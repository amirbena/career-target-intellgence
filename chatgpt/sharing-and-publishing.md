# Sharing and Publishing

Supported deployment stages for the Career Targeting Intelligence Custom
GPT, in order.

## Private Draft

Use for initial configuration and testing. Keep the GPT private while you
work through [`testing-guide.md`](testing-guide.md) — nothing here should
be visible to anyone else yet.

## Shared by Link or Workspace

Use once the smoke tests pass. Share with specific people, or within your
workspace, subject to whatever sharing options your account and workspace
actually expose — not every account has every sharing mode available.

## Public Publishing

An optional later step, not a required one. Before publishing more
broadly, confirm:

- The name and description are accurate and match
  [`builder-config.md`](builder-config.md).
- No private Knowledge files were uploaded — only the eight generated
  bundles from `knowledge/`.
- There is no misleading affiliation with any company, job board, or
  platform.
- There is no unsupported guarantee of job outcomes, guaranteed current
  data, or guaranteed automation.
- No external Actions or Apps are configured.
- [`testing-guide.md`](testing-guide.md) passes in full.
- Privacy boundaries are visible to a new user — the description and
  Instructions should make clear what the GPT does and does not do (see
  the explicit non-actions in [`instructions.md`](instructions.md)).
- Any Builder Profile requirements the platform itself presents (for
  example, a verified builder name) are completed.

## What this guide does not promise

Not every account or workspace supports every sharing mode described
above — availability depends on your platform plan and configuration.
This guide documents the stages in the order they're meant to be used; it
does not guarantee any specific stage is available to you.
