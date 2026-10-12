---


title: "Reading EXPLAIN ANALYZE in Postgres Without Getting Lost"
description: "AI tool guide"
date: 2026-09-20
slug: "reading-explain-analyze-postgres"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---


title: Reading EXPLAIN ANALYZE in Postgres Without Getting Lost
description: "AI tool guide"
  interpret query plans, identify bottlenecks and optimize database performance.
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack: - Python
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
last_maintained: "2026-05-15"
draft: false
aliases:
  - /en/posts/reading-explain-analyze-postgres/
- /posts/reading-explain-analyze-postgres/
faqs: - q: 'What does the top line''s actual time mean in EXPLAIN ANALYZE output?'
    a: 'The outermost node''s second actual time value is the wall-clock cost of the whole query in milliseconds for one execution of that node. Every node below it breaks down where that total time was spent.'
  - q: 'How do I find a bad query plan from EXPLAIN ANALYZE row counts?'
    a: 'Compare the planner''s estimated rows= (in the cost= section) against the actual rows= (in the actual time= section). When they disagree by 10x or more, the planner used bad statistics, and every node above it was chosen on a wrong assumption—that is almost always the bug.'
  - q: 'How do I calculate the time spent in just one EXPLAIN ANALYZE node?'
    a: 'For nodes with loops=1, self time is approximately this node''s last-row time (B) minus the sum of its children''s last-row times. For a node with large loops=N, the reported times are per-loop, so multiply by loops to get the total.'
  - q: 'What is the difference between shared hit and shared read in EXPLAIN (ANALYZE, BUFFERS)?'
    a: 'shared hit counts pages already in Postgres'' buffer cache and is cheap, while shared read counts pages fetched from the OS or disk and is expensive. If read dominates, the data simply isn''t cached—run the query twice, since the second run reflects steady state.'
  - q: 'What does temp written mean on a Sort or Hash node in a query plan?'
    a: 'It means the sort or hash didn''t fit in work_mem and spilled to disk, which can easily multiply a node''s time by 10x. The fix is to bump work_mem for that session and re-run EXPLAIN.'
