# ADR 001: Add fact_user_engagement_summary table

**Status:** Accepted

**Context:**
The core star schema (fact_deals, fact_product_events, plus 4 dimensions) supports
the tutorial's baseline KPIs, but doesn't directly support answering our project's
central business question: "which customer segments/behaviors predict early churn?"
Answering that requires repeatedly joining silver activation/churn views with raw
event aggregates - logic that would otherwise be duplicated across every future
analysis query.

**Decision:**
Add a new gold-layer table, fact_user_engagement_summary, at a one-row-per-user
grain, combining: activation status, churn status, total core actions, breadth
of feature usage (distinct action types), and recency (days since last core action).

**Alternatives considered:**
1. Calculate these metrics fresh inside every analysis query - rejected, since it
   duplicates already-validated activation/churn logic and risks reintroducing bugs
   we already fixed (e.g., the 90-day window issue found in Step 4).
2. Add these columns directly onto dim_users - rejected, since dimension tables
   should hold slowly-changing descriptive attributes, not metrics derived from
   fact-table aggregation, which violates standard star schema conventions.

**Consequences:**
- Enables Step 9 extended analysis (engagement vs. churn comparison) without
  repeated complex joins.
- This table must be refreshed whenever bronze__product_events or the silver
  views are rebuilt (documented dependency).
- Slight redundancy with dim_users (account_id repeated), acceptable trade-off
  for query simplicity in the analysis layer.