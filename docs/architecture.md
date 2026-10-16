# Architecture

The product is a platform-independent methodology in `core/` and its supporting folders; the `claude/` and `chatgpt/` folders are thin platform wrappers generated from it. The [README](../README.md#architecture) has the short overview.

## Core journeys

- **Job Search Journey** (default for job-discovery intent) — Candidate
  Profile → Search Criteria → Job Discovery → Job Verification →
  Candidate/Job Fit → Company State → Recruiter/Hiring-Manager Discovery
  → Outreach Prioritization. See
  [workflows/job-search-journey.md](../workflows/job-search-journey.md).
- **Company Targeting Journey** — a focused mode for requests like "which
  companies should I target?" that don't require a currently open role.
  See [workflows/full-journey.md](../workflows/full-journey.md).
- **Focused Tasks** — a single module (verify one job, refresh company
  state, find recruiters for already-verified roles, ...) without
  re-running the rest of the journey. See
  [workflows/focused-task-routing.md](../workflows/focused-task-routing.md).

## Core model

The canonical, platform-independent data model for the candidate, target companies, public contacts, and the research journey lives in `core/` and `schemas/`:

- [core/data-model.md](../core/data-model.md) — overview of the model and how the records relate
- [schemas/candidate-profile.schema.md](../schemas/candidate-profile.schema.md) — who the candidate is professionally
- [schemas/search-criteria.schema.md](../schemas/search-criteria.schema.md) — what should be searched for
- [schemas/job-record.schema.md](../schemas/job-record.schema.md) — a specific discovered role, as a first-class record, with current-availability and candidate-fit-gate state
- [schemas/company-state-record.schema.md](../schemas/company-state-record.schema.md) — time-sensitive organizational developments (layoffs, freezes, restructuring, funding, and similar), separate from stable company identity
- [schemas/company-record.schema.md](../schemas/company-record.schema.md) — target companies and the evidence gathered about them
- [schemas/person-record.schema.md](../schemas/person-record.schema.md) — recruiters and potential hiring managers
- [schemas/activity-record.schema.md](../schemas/activity-record.schema.md) — verified public activity evidence
- [schemas/research-state.schema.md](../schemas/research-state.schema.md) — what has already been completed, approved, or needs refresh

## Trust and verification

The shared policy for how research claims are sourced, expressed with confidence, and kept fresh lives in `core/`:

- [core/source-policy.md](../core/source-policy.md) — preferred source categories and claim-specific source rules
- [core/confidence-model.md](../core/confidence-model.md) — the evidence states used to describe how well a claim is supported
- [core/freshness-policy.md](../core/freshness-policy.md) — how freshness requirements depend on claim type
- [core/quality-gates.md](../core/quality-gates.md) — minimum checks before returning each research output
- [core/job-verification-policy.md](../core/job-verification-policy.md) — the canonical current-job verification policy: source hierarchy, mandatory official-site cross-check, and verification outcomes

## Ranking and prioritization

The platform-independent rules for scoring target companies, scoring recruiters and hiring managers, handling excluded companies, gating job-search eligibility, and prioritizing outreach actions live in `ranking/`:

- [ranking/company-ranking-model.md](../ranking/company-ranking-model.md) — the weighted model for ranking target companies
- [ranking/person-ranking-model.md](../ranking/person-ranking-model.md) — the weighted model for ranking recruiters and potential hiring managers
- [ranking/exclusion-policy.md](../ranking/exclusion-policy.md) — how excluded and Needs Review companies are handled
- [ranking/job-eligibility-gate.md](../ranking/job-eligibility-gate.md) — the hard availability + candidate-fit gate a role must pass to enter the primary Verified Jobs Map
- [ranking/outreach-priority-model.md](../ranking/outreach-priority-model.md) — the recommended action order for the Outreach Priority Queue

## Workflow orchestration

How the product routes and executes research work — running only the modules a request actually needs, resuming from available context, and never repeating approved work — is defined in `core/` and `workflows/`:

- [core/workflow.md](../core/workflow.md) — the operating modes (Job Search Journey, Company Targeting Journey, Focused Task, Resume Journey) and the routing principle
- [workflows/job-search-journey.md](../workflows/job-search-journey.md) — the default, job-first end-to-end path for job-discovery intent
- [workflows/discover-jobs.md](../workflows/discover-jobs.md), [workflows/verify-job.md](../workflows/verify-job.md), [workflows/evaluate-candidate-job-fit.md](../workflows/evaluate-candidate-job-fit.md), [workflows/verify-company-state.md](../workflows/verify-company-state.md) — the job-search-specific modules
- [workflows/full-journey.md](../workflows/full-journey.md) — the complete, ordered, company-first path (Company Targeting Journey)
- [workflows/focused-task-routing.md](../workflows/focused-task-routing.md) — routing a specific request to the minimum required modules
- [workflows/resume-journey.md](../workflows/resume-journey.md) — continuing from the latest valid Research State

## Output contracts

The canonical outputs the product produces — what they contain, how they're ordered, and how a Markdown output maps to a CSV-compatible one — are defined in `core/` and `outputs/`:

- [core/output-contracts.md](../core/output-contracts.md) — every canonical output's purpose, required records, and rules
- [outputs/verified-jobs-map-template.md](../outputs/verified-jobs-map-template.md) — the primary output for job-search intent
- [outputs/unverified-job-leads-template.md](../outputs/unverified-job-leads-template.md) — every rejected or unverified job lead, kept visible with a reason
- [outputs/company-map-template.md](../outputs/company-map-template.md) — the Target Company Map
- [outputs/people-map-template.md](../outputs/people-map-template.md) — the People Map
- [outputs/activity-verification-template.md](../outputs/activity-verification-template.md) — the Activity Verification Report
- [outputs/outreach-queue-template.md](../outputs/outreach-queue-template.md) — the Outreach Priority Queue
- [outputs/csv-column-contracts.md](../outputs/csv-column-contracts.md) — stable CSV-compatible column definitions for every output

## Golden example

A complete, end-to-end worked example — using a fully synthetic candidate ("Tova") and entirely synthetic companies, people, and activity — demonstrates the schemas, trust policy, ranking models, workflow, and output contracts working together:

- [examples/tova/](../examples/tova/) — the full journey from source profile through Candidate Profile, Search Criteria, Company Map, Excluded Companies, People Map, Activity Verification, Outreach Queue, Research State, and evaluation notes
