---
title: '셀프호스트 AI 코딩 워크플로우: 2026년 $6/월 완전 스택'
description: '7개 컴포넌트 셀프호스트 AI 코딩 스택 — $290/월 SaaS 구독(Cursor + Claude Code Pro + Copilot + Replit)을 $6/월 인프라로 대체. 실제 수치, 실제 config, 전체 단계별 조립 가이드.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Docker
  - Python
  - TypeScript
  - PostgreSQL
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
tags: ['셀프호스트', 'AI 코딩', '스택', '워크플로우', '컬렉션']
aliases:
  - /posts/self-hosted-ai-coding-workflow/
---

Cursor $20/월 + Claude Code Pro $80/월 + Copilot $19/월 + Replit credit $50/월 + OpenAI API 충전 $120/월 내고 있다면 AI 코딩 월 지출이 **$289/월**입니다. 12개월이면 **$3,468** — 소유하지도, 감사하지도 못하고, 예고 없이 rate-limit 되거나 끊길 수 있는 도구들에 들어가는 돈.

이 컬렉션은 **7컴포넌트 셀프호스트 대안**을 조립합니다. **$6/월 VPS** 위에서 돌며 SaaS 기능 세트의 90%+를 매칭합니다. 지난 90일간 각 컴포넌트의 심층 가이드를 게시했고, 이 페이지는 **완전한 스택 조립** — 무엇을 설치하고, 어떤 순서로, 어떤 config로, 그리고 $6 tier를 벗어날 때 업그레이드 경로까지.

## TL;DR — 한눈에 보는 스택

| # | 컴포넌트 | 도구 | 이유 | 심층 가이드 |
|---|---|---|---|---|
| 1 | 에디터 / Agent | **OpenCode** | Claude Code 오픈소스 대안, DeepSeek-V4를 작업당 $0.007에 ($0.14 대비) | [OpenCode 셋업](/kr/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/) |
| 2 | 로컬 LLM 러너 | **Ollama** | 137k star, 한 줄 설치, 5년 된 M1에서 22 tok/sec | [Ollama 가이드](/kr/resources/llm-frameworks/ollama/) |
| 3 | LLM 게이트웨이 | **LiteLLM** | 47.8k star, 100+ 모델 통합 API, 셀프호스트 | [LiteLLM 게이트웨이](/kr/resources/llm-frameworks/litellm/) |
| 4 | 토큰 절약 프록시 | **9Router** | RTK 압축으로 코딩 에이전트 토큰 20-40% 절감 | [9Router 셋업](/kr/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/) |
| 5 | 메모리 레이어 | **mem0 + AgentMemory MCP** | 세션 간 영구 시맨틱 회상 | [AgentMemory MCP](/kr/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/) |
| 6 | 코드 컨텍스트 MCP | **filesystem + git + tavily 검색** | Anthropic reference + 커뮤니티 + 검색 | [MCP server 레지스트리](/kr/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) |
| 7 | 멀티 CLI 스위처 | **CC Switch** | Claude / Codex / Gemini CLI / OpenCode 원클릭 전환 | [CC Switch 가이드](/kr/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/) |

**월 총 비용**(4GB VPS + 스토리지): 엔트리 tier **$6**. "5인 팀 tier" + Postgres + Redis + LiteLLM 다중 레플리카 시 **약 $30/월**.

## 1. 왜 이 스택이 2026년에야 가능해졌나

2024~2026 사이 셀프호스트 AI 코딩이 드디어 viable해진 세 가지:

1. **오픈 웨이트 모델이 따라잡음**: DeepSeek-V4, Qwen 3 Coder, GLM-4.6 Coder가 코딩 벤치마크에서 Claude/GPT-5와 5% 차이, 무료 또는 거의 무료
2. **MCP가 도구 통합 표준화**: 에디터마다 파일/git/검색 도구 호출법 재발명 안 함, 프로토콜이 USB-C 포트화 — 19,700+ server 가능 → [MCP server 레지스트리 가이드](/kr/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) 참조
3. **로컬 LLM 러너 프로덕션 등급**: Ollama, vLLM, llama.cpp가 소비자 하드웨어에서 수용 가능 속도

2024년에도 수학은 성립했지만 경험이 고통스러웠음. 2026년에 갭이 닫힘.

## 2. 아키텍처 개요

