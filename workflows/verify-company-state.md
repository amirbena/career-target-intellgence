# Module: Verify Company State

Identifies and verifies time-sensitive organizational developments (layoffs, hiring freezes, restructuring, acquisitions, funding, expansion, leadership changes, and similar events) for a company, producing [Company State Records](../schemas/company-state-record.schema.md). This module never changes a Job Record's `job_status`.

## Purpose

Surface company health/state signals as explicit, separately-dated, separately-sourced context alongside a role or a company — never merged into availability or fit.

## Required Inputs

- One or more company names to check — typically the employer(s) of Job Records that passed the [Primary Job Eligibility Gate](../ranking/job-eligibility-gate.md), or companies under active consideration in the [Company Targeting Journey](full-journey.md).

## Preconditions

- None beyond having a company name; this module may run standalone as a focused task ("assess company state for these companies") or as part of either full journey.

## Procedure

1. Search for recent organizational developments using the [Company State Source Hierarchy](../core/source-policy.md#company-state-source-hierarchy): official announcements/filings first, then regulatory filings where applicable, then direct executive/company communications, then reputable business/news reporting, then other credible secondary sources.
2. Reject a social-media rumor or unsupported post as the sole basis for a verified event; record it only as `Unverified` if recorded at all.
3. For a significant negative event (layoffs, closures, insolvency, distress), attempt corroboration from a second independent source when practical; record `corroborated`.
4. Populate [Event](../schemas/company-state-record.schema.md#event), [Source and Freshness](../schemas/company-state-record.schema.md#source-and-freshness), and [Evidence State](../schemas/company-state-record.schema.md#evidence-state) fields.
5. Write `candidate_impact_assessment`, explicitly labeled via `impact_assessment_type` as `Fact` or `Supported Inference` — never presented as an unlabeled conclusion.
6. Set `currency_assessment` based on whether the event remains materially relevant to the decision at hand, independent of its raw age.
7. Link the record to relevant Job Record(s) via `related_job_record_references` (or the reverse reference on the Job Record) so it can be surfaced alongside the role — do not modify the Job Record's `job_status` or `fit_gate_result`.

## Outputs

- Company State Records, linked to relevant Job Records where applicable.

## Research State Updates

- `company_state_verification_status` moves from Not Started → Draft → Completed.

## Quality Gates

- Facts (`event_description`) and inference (`candidate_impact_assessment` when `impact_assessment_type` is `Supported Inference`) remain visibly separate — see [Company State Record Rules](../schemas/company-state-record.schema.md#company-state-record-rules), rule 6.
- A social-media rumor alone does not become a verified event — rule 3.
- Conflicting evidence stays visible — rule 5.
- This module never sets or changes a Job Record's `job_status` — rule 8.

## Uncertainty Handling

- When only weak or single-source evidence exists, record `evidence_state` of `Unverified` or `Unable to Verify` rather than omitting the event or overstating it.
- `currency_assessment` of `Materially Relevant Though Older` is used, not automatic expiration, when an older event remains decision-relevant — see [freshness-policy.md](../core/freshness-policy.md#company-state-freshness).

## Explicit Non-Actions

- Do not convert a factual event into an unlabeled conclusion like "bad company."
- Do not auto-close every Job Record at a company because of a layoff.
- Do not auto-taint a role in an unrelated business unit because of a layoff elsewhere in the company.
- Do not treat growth/funding evidence as proof any specific role is open.
- Do not perform background or scheduled monitoring of company news.

## Related documents

- [../schemas/company-state-record.schema.md](../schemas/company-state-record.schema.md)
- [../core/source-policy.md](../core/source-policy.md)
- [../core/freshness-policy.md](../core/freshness-policy.md)
- [../core/job-verification-policy.md](../core/job-verification-policy.md)
- [job-search-journey.md](job-search-journey.md)
- [full-journey.md](full-journey.md)
