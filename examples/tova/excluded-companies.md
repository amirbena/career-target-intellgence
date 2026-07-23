# Excluded Companies — Tova (Golden Example)

Built following the [Excluded Companies output template](../../outputs/excluded-companies-template.md) and the [Exclusion Policy](../../ranking/exclusion-policy.md). All companies below are entirely synthetic. `checked_at` is fixed at `2026-07-23T09:00:00Z`.

## Ordering

Excluded records first, then Needs Review, each alphabetical by company name.

## Excluded

| Company | Company Type | Exclusion Status | Exclusion Reason | Evidence | Confidence | Reconsideration Condition | Checked At |
|---|---|---|---|---|---|---|---|
| Apex Delivery Partners | System Integrator | Excluded | Excluded company type | Company site describes delivering third-party ERP implementations for enterprise clients | High | User explicitly opts to include system integrators | 2026-07-23 |
| GlobalStaff Outsourcing | Outsourcing | Excluded | Excluded company type | Company site describes itself as a staff-augmentation vendor placing engineers at client sites | High | User explicitly opts to include outsourcing companies | 2026-07-23 |
| Junior Web Studio | Product | Excluded | Role/seniority mismatch | Careers page lists only Junior and Mid-level front-end roles; no backend or senior openings found | Medium | New senior backend role opens matching target seniority | 2026-07-23 |
| Northgate Analytics | Product | Excluded | Outside commute boundary | Estimated commute of 62 minutes by car exceeds the 40-minute limit in Search Criteria | Medium | Candidate raises the commute limit in Search Criteria | 2026-07-23 |

## Needs Review

| Company | Company Type | Exclusion Status | Exclusion Reason | Evidence | Confidence | Reconsideration Condition | Checked At |
|---|---|---|---|---|---|---|---|
| Verdant Cloud Works | Unclear | Needs Review | Insufficient evidence | Website language is ambiguous between an in-house product and a client-delivery consultancy; no clear classification signal found | Low | Additional source found clarifying the business model | 2026-07-23 |

## Rules Demonstrated

- Excluded companies (Apex Delivery Partners, GlobalStaff Outsourcing, Junior Web Studio, Northgate Analytics) do not receive a Priority 1–3 tier — see [company-map.md](company-map.md), which contains none of them.
- All four Excluded companies and the one Needs Review company remain visible here rather than silently dropped.
- Verdant Cloud Works (Needs Review) is kept separate from the fully Excluded records, per [Exclusion Policy](../../ranking/exclusion-policy.md#needs-review) — its Unclear company type is a research gap, not a disqualifying finding.
- Northgate Analytics' exclusion is explicitly tied to the current Search Criteria's commute limit; per [Exclusion Policy Rules](../../ranking/exclusion-policy.md#rules), rule 6, raising that limit would justify reconsidering it.

## Related documents

- [../../ranking/exclusion-policy.md](../../ranking/exclusion-policy.md)
- [company-map.md](company-map.md)
- [search-criteria.md](search-criteria.md)
