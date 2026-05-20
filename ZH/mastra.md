---
title: 'Mastra: 24K+ Stars — 节省 Token 成本 4-10 倍的 TypeScript AI 框架 2026'
description: 'Mastra 是 Gatsby 团队打造的 TypeScript 原生 AI 框架，用于构建 AI 驱动的应用和智能体。涵盖 Mastra vs LangChain、安装教程、工作流、RAG、记忆系统、可观测性、基准测试和生产加固。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/mastra-ai/mastra'
stars: 24050
maintainer: 'mastra-ai'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['mastra', 'typescript', 'ai框架', '智能体', 'llm', 'mastra教程', 'mastra-vs-langchain', '开源']
aliases:
- /zh/posts/mastra/
---

{{</* resource-info */>}}

绝大多数 AI 框架都是为 Python 构建的。如果你的技术栈运行在 TypeScript 和 Node.js 上，你只能在跨语言桥接和次优开发体验之间做出选择。这种情况在 Gatsby 团队推出 Mastra 后发生了改变 —— 一个用于构建 AI 智能体的 TypeScript 原生框架，截至 2026 年 5 月已获得 **24,050 个 GitHub Star**，目前被 Replit、PayPal 和 Sanity 等公司用于生产环境。本文涵盖安装 Mastra、构建第一个智能体所需的一切，以及其 Observational Memory 如何比传统 RAG 方法减少 4-10 倍 Token 成本。

## 什么是 Mastra？

Mastra 是一个用于构建 AI 驱动应用和智能体的开源 TypeScript 框架。它提供了一个统一的工具包，涵盖智能体、工作流、RAG 管道、记忆系统、评估框架和可观测性 —— 全部具备一流的 TypeScript 类型支持。与从 Python 移植到 JavaScript 的框架不同，Mastra 从底层开始就是为 TypeScript 生态系统打造的。它基于 Vercel AI SDK 构建，处理底层模型交互，并添加了生产级 AI 应用所需的更高层抽象。

