---
title: "JustHireMe：AI가 당신의 취업을 자동화합니다"
description: "JustHireMe 오픈소스 AI 취업 워크벤치 리뷰. 로컬 우선 구직 인텔리전스 시스템, 자동 포지션 크롤링, AI 매칭도 평가, 맞춤형 이력서 및 자기소개서 생성."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - JavaScript
  - Python
  - TypeScript
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "50.9 MB"
file_md5: ""
download_url: "https://github.com/vasu-devs/JustHireMe.git"
backup_url: ""
github_repo: "https://github.com/vasu-devs/JustHireMe.git"
stars: 1749
maintainer: "vasu-devs"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /kr/posts/justhireme-ai-job-search-workbench/
faqs:
  - q: 'JustHireMe는 무료 오픈 소스인가요?'
    a: '네. JustHireMe는 MIT 라이선스 하에 오픈 소스로 공개되어 있으며, 구독료나 숨겨진 비용이 전혀 없습니다. 이력서와 데이터의 소유권은 전적으로 사용자에게 있으며, 점수 산출 알고리즘도 투명하게 공개되어 있습니다.'
  - q: 'JustHireMe를 사용하려면 AI API 키가 필요하거나 데이터가 클라우드로 전송되나요?'
    a: '아닙니다. JustHireMe는 로컬 우선 방식으로 동작합니다. 모든 AI 연산은 로컬에서 실행되므로 API 키가 필요 없으며, 데이터는 클라우드에 업로드되지 않고 사용자 기기의 로컬 SQLite 데이터베이스에 저장됩니다.'
  - q: 'JustHireMe는 어떤 채용 플랫폼에서 공고를 수집할 수 있나요?'
    a: 'LinkedIn, Indeed, Glassdoor, AngelList, Hacker News, 기업 채용 페이지, 원격 근무 전용 섹션에서 자동으로 채용 공고를 수집합니다. 중복 제거 알고리즘이 여러 플랫폼에 동일하게 게재된 포지션을 자동으로 하나로 통합합니다.'
  - q: 'JustHireMe의 채용 공고 매칭 점수는 어떻게 산출되나요?'
    a: '키워드 매칭이 아닌 시맨틱 이해 방식을 사용합니다. 사용자의 기술, 경력, 연봉 기대치, 커리어 목표를 각 공고의 요구 사항과 비교 분석하여 0-100 점수를 부여하므로, 80점 이상의 포지션에 집중할 수 있습니다.'
  - q: 'JustHireMe는 어떤 기술 스택으로 개발되었나요?'
    a: '데스크톱 앱은 React 19와 TypeScript를 결합한 Tauri 2로 구축되었으며, 백엔드는 FastAPI와 WebSockets를 사용하는 Python 3.13으로 실행됩니다. 데이터는 SQLite와 Kuzu 그래프 데이터베이스, LanceDB 벡터 저장소에 보관되며, Playwright가 스크래핑 및 지원서 제출을 위한 브라우저 자동화를 담당합니다.'
---
{</* resource-info */>}

## 문제: 구직은 풀타임 직업입니다

이력서 100통을 제출하고, 면접 2개를 받고, Offer 0개. 이는 당신의 문제가 아니라 시스템의 문제입니다.

각 채용 사이트는 섬입니다:
- **LinkedIn**: 고급 검색은 유료
- **Indeed**: 중복 포지션, 만료된 정보
- **Glassdoor**: 급여 데이터 지연
- **회사 홈페이지**: 각각 다시 작성해야 함
- **채용 이메일**: 99% 읽음 확인 없음

더 고통스러운 것은: 제출할 때마다 **이력서를 다시 쓰고**, **자기소개서를 다시 쓰고**, **회사를 다시 연구해야** 합니다.

## 해결책: JustHireMe

**JustHireMe**는 오픈소스 AI 구직 인텔리전스 워크벤치입니다. 로컬 우선, 프라이버시 안전, 원클릭 자동 제출.

**핵심 철학**: AI가 반복 작업을 하고, 당신은 의사결정만 합니다.

## 핵심 기능

### 1. 스마트 포지션 크롤링

여러 플랫폼에서 자동으로 포지션을 크롤링합니다:
- LinkedIn, Indeed, Glassdoor
- AngelList, Hacker News
- 회사 채용 페이지
- 원격 근무 전용 구역

**중복 제거 알고리즘**: 동일한 포지션이 다른 플랫폼에 나타나면 자동으로 병합합니다.

### 2. AI 매칭도 평가

