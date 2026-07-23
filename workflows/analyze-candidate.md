# Module: Analyze Candidate

Builds the [Candidate Profile](../schemas/candidate-profile.schema.md) from available candidate input. This module does not redefine the schema — it describes how to populate it within the workflow.

## Purpose

Turn candidate-provided background (resume, description, prior context) into a structured Candidate Profile.

## Required Inputs

- A resume, candidate-provided background description, or equivalent context available in the active conversation.

## Optional Inputs

- Explicit user statements about target roles, seniority, or preferences that belong in the [Preferences and Constraints](../schemas/candidate-profile.schema.md#preferences-and-constraints) section.

## Preconditions

- None — this is typically the first module in a Full Journey, but it may also run standalone as a Focused Task (e.g., "Analyze this resume").

## Procedure

1. Extract Identity, Professional Level, Technologies, Professional Domains, and Responsibility and Impact fields from the available input, per the [Candidate Profile schema](../schemas/candidate-profile.schema.md).
2. Classify each technology as primary, secondary, or familiar based on the strength of evidence — see [Technologies](../schemas/candidate-profile.schema.md#technologies).
3. Record `source_documents`, `user_confirmed_fields`, `inferred_fields`, `assumptions`, and `uncertainties` to keep provenance visible, per [Evidence and Confidence](../schemas/candidate-profile.schema.md#evidence-and-confidence).
4. Present the draft profile for user confirmation before marking it Approved.

## Outputs

- A Candidate Profile with `profile_status` of Draft or Approved.

## Research State Updates

- `candidate_analysis_status` moves from Not Started → Draft → Approved.
- `candidate_profile_reference` is set once a profile exists.

## Quality Gates

- No invented experience — see [Candidate Profile Rules](../schemas/candidate-profile.schema.md#candidate-profile-rules), rule 1.
- No inflated seniority from years of experience alone — rule 3 in the same section is about management inference, but seniority-from-years-alone is separately prohibited in [Professional Level](../schemas/candidate-profile.schema.md#professional-level).
- No management inferred without evidence — rule 3.
- User corrections are preserved over model inference — rule 4.

## Uncertainty Handling

- Conflicting evidence (e.g., two different seniority signals) remains visible rather than silently resolved — rule 5.
- Fields with insufficient evidence are recorded as unknown, not guessed.

## Explicit Non-Actions

- Do not invent experience.
- Do not inflate seniority.
- Do not infer management responsibility without evidence.
- Do not rebuild an Approved profile without a stated reason.

## Related documents

- [../schemas/candidate-profile.schema.md](../schemas/candidate-profile.schema.md)
- [full-journey.md](full-journey.md)
- [focused-task-routing.md](focused-task-routing.md)
