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
unique_contacts AS (
  SELECT
    DISTINCT identifier,
    c_contact_closed_reason
  FROM
    within_sl
),
totals AS (
  SELECT
    COUNT(identifier) AS total_contacts,
    SUM(
      CASE
        WHEN c_contact_closed_reason = 'peer' THEN 1
        ELSE 0
      END
    ) AS closed_by_customer,
    SUM(
      CASE
        WHEN c_contact_closed_reason = 'client' THEN 1
        ELSE 0
      END
    ) AS closed_by_agent,
    SUM(
      CASE
        WHEN NOT c_contact_closed_reason IN ('peer', 'client')
        OR c_contact_closed_reason IS NULL THEN 1
        ELSE 0
      END
    ) AS closed_other
  FROM
    unique_contacts
)
SELECT
  total_contacts,
  closed_by_customer,
  closed_by_agent,
  closed_other,
  closed_by_customer / NULLIF(NULLIF(total_contacts, 0), 0) AS pct_closed_by_customer,
  closed_by_agent / NULLIF(NULLIF(total_contacts, 0), 0) AS pct_closed_by_agent,
  closed_other / NULLIF(NULLIF(total_contacts, 0), 0) AS pct_closed_other
FROM
  totals
