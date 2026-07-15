-- Gold layer: date dimension table (calendar reference)
-- Generated programmatically to cover the full range of dates in our dataset
-- (2025-2030, giving a safety buffer around the actual data range which
-- extends into 2029 due to the synthetic future-dating issue documented earlier)

CREATE OR REPLACE TABLE dim_date AS
SELECT
    d::DATE AS date_key,
    EXTRACT(YEAR FROM d) AS year,
    EXTRACT(MONTH FROM d) AS month,
    EXTRACT(QUARTER FROM d) AS quarter,
    EXTRACT(DOW FROM d) AS day_of_week,
    STRFTIME(d, '%A') AS day_name,
    STRFTIME(d, '%B') AS month_name
FROM generate_series(DATE '2025-01-01', DATE '2030-12-31', INTERVAL 1 DAY) AS t(d);