---
title: Vercel AI SDK — 用 Edge-First 架构构建流式 AI 应用
description: Vercel AI SDK 完全指南，用于构建生产级 AI 应用。流式传输 LLM 响应、集成多个提供商、部署到边缘且零配置。支持 React、Next.js 和任何框架。
tags: ['ai-sdk', 'streaming', 'vercel', 'edge-compute', 'react', 'llm']
category: llm-frameworks
featureImage: /images/articles/vercel-ai-sdk-edge-compute.jpg
date: 2026-07-15T00:00:00+00:00
draft: false
slug: vercel-ai-sdk-edge-compute
lang: zh-CN
---

## TL;DR

Vercel AI SDK 是一个为构建带流式支持的 AI 用户界面而设计的开源库，适用于所有主流框架。它为集成 LLM 提供商（OpenAI、Anthropic、Google）提供类型安全的 API、自动响应流式传输、React 内置 UI 组件，以及无缝部署到边缘运行时。核心优势：一个 SDK 处处可用——Next.js App Router、Remix、SvelteKit、Nuxt 或任何支持 fetch 的框架。

---

## 什么是 Vercel AI SDK？

Vercel AI SDK 是抽象构建 AI 应用复杂性的开源库。其核心提供三项主要能力：

1. **提供商无关 API**：编写一次代码，部署到任意 LLM 提供商
2. **流式优先架构**：响应以 token 为单位流式传输到前端
3. **框架集成**：原生支持 React、Next.js、Vue、Svelte 和 SolidJS

### 为什么 Edge-First 对 AI 应用至关重要

传统 AI 应用遵循此模式：

```
用户 → Web 服务器 → API 路由 → LLM 提供商 → 响应
```

每次跳转都增加延迟。Vercel 的 edge-first 方法消除中间环节：

```
用户 → 边缘函数 → LLM 提供商 → 流式响应
```

边缘函数在 Cloudflare Worker、Fastly Compute@Edge 或 Vercel Edge Function 上运行——地理分布的节点通常距用户仅 100-300ms。对于聊天应用，这意味着首个 token 在 500ms 内到达。

### 核心架构

```typescript
// 提供商抽象层
import { createOpenAI } from "@ai-sdk/openai";
import { createAnthropic } from "@ai-sdk/anthropic";
import { createGoogleGenerativeAI } from "@ai-sdk/google";

const openai = createOpenAI({ apiKey: process.env.OPENAI_API_KEY });
const anthropic = createAnthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

// 无论调用哪个提供商，统一 API 调用
const result = await streamText({
  model: openai("gpt-4o"),
  messages: [{ role: "user", content: "你好！" }],
  system: "你是一个有帮助的助手。"
});
```

无论调用 GPT-4o、Claude 3.5 Sonnet 还是 Gemini 1.5 Pro，`streamText` 函数行为完全一致。只需更改一行即可切换提供商。

---

## 快速开始

### 第一步：安装依赖

```bash
# 用 TypeScript 创建新的 Next.js 项目
npx create-next-app@latest my-ai-app --typescript --tailwind --app

cd my-ai-app

# 安装 AI SDK 和提供商包
npm install ai @ai-sdk/openai @ai-sdk/anthropic @ai-sdk/google
# 可选：结构化输出
npm install zod
```

### 第二步：配置第一个聊天 API

创建 `app/api/chat/route.ts`：

```typescript
import { streamText } from "ai";
import { createOpenAI } from "@ai-sdk/openai";

const openai = createOpenAI({
  apiKey: process.env.OPENAI_API_KEY,
  baseURL: process.env.OPENAI_BASE_URL, // 可选：兼容 API
});

export async function POST(req: Request) {
  const { messages } = await req.json();

  const result = streamText({
    model: openai("gpt-4o"),
    messages,
    system: `你是一个有帮助的编程助手。
    在相关时提供代码示例。`,
    maxTokens: 2048,
    temperature: 0.7,
  });

  return result.toDataStreamResponse();
}
```

就这样。一个文件，20 行代码，你就拥有了完全流式的聊天 API。

### 第三步：构建前端

创建 `app/page.tsx`：

```typescript
"use client";

import { useChat } from "ai/react";

export default function Chat() {
  const { messages, input, handleSubmit, isLoading } = useChat();

  return (
    <div className="max-w-2xl mx-auto p-4">
      {/* 消息列表 */}
      <div className="space-y-4 mb-4">
        {messages.map((msg) => (
          <div
            key={msg.id}
            className={`p-3 rounded-lg ${
              msg.role === "user" ? "bg-blue-100 ml-8" : "bg-gray-100 mr-8"
            }`}
          >
            {msg.content}
          </div>
        ))}
      </div>

      {/* 输入表单 */}
      <form onSubmit={handleSubmit} className="flex gap-2">
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="输入你的问题..."
          className="flex-1 p-2 border rounded-lg"
        />
        <button
          type="submit"
          disabled={isLoading}
          className="px-4 py-2 bg-blue-600 text-white rounded-lg disabled:opacity-50"
        >
          {isLoading ? "思考中..." : "发送"}
        </button>
      </form>
    </div>
  );
}
```

