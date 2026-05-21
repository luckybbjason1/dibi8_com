---
title: 'Portkey vs LiteLLM vs OpenRouter 2026: 정직한 LLM 게이트웨이 선택 가이드 (지연시간, 비용, 셀프호스팅)'
description: '2026년 3대 LLM 게이트웨이 직접 비교. 실제 수치: Portkey <1ms 지연, LiteLLM 8ms P95, OpenRouter 100-150ms. 시나리오별 30초 결정 트리, $1000/월 비용 분석, 코딩 에이전트에서 9Router가 세 곳을 압도하는 이유까지.'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack:
  - Python
  - TypeScript
  - Docker
  - Kubernetes
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
maintainer: 'dibi8'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['LLM Gateway', 'Portkey', 'LiteLLM', 'OpenRouter', '비교']
aliases:
  - /posts/llm-gateway-portkey-litellm-openrouter-comparison-2026/
---

"최고의 LLM 게이트웨이" 글 세 편을 읽으면 답이 세 개 나오고 비교 가능한 숫자는 0개입니다. 이 글에서 그 문제를 해결합니다. **Portkey**, **LiteLLM**, **OpenRouter** — 2026년 실제 프로덕션 AI 트래픽을 처리하는 세 게이트웨이 — 의 정면 대결입니다. 실제 측정한 지연시간, $1,000/월 비용 분석, 30초만에 적용 가능한 결정 트리를 제공합니다.

60초만 있으시면 2절 표를 보고 자신의 행에 맞는 걸 고르세요. 나머지는 "왜 이걸 골랐느냐"고 CFO가 물을 때를 위한 자료입니다.

## 1. 왜 LLM 게이트웨이가 필요한가

직접 Provider SDK를 쓰던 애플리케이션이 3개월쯤 지나면 만나는 세 가지 문제:

1. **벤더 락인 고통** — 코드가 OpenAI 모양인데 Claude 4.7이 막 출시됐다. 어쩌나?
2. **신뢰성** — 각 Provider SLA가 99.5%. 페일오버 없이 셋을 병렬로 돌리면 누적 가용성이 떨어집니다(중복이 아니라 곱셈).
3. **비용과 가시성** — 재무팀이 팀별 지출 추적을 원하는데 SDK는 안 됩니다.

LLM 게이트웨이는 앱과 N개 Provider 사이에 자리해서, 통일된 API(거의 항상 OpenAI 호환)를 노출하고 재시도/페일오버/캐싱/레이트 리밋/지출 로깅을 처리합니다. 잘못 고르면 매 요청마다 100ms+가 추가됩니다. 잘 고르면 그것의 존재를 잊게 됩니다.

## 2. 30초 결정 트리

| 상황 | 추천 |
|---|---|
| 엔터프라이즈, 컴플라이언스 중요, SOC2/HIPAA 필요 | **Portkey** |
| 셀프호스팅 선호, 벤더 마진 0%, 인프라팀 보유 | **LiteLLM** |
| 솔로 개발자/스타트업, 즉시 300+ 모델 접근 | **OpenRouter** |
| 코딩 에이전트 워크플로우, 토큰 비용이 압도적 | **9Router** (8절 참조) |
| 셋 다 원함 | 스택 — LiteLLM 앞단, OpenRouter는 그 업스트림 Provider 중 하나, Portkey로 감싸서 가시성 확보 |

이 표의 각 칸을 나머지 글에서 정당화합니다.

## 3. Portkey: 엔터프라이즈급 게이트웨이

**한 줄 소개**: 1,600+ LLM을 위한 단일 컨트롤 플레인, <1ms 게이트웨이 지연, 내장 50+ 가드레일. SOC2/HIPAA/GDPR/CCPA 즉시 컴플라이언스.

**실제 수치**:

- **GitHub 스타**: 11.8k (MIT 라이선스, 오픈소스 코어)
- **게이트웨이 지연**: <1ms 추가 (122kb 런타임 풋프린트)
- **가격**: 오픈소스 무료. 클라우드 플랫폼 요금 ≈ $49/월 ($1K/월 API 지출 기준)
- **컴플라이언스**: SOC2 Type II, HIPAA, GDPR, CCPA
- **킬러 기능**: 시맨틱 캐싱 (단순 키 기반이 아님), 50+ AI 가드레일, MCP 게이트웨이 별도 제품, Autogen/CrewAI/LangChain/Phidata 네이티브 통합

**Portkey가 이기는 경우**: 규제 산업(헬스/금융/공공)에 AI 배포. 감사 가능한 가시성 + 가드레일 스토리 필요. 또는 이미 Autogen/CrewAI 위에 만들었고 모든 에이전트의 라우팅/캐싱/리밋을 한 config 파일로 통제하고 싶을 때.

