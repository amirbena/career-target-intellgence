---
name: career-targeting-intelligence
description: >
  Analyze candidate backgrounds, build targeted product-company maps,
  identify relevant recruiters and engineering managers, verify recent
  public hiring activity, and produce evidence-based outreach priorities.
  Use for full career-targeting journeys and focused company, people,
  activity, ranking, or outreach research tasks.
---

# Career Targeting Intelligence

## Product purpose

Career Targeting Intelligence turns a candidate's background and goals into a
prioritized, evidence-based research map: which companies are worth
targeting, which recruiters and hiring managers are worth reaching, and in
what order — without automated outreach, scraping, or background monitoring.

The canonical methodology, data model, ranking models, workflow, and output
contracts live in the repository's `core/`, `schemas/`, `ranking/`,
`workflows/`, and `outputs/` directories. This Skill adapts that methodology
for execution inside Claude. It does not redefine it. Where a reference file
in this Skill states a rule, a number, a threshold, or an enum, that value
was copied from the canonical source and must not drift from it.

## In-scope requests

- Analyzing a candidate's background into a structured Candidate Profile.
- Building Search Criteria from a Candidate Profile and explicit user
  constraints.
- Discovering candidate roles across official careers pages, LinkedIn,
  Glassdoor, Indeed, other job boards, and recruiter posts.
- Verifying a specific role's current availability, preferring official
  careers sites/ATS and cross-checking secondary discoveries against them.
- Evaluating candidate–job fit against a hard eligibility gate (availability
  and hard constraints), separately from company attractiveness.
- Evaluating company-state signals (layoffs, freezes, restructuring, funding,
  expansion, leadership changes) as context distinct from job availability.
- Discovering and classifying target companies, then ranking them
  (Company Targeting Journey).
- Finding recruiters, technical recruiters, and hiring managers at target
  companies or verified roles, and verifying their current employment.
- Verifying recent public hiring activity, but only when explicitly
  requested — distinct from Current Job Verification, which is required
  whenever job discovery is requested.
- Building an Outreach Priority Queue of recommended (manual) next actions,
  optionally associated with a specific verified Job Record.
- Producing any of the canonical Markdown or CSV-compatible outputs.
- Explaining an existing output or ranking without re-running research.

## Full, focused, and resumed journeys

This Skill supports the same operating modes defined in
[`core/workflow.md`](../../core/workflow.md):

- **Job Search Journey (default full journey for job-discovery intent)** —
  "find me jobs" and equivalents. Candidate Input/Profile → Search Criteria
  → Current Job Discovery → Current Job Verification → Candidate–Job Fit →
  Company State Verification → Recruiter/Hiring-Manager Discovery →
  Outreach Prioritization. The primary result is the Verified Jobs Map:
  only roles that are currently verified (or clearly separated
  Likely Open/Partially Verified) AND pass the candidate hard-constraint
  gate. Company attractiveness never substitutes for a verified, fit role.
- **Company Targeting Journey (preserved focused full journey)** — the
  complete, ordered, company-first pipeline from Candidate Input through
  Outreach Queue (and optional export). Use when the user explicitly wants
  a company-first pass, or asks to find companies worth targeting even
  without a verified role today.
