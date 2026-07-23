# Product Definition

## Purpose

Career Targeting Intelligence turns a candidate's profile and goals into a prioritized, evidence-based map of where to focus a job search: which companies to target, which people to reach, and in what order — without automating outreach or monitoring on the candidate's behalf.

## Primary user journey

A candidate describes who they are and what they're looking for. The workflow analyzes that input, defines search criteria, discovers and filters target companies, prioritizes them, identifies relevant recruiters and hiring managers, optionally verifies recent activity when the candidate explicitly asks for it, and produces a prioritized outreach queue the candidate can act on manually.

## Main outputs

- **Candidate Profile** — a structured summary of the candidate's background, goals, and constraints.
- **Target Company Map** — the set of companies worth targeting, with the reasoning behind their inclusion.
- **Recruiter Map** — relevant recruiters associated with target companies.
- **Hiring Manager Map** — relevant hiring managers associated with target companies and roles.
- **Activity Verification** — confirmation of recent, relevant activity (e.g., open roles, hiring signals), performed only when explicitly requested.
- **Outreach Priority Queue** — a ranked list of who to contact next and why.

## Structured but modular

The workflow follows a defined sequence of stages, but each stage is a self-contained, modular step. A user can request a single stage in isolation (e.g., "just build my Candidate Profile") without running the full workflow.

## Research is opt-in

Research actions — including activity verification and any lookup beyond the candidate's own input — are performed only after the candidate explicitly requests them. The workflow does not run background or speculative research on its own initiative.

## Related documents

- [../README.md](../README.md)
- [scope-and-non-goals.md](scope-and-non-goals.md)
- [../ROADMAP.md](../ROADMAP.md)
