# Development

See the [repository map](repository-map.md) for the directory layout. Contributor and agent rules live in [AGENTS.md](../AGENTS.md) and [policies/](../policies/). The README keeps only a short [development summary](../README.md#development).

## Build / package

Every package is generated from the canonical sources above by a build
script — never hand-edit a generated file. Each build script also runs
any platform validator before packaging (the ChatGPT packagers only check `plugin.json` is valid JSON).

### ChatGPT Plugin

- Canonical source: [chatgpt/plugin/SKILL.md](../chatgpt/plugin/SKILL.md) (behavior) + [chatgpt/plugin/plugin.json](../chatgpt/plugin/plugin.json) (manifest) + [chatgpt/knowledge-manifest.md](../chatgpt/knowledge-manifest.md)-mapped bundles (reference material)
- Build:
  ```bash
  ./scripts/package/build-chatgpt-knowledge.sh
  ./scripts/package/package-chatgpt-plugin.sh
  ```
  (`.ps1` equivalents on Windows)
- Output: `dist/career-targeting-intelligence-chatgpt-plugin.zip` — skills-only; no apps, MCP servers, hooks, or external APIs
- Limits: manifest fields should stay within OpenAI's documented plugin limits ([chatgpt/plugin-config.md](../chatgpt/plugin-config.md)); not automatically enforced, so check them before submitting. The packagers only check that `plugin.json` is valid JSON
- More: [chatgpt/plugin-config.md](../chatgpt/plugin-config.md) (manifest values and limits), [chatgpt/testing-guide.md](../chatgpt/testing-guide.md) (smoke tests), [chatgpt/package-manifest.md](../chatgpt/package-manifest.md) (package structure)

### Claude Project

- Canonical source: [claude/project-instructions.md](../claude/project-instructions.md) (full) / [claude/project-instructions.compact.md](../claude/project-instructions.compact.md) (compact, must stay behaviorally aligned) + [claude/knowledge-manifest.md](../claude/knowledge-manifest.md)
- Setup: [claude/project-setup.md](../claude/project-setup.md); artifact behavior: [claude/artifact-policy.md](../claude/artifact-policy.md)
- For teammates outside the creator's Claude organization, a portable
  [external self-install kit](../claude/external-install/README.md) bundles
  the Skill, Instructions, and approved Knowledge:
  ```bash
  ./scripts/package/package-claude-external-kit.sh
  ```
  producing `dist/career-targeting-intelligence-claude-kit.zip`

### Claude Plugin

- Canonical source: [claude/plugin/plugin.json](../claude/plugin/plugin.json) (manifest) + the Claude Skill sources — the Skill is not forked
- Build: `./scripts/package/package-claude-plugin.sh` (`.ps1` on Windows), producing `dist/career-targeting-intelligence-claude-plugin.zip`
- Versions: set `RELEASE_VERSION` when packaging; the GitHub Release tag is the single source of truth ([claude/packaging.md](../claude/packaging.md))

### Claude Skill

- Canonical source: [skills/career-targeting-intelligence/SKILL.md](../skills/career-targeting-intelligence/SKILL.md) entry point, packaged via an explicit allowlist ([claude/skill-manifest.md](../claude/skill-manifest.md)) — never a recursive repository copy
- Build:
  ```bash
  ./scripts/package/package-claude-skill.sh
  ```
  (`.ps1` equivalent on Windows)
- Output: `dist/career-targeting-intelligence.skill.zip`
- Limit: the packaged Skill `description` (SKILL.md YAML frontmatter) must be `< 2400` characters (prefer `<= 2200`); enforced by `scripts/validate/validate-skill-description.sh`
- Packaging guide: [claude/packaging.md](../claude/packaging.md)

## Validation

CI runs on Linux, so CI-only scripts are Bash only: `validate-branch-name.sh`, `validate-pr-release.sh`, and `verify-archive-versions.sh` have no `.ps1` twins (removed because no workflow or Windows packaging path uses them). `validate-claude-plugin.sh` is also Bash only (the Windows plugin packager skips it; run it under Bash or WSL). `validate-chatgpt-plugin` was removed (its limits are documented, not enforced). `validate-skill-description` keeps its `.ps1` version because the `.ps1` Skill packagers call it.

- `scripts/validate/validate-claude-plugin.sh` — Claude plugin manifest and marketplace manifest (`.claude-plugin/marketplace.json`): JSON syntax, required fields, source/skill paths, version consistency. Needs only `python3`; CI never invokes the `claude` CLI. Whether Claude can actually install and update the plugin is a [manual check](installation.md#manual-verification)
- `scripts/validate/validate-skill-description.sh` / `.ps1` — Claude Skill description length gate, run automatically by `scripts/package/package-claude-skill.sh`
- [tests/README.md](../tests/README.md) — synthetic job-verification scenarios, quality-gate checklist, and package-alignment checklist (this repository is documentation-driven; these are reviewed synthetic scenarios rather than executable unit tests)
