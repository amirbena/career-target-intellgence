# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

- Initialized repository foundation: project structure, working rules, and high-level scope.
- Defined the core candidate and research state data model: Candidate Profile, Search Criteria, and Research State schemas.
- Defined the Company, Person, and Activity Record schemas, extending the core data model to target companies, public professional contacts, and verified public activity evidence.
- Defined the shared trust policy: Source Policy, Confidence Model, Freshness Policy, and Quality Gates.
- Defined the ranking and outreach priority policy: Company Ranking Model, Person Ranking Model, Exclusion Policy, and Outreach Priority Model.
- Defined modular workflow orchestration: core workflow, Full Journey, Focused Task Routing, Resume Journey, and per-module definitions (Analyze Candidate, Build Search Criteria, Discover Companies, Classify and Rank Companies, Discover People, Verify Activity, Build Outreach Queue); aligned Research State stage names with the workflow modules.
- Defined canonical output contracts: Candidate Profile, Search Criteria, Company Map, Excluded Companies, People Map, Activity Verification, Outreach Queue templates, and stable CSV column contracts for each.
- Reconciled deferred schema gaps: added `stale_reason` and `refresh_required` to the Company, Person, and Activity Record schemas, and `duplicate_contact_group` to the Person Record schema.
