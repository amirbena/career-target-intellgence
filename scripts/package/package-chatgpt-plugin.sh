#!/usr/bin/env bash
#
# Packages the Career Targeting Intelligence ChatGPT Plugin into
# dist/career-targeting-intelligence-chatgpt-plugin.zip.
#
# Validates the manifest and skill, runs the Knowledge builder, then
# assembles a skills-only plugin using an explicit allowlist. The plugin
# root is the archive root: plugin.json sits at the top level of the zip.
#
# Works when invoked from inside or outside the repository root, since all
# paths are resolved relative to this script's own location.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/../.." >/dev/null 2>&1 && pwd -P)"

CHATGPT_DIR="${REPO_ROOT}/chatgpt"
PLUGIN_SRC_DIR="${CHATGPT_DIR}/plugin"
KNOWLEDGE_DIR="${CHATGPT_DIR}/knowledge"

DIST_DIR="${REPO_ROOT}/dist"
BUILD_DIR="${REPO_ROOT}/.build/chatgpt-plugin-package"
PACKAGE_NAME="career-targeting-intelligence-chatgpt-plugin"
SKILL_NAME="career-targeting-intelligence"
OUTPUT_ZIP="${DIST_DIR}/${PACKAGE_NAME}.zip"

fail() {
  echo "error: $1" >&2
  exit 1
}

command -v zip >/dev/null 2>&1 || fail "the 'zip' command is required but was not found on PATH. Install zip and re-run this script."
command -v unzip >/dev/null 2>&1 || fail "the 'unzip' command is required but was not found on PATH. Install unzip and re-run this script."

[ -f "${PLUGIN_SRC_DIR}/plugin.json" ] || fail "required file not found: ${PLUGIN_SRC_DIR}/plugin.json"
command -v python3 >/dev/null 2>&1 || fail "python3 is required but was not found on PATH."
python3 -m json.tool "${PLUGIN_SRC_DIR}/plugin.json" >/dev/null || fail "plugin.json is not valid JSON: ${PLUGIN_SRC_DIR}/plugin.json"
[ -f "${PLUGIN_SRC_DIR}/SKILL.md" ] || fail "required file not found: ${PLUGIN_SRC_DIR}/SKILL.md"
[ -f "${CHATGPT_DIR}/capability-policy.md" ] || fail "required file not found: ${CHATGPT_DIR}/capability-policy.md"

# Build the reference bundles first — the archive embeds their output unchanged.
[ -x "${SCRIPT_DIR}/build-chatgpt-knowledge.sh" ] || fail "required build script not found or not executable: ${SCRIPT_DIR}/build-chatgpt-knowledge.sh"
"${SCRIPT_DIR}/build-chatgpt-knowledge.sh" >/dev/null

KNOWLEDGE_FILES=(01-product-and-terminology.md 02-candidate-and-search.md 03-company-intelligence.md 04-people-and-activity.md 05-ranking-and-exclusions.md 06-workflow-and-state.md 07-evidence-confidence-freshness.md 08-output-contracts.md 09-job-and-company-state.md)
for kf in "${KNOWLEDGE_FILES[@]}"; do
  [ -f "${KNOWLEDGE_DIR}/${kf}" ] || fail "Knowledge build did not produce: ${KNOWLEDGE_DIR}/${kf}"
done

# Only remove the dedicated build/staging directory — never an arbitrary path.
rm -rf -- "${BUILD_DIR}"
PACKAGE_ROOT="${BUILD_DIR}/${PACKAGE_NAME}"
SKILL_DIR="${PACKAGE_ROOT}/skills/${SKILL_NAME}"
mkdir -p -- "${SKILL_DIR}/references"

# Explicit allowlist copy — never a recursive repository copy.
cp -- "${PLUGIN_SRC_DIR}/plugin.json" "${PACKAGE_ROOT}/plugin.json"
# With RELEASE_VERSION set, write it into the packaged manifest's version field.
if [ -n "${RELEASE_VERSION:-}" ]; then
  [[ "${RELEASE_VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail "RELEASE_VERSION must be MAJOR.MINOR.PATCH, got: ${RELEASE_VERSION}"
  sed -E -i.bak "s/^(  \"version\": )\"[^\"]*\"/\1\"${RELEASE_VERSION}\"/" "${PACKAGE_ROOT}/plugin.json"
  rm -f -- "${PACKAGE_ROOT}/plugin.json.bak"
  grep -q "\"version\": \"${RELEASE_VERSION}\"" "${PACKAGE_ROOT}/plugin.json" || fail "could not set version in the packaged plugin.json"
fi
cp -- "${PLUGIN_SRC_DIR}/SKILL.md" "${SKILL_DIR}/SKILL.md"
cp -- "${CHATGPT_DIR}/capability-policy.md" "${SKILL_DIR}/references/capability-policy.md"
for kf in "${KNOWLEDGE_FILES[@]}"; do
  cp -- "${KNOWLEDGE_DIR}/${kf}" "${SKILL_DIR}/references/${kf}"
done

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
  echo "plugin.json"
  echo "skills/${SKILL_NAME}/SKILL.md"
  echo "skills/${SKILL_NAME}/references/capability-policy.md"
  for kf in "${KNOWLEDGE_FILES[@]}"; do echo "skills/${SKILL_NAME}/references/${kf}"; done
} | LC_ALL=C sort )"
ACTUAL="$(unzip -Z1 "${OUTPUT_ZIP}" | LC_ALL=C sort)"
[ "${EXPECTED}" = "${ACTUAL}" ] || fail "archive contents do not match the allowlist. Expected:
${EXPECTED}
Actual:
${ACTUAL}"

echo "Packaged ChatGPT Plugin: ${OUTPUT_ZIP}"
echo ""
echo "Packaged files:"
echo "${ACTUAL}"
