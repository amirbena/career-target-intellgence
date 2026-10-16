#!/usr/bin/env bash
#
# Verifies that the version embedded in every published archive in dist/
# equals the given release version (the GitHub Release tag without the "v").
# Exits non-zero on the first mismatch so a release cannot ship inconsistent
# archives.
#
# Usage: scripts/validate/verify-archive-versions.sh <version> [dist-dir [archive-name...]]
# With no archive names, all four published archives are checked.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/../.." >/dev/null 2>&1 && pwd -P)"

VERSION="${1:-}"
DIST_DIR="${2:-${REPO_ROOT}/dist}"
[ -n "${VERSION}" ] || { echo "usage: $0 <version> [dist-dir [archive-name...]]" >&2; exit 1; }
shift $(( $# < 2 ? $# : 2 ))
VERSION="${VERSION#v}"

command -v python3 >/dev/null 2>&1 || { echo "error: python3 is required" >&2; exit 1; }

python3 - "${VERSION}" "${DIST_DIR}" "$@" <<'PY'
import io, json, os, re, sys, zipfile

version, dist = sys.argv[1], sys.argv[2]
only = set(sys.argv[3:])
def want(name):
    return not only or name in only
errors = []

def skill_version(data):
    m = re.match(r"^---\n(.*?)\n---\n", data, re.S)
    v = re.search(r"^metadata:\n(?:[ \t]+.*\n)*?[ \t]+version:\s*(\S+)", (m.group(1) + "\n") if m else "", re.M)
    return v.group(1) if v else None

def check(label, found):
    if found != version:
        errors.append(f"{label}: found {found!r}, expected {version!r}")
    else:
        print(f"ok: {label} = {found}")

def open_zip(name):
    path = os.path.join(dist, name)
    if not os.path.isfile(path):
        errors.append(f"{name}: archive not found in {dist}")
        return None
    return zipfile.ZipFile(path)

z = open_zip("career-targeting-intelligence.skill.zip") if want("career-targeting-intelligence.skill.zip") else None
if z:
    check("skill zip SKILL.md", skill_version(z.read("career-targeting-intelligence/SKILL.md").decode()))

z = open_zip("career-targeting-intelligence-claude-kit.zip") if want("career-targeting-intelligence-claude-kit.zip") else None
if z:
    root = "career-targeting-intelligence-claude-kit/"
    check("claude kit VERSION", z.read(root + "VERSION").decode().strip())
    inner = zipfile.ZipFile(io.BytesIO(z.read(root + "skill/career-targeting-intelligence.skill.zip")))
    check("claude kit embedded skill SKILL.md", skill_version(inner.read("career-targeting-intelligence/SKILL.md").decode()))

z = open_zip("career-targeting-intelligence-claude-plugin.zip") if want("career-targeting-intelligence-claude-plugin.zip") else None
if z:
    check("claude plugin manifest", json.loads(z.read(".claude-plugin/plugin.json"))["version"])
    check("claude plugin SKILL.md", skill_version(z.read("skills/career-targeting-intelligence/SKILL.md").decode()))

z = open_zip("career-targeting-intelligence-chatgpt-plugin.zip") if want("career-targeting-intelligence-chatgpt-plugin.zip") else None
if z:
    check("chatgpt plugin manifest", json.loads(z.read("plugin.json"))["version"])

if errors:
    for e in errors:
        print(f"error: {e}", file=sys.stderr)
    sys.exit(1)
PY
