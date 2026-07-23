# Quality Gates

This document defines the minimum checks that must pass before returning each research output. It is downstream of [source-policy.md](source-policy.md), [confidence-model.md](confidence-model.md), and [freshness-policy.md](freshness-policy.md), and applies to the outputs described in [product-definition.md](product-definition.md).

## Company Map

Before returning a Company Map, confirm:

- company identity verified or clearly marked;
- company type classified or marked Unclear;
- location evidence present when commute matters;
- technology evidence includes scope;
- suitability is separated from current hiring;
- exclusions include reasons;
- mutable claims include `checked_at`;
- confidence is claim-specific.

## People Map

Before returning a People Map, confirm:

- person identity is reasonably matched;
- current employment is verified or marked unresolved;
- person type is classified;
- recruiter relevance and managerial relevance are separated;
- duplicate-name risk is considered;
- profile URL is not fabricated;
- activity status is not inferred from an Activity URL alone;
- mutable claims include `checked_at`.

## Activity Verification

Before returning Activity Verification, confirm:

- A0–A4 level is assigned consistently;
- A2 or above has a specific dated post;
- authorship or repost status is noted when possible;
- exact lookback dates are used;
- hiring relevance is explicit;
- matching-role status is justified;
- current job status is verified separately;
- failed verification is reported rather than omitted.

## Outreach Queue

Before returning an Outreach Queue, confirm:

- recommendations are based on available evidence;
- current employment uncertainty is visible;
- stale hiring signals do not appear as current openings;
- suggested action matches the evidence level;
- unsupported certainty is avoided;
- users are not instructed to automate outreach;
- no private-contact enrichment is included.

## Universal Final Check

Every factual public-data claim must either have supporting evidence, be explicitly labeled as inference, or be marked as unverified.

## Related documents

- [source-policy.md](source-policy.md)
- [confidence-model.md](confidence-model.md)
- [freshness-policy.md](freshness-policy.md)
- [data-model.md](data-model.md)
- [product-definition.md](product-definition.md)
- [../schemas/company-record.schema.md](../schemas/company-record.schema.md)
- [../schemas/person-record.schema.md](../schemas/person-record.schema.md)
- [../schemas/activity-record.schema.md](../schemas/activity-record.schema.md)
