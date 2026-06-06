---
title: Reading EXPLAIN ANALYZE in Postgres Without Getting Lost
description: Reading EXPLAIN ANALYZE in PostgreSQL without getting lost. Learn to
  interpret query plans, identify bottlenecks and optimize database performance.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Python
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: ''
last_maintained: '2026-05-15'
featureImage: ''
draft: false
aliases:
- /en/posts/reading-explain-analyze-postgres/
- /posts/reading-explain-analyze-postgres/
faqs:
  - q: 'What does the top line''s actual time mean in EXPLAIN ANALYZE output?'
    a: 'The outermost node''s second actual time value is the wall-clock cost of the whole query in milliseconds for one execution of that node. Every node below it breaks down where that total time was spent.'
  - q: 'How do I find a bad query plan from EXPLAIN ANALYZE row counts?'
    a: 'Compare the planner''s estimated rows= (in the cost= section) against the actual rows= (in the actual time= section). When they disagree by 10x or more, the planner used bad statistics, and every node above it was chosen on a wrong assumption—that is almost always the bug.'
  - q: 'How do I calculate the time spent in just one EXPLAIN ANALYZE node?'
    a: 'For nodes with loops=1, self time is approximately this node''s last-row time (B) minus the sum of its children''s last-row times. For a node with large loops=N, the reported times are per-loop, so multiply by loops to get the total.'
  - q: 'What is the difference between shared hit and shared read in EXPLAIN (ANALYZE, BUFFERS)?'
    a: 'shared hit counts pages already in Postgres'' buffer cache and is cheap, while shared read counts pages fetched from the OS or disk and is expensive. If read dominates, the data simply isn''t cached—run the query twice, since the second run reflects steady state.'
  - q: 'What does temp written mean on a Sort or Hash node in a query plan?'
    a: 'It means the sort or hash didn''t fit in work_mem and spilled to disk, which can easily multiply a node''s time by 10x. The fix is to bump work_mem for that session and re-run EXPLAIN.'
---

{</* resource-info */>}

The first time you see Postgres `EXPLAIN ANALYZE` output, it looks like
a Christmas tree of numbers. Most of them are noise for the question you
actually have: *why is this query slow?*

Here's the order I read it in after a few hundred of these.

## A query to anchor on

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT u.id, u.email, count(o.id) AS order_count
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
WHERE u.signup_at > now() - interval '30 days'
GROUP BY u.id;
```

A typical output snippet:

```
HashAggregate  (cost=12345.67..23456.78 rows=10000 width=48)
               (actual time=412.331..480.219 rows=8742 loops=1)
  ->  Hash Right Join  (cost=2345.67..11234.56 rows=120000 width=44)
                       (actual time=18.221..380.115 rows=98213 loops=1)
        ...
        Buffers: shared hit=18234 read=4521
