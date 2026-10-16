#!/usr/bin/env bash
# Compute the next semantic version from Conventional Commits since the last
# tag, update CHANGELOG.md, tag, and publish a GitHub Release with the Claude
# Skill, Claude External Kit, Claude Plugin and ChatGPT Plugin ZIPs attached,
# each built with RELEASE_VERSION so its embedded version matches the tag. Safe to re-run: existing tags,
# changelog sections, and release assets are never duplicated, and a missing
# Release or missing assets for the latest tag are recovered.
#
# Usage: scripts/release.sh [--dry-run]
# Needs: git, zip; gh + GH_TOKEN when publishing.
# Optional: GIT_USER_NAME / GIT_USER_EMAIL for the release commit identity.
set -euo pipefail

DRY_RUN=0
[ "${1:-}" = "--dry-run" ] && DRY_RUN=1

cd "$(git rev-parse --show-toplevel)"
BASELINE="1.0.0"
ASSETS=(
  career-targeting-intelligence.skill.zip
  career-targeting-intelligence-claude-kit.zip
  career-targeting-intelligence-claude-plugin.zip
  career-targeting-intelligence-chatgpt-plugin.zip
)
# asset -> packaging script (run from the tagged revision)
packager_for() {
  case "$1" in
    career-targeting-intelligence.skill.zip) echo package-claude-skill.sh ;;
    career-targeting-intelligence-claude-kit.zip) echo package-claude-external-kit.sh ;;
    career-targeting-intelligence-claude-plugin.zip) echo package-claude-plugin.sh ;;
    career-targeting-intelligence-chatgpt-plugin.zip) echo package-chatgpt-plugin.sh ;;
  esac
}
WT=""
trap '[ -z "$WT" ] || git worktree remove --force "$WT" >/dev/null 2>&1 || true' EXIT
if [ "$DRY_RUN" = 0 ]; then  # identity for the release commit and the annotated tag
  git config user.name "${GIT_USER_NAME:-github-actions[bot]}"
  git config user.email "${GIT_USER_EMAIL:-41898282+github-actions[bot]@users.noreply.github.com}"
fi
LAST_TAG="$(git describe --tags --abbrev=0 --match 'v[0-9]*' 2>/dev/null || true)"

# Release notes = the version's CHANGELOG.md section (without its heading).
notes_for() { # $1=version
  awk -v h="## $1 " 'index($0,h)==1 {f=1; next} f && /^## /{exit} f' CHANGELOG.md
}

# Create the Release if missing and upload any missing assets, building the
# ZIPs from the tagged revision so they match the published version.
ensure_release() { # $1=version
  local tag="v$1" notes missing=() have
  if [ "$DRY_RUN" = 1 ]; then echo "[dry-run] would ensure Release $tag with assets: ${ASSETS[*]}"; return 0; fi
  notes="$(mktemp)"; notes_for "$1" > "$notes"
  [ -s "$notes" ] || echo "Release $tag" > "$notes"
  if have="$(gh release view "$tag" --json assets -q '.assets[].name' 2>/dev/null)"; then
    for a in "${ASSETS[@]}"; do grep -qxF "$a" <<<"$have" || missing+=("$a"); done
    [ "${#missing[@]}" -eq 0 ] && { echo "Release $tag is complete."; return 0; }
  else
    have=""; missing=("${ASSETS[@]}")
  fi
  WT="$(mktemp -d)"
  git worktree add --detach "$WT" "refs/tags/$tag" >/dev/null
  # Build from the tagged revision with RELEASE_VERSION. A tag whose packager
  # is missing or predates RELEASE_VERSION cannot produce a version-correct
  # asset, so it is skipped rather than built from newer sources.
  local files=() a pk built=()
  for a in "${missing[@]}"; do
    pk="$(packager_for "$a")"
    if [ ! -x "$WT/scripts/$pk" ] || ! grep -q RELEASE_VERSION "$WT/scripts/$pk"; then
      echo "warning: $tag has no $pk with RELEASE_VERSION support; skipping $a" >&2; continue
    fi
    RELEASE_VERSION="$1" "$WT/scripts/$pk" >/dev/null
    files+=("$WT/dist/$a"); built+=("$a")
  done
  # Fail the release if any built archive's embedded version differs from the tag.
  if [ -x "$WT/scripts/verify-archive-versions.sh" ] && [ "${#built[@]}" -gt 0 ]; then
    "$WT/scripts/verify-archive-versions.sh" "$1" "$WT/dist" "${built[@]}"
  fi
  [ "${#files[@]}" -gt 0 ] || { echo "No buildable assets for $tag."; return 0; }
  if gh release view "$tag" >/dev/null 2>&1; then
    gh release upload "$tag" "${files[@]}" --clobber
  else
    gh release create "$tag" "${files[@]}" --title "$tag" --notes-file "$notes" --verify-tag
  fi
  git worktree remove --force "$WT"
}

