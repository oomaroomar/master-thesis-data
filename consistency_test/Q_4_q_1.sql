-- 10/10. Incorrect, should be direction = inbound, not direction_original
SELECT
  cal.cal_day_of_week_name,
  DATE_PART('hour', conv.c_contact_connected_datetime) AS hour_of_day,
  COUNT(DISTINCT conv.identifier) AS total_contacts
FROM
  conv AS conv
  LEFT OUTER JOIN cale AS cal ON conv.contact_connected_date = cal.date_day
WHERE
  conv.c_direction_original = 'inbound'
GROUP BY
  cal.cal_day_of_week_name,
  hour_of_day
ORDER BY
  CASE
    cal.cal_day_of_week_name
    WHEN 'Sunday' THEN 0
    WHEN 'Monday' THEN 1
    WHEN 'Tuesday' THEN 2
    WHEN 'Wednesday' THEN 3
    WHEN 'Thursday' THEN 4
    WHEN 'Friday' THEN 5
    WHEN 'Saturday' THEN 6
  END,
  hour_of_day
