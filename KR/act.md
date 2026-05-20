---
title: 'act: 70,410 GitHub Stars — 로컬에서 GitHub Actions 실행, 2026 프로덕션 CI/CD 가이드'
description: 'act (nektos/act)는 Docker 컨테이너에서 GitHub Actions 워크플로우를 로컬로 실행하는 CLI 도구입니다. Docker, GitHub Actions, Go, VS Code와 호환됩니다. 설치, 설정, 시크릿 관리, runner 이미지, 프로덕션 하드닝을 다룹니다.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/nektos/act'
stars: 70410
maintainer: 'nektos'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['act', 'github-actions', 'ci-cd', 'docker', '로컬-개발', 'devops', '테스트', '자동화']
aliases:
- /kr/posts/act/
---

{{</* resource-info */>}}

![act logo](https://raw.githubusercontent.com/nektos/act/master/img/act-logo.png)

## 소개

GitHub Actions 워크플로우를 작성해 본 모든 개발자는 이 고통을 알고 있습니다: `.github/workflows/ci.yml`을 수정하고, 커밋하고, 푸시한 뒤, runner가 실행되기를 3-5분 기다렸다가 4단계에서 환경 변수 누락이나 셸 명령어 오타로 실패하는 것을 지켜봅니다. 피드백 루프는 느리고, GitHub Actions 분을 소모하며, 커밋 히스토리를 "fix CI" 메시지로 더럽힙니다. 2026년, CI/CD 파이프라인이 모든 배포를 관리하는 시점에서 이러한 비효율은 더 이상 용납될 수 없습니다. [act](https://github.com/nektos/act)는 Casey Lee와 nektos 조직이 Go로 개발한 CLI 도구로, Docker 컨테이너 낶에서 GitHub Actions 워크플로우를 로컬로 실행하여 GitHub의 환경 변수, 파일 시스템 레이아웃, runner 동작을 재현합니다. GitHub에서 70,410개의 스타와 번성하는 통합 생태계를 보유한 act는 로컬 CI/CD 개발의 표준 도구가 되었습니다.

## act란 무엇인가?

act는 `.github/workflows/`에서 GitHub Actions 워크플로우 파일을 읽고 Docker 컨테이너를 사용하여 로컬에서 실행하는 CLI 도구로, GitHub Actions 런타임 환경을 충실히 재현합니다. 이 tutorial은 설치부터 프로덕션 하드닝까지 완전한 act 설정을 안내하여 GitHub에 푸시하기 전에 모든 워크플로우 변경 사항을 검증할 수 있게 합니다.

## act의 작동 원리

act는 로컬 GitHub Actions runner 시뮬레이터로 작동합니다. 저장소에서 `act`를 실행하면 다음 단계를 수행합니다:

1. **워크플로우 발견**: `.github/workflows/`에서 YAML 워크플로우 파일 스캔
2. **이벤트 파싱**: 이벤트 유형(push, pull_request 등)에 따라 실행할 워크플로우 결정
3. **의존성 해결**: 작업 의존성의 방향성 비순환 그래프(DAG) 구축
4. **이미지 준비**: 지정된 runner용 Docker 이미지 풀링 또는 빌드
5. **컨테이너 실행**: GitHub 호환 환경 변수와 파일 시스템 마운트가 있는 Docker 컨테이너에서 각 단계 실행
6. **아티팩트 수집**: 출력, 아티팩트, 로그 수집

![act 아키텍처 다이어그램](https://raw.githubusercontent.com/nektos/act/master/img/act-quickstart-2.gif)

이 도구는 Docker Engine API를 직접 사용하므로, Docker 호환 컨테이너 런타임은 모두 백엔드로 작동합니다. 환경 변수(`GITHUB_SHA`, `GITHUB_REF`, `GITHUB_REPOSITORY` 등)와 파일 시스템 구조(`/github/workspace`, `/github/event.json`, `/github/home`)는 GitHub가 호스팅 runner에서 제공하는 내용과 일치하도록 구성됩니다.

### Runner 이미지 크기

act는 충실도와 디스크 공간 간의 균형을 맞추기 위해 세 가지 이미지 계층을 제공합니다:

| 이미지 크기 | 다운로드 | 디스크 공간 | 사용 사례 |
|---|---|---|---|
| Micro | ~50 MB | <200 MB | Node.js 전용, 빠른 스모크 테스트 |
| Medium | ~200 MB | ~500 MB | 필수 도구 포함, 대부분의 워크플로우에 적합 |
| Large | ~5 GB | ~18-75 GB | 전체 GitHub runner 동등성, 완전한 툴체인 |

기본 Medium 이미지(`catthehacker/ubuntu:act-latest`)는 Python, Node.js, Go, Ruby, Java, .NET 및 일반적인 빌드 도구를 포함합니다. Large 이미지(`catthehacker/ubuntu:full-*`)는 실제 GitHub 호스팅 runner의 파일 시스템 덤프로, 가장 근접한 동등성을 제공합니다.

## 설치 및 설정

act는 Docker가 설치된 모든 플랫폼에서 60초 이내에 설치됩니다. 원하는 방법을 선택하세요:

### macOS (Homebrew)

```bash
# Homebrew를 통해 act 설치
brew install act

# 설치 확인
act --version
# act version 0.2.88
```

### Linux (Bash 스크립트)

```bash
# 한 줄 설치 (bash와 curl 필요)
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# 대안: 사전 빌드된 바이너리 다운로드
wget https://github.com/nektos/act/releases/download/v0.2.88/act_Linux_x86_64.tar.gz
tar xzf act_Linux_x86_64.tar.gz
sudo mv act /usr/local/bin/
```

### Windows (Chocolatey / Scoop / WinGet)

```powershell
# Chocolatey
choco install act-cli

# Scoop
scoop install act

# WinGet
winget install nektos.act
```

### GitHub CLI 확장

```bash
# gh CLI 확장으로 설치
gh extension install https://github.com/nektos/gh-act

# gh를 통해 실행
gh act
```

### 소스에서 빌드 (Go 1.20+)

```bash
git clone https://github.com/nektos/act.git
cd act/
make build
sudo make install
```

### 설치 후 설정

첫 실행 시 act는 기본 이미지 크기 선택을 요청합니다:

```bash
# 첫 실행 — 기본 runner 이미지 선택
act
? Please choose the default image you want to use with act:
  - Large size image: ~17GB download, ~75GB disk space, closest to GitHub runners
  - Medium size image: ~500MB, includes essential tools (RECOMMENDED)
  - Micro size image: <200MB, Node.js only
```

이렇게 하면 `~/.actrc`에 기본 설정이 생성됩니다:

```bash
# ~/.actrc — 기본 설정
cat ~/.actrc
-P ubuntu-latest=catthehacker/ubuntu:act-latest
```

### Docker 사전 요구사항

act는 Docker Engine API가 필요합니다. 실행 전 확인:

```bash
# Docker가 실행 중인지 확인
docker info

# Docker API에 접근 가능한지 확인
docker version
```

**참고:** Podman은 공식적으로 지원되지 않습니다(issue #303). 루트리스 설정이나 대안으로 macOS에서 Docker Desktop, Rancher Desktop, 또는 Colima를 사용하세요.

## Docker, VS Code, GitHub Enterprise, Make와의 통합

### Docker 통합

act는 실행 엔진으로 Docker를 사용합니다. 모든 워크플로우 작업은 격리된 컨테이너에서 실행됩니다:

```bash
# 사용자 지정 runner 이미지로 실행
act -P ubuntu-latest=node:20-slim

# 사용자 지정 Docker 호스트 지정 (원격 엔진)
export DOCKER_HOST=tcp://remote-docker:2376
act

# Apple Silicon에서 컨테이너 아키텍처 플래그 사용
act --container-architecture linux/amd64
```

Docker-in-Docker (DinD) 워크플로우는 호스트 Docker 소켓 마운트를 통해 지원됩니다:

```yaml
# .github/workflows/dind-test.yml
name: Docker Build Test
on: push
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Docker image
        run: docker build -t myapp:latest .
```

### VS Code 확장 (GitHub Local Actions)

[GitHub Local Actions](https://marketplace.visualstudio.com/items?itemName=SanjulaGanepola.github-local-actions) VS Code 확장은 act를 위한 GUI를 제공합니다:

```bash
# VS Code 마켓플레이스에서 확장 설치
# Cmd+Shift+P → "Extensions: Install Extensions" → "GitHub Local Actions" 검색
```

확장 설치 후:
- 사이드바에서 Act 패널 열기
- `.github/workflows/`의 모든 워크플로우 보기
- 임의의 워크플로우를 클릭하여 로컬로 실행
- 통합 터미널에서 실시간 로그 보기

![VS Code GitHub Local Actions 확장](https://raw.githubusercontent.com/SanjulaGanepola/github-local-actions/main/resources/screencast.gif)

### GitHub Enterprise 지원

act는 프라이빗 GitHub Enterprise Server 인스턴스를 지원합니다:

```bash
# GitHub Enterprise Server 대상 실행
act --github-instance github.company.com

# 인증과 함께
act --github-instance github.company.com -s GITHUB_TOKEN=ghp_xxxxxxxx
```

### Make 대체로 act 사용하기

많은 팀이 act를 로컬 태스크 러너로 사용하며, Makefile을 GitHub Actions 워크플로우로 대체합니다:

```yaml
# .github/workflows/tasks.yml
name: Local Tasks
on: workflow_dispatch
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run linter
        run: npm run lint
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: npm test
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: npm run build
```

```bash
# make 대신 로컬에서 태스크 실행
act -j lint
act -j test
act -j build
```

## 벤치마크 / 실제 사용 사례

### 피드백 루프 비교

| 시나리오 | GitHub에 푸시 | act로 로컬 실행 | 시간 절약 |
|---|---|---|---|
| 워크플로우 오타 수정 | 3-5분 | 15-30초 | 90% |
| 실패한 테스트 디버깅 | 5-10분 (여러 푸시) | 반복당 30-60초 | 85% |
| 테스트 매트릭스 (3 OS × 2 Node 버전) | 8-15분 | 2-3분 | 80% |
| 시크릿/설정 검증 | 3-5분 | 20-40초 | 90% |
| 워크플로우 구문 검사 | 2-3분 | 10-15초 (dry-run) | 92% |

### 사례 연구: CI 분 감소

중간 규모 엔지니어링 팀(25명 개발자)이 하루에 200번 워크플로우 푸시를 실행:

- **act 이전**: 하루 약 600번의 실패한 CI 실행으로 약 3,000 GitHub Actions 분 소모
- **act 이후**: 개발자가 먼저 로컬로 검증; 실패한 CI 실행이 하루 약 80건으로 감소
- **월간 절약**: 약 66,000 GitHub Actions 분 = runner 유형에 따라 약 $400-1,300/월

### 이미지 크기별 시작 시간

| 이미지 | 첫 풀링 | 콜드 스타트 | 웜 스타트 |
|---|---|---|---|
| Micro (node:16-slim) | ~10초 | 5초 | 2초 |
| Medium (catthehacker/ubuntu:act-latest) | ~45초 | 15초 | 5초 |
| Large (catthehacker/ubuntu:full-latest) | ~8분 | 45초 | 15초 |

## 고급 사용법 / 프로덕션 하드닝

### 시크릿 관리

시크릿을 커밋하여 테스트하지 마세요. act는 여러 가지 안전한 패턴을 제공합니다:

```bash
# 옵션 1: 대화형 프롬프트 (수동 실행에 권장)
act -s MY_SECRET

# 옵션 2: 환경 변수 조회
export MY_SECRET=supersecurevalue
act -s MY_SECRET

# 옵션 3: 시크릿 파일 (.secrets, .env와 동일한 형식)
cat > .secrets << 'EOF'
MY_SECRET=supersecurevalue
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
EOF
act --secret-file .secrets

# 옵션 4: GITHUB_TOKEN용 (읽기 전용 PAT 권장)
act -s GITHUB_TOKEN=ghp_xxxxxxxxxxxx
```

`.secrets`를 즉시 `.gitignore`에 추가:

```bash
echo ".secrets" >> .gitignore
echo "*.secrets" >> .gitignore
```

### 저장소 변수 (vars 컨텍스트)

GitHub의 `vars` 컨텍스트가 저장소 수준 설정을 위해 지원됩니다:

```bash
# 변수 설정
act --var DEPLOY_ENV=staging --var API_VERSION=v2

# 또는 변수 파일 사용
cat > .variables << 'EOF'
DEPLOY_ENV=staging
API_VERSION=v2
EOF
act --var-file .variables
```

### 페이로드 파일로 이벤트 시뮬레이션

이벤트 데이터에 의존하는 워크플로우를 JSON 페이로드 파일로 테스트:

```bash
# pull_request 이벤트 시뮬레이션
cat > pull-request.json << 'EOF'
{
  "pull_request": {
    "head": { "ref": "feature/new-login" },
    "base": { "ref": "main" },
    "number": 42
  }
}
EOF
act pull_request -e pull-request.json
```

```bash
# 태그와 함께 push 시뮬레이션
cat > tag-push.json << 'EOF'
{ "ref": "refs/tags/v1.2.3" }
EOF
act push -e tag-push.json
```

```bash
# workflow_dispatch 입력과 함께 시뮬레이션
cat > workflow-inputs.json << 'EOF'
{
  "inputs": {
    "environment": "production",
    "version": "2.0.0"
  }
}
EOF
act workflow_dispatch -e workflow-inputs.json
```

### 드라이-런 모드

실제 실행 없이 워크플로우 구문을 검증하고 실행 계획을 확인:

```bash
# 실행할 모든 작업 나열
act -l

# 드라이 런 (실제 실행 없음)
act -n

# 자세한 드라이 런
act -n -v
```

### 설정 파일 (.actrc)

`.actrc`를 통한 프로젝트별 설정:

```bash
# 프로젝트 루트의 .actrc
cat > .actrc << 'EOF'
--container-architecture linux/amd64
--action-offline-mode
-P ubuntu-latest=catthehacker/ubuntu:act-latest
--env-file .env
--secret-file .secrets
EOF
```

설정 우선순위 (높음에서 낮음):
1. CLI 인자
2. `./.actrc` (프로젝트 루트)
3. `~/.actrc` (홈 디렉토리)
4. `$XDG_CONFIG_HOME/act/actrc`

### 로컬 실행을 위한 작업/단계 건 skipped

로컬에서 실행하지 않을 단계 표시:

```yaml
# 워크플로우 파일에서
jobs:
  deploy:
    if: ${{ !github.event.act }}  # 로컬 실행 시 배포 작업 건 skipped
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

  notify:
    runs-on: ubuntu-latest
    steps:
      - name: 로컬에서 Slack 알림 건 skipped
        if: ${{ !env.ACT }}
        run: |
          curl -X POST -H 'Content-type: application/json' \
            --data '{"text":"Deployment complete"}' ${{ secrets.SLACK_WEBHOOK }}
```

이벤트를 통해 act 플래그 전달:

```bash
cat > event.json << 'EOF'
{ "act": true }
EOF
act -e event.json
```

### 아티팩트 수집

로컬에서 워크플로우 아티팩트 수집:

```bash
# 아티팩트 서버 경로 지정
act --artifact-server-path /tmp/artifacts

# 아티팩트는 /tmp/artifacts/<workflow>/<artifact-name>/에 저장됨
ls -la /tmp/artifacts/
```

### 오프라인 모드

격리 또는 저대역폭 환경용:

```bash
# 사전 풀링 이미지
act --action-offline-mode

# 로컬에 캐시된 작업 저장소와 Docker 이미지를 재사용
# GitHub이나 Docker Hub에서 가져오지 않음
```

## 대안과의 비교

| 기능 | act | GitHub Actions Runner | Drone CI | Jenkins |
|---|---|---|---|---|
| **로컬 실행** | 네이티브 (Docker) | 가능 (복잡한 설정) | Docker 기반 | Java + 플러그인 필요 |
| **GitHub 동등성** | 높음 (동일 YAML 구문) | 완전 (공식 runner) | 중간 (다른 구문) | 낮음 (플러그인 의존) |
| **설정 시간** | <1분 | 10-30분 | 5-10분 | 15-30분 |
| **리소스 사용** | 낮음 (Docker 컨테이너) | 중-높음 (VM/서비스) | 중간 (Docker) | 높음 (JVM + 플러그인) |
| **시크릿 관리** | 파일, 환경변수, 대화형 | GitHub UI만 | Drone UI / CLI | Credentials 플러그인 |
| **셀프 호스팅 옵션** | 해당 없음 (로컬 전용) | 공식 셀프 호스팅 runner | 전체 서버 배포 | 전체 서버 배포 |
| **가격** | 무로 (오픈소스) | 무로 (공개 저장소) / $0.008/분 (비공개) | 무로 (오픈소스) / 클라우드 $15/월부터 | 무로 (오픈소스) |
| **커뮤니티 규모** | 70,410 GitHub stars | GitHub 네이티브 | 27,000+ stars | 확립된 엔터프라이즈 |
| **학습 곡선** | 낮음 (GitHub 구문 사용) | 중간 | 중간 | 높음 |
| **IDE 통합** | VS Code 확장 | 제한적 | 제한적 | 풍부함 |

**act를 선택할 때:**
- **act**: 로컬 개발, 워크플로우 디버깅, 커밋 전 검증, GitHub Actions 학습
- **GitHub Actions Runner**: GitHub 인프라 또는 셀프 호스팅 클러스터에서 프로덕션 CI/CD
- **Drone CI**: 컨테이너 네이티브 파이프라인을 원하는 팀, 다른 구문 선호
- **Jenkins**: 광범위한 플러그인 생태계와 레거시 통합이 필요한 엔터프라이즈급 CI/CD

## 한계 / 객관적 평가

act는 개발 및 디버깅 도구이며, 프로덕션 CI/CD의 대체재가 아닙니다. 도입 전 다음 제약사항을 이해하세요:

1. **Linux runner만 지원**: Windows (`windows-latest`) 및 macOS (`macos-latest`) runner는 컨테이너화된 실행을 지원하지 않습니다. `-self-hosted` 플래그는 macOS/Windows 호스트에서 직접 작업을 실행할 수 있지만, 이는 컨테이너 격리를 우회하고 GitHub의 runner 환경과 일치하지 않습니다.

2. **기본 이미지 불완전**: Medium runner 이미지에는 GitHub 호스팅 runner에 사전 설치된 모든 도구가 포함되어 있지 않습니다. `swift`, `gcloud` 또는 특정 Android SDK 구성 요소와 같은 소프트웨어는 워크플로우에서 수동 설치 단계가 필요할 수 있습니다.

3. **Docker-in-Docker 제한**: 소켓 마운팅을 통해 act 컨테이너 낶에서 Docker 명령을 실행할 수 있지만, 중첩 컨테이너 시나리오와 Docker 낶의 Kubernetes에는 추가 구성이 필요합니다.

4. **서비스 지원 불완전**: 작업 정의의 Docker Compose `services`는 제한적인 지원을 받습니다(issue #173). 데이터베이스와 캐시는 외부 오케스트레이션이 필요할 수 있습니다.

5. **네트워크 및 캐시 차이**: GitHub Actions 캐싱(`actions/cache`)과 서비스 컨테이너는 로컬에서 다르게 작동합니다. 캐시 히트/미스와 네트워크 지연은 프로덕션과 정확히 일치하지 않습니다.

6. **GitHub 호스팅 작업 마켓플레이스 미지원**: 일부 복합 작업이나 GitHub 낶부 API에 의존하는 작업은 로컬에서 실패할 수 있습니다.

7. **Large 이미지 디스크 요구사항**: Large 이미지는 약 18-75 GB로, 저장 공간이 제한된 랩톱에는 비실용적입니다. 대부분의 팀은 일상적인 개발에 Medium 이미지를 사용해야 합니다.

## 자주 묻는 질문

### Q1: act는 인터넷 연결이 필요합니까?

첫 실행에는 필요합니다 — act는 GitHub에서 Docker 이미지를 풀링하고 작업 저장소를 클론해야 합니다. 이후 `--action-offline-mode`를 사용하여 캐시된 이미지와 작업으로 작업할 수 있습니다. 오프라인 전 `docker pull`로 이미지를 사전 풀링하세요.

### Q2: 워크플로우에서 특정 작업만 실행하려면 어떻게 합니까?

워크플로우 YAML에 정의된 작업 ID 뒤에 `-j` 플래그를 사용합니다:

```bash
# "test" 작업만 실행
act -j test

# 특정 워크플로우 파일에서 작업 실행
act -j lint -W .github/workflows/checks.yml
```

### Q3: act를 프라이빗 GitHub 저장소나 GitHub Enterprise와 함께 사용할 수 있습니까?

예. 프라이빗 저장소의 경우 `-s GITHUB_TOKEN`을 통해 개인 액세스 토큰을 제공합니다. GitHub Enterprise Server의 경우 `--github-instance`를 사용합니다:

```bash
act --github-instance github.mycompany.com -s GITHUB_TOKEN=ghp_xxx
```

### Q4: 왜 내 워크플로우가 "MODULE_NOT_FOUND"으로 실패합니까?

로컬 작업(예: `uses: ./`)을 사용할 때 적절한 체크아웃 없이 이 오류가 발생합니다. 저장소 이름이 체크아웃 경로와 일치하는지 확인하세요. 저장소가 `my-project`라면 체크아웃 단계에 `path: "my-project"`를 포함해야 합니다.

### Q5: 실패한 단계를 어떻게 디버깅합니까?

상세 로깅(`-v`)으로 act를 실행하고 컨테이너를 보존하여 검사합니다:

```bash
# 상세 출력
act -v

# 특정 작업에 상세 출력 적용
act -j test -v

# 컨테이너 이름이 로그에 출력됨; 실패 후 검사
docker exec -it <container-name> /bin/bash
```

### Q6: act는 프로덕션 CI/CD 파이프라인 실행에 적합합니까?

아니요. act는 로컬 개발 및 디버깅을 위해 설계되었습니다. 프로덕션 CI/CD에는 GitHub 호스팅 runner, 셀프 호스팅 runner, 또는 GitHub Actions, Drone, Jenkins와 같은 전용 CI/CD 플랫폼을 사용하세요.

### Q7: act를 최신 버전으로 업데이트하려면 어떻게 합니까?

설치에 사용한 것과 동일한 패키지 관리자를 사용합니다:

```bash
# Homebrew
brew upgrade act

# Chocolatey
choco upgrade act-cli

# Scoop
scoop update act

# Bash 스크립트 (설치기 재실행)
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
```

## 결론

70,410개의 스타와 GitHub Actions 업데이트에 맞춰 유지되는 릴리즈 주기를 갖춘 act는 모든 개발자의 도구킷에서 확고한 위치를 차지했습니다. 푸시 전에 워크플로우를 로컬로 검증하는 기능은 커밋-푸시-대기-실패-수정의 비싼 피드백 루프를 제거합니다. 1분 이내에 설치하고, `.actrc`를 구성한 뒤, CI/CD 정의를 머신에서 테스트할 수 있는 일급 코드로 취급하기 시작하세요.

**실행 항목:**
1. 선호하는 패키지 관리자로 act 설치
2. 워크플로우가 있는 저장소에서 `act -l` 실행하여 사용 가능한 작업 확인
3. 기본 runner 설정으로 `.actrc` 파일 생성
4. 로컬 시크릿 관리를 위한 `.secrets` 파일 설정 (`.gitignore`에 추가)
5. 팀과 이 가이드를 공유하여 로컬 CI/CD 개발 표준화

[dibi8 개발자 Telegram 커뮤니티](https://t.me/dibi8)에 참여하여 act 설정에 대해 논의하고, 워크플로우 최적화를 공유하며, 프로덕션 환경에서 act를 사용하는 엔지니어로부터 도움을 받으세요.



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- [act GitHub 저장소](https://github.com/nektos/act) — 공식 소스 코드, 70,410 stars
- [act 사용자 가이드](https://nektosact.com/) — 포괄적인 문서
- [act 설치 가이드](https://nektosact.com/installation/index.html) — 플랫폼별 설치 방법
- [act Runner 참조](https://nektosact.com/usage/runners.html) — Docker 이미지 옵션 및 크기
- [act 사용 가이드](https://nektosact.com/usage/index.html) — 이벤트, 시크릿, 설정
- [VS Code: GitHub Local Actions 확장](https://marketplace.visualstudio.com/items?itemName=SanjulaGanepola.github-local-actions)
- [GitHub Actions 문서](https://docs.github.com/en/actions)
- [catthehacker/docker_images](https://github.com/catthehacker/docker_images) — act가 사용하는 커뮤니티 runner 이미지
