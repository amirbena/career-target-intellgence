# People Map Template

This is the Markdown presentation template for the People Map output, built from [Person Records](../schemas/person-record.schema.md), per [core/output-contracts.md](../core/output-contracts.md#people-map) and the [Person Ranking Model](../ranking/person-ranking-model.md). All values below are synthetic.

## Required Columns

| Column | Source field |
|---|---|
| Company | `company_name` |
| Person | `person_name` |
| Current Title | `current_title` |
| Person Type | `person_type` |
| Current Employment | `current_employment_status` |
| Recruiter Relevance | `recruiting_relevance` |
| Managerial Relevance | `managerial_relevance` |
| Team Relevance | `team_relevance` |
| LinkedIn Profile | `linkedin_profile_url` |
| Activity URL | `activity_url` |
| Recent Activity Status | `recent_activity_status` |
| Hiring Activity | `recent_hiring_activity_status` |
| Matching Job Signal | `matching_job_activity_status` |
| Last Verified Activity | Linked Activity Record's `checked_at` |
| Priority Score | Person Ranking Model total |
| Confidence | `confidence` |
| Duplicate Contact Group | `duplicate_contact_group` |
| Sources | `sources` |
| Checked At | `checked_at` |

## Rules

- Recruiters and hiring managers may appear in the same output, but must remain distinguishable by `person_type`.
- Duplicate or near-duplicate records must be grouped via `duplicate_contact_group` or otherwise flagged, not silently merged.
- An Activity URL alone does not prove activity — `recent_activity_status` reflects the linked Activity Record's actual verification, not the presence of a URL.
- Former employees (`current_employment_status`: Former) must not receive an active outreach recommendation.

## Ordering

By company (matching the Company Map order), then by person priority score descending within each company.

## Synthetic Example

| Company | Person | Current Title | Person Type | Current Employment | Recruiter Relevance | Managerial Relevance | Team Relevance | LinkedIn Profile | Activity URL | Recent Activity Status | Hiring Activity | Matching Job Signal | Last Verified Activity | Priority Score | Confidence | Duplicate Contact Group | Sources | Checked At |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Northbridge Systems | Jordan Ashkenazi | Senior Technical Recruiter | Technical Recruiter | Current | Handles engineering hiring | — | Sources for Billing Platform Team | linkedin.com/in/jordan-ashkenazi-example | linkedin.com/in/jordan-ashkenazi-example/recent-activity | Verified | Verified | Not Checked | 2026-07-19 | 84 | Medium | — | LinkedIn profile | 2026-07-18 |
| Northbridge Systems | Ronit Peretz | Engineering Manager | Engineering Manager | Current | — | May manage a relevant team | Owns Billing Platform Team | linkedin.com/in/ronit-peretz-example | linkedin.com/in/ronit-peretz-example/recent-activity | Partially Verified | Not Checked | Not Checked | 2026-07-15 | 60 | Medium | — | LinkedIn profile | 2026-07-18 |

## Related documents

- [../schemas/person-record.schema.md](../schemas/person-record.schema.md)
- [../ranking/person-ranking-model.md](../ranking/person-ranking-model.md)
- [../core/output-contracts.md](../core/output-contracts.md)
- [activity-verification-template.md](activity-verification-template.md)
