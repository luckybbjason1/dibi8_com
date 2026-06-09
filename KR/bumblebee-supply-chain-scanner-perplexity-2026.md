---
title: 'Bumblebee 2026: Perplexity AI 내부 공급망 스캐너 오픈소스화 — MCP 설정·에디터 확장 지원'
description: 'Bumblebee는 Perplexity AI의 오픈소스 읽기 전용 공급망 스캐너입니다. npm, PyPI, Go 모듈, MCP 설정, 에디터 확장, 브라우저 확장에서 알려진 침해 패키지를 검사하며, 코드를 단 한 줄도 실행하지 않습니다.'
date: 2026-06-09 00:00:00+08:00
lastmod: 2026-06-09 00:00:00+08:00
tech_stack: ['Go', 'Security', 'CLI']
application_domain: Dev Utils
source_version: '0.1.1'
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: 'https://github.com/perplexityai/bumblebee'
backup_url: ''
github_repo: 'perplexityai/bumblebee'
stars: 1500
maintainer: 'perplexityai'
last_maintained: '2026-05-22'
featureImage: '/images/articles/bumblebee-supply-chain-scanner-perplexity-2026/cover.jpg'
draft: false
categories: ['dev-utils']
tags: ['bumblebee', '공급망-보안', 'MCP', 'security', 'Go', 'npm', 'PyPI', 'perplexity-ai']
aliases:
- /kr/posts/bumblebee-supply-chain-scanner-perplexity-2026/
faqs:
  - q: 'Bumblebee란 무엇이며 무엇을 스캔합니까?'
    a: 'Bumblebee는 Perplexity AI가 오픈소스로 공개한 읽기 전용 개발자 엔드포인트 스캐너입니다. npm, pnpm, Yarn, PyPI, Go 모듈, RubyGems, MCP 설정, 에디터 확장(VS Code, Cursor, Windsurf, Zed), 브라우저 확장의 디스크 메타데이터를 스캔합니다. 설치 스크립트를 실행하거나 패키지 관리자를 호출하지 않습니다.'
  - q: 'AI 개발자에게 MCP 스캔이 왜 중요합니까?'
    a: 'MCP(Model Context Protocol) 서버는 개발자 머신에서 높은 권한으로 실행됩니다. 침해된 MCP 패키지는 데이터를 유출하거나 임의 코드를 실행할 수 있습니다. Bumblebee는 MCP 설정 파일(claude_desktop_config.json, mcp_settings.json 등)을 위협 인텔리전스 카탈로그와 대조해 스캔하는 최초의 공개 도구입니다.'
  - q: '세 가지 스캔 프로필의 차이는 무엇입니까?'
    a: 'baseline은 전역 패키지 루트, 툴체인, 에디터 확장, MCP 설정을 스캔하며 일상적인 인벤토리에 적합합니다. project는 baseline에 개발 디렉터리(~/code 등)를 추가합니다. deep은 지정된 루트(보통 홈 디렉터리 전체)를 스윕하며 보안 사고 대응 시 사용합니다.'
  - q: 'Bumblebee 설치 방법은?'
    a: 'go install github.com/perplexityai/bumblebee/cmd/bumblebee@v0.1.1을 실행합니다. 일상 인벤토리는 bumblebee scan --profile baseline > inventory.ndjson, 특정 취약점 노출 검사는 bumblebee scan --profile deep --root "$HOME" --exposure-catalog ./catalog.json --findings-only를 사용합니다.'
---

![Bumblebee 2026: Perplexity AI 공급망 스캐너 — dibi8.com](/images/articles/bumblebee-supply-chain-scanner-perplexity-2026/cover.jpg)

2026년 5월 22일, Perplexity AI는 내부 보안 팀이 개발자 노트북 공급망 리스크 감사에 사용하던 도구인 [Bumblebee](https://github.com/perplexityai/bumblebee)를 오픈소스로 공개했습니다. 일주일도 안 돼 1,500개 이상의 GitHub 스타와 112개의 포크를 기록했습니다. 이 도구가 답하는 질문은 단 하나입니다: **침해된 패키지가 내 머신에 있는가?**

## 공급망 공격이 개발자를 먼저 노리는 이유

xz 사건, polyfill.io, AI 툴링을 겨냥한 수십 개의 악성 npm 패키지를 포함한 2024~2026년 공급망 사건들은 하나의 패턴을 공유합니다: 개발자 머신에 먼저 상륙하고, 수개월 후 프로덕션에서 피해를 입힙니다.

기존 SCA 도구(Snyk, Dependabot)는 코드가 선언한 의존성을 검사합니다. 이들이 놓치는 것: 전역 설치 CLI, 에디터 확장, 브라우저 확장, **MCP 설정 파일**. Bumblebee는 이 공백을 채웁니다.

## 읽기 전용 보장

이 도구의 핵심 제약은 **아무것도 실행하지 않는다**는 것입니다. `npm ls`, `pip check`, `go list` 없음. 공급망 공격은 점점 검사 단계 자체를 노립니다. Bumblebee는 디스크의 메타데이터 파일만 읽어 이 위험을 완전히 우회합니다.

## 세 가지 스캔 프로필

```bash
# 일상 전역 인벤토리
bumblebee scan --profile baseline > inventory.ndjson

# 프로젝트 범위 스캔
bumblebee scan --profile project --project-root ~/code

# 사고 대응 - 전체 홈 디렉터리 스윕
bumblebee scan --profile deep \
  --root "$HOME" \
  --exposure-catalog ./catalog.json \
  --findings-only \
  --max-duration 10m
```

## MCP 설정 지원

2026년 AI 개발자에게 가장 중요한 기능입니다. Bumblebee가 스캔하는 경로:

| 파일 | 도구 |
|------|------|
| `~/.claude.json` | Claude CLI |
| `claude_desktop_config.json` | Claude Desktop |
| `mcp_settings.json` | Cline / Roo Code |
| `.mcp.json` / `mcp.json` | 범용 MCP |
| `~/.gemini/settings.json` | Gemini CLI |

각 MCP 서버 항목에 대해 패키지 이름, 버전, 출처 레지스트리를 기록합니다. 노출 스캔 실행 시 MCP 패키지도 일반 의존성과 함께 검사됩니다.

## 제로 의존성 설계

Go 1.25로 작성되었으며 **표준 라이브러리 외 의존성 없음**. 결과물은 단일 정적 바이너리입니다.

```bash
go install github.com/perplexityai/bumblebee/cmd/bumblebee@v0.1.1
```

> **안전한 AI 인프라 구축:** MCP 서버나 AI 워크로드를 VPS에서 운영한다면 호스트 OS 강화가 최우선입니다. [월 $6 DigitalOcean Droplet](https://m.do.co/c/eca87ac14ee0)으로 방화벽, 사용자 격리, 감사 로깅을 직접 설정하세요. 신규 사용자에게 **$200 무료 크레딧** 제공.

**GitHub:** [perplexityai/bumblebee](https://github.com/perplexityai/bumblebee) · v0.1.1 · Apache-2.0
