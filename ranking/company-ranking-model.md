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

### Role and seniority fit (max 20)

- **Measures:** How closely the company's likely open or plausible roles match the candidate's target roles and seniority.
- **Evidence required:** Company Record `relevant_roles`, `role_fit_notes`, cross-referenced with the candidate's `target_roles` and `seniority`.
- **Full fit:** Roles at the candidate's exact target seniority and title family are evidenced.
- **Partial fit:** Roles exist in an adjacent seniority or title family (e.g., Lead vs. Senior).
- **Low fit:** No evidenced roles align, or only tangential roles are found.
- **Missing evidence:** If no role evidence exists at all, score conservatively low on this dimension but do not assume the company has no relevant roles — this is a scoring input, not a claim about reality.
- **Confidence effect:** A `Supported Inference` classification (see [confidence-model.md](../core/confidence-model.md)) should not be scored as strongly as a `Verified` one.

### Technology-stack fit (max 20)

- **Measures:** Alignment between the candidate's primary/secondary technologies and the company's `known_technologies`.
- **Evidence required:** Company Record `known_technologies`, `technology_scope`, `technology_confidence`.
- **Full fit:** Strong overlap with `technology_scope` of Company-wide or Business Unit.
- **Partial fit:** Overlap exists but `technology_scope` is Team-specific or Job-specific.
- **Low fit:** No meaningful overlap, or evidence is `Historical`/`Unknown` scope.
- **Missing evidence:** Absence of technology evidence must not be scored as a stack mismatch; score the dimension low for lack of support, not as a penalty for an assumed mismatch.
- **Confidence effect:** `technology_confidence` of Low should cap how much of the 20 points this dimension can contribute.

### Domain fit (max 15)

- **Measures:** Alignment between the candidate's domain experience and the company's `business_domains`/`industries`.
- **Evidence required:** Company Record `business_domains`, `industries`, `domain_fit_notes`.
- **Full fit:** Direct domain match (e.g., billing-to-billing).
- **Partial fit:** Adjacent domain (e.g., billing-to-fintech generally).
- **Low fit:** No discernible domain relationship.
- **Missing evidence:** Score conservatively; do not infer a domain from the company name alone.

### System-type fit (max 10)

- **Measures:** Alignment between the candidate's `system_types`/`production_experience` and the company's `system_types`.
- **Evidence required:** Company Record `system_types`, `system_fit_notes`.
- **Full fit:** Matching system type (e.g., distributed systems-to-distributed systems).
- **Partial fit:** Related but not identical system type.
- **Low fit:** No evidenced overlap.
- **Missing evidence:** Score low for lack of evidence, not as a claim the systems differ.

### Product-company fit (max 10)

- **Measures:** Whether the company's `company_type` matches the candidate's or user's stated preference (e.g., product companies only).
- **Evidence required:** Company Record `company_type`, `company_type_confidence`.
- **Full fit:** `company_type` is Product or Product-led Enterprise, with Medium+ confidence.
- **Partial fit:** `company_type` is Hybrid Product and Services, or Product with Low confidence.
- **Low fit:** `company_type` is Consulting, Outsourcing, System Integrator, Staffing, or Project-based Development.
- **Missing evidence:** `company_type` of Unclear should score low on this dimension but must not be treated as automatic exclusion — see [exclusion-policy.md](exclusion-policy.md).

### Location and commute fit (max 10)

- **Measures:** Alignment with the candidate's commute constraints from Search Criteria.
- **Evidence required:** Company Record `estimated_commute_minutes`, `commute_confidence`, cross-referenced with Search Criteria `maximum_commute_minutes`.
- **Full fit:** Estimated commute comfortably within the stated maximum, with reasonable confidence.
- **Partial fit:** Estimated commute near the boundary, or estimate confidence is low.
- **Low fit:** Estimated commute exceeds the stated maximum.
- **Missing evidence:** No location evidence should score low on this dimension, not be treated as disqualifying by itself.

### Relevant-team evidence (max 10)

- **Measures:** Whether a specific team or business unit relevant to the candidate has been identified.
- **Evidence required:** Company Record `possible_relevant_teams`.
- **Full fit:** A specific, named team with supporting evidence.
- **Partial fit:** A plausible team is named but evidence is thin.
- **Low fit:** No team-level evidence exists.
- **Missing evidence:** Absence of team evidence is common and expected at early research stages; it should reduce this dimension's contribution, not the overall record's credibility.

### Current hiring signal (max 5)

- **Measures:** Whether there is a current, verified hiring signal at the company.
- **Evidence required:** Company Record `hiring_signal_status`.
- **Full fit:** `hiring_signal_status` is Verified Current Role.
- **Partial fit:** `hiring_signal_status` is Recent Hiring Signal.
- **Low fit:** `hiring_signal_status` is Historical Hiring Signal, No Signal Found, or Unable to Verify.
- **Missing evidence:** No hiring signal contributes 0 points here but must not reduce any other dimension — see rules below.

## Priority Tiers

| Tier | Score Range |
|---|---|
| Priority 1 | 80–100 |
| Priority 2 | 60–79 |
| Priority 3 | 40–59 |
| Below 40 | Normally excluded from the final target map |

## Rules

1. The score is an explainability and consistency mechanism, not objective truth.
2. Missing evidence must not be treated as negative evidence automatically.
3. Strong hiring signals must not compensate for poor professional fit — the 5-point cap on Current hiring signal enforces this structurally.
4. Company suitability and current hiring are separate; see [source-policy.md](../core/source-policy.md) and [confidence-model.md](../core/confidence-model.md).
5. Scores must be accompanied by written reasoning.
6. Claim-level confidence remains governed by the [confidence model](../core/confidence-model.md); a high score built on low-confidence evidence must disclose that.

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
