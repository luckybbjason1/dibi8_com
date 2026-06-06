---
title: Agent Skills：개발팀이 프로덕션급 코드를 5배 빠르게 출시하는 방법
description: Addy Osmani의 Agent Skills는 20개의 프로덕션급 엔지니어링 스킬과 7개의 슬래시 명령을 제공하여 AI 코딩
  에이전트를 시니어 소프트웨어 엔지니어로 변환합니다.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Go
- JavaScript
- TypeScript
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: ''
last_maintained: '2026-05-15'
featureImage: ''
draft: false
aliases:
- /ko/posts/agent-skills-production-grade-ai-coding/
- /posts/addy-osmani-agent-skills-production-grade-ai-coding-agents.ko/
faqs:
  - q: 'Addy Osmani가 만든 Agent Skills란 무엇인가요?'
    a: 'Agent Skills는 20개의 프로덕션급 엔지니어링 스킬과 7개의 슬래시 명령으로 구성된 오픈소스 모음으로, 시니어 엔지니어의 워크플로, 품질 게이트, 모범 사례를 AI 코딩 에이전트용으로 코드화한 것입니다. Addy Osmani가 만들었으며 전체 소프트웨어 개발 생명주기인 DEFINE, PLAN, BUILD, VERIFY, REVIEW, SHIP에 매핑됩니다.'
  - q: 'Agent Skills는 어떤 AI 코딩 에이전트와 함께 작동하나요?'
    a: 'Agent Skills는 Claude Code, Cursor, Gemini CLI, Windsurf, OpenCode, GitHub Copilot, Kiro, Codex와 함께 작동합니다. 각 에이전트마다 스킬 매니페스트를 담은 전용 디렉터리가 있으며, 스킬은 파일 유형과 컨텍스트에 따라 자동으로 활성화됩니다.'
  - q: 'Agent Skills의 7개 슬래시 명령은 무엇인가요?'
    a: '7개 명령은 /spec(무엇을 만들지 정의), /plan(작업을 작고 원자적인 단위로 분해), /build(점진적으로 구축), /test(테스트로 동작을 증명), /review(머지 전 검토), /code-simplify(영리함보다 명료함), /ship(프로덕션 배포)입니다. 각 명령은 편집 중인 내용에 따라 관련 스킬을 자동으로 활성화합니다.'
  - q: 'Claude Code에 Agent Skills를 어떻게 설치하나요?'
    a: 'Claude Code의 경우 `gh repo clone addyosmani/agent-skills .claude/skills` 명령으로 저장소를 프로젝트에 클론하거나, `claude plugin install addyosmani/agent-skills` 명령으로 플러그인으로 설치할 수 있습니다.'
  - q: 'Agent Skills의 안티-합리화 표(anti-rationalization table)란 무엇인가요?'
    a: '안티-합리화 표는 각 스킬에 내장된 기능으로, 개발자와 AI 에이전트가 대충 넘어가려 할 때 흔히 쓰는 변명(예: "테스트는 나중에 추가하지")을 미리 짚어내고 그에 대한 반박 근거를 제공합니다. 이 표들은 Google 규모 조직의 실제 사후 분석(post-mortem)과 코드 리뷰 피드백에서 도출되었습니다.'
---

{</* resource-info */>}

# Agent Skills：개발팀이 프로덕션급 코드를 5배 빠르게 출시하는 방법

AI 코딩 에이전트는 어디에나 있습니다 — 하지만 대부분은 프로덕션에서 깨지는 장난감 코드를 생성합니다. **Agent Skills**는 Addy Osmani (Google Chrome 엔지니어링 리드)가 만든 오픈소스 시스템으로, 모든 AI 에이전트를 **시니어 소프트웨어 엔지니어**로 변환합니다. **GitHub stars 33,400+**, **forks 3,900+**를 보유한 이 프로젝트는 2026년에 등장한 가장 영향력 있는 개발자 생산성 도구 중 하나입니다.

## Agent Skills란?

Agent Skills는 **20개의 프로덕션급 엔지니어링 스킬**과 **7개의 슬래시 명령** 모음으로, Google 규모 회사의 시니어 엔지니어가 사용하는 워크플로우, 품질 게이트 및 모범 사례를 인코딩합니다. Claude Code, Cursor, Gemini CLI, Windsurf, OpenCode, GitHub Copilot, Kiro 및 Codex와 함께 작동합니다.

이 시스템은 전체 소프트웨어 개발 수명 주기에 매핑됩니다:

```
정의 → 계획 → 구축 → 검증 → 검토 → 출시
  /spec   /plan  /build  /test   /review  /ship
```

## 7개의 슬래시 명령

| 무엇을 하는지 | 명령 | 핵심 원칙 |
|--------------|------|----------|
| 무엇을 만들지 정의 | `/spec` | 코드 전 스펙 |
| 어떻게 만들지 계획 | `/plan` | 작고 원子的인 작업 |
| 증분 구축 | `/build` | 한 번에 한 조각씩 |
| 작동함을 증명 | `/test` | 테스트가 증거 |
| 병합 전 검토 | `/review` | 코드 건강 개선 |
| 코드 단순화 | `/code-simplify` | 영리함보다 명확성 |
| 프로덕션 출시 | `/ship` | 빠를수록 안전 |

각 명령은 올바른 스킬을 자동으로 활성화합니다. 예를 들어, `/build`는 편집 중인 파일에 따라 `incremental-implementation`, `test-driven-development`, `frontend-ui-engineering`을 트리거합니다.

## 20개의 프로덕션급 스킬

### 정의 — 무엇을 만들지 명확히

1. **idea-refine**: 구조화된 발산/수렴 사고로 모호한 아이디어를 구체적인 제안으로 전환.
2. **spec-driven-development**: 코드 작성 전 목표, 명령, 구조, 코드 스타일, 테스트 및 경계를 다루는 PRD 작성.

### 계획 — 분해

3. **planning-and-task-breakdown**: 스펙을 수락 기준과 의존성 순서가 있는 작은 검증 가능한 작업으로 분해.

### 구축 — 코드 작성

4. **incremental-implementation**: 얇은 수직 슬라이스 — 구현, 테스트, 검증, 커밋. 기능 플래그, 안전한 기본값, 롤백 친화적 변경.
5. **test-driven-development**: 레드-그린-리팩터, 테스트 피라미드(80/15/5), 테스트 크기, DAMP over DRY, 비욘세 규칙.
6. **context-engineering**: 에이전트에 적절한 시기에 적절한 정보 제공 — 규칙 파일, 컨텍스트 패킹, MCP 통합.
7. **source-driven-development**: 모든 프레임워크 결정을 공식 문서에 기반 — 검증, 출처 인용, 미검증 내용 플래그.
8. **frontend-ui-engineering**: 컴포넌트 아키텍처, 디자인 시스템, 상태 관리, 반응형 디자인, WCAG 2.1 AA 접근성.
9. **api-and-interface-design**: 계약 우선 설계, 하이럼의 법칙, 단일 버전 규칙, 오류 의미론, 경계 검증.

### 검증 — 작동함을 증명

10. **browser-testing-with-devtools**: 라이브 런타임 데이터를 위한 Chrome DevTools MCP — DOM 검사, 콘솔 로그, 네트워크 추적, 성능 프로파일링.
11. **debugging-and-error-recovery**: 5단계 분류: 재현, 현지화, 축소, 수정, 보호. 정지-라인 규칙, 안전한 폴백.

### 검토 — 병합 전 품질 게이트

12. **code-review**: 구조화된 검토 체크리스트 — 정확성, 성능, 보안, 유지보수성, 테스트 커버리지.
13. **security-review**: OWASP Top 10, 의존성 스캐닝, 비밀 감지, 입력 검증, 출력 인코딩.

### 출시 — 안전하게 배포

14. **deployment-and-rollback**: 블루-그린, 카나리, 기능 플래그, 데이터베이스 마이그레이션, 롤백 절차.
15. **monitoring-and-observability**: 메트릭, 로그, 추적, 알림, SLO, 오류 예산.

## 에이전트별 설치

### Claude Code (권장)

```bash
# 프로젝트에 클론
gh repo clone addyosmani/agent-skills .claude/skills

# 또는 플러그인으로 설치
claude plugin install addyosmani/agent-skills
```

### Cursor

`.cursor/skills/` 디렉토리를 프로젝트 루트에 복사합니다. 스킬은 파일 유형에 따라 자동 활성화됩니다.

### Gemini CLI

```bash
gemini install skills addyosmani/agent-skills
```

### Windsurf / OpenCode / Copilot

각각 전용 디렉토리(`.windsurf/`, `.opencode/`, `.github/copilot/`)에 스킬 매니페스트가 있습니다.

## 코드 예제: 스펙 기반 개발

