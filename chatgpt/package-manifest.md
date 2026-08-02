# ChatGPT Package Manifest

Defines the exact structure of the deployable ChatGPT Custom GPT archive.
See [`README.md`](README.md) for what the package is for, and
[`knowledge-manifest.md`](knowledge-manifest.md) for the Knowledge
bundle-to-source mapping this package embeds.

## Package identity

- **Package name:** `career-targeting-intelligence-chatgpt`
- **Output archive:** `dist/career-targeting-intelligence-chatgpt.zip`
- **Top-level directory inside the archive:** `career-targeting-intelligence-chatgpt/`

## Expected structure

```text
career-targeting-intelligence-chatgpt/
  README.md
  instructions.md
  builder-config.md
  conversation-starters.md
  builder-setup.md
  capability-policy.md
  testing-guide.md
  sharing-and-publishing.md
  knowledge-manifest.md

  knowledge/
    01-product-and-terminology.md
    02-candidate-and-search.md
    03-company-intelligence.md
    04-people-and-activity.md
    05-ranking-and-exclusions.md
    06-workflow-and-state.md
    07-evidence-confidence-freshness.md
    08-output-contracts.md
```

Exactly one top-level directory is allowed inside the archive.

## Source mapping

| Archive file | Source |
|---|---|
| `README.md` | [`README.md`](README.md) |
| `instructions.md` | [`instructions.md`](instructions.md) |
| `builder-config.md` | [`builder-config.md`](builder-config.md) |
| `conversation-starters.md` | [`conversation-starters.md`](conversation-starters.md) |
| `builder-setup.md` | [`builder-setup.md`](builder-setup.md) |
| `capability-policy.md` | [`capability-policy.md`](capability-policy.md) |
| `testing-guide.md` | [`testing-guide.md`](testing-guide.md) |
| `sharing-and-publishing.md` | [`sharing-and-publishing.md`](sharing-and-publishing.md) |
| `knowledge-manifest.md` | [`knowledge-manifest.md`](knowledge-manifest.md) |
| `knowledge/*.md` | The output of `scripts/build-chatgpt-knowledge.sh` / `.ps1`, built first and embedded unchanged |

## Excluded from the archive

By construction (an explicit allowlist, never a recursive copy), the
archive never contains:

- `.git/`, `.github/`
- `AGENTS.md`, `CLAUDE.md`
- The repository root `README.md`, `ROADMAP.md`, `CHANGELOG.md`
- `scripts/` (the packaging and knowledge-build scripts themselves)
- Any Claude distribution files (`claude/`)
- `examples/` (including the Tova Golden Journey)
- `tests/`
- Any real candidate, company, or person data
- Temporary/staging directories or previous archives
- Action schemas, API credentials, or any other API configuration
- `.DS_Store`, `Thumbs.db`, `__MACOSX/`

## Building the package

```bash
./scripts/package-chatgpt-gpt.sh
```

```powershell
.\scripts\package-chatgpt-gpt.ps1
```

Both scripts run the Knowledge builder first (via
`build-chatgpt-knowledge.sh` / `.ps1`), then assemble the archive around
its output using the explicit allowlist above.
