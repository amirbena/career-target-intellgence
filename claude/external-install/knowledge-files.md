# Knowledge Files

The external kit ships a fixed, explicit allowlist of shared-methodology
Knowledge files — the same files
[`claude/knowledge-manifest.md`](../knowledge-manifest.md) recommends for
any Career Targeting Intelligence Project, restricted to files that
currently exist in the repository.

## Allowlist (canonical source → deployed name)

| Canonical source | Deployed as |
|---|---|
| `core/product-definition.md` | `knowledge/product-definition.md` |
| `core/data-model.md` | `knowledge/data-model.md` |
| `core/workflow.md` | `knowledge/workflow.md` |
| `core/source-policy.md` | `knowledge/source-policy.md` |
| `core/confidence-model.md` | `knowledge/confidence-model.md` |
| `core/freshness-policy.md` | `knowledge/freshness-policy.md` |
| `core/quality-gates.md` | `knowledge/quality-gates.md` |
| `core/output-contracts.md` | `knowledge/output-contracts.md` |
| `ranking/company-ranking-model.md` | `knowledge/company-ranking-model.md` |
| `ranking/person-ranking-model.md` | `knowledge/person-ranking-model.md` |
| `ranking/exclusion-policy.md` | `knowledge/exclusion-policy.md` |
| `ranking/outreach-priority-model.md` | `knowledge/outreach-priority-model.md` |

`core/terminology.md` is intentionally **not** included — it does not
currently exist in the repository. It will be added to this allowlist once
a future task creates it.

Each deployed file is copied byte-for-byte from its canonical source at
packaging time. It is never hand-edited or independently maintained inside
the kit.

## Optional private workspace files

Beyond the fixed allowlist above, you may separately add your own private
workspace files to your own Project's Knowledge — never to a shared or
team Knowledge base:

- `candidate-profile.md`
- `search-criteria.md`
- `research-state.md`
- `company-map.md`
- `people-map.md`
- `activity-verification.md`
- `outreach-queue.md`

These are yours alone. The kit does not ship them and does not generate
them — you create them from your own research.

## What is intentionally excluded

The kit's Knowledge set never includes:

- A duplicate copy of the Skill source (`claude/skill/` — the Skill is
  installed separately as a Skill package, not re-uploaded as Knowledge).
- Golden Journey example files (`examples/tova/`).
- `CLAUDE.md` (repository working instructions for contributors, not
  end-user methodology).
- `ROADMAP.md` or `CHANGELOG.md` (repository project-management history).
- Packaging scripts (`scripts/`).
- Test fixtures (`tests/`).
- Any other repository metadata not part of the methodology itself.
