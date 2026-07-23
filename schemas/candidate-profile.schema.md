# Candidate Profile Schema

The Candidate Profile describes who the candidate is professionally: background, experience, technologies, domains, and demonstrated responsibility. It does not contain search preferences (see [Search Criteria](search-criteria.schema.md)) or research progress (see [Research State](research-state.schema.md)).

This is a logical record. See [core/data-model.md](../core/data-model.md) for the principles that govern how it should be interpreted and populated.

## Identity

| Field | Type | Required | Description | Source expectations | Example |
|---|---|---|---|---|---|
| `candidate_name` | string | Required | The candidate's name. | User-provided. | `"Dana Levi"` |
| `current_location` | string | Optional | The candidate's current city or area. | User-provided or observed in a source document. | `"Bnei Brak"` |
| `location_source` | enum: `User-provided`, `Observed`, `Assumed`, `Unknown` | Required | Where `current_location` came from. | Must accompany `current_location`. | `"User-provided"` |

Do not require personal contact details (phone, email, address) as part of this profile.

## Professional Level

| Field | Type | Required | Description | Source expectations | Example |
|---|---|---|---|---|---|
| `current_title` | string | Optional | The candidate's most recent or current title. | Observed or user-provided. | `"Senior Software Engineer"` |
| `seniority` | enum: `Junior`, `Mid-level`, `Senior`, `Lead`, `Staff`, `Principal`, `Manager`, `Unknown` | Required | The candidate's seniority level. | Must be based on evidence of scope and responsibility, not years alone. | `"Senior"` |
| `years_of_experience` | number | Optional | Total years of relevant professional experience. | Observed or user-provided. | `9` |
| `target_roles` | list of strings | Optional | Roles the candidate is aiming for. | User-provided. | `["Senior Backend Engineer"]` |

Do not infer `seniority` from `years_of_experience` alone; seniority must reflect demonstrated scope, ownership, and responsibility.

## Technologies

| Field | Type | Required | Description | Source expectations | Example |
|---|---|---|---|---|---|
| `primary_technologies` | list of strings | Optional | Technologies with substantial, hands-on experience. | Observed with supporting evidence. | `["C#", "SQL Server"]` |
| `secondary_technologies` | list of strings | Optional | Technologies with meaningful but not central experience. | Observed with supporting evidence. | `["Redis"]` |
| `familiar_technologies` | list of strings | Optional | Technologies the candidate has been exposed to but should not be presented as strong experience. | Observed or user-provided. | `["Kafka"]` |
| `technology_evidence` | list of strings | Optional | Notes or citations supporting the classification above. | Observed. | `["3 years leading billing service in C#"]` |

**Primary** means substantial hands-on experience. **Secondary** means meaningful but not central experience. **Familiar** means exposure that must not be presented as strong experience.

## Professional Domains

| Field | Type | Required | Description | Source expectations | Example |
|---|---|---|---|---|---|
| `domains` | list of strings | Optional | Business or industry domains the candidate has worked in. | Observed. | `["billing", "manufacturing"]` |
| `system_types` | list of strings | Optional | Types of systems the candidate has built or operated. | Observed. | `["distributed systems", "internal platforms"]` |
| `business_process_experience` | list of strings | Optional | Business processes the candidate has direct experience with. | Observed. | `["invoicing workflows"]` |
| `integration_experience` | list of strings | Optional | Systems or third-party integrations the candidate has built. | Observed. | `["payment gateway integration"]` |
| `production_experience` | list of strings | Optional | Evidence of operating systems in production. | Observed. | `["on-call for billing platform"]` |

Examples of domains include payments, billing, manufacturing, fintech, enterprise software, workflow systems, distributed systems, and internal platforms.

## Responsibility and Impact

