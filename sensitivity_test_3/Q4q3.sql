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
totals AS (
  SELECT
    COUNT(DISTINCT identifier) AS total_sla_answered,
    COUNT(
      DISTINCT CASE
        WHEN c_contact_closed_reason = 'peer' THEN identifier
      END
    ) AS customer_closed,
    COUNT(
      DISTINCT CASE
        WHEN c_contact_closed_reason = 'client' THEN identifier
      END
    ) AS agent_closed
  FROM
    sla_answered
)
SELECT
  total_sla_answered,
  customer_closed,
  agent_closed,
  customer_closed / NULLIF(NULLIF(total_sla_answered, 0), 0) AS customer_closed_proportion,
  agent_closed / NULLIF(NULLIF(total_sla_answered, 0), 0) AS agent_closed_proportion
FROM
  totals

