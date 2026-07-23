# People Map — Tova (Golden Example)

Built following the [People Map output template](../../outputs/people-map-template.md) and the [Person Ranking Model](../../ranking/person-ranking-model.md). All people below are entirely synthetic. `checked_at` is fixed at `2026-07-23T09:00:00Z`. Activity fields summarize the corresponding entries in [activity-verification.md](activity-verification.md).

## Ordering

By company (matching the [Company Map](company-map.md) order), then by person priority score descending within each company.

## People Map

| Company | Person | Current Title | Person Type | Current Employment | Recruiter Relevance | Managerial Relevance | Team Relevance | LinkedIn Profile | Activity URL | Recent Activity Status | Hiring Activity | Matching Job Signal | Last Verified Activity | Priority Score | Confidence | Duplicate Contact Group | Sources | Checked At |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| IndustrialFlow Systems | Roi Ashkenazi | Engineering Manager | Engineering Manager | Current | — | Owns the backend integration team; may manage a relevant team | Direct — owns the team building the manufacturing/SAP integration backend | https://linkedin.example/in/roi-ashkenazi-example | https://linkedin.example/in/roi-ashkenazi-example/recent-activity | Verified | Verified | Verified | 2026-07-18 | 96 | Medium | — | LinkedIn profile, company careers page | 2026-07-23 |
| IndustrialFlow Systems | Noa Peretz | Senior Technical Recruiter | Technical Recruiter | Current | Owns technical hiring for the backend/integration group | — | Recruits directly for the relevant team | https://linkedin.example/in/noa-peretz-example | https://linkedin.example/in/noa-peretz-example/recent-activity | Verified | Verified | Verified | 2026-07-10 | 96 | Medium | — | LinkedIn profile, company careers page | 2026-07-23 |
| BillingMesh | Yossi Katz | Group Manager, Platform Engineering | Group Manager | Current | — | May manage a relevant team within the platform group | Group-level, not a single named team | https://linkedin.example/in/yossi-katz-example | https://linkedin.example/in/yossi-katz-example/recent-activity | Verified | Verified | Not Checked | 2026-05-05 | 77 | Medium | — | LinkedIn profile | 2026-07-23 |
| BillingMesh | Dana Segal | Recruiter | Recruiter | Current | Handles engineering hiring for the platform group | — | General, not team-specific | https://linkedin.example/in/dana-segal-example | https://linkedin.example/in/dana-segal-example/recent-activity | Verified | Verified | Not Checked | 2026-06-20 | 70 | Medium | billingmesh-dana-segal | LinkedIn profile | 2026-07-23 |
| BillingMesh | Dana Segal-Mor | Talent Acquisition Partner | Talent Acquisition | Current | Same recruiting scope as Dana Segal, found via a separate source | — | General, not team-specific | https://linkedin.example/in/dana-segal-mor-example | https://linkedin.example/in/dana-segal-mor-example/recent-activity | Partially Verified | Not Checked | Not Checked | — | 51 | Low | billingmesh-dana-segal | Company careers page | 2026-07-23 |
| FactoryCore | Eitan Shalev | Director of Engineering | Director of Engineering | Unclear | — | Possibly relevant, but employment could not be confirmed as current | Unclear — no confirmed team ownership found | https://linkedin.example/in/eitan-shalev-example | https://linkedin.example/in/eitan-shalev-example/recent-activity | Stale | Not Checked | Not Checked | 2026-03-02 | 38 | Low | — | LinkedIn profile (last confirmed update predates current employer section) | 2026-07-23 |
| FactoryCore | Michal Bar | Talent Acquisition Specialist | Talent Acquisition | Current | General recruiting scope; no team-specific evidence | — | Weak — no specific team identified | https://linkedin.example/in/michal-bar-example | *(no activity page found)* | Unable to Verify | Not Checked | Not Checked | — | 48 | Low | — | LinkedIn profile | 2026-07-23 |
| EnterpriseOps Suite | Amit Shani | Engineering Manager | Engineering Manager | Current | — | May manage a relevant team; no current hiring evidence | Moderate — team scope stated generally | https://linkedin.example/in/amit-shani-example | https://linkedin.example/in/amit-shani-example/recent-activity | Unable to Verify | Not Checked | Not Checked | — | 50 | Low | — | LinkedIn profile | 2026-07-23 |
| EnterpriseOps Suite | Liora Fein | HR Business Partner | HR Business Partner | Current | General HR scope, not a technical recruiter; lower relevance per [Person Ranking Model](../../ranking/person-ranking-model.md#recruiters) | — | Weak — HR Business Partner role does not indicate team-level involvement | https://linkedin.example/in/liora-fein-example | https://linkedin.example/in/liora-fein-example/recent-activity | Unable to Verify | Not Checked | Not Checked | — | 36 | Low | — | LinkedIn profile (activity page access could not be verified) | 2026-07-23 |
| ProcessGrid | Tal Regev | Former Technical Recruiter | Technical Recruiter | Former | Was a technical recruiter, but no longer employed here — not eligible for active outreach | — | N/A — former employee | https://linkedin.example/in/tal-regev-example | https://linkedin.example/in/tal-regev-example/recent-activity | Verified | Not Checked | Not Checked | 2026-05-01 | 34 | Medium | — | LinkedIn profile | 2026-07-23 |
| DataWorks Product Labs | Noa Cohen | Technical Recruiter | Technical Recruiter | Current | Recruiting scope stated, but identity confidence is reduced by name ambiguity | — | Weak — general recruiting scope | https://linkedin.example/in/noa-cohen-example | https://linkedin.example/in/noa-cohen-example/recent-activity | Partially Verified | Not Checked | Not Checked | — | 35 | Low | — | LinkedIn profile (multiple same-named profiles found; see ambiguity note below) | 2026-07-23 |

## Rules Demonstrated

- **Recruiters and hiring managers distinguishable in the same output:** IndustrialFlow Systems lists both Roi Ashkenazi (Engineering Manager) and Noa Peretz (Technical Recruiter), clearly separated by `Person Type`.
- **Verified current employment:** Roi Ashkenazi, Noa Peretz, Yossi Katz, Dana Segal, Dana Segal-Mor, Michal Bar, Amit Shani, Liora Fein, Noa Cohen — all `Current`.
- **Unresolved employment:** Eitan Shalev — `Unclear`, capped scoring and no active outreach until resolved (see [outreach-queue.md](outreach-queue.md)).
- **Former employee:** Tal Regev — `Former`, excluded from active outreach recommendations regardless of prior relevance.
- **Recruiter vs. general HR relevance:** Noa Peretz/Dana Segal/Michal Bar/Tal Regev/Noa Cohen (recruiting-focused) vs. Liora Fein (HR Business Partner, general HR, deliberately lower recruiter-relevance score per the [Person Ranking Model](../../ranking/person-ranking-model.md#recruiters)).
- **Direct vs. weak team relevance:** Roi Ashkenazi and Noa Peretz (direct — named team) vs. Michal Bar and Liora Fein (weak — no specific team identified).
- **Duplicate-contact grouping:** Dana Segal and Dana Segal-Mor share `duplicate_contact_group: billingmesh-dana-segal` — they were discovered via two different sources but appear to be the same recruiting contact at BillingMesh. This groups them for output deduplication only; both records remain traceable and neither was merged or deleted, per [Person Record Rules](../../schemas/person-record.schema.md#person-record-rules), rule 12.
- **Ambiguous duplicate-name case:** Noa Cohen at DataWorks Product Labs has `duplicate_risk: High` — multiple LinkedIn profiles named "Noa Cohen" with similar titles were found, and it could not be confirmed with confidence which one (if any) corresponds to a DataWorks Product Labs employee. This is identity ambiguity (`duplicate_risk`), distinct from the output-deduplication case above (`duplicate_contact_group`).
- **No fabricated private contact information:** every entry uses only a public LinkedIn-style profile URL; no phone numbers, personal emails, or other private-contact details are included anywhere in this golden example.

## Related documents

- [../../schemas/person-record.schema.md](../../schemas/person-record.schema.md)
- [../../ranking/person-ranking-model.md](../../ranking/person-ranking-model.md)
- [company-map.md](company-map.md)
- [activity-verification.md](activity-verification.md)
- [outreach-queue.md](outreach-queue.md)
