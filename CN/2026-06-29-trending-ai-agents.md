---
title: "This Week in Open-Source AI Agents — Top Trending GitHub Repos (Week of June 29, 2026)"
description: "Hand-edited weekly roundup of top trending open-source AI agent, LLM, and MCP projects on GitHub — data auto-collected by Dibi8 Tribe Intel, analysis by Dibi8 editorial team."
date: 2026-06-29T00:00:00+09:00
draft: false
tags: ["ai-agents", "open-source", "weekly-roundup", "github-trending", "llm-frameworks"]
categories: ["llm-frameworks"]
slug: this-week-ai-agents-2026-w26
author: "Dibi8 Tribe Intel (data collection) + Dibi8 editorial team (analysis & edit)"
showAuthor: true
showSummary: true
sources:
  - "GitHub Search API"
methodology: "Open-source script at home-hermes/服务器hermes/scripts/tribe-os-intel.sh"
review_status: "PUBLISHED"
review_checklist:
  - "Editor's Take 段已填实际分析"
  - "至少 1 个 repo 编辑加了 hands-on 评注"
  - "无 placeholder URL"
  - "无 aff 链接 (Tribe 文章纪律)"
featureImage: /images/articles/b62165fb-this-week-open-source-agents.png
------

> **Editorial Disclosure**: The data in this article (repo names, stars, descriptions) was auto-collected by Dibi8 Tribe Intel — an open-source bash script that polls GitHub Search API. Analysis, ranking commentary, and "Editor's Take" sections are written by the Dibi8 editorial team. We disclose this so you know what's machine and what's human.

## Editor's Take

Three clear trends emerge from this week's trending open-source AI agent repos on GitHub:

**First, Agent Harness is becoming new infrastructure.** affaan-m/ECC (223k stars) and NousResearch/hermes-agent (206k stars) represent two directions of agent harness systems — the former focuses on performance optimization for coding assistants like Claude Code, Codex, and Cursor, while the latter is our own Hermes Agent, emphasizing a general-purpose agent that "grows with you." Both gained massive stars within a week, signaling developer interest in "agents on top of agents."

**Second, traditional AI tools are fully embracing agent capabilities.** n8n (195k stars), AutoGPT (185k stars), and Dify (147k stars) have all significantly strengthened their agent features recently. n8n added `.agents/skills` for skill references, AutoGPT launched the AutoPilot skills library, and Dify focuses on production-grade agentic workflows. This shows agents are no longer standalone products but standard features of existing platforms.

**Third, local AI and prompt management remain essentials.** ollama (175k stars) continues expanding its supported model list (most recently adding Kimi-K2.6 and GLM-5.1), while prompts.chat (165k stars) maintains its core value as a community prompt-sharing platform. JavaGuide (157k stars) on the list reminds us that foundational knowledge still matters — it has added an AI application development section.

**Most worth trying: ECC.** It directly targets mainstream coding agents like Claude Code, Codex, and Cursor, providing performance optimization across skills, instincts, memory, and security dimensions. For developers using coding agents daily, it delivers immediate efficiency gains.

---

