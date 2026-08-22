# Unverified and Rejected Job Leads Template

This is the Markdown presentation template for the Unverified/Rejected Job Leads output, which keeps every role that did not pass the [Primary Job Eligibility Gate](../ranking/job-eligibility-gate.md) visible with an explicit reason, per [core/output-contracts.md](../core/output-contracts.md#unverified-and-rejected-job-leads) — instead of silently dropping it. All values below are synthetic.

## Disclaimer

> A role appearing here was not confirmed as a strong, currently-open, candidate-fit match — it was not necessarily disproven. Each row states the specific reason it did not enter the [Verified Jobs Map](verified-jobs-map-template.md).

## Required Columns

| Column | Source field |
|---|---|
| Job Title | `job_title` |
| Company | `company_name` |
| Discovery Source | `discovery_source`, `discovery_source_type` |
| Rejection Reason | `rejection_reason` |
| Reason Detail | `job_status_evidence`, `fit_gate_reason`, or `stale_reason`, whichever applies |
| Official Verification Attempted | `official_verification_attempted`, `official_verification_result` |
| Last Checked At | `job_status_checked_at` |
| Reconsideration Note | A short note on what would change the outcome (e.g., "revisit if official careers page is reachable again") |

## Rejection Reasons

One of the following, matching `rejection_reason` on the [Job Record schema](../schemas/job-record.schema.md#evidence-and-lifecycle):

- Closed
- Not Found on Official Site
- Unable to Verify
- Seniority mismatch
- Location mismatch
- Hard technology mismatch
- User exclusion
- Stale
- Duplicate

## Rules

- Every role with `record_disposition` of `Rejected Lead` must appear here, not be silently dropped.
- `Not Found on Official Site` must never be presented as equivalent to `Closed` — the Reason Detail column must make the distinction explicit.
- Rows are retained for reconsideration; a later refresh may move a role from here into the Verified Jobs Map if new evidence changes the outcome.
- This report must not be merged into the Verified Jobs Map — the two lists communicate different confidence levels and must remain visually distinct.

## Ordering

By Rejection Reason (grouped), then by Company name within each group.

## Synthetic Example

| Job Title | Company | Discovery Source | Rejection Reason | Reason Detail | Official Verification Attempted | Last Checked At | Reconsideration Note |
|---|---|---|---|---|---|---|---|
| Backend Engineer | Meridian Retail Systems | Glassdoor listing (Glassdoor) | Not Found on Official Site | Official careers page was reachable; this exact role was not found there | Yes — Not Found | 2026-07-19T09:00:00Z | Recheck official careers page in 1–2 weeks; listing may be stale rather than closed |
| Platform Engineer | Riverton Analytics | LinkedIn Jobs search (LinkedIn) | Unable to Verify | Official careers site returned an error / was inaccessible during the check | Yes — Site Inaccessible | 2026-07-17T09:20:00Z | Retry official-site verification later |
| Staff Backend Engineer | Northbridge Systems | Official careers page (Official Careers) | Closed | Official page states "This position is no longer accepting applications" | Yes — Confirmed | 2026-07-20T09:00:00Z | Not applicable — direct closure evidence |
| Senior Backend Engineer (US-based) | Northbridge Systems | Official careers page (Official Careers) | Location mismatch | Role is on-site in Austin, Texas; outside candidate's central-Israel-only constraint | Yes — Confirmed | 2026-07-20T09:00:00Z | Would only be reconsidered if the candidate's geographic constraint changes |

## Related documents

- [../schemas/job-record.schema.md](../schemas/job-record.schema.md)
- [../ranking/job-eligibility-gate.md](../ranking/job-eligibility-gate.md)
- [../core/job-verification-policy.md](../core/job-verification-policy.md)
- [../core/output-contracts.md](../core/output-contracts.md)
- [verified-jobs-map-template.md](verified-jobs-map-template.md)
