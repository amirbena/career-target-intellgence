# Packaging the Claude Skill

This document explains how to build the installable Career Targeting
Intelligence Claude Skill ZIP from `skills/career-targeting-intelligence/`. For what the package
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
- Validate that `skills/career-targeting-intelligence/SKILL.md`, `skills/career-targeting-intelligence/references/`, and
  `skills/career-targeting-intelligence/templates/` exist before doing any packaging work, and fail
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

## Packaging the External Self-Install Kit

A second, separate archive — the External Kit — bundles the Skill ZIP
above together with Project Instructions, a fixed Knowledge allowlist, and
installation documentation, for distribution to users outside the
creator's Claude organization. See
[`external-install/package-manifest.md`](external-install/package-manifest.md)
for its full structure.

### Commands

```bash
./scripts/package-claude-external-kit.sh
```

```powershell
.\scripts\package-claude-external-kit.ps1
```

Both scripts build the Skill ZIP first (by invoking
`package-claude-skill.sh` / `.ps1`), then assemble
`dist/career-targeting-intelligence-claude-kit.zip` around it, using the
same conventions as the Skill packager: an explicit allowlist, a dedicated
staging directory, byte-for-byte copies of the canonical compact
Instructions and Knowledge sources, and a single top-level package
directory.

### The two archives are distinct

- `dist/career-targeting-intelligence.skill.zip` — the Skill execution
  package. Install this as a Claude Skill.
- `dist/career-targeting-intelligence-claude-kit.zip` — the distribution
  package for external self-install. It contains the Skill ZIP above
  (embedded, unchanged) plus Project Instructions, Knowledge, and setup
  documentation. Distribute this to external users; do not distribute the
  Skill ZIP alone and expect it to include Project setup, since the Skill
  ZIP intentionally contains only Skill source.

## Packaging the Claude Plugin

A third archive, `dist/career-targeting-intelligence-claude-plugin.zip`,
distributes the same Skill as a Claude Plugin, which installs through
claude.ai **Upload plugin** and `claude --plugin-dir`.

```bash
./scripts/package-claude-plugin.sh
```

```powershell
.\scripts\package-claude-plugin.ps1
```

### Layout decision

Checked against `claude plugin validate` (Claude Code CLI) when this was
added; re-check Claude's current plugin documentation before changing it.

- The manifest lives at `.claude-plugin/plugin.json` at the archive root.
  Only `name` is required; this package sets `name`, `version`,
  `description`, `author`, `repository`, and `keywords`. The source is
  [`plugin/plugin.json`](plugin/plugin.json).
- Skills live at `skills/<skill-name>/SKILL.md` at the archive root (not
  inside `.claude-plugin/`). The skill folder holds the same `SKILL.md`,
  `references/`, and `templates/` as the Skill ZIP, copied from
  `skills/career-targeting-intelligence/` with the same allowlist — the Skill is not forked.
- Skills-only: no hooks, MCP servers, commands, or agents.
- The plugin and Skill name match (`career-targeting-intelligence`), so the
  Skill is invoked as `/career-targeting-intelligence:career-targeting-intelligence`
  or by description-based activation.

### Versions

Set `RELEASE_VERSION` to write that version into `plugin.json` and the
packaged `SKILL.md` (`metadata.version`); this applies to all four packagers.
The GitHub Release tag is the single source of truth.
`scripts/verify-archive-versions.sh` / `.ps1` check every archive against
the tag. See [../policies/packaging-rules.md](../policies/packaging-rules.md).
