---
title: "HowToCook 프로그래머 요리 가이드: 코딩을 더 향기롭게 하는 297개 오픈소스 레시피"
description: "HowToCook 프로그래머 요리 가이드를 탐색하세요 — 코드처럼 정확하게 요리하는 297개 오픈소스 레시피. 토마토 계란볶음부터 베이징 덕까지, 난이도 분류, 명확한 단계."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Docker
  - JavaScript
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "455.3 MB"
file_md5: ""
download_url: "https://github.com/Anduin2017/HowToCook"
backup_url: ""
github_repo: "https://github.com/Anduin2017/HowToCook"
stars: 100171
maintainer: "Anduin2017"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /kr/posts/howtocook-programmer-open-source-cookbook/
faqs:
  - q: 'HowToCook이란 무엇인가요?'
    a: 'HowToCook(程序员做饭指南)은 프로그래머 Anduin2017이 만든 오픈 소스 레시피 프로젝트로, 개발자가 문서에서 기대하는 수준의 정밀함과 명확함으로 작성된 297가지 레시피를 담고 있습니다.'
  - q: 'HowToCook은 기존 레시피와 어떻게 다른가요?'
    a: '''소금 약간''이나 ''노릇해질 때까지 볶기'' 같은 모호한 표현 대신, 모든 레시피에 정확한 계량(예: ''소금 3g''), 정확한 시간(예: ''한 면당 90초 볶기''), 완전한 사전 재료 목록, 필요 도구 목록, 그리고 1-5성 난이도 등급이 명시되어 있습니다.'
  - q: 'HowToCook 레시피의 난이도 등급은 어떻게 되나요?'
    a: '레시피는 1-5성 체계를 사용합니다. 1성은 토마토 달걀볶음, 인스턴트 라면 같은 간단한 요리이고, 5성은 샥스핀 수프, 전복죽 같은 고급 요리입니다. 전체 컬렉션은 1성 45개, 2성 78개, 3성 89개, 4성 56개, 5성 29개로 구성되어 있습니다.'
  - q: 'Docker로 HowToCook을 로컬에서 실행하는 방법은 무엇인가요?'
    a: '다음 명령으로 이미지를 받아 실행하세요: docker pull ghcr.io/anduin2017/how-to-cook:latest 후 docker run -d -p 5000:5000 ghcr.io/anduin2017/how-to-cook:latest를 실행하고, http://localhost:5000에서 접속합니다.'
  - q: 'HowToCook에 레시피를 기여하는 방법은 무엇인가요?'
    a: '저장소를 Fork하고, 템플릿 레시피를 복사한 뒤, 프로젝트의 구조화된 형식에 맞게 레시피를 작성하고 Pull Request를 제출하면 됩니다. 이 프로젝트에는 200명 이상의 기여자가 있으며 중국어, 영어, 일본어를 지원합니다.'
---
{</* resource-info */>}

## HowToCook란?

**HowToCook**（프로그래머 요리 가이드）는 프로그래머 **Anduin2017**이 만든 오픈소스 레시피 프로젝트입니다. **297개 레시피**가 프로그래머가 익숙한 정확성과 명확성으로 작성되었습니다.

프로젝트 철학: **레시피는 코드처럼 명확해야 합니다**. "소금 조금"이나 "노랗게 볶을 때까지" 같은 모호한 설명 없이, 모든 레시피는 정확한 계량, 정확한 시간, 단계별 프로세스를 제공합니다.

**GitHub**: https://github.com/Anduin2017/HowToCook  
**Stars**: 70K+  
**기여자**: 200+  
**라이선스**: Unlicense

---

## 왜 프로그래머가 이것이 필요한가?

### 기존 레시피의 문제

| 문제 | 예시 | HowToCook 해결책 |
|------|------|-------------------|
| 모호한 양 | "소금 조금" | "소금 3g（1/2 티스푼）" |
| 애매한 시간 | "노랗게 볶을 때까지" | "한 면당 90초 볶기" |
| 누락된 단계 | 중간에 새로운 재료 등장 | 완전한 재료 목록 먼저 |
| 난이도 없음 | 모든 요리가 똑같이 어려워 보임 | 1-5성 난이도 시스템 |
| 장비 목록 없음 | 모든 것이 있다고 가정 | 필요한 도구 먼저 나열 |

### 개발자를 위한 특성

- **구조화된 형식**: 매개변수가 있는 함수처럼
- **난이도 등급**: 1-5성（라면에서 베이징 덕까지）
- **장비 요구사항**: 재료 전에 나열
- **정확한 계량**: g, ml, "한 꼬집" 아님
- **시간 추적**: 준비 시간, 조리 시간, 총 시간
- **에러 처리**: 일반적인 실수와 피하는 방법

---

## 레시피 분류

### 난이도별

| 성급 | 수량 | 예시 |
|------|------|------|
| ⭐ | 45 | 토마토 계란볶음, 라면 업그레이드 |
| ⭐⭐ | 78 | 궁보계정, 홍소육 |
| ⭐⭐⭐ | 89 | 탕초排骨, 마파두부 |
| ⭐⭐⭐⭐ | 56 | 베이징 덕, 훠궈 베이스 |
| ⭐⭐⭐⭐⭐ | 29 | 상어 지느러미 수프, 전복 죽 |

### 종류별

- **채소**: 85道（볶음, 조림, 찜）
- **고기**: 92道（돼지, 소, 닭, 양）
- **해산물**: 34道（생선, 새우, 게）
- **국물**: 46道（빠른 국, 느린 끓임）
- **아침**: 23道（죽, 팬케이크, 샌드위치）
- **디저트**: 17道（케이크, 푸딩, 단팥죽）

---

## 샘플 레시피: 토마토 계란볶음

```markdown
# 토마토 계란볶음 ⭐

## 재료
- 계란 2개（100g）
- 토마토 2개（300g）
- 소금 3g（1/2 티스푼）
- 설탕 5g（1 티스푼）
- 식용유 10ml
- 파 2g（선택）

## 조리도구
- 프라이팬
- 뒤집개
- 볼

## 시간
- 준비: 5분
- 조리: 5분
- 총계: 10분

## 단계
1. 계란을 볼에 깨서 소금 1g 넣고 균일하게 휘핑
2. 토마토를 씻어 2cm 덩이로 자르기
3. 중불로 프라이팬을 180°C까지 가열
4. 기름을 두르고 10초 대기
5. 계란을 부어 30초간 계속 저으며 볶기
6. 계란이 80% 익었을 때（약간 촉촉한 상태）꺼내기
7. 같은 팬에 토마토 넣고 2분 볶기
8. 남은 소금과 설탕 추가
9. 계란을 다시 팬에 넣고 20초 섞기
10. 즉시 서빙

## 팁
- 계란을 너무 오래 볶지 마세요 — 꺼낸 후에도 익어갑니다
- 토마토가 너무 신맛이 나면 설탕 1g 더 추가
- 더 부드러운 식감을 원하면 계란에 우유 10ml 추가
```

---

## 커뮤니티와 기여

### 기여 방법

1. **Fork** 저장소
2. **복사** 템플릿 레시피
3. **작성** 형식에 맞는 레시피
4. **제출** Pull Request

### 기여 통계

- **200+ 기여자** 전 세계에서
- **297개 레시피** 지속적으로 증가
- **다국어 지원**: 중국어, 영어, 일본어
- **Docker 지원**: 한 줄 명령으로 로컬 실행

### 웹 배포

```bash
# 로컬 배포
docker pull ghcr.io/anduin2017/how-to-cook:latest
docker run -d -p 5000:5000 ghcr.io/anduin2017/how-to-cook:latest

# http://localhost:5000 접속
```

---

## NPM 패키지

Node.js 패키지로 설치:

```bash
npm install how-to-cook
```

프로그래밍 방식 사용:

```javascript
const recipes = require('how-to-cook');

// 레시피 검색
const tomatoRecipes = recipes.search('토마토');

// 난이도로 필터링
const easyRecipes = recipes.filterByStars(1);

// 랜덤 가져오기
const dinner = recipes.random();
```

---

## 학습 경로

### 초보자（1-2주）
- 주방 준비
- 기본 칼 기술
- 1성 레시피
- 밥 짓기

### 중급자（3-4주）
- 2-3성 레시피
- 육류 처리
- 볶음 기술
- 국물 기초

### 고급자（5주+）
- 4-5성 레시피
- 다중 요리 조율
- 맛 균형
- 플레이팅

---

## 왜 이 프로젝트가 주목받아야 하는가

**HowToCook**은 다음의 완벽한 예시입니다:

1. **커뮤니티 기반 콘텐츠**: 200+ 기여자가 진정한 콘텐츠를 창조
2. **구조화된 데이터**: 레시피는 schema.org 형식을 따름
3. **롱테일 키워드**: "프로그래머 요리 가이드", "how to cook for developers"
4. **에버그린 콘텐츠**: 요리는 결코 시대에 뒤떨어지지 않음
5. **다국어**: 중국어, 영어, 일본어 버전

---

## 관련 기사

- [Free Claude Code 오픈소스 AI 코딩 에이전트](/kr/resources/ai-tools/free-claude-code-open-source-proxy/) — 또 다른 개발자 오픈소스 도구
- [Pixelle-Video AI 쇼트 비디오 생성기](/kr/resources/ai-tools/pixelle-video-ai-short-video-generator/) — AI 콘텐츠 제작 도구
- [OpenClaw 42개 사용 사례](/kr/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/) — AI 에이전트 일상 작업

---

*면책 조항: 본 문서는 오픈소스 프로젝트를 소개합니다. 모든 레시피 콘텐츠는 HowToCook 커뮤니티에 속합니다. 요리 시 식품 안전 지침을 따르세요.*

---

## 추천 도구

오픈소스 AI 도구 개발/배포 시 권장:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전, AI 워크로드용 원클릭 droplet.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API 프록시. 위의 AI 도구 대부분 (챗봇, 코드 생성, 번역, 검색 등) LLM API 키 필요 — 이 프록시로 안정적인 톱 모델 액세스, 공식 가격의 ~30%.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

