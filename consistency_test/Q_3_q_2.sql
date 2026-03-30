-- 3/10. Incorrect, swaps Agents and Customers
WITH sl_contacts AS (
  SELECT
    DISTINCT conv.identifier,
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
  ) AS closed_by_customer,
  COUNT(
    DISTINCT CASE
      WHEN c_contact_closed_reason = 'client' THEN identifier
    END
  ) AS closed_by_agent,
  COUNT(DISTINCT identifier) AS total_sl_contacts,
  COUNT(
    DISTINCT CASE
      WHEN c_contact_closed_reason = 'peer' THEN identifier
    END
  ) / NULLIF(NULLIF(COUNT(DISTINCT identifier), 0), 0) AS pct_closed_by_customer,
  COUNT(
    DISTINCT CASE
      WHEN c_contact_closed_reason = 'client' THEN identifier
    END
  ) / NULLIF(NULLIF(COUNT(DISTINCT identifier), 0), 0) AS pct_closed_by_agent
FROM
  sl_contacts
