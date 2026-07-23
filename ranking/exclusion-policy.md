# Exclusion Policy

This document resolves the `exclusion_status` behavior deferred when the [Company Record schema](../schemas/company-record.schema.md) was defined. It defines how the `exclusion_status` values — Included, Needs Review, Excluded — interact with the [Company Ranking Model](company-ranking-model.md).

## Included

The company may proceed to ranking. It receives a full score across all dimensions defined in [company-ranking-model.md](company-ranking-model.md) and may be assigned a Priority tier.

## Needs Review

A company marked Needs Review may be retained in research results, but:

- it must be clearly marked as Needs Review wherever it appears;
- it should not receive a final outreach recommendation until the unresolved issue is reviewed;
- it may receive a provisional score if evidence is sufficient, but that score must be labeled provisional and not presented as a final Priority tier.

Typical reasons a company enters Needs Review: an Unclear `company_type`, conflicting evidence, or insufficient evidence to classify confidently — see the exclusion reasons list below, which applies to both Needs Review and Excluded records.

## Excluded

A company marked Excluded:

- does not participate in the active ranking set;
- must not receive a Priority 1–3 tier;
- should be retained in a separate exclusion report, not silently dropped;
- must include an explicit `exclusion_reason`;
- may be reconsidered only after criteria change or new evidence appears.

## Common Exclusion Reasons

- Excluded company type
- Outside commute boundary
- Excluded industry
- Role mismatch
- Seniority mismatch
- No meaningful professional fit
- Duplicate company record
- Company closed
- Insufficient evidence
- User-requested exclusion

## Rules

1. Exclusion is not the same as a zero score. A zero-scoring company that remains Included is still visible in ranked results at the bottom; an Excluded company is removed from the ranked set entirely and reported separately.
2. An excluded company must not be hidden silently — it must always appear in the exclusion report with its `exclusion_reason`.
3. Company-type filtering occurs before final ranking, not as one of the scored dimensions alone; a company classified as an excluded type should generally move to Excluded rather than simply scoring low on Product-company fit.
4. Hybrid companies (`company_type` of Hybrid Product and Services) may remain eligible when the user permits them, per the user's Search Criteria (`product_companies_only`, `include_hybrid_companies`).
5. An Unclear company type should normally become Needs Review, not automatically Excluded — classification uncertainty is a research gap, not a disqualifying finding.
6. Changing Search Criteria (e.g., commute limit, company-type constraints) may invalidate an earlier exclusion; an excluded company should be reconsidered against the new criteria rather than staying excluded by default. See [Search Criteria Rules](../schemas/search-criteria.schema.md#search-criteria-rules), rule 8.

## Related documents

- [../schemas/company-record.schema.md](../schemas/company-record.schema.md)
- [../schemas/search-criteria.schema.md](../schemas/search-criteria.schema.md)
- [company-ranking-model.md](company-ranking-model.md)
- [outreach-priority-model.md](outreach-priority-model.md)
