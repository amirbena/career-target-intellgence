# Search Criteria Template

This is the Markdown presentation template for the Search Criteria output, built from the [Search Criteria schema](../schemas/search-criteria.schema.md), per [core/output-contracts.md](../core/output-contracts.md#search-criteria). The commute limit remains user-configurable — it is never a fixed default. All values below are synthetic.

## Template

```markdown
# Search Criteria — {{candidate_name}}

**Status:** {{criteria_status}} · **Last updated:** {{last_updated_at}}

## Search Origin
{{origin_location}}

## Commute Limit and Mode
- **Maximum commute:** {{maximum_commute_minutes}} minutes ({{commute_mode}}) — user-configured for this search, not a product default.
- **Interpretation:** {{commute_interpretation}}

## Work Models
- **Preferred:** {{preferred_work_models}}
- **Acceptable:** {{acceptable_work_models}}

## Target and Acceptable Roles
- **Target:** {{target_roles}}
- **Acceptable:** {{acceptable_roles}}
- **Excluded:** {{excluded_roles}}

## Target Seniority
- **Target:** {{target_seniority}}
- **Acceptable:** {{acceptable_seniority}}

## Technology Strictness
{{stack_match_strictness}}

## Preferred and Excluded Domains
- **Preferred:** {{preferred_domains}}
- **Excluded:** {{excluded_domains}}

## Preferred and Excluded Company Types
- **Preferred:** {{preferred_company_types}}
- **Excluded:** {{excluded_company_types}}

## Requested Company Count
{{requested_company_count}}

## Product-only and Hybrid-company Settings
- **Product companies only:** {{product_companies_only}}
- **Include hybrid companies:** {{include_hybrid_companies}}

## Activity Lookback Window
{{activity_lookback_days}} days (only applies if Activity Verification is requested)

## Requested Outputs
{{requested_outputs}}

## Assumptions
{{assumptions}}

## Criteria Status
{{criteria_status}}

## Last Updated
{{last_updated_at}}
```

## Synthetic Example

```markdown
# Search Criteria — Dana Levi

**Status:** Ready · **Last updated:** 2026-07-20T10:05:00Z

## Search Origin
Bnei Brak

## Commute Limit and Mode
- **Maximum commute:** 40 minutes (Driving) — user-configured for this search, not a product default.
- **Interpretation:** one-way, typical traffic

## Work Models
- **Preferred:** hybrid
- **Acceptable:** on-site

## Target and Acceptable Roles
- **Target:** Senior Backend Engineer
- **Acceptable:** Backend Team Lead
- **Excluded:** QA Engineer

## Target Seniority
- **Target:** Senior, Staff
- **Acceptable:** Lead

## Technology Strictness
Balanced

## Preferred and Excluded Domains
- **Preferred:** fintech
- **Excluded:** gambling

## Preferred and Excluded Company Types
- **Preferred:** product companies
- **Excluded:** outsourcing houses

## Requested Company Count
30

## Product-only and Hybrid-company Settings
- **Product companies only:** true
- **Include hybrid companies:** false

## Activity Lookback Window
Not requested

## Requested Outputs
Target Company Map

## Assumptions
assumed balanced stack matching

## Criteria Status
Ready

## Last Updated
2026-07-20T10:05:00Z
```

## Related documents

- [../schemas/search-criteria.schema.md](../schemas/search-criteria.schema.md)
- [../core/output-contracts.md](../core/output-contracts.md)
