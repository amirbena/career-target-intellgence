# Company Intelligence

Adapts the Company Record schema and the Discover Companies and Classify and
Rank Companies workflows for execution inside Claude. Scoring weights and
bands live in [`ranking-and-exclusions.md`](ranking-and-exclusions.md) — do
not restate or re-derive them here.

**Canonical sources:** [`schemas/company-record.schema.md`](../../../schemas/company-record.schema.md),
[`workflows/discover-companies.md`](../../../workflows/discover-companies.md),
[`workflows/classify-and-rank-companies.md`](../../../workflows/classify-and-rank-companies.md).

## Company Record

- **Identity** — `company_name` (required), `website_url`,
  `linkedin_company_url`, `company_description`, `company_status` (Active /
  Acquired / Closed / Unknown, required).
- **Location** — `office_locations`, `relevant_location`,
  `estimated_commute_minutes`, `commute_mode`, `commute_confidence`
  (Estimated / Verified, required), `location_evidence`.
- **Company Classification** — `company_type` (Product / Product-led
  Enterprise / Hybrid Product and Services / Consulting / Outsourcing /
  System Integrator / Staffing / Project-based Development / Unclear,
  required), `company_type_confidence` (Low / Medium / High),
  `company_type_evidence`.
- **Product and Domain** — `products`, `industries`, `business_domains`,
  `system_types`, `customer_types`.
- **Technology Evidence** — `known_technologies`, `technology_evidence`,
  `technology_scope` (Company-wide / Business Unit / Team-specific /
  Job-specific / Historical / Unknown, required), `technology_confidence`
  (Low / Medium / High, required).
- **Candidate Relevance** — `relevant_roles`, `possible_relevant_teams`,
  `role_fit_notes`, `stack_fit_notes`, `domain_fit_notes`,
  `system_fit_notes`, `location_fit_notes`. No numeric score is stored on
  the record itself — scores are computed by the ranking model.
- **Hiring Evidence** — `career_page_url`, `current_role_evidence`,
  `general_hiring_signal`, `hiring_signal_date`, `hiring_signal_status`
  (Verified Current Role / Recent Hiring Signal / Historical Hiring Signal /
  No Signal Found / Unable to Verify, required).
- **Evidence and Lifecycle** — `sources`, `checked_at` (required),
  `confidence` (Low / Medium / High, required), `record_status` (Draft /
  Verified / Approved / Stale / Superseded, required), `exclusion_status`
  (Included / Excluded / Needs Review, required), `exclusion_reason`,
  `stale_reason` (required when `record_status` is Stale),
  `refresh_required` (boolean or Unknown — never implies an automatic
  refresh).

### Rules

1. Keep identity evidence separate from relevance evidence.
2. Keep current-hiring evidence separate from general suitability.
3. Qualify every technology claim with its `technology_scope` — a single job
   posting is job-specific evidence, not company-wide.
4. Preserve uncertainty when `company_type` is genuinely unclear rather than
   forcing a classification.
5. Every excluded record needs an `exclusion_reason`.
6. Never invent locations, teams, technologies, or roles not supported by
   evidence.
7. Every mutable claim needs a source and a `checked_at` date.
8. Suitability is not the same as current hiring — never conflate them.
9. `stale_reason` is required whenever `record_status` is Stale.
10. `refresh_required` only follows an explicit user request, never an
    implied schedule.

## Discovery procedure

Discovery is deliberately broad — it identifies a candidate set of companies
from Search Criteria without classifying or scoring them yet (that happens
in the next stage).

1. Identify companies matching the Search Criteria's role, domain, and
   location signals.
2. Populate Identity and Location fields with sourced evidence.
3. Leave Company Classification, Candidate Relevance, and ranking fields for
   the classification stage.
4. Set `record_status: Draft`.

Do not imply that a discovered company is hiring. Do not rank companies
before they are classified. Discovery runs once per request — it is not a
recurring or background process.

## Classification procedure

Operates on Draft Company Records from discovery.

1. Classify `company_type` with confidence and evidence. Never classify from
   branding or marketing language alone.
2. Apply the Exclusion Policy (see
   [`ranking-and-exclusions.md`](ranking-and-exclusions.md)) to set
   `exclusion_status`. An Unclear `company_type` routes to Needs Review, not
   an automatic Excluded.
3. For Included and Needs Review companies, apply the full Company Ranking
   Model (see [`ranking-and-exclusions.md`](ranking-and-exclusions.md)) to
   compute a score and Priority tier. A Needs Review company's score is
   provisional and must be labeled as such, not treated as a final tier.
4. Retain Excluded companies in a separate exclusion report — never drop
   them silently.

### Re-scoring

When a change affects only some scoring dimensions (for example, "change
commute to 20 minutes"), re-score only the affected dimensions rather than
the whole record. The full re-scoring trigger list and six-step process are
defined once, in
[`ranking-and-exclusions.md`](ranking-and-exclusions.md) — follow it exactly
rather than restating it here.
