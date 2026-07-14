-- Silver layer: early-stage churn calculation
-- Business logic: an activated user is considered "churned" if they had a gap of
-- 30+ consecutive days with no core product action, within their first 90 days
-- as a customer. Churn is only evaluated for users who were activated in the
-- first place (see silver__user_activation) - never-activated users represent
-- a separate onboarding-failure problem, not churn.
--
-- IMPORTANT: gap detection is restricted to each user's own first 90 days
-- (event_timestamp <= created_at + INTERVAL 90 DAY). An earlier version of this
-- query checked for 30-day gaps across a user's ENTIRE history, which incorrectly
-- flagged 87.9% of activated users as "churned" - simply because longer histories
-- have more opportunities for a random 30-day gap, unrelated to early-stage churn.
-- Restricting to the first 90 days brought this down to a more realistic ~43%.

CREATE OR REPLACE VIEW silver__user_churn AS
WITH core_action_gaps AS (
    SELECT
        e.user_id,
        e.event_timestamp,
        DATE_DIFF(
            'day',
            LAG(e.event_timestamp) OVER (PARTITION BY e.user_id ORDER BY e.event_timestamp),
            e.event_timestamp
        ) AS gap_days
    FROM bronze__product_events e
    INNER JOIN bronze__users u ON e.user_id = u.user_id
    WHERE e.event_name IN ('create_deal', 'log_activity', 'move_deal_stage', 'enable_automation', 'invite_user')
      AND e.event_timestamp <= u.created_at + INTERVAL 90 DAY
),
churn_flag AS (
    SELECT
        user_id,
        MAX(CASE WHEN gap_days >= 30 THEN 1 ELSE 0 END) AS had_30_day_gap
    FROM core_action_gaps
    GROUP BY user_id
)
SELECT
    a.user_id,
    a.account_id,
    a.is_activated,
    COALESCE(c.had_30_day_gap, 0) AS had_30_day_gap,
    CASE
        WHEN a.is_activated = true AND COALESCE(c.had_30_day_gap, 0) = 1 THEN true
        ELSE false
    END AS is_churned
FROM silver__user_activation a
LEFT JOIN churn_flag c ON a.user_id = c.user_id;