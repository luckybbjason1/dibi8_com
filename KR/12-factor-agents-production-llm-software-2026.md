---
title: '12-Factor Agents 해설: 프로덕션급 LLM 소프트웨어를 위한 12개 원칙 (2026 완전 가이드)'
description: 'HumanLayer가 발표한 12-Factor Agents (GitHub 22K+ stars)는 데모 수준의 LLM 프로토타입과 실제 고객이 의존하는 프로덕션 에이전트를 가르는 설계 패턴을 정의합니다. 12개 원칙 전부 해설 — 프롬프트 소유, 컨텍스트 윈도우 소유, stateless reducer 모델, 제어 흐름 소유, tool call을 통한 human-in-the-loop, 컴팩트한 에러, 작고 집중된 에이전트 등. Claude Code, Codex, OpenCode, MCP 기반 에이전트 스택 실전 적용 가이드 포함.'
date: 2026-05-23 00:00:00+08:00
lastmod: 2026-05-23 00:00:00+08:00
tech_stack: []
application_domain: LLM Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/humanlayer/12-factor-agents'
stars: 22000
maintainer: 'humanlayer'
last_maintained: '2026-05-22'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['12-factor-agents', 'production-ai', 'llm-engineering', 'agent-architecture', 'humanlayer', 'agent-design-patterns', 'context-window', 'prompt-engineering', 'tool-calls', 'developer-productivity']
aliases:
- /kr/posts/12-factor-agents-production-llm-software-2026/
---

## "그냥 LangChain 쓰면 되지"가 안 통하게 된 이유

LLM 기반 기능을 실제 사용자에게 출시해본 엔지니어는 모두 같은 벽에 부딪힌다: 노트북에서 완벽하게 동작하던 프로토타입이 결제하는 고객이 처음 다른 각도로 요청하는 순간 무너진다. 에이전트가 도구 호출을 환각하고, 컨텍스트 윈도우가 세션 중간에 터지고, 에러는 조용히 삼켜지고, 재시도는 무한 회전하고, 사후 분석을 해보니 — 만든 엔지니어 본인조차 에이전트가 실패할 때 정확히 뭘 하고 있었는지 모른다.

2025–2026 에이전틱 AI 생태계는 "에이전트를 프로덕션급으로 만든다"고 약속한 프레임워크를 수십 개 만들어냈다 — LangChain, LangGraph, CrewAI, AutoGen, OpenAI Agents SDK, Pydantic AI, 끝없이 이어진다. 각각 *데모* 문제(도구 호출 조립, 서브 에이전트 라우팅)는 풀었다. 거의 누구도 *프로덕션* 문제(예상 못한 입력에서의 예측 가능한 동작, 관찰 가능한 실패 모드, 복구 가능한 세션)는 풀지 못했다.