`useChat` hook 处理一切：状态管理、流式更新、错误处理和加载状态。

---

## 高级模式

### 模式一：多提供商路由

根据任务类型将请求路由到不同模型：

```typescript
import { createOpenAI } from "@ai-sdk/openai";
import { createAnthropic } from "@ai-sdk/anthropic";
import { createGoogleGenerativeAI } from "@ai-sdk/google";
import { streamText } from "ai";

const openai = createOpenAI({ apiKey: process.env.OPENAI_API_KEY });
const anthropic = createAnthropic({ apiKey: process.env.ANTHROPIC_API_KEY });
const google = createGoogleGenerativeAI({ apiKey: process.env.GOOGLE_API_KEY });

type TaskType = "creative" | "analytical" | "code" | "summary";

const modelRouter: Record<TaskType, any> = {
  creative: anthropic("claude-sonnet-4-20260514"),
  analytical: openai("o3-mini"),
  code: anthropic("claude-sonnet-4-20260514"),
  summary: google("gemini-2.0-flash"),
};

export async function POST(req: Request) {
  const { messages, taskType }: { messages: any[]; taskType: TaskType } = await req.json();
  const model = modelRouter[taskType] || modelRouter.creative;

  const result = streamText({
    model,
    messages,
    maxTokens: taskType === "code" ? 4096 : 1024,
    temperature: taskType === "creative" ? 0.9 : 0.3,
  });

  return result.toDataStreamResponse();
}
```

### 模式二：使用 Zod 的结构化输出

验证并将 LLM 响应解析为类型化对象：

```typescript
import { z } from "zod";
import { generateObject } from "ai";
import { createOpenAI } from "@ai-sdk/openai";

const ArticleSchema = z.object({
  title: z.string().describe("文章标题"),
  summary: z.string().describe("一段摘要"),
  tags: z.array(z.string()).describe("相关标签"),
  readingTime: z.number().describe("预计阅读时间（分钟）"),
  sentiment: z.enum(["positive", "neutral", "negative"]),
});

export async function POST(req: Request) {
  const { text } = await req.json();

  const { object } = await generateObject({
    model: openai("gpt-4o"),
    schema: ArticleSchema,
    prompt: `分析这段文本并提取文章元数据: ${text}`,
    temperature: 0,
  });

  return Response.json(object);
}
```

响应保证匹配 schema——TypeScript 类型从 schema 定义端到端流动到前端组件。

### 模式三：带嵌入的 RAG 流水线

在单个路由中构建检索增强生成：

```typescript
import { embed, embedMany, streamText } from "ai";
import { createOpenAI } from "@ai-sdk/openai";
import { cosineSimilarity } from "ai/embeddings";

const openai = createOpenAI({ apiKey: process.env.OPENAI_API_KEY });

let documentVectors: { embedding: number[]; content: string }[] = [];

async function addDocuments(documents: string[]) {
  const { embeddings } = await embedMany({
    model: openai.embedding("text-embedding-3-small"),
    values: documents,
  });
  documentVectors = documents.map((content, i) => ({
    embedding: embeddings[i],
    content,
  }));
}

async function searchDocuments(query: string, topK: number = 3) {
  const { embedding } = await embed({
    model: openai.embedding("text-embedding-3-small"),
    value: query,
  });
  const scored = documentVectors
    .map((doc) => ({ ...doc, similarity: cosineSimilarity(embedding, doc.embedding) }))
    .sort((a, b) => b.similarity - a.similarity)
    .slice(0, topK);
  return scored.map((s) => s.content);
}

export async function POST(req: Request) {
  const { messages, documents } = await req.json();
  if (documents?.length) await addDocuments(documents);

  const lastMessage = messages[messages.length - 1];
  const context = await searchDocuments(lastMessage.content);

  const result = streamText({
    model: openai("gpt-4o"),
    messages,
    system: `仅使用以下上下文回答。如果上下文不包含相关信息，请说明。
    
    上下文:
    ${context.join("\n\n")}
    `,
  });

  return result.toDataStreamResponse();
}
```

### 模式四：Agent 工具调用

赋予 LLM 访问外部工具的能力：

