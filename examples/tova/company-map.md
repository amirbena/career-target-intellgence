# Company Map — Tova (Golden Example)

Built following the [Company Map output template](../../outputs/company-map-template.md), the [Company Ranking Model](../../ranking/company-ranking-model.md), and the [Exclusion Policy](../../ranking/exclusion-policy.md). All companies below are **entirely synthetic** — no live research was performed. `checked_at` is fixed at `2026-07-23T09:00:00Z` across this entire golden example.

> The target-company map is not a claim that every listed company is currently hiring or that every team uses the same technology stack. Team-level technology and current hiring status must be verified before outreach.

## Ordering

1. Priority tier
2. Score, descending
3. Confidence
4. Company name

## Company Map

| Priority | Score | Company | Relevant Location | Estimated Commute | Company Type | Product / Domain | Relevant Roles | Technology Evidence | Technology Scope | Role Fit | Stack Fit | Domain Fit | Relevant Team Evidence | Current Hiring Signal | Confidence | Why It Fits | Sources | Checked At |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Priority 1 | 93 | IndustrialFlow Systems | Ramat Gan | ~28 min (estimated) | Product | Manufacturing Execution System / manufacturing | Senior .NET Developer, Senior Backend Engineer | C#, .NET, SQL Server, REST APIs | Company-wide | 19/20 | 19/20 | 14/15 | 8/10 | 5/5 | Medium | Direct MES/manufacturing domain match with a company-wide C#/.NET/SQL Server stack; team-specific evidence of a backend integration team; verified current open role. | https://industrialflow.example, https://industrialflow.example/careers | 2026-07-23 |
| Priority 1 | 86 | BillingMesh | Givatayim | ~38 min (estimated) | Product | Billing/invoicing platform / billing, payments | Senior Backend Engineer | C#, SQL Server | Job-specific | 18/20 | 17/20 | 15/15 | 7/10 | 3/5 | Medium | Exact billing/payments domain match to Tova's Aman Group background; strong stack overlap evidenced by two job-specific postings; recent (not fully current) hiring signal. | https://billingmesh.example, https://billingmesh.example/careers | 2026-07-23 |
| Priority 2 | 65 | FactoryCore | Petah Tikva | ~33 min (estimated) | Product | Manufacturing operations software / manufacturing | Backend Engineer | .NET (job-specific mention only) | Job-specific | 15/20 | 10/20 | 14/15 | 2/10 | 0/5 | Low | Strong manufacturing-domain fit, but the only technology evidence is a single job-specific mention and no relevant team has been identified yet — a research gap, not a fit problem. | https://factorycore.example | 2026-07-23 |
| Priority 2 | 61 | EnterpriseOps Suite | Herzliya | ~35 min (estimated) | Product | Enterprise operations suite / enterprise systems | Backend Engineer | Java, REST APIs | Company-wide | 14/20 | 8/20 | 11/15 | 4/10 | 0/5 | Medium | Strong enterprise-domain and product-company fit, but the company-wide stack is Java-based with only partial REST API overlap with Tova's C#/.NET background. | https://enterpriseops.example, https://enterpriseops.example/careers | 2026-07-23 |
| Priority 3 | 55 | ProcessGrid | Bnei Brak | ~32 min (estimated) | Product | Workflow automation / process management | QA Automation Engineer (posted role does not match target roles) | C#, SQL Server | Job-specific | 9/20 | 12/20 | 9/15 | 3/10 | 3/5 | Low | Some stack and domain overlap, but the only currently posted role (QA Automation) does not match Tova's target roles; recent hiring signal exists but for an unrelated role. | https://processgrid.example, https://processgrid.example/careers | 2026-07-23 |
| Priority 3 | 47 | DataWorks Product Labs | Tel Aviv | ~25 min (estimated) | Product | Data-platform product suite / data infrastructure | Data Platform Engineer | Python, Go | Company-wide | 8/20 | 9/20 | 6/15 | 1/10 | 0/5 | Low | Clear product company with a short commute, but limited role, stack, and domain overlap with Tova's manufacturing/billing backend background. | https://dataworks.example | 2026-07-23 |

## Score Calculation Detail

Each score is the sum of the eight [Company Ranking Model](../../ranking/company-ranking-model.md) dimensions (Role and seniority fit /20, Technology-stack fit /20, Domain fit /15, System-type fit /10, Product-company fit /10, Location and commute fit /10, Relevant-team evidence /10, Current hiring signal /5), with System-type fit and Location and commute fit shown below (they are not in the summary table for column-count reasons but are included in the score):

| Company | Role Fit | Stack Fit | Domain Fit | System Fit | Product-company Fit | Location Fit | Team Evidence | Hiring Signal | **Total** | **Tier** |
|---|---|---|---|---|---|---|---|---|---|---|
| IndustrialFlow Systems | 19 | 19 | 14 | 9 | 10 | 9 | 8 | 5 | **93** | Priority 1 |
| BillingMesh | 18 | 17 | 15 | 8 | 10 | 8 | 7 | 3 | **86** | Priority 1 |
| FactoryCore | 15 | 10 | 14 | 8 | 9 | 7 | 2 | 0 | **65** | Priority 2 |
| EnterpriseOps Suite | 14 | 8 | 11 | 6 | 10 | 8 | 4 | 0 | **61** | Priority 2 |
| ProcessGrid | 9 | 12 | 9 | 5 | 8 | 6 | 3 | 3 | **55** | Priority 3 |
| DataWorks Product Labs | 8 | 9 | 6 | 4 | 10 | 9 | 1 | 0 | **47** | Priority 3 |

## Demonstrated Ranking Cases

- **Direct .NET and manufacturing fit:** IndustrialFlow Systems (near-maximum role and stack fit).
- **Strong billing and enterprise fit:** BillingMesh (exact domain match to Tova's prior billing/payments experience).
- **Strong domain fit with unclear team stack:** FactoryCore (Domain Fit 14/15 but Relevant-team evidence only 2/10).
- **Strong product company with weaker direct stack overlap:** EnterpriseOps Suite (Product-company fit 10/10 but Stack Fit only 8/20).
- **No current hiring signal:** FactoryCore and DataWorks Product Labs (Current hiring signal 0/5) — their overall fit is unaffected by the absence of a signal, per [Company Ranking Model Rules](../../ranking/company-ranking-model.md#rules), rule 3.
- **Recent but non-matching hiring signal:** ProcessGrid (a Recent Hiring Signal exists, but for a QA Automation role that does not match Tova's target roles — the hiring signal dimension credits the signal's existence, while Role Fit separately and correctly stays low).

## Related documents

- [../../ranking/company-ranking-model.md](../../ranking/company-ranking-model.md)
- [../../schemas/company-record.schema.md](../../schemas/company-record.schema.md)
- [excluded-companies.md](excluded-companies.md)
- [people-map.md](people-map.md)
