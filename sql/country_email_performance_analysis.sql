/*
Project: Country Email Performance Analysis

Business task:
Analyze account creation and email campaign activity by country.
Calculate the number of created accounts, sent emails, opened emails,
and website visits. Rank countries by the total number of accounts
and sent messages, and return countries included in the top 10
by at least one of these metrics.

Skills demonstrated:
CTE, JOIN, UNION ALL, aggregation, COUNT DISTINCT,
date calculations, window functions, DENSE_RANK.
*/

WITH account_base AS (
  SELECT
    a.id AS account_id,
    s.date AS created_date,
    sp.country,
    a.send_interval,
    a.is_verified,
    a.is_unsubscribed
  FROM `data-analytics-mate.DA.account` AS a
  INNER JOIN `data-analytics-mate.DA.account_session` AS acs
    ON a.id = acs.account_id
  INNER JOIN `data-analytics-mate.DA.session` AS s
    ON acs.ga_session_id = s.ga_session_id
  INNER JOIN `data-analytics-mate.DA.session_params` AS sp
    ON acs.ga_session_id = sp.ga_session_id
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY a.id
    ORDER BY s.date
  ) = 1
),

account_metrics AS (
  SELECT
    created_date AS date,
    country,
    send_interval,
    is_verified,
    is_unsubscribed,
    COUNT(DISTINCT account_id) AS account_cnt,
    0 AS sent_msg,
    0 AS open_msg,
    0 AS visit_msg
  FROM account_base
  GROUP BY
    date,
    country,
    send_interval,
    is_verified,
    is_unsubscribed
),

email_metrics AS (
  SELECT
    DATE_ADD(ab.created_date, INTERVAL es.sent_date DAY) AS date,
    ab.country,
    ab.send_interval,
    ab.is_verified,
    ab.is_unsubscribed,
    0 AS account_cnt,
    COUNT(DISTINCT es.id_message) AS sent_msg,
    COUNT(DISTINCT eo.id_message) AS open_msg,
    COUNT(DISTINCT ev.id_message) AS visit_msg
  FROM `data-analytics-mate.DA.email_sent` AS es
  INNER JOIN account_base AS ab
    ON es.id_account = ab.account_id
  LEFT JOIN `data-analytics-mate.DA.email_open` AS eo
    ON es.id_message = eo.id_message
  LEFT JOIN `data-analytics-mate.DA.email_visit` AS ev
    ON es.id_message = ev.id_message
  GROUP BY
    date,
    country,
    send_interval,
    is_verified,
    is_unsubscribed
),

combined_metrics AS (
  SELECT * FROM account_metrics
  UNION ALL
  SELECT * FROM email_metrics
),

daily_metrics AS (
  SELECT
    date,
    country,
    send_interval,
    is_verified,
    is_unsubscribed,
    SUM(account_cnt) AS account_cnt,
    SUM(sent_msg) AS sent_msg,
    SUM(open_msg) AS open_msg,
    SUM(visit_msg) AS visit_msg
  FROM combined_metrics
  GROUP BY
    date,
    country,
    send_interval,
    is_verified,
    is_unsubscribed
),

country_totals AS (
  SELECT
    country,
    SUM(account_cnt) AS total_country_account_cnt,
    SUM(sent_msg) AS total_country_sent_cnt
  FROM daily_metrics
  GROUP BY country
),

country_rankings AS (
  SELECT
    country,
    total_country_account_cnt,
    total_country_sent_cnt,
    DENSE_RANK() OVER (
      ORDER BY total_country_account_cnt DESC
    ) AS account_rank,
    DENSE_RANK() OVER (
      ORDER BY total_country_sent_cnt DESC
    ) AS sent_messages_rank
  FROM country_totals
)

SELECT
  dm.date,
  dm.country,
  dm.send_interval,
  dm.is_verified,
  dm.is_unsubscribed,
  dm.account_cnt,
  dm.sent_msg,
  dm.open_msg,
  dm.visit_msg,
  cr.total_country_account_cnt,
  cr.total_country_sent_cnt,
  cr.account_rank,
  cr.sent_messages_rank
FROM daily_metrics AS dm
INNER JOIN country_rankings AS cr
  ON dm.country = cr.country
WHERE cr.account_rank <= 10
   OR cr.sent_messages_rank <= 10
ORDER BY
  dm.date,
  dm.country,
  dm.send_interval,
  dm.is_verified,
  dm.is_unsubscribed;
