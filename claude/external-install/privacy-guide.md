# Privacy Guide

## What the kit contains

The kit contains methodology, instructions, and empty configuration assets
only:

- The packaged Skill (methodology and progressive references).
- Compact Project Instructions (routing and behavior rules).
- A fixed set of shared-methodology Knowledge files.
- Documentation (this guide, the installation checklist, the verification
  guide, and the rest).

## What the kit does not contain

- No creator chats or conversation history.
- No real resumes or candidate profiles.
- No real company lists, target-company maps, or exclusion decisions.
- No real recruiter, hiring-manager, or other person records.
- No outreach history or queue entries.

Every example anywhere in this repository (including the Tova Golden
Journey) is synthetic and is not included in this kit regardless.

## What you control

Once installed, you — the external user — control:

- Your own Project's existence, name, and membership.
- Its sharing settings (private, shared within your own organization, or
  otherwise).
- Which files you upload to it, including any private workspace files
  (your resume, your own research outputs).
- Whether and when you delete your own Project or its contents.

## Shared Knowledge visibility

If you share your Project with other people, the Knowledge you've
uploaded to it — including anything beyond the kit's own allowlist that
you've added yourself — becomes visible to everyone with access to that
Project. Keep personal candidate data out of any Project you intend to
share, or remove it before sharing.

## The Skill is not secure storage

The installed Skill defines methodology and output shapes. It is not a
database, and it does not provide access controls, encryption, or
retention guarantees of its own. Whatever persistence, privacy, and
retention behavior exists is entirely a property of the underlying Claude
platform and your own Project configuration — this kit does not add or
change any of that.

## Connectors introduce separate boundaries

If you connect other tools or data sources (calendars, file storage,
spreadsheets, or similar) to your Project, each connector has its own
access model and data-handling policy, separate from this kit and from
Claude itself. Review a connector's own privacy terms before connecting
it, especially before letting it read or write anything containing real
candidate data.

## Install only trusted Skill packages

Only install a `career-targeting-intelligence.skill.zip` (or an external
kit containing one) that you obtained from a source you trust — ideally
this repository directly, or a build you produced yourself with
[`scripts/package-claude-skill.sh`](../../scripts/package-claude-skill.sh)
or
[`scripts/package-claude-external-kit.sh`](../../scripts/package-claude-external-kit.sh).
A Skill package determines how Claude behaves inside your Project; treat
installing one with the same care you'd give any other executable
methodology you didn't author yourself.
