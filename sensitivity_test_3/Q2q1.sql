WITH resolved_within_sl AS (
  SELECT
    conv.identifier,
    conv.c_contact_closed_reason
  FROM
    conv AS conv
    LEFT OUTER JOIN queu AS queu ON conv.queueid = queu.id
  WHERE
    conv.c_answered = 1
    AND conv.c_direction = 'inbound'
    AND conv.c_media_type IN ('call', 'voice')
    AND conv.queue_duration <= queu.q_call_service_level_duration_seconds
)
SELECT
  COUNT(
    DISTINCT CASE
      WHEN c_contact_closed_reason = 'peer' THEN identifier
    END
  ) AS customer_closed_count,
  COUNT(
    DISTINCT CASE
      WHEN c_contact_closed_reason = 'client' THEN identifier
    END
  ) AS agent_closed_count,
  COUNT(DISTINCT identifier) AS total_resolved_within_sl,
  COUNT(
    DISTINCT CASE
      WHEN c_contact_closed_reason = 'peer' THEN identifier
    END
  ) / NULLIF(NULLIF(COUNT(DISTINCT identifier), 0), 0) AS customer_closed_pct,
  COUNT(
    DISTINCT CASE
      WHEN c_contact_closed_reason = 'client' THEN identifier
    END
  ) / NULLIF(NULLIF(COUNT(DISTINCT identifier), 0), 0) AS agent_closed_pct
FROM
  resolved_within_sl
