# External Self-Install — Career Targeting Intelligence

This path is for people **outside the creator's Claude organization** who
want to run the Career Targeting Intelligence Project for themselves. It
packages the same canonical Skill, methodology, and Project Instructions
already defined in this repository into a portable kit anyone can install
into their own, separate Claude Project.

## What this kit is not

- It is not access to the creator's own Claude Project. It does not grant
  membership, sharing, or visibility into any Project the creator runs.
- It does not transfer any chats, conversation history, or personal
  candidate data — the creator's or anyone else's. The kit ships
  methodology and empty configuration only.
- It does not perform a one-click Project import. There is no automated
  installer that creates or configures a Claude Project on the user's
  behalf — Claude Projects do not expose that capability, and this kit
  does not claim otherwise.
- Skill installation and Project configuration are two separate steps: you
  install the Skill package once, and separately create and configure your
  own Project (instructions, Knowledge). One does not imply or perform the
  other.

## What you get

- The packaged Skill (`career-targeting-intelligence.skill.zip`), unchanged
  from [`claude/skill/`](../skill/).
- The same compact Project Instructions used throughout this repository,
  copied byte-for-byte at packaging time — never a separately maintained
  fork.
- The same shared-methodology Knowledge files recommended in
  [`claude/knowledge-manifest.md`](../knowledge-manifest.md), restricted to
  a fixed allowlist.
- Documentation to install, verify, and use the product safely.

## Installation flow

```text
Install Skill
  → Create private Claude Project
  → Paste supplied Project Instructions
  → Upload approved Knowledge files
  → Optionally add private candidate files
  → Run verification prompts
  → Begin using the product
```

Each step is under your control, in your own Claude account. See
[`installation-checklist.md`](installation-checklist.md) for the concrete
steps, and [`verification-guide.md`](verification-guide.md) to confirm the
install worked before relying on it.

## Related documents

- [`installation-checklist.md`](installation-checklist.md)
- [`knowledge-files.md`](knowledge-files.md)
- [`conversation-starters.md`](conversation-starters.md)
- [`verification-guide.md`](verification-guide.md)
- [`privacy-guide.md`](privacy-guide.md)
- [`package-manifest.md`](package-manifest.md)
- [`../project-setup.md`](../project-setup.md) — the general setup guide this kit packages for external distribution