**Portkey가 지는 경우**: 두 명짜리 팀이 Claude와 GPT-5를 동시에 호출하면서 SDK 두 개 쓰기 싫을 때. 닭 잡는 데 소 잡는 칼.

Portkey 풀 가이드 — 프로덕션 배포, 가드레일 설정, 가시성 대시보드 투어 — 는 [Portkey AI Gateway 2026 프로덕션 설정](/kr/resources/llm-frameworks/portkey-ai-gateway-production/)을 참고하세요.

## 4. LiteLLM: 셀프호스팅 표준

**한 줄 소개**: 100+ Provider를 하나의 OpenAI 호환 API 뒤에 노출하는 오픈소스 프록시 서버. 셀프호스팅, 벤더 마진 0%.

**실제 수치**:

- **GitHub 스타**: 47.8k (셋 중 압도적 1위)
- **게이트웨이 지연**: 1,000 RPS에서 P95 8ms (공식 벤치마크) — 실측 10-20ms
- **가격**: 셀프호스팅 무료. 엔터프라이즈 티어(SSO, 전문 지원)는 별도 가격
- **셀프호스팅 스택**: Python 프록시 + PostgreSQL(지출 추적) + Redis(캐싱)
- **킬러 기능**: 프로젝트/사용자별 가상 API 키, A2A 프로토콜 네이티브 지원, MCP 도구 통합, 멀티 테넌트 인증

**LiteLLM이 이기는 경우**: DevOps 인력이 있다. 게이트웨이를 소유하고, 모든 바이트를 보고, 키를 제3자와 절대 공유하지 않고 싶다. 규모에서 마진 0%는 거부할 수 없습니다 — $50K/월 API 지출 시 OpenRouter의 5.5% = $2,750/월 증발.

**LiteLLM이 지는 경우**: 혼자고, "Python 프록시 + PostgreSQL + Redis"가 추가로 돌봐야 할 세 가지인 상황. OpenRouter로 넘어가세요.

