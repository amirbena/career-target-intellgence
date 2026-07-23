# Research State Schema

The Research State record is a logical representation of the current progress of a candidate research journey, based on the context available to the running platform. It exists to prevent unnecessary repetition and to support resuming work within the context the platform makes available. It is separate from the [Candidate Profile](candidate-profile.schema.md) (who the candidate is) and the [Search Criteria](search-criteria.schema.md) (what should be searched for).

This is a logical record. See [core/data-model.md](../core/data-model.md) for the principles that govern how it should be interpreted and populated, including the [Context Boundary](../core/data-model.md#context-boundary) between this model and platform-managed persistence. These are logical references, not an assumption of any specific database or file system.

Research State is not a storage mechanism and is not guaranteed to survive across conversations. It may be reconstructed from the available conversation or workspace context, and it may be used across multiple conversations when the platform exposes the same Project or workspace context to the product. Platform chat IDs, thread IDs, or Project IDs are not part of the canonical logical model.

## Research Identity

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `research_id` | string | Required | A logical identifier for this research journey. | `"research-2026-07-20-dana-levi"` |
| `candidate_name` | string | Required | The candidate this research journey belongs to. | `"Dana Levi"` |
| `created_at` | timestamp | Required | When this research journey was created. | `"2026-07-20T09:00:00Z"` |
| `last_updated_at` | timestamp | Required | When this research journey was last updated. | `"2026-07-20T10:30:00Z"` |

## Current Status

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `current_stage` | string | Required | The stage currently being worked on. | `"company_discovery"` |
| `journey_mode` | enum: `Full Journey`, `Focused Task`, `Resume Journey` | Required | The mode this research journey is operating in. | `"Focused Task"` |
| `overall_status` | enum: `Not Started`, `In Progress`, `Blocked`, `Completed`, `Stale` | Required | The overall status of the research journey. | `"In Progress"` |

## Stage Statuses

Each stage below uses the same status enum: `Not Started`, `Draft`, `Completed`, `Approved`, `Stale`, `Superseded`, `Not Requested`.

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `candidate_analysis_status` | enum | Required | Status of the Candidate Analysis stage (building the Candidate Profile). | `"Approved"` |
| `search_criteria_status` | enum | Required | Status of the Search Criteria stage. | `"Approved"` |
| `company_discovery_status` | enum | Required | Status of the Company Discovery stage. | `"Not Started"` |
| `company_classification_status` | enum | Required | Status of the Company Classification stage. | `"Not Started"` |
| `company_ranking_status` | enum | Required | Status of the Company Ranking stage. | `"Not Started"` |
| `company_selection_status` | enum | Required | Status of the Company Selection stage. | `"Not Started"` |
| `people_discovery_status` | enum | Required | Status of the People Discovery stage (recruiters and potential hiring managers). | `"Not Started"` |
| `activity_verification_status` | enum | Required | Status of the Activity Verification stage. | `"Not Requested"` |
| `outreach_queue_status` | enum | Required | Status of the Outreach Queue stage. | `"Not Started"` |
| `export_status` | enum | Required | Status of the optional Export stage. | `"Not Started"` |

Stage names align with the [workflow modules](../core/workflow.md#workflow-modules) — see [full-journey.md](../workflows/full-journey.md) for each stage's purpose, inputs, outputs, and quality gate.

## Saved References

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `candidate_profile_reference` | logical reference | Optional | A reference to the approved Candidate Profile. | `"candidate-profile:dana-levi:v2"` |
| `search_criteria_reference` | logical reference | Optional | A reference to the current Search Criteria. | `"search-criteria:dana-levi:v1"` |
| `selected_companies` | list of logical references | Optional | References to companies selected during this research journey. | `[]` |
| `completed_outputs` | list of strings | Optional | Outputs that have been completed. | `["Candidate Profile"]` |
| `pending_outputs` | list of strings | Optional | Outputs that are still pending. | `["Target Company Map"]` |

## Progress and Continuation

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `last_completed_stage` | string | Optional | The most recently completed stage. | `"search_criteria"` |
| `recommended_next_stage` | string | Optional | The stage recommended to run next. | `"company_discovery"` |
| `blocking_issues` | list of strings | Optional | Issues currently blocking progress. | `[]` |
| `open_questions` | list of strings | Optional | Unresolved questions relevant to this research journey. | `[]` |
| `refresh_required` | boolean | Optional | Whether any part of this research journey requires a refresh. | `false` |
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
candidate_analysis_status: "Approved"
search_criteria_status: "Approved"
company_discovery_status: "Not Started"
recommended_next_stage: "company_discovery"
```

## Related documents

- [../core/data-model.md](../core/data-model.md)
- [../core/workflow.md](../core/workflow.md)
- [../workflows/full-journey.md](../workflows/full-journey.md)
- [candidate-profile.schema.md](candidate-profile.schema.md)
- [search-criteria.schema.md](search-criteria.schema.md)
