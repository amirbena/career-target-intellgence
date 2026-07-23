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

## Resolved by Specification Reconciliation

The five findings originally recorded here were resolved in a dedicated specification-reconciliation task, before Claude and ChatGPT platform packaging began:

1. **No numeric rubric within a dimension** — resolved. Both [Company Ranking Model](../../ranking/company-ranking-model.md#scoring-bands) and [Person Ranking Model](../../ranking/person-ranking-model.md#scoring-bands) now define a shared five-band rubric (Full Fit 100%, Strong Partial Fit 75%, Moderate Partial Fit 50%, Low or Weak Fit 25%, No Supported Fit 0%, half-up rounded), with per-band guidance for every dimension. This example's scores (e.g., IndustrialFlow Systems' Role Fit of 19/20) remain a judgment call within the rubric's guidance, as the rubric is explicitly designed to guide rather than replace judgment.
2. **No defined re-scoring trigger** — resolved. The Company Ranking Model now defines explicit [Re-scoring Triggers](../../ranking/company-ranking-model.md#re-scoring-triggers) and a [Re-scoring Process](../../ranking/company-ranking-model.md#re-scoring-process), referenced from [workflows/classify-and-rank-companies.md](../../workflows/classify-and-rank-companies.md#re-scoring). This example did not need to demonstrate a re-scoring event, since no evidence changed mid-journey.
3. **Manager-before-recruiter tie-break is implicit** — resolved. The [Outreach Priority Model](../../ranking/outreach-priority-model.md#tie-break-sequence) now states the manager-before-recruiter default explicitly, with four named exceptions, inside a complete 10-step tie-break sequence. This example's positions 1–2 (Roi Ashkenazi before Noa Peretz, both IndustrialFlow, both A4) now cite that explicit rule rather than an inferred convention.
4. **`duplicate_risk`/`duplicate_contact_group` interaction is undefined** — resolved. The [Person Record schema](../../schemas/person-record.schema.md#duplicate-lifecycle-fields) now defines both fields' distinct purposes, confirms a record may carry both simultaneously, and includes a synthetic example demonstrating it. This example's own Noa Cohen (`duplicate_risk: High`) and Dana Segal/Dana Segal-Mor (`duplicate_contact_group`) records remain valid illustrations of each field used independently; the schema's new example shows the combined case this journey didn't need.
5. **Company Map doesn't expose all eight dimensions** — resolved. The [Company Map output template](../../outputs/company-map-template.md#required-columns) and [CSV Column Contracts](../../outputs/csv-column-contracts.md#company-map) now include System-type Fit, Product-company Fit, and Location and Commute Fit as required columns, alongside the pre-existing Role Fit, Stack Fit, and Domain Fit. This example's [company-map.md](company-map.md) was updated in the same task to add the three missing columns to its table.

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
