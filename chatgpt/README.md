# Career Targeting Intelligence — ChatGPT Plugin

This is the deployable ChatGPT Plugin package for Career Targeting
Intelligence. It packages the same methodology defined canonically in
`core/`, `schemas/`, `ranking/`, `workflows/`, and `outputs/` as a
skills-only plugin: one skill plus reference files, with no apps, MCP
servers, hooks, or external APIs.

## What this plugin does

Given a candidate's background and search constraints, it produces a
prioritized, evidence-based map of target companies, relevant recruiters
and engineering managers, verified public activity, and a manual outreach
queue — a research and prioritization assistant the user reviews and acts
on themselves, not an automation system.

## Canonical source and how to regenerate

The archive is generated, not hand-authored. Do not edit files inside a
built archive or the generated `knowledge/` bundles — edit the canonical
source and rebuild:

- Behavior: [`plugin/SKILL.md`](plugin/SKILL.md)
- Manifest and listing metadata: [`plugin/plugin.json`](plugin/plugin.json)
- Reference material: the canonical files listed in
  [`knowledge-manifest.md`](knowledge-manifest.md)

```bash
./scripts/package/build-chatgpt-knowledge.sh    # regenerates knowledge/*.md
./scripts/validate/validate-chatgpt-plugin.sh    # checks manifest and skill limits
./scripts/package/package-chatgpt-plugin.sh     # validates and builds the archive
```

(`.ps1` equivalents on Windows, run from the repository root.) Packaging
produces `dist/career-targeting-intelligence-chatgpt-plugin.zip`. The
packager runs the Knowledge builder and the validator itself and fails the
build on any violation — these are automated constraints, not manual
checks.

## What the archive contains

```text
plugin.json
skills/career-targeting-intelligence/
  SKILL.md
  references/
    capability-policy.md
    01-product-and-terminology.md … 09-job-and-company-state.md
```

See [`package-manifest.md`](package-manifest.md) for the full structure
definition and exclusions, and [`plugin-config.md`](plugin-config.md) for
the manifest values and limits.

## Installing and sharing

See [`sharing-and-publishing.md`](sharing-and-publishing.md) for private
install and directory submission.

## Required validation

Before sharing or submitting, run every test in
[`testing-guide.md`](testing-guide.md) and confirm each behaves as
documented.

## Privacy boundaries

- This archive contains no real candidate, company, or person data, and
  no Golden Journey example content.
- Reference files are methodology only — never personal records. See
  [`knowledge-manifest.md`](knowledge-manifest.md).
- The plugin does not promise persistence, automatic memory, or guaranteed
  web access — see the explicit non-actions in
  [`plugin/SKILL.md`](plugin/SKILL.md).

## Apps, MCP, and APIs are not included

This package declares no apps, MCP servers, hooks, connectors, or external
APIs. See [`capability-policy.md`](capability-policy.md) for how the
skill behaves with and without built-in platform capabilities like web
search and data analysis.
