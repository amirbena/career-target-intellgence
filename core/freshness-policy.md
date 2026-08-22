# Freshness Policy

This document defines how freshness requirements depend on claim type. It complements [source-policy.md](source-policy.md) (source strength) and [confidence-model.md](confidence-model.md) (how confidence is expressed), and applies to the [Company Record](../schemas/company-record.schema.md), [Person Record](../schemas/person-record.schema.md), and [Activity Record](../schemas/activity-record.schema.md).

There is no single universal expiration period that applies to every field. Freshness expectations depend on how quickly the underlying fact tends to change and on what the claim will be used for.

## Freshness Expectations by Claim Type

| Claim Type | Typical Freshness Expectation |
|---|---|
| Company identity | Slow-changing |
| Product description | Slow-changing |
| Office location | Verify when used for commute decisions |
| Company type | Review when evidence is old or mixed |
| Technology evidence | Prefer recent team- or job-specific evidence |
| Current employment | Current evidence required |
| Public activity | Must fall inside the user-requested lookback window |
| Hiring signal | Recent evidence required |
| Job availability | Current verification required — see [Job Availability Freshness](#job-availability-freshness) |
| Company state (organizational event) | Event-specific — see [Company State Freshness](#company-state-freshness) |
| Commute estimate | Depends on transport mode and traffic assumptions |

## Job Availability Freshness

Job availability is highly time-sensitive. A role used as a current recommendation (entering the [Verified Jobs Map](../outputs/verified-jobs-map-template.md)) must have:

- a current verification attempt (`official_verification_attempted`, `official_verification_result` on the [Job Record](../schemas/job-record.schema.md));
- an exact `job_status_checked_at`.

Do not rely on the listing's own publication date (`source_date`) alone as proof the role remains open — a listing can remain posted long after a role closes. See [job-verification-policy.md](job-verification-policy.md).

## Company State Freshness

Company State evidence uses event-specific freshness, distinguishing three separate questions that must not be collapsed into one:

1. **When did the event happen** — `source_date` on the [Company State Record](../schemas/company-state-record.schema.md).
2. **When was it last checked** — `checked_at`.
3. **Is the impact still relevant to the decision at hand** — `currency_assessment` (`Current`, `Materially Relevant Though Older`, `Likely Superseded`, `Unknown`).

A months-old layoff may still be materially relevant and must not be auto-expired just because it falls outside the (much shorter) job-verification freshness window — the two freshness clocks are independent. `currency_assessment` of `Likely Superseded` is the only case that should be treated like an expired claim, and it requires a `stale_reason`.

## Key Concepts

- **`checked_at`** — the timestamp when a record or field was last checked, regardless of when the underlying source itself was published.
- **`source_date`** — the date the underlying source (a post, a listing, a page) was published or last updated, when known.
- **`lookback_start_date`** — the explicit start of a requested activity or hiring lookback window.
- **`lookback_end_date`** — the explicit end of a requested activity or hiring lookback window.
- **`stale_reason`** — a short explanation of why a claim is considered stale (e.g., "source_date older than requested lookback window").
- **`refresh_required`** — whether the affected claim needs to be re-checked before it can be used with confidence.

## Freshness Rules

1. Use exact dates for time windows.
2. Do not rely only on phrases like "recently" or "three months ago."
3. A user-requested three-month check must use explicit start and end dates.
4. Historical evidence may remain useful for fit, but not for current hiring claims.
5. Current employment requires current evidence.
6. Old job posts should default to unknown current status.
7. A stale field does not automatically make the entire record unusable.
8. Refresh only the affected public research, not stable candidate information.
9. Refresh activity or hiring information only after an explicit user request.
10. Do not imply continuous monitoring.
11. Job-status freshness and company-state freshness are independent clocks; a stale company-state event does not invalidate a fresh job verification, and a stale job verification does not invalidate a still-relevant company-state event.
12. Refreshing a stale job verification must not force a Candidate Profile rebuild; refreshing a stale company-state event must not auto-invalidate stable company identity data.

## Related documents

- [source-policy.md](source-policy.md)
- [confidence-model.md](confidence-model.md)
- [quality-gates.md](quality-gates.md)
- [data-model.md](data-model.md)
- [job-verification-policy.md](job-verification-policy.md)
- [../schemas/research-state.schema.md](../schemas/research-state.schema.md)
- [../schemas/job-record.schema.md](../schemas/job-record.schema.md)
- [../schemas/company-state-record.schema.md](../schemas/company-state-record.schema.md)
