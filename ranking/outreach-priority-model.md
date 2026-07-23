# Outreach Priority Model

This document defines how the [Company Ranking Model](company-ranking-model.md), [Person Ranking Model](person-ranking-model.md), and [Activity Record](../schemas/activity-record.schema.md) A0–A4 levels combine into a recommended action order for the Outreach Priority Queue. All recommendations here are advisory — the system recommends actions but does not perform them. See [scope-and-non-goals.md](../core/scope-and-non-goals.md) for the non-goals this model must respect.

## Recommended Action Order

1. Relevant hiring manager with an A4 matching job post.
2. Relevant technical recruiter with an A4 matching job post.
3. Relevant hiring manager with A3 hiring activity.
4. Relevant recruiter with A3 hiring activity.
5. Direct application to a currently verified open role.
6. Relevant manager with verified employment but no hiring signal.
7. Relevant recruiter with verified employment but no hiring signal.
8. Follow public activity manually.
9. Perform additional research.
10. Skip.

This order reflects evidence strength, from strongest (a specific matching role, confirmed by the most relevant person) to weakest (insufficient evidence to justify an action). It is a default ordering, not a rigid rule that overrides evidence-specific judgment — see the boundaries below.

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

1. Matching job evidence (an `A4` matching job post outranks anything weaker, regardless of person type).
2. Current job status (`Verified Open` outranks `Post Found, Current Status Unknown`, which outranks the rest).
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
- current job status (`job_status` on the Activity Record);
- evidence confidence (per the [confidence model](../core/confidence-model.md));
- user preferences (from [Search Criteria](../schemas/search-criteria.schema.md));
- duplicate-contact avoidance — the same person should not generate multiple redundant queue entries across overlapping roles at the same company.

## Worked Examples

**Apply Now**
A Priority 1 company has a hiring manager (`person_type`: Engineering Manager, `current_employment_status`: Current) linked to an Activity Record at `A4 — Matching Job Post Found`, `job_status`: Verified Open. Recommended action: Apply Now, with a note to also consider connecting with the manager.

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
- [../schemas/activity-record.schema.md](../schemas/activity-record.schema.md)
- [../core/confidence-model.md](../core/confidence-model.md)
- [../core/scope-and-non-goals.md](../core/scope-and-non-goals.md)
