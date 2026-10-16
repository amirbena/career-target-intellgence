# Readability and Voice Guide

Canonical style guidance for every generated answer, referenced from [core/output-contracts.md](../core/output-contracts.md#readability-and-voice). It changes how an output is *written*, never what it must *contain*: required fields, canonical column names and order, evidence citations, confidence labels, freshness markers (`checked_at`), statuses, and disclaimers are unchanged. Platform layers (Custom GPT, Claude Skill, Claude Project) adapt this guide; they do not redefine it.

## Principles

1. **Lead with the conclusion.** Open with what was found and what it means for the decision, in one to three sentences, before any table or detail.
2. **Prose for reasoning, tables for tabular data.** Use a table only when the content is genuinely multi-record and comparable across the same columns. Explain *why* something fits, was excluded, or is uncertain in a sentence, not a cell-stuffed paragraph.
3. **Say it once.** Do not repeat the same caveat, disclaimer, or scaffolding per row or per section. State a shared caveat once, near the top of its section. Mandatory disclaimers appear once per output, exactly as the contract words them.
4. **Plain, direct voice.** Write for a busy person deciding what to do next. Prefer "This role looks open — the company's careers page lists it (checked 2026-07-20)" over "Availability Status: Verified Open; Evidence: official page confirmed."
5. **Keep the trust markers, make them light.** Dates, confidence, and sources stay attached to the claim they support, written inline (for example "(Fact, checked 2026-07-20, [careers page](https://example.com/careers))"). Never drop them to save space.
6. **Short by default.** Cut empty or Not-applicable sections, nested bullets deeper than two levels, and restated headings. A missing value is still shown as Unknown / Not yet identified, once, in the place the contract requires — not elaborated.
7. **Flag, don't bury, the uncertain.** Anything stale, unverified, or low-confidence is named in the sentence that relies on it.

## When to use a table

| Use a table | Use prose |
|---|---|
| Several records compared on the same canonical columns (jobs, companies, people, queue entries) | Why one record fits, was excluded, or is uncertain |
| CSV-compatible output (always the canonical columns) | Summaries, next steps, caveats, the overall conclusion |
| Ranked lists where order is the point | A single record or a one-or-two-item result |

When a Markdown table would exceed readable width, keep the canonical columns and put a one-sentence plain-language takeaway above the table; do not drop or rename columns.

## Length guidance

- Opening summary: 1–3 sentences.
- Per-record explanation: 1–2 sentences, not a field-by-field restatement of the row.
- Whole answer: only what the request needs. Do not pad with sections for outputs the user did not ask for.

## Before / after examples

All values are synthetic.

### Verified Jobs Map

**Before** (mechanical):

> ### Verified Open
> - Job Title: Senior Backend Engineer
>   - Company: Northbridge Systems
>     - Availability Status: Verified Open
>       - Availability Evidence: Confirmed on official careers page
>     - Job Status Checked At: 2026-07-20T09:10:00Z
>     - Candidate-Fit Summary: Matches target seniority and primary stack
>     - Company-State Summary: No current company-state evidence found
>     - Recruiter / Hiring-Manager Refs: Not yet identified
>     - Uncertainty / Caveats: None
>     - Record Status: Verified

**After** (same data, canonical table retained below the summary):

> One role passed both gates, and it is open: **Senior Backend Engineer at Northbridge Systems**. It matches your target seniority and C#/.NET stack, and the company's careers page lists it (checked 2026-07-20). No recent company news affects it, and no recruiter has been identified yet.
>
> | Job Title | Company | … *(canonical 14 columns, one row)* |

### Unverified and Rejected Job Leads

**Before:** one nested block per lead, repeating "Official Verification Attempted: Yes" and "Reconsideration Note: Re-check later" for every lead.

**After:**

> Two leads did not make the map. Platform Engineer at Meridian Retail Systems is **Not Found on Official Site** (it appeared on a job board but not on the company's careers page; checked 2026-07-19) — this is different from closed, and worth re-checking. Data Engineer at Orbit Analytics is **Closed** (the posting says it stopped accepting applications).
>
> *(canonical 8-column table follows, grouped by rejection reason)*

### Target Company Map

**Before:** a 22-column table with a repeated "Why It Fits" paragraph in every row and the disclaimer repeated per row.

**After:**

> Three companies lead the list. Northbridge Systems ranks first: it is a product company in Ra'anana with public evidence of a C#/.NET backend (Fact), and a current backend opening. Meridian Retail Systems is second, but its technology evidence is company-level only, so team-level fit is unconfirmed. The disclaimer below applies to every row.
>
> *(canonical 22-column table, one row per company; disclaimer once)*

### People Map and Outreach Priority Queue

**Before:** every person restated with all 19 fields in prose plus the table.

**After:**

> Start with Jordan Ashkenazi, a technical recruiter at Northbridge Systems whose current employment is verified (checked 2026-07-20) and who recently posted about the open backend role (A3). For Meridian Retail Systems no contact is identified yet. These are suggestions for you to act on manually.
>
> *(canonical table follows)*

### Candidate Profile and Search Criteria

**Before:** every field listed as a bullet, including empty ones, with "Status: Draft" repeated in each section.

**After:**

> Here is the draft profile for your confirmation: a senior backend engineer, about nine years of experience, mainly C#/.NET, targeting product companies near Ra'anana. Two things are still unknown and need your input: preferred work model and salary expectations. *(Sections per the template; unknown fields shown as Unknown, sourced vs. inferred claims labeled.)*

## Related documents

- [../core/output-contracts.md](../core/output-contracts.md)
- [csv-column-contracts.md](csv-column-contracts.md)
- [verified-jobs-map-template.md](verified-jobs-map-template.md)
