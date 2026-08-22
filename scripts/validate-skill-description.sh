#!/usr/bin/env bash
#
# Validates that the `description:` field in claude/skill/SKILL.md's YAML
# frontmatter — the canonical source of the packaged Claude Skill's
# activation-triggering description — stays within the platform's
# character limit.
#
# Character count uses Python's len() on the YAML-parsed (folded) string
# value of the `description` field, not a raw grep/line count, since YAML
# block scalars fold line breaks and indentation into the final string
# Claude actually reads.
#
# Works when invoked from inside or outside the repository root, since all
# paths are resolved relative to this script's own location.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd -P)"

SKILL_FILE="${REPO_ROOT}/claude/skill/SKILL.md"

HARD_LIMIT=2400
WARN_THRESHOLD=2200

fail() {
  echo "error: $1" >&2
  exit 1
}

command -v python3 >/dev/null 2>&1 || fail "python3 is required but was not found on PATH."

[ -f "${SKILL_FILE}" ] || fail "Skill source file not found: ${SKILL_FILE}"

CHAR_COUNT="$(python3 -c "
import re
import sys

with open(sys.argv[1], encoding='utf-8') as f:
    text = f.read()

match = re.match(r'^---\n(.*?\n)---\n', text, re.DOTALL)
if not match:
    print('error: could not locate YAML frontmatter block', file=sys.stderr)
    sys.exit(1)

try:
    import yaml
    data = yaml.safe_load(match.group(1))
except ImportError:
    print('error: PyYAML is required to parse SKILL.md frontmatter (pip install pyyaml)', file=sys.stderr)
    sys.exit(1)

if not isinstance(data, dict) or 'description' not in data:
    print('error: no description field found in SKILL.md frontmatter', file=sys.stderr)
    sys.exit(1)

description = data['description']
print(len(description))
" "${SKILL_FILE}")"

echo "claude/skill/SKILL.md description: ${CHAR_COUNT} characters (hard limit ${HARD_LIMIT}, warn threshold ${WARN_THRESHOLD})"

if [ "${CHAR_COUNT}" -ge "${HARD_LIMIT}" ]; then
  fail "claude/skill/SKILL.md description is ${CHAR_COUNT} characters, at or over the ${HARD_LIMIT}-character Claude Skill description hard limit. Shorten it before packaging."
fi

if [ "${CHAR_COUNT}" -gt "${WARN_THRESHOLD}" ]; then
  echo "warning: claude/skill/SKILL.md description is ${CHAR_COUNT} characters, over the ${WARN_THRESHOLD}-character safety margin (hard limit ${HARD_LIMIT})." >&2
fi

echo "OK: claude/skill/SKILL.md description is within the Claude Skill description limit."
