WITH daily_metrics AS (
  SELECT
    cal.cal_date_day,
    COUNT(
      DISTINCT CASE
        WHEN conv.c_answered = 1
        AND conv.c_direction_original = 'inbound'
        AND conv.c_media_type IN ('call', 'voice')
        AND conv.c_direction = 'inbound' THEN conv.identifier
      END
    ) AS answered,
    COUNT(
      DISTINCT CASE
        WHEN conv.c_direction_original = 'inbound'
        AND conv.c_media_type IN ('call', 'voice')
        AND conv.c_direction = 'inbound' THEN conv.identifier
      END
    ) AS inbound,
    SUM(
      CASE
        WHEN conv.queue_duration <= 0
        AND conv.c_answered = 0
        AND conv.c_direction_original = 'inbound'
        AND conv.c_media_type IN ('call', 'voice')
        AND conv.c_direction = 'inbound' THEN 1
        ELSE 0
      END
    ) AS short_abandons
  FROM
    conv AS conv
    LEFT OUTER JOIN cale AS cal ON conv.contact_connected_date = cal.date_day
  WHERE
    cal.cal_year_number = 2026
    AND cal.cal_month_of_year = 2
  GROUP BY
    cal.cal_date_day
)
SELECT
  cal_date_day,
  answered,
  inbound,
  short_abandons,
  answered / NULLIF(NULLIF((inbound - short_abandons), 0), 0) AS answer_rate
FROM
  daily_metrics
ORDER BY
  cal_date_day ASC
