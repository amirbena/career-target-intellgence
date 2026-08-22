# Current Job Verification Policy

This document defines how the current availability of one specific role (a [Job Record](../schemas/job-record.schema.md)) is decided. It is the canonical policy referenced by [source-policy.md](source-policy.md), [freshness-policy.md](freshness-policy.md), [quality-gates.md](quality-gates.md), the [Job Eligibility Gate](../ranking/job-eligibility-gate.md), the [Job Search Journey](../workflows/job-search-journey.md), and every platform-specific adaptation. It applies whenever the product is asked to find, verify, or refresh currently open jobs — the default job-search intent described in [product-definition.md](product-definition.md).

## Why This Exists

None of the following, on their own, prove that a specific role is currently open:

- a company being attractive or generally hiring;
- a recruiter's hiring-related post;
- a LinkedIn job page;
- a Glassdoor listing;
- an Indeed listing;
- a listing on any other job board or aggregator;
- a search-result snippet;
- historical hiring evidence.

Each of the above may be valid **discovery** evidence — a reasonable starting point for further verification — but none of them is **verification** evidence by itself. This policy exists to keep that distinction structural, not a matter of wording discipline alone.

## Source Hierarchy for Current Availability

From strongest to weakest:

1. **Official company careers site** — the company's own careers page or job listing.
2. **Official ATS or job page linked/controlled by the company** — a third-party-hosted application system (e.g., Greenhouse, Lever) that the company itself operates or explicitly links to as its own.
3. **Other official company recruitment source** — e.g., an official company careers-related social account explicitly confirming a specific opening.

Third-party discovery sources — LinkedIn Jobs, Glassdoor, Indeed, other aggregators, recruiter posts, and search-result snippets — may **discover** a role. They must not, by themselves, produce a `job_status` of Verified Open.

## Mandatory Cross-Check Rule

> When a role is discovered via a secondary source, attempt to verify it against the company's official careers site or official ATS whenever that site is publicly accessible.

This attempt must happen before a role can be treated as a primary, high-confidence recommendation, and the attempt itself — whether it succeeded, failed, or was not possible — must be recorded (`official_verification_attempted`, `official_verification_result`, `official_verification_url` on the [Job Record](../schemas/job-record.schema.md)).

## Verification Outcomes

| Situation | `job_status` | Notes |
|---|---|---|
| Exact/clearly corresponding role found on an official source, and that source appears current/usable | `Verified Open` | Record both the discovery source and the official source, the verification URL, and `job_status_checked_at`. |
| Role found via a third-party source; official site unavailable or inaccessible | `Unable to Verify` | Not Verified Open. Record the failed verification attempt (`official_verification_result`: `Site Inaccessible`). Not eligible as a primary recommendation. |
| Role found via a third-party source; official careers site is accessible; role not found there | `Not Found on Official Site` | Do not silently discard the lead and do not auto-mark Closed. Preserve the external lead and the failed-match record. This state must substantially reduce or prevent primary job recommendation eligibility — see [job-eligibility-gate.md](../ranking/job-eligibility-gate.md). |
| Official page explicitly states the role is closed, expired, or no longer accepting applications | `Closed` | Record the exact verification date and the closure evidence. Excluded from the primary Verified Jobs Map. |
| Only a search-result snippet exists | Not a verification outcome | A snippet is a discovery lead only — proceed to attempt official verification before assigning any `job_status` implying availability. |
| Role found on an official source, but the source's freshness or usability is itself uncertain (e.g., ambiguous page state) | `Likely Open / Partially Verified` | Use only when official evidence exists but is not fully conclusive; must appear in a clearly separate, lower-confidence section — never presented as equivalent to Verified Open. |

## Absence Is Not Closure

> Absence from an official careers search is evidence that verification failed or the listing may be stale; it is not automatically proof of closure unless the official source or other direct evidence establishes closure.

