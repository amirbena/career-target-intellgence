# Claude Skill Manifest

This manifest describes the packaged Claude Skill for Career Targeting
Intelligence: what it contains, how it maps back to the canonical
repository, and how to build the installable ZIP.

## Skill identity

- **Skill name:** `career-targeting-intelligence`
- **Version:** 1.0.0
- **Package root (source):** [`claude/skill/`](skill/)
- **Top-level directory inside the ZIP:** `career-targeting-intelligence/`

## Included files

Everything under `claude/skill/` is Skill source and enters the package:

```
claude/skill/
  SKILL.md
  references/
    candidate-intelligence.md
    company-intelligence.md
    people-intelligence.md
    activity-verification.md
    ranking-and-exclusions.md
    workflow-routing.md
    output-generation.md
    quality-and-trust.md
  templates/
    candidate-profile.md
    search-criteria.md
    company-map.md
    excluded-companies.md
    people-map.md
    activity-verification.md
    outreach-queue.md
    research-state.md
```

## Intentionally excluded files

The package uses an explicit allowlist (`SKILL.md`, `references/`,
`templates/`), so everything else is excluded by construction, including:

- `.git/`, `.github/`
- `.DS_Store`, `Thumbs.db`, `__MACOSX/`
- The repository root `README.md`, `ROADMAP.md`, `CHANGELOG.md`, `CLAUDE.md`
- `core/`, `schemas/`, `ranking/`, `workflows/`, `outputs/`
- `examples/` (including the Tova golden journey — it is a repository
  development asset, not Skill content, and must never enter the package)
- `tests/`
- `claude/skill-manifest.md`, `claude/packaging.md` (documentation about the
  package, not part of it)
- `scripts/` (the packaging scripts themselves)
- Any previous `*.skill.zip` output, temporary build folders, or caches

## Canonical source mappings

Every reference file in `claude/skill/references/` adapts specific
canonical repository files rather than redefining them. See the "Canonical
sources" note at the top of each reference file for the exact mapping.
Summary:

| Reference file | Canonical sources |
|---|---|
| `candidate-intelligence.md` | `schemas/candidate-profile.schema.md`, `schemas/search-criteria.schema.md`, `workflows/analyze-candidate.md`, `workflows/build-search-criteria.md` |
| `company-intelligence.md` | `schemas/company-record.schema.md`, `workflows/discover-companies.md`, `workflows/classify-and-rank-companies.md` |
| `people-intelligence.md` | `schemas/person-record.schema.md`, `workflows/discover-people.md` |
| `activity-verification.md` | `schemas/activity-record.schema.md`, `workflows/verify-activity.md` |
| `ranking-and-exclusions.md` | `ranking/company-ranking-model.md`, `ranking/person-ranking-model.md`, `ranking/exclusion-policy.md`, `ranking/outreach-priority-model.md` |
| `workflow-routing.md` | `core/workflow.md`, `workflows/full-journey.md`, `workflows/focused-task-routing.md`, `workflows/resume-journey.md`, `schemas/research-state.schema.md` |
| `output-generation.md` | `core/output-contracts.md`, `outputs/*-template.md`, `outputs/csv-column-contracts.md` |
| `quality-and-trust.md` | `core/source-policy.md`, `core/confidence-model.md`, `core/freshness-policy.md`, `core/quality-gates.md` |

Templates in `claude/skill/templates/` mirror the placeholder structure of
the matching file in `outputs/*-template.md`, with all synthetic example
content stripped — templates ship as clean, reusable placeholders only.

## Expected ZIP structure

```
career-targeting-intelligence.skill.zip
└── career-targeting-intelligence/
    ├── SKILL.md
    ├── references/
    │   └── ... (8 files)
    └── templates/
        └── ... (8 files)
```

Exactly one top-level directory. No other files or directories at the ZIP
root.

## Installation outline

1. Download or build `dist/career-targeting-intelligence.skill.zip` (see
   [`packaging.md`](packaging.md)).
2. In the target Claude surface's Skill management UI, upload the ZIP as a
   new Skill (or extract it to the location that surface expects a Skill
   package to live).
3. Confirm the Skill is named `career-targeting-intelligence` and that its
   description matches the frontmatter in `SKILL.md`.
4. No further configuration is required — the Skill has no external
   dependencies and does not require API keys, credentials, or connected
   accounts.

## Packaging commands

macOS / Linux:

```bash
./scripts/package-claude-skill.sh
```

Windows PowerShell:

```powershell
.\scripts\package-claude-skill.ps1
```

Both produce `dist/career-targeting-intelligence.skill.zip`. See
[`packaging.md`](packaging.md) for full documentation.

## Supported operating systems

- macOS (Bash 3.2+ via the system `zip` utility, or a newer Bash)
- Linux (Bash with `zip` available)
- Windows (Windows PowerShell 5.1 or PowerShell 7+, using built-in .NET ZIP
  support)

## Known limitations

- The packaging scripts require a standard `zip` command (macOS/Linux) or
  built-in PowerShell/.NET compression cmdlets (Windows) — no third-party
  packaging dependency is bundled or installed.
- ZIP files produced on different operating systems are not guaranteed to
  be byte-for-byte identical, because each platform's `zip` implementation
  writes different archive metadata (timestamps, file-mode bits, host
  attributes). The normalized internal file list and the contents of each
  file are guaranteed to match; the raw archive bytes and hash are not.
- The Skill package contains no example data. Users who want to see the
  methodology applied end-to-end should read the Tova golden journey in
  [`examples/tova/`](../examples/tova/) directly in the repository — it is
  intentionally not shipped inside the Skill package.
- This package does not include Claude Project instructions or a ChatGPT
  Custom GPT configuration; those are tracked separately in the project
  roadmap.
