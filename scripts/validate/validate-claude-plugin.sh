#!/usr/bin/env bash
#
# Validates the Claude Plugin manifest (claude/plugin/plugin.json) against the
# documented Claude Plugin requirements and the Skill it wraps
# (skills/career-targeting-intelligence/SKILL.md). When the `claude` CLI is available and a built
# plugin directory is passed as $1, also runs `claude plugin validate`.
#
# Works when invoked from inside or outside the repository root, since all
# paths are resolved relative to this script's own location.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/../.." >/dev/null 2>&1 && pwd -P)"

MANIFEST_FILE="${REPO_ROOT}/claude/plugin/plugin.json"
SKILL_FILE="${REPO_ROOT}/skills/career-targeting-intelligence/SKILL.md"
BUILT_PLUGIN_DIR="${1:-}"

fail() {
  echo "error: $1" >&2
  exit 1
}

command -v python3 >/dev/null 2>&1 || fail "python3 is required but was not found on PATH."
[ -f "${MANIFEST_FILE}" ] || fail "plugin manifest not found: ${MANIFEST_FILE}"
[ -f "${SKILL_FILE}" ] || fail "skill file not found: ${SKILL_FILE}"

python3 - "${MANIFEST_FILE}" "${SKILL_FILE}" <<'PY'
import json
import re
import sys

manifest_path, skill_path = sys.argv[1], sys.argv[2]
errors = []

def check(cond, msg):
    if not cond:
        errors.append(msg)

try:
    with open(manifest_path, encoding="utf-8") as f:
        manifest = json.load(f)
except json.JSONDecodeError as e:
    print(f"error: plugin.json is not valid JSON: {e}", file=sys.stderr)
    sys.exit(1)

name = manifest.get("name")
check(isinstance(name, str) and re.fullmatch(r"[a-z0-9]+(-[a-z0-9]+)*", name or ""), "name must be kebab-case")
version = manifest.get("version")
check(isinstance(version, str) and re.fullmatch(r"\d+\.\d+\.\d+", version or ""), "version must be MAJOR.MINOR.PATCH")
desc = manifest.get("description")
check(isinstance(desc, str) and desc.strip() != "", "description must be a non-empty string")
for forbidden in ("hooks", "mcpServers", "commands", "agents"):
    check(forbidden not in manifest, f"manifest must not declare '{forbidden}' (skills-only plugin)")

with open(skill_path, encoding="utf-8") as f:
    skill = f.read()
m = re.match(r"^---\n(.*?)\n---\n", skill, re.S)
check(m is not None, "SKILL.md must start with YAML frontmatter")
if m:
    nm = re.search(r"^name:\s*(\S.*)$", m.group(1), re.M)
    check(nm is not None and nm.group(1).strip() == name, "SKILL.md name must match the plugin manifest name")

if errors:
    for e in errors:
        print(f"error: {e}", file=sys.stderr)
    sys.exit(1)
print("plugin.json: valid")
PY

if [ -n "${BUILT_PLUGIN_DIR}" ]; then
  if command -v claude >/dev/null 2>&1; then
    claude plugin validate "${BUILT_PLUGIN_DIR}" || fail "'claude plugin validate' failed for ${BUILT_PLUGIN_DIR}"
  else
    echo "note: 'claude' CLI not found; skipping 'claude plugin validate'." >&2
  fi
fi

echo "OK: Claude Plugin manifest and skill are valid."
