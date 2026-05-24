---
title: 'CodeGraph 리뷰: Claude Code · Cursor · Codex의 토큰 비용을 35% 줄인 로컬 코드 그래프 (2026)'
description: 'CodeGraph (GitHub 20.2K+ stars)는 Claude Code, Cursor, Codex CLI, OpenCode, Hermes Agent를 위해 코드 지식 그래프를 사전 인덱싱하는 오픈소스 도구입니다. SQLite 로컬 저장, 19개 언어, 14개 framework 라우팅 인식, 외부 API 제로. 원시 grep/glob/Read 대비 약 35% 토큰 절감, 약 70% 도구 호출 감소. 기능 분석·설치·실전 워크플로·LSP/MCP 서비스 비교까지 정리.'
date: 2026-05-23 00:00:00+08:00
lastmod: 2026-05-23 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: 'v0.9.3'
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/colbymchenry/codegraph'
stars: 20200
maintainer: 'colbymchenry'
last_maintained: '2026-05-22'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['codegraph', 'claude-code', 'ai-coding-agent', 'code-graph', 'token-savings', 'mcp', 'hermes-agent', 'cursor', 'codex-cli', 'opencode', 'developer-productivity']
aliases:
- /kr/posts/codegraph-pre-indexed-knowledge-graph-2026/
---

## 문제: AI 코딩 에이전트가 `grep`에서 토큰을 태우고 있다

Claude Code, Cursor Pro 또는 OpenAI 경유 Codex CLI를 쓴다면 누구나 느꼈을 것이다. 에이전트가 코드베이스를 "이해"해야 할 때마다 Explore 단계가 시작된다: `Glob`로 파일 찾고, `Grep`로 심볼 찾고, `Read`로 컨텍스트 로딩. 모든 호출은 도구 왕복이고, 모든 왕복은 토큰이다 — 요청 페이로드와 컨텍스트로 돌아오는 응답 양쪽 다.

중간 규모 코드베이스(약 5만 라인)에서 `UserService`가 어디서 쓰이느냐는 질문 하나가 에이전트가 추론을 시작하기도 전에 8,000–15,000 토큰을 파일 스캔으로 태울 수 있다. 하루 분량의 편집을 곱하면 실제 청구서가 보인다.

근본 원인: **AI 에이전트는 코드베이스 형상에 대한 영구 기억이 없다**. 세션마다 호출 그래프를 다시 발견한다. 매번. 모든 세션.

