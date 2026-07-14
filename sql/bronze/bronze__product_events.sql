-- Bronze layer: cleaned version of raw__product_events
-- Fixes applied:
--   1. Standardized event_name casing AND naming variants
--      (login/Login/user_login -> login; view_dashboard/ViewDashboard -> view_dashboard)
--   2. Filtered out all rows where is_test_event = true (fake/test data)
--   3. Filtered out events with event_timestamp before the user's own signup date
--      (found ~45% of events had impossible timestamps - a synthetic data generation flaw
--      where events and user signup dates were generated independently of each other)

CREATE OR REPLACE VIEW bronze__product_events AS
SELECT
    e.event_id,
    e.user_id,
    e.account_id,
    e.deal_id,
    CASE
        WHEN LOWER(e.event_name) IN ('login', 'user_login') THEN 'login'
        WHEN LOWER(e.event_name) = 'viewdashboard' THEN 'view_dashboard'
        ELSE LOWER(e.event_name)
    END AS event_name,
    e.event_date,
    e.event_timestamp,
    e.platform,
    e.device_type,
    e.country_code,
    e.event_properties,
    e.is_test_event,
    e.source_system,
    e.app_version,
    e.ingested_at
FROM raw__product_events e
INNER JOIN raw__users u ON e.user_id = u.user_id
WHERE e.is_test_event = false
  AND e.event_timestamp >= u.created_at;