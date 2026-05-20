---
title: 'Mastra: 24K+ Stars — Framework TypeScript AI Giảm Chi Phí Token 4-10 Lần 2026'
description: 'Mastra la framework TypeScript native tu Gatsby team de xay dung ung dung AI va agent. Bao gom Mastra vs LangChain, huong dan cai dat, workflow, RAG, bo nho, observability, benchmark va hardening san xuat.'
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
tags: ['mastra', 'typescript', 'ai-framework', 'agent', 'llm', 'mastra-huong-dan', 'mastra-vs-langchain', 'ma-nguon-mo']
aliases:
- /vi/posts/mastra/
---

{{</* resource-info */>}}

Hau het cac framework AI deu duoc xay dung cho Python. Neu stack cua ban chay tren TypeScript va Node.js, ban phai chon cau noi giua cac ngon ngu hoac chap nhan trai nghiem phat trien kem hon. Dieu nay da thay doi khi Gatsby team ra mat Mastra — mot framework TypeScript native de xay dung agent AI, dat **24.050 sao GitHub** vao thang 5/2026 va dang duoc su dung trong moi truong production tai Replit, PayPal, va Sanity. Bai viet nay bao gom moi thu ban can de cai dat Mastra, xay dung agent dau tien, va hieu cach Observational Memory cua no giam chi phi token 4-10 lan so voi cach tiep can RAG truyen thong.

## Mastra la gi?

Mastra la mot framework TypeScript ma nguon mo de xay dung ung dung va agent AI. No cung cap mot bo cong cu thong nhat bao gom agent, workflow, pipeline RAG, he thong bo nho, khung danh gia, va kha nang quan sat — tat ca deu co ho tro kieu TypeScript hang dau. Khac voi cac framework Python duoc chuyen sang JavaScript, Mastra duoc xay dung tu nen tang len cho he sinh thai TypeScript. No nam tren Vercel AI SDK de xu ly tuong tac mo hinh cap thap va them cac lop truu tuong cao hon ma ung dung AI production yeu cau.

