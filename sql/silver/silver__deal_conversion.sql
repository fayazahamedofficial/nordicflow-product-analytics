-- Silver layer: deal conversion rate calculation
-- Formula: Closed-Won / (Closed-Won + Closed-Lost), excluding Open deals
-- Note: no test/demo account flag exists in raw_accounts, so test-account
-- exclusion (mentioned in metrics dictionary) could not be applied here -
-- documented as a known limitation.

CREATE OR REPLACE VIEW silver__deal_conversion AS
SELECT
    COUNT(CASE WHEN status = 'won' THEN 1 END) AS won_deals,
    COUNT(CASE WHEN status = 'lost' THEN 1 END) AS lost_deals,
    COUNT(CASE WHEN status IN ('won', 'lost') THEN 1 END) AS decided_deals,
    ROUND(
        COUNT(CASE WHEN status = 'won' THEN 1 END) * 100.0
        / COUNT(CASE WHEN status IN ('won', 'lost') THEN 1 END),
        2
    ) AS conversion_rate_pct
FROM bronze__deals
WHERE status IN ('won', 'lost');