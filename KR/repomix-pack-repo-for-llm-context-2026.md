---
title: 'repomix 2026: 전체 코드베이스를 LLM 컨텍스트용 단일 파일로 패킹 — 제로 설정'
description: 'repomix(구 repopack)는 Git 저장소 전체를 Claude, ChatGPT, Gemini의 컨텍스트 창에 최적화된 단일 구조화 텍스트 파일로 변환합니다. 14k+ 스타, 제로 설정, npx로 즉시 실행.'
date: 2026-06-09 00:00:00+08:00
lastmod: 2026-06-09 00:00:00+08:00
tech_stack: ['Node.js', 'TypeScript', 'CLI']
application_domain: Dev Utils
source_version: 'v0.3'
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: 'https://github.com/yamadashy/repomix'
backup_url: ''
github_repo: 'yamadashy/repomix'
stars: 14200
maintainer: 'yamadashy'
last_maintained: '2026-06-01'
featureImage: '/images/articles/repomix-pack-repo-for-llm-context-2026/cover.jpg'
draft: false
categories: ['dev-utils']
tags: ['repomix', 'repopack', 'AI코딩', 'LLM컨텍스트', '코드베이스패킹', 'Claude', 'ChatGPT', '개발자도구', '오픈소스']
aliases:
- /kr/posts/repomix-pack-repo-for-llm-context-2026/
faqs:
  - q: 'repomix란 무엇이며 이전 이름은 무엇이었습니까?'
    a: 'repomix(구 repopack)는 전체 Git 저장소를 LLM 컨텍스트 창에 최적화된 단일 구조화 텍스트 파일로 패킹하는 오픈소스 CLI 도구입니다. npm의 기존 "repack" 명령과의 혼동을 피하기 위해 2025년에 "repopack"에서 "repomix"로 이름이 변경되었습니다. yamadashy가 개발했으며 MIT 라이선스입니다.'
  - q: 'repomix가 지원하는 출력 형식은 무엇입니까?'
    a: 'repomix는 세 가지 출력 형식을 지원합니다: 일반 텍스트(기본값, ChatGPT 등 일반 LLM에 적합), XML(Claude에 최적 — Claude는 XML을 기본으로 사용), 마크다운(Copilot, 문서 워크플로에 적합). --style plain|xml|markdown으로 선택합니다.'
  - q: 'repomix는 얼마나 큰 코드베이스를 처리할 수 있습니까?'
    a: 'repomix는 약 100,000–200,000 토큰(대략 5,000–10,000개 파일 프로젝트)까지 잘 작동합니다. 더 큰 저장소의 경우 --include 패턴을 사용하여 관련 서브시스템만 전송하세요. --output-show-line-numbers 플래그는 LLM이 정확한 줄 참조로 편집 제안을 하는 데 도움이 됩니다.'
---

![repomix 2026: 코드베이스를 LLM 컨텍스트로 패킹 — dibi8.com](/images/articles/repomix-pack-repo-for-llm-context-2026/cover.jpg)

Claude나 ChatGPT에게 멀티파일 이슈를 디버깅해달라고 할 때, 코드 스니펫을 하나씩 붙여넣으면 금방 컨텍스트를 잃게 됩니다. [repomix](https://github.com/yamadashy/repomix)는 전체 저장소를 하나의 구조화된 파일로 변환해 이 문제를 해결합니다.

## repomix가 하는 일

repomix는 저장소를 스캔하고, `.gitignore`의 파일을 제외한 후, 다음을 포함하는 단일 텍스트 파일을 출력합니다:

1. **저장소 요약** — 전체 파일 수, 토큰 추정치, 언어 분포
2. **디렉토리 트리** — 전체 폴더 구조
3. **모든 소스 파일** — 각 파일 앞에 경로 헤더와 선택적 줄 번호

## 제로 설정 시작

```bash
# 설치 없이 npx로 실행
npx repomix

# 전역 설치
npm install -g repomix

# 특정 디렉토리 패킹
repomix ./src

# 원격 GitHub 저장소 직접 패킹 (git clone 불필요)
npx repomix --remote https://github.com/user/repo
```

## 출력 형식

| 형식 | 플래그 | 최적 용도 |
|------|--------|----------|
| 일반 텍스트 | `--style plain` (기본값) | ChatGPT, 일반 LLM |
| XML | `--style xml` | Claude (기본 XML 사용), 구조화 파싱 |
| 마크다운 | `--style markdown` | Copilot, 문서 워크플로 |

## 출력 필터링 (대규모 프로젝트용)

```bash
# src/의 TypeScript 파일만 포함
repomix --include "src/**/*.ts"

# 테스트 파일과 빌드 산출물 제외
repomix --ignore "**/*.test.ts,dist/**"

# 줄 번호 표시 (LLM이 정확한 편집 위치 제공에 유용)
repomix --output-show-line-numbers
```

## 일반적인 LLM 워크플로

```bash
# 전체 코드베이스 코드 리뷰
repomix --style xml --output review.xml
# → Claude Project에 업로드
# → "이 코드베이스의 보안 문제와 아키텍처 이슈를 검토해주세요"

# 원격 저장소 분석 (클론 불필요)
npx repomix --remote https://github.com/some-org/some-project
# → "이 프로젝트의 아키텍처를 요약하고 어떤 디자인 패턴을 사용하는지 설명해주세요"
```

## 보안: `.repomixignore`

repomix는 기본적으로 `.gitignore`를 존중하지만, gitignore되지 않은 민감한 파일(로컬 `.env` 파일 등)이 출력에 포함될 수 있습니다. 프로젝트 루트에 `.repomixignore` 파일을 생성하여 민감한 파일을 명시적으로 제외하세요:

```
.env
.env.local
config/credentials.json
```

> **AI 개발 도구를 구축할 서버가 필요하신가요?** [DigitalOcean 신규 사용자는 $200 크레딧을 받습니다](https://m.do.co/c/eca87ac14ee0) — 개발 서버를 실행하거나 AI 지원 코드베이스를 배포하기에 충분합니다.

**GitHub:** [yamadashy/repomix](https://github.com/yamadashy/repomix) · 14.2k ⭐ · MIT
