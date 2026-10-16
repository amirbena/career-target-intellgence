# Package Alignment Checklist

Confirms the three distributed platform surfaces stay semantically aligned with the canonical sources in `core/`, `schemas/`, `ranking/`, `workflows/`, and `outputs/`, per [`policies/packaging-rules.md`](../policies/packaging-rules.md) (Claude Skill packaging rules, Claude Project experience rules, ChatGPT packaging rules) and [`core/quality-gates.md` — Cross-Platform Package Alignment](../core/quality-gates.md#cross-platform-package-alignment). Run this after any canonical change and before treating a packaging change as complete.

## Build commands to run

```bash
./scripts/package/build-chatgpt-knowledge.sh
./scripts/package/package-chatgpt-plugin.sh
./scripts/package/package-claude-skill.sh
./scripts/package/package-claude-external-kit.sh
./scripts/package/package-claude-plugin.sh
```

Each script must exit successfully and print its packaged file list. None of them should be hand-edited afterward — a mismatch is fixed by editing the canonical source and re-running the script, never by editing `chatgpt/knowledge/*.md`, `dist/*.zip` contents, or any generated bundle directly.

## Checks

| # | Check |
|---|---|
| 1 | `chatgpt/knowledge/09-job-and-company-state.md` exists, is generated (carries the generated-content notice), and contains the current `schemas/job-record.schema.md`, `schemas/company-state-record.schema.md`, `core/job-verification-policy.md`, `ranking/job-eligibility-gate.md`, `workflows/discover-jobs.md`, `workflows/verify-job.md`, `workflows/evaluate-candidate-job-fit.md`, and `workflows/verify-company-state.md` content verbatim. |
| 2 | `chatgpt/knowledge/06-workflow-and-state.md` includes `workflows/job-search-journey.md`. |
| 3 | `chatgpt/knowledge/08-output-contracts.md` includes `outputs/verified-jobs-map-template.md` and `outputs/unverified-job-leads-template.md`. |
| 4 | `dist/career-targeting-intelligence-chatgpt-plugin.zip` contains exactly nine bundles `01`–`09` under `skills/career-targeting-intelligence/references/`, plus `capability-policy.md`, `SKILL.md`, and `plugin.json`, matching `chatgpt/package-manifest.md`. |
| 5 | `dist/career-targeting-intelligence.skill.zip` contains `references/job-intelligence.md`, `templates/verified-jobs-map.md`, and `templates/unverified-job-leads.md`, matching `claude/skill-manifest.md`'s file list. |
| 6 | `dist/career-targeting-intelligence-claude-kit.zip` contains `knowledge/job-verification-policy.md` and `knowledge/job-eligibility-gate.md`, matching `claude/external-install/package-manifest.md`. |
| 7 | No Golden Journey content (`examples/tova/`) or real personal data appears in any generated bundle or packaged ZIP. |
| 8 | `claude/project-instructions.md` and `claude/project-instructions.compact.md` describe the Job Search Journey and Company Targeting Journey consistently (same rules, no contradiction) — spot-check the "Supported use cases," journey routing, and non-actions sections in both. |
| 9 | None of the three surfaces (ChatGPT Instructions, Claude Project Instructions, Claude Skill) restate a canonical enum, weight, threshold, or rule with a different value than its canonical source — each should reference the canonical file rather than re-deriving the value. |
| 10 | Every new canonical file introduced by this change (`schemas/job-record.schema.md`, `schemas/company-state-record.schema.md`, `core/job-verification-policy.md`, `ranking/job-eligibility-gate.md`, `workflows/job-search-journey.md`, `workflows/discover-jobs.md`, `workflows/verify-job.md`, `workflows/evaluate-candidate-job-fit.md`, `workflows/verify-company-state.md`, `outputs/verified-jobs-map-template.md`, `outputs/unverified-job-leads-template.md`) is referenced from at least one packaging manifest or build-script allowlist — none omitted by accident. |

## Release version checks

Run when changing packaging scripts or the release process. The GitHub Release tag is the single source of truth for versions.

```bash
export RELEASE_VERSION=9.9.9   # any MAJOR.MINOR.PATCH
./scripts/package/package-claude-skill.sh && ./scripts/package/package-claude-external-kit.sh \
  && ./scripts/package/package-claude-plugin.sh && ./scripts/package/package-chatgpt-plugin.sh
./scripts/validate/verify-archive-versions.sh "$RELEASE_VERSION"   # must pass
./scripts/validate/verify-archive-versions.sh 0.0.0                # must fail
```

| # | Check |
|---|---|
| 11 | `dist/career-targeting-intelligence-claude-plugin.zip` contains `.claude-plugin/plugin.json` and `skills/career-targeting-intelligence/` with the same `SKILL.md`, `references/`, and `templates/` file list as the Skill ZIP, passes `claude plugin validate`, and contains no Golden Journey or personal data. |
| 12 | With `RELEASE_VERSION` set, the Skill ZIP, Claude Project Kit, Claude Plugin, and ChatGPT Plugin each embed that version; without it, packagers behave as before. |
| 13 | The `.sh` and `.ps1` packagers and validators list the same normalized files. |

## Related documents

- [../AGENTS.md](../AGENTS.md)
- [../policies/packaging-rules.md](../policies/packaging-rules.md)
- [../core/quality-gates.md](../core/quality-gates.md)
- [../claude/packaging.md](../claude/packaging.md)
- [../claude/skill-manifest.md](../claude/skill-manifest.md)
- [../claude/external-install/package-manifest.md](../claude/external-install/package-manifest.md)
- [../chatgpt/knowledge-manifest.md](../chatgpt/knowledge-manifest.md)
- [../chatgpt/package-manifest.md](../chatgpt/package-manifest.md)
