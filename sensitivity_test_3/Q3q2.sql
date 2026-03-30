WITH within_sl AS (
  SELECT
    conv.identifier,
    conv.c_contact_closed_reason
  FROM
    conv AS conv
    LEFT OUTER JOIN queu AS queu ON conv.queueid = queu.id
  WHERE
    conv.c_answered = 1
    AND conv.c_direction_original = 'inbound'
    AND conv.queue_duration <= queu.q_call_service_level_duration_seconds
),
closure_counts AS (
  SELECT
    COUNT(DISTINCT identifier) AS total_within_sl,
    COUNT(
      DISTINCT CASE
        WHEN c_contact_closed_reason = 'peer' THEN identifier
      END
    ) AS closed_by_customer,
    COUNT(
      DISTINCT CASE
        WHEN c_contact_closed_reason = 'client' THEN identifier
      END
    ) AS closed_by_agent
  FROM
    within_sl
)
SELECT
  total_within_sl,
  closed_by_customer,
  closed_by_agent,
  closed_by_customer / NULLIF(NULLIF(total_within_sl, 0), 0) AS pct_closed_by_customer,
  closed_by_agent / NULLIF(NULLIF(total_within_sl, 0), 0) AS pct_closed_by_agent
FROM
  closure_counts
