#!/usr/bin/env bash
#
# Validates that chatgpt/instructions.md — the exact content pasted
# unedited into the Custom GPT's Instructions field — stays within the
# platform's character limit.
#
# Character count uses Python's len() on the decoded UTF-8 text (character
# count, not byte count, not word count), matching what ChatGPT itself
# counts against the Instructions field limit.
#
# Works when invoked from inside or outside the repository root, since all
# paths are resolved relative to this script's own location.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd -P)"

INSTRUCTIONS_FILE="${REPO_ROOT}/chatgpt/instructions.md"

HARD_LIMIT=8000
WARN_THRESHOLD=7600

fail() {
  echo "error: $1" >&2
  exit 1
}

command -v python3 >/dev/null 2>&1 || fail "python3 is required but was not found on PATH."

[ -f "${INSTRUCTIONS_FILE}" ] || fail "instructions file not found: ${INSTRUCTIONS_FILE}"

CHAR_COUNT="$(python3 -c "
import sys
with open(sys.argv[1], encoding='utf-8') as f:
    text = f.read()
print(len(text))
" "${INSTRUCTIONS_FILE}")"

echo "chatgpt/instructions.md: ${CHAR_COUNT} characters (hard limit ${HARD_LIMIT}, warn threshold ${WARN_THRESHOLD})"

if [ "${CHAR_COUNT}" -ge "${HARD_LIMIT}" ]; then
  fail "chatgpt/instructions.md is ${CHAR_COUNT} characters, at or over the ${HARD_LIMIT}-character Custom GPT Instructions field hard limit. Shorten it before packaging."
fi

if [ "${CHAR_COUNT}" -gt "${WARN_THRESHOLD}" ]; then
  echo "warning: chatgpt/instructions.md is ${CHAR_COUNT} characters, over the ${WARN_THRESHOLD}-character safety margin (hard limit ${HARD_LIMIT})." >&2
fi

echo "OK: chatgpt/instructions.md is within the Custom GPT Instructions field limit."
