#!/usr/bin/env bash
#
# Packages the Career Targeting Intelligence Claude Skill into
# dist/career-targeting-intelligence.skill.zip using an explicit
# file allowlist (SKILL.md, references/, templates/).
#
# Works when invoked from inside or outside the repository root, since all
# paths are resolved relative to this script's own location.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd -P)"

SKILL_SOURCE_DIR="${REPO_ROOT}/claude/skill"
DIST_DIR="${REPO_ROOT}/dist"
BUILD_DIR="${REPO_ROOT}/.build/claude-skill-package"
PACKAGE_NAME="career-targeting-intelligence"
OUTPUT_ZIP="${DIST_DIR}/${PACKAGE_NAME}.skill.zip"

fail() {
  echo "error: $1" >&2
  exit 1
}

command -v zip >/dev/null 2>&1 || fail "the 'zip' command is required but was not found on PATH. Install zip and re-run this script."

[ -f "${SKILL_SOURCE_DIR}/SKILL.md" ] || fail "required file not found: ${SKILL_SOURCE_DIR}/SKILL.md"
[ -d "${SKILL_SOURCE_DIR}/references" ] || fail "required directory not found: ${SKILL_SOURCE_DIR}/references"
[ -d "${SKILL_SOURCE_DIR}/templates" ] || fail "required directory not found: ${SKILL_SOURCE_DIR}/templates"

# Only remove the dedicated build/staging directory — never an arbitrary path.
rm -rf -- "${BUILD_DIR}"
mkdir -p -- "${BUILD_DIR}"

PACKAGE_ROOT="${BUILD_DIR}/${PACKAGE_NAME}"
mkdir -p -- "${PACKAGE_ROOT}/references" "${PACKAGE_ROOT}/templates"

# Explicit allowlist copy — never a recursive repository copy.
cp -- "${SKILL_SOURCE_DIR}/SKILL.md" "${PACKAGE_ROOT}/SKILL.md"
cp -- "${SKILL_SOURCE_DIR}"/references/*.md "${PACKAGE_ROOT}/references/"
cp -- "${SKILL_SOURCE_DIR}"/templates/*.md "${PACKAGE_ROOT}/templates/"

# Strip platform artifacts if any slipped in via the source tree.
find "${BUILD_DIR}" -type f \( -name ".DS_Store" -o -name "Thumbs.db" \) -delete
find "${BUILD_DIR}" -type d -name "__MACOSX" -exec rm -rf -- {} + 2>/dev/null || true

mkdir -p -- "${DIST_DIR}"
rm -f -- "${OUTPUT_ZIP}"

(
  cd "${BUILD_DIR}"
  zip -r -X -q "${OUTPUT_ZIP}" "${PACKAGE_NAME}"
)

rm -rf -- "${BUILD_DIR}"

[ -f "${OUTPUT_ZIP}" ] || fail "packaging failed: ${OUTPUT_ZIP} was not created"

echo "Packaged Claude Skill: ${OUTPUT_ZIP}"
echo ""
echo "Packaged files:"
unzip -Z1 "${OUTPUT_ZIP}" | sort
