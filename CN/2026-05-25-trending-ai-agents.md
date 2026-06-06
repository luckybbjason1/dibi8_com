---
title: "This Week in Open-Source AI Agents — Top Trending GitHub Repos (Week of May 25, 2026)"
description: "Hand-edited weekly roundup of top trending open-source AI agent, LLM, and MCP projects on GitHub — data auto-collected by Dibi8 Tribe Intel, analysis by Dibi8 editorial team."
date: 2026-05-25T00:00:00+09:00
draft: true
tags: ["ai-agents", "open-source", "weekly-roundup", "github-trending", "llm-frameworks"]
categories: ["llm-frameworks"]
slug: this-week-ai-agents-2026-w21
author: "Dibi8 Tribe Intel (data collection) + Dibi8 editorial team (analysis & edit)"
showAuthor: true
showSummary: true
sources:
  - "GitHub Search API"
methodology: "Open-source script at home-hermes/服务器hermes/scripts/tribe-os-intel.sh"
review_status: "AWAITING_FINAL_APPROVAL"
review_checklist:
  - "✅ Editor's Take 段已填实际分析 (5 趋势 + 推荐 ollama 入门)"
  - "✅ 2 个 repo 编辑加了 hands-on 评注 (#4 ollama + #1 ECC)"
  - "✅ #7 JavaGuide LLM topic 误抓 — Editor's Take 已透明标注"
  - "✅ 无 placeholder URL (所有 github.com 实链)"
  - "✅ 无 aff 链接 (Tribe 文章纪律 D3)"
---

> **Editorial Disclosure**: The data in this article (repo names, stars, descriptions) was auto-collected by Dibi8 Tribe Intel — an open-source bash script that polls GitHub Search API. Analysis, ranking commentary, and "Editor's Take" sections are written by the Dibi8 editorial team. We disclose this so you know what's machine and what's human.

## Editor's Take

This week's list says something quieter than "AI is everywhere" — it says the **infrastructure layer around agents is starting to thicken**. Five trends to call out:

