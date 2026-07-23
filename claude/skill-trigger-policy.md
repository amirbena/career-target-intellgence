# Skill Trigger Policy

Defines when a request needs the full Career Targeting Intelligence Skill
methodology, when it needs only a partial reference to existing results,
and when it needs no Skill involvement at all. This lets the Project
apply the [core routing rule](project-instructions.md#skill-usage-rules) —
minimum required modules — consistently.

Claude does not need to expose Skill-invocation mechanics to the user
(which reference file loaded, which module ran). The user sees the result
of the right amount of work, not the routing decision behind it.

## Skill Methodology Required

The request needs one or more Skill workflow modules to run, producing new
or updated evidence, scoring, or a new record:

- Candidate analysis (building or rebuilding a Candidate Profile).
- Search criteria (building or updating Search Criteria).
- Company discovery.
- Company classification.
- Company ranking.
- Recruiter discovery.
- Hiring-manager discovery.
- Activity verification.
- Job-status verification.
- Outreach prioritization.
- Producing a new artifact or CSV-compatible output from underlying
  records.

Route these to the specific module(s) they need, per
[`state-routing.md`](state-routing.md) — not to a full journey by default.

## Partial Skill Reference Use

The request references existing Skill output or methodology without
generating new evidence or re-running a module:

- Explaining an existing score or Priority tier.
- Comparing companies or people already researched in the conversation.
- Updating the formatting or presentation of an existing output.
- Summarizing an already-approved output.
- Refreshing a single stale claim (not the whole record or journey).
- Changing a single search constraint and reporting only the scoped
  impact (see [`state-routing.md`](state-routing.md) for the affected-only
  refresh rule).

These may still consult a Skill reference file to apply the methodology
correctly (for example, the scoring-band rubric to explain a score), but
they do not re-run discovery, classification, or verification from
scratch.

## Skill Not Required

The request has nothing to do with the career-targeting methodology:

- General product-help questions ("what can this Project do?").
- Unrelated conversation.
- Simple wording or tone changes to text already in the conversation.
- Questions about the repository's own setup or structure.

Handle these as ordinary conversation. Do not load any Skill reference
file, and do not frame the response as if Skill methodology applied.

## Mutual understandability

These three categories are meant to be recognizable without ambiguity by
matching a request against its examples above, not by any hidden signal.
When a request plausibly spans two categories (for example, "why is this
Priority 2, and can you also check if anything's changed?" mixes Partial
Reference Use with Skill Methodology Required), treat it as belonging to
the stronger category — do the new verification the second half asks for,
using only the module it needs, rather than defaulting to the weaker
category and under-delivering.
