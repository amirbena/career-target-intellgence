# Packaging the Claude Skill

This document explains how to build the installable Career Targeting
Intelligence Claude Skill ZIP from `claude/skill/`. For what the package
contains and why, see [`skill-manifest.md`](skill-manifest.md).

## Commands

### macOS / Linux

```bash
./scripts/package-claude-skill.sh
```

### Windows PowerShell

```powershell
.\scripts\package-claude-skill.ps1
```

Both scripts:

- Resolve all paths relative to their own location, so they work whether
  invoked from the repository root, from `scripts/`, or from any other
  working directory, including one outside the repository.
- Validate that `claude/skill/SKILL.md`, `claude/skill/references/`, and
  `claude/skill/templates/` exist before doing any packaging work, and fail
  with an actionable message if any are missing.
- Copy only the explicit package allowlist — `SKILL.md`, `references/`,
  `templates/` — into a dedicated staging directory. Neither script performs
  a recursive copy of the repository followed by exclusions; both start
  from an empty staging directory and add only allowed content.
- Wrap the staged content in a single top-level directory named
  `career-targeting-intelligence/`.
- Strip platform artifacts (`.DS_Store`, `Thumbs.db`, `__MACOSX/`) if
  encountered in the source tree.
- Write the archive to `dist/career-targeting-intelligence.skill.zip`,
  replacing any existing file at that path deterministically.
- Print the final package path and the packaged file list on success.
- Exit with a non-zero status and an actionable error message on failure
  (a missing required source file or directory, or a missing required
  system command).

## Expected output

```
dist/career-targeting-intelligence.skill.zip
```

Containing exactly one top-level directory:

```
career-targeting-intelligence/
  SKILL.md
  references/
    candidate-intelligence.md
    company-intelligence.md
    people-intelligence.md
    activity-verification.md
    ranking-and-exclusions.md
    workflow-routing.md
    output-generation.md
    quality-and-trust.md
  templates/
    candidate-profile.md
    search-criteria.md
    company-map.md
    excluded-companies.md
    people-map.md
    activity-verification.md
    outreach-queue.md
    research-state.md
```

## Cross-platform parity

The macOS/Linux script and the Windows script are logically equivalent —
they share:

- The output package filename (`career-targeting-intelligence.skill.zip`).
- The top-level directory name inside the archive
  (`career-targeting-intelligence/`).
- The explicit package allowlist (`SKILL.md`, `references/`, `templates/`).
- The required-source validation checks.
- The exclusion of platform artifacts.
- Their staging behavior (a dedicated, cleaned staging directory; never an
  arbitrary path deletion).
- The final logical file list inside the archive.

**ZIP byte hashes may legitimately differ between the two scripts and
between runs on different operating systems**, because `zip` on macOS/Linux
and .NET's compression APIs on Windows write different archive metadata
(timestamps, permission bits, host attributes). This is expected and does
not indicate a packaging bug. What must match — and what the validation
procedure below checks — is the **normalized internal path list** and the
**contents of each packaged file**. Do not treat the two scripts as
producing byte-for-byte identical archives; they are not required to.

## Validating a package

After running either script:

1. Unzip `dist/career-targeting-intelligence.skill.zip` to a temporary
   location.
2. Confirm exactly one top-level directory exists:
   `career-targeting-intelligence/`.
3. Confirm the internal file list matches the expected output above exactly
   — no extra files, no missing files.
4. Confirm no forbidden files (see [`skill-manifest.md`](skill-manifest.md#intentionally-excluded-files))
   are present anywhere in the archive.
5. Spot-check that `SKILL.md` has valid frontmatter and that every file a
   reference links to under `references/` and `templates/` actually exists
   in the package.
6. Run the packaging command a second time and confirm the archive does not
   accumulate stale files from a previous run (the staging directory is
   fully rebuilt each time, not appended to).
