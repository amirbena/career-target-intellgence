# Career Targeting Intelligence

Career Targeting Intelligence finds currently open roles that meaningfully
match a candidate, verifies their current availability using the
strongest available public evidence, evaluates relevant company-state
signals, identifies appropriate recruiters or potential hiring managers,
and produces an evidence-based manual outreach queue — without relying on
background automation or scraping.

Job searching at a senior level is usually either too broad (spraying
applications with no prioritization) or too manual (hours of unstructured
research per company). A job board listing, a recruiter's post, or a
company's general attractiveness is routinely mistaken for proof that a
role is actually open today. This project is a structured, on-demand
research method for going from "who am I and what do I want" to "here are
the specific, currently verified roles and outreach actions worth my time
this week" — built for individual job seekers who review and act on
findings manually rather than automate them away.

## Core journeys

- **Job Search Journey** (default for job-discovery intent) — Candidate
  Profile → Search Criteria → Job Discovery → Job Verification →
  Candidate/Job Fit → Company State → Recruiter/Hiring-Manager Discovery
  → Outreach Prioritization. See
  [workflows/job-search-journey.md](workflows/job-search-journey.md).
- **Company Targeting Journey** — a focused mode for requests like "which
  companies should I target?" that don't require a currently open role.
  See [workflows/full-journey.md](workflows/full-journey.md).
- **Focused Tasks** — a single module (verify one job, refresh company
  state, find recruiters for already-verified roles, ...) without
  re-running the rest of the journey. See
  [workflows/focused-task-routing.md](workflows/focused-task-routing.md).

## Product surfaces

- **ChatGPT Custom GPT** — a conversational interface to the same
  methodology, built for the ChatGPT ecosystem.
- **Claude Project with a Claude Skill** — a conversational interface to
  the same methodology, built for the Claude ecosystem.

Both are thin, platform-specific wrappers. The methodology itself lives
once, in `core/`.

## Repository structure

| Path | Contents |
| --- | --- |
| `core/` | Platform-independent source of truth: product definition, scope, workflow, source/confidence/freshness policy, quality gates, output contracts |
| `schemas/` | The canonical data model (Candidate Profile, Search Criteria, Job Record, Company State Record, Company Record, Person Record, Activity Record, Research State) |
| `ranking/` | Weighted scoring models and the job eligibility gate |
| `workflows/` | Step-by-step modules for each journey and focused task |
| `outputs/` | Canonical output templates and CSV column contracts |
| `claude/` | Claude Skill, Claude Project instructions, and the external self-install kit |
| `chatgpt/` | ChatGPT Custom GPT instructions and Knowledge bundles |
| `scripts/` | Build, packaging, and validation scripts for every platform |
| `tests/` | Synthetic verification scenarios and packaging/quality-gate checklists |
| `.github/` | GitHub contribution templates (Engineering Task Issue Form, pull request template) |
| `examples/tova/` | The fully synthetic Golden Journey example |

`core/` is the platform-independent source of truth: anything describing
*what the product does* belongs there. Platform folders (`claude/`,
`chatgpt/`) only adapt that shared definition — they never redefine or
duplicate business rules.

## Core model

The canonical, platform-independent data model for the candidate, target companies, public contacts, and the research journey lives in `core/` and `schemas/`:

- [core/data-model.md](core/data-model.md) — overview of the model and how the records relate
- [schemas/candidate-profile.schema.md](schemas/candidate-profile.schema.md) — who the candidate is professionally
- [schemas/search-criteria.schema.md](schemas/search-criteria.schema.md) — what should be searched for
- [schemas/job-record.schema.md](schemas/job-record.schema.md) — a specific discovered role, as a first-class record, with current-availability and candidate-fit-gate state
- [schemas/company-state-record.schema.md](schemas/company-state-record.schema.md) — time-sensitive organizational developments (layoffs, freezes, restructuring, funding, and similar), separate from stable company identity
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
- [core/job-verification-policy.md](core/job-verification-policy.md) — the canonical current-job verification policy: source hierarchy, mandatory official-site cross-check, and verification outcomes

## Ranking and prioritization

The platform-independent rules for scoring target companies, scoring recruiters and hiring managers, handling excluded companies, gating job-search eligibility, and prioritizing outreach actions live in `ranking/`:

- [ranking/company-ranking-model.md](ranking/company-ranking-model.md) — the weighted model for ranking target companies
- [ranking/person-ranking-model.md](ranking/person-ranking-model.md) — the weighted model for ranking recruiters and potential hiring managers
- [ranking/exclusion-policy.md](ranking/exclusion-policy.md) — how excluded and Needs Review companies are handled
- [ranking/job-eligibility-gate.md](ranking/job-eligibility-gate.md) — the hard availability + candidate-fit gate a role must pass to enter the primary Verified Jobs Map
- [ranking/outreach-priority-model.md](ranking/outreach-priority-model.md) — the recommended action order for the Outreach Priority Queue

## Workflow orchestration

How the product routes and executes research work — running only the modules a request actually needs, resuming from available context, and never repeating approved work — is defined in `core/` and `workflows/`:

