# Workflow Routing

Adapts the three operating modes and the module routing logic for execution
inside Claude.

**Canonical sources:** [`core/workflow.md`](../../../core/workflow.md),
[`workflows/full-journey.md`](../../../workflows/full-journey.md),
[`workflows/focused-task-routing.md`](../../../workflows/focused-task-routing.md),
[`workflows/resume-journey.md`](../../../workflows/resume-journey.md),
[`schemas/research-state.schema.md`](../../../schemas/research-state.schema.md).

## Routing principle

> Use the minimum required workflow modules needed to satisfy the current
> request while preserving all applicable evidence, freshness, ranking, and
> quality-gate rules.

## Full Journey

The complete, ordered pipeline:

Candidate Input → Candidate Analysis → Search Criteria → Company Discovery →
Company Classification → Company Ranking → Company Selection → People
Discovery → Activity Verification → Outreach Queue → Optional Export.

Cross-cutting rules:

1. A Candidate Profile must exist before Search Criteria.
2. Company discovery may proceed from an explicit Search Criteria.
3. Classification happens before final ranking.
4. Excluded companies do not proceed to final ranking.
5. People discovery operates on selected or prioritized companies.
6. Activity verification is not automatic — only run it if the user
   explicitly requested it, or explicitly included it in the requested
   journey.
7. The Outreach Queue requires sufficient company and person evidence to be
   meaningful.
8. Export is optional and user-initiated; it is never proof that the
   research itself is complete.

Company Selection is the point where the user reviews the ranked Company
Map and confirms which companies carry forward into People Discovery — it
is not a re-scoring step.

## Focused Task

Enter a specific module directly instead of running the full pipeline. This
table is illustrative, not exhaustive — anything not listed is still
governed by the routing principle above.

| Request | Route to |
|---|---|
| "Analyze this resume" | Analyze Candidate |
| "Find 30 companies" | Search Criteria → Discover Companies → Classify and Rank Companies |
| "Find recruiters at these companies" | Discover People |
| "Find managers who may manage this profile" | Discover People, scoped to Engineering Manager / Group Manager / Director of Engineering / Head of R&D / VP R&D |
| "Check who posted jobs recently" | Verify Activity |
| "Why is this Priority 2?" | Explain the existing ranking only — do not re-run the module |
| "Change commute to 20 minutes" | Update Search Criteria, then refresh only the location-dependent Company Record fields |
| "Create an outreach list" | Build Outreach Queue |
| "Export this to CSV" | Export the existing approved output only — do not re-run the module |

**Prerequisite behavior:** use context already available; do not re-ask for
known information; ask a clarifying question only when the gap is genuinely
blocking; use a labeled assumption for a non-blocking gap; never silently
trigger a module the user did not ask for.

## Resume Journey

Continues from the latest valid Research State present in the active
conversation context. No cross-chat persistence is assumed — if no Research
State is visible in context, do not fabricate one; proceed as a fresh Full
Journey or Focused Task instead.

When a Research State is present, read `current_stage`, `overall_status`,
and every stage-specific status field. Each stage status uses the shared
seven-value enum:

`Not Started`, `Draft`, `Completed`, `Approved`, `Stale`, `Superseded`,
`Not Requested`.

- `Completed` / `Approved` — usable as-is; do not rebuild without a stated
  reason.
- `Draft` — finish it, do not restart it.
- `Stale` — needs a refresh before reuse.
- `Superseded` — explicitly replaced; keep it traceable rather than
  discarding it.
- `Not Requested` — most commonly `activity_verification_status`; this is
  not automatically a gap to fill.

Resume forward using `recommended_next_stage` (falling back to
`last_completed_stage`) without re-running upstream stages that are already
`Completed` or `Approved`.

**Refresh only what is stale.** Refresh only the stages actually marked
Stale or `refresh_required`, never the whole journey. Do not refresh the
Candidate Profile or Search Criteria merely because downstream public
research has gone stale.

### Rules

1. An `Approved` Candidate Profile is reused, not rebuilt.
2. Updated Search Criteria invalidate only the results they actually
   affect.
3. Activity and hiring evidence may go stale independently of everything
   else.
4. Missing prior Research State must be acknowledged, not assumed away.
5. A focused task may proceed with sufficient user-supplied context even
   without any prior Research State.

## Workflow modules

| Module | File | Applies |
|---|---|---|
| Analyze Candidate | `workflows/analyze-candidate.md` | Candidate Profile schema |
| Build Search Criteria | `workflows/build-search-criteria.md` | Search Criteria schema |
| Discover Companies | `workflows/discover-companies.md` | Company Record schema |
| Classify and Rank Companies | `workflows/classify-and-rank-companies.md` | Exclusion Policy, Company Ranking Model |
| Discover People | `workflows/discover-people.md` | Person Record schema, Person Ranking Model |
| Verify Activity | `workflows/verify-activity.md` | Activity Record schema |
| Build Outreach Queue | `workflows/build-outreach-queue.md` | Outreach Priority Model |

Company Selection and Export are decision points inside the Full Journey and
Focused Task Routing logic, not independent modules.