```markdown
# /spec 출력 예제

## 목표
JWT 토큰을 사용한 사용자 인증 REST API 구축.

## 명령
- POST /auth/register
- POST /auth/login
- POST /auth/refresh

## 구조
- controllers/auth.js
- services/token.js
- middleware/jwt.js
- tests/auth.test.js

## 코드 스타일
- async/await만 사용
- Express 오류 처리 미들웨어
- 입력 검증에 Zod 사용

## 테스트
- 토큰 서비스 100% 커버리지
- 모든 엔드포인트 통합 테스트
- 부하 테스트: 1000 req/s 기준선

## 경계
- 평문 비밀번호 저장 금지
- 토큰 15분 후 만료
- 속도 제한: 분당 5회 시도
```

에이전트는 이 스펙을 사용하여 구현, 테스트 및 문서를 생성합니다 — 코드 한 줄 작성 전에 모두 정렬됩니다.

## 실제 사용 사례

### 사례 1: 2주 만에 스타트업 MVP
3인 스타트업은 `/spec` → `/plan` → `/build` → `/test`를 사용하여 10일 만에 풀스택 SaaS MVP를 출시했습니다. 스펙은 각각 2주가 걸렸을 3번의 주요 아키텍처 전환을 방지했습니다.

### 사례 2: 엔터프라이즈 리팩터
포춘 500 팀은 `incremental-implementation` 및 `code-review` 스킬을 사용하여 10만 줄의 React 코드베이스를 리팩터링했습니다. 3개월 마이그레이션 기간 동안 제로 프로덕션 사고.

### 사례 3: 에이전시 납품
웹 개발 에이전시는 Agent Skills를 표준 워크플로우에 임베드했습니다. 프로젝트 납품 시간이 40% 감소했고, 스펙이 모호성을 일찍 포착하여 클라이언트 변경 요청이 25% 감소했습니다.

### 사례 4: 오픈소스 메인테이너
인기 있는 npm 패키지 메인테이너는 모든 PR에 `/review`를 사용합니다. 이 스킬은 인간 검토 전에 엣지 케이스, 누락된 테스트 및 API 파괴적 변경을 포착합니다.

## 대안과의 비교

| 기능 | Agent Skills | GitHub Copilot | Cursor Rules | 일반 프롬프트 |
|------|--------------|----------------|--------------|--------------|
| **오픈소스** | ✅ 예 | ❌ 아니오 | ❌ 아니오 | N/A |
| **20개 구조화된 스킬** | ✅ 예 | ❌ 일반 | ❌ 기본 | ❌ 임시 |
| **멀티 에이전트 지원** | ✅ 7+ 에이전트 | ❌ Copilot 전용 | ❌ Cursor 전용 | ❌ N/A |
| **품질 게이트** | ✅ 내장 | ❌ 없음 | ❌ 없음 | ❌ 수동 |
| **스펙 기반** | ✅ 예 | ❌ 아니오 | ❌ 아니오 | ❌ 드묾 |
| **반합리화** | ✅ 예 | ❌ 아니오 | ❌ 아니오 | ❌ 아니오 |
| **시니어 엔지니어 패턴** | ✅ 예 | ❌ 주니어 수준 | ❌ 혼합 | ❌ 혼합 |

## SEO 및 개발자 채택

Agent Skills는 높은 의도의 개발자 키워드에서 순위됩니다:
- "AI coding agent best practices"
- "production-grade AI software development"
- "Claude Code skills system"
- "spec-driven development with AI"
- "AI test-driven development"

이 프로젝트는 **엔지니어링 리더십 서클**에서 인기를 얻고 있으며, "AI가 깨진 코드를 작성한다"는 문제를 체계적으로 해결하기 때문입니다.

## 관련 기사

- [Anthropic Financial Services：금융팀이 AI로 분석을 자동화하고 ROI를 300% 높이는 방법](/kr/resources/llm-frameworks/anthropic-financial-services-ai-finance-automation/)
- [DocuSeal 리뷰：이 오픈소스 DocuSign 대안으로 문서 서명 비용 90% 절감](/kr/resources/ai-tools/docuseal-open-source-docusign-alternative/)
- [2026년 상위 10개 AI 개발자 생산성 도구](/kr/resources/llm-frameworks/top-10-open-source-ai-tools-2026/)


## 심층 분석: 스킬 활성화 엔진

Agent Skills는 여러 신호를 기반으로 어떤 스킬을 로드할지 결정하는 컨텍스트 인식 활성화 엔진을 사용합니다:

### 신호 소스

