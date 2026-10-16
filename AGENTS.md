# Repository Instructions (Canonical)

This file is the canonical, provider-neutral entry point for how any
coding agent (Claude, Codex, Gemini, or otherwise) works in this
repository. Platform-specific files (e.g. `CLAUDE.md`) extend this file
for their own agent's operating conventions; they must not duplicate it
wholesale. When both a shared rule and a platform-specific file could
describe the same topic, the platform-specific file should reference this
document rather than restate the rule.

Detailed policy lives in linked documents; every rule has one home.

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

## Where the detailed rules live

| Topic | Document |
| --- | --- |
| Branches, up-to-date `main`, pre-edit gate, stash policy, Issue and PR descriptions, release classification (`release:` labels), merge strategy, admin merge fallback, post-merge sync, local cleanup | [docs/git-workflow.md](docs/git-workflow.md) |
| Claude Skill packaging, Claude Project experience, Claude external kit, ChatGPT packaging (allowlists, length limits, script parity, privacy exclusions) | [docs/packaging-rules.md](docs/packaging-rules.md) |
| Issue label taxonomy | [docs/issue-labels.md](docs/issue-labels.md) |
| Scope and non-goals | [core/scope-and-non-goals.md](core/scope-and-non-goals.md) |
| Quality gates and cross-platform alignment | [core/quality-gates.md](core/quality-gates.md) |
| Repository layout, validation scripts, and test scenarios | [README.md](README.md), [tests/README.md](tests/README.md) |

Read the Git workflow before your first change, and the packaging rules
before touching `claude/` or `chatgpt/` packaging.

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

When a rule applies to all coding agents, update the canonical document
that owns it (this file or a linked document) only. Update `CLAUDE.md`
(or another platform-specific file) only when the rule is genuinely
specific to that agent. Do not copy shared rules into a platform-specific
file for convenience. If both need to mention the same topic, the
platform-specific file should reference the canonical rule and only add
its own specialization.

## Related documents

- [README.md](README.md)
- [CLAUDE.md](CLAUDE.md)
- [core/scope-and-non-goals.md](core/scope-and-non-goals.md)
- [docs/issue-labels.md](docs/issue-labels.md)