| Field | Type | Required | Description | Source expectations | Example |
|---|---|---|---|---|---|
| `ownership_signals` | list of strings | Optional | Evidence the candidate owned a system or outcome. | Observed. | `["owned billing service end-to-end"]` |
| `leadership_signals` | list of strings | Optional | Evidence of leading initiatives or people. | Observed. | `["led migration to microservices"]` |
| `mentoring_signals` | list of strings | Optional | Evidence of mentoring other engineers. | Observed. | `["mentored two junior engineers"]` |
| `architecture_signals` | list of strings | Optional | Evidence of architectural decision-making. | Observed. | `["designed event-driven billing architecture"]` |
| `production_support_signals` | list of strings | Optional | Evidence of supporting live systems. | Observed. | `["primary on-call responder"]` |
| `measurable_impact` | list of strings | Optional | Quantified outcomes attributable to the candidate. | Observed. | `["reduced billing errors by 30%"]` |

Do not convert technical support or participation into formal people management without direct evidence.

## Preferences and Constraints

| Field | Type | Required | Description | Source expectations | Example |
|---|---|---|---|---|---|
| `preferred_roles` | list of strings | Optional | Roles the candidate prefers. | User-provided. | `["Backend Engineer"]` |
| `excluded_roles` | list of strings | Optional | Roles the candidate wants to avoid. | User-provided. | `["People Manager"]` |
| `preferred_domains` | list of strings | Optional | Domains the candidate prefers to work in. | User-provided. | `["fintech"]` |
| `excluded_domains` | list of strings | Optional | Domains the candidate wants to avoid. | User-provided. | `["gambling"]` |
| `preferred_company_types` | list of strings | Optional | Company types the candidate prefers. | User-provided. | `["product companies"]` |
| `excluded_company_types` | list of strings | Optional | Company types the candidate wants to avoid. | User-provided. | `["outsourcing houses"]` |
| `work_model_preferences` | list of strings | Optional | Preferred work models (e.g., hybrid, remote, on-site). | User-provided. | `["hybrid"]` |
| `geographic_constraints` | list of strings | Optional | Geographic limitations relevant to the candidate. | User-provided. | `["central Israel only"]` |

These are durable preferences that may come directly from the candidate rather than from a resume, and they may differ from what a resume alone would suggest.

## Evidence and Confidence

| Field | Type | Required | Description | Source expectations | Example |
|---|---|---|---|---|---|
| `source_documents` | list of strings | Optional | Identifiers or descriptions of documents used to build this profile. | Observed. | `["resume_2026.pdf"]` |
| `user_confirmed_fields` | list of strings | Optional | Fields the candidate has explicitly confirmed. | User-provided. | `["seniority", "current_title"]` |
| `inferred_fields` | list of strings | Optional | Fields the model inferred rather than observed directly. | Model inference. | `["domains"]` |
| `assumptions` | list of strings | Optional | Labeled assumptions made while building the profile. | Model inference. | `["assumed full-time employment history"]` |
| `uncertainties` | list of strings | Optional | Known gaps or ambiguities in the profile. | Model inference. | `["unclear whether role was people-management"]` |
| `profile_status` | enum: `Draft`, `Approved`, `Superseded` | Required | The current status of the profile. | — | `"Approved"` |
| `last_updated_at` | timestamp | Required | When the profile was last updated. | — | `"2026-07-20T10:00:00Z"` |

## Candidate Profile Rules

1. Do not invent missing experience.
2. Do not upgrade familiarity into expertise.
3. Do not infer formal management without evidence.
4. Preserve user corrections over model inference.
5. Keep conflicting evidence visible until resolved.
6. An approved profile should not be rebuilt without a reason.
7. Location and commute preferences must not be hardcoded.

## Example Record

```text
candidate_name: "Dana Levi"
current_location: "Bnei Brak"
location_source: "User-provided"
current_title: "Senior Software Engineer"
seniority: "Senior"
years_of_experience: 9
primary_technologies: ["C#", "SQL Server"]
domains: ["enterprise billing", "manufacturing"]
profile_status: "Approved"
last_updated_at: "2026-07-20T10:00:00Z"
```

## Related documents

- [../core/data-model.md](../core/data-model.md)
- [search-criteria.schema.md](search-criteria.schema.md)
- [research-state.schema.md](research-state.schema.md)