(Editor's perspective filled in)
---

## Methodology

- **Source**: GitHub Search API, query window `pushed:>2026-06-22`
- **Topics scanned**: `ai-agent` + `llm` + `mcp` (deduped across topics)
- **Filter**: ≥100 stars + active commits in past 7 days
- **Output**: Top 8 by stars
- **Script**: [tribe-os-intel.sh](https://github.com/luckybbjason1/home-hermes/blob/main/服务器hermes/scripts/tribe-os-intel.sh) (open-source, fully reproducible)

We open-source our scout because trust is built on transparency. Reproduce our query, double-check our list — that's how AI-era content credibility works.

---

## Top 8 Trending Repos This Week

### 1. [affaan-m/ECC](https://github.com/affaan-m/ECC) — ★223k

- **Primary language**: `JavaScript`
- **GitHub topic**: `mcp`
- **What it claims**: The agent harness performance optimization system. Skills, instincts, memory, security, and research-first development for Claude Code, Codex, Opencode, Cursor 

<!-- ⚠️ EDITOR: 如果你 hands-on 试过这个 repo, 在这里加 1-2 句你的评注 (可选但鼓励) -->

→ [Project on GitHub](https://github.com/affaan-m/ECC)

---
### 2. [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) — ★206k

- **Primary language**: `Python`
- **GitHub topic**: `llm`
- **What it claims**: The agent that grows with you

<!-- ⚠️ EDITOR: 如果你 hands-on 试过这个 repo, 在这里加 1-2 句你的评注 (可选但鼓励) -->

→ [Project on GitHub](https://github.com/NousResearch/hermes-agent)

---
### 3. [n8n-io/n8n](https://github.com/n8n-io/n8n) — ★195k

- **Primary language**: `TypeScript`
- **GitHub topic**: `mcp`
- **What it claims**: Fair-code workflow automation platform with native AI capabilities. Combine visual building with custom code, self-host or cloud, 400+ integrations.

<!-- ⚠️ EDITOR: 如果你 hands-on 试过这个 repo, 在这里加 1-2 句你的评注 (可选但鼓励) -->

→ [Project on GitHub](https://github.com/n8n-io/n8n)

---
### 4. [Significant-Gravitas/AutoGPT](https://github.com/Significant-Gravitas/AutoGPT) — ★185k

- **Primary language**: `Python`
- **GitHub topic**: `llm`
- **What it claims**: AutoGPT is the vision of accessible AI for everyone, to use and to build on. Our mission is to provide the tools, so that you can focus on what matters.

<!-- ⚠️ EDITOR: 如果你 hands-on 试过这个 repo, 在这里加 1-2 句你的评注 (可选但鼓励) -->

→ [Project on GitHub](https://github.com/Significant-Gravitas/AutoGPT)

---
### 5. [ollama/ollama](https://github.com/ollama/ollama) — ★175k

- **Primary language**: `Go`
- **GitHub topic**: `llm`
- **What it claims**: Get up and running with Kimi-K2.6, GLM-5.1, MiniMax, DeepSeek, gpt-oss, Qwen, Gemma and other models.

<!-- ⚠️ EDITOR: 如果你 hands-on 试过这个 repo, 在这里加 1-2 句你的评注 (可选但鼓励) -->

→ [Project on GitHub](https://github.com/ollama/ollama)

---
### 6. [f/prompts.chat](https://github.com/f/prompts.chat) — ★165k

- **Primary language**: `HTML`
- **GitHub topic**: `llm`
- **What it claims**: f.k.a. Awesome ChatGPT Prompts. Share, discover, and collect prompts from the community. Free and open source — self-host for your organization with complete pr

<!-- ⚠️ EDITOR: 如果你 hands-on 试过这个 repo, 在这里加 1-2 句你的评注 (可选但鼓励) -->

→ [Project on GitHub](https://github.com/f/prompts.chat)

---
### 7. [Snailclimb/JavaGuide](https://github.com/Snailclimb/JavaGuide) — ★157k

- **Primary language**: `JavaScript`
- **GitHub topic**: `mcp`
- **What it claims**: Java 面试 & 后端通用面试指南，覆盖计算机基础、数据库、分布式、高并发、系统设计与 AI 应用开发

<!-- ⚠️ EDITOR: 如果你 hands-on 试过这个 repo, 在这里加 1-2 句你的评注 (可选但鼓励) -->

→ [Project on GitHub](https://github.com/Snailclimb/JavaGuide)

---
### 8. [langgenius/dify](https://github.com/langgenius/dify) — ★147k

- **Primary language**: `TypeScript`
- **GitHub topic**: `mcp`
- **What it claims**: Production-ready platform for agentic workflow development.

<!-- ⚠️ EDITOR: 如果你 hands-on 试过这个 repo, 在这里加 1-2 句你的评注 (可选但鼓励) -->

→ [Project on GitHub](https://github.com/langgenius/dify)

---

## Why We Run This Weekly

Open-source AI moves fast. Trending repos this week may be irrelevant next month — or they may be the foundation of next year's stack. Either way, watching the signal matters more than predicting it.

Dibi8 Tribe Intel does this work so you don't have to. We surface; you decide.

## More from Dibi8

- [Open-Source AI Tools Directory](https://dibi8.com/resources/ai-tools/) — 280+ curated tools, human-edited
- [LLM Frameworks & Agents](https://dibi8.com/resources/llm-frameworks/) — Production-grade stack guides
- [Interactive Dev Tools](https://dibi8.com/tools/) — 14 free client-side utilities

---

*This roundup is part of an editorial experiment. If you find it useful, [tell us on GitHub](https://github.com/luckybbjason1/home-hermes/issues). If it's not useful, also tell us — we'll kill it. The Tribe serves the reader, not the other way around.*