```
                  ┌─────────────────────────────┐
                  │   당신 머신 / VPS ($6)       │
                  │                             │
   타이핑  →      │  OpenCode (에디터/agent)    │
                  │           │                 │
                  │           ▼                 │
                  │  CC Switch (1-click CLI)    │
                  │           │                 │
                  │           ▼                 │
                  │  LiteLLM Gateway :4000      │
                  │           │                 │
                  │     ┌─────┴─────┐           │
                  │     │           │           │
                  │     ▼           ▼           │
                  │  9Router    직접           │
                  │  (RTK 압축)  (premium)     │
                  │     │           │           │
                  └─────┼───────────┼───────────┘
                        │           │
              ┌─────────┴───┐  ┌────┴──────┐
              ▼             ▼  ▼           ▼
          Ollama       DeepSeek API   Claude API
          (로컬)        (저렴)         (premium)

      MCP servers (filesystem + git + memory + tavily-search)
      claude_desktop_config.json 통해 OpenCode에 마운트
```

패턴: **OpenCode가 에디터 두뇌, LiteLLM이 교통 경찰, 9Router가 압축, MCP servers가 세계 노출.** 어떤 컴포넌트도 다른 거 안 건드리고 교체 가능.

## 3. 컴포넌트 1 — OpenCode (에디터 / Agent)

**역할**: 실제로 타이핑하는 것. Cursor + Claude Code Pro 대체.

**왜 이거**: MCP 네이티브 지원하는 오픈소스 에이전트. 동일 리팩토링 작업(400줄 React 컴포넌트)에서 OpenCode + DeepSeek-V4 = 18초 $0.007. Claude Code (Sonnet) = 12초 $0.14. 20배 저렴, 5% 느림.

**빠른 설치**:
```bash
npm install -g @opencode-ai/opencode
opencode --version  # 1.x
```

LiteLLM 게이트웨이(다음 컴포넌트) 가리키도록 config 설정, 끝.

**전체 셋업** (provider 라우팅 규칙, MCP server 연결, 에디터 통합) — [OpenCode 완전 가이드](/kr/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/) 참조.

## 4. 컴포넌트 2 — Ollama (로컬 LLM 러너)

**역할**: 본인 하드웨어에서 작은 모델 실행. 민감한 코드를 위한 100% 오프라인 옵션.

**왜 이거**: 137k star. 싱글 바이너리 설치. Llama 3.2 3B가 5년 된 M1 MacBook 8GB RAM에서 22 tok/sec. Qwen 3 Coder 14B는 16GB M 시리즈 Mac 또는 32GB Linux에서 편하게.

**빠른 설치**:
```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama pull qwen3-coder:14b
ollama serve  # :11434 OpenAI 호환 API 노출
```

LiteLLM이 Ollama를 provider로 자동 인식.

**전체 셋업** (하드웨어 tier별 모델 선택 + 양자화 트레이드오프) — [Ollama 프로덕션 가이드](/kr/resources/llm-frameworks/ollama/) 참조.

## 5. 컴포넌트 3 — LiteLLM (통합 게이트웨이)

**역할**: 모든 모델 앞에 OpenAI 호환 API 하나 — Ollama (로컬), DeepSeek (저렴), Claude (premium), Gemini (무료층). 에디터는 LiteLLM에만 말 걸고 LiteLLM이 config 따라 라우팅.

**왜 이거**: 47.8k star, LLM 게이트웨이 중 star 1위. 1k RPS에서 P95 8ms. 셀프호스트 무료. 상세 비교는 [Portkey vs LiteLLM vs OpenRouter 2026 가이드](/kr/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/) 참조.

**4GB VPS에 빠른 배포** (중국 본토 sub-30ms는 {{< aff "htstack" "stack-vps" "HTStack 홍콩 VPS" >}}, 그 외엔 {{< aff "digitalocean" "stack-droplet" "DigitalOcean $6 droplet" >}}):

```bash
docker run -d --name litellm -p 4000:4000 \
  -e LITELLM_MASTER_KEY=sk-your-secret \
  -e OLLAMA_API_BASE=http://host.docker.internal:11434 \
  -e DEEPSEEK_API_KEY=$DEEPSEEK_KEY \
  -e ANTHROPIC_API_KEY=$CLAUDE_KEY \
  ghcr.io/berriai/litellm:main-stable
```

**전체 셋업** (가상 키, 지출 추적, 페일오버 규칙) — [LiteLLM 프로덕션 게이트웨이 2026](/kr/resources/llm-frameworks/litellm/) 참조.

