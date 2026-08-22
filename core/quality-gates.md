# Quality Gates

This document defines the minimum checks that must pass before returning each research output. It is downstream of [source-policy.md](source-policy.md), [confidence-model.md](confidence-model.md), and [freshness-policy.md](freshness-policy.md), and applies to the outputs described in [product-definition.md](product-definition.md).

## Verified Jobs Map

Before returning a Verified Jobs Map, confirm:

- every entry has `record_disposition` of `Primary Candidate` — see [job-eligibility-gate.md](../ranking/job-eligibility-gate.md);
- `job_status` is `Verified Open` or `Likely Open / Partially Verified`, never `Closed`, `Unable to Verify`, `Not Found on Official Site`, `Historical`, or `Stale`;
- `Likely Open / Partially Verified` entries appear in a clearly separate, lower-confidence section, never merged with `Verified Open`;
- `official_verification_attempted` and `official_verification_result` are present for every entry;
- a LinkedIn/Glassdoor/Indeed/other-board/recruiter-post listing alone never produced `Verified Open` when official verification was possible but not performed;
- a recruiter's hiring post alone never produced `Verified Open`;
- a search-result snippet alone never produced `Verified Open`;
- no entry violates a hard candidate constraint (`fit_gate_result` of `Passes` for every entry);
- `job_status_checked_at` is present and exact on every entry;
- company-state context is shown separately from availability and fit, never merged into either;
- recruiter/hiring-manager references are shown when discovered, or explicitly noted as not yet identified.

## Unverified and Rejected Job Leads

Before returning this output, confirm:

- every role with `record_disposition` of `Rejected Lead` is included, not silently dropped;
- each entry has a specific `rejection_reason` from the canonical list — see [Job Record schema](../schemas/job-record.schema.md#evidence-and-lifecycle);
- `Not Found on Official Site` is never presented as equivalent to `Closed`;
- `Closed` entries carry direct closure evidence and an exact verification date;
- a missing official-verification attempt is visible, not hidden.

## Company Map

Before returning a Company Map, confirm:

- company identity verified or clearly marked;
- company type classified or marked Unclear;
- location evidence present when commute matters;
- technology evidence includes scope;
- suitability is separated from current hiring;
- exclusions include reasons;
- mutable claims include `checked_at`;
- confidence is claim-specific;
- under the Company Targeting Journey, a company with no current matching role is explicitly labeled as such — it must not masquerade as a current job result (see [job-eligibility-gate.md](../ranking/job-eligibility-gate.md), rule 7).

## Company State Verification

Before returning company-state evidence, confirm:

- `event_description` (Fact) and `candidate_impact_assessment` (Fact or Supported Inference) are separated and each explicitly labeled via `impact_assessment_type`;
- a social-media rumor or unsupported post alone did not produce a Verified `evidence_state`;
- a significant negative event (layoffs, closures, insolvency) is corroborated when practical, and `corroborated` reflects that;
- conflicting evidence remains visible via `conflicting_evidence`, not silently resolved;
- this evidence did not automatically mark a Job Record `Closed` — a layoff does not automatically close every job at the company;
- `source_date` (when available) and `checked_at` are both present.

## People Map

Before returning a People Map, confirm:

- person identity is reasonably matched;
- current employment is verified or marked unresolved;
- person type is classified;
- recruiter relevance and managerial relevance are separated;
- duplicate-name risk is considered;
- profile URL is not fabricated;
- activity status is not inferred from an Activity URL alone;
- mutable claims include `checked_at`;
- current employment verification for a recruiter or manager is kept separate from any job's `job_status` — verifying that a person currently works at a company is not the same claim as verifying that a specific role is open.

## Activity Verification

Before returning Activity Verification, confirm:

- A0–A4 level is assigned consistently;
- A2 or above has a specific dated post;
- authorship or repost status is noted when possible;
- exact lookback dates are used;
- hiring relevance is explicit;
- matching-role status is justified;
- current job status is verified separately;
- failed verification is reported rather than omitted.

## Outreach Queue

Before returning an Outreach Queue, confirm:

- recommendations are based on available evidence;
- current employment uncertainty is visible;
- stale hiring signals do not appear as current openings;
- suggested action matches the evidence level;
- unsupported certainty is avoided;
- users are not instructed to automate outreach;
- no private-contact enrichment is included;
- when a Job Record is referenced, the association is disclosed as a suggestion only — no automatic outreach is implied by the association itself.

## Cross-Platform Package Alignment

Before treating a generated ChatGPT Knowledge bundle, Claude Project Knowledge/Instructions, or Claude Skill package as up to date, confirm:

- it was produced by the repository's own build/packaging scripts, never hand-edited;
- it reflects the current canonical `core/`, `schemas/`, `ranking/`, `workflows/`, and `outputs/` content, including the Job Record, Company State Record, job-verification policy, and eligibility gate;
- the three platform surfaces remain semantically aligned — none defines a rule, enum, or threshold the others don't share.

## Universal Final Check

Every factual public-data claim must either have supporting evidence, be explicitly labeled as inference, or be marked as unverified. This applies equally to job-status claims, company-state claims, and candidate-fit claims — see [job-verification-policy.md](job-verification-policy.md) and [job-eligibility-gate.md](../ranking/job-eligibility-gate.md).

## Related documents

- [source-policy.md](source-policy.md)
- [confidence-model.md](confidence-model.md)
- [freshness-policy.md](freshness-policy.md)
- [data-model.md](data-model.md)
- [product-definition.md](product-definition.md)
- [job-verification-policy.md](job-verification-policy.md)
- [../schemas/company-record.schema.md](../schemas/company-record.schema.md)
- [../schemas/person-record.schema.md](../schemas/person-record.schema.md)
- [../schemas/activity-record.schema.md](../schemas/activity-record.schema.md)
- [../schemas/job-record.schema.md](../schemas/job-record.schema.md)
- [../schemas/company-state-record.schema.md](../schemas/company-state-record.schema.md)
- [../ranking/job-eligibility-gate.md](../ranking/job-eligibility-gate.md)
