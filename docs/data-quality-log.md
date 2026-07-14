# Data Quality Log

## Issue 1: Inconsistent casing in `raw__deals.status`
- **Found in:** `raw__deals` table, `status` column
- **What I found:** The same status appeared in multiple casings — e.g. "open", "OPEN", "Open" were stored as 9 distinct values instead of 3 clean categories (open, won, lost)
- **Why it matters:** Any KPI filtering on `status = 'won'` (exact match) would silently miss "Won" and "WON" rows, undercounting deal wins and producing an incorrect Deal Conversion Rate
- **How I found it:** Ran `GROUP BY status` to see all distinct values and their counts
- **Fix applied:** Used `LOWER(status)` to standardize casing before grouping/filtering. This will be applied in the bronze/silver transformation layer — never directly on the raw table.
- **Validation:** Re-ran the grouped count after applying `LOWER()` — confirmed the 9 messy values correctly collapsed into 3 clean categories (open: 4500, won: 1139, lost: 804), matching the sum of the original variants.
## Issue 2: Multiple "ended" states in `raw__accounts.account_status`, and minor casing inconsistency
- **Found in:** `raw__accounts` table, `account_status` column
- **What I found:** Values include active, churned, cancelled, and one casing variant (ACTIVE). "Churned" and "cancelled" appear to represent two different end-states, but a date-range comparison was inconclusive in distinguishing them clearly.
- **Why it matters:** Unclear whether "churned" and "cancelled" should be treated as the same outcome or different ones when building churn analysis.
- **Decision made:** Treat "churned" and "cancelled" together as one "ended" group representing Nordicflow's official account status, kept separate from our own custom behavioral churn definition (30+ days inactivity post-activation, from the metrics dictionary). This gives us two independent signals to compare later, rather than forcing one definition.
- **Fix applied:** Standardize casing with LOWER() (same as the deals status fix) before any grouping or filtering.
- **Follow-up idea:** Potential original analysis (Step 9) — check whether our behavioral churn signal predicts accounts that later show official churned/cancelled status.
## Observation 3: Minor nulls in `raw__users.job_role`
- **Found in:** `raw__users` table, `job_role` column
- **What I found:** 10 out of ~400 users have a NULL job_role (out of 5 known values: sales_rep, sales_manager, revops, customer_success, admin)
- **Why it matters:** Minor — likely normal missing data (e.g. optional field skipped at signup, or a system/service account), not a systemic issue
- **Decision:** No fix needed now. If job_role is used in future analysis, treat NULLs as "unknown" or exclude depending on the specific question.
## Issue 4: Test events present in `raw__product_events`, plus casing/naming inconsistency in `event_name`
- **Found in:** `raw__product_events` table
- **What I found:**
  1. `event_name` has casing/naming inconsistencies — e.g. "login", "Login", "user_login" all represent the same event; "view_dashboard" and "ViewDashboard" likewise.
  2. `is_test_event` flag shows 1,195 out of ~61,747 rows (~2%) are explicitly marked as test events.
- **Why it matters:** Including test events or failing to standardize event names would inflate or distort activation/churn calculations, since these rely on counting specific "core action" events accurately.
- **Fix applied:**
  - Standardize `event_name` with LOWER() before matching against our core-action list
  - Filter out all rows where `is_test_event = true` before any KPI calculation
- **Bonus discovery:** Found a new event type, `invite_user`, not originally identified in our Step 2 core-action list. Added it as a core action — reasoning: inviting teammates signals team-wide CRM adoption, not just individual usage, which is a genuine value signal similar to creating deals or logging activities.
- **Updated core actions list:** create_deal, log_activity, move_deal_stage, enable_automation, invite_user
- **Updated non-core actions:** login (all variants), view_dashboard (all variants)