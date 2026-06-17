/*
Project: Cumulative Revenue vs Forecast

Business task:
Compare cumulative actual revenue with cumulative forecasted revenue
over time and calculate the percentage of the revenue goal achieved
for each date.

Skills demonstrated:
JOIN, UNION ALL, aggregation, window functions,
cumulative sums and NULLIF.
*/

WITH combined_data AS (
  SELECT
    rp.date,
    0 AS revenue,
    SUM(rp.predict) AS predict
  FROM `data-analytics-mate.DA.revenue_predict` AS rp
  GROUP BY rp.date

  UNION ALL

  SELECT
    s.date,
    SUM(p.price) AS revenue,
    0 AS predict
  FROM `data-analytics-mate.DA.order` AS o
  INNER JOIN `data-analytics-mate.DA.product` AS p
    ON o.item_id = p.item_id
  INNER JOIN `data-analytics-mate.DA.session` AS s
    ON o.ga_session_id = s.ga_session_id
  GROUP BY s.date
),

daily_totals AS (
  SELECT
    date,
    SUM(revenue) AS daily_revenue,
    SUM(predict) AS daily_predict
  FROM combined_data
  GROUP BY date
),

cumulative_totals AS (
  SELECT
    date,
    SUM(daily_revenue) OVER (
      ORDER BY date
    ) AS cumulative_revenue,
    SUM(daily_predict) OVER (
      ORDER BY date
    ) AS cumulative_predict
  FROM daily_totals
)

SELECT
  date,
  cumulative_revenue,
  cumulative_predict,
  cumulative_revenue / NULLIF(cumulative_predict, 0) * 100
    AS revenue_goal_percent
FROM cumulative_totals
ORDER BY date;
