# Packaging Rules

Detailed packaging and platform-experience rules for the Claude Skill,
Claude Project, Claude external kit, and ChatGPT surfaces. Moved verbatim
from `AGENTS.md`; the entry point is [../AGENTS.md](../AGENTS.md).

## Claude Skill packaging rules

- `claude/skill/` is the installable Skill source.
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
  `claude/skill/SKILL.md`) must be < 2400 characters; prefer <= 2200 to
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
  `scripts/validate-chatgpt-plugin.sh` / `.ps1` and run by the packagers.
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
