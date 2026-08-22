# Outreach Priority Model

This document defines how the [Company Ranking Model](company-ranking-model.md), [Person Ranking Model](person-ranking-model.md), [Job Record](../schemas/job-record.schema.md) verification state, and [Activity Record](../schemas/activity-record.schema.md) A0–A4 levels combine into a recommended action order for the Outreach Priority Queue. All recommendations here are advisory — the system recommends actions but does not perform them. See [scope-and-non-goals.md](../core/scope-and-non-goals.md) for the non-goals this model must respect.

**Job-first note:** when a [Job Record](../schemas/job-record.schema.md) with `record_disposition` of `Primary Candidate` exists for the company/role in question, its `job_status` (from the [Primary Job Eligibility Gate](job-eligibility-gate.md), decided per [job-verification-policy.md](../core/job-verification-policy.md)) is the strongest available evidence for the "currently verified open role" condition below — it should be preferred over an Activity Record's own `job_status` field when both exist for what appears to be the same role, per [Migration and Compatibility](../core/data-model.md#migration-and-compatibility-job-record).

## Recommended Action Order

1. Relevant hiring manager, with a qualifying Job Record (`job_status` of Verified Open for a matching role, with a current `job_status_checked_at`).
2. Relevant technical recruiter, with a qualifying Job Record (`job_status` of Verified Open for a matching role, with a current `job_status_checked_at`).
3. Relevant hiring manager with an A4 matching job post but no qualifying Job Record (absent, or not yet Verified Open) — matching hiring activity exists, but current availability is unverified.
4. Relevant technical recruiter with an A4 matching job post but no qualifying Job Record (absent, or not yet Verified Open) — matching hiring activity exists, but current availability is unverified.
5. Relevant hiring manager with A3 hiring activity, role not independently Verified Open.
6. Relevant recruiter with A3 hiring activity, role not independently Verified Open.
7. Direct application to a currently verified open role (Job Record `job_status`: Verified Open) with no identified relevant contact yet.
8. Relevant manager with verified employment but no hiring signal.
9. Relevant recruiter with verified employment but no hiring signal.
10. Follow public activity manually.
11. Perform additional research.
12. Skip.

This order reflects evidence strength, from strongest (a specific matching role, confirmed by the most relevant person) to weakest (insufficient evidence to justify an action). It is a default ordering, not a rigid rule that overrides evidence-specific judgment — see the boundaries below.

**Job Record required for "Apply Now":** an outreach action that depends on a role being currently open — most importantly "Apply Now" — requires all of the following:

