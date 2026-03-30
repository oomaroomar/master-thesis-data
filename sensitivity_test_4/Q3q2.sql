WITH hourly_contacts AS (
  SELECT
    cal.cal_day_of_week_name,
    DATE_PART(HOUR, conv.c_contact_connected_datetime) AS hour_of_day,
    COUNT(
      DISTINCT CASE
        WHEN conv.c_direction_original = 'inbound' THEN conv.identifier
      END
    ) AS inbound_contacts,
    COUNT(DISTINCT conv.identifier) AS total_contacts
  FROM
    conv AS conv
    LEFT OUTER JOIN cale AS cal ON conv.contact_connected_date = cal.date_day
  WHERE
    NOT conv.c_contact_connected_datetime IS NULL
  GROUP BY
    cal.cal_day_of_week_name,
    DATE_PART(HOUR, conv.c_contact_connected_datetime)
)
SELECT
  cal_day_of_week_name,
  hour_of_day,
  inbound_contacts,
  total_contacts,
  SUM(inbound_contacts) OVER (PARTITION BY cal_day_of_week_name) AS total_inbound_for_weekday,
  ROUND(
    inbound_contacts / NULLIF(
      NULLIF(
        SUM(inbound_contacts) OVER (PARTITION BY cal_day_of_week_name),
        0
      ),
      0
    ),
    4
  ) AS pct_of_weekday_inbound
FROM
  hourly_contacts
ORDER BY
  CASE
    cal_day_of_week_name
    WHEN 'Monday' THEN 1
    WHEN 'Tuesday' THEN 2
    WHEN 'Wednesday' THEN 3
    WHEN 'Thursday' THEN 4
    WHEN 'Friday' THEN 5
    WHEN 'Saturday' THEN 6
    WHEN 'Sunday' THEN 7
    ELSE 8
  END,
  hour_of_day