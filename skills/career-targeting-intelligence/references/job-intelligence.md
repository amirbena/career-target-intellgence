# Job Intelligence

Adapts the Job Record schema, the Company State Record schema, the Current Job Verification Policy, and the Discover Jobs / Verify Job / Evaluate Candidate–Job Fit / Verify Company State workflows for execution inside Claude. This is the primary reference for the Job Search Journey — the default journey for job-discovery intent ("find me jobs" and equivalents). The eligibility-gate mechanics live in [`ranking-and-exclusions.md`](ranking-and-exclusions.md) — do not restate or re-derive them here.

**Canonical sources:** [`schemas/job-record.schema.md`](../../../schemas/job-record.schema.md),
[`schemas/company-state-record.schema.md`](../../../schemas/company-state-record.schema.md),
[`core/job-verification-policy.md`](../../../core/job-verification-policy.md),
[`workflows/job-search-journey.md`](../../../workflows/job-search-journey.md),
[`workflows/discover-jobs.md`](../../../workflows/discover-jobs.md),
[`workflows/verify-job.md`](../../../workflows/verify-job.md),
[`workflows/evaluate-candidate-job-fit.md`](../../../workflows/evaluate-candidate-job-fit.md),
[`workflows/verify-company-state.md`](../../../workflows/verify-company-state.md).

## Core principle

None of the following, alone, proves a specific job is currently open: a company being attractive, a recruiter's hiring-related post, a LinkedIn job page, a Glassdoor listing, an Indeed listing, a search-result snippet, or historical hiring evidence. Prefer fewer strongly verified matches over many stale, closed, weak, or unverifiable ones.

## Job Record

- **Identity** — `job_id`, `company_name` (required), `job_title` (required), `job_url`, `official_job_url`, `external_job_urls`, `job_location`, `work_model` (On-site / Hybrid / Remote / Unknown, required), `employment_type` (Full-time / Part-time / Contract / Internship / Unknown, required), `team_or_org`.
- **Discovery** — `discovery_source` (required), `discovery_source_type` (Official Careers / LinkedIn / Glassdoor / Indeed / Other Job Board / Recruiter Post / Search Result / Other, required), `discovered_at` (required).
- **Current Availability** — `job_status` (Verified Open / Likely Open, Partially Verified / Unable to Verify / Not Found on Official Site / Closed / Historical / Stale, required), `job_status_evidence`, `job_status_checked_at` (required), `official_verification_attempted` (required), `official_verification_result` (Confirmed / Not Found / Site Inaccessible / Not Attempted, required), `official_verification_url`, `source_date`, `stale_reason` (required when Stale), `refresh_required`.
- **Role Requirements and Fit Inputs** — `seniority`, `discipline`, `required_technologies`, `preferred_technologies`, `domain`, `relevant_systems`, `responsibilities`, `management_expectations`, `mandatory_requirements`, `exclusions`. Never infer a requirement not present in the evidence.
- **Candidate-Fit Evaluation** — `fit_evaluation_status`, `fit_gate_result` (Passes / Fails — Hard Constraint / Fails — Availability / Not Evaluated, required), `fit_gate_reason`, `fit_notes`.
- **Related Records** — `related_activity_record_references`, `related_company_state_references`, `related_person_references`.
- **Evidence and Lifecycle** — `sources`, `checked_at` (required), `confidence` (Low/Medium/High, required), `record_status` (Draft/Verified/Approved/Stale/Superseded, required), `record_disposition` (Primary Candidate / Lower-Confidence Candidate / Rejected Lead / Not Yet Evaluated, required), `rejection_reason` (Closed / Not Found on Official Site / Unable to Verify / Seniority mismatch / Location mismatch / Hard technology mismatch / User exclusion / Stale / Duplicate — required when Rejected Lead).

### Job Record rules

1. A Job Record is a first-class record — never merely nested evidence inside a Company or Activity Record.
2. `job_status` is decided per the verification policy below; a discovery source alone never sets Verified Open.
3. A discovery from LinkedIn/Glassdoor/Indeed/other-board/recruiter-post/search-result is discovery evidence only.
4. Absence from an official careers search means the check failed or the listing may be stale, not automatic closure.
5. Record `official_verification_attempted`/`official_verification_result` even when the attempt failed.
6. Never infer technologies/requirements/exclusions absent from the evidence.
7. Unknown fit evidence is never a positive fit signal.
8. A `Rejected Lead` requires a `rejection_reason` and stays visible in the Unverified/Rejected Job Leads output — never silently dropped.
9. A closed role, or one failing a hard constraint, never carries `record_disposition: Primary Candidate`.
10. Every mutable claim needs `checked_at`.
11. Company-state evidence is surfaced alongside the role, never merged into `job_status`.

