# Ranking and Exclusions

Adapts the Company Ranking Model, Person Ranking Model, Exclusion Policy,
and Outreach Priority Model for execution inside Claude. These scoring
weights, bands, thresholds, and sequences are canonical — do not alter them,
approximate them, or invent alternate numbers.

**Canonical sources:** [`ranking/company-ranking-model.md`](../../../ranking/company-ranking-model.md),
[`ranking/person-ranking-model.md`](../../../ranking/person-ranking-model.md),
[`ranking/exclusion-policy.md`](../../../ranking/exclusion-policy.md),
[`ranking/outreach-priority-model.md`](../../../ranking/outreach-priority-model.md).

A score is an explainability and consistency mechanism, not an objective
truth claim.

## Shared scoring-band rubric

Every scoring dimension in both ranking models uses the same five bands,
expressed as a percentage of that dimension's maximum points (round half
up):

| Band | % of max |
|---|---|
| Full Fit | 100% |
| Strong Partial Fit | 75% |
| Moderate Partial Fit | 50% |
| Low or Weak Fit | 25% |
| No Supported Fit | 0% |

Point values by dimension maximum:

| Dimension max | Full | Strong | Moderate | Low | None |
|---|---|---|---|---|---|
| 25 | 25 | 19 | 13 | 6 | 0 |
| 20 | 20 | 15 | 10 | 5 | 0 |
| 15 | 15 | 11 | 8 | 4 | 0 |
| 10 | 10 | 8 | 5 | 3 | 0 |
| 5 | 5 | 4 | 3 | 1 | 0 |

Missing evidence is not an automatic negative — it caps the dimension at No
Supported Fit rather than implying a penalty beyond zero.

## Company Ranking Model (8 dimensions, 100 points total)

| Dimension | Max points |
|---|---|
| Role and seniority fit | 20 |
| Technology-stack fit | 20 |
| Domain fit | 15 |
| System-type fit | 10 |
| Product-company fit | 10 |
| Location and commute fit | 10 |
| Relevant-team evidence | 10 |
| Current hiring signal | 5 |

Notes:
- Technology-stack fit caps at Moderate Partial Fit when `technology_confidence`
  is Low.
- Product-company fit scores 0 when `company_type` is Consulting,
  Outsourcing, System Integrator, Staffing, or Project-based Development.
- Current hiring signal (5-point cap) can never compensate for poor fit on
  the other dimensions.

**Priority tiers:**

| Tier | Score range |
|---|---|
| Priority 1 | 80–100 |
| Priority 2 | 60–79 |
| Priority 3 | 40–59 |
| Below 40 | Normally excluded from the final target map |

### Re-scoring triggers

New technology evidence; changed classification; changed team evidence;
changed commute or office location; changed hiring signal; changed target
role or seniority; changed domain or company-type preference; previously
stale evidence refreshed; explicit user correction.

Re-scoring is **not** required for wording-only changes, a reformatted URL,
restated but unchanged evidence, or unrelated candidate fields.

### Re-scoring process (in order)

1. Mark the affected dimensions for refresh.
2. Recompute only the affected dimensions.
3. Recompute the total score and Priority tier.
4. If the change is material (a tier change, or a shift of 10 or more
   points), preserve the prior score in the record's notes.
5. Move an `Approved` or `Verified` record back to `Draft` before
   overwriting its score.
6. Update `checked_at`, `confidence`, and the written reasoning.

Re-scoring never silently overwrites an approved ranking.

## Person Ranking Model (6 dimensions, 100 points total)

| Dimension | Max points |
|---|---|
| Current employment verified | 25 |
| Relevant recruiting or management role | 20 |
| Relevant team or domain | 20 |
| Recent public activity | 10 |
| Recent hiring activity | 15 |
| Matching job signal | 10 |

Notes:
- **Recent public activity** ties to the activity level: A4 = Full (10), A3
  = Strong (8), A2 = Moderate (5), A1 = Low (3), A0 = None (0). An Activity
  URL alone (A0/A1) never earns Full or Strong Fit.
- **Recent hiring activity** requires A3 or higher: A4 + Verified = Full
  (15), A3 + Verified = Strong (11), A3 + Partially Verified = Moderate (8),
  borderline A2/A3 = Low (4), anything below A3 = 0.
- **Matching job signal** requires A4 specifically: A4 with a clear match =
  Full (10), A4 with a partial match = Strong (8); this dimension is
  otherwise effectively binary — Moderate and Low bands rarely apply.

