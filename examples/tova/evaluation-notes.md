# Evaluation Notes — Tova Golden Example

## What the Golden Example Proves

- **Candidate Profile and Search Criteria remain distinct:** [candidate-profile.md](candidate-profile.md) describes who Tova is; [search-criteria.md](search-criteria.md) describes what to search for. The 40-minute commute limit, product-only filtering, and technology strictness all live in Search Criteria, not the profile.
- **Company classification precedes ranking:** [company-map.md](company-map.md) shows every included company already carrying a `company_type` classification before its score is presented; [excluded-companies.md](excluded-companies.md) shows classification decisions (Outsourcing, System Integrator) driving exclusion before any ranking would occur.
- **Excluded companies remain visible:** all 4 Excluded and 1 Needs Review company appear in [excluded-companies.md](excluded-companies.md) with explicit reasons, confidence, and reconsideration conditions — none were silently dropped.
- **Person relevance and current employment are separate:** [people-map.md](people-map.md) shows a person with strong relevance but unresolved employment (Eitan Shalev) scored and treated differently from one with weaker relevance but verified employment (Liora Fein) — relevance and employment status vary independently, as the schema intends.
- **Activity levels A0–A4 work as intended:** [activity-verification.md](activity-verification.md) demonstrates all five levels with concrete synthetic evidence, including the specific requirements at each threshold (A2 needs a dated post, A3 needs hiring content, A4 needs a matching role).
- **Job-post existence and job status remain separate:** two A3/A4 pairs (Roi Ashkenazi/Noa Peretz at Verified Open vs. Yossi Katz/Dana Segal at Post Found, Current Status Unknown) show that a hiring-related post's existence never implies the role is confirmed open.
- **Outreach order follows evidence strength:** [outreach-queue.md](outreach-queue.md)'s 11 entries map exactly onto the 10-step [Recommended Action Order](../../ranking/outreach-priority-model.md#recommended-action-order), with company priority explicitly shown breaking a tie between two same-category entries.
- **No automation or storage assumptions are introduced:** every action in the Outreach Queue is marked `Not started`; [research-state.md](research-state.md) is explicitly documented as a logical progress record, not a database.

## Gaps or Friction Found

These were real points of judgment encountered while building this example against the current specification. They are recorded here rather than silently worked around:

1. **No numeric rubric within a dimension.** The [Company Ranking Model](../../ranking/company-ranking-model.md) and [Person Ranking Model](../../ranking/person-ranking-model.md) define full/partial/low-fit *conditions* per dimension, but not a rubric for choosing, say, 16/20 vs. 12/20 within "partial fit." Two different people applying the model in good faith could reasonably land on different point totals for the same evidence. This example's exact scores (e.g., IndustrialFlow Systems' Role Fit of 19/20 vs. a plausible 17/20) reflect one reasonable interpretation, not a uniquely correct calculation.
2. **No defined re-scoring trigger.** When new evidence changes a scored dimension mid-journey (e.g., a company's technology scope is later found to be broader than first evidenced), neither the Company Record schema nor the Company Ranking Model states whether this should silently update the existing score, mark the record Stale pending re-scoring, or require an explicit re-run of Classify and Rank Companies. This example deliberately avoided that scenario rather than inventing a resolution.
3. **Manager-before-recruiter tie-break is implicit, not stated.** The [Recommended Action Order](../../ranking/outreach-priority-model.md#recommended-action-order) lists "hiring manager" before "recruiter" at the same evidence level (steps 1–2, 6–7), which this example treated as an implicit convention for same-company, same-category, same-score ties (see positions 1–2 in [outreach-queue.md](outreach-queue.md)). Nothing in the model states this explicitly as a tie-breaking rule.
4. **`duplicate_risk` and `duplicate_contact_group` interaction is undefined.** The Person Record schema defines these as separate concepts (identity ambiguity vs. output deduplication), and this example kept them on entirely separate people (Noa Cohen for `duplicate_risk`, the two Dana Segal records for `duplicate_contact_group`) to avoid the question — but no rule states what should happen if a single record legitimately needs both.
5. **Company Map's required columns don't surface every scored dimension.** The [Company Map output template](../../outputs/company-map-template.md)'s required columns include Role Fit, Stack Fit, and Domain Fit, but not System-type fit, Product-company fit, or Location and commute fit — even though all eight dimensions feed the score. This example added a supplementary "Score Calculation Detail" table to keep the arithmetic fully auditable, which the canonical template does not require.

## Expected Future Use

This golden example is expected to later be used to test:

- Claude Skill behavior
- Claude Project behavior
- ChatGPT GPT behavior
- Cross-platform parity (comparing Claude and ChatGPT outputs against this same synthetic input)
- Output validation (checking that generated outputs conform to the templates and column contracts exercised here)

## Related documents

- [source-profile.md](source-profile.md)
- [research-state.md](research-state.md)
- [../../ranking/company-ranking-model.md](../../ranking/company-ranking-model.md)
- [../../ranking/person-ranking-model.md](../../ranking/person-ranking-model.md)
- [../../ranking/outreach-priority-model.md](../../ranking/outreach-priority-model.md)
