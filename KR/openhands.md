---
title: 'OpenHands: 74K+ Stars — 코드를 작성하고 실행하는 AI 소프트웨어 엔지니어 (2026 설치 가이드)'
description: 'OpenHands는 소프트웨어 엔지니어링 에이전트로 작동하는 AI 기반 개발 플랫폼입니다. VS Code, Docker, GitHub, GitLab, Claude, OpenAI와 호환됩니다. Docker 설치, 모델 구성, 헤드리스 CI/CD 모드, 프로덕션 하드닝을 다룹니다.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/OpenHands/OpenHands'
stars: 74200
maintainer: 'OpenHands'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['OpenHands', 'AI 코딩 에이전트', 'Docker', 'SWE-bench', 'Claude', 'OpenAI', '셀프 호스팅', '자동화']
aliases:
- /kr/posts/openhands/
- /kr/resources/llm-frameworks/openhands-architecture-ai-programmer-agent/
---

{{</* resource-info */>}}

## 소개

대부분의 AI 코딩 도구는 제안 수준에서 멈춥니다. 제안을 받아 붙여넣고 컴파일되기를 기도합니다. OpenHands는 완전히 다른 접근 방식을 취합니다: 코드 저장소를 읽고, 파일을 편집하고, 테스트를 실행하고, 작업이 통과할 때까지 반복하는 완전한 소프트웨어 엔지니어링 에이전트입니다. 74,000개 이상의 GitHub Star와 SWE-bench Verified 72% 점수를 기록하며 프로덕션 환경에서 가장 많이 배포된 오픈소스 코딩 에이전트입니다.

이 가이드에서는 OpenHands 로컬 설치, 선호하는 LLM 제공업체 연결, GitHub 통합, CI/CD 파이프라인용 헤드리스 모드 실행을 다룹니다. 일상 작업용 로컬 AI 엔지니어가 필요하든 배치 이슈 해결용 자율 에이전트가 필요하든, 이 튜토리얼은 실제 명령어와 구성으로 모든 단계를 설명합니다.

## OpenHands란 무엇인가?

OpenHands(이전 명칭 OpenDevin)는 Docker 컨테이너 난에 실행되는 오픈소스 AI 소프트웨어 엔지니어링 에이전트입니다. 컨트롤러-샌드박스 아키텍처를 사용합니다: Python 기반 컨트롤러가 에이전트 루프(관찰-사고-행동)를 관리하고, 격리된 샌드박스 컨테이너가 코드 실행, 파일 작업, 테스트 실행을 처리합니다.

핵심 기능:
- **자율 작업 실행**: GitHub 이슈 또는 자연어 작업을 주면 종단간 해결
- **샌드박스 코드 실행**: 모든 코드는 Docker 컨테이너 난에서 실행되어 호스트와 격리
- **멀티 에이전트 위임**: 복잡한 작업을 전문화된 하위 에이전트로 분할
- **BYO 모델 지원**: Claude, GPT, Gemini, Ollama 또는 vLLM을 통한 로컬 모델, LiteLLM을 통한 100+ 제공업체와 호환
- **헤드리스 모드**: CI/CD 및 배치 처리를 위한 프로그래밍 방식 API 액세스
- **Web UI + CLI**: 브라우저 기반 인터페이스와 터미널 중심 워크플로우 모두 제공

## OpenHands의 작동 원리

아키텍처는 두 개의 주요 구성 요소로 구성됩니다:

**컨트롤러 노드(Controller Node)**: 에이전트 루프를 관리하고, LiteLLM을 통해 LLM 추상화를 처리하고, 샌드박스 수명 주기를 조정하는 Python 서버. 작업을 받아 단계로 분해하고, 결정을 위해 LLM을 호출하고, 반복 간 상태를 추적합니다.

**샌드박스 컨테이너(Sandbox Container)**: 작업마다 생성되는 Docker 컨테이너로, 모든 코드 실행이 이 안에서 이루어집니다. 에이전트는 격리된 환경에서 파일을 읽고, 셸 명령을 실행하고, 테스트를 실행하고, 패치를 작성합니다. 작업이 완료되면 샌드박스가 소멸됩니다.

