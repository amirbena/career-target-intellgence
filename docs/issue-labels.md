# Issue Label Taxonomy

A deliberately small label set that mirrors the fields of the
[Engineering Task issue form](../.github/ISSUE_TEMPLATE/engineering-task.yml).
Every issue gets **one type, one area, and one priority**. Labels are applied
by hand when the issue is created; the form's dropdown answers map directly
to a label.

## Type — what kind of work

| Label | Color | Description | Use when |
| --- | --- | --- | --- |
| `type: feature` | `#1d76db` | New capability or behavior | Adding something the product or repo does not do yet |
| `type: refactor` | `#5319e7` | Restructure without changing behavior | Reorganizing or simplifying existing content |
| `type: quality` | `#0e8a16` | Correctness, consistency, or validation | Fixing drift, contradictions, or gaps; adding checks |
| `type: research` | `#fbca04` | Investigation that produces a decision | The outcome is a recommendation, not a change |
| `type: documentation` | `#0075ca` | Docs-only change | Only prose or examples change |
| `type: infrastructure` | `#6e7781` | Repo, tooling, packaging, or process | Scripts, templates, CI, labels, workflow rules |

## Area — which part of the product

| Label | Color | Description |
| --- | --- | --- |
| `area: candidate-fit` | `#bfd4f2` | Candidate & Fit Analysis |
| `area: jobs` | `#bfd4f2` | Job Discovery & Verification |
| `area: companies` | `#bfd4f2` | Company Discovery & Ranking |
| `area: people` | `#bfd4f2` | People Discovery (Recruiters / Hiring Managers) |
| `area: outreach` | `#bfd4f2` | Outreach Prioritization |
| `area: evidence` | `#bfd4f2` | Research / Evidence |
| `area: core` | `#bfd4f2` | Core Methodology & Policy |
| `area: schemas` | `#bfd4f2` | Schemas & Output Contracts |
| `area: packaging` | `#bfd4f2` | Platform Packaging & Distribution |
| `area: tooling` | `#bfd4f2` | Repository / Tooling |
| `area: docs` | `#bfd4f2` | Documentation |

## Priority — how soon

| Label | Color | Description |
| --- | --- | --- |
| `priority: P0` | `#b60205` | Correctness or blocking emergency — applied manually only |
| `priority: P1` | `#d93f0b` | High |
| `priority: P2` | `#fbca04` | Medium |
| `priority: P3` | `#c2e0c6` | Low |

## Triage labels

Applied when closing or routing an issue, not when creating it.

| Label | Color | Description |
| --- | --- | --- |
| `bug` | `#d73a4a` | Something isn't working |
| `question` | `#d876e3` | Further information is requested |
| `duplicate` | `#cfd3d7` | This issue or pull request already exists |
| `wontfix` | `#ffffff` | This will not be worked on |

## Default GitHub labels

| Default label | Decision |
| --- | --- |
| `enhancement` | Renamed to `type: feature` |
| `documentation` | Renamed to `type: documentation` |
| `bug`, `question`, `duplicate`, `wontfix` | Kept as triage labels |
| `good first issue`, `help wanted`, `invalid` | Retired — this is a single-maintainer repository with no contributor funnel, and `invalid` overlaps with `wontfix` |

## Usage rules

1. One `type`, one `area`, one `priority` per issue. If an issue needs two
   types or areas, it probably should be split.
2. Choose the same values you selected in the issue form.
3. `priority: P0` is never chosen in the form; only a maintainer applies it.
4. Historical issues are not relabelled retroactively.
5. Adding or renaming a label means updating this file in the same change.

## Creating the labels

```bash
gh label create "type: feature" --color 1d76db --description "New capability or behavior" --force
# ...repeat per table above; --force updates an existing label
```
