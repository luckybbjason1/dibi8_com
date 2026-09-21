---
title: Vercel AI SDK — Xây Dựng Ứng Dụng AI Streaming Với Kiến T...
description: Hướng dẫn toàn diện về Vercel AI SDK để xây dựng ứng dụng AI production. Stream response LLM, tích hợp nhiều provider và deploy đến edge với zero config. Hỗ trợ React, Next.js và mọi framework.
tags: ["ai-sdk", "streaming", "vercel", "edge-compute", "react", "llm"]
category: llm-frameworks
date: 2026-07-15T00:00:00+00:00
lastmod: 2026-07-15T00:00:00+00:00
draft: false
slug: vercel-ai-sdk-edge-compute
---


## TL;DR

Vercel AI SDK là thư viện mã nguồn mở để xây dựng giao diện người dùng powered AI với streaming support across tất cả framework chính. Nó cung cấp API type-safe để tích hợp LLM provider(OpenAI, Anthropic, Google), automatic response streaming, built-in UI component cho React và seamless deployment đến edge runtime. Lợi thế chính: một SDK hoạt động ở mọi nơi — Next.js App Router, Remix, SvelteKit, Nuxt hoặc bất kỳ framework nào hỗ trợ fetch.

* * *

## Vercel AI SDK Là Gì?

Vercel AI SDK là thư viện mã nguồn mở abstract hóa complexity của việc xây dựng ứng dụng AI. Về cốt lõi, nó cung cấp ba capability chính: 1. **Provider-agnostic API**: Viết code một lần, deploy đến bất kỳ LLM provider nào
2. **Streaming-first architecture**: Response stream token-by-token đến frontend
3. **Framework integration**: Native support cho React, Next.js, Vue, Svelte và SolidJS

### Tại Sao Edge-First Quan Trọng Cho Ứng Dụng AI

Ứng dụng AI truyền thống theo pattern này: ````
User → Web Server → API Route → LLM Provider → Response
`````

Mỗi hop thêm latency. Edge-first approach của Vercel loại bỏ middleman: `````
User → Edge Function → LLM Provider → Streaming Response
`````

Edge function chạy trên Cloudflare Worker, Fastly Compute@Edge hoặc Vercel Edge Function — node phân phối địa lý cách user 100-300ms. Cho chat application, điều này có nghĩa token đầu tiên đến trong dưới 500ms.

### Core Architecture

`````typescript
// Provider abstraction layer
import { createOpenAI } from "@ai-sdk/openai";
import { createAnthropic } from "@ai-sdk/anthropic";
import { createGoogleGenerativeAI } from "@ai-sdk/google";

const openai = createOpenAI({ apiKey: process.env.OPENAI_API_KEY });
const anthropic = createAnthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

// Unified API call bất kể provider
const result = await streamText({
  model: openai("gpt-4o"),
  messages: [{ role: "user", content: "Xin chào!" }],
  system: "Bạn là trợ lý hữu ích."
});
`````

Hàm ````streamText```` same hoạt động identically dù bạn gọi GPT-4o, Claude 3.5 Sonnet hay Gemini 1.5 Pro. Swap provider bằng cách thay đổi một dòng.

* * *

## Bắt Đầu

### Bước 1: Cài Đặt Dependency

`````bash
# Tạo new Next.js project với TypeScript
npx create-next-app@latest my-ai-app --typescript --tailwind --app

cd my-ai-app

# Cài đặt AI SDK và provider package
npm install ai @ai-sdk/openai @ai-sdk/anthropic @ai-sdk/google
# Optional: cho structured output
npm install zod
`````

### Bước 2: Cấu Hình Chat API Đầu Tiên

Tạo ``app/api/chat/route.ts``: `````typescript
import { streamText } from "ai";
import { createOpenAI } from "@ai-sdk/openai";

const openai = createOpenAI({
  apiKey: process.env.OPENAI_API_KEY,
  baseURL: process.env.OPENAI_BASE_URL, // Optional: cho compatible API
});

export async function POST(req: Request) {
  const { messages } = await req.json();

  const result = streamText({
    model: openai("gpt-4o"),
    messages,
    system: ````Bạn là trợ lý lập trình hữu ích. 
    Cung cấp ví dụ code khi liên quan.````,
    maxTokens: 2048,
    temperature: 0.7,
  });

  return result.toDataStreamResponse();
}
`````

Chỉ vậy đó. Một file, 20 dòng code và bạn có fully streaming chat API.

### Bước 3: Xây Dựng Frontend

Tạo ``app/page.tsx``: `````typescript
"use client";

import { useChat } from "ai/react";

