-- Gold layer: accounts dimension table
-- Descriptive attributes about each customer account, for joining to fact tables

CREATE OR REPLACE TABLE dim_accounts AS
SELECT
    account_id,
    account_name,
    country_code,
    city,
    industry,
    employee_band,
    segment,
    created_at,
    trial_start_date,
    trial_end_date,
    account_status,
    acquisition_channel
FROM bronze__accounts;