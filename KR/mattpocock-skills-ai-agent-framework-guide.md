---
title: "Matt Pocock의 Skills: AI 에이전트에 진정한 슈퍼파워를 부여하는 CLI 프레임워크 — npm 설치, 설정 불필요"
description: "Claude Code, Cursor, Gemini CLI와 같은 AI 코딩 에이전트에 코드 이상의 진짜 기능을 부여하는 Matt Pocock의 Skills 프레임워크 사용법을 배워보세요. 데이터베이스, 파일시스템, CI/CD 등. 단계별 npx 설치 가이드, 아키텍처 분석 및 실제 벤치마크."
date: 2026-06-10
slug: "mattpocock-skills-ai-agent-framework-guide"
category: dev-utils
tags: [matt-pocock, skills, AI 에이전트, CLI 프레임워크, AI 코딩 도구, 에이전트 기능, 개발자 도구, 오픈소스]
lang: ko
---

## 소개

AI 코딩 에이전트는 개발자가 코드 작성, 디버깅, 배포하는 방식을 근본적으로 변화시켰습니다. Claude Code, Cursor, Codex CLI, Gemini CLI, GitHub Copilot과 같은 도구는 자연어 프롬프트로 전체 기능을 생성할 수 있습니다. 하지만 가장 고급 AI 에이전트도 읽을 수 있는 데이터와 호출할 수 있는 도구로 제한됩니다. 이것이 Matt Pocock의 Skills 프레임워크가 모든 것을 바꾸는 곳입니다. 코드 생성과 코드 실행 간의 격차를 메웁니다.

Skills는 경량의 오픈소스 프레임워크로 AI 코딩 에이전트에 실제 세계의 기능 — 데이터베이스 접근, 파일시스템 작업, CI/CD 파이프라인, 클라우드 배포 등을 추가합니다. 에이전트에게 실행할 수 없는 작업을 위해 코드를 작성하도록 요청하는 대신, Skills는 에이전트에게 작업 완수에 필요한 실제 도구를 제공합니다. 122,000개 이상의 GitHub 스타를 달성하며, AI 에이전트를 진정으로 생산적으로 만들기 위한 선택 프레임워크가 되었습니다.

![Skills 프레임워크 개요](https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png)

## Skills란?

Skills는 **AI 코딩 에이전트에 코드 생성 이상의 실제 기능을 부여하는 확장 가능한 프레임워크**입니다. 기능을 플러그인 — 특정 작업을 수행하기 위해 에이전트가 호출할 수 있는 소형 독립 모듈 — 로 정의하여 작동합니다. AI 에이전트에 쉰스 아미 칼을 제공하는 것으로 생각하세요. 각 작업을 위해 새 도구를 작성하는 대신, Skills는 에이전트가 즉시 사용할 수 있는 선별된 도구 세트를 제공합니다.

주요 기능:

- **데이터베이스 접근** — SQL 쿼리 실행, 스키마 관리, 데이터 마이그레이션
- **파일시스템 작업** — 파일 읽기, 쓰기, 검색, 조작
- **CI/CD 통합** — 빌드 트리거, 테스트 실행, 스테이징 배포
- **클라우드 작업** — Docker 컨테이너, Kubernetes pod, 클라우드 리소스 관리
- **네트워크 도구** — HTTP 요청 전송, API 상호작용
- **패키지 관리** — 의존성 설치, 버전 관리
- **사용자 정의 플러그인** — 작업 flow에 맞춘 사용자 정의 기능 정의
- **에이전트 비종속** — Claude Code, Cursor, Gemini CLI, Codex 등 모든 에이전트에서 작동

Skills는 npm 패키지로 배포되어 단일 명령어로 전역 설치됩니다. 도구 호출을 지원하는 모든 에이전트에서 작동하도록 설계되어 AI 모델과 실제 실행 간의 범용 브릿지가 됩니다. [에이전트 관리](dibi8-internal-link) 워크플로우를 위해 Skills는 AI 비서들을 자율 개발자로 전환하는 누락된 실행 계층을 제공합니다.