- [core/workflow.md](core/workflow.md) — the operating modes (Job Search Journey, Company Targeting Journey, Focused Task, Resume Journey) and the routing principle
- [workflows/job-search-journey.md](workflows/job-search-journey.md) — the default, job-first end-to-end path for job-discovery intent
- [workflows/discover-jobs.md](workflows/discover-jobs.md), [workflows/verify-job.md](workflows/verify-job.md), [workflows/evaluate-candidate-job-fit.md](workflows/evaluate-candidate-job-fit.md), [workflows/verify-company-state.md](workflows/verify-company-state.md) — the job-search-specific modules
- [workflows/full-journey.md](workflows/full-journey.md) — the complete, ordered, company-first path (Company Targeting Journey)
- [workflows/focused-task-routing.md](workflows/focused-task-routing.md) — routing a specific request to the minimum required modules
- [workflows/resume-journey.md](workflows/resume-journey.md) — continuing from the latest valid Research State

## Output contracts

The canonical outputs the product produces — what they contain, how they're ordered, and how a Markdown output maps to a CSV-compatible one — are defined in `core/` and `outputs/`:

- [core/output-contracts.md](core/output-contracts.md) — every canonical output's purpose, required records, and rules
- [outputs/verified-jobs-map-template.md](outputs/verified-jobs-map-template.md) — the primary output for job-search intent
- [outputs/unverified-job-leads-template.md](outputs/unverified-job-leads-template.md) — every rejected or unverified job lead, kept visible with a reason
- [outputs/company-map-template.md](outputs/company-map-template.md) — the Target Company Map
- [outputs/people-map-template.md](outputs/people-map-template.md) — the People Map
- [outputs/activity-verification-template.md](outputs/activity-verification-template.md) — the Activity Verification Report
- [outputs/outreach-queue-template.md](outputs/outreach-queue-template.md) — the Outreach Priority Queue
- [outputs/csv-column-contracts.md](outputs/csv-column-contracts.md) — stable CSV-compatible column definitions for every output

## Build / package

Every package is generated from the canonical sources above by a build
script — never hand-edit a generated file. Each build script also runs
that platform's length validator before packaging.

### ChatGPT GPT

- Canonical source: [chatgpt/instructions.md](chatgpt/instructions.md) (behavior) + [chatgpt/knowledge-manifest.md](chatgpt/knowledge-manifest.md)-mapped Knowledge bundles (reference material)
- Build:
  ```bash
  ./scripts/build-chatgpt-knowledge.sh
  ./scripts/package-chatgpt-gpt.sh
  ```
  (`.ps1` equivalents on Windows)
- Output: `dist/career-targeting-intelligence-chatgpt.zip` — no Actions, Apps, or external APIs configured
- Limit: packaged Instructions must be `< 8000` characters (prefer `<= 7600`); enforced by `scripts/validate-chatgpt-instructions.sh`
- More: [chatgpt/builder-config.md](chatgpt/builder-config.md) (Builder setup), [chatgpt/testing-guide.md](chatgpt/testing-guide.md) (smoke tests), [chatgpt/package-manifest.md](chatgpt/package-manifest.md) (package structure)

### Claude Project

- Canonical source: [claude/project-instructions.md](claude/project-instructions.md) (full) / [claude/project-instructions.compact.md](claude/project-instructions.compact.md) (compact, must stay behaviorally aligned) + [claude/knowledge-manifest.md](claude/knowledge-manifest.md)
- Setup: [claude/project-setup.md](claude/project-setup.md); artifact behavior: [claude/artifact-policy.md](claude/artifact-policy.md)
- For teammates outside the creator's Claude organization, a portable
  [external self-install kit](claude/external-install/README.md) bundles
  the Skill, Instructions, and approved Knowledge:
  ```bash
  ./scripts/package-claude-external-kit.sh
  ```
  producing `dist/career-targeting-intelligence-claude-kit.zip`

### Claude Skill

- Canonical source: [claude/skill/SKILL.md](claude/skill/SKILL.md) entry point, packaged via an explicit allowlist ([claude/skill-manifest.md](claude/skill-manifest.md)) — never a recursive repository copy
- Build:
  ```bash
  ./scripts/package-claude-skill.sh
  ```
  (`.ps1` equivalent on Windows)
- Output: `dist/career-targeting-intelligence.skill.zip`
- Limit: the packaged Skill `description` (SKILL.md YAML frontmatter) must be `< 2400` characters (prefer `<= 2200`); enforced by `scripts/validate-skill-description.sh`
- Packaging guide: [claude/packaging.md](claude/packaging.md)

## Validation

- `scripts/validate-chatgpt-instructions.sh` / `.ps1` — ChatGPT Instructions length gate, run automatically by `package-chatgpt-gpt.sh`
- `scripts/validate-skill-description.sh` / `.ps1` — Claude Skill description length gate, run automatically by `package-claude-skill.sh`
- [tests/README.md](tests/README.md) — synthetic job-verification scenarios, quality-gate checklist, and package-alignment checklist (this repository is documentation-driven; these are reviewed synthetic scenarios rather than executable unit tests)

## Development workflow

All implementation work — including documentation-only changes — happens
on a dedicated task branch created from an up-to-date `main`; never
implement directly on `main`. See
[AGENTS.md](AGENTS.md#git-and-pr-workflow) for the full branch-safety,
stash, and merge policy.

## Golden example

A complete, end-to-end worked example — using a fully synthetic candidate ("Tova") and entirely synthetic companies, people, and activity — demonstrates the schemas, trust policy, ranking models, workflow, and output contracts working together:

- [examples/tova/](examples/tova/) — the full journey from source profile through Candidate Profile, Search Criteria, Company Map, Excluded Companies, People Map, Activity Verification, Outreach Queue, Research State, and evaluation notes

## Additional documentation

- [ROADMAP.md](ROADMAP.md)
- [core/product-definition.md](core/product-definition.md)
- [core/scope-and-non-goals.md](core/scope-and-non-goals.md)
