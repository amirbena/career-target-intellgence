# Candidate Intelligence

Adapts the Candidate Profile schema and the Analyze Candidate and Build
Search Criteria workflows for execution inside Claude.

**Canonical sources:** [`schemas/candidate-profile.schema.md`](../../../schemas/candidate-profile.schema.md),
[`schemas/search-criteria.schema.md`](../../../schemas/search-criteria.schema.md),
[`workflows/analyze-candidate.md`](../../../workflows/analyze-candidate.md),
[`workflows/build-search-criteria.md`](../../../workflows/build-search-criteria.md).

## Candidate Profile

Built from a resume, background description, or other candidate-supplied
context. Required sections and fields:

- **Identity** — `candidate_name` (required); `current_location`;
  `location_source` (User-provided / Observed / Assumed / Unknown, required).
- **Professional Level** — `current_title`; `seniority` (Junior / Mid-level /
  Senior / Lead / Staff / Principal / Manager / Unknown, required);
  `years_of_experience`; `target_roles`.
- **Technologies** — `primary_technologies` (substantial, hands-on
  experience); `secondary_technologies` (meaningful but not central);
  `familiar_technologies` (exposure only, not strong experience);
  `technology_evidence`.
- **Professional Domains** — `domains`, `system_types`,
  `business_process_experience`, `integration_experience`,
  `production_experience`.
- **Responsibility and Impact** — `ownership_signals`, `leadership_signals`,
  `mentoring_signals`, `architecture_signals`, `production_support_signals`,
  `measurable_impact`.
- **Preferences and Constraints** — `preferred_roles`, `excluded_roles`,
  `preferred_domains`, `excluded_domains`, `preferred_company_types`,
  `excluded_company_types`, `work_model_preferences`,
  `geographic_constraints`.
- **Evidence and Confidence** — `source_documents`, `user_confirmed_fields`,
  `inferred_fields`, `assumptions`, `uncertainties`, `profile_status` (Draft
  / Approved / Superseded, required), `last_updated_at` (required).

### Rules

1. Never invent experience, technologies, or seniority not supported by the
   source material.
2. Never upgrade a familiar technology to primary or secondary experience.
3. Never infer management or leadership responsibility without direct
   evidence.
4. Preserve explicit user corrections over anything inferred.
5. Keep conflicting evidence visible rather than silently resolving it.
6. Do not rebuild an `Approved` Candidate Profile without a stated reason
   (new information, explicit user correction, or explicit refresh request).
7. Location and commute preferences belong to Search Criteria, not to a
   hardcoded assumption inside the Candidate Profile.

### Procedure

Extract each section from the supplied material, classify technologies into
primary / secondary / familiar, record the provenance of every field
(`user_confirmed_fields` vs. `inferred_fields` vs. `assumptions`), and
present the draft back to the user for confirmation before marking
`profile_status: Approved`.

## Search Criteria

Built from an existing Candidate Profile plus explicit user constraints.
Requires a Candidate Profile to exist first.

- **Search Scope** — `origin_location`, `maximum_commute_minutes` (must stay
  user-configurable for the current search, never a fixed product default),
  `commute_mode` (Driving / Public transit / Walking / Mixed / Not
  applicable), `commute_interpretation`, `preferred_work_models`,
  `acceptable_work_models`.
- **Role Criteria** — `target_roles`, `acceptable_roles`, `excluded_roles`,
  `target_seniority`, `acceptable_seniority`.
- **Technology Criteria** — `preferred_technologies`,
  `acceptable_technologies`, `technology_exclusions`,
  `stack_match_strictness` (Strict / Balanced / Flexible, required — Strict
  requires direct stack overlap; Balanced weighs stack, domain, and system
  fit together; Flexible allows stack differences given strong domain or
  system fit).
- **Domain and Company Criteria** — `preferred_domains`,
  `acceptable_domains`, `excluded_domains`, `preferred_company_types`,
  `acceptable_company_types`, `excluded_company_types`,
  `preferred_company_sizes`.
- **Research Request** — `requested_company_count`,
  `product_companies_only` (boolean, must come from an explicit user
  statement), `include_hybrid_companies`, `activity_lookback_days`,
  `requested_outputs` (Candidate Profile / Target Company Map / Recruiter
  Map / Hiring Manager Map / Activity Verification / Outreach Priority Queue
  / CSV-compatible Export, required).
- **Assumptions and Confirmation** — `user_provided_constraints`,
  `derived_constraints`, `assumptions`, `open_questions`, `criteria_status`
  (Draft / Ready / Superseded, required), `last_updated_at`.

### Rules

1. A user-provided constraint always overrides an inferred one.
2. The commute limit must remain configurable per search — never hardcode a
   default value.
3. A non-blocking gap may be filled with a clearly labeled assumption rather
   than blocking progress.
4. Product-company-only filtering must come from an explicit user statement.
5. The requested company count may vary by request; do not assume a fixed
   number.
6. Activity verification is only in scope when explicitly requested, or
   explicitly included as part of a requested full journey.
7. Search Criteria can be updated without rebuilding the Candidate Profile.
8. Changing a commute or company-type constraint invalidates only the
   downstream results the change actually affects, not the whole journey.
