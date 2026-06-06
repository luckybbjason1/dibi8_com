---
title: "9Router: 스마트 LLM 프록시 — 토큰 60% 절약, API 제한 다시는 겪지 않기"
description: "9Router 발견하기 — RTK 무손실 압축 엔진으로 토큰을 20-40% 절약하고, 3단계 스마트 폴백 시스템으로 40개 이상의 AI 모델 공급자를 자동 라우팅하며, 무료로 world-class의 AI 코딩 경험을 실현하는 최신 오픈소스 프록시 인프라."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Docker
  - Go
  - Java
  - JavaScript
  - TypeScript
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "3.2 MB"
file_md5: ""
download_url: "https://github.com/rtk-ai/rtk"
backup_url: ""
github_repo: "https://github.com/rtk-ai/rtk"
stars: 49905
maintainer: "rtk-ai"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /kr/posts/9router-smart-llm-proxy-token-saver-free-coding/
faqs:
  - q: '9Router란 무엇이며 어떻게 작동하나요?'
    a: '9Router는 AI 코딩 도구와 모델 제공업체 사이에 위치하는 오픈소스 셀프 호스팅 스마트 프록시로, 기본적으로 localhost:20128에서 실행됩니다. Claude나 OpenAI를 직접 호출하는 대신, 도구가 9Router로 요청을 보내면 9Router가 지능형 폴백 로직과 토큰 압축을 사용해 40개 이상의 제공업체로 요청을 라우팅합니다.'
  - q: '9Router를 사용하는 데 비용이 드나요?'
    a: '아니요. 9Router 소프트웨어는 오픈소스 MIT 라이선스로 영구 무료이며 사용자 본인의 하드웨어에서 셀프 호스팅됩니다. 결제 인프라가 전혀 없어 절대 요금을 청구하지 않습니다. 사용자는 본인이 설정한 구독이나 API key에 대해서만 제공업체에 직접 비용을 지불하며, 무료 제공업체는 계속 무료로 유지됩니다. 대시보드의 비용 수치는 동등한 유료 API 사용 시 들었을 비용을 보여주는 절감 추적기입니다.'
  - q: '9Router는 AI 토큰 사용량을 얼마나 줄여주나요?'
    a: '내장된 RTK 압축을 통해 9Router는 git diff, grep 결과, 디렉터리 목록 같은 도구 출력을 LLM에 도달하기 전에 압축하여 요청당 입력 토큰을 20-40% 절감합니다. 선택적인 Caveman 모드는 장황한 모델 출력을 최대 65%까지 줄이며, 하루 500회 이상 호출하는 개발자들은 실제 모델 소비가 40-60% 감소했다고 보고합니다.'
  - q: '어떤 AI 코딩 도구와 IDE가 9Router와 함께 작동하나요?'
    a: '사용자 지정 OpenAI 호환 API 엔드포인트를 지원하는 모든 도구는 http://localhost:20128/v1 을 통해 9Router에 연결할 수 있습니다. 지원되는 도구로는 Claude Code, OpenAI Codex CLI, Cursor IDE, GitHub Copilot, Cline, Continue, Roo Code, Antigravity, Droid, Kilo Code, OpenCode가 있습니다.'
  - q: '월 비용 없이 9Router로 AI 코딩을 할 수 있나요?'
    a: '네. Kiro AI(AWS Builder ID, Google, GitHub OAuth를 통한 무료 무제한, API key 불필요), OpenCode Free(인증 없는 패스스루), Vertex AI($300 무료 Google Cloud 크레딧) 같은 무료 제공업체만으로 조합을 구성할 수 있습니다. RTK 압축과 결합하면 말 그대로 월 $0로 프로덕션 품질의 응답을 제공합니다.'
---
{</* resource-info */>}

AI 코딩 어시스턴트 혁명은 개발자들에게 역설적인 딜레마를 안겨주었습니다. Claude Code, OpenAI Codex, Cursor, GitHub Copilot과 같은 도구를 통해 세계적 수준의 언어 모델에前所未有的 접근 권한을 얻었지만, 여러 플랫폼에서 구독, 할당량, 속도 제한을 관리하는 것이 점점 더 비싸고 짜증나는 일이 되었습니다. 많은 개발자들이 Claude Pro 월간 할당량을 2주 만에 소진한 뒤, 스프린트 마감일에 직면하여 속도 제한 벽과 마주하는 경험을 합니다.

