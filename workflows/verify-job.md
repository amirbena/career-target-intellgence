# Module: Verify Job

Decides each discovered role's `job_status` by applying [core/job-verification-policy.md](../core/job-verification-policy.md), including the mandatory official-site/ATS cross-check. Produces the authoritative current-availability determination for a [Job Record](../schemas/job-record.schema.md).

## Purpose

Turn a discovered lead into a dated, sourced, current-availability determination — never inferring "still open" from the listing's continued existence alone.

## Required Inputs

- One or more Draft Job Records from [discover-jobs.md](discover-jobs.md).

## Optional Inputs

- A specific role or set of roles the user wants (re-)verified, for a "check whether these roles are still open" focused task.

## Preconditions

- The role must have at least a `discovery_source` and `discovery_source_type` recorded.

## Procedure

1. If `discovery_source_type` is `Official Careers`, confirm the listing appears current/usable and record `job_status` of `Verified Open` (or `Likely Open / Partially Verified` if the source is official but not fully conclusive).
2. If `discovery_source_type` is anything else (LinkedIn, Glassdoor, Indeed, Other Job Board, Recruiter Post, Search Result), attempt to locate the same role on the company's official careers site or official ATS whenever publicly accessible — the mandatory cross-check.
3. Record `official_verification_attempted: true` and the specific `official_verification_result` regardless of outcome.
4. Apply the [Verification Outcomes table](../core/job-verification-policy.md#verification-outcomes) to set `job_status`:
   - found and current on the official source → `Verified Open`;
   - official source inaccessible → `Unable to Verify`;
   - official source accessible, role not found there → `Not Found on Official Site` (never silently dropped, never auto-`Closed`);
   - official source explicitly states closed/expired → `Closed`, with the exact evidence and date;
   - a search-result snippet only, not yet cross-checked → do not assign an availability-implying status; proceed to step 2 first.
5. Record `job_status_checked_at` with an exact timestamp.

## Outputs

- Job Records with `job_status`, `job_status_evidence`, `official_verification_attempted`, `official_verification_result`, `official_verification_url` (when reached), and `job_status_checked_at` populated.

## Research State Updates

- `job_verification_status` moves from Not Started → Draft → Completed.

## Quality Gates

- No discovery-source listing alone produces `Verified Open` — see [core/job-verification-policy.md](../core/job-verification-policy.md#policy-rules), rule 1.
- The cross-check attempt is recorded even when it fails — rule 2.
- `Closed` requires direct closure evidence — rule 4.
- `Not Found on Official Site` preserves the lead rather than dropping it — rule 5.
- `job_status_checked_at` is exact, not relative — rule 9.

## Uncertainty Handling

- When the official source cannot be reached or assessed, record `Unable to Verify` and the specific reason rather than omitting the role.
- When results conflict (e.g., one source says open, a more recent one suggests closed), keep both visible per [confidence-model.md](../core/confidence-model.md) (`Contradicted`) rather than picking one silently.

## Explicit Non-Actions

- Do not treat a job board's continued listing of a role as proof it remains open.
- Do not treat a recruiter's hiring post as job verification — that is Activity evidence (see [verify-activity.md](verify-activity.md)), not Job Record verification.
- Do not auto-mark every role `Closed` because one role at the company was found closed.
- Do not imply continuous or scheduled re-checking; verification runs on request.

## Related documents

- [../core/job-verification-policy.md](../core/job-verification-policy.md)
- [../schemas/job-record.schema.md](../schemas/job-record.schema.md)
- [discover-jobs.md](discover-jobs.md)
- [evaluate-candidate-job-fit.md](evaluate-candidate-job-fit.md)
- [job-search-journey.md](job-search-journey.md)
