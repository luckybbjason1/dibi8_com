---
title: '2026년 로컬 우선 AI 스택: 14개 오픈소스 도구로 짜는 프로덕션 아키텍처 레퍼런스'
description: '클라우드 lock-in 없이 2026년 프로덕션급 AI 애플리케이션을 만드는 완전한 참조 아키텍처 — 7개 레이어, 14개 오픈소스 도구, 실제 성능 수치. 로컬 LLM 런타임, 심볼 단위 코드 인텔리전스(CodeGraph), 통합 CLI 컨트롤(CC Switch), 비용 인식 프록시(rtk), 영구 에이전트 메모리(agentmemory/MemPalace), 온디바이스 TTS(Supertonic), 그리고 12-Factor Agents 방법론까지. 경제적으로 스케일하는 LLM 기능을 출하하기 위한 풀스택.'
date: 2026-05-23 00:00:00+08:00
lastmod: 2026-05-23 00:00:00+08:00
tech_stack: []
application_domain: LLM Frameworks
source_version: ''
licensing_model: Mixed Open Source
license_type: Various (per-component)
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8 editorial team'
last_maintained: '2026-05-23'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['hub article', 'local-first-ai', 'production-ai', 'self-hosted-ai', 'ai-architecture', 'ai-stack-2026', 'agent-infrastructure', 'codegraph', '12-factor-agents', 'supertonic', 'cc-switch', 'rtk', 'agentmemory', 'mempalace', 'mcp', 'ds4', 'opencode', 'hermes-agent']
aliases:
- /kr/posts/2026-local-first-ai-stack-production-architecture/
---

## "그냥 OpenAI 호출하면 되지"가 더 이상 통하지 않는 이유

2년 동안 LLM 기반 제품을 만드는 지배적 패턴은 늘 똑같은 다섯 줄짜리 Python이었다: OpenAI 클라이언트 임포트, API 키 붙여넣기, 시스템 프롬프트 작성, 출시. 이 패턴은 프로토타입에는 여전히 유효합니다. 하지만 스케일하는 제품, 규제 산업의 제품, API가 레이트 리밋에 걸리거나 닿지 않는 지역의 제품, 시리즈 A 이후까지 유닛 이코노믹스를 살려야 하는 제품에는 더 이상 통하지 않습니다.

2026년 프로덕션의 현실:

- 일일 활성 사용자 약 1만 명을 넘기는 순간 **토큰 비용이 복리로 불어납니다**.
- **개인정보 보호와 컴플라이언스**는 헬스케어, 법률, 핀테크, 정부, 그리고 점점 늘어나는 엔터프라이즈 버티컬에서 서드파티 API를 배제합니다.
- 국경을 넘나드는 API 호출에 의존하는 순간 **레이턴시 변동성**이 실시간 에이전트 UX를 죽입니다.
- **벤더 리스크** — 지난 18개월간 주요 프론티어 모델 제공자 모두가 수 시간짜리 장애, 깜짝 가격 인상, 정책 변경을 한 번씩은 겪었습니다.

2026년에 바뀐 것은 로컬 AI가 극적으로 좋아졌다는 점이 아닙니다 — 그쪽은 꾸준히 개선되어 왔죠. 바뀐 것은 **돈 내는 고객에게 실제로 로컬 AI를 출하하는 데 필요한 오픈소스 조각들의 스택**이 마침내 제자리에 딸깍 끼워졌다는 점입니다. 이 글은 그 스택의 참조 아키텍처입니다: 7개 레이어, 14개의 구체적인 오픈소스 도구, 그리고 그것들이 어떻게 조합되는지.

---

## 도그마

로컬 우선 AI 스택은 세 가지 약속 위에 세워집니다:

1. **추론은 로컬일 수도, 원격일 수도 있다. 단, 그 선택은 요청별로 애플리케이션이 한다.** 프레임워크가 아니고, SDK도 아니고, 앱이.
2. **모든 레이어는 오픈 웨이트이며 셀프 호스팅 가능해야 한다.** "무료 티어"는 "오픈소스"가 아닙니다. 셀프 호스팅 불가능한 무료 티어는 미래의 청구서일 뿐.
3. **어떤 레이어도 하드 디펜던시가 아니다.** 에이전트를 재작성하지 않고 각 조각을 교체할 수 있어야 합니다.