키워드 매칭이 아닌 진정한 **의미 이해**:
- 당신의 기술 vs 포지션 요구사항
- 당신의 경험 vs 포지션 레벨
- 당신의 급여 기대치 vs 예산 범위
- 당신의 커리어 목표 vs 회사 방향

점수 0-100, 80점 이상의 포지션만 봅니다.

### 3. 이력서 자동 맞춤화

각 포지션에 따라 **이력서를 재작성**합니다:
- 관련 기술 강조
- 프로젝트 설명 조정
- 키워드 매칭
- 레이아웃 포맷 최적화

템플릿 채우기가 아닌, **진정한 AI 재작성**입니다.

### 4. 자기소개서 생성

각 자기소개서는 **유니크**합니다:
- 회사 배경 연구
- 구체적인 프로젝트 인용
- 관련 경험 제시
- 진정한 관심 표현

HR은 템플릿과 진심 어린 글을 구분할 수 있습니다.

### 5. 로컬 CRM 관리

모든 데이터는 로컬에 저장됩니다:
- SQLite 데이터베이스
- 포지션 이력 기록
- 제출 상태 추적
- 면접 일정 관리

**프라이버시 우선**: 당신의 데이터는 클라우드에 업로드되지 않습니다.

## 기술 아키텍처

| 레이어 | 기술 |
|--------|------|
| 데스크톱 | Tauri 2 + React 19 + TypeScript |
| 백엔드 | Python 3.13 + FastAPI + WebSockets |
| 데이터베이스 | SQLite + Kuzu 그래프 DB + LanceDB 벡터 DB |
| AI 모델 | 로컬 LLM + 의미 검색 |
| 자동화 | Playwright 브라우저 자동화 |

**로컬 우선**: 모든 AI 계산은 로컬에서 완료되며, API Key가 필요 없습니다.

## 설치 및 사용

```bash
# 저장소 클론
git clone https://github.com/vasu-devs/JustHireMe.git
cd JustHireMe

# 프론트엔드 의존성 설치
npm install

# 개발 서버 시작
npm run dev

# 데스크톱 앱 시작
npm run tauri dev
```

## 사용 프로세스

1. **프로필 설정**: 이력서 업로드, 기술과 목표 입력
2. **크롤링 소스 구성**: 모니터링할 채용 플랫폼 선택
3. **크롤링 실행**: AI가 최신 포지션을 자동으로 크롤링
4. **매칭 보기**: 매칭도순 정렬, 고점수 포지션 필터링
5. **원클릭 지원**: AI가 맞춤형 자료 생성, 자동 제출
6. **진행 상황 추적**: CRM으로 모든 지원 상태 관리

## 왜 오픈소스인가?

구직은 플랫폼에 의해 독점되어서는 안 됩니다:
- **데이터 소유권**: 당신의 이력서, 당신의 데이터
- **알고리즘 투명성**: AI가 어떻게 평가하는지 알 수 있음
- **무료 사용**: 구독료 없음, 숨겨진 비용 없음
- **커뮤니티 주도**: 모두가 함께 개선

## 누구에게 적합한가?

- **구직자**: 더 많이, 더 잘, 더 빠르게 지원하고 싶은 사람
- **프리랜서**: 계약과 프로젝트를 찾는 사람
- **전환 희망자**: 맞춤형 이력서가 필요한 사람
- **신입**: 어디서 시작해야 할지 모르는 사람
- **시니어**: 고품질 기회를 수동적으로 받고 싶은 사람

## 관련 기사

- [Agent Reach：AI 에이전트를 인터넷 마스터로 만드는 원클릭 솔루션](/kr/resources/llm-frameworks/agent-reach-ai-agent-internet-access/)
- [Free Claude Code：비용 부담 없이 Claude Code 사용하기](/kr/resources/ai-tools/free-claude-code-open-source-proxy/)
- [OpenClaw 42개 실제 사용 사례：AI 에이전트가 이미 이렇게 우리의 삶을 바꾸고 있습니다](/kr/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/)

---

**프로젝트 주소**: [github.com/vasu-devs/JustHireMe](https://github.com/vasu-devs/JustHireMe)

**Stars**: 471 ⭐ | **Forks**: 91 | **언어**: Python 47.3%, TypeScript 27.5%

---

## 추천 도구

오픈소스 AI 도구 개발/배포 시 권장:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전, AI 워크로드용 원클릭 droplet.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API 프록시. 위의 AI 도구 대부분 (챗봇, 코드 생성, 번역, 검색 등) LLM API 키 필요 — 이 프록시로 안정적인 톱 모델 액세스, 공식 가격의 ~30%.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

