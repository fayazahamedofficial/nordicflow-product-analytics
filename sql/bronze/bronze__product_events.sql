-- Bronze layer: cleaned version of raw__product_events
-- Fixes applied:
--   1. Standardized event_name casing AND naming variants
--      (login/Login/user_login -> login; view_dashboard/ViewDashboard -> view_dashboard)
--   2. Filtered out all rows where is_test_event = true (fake/test data)

CREATE OR REPLACE VIEW bronze__product_events AS
SELECT
    event_id,
    user_id,
    account_id,
    deal_id,
    CASE
        WHEN LOWER(event_name) IN ('login', 'user_login') THEN 'login'
        WHEN LOWER(event_name) = 'viewdashboard' THEN 'view_dashboard'
        ELSE LOWER(event_name)
    END AS event_name,
    event_date,
    event_timestamp,
    platform,
    device_type,
    country_code,
    event_properties,
    is_test_event,
    source_system,
    app_version,
    ingested_at
FROM raw__product_events
WHERE is_test_event = false;