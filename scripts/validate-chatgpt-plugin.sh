#!/usr/bin/env bash
#
# Validates the ChatGPT Plugin sources against the documented OpenAI plugin
# submission limits: chatgpt/plugin/plugin.json (manifest) and
# chatgpt/plugin/SKILL.md (skill frontmatter).
#
# Character counts use Python's len() on the decoded UTF-8 text (character
# count, not byte count).
#
# This is a skills-only plugin: the manifest must not declare apps, hooks,
# or MCP servers, which are out of scope for this package.
#
# Works when invoked from inside or outside the repository root, since all
# paths are resolved relative to this script's own location.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd -P)"

MANIFEST_FILE="${REPO_ROOT}/chatgpt/plugin/plugin.json"
SKILL_FILE="${REPO_ROOT}/chatgpt/plugin/SKILL.md"

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

def text_field(obj, key, label, limit, required=True):
    value = obj.get(key)
    if value is None:
        check(not required, f"{label} is required")
        return None
    check(isinstance(value, str) and value.strip() != "", f"{label} must be a non-empty string")
    if isinstance(value, str):
        check(len(value) <= limit, f"{label} is {len(value)} characters, over the {limit}-character limit")
    return value

with open(manifest_path, encoding="utf-8") as f:
    try:
        manifest = json.load(f)
    except json.JSONDecodeError as e:
        print(f"error: plugin.json is not valid JSON: {e}", file=sys.stderr)
        sys.exit(1)

name = text_field(manifest, "name", "name", 64)
if isinstance(name, str):
    check(re.fullmatch(r"[a-z0-9]+(-[a-z0-9]+)*", name) is not None,
          "name must use lowercase letters, numbers, and single hyphens")
version = manifest.get("version")
check(isinstance(version, str) and re.fullmatch(r"\d+\.\d+\.\d+", version) is not None,
      "version must be an explicit semantic version (MAJOR.MINOR.PATCH)")
text_field(manifest, "description", "description", 4000)

author = manifest.get("author", {})
if author:
    text_field(author, "name", "author.name", 120)

check("mcpServers" not in manifest, "mcpServers must not be declared (skills-only plugin)")
openai = manifest.get("extensions", {}).get("com.openai", {})
check("apps" not in openai, "extensions.com.openai.apps must not be declared (out of scope)")
check("hooks" not in openai, "extensions.com.openai.hooks must not be declared (out of scope)")

interface = openai.get("interface")
check(isinstance(interface, dict), "extensions.com.openai.interface is required")
if isinstance(interface, dict):
    text_field(interface, "displayName", "interface.displayName", 30)
    text_field(interface, "shortDescription", "interface.shortDescription", 30)
    text_field(interface, "longDescription", "interface.longDescription", 4000)
    text_field(interface, "developerName", "interface.developerName", 80)
    prompts = interface.get("defaultPrompt", [])
    check(isinstance(prompts, list) and len(prompts) <= 3, "interface.defaultPrompt allows at most 3 prompts")
    if isinstance(prompts, list):
        check(len(set(prompts)) == len(prompts), "interface.defaultPrompt entries must be unique")
        for i, p in enumerate(prompts):
            check(isinstance(p, str) and len(p) <= 128, f"interface.defaultPrompt[{i}] must be a string of at most 128 characters")
            check(isinstance(p, str) and "@" not in p, f"interface.defaultPrompt[{i}] must not include app @mentions")

with open(skill_path, encoding="utf-8") as f:
    skill = f.read()
m = re.match(r"---\n(.*?)\n---\n", skill, re.S)
check(m is not None, "SKILL.md must begin with YAML frontmatter")
if m:
    fm = m.group(1)
    nm = re.search(r"^name:\s*(\S.*)$", fm, re.M)
    ds = re.search(r"^description:\s*(\S.*)$", fm, re.M)
    check(nm is not None, "SKILL.md frontmatter requires name")
    check(ds is not None, "SKILL.md frontmatter requires description")
    if nm and name:
        check(nm.group(1).strip() == name, "SKILL.md name must match the plugin manifest name")

if errors:
    for e in errors:
        print(f"error: {e}", file=sys.stderr)
    sys.exit(1)

print(f"plugin.json: valid ({len(manifest['description'])}-character description)")
print(f"SKILL.md: valid frontmatter ({len(skill)} characters)")
PY

echo "OK: ChatGPT Plugin manifest and skill are within the documented limits."
