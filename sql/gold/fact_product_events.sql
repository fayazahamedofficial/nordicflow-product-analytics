-- Gold layer: product events fact table
-- One row per user action, with foreign keys to dim_users, dim_accounts, dim_geography, dim_date
-- Dropped columns:
--   is_test_event - constant (always false) since bronze already filters test events out
--   event_properties - miscellaneous field, no clear business need identified yet
--   ingested_at - pipeline metadata, not a business fact about the event itself
-- country_code standardized to match dim_geography

CREATE OR REPLACE TABLE fact_product_events AS
SELECT
    event_id,
    user_id,
    account_id,
    deal_id,
    event_name,
    event_date,
    event_timestamp,
    platform,
    device_type,
    TRIM(UPPER(country_code)) AS country_code,
    source_system,
    app_version
FROM bronze__product_events;