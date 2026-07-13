# Metrics Dictionary

## Deal Conversion Rate
- **Formula:** Closed-Won deals ÷ (Closed-Won deals + Closed-Lost deals)
- **Grain:** One row = one deal
- **Tables used:** deals, accounts, geography
- **Filters/Exclusions:** Excludes deals still "Open" (no outcome yet); excludes test/demo accounts
- **Assumption:** This measures win-rate among decided deals, not overall pipeline efficiency, since this project's focus is churn and activation rather than sales team performance.
## Activation Rate
- **Formula:** % of new users who perform at least one core product action within 14 days of signup
- **Grain:** One row = one user
- **Tables used:** users, product_events, accounts, geography
- **Filters/Exclusions:** Only includes users whose full 14-day window has elapsed as of the reporting date (excludes too-recent signups); excludes test/demo accounts
- **Core actions counted:** creating a deal, logging a follow-up activity, moving a deal to a new pipeline stage, setting up workflow automation, adding a new contact/lead
- **Non-core actions (excluded):** logging in, changing settings/profile picture, browsing/viewing without creating anything
- **Why this matters:** Activation is our project's central KPI — it distinguishes users who are genuinely getting value from the CRM (activity) from those who are just logging in without real engagement (value), which directly ties to our churn investigation.
## Churn Rate (Early-Stage)
- **Formula:** % of activated customers who perform no core product actions for 30+ consecutive days within their first 90 days as a customer
- **Grain:** One row = one customer (only among activated customers)
- **Tables used:** accounts, product_events, users
- **Filters/Exclusions:** Only measured among customers who were successfully activated; measured within first 90 days only (early-stage, not lifetime churn)
- **Assumption:** Uses 30+ consecutive days of no core activity as a behavioral proxy for churn, since an explicit cancellation flag may not be reliably captured in the data. The 30-day threshold avoids falsely flagging normal short gaps (weekends, holidays, business trips) as churn.
- **Why this matters:** Churn is only meaningful in the context of customers who got real value in the first place — mixing "never activated" with "activated then disengaged" would blur two different business problems into one misleading number.