# Career Targeting Intelligence

Career Targeting Intelligence is a research and prioritization workflow that helps a job seeker turn a candidate profile into a focused, evidence-based outreach plan — identifying the right target companies, the right recruiters, and the right hiring managers, without relying on background automation or scraping.

## Problem

Job searching at a senior level is usually either too broad (spraying applications with no prioritization) or too manual (hours of unstructured research per company). There is no lightweight, repeatable method for going from "who am I and what do I want" to "here are the specific companies, people, and outreach actions worth my time this week."

## Intended users

Individual job seekers — particularly experienced professionals — who want a structured, on-demand research assistant for their own job search, and who are willing to review and act on findings manually rather than automate them away.

## Planned product surfaces

- **ChatGPT Custom GPT** — a conversational interface to the same methodology, built for the ChatGPT ecosystem.
- **Claude Project with a Claude Skill** — a conversational interface to the same methodology, built for the Claude ecosystem.

Both surfaces are thin, platform-specific wrappers. The methodology itself lives once, in `core/`.

## Core principle

`core/` is the platform-independent source of truth. Anything that describes *what the product does* — its methodology, outputs, and scope — belongs in `core/`. Platform folders (`claude/`, `chatgpt/`) only adapt that shared definition to a specific product surface; they should not redefine or duplicate business rules.

## Current project status

Foundation stage. This repository currently defines project structure, working rules, high-level scope, and the core candidate, company, person, activity, and research-state data model. The Claude Skill, Claude Project instructions, ChatGPT GPT instructions, detailed workflows, ranking models, and research examples have not been implemented yet.

## Core model

The canonical, platform-independent data model for the candidate, target companies, public contacts, and the research journey lives in `core/` and `schemas/`:

- [core/data-model.md](core/data-model.md) — overview of the model and how the records relate
- [schemas/candidate-profile.schema.md](schemas/candidate-profile.schema.md) — who the candidate is professionally
- [schemas/search-criteria.schema.md](schemas/search-criteria.schema.md) — what should be searched for
- [schemas/company-record.schema.md](schemas/company-record.schema.md) — target companies and the evidence gathered about them
- [schemas/person-record.schema.md](schemas/person-record.schema.md) — recruiters and potential hiring managers
- [schemas/activity-record.schema.md](schemas/activity-record.schema.md) — verified public activity evidence
- [schemas/research-state.schema.md](schemas/research-state.schema.md) — what has already been completed, approved, or needs refresh

## Trust and verification

The shared policy for how research claims are sourced, expressed with confidence, and kept fresh lives in `core/`:

- [core/source-policy.md](core/source-policy.md) — preferred source categories and claim-specific source rules
- [core/confidence-model.md](core/confidence-model.md) — the evidence states used to describe how well a claim is supported
- [core/freshness-policy.md](core/freshness-policy.md) — how freshness requirements depend on claim type
- [core/quality-gates.md](core/quality-gates.md) — minimum checks before returning each research output

## Ranking and prioritization

The platform-independent rules for scoring target companies, scoring recruiters and hiring managers, handling excluded companies, and prioritizing outreach actions live in `ranking/`:

- [ranking/company-ranking-model.md](ranking/company-ranking-model.md) — the weighted model for ranking target companies
- [ranking/person-ranking-model.md](ranking/person-ranking-model.md) — the weighted model for ranking recruiters and potential hiring managers
- [ranking/exclusion-policy.md](ranking/exclusion-policy.md) — how excluded and Needs Review companies are handled
- [ranking/outreach-priority-model.md](ranking/outreach-priority-model.md) — the recommended action order for the Outreach Priority Queue

## Workflow orchestration

How the product routes and executes research work — running only the modules a request actually needs, resuming from available context, and never repeating approved work — is defined in `core/` and `workflows/`:

- [core/workflow.md](core/workflow.md) — the three operating modes and the routing principle
- [workflows/full-journey.md](workflows/full-journey.md) — the complete, ordered end-to-end path
- [workflows/focused-task-routing.md](workflows/focused-task-routing.md) — routing a specific request to the minimum required modules
- [workflows/resume-journey.md](workflows/resume-journey.md) — continuing from the latest valid Research State

## Output contracts

The canonical outputs the product produces — what they contain, how they're ordered, and how a Markdown output maps to a CSV-compatible one — are defined in `core/` and `outputs/`:

- [core/output-contracts.md](core/output-contracts.md) — every canonical output's purpose, required records, and rules
- [outputs/company-map-template.md](outputs/company-map-template.md) — the Target Company Map
- [outputs/people-map-template.md](outputs/people-map-template.md) — the People Map
- [outputs/activity-verification-template.md](outputs/activity-verification-template.md) — the Activity Verification Report
- [outputs/outreach-queue-template.md](outputs/outreach-queue-template.md) — the Outreach Priority Queue
- [outputs/csv-column-contracts.md](outputs/csv-column-contracts.md) — stable CSV-compatible column definitions for every output

## Golden example

A complete, end-to-end worked example — using a fully synthetic candidate ("Tova") and entirely synthetic companies, people, and activity — demonstrates the schemas, trust policy, ranking models, workflow, and output contracts working together:

- [examples/tova/](examples/tova/) — the full journey from source profile through Candidate Profile, Search Criteria, Company Map, Excluded Companies, People Map, Activity Verification, Outreach Queue, Research State, and evaluation notes

## Further reading

- [ROADMAP.md](ROADMAP.md)
- [core/product-definition.md](core/product-definition.md)
- [core/scope-and-non-goals.md](core/scope-and-non-goals.md)
