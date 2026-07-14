-- Silver layer: user activation calculation
-- Business logic: a user is "activated" if they performed at least one core action
-- (create_deal, log_activity, move_deal_stage, enable_automation, invite_user)
-- within 14 days of their own signup date.
-- Only includes users whose 14-day window has fully elapsed as of the dataset's
-- latest date (2029-12-30), per our data quality decision to anchor "today" to
-- the dataset's own MAX date rather than the real-world calendar date.

CREATE OR REPLACE VIEW silver__user_activation AS
WITH first_core_action AS (
    SELECT
        user_id,
        MIN(event_timestamp) AS first_core_action_at
    FROM bronze__product_events
    WHERE event_name IN ('create_deal', 'log_activity', 'move_deal_stage', 'enable_automation', 'invite_user')
    GROUP BY user_id
)
SELECT
    u.user_id,
    u.account_id,
    u.created_at AS signup_date,
    f.first_core_action_at,
    CASE
        WHEN f.first_core_action_at IS NOT NULL
             AND f.first_core_action_at <= u.created_at + INTERVAL 14 DAY
        THEN true
        ELSE false
    END AS is_activated
FROM bronze__users u
LEFT JOIN first_core_action f ON u.user_id = f.user_id
WHERE u.created_at <= DATE '2029-12-30' - INTERVAL 14 DAY;