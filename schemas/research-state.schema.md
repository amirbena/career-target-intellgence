# Research State Schema

The Research State record describes what has already been completed, approved, or needs refresh in a candidate's research journey. It exists to prevent unnecessary repetition and to support resuming work. It is separate from the [Candidate Profile](candidate-profile.schema.md) (who the candidate is) and the [Search Criteria](search-criteria.schema.md) (what should be searched for).

This is a logical record. See [core/data-model.md](../core/data-model.md) for the principles that govern how it should be interpreted and populated. These are logical references, not an assumption of any specific database or file system.

## Session Identity

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `research_id` | string | Required | A logical identifier for this research session. | `"research-2026-07-20-dana-levi"` |
| `candidate_name` | string | Required | The candidate this research session belongs to. | `"Dana Levi"` |
| `created_at` | timestamp | Required | When this research session was created. | `"2026-07-20T09:00:00Z"` |
| `last_updated_at` | timestamp | Required | When this research session was last updated. | `"2026-07-20T10:30:00Z"` |

## Current Status

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `current_stage` | string | Required | The stage currently being worked on. | `"company_discovery"` |
| `journey_mode` | enum: `Full Journey`, `Focused Task`, `Resume Journey` | Required | The mode this research session is operating in. | `"Focused Task"` |
| `overall_status` | enum: `Not Started`, `In Progress`, `Blocked`, `Completed`, `Stale` | Required | The overall status of the research session. | `"In Progress"` |

## Stage Statuses

Each stage below uses the same status enum: `Not Started`, `Draft`, `Completed`, `Approved`, `Stale`, `Superseded`, `Not Requested`.

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `candidate_profile_status` | enum | Required | Status of the Candidate Profile. | `"Approved"` |
| `search_criteria_status` | enum | Required | Status of the Search Criteria. | `"Approved"` |
| `company_discovery_status` | enum | Required | Status of target company discovery. | `"Not Started"` |
| `company_classification_status` | enum | Required | Status of product-company classification/filtering. | `"Not Started"` |
| `company_ranking_status` | enum | Required | Status of company prioritization/ranking. | `"Not Started"` |
| `company_selection_status` | enum | Required | Status of final company selection. | `"Not Started"` |
| `recruiter_research_status` | enum | Required | Status of recruiter discovery. | `"Not Started"` |
| `hiring_manager_research_status` | enum | Required | Status of hiring manager discovery. | `"Not Started"` |
| `activity_verification_status` | enum | Required | Status of activity verification. | `"Not Requested"` |
| `outreach_queue_status` | enum | Required | Status of the outreach priority queue. | `"Not Started"` |
| `export_status` | enum | Required | Status of any requested export. | `"Not Started"` |

## Saved References

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `candidate_profile_reference` | logical reference | Optional | A reference to the approved Candidate Profile. | `"candidate-profile:dana-levi:v2"` |
| `search_criteria_reference` | logical reference | Optional | A reference to the current Search Criteria. | `"search-criteria:dana-levi:v1"` |
| `selected_companies` | list of logical references | Optional | References to companies selected during this research session. | `[]` |
| `completed_outputs` | list of strings | Optional | Outputs that have been completed. | `["Candidate Profile"]` |
| `pending_outputs` | list of strings | Optional | Outputs that are still pending. | `["Target Company Map"]` |

## Progress and Continuation

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `last_completed_stage` | string | Optional | The most recently completed stage. | `"search_criteria"` |
| `recommended_next_stage` | string | Optional | The stage recommended to run next. | `"company_discovery"` |
| `blocking_issues` | list of strings | Optional | Issues currently blocking progress. | `[]` |
| `open_questions` | list of strings | Optional | Unresolved questions relevant to this research session. | `[]` |
| `refresh_required` | boolean | Optional | Whether any part of this research session requires a refresh. | `false` |
| `refresh_reason` | string | Optional | The reason a refresh is required, if applicable. | `""` |

## Research State Rules

1. Approved work should not be repeated automatically.
2. A focused task should execute only the required stages.
3. A resumed journey should begin from the latest valid state.
4. Public research may become stale independently of the Candidate Profile.
5. A changed commute limit should not automatically invalidate unrelated candidate data.
6. A stage may be `Not Requested` without blocking the journey.
7. Export is an output action, not proof that research is complete.
8. No state value may imply scheduled or background monitoring.
9. Every external research refresh must follow an explicit user request.
10. Superseded records must not silently replace approved records without traceability.

## Example Record

```text
research_id: "research-2026-07-20-dana-levi"
candidate_name: "Dana Levi"
journey_mode: "Focused Task"
overall_status: "In Progress"
candidate_profile_status: "Approved"
search_criteria_status: "Approved"
company_discovery_status: "Not Started"
recommended_next_stage: "company_discovery"
```

## Related documents

- [../core/data-model.md](../core/data-model.md)
- [candidate-profile.schema.md](candidate-profile.schema.md)
- [search-criteria.schema.md](search-criteria.schema.md)