```

That's enough output to learn the technique on.

## Step 1: Look at the top line's `actual time`

The outermost node's second `actual time` is the wall-clock cost of the
whole query (in ms, for one execution of that node). In the example
above: **480 ms**. Everything else in the plan is breaking down where
those 480 ms went.

If the top number is fine and you're chasing a slow query report,
double-check that you're explaining the same query the application
runs. Different parameter values produce different plans.

## Step 2: Compare `rows=` estimate vs actual

Each line has two row counts:

- `rows=N` in the `cost=…` part — the **planner's estimate**
- `rows=N` in the `actual time=…` part — what **really happened**

When these disagree by 10× or more, the planner is operating on bad
statistics, and *every node above it* has been chosen using a wrong
assumption. That's almost always your bug.

In the example above the planner expected the join to produce 120,000
rows and it produced 98,213. That's fine, ~20% off. But if I saw
something like estimate 100, actual 1,000,000 — full stop, that's the
problem. Common causes:

- Stale statistics → run `ANALYZE the_table` and re-explain.
- Correlated columns → set `CREATE STATISTICS` on the column pair, or
  rewrite the predicate.
- Skewed data the planner can't model → sometimes you need a hint via
  `pg_hint_plan` or query rewrite.

## Step 3: Find where the time actually went

Each node's `actual time=A..B loops=L` reads as: *"first row produced
at A ms after start, last row produced at B ms; this node ran L times."*

To get the time spent in *just this node* (excluding children), you
have to subtract the children's `actual time` ranges. For the common
case of `loops=1`, the simple version is:

> **Self time ≈ this node's `B` − sum of children's `B` values**

I scan the plan top-down looking for the node with the biggest self
time. That's where the optimization budget should go.

A node with `loops=N` where N is large (a `Nested Loop` inner side, for
example) reports per-loop times. Multiply by `loops` to get total.

## Step 4: Use `BUFFERS` to tell I/O from CPU

`EXPLAIN (ANALYZE, BUFFERS)` adds lines like:

```
Buffers: shared hit=18234 read=4521
```

- `shared hit` — pages already in Postgres' buffer cache. Cheap.
- `shared read` — pages fetched from the OS / disk. Expensive.
- `temp written / read` — sorts or hashes that didn't fit in `work_mem`
  and spilled to disk. Also expensive.

If `read` dominates, the plan is fine but the data isn't in cache. Run
the query twice — the second run is more representative of steady
state. If both runs are slow with high `read`, the working set doesn't
fit and you need either more RAM, an index that touches fewer pages, or
a smaller query.

If you see `temp written` appearing on a `Sort` or `Hash` node, bump
`work_mem` for that session and re-explain. A spill to disk can easily
multiply a node's time by 10×.

## The three patterns I see most often

After all that, the actual bugs cluster into a few shapes:

**1. Sequential scan on a "should-be-indexed" column.** Plan node says
`Seq Scan on big_table  Filter: (...)` and rows-removed-by-filter is
huge. Add an index on the filter column. Don't add it if the table is
small or the filter is non-selective; the planner's choice was correct.

**2. Nested Loop where Hash Join was expected.** Inner side runs
thousands of times. Almost always caused by row estimate being too low
upstream (Step 2 problem). Fix the stats or rewrite the predicate, then
the planner picks the right join.

**3. Aggregate over a join that should be filtered first.** The plan
joins everything and then filters. Push the filter into a subquery or
CTE so it applies before the join, reducing the row count the join has
to handle.

## A quick reading checklist

When someone hands me an `EXPLAIN ANALYZE`, I do this in order:

1. Total time at the top — is it actually slow?
2. Any node with `rows` estimate vs actual off by ≥10×? — that's the bug.
3. Which node has the biggest self-time? — that's the budget.
4. Any `temp written` or unusually high `shared read`? — I/O issue.
5. Match the slow node to one of the three patterns above.

That's it. It's not magic, but the order matters — chasing the biggest
self-time before checking the row estimates leads you to optimize the
*symptom* of a bad plan rather than fixing the plan itself.


## Related Articles

- [Python Context Managers: The Three Cases You Actually Need](/resources/ai-tools/python-context-managers-the-three-cases-you-actually-need/) — Python resource management
- [Scrapling Reviewed: A Faster, Stealthier Take on Python Scraping](/resources/dev-utils/scrapling-python-stealthy-web-scraping-review/) — Data extraction techniques
- [Agent Reach: Give Your AI Agent Internet Superpowers](/resources/llm-frameworks/agent-reach-ai-agent-internet-access/) — AI-powered development tools

---

## Recommended Tools

For developers building or deploying open-source AI tools, we recommend:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for new users, 14+ global regions, one-click GPU/CPU droplets ideal for AI workloads.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API proxy. Most AI tools above (chatbots, code gen, translation, search, etc) need an LLM API key — this proxy delivers stable access to top models at ~30% of official pricing.

*Affiliate link — supports dibi8.com at no cost to you.*