![OpenHands 아키텍처](https://raw.githubusercontent.com/All-Hands-AI/OpenHands/main/docs/static/img/system_architecture_overview.png)

에이전트 루프는 다음 패턴을 따릅니다:

```
1. OBSERVE: 작업 설명, 저장소 상태, 이전 작업 결과 읽기
2. THINK: LLM이 계획 생성(어떤 파일을 편집할지, 어떤 명령을 실행할지)
3. ACT: 계획된 작업 실행(read_file, write_file, run_cmd 등)
4. OBSERVE: 결과 캡처(출력, 오류, 테스트 결과)
5. REPEAT: 작업이 완료되거나 최대 반복 횟수에 도달할 때까지 반복
```

각 작업은 일반적으로 30-50회의 LLM 호출을 소모합니다. v1.5에 추가된 메모리 응축기(memory condenser)는 이전 컨텍스트를 요약하여 컨텍스트 윈도우를 집중시키고, 긴 작업에서 지연 시간과 토큰 소비를 줄입니다.

## 설치 및 설정

### 사전 요구사항

OpenHands를 설치하기 전에 다음이 준비되어야 합니다:

- **Docker Desktop** 설치 및 실행 완료 (Docker 소켓 액세스 필요)
- **4GB+ RAM** (동시 세션에는 8GB 권장)
- **Python 3.12+** (uv를 통한 CLI 설치 시 필요)
- **LLM API 키** (Anthropic, OpenAI, Google 또는 로컬 모델 엔드포인트)

### 방법 1: uv로 CLI 설치 (권장)

OpenHands를 가장 빠르게 실행하는 방법은 uv 기반 CLI 설치기를 통하는 것입니다:

```bash
# uv 설치 (아직 없는 경우)
curl -LsSf https://astral.sh/uv/install.sh | sh

# OpenHands 설치
uv tool install openhands --python 3.12

# GUI 서버 실행
openhands serve
```

서버가 `http://localhost:3000`에서 시작됩니다. 브라우저를 열고 LLM 제공업체를 선택하고, API 키를 입력하면 작업 할당 준비가 완료됩니다.

![OpenHands Web UI](https://raw.githubusercontent.com/All-Hands-AI/OpenHands/main/docs/static/img/screenshot.png)

나중에 업그레이드하려면:

```bash
uv tool upgrade openhands --python 3.12
```

### 방법 2: Docker 직접 실행

Python 도구를 설치하지 않고 Docker를 선호하는 경우:

```bash
# 최신 이미지 가져오기
docker pull ghcr.io/openhands/openhands:latest

# Docker 소켓 마운트로 실행 (샌드박스 관리에 필요)
docker run -it --rm \
  -p 3000:3000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e SANDBOX_RUNTIME_CONTAINER_IMAGE=ghcr.io/openhands/openhands:latest \
  ghcr.io/openhands/openhands:latest
```

`--mount-cwd` 플래그는 현재 작업 디렉토리를 샌드박스에 마운트합니다:

```bash
openhands serve --mount-cwd
```

GPU 가속 로컬 모델의 경우:

```bash
openhands serve --gpu
```

### 방법 3: pip 설치

```bash
pip install openhands-ai

# Web UI 시작
openhands serve
```

### Windows 설치 참고사항

Windows에서는 모든 명령을 WSL2(Ubuntu) 난에서 실행해야 합니다:

```powershell
# PowerShell 관리자 권한에서
wsl --install -d Ubuntu
wsl -d Ubuntu
```

그리고 WSL 난에서:

```bash
# 먼저 Docker Desktop for Windows 설치한 후:
uv tool install openhands --python 3.12
openhands serve
```

## 구성 및 첫 작업

### LLM 제공업체 설정

OpenHands를 실행한 후 설정 패널(기어 아이콘)에서 모델을 구성합니다:

1. **제공업체 선택**: Anthropic(Claude), OpenAI(GPT), Google(Gemini) 또는 로컬
2. **모델 선택**: 최상의 결과를 위해 `anthropic/claude-sonnet-4-20250514` 권장
3. **API 키 입력**: 제공업체의 API 키 붙여넣기
4. **변경사항 저장**

고급 구성을 위해 고급 설정을 활성화하고 LiteLLM 접두사 형식으로 커스텀 모델을 설정할 수 있습니다:

```
anthropic/claude-sonnet-4-5-20250929
openai/gpt-5-2025-08-07
gemini/gemini-3-pro-preview
deepseek/deepseek-chat
```

### 로컬 모델 사용 (Ollama)

오프라인 배포가 필요한 팀을 위한 방법:

```bash
# Ollama로 강력한 코딩 모델 시작
ollama run qwen3-coder:32b

# OpenHands 설정에서 구성:
# 커스텀 모델: openai/qwen3-coder:32b
# 기본 URL: http://host.docker.internal:11434/v1
# API 키: ollama (아무 값이나 가능)
```

### 첫 작업 실행

`localhost:3000`에서 UI를 열고:

1. 채팅 상자에 작업 입력: "app.py의 main 함수에 docstring 추가"
2. 에이전트가 샌드박스를 생성하고, 파일을 읽고, docstring을 작성하고, 변경사항을 확인합니다
3. 수락하기 전에 diff를 검토합니다

GitHub 이슈 해결의 경우:

```
이슈 #42에 설명된 인증 버그를 수정하세요.
저장소를 클론하고, 오류를 재현하고, 수정을 구현하고, 테스트 스위트를 실행하세요.
```

## VS Code, GitHub, Docker, CI/CD와의 통합

### ACP를 통한 VS Code 통합

OpenHands v1.5+에는 IDE 통합을 위한 Agent Control Plane이 포함되어 있습니다:

```bash
# OpenHands VS Code 확장 설치
# VS Code 확장 마켓플레이스에서 "OpenHands" 검색

# 로컬 OpenHands 서버에 연결하도록 확장 구성
# 설정 > OpenHands > 서버 URL: http://localhost:3000
```

ACP 프로토콜을 통해 VS Code는 작업을 OpenHands에 직접 전송하고 diff 패치 형태로 구조화된 편집을 다시 받을 수 있습니다.

### GitHub 통합

자동화된 이슈 해결을 위해 OpenHands를 GitHub 저장소에 연결합니다:

```bash
# 세분화된 GitHub PAT(개인 액세스 토큰) 설정
export GITHUB_TOKEN=ghp_your_token_here

# GitHub 자격 증명으로 OpenHands 실행
docker run -it --rm \
  -p 3000:3000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GITHUB_TOKEN=$GITHUB_TOKEN \
  ghcr.io/openhands/openhands:latest
```

UI에서 GitHub 이슈 URL을 붙여넣으면 OpenHands가 다음을 수행합니다:
1. 저장소 클론
2. 이슈 설명 읽기
3. 버그 재현
4. 수정 구현
5. 테스트 실행으로 검증
6. 검토용 diff 생성

### GitLab 통합

GitLab 지원(v1.5 추가)은 유사한 방식으로 작동합니다:

```bash
export GITLAB_TOKEN=glpat-your-token
docker run -it --rm \
  -p 3000:3000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GITLAB_TOKEN=$GITLAB_TOKEN \
  ghcr.io/openhands/openhands:latest
```

### 프로덕션용 Docker Compose

지속적인 배포를 위해 Docker Compose를 사용합니다:

```yaml
version: "3.8"
services:
  openhands:
    image: ghcr.io/openhands/openhands:latest
    ports:
      - "3000:3000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./workspace:/workspace
    environment:
      - SANDBOX_RUNTIME_CONTAINER_IMAGE=ghcr.io/openhands/openhands:latest
      - LLM_API_KEY=${LLM_API_KEY}
      - LLM_MODEL=anthropic/claude-sonnet-4-20250514
      - SANDBOX_NETWORK_DISABLED=true
      - LOG_LEVEL=info
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
```

배포:

```bash
docker-compose up -d
```

### CI/CD 파이프라인 헤드리스 모드

헤드리스 모드는 대화형 UI 없이 OpenHands를 실행하여 자동화에 적합합니다:

```bash
# 헤드리스 모드로 작업 실행
openhands --headless -t "인증 모듈에 대한 단위 테스트 작성"

# 파일에서 작업 로드
openhands --headless -f task.txt

# 파이프라인 파싱용 JSON 출력
openhands --headless --json -t "routes.py의 API 엔드포인트 수정" > output.jsonl
```

GitHub Actions 워크플로우 예시:

```yaml
name: OpenHands 자동 수정
on:
  issues:
    types: [labeled]
jobs:
  fix:
    if: github.event.label.name == 'auto-fix'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: OpenHands 실행
        run: |
          docker run --rm \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v $(pwd):/workspace \
            -e LLM_API_KEY=${{ secrets.ANTHROPIC_API_KEY }} \
            ghcr.io/openhands/openhands:latest \
            openhands --headless --json \
            -f .openhands/task.txt > results.jsonl
```

### MCP 서버 통합

OpenHands는 확장 기능을 위해 Model Context Protocol(MCP) 서버를 지원합니다:

```json
{
  "mcpServers": {
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/workspace"]
    }
  }
}
```

## 벤치마크 / 실제 사용 사례

### SWE-bench Verified 성능

SWE-bench Verified는 500개의 실제 GitHub 이슈에서 에이전트를 테스트합니다. 점수가 높을수록 에이전트가 더 많은 프로덕션 버그를 자율적으로 해결할 수 있음을 의미합니다.

| 에이전트 + 모델 | SWE-bench Verified | 참고 |
|---|---|---|
| OpenHands + Claude Opus 4.6 | ~72% | 오픈소스 프레임워크 최고 성능 |
| OpenHands + Claude Sonnet 4.6 | ~67% | 권장되는 비용/품질 균형 |
| OpenHands + GPT-5 | ~55% | 이미 OpenAI를 사용하는 팀에 적합 |
| OpenHands + Qwen3-Coder-32B (로컬) | ~32% | 일상 작업에 수용 가능 |
| OpenHands + Devstral 24B | ~47% | 최고의 오픈웨이트 모델 |
| Claude Code + Claude Opus 4.6 | ~78% | 최고의 첫 시도 성공률 |
| Aider + Claude Opus 4.6 | ~62% | 강력한 CLI 대안 |

### 성공적 수정당 비용

일반적인 SWE-bench 작업이 ~55K 토큰을 소모할 때:

| 모델 | 시도당 비용 | 성공률 | 성공당 비용 |
|---|---|---|---|
| Claude Opus 4.7 | ~$1.50 | 87.6% | ~$1.71 |
| GPT-5.3-Codex | ~$0.90 | 85.0% | ~$1.06 |
| Claude Sonnet 4.6 | ~$0.40 | 67% | ~$0.60 |
| Qwen3.6 Plus (호스팅) | ~$0.20 | 78.8% | ~$0.25 |

### 실제 배포 지표

커뮤니티가 보고한 프로덕션 배포 데이터 기준:

- **이슈 해결률**: 30-40%의 라벨링된 버그가 첫 시도에 자율적으로 해결
- **코드 리뷰 지원**: 200라인 이하 PR의 리뷰 시간 60% 감소
- **테스트 생성**: "X에 대한 테스트 작성" 프롬프트로 새 모듈 80%+ 커버리지 달성
- **문서 생성**: docstring 및 README 생성 작업 90%+ 정확도

![OpenHands Star History](https://api.star-history.com/svg?repos=OpenHands/OpenHands&type=Date)

### OpenHands를 사용하는 기업

AMD, Apple, Google, Netflix가 모두 자동화 유지보수 작업을 위해 OpenHands를 난부적으로 배포했습니다. 가장 일반적인 사용 사례는 여러 저장소의 종속성 업그레이드, 취약점 수정 스윕, PR 리뷰 자동화입니다.

## 고급 사용법 / 프로덕션 하드닝

### 보안 체크리스트

자율 코드 실행 에이전트를 실행하려면 신중한 보안 설정이 필요합니다:

**1. 샌드박스 네트워크 격리**

```yaml
environment:
  - SANDBOX_NETWORK_DISABLED=true
```

이것은 샌드박스 컨테이너의 아웃바운드 요청을 차단합니다. 패키지 설치가 필요한 작업에서만 선택적으로 활성화하세요.

**2. Docker 소켓 보안**

Docker 소켓 마운트는 효과적으로 root 액세스와 동일합니다. 다음으로 완화합니다:

```bash
docker run --security-opt no-new-privileges \
  --cap-drop ALL \
  --cap-add SYS_ADMIN \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/openhands/openhands:latest
```

**3. 세분화된 GitHub PAT**

조직 범위 토큰은 사용하지 마세요. PAT를 특정 저장소로 범위를 좁히세요:

```bash
# GitHub > 설정 > 개발자 설정에서 세분화된 PAT 생성
# 다음만 선택: 콘텐츠(읽기/쓰기), 이슈(읽기), 풀 리퀘스트(쓰기)
```

**4. 비밀 관리**

비밀을 환경 변수 대신 읽기 전용 볼륨으로 마운트합니다:

```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
  - /opt/secrets:/secrets:ro
environment:
  - LLM_API_KEY_FILE=/secrets/anthropic_key
```

### 멀티 에이전트 위임

대규모 기능을 위해 멀티 에이전트 모드를 활성화합니다:

```bash
# config.toml 또는 환경 변수를 통해
[agent]
enable_multi_agent = true
max_subagents = 3
```

상위 에이전트가 "인증이 포함된 REST API 구축"을 다음으로 분해합니다:
- 하위 에이전트 1: API 엔드포인트 구현
- 하위 에이전트 2: 인증 미들웨어 작성
- 하위 에이전트 3: 데이터베이스 모델 생성

### 메모리 응축기 튜닝

장기 실행 작업의 경우 메모리 응축기를 조정합니다:

```toml
[llm]
enable_condenser = true
condenser_max_history = 240  # 240개 이벤트 후 요약 (기본값: 240)
```

### 모니터링 및 로깅

가시성을 위해 구조화된 JSON 로깅을 활성화합니다:

```bash
openhands --headless --json -t "작업" 2>&1 | tee openhands.log
```

지표를 위해 로그를 파싱합니다:

```bash
# LLM 호출 횟수 계산
jq 'select(.type == "llm")' openhands.log | wc -l

# 오류 찾기
jq 'select(.type == "error")' openhands.log

# 작업 소요 시간 계산
jq 'select(.type == "finish") | .timestamp' openhands.log
```

### Kubernetes 확장

팀 배포를 위해 커뮤니티가 관리하는 Helm 차트를 사용합니다:

```bash
# OpenHands Helm 리포지토리 추가
helm repo add openhands https://charts.openhands.dev
helm repo update

# 값을 설정하여 설치
helm install openhands openhands/openhands \
  --set llm.apiKey=$LLM_API_KEY \
  --set llm.model=anthropic/claude-sonnet-4-20250514 \
  --set sandbox.networkDisabled=true \
  --set replicas=2
```

## 대안과의 비교

| 기능 | OpenHands | Claude Code | Aider | Codex CLI |
|---|---|---|---|---|
| **라이선스** | MIT (오픈소스) | 독점 (폐쇄) | Apache-2.0 (오픈소스) | 독점 (폐쇄) |
| **GitHub Stars** | 74,200 | 해당 없음 | 39,000 | 해당 없음 |
| **인터페이스** | Web UI + CLI | CLI 전용 | CLI 전용 | CLI 전용 |
| **샌드박싱** | Docker 컨테이너 | 호스트 파일시스템 | 호스트 파일시스템 | 호스트 파일시스템 |
| **모델 지원** | LiteLLM을 통한 100+ | Claude 전용 | API를 통한 100+ | OpenAI 전용 |
| **SWE-bench Verified** | ~72% (Claude) | ~78% (Claude) | ~62% (Claude) | ~55% (GPT) |
| **첫 시도 성공률** | ~65% | ~78% | ~71% | ~60% |
| **멀티 에이전트** | 예 (네이티브) | 예 (하위 에이전트) | 아니오 | 아니오 |
| **셀프 호스팅** | 예 (기본값) | 아니오 | 예 | 아니오 |
| **설치 시간** | 10-15분 | 2분 | 5-10분 | 2분 |
| **비용** | 물질 + API | $17-200/월 | 물질 + API | $20/월 + API |
| **CI/CD 통합** | 헤드리스 + JSON | 제한적 | 스크립트 가능 | 제한적 |
| **IDE 통합** | VS Code (ACP) | 없음 | 없음 | VS Code (공식) |

### 어떤 도구를 선택해야 할까

- **OpenHands**: 샌드박스 실행과 멀티 에이전트 지원이 있는 셀프 호스팅 자율 에이전트가 필요할 때. 인프라와 모델 선택에 대한 완전한 통제를 원할 때.
- **Claude Code**: 최고의 첫 시도 성공률을 원하고, 이미 Claude를 사용하며, 셀프 호스팅이 필요 없을 때. Docker 복잡성 없이 간단한 CLI를 선호할 때.
- **Aider**: 터미널 중심 작업을 하고, git 네이티브 작업과 자동 커밋이 필요하고, 컨테이너 오버헤드 없는 가벼운 도구를 원할 때.
- **Codex CLI**: OpenAI 에코시스템에 깊이 통합되어 있고, 공식 VS Code 지원이 필요하고, 관리형 서비스를 선호할 때.

## 한계 / 정직한 평가

OpenHands는 모든 상황에 적합한 도구가 아닙니다. 다음은 적합하지 않은 경우입니다:

**1. 시각적 피드백이 필요한 프론트엔드/UI 작업**: 에이전트는 렌더링된 출력을 "볼" 수 없습니다. "이 버튼을 가욱데 정렬" 또는 "CSS 그라데이션 수정"과 같은 작업은 에이전트가 시각적 검증이 부족하여 여러 번의 반복이 필요합니다.

**2. 신속한 프로토타이핑**: Docker 샌드백 시작은 작업마다 10-30초의 지연을 추가합니다. 빠른 일회성 편집의 경우 Aider나 Cursor가 더 빠릅니다.

**3. Docker를 실행할 수 없는 소형 기기**: Docker Desktop을 실행할 수 없는 경우(기업 잠금 노트북, ARM Chromebook), OpenHands는 작동하지 않습니다. Docker 소켓 마운트는 필수 요구사항입니다.

**4. 모호한 요구사항**: "코드베이스 개선" 또는 "더 나은 아키텍처로 리팩토링"과 같은 모호한 작업은 에이전트를 루프에 빠뜨립니다. 구체적이고 테스트 가능한 지침이 필요합니다.

**5. 복잡한 작업의 토큰 비용**: 각 작업은 30-50회의 LLM 호출을 소모합니다. Claude Sonnet 기준 호출당 ~$0.01로 계산하면 작업당 $0.30-0.50입니다. 고볼륨 배치 처리에서 비용이 빠르게 누적됩니다.

**6. 학습 곡선**: 멀티 에이전트 시스템, 이벤트 스트림, 구성 옵션은 강력하지만 Devin의 2분 가입 흐름에 비해 복잡합니다. 생산적인 사용 전에 1-2시간의 설정과 실험이 필요합니다.

## 자주 묻는 질문

### OpenHands를 실행하는 데 어떤 하드웨어가 필요한가요?

최소 사양: 현대 CPU, 4GB RAM, Docker Desktop. 로컬 모델의 경우 적어도 24GB VRAM의 GPU(RTX 4090 이상)가 필요합니다. 클라우드 API 모델은 GPU가 전혀 필요 없습니다.

### OpenHands를 완전히 오프라인으로 실행할 수 있나요?

Ollama, vLLM, LM Studio를 통한 로컬 모델로 가능합니다. 기본 URL을 로컬 엔드포인트(예: `http://localhost:11434/v1`)로 설정하고 API 키는 아무 값이나 사용하세요. 복잡한 작업에서는 성능이 프런티어 API보다 20-30% 낮지만, 일상적인 버그 수정과 리팩토링은 가능합니다.

### OpenHands와 Devin을 어떻게 비교하나요?

Devin($20-500/월)은 설정이 더 쉽지만(2분 가입), Cognition의 모델과 인프라에 종속됩니다. OpenHands는 10-15분의 설정이 필요하지만, 완전한 모델 선택과 셀프 호스팅, 벤더 종속 없음을 제공합니다. SWE-bench Verified 점수: OpenHands ~72% 대 Devin ~50%.

### OpenHands에서 내 코드가 안전한가요?

코드는 작업 완료 후 소멸되는 Docker 샌드박스 컨테이너에서 실행됩니다. `SANDBOX_NETWORK_DISABLED=true` 설정 시 샌드박스는 네트워크 액세스가 없습니다. 그러나 Docker 소켓 마운트는 컨트롤러에 상당한 호스트 액세스를 제공하므로, 프로덕션 노트북이 아닌 전용 머신이나 VM에서 OpenHands를 실행하세요.

### 기존 CI/CD 파이프라인과 OpenHands를 통합할 수 있나요?

헤드리스 모드를 통해 가능합니다. `--headless --json` 플래그는 구조화된 JSONL 출력을 생성하여 모든 CI 시스템이 파싱할 수 있습니다. 일반적인 GitHub Actions 워크플로우는 저장소를 클론하고, 라벨링된 이슈에서 OpenHands를 실행하고, 생성된 diff에서 PR을 생성합니다.

### 어떤 모델이 OpenHands와 가장 잘 작동하나요?

Claude Sonnet 4.6은 대부분의 작업에서 비용과 품질의 최적 균형을 제공합니다. Claude Opus 4.6은 최고의 정확도를 제공하지만 토큰 비용이 3-4배 높습니다. GPT-5는 이미 OpenAI를 사용하는 팀에 잘 작동합니다. 로컬 배포의 경우 Qwen3-Coder-32B 또는 Devstral 24B가 최고의 오픈웨이트 옵션입니다.

### OpenHands가 루프에 갇혔을 때 어떻게 디버그하나요?

UI의 이벤트 로그에서 반복적으로 실패한 작업을 확인하세요. 일반적인 수정 방법: (1) 더 구체적인 지침 제공, (2) 더 강력한 모델로 전환, (3) 작업을 더 작은 하위 작업으로 분할, (4) 설정에서 `max_iterations` 제한 증가.

## 결론

OpenHands는 2026년에 사용 가능한 가장 강력한 오픈소스 AI 소프트웨어 엔지니어링 에이전트입니다. 74,000개 이상의 GitHub Star, 72%의 SWE-bench 점수, Docker 샌드박스 아키텍처는 벤더 종속 없이 자율 코딩 기능이 필요한 팀에게 적합한 선택입니다.

설치는 10-15분이 소요됩니다: uv 또는 Docker를 통해 설치하고, LLM 제공업체를 구성하고, 작업을 시작하세요. 프로덕션 사용을 위해 샌드박스 네트워크 격리를 활성화하고, 세분화된 GitHub PAT을 사용하고, CI/CD 통합을 위해 헤드리스 모드를 배포하세요.

**다음 단계:**
1. 저장소 클론: `git clone https://github.com/OpenHands/OpenHands.git`
2. 설치: `uv tool install openhands --python 3.12`
3. 실행: `openhands serve`로 시작하고 `localhost:3000`에서 연결
4. 지원과 기능 업데이트를 위해 Slack 커뮤니티 참여



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 참고 자료 및 추가 읽기

- [OpenHands GitHub 저장소](https://github.com/OpenHands/OpenHands) — 소스 코드 및 릴리스
- [공식 문서](https://docs.openhands.dev/) — 전체 설치 및 API 문서
- [OpenHands LLM 구성 가이드](https://docs.openhands.dev/openhands/usage/llms/llms) — 모델 권장 사항 및 제공업체 설정
- [헤드리스 모드 문서](https://docs.openhands.dev/openhands/usage/cli/headless) — CI/CD 및 스크립트 참조
- [SWE-bench 순위표](https://www.swebench.com/) — 공식 벤치마크 결과
- [LiteLLM 제공업체 문서](https://docs.litellm.ai/docs/providers) — 지원되는 모델 제공업체
- [OpenHands 커뮤니티 포럼](https://github.com/OpenHands/OpenHands/discussions) — 질문 및 문제 해결
- [Agent Control Plane 문서](https://docs.openhands.dev/openhands/usage/key-features) — VS Code 통합 및 멀티 에이전트 설정

---

*이 가이드는 독립적으로 유지관리되며 정기적으로 업데이트됩니다. 마지막 검증: 2026년 5월.*
