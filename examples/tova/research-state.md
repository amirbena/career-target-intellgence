# Research State — Tova (Golden Example)

Built following the [Research State schema](../../schemas/research-state.schema.md). This is a logical progress record only — it does not represent any real storage mechanism, per the schema's [Context Boundary](../../core/data-model.md#context-boundary).

## Research Identity

| Field | Value |
|---|---|
| `research_id` | `research-2026-07-23-tova-golden-example` |
| `candidate_name` | Tova |
| `created_at` | 2026-07-23T08:00:00Z |
| `last_updated_at` | 2026-07-23T09:00:00Z |

## Current Status

| Field | Value |
|---|---|
| `current_stage` | `outreach_queue` |
| `journey_mode` | Full Journey |
| `overall_status` | Completed |

## Stage Statuses

| Field | Value |
|---|---|
| `candidate_analysis_status` | Approved |
| `search_criteria_status` | Approved |
| `company_discovery_status` | Completed |
| `company_classification_status` | Completed |
| `company_ranking_status` | Completed |
| `company_selection_status` | Approved |
| `people_discovery_status` | Completed |
| `activity_verification_status` | Completed |
| `outreach_queue_status` | Completed |
| `export_status` | Not Started |

## Saved References

| Field | Value |
|---|---|
| `candidate_profile_reference` | `candidate-profile:tova-golden-example:v1` |
| `search_criteria_reference` | `search-criteria:tova-golden-example:v1` |
| `selected_companies` | IndustrialFlow Systems, BillingMesh, FactoryCore, EnterpriseOps Suite, ProcessGrid, DataWorks Product Labs |
| `completed_outputs` | Candidate Profile, Search Criteria, Company Map, Excluded Companies Report, People Map, Activity Verification Report, Outreach Priority Queue |
| `pending_outputs` | CSV-compatible export |

## Progress and Continuation

| Field | Value |
|---|---|
| `last_completed_stage` | Outreach Queue |
| `recommended_next_stage` | Optional Export |
| `blocking_issues` | *(none)* |
| `open_questions` | Eitan Shalev's current employment status at FactoryCore remains unresolved; Noa Cohen's identity at DataWorks Product Labs remains ambiguous. |
| `refresh_required` | false |
| `refresh_reason` | *(not applicable — `refresh_required` is false)* |

## Related documents

- [../../schemas/research-state.schema.md](../../schemas/research-state.schema.md)
- [../../workflows/full-journey.md](../../workflows/full-journey.md)
- [outreach-queue.md](outreach-queue.md)
- [evaluation-notes.md](evaluation-notes.md)
