# Packaging Rules

Detailed packaging and platform-experience rules for the Claude Skill,
Claude Plugin, Claude Project, Claude external kit, and ChatGPT surfaces. Moved verbatim
from `AGENTS.md`; the entry point is [../AGENTS.md](../AGENTS.md).

## Claude Skill packaging rules

- `skills/career-targeting-intelligence/` is the installable Skill source.
- `core/`, `schemas/`, `ranking/`, `workflows/`, and `outputs/` remain
  canonical — the Skill adapts them, it does not redefine them.
- Platform adaptations must not silently change canonical rules, numbers,
  or enums.
- Packaging uses an explicit allowlist (`SKILL.md`, `references/`,
  `templates/`), never a recursive repository copy followed by exclusions.
- Never recursively package the whole repository.
- The macOS/Linux and Windows packaging scripts must remain logically
  equivalent (same allowlist, same output filename, same top-level
  directory, same normalized file list).
- Real user data and Golden Journey examples must never enter the Skill
  ZIP.
- Packaging scripts must work when invoked from outside the repository
  root.
- Remove obsolete `.gitkeep` files when real content is added to a
  directory.
- Every Skill change must validate package contents before completion.
- The final packaged Skill `description` field (YAML frontmatter in
  `skills/career-targeting-intelligence/SKILL.md`) must be < 2400 characters; prefer <= 2200 to
  retain a safety margin.
- Measure the exact final `description` payload that ships in the Skill
  package, not a raw line count — YAML folding changes the actual string.
- Do not work around the limit by moving required runtime behavior into
  the description. It is concise activation metadata; canonical behavior
  belongs in `SKILL.md` body content and `references/`.
- These packaging length limits (ChatGPT Instructions and Skill
  description) are automated build constraints, enforced by dedicated
  validator scripts wired into packaging, not manual review conventions.

## Claude Project experience rules

- Project Instructions orchestrate; they do not duplicate the Skill.
- Full and compact Project Instructions must remain behaviorally aligned.
- Skill activation language must be strong but not claim technical
  guarantees.
- Shared Project Knowledge must contain methodology only.
- Personal records belong only in user-controlled context.
- Platform persistence must not be reimplemented in prompts.
- Project files must not redefine canonical weights, schemas, evidence
  states, or output contracts.
- Claude Project changes must be validated against the Tova Golden
  Journey.
- No ChatGPT files should be changed in Claude-only tasks.

## Claude external kit rules

- External kits use an explicit allowlist.
- External Instructions are copied from the canonical compact source
  during packaging.
- Knowledge deployment files come from canonical repository sources.
- External kits contain no Golden Journey or personal records.
- Skill ZIP and External Kit ZIP are distinct artifacts.
- macOS/Linux and Windows kit packagers must remain logically equivalent.
- Normalized archive paths and extracted file contents must be validated.
- Organization sharing and external installation remain separate product
  paths.

## Claude Plugin packaging rules

- The Claude Plugin ZIP wraps the existing Skill: `claude/plugin/plugin.json`
  is the manifest source and `skills/career-targeting-intelligence/` supplies the Skill content. The
  Skill is never forked.
- The archive root is the plugin root: `.claude-plugin/plugin.json` plus
  `skills/career-targeting-intelligence/` with the same `SKILL.md`,
  `references/*.md`, and `templates/*.md` allowlist as the Skill ZIP.
- It is a skills-only plugin: no hooks, MCP servers, commands, or agents.
- The packagers verify the exact archive file list (forward-slash paths, no
  directory entries) and run `claude plugin validate` when the `claude` CLI
  is available.
- No Golden Journey content or personal data.
- `scripts/package/package-claude-plugin.sh` / `.ps1` and
  `scripts/validate/validate-claude-plugin.sh` / `.ps1` must remain logically
  equivalent.

## Claude marketplace rules

- `.claude-plugin/marketplace.json` makes this repository a Claude Code
  marketplace. Its single entry uses the repository root as the plugin
  source and points `skills` at the canonical
  `skills/career-targeting-intelligence/` directory; it copies no Skill
  files and declares no `version` (the commit identifies the version).
- Keep the entry `name` equal to the plugin name and run
  `claude plugin validate .` after any edit.
- Keep the plugin skills-only; the marketplace adds no hooks, MCP servers,
  commands, or agents.
- The ChatGPT plugin has no repository marketplace: OpenAI marketplaces
  need an assembled plugin tree, which would duplicate generated content.
  It is installed from the release ZIP; see
  [../docs/installation.md](../docs/installation.md).

## Release versioning rules

- The GitHub Release tag is the single source of truth for package versions.
- Every packager (Skill, external kit, Claude Plugin, ChatGPT Plugin) accepts
  `RELEASE_VERSION` (`MAJOR.MINOR.PATCH`) and writes it into the packaged
  manifest or metadata: `metadata.version` in the packaged `SKILL.md`
  frontmatter, `version` in each `plugin.json`, and a top-level `VERSION`
  file in the external kit. Without it, local builds keep today's behavior.
- `scripts/validate/verify-archive-versions.sh` / `.ps1` compare every archive's
  embedded version to the tag; the release fails on any mismatch.
- Version literals in source files are not banned; they are placeholders and
  are overridden at packaging time.

## ChatGPT packaging rules

- The ChatGPT package is a skills-only ChatGPT Plugin. `chatgpt/plugin/SKILL.md`
  is the canonical behavior source and `chatgpt/plugin/plugin.json` is the
  canonical manifest.
- The skill defines behavior; reference files define reference material.
- Generated Knowledge bundles must not be edited manually.
- Knowledge bundles derive only from explicit canonical source allowlists
  and ship as the skill's `references/` files.
- Manifest fields must stay within OpenAI's documented plugin limits
  (see `chatgpt/plugin-config.md`), enforced by
  `scripts/validate/validate-chatgpt-plugin.sh` / `.ps1` and run by the packagers.
- The plugin archive is built from an explicit allowlist, and the
  packagers verify the archive's exact file list, with forward-slash
  paths and no directory entries.
- Do not include Golden Journey or personal records in the plugin
  package.
- The plugin must not claim unavailable memory, browsing, storage, or
  automation.
- Apps (`.app.json`), MCP servers, lifecycle hooks, external APIs,
  monitoring, and outreach execution remain out of scope.
- macOS/Linux and Windows validators, builders, and packagers must
  remain logically equivalent.
- Every ChatGPT package change must validate the manifest and skill,
  reference parity, normalized archive paths, and privacy exclusions.
- Claude-only files must not be changed unless shared documentation
  genuinely requires it.
- Remove obsolete `.gitkeep` files when real content is added.
- Re-check OpenAI's current plugin documentation before changing the
  manifest shape or limits; they are set by OpenAI and change over time.
