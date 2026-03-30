SELECT
  *
FROM
  SEMANTIC_VIEW(
    PROD.ANALYTICS.SEM_VERBOSE METRICS answer_percentage
    WHERE
      c_direction_original = 'inbound'
      AND c_media_type IN ('call', 'voice')
      AND c_contact_connected_datetime >= '2026-02-01'
      AND c_contact_connected_datetime < '2026-03-01'
  )
