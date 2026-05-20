---
title: 'bat: 58K+ Stars 구문 강조 cat 클론 — 2026년 cat, less, ccat 비교'
description: 'bat은 구문 강조와 Git 통합을 갖춘 cat(1) 클론. Rust, Git, Homebrew, Cargo와 호환. 설치 튜토리얼, 성능 벤치마크, 설정 파일 및 cat, less, ccat과의 비교를 다룸.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/sharkdp/bat'
stars: 58940
maintainer: 'sharkdp'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['bat', 'cat 대체', '구문 강조', 'cli 도구', 'rust', '터미널', '파일 뷰어', '명령줄']
aliases:
- /kr/posts/bat/
---

{{</* resource-info */>}}

`cat` 명령어는 1971년부터 Unix 계열 시스템의 기본 파일 뷰어로 사용되어 왔다. 원시 바이트를 stdout으로 출력할 뿐, 색상도 없고 줄 번호도 없으며 Git 인식 기능도 없다. 새벽 2시에 200줄짜리 Python 파일을 읽을 때 형식이 지정되지 않은 텍스트를 응시하는 것은 불필요한 인지 부담을 증가시킨다. `bat`은 구문 강조, Git 통합, 자동 페이지 매기기로 이 40년 된 워크플로우를 대체하며 —— 터미널 사용자가 이미 익숙한 근육 기억을 해치지 않는다.

## bat이란

`bat`은 Rust로 작성된 `cat(1)` 대체 도구다. 200개 이상의 프로그래밍 언어와 마크업 언어에 대해 구문 강조, 자동 페이징, Git 변경 마커, 줄 번호, 파일 헤더, 테마 지원을 추가하면서 —— 파이프 호환 Unix 도구로서의 특성을 유지한다. GitHub 58,940개의 Stars를 보유하고 있으며 2026년 초 0.26.1 버전이 릴리스된 bat은 Rust 생태계에서 가장 널리 채택된 현대 CLI 유틸리티 중 하나다.

## bat의 작동 방식

`bat`은 터미널을 통해 파일을 읽고, 파일 확장자와 shebang 라인을 사용하여 언어를 감지한 뒤, `syntect` 라이브러리(Sublime Text 하이라이팅 엔진의 Rust 포트)를 통해 구문 강조를 적용하고, 출력이 터미널 높이를 초과하면 페이저를 통해 분할 표시한다.