**9Router**가 이 문제를 완전히 해결합니다 — 토큰 관리 시스템이자 오픈소스 스마트 프록시입니다. **6,900개 이상의 GitHub 스타**, 1,200개 이상의 포크와 빠른 커뮤니티 성장을 자랑하는 9Router는 프리미엄 티어에 불필요하게 많은 비용을 지출하지 않고maximum AI 능력을 원하는 개발자들의 필수 솔루션이 되었습니다. Node.js 20+, Next.js 16, React 19 기반으로 구축되어, 지능형 폴백 로직과 강력한 토큰 절약 압축으로 40개 이상의 공급자에 AI 코딩 요청을 라우팅할 수 있는 통합 인터페이스를 제공합니다.

## 9Router란 무엇이며 어떻게 작동하나요?

9Router는 로컬 호스트 서비스(기본적으로 `localhost:20128`에서 실행)로, AI 코딩 도구와 백엔드 모델 공급자 사이에 중간 계층으로 동작합니다. 클라우드 코드나 Claude, OpenAI 등 단일 공급자에게 직접 API 요청을 보내는 대신, 모든 요청은 9Router를 통과합니다 — 그러면 9Router가 어느 백엔드 공급자로 요청을 보낼지 지능적으로 결정합니다.

이 아키텍처는 세 가지 주요 장점을 제공합니다:

