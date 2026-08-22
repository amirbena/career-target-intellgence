# Verified Jobs Map Template

This is the Markdown presentation template for the Verified Jobs Map (also called the Job Opportunities Map) output — the new canonical **primary** output for job-search intent, built from [Job Records](../schemas/job-record.schema.md) that passed the [Primary Job Eligibility Gate](../ranking/job-eligibility-gate.md), per [core/output-contracts.md](../core/output-contracts.md#verified-jobs-map). All values below are synthetic.

## Disclaimer

> This map contains only roles that passed both the current-availability gate and the candidate-fit gate. It is not a claim that these are the only relevant roles at these companies — see the [Unverified and Rejected Job Leads](unverified-job-leads-template.md) report for roles that did not pass the gate, and why.

This disclaimer must accompany every Verified Jobs Map output.

## Structure

The map has two sections, never merged:

1. **Verified Open** — roles with `job_status` of `Verified Open` that passed both gates.
2. **Likely Open / Partially Verified** — roles with `job_status` of `Likely Open / Partially Verified` that passed both gates. This section must be clearly separated and labeled lower-confidence; it must never be presented as equivalent to the Verified Open section.

## Required Columns

| Column | Source field |
|---|---|
| Job Title | `job_title` |
| Company | `company_name` |
| Location / Work Model | `job_location`, `work_model` |
| Candidate-Fit Summary | `fit_notes`, `fit_gate_result` |
| Availability Status | `job_status` |
| Availability Evidence | `job_status_evidence` |
| Discovery Source | `discovery_source`, `discovery_source_type` |
| Official Verification | `official_verification_result`, `official_verification_url` |
| Job Status Checked At | `job_status_checked_at` |
| Company-State Summary | Linked [Company State Record(s)](../schemas/company-state-record.schema.md) `event_description` + `candidate_impact_assessment`, or "No current company-state evidence found" |
| Company-State Evidence Date / Checked At | Linked Company State Record `source_date` / `checked_at` |
| Recruiter / Hiring-Manager Refs | `related_person_references`, or "Not yet identified" |
| Uncertainty / Caveats | Any Gate A `Likely Open` caveat, stale-evidence notes, or unresolved fit dimensions |
| Record Status | `record_status` |

## Ordering

1. Section (Verified Open before Likely Open / Partially Verified).
2. Within a section: candidate-fit strength, then company priority (per the [Company Ranking Model](../ranking/company-ranking-model.md), when scored), then `job_status_checked_at` descending (most recently checked first).

## Rules

- Only roles with `record_disposition` of `Primary Candidate` appear here — a closed, unverified, or hard-constraint-failing role must never appear in this map (see [job-eligibility-gate.md](../ranking/job-eligibility-gate.md)).
- Company-State evidence is disclosed as context; it must never be presented as changing the Availability Status itself.
- A missing Recruiter / Hiring-Manager reference is shown as "Not yet identified," never omitted from the row.
- Every row must show `job_status_checked_at`.

## Synthetic Example

### Verified Open

| Job Title | Company | Location / Work Model | Candidate-Fit Summary | Availability Status | Discovery Source | Official Verification | Job Status Checked At | Company-State Summary | Recruiter / Hiring-Manager Refs | Uncertainty / Caveats | Record Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Senior Backend Engineer | Northbridge Systems | Ra'anana / Hybrid | Matches target seniority and primary stack (C#, .NET) | Verified Open | LinkedIn Jobs search (LinkedIn) | Confirmed on official careers page | 2026-07-20T09:10:00Z | Company announced an ~8% workforce reduction concentrated in sales on 2026-06-01 (Fact); engineering hiring for this team does not appear directly affected (Supported Inference) | Jordan Ashkenazi, Technical Recruiter | None | Verified |

### Likely Open / Partially Verified

| Job Title | Company | Location / Work Model | Candidate-Fit Summary | Availability Status | Discovery Source | Official Verification | Job Status Checked At | Company-State Summary | Recruiter / Hiring-Manager Refs | Uncertainty / Caveats | Record Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Platform Engineer | Meridian Retail Systems | Tel Aviv / Hybrid | Matches role family; seniority slightly below target (Mid vs. Senior) but within acceptable range | Likely Open / Partially Verified | Official careers page | Confirmed, but posting date/status text was ambiguous | 2026-07-19T14:00:00Z | No current company-state evidence found | Not yet identified | Official page listing exists but freshness could not be fully confirmed | Verified |

## Related documents

- [../schemas/job-record.schema.md](../schemas/job-record.schema.md)
- [../schemas/company-state-record.schema.md](../schemas/company-state-record.schema.md)
- [../ranking/job-eligibility-gate.md](../ranking/job-eligibility-gate.md)
- [../core/job-verification-policy.md](../core/job-verification-policy.md)
- [../core/output-contracts.md](../core/output-contracts.md)
- [unverified-job-leads-template.md](unverified-job-leads-template.md)
- [outreach-queue-template.md](outreach-queue-template.md)
