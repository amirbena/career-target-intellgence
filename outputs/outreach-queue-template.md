# Outreach Queue Template

This is the Markdown presentation template for the Outreach Priority Queue output, built from ranked Company, Person, and (when available) Activity Records, per [core/output-contracts.md](../core/output-contracts.md#outreach-priority-queue) and the [Outreach Priority Model](../ranking/outreach-priority-model.md). All values below are synthetic.

## Required Columns

| Column | Source field |
|---|---|
| Queue Position | Position in the recommended action order |
| Company | `company_name` |
| Person | `person_name` |
| Person Type | `person_type` |
| Company Priority | Company Ranking Model tier |
| Person Priority Score | Person Ranking Model total |
| Evidence Signal | The activity level and job status supporting the recommendation |
| Recommended Action | One of the [Supported Actions](#supported-actions) |
| Reason | Written justification tied to the evidence |
| Timing | When the action is suggested (e.g., "Now", "This week") |
| Status | Whether the user has acted on this entry (e.g., "Not started") |
| Follow-up Date | A suggested date to revisit, if applicable |
| Duplicate Contact Group | `duplicate_contact_group` |
| Confidence | Overall confidence in the recommendation |
| Checked At | `checked_at` |
| Associated Job Record | `job_id`, when a specific verified job (from the [Verified Jobs Map](verified-jobs-map-template.md)) is being associated with this contact — otherwise "Not associated with a specific job" |

## Supported Actions

- Apply Now
- Connect
- Send Direct Message
- Follow Activity
- Verify Role
- Research Team
- Revisit Later
- Skip

## Rules

- Do not include automatic execution — every entry is a suggestion for the user to act on manually.
- Avoid multiple equivalent contacts from the same duplicate group appearing as separate high-priority entries.
- Unresolved current employment must remain visible in the entry, not hidden behind a confident-sounding action.
- Stale activity must not be presented as a current opportunity.
- The user controls whether any action is performed.
- An Associated Job Record reference is descriptive only — it does not authorize or imply automatic outreach on the candidate's behalf.
- A Job Record with `record_disposition` of `Rejected Lead` must never be associated with a queue entry as if it were a verified opportunity.

## Ordering

By Queue Position, following the [Recommended Action Order](../ranking/outreach-priority-model.md#recommended-action-order).

## Synthetic Example

| Queue Position | Company | Person | Person Type | Company Priority | Person Priority Score | Evidence Signal | Recommended Action | Reason | Timing | Status | Follow-up Date | Duplicate Contact Group | Confidence | Checked At | Associated Job Record |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Northbridge Systems | Jordan Ashkenazi | Technical Recruiter | Priority 1 | 84 | A4 matching job post; job Verified Open | Apply Now | Currently employed recruiter with a verified matching role open on the official careers page. | Now | Not started | — | — | High | 2026-07-20 | job:northbridge-systems:senior-backend-engineer:2026-07-20 |
| 2 | Northbridge Systems | Ronit Peretz | Engineering Manager | Priority 1 | 60 | A1 activity page only, no dated post | Research Team | Relevant manager identified, but no recent activity evidence exists yet. | This week | Not started | 2026-08-02 | — | Low | 2026-07-19 | Not associated with a specific job |

## Related documents

- [../ranking/outreach-priority-model.md](../ranking/outreach-priority-model.md)
- [../core/output-contracts.md](../core/output-contracts.md)
- [people-map-template.md](people-map-template.md)
- [activity-verification-template.md](activity-verification-template.md)
- [verified-jobs-map-template.md](verified-jobs-map-template.md)
- [../schemas/job-record.schema.md](../schemas/job-record.schema.md)
