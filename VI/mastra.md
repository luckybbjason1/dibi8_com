---
title: "Mastra: 24K+ Stars — Framework TypeScript AI Giảm Chi Ph...
description: "Mastra la framework TypeScript native tu Gatsby team de xay dung ung dung AI va agent. Bao gom Mastr..."
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
github_repo: "https://github.com/mastra-ai/mastra"
stars: 24050
maintainer: 'mastra-ai'
last_maintained: "2026-05-19"
featureImage: ''
draft: false
categories: ["llm-frameworks"]
tags: ["mastra", "typescript", "ai-framework", "agent", "llm", "mastra-huong-dan", "mastra-vs-langchain", "ma-nguon-mo"]
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

Kien truc cua Mastra xoay quanh sau khoi xay dung phan anh nhung gi cac he thong AI production thuc su can: ### Agent
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

# Tro ly se hoi: # - Ten du an
# - Thanh phan (agent, workflow, RAG, bo nho)
# - Nha cung cap LLM (OpenAI, Anthropic, Google, v.v.)
# - Co bao gom ma vi du khong
```

### Buoc 2: Cai Dat Thu Cong (Thay The)

Neu ban muon them Mastra vao du an hien co: ```bash
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
import { z } from zod;

const searchTool = createTool({
  id: 'search-docs',
  description: "Tim kiem tai lieu noi bo",
  inputSchema: z.object({
    query: z.string().describe('Truy van tim ki..."
services: mastra: build: .
    ports: - "4111:4111"
    environment: - OPENAI_API_KEY=${OPENAI_API_KEY}
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/mastra
    depends_on: - db

  db: image: pgvector/pgvector:pg17
    environment: POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: mastra
    volumes: - pgdata:/var/lib/postgresql/data

volumes: pgdata: ```

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

Mastra khong phai cong cu phu hop cho moi tinh huong. Day la nhung gi framework nay KHONG gioi: **Khoa Sinh Thai Python:** Neu toan bo stack data science cua ban la Python — pandas, NumPy, PyTorch, Jupyter — Mastra buoc ban phai ket noi hai ngon ngu. Framework nay chi dung TypeScript. Voi cac doi da dau tu sau vao Python, LangChain hoac CrewAI van la lua chon tu nhien hon.

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

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng: - **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
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


{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Mastra: 24K+ Stars — Framework TypeScript AI Giảm Chi Phí Token 4-10 Lần 2026",
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
    "@id": "https://dibi8.com/vi/resources/mastra"
  }
}
</script>

---

## Related Articles

- [12-factor-agents-production-llm-software-2026](mastra)
- [12-factor-agents](mastra)
- [1m-context-window-llm-2026-real-test](mastra)
- [9router-smart-llm-proxy-token-saver-free-coding](mastra)
- [ai-engineering-from-scratch](mastra)

---

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

