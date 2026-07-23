# Project Setup Guide

How to stand up the Career Targeting Intelligence Claude Project from the
files in this repository.

## Steps

1. Create a Claude Project.
2. Install the packaged Skill — build
   `dist/career-targeting-intelligence.skill.zip` (see
   [`packaging.md`](packaging.md)) and install it as the Project's Skill.
3. Paste the compact Project Instructions from
   [`project-instructions.compact.md`](project-instructions.compact.md)
   into the Project's instructions field. (See
   [`project-instructions.md`](project-instructions.md) for the full,
   explained version this is condensed from.)
4. Add the recommended shared Knowledge files listed in
   [`knowledge-manifest.md`](knowledge-manifest.md).
5. Optionally add private candidate workspace files (your own resume,
   in-progress Research State, or prior outputs) — see the private
   workspace section of [`knowledge-manifest.md`](knowledge-manifest.md).
   These are yours alone; do not add them to a shared or team Project.
6. Start with one of the prompts in
   [`conversation-starters.md`](conversation-starters.md), or describe
   your own background and goal directly.
7. Verify the Skill is being used for in-scope research — responses to
   candidate, company, people, activity, ranking, or outreach requests
   should follow the methodology (evidence, confidence, freshness,
   canonical output shapes) rather than free-form answers.
8. Keep personal data out of shared Project assets — real candidate,
   company, or person details belong only in your own conversation or
   your own private workspace files, never in shared Knowledge, the Skill
   package, or this repository.

## Distribution paths

The steps above describe setting up a single Project directly from this
repository. Depending on who you're setting the Project up for, that
happens along one of two distinct paths:

### Organization Shared Project

For teammates within the creator's own Claude organization:

- Share the Project within the same Claude organization.
- Use restricted access unless editing is required.
- Keep shared Knowledge free of personal candidate records.
- Ensure the Skill is separately available to users — Project sharing
  does not automatically install the Skill for everyone who gains access.

### External Self-Install

For anyone outside the creator's Claude organization:

- Distribute the [external self-install kit](external-install/README.md)
  instead of relying on Project sharing.
- The user installs the Skill from the kit's embedded Skill ZIP.
- The user creates their own private Project.
- The user pastes the kit's included Instructions (copied byte-for-byte
  from [`project-instructions.compact.md`](project-instructions.compact.md)
  at packaging time).
- The user uploads the kit's included Knowledge files.
- The user optionally adds their own private workspace files.

See [`external-install/README.md`](external-install/README.md) for the
full flow and [`external-install/installation-checklist.md`](external-install/installation-checklist.md)
for the step-by-step checklist.

## Responsibility table

| Layer | Responsibility |
|---|---|
| Core repository (`core/`, `schemas/`, `ranking/`, `workflows/`, `outputs/`) | Canonical methodology |
| Claude Skill (`claude/skill/`) | Execution and progressive loading |
| Project Instructions | Conversation routing and UX |
| Project Knowledge | Shared methodology and optional private context |
| Claude platform | Available context, persistence, and retention |
| User | Inputs, corrections, privacy choices, and actions |

## What this setup does not guarantee

Installing the Skill and following this guide increases the likelihood
that in-scope requests are handled with the Career Targeting Intelligence
methodology, but it does not guarantee automatic Skill activation on every
message — the underlying platform decides when an installed Skill is
invoked. It also does not provide cross-chat memory: nothing in this setup
persists candidate data between conversations beyond what the platform
itself retains and beyond whatever the user explicitly saves to their own
private workspace files or Knowledge.