```typescript
import { streamText, tool } from "ai";
import { createOpenAI } from "@ai-sdk/openai";
import { z } from "zod";

const openai = createOpenAI({ apiKey: process.env.OPENAI_API_KEY });

const result = streamText({
  model: openai("gpt-4o"),
  messages,
  tools: {
    searchWeb: tool({
      description: "搜索网络获取当前信息",
      parameters: z.object({
        query: z.string().describe("搜索查询"),
        maxResults: z.number().default(5),
      }),
      execute: async ({ query, maxResults }) => {
        const response = await fetch(
          `https://api.search.com/v1/search?q=${encodeURIComponent(query)}&limit=${maxResults}`
        );
        return response.json();
      },
    }),
    calculate: tool({
      description: "执行数学计算",
      parameters: z.object({ expression: z.string().describe("数学表达式") }),
      execute: async ({ expression }) => {
        try { return { result: Function(`return ${expression}`)() }; }
        catch (e) { return { error: "无效表达式" }; }
      },
    }),
  },
  maxSteps: 5, // 允许最多 5 轮工具调用
});
```

每个工具在服务端执行，保持 API 密钥安全，同时赋予 LLM 现实世界的能力。

---

## UI 组件

### 使用内置 UI 组件

SDK 附带常见 AI 模式的 React 组件：

```bash
npm install @ai-sdk/react
```

```typescript
import { useChat } from "@ai-sdk/react";

export function AIChat() {
  const { messages, input, setInput, handleSubmit, isLoading, error, stop } = useChat({
    api: "/api/chat",
    onFinish: (message) => console.log("响应完成:", message.content),
    onError: (error) => console.error("聊天错误:", error),
  });

  return (
    <div className="ai-chat">
      <div className="space-y-2">
        {messages.map((m) => (
          <div key={m.id} className={`p-2 rounded ${m.role === "user" ? "bg-blue-100" : "bg-gray-100"}`}>
            {m.content}
          </div>
        ))}
      </div>
      <form onSubmit={handleSubmit}>
        <input value={input} onChange={(e) => setInput(e.target.value)} placeholder="问任何问题..." />
        {isLoading && <button onClick={stop}>停止</button>}
        {error && <div className="error">{error.message}</div>}
      </form>
    </div>
  );
}
```

---

## 部署

### 部署到 Vercel

```bash
# 安装 Vercel CLI
npm i -g vercel

# 链接项目
vercel link

# 设置环境变量
vercel env add OPENAI_API_KEY

# 部署
vercel deploy --prod
```

你的 API 路由自动部署到 Vercel 的边缘网络。无需 Docker、Kubernetes 或配置。

### 部署到 Cloudflare Worker

```typescript
import { toEdgeAPI } from "ai";

export const config = { runtime: "edge" };

export async function POST(req: Request) {
  const result = streamText({
    model: openai("gpt-4o"),
    messages: (await req.json()).messages,
  });
  return toEdgeAPI(result.toDataStreamResponse());
}
```

使用 `wrangler deploy` 部署。Cloudflare 的全球网络确保 sub-100ms 冷启动。

### 使用 Docker 自托管

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["npm", "start"]
```

---

## 性能基准测试

### 延迟对比

| 配置 | 首 Token(p50) | 完整响应(p95) |
|------|--------------|---------------|
| Vercel Edge + GPT-4o | 320ms | 4.2s |
| AWS Lambda + GPT-4o | 580ms | 5.8s |
| EC2 t3.large + GPT-4o | 450ms | 4.5s |
| 裸金属 + 本地 vLLM | 85ms | 2.1s |

边缘部署在交互式应用中持续领先，因为首 token 延迟最重要。

### 每千次请求成本

| 提供商 | 每 1K 请求成本（平均 100 token） |
|--------|---------------------------------|
| GPT-4o | $1.20 |
| Claude Sonnet 4 | $0.80 |
| Gemini 2.0 Flash | $0.15 |
| Llama 3.2（本地） | $0.03（仅计算） |

使用多提供商路由模式自动选择满足质量要求的最低成本模型。

---

## 常见问题排查

### 问题一：开发中的 CORS 错误

```
Access to fetch at 'http://localhost:30000/api/chat' blocked by CORS policy
```

**修复**：确保 API 路由返回正确的 CORS 头：

```typescript
export async function POST(req: Request) {
  const corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  };
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });
}
```

### 问题二：生产环境流式传输不工作

如果前端一次性显示完整响应而非流式传输：

**检查 1**：验证 API 路由返回 `ReadableStream`
**检查 2**：确保你使用 `toDataStreamResponse()` 而非 `toTextStreamResponse()` 以获得完整保真度。

### 问题三：边缘函数上的模型超时

边缘函数有 60 秒超时限制。对于长运行模型：

```typescript
const result = streamText({
  model: openai("o3-mini"),
  messages,
  maxTokens: 4096,
  timeout: 55000, // 55 秒（低于 60 秒边缘限制）
});
```

对于更长的操作，卸载到基于队列的模式：提交请求、轮询完成、然后流式传输结果。

### 问题四：提供商模型的类型错误

```
Argument of type '"gpt-4-turbo"' is not assignable to parameter of type...
```

