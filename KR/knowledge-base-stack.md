---
title: '지식 베이스 스택 2026: AnythingLLM + RAGFlow + mem0로 "두 번째 뇌" 구축 ($10-25/월)'
description: '개인 또는 팀용 5컴포넌트 셀프호스트 지식 베이스 스택. AnythingLLM(UI + RAG) + RAGFlow(심층 문서 파싱) + mem0(에이전트 메모리) + AgentMemory MCP(MCP 노출) + 벡터 DB 픽. $50-200/월 SaaS(Notion AI + Mem + Glean)를 $10-25/월 셀프호스트로 대체.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Docker
  - Python
  - PostgreSQL
  - Redis
application_domain: Collections
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['collections']
tags: ['지식 베이스', 'RAG', '두 번째 뇌', '스택', '컬렉션']
aliases:
  - /posts/knowledge-base-stack/
---

PDF 500개, 노트 2,000개, 이메일 10년치가 있는데 에디터의 AI는 그 어떤 것도 존재함을 모릅니다. Notion AI는 시트당 $10/월이고 로컬 파일을 못 봅니다. Glean은 연 최소 $30k. Mem.ai는 좋지만 SaaS — 당신의 "두 번째 뇌"가 남의 하드웨어에 살아요.

이 컬렉션은 **5컴포넌트 셀프호스트 지식 베이스 스택**을 조립합니다. 모든 것(PDF, 노트, 웹 페이지, 코드) 흡수, 로컬 임베딩, chat + API로 쿼리, MCP로 AI 코딩 에이전트에 노출 — 총 **$10-25/월** 인프라 비용.

## TL;DR — 한눈에 보는 스택

| # | 컴포넌트 | 역할 | 이유 | 심층 가이드 |
|---|---|---|---|---|
| 1 | **AnythingLLM** | 올인원 RAG UI + 문서 관리 + chat 인터페이스 | "정문" — 당신과 팀이 실제로 클릭해 들어가는 곳 | [AnythingLLM 로컬 RAG 아키텍처](/kr/resources/llm-frameworks/anythingllm-architecture-local-rag/) |
| 2 | **RAGFlow** | 심층 문서 파싱(표, 공식, 다단 PDF) | AnythingLLM의 "충분히 좋은" 파싱이 멈춘 곳에서 RAGFlow가 어려운 문서 처리 | [RAGFlow 가이드](/kr/resources/llm-frameworks/ragflow/) |
| 3 | **mem0** | 에이전트용 영구 시맨틱 메모리 레이어 | 세션 간 장기 "사용자에 대한 이 사실 기억" | [mem0 셋업](/kr/resources/llm-frameworks/mem0/) |
| 4 | **AgentMemory MCP** | mem0를 임의의 MCP host(Claude Desktop, OpenCode, Cursor)에 노출 | 코딩 에이전트가 MCP 프로토콜로 지식 베이스 공유 | [AgentMemory MCP](/kr/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/) |
| 5 | **벡터 DB**(Chroma / Qdrant / Weaviate) | 임베딩 저장 + 유사도 검색 백엔드 | 픽은 다양 — [벡터 DB 비교](/kr/resources/llm-frameworks/vector-database-comparison/) 참조 | [벡터 DB 비교 2026](/kr/resources/llm-frameworks/vector-database-comparison/) |

**월 총 비용**(솔로, 문서 10 GB): **$10-15** • **작은 팀(10 GB, 5명)**: **$15-25** • **조직(100 GB, 50명)**: **$60-150**

SaaS 등가물과 비교: Notion AI + Mem + Glean Lite = 솔로-작은팀 커버에 $50-200/월.

## 1. 왜 2026에 지식 베이스를 셀프호스트할 때

세 가지가 수렴:

1. **로컬 임베딩 모델이 프로덕션 품질에 도달** — `nomic-embed-text`와 `bge-large`가 4GB VPS에서 동작, 200 doc/분 임베드, sub-100ms 검색. "임베딩 위해 OpenAI에 데이터 전송"은 더 이상 없음
2. **MCP가 에이전트-지식 베이스 통합 표준화** — 지식 베이스가 MCP를 말하면 모든 AI 코딩 에이전트(Claude Desktop, OpenCode, Cursor, Continue)가 커스텀 통합 코드 없이 쿼리 가능. 프로토콜 디테일은 [MCP 서버 레지스트리 가이드](/kr/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) 참조
3. **RAGFlow가 엔터프라이즈급 문서 파싱을 오픈소스로 출시** — 다단 PDF, 병합 셀 표, 공식 임베드. 모든 "DIY RAG" 스택이 실패한 그것, 이제 해결

