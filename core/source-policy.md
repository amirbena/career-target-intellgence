# Source Policy

This document defines the preferred source categories and claim-specific source rules used when researching companies, people, technologies, employment, activity, and job signals. It applies to both the Claude and ChatGPT product surfaces equally — see [data-model.md](data-model.md) for the records this policy feeds into and [confidence-model.md](confidence-model.md) for how source strength translates into a confidence state.

This document does not define scraping, bypassing access controls, private-contact enrichment, or automated monitoring. It governs how publicly accessible information is weighed, not how it is retrieved.

## Preferred Source Categories

Sources are listed from strongest to weakest. Stronger sources are preferred whenever available; weaker sources may still be used, but only with the limitations noted below.

### 1. Official company website

- **Can support:** company identity, product description, office locations, company type (when stated plainly, not just implied by branding).
- **Cannot support alone:** team-specific technology, current hiring status, individual employment.
- **Typical freshness risk:** low to medium — marketing pages can lag behind reality.
- **Corroboration recommended:** not required for identity claims; recommended for company type when the site uses ambiguous language.

### 2. Official company careers page

- **Can support:** current job availability, general hiring signal, job titles and locations for open roles.
- **Cannot support alone:** company-wide technology stack, team composition.
- **Typical freshness risk:** medium — postings can remain listed after a role closes.
- **Corroboration recommended:** recommended when the claim will be presented as "verified open."

### 3. Official company LinkedIn page

- **Can support:** company identity, company size signal, general activity.
- **Cannot support alone:** company type classification alone, technology stack.
- **Typical freshness risk:** low to medium.
- **Corroboration recommended:** recommended for company type.

### 4. Public LinkedIn profile of the relevant person

- **Can support:** current title, current employer (when recently updated), person type classification.
- **Cannot support alone:** current activity, current hiring behavior.
- **Typical freshness risk:** medium — profiles are not always kept current.
- **Corroboration recommended:** recommended when the profile appears stale or ambiguous.

### 5. Direct public post by the relevant person

- **Can support:** authored activity, hiring-related content, a specific role mention, authorship status.
- **Cannot support alone:** whether a mentioned role is still open at the time of use.
- **Typical freshness risk:** depends entirely on the post's own date — always check the date directly.
- **Corroboration recommended:** recommended for A4-level (matching job post) claims.

### 6. Reputable job board

- **Can support:** job availability signal, job title, job location.
- **Cannot support alone:** company-wide technology stack, team relevance.
- **Typical freshness risk:** medium to high — listings can be stale or auto-reposted.
- **Corroboration recommended:** recommended before treating a listing as verified open.

### 7. Reputable business database

- **Can support:** company identity, company size, industry classification.
- **Cannot support alone:** technology stack, current hiring, employment status.
- **Typical freshness risk:** medium — update cadence varies by provider.
- **Corroboration recommended:** recommended for anything beyond basic identity.

### 8. Reliable secondary source

- **Can support:** general company description, industry context.
- **Cannot support alone:** any time-sensitive or person-specific claim.
- **Typical freshness risk:** medium to high.
- **Corroboration recommended:** recommended for any claim used beyond general background.

### 9. Search-result snippet only

- **Can support:** a starting point for further verification.
- **Cannot support alone:** any claim presented as verified.
- **Typical freshness risk:** high — snippets can be outdated or out of context.
- **Corroboration recommended:** always required before use.

### 10. Unverified or inaccessible source

- **Can support:** nothing on its own.
- **Cannot support alone:** any claim.
- **Typical freshness risk:** unknown.
- **Corroboration recommended:** not applicable — must not be represented as evidence.

## Current Job Availability Source Hierarchy

