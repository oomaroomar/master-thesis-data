WITH hourly_contacts AS (
  SELECT
    cal.cal_day_of_week_name,
    HOUR(conv.c_contact_connected_datetime) AS hour_of_day,
    COUNT(
      DISTINCT CASE
        WHEN conv.c_direction_original = 'inbound' THEN conv.identifier
      END
    ) AS total_inbound_contacts
  FROM
    conv AS conv
    LEFT OUTER JOIN cale AS cal ON conv.contact_connected_date = cal.date_day
  WHERE
    NOT conv.c_contact_connected_datetime IS NULL
  GROUP BY
    cal.cal_day_of_week_name,
    HOUR(conv.c_contact_connected_datetime)
),
peak_hours AS (
  SELECT
    cal_day_of_week_name,
    MAX(total_inbound_contacts) AS peak_contacts
  FROM
    hourly_contacts
  GROUP BY
    cal_day_of_week_name
)
SELECT
  hc.cal_day_of_week_name,
  hc.hour_of_day,
  hc.total_inbound_contacts,
  CASE
    WHEN hc.total_inbound_contacts = ph.peak_contacts THEN TRUE
    ELSE FALSE
  END AS is_peak_hour
FROM
  hourly_contacts AS hc
  LEFT JOIN peak_hours AS ph ON hc.cal_day_of_week_name = ph.cal_day_of_week_name
ORDER BY
  CASE
    WHEN hc.cal_day_of_week_name = 'Monday' THEN 1
    WHEN hc.cal_day_of_week_name = 'Tuesday' THEN 2
    WHEN hc.cal_day_of_week_name = 'Wednesday' THEN 3
    WHEN hc.cal_day_of_week_name = 'Thursday' THEN 4
    WHEN hc.cal_day_of_week_name = 'Friday' THEN 5
    WHEN hc.cal_day_of_week_name = 'Saturday' THEN 6
    WHEN hc.cal_day_of_week_name = 'Sunday' THEN 7
    ELSE 8
  END,
  hc.hour_of_day