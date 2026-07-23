# Builder Configuration

Paste-ready fields for configuring the Career Targeting Intelligence
Custom GPT in the GPT editor. See [`builder-setup.md`](builder-setup.md)
for the step-by-step process this configuration fits into.

## Name

```text
Career Targeting Intelligence
```

## Description

```text
Turns your background and search constraints into a prioritized map of target companies, relevant recruiters and engineering managers, evidence-based activity verification, and a manual outreach queue you review and act on yourself.
```

This communicates candidate-to-company targeting, recruiters and
engineering managers, evidence-based activity verification, and
prioritized (manual) outreach — without claiming automation, guaranteed
job outcomes, or guaranteed current data.

## Instructions source

```text
chatgpt/instructions.md
```

Paste the entire content of that file into the GPT's Instructions field,
unedited. Do not summarize, shorten, or rewrite it during setup — it is
already sized and worded for direct use.

## Conversation Starters

```text
chatgpt/conversation-starters.md
```

Add each starter listed there as one of the GPT's Conversation Starters.

## Knowledge uploads

Upload all eight generated bundles under `chatgpt/knowledge/`:

1. `01-product-and-terminology.md`
2. `02-candidate-and-search.md`
3. `03-company-intelligence.md`
4. `04-people-and-activity.md`
5. `05-ranking-and-exclusions.md`
6. `06-workflow-and-state.md`
7. `07-evidence-confidence-freshness.md`
8. `08-output-contracts.md`

These are generated files — build or rebuild them with
`scripts/build-chatgpt-knowledge.sh` (or `.ps1`) rather than editing them
by hand. See [`knowledge-manifest.md`](knowledge-manifest.md) for what
each bundle contains and where it comes from.

## Recommended capabilities

Configure the following when your account and workspace expose the
control — availability of these toggles varies by account:

- **Web search** — enabled when available. Used for company discovery,
  current-employment checks, current-job checks, and recent-activity
  verification. See [`capability-policy.md`](capability-policy.md) for
  exact behavior when it is or isn't available.
- **Code Interpreter / Data Analysis** — enabled when available. Used for
  deterministic score calculation, CSV-compatible output, deduplication
  checks, and tabular transformations.
- **Canvas** — optional, enable if available; not required for core
  functionality.
- **Image generation** — disabled, unless a future product requirement
  needs it.

## Not configured

- **Actions** — not configured. This package defines no Action schema.
- **Apps / connectors** — not configured.
- **External APIs** — not configured.

## Profile image

Document only a high-level visual brief for whoever creates the image —
this task does not generate it:

- Professional.
- Clean.
- Research / intelligence theme (for example, an abstract map, network, or
  magnifying-glass motif).
- No company logos.
- No misleading affiliation with any company, job board, or platform.
