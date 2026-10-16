#!/usr/bin/env bash
#
# Validates the Claude Plugin manifest (claude/plugin/plugin.json) and the
# marketplace manifest (.claude-plugin/marketplace.json) as repository
# structure: JSON syntax, required fields, source/skill paths, and version
# consistency, plus the Skill the plugin wraps
# (skills/career-targeting-intelligence/SKILL.md). When a built plugin
# directory is passed as $1, also checks its layout. It does not invoke the
# `claude` CLI and does not prove Claude can install or update the plugin;
# that is a manual check (docs/installation.md#manual-verification).
#
# Works when invoked from inside or outside the repository root, since all
# paths are resolved relative to this script's own location.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/../.." >/dev/null 2>&1 && pwd -P)"

MANIFEST_FILE="${REPO_ROOT}/claude/plugin/plugin.json"
MARKETPLACE_FILE="${REPO_ROOT}/.claude-plugin/marketplace.json"
SKILL_FILE="${REPO_ROOT}/skills/career-targeting-intelligence/SKILL.md"
BUILT_PLUGIN_DIR="${1:-}"

fail() {
  echo "error: $1" >&2
  exit 1
}

command -v python3 >/dev/null 2>&1 || fail "python3 is required but was not found on PATH."
[ -f "${MANIFEST_FILE}" ] || fail "plugin manifest not found: ${MANIFEST_FILE}"
[ -f "${SKILL_FILE}" ] || fail "skill file not found: ${SKILL_FILE}"

python3 - "${MANIFEST_FILE}" "${SKILL_FILE}" "${MARKETPLACE_FILE}" <<'PY'
import json
import os
import re
import sys

manifest_path, skill_path, marketplace_path = sys.argv[1], sys.argv[2], sys.argv[3]
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
# Marketplace manifest: syntax, required fields, paths, version consistency.
# release.sh keeps the marketplace entry version equal to plugin.json.
repo_root = os.path.dirname(os.path.dirname(os.path.abspath(marketplace_path)))
try:
    with open(marketplace_path, encoding="utf-8") as f:
        market = json.load(f)
except (OSError, json.JSONDecodeError) as e:
    market = None
    errors.append(f"marketplace.json unreadable or invalid JSON: {e}")
if market is not None:
    check(isinstance(market.get("name"), str) and re.fullmatch(r"[a-z0-9]+(-[a-z0-9]+)*", market.get("name") or ""), "marketplace name must be kebab-case")
    check(isinstance((market.get("owner") or {}).get("name"), str), "marketplace owner.name is required")
    plugins = market.get("plugins")
    check(isinstance(plugins, list) and plugins, "marketplace plugins must be a non-empty list")
    entry = None
    for p in plugins if isinstance(plugins, list) else []:
        if p.get("name") == name:
            entry = p
        check(isinstance(p.get("source"), str), f"plugin entry {p.get('name')!r} needs a string source")
        if isinstance(p.get("source"), str):
            check(os.path.isdir(os.path.normpath(os.path.join(repo_root, p["source"]))), f"source path not found: {p['source']}")
        for sk in p.get("skills", []):
            check(os.path.isfile(os.path.join(repo_root, sk, "SKILL.md")), f"skills path has no SKILL.md: {sk}")
    check(entry is not None, "marketplace.json has no entry matching the plugin name")
    if entry is not None:
        check(entry.get("version") == version, "marketplace.json plugin version must equal plugin.json version")
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
  [ -f "${BUILT_PLUGIN_DIR}/.claude-plugin/plugin.json" ] || fail "built plugin is missing .claude-plugin/plugin.json: ${BUILT_PLUGIN_DIR}"
  [ -f "${BUILT_PLUGIN_DIR}/skills/career-targeting-intelligence/SKILL.md" ] || fail "built plugin is missing skills/career-targeting-intelligence/SKILL.md: ${BUILT_PLUGIN_DIR}"
  python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "${BUILT_PLUGIN_DIR}/.claude-plugin/plugin.json" || fail "built plugin.json is not valid JSON"
fi

echo "OK: Claude Plugin manifest and skill are valid."
