---
title: Hermes Agent：자기 진화하는 AI 에이전트, 사용할수록 당신을 더 잘 이해합니다
description: Hermes Agent는 Nous Research가 만든 오픈소스 AI 에이전트로, 자체 학습 루프를 통해 경험에서 스킬을
  생성하고, 지속적으로 개선하며, 당신의 선호도를 기억합니다.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Python
- TypeScript
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "210.6 MB"
file_md5: ''
download_url: https://github.com/NousResearch/hermes-agent
backup_url: ''
github_repo: https://github.com/NousResearch/hermes-agent
stars: 156248
maintainer: "NousResearch"
last_maintained: "2026-05-16"
featureImage: ''
draft: false
aliases:
- /ko/posts/hermes-agent-self-improving-ai-agent/
- /posts/genericagent-self-evolving-ai-agent.ko/
faqs:
  - q: 'Hermes Agent는 Claude Code, Cursor, GitHub Copilot 같은 도구와 무엇이 다른가요?'
    a: 'Hermes Agent에는 내장된 자가 학습 루프, 세션 간 지속되는 메모리, 그리고 그런 도구들에는 없는 스킬 시스템이 있습니다. 또한 6개의 메시징 플랫폼에서 동작하고, cron 스케줄링과 MCP를 지원하며, 오픈 소스이자 셀프 호스팅이 가능합니다. 반면 다른 도구들은 CLI, 데스크톱, 또는 IDE 전용이며 구독료나 API 요금을 부과합니다.'
  - q: 'Hermes Agent의 자기 개선 루프는 어떻게 작동하나요?'
    a: '작업을 완료한 후 Hermes는 무엇이 효과적이었고 무엇이 그렇지 않았는지 분석하고, 재사용 가능한 패턴을 추출하며, 그 접근 방식을 문서화한 스킬 파일을 생성하고, 유사한 작업에서 해당 스킬을 테스트한 뒤, 결과를 바탕으로 이를 다듬습니다. 시간이 지나면서 이는 사용자만의 고유한 개인 스킬 라이브러리를 구축합니다.'
  - q: 'Hermes Agent는 세션 간에 어떤 종류의 메모리를 유지하나요?'
    a: 'Hermes는 두 가지 유형의 메모리를 유지합니다. 사용자 프로필 메모리(코딩 스타일, 프로젝트, 선호하는 도구, 커뮤니케이션 선호도, 자주 하는 실수)와 세션 메모리(현재 프로젝트 컨텍스트, 최근 명령어와 출력, 편집한 파일)입니다. 프로필 메모리는 컴퓨터를 재시작한 후에도 유지됩니다.'
  - q: 'Hermes Agent는 어떤 메시징 플랫폼에서 실행할 수 있나요?'
    a: 'Hermes Agent는 Telegram, Discord, Slack, WhatsApp, Signal, Email에서 멀티 플랫폼 메시징 봇으로 동작하며, 모두 `hermes gateway setup` 명령으로 구성됩니다. 동일한 명령어와 스킬이 모든 플랫폼에서 그대로 작동합니다.'
  - q: 'Hermes Agent는 어떻게 설치하고 LLM 제공자를 구성하나요?'
    a: 'Linux, macOS 또는 WSL2에서는 한 줄짜리 curl 스크립트를 bash로 파이프하여 설치하거나, 저장소를 클론한 뒤 `./setup-hermes.sh`를 실행할 수 있습니다. 그런 다음 `hermes config set provider openai`와 `hermes config set model gpt-4o` 같은 명령으로 제공자를 설정하거나, `hermes config set provider ollama`를 통해 로컬 모델을 사용할 수 있습니다.'
---
{</* resource-info */>}

## 문제: 대부분의 AI 에이전트는 당신을 잊어버립니다

AI 어시스턴트에게 당신의 워크플로우, 코딩 스타일, 프로젝트 구조를 가르치는 데 몇 시간을 보냅니다. 그런 다음 새 세션을 시작하면 — 모든 것이 사라집니다. 에이전트는 매번 당신을 낯선 사람처럼 대합니다.

이것이 오늘날 대부분의 AI 에이전트의 근본적인 한계입니다: **메모리가 없고, 학습이 없고, 성장이 없습니다**. 설계상 상태를 유지하지 않으므로, 강력한 도구이지만 끔찍한 장기 파트너입니다.

**Hermes Agent**는 급진적인 접근 방식으로 이 문제를 해결합니다: 내장 학습 루프를 가진 유일한 에이전트입니다.

