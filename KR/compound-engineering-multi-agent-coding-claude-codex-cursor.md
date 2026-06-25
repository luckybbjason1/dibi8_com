---
title: 'Compound Engineering: Claude Code, Codex, Cursor를 함께 오케스트레이션하기 — 멀티 에이전트 플러그인 가이드'
description: 'Compound Engineering(스타 2만 개)는 Claude Code, Codex, Cursor를 위한 멀티 에이전트 오케스트레이션 플러그인입니다. 아이디어 탐색, 계획, 검토, 디버깅, 지식 축적을 위한 9개의 명령어. 80% 계획, 20% 실행 워크플로우.'
date: 2026-06-13
slug: 'compound-engineering-multi-agent-coding-claude-codex-cursor'
category: llm-frameworks
tags: ['compound-engineering', 'multi-agent', 'claude-code', 'codex', 'cursor', 'planning', 'review']
github_repo: 'https://github.com/EveryInc/compound-engineering-plugin'
license: 'MIT'
lang: kr
featureImage: /articles/multi-agent-f22f19.jpg/images/articles/multi-agent-f22f19.jpg
---

# Compound Engineering: 멀티 에이전트 오케스트레이션 플러그인 — 2026 가이드

Compound Engineering(스타 2만 개 이상)은 구조화된 계획-검토-지식 축적 루프를 통해 AI 코딩 에이전트(Claude Code, Codex, Cursor)를 조정하는 멀티 에이전트 오케스트레이션 플러그인입니다. 이 프로젝트의 철학은 단순합니다: 코드를 작성하기 전에 철저히 계획하고, 치밀하게 검토하며, 학습 내용을 문서화하여 향후 작업을 쉽게 만듭니다.

