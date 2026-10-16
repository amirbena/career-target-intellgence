# Career Targeting Intelligence

Career Targeting Intelligence finds currently open roles that meaningfully
match a candidate, verifies their availability against the strongest public
evidence, evaluates company-state signals, identifies relevant recruiters
and potential hiring managers, and produces an evidence-based **manual**
outreach queue. It runs on demand inside your AI assistant: no scraping,
background automation, or automated outreach.

## Quick Start

**Claude Code** (marketplace):

```text
/plugin marketplace add amirbena/career-target-intellgence
/plugin install career-targeting-intelligence@career-targeting-intelligence
```

Run `/reload-plugins`, then ask: *"Here is my resume. Build my Candidate Profile."*

**ChatGPT** (local plugin marketplace, desktop app; *not verified end-to-end*): download the ChatGPT Plugin ZIP from [Releases](https://github.com/amirbena/career-target-intellgence/releases/latest), register it in `~/.agents/plugins/marketplace.json`, restart the app, then install **Career Targeting** from the Plugins directory and start a chat with `@`. Exact steps and account notes: [ChatGPT install](docs/installation.md#chatgpt-plugin). The public directory listing needs OpenAI review and is not done yet.

**Cursor:**

```bash
npx skills add amirbena/career-target-intellgence -a cursor -y
```

**Any other skills-compatible agent** (Claude Code included, as an alternative to the marketplace):

```bash
npx skills add amirbena/career-target-intellgence
```

**Claude.ai / Cowork plugin, Claude Skill, and Claude Project:** download the ZIPs from [Releases](https://github.com/amirbena/career-target-intellgence/releases/latest). The Project kit has its own guide: [claude/external-install/README.md](claude/external-install/README.md).

All steps, activation, and verification: [docs/installation.md](docs/installation.md).

## Usage Examples

- *Find currently open Senior Backend roles that match my experience.*
- *Identify product companies worth targeting for me.*
- *Find relevant recruiters for this verified open role: <link>.*

## Supported Platforms

| Platform | Install |
| --- | --- |
| Claude Code | Marketplace, `npx skills`, or plugin ZIP |
| Claude.ai / Cowork | Plugin ZIP, Skill ZIP |
| Claude Project | [External kit](claude/external-install/README.md) |
| ChatGPT | Skills-only plugin (local marketplace) |
| Cursor | `npx skills` |
| Other agents | `npx skills` |

## How It Works

A job-first research journey: Candidate Profile → Search Criteria → Job
Discovery → Job Verification → Candidate/Job Fit → Company State →
Recruiter/Hiring-Manager Discovery → Outreach Prioritization. A role only
reaches the Verified Jobs Map after passing a hard availability and fit
gate, every time-sensitive claim carries a source and check date, and
rejected leads stay visible with a reason. Focused requests (verify one
job, refresh a company) run only the modules they need.

See [core/workflow.md](core/workflow.md), [core/job-verification-policy.md](core/job-verification-policy.md), and [docs/architecture.md](docs/architecture.md).

## Architecture

The methodology lives once, in `core/`; the Claude and ChatGPT packages are
thin wrappers built from it.

| Path | Contents |
| --- | --- |
| `core/` | Canonical methodology: policies, workflow, quality gates, output contracts |
| `schemas/`, `ranking/`, `workflows/`, `outputs/` | Data model, scoring models, step-by-step modules, output templates |
| `skills/` | The canonical Claude Skill (also used by `npx skills` and the marketplace) |
| `claude/`, `chatgpt/` | Platform wrappers: plugin manifests, Project instructions, Knowledge bundles |
| `scripts/` | Packaging and validation scripts |
| `policies/` | Repository maintenance rules for coding agents |
| `docs/` | Human documentation |
| `examples/tova/` | Fully synthetic end-to-end example |

## Development

Build and validation commands are in [docs/development.md](docs/development.md). Contributors and coding agents follow [AGENTS.md](AGENTS.md), which points to the rules in [policies/](policies/). Packages are generated from canonical sources; never hand-edit generated files.

## Documentation

- [Installation](docs/installation.md)
- [Architecture](docs/architecture.md): journeys, data model, trust, ranking, workflow, output contracts
- [Development](docs/development.md)
- [Repository policies](policies/): [Git and PR workflow](policies/git-workflow.md), [packaging rules](policies/packaging-rules.md), [issue labels](policies/issue-labels.md)
- [Product definition](core/product-definition.md), [scope and non-goals](core/scope-and-non-goals.md), [ROADMAP](ROADMAP.md)
- [Tests and scenarios](tests/README.md), [Golden example](examples/tova/)
