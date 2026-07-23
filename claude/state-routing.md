# State Routing

Defines how the Project uses available active context — conversation
history, uploaded files, and any Research State the user supplies — to
decide what to run and what to reuse. This adapts the Skill's
[workflow-routing reference](skill/references/workflow-routing.md) and the
canonical [`schemas/research-state.schema.md`](../schemas/research-state.schema.md)
for the Project's conversational layer; it does not redefine either.

## Rules

1. Use information already available in the current conversation, uploaded
   files, or Project context. Do not re-derive what is already stated.
2. Do not ask again for information already available.
3. An explicit user correction overrides prior inference, even if the
   inference came from the same conversation.
4. Do not claim access to prior conversations, external accounts, or
   monitoring data that were not actually supplied in the active context.
5. Resume only from a Research State actually present in the active
   context (pasted, uploaded, or otherwise supplied this conversation).
   Never assume a Research State exists because a prior journey seems
   likely.
6. After a single constraint change (for example, a new commute limit),
   run only the modules that constraint actually affects — not the whole
   journey.
7. Refresh stale public evidence (activity, hiring signal, current
   employment) without rebuilding stable candidate facts (identity,
   technologies, seniority) that have not changed.
8. A focused task may proceed without a full saved journey when the
   user's current message supplies sufficient input on its own (for
   example, "find recruiters at Acme Corp and Beta Inc" needs no prior
   Candidate Profile to answer).

## Routing table

| Situation | Routing |
|---|---|
| New user, no prior context, resume/background pasted or described | Full Journey or Focused Task per the request — start with Candidate Analysis if the request implies more than one stage |
| Existing (in-context) candidate, requesting companies | Focused Task: Discover Companies → Classify and Rank Companies, reusing the existing Candidate Profile and Search Criteria |
| Companies already provided or approved, requesting recruiters | Focused Task: Discover People, scoped to the provided/selected companies only |
| People already identified, requesting activity verification | Focused Task: Verify Activity — only if explicitly requested, with an explicit lookback window |
| "Why is this ranked the way it is?" | Explain the existing ranking using the Ranking and Exclusions methodology — no module re-run |
| Single constraint change (e.g., commute limit, one excluded domain) | Update Search Criteria, then refresh only the location- or constraint-dependent fields on affected Company Records — not the whole map |
| One claim flagged as stale, or user asks to recheck one thing | Refresh only that claim (re-run the specific verification it needs) — leave the rest of the record untouched |
| User asks to export or produce an artifact from already-approved results | Produce the artifact/export directly — no module re-run, no new evidence created |

This table mirrors the Skill's
[Focused Task routing table](skill/references/workflow-routing.md#focused-task)
at the conversational-request level; it does not add new routing logic the
Skill doesn't already define.
