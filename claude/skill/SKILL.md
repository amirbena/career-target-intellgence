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
- Discovering and classifying target companies, then ranking them.
- Finding recruiters, technical recruiters, and hiring managers at target
  companies, and verifying their current employment.
- Verifying recent public hiring activity, but only when explicitly
  requested.
- Building an Outreach Priority Queue of recommended (manual) next actions.
- Producing any of the canonical Markdown or CSV-compatible outputs.
- Explaining an existing output or ranking without re-running research.

## Full, focused, and resumed journeys

This Skill supports the same three operating modes defined in
[`core/workflow.md`](../../core/workflow.md):

- **Full Journey** — the complete, ordered pipeline from Candidate Input
  through Outreach Queue (and optional export). Use when the user asks for
  an end-to-end career-targeting research pass.
- **Focused Task** — enter a specific module directly (for example, "find
  recruiters at these three companies," or "why is this company Priority
  2?"). Do not run upstream or downstream modules the request does not need.
- **Resume Journey** — continue from a Research State already present in the
  active conversation context. Never assume a Research State exists if it is
  not visible in context; if none is present, proceed as a fresh Full
  Journey or Focused Task instead of fabricating prior progress.

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
| Discover companies | [`company-intelligence.md`](references/company-intelligence.md), [`quality-and-trust.md`](references/quality-and-trust.md) |
| Classify or rank companies | [`company-intelligence.md`](references/company-intelligence.md), [`ranking-and-exclusions.md`](references/ranking-and-exclusions.md) |
| Find recruiters or managers | [`people-intelligence.md`](references/people-intelligence.md), [`quality-and-trust.md`](references/quality-and-trust.md) |
| Verify recent activity | [`activity-verification.md`](references/activity-verification.md), [`quality-and-trust.md`](references/quality-and-trust.md) |
| Build outreach queue | [`ranking-and-exclusions.md`](references/ranking-and-exclusions.md), [`output-generation.md`](references/output-generation.md) |
| Run full journey | Load references progressively, one per stage, as the journey reaches that stage |
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

Every reference and template in this Skill inherits these non-actions.
