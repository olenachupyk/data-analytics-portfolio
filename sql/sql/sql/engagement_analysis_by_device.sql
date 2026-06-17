/*
Project: Engagement Analysis by Device

Business task:
Analyze user engagement across device categories by calculating
the share of events associated with engaged sessions.

Skills demonstrated:
CTE, UNNEST, nested event parameters, JOIN,
CASE WHEN, aggregation, percentage calculation.
*/

WITH event_data AS (
  SELECT
    ep.ga_session_id,
    ep.event_name,
    params.value.string_value AS session_engaged
  FROM `data-analytics-mate.DA.event_params` AS ep,
  UNNEST(ep.event_params) AS params
  WHERE params.key = 'session_engaged'
    AND params.value.string_value IS NOT NULL
)

SELECT
  sp.device,
  COUNT(
    CASE
      WHEN ed.session_engaged = '1' THEN ed.event_name
    END
  ) AS engaged_events_count,
  COUNT(ed.event_name) AS total_events_with_session_engaged,
  COUNT(
    CASE
      WHEN ed.session_engaged = '1' THEN ed.event_name
    END
  ) * 100.0 / NULLIF(COUNT(ed.event_name), 0)
    AS engaged_events_percent
FROM event_data AS ed
INNER JOIN `data-analytics-mate.DA.session_params` AS sp
  ON ed.ga_session_id = sp.ga_session_id
GROUP BY sp.device
ORDER BY engaged_events_percent DESC;
