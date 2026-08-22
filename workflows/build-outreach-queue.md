# Module: Build Outreach Queue

Applies the [Outreach Priority Model](../ranking/outreach-priority-model.md) to produce a prioritized, advisory list of manual outreach actions. This module does not perform outreach — it recommends it.

## Purpose

Combine company ranking, person relevance, and activity evidence into an ordered, evidence-justified list of suggested next actions.

## Required Inputs

- Ranked Company Records (Priority 1–3, Included or Needs Review).
- Discovered Person Records for those companies.

## Optional Inputs

- Activity Records, when Activity Verification has been run — their absence does not block the queue, but it does cap which actions can be recommended (see below).
- Primary [Job Records](../schemas/job-record.schema.md) (`record_disposition` of `Primary Candidate`), when the request originated from the [Job Search Journey](job-search-journey.md) — a Job Record's `job_status` of `Verified Open` is the strongest available "currently open role" evidence and should be preferred over an Activity Record's own `job_status` for the same role, per [Migration and Compatibility: Job Record](../core/data-model.md#migration-and-compatibility-job-record).

## Preconditions

- Sufficient company and person evidence must exist — see [Full Journey Rule 7](full-journey.md#outreach-queue).

## Procedure

1. For each company/person pairing, determine the recommended action using the [Recommended Action Order](../ranking/outreach-priority-model.md#recommended-action-order) — from an A4 matching job post down to Skip.
2. Select from the [Supported Actions](../ranking/outreach-priority-model.md#supported-actions) list only.
3. Apply the [Outreach Queue Inputs](../ranking/outreach-priority-model.md#outreach-queue-inputs): company priority, person relevance, activity level, current job status, company state, evidence confidence, user preferences, and duplicate-contact avoidance.
4. Avoid generating multiple redundant entries for the same person across overlapping roles at one company.
5. When a primary Job Record exists for the role, associate its `job_id` with the queue entry (see [outreach-queue-template.md](../outputs/outreach-queue-template.md)) — this association is descriptive only and never implies automatic outreach.

## Outputs

- An Outreach Priority Queue: an ordered list of company/person pairs, each with a recommended action and its supporting evidence.

## Research State Updates

- `outreach_queue_status` moves from Not Started → Draft → Completed.

## Quality Gates

- Recommendations are based on available evidence, not assumed certainty — see [Outreach Priority Model](../ranking/outreach-priority-model.md#evidence-boundaries).
- Stale hiring signals do not appear as current openings.
- Current employment uncertainty remains visible in the recommendation.

## Uncertainty Handling

- When Activity Verification has not been run, recommendations are capped at "Research Team" or lower — no action implying verified current activity or an open role can be justified without it.
- When employment status is unresolved, the recommendation reflects that (e.g., "Research Team" rather than "Apply Now").

## Explicit Non-Actions

- Recommendations must remain manual and advisory — see [Outreach Priority Model](../ranking/outreach-priority-model.md#evidence-boundaries).
- No automatic messages, connection requests, monitoring, or scheduled follow-up are generated or performed.
- The queue does not instruct the user to automate outreach.
- No private-contact enrichment is included in queue entries.

## Related documents

- [../ranking/outreach-priority-model.md](../ranking/outreach-priority-model.md)
- [classify-and-rank-companies.md](classify-and-rank-companies.md)
- [discover-people.md](discover-people.md)
- [verify-activity.md](verify-activity.md)
- [evaluate-candidate-job-fit.md](evaluate-candidate-job-fit.md)
- [full-journey.md](full-journey.md)
- [job-search-journey.md](job-search-journey.md)
- [../schemas/job-record.schema.md](../schemas/job-record.schema.md)