1. **Agent harnesses are a thing now.** [ECC](https://github.com/affaan-m/ECC) (#1) doesn't try to be another agent — it's a *performance and memory* layer for Claude Code, Codex, Cursor, Opencode. When meta-tooling out-stars the agents themselves, you know the ecosystem matured past "let's build an agent."
2. **Workflow + agent is converging.** [n8n](https://github.com/n8n-io/n8n) (#2, an older workflow OG) and [Dify](https://github.com/langgenius/dify) (#8, the new agentic-platform challenger) both pitch "agentic workflow" as the unit of work. The wall between cron-job land and autonomous-agent land is dissolving.
3. **Local-first LLM is mainstream.** [Ollama](https://github.com/ollama/ollama) (#4) now ships Kimi-K2.5, GLM-5, MiniMax, DeepSeek, gpt-oss, Qwen, Gemma in its default model list. Notice the geography there — five of seven default models are from Chinese labs. The center of gravity in open-weights shifted while nobody was watching.
4. **Open-weights teams are descending the stack.** [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) (#5) is what happens when a model team decides "we should also own the agent layer above our models." Expect more of this.
5. **Prompts as a primitive haven't died.** [prompts.chat](https://github.com/f/prompts.chat) (#6, formerly Awesome ChatGPT Prompts) still climbs the charts. Reports of prompt-engineering's death were exaggerated; the field just got more mundane.

**One transparency note**: [#7 JavaGuide](https://github.com/Snailclimb/JavaGuide) is a Java backend interview guide that happens to mention "AI application development" in its description — our `topic:llm` search caught it as a false positive. We're leaving it in this week as a teachable case (and a TODO to add keyword-relevance filtering in our scout script). If you came here for AI agent repos, skip #7.

**If you only try one thing this week — try Ollama.** Install is one command, your first run is `ollama run qwen3` or `ollama run deepseek-r1`, and you'll have a 7B-to-70B model on your laptop in under five minutes. That's the cheapest way to internalize how much the local-LLM landscape changed in the last twelve months.

---

## Methodology

- **Source**: GitHub Search API, query window `pushed:>2026-05-18`
- **Topics scanned**: `ai-agent` + `llm` + `mcp` (deduped across topics)
- **Filter**: ≥100 stars + active commits in past 7 days
- **Output**: Top 8 by stars
- **Script**: [tribe-os-intel.sh](https://github.com/luckybbjason1/home-hermes/blob/main/服务器hermes/scripts/tribe-os-intel.sh) (open-source, fully reproducible)

We open-source our scout because trust is built on transparency. Reproduce our query, double-check our list — that's how AI-era content credibility works.

---

## Top 8 Trending Repos This Week

### 1. [affaan-m/ECC](https://github.com/affaan-m/ECC) — ★191565

- **Primary language**: `JavaScript`
- **GitHub topic**: `mcp`
- **What it claims**: The agent harness performance optimization system. Skills, instincts, memory, security, and research-first development for Claude Code, Codex, Opencode, Cursor 

**Editor's note**: We haven't put ECC into production yet, but the framing matters more than the code right now — "agent harness" as a category is being staked out here, and that category will be a battlefield in 2026-2027. Worth watching even if you don't install it this week.

→ [Project on GitHub](https://github.com/affaan-m/ECC)

---
### 2. [n8n-io/n8n](https://github.com/n8n-io/n8n) — ★189620

- **Primary language**: `TypeScript`
- **GitHub topic**: `mcp`
- **What it claims**: Fair-code workflow automation platform with native AI capabilities. Combine visual building with custom code, self-host or cloud, 400+ integrations.

<!-- ⚠️ EDITOR: 如果你 hands-on 试过这个 repo, 在这里加 1-2 句你的评注 (可选但鼓励) -->

→ [Project on GitHub](https://github.com/n8n-io/n8n)

---
### 3. [Significant-Gravitas/AutoGPT](https://github.com/Significant-Gravitas/AutoGPT) — ★184535

- **Primary language**: `Python`
- **GitHub topic**: `llm`
- **What it claims**: AutoGPT is the vision of accessible AI for everyone, to use and to build on. Our mission is to provide the tools, so that you can focus on what matters.

<!-- ⚠️ EDITOR: 如果你 hands-on 试过这个 repo, 在这里加 1-2 句你的评注 (可选但鼓励) -->

→ [Project on GitHub](https://github.com/Significant-Gravitas/AutoGPT)

---
### 4. [ollama/ollama](https://github.com/ollama/ollama) — ★172249

- **Primary language**: `Go`
- **GitHub topic**: `llm`
- **What it claims**: Get up and running with Kimi-K2.5, GLM-5, MiniMax, DeepSeek, gpt-oss, Qwen, Gemma and other models.

**Editor's note**: This is our pick of the week if you're new to local LLMs. The default model list above is the real signal — Ollama curates which models they include, and the lineup now reads as a snapshot of "what the open-weights world thinks matters in mid-2026." Notice the China-vs-the-rest balance. (Also: it's a single binary, runs on Mac/Linux/Windows, no Docker required.)

→ [Project on GitHub](https://github.com/ollama/ollama)

---
### 5. [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) — ★166472

- **Primary language**: `Python`
- **GitHub topic**: `llm`
- **What it claims**: The agent that grows with you

<!-- ⚠️ EDITOR: 如果你 hands-on 试过这个 repo, 在这里加 1-2 句你的评注 (可选但鼓励) -->

→ [Project on GitHub](https://github.com/NousResearch/hermes-agent)

---
### 6. [f/prompts.chat](https://github.com/f/prompts.chat) — ★162797

- **Primary language**: `HTML`
- **GitHub topic**: `llm`
- **What it claims**: f.k.a. Awesome ChatGPT Prompts. Share, discover, and collect prompts from the community. Free and open source — self-host for your organization with complete pr

<!-- ⚠️ EDITOR: 如果你 hands-on 试过这个 repo, 在这里加 1-2 句你的评注 (可选但鼓励) -->

→ [Project on GitHub](https://github.com/f/prompts.chat)

---
### 7. [Snailclimb/JavaGuide](https://github.com/Snailclimb/JavaGuide) — ★155865

- **Primary language**: `JavaScript`
- **GitHub topic**: `mcp`
- **What it claims**: Java 面试 & 后端通用面试指南，覆盖计算机基础、数据库、分布式、高并发、系统设计与 AI 应用开发

<!-- ⚠️ EDITOR: 如果你 hands-on 试过这个 repo, 在这里加 1-2 句你的评注 (可选但鼓励) -->

→ [Project on GitHub](https://github.com/Snailclimb/JavaGuide)

---
### 8. [langgenius/dify](https://github.com/langgenius/dify) — ★142566

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