Current job availability has its own dedicated source hierarchy and cross-check rule, defined canonically in [job-verification-policy.md](job-verification-policy.md#source-hierarchy-for-current-availability) — summarized here for completeness:

1. Official company careers site.
2. Official ATS or job page the company controls or explicitly links.
3. Other official company recruitment source.

LinkedIn Jobs, Glassdoor, Indeed, other job boards/aggregators, recruiter posts, and search-result snippets may discover a role; none of them may alone produce a "verified open" determination. **If a job is discovered on LinkedIn, Glassdoor, Indeed, another job board, recruiter activity, or another secondary source, attempt to verify it against the employer's official careers site or official ATS whenever publicly accessible. Treat the external listing as discovery evidence, not sufficient proof of current availability.** Absence from an official careers search is evidence that verification failed or the listing may be stale; it is not automatically proof of closure unless the official source or other direct evidence establishes closure. See [job-verification-policy.md](job-verification-policy.md) for the full outcome table and rules.

## Company State Source Hierarchy

Time-sensitive organizational developments (layoffs, freezes, restructuring, acquisitions, funding, expansion, leadership changes) use their own preference order, from strongest to weakest:

1. Official company announcements or filings.
2. Regulatory filings, where applicable.
3. Direct executive/company communications.
4. Highly reputable business/news reporting.
5. Other credible secondary sources.

A social-media rumor or unsupported post must not become a verified company-state event. Corroborate significant negative events (layoffs, closures, insolvency) with a second independent source when practical. See [schemas/company-state-record.schema.md](../schemas/company-state-record.schema.md) and [workflows/verify-company-state.md](../workflows/verify-company-state.md).

## Claim-Specific Source Rules

| Claim | Preferred sources | Notes |
|---|---|---|
| Company identity | Official website, official LinkedIn page, business database | Low freshness risk; a single strong source is usually sufficient. |
| Office location | Official website, careers page | Verify separately when used for a commute decision. |
| Company type | Official website plus at least one corroborating source | Do not classify as Product from branding language alone. |
| Product description | Official website | Marketing language should be summarized factually, not repeated uncritically. |
| Technology stack | Multiple job posts, official engineering content | Must be scoped — see [confidence-model.md](confidence-model.md). |
| Team-specific technology | Team-specific job post, employee profile mentioning the team | One profile does not prove a team-wide stack. |
| Current employment | Person's own profile, checked recently | An old title is not current employment. |
| Public activity | The person's own posts | An Activity URL alone does not prove recent activity. |
| Hiring activity | A dated post from the person or company | Must include a date; otherwise treat as unverified. |
| Current job availability | Official careers site/ATS preferred; job board discovery requires official cross-check | A post or listing existing does not prove the role is still open — see [job-verification-policy.md](job-verification-policy.md). |
| Company state / organizational change | Official announcement/filing preferred; reputable reporting acceptable, corroborated for negative events | A single social post is not sufficient — see [Company State Source Hierarchy](#company-state-source-hierarchy). |
| Commute estimate | Mapping/transit source appropriate to the request | Must be labeled as an estimate unless a live source was used. |

## Source Policy Rules

1. Prefer direct and official sources over aggregators.
2. A search-result snippet alone is weak evidence.
3. One job post does not prove a company-wide stack.
4. One employee profile does not prove a team-wide stack.
5. An old title must not be treated as current employment.
6. An Activity URL does not prove recent activity.
7. A post does not prove that a role is still open.
8. Conflicting sources must remain visible.
9. Inaccessible or private content must not be represented as verified.
10. Every time-sensitive claim must include `checked_at`.
11. A LinkedIn, Glassdoor, Indeed, other job-board, or recruiter-post discovery of a role must be cross-checked against the official careers site/ATS whenever accessible, before being treated as verified — see [job-verification-policy.md](job-verification-policy.md).
12. A social-media rumor or unsupported post must not become a verified company-state event.

## Related documents

- [data-model.md](data-model.md)
- [confidence-model.md](confidence-model.md)
- [freshness-policy.md](freshness-policy.md)
- [quality-gates.md](quality-gates.md)
- [job-verification-policy.md](job-verification-policy.md)
- [../schemas/company-record.schema.md](../schemas/company-record.schema.md)
- [../schemas/person-record.schema.md](../schemas/person-record.schema.md)
- [../schemas/activity-record.schema.md](../schemas/activity-record.schema.md)
- [../schemas/job-record.schema.md](../schemas/job-record.schema.md)
- [../schemas/company-state-record.schema.md](../schemas/company-state-record.schema.md)
