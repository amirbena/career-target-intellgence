# Excluded Companies Template

This is the Markdown presentation template for the Excluded Companies Report, built from [Company Records](../schemas/company-record.schema.md) with `exclusion_status` of Excluded or Needs Review, per [core/output-contracts.md](../core/output-contracts.md#excluded-companies-report) and the [Exclusion Policy](../ranking/exclusion-policy.md). All values below are synthetic.

## Required Columns

| Column | Source field |
|---|---|
| Company | `company_name` |
| Company Type | `company_type` |
| Exclusion Status | `exclusion_status` |
| Exclusion Reason | `exclusion_reason` |
| Evidence | `company_type_evidence`, or other supporting evidence for the exclusion |
| Confidence | `confidence` |
| Reconsideration Condition | What would justify reconsidering the company (e.g., "if commute limit increases") |
| Checked At | `checked_at` |

## Rules

- Excluded companies do not receive Priority 1–3.
- Excluded companies must not disappear silently — every Excluded or Needs Review company appears here.
- Needs Review records must remain separate from fully Excluded records.
- Changed Search Criteria may justify reconsideration — see [Exclusion Policy Rules](../ranking/exclusion-policy.md#rules), rule 6.

## Ordering

Excluded records first, then Needs Review, each alphabetical by company name.

## Synthetic Example

**Excluded**

| Company | Company Type | Exclusion Status | Exclusion Reason | Evidence | Confidence | Reconsideration Condition | Checked At |
|---|---|---|---|---|---|---|---|
| Atlas Outsourcing Group | Outsourcing | Excluded | Excluded company type | Company site describes itself as a staff-augmentation vendor | High | User explicitly opts to include outsourcing companies | 2026-07-19 |
| Coastal Freight Partners | Product | Excluded | Outside commute boundary | Estimated commute of 65 minutes exceeds the 40-minute limit | Medium | Candidate raises the commute limit | 2026-07-18 |

**Needs Review**

| Company | Company Type | Exclusion Status | Exclusion Reason | Evidence | Confidence | Reconsideration Condition | Checked At |
|---|---|---|---|---|---|---|---|
| Verona Data Solutions | Unclear | Needs Review | Insufficient evidence | Website language is ambiguous between product and consulting | Low | Additional source found clarifying business model | 2026-07-20 |

## Related documents

- [../schemas/company-record.schema.md](../schemas/company-record.schema.md)
- [../ranking/exclusion-policy.md](../ranking/exclusion-policy.md)
- [../core/output-contracts.md](../core/output-contracts.md)
- [company-map-template.md](company-map-template.md)