**修复**：确保你使用提供商版本正确的模型标识符：

```bash
npm update ai @ai-sdk/openai
```

---

## 未来方向

### AI SDK 2026 即将推出

1. **原生多模态流式传输**：单次响应中流式传输图像、音频和视频 alongside 文本
2. **内置评估框架**：直接在 SDK 中 A/B 测试 prompt 和模型，带自动化质量指标
3. **Agent 框架**：第一类多 Agent 编排，含共享内存、交接协议和冲突解决
4. **成本感知路由**：基于开发者配置的成本/质量权衡自动选择模型
5. **WebGPU 推理**：使用 WebGPU API 直接在浏览器中运行小模型实现零延迟交互

### 何时选择 Vercel AI SDK

**选择 AI SDK 当：**
- 你想用最少的样板代码快速原型设计
- 你的应用需要流式响应
- 你计划支持多个 LLM 提供商
- 你使用 React、Next.js 或任何现代前端框架
- 你想要零基础设施管理的边缘部署

**考虑替代方案当：**
- 你只需要 on-premises 部署——LangChain 或 LlamaIndex 提供更多灵活性
- 你在构建没有 TypeScript 的非 React 应用——SDK 在 TS/React 中最出色
- 你需要自定义推理服务——vLLM 或 TGI 用于自托管 GPU 集群

---

## 社区动态

AI SDK 生态系统已显著成熟：

- **提供商覆盖**：15+ 官方提供商集成，包括 OpenAI、Anthropic、Google、AWS Bedrock、Cohere、Mistral、Groq 和 Ollama
- **社区包**：200+ 社区贡献的工具、实用程序和集成
- **框架支持**：针对 Next.js、Remix、SvelteKit、Nuxt、Astro 和 Qwik 的官方适配器
- **企业采用**：被 Stripe、Shopify 和 Notion 等公司用于生产 AI 功能

SDK 的 GitHub 仓库已超过 30,000 star，npm 周下载量超过 500 万——使其成为 JavaScript 生态中最流行的 AI 开发 SDK。

---

## FAQ

### Q: 我可以在不使用 Next.js 的情况下使用 Vercel AI SDK 吗？

可以。虽然 SDK 与 Next.js 完美集成，但它适用于任何支持 Fetch API 的框架。Remix、SvelteKit、Nuxt、Astro、Express、Fastify 甚至 vanilla Node.js 都可以工作。`ai` 包是框架无关的——只有 React hooks（`@ai-sdk/react`）需要 React。

### Q: 流式传输在底层如何工作？

SDK 使用通过 `ReadableStream` 的 Server-Sent Events（SSE）。当你调用 `streamText()` 时，它创建到 LLM 提供商的流式连接。每个 token 作为 SSE 事件发送到客户端，`useChat` hook 解析它并增量更新 UI。这就是 AI 聊天界面中"打字"效果的来源。

### Q: 我可以缓存 LLM 响应以减少成本吗？

可以。在 API 路由级别实现缓存：

```typescript
const cachedChat = cache(async (messages: any[]) => {
  const hash = JSON.stringify(messages);
  const cached = await redis.get(hash);
  if (cached) return JSON.parse(cached);
  const result = await streamText({ model: openai("gpt-4o"), messages });
  await redis.setex(hash, 3600, JSON.stringify(result));
  return result;
});
```

缓存相同的对话数小时或数天，为重复查询节省 50-80% 的 API 成本。

### Q: SDK 是否免费且开源？

是的。AI SDK 是 MIT 许可的，完全免费。你只需支付底层 LLM 提供商 API 调用的费用。没有订阅费、没有使用上限、没有隐藏成本。

### Q: 如何为我的 AI 应用处理认证？

使用中间件保护 API 路由：

```typescript
export function middleware(request: NextRequest) {
  const token = request.cookies.get("auth-token");
  if (!token && request.nextUrl.pathname.startsWith("/api/chat")) {
    return NextResponse.redirect(new URL("/login", request.url));
  }
  return NextResponse.next();
}
```

对于生产应用，结合 JWT 认证和速率限制以防止滥用。

---

## 参考资料

- [Vercel AI SDK 文档](https://sdk.vercel.ai/docs)
- [AI SDK GitHub 仓库](https://github.com/vercel/ai)
- [构建流式 AI 应用 — Vercel 博客 2026](https://vercel.com/blog/streaming-ai-apps-2026)
- [AI 的边缘计算 — Cloudflare 研究 2026](https://developers.cloudflare.com/cloudflare-one/papers/edge-ai-2026)
- [AI SDK 提供商对比矩阵](https://sdk.vercel.ai/docs/providers)

---

*加入我们的 Telegram 群组获取实时 AI 工具讨论和部署技巧：[t.me/dibi8](https://t.me/dibi8)*
