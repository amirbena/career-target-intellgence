# Repository Instructions (Canonical)

This file is the canonical, provider-neutral source of truth for how any
coding agent (Claude, Codex, Gemini, or otherwise) works in this
repository. Platform-specific files (e.g. `CLAUDE.md`) extend this file
for their own agent's operating conventions; they must not duplicate it
wholesale. When both a shared rule and a platform-specific file could
describe the same topic, the platform-specific file should reference this
document rather than restate the rule.

## Working rules

- Always inspect the repository before changing files.
- Start feature work from the latest `main`.
- Create one dedicated branch per task.
- Do not modify unrelated files.
- Treat `core/` as the platform-independent source of truth.
- Keep `claude/` and `chatgpt/` platform-specific.
- Do not duplicate business rules across platform folders when they belong
  in `core/`.
- Prefer small, focused changes.
- Do not add LinkedIn automation, scheduled monitoring, scraping, alerts,
  outreach automation, or automatic external-file mutation unless a future
  task explicitly requests it.
- Do not push, open a PR, merge, or delete branches unless explicitly
  requested.

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

## Git and PR workflow

### Implementation branch rule

Every implementation task that changes repository files must use a
dedicated task branch. This includes:

- features
- fixes
- refactoring
- scripts
- tests
- configuration
- prompts
- skill behavior
- committed documentation changes
- generated repository artifacts intended for commit

Read-only analysis/review does not require a branch unless files will be
modified. Never implement directly on `main`.

### Up-to-date main rule

Every new implementation branch must start from the current remote
`main`. Before creating the task branch:

- fetch remote state
- update local `main`
- verify local `main == origin/main`
- resolve divergence before implementation

Do not create implementation branches from stale `main`. If valid work
already exists on an active feature branch, preserve it rather than
recreating it unnecessarily.

### Pre-edit gate

Before the first repository modification, confirm:

- main is updated
- working tree is clean or fully understood
- dedicated task branch is active
- active branch is not main

Read-only inspection may occur before branch creation. File creation,
modification, deletion, formatting, or generated committed output may
not.

### Merge strategy

Prefer squash merge into `main`. Default flow:

```
review → squash merge → one focused commit on main
```

Use a different merge strategy only when there is a clear
repository-specific reason to preserve multiple commits. Do not rewrite
or force-push `main`.

### Post-merge synchronization

After a PR is successfully merged:

1. fetch latest remote state
2. switch local checkout to `main`
3. update local `main` from `origin/main`
4. verify local `main == origin/main`
5. verify the merged commit is present
6. delete the merged local task branch
7. delete the merged remote branch when appropriate

Because squash merge may make `git branch -d` refuse deletion, verify the
PR work is represented on `main` before using `git branch -D`. Never
force-delete first and verify afterward.

### Safe local cleanup

After merge, inspect `git status --short` and remove only known-safe
disposable artifacts associated with the completed task (e.g. scratch
files, transient generated output, temporary task-specific artifacts,
reproducible build/test leftovers).

Do not blindly remove unknown untracked files. Preserve unrelated work,
user-created files, credentials/secrets, intentional local configuration,
and another active task's artifacts.

Do not use broad destructive cleanup such as `git clean -fd` unless every
affected file has been explicitly inspected and confirmed safe.

## Before completion

- Inspect the final diff.
- Verify relative Markdown links.
- Confirm only expected files changed.
- Commit the work.

## Final response report

Every task's final response must include:

- Branch name
- Commit hash
- Changed files
- Validation performed
- Remaining limitations

## Maintenance: preventing instruction drift

When a rule applies to all coding agents, update `AGENTS.md` only. Update
`CLAUDE.md` (or another platform-specific file) only when the rule is
genuinely specific to that agent. Do not copy shared `AGENTS.md` rules
into a platform-specific file for convenience. If both files need to
mention the same topic, the platform-specific file should reference the
canonical rule here and only add its own specialization.

## Related documents

- [README.md](README.md)
- [core/scope-and-non-goals.md](core/scope-and-non-goals.md)
- [CLAUDE.md](CLAUDE.md)
