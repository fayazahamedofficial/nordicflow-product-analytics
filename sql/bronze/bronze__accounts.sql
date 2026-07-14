-- Bronze layer: cleaned version of raw__accounts
-- Fixes applied:
--   1. Removed exact duplicate rows (if any)
--   2. Standardized account_status casing using LOWER()

CREATE OR REPLACE VIEW bronze__accounts AS
SELECT DISTINCT
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
    LOWER(account_status) AS account_status,
    acquisition_channel
FROM raw__accounts;