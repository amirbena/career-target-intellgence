# Company Ranking Model

This document defines the platform-independent scoring model used to rank target companies. It builds on the [Company Record](../schemas/company-record.schema.md) and the [confidence model](../core/confidence-model.md), and it feeds the [Outreach Priority Model](outreach-priority-model.md). See [exclusion-policy.md](exclusion-policy.md) for how a company is filtered out of ranking entirely.

The score is an **explainability and consistency mechanism, not objective truth**. It exists to make prioritization reasoning legible and repeatable — not to assert a precise, unarguable measure of fit. Scores must always be accompanied by written reasoning, not presented as a bare number.

## Scoring Dimensions

| Dimension | Maximum Points |
|---|---|
| Role and seniority fit | 20 |
| Technology-stack fit | 20 |
| Domain fit | 15 |
| System-type fit | 10 |
| Product-company fit | 10 |
| Location and commute fit | 10 |
| Relevant-team evidence | 10 |
| Current hiring signal | 5 |
| **Total** | **100** |

Total weights are unchanged from the original model — this document only adds a scoring rubric within each dimension and defines when a score must be revisited.

## Scoring Bands

Every dimension below uses the same five-band rubric, expressed as a percentage of that dimension's maximum points:

| Band | Percentage of maximum |
|---|---|
| Full Fit | 100% |
| Strong Partial Fit | 75% |
| Moderate Partial Fit | 50% |
| Low or Weak Fit | 25% |
| No Supported Fit | 0% |

When a dimension's maximum does not divide evenly, use conventional half-up rounding to the nearest whole point (a value ending in exactly .5 rounds up). The resulting point values for each dimension in this model:

| Dimension max | Full Fit | Strong Partial Fit | Moderate Partial Fit | Low or Weak Fit | No Supported Fit |
|---|---|---|---|---|---|
| 20 | 20 | 15 | 10 | 5 | 0 |
| 15 | 15 | 11 | 8 | 4 | 0 |
| 10 | 10 | 8 | 5 | 3 | 0 |
| 5 | 5 | 4 | 3 | 1 | 0 |

**How the bands are used:**

1. Evidence quality determines which band is justified — the band is a conclusion drawn from the evidence, not a starting assumption.
2. Missing evidence is not automatically No Supported Fit.
3. Missing evidence should normally result in either a lower-confidence provisional score (typically Low or Weak Fit, or Moderate Partial Fit when other evidence partially substitutes) or an unresolved dimension flagged for review — never a default zero applied without consideration.
4. The written explanation remains mandatory for every dimension, regardless of band.
5. The rubric improves consistency across applications of the model, but it does not remove professional judgment — the bands describe evidence quality categories, not a mechanical formula that eliminates interpretation.

### Role and seniority fit (max 20)

- **Measures:** How closely the company's likely open or plausible roles match the candidate's target roles and seniority.
- **Evidence required:** Company Record `relevant_roles`, `role_fit_notes`, cross-referenced with the candidate's `target_roles` and `seniority`.

| Band | Points | Guidance |
|---|---|---|
| Full Fit | 20 | Roles at the candidate's exact target seniority and title family are evidenced. |
| Strong Partial Fit | 15 | Roles at the target title family with only a minor seniority gap (e.g., Senior vs. Lead within the same track). |
| Moderate Partial Fit | 10 | Roles exist in an adjacent seniority or title family (e.g., Lead vs. Senior, or a related but distinct discipline). |
| Low or Weak Fit | 5 | Only tangential roles are found, or the connection to the candidate's target roles is superficial. |
| No Supported Fit | 0 | No evidenced roles align, and no plausible role connection exists. |

- **Missing evidence:** If no role evidence exists at all, this typically lands at Low or Weak Fit rather than No Supported Fit, unless other evidence (e.g., a very small, narrowly-scoped company with no plausible fit) supports the stronger conclusion — do not assume the company has no relevant roles.
- **Confidence effect:** A `Supported Inference` classification (see [confidence-model.md](../core/confidence-model.md)) should not be scored in a higher band than a `Verified` one with equivalent apparent fit.

### Technology-stack fit (max 20)

- **Measures:** Alignment between the candidate's primary/secondary technologies and the company's `known_technologies`.
- **Evidence required:** Company Record `known_technologies`, `technology_scope`, `technology_confidence`.

| Band | Points | Guidance |
|---|---|---|
| Full Fit | 20 | Strong overlap with `technology_scope` of Company-wide or Business Unit. |
| Strong Partial Fit | 15 | Strong overlap, but `technology_scope` is Team-specific. |
| Moderate Partial Fit | 10 | Overlap exists but `technology_scope` is Job-specific, or overlap is partial at a broader scope. |
| Low or Weak Fit | 5 | Minimal overlap, or evidence is `Historical`/`Unknown` scope. |
| No Supported Fit | 0 | No meaningful overlap found. |