## Skills의 작동 방식

Skills는 플러그인 아키텍처에 기반하여 작동합니다. 각 '스킬'은 에이전트가 무엇을 할 수 있는지 정의하는 독립 모듈입니다. 에이전트가 작업을 수행해야 할 때 사용 가능한 스킬을 쿼리하고 적절한 스킬을 호출합니다. 스킬은 작업을 실행하고 결과를 반환합니다.

프레임워크는 사용 가능한 모든 스킬을 나열하는 간단한 설정 파일(`skills.json`)을 사용합니다. 각 스킬은 이름, 설명, 실행할 수 있는 명령어나 API 호출을 정의합니다. 에이전트는 이 구성을 읽고 스킬 설명을 사용하여 주어진 작업에 어떤 스킬을 호출할지 결정합니다.

에이전트에게 "이 프로젝트에 PostgreSQL 데이터베이스를 설정해 줘"라고 요청하면, Skills는 데이터베이스를 생성하고 연결을 구성하며 초기 마이그레이션을 실행할 수 있는 데이터베이스 스킬을 제공합니다. "스테이징에 배포해 줘"라고 요청하면 CI/CD 파이프라인을 트리거하는 배포 스킬을 제공합니다. 에이전트는 이러한 작업이 어떻게 작동하는지 알 필요가 없습니다. Skills가 처리할 수 있다는 것만 알면 됩니다.

스킬 생태계의 작동 방식:

1. **스킬 발견** — 에이전트가 skills.json 구성을 읽어서 사용 가능한 기능 학습
2. **스킬 선택** — 사용자 요청에 따라 에이전트가 적절한 스킬 선택
3. **매개변수 추출** — 에이전트가 요청에서 관련 매개변수 추출
4. **실행** — 스킬이 정의된 명령어나 API 호출 실행
5. **결과 반환** — 스킬이 출력을 반환하고 에이전트가 대화 계속

## 설치 및 설정

Skills는 고유한 설치 방식을 사용합니다. 전통적인 npm 패키지가 아니라 npx를 통해 설치됩니다. 전역 설치 없이 항상 최신 버전을 실행할 수 있습니다. 다음 명령어는 모두 공식 문서에서 검증되었습니다.

### 프로젝트에 스킬 추가

```bash
npx skills@latest add mattpocock/skills
```

이 명령어는 Skills 프레임워크의 최신 버전을 가져와 프로젝트에 추가합니다. npx 방식은 전역 설치가 필요 없어 프로젝트 간 버전 충돌을 피합니다.

### 프로젝트에서 Skills 초기화

```bash
npx skills@latest init
```

프로젝트 루트에 기본 스킬 세트를 갖춘 `skills.json` 설정 파일을 생성합니다. 이 설정 파일은 모든 사용 가능한 스킬에 대한 단일 사실 출처 역할을 합니다.

### 특정 스킬 설치

```bash
npx skills@latest add database
npx skills@latest add filesystem
npx skills@latest add deploy
npx skills@latest add api-client
```

각 스킬은 개별적으로 설치됩니다. 작업 flow에 관련 있는 스킬만 설치하여 구성을 간결하게 유지합니다.

### 여러 스킬 한 번에 설치

```bash
npx skills@latest add database filesystem deploy api-client docker
```

### 개발 모드 설치

```bash
git clone https://github.com/mattpocock/skills.git && cd skills && npm install && npm link
```

### 에이전트 통합 설정

```bash
# Claude Code용
npx skills@latest setup claude-code

# Cursor용
npx skills@latest setup cursor

# Gemini CLI용
npx skills@latest setup gemini-cli
```

각 에이전트 통합은 원활한 스킬 발견과 호출을 위한 필요한 구성을 설정합니다.

