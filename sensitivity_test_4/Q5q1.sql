WITH contacts_by_weekday_hour AS (
  SELECT
    *
  FROM
    SEMANTIC_VIEW(
      PROD.ANALYTICS.SEM_VERBOSE METRICS total_contacts DIMENSIONS cal_day_of_week_name,
      DATE_PART('hour', conv.c_contact_connected_datetime) AS hour_of_day
    )
),
peak_hours AS (
  SELECT
    cal_day_of_week_name,
    hour_of_day,
    total_contacts,
    RANK() OVER (
      PARTITION BY cal_day_of_week_name
      ORDER BY
        total_contacts DESC NULLS LAST
    ) AS rnk
  FROM
    contacts_by_weekday_hour
)
SELECT
  c.cal_day_of_week_name,
  c.hour_of_day,
  c.total_contacts,
  CASE
    WHEN p.rnk = 1 THEN TRUE
    ELSE FALSE
  END AS is_peak_hour
FROM
  contacts_by_weekday_hour AS c
  LEFT JOIN peak_hours AS p ON c.cal_day_of_week_name = p.cal_day_of_week_name
  AND c.hour_of_day = p.hour_of_day
  AND p.rnk = 1
ORDER BY
  c.cal_day_of_week_name,
  c.hour_of_day NULLS LAST;