SELECT
  COUNT(
    DISTINCT CASE
      WHEN conv.c_answered = 1
      AND conv.c_direction_original = 'inbound'
      AND conv.c_media_type IN ('call', 'voice')
      AND conv.c_direction = 'inbound' THEN conv.identifier
    END
  ) AS answered_contacts,
  COUNT(
    DISTINCT CASE
      WHEN conv.c_direction_original = 'inbound'
      AND conv.c_media_type IN ('call', 'voice')
      AND conv.c_direction = 'inbound' THEN conv.identifier
    END
  ) AS inbound_contacts,
  SUM(
    CASE
      WHEN conv.queue_duration <= 0
      AND conv.c_answered = 0
      AND conv.c_direction_original = 'inbound'
      AND conv.c_media_type IN ('call', 'voice')
      AND conv.c_direction = 'inbound' THEN 1
      ELSE 0
    END
  ) AS short_abandons,
  COUNT(
    DISTINCT CASE
      WHEN conv.c_answered = 1
      AND conv.c_direction_original = 'inbound'
      AND conv.c_media_type IN ('call', 'voice')
      AND conv.c_direction = 'inbound' THEN conv.identifier
    END
  ) / NULLIF(
    NULLIF(
      (
        COUNT(
          DISTINCT CASE
            WHEN conv.c_direction_original = 'inbound'
            AND conv.c_media_type IN ('call', 'voice')
            AND conv.c_direction = 'inbound' THEN conv.identifier
          END
        ) - SUM(
          CASE
            WHEN conv.queue_duration <= 0
            AND conv.c_answered = 0
            AND conv.c_direction_original = 'inbound'
            AND conv.c_media_type IN ('call', 'voice')
            AND conv.c_direction = 'inbound' THEN 1
            ELSE 0
          END
        )
      ),
      0
    ),
    0
  ) AS answer_percentage
FROM
  conv AS conv
  LEFT OUTER JOIN cale AS cale ON conv.contact_connected_date = cale.date_day
WHERE
  cale.cal_year_number = 2026
  AND cale.cal_month_of_year = 2
