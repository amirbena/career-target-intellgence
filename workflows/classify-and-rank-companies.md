# Module: Classify and Rank Companies

Applies company classification, the [Exclusion Policy](../ranking/exclusion-policy.md), and the [Company Ranking Model](../ranking/company-ranking-model.md) to discovered companies. This module does not perform discovery — it operates on Draft Company Records already produced by [discover-companies.md](discover-companies.md).

## Purpose

Turn a broad, unfiltered discovery set into a classified, scored, and prioritized set of companies, with excluded companies retained separately rather than dropped.

## Required Inputs

- Draft Company Records from Discover Companies.

## Optional Inputs

- User-supplied corrections to a company's classification (e.g., "this is actually a product company, not a consultancy").

## Preconditions

- Discovery must have produced at least one Draft Company Record.

## Procedure

1. Classify each company's `company_type`, with `company_type_confidence` and `company_type_evidence`, per [Company Classification](../schemas/company-record.schema.md#company-classification). Do not classify as Product based on branding language alone.
2. Apply the [Exclusion Policy](../ranking/exclusion-policy.md): set `exclusion_status` to Included, Needs Review, or Excluded, with an `exclusion_reason` for Excluded records. Unclear `company_type` normally becomes Needs Review, not Excluded — see [Exclusion Policy rules](../ranking/exclusion-policy.md#rules), rule 5.
3. For Included and Needs Review companies, apply the [Company Ranking Model](../ranking/company-ranking-model.md) across all eight dimensions, using its [Scoring Bands](../ranking/company-ranking-model.md#scoring-bands) rubric, producing a score and Priority tier (or a labeled provisional score for Needs Review).
4. Retain Excluded companies in a separate exclusion report rather than dropping them from the result set.

## Re-scoring

This module also handles re-scoring an already-ranked company when a [Re-scoring Trigger](../ranking/company-ranking-model.md#re-scoring-triggers) applies (for example, a Focused Task like "change commute to 20 minutes" — see [focused-task-routing.md](focused-task-routing.md)). In that case, follow the [Re-scoring Process](../ranking/company-ranking-model.md#re-scoring-process) exactly:

1. Mark only the affected dimension(s) as requiring refresh, not the whole record.
2. Recompute only the affected dimensions.
3. Recompute the total score and Priority tier from the full dimension set.
4. Preserve the previous score in the reasoning when the change is material.
5. Do not silently overwrite an Approved or Verified ranking — move it to Draft before replacing it.
6. Update `checked_at`, `confidence`, and the written reasoning.

## Outputs

- Company Records with `company_type`, `exclusion_status`, and (for Included/Needs Review) a Priority tier and written reasoning.
- A separate exclusion report listing Excluded companies with their `exclusion_reason`.

## Research State Updates

- `company_classification_status` moves from Not Started → Draft → Completed.
- `company_ranking_status` moves from Not Started → Draft → Completed.

## Quality Gates

- Company classification happens before final ranking — see [Full Journey Rule 3](full-journey.md#company-ranking).
- Excluded companies do not proceed to final ranking — [Full Journey Rule 4](full-journey.md#company-ranking) and [Exclusion Policy](../ranking/exclusion-policy.md).
- Every score is accompanied by written reasoning — see [Company Ranking Model Rules](../ranking/company-ranking-model.md#rules), rule 5.

## Uncertainty Handling

- Missing evidence on a scoring dimension is scored conservatively low, never treated as active negative evidence — see [Company Ranking Model Rules](../ranking/company-ranking-model.md#rules), rule 2.
- Companies with conflicting classification evidence keep that conflict visible rather than picking one side silently.

## Explicit Non-Actions

- Do not classify a company as Product from branding language alone.
- Do not rank an Excluded company.
- Do not let a strong hiring signal compensate for poor professional fit — the ranking model's 5-point cap on hiring signal enforces this.
- Do not hide an Excluded company; it must appear in the exclusion report.

## Related documents

- [../schemas/company-record.schema.md](../schemas/company-record.schema.md)
- [../ranking/exclusion-policy.md](../ranking/exclusion-policy.md)
- [../ranking/company-ranking-model.md](../ranking/company-ranking-model.md)
- [discover-companies.md](discover-companies.md)
- [full-journey.md](full-journey.md)
