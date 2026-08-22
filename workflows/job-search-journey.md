# Job Search Journey

The Job Search Journey is the **default** end-to-end path when the user's intent is to find jobs — as opposed to the [Company Targeting Journey](full-journey.md), which remains a supported focused mode for company-first exploration. See [core/workflow.md](../core/workflow.md#operating-modes) for how these two full journeys relate, and [core/product-definition.md](../core/product-definition.md) for why job-first is the default for job-discovery intent.

```text
Candidate Input / Existing Candidate Profile
        ↓
Search Criteria
        ↓
Current Job Discovery
        ↓
Current Job Verification
        ↓
Candidate–Job Fit
        ↓
Company State Verification
        ↓
Recruiter / Hiring-Manager Discovery
        ↓
Outreach Prioritization
```

A successful primary result under this journey is a specific role with: a specific employer, a specific job title, sufficient role detail to assess candidate relevance, an explicit current-availability state, an exact `job_status_checked_at`, source URL(s), a candidate-fit assessment, a company-state assessment, and recruiter/hiring-manager discovery when useful and possible. Prefer fewer strongly verified matches over many stale, closed, weak, or unverifiable ones.

## Stages

### Candidate Input / Existing Candidate Profile

- **Purpose:** Reuse or build the [Candidate Profile](../schemas/candidate-profile.schema.md) — identical to [Full Journey — Candidate Analysis](full-journey.md#candidate-analysis); this journey does not redefine that stage.
- **Conditions for skipping:** An Approved Candidate Profile already exists in the available context and the user has not indicated changes.

### Search Criteria

- **Purpose:** Build or reuse [Search Criteria](../schemas/search-criteria.schema.md) — identical to [Full Journey — Search Criteria](full-journey.md#search-criteria).
- **Conditions for skipping:** Ready Search Criteria already exist and the user has not indicated changes.

### Current Job Discovery

- **Purpose:** Identify a broad set of candidate roles across discovery sources — official careers pages, LinkedIn Jobs, Glassdoor, Indeed, other job boards, and recruiter posts — before verification or fit evaluation.
- **Required inputs:** Ready Search Criteria.
- **Outputs:** Draft [Job Records](../schemas/job-record.schema.md), each with `discovery_source`, `discovery_source_type`, and `discovered_at` populated; `job_status` not yet decided beyond a provisional value.
- **State transition:** `job_discovery_status` moves Not Started → Draft → Completed.
- **Quality gate:** See [Job Record Rules](../schemas/job-record.schema.md#job-record-rules), rule 3 — a discovery-source listing is never treated as verification.
- **Module reference:** [discover-jobs.md](discover-jobs.md).

### Current Job Verification

- **Purpose:** Decide each discovered role's `job_status` per [core/job-verification-policy.md](../core/job-verification-policy.md), including the mandatory official-site/ATS cross-check.
- **Required inputs:** Draft Job Records from Current Job Discovery.
- **Outputs:** Job Records with `job_status`, `official_verification_attempted`, `official_verification_result`, and `job_status_checked_at` populated.
- **State transition:** `job_verification_status` moves Not Started → Draft → Completed.
- **Quality gate:** See [core/job-verification-policy.md](../core/job-verification-policy.md#policy-rules) — no discovery source alone produces Verified Open; a failed or impossible verification attempt is recorded, not omitted.
- **Module reference:** [verify-job.md](verify-job.md).

**Rule 1:** Do not require Activity verification merely to prove a job exists if the official careers page already proves current availability — Activity Record verification (see [verify-activity.md](verify-activity.md)) remains a separate, optional module about a person's public posts, not a precondition for Current Job Verification.

### Candidate–Job Fit

- **Purpose:** Apply the [Primary Job Eligibility Gate](../ranking/job-eligibility-gate.md) — Gate B (candidate fit) — to verified/likely-open roles, and record `fit_gate_result`/`fit_gate_reason` on each Job Record.
- **Required inputs:** Job Records with `job_status` decided; an approved Candidate Profile and Ready Search Criteria.
- **Outputs:** Job Records with `fit_evaluation_status`, `fit_gate_result`, `fit_gate_reason` (when failing), and `record_disposition` populated.
- **State transition:** `job_fit_evaluation_status` moves Not Started → Draft → Completed.
- **Quality gate:** See [job-eligibility-gate.md](../ranking/job-eligibility-gate.md#rules) — unknown fit evidence is never a positive signal; a hard-constraint violation excludes the role from the primary map regardless of company attractiveness.
- **Module reference:** [evaluate-candidate-job-fit.md](evaluate-candidate-job-fit.md).

**Rule 2:** A role that fails Gate A (availability) or Gate B (fit) is reclassified as a Rejected Lead, not deleted — see [Unverified and Rejected Job Leads](../outputs/unverified-job-leads-template.md).

### Company State Verification

- **Purpose:** Surface relevant, recent organizational developments (layoffs, freezes, restructuring, funding, expansion, leadership change, etc.) for the employer of each role that passed the eligibility gate, per [company-state-record.schema.md](../schemas/company-state-record.schema.md).
- **Required inputs:** Job Records with `record_disposition` of `Primary Candidate`.
- **Outputs:** [Company State Records](../schemas/company-state-record.schema.md), linked to the relevant Job Record(s) via `related_company_state_references`.
- **State transition:** `company_state_verification_status` moves Not Started → Draft → Completed.
- **Quality gate:** See [Company State Record Rules](../schemas/company-state-record.schema.md#company-state-record-rules) — Fact and Supported Inference stay labeled and separate; this stage never changes a Job Record's `job_status` or `fit_gate_result`.
- **Module reference:** [verify-company-state.md](verify-company-state.md).

**Rule 3:** Company State evidence is disclosed alongside the role, never merged into it — a recent layoff does not remove a verified open role from the primary map, and it does not automatically mark every role at that company Closed.

### Recruiter / Hiring-Manager Discovery

- **Purpose:** Identify public professional contacts relevant to each primary role, using the priority order in [source-policy.md](../core/source-policy.md) and [person-ranking-model.md](../ranking/person-ranking-model.md) — identical module to [Full Journey — People Discovery](full-journey.md#people-discovery), scoped to the companies behind primary roles rather than a broader selected-company set.
- **Required inputs:** Job Records with `record_disposition` of `Primary Candidate`.
- **Outputs:** [Person Records](../schemas/person-record.schema.md), with `related_person_references` populated on the relevant Job Record(s) when discovered.
- **State transition:** `people_discovery_status` moves Not Started → Draft → Completed (shared with the Company Targeting Journey's stage of the same name).
- **Conditions for skipping:** Relevant Person Records for the role's employer already exist and are not stale.

### Outreach Prioritization

- **Purpose:** Produce the [Outreach Priority Queue](../outputs/outreach-queue-template.md), now able to associate a specific verified Job Record with a recommended contact — see [build-outreach-queue.md](build-outreach-queue.md).
- **Required inputs:** Primary Job Records, discovered Person Records, and (when available) Activity Records and Company State Records.
- **Outputs:** An Outreach Priority Queue.
- **State transition:** `outreach_queue_status` moves Not Started → Draft → Completed (shared with the Company Targeting Journey).

## Primary Result Requirements

Every entry that reaches the [Verified Jobs Map](../outputs/verified-jobs-map-template.md) must have all of the following, per the product spec:

- specific employer (`company_name`);
- specific job title (`job_title`);
- sufficient role detail to assess candidate relevance;
- explicit current-availability state (`job_status`);
- exact `job_status_checked_at`;
- source URL(s);
- a candidate-fit assessment (`fit_gate_result`, `fit_notes`);
- a company-state assessment (linked Company State Record(s), or an explicit note that none were found);
- recruiter/hiring-manager discovery when useful and possible (not mandatory when no relevant contact could be found — that gap is disclosed, not fabricated).

## Explicit Non-Actions

- Do not treat a company's general attractiveness, a recruiter's hiring post, a job-board listing, or historical hiring evidence as proof a specific job is currently open.
- Do not require Activity Verification of a person's social posts as a precondition for Current Job Verification when the official careers page already settles availability.
- Do not silently drop a role that fails a gate — route it to Rejected/Unverified Leads with a specific reason.
- Do not let Company State evidence auto-invalidate a verified role, and do not let it auto-close every role at a company.
- Do not perform scheduled or background job monitoring; this journey runs once per explicit request.

## Related documents

- [../core/workflow.md](../core/workflow.md)
- [../core/job-verification-policy.md](../core/job-verification-policy.md)
- [../ranking/job-eligibility-gate.md](../ranking/job-eligibility-gate.md)
- [full-journey.md](full-journey.md)
- [focused-task-routing.md](focused-task-routing.md)
- [resume-journey.md](resume-journey.md)
- [discover-jobs.md](discover-jobs.md)
- [verify-job.md](verify-job.md)
- [evaluate-candidate-job-fit.md](evaluate-candidate-job-fit.md)
- [verify-company-state.md](verify-company-state.md)
- [../outputs/verified-jobs-map-template.md](../outputs/verified-jobs-map-template.md)
- [../outputs/unverified-job-leads-template.md](../outputs/unverified-job-leads-template.md)
- [../schemas/research-state.schema.md](../schemas/research-state.schema.md)
