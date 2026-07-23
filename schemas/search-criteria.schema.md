# Search Criteria Schema

The Search Criteria record describes what should be searched for. It is separate from the [Candidate Profile](candidate-profile.schema.md) (who the candidate is) and from the [Research State](research-state.schema.md) (what has already been done).

This is a logical record. See [core/data-model.md](../core/data-model.md) for the principles that govern how it should be interpreted and populated.

## Search Scope

| Field | Type | Required | Description | Source expectations | Example |
|---|---|---|---|---|---|
| `origin_location` | string | Optional | The location the candidate is searching from. | User-provided. | `"Bnei Brak"` |
| `maximum_commute_minutes` | number | Optional | The candidate's maximum acceptable commute, in minutes. | User-provided. Must be configurable per request; see rules below. | `40` |
| `commute_mode` | enum: `Driving`, `Public transit`, `Walking`, `Mixed`, `Not applicable` | Optional | The mode of transport the commute limit applies to. | User-provided. | `"Driving"` |
| `commute_interpretation` | string | Optional | How the commute limit should be interpreted (e.g., one-way, round-trip, typical traffic conditions). | User-provided or assumed and labeled as such. | `"one-way, typical traffic"` |
| `preferred_work_models` | list of strings | Optional | Preferred work models. | User-provided. | `["hybrid"]` |
| `acceptable_work_models` | list of strings | Optional | Work models the candidate would accept even if not preferred. | User-provided. | `["on-site"]` |

`maximum_commute_minutes` is example input supplied per candidate. It must never be treated as a fixed or permanent product default.

## Role Criteria

| Field | Type | Required | Description | Source expectations | Example |
|---|---|---|---|---|---|
| `target_roles` | list of strings | Optional | Roles the candidate is primarily targeting. | User-provided. | `["Senior Backend Engineer"]` |
| `acceptable_roles` | list of strings | Optional | Roles the candidate would accept. | User-provided. | `["Backend Team Lead"]` |
| `excluded_roles` | list of strings | Optional | Roles that should be excluded from the search. | User-provided. | `["QA Engineer"]` |
| `target_seniority` | list of strings | Optional | Seniority levels being targeted. | User-provided. | `["Senior", "Staff"]` |
| `acceptable_seniority` | list of strings | Optional | Seniority levels that would be acceptable. | User-provided. | `["Lead"]` |

## Technology Criteria

| Field | Type | Required | Description | Source expectations | Example |
|---|---|---|---|---|---|
| `preferred_technologies` | list of strings | Optional | Technologies the search should favor. | User-provided. | `["C#", ".NET"]` |
| `acceptable_technologies` | list of strings | Optional | Technologies that are acceptable but not preferred. | User-provided. | `["Java"]` |
| `technology_exclusions` | list of strings | Optional | Technologies the candidate wants to avoid. | User-provided. | `["PHP"]` |
| `stack_match_strictness` | enum: `Strict`, `Balanced`, `Flexible` | Required | How strictly the search should match on technology stack. | User-provided or defaulted per request and labeled as an assumption. | `"Balanced"` |

`Strict` emphasizes direct stack overlap. `Balanced` combines stack, domain, and system experience. `Flexible` allows strong domain or system fit despite stack differences.

## Domain and Company Criteria

| Field | Type | Required | Description | Source expectations | Example |
|---|---|---|---|---|---|
| `preferred_domains` | list of strings | Optional | Domains the search should favor. | User-provided. | `["fintech"]` |
| `acceptable_domains` | list of strings | Optional | Domains that are acceptable. | User-provided. | `["enterprise software"]` |
| `excluded_domains` | list of strings | Optional | Domains to exclude. | User-provided. | `["gambling"]` |
| `preferred_company_types` | list of strings | Optional | Company types the search should favor. | User-provided. | `["product companies"]` |
| `acceptable_company_types` | list of strings | Optional | Company types that are acceptable. | User-provided. | `["hybrid product/services"]` |
| `excluded_company_types` | list of strings | Optional | Company types to exclude. | User-provided. | `["outsourcing houses"]` |
| `preferred_company_sizes` | list of strings | Optional | Preferred company sizes. | User-provided. | `["mid-size", "startup"]` |

## Research Request

| Field | Type | Required | Description | Source expectations | Example |
|---|---|---|---|---|---|
| `requested_company_count` | number | Optional | The number of companies the candidate wants researched. | User-provided. May vary per request. | `30` |
| `product_companies_only` | boolean | Optional | Whether the search should be restricted to product companies. | User-provided. Must be explicit, not assumed. | `true` |
| `include_hybrid_companies` | boolean | Optional | Whether hybrid product/services companies should be included. | User-provided. | `false` |
| `activity_lookback_days` | number | Optional | How far back activity verification should look, if requested. | User-provided. | `30` |
| `requested_outputs` | list of enum: `Candidate Profile`, `Target Company Map`, `Recruiter Map`, `Hiring Manager Map`, `Activity Verification`, `Outreach Priority Queue`, `CSV-compatible Export` | Required | The outputs the candidate has requested. | User-provided. | `["Target Company Map"]` |

## Assumptions and Confirmation

| Field | Type | Required | Description | Source expectations | Example |
|---|---|---|---|---|---|
| `user_provided_constraints` | list of strings | Optional | Constraints stated directly by the candidate. | User-provided. | `["max 40 minute drive"]` |
| `derived_constraints` | list of strings | Optional | Constraints derived from other information rather than stated directly. | Model inference. | `["prefers similar commute to last role"]` |
| `assumptions` | list of strings | Optional | Labeled, non-blocking assumptions made to proceed. | Model inference. | `["assumed balanced stack matching"]` |
| `open_questions` | list of strings | Optional | Questions that remain unresolved. | Model inference. | `["work model preference not yet confirmed"]` |
| `criteria_status` | enum: `Draft`, `Ready`, `Superseded` | Required | The current status of the search criteria. | — | `"Ready"` |
| `last_updated_at` | timestamp | Required | When the criteria were last updated. | — | `"2026-07-20T10:00:00Z"` |

## Search Criteria Rules

1. User-provided constraints override inferred preferences.
2. A commute limit must remain configurable.
3. The system may continue with a labeled assumption when a missing detail is non-blocking.
4. Product-only filtering must be explicit.
5. The requested number of companies may vary.
6. Activity verification is performed only when explicitly requested or included in an explicitly requested full journey.
7. Search criteria may be updated without rebuilding the Candidate Profile.
8. Changing commute or company-type constraints may invalidate only the affected research results.

## Example Record

```text
origin_location: "Bnei Brak"
maximum_commute_minutes: 40   # example input for this candidate, not a product default
commute_mode: "Driving"
product_companies_only: true
requested_company_count: 30
criteria_status: "Ready"
last_updated_at: "2026-07-20T10:05:00Z"
```

## Related documents

- [../core/data-model.md](../core/data-model.md)
- [candidate-profile.schema.md](candidate-profile.schema.md)
- [research-state.schema.md](research-state.schema.md)