세 개 스택 — 로컬 임베딩 + MCP 노출 + RAGFlow급 파싱 — "그냥 Notion AI 쓸게" 결정이 프라이버시 우려 또는 > 5 GB 소스 문서가 있는 사람에게 뒤집힘.

## 2. 아키텍처 개요

```
   ┌────────────────────────────────────────────────────┐
   │ VPS ($10-25/월)                                    │
   │                                                    │
   │  ┌────────────────────────────────────────────┐   │
   │  │ AnythingLLM (웹 UI)                        │   │
   │  │   ↕                                         │   │
   │  │   문서 → 임베딩 파이프라인                  │   │
   │  └────────────┬───────────────────────────────┘   │
   │               │                                    │
   │   "어려운 PDF"│  "쉬운 문서"                       │
   │       ↓       │       ↓                            │
   │  ┌─────────┐  │  ┌──────────────┐                  │
   │  │ RAGFlow │  │  │ (AnythingLLM │                  │
   │  │ 파서    │  │  │  내장)       │                  │
   │  └────┬────┘  │  └──────┬───────┘                  │
   │       └───────┴─────────┘                          │
   │               ↓                                    │
   │      ┌────────────────┐                            │
   │      │ 벡터 DB        │                            │
   │      │ (Chroma 로컬)  │                            │
   │      └────────┬───────┘                            │
   │               ↓                                    │
   │  ┌─────────────────────────────────┐               │
   │  │ 쿼리 라우팅                       │               │
   │  │   ├─► AnythingLLM chat UI       │               │
   │  │   ├─► mem0 (에이전트 메모리)     │               │
   │  │   └─► AgentMemory MCP server    │               │
   │  │         ↓                        │               │
   │  │    (Claude / Cursor / OpenCode)  │               │
   │  └─────────────────────────────────┘               │
   └────────────────────────────────────────────────────┘
```

분담: AnythingLLM은 사용자 정문, RAGFlow는 AnythingLLM 파서가 비틀거리는 문서 처리, 벡터 DB는 공유 검색 백엔드, mem0 + AgentMemory MCP는 같은 지식을 AI 코딩 에이전트에 노출.

## 3. 컴포넌트 1 — AnythingLLM (정문)

**역할**: 당신과 팀이 실제로 클릭해 들어가는 것. 문서 업로드, 워크스페이스 조직, 문서와 chat, 사용자 관리 — 모두 하나의 셀프호스트 앱.

**왜 이거**: 28k+ stars, 단일 Docker 컨테이너로 10분 배포, 오픈소스 RAG 도구 중 가장 다듬어진 웹 UI. chat 백엔드로 40+ LLM 프로바이더 지원(Ollama / DeepSeek / Claude / GPT-5 / OpenRouter)으로 비용 유연성 유지.

**빠른 설치**:
```bash
docker run -d --name anythingllm \
  -p 3001:3001 \
  -v anythingllm-storage:/app/server/storage \
  -e LLM_PROVIDER=ollama \
  -e EMBEDDING_ENGINE=native \
  mintplexlabs/anythingllm:latest
```

`http://your-vps:3001` 열기, 워크스페이스 생성, PDF 드래그. 내장 파서가 80% 문서 처리. 나머지 20%는 RAGFlow(다음 컴포넌트)로 라우팅.

**전체 셋업**(팀 인증, 워크스페이스 구조, LLM 프로바이더 라우팅): [AnythingLLM 로컬 RAG 아키텍처](/kr/resources/llm-frameworks/anythingllm-architecture-local-rag/).

## 4. 컴포넌트 2 — RAGFlow (심층 문서 파싱)

**역할**: AnythingLLM의 내장 파서가 특정 문서에 쓰레기를 출력할 때 — 다단 PDF, 스캔 논문, 복잡한 표, 공식 많은 학술 논문 — RAGFlow가 들어옴.

**왜 이거**: RAGFlow의 "DeepDoc" 파서가 각 페이지에 비전 모델 사용, 표 구조 보존(병합 셀, 중첩 행), 토큰 카운트 대신 시맨틱 블록으로 문서 청크. 결과는 어려운 문서에서 3-5× 더 정확한 검색.

**빠른 설치**:
```bash
docker compose -f https://github.com/infiniflow/ragflow/raw/main/docker/docker-compose.yml up -d
# 웹 UI :80, API :9380
```

**워크플로우 패턴**: AnythingLLM이 daily driver. 특정 doc 검색 품질 떨어지면 RAGFlow 통해 재처리, 파싱된 청크를 공유 벡터 DB에 저장.

