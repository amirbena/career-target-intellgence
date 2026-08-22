# Primary Job Eligibility Gate

This document defines the hard eligibility gate a [Job Record](../schemas/job-record.schema.md) must pass before it can enter the primary [Verified Jobs Map](../outputs/verified-jobs-map-template.md) for job-search intent. It builds on [core/job-verification-policy.md](../core/job-verification-policy.md) (how `job_status` is decided) and consumes the [Candidate Profile](../schemas/candidate-profile.schema.md) and [Search Criteria](../schemas/search-criteria.schema.md). It does not replace the [Company Ranking Model](company-ranking-model.md) or [Person Ranking Model](person-ranking-model.md) — those remain in effect for company and person prioritization; this gate is specific to job-search intent and runs before any of them contribute to a job-search recommendation.

## Core Rule

> For job-search intent, company attractiveness cannot compensate for a closed or unverified job, and it cannot compensate for a role that violates a hard candidate constraint. Availability and hard candidate fit are eligibility gates, not soft score dimensions.

A role must pass **both** gates below to receive `record_disposition` of `Primary Candidate` on its Job Record.

## Gate A — Availability

| `job_status` | Gate A result |
|---|---|
| `Verified Open` | Passes |
| `Likely Open / Partially Verified` | Passes, but must appear only in a clearly separate, lower-confidence section — never presented as equivalent to a `Verified Open` result. |
| `Unable to Verify` | Fails |
| `Not Found on Official Site` | Fails |
| `Closed` | Fails |
| `Historical` | Fails |
| `Stale` | Fails until refreshed |

A role failing Gate A is not deleted — it moves to `record_disposition` of `Rejected Lead` with the matching `rejection_reason` and remains visible in the [Unverified and Rejected Job Leads](../outputs/unverified-job-leads-template.md) output.

## Gate B — Candidate Fit

Evaluate the role against the approved [Candidate Profile](../schemas/candidate-profile.schema.md) and [Search Criteria](../schemas/search-criteria.schema.md) on:

- role family / discipline;
- candidate seniority versus the role's stated/evidenced seniority;
- mandatory technologies (the role's `mandatory_requirements`/`required_technologies` versus the candidate's technologies and Search Criteria `technology_exclusions`);
- hard exclusions (the candidate's `excluded_roles`, `excluded_domains`, `excluded_company_types` on the Candidate Profile or Search Criteria);
- geography / commute constraints (Search Criteria `maximum_commute_minutes`, `origin_location`, and the role's `job_location`);
- work model (Search Criteria `preferred_work_models`/`acceptable_work_models` versus the role's `work_model`);
- excluded company/domain constraints;
- any other explicit user must-have stated in the current conversation.

| Result | Meaning |
|---|---|
| Passes | No hard constraint is violated; unknown fields are treated as Unknown, not as a violation. |
| Fails — Hard Constraint | At least one hard constraint above is directly violated by evidenced role data. |

A role that violates a hard constraint must not appear in the primary Verified Jobs Map even when the employing company is highly attractive under the [Company Ranking Model](company-ranking-model.md). Record the specific constraint in `fit_gate_reason` on the Job Record.

**Unknown stays Unknown.** When a fit-relevant field is simply not present in the evidence (e.g., the posting does not state a required technology the candidate lacks), do not treat that absence as either a pass or a fail signal beyond what is actually evidenced — it is not grounds for exclusion, and it is not grounds for a confident positive-fit claim either.

## Gate Outcomes on the Job Record

| Gate A | Gate B | `fit_gate_result` | `record_disposition` |
|---|---|---|---|
| Passes (Verified Open) | Passes | `Passes` | `Primary Candidate` |
| Passes (Likely Open / Partially Verified) | Passes | `Passes` | `Primary Candidate` — placed in the lower-confidence section, per Gate A. |
| Passes | Fails — Hard Constraint | `Fails — Hard Constraint` | `Rejected Lead`, `rejection_reason` matching the violated constraint (e.g., Seniority mismatch, Location mismatch, Hard technology mismatch, User exclusion). |
| Fails | Not evaluated or any | `Fails — Availability` | `Rejected Lead`, `rejection_reason` matching the availability outcome (Closed, Not Found on Official Site, Unable to Verify, Stale). |

Gate A is evaluated first: an unavailable role does not need a fit evaluation to be excluded from the primary map, though a fit evaluation may still be recorded if useful context for the rejected-lead report.

## After the Gate: Ranking Within the Primary Set

Once a role passes both gates, ranking within the Verified Jobs Map may weigh (in no fixed numeric order — this is qualitative prioritization guidance, not a new numeric model):

- candidate/job fit strength (beyond the hard-constraint pass/fail — e.g., preferred-technology overlap, domain match);
- strength of official job verification (`Verified Open` outranks `Likely Open / Partially Verified`);
- company fit, per the [Company Ranking Model](company-ranking-model.md);
- company state, per the linked [Company State Record(s)](../schemas/company-state-record.schema.md) — surfaced as context, never as a silent score adjustment;
- recruiter/contact quality, per the [Person Ranking Model](person-ranking-model.md);
- team/domain relevance;
- evidence confidence and freshness.

Preserve written reasoning alongside any ordering — see [Company Ranking Model Rules](company-ranking-model.md#rules), rule 5, which applies equally here. Do not silently zero out unknown evidence where the underlying ranking model already distinguishes Unknown from a negative signal.

## Rules

1. Availability (Gate A) and hard candidate fit (Gate B) are eligibility gates, not soft-scored dimensions, for job-search intent.
2. Company attractiveness cannot compensate for failing either gate.
3. A role failing either gate is not deleted; it is reclassified as a Rejected Lead with a specific `rejection_reason` and remains visible.
4. `Likely Open / Partially Verified` roles that pass both gates still surface in a separate, clearly lower-confidence section, never merged with `Verified Open` results.
5. Unknown fit evidence is never treated as a positive fit signal, and never treated as an automatic hard-constraint violation either — it is disclosed as Unknown.
6. Company State evidence informs post-gate prioritization and disclosure; it never gates or silently adjusts `job_status` or `fit_gate_result` — see [job-verification-policy.md](../core/job-verification-policy.md#company-state-does-not-gate-job-availability).
7. This gate applies to job-search intent specifically; the Company Targeting journey (no verified role required) is governed by [exclusion-policy.md](exclusion-policy.md) instead, and companies there must explicitly disclose the absence of a current matching role rather than imply one exists.

## Related documents

- [../core/job-verification-policy.md](../core/job-verification-policy.md)
- [../schemas/job-record.schema.md](../schemas/job-record.schema.md)
- [../schemas/company-state-record.schema.md](../schemas/company-state-record.schema.md)
- [company-ranking-model.md](company-ranking-model.md)
- [person-ranking-model.md](person-ranking-model.md)
- [exclusion-policy.md](exclusion-policy.md)
- [outreach-priority-model.md](outreach-priority-model.md)
- [../outputs/verified-jobs-map-template.md](../outputs/verified-jobs-map-template.md)
- [../outputs/unverified-job-leads-template.md](../outputs/unverified-job-leads-template.md)
- [../workflows/job-search-journey.md](../workflows/job-search-journey.md)