- **Missing evidence:** Absence of technology evidence must not be scored as a stack mismatch — it should land at Low or Weak Fit for lack of support, not No Supported Fit as a penalty for an assumed mismatch.
- **Confidence effect:** `technology_confidence` of Low caps this dimension at Moderate Partial Fit or below, regardless of how strong the raw overlap appears.

### Domain fit (max 15)

- **Measures:** Alignment between the candidate's domain experience and the company's `business_domains`/`industries`.
- **Evidence required:** Company Record `business_domains`, `industries`, `domain_fit_notes`.

| Band | Points | Guidance |
|---|---|---|
| Full Fit | 15 | Direct domain match (e.g., billing-to-billing). |
| Strong Partial Fit | 11 | Closely related domain with substantial overlap (e.g., billing-to-payments). |
| Moderate Partial Fit | 8 | Adjacent domain (e.g., billing-to-fintech generally). |
| Low or Weak Fit | 4 | A distant or speculative domain relationship. |
| No Supported Fit | 0 | No discernible domain relationship. |

- **Missing evidence:** Score conservatively (Low or Weak Fit); do not infer a domain from the company name alone.

### System-type fit (max 10)

- **Measures:** Alignment between the candidate's `system_types`/`production_experience` and the company's `system_types`.
- **Evidence required:** Company Record `system_types`, `system_fit_notes`.

| Band | Points | Guidance |
|---|---|---|
| Full Fit | 10 | Matching system type (e.g., distributed systems-to-distributed systems). |
| Strong Partial Fit | 8 | Closely related system type with most characteristics shared. |
| Moderate Partial Fit | 5 | Related but not identical system type. |
| Low or Weak Fit | 3 | A distant or speculative system-type relationship. |
| No Supported Fit | 0 | No evidenced overlap. |

- **Missing evidence:** Score low (Low or Weak Fit) for lack of evidence, not as a claim the systems differ.

### Product-company fit (max 10)

- **Measures:** Whether the company's `company_type` matches the candidate's or user's stated preference (e.g., product companies only).
- **Evidence required:** Company Record `company_type`, `company_type_confidence`.

| Band | Points | Guidance |
|---|---|---|
| Full Fit | 10 | `company_type` is Product or Product-led Enterprise, with High confidence. |
| Strong Partial Fit | 8 | `company_type` is Product or Product-led Enterprise, with Medium confidence. |
| Moderate Partial Fit | 5 | `company_type` is Hybrid Product and Services, or Product with Low confidence. |
| Low or Weak Fit | 3 | `company_type` is Unclear, but some evidence leans toward a suitable type. |
| No Supported Fit | 0 | `company_type` is Consulting, Outsourcing, System Integrator, Staffing, or Project-based Development. |

- **Missing evidence:** `company_type` of Unclear normally lands at Low or Weak Fit and must not be treated as automatic exclusion — see [exclusion-policy.md](exclusion-policy.md).

### Location and commute fit (max 10)

- **Measures:** Alignment with the candidate's commute constraints from Search Criteria.
- **Evidence required:** Company Record `estimated_commute_minutes`, `commute_confidence`, cross-referenced with Search Criteria `maximum_commute_minutes`.

| Band | Points | Guidance |
|---|---|---|
| Full Fit | 10 | Estimated commute comfortably within the stated maximum, with High or Medium confidence. |
| Strong Partial Fit | 8 | Estimated commute within the stated maximum, with Low confidence, or moderately close to the boundary. |
| Moderate Partial Fit | 5 | Estimated commute near the boundary of the stated maximum. |
| Low or Weak Fit | 3 | Estimated commute is uncertain or only slightly over the stated maximum. |
| No Supported Fit | 0 | Estimated commute clearly exceeds the stated maximum. |

- **Missing evidence:** No location evidence should score at Low or Weak Fit, not be treated as disqualifying by itself.

### Relevant-team evidence (max 10)

- **Measures:** Whether a specific team or business unit relevant to the candidate has been identified.
- **Evidence required:** Company Record `possible_relevant_teams`.

| Band | Points | Guidance |
|---|---|---|
| Full Fit | 10 | A specific, named team with strong supporting evidence. |
| Strong Partial Fit | 8 | A specific, named team with moderate supporting evidence. |
| Moderate Partial Fit | 5 | A plausible team is named but evidence is thin. |
| Low or Weak Fit | 3 | Only a general business unit or division is identifiable, not a specific team. |
| No Supported Fit | 0 | No team-level evidence exists. |

- **Missing evidence:** Absence of team evidence is common and expected at early research stages; it should reduce this dimension's contribution (typically to No Supported Fit or Low or Weak Fit), not the overall record's credibility.

### Current hiring signal (max 5)

- **Measures:** Whether there is a current, verified hiring signal at the company.
- **Evidence required:** Company Record `hiring_signal_status`.

| Band | Points | Guidance |
|---|---|---|
| Full Fit | 5 | `hiring_signal_status` is Verified Current Role. |
| Strong Partial Fit | 4 | `hiring_signal_status` is Recent Hiring Signal, with strong corroborating evidence. |
| Moderate Partial Fit | 3 | `hiring_signal_status` is Recent Hiring Signal. |
| Low or Weak Fit | 1 | `hiring_signal_status` is Historical Hiring Signal. |
| No Supported Fit | 0 | `hiring_signal_status` is No Signal Found or Unable to Verify. |

