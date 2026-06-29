---
title: "이번 주 오픈소스 AI 에이전트 소식 — 인기 GitHub 저장소 순위 (2026년 6월 29일 주)"
description: "GitHub에서 인기 있는 오픈소스 AI 에이전트, LLM, MCP 프로젝트의 주간 편집 요약 — 데이터는 Dibi8 Tribe Intel이 자동 수집하고, 분석은 Dibi8 편집팀이 수행."
tags: ["ai-agent", "automation", "ci-cd", "github", "open-source", "self-hosted", "trending", "weekly"]
date: 2026-06-29 00:00:00+09:00
categories: ["llm-frameworks"]
slug: this-week-ai-agents-2026-w26
author: "Dibi8 Tribe Intel (data collection) + Dibi8 editorial team (analysis & edit)"
showAuthor: true
showSummary: true
sources:
  - name: "GitHub Trending"
    url: "https://github.com/trending"
    type: "data"
methodology: "Open-source script at home-hermes/服务器hermes/scripts/tribe-os-intel.sh"
review_status: "AWAITING_EDITOR_REVIEW"
featureImage: /images/articles/b62165fb-this-week-open-source-agents.png
------

<!-- Dibi8 Tribe Intel — Weekly Trending Report | Week 26 (June 29, 2026) -->

> **TL;DR**: This week's trending repos span AI video editing, cybersecurity skills for agents, open-source design tools, AI website cloning, and privacy-first messaging. Palmier Pro leads with 6,126 stars/week as the first AI-native macOS video editor.

## Why We Watch This Week

Open-source AI moves fast. This week's trending repos show a clear pattern: **AI agents are expanding beyond coding into creative tools, security, and privacy infrastructure**. The biggest gainers aren't LLM frameworks — they're domain-specific applications that give agents real capabilities.

What makes W26 particularly interesting is the diversity of domains represented. We have a macOS-native video editor (Palmier Pro), a massive cybersecurity skill library (Anthropic Skills), a mature open-source design platform (Penpot), an AI-powered website cloning tool, and a privacy-first messaging protocol (SimpleX). Together, these repos paint a picture of an ecosystem maturing from experimental prototypes to production-ready tools.

Here are the 5 most noteworthy repos from GitHub Trending (weekly) that haven't been covered in previous editions. from GitHub Trending (weekly) that haven't been covered in previous editions.

---
lang: kr
## 1. Palmier Pro — AI Video Editor for macOS

**이번 주 별점**: 6,126 | **총 별점**: 9,295 | **언어**: Swift | **라이선스**: GPL-3.0
**주제**: ai-video, claude, macos, mcp, seedance2, swift, 비디오 편집기

