# Module: Evaluate Candidate–Job Fit

Applies Gate B of the [Primary Job Eligibility Gate](../ranking/job-eligibility-gate.md) to roles with a decided `job_status`, producing the `fit_gate_result` and `record_disposition` that determine primary-map eligibility.

## Purpose

Decide whether a specific role is compatible with the candidate's approved profile and stated search constraints — separately from whether the role is currently open.

## Required Inputs

- Job Records with `job_status` decided (from [verify-job.md](verify-job.md)).
- An approved [Candidate Profile](../schemas/candidate-profile.schema.md).
- Ready [Search Criteria](../schemas/search-criteria.schema.md).

## Preconditions

- `job_status` must already be set; a role that fails Gate A does not require a fit evaluation to be excluded from the primary map, though one may still be recorded for context.

## Procedure

1. Compare the Job Record's [Role Requirements and Fit Inputs](../schemas/job-record.schema.md#role-requirements-and-fit-inputs) against the Candidate Profile and Search Criteria on: role family/discipline, seniority, mandatory technologies, hard exclusions, geography/commute, work model, and any explicit user must-have from the current conversation.
2. If a hard constraint is directly violated by evidenced role data, set `fit_gate_result` to `Fails — Hard Constraint` and record the specific constraint in `fit_gate_reason`.
3. If no hard constraint is violated, set `fit_gate_result` to `Passes`; unknown fields are treated as Unknown, not as a pass or fail signal.
4. Combine with Gate A's result (from `job_status`) to set `record_disposition` per the [Gate Outcomes table](../ranking/job-eligibility-gate.md#gate-outcomes-on-the-job-record).
5. When `record_disposition` is `Rejected Lead`, set the matching `rejection_reason`.

## Outputs

- Job Records with `fit_evaluation_status`, `fit_gate_result`, `fit_gate_reason` (when failing), `fit_notes`, and `record_disposition` populated.

## Research State Updates

- `job_fit_evaluation_status` moves from Not Started → Draft → Completed.

## Quality Gates

- Unknown fit evidence is never treated as a positive fit signal — see [job-eligibility-gate.md](../ranking/job-eligibility-gate.md#rules), rule 5.
- A hard-constraint violation excludes the role from the primary map regardless of company attractiveness — rule 2.
- A rejected role remains visible with a specific `rejection_reason`, never silently dropped — rule 3.

## Uncertainty Handling

- When a fit-relevant field is not present in the role's evidence, disclose it as not evaluated for that dimension rather than assuming a match or a mismatch.

## Explicit Non-Actions

- Do not let company attractiveness override a failed hard-constraint check.
- Do not treat an evaluated-but-unknown dimension as a violation.
- Do not re-run this evaluation on roles whose fit-relevant Candidate Profile/Search Criteria fields have not changed since the last evaluation.

## Related documents

- [../ranking/job-eligibility-gate.md](../ranking/job-eligibility-gate.md)
- [../schemas/job-record.schema.md](../schemas/job-record.schema.md)
- [../schemas/candidate-profile.schema.md](../schemas/candidate-profile.schema.md)
- [../schemas/search-criteria.schema.md](../schemas/search-criteria.schema.md)
- [verify-job.md](verify-job.md)
- [job-search-journey.md](job-search-journey.md)
