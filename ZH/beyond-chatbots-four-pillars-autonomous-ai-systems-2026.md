---
title: "超越聊天机器人：2026年自主AI系统的四大支柱"
description: "Local Deep Research、InsForge、Agent Skills 和 Karpathy 原则如何构成真正的自主AI代理的完整技术栈——从深度研究到生产部署。"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Docker
  - Go
  - JavaScript
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "46.6 MB"
file_md5: ""
download_url: "https://github.com/LearningCircuit/local-deep-research"
backup_url: ""
github_repo: "https://github.com/LearningCircuit/local-deep-research"
stars: 7793
maintainer: "LearningCircuit"
last_maintained: "2026-05-16"
featureImage: ""
draft: false
aliases:
- /zh/posts/beyond-chatbots-four-pillars-autonomous-ai-systems-2026/
faqs:
  - q: '什么是 Local Deep Research，它的准确率有多高？'
    a: 'Local Deep Research 是 LearningCircuit 开发的一款开源 AI 研究工具，它会在 arXiv、PubMed、Semantic Scholar、SearXNG、Tavily 和 Brave Search 等来源上运行迭代式研究循环。据其报告，在 SimpleQA 基准测试上的准确率约为 95%，数据存储在按用户隔离、经 SQLCipher 加密的 SQLite 数据库（AES-256）中，且不含任何遥测。'
  - q: 'InsForge 用来做什么？'
    a: 'InsForge 是一个专为 agentic coding 打造的一体化开源后端平台，提供身份认证、带 PostgREST 自动 API 生成的 PostgreSQL 数据库、S3 兼容存储、edge functions、模型网关以及站点部署。它同时暴露了 MCP server 和 CLI 加 skills，让 AI agent 能够端到端地自行配置和部署后端。它基于 Apache 2.0 许可证授权。'
  - q: 'Addy Osmani 的 Agent Skills 中有哪七个斜杠命令？'
    a: 'Agent Skills 将七个命令映射到开发生命周期：/spec（定义需求）、/plan（拆分为原子任务）、/build（增量交付）、/test（以测试作为证明）、/review（改善代码健康度）、/code-simplify（清晰胜于花哨）和 /ship（增量发布）。Skills 会根据任务上下文自动激活。'
  - q: '面向 AI 编码、受 Karpathy 启发的四条行为原则是什么？'
    a: '这四条原则被写入一个 CLAUDE.md 文件中，分别是：编码前先思考（陈述假设，在臆断前先发问）、简单优先（构建最小可行方案）、外科手术式改动（只动必须动的部分，并与现有风格保持一致），以及目标驱动的执行（预先定义清晰的成功标准）。它们充当认知防护，抵御 LLM 的过度自信。'
  - q: '自主 AI 系统的四大支柱如何协同运作？'
    a: 'agent 首先使用 Local Deep Research 生成一份经过验证、带引用的报告，然后通过 MCP tool calls 使用 InsForge 配置完整的后端（数据库、edge functions、存储、认证），接着遵循 Agent Skills 的 spec-to-ship 工作流构建前端，并在整个过程中应用受 Karpathy 启发的行为护栏，以防止过度工程化和错误假设。每个支柱各自应对自主开发中一种独特的失败模式。'
---
{</* resource-info */>}

## The Evolution: From Chatbot to Autonomous System

我们正站在一个关键的转折点。 In 2024, we celebrated chatbots that could answer questions. In 2025, we marveled at agents that could browse the web. Now in mid-2026, something fundamentally different has emerged: **自主AI系统 that combine 深度研究, 基础设施配置, 代码生成, and 质量保证 into a 单一连贯的工作流.**

This isn't 渐进式改进. It's 架构演进. And four open-source projects reveal the pattern.

## Pillar 1: Deep Research — The Intelligence Layer

### [Local Deep Research](https://github.com/LearningCircuit/local-deep-research) by LearningCircuit

大多数AI工具给你答案。 Local Deep Research gives you *verified knowledge*.

让它在众多工具中脱颖而出的原因:

- **20+ 研究策略** including a LangGraph agent mode that autonomously decides which search engine to use, when to dig deeper, and when to synthesize
- **~95% 在SimpleQA基准测试中的准确率** — 与商业系统相当
- **隐私优先的架构**: SQLCipher-加密SQLite数据库 (AES-256), 无遥测、无分析、无追踪
- **多源情报整合**: arXiv, PubMed, Semantic Scholar, SearXNG, Tavily, Brave Search — 每个来源都经过索引和交叉引用
- **零知识加密**: User data isolated per-database, 即使是服务器管理员也无法读取你的内容

