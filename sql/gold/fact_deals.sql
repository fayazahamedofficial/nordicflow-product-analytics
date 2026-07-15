-- Gold layer: deals fact table
-- One row per deal, with foreign keys to dim_accounts, dim_users, dim_geography, dim_date
-- country_code standardized to match dim_geography

CREATE OR REPLACE TABLE fact_deals AS
SELECT
    deal_id,
    account_id,
    owner_user_id,
    pipeline_id,
    current_stage_id,
    status,
    created_at,
    closed_at,
    last_stage_changed_at,
    amount,
    currency,
    TRIM(UPPER(country_code)) AS country_code,
    source_system
FROM bronze__deals;