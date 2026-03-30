SELECT
  COUNT(
    DISTINCT CASE
      WHEN conv.c_answered = 1
      AND conv.c_direction_original = 'inbound' THEN conv.identifier
    END
  ) AS answered_contacts
FROM
  conv AS conv
  LEFT OUTER JOIN cale AS cale ON conv.contact_connected_date = cale.date_day
WHERE
  cale.cal_year_number = 2026
  AND cale.cal_month_of_year = 1