**전체 RAGFlow 셋업**(DeepDoc 튜닝 + 파이프라인 통합): [RAGFlow 가이드](/kr/resources/llm-frameworks/ragflow/).

## 5. 컴포넌트 3 — mem0 (에이전트 메모리 레이어)

**역할**: chat 세션과 에이전트 간 살아남는 영구 시맨틱 메모리. "사용자가 Tailwind v4를 쓰고 auth는 `src/lib/auth.ts`에 있음을 기억" — mem0와 대화하는 어떤 에이전트든 다음 세션, 다음 달, 다음 해에 그 사실을 받음.

**왜 이거**: 30k+ stars. 특별히 에이전트 메모리용으로 구축(범용 벡터 DB 아님). 대화에서 사실 자동 추출, 중복 제거, 오래된 사실 자연 감쇠.

**빠른 설치**:
```bash
pip install mem0ai
# 또는 서비스로 실행:
docker run -d --name mem0 -p 8765:8765 \
  -e VECTOR_DB=chroma \
  mem0ai/mem0-server:latest
```

**사용 사례**: AnythingLLM 워크스페이스에 mem0를 writeback 레이어로 연결. 모든 chat 대화가 자동으로 mem0 사실로 증류. AI 코딩 에이전트(다음 컴포넌트)는 문서 코퍼스 AND 대화 추출 사실을 모두 사용 가능.

**전체 mem0 셋업**(임베딩 모델 픽 + 감쇠 정책 튜닝): [mem0 셋업 가이드](/kr/resources/llm-frameworks/mem0/).

## 6. 컴포넌트 4 — AgentMemory MCP (코딩 에이전트로의 다리)

**역할**: mem0(및 선택적으로 AnythingLLM 벡터 DB)를 임의의 MCP host에 노출 — Claude Desktop, OpenCode, Cursor, Continue, Hermes Agent. 지식 베이스가 이제 모든 현대 AI 코딩 에이전트가 이해하는 프로토콜 사용.

**중요한 이유**: MCP 없으면 커스텀 지식 베이스를 각 AI 코딩 도구와 통합하려면 도구별 커스텀 코드 필요. AgentMemory MCP로 `claude_desktop_config.json`에 한 번 추가하고 모든 MCP 인식 에이전트가 받음.

**빠른 설치**:
```bash
npm install -g @mem0/mem0-mcp
# OpenCode / Claude Desktop MCP config에 추가:
# { "agentmemory": { "command": "mem0-mcp", "env": { "MEM0_URL": "http://localhost:8765" } } }
```

**결과**: 코딩 에이전트가 이제 "프로젝트 문서와 과거 대화 기반으로 새 auth 흐름을 어떻게 구조화해야 할까?" 답할 수 있음 — PDF와 과거 결정 모두에서 인용.

**전체 셋업**(팀 간 AgentMemory MCP 공유 방법): [AgentMemory MCP 가이드](/kr/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/).

## 7. 컴포넌트 5 — 벡터 DB 픽

**역할**: AnythingLLM, RAGFlow, mem0 뒤의 공유 임베딩 저장 백엔드.

**3가지 가능한 픽**(전체 비교: [벡터 DB 비교 2026](/kr/resources/llm-frameworks/vector-database-comparison/)):

- **Chroma** — 솔로 / 작은 팀 최적. 단일 파일 SQLite같은 단순함. 임베드 모드 = 추가 서비스 0. AnythingLLM 기본
- **Qdrant** — 프로덕션 팀 최적. Rust 기반, sub-10ms 레이턴시, 수평 확장. Docker compose가 처리
- **Weaviate** — 하이브리드 검색(벡터 + 키워드) 필요할 때 최적. 운영 더 무겁지만 더 강력한 검색 모드

**기본 추천**: Chroma 시작(AnythingLLM 안에 이미 있음). 코퍼스 > 100 GB 또는 쿼리 레이턴시 > 200ms 시 Qdrant로 마이그레이션.

```bash
# Chroma 벗어날 때 Qdrant:
docker run -d --name qdrant -p 6333:6333 -p 6334:6334 \
  -v qdrant-storage:/qdrant/storage \
  qdrant/qdrant:latest
```

## 8. Day 1 셋업 순서 (90분)

