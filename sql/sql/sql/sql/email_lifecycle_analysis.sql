/*
Project: Email Lifecycle Analysis

Business task:
Reconstruct the lifecycle of each email message by calculating
the actual sending date, first opening date, and first website visit date
relative to the account registration date.

Skills demonstrated:
JOIN, LEFT JOIN, subqueries, aggregation,
MIN, date calculations, email funnel analysis.
*/

WITH account_registration AS (
  SELECT
    acs.account_id,
    MIN(s.date) AS registration_date
  FROM `data-analytics-mate.DA.account_session` AS acs
  INNER JOIN `data-analytics-mate.DA.session` AS s
    ON acs.ga_session_id = s.ga_session_id
  GROUP BY acs.account_id
),

first_open AS (
  SELECT
    id_message,
    MIN(open_date) AS first_open_day
  FROM `data-analytics-mate.DA.email_open`
  GROUP BY id_message
),

first_visit AS (
  SELECT
    id_message,
    MIN(visit_date) AS first_visit_day
  FROM `data-analytics-mate.DA.email_visit`
  GROUP BY id_message
)

SELECT
  es.id_account,
  es.id_message,
  DATE_ADD(ar.registration_date, INTERVAL es.sent_date DAY) AS sent_date,
  DATE_ADD(ar.registration_date, INTERVAL fo.first_open_day DAY) AS first_open_date,
  DATE_ADD(ar.registration_date, INTERVAL fv.first_visit_day DAY) AS first_visit_date
FROM `data-analytics-mate.DA.email_sent` AS es
INNER JOIN account_registration AS ar
  ON es.id_account = ar.account_id
LEFT JOIN first_open AS fo
  ON es.id_message = fo.id_message
LEFT JOIN first_visit AS fv
  ON es.id_message = fv.id_message
ORDER BY sent_date, es.id_message;
