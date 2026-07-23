# Roadmap

This roadmap tracks the high-level phases for building Career Targeting Intelligence. Phases are sequential at a high level; detailed tasks within each phase will be defined when that phase begins.

1. **Foundation** — repository structure, working rules, and high-level scope. **Completed.**
2. **Core Methodology** — the platform-independent workflow, steps, and principles in `core/`. **In progress** — candidate, search criteria, company, person, activity, and research state data model defined; source, confidence, freshness, and quality-gate policy defined; company and person ranking, exclusion, and outreach priority models defined; modular workflow orchestration (full journey, focused task routing, resume journey, and per-module definitions) defined; specification-reconciliation milestone **completed** — ranking-band rubric, company re-scoring rules, outreach tie-break rules, duplicate-field interaction, and expanded Company Map scoring visibility resolved.
3. **Output Contracts** — defined shapes for each output (Candidate Profile, Target Company Map, Recruiter Map, Hiring Manager Map, Activity Verification, Outreach Priority Queue). **Completed.**
4. **Golden Example** — a worked, end-to-end example demonstrating the full methodology. **Completed** — the Tova golden journey in `examples/tova/`.
5. **Claude Product** — the Claude Skill and Claude Project instructions in `claude/`. **In progress** — Claude Skill foundation and packaging **completed**: Skill source (`claude/skill/`), progressive reference loading, reusable output templates, and deterministic macOS/Linux and Windows packaging into `dist/career-targeting-intelligence.skill.zip` are in place. Claude Project instructions have not been added yet.
6. **ChatGPT Product** — the ChatGPT Custom GPT instructions in `chatgpt/`.
7. **Validation** — testing the methodology and both product surfaces against real scenarios.
8. **MVP Release** — first usable release across both platforms.

See [README.md](README.md) for project context and [core/product-definition.md](core/product-definition.md) for the product definition.
