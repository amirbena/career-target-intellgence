# Job Record Schema

The Job Record describes a specific, discovered role at a target company as a first-class logical record — not evidence nested inside a Company Record or an Activity Record. It exists so that "is this specific job currently open" can be tracked, verified, and reasoned about independently of company suitability and independently of what a person publicly posted.

This is a logical record. See [core/data-model.md](../core/data-model.md) for the principles that govern how it should be interpreted and populated, including the [Context Boundary](../core/data-model.md#context-boundary). Current-availability determinations follow [core/job-verification-policy.md](../core/job-verification-policy.md) — this schema defines the record shape; that document defines how `job_status` is decided.

## Record Boundary

- **Company Record** ([company-record.schema.md](company-record.schema.md)) stays authoritative for stable company facts, classification, and general hiring signal at the company level. It does not carry the authoritative status of one specific role.
- **Activity Record** ([activity-record.schema.md](activity-record.schema.md)) stays authoritative for what a person publicly posted or did. It may reference a Job Record when a post concerns a specific role, but it does not itself decide whether that role is currently open.
- **Job Record** is authoritative for the current availability of one specific role. See [Migration and Compatibility](../core/data-model.md#migration-and-compatibility-job-record) for how this interacts with the pre-existing `job_status`/`job_status_checked_at` fields on the Activity Record's [Job Signal](activity-record.schema.md#job-signal) section.

## Identity

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `job_id` | string | Required | A logical identifier for this job record. | `"job:northbridge-systems:senior-backend-engineer:2026-07-20"` |
| `company_name` | string | Required | The employer. | `"Northbridge Systems"` |
| `job_title` | string | Required | The role's title as posted. | `"Senior Backend Engineer"` |
| `job_url` | string | Optional | The URL where this role was discovered. | `"https://linkedin.com/jobs/view/example-1234"` |
| `official_job_url` | string | Optional | The URL of the role on the company's own careers site or official ATS, when found. | `"https://northbridgesystems.example/careers/senior-backend-engineer"` |
| `external_job_urls` | list of strings | Optional | Other URLs where the same role was also observed (e.g., a job board mirror). | `["https://www.glassdoor.com/job-listing/example-5678"]` |
| `job_location` | string | Optional | The role's stated location. | `"Ra'anana"` |
| `work_model` | enum: `On-site`, `Hybrid`, `Remote`, `Unknown` | Required | The role's stated work model. | `"Hybrid"` |
| `employment_type` | enum: `Full-time`, `Part-time`, `Contract`, `Internship`, `Unknown` | Required | The role's stated employment type. | `"Full-time"` |
| `team_or_org` | string | Optional | The team or business unit the role belongs to, when known. | `"Billing Platform Team"` |

## Discovery

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `discovery_source` | string | Required | Where this role was first found. | `"LinkedIn Jobs search"` |
| `discovery_source_type` | enum: `Official Careers`, `LinkedIn`, `Glassdoor`, `Indeed`, `Other Job Board`, `Recruiter Post`, `Search Result`, `Other` | Required | The category of the discovery source. | `"LinkedIn"` |
| `discovered_at` | timestamp | Required | When this role was first discovered. | `"2026-07-20T09:00:00Z"` |

## Current Availability

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `job_status` | enum: `Verified Open`, `Likely Open / Partially Verified`, `Unable to Verify`, `Not Found on Official Site`, `Closed`, `Historical`, `Stale` | Required | The current availability state of this specific role. Decided per [job-verification-policy.md](../core/job-verification-policy.md). | `"Verified Open"` |
| `job_status_evidence` | list of strings | Optional | Evidence supporting `job_status`. | `["role visible on official careers page, checked 2026-07-20"]` |
| `job_status_checked_at` | timestamp | Required | When `job_status` was last checked. | `"2026-07-20T09:00:00Z"` |
| `official_verification_attempted` | boolean | Required | Whether an attempt was made to verify this role against the official careers site or ATS. | `true` |
| `official_verification_result` | enum: `Confirmed`, `Not Found`, `Site Inaccessible`, `Not Attempted` | Required | The outcome of the official verification attempt. | `"Confirmed"` |
| `official_verification_url` | string | Optional | The official source URL used for verification, when one was reached. | `"https://northbridgesystems.example/careers/senior-backend-engineer"` |
| `source_date` | date | Optional | The date the discovery source's listing itself was published or last updated, when available. | `"2026-07-15"` |
| `stale_reason` | string | Required when `job_status` is Stale | A short explanation of why the record is considered stale, per [freshness-policy.md](../core/freshness-policy.md). | `""` |
| `refresh_required` | boolean or `Unknown` | Optional | Whether this record needs to be re-checked before it can be used with confidence. Does not imply an automatic refresh. | `false` |

Absence from an official careers search is evidence that verification failed or the listing may be stale; it is not automatically proof of closure — see [job-verification-policy.md](../core/job-verification-policy.md).

## Role Requirements and Fit Inputs

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `seniority` | string | Optional | The role's stated or evidenced seniority level. | `"Senior"` |
| `discipline` | string | Optional | The role's discipline or family. | `"Backend Engineering"` |
| `required_technologies` | list of strings | Optional | Technologies stated as required, observed directly in the posting. | `["C#", ".NET"]` |
| `preferred_technologies` | list of strings | Optional | Technologies stated as preferred/nice-to-have. | `["Kafka"]` |
| `domain` | string | Optional | The business domain the role sits in. | `"Billing"` |
| `relevant_systems` | list of strings | Optional | System types the posting mentions. | `["distributed systems"]` |
| `responsibilities` | list of strings | Optional | Responsibilities stated in the posting. | `["own the billing service end-to-end"]` |
| `management_expectations` | string | Optional | Whether the role includes people-management responsibility, as stated. | `"Individual contributor; no direct reports"` |
| `mandatory_requirements` | list of strings | Optional | Requirements stated as mandatory. | `["5+ years backend experience"]` |
| `exclusions` | list of strings | Optional | Disqualifying requirements stated in the posting (e.g., citizenship, clearance, on-site-only). | `[]` |

Do not infer technologies or requirements that are not present in the evidence — an empty list means none were observed, not that none exist.

## Candidate-Fit Evaluation

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `fit_evaluation_status` | enum: `Not Evaluated`, `Evaluated` | Required | Whether this role has been evaluated against the candidate's approved Candidate Profile and Search Criteria. | `"Evaluated"` |
| `fit_gate_result` | enum: `Passes`, `Fails — Hard Constraint`, `Fails — Availability`, `Not Evaluated` | Required | The result of the [Primary Job Eligibility Gate](../ranking/job-eligibility-gate.md). | `"Passes"` |
| `fit_gate_reason` | string | Optional | The specific hard constraint violated, when `fit_gate_result` is a Fails value. | `""` |
| `fit_notes` | string | Optional | Written notes on candidate/job fit beyond the gate itself. | `"Matches target seniority and primary stack"` |

Unknown fit evidence stays Unknown; it must never be treated as a positive fit signal. See [job-eligibility-gate.md](../ranking/job-eligibility-gate.md).

## Related Records

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `related_activity_record_references` | list of logical references | Optional | Activity Records that discovered or referenced this role. | `["activity:jordan-ashkenazi:2026-07-19"]` |
| `related_company_state_references` | list of logical references | Optional | Company State Records relevant to this role's employer, surfaced alongside it. | `["company-state:northbridge-systems:2026-06-01-layoff"]` |
| `related_person_references` | list of logical references | Optional | Person Records (recruiter/hiring-manager) associated with this role. | `["person:jordan-ashkenazi"]` |

## Evidence and Lifecycle

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `sources` | list of strings | Optional | Sources used to build this record. | `["LinkedIn Jobs listing", "official careers page"]` |
| `checked_at` | timestamp | Required | When this record was last checked overall. | `"2026-07-20T09:00:00Z"` |
| `confidence` | enum: `Low`, `Medium`, `High` | Required | Overall confidence in the record. | `"High"` |
| `record_status` | enum: `Draft`, `Verified`, `Approved`, `Stale`, `Superseded` | Required | The status of the record. | `"Verified"` |
| `record_disposition` | enum: `Primary Candidate`, `Lower-Confidence Candidate`, `Rejected Lead`, `Not Yet Evaluated` | Required | Where this role sits relative to the [Primary Job Eligibility Gate](../ranking/job-eligibility-gate.md) and the [Verified Jobs Map](../outputs/verified-jobs-map-template.md) / [Unverified and Rejected Job Leads](../outputs/unverified-job-leads-template.md) outputs. | `"Primary Candidate"` |
| `rejection_reason` | enum: `Closed`, `Not Found on Official Site`, `Unable to Verify`, `Seniority mismatch`, `Location mismatch`, `Hard technology mismatch`, `User exclusion`, `Stale`, `Duplicate` | Required when `record_disposition` is Rejected Lead | The reason this lead did not enter the primary Verified Jobs Map. | `""` |

## Job Record Rules

1. A Job Record is a first-class logical record — it is not merely nested evidence inside a Company Record or an Activity Record.
2. `job_status` must be decided per [job-verification-policy.md](../core/job-verification-policy.md); a discovery source alone must never set `job_status` to Verified Open.
3. A LinkedIn, Glassdoor, Indeed, other job-board, recruiter-post, or search-result discovery is discovery evidence only, never sufficient proof of current availability by itself.
4. Absence from an official careers search is evidence that verification failed or the listing may be stale, not automatic proof of closure — closure requires direct closure evidence.
5. `official_verification_attempted` and `official_verification_result` must be recorded even when verification failed or was not possible, not omitted.
6. Do not infer required or preferred technologies, requirements, or exclusions not present in the evidence.
7. `fit_gate_result` reflects the [Primary Job Eligibility Gate](../ranking/job-eligibility-gate.md); unknown fit evidence must never be scored as a positive fit.
8. `record_disposition` of Rejected Lead requires a `rejection_reason`; rejected leads must remain visible in the [Unverified and Rejected Job Leads](../outputs/unverified-job-leads-template.md) output rather than being silently dropped.
9. A closed role, or a role failing a hard candidate constraint, must not carry `record_disposition` of Primary Candidate.
10. Every mutable claim on this record requires `checked_at`.
11. `stale_reason` is required whenever `job_status` is Stale.
12. `refresh_required` does not imply automatic refresh; a refresh occurs only after an explicit user request.
13. Company State evidence relevant to this job's employer must be surfaced alongside the role (via `related_company_state_references`), never silently merged into `job_status` — see [Company State Record schema](company-state-record.schema.md) and [job-verification-policy.md](../core/job-verification-policy.md).

## Example Records

**Verified Open, discovered via LinkedIn, cross-checked against the official site**
```text
job_id: "job:northbridge-systems:senior-backend-engineer:2026-07-20"
company_name: "Northbridge Systems"
job_title: "Senior Backend Engineer"
job_location: "Ra'anana"
work_model: "Hybrid"
employment_type: "Full-time"
discovery_source: "LinkedIn Jobs search"
discovery_source_type: "LinkedIn"
discovered_at: "2026-07-20T09:00:00Z"
job_status: "Verified Open"
official_verification_attempted: true
official_verification_result: "Confirmed"
official_verification_url: "https://northbridgesystems.example/careers/senior-backend-engineer"
job_status_checked_at: "2026-07-20T09:10:00Z"
fit_evaluation_status: "Evaluated"
fit_gate_result: "Passes"
record_status: "Verified"
record_disposition: "Primary Candidate"
checked_at: "2026-07-20T09:10:00Z"
```

**Discovered via Glassdoor, official careers site accessible, role not found there**
```text
job_id: "job:meridian-retail-systems:backend-engineer:2026-07-18"
company_name: "Meridian Retail Systems"
job_title: "Backend Engineer"
discovery_source: "Glassdoor listing"
discovery_source_type: "Glassdoor"
discovered_at: "2026-07-18T10:00:00Z"
job_status: "Not Found on Official Site"
official_verification_attempted: true
official_verification_result: "Not Found"
job_status_checked_at: "2026-07-19T09:00:00Z"
fit_evaluation_status: "Not Evaluated"
fit_gate_result: "Not Evaluated"
record_status: "Verified"
record_disposition: "Rejected Lead"
rejection_reason: "Not Found on Official Site"
checked_at: "2026-07-19T09:00:00Z"
```

**Discovered via LinkedIn, official careers site inaccessible**
```text
job_id: "job:riverton-analytics:platform-engineer:2026-07-17"
company_name: "Riverton Analytics"
job_title: "Platform Engineer"
discovery_source: "LinkedIn Jobs search"
discovery_source_type: "LinkedIn"
discovered_at: "2026-07-17T09:00:00Z"
job_status: "Unable to Verify"
official_verification_attempted: true
official_verification_result: "Site Inaccessible"
job_status_checked_at: "2026-07-17T09:20:00Z"
fit_evaluation_status: "Not Evaluated"
fit_gate_result: "Not Evaluated"
record_status: "Verified"
record_disposition: "Rejected Lead"
rejection_reason: "Unable to Verify"
checked_at: "2026-07-17T09:20:00Z"
```

**Official page explicitly closed**
```text
job_id: "job:northbridge-systems:staff-backend-engineer:2026-06-01"
company_name: "Northbridge Systems"
job_title: "Staff Backend Engineer"
discovery_source: "Official careers page"
discovery_source_type: "Official Careers"
discovered_at: "2026-06-01T09:00:00Z"
job_status: "Closed"
job_status_evidence: ["official page states 'This position is no longer accepting applications', checked 2026-07-20"]
official_verification_attempted: true
official_verification_result: "Confirmed"
official_verification_url: "https://northbridgesystems.example/careers/staff-backend-engineer"
job_status_checked_at: "2026-07-20T09:00:00Z"
fit_evaluation_status: "Not Evaluated"
fit_gate_result: "Not Evaluated"
record_status: "Verified"
record_disposition: "Rejected Lead"
rejection_reason: "Closed"
checked_at: "2026-07-20T09:00:00Z"
```

**Verified open role, but fails a hard candidate constraint**
```text
job_id: "job:northbridge-systems:senior-backend-engineer-us:2026-07-20"
company_name: "Northbridge Systems"
job_title: "Senior Backend Engineer (US-based)"
job_location: "Austin, Texas"
work_model: "On-site"
discovery_source: "Official careers page"
discovery_source_type: "Official Careers"
discovered_at: "2026-07-20T09:00:00Z"
job_status: "Verified Open"
official_verification_attempted: true
official_verification_result: "Confirmed"
official_verification_url: "https://northbridgesystems.example/careers/senior-backend-engineer-us"
job_status_checked_at: "2026-07-20T09:00:00Z"
fit_evaluation_status: "Evaluated"
fit_gate_result: "Fails — Hard Constraint"
fit_gate_reason: "Outside candidate's stated geographic constraint (central Israel only); role is on-site in Austin, Texas"
record_status: "Verified"
record_disposition: "Rejected Lead"
rejection_reason: "Location mismatch"
checked_at: "2026-07-20T09:00:00Z"
```

## Related documents

- [../core/data-model.md](../core/data-model.md)
- [../core/job-verification-policy.md](../core/job-verification-policy.md)
- [company-record.schema.md](company-record.schema.md)
- [company-state-record.schema.md](company-state-record.schema.md)
- [activity-record.schema.md](activity-record.schema.md)
- [../ranking/job-eligibility-gate.md](../ranking/job-eligibility-gate.md)
- [../outputs/verified-jobs-map-template.md](../outputs/verified-jobs-map-template.md)
- [../outputs/unverified-job-leads-template.md](../outputs/unverified-job-leads-template.md)
