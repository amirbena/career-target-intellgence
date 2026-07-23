# Output Contracts

This document defines the canonical outputs produced by the product, downstream of the [data model](data-model.md), [trust policy](source-policy.md), [ranking models](../ranking/company-ranking-model.md), and [workflow](workflow.md). Each output has a dedicated template in [outputs/](../outputs/) and, where applicable, a CSV-compatible column contract in [outputs/csv-column-contracts.md](../outputs/csv-column-contracts.md).

## Canonical Outputs

### Candidate Profile

- **Purpose:** Present the candidate's professional background for user confirmation.
- **Required source records:** [Candidate Profile](../schemas/candidate-profile.schema.md).
- **Required sections:** See [outputs/candidate-profile-template.md](../outputs/candidate-profile-template.md).
- **Minimum verification requirements:** Fields are sourced or explicitly marked as assumptions/inferences per [Candidate Profile Evidence and Confidence](../schemas/candidate-profile.schema.md#evidence-and-confidence).
- **Unknown/unavailable handling:** Unknown fields are shown as Unknown, never guessed.
- **Ordering:** Follows the section order in the template.
- **Draft/Verified/Approved:** Mirrors `profile_status` (Draft, Approved, Superseded) on the underlying record.
- **May be produced partially:** Yes — a Draft profile with open uncertainties may still be shown for user review.

### Search Criteria

- **Purpose:** Present the search parameters that will guide company discovery, for user confirmation.
- **Required source records:** [Search Criteria](../schemas/search-criteria.schema.md).
- **Required sections:** See [outputs/search-criteria-template.md](../outputs/search-criteria-template.md).
- **Minimum verification requirements:** None beyond capturing user-provided constraints accurately; this output does not involve public research.
- **Unknown/unavailable handling:** An unset constraint is shown as Not specified, not defaulted silently.
- **Ordering:** Follows the section order in the template.
- **Draft/Verified/Approved:** Mirrors `criteria_status` (Draft, Ready, Superseded).
- **May be produced partially:** Yes — a Draft set of criteria may be shown before it is Ready.

### Target Company Map

- **Purpose:** Present ranked, Included/Needs-Review companies for outreach planning.
- **Required source records:** [Company Records](../schemas/company-record.schema.md), scored per the [Company Ranking Model](../ranking/company-ranking-model.md).
- **Required sections/columns:** See [outputs/company-map-template.md](../outputs/company-map-template.md).
- **Minimum verification requirements:** Identity and location claims sourced; technology claims scoped; every mutable claim includes `checked_at`.
- **Unknown/unavailable handling:** Missing evidence on a dimension is shown as Unknown, not a zero implying disproof.
- **Ordering:** Priority tier, then score descending, then confidence, then company name.
- **Draft/Verified/Approved:** Verified once classification and ranking are complete; Approved once the user has reviewed it (Company Selection).
- **May be produced partially:** Yes — a partial map may be shown while discovery is still in progress, clearly labeled as such.

### Excluded Companies Report

- **Purpose:** Keep excluded and Needs-Review companies visible with their reasons, rather than silently dropped.
- **Required source records:** Company Records with `exclusion_status` of Excluded or Needs Review.
- **Required sections/columns:** See [outputs/excluded-companies-template.md](../outputs/excluded-companies-template.md).
- **Minimum verification requirements:** An `exclusion_reason` is required for Excluded records.
- **Unknown/unavailable handling:** Insufficient evidence is itself a valid, stated exclusion reason.
- **Ordering:** Excluded records first, then Needs Review, each alphabetical by company name.
- **Draft/Verified/Approved:** Mirrors the underlying Company Record's `record_status`.
- **May be produced partially:** Yes — grows incrementally as classification proceeds.

### People Map

- **Purpose:** Present discovered recruiters and potential hiring managers per company.
- **Required source records:** [Person Records](../schemas/person-record.schema.md), scored per the [Person Ranking Model](../ranking/person-ranking-model.md).
- **Required sections/columns:** See [outputs/people-map-template.md](../outputs/people-map-template.md).
- **Minimum verification requirements:** Current employment verified or marked unresolved; profile URLs never fabricated.
- **Unknown/unavailable handling:** Unresolved employment or activity status is shown explicitly, not omitted.
- **Ordering:** By company (matching the Company Map order), then by person priority score descending within each company.
- **Draft/Verified/Approved:** Verified once employment status has been checked; Approved is not typically applicable to this output.
- **May be produced partially:** Yes — companies without an identified contact may still appear with an empty entry noting "no contact identified."

### Activity Verification Report

- **Purpose:** Present A0–A4 activity evidence for discovered people, only when explicitly requested.
- **Required source records:** [Activity Records](../schemas/activity-record.schema.md).
- **Required sections/columns:** See [outputs/activity-verification-template.md](../outputs/activity-verification-template.md).
- **Minimum verification requirements:** A2+ requires a specific dated post; job status verified separately from post existence.
- **Unknown/unavailable handling:** Failed verification is reported, not omitted.
- **Ordering:** By activity level descending (A4 first), then by person within each level.
- **Draft/Verified/Approved:** Mirrors the underlying Activity Record's `verification_status`.
- **May be produced partially:** Yes — only for the people actually checked; it must not imply the full People Map was verified.

### Outreach Priority Queue

- **Purpose:** Present a prioritized, advisory list of manual outreach actions.
- **Required source records:** Ranked Company Records, Person Records, and (when available) Activity Records, combined per the [Outreach Priority Model](../ranking/outreach-priority-model.md).
- **Required sections/columns:** See [outputs/outreach-queue-template.md](../outputs/outreach-queue-template.md).
- **Minimum verification requirements:** Recommendations reflect the evidence level actually available; stale evidence never presented as current.
- **Unknown/unavailable handling:** When employment or activity is unresolved, the recommended action is capped accordingly (see [build-outreach-queue.md](../workflows/build-outreach-queue.md)).
- **Ordering:** By queue position, following the [Recommended Action Order](../ranking/outreach-priority-model.md#recommended-action-order).
- **Draft/Verified/Approved:** Draft until the user reviews it; there is no further "Approved" state — the user acts on it directly and manually.
- **May be produced partially:** Yes — entries may be added incrementally as company/person/activity evidence becomes available.

### CSV-compatible export

- **Purpose:** Package an already-approved output as a CSV-compatible text representation with the same meaning as its Markdown counterpart.
- **Required source records:** The approved output being exported.
- **Required sections/columns:** See [outputs/csv-column-contracts.md](../outputs/csv-column-contracts.md).
- **Minimum verification requirements:** None beyond what the source output already satisfies — export does not create new evidence.
- **Unknown/unavailable handling:** Unknown/Unable to Verify values are preserved as explicit text, never left as an empty cell that could be misread as zero or false.
- **Ordering:** Matches the source output's ordering.
- **Draft/Verified/Approved:** Matches the source output's status; export itself has no separate status beyond `export_status` on Research State.
- **May be produced partially:** No — export packages what already exists; it is not a research step that can be "partially" run.

## Universal Rules

1. Do not combine all outputs into one oversized table.
2. Use Unknown, Not Found, or Unable to Verify rather than inventing values.
3. Time-sensitive public information must include `checked_at`.
4. Confidence must remain claim-specific.
5. Sources must support the nearby claims.
6. Excluded records must remain visible in a separate report.
7. Outreach recommendations must remain advisory and manual.
8. Output generation does not create new evidence.
9. CSV-compatible output must preserve the same meaning as Markdown output.
10. Shared templates must contain only synthetic examples.

## Related documents

- [data-model.md](data-model.md)
- [workflow.md](workflow.md)
- [quality-gates.md](quality-gates.md)
- [../ranking/outreach-priority-model.md](../ranking/outreach-priority-model.md)
- [../outputs/csv-column-contracts.md](../outputs/csv-column-contracts.md)
