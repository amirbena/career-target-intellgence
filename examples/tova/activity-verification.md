# Activity Verification — Tova (Golden Example)

Built following the [Activity Verification output template](../../outputs/activity-verification-template.md) and the [Activity Record schema](../../schemas/activity-record.schema.md). All people, companies, and URLs below are entirely synthetic. Activity Verification was explicitly requested as part of this Full Journey example, per [Search Criteria — Requested Outputs](search-criteria.md#requested-outputs).

**Fixed evaluation date:** 2026-07-23
**Lookback window:** 2026-04-24 through 2026-07-23 (90 days), used consistently across every entry below.

## Ordering

By activity level descending (A4 first), then by person within each level.

## Activity Verification

| Person | Company | Activity Level | Activity Type | Authorship Status | Post Date | Within Lookback Window | Hiring Related | Matching Role | Job Status | Post URL | Verification Status | Confidence | Stale Reason | Refresh Required | Checked At |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Roi Ashkenazi | IndustrialFlow Systems | A4 — Matching Job Post Found | post | Authored | 2026-07-15 | true | true | Senior .NET Developer | Verified Open | https://linkedin.example/posts/roi-ashkenazi-example_hiring-1 | Verified | High | — | false | 2026-07-23 |
| Noa Peretz | IndustrialFlow Systems | A4 — Matching Job Post Found | post | Authored | 2026-07-10 | true | true | Senior .NET Developer | Verified Open | https://linkedin.example/posts/noa-peretz-example_hiring-1 | Verified | High | — | false | 2026-07-23 |
| Yossi Katz | BillingMesh | A3 — Hiring-related Post Found | post | Authored | 2026-05-05 | true | true | — | Post Found, Current Status Unknown | https://linkedin.example/posts/yossi-katz-example_hiring-1 | Verified | Medium | — | false | 2026-07-23 |
| Dana Segal | BillingMesh | A3 — Hiring-related Post Found | repost | Reposted | 2026-06-20 | true | true | — | Post Found, Current Status Unknown | https://linkedin.example/posts/dana-segal-example_hiring-1 | Verified | Medium | — | false | 2026-07-23 |
| Tal Regev | ProcessGrid | A2 — Recent Post Found | post | Reposted | 2026-05-01 | true | false | — | Not Applicable | https://linkedin.example/posts/tal-regev-example_note-1 | Verified | Medium | — | false | 2026-07-23 |
| Eitan Shalev | FactoryCore | A2 — Recent Post Found | post | Authored | 2026-03-02 | false | false | — | Not Applicable | https://linkedin.example/posts/eitan-shalev-example_note-1 | Stale | Low | Most recent known post (2026-03-02) predates the requested lookback window (2026-04-24 to 2026-07-23); evidence needs refreshing before use. | true | 2026-07-23 |
| Dana Segal-Mor | BillingMesh | A1 — Activity Page Only | — | Unknown | — | — | — | — | Not Applicable | https://linkedin.example/in/dana-segal-mor-example/recent-activity | Partially Verified | Low | — | — | 2026-07-23 |
| Noa Cohen | DataWorks Product Labs | A1 — Activity Page Only | — | Unknown | — | — | — | — | Not Applicable | https://linkedin.example/in/noa-cohen-example/recent-activity | Partially Verified | Low | — | — | 2026-07-23 |
| Liora Fein | EnterpriseOps Suite | A1 — Activity Page Only | — | Unknown | — | — | — | — | Not Applicable | https://linkedin.example/in/liora-fein-example/recent-activity | Unable to Verify | Low | — | — | 2026-07-23 |
| Michal Bar | FactoryCore | A0 — Profile Only | — | Unknown | — | — | — | — | Not Applicable | — | Unable to Verify | Low | — | — | 2026-07-23 |
| Amit Shani | EnterpriseOps Suite | A0 — Profile Only | — | Unknown | — | — | — | — | Not Applicable | — | Unable to Verify | Low | — | — | 2026-07-23 |

## Rules Demonstrated

- **A0–A4 each appear at least once:** Michal Bar/Amit Shani (A0), Dana Segal-Mor/Noa Cohen/Liora Fein (A1), Tal Regev/Eitan Shalev (A2), Yossi Katz/Dana Segal (A3), Roi Ashkenazi/Noa Peretz (A4) — per [Activity Record Rules](../../schemas/activity-record.schema.md#activity-record-rules).
- **Authored vs. reposted content:** Roi Ashkenazi, Noa Peretz, Yossi Katz, and Eitan Shalev authored their posts; Dana Segal and Tal Regev reposted content from others.
- **Hiring-related content:** Roi Ashkenazi, Noa Peretz, Yossi Katz, and Dana Segal — `hiring_related: true`.
- **Matching .NET/enterprise backend role:** Roi Ashkenazi and Noa Peretz both reference "Senior .NET Developer," meaningfully matching Tova's target roles, meeting the A4 bar per rule 5.
- **Old post with unknown current status:** Yossi Katz's and Dana Segal's posts are hiring-related and dated within the window, but their `job_status` is explicitly "Post Found, Current Status Unknown" rather than assumed open — the post's existence does not prove the role remains available, per rule 8.
- **Stale activity:** Eitan Shalev's most recent known post (2026-03-02) falls outside the 2026-04-24–2026-07-23 lookback window; `verification_status` is Stale, `stale_reason` is populated, and `refresh_required` is `true` — but this does not silently drop him from the People Map, per rule 9.
- **Failed verification:** Liora Fein's activity page access could not be confirmed; `verification_status` is Unable to Verify rather than the entry being omitted, per rule 9.
- **Job status verified separately from post existence:** Roi Ashkenazi and Noa Peretz's posts have `job_status: Verified Open` (separately confirmed via the company careers page), while Yossi Katz and Dana Segal's equally real, hiring-related posts have `job_status: Post Found, Current Status Unknown` because that separate verification was not possible — demonstrating that a post's existence alone never determines `job_status`.

## Related documents

- [../../schemas/activity-record.schema.md](../../schemas/activity-record.schema.md)
- [../../core/freshness-policy.md](../../core/freshness-policy.md)
- [people-map.md](people-map.md)
- [outreach-queue.md](outreach-queue.md)