## Current Job Verification Policy (summary)

Source hierarchy for current availability, strongest first: (1) official company careers site, (2) official ATS/job page the company controls or links, (3) other official company recruitment source. Third-party sources (LinkedIn, Glassdoor, Indeed, aggregators, recruiter posts, search snippets) may discover a role; they must not alone produce Verified Open.

**Mandatory cross-check:** when a role is discovered via a secondary source, attempt to verify it against the official careers site/ATS whenever publicly accessible, and record the attempt's outcome regardless of result.

| Situation | `job_status` |
|---|---|
| Found and current on an official source | Verified Open |
| Third-party source; official site inaccessible | Unable to Verify |
| Third-party source; official site accessible, role not found there | Not Found on Official Site (preserve the lead — never silently drop, never auto-Closed) |
| Official page explicitly states closed/expired | Closed (with exact date and evidence) |
| Search-result snippet only | Not a verification outcome — attempt the cross-check before assigning any availability-implying status |
| Official evidence exists but is not fully conclusive | Likely Open / Partially Verified — must appear in a clearly separate, lower-confidence section, never equated with Verified Open |

Do the full canonical policy justice by reading [`core/job-verification-policy.md`](../../../core/job-verification-policy.md) directly when a nuanced case arises — this is a summary, not a replacement.

## Company State Record

- **Event** — `company_state_id`, `company_name` (required), `event_type` (Layoffs / Repeated Layoffs / Hiring Freeze / Restructuring / Office/Site Closure / Acquisition or Merger / Insolvency or Distress / Major Funding / Strong Expansion / Major Hiring Expansion / Leadership Change / Strategic Pivot / Major Business Contraction / Unusual Attrition Signal / Other, required), `event_description` (required, factual only), `affected_scope`, `magnitude` (only when directly evidenced).
- **Source and Freshness** — `source_date`, `checked_at` (required), `source_urls`, `source_category` (required; a Social Media/Unsupported Post caps `evidence_state` at Unverified or below), `corroborated` (required for significant negative events), `currency_assessment` (Current / Materially Relevant Though Older / Likely Superseded / Unknown, required), `stale_reason` (required when Likely Superseded).
- **Evidence State** — `evidence_state`, `confidence`, `conflicting_evidence` (kept visible, never silently resolved).
- **Impact Assessment** — `impact_assessment_type` (Fact / Supported Inference, required), `candidate_impact_assessment`, `risk_opportunity_classification` (optional).

**Never** convert a factual event into an unlabeled conclusion like "bad company." **Never** let this record change a Job Record's `job_status` or a Company Record's stable classification. A layoff does not auto-close every job at the company; layoffs in an unrelated business unit do not taint the candidate's target team; growth/funding evidence never proves a specific role is open.

## Job Search Journey procedure (summary)

1. **Current Job Discovery** — cast a wide, criteria-guided net across official careers pages, LinkedIn, Glassdoor, Indeed, other boards, and recruiter posts. Populate Identity/Discovery only; leave availability and fit for later stages.
2. **Current Job Verification** — apply the policy above to every discovered role. Do not require Activity Verification of a person's posts as a precondition — the official careers page can settle availability on its own.
3. **Candidate–Job Fit** — evaluate role family/discipline, seniority, mandatory technologies, hard exclusions, geography/commute, work model, and any explicit user must-have against the approved Candidate Profile and Search Criteria. Unknown stays Unknown — never a pass or fail signal by itself. A hard-constraint violation excludes the role regardless of company attractiveness.
4. **Company State Verification** — surface relevant, recent organizational developments for the employer of each role that passed the gate, using the preferred source order in [`quality-and-trust.md`](quality-and-trust.md). Disclose as context; never merge into availability or fit.
5. **Recruiter/Hiring-Manager Discovery** — identify contacts for the companies behind primary roles (see [`people-intelligence.md`](people-intelligence.md)).
6. **Outreach Prioritization** — build the queue (see [`ranking-and-exclusions.md`](ranking-and-exclusions.md), [`output-generation.md`](output-generation.md)), optionally associating a specific verified Job Record with a contact — descriptive only, never automatic outreach.

A role failing either gate moves to `Rejected Lead` with a specific reason and stays visible in the Unverified/Rejected Job Leads output — it is not deleted. See [`output-generation.md`](output-generation.md) for both output shapes.

## Explicit non-actions

- Do not treat a job-board listing's continued existence as proof of continued availability.
- Do not treat a recruiter's post as job verification — that's Activity evidence, handled separately in [`activity-verification.md`](activity-verification.md).
- Do not auto-close every role at a company because one role was found closed, or because of a layoff elsewhere.
- Do not perform background or scheduled job/company-state monitoring — every check follows an explicit user request.
