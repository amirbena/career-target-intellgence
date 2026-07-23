# Activity Record Schema

The Activity Record is a public activity evidence record linked to a [Person Record](person-record.schema.md). It captures specific, dated evidence — not a general impression — and exists to prevent activity claims from being asserted without a verifiable basis.

This is a logical record. See [core/data-model.md](../core/data-model.md) for the principles that govern how it should be interpreted and populated, including the [Context Boundary](../core/data-model.md#context-boundary). Activity verification occurs only after an explicit user request or as part of an explicitly requested full journey — see [Search Criteria Rules](search-criteria.schema.md#search-criteria-rules) and [Core Rules](../core/data-model.md#core-rules).

## Identity

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `activity_id` | string | Required | A logical identifier for this activity record. | `"activity:jordan-ashkenazi:2026-07-19"` |
| `person_name` | string | Required | The person this activity record is about. | `"Jordan Ashkenazi"` |
| `company_name` | string | Required | The company associated with the person at the time of the activity. | `"Northbridge Systems"` |
| `activity_url` | string | Optional | The person's public activity page. | `"https://linkedin.com/in/jordan-ashkenazi-example/recent-activity"` |
| `post_url` | string | Optional | The specific post referenced by this record, if applicable. | `"https://linkedin.com/posts/jordan-ashkenazi-example_hiring-activity-1234"` |

## Activity Level

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `activity_level` | enum: `A0 — Profile Only`, `A1 — Activity Page Only`, `A2 — Recent Post Found`, `A3 — Hiring-related Post Found`, `A4 — Matching Job Post Found` | Required | The level of activity evidence found, from weakest to strongest. | `"A3 — Hiring-related Post Found"` |

Higher levels require direct evidence: each level must be supported by evidence at least as strong as its definition requires, not inferred from a lower level of evidence.

## Activity Details

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `activity_type` | string | Optional | The type of activity found (e.g., post, comment, share). | `"post"` |
| `activity_date` | timestamp | Optional | The date of the specific activity, if found. | `"2026-07-15T00:00:00Z"` |
| `authorship_status` | enum: `Authored`, `Reposted`, `Shared with Commentary`, `Unknown` | Required | Whether the content was authored by the person or reposted/shared. | `"Authored"` |
| `content_summary` | string | Optional | A short, factual summary of the content. | `"Announced an open Senior Backend Engineer role"` |
| `hiring_related` | boolean | Required | Whether the content is hiring-related. | `true` |
| `matching_role` | string | Optional | The specific role mentioned, if any. | `"Senior Backend Engineer"` |
| `role_relevance_notes` | string | Optional | Notes on whether the mentioned role matches the candidate. | `"Matches candidate's target role and stack"` |

## Time Window

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `lookback_start_date` | date | Required | The start of the requested lookback window. | `"2026-06-23"` |
| `lookback_end_date` | date | Required | The end of the requested lookback window. | `"2026-07-23"` |
| `within_requested_window` | boolean | Required | Whether the activity date falls within the lookback window. | `true` |

Use explicit dates rather than only relative wording such as "three months ago."

## Verification

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `verification_status` | enum: `Verified`, `Partially Verified`, `Unable to Verify`, `Contradicted`, `Stale` | Required | The verification outcome for this record. | `"Verified"` |
| `verification_evidence` | list of strings | Optional | Evidence supporting the verification status. | `["post visible and dated 2026-07-15"]` |
| `source_urls` | list of strings | Optional | Source URLs used for verification. | `["https://linkedin.com/posts/jordan-ashkenazi-example_hiring-activity-1234"]` |
| `checked_at` | timestamp | Required | When this record was last checked. | `"2026-07-19T00:00:00Z"` |
| `confidence` | enum: `Low`, `Medium`, `High` | Required | Confidence in the verification outcome. | `"High"` |
| `stale_reason` | string | Required when `verification_status` is Stale | A short explanation of why the record is considered stale, per [freshness-policy.md](../core/freshness-policy.md). | `""` |
| `refresh_required` | boolean or `Unknown` | Optional | Whether this record needs to be re-checked before it can be used with confidence. Does not imply an automatic refresh. | `false` |

## Job Signal

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `job_title` | string | Optional | The job title mentioned in the activity, if any. | `"Senior Backend Engineer"` |
| `job_location` | string | Optional | The job location mentioned, if any. | `"Ra'anana"` |
| `job_status` | enum: `Verified Open`, `Post Found, Current Status Unknown`, `Closed`, `Historical`, `Not Applicable`, `Unable to Verify` | Required | The verified status of the job referenced. | `"Post Found, Current Status Unknown"` |
| `job_status_checked_at` | timestamp | Required | When `job_status` was last checked. | `"2026-07-19T00:00:00Z"` |

A post existing does not prove that the role remains open; `job_status` must reflect what was actually verified.

## Activity Record Rules

1. A profile URL alone is A0.
2. An activity-page URL alone is A1.
3. A2 or above requires a specific dated post.
4. A3 requires clear hiring-related content.
5. A4 requires a role meaningfully matching the candidate.
6. Distinguish authored content from reposts where possible.
7. Use exact date boundaries for lookback checks.
8. Do not infer current job availability from an old post.
9. Record failed verification rather than silently dropping the person.
10. Activity verification occurs only after an explicit user request or as part of an explicitly requested full journey.
11. `stale_reason` is required whenever `verification_status` is Stale.
12. `refresh_required` does not imply automatic refresh; a refresh occurs only after an explicit user request.

## Example Records

**A0 — Profile Only**
```text
activity_id: "activity:sample-person-a:2026-07-19"
activity_level: "A0 — Profile Only"
verification_status: "Unable to Verify"
job_status: "Not Applicable"
checked_at: "2026-07-19T00:00:00Z"
```
Only a LinkedIn profile was found; no activity page or posts were located.

**A1 — Activity Page Only**
```text
activity_id: "activity:sample-person-b:2026-07-19"
activity_level: "A1 — Activity Page Only"
activity_url: "https://linkedin.com/in/sample-person-b-example/recent-activity"
verification_status: "Partially Verified"
job_status: "Not Applicable"
checked_at: "2026-07-19T00:00:00Z"
```
An activity page exists, but no specific dated post was found on it.

**A2 — Recent Post Found**
```text
activity_id: "activity:sample-person-c:2026-07-19"
activity_level: "A2 — Recent Post Found"
post_url: "https://linkedin.com/posts/sample-person-c-example_note-1"
activity_date: "2026-07-10T00:00:00Z"
hiring_related: false
verification_status: "Verified"
job_status: "Not Applicable"
checked_at: "2026-07-19T00:00:00Z"
```
A specific, dated post was found, but it is not hiring-related.

**A3 — Hiring-related Post Found**
```text
activity_id: "activity:jordan-ashkenazi:2026-07-19"
activity_level: "A3 — Hiring-related Post Found"
post_url: "https://linkedin.com/posts/jordan-ashkenazi-example_hiring-activity-1234"
activity_date: "2026-07-15T00:00:00Z"
hiring_related: true
verification_status: "Verified"
job_status: "Post Found, Current Status Unknown"
checked_at: "2026-07-19T00:00:00Z"
```
A dated post announces hiring activity, but the specific role's current open status has not been separately verified.

**A4 — Matching Job Post Found**
```text
activity_id: "activity:sample-person-d:2026-07-19"
activity_level: "A4 — Matching Job Post Found"
post_url: "https://linkedin.com/posts/sample-person-d-example_role-1234"
activity_date: "2026-07-12T00:00:00Z"
hiring_related: true
matching_role: "Senior Backend Engineer"
role_relevance_notes: "Matches candidate's target role and stack"
verification_status: "Verified"
job_status: "Verified Open"
checked_at: "2026-07-19T00:00:00Z"
```
A dated post announces a specific role that has been verified as meaningfully matching the candidate and currently open.

## Related documents

- [../core/data-model.md](../core/data-model.md)
- [person-record.schema.md](person-record.schema.md)
- [company-record.schema.md](company-record.schema.md)
