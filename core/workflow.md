# Core Workflow

This document defines how the product routes and executes research work across the existing [data model](data-model.md), [trust policy](source-policy.md), and [ranking models](../ranking/company-ranking-model.md). It is platform-independent — the [Role of the GPT, Project, and Skill](data-model.md#role-of-the-gpt-project-and-skill) section of the core data model still applies: this workflow describes logic and routing, not a platform-specific implementation.

The workflow is **structured but flexible**. It must:

- support a full end-to-end journey;
- support focused tasks;
- resume from available context;
- avoid repeating approved work;
- run only the modules required by the user's request.

## Operating Modes

### Full Journey

The complete, ordered path from candidate input to an outreach-ready result:

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

See [workflows/full-journey.md](../workflows/full-journey.md) for the per-stage definition.

### Focused Task

The user may enter directly into a specific module when sufficient context is already available — for example: provide companies and request recruiters, request managers for selected companies, verify activity for existing people, explain an existing ranking, rebuild an outreach queue, or change commute constraints and refresh only the affected companies.

See [workflows/focused-task-routing.md](../workflows/focused-task-routing.md) for routing rules and examples.

### Resume Journey

Continue from the latest valid [Research State](../schemas/research-state.schema.md) available in the active platform context. Resuming does **not** assume cross-chat persistence — see the [Context Boundary](data-model.md#context-boundary). A journey may only be resumed from context the platform actually provides; when no prior context is available, the product proceeds as a fresh Full Journey or Focused Task instead of pretending to remember one.

See [workflows/resume-journey.md](../workflows/resume-journey.md) for details.

## Routing Principle

> Use the minimum required workflow modules needed to satisfy the current request while preserving all applicable evidence, freshness, ranking, and quality-gate rules.

This principle governs all three operating modes. It means:

- a focused task never triggers unrelated modules;
- a resumed journey never rebuilds approved, still-fresh work;
- even a Full Journey may skip a module when its preconditions are already satisfied by approved, non-stale state — see [Research State Rules](../schemas/research-state.schema.md#research-state-rules).

## Workflow Modules

Each module below is documented independently in [workflows/](../workflows/) and refers back to the schemas, trust policy, and ranking models it applies — it does not redefine them.

| Module | File | Applies |
|---|---|---|
| Analyze Candidate | [workflows/analyze-candidate.md](../workflows/analyze-candidate.md) | [Candidate Profile schema](../schemas/candidate-profile.schema.md) |
| Build Search Criteria | [workflows/build-search-criteria.md](../workflows/build-search-criteria.md) | [Search Criteria schema](../schemas/search-criteria.schema.md) |
| Discover Companies | [workflows/discover-companies.md](../workflows/discover-companies.md) | [Company Record schema](../schemas/company-record.schema.md) |
| Classify and Rank Companies | [workflows/classify-and-rank-companies.md](../workflows/classify-and-rank-companies.md) | [Exclusion Policy](../ranking/exclusion-policy.md), [Company Ranking Model](../ranking/company-ranking-model.md) |
| Discover People | [workflows/discover-people.md](../workflows/discover-people.md) | [Person Record schema](../schemas/person-record.schema.md), [Person Ranking Model](../ranking/person-ranking-model.md) |
| Verify Activity | [workflows/verify-activity.md](../workflows/verify-activity.md) | [Activity Record schema](../schemas/activity-record.schema.md) |
| Build Outreach Queue | [workflows/build-outreach-queue.md](../workflows/build-outreach-queue.md) | [Outreach Priority Model](../ranking/outreach-priority-model.md) |

Company Selection and Export are decision points within [full-journey.md](../workflows/full-journey.md) and [focused-task-routing.md](../workflows/focused-task-routing.md) rather than independent modules — selection is a user review step on already-ranked output, and export packages an already-approved output rather than producing new evidence.

## Related documents

- [data-model.md](data-model.md)
- [source-policy.md](source-policy.md)
- [confidence-model.md](confidence-model.md)
- [freshness-policy.md](freshness-policy.md)
- [quality-gates.md](quality-gates.md)
- [../ranking/company-ranking-model.md](../ranking/company-ranking-model.md)
- [../ranking/person-ranking-model.md](../ranking/person-ranking-model.md)
- [../ranking/exclusion-policy.md](../ranking/exclusion-policy.md)
- [../ranking/outreach-priority-model.md](../ranking/outreach-priority-model.md)
- [../schemas/research-state.schema.md](../schemas/research-state.schema.md)
