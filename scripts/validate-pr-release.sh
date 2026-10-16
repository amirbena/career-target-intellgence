#!/usr/bin/env bash
#
# Validates a pull request's release classification. Pure string checks: it
# never calculates a version, edits CHANGELOG.md, tags, or releases. Those
# stay in scripts/release.sh, which reads the same label after merge.
#
# Rules:
#   - exactly one `release: major|minor|patch|none` label
#   - the label is not lower than the PR title's Conventional Commit type
#     implies (`!` or a BREAKING CHANGE footer -> major, feat -> minor,
#     fix -> patch); a higher label is allowed
#   - `release: major` requires a `!` or BREAKING CHANGE marker
#
# Usage: validate-pr-release.sh <title> <labels> [body]
#   labels: comma- or newline-separated label names
#   Falls back to PR_TITLE, PR_LABELS, PR_BODY when arguments are omitted.
#
# Works from any directory; it reads no repository files.

set -euo pipefail

TITLE="${1-${PR_TITLE-}}"
LABELS="${2-${PR_LABELS-}}"
BODY="${3-${PR_BODY-}}"

fail() {
  echo "error: $1" >&2
  exit 1
}

rank() {
  case "$1" in
    none) echo 0 ;; patch) echo 1 ;; minor) echo 2 ;; major) echo 3 ;;
  esac
}

# Exactly one release label.
level=""; count=0
while IFS= read -r label; do
  label="${label#"${label%%[![:space:]]*}"}"; label="${label%"${label##*[![:space:]]}"}"
  case "$label" in
    "release: "*)
      count=$((count + 1))
      level="${label#release: }"
      case "$level" in
        major|minor|patch|none) ;;
        *) fail "unknown release label '$label'. Use release: major, minor, patch, or none." ;;
      esac ;;
  esac
done < <(printf '%s\n' "$LABELS" | tr ',' '\n')

[ "$count" -ge 1 ] || fail "no release label. Add exactly one of: release: major, release: minor, release: patch, release: none."
[ "$count" -eq 1 ] || fail "found $count release labels. Keep exactly one."

# Minimum level implied by the Conventional Commit title.
floor="none"; breaking=0
re='^([a-z]+)(\([^)]*\))?(!)?: .+$'
if [[ "$TITLE" =~ $re ]]; then
  type="${BASH_REMATCH[1]}"; bang="${BASH_REMATCH[3]}"
  [ -n "$bang" ] && breaking=1
  case "$type" in feat) floor="minor" ;; fix) floor="patch" ;; esac
fi
printf '%s' "$BODY" | grep -qE '^BREAKING[ -]CHANGE:' && breaking=1
[ "$breaking" -eq 1 ] && floor="major"

if [ "$(rank "$level")" -lt "$(rank "$floor")" ]; then
  fail "label 'release: $level' is lower than the title implies ('release: $floor'). Fix the label, or retitle the PR (for example docs: instead of feat:)."
fi
if [ "$level" = "major" ] && [ "$breaking" -eq 0 ]; then
  fail "'release: major' needs a breaking-change marker: '!' after the title type or a 'BREAKING CHANGE:' footer in the PR description."
fi

echo "ok: release: $level"
