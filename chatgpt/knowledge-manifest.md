# Knowledge Manifest

Defines the eight Knowledge bundles for the Career Targeting Intelligence
Custom GPT: what each contains, which canonical repository files it's
generated from, and what Knowledge must never contain. A Custom GPT
currently accepts up to 10 Knowledge files — this package uses 8,
comfortably inside that limit.

Knowledge bundles are generated, not hand-written. Rebuild them with
[`../scripts/build-chatgpt-knowledge.sh`](../scripts/build-chatgpt-knowledge.sh)
(or `.ps1`) — never edit a file under `chatgpt/knowledge/` directly. See
[`instructions.md`](instructions.md) for how the GPT is expected to use
Knowledge versus Instructions.

## What Knowledge contains

- Reference methodology (product definition, scope, data model).
- Schemas and terminology.
- Ranking definitions (scoring weights, bands, tiers, exclusion policy,
  outreach priority model).
- Workflow definitions (operating modes, per-module procedures, research
  state).
- Output contracts (canonical output shapes and CSV column contracts).

## What Knowledge must not contain

- Behavioral instructions that belong in [`instructions.md`](instructions.md)
  (routing, clarification policy, non-actions) — Knowledge is reference
  material, not GPT configuration.
- Personal candidate records.
- Tova or any other Golden Journey content.
- Repository-development rules (`AGENTS.md`, `CLAUDE.md`, working rules,
  commit conventions).
- Packaging scripts.
- `CHANGELOG.md` or `ROADMAP.md`.
- Hidden state of any kind.
- Any promise of persistence.

## Bundle source mapping

Each bundle is generated with a header notice marking it as generated
content, followed by one section per canonical source, each headed with
that source's repository path.

### `01-product-and-terminology.md`

- `core/product-definition.md`
- `core/scope-and-non-goals.md`
- `core/data-model.md`

`core/terminology.md` is **not** referenced — it does not exist in the
repository. It will be added to this bundle once a future task creates it.

### `02-candidate-and-search.md`

- `schemas/candidate-profile.schema.md`
- `schemas/search-criteria.schema.md`
- `workflows/analyze-candidate.md`
- `workflows/build-search-criteria.md`

### `03-company-intelligence.md`

- `schemas/company-record.schema.md`
- `workflows/discover-companies.md`
- `workflows/classify-and-rank-companies.md`
- `ranking/company-ranking-model.md`

### `04-people-and-activity.md`

- `schemas/person-record.schema.md`
- `schemas/activity-record.schema.md`
- `workflows/discover-people.md`
- `workflows/verify-activity.md`

### `05-ranking-and-exclusions.md`

- `ranking/person-ranking-model.md`
- `ranking/exclusion-policy.md`
- `ranking/outreach-priority-model.md`

### `06-workflow-and-state.md`

- `core/workflow.md`
- `schemas/research-state.schema.md`
- `workflows/full-journey.md`
- `workflows/focused-task-routing.md` — **mapped** from the filename
  `workflows/focused-task.md` used in earlier task descriptions; the
  tracked repository file is `focused-task-routing.md`.
- `workflows/resume-journey.md`
- `workflows/build-outreach-queue.md` — added here as the one workflow
  module not otherwise covered by any bundle, so the workflow set stays
  complete. Documented explicitly per this manifest, as required whenever
  an additional canonical module is included.

### `07-evidence-confidence-freshness.md`

- `core/source-policy.md`
- `core/confidence-model.md`
- `core/freshness-policy.md`
- `core/quality-gates.md`

### `08-output-contracts.md`

- `core/output-contracts.md`
- `outputs/candidate-profile-template.md`
- `outputs/search-criteria-template.md`
- `outputs/company-map-template.md`
- `outputs/excluded-companies-template.md`
- `outputs/people-map-template.md`
- `outputs/activity-verification-template.md`
- `outputs/outreach-queue-template.md`
- `outputs/csv-column-contracts.md`

`outputs/research-state-template.md` is **not** referenced — no such file
exists in the repository. There is no standalone Markdown output template
for Research State; it is defined only as a schema
(`schemas/research-state.schema.md`, already included in
`06-workflow-and-state.md`) and packaged as a Skill template
(`claude/skill/templates/research-state.md`) rather than as a repository
`outputs/*-template.md` file. This bundle therefore covers the eight
`outputs/*-template.md` files that actually exist, plus
`core/output-contracts.md` and `outputs/csv-column-contracts.md`.

## A note on synthetic example names

Several canonical sources — notably `schemas/candidate-profile.schema.md`
and the `outputs/*-template.md` files — include their own inline
"Synthetic Example" sections using a recurring fictional cast (for
example, "Dana Levi," "Northbridge Systems," "Jordan Ashkenazi"). These
names are part of the canonical schema and output-contract files
themselves, explicitly labeled synthetic, and are preserved verbatim when
those files are copied into a bundle — per the build script's requirement
to preserve source content without silent rewriting.

This is distinct from the Tova Golden Journey (`examples/tova/`), which is
never used as a bundle source anywhere in this manifest. The two examples
happen to reuse overlapping fictional names by convention elsewhere in the
repository, but no file under `examples/tova/` is copied into any
Knowledge bundle.

## Integrity expectations

- Every canonical source above appears in exactly one bundle, except
  where a cross-bundle appearance would be intentional and is explicitly
  called out (none currently are).
- Rebuilding the bundles from unchanged sources must produce identical
  file contents — the build scripts are deterministic.
- No personal data, Golden Journey content, or GPT behavioral instructions
  may enter a bundle. If a future canonical source changes to include
  such content, the build should fail loudly rather than propagate it
  silently — but as of this package, no canonical source referenced above
  contains any.
