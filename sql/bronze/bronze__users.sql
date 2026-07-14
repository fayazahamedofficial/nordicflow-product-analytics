-- Bronze layer: cleaned version of raw__users
-- Fixes applied:
--   1. Removed exact duplicate rows (if any)
--   2. Standardized user_status casing using LOWER()

CREATE OR REPLACE VIEW bronze__users AS
SELECT DISTINCT
    user_id,
    account_id,
    full_name,
    email,
    job_role,
    LOWER(user_status) AS user_status,
    created_at,
    last_seen_at,
    timezone,
    locale,
    is_admin
FROM raw__users;