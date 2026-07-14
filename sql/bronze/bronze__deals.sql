-- Bronze layer: cleaned version of raw__deals
-- Fixes applied:
--   1. Removed exact duplicate rows (34 deals were duplicated, found via GROUP BY deal_id HAVING COUNT(*) > 1)
--   2. Standardized status casing using LOWER() (raw data had open/OPEN/Open, won/Won/WON, lost/Lost/LOST)

CREATE OR REPLACE VIEW bronze__deals AS
SELECT DISTINCT
    deal_id,
    account_id,
    owner_user_id,
    pipeline_id,
    current_stage_id,
    LOWER(status) AS status,
    created_at,
    closed_at,
    last_stage_changed_at,
    amount,
    currency,
    country_code,
    source_system
FROM raw__deals;