---
title: "Scaffold a new Mastra project with the interactive CLI"
description: "title: "Scaffold a new Mastra project with the interactive CLI""
date: 2026-09-20
slug: "mastra"
category: "ai-tools"
tags: ["ai", "tools"]
---
title: "Scaffold a new Mastra project with the interactive CLI"
description: "title: "Scaffold a new Mastra project with the interactive CLI""
date: 2026-05-19T00:00:00+08:00
lastmod: 2026-05-19T00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
last_maintained: "2026-05-19"
draft: false
categories: ["llm-frameworks"]
tags: ["mastra", "typescript", "ai-framework", "agents", "llm", "mastra-tutorial", "mastra-vs-langchain", "open-source"]
aliases:
  - /posts/mastra/-
---



Most AI frameworks are built for Python. If your stack runs on TypeScript and Node.js, you either bridge languages or accept a sub-par developer experience. That changed when the Gatsby team launched Mastra — a TypeScript-native framework for building AI agents that reached **24,050 GitHub stars** by May 2026 and is now used in production at Replit, PayPal, and Sanity. This article covers everything you need to install Mastra, build your first agent, and understand how its Observational Memory reduces token costs by 4-10x compared to traditional RAG approaches.

## What Is Mastra?

Mastra is an open-source TypeScript framework for building AI-powered applications and agents. It provides a unified toolkit that covers agents, workflows, RAG pipelines, memory systems, evaluation frameworks, and observability — all with first-class TypeScript types. Unlike Python-first frameworks ported to JavaScript, Mastra was built from the ground up for the TypeScript ecosystem. It sits on top of the Vercel AI SDK for low-level model interactions and adds the higher-level abstractions that production AI applications require.

