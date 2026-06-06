---
title: 阅读 PostgreSQL 中的 EXPLAIN ANALYZE 输出而不迷失
description: PostgreSQL EXPLAIN ANALYZE tutorial. Learn query plan interpretation,
  bottleneck detection, and database performance optimization.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- AI
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
- /zh/posts/reading-explain-analyze-postgres/
faqs:
  - q: 'EXPLAIN ANALYZE 输出中，顶行的 actual time 代表什么意思？'
    a: '最外层节点的第二个 actual time 值，是整条查询在毫秒级别的实际挂钟耗时（该节点执行一次的时间）。它下面的每个节点则进一步拆解了这段总耗时花在了哪里。'
  - q: '如何通过 EXPLAIN ANALYZE 的行数判断查询计划有问题？'
    a: '对比 cost= 部分的 rows=（规划器估算值）和 actual time= 部分的 rows=（实际值）。如果两者相差 10 倍或以上，说明规划器使用了过时的统计信息，而它之上的每一个节点都是基于错误假设选出来的——这几乎必然就是问题所在。'
  - q: '如何计算 EXPLAIN ANALYZE 中某个单独节点的自身耗时？'
    a: '对于 loops=1 的节点，自身耗时约等于该节点的最后一行时间（B）减去所有子节点的最后一行时间之和。对于 loops=N 较大的节点，输出的时间是每次循环的时间，需乘以 loops 才能得到总耗时。'
  - q: 'EXPLAIN (ANALYZE, BUFFERS) 中，shared hit 和 shared read 有什么区别？'
    a: 'shared hit 统计的是已在 Postgres 缓冲区缓存中的页面，读取代价低；shared read 统计的是从操作系统或磁盘获取的页面，代价高昂。如果 read 占主导，说明数据根本没有被缓存——运行两次查询，第二次的结果才能反映稳定状态。'
  - q: '查询计划中 Sort 或 Hash 节点上出现 temp written 是什么意思？'
    a: '这意味着排序或哈希操作超出了 work_mem 的限制，数据溢出到了磁盘，这很容易让该节点的耗时增加 10 倍。解决方法是为该会话调大 work_mem，然后重新运行 EXPLAIN。'
---

{</* resource-info */>}

EXPLAIN ANALYZE 输出看起来令人生畏，直到您知道实际重要的三个数字。以下是我阅读它们的顺序，以及指向特定错误的模式。

## 实际重要的三个数字

### 1. **总执行时间 (Execution Time)**
```
Total runtime: 1234.567 ms
```
这是最重要的指标。如果查询慢，这里会告诉您。

### 2. **实际行数 vs 估计行数 (Actual vs Estimated Rows)**
```
Seq Scan on users  (cost=0.00..123.45 rows=1000 width=32) (actual time=1.234..567.890 rows=50000 loops=1)
```
巨大差异表明规划器做出了错误假设。

### 3. **缓冲区命中率 (Buffer Hit Ratio)**
```
Buffers: shared hit=1000 read=50
```
高命中率 = 好缓存使用，低命中率 = 磁盘 I/O 问题。

## 阅读顺序

1. **从底部开始** - 总执行时间
2. **向上工作** - 查找成本最高的节点
3. **检查行数估计** - 实际 vs 估计
4. **查看缓冲区统计** - I/O 模式

## 常见问题模式

### **顺序扫描当应该索引扫描时**
```
Seq Scan on large_table (cost=1000.00..2000.00 rows=100000 width=32)
```
**解决方案**: 添加适当的索引

### **嵌套循环当应该哈希连接时**
```
Nested Loop (cost=1000.00..100000.00 rows=1000 width=64)
  -> Seq Scan on users
  -> Index Scan on orders
```
**解决方案**: 增加 work_mem 或重写查询

### **缓冲区未命中太多**
```
Buffers: shared hit=10 read=1000
```
**解决方案**: 增加 shared_buffers 或改善查询

### **排序溢出到磁盘**
```
Sort Method: external merge  Disk: 16384kB
```
**解决方案**: 增加 work_mem

## 实际应用

这些洞察帮助我识别并修复了：
- 缺失索引
- 低效的连接顺序
- 内存不足的问题
- 缓存未命中

记住：EXPLAIN ANALYZE 是您的查询性能调试器。学习阅读它将节省您无数小时的猜测。

---

## 推荐工具

跑或部署开源 AI 工具时，推荐：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心，AI 工作流 droplet 一键部署。
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Claude / OpenAI / DeepSeek API 中转。上面的 AI 工具 (chatbot / 代码生成 / 翻译 / 搜索 等) 大多需要 LLM API key — 这个中转给你稳定访问顶级模型, 价格约官方 30%。

*推广链接 — 不增加你的成本，能支持 dibi8.com 持续运营。*

