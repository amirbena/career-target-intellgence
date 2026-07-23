# Career Targeting Intelligence — ChatGPT Custom GPT

This is the deployable ChatGPT Custom GPT package for Career Targeting
Intelligence. It packages the same methodology defined canonically in
`core/`, `schemas/`, `ranking/`, `workflows/`, and `outputs/` for
execution as a ChatGPT Custom GPT.

## What this GPT does

Given a candidate's background and search constraints, it produces a
prioritized, evidence-based map of target companies, relevant recruiters
and engineering managers, verified public activity, and a manual outreach
queue — a research and prioritization assistant the user reviews and acts
on themselves, not an automation system.

## What this archive contains

```text
career-targeting-intelligence-chatgpt/
  README.md
  instructions.md
  builder-config.md
  conversation-starters.md
  builder-setup.md
  capability-policy.md
  testing-guide.md
  sharing-and-publishing.md
  knowledge-manifest.md
  knowledge/
    01-product-and-terminology.md
    02-candidate-and-search.md
    03-company-intelligence.md
    04-people-and-activity.md
    05-ranking-and-exclusions.md
    06-workflow-and-state.md
    07-evidence-confidence-freshness.md
    08-output-contracts.md
```

See [`package-manifest.md`](package-manifest.md) for the full structure
definition and exclusions.

## How to build the GPT

1. Paste [`instructions.md`](instructions.md) into the GPT's Instructions
   field.
2. Upload all eight files under `knowledge/` as Knowledge.
3. Set the Name, Description, and Capabilities from
   [`builder-config.md`](builder-config.md).
4. Add the Conversation Starters from
   [`conversation-starters.md`](conversation-starters.md).

Full step-by-step instructions: [`builder-setup.md`](builder-setup.md).

## Which eight files to upload as Knowledge

All eight files under `knowledge/`, listed above — no more, no fewer. They
are generated from canonical repository sources; see
[`knowledge-manifest.md`](knowledge-manifest.md) for exactly which source
maps to which bundle.

## What goes into Instructions

The entire content of [`instructions.md`](instructions.md), pasted
unedited. It defines behavior, routing, trust boundaries, and output
policy — it deliberately does not duplicate the scoring weights, evidence
states, or output columns that live in Knowledge instead.

## Required validation

Before sharing or publishing, run every test in
[`testing-guide.md`](testing-guide.md) and confirm each behaves as
documented.

## Privacy boundaries

- This archive contains no real candidate, company, or person data, and
  no Golden Journey example content.
- Knowledge is reference methodology only — never personal records. See
  [`knowledge-manifest.md`](knowledge-manifest.md).
- The GPT does not promise persistence, automatic memory, or guaranteed
  web access — see the explicit non-actions in
  [`instructions.md`](instructions.md).

## Actions and APIs are not included

This package configures no Actions, Apps, connectors, or external APIs.
See [`capability-policy.md`](capability-policy.md) for exactly how the GPT
behaves with and without built-in platform capabilities like web search
and data analysis — that is a separate question from Actions/Apps, which
this package does not use at all.
