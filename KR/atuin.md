---
title: 'Atuin: 29,794 GitHub Stars — 셸 히스토리 동기화 완벽 설정 가이드 2026'
description: 'Atuin은 셸 히스토리를 SQLite 데이터베이스로 교체하고, 명령어 컨텍스트(종료 코드, 작업 디렉토리, 실행 시간)를 기록하며, E2E 암호화로 여러 머신 간 히스토리를 동기화한다. Bash, Zsh, Fish, Nushell 지원. 설치, 자체 호스팅, 설정 및 Atuin vs mcfly vs fzf vs Hstr 비교 포함.'
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
github_repo: 'https://github.com/atuinsh/atuin'
stars: 29794
maintainer: 'atuinsh'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['atuin', '셸-히스토리', 'cli-도구', 'sqlite', 'rust', '동기화', 'bash', 'zsh', 'fish']
aliases:
- /kr/posts/atuin/
---

{{</* resource-info */>}}

![Atuin Shell History](https://raw.githubusercontent.com/atuinsh/atuin/main/docs/static/img/atuin.png)

*Atuin은 기존 셸 히스토리를 SQLite 데이터베이스와 Ctrl+R로 활성화되는 전체 화면 퍼지 검색 UI로 교체한다.*

![Atuin Stats](https://docs.atuin.sh/assets/images/stats.png)

*`atuin stats` 명령어는 가장 많이 사용한 명령어, 총 명령어 수 및 고유 명령어 분석을 표시한다.*

## 소개

그 복잡한 `kubectl` 명령어를 이번 주에 최소 세 번 입력했을 것이다. 히스토리 어딘가에 있을 거라는 걸 안다 — 아마도 다른 4만 개 명령어 아래 묻혀 있겠지만 — `Ctrl+R` 역방향 검색은 한 번에 하나씩만 매칭을 순환하고, `grep ~/.bash_history`는 잡음의 벽을 반환한다. 터미널에서 사는 개발자에게 셸 히스토리는 두 번째 기억이다. 이것이 실패하면 생산성이 떨어진다.

Atuin은 SQLite 기반 히스토리 데이터베이스로 이 문제를 해결한다. 명령어뿐만 아니라 그 주변 컨텍스트도 기록한다: 종료 코드, 작업 디렉토리, 호스트명, 세션 ID, 실행 시간. 29,794개의 GitHub Stars와 Rust 기반 코드베이스를 바탕으로 Atuin은 모든 셸 세션에 퍼지 검색, 암호화된 머신 간 동기화, 사용량 분석을 추가한다. 이 가이드는 첫 번째 명령어부터 자체 호스팅 동기화 서버까지 프로덕션급 Atuin 설치를 안내한다.

## Atuin이란?

Atuin은 Rust로 작성된 셸 히스토리 교체 도구로, 풍부한 메타데이터와 함께 명령어를 로컬 SQLite 데이터베이스에 저장한 다음, E2E 암호화를 통해 여러 머신 간 히스토리 동기화를 선택적으로 제공한다. atuinsh 조직이 관리하며 MIT 라이선스로 배포되며, Bash, Zsh, Fish, Nushell, Xonsh 및 PowerShell(2차 지원)을 지원한다.

## Atuin의 작동 방식

Atuin은 클라이언트 측 히스토리 인터셉터와 선택적 동기화 클라이언트로 작동한다. 아키텍처를 이해하면 동기화 문제를 디버깅하거나 자체 호스팅 배포를 계획하는 데 도움이 된다.

### 아키텍처 개요

```
+-------------+     preexec/precmd 훅       +------------------+
|   Shell     |  -------------------------->  |   Atuin Client   |
| (bash/zsh)  |                             |   (Rust binary)  |
+-------------+                             +--------+---------+
                                                     |
                                            +--------v---------+
                                            |   SQLite (로컬)  |
                                            |   ~/.local/share |
                                            +--------+---------+
                                                     |
                              +----------------------v----------------------+
                              |              동기화 프로토콜 V2               |
                              |   PASETO V4 (XChaCha20-Poly1305 + Blake2b) |
                              +----------------------+----------------------+
                                                     |
                              +----------------------v----------------------+
                              |         Atuin 서버 (자체 호스팅 또는 클라우드) |
                              |         PostgreSQL 또는 SQLite 백엔드         |
                              +---------------------------------------------+
```

### 핵심 컴포넌트

1. **셸 훅 레이어**: Atuin은 셸 전용 플러그인을 통해 `preexec`(명령 전) 및 `precmd`(명령 후) 훅을 등록한다. 이 훅은 명령어 문자열, 작업 디렉토리, 시작 시간, 종료 코드를 캡처한다.
2. **로컬 SQLite 데이터베이스**: 모든 히스토리는 `~/.local/share/atuin/history.db`에 SQLite WAL 모드를 사용하여 저장되어 동시 읽기/쓰기 성능을 보장한다.
3. **동기화 클라이언트**: 선택적 백그라운드 동기화는 암호화된 레코드를 Atuin 서버로 푸시한다. 데이터는 머신을 떠나기 전에 레코드별 콘텐츠 암호화 키로 봉투 암호화된다.
4. **TUI 검색 인터페이스**: 전체 터미널 UI(`ratatui` 기반)가 `Ctrl+R`을 대체하여 퍼지/접두사/전문 검색과 필터 모드를 제공한다.

### 암호화 상세

| 프로토콜 | 알고리즘 | 상태 |
|----------|----------|------|
| V1 (레거시) | XSalsa20Poly1305 (NaCl secretbox) | 단계적 폐지 |
| V2 (현재) | PASETO V4 Local (XChaCha20-Poly1305 + Blake2b) | 활성 |

V2는 봉투 암호화를 사용한다: 각 레코드는 사용자 마스터 키로 래핑된 무작위 CEK를 얻는다. 마스터 키는 `~/.local/share/atuin/key`에 있으며 기기를 절대 떠나지 않는다.

## 설치 및 설정

### 원라인 설치 (권장)

```bash
# Unix/macOS — 인터랙티브 설치, 셸 설정 프롬프트 포함
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# 비인터랙티브 (CI, Dockerfile)
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive
```

인스톨러는 바이너리를 `~/.atuin/bin/atuin`에 배치하고 rc 파일에 셸 통합을 추가한다.

### 패키지 매니저

```bash
# Homebrew (macOS/Linux)
brew install atuin

# Cargo (Rust 툴체인 필요)
cargo install atuin

# Arch Linux
sudo pacman -S atuin

# NixOS / nix
nix-env -iA nixpkgs.atuin

# Debian/Ubuntu (GitHub releases에서)
VERSION="18.16.1"
curl -LO "https://github.com/atuinsh/atuin/releases/download/v${VERSION}/atuin_${VERSION}_amd64.deb"
sudo dpkg -i "atuin_${VERSION}_amd64.deb"

# Windows (WinGet)
winget install -e Atuinsh.Atuin
```

### 셸 통합

설치 후 셸의 rc 파일에 Atuin을 추가한다:

```bash
# Bash — ~/.bashrc에 추가
eval "$(atuin init bash)"

# Zsh — ~/.zshrc에 추가
eval "$(atuin init zsh)"

# Fish — ~/.config/fish/config.fish에 추가
atuin init fish | source

# Nushell — config.nu에 추가
atuin init nu | save ~/.config/nushell/atuin.nu
source ~/.config/nushell/atuin.nu
```

셸을 다시 로드하거나 `exec $SHELL`을 실행하여 활성화한다.

### 기존 히스토리 가져오기

```bash
# 셸 자동 감지 및 가져오기
atuin import auto

# 또는 명시적으로 지정
atuin import bash
atuin import zsh
atuin import fish

# 가져온 개수 확인
atuin stats
```

### 설치 확인

```bash
$ atuin --version
atuin 18.16.1

$ atuin doctor
Atuin Doctor
Checking for diagnostics
[✓] Atuin is compiled with sqlite support
[✓] Atuin is compiled with sync support
[✓] Atuin config directory exists
```

## 핵심 설정

Atuin의 설정 파일은 `~/.config/atuin/config.toml`에 있다. 설정을 자세히 살펴 보기 전에, 다양한 필터 모드가 적용된 검색 인터페이스의 실제 모습은 다음과 같다:

![Atuin Search UI](https://docs.atuin.sh/assets/images/search.png)

*Atuin의 TUI가 퍼지 매칭과 디렉토리 범위 결과가 포함된 인라인 검색 창을 표시한다.* 다음은 프로덕션 하드닝 설정이다:

```toml
# ~/.config/atuin/config.toml
[settings]
# 검색 모드: prefix, fulltext, fuzzy, skim
search_mode = "fuzzy"

# 필터 모드: global, host, session, directory
filter_mode = "global"

# UI 스타일: compact, full
style = "compact"

# 동기화 설정
auto_sync = true
sync_frequency = "5m"
sync_address = "https://api.atuin.sh"

# 민감한 명령어 기록 금지 (정규식 패턴)
history_filter = [
    "^export.*KEY",
    "^export.*SECRET",
    "^export.*PASSWORD",
    "^aws configure",
    "^ssh-keygen",
]

# 작업 디렉토리 필터 — 이 경로에서는 기록하지 않음
cwd_filter = [
    "/tmp/secrets",
    "~/.*cred",
]

# Enter로 명령어 실행; false = Tab으로 먼저 편집
enter_accept = true

# 검색 UI에서 도움말 표시
show_help = false

# 결과 수
inline_height = 20
```

### 주요 설정 옵션 설명

```bash
# 현재 설정값 확인
atuin config get search_mode
# fuzzy

# 해석된 (유효) 값 확인
atuin config get search_mode --resolved
# fuzzy

# 인라인으로 설정값 변경
atuin config set search_mode fulltext
atuin config set filter_mode directory

# 전체 설정 출력
atuin config print
```

### 검색 및 필터 모드

```bash
# Ctrl+R로 필터 모드 간 인터랙티브 전환
# 기본 필터 모드: global -> host -> session -> directory

# 필터가 적용된 명령줄 검색
atuin search --exit 0 --after "yesterday 3pm" make
atuin search --before "2026-01-01" --cwd /project deploy
atuin search --exit 1 --session       # 이 세션의 실패한 명령어

# 매칭 항목 삭제
atuin search --delete "rm -rf /accident"
```

## 인기 도구와의 통합

### Starship 프롬프트

Starship은 Atuin과 충돌 없이 함께 작동한다. 둘 다 독립적으로 셸 이벤트에 후킹한다:

```toml
# ~/.config/starship.toml — 특별한 설정 불필요
# Atuin이 히스토리 처리; Starship이 프롬프트 처리
# rc 파일에서 Atuin init이 Starship init보다 먼저 실행되도록 설정
```

```bash
# ~/.zshrc — 순서가 중요
eval "$(atuin init zsh)"       # Atuin 먼저
eval "$(starship init zsh)"    # Starship 다음
```

### tmux

Atuin은 tmux 세션과 깔끔하게 통합된다. 각 tmux 윈도우는 고유한 세션 ID를 가져 세션별 히스토리 필터링이 가능하다:

```bash
# ~/.tmux.conf — 키를 Atuin 검색 열기에 바인딩
bind-key r run-shell "tmux send-keys C-r"

# Atuin은 환경 변수를 통해 tmux 세션을 자동 감지
# 세션별 필터: Ctrl+R 누른 후 필터 모드 전환
```

### fzf

일부 사용자는 파일 퍼지 검색은 fzf로, 히스토리는 Atuin으로 함께 사용한다:

```bash
# 파일은 fzf로, 히스토리는 Atuin으로
# fzf 히스토리 바인딩 비활성화 (~/.bashrc 또는 ~/.zshrc에서)
export FZF_DEFAULT_COMMAND='fd --type f --hidden'
# Ctrl+R 바인딩 금지 — Atuin이 처리하도록

# 파일 검색용 fzf
alias ff='fzf --preview "bat --style=numbers --color=always {}"'

# 히스토리용 Atuin (자동으로 Ctrl+R에 바인딩)
```

### Nushell

Nushell은 다른 설정 시스템을 사용하므로 명시적 설정이 필요하다:

```nushell
# config.nu
source ~/.config/nushell/atuin.nu

# 환경 변수 설정
$env.ATUIN_NOBIND = true  # 커스텀 키바인딩을 원할 경우
```

### Docker / Dev Containers

```dockerfile
# Dockerfile.dev
RUN curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive
COPY config.toml /root/.config/atuin/config.toml
RUN echo 'eval "$(atuin init bash)"' >> /root/.bashrc
```

## 자체 호스팅 동기화 서버

팀이나 프라이버시를 중시하는 사용자를 위해 Atuin의 동기화 서버는 Docker로 자체 호스팅할 수 있다.

### Docker Compose 설정

```yaml
# docker-compose.yml
version: "3"
services:
  atuin:
    restart: always
    image: ghcr.io/atuinsh/atuin:latest
    command: server start
    volumes:
      - ./config:/config
      - ./atuin-data:/atuin-data
    links:
      - postgresql
    ports:
      - "8888:8888"
    environment:
      ATUIN_HOST: "0.0.0.0"
      ATUIN_PORT: "8888"
      ATUIN_OPEN_REGISTRATION: "true"
      ATUIN_DB_URI: "postgres://atuin:change-me@postgresql/atuin"
      RUST_LOG: "info,atuin_server=debug"
    user: "1000:1000"

  postgresql:
    image: postgres:14
    restart: always
    volumes:
      - ./postgres-data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: atuin
      POSTGRES_PASSWORD: change-me
      POSTGRES_DB: atuin
    user: "1000:1000"

  # 선택: 자동 백업
  backup:
    image: prodrigestivill/postgres-backup-local
    restart: always
    volumes:
      - ./backups:/backups
    links:
      - postgresql
    environment:
      POSTGRES_HOST: postgresql
      POSTGRES_DB: atuin
      POSTGRES_USER: atuin
      POSTGRES_PASSWORD: change-me
      POSTGRES_EXTRA_OPTS: "-Z6 --schema=public --blobs"
      SCHEDULE: "@daily"
      BACKUP_KEEP_DAYS: "7"
```

### 서버 시작

```bash
# 데이터 디렉토리 생성
mkdir -p atuin-data postgres-data backups

# 서비스 시작
docker compose up -d

# 상태 확인
curl http://localhost:8888/health
# {"status":"ok"}
```

### 자체 호스팅 클라이언트 설정

```toml
# ~/.config/atuin/config.toml
[settings]
sync_address = "http://your-server:8888"
auto_sync = true
sync_frequency = "5m"
```

```bash
# 자체 호스팅 서버에 새 계정 등록
atuin register -u myuser -e myuser@example.com -p securepassword

# 또는 추가 머신에서 로그인
atuin login -u myuser -p securepassword

# 암호화 키 가져오기 (안전하게 백업)
atuin key
# c2e2d6e5a9b1c3f4d7e8a9b0c1d2e3f4...

# 동기화 트리거
atuin sync
```

### Kubernetes 배포

```yaml
# atuin-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: atuin-server
spec:
  replicas: 2
  selector:
    matchLabels:
      app: atuin
  template:
    metadata:
      labels:
        app: atuin
    spec:
      containers:
        - name: atuin
          image: ghcr.io/atuinsh/atuin:18.16.1
          command: ["atuin", "server", "start"]
          ports:
            - containerPort: 8888
          env:
            - name: ATUIN_HOST
              value: "0.0.0.0"
            - name: ATUIN_DB_URI
              valueFrom:
                secretKeyRef:
                  name: atuin-db-secret
                  key: uri
---
apiVersion: v1
kind: Service
metadata:
  name: atuin-service
spec:
  selector:
    app: atuin
  ports:
    - port: 8888
      targetPort: 8888
```

## 벤치마크 / 실제 사용 사례

### 성능 특성

Atuin의 Rust 구현과 SQLite 백엔드는 대용량 히스토리 데이터셋에서 일관된 성능을 제공한다:

| 지표 | 값 | 참고 |
|------|------|------|
| 히스토리 쿼리 (10만 개) | ~15ms | 퍼지 검색, 콜드 캐시 |
| 히스토리 쿼리 (50만 개) | ~45ms | 퍼지 검색, 웜 캐시 |
| 동기화 초기 업로드 (5만 개 명령) | ~30초 | 대역폭에 따라 다름 |
| 증분 동기화 | ~1-3초 | 일반적인 일일 델타 |
| 바이너리 크기 | ~12MB | 단일 정적 바이너리 |
| 메모리 사용량 | ~15MB | 유휴 시 상주 |
| SQLite DB 크기 | ~100MB/10만 명령 | 전체 메타데이터 포함 |

### 프로덕션 사용 사례

1. **다중 장치 개발**: 업무용 노트북, 개인 데스크톱, 클라우드 VM을 가진 개발자가 모든 셸 히스토리를 동기화한다. 한 머신에서 `docker compose up`을 실행한 것을 다른 머신에서 검색할 수 있다.
2. **팀 지식 보존**: DevOps 팀이 Atuin을 자체 호스팅하여 교대 근무 엔지니어 간에 검색 가능한 인프라 명령 감사 추적을 유지한다.
3. **원격 환경 복구**: 임시 클라우드 워크스페이스(Gitpod, Coder)를 사용하는 개발자가 히스토리를 동기화하여 워크스페이스 제거 시 명령어 컨텍스트가 지워지지 않도록 한다.

### Stats 명령어 출력

```bash
$ atuin stats
[▮▮▮▮▮▮▮▮▮▮]  9,607 fg
[▮▮▮▮▮▮▮▮▮ ]  9,458 vim
[▮▮▮       ]  3,144 ag
[▮▮▮       ]  3,095 git status
[▮▮        ]  2,248 git diff
[▮         ]  1,787 curl
[▮         ]  1,571 jq
[▮         ]  1,357 rg
[▮         ]  1,348 cd
[▮         ]  1,322 git log
Total commands:   62,849
Unique commands:  26,908
```

## 고급 사용법 / 프로덕션 하드닝

### 히스토리 프라이버시 필터

민감한 명령어가 데이터베이스에 들어가는 것을 방지한다:

```toml
# ~/.config/atuin/config.toml
[settings]
history_filter = [
    # AWS 자격 증명
    "^aws configure",
    "^export AWS_SECRET_ACCESS_KEY",
    # 일반 시크릿
    "^export.*SECRET",
    "^export.*PASSWORD",
    "^export.*TOKEN",
    "^echo.*password",
    # SSH 키
    "^ssh-add",
    "^ssh-keygen",
    # 데이터베이스 연결 문자열
    "^psql.*://.*:",
    "^mysql.*-p",
]
```

### 히스토리 백업

```bash
# SQLite 백업 (안전, 락 문제 없음)
sqlite3 ~/.local/share/atuin/history.db ".backup '/backup/atuin-$(date +%Y%m%d).db'"

# WAL 체크포인트로 복사
cp ~/.local/share/atuin/history.db ~/backups/atuin-backup.db

# cron을 통한 자동 일일 백업
0 2 * * * sqlite3 ~/.local/share/atuin/history.db ".backup '/backups/atuin/atuin-$(date +\%Y\%m\%d).db'" && find /backups/atuin -mtime +30 -delete
```

### 동기화 상태 모니터링

```bash
# 마지막 동기화 시간 확인
atuin sync --force  # 강제 동기화 및 상태 표시

# 동기화 정보 확인
atuin info
# Atuin v18.16.1
# Sync interval: 5m
# Sync address: https://api.atuin.sh
# Last sync: 2026-05-20T08:15:32Z
# History count: 47,231

# 문제 확인
atuin doctor
```

### TUI 테마

```toml
# ~/.config/atuin/config.toml
[theme]
# 터미널 기본 색상 사용
use_default_colors = true

# 또는 명시적 색상 지정
base = "#1e1e2e"
layer1 = "#313244"
text = "#cdd6f4"
accent = "#89b4fa"
```

### 다중 머신 키 마이그레이션

새 머신을 설정할 때 암호화 키를 안전하게 전송한다:

```bash
# 이전 머신에서 — 클립보드에 키 복사 (또는 안전한 전송)
cat ~/.local/share/atuin/key

# 새 머신에서 — 설치 및 로그인 후
mkdir -p ~/.local/share/atuin
echo "YOUR_KEY_HERE" > ~/.local/share/atuin/key
chmod 600 ~/.local/share/atuin/key

# 동기화가 작동하는지 확인
atuin sync
atuin stats
```

## 대안과의 비교

| 기능 | Atuin | mcfly | fzf + history | Hstr |
|------|-------|-------|---------------|------|
| **데이터베이스** | SQLite | SQLite | 텍스트 파일 | 텍스트 파일 |
| **머신 간 동기화** | 예 (E2EE) | 아니오 | 아니오 | 아니오 |
| **검색 UI** | 내장 TUI | 내장 TUI | fzf 통합 | 내장 TUI |
| **컨텍스트 기록** | cwd, 종료, 시간, 호스트 | cwd, 종료 | 없음 | 없음 |
| **통계** | `atuin stats` | 없음 | 없음 | 없음 |
| **셸 지원** | bash, zsh, fish, nu, xonsh | bash, zsh, fish | 모든 셸 | bash, zsh |
| **암호화** | PASETO V4 | 없음 | 없음 | 없음 |
| **자체 호스팅 서버** | 예 (Docker/K8s) | 해당 없음 | 해당 없음 | 해당 없음 |
| **AI 통합** | 예 (선택) | 아니오 | 아니오 | 아니오 |
| **히스토리 가져오기** | bash, zsh, fish, nu | bash, zsh, fish | 해당 없음 | bash, zsh |
| **GitHub Stars** | 29,794 | 6,800 | 67,000 (fzf) | 3,900 |
| **바이너리 크기** | ~12MB | ~4MB | ~4MB (fzf만) | ~2MB |

### 각 도구를 선택하는 경우

- **Atuin**: 암호화된 다중 머신 동기화, 풍부한 컨텍스트 메타데이터, 풀기능 검색 UI가 필요한 경우. 2대 이상 머신을 사용하고 히스토리 분석을 중시하는 개발자에게 최적.
- **mcfly**: 가볍고 완전히 로컬이며 지능적 컨텍스트 순위가 필요한 경우. 단일 머신 사용자, 네트워크 제로 의존.
- **fzf + history**: 이미 파일 검색에 fzf를 사용하고 최소한의 히스토리 솔루션을 원하는 경우. 하나의 도구로 모든 퍼지 검색을 해결하고자 하는 사용자에게 최적.
- **Hstr**: 데이터베이스 오버헤드 없이 단순하고 가벼운 히스토리 TUI가 필요한 경우. bash/zsh 미니멀리스트에게 최적.

## 한계 / 솔직한 평가

Atuin은 모든 시나리오에 적합한 도구가 아니다:

1. **실행자 추적 없음**: Atuin은 명령어를 기록하지만 수동 입력, 스크립트 실행, AI 코딩 보조 생성 여부는 구분하지 않는다. 모든 소스가 데이터베이스에서 동일하게 보인다.

2. **로컬 데이터베이스는 암호화되지 않음**: `~/.local/share/atuin/`의 SQLite 데이터베이스는 성능을 위해 평문으로 저장된다. 동기화는 암호화되지만 로컬 저장은 그렇지 않다. 보호를 위해 파일 시스템 암호화(LUKS, FileVault)를 사용하라.

3. **Bash 통합이 취약할 수 있음**: Bash의 `preexec` 훅은 DEBUG 트랩에 의존하며 다른 도구(pyenv, nodenv, 특정 PROMPT_COMMAND 설정)와 충돌할 수 있다. Zsh와 Fish 통합이 더 안정적이다.

4. **동기화에 계정 필요**: 자체 호스팅 동기화에도 사용자 등록이 필요하다. 익명 또는 "S3에 직접 동기화" 모드는 없다.

5. **위쪽 화살표 바인딩이 신규 사용자를 혼란스럽게 함**: Atuin은 기본적으로 위쪽 화살표 키를 대체하여 최근 명령어만 순환하려는 사용자를 혼란스럽게 할 수 있다. `filter_mode_shell_up_key = "session"`을 설정하거나 바인딩을 완전히 비활성화하라.

6. **PowerShell 지원은 2차**: 기능적으로 작동하지만 PowerShell 통합은 테스트가 적어 Unix 셸 기능보다 뒤처질 수 있다.

## 자주 묻는 질문

### 위쪽 화살표 바인딩을 비활성화하려면?

설정에 `filter_mode_shell_up_key = "global"` 또는 `show_preview = false`를 추가한다. Atuin의 위쪽 화살표를 완전히 비활성화하려면 init 줄 전에 `export ATUIN_NOBIND=1`을 추가하고 `Ctrl+R`만 수동으로 바인딩한다:

```bash
# ~/.bashrc
export ATUIN_NOBIND=1
eval "$(atuin init bash)"
bind '"\C-r": "\C-aatuin search\C-j"'
```

### 동기화 없이 Atuin을 사용할 수 있나?

예. Atuin은 완전히 로컬 도구로 작동한다. 등록을 건너뛰고 모든 동기화 명령을 무시한다. 히스토리는 로컬 SQLite에 저장되며 모든 검색 기능이 오프라인에서 작동한다.

### 데이터는 어떻게 암호화되나?

모든 동기화 데이터는 머신을 떠나기 전에 PASETO V4(XChaCha20-Poly1305 + Blake2b)로 클라이언트 측 암호화된다. 동기화 서버(자체 호스팅 또는 atuin.sh)는 암호화된 blob만 볼 수 있다 — 명령어를 복호화하거나 읽을 수 없다. 로컬 SQLite 데이터베이스는 검색 성능을 위해 암호화되지 않는다.

### 암호화 키를 잃어버리면 어떻게 되나?

암호화 키는 동기화된 히스토리를 복호화하는 데 필요하다. 분실하면 이전에 동기화된 데이터를 복구할 수 없다. 키는 초기 설정 중 `atuin key`로 표시되며 — 비밀번호 관리자에 백업하라. 로컬 히스토리는 키와 관계없이 접근 가능하다.

### 두 사용자가 히스토리 데이터베이스를 공유할 수 있나?

직접적으로는 불가능하다. Atuin의 동기화 모델은 한 사용자가 여러 장치에서 사용하는 것을 목적으로 설계되었다. 팀 공유 히스토리의 경우 각 사용자가 자신의 데이터베이스와 동기화 계정을 유지한다. 자체 호스팅 서버는 여러 독립 계정을 지원한다.

### Atuin이 셸을 느리게 만들까?

측정 가능한 영향은 없다. Rust 바이너리는 셸 시작 시간에 약 5-10ms를 추가하며(일회성), 명령어 캡처는 셸 훅을 통해 비동기적으로 이루어진다. SQLite WAL 모드는 쓰기가 셸 프롬프트를 차단하지 않도록 보장한다.

### 히스토리에서 명령어를 삭제하려면?

```bash
# 검색 패턴으로 삭제
atuin search --delete "sensitive-command"

# 또는 TUI 사용 — 명령어를 찾은 후 Alt+Delete 누르기
```

## 결론

Atuin은 셸 히스토리를 평평한 텍스트 파일에서 구조화되고 검색 가능하며 이식 가능한 데이터베이스로 전환한다. 29,794개의 GitHub Stars, E2E 암호화 동기화, 모든 주요 셸에 대한 지원을 갖춘 Atuin은 터미널에서 사는 모든 개발자에게 실용적인 업그레이드이다.

**다음 단계:**
1. `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh`를 실행하여 설치
2. `atuin import auto`로 기존 히스토리 가져오기
3. 동기화를 위해 등록하거나 자체 호스팅 서버 구성
4. 팁과 문제 해결을 위해 [Telegram 개발자 커뮤니티](https://t.me/dibi8dev) 가입



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- [Atuin GitHub 저장소](https://github.com/atuinsh/atuin)
- [Atuin 공식 문서](https://docs.atuin.sh/)
- [Atuin 자체 호스팅 가이드](https://docs.atuin.sh/self-hosting/docker/)
- [Atuin 설정 참조](https://docs.atuin.sh/cli/reference/config/)
- [PASETO V4 사양](https://paseto.io/)
- [Ellie Huxtable — Atuin 창작자 블로그](https://ellie.wtf/projects/atuin)
- [mcfly GitHub 저장소](https://github.com/cantino/mcfly)
- [fzf GitHub 저장소](https://github.com/junegunn/fzf)
- [Hstr GitHub 저장소](https://github.com/dvorka/hstr)
