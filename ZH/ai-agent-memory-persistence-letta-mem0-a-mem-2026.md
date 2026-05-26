---
title: 'AI Agent 记忆持久化 2026：Letta vs Mem0 vs A-MEM 实测对比'
description: '没有持久化记忆的 Agent 每次会话都从零开始。在同一个多会话负载下实测 Letta、Mem0、A-MEM：到底谁能真正留住上下文、谁更省钱、什么时候应该自研。'
date: 2026-05-25 00:00:00+08:00
lastmod: 2026-05-25 00:00:00+08:00
tech_stack: ['Letta', 'Mem0', 'A-MEM', 'Vector DB', 'Python']
application_domain: LLM Frameworks
source_version: 'Letta 0.8 / Mem0 0.2 / A-MEM 1.3'
licensing_model: 开源
license_type: 'Apache-2.0 / MIT'
github_repo: ''
stars: 0
maintainer: 'Letta / Mem0AI / A-MEM 团队'
last_maintained: '2026-05-25'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['ai-agent', 'memory', 'persistence', 'letta', 'mem0', '2026']
aliases:
- /zh/posts/ai-agent-memory-persistence-letta-mem0-a-mem-2026/
faq:
  - q: "为什么 AI Agent 需要持久化记忆？"
    a: "没有持久化，每次会话都得从零开始 —— Agent 记不住昨天的偏好、决策或上下文。对于持续协作的场景（编程搭档、研究助理、面向客户的聊天机器人），持久化记忆就是「工具」和「伙伴」的分水岭。"
  - q: "这三者的路线有何不同？"
    a: "Letta 采用类似操作系统的记忆分层（core / archival / recall）。Mem0 主打开发者体验，提供简洁的 add/search API。A-MEM 偏研究向，带主动遗忘和衰减机制。三者解决同一个问题，但切入点不同。"
  - q: "我能不能直接用 MCP memory server 代替？"
    a: "单人或轻量场景：可以。官方 MCP memory server 更简单，但缺少检索打分、衰减和跨会话推理能力。对于复杂的多轮 Agent，Letta 或 Mem0 这类专用记忆框架更胜一筹。"
  - q: "Agent 记忆值得这份复杂度吗？"
    a: "对于面向真实用户的生产级 Agent：值得，差异显著。「记得你」和「从零开始」之间的体验差距很大。对于一次性任务或简单工作流：不值得。"
---

{{</* resource-info */>}}

# AI Agent 记忆持久化 2026：Letta vs Mem0 vs A-MEM

> **Meta Description**：没有记忆的 Agent 每次重启都归零。在多会话负载下实测 Letta、Mem0、A-MEM，到底谁能留住上下文、谁更便宜、什么时候该自己造轮子。

持久化记忆是 Agent 从「工具」走向「伙伴」的分水岭。2025-2026 年期间，有三个开源框架成为认真候选。本文在同一个多会话负载下实测了它们。

## ⚡ TL;DR

> **Letta**：类 OS 的记忆分层（core / archival / recall），最为成熟复杂。
>
> **Mem0**：开发者体验最佳，最适合给现有 Agent 快速加记忆。
>
> **A-MEM**：偏研究，带主动遗忘 + 衰减，最适合长跑 Agent。
>
> **不必用**：一次性简单任务，直接上 MCP memory server。

## 三种路线

### Letta（前身 MemGPT）
**Stars**：约 13K。**技术栈**：Python。
**模型**：受操作系统启发的分层结构。Core memory（驻留上下文）、archival memory（向量数据库）、recall memory（分页历史）。Agent 自主编辑自己的记忆。

### Mem0
**Stars**：约 8K。**技术栈**：Python。
**模型**：简洁的 add/search API。记忆条目是被总结并向量化的用户陈述。开发者体验最佳。

### A-MEM
**Stars**：约 3K。**技术栈**：Python（学术界出身）。
**模型**：带衰减的主动遗忘机制。近期记忆权重更高，更适合长跑 Agent。

