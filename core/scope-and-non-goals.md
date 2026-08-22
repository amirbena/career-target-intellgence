# Scope and Non-Goals

## MVP scope

The MVP covers the following capabilities:

- Candidate analysis
- Search-criteria definition
- Current job discovery, across official careers pages, LinkedIn, Glassdoor, Indeed, other job boards, and recruiter posts
- Current job verification against the strongest available public evidence (official careers site/ATS preferred), per [job-verification-policy.md](job-verification-policy.md)
- Candidate–job fit evaluation against a hard eligibility gate, per [ranking/job-eligibility-gate.md](../ranking/job-eligibility-gate.md)
- Company-state evaluation (layoffs, freezes, restructuring, funding, expansion, leadership changes, and similar events), kept separate from job availability and candidate fit
- Target-company discovery (Company Targeting Journey)
- Product-company filtering
- Company prioritization
- Recruiter discovery
- Hiring-manager discovery
- Explicitly requested activity verification of a person's public posts
- Outreach prioritization
- Manual Markdown or CSV-compatible outputs

## Non-goals

The following are explicitly out of scope for the MVP and must not be introduced without a future task explicitly requesting them:

- Scheduled LinkedIn monitoring
- Background profile checks
- Automatic alerts
- Automatic outreach
- Automatic connection requests
- Automatic spreadsheet updates
- Scraping automation
- Standalone web application
- API
- Multi-agent architecture

Current job verification is public-evidence weighing only — it does not authorize scraping, access-control bypass, or automated/scheduled re-checking of job listings; every check is a response to an explicit user request, per [job-verification-policy.md](job-verification-policy.md), rule 10.

## Related documents

- [product-definition.md](product-definition.md)
- [../README.md](../README.md)
- [../AGENTS.md](../AGENTS.md)
- [../CLAUDE.md](../CLAUDE.md)
- [job-verification-policy.md](job-verification-policy.md)
- [../ranking/job-eligibility-gate.md](../ranking/job-eligibility-gate.md)
