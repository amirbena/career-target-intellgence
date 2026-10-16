# Sharing and Publishing

Supported deployment stages for the Career Targeting Intelligence ChatGPT
Plugin, in order.

## Private Install

Use for initial testing. Build the archive with
`scripts/package/package-chatgpt-plugin.sh` (or `.ps1`), install it privately, and
work through [`testing-guide.md`](testing-guide.md). Nothing here should be
visible to anyone else yet.

## Public Directory Submission

An optional later step, not a required one. Submission is through the
OpenAI Platform dashboard (Plugins → Upload new or existing plugin) by an
organization owner or a member with Apps Management Write, under a
verified developer identity. Before submitting, confirm:

- `plugin.json` stays within the documented manifest limits in
  [`plugin-config.md`](plugin-config.md); check them by hand, as the
  packagers only check that it is valid JSON.
- The listing text matches [`plugin-config.md`](plugin-config.md).
- The archive contains only the allowlisted files — no personal records,
  no Golden Journey content (see [`package-manifest.md`](package-manifest.md)).
- There is no misleading affiliation with any company, job board, or
  platform.
- There is no unsupported guarantee of job outcomes, guaranteed current
  data, or guaranteed automation.
- No apps, hooks, or MCP servers are declared — submission with apps or
  hooks is not currently accepted, and this package defines none.
- [`testing-guide.md`](testing-guide.md) passes in full.
- The required skill scans complete successfully, and the primary plugin
  icon required by the dashboard has been supplied (this repository does
  not ship one; see the brief in [`plugin-config.md`](plugin-config.md)).

## What this guide does not promise

Submission requirements, review rules, and available sharing modes are
set by OpenAI and change over time. This guide records what was verified
against OpenAI's plugin documentation when the package was created; check
the current submission documentation before each submission.
