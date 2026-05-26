---
title: 'Claude Code MCP 고급 2026: 프로덕션급 10 서버 스택'
description: '다양한 MCP 서버 조합으로 Claude Code를 운영해본 끝에, 성능·보안·시작 시간의 균형을 맞춘 10 서버 프로덕션 스택으로 정착했습니다. 각 서버가 왜 포함되었는지, 무엇을 하는지, 그리고 1인 사용자와 팀 환경에서 어떻게 구성할지 정리합니다.'
date: 2026-05-25 00:00:00+08:00
lastmod: 2026-05-25 00:00:00+08:00
tech_stack: ['Claude Code', 'MCP', 'TypeScript', 'Python', 'Docker']
application_domain: LLM 프레임워크
source_version: 'MCP 2025-06 / Claude Code 1.0'
licensing_model: '혼합'
license_type: '다양'
github_repo: 'https://github.com/modelcontextprotocol/servers'
stars: 60000
maintainer: 'Anthropic + 커뮤니티'
last_maintained: '2026-05-25'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['claude-code', 'mcp', 'configuration', 'production', '2026']
aliases:
- /kr/posts/claude-code-mcp-advanced-10-server-stack-2026/
faq:
  - q: "MCP 서버는 몇 개부터 너무 많은가요?"
    a: "10개를 넘어가면 시작 지연이 눈에 띄게 늘어납니다. 서버 하나당 Claude Code 초기화에 100~300ms가 추가됩니다. 아래 10 서버 스택이 최적점이며, 시작이 느려졌다고 느끼지 않으면서 90%의 워크플로를 커버합니다."
  - q: "글로벌 설정과 프로젝트별 MCP 설정 중 어느 쪽을 써야 하나요?"
    a: "프로젝트 전용 서버(이 앱 전용 postgres, 이 리포지토리에 한정된 GitHub PAT 등)는 프로젝트별(.claude/mcp.json 또는 .cursor/mcp.json)로 두세요. 개인용 범용 도구(홈 디렉터리로 한정된 filesystem, sequentialthinking)는 글로벌(~/.claude/mcp.json)로 두세요."
  - q: "팀과 1인 사용자에게 각각 유리한 MCP 서버는 무엇인가요?"
    a: "팀: github(PR 리뷰), linear(프로젝트 추적), slack(알림), 공유 postgres 또는 supabase(협업 데이터). 1인: 동일하지만 공유 인프라 제외. 공통: filesystem, git, fetch, memory, sequentialthinking."
  - q: "HTTP/SSE 서버와 stdio의 트레이드오프는 무엇인가요?"
    a: "HTTP: 영속 상태, 자격 증명 중앙화, 서버 가동 시간에 의존. stdio: 지연 없음, 자격 증명 노출 없음, 세션 종료 시 함께 종료. 기본은 stdio. HTTP는 (a) 세션 간 영속 상태가 필요하거나, (b) 로컬 대체가 없는 SaaS와 통합해야 할 때만 사용하세요."
---

{{</* resource-info */>}}

# Claude Code MCP 고급 2026: 프로덕션급 10 서버 스택

> **메타 설명**: 다양한 MCP 조합으로 Claude Code를 운영해본 뒤, 성능·보안·시작 시간의 균형을 맞춘 10 서버 스택으로 정착했습니다.

2026년 MCP 생태계는 1,000개 이상의 서버에 도달했습니다. 대부분의 사용자는 너무 적게 설치(유용한 통합을 놓침)하거나 너무 많이 설치(시작이 느려지고 공격 표면이 커짐)합니다. 본 글은 수개월의 테스트 끝에 정착한 10 서버 스택과, 각 서버가 포함된 이유를 공유합니다.

## ⚡ TL;DR

> **10 서버 스택**: filesystem, git, github, fetch, sequentialthinking, memory, postgres, brave-search, playwright, linear.
>
> **stdio 5개(로컬), HTTP 5개(SaaS)**.
>
> **시작 비용**: 총 약 1.5초.
>
> **프로젝트별 오버라이드**: postgres, github, linear는 리포지토리 내 `.claude/mcp.json`으로 설정.

## 스택

### 로컬 stdio (5개)

#### 1. filesystem
**선정 이유**: 범위가 제한된 디렉터리 읽기/쓰기. 모든 작업의 토대.
**구성**: 워크스페이스 루트로 범위 제한.
**위험**: 범위가 좁을 때 낮음.

#### 2. git
**선정 이유**: 셸에서 git을 띄우지 않고도 blame, log, diff 검사.
**구성**: 기본값.
**위험**: 낮음(읽기 전용).

#### 3. fetch
**선정 이유**: 범용 HTTP + Markdown 변환. Claude가 문서/기사를 끌어올 수 있게 함.
**구성**: 기본값.
**위험**: 중간(가져온 콘텐츠를 통한 프롬프트 인젝션 가능).

#### 4. sequentialthinking
**선정 이유**: 복잡한 작업을 위한 구조화된 계획 도우미.
**구성**: 기본값.
**위험**: 미미함.

#### 5. memory
**선정 이유**: 세션 간 지속되는 에이전트 메모리.
**구성**: 메모리 파일을 프로젝트 범위로 제한.
**위험**: 낮음.

### HTTP / SSE (5개)

