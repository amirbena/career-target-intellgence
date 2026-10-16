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

- `chatgpt/instructions.md` is the canonical Custom GPT behavior source.
- GPT Instructions define behavior; Knowledge defines reference material.
- Generated Knowledge bundles must not be edited manually.
- Knowledge bundles derive only from explicit canonical source allowlists.
- Keep the Knowledge file count within the current GPT limit.
- Do not upload Golden Journey or personal records as shared GPT
  Knowledge.
- The GPT must not claim unavailable memory, browsing, storage, or
  automation.
- Actions, Apps, APIs, monitoring, and outreach execution remain out of
  scope.
- macOS/Linux and Windows builders and packagers must remain logically
  equivalent.
- Every ChatGPT package change must validate Instructions, Knowledge
  parity, normalized archive paths, and privacy exclusions.
- Claude-only files must not be changed unless shared documentation
  genuinely requires it.
- Remove obsolete `.gitkeep` files when real content is added.
- The final packaged ChatGPT Instructions payload (the exact text pasted
  into the Custom GPT's Instructions field) must be < 8000 characters;
  prefer <= 7600 to retain headroom.
- Measure the actual final payload copied into the GPT Instructions field,
  not a partial or pre-edit draft.
- Compress structurally to stay within the limit; do not remove required
  product behavior merely to satisfy it.
- The canonical source of the Instructions payload remains
  `chatgpt/instructions.md` unless repository architecture changes.