위에서 아래로, 우리가 각 레이어에 추천하는 오픈소스 대표 주자와 함께 7개 레이어:

| 레이어 | 기능 | 레퍼런스 도구 |
|---|---|---|
| 7 — 방법론 | 에이전트를 사고하는 방식 | [12-Factor Agents](https://dibi8.com/kr/resources/llm-frameworks/12-factor-agents-production-llm-software-2026/) |
| 6 — 음성 / 오디오 I/O | 클라우드 없는 음성 입출력 | [Supertonic](https://dibi8.com/kr/resources/ai-tools/supertonic-on-device-multilingual-tts-2026/) |
| 5 — 메모리 / 상태 | 영구 에이전트 상태 | [agentmemory](https://dibi8.com/kr/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/) + [MemPalace](https://dibi8.com/kr/resources/ai-tools/mempalace/) |
| 4 — 비용 통제 | 호출별 라우팅 + 예산 캡 | [rtk](https://dibi8.com/kr/resources/llm-frameworks/rtk-rust-cli-proxy-llm-token-savings-2026/) |
| 3 — 심볼 인텔리전스 | 코드 이해 | [CodeGraph](https://dibi8.com/kr/resources/dev-utils/codegraph-pre-indexed-knowledge-graph-2026/) |
| 2 — 에이전트 런타임 / CLI | 도구 호출 + 제어 흐름 | [OpenCode](https://dibi8.com/kr/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/), [Hermes Agent](https://dibi8.com/kr/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/), [Codex CLI](https://dibi8.com/kr/resources/llm-frameworks/openai-codex-cli-terminal-ai-coding-agent-2026/) — [CC Switch](https://dibi8.com/kr/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/)로 통합 |
| 1 — LLM 런타임 | 실제 실행되는 모델 자체 | [로컬 LLM 러너 비교](https://dibi8.com/kr/resources/llm-frameworks/local-llm-runner-comparison-2026/) + [ds4](https://dibi8.com/kr/resources/llm-frameworks/ds4-open-source-deepseek-alternative-2026/) |

그리고 모든 레이어를 가로지르는 결합 조직: **[MCP — Model Context Protocol](https://dibi8.com/kr/resources/llm-frameworks/mcp-deep-dive-definitive-2026-guide/)** — 각 도구가 다음 도구에게 말을 거는 표준 프로토콜.

---

## 레이어 1 — 로컬 LLM 런타임

기초입니다. 쓸 만한 로컬 모델 없이는 나머지 모든 레이어가 클라우드 프록시로 회귀합니다.

"2026년 프로덕션 사용 가능" 라인을 넘어선 후보들은 [로컬 LLM 러너 비교](https://dibi8.com/kr/resources/llm-frameworks/local-llm-runner-comparison-2026/)에서 상세히 다뤘습니다 — Ollama, LM Studio, vLLM, TGI, 그리고 떠오르는 다크호스 [ds4 (DeepSeek 파생 오픈소스 로컬 모델)](https://dibi8.com/kr/resources/llm-frameworks/ds4-open-source-deepseek-alternative-2026/).

프로덕션용 런타임을 취미용과 가르는 건 세 가지입니다:

- **동시 서빙** — 한 건이 아니라 수십 개의 동시 요청을 처리.
- **정확도를 망가뜨리지 않는 양자화** — Q4/Q5 양자화가 당신의 유스케이스에서 비양자화 모델 성능의 95%+를 유지해야 합니다.
- 마이너 버전마다 깨지지 않는 **안정적인 API 표면**.

2026년 대부분의 팀에게 실용적인 분할은 **서빙은 vLLM, 개발은 Ollama**입니다. ds4는 DeepSeek 업스트림을 직접 돌리는 라이선스 모호함 없이 DeepSeek 급 추론을 원하는 팀의 모델 선택지로 흥미롭습니다.

---

## 레이어 2 — 에이전트 런타임 / CLI

모델이 로드되었습니다. 이제 그것을 운전할 무언가가 필요합니다 — 도구를 호출하고, 응답을 파싱하고, 끝날 때까지 루프를 도는 무엇.

2026년 현재, 프로덕션 팀들이 실제로 배포한 살아있는 오픈소스 옵션은 셋입니다:

- **[OpenCode](https://dibi8.com/kr/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/)** — 커뮤니티 주도 Claude Code 대안, 162K+ stars, 멀티 모델.
- **[Hermes Agent](https://dibi8.com/kr/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/)** — 강력한 거버넌스 프리미티브를 가진 Nous Research의 자기 개선 에이전트.
- **[Codex CLI](https://dibi8.com/kr/resources/llm-frameworks/openai-codex-cli-terminal-ai-coding-agent-2026/)** — Rust로 재작성, 세 가지 자율성 모드, 가장 깊은 도구 호출 규율.

웬만한 팀은 결국 *세 개 모두* 돌리게 됩니다 — 일마다 다른 에이전트. 그러다 보면 설정 난립 문제가 생기고, 이건 **[CC Switch](https://dibi8.com/kr/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/)** (74K+ stars)가 해결해줍니다. 세 도구에 더해 Claude Code, Gemini CLI까지 통합 컨트롤 센터 하나로 묶어주죠. CC Switch가 없으면 5개의 서로 다른 MCP 설정과 API 키 파일을 맞추느라 매주 1시간을 까먹게 됩니다.

---

## 레이어 3 — 심볼 인텔리전스

에이전트가 당신의 코드를 이해해야 할 때, 순진한 `grep` + `Read` 조합은 토큰을 태웁니다. 그것도 아주 많이. 이 레이어는 대부분의 팀이 출하 *후에야* 발견하는 레이어입니다 — 보통 첫 달 청구서가 도착하는 순간에.

**[CodeGraph](https://dibi8.com/kr/resources/dev-utils/codegraph-pre-indexed-knowledge-graph-2026/)** (20K+ stars)가 오픈소스 답입니다: 코드베이스의 심볼, 호출 관계, framework 라우트를 사전 인덱싱한 지식 그래프, MCP로 밀리초 안에 쿼리 가능. 보고된 절감: 세션당 토큰 약 35%, 도구 호출 약 70% 감소.

CodeGraph의 아키텍처적 통찰은 일반화됩니다: **에이전트가 당신의 도메인에 대해 반복적으로 쿼리할 모든 데이터는 세션마다 다시 도출되는 것이 아니라 사전 인덱싱된 쿼리 표면을 가져야 한다**. 고객 레코드, 제품 카탈로그, 티켓 히스토리 — 모두 자신만의 CodeGraph 스타일 인덱스를 가질 자격이 있습니다.

---

## 레이어 4 — 비용 통제 / 라우팅

로컬 모델과 심볼 레이어가 있어도, 에이전트는 능력 때문에 외부 모델을 쓰게 됩니다 — 어려운 추론에는 Claude Opus, 비전에는 Gemini Pro, 특정 도구에는 GPT-4o. 비용 통제 레이어는 요청별로 라우팅합니다: 싼 모델 먼저, 필요할 때만 에스컬레이션, 캐싱은 공격적으로.

**[rtk](https://dibi8.com/kr/resources/llm-frameworks/rtk-rust-cli-proxy-llm-token-savings-2026/)**는 가장 가벼운 옵션입니다 — Claude Code(또는 OpenAI 호환 클라이언트) 앞에 끼우는 Rust CLI 프록시로, 요청을 지능적으로 라우팅합니다. 실전 보고: 코딩 에이전트 워크로드에서 60–90% 토큰 절감.

더 복잡한 라우팅(A/B 테스트, 예산 강제, 폴백 체인)이 필요하면 LiteLLM이나 Portkey 같은 무거운 게이트웨이가 작동합니다. 그건 [LLM 게이트웨이 비교](https://dibi8.com/kr/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/)에서 다뤘습니다.

---

## 레이어 5 — 메모리와 상태

상태 없는 에이전트는 생산성의 천장입니다. 프로덕션 에이전트는 기억합니다 — 세션을 넘나들고, 사용자를 넘나들고, 대화를 넘나들며.

2026년 에이전트 메모리에 대한 오픈소스 지형은 [AI 에이전트 메모리 시스템 가이드](https://dibi8.com/kr/resources/llm-frameworks/ai-agent-memory-systems-2026/)에 정리되어 있습니다. 우리가 직접 만져보고 추천하는 두 가지:

- **[agentmemory](https://dibi8.com/kr/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/)** — MCP 네이티브, 실전 벤치마크, "AI 코딩 에이전트를 위한 영구 메모리"의 최초 신뢰할 만한 시도.
- **[MemPalace](https://dibi8.com/kr/resources/ai-tools/mempalace/)** — 강력한 지식 그래프 능력을 가진 더 일반적인 "개인 메모리" 접근.

둘 다 같은 아키텍처 패턴을 따릅니다: 의미 검색을 위한 벡터 스토어, 사실과 결정을 위한 구조화된 key-value 레이어, 그리고 어떤 에이전트 런타임이든 두 레이어를 모두 쿼리할 수 있도록 해주는 MCP 서버. 12-Factor 원칙 중 "컨텍스트 윈도우를 직접 소유하라"(factor 3)가 여기에 그대로 적용됩니다 — 메모리는 당신이 조립하는 컨텍스트의 일부입니다.

---

## 레이어 6 — 음성과 오디오 I/O

음성으로 인간과 상호작용하는 에이전트 — 단순 챗봇이 아니라 차량 내 어시스턴트, 접근성 도구, 키오스크, 규제된 음성 안내 — 에 대해 클라우드 TTS는 역사적 기본값이었고 동시에 비용과 프라이버시의 병목이었습니다.

**[Supertonic](https://dibi8.com/kr/resources/ai-tools/supertonic-on-device-multilingual-tts-2026/)** (한국 회사 Supertone Inc., 9.9K+ stars)이 2026년 가장 신뢰할 만한 오픈소스 온디바이스 TTS입니다. 9,900만 파라미터, 한국어 포함 모든 주요 아시아 언어를 포함한 31개 언어, ONNX 경유로 CPU에서 돌아갑니다. 코드는 MIT, 모델은 OpenRAIL-M 라이선스.

ASR(음성 입력) 쪽은 Whisper.cpp가 여전히 오랫동안 자리를 지키는 오픈소스 기본값입니다. Supertonic + Whisper.cpp + 로컬 LLM 조합은 대화 수준 레이턴시로 완전 로컬 음성 에이전트를 굴리는 2026년 최초의 스택입니다.

---

## 레이어 7 — 방법론

최고의 도구 스택조차 스스로 프로덕션 에이전트를 출하해주진 않습니다. 설계를 *사고하는* 방법이 필요한데, 그게 바로 **[12-Factor Agents](https://dibi8.com/kr/resources/llm-frameworks/12-factor-agents-production-llm-software-2026/)** (22K+ stars, HumanLayer의 Dex Horthy)가 가져오는 것입니다. Heroku의 2011년 12-Factor App 매니페스토를 본떠 LLM 소프트웨어에 적용한 12개 원칙.

위 레이어들을 가장 직접적으로 지배하는 factor들:

- **Factor 2: 프롬프트를 직접 소유하라** → 레이어 7이 레이어 2의 동작을 지배.
- **Factor 3: 컨텍스트 윈도우를 직접 소유하라** → 레이어 5(메모리)는 애플리케이션이 통제하는 컨텍스트를 생산해야 함.
- **Factor 4: 도구는 구조화된 출력이다** → MCP가 이것을 모든 레이어에 걸쳐 강제.
- **Factor 8: 제어 흐름을 직접 소유하라** → 레이어 2가 블랙박스 에이전트 런타임이어선 안 됨.

[12개 factor 전체 워크스루](https://dibi8.com/kr/resources/llm-frameworks/12-factor-agents-production-llm-software-2026/)도 따로 썼습니다 — 2년 전에 가지고 있었다면 좋았을 문서입니다.

---

## 레이어가 어떻게 조합되는가: 실제 요청 한 건

사용자가 에이전트에게 "레거시 LDAP 서버에 인증하는 모든 곳을 찾아서 새 SSO 모듈을 쓰도록 리팩터해줘"라고 요청했을 때 무슨 일이 벌어지는지 추적해봅시다:

1. **레이어 2 (에이전트 런타임)**가 사용자 메시지를 수신.
2. **레이어 5 (메모리)**에 쿼리 — 에이전트가 LDAP/SSO 마이그레이션 프로젝트에 대해 뭔가 기억하고 있나? 관련 사전 결정을 컨텍스트에 주입.
3. **레이어 3 (심볼 인텔리전스)**에 MCP로 쿼리 — "`LDAP`에 매칭되거나 `ldap_authenticate`를 호출하는 심볼은?" CodeGraph가 200ms 안에 답을 반환.
4. **레이어 4 (비용 통제)**가 모델을 선택 — `rtk`가 계획 프롬프트를 일단 싼 로컬 모델로 라우팅.
5. **레이어 1 (로컬 LLM 런타임)**이 계획을 실행. 계획이 로컬 모델 능력을 넘어서면 `rtk`가 프론티어 모델로 에스컬레이션.
6. **레이어 2**가 루프를 돔: CodeGraph가 찾아낸 각 파일에 대해 편집 서브태스크 실행. 각 서브태스크는 작고 집중된 에이전트(Factor 10).
7. **레이어 6** (음성 모드일 경우): 완료 시 Supertonic이 "리팩터 완료, 파일 17개 변경, 테스트 실패 0건"이라고 안내.
8. **레이어 5**가 다음 세션을 위해 결과를 저장.

모든 레이어가 교체 가능합니다. 결합 조직 — MCP — 이 각 레이어가 말하는 표준입니다.

---

## 현실적인 도입 경로

대부분의 팀은 7개 레이어를 한 번에 다 들이지 못합니다. 우리가 본 작동하는 순서:

### 단계 1 (1–2주차): 비용 통제 쐐기
- 기존 Claude Code / Cursor 사용 앞에 **rtk** 설치.
- 에이전트 설정 통일을 위해 **CC Switch** 설치.
- [12-Factor Agents](https://dibi8.com/kr/resources/llm-frameworks/12-factor-agents-production-llm-software-2026/) 매니페스토를 처음부터 끝까지 정독.

**결과**: 에이전트 동작 변경 제로로 API 지출 50%+ 감소.

### 단계 2 (3–4주차): 심볼 인텔리전스
- 가장 큰 코드베이스에 **CodeGraph** 설치, MCP 서버로 등록.
- 가장 빈도 높은 상위 5개 에이전트 쿼리 감사 — CodeGraph가 커버하나?

**결과**: 1초 미만 심볼 조회, Explore 위주 워크플로에서 추가 30% 토큰 절감.

### 단계 3 (5–8주차): 로컬 런타임
- 타깃 모델의 Q5 양자화로 **vLLM 또는 ds4** 셋업.
- **rtk**를 트래픽의 30%를 로컬로 라우팅하도록 설정. 품질 측정.
- 품질이 유지되면 70%로 상향.

**결과**: 주요 비용 절감; 클라우드 지출이 기본값이 아니라 예외가 됨.

### 단계 4 (2분기): 메모리와 음성
- 에이전트에게 연속성을 주기 위해 **agentmemory** 또는 **MemPalace** 추가.
- 음성 유스케이스가 있다면 TTS용으로 **Supertonic** 평가.

**결과**: 완전 로컬 가능 스택. 프론티어 능력이 필요할 땐 여전히 클라우드 모델을 쓰지만, 더 이상 *의존*하지는 않습니다.

---

## 2026년에 여전히 빠진 것

부족한 부분도 솔직히 말하자면:

- **오픈소스 에이전트 옵저버빌리티는 약합니다.** OSS 세계에 LLM 에이전트용 Datadog 등가물은 아직 없습니다. LangSmith/Langfuse가 있지만 아직 성숙 중.
- **프로덕션 준비된 오픈소스 eval 프레임워크 부재.** "에이전트가 잘 작동한다"는 게 무엇인지가 여전히 팀마다 손으로 짜는 영역입니다.
- **셀프 호스팅 서빙용 GPU 가격**은 여전히 capex나 비싼 클라우드 GPU 임대를 요구합니다. 스케일(약 5만 활성 사용자)에 도달하면 이코노믹스가 뒤집히지만, 작은 팀들은 프리미엄을 내야 합니다.
- **오픈소스 음성 클로닝 품질**은 여전히 최상급 상용 API에 1년쯤 뒤처져 있습니다.
- **멀티 에이전트 조율 패턴**은 초기입니다. 팀마다 새로 발명 중.

이 빈자리들이 다음 라운드 오픈소스 모멘텀이 향할 곳입니다.

---

## 평결

2026년 로컬 우선 AI 스택은 "이 프레임워크 하나 써라"가 아닙니다 — MCP로 묶인 독립적이고 교체 가능한 오픈소스 조각들의 의도적 조합입니다. 그 결과는 다음과 같은 프로덕션 아키텍처:

- 크리티컬 패스 중 무엇도 클라우드 전용이 아니기에 **클라우드 장애에서 살아남습니다**.
- 비용 성장이 사용량 대비 sub-linear이기에 **경제적으로 스케일합니다**.
- 모든 레이어가 팀이 읽을 수 있는 오픈 코드이기에 **감사 가능합니다**.
- 각 레이어의 계약이 독점 SDK가 아니라 MCP이기에 **자연스럽게 조합됩니다**.

스택의 각 컴포넌트는 곧 피벗할 스타트업이 아니라, 잘 유지보수되는 집중된 오픈소스 프로젝트 하나입니다. 도그마는 보수적인데 결과는 역설적으로 클라우드 우선 대안보다 더 공격적입니다 — 비용이 더 이상 "당신이 만들 수 있는 것"의 레이트 리미터가 아니기 때문입니다.

오늘 시작한다면, 이번 주 안에 rtk와 CC Switch를 설치하고, 12-Factor Agents를 정독하고, 월말 안에 가장 많이 쓰는 레포에 CodeGraph를 붙이세요. 나머지는 거기서 따라옵니다.

---

**한눈에 보는 스택** — 북마크해두세요:

| # | 레이어 | 도구 | Stars | 라이선스 |
|---|---|---|---|---|
| 1 | LLM 런타임 | [로컬 LLM 러너 비교](https://dibi8.com/kr/resources/llm-frameworks/local-llm-runner-comparison-2026/) / [ds4](https://dibi8.com/kr/resources/llm-frameworks/ds4-open-source-deepseek-alternative-2026/) | 다양 | Mixed OSS |
| 2 | 에이전트 런타임 | [OpenCode](https://dibi8.com/kr/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/) / [Hermes](https://dibi8.com/kr/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/) / [Codex CLI](https://dibi8.com/kr/resources/llm-frameworks/openai-codex-cli-terminal-ai-coding-agent-2026/) | 각 100K+ | OSS |
| 2.5 | CLI 통합 | [CC Switch](https://dibi8.com/kr/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/) | 74K+ | OSS |
| 3 | 심볼 인텔리전스 | [CodeGraph](https://dibi8.com/kr/resources/dev-utils/codegraph-pre-indexed-knowledge-graph-2026/) | 20K+ | MIT |
| 4 | 비용 통제 | [rtk](https://dibi8.com/kr/resources/llm-frameworks/rtk-rust-cli-proxy-llm-token-savings-2026/) | 45K+ | OSS |
| 5 | 메모리 | [agentmemory](https://dibi8.com/kr/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/) / [MemPalace](https://dibi8.com/kr/resources/ai-tools/mempalace/) | 6.9K+ | OSS |
| 6 | 음성 I/O | [Supertonic](https://dibi8.com/kr/resources/ai-tools/supertonic-on-device-multilingual-tts-2026/) | 9.9K+ | MIT + OpenRAIL-M |
| 7 | 방법론 | [12-Factor Agents](https://dibi8.com/kr/resources/llm-frameworks/12-factor-agents-production-llm-software-2026/) | 22K+ | Apache + CC BY-SA |
| ∗ | 결합 조직 | [MCP — Model Context Protocol](https://dibi8.com/kr/resources/llm-frameworks/mcp-deep-dive-definitive-2026-guide/) | n/a | Anthropic OSS |