- **Missing evidence:** No hiring signal contributes 0 points here but must not reduce any other dimension — see Rules below.

## Priority Tiers

| Tier | Score Range |
|---|---|
| Priority 1 | 80–100 |
| Priority 2 | 60–79 |
| Priority 3 | 40–59 |
| Below 40 | Normally excluded from the final target map |

Priority thresholds are unchanged from the original model.

## Re-scoring Triggers

A Company Record's score must be recomputed when evidence changes in a way that affects a scoring dimension, including:

- newly verified technology evidence;
- changed company classification;
- changed relevant-team evidence;
- changed commute constraint or office location;
- changed hiring signal;
- changed target role or seniority (from an updated Candidate Profile or Search Criteria);
- changed domain or company-type preference in Search Criteria;
- stale evidence being refreshed;
- a user correction invalidating an earlier assumption.

Re-scoring is **not** required when:

- wording changes without an evidence change;
- a source URL is reformatted;
- unchanged evidence is merely restated;
- unrelated Candidate Profile fields change (fields with no bearing on any of the eight dimensions above).

### Re-scoring Process

1. Mark the affected dimension(s) as requiring refresh (see `refresh_required` on the [Company Record schema](../schemas/company-record.schema.md)).
2. Recompute only the affected dimensions where possible — unaffected dimensions keep their existing score and reasoning.
3. Recompute the total score and Priority tier from the full set of (updated and unchanged) dimension scores.
4. When the change is material (a Priority tier change, or a score shift of 10+ points), preserve the previous score in the reasoning or revision notes rather than silently discarding it.
5. Do not silently overwrite an approved ranking — an Approved or Verified `record_status` should move to Draft (or otherwise be marked as under revision) before the new score replaces it.
6. Update `checked_at`, `confidence`, and the written reasoning to reflect the new evidence.

## Rules

1. The score is an explainability and consistency mechanism, not objective truth.
2. Missing evidence must not be treated as negative evidence automatically.
3. Strong hiring signals must not compensate for poor professional fit — the 5-point cap on Current hiring signal enforces this structurally.
4. Company suitability and current hiring are separate; see [source-policy.md](../core/source-policy.md) and [confidence-model.md](../core/confidence-model.md).
5. Scores must be accompanied by written reasoning.
6. Claim-level confidence remains governed by the [confidence model](../core/confidence-model.md); a high score built on low-confidence evidence must disclose that.
7. Re-scoring follows the triggers and process defined above; it never happens silently on an approved ranking.

## Worked Examples

**Strong direct fit**
Role fit 18/20, stack fit 18/20, domain fit 14/15, system fit 9/10, product-company fit 10/10, location fit 9/10, team evidence 8/10, hiring signal 3/5. Total: 89 → Priority 1. Reasoning: strong, well-evidenced overlap across nearly every dimension, with a recent but not fully verified hiring signal.

**Enterprise fit with partial stack overlap**
Role fit 16/20, stack fit 10/20, domain fit 12/15, system fit 6/10, product-company fit 8/10, location fit 8/10, team evidence 4/10, hiring signal 0/5. Total: 64 → Priority 2. Reasoning: strong role/domain match, but the observed stack overlap is partial and team-specific.

**Strong company with unclear team evidence**
Role fit 17/20, stack fit 16/20, domain fit 13/15, system fit 8/10, product-company fit 10/10, location fit 9/10, team evidence 1/10, hiring signal 0/5. Total: 74 → Priority 2. Reasoning: excellent company-level fit, but no specific relevant team has been identified yet — this is a research gap, not a fit problem.

**Good stack fit but unsuitable company type**
Role fit 12/20, stack fit 17/20, domain fit 8/15, system fit 5/10, product-company fit 2/10, location fit 7/10, team evidence 3/10, hiring signal 0/5. Total: 54 → Priority 3. Reasoning: strong technical overlap, but the company is classified as Outsourcing, which caps the product-company fit dimension.

**Strong fit with no current hiring signal**
Role fit 19/20, stack fit 19/20, domain fit 14/15, system fit 9/10, product-company fit 10/10, location fit 10/10, team evidence 7/10, hiring signal 0/5. Total: 88 → Priority 1. Reasoning: near-ideal fit across every professional dimension; the absence of a hiring signal does not reduce the fit-based dimensions, consistent with Rule 3.

## Related documents

- [../schemas/company-record.schema.md](../schemas/company-record.schema.md)
- [../core/confidence-model.md](../core/confidence-model.md)
- [exclusion-policy.md](exclusion-policy.md)
- [person-ranking-model.md](person-ranking-model.md)
- [outreach-priority-model.md](outreach-priority-model.md)
- [../workflows/classify-and-rank-companies.md](../workflows/classify-and-rank-companies.md)
