# Artifact Policy

Defines when the Project should produce a dedicated artifact (a standalone,
reusable document) versus keeping a result inline in the conversation, and
what every artifact must preserve. This adapts the canonical
[`core/output-contracts.md`](../core/output-contracts.md) and the Skill's
[output-generation reference](skill/references/output-generation.md) for
the Project's conversational layer — it does not redefine either.

## Supported artifacts

- Candidate Profile
- Search Criteria
- Company Map
- Excluded Companies Report
- People Map
- Activity Verification Report
- Outreach Queue
- Research State
- CSV-compatible table

Each uses the shape defined by its matching
[Skill template](skill/templates/) and the corresponding canonical output
contract — an artifact is a presentation of that shape, not a new one.

## Rules

1. Short intermediate results (a quick answer, a single explanation, a
   small clarifying comparison) may remain inline in chat — not every
   response needs an artifact.
2. A canonical or reusable output — one of the nine listed above, once it
   has real content — should become an artifact rather than staying
   buried in chat, so the user can return to it, edit it, or export it.
3. Lifecycle status (Draft, Verified, Approved, Stale, Superseded, or the
   applicable output-specific status) must remain visible on the artifact
   itself, not only mentioned in surrounding chat text.
4. Producing an artifact creates no new evidence. It packages evidence
   already gathered — it never fills a gap with an invented value to make
   the artifact look complete.
5. A partial output (for example, a Company Map where only some companies
   are fully verified) must be clearly labeled as partial, with the same
   visibility rules that apply in chat.
6. Real user information supplied in the conversation must never be copied
   into a shared Skill file, shared Project Knowledge, or any repository
   asset — an artifact stays inside the user's own conversation/workspace.
7. Export to an external file, or mutation of a connected file or
   spreadsheet, happens only after an explicit, in-the-moment user
   request — never automatically because an artifact was produced.
8. Outreach-related artifacts (the Outreach Queue) remain advisory and
   manual. An artifact recommending an action never performs that action,
   and must not be framed as having already done so.
