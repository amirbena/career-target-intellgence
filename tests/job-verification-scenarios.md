# Job Verification Scenarios

Eight fully synthetic scenarios exercising [`core/job-verification-policy.md`](../core/job-verification-policy.md) and [`ranking/job-eligibility-gate.md`](../ranking/job-eligibility-gate.md). Every company, person, and role below is fictional. Each scenario states the fixture, the canonical rule(s) it exercises, and the expected outcome.

## Scenario 1 — LinkedIn discovery confirmed on the official site → Verified Open

**Fixture:** A "Senior Backend Engineer" role at synthetic company "Northbridge Systems" is discovered via a LinkedIn Jobs listing. The same exact role is also found, current and usable, on Northbridge Systems' official careers page.

**Exercises:** [job-verification-policy.md — Verification Outcomes](../core/job-verification-policy.md#verification-outcomes), row 1.

**Expected outcome:** `job_status: Verified Open`. Both `discovery_source` (LinkedIn) and `official_verification_url` (the official careers page) are recorded, along with an exact `job_status_checked_at`. The role is eligible for Gate A of the [Primary Job Eligibility Gate](../ranking/job-eligibility-gate.md#gate-a--availability).

## Scenario 2 — Glassdoor discovery, official site accessible, role not found there → NOT Verified Open

**Fixture:** A "Backend Engineer" role at synthetic company "Meridian Retail Systems" is discovered via a Glassdoor listing. Meridian Retail Systems' official careers page is reachable and searchable, but this specific role does not appear there.

**Exercises:** [job-verification-policy.md — Verification Outcomes](../core/job-verification-policy.md#verification-outcomes), row 3; [Absence Is Not Closure](../core/job-verification-policy.md#absence-is-not-closure).

**Expected outcome:** `job_status: Not Found on Official Site` — never `Closed`, never silently discarded. `official_verification_attempted: true`, `official_verification_result: Not Found`. The external Glassdoor lead is preserved. `record_disposition: Rejected Lead`, `rejection_reason: Not Found on Official Site`. Appears in the [Unverified and Rejected Job Leads](../outputs/unverified-job-leads-template.md) output, not the Verified Jobs Map.

## Scenario 3 — LinkedIn discovery, official site inaccessible → Unable to Verify

**Fixture:** A "Platform Engineer" role at synthetic company "Riverton Analytics" is discovered via LinkedIn. Riverton Analytics' official careers site returns an error / cannot be reached during the check.

**Exercises:** [job-verification-policy.md — Verification Outcomes](../core/job-verification-policy.md#verification-outcomes), row 2.

**Expected outcome:** `job_status: Unable to Verify`, not Verified Open. `official_verification_attempted: true`, `official_verification_result: Site Inaccessible`. Not eligible as a primary recommendation; `record_disposition: Rejected Lead`, `rejection_reason: Unable to Verify`.

## Scenario 4 — Official page explicitly closed → Closed

**Fixture:** A "Staff Backend Engineer" role at synthetic company "Northbridge Systems" was previously discovered on the official careers page. On re-check, the same official page now states "This position is no longer accepting applications," dated.

**Exercises:** [job-verification-policy.md — Verification Outcomes](../core/job-verification-policy.md#verification-outcomes), row 4.

**Expected outcome:** `job_status: Closed`, with the exact verification date and the closure evidence recorded in `job_status_evidence`. Excluded from the primary Verified Jobs Map; `record_disposition: Rejected Lead`, `rejection_reason: Closed`.

## Scenario 5 — Verified open role, but violates candidate's geographic hard constraint → excluded for fit reason

**Fixture:** A "Senior Backend Engineer (US-based)" role at synthetic company "Northbridge Systems" is `job_status: Verified Open` (confirmed on the official careers page, on-site in Austin, Texas). The candidate's Search Criteria state a hard geographic constraint of "central Israel only."

**Exercises:** [job-eligibility-gate.md — Gate B](../ranking/job-eligibility-gate.md#gate-b--candidate-fit).

**Expected outcome:** Gate A passes (`Verified Open`), but Gate B fails: `fit_gate_result: Fails — Hard Constraint`, `fit_gate_reason` names the geographic constraint. `record_disposition: Rejected Lead`, `rejection_reason: Location mismatch`. The role does not appear in the primary Verified Jobs Map despite being confirmed open, and company attractiveness does not override the exclusion.

## Scenario 6 — Verified open role at a company with significant recent restructuring/layoff evidence → job may remain open; Company State is a distinct, separately labeled signal

**Fixture:** A "Senior Backend Engineer" role at synthetic company "Northbridge Systems" is `job_status: Verified Open`, passes the candidate-fit gate. Separately, a synthetic Company State Record documents that Northbridge Systems announced an ~8% workforce reduction one month prior, concentrated in the sales organization (a business unit distinct from the role's engineering team).

**Exercises:** [core/job-verification-policy.md — Company State Does Not Gate Job Availability](../core/job-verification-policy.md#company-state-does-not-gate-job-availability); [schemas/company-state-record.schema.md — Rules](../schemas/company-state-record.schema.md#company-state-record-rules), rule 8.

**Expected outcome:** The role remains `Verified Open` and enters the Verified Jobs Map. The layoff appears as a separate Company-State Summary alongside the role — `event_description` (Fact: "~8% workforce reduction, concentrated in sales, announced [date]") kept visibly distinct from `candidate_impact_assessment` (Supported Inference: "engineering hiring for this team does not appear directly affected, though not separately confirmed"). The layoff does not remove the role from the map and is not silently merged into `job_status` or `fit_gate_result`.

## Scenario 7 — Company highly relevant but no current matching role → eligible for Company Targeting mode, not represented as a current job match

**Fixture:** Synthetic company "Coastal Freight Partners" scores well under the [Company Ranking Model](../ranking/company-ranking-model.md) (strong role/stack/domain fit), but no Job Record for this company currently has `record_disposition: Primary Candidate` — every discovered role is either closed or not found on the official site.

**Exercises:** [ranking/exclusion-policy.md — Relationship to Job-Level Rejection](../ranking/exclusion-policy.md#relationship-to-job-level-rejection); [core/quality-gates.md — Company Map](../core/quality-gates.md#company-map).

**Expected outcome:** Coastal Freight Partners remains `exclusion_status: Included` and appears in the [Target Company Map](../outputs/company-map-template.md) under the Company Targeting Journey with its full company-level score. It does **not** appear in the Verified Jobs Map, and any presentation of it explicitly states that no current matching role was found — it is never presented or implied as a current job match.

## Scenario 8 — Recruiter has a hiring post for a matching role, but current role status cannot be verified → activity evidence remains valid; job does not become Verified Open

**Fixture:** A synthetic recruiter, "Jordan Ashkenazi" (Technical Recruiter, Northbridge Systems, current employment verified), posts a dated, hiring-related LinkedIn post announcing a "Senior Backend Engineer" opening. Northbridge Systems' official careers page cannot currently be reached to cross-check this specific role.

**Exercises:** [core/job-verification-policy.md — Source-Specific Guidance](../core/job-verification-policy.md#source-specific-guidance) (Recruiter Post row); [schemas/activity-record.schema.md — Job Signal](../schemas/activity-record.schema.md#job-signal).

**Expected outcome:** The Activity Record remains valid and useful: `activity_level: A3 — Hiring-related Post Found` (or `A4` if the post itself meaningfully matches the candidate), `verification_status: Verified` for the post's own existence and content. However, the corresponding Job Record's `job_status` does **not** become `Verified Open` from the recruiter post alone — official verification was attempted and failed, so `job_status: Unable to Verify`. The recruiter relationship and the post remain valid, separately-tracked evidence; they are not treated as job verification.

## Related documents

- [../core/job-verification-policy.md](../core/job-verification-policy.md)
- [../ranking/job-eligibility-gate.md](../ranking/job-eligibility-gate.md)
- [../schemas/job-record.schema.md](../schemas/job-record.schema.md)
- [../schemas/company-state-record.schema.md](../schemas/company-state-record.schema.md)
- [quality-gate-checklist.md](quality-gate-checklist.md)
