#!/usr/bin/env bash
#
# Packages the Career Targeting Intelligence External Self-Install Kit
# into dist/career-targeting-intelligence-claude-kit.zip.
#
# The kit bundles the built Skill ZIP, the canonical compact Project
# Instructions (copied byte-for-byte as project-instructions.md), a fixed
# allowlist of shared-methodology Knowledge files, and the external
# installation documentation. It never contains personal data, Golden
# Journey content, or repository-development files.
#
# Works when invoked from inside or outside the repository root, since all
# paths are resolved relative to this script's own location.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd -P)"

EXTERNAL_INSTALL_DIR="${REPO_ROOT}/claude/external-install"
PROJECT_INSTRUCTIONS_COMPACT="${REPO_ROOT}/claude/project-instructions.compact.md"
CORE_DIR="${REPO_ROOT}/core"
RANKING_DIR="${REPO_ROOT}/ranking"

DIST_DIR="${REPO_ROOT}/dist"
BUILD_DIR="${REPO_ROOT}/.build/claude-external-kit-package"
PACKAGE_NAME="career-targeting-intelligence-claude-kit"
OUTPUT_ZIP="${DIST_DIR}/${PACKAGE_NAME}.zip"

SKILL_ZIP_NAME="career-targeting-intelligence.skill.zip"
SKILL_ZIP_PATH="${DIST_DIR}/${SKILL_ZIP_NAME}"

fail() {
  echo "error: $1" >&2
  exit 1
}

command -v zip >/dev/null 2>&1 || fail "the 'zip' command is required but was not found on PATH. Install zip and re-run this script."

# Required external-install documentation.
for doc in README.md installation-checklist.md knowledge-files.md conversation-starters.md verification-guide.md privacy-guide.md; do
  [ -f "${EXTERNAL_INSTALL_DIR}/${doc}" ] || fail "required file not found: ${EXTERNAL_INSTALL_DIR}/${doc}"
done

[ -f "${PROJECT_INSTRUCTIONS_COMPACT}" ] || fail "required file not found: ${PROJECT_INSTRUCTIONS_COMPACT}"

# Required canonical Knowledge sources — explicit allowlist, source path -> deployed name.
KNOWLEDGE_FILES=(
  "${CORE_DIR}/product-definition.md:product-definition.md"
  "${CORE_DIR}/data-model.md:data-model.md"
  "${CORE_DIR}/workflow.md:workflow.md"
  "${CORE_DIR}/source-policy.md:source-policy.md"
  "${CORE_DIR}/confidence-model.md:confidence-model.md"
  "${CORE_DIR}/freshness-policy.md:freshness-policy.md"
  "${CORE_DIR}/quality-gates.md:quality-gates.md"
  "${CORE_DIR}/output-contracts.md:output-contracts.md"
  "${RANKING_DIR}/company-ranking-model.md:company-ranking-model.md"
  "${RANKING_DIR}/person-ranking-model.md:person-ranking-model.md"
  "${RANKING_DIR}/exclusion-policy.md:exclusion-policy.md"
  "${RANKING_DIR}/outreach-priority-model.md:outreach-priority-model.md"
)

for entry in "${KNOWLEDGE_FILES[@]}"; do
  src="${entry%%:*}"
  [ -f "${src}" ] || fail "required Knowledge source not found: ${src}"
done

# Build the Skill ZIP first — the external kit embeds it unchanged.
[ -x "${SCRIPT_DIR}/package-claude-skill.sh" ] || fail "required packaging script not found or not executable: ${SCRIPT_DIR}/package-claude-skill.sh"
"${SCRIPT_DIR}/package-claude-skill.sh" >/dev/null
[ -f "${SKILL_ZIP_PATH}" ] || fail "Skill packaging did not produce: ${SKILL_ZIP_PATH}"

# Only remove the dedicated build/staging directory — never an arbitrary path.
rm -rf -- "${BUILD_DIR}"
mkdir -p -- "${BUILD_DIR}"

PACKAGE_ROOT="${BUILD_DIR}/${PACKAGE_NAME}"
mkdir -p -- "${PACKAGE_ROOT}/skill" "${PACKAGE_ROOT}/knowledge"

# Explicit allowlist copy — never a recursive repository copy.
cp -- "${EXTERNAL_INSTALL_DIR}/README.md" "${PACKAGE_ROOT}/README.md"
cp -- "${EXTERNAL_INSTALL_DIR}/installation-checklist.md" "${PACKAGE_ROOT}/installation-checklist.md"
cp -- "${EXTERNAL_INSTALL_DIR}/knowledge-files.md" "${PACKAGE_ROOT}/knowledge-files.md"
cp -- "${EXTERNAL_INSTALL_DIR}/conversation-starters.md" "${PACKAGE_ROOT}/conversation-starters.md"
cp -- "${EXTERNAL_INSTALL_DIR}/verification-guide.md" "${PACKAGE_ROOT}/verification-guide.md"
cp -- "${EXTERNAL_INSTALL_DIR}/privacy-guide.md" "${PACKAGE_ROOT}/privacy-guide.md"

# Canonical compact instructions, copied byte-for-byte — never a separately maintained fork.
cp -- "${PROJECT_INSTRUCTIONS_COMPACT}" "${PACKAGE_ROOT}/project-instructions.md"

# The built Skill ZIP, embedded unchanged.
cp -- "${SKILL_ZIP_PATH}" "${PACKAGE_ROOT}/skill/${SKILL_ZIP_NAME}"

# The fixed Knowledge allowlist, each copied byte-for-byte with a stable deployment name.
for entry in "${KNOWLEDGE_FILES[@]}"; do
  src="${entry%%:*}"
  dest="${entry##*:}"
  cp -- "${src}" "${PACKAGE_ROOT}/knowledge/${dest}"
done

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

echo "Packaged Claude external kit: ${OUTPUT_ZIP}"
echo ""
echo "Packaged files:"
unzip -Z1 "${OUTPUT_ZIP}" | sort
