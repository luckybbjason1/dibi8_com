---
title: "Mastra: 24K+ Stars — Token 비용을 4-10배 절감하는 TypeScript AI ...
description: "Mastra는 Gatsby 팀이 만든 TypeScript 네이티브 AI 프레임워크로 AI 기반 애플리케이션과 에이전트를 구축합니다. Mastra vs LangChain, 설치 튜토..."
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
github_repo: "https://github.com/mastra-ai/mastra"
stars: 24050
maintainer: 'mastra-ai'
last_maintained: "2026-05-19"
featureImage: ''
draft: false
categories: ["llm-frameworks"]
tags: ["mastra", "typescript", "ai프레임워크", "에이전트", "llm", "mastra튜토리얼", "mastra-vs-langchain", "오픈소스"]
aliases:
  - /kr/posts/mastra/
---


{{</* resource-info */>}}

대부분의 AI 프레임워크는 Python용으로 만들어졌습니다. 기술 스택이 TypeScript와 Node.js를 기반으로 한다면 두 가지 선택지밖에 없었습니다: 언어 간 브리징을 하거나, 떨어지는 개발자 경험을 감수하는 것입니다. Gatsby 팀이 Mastra를 출시하면서 상황이 바뀌었습니다 — TypeScript 네이티브 AI 에이전트 구축 프레임워크로, 2026년 5월 기준 **24,050개의 GitHub Star**를 달성했으며 현재 Replit, PayPal, Sanity 등에서 프로덕션 환경에 사용되고 있습니다. 이 글에서는 Mastra 설치부터 첫 에이전트 구축, 그리고 Observational Memory가 기존 RAG 접근법 대비 Token 비용을 4-10배 어떻게 절감하는지에 대한 모든 것을 다룹니다.

## Mastra란?

Mastra는 AI 기반 애플리케이션과 에이전트를 구축하기 위한 오픈소스 TypeScript 프레임워크입니다. 에이전트, 워크플로우, RAG 파이프라인, 메모리 시스템, 평가 프레임워크, 관측 가능성을 통합된 툴킷으로 제공하며 일류의 TypeScript 타입 지원을 갖추고 있습니다. Python에서 JavaScript로 포팅된 프레임워크와 달리 Mastra는 처음부터 TypeScript 생태계를 위해 만들어졌습니다. Vercel AI SDK 위에 구축되어 낮은 수준의 모델 상호작용을 처리하고, 프로덕션 AI 애플리케이션에 필요한 고수준 추상화를 추가합니다.