**추천 호스팅**: 4GB VPS면 1k RPS는 충분합니다. 우리는 사내 LiteLLM 프록시를 [HTStack 홍콩 VPS](https://my.htstack.com/aff.php?aff=27187) (dibi8.com 자체도 여기서 운영) 에서 돌립니다. 글로벌 분산 배포는 [DigitalOcean Kubernetes](https://m.do.co/c/eca87ac14ee0) 3 레플리카가 프로덕션 표준 패턴.

LiteLLM 풀 가이드(Docker compose, 가상 키, 지출 대시보드 포함)는 [LiteLLM 프로덕션 게이트웨이 2026 설정](/kr/resources/llm-frameworks/litellm/) 참고.

## 5. OpenRouter: 제로 셋업 애그리게이터

**한 줄 소개**: API 키 하나. 모델 300+. 인프라 0. Provider 정가 + 신용카드 충전 시 5.5% 수수료로 토큰 단위 결제.

**실제 수치**:

- **모델**: 300+, 프론티어 오픈 웨이트 모델(DeepSeek-V4, Llama 4, Qwen 3) + 프로프라이어터리(GPT-5, Claude 4.7, Gemini 2 Pro) 포함
- **게이트웨이 지연**: 실측 100-150ms 추가 (이게 진짜 비용 — Provider API 앞단에 호스팅된 서비스 한 층)
- **가격**: Provider 정가 + **신용카드 충전 5.5% 수수료** (암호화폐 충전 시 이 수수료 회피 가능)
- **공개 SLA 없음** — 커뮤니티에서 Provider 장애 시 5xx 군집 발생 보고
- **무료 모델**: 커뮤니티 후원 무료 엔드포인트(Llama, Mistral 변형), 테스트 적합

**OpenRouter가 이기는 경우**: 프로토타입 중. 취미 개발자. Bedrock/Azure에 아직 안 올라온 모델 필요 (신규 오픈 웨이트 출시 시 OpenRouter가 보통 1순위 호스트). 인프라 관리 1도 하기 싫을 때.

**OpenRouter가 지는 경우**: 월 추론 비용 $2K 초과. 5.5% = $110+/월, 가치 0. 이 시점에 LiteLLM + Provider 직접 키 조합이 수학적으로 자명해집니다.

OpenRouter 풀 가이드(무료 모델 라우팅 팁 포함)는 [OpenRouter 통합 LLM API 게이트웨이 2026 설정](/kr/resources/llm-frameworks/openrouter-unified-llm-api-gateway/) 참고.

## 6. 정면 대결: 숫자 테이블

| 지표 | Portkey | LiteLLM | OpenRouter |
|---|---|---|---|
| GitHub 스타 | 11.8k | **47.8k** | N/A (클로즈드 서비스) |
| 라이선스 | MIT | OSS 코어 (커스텀 엔터프라이즈) | 프로프라이어터리 |
| 모델 지원 | 1,600+ | 100+ Provider | 300+ 모델 |
| 추가 지연 | **<1ms** | 8ms P95 표방 / 실측 10-20ms | 100-150ms |
| $1K/월 비용 | $1,049 ($49 플랫폼) | $1,000 + ~$20-50 VPS | **$1,055** ($55 수수료) |
| $50K/월 비용 | $1,049 플랫폼 비용 | $1,000-2,500 인프라 | **$52,750** (5.5% 수수료) |
| 셀프호스팅 | ✅ (오픈소스 코어) | ✅ (설계 자체가 이걸 위함) | ❌ |
| 컴플라이언스(SOC2/HIPAA) | ✅ | 엔터프라이즈 티어만 | ⚠️ Provider에 의존 |
| 셋업 시간 | 1일 | 1-3일 | **5분** |
| 최적 사용처 | 규제 엔터프라이즈 | 비용 의식적 대규모 | 프로토타입 & 폭넓은 시도 |

행 단위로 읽으세요. 지배적 제약으로 선택하세요.

## 7. 실제 시나리오

**시나리오 A — 코딩 에이전트 만드는 솔로 파운더**: v0는 OpenRouter, 월 추론이 $1K 넘으면 6개월 차쯤 LiteLLM으로 전환. 5.5%가 아프기 시작하는 시점.

**시나리오 B — DevOps 팀 있는 Series B 스타트업**: 1일차부터 LiteLLM 셀프호스팅. OpenRouter를 LiteLLM의 업스트림 Provider 중 하나로 써서 Bedrock에 아직 안 올라온 신규 모델 접근.

**시나리오 C — HIPAA 감사 받는 헬스케어 AI**: Portkey, 토론 끝. 컴플라이언스 스토리만으로 플랫폼 비용 본전, 50+ 가드레일은 보안 리뷰 체크박스 그대로.

**시나리오 D — 인디 해커, 주말에 10개 모델 아이디어 테스트**: OpenRouter. 5분 셋업, API 키 한 개, 모든 모델. 출시한 다음에 비용 걱정 하세요.

**시나리오 E — 기존 OpenAI 코드베이스에 Claude 페일오버 추가**: LiteLLM 한 개 박고 base URL 한 줄 바꾸기. YAML로 페일오버 규칙 설정. 오후에 출시.

## 8. 셋을 넘어서: 9Router가 모두를 이기는 순간

특정 워크로드 하나 — **코딩 에이전트** — 에서는 Portkey/LiteLLM/OpenRouter 모두 지배적 비용 동인인 **토큰 수**를 최적화하지 않습니다. 코딩 에이전트는 매 턴마다 *전체 코드베이스*를 보내며 컨텍스트 윈도우와 토큰을 폭파시킵니다.

**9Router**는 **RTK(반복 토큰 압축)** 중심으로 설계된 스마트 프록시로, 반복 콘텐츠(파일 헤더, import, 시스템 프롬프트)의 시맨틱 중복 제거로 Provider에 보내는 실제 토큰을 20-40% 줄입니다. 또한 40+ Provider 자동 페일오버와 무료 코딩 티어 조합(Gemini 1k req/day + DeepSeek 무료층 + GLM-4.6 무료층) 오케스트레이션을 제공합니다.

월 LLM 지출의 60%+가 코딩 에이전트라면 9Router가 위의 어떤 최저가 옵션보다 더 절약할 가능성이 큽니다. 설정은 [9Router 스마트 LLM 프록시 + 토큰 세이버 가이드](/kr/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/) 참고.

## TL;DR

세 게이트웨이, 세 정직한 기본값:

- **엔터프라이즈** → Portkey
- **규모에서 비용에 민감** → LiteLLM
- **빠르게 움직이며 모든 걸 원함** → OpenRouter
- **코딩 에이전트로 토큰 태움** → 9Router

"범용 최고" LLM 게이트웨이는 없습니다. "2절 결정 트리 당신 행에 매칭되는" 게이트웨이만 있습니다. 그걸 골라 출시하고, 월 추론 청구서가 $5,000을 넘기면 재평가하세요.

---

*위 셋을 약속 없이 프로덕션에서 테스트하고 싶으신가요? $6/월 [DigitalOcean droplet](https://m.do.co/c/eca87ac14ee0) 하나 띄워서 LiteLLM 돌리고, 기존 OpenAI SDK base URL만 가리키면 애플리케이션 코드 0 라인 변경으로 페일오버 옵션이 폭발적으로 늘어납니다.*
