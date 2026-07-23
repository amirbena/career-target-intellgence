# Company Map Template

This is the Markdown presentation template for the Target Company Map output, built from ranked [Company Records](../schemas/company-record.schema.md), per [core/output-contracts.md](../core/output-contracts.md#target-company-map) and the [Company Ranking Model](../ranking/company-ranking-model.md). All values below are synthetic.

## Disclaimer

> The target-company map is not a claim that every listed company is currently hiring or that every team uses the same technology stack. Team-level technology and current hiring status must be verified before outreach.

This disclaimer must accompany every Company Map output.

## Required Columns

| Column | Source field |
|---|---|
| Priority | Company Ranking Model tier |
| Score | Company Ranking Model total |
| Company | `company_name` |
| Relevant Location | `relevant_location` |
| Estimated Commute | `estimated_commute_minutes`, `commute_confidence` |
| Company Type | `company_type` |
| Product / Domain | `products`, `business_domains` |
| Relevant Roles | `relevant_roles` |
| Technology Evidence | `known_technologies` |
| Technology Scope | `technology_scope` |
| Role Fit | Role and seniority fit dimension |
| Stack Fit | Technology-stack fit dimension |
| Domain Fit | Domain fit dimension |
| Relevant Team Evidence | `possible_relevant_teams` |
| Current Hiring Signal | `hiring_signal_status` |
| Confidence | `confidence` |
| Why It Fits | Written reasoning from the ranking |
| Sources | `sources` |
| Checked At | `checked_at` |

## Ordering

1. Priority tier
2. Score, descending
3. Confidence
4. Company name

## Synthetic Example

| Priority | Score | Company | Relevant Location | Estimated Commute | Company Type | Product / Domain | Relevant Roles | Technology Evidence | Technology Scope | Role Fit | Stack Fit | Domain Fit | Relevant Team Evidence | Current Hiring Signal | Confidence | Why It Fits | Sources | Checked At |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Priority 1 | 89 | Northbridge Systems | Ra'anana | ~35 min (estimated) | Product | Billing platform / billing | Senior Backend Engineer | C#, .NET, SQL Server | Job-specific | 18/20 | 18/20 | 14/15 | Billing Platform Team | Recent Hiring Signal | Medium | Strong role, stack, and domain overlap; team-specific tech evidence. | Company website, careers page | 2026-07-20 |
| Priority 2 | 64 | Meridian Retail Systems | Tel Aviv | ~50 min (estimated) | Hybrid Product and Services | Retail ERP / retail | Backend Engineer | Java, Oracle | Company-wide | 16/20 | 10/20 | 12/15 | Not yet identified | No Signal Found | Low | Good role and domain fit; partial and less familiar stack. | LinkedIn company page | 2026-07-19 |

## Related documents

- [../schemas/company-record.schema.md](../schemas/company-record.schema.md)
- [../ranking/company-ranking-model.md](../ranking/company-ranking-model.md)
- [../core/output-contracts.md](../core/output-contracts.md)
- [excluded-companies-template.md](excluded-companies-template.md)
