# Module: Discover Jobs

Identifies a broad set of candidate roles across discovery sources, before verification or fit evaluation. This module produces draft [Job Records](../schemas/job-record.schema.md) — it does not decide `job_status` or evaluate fit.

## Purpose

Cast a wide, criteria-guided net across official careers pages, LinkedIn Jobs, Glassdoor, Indeed, other job boards, and recruiter posts. Verification and fit evaluation happen afterward in [verify-job.md](verify-job.md) and [evaluate-candidate-job-fit.md](evaluate-candidate-job-fit.md).

## Required Inputs

- Ready Search Criteria.

## Optional Inputs

- A user-supplied list of specific roles or companies to check, when the request is "check whether these roles are still open" rather than open discovery.

## Preconditions

- Search Criteria must be Ready.

## Procedure

1. Identify candidate roles matching the Search Criteria's role, technology, domain, location, and company-type criteria, across the discovery sources available in the active context.
2. Populate [Identity](../schemas/job-record.schema.md#identity) and [Discovery](../schemas/job-record.schema.md#discovery) fields with sourced evidence, including `discovery_source_type`.
3. Leave [Current Availability](../schemas/job-record.schema.md#current-availability) and [Candidate-Fit Evaluation](../schemas/job-record.schema.md#candidate-fit-evaluation) fields for the next modules — discovery does not verify or evaluate fit.
4. Set `record_status` to Draft and `record_disposition` to `Not Yet Evaluated`.

## Outputs

- Draft Job Records with `record_status` of Draft.

## Research State Updates

- `job_discovery_status` moves from Not Started → Draft → Completed.

## Quality Gates

- `discovery_source_type` is recorded for every role — see [Job Record Rules](../schemas/job-record.schema.md#job-record-rules), rule 3.
- A discovery-source listing is never itself treated as proof of current availability.

## Uncertainty Handling

- Roles with weak or single-source discovery evidence are still recorded as Draft; verification strength is expressed later via `job_status`, not by omitting the role here.

## Explicit Non-Actions

- Do not assign `job_status` of Verified Open at this stage — that decision belongs to [verify-job.md](verify-job.md).
- Do not perform background or recurring discovery — this module runs once per request, not on a schedule.
- Do not invent roles, companies, or URLs that were not actually observed.

## Related documents

- [../schemas/job-record.schema.md](../schemas/job-record.schema.md)
- [../core/job-verification-policy.md](../core/job-verification-policy.md)
- [verify-job.md](verify-job.md)
- [job-search-journey.md](job-search-journey.md)
- [build-search-criteria.md](build-search-criteria.md)