1. **한 곳에서 다중 공급자 접근**: 대시보드 하나에 Claude, Gemini, GLM, MiniMax, Kiro, OpenCode, Vertex AI 및 40개 이상의 기타 공급자를 구성하세요. CLI 도구는 localhost로 요청을 보내고, 9Router가 나머지를 처리합니다.
2. **자동 폴백**: 주요 공급자가 할당량 한계에 도달하거나 다운되면, 9Router는 두 번째 레이어로 즉시 전환합니다 — 싸운 백업 공급자든 완전 무료 옵션이든. 워크플로우 중단 없이 연속 작업 가능합니다.
3. **머신 외부 전송 전 토큰 압축**: [RTK](https://github.com/rtk-ai/rtk) (~40K 스타)와 통합된 9Router는 도구 출력(`git diff`, `grep` 결과, 디렉토리 목록, 로그 덤프 등)이 LLM에 도달하기 전에 자동으로 압축합니다. 이것만으로도 요청당 입력 토큰을 20-40% 절약할 수 있습니다.

## 9Router를 차별화하는 핵심 기능

### 🚀 RTK 토큰 압축 엔진

도구 출력은 전체 프롬프트 예산의 30-50%를 차지하기도 합니다. Claude Code가 대규모 코드베이스에서 `git diff`, `ls -R`, `grep`을 실행하면 수백만 바이트의 텍스트가 모델로 전송됩니다 — 그중 대부분이 관련 없는 노이즈일 뿐입니다.

9Router의 내장 RTK 기능은 이러한 도구 출력을 자동으로 감지하고 스마트한 무손실 압축 필터를 적용합니다:

- **git-diff**: diff 출력을 변경된 필수 줄로 축소
- **git-status**: 상태 정보를 요약 형식으로 압축
- **grep / find**: 관련 없는 매atches 제거, 컨텍스트 풍부한 행만 유지
- **tree / ls**: 디렉토리 구조를 의미 있게 정리
- **dedup-log**: 반복되는 연속 로그 항목 제거
- **smart-truncate**: 첫 부분과 마지막 부분은 보존하면서 중복 중간 내용 제거

중요한 점은 필터 중 하나가 실패하거나 원본보다 나쁜 출력을 생성하면 RTK가 자동으로 수정되지 않은 텍스트로 돌아가며, 오류가 절대 요청을 망가뜨리지 않습니다. 압축은 모든 형식 변환 **전에** 실행되므로 OpenAI, Claude, Gemini, Cursor, Kiro, OpenAI Responses 등 모든 지원 형식에서 작동합니다.

```
RTK 미사용: LLM에게 47K 토큰 전송
RTK 사용:   LLM에게 28K 토큰 전송 (40% 절약 · 동일한 답변 품질)
```

실제로 많은 개발자가 매 요청마다 20-40%의 토큰 절약을 보고하며 — 이것은 모든 구독의 수명을 며칠 또는几周 연장시키는 효과를 가져옵니다.

### 🪨 케뱅 모드 (출력 압축)

입력 최적화 외에도 9Router는 LLM이 반환하는 내용량도 줄입니다. [Caveman](https://github.com/JuliusBrussee/caveman) (~52K 스타)에서 영감을 받은 "케뱅 스타일" 시스템 프롬프트를 주입하여 9Router가 모델을 간결하게 응답하도록 지시합니다 — 모든 기술적 내용을 보존하면서도 대화형 플러시를 제거합니다.

이를 통해 최대 **65%의 출력 토큰을 절약**할 수 있습니다. 복잡한 리팩토링 작업이나 긴 코드 생성 세션에서는 이러한 절감이 수백 번의 API 호출 동안 급격히 누적됩니다.

### 🎯 스마트 3단계 폴백 시스템

이것이 바로 9Router의 가장 큰 강점입니다. 다른 가격 레이어에 걸친 정렬된 모델 목록인 "콤보"를 정의하면, 9Router는 자동으로 해당 요청을 라우팅합니다:

```
콤보: "my-coding-stack"
  1. cc/claude-opus-4-6        → Claude Code Pro 구독
  2. glm/glm-4.7               → 저가 백업 ($0.6 per 1M 토큰)
  3. kr/claude-sonnet-4.5      → Kiro AI 무료 긴급 폴백
```

Opus 할당량이 고갈되면(또는 에러 발생 시), 9Router는 즉시 GLM으로 전환합니다. GLM도 고갈되면 Kiro의 무료 무제한 레벨로 내려갑니다. 벽에 부딪히는 일이 없습니다.

시스템은 다섯 가지 다른 가격 레이어를 지원합니다:

| 레벨 | 공급자 | typical 비용 | 재설정 패턴 |
|------|--------|-------------|-------------|
| 구독 | Claude Code, Codex, Copilot, Cursor | $10-$200/월 | 5시간 롤링 + 주간/월간 |
| 저가 | GLM-5.1, MiniMax M2.7, Kimi K2.5 | $0.2-$0.6/M 토큰 | 일일/롤링/고정 월간 |
| 무료 | Kiro AI, OpenCode Free, Vertex AI | $0 | 무제한 |

### 📊 실시간 할당량 추적 및 분석

웹 대시보는 각 공급자에 대한 실시간 토큰 소비량, 재설정 카운트다운(5시간, 일일, 주간, 월간) 및 추정 비용 트래킹을 표시합니다. 대시보드가 "비용"을 참조 비교 도구로 표시하지만 — 9Router 자체는 무료 소프트웨어이며 결코 요금을 청구하지 않습니다 — 이러한 분석은 사용 패턴을 이해하고 지출을 최적화하는 데 도움이 됩니다.

Kiro 무료 레벨 사용 중에 대시보드가 "$290 총 비용"을 표시한다면, 이 $290은 해당 API를 직접 사용했을 경우 지불했어야 하는 금액을 나타냅니다. 실제 결제 금액은 여전히 $0입니다. 이것은 당신이 얼마나 많은 돈을 절약하고 있는지 보여주는 savings tracker입니다.

### 🔄 모든 주요 프로토콜 간 형식 번역

9Router는 OpenAI, Claude, Gemini, Cursor, Kiro, Vertex AI, Antigravity, Ollama, OpenAI Responses 형식 간에 투명하게 번역합니다. CLI 도구는 표준 OpenAI 호환 페이로드를 보내고, 9Router는 각 공급자가 기대하는 네이티브 형식으로 번역합니다. 따라서 사용자 지정 OpenAI 엔드포인트를 지원하는 모든 도구를 사용할 수 있으며 어떤 백엔드 공급자에도 연결할 수 있습니다.

### 👥 다중 계정 지원

로드 밸런싱이나 계정의 중복성이 필요한가요? 9Router는 각 공급자에 대해 여러 계정을 추가할 수 있으며, 자동 round-robin 분배 또는 우선순위 기반 라우팅을 지원합니다. 하나의 계정이 할당량에 도달하면 요청이 다음 사용 가능한 계정으로 자동으로 전환됩니다. OAuth 토큰은 자동으로 새로 고쳐져 수동 재인증 주기를 없앱니다.

### 💾 클라우드 동기화

암호화된 클라우드 저장소를 통해 전체 구성 — 공급자, 콤보, 별칭, 설정 — 을 장치 간에 동기화합니다. 로컬 기계에서 완벽한 콤보를 설정한 후 VPS, Docker 배포 또는 동료의 작업대에서 동일한 구성에 접근하세요.

## 지원되는 코딩 도구 및 IDE

9Router는 범용 어댑터로서 거의 모든 인기 AI 코딩 도구를 지원합니다:

- **Claude Code** (`~/.claude/config.json`에 사용자 정의 API 기본 주소 사용)
- **OpenAI Codex CLI** (환경 변수 오버라이드)
- **Cursor IDE** (사용자 정의 OpenAI 엔드포인트 설정)
- **GitHub Copilot**
- **OpenClaw** (WhatsApp, Telegram, Slack 메시징)
- **Cline**
- **Continue**
- **Roo Code**
- **Antigravity**
- **Droid**
- **Kilo Code**
- **OpenCode**

사용자 정의 OpenAI 호환 API 엔드포인트를 지원하는 모든 도구는 9Router에 연결할 수 있습니다. 서비스는 `http://localhost:20128/v1`에서 표준 OpenAI 호환 인터페이스를 노출합니다.

## 시작하기: 설치 및 설정

### 빠른 시작: 로컬호스트 (대부분의 사용자에게 권장)

```bash
# 클론 및 설치
git clone https://github.com/decolua/9router.git
cd 9router
npm install
npm run build

# 선택적 환경 설정
export JWT_SECRET="your-secure-secret-change-this"
export INITIAL_PASSWORD="your-dashboard-password"
export PORT="20128"
export NODE_ENV="production"

# 서버 시작
npm run start
```

시작 후 `http://localhost:20128`을 열어 웹 대시보드에 액세스합니다. 여기서 첫 번째 공급자를 연결합니다.

### Docker 배포

프로덕션 또는 다중 장치 설정의 경우 Docker가 설치를 간단하게 만듭니다:

```bash
docker build -t 9router .

docker run -d \
  --name 9router \
  -p 20128:20128 \
  --env-file ./.env \
  -v 9router-data:/app/data \
  -v 9router-usage:/root/.9router \
  9router
```

### 첫 번째 공급자 연결

결제 수단 없이 완전한 무료 레벨 조합을 설정해 봅시다:

1. **대시보드에서 Kiro AI 연결** (AWS Builder ID, Google 또는 GitHub OAuth 사용 — API 키 필요 없음)
2. **OpenCode Free 연결** (제로 인증, 패스루프 프록시, 모델 자동 검색)
3. **`free-dev`라는 콤보 생성** 포함 모델:
   - `kr/claude-sonnet-4.5` (Kiro를 통한 Claude Sonnet 4.5 — 무료 무제한)
   - `kr/glm-5` (Kiro를 통한 GLM-5 — 무료 무제한)
   - `vertex/gemini-3.1-pro-preview` (Google Cloud — $300 무료 크레딧)

그런 다음 선호하는 도구를 `http://localhost:20128/v1`로 향하도록 구성하고 대시보드 API 키를 사용합니다:

```json
{
  "anthropic_api_base": "http://localhost:20128/v1",
  "anthropic_api_key": "your-9router-api-key"
}
```

### Cursor IDE 구성

Cursor 설정 → 모델 → 고급에서:

```
OpenAI API 기본 주소: http://localhost:20128/v1
OpenAI API 키: [9Router 대시보드에서 복사]
모델: cc/claude-opus-4-7
```

이제 Cursor의 모든 모델 호출이 9Router의 라우팅 인텔리전스를 통해 흐릅니다.

## 실제 사례

### 시나리오 A: 기존 구독 극대화

Claude Pro 월 $20을 지불합니다. 9Router 없이 할당량이 고갈되면 코딩이 재설정 때까지 중단됩니다.

9Router의 "maximize-claude" 콤보 사용:
- 기본: `cc/claude-opus-4-7` (구독 활용)
- 백업: `glm/glm-5.1` ($0.6/M 토큰, 매일 오전 10시 재설정)
- 비상: `kr/claude-sonnet-4.5` (Kiro 무료 폴백)

결과: RTK가 20-40% 토큰을 절약하므로 $20 구독이 더 오래 지속되며, 만료되면 원활한 백업이 있습니다. 저가 레벨의 총 효과 비용은 약 $5만 증가합니다 — Claude Max($200/월) 업그레이드 훨씬 저렴합니다.

### 시나리오 B: 완전 제로 예산

100% 무료 모델로 시작:
- `gc/gemini-3-flash` (Google 월 180K 무료 쿼리)
- `kr/claude-sonnet-4.5` (Kiro 무료 무제한)
- `oc/<auto>` (OpenCode Free, 인증 불필요)

RTK 압축과 결합하여 이 설정은 실제로 월 비용 $0로 프로덕션급 모델 응답을 제공합니다.

### 시나리오 C: 24/7 중단 없는 개발

마감일에 일하는 팀과 프리랜서를 위해 다섯 가지 폴백 레이어 구성:
1. Claude Opus (프리미엄 품질)
2. GPT-5.5 via Codex (두 번째 구독)
3. GLM-5.1 (저렴한 일일 재설정)
4. MiniMax M2.7 (가장 저렴 $0.2/M 토큰, 5시간 롤링 재설정)
5. Kiro Claude Sonnet 4.5 (무료 무제한)

다섯 층이 할당량 고갈이나 공급자 장애에 관계없이 중단 없는 보장을 제공합니다.

## 가격 투명성: 실제로 얼마나 들까요?

9Router를 평가할 때 핵심 질문: **9Router가 요금을 청구합니까?** 아니오. 영원히 아닙니다.

경제적運作 방식은 다음과 같습니다:

- **9Router 소프트웨어 = 평생 무료** (MIT 오픈소스 라이선스, 자체 호스팅)
- **대시보드 비용 = 표시/추적 전용** (실제 청구서가 아님)
- **공급자에게 직접 지불** (구독, API 키, 구성한 것)
- **무료 공급자는 무료 유지** (Kiro AI, OpenCode Free, Vertex AI 크레딧)

9Router는 귀하의 컴퓨터에서 실행되는 순수 로컬 프록시 라우터입니다. 신용카드에 접근할 수 없으며, 송장을 생성할 수 없고, 청구 인프라도 없습니다. 요청을 전달하고 선택적으로 토큰을 압축할 뿐입니다.

대시보드의 비용 표시는 "절약 tracker" 역할을 합니다 — 유료 API를 직접 사용한 경우와 비교하여 얼마나 절약하는지 보여줍니다. 모든 무료 공급자를 구성하면 표시된 비용이 "$290"이라도 실제 은행 거래는 $0입니다. 이 $290은 귀하가 적극적으로 절약하는 돈입니다.

## 9Router vs 타 솔루션 비교

9Router는 기존 솔루션과 어떻게 비교될까요?

| 기능 | 9Router | 직접 공급자 접근 | 기타 프록시 도구 |
|------|---------|---------------|----------------|
| 스마트 폴백 라우팅 | ✅ 자동 3+ 레이어 | ❌ 단일 공급자 | 일부 |
| 토큰 압축 (RTK) | ✅ 내장 | ❌ 없음 | 드문 경우 |
| 다중 형식 번역 | ✅ 8+ 프로토콜 | N/A | 제한적 |
| 다중 계정 회전 | ✅ Round-robin | ❌ 수동 | 수동 |
| 무료 공급자 지원 | ✅ Kiro, OpenCode, Vertex | ❌ 해당 없음 | 보통 없음 |
| 실시간 분석 | ✅ 대시보드 + 로그 | ❌ 공급자 포털 | 기초 |
| 자체 호스팅 | ✅ 완전 제어 | N/A | 다양 |
| 비용 | 무료 소프트웨어 + 공급자 비용 | 완전 공급자 가격 | 종종 유료 |

주의해야 할 주요 대안은 **[OmniRoute](https://github.com/diegosouzapw/OmniRoute)**로, 9Router의 TypeScript 포크입니다. 36+ 공급자, 4단계 자동 폴백, 멀티모달 API(이미지, 임베딩, 오디오, TTS), 서킷 브레이커 패턴, 시맨틱 캐싱, LLM 평가 하니스 등을 추가하며 368개 이상의 유닛 테스트가 포함된 정교한 대시보드를 갖추고 있습니다. OmniRoute는 npm 및 Docker를 통해 이용 가능하여 핵심 9Router 기능 집합을 넘어선 확장 기능을 원하는 사용자에게 적합합니다.

## 왜 지금 9Router가 중요한가

우리는 AI 코딩 도구의 황금기에 살고 있지만, 경제적 현실은 아직 따라오지 못하고 있습니다. 각 주요 공급자는 독립적으로 유료 월벽, 할당량 제한, 속도 캡 뒤에 접근을 제한합니다. Claude, OpenAI, Google, Anthropic, DeepSeek, xAI 사이에서 여섯 개의 서로 다른 구독을 관리하는 것은 재정적 부담과 운영 복잡성을 모두 초래합니다.

9Router는 이러한 모든 공급자를 단일 인텔리전스 레이어를 통해 교체 가능한 상품으로 취급함으로써 이 문제를 해결합니다. 각 작업에 가장 좋은 모델을 얻고, 일반적인 작업에는 가장 저렴한 경로를 선택하고, 할당량이 고갈될 때 보장된 가용성을 제공하며 — 머신을 떠나기 전에 토큰 낭비를 압축합니다.

RTK 토큰 압축(~20-40% 절약), 케뱅 모드 출력 감소(~65% 절약), 스마트 다중 레이어 폴백의 결합은 복리적 효과를 만듭니다. 하루 500+回の API 호출을 사용하는 개발자들은 효과적인 모델 소비량이 40-60% 감소하는 것을 보고하며, $200/월 AI 스택을 $20-30 수준으로 관리 가능하게 변화시켰습니다.

## 기술 아키텍처 하이라이트

9Router는 신뢰성에 최적화된 현대 JavaScript 스택으로 구축되었습니다:

- **런타임**: Node.js 20+ — 일관되고 고성능의 비동기 I/O
- **프레임워크**: Next.js 16 + React 19 — 웹 대시보드용
- **데이터베이스**: LowDB (JSON 파일 기반) — 단순하고 이식 가능하며 버전 관리 가능한 설정
- **스트리밍**: Server-Sent Events (SSE) — 실시간 진행 피드백용
- **인증**: OAuth 2.0 + PKCE, JWT 세션 쿠키, HMAC 서명 API 키
- **프록시**: 전체 HTTP 투과성과 구성 가능한 상위 프록시

환경 변수는 배포에 대한 세밀한 통제를 제공합니다:
- `JWT_SECRET`: 프로덕션에서 변경 권장
- `REQUIRE_API_KEY`: `/v1/*` 경로에 bearer token 인증 강제
- `ENABLE_REQUEST_LOGS`: 디버그 수준 요청/응답 로그 기록 활성화
- `AUTH_COOKIE_SECURE`: HTTPS 리버스 프록시 뒤에서 Secure 쿠키 플래그 강제
- `HTTP_PROXY` / `HTTPS_PROXY`: 기업 프록시를 통해 상위 요청 라우팅

서비스는 기본적으로 포트 `20128`에서 수신하며, `${DATA_DIR}`에 저장된 JSON 파일 외에는 외부 종속성이나 데이터베이스가 필요하지 않습니다.

## 마무리 생각

9Router는 더 많은 개발자들이 느끼기 시작하는 진정한 고통스러운 문제를 해결합니다. AI 도구 구독이 증가함에 따라 우리는 escalating costs와 임의적인 제한을 AI 보조 개발의 불가피한 가격으로 받아들이지 않고, 9Router가 방식을 바꿔놓습니다: 이미 가진 공급자를 사용하고, 저렴하거나 무료 대체재로 결측 부분을 채우고, 가능한 모든 것을 압축하며, 할당량 상태와 상관없이 연속적인 코딩 흐름을 유지합니다.

비즈니스 제약이 있는 솔로 개발자에게는 free-first 전략으로 정확히 $0의 비용으로 완전히 기능하는 AI 코딩 보조를 제공할 수 있습니다. 프리미엄 구독에 투자할 의향이 있는 팀에게는 토큰 압축과 스마트 라우팅이 모든 달러를 더 멀리 늘려주며 ROI를 극대화합니다.

무료이고 오픈소스이며 몇 분이면 자체 호스팅할 수 있습니다. 현재 AI 도구 가격 추세를 고려할 때, 9Router를 개발 인프라에 추가하는 것은 단순히 유용한 수준을 넘어 필수불가결 해지고 있습니다.

**저장소**: [github.com/decolua/9router](https://github.com/decolua/9router)
**웹사이트**: [9router.com](https://9router.com)

---

## 관련 글


- [GenericAgent: 자기 진화 AI 에이전트 프레임워크](/resources/llm-frameworks/hermes-agent-self-improving-ai-agent.ko/)
- [Anthropic Financial Services: AI 기반 Claude 에이전트](/resources/llm-frameworks/anthropic-financial-services-ai-finance-automation.ko/)

- [Addy Osmani Agent Skills: 프로덕션-grade AI 코딩 에이전트](/resources/llm-frameworks/agent-skills-production-grade-ai-coding.ko/)

---

## 추천 도구

오픈소스 AI 도구 개발/배포 시 권장:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전, AI 워크로드용 원클릭 droplet.
- **{{< aff "shiyunapi" "footer-cta-legacy" "Shiyunapi Claude API" >}}** — Claude / OpenAI / DeepSeek API 프록시. 키 하나로 여러 최상위 모델 액세스, 공식 가격의 ~30%; 모델 비교나 직접 API 액세스가 제한된 지역에서 특히 유용.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