The 其架构设计值得深入研究:

```
User Query -> Strategy Selector -> Question Generator 
    -> Parallel Search (academic + web + documents) 
    -> Analysis Loop -> Report Synthesis -> Multi-format Export
```

What's novel is the **迭代研究循环**. Instead of 单次查询响应, the system generates 子问题, searches across diverse sources, analyzes results, and iterates until 置信度阈值 are met. This 模拟人类专家的研究方式: hypothesize, investigate, evaluate, refine.

The 安全模型特别值得关注. Every user gets an isolated SQLCipher database. The encryption uses 信号级AES-256安全性. No password recovery means 真正的零知识证明. Docker images are signed with Cosign and include SLSA provenance attestations. For developers who care about supply chain security, this is 企业级安全标准.

## Pillar 2: Infrastructure — The Platform Layer

### [InsForge](https://github.com/InsForge/InsForge) by InsForge

An AI agent that can research deeply still needs somewhere to deploy its work. Enter InsForge: 专为智能体编码设计的综合性开源后端平台.

Think of it as Firebase meets Vercel meets Render — but built for AI agents to operate directly.

Core capabilities:

- **Authentication**: Email/password + OAuth (Google, GitHub) with session management
- **Database**: PostgreSQL with PostgREST auto-API generation
- **Storage**: S3-compatible file storage for documents, media, assets
- **Edge Functions**: Serverless code deployment with automatic scaling
- **Model Gateway**: OpenAI-compatible API routing across multiple LLM providers
- **Compute**: Long-running container services (private preview)
- **Site Deployment**: Full site build and deployment pipeline

The key innovation is **双重接口支持**:

1. **MCP服务器** — 可自托管的接口，将InsForge操作暴露为标准化工具 that 任何MCP兼容的代理 (Claude Code, Cursor, Gemini CLI) can call
2. **命令行界面 + 技能系统** — Cloud-native command-line interface paired with executable skill definitions

This means an AI agent doesn't just generate code — it can 配置自己的数据库架构, configure authentication, deploy edge functions, set up storage buckets, and even route its own API calls through the model gateway. 端到端自主化.

The SDK is elegantly simple:

```javascript
import { createClient } from '@insforge/sdk';

const client = createClient({
  baseUrl: 'https://your-app.region.insforge.app',
  anonKey: 'your-anon-key-here'
});
```

Everything from database CRUD to auth flows to AI operations is available through this unified client. For a coding agent, this 将通常需要DevOps工程师完成的繁琐流程简化为单一的API调用.

Vercel supports this project through their OSS program, indicating strong industry validation. Licensed under Apache 2.0.

## Pillar 3: Engineering Discipline — The Quality Layer

### [Agent Skills](https://github.com/addyosmani/agent-skills) by Addy Osmani

没有纪律约束的原始能力只会产生混乱且无法维护的代码。 This is where Addy Osmani's Agent Skills come in — 生产级的工程工作流 packaged so AI agents follow 始终遵循高级工程师的标准.

The core insight: **技能系统编码了高级工程师在整个开发过程中使用的决策模式**. Not specific code — the *judgment* behind when and why to make certain decisions.

The 七个斜杠命令框架映射到完整的开发生命周期:

||Command|Phase|Principle||
||---------|-------|-----------||
||`/spec`|Define|先规范后代码——需求优先||
||`/plan`|Plan|小而原子化的任务——化解复杂性||
||`/build`|Build|一次只做一片增量——渐进式交付||
||`/test`|Verify|测试是证明——不是装饰品||
||`/review`|Review|改善代码健康度——持续精进||
||`/code-simplify`|Simplify|清晰胜过巧妙——可读性取胜||
||`/ship`|Ship|更快就是更安全——增量发布||

But the real magic is **上下文感知的自动发现**. When designing an API, the `api-and-interface-design` skill activates automatically. Building UI? `frontend-ui-engineering` triggers. The agent understands its task and loads the appropriate expertise.

This transforms AI coding from "write code that happens to work" to "follow proven engineering workflows that produce maintainable results."

## Pillar 4: Behavioral Guardrails — The Wisdom Layer

### [Karpathy-Inspired Skills](https://github.com/forrestchang/andrej-karpathy-skills)

如果底层行为存在问题，最好的工程框架也会失效。 Andrej Karpathy identified LLM编码失败中的一个规律:

