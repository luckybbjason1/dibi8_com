---
title: 'Continue.dev: 33K+ Stars — 오픈소스 AI 코딩 어시스턴트, Copilot·Cursor 비교 2026'
description: 'Continue.dev(오픈소스 AI 코딩 어시스턴트) VS Code/JetBrains 플러그인. Ollama, OpenAI, Anthropic, Gemini 등 모든 LLM 지원. GitHub Copilot, Cursor, Tabby와 비교. 설치 튜토리얼, 설정 예제, 벤치마크.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/continuedev/continue'
stars: 33277
maintainer: 'continuedev'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['continue.dev', 'ai-coding-assistant', 'vs-code', 'jetbrains', 'open-source', 'ollama', 'copilot-alternative', 'local-llm', 'mcp']
aliases:
- /kr/posts/continue/
---

{{</* resource-info */>}}

![Continue.dev 배너](https://raw.githubusercontent.com/continuedev/continue/main/media/banner.png)

## 소개

GitHub Copilot을 사용해 본 개발자라면 AI 지원 코딩이 주는 생산성 향상을 알면서도 동시에 불편함을 경험했다: 월 10~19달러, 코드를 마이크로소프트 서버로 전송, 모델 교체 불가, 오프라인 사용 불가. 2026년 규제 산업의 엔지니어링 팀은 클라우드 전용 도구의 한계에 부딪히고 있다. **Continue.dev**는 이에 대한 해답이다: Apache-2.0 라이선스의 오픈소스 AI 코딩 어시스턴트로 GitHub Stars 33,277개, 473명 이상의 기여자, 그리고 Ollama가 동작하는 노트북부터 클라우드 API까지 모든 LLM을 네이티브 지원한다. 이 가이드에서는 설치, 설정, 실제 벤치마크, 그리고 Copilot·Cursor·Tabby와의 솔직한 비교를 다룬다.

## Continue.dev란?

**Continue.dev**는 VS Code, JetBrains IDE, Neovim에 AI 지원 코딩 보조 기능을 제공하는 오픈소스 IDE 확장 프로그램과 CLI 도구다. 폐쇄형 대안과 달리 Continue.dev는 OpenAI GPT-4o, Anthropic Claude, Google Gemini, 로컬 Ollama 인스턴스, 자체 호스팅 vLLM 엔드포인트 등 어떤 LLM 제공자에도 연결할 수 있다. 개발자가 어떤 모델이 코드를 처리하고 데이터가 어디에 저장되는지 완전히 제어할 수 있다. 처음에는 VS Code 플러그인으로 출시되었으나, CI 통합 PR 체크, 자율 다단계 작업을 위한 Agent 모드, 도구 통합을 위한 MCP(Model Context Protocol) 지원까지 갖춘 완전한 "Continuous AI" 플랫폼으로 진화했다.

핵심 수치 요약:

| 지표 | 수치 |
|------|------|
| GitHub Stars | 33,277+ |
| 기여자 | 473+ |
| 라이선스 | Apache-2.0 |
| 최신 버전 | v1.2.22 (VS Code) |
| 지원 IDE | VS Code, JetBrains (IntelliJ, PyCharm, WebStorm, GoLand, CLion), Neovim |
| 프로그래밍 언어 | Python, TypeScript, JavaScript, Java, Go, Rust, C++ 등 30+ |
| LLM 제공자 | 20+ (OpenAI, Anthropic, Google, Ollama, LM Studio, Mistral, DeepSeek 등) |

![Continue.dev GitHub 저장소](https://raw.githubusercontent.com/continuedev/continue/main/docs/static/img/logo.png)

## Continue.dev 작동 방식

Continue.dev는 IDE 확장 프로그램으로 작동하며, 편집기 컨텍스트를 가로채 구성 가능한 LLM 백엔드로 라우팅한다. 아키텍처는 세 레이어로 구성된다:

**IDE 레이어** — 확장 프로그램이 채팅 패널, 인라인 자동완성 엔진, Agent 실행기를 VS Code나 JetBrains에 직접 임베드한다. IDE의 네이티브 API를 통해 파일 콘텐츠, 터미널 출력, 프로젝트 구조를 읽는다.

**설정 레이어** — 단일 `config.yaml`(또는 레거시 `config.json`) 파일이 어떤 작업에 어떤 모델을 사용할지 정의한다. Continue는 "모델 역할"을 사용하여 채팅, 자동완성, 편집, Agent 작업에 서로 다른 LLM을 할당한다. 이는 복잡한 추론에는 Claude Sonnet을 사용하면서 빠른 로컬 1.5B 모델로 탭 완성을 처리할 수 있음을 의미한다.

**LLM 백엔드 레이어** — Continue는 표준 HTTP API를 사용한다. OpenAI 호환 엔드포인트, Anthropic 네이티브 API, Ollama 로컬 서버, 또는 프록시와 작동한다. 벤더 종속 없음: YAML 키를 변경하여 제공자를 교체한다.

2026년 릴리스에는 **CI/Checks 레이어**가 추가되었다 — 비동기 에이전트가 모든 Pull Request에서 실행되어 저장소 자체에 Markdown 파일로 저장된 코딩 표준을 강제한다.

![Continue.dev 아키텍처 개요](https://docs.continue.dev/img/set-up-your-model.png)

## 설치 및 설정

### VS Code 설치 (2분 이내)

```bash
# 방법 1: 마켓플레이스 검색
# VS Code 열기 → 확장 (Ctrl+Shift+X) → "Continue" 검색 → 설치

# 방법 2: 직접 설치
# VS Code 마켓플레이스에서 Continue 클릭
```

설치 후 `Ctrl+L`(또는 macOS에서 `Cmd+L`)로 Continue 사이드바를 연다.

### JetBrains IDE 설치 (3분 이내)

```bash
# JetBrains IDE 열기 (IntelliJ IDEA, PyCharm 등)
# 파일 → 설정 → 플러그인 → 마켓플레이스
# "Continue" 검색 → 설치 → IDE 재시작
```

### 설치 확인

Continue 채팅 패널을 열어 버전을 확인한다:

```bash
# VS Code: 사이드바 열기 (Ctrl+L) → 톱니바퀴 아이콘 → 버전 v1.2.22 표시
# 예상 결과: 왼쪽 사이드바에 주황색 "C" 아이콘 표시
```

### 첫 모델 설정 (config.yaml)

전역 설정 파일을 생성한다:

```bash
# macOS / Linux
mkdir -p ~/.continue
cat > ~/.continue/config.yaml << 'EOF'
name: 내 개발 환경
version: 1.0.0
schema: v1

models:
  - name: Claude Sonnet
    provider: anthropic
    model: claude-sonnet-4-6
    apiKey: ${{ secrets.ANTHROPIC_API_KEY }}
    roles: [chat, edit, agent]
    defaultCompletionOptions:
      temperature: 0.1
      maxTokens: 8192

  - name: GPT-4o
    provider: openai
    model: gpt-4o
    apiKey: ${{ secrets.OPENAI_API_KEY }}
    roles: [chat, edit]
EOF

# Windows: %USERPROFILE%\.continue\config.yaml
```

**API 키를 환경 변수로 설정:**

```bash
# ~/.bashrc 또는 ~/.zshrc에 추가
export ANTHROPIC_API_KEY="sk-ant-xxxxx"
export OPENAI_API_KEY="sk-xxxxx"
```

### Ollama 로컬 LLM 설정

```bash
# 1단계: Ollama 설치
# macOS: brew install ollama
# Linux: curl -fsSL https://ollama.com/install.sh | sh

# 2단계: 모델 다운로드
ollama pull qwen2.5-coder:7b      # 채팅 및 편집
ollama pull qwen2.5-coder:1.5b    # 빠른 자동완성
ollama pull nomic-embed-text       # @codebase용 임베딩

# 3단계: Ollama 서버 시작 (기본: http://localhost:11434)
ollama serve
```

`config.yaml`에 추가:

```yaml
models:
  - name: Qwen Coder 7B
    provider: ollama
    model: qwen2.5-coder:7b
    apiBase: http://localhost:11434
    roles: [chat, edit]

  - name: Qwen Coder 1.5B 고속
    provider: ollama
    model: qwen2.5-coder:1.5b
    apiBase: http://localhost:11434
    roles: [autocomplete]
    autocompleteOptions:
      debounceDelay: 300
      maxPromptTokens: 512

  - name: Nomic Embed
    provider: ollama
    model: nomic-embed-text
    apiBase: http://localhost:11434
    roles: [embed]
```

### Docker 팀 배포

```dockerfile
# Dockerfile.continue-ci
FROM node:20-slim

RUN npm install -g @continuedev/cli

COPY .continue/config.yaml /root/.continue/config.yaml
ENV ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}

# CI에서 Continue 체크 실행
CMD ["continue", "check", "--config", "/root/.continue/config.yaml"]
```

```yaml
# docker-compose.yml 팀 Ollama + Continue
version: '3.8'
services:
  ollama:
    image: ollama/ollama:latest
    volumes:
      - ollama-data:/root/.ollama
    ports:
      - "11434:11434"
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

volumes:
  ollama-data:
```

## VS Code, Ollama, OpenAI, Anthropic, JetBrains 통합

### VS Code: 다중 모델 워크플로우

Continue.dev의 VS Code 핵심 기능은 **서로 다른 작업에 서로 다른 모델을 사용**하는 것이다. 프로덕션급 설정 예시:

```yaml
# ~/.continue/config.yaml — 프로덕션 VS Code 설정
name: 프로덕션 VS Code
version: 1.0.0
schema: v1

models:
  # 주력: 복잡한 작업용 Claude
  - name: Claude Sonnet 4.6
    provider: anthropic
    model: claude-sonnet-4-6
    apiKey: ${{ secrets.ANTHROPIC_API_KEY }}
    roles: [chat, edit, agent]
    defaultCompletionOptions:
      temperature: 0.1
      maxTokens: 8192

  # 폴리백: 속도용 GPT-4o
  - name: GPT-4o
    provider: openai
    model: gpt-4o
    apiKey: ${{ secrets.OPENAI_API_KEY }}
    roles: [chat]

  # 자동완성: 제로 지연 로컬 모델
  - name: Qwen 1.5B 로컬
    provider: ollama
    model: qwen2.5-coder:1.5b
    apiBase: http://localhost:11434
    roles: [autocomplete]

  # 임베딩: 개인정보 보호용 로컬
  - name: Nomic Embed 로컬
    provider: ollama
    model: nomic-embed-text
    apiBase: http://localhost:11434
    roles: [embed]

context:
  - provider: code
  - provider: docs
  - provider: diff
  - provider: terminal
  - provider: codebase

rules:
  - name: TypeScript 표준
    pattern: "**/*.ts"
    rule: |
      엄격한 TypeScript 사용. type 대신 interface 우선.
      async/await 사용, 콜백 금지. 모든 오류를 명시적으로 처리.
```

### Ollama: 완전 오프라인 모드

```bash
# Ollama 실행 중인지 확인
curl http://localhost:11434/api/tags

# 예상 출력: 사용 가능한 모델 목록
# {"models":[{"name":"qwen2.5-coder:7b",...}]}
```

위 Ollama 설정으로 모든 코드 처리가 로컬에서 이루어진다. 네트워크 호출 없음, 데이터가 localhost를 벗어나지 않음. 금융 및 의료 등 규제 요건이 엄격한 팀이 이 설정을 사용한다.

### Anthropic Claude 통합

```yaml
models:
  - name: Claude Opus
    provider: anthropic
    model: claude-opus-4-6
    apiKey: ${{ secrets.ANTHROPIC_API_KEY }}
    roles: [chat, edit, agent]
    defaultCompletionOptions:
      temperature: 0.2
      maxTokens: 16384
```

Claude 모델은 MCP 도구 사용을 네이티브 지원하여 Continue의 Agent 모드가 외부 도구를 호출할 수 있게 한다.

### OpenAI 통합

```yaml
models:
  - name: GPT-4o
    provider: openai
    model: gpt-4o
    apiKey: ${{ secrets.OPENAI_API_KEY }}
    roles: [chat, edit]

  - name: GPT-4o-mini
    provider: openai
    model: gpt-4o-mini
    apiKey: ${{ secrets.OPENAI_API_KEY }}
    roles: [autocomplete]
    defaultCompletionOptions:
      maxTokens: 1024
```

### JetBrains: 전체 기능 설정

JetBrains의 Continue는 동일한 `config.yaml`을 지원한다. 위치:

```bash
# 전역 (모든 프로젝트)
# macOS: ~/.continue/config.yaml
# Windows: %USERPROFILE%\.continue\config.yaml

# 프로젝트별
# <프로젝트 루트>/.continue/config.yaml
```

JetBrains 단축키:
- `Cmd/Ctrl + J` — Continue 채팅 열기
- `Tab` — 자동완성 수락
- `Cmd/Ctrl + Shift + L` — 인라인 편집 전환

### MCP(Model Context Protocol) 통합

Continue.dev는 MCP 서버의 도구 사용을 지원한다. `config.yaml`에 추가:

```yaml
mcpServers:
  - name: filesystem
    command: npx
    args: ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"]

  - name: github
    command: npx
    args: ["-y", "@modelcontextprotocol/server-github"]
    env:
      GITHUB_PERSONAL_ACCESS_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  - name: postgres
    command: npx
    args: ["-y", "@modelcontextprotocol/server-postgres", "postgresql://localhost/mydb"]
```

## 벤치마크 / 실제 사용 사례

### 생산성 지표 (2026년 개발자 설문)

| 지표 | Continue.dev + Claude | Continue.dev + Ollama | GitHub Copilot | Cursor Pro |
|------|----------------------|----------------------|----------------|------------|
| 코드 수락률 | 68% | 52% | 72% | 75% |
| 평균 응답 시간 (채팅) | 2.1초 | 0.8초 (로컬) | 1.4초 | 1.2초 |
| 평균 응답 시간 (자동완성) | 0.5초 | 0.3초 | 0.4초 | 0.3초 |
| 월 비용 (고사용자) | $20-50 | $0 | $10-19 | $20 |
| 월 비용 (저사용자) | $2-5 | $0 | $10 | $0-20 |
| 생성/수락 코드 라인 | 2,400 / 1,632 | 1,800 / 936 | 3,100 / 2,232 | 3,500 / 2,625 |
| 설정 시간 | 15-30분 | 30-60분 | 5분 | 10분 |
| 오프라인 가능 | 부분 | 완전 | 불가 | 불가 |

### 사례: 규제 기업 (금융)

12인 개발팀을 보유한 유럽 핀테크 기업이 Copilot Business에서 낸 GPU 서버에서 실행되는 Continue.dev + Ollama로 전환. 3개월 후 결과:

- **비용**: 월 $0 (Copilot Business 대비 월 $228)
- **지연 시간**: A100에서 Qwen 2.5 Coder 7B로 평균 자동완성 0.4초
- **규정 준수**: 100% 에어갭, SOC 2 감사 통과
- **개발자 만족도**: 8.2/10 (Copilot은 모델 제한으로 6.5/10)

### 사례: 개인 풀스택 개발자

로컬과 클라우드 모델을 혼합하여 사용하는 개발자:

```yaml
# 비용-성능 최적화 설정
models:
  - name: Claude Haiku
    provider: anthropic
    model: claude-haiku-4-5
    apiKey: ${{ secrets.ANTHROPIC_API_KEY }}
    roles: [chat]  # $0.25/백만 토큰

  - name: Qwen 7B 로컬
    provider: ollama
    model: qwen2.5-coder:7b
    roles: [autocomplete, edit]  # 무
```

월간 API 비용: **$3-8**, 주 40시간 코딩. 구독료 없음.

## 고급 사용법 / 프로덕션 강화

### Agent 모드 자율 워크플로우

Continue.dev의 2026년 Agent 모드는 자율적으로 다단계 작업을 계획하고 실행한다:

```yaml
# 도구 정책이 있는 Agent 모드 활성화
models:
  - name: Claude Sonnet Agent
    provider: anthropic
    model: claude-sonnet-4-6
    apiKey: ${{ secrets.ANTHROPIC_API_KEY }}
    roles: [chat, edit, agent]
    capabilities:
      - tool_use
      - image_input
```

Agent 워크플로우: 작업 설명 → AI가 코드베이스 분석 → 계획 생성 → 파일 수정 실행 → 터미널 명령 실행 → 결과 검증. 도구 정책은 도구별로 "먼저 묻기", "자동", "제외"로 설정 가능.

### 코드 품질을 위한 사용자 정의 규칙

```yaml
# ~/.continue/rules/typescript.yaml
name: TypeScript 규칙
version: 1.0.0
schema: v1

rules:
  - pattern: "**/*.ts"
    rule: |
      1. 엄격한 TypeScript 사용 (noImplicitAny, strictNullChecks)
      2. 객체 형태는 `interface`를 `type`보다 우선 사용
      3. Promise 거부는 항상 try/catch로 처리
      4. 의존성 주입 사용, 전역 상태 회피
      5. 함수는 50줄 이하여야 함
```

### 더 깊은 이해를 위한 컨텍스트 제공자

Continue의 `@` 명령은 AI에 정확한 컨텍스트를 제공한다:

```
@codebase    — 전체 프로젝트의 의미론적 검색
@docs        — 외부 문서 사이트 참조
@terminal    — 마지막 명령 출력 포함
@file        — 특정 파일 참조
@web         — 최신 정보를 위한 웹 검색
@github      — 이슈와 PR 가져오기
```

채팅 예시:

```
> @codebase 이 프로젝트의 인증 미들웨어 작동 방식 설명
> @docs https://docs.nestjs.com/security/authentication
> 문서의 패턴을 사용하여 로그인 핸들러 리팩토링
```

### 보안: 시크릿 관리

```yaml
# API 키를 절대 하드코딩하지 마라. 환경 변수 대체 사용:
models:
  - name: Claude
    provider: anthropic
    model: claude-sonnet-4-6
    apiKey: ${{ secrets.ANTHROPIC_API_KEY }}  # 환경 변수에서

# CI/CD에서는 러너의 시크릿 저장소 사용:
# GitHub Actions: ${{ secrets.ANTHROPIC_API_KEY }}
# GitLab CI: $ANTHROPIC_API_KEY (CI/CD 변수)
```

### 사용량 모니터링

```bash
# 모델별 API 비용 추적
# 쉘 프로파일에 추가:
export CONTINUE_LOG_LEVEL=debug

# 로그가 기록되는 위치:
# macOS: ~/Library/Logs/Continue/
# Linux: ~/.config/Continue/logs/
# Windows: %APPDATA%\Continue\logs\
```

## 대안과 비교

| 기능 | Continue.dev | GitHub Copilot | Cursor | Tabby |
|------|:----------:|:------------:|:------:|:-----:|
| **라이선스** | Apache-2.0 | 독점 | 독점 | Apache-2.0 |
| **개인 가격** | 무 | $10-19/월 | $20/월 | 무 (자체 호스팅) |
| **오픈소스** | 예 | 아니오 | 아니오 | 예 |
| **로컬 LLM 지원** | 네이티브 Ollama, LM Studio | 없음 | 제한적 | 내장 |
| **IDE 지원** | VS Code, JetBrains, Neovim | VS Code, JetBrains, Vim | VS Code 전용 | VS Code, JetBrains |
| **모델 유연성** | 모든 LLM | 고정 (OpenAI) | 제한적 | 제한적 |
| **Agent 모드** | 예 (2026) | 제한적 | 예 (Composer) | 아니오 |
| **MCP 지원** | 예 | 부분 | 예 | 아니오 |
| **탭 완성** | 예 | 예 | 예 | 예 (주력) |
| **팀/엔터프라이즈** | $10/인/월 (Hub) | $19-39/인/월 | $40/인/월 | 자체 호스팅 |
| **오프라인 가능** | 완전 | 불가 | 불가 | 완전 |
| **CI/PR 통합** | 예 (Checks) | 없음 | 없음 | 없음 |
| **설정 복잡도** | 중간 | 낮음 | 낮음 | 중간 |
| **코드 프라이버시** | 완전 통제 | 마이크로소프트 서버 | 미국 클라우드 | 완전 통제 |
| **GitHub Stars** | 33,277 | 해당 없음 | 해당 없음 | 25,000+ |

**표 해석:**

- **Continue.dev**를 선택하려는 경우: 최대한의 유연성, 로컬 LLM 지원, 완전한 코드 프라이버시가 필요할 때. 대가는 수동 설정이다.
- **GitHub Copilot**을 선택하려는 경우: 마이크로소프트 에코시스템 내에서 무설정 클라우드 전용 운영을 원할 때.
- **Cursor**를 선택하려는 경우: 가장 세련된 AI 네이티브 IDE 경험을 원하고 월 $20를 기꺼이 지불할 때.
- **Tabby**를 선택하려는 경우: 팀 배포를 위한 전용 자동완성 서버가 필요하고, 내장 모델 서빙과 저장소 인덱싱이 필요할 때.

## 한계 / 솔직한 평가

Continue.dev가 모든 개발자에게 적합한 것은 아니다. 솔직한 한계:

**1. 자동완성 불안정성.** 탭 완성 기능은 여러 버전에서 알려진 신뢰성 문제가 있다. 특정 모델(Codestral, Qwen 2.5 Coder)에서는 잘 작동하지만 다른 모델에서는 오류가 발생하거나 조용히 실패할 수 있다. 자동완성이 주요 요구사항이라면 Copilot이나 Tabby가 더 신뢰할 수 있다.

**2. 수동 설정 부담.** 모델을 변경할 때마다 `config.yaml`을 편집해야 한다. 설치하면 바로 작동하는 Copilot과 비교해 본다. Continue는 뜯어고치기를 좋아하는 사용자에게 보상을 주고, 제로 설정을 원하는 사용자를 벌한다.

**3. 내장 모델 없음.** 자체 API 키를 가져와서 사용량에 따라 비용을 지불해야 한다. Cursor 물 계획의 2,000회 완성과 같은 번들 물 컴퓨팅 크레딧이 없다. 무거운 클라우드 LLM 사용자의 경우 비용이 구독형 대안을 초과할 수 있다.

**4. 제한된 팀 기능.** Continue Hub($10/인/월)는 공유 설정을 추가하지만, Copilot Business나 Tabby Enterprise가 제공하는 엔터프라이즈 관리 제어, 사용량 분석, SSO가 부족하다.

**5. UI 세련도 격차.** Continue의 인터페이스는 기능적이지만 Cursor만큼 세련되지 않다. JetBrains 플러그인은 특히 가끔 렌더링 문제가 있고 VS Code 버전보다 업데이트 속도가 느리다.

**6. 고급 기능 학습 곡선.** 컨텍스트 제공자, 사용자 정의 규칙, MCP 서버, Agent 모드는 모두 문서를 읽고 실험이 필요하다. 보상은 크지만 시간 투자는 확실하다.

## 자주 묻는 질문

### Continue.dev는 완전히 오프라인으로 작동하나요?

예, Ollama나 LM Studio로 로컬 모델을 실행하도록 구성한 경우. 모든 코드 처리가 네트워크 호출 없이 로컬에서 이루어진다. 유일한 제한은 웹 검색(`@web`)과 클라우드 기반 컨텍스트 제공자가 당연히 연결을 필요로 한다는 것이다. 완전한 에어갭 환경에서는 Continue.dev가 작동하는 소수의 AI 코딩 어시스턴트 중 하나이다.

### Continue.dev는 일일 코딩에서 GitHub Copilot과 어떻게 비교되나요?

Continue.dev는 채팅 기능에서 Copilot과 대등하고 모델 유연성에서 능가한다. Copilot은 자동완성 신뢰성과 설정 편의성에서 승리한다. 전형적인 워크플로우: Continue.dev + Claude로 복잡한 리팩토링을 하고 Ollama로 로컬 자동완성을 처리한다. 편의성보다 통제를 중시한다면 Continue.dev가 더 나은 선택이다.

### 로컬 LLM 운영에 어떤 하드웨어가 필요한가요?

자동완성용 1.5B 매개변수 모델(Qwen 2.5 Coder): RAM 8GB, GPU 불필요. 채팅용 7B 모델: RAM 16GB 또는 VRAM 8GB GPU(RTX 3060, RTX 4060). 더 큰 모델의 최적 성능: RAM 32GB + VRAM 12GB(RTX 3060 12GB, RTX 4070). CPU 전용 추론은 가능하지만 1~3초 지연이 추가된다.

### Continue.dev는 상업적 사용이 물인가요?

예. Apache-2.0 라이선스는 제한 없이 상업적 사용, 수정, 배포를 허용한다. IDE 확장 프로그램은 완전 물. Continue Hub(팀 협업 기능)는 $10/인/월부터 시작한다. Claude나 GPT-4o와 같은 클라우드 LLM을 사용할 때만 API 사용량에 따라 비용이 발생한다.

### Copilot에서 Continue.dev로 어떻게 마이그레이션하나요?

1. Continue 확장 프로그램 설치(Copilot은 아직 제거하지 않는다)
2. `~/.continue/config.yaml`에 선호하는 모델 구성
3. 1~2주간 양쪽을 병렬로 실행하며 비교
4. VS Code 설정에서 Copilot 자동완성을 비활성화하고 Continue 사용
5. 적응하면 Copilot 구독 취소

마이그레이션은 일반적으로 config.yaml을 조정하는 데 3~5일의 활발한 사용이 필요하다. 대부분의 개발자는 초기 설정 기간 후 더 높은 만족도를 보고한다.

### config.yaml과 config.json의 차이는 무엇인가요?

Continue.dev는 2025년에 JSON에서 YAML로 권장 형식을 변경했다. `config.yaml`은 새 규칙 시스템, Hub 가져오기, 더 나은 가독성을 포함한 전체 기능 세트를 지원한다. `config.json`은 이전 버전과의 호환성을 위해 여전히 작동하지만 최신 기능이 부족하다. 새 설정은 YAML만 사용해야 한다.

## 결론

Continue.dev는 33,277+ GitHub Stars, 모든 LLM 유연성, 완전한 오프라인 기능, CI 통합 체크 시스템을 결합한 유일한 오픈소스 AI 코딩 어시스턴트로 독보적이다. 벤더 종속을 거부하고, 에어갭 운영이 필요하거나, 어떤 AI 모델이 코드를 처리하는지 제어하고 싶은 개발자에게 Continue.dev는 2026년의 프로덕션급 선택이다.

**실행 항목:**
1. VS Code 마켓플레이스에서 Continue.dev 설치 (2분)
2. `~/.continue/config.yaml`에 첫 모델 구성 (10분)
3. Ollama와 Qwen 2.5 Coder로 물 로컬 자동완성 설정
4. 설정 팁을 위해 GitHub Discussions의 Continue 커뮤니티 가입

**커뮤니티:** [AI Coding Tools Telegram 그룹](https://t.me/aicodingtools)에 가입하여 Continue.dev 설정을 논의하고, 모델 설정을 공유하고, 오픈소스 AI 어시스턴트를 사용하는 다른 개발자로부터 도움을 받아라.



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- [Continue.dev 공식 웹사이트](https://www.continue.dev/)
- [Continue.dev 문서](https://docs.continue.dev/)
- [Continue.dev GitHub 저장소](https://github.com/continuedev/continue)
- [Continue Hub 가격](https://www.continue.dev/pricing)
- [Ollama 공식 웹사이트](https://ollama.com/)
- [Model Context Protocol 문서](https://modelcontextprotocol.io/)
- [VS Code Continue 확장](https://marketplace.visualstudio.com/items?itemName=Continue.continue)
- [JetBrains 마켓플레이스 - Continue](https://plugins.jetbrains.com/plugin/22707-continue)
- [Continue.dev 블로그](https://blog.continue.dev/)
