-- Gold layer: users dimension table
-- Descriptive attributes about each user, for joining to fact tables

CREATE OR REPLACE TABLE dim_users AS
SELECT
    user_id,
    account_id,
    full_name,
    email,
    job_role,
    user_status,
    is_admin,
    locale,
    timezone,
    created_at AS signup_date
FROM bronze__users;