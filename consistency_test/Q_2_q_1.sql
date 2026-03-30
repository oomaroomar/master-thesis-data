-- 9/10. Correct
SELECT
  *
FROM
  SEMANTIC_VIEW(
    PROD.ANALYTICS.SEM_VERBOSE METRICS answer_percentage
    WHERE
      conv.c_media_type IN ('call', 'voice')
      AND conv.c_direction_original = 'inbound'
      AND conv.c_contact_connected_datetime >= '2026-02-01'
      AND conv.c_contact_connected_datetime < '2026-03-01'
  ) 
