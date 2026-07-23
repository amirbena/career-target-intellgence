# Activity Verification Template

This is the Markdown presentation template for the Activity Verification Report, built from [Activity Records](../schemas/activity-record.schema.md), per [core/output-contracts.md](../core/output-contracts.md#activity-verification-report). This output is produced only when Activity Verification has been explicitly requested. All values below are synthetic.

## Required Columns

| Column | Source field |
|---|---|
| Person | `person_name` |
| Company | `company_name` |
| Activity Level | `activity_level` |
| Activity Type | `activity_type` |
| Authorship Status | `authorship_status` |
| Post Date | `activity_date` |
| Within Lookback Window | `within_requested_window` |
| Hiring Related | `hiring_related` |
| Matching Role | `matching_role` |
| Job Status | `job_status` |
| Post URL | `post_url` |
| Verification Status | `verification_status` |
| Confidence | `confidence` |
| Stale Reason | `stale_reason` |
| Refresh Required | `refresh_required` |
| Checked At | `checked_at` |

## Rules

- A2 or above requires a dated post.
- A4 requires meaningful candidate-role relevance.
- Job status must be verified separately from post existence.
- Failed verification must remain visible — a person who could not be verified still appears here with `verification_status` of Unable to Verify, not omitted.

## Ordering

By activity level descending (A4 first), then by person within each level.

## Synthetic Example

| Person | Company | Activity Level | Activity Type | Authorship Status | Post Date | Within Lookback Window | Hiring Related | Matching Role | Job Status | Post URL | Verification Status | Confidence | Stale Reason | Refresh Required | Checked At |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Jordan Ashkenazi | Northbridge Systems | A3 — Hiring-related Post Found | post | Authored | 2026-07-15 | true | true | — | Post Found, Current Status Unknown | linkedin.com/posts/jordan-ashkenazi-example_hiring-activity-1234 | Verified | High | — | false | 2026-07-19 |
| Ronit Peretz | Northbridge Systems | A1 — Activity Page Only | — | Unknown | — | — | — | — | Not Applicable | — | Partially Verified | Low | No dated post found within the lookback window | true | 2026-07-19 |

## Related documents

- [../schemas/activity-record.schema.md](../schemas/activity-record.schema.md)
- [../schemas/person-record.schema.md](../schemas/person-record.schema.md)
- [../core/output-contracts.md](../core/output-contracts.md)
- [people-map-template.md](people-map-template.md)
