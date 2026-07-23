# Full Journey

The Full Journey is the complete, ordered path from candidate input to an outreach-ready result, as introduced in [core/workflow.md](../core/workflow.md). It coordinates the workflow modules but does not redefine the rules already established by the schemas, trust policy, and ranking models it invokes.

```text
Candidate Input
        ↓
Candidate Analysis
        ↓
Search Criteria
        ↓
Company Discovery
        ↓
Company Classification
        ↓
Company Ranking
        ↓
Company Selection
        ↓
People Discovery
        ↓
Activity Verification
        ↓
Outreach Queue
        ↓
Optional Export
```

## Stages

### Candidate Analysis

- **Purpose:** Build the [Candidate Profile](../schemas/candidate-profile.schema.md) from available input.
- **Required inputs:** A resume, a description of the candidate's background, or equivalent candidate-provided context.
- **Outputs:** A Candidate Profile with `profile_status` of Draft or Approved.
- **State transition:** `candidate_analysis_status` moves from Not Started → Draft → Approved.
- **Quality gate:** See [Candidate Profile Rules](../schemas/candidate-profile.schema.md#candidate-profile-rules) — no invented experience, no inflated seniority, no unsupported management inference.
- **Conditions for skipping:** An Approved Candidate Profile already exists in the available context and the user has not indicated changes.
- **Conditions requiring refresh:** The user explicitly corrects or expands their background.

### Search Criteria

- **Purpose:** Build the [Search Criteria](../schemas/search-criteria.schema.md) that will guide company discovery.
- **Required inputs:** An Approved (or at least Draft) Candidate Profile, plus any explicit user constraints.
- **Outputs:** Search Criteria with `criteria_status` of Draft or Ready.
- **State transition:** `search_criteria_status` moves from Not Started → Draft → Ready.
- **Quality gate:** See [Search Criteria Rules](../schemas/search-criteria.schema.md#search-criteria-rules) — commute limits stay configurable, product-only filtering stays explicit.
- **Conditions for skipping:** Ready Search Criteria already exist and the user has not indicated changes.
- **Conditions requiring refresh:** The user changes a constraint (e.g., commute limit, company type).

**Rule 1:** Candidate Profile must exist before building candidate-specific Search Criteria.

### Company Discovery

- **Purpose:** Identify a broad set of candidate companies matching the Search Criteria, before any filtering or ranking.
- **Required inputs:** Ready Search Criteria.
- **Outputs:** Draft [Company Records](../schemas/company-record.schema.md) with `record_status` of Draft.
- **State transition:** `company_discovery_status` moves from Not Started → Draft → Completed.
- **Quality gate:** See [source-policy.md](../core/source-policy.md) — identity and location claims must be sourced.
- **Conditions for skipping:** A completed discovery set already exists for the current Search Criteria and has not been invalidated.
- **Conditions requiring refresh:** Search Criteria change in a way that affects the discovery scope (e.g., company-type or domain constraints).

**Rule 2:** Company discovery may proceed from explicit Search Criteria.

### Company Classification

- **Purpose:** Classify discovered companies by type and apply the [Exclusion Policy](../ranking/exclusion-policy.md).
- **Required inputs:** Draft Company Records.
- **Outputs:** Company Records with `company_type`, `exclusion_status`, and `exclusion_reason` (when applicable) populated.
- **State transition:** `company_classification_status` moves from Not Started → Draft → Completed.
- **Quality gate:** See [Company Record Rules](../schemas/company-record.schema.md#company-record-rules) and the [Exclusion Policy](../ranking/exclusion-policy.md) — Unclear type becomes Needs Review, not automatic Excluded.
- **Conditions for skipping:** Classification is already complete and Search Criteria have not changed in a way that affects classification.
- **Conditions requiring refresh:** New company-type evidence appears, or Search Criteria's type constraints change.

### Company Ranking

- **Purpose:** Apply the [Company Ranking Model](../ranking/company-ranking-model.md) to Included companies.
- **Required inputs:** Classified Company Records with `exclusion_status` of Included or Needs Review.
- **Outputs:** Scored Company Records with a Priority tier (or provisional score for Needs Review).
- **State transition:** `company_ranking_status` moves from Not Started → Draft → Completed.
- **Quality gate:** See [Company Ranking Model Rules](../ranking/company-ranking-model.md#rules) — every score carries written reasoning.
- **Conditions for skipping:** Ranking is already complete and no ranking-relevant evidence has changed.
- **Conditions requiring refresh:** Classification changes, or fit-relevant Company Record fields are updated.

**Rule 3:** Company classification happens before final ranking.
**Rule 4:** Excluded companies do not proceed to final ranking.

### Company Selection

- **Purpose:** Let the user review the ranked companies and confirm which to carry forward into People Discovery.
- **Required inputs:** A completed, ranked company set.
- **Outputs:** A `selected_companies` list on the [Research State](../schemas/research-state.schema.md).
- **State transition:** `company_selection_status` moves from Not Started → Draft → Approved.
- **Quality gate:** Selection must reflect the ranked evidence presented; it is a user decision point, not a re-scoring step.
- **Conditions for skipping:** The user has already approved a selection and has not requested changes to the ranked set.
- **Conditions requiring refresh:** The ranking changes materially, or the user requests a different selection.

### People Discovery

- **Purpose:** Find recruiters and potential hiring managers at selected companies.
- **Required inputs:** Selected companies.
- **Outputs:** [Person Records](../schemas/person-record.schema.md) with employment verification and `person_type` classification.
- **State transition:** `people_discovery_status` moves from Not Started → Draft → Completed.
- **Quality gate:** See [Person Record Rules](../schemas/person-record.schema.md#person-record-rules) — current employment verified or marked unresolved.
- **Conditions for skipping:** People Discovery already completed for the selected companies.
- **Conditions requiring refresh:** Company selection changes, or existing Person Records become stale.

**Rule 5:** People discovery operates on selected or prioritized companies.

### Activity Verification

- **Purpose:** Apply A0–A4 activity levels to discovered people, per the [Activity Record schema](../schemas/activity-record.schema.md).
- **Required inputs:** Person Records, plus an explicit lookback window.
- **Outputs:** [Activity Records](../schemas/activity-record.schema.md) linked to Person Records.
- **State transition:** `activity_verification_status` moves from Not Requested → Draft → Completed (or stays Not Requested if not included).
- **Quality gate:** See [Activity Record Rules](../schemas/activity-record.schema.md#activity-record-rules) — A2+ requires a specific dated post; job status verified separately.
- **Conditions for skipping:** Not requested, or already completed within the current lookback window.
- **Conditions requiring refresh:** The user explicitly requests a new check, or the lookback window changes.

**Rule 6:** Activity verification is not automatic unless explicitly included in the requested journey.

### Outreach Queue

- **Purpose:** Apply the [Outreach Priority Model](../ranking/outreach-priority-model.md) to produce a prioritized, advisory action list.
- **Required inputs:** Ranked companies, discovered people, and (when included) Activity Records.
- **Outputs:** An Outreach Priority Queue.
- **State transition:** `outreach_queue_status` moves from Not Started → Draft → Completed.
- **Quality gate:** See [outreach-priority-model.md](../ranking/outreach-priority-model.md) — recommendations remain advisory and manual.
- **Conditions for skipping:** An up-to-date queue already exists.
- **Conditions requiring refresh:** Underlying company, person, or activity evidence changes.

**Rule 7:** Outreach Queue requires sufficient company and person evidence.

### Optional Export

- **Purpose:** Package an already-approved output (e.g., the Outreach Queue) as Markdown or CSV-compatible text.
- **Required inputs:** An approved output to export.
- **Outputs:** An exported representation of that output.
- **State transition:** `export_status` moves from Not Started → Completed.
- **Quality gate:** Export must not be treated as proof that research is complete — see [Research State Rules](../schemas/research-state.schema.md#research-state-rules), rule 7.
- **Conditions for skipping:** Not requested.
- **Conditions requiring refresh:** Not applicable — export is user-initiated each time.

**Rule 8:** Export is optional and user-initiated.

## Related documents

- [../core/workflow.md](../core/workflow.md)
- [focused-task-routing.md](focused-task-routing.md)
- [resume-journey.md](resume-journey.md)
- [../schemas/research-state.schema.md](../schemas/research-state.schema.md)