**Recruiters** — prioritize technical recruiting responsibility, current
employment, location/business-unit responsibility, recent hiring activity,
and matching role evidence. Recruiter, Technical Recruiter, Talent
Acquisition, Talent Sourcer, and Recruitment Lead earn Full or Strong on the
role dimension; HR Business Partner and People Partner score Moderate or
lower unless there is specific evidence of recruiting responsibility.

**Hiring managers** — prioritize team-ownership likelihood, role/domain/
system/technology relevance, current employment, recent hiring activity,
and matching role evidence. Team Lead, Engineering Manager, Group Manager,
Director of Engineering, Head of R&D, and VP R&D score proportional to
likely team ownership. Never state that a manager "will manage the
candidate" — use "may manage a relevant team," "appears relevant to this
role family," or "could be involved in hiring for a matching team."

**Ambiguity and uncertainty:** a High `duplicate_risk` reduces confidence
proportionally across all dimensions. Former employment removes eligibility
for the employment dimension and generally excludes the person from active
outreach until re-verified. Unable to Verify / Unavailable activity yields
No Supported Fit on activity dimensions — not a negative score.

## Exclusion Policy

Resolves `exclusion_status`: **Included / Needs Review / Excluded**.

- **Included** — scored across all dimensions; may reach a Priority tier.
- **Needs Review** — may receive a provisional score, explicitly labeled as
  provisional rather than a final tier; no final outreach recommendation
  until reviewed. Typical causes: Unclear `company_type`, conflicting
  evidence, insufficient evidence.
- **Excluded** — does not enter active ranking, does not receive a Priority
  tier, is retained in a separate exclusion report, and requires an
  `exclusion_reason`. Reconsidered only after a Search Criteria change or
  new evidence.

**Common exclusion reasons:** Excluded company type, Outside commute
boundary, Excluded industry, Role mismatch, Seniority mismatch, No
meaningful professional fit, Duplicate company record, Company closed,
Insufficient evidence, User-requested exclusion.

### Rules

1. Exclusion is not the same as a zero score — a zero-scoring Included
   company stays visible at the bottom of the map; an Excluded company is
   removed from the map and reported separately.
2. An excluded company is never hidden silently.
3. Company-type filtering happens before ranking, not merely as a low
   score.
4. Hybrid companies may remain eligible depending on `product_companies_only`
   and `include_hybrid_companies`.
5. An Unclear `company_type` routes to Needs Review, never an automatic
   Excluded.
6. A changed Search Criteria may un-exclude a previously excluded company.

## Outreach Priority Model

**Recommended Action Order (highest priority first):**

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

**Supported Actions:** Apply Now, Connect, Send Direct Message, Follow
Activity, Verify Role, Research Team, Revisit Later, Skip. No action outside
this list may be recommended.

**Evidence boundaries:** stale activity routes only to Follow Activity,
Research Team, or Revisit Later — never Apply Now or Send Direct Message.
Unresolved employment caps the recommended action at Research Team or
lower. No unsupported certainty. The system never performs an action — it
only recommends one for the user to take manually. No automated messages,
connections, monitoring, or scheduled follow-up.

**Tie-break default:** when evidence strength, activity level, role match,
current employment, and company priority are otherwise equivalent, a
relevant hiring manager ranks before a recruiter, because the manager is
more likely to own or influence the matching team's hiring decision.
Exceptions: a recruiter with direct ownership of the exact verified role may
outrank the manager; an unresolved manager never outranks a verified
recruiter; explicit user preference may override; duplicate-contact
avoidance may change the order.

**Complete tie-break sequence (apply in order until resolved):**

1. Matching job evidence — A4 outranks anything weaker, regardless of person
   type.
2. Current job status — Verified Open > Post Found, Current Status Unknown
   > all others.
3. Current employment verification — Current > Unclear/Unable to Verify >
   Former.
4. Company priority — P1 > P2 > P3.
5. Person relevance score (Person Ranking Model total, descending).
6. Hiring activity recency — more recent `activity_date` wins.
7. Hiring manager before recruiter (the default rule above), applied only
   after steps 1–6 remain unresolved.
8. Confidence — Higher > Lower.
9. Duplicate-contact avoidance — the strongest actionable record in a
   `duplicate_contact_group` outranks the others in the same group.
10. Stable alphabetical fallback by person name — the final deterministic
    tiebreaker.

**Outreach Queue inputs:** company priority, person relevance, activity
level (A0–A4), current job status (`job_status`), evidence confidence, user
preferences (Search Criteria), duplicate-contact avoidance.
