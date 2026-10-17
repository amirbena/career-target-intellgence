# core/

**Canonical** platform-independent methodology: what the product is, what it
will not do, the data model, trust policies, quality gates, and output
contracts. Other areas adapt these documents; they must not redefine them.
Map of the whole repository: [docs/repository-map.md](../docs/repository-map.md).

## Reading order

1. [product-definition.md](product-definition.md) — what the product is and the outputs it produces.
2. [scope-and-non-goals.md](scope-and-non-goals.md) — what is in and out of scope.
3. [data-model.md](data-model.md) — the records and how they relate (schemas live in [../schemas/](../schemas/README.md)).
4. [workflow.md](workflow.md) — operating modes and routing (procedures live in [../workflows/](../workflows/README.md)).
5. [source-policy.md](source-policy.md) — preferred sources and claim-specific source rules.
6. [confidence-model.md](confidence-model.md) — evidence states.
7. [freshness-policy.md](freshness-policy.md) — freshness by claim type.
8. [job-verification-policy.md](job-verification-policy.md) — current-job verification and the official-site cross-check.
9. [quality-gates.md](quality-gates.md) — checks before returning each output.
10. [output-contracts.md](output-contracts.md) — every canonical output (templates live in [../outputs/](../outputs/README.md)).
