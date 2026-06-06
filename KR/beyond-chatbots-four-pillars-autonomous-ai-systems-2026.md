---
title: "챗봇을 넘어: 2026년 자율 AI 시스템의 4가지 기둥"
description: "로컬 딥 리서치, InsForge, 에이전트 스킬스, 그리고 카프티 원칙이 심층 연구부터 프로덕션 배포까지 진정한 자율 AI 에이전트를 위한 완전한 스택을 어떻게 형성하는지 알아봅니다."
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
- /kr/posts/beyond-chatbots-four-pillars-autonomous-ai-systems-2026/
faqs:
  - q: 'Local Deep Research란 무엇이며 정확도는 얼마나 되나요?'
    a: 'Local Deep Research는 LearningCircuit가 개발한 오픈소스 AI 연구 도구로, arXiv, PubMed, Semantic Scholar, SearXNG, Tavily, Brave Search 같은 소스 전반에 걸쳐 반복적인 연구 루프를 실행합니다. SimpleQA 벤치마크에서 약 95%의 정확도를 보고하며, 데이터는 사용자별로 분리된 SQLCipher 암호화 SQLite 데이터베이스(AES-256)에 저장되고 텔레메트리는 전혀 없습니다.'
  - q: 'InsForge는 무엇에 사용되나요?'
    a: 'InsForge는 agentic coding을 위해 만들어진 올인원 오픈소스 백엔드 플랫폼으로, 인증, PostgREST 자동 API 생성을 갖춘 PostgreSQL 데이터베이스, S3 호환 스토리지, edge functions, 모델 게이트웨이, 사이트 배포를 제공합니다. MCP server와 CLI 및 skills를 모두 노출하여 AI 에이전트가 자체 백엔드를 처음부터 끝까지 프로비저닝하고 배포할 수 있게 합니다. Apache 2.0 라이선스로 배포됩니다.'
  - q: 'Addy Osmani의 Agent Skills에 있는 일곱 개의 슬래시 명령어는 무엇인가요?'
    a: 'Agent Skills는 일곱 개의 명령어를 개발 라이프사이클에 매핑합니다: /spec(요구사항 정의), /plan(원자적 작업으로 분할), /build(점진적 전달), /test(증거로서의 테스트), /review(코드 건강성 개선), /code-simplify(영리함보다 명료함), /ship(점진적 배포). Skills는 작업 컨텍스트에 따라 자동으로 활성화됩니다.'
  - q: 'AI 코딩을 위한 Karpathy에서 영감을 받은 네 가지 행동 원칙은 무엇인가요?'
    a: 'CLAUDE.md 파일에 내장된 네 가지 원칙은 다음과 같습니다: 코딩 전에 생각하기(가정을 명시하고 단정하기 전에 묻기), 단순함 우선(최소 실행 가능 솔루션 구축), 외과적 변경(꼭 필요한 것만 건드리고 기존 스타일에 맞추기), 목표 주도 실행(성공 기준을 사전에 정의). 이들은 LLM의 과신에 대한 인지적 안전장치 역할을 합니다.'
  - q: '자율 AI 시스템의 네 가지 기둥은 어떻게 함께 작동하나요?'
    a: '에이전트는 먼저 Local Deep Research를 사용해 검증되고 인용이 포함된 보고서를 생성하고, 그다음 MCP tool calls를 통해 InsForge로 전체 백엔드(데이터베이스, edge functions, 스토리지, 인증)를 프로비저닝하며, Agent Skills의 spec-to-ship 워크플로를 따라 프런트엔드를 구축하고, 그 전 과정에 걸쳐 Karpathy에서 영감을 받은 행동 가드레일을 적용하여 과도한 엔지니어링과 잘못된 가정을 방지합니다. 각 기둥은 자율 개발에서 발생하는 고유한 실패 모드를 다룹니다.'
---
{</* resource-info */>}

## The Evolution: From Chatbot to Autonomous System

우리는 중요한 전환점에 서 있습니다. In 2024, we celebrated chatbots that could answer questions. In 2025, we marveled at agents that could browse the web. Now in mid-2026, something fundamentally different has emerged: **자율 AI 시스템 that combine 심층 연구, 인프라 구성, 코드 생성, and 품질 보증 into a 단일 통합 워크플로우.**

This isn't 점진적 개선. It's 아키텍처 진화. And four open-source projects reveal the pattern.

## Pillar 1: Deep Research — The Intelligence Layer

### [Local Deep Research](https://github.com/LearningCircuit/local-deep-research) by LearningCircuit