![Mastra Logo](https://raw.githubusercontent.com/mastra-ai/mastra/main/docs/public/logo.png)

The core idea is simple: agents handle open-ended conversational tasks with tool access, workflows manage deterministic multi-step processes, RAG grounds responses in your data, memory persists context across conversations, and evals measure quality. All six primitives ship in ```@mastra/core```` and work together through consistent Zod-typed APIs.

![Mastra Studio — Local development UI for debugging agents, workflows, and memory](https://www.firecrawl.dev/images/blog/mastra-tutorial/workflow-graph.webp)

## How Mastra Works — Architecture and Core Concepts

Mastra's architecture revolves around six building blocks that mirror what production AI systems actually need: ### Agents
Agents are the primary actors. You give them instructions, a model, and access to tools. They decide what to call, when to stop, and how to respond. Agents expose ````.generate()```` for complete responses and ````.stream()```` for real-time token streaming — essential for chat UIs where users expect to see responses form progressively.

### Workflows
Workflows provide deterministic orchestration for multi-step operations where you need explicit control. Built on XState, they support branching, parallel execution, loops, and human-in-the-loop patterns where execution pauses for approval before resuming.

### RAG (Retrieval-Augmented Generation)
Mastra's RAG pipeline handles document chunking, embedding generation, vector storage, similarity search, and reranking. It works with Pinecone, Qdrant, ChromaDB, pgvector, and many other vector databases.

### Memory
The memory system includes conversation history (raw message storage), semantic recall (embedding-based similarity search), working memory (structured facts and preferences as a Markdown scratchpad), and the standout feature — Observational Memory — which compresses old conversations into dense observations, cutting token costs by 4-10x.

### Tools
Tools are typed functions defined with Zod schemas that agents can invoke. They provide structured interfaces to external APIs, databases, and services. Mastra also supports the Model Context Protocol (MCP) for connecting to external tool ecosystems with over 10,000 available MCP servers.

### Evals
Evaluation frameworks track agent quality through model-graded, rule-based, and statistical methods. You can assess relevance, faithfulness, toxicity, tone consistency, and define custom metrics.

`````typescript
// Core Mastra architecture — all six primitives in one setup
import { Mastra } from '@mastra/core';
import { openai } from '@ai-sdk/openai';

const mastra = new Mastra({
  agents: {
    supportAgent,
    researchAgent,
  },
  workflows: {
    ticketPipeline,
  },
  storage: new PgStorage({ connectionString: process.env.DATABASE_URL }),
  vectorStore: new PgVector(connectionString),
  telemetry: otel,
});
`````

## Installation and Setup — Under 5 Minutes

Mastra requires Node.js 22.13.0 or later. The recommended path is the CLI wizard, which scaffolds a complete project with the right package structure, configuration files, and example code.

### Step 1: Create a New Project

`````bash
# Scaffold a new Mastra project with the interactive CLI
npm create mastra@latest

# The wizard prompts for: # - Project name
# - Components (agents, workflows, RAG, memory)
# - LLM provider (OpenAI, Anthropic, Google, etc.)
# - Whether to include example code
`````

### Step 2: Manual Installation (Alternative)

If you prefer to add Mastra to an existing project: `````bash
# Install core package with Zod for schema validation
npm install @mastra/core@latest zod@^4

# Install your preferred LLM provider from the AI SDK
npm install @ai-sdk/openai

# Optional: vector store, memory, and deployer packages
npm install @mastra/pg @mastra/memory @mastra/deployer-vercel
`````

### Step 3: Environment Setup

`````bash
# .env — Mastra loads these automatically at runtime
OPENAI_API_KEY=sk-xxxx
DATABASE_URL=postgresql://user:pass@localhost:5432/mastra
`````

### Step 4: Project Structure

`````
my-mastra-project/
├── src/
│   └── mastra/
│       ├── agents/
│       │   └── support.ts
│       ├── tools/
│       │   └── search.ts
│       ├── workflows/
│       │   └── ticket.ts
│       └── index.ts
├── .env
├── package.json
└── tsconfig.json
`````

### Step 5: Launch Mastra Studio

`````bash
# Start the local development UI at localhost:4111
npx mastra dev

# Studio lets you chat with agents, inspect tool calls,
# view memory state, visualize workflows, and iterate on prompts
`````

![Mastra Changelog Digest Workflow — showing the INPUT → SCRAPE → EXTRACT → OUTPUT pipeline](https://www.firecrawl.dev/images/blog/mastra-tutorial/changelog-pipeline.webp)

## Building Your First Agent — Real Code Examples

### Basic Agent with Tools

`````typescript
// src/mastra/agents/support.ts
import { Agent } from '@mastra/core';
import { openai } from '@ai-sdk/openai';
import { createTool } from '@mastra/core';
import { z } from zod;

const searchTool = createTool({
  id: 'search-docs',
  description: "title: "Scaffold a new Mastra project with the interactive CLI""
  inputSchema: z.object({
    query: z.string().describe('The search..."
    environment: - OPENAI_API_KEY=${OPENAI_API_KEY}
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/mastra
    depends_on: - db

  db: image: pgvector/pgvector:pg17
    environment: POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: mastra
    volumes: - pgdata:/var/lib/postgresql/data

volumes: pgdata: `````

## Comparison with Alternatives

| Feature | Mastra | LangChain | CrewAI | Vercel AI SDK |
|
* * *
|
* * *
|
* * *
|
* * *
|
* * *
|
| **Primary Language** | TypeScript (99.2%) | Python (also JS) | Python | TypeScript |
| **GitHub Stars** | 24,050 | 117,000 | 39,200 | N/A (part of Vercel) |
| **Setup Time** | < 5 min | 15-30 min | 10-15 min | < 5 min (manual wiring) |
| **Agent Abstractions** | Native Agent class | Chain/Agent classes | Role-based crew | Manual composition |
| **Workflow Engine** | XState-based, durable | LangGraph (graph) | Sequential/hierarchical | None |
| **Memory System** | Observational Memory (4-10x cost reduction) | ConversationBufferMemory | Short-term only | Manual |
| **Type Safety** | Zod throughout, full TS | Partial in JS version | Python type hints | Zod supported |
| **Observability** | Built-in + OTEL | LangSmith (SaaS) | Built-in basic | Vercel platform |
| **MCP Support** | Native | Via adapter | Limited | Via integration |
| **Multi-Agent** | Supervisor pattern | LangGraph multi-agent | Core feature | Manual |
| **Best For** | TS teams, Next.js, Node.js | Python teams, complex graphs | Python multi-agent prototyping | React/Next.js UI-heavy apps |
| **LLM Providers** | 40+ | 100+ | 20+ | 10+ |
| **Production Users** | Replit, PayPal, Sanity | Uber, LinkedIn | Startups, agencies | Vercel-hosted apps |
| **Deployment** | Any Node.js server, Vercel, CF Workers | LangSmith Cloud, self-hosted | Self-hosted, CrewAI Cloud | Vercel (optimal) |

## Limitations — Honest Assessment

Mastra is not the right tool for every situation. Here is what the framework is NOT good at: **Python Ecosystem Lock-In:** If your entire data science stack is Python — pandas, NumPy, PyTorch, Jupyter — Mastra forces you to bridge two languages. The framework is TypeScript-only. For teams deeply invested in Python, LangChain or CrewAI remain more natural choices.

**Smaller Integration Ecosystem:** LangChain has 100+ LLM integrations and 50+ vector stores. Mastra supports 40+ providers and covers the major vector databases, but if you need an obscure model or a niche vector store, you may need to write custom integration code.

**Younger Project, Higher Churn:** Mastra hit v1.0 in January 2026. The API has stabilized but breaking changes still occur more frequently than in LangChain's mature ecosystem. Budget time for version upgrades.

**No Native Visual Workflow Builder:** Unlike n8n or Langflow, Mastra has no drag-and-drop workflow designer. Everything is code. For non-technical team members who need to modify workflows, this is a barrier.

**Community Size:** At 24K stars, Mastra's community is active but significantly smaller than LangChain's. You will find fewer Stack Overflow answers, fewer third-party tutorials, and a narrower selection of blog posts covering edge cases.

**Limited UI Components:** While Mastra Studio provides a development playground, it does not ship production UI components like chat widgets. You still need to build the frontend yourself or pair Mastra with the Vercel AI SDK's UI libraries.

## Frequently Asked Questions

**Q: Does Mastra require TypeScript knowledge?**
Yes, Mastra is TypeScript-native. Basic familiarity with TypeScript, async/await, and Zod schemas is expected. If your team only knows Python, the learning curve for TypeScript plus Mastra will be steeper than using LangChain directly.

**Q: How does Mastra's Observational Memory compare to LangChain's memory classes?**
LangChain provides ConversationBufferMemory, ConversationSummaryMemory, and vector-based retrieval. These work but either consume full context window or rely on vector search that invalidates prompt caches. Mastra's Observational Memory compresses context into cacheable observations, achieving 4-10x cost reduction while scoring higher on LongMemEval benchmarks (84.23% vs 80.05% for RAG).

**Q: Can I deploy Mastra on DigitalOcean or AWS instead of Vercel?**
Yes. Mastra is fully open-source and deploys to any Node.js runtime. Build with ````mastra build````, then run the output on DigitalOcean App Platform, AWS ECS, Google Cloud Run, or any Docker host. Deployers exist for Vercel and Cloudflare Workers, but they are optional.

**Q: What LLM providers does Mastra support?**
Mastra supports 40+ providers through the Vercel AI SDK: OpenAI, Anthropic, Google, Mistral, Cohere, xAI, DeepSeek, Fireworks, Together, and many more. Switching providers is a one-line code change.

**Q: How does Mastra handle errors and retries in production?**
Mastra workflows include configurable retry policies with exponential backoff at the step level. Agents have built-in timeout handling. The observability integration (OpenTelemetry) traces every call, making it straightforward to identify and debug failures in production.

**Q: Is Mastra free for commercial use?**
Yes. Mastra is licensed under Apache 2.0 and free for commercial use. Mastra Cloud (managed hosting) offers paid tiers, but the core framework is fully open-source and self-hostable at no cost.

**Q: How do I add memory to an existing Mastra agent?**
Pass a memory instance when creating the Mastra instance. The agent automatically tracks conversation threads per user. For multi-turn conversations, initialize memory with a storage backend (PostgreSQL, libSQL, or MongoDB) and the agent handles the rest.

## Conclusion

Mastra fills a clear gap in the AI framework landscape — a production-grade, TypeScript-native toolkit that lets JavaScript developers build agents without leaving their ecosystem. The 4-10x token cost reduction from Observational Memory is not marketing hype; it is a measurable production advantage backed by LongMemEval benchmarks. The framework's DX score of 9/10 and sub-5-minute setup time make it the fastest path from idea to deployed agent for TypeScript teams.

If you are building AI features into a Next.js application, Node.js service, or any TypeScript project, Mastra deserves a serious evaluation. Start with ````npm create mastra@latest````, build a workflow, and measure the token cost difference for yourself.

**Action items:**
1. Clone the Mastra repo and run the quickstart: ````npm create mastra@latest```
2. Join the [Mastra Discord community](https://discord.gg/mastra) (5,500+ members)
3. Explore the [official documentation](https://mastra.ai/docs)
4. Follow the [Mastra GitHub repository](https://github.com/mastra-ai/mastra) for updates

*Some links in this article are affiliate links. If you sign up for DigitalOcean through our referral link, we may earn a commission at no extra cost to you. This helps fund independent technical research.*



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends: - **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don"t cost you extra and they help keep dibi8.com running.*

## Sources and Further Reading

- [Mastra Official Website](https://mastra.ai)
- [Mastra GitHub Repository](https://github.com/mastra-ai/mastra)
- [Mastra Documentation](https://mastra.ai/docs)
- [Mastra Course - Learn to Build AI Agents](https://mastra.ai/course)
- [Mastra Tutorial: Changelog Tracker with Firecrawl](https://www.firecrawl.dev/blog/mastra-tutorial)
- [Mastra Observational Memory Deep Dive](https://agentmarketcap.ai/blog/2026/04/13/mastra-observational-memory-observer-reflector-pattern-agent-costs-longmemeval-2026)
- [ByteIota: Mastra TypeScript AI Framework Analysis](https://byteiota.com/mastra-typescript-ai-framework-cuts-token-costs-4-10x/)
- [Mastra vs LangChain Comparison on xpay](https://www.xpay.sh/resources/agentic-frameworks/compare/langchain-vs-mastra/)
- [CrewAI vs Mastra Comparison on respan.ai](https://respan.ai/market-map/compare/crewai-vs-mastra)
- [Top JavaScript/TypeScript Gen AI Frameworks for 2026](https://xavidop.me/genkit/2026-04-16-top-jsts-genai-frameworks-2026/)
- [Mastra Workshop: Build Your Own Coding Agent](https://github.com/mastra-ai/workshop-mastracode)
- [Mastra Observational Memory Workshop](https://github.com/mastra-ai/mastra-observational-memory-workshop)
- [LangChain GitHub Repository](https://github.com/langchain-ai/langchain)
- [CrewAI GitHub Repository](https://github.com/crewAIInc/crewAI)
- [Vercel AI SDK Documentation](https://sdk.vercel.ai/docs)


{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Mastra: 24K+ Stars — TypeScript AI Framework That Cuts Token Costs 4-10x in 2026",
  "datePublished": "2026-05-19",
  "dateModified": "2026-05-19",
  "author": {
    "@type": "Organization",
    "name": "Dibi8"
  },
  "publisher": {
    "@type": "Organization",
    "name": "Dibi8",
    "logo": {
      "@type": "ImageObject",
      "url": "https://dibi8.com/logo.png"
    }
  },
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": "https://dibi8.com/resources/mastra"
  }
}
</script>


* * *
## Related Articles

- [12-factor-agents-production-llm-software-2026](mastra)
- [12-factor-agents](mastra)
- [1m-context-window-llm-2026-real-test](mastra)
- [9router-smart-llm-proxy-token-saver-free-coding](mastra)
- [ai-engineering-from-scratch](mastra)


* * *
*Found this helpful? [Join our Telegram community](https://t.me/DIBI8_Group) for daily AI tool updates!*

## Frequently Asked Questions (FAQ)

**问：AI Agent和传统自动化有什么区别？**

AI Agent具有自主决策能力，能够根据环境变化调整策略，而传统自动化只能执行预设规则。

**问：如何选择合适的AI Agent框架？**

考虑因素包括：部署难度、社区活跃度、扩展性、成本。Claude Code适合开发者，AutoGen适合复杂多智能体场景。

**问：AI Agent的安全性如何保证？**

实施权限最小化、输入验证、审计日志、以及定期安全评估。

**问：AI Agent的学习成本有多高？**

入门级使用3-5天，高级配置需要2-4周，取决于团队技术基础。

**问：能否自定义AI Agent的行为？**

是的，通过提示工程、工具定义、记忆系统、以及行为约束来定制。

