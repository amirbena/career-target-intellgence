# Testing Guide

Thirteen smoke tests to run in Preview before saving or sharing the
configured GPT. Each targets a distinct part of the methodology — scope
discipline, approval checkpoints, focused routing, evidence boundaries,
freshness, resume behavior, output completeness, capability-unavailable
behavior, the job-first eligibility gate, company-state handling, and a
full regression walkthrough.

## Test 1 — Candidate Analysis

Provide a short synthetic resume.

**Expected:** a Candidate Profile only. Unsupported claims remain marked
unknown rather than invented. No company research happens unless
explicitly requested.

## Test 2 — Search Criteria Approval

Ask the GPT to turn candidate preferences into Search Criteria.

**Expected:** constraints the user actually stated are kept separate from
preferences the GPT inferred. Unresolved decisions stay visible rather
than silently defaulted. The Draft-to-Ready approval checkpoint is
preserved — the GPT doesn't treat Search Criteria as final without
confirmation.

## Test 3 — Focused Company Classification

Provide three synthetic companies.

**Expected:** the GPT uses the supplied candidate/search context, runs
only company classification and ranking (not discovery, not people
discovery), does not rebuild already-approved candidate work, and
explains any exclusions with a stated reason.

## Test 4 — Activity Boundary

Provide a person's profile URL, an Activity URL, and no dated authored
post.

**Expected:** the activity level lands at `A0` or `A1`. No claim of
verified recent activity. No hiring claim derived from the URLs alone.

## Test 5 — Current Job Boundary

Provide an old job posting.

**Expected:** the job posting's existence and its current-open status are
treated as two separate claims. Current status is marked stale,
unverified, or unable to verify, as appropriate — never assumed open.

## Test 6 — Resume Journey

Provide a completed Research State where export has not started.

**Expected:** the GPT resumes toward export, does not rebuild any stage
already marked Completed or Approved, and preserves any open questions
recorded in the Research State.

## Test 7 — Company Map Contract

Request a Company Map for at least one company with enough evidence to
score it.

**Expected:** all eight scoring dimensions appear, with a correctly
computed total and Priority tier per the canonical model, source and
confidence and `checked_at` on the relevant claims, and no invented
evidence anywhere in the row.

## Test 8 — Web Unavailable

Explicitly instruct the GPT not to browse (or test in a context where web
search is genuinely unavailable).

**Expected:** no fabricated claim of having done current research.
Supplied data is still processed normally. Any claim that would have
needed external verification is labeled `Unverified` or
`Unable to Verify`, per [`capability-policy.md`](capability-policy.md).

## Test 9 — Tova Golden Journey Regression

Walk the GPT through the existing synthetic Tova Golden Journey
(`examples/tova/` in the source repository) as a set of prompts — do not
paste the Golden Journey's own files into the GPT as Knowledge or as
conversation attachments beyond what a normal user prompt would supply.

**Expected:** the same journey decisions the source repository's Golden
Journey documents, the same approved-stage reuse behavior on resume, the
same unresolved identity/employment issues surfaced rather than resolved,
and the same canonical scoring and output contracts applied.

Do not copy Tova records into the packaged Knowledge files — this test
uses the Golden Journey only as a walkthrough script, never as shipped
content.

## Test 10 — Official Cross-Check Confirms

Provide a synthetic role discovered on a LinkedIn/Glassdoor-style listing,
and state that the same role is also found on the (synthetic) company's
official careers page.

**Expected:** `job_status` becomes Verified Open only after the official
source is checked; both the discovery source and the official verification
URL are recorded; `job_status_checked_at` is exact.

## Test 11 — Official Cross-Check Fails to Find the Role

Provide a synthetic role discovered on a job board; state the official
careers site is accessible but does not list this role.

**Expected:** `job_status` becomes Not Found on Official Site, never
Closed; the lead is preserved (not dropped) and appears in the
Unverified/Rejected Job Leads output with that specific reason.

## Test 12 — Candidate-Fit Gate Excludes a Verified Role

Provide a synthetic role that is Verified Open but violates a stated hard
constraint (e.g., outside the candidate's geographic constraint).

**Expected:** the role does not appear in the Verified Jobs Map despite
being Verified Open; it appears in Unverified/Rejected Job Leads with
reason "Location mismatch" (or the relevant hard-constraint reason), and
company attractiveness is not treated as a reason to include it anyway.

## Test 13 — Company State Does Not Auto-Close a Job

Provide a synthetic Verified Open role at a company with a recent synthetic
layoff announcement (unrelated business unit).

**Expected:** the role remains Verified Open in the Verified Jobs Map; the
layoff appears as separate, clearly labeled company-state context (Fact vs.
Supported Inference) rather than changing the role's availability status,
and does not imply every other role at that company is also closed.

## If a test fails

Re-check [`builder-setup.md`](builder-setup.md) — a failed test usually
means the Instructions weren't pasted, a Knowledge bundle is missing, or a
Capability the test depends on isn't enabled. If everything was configured
correctly and a test still fails, treat the GPT as unverified and do not
share or publish it until it passes.
