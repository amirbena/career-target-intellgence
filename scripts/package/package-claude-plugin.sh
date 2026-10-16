#!/usr/bin/env bash
#
# Packages the Career Targeting Intelligence Claude Plugin into
# dist/career-targeting-intelligence-claude-plugin.zip.
#
# The plugin reuses the Claude Skill sources (SKILL.md, references/,
# templates/) with the same allowlist and file list as the Skill ZIP; it does
# not fork the Skill content. The plugin root is the archive root:
# .claude-plugin/plugin.json sits at the top level of the zip.
#
# Set RELEASE_VERSION (MAJOR.MINOR.PATCH) to write that version into the
# manifest and the packaged SKILL.md; without it local builds keep the
# versions in the source files.
#
# Works when invoked from inside or outside the repository root, since all
# paths are resolved relative to this script's own location.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/../.." >/dev/null 2>&1 && pwd -P)"

PLUGIN_SRC_DIR="${REPO_ROOT}/claude/plugin"
SKILL_SOURCE_DIR="${REPO_ROOT}/skills/career-targeting-intelligence"
DIST_DIR="${REPO_ROOT}/dist"
BUILD_DIR="${REPO_ROOT}/.build/claude-plugin-package"
PACKAGE_NAME="career-targeting-intelligence-claude-plugin"
SKILL_NAME="career-targeting-intelligence"
OUTPUT_ZIP="${DIST_DIR}/${PACKAGE_NAME}.zip"

fail() {
  echo "error: $1" >&2
  exit 1
}

command -v zip >/dev/null 2>&1 || fail "the 'zip' command is required but was not found on PATH. Install zip and re-run this script."
command -v unzip >/dev/null 2>&1 || fail "the 'unzip' command is required but was not found on PATH. Install unzip and re-run this script."
command -v python3 >/dev/null 2>&1 || fail "python3 is required but was not found on PATH."

if [ -n "${RELEASE_VERSION:-}" ]; then
  [[ "${RELEASE_VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail "RELEASE_VERSION must be MAJOR.MINOR.PATCH, got: ${RELEASE_VERSION}"
fi

[ -x "${SCRIPT_DIR}/../validate/validate-skill-description.sh" ] || fail "required validation script not found or not executable: ${SCRIPT_DIR}/../validate/validate-skill-description.sh"
"${SCRIPT_DIR}/../validate/validate-skill-description.sh"
[ -x "${SCRIPT_DIR}/../validate/validate-claude-plugin.sh" ] || fail "required validation script not found or not executable: ${SCRIPT_DIR}/../validate/validate-claude-plugin.sh"
"${SCRIPT_DIR}/../validate/validate-claude-plugin.sh"

[ -f "${PLUGIN_SRC_DIR}/plugin.json" ] || fail "required file not found: ${PLUGIN_SRC_DIR}/plugin.json"
[ -f "${SKILL_SOURCE_DIR}/SKILL.md" ] || fail "required file not found: ${SKILL_SOURCE_DIR}/SKILL.md"
[ -d "${SKILL_SOURCE_DIR}/references" ] || fail "required directory not found: ${SKILL_SOURCE_DIR}/references"
[ -d "${SKILL_SOURCE_DIR}/templates" ] || fail "required directory not found: ${SKILL_SOURCE_DIR}/templates"

# Only remove the dedicated build/staging directory — never an arbitrary path.
rm -rf -- "${BUILD_DIR}"
PACKAGE_ROOT="${BUILD_DIR}/${PACKAGE_NAME}"
SKILL_DIR="${PACKAGE_ROOT}/skills/${SKILL_NAME}"
mkdir -p -- "${PACKAGE_ROOT}/.claude-plugin" "${SKILL_DIR}/references" "${SKILL_DIR}/templates"

# Explicit allowlist copy — never a recursive repository copy.
cp -- "${PLUGIN_SRC_DIR}/plugin.json" "${PACKAGE_ROOT}/.claude-plugin/plugin.json"
cp -- "${SKILL_SOURCE_DIR}/SKILL.md" "${SKILL_DIR}/SKILL.md"
cp -- "${SKILL_SOURCE_DIR}"/references/*.md "${SKILL_DIR}/references/"
cp -- "${SKILL_SOURCE_DIR}"/templates/*.md "${SKILL_DIR}/templates/"

# With RELEASE_VERSION set, write it into the manifest and the packaged SKILL.md.
if [ -n "${RELEASE_VERSION:-}" ]; then
  sed -E -i.bak "s/^(  \"version\": )\"[^\"]*\"/\1\"${RELEASE_VERSION}\"/" "${PACKAGE_ROOT}/.claude-plugin/plugin.json"
  rm -f -- "${PACKAGE_ROOT}/.claude-plugin/plugin.json.bak"
  grep -q "\"version\": \"${RELEASE_VERSION}\"" "${PACKAGE_ROOT}/.claude-plugin/plugin.json" || fail "could not set version in the packaged plugin.json"
  python3 - "${SKILL_DIR}/SKILL.md" "${RELEASE_VERSION}" <<'PY'
import sys
path, version = sys.argv[1], sys.argv[2]
lines = open(path, encoding="utf-8").read().split("\n")
end = lines.index("---", 1)
lines[end:end] = ["metadata:", f"  version: {version}"]
open(path, "w", encoding="utf-8", newline="").write("\n".join(lines))
PY
fi

"${SCRIPT_DIR}/../validate/validate-claude-plugin.sh" "${PACKAGE_ROOT}" >/dev/null

# Strip platform artifacts if any slipped in via the source tree.
find "${BUILD_DIR}" -type f \( -name ".DS_Store" -o -name "Thumbs.db" \) -delete
find "${BUILD_DIR}" -type d -name "__MACOSX" -exec rm -rf -- {} + 2>/dev/null || true

mkdir -p -- "${DIST_DIR}"
rm -f -- "${OUTPUT_ZIP}"

(
  cd "${PACKAGE_ROOT}"
  zip -r -X -D -q "${OUTPUT_ZIP}" .
)

rm -rf -- "${BUILD_DIR}"

[ -f "${OUTPUT_ZIP}" ] || fail "packaging failed: ${OUTPUT_ZIP} was not created"

# Verify the archive holds exactly the allowlisted, normalized paths.
EXPECTED="$( {
  echo ".claude-plugin/plugin.json"
  echo "skills/${SKILL_NAME}/SKILL.md"
  for f in "${SKILL_SOURCE_DIR}"/references/*.md; do echo "skills/${SKILL_NAME}/references/$(basename "$f")"; done
  for f in "${SKILL_SOURCE_DIR}"/templates/*.md; do echo "skills/${SKILL_NAME}/templates/$(basename "$f")"; done
} | LC_ALL=C sort )"
ACTUAL="$(unzip -Z1 "${OUTPUT_ZIP}" | LC_ALL=C sort)"
[ "${EXPECTED}" = "${ACTUAL}" ] || fail "archive contents do not match the allowlist. Expected:
${EXPECTED}
Actual:
${ACTUAL}"

echo "Packaged Claude Plugin: ${OUTPUT_ZIP}"
echo ""
echo "Packaged files:"
echo "${ACTUAL}"
