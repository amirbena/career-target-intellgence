# Core Data Model

This document describes the canonical, platform-independent data model used throughout Career Targeting Intelligence. It defines the logical records the methodology operates on — not a database schema, not a storage format, and not an implementation.

## Principles

- **Platform-independent.** The model does not belong to Claude or ChatGPT. Both platforms must use the same field names and the same field meanings when they build their platform-specific instructions in [claude/](../claude/) and [chatgpt/](../chatgpt/).
- **Logical records, not storage.** Each schema describes the shape and meaning of a record. It does not mandate a database, a file format, or a specific serialization. A conversation, a Markdown document, or a JSON object can all be valid representations of the same logical record.
- **Unknown is not invented.** A field may be legitimately unknown. An unknown field must be recorded as unknown, not filled in with a plausible-sounding guess.
- **Provenance must stay visible.** Observed information (found in a resume or document), user-provided information (stated directly by the candidate), assumptions (a labeled, non-blocking guess), and model inferences (a conclusion the model drew from evidence) are different things and must remain distinguishable in every record. Collapsing them into a single unattributed fact is not permitted.
- **Public research comes later.** This model defines the candidate and the research journey only. Company, recruiter, hiring-manager, and activity data models are out of scope for this task and will be added in later tasks.

## Record Relationship

```text
Candidate Profile
        ↓
Search Criteria
        ↓
Research State
```

- **Candidate Profile** describes who the person is professionally — background, experience, technologies, and domains.
- **Search Criteria** describes what should be searched for — the preferences and constraints that shape the research, separate from the candidate's professional facts.
- **Research State** describes what has already been completed, approved, or needs refresh — the progress and continuation state of the research journey, separate from both the candidate's facts and the search preferences.

Each record has a distinct responsibility. A change to one does not automatically imply a rebuild of the others.

## Schemas

- [Candidate Profile](../schemas/candidate-profile.schema.md)
- [Search Criteria](../schemas/search-criteria.schema.md)
- [Research State](../schemas/research-state.schema.md)

## Related documents

- [../README.md](../README.md)
- [product-definition.md](product-definition.md)
- [scope-and-non-goals.md](scope-and-non-goals.md)
