# People Intelligence

Adapts the Person Record schema and the Discover People workflow for
execution inside Claude. Person scoring weights and bands live in
[`ranking-and-exclusions.md`](ranking-and-exclusions.md) — do not restate or
re-derive them here.

**Canonical sources:** [`schemas/person-record.schema.md`](../../../schemas/person-record.schema.md),
[`workflows/discover-people.md`](../../../workflows/discover-people.md).

## Person Record

- **Identity** — `person_name` (required), `company_name` (required),
  `current_title`, `linkedin_profile_url`, `profile_status` (Available /
  Unavailable / Ambiguous / Unknown, required — distinct from the Candidate
  Profile's own `profile_status` field).
- **Person Type** — `person_type` (required; one of: Recruiter, Technical
  Recruiter, Talent Acquisition, Talent Sourcer, Recruitment Lead, HR
  Business Partner, People Partner, Team Lead, Engineering Manager, Group
  Manager, Director of Engineering, Head of R&D, VP R&D, Other, Unclear),
  `person_type_evidence`.
- **Employment Verification** — `current_employment_status` (Current /
  Former / Unclear / Unable to Verify, required), `employment_verification`,
  `employment_evidence`, `employment_checked_at` (required).
- **Candidate Relevance** — `recruiting_relevance`, `managerial_relevance`,
  `team_relevance`, `domain_relevance`, `technology_relevance`,
  `relevance_notes`. No numeric person score is stored on the record itself.
- **Public Links** — `activity_url`, `public_contact_path`,
  `source_profile_urls`.
- **Activity Summary** — `latest_activity_record_reference`,
  `recent_activity_status`, `recent_hiring_activity_status`,
  `matching_job_activity_status` (each: Verified / Partially Verified /
  Unable to Verify / Not Checked, required).
- **Evidence and Lifecycle** — `sources`, `checked_at` (required),
  `confidence` (Low / Medium / High, required), `record_status` (Draft /
  Verified / Approved / Stale / Superseded, required), `duplicate_risk` (Low
  / Medium / High, required), `ambiguity_notes`, `stale_reason` (required
  when Stale), `refresh_required`, `duplicate_contact_group` (optional
  label, for output deduplication only — not a database identifier).

### Recruiter vs. hiring manager distinctions

Recruiter-family types (Recruiter, Technical Recruiter, Talent Acquisition,
Talent Sourcer, Recruitment Lead) are relevant primarily through
`recruiting_relevance`. Manager-family types (Team Lead, Engineering
Manager, Group Manager, Director of Engineering, Head of R&D, VP R&D) are
relevant primarily through `managerial_relevance` and `team_relevance`. HR
Business Partner and People Partner sit between the two and should not
automatically inherit full recruiter or manager relevance without specific
evidence. Never state that a manager "will manage" the candidate — prefer
"may manage a relevant team" or "appears relevant to this role family."

### Duplicate lifecycle fields

`duplicate_risk` describes identity ambiguity — the possibility that this
record represents a different person who happens to share a name.
`duplicate_contact_group` is a separate, optional output-deduplication label
for records the researcher has already determined represent overlapping or
intentionally grouped contacts. The two fields may coexist on one record.
`duplicate_contact_group` never authorizes merging or deleting a record —
both records stay individually traceable.

### Rules

1. Verify current employment before treating a person as an active contact.
2. Distinguish recruiters from general HR contacts by type and evidence, not
   by title similarity alone.
3. Distinguish team relevance from title similarity — a matching title at
   the wrong team or business unit is not automatically relevant.
4. Never treat an Activity URL alone as proof of recent activity.
5. Never treat an old hiring post as evidence of current hiring.
6. Preserve name ambiguity rather than resolving it without evidence.
7. Never fabricate a LinkedIn or profile URL.
8. Every time-sensitive field needs a `checked_at` date.
9. Use only public information — no private-contact enrichment.
10. `stale_reason` is required whenever `record_status` is Stale.
11. `refresh_required` only follows an explicit user request.
12. `duplicate_contact_group` supports output deduplication only; it never
    triggers an automatic merge or deletion.
13. `duplicate_risk` and `duplicate_contact_group` may both apply to the
    same record at once.

## Discovery procedure

Requires at least one company already identified (selected from the Company
Map, or explicitly supplied by the user).

1. Identify candidate people across the relevant `person_type` values for
   the request (for example, restrict to Engineering Manager / Group
   Manager / Director of Engineering / Head of R&D / VP R&D when the user
   asks specifically for managers).
2. Verify current employment — mark `current_employment_status` as Unclear
   or Unable to Verify rather than assuming Current when evidence is
   insufficient.
3. Populate Candidate Relevance fields, distinguishing recruiting relevance
   from managerial relevance.
4. Apply the Person Ranking Model (see
   [`ranking-and-exclusions.md`](ranking-and-exclusions.md)) once activity
   evidence is available.
5. Note `duplicate_risk` for people sharing a name with another candidate
   contact.

Do not treat an Activity URL as activity proof, an old post as current
hiring evidence, or a title match as a management claim. Do not perform
private-contact enrichment.
