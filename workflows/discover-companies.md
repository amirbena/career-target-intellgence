# Module: Discover Companies

Identifies a broad set of candidate companies matching the Search Criteria, before any filtering or ranking. This module produces draft [Company Records](../schemas/company-record.schema.md) — it does not classify or score them.

## Purpose

Cast a wide, criteria-guided net before narrowing. Discovery is deliberately broad; classification and ranking happen afterward in [classify-and-rank-companies.md](classify-and-rank-companies.md).

## Required Inputs

- Ready Search Criteria.

## Optional Inputs

- A user-supplied list of specific companies to include, when the request is "find recruiters/managers at these companies" style rather than open discovery.

## Preconditions

- Search Criteria must be Ready — see [Full Journey Rule 2](full-journey.md#company-discovery).

## Procedure

1. Identify companies matching the Search Criteria's role, technology, domain, and company-type criteria.
2. Populate [Identity](../schemas/company-record.schema.md#identity) and [Location](../schemas/company-record.schema.md#location) fields with sourced evidence, per [source-policy.md](../core/source-policy.md).
3. Leave [Company Classification](../schemas/company-record.schema.md#company-classification), [Candidate Relevance](../schemas/company-record.schema.md#candidate-relevance), and ranking fields for the next module — discovery does not classify or rank.
4. Set `record_status` to Draft.

## Outputs

- Draft Company Records with `record_status` of Draft.

## Research State Updates

- `company_discovery_status` moves from Not Started → Draft → Completed.

## Quality Gates

- Identity and location claims must be sourced — see [source-policy.md](../core/source-policy.md).
- Every mutable public claim requires `checked_at` — see [Company Record Rules](../schemas/company-record.schema.md#company-record-rules), rule 7.

## Uncertainty Handling

- Companies with weak or single-source evidence are still recorded as Draft; confidence is expressed per [confidence-model.md](../core/confidence-model.md), not by omitting the company.

## Explicit Non-Actions

- Do not imply every discovered company is currently hiring — see [Company Record Rules](../schemas/company-record.schema.md#company-record-rules), rule 8.
- Do not rank before classification.
- Do not perform background or recurring research — discovery runs once per request, not on a schedule.

## Related documents

- [../schemas/company-record.schema.md](../schemas/company-record.schema.md)
- [../core/source-policy.md](../core/source-policy.md)
- [classify-and-rank-companies.md](classify-and-rank-companies.md)
- [build-search-criteria.md](build-search-criteria.md)
- [full-journey.md](full-journey.md)
