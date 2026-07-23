# Confidence Model

This document defines the six evidence states used to describe how well a claim is supported, and the wording rules that follow from each state. It complements [source-policy.md](source-policy.md) (what sources can support) and [freshness-policy.md](freshness-policy.md) (how long a claim stays usable).

Confidence is **claim-specific, not automatically record-wide**. A single Company Record may legitimately contain a verified location, a supported-inference technology fit, an unverified team relevance, and a stale hiring signal, all at the same time. Assigning one confidence value to an entire record and letting it stand in for every field inside it is not permitted.

## Evidence States

### Verified

- **Meaning:** Direct or sufficiently corroborated evidence supports the claim exactly as stated.
- **Minimum evidence:** A direct, checkable source, or multiple independent sources in agreement.
- **Allowed wording:** State the claim directly, e.g. "The company lists Tel Aviv as an office location."
- **Forbidden wording:** None beyond the general prohibition on overstating certainty (see [source-policy.md](source-policy.md)).
- **May drive an outreach recommendation:** Yes.

### Supported Inference

- **Meaning:** Available evidence reasonably supports the conclusion, but the exact claim is not directly confirmed.
- **Minimum evidence:** At least one relevant, scoped piece of evidence (e.g., a team-specific job post).
- **Allowed wording:** Frame as a possibility tied to its evidence, e.g. "The team may use .NET, based on a recent team-specific job post."
- **Forbidden wording:** Do not state the inferred claim as fact, e.g. do not say "The company uses C#" based on one isolated role.
- **May drive an outreach recommendation:** Yes, with the inference explicitly disclosed.

### Unverified

- **Meaning:** A plausible claim exists but evidence is insufficient to support even a supported inference.
- **Minimum evidence:** None required to record the claim, but none exists to support it either.
- **Allowed wording:** State the absence directly, e.g. "The person's current employment could not be verified."
- **Forbidden wording:** Do not present the claim as likely true or false.
- **May drive an outreach recommendation:** Only as a caveat, not as the basis for a positive recommendation.

### Unable to Verify

- **Meaning:** Verification was attempted but access, ambiguity, or missing evidence prevented a conclusion.
- **Minimum evidence:** A documented verification attempt, even if it failed.
- **Allowed wording:** Report the failed attempt, e.g. "A hiring post was found, but the role's current status is unknown."
- **Forbidden wording:** Do not silently omit the claim as if it were never checked.
- **May drive an outreach recommendation:** No — treat as missing information.

### Contradicted

- **Meaning:** Credible sources conflict with the claim, or with each other.
- **Minimum evidence:** At least two sources in direct conflict.
- **Allowed wording:** Present both sides, e.g. "One source lists the role as open; a more recent source suggests it has closed."
- **Forbidden wording:** Do not pick one side without disclosing the conflict.
- **May drive an outreach recommendation:** No — the conflict must be resolved or disclosed first.

### Stale

- **Meaning:** Evidence may once have been valid but is no longer fresh enough for the intended use.
- **Minimum evidence:** A previously valid claim with a `checked_at` or `source_date` outside the relevant freshness window.
- **Allowed wording:** State the staleness directly, e.g. "No current hiring signal was found; the most recent evidence is from an earlier period."
- **Forbidden wording:** Do not present stale evidence as current.
- **May drive an outreach recommendation:** Only as historical fit context, not as a current-hiring basis.

## Preferred Wording Examples

- "The company lists Tel Aviv as an office location."
- "The team may use .NET, based on a recent team-specific job post."
- "No current hiring signal was found."
- "The person's current employment could not be verified."
- "A hiring post was found, but the role's current status is unknown."

## Forbidden Wording Examples

- "The company uses C#" — based on one isolated role.
- "This person is hiring" — based only on an Activity URL.
- "The position is open" — based on an old post.
- "This manager will manage you." — presumes an outcome the evidence cannot support.
- "The commute is exactly 37 minutes" — without a suitable live source.

## Related documents

- [source-policy.md](source-policy.md)
- [freshness-policy.md](freshness-policy.md)
- [quality-gates.md](quality-gates.md)
- [data-model.md](data-model.md)
