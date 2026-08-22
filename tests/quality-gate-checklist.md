# Quality Gate Checklist

A pass/fail checklist mirroring [`core/quality-gates.md`](../core/quality-gates.md), focused on the job-first verification and company-state gates added by this refactor (spec section 15). Run this before treating a Verified Jobs Map, Unverified/Rejected Job Leads, or Company State output as complete. Each check names the rule it verifies and how to falsify it against the [scenario fixtures](job-verification-scenarios.md).

| # | Check | Rule source | Falsified by |
|---|---|---|---|
| 1 | A LinkedIn/Glassdoor/Indeed/other-board/recruiter-post listing alone never produces `job_status: Verified Open` when official verification was possible but not performed. | [job-verification-policy.md, rule 1](../core/job-verification-policy.md#policy-rules) | Scenario 1 assigning `Verified Open` from the LinkedIn listing alone, without the official-site cross-check. |
| 2 | A recruiter's hiring post alone never proves a role remains open. | [job-verification-policy.md, Source-Specific Guidance](../core/job-verification-policy.md#source-specific-guidance) | Scenario 8 assigning `Verified Open` from the recruiter post alone. |
| 3 | A search-result snippet alone never proves an open job. | [job-verification-policy.md, Verification Outcomes](../core/job-verification-policy.md#verification-outcomes) | Any Job Record with `discovery_source_type: Search Result` and `job_status: Verified Open` with no recorded official-site cross-check. |
| 4 | A closed role never enters the primary Verified Jobs Map. | [job-eligibility-gate.md, Gate A](../ranking/job-eligibility-gate.md#gate-a--availability) | Scenario 4's role appearing with `record_disposition: Primary Candidate`. |
| 5 | A role violating a hard candidate constraint never enters the primary Verified Jobs Map, even when the employer scores well. | [job-eligibility-gate.md, Gate B](../ranking/job-eligibility-gate.md#gate-b--candidate-fit) | Scenario 5's role appearing in the Verified Jobs Map. |
| 6 | Missing official verification is visible, not hidden. | [job-record.schema.md, rule 5](../schemas/job-record.schema.md#job-record-rules) | Any Rejected Lead entry missing `official_verification_attempted`/`official_verification_result`. |
| 7 | `checked_at` (or `job_status_checked_at`) is present on every mutable job-status claim. | [job-record.schema.md, rule 10](../schemas/job-record.schema.md#job-record-rules) | Any Verified Jobs Map or Unverified/Rejected Job Leads row with no checked-at timestamp. |
| 8 | Company-state facts (`event_description`) are separated from candidate-impact inference (`candidate_impact_assessment`), each labeled via `impact_assessment_type`. | [company-state-record.schema.md, rule 6](../schemas/company-state-record.schema.md#company-state-record-rules) | Scenario 6 presenting the layoff and its impact as one unlabeled statement. |
| 9 | A layoff does not automatically mark every job at the company Closed. | [job-verification-policy.md — Company State Does Not Gate Job Availability](../core/job-verification-policy.md#company-state-does-not-gate-job-availability) | Scenario 6's role becoming `Closed` or removed from the map because of the layoff. |
| 10 | A company with no current matching role may still appear in Company Targeting mode, but never masquerades as a current job result. | [exclusion-policy.md — Relationship to Job-Level Rejection](../ranking/exclusion-policy.md#relationship-to-job-level-rejection) | Scenario 7's company appearing in, or implied to be in, the Verified Jobs Map. |
| 11 | Current employment verification for a recruiter/manager stays separate from job availability. | [core/quality-gates.md — People Map](../core/quality-gates.md#people-map) | Scenario 8 treating Jordan Ashkenazi's verified current employment as also proving the role is open. |
| 12 | Generated ChatGPT/Claude/Skill packages remain semantically aligned with canonical sources. | [core/quality-gates.md — Cross-Platform Package Alignment](../core/quality-gates.md#cross-platform-package-alignment) | See [`package-alignment-checklist.md`](package-alignment-checklist.md). |
| 13 | An `A4 — Matching Job Post Found` Activity Record, without a qualifying Job Record (`job_status: Verified Open` with a current `job_status_checked_at`), never produces an "Apply Now" recommendation. | [ranking/outreach-priority-model.md — Job Record required for "Apply Now"](../ranking/outreach-priority-model.md#recommended-action-order) | Scenario 9's recruiter (or the Apply Now worked example) producing "Apply Now" from A4 evidence alone, with no linked Job Record confirming Verified Open. |

## Additional output-specific checks

- `Not Found on Official Site` is never presented as equivalent to `Closed` (Scenario 2) — the Reason Detail / `job_status_evidence` column must make the distinction explicit in the Unverified/Rejected Job Leads output.
- The Verified Jobs Map's Verified Open and Likely Open / Partially Verified sections remain visually separate — never merged into one list.
- The Outreach Queue's Associated Job Record column never references a `Rejected Lead` Job Record as if it were verified.

## Related documents

- [../core/quality-gates.md](../core/quality-gates.md)
- [job-verification-scenarios.md](job-verification-scenarios.md)
- [package-alignment-checklist.md](package-alignment-checklist.md)
