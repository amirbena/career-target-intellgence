# Module: Build Search Criteria

Builds the [Search Criteria](../schemas/search-criteria.schema.md) that will guide company discovery, using the Candidate Profile plus explicit user constraints. This module does not redefine the schema — it describes how to populate it within the workflow.

## Purpose

Translate the candidate's background and stated preferences into explicit, structured search criteria.

## Required Inputs

- A Candidate Profile (Draft or Approved).
- Any explicit constraints the user has stated (commute limit, target roles, company type preferences, etc.).

## Optional Inputs

- Prior Search Criteria, when refining rather than starting fresh.

## Preconditions

- A Candidate Profile must exist — see [Full Journey Rule 1](full-journey.md#candidate-analysis).

## Procedure

1. Populate [Search Scope](../schemas/search-criteria.schema.md#search-scope), [Role Criteria](../schemas/search-criteria.schema.md#role-criteria), [Technology Criteria](../schemas/search-criteria.schema.md#technology-criteria), and [Domain and Company Criteria](../schemas/search-criteria.schema.md#domain-and-company-criteria) from the Candidate Profile and explicit user statements.
2. Populate [Research Request](../schemas/search-criteria.schema.md#research-request) fields (`requested_company_count`, `product_companies_only`, `requested_outputs`, etc.) only from explicit user input — never assume a default scope the user has not stated.
3. Record `user_provided_constraints`, `derived_constraints`, and `assumptions` per [Assumptions and Confirmation](../schemas/search-criteria.schema.md#assumptions-and-confirmation).
4. Mark `criteria_status` as Ready once the criteria are sufficient to proceed.

## Outputs

- Search Criteria with `criteria_status` of Draft or Ready.

## Research State Updates

- `search_criteria_status` moves from Not Started → Draft → Ready.
- `search_criteria_reference` is set once criteria exist.

## Quality Gates

- `maximum_commute_minutes` remains user-configurable, never a hardcoded default — see [Search Criteria Rules](../schemas/search-criteria.schema.md#search-criteria-rules), rule 2.
- `product_companies_only` is set only when the user explicitly requests it — rule 4.
- User-provided constraints override inferred preferences — rule 1.

## Uncertainty Handling

- A non-blocking missing detail proceeds with a clearly labeled assumption rather than blocking the workflow — rule 3.
- A blocking missing detail (e.g., no target role or location at all) is surfaced as an open question rather than guessed.

## Explicit Non-Actions

- Do not hardcode 40 minutes, or any other commute figure, as a default.
- Do not assume product-only filtering unless the user requests it.
- Do not overwrite user-stated preferences with model inference.

## Related documents

- [../schemas/search-criteria.schema.md](../schemas/search-criteria.schema.md)
- [analyze-candidate.md](analyze-candidate.md)
- [full-journey.md](full-journey.md)
- [focused-task-routing.md](focused-task-routing.md)