## Hermes Agent란 무엇인가?

[Hermes Agent](https://github.com/NousResearch/hermes-agent)는 [Nous Research](https://nousresearch.com)가 만든 오픈소스 AI 에이전트입니다 — Hermes 오픈소스 대규모 언어 모델 시리즈를 만든 바로 그 팀입니다. GitHub에서 **136,579+ 스타**와 **20,960+ 포크**를 보유하고 있으며, 현존하는 가장 인기 있는 AI 에이전트 프레임워크 중 하나입니다.

프로젝트의 슬로건이 모든 것을 설명합니다: **"당신과 함께 성장하는 에이전트."**

다른 에이전트가 정적인 도구인 것과 달리, Hermes Agent는:
- **경험에서 스킬을 생성합니다** — 당신의 워크플로우를 학습하고 재사용 가능한 스킬로 저장합니다
- **사용 중에 스킬을 개선합니다** — 피드백을 기반으로 능력을 정제합니다
- **세션 간에 지식을 유지합니다** — 당신이 누구인지, 무엇을 좋아하는지 기억합니다
- **당신에 대한 깊은 모델을 구축합니다** — 사용할수록 당신을 더 잘 이해합니다

## 핵심 기능

### 1. 내장 학습 루프

Hermes Agent의 핵심 혁신은 **자기 개선 사이클**입니다:

```
경험 → 반성 → 스킬 생성 → 실습 → 개선
```

Hermes로 작업을 완료하면 다음을 수행합니다:
1. **분석** — 무엇이 효과적이었고 무엇이 아니었는지
2. **추출** — 재사용 가능한 패턴
3. **생성** — 접근 방식을 문서화하는 스킬 파일
4. **테스트** — 유사한 작업에서 스킬 테스트
5. **정제** — 결과를 기반으로 개선

시간이 지남에 따라 이것은 당신만의 **개인 스킬 라이브러리**를 만듭니다.

### 2. 40+ 내장 도구

Hermes Agent는 포괄적인 도구 세트와 함께 제공됩니다:

| 도구 카테고리 | 예시 |
|-------------|---------|
| **파일 작업** | 읽기, 쓰기, 검색, 차이 비교, 패치 |
| **터미널** | 명령 실행, 셸 세션, 백그라운드 작업 |
| **웹** | 브라우징, 스크래핑, 다운로드, API 호출 |
| **코드** | 구문 검사, 린트, 포맷팅, 테스트 |
| **Git** | 커밋, 브랜치, 차이, 로그, PR 리뷰 |
| **시스템** | 프로세스 관리, 파일 모니터링, 크론 작업 |

**툴셋 시스템**을 사용하면 필요한 도구만 활성화하여 토큰 사용량을 줄이고 집중력을 높일 수 있습니다.

### 3. 스킬 시스템 (절차적 메모리)

스킬은 Hermes Agent의 비밀 무기입니다. 이들은 다음을 캡처하는 **재사용 가능한 절차 파일**입니다:

- **트리거 조건** — 이 스킬을 사용할 시기
- **단계별 지침** — 무엇을 할 것인지
- **함정** — 피해야 할 일반적인 실수
- **검증 단계** — 성공을 확인하는 방법

스킬은 다음과 같은 방식으로 사용할 수 있습니다:
- **자동 생성** — 성공적인 작업 완료에서
- **스킬 허브에서 다운로드** — 커뮤니티 기여 스킬
- **수동 작성** — 특정 워크플로우용
- **다른 사용자와 공유**

### 4. 영구 메모리

Hermes Agent는 **두 가지 유형의 메모리**를 유지합니다:

**사용자 프로필 메모리**:
- 선호하는 코딩 스타일
- 작업 중인 프로젝트
- 좋아하는 도구
- 커뮤니케이션 선호도
- 자주 저지르는 실수 (이를 잡아낼 수 있도록)

**세션 메모리**:
- 현재 프로젝트 컨텍스트
- 최근 명령과 출력
- 편집 중인 파일
- 이 세션의 대화

이 메모리는 세션 간에 지속되므로 컴퓨터를 다시 시작해도 Hermes는 **당신을 기억합니다**.

### 5. 메시징 게이트웨이

Hermes Agent는 단순한 CLI 도구가 아닙니다 — **멀티플랫폼 메시징 봇**입니다:

| 플랫폼 | 설정 | 사용 사례 |
|---------|-------|---------|
| **Telegram** | `hermes gateway setup` | 모바일 AI 어시스턴트 |
| **Discord** | `hermes gateway setup` | 팀 협업 |
| **Slack** | `hermes gateway setup` | 직장 통합 |
| **WhatsApp** | `hermes gateway setup` | 개인 어시스턴트 |
| **Signal** | `hermes gateway setup` | 프라이버시 중심 |
| **Email** | `hermes gateway setup` | 비동기 워크플로우 |

구성이 완료되면 이러한 플랫폼 중 하나에서 동일한 명령과 스킬을 사용하여 Hermes와 채팅할 수 있습니다.

### 6. MCP 통합

Hermes Agent는 **모델 컨텍스트 프로토콜(MCP)**을 지원하여 확장 기능을 위해 모든 MCP 서버에 연결할 수 있습니다:

- **데이터베이스 서버** — SQL 데이터베이스 쿼리
- **파일 서버** — 원격 파일 시스템에 액세스
- **API 서버** — 모든 REST API와 상호 작용
- **사용자 정의 서버** — 자체 통합 구축

이를 통해 Hermes는 무한하게 확장 가능합니다 — MCP 서버를 구축할 수 있다면 Hermes는 사용할 수 있습니다.

### 7. 크론 스케줄링

Hermes Agent는 내장된 크론 시스템을 통해 **예약된 작업**을 실행할 수 있습니다:

```bash
# 매일 오전 9시에 스킬 실행
hermes cron add --skill "daily-report" --schedule "0 9 * * *"

# 매주 백업 실행
hermes cron add --skill "backup-database" --schedule "0 2 * * 0"

# 모든 예약 작업 목록
hermes cron list
```

일정에 따라 실행되어야 하는 자동화 워크플로우에 적합합니다.

### 8. 보안 기능

Hermes Agent는 보안을 중요하게 생각합니다:

- **명령 승인** — 위험한 명령은 명시적 확인이 필요합니다
- **DM 페어링** — 민감한 작업 전에 신원을 확인합니다
- **컨테이너 격리** — 신뢰할 수 없는 코드를 격리된 환경에서 실행
- **감사 로깅** — 모든 작업이 검토를 위해 기록됩니다

## 빠른 시작

### 설치

```bash
# 한 줄 설치 (Linux, macOS, WSL2)
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# 또는 수동으로 클론 및 설정
git clone https://github.com/NousResearch/hermes-agent.git
cd hermes-agent
./setup-hermes.sh
```

### 첫 대화

```bash
source ~/.bashrc    # 셸 다시 로드
hermes              # 채팅 시작
```

### 공급자 구성

```bash
# 선호하는 LLM 공급자 설정
hermes config set provider openai
hermes config set model gpt-4o

# 또는 로컬 모델 사용
hermes config set provider ollama
hermes config set model llama3.1
```

### 유용한 명령

```bash
# 새 대화 시작
/new

# 즉석에서 모델 변경
/model anthropic:claude-3-5-sonnet

# 개성 설정
/personality developer

# 사용량 확인
/usage

# 사용 가능한 스킬 찾아보기
/skills

# 특정 스킬 사용
/hugo-blog-deploy

# 토큰 절약을 위해 컨텍스트 압축
/compress
```

## 아키텍처

Hermes Agent는 모듈식 아키텍처로 구축되었습니다:

```
Hermes Agent
├── CLI 인터페이스 (터미널 UI)
├── 메시징 게이트웨이 (Telegram, Discord 등)
├── 에이전트 코어 (추론 엔진)
├── 스킬 시스템 (절차적 메모리)
├── 메모리 저장소 (영구 저장)
├── 툴셋 관리자 (40+ 도구)
├── MCP 클라이언트 (외부 통합)
├── 크론 스케줄러 (자동화 작업)
└── 보안 계층 (승인, 격리)
```

전체 시스템은 **Python** (2800만+ 라인)으로 작성되었으며, 웹 인터페이스에는 TypeScript 구성 요소가 사용됩니다.

## 사용 사례

### 개발자용
- **코드 리뷰 어시스턴트** — Hermes가 코드베이스를 학습하고 PR을 검토합니다
- **DevOps 자동화** — 인프라 배포, 모니터링 및 문제 해결
- **문서 작성기** — 코드 주석에서 문서 자동 생성
- **버그 헌터** — 과거 버그를 유발한 패턴 검색

### 팀용
- **공유 스킬 라이브러리** — 팀 전체의 모범 사례를 재사용 가능한 스킬로
- **온보딩 가속기** — 신규 팀원이 팀 지식에 즉시 액세스
- **24/7 운영** — 크론 작업이 일상적인 유지 관리를 처리합니다
- **멀티플랫폼 액세스** — Slack, Discord 또는 Telegram에서 Hermes와 채팅

### 파워 유저용
- **개인 지식 기반** — Hermes가 가르치는 모든 것을 기억합니다
- **워크플로우 자동화** — 복잡한 다단계 작업이 하나의 명령이 됩니다
- **크로스 플랫폼 어시스턴트** — 데스크톱, 모바일 및 웹에서 동일한 어시스턴트
- **사용자 정의 통합** — 특정 도구용 MCP 서버 구축

## 성능 비교

| 기능 | Hermes Agent | Claude Code | Cursor | GitHub Copilot |
|---------|-------------|-----------|--------|----------------|
| **자기 학습** | ✅ 예 | ❌ 아니오 | ❌ 아니오 | ❌ 아니오 |
| **영구 메모리** | ✅ 예 | ❌ 아니오 | ❌ 아니오 | ❌ 아니오 |
| **스킬 시스템** | ✅ 예 | ❌ 아니오 | ❌ 아니오 | ❌ 아니오 |
| **멀티플랫폼** | ✅ 6개 플랫폼 | ❌ CLI 전용 | ❌ 데스크톱 전용 | ❌ IDE 전용 |
| **오픈소스** | ✅ 예 | ❌ 아니오 | ❌ 아니오 | ❌ 아니오 |
| **크론 스케줄링** | ✅ 예 | ❌ 아니오 | ❌ 아니오 | ❌ 아니오 |
| **MCP 지원** | ✅ 예 | ❌ 아니오 | ❌ 아니오 | ❌ 아니오 |
| **무료 계층** | ✅ 자체 호스팅 | 💰 API 비용 | 💰 구독 | 💰 구독 |

## 한계

- **학습 곡선** — 스킬 시스템은 사전 투자가 필요합니다
- **로컬 설정** — 자체 호스팅에는 기술 지식이 필요합니다
- **리소스 사용** — 영구 메모리는 시간이 지남에 따라 저장 공간을 소비합니다
- **공급자 비용** — LLM API 호출은 여전히 비용이 듭니다 (로컬 모델을 사용하지 않는 한)

## 결론

Hermes Agent는 AI 어시스턴트에 대해 생각하는 방식의 **근본적인 전환**을 대표합니다. AI를 일회성 도구로 취급하는 대신, Hermes는 **당신과 함께 성장하는 장기 파트너**로 취급합니다.

자기 개선 루프, 영구 메모리 및 스킬 시스템은 복리 효과를 만듭니다: Hermes를 더 많이 사용할수록 더 가치 있게 됩니다. 이것은 시간이 지남에 따라 감소하는 수익을 제공하는 기존 AI 도구와 정반대입니다.

매번 세션마다 AI 어시스턴트에게 같은 것을 다시 가르치는 것에 지쳤다면, Hermes Agent를 탐색해 볼 가치가 있습니다.

**GitHub**: [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)  
**문서**: [hermes-agent.nousresearch.com/docs](https://hermes-agent.nousresearch.com/docs/)  
**스타**: 136,579+ | **포크**: 20,960+ | **라이선스**: 오픈소스  

Hermes Agent를 사용해 보셨나요? 자기 개선하는 AI 에이전트에 대한 경험이 있으신가요? 댓글에서 생각을 공유해 주세요.

## 관련 기사

- [Agent Reach: AI 에이전트에 인터넷 슈퍼파워 부여하기](/kr/resources/llm-frameworks/agent-reach-ai-agent-internet-access/)
- [Free Claude Code: Claude Code CLI를 무료로 사용할 수 있는 오픈소스 프록시 도구](/kr/resources/ai-tools/free-claude-code-open-source-proxy/)
- [OpenClaw 42개 실제 사용 사례: AI 에이전트가 이미 우리의 삶을 이렇게 바꾸고 있습니다](/kr/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/)

---

## 자체 호스팅 추천 인프라

24/7 안정 운영을 위해 인프라 선택이 중요하다:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 60일 $200 크레딧, 글로벌 14+ 리전. 오픈소스 AI 도구 자체 호스팅에 적합.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — 홍콩 VPS, 중국 본토 접근 시 저지연. dibi8.com 자체가 호스팅된 검증된 IDC.

*추천 링크입니다. 추가 비용 없이 dibi8.com 운영에 도움이 됩니다.*