![Mastra Logo](https://raw.githubusercontent.com/mastra-ai/mastra/main/docs/public/logo.png)

핵심 개념은 간단합니다: 에이전트는 도구 접근 권한을 가진 개방형 대화 작업을 처리하고, 워크플로우는 결정론적 다단계 프로세스를 관리하며, RAG는 응답을 데이터에 기반시키고, 메모리는 대화 간 문맥을 유지하며, 평가는 품질을 측정합니다. 6가지 원시 요소 모두 ```@mastra/core````에 포함되어 일관된 Zod 타입 API로 함께 작동합니다.

![Mastra Studio — 에이전트, 워크플로우, 메모리를 디버깅하는 로컬 개발 UI](https://www.firecrawl.dev/images/blog/mastra-tutorial/workflow-graph.webp)

## Mastra의 작동 방식 — 아키텍처와 핵심 개념

Mastra의 아키텍처는 프로덕션 AI 시스템에 실제로 필요한 6가지 구성 요소를 중심으로 설계되었습니다: ### 에이전트 (Agents)
에이전트는 주요 행위자입니다. 지시사항, 모델, 도구 접근 권한을 제공하면 에이전트가 어떤 것을 호출할지, 언제 멈출지, 어떻게 응답할지 스스로 결정합니다. ````.generate()````는 완전한 응답을 위해, ````.stream()````은 실시간 Token 스트리밍을 제공합니다 — 이는 응답이 점진적으로 표시되는 채팅 UI에 필수적입니다.

### 워크플로우 (Workflows)
워크플로우는 XState 기반으로 명시적 제어가 필요한 다단계 작업의 결정론적 오케스트레이션을 제공합니다. 분기, 병렬 실행, 반복, 그리고 실행을 일시 중지한 후 승인을 받으면 재개하는 휴인더루프(human-in-the-loop) 패턴을 지원합니다.

### RAG (검색 증강 생성)
Mastra의 RAG 파이프라인은 문서 청킹, 임베딩 생성, 벡터 저장, 유사성 검색, 리랭킹을 처리합니다. Pinecone, Qdrant, ChromaDB, pgvector 등 주요 벡터 데이터베이스와 호환됩니다.

### 메모리 (Memory)
메모리 시스템은 대화 기록(원본 메시지 저장), 시맨틱 리콜(임베딩 기반 유사성 검색), 워킹 메모리(구조화된 사실과 선호도를 Markdown 스크래치패드로), 그리고 핵심 기능인 Observational Memory — 오래된 대화를 압축된 관찰로 변환하여 Token 비용을 4-10배 절감합니다.

### 도구 (Tools)
도구는 Zod 스키마로 정의된 타입 함수로 에이전트가 호출할 수 있습니다. 외부 API, 데이터베이스, 서비스에 대한 구조화된 인터페이스를 제공합니다. Mastra는 10,000개 이상의 사용 가능한 MCP 서버가 있는 외부 도구 생태계에 연결하기 위한 모델 컨텍스트 프로토콜(MCP)도 지원합니다.

### 평가 (Evals)
평가 프레임워크는 모델 기반 평가, 규칙 기반, 통계적 방법을 통해 에이전트 품질을 추적합니다. 관련성, 충실도, 독성, 톤 일관성, 커스텀 메트릭을 평가할 수 있습니다.

`````typescript
// Mastra 핵심 아키텍처 — 6가지 원시 요소를 한 설정에
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

## 설치 및 설정 — 5분 이내

Mastra는 Node.js 22.13.0 이상이 필요합니다. 권장 방법은 CLI 마법사를 사용하는 것으로, 올바른 패키지 구조와 구성 파일, 예제 코드가 포함된 완전한 프로젝트를 스캐폴드합니다.

### 단계 1: 새 프로젝트 생성

`````bash
# 인터랙티브 CLI로 새 Mastra 프로젝트 스캐폴드
npm create mastra@latest

# 마법사가 묻는 항목: # - 프로젝트 이름
# - 구성 요소 (에이전트, 워크플로우, RAG, 메모리)
# - LLM 제공자 (OpenAI, Anthropic, Google 등)
# - 예제 코드 포함 여부
`````

### 단계 2: 수동 설치 (대안)

기존 프로젝트에 Mastra를 추가하려는 경우: `````bash
# 스키마 검증용 Zod와 함께 핵심 패키지 설치
npm install @mastra/core@latest zod@^4

# AI SDK에서 선호하는 LLM 제공자 설치
npm install @ai-sdk/openai

# 선택적: 벡터 저장소, 메모리, 배포 패키지
npm install @mastra/pg @mastra/memory @mastra/deployer-vercel
`````

### 단계 3: 환경 설정

`````bash
# .env — Mastra가 런타임에 자동 로드
OPENAI_API_KEY=sk-xxxx
DATABASE_URL=postgresql://user:pass@localhost:5432/mastra
`````

### 단계 4: 프로젝트 구조

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

### 단계 5: Mastra Studio 실행

`````bash
# localhost:4111에서 로컬 개발 UI 시작
npx mastra dev

# Studio를 통해 에이전트와 채팅, 도구 호출 검사,
# 메모리 상태 보기, 워크플로우 시각화, 프롬프트 반복 가능
`````

![Mastra Changelog Digest 워크플로우 — INPUT → SCRAPE → EXTRACT → OUTPUT 파이프라인](https://www.firecrawl.dev/images/blog/mastra-tutorial/changelog-pipeline.webp)

## 첫 번째 에이전트 구축 — 실제 코드 예제

### 도구가 있는 기본 에이전트

`````typescript
// src/mastra/agents/support.ts
import { Agent } from '@mastra/core';
import { openai } from '@ai-sdk/openai';
import { createTool } from '@mastra/core';
import { z } from zod;

const searchTool = createTool({
  id: 'search-docs',
  description: "낮부 문서 검색",
  inputSchema: z.object({
    query: z.string().describe('검색 쿼리'),
  }),
  execute: async..."
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

volumes: pgdata: `````

## 대안과의 비교

| 기능 | Mastra | LangChain | CrewAI | Vercel AI SDK |
|---|---|---|---|---|
| **주요 언어** | TypeScript (99.2%) | Python (JS도 지원) | Python | TypeScript |
| **GitHub Stars** | 24,050 | 117,000 | 39,200 | N/A (Vercel의 일부) |
| **설정 시간** | < 5분 | 15-30분 | 10-15분 | < 5분 (수동 배선) |
| **에이전트 추상화** | 네이티브 Agent 클래스 | Chain/Agent 클래스 | 역할 기반 crew | 수동 조합 |
| **워크플로우 엔진** | XState 기반, 내구성 | LangGraph (그래프) | 순차/계층적 | 없음 |
| **메모리 시스템** | Observational Memory (비용 4-10x 절감) | ConversationBufferMemory | 단기 전용 | 수동 |
| **타입 안전성** | 전체 Zod, 완전 TS | JS 버전 부분 지원 | Python 타입 힌트 | Zod 지원 |
| **관측 가능성** | 내장 + OTEL | LangSmith (SaaS) | 기본 내장 | Vercel 플랫폼 |
| **MCP 지원** | 네이티브 | 어댑터 통해 | 제한적 | 통합 통해 |
| **멀티 에이전트** | Supervisor 패턴 | LangGraph 멀티 에이전트 | 핵심 기능 | 수동 |
| **가장 적합** | TS 팀, Next.js, Node.js | Python 팀, 복잡한 그래프 | Python 멀티 에이전트 프로토타입 | React/Next.js UI 중심 앱 |
| **LLM 제공자** | 40+ | 100+ | 20+ | 10+ |
| **프로덕션 사용자** | Replit, PayPal, Sanity | Uber, LinkedIn | 스타트업, 에이전시 | Vercel 호스팅 앱 |
| **배포** | 모든 Node.js 서버, Vercel, CF Workers | LangSmith Cloud, 자체 호스팅 | 자체 호스팅, CrewAI Cloud | Vercel (최적) |

## 한계 — 정직한 평가

Mastra는 모든 상황에 맞는 도구가 아닙니다. 이 프레임워크가 적합하지 않은 경우는 다음과 같습니다: **Python 생태계 락인:** 데이터 사이언스 스택 전체가 Python — pandas, NumPy, PyTorch, Jupyter — 이라면 Mastra는 두 언어를 연결해야 합니다. 이 프레임워크는 순수 TypeScript입니다. Python에 깊이 투자한 팀에게는 LangChain이나 CrewAI가 더 자연스러운 선택입니다.

**더 작은 통합 생태계:** LangChain은 100개 이상의 LLM 통합과 50개 이상의 벡터 저장소를 보유하고 있습니다. Mastra는 40개 이상의 제공자를 지원하고 주요 벡터 데이터베이스를 커버하지만, 희귀한 모델이나 틈새 벡터 저장소가 필요하면 커스텀 통합 코드를 작성해야 할 수 있습니다.

**새로운 프로젝트, 더 높은 변경률:** Mastra는 2026년 1월 v1.0에 도달했습니다. API는 안정화되었지만 LangChain의 성숙한 생태계보다 breaking change가 더 자주 발생합니다. 버전 업그레이드 시간을 예산에 포함하세요.

**네이티브 시각적 워크플로우 빌더 없음:** n8n이나 Langflow와 달리 Mastra에는 드래그 앤 드롭 워크플로우 설계 도구가 없습니다. 모든 것이 코드입니다. 워크플로우를 수정해야 하는 비기술 팀원에게는 진입 장벽입니다.

**커뮤니티 규모:** 24K stars로 Mastra의 커뮤니티는 활발하지만 LangChain보다 훨씬 작습니다. Stack Overflow 답변, 서드파티 튜토리얼, 에지 케이스를 다루는 블로그 글이 더 적습니다.

**제한된 UI 컴포넌트:** Mastra Studio는 개발 플레이그라운드를 제공하지만 채팅 위젯과 같은 프로덕션 UI 컴포넌트는 제공하지 않습니다. 여전히 직접 프론트엔드를 빌드하거나 Mastra를 Vercel AI SDK의 UI 라이브러리와 페어링해야 합니다.

## 자주 묻는 질문

**Q: Mastra는 TypeScript 지식이 필요한가요?**
네, Mastra는 TypeScript 네이티브입니다. TypeScript, async/await, Zod 스키마에 대한 기본적인 숙련도가 예상됩니다. 팀이 Python만 안다면 TypeScript와 Mastra를 함께 배우는 것이 LangChain을 직접 사용하는 것보다 학습 곡선이 더 가파를 것입니다.

**Q: Mastra의 Observational Memory는 LangChain의 메모리 클래스와 어떻게 다른가요?**
LangChain은 ConversationBufferMemory, ConversationSummaryMemory, 벡터 기반 검색을 제공합니다. 이들은 전체 컨텍스트 윈도우를 소비하거나 프롬프트 캐시를 무효화하는 벡터 검색에 의존합니다. Mastra의 Observational Memory는 문맥을 캐시 가능한 관찰로 압축하여 4-10배 비용 절감을 달성하면서 LongMemEval 벤치마크에서 더 높은 점수(84.23% vs RAG의 80.05%)를 기록합니다.

**Q: DigitalOcean이나 AWS에서 Vercel이 아닌 Mastra를 배포할 수 있나요?**
네. Mastra는 완전히 오픈소스이며 모든 Node.js 런타임에 배포할 수 있습니다. ````mastra build````로 빌드한 후 DigitalOcean App Platform, AWS ECS, Google Cloud Run 또는 Docker 호스트에서 출력을 실행하세요. Vercel과 Cloudflare Workers 배포기는 선택 사항입니다.

**Q: Mastra는 어떤 LLM 제공자를 지원하나요?**
Mastra는 Vercel AI SDK를 통해 40개 이상의 제공자를 지원합니다: OpenAI, Anthropic, Google, Mistral, Cohere, xAI, DeepSeek, Fireworks, Together 등. 제공자 전환은 코드 한 줄 변경으로 가능합니다.

**Q: Mastra는 프로덕션에서 오류와 재시도를 어떻게 처리하나요?**
Mastra 워크플로우는 단계 수준에서 지수 백오프를 포함한 구성 가능한 재시도 정책을 포함합니다. 에이전트에는 내장 타임아웃 처리가 있습니다. 관측 가능성 통합(OpenTelemetry)은 모든 호출을 추적하여 프로덕션에서 오류를 식별하고 디버깅하기 쉽게 만듭니다.

**Q: Mastra는 상업적 사용이 무인가요?**
네. Mastra는 Apache 2.0 라이선스로 상업적 사용이 무입니다. Mastra Cloud(관리 호스팅)는 유료 티어를 제공하지만 핵심 프레임워크는 완전히 오픈소스이며 무로 자체 호스팅할 수 있습니다.

**Q: 기존 Mastra 에이전트에 메모리를 어떻게 추가하나요?**
Mastra 인스턴스를 생성할 때 메모리 인스턴스를 전달하세요. 에이전트는 자동으로 사용자별 대화 스레드를 추적합니다. 다중 턴 대화를 위해 스토리지 백엔드(PostgreSQL, libSQL 또는 MongoDB)로 메모리를 초기화하면 에이전트가 나머지를 처리합니다.

## 결론

Mastra는 AI 프레임워크 환경에서 명확한 간극을 메웁니다 — JavaScript 개발자가 생태계를 떠나지 않고 에이전트를 구축할 수 있는 프로덕션급 TypeScript 네이티브 툴킷입니다. Observational Memory의 4-10배 Token 비용 절감은 마케팅 과장이 아닙니다. LongMemEval 벤치마크로 검증된 측정 가능한 프로덕션 이점입니다. 프레임워크의 DX 점수 9/10과 5분 미만의 설정 시간은 TypeScript 팀이 아이디어에서 배포된 에이전트까지 가는 가장 빠른 경로를 제공합니다.

Next.js 애플리케이션, Node.js 서비스, 또는 TypeScript 프로젝트에 AI 기능을 구축하고 있다면 Mastra는 진지한 평가를 받을 가치가 있습니다. ````npm create mastra@latest````로 시작하여 워크플로우를 구축하고 Token 비용 차이를 직접 측정해 보세요.

**실행 항목:**
1. Mastra 저장소를 클론하고 빠른 시작을 실행하세요: ````npm create mastra@latest```
2. [Mastra Discord 커뮤니티](https://discord.gg/mastra)에 가입하세요 (5,500+ 멤버)
3. [공식 문서](https://mastra.ai/docs)를 살펴 보세요
4. 업데이트를 위해 [Mastra GitHub 저장소](https://github.com/mastra-ai/mastra)를 팔로우하세요

*이 글의 일부 링크는 제휴 링크입니다. 추천 링크를 통해 DigitalOcean에 가입하면 추가 비용 없이 커미션을 받을 수 있으며, 이는 독립적인 기술 연구에 도움이 됩니다.*



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션: - **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- [Mastra 공식 웹사이트](https://mastra.ai)
- [Mastra GitHub 저장소](https://github.com/mastra-ai/mastra)
- [Mastra 공식 문서](https://mastra.ai/docs)
- [Mastra 코스 - AI 에이전트 구축 배우기](https://mastra.ai/course)
- [Mastra 튜토리얼: Firecrawl을 사용한 변경 로그 추적기](https://www.firecrawl.dev/blog/mastra-tutorial)
- [Mastra Observational Memory 심층 분석](https://agentmarketcap.ai/blog/2026/04/13/mastra-observational-memory-observer-reflector-pattern-agent-costs-longmemeval-2026)
- [ByteIota: Mastra TypeScript AI 프레임워크 분석](https://byteiota.com/mastra-typescript-ai-framework-cuts-token-costs-4-10x/)
- [Mastra vs LangChain 비교 - xpay](https://www.xpay.sh/resources/agentic-frameworks/compare/langchain-vs-mastra/)
- [CrewAI vs Mastra 비교 - respan.ai](https://respan.ai/market-map/compare/crewai-vs-mastra)
- [2026년 최고의 JavaScript/TypeScript Gen AI 프레임워크](https://xavidop.me/genkit/2026-04-16-top-jsts-genai-frameworks-2026/)
- [Mastra 워크숍: 나만의 코딩 에이전트 구축](https://github.com/mastra-ai/workshop-mastracode)
- [Mastra Observational Memory 워크숍](https://github.com/mastra-ai/mastra-observational-memory-workshop)
- [LangChain GitHub 저장소](https://github.com/langchain-ai/langchain)
- [CrewAI GitHub 저장소](https://github.com/crewAIInc/crewAI)
- [Vercel AI SDK 문서](https://sdk.vercel.ai/docs)


{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Mastra: 24K+ Stars — Token 비용을 4-10배 절감하는 TypeScript AI 프레임워크 2026",
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
    "@id": "https://dibi8.com/kr/resources/mastra"
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

**问：LangChain和LlamaIndex哪个更好？**

LangChain适合复杂工作流和Agent构建，LlamaIndex专注于RAG和数据检索优化。

**问：如何评估LLM框架的性能？**

基准测试包括：推理速度、准确率、资源消耗、可扩展性。

**问：开源LLM框架的商业使用限制？**

大多数采用MIT/Apache许可，可商业使用，但需保留版权信息。

**问：是否需要GPU才能运行LLM框架？**

推理需要GPU以获得最佳性能，但部分框架支持CPU模式（较慢）。

**问：企业级部署的最佳实践？**

使用Kubernetes容器化、API网关、监控告警、自动伸缩、以及灰度发布。

