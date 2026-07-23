# Company Record Schema

The Company Record describes a target organization and the evidence gathered about it. It is separate from the [Candidate Profile](candidate-profile.schema.md) and [Search Criteria](search-criteria.schema.md) — those describe the candidate and what to search for; this record describes what was found about one company.

This is a logical record. See [core/data-model.md](../core/data-model.md) for the principles that govern how it should be interpreted and populated, including the [Context Boundary](../core/data-model.md#context-boundary).

## Identity

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `company_name` | string | Required | The company's name. | `"Northbridge Systems"` |
| `website_url` | string | Optional | The company's website. | `"https://northbridgesystems.example"` |
| `linkedin_company_url` | string | Optional | The company's LinkedIn page. | `"https://linkedin.com/company/northbridge-systems-example"` |
| `company_description` | string | Optional | A short description of the company. | `"Mid-size billing platform vendor"` |
| `company_status` | enum: `Active`, `Acquired`, `Closed`, `Unknown` | Required | The company's operating status. | `"Active"` |

## Location

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `office_locations` | list of strings | Optional | Known office locations. | `["Tel Aviv", "Ra'anana"]` |
| `relevant_location` | string | Optional | The office location relevant to the candidate's search. | `"Ra'anana"` |
| `estimated_commute_minutes` | number | Optional | An estimated commute time from the candidate's origin location. | `35` |
| `commute_mode` | enum: `Driving`, `Public transit`, `Walking`, `Mixed`, `Not applicable` | Optional | The mode the estimate assumes. | `"Driving"` |
| `commute_confidence` | enum: `Estimated`, `Verified` | Required | Whether the commute figure is a rough estimate or has been verified. | `"Estimated"` |
| `location_evidence` | list of strings | Optional | Sources supporting the location information. | `["company careers page"]` |

Commute values must be treated as estimates and must not imply live traffic accuracy unless verified by an appropriate source.

## Company Classification

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `company_type` | enum: `Product`, `Product-led Enterprise`, `Hybrid Product and Services`, `Consulting`, `Outsourcing`, `System Integrator`, `Staffing`, `Project-based Development`, `Unclear` | Required | The company's business model type. | `"Product"` |
| `company_type_confidence` | enum: `Low`, `Medium`, `High` | Required | Confidence in the classification. | `"Medium"` |
| `company_type_evidence` | list of strings | Optional | Evidence supporting the classification. | `["sells a single billing SaaS product"]` |

Do not classify a company as Product based only on branding language.

## Product and Domain

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `products` | list of strings | Optional | Known products the company builds. | `["billing platform"]` |
| `industries` | list of strings | Optional | Industries the company serves. | `["fintech"]` |
| `business_domains` | list of strings | Optional | Business domains relevant to the company's work. | `["billing", "invoicing"]` |
| `system_types` | list of strings | Optional | Types of systems the company operates. | `["distributed systems"]` |
| `customer_types` | list of strings | Optional | Types of customers the company serves. | `["enterprise"]` |

## Technology Evidence

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `known_technologies` | list of strings | Optional | Technologies observed in evidence. | `["C#", ".NET", "SQL Server"]` |
| `technology_evidence` | list of strings | Optional | Sources supporting the technology claims. | `["job posting for Senior Backend Engineer"]` |
| `technology_scope` | enum: `Company-wide`, `Business Unit`, `Team-specific`, `Job-specific`, `Historical`, `Unknown` | Required | The scope the technology evidence applies to. | `"Job-specific"` |
| `technology_confidence` | enum: `Low`, `Medium`, `High` | Required | Confidence in the technology evidence. | `"Medium"` |

One job post must not automatically become a company-wide stack claim; `technology_scope` must reflect the actual breadth of the evidence.

## Candidate Relevance

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `relevant_roles` | list of strings | Optional | Roles at this company relevant to the candidate. | `["Senior Backend Engineer"]` |
| `possible_relevant_teams` | list of strings | Optional | Teams that may be relevant. | `["Billing Platform Team"]` |
| `role_fit_notes` | string | Optional | Notes on role fit. | `"Titles align with candidate's target roles"` |
| `stack_fit_notes` | string | Optional | Notes on technology fit. | `"C#/SQL Server matches candidate's primary stack"` |
| `domain_fit_notes` | string | Optional | Notes on domain fit. | `"Billing domain matches candidate's experience"` |
| `system_fit_notes` | string | Optional | Notes on system-type fit. | `"Distributed systems experience is relevant"` |
| `location_fit_notes` | string | Optional | Notes on location/commute fit. | `"Within candidate's commute preference"` |

Do not add numeric scores or priority tiers in this task.

## Hiring Evidence

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `career_page_url` | string | Optional | The company's careers page. | `"https://northbridgesystems.example/careers"` |
| `current_role_evidence` | list of strings | Optional | Evidence of currently open roles. | `["Senior Backend Engineer listing dated 2026-07-10"]` |
| `general_hiring_signal` | string | Optional | A general description of hiring activity, if any. | `"Multiple engineering roles open"` |
| `hiring_signal_date` | timestamp | Optional | When the hiring signal was observed. | `"2026-07-10T00:00:00Z"` |
| `hiring_signal_status` | enum: `Verified Current Role`, `Recent Hiring Signal`, `Historical Hiring Signal`, `No Signal Found`, `Unable to Verify` | Required | The status of the hiring signal. | `"Recent Hiring Signal"` |

A company appearing in the target map must not imply that it is currently hiring; `hiring_signal_status` carries that determination explicitly.

## Evidence and Lifecycle

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `sources` | list of strings | Optional | Sources used to build this record. | `["company website", "LinkedIn company page"]` |
| `checked_at` | timestamp | Required | When this record was last checked. | `"2026-07-20T09:00:00Z"` |
| `confidence` | enum: `Low`, `Medium`, `High` | Required | Overall confidence in the record. | `"Medium"` |
| `record_status` | enum: `Draft`, `Verified`, `Approved`, `Stale`, `Superseded` | Required | The status of the record. | `"Draft"` |
| `exclusion_status` | enum: `Included`, `Excluded`, `Needs Review` | Required | Whether the company remains in scope. | `"Included"` |
| `exclusion_reason` | string | Optional | The reason for exclusion, if excluded. | `""` |

## Company Record Rules

1. Separate company identity from candidate relevance.
2. Separate current hiring evidence from general suitability.
3. Qualify technology claims by scope.
4. Preserve uncertainty when company type is unclear.
5. Record why a company was excluded.
6. Do not invent office locations, teams, technologies, or open roles.
7. Every mutable public claim requires a source and `checked_at`.
8. Company suitability does not prove current hiring.

## Example Record

```text
company_name: "Northbridge Systems"
company_status: "Active"
relevant_location: "Ra'anana"
estimated_commute_minutes: 35
commute_confidence: "Estimated"
company_type: "Product"
company_type_confidence: "Medium"
known_technologies: ["C#", ".NET", "SQL Server"]
technology_scope: "Job-specific"
hiring_signal_status: "Recent Hiring Signal"
record_status: "Draft"
exclusion_status: "Included"
checked_at: "2026-07-20T09:00:00Z"
```

## Related documents

- [../core/data-model.md](../core/data-model.md)
- [person-record.schema.md](person-record.schema.md)
- [activity-record.schema.md](activity-record.schema.md)