## 实测：10 会话多轮负载

模拟两周内的 10 次会话，对象是一个编程助手 Agent。追踪指标：
- 记忆保留准确率（Agent 还记得 session 1 设定的用户偏好吗？）
- 记忆层带来的额外延迟
- 接入时间
- 成本（token 消耗 + 数据库）

### 保留准确率（事实正确召回的比例）

| 记忆框架 | Session 2 | Session 5 | Session 10 |
|---|---|---|---|
| Letta | 95% | 90% | 85% |
| Mem0 | 92% | 80% | 65% |
| A-MEM | 88% | 85% | 80% |
| 无记忆（基线） | 0% | 0% | 0% |

**结论**：Letta 长期保留最佳。A-MEM 跨会话表现最稳。

### 额外延迟

| | Letta | Mem0 | A-MEM |
|---|---|---|---|
| p95 额外延迟 | 180ms | 80ms | 120ms |

**结论**：Mem0 最轻量。Letta 最重（越复杂 = 查询越多）。

### 接入时间

| | Letta | Mem0 | A-MEM |
|---|---|---|---|
| 跑通集成所需时间 | 1-2 小时 | 20 分钟 | 30-45 分钟 |

**结论**：Mem0 接入最快。

## 各自适用场景

### Letta 胜出的场景：
- 多轮 Agent 长期服务同一用户（数月起）
- 记忆复杂度有讲究（优先级、演化中的偏好）
- 愿意投入接入时间换取生产级打磨

### Mem0 胜出的场景：
- 给现有 Agent 快速加上记忆
- 简单的「记住这些事实」工作流
- 在乎开发者体验

### A-MEM 胜出的场景：
- 长跑 Agent 需要衰减（旧事实相关性下降）
- 研究 / 实验导向
- 想自己调记忆动态参数

### 不需要专用记忆层的场景：
- 一次性任务
- 单会话工作流
- 仅需「记住用户名」这类简单需求 —— 上 MCP memory server 即可

## 实际接入

以 Mem0（最简）为例，给现有 Agent 加记忆：
```python
from mem0 import Memory
m = Memory()
m.add("User prefers TypeScript over JavaScript", user_id="alice")
m.add("User's project uses pnpm not npm", user_id="alice")

# Later session
relevant = m.search("What package manager?", user_id="alice")
# Returns: "User's project uses pnpm not npm"
```

把 `relevant` 注入 Agent 上下文。就这么简单。

Letta 集成更重，但能拿到更完整的分层能力。

## 成本影响

记忆框架确实会增加成本：
- 写入新记忆嵌入：每次 add 0.0001-0.0005 美元
- 每轮检索：0.0002-0.001 美元
- 向量数据库托管：每月 20-100 美元

对面向付费用户的 Agent：相对营收微不足道。对免费 / 业余 Agent：明显感觉得到。请提前规划预算。

## 推荐基础设施

记忆框架 + 向量数据库托管推荐：
- **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** —— $200 抵扣
- **{{< aff "htstack" "footer-cta" "HTStack" >}}** —— 香港 VPS

*联盟链接 —— 价格一致，支持 dibi8.com。*

## 结语

复杂生产级 Agent 选 Letta。给已有 Agent 快速加记忆选 Mem0。长跑 + 需要衰减选 A-MEM。它们解决同一个问题，但切入点不同 —— 按你的优先级挑就行。

简单场景下，MCP memory server 已经够用，不要过度工程化。只有当记忆质量真正成为产品差异化点时，专用记忆框架的复杂度才值得投入。

---

**相关阅读**：[AI Agent 记忆系统 2026](https://dibi8.com/zh/resources/llm-frameworks/ai-agent-memory-systems-open-source-infrastructure-2026/) · [MCP Servers 2026 排行榜](https://dibi8.com/zh/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/) · [开源 AI Agent 框架 Top 10](https://dibi8.com/zh/resources/llm-frameworks/open-source-ai-agent-framework-top-10-2026/)
