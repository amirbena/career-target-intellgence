#!/usr/bin/env bash
#
# Packages the Career Targeting Intelligence ChatGPT Custom GPT deployment
# archive into dist/career-targeting-intelligence-chatgpt.zip.
#
# Runs the Knowledge builder first, then assembles the archive around its
# output plus the deployment documentation, using an explicit allowlist.
#
# Works when invoked from inside or outside the repository root, since all
# paths are resolved relative to this script's own location.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd -P)"

CHATGPT_DIR="${REPO_ROOT}/chatgpt"
KNOWLEDGE_DIR="${CHATGPT_DIR}/knowledge"

DIST_DIR="${REPO_ROOT}/dist"
BUILD_DIR="${REPO_ROOT}/.build/chatgpt-gpt-package"
PACKAGE_NAME="career-targeting-intelligence-chatgpt"
OUTPUT_ZIP="${DIST_DIR}/${PACKAGE_NAME}.zip"

fail() {
  echo "error: $1" >&2
  exit 1
}

command -v zip >/dev/null 2>&1 || fail "the 'zip' command is required but was not found on PATH. Install zip and re-run this script."

# Required deployment documentation.
DOCS=(README.md instructions.md builder-config.md conversation-starters.md builder-setup.md capability-policy.md testing-guide.md sharing-and-publishing.md knowledge-manifest.md)
for doc in "${DOCS[@]}"; do
  [ -f "${CHATGPT_DIR}/${doc}" ] || fail "required file not found: ${CHATGPT_DIR}/${doc}"
done

# Build the Knowledge bundles first — the archive embeds their output unchanged.
[ -x "${SCRIPT_DIR}/build-chatgpt-knowledge.sh" ] || fail "required build script not found or not executable: ${SCRIPT_DIR}/build-chatgpt-knowledge.sh"
"${SCRIPT_DIR}/build-chatgpt-knowledge.sh" >/dev/null

KNOWLEDGE_FILES=(01-product-and-terminology.md 02-candidate-and-search.md 03-company-intelligence.md 04-people-and-activity.md 05-ranking-and-exclusions.md 06-workflow-and-state.md 07-evidence-confidence-freshness.md 08-output-contracts.md)
for kf in "${KNOWLEDGE_FILES[@]}"; do
  [ -f "${KNOWLEDGE_DIR}/${kf}" ] || fail "Knowledge build did not produce: ${KNOWLEDGE_DIR}/${kf}"
done

# Only remove the dedicated build/staging directory — never an arbitrary path.
rm -rf -- "${BUILD_DIR}"
mkdir -p -- "${BUILD_DIR}"

PACKAGE_ROOT="${BUILD_DIR}/${PACKAGE_NAME}"
mkdir -p -- "${PACKAGE_ROOT}/knowledge"

# Explicit allowlist copy — never a recursive repository copy.
for doc in "${DOCS[@]}"; do
  cp -- "${CHATGPT_DIR}/${doc}" "${PACKAGE_ROOT}/${doc}"
done
for kf in "${KNOWLEDGE_FILES[@]}"; do
  cp -- "${KNOWLEDGE_DIR}/${kf}" "${PACKAGE_ROOT}/knowledge/${kf}"
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

echo "Packaged ChatGPT Custom GPT: ${OUTPUT_ZIP}"
echo ""
echo "Packaged files:"
unzip -Z1 "${OUTPUT_ZIP}" | sort