## 6. 컴포넌트 4 — 9Router (토큰 절약 프록시)

**역할**: LiteLLM과 "premium" provider (Claude / GPT-5) 사이에 위치. 반복 콘텐츠(파일 헤더, 시스템 프롬프트, 코드베이스 컨텍스트) 압축 후 전송. **코딩 에이전트의 청구 토큰 20-40% 절감.**

**왜 중요한가**: 코딩 에이전트는 병적인 토큰 소비자 — 매 턴 전체 코드베이스 컨텍스트 전송. Claude Sonnet 입력 $3/M token, 빠르게 쌓임. 9Router의 RTK(Repetition-Token Compression)는 이 워크로드 전용으로 설계된 유일한 프록시.

**빠른 설치**:
```bash
docker run -d --name 9router -p 9999:9999 \
  -e PROVIDERS=anthropic,openai,gemini,deepseek \
  ghcr.io/rtk-ai/9router:latest
```

LiteLLM의 premium provider 엔드포인트를 직접 대신 `localhost:9999`로 가리키게.

**전체 셋업**: [9Router 스마트 프록시 가이드](/kr/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/).

## 7. 컴포넌트 5 — 메모리 레이어 (mem0 + AgentMemory MCP)

**역할**: 코딩 세션 간 영구 시맨틱 메모리. "Tailwind v4 쓰고 auth는 `src/lib/auth.ts`에 있다는 거 기억해" — 다음 주 월요일에도 에이전트가 기억함.

**왜 이거**: mem0는 30k+ star의 오픈소스 시맨틱 메모리 레이어. AgentMemory는 그걸 임의의 MCP host(OpenCode / Claude Desktop / Cursor)에 노출하는 MCP server.

**빠른 설치**:
```bash
npm install -g @mem0/mem0-mcp
# OpenCode MCP config에 추가:
# { "agentmemory": { "command": "mem0-mcp", "args": [] } }
```

**전체 셋업** (임베딩 모델 선택 + 벡터 DB 고르기) — [AgentMemory MCP 가이드](/kr/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/) 참조.

## 8. 컴포넌트 6 — 코드 컨텍스트 MCP (filesystem + git + tavily 검색)

**역할**: 에이전트에 눈과 손 주기. 프로젝트 파일 읽기, git 히스토리 확인, 웹 검색 — 모두 MCP 프로토콜 경유.

**최소 세트**:
- `modelcontextprotocol/server-filesystem` (Anthropic reference)
- `modelcontextprotocol/server-git` (Anthropic reference)
- `tavily-mcp` (LLM 포맷된 웹 검색 결과)

**빠른 설치** (3개 모두 OpenCode `claude_desktop_config.json`에 추가):
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"]
    },
    "git": {
      "command": "uvx",
      "args": ["mcp-server-git", "--repository", "/home/user/projects/your-repo"]
    },
    "tavily": {
      "command": "npx",
      "args": ["-y", "@tavily/mcp"],
      "env": {"TAVILY_API_KEY": "tvly-xxx"}
    }
  }
}
```

Tavily는 월 1,000 검색 무료 tier로 $6 예산 안에 충분.

**19,700+ 사용 가능 MCP server 완전 메뉴 + 추가 선택법**: [MCP Server 레지스트리 완전 가이드 2026](/kr/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) 참조.

## 9. 컴포넌트 7 — CC Switch (멀티 CLI 오케스트레이션)

**역할**: 특정 작업에 Claude Code 네이티브로 쓰고 싶을 때 — 또는 Codex로 Rust 속도 점프 — CC Switch는 1-click 스왑. 싱글 config, 모든 AI CLI가 MCP servers 공유.

**왜 이거**: 75k star Rust + Tauri 데스크톱 앱, 5개 다른 CLI를 위해 5개 별도 `~/.claude_desktop_config.json` 유지 안 해도 됨.

**빠른 설치**: [farion1231/cc-switch releases](https://github.com/farion1231/cc-switch/releases)에서 다운로드, 각 CLI를 한 번 클릭으로 설정.

**전체 가이드**: [CC Switch 통합 AI CLI 컨트롤 센터](/kr/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/).

## 10. 조립 순서 — Day 1 셋업 (90분)

처음부터 시작한다면 이 순서로:

1. **인프라 띄우기** (15분) — {{< aff "digitalocean" "assembly-vps" "DigitalOcean $6 droplet" >}} 주문, Docker 설치, 포트 4000 (LiteLLM) + 9999 (9Router) + 11434 (Ollama) 열기
2. **Ollama 먼저** (10분) — 설치 + `qwen3-coder:14b` 풀 (~9 GB). `curl localhost:11434/api/tags` 동작 확인
3. **LiteLLM 두 번째** (15분) — 5절 env vars로 docker run. `curl localhost:4000/v1/models -H "Authorization: Bearer sk-your-secret"`로 Ollama 모델 나열 확인
4. **9Router 세 번째** (10분) — 옵션이지만 추천. LiteLLM premium provider config에 추가
5. **OpenCode 네 번째** (15분) — 로컬 설치, `https://your-vps:4000/v1` LiteLLM 가리킴, 기본 prompt 테스트
6. **MCP servers 다섯 번째** (15분) — filesystem + git + tavily를 OpenCode config에 추가. "이 repo의 파일 나열해" 물어 테스트
7. **mem0 + AgentMemory 여섯 번째** (10분) — `npm i -g mem0-mcp`, config에 추가, "Tailwind v4 쓴다는 거 기억해" 말하기
8. **CC Switch 마지막** (옵션) — 네이티브 Claude Code / Codex 병행 원할 때만

