-- Gold layer: user engagement summary (ORIGINAL TABLE - beyond tutorial scope)
-- One row per user, combining activation status, churn status, raw engagement
-- metrics, and account attributes (industry, segment, employee_band).
--
-- UPDATE: added industry/segment/employee_band directly onto this table
-- (joined from dim_accounts) rather than creating a separate dim_users <->
-- dim_accounts relationship in Power BI, which would have caused an ambiguous
-- relationship path conflict with the existing fact_deals -> dim_accounts link.

CREATE OR REPLACE TABLE fact_user_engagement_summary AS
WITH engagement_stats AS (
    SELECT
        user_id,
        COUNT(*) AS total_core_actions,
        COUNT(DISTINCT event_name) AS distinct_core_action_types,
        MIN(event_timestamp) AS first_core_action_at,
        MAX(event_timestamp) AS last_core_action_at,
        DATE_DIFF('day', MAX(event_timestamp), DATE '2029-12-30') AS days_since_last_core_action
    FROM bronze__product_events
    WHERE event_name IN ('create_deal', 'log_activity', 'move_deal_stage', 'enable_automation', 'invite_user')
    GROUP BY user_id
)
SELECT
    u.user_id,
    u.account_id,
    acc.industry,
    acc.segment,
    acc.employee_band,
    a.is_activated,
    ch.is_churned,
    e.total_core_actions,
    e.distinct_core_action_types,
    e.first_core_action_at,
    e.last_core_action_at,
    e.days_since_last_core_action
FROM dim_users u
LEFT JOIN dim_accounts acc ON u.account_id = acc.account_id
LEFT JOIN silver__user_activation a ON u.user_id = a.user_id
LEFT JOIN silver__user_churn ch ON u.user_id = ch.user_id
LEFT JOIN engagement_stats e ON u.user_id = e.user_id;