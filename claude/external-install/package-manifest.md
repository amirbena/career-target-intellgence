# External Kit Package Manifest

Defines the exact structure of the External Kit archive — a separate
artifact from the Skill ZIP, intended for distribution to users outside
the creator's Claude organization. See
[`../skill-manifest.md`](../skill-manifest.md) for how this relates to the
Skill package itself, and [`../packaging.md`](../packaging.md) for how to
build both.

## Kit identity

- **Package name:** `career-targeting-intelligence-claude-kit`
- **Output archive:** `dist/career-targeting-intelligence-claude-kit.zip`
- **Top-level directory inside the archive:** `career-targeting-intelligence-claude-kit/`

## Expected structure

```text
career-targeting-intelligence-claude-kit/
  README.md
  installation-checklist.md
  project-instructions.md
  knowledge-files.md
  conversation-starters.md
  verification-guide.md
  privacy-guide.md

  skill/
    career-targeting-intelligence.skill.zip

  knowledge/
    product-definition.md
    data-model.md
    workflow.md
    source-policy.md
    confidence-model.md
    freshness-policy.md
    quality-gates.md
    output-contracts.md
    company-ranking-model.md
    person-ranking-model.md
    exclusion-policy.md
    outreach-priority-model.md
```

Exactly one top-level directory is allowed inside the archive.

## Source mapping

| Kit file | Source |
|---|---|
| `README.md` | [`external-install/README.md`](README.md) |
| `installation-checklist.md` | [`external-install/installation-checklist.md`](installation-checklist.md) |
| `project-instructions.md` | [`../project-instructions.compact.md`](../project-instructions.compact.md) — copied byte-for-byte at packaging time, never a separately maintained fork |
| `knowledge-files.md` | [`external-install/knowledge-files.md`](knowledge-files.md) |
| `conversation-starters.md` | [`external-install/conversation-starters.md`](conversation-starters.md) |
| `verification-guide.md` | [`external-install/verification-guide.md`](verification-guide.md) |
| `privacy-guide.md` | [`external-install/privacy-guide.md`](privacy-guide.md) |
| `skill/career-targeting-intelligence.skill.zip` | The output of `scripts/package-claude-skill.sh` / `.ps1`, built first and embedded unchanged |
| `knowledge/*.md` | The fixed allowlist in [`knowledge-files.md`](knowledge-files.md), each copied byte-for-byte from its canonical `core/` or `ranking/` source |

## Excluded from the kit

By construction (an explicit allowlist, never a recursive copy), the kit
never contains:

- `.git/`, `.github/`
- `examples/` (including the Tova Golden Journey)
- `tests/`
- `AGENTS.md`, `CLAUDE.md`
- `README.md`, `ROADMAP.md`, `CHANGELOG.md` (the repository's own root
  docs — distinct from the kit's own `README.md`)
- `scripts/` (the packaging scripts themselves)
- Any repository metadata not part of the shipped methodology or
  documentation above
- Any real candidate, company, or person data — the kit ships only
  synthetic-free methodology and empty configuration assets

## Building the kit

```bash
./scripts/package-claude-external-kit.sh
```

```powershell
.\scripts\package-claude-external-kit.ps1
```

Both build the Skill ZIP first (via the existing Skill packager), then
assemble the kit around it. See
[`../packaging.md`](../packaging.md) for full documentation and the
distinction between the Skill ZIP and the External Kit ZIP.