[**12-Factor Agents**](https://github.com/humanlayer/12-factor-agents) (GitHub: `humanlayer/12-factor-agents`, **2026년 5월 기준 22,000+ stars**)는 Dex Horthy와 HumanLayer가 그 갭에 내놓은 답이다. Heroku의 2011년 12-Factor App 방법론을 본떠 만든, *방법론* 이다 — 프레임워크 아니고, 런타임 아니고, SaaS 아닌 — 실제 고객이 쓸 LLM 소프트웨어에 대한 사고법.

코드 Apache 2.0, 글 CC BY-SA 4.0. 273 커밋, 계속 증가 중. 주로 TypeScript에 접근성을 위한 Python과 Jupyter 예제.

---

## 핵심 통찰

프레임워크는 에이전트가 깨질 때 가장 중요한 네 가지를 추상화로 가려버린다:

1. **보내진 프롬프트**.
2. **활성화된 컨텍스트 윈도우**.
3. **다음에 뭘 할지 결정한 제어 흐름**.
4. **크래시에서 살아남아야 할 실행 state**.

12-Factor Agents는 *이 네 가지 각각*이 프레임워크가 감추는 마법이 아니라 *당신이 소유한 코드*여야 한다고 한 줄씩 논증한다. 결과는 레포에 코드가 좀 더 늘고, 새벽 3시 사고 때 기도를 덜 하게 되는 것이다.

전체 12개 factor와 각각의 실전 의미는 다음과 같다.

---

## 12개 Factor

### 1. 자연어를 도구 호출로

LLM의 일은 사용자 의도를 구조화된 도구 호출로 번역하는 것 — 그뿐. LLM에게 "그것을 해라"고 하지 마라. 그것을 *서술하는* JSON을 emit하게 한 다음 결정론적 코드가 실행하게 하라. 이 한 가지 제약이 환각 기반 사고 한 카테고리 전체를 없앤다.

### 2. 프롬프트를 소유하라

프롬프트는 *코드*다. 레포에 있고, 버전 관리되고, 코드 리뷰를 받아야 한다. 프레임워크 프롬프트 라이브러리에 묻혀 있는 템플릿은 업그레이드 시 조용히 동작을 바꿔놓을 기술 부채다. 에이전트 동작이 문자열에 달려 있다면, 그 문자열은 당신 것이다.

### 3. 컨텍스트 윈도우를 소유하라

모델 컨텍스트에 현재 있는 메시지 집합이 동작을 결정하는 최대 단일 요인이다. 자동 요약, 자동 가지치기, 자동 메모리 주입 프레임워크는 좋다 — 안 좋아질 때까지. 자체 컨텍스트 조립 로직을 만들어라. 모든 LLM 호출에 들어가는 정확한 메시지 배열을 출력할 수 있어야 한다.

### 4. 도구는 그냥 구조화된 출력

"도구"는 마법 Function 객체가 아니라 — LLM 출력을 제약하는 JSON Schema다. 이걸 내면화하면, LLM이 실제 "실행"하지 않는 "도구"를 만들 수 있다: 상태 전이, 결정 분기, escalation 요청. LLM에게 어떤 shape을 약속하도록 만드는 모든 것이 도구가 될 수 있다.

### 5. 실행 state와 비즈니스 state를 통일

당신의 에이전트에는 상태 머신이 두 개 있다: "대화 어디쯤이냐"와 "사용자의 주문/티켓/프로젝트는 뭘 하고 있냐". 12-Factor는 이 둘이 *같은* 상태 머신이어야 한다고 논증한다. 분리해두는 게 "에이전트는 끝났다고 하는데 주문은 여전히 pending" 같은 버그의 가장 흔한 원인이다.

### 6. Launch / Pause / Resume을 단순한 API로

당신의 에이전트는 실행 중간에 일시 정지되고 나중에 재개될 수 있어야 한다 — 다른 머신에서, 인간 승인 후일 수도. 즉 전체 세션 state가 직렬화 가능해야 한다. 로컬 변수 closure 마법 안 됨. "LLM 클라이언트 객체가 메모리에서 대화를 살려두는" 것 안 됨. 평범한 데이터, 어딘가 durable한 곳에 저장.

### 7. 도구 호출로 인간 연락

에이전트가 인간 입력이 필요할 때 — 승인, 누락 정보, escalation — 멈춰버리지 말고 *tool call을 emit*해야 한다. Tool call은 인간이 모니터링하는 같은 큐/UI/inbox로 간다. Factor 4와 같은 패턴, human-in-the-loop 케이스에 적용. HumanLayer의 제품은 이 원칙의 제품화 버전.

### 8. 제어 흐름을 소유하라

"LLM 호출 → 도구 실행 → LLM 다시 호출 → 끝났는지 체크 → LLM 다시 호출"의 for 루프가 모든 에이전트의 심장이다. 이를 숨기는 프레임워크("yield만 하면 루프는 우리가 처리")는 정확히 필요한 위치에 — rate limit, 예산 상한, 인간 checkpoint, 재시도 — 커스텀 로직을 넣을 수 있는 능력을 빼앗는다. 루프를 써라. 스무 줄짜리다.

### 9. 에러를 컨텍스트 윈도우로 컴팩트하게

도구 호출이 실패하면 올바른 행동은 *짧고 구조화된* 에러 메시지를 LLM의 다음 턴으로 되돌려 반응하게 하는 것이다. 크래시 X. 조용한 재시도 X. log-and-pray X. 200자짜리 "TOOL_FAILED: HTTP 503 from /api/orders, payload too large"면 LLM이 합리적 다음 수를 두기에 충분하다 — 백오프, 작은 payload 시도, 인간에 escalate.

### 10. 작고 집중된 에이전트

"모든 걸 다 하는" 거대 에이전트 하나는 디버깅 악몽. 도구 세 개, 일 하나씩 가진 작은 에이전트 열두 개는 테스트 가능하고 복구 가능하다. 마이크로서비스와 같은 패턴, 같은 trade-off: 조율 오버헤드는 더 크지만 장애 격리는 훨씬 낫다.

### 11. 어디서든 트리거, 사용자가 있는 곳에서 만나라

에이전트의 입력이 단일 채널에 결합되면 안 된다. Slack 메시지, 이메일, 웹 폼, GitHub 이슈, Telegram 봇, cron job — 모두 같은 에이전트. Factor 2(프롬프트 소유)와 Factor 5(통일 state)가 먼저 단단해야 가능, 보상은 에이전트 재작성 없이 새 입력 소스를 추가할 수 있다는 것.

### 12. 에이전트를 무상태 리듀서로

에이전트는 순수 함수: `state, event → new state, output`. 숨겨진 mutation X. "에이전트는 self.history 속성이 있어서 기억해" X. 출력에 영향을 주는 모든 것이 입력에 있다. 이것이 다른 모든 걸 가능하게 한다 — 이거 없으면 Factor 5, 6, 10은 희망사항.

---

## 실제 스택에 적용

### [Claude Code](https://dibi8.com/kr/vs/claude-code-vs-aider/) 워크플로에 적용

Claude Code는 설계상 이미 Factor 1, 4, 7을 구현 — tool call이 구조화된 출력이고, MCP 서버가 human-in-the-loop을 추가하고, 도구 카탈로그는 당신 소유(프로젝트의 MCP 설정). 당신이 신경 써야 할 것은 Factor 2(CLAUDE.md로 시스템 프롬프트 커스터마이즈), Factor 3(컨텍스트 윈도우 조립은 부분적으로 Claude가 하지만 pagefind/[CodeGraph](https://dibi8.com/kr/resources/dev-utils/codegraph-pre-indexed-knowledge-graph-2026/) 통합으로 형태를 잡을 수 있음), Factor 9(도구가 에러를 반환할 때 컴팩트하고 구조화되도록 보장).

### [MCP 기반](https://dibi8.com/kr/resources/llm-frameworks/mcp-deep-dive-definitive-2026-guide/) 에이전트 스택에 적용

MCP는 Factor 4를 못 박는다(표준화된 프로토콜 위 구조화된 출력으로서의 도구) — Factor 11에도 도움(MCP 인식 클라이언트가 어떤 MCP 서버든 구동 가능). MCP 자체는 Factor 5, 6, 8, 12에 대해 침묵 — 이건 MCP 위에 직접 만들어야 한다.

### [Hermes Agent](https://dibi8.com/kr/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/) / [OpenCode](https://dibi8.com/kr/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/) / 자체 스택에 적용

이들은 Factor 1, 4, 8에서 출발점을 준다 (내장 에이전트 루프, 구조화된 tool call). 당신이 직접 가져와야 할 것은 Factor 2(프롬프트), Factor 3(컨텍스트 조형), Factor 5–6(state 영속화), Factor 12(무상태성).

---

## 12-Factor Agents가 주류 프레임워크 마케팅과 부딪치는 지점

매니페스토 안에 "프레임워크 써서 디테일 잊어버려" 화법에 정면으로 맞서는 원칙 몇 개:

- **Factor 2 vs 프롬프트 라이브러리**: 대부분의 에이전트 프레임워크가 프롬프트 라이브러리를 제공. 12-Factor 왈: 프롬프트를 레포에 복사하라, 그러면 당신 것이다.
- **Factor 3 vs 자동 메모리**: 프레임워크는 자동 메모리("out-of-the-box RAG")를 좋아함. 12-Factor 왈: 그게 "왜 에이전트가 이러지?" 미스터리의 최대 단일 원인. 자체 조립을 만들어라.
- **Factor 8 vs 루프 숨기는 런타임**: 루프를 감추는 호스팅 런타임은 커스텀 로직 넣기 전엔 편리. 12-Factor 왈: 직접 루프 써라, 작다.

이건 반-프레임워크가 아니라 *너무 많이 숨기는* 프레임워크와의 싸움. 프레임워크를 라이브러리로 써라, 블랙박스가 아니라.

---

## 12-Factor Agents가 아닌 것

기대치를 맞추기 위해:

- **런타임 아님**. `pip install twelve-factor-agents` 없음. 글, 예제, 패턴.
- **단일 언어 아님**. 예제는 TypeScript와 Python이지만 원칙은 언어 무관.
- **종교 아님**. 일부 factor (특히 10 — 작고 집중된 에이전트) 는 실제 trade-off 동반. 매니페스토는 그 점에 정직.
- **완성 아님**. 273 커밋 증가 중. 이슈와 토론이 표현을 적극 반복.

---

## 누가 읽어야 하나

**그렇다, 처음부터 끝까지 읽어라, 만약 당신이:**
- LLM 기능을 결제 고객에게 출시하고 있다(혹은 곧 출시 예정).
- 지난 60일 안에 "데모 때는 됐는데" 에이전트 사고를 디버깅했다.
- 직접 에이전트 루프를 작성할지 LangGraph/CrewAI/Agents SDK를 도입할지 고민 중.
- [Cursor vs Claude Code](https://dibi8.com/kr/vs/claude-code-vs-aider/) 같은 벤더 비교를 하고 있고 "프로덕션급"이 실제로 무슨 의미인지 체크리스트를 원한다.

**훑어만 보아도 OK, 만약 당신이:**
- 아직 "첫 에이전트" 데모 단계 (Factor 1, 2 읽고 나중에 돌아와라).
- 호스팅 노코드 플랫폼(n8n, Zapier)만 쓰고 에이전트 루프를 직접 안 짠다.

---

## 결론

12-Factor Agents가 2026년 LLM 소프트웨어에서 가장 많이 인용되는 매니페스토인 데는 이유가 있다: 지난 2년간 프로덕션 에이전트를 출시한 엔지니어들이 독립적으로 도달했던 패턴들에 단어를 부여한다. Heroku 12-factor 평행선은 잘난 척이 아니다 — 두 문서 모두 *실제 사용자가 의존하기 시작하면 선택 사항이 아니게 되는 것들*을 성문화한 것이다.

매니페스토가 미는 가장 큰 단일 마인드셋 전환: **에이전트는 소프트웨어다, 그리고 소프트웨어는 그것을 운영하는 팀이 이해할 수 있어야 한다**. 그 계약을 흐리는 프레임워크는 생산성이 아니라 기술 부채.

12개 factor를 [CodeGraph 같은 토큰 효율적 심볼 레이어](https://dibi8.com/kr/resources/dev-utils/codegraph-pre-indexed-knowledge-graph-2026/), [rtk 같은 비용 인식 LLM 프록시](https://dibi8.com/kr/resources/llm-frameworks/rtk-rust-cli-proxy-llm-token-savings-2026/), [CC Switch 같은 통합 CLI 컨트롤 플레인](https://dibi8.com/kr/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/)과 결합하면, 2026년 프로덕션 AI 스택의 아키텍처 뼈대가 된다.

---

**GitHub**: [humanlayer/12-factor-agents](https://github.com/humanlayer/12-factor-agents) · **라이선스**: Apache 2.0 (코드) / CC BY-SA 4.0 (콘텐츠) · **Stars**: 22K+ · **저자**: Dex Horthy / HumanLayer
