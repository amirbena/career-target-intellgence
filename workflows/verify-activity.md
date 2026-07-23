# Module: Verify Activity

Applies the A0–A4 activity levels to discovered people, producing [Activity Records](../schemas/activity-record.schema.md). This module runs only when explicitly requested — never automatically.

## Purpose

Establish specific, dated, verifiable evidence of a person's public activity and hiring-related posts, within an explicit lookback window.

## Required Inputs

- One or more Person Records to check.
- An explicit lookback window (`lookback_start_date`, `lookback_end_date`), either user-supplied or confirmed with the user before proceeding.

## Optional Inputs

- A specific role or team the user wants matched against (feeds `matching_role` and `role_relevance_notes`).

## Preconditions

- Activity Verification must have been explicitly requested by the user, or explicitly included as part of a requested Full Journey — see [Full Journey Rule 6](full-journey.md#activity-verification).

## Procedure

1. Check each person's public activity page and posts within the lookback window.
2. Assign `activity_level` per [Activity Level](../schemas/activity-record.schema.md#activity-level): A0 (profile only) through A4 (matching job post found), requiring direct evidence for each level attained.
3. Record `authorship_status` (Authored, Reposted, Shared with Commentary, Unknown) when it can be determined.
4. Record exact `lookback_start_date` and `lookback_end_date`, not relative phrases.
5. Verify `job_status` for any hiring-related post separately from the post's existence — a post being found does not mean the role is still open.
6. Record `verification_status` even when verification fails, rather than omitting the person.

## Outputs

- Activity Records linked to Person Records, with `activity_level`, `verification_status`, and (when applicable) `job_status`.

## Research State Updates

- `activity_verification_status` moves from Not Requested → Draft → Completed when run; stays Not Requested otherwise.

## Quality Gates

- A2 or above requires a specific dated post — see [Activity Record Rules](../schemas/activity-record.schema.md#activity-record-rules), rule 3.
- A3 requires clear hiring-related content — rule 4.
- A4 requires a role meaningfully matching the candidate — rule 5.
- Exact date boundaries are used for lookback checks — rule 7.
- Current job status is verified separately from the post's existence — rule 8.

## Uncertainty Handling

- Failed verification is recorded (`verification_status` of Unable to Verify or Contradicted), not silently dropped — rule 9.
- `job_status` defaults to "Post Found, Current Status Unknown" rather than assuming Verified Open.

## Explicit Non-Actions

- Do not run without an explicit request or explicit Full Journey inclusion.
- Do not infer current job availability from an old post — rule 8.
- Do not treat a profile URL or activity-page URL alone as A2 or above — rules 1–2.
- Do not imply continuous or scheduled monitoring — see [freshness-policy.md](../core/freshness-policy.md), rule 10.

## Related documents

- [../schemas/activity-record.schema.md](../schemas/activity-record.schema.md)
- [../schemas/person-record.schema.md](../schemas/person-record.schema.md)
- [../core/freshness-policy.md](../core/freshness-policy.md)
- [discover-people.md](discover-people.md)
- [full-journey.md](full-journey.md)
