# Company State Record Schema

The Company State Record describes one time-sensitive organizational development at a target company — a layoff, a hiring freeze, a restructuring, an acquisition, major funding, an expansion, a relevant leadership change, or a similar event. It is a dedicated record, separate from the [Company Record](company-record.schema.md), because company identity/classification and time-sensitive organizational developments have different freshness behavior, different evidence requirements, and different failure modes if merged — see [Record Boundary](#record-boundary).

This is a logical record. See [core/data-model.md](../core/data-model.md) for the principles that govern how it should be interpreted and populated, including the [Context Boundary](../core/data-model.md#context-boundary). Company State evidence never auto-invalidates a Job Record — see [job-verification-policy.md](../core/job-verification-policy.md#company-state-does-not-gate-job-availability).

## Record Boundary

- **Company Record** ([company-record.schema.md](company-record.schema.md)) stays authoritative for stable company facts: identity, classification, product/domain, technology evidence. Its `company_status` field (Active/Acquired/Closed/Unknown) captures the company's durable operating status, not a specific dated event.
- **Company State Record** captures one specific, dated organizational development and keeps it separately verifiable, separately dated, and separately confident from both the stable Company Record and from any specific Job Record at that company.
- A Company Record may reference zero, one, or many Company State Records over time; a stale or superseded Company State Record does not invalidate the Company Record's stable identity fields — see [Research State Rules](research-state.schema.md#research-state-rules).

## Identity

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `company_state_id` | string | Required | A logical identifier for this event record. | `"company-state:northbridge-systems:2026-06-01-layoff"` |
| `company_name` | string | Required | The company this event concerns. | `"Northbridge Systems"` |

## Event

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `event_type` | enum: `Layoffs`, `Repeated Layoffs`, `Hiring Freeze`, `Restructuring`, `Office/Site Closure`, `Acquisition or Merger`, `Insolvency or Distress`, `Major Funding`, `Strong Expansion`, `Major Hiring Expansion`, `Leadership Change`, `Strategic Pivot`, `Major Business Contraction`, `Unusual Attrition Signal`, `Other` | Required | The category of organizational development. | `"Layoffs"` |
| `event_description` | string | Required | A short, factual description of what happened, without conclusions. | `"Company announced a reduction of approximately 8% of its workforce, primarily in the sales organization."` |
| `affected_scope` | string | Optional | The affected business unit, team, function, or geography, when known. | `"Sales organization; engineering not specifically named"` |
| `magnitude` | string | Optional | A magnitude figure, included only when directly supported by evidence (e.g., a stated headcount or percentage). | `"~8% of global workforce"` |

Do not state a magnitude that is not directly supported by evidence; leave it unset rather than estimating.

## Source and Freshness

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `source_date` | date | Optional | The date the underlying event/announcement occurred or was published, when known. | `"2026-06-01"` |
| `checked_at` | timestamp | Required | When this record was last checked/reconfirmed. | `"2026-07-20T09:00:00Z"` |
| `source_urls` | list of strings | Optional | Source URLs supporting this record. | `["https://northbridgesystems.example/newsroom/2026-restructuring"]` |
| `source_category` | enum: `Official Announcement or Filing`, `Regulatory Filing`, `Direct Executive/Company Communication`, `Reputable Business/News Reporting`, `Other Credible Secondary Source`, `Social Media / Unsupported Post` | Required | The strongest source category supporting this record, per [source-policy.md](../core/source-policy.md#company-state-source-hierarchy). | `"Reputable Business/News Reporting"` |
| `corroborated` | boolean | Required | Whether a significant negative event (layoffs, closures, insolvency) has been corroborated by a second independent source. | `true` |
| `currency_assessment` | enum: `Current`, `Materially Relevant Though Older`, `Likely Superseded`, `Unknown` | Required | Whether this event is current enough for the decision it's being used for — distinct from how old it is; see [freshness-policy.md](../core/freshness-policy.md#company-state-freshness). | `"Materially Relevant Though Older"` |
| `stale_reason` | string | Required when `currency_assessment` is Likely Superseded | A short explanation of why the record is considered superseded/stale. | `""` |
| `refresh_required` | boolean or `Unknown` | Optional | Whether this record needs to be re-checked before it can be used with confidence. Does not imply an automatic refresh. | `false` |

A social-media rumor or unsupported post (`source_category` of Social Media / Unsupported Post) must never be presented as a verified company-state event — see Rules below.

## Evidence State

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `evidence_state` | enum: `Verified`, `Supported Inference`, `Unverified`, `Unable to Verify`, `Contradicted`, `Stale` | Required | The claim's evidence state, per [confidence-model.md](../core/confidence-model.md). | `"Verified"` |
| `confidence` | enum: `Low`, `Medium`, `High` | Required | Confidence in this specific claim. | `"Medium"` |
| `conflicting_evidence` | string | Optional | A description of any conflicting evidence found, kept visible rather than silently resolved. | `""` |

## Impact Assessment

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `impact_assessment_type` | enum: `Fact`, `Supported Inference` | Required | Whether the statement in `candidate_impact_assessment` is a directly sourced fact or a labeled inference drawn from it. Facts and inference must never be merged into one unlabeled statement. | `"Supported Inference"` |
| `candidate_impact_assessment` | string | Optional | A written assessment of how this event may affect a candidate's job search at this company, explicitly labeled per `impact_assessment_type`. | `"The layoff was concentrated in sales; engineering hiring for the Billing Platform Team does not appear directly affected, but a hiring freeze in that org has not been ruled out (Supported Inference)."` |
| `risk_opportunity_classification` | enum: `Risk`, `Opportunity`, `Mixed`, `Neutral / Context Only` | Optional | A classification usable by ranking/prioritization, only when the ranking model calls for one — see [company-ranking-model.md](../ranking/company-ranking-model.md). | `"Risk"` |

Never auto-convert a factual event into a conclusion like "bad company"; `event_description` (Fact) and `candidate_impact_assessment` (Fact or Supported Inference, explicitly labeled) must remain visibly distinct.

## Related Records

| Field | Type | Required | Description | Example |
|---|---|---|---|---|
| `related_job_record_references` | list of logical references | Optional | Job Records at this company that this event should be surfaced alongside. | `["job:northbridge-systems:senior-backend-engineer:2026-07-20"]` |

## Company State Record Rules

1. A Company State Record captures one specific, dated organizational development — it is not a substitute for the Company Record's stable identity/classification fields.
2. Every time-sensitive claim requires `source_date` (when available), `checked_at`, at least one `source_urls` entry when accessible, and a claim-specific `evidence_state`/`confidence`.
3. A social-media rumor or unsupported post must not become a verified company-state event; `source_category` of Social Media / Unsupported Post caps `evidence_state` at Unverified or below.
4. Significant negative events (layoffs, closures, insolvency, distress) should be corroborated by a second independent source when practical; `corroborated` reflects whether that happened.
5. Conflicting evidence must remain visible via `conflicting_evidence`, not silently resolved to one side.
6. `event_description` (Fact) and `candidate_impact_assessment` (Fact or Supported Inference) must remain strictly separate and each explicitly labeled per `impact_assessment_type`.
7. Do not state `magnitude` unless it is directly supported by evidence.
8. This record must never automatically invalidate a Job Record's `job_status` — see [job-verification-policy.md](../core/job-verification-policy.md#company-state-does-not-gate-job-availability). A layoff does not automatically mark every job at the company Closed.
9. `currency_assessment` is distinct from age: a months-old event may remain Materially Relevant Though Older and must not be auto-expired solely because it is older than the job-verification freshness window — see [freshness-policy.md](../core/freshness-policy.md#company-state-freshness).
10. `stale_reason` is required whenever `currency_assessment` is Likely Superseded.
11. `refresh_required` does not imply automatic refresh; a refresh occurs only after an explicit user request.
12. Do not hard-code any real company or real event into shared repository assets — every example in canonical documents must be synthetic.

## Example Records

**Verified, corroborated layoff, materially relevant though not brand-new**
```text
company_state_id: "company-state:northbridge-systems:2026-06-01-layoff"
company_name: "Northbridge Systems"
event_type: "Layoffs"
event_description: "Company announced a reduction of approximately 8% of its workforce, primarily in the sales organization, per its own newsroom post."
affected_scope: "Sales organization; engineering not specifically named"
magnitude: "~8% of global workforce"
source_date: "2026-06-01"
checked_at: "2026-07-20T09:00:00Z"
source_category: "Official Announcement or Filing"
corroborated: true
currency_assessment: "Materially Relevant Though Older"
evidence_state: "Verified"
confidence: "Medium"
impact_assessment_type: "Supported Inference"
candidate_impact_assessment: "The layoff was concentrated in sales; the Billing Platform Team's hiring does not appear directly affected, but this has not been separately confirmed."
risk_opportunity_classification: "Risk"
```

**Unable to verify — social post only, not corroborated**
```text
company_state_id: "company-state:meridian-retail-systems:2026-07-10-rumor"
company_name: "Meridian Retail Systems"
event_type: "Hiring Freeze"
event_description: "A single social media post claims a company-wide hiring freeze; no official announcement or reputable reporting found."
source_date: "2026-07-10"
checked_at: "2026-07-19T09:00:00Z"
source_category: "Social Media / Unsupported Post"
corroborated: false
currency_assessment: "Unknown"
evidence_state: "Unverified"
confidence: "Low"
impact_assessment_type: "Fact"
candidate_impact_assessment: "Unconfirmed; not used as a basis for any recommendation until corroborated."
risk_opportunity_classification: "Neutral / Context Only"
```

## Related documents

- [../core/data-model.md](../core/data-model.md)
- [../core/job-verification-policy.md](../core/job-verification-policy.md)
- [../core/source-policy.md](../core/source-policy.md)
- [../core/freshness-policy.md](../core/freshness-policy.md)
- [company-record.schema.md](company-record.schema.md)
- [job-record.schema.md](job-record.schema.md)