export default function Chat() {
  const { messages, input, handleSubmit, isLoading } = useChat();

  return (
    <div className="max-w-2xl mx-auto p-4">
      {/* Message list */}
      <div className="space-y-4 mb-4">
        {messages.map((msg) => (
          <div
            key={msg.id}
            className={````p-3 rounded-lg ${
              msg.role === "user"
                ? "bg-blue-100 ml-8"
                : "bg-gray-100 mr-8"
            }````}
          >
            {msg.content}
          </div>
        ))}
      </div>

      {/* Input form */}
      <form onSubmit={handleSubmit} className="flex gap-2">
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Nhập tin nhắn..."
          className="flex-1 p-2 border rounded-lg"
        />
        <button
          type="submit"
          disabled={isLoading}
          className="px-4 py-2 bg-blue-600 text-white rounded-lg disabled:opacity-50"
        >
          {isLoading ? "Đang suy nghĩ..." : "Gửi"}
        </button>
      </form>
    </div>
  );
}
`````

Hook ````useChat```` xử lý everything: state management, streaming update, error handling và loading state.

* * *

## Mẫu Nâng Cao

### Mẫu 1: Multi-Provider Routing

Route request đến model khác nhau dựa trên task type: `````typescript
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
  const { messages, taskType }: { messages: any[]; taskType: TaskType } =
    await req.json();

  const model = modelRouter[taskType] || modelRouter.creative;

  const result = streamText({
    model,
    messages,
    maxTokens: taskType === "code" ? 4096 : 1024,
    temperature: taskType === "creative" ? 0.9 : 0.3,
  });

  return result.toDataStreamResponse();
}
`````

### Mẫu 2: Structured Output Với Zod

Validate và parse LLM response thành typed object: `````typescript
import { z } from "zod";
import { generateObject } from "ai";
import { createOpenAI } from "@ai-sdk/openai";

const openai = createOpenAI({ apiKey: process.env.OPENAI_API_KEY });

const ArticleSchema = z.object({
  title: z.string().describe("Tiêu đề bài viết"),
  summary: z.string().describe("Tóm tắt một đoạn"),
  tags: z.array(z.string()).describe("Tag liên quan"),
  readingTime: z.number().describe("Thời gian đọc ước tính phút"),
  sentiment: z.enum(["positive", "neutral", "negative"]),
});

export async function POST(req: Request) {
  const { text } = await req.json();

  const { object } = await generateObject({
    model: openai("gpt-4o"),
    schema: ArticleSchema,
    prompt: ````Phân tích text này và trích xuất metadata bài viết: ${text}````,
    temperature: 0,
  });

  return Response.json(object);
}
`````

Response được guarantee match schema — TypeScript type flow end-to-end từ schema definition đến frontend component.

### Mẫu 3: RAG Pipeline Với Embedding

Xây dựng retrieval-augmented generation trong single route: `````typescript
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
    .map((doc) => ({
      ...doc,
      similarity: cosineSimilarity(embedding, doc.embedding),
    }))
    .sort((a, b) => b.similarity - a.similarity)
    .slice(0, topK);

  return scored.map((s) => s.content);
}

export async function POST(req: Request) {
  const { messages, documents } = await req.json();

  if (documents?.length) {
    await addDocuments(documents);
  }

  const lastMessage = messages[messages.length - 1];
  const context = await searchDocuments(lastMessage.content);

  const result = streamText({
    model: openai("gpt-4o"),
    messages,
    system: ````Chỉ trả lời dùng context sau. 
    Nếu context không chứa thông tin relevant, nói vậy.
    
    Context: ${context.join("\n\n")}
    ````,
  });

  return result.toDataStreamResponse();
}
`````

### Mẫu 4: Agent Tool Calling

Cho LLM access đến external tool: ````typescript
import { streamText, tool } from "ai";
import { createOpenAI } from "@ai-sdk/openai";
import { z } from "zod";

const openai = createOpenAI({ apiKey: process.env.OPENAI_API_KEY });

const result = streamText({
  model: openai("gpt-4o"),
  messages,
  tools: {
    searchWeb: tool({
      description: "Tìm kiếm web cho thông tin hiện tại",
      parameters: z.object({
        query: z.string().describ..."
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
    "@id": "https://dibi8.com/vi/resources/vercel-ai-sdk-edge-compute"
  }
}
</script>

* * *

## Related Articles

- [12-factor-agents-production-llm-software-2026](vercel-ai-sdk-edge-compute)
- [12-factor-agents](vercel-ai-sdk-edge-compute)
- [1m-context-window-llm-2026-real-test](vercel-ai-sdk-edge-compute)
- [9router-smart-llm-proxy-token-saver-free-coding](vercel-ai-sdk-edge-compute)
- [ai-engineering-from-scratch](vercel-ai-sdk-edge-compute)

* * *

*Found this helpful? [Join our Telegram community](https://t.me/DIBI8_Group) for daily AI tool updates!*
