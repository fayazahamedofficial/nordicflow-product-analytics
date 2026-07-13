# Data Quality Log

## Issue 1: Inconsistent casing in `raw__deals.status`
- **Found in:** `raw__deals` table, `status` column
- **What I found:** The same status appeared in multiple casings — e.g. "open", "OPEN", "Open" were stored as 9 distinct values instead of 3 clean categories (open, won, lost)
- **Why it matters:** Any KPI filtering on `status = 'won'` (exact match) would silently miss "Won" and "WON" rows, undercounting deal wins and producing an incorrect Deal Conversion Rate
- **How I found it:** Ran `GROUP BY status` to see all distinct values and their counts
- **Fix applied:** Used `LOWER(status)` to standardize casing before grouping/filtering. This will be applied in the bronze/silver transformation layer — never directly on the raw table.
- **Validation:** Re-ran the grouped count after applying `LOWER()` — confirmed the 9 messy values correctly collapsed into 3 clean categories (open: 4500, won: 1139, lost: 804), matching the sum of the original variants.