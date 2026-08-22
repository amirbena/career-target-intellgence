# CSV Column Contracts

This document defines stable, snake_case CSV-compatible column sets for each canonical output, per [core/output-contracts.md](../core/output-contracts.md), Universal Rule 9: "CSV-compatible output must preserve the same meaning as Markdown output." This document defines the column contracts only — it does not implement a CSV exporter.

## Conventions

- Dates use ISO `YYYY-MM-DD`.
- Timestamps use ISO 8601 (`YYYY-MM-DDTHH:MM:SSZ`).
- Simple lists use semicolon-separated values within a single cell (e.g., `"C#;SQL Server;.NET"`).
- URLs are plain text values, not hyperlinks.
- An empty value is used only when absence itself is meaningful (e.g., no `exclusion_reason` because the company is Included).
- When verification failed or a value is genuinely unknown, use an explicit value such as `Unknown` or `Unable to Verify` — never leave the cell empty to mean that.

## Candidate Profile

| Column | Source field | Value shape | Required | List handling | Unknown handling | Date format |
|---|---|---|---|---|---|---|
| `candidate_name` | `candidate_name` | string | Required | n/a | n/a | n/a |
| `current_location` | `current_location` | string | Optional | n/a | `Unknown` | n/a |
| `current_title` | `current_title` | string | Optional | n/a | `Unknown` | n/a |
| `seniority` | `seniority` | enum | Required | n/a | `Unknown` | n/a |
| `years_of_experience` | `years_of_experience` | number | Optional | n/a | `Unknown` | n/a |
| `target_roles` | `target_roles` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `primary_technologies` | `primary_technologies` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `secondary_technologies` | `secondary_technologies` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `familiar_technologies` | `familiar_technologies` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `domains` | `domains` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `system_types` | `system_types` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `profile_status` | `profile_status` | enum | Required | n/a | n/a | n/a |
| `last_updated_at` | `last_updated_at` | timestamp | Required | n/a | n/a | ISO 8601 |

## Search Criteria

| Column | Source field | Value shape | Required | List handling | Unknown handling | Date format |
|---|---|---|---|---|---|---|
| `origin_location` | `origin_location` | string | Optional | n/a | `Unknown` | n/a |
| `maximum_commute_minutes` | `maximum_commute_minutes` | number | Optional | n/a | `Not specified` | n/a |
| `commute_mode` | `commute_mode` | enum | Optional | n/a | `Not specified` | n/a |
| `target_roles` | `target_roles` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `target_seniority` | `target_seniority` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `stack_match_strictness` | `stack_match_strictness` | enum | Required | n/a | n/a | n/a |
| `preferred_domains` | `preferred_domains` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `excluded_domains` | `excluded_domains` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `preferred_company_types` | `preferred_company_types` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `excluded_company_types` | `excluded_company_types` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `requested_company_count` | `requested_company_count` | number | Optional | n/a | `Not specified` | n/a |
| `product_companies_only` | `product_companies_only` | boolean | Optional | n/a | `Not specified` | n/a |
| `include_hybrid_companies` | `include_hybrid_companies` | boolean | Optional | n/a | `Not specified` | n/a |
| `activity_lookback_days` | `activity_lookback_days` | number | Optional | n/a | `Not requested` | n/a |
| `requested_outputs` | `requested_outputs` | semicolon-separated | Required | semicolon-separated | empty | n/a |
| `criteria_status` | `criteria_status` | enum | Required | n/a | n/a | n/a |
| `last_updated_at` | `last_updated_at` | timestamp | Required | n/a | n/a | ISO 8601 |

## Verified Jobs Map

| Column | Source field | Value shape | Required | List handling | Unknown handling | Date format |
|---|---|---|---|---|---|---|
| `section` | Verified Open vs. Likely Open / Partially Verified | enum | Required | n/a | n/a | n/a |
| `job_title` | `job_title` | string | Required | n/a | n/a | n/a |
| `company_name` | `company_name` | string | Required | n/a | n/a | n/a |
| `job_location` | `job_location` | string | Optional | n/a | `Unknown` | n/a |
| `work_model` | `work_model` | enum | Required | n/a | n/a | n/a |
| `fit_gate_result` | `fit_gate_result` | enum | Required | n/a | n/a | n/a |
| `fit_notes` | `fit_notes` | string | Optional | n/a | empty | n/a |
| `job_status` | `job_status` | enum | Required | n/a | n/a | n/a |
| `job_status_evidence` | `job_status_evidence` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `discovery_source_type` | `discovery_source_type` | enum | Required | n/a | n/a | n/a |
| `official_verification_result` | `official_verification_result` | enum | Required | n/a | n/a | n/a |
| `official_verification_url` | `official_verification_url` | URL | Optional | n/a | empty | n/a |
| `job_status_checked_at` | `job_status_checked_at` | timestamp | Required | n/a | n/a | ISO 8601 |
| `company_state_summary` | Linked Company State Record `event_description` + `candidate_impact_assessment` | string | Optional | n/a | `No current company-state evidence found` | n/a |
| `company_state_checked_at` | Linked Company State Record `checked_at` | timestamp | Optional | n/a | empty | ISO 8601 |
| `recruiter_hiring_manager_refs` | `related_person_references` | semicolon-separated | Optional | semicolon-separated | `Not yet identified` | n/a |
| `uncertainty_caveats` | Written caveats | string | Optional | n/a | empty | n/a |
| `record_status` | `record_status` | enum | Required | n/a | n/a | n/a |