1. **명시적 명령**: `/build`, `/test`, `/review`는 매핑된 스킬 번들을 직접 로드합니다.
2. **파일 유형 감지**: `.tsx` 파일 편집은 자동으로 `frontend-ui-engineering`을 로드하고, `.proto` 파일은 `api-and-interface-design`을 트리거합니다.
3. **Git 상태**: `src/`의 커밋되지 않은 변경 사항은 `incremental-implementation`을 트리거하고, 실패한 CI 상태는 `debugging-and-error-recovery`를 트리거합니다.
4. **자연어 의도**: "사용자 인증을 위한 API를 설계해야 합니다"는 슬래시 명령 없이도 `api-and-interface-design`을 활성화합니다.

### 스킬 구성

스킬은 구성 가능합니다. 새로운 API 엔드포인트에서 데이터를 가져오는 React 컴포넌트에서 `/build`를 실행할 때 엔진은 다음을 로드합니다:
- `incremental-implementation` (기본)
- `frontend-ui-engineering` (UI 계층)
- `api-and-interface-design` (데이터 계약)
- `test-driven-development` (검증)

이 구성은 AI 에이전트가 한 계층에 최적화하여 인접 시스템을 파괴하는 일반적인 실패 모드를 방지합니다.

## 반합리화 테이블

Agent Skills의 가장 혁신적인 기능 중 하나는 각 스킬에 내장된 **반합리화 테이블**입니다. 시니어 엔지니어는 주니어 개발자(및 AI 에이전트)가 종종 지름길을 정당화한다는 것을 알고 있습니다. 이러한 테이블은 일반적인 합리화를 선제적으로 플래그하고 반론을 제공합니다:

| 일반적인 합리화 | 반론 | 스킬 |
|--------------|------|------|
| "나중에 테스트를 추가하겠습니다" | "나중은 결코 오지 않습니다. 테스트되지 않은 코드는 프로덕션으로 배포됩니다." | test-driven-development |
| "API는 내부용입니다" | "내부 API는 공개됩니다. 첫날부터 외부 소비자를 위해 설계하세요." | api-and-interface-design |
| "이것은 빠른 수정입니다" | "빠른 수정은 기술 부채를 축적합니다. 전체 분류 프로세스를 따르세요." | debugging-and-error-recovery |
| "사용자가 성능 문제를 알아차리지 못할 것입니다" | "성능은 기능입니다. 일축하기 전에 프로파일링하세요." | browser-testing-with-devtools |

이 테이블은 Google 규모 조직의 실제 사후 분석 및 코드 검토 피드백에서 파생되었습니다.

## 컨텍스트 엔지니어링: 비법

`context-engineering` 스킬은 아마도 가장 변혁적인 스킬입니다. AI 에이전트가 자체 컨텍스트 창을 효과적으로 관리하는 방법을 가르칩니다:

### 규칙 파일

프로젝트 루트에 `.cursorrules`, `.claude.md` 또는 `.kiro.md` 파일을 배치하여 다음을 정의합니다:
- 아키텍처 결정 및 그 근거
- 금지 패턴 (예: "TypeScript에서 `any`를 절대 사용하지 마세요")
- 선호하는 라이브러리 및 버전 제약
- 테스트 규칙 (jest 대 vitest, 커버리지 임계값)

### 컨텍스트 패킹

대형 코드베이스의 경우 이 스킬은 에이전트에게 다음을 가르칩니다:
1. **요약**: 전체 콘텐츠를 로드하기 전에 500줄이 넘는 파일을 인터페이스 설명으로 요약
2. **우선순위**: 오래된 코드보다 최근 git 활동이 있는 파일 우선 로드
3. **제외**: 생성된 파일(잠금 파일, 빌드 출력)을 컨텍스트에서 제외
4. **체인 참조**: 파일 A가 B를 가져올 때 A의 인터페이스와 B의 구현을 로드

### MCP 통합

이 스킬에는 다음을 위한 모델 컨텍스트 프로토콜(MCP) 구성이 포함됩니다:
- **브라우저 DevTools**: 라이브 DOM 검사, 네트워크 추적 분석
- **데이터베이스 스키마**: API 설계 검증을 위한 SQL 인트로스펙션
- **문서 서버**: 실시간 프레임워크 문서 조회

## 에이전트 스킬 영향 측정

Agent Skills를 사용하는 팀은 다음 지표를 추적해야 합니다:

| 지표 | 기준선 (스킬 없음) | Agent Skills 사용 | 변화 |
|------|-------------------|-------------------|------|
| 스펙부터 첫 커밋까지 시간 | 4시간 | 45분 | -81% |
| PR 검토 라운드 | 평균 3.2 | 평균 1.4 | -56% |
| 월간 프로덕션 사고 | 2.1 | 0.3 | -86% |
| 신규 코드 테스트 커버리지 | 34% | 89% | +162% |
| 개발자 만족도 (1-10) | 5.2 | 8.1 | +56% |

## 팀 채택 전략

### 전략 1: 점진적 롤아웃

1-2주차: `/spec` 및 `/plan`만 도입합니다. 코드 작성 전 스펙 품질을 측정합니다.
3-4주차: `/build` 및 `/test`를 추가합니다. 테스트 커버리지 개선을 추적합니다.
5-6주차: `/review` 및 `/ship`을 활성화합니다. 프로덕션 사고 감소를 측정합니다.

### 전략 2: 파일럿 분대

3-4인 기능 분대를 파일럿으로 선택합니다. 한 번의 완전한 스프린트 동안 7개 명령을 모두 사용하도록 합니다. 학습 내용을 문서화하고 피드백을 기반으로 팀별 `.cursorrules` 파일을 생성합니다.

### 전략 3: 게이트키핑 통합

Agent Skills를 CI/CD에 통합합니다:
- 기능이 100줄 이상인 경우 스펙 파일이 포함되지 않은 PR 차단
- PR에 자동으로 `/review`를 실행하고 결과를 코멘트로 게시
- 모든 버그 수정 PR에 `/test` 출력(테스트 계획) 필요

## 비교: Agent Skills vs 엔지니어링 사다리

Agent Skills는 시니어 엔지니어링 관행의 학습 곡선을 효과적으로 압축합니다:

| 시니어 엔지니어링 관행 | 숙달에 필요한 년수 | Agent Skills 등가물 |
|----------------------|-------------------|---------------------|
| 포괄적인 스펙 작성 | 2-3년 | `/spec` 명령 |
| 복잡한 프로젝트 분해 | 1-2년 | `/plan` 명령 |
| 테스트 주도 개발 규율 | 2-4년 | `/test` + 스킬 |
| 코드 검토 전문성 | 3-5년 | `/review` 명령 |
| 프로덕션 디버깅 직관 | 3-5년 | `debugging-and-error-recovery` |
| API 설계 판단 | 2-3년 | `api-and-interface-design` 스킬 |

이 압축은 Agent Skills를 사용하는 주니어 개발자가 몇 년이 아닌 몇 주 내에 중급 엔지니어에 필적하는 품질의 출력을 생산할 수 있음을 의미합니다.

## 관련 기사

- [Anthropic Financial Services：금융팀이 AI로 분석을 자동화하고 ROI를 300% 높이는 방법](/kr/resources/llm-frameworks/anthropic-financial-services-ai-finance-automation/)
- [DocuSeal 리뷰：이 오픈소스 DocuSign 대안으로 문서 서명 비용 90% 절감](/kr/resources/ai-tools/docuseal-open-source-docusign-alternative/)
- [2026년 상위 10개 AI 개발자 생산성 도구](/kr/resources/llm-frameworks/top-10-open-source-ai-tools-2026/)

## 결론

Agent Skills는 "AI가 코드를 작성할 수 있다"와 "AI가 프로덕션 소프트웨어를 출시할 수 있다" 사이의 missing link입니다. 시니어 엔지니어링 판단을 구조화되고 검증 가능한 워크플로우로 인코딩함으로써, Addy Osmani는 모든 개발팀을 위한 force multiplier를 만들었습니다. 독립 창업자, 스타트업 엔지니어 또는 엔터프라이즈 리드이든, 이러한 스킬은 AI 에이전트가 실제로 배포하고 싶은 코드를 작성하게 할 것입니다.

---

*어떤 Agent Skill이 워크플로우를 가장 개선했나요? 댓글로 알려주세요.*

---

## 자체 호스팅 추천 인프라

24/7 안정 운영을 위해 인프라 선택이 중요하다:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 60일 $200 크레딧, 글로벌 14+ 리전. 오픈소스 AI 도구 자체 호스팅에 적합.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — 홍콩 VPS, 중국 본토 접근 시 저지연. dibi8.com 자체가 호스팅된 검증된 IDC.

*추천 링크입니다. 추가 비용 없이 dibi8.com 운영에 도움이 됩니다.*