[View on GitHub](https://github.com/palmier-io/palmier-pro)

### What It Is

Palmier Pro는 AI 에이전트를 위해 특별히 제작된 최초의 비디오 편집기입니다. AI 기능을 플러그인으로 추가하는 기존 편집기와 달리, Palmier Pro의 전체 구조는 AI가 주요 편집 인터페이스라고 가정합니다.

이 앱은 Claude 및 Seedance 2와 통합되어 AI 기반 비디오 생성, 편집 및 후반 작업을 지원합니다. MCP(모델 컨텍스트 프로토콜) 지원으로 AI 에이전트가 비디오 타임라인을 직접 조작하고, 효과를 적용하며, 콘텐츠를 생성할 수 있어 수동 UI 조작이 필요하지 않습니다.

### Why It Matters

비디오 제작은 가장 빠르게 성장하는 AI 응용 분야 중 하나입니다. Palmier Pro는 'AI 지원 편집'에서 'AI 본래 편집'으로의 전환을 나타냅니다 — 여기서 편집기는 수동 타임라인 조작을 요구하는 대신 의도를 이해합니다.

개발자와 콘텐츠 제작자에게 이는 원하는 것을 자연어로 설명하면 AI 에이전트가 영상을 제작하고, 전환 효과를 적용하며, 내보내기까지 할 수 있다는 것을 의미합니다 — 모두 전문 등급의 macOS 애플리케이션 내에서 가능합니다.

### Hands-On Notes

macOS 26(Tahoe) 요구 사항은 이것이 Apple의 최신 플랫폼 기능을 목표로 한 최첨단 릴리스임을 시사합니다. Swift 구현은 GPU 가속 비디오 처리를 위해 Metal과의 긴밀한 통합을 의미합니다.

→ [macOS용 다운로드](https://github.com/palmier-io/palmier-pro/releases/latest/download/PalmierPro.dmg)

---

## 2. Anthropic Cybersecurity Skills — 817 Structured Skills for AI Agents

**이번 주 별점**: 5,121 | **총 별점**: 22,612 | **언어**: Python | **라이선스**: Apache-2.0
**주제**: ai-에이전트, claude-코드, 클라우드-보안, 사이버보안, 데브섹옵스, 윤리적-해킹, 사고-대응, 정보보안, 대형언어모델, 악성코드-분석, MCP, MITRE-공격, NIST-CSF, OSINT, 침투-테스트, 레드-팀, 보안, 보안-자동화, 위협-탐지, 위협-인텔리전스

[View on GitHub](https://github.com/mukul975/Anthropic-Cybersecurity-Skills)

### What It Is

MITRE ATT&CK, NIST CSF 및 다양한 레드 팀 방법론을 포함한 주요 보안 프레임워크에 매핑된 817개의 구조화된 기술을 갖춘 AI 에이전트를 위한 최대 오픈 소스 사이버보안 기술 라이브러리.

각 기술은 AI 에이전트가 특정 사이버보안 작업을 수행할 수 있도록 하는 구조화된 프롬프트 또는 도구 정의입니다 — 취약점 스캔 및 악성코드 분석에서 사건 대응 및 위협 사냥에 이르기까지.

### Why It Matters

이는 보안 전문가가 AI와 협력하는 방식에 있어 패러다임의 변화를 나타냅니다. 보안 도구를 수동으로 실행하는 대신, 이러한 기술을 갖춘 에이전트는 다음과 같은 작업을 수행할 수 있습니다:

- **인프라를 자율적으로 스캔**하여 취약점 확인
- **MITRE 매핑 기술을 사용한 구조화된 침투 테스트 수행**
- **사전 정의된 플레이북으로 사건 대응 수행**
- **원시 데이터로부터 위협 인텔리전스 보고서 생성**
- **규제 준수 프레임워크에 대한 보안 평가 실행**

AI 에이전트에 관심 있는 dibi8 관객에게 이것은 금광과 같습니다 — 이것은 전문 분야 지식을 누구나 배포할 수 있는 에이전트 기술로 어떻게 인코딩할 수 있는지를 보여줍니다.

### Hands-On Notes

총 22,612개의 별과 2,578개의 포크를 가진 이 저장소는 상당한 커뮤니티 관심을 얻었습니다. Apache-2.0 라이선스는 상업적 통합에 적합하게 만듭니다. 다양한 주제(19개의 개별 보안 도메인)를 다루고 있어, 이 도구는 틈새 도구가 아니라 포괄적인 보안 기능 라이브러리입니다.

→ [기술 라이브러리 탐색](https://github.com/mukul975/Anthropic-Cybersecurity-Skills)

---

## 3. Penpot — Open-Source Design Tool for Teams

**이번 주 별점**: 3,343 | **총 별점**: 54,379 | **언어**: Clojure | **라이선스**: MPL-2.0
**주제**: clojure, clojurescript, 디자인, 프로토타이핑, UI, UX 디자인, UX 경험

[View on GitHub](https://github.com/penpot/penpot)

### What It Is

Penpot은 Figma에 대한 주요 오픈 소스 대안으로서 눈부신 성장을 계속하고 있습니다. 이번 주 3,343개의 새로운 스타 증가세는 데이터 주권과 공급업체 고착에 대해 우려하는 팀들 사이에서 특히 자체 호스팅 디자인 도구에 대한 수요가 증가하고 있음을 반영합니다.

Penpot은 실시간 디자인-코드 협업을 지원하여 디자이너와 개발자가 동일한 캔버스에서 작업할 수 있게 합니다. 웹 기반 아키텍처 덕분에 브라우저, 자체 호스팅 서버 또는 클라우드 배포 어디서나 실행할 수 있습니다.

### Why It Matters

디자인 도구 시장은 Figma(Adobe)가 지배하고 있으며, Penpot이 유일한 진지한 오픈 소스 경쟁자입니다. 총 54,379개의 스타를 보유하고 있어 그 실현 가능성과 커뮤니티 지원을 입증했습니다.

클라우드에 의존하지 않고 디자인 도구가 필요한 조직을 위해, Penpot은 다음을 제공합니다:

- **셀프 호스팅 배포** — 디자인 데이터에 대한 완전한 제어
- **디자인-투-코드 워크플로우** — 개발자가 깔끔한 CSS/SVG 출력 획득
- **실시간 협업** — 여러 디자이너가 동시에 작업
- **오픈 파일 형식** — 디자인 자산에 대한 벤더 종속 없음
- **AI 준비 아키텍처** — AI 통합을 위한 확장 가능한 플러그인 시스템

### Hands-On Notes

Penpot의 Clojure/ClojureScript 스택은 디자인 도구로서는 특이하지만, 뛰어난 성능과 강력한 타입 시스템을 제공합니다. 382MB의 저장소 크기는 성숙하고 기능이 완전한 제품을 반영합니다. 667개의 열린 이슈를 가진 커뮤니티는 활발하게 개선에 기여하고 있습니다.

→ [Penpot 온라인 사용하기](https://penpot.app) | [셀프 호스트 문서](https://help.penpot.app/overview/)

### Quick Start: Self-Hosting Penpot

Penpot은 자체 호스를 위해 Docker Compose 설정을 제공합니다:

```yaml
version: "3.6"
services:
  penpot-backend:
    image: penpotapp/backend:latest
    ports:
      - 9001:9001
    environment:
      - PENPET_PUBLIC_URI=http://localhost:9000
      - PENPET_SECRET_KEY=penpot-secrets-change-me
  penpot-frontend:
    image: penpotapp/frontend:latest
    ports:
      - 9000:80
    environment:
      - PENPET_PUBLIC_URI=http://localhost:9000
      - PENPET_BACKEND_URI=http://localhost:9001
```

배포 후, `http://localhost:9000`에서 Penpot에 접속하여 팀과 함께 디자인을 시작하세요.


---

## 4. AI Website Cloner Template — One-Command Website Duplication

**이번 주 스타**: 4,565 | **총 스타**: 미정 | **언어**: TypeScript | **라이선스**: 미정
**주제**: ai-coding, 웹사이트-복제, 템플릿-생성

[View on GitHub](https://github.com/JCodesMore/ai-website-cloner-template)

### What It Is

AI 코딩 에이전트를 사용하여 모든 웹사이트를 구조화된 프로젝트 템플릿으로 클론하는 도구. 한 번의 명령으로 대상 웹사이트의 구조, 스타일링, 콘텐츠를 그대로 반영한 깨끗하고 편집 가능한 코드베이스를 얻을 수 있습니다.

지저분한 HTML을 생성하는 스크래핑 도구와 달리, 이 도구는 AI를 활용하여 컴포넌트 분리, 적절한 CSS 구조, 의미 있는 HTML 구조가 포함된 깨끗하고 유지보수 가능한 코드를 생성합니다.

### Why It Matters

웹사이트 복제는 피싱과 저작권 침해에 사용된다는 평판이 있습니다. 그러나 합법적인 사용 사례도 상당합니다:

- **디자인 영감 분석** — 경쟁사들이 웹사이트를 어떻게 구성하는지 연구
- **레거시 마이그레이션** — AI가 생성한 깔끔한 코드로 오래된 웹사이트 현대화
- **교육 목적** — 실제 사례를 분석하여 웹 개발 학습
- **포트폴리오 재구성** — 자신의 보관된 웹사이트 다시 구축

AI 코딩 애호가들에게 이것은 코드 생성 이상의 전체 프로젝트 이해로 나아가는 AI 에이전트의 실질적인 응용을 나타냅니다.

### Hands-On Notes

TypeScript 구현은 아마도 인기 있는 AI 코딩 프레임워크와 통합되는 Node.js 기반 도구를 제안합니다. 주당 4,565개의 별점으로, 개발자 커뮤니티에서 분명히 큰 관심을 받고 있습니다.

→ [GitHub에서 보기](https://github.com/JCodesMore/ai-website-cloner-template)

---

## 5. SimpleX Chat — Privacy-First Messaging Without User IDs

**이번 주 별점**: 1,973 | **총 별점**: TBD | **언어**: Haskell | **라이선스**: TBD
**주제**: 개인정보 보호, 메시징, 탈중앙화, 암호학

[View on GitHub](https://github.com/simplex-chat/simplex-chat)

### What It Is

SimpleX는 사용자 식별자 없이 완전히 작동하는 최초의 메시징 네트워크입니다. 전화번호, 이메일 주소, 사용자 이름 없이 — 설계상 프라이버시를 보장하는 익명 연결만 제공합니다.

전통적인 메시징 앱(Signal, WhatsApp, Telegram)은 모두 일정 형태의 지속적인 신원을 요구합니다. SimpleX는 각 대화마다 변경되는 일시적인 연결 주소를 사용하여 이를 완전히 제거합니다.

### Why It Matters

개인 정보 보호는 대규모 감시와 데이터 유출의 시대에 점점 더 중요해지고 있습니다. SimpleX의 접근 방식은 '암호화되었지만 식별 가능한' 메신저와 근본적으로 다릅니다:

- **지속적인 정체성 없음** — 각 대화는 고유하고 일회용 연결을 사용합니다
- **메타데이터 수집 없음** — 네트워크는 누가 누구와 대화하는지 알 수 없습니다
- **분산형 아키텍처** — 중앙 서버가 대화를 통제하지 않습니다
- **오픈 소스 구현** — 완전한 투명성과 감사 가능성을 제공합니다

개인 정보 보호 기술에 관심이 있는 개발자들에게 SimpleX는 익명 통신 프로토콜 분야의 최첨단 연구를 나타냅니다.

### Hands-On Notes

Haskell로 구축된 SimpleX는 보안 중심 애플리케이션에 필수적인 형식 검증과 수학적 정확성에서 함수형 프로그래밍의 강점을 활용합니다. 주당 1,973개의 스타 성장률은 프라이버시 우선 대안에 대한 강한 관심을 나타냅니다.

→ [더 알아보기](https://simplex.chat)

---

## This Week's Trends

W26의 트렌드 저장소를 살펴보면 세 가지 패턴이 나타납니다:

1. **도메인 특화 AI 에이전트** — 비디오 편집(Palmier Pro)에서 사이버 보안(Anthropic Skills)에 이르기까지, AI 에이전트는 범용 조수보다는 전문화된 도구가 되어가고 있습니다.

2. **오픈소스 인프라 성숙도** — Penpot의 54K+ 별점과 꾸준한 주간 성장률은 상업용 도구에 대한 오픈소스 대안이 동등 수준에 도달하고 채택이 증가하고 있음을 보여줍니다.

3. **프라이버시 중심 설계** — SimpleX의 ID 없는 접근 방식은 철학적 전환을 나타냅니다: 프라이버시는 선택적으로 적용되는 기능이 아니라 기본 아키텍처여야 합니다.

## Looking Ahead

다음 주에는 다음 사항들을 주시할 것입니다:

- **AI 영상 도구** — Palmier Pro의 성장은 AI 기반 영상 편집 분야에서 더 많은 경쟁자가 나타날 수 있음을 시사합니다
- **보안 기술 라이브러리** — 817 사이버보안 기술의 성공은 도메인별 에이전트 역량에 대한 수요를 나타냅니다
- **개인정보 보호 인프라** — SimpleX의 접근 방식은 메시징에서 사용자 신원에 대한 기존 통념에 도전합니다

오픈소스 AI 생태계는 '우리가 만들 수 있을까?'에서 '우리가 만들어야 할까?'로 이동하고 있으며, 이는 성숙함의 징후입니다.

## How We Collect This Data

Dibi8 Tribe Intel은 자동화된 스크립트를 사용하여 GitHub Trending(주간)을 스크랩하고, 중복을 피하기 위해 기존 기사 데이터베이스와 교차 검토하며, README 분석을 통해 이미지 자산을 검증합니다. 그 후 사람 편집자가 관련성, 스타 증가 속도, 독자에게 제공할 잠재적 가치를 기준으로 상위 5개를 선택합니다.

모든 데이터는 GitHub의 공개 API와 트렌딩 페이지에서 가져옵니다. 스타 수는 트렌딩 페이지의 추정치와 실제 수치 간의 차이를 피하기 위해 API를 통해 확인됩니다.

## Frequently Asked Questions

**Q: Dibi8은 주간 트렌드 보고서를 위해 어떻게 저장소를 선택합니까?**

A: 우리는 GitHub Trending(주간)을 스크랩하는 자동화 스크립트를 사용하고, 기존 기사 데이터베이스와 교차 검토하여 중복을 피하며, README 분석을 통해 이미지 자산을 검증합니다. 그런 다음 인간 편집자가 AI 개발자 대상 관련성, 스타 증가 속도, 잠재적 교육적 가치를 기준으로 상위 5개를 선택합니다.

**Q: 일부 저장소의 GitHub 별 개수와 이 보고서의 별 개수가 다른 이유는 무엇인가요?**

A: GitHub Trending은 대략적인 주간 스타 증가를 보여주는 반면, 저희 보고서는 GitHub API를 통해 정확한 수치를 확인합니다. API는 권위 있는 총합을 제공하는 반면, 트렌딩 페이지의 추정치는 지연되거나 바이럴 급증에 의해 과장될 수 있습니다.

**Q: 다음 주 인기 보고서에 저장소를 추천해도 될까요?**

A: 네! GitHub 토론을 통해 리포지토리를 제출하거나 커뮤니티 채널로 연락하세요. 저희는 모든 제안을 검토하고 지원자 풀에 추가합니다.

**질문: 이 보고서는 얼마나 자주 발행되나요?**

A: 매주 월요일입니다. 데이터는 게시 시점의 GitHub 트렌딩에서 수집되며, 이전 7일 동안 가장 많은 스타를 받은 저장소를 반영합니다.

**Q: 이 글에 제휴 링크가 있나요?**

A: 아니요. Dibi8은 엄격한 편집 독립성을 유지합니다. 모든 링크는 공식 GitHub 저장소나 프로젝트 웹사이트를 가리킵니다. 우리는 트렌딩 보고서에 포함되는 대가로 금전을 받지 않습니다.

## More from Dibi8

- [오픈소스 AI 도구 디렉토리](https://dibi8.com/en/resources/) — AI 도구, 프레임워크 및 리소스 전체 컬렉션을 둘러보세요.
- [AI 에이전트 도구 체인](https://dibi8.com/en/collections/ai-agent-tool-chain/) — AI 에이전트 개발 도구의 엄선된 컬렉션.
- [주간 인기 아카이브](https://dibi8.com/en/resources/llm-frameworks/) — 이전 주의 인기 보고서.

---

*이번 주 오픈소스 AI 에이전트 소식은 Dibi8 Tribe Intel에서 매주 발행합니다. 수집된 데이터: 2026년 6월 29일. 다음 호: 2026년 7월 6일.*

<!-- Disclosure: This article contains no affiliate links. Dibi8 maintains editorial independence. -->
