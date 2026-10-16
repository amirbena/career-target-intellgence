# ChatGPT Package Manifest

Defines the exact structure of the deployable ChatGPT Plugin archive. See
[`README.md`](README.md) for what the package is for,
[`plugin-config.md`](plugin-config.md) for the manifest values, and
[`knowledge-manifest.md`](knowledge-manifest.md) for the reference
bundle-to-source mapping this package embeds.

## Package identity

- **Plugin name:** `career-targeting-intelligence`
- **Output archive:** `dist/career-targeting-intelligence-chatgpt-plugin.zip`
- **Archive root:** the plugin root — `plugin.json` sits at the top level
  of the zip, with no wrapping directory. This layout is unconfirmed
  against the submission dashboard; see
  [`plugin-config.md`](plugin-config.md#unconfirmed-choices).

## Expected structure

```text
plugin.json
skills/
  career-targeting-intelligence/
    SKILL.md
    references/
      capability-policy.md
      01-product-and-terminology.md
      02-candidate-and-search.md
      03-company-intelligence.md
      04-people-and-activity.md
      05-ranking-and-exclusions.md
      06-workflow-and-state.md
      07-evidence-confidence-freshness.md
      08-output-contracts.md
      09-job-and-company-state.md
```

The archive contains file entries only (no directory entries), with
forward-slash paths. The packagers fail if the archive contents differ
from this list.

## Source mapping

| Archive file | Source |
|---|---|
| `plugin.json` | [`plugin/plugin.json`](plugin/plugin.json) |
| `skills/career-targeting-intelligence/SKILL.md` | [`plugin/SKILL.md`](plugin/SKILL.md) |
| `skills/career-targeting-intelligence/references/capability-policy.md` | [`capability-policy.md`](capability-policy.md) |
| `skills/career-targeting-intelligence/references/0N-*.md` | The output of `scripts/package/build-chatgpt-knowledge.sh` / `.ps1`, built first and embedded unchanged |

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
- The repository-facing docs in `chatgpt/` (`README.md`,
  `plugin-config.md`, `package-manifest.md`, `knowledge-manifest.md`,
  `testing-guide.md`, `sharing-and-publishing.md`)
- Any real candidate, company, or person data
- Temporary/staging directories or previous archives
- App references (`.app.json`), MCP configuration (`mcp.json`), lifecycle
  hooks, API credentials, or any other API configuration
- `.DS_Store`, `Thumbs.db`, `__MACOSX/`

## Building the package

```bash
./scripts/package/package-chatgpt-plugin.sh
```

```powershell
.\scripts\package\package-chatgpt-plugin.ps1
```

Both scripts validate the manifest and skill
(`validate-chatgpt-plugin.sh` / `.ps1`), run the Knowledge builder
(`build-chatgpt-knowledge.sh` / `.ps1`), then assemble the archive using
the explicit allowlist above.