This is the load-bearing distinction between `Not Found on Official Site` and `Closed`. Only direct closure evidence (an explicit "closed"/"expired"/"no longer accepting applications" statement, or equivalent) may produce `Closed`.

## Company State Does Not Gate Job Availability

Company State evidence (layoffs, hiring freezes, restructuring, and the other [Company State Record](../schemas/company-state-record.schema.md) event types) must never automatically change a Job Record's `job_status`:

- A verified open role at a company with a recent layoff may remain `Verified Open` — the layoff is surfaced alongside the role as separate context, not merged into the availability claim.
- A hiring freeze evidenced in the *specific relevant org* may reduce confidence and should be disclosed, but does not by itself flip `job_status` to Closed absent direct closure evidence for that specific role.
- Layoffs in an unrelated business unit must not automatically taint a role in the candidate's target team.
- Growth or funding signals do not themselves prove any specific role is open; they remain company-level context, not job-level verification.

Job availability, Company health/state, and Candidate fit are three distinct claims and must never be merged into one silent score — see [job-eligibility-gate.md](../ranking/job-eligibility-gate.md) and [company-ranking-model.md](../ranking/company-ranking-model.md).

## Source-Specific Guidance

| Discovery source | `discovery_source_type` | Can it alone produce Verified Open? | Required next step |
|---|---|---|---|
| Official company careers site | Official Careers | Yes, when current/usable | None beyond recording the checked date. |
| Official ATS/job page the company controls or explicitly links | Official Careers | Yes, when current/usable | None beyond recording the checked date. |
| LinkedIn Jobs | LinkedIn | No | Attempt official-site cross-check. |
| Glassdoor | Glassdoor | No | Attempt official-site cross-check. |
| Indeed | Indeed | No | Attempt official-site cross-check. |
| Other job board/aggregator | Other Job Board | No | Attempt official-site cross-check. |
| Recruiter's hiring-related post | Recruiter Post | No | Attempt official-site cross-check; treat the post as Activity evidence per [activity-record.schema.md](../schemas/activity-record.schema.md), not as job verification. |
| Search-result snippet | Search Result | No | Treat as a discovery lead only; attempt official-site cross-check before any further use. |

## Policy Rules

1. A LinkedIn/Glassdoor/Indeed/other-board/recruiter-post/search-snippet discovery alone must never produce `job_status` of Verified Open.
2. When a role is discovered via a secondary source, attempt official-site/ATS cross-check whenever the official source is publicly accessible; record the attempt regardless of outcome.
3. Absence from an official careers search is evidence of a failed or inconclusive verification attempt, not proof of closure.
4. `Closed` requires direct closure evidence, dated and sourced.
5. `Not Found on Official Site` preserves the lead; it does not silently drop it and does not auto-become `Closed`.
6. `Unable to Verify` applies when the official source itself could not be reached or assessed.
7. Company State evidence is surfaced alongside a Job Record, never merged into `job_status`.
8. A `Likely Open / Partially Verified` role must appear in a clearly separate, lower-confidence section of any job output — never presented as equivalent to Verified Open.
9. Every `job_status` decision carries an exact `job_status_checked_at`; relative language ("recently," "still likely open") is not a substitute.
10. This policy governs how public evidence is weighed; it does not define or authorize scraping, access-control bypass, or automated monitoring — see [scope-and-non-goals.md](scope-and-non-goals.md).

## Related documents

- [source-policy.md](source-policy.md)
- [freshness-policy.md](freshness-policy.md)
- [confidence-model.md](confidence-model.md)
- [quality-gates.md](quality-gates.md)
- [data-model.md](data-model.md)
- [product-definition.md](product-definition.md)
- [../schemas/job-record.schema.md](../schemas/job-record.schema.md)
- [../schemas/company-state-record.schema.md](../schemas/company-state-record.schema.md)
- [../ranking/job-eligibility-gate.md](../ranking/job-eligibility-gate.md)
- [../workflows/job-search-journey.md](../workflows/job-search-journey.md)
