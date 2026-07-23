# Output Generation

Adapts the canonical output contracts for execution inside Claude. Column
sets and ordering rules are canonical — do not add, drop, rename, or
reorder columns. Use the matching template in [`../templates/`](../templates/)
as the starting structure for any output you produce.

**Canonical sources:** [`core/output-contracts.md`](../../../core/output-contracts.md),
[`outputs/candidate-profile-template.md`](../../../outputs/candidate-profile-template.md),
[`outputs/search-criteria-template.md`](../../../outputs/search-criteria-template.md),
[`outputs/company-map-template.md`](../../../outputs/company-map-template.md),
[`outputs/excluded-companies-template.md`](../../../outputs/excluded-companies-template.md),
[`outputs/people-map-template.md`](../../../outputs/people-map-template.md),
[`outputs/activity-verification-template.md`](../../../outputs/activity-verification-template.md),
[`outputs/outreach-queue-template.md`](../../../outputs/outreach-queue-template.md),
[`outputs/csv-column-contracts.md`](../../../outputs/csv-column-contracts.md).

## Canonical outputs

1. **Candidate Profile** — mirrors `profile_status` (Draft, Approved,
   Superseded). Template: [`candidate-profile.md`](../templates/candidate-profile.md).
2. **Search Criteria** — mirrors `criteria_status` (Draft, Ready,
   Superseded). Template: [`search-criteria.md`](../templates/search-criteria.md).
3. **Target Company Map** — ranked Included and Needs Review companies.
   Ordering: Priority tier, then score descending, then confidence, then
   company name. Verified once classification and ranking are complete;
   Approved once the user reviews it during Company Selection. Template:
   [`company-map.md`](../templates/company-map.md).
4. **Excluded Companies Report** — Company Records with `exclusion_status`
   Excluded or Needs Review. Ordering: Excluded first, then Needs Review,
   alphabetical by company name within each group. Mirrors the underlying
   `record_status`. Template: [`excluded-companies.md`](../templates/excluded-companies.md).
5. **People Map** — Person Records scored per the Person Ranking Model.
   Ordering: by company (matching the Company Map's order), then person
   priority score descending within company. Verified once employment is
   checked; an Approved state is not typically applicable. Template:
   [`people-map.md`](../templates/people-map.md).
6. **Activity Verification Report** — presents A0–A4 evidence; produced only
   when explicitly requested. Ordering: activity level descending (A4
   first), then person within level. Mirrors `verification_status`.
   Template: [`activity-verification.md`](../templates/activity-verification.md).
7. **Outreach Priority Queue** — combined via the Outreach Priority Model.
   Ordering: by queue position per the Recommended Action Order. Draft until
   the user reviews it; there is no further "Approved" state, since the
   user acts on it manually. Template: [`outreach-queue.md`](../templates/outreach-queue.md).
8. **CSV-compatible export** — packages an already-approved output; creates
   no new evidence. May never be produced partially.

## Required columns (exact order)

**Target Company Map (22 columns):** Priority, Score, Company, Relevant
Location, Estimated Commute, Company Type, Product / Domain, Relevant
Roles, Technology Evidence, Technology Scope, Role Fit, Stack Fit, Domain
Fit, System-type Fit, Product-company Fit, Location and Commute Fit,
Relevant Team Evidence, Current Hiring Signal, Confidence, Why It Fits,
Sources, Checked At. The eight scoring-dimension columns must appear in
this exact order, matching the Company Ranking Model.

Every Target Company Map must carry this disclaimer: "The target-company
map is not a claim that every listed company is currently hiring or that
every team uses the same technology stack. Team-level technology and
current hiring status must be verified before outreach."

**Excluded Companies Report (8 columns):** Company, Company Type, Exclusion
Status, Exclusion Reason, Evidence, Confidence, Reconsideration Condition,
Checked At.

**People Map (19 columns):** Company, Person, Current Title, Person Type,
Current Employment, Recruiter Relevance, Managerial Relevance, Team
Relevance, LinkedIn Profile, Activity URL, Recent Activity Status, Hiring
Activity, Matching Job Signal, Last Verified Activity, Priority Score,
Confidence, Duplicate Contact Group, Sources, Checked At.

**Activity Verification Report (16 columns):** Person, Company, Activity
Level, Activity Type, Authorship Status, Post Date, Within Lookback Window,
Hiring Related, Matching Role, Job Status, Post URL, Verification Status,
Confidence, Stale Reason, Refresh Required, Checked At.

**Outreach Priority Queue (15 columns):** Queue Position, Company, Person,
Person Type, Company Priority, Person Priority Score, Evidence Signal,
Recommended Action, Reason, Timing, Status, Follow-up Date, Duplicate
Contact Group, Confidence, Checked At. Recommended Action must be one of
the eight Supported Actions defined in
[`ranking-and-exclusions.md`](ranking-and-exclusions.md).

## CSV-compatible export

CSV columns use stable snake_case names. Conventions: dates as ISO
`YYYY-MM-DD`; timestamps as ISO 8601 `YYYY-MM-DDTHH:MM:SSZ`; lists as
semicolon-separated values in a single cell (for example
`"C#;SQL Server;.NET"`); URLs as plain text; an empty cell only when the
absence itself is meaningful (for example, no `exclusion_reason` for an
Included company); unknown or failed verification uses explicit text
(`Unknown` / `Unable to Verify`), never a blank cell. See
[`core/output-contracts.md`](../../../core/output-contracts.md) and
[`outputs/csv-column-contracts.md`](../../../outputs/csv-column-contracts.md)
for the full per-output column tables — do not re-derive them independently.

## Universal rules

1. Do not combine multiple outputs into one oversized table.
2. Use `Unknown`, `Not Found`, or `Unable to Verify` — never an invented
   value.
3. Every time-sensitive claim needs a `checked_at` date.
4. Confidence is claim-specific, not applied uniformly across a whole
   record.
5. A cited source must actually support the claim next to it.
6. Excluded records stay visible, in their own separate report — never
   silently dropped.
7. Outreach recommendations remain advisory and manual — the Skill never
   performs an outreach action.
8. Producing an output creates no new evidence — it only presents evidence
   already gathered.
9. A CSV export must preserve the same meaning as its Markdown counterpart.
10. Shared templates and examples must contain only synthetic placeholder
    content — never real candidate, company, or person data.

## Ordering and partial-output rules

Produce only the outputs the current request or `requested_outputs`
actually calls for. An output may be produced partially only where its
output contract explicitly allows it (for example, a Company Map that
already lists confirmed companies while others are still being verified);
the CSV-compatible export specifically may never be produced partially,
since it packages an already-approved output rather than in-progress
research.
