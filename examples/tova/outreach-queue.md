# Outreach Queue — Tova (Golden Example)

Built following the [Outreach Queue output template](../../outputs/outreach-queue-template.md) and the [Outreach Priority Model](../../ranking/outreach-priority-model.md). All entries below are entirely synthetic and **advisory only** — nothing in this file is executed automatically; every action is a suggestion for the user to perform manually.

## Ordering

By Queue Position, following the [Recommended Action Order](../../ranking/outreach-priority-model.md#recommended-action-order).

## Outreach Queue

| Queue Position | Company | Person | Person Type | Company Priority | Person Priority Score | Evidence Signal | Recommended Action | Reason | Timing | Status | Follow-up Date | Duplicate Contact Group | Confidence | Checked At |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | IndustrialFlow Systems | Roi Ashkenazi | Engineering Manager | Priority 1 (93) | 96 | A4 matching job post; job status Verified Open | Apply Now | Relevant hiring manager posted an A4 matching role for a verified open position. | Now | Not started | — | — | High | 2026-07-23 |
| 2 | IndustrialFlow Systems | Noa Peretz | Technical Recruiter | Priority 1 (93) | 96 | A4 matching job post; job status Verified Open | Send Direct Message | Relevant technical recruiter posted the same A4 matching, verified-open role. | Now | Not started | — | — | High | 2026-07-23 |
| 3 | BillingMesh | Yossi Katz | Group Manager | Priority 1 (86) | 77 | A3 hiring-related post; job status Post Found, Current Status Unknown | Send Direct Message | Relevant hiring manager with A3 hiring activity; message should ask about current openings rather than assume one exists. | Now | Not started | — | — | Medium | 2026-07-23 |
| 4 | BillingMesh | Dana Segal | Recruiter | Priority 1 (86) | 70 | A3 hiring-related repost; job status Post Found, Current Status Unknown | Connect | Relevant recruiter with A3 hiring activity. | This week | Not started | — | billingmesh-dana-segal | Medium | 2026-07-23 |
| 5 | IndustrialFlow Systems | — (direct application) | N/A | Priority 1 (93) | N/A | Careers page listing; job status Verified Open | Apply Now | Direct application to a currently verified open role (Senior .NET Developer), independent of any specific contact. | Now | Not started | — | — | High | 2026-07-23 |
| 6 | EnterpriseOps Suite | Amit Shani | Engineering Manager | Priority 2 (61) | 50 | A0 profile only; no hiring signal; employment verified | Connect | Relevant manager with verified employment but no current hiring signal. | This week | Not started | 2026-08-06 | — | Low | 2026-07-23 |
| 7 | BillingMesh | Dana Segal-Mor | Talent Acquisition | Priority 1 (86) | 51 | A1 activity page only; no hiring signal; employment verified | Connect | Relevant recruiter with verified employment but no hiring signal; grouped with Dana Segal — contacting one likely reaches the same underlying contact, so avoid duplicating the outreach. | This week | Not started | 2026-08-06 | billingmesh-dana-segal | Low | 2026-07-23 |
| 8 | DataWorks Product Labs | Noa Cohen | Technical Recruiter | Priority 3 (47) | 35 | A1 activity page only; identity ambiguous | Follow Activity | Some activity evidence exists, but identity ambiguity and low company priority mean a direct approach is premature. | Later | Not started | 2026-08-20 | — | Low | 2026-07-23 |
| 9 | FactoryCore | Eitan Shalev | Director of Engineering | Priority 2 (65) | 38 | Employment status Unclear; activity Stale | Research Team | Unresolved employment status caps the recommendation at research rather than direct contact. | This month | Not started | 2026-08-13 | — | Low | 2026-07-23 |
| 10 | EnterpriseOps Suite | Liora Fein | HR Business Partner | Priority 2 (61) | 36 | Weak relevance; general HR role | Skip | General HR relevance without recruiting responsibility; a higher-priority contact (Amit Shani) already covers this company. | — | Not started | — | — | Low | 2026-07-23 |
| 11 | ProcessGrid | Tal Regev | Technical Recruiter | Priority 3 (55) | 34 | Former employee | Skip | No longer employed at the company; not eligible for active outreach regardless of prior relevance. | — | Not started | — | — | Low | 2026-07-23 |

## How Queue Position Was Determined

- **Company priority and evidence category dominate:** positions 1–9 each occupy a distinct step of the [Recommended Action Order](../../ranking/outreach-priority-model.md#recommended-action-order) (A4 manager → A4 recruiter → A3 manager → A3 recruiter → direct application → verified-employment manager → verified-employment recruiter → follow activity → research), so the category itself determines the ordering before any tie-breaking is needed.
- **Company priority breaks ties within the same category:** positions 10 and 11 are both category-10 "Skip" entries. EnterpriseOps Suite (Priority 2, score 61) outranks ProcessGrid (Priority 3, score 55), so Liora Fein is listed before Tal Regev even though both entries are Skip.
- **Person priority score** further distinguishes entries within the same company and category (e.g., position 1 vs. 2 — both IndustrialFlow, both A4 — Roi Ashkenazi and Noa Peretz share the same score of 96, so their order reflects the manager-before-recruiter convention in the canonical action order itself).
- **Job status** determines whether "Apply Now" (Verified Open) or a softer action like "Send Direct Message" (Post Found, Current Status Unknown) is recommended, even at the same activity level.
- **Duplicate-contact grouping** (`billingmesh-dana-segal`) is called out explicitly at position 7 so the user does not treat positions 4 and 7 as two independent contacts to reach separately.
- **Confidence** is lower for entries built on weaker evidence (e.g., position 8's identity ambiguity, position 6 and 9's unresolved current signals), which is reflected in the `Confidence` column even when the category and company priority alone might suggest a stronger action.

## Rules Demonstrated

- No automatic execution is implied anywhere — every `Status` is `Not started`, and every action is phrased as a suggestion for the user.
- Positions 4 and 7 (`billingmesh-dana-segal`) avoid presenting the same underlying contact as two independent high-priority outreach targets.
- Position 9 keeps Eitan Shalev's unresolved employment visible and caps the recommendation accordingly, rather than recommending direct contact.
- Position 3's stale-adjacent evidence (`Post Found, Current Status Unknown`) is not presented as a current opening — the recommended message explicitly asks rather than assumes.
- The user controls whether any of these 11 actions is actually performed; nothing here schedules a follow-up automatically — `Follow-up Date` values are suggestions for the user's own calendar, not system-scheduled reminders.

## Related documents

- [../../ranking/outreach-priority-model.md](../../ranking/outreach-priority-model.md)
- [company-map.md](company-map.md)
- [people-map.md](people-map.md)
- [activity-verification.md](activity-verification.md)
