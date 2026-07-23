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
| Job availability | Current verification required |
| Commute estimate | Depends on transport mode and traffic assumptions |

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

## Related documents

- [source-policy.md](source-policy.md)
- [confidence-model.md](confidence-model.md)
- [quality-gates.md](quality-gates.md)
- [data-model.md](data-model.md)
- [../schemas/research-state.schema.md](../schemas/research-state.schema.md)