대부분의 AI 도구는 답변만 제공합니다. Local Deep Research gives you *verified knowledge*.

독보적인 이유는 다음과 같습니다:

- **20+ 연구 전략** including a LangGraph agent mode that autonomously decides which search engine to use, when to dig deeper, and when to synthesize
- **~95% SimpleQA 벤치마크 정확도** — 상용 시스템과 경쟁력 있는 수준
- **프라이버시 우선 아키텍처**: SQLCipher-암호화된 SQLite 데이터베이스 (AES-256), 텔레메트리, 분석, 추적 없음
- **다중 소스 인텔리전스**: arXiv, PubMed, Semantic Scholar, SearXNG, Tavily, Brave Search — 각 소스가 색인되고 교차 참조됨
- **무지식 암호화**: User data isolated per-database, 서버 관리자도 내용을 읽을 수 없음

The architecture is instructive:

```
User Query -> Strategy Selector -> Question Generator 
    -> Parallel Search (academic + web + documents) 
    -> Analysis Loop -> Report Synthesis -> Multi-format Export
```

What's novel is the **iterative research loop**. Instead of one-shot query-response, the system generates sub-questions, searches across diverse sources, analyzes results, and iterates until confidence thresholds are met. This mimics how human experts actually do research: hypothesize, investigate, evaluate, refine.

The security model deserves special mention. Every user gets an isolated SQLCipher database. The encryption uses Signal-level AES-256 security. No password recovery means true zero-knowledge. Docker images are signed with Cosign and include SLSA provenance attestations. For developers who care about supply chain security, this is 엔터프라이즈급 보안.

## Pillar 2: Infrastructure — The Platform Layer

### [InsForge](https://github.com/InsForge/InsForge) by InsForge

An AI agent that can research deeply still needs somewhere to deploy its work. Enter InsForge: 에이전트 코딩을 위해 특별히 설계된 올인원 오픈소스 백엔드 플랫폼.

Think of it as Firebase meets Vercel meets Render — but built for AI agents to operate directly.

Core capabilities:

- **Authentication**: Email/password + OAuth (Google, GitHub) with session management
- **Database**: PostgreSQL with PostgREST auto-API generation
- **Storage**: S3-compatible file storage for documents, media, assets
- **Edge Functions**: Serverless code deployment with automatic scaling
- **Model Gateway**: OpenAI-compatible API routing across multiple LLM providers
- **Compute**: Long-running container services (private preview)
- **Site Deployment**: Full site build and deployment pipeline

The key innovation is **이중 인터페이스 지원**:

1. **MCP 서버** — Self-hostable interface exposing InsForge operations as standardized tools that any MCP-compatible agent (Claude Code, Cursor, Gemini CLI) can call
2. **CLI + Skills** — Cloud-native command-line interface paired with executable skill definitions

This means an AI agent doesn't just generate code — it can provision its own database schema, configure authentication, deploy edge functions, set up storage buckets, and even route its own API calls through the model gateway. End-to-end autonomy.

The SDK is elegantly simple:

```javascript
import { createClient } from '@insforge/sdk';

const client = createClient({
  baseUrl: 'https://your-app.region.insforge.app',
  anonKey: 'your-anon-key-here'
});
```

Everything from database CRUD to auth flows to AI operations is available through this unified client. For a coding agent, this reduces what would normally require a DevOps engineer to a single API call.

Vercel supports this project through their OSS program, indicating strong industry validation. Licensed under Apache 2.0.

## Pillar 3: Engineering Discipline — The Quality Layer

### [Agent Skills](https://github.com/addyosmani/agent-skills) by Addy Osmani

규율 없는 순수 능력은 지저분하고 유지보수 불가능한 코드를 낳습니다. This is where Addy Osmani's Agent Skills come in — production-grade engineering workflows packaged so AI agents follow senior-engineer standards consistently.

The core insight: **스킬은 시니어 엔지니어가 개발 전 과정에서 사용하는 의사결정 패턴을 인코딩합니다**. Not specific code — the *judgment* behind when and why to make certain decisions.

The seven-slash-command framework maps to the complete development lifecycle:

||Command|Phase|Principle||
||---------|-------|-----------||
||`/spec`|Define|Spec before code — requirements first||
||`/plan`|Plan|Small, atomic tasks — break down complexity||
||`/build`|Build|One slice at a time — incremental delivery||
||`/test`|Verify|Tests are proof — not decoration||
||`/review`|Review|Improve code health — continuous refinement||
||`/code-simplify`|Simplify|Clarity over cleverness — readability wins||
||`/ship`|Ship|Faster is safer — ship incrementally||

