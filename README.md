# data-analytics-portfolio
Data analytics portfolio featuring projects in SQL, Python, Tableau, spreadsheets, and A/B testing.
# Data Analytics Portfolio

Welcome to my data analytics portfolio.

This repository contains SQL projects completed during my Data Analytics studies. The projects demonstrate my ability to work with relational and nested data, calculate business metrics, analyze user behavior, and prepare datasets for reporting and visualization.

## Skills

* SQL
* Google BigQuery
* CTEs and subqueries
* JOIN and UNION ALL
* Window functions
* Data aggregation
* Ranking and segmentation
* Date calculations
* Nested data and UNNEST
* Business metrics analysis

## SQL Projects

### 1. Country Email Performance Analysis

Analyzes account creation and email campaign activity by country.

The query calculates:

* number of created accounts;
* sent emails;
* opened emails;
* website visits;
* country rankings by account and email volume.

**SQL skills:** CTE, JOIN, UNION ALL, COUNT DISTINCT, DENSE_RANK, window functions.

[View SQL query](sql/country_email_performance_analysis.sql)

---

### 2. Cumulative Revenue vs Forecast

Compares cumulative actual revenue with cumulative forecasted revenue over time.

The query calculates:

* daily revenue;
* daily forecast;
* cumulative revenue;
* cumulative forecast;
* percentage of the revenue goal achieved.

**SQL skills:** JOIN, UNION ALL, aggregation, window functions, cumulative sums, NULLIF.

[View SQL query](sql/cumulative_revenue_vs_forecast.sql)

---

### 3. Engagement Analysis by Device

Analyzes user engagement across different device categories.

The query extracts nested event parameters and calculates the share of events associated with engaged sessions.

**SQL skills:** CTE, UNNEST, nested data, JOIN, CASE WHEN, percentage calculation.

[View SQL query](sql/engagement_analysis_by_device.sql)

---

### 4. Email Lifecycle Analysis

Reconstructs the lifecycle of each email message.

The query calculates:

* email sending date;
* first opening date;
* first website visit date.

This analysis helps evaluate user movement through the email funnel.

**SQL skills:** CTE, INNER JOIN, LEFT JOIN, MIN, aggregation, date calculations.

[View SQL query](sql/email_lifecycle_analysis.sql)

## Tools

* Google BigQuery
* SQL
* GitHub
* Google Sheets
* Python
* Tableau

## About Me

I am developing my skills in data analytics and working with SQL, Python, spreadsheets, and data visualization tools.

My goal is to transform raw data into clear insights that support business decisions.