tag_and_ensure() { # $1=version  $2=commit to tag
  local tag="v$1"
  if ! git rev-parse -q --verify "refs/tags/$tag" >/dev/null; then
    if [ "$DRY_RUN" = 1 ]; then echo "[dry-run] would tag $tag at $2"; ensure_release "$1"; return 0; fi
    git tag -a "$tag" "$2" -m "Release $tag"
    git push origin "refs/tags/$tag"
  else
    echo "Tag $tag already exists."
  fi
  ensure_release "$1"
}

# First release: the existing changelog content is the baseline.
if [ -z "$LAST_TAG" ]; then
  echo "No tags found; cutting baseline v$BASELINE at HEAD."
  grep -q "^## $BASELINE" CHANGELOG.md || { echo "CHANGELOG.md lacks a '## $BASELINE' section" >&2; exit 1; }
  tag_and_ensure "$BASELINE" HEAD
  exit 0
fi

# Classify commits since the last tag (subject line only; bodies for BREAKING CHANGE).
bump=""; feats=""; fixes=""; breaks=""
while IFS= read -r -d $'\x1e' rec; do
  rec="${rec#"${rec%%[![:space:]]*}"}"
  [ -z "$rec" ] && continue
  subject="$(printf '%s' "$rec" | head -n1)"
  body="$(printf '%s' "$rec" | tail -n +2)"
  re='^([a-z]+)(\([^)]*\))?(!)?: (.+)$'
  [[ "$subject" =~ $re ]] || continue
  type="${BASH_REMATCH[1]}"; bang="${BASH_REMATCH[3]}"; desc="${BASH_REMATCH[4]}"
  desc="$(printf '%s' "$desc" | sed -E 's/ \(#[0-9]+\)$//')"
  if [ -n "$bang" ] || printf '%s' "$body" | grep -qE '^BREAKING[ -]CHANGE:'; then
    breaks+="- $desc"$'\n'; bump="major"; continue
  fi
  case "$type" in
    feat) feats+="- $desc"$'\n'; [ "$bump" = major ] || bump="minor" ;;
    fix)  fixes+="- $desc"$'\n'; [ -n "$bump" ] || bump="patch" ;;
  esac
done < <(git log "$LAST_TAG..HEAD" --format='%s%n%b%x1e')

if [ -z "$bump" ]; then
  echo "No user-facing commits since $LAST_TAG; no new release."
  ensure_release "${LAST_TAG#v}"   # recovery: a missing Release/assets for the latest tag
  exit 0
fi

cur="${LAST_TAG#v}"; IFS=. read -r MA MI PA <<<"$cur"
case "$bump" in
  major) MA=$((MA+1)); MI=0; PA=0 ;;
  minor) MI=$((MI+1)); PA=0 ;;
  patch) PA=$((PA+1)) ;;
esac
NEW="$MA.$MI.$PA"

notes="$(mktemp)"
{
  [ -n "$breaks" ] && printf '### Breaking changes\n\n%s\n' "$breaks"
  [ -n "$feats" ]  && printf '### Features\n\n%s\n' "$feats"
  [ -n "$fixes" ]  && printf '### Fixes\n\n%s\n' "$fixes"
} > "$notes"

echo "Last tag: $LAST_TAG  ->  next: v$NEW ($bump)"
echo "---- changelog section ----"; cat "$notes"

# Idempotent: skip the file edit if the section is already present.
if ! grep -q "^## $NEW " CHANGELOG.md; then
  section="$(mktemp)"
  { printf '## %s - %s\n\n' "$NEW" "$(date -u +%F)"; cat "$notes"; } > "$section"
  out="$(mktemp)"
  # Insert before the first version heading.
  awk -v sec="$section" '!d && /^## /{while((getline l < sec)>0) print l; d=1} {print}' CHANGELOG.md > "$out"
  if [ "$DRY_RUN" = 1 ]; then diff -u CHANGELOG.md "$out" || true; else cp "$out" CHANGELOG.md; fi
fi

if [ "$DRY_RUN" = 1 ]; then tag_and_ensure "$NEW" HEAD; echo "[dry-run] done"; exit 0; fi

if ! git diff --quiet CHANGELOG.md; then
  git add CHANGELOG.md
  git commit -m "chore(release): v$NEW"
  git push origin HEAD
fi
# Tag the release commit (recovers a run that pushed the commit but not the tag).
target="$(git log -1 --format=%H --grep="^chore(release): v$NEW\$")"
tag_and_ensure "$NEW" "${target:-HEAD}"