- a corresponding Job Record exists for the role;
- that Job Record is authoritative for current availability (per [Migration and Compatibility: Job Record](../core/data-model.md#migration-and-compatibility-job-record));
- its `job_status` satisfies the required state (normally `Verified Open`, per [job-eligibility-gate.md — Gate A](job-eligibility-gate.md#gate-a--availability));
- it carries a current `job_status_checked_at`.

Activity Record evidence — including `A4 — Matching Job Post Found` — may strengthen recruiter/manager relevance, hiring-activity signal, and outreach personalization, but it must never substitute for Job Record verification. When only an A4 Activity Record exists with no qualifying Job Record, the recommended action downgrades to "Verify Role" (see [Supported Actions](#supported-actions)) — communicating that matching hiring activity exists, but current availability has not been verified through an authoritative Job Record.

## Supported Actions

- Apply Now
- Connect
- Send Direct Message
- Follow Activity
- Verify Role
- Research Team
- Revisit Later
- Skip

## Evidence Boundaries

- Outreach priority must reflect evidence strength — a higher-ranked action requires the evidence level that justifies it, per the [Person Ranking Model](person-ranking-model.md) and [Activity Record](../schemas/activity-record.schema.md) rules.
- Stale hiring activity must not appear as a current opportunity; a `Stale` or historical Activity Record should route to "Follow Activity," "Research Team," or "Revisit Later," not "Apply Now" or "Send Direct Message."
- Unresolved employment (Person Record `current_employment_status` of Unclear or Unable to Verify) must remain visible in the recommendation and generally caps the recommended action at "Research Team" or lower until resolved.
- Unsupported certainty must be avoided — no recommendation should imply a role is open, or a person will respond, without evidence at the corresponding confidence level.
- "Apply Now" (or any action that asserts a role is currently open) requires a qualifying Job Record — see [Job Record required for "Apply Now"](#recommended-action-order). Activity Record evidence, at any activity level including A4, must never substitute for Job Record verification of current availability; it may only strengthen relevance, hiring-activity signal, or personalization.
- No automatic messages, connection requests, monitoring, or scheduled follow-up. The queue is a prioritized list of suggested next actions for the user to perform manually.
- The system recommends actions but does not perform them.

## Tie-break Sequence

When two candidate outreach entries are otherwise equivalent under the [Recommended Action Order](#recommended-action-order), the following default applies:

> When evidence strength, activity level, role match, current employment, and company priority are otherwise equivalent, a relevant hiring manager ranks before a recruiter, because the manager is more likely to own or influence the matching team's hiring decision.

**Exceptions to the default:**

- A recruiter with direct ownership of the exact verified role may outrank a manager with only general team relevance.
- An unresolved manager (unverified or unclear current employment) must not outrank a verified recruiter.
- User preference may override the default tie-break.
- Duplicate-contact avoidance may change queue order — see [Outreach Queue Inputs](#outreach-queue-inputs) below.

**Complete tie-break sequence**, applied in order until the tie is resolved:

1. Matching job evidence — a Job Record `job_status` of `Verified Open` for a matching role outranks anything weaker, regardless of person type. Absent a qualifying Job Record, an `A4` matching job post is the next-strongest evidence signal *for ordering purposes only*; it never makes "Apply Now" eligible on its own — see [Job Record required for "Apply Now"](#recommended-action-order).
2. Current job status (Job Record `job_status` of `Verified Open` outranks `Likely Open / Partially Verified`, which outranks Activity Record `Post Found, Current Status Unknown`, which outranks the rest).
3. Current employment verification (`Current` outranks `Unclear`/`Unable to Verify`, which outranks `Former`).
4. Company priority (Priority 1 outranks Priority 2 outranks Priority 3).
5. Person relevance score (the [Person Ranking Model](person-ranking-model.md) total, descending).
6. Hiring activity recency (a more recent `activity_date` outranks an older one).
7. Hiring manager before recruiter, when otherwise equivalent — the default described above, applied only after steps 1–6 have not resolved the tie.
8. Confidence (Higher confidence outranks Lower, per the [confidence model](../core/confidence-model.md)).
9. Duplicate-contact avoidance (an entry that is the strongest actionable record in its `duplicate_contact_group` outranks other records in the same group).
10. Stable alphabetical fallback (by person name), so that ordering is deterministic even when every prior step is tied.

## Outreach Queue Inputs

Each entry in the Outreach Queue should consider:

- company priority (from the [Company Ranking Model](company-ranking-model.md));
- person relevance (from the [Person Ranking Model](person-ranking-model.md));
- activity level (A0–A4, from the [Activity Record](../schemas/activity-record.schema.md));
- current job status (`job_status` on the primary [Job Record](../schemas/job-record.schema.md) when one exists for the role, otherwise `job_status` on the Activity Record);
- company state (from any linked [Company State Record](../schemas/company-state-record.schema.md), disclosed as context — never silently folded into the numeric priority);
- evidence confidence (per the [confidence model](../core/confidence-model.md));
- user preferences (from [Search Criteria](../schemas/search-criteria.schema.md));
- duplicate-contact avoidance — the same person should not generate multiple redundant queue entries across overlapping roles at the same company.

## Worked Examples

**Apply Now**
A Priority 1 company has a hiring manager (`person_type`: Engineering Manager, `current_employment_status`: Current) linked to an Activity Record at `A4 — Matching Job Post Found` (`matching_role` confirmed, `hiring_related: true`) whose `related_job_record_reference` points to a Job Record with `job_status`: Verified Open and a current `job_status_checked_at`. Recommended action: Apply Now, with a note to also consider connecting with the manager.

**Verify Role**
A Priority 1 company has a hiring manager (`person_type`: Engineering Manager, `current_employment_status`: Current) linked to an Activity Record at `A4 — Matching Job Post Found` (`matching_role` confirmed as meaningfully matching the candidate, `hiring_related: true`), but no Job Record exists yet for the role (or an existing Job Record has not reached `job_status`: Verified Open). Recommended action: Verify Role — the matching activity is valid evidence of hiring interest and elevates this contact above general A3 activity, but "Apply Now" is not justified until an authoritative Job Record confirms current availability.

**Send Direct Message**
A Priority 2 company has a Technical Recruiter, currently employed, linked to an `A3 — Hiring-related Post Found` Activity Record with `hiring_related: true` but no specific matching role identified. Recommended action: Send Direct Message, referencing the hiring post, without claiming a specific open role.

**Follow Activity**
A Priority 2 company has a relevant hiring manager, currently employed, but the linked Activity Record is `A1 — Activity Page Only` with no dated post found. Recommended action: Follow Activity, noting that no recent evidence justifies a direct approach yet.

**Research Team**
A Priority 1 company has strong fit but no relevant person has been identified yet (no Person Record with sufficient `team_relevance`). Recommended action: Research Team, to identify a relevant contact before any outreach.

**Revisit Later**
A Priority 3 company has a relevant recruiter whose Activity Record is `Stale` (hiring activity found, but outside the current lookback window and not re-verified). Recommended action: Revisit Later, with a note that the evidence needs refreshing before an approach.

**Skip**
A company scored below 40 and is not Excluded (e.g., retained for visibility), with no identified relevant person. Recommended action: Skip.

## Related documents

- [company-ranking-model.md](company-ranking-model.md)
- [person-ranking-model.md](person-ranking-model.md)
- [exclusion-policy.md](exclusion-policy.md)
- [job-eligibility-gate.md](job-eligibility-gate.md)
- [../schemas/activity-record.schema.md](../schemas/activity-record.schema.md)
- [../schemas/job-record.schema.md](../schemas/job-record.schema.md)
- [../schemas/company-state-record.schema.md](../schemas/company-state-record.schema.md)
- [../core/confidence-model.md](../core/confidence-model.md)
- [../core/scope-and-non-goals.md](../core/scope-and-non-goals.md)
- [../core/job-verification-policy.md](../core/job-verification-policy.md)
- [../outputs/verified-jobs-map-template.md](../outputs/verified-jobs-map-template.md)