But the real magic is **context-aware auto-discovery**. When designing an API, the `api-and-interface-design` skill activates automatically. Building UI? `frontend-ui-engineering` triggers. The agent understands its task and loads the appropriate expertise.

This transforms AI coding from "write code that happens to work" to "follow proven engineering workflows that produce maintainable results."

## Pillar 4: Behavioral Guardrails — The Wisdom Layer

### [Karpathy-Inspired Skills](https://github.com/forrestchang/andrej-karpathy-skills)

기반 행동에 결함이 있으면 최고의 엔지니어링 프레임워크도 실패합니다. Andrej Karpathy identified LLM 코딩 실패의 패턴:

> "The models make wrong assumptions on your behalf and just run along with them without checking. They don't manage their confusion, don't seek clarifications, don't surface inconsistencies, don't present tradeoffs, don't push back when they should."

This project distills Karpathy's observations into four behavioral principles embedded in a `CLAUDE.md` file:

**1. Think Before Coding** — State assumptions explicitly. Present multiple interpretations. Push back when simpler approaches exist. Stop when confused. Ask before assuming.

**2. Simplicity First** — Minimum viable solution. No speculative features. No abstractions for single-use code. If 200 lines could be 50, rewrite it. The test: "Would a senior engineer say this is overcomplicated?"

**3. Surgical Changes** — Touch only what you must. Don't refactor things that aren't broken. Match existing style. Remove only the dead code YOUR changes created — never pre-existing orphan code unless asked.

**4. Goal-Driven Execution** — Define success criteria upfront. Transform "add validation" into "write tests for invalid inputs, then make them pass." Strong criteria enable independent looping; weak criteria require constant clarification.

These aren't technical solutions — they're 인지적 안전장치. They address the LLM의 근본적 약점: 능력을 가장한 과도한 자신감.

## How These Four Layers Work Together

The breakthrough moment comes when you connect all four pillars into a single workflow:

1. **Research** (Local Deep Research): An agent receives a complex query — "Build a trading dashboard for prediction markets." It conducts 심층 연구 across financial APIs, market structures, and UI patterns, producing a verified report with citations.

2. **Platform** (InsForge): The agent provisions the entire backend — PostgreSQL for market data, edge functions for real-time updates, storage for historical charts, auth for user accounts, model gateway for analysis APIs. All via MCP tool calls.

3. **Engineering** (Agent Skills): The agent builds the frontend following the `/spec → /plan → /build → /test → /review → /ship` workflow. Context-aware skills activate as needed — `frontend-ui-engineering` for the dashboard, `data-visualization` for charting, `api-integration` for real-time websockets.

4. **Wisdom** (Karpathy Skills): Throughout this process, the behavioral guardrails prevent classic LLM mistakes — no overengineered abstractions, no touching unrelated code, explicit assumption-stating before every architectural decision, verifiable success criteria instead of vague "make it work" targets.

The result? An agent that doesn't just "write code" but operates with the judgment, discipline, and verification standards of a senior full-stack team.

## Why This Matters for Developers

Three years ago, the question was "Can AI write code?" Today, it's "Can AI build production systems end-to-end?"

The answer is becoming clear: **not yet fully autonomously, but dangerously close.**

Each pillar addresses a specific failure mode:
- Without 심층 연구 → agents build on outdated or incorrect information
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

You don't need to adopt all four simultaneously. Start with what addresses your biggest gap. But once you experience the synergy — research informing architecture, architecture guiding implementation, implementation disciplined by skills, all guided by wisdom — it's hard to go back to doing it alone.

The future of software development isn't humans replacing AI or AI replacing humans. It's humans orchestrating AI systems that combine deep intelligence, robust infrastructure, engineering discipline, and practical wisdom. And those systems are already here.

---

## 추천 도구

오픈소스 AI 도구 개발/배포 시 권장:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전, AI 워크로드용 원클릭 droplet.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

## 추천 도구

**안정적인 Claude / OpenAI API 액세스가 필요?** 이 분야 프로젝트는 결국 Anthropic / OpenAI 레이트 리밋이나 가격 벽에 부딪힙니다.

- **{{< aff "shiyunapi" "llm-footer" "Shiyunapi" >}}** — Claude / OpenAI / DeepSeek API 프록시. 키 하나로 여러 최상위 모델 액세스, 공식 가격의 ~30%; 에이전트 프롬프트 이터레이션이나 직접 API 액세스 제한 지역에서 특히 유용.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영에 도움이 됩니다.*

