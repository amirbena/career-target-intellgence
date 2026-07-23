# Person Record Schema

The Person Record describes a publicly identifiable professional contact — a recruiter, hiring manager, or related role — at a target company. It is separate from the [Company Record](company-record.schema.md) (the organization) and the [Activity Record](activity-record.schema.md) (specific dated evidence about this person's activity).

This is a logical record. See [core/data-model.md](../core/data-model.md) for the principles that govern how it should be interpreted and populated, including the [Context Boundary](../core/data-model.md#context-boundary). This record covers public professional information only; it does not define or encourage private-contact discovery, scraping, or bypassing platform access controls.

## Identity

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `person_name` | string | Required | The person's name. | `"Jordan Ashkenazi"` |
| `company_name` | string | Required | The company the person is associated with. | `"Northbridge Systems"` |
| `current_title` | string | Optional | The person's current title as observed. | `"Senior Technical Recruiter"` |
| `linkedin_profile_url` | string | Optional | The person's public LinkedIn profile URL, if found. | `"https://linkedin.com/in/jordan-ashkenazi-example"` |
| `profile_status` | enum: `Available`, `Unavailable`, `Ambiguous`, `Unknown` | Required | Whether a usable public profile was found. | `"Available"` |

## Person Type

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `person_type` | enum: `Recruiter`, `Technical Recruiter`, `Talent Acquisition`, `Talent Sourcer`, `Recruitment Lead`, `HR Business Partner`, `People Partner`, `Team Lead`, `Engineering Manager`, `Group Manager`, `Director of Engineering`, `Head of R&D`, `VP R&D`, `Other`, `Unclear` | Required | The person's role category. | `"Technical Recruiter"` |
| `person_type_evidence` | list of strings | Optional | Evidence supporting the role classification. | `["title states 'Technical Recruiter'"]` |

## Employment Verification

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `current_employment_status` | enum: `Current`, `Former`, `Unclear`, `Unable to Verify` | Required | Whether the person is currently employed at `company_name`. | `"Current"` |
| `employment_verification` | string | Optional | How employment was verified. | `"Profile lists company as current employer"` |
| `employment_evidence` | list of strings | Optional | Supporting evidence for employment status. | `["LinkedIn profile, checked 2026-07-18"]` |
| `employment_checked_at` | timestamp | Required | When employment status was last checked. | `"2026-07-18T00:00:00Z"` |

A title shown in an old search result must not be treated as current without supporting evidence.

## Candidate Relevance

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `recruiting_relevance` | string | Optional | Why this person is relevant from a recruiting standpoint. | `"Handles engineering hiring"` |
| `managerial_relevance` | string | Optional | Why this person is relevant as a potential manager. | `""` |
| `team_relevance` | string | Optional | Notes on relevance to a specific team. | `"Sources for Billing Platform Team"` |
| `domain_relevance` | string | Optional | Notes on domain relevance. | `""` |
| `technology_relevance` | string | Optional | Notes on technology relevance. | `""` |
| `relevance_notes` | string | Optional | Additional relevance notes. | `""` |

Do not add a numeric person score in this task.

## Public Links

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `activity_url` | string | Optional | A public activity or posts page for this person. | `"https://linkedin.com/in/jordan-ashkenazi-example/recent-activity"` |
| `public_contact_path` | string | Optional | A publicly documented way to reach this person (e.g., "message via LinkedIn"). | `"LinkedIn message"` |
| `source_profile_urls` | list of strings | Optional | URLs used as sources for this record. | `["https://linkedin.com/in/jordan-ashkenazi-example"]` |

Do not define or encourage private-contact discovery, scraping, or bypassing platform access controls.

## Activity Summary

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `latest_activity_record_reference` | logical reference | Optional | A reference to the most recent related Activity Record. | `"activity:jordan-ashkenazi:2026-07-19"` |
| `recent_activity_status` | enum: `Verified`, `Partially Verified`, `Unable to Verify`, `Not Checked` | Required | Summary status of recent activity, per the referenced Activity Record. | `"Not Checked"` |
| `recent_hiring_activity_status` | enum: `Verified`, `Partially Verified`, `Unable to Verify`, `Not Checked` | Required | Summary status of recent hiring-related activity. | `"Not Checked"` |
| `matching_job_activity_status` | enum: `Verified`, `Partially Verified`, `Unable to Verify`, `Not Checked` | Required | Summary status of a matching job post. | `"Not Checked"` |

These fields summarize verified Activity Records and must not replace them.

## Evidence and Lifecycle

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `sources` | list of strings | Optional | Sources used to build this record. | `["LinkedIn profile"]` |
| `checked_at` | timestamp | Required | When this record was last checked. | `"2026-07-18T00:00:00Z"` |
| `confidence` | enum: `Low`, `Medium`, `High` | Required | Overall confidence in the record. | `"Medium"` |
| `record_status` | enum: `Draft`, `Verified`, `Approved`, `Stale`, `Superseded` | Required | The status of the record. | `"Draft"` |
| `duplicate_risk` | enum: `Low`, `Medium`, `High` | Required | Risk that this record is confused with a different person of the same name. | `"Low"` |
| `ambiguity_notes` | string | Optional | Notes explaining any ambiguity. | `""` |
| `stale_reason` | string | Required when `record_status` is Stale | A short explanation of why the record is considered stale, per [freshness-policy.md](../core/freshness-policy.md). | `""` |
| `refresh_required` | boolean or `Unknown` | Optional | Whether this record needs to be re-checked before it can be used with confidence. Does not imply an automatic refresh. | `false` |
| `duplicate_contact_group` | string | Optional | An optional logical label grouping this record with other duplicate or overlapping contact records, for output deduplication only. Not a database identifier. | `""` |

## Person Record Rules

1. Verify that the person currently works at the company.
2. Distinguish recruiters from general HR roles.
3. Distinguish direct team relevance from title similarity.
4. Do not treat an Activity URL as proof of recent activity.
5. Do not treat an old hiring post as evidence of current hiring.
6. Preserve ambiguity when multiple people share the same name.
7. Do not fabricate LinkedIn profile URLs.
8. Every time-sensitive field requires `checked_at`.
9. Public professional information only; no private-contact enrichment.
10. `stale_reason` is required whenever `record_status` is Stale.
11. `refresh_required` does not imply automatic refresh; a refresh occurs only after an explicit user request.
12. `duplicate_contact_group` supports output deduplication only — it must not trigger automatic merging or deletion, and original records remain traceable.

## Example Record

```text
person_name: "Jordan Ashkenazi"
company_name: "Northbridge Systems"
current_title: "Senior Technical Recruiter"
profile_status: "Available"
person_type: "Technical Recruiter"
current_employment_status: "Current"
employment_checked_at: "2026-07-18T00:00:00Z"
recent_activity_status: "Not Checked"
record_status: "Draft"
duplicate_risk: "Low"
checked_at: "2026-07-18T00:00:00Z"
```

## Related documents

- [../core/data-model.md](../core/data-model.md)
- [company-record.schema.md](company-record.schema.md)
- [activity-record.schema.md](activity-record.schema.md)