## Unverified and Rejected Job Leads

| Column | Source field | Value shape | Required | List handling | Unknown handling | Date format |
|---|---|---|---|---|---|---|
| `job_title` | `job_title` | string | Required | n/a | n/a | n/a |
| `company_name` | `company_name` | string | Required | n/a | n/a | n/a |
| `discovery_source_type` | `discovery_source_type` | enum | Required | n/a | n/a | n/a |
| `rejection_reason` | `rejection_reason` | enum | Required | n/a | n/a | n/a |
| `reason_detail` | `job_status_evidence`, `fit_gate_reason`, or `stale_reason` | string | Optional | n/a | empty | n/a |
| `official_verification_attempted` | `official_verification_attempted` | boolean | Required | n/a | n/a | n/a |
| `official_verification_result` | `official_verification_result` | enum | Required | n/a | n/a | n/a |
| `job_status_checked_at` | `job_status_checked_at` | timestamp | Required | n/a | n/a | ISO 8601 |
| `reconsideration_note` | Written note | string | Optional | n/a | empty | n/a |

## Company Map

Surfaces all eight [Company Ranking Model](../ranking/company-ranking-model.md) scoring dimensions as separate numeric columns, matching the [Company Map Markdown template](company-map-template.md) exactly.

| Column | Source field | Value shape | Required | List handling | Unknown handling | Date format |
|---|---|---|---|---|---|---|
| `priority_tier` | Company Ranking Model tier | string | Required | n/a | n/a | n/a |
| `score` | Company Ranking Model total | number | Required | n/a | n/a | n/a |
| `company_name` | `company_name` | string | Required | n/a | n/a | n/a |
| `relevant_location` | `relevant_location` | string | Optional | n/a | `Unknown` | n/a |
| `estimated_commute_minutes` | `estimated_commute_minutes` | number | Optional | n/a | `Unknown` | n/a |
| `commute_confidence` | `commute_confidence` | enum | Optional | n/a | `Unknown` | n/a |
| `company_type` | `company_type` | enum | Required | n/a | n/a | n/a |
| `known_technologies` | `known_technologies` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `technology_scope` | `technology_scope` | enum | Required | n/a | n/a | n/a |
| `relevant_roles` | `relevant_roles` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `role_fit` | Role and seniority fit dimension | number | Required | n/a | n/a | n/a |
| `stack_fit` | Technology-stack fit dimension | number | Required | n/a | n/a | n/a |
| `domain_fit` | Domain fit dimension | number | Required | n/a | n/a | n/a |
| `system_type_fit` | System-type fit dimension | number | Required | n/a | n/a | n/a |
| `product_company_fit` | Product-company fit dimension | number | Required | n/a | n/a | n/a |
| `location_commute_fit` | Location and commute fit dimension | number | Required | n/a | n/a | n/a |
| `possible_relevant_teams` | `possible_relevant_teams` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `relevant_team_evidence_fit` | Relevant-team evidence dimension | number | Required | n/a | n/a | n/a |
| `hiring_signal_status` | `hiring_signal_status` | enum | Required | n/a | n/a | n/a |
| `current_hiring_signal_fit` | Current hiring signal dimension | number | Required | n/a | n/a | n/a |
| `confidence` | `confidence` | enum | Required | n/a | n/a | n/a |
| `why_it_fits` | Written reasoning | string | Required | n/a | n/a | n/a |
| `sources` | `sources` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `checked_at` | `checked_at` | timestamp | Required | n/a | n/a | ISO 8601 |

## Excluded Companies

| Column | Source field | Value shape | Required | List handling | Unknown handling | Date format |
|---|---|---|---|---|---|---|
| `company_name` | `company_name` | string | Required | n/a | n/a | n/a |
| `company_type` | `company_type` | enum | Required | n/a | n/a | n/a |
| `exclusion_status` | `exclusion_status` | enum | Required | n/a | n/a | n/a |
| `exclusion_reason` | `exclusion_reason` | string | Required for Excluded | n/a | empty for Needs Review with no reason yet | n/a |
| `evidence` | `company_type_evidence` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `confidence` | `confidence` | enum | Required | n/a | n/a | n/a |
| `reconsideration_condition` | Written note | string | Optional | n/a | empty | n/a |
| `checked_at` | `checked_at` | timestamp | Required | n/a | n/a | ISO 8601 |

## People Map

