# Candidate Profile Template

This is the Markdown presentation template for the Candidate Profile output, built from the [Candidate Profile schema](../schemas/candidate-profile.schema.md), per [core/output-contracts.md](../core/output-contracts.md#candidate-profile). It is kept concise enough for the user to confirm quickly. All values below are synthetic.

## Template

```markdown
# Candidate Profile — {{candidate_name}}

**Status:** {{profile_status}} · **Last updated:** {{last_updated_at}}

## Candidate Summary
{{current_title}}, {{years_of_experience}} years of experience, based in {{current_location}}.

## Professional Level
- **Seniority:** {{seniority}}
- **Current title:** {{current_title}}

## Target Roles
- {{target_roles}}

## Primary Technologies
- {{primary_technologies}}

## Secondary and Familiar Technologies
- **Secondary:** {{secondary_technologies}}
- **Familiar:** {{familiar_technologies}}

## Domains and System Types
- **Domains:** {{domains}}
- **System types:** {{system_types}}

## Responsibility and Impact Signals
- **Ownership:** {{ownership_signals}}
- **Leadership:** {{leadership_signals}}
- **Mentoring:** {{mentoring_signals}}
- **Architecture:** {{architecture_signals}}
- **Production support:** {{production_support_signals}}
- **Measurable impact:** {{measurable_impact}}

## Preferences and Constraints
- **Preferred roles:** {{preferred_roles}}
- **Excluded roles:** {{excluded_roles}}
- **Preferred domains:** {{preferred_domains}}
- **Excluded domains:** {{excluded_domains}}
- **Work model:** {{work_model_preferences}}
- **Geographic constraints:** {{geographic_constraints}}

## Assumptions and Uncertainties
- **Assumptions:** {{assumptions}}
- **Uncertainties:** {{uncertainties}}

## Profile Status
{{profile_status}}

## Last Updated
{{last_updated_at}}
```

## Synthetic Example

```markdown
# Candidate Profile — Dana Levi

**Status:** Approved · **Last updated:** 2026-07-20T10:00:00Z

## Candidate Summary
Senior Software Engineer, 9 years of experience, based in Bnei Brak.

## Professional Level
- **Seniority:** Senior
- **Current title:** Senior Software Engineer

## Target Roles
- Senior Backend Engineer

## Primary Technologies
- C#, SQL Server

## Secondary and Familiar Technologies
- **Secondary:** Redis
- **Familiar:** Kafka

## Domains and System Types
- **Domains:** enterprise billing, manufacturing
- **System types:** distributed systems, internal platforms

## Responsibility and Impact Signals
- **Ownership:** owned billing service end-to-end
- **Leadership:** led migration to microservices
- **Mentoring:** mentored two junior engineers
- **Architecture:** designed event-driven billing architecture
- **Production support:** primary on-call responder
- **Measurable impact:** reduced billing errors by 30%

## Preferences and Constraints
- **Preferred roles:** Backend Engineer
- **Excluded roles:** People Manager
- **Preferred domains:** fintech
- **Excluded domains:** gambling
- **Work model:** hybrid
- **Geographic constraints:** central Israel only

## Assumptions and Uncertainties
- **Assumptions:** assumed full-time employment history
- **Uncertainties:** unclear whether role was people-management

## Profile Status
Approved

## Last Updated
2026-07-20T10:00:00Z
```

## Related documents

- [../schemas/candidate-profile.schema.md](../schemas/candidate-profile.schema.md)
- [../core/output-contracts.md](../core/output-contracts.md)