#### 6. github
**선정 이유**: PR 리뷰, 이슈 분류, 리포지토리 검색.
**구성**: 리포지토리별 세분화된 PAT. 절대 전체 권한 사용 금지.
**위험**: 중간(토큰 범위가 관건).

#### 7. postgres
**선정 이유**: Claude를 떠나지 않고 데이터베이스 쿼리.
**구성**: 읽기 전용 DB 사용자, 프로젝트 범위로 한정.
**위험**: 읽기 전용이 아니면 높음.

#### 8. brave-search
**선정 이유**: 리서치용 프라이버시 친화적 웹 검색.
**구성**: 환경 변수에 API 키 보관.
**위험**: 낮음.

#### 9. playwright
**선정 이유**: 테스트 또는 스크래핑용 브라우저 자동화.
**구성**: 기본은 헤드리스 모드.
**위험**: 중간(브라우저는 공격 표면이 넓음).

#### 10. linear
**선정 이유**: 작업 추적을 위한 프로젝트 관리 통합.
**구성**: 단일 팀으로 범위 제한.
**위험**: 중간(프로젝트 보드에 쓰기 권한).

## 구성

`~/.claude/mcp.json` (글로벌, 범용 도구):

```json
{
  "mcpServers": {
    "filesystem": {"command": "npx", "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/me/work"]},
    "git": {"command": "uvx", "args": ["mcp-server-git"]},
    "fetch": {"command": "uvx", "args": ["mcp-server-fetch"]},
    "sequentialthinking": {"command": "npx", "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]},
    "memory": {"command": "npx", "args": ["-y", "@modelcontextprotocol/server-memory"]},
    "brave-search": {"command": "npx", "args": ["-y", "@modelcontextprotocol/server-brave-search"], "env": {"BRAVE_API_KEY": "${BRAVE_API_KEY}"}},
    "playwright": {"command": "npx", "args": ["-y", "@executeautomation/playwright-mcp-server"]}
  }
}
```

`.claude/mcp.json` (프로젝트별, 민감한 도구):

```json
{
  "mcpServers": {
    "github": {"command": "...", "env": {"GITHUB_PAT": "${PROJECT_GITHUB_PAT}"}},
    "postgres": {"command": "...", "env": {"DATABASE_URL": "postgresql://readonly:..."}},
    "linear": {"command": "...", "env": {"LINEAR_API_KEY": "${LINEAR_KEY}"}}
  }
}
```

## 왜 더 많은 서버를 넣지 않는가?

### 왜 `slack` MCP는 없는가?
유용하지만 권한 관리 마찰이 큽니다. Slack 통합이 매일 필요할 때만 추가하세요.

### 왜 `notion` MCP는 없는가?
Slack과 동일—유용하지만 대부분 사용자에게 매일 돌아오는 보상에 비해 시작 시간 부담이 큽니다.

### 왜 `kubernetes` MCP는 없는가?
강력하지만 사용 빈도가 낮습니다. 운영 업무가 요구할 때 프로젝트별로 추가하세요.

### 왜 `aws` / `gcp` MCP는 없는가?
동일—프로젝트별로 설치하세요. 클라우드 자격 증명을 글로벌로 상시 접근 가능하게 두지 마세요.

## 시작 최적화

서버 하나당 약 100~300ms 추가. 서버 10개: 합계 약 1.5초. 15개 이상: 눈에 띄게 느려짐.

팁:
- 동일 기능이 stdio(로컬)와 HTTP 모두에 있으면 stdio 우선
- 각 서버의 시작 시간 감사—`time npx <server>`로 측정
- Anthropic 공식 대체가 있을 때 느린 커뮤니티 서버를 교체

## 보안 패턴

1. github/linear/postgres에는 **세분화된 토큰**
2. postgres MCP에는 **읽기 전용 DB 사용자**
3. mcp.json에서 **버전 고정**(커뮤니티 서버 자동 업그레이드 금지)
4. 민감 자격 증명은 **프로젝트별 오버라이드**
5. 고위험 프로젝트에는 에이전트 루프를 **샌드박스화**(firejail 또는 컨테이너)

## 권장 인프라

자체 호스팅 MCP 서버(팀 공유용):
- **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — 200달러 크레딧
- **{{< aff "htstack" "footer-cta" "HTStack" >}}** — 홍콩 VPS, 아시아 저지연

*제휴 링크—가격은 동일하며 dibi8.com을 후원합니다.*

## 결론

MCP 서버 10개가 최적점입니다. 위 스택은 코드, 검색, 프로젝트 관리, 브라우저 자동화, 데이터베이스를 아우르며 대부분 워크플로를 커버합니다. 성능을 위해 15개 미만을 유지하세요.

프로젝트별 오버라이드가 글로벌 설정보다 더 중요합니다. 민감 토큰은 해당 프로젝트로 한정하세요. "이 프로젝트가 필요한 것만" 원칙을 지키면 자격 증명 유출을 방지하고 시작을 빠르게 유지할 수 있습니다.

---

**관련 글**: [MCP 서버 2026 순위](https://dibi8.com/kr/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/) · [MCP 서버 보안 감사 2026](https://dibi8.com/kr/resources/llm-frameworks/mcp-server-security-audit-2026-real-cases/) · [Claude Code 설정 가이드](https://dibi8.com/kr/resources/llm-frameworks/claude-code/)