- **Focused Task** — enter a specific module directly (for example, "find
  recruiters at these three companies," "check whether these roles are
  still open," or "why is this company Priority 2?"). Do not run upstream
  or downstream modules the request does not need.
- **Resume Journey** — continue from a Research State already present in the
  active conversation context. Never assume a Research State exists if it is
  not visible in context; if none is present, proceed as a fresh journey or
  Focused Task instead of fabricating prior progress.

See [`references/workflow-routing.md`](references/workflow-routing.md) for
the full routing logic, including the illustrative routing table and the
Research State transition rules.

## Core rule

> Apply only the workflow modules required by the user's request and the
> valid context currently available. Do not repeat approved work unless the
> user requests a refresh, provides conflicting information, or relevant
> public evidence is stale.

This means: do not re-run a module whose output is already `Approved` or
`Completed` in an available Research State; do not re-ask for information
already present in the conversation, an uploaded file, or an active
correction; and do not silently widen a focused request into a full journey.

## Progressive reference loading

Do not load every reference file for every request. Load only the reference
files a request actually needs, based on user intent:

| User intent | Required references |
|---|---|
| Analyze candidate | [`candidate-intelligence.md`](references/candidate-intelligence.md), [`quality-and-trust.md`](references/quality-and-trust.md) |
| Build search criteria | [`candidate-intelligence.md`](references/candidate-intelligence.md), [`workflow-routing.md`](references/workflow-routing.md) |
| Find jobs / discover jobs | [`job-intelligence.md`](references/job-intelligence.md), [`quality-and-trust.md`](references/quality-and-trust.md) |
| Verify a specific job / check if roles are still open | [`job-intelligence.md`](references/job-intelligence.md) |
| Evaluate candidate–job fit | [`job-intelligence.md`](references/job-intelligence.md), [`ranking-and-exclusions.md`](references/ranking-and-exclusions.md) |
| Assess company state / company health | [`job-intelligence.md`](references/job-intelligence.md), [`company-intelligence.md`](references/company-intelligence.md) |
| Discover companies | [`company-intelligence.md`](references/company-intelligence.md), [`quality-and-trust.md`](references/quality-and-trust.md) |
| Classify or rank companies | [`company-intelligence.md`](references/company-intelligence.md), [`ranking-and-exclusions.md`](references/ranking-and-exclusions.md) |
| Find recruiters or managers | [`people-intelligence.md`](references/people-intelligence.md), [`quality-and-trust.md`](references/quality-and-trust.md) |
| Verify recent activity | [`activity-verification.md`](references/activity-verification.md), [`quality-and-trust.md`](references/quality-and-trust.md) |
| Build outreach queue | [`ranking-and-exclusions.md`](references/ranking-and-exclusions.md), [`output-generation.md`](references/output-generation.md) |
| Run Job Search Journey | Load references progressively, one per stage, as the journey reaches that stage — starting with [`job-intelligence.md`](references/job-intelligence.md) |
| Run Company Targeting Journey | Load references progressively, one per stage, as the journey reaches that stage |
| Explain existing output | Load only the single methodology reference relevant to the claim being explained |

SKILL.md is an orchestrator: it defines routing and non-actions, but the
field lists, evidence rules, scoring models, and output shapes live in the
reference files (and, canonically, in the repository directories they adapt
from).

## Using active context

Use all relevant information already present in the active conversation:
prior messages, an uploaded resume or document, an active Research State, or
an explicit user correction. A later explicit correction always overrides
earlier inferred or assumed information. Do not claim access to context that
was not actually supplied (no other chats, no external storage, no
background monitoring). Absence of prior context does not block a focused
task that has sufficient input to proceed on its own.

## Evidence, confidence, and freshness

Every public-data claim must be evidence-backed, explicitly labeled as an
inference, or explicitly marked unverified — never invented. Apply the
shared evidence states, source rules, and freshness rules exactly as defined
in [`quality-and-trust.md`](references/quality-and-trust.md), which adapts
[`core/confidence-model.md`](../../core/confidence-model.md),
[`core/source-policy.md`](../../core/source-policy.md), and
[`core/freshness-policy.md`](../../core/freshness-policy.md).

## Final quality checks

Before returning any output, apply the quality gate for that output type
from [`quality-and-trust.md`](references/quality-and-trust.md) (adapted from
[`core/quality-gates.md`](../../core/quality-gates.md)). At minimum, confirm
that every factual claim has a source and a `checked_at` date, is labeled as
an inference, or is marked unverified, and that current-hiring status is
never inferred from suitability alone.

## Output selection

Produce only the outputs the user asked for (or, in a full journey, only the
outputs listed in `requested_outputs`). Use the canonical output shapes and
column sets defined in [`output-generation.md`](references/output-generation.md)
and the empty templates in [`templates/`](templates/) as a starting
structure. Do not merge multiple outputs into one oversized table, and do
not produce a CSV-compatible export of an output that has not been produced
in Markdown first.

## Explicit non-actions

This Skill must not:

- Promise automatic cross-chat memory or act as persistent storage.
- Monitor LinkedIn, company pages, or any profile in the background.
- Schedule research or imply continuous/recurring monitoring.
- Scrape private or otherwise inaccessible content, or bypass a platform's
  access controls.
- Send messages, connection requests, or any other outreach on the user's
  behalf.
- Mutate spreadsheets or other connected files without an explicit,
  in-the-moment user request.
- Invent companies, people, URLs, activity, or job postings that were not
  actually observed.
- Claim that an Activity URL alone proves recent activity (that is A0/A1
  evidence at most — see [`activity-verification.md`](references/activity-verification.md)).
- Claim that the existence of a job post proves the role remains open;
  current job status must be verified separately and dated.
- Claim a job is Verified Open based on a LinkedIn, Glassdoor, Indeed, other
  job-board, recruiter-post, or search-result discovery alone — attempt the
  official-site/ATS cross-check first (see
  [`job-intelligence.md`](references/job-intelligence.md)).
- Treat a role's absence from an official careers search as proof it is
  closed, absent direct closure evidence.
- Let a company-state event (layoff, freeze, restructuring, etc.) silently
  change a job's availability status or auto-close every role at that
  company.
- Let company attractiveness substitute for a role passing the eligibility
  gate in the Job Search Journey's primary Verified Jobs Map.

Every reference and template in this Skill inherits these non-actions.
