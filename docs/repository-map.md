# Repository Map

One page that answers: what is each top-level area for, is it the source of
truth or derived packaging, and which document should I read next?

## Authority levels

| Level | Meaning | Edit rule |
| --- | --- | --- |
| **Canonical** | Platform-independent source of truth for the product methodology or its contracts. | Change here first; other areas adapt it. |
| **Platform surface** | A behavioral package surface (ChatGPT Plugin, Claude Skill, Claude Project) that adapts the canonical sources. | Adapt, never redefine, canonical rules. |
| **Distribution** | Built from existing sources; not an independent behavioral surface. | Never hand-edit generated output. |
| **Policy / docs** | Rules for contributors and human-facing documentation. | Each rule has one home. |
| **Fixture** | Synthetic examples and checklists used to validate behavior. | Read-only reference. |

See [cross-package delivery](../AGENTS.md#cross-package-delivery) for how
canonical sources and the three surfaces must stay equivalent.

## Top-level areas

| Path | Purpose | Authority | Start with |
| --- | --- | --- | --- |
| [core/](../core/README.md) | Product definition, scope, data model, workflow, trust policies (source, confidence, freshness), quality gates, output contracts. | **Canonical** | [product-definition.md](../core/product-definition.md) |
| [schemas/](../schemas/README.md) | Record shapes: candidate, search criteria, job, company, company state, person, activity, research state. | **Canonical** | [data-model.md](../core/data-model.md) |
| [ranking/](../ranking/README.md) | Scoring, exclusion, job-eligibility gate, and outreach-priority models. | **Canonical** | [job-eligibility-gate.md](../ranking/job-eligibility-gate.md) |
| [workflows/](../workflows/README.md) | Journeys and per-module procedures. | **Canonical** | [job-search-journey.md](../workflows/job-search-journey.md) |
| [outputs/](../outputs/README.md) | Output templates, CSV column contracts, readability guide. | **Canonical** | [output-contracts.md](../core/output-contracts.md) |
| [chatgpt/](../chatgpt/README.md) | ChatGPT Plugin surface: `plugin/` source, generated `knowledge/` bundles, config and testing docs. | Platform surface (`knowledge/` is generated) | [README.md](../chatgpt/README.md) |
| [skills/](../skills/README.md) | Claude Skill source (`SKILL.md`, references, templates). Also the entry point for `npx skills` installs. | Platform surface | [SKILL.md](../skills/career-targeting-intelligence/SKILL.md) |
| [claude/](../claude/README.md) | Claude Project instructions, Skill trigger/state/artifact policy, packaging docs, plugin manifest, external install kit. | Platform surface; `external-install/` and `plugin/` are distribution | [README.md](../claude/README.md) |
| [policies/](../policies/README.md) | Git/PR workflow, packaging rules, issue labels. | Policy | [git-workflow.md](../policies/git-workflow.md) |
| [docs/](README.md) | Installation, architecture, development, and this map. | Docs | [installation.md](installation.md) |
| [scripts/](../scripts/README.md) | Package, validate, and release scripts. | Tooling | [development.md](development.md) |
| [tests/](../tests/README.md) | Synthetic verification scenarios and checklists. | Fixture | [README.md](../tests/README.md) |
| [examples/](../examples/README.md) | Synthetic end-to-end golden example ("Tova"). | Fixture | [examples/tova/](../examples/tova/) |
| `.claude-plugin/` | Claude marketplace manifest (`marketplace.json`). | Distribution | [installation.md](installation.md#claude-code-marketplace) |
| `.github/` | Issue/PR templates and CI workflows. | Tooling | [git-workflow.md](../policies/git-workflow.md) |

Root files: [README.md](../README.md) (overview and install),
[ROADMAP.md](../ROADMAP.md) (phases), [AGENTS.md](../AGENTS.md) (canonical
agent/contributor rules), [CLAUDE.md](../CLAUDE.md) (Claude-specific
pointers), [CHANGELOG.md](../CHANGELOG.md) (release history).

## Start here, by task

| I want to… | Read |
| --- | --- |
| Understand the product | [README.md](../README.md), then [core/product-definition.md](../core/product-definition.md) and [core/scope-and-non-goals.md](../core/scope-and-non-goals.md) |
| Install it | [installation.md](installation.md) |
| See how a job search runs | [core/workflow.md](../core/workflow.md), then [workflows/job-search-journey.md](../workflows/job-search-journey.md) |
| Know how a job is verified or rejected | [core/job-verification-policy.md](../core/job-verification-policy.md), [ranking/job-eligibility-gate.md](../ranking/job-eligibility-gate.md) |
| Look up a record's fields | [schemas/](../schemas/README.md) |
| See what an output looks like | [outputs/](../outputs/README.md), [examples/tova/](../examples/tova/) |
| Understand ranking | [ranking/](../ranking/README.md) |
| Change the methodology | [AGENTS.md](../AGENTS.md), edit `core/` (and `schemas/`, `ranking/`, `workflows/`, `outputs/`), then update all three surfaces and run [tests/package-alignment-checklist.md](../tests/package-alignment-checklist.md) |
| Change a platform package | [policies/packaging-rules.md](../policies/packaging-rules.md), [development.md](development.md) |
| Build or release | [development.md](development.md), [scripts/](../scripts/README.md) |
| Contribute (branches, PRs, labels) | [policies/git-workflow.md](../policies/git-workflow.md), [policies/issue-labels.md](../policies/issue-labels.md) |

## Naming and ordering convention

- File names are lowercase `kebab-case.md`.
- Suffixes mark the document kind: `.schema.md` (record schemas),
  `-template.md` (output templates), `-model.md` (scoring models),
  `-policy.md` (rules), `-guide.md` (how-to).
- Each directory's `README.md` lists its documents in reading order,
  not alphabetical order: overview first, then foundations, then details.
- Generated knowledge bundles use a two-digit numeric prefix
  (`01-…`) that fixes their order.
- Every directory index links each document with a one-line purpose;
  add new documents to the index in the same change.