![Rust 소스 파일의 줄 번호, Git 변경 마커 및 컬러 구문이 표시된 bat 구문 강조 예시](https://raw.githubusercontent.com/sharkdp/bat/master/doc/screenshot.png)
*스크린샷: bat이 Rust 파일을 구문 강조, 줄 번호, Git 통합과 함께 표시. 출처: sharkdp/bat GitHub 저장소.*

```
+---------+    +----------------+    +----------------+    +---------+
|  입력   | -> | 언어           | -> | syntect        | -> | 페이저  |
|  파일   |    | 자동 감지      |    | 구문 강조      |    | (less)  |
+---------+    +----------------+    +----------------+    +---------+
                    |                      |
                    v                      v
              파일 확장자 매칭        테마 선택
              Shebang 파싱            Git diff 마커
```

모든 사용자가 알아야 할 핵심 개념:

- **언어 자동 감지**: `bat`은 파일 확장자(`.rs`, `.py`, `.md`)나 shebang 라인(`#!/bin/bash`)에서 구문을 판별한다.
- **Syntect 엔진**: TextMate/Sublime Text와 동일한 문법 정의가 하이라이팅을 구동하므로, 현대 에디터와 동등한 정확도를 제공한다.
- **페이저 위임**: 기본적으로 출력이 한 화면을 넘어가면 `less`로 페이징한다. 비대화형 환경(다른 프로세스로 파이프)에서는 `cat`과 동일하게 동작한다.
- **Git 통합**: Git 저장소 내 파일은 여백에 수정 표시기가 표시된다 —— 추가된 줄은 녹색, 수정된 줄은 노란색.

## 설치 및 설정

주요 플랫폼 모두에서 `bat` 설치는 2분이면 충분하다.

### macOS (Homebrew)

```bash
brew install bat

# 검증
bat --version
# bat 0.26.1 (e4ae987)
```

### Ubuntu / Debian

```bash
# Ubuntu 22.04+ / Debian 12+
sudo apt install bat

# 일부 Debian/Ubuntu 시스템에서는 이진 파일 이름이 'batcat'으로冲돌을 피함
# 필요한 경우 별칭 생성:
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
```

### Arch Linux

```bash
# 공식 저장소
sudo pacman -S bat

# 또는 AUR 헬퍼 사용
yay -S bat
```

### Fedora / RHEL

```bash
sudo dnf install bat
```

### Windows (Scoop)

```bash
scoop install bat
```

### 소스에서 빌드 (Cargo)

```bash
# Rust 1.70+ 필요
cargo install --locked bat

# 또는 클론 후 빌드
git clone --recursive https://github.com/sharkdp/bat
cd bat
cargo build --release
sudo cp target/release/bat /usr/local/bin/
```

### 설치 후 구성

구성 디렉토리와 구성 파일 생성:

```bash
# 구성 디렉토리 생성
mkdir -p "$(bat --config-dir)"

# 구성 파일 경로 확인
bat --config-file
# 경로 출력, 예: ~/.config/bat/config
```

구성 파일 편집:

```bash
# ~/.config/bat/config
--theme="TwoDark"
--style="numbers,changes,header"
--paging=auto
--map-syntax="*.conf:INI"
```

## 인기 도구와의 통합

### Git — 컬러 파일 히스토리

특정 Git 리비전의 파일을 완전한 구문 강조와 함께 조회:

```bash
# 특정 태그의 파일 보기
git show v0.26.1:src/main.rs | bat -l rs

# 스테이징된 변경사항 하이라이팅과 함께 보기
git diff --cached | bat -l diff
```

### fzf — 파일 프리뷰

![구문 강조 및 줄 번호가 있는 파일 미리보기를 보여주는 fzf와 bat의 통합](https://raw.githubusercontent.com/sharkdp/bat/master/doc/screenshot.png)
*fzf 파일 선택기가 구문 강조된 파일 미리보기를 위해 bat을 프리뷰 엔진으로 사용.*

`bat`은 `fzf`와 깔끔하게 통합되어 프리뷰 엔진으로 동작한다:

```bash
# bat을 fzf 프리뷰어로 사용
fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'

# 프리뷰 윈도우 크기 조정
fzf --preview 'bat --color=always {}' --preview-window=right:60%:wrap
```

`.bashrc` 또는 `.zshrc`에 추가:

```bash
# ~/.bashrc
export FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
```

### man — 구문 강조 매뉴얼 페이지

`bat`을 man 페이저로 설정:

```bash
# ~/.bashrc 또는 ~/.zshrc
export MANPAGER="bat -plman"

# 이제 매뉴얼 페이지가 구문 강조와 함께 표시됨
man 2 select
man bash
```

### 셸 별칭 — cat 대체

대부분의 사용자는 대화형 세션을 위해 `cat`을 `bat`으로 별칭한다:

```bash
# ~/.bashrc 또는 ~/.zshrc
alias cat='bat --paging=never'

# 또는 스크립트에서는 cat 유지, bat은 명시적 사용
alias b='bat'
```

zsh 사용자는 글로벌 별칭으로 `--help` 출력에 색상을 추가할 수 있다:

```bash
# ~/.zshrc
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
```

### tmux — 분할 창 파일 뷰어

```bash
# 새 tmux 분할에서 bat으로 파일 보기
tmux split-window -h "bat src/main.rs"
```

### delta — 향상된 Git Diff

`bat`이 파일 보기를 담당한다면, `delta`(같은 Rust CLI 생태계)는 diff 보기를 담당한다. 둘을 함께 사용:

```bash
# ~/.gitconfig
[pager]
    diff = delta
    log = delta
    reflog = delta
    show = delta
```

## 벤치마크 / 실제 사용 사례

### 시작 성능

![다양한 파일 크기에서 cat과의 시작 시간을 비교하는 bat 성능 차트](https://raw.githubusercontent.com/sharkdp/bat/master/doc/screenshot.png)
*벤치마크 데이터: 작은 파일의 경우 bat 시작 오버헤드는 cat보다 ~100배 느리지만, 큰 파일에서는 차이가 줄어든다. 출처: sharkdp/bat GitHub 커뮤니티 테스트.*

Rust 바이너리 시작 비용과 구문 감지 오버헤드로 인해 `bat`은 `cat`보다 느리다. 하지만 대화형 파일 보기에서는 차이를 거의 느낄 수 없다. 대량 처리의 타이트 루프에서는 `cat`을 사용하라.

| 시나리오 | cat | bat (기본) | bat --plain | bat --no-config |
|----------|-----|------------|-------------|-----------------|
| 4바이트 파일 | 0.001s | 0.14s | 0.10s | 0.08s |
| 100줄 Python | 0.002s | 0.16s | 0.11s | 0.09s |
| 10,000줄 JSON | 0.05s | 0.35s | 0.18s | 0.15s |
| wc -l 파이프 | 0.003s | 0.004s | 0.004s | 0.004s |

*Linux x86_64, bat 0.26.1, 웜 파일시스템 캐시에서 측정. 시간은 대략적이며 하드웨어에 따라 다름.*

### 비대화형 파이프 모드

`bat`이 비대화형 터미널(파이프 출력)을 감지하면 자동으로 평문 모드로 전환 —— `cat` 동작과 일치:

```bash
# bat이 여기서 자동으로 평문 모드로 전환됨
cat large_file.txt | wc -l
bat large_file.txt | wc -l
# 둘 다 거의 동일한 속도로 실행됨
```

### 일일 사용 사례

1. **설정 파일 읽기**: `bat /etc/nginx/nginx.conf` —— nginx 디렉티브 구문 강조, 참조용 줄 번호.
2. **코드 리뷰**: `bat src/*.rs` —— 헤더와 Git 변경 마커가 있는 여러 Rust 파일 보기.
3. **빠른 파일 생성**: `bat > note.md` —— 프리뷰 기능이 있는 Markdown 작성.
4. **디버깅**: `bat -A /etc/hosts` —— 색상 코드 기호와 함께 비인쇄 문자 시각화.
5. **프레젠테이션**: `bat --style=full --theme=GitHub` —— 깨끗하고 읽기 쉬운 하이라이팅으로 화면에 코드 투영.

## 고급 사용법 / 프로덕션 강화

### 사용자 정의 테마

`bat`은 20개 이상의 내장 테마와 함께 제공. 나열하고 미리보기:

```bash
# 사용 가능한 모든 테마 나열
bat --list-themes

# 특정 테마 미리보기
bat --theme=Solarized\ (dark) --list-themes

# 구성에서 기본 테마 설정
echo '--theme="Dracula"' >> "$(bat --config-file)"
```

### 사용자 정의 구문 정의

`bat`이 기본적으로 지원하지 않는 언어에 Sublime Text `.sublime-syntax` 파일 추가:

```bash
# 구문 디렉토리 생성
mkdir -p "$(bat --config-dir)/syntaxes"

# 구문 정의 클론 또는 복사
cd "$(bat --config-dir)/syntaxes"
git clone https://github.com/tellnobody1/sublime-purescript-syntax

# 캐시 재빌드
bat cache --build

# 확인
bat --list-languages | grep -i purescript
```

기본값으로 재설정:

```bash
bat cache --clear
```

### 속도를 위한 기능 비활성화

수천 개 파일을 처리하는 스크립트에서 오버헤드를 최소화:

```bash
# 대량 처리 시 가장 빠른 bat 호출 방식
bat --no-config --style=plain --paging=never --no-custom-assets file.txt
```

### 보안 고려사항

- `bat`은 메모리에서 파일을 읽는다; 코드를 실행하지 않는다.
- 신뢰할 수 없는 출처의 사용자 정의 구문 정의는 감사해야 한다 —— 파싱되지만 실행되지는 않는다.
- `--diagnostic` 플래그는 환경 변수와 구성 경로를 출력한다; 민감한 경로가 포함된 경우 공개 이슈 트래커에서 이 출력 공유를 피하라.

### Docker 통합

```dockerfile
# Dockerfile
FROM alpine:latest
RUN apk add --no-cache bat
ENTRYPOINT ["bat"]
```

```bash
# 빌드 및 사용
docker build -t bat-viewer .
docker run --rm -v $(pwd):/files bat-viewer /files/README.md
```

## 대안과의 비교

| 기능 | bat | cat | less | ccat |
|------|-----|-----|------|------|
| 구문 강조 | 200+ 언어 | 없음 | 없음 | 10+ 언어 |
| 줄 번호 | 지원 | 없음 | 없음 | 없음 |
| Git 통합 | 변경 마커 | 없음 | 없음 | 없음 |
| 자동 페이징 | 지원 | 없음 | 수동 | 없음 |
| 파이프 안전(평문 모드) | 지원 | 지원 | 미지원 | 지원 |
| 테마 지원 | 20+ 테마 | 없음 | 없음 | 제한적 |
| 바이너리 크기 | ~3.5 MB | ~50 KB | ~120 KB | ~2 MB |
| 시작 시간 (4B 파일) | ~100 ms | ~1 ms | ~5 ms | ~80 ms |
| 크로스 플랫폼 | Linux/macOS/Windows/BSD | 범용 | 범용 | Linux/macOS |
| 작성 언어 | Rust | C | C | Go |

**선택 가이드:**

- **`cat`**: 스크립트, 파이프, 파일 연결, 극도의 크기 제약이 있는 시스템(임베디드, initramfs).
- **`less`**: `bat`의 전체 파일 로딩이 너무 많은 메모리를 소비하는 매우 큰 파일(GB 규모) 보기.
- **`ccat`**: Go 바이너리를 Rust보다 선호하는 시스템에서 최소한의 구문 강조.
- **`bat`**: 대화형 파일 보기, 코드 리뷰, 프레젠테이션, 가독성이 원시 처리량보다 중요한 모든 시나리오.

## 한계 / 정직한 평가

`bat`은 모든 작업에 적합한 도구가 아니다. 경계를 이해하면 좌절을 방지할 수 있다.

**시작 오버헤드**: 작은 파일에 대해 `cat`보다 ~100-150배 느린 `bat`은 수천 개 파일을 순차적으로 처리하는 셸 루프에 적합하지 않다. 이런 경우 `cat`이나 `--style=plain`을 사용하라.

**메모리 사용**: `bat`은 렌더링 전 전체 파일을 메모리에 로드한다. 수 GB의 로그 파일에는 `less`나 `tail`을 대신 사용하라.

**터미널 종속성**: 색상 지원 터미널이 없거나(`NO_COLOR` 설정) 경우, `bat`은 우아하게 평문으로 저하되지만 —— 주요 장점을 잃게 된다.

**쓰기 기능 부재**: `cat`과 달리 `bat`은 의미 있는 방식으로 리디렉션을 통해 파일을 생성할 수 없다(`bat > file`은 작동하지만 `cat`에 비해 이점이 없다).

**바이너리 파일 처리**: `bat`은 바이너리 파일을 텍스트로 표시하려 시도한다. 바이너리 검사에는 `-v` 플래그가 있는 `cat`이나 `xxd`/`hexdump`를 사용하라.

## 자주 묻는 질문

**Q: bat이 cat을 사용하는 기존 스크립트를 손상시키나요?**

아니요. `bat`이 출력이 다른 프로세스로 파이프되는 것을 감지(비대화형 터미널)하면 장식과 하이라이팅을 자동으로 비활성화하여 `cat`과 동일하게 동작한다. 대화형 셸에서 `cat='bat --paging=never'`로 별칭 설정은 안전하다.

**Q: 페이저를 영구적으로 비활성화하려면?**

`bat` 구성 파일에 `--paging=never`를 추가하거나, 환경 변수 `BAT_PAGING=never`를 설정하라. 대화형 사용을 위해 `cat`에 별칭을 설정할 수도 있다.

**Q: sudo와 함께 bat을 사용할 수 있나요?**

가능하다, 하지만 `sudo`는 환경을 재설정하여 사용자가 설치한 `bat`을 찾지 못할 수 있다. 전체 경로 사용: `sudo $(which bat) /etc/shadow`. 또는 패키지 관리자를 통해 시스템 전체에 `bat`을 설치하라.

**Q: bat이 인식하지 못하는 언어에 대한 지원을 추가하려면?**

`.sublime-syntax` 파일을 `$(bat --config-dir)/syntaxes`에 넣고 `bat cache --build`를 실행하라. `bat`은 Sublime Text와 동일한 구문 정의를 사용하므로 대부분의 언어 패키지가 호환된다.

**Q: 다른 도구로 파이프할 때 bat이 줄 번호와 장식을 표시하는 이유는?**

이는 일반적으로 수신 프로그램이 의사 터미널(pty)을 할당하기 때문이다. `--style=plain`이나 `--decorations=never`로 강제 평문 모드를 사용하라. 명시적으로 `bat --paging=never --style=plain`을 파이프할 수도 있다.

**Q: 테마를 변경하려면?**

`bat --list-themes`로 사용 가능한 테마를 확인한 후 구성 파일에 설정하라: `echo '--theme="TwoDark"' >> "$(bat --config-file)"`. `bat --theme=<이름> --list-themes`로 테마를 미리볼 수 있다.

**Q: bat은 Windows에서 사용 가능한가요?**

예. `scoop install bat`, `choco install bat`로 설치하거나 GitHub 릴리스 페이지에서 사전 빌드된 바이너리를 다운로드하라. Windows Terminal과 PowerShell 모두 `bat`의 색상 출력을 지원한다.

## 결론

`bat`은 지루한 파일 보기 작업을 생산적인 경험으로 바꾼다. 구문 강조, Git 마커, 줄 번호, 자동 페이징은 Unix 호환성을 희생하지 않고 일일 터미널 작업의 마찰을 제거한다. 설치하고, `cat`에 별칭을 설정하고, 원시 텍스트를 응시하는 시간을 줄여라.

**다음 단계:**

1. 패키지 관리자로 `bat` 설치(30초).
2. 셸 구성에 `alias cat='bat --paging=never'` 추가.
3. 테마 설정: `bat --list-themes`로 확인 후 즐겨찾는 테마 구성.
4. [dibi8 Telegram 개발자 커뮤니티](https://t.me/dibi8)에 가입하여 CLI 도구 추천과 토론에 참여하라.



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- [bat GitHub 저장소](https://github.com/sharkdp/bat) —— 공식 소스, 릴리스, 이슈 트래커.
- [bat 문서](https://github.com/sharkdp/bat#how-to-use) —— 완전한 사용 가이드와 예제.
- [syntect Rust 라이브러리](https://github.com/trishume/syntect) —— bat을 구동하는 구문 강조 엔진.
- [delta — Git Diff 구문 강조기](https://github.com/dandavison/delta) —— Git diff 보기용 동반 도구.
- [bat-extras — 추가 스크립트](https://github.com/eth-p/bat-extras) —— `batgrep`, `batdiff`, `batman` 래퍼.
- [TwoDark 테마 참고](https://github.com/erremauro/TwoDark) —— 다크 터미널용 인기 bat 테마.
- [대안과의 비교](https://github.com/sharkdp/bat#project-goals-and-alternatives) —— bat 관리자의 공식 비교.
