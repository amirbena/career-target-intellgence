# Activity Verification

Adapts the Activity Record schema and the Verify Activity workflow for
execution inside Claude. Activity verification runs only when the user
explicitly requests it, or explicitly includes it in a requested full
journey — never automatically.

**Canonical sources:** [`schemas/activity-record.schema.md`](../../../schemas/activity-record.schema.md),
[`workflows/verify-activity.md`](../../../workflows/verify-activity.md).

## Activity Record

- **Identity** — `activity_id` (required), `person_name` (required),
  `company_name` (required), `activity_url`, `post_url`.
- **Activity Level** — `activity_level` (required), one of, weakest to
  strongest:
  - `A0 — Profile Only`
  - `A1 — Activity Page Only`
  - `A2 — Recent Post Found`
  - `A3 — Hiring-related Post Found`
  - `A4 — Matching Job Post Found`
- **Activity Details** — `activity_type`, `activity_date`,
  `authorship_status` (Authored / Reposted / Shared with Commentary /
  Unknown, required), `content_summary`, `hiring_related` (boolean,
  required), `matching_role`, `role_relevance_notes`.
- **Time Window** — `lookback_start_date` (required), `lookback_end_date`
  (required), `within_requested_window` (boolean, required).
- **Verification** — `verification_status` (Verified / Partially Verified /
  Unable to Verify / Contradicted / Stale, required), `verification_evidence`,
  `source_urls`, `checked_at` (required), `confidence` (Low / Medium / High,
  required), `stale_reason` (required when Stale), `refresh_required`.
- **Job Signal** — `job_title`, `job_location`, `job_status` (Verified Open
  / Post Found, Current Status Unknown / Closed / Historical / Not
  Applicable / Unable to Verify, required), `job_status_checked_at`
  (required).

## Exact lookback windows

Freshness for activity is expressed with exact dates, never relative
language. Always set `lookback_start_date` and `lookback_end_date`
explicitly — never write "recently" or "a few months ago." A requested
lookback of, for example, 90 days must be expressed as the exact calendar
start and end dates it resolves to.

## Authored vs. reposted content

`authorship_status` must distinguish content the person actually wrote
(Authored) from content they reposted or shared with commentary (Reposted /
Shared with Commentary). A repost of someone else's hiring post is weaker
evidence of the person's own hiring involvement than an authored post, and
this distinction must stay visible in the record and in any output that
surfaces the activity.

## Current job verification is separate from activity level

Reaching `A4 — Matching Job Post Found` proves that a matching job post was
found — it does not by itself prove the role is still open. `job_status`
must be verified and dated independently (`job_status_checked_at`). A job
post's mere existence is never sufficient evidence that a role remains
open.

### Rules

1. A profile URL alone is `A0 — Profile Only` — never higher.
2. An activity-page URL alone (no specific post found) is
   `A1 — Activity Page Only` — never higher.
3. `A2` or higher requires a specific, dated post.
4. `A3` requires clearly hiring-related content, not just professional
   activity.
5. `A4` requires a job post that meaningfully matches the candidate's target
   role, not just any job post.
6. Always distinguish authored content from reposted or shared content.
7. Use exact date boundaries for the lookback window — never relative
   phrasing.
8. Never infer current role availability from an old post.
9. Record a failed or blocked verification attempt explicitly
   (`verification_status: Unable to Verify`) — never silently drop the
   person from the output.
10. Only run activity verification after an explicit user request, or
    explicit inclusion in a requested full journey.
11. `stale_reason` is required whenever `verification_status` is Stale.
12. `refresh_required` only follows an explicit user request — never an
    implied continuous or scheduled recheck.