![Mastra Logo](https://raw.githubusercontent.com/mastra-ai/mastra/main/docs/public/logo.png)

Y tuong cot loi rat don gian: agent xu ly cac tac vu doi thoai mo co quyen truy cap cong cu, workflow quan ly cac quy trinh nhieu buoc co tinh dinh huong, RAG neo cau tra loi vao du lieu cua ban, bo nho duy tri ng canh lien cuoc doi thoai, va eval do luong chat luong. Ca sau nguyen thuy deu duoc tich hop trong `@mastra/core` va hoat dong cung nhau thong qua API Zod kieu nhat quan.

![Mastra Studio — Giao dien phat trien dia phuong de go loi agent, workflow va bo nho](https://www.firecrawl.dev/images/blog/mastra-tutorial/workflow-graph.webp)

## Mastra Hoat Dong Nhu The Nao — Kien Truc va Khai Niem Cot Loi

Kien truc cua Mastra xoay quanh sau khoi xay dung phan anh nhung gi cac he thong AI production thuc su can:

### Agent
Agent la cac tac nhan chinh. Ban cung cap cho chung huong dan, mo hinh, va quyen truy cap cong cu. Chung tu quyet dinh goi gi, khi nao dung, va cach tra loi. Agent co `.generate()` de nhan phan hoi day du va `.stream()` de phat truc tiep token — dieu nay rat quan trong cho giao dien tro chuyen noi nguoi dung mong doi thay cau tra loi hinh thanh dan.

### Workflow
Workflow cung cap dieu phoi co tinh dinh huong cho cac thao tac nhieu buoc can kiem soat ro rang. Duoc xay dung tren XState, chung ho tro re nhanh, thuc thi song song, vong lap, va che do human-in-the-loop noi thuc thi tam dung cho phe duyet truoc khi tiep tuc.

### RAG (Generation Tang Cuong Truy Xuat)
Pipeline RAG cua Mastra xu ly tach tai lieu, tao embedding, luu tru vector, tim kiem tuong dong, va xep hang lai. No tuong thich voi Pinecone, Qdrant, ChromaDB, pgvector va nhieu co so du lieu vector khac.

### Bo Nho
He thong bo nho bao gom lich su cuoc doi thoai (luu tru tin nhan tho), goi lai ngu nghia (tim kiem tuong dong dua tren embedding), bo nho lam viec (su kien va so thich co cau truc duoi dang ban nhap Markdown), va tinh nang noi bat — Observational Memory — nen cac cuoc doi thoai cu thanh cac quan sat day dac, giam chi phi token 4-10 lan.

### Cong Cu
Cong cu la cac ham duoc dinh nghia bang schema Zod ma agent co the goi. Chung cung cap giao dien co cau truc cho API ben ngoai, co so du lieu va dich vu. Mastra cung ho tro Model Context Protocol (MCP) de ket noi voi he sinh thai cong cu ben ngoai voi hon 10.000 may chu MCP co san.

### Eval
Khung danh gia theo doi chat luong agent thong qua cac phuong phap danh gia dua tren mo hinh, dua tren quy tac, va thong ke. Ban co the danh gia su lien quan, do trung thanh, do doc, tinh nhat quan giong noi, va cac chi so tuy chinh.

```typescript
// Kien truc cot loi Mastra — tat ca sau nguyen thuy trong mot thiet lap
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

## Cai Dat va Thiet Lap — Duoi 5 Phut

Mastra yeu cau Node.js 22.13.0 tro len. Duong dan khuyen nghi la su dung tro ly CLI, noi tao mot du an hoan chinh voi cau truc goi, tep cau hinh, va ma vi du phu hop.

### Buoc 1: Tao Du An Moi

```bash
# Tao du an Mastra moi voi CLI tuong tac
npm create mastra@latest

# Tro ly se hoi:
# - Ten du an
# - Thanh phan (agent, workflow, RAG, bo nho)
# - Nha cung cap LLM (OpenAI, Anthropic, Google, v.v.)
# - Co bao gom ma vi du khong
```

### Buoc 2: Cai Dat Thu Cong (Thay The)

Neu ban muon them Mastra vao du an hien co:

```bash
# Cai dat goi cot loi voi Zod de xac thuc schema
npm install @mastra/core@latest zod@^4

# Cai dat nha cung cap LLM ua thich tu AI SDK
npm install @ai-sdk/openai

# Tuy chon: goi vector store, bo nho, va trien khai
npm install @mastra/pg @mastra/memory @mastra/deployer-vercel
```

### Buoc 3: Thiet Lap Moi Truong

```bash
# .env — Mastra tu dong tai cac bien nay khi chay
OPENAI_API_KEY=sk-xxxx
DATABASE_URL=postgresql://user:pass@localhost:5432/mastra
```

### Buoc 4: Cau Truc Du An

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

### Buoc 5: Khoi Dong Mastra Studio

```bash
# Khoi dong giao dien phat trien dia phuong tai localhost:4111
npx mastra dev

# Studio cho phep ban tro chuyen voi agent, kiem tra loi goi cong cu,
# xem trang thai bo nho, hinh anh hoa workflow, va lap lai prompt
```

![Mastra Changelog Digest Workflow — Hien thi pipeline INPUT → SCRAPE → EXTRACT → OUTPUT](https://www.firecrawl.dev/images/blog/mastra-tutorial/changelog-pipeline.webp)

## Xay Dung Agent Dau Tien — Vi Du Ma Thuc

### Agent Co Ban Voi Cong Cu

```typescript
// src/mastra/agents/support.ts
import { Agent } from '@mastra/core';
import { openai } from '@ai-sdk/openai';
import { createTool } from '@mastra/core';
import { z } from 'zod';

const searchTool = createTool({
  id: 'search-docs',
  description: 'Tim kiem tai lieu noi bo',
  inputSchema: z.object({
    query: z.string().describe('Truy van tim kiem'),
  }),
  execute: async ({ context }) => {
    const results = await searchInternalDocs(context.query);
    return { results };
  },
});

export const supportAgent = new Agent({
  name: 'SupportAgent',
  instructions: `Ban la agent ho tro ky thuat. Tra loi cau hoi
    bang cong cu tim kiem. Ngan gon va trich dan nguon.`,
  model: openai('gpt-4o'),
  tools: { searchTool },
});
```

### Agent Voi Dau Ra Co Cau Truc

```typescript
// Nhan doi tuong kieu thay vi van ban thuan tuy
const result = await supportAgent.generate(
  'Phan loai ticket nay: "Khong the trien khai len Vercel"',
  {
    output: z.object({
      category: z.enum(['deployment', 'billing', 'bug', 'feature']),
      priority: z.enum(['low', 'medium', 'high', 'critical']),
      summary: z.string(),
      actionItems: z.array(z.string()),
    }),
  }
);

// result.object duoc kieu hoa day du — TypeScript biet cau truc
console.log(result.object.priority); // 'high' | 'low' | 'medium' | 'critical'
```

### Phan Hoi Streaming

```typescript
// Phat token thoi gian thuc cho giao dien tro chuyen
const stream = await supportAgent.stream(
  'Lam the nao de cau hinh bien moi truong?'
);

for await (const chunk of stream.textStream) {
  process.stdout.write(chunk); // Ghi token khi chung den
}
```

### Workflow Nhieu Buoc Voi Re Nhanh

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
      `Phan loai: ${input.ticketText}`,
      { output: z.object({ category: z.string(), priority: z.string() }) }
    );
    return result.object;
  },
});

const escalateStep = new Step({
  id: 'escalate',
  outputSchema: z.object({ escalated: z.boolean() }),
  execute: async ({ input }) => {
    await sendSlackAlert(`Uu tien cao: ${input.ticketText}`);
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

### Thuc Thi Workflow Song Song

```typescript
// Chay cac buoc song song voi .after()
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
  .step(stepD); // stepD chi chay sau khi A, B, va C deu hoan thanh
```

## Tich Hop Voi Next.js, Node.js, va Vercel AI SDK

### Tich Hop Next.js

```typescript
// app/api/agent/route.ts — Expose agent duoi dang route API trong Next.js
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

### May Chu Node.js Voi Hono

```bash
// Mastra dong goi may chu Hono HTTP khi ban build
npx mastra build

// Dau ra vao .mastra/output/
// May chu Hono expose agent, workflow, va bo nho duoi dang endpoint REST

npx mastra start
// May chu chay tai http://localhost:4111
```

### Tich Hop Vercel AI SDK

Mastra duoc xay dung tren Vercel AI SDK. Ban co the su dung SDK truc tiep cho kiem soat cap thap:

```typescript
// Mastra su dung nha cung cap AI SDK o cap thap
import { openai } from '@ai-sdk/openai';
import { anthropic } from '@ai-sdk/anthropic';
import { google } from '@ai-sdk/google';

// Chuyen doi nha cung cap bang mot dong ma
const agent = new Agent({
  name: 'MultiProviderAgent',
  instructions: 'Ban la tro ly huu ich.',
  model: openai('gpt-4o'), // hoac anthropic('claude-sonnet-4') hoac google('gemini-2.0-pro')
  tools: { searchTool, calcTool },
});
```

### Tich Hop MCP (Model Context Protocol)

```typescript
// Ket noi voi bat ky may chu MCP nao — hon 10.000 san co
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

// Cong cu MCP tu dong co san cho agent cua ban
const tools = await mcpClient.tools();
const agent = new Agent({
  name: 'MCPAgent',
  model: openai('gpt-4o'),
  tools, // Tat ca cong cu MCP gio da san sang
});
```

## Benchmark va Truong Hop Su Dung Thuc Te

### Giam Chi Phi Token — Tuyen Bo 4-10 Lan

Observational Memory cua Mastra la tinh nang noi bat cho kinh te san xuat. Day la cac con so:

**Van De:** Cac he thong bo nho dura tren RAG truyen thong truy xuat ng canh khac nhau mot cach dong tren moi luot. Moi lan truy xuat thay doi prefix prompt, vo hieu hoa bo dem prompt. Voi ca Anthropic va OpenAI deu cung cap chiet khau 90% cho cac token prompt duoc luu vao bo dem, moi lan truy cap bo dem khong trung khop deu bi phat chi phi 10 lan tren phan duoc luu vao bo dem.

**Giai Phap:** Observational Memory chia ng canh thanh hai khoi — cac quan sat duoc nen (chi them cho den khi reflection chay) va cac tin nhan gan day tho. Khoi quan sat giu nhat quan giua cac luot, khien no co the luu vao bo dem toan bo.

### Ty Le Nen Theo Tai

| Loai Tai | Ty Le Nen | Vi Du |
|---|---|---|
| Doi thoai van ban thuan tuy | 3-6x | Tro chuyen ho tro khach hang |
| Agent nang cong cu (trinh duyet, coding) | 5-40x | Tu dong hoa trinh duyet, agent lap trinh |
| Agent co anh chup man hinh/tai lieu lon | 10-40x | Playwright DOM snapshots |

### Ket Qua Benchmark LongMemEval

| He Thong Bo Nho | Diem GPT-4o | Diem GPT-5-mini |
|---|---|---|
| Mastra Observational Memory | 84,23% | 94,87% |
| Mastra RAG (co so) | 80,05% | — |
| Lich su doi thoai truyen thong | ~72% | — |

Mot agent tu dong hoa trinh duyet chup anh man hinh Playwright co the nen 200.000 token lich su phien thanh 5.000-15.000 token quan sat — giam 15-30 lan.

### Benchmark Trai Nghiem Nha Phat Trien

| Framework | Diem DX (1-10) | Thoi Gian Cai Dat | Thoi Gian Den Agent Dau Tien |
|---|---|---|---|
| Mastra | 9/10 | < 5 phut | Vai phut |
| LangChain (Python) | 5/10 | 15-30 phut | Vai gio |
| CrewAI | 6/10 | 10-15 phut | 30 phut |
| Vercel AI SDK | 7/10 | < 5 phut | Vai gio (lap rap thu cong) |

*Nguon: Benchmark production NextBuild, thang 12/2025*

### Cac Trien Khai Production

- **Replit**: Su dung Mastra cho tinh nang tao ma va chinh sua AI
- **PayPal**: Agent AI ho tro khach hang cho thanh toan
- **Sanity**: Quy trinh noi dung va chinh sua co tro ly AI
- **WorkOS**: Tu dong hoa nhan dang va truy cap doanh nghiep
- **Elastic**: Cac tinh nang AI tim kiem va quan sat

## Su Dung Nang Cao — Cung Co Production

### Cau Hinh Bo Nho Voi Observational Memory

```typescript
import { Mastra } from '@mastra/core';
import { ObservationalMemory } from '@mastra/memory';
import { PgStorage } from '@mastra/pg';

const mastra = new Mastra({
  agents: { supportAgent },
  memory: new ObservationalMemory({
    storage: new PgStorage({ connectionString: process.env.DATABASE_URL }),
    observerModel: openai('gpt-4o-mini'), // Chay agent Observer
    reflectorModel: openai('gpt-4o-mini'), // Chay agent Reflector
    compressionInterval: 5, // Nen sau moi 5 tin nhan
  }),
});
```

### Thiet Lap Pipeline RAG

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

// Danh chi muc tai lieu
await rag.index(documentBatch);

// Truy van voi tim kiem tuong dong
const results = await rag.query('Lam the nao cau hinh SSO?', { topK: 5 });
```

### Quan Sat Voi OpenTelemetry

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

// Cac trace tu dong xuat hien tren nen tang quan sat cua ban
// Moi loi goi agent, thuc thi cong cu, va buoc workflow deu duoc tu dong instrument
```

### Rai Dao Va Bao Mat

```typescript
import { Agent } from '@mastra/core';
import { createGuardrail } from '@mastra/core';

const promptInjectionGuard = createGuardrail({
  id: 'no-prompt-injection',
  check: async ({ input }) => {
    const suspicious = /ignore previous|disregard instructions/i.test(input);
    return { passed: !suspicious, message: suspicious ? 'Phat hien injection' : undefined };
  },
});

const piiGuard = createGuardrail({
  id: 'no-pii',
  check: async ({ output }) => {
    const hasPii = /\b\d{3}-\d{2}-\d{4}\b/.test(output); // Mau SSN
    return { passed: !hasPii, message: hasPii ? 'Phat hien ro ri PII' : undefined };
  },
});

const agent = new Agent({
  name: 'SafeAgent',
  model: openai('gpt-4o'),
  tools: { searchTool },
  guardrails: [promptInjectionGuard, piiGuard],
});
```

### Human-in-the-Loop

```typescript
import { Workflow, Step } from '@mastra/core';

const humanApprovalStep = new Step({
  id: 'await-approval',
  outputSchema: z.object({ approved: z.boolean() }),
  execute: async ({ suspend }) => {
    // Tam dung workflow va cho dau vao con nguoi
    const { approved } = await suspend({ reason: 'Hoan tien vuot qua $500' });
    return { approved };
  },
});

// Workflow tiep tuc khi con nguoi duyet qua Studio hoac API
const refundWorkflow = new Workflow({
  name: 'refund-pipeline',
  triggerSchema: z.object({ amount: z.number(), orderId: z.string() }),
})
  .step(validateStep)
  .then(humanApprovalStep)
  .then(processRefundStep, { when: { 'await-approval.approved': true } });
```

### Trien Khai Docker

```dockerfile
// Dockerfile cho trien khai production
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
// docker-compose.yml
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

## So Sanh Voi Cac Lua Chon Thay The

| Tinh Nang | Mastra | LangChain | CrewAI | Vercel AI SDK |
|---|---|---|---|---|
| **Ngon Ngu Chinh** | TypeScript (99,2%) | Python (co JS) | Python | TypeScript |
| **Sao GitHub** | 24.050 | 117.000 | 39.200 | N/A (thuoc Vercel) |
| **Thoi Gian Cai Dat** | < 5 phut | 15-30 phut | 10-15 phut | < 5 phut (lap rap thu cong) |
| **Truu Tuong Hoa Agent** | Lop Agent native | Lop Chain/Agent | Crew dua tren vai tro | Ket hop thu cong |
| **Cong Cu Workflow** | XState-based, ben bi | LangGraph (do thi) | Tuan tu/phan cap | Khong |
| **He Thong Bo Nho** | Observational Memory (giam chi phi 4-10x) | ConversationBufferMemory | Chi ngan han | Thu cong |
| **An Toan Kieu** | Zod toan bo, TS day du | Phan ho tro JS | Python type hints | Ho tro Zod |
| **Kha Nang Quan Sat** | Built-in + OTEL | LangSmith (SaaS) | Co ban built-in | Nen tang Vercel |
| **Ho Tro MCP** | Native | Qua adapter | Han che | Qua tich hop |
| **Da Agent** | Che do Supervisor | LangGraph da agent | Tinh nang cot loi | Thu cong |
| **Phu Hop Nhat** | Doi TS, Next.js, Node.js | Doi Python, do thi phuc tap | Nguyen mau da agent Python | Ung dung React/Next.js UI nang |
| **Nha Cung Cap LLM** | 40+ | 100+ | 20+ | 10+ |
| **Nguoi Dung Production** | Replit, PayPal, Sanity | Uber, LinkedIn | Startup, agency | Ung dung host Vercel |
| **Cach Trien Khai** | Bat ky may chu Node.js, Vercel, CF Workers | LangSmith Cloud, tu host | Tu host, CrewAI Cloud | Vercel (toi uu) |

## Han Che — Danh Gia Trung Thuc

Mastra khong phai cong cu phu hop cho moi tinh huong. Day la nhung gi framework nay KHONG gioi:

**Khoa Sinh Thai Python:** Neu toan bo stack data science cua ban la Python — pandas, NumPy, PyTorch, Jupyter — Mastra buoc ban phai ket noi hai ngon ngu. Framework nay chi dung TypeScript. Voi cac doi da dau tu sau vao Python, LangChain hoac CrewAI van la lua chon tu nhien hon.

**Sinh Thai Tich Hop Nho Hon:** LangChain co 100+ tich hop LLM va 50+ vector store. Mastra ho tro 40+ nha cung cap va bao phu cac vector DB chinh, nhung neu ban can mot mo hinh hiem hoac vector store ngach, co the ban se can viet ma tich hop tuy chinh.

**Du An Tre, Thay Doi Nhieu Hon:** Mastra dat v1.0 vao thang 1/2026. API da on dinh nhung breaking changes van xay ra thuong xuyen hon trong he sinh thai truong thanh cua LangChain. Du thoi gian cho nang cap phien ban.

**Khong Co Cong Cu Xay Dung Workflow Truc Quan:** Khac voi n8n hoac Langflow, Mastra khong co trinh thiet ke workflow keo-tha. Tat ca deu la ma. Voi cac thanh vien doi khong ky thuat can chinh sua workflow, day la rao can.

**Quy Mo Cong Dong:** Voi 24K stars, cong dong Mastra tich cuc nhung nho hon nhieu so voi LangChain. Ban se tim thay it cau tra loi tren Stack Overflow hon, it huong dan tu ben thu ba hon, va it bai viet blog ve cac truong hop bien hon.

**Thanh Phan UI Han Che:** Mastra Studio cung cap san choi phat trien, nhung khong cung cap cac thanh phan UI production nhu widget tro chuyen. Ban van can tu xay dung frontend hoac ket hop Mastra voi thu vien UI cua Vercel AI SDK.

## Cau Hoi Thuong Gap

**Q: Mastra co yeu cau kien thuc TypeScript khong?**
Co, Mastra la TypeScript native. Ky vong co kien thuc co ban ve TypeScript, async/await, va schema Zod. Neu doi chi biet Python, duong cong hoc TypeScript cong voi Mastra se doc hon so voi viec dung LangChain truc tiep.

**Q: Observational Memory cua Mastra so voi lop bo nho cua LangChain nhu the nao?**
LangChain cung cap ConversationBufferMemory, ConversationSummaryMemory, va truy xuat vector. Cac phuong phap nay hoat dong nhung hoac tieu ton toan bo cua so ng canh hoac dura vao tim kiem vector lam vo hieu bo dem prompt. Observational Memory cua Mastra nen ng canh thanh cac quan sat co the luu vao bo dem, dat duoc giam chi phi 4-10 lan trong khi dat diem cao hon tren benchmark LongMemEval (84,23% so voi 80,05% cua RAG).

**Q: Toi co the trien khai Mastra tren DigitalOcean hoac AWS thay vi Vercel khong?**
Co. Mastra hoan toan ma nguon mo va trien khai duoc tren bat ky runtime Node.js nao. Xay dung bang `mastra build`, sau do chay dau ra tren DigitalOcean App Platform, AWS ECS, Google Cloud Run, hoac bat ky may chu Docker nao. Cac trinh trien khai cho Vercel va Cloudflare Workers la tuy chon.

**Q: Mastra ho tro nha cung cap LLM nao?**
Mastra ho tro 40+ nha cung cap thong qua Vercel AI SDK: OpenAI, Anthropic, Google, Mistral, Cohere, xAI, DeepSeek, Fireworks, Together va nhieu nha khac. Chuyen doi nha cung cap la thay doi mot dong ma.

**Q: Mastra xu ly loi va thu lai trong production nhu the nao?**
Workflow cua Mastra bao gom chinh sach thu lai co the cau hinh voi backoff ham mu o cap do buoc. Agent co xu ly timeout tich hop. Tich hop quan sat (OpenTelemetry) truy vet moi cuoc goi, khien viec xac dinh va go loi loi trong production tro nen de dang.

**Q: Mastra co mien phi cho su dung thuong mai khong?**
Co. Mastra duoc cap phep Apache 2.0 va mien phi cho su dung thuong mai. Mastra Cloud (hosting quan ly) co cac muc gia tra phi, nhung framework cot loi hoan toan ma nguon mo va co the tu host mien phi.

**Q: Lam the nao de them bo nho cho agent Mastra hien co?**
Truyen mot the hien bo nho khi tao the hien Mastra. Agent tu dong theo doi chu de doi thoai theo nguoi dung. Cho cac cuoc doi thoai nhieu luot, khoi tao bo nho voi backend luu tru (PostgreSQL, libSQL, hoac MongoDB) va agent se xu ly phan con lai.

## Ket Luan

Mastra lap day khoang trong ro rang trong boi canh framework AI — mot bo cong cu TypeScript native cap do production cho phep nha phat trien JavaScript xay dung agent ma khong can roi khoi he sinh thai cua ho. Viec giam chi phi token 4-10 lan tu Observational Memory khong phai la tuyen ba quang cao; no la mot loi the production co the do luong duoc ho tro boi benchmark LongMemEval. Diem DX 9/10 va thoi gian thiet lap duoi 5 phut cua framework khien no la con duong nhanh nhat tu y tuong den agent da trien khai cho cac doi TypeScript.

Neu ban dang xay dung cac tinh nang AI cho ung dung Next.js, dich vu Node.js, hoac bat ky du an TypeScript nao, Mastra xung dang duoc danh gia nghiem tuc. Bat dau voi `npm create mastra@latest`, xay dung mot workflow, va tu do luong su khac biet chi phi token.

**Cac muc hanh dong:**
1. Clone repo Mastra va chay quickstart: `npm create mastra@latest`
2. Tham gia [cong dong Discord Mastra](https://discord.gg/mastra) (5.500+ thanh vien)
3. Kham pha [tai lieu chinh thuc](https://mastra.ai/docs)
4. Theo doi [repo GitHub Mastra](https://github.com/mastra-ai/mastra) de cap nhat

*Mot so lien ket trong bai viet nay la lien ket lien ket. Neu ban dang ky DigitalOcean qua lien ket gioi thieu cua chung toi, chung toi co the nhan duoc hoa hong ma khong co chi phi phat sinh cho ban. Dieu nay giup tai tro cho nghien cuu ky thuat doc lap.*



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguon va Tai Lieu Tham Khao

- [Trang Web Chinh Thuc Mastra](https://mastra.ai)
- [Repo GitHub Mastra](https://github.com/mastra-ai/mastra)
- [Tai Lieu Chinh Thuc Mastra](https://mastra.ai/docs)
- [Khoa Hoc Mastra — Hoc Xay Dung Agent AI](https://mastra.ai/course)
- [Huong Dan Mastra: Trinh Theo Doi Changelog Voi Firecrawl](https://www.firecrawl.dev/blog/mastra-tutorial)
- [Phan Tich Sau Observational Memory Mastra](https://agentmarketcap.ai/blog/2026/04/13/mastra-observational-memory-observer-reflector-pattern-agent-costs-longmemeval-2026)
- [ByteIota: Phan Tich Framework AI TypeScript Mastra](https://byteiota.com/mastra-typescript-ai-framework-cuts-token-costs-4-10x/)
- [So Sanh Mastra vs LangChain — xpay](https://www.xpay.sh/resources/agentic-frameworks/compare/langchain-vs-mastra/)
- [So Sanh CrewAI vs Mastra — respan.ai](https://respan.ai/market-map/compare/crewai-vs-mastra)
- [Cac Framework Gen AI JS/TS Hang Dau 2026](https://xavidop.me/genkit/2026-04-16-top-jsts-genai-frameworks-2026/)
- [Workshop Mastra: Xay Dung Agent Coding Cua Rieng Ban](https://github.com/mastra-ai/workshop-mastracode)
- [Workshop Observational Memory Mastra](https://github.com/mastra-ai/mastra-observational-memory-workshop)
- [Repo GitHub LangChain](https://github.com/langchain-ai/langchain)
- [Repo GitHub CrewAI](https://github.com/crewAIInc/crewAI)
- [Tai Lieu Vercel AI SDK](https://sdk.vercel.ai/docs)
