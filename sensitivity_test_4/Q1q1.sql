SELECT
  cal.cal_day_of_week_name,
  DATE_PART('hour', conv.c_contact_connected_datetime) AS hour_of_day,
  COUNT(
    DISTINCT CASE
      WHEN conv.c_direction_original = 'inbound' THEN conv.identifier
    END
  ) AS inbound_contacts
FROM
  conv AS conv
  LEFT OUTER JOIN cale AS cal ON conv.contact_connected_date = cal.date_day
WHERE
  NOT conv.c_contact_connected_datetime IS NULL
GROUP BY
  cal.cal_day_of_week_name,
  hour_of_day
ORDER BY
  inbound_contacts DESC NULLS LAST