[**CodeGraph**](https://github.com/colbymchenry/codegraph) (GitHub: `colbymchenry/codegraph`, **2026년 5월 기준 20,200+ stars**)는 이 문제를 정조준한 최초의 광범위 채택 오픈소스 시도다. 코드의 심볼, 호출 관계, framework 라우트, 파일 구조를 미리 인덱싱한 지식 그래프 — 밀리초 단위로 쿼리 가능하며 단일 MCP 서버 한 번 설정으로 Claude Code, Cursor, Codex CLI, OpenCode, Hermes Agent에 모두 연결된다.

공개 수치: **세션당 약 35% 비용 절감, 약 70% 도구 호출 감소, 100% 로컬, 외부 API 제로**.

---

## CodeGraph는 정확히 무엇인가

본질은 세 가지를 묶은 것이다:

1. **인덱서** — 레포를 워크하면서 지원 파일을 모두 파싱, 심볼(함수, 클래스, 타입, 익스포트)·호출 관계("함수 A가 함수 B를 호출")·framework 라우트("`/api/users`는 `UserController.list`에서 처리")를 추출. 전체를 로컬 SQLite DB에 저장.

2. **쿼리 CLI** — `codegraph query`, `codegraph callers`, `codegraph impact`. 밀리초 단위로 구조화 JSON 반환 — 토큰 비용·LLM 왕복 없음.

3. **자동 동기화 워처** — OS 네이티브 파일 워처(macOS `fsevents`, Linux `inotify`, Windows `ReadDirectoryChangesW`) 사용해 편집 중에도 그래프를 신선하게 유지. 백그라운드 daemon 폴링 없음, 오래된 데이터 없음.

전체가 약 92% TypeScript에 얇은 플랫폼 shim, MIT 라이선스. `v0.9.3`은 2026년 5월 22일 — 이 기사 작성 3일 전 — 출시.

### 지원 언어와 framework

- **19개 이상 프로그래밍 언어**: TypeScript, JavaScript, Python, Go, Rust, Java, C#, C++, Ruby, PHP, Swift, Kotlin, 그리고 여러 niche 언어.
- **14개 framework 라우터 인식**: Next.js, Nest.js, Express, FastAPI, Django, Flask, Rails, Spring Boot, Laravel 등 — 즉 "`POST /api/login`은 어디서 처리되나?"라고 물으면 CodeGraph는 단순히 `/api/login` 문자열이 나오는 위치가 아니라 실제 controller와 메서드를 답한다.

---

## 수치 뒤의 이야기

CodeGraph의 헤드라인 지표는 그래프 부착 유무에 따른 Claude Code 내부 benchmark에서 나온 것:

| 지표 | CodeGraph 없을 때 | 있을 때 |
|---|---|---|
| "X 이해" 평균 도구 호출 수 | ~22 | ~6.5 |
| 세션당 평균 토큰(중형 레포) | 11,400 | 7,400 |
| 심볼 조회 wall-clock 지연 | 4–9 초 | 50–200 ms |

wall-clock 개선이 더 흥미롭다. 비용을 신경 쓰지 않더라도 Explore 단계가 8초 대신 200ms로 끝나면 에이전트의 **느낌** 자체가 바뀐다 — 원격 API 대기가 아니라 로컬 도구처럼 느껴진다.

---

## 지원되는 AI 코딩 도구

CodeGraph는 MCP(Model Context Protocol)를 지원하는 도구는 MCP 서버로, 아직 미지원인 도구는 직접 CLI로 통합한다:

- **[Claude Code](https://dibi8.com/kr/vs/claude-code-vs-aider/)** — MCP 서버 등록. 한 번 설정하면 Claude Code의 Explore 에이전트가 원시 `grep`/`glob`보다 CodeGraph를 자동으로 선호한다.
- **[Cursor](https://dibi8.com/kr/vs/claude-code-vs-aider/)** — 동일하게 MCP 서버 패턴.
- **[Codex CLI](https://dibi8.com/kr/resources/llm-frameworks/openai-codex-cli-terminal-ai-coding-agent-2026/)** — 셸 alias 또는 wrapper 스크립트로 CLI 통합.
- **[OpenCode](https://dibi8.com/kr/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/)** — MCP 호환.
- **[Hermes Agent](https://dibi8.com/kr/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/)** — Hermes의 MCP 툴셋을 통한 네이티브 통합.

모든 경우 통합 방식은 대동소이하다: 레포를 한 번 인덱싱, CodeGraph MCP 서버(또는 alias)를 에이전트 설정에 추가하면 에이전트가 "심볼 단위 쿼리"를 일등 능력으로 갖춘다.

---

## 빠른 설치

CodeGraph는 세 가지 설치 경로를 제공한다. 스택에 맞는 것을 골라라:

```bash
# macOS / Linux 공식 설치 스크립트
curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh

# Windows PowerShell
irm https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.ps1 | iex

# 또는 npm (크로스 플랫폼, 설치 없이)
npx @colbymchenry/codegraph
```

설치 후 레포 루트에서:

```bash
# 최초 인덱싱 — 일회성, 5만 라인 레포 약 10초
codegraph init -i

# 심볼 쿼리 — UserService 및 관련 항목 모두 찾기
codegraph query UserService

# 역추적 — loginFunction을 누가 호출?
codegraph callers loginFunction

# 영향 분석 — 이것을 바꾸면 무엇이 망가지나?
codegraph impact src/auth/session.ts
```

워처는 백그라운드에서 시작해 편집 중에도 동기화를 유지한다. 돌볼 daemon이 없다.

---

## Claude Code에 연결

가장 흔한 워크플로. `~/.claude/mcp_servers.json`에:

```json
{
  "mcpServers": {
    "codegraph": {
      "command": "codegraph",
      "args": ["mcp"],
      "env": {}
    }
  }
}
```

이걸로 끝. Claude Code 재시작 후 "`AuthMiddleware`를 사용하는 모든 위치 찾기"를 묻자마자 Claude는 `grep` 12회 펼치는 대신 CodeGraph를 친다.

---

## 비교

CodeGraph가 경쟁하는 기존 접근법 3가지:

### 원시 `grep`/`glob`/`Read`와 비교
Claude Code / Cursor 기본 동작이다. 설치 비용 제로지만 세션마다 다시 스캔. 한 번 인덱싱하면 비용·지연 모두 CodeGraph가 압도적이다.

### Language Server (LSP)와 비교
LSP(TypeScript Server, gopls, rust-analyzer)도 유사한 심볼 지능을 제공한다. 차이점:
- LSP는 언어별; CodeGraph는 단일 바이너리 polyglot.
- LSP는 에디터 통합용 설계, headless 에이전트 쿼리용 아님 — CLI 에이전트에서 호출하기 어색.
- CodeGraph는 그래프 저장; LSP는 매번 재계산.

에이전트 워크플로엔 CodeGraph 사전 인덱싱 모델이 더 적합. 인터랙티브 편집은 여전히 LSP가 최강.

### Sourcegraph, Continue 같은 MCP 서비스와 비교
Sourcegraph와 Continue도 코드 지능 MCP 서버를 제공하지만 클라우드 기반이며 전체 서비스 셀프 호스팅 또는 호스팅 플랜 결제가 필요하다. CodeGraph는 단일 바이너리, 완전 로컬, 자격 증명 제로. 독립 개발자와 소규모 팀에는 훨씬 가벼운 약속이다.

---

## CodeGraph가 못하는 것

기대치를 맞추기 위해:

- **의미 검색 없음** — 임베딩 기반이 아니라 구조 기반. "개념적으로 X를 하는 코드 찾기"는 그의 일이 아니다. 필요하면 벡터 스토어(`agentmemory` 또는 로컬 Qdrant)와 함께 써라.
- **멀티 레포 join 없음** — 한 번에 한 레포 인덱싱. polyrepo monorepo는 별도 인덱싱 필요.
- **매크로/제네릭 해석 제한적** — Rust trait dispatch, C++ template, TS conditional types는 부분 해석. 가끔 "확정 답" 대신 "참고용"이 나온다.
- **git 히스토리 없음** — `codegraph`는 현재 트리에 관한 것, "이 함수 언제 바뀌었나"는 아니다. 그건 `git log`나 [Sourcegraph](https://about.sourcegraph.com)에서.

---

## 누가 써야 하나

**그렇다, 설치하라, 만약 당신이:**
- 2만 라인 넘는 코드베이스에서 일하며 Claude Code, Cursor, 또는 MCP 인식 코딩 에이전트를 매일 쓴다.
- 유용한 출력 전에 세션이 $1–$2 이상 토큰을 태우는 걸 봤다.
- 에이전트 컨텍스트와 무관하게 터미널에서 sub-second 심볼 조회를 원한다.

**건너뛰어도, 만약 당신이:**
- 주로 단일 스크립트나 노트북을 쓴다.
- IDE 내장 LSP로 만족하고 AI 에이전트를 안 쓴다.
- 멀티 레포 지능이 주요 요구사항이다.

---

## 결론

CodeGraph는 2026년에 보기 드물게 명확한 문제 정의와 검증 가능한 수치를 들고 나온 개발자 도구다. 35% 토큰 절감은 보수적인 추정 — 고반복 Explore 워크플로에서 초기 인덱스 워밍업 후 Claude Code가 50%+ 절감을 달성하는 것을 봤다. 지연 개선(**정성적** 이득)과 결합되면, Claude Code 워크플로에 더할 수 있는 "첫 세션에 본전 뽑는" 몇 안 되는 무료 추가물이다.

MIT 라이선스, 로컬 우선 아키텍처, 제로 외부 의존성 — 코딩 에이전트를 스케일로 돌리는 누구에게나 no-brainer다. 2026년 상반기 20,200 stars 성장이 그것을 반영하며, `v0.9.3` 릴리스 케이던스는 `v1.0`이 머지않았음을 시사한다.

[CC Switch 같은 통합 AI CLI 컨트롤 센터](https://dibi8.com/kr/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/)와 [rtk 같은 비용 인식 프록시](https://dibi8.com/kr/resources/llm-frameworks/rtk-rust-cli-proxy-llm-token-savings-2026/)와 함께 쓰면, 진정으로 자기 예산을 통제하는 2026년 AI 코딩 스택을 조립한 셈이다.

---

**GitHub**: [colbymchenry/codegraph](https://github.com/colbymchenry/codegraph) · **라이선스**: MIT · **최신**: v0.9.3 (2026-05-22) · **Stars**: 20.2K+
