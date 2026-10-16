#!/usr/bin/env bash
#
# Validates a branch name against the repository convention:
#
#   <type>/<issue-number>-<short-description>
#
# Types: feat, fix, docs, chore, ci, refactor, test. The description is
# lowercase kebab-case, e.g. feat/42-codex-marketplace.
#
# Exempt: main only. Every other branch, including auto-generated names such
# as claude/<slug>-<id>, must be renamed to this convention before it is
# pushed (see policies/git-workflow.md). Pure string check; it reads no
# repository files and never touches Git.
#
# Usage: validate-branch-name.sh [branch]
#   Falls back to BRANCH_NAME when the argument is omitted.

set -euo pipefail

BRANCH="${1-${BRANCH_NAME-}}"

if [ -z "$BRANCH" ]; then
  echo "error: no branch name given. Pass it as an argument or set BRANCH_NAME." >&2
  exit 1
fi

case "$BRANCH" in
  main) echo "ok: '$BRANCH' is exempt from the branch naming convention."; exit 0 ;;
esac

re='^(feat|fix|docs|chore|ci|refactor|test)/[0-9]+-[a-z0-9]+(-[a-z0-9]+)*$'
if [[ "$BRANCH" =~ $re ]]; then
  echo "ok: '$BRANCH' follows the branch naming convention."
  exit 0
fi

cat >&2 <<MSG
error: branch name '$BRANCH' does not follow the convention.

  Expected: <type>/<issue-number>-<short-description>
  Types:    feat, fix, docs, chore, ci, refactor, test
  Example:  fix/38-skip-release-bot

Use lowercase kebab-case after the issue number. Rename the branch with
'git branch -m <new-name>', then push it again. See policies/git-workflow.md.
MSG
exit 1
