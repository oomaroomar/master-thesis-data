WITH sla_answered AS (
  SELECT
    conv.identifier,
    conv.c_contact_closed_reason
  FROM
    conv AS conv
    LEFT OUTER JOIN queu AS queu ON conv.queueid = queu.id
  WHERE
    conv.c_answered = 1
    AND conv.c_direction_original = 'inbound'
    AND conv.c_media_type IN ('call', 'voice')
    AND conv.c_direction = 'inbound'
    AND conv.queue_duration <= queu.q_call_service_level_duration_seconds
),
unique_contacts AS (
  SELECT
    DISTINCT identifier,
    c_contact_closed_reason
  FROM
    sla_answered
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
  COUNT(DISTINCT identifier) AS total_sla_answered,
  COUNT(
    DISTINCT CASE
      WHEN c_contact_closed_reason = 'peer' THEN identifier
    END
  ) / NULLIF(NULLIF(COUNT(DISTINCT identifier), 0), 0) AS customer_closed_proportion,
  COUNT(
    DISTINCT CASE
      WHEN c_contact_closed_reason = 'client' THEN identifier
    END
  ) / NULLIF(NULLIF(COUNT(DISTINCT identifier), 0), 0) AS agent_closed_proportion
FROM
  unique_contacts