1. **VPS 띄우기** (10분) — {{< aff "digitalocean" "kb-vps" "DigitalOcean $12/월 droplet" >}}(8 GB tier; 4 GB는 파싱 + 임베딩 + LLM에 빠듯) 주문, Docker 설치
2. **AnythingLLM 먼저** (15분) — 단일 docker run, :3001 브라우즈, 관리자 계정 + 첫 워크스페이스 생성
3. **테스트 문서 10개 업로드** (10분) — PDF, .md 노트, .docx 혼합 — AnythingLLM 내장 파서가 처리하는 거 확인
4. **RAGFlow 두 번째** (20분) — docker compose, :80 브라우즈, AnythingLLM이 비틀거린 2-3개 문서 재처리
5. **mem0 세 번째** (10분) — pip install + 서비스로 실행, AnythingLLM이 쓰는 Chroma 인스턴스 가리킴
6. **AgentMemory MCP 네 번째** (10분) — npm install, Claude Desktop / OpenCode config에 추가
7. **전체 파이프라인 테스트** (15분) — AnythingLLM에 문서 업로드 → chat → mem0가 사실 캡처 → Claude Desktop에서 MCP로 같은 질문 → 두 출처 인용

90분 후 $12/월 droplet에서 돌아가는 개인 Glean 등가물 보유.

## 9. 비용 분석

| 항목 | 솔로 (10 GB 문서) | 작은 팀 (10 GB, 5명) | 조직 (100 GB, 50명) |
|---|---|---|---|
| VPS | $12 (8 GB) | $24 (16 GB) | $120 (64 GB + 레플리카) |
| AnythingLLM | $0 (셀프호스트) | $0 | $0 |
| RAGFlow | $0 (셀프호스트) | $0 | $0 |
| mem0 / AgentMemory MCP | $0 (셀프호스트) | $0 | $0 |
| 벡터 DB (Chroma → Qdrant) | $0 | $0 | $0 (Qdrant 셀프호스트) |
| 임베딩 (로컬 Ollama bge-large) | $0 | $0 | $0 |
| Chat LLM (저렴은 DeepSeek, 어려운 건 Claude) | $0-5 | $0-10 | $20-30 |
| 백업 스토리지 | $1 | $2 | $20 |
| **합계** | **~$13-18/월** | **~$26-36/월** | **~$160-170/월** |

SaaS 등가물 비교:
- 솔로: Notion AI ($10) + Mem.ai ($15) = $25/월, 로컬 파일 못 봄
- 작은 팀: 동일 × 5명 = $125/월
- 조직: Glean Lite ~$30/명/월 × 50 = $1,500/월

## 10. 업그레이드 경로

이 스택 벗어날 때:

- **코퍼스 > 1 TB 또는 > 1000만 doc** — Qdrant를 전용 32 GB 박스로, 샤딩 추가
- **다지역 팀** — AnythingLLM 다지역 read 레플리카, 중국 친화 레이턴시 위해 {{< aff "htstack" "upgrade-hk-vps" "HTStack HK" >}}에 단일 write master
- **풀텍스트 + 벡터 하이브리드 필요** — 벡터 DB Chroma에서 Weaviate로 마이그레이션
- **감사 / SOC2 컴플라이언스** — LLM 콜 가시성용 Portkey와 페어 ([LLM Gateway 비교 2026](/kr/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/) 참조)
- **멀티테넌트 SaaS** — 고객별 가상 키용 LiteLLM 추가 ([LiteLLM 가이드](/kr/resources/llm-frameworks/litellm/))

## TL;DR — 레시피

**5 컴포넌트, 솔로-작은팀 $10-25/월**:
1. **AnythingLLM** — 정문 + chat UI
2. **RAGFlow** — 심층 문서 파서 (어려운 PDF)
3. **mem0** — 에이전트 메모리 레이어
4. **AgentMemory MCP** — 코딩 에이전트로의 다리
5. **벡터 DB** (Chroma → 규모에서 Qdrant)

$50-200/월 SaaS(Notion AI + Mem + Glean Lite)를 본인 소유 셀프호스트로 대체. 90분 셋업, MCP 네이티브이므로 모든 코딩 에이전트 혜택.

엔트리 tier로 {{< aff "digitalocean" "footer-cta" "DigitalOcean $12/월 droplet" >}} 띄우고 8절 따라가면 내일까지 Claude Desktop / Cursor / OpenCode에서 지식 베이스 쿼리 가능.

---

*동반 컬렉션: [셀프호스트 AI 코딩 워크플로우](/kr/collections/self-hosted-ai-coding-workflow/)는 이 지식 베이스를 코딩 에이전트 스택에 연결. [저렴한 LLM 스택](/kr/collections/cheap-llm-stack/)은 chat-LLM 비용 측 커버. [국경 간 AI 마케팅 스택](/kr/collections/cross-border-ai-marketing-stack/)은 중국 친화 호스팅 필요한 중국 팀용.*
