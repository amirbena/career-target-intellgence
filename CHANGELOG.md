# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

- Initialized repository foundation: project structure, working rules, and high-level scope.
- Defined the core candidate and research state data model: Candidate Profile, Search Criteria, and Research State schemas.
- Defined the Company, Person, and Activity Record schemas, extending the core data model to target companies, public professional contacts, and verified public activity evidence.
- Defined the shared trust policy: Source Policy, Confidence Model, Freshness Policy, and Quality Gates.
- Defined the ranking and outreach priority policy: Company Ranking Model, Person Ranking Model, Exclusion Policy, and Outreach Priority Model.
- Defined modular workflow orchestration: core workflow, Full Journey, Focused Task Routing, Resume Journey, and per-module definitions (Analyze Candidate, Build Search Criteria, Discover Companies, Classify and Rank Companies, Discover People, Verify Activity, Build Outreach Queue); aligned Research State stage names with the workflow modules.
- Defined canonical output contracts: Candidate Profile, Search Criteria, Company Map, Excluded Companies, People Map, Activity Verification, Outreach Queue templates, and stable CSV column contracts for each.
- Reconciled deferred schema gaps: added `stale_reason` and `refresh_required` to the Company, Person, and Activity Record schemas, and `duplicate_contact_group` to the Person Record schema.
- Added the Tova golden journey: a complete, fully synthetic end-to-end example exercising the candidate/research data model, trust policy, ranking models, workflow, and output contracts together.
- Reconciled the five specification gaps identified by the Tova golden journey: added a shared percentage-based scoring-band rubric to the Company and Person Ranking Models; defined company re-scoring triggers and process; made the manager-versus-recruiter outreach tie-break explicit with a complete 10-step tie-break sequence; clarified the distinct, coexisting roles of `duplicate_risk` and `duplicate_contact_group` on the Person Record; and expanded the Company Map output contract (Markdown and CSV) to surface all eight Company Ranking Model dimensions.
- Added the first installable Claude Skill package (`claude/skill/`): a `SKILL.md` entry point defining product purpose, journey support, and explicit non-actions; eight progressively-loaded reference files adapting the canonical candidate, company, people, activity, ranking/exclusion, workflow-routing, output-generation, and quality/trust methodology for Claude; and eight reusable, placeholder-only output templates.
- Defined progressive reference loading: routes each user intent to the minimum required Skill reference files instead of loading the full methodology for every request.
- Added deterministic macOS/Linux packaging (`scripts/package-claude-skill.sh`) and Windows PowerShell packaging (`scripts/package-claude-skill.ps1`), both building `dist/career-targeting-intelligence.skill.zip` from the same explicit file allowlist (`SKILL.md`, `references/`, `templates/`) with a single top-level package directory.
- Added the Claude Skill package manifest (`claude/skill-manifest.md`) and packaging guide (`claude/packaging.md`), documenting included/excluded files, canonical source mappings, expected ZIP structure, and cross-platform packaging parity.
- Added the Claude Project Experience: full (`claude/project-instructions.md`) and compact (`claude/project-instructions.compact.md`) Project Instructions defining product identity, Skill routing, Full/Focused/Resume journey support, active-context reuse, trust rules, output behavior, and explicit non-actions, kept behaviorally aligned by design.
- Added the Skill trigger policy (`claude/skill-trigger-policy.md`), distinguishing requests that require full Skill methodology, partial reference to existing results, or no Skill involvement.
- Added state routing (`claude/state-routing.md`), defining how the Project reuses active context, resumes only from an actually-available Research State, and scopes refreshes to only the affected modules.
- Added the Knowledge manifest (`claude/knowledge-manifest.md`), recommending shared methodology Knowledge files while excluding personal records and the Skill package itself from duplication.
- Added the artifact policy (`claude/artifact-policy.md`), aligning artifact generation with the canonical output contracts and lifecycle statuses.
- Added conversation starters (`claude/conversation-starters.md`) and a Project setup guide (`claude/project-setup.md`) with a layer-responsibility table spanning the core repository, Skill, Project Instructions, Project Knowledge, platform, and user.
