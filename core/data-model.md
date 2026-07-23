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
- **Research State** describes what has already been completed, approved, or needs refresh — a logical representation of research journey progress, based on the context available to the running platform. It is not a storage mechanism, separate from both the candidate's facts and the search preferences.

Each record has a distinct responsibility. A change to one does not automatically imply a rebuild of the others.

## Schemas

- [Candidate Profile](../schemas/candidate-profile.schema.md)
- [Search Criteria](../schemas/search-criteria.schema.md)
- [Research State](../schemas/research-state.schema.md)

## Context Boundary

The core model defines the logical structure the product uses. It does not implement or control how any platform persists conversations, files, or memory.

### Active Conversation Context

Within an active conversation, the product may learn from and use information that the user:

- writes in messages;
- provides through a resume;
- uploads in files;
- adds through the active Project or workspace context;
- explicitly corrects or expands during the conversation.

The latest explicit user correction takes precedence over earlier inference.

### Platform-Managed Persistence

The platform running the product is responsible for any supported conversation, Project, workspace, memory, or file persistence.

The shared product specification does not:

- implement persistence;
- guarantee cross-chat recall;
- define hidden metadata;
- write to undocumented platform state;
- control platform retention;
- create an external data store.

The product may use prior context when the platform makes that context available. When prior context is unavailable, it must not pretend to remember it.

### Role of the GPT, Project, and Skill

The GPT, Claude Project Instructions, and Claude Skill provide:

- the logical gateway into the product;
- intent detection;
- research methodology;
- field definitions;
- evidence and confidence rules;
- output contracts;
- quality gates;
- guidance for using the context available in the current execution environment.

They are not the canonical storage location for an individual user's research data. Shared instructions and Skill files must remain generic and reusable.

### Personal Context

Personal candidate information may exist in the active platform-managed context, including:

- the current conversation;
- files uploaded by the user;
- a private Project or workspace;
- other context explicitly made available by the platform.

The product should use this information when relevant, but must not copy real personal records into shared repository files, reusable prompts, shared Knowledge files, or the distributed Skill package.

## Core Rules

1. Use all relevant information available in the active context.
2. Do not ask again for information already available in that context.
3. Explicit user corrections override model inference.
4. Do not claim access to context that the platform has not provided.
5. Do not promise automatic memory or persistence.
6. Do not place real user records inside shared prompts, Skills, Knowledge assets, examples, or repository documentation.
7. Shared product assets define logic and methodology only.
8. Platform-specific adapters may describe how users supply context, but may not redefine the core data model.
9. Absence of prior context does not block a focused task when the user supplies sufficient input.
10. No state rule may imply background monitoring or scheduled execution.

## Related documents

- [../README.md](../README.md)
- [product-definition.md](product-definition.md)
- [scope-and-non-goals.md](scope-and-non-goals.md)
