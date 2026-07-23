# Module: Discover People

Finds recruiters, talent acquisition contacts, hiring managers, and relevant team leads or engineering leaders at selected companies. Produces [Person Records](../schemas/person-record.schema.md) and applies the [Person Ranking Model](../ranking/person-ranking-model.md).

## Purpose

Identify publicly relevant contacts at target companies, with current employment verified or clearly marked as unresolved.

## Required Inputs

- Selected or otherwise prioritized companies (from Company Selection, or a user-supplied company list in a Focused Task).

## Optional Inputs

- A specific person-type focus (e.g., "find managers who may manage this profile" restricts scope to management-type person records).

## Preconditions

- At least one company must be identified — either from ranked/selected Company Records, or supplied directly by the user in a Focused Task.

## Procedure

1. Identify candidate people at each company: Recruiter, Technical Recruiter, Talent Acquisition, Talent Sourcer, Recruitment Lead, HR Business Partner, People Partner, Team Lead, Engineering Manager, Group Manager, Director of Engineering, Head of R&D, or VP R&D — per [Person Type](../schemas/person-record.schema.md#person-type).
2. Verify current employment per [Employment Verification](../schemas/person-record.schema.md#employment-verification); if it cannot be verified, mark `current_employment_status` as Unclear or Unable to Verify rather than assuming Current.
3. Populate [Candidate Relevance](../schemas/person-record.schema.md#candidate-relevance) fields, distinguishing recruiting relevance from managerial relevance.
4. Apply the [Person Ranking Model](../ranking/person-ranking-model.md) once activity evidence is available (from Verify Activity, when included).
5. Note `duplicate_risk` when multiple people share the same name.

## Outputs

- Person Records with `person_type`, `current_employment_status`, and relevance notes populated.

## Research State Updates

- `people_discovery_status` moves from Not Started → Draft → Completed.

## Quality Gates

- Current employment is verified or marked unresolved — see [Person Record Rules](../schemas/person-record.schema.md#person-record-rules), rule 1.
- Recruiters are distinguished from general HR roles — rule 2.
- Direct team relevance is distinguished from title similarity — rule 3.
- Profile URLs are never fabricated — rule 7.

## Uncertainty Handling

- Ambiguous identities (multiple people with the same name) are preserved as ambiguous, not arbitrarily resolved — rule 6.
- A person whose employment cannot be verified is still recorded, with `current_employment_status` reflecting that uncertainty rather than being omitted.

## Explicit Non-Actions

- Do not treat an Activity URL as proof of recent activity — rule 4; that determination belongs to Verify Activity.
- Do not treat an old hiring post as evidence of current hiring — rule 5.
- Do not claim a manager "will manage" the candidate — see [Hiring Managers](../ranking/person-ranking-model.md#hiring-managers).
- Do not perform private-contact enrichment — rule 9.

## Related documents

- [../schemas/person-record.schema.md](../schemas/person-record.schema.md)
- [../ranking/person-ranking-model.md](../ranking/person-ranking-model.md)
- [verify-activity.md](verify-activity.md)
- [classify-and-rank-companies.md](classify-and-rank-companies.md)
- [full-journey.md](full-journey.md)
