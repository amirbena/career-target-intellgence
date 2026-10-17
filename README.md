# Career Targeting Intelligence

Career Targeting Intelligence finds currently open roles that meaningfully
match a candidate, verifies their availability against the strongest public
evidence, evaluates company-state signals, identifies relevant recruiters
and potential hiring managers, and produces an evidence-based **manual**
outreach queue. It runs on demand inside your AI assistant: no scraping,
background automation, or automated outreach.

**📖 [Read the Wiki](https://github.com/amirbena/career-target-intellgence/wiki)**: how the Skill works, what each reference and template is for, and how to extend it. The Wiki explains; this repository is the source of truth.

## Installation

**Claude Code** (terminal; marketplace):

```bash
claude plugin marketplace add amirbena/career-target-intellgence
claude plugin install career-targeting-intelligence@career-targeting-intelligence
```

Then start a new session or run `/reload-plugins`. The interactive `/plugin` equivalents are in the [detailed guide](docs/installation.md#claude-code-marketplace).

**Codex CLI** (same marketplace; verified from GitHub with `codex-cli 0.160.0`):

```bash
codex plugin marketplace add amirbena/career-target-intellgence
codex plugin add career-targeting-intelligence@career-targeting-intelligence
```

**Cursor** (verified):

```bash
npx skills add amirbena/career-target-intellgence -a cursor -y
```

**Any other skills-compatible agent:**

```bash
npx skills add amirbena/career-target-intellgence
```

**Claude Desktop / Claude.ai / Cowork** (plugin or Skill ZIP from [Releases](https://github.com/amirbena/career-target-intellgence/releases/latest)): see [Claude Plugin ZIP](docs/installation.md#claude-plugin-zip) and [Claude Skill ZIP](docs/installation.md#claude-skill-zip). For a Claude Project, use the [external kit](claude/external-install/README.md).

**ChatGPT Desktop** (local plugin marketplace): see [ChatGPT install](docs/installation.md#chatgpt-plugin). The plugin has been verified working inside ChatGPT, but these Desktop steps are *not verified end-to-end*, and a Codex CLI install is not verified to carry over to ChatGPT Desktop.

All steps, activation, and verification status: [docs/installation.md](docs/installation.md).

## Usage

- *Here is my resume. Build my Candidate Profile.*
- *Find currently open Senior Backend roles that match my experience.*
- *Find relevant recruiters for this verified open role: [job URL].*

## How It Works

A job-first research journey: Candidate Profile → Search Criteria → Job
Discovery → Job Verification → Candidate/Job Fit → Company State →
Recruiter/Hiring-Manager Discovery → Outreach Prioritization. A role only
reaches the Verified Jobs Map after passing a hard availability and fit
gate, every time-sensitive claim carries a source and check date, and
rejected leads stay visible with a reason. Focused requests (verify one
job, refresh a company) run only the modules they need.

## Documentation

- [Repository map](docs/repository-map.md): what each top-level area is, source of truth vs. packaging, and where to start by task
- [Installation](docs/installation.md)
- [Architecture](docs/architecture.md) and [Development](docs/development.md)
- [Workflow](core/workflow.md), [job verification policy](core/job-verification-policy.md), [scope and non-goals](core/scope-and-non-goals.md)
- [Repository policies](policies/) (contributors and coding agents start at [AGENTS.md](AGENTS.md))
- [ROADMAP](ROADMAP.md), [tests](tests/README.md), [golden example](examples/tova/)
