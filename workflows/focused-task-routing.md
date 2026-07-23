# Focused Task Routing

A Focused Task lets the user enter directly into a specific [workflow module](../core/workflow.md#workflow-modules) when sufficient context is already available, instead of running the [Full Journey](full-journey.md) end to end. This document defines how requests route to modules and the prerequisite behavior that applies to all focused tasks.

## Routing Table

| User request | Required modules |
|---|---|
| "Analyze this resume" | Analyze Candidate |
| "Find 30 companies" | Search Criteria → Discover Companies → Classify and Rank Companies |
| "Find recruiters at these companies" | Discover People |
| "Find managers who may manage this profile" | Discover People |
| "Check who posted jobs recently" | Verify Activity |
| "Why is this Priority 2?" | Explain existing ranking only — no module re-run |
| "Change commute to 20 minutes" | Update Search Criteria → refresh location-dependent Company Record fields only |
| "Create an outreach list" | Build Outreach Queue |
| "Export this to CSV" | Export existing approved output only — no module re-run |

This table is illustrative, not exhaustive. The [Routing Principle](../core/workflow.md#routing-principle) governs any request not listed: use the minimum required modules to satisfy the request.

## Prerequisite Behavior

- Use existing context where available — see [Active Conversation Context](../core/data-model.md#active-conversation-context).
- Do not ask again for known information — see [Core Rules](../core/data-model.md#core-rules), rule 2.
- Ask only when a missing input blocks correct execution.
- Use a clearly labeled assumption when the missing detail is non-blocking — see [Search Criteria Rules](../schemas/search-criteria.schema.md#search-criteria-rules), rule 3.
- Do not silently trigger unrelated modules; a request scoped to one module (e.g., "explain this ranking") must not cause company discovery, activity verification, or any other module to run.

## Worked Examples

**"Why is this Priority 2?"**
No module runs. The system explains the existing score using the reasoning already recorded against the [Company Ranking Model](../ranking/company-ranking-model.md) dimensions for that company — it does not re-score the company or re-run discovery.

**"Change commute to 20 minutes"**
Only Search Criteria updates (`maximum_commute_minutes`), and only the Company Records' Location and commute fit dimension and `estimated_commute_minutes`/`commute_confidence` fields are refreshed. Technology fit, domain fit, and other unaffected dimensions are not recomputed — see [Search Criteria Rules](../schemas/search-criteria.schema.md#search-criteria-rules), rule 8.

**"Find managers who may manage this profile"**
Only Discover People runs, scoped to Engineering Manager, Group Manager, Director of Engineering, Head of R&D, and VP R&D person types, per the [Person Ranking Model](../ranking/person-ranking-model.md#hiring-managers). Company discovery and ranking are not re-run if a selected company set already exists.

## Related documents

- [../core/workflow.md](../core/workflow.md)
- [full-journey.md](full-journey.md)
- [resume-journey.md](resume-journey.md)