![Mastra Logo](https://raw.githubusercontent.com/mastra-ai/mastra/main/docs/public/logo.png)

核心概念很简单：智能体处理开放式对话任务并可访问工具，工作流管理确定性的多步骤流程，RAG 将回答基于你的数据，记忆在对话间保持上下文，评估则衡量质量。所有六个原语都包含在 `@mastra/core` 中，通过一致的 Zod 类型 API 协同工作。

![Mastra Studio — 用于调试智能体、工作流和记忆的本地开发 UI](https://www.firecrawl.dev/images/blog/mastra-tutorial/workflow-graph.webp)

## Mastra 的工作原理 —— 架构与核心概念

Mastra 的架构围绕六个构建块展开，对应生产级 AI 系统真正需要的组件：

### 智能体 (Agents)
智能体是主要参与者。你给它们指令、模型和工具访问权限。它们自主决定调用什么工具、何时停止以及如何响应。智能体提供 `.generate()` 获取完整响应，`.stream()` 获取实时 Token 流 —— 这对聊天界面至关重要。

### 工作流 (Workflows)
工作流基于 XState 提供确定性编排，支持需要显式控制的多步骤操作。支持分支、并行执行、循环和人机协同模式（暂停执行等待人工审批后恢复）。

### RAG (检索增强生成)
Mastra 的 RAG 管道处理文档分块、嵌入生成、向量存储、相似性搜索和重排序。兼容 Pinecone、Qdrant、ChromaDB、pgvector 等主流向量数据库。

### 记忆 (Memory)
记忆系统包括对话历史（原始消息存储）、语义回忆（基于嵌入的相似性搜索）、工作记忆（结构化事实和偏好作为 Markdown 草稿板），以及其标志性功能 —— **Observational Memory** —— 将旧对话压缩为密集观察，减少 Token 成本 4-10 倍。

### 工具 (Tools)
工具是使用 Zod 模式定义的类型的函数，智能体可以调用。它们为外部 API、数据库和服务提供结构化接口。Mastra 还支持模型上下文协议 (MCP)，用于连接超过 10,000 个可用的 MCP 服务器的外部工具生态。

### 评估 (Evals)
评估框架通过模型评分、基于规则和统计的方法跟踪智能体质量。可评估相关性、忠实度、毒性、语气一致性和自定义指标。

```typescript
// Mastra 核心架构 —— 六个原语一站式配置
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
```

## 安装与设置 —— 5 分钟以内

Mastra 需要 Node.js 22.13.0 或更高版本。推荐路径是使用 CLI 向导，它可以脚手架完整的项目结构、配置文件和示例代码。

### 步骤 1：创建新项目

```bash
# 使用交互式 CLI 脚手架创建新的 Mastra 项目
npm create mastra@latest

# 向导会提示：
# - 项目名称
# - 组件（智能体、工作流、RAG、记忆）
# - LLM 提供商（OpenAI、Anthropic、Google 等）
# - 是否包含示例代码
```

### 步骤 2：手动安装（替代方案）

如果你希望将 Mastra 添加到现有项目中：

```bash
# 安装核心包和用于模式验证的 Zod
npm install @mastra/core@latest zod@^4

# 从 AI SDK 安装你偏好的 LLM 提供商
npm install @ai-sdk/openai

# 可选：向量存储、记忆和部署器包
npm install @mastra/pg @mastra/memory @mastra/deployer-vercel
```

### 步骤 3：环境配置

```bash
# .env —— Mastra 在运行时自动加载这些变量
OPENAI_API_KEY=sk-xxxx
DATABASE_URL=postgresql://user:pass@localhost:5432/mastra
```

### 步骤 4：项目结构

```
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
```

### 步骤 5：启动 Mastra Studio

```bash
# 在 localhost:4111 启动本地开发 UI
npx mastra dev

# Studio 允许你与智能体对话、检查工具调用、
# 查看记忆状态、可视化工作流并迭代提示词
```

![Mastra Changelog Digest 工作流 — 展示 INPUT → SCRAPE → EXTRACT → OUTPUT 管道](https://www.firecrawl.dev/images/blog/mastra-tutorial/changelog-pipeline.webp)

## 构建你的第一个智能体 —— 真实代码示例

### 带工具的基础智能体

```typescript
// src/mastra/agents/support.ts
import { Agent } from '@mastra/core';
import { openai } from '@ai-sdk/openai';
import { createTool } from '@mastra/core';
import { z } from 'zod';

const searchTool = createTool({
  id: 'search-docs',
  description: '搜索内部文档',
  inputSchema: z.object({
    query: z.string().describe('搜索查询'),
  }),
  execute: async ({ context }) => {
    const results = await searchInternalDocs(context.query);
    return { results };
  },
});

export const supportAgent = new Agent({
  name: 'SupportAgent',
  instructions: `你是一个技术支持智能体。使用搜索工具回答问题。
    保持简洁并引用来源。`,
  model: openai('gpt-4o'),
  tools: { searchTool },
});
```

### 结构化输出的智能体

```typescript
// 获取类型对象而非纯文本
const result = await supportAgent.generate(
  '分类这张工单："无法部署到 Vercel"',
  {
    output: z.object({
      category: z.enum(['deployment', 'billing', 'bug', 'feature']),
      priority: z.enum(['low', 'medium', 'high', 'critical']),
      summary: z.string(),
      actionItems: z.array(z.string()),
    }),
  }
);

// result.object 是完全类型化的 —— TypeScript 知道其结构
console.log(result.object.priority); // 'high' | 'low' | 'medium' | 'critical'
```

### 流式响应

```typescript
// 为聊天界面实时流式传输 Token
const stream = await supportAgent.stream(
  '如何配置环境变量？'
);

for await (const chunk of stream.textStream) {
  process.stdout.write(chunk); // Token 到达时立即写入
}
```

### 带分支的多步骤工作流

```typescript
// src/mastra/workflows/ticket.ts
import { Workflow, Step } from '@mastra/core';
import { z } from 'zod';

const classifyStep = new Step({
  id: 'classify',
  inputSchema: z.object({ ticketText: z.string() }),
  outputSchema: z.object({ category: z.string(), priority: z.string() }),
  execute: async ({ input, mastra }) => {
    const agent = mastra.getAgent('supportAgent');
    const result = await agent.generate(
      `分类：${input.ticketText}`,
      { output: z.object({ category: z.string(), priority: z.string() }) }
    );
    return result.object;
  },
});

const escalateStep = new Step({
  id: 'escalate',
  outputSchema: z.object({ escalated: z.boolean() }),
  execute: async ({ input }) => {
    await sendSlackAlert(`高优先级：${input.ticketText}`);
    return { escalated: true };
  },
});

const autoRespondStep = new Step({
  id: 'auto-respond',
  outputSchema: z.object({ sent: z.boolean() }),
  execute: async ({ input }) => {
    await sendAutoReply(input.ticketText);
    return { sent: true };
  },
});

export const ticketPipeline = new Workflow({
  name: 'ticket-pipeline',
  triggerSchema: z.object({ ticketText: z.string() }),
})
  .step(classifyStep)
  .then(escalateStep, {
    when: { 'classify.priority': 'high' },
  })
  .then(autoRespondStep, {
    when: { 'classify.priority': ['low', 'medium'] },
  });
```

### 并行工作流执行

```typescript
// 使用 .after() 并行运行步骤
import { Workflow, Step } from '@mastra/core';

const stepA = new Step({ id: 'fetch-user', /* ... */ });
const stepB = new Step({ id: 'fetch-orders', /* ... */ });
const stepC = new Step({ id: 'fetch-preferences', /* ... */ });
const stepD = new Step({ id: 'combine', /* ... */ });

const parallelWorkflow = new Workflow({
  name: 'parallel-fetch',
  triggerSchema: z.object({ userId: z.string() }),
})
  .step(stepA)
  .step(stepB)
  .step(stepC)
  .after(stepA, stepB, stepC)
  .step(stepD); // stepD 仅在 A、B、C 全部完成后运行
```

## 与 Next.js、Node.js 和 Vercel AI SDK 集成

### Next.js 集成

```typescript
// app/api/agent/route.ts —— 在 Next.js 中将智能体暴露为 API 路由
import { mastra } from '@/mastra';
import { NextResponse } from 'next/server';

export async function POST(req: Request) {
  const { message } = await req.json();
  const agent = mastra.getAgent('supportAgent');

  const stream = await agent.stream(message);

  return new Response(stream.textStream, {
    headers: { 'Content-Type': 'text/event-stream' },
  });
}
```

### 使用 Hono 的 Node.js 服务器

```bash
# Mastra 构建时会打包 Hono HTTP 服务器
npx mastra build

# 输出到 .mastra/output/
# Hono 服务器将智能体、工作流和记忆暴露为 REST 端点

npx mastra start
# 服务器运行在 http://localhost:4111
```

### Vercel AI SDK 集成

Mastra 基于 Vercel AI SDK 构建。你可以直接使用 SDK 进行底层控制：

```typescript
// Mastra 底层使用 AI SDK 提供商
import { openai } from '@ai-sdk/openai';
import { anthropic } from '@ai-sdk/anthropic';
import { google } from '@ai-sdk/google';

// 一行代码切换提供商
const agent = new Agent({
  name: 'MultiProviderAgent',
  instructions: '你是一个有用的助手。',
  model: openai('gpt-4o'), // 或 anthropic('claude-sonnet-4') 或 google('gemini-2.0-pro')
  tools: { searchTool, calcTool },
});
```

### MCP（模型上下文协议）集成

```typescript
// 连接任何 MCP 服务器 —— 超过 10,000 个可用
import { MCPClient } from '@mastra/core';

const mcpClient = new MCPClient({
  servers: {
    slack: {
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-slack'],
      env: { SLACK_BOT_TOKEN: process.env.SLACK_TOKEN },
    },
    github: {
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-github'],
      env: { GITHUB_PERSONAL_ACCESS_TOKEN: process.env.GITHUB_TOKEN },
    },
  },
});

// MCP 工具自动对你的智能体可用
const tools = await mcpClient.tools();
const agent = new Agent({
  name: 'MCPAgent',
  model: openai('gpt-4o'),
  tools, // 所有 MCP 工具现在可用
});
```

## 基准测试与实际用例

### Token 成本削减 —— 4-10 倍之说

Mastra 的 Observational Memory 是生产经济学的标志性功能。数据如下：

**问题所在：** 传统基于 RAG 的记忆系统每轮动态检索不同的上下文。每次检索都会改变提示前缀，使提示缓存失效。Anthropic 和 OpenAI 都对缓存的提示 Token 提供 90% 的折扣，每次缓存未命中都会在缓存部分产生 10 倍的成本惩罚。

**解决方案：** Observational Memory 将上下文分为两个块 —— 压缩观察（附加只读直到反射运行）和原始近期消息。观察块在轮次间保持一致，使其完全可缓存。

### 按工作负载的压缩比率

| 工作负载类型 | 压缩比率 | 示例场景 |
|---|---|---|
| 纯文本对话 | 3-6x | 客户支持聊天 |
| 工具调用密集型智能体 | 5-40x | 浏览器自动化、编码智能体 |
| 带大截图/文件的智能体 | 10-40x | Playwright DOM 快照 |

### LongMemEval 基准测试结果

| 记忆系统 | GPT-4o 分数 | GPT-5-mini 分数 |
|---|---|---|
| Mastra Observational Memory | 84.23% | 94.87% |
| Mastra RAG（基线） | 80.05% | — |
| 传统对话历史 | ~72% | — |

浏览器自动化智能体捕获 Playwright 截图时，可将 200,000 Token 的会话历史压缩到 5,000-15,000 Token 的观察 —— 减少 15-30 倍。

### 开发者体验基准

| 框架 | DX 分数 (1-10) | 设置时间 | 首个智能体时间 |
|---|---|---|---|
| Mastra | 9/10 | < 5 分钟 | 数分钟 |
| LangChain (Python) | 5/10 | 15-30 分钟 | 数小时 |
| CrewAI | 6/10 | 10-15 分钟 | 30 分钟 |
| Vercel AI SDK | 7/10 | < 5 分钟 | 数小时（手动配置） |

*来源：NextBuild 生产基准测试，2025 年 12 月*

### 生产部署案例

- **Replit**：用于 AI 驱动的代码生成和编辑功能
- **PayPal**：面向客户的支付支持 AI 智能体
- **Sanity**：内容工作流和 AI 辅助编辑
- **WorkOS**：企业身份和访问自动化
- **Elastic**：搜索和可观测性 AI 功能

## 高级用法 —— 生产加固

### Observational Memory 配置

```typescript
import { Mastra } from '@mastra/core';
import { ObservationalMemory } from '@mastra/memory';
import { PgStorage } from '@mastra/pg';

const mastra = new Mastra({
  agents: { supportAgent },
  memory: new ObservationalMemory({
    storage: new PgStorage({ connectionString: process.env.DATABASE_URL }),
    observerModel: openai('gpt-4o-mini'), // 运行 Observer 智能体
    reflectorModel: openai('gpt-4o-mini'), // 运行 Reflector 智能体
    compressionInterval: 5, // 每 5 条消息压缩一次
  }),
});
```

### RAG 管道设置

```typescript
import { MastraRAG } from '@mastra/rag';
import { openai } from '@ai-sdk/openai';
import { PgVector } from '@mastra/pg';

const rag = new MastraRAG({
  embedder: openai.embedding('text-embedding-3-small'),
  vectorStore: new PgVector({
    connectionString: process.env.DATABASE_URL,
    dimension: 1536,
  }),
  chunkSize: 512,
  chunkOverlap: 50,
});

// 索引文档
await rag.index(documentBatch);

// 带相似性搜索的查询
const results = await rag.query('如何配置 SSO？', { topK: 5 });
```

### 使用 OpenTelemetry 实现可观测性

```typescript
import { Mastra } from '@mastra/core';
import { NodeSDK } from '@opentelemetry/sdk-node';

const otel = new NodeSDK({
  traceExporter: new OTLPTraceExporter({
    url: 'https://api.honeycomb.io/v1/traces',
  }),
});

const mastra = new Mastra({
  agents: { supportAgent },
  workflows: { ticketPipeline },
  telemetry: otel,
});

// 追踪自动出现在你的可观测平台中
// 每个智能体调用、工具执行和工作流步骤都被自动插桩
```

### 护栏与安全

```typescript
import { Agent } from '@mastra/core';
import { createGuardrail } from '@mastra/core';

const promptInjectionGuard = createGuardrail({
  id: 'no-prompt-injection',
  check: async ({ input }) => {
    const suspicious = /ignore previous|disregard instructions/i.test(input);
    return { passed: !suspicious, message: suspicious ? '检测到注入' : undefined };
  },
});

const piiGuard = createGuardrail({
  id: 'no-pii',
  check: async ({ output }) => {
    const hasPii = /\b\d{3}-\d{2}-\d{4}\b/.test(output); // 社保号模式
    return { passed: !hasPii, message: hasPii ? '检测到 PII 泄露' : undefined };
  },
});

const agent = new Agent({
  name: 'SafeAgent',
  model: openai('gpt-4o'),
  tools: { searchTool },
  guardrails: [promptInjectionGuard, piiGuard],
});
```

### 人机协同

```typescript
import { Workflow, Step } from '@mastra/core';

const humanApprovalStep = new Step({
  id: 'await-approval',
  outputSchema: z.object({ approved: z.boolean() }),
  execute: async ({ suspend }) => {
    // 暂停工作流等待人工输入
    const { approved } = await suspend({ reason: '退款金额超过 $500' });
    return { approved };
  },
});

// 人工通过 Studio 或 API 调用批准后工作流继续
const refundWorkflow = new Workflow({
  name: 'refund-pipeline',
  triggerSchema: z.object({ amount: z.number(), orderId: z.string() }),
})
  .step(validateStep)
  .then(humanApprovalStep)
  .then(processRefundStep, { when: { 'await-approval.approved': true } });
```

### Docker 部署

```dockerfile
# Dockerfile 用于生产部署
FROM node:22-slim

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npx mastra build

EXPOSE 4111
CMD ["node", ".mastra/output/index.mjs"]
```

```yaml
# docker-compose.yml
version: '3.8'
services:
  mastra:
    build: .
    ports:
      - "4111:4111"
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/mastra
    depends_on:
      - db

  db:
    image: pgvector/pgvector:pg17
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: mastra
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

## 与替代方案对比

| 特性 | Mastra | LangChain | CrewAI | Vercel AI SDK |
|---|---|---|---|---|
| **主要语言** | TypeScript (99.2%) | Python (也支持 JS) | Python | TypeScript |
| **GitHub Stars** | 24,050 | 117,000 | 39,200 | N/A (Vercel 的一部分) |
| **设置时间** | < 5 分钟 | 15-30 分钟 | 10-15 分钟 | < 5 分钟（手动配置） |
| **智能体抽象** | 原生 Agent 类 | Chain/Agent 类 | 基于角色的 crew | 手动组合 |
| **工作流引擎** | 基于 XState，持久化 | LangGraph（图） | 顺序/分层 | 无 |
| **记忆系统** | Observational Memory（成本降低 4-10x） | ConversationBufferMemory | 仅短期 | 手动 |
| **类型安全** | 全链路 Zod，完整 TS | JS 版本部分支持 | Python 类型提示 | 支持 Zod |
| **可观测性** | 内置 + OTEL | LangSmith（SaaS） | 基础内置 | Vercel 平台 |
| **MCP 支持** | 原生 | 通过适配器 | 有限 | 通过集成 |
| **多智能体** | Supervisor 模式 | LangGraph 多智能体 | 核心特性 | 手动 |
| **最适合** | TS 团队、Next.js、Node.js | Python 团队、复杂图 | Python 多智能体原型 | React/Next.js 重度 UI 应用 |
| **LLM 提供商** | 40+ | 100+ | 20+ | 10+ |
| **生产用户** | Replit、PayPal、Sanity | Uber、LinkedIn | 初创公司、代理商 | Vercel 托管应用 |
| **部署方式** | 任意 Node.js 服务器、Vercel、CF Workers | LangSmith Cloud、自托管 | 自托管、CrewAI Cloud | Vercel（最优） |

## 局限性 —— 客观评估

Mastra 并非适用于所有情况。以下是其不足之处：

**Python 生态锁定：** 如果你的数据科学栈完全是 Python —— pandas、NumPy、PyTorch、Jupyter —— Mastra 会迫使你桥接两种语言。该框架是纯 TypeScript 的。对于深度投入 Python 的团队，LangChain 或 CrewAI 仍然是更自然的选择。

**集成生态较小：** LangChain 有 100+ LLM 集成和 50+ 向量存储。Mastra 支持 40+ 提供商并覆盖主流向量数据库，但如果你需要冷门模型或小众向量存储，可能需要编写自定义集成代码。

**项目较新，变更更频繁：** Mastra 在 2026 年 1 月达到 v1.0。API 已稳定但 breaking changes 仍比 LangChain 成熟生态更频繁。请为版本升级预留时间。

**无原生可视化工作流构建器：** 与 n8n 或 Langflow 不同，Mastra 没有拖拽式工作流设计器。一切皆为代码。对于需要修改工作流的非技术团队成员，这是一个门槛。

**社区规模：** 24K stars 下 Mastra 的社区很活跃但远小于 LangChain。你会发现 Stack Overflow 答案更少、第三方教程更少、覆盖边缘案例的博客文章也更有限。

**UI 组件有限：** 虽然 Mastra Studio 提供开发游乐场，但它不附带生产级 UI 组件如聊天小部件。你仍需自己构建前端，或将 Mastra 与 Vercel AI SDK 的 UI 库配对使用。

## 常见问题

**Q: Mastra 是否需要 TypeScript 知识？**
是的，Mastra 是 TypeScript 原生的。预期需要熟悉 TypeScript、async/await 和 Zod 模式。如果你的团队只懂 Python，学习 TypeScript 加 Mastra 的曲线会比直接使用 LangChain 更陡峭。

**Q: Mastra 的 Observational Memory 与 LangChain 的记忆类相比如何？**
LangChain 提供 ConversationBufferMemory、ConversationSummaryMemory 和基于向量的检索。这些方法要么消耗完整上下文窗口，要么依赖使提示缓存失效的向量搜索。Mastra 的 Observational Memory 将上下文压缩为可缓存的观察，实现 4-10 倍成本降低，同时在 LongMemEval 基准上得分更高（84.23% vs RAG 的 80.05%）。

**Q: 我可以在 DigitalOcean 或 AWS 上部署 Mastra 而不是 Vercel 吗？**
可以。Mastra 是完全开源的，可部署到任何 Node.js 运行时。使用 `mastra build` 构建，然后在 DigitalOcean App Platform、AWS ECS、Google Cloud Run 或任何 Docker 主机上运行输出。Vercel 和 Cloudflare Workers 的部署器是可选的。

**Q: Mastra 支持哪些 LLM 提供商？**
Mastra 通过 Vercel AI SDK 支持 40+ 提供商：OpenAI、Anthropic、Google、Mistral、Cohere、xAI、DeepSeek、Fireworks、Together 等。切换提供商只需修改一行代码。

**Q: Mastra 如何在生产环境中处理错误和重试？**
Mastra 工作流包含可配置的重试策略，步骤级别支持指数退避。智能体有内置超时处理。可观测性集成（OpenTelemetry）追踪每次调用，使生产环境中识别和调试故障变得简单。

**Q: Mastra 商业使用是否免费？**
是的。Mastra 采用 Apache 2.0 许可证，商业使用免费。Mastra Cloud（托管服务）提供付费层级，但核心框架完全开源且可免费自托管。

**Q: 如何为现有 Mastra 智能体添加记忆？**
在创建 Mastra 实例时传递记忆实例。智能体会自动按用户追踪对话线程。对于多轮对话，使用存储后端（PostgreSQL、libSQL 或 MongoDB）初始化记忆，智能体会处理其余部分。

## 结论

Mastra 填补了 AI 框架领域的明显空白 —— 一个生产级的 TypeScript 原生工具包，让 JavaScript 开发者无需离开其生态即可构建智能体。Observational Memory 带来的 4-10 倍 Token 成本降低并非营销噱头，而是由 LongMemEval 基准验证的、可量化的生产优势。框架的 DX 评分 9/10 和不足 5 分钟的设置时间，使其成为 TypeScript 团队从构想到部署智能体的最快路径。

如果你正在为 Next.js 应用、Node.js 服务或任何 TypeScript 项目构建 AI 功能，Mastra 值得认真评估。从 `npm create mastra@latest` 开始，构建一个工作流，并自己测量 Token 成本的差异。

**行动项：**
1. 克隆 Mastra 仓库并运行快速入门：`npm create mastra@latest`
2. 加入 [Mastra Discord 社区](https://discord.gg/mastra)（5,500+ 成员）
3. 探索 [官方文档](https://mastra.ai/docs)
4. 关注 [Mastra GitHub 仓库](https://github.com/mastra-ai/mastra) 获取更新

*本文中的部分链接是联盟链接。如果你通过我们的推荐链接注册 DigitalOcean，我们可能会获得佣金，而你无需支付额外费用。这有助于资助独立技术研究。*



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与扩展阅读

- [Mastra 官方网站](https://mastra.ai)
- [Mastra GitHub 仓库](https://github.com/mastra-ai/mastra)
- [Mastra 官方文档](https://mastra.ai/docs)
- [Mastra 课程 - 学习构建 AI 智能体](https://mastra.ai/course)
- [Mastra 教程：使用 Firecrawl 的变更日志追踪器](https://www.firecrawl.dev/blog/mastra-tutorial)
- [Mastra Observational Memory 深度解析](https://agentmarketcap.ai/blog/2026/04/13/mastra-observational-memory-observer-reflector-pattern-agent-costs-longmemeval-2026)
- [ByteIota：Mastra TypeScript AI 框架分析](https://byteiota.com/mastra-typescript-ai-framework-cuts-token-costs-4-10x/)
- [Mastra vs LangChain 对比 - xpay](https://www.xpay.sh/resources/agentic-frameworks/compare/langchain-vs-mastra/)
- [CrewAI vs Mastra 对比 - respan.ai](https://respan.ai/market-map/compare/crewai-vs-mastra)
- [2026 年顶级 JavaScript/TypeScript Gen AI 框架](https://xavidop.me/genkit/2026-04-16-top-jsts-genai-frameworks-2026/)
- [Mastra 研讨会：构建你自己的编码智能体](https://github.com/mastra-ai/workshop-mastracode)
- [Mastra Observational Memory 研讨会](https://github.com/mastra-ai/mastra-observational-memory-workshop)
- [LangChain GitHub 仓库](https://github.com/langchain-ai/langchain)
- [CrewAI GitHub 仓库](https://github.com/crewAIInc/crewAI)
- [Vercel AI SDK 文档](https://sdk.vercel.ai/docs)
