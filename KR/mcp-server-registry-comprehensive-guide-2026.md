---
title: 'MCP Server 레지스트리 가이드 2026: 19,700+ 서버, 7개 공식 픽, 60초 안에 맞는 거 찾는 법'
description: '2026년 MCP server 발견 완전 가이드. Anthropic 7개 reference 서버, 87.3k star awesome list, Smithery vs mcp.so 레지스트리 비교, 카테고리별 top 서버, 그리고 선택 결정 트리 — MCP가 뭔지가 아니라 당신의 MCP host에 꽂을 수 있는 게 뭔지에 대한 가이드.'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack:
  - TypeScript
  - Python
  - Docker
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/modelcontextprotocol/servers'
stars: 86000
maintainer: 'dibi8'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['MCP', 'Model Context Protocol', '레지스트리', 'Hub 글']
aliases:
  - /posts/mcp-server-registry-comprehensive-guide-2026/
---

2026년 1월, 공개된 모든 MCP server를 GitHub README 하나에 다 담을 수 있었습니다. 2026년 5월, [mcp.so](https://mcp.so)는 **19,700+** 개를 나열합니다. 병목은 더 이상 "어떻게 하나 만들지"가 아닙니다 — "19,700개 중 뭘 실제로 꽂을지"입니다.

이 가이드는 정확히 그 질문에 답합니다. **MCP가 뭔지는 다시 설명하지 않습니다** (그건 [MCP 심층 가이드 2026](/kr/resources/llm-frameworks/mcp-deep-dive-definitive-2026-guide/)에서 읽으세요). 이 글은 **server 생태계 지도**입니다 — Anthropic 7개 reference, 87.3k star 커뮤니티 리스트, 두 레지스트리 플랫폼, 그리고 30초 안에 쓰는 발견 결정 트리.

## 1. 왜 MCP server 수가 6개월 만에 100배 폭증했나

세 가지가 복합:

1. **크로스 플랫폼 채택**: 2026년 초까지 Anthropic, OpenAI, Google DeepMind 모두 MCP 지원. 한 번 작성한 server가 Claude Desktop, ChatGPT, Gemini에서 다 됨
2. **툴링 성숙**: TypeScript, Python, Go, Rust, Swift SDK — server 만드는 건 50줄 오후 프로젝트
3. **2026 로드맵 착륙**: 트랜스포트 확장성(server가 세션 상태 안 들고 수평 확장 가능), 엔터프라이즈 인증(SSO/감사 트레일), MCP Apps(SEP-1865 UI 확장)로 프로덕션 레디

결과: 1월 500+ 공개 server, 3월 ~5,000, 5월 19,700+. **대부분 신호이고 노이즈 아님** — 하지만 지도가 필요.

## 2. 30초 발견 결정 트리

| 원하는 것 | 첫 번째 정거장 |
|---|---|
| 검증된 기본 (filesystem, fetch, git) 사용 | **Anthropic reference 서버** (3절) |
| 카테고리별 탐색 (DB, 브라우저, 클라우드) | **awesome-mcp-servers** (4절) |
| Config 안 건드리고 server 설치/관리 | **Smithery** 레지스트리 (5절) |
| 가장 큰 카탈로그 탐색 | **mcp.so** (19,700+) (5절) |
| 컴플라이언스로 셀프호스트 | OSS server 픽 + 7절 |
| 직접 만들기 | [MCP 심층 가이드](/kr/resources/llm-frameworks/mcp-deep-dive-definitive-2026-guide/) |

이후 각 절이 한 줄씩 펼침.

## 3. Anthropic 7개 Reference Server — 베이스라인

공식 [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers) 저장소(GitHub 86k star)는 7개 reference 구현을 유지합니다. Anthropic 내부에서 쓰는 + 프로토콜의 "해피 패스" 도장이 찍힌 server들:

| Server | 하는 일 | 전형적 사용 |
|---|---|---|
| **Everything** | 모든 MCP primitive(tool/resource/prompt) 노출하는 데모 server | 프로토콜 작성자의 reference 읽기 |
| **Fetch** | HTTP/HTTPS 페처 + html→markdown 변환 | LLM이 임의 URL 요청 시 읽음 |
| **Filesystem** | 샌드박스된 로컬 FS 읽기/쓰기/목록 | 프로젝트 디렉토리에서 일하는 코딩 에이전트 |
| **Git** | Git 저장소 introspection (log/diff/blame/branch) | 코드 인식 AI 어시스턴트 |
| **Memory** | 임베딩 검색 가능한 영구 KV 메모리 | 회상 필요한 장기 에이전트 |
| **Sequential Thinking** | 다단계 추론 스캐폴드 (chain-of-thought를 도구로) | 복잡한 계획 작업 |
| **Time** | 타임존 인식 날짜/시간 연산 | 스케줄링 에이전트, 캘린더 봇 |

은퇴한 reference 두 개:

- **Brave Search** — Brave 본인이 관리하는 [brave/brave-search-mcp-server](https://github.com/brave/brave-search-mcp-server)로 이전
- **Slack** — 이제 Zencoder 커뮤니티 관리

오늘 시작한다면 **Filesystem + Fetch + Memory** 포함 config 복사 — 그게 "자율 코딩 에이전트 최소 유용 세트".

## 4. awesome-mcp-servers — 87.3k Star 커뮤니티 색인

[punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers)는 사실상 커뮤니티 카탈로그: **87.3k star, 10.5k fork, 1.6k PR**. 서버는 ~40 카테고리로 그룹화. 2026 AI 개발 워크플로우에서 가장 중요한 카테고리:

- **Aggregators** — 여러 MCP server를 한 엔드포인트 뒤에 묶음 (`1mcp/agent`, `a2asearch-mcp`)
- **Browser Automation** — `playwright-mcp`, `browsermcp/mcp`, `real-browser-mcp`
- **Cloud Platforms** — `terraform-mcp-server`, `aws-mcp-server`, `k8s-mcp-server`, `localstack-mcp-server`
- **Code Execution** — `e2b-sandbox-mcp` (클라우드 샌드박스), `piston-mcp` (멀티랭 러너), `pydantic-ai/mcp-run-python`
- **Coding Agents** — `codemcp`, `claude-concilium`, `any-cli-mcp-server`
- **Databases** — Postgres, MySQL, MongoDB, Redis, SQLite, ClickHouse, Snowflake 커넥터 모두 OSS MCP server 있음
- **Communication** — Slack (Zencoder), Discord, Teams, Telegram, 이메일 (IMAP/SMTP)
- **Knowledge & Memory** — `mem0-mcp`, `letta-mcp`, 벡터 DB 통합 (Pinecone, Weaviate, Chroma)
- **Search** — `brave-search-mcp-server`, `tavily-mcp`, `exa-mcp`, `perplexity-mcp`

**사용법**: 순차 탐색 금지. 문제 영역 Ctrl-F ("postgres", "kubernetes", "stripe"), 상위 2-3개 픽, star 카운트와 마지막 커밋 일자 확인. **리스트는 star 정렬 아니고 유지자 판단** — 직접 검증.

## 5. Smithery vs mcp.so — 두 레지스트리 플랫폼

awesome-list가 2026년 1월 500개 server를 넘기자, "JSON config 복사 붙여넣기 안 하고 설치하고 싶다"는 통증을 해결하려 두 레지스트리 플랫폼이 등장.

### Smithery ([smithery.ai](https://smithery.ai))

- **모델**: 레지스트리 + 호스팅 런타임 + CLI 설치기
- **server 수**: ~5,000 (큐레이션, mcp.so보다 작지만 품질 기준 높음)
- **가격**: 리스트 무료, 탐색 무료, 설치 무료. 호스팅 server는 사용량 기반 가격일 수 있음
- **킬러 기능**: `npx -y @smithery/cli@latest install <server>`로 Claude Desktop / Cursor / Continue config에 추가 — 수동 JSON 편집 불필요
- **단점**: 아직 크리에이터 수익화 없음 — 개발자가 인기 server로 돈 못 받음

### mcp.so

- **모델**: 순수 레지스트리/디렉토리 (최대 카탈로그)
- **server 수**: **19,700+** (포괄적 — 질보다 양)
- **가격**: 무료 디렉토리
- **킬러 기능**: 단연 최대 카탈로그; 존재하면 여기 있음
- **단점**: 큐레이션 품질 낮음; 각 항목을 직접 평가 필요

### 어떤 걸 쓸까

- **CLI 설치 + 큐레이션 원함**: Smithery
- **롱테일 원함**: mcp.so
- **프로덕션 배포**: 항상 설치 전 GitHub 소스 읽기 — 두 레지스트리 모두 원본 레포로 링크 — 유지자 활동성 + open issue + 라이선스 직접 확인

## 6. 카테고리별 Top MCP Server (2026년 5월)

커뮤니티 star 카운트, 통합 커버리지, 최근 커밋 활동 기준:

**Filesystem & Code**
- `modelcontextprotocol/server-filesystem` (공식) — 샌드박스 FS
- `cyanheads/git-mcp-server` — 공식 Git server 범위 넘는 Git 작업
- `tools-mcp/codemap-mcp` — 시맨틱 코드 내비게이션

**Browser & Web**
- `microsoft/playwright-mcp` — E2E 테스트 + 복잡한 페이지 인터랙션 최강
- `browsermcp/mcp` — 가벼움, 이미 로그인된 브라우저 세션 재사용
- `tavily-mcp` — LLM 소비용으로 사전 포맷된 검색 결과

**Database**
- `postgres-mcp-server` — schema introspection + 안전한 쿼리 실행
- `mongodb-mcp` — MongoDB 공식 관리
- `redis-mcp` — 에이전트 협업용 KV + pub/sub

**Memory & Knowledge**
- `mem0-mcp` — 영구 시맨틱 메모리 레이어 (mem0 SaaS 연동)
- `letta-mcp` — 에이전트 상태 프레임워크
- `pinecone-mcp` — 벡터 스토어

**Cloud Ops**
- `aws-mcp-server` — IAM 범위 AWS API 접근
- `k8s-mcp-server` — kubectl 동등 + 안전 가드레일
- `terraform-mcp-server` — plan/apply with 확인 게이트

**Coding Agents**
- `codemcp` — 임의의 IDE를 MCP host로 변환
- `e2b-sandbox-mcp` — 샌드박스 클라우드 코드 실행 (Code Interpreter 대체)

## 7. 셀프호스트 vs 클라우드 호스트 MCP Server

대부분의 MCP server는 stdio 기반 — 당신 머신에서 실행. 그러나 2026 트랜스포트 확장성 작업으로 HTTP/SSE MCP server가 프로덕션 가능해지며 클라우드 호스팅 패턴이 열림.

### 셀프호스트할 때

- **컴플라이언스** (헬스/금융/공공) — 데이터 경계 밖 못 나감
- **레이턴시** — server가 데이터 근처 (같은 VPC의 postgres)
- **비용** — 규모에서 per-call SaaS 비용 제거

4GB VPS면 stdio-브릿지 또는 HTTP MCP server 10+ 개 병렬로 편하게 돌립니다. 우리는 dibi8 내부 MCP 클러스터를 {{< aff "htstack" "self-host-vps" "HTStack 홍콩 VPS" >}}에서 운영 (중국 본토 sub-30ms 레이턴시). 글로벌 분산 배포 또는 큰 플릿은 {{< aff "digitalocean" "self-host-k8s" "DigitalOcean 매니지드 Kubernetes" >}} 3 레플리카가 프로덕션 표준 패턴.

### 클라우드 호스트할 때 (Smithery / e2b / 벤더 호스팅)

- **프로토타입** — 인프라 0, CLI로 설치, 빠른 반복
- **무상태 유틸리티** (fetch, search) — 데이터 로컬리티 고민 없음
- **컴퓨트 헤비** (e2b 샌드박스, 브라우저 자동화) — VM 관리 외주

## 8. 고르는 법 + 직접 만드는 곳

**픽 체크리스트 (후보당 30초)**:

1. **Star > 500** + **마지막 커밋 < 90일** = 활성 프로젝트 (아니면 다른 거)
2. **"good first issue" 라벨 open issue 존재** = 유지자가 컨트리뷰션 환영 (건강)
3. **License = MIT/Apache 2.0** = 상업 사용 안전
4. **README에 `claude_desktop_config.json` 스니펫 있음** = 작성자가 설치 경로 테스트함
5. **npm/PyPI 설치 시 바이너리 서명 확인** — MCP server 통한 공급망 공격은 2026 실제 위협 벡터

**맞는 게 없으면** 직접 작성. TypeScript와 Python SDK로 ~50줄로 동작하는 MCP server 출하. Anthropic 팀이 일부러 프로토콜을 얇게 유지 — server 만들기 마찰 없음.

전체 "내 MCP server 만들기" 워크스루(stdio 트랜스포트 셋업, tools/resources/prompts 구현, Claude Desktop 디버깅)는 [MCP 심층 결정판 2026 가이드](/kr/resources/llm-frameworks/mcp-deep-dive-definitive-2026-guide/) 참조.

## TL;DR

2026 MCP server 생태계는 알아둘 4 레이어:

1. **Anthropic 7 reference server** — 베이스라인 (Filesystem + Fetch + Memory 최소)
2. **awesome-mcp-servers (87.3k star)** — 정전 커뮤니티 색인, 카테고리로 탐색
3. **Smithery + mcp.so** — 레지스트리 플랫폼 (Smithery CLI 설치용, mcp.so 폭 넓음)
4. **셀프호스트 vs 클라우드 호스트** — 컴플라이언스/레이턴시는 셀프호스트, 프로토타입/컴퓨트 헤비는 클라우드

어려움은 더 이상 "server 찾기"가 아니라 **올바른 것 고르기** — 8절 30초 체크리스트와 2절 결정 트리 사용. 맞는 게 없으면 오후에 직접 작성 (50줄 TS 또는 Python).

---

*5+ MCP server (postgres + filesystem + git + memory + tavily-search)를 클라우드 청구서 안 태우고 셀프호스트하고 싶으신가요? $6/월 {{< aff "digitalocean" "footer-cta" "DigitalOcean droplet" >}} 하나 띄우고, 슈퍼바이저(systemd 또는 PM2) 아래 돌리고, Claude Desktop `claude_desktop_config.json`을 호스트로 가리키세요. 오후에 완료.*