| Column | Source field | Value shape | Required | List handling | Unknown handling | Date format |
|---|---|---|---|---|---|---|
| `company_name` | `company_name` | string | Required | n/a | n/a | n/a |
| `person_name` | `person_name` | string | Required | n/a | n/a | n/a |
| `current_title` | `current_title` | string | Optional | n/a | `Unknown` | n/a |
| `person_type` | `person_type` | enum | Required | n/a | n/a | n/a |
| `current_employment_status` | `current_employment_status` | enum | Required | n/a | n/a | n/a |
| `recruiting_relevance` | `recruiting_relevance` | string | Optional | n/a | empty | n/a |
| `managerial_relevance` | `managerial_relevance` | string | Optional | n/a | empty | n/a |
| `team_relevance` | `team_relevance` | string | Optional | n/a | empty | n/a |
| `linkedin_profile_url` | `linkedin_profile_url` | URL | Optional | n/a | empty | n/a |
| `activity_url` | `activity_url` | URL | Optional | n/a | empty | n/a |
| `recent_activity_status` | `recent_activity_status` | enum | Required | n/a | n/a | n/a |
| `recent_hiring_activity_status` | `recent_hiring_activity_status` | enum | Required | n/a | n/a | n/a |
| `matching_job_activity_status` | `matching_job_activity_status` | enum | Required | n/a | n/a | n/a |
| `priority_score` | Person Ranking Model total | number | Required | n/a | n/a | n/a |
| `confidence` | `confidence` | enum | Required | n/a | n/a | n/a |
| `duplicate_contact_group` | `duplicate_contact_group` | string | Optional | n/a | empty | n/a |
| `sources` | `sources` | semicolon-separated | Optional | semicolon-separated | empty | n/a |
| `checked_at` | `checked_at` | timestamp | Required | n/a | n/a | ISO 8601 |

## Activity Verification

| Column | Source field | Value shape | Required | List handling | Unknown handling | Date format |
|---|---|---|---|---|---|---|
| `person_name` | `person_name` | string | Required | n/a | n/a | n/a |
| `company_name` | `company_name` | string | Required | n/a | n/a | n/a |
| `activity_level` | `activity_level` | enum | Required | n/a | n/a | n/a |
| `activity_type` | `activity_type` | string | Optional | n/a | empty | n/a |
| `authorship_status` | `authorship_status` | enum | Required | n/a | n/a | n/a |
| `activity_date` | `activity_date` | date | Optional | n/a | empty | ISO `YYYY-MM-DD` |
| `within_requested_window` | `within_requested_window` | boolean | Required | n/a | n/a | n/a |
| `hiring_related` | `hiring_related` | boolean | Required | n/a | n/a | n/a |
| `matching_role` | `matching_role` | string | Optional | n/a | empty | n/a |
| `job_status` | `job_status` | enum | Required | n/a | n/a | n/a |
| `post_url` | `post_url` | URL | Optional | n/a | empty | n/a |
| `verification_status` | `verification_status` | enum | Required | n/a | n/a | n/a |
| `confidence` | `confidence` | enum | Required | n/a | n/a | n/a |
| `stale_reason` | `stale_reason` | string | Required if Stale | n/a | empty | n/a |
| `refresh_required` | `refresh_required` | boolean or `Unknown` | Optional | n/a | `Unknown` | n/a |
| `checked_at` | `checked_at` | timestamp | Required | n/a | n/a | ISO 8601 |

## Outreach Queue

| Column | Source field | Value shape | Required | List handling | Unknown handling | Date format |
|---|---|---|---|---|---|---|
| `queue_position` | Position in the recommended action order | number | Required | n/a | n/a | n/a |
| `company_name` | `company_name` | string | Required | n/a | n/a | n/a |
| `person_name` | `person_name` | string | Required | n/a | n/a | n/a |
| `person_type` | `person_type` | enum | Required | n/a | n/a | n/a |
| `company_priority_tier` | Company Ranking Model tier | string | Required | n/a | n/a | n/a |
| `person_priority_score` | Person Ranking Model total | number | Required | n/a | n/a | n/a |
| `evidence_signal` | Activity level and job status | string | Required | n/a | n/a | n/a |
| `recommended_action` | One of the Supported Actions | enum | Required | n/a | n/a | n/a |
| `reason` | Written justification | string | Required | n/a | n/a | n/a |
| `timing` | Suggested timing | string | Optional | n/a | empty | n/a |
| `status` | User progress on this entry | string | Required | n/a | n/a | n/a |
| `follow_up_date` | Suggested revisit date | date | Optional | n/a | empty | ISO `YYYY-MM-DD` |
| `duplicate_contact_group` | `duplicate_contact_group` | string | Optional | n/a | empty | n/a |
| `confidence` | Overall confidence | enum | Required | n/a | n/a | n/a |
| `checked_at` | `checked_at` | timestamp | Required | n/a | n/a | ISO 8601 |
| `associated_job_id` | `job_id` | string | Optional | n/a | `Not associated with a specific job` | n/a |

## Related documents

- [../core/output-contracts.md](../core/output-contracts.md)
- [company-map-template.md](company-map-template.md)
- [excluded-companies-template.md](excluded-companies-template.md)
- [people-map-template.md](people-map-template.md)
- [activity-verification-template.md](activity-verification-template.md)
- [outreach-queue-template.md](outreach-queue-template.md)
- [verified-jobs-map-template.md](verified-jobs-map-template.md)
- [unverified-job-leads-template.md](unverified-job-leads-template.md)
