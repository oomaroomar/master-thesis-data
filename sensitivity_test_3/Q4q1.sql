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
closure_counts AS (
  SELECT
    c_contact_closed_reason,
    COUNT(DISTINCT identifier) AS contact_count
  FROM
    sla_answered
  GROUP BY
    c_contact_closed_reason
),
total AS (
  SELECT
    SUM(contact_count) AS total_count
  FROM
    closure_counts
)
SELECT
  cc.c_contact_closed_reason,
  cc.contact_count,
  t.total_count,
  cc.contact_count / NULLIF(NULLIF(t.total_count, 0), 0) AS proportion
FROM
  closure_counts AS cc
  CROSS JOIN total AS t
ORDER BY
  cc.contact_count DESC NULLS LAST