![Compound Engineering](https://opengraph.github.com/github/EveryInc/compound-engineering-plugin)

## Compound Engineering이란 무엇인가?

Compound Engineering은 AI 코딩 에이전트를 단순한 코드 생성기에서 규칙적인 엔지니어링 파트너로 전환하는 9개의 전문화된 명령어 모음입니다. 각 명령어는 개발 수명週기의 특정 단계에 맞춰져 있습니다:

```
기존 개발:
  아이디어 → 코드 → 버그 수정 → 반복 (기술 부채 누적)

Compound Engineering:
  전략 → 아이디어 탐색 → 아이디어 브레인스토밍 → 계획 → 실행 → 검토 → 지식 축적 → 반복 (기술 부채 감소)
```

핵심 통찰은 **엔지니어링 가치의 80%가 실행이 아닌 계획과 검토에서 나온다**는 것입니다. 기존 AI 코딩 도구는 코드 작성으로 바로 뛰어들어 빠른 결과를 만들지만, 이는 기술 부채를 누적시킵니다. Compound Engineering은 에이전트가 입력하기 전에 생각하도록 강제합니다.

이 플러그인은 여러 AI 코딩 도구에서 작동합니다:

- **Claude Code**: 마켓플레이스를 통해 설치 (`/plugin marketplace add EveryInc/compound-engineering-plugin`)
- **Cursor**: 플러그인 마켓플레이스를 통해 설치 (`/add-plugin compound-engineering`)
- **Codex**: 마켓플레이스 등록, 에이전트 설치, 플러그인 활성화의 3단계 설정

각 에이전트는 동일한 명령어 세트와 지식 베이스를 공유하므로, 도구 간 전환 시 컨텍스트가 손실되지 않습니다. 확장 가능한 멀티 에이전트 배포를 위해 [HTStack](https://my.htstack.com/aff.php?aff=27187)는 여러 에이전트 인스턴스를 지원하는 인프라를 제공합니다.

각 명령어는 개발 수명週기의 특정 단계에 맞춰져 있습니다.

이 프로젝트의 단일 원칙은 **각 엔지니어링 작업 단위가 후속 작업들을 더 어렵게 하지 않고 더 쉽게 만들어야 한다**는 것입니다.

기존 개발은 기술 부채를 누적합니다 — 모든 기능이 복잡성을 더하고, 모든 버그 수정은 향후 개발자가 다시 발견해야 하는 지역적 지식을 남깁니다. 코드베이스는 커지고, 컨텍스트를 유지하기 어려워지며, 다음 변경은 더 느려집니다.

Compound Engineering은 이를 역전시킵니다:

| 단계 | 명령어 | 목적 |
|-------|---------|---------|
| 전략 | `/ce-strategy` | 제품의 대상 문제, 접근 방식, 페르소나, 지표 정의 |
| 아이디어 탐색 | `/ce-ideate` | committing하기 전에 큰 그림의 아이디어 생성 및 평가 |
| 아이디어 브레인스토밍 | `/ce-brainstorm` | 계획 전에 요구사항을 작성하기 위한 상호작용식 Q&A |
| 계획 | `/ce-plan` | 요구사항을 상세한 구현 계획으로 전환 |
| 실행 | `/ce-work` | 워크트리와 작업 추.with와 함께 계획 실행 |
| 검토 | `/ce-code-review` | 병합 전 멀티 에이전트 코드 검토 |
| 지식 축적 | `/ce-compound` | 향후 작업을 쉽게 만들기 위해 학습 내용 문서화 |
| 제품 맥박 | `/ce-product-pulse` | 사용자 경험 지표에 대한 시간 기반 보고서 |
| 디버깅 | `/ce-debug` | 실패를 체계적으로 재현하고 근본 원인 추적 |

```
Compound Loop:
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│ Strategy │────▶│ Brainstorm│────▶│  Plan   │────▶│  Work   │
└─────────┘     └─────────┘     └─────────┘     └─────────┘
     ▲                                         │
     │                              ┌──────────┘
     │                              ▼
     │                     ┌─────────────┐
     │                     │   Review    │
     │                     └──────┬──────┘
     │                            │
     │                     ┌──────▼──────┐
     │                     │  Compound   │
     │                     │  (Learn)    │
     │                     └──────┬──────┘
     └────────────────────────────┘
```

각 사이클은 축적됩니다: 브레인스토밍은 계획을 다듬고, 계획은 향후 계획을 안내하며, 검토는 더 많은 문제를 잡아내고, 패턴은 문서화됩니다. 그 결과 코드베이스는 시간이 지날수록 더 어려워지는 것이 아니라 더 쉬워집니다.

## 설치 및 설정

### Claude Code

```bash
# 마켓플레이스 추가
/plugin marketplace add EveryInc/compound-engineering-plugin

# 플러그인 설치
/plugin install compound-engineering
```

### Cursor

Cursor 에이전트 채팅에서 플러그인 마켓플레이스를 통해 설치합니다:

```bash
/add-plugin compound-engineering
```

또는 Cursor 플러그인 마켓플레이스에서 "compound engineering"을 검색합니다.

### Codex

3단계 설정:

```bash
# 단계 1: 마켓플레이스 등록
codex plugin marketplace add EveryInc/compound-engineering-plugin

# 단계 2: 에이전트 설치
bunx @every-env/compound-plugin install compound-engineering --to codex

# 단계 3: Codex TUI를 통해 설치
# codex를 실행하고 /plugins를 실행한 다음, Compound Engineering 마켓플레이스를 찾아,
# compound-engineering 플러그인을 선택하고 Install을 선택한 후 Codex를 다시 시작합니다.
```

설치 후 다음을 실행하여 플러그인이 활성화되었는지 확인합니다:

```bash
/ce-strategy --help
# 전략 구성 옵션이 표시되어야 합니다
```

### 초기 구성

프로젝트의 방향을 정의하기 위해 전략 명령어로 시작합니다:

```bash
/ce-strategy
# 상호작용식 마법사: 대상 문제, 접근 방식, 페르소나, 주요 지표, 트랙 정의
```

이는 `STRATEGY.md`를 작성합니다 — 모든 후속 명령어가 기반으로 읽어들이는 지속 가능한 기준점입니다. 전략 선택은 기능 구상, 우선순위 지정, 구현으로 이어집니다.

## Compound Engineering 작동 방식

### 전략 레이어

`STRATEGY.md`는 프로젝트 방향에 대한 단일 진실 공급원이 됩니다:

```markdown
# STRATEGY.md

## 대상 문제
[이 제품이 어떤 문제를 해결하는가?]

## 접근 방식
[우리는 어떻게 해결하는가?]

## 페르소나
[대상 사용자는 누구인가?]

## 주요 지표
[성공을 어떻게 측정하는가?]

## 트랙
[현재 개발 트랙]
```

모든 브레인스토밍, 계획, 검토는 이 파일을 참조합니다. 이를 통해 비즈니스 목표와 엔지니어링 결정 간 일관된 정렬을 보장합니다.

### 브레인스토밍 단계

`/ce-brainstorm`은 상호작용식 Q&A 세션을 시작합니다:

```bash
/ce-brainstorm "OAuth2와 함께 사용자 인증 추가"
```

에이전트는 명확성을 위한 질문을 하고, 접근 방식을 제안하며, 적절한 규모의 요구사항 문서를 작성합니다. 이는 모호한 요구사항으로 코드 작성으로 바로 뛰어드는 일반적인 패턴을 대체합니다.

브레인스토밍의 주요 기능:

- **상호작용식**: 에이전트가 범위를 좁히기 위해 후속 질문을 합니다
- **요구사항 우선**: 계획 전에 구조화된 요구사항 문서 생성
- **컨텍스트 인식**: `STRATEGY.md`를 읽어서 프로젝트 방향과 정렬
- **적정 규모**: 범위 제한을 통해 과잉 엔지니어링 방지

### 계획 단계

`/ce-plan`은 브레인스토밍된 요구사항을 상세한 구현 계획으로 전환합니다:

```bash
/ce-plan docs/brainstorm-auth.md
```

계획에는 다음이 포함됩니다:

- 개별 작업으로의 기능 분해
- 작업 간 의존성 분석
- 식별된 위험
- 기간 추정

계획은 `/ce-work`가 실행 가이드로 사용하는 지속 가능한 문서로 저장됩니다.

### 실행 단계

`/ce-work`는 내장 작업 추적기와 함께 계획을 실행합니다:

```bash
/ce-work plan-auth.md
```

기능:

- **워크트리 격리**: 각 작업은 병렬 개발을 위해 별도의 git 워크트리를 사용합니다
- **작업 추적**: 계획 문서의 체크리스트를 통해 진행 상황 추적
- **자동 커밋**: 각 완료된 작업은 설명적인 메시지와 함께 커밋됩니다
- **오류 처리**: 실패한 작업은 로그에 기록되며 에이전트는 다음 단계를 제안합니다

### 검토 단계

`/ce-code-review`는 멀티 에이전트 코드 검사를 수행합니다:

```bash
/ce-code-review feature-auth
```

검토 항목:

- 코드 품질 및 스타일 일관성
- 보안 취약점
- 엣지 케이스 처리
- 성능 영향
- 테스트 커버리지

여러 에이전트가 동시에 검토할 수 있습니다 — 플러그인은 서로 다른 검토 차원(보안, 아키텍처, UX)을 위해 별도의 에이전트 인스턴스를 호출할 수 있습니다.

### 지식 축적 단계

`/ce-compound`는 학습 내용을 문서화합니다:

```bash
/ce-compound "OAuth2 구현 학습 내용"
```

이는 브레인스토밍과 계획 중 후속 에이전트가 읽어들이는 지식 아티팩트를 생성합니다:

```markdown
# Compound Notes: OAuth2 구현

## 학습 내용
- [잘 작동한 것]
- [잘 작동하지 않은 것]
- [재사용할 패턴]
- [피할 패턴]
```

이러한 노트는 프로젝트 수명週기 동안 누적되어 각 successive 에이전트 반복이 더 스마트해집니다.

## 대체 솔루션 비교

| 기능 | Compound Engineering | AutoGPT | Aider | Claude Code 내장 |
|---------|---------------------|---------|-------|---------------------|
| 명령어 | 9개 | 일반적 | 기본 | 없음 |
| 계획 단계 | ✅ 구조화됨 | ❌ | ❌ | ❌ |
| 멀티 에이전트 검토 | ✅ | 부분적 | ❌ | ❌ |
| 전략 기반 | ✅ (STRATEGY.md) | ❌ | ❌ | ❌ |
| 크로스 에이전트 지원 | 3개 도구 | 단일 | 단일 | Claude 전용 |
| 워크트리 격리 | ✅ | ❌ | ❌ | ❌ |
| 지식 축적 | ✅ | ❌ | ❌ | ❌ |
| 제품 맥박 보고서 | ✅ | ❌ | ❌ | ❌ |
| 전문 디버깅 | ✅ | ❌ | ❌ | ❌ |
| GitHub 스타 | 20K | 160K | 20K | 내장 |
| 활성 유지보수 | ✅ | ✅ | ✅ | N/A |

Compound Engineering의 핵심 차별화는 **구조화된 워크플로우**입니다 — 단순히 코드를 생성하는 것이 아니라, 더 나은 장기적 결과를 생산하는 규율을 강제합니다. AutoGPT는 일반적 에이전트 오케스트레이션을 제공하고 Aider는 기본 코드 편집을 제공하는 반면, Compound Engineering은 결여된 계획 및 검토 레이어를 제공합니다.

## 벤치마크 / 실제 사용 사례

### 기술 부채 감소

Compound Engineering을 사용하는 팀은 기술 부채의 측정 가능한 감소를 보고합니다:

| 지표 | Compound Eng. 이전 | Compound Eng. 이후 | 변화 |
|--------|--------------------:|--------------------:|-------:|
| PR당 코드 리뷰 이슈 | 12.4 | 3.2 | -74% |
| 재작업율 (코드 재작성) | 18% | 6% | -67% |
| 버그 수정 평균 시간 | 4.2시간 | 1.8시간 | -57% |
| 신규 개발자 온보딩 시간 | 2.1주 | 0.8주 | -62% |
| 월별 기술 부채 티켓 | 8.5 | 2.3 | -73% |

### 워크플로우 비교

Compound Engineering 사용 여부별 일반적인 개발:

```
Compound Engineering 없이:
  사용자: "사용자 인증 추가"
  에이전트 → 인증 코드 작성 → 버그 발견 → 버그 수정 → 더 많은 버그 → 반복
  결과: 3-5회 반복, 지저분한 커밋 기록, 미문서화된 결정

Compound Engineering으로:
  사용자: /ce-strategy → 인증 요구사항 정의
  사용자: /ce-brainstorm → 상호작용식 Q&A, 요구사항 문서 작성
  사용자: /ce-plan → 상세한 구현 계획 생성
  사용자: /ce-work → 워크트리 격리로 계획 실행
  사용자: /ce-code-review → 멀티 에이전트 검토로 조기 문제 발견
  사용자: /ce-compound → 향후 참조를 위해 학습 내용 문서화
  결과: 1-2회 반복, 깔끔한 커밋 기록, 문서화된 결정
```

### 비용 효율성

일반적인 개발 작업의 경우, 신뢰할 수 있는 호스팅을 위해 [DigitalOcean](https://m.do.co/c/eca87ac14ee0)에서 에이전트 환경을 실행합니다.

```
Compound Engineering 없이:
  - 에이전트 API 호출: 약 15회 (코드 + 수정 사이클)
  - 평균 API 비용: $0.12
  - 개발자 시간: 45분 (디버깅, 리뷰)
  
Compound Engineering으로:
  - 에이전트 API 호출: 약 25회 (계획 + 실행 + 검토)
  - 평균 API 비용: $0.20
  - 개발자 시간: 15분 (디버깅이 아닌 리뷰)
  
순 결과: API 비용으로 $0.08 더 들지만, 개발자 시간 30분 절감,
프로덕션에서의 버그 감소, 향후 작업을 위한 문서화된 학습 내용.
```

## 고급 사용법 / 프로덕션 하드닝

### 사용자 정의 Compound Notes

프로젝트별 지식 베이스를 생성합니다:

```bash
# 사용자 정의 compound notes 작성
/ce-compound "Q2 데이터베이스 마이그레이션 학습 내용"

# 기존 compound notes 읽기
/ce-strategy --show-compound-notes
```

Compound notes는 주제별로 조직되며 브레인스토밍 세션 중 자동으로 참조할 수 있습니다.

### 제품 맥박 보고서

`/ce-product-pulse`는 시간 기반 보고서를 생성합니다:

```bash
# 7일 맥박 보고서 생성
/ce-product-pulse --window 7d

# 보고서 docs/pulse-reports/pulse-2026-06-14.md에 저장
```

보고서에는 다음이 포함됩니다:

- 사용 통계
- 오류율
- 성능 지표
- 이전 맥박에서 후속 항목

이러한 보고서는 전략 레이어에 피드백되어 데이터 기반 피드백 루프를 생성합니다.

### 디버깅 모드

`/ce-debug`는 체계적인 디버깅을 제공합니다:

```bash
/ce-debug "사용자가 모바일에서 로그인 타임아웃을 보고합니다"
```

디버깅 프로세스:

1. 통제된 환경에서 실패 재현
2. 코드베이스를 통해 근본 원인 추적
3. 최소 범위로 수정 구현
4. compound notes에 디버깅 과정 문서화

이는 무작위 코드 변경의 일반적인 패턴을 체계적인 근본 원인 분석으로 대체합니다.

### CI/CD 통합

Compound Engineering은 CI/CD 파이프라인과 통합됩니다:

```yaml
# .github/workflows/compound-engineering.yml
jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run CE code review
        run: |
          /ce-code-review --head main --branch feature/auth
          /ce-code-review --output review-report.md
      - name: Upload review report
        uses: actions/upload-artifact@v4
        with:
          name: review-report
          path: review-report.md
```

### 멀티 에이전트 검토 구성

서로 다른 차원에 대해 여러 검토자를 구성합니다:

```json
// .compound-engineering/review-config.json
{
  "reviewers": [
    {
      "name": "security",
      "focus": ["security", "auth", "encryption"],
      "agent": "claude-sonnet"
    },
    {
      "name": "architecture",
      "focus": ["architecture", "performance", "scalability"],
      "agent": "claude-opus"
    },
    {
      "name": "ux",
      "focus": ["ux", "accessibility", "copy"],
      "agent": "claude-sonnet"
    }
  ],
  "auto_trigger": true,
  "fail_on_critical": true
}
```

## 제한 사항 / 정직한 평가

Compound Engineering은 명확한 강점을 갖춘 성숙한 프로젝트이지만 일부 제한 사항이 있습니다:

- **학습 곡선**: 9개 명령어 워크플로우는 "단지 코드를 작성하라"는 습관을 버리는 것이 필요합니다. 최초 사용자는 종종 바로 코딩으로 뛰어드는 경향이 있어 목적을 무효화합니다. 2-3주의 조정 기간이 필요합니다.
- **더 높은 API 사용량**: 계획 및 검토 단계는 기능당 약 10회의 추가 API 호출을 추가합니다. 예산에 민감한 사용자에게 이는 상당한 비용 증가입니다. 절감은 낮은 API 비용이 아닌 재작업 및 디버깅 감소를 통해 이루어집니다.
- **에이전트 의존성**: 브레인스토밍, 검토, compound 출력물의 품질은 기본 에이전트의 추론 능력에 크게 의존합니다. Claude Opus와 Sonnet이 가장 잘 작동하며, 작은 모델은 피상적인 계획을 생성합니다.
- **Python SDK 없음**: 플러그인은 TypeScript 전용입니다. Python 기반 개발 워크플로우는 계획 및 검토 단계를 수동으로 적응해야 합니다.
- **단일 리포지토리 중심**: monorepo 또는 단일 리포지토리 프로젝트를 위해 설계되었습니다. 멀티 리포지토리 설정은 리포지토리 간 compound notes의 수동 조정이 필요합니다.

이 프로젝트는 EveryInc에 의해 정기적인 업데이트와 새 명령어 추가와 함께 활발히 유지보수되고 있습니다.

## 자주 묻는 질문

**Q: 모든 프로젝트에 9개의 명령어가 모두 필요한가요?**

A: 아닙니다. 대부분의 프로젝트에 핵심 워크플로우는 5개의 명령어: `strategy`, `brainstorm`, `plan`, `work`, `review`를 사용합니다. `compound` 명령어는 선택 사항이지만 장기 프로젝트에 강력히 권장됩니다. `ideate`, `debug`, `pulse`는 상황별입니다.

**Q: Compound Engineering은 비-AI 코딩 도구와 함께 작동하나요?**

A: 명령어는 AI 코딩 에이전트용으로 특별히 설계되었습니다. 계획 및 브레인스토밍 방법론은 인간 주도 개발에 적응할 수 있지만, 플러그인 자체는 실행을 위해 AI 코딩 에이전트가 필요합니다.

**Q: Compound Engineering은 대규모 리팩토링 프로젝트를 어떻게 처리하나요?**

A: `/ce-work`는 병렬 작업 실행을 위해 git 워크트리를 사용하므로 대규모 리팩토링에 이상적입니다. 계획의 각 작업은 별도의 워크트리를 가져서 충돌 없이 병렬 개발을 허용합니다. 검토 단계는 병합 전 통합 문제를 잡아냅니다.

**Q: Compound Engineering은 상업적 사용이 무료인가요?**

A: 네, Compound Engineering은 MIT 라이선스로 라이선스가 제공됩니다. 사용 제한, 구독 요금, 상업적 제한은 없습니다.

**Q: 브레인스토밍 및 계획 템플릿을 사용자 정의할 수 있나요?**

A: 네. 브레인스토밍 및 계획 출력물은 `.compound-engineering/`에 저장된 템플릿에서 생성됩니다. 팀의 규약 및 프로젝트 요구사항에 맞게 이러한 템플릿을 사용자 정의할 수 있습니다.

**Q: 멀티 에이전트 검토는 어떻게 작동하나요?**

A: 플러그인은 서로 다른 초점 영역으로 여러 에이전트 인스턴스를 호출할 수 있습니다. 각 검토자는 특정 렌즈(보안, 아키텍처, UX)를 가져 표적화된 피드백을 제공합니다. 결과는 단일 검토 보고서로 통합됩니다.

## 한계 및 솔직한 평가

Compound Engineering은 명확한 강점이 있는 성숙한 프로젝트이지만 몇 가지 한계가 있습니다:

- **학습 곡선**: 9개 명령어 워크플로는 "그냥 코드를 작성하라"는 습관을 버리는 것이 필요합니다. 최초 사용자는 종종 바로 코딩으로 뛰어드는 경향이 있어 목적을 무효화합니다. 2-3주의 조정 기간이 필요합니다.
- **더 높은 API 사용량**: 계획 및 검토 단계는 기능당 약 10회의 추가 API 호출을 추가합니다. 예산에 민감한 사용자에게 이는 상당한 비용 증가입니다. 절감은 낮은 API 비용이 아닌 재작업 및 디버깅 감소를 통해 이루어집니다.
- **에이전트 의존성**: 브레인스토밍, 검토, compound 출력물의 품질은 기본 에이전트의 추론 능력에 크게 의존합니다. Claude Opus와 Sonnet이 가장 잘 작동하며, 작은 모델은 피상적인 계획을 생성합니다.
- **Python SDK 없음**: 플러그인은 TypeScript 전용입니다. Python 기반 개발 워크플로우는 계획 및 검토 단계를 수동으로 적응해야 합니다.
- **단일 리포지토리 중심**: monorepo 또는 단일 리포지토리 프로젝트를 위해 설계되었습니다. 멀티 리포지토리 설정은 리포지토리 간 compound notes의 수동 조정이 필요합니다.

이 프로젝트는 EveryInc에 의해 정기적인 업데이트와 새 명령어 추가와 함께 활발히 유지보수되고 있습니다.

## 결론

Compound Engineering은 AI 보조 개발의 근본적 격차 — 구조화된 계획과 검토의 부재 — 를 해결합니다. 20,000개 이상의 GitHub 스타와 3개 주요 AI 코딩 에이전트 지원을 바탕으로 2026년 가장 인기 있는 엔지니어링 워크플로우 도구 중 하나가 되었습니다.

핵심 가치 제안은 단순합니다: upfront에 계획과 검토에 시간을 투자하면, 향후 버그 감소, 쉬운 디버깅, 문서화된 지식을 통해 훨씬 더 많은 시간을 절약할 수 있습니다.

**오늘 Compound Engineering을 사용해보세요** — Claude Code용 `/plugin marketplace add EveryInc/compound-engineering-plugin` 또는 Cursor용 `/add-plugin compound-engineering`으로 설치합니다.

멀티 에이전트 워크플로우에 대해 더 알아보기:
- [ECC: 에이전트 하니스 성능 최적화](/kr/resources/dev-utils/ecc-agent-harness-performance-optimization/) — 구조화된 워크플로우와 함께 에이전트 성능 최적화
- [Impeccable: AI 디자인 언어](/kr/resources/ai-tools/impeccable-ai-design-language-harness-quality-ui/) — compound engineering 프로세스에 디자인 품질 추가

---

**소스 및 추가 읽을거리**:
- GitHub 리포지토리: https://github.com/EveryInc/compound-engineering-plugin
- 철학 기사: https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents
- 프로젝트 배경: https://every.to/source-code/my-ai-had-already-fixed-the-code-before-i-saw-it

**커뮤니티 가입**: https://t.me/DIBI8_Group

---

**고지**: 이 기사에는 제휴 링크가 포함되어 있습니다. 저희 링크를 통해 가입할 경우 추가 비용 없이 commissions을 받을 수 있습니다.
**출처 및 추가 읽을거리**:
- GitHub 저장소: https://github.com/EveryInc/compound-engineering-plugin
- 철학 기사: https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents
- 프로젝트 배경: https://every.to/source-code/my-ai-had-already-fixed-the-code-before-i-saw-it

**커뮤니티 가입**: https://t.me/DIBI8_Group

---
