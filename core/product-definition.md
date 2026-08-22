# Product Definition

## Purpose

Career Targeting Intelligence finds currently open roles that meaningfully match the candidate, verifies their current availability using the strongest available public evidence, evaluates relevant company-state signals, identifies appropriate recruiters or potential hiring managers, and produces an evidence-based manual outreach queue.

Company-first research remains a supported, focused journey — a company can still be a useful target even without a verified open role today — but it is not the default when the user's intent is to find jobs. See [Primary user journey](#primary-user-journey) and [Company Targeting Journey](#company-targeting-journey).

## Primary user journey

For job-discovery intent — "find me jobs," "what roles should I apply to," and equivalents — the default is the **Job Search Journey**: Candidate Input/Existing Candidate Profile → Search Criteria → Current Job Discovery → Current Job Verification → Candidate–Job Fit → Company State Verification → Recruiter/Hiring-Manager Discovery → Outreach Prioritization. See [workflows/job-search-journey.md](../workflows/job-search-journey.md).

A successful primary job result represents one specific role with: a specific employer, a specific job title, sufficient role detail to assess candidate relevance, an explicit current-availability state, an exact verification timestamp, source URL(s), a candidate-fit assessment, a company-state assessment, and recruiter/hiring-manager discovery when useful and possible. The product prefers fewer strongly verified matches over many stale, closed, weak, or unverifiable ones. None of the following, alone, is treated as proof a job is currently open: a company being attractive, a recruiter's hiring post, a LinkedIn job page, a Glassdoor listing, an Indeed listing, a search-result snippet, or historical hiring evidence — see [core/job-verification-policy.md](job-verification-policy.md).

## Company Targeting Journey

The prior company-first path remains fully supported as a focused mode: "which companies should I target?", "find companies that match me even if there is no role today," "find recruiters at these companies." A company may appear in this mode's results without a verified open role, but the output must explicitly say so rather than implying a current opening exists. See [workflows/full-journey.md](../workflows/full-journey.md).

## Main outputs

- **Candidate Profile** — a structured summary of the candidate's background, goals, and constraints.
- **Verified Jobs Map** — the primary output for job-search intent: currently open, candidate-fit roles that passed the [Primary Job Eligibility Gate](../ranking/job-eligibility-gate.md), each with availability evidence, candidate-fit assessment, and company-state context.
- **Unverified and Rejected Job Leads** — roles that did not pass the gate, kept visible with an explicit reason rather than silently dropped.
- **Target Company Map** — the set of companies worth targeting under the Company Targeting Journey, with the reasoning behind their inclusion.
- **Recruiter Map** — relevant recruiters associated with target companies or verified roles.
- **Hiring Manager Map** — relevant hiring managers associated with target companies, roles, or teams.
- **Activity Verification** — confirmation of a person's recent, relevant public activity (e.g., a hiring-related post), performed only when explicitly requested; distinct from Current Job Verification, which is a required part of the Job Search Journey rather than optional.
- **Outreach Priority Queue** — a ranked list of who to contact next and why, able to reference a specific verified Job Record.

## Structured but modular

The workflow follows a defined sequence of stages, but each stage is a self-contained, modular step. A user can request a single stage in isolation (e.g., "just build my Candidate Profile") without running the full workflow.

## Research is opt-in, except job verification when job discovery is requested

Research actions — including any lookup beyond the candidate's own input — are performed only after the candidate explicitly requests them; the workflow does not run background or speculative research on its own initiative. **Current Job Verification is the one exception to "optional until asked":** when the user explicitly requests current job discovery (the Job Search Journey's default intent), Current Job Verification is a required part of that journey, not an optional add-on — a role cannot appear in the primary Verified Jobs Map without it. Activity Verification of a person's social posts remains optional and separate, since it is about what a person publicly did, not about proving a specific job is open — see [job-verification-policy.md](job-verification-policy.md) and [workflows/verify-activity.md](../workflows/verify-activity.md).

## Related documents

- [../README.md](../README.md)
- [scope-and-non-goals.md](scope-and-non-goals.md)
- [../ROADMAP.md](../ROADMAP.md)
- [job-verification-policy.md](job-verification-policy.md)
- [../workflows/job-search-journey.md](../workflows/job-search-journey.md)
- [../ranking/job-eligibility-gate.md](../ranking/job-eligibility-gate.md)
