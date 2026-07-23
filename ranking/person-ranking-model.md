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

Total weights are unchanged from the original model. The same six dimensions apply to both recruiters and hiring managers, but interpretation differs by person type, as described below.

## Scoring Bands

Every dimension below uses the same five-band rubric as the [Company Ranking Model](company-ranking-model.md#scoring-bands): Full Fit (100%), Strong Partial Fit (75%), Moderate Partial Fit (50%), Low or Weak Fit (25%), No Supported Fit (0%), using conventional half-up rounding to the nearest whole point. The resulting point values for each dimension in this model:

| Dimension max | Full Fit | Strong Partial Fit | Moderate Partial Fit | Low or Weak Fit | No Supported Fit |
|---|---|---|---|---|---|
| 25 | 25 | 19 | 13 | 6 | 0 |
| 20 | 20 | 15 | 10 | 5 | 0 |
| 15 | 15 | 11 | 8 | 4 | 0 |
| 10 | 10 | 8 | 5 | 3 | 0 |

The same interpretation rules apply as in the Company Ranking Model: evidence quality determines the band; missing evidence is not automatically No Supported Fit; a written explanation remains mandatory; and the rubric guides but does not replace judgment.

### Current employment verified (max 25)

- **Evidence required:** Person Record `current_employment_status`, `employment_verification`, `employment_checked_at`.

| Band | Points | Guidance |
|---|---|---|
| Full Fit | 25 | `current_employment_status` is Current, with recent, direct `employment_checked_at` evidence. |
| Strong Partial Fit | 19 | `current_employment_status` is Current, but evidence is somewhat dated or indirect. |
| Moderate Partial Fit | 13 | `current_employment_status` is Unclear, with some supporting evidence leaning toward current. |
| Low or Weak Fit | 6 | `current_employment_status` is Unclear, with little or conflicting evidence. |
| No Supported Fit | 0 | `current_employment_status` is Former or Unable to Verify. |

Former employment does not disqualify the record from existing, but it removes eligibility for outreach prioritization until updated evidence shows current employment.

### Relevant recruiting or management role (max 20)

- **Evidence required:** Person Record `person_type`, `person_type_evidence`.
- Interpreted differently for recruiters vs. hiring managers — see the role-specific sections below.

| Band | Points | Guidance |
|---|---|---|
| Full Fit | 20 | The role is clearly and specifically recruiting- or management-relevant, with strong supporting evidence. |
| Strong Partial Fit | 15 | The role is clearly relevant, with moderate supporting evidence. |
| Moderate Partial Fit | 10 | The role is plausibly relevant, but the title or evidence is generic (e.g., general HR without confirmed recruiting responsibility). |
| Low or Weak Fit | 5 | The role has a weak or indirect connection to recruiting or management. |
| No Supported Fit | 0 | No evidence connects the role to recruiting or management responsibility. |

### Relevant team or domain (max 20)

- **Evidence required:** Person Record `team_relevance`, `domain_relevance`, `technology_relevance`.

| Band | Points | Guidance |
|---|---|---|
| Full Fit | 20 | Direct evidence ties the person to a specific team or domain matching the candidate. |
| Strong Partial Fit | 15 | Direct evidence ties the person to a broader group (e.g., a department) containing the relevant team. |
| Moderate Partial Fit | 10 | General relevance without a specific team, but a plausible connection exists. |
| Low or Weak Fit | 5 | Only a tenuous or speculative connection to a relevant team or domain. |
| No Supported Fit | 0 | No team or domain relevance evidence. |

### Recent public activity (max 10)

- **Evidence required:** The linked Activity Record's `activity_level`.

| Band | Points | Guidance |
|---|---|---|
| Full Fit | 10 | `A4` — a verified, dated post matching a specific role within the lookback window. |
| Strong Partial Fit | 8 | `A3` — a verified, dated, hiring-related post within the lookback window. |
| Moderate Partial Fit | 5 | `A2` — a verified, dated, non-hiring post within the lookback window. |
| Low or Weak Fit | 3 | `A1` — an activity page exists, but no specific dated post was found. |
| No Supported Fit | 0 | `A0` — profile only, or no activity evidence at all. |

An Activity URL alone (`A0` or `A1`) never earns Full Fit or Strong Partial Fit on this dimension — points require at least `A2 — Recent Post Found`, consistent with `A1`'s Low or Weak Fit ceiling above.

### Recent hiring activity (max 15)

- **Evidence required:** The linked Activity Record's `activity_level` and `hiring_related` field.

| Band | Points | Guidance |
|---|---|---|
| Full Fit | 15 | `A4` with `verification_status` Verified and clear hiring relevance. |
| Strong Partial Fit | 11 | `A3` with `verification_status` Verified. |
| Moderate Partial Fit | 8 | `A3` with `verification_status` Partially Verified. |
| Low or Weak Fit | 4 | Hiring-related content exists but could not be fully verified, or is borderline `A2`/`A3`. |
| No Supported Fit | 0 | No `A3`+ hiring-related evidence exists. |

Requires at least `A3 — Hiring-related Post Found` to earn any points beyond No Supported Fit.

### Matching job signal (max 10)

- **Evidence required:** The linked Activity Record.

| Band | Points | Guidance |
|---|---|---|
| Full Fit | 10 | `A4` with a role clearly and meaningfully matching the candidate's target roles. |
| Strong Partial Fit | 8 | `A4` with a role that partially matches (e.g., correct discipline, adjacent seniority). |
| Moderate Partial Fit | 5 | *(rarely applicable — see note below)* |
| Low or Weak Fit | 3 | *(rarely applicable — see note below)* |
| No Supported Fit | 0 | No `A4` evidence exists — `A3` alone (hiring-related but not role-matching) earns 0 points on this dimension. |

A matching job signal requires `A4 — Matching Job Post Found` evidence specifically; the Moderate Partial Fit and Low or Weak Fit bands exist for consistency with the shared rubric but will rarely apply in practice, since this dimension is effectively binary on whether `A4` evidence exists.

## Recruiters

For recruiters, prioritize:

- technical recruiting responsibility;
- current employment;
- responsibility for the relevant location or business unit;
- recent hiring activity;
- matching role evidence.

`person_type` values of Recruiter, Technical Recruiter, Talent Acquisition, Talent Sourcer, or Recruitment Lead should score in the Full Fit or Strong Partial Fit band on the "Relevant recruiting or management role" dimension when supported by evidence. General HR or People roles (HR Business Partner, People Partner) should normally score in the Moderate Partial Fit band or lower on this dimension unless recruiting responsibility is specifically supported by evidence.

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

- Ambiguous identities (per Person Record `duplicate_risk`) reduce confidence in every dimension proportionally; a High `duplicate_risk` record should not score at full confidence regardless of how strong the individual dimension evidence looks — see [Person Record — `duplicate_risk` and `duplicate_contact_group`](../schemas/person-record.schema.md#duplicate-lifecycle-fields) for how this differs from `duplicate_contact_group`.
- Former employment (per `current_employment_status`) removes eligibility for the "Current employment verified" dimension and should generally exclude the person from an active outreach recommendation until re-verified.
- Unavailable activity (`profile_status` of Unavailable, or an Activity Record with `verification_status` of Unable to Verify) scores the "Recent public activity" and "Recent hiring activity" dimensions at No Supported Fit, not negatively — absence of evidence is not evidence of absence.
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
