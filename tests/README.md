# Tests

This repository is documentation- and prompt-driven — there is no executable application code to unit-test. "Tests" here are synthetic, fully fictional scenario fixtures and validation checklists that a human (or an agent walking through the methodology) can use to confirm the canonical policy in `core/`, `schemas/`, `ranking/`, and `workflows/` produces the required behavior, and that all three platform packages (ChatGPT Custom GPT, Claude Project, Claude Skill) stay semantically aligned with it.

All names, companies, people, and events in this directory are synthetic. None represent real candidates, companies, or events — consistent with [`core/data-model.md`](../core/data-model.md#personal-context) and [AGENTS.md](../AGENTS.md).

## Files

- [`job-verification-scenarios.md`](job-verification-scenarios.md) — the 8 required synthetic scenarios exercising the current-job verification policy and the Primary Job Eligibility Gate, each with its expected outcome per the canonical policy.
- [`quality-gate-checklist.md`](quality-gate-checklist.md) — a checklist mapping every rule in [`core/quality-gates.md`](../core/quality-gates.md) to a pass/fail check, focused on the new Verified Jobs Map, Unverified/Rejected Job Leads, and Company State Verification gates.
- [`package-alignment-checklist.md`](package-alignment-checklist.md) — a checklist confirming the ChatGPT Knowledge bundles, Claude Project Instructions/Knowledge, and Claude Skill package all reflect the same canonical rules with no manual edits and no drift between surfaces.

## How to use these

1. Walk each scenario in `job-verification-scenarios.md` against the current canonical policy (or against a configured GPT/Project/Skill) and confirm the "Expected outcome" is what's actually produced.
2. Walk `quality-gate-checklist.md` before treating any Verified Jobs Map, Unverified/Rejected Job Leads, or Company State output as complete.
3. Run `package-alignment-checklist.md` after any change to `core/`, `schemas/`, `ranking/`, `workflows/`, or `outputs/` and before treating a packaging change as done.

These fixtures are read-only reference material — they do not invoke or require any build tooling themselves. The build/packaging scripts in [`scripts/`](../scripts/) are validated by actually running them (see each script's own output) and by the packaging validation steps in this checklist.