> "The models make 代替你做出错误假设 and just run along with them without checking. They don't manage their confusion, don't seek clarifications, don't surface inconsistencies, don't present tradeoffs, don't push back when they should."

This project distills Karpathy's observations into four behavioral principles embedded in a `CLAUDE.md` file:

**1. Think Before Coding** — State assumptions explicitly. Present multiple interpretations. Push back when simpler approaches exist. Stop when confused. Ask before assuming.

**2. Simplicity First** — Minimum viable solution. No speculative features. No abstractions for single-use code. If 200 lines could be 50, rewrite it. The test: "Would a senior engineer say this is overcomplicated?"

**3. Surgical Changes** — Touch only what you must. Don't refactor things that aren't broken. Match existing style. Remove only the dead code YOUR changes created — never pre-existing orphan code unless asked.

**4. Goal-Driven Execution** — Define success criteria upfront. Transform "add validation" into "write tests for invalid inputs, then make them pass." Strong criteria enable independent looping; weak criteria require constant clarification.

These aren't technical solutions — they're 认知防护机制. They address the LLMs的根本弱点：过度自信伪装成能力强.

## How These Four Layers Work Together

The breakthrough moment comes when you connect all four pillars into a single workflow:

1. **Research** (Local Deep Research): An agent receives a complex query — "Build a trading dashboard for prediction markets." It conducts 深度研究 across financial APIs, market structures, and UI patterns, producing a verified report with citations.

2. **Platform** (InsForge): The agent provisions the entire backend — PostgreSQL for market data, edge functions for real-time updates, storage for historical charts, auth for user accounts, model gateway for analysis APIs. All via MCP tool calls.

3. **Engineering** (Agent Skills): The agent builds the frontend following the `/spec → /plan → /build → /test → /review → /ship` workflow. Context-aware skills activate as needed — `frontend-ui-engineering` for the dashboard, `data-visualization` for charting, `api-integration` for real-time websockets.

4. **Wisdom** (Karpathy Skills): Throughout this process, the behavioral guardrails prevent classic LLM mistakes — no overengineered abstractions, no touching unrelated code, explicit assumption-stating before every architectural decision, verifiable success criteria instead of vague "make it work" targets.

The result? An agent that doesn't just "write code" but operates with the judgment, discipline, and verification standards of a senior full-stack team.

## Why This Matters for Developers

Three years ago, the question was "Can AI write code?" Today, it's "Can AI build production systems end-to-end?"

The answer is becoming clear: **not yet fully autonomously, but dangerously close.**

Each pillar addresses a specific failure mode:
- Without 深度研究 → agents build on outdated or incorrect information
- Without proper infrastructure → agents generate code with no deployment path
- Without engineering discipline → agents produce unmaintainable spaghetti
- Without behavioral guardrails → agents overconfidently implement wrong solutions

Together, these four open-source projects form the first complete stack for genuine AI-assisted development.

## Getting Started

All four projects are open-source and free:

- **Local Deep Research**: `pip install local-deep-research` or Docker Compose
- **InsForge**: `npm install @insforge/sdk` (cloud) or self-hosted MCP server
- **Agent Skills**: Claude Code marketplace plugin or `.cursor/rules/`
- **Karpathy Skills**: Single `CLAUDE.md` file merge

你不需要同时采用所有四项。 从解决你最大短板的项目开始。 But once you experience the 协同效应 — 研究指导架构, 架构指导实施, 技能约束实施过程, 智慧贯穿始终 — it's 一旦体验过就再也回不去单打独斗了。

The future of software development isn't humans replacing AI or AI replacing humans. It's humans orchestrating AI systems that combine deep intelligence, robust infrastructure, engineering discipline, and practical wisdom. And those systems are already here.

---

## 推荐工具

跑或部署开源 AI 工具时，推荐：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心，AI 工作流 droplet 一键部署。

*推广链接 — 不增加你的成本，能支持 dibi8.com 持续运营。*

## 推荐工具

**需要稳定的 Claude / OpenAI API 访问？** 这个领域的项目最终都会撞 Anthropic / OpenAI 限流或价格墙。

- **{{< aff "shiyunapi" "llm-footer" "Shiyunapi" >}}** — Claude / OpenAI / DeepSeek API 中转。一个 key 同时访问多家顶级模型, 价格约官方 30%; 迭代 agent prompt 或国内/受限地区直连不通时尤其管用。

*推广链接 — 不增加你的成本, 帮助 dibi8.com 持续运营。*

