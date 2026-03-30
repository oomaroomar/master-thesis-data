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
)
SELECT
  c_contact_closed_reason,
  COUNT(DISTINCT identifier) AS contact_count,
  COUNT(DISTINCT identifier) / NULLIF(
    NULLIF(SUM(COUNT(DISTINCT identifier)) OVER (), 0),
    0
  ) AS share
FROM
  sl_answered
WHERE
  c_contact_closed_reason IN ('client', 'peer')
GROUP BY
  c_contact_closed_reason
ORDER BY
  contact_count DESC NULLS LAST
