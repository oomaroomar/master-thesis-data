-- 10/10. Correct
SELECT
  COUNT(*) AS total_contacts
FROM
  conv AS conv
  LEFT OUTER JOIN cale AS cale ON conv.contact_connected_date = cale.date_day
WHERE
  cale.cal_year_number = 2026
  AND cale.cal_month_of_year = 1  
