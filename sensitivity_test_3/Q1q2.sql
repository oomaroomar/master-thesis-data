WITH sl_answered AS (
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
),
total AS (
  SELECT
    COUNT(DISTINCT identifier) AS total_sl_answered
  FROM
    sl_answered
)
SELECT
  sl.c_contact_closed_reason,
  COUNT(DISTINCT sl.identifier) AS contact_count,
  COUNT(DISTINCT sl.identifier) / NULLIF(NULLIF(t.total_sl_answered, 0), 0) AS share
FROM
  sl_answered AS sl
  CROSS JOIN total AS t
GROUP BY
  sl.c_contact_closed_reason,
  t.total_sl_answered
ORDER BY
  contact_count DESC NULLS LAST
