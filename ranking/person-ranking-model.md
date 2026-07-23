# Person Ranking Model

This document defines the platform-independent scoring model used to rank recruiters and potential hiring managers. It builds on the [Person Record](../schemas/person-record.schema.md), the [Activity Record](../schemas/activity-record.schema.md) A0–A4 levels, and the [confidence model](../core/confidence-model.md), and it feeds the [Outreach Priority Model](outreach-priority-model.md).

As with the [Company Ranking Model](company-ranking-model.md), the score is an explainability and consistency mechanism, not objective truth, and must be accompanied by written reasoning.

## Shared Evidence Model

| Dimension | Maximum Points |
|---|---|
| Current employment verified | 25 |
| Relevant recruiting or management role | 20 |
| Relevant team or domain | 20 |
| Recent public activity | 10 |
| Recent hiring activity | 15 |
| Matching job signal | 10 |
| **Total** | **100** |

The same six dimensions apply to both recruiters and hiring managers, but interpretation differs by person type, as described below.

### Current employment verified (max 25)

- **Evidence required:** Person Record `current_employment_status`, `employment_verification`, `employment_checked_at`.
- **Full credit:** `current_employment_status` is Current, with recent `employment_checked_at`.
- **Partial credit:** `current_employment_status` is Unclear but with some supporting evidence.
- **No credit:** `current_employment_status` is Former or Unable to Verify.
- Former employment does not disqualify the record from existing, but it removes eligibility for outreach prioritization until updated evidence shows current employment.

### Relevant recruiting or management role (max 20)

- **Evidence required:** Person Record `person_type`, `person_type_evidence`.
- Interpreted differently for recruiters vs. hiring managers — see the role-specific sections below.

### Relevant team or domain (max 20)

- **Evidence required:** Person Record `team_relevance`, `domain_relevance`, `technology_relevance`.
- **Full credit:** Direct evidence ties the person to a team or domain matching the candidate.
- **Partial credit:** General relevance without a specific team.
- **No credit:** No team or domain relevance evidence.

### Recent public activity (max 10)

- **Evidence required:** The linked Activity Record's `activity_level`.
- An Activity URL alone (`A0` or `A1`) earns **no** recent-activity points. Points require at least `A2 — Recent Post Found`.
- Full credit requires a verified, dated post within the requested lookback window.

### Recent hiring activity (max 15)

- **Evidence required:** The linked Activity Record's `activity_level` and `hiring_related` field.
- Requires at least `A3 — Hiring-related Post Found` to earn any points.
- Full credit requires `A3` or `A4` with `verification_status` of Verified.

### Matching job signal (max 10)

- **Evidence required:** The linked Activity Record.
- A matching job signal requires `A4 — Matching Job Post Found` evidence specifically. `A3` alone (hiring-related but not role-matching) earns 0 points on this dimension.

## Recruiters

For recruiters, prioritize:

- technical recruiting responsibility;
- current employment;
- responsibility for the relevant location or business unit;
- recent hiring activity;
- matching role evidence.

`person_type` values of Recruiter, Technical Recruiter, Talent Acquisition, Talent Sourcer, or Recruitment Lead should score fully on the "Relevant recruiting or management role" dimension when supported by evidence. General HR or People roles (HR Business Partner, People Partner) should receive lower relevance on this dimension unless recruiting responsibility is specifically supported by evidence.

## Hiring Managers

For hiring managers, prioritize:

- likely ownership of a relevant engineering team;
- role, domain, system, or technology relevance;
- current employment;
- recent hiring activity;
- matching role evidence.

`person_type` values of Team Lead, Engineering Manager, Group Manager, Director of Engineering, Head of R&D, or VP R&D should score on the "Relevant recruiting or management role" dimension in proportion to how directly they likely own a relevant team.

Do not claim that a manager "will manage the candidate." Use wording such as:

- "may manage a relevant team";
- "appears relevant to this role family";
- "could be involved in hiring for a matching team."

## Ambiguity and Uncertainty

- Ambiguous identities (per Person Record `duplicate_risk`) reduce confidence in every dimension proportionally; a High `duplicate_risk` record should not score at full confidence regardless of how strong the individual dimension evidence looks.
- Former employment (per `current_employment_status`) removes eligibility for the "Current employment verified" dimension and should generally exclude the person from an active outreach recommendation until re-verified.
- Unavailable activity (`profile_status` of Unavailable, or an Activity Record with `verification_status` of Unable to Verify) scores the "Recent public activity" and "Recent hiring activity" dimensions at 0, not negatively — absence of evidence is not evidence of absence.
- An Activity URL alone earns no recent-activity points, as stated above.
- A matching job signal requires `A4` evidence, as stated above.

## Worked Examples

**Recruiter example**
Employment verified 25/25, recruiting role 18/20, team/domain relevance 14/20, recent activity 7/10, recent hiring activity 12/15, matching job signal 8/10. Total: 84. Reasoning: currently employed Technical Recruiter with a verified `A4` matching job post for a role aligned with the candidate's target role.

**Hiring manager example**
Employment verified 25/25, management role 15/20, team/domain relevance 16/20, recent activity 4/10 (only `A2` evidence, not hiring-related), recent hiring activity 0/15 (no `A3`+ evidence), matching job signal 0/10. Total: 60. Reasoning: an Engineering Manager whose team appears relevant, with confirmed current employment and some recent activity, but no hiring-related or matching-job evidence found yet.

## Related documents

- [../schemas/person-record.schema.md](../schemas/person-record.schema.md)
- [../schemas/activity-record.schema.md](../schemas/activity-record.schema.md)
- [../core/confidence-model.md](../core/confidence-model.md)
- [company-ranking-model.md](company-ranking-model.md)
- [outreach-priority-model.md](outreach-priority-model.md)
