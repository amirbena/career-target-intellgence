# Resume Journey

Resume Journey continues a research journey from the latest valid [Research State](../schemas/research-state.schema.md) available in the active platform context, as introduced in [core/workflow.md](../core/workflow.md#resume-journey). It does not assume cross-chat persistence — see the [Context Boundary](../core/data-model.md#context-boundary).

## Inspecting Available Research State

- Check whether a Research State record is present in the active context (conversation, Project, or workspace, per [Platform-Managed Persistence](../core/data-model.md#platform-managed-persistence)).
- If none is available, do not fabricate one — proceed as a fresh Full Journey or Focused Task instead.
- If one is available, read `current_stage`, `overall_status`, and every stage status field to understand what has already happened.

## Identifying Stage States

Using the [Stage Statuses](../schemas/research-state.schema.md#stage-statuses) enum (`Not Started`, `Draft`, `Completed`, `Approved`, `Stale`, `Superseded`, `Not Requested`):

- **Completed or Approved** stages represent usable prior work and should not be rebuilt without a reason.
- **Draft** stages represent partial work that may need to be finished, not restarted.
- **Stale** stages represent work that was once valid but needs a refresh before reuse — see [freshness-policy.md](../core/freshness-policy.md).
- **Superseded** stages represent work that has been explicitly replaced; the replacement must be traceable per [Research State Rules](../schemas/research-state.schema.md#research-state-rules), rule 10.
- **Not Requested** stages (most commonly `activity_verification_status`) are not gaps to fill automatically — they simply were not part of the requested scope.

## Continuing From the Latest Valid Stage

- Use `recommended_next_stage` (or `last_completed_stage` when `recommended_next_stage` is absent) to determine where to resume.
- Resume forward from that stage using the [Full Journey](full-journey.md) stage definitions, without re-running Completed/Approved stages upstream of it.

## Refreshing Only Stale Public Research

- Refresh only the specific stage(s) marked Stale or flagged via `refresh_required`/`refresh_reason`, not the entire journey.
- Candidate Profile and Search Criteria are not refreshed just because downstream public research (companies, people, activity) is stale — see [freshness-policy.md](../core/freshness-policy.md), rule 8.

## Avoiding Rebuilds of Stable Candidate Information

- An Approved Candidate Profile is reused as-is unless the user explicitly corrects or expands it.
- Do not re-run Candidate Analysis solely because downstream company or people research has gone stale.

## Explicit Corrections Supersede Prior Inference

- When the user provides a correction during a resumed journey, it takes precedence over any prior inference recorded in the resumed state — consistent with [Core Rules](../core/data-model.md#core-rules), rule 3.

## Rules

1. Approved Candidate Profiles are reused.
2. Updated Search Criteria invalidate only affected results.
3. Activity and hiring evidence may become stale independently.
4. Missing prior state must be acknowledged.
5. A focused task may still proceed when the user supplies enough context.

## Related documents

- [../core/workflow.md](../core/workflow.md)
- [full-journey.md](full-journey.md)
- [focused-task-routing.md](focused-task-routing.md)
- [../schemas/research-state.schema.md](../schemas/research-state.schema.md)