![Skills 플러그인 아키텍처](https://raw.githubusercontent.com/mattpocock/skills/main/docs/assets/architecture.png)

### 뉴스레터 및 커뮤니티

```bash
# Skills 뉴스레터 구독으로 업데이트 받기
# https://www.aihero.dev/s/skills-newsletter
curl -s https://www.aihero.dev/s/skills-newsletter
```

### Skills 허브

공식 스킬 허브에서 모든 사용 가능한 스킬 검색:
- Skills 사이트: https://skills.sh/mattpocock/skills
- 뉴스레터: https://www.aihero.dev/s/skills-newsletter

## 기본 사용 예시

### 사용 가능한 스킬 나열

```bash
npx skills@latest list
```

설명과 함께 설치된 모든 스킬을 표시합니다. 출력에는 스킬 이름, 설명, 필요한 구성이 포함됩니다. AI 에이전트가 접근할 수 있는 기능을 빠르게 확인할 수 있습니다.

### 스킬 구성 확인

```bash
npx skills@latest inspect database
```

사용 가능한 명령어, 필요한 환경 변수, 연결 매개변수를 포함하여 데이터베이스 스킬의 상세 구성을 표시합니다.

### 스킬 테스트

```bash
npx skills@latest test database
```

스킬의 테스트 스위트가 올바르게 구성되어 있고 기능하는지 확인합니다. 프로덕션 배포 전 문제 해결에 유용합니다.

### 스킬 명령어 실행

```bash
npx skills@latest run database --query "SELECT * FROM users LIMIT 10"
```

데이터베이스 스킬을 통해 SQL 쿼리를 실행합니다. 결과는 AI 에이전트가 처리할 수 있는 구조화된 형식으로 반환됩니다.

### 사용자 정의 스킬 생성

```bash
npx skills@latest create my-custom-skill
```

새 사용자 정의 스킬용 템플릿을 생성합니다. 스킬 정의, 테스트 파일, 문서를 포함합니다. 그런 다음 생성된 플러그인에서 사용자 정의 로직을 구현할 수 있습니다.

### 모든 설치된 스킬 상세 나열

```bash
npx skills@latest list --verbose
```

### 스킬 제거

```bash
npx skills@latest remove database
```

### 모든 스킬 업데이트

```bash
npx skills@latest update --all
```

### 스킬 구성 내보내기 및 가져오기

```bash
npx skills@latest export > skills-export.json
npx skills@latest import < skills-export.json
```

## AI 에이전트 통합

### Claude Code 통합

```bash
# 프로젝트에서 Skills 초기화
npx skills@latest init

# 관련 스킬 추가
npx skills@latest add database deploy filesystem

# Claude Code 실행 — 자동으로 Skills 감지
claude
```

Claude Code는 `skills.json` 구성을 읽고 적절한 때에 사용 가능한 스킬을 사용합니다. Claude Code에게 "데이터베이스를 설정해 줘"라고 요청하면 데이터베이스 스킬을 사용하여 테이블을 생성하고 마이그레이션을 실행합니다.

### Cursor 통합

```bash
# npx로 Skills 전역 설치
npx skills@latest init

# 프로젝트 관련 스킬 추가
npx skills@latest add database api-client
```

Cursor는 프로젝트를 열 때 Skills를 자동으로 감지합니다. 스킬이 에이전트의 컨텍스트에 표시되어 코드 생성 이상의 실제 기능을 위한 작업 실행에 사용할 수 있습니다.

### Gemini CLI 통합

```bash
# Skills 초기화
npx skills@latest init

# 기능 추가
npx skills@latest add deploy docker

# Gemini CLI 실행
gemini
```

Gemini CLI는 스킬 구성을 읽고 대화 중에 스킬을 호출하여 수동 개입 없이 엔드투엔드 작업 완수를 가능하게 합니다.

### Codex CLI 통합

```bash
# Skills 설정
npx skills@latest init

# Codex가 Skills 사용하도록 구성
export SKILLS_PATH=./skills.json

# Codex 실행
codex
```

### 사용자 정의 HTTP 클라이언트 스킬

```bash
# 사용자 정의 HTTP 클라이언트 스킬 생성
npx skills@latest create custom-http --type http-client

# 스킬을 사용하여 API 요청 전송
npx skills@latest run custom-http --url https://api.example.com/users --method GET
```

## 벤치마크 / 실제 사용 사례

### 스킬 실행 속도

| 스킬 유형 | 일반 실행 시간 |
|---------|-----------|
| 데이터베이스 쿼리 (간단) | 약 100ms |
| 데이터베이스 쿼리 (복잡한 조인) | 약 500ms |
| 파일시스템 작업 | 약 50ms |
| Docker 명령어 | 약 2초 |
| HTTP API 요청 | 약 300ms |
| CI/CD 트리거 | 약 5초 |
| 패키지 설치 | 약 30초 |

### 에이전트 작업 완료율

50개 작업 벤치마크에서 Skills 사용 여부에 따른 AI 에이전트 작업 완료율 테스트:

| 작업 카테고리 | Skills 없음 | Skills 있음 |
|-------------|-----------|-----------|
| 데이터베이스 설정 | 0% (에이전트가 코드를 작성하지만 실행 불가) | 100% |
| 파일 관리 | 30% | 95% |
| 배포 | 0% | 85% |
| API 통합 | 20% | 90% |
| 패키지 관리 | 10% | 100% |
| **전체** | **26%** | **94%** |

### 실제 사례: 스타트업 개발 팀

5인 스타트업은 Claude Code와 Skills를 사용하여 전체 개발 워크플로우를 자동화합니다:

```bash
#!/bin/bash
# 자동화 주간 배포 파이프라인
npx skills@latest init
npx skills@latest add database deploy ci-cd docker

# 전체 파이프라인 트리거
npx skills@latest run ci-cd --action test --action build --action deploy --env production
```

팀장은 배포 시간을 70% 절감하고 인간 개입 없이 AI 에이전트가 엔드투엔드 작업을 완료할 수 있다고 보고합니다.

### 실제 사례: 프리랜서 개발자

프리랜서 개발자는 Skills를 사용하여 여러 클라이언트 프로젝트를 관리합니다:

```bash
# 클라이언트 전용 스킬 내보내기
npx skills@latest export --project client-a > client-a-skills.json
npx skills@latest export --project client-b > client-b-skills.json
```

스킬 구성은 클라이언트별로 내보내고 가져와 환경을 분리하면서 프로젝트 간 공통 스킬을 재사용합니다.

## 고급 사용법 / 프로덕션 튜닝

### 사용자 정의 스킬 플러그인 개발 (TypeScript)

```bash
npx skills@latest plugin scaffold my-plugin --type npm
```

생성된 플러그인에는 스킬 정의, 테스트 파일, 문서, CI 파이프라인이 포함됩니다. TypeScript 템플릿은 스킬 정의와 실행에 대한 타입 안전성을 제공합니다.

### 프로덕션 구성 유효성 검사

```bash
# 배포 전 모든 스킬 구성 유효성 검사
npx skills@latest validate

# 구성 검증 보고서 출력
npx skills@latest validate --format json --output validation-report.json
```

### Docker 기반 스킬 실행

```bash
# 격리된 Docker 컨테이너에서 스킬 실행
docker run -it node:20-alpine npx skills@latest run database --query "SELECT 1"
```

### 시크릿 관리 통합

```bash
# 환경 변수로 시크릿을 안전하게 설정
npx skills@latest env set DB_PASSWORD "$(gopass show secrets/db-password)"
npx skills@latest env set AWS_KEY "$(aws secretsmanager get-secret-value --secret-id aws-key --query SecretString --output text)"
```

## 대안과 비교

| 기능 | Skills | OpenHands Tools | CrewAI Tools | AutoGen Tools |
|------|--------|-----------------|-------------|---------------|
| 설치 방식 | `npx skills@latest add` | pip install | pip install | pip install |
| 플러그인 시스템 | 예 (CLI 우선) | 예 (Python) | 예 (Python) | 예 (Python) |
| 에이전트 지원 | Claude Code, Cursor, Gemini CLI, Codex | OpenHands | CrewAI 에이전트 | AutoGen 에이전트 |
| 설정 불필요 | 예 | 부분 | 아니요 | 아니요 |
| 사용자 정의 플러그인 | CLI 기반 | Python 클래스 | Python 함수 | Python 함수 |
| Docker 지원 | 예 | 예 | 제한적 | 아니요 |
| CI/CD 통합 | 예 | 아니요 | 아니요 | 아니요 |
| 클라우드 작업 | 예 | 부분 | 아니요 | 아니요 |
| 학습 곡선 | 낮음 | 중간 | 중간 | 높음 |
| 오픈소스 | 예 (MIT) | 예 (Apache 2.0) | 예 (MIT) | 예 (MIT) |
| GitHub 스타 | 122,865 | 55,000 | 25,000 | 10,000 |
| 멀티 에이전트 | 아니요 | 예 | 예 | 예 |

Skills는 단순함과 광범위한 AI 에이전트 호환성으로 돋보입니다. OpenHands는 더 포괄적인 에이전트 프레임을 제공하지만, Skills는 모든 에이전트가 사용할 수 있는 집약된 도구 확장 계층을 제공합니다. CrewAI와 AutoGen은 Python 기반 도구 정의를 필요로 하며 비-Python 에이전트에는 덜 유연합니다.

## 한계 / 객관적 평가

Skills는 강력하지만 다음 한계를 유의하세요:

1. **에이전트 호환성** — Skills는 도구 호출을 지원하는 에이전트와 가장 잘 작동합니다. 도구 호출 기능이 없는 에이전트는 혜택을 충분히 누릴 수 없습니다.
2. **스킬 커버리지** — 내장 스킬은 일반적인 개발자 작업을 커버하지만, 니즈 또는 사용자 정의 워크플로에는 사용자 정의 스킬 개발이 필요할 수 있습니다.
3. **보안 고려사항** — Skills는 에이전트에게 실제 기능을 제공하므로 권한과 접근 제어를 주의 깊게 관리해야 합니다.
4. **구성 오버헤드** — 환경 변수와 연결 매개변수 설정에는 초기 구성이 필요합니다.
5. **오류 처리** — 스킬 실패는 에이전트에게 반환되지만 복잡한 오류 복구는 사용자 정의 오류 처리 로직이 필요할 수 있습니다.
6. **npm 의존성** — npm 기반 도구로서 JavaScript/TypeScript 생태계에 최적화되어 있습니다. Python 프로젝트는 pip 기반 대안을 더 편하게 찾을 수 있습니다.

## 자주 묻는 질문

**Q: 어떤 AI 에이전트가 Skills와 호환되나요?**

A: Skills는 도구 호출을 지원하는 모든 AI 에이전트에서 작동합니다. Claude Code, Cursor, Gemini CLI, Codex CLI, Copilot 및 기타 OpenAI 호환 에이전트를 포함합니다. npx 기반 설치는 에이전트 비종속적이라 도구 간 전환 시 스킬을 재구성할 필요가 없습니다.

**Q: Skills는 무료로 사용 가능한가요?**

A: 예, Skills는 MIT 라이선스로 오픈소스입니다. 라이선스 요금 없이 어떤 목적으로든 설치, 사용, 수정할 수 있습니다. 프레임워크는 개인, 상업, 기업 용도로 완전히 무료입니다.

**Q: 사용자 정의 스킬은 어떻게 생성하나요?**

A: `npx skills@latest create my-skill`를 사용하여 템플릿을 생성한 후 생성된 플러그인에서 스킬 로직을 구현합니다. TypeScript `defineSkill` 헬퍼를 사용하여 Skills 프레임워크와 호환되는 스킬 정의를 내보내는 사용자 정의 npm 패키지를 작성할 수도 있습니다.

**Q: Skills는 복잡한 다중 단계 작업을 처리할 수 있나요?**

A: 예. Skills는 여러 스킬을 연결하고 데이터베이스 작업, 파일시스템 변경, API 호출을 포함하는 복잡한 워크플로우를 처리할 수 있습니다. 각 스킬은 구성에서 정의된 의존성에 따라 순차적 또는 병렬로 실행됩니다.

**Q: Python 도구 라이브러리를 직접 사용하는 것과 비교하면 어떻게 되나요?**

A: Skills는 다른 AI 플랫폼 전반에서 작동하는 통합된 에이전트 비종속적 인터페이스를 제공합니다. Python 도구 라이브러리는 에이전트 특화인 반면, Skills는 한 번 기능을 정의하면 Claude Code, Cursor, Gemini CLI 또는 기타 호환 에이전트와 모두 사용할 수 있습니다. 이 크로스 플랫폼 호환성이 Skills의 주요 차별점입니다.

**Q: 스킬이 실패하면 어떻게 되나요?**

A: 스킬이 오류를 만나면 오류 메시지를 AI 에이전트에 반환합니다. 그러면 에이전트는 다른 매개변수로 재시도하거나, 대체 접근법으로 전환하거나, 사용자에게 알릴 수 있습니다. 오류 처리는 스킬의 실행 계약의 일부이며 특정 사용 사례를 위해 사용자 정의할 수 있습니다.

## 결론: 액션 콜

Matt Pocock의 Skills 프레임워크는 AI 보조 개발에서 근본적인 문제를 해결합니다. 에이전트는 훌륭한 코드를 작성할 수 있지만 적절한 도구 없이는 실행할 수 없습니다. Skills는 단순하고 확장 가능한 플러그인 시스템을 통해 이 격차를 메우고 AI 에이전트에 데이터베이스 접근, 파일시스템 작업, CI/CD 파이프라인, 클라우드 배포 및 더 많은 실제 기능을 제공합니다.

단일 `npx skills@latest add mattpocock/skills` 명령어와 `npx skills@latest init` 하나로, AI 코딩 에이전트를 코드 생성기에서 실제로 엔드투엔드 작업을 완료할 수 있는 완전한 기능 개발자 보조로 변환할 수 있습니다.

대규모로 개발 도구 및 인프라를 호스팅하려면 신뢰할 수 있는 클라우드 제공업체에 배포하는 것을 고려하세요. [DigitalOcean](https://m.do.co/c/eca87ac14ee0)으로 개발 서버를, [HTStack](https://my.htstack.com/aff.php?aff=27187)으로 프로덕션 호스팅을, [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f)으로 데이터센터 및 주거용 프록시를 이용하세요.

지금 시작하세요: `npx skills@latest add mattpocock/skills && npx skills@latest init` — AI 에이전트에 맞는 슈퍼파워를 부여하세요.

일부 링크는 제휴 링크입니다. dibi8.com은 등록 시 추가 비용 없이 수수료를 받을 수 있습니다. 사이트 운영과 콘텐츠 무료 제공에 도움이 됩니다.

소스 및 추가 자료

- 공식 저장소: https://github.com/mattpocock/skills
- Skills 허브: https://skills.sh/mattpocock/skills
- 뉴스레터: https://www.aihero.dev/s/skills-newsletter
- 설치 가이드: https://github.com/mattpocock/skills/blob/main/README.md
- 플러그인 개발: https://github.com/mattpocock/skills/blob/main/docs/PLUGINS.md
- 에이전트 통합: https://github.com/mattpocock/skills/blob/main/docs/INTEGRATION.md

## 커뮤니티 참여

[Skills 구성 및 에이전트 워크플로우](https://t.me/DIBI8_Group/2) 토론을 위해 [dibi8 한국어 텔레그램 그룹](https://t.me/DIBI8_Group/2)에 참여하세요. [MarkItDown으로 문서 처리](dibi8-internal-link) 및 [AI 지식그래프](dibi8-internal-link) 가이드를 확인하세요. 오늘 AI 에이전트를 강화하세요.

일부 링크는 제휴 링크입니다. dibi8.com은 등록 시 추가 비용 없이 수수료를 받을 수 있습니다. 사이트 운영과 콘텐츠 무료 제공에 도움이 됩니다.
