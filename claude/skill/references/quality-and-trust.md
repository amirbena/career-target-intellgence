# Quality and Trust

Adapts the shared source policy, confidence model, freshness policy, and
quality gates for execution inside Claude. These evidence states, source
rules, and freshness rules are canonical — do not add, remove, or reword
them into different meanings.

**Canonical sources:** [`core/source-policy.md`](../../../core/source-policy.md),
[`core/confidence-model.md`](../../../core/confidence-model.md),
[`core/freshness-policy.md`](../../../core/freshness-policy.md),
[`core/quality-gates.md`](../../../core/quality-gates.md).

## Source policy

Ten preferred source categories, strongest to weakest:

1. Official company website
2. Official company careers page
3. Official company LinkedIn page
4. Public LinkedIn profile of the relevant person
5. Direct public post by the relevant person
6. Reputable job board
7. Reputable business database
8. Reliable secondary source
9. Search-result snippet only
10. Unverified or inaccessible source (supports nothing alone)

### Rules

1. Prefer direct, official sources over aggregators.
2. A snippet alone is weak evidence — corroborate before relying on it.
3. One job posting is not evidence of a company-wide technology stack.
4. One employee's profile is not evidence of a team-wide technology stack.
5. An old title is not evidence of current employment.
6. An Activity URL is not proof of recent activity.
7. A job post existing is not proof that the role is still open.
8. Conflicting sources stay visible rather than silently resolved.
9. Inaccessible or private content is never marked "verified."
10. Every time-sensitive claim needs a `checked_at` date.

## Confidence model

Six evidence states:

| State | Minimum evidence | Wording | May drive outreach |
|---|---|---|---|
| Verified | Direct, checkable source or multiple independent agreeing sources | State directly | Yes |
| Supported Inference | At least one relevant, scoped piece of evidence | Frame as a possibility tied to the evidence — never state as fact | Yes, with the inference disclosed |
| Unverified | Plausible claim, insufficient evidence even for inference | State the absence directly | Only as a caveat, never as positive basis |
| Unable to Verify | Verification attempted but blocked (access, ambiguity, or missing evidence) | Report the failed attempt | No — treat as missing information |
| Contradicted | At least two conflicting credible sources | Present both sides | No, until resolved or disclosed |
| Stale | A prior valid claim whose `checked_at` / `source_date` is now outside the freshness window | State the staleness directly | Only as historical fit context, never as current-hiring basis |

Confidence is **claim-specific, not record-wide** — a single record may hold
claims at several different confidence levels simultaneously.

Forbidden wording examples: "The company uses C#" from one role's job
posting alone; "This person is hiring" from an Activity URL alone; "This
manager will manage you."

## Freshness policy

Key fields: `checked_at`, `source_date`, `lookback_start_date`,
`lookback_end_date`, `stale_reason`, `refresh_required`.

Freshness expectations by claim type:

| Claim type | Expectation |
|---|---|
| Company identity | Slow-changing |
| Product description | Slow-changing |
| Office location | Verify when used for a commute decision |
| Company type | Review when evidence is old or mixed |
| Technology evidence | Prefer recent, team- or job-specific evidence |
| Current employment | Requires current evidence |
| Public activity | Must fall inside the user-requested lookback window |
| Hiring signal | Requires recent evidence |
| Job availability | Requires current verification |
| Commute estimate | Depends on transport mode and traffic assumptions |

### Rules

1. Use exact dates for lookback windows — never "recently" or "a few
   months ago."
2. A stated three-month check needs explicit start and end dates.
3. Historical evidence can support fit context but not current-hiring
   claims.
4. Current employment claims need current evidence, not an old title.
5. An old job post defaults to unknown current status, not open.
6. A stale field does not make the whole record unusable — only that field.
7. A refresh only touches the specific research affected, not everything.
8. Activity and hiring evidence refresh only after an explicit user
   request.
9. No freshness rule implies continuous or scheduled monitoring.

## Quality gates (before returning each output)

**Company Map:** identity verified or explicitly marked otherwise; type
classified or marked Unclear; location evidence present when commute
matters; technology evidence scoped; suitability kept separate from current
hiring; every exclusion carries a reason; mutable claims carry
`checked_at`; confidence is claim-specific.

**People Map:** identity reasonably matched; employment verified or marked
unresolved; person type classified; recruiter relevance kept separate from
managerial relevance; duplicate-name risk considered; no fabricated profile
URL; activity status never inferred from an Activity URL alone; `checked_at`
present.

**Activity Verification:** A0–A4 assigned consistently; A2 and above carry a
specific, dated post; authorship vs. repost noted; exact lookback dates
used; hiring relevance stated explicitly; a matching-role claim is
justified; current job status verified separately from post existence;
failed verification reported, not omitted.

**Outreach Queue:** recommendations based only on available evidence;
employment uncertainty stays visible; stale signals never shown as current;
the recommended action matches the evidence level; no unsupported
certainty; the user is never told to automate outreach; no
private-contact enrichment.

**Universal final check:** every factual public-data claim has evidence, is
explicitly labeled an inference, or is explicitly marked unverified.
