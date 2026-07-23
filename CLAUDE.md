# Repository Instructions for Claude Code

## Working rules

- Always inspect the repository before changing files.
- Start feature work from the latest `main`.
- Create one dedicated branch per task.
- Do not modify unrelated files.
- Treat `core/` as the platform-independent source of truth.
- Keep `claude/` and `chatgpt/` platform-specific.
- Do not duplicate business rules across platform folders when they belong in `core/`.
- Prefer small, focused changes.
- Do not add LinkedIn automation, scheduled monitoring, scraping, alerts, outreach automation, or automatic external-file mutation unless a future task explicitly requests it.
- Do not push, open a PR, merge, or delete branches unless explicitly requested.

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

## Related documents

- [README.md](README.md)
- [core/scope-and-non-goals.md](core/scope-and-non-goals.md)
