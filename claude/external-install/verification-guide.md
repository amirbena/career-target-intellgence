# Verification Guide

Five smoke tests to run right after installation, before relying on the
Project for real research. Each checks a distinct part of the
methodology — routing, scope discipline, evidence rules, resume behavior,
and output completeness.

## 1. Candidate analysis without company research

Prompt: "Here is my resume. Build my candidate profile." (paste or
describe a background).

Expect: a Candidate Profile only — no company discovery, no company map,
no recruiters. Company research is a separate, later step the Project
should not run unprompted.

## 2. Focused classification of supplied companies

Prompt: "Classify these three companies: [name three companies]."

Expect: a classification (`company_type`, confidence, evidence) for
exactly those three companies — no broader company discovery beyond the
ones supplied, and no ranking step invented unless you asked for one.

## 3. Activity URL without a dated post results in A0 or A1

Prompt: "Here is this person's LinkedIn activity page URL: [URL]. Have
they posted anything hiring-related recently?" — supply only a profile or
activity-page URL, not a specific dated post.

Expect: the response caps at `A0 — Profile Only` (URL is just a profile)
or `A1 — Activity Page Only` (URL is an activity page but no specific
dated post was found) — never `A2` or higher, and never a claim of recent
activity based on the URL alone.

## 4. Resume from a provided Research State

Prompt: "Continue from this Research State file." (paste a Research State,
for example one modeled on
[`schemas/research-state.schema.md`](../../schemas/research-state.schema.md)).

Expect: the Project reads the supplied stage statuses and continues from
`recommended_next_stage` (or `last_completed_stage`) without re-running
stages already `Completed` or `Approved`, and without fabricating a
Research State if you had not supplied one.

## 5. Company Map includes all eight scoring dimensions

Prompt: request a Company Map for at least one company with enough
supplied evidence to score it.

Expect: the output includes all eight Company Ranking Model dimensions —
Role Fit, Stack Fit, Domain Fit, System-type Fit, Product-company Fit,
Location and Commute Fit, Relevant Team Evidence, and Current Hiring
Signal — in that order, alongside Priority, Score, and the other required
Company Map columns.

## If a test fails

Re-check [`installation-checklist.md`](installation-checklist.md) — a
failed test usually means the Skill isn't installed on this Project, the
Project Instructions weren't pasted, or the Knowledge files weren't
uploaded. If everything was installed correctly and a test still fails,
treat the install as unverified and do not rely on it for real research
until it passes.