이제 $289/월 SaaS 번들의 90%를 매칭하는 $6/월 AI 코딩 스택 보유.

## 11. 월 비용 분석

| 항목 | 엔트리 tier | 5인 팀 tier |
|---|---|---|
| VPS (4 GB → 16 GB) | $6 | $24 |
| Ollama 모델 | $0 (디스크 본인 소유) | $0 |
| LiteLLM | $0 (셀프호스트) | $0 |
| 9Router | $0 (셀프호스트) | $0 |
| Tavily 검색 | $0 (1k req 무료) | $5 (유료) |
| mem0 / AgentMemory | $0 (셀프호스트) | $0 |
| DeepSeek API (하드 작업 저렴 추론) | ~$2-5 | ~$10-15 |
| Claude API (드물게 premium fallback) | ~$1-3 | ~$5-10 |
| **합계** | **~$6-14** | **~$30-50** |

Cursor + Claude Code Pro + Copilot + Replit + OpenAI 충전 $289/월과 비교.

## 12. 업그레이드 경로

$6 tier를 벗어날 때 (1명 이상 dev / 1개 이상 프로젝트 / 영구 상태 중요):

- **Postgres 추가** LiteLLM 지출 추적 + 프로젝트별 가상 키 ({{< aff "digitalocean" "upgrade-postgres" "DigitalOcean Managed Postgres" >}} $15/월)
- **Redis 추가** LiteLLM 캐싱용 (1 GB managed Redis $10/월)
- **LiteLLM을 LB + 3 레플리카 뒤로** — [Portkey vs LiteLLM 2026 가이드](/kr/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/) 4절의 Kubernetes 패턴 참조
- **Grafana + Loki 추가** 완전 가시성 — 모든 prompt, 모든 페일오버, 모든 비용 스파이크 로그
- **팀 레벨 RBAC 추가** LiteLLM 엔터프라이즈 tier 경유 (커스텀 가격)

요점: $6/월로 시작했고 **전체 스택을 본인이 소유**. 모든 업그레이드는 특정 필요에 묶인 의도적 비용 결정 — SaaS 락인 함정이 아님.

## TL;DR — 7컴포넌트 레시피

1. **OpenCode** — 에디터 두뇌
2. **Ollama** — 로컬 페일오버
3. **LiteLLM** — 통합 게이트웨이
4. **9Router** — 토큰 압축
5. **mem0 + AgentMemory** — 영구 메모리
6. **MCP servers** (filesystem + git + tavily) — 컨텍스트 + 도구
7. **CC Switch** — 멀티 CLI 오케스트레이션

총: $6/월. 총: 90분 조립. 총: 벤더 락인 0.

AI 코딩 SaaS에 $200+/월 쓰고 있다면 이 스택은 1주차에 본전. {{< aff "digitalocean" "footer-cta" "DigitalOcean $6 droplet" >}} 띄우고 10절 따라가서 다음 주에 결과 보고.

---

*이 페이지 북마크 — 새 오픈소스 릴리스 따라 분기별 컴포넌트 선택 업데이트. 마지막 업데이트: 2026-05-21.*
