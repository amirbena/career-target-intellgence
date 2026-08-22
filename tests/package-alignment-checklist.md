# Package Alignment Checklist

Confirms the three distributed platform surfaces stay semantically aligned with the canonical sources in `core/`, `schemas/`, `ranking/`, `workflows/`, and `outputs/`, per [`AGENTS.md`](../AGENTS.md) (Claude Skill packaging rules, Claude Project experience rules, ChatGPT packaging rules) and [`core/quality-gates.md` — Cross-Platform Package Alignment](../core/quality-gates.md#cross-platform-package-alignment). Run this after any canonical change and before treating a packaging change as complete.

## Build commands to run

```bash
./scripts/build-chatgpt-knowledge.sh
./scripts/package-chatgpt-gpt.sh
./scripts/package-claude-skill.sh
./scripts/package-claude-external-kit.sh
```

Each script must exit successfully and print its packaged file list. None of them should be hand-edited afterward — a mismatch is fixed by editing the canonical source and re-running the script, never by editing `chatgpt/knowledge/*.md`, `dist/*.zip` contents, or any generated bundle directly.

## Checks

| # | Check |
|---|---|
| 1 | `chatgpt/knowledge/09-job-and-company-state.md` exists, is generated (carries the generated-content notice), and contains the current `schemas/job-record.schema.md`, `schemas/company-state-record.schema.md`, `core/job-verification-policy.md`, `ranking/job-eligibility-gate.md`, `workflows/discover-jobs.md`, `workflows/verify-job.md`, `workflows/evaluate-candidate-job-fit.md`, and `workflows/verify-company-state.md` content verbatim. |
| 2 | `chatgpt/knowledge/06-workflow-and-state.md` includes `workflows/job-search-journey.md`. |
| 3 | `chatgpt/knowledge/08-output-contracts.md` includes `outputs/verified-jobs-map-template.md` and `outputs/unverified-job-leads-template.md`. |
| 4 | `dist/career-targeting-intelligence-chatgpt.zip` contains exactly nine files under `knowledge/` (`01`–`09`), matching `chatgpt/package-manifest.md`. |
| 5 | `dist/career-targeting-intelligence.skill.zip` contains `references/job-intelligence.md`, `templates/verified-jobs-map.md`, and `templates/unverified-job-leads.md`, matching `claude/skill-manifest.md`'s file list. |
| 6 | `dist/career-targeting-intelligence-claude-kit.zip` contains `knowledge/job-verification-policy.md` and `knowledge/job-eligibility-gate.md`, matching `claude/external-install/package-manifest.md`. |
| 7 | No Golden Journey content (`examples/tova/`) or real personal data appears in any generated bundle or packaged ZIP. |
| 8 | `claude/project-instructions.md` and `claude/project-instructions.compact.md` describe the Job Search Journey and Company Targeting Journey consistently (same rules, no contradiction) — spot-check the "Supported use cases," journey routing, and non-actions sections in both. |
| 9 | None of the three surfaces (ChatGPT Instructions, Claude Project Instructions, Claude Skill) restate a canonical enum, weight, threshold, or rule with a different value than its canonical source — each should reference the canonical file rather than re-deriving the value. |
| 10 | Every new canonical file introduced by this change (`schemas/job-record.schema.md`, `schemas/company-state-record.schema.md`, `core/job-verification-policy.md`, `ranking/job-eligibility-gate.md`, `workflows/job-search-journey.md`, `workflows/discover-jobs.md`, `workflows/verify-job.md`, `workflows/evaluate-candidate-job-fit.md`, `workflows/verify-company-state.md`, `outputs/verified-jobs-map-template.md`, `outputs/unverified-job-leads-template.md`) is referenced from at least one packaging manifest or build-script allowlist — none omitted by accident. |

## Related documents

- [../AGENTS.md](../AGENTS.md)
- [../core/quality-gates.md](../core/quality-gates.md)
- [../claude/skill-manifest.md](../claude/skill-manifest.md)
- [../claude/external-install/package-manifest.md](../claude/external-install/package-manifest.md)
- [../chatgpt/knowledge-manifest.md](../chatgpt/knowledge-manifest.md)
- [../chatgpt/package-manifest.md](../chatgpt/package-manifest.md)
