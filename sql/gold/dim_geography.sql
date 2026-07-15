-- Gold layer: geography dimension table
-- Loaded from external Excel reference file (data/raw/Module_2_raw__geography--.xlsx)
-- Fixes applied:
--   1. Standardized country_code casing with UPPER() (raw had mixed case, e.g. 'de')
--   2. Trimmed whitespace with TRIM() (raw had trailing spaces, e.g. 'NL ')
--   3. Removed duplicate row (France appeared twice, identical data)

CREATE OR REPLACE TABLE dim_geography AS
SELECT DISTINCT
    UPPER(TRIM(country_code)) AS country_code,
    country_name,
    region,
    market,
    currency,
    sales_region
FROM raw__geography;