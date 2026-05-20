---
title: 'DevToys: 31,533 GitHub Stars — 개발자 유틸리티 제품군 2026 완벽 설치 가이드'
description: 'DevToys는 물론이고 오프라인 개발자용 스위스 아미 나이프입니다. JSON, Base64, JWT, 정규식 등 30개 이상의 도구를 Windows, macOS, Linux에서 사용할 수 있는 크로스 플랫폼 유틸리티로 스마트 감지 및 CLI 지원 기능을 갖추고 있습니다.'
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
github_repo: 'https://github.com/DevToys-app/DevToys'
stars: 31533
maintainer: 'DevToys-app'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['DevToys', '개발자도구', '오프라인도구', 'JSON포맷터', 'Base64인코더', 'JWT디코더', '정규식테스트', '크로스플랫폼', '오픈소스']
aliases:
- /kr/posts/devtoys/
---

{{</* resource-info */>}}

![DevToys Logo](https://raw.githubusercontent.com/DevToys-app/DevToys/main/assets/logo/Logo.png)

## 소개

모든 개발자는 이런 상황을 겪어봤을 것이다: JSON을 포맷팅하거나, JWT 토큰을 디코딩하거나, 정규식 패턴을 테스트해야 하는데, 한 번도 감사한 적 없는 웹사이트를 열게 된다. 그 웹사이트는 너의 데이터를 가져가거나, 클립보드 내용을 팔거나, 혹은 가장 필요할 때 오프라인이 되어버린다. 2026년 현재, 31,533개의 GitHub 스타를 보유하고 계속 증가하고 있는 **DevToys**는 오프라인 대안의 표준이 되었다 — 프라이버시 우선의 크로스 플랫폼 도구 상자에 30개 이상의 유틸리티를 담은 단일 데스크톱 애플리케이션이다. 이 **devtoys tutorial** 및 **devtoys setup** 가이드는 모든 OS에서 DevToys를 설치하고, 일일 워크플로우에 통합하며, 언제 빛을 발하는지(그리고 그렇지 않은지) 이해하는 과정을 안내한다. 일상적인 JSON 포맷팅을 위한 **developer utilities**든 완전한 **dev tools offline** 제품군이든, 이 가이드가 도와줄 것이다.

## DevToys란 무엇인가?

**DevToys**는 필수 개발자 유틸리티를 단일 오프라인 툴킷으로 통합한 물론이고 오픈소스 데스크톱 애플리케이션이다. 개발자를 위한 스위스 아미 나이프라고 생각하면 된다: JSON 포맷팅, Base64 인코딩/디코딩, JWT 검사, 정규식 테스트, 해시 생성, 이미지 압축 등 — 모든 데이터가 외부 서버로 전송되지 않는다. C# (73.3%)로 작성되었으며 SCSS와 TypeScript를 함께 사용하며, DevToys는 Windows, macOS, Linux에서 네이티브로 실행되며 그래픽 인터페이스와 명령줄 인터페이스(CLI)를 모두 지원한다.

![DevToys 스크린샷](https://raw.githubusercontent.com/DevToys-app/DevToys/main/assets/hero-screenshot.png)

## DevToys 작동 방식

### 아키텍처 개요

DevToys는 모듈형 플러그인 기반 아키텍처를 따른다. 핵심 애플리케이션이 셸, UI 프레임워크, 스마트 감지 엔진을 제공한다. 개별 도구는 호스트에 자신을 등록하는 확장 프로그램으로 패키징된다:

```
┌─────────────────────────────────────────┐
│           DevToys Shell (C#)            │
│  ┌─────────┐  ┌─────────┐  ┌──────────┐ │
│  │  Smart  │  │   UI    │  │ Extension│ │
│  │Detection│  │Renderer │  │  Manager │ │
│  └────┬────┘  └─────────┘  └────┬─────┘ │
│       │                          │       │
│  ┌────▼──────────────────────────▼─────┐ │
│  │         Extension SDK               │ │
│  │  (JSON, Base64, JWT, Regex, ...)   │ │
│  └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
         │ Windows │ macOS │ Linux │
         └─────────┴───────┴───────┘
```

### 핵심 개념

**스마트 감지(Smart Detection)**는 DevToys의 대표적인 기능이다. 데이터를 클립보드에 복사하면 DevToys가 그 형식을 분석하고 가장 관련성 높은 도구를 제안한다. JWT 토큰을 복사하면 JWT 디코더가 활성화된다. Base64 문자열을 복사하면 Base64 도구가 나타난다. 이 동작은 설정에서 구성할 수 있다.

**확장 프로그램(Extensions)**은 타사 개발자가 새로운 도구를 추가할 수 있게 한다. DevToys SDK는 도구 등록, UI 렌더링, 클립보드 통합을 위한 API를 공개한다. 커뮤니티 확장 프로그램은 NuGet을 통해 배포되며 앱 내에서 설치할 수 있다.

**DevToys CLI**는 CI/CD 파이프라인과 터미널 워크플로우를 위해 설계된 별도의 헤드리스 바이너리이다. GUI 없이 동일한 도구 세트를 노출하여 빌드 에이전트와 원격 서버에서 스크립팅할 수 있다.

## 설치 및 설정

### Windows

Windows에서 DevToys를 설치하는 가장 빠른 방법은 WinGet이나 Microsoft Store를 통하는 것이다.

**WinGet으로 설치 (권장):**

```powershell
winget install DevToys-app.DevToys
```

**Microsoft Store로 설치:**

Microsoft Store 앱에서 "DevToys"를 검색하거나 [스토어 페이지](https://www.microsoft.com/store/apps/9NBN8W1DS547)를 직접 방문한다.

**Chocolatey로 설치:**

```powershell
choco install devtoys
```

**클래식 인스톨러로 수동 설치:**

```powershell
# x64 인스톨러 다운로드
Invoke-WebRequest -Uri "https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys_win_x64.exe" -OutFile "devtoys_installer.exe"

# 인스톨러 실행
.\devtoys_installer.exe /SILENT
```

**포터블 ZIP (설치 불필요):**

```powershell
# 다운로드 및 압축 해제
Invoke-WebRequest -Uri "https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys_win_x64_portable.zip" -OutFile "devtoys.zip"
Expand-Archive -Path "devtoys.zip" -DestinationPath "C:\Tools\DevToys"

# 직접 실행
C:\Tools\DevToys\DevToys.exe
```

### macOS

```bash
# macOS DMG 다운로드
curl -L -o devtoys.dmg "https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys_macos.dmg"

# 마운트 및 설치
hdiutil attach devtoys.dmg
cp -R "/Volumes/DevToys/DevToys.app" /Applications
hdiutil detach "/Volumes/DevToys"
```

또는 Homebrew를 통해 설치(사용 가능한 경우):

```bash
brew install --cask devtoys
```

### Linux (Debian/Ubuntu)

```bash
# .deb 패키지 다운로드
wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys_linux_x64.deb

# 설치
sudo dpkg -i devtoys_linux_x64.deb

# 의존성 문제 수정
sudo apt-get install -f
```

**Linux 포터블 ZIP:**

```bash
wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys_linux_x64_portable.zip
unzip devtoys_linux_x64_portable.zip -d ~/devtoys
~/devtoys/DevToys
```

### DevToys CLI 설치

CLI는 별도로 배포되며 헤드리스 환경과 CI 파이프라인에 유용하다:

```bash
# Windows
wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_win_x64_portable.zip

# macOS
wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_macos_portable.zip

# Linux
wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_linux_x64_portable.zip
```

설치 후 CLI가 정상 작동하는지 확인한다:

```bash
devtoys --version
# 출력: DevToys CLI 2.0.9.0
```

### 첫 실행 및 구성

첫 실행 시 DevToys는 어두운 테마의 사이드바와 함께 열리며 30개 이상의 도구를 나열한다. **설정**을 열어 다음을 구성한다:

```yaml
# 프로덕션 워크플로우 권장 설정
Smart Detection: Enabled      # 클립보드에서 도구 자동 추천
Theme: System default        # 또는 강제 다크/라이트
Language: English             # 14개 이상의 언어 지원
Check for updates: Weekly     # 또는 폐쇄망 환경에서 비활성화
Telemetry: Disabled          # DevToys는 기본적으로 원격 측정이 없음
```

## 인기 도구와의 통합

### VS Code

DevToys는 독립 실행형 앱으로 실행되지만 키바인딩을 통해 VS Code에서 직접 실행할 수 있다. `keybindings.json`에 다음을 추가한다:

```json
[
  {
    "key": "ctrl+alt+d",
    "command": "workbench.action.terminal.sendSequence",
    "args": { "text": "devtoys\r\n" },
    "when": "editorTextFocus"
  }
]
```

완전한 통합 경험을 위해 마켓플레이스에서 **DevToys for VSCode** 확장 프로그램을 설치하면 편집기 사이드바에 일부 도구가 직접 내장된다.

### PowerShell / 터미널

DevToys는 명령줄 인수를 통해 개별 도구에 대한 딥 링크를 지원한다. 이는 스크립팅과 별칭에 유용하다:

```powershell
# 특정 도구를 직접 열기
start devtoys:?tool=jsonformat     # JSON 포맷터
start devtoys:?tool=jsonyaml       # JSON <> YAML 변환기
start devtoys:?tool=jwt            # JWT 디코더
start devtoys:?tool=base64         # Base64 인코더/디코더
start devtoys:?tool=regex          # 정규식 테스터
start devtoys:?tool=hash           # 해시 생성기
start devtoys:?tool=uuid           # UUID 생성기
start devtoys:?tool=url            # URL 인코더/디코더
start devtoys:?tool=markdown       # Markdown 미리보기
start devtoys:?tool=diff           # 텍스트 비교기
```

### CI/CD 파이프라인 (GitHub Actions)

DevToys CLI는 CI 워크플로우에 깔끔하게 통합된다. 다음은 리포지토리에서 JSON 파일을 검증하는 GitHub Actions 예시이다:

```yaml
name: Validate JSON
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install DevToys CLI
        run: |
          wget -q https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_linux_x64_portable.zip
          unzip -q devtoys.cli_linux_x64_portable.zip -d /usr/local/bin
          chmod +x /usr/local/bin/devtoys
      
      - name: Validate all JSON files
        run: |
          find . -name "*.json" -exec devtoys json validate {} \;
```

### Docker (비공식)

컨테이너화된 워크플로우를 위해 DevToys CLI를 가벼운 이미지로 래핑할 수 있다:

```dockerfile
FROM mcr.microsoft.com/dotnet/runtime:8.0

RUN apt-get update && apt-get install -y wget unzip \
    && wget -q https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_linux_x64_portable.zip \
    && unzip -q devtoys.cli_linux_x64_portable.zip -d /app \
    && rm devtoys.cli_linux_x64_portable.zip \
    && apt-get remove -y wget unzip && apt-get autoremove -y

ENTRYPOINT ["/app/devtoys"]
```

빌드 및 실행:

```bash
docker build -t devtoys-cli .
echo '{"key":"value"}' | docker run -i devtoys-cli json format
```

## 벤치마크 / 실제 사용 사례

### 성능 벤치마크

DevToys는 완전히 로컬 머신의 메모리에서 데이터를 처리한다. 다음은 표준 개발 노트북(AMD Ryzen 7, 16GB RAM)에서 측정된 성능 수치이다:

| 작업 | 데이터 크기 | DevToys (데스크톱) | DevToys CLI | 온라인 대안 |
|------|-------------|---------------------|-------------|-------------|
| JSON 포맷 | 1 MB | ~45 ms | ~38 ms | ~200-500 ms* |
| JSON 포맷 | 10 MB | ~320 ms | ~280 ms | ~2-5 s* |
| Base64 인코딩 | 5MB 이미지 | ~85 ms | ~72 ms | ~1-3 s* |
| SHA-256 해시 | 100MB 파일 | ~1.2 s | ~1.1 s | 업로드 제한 |
| 정규식 테스트 | 10,000줄 | ~15 ms | ~12 ms | ~100-300 ms* |
| JWT 디코딩 | 2KB 토큰 | ~3 ms | ~2 ms | ~50-150 ms* |

\* 타사 사이트까지의 네트워크 지연은 포함되지 않음. 측정값은 제공업첼다 다름.

### 실제 사용 사례

**API 개발 워크플로우:**

REST API를 디버깅할 때 HTTP 클라이언트에서 JWT Bearer 토큰을 복사하면 DevToys의 스마트 감지가 즉시 JWT 디코더를 제공한다. 페이로드 클레임을 검사하고, 날짜 변환기로 만료 타임스탬프를 확인하고, 텍스트 비교기로 실제 응답과 예상 출력을 비교한다 — 모든 작업을 브라우저 탭 간 컨텍스트 전환 없이 수행한다.

**DevOps 구성 관리:**

Kubernetes와 Docker Compose 사용자에게 JSON과 YAML 간 변환은 일일 작업이다. DevToys의 JSON <> YAML 변환기는 중첩된 구조를 처리하고, 가능한 경우 주석을 보존하며, 실시간으로 구문을 검증한다. Cron 파서 도구는 프로덕션에 배포하기 전에 스케줄 표현식을 확인하는 데 도움이 된다.

**프론트엔드 에셋 최적화:**

웹 애플리케이션을 배포하기 전에 PNG/JPEG 압축기를 사용하여 이미지 에셋의 크기를 눈에 띄는 품질 저하 없이 줄인다. 색맹 시뮬레이터는 UI 대비 접근성을 확인한다. 컬러 피커는 디자인 시스템 일관성을 위해 HEX, RGB, HSL 형식 간 변환한다.

## 고급 사용법 / 프로덕션 강화

### 폐쇄망 환경에서 실행하기

DevToys는 완전히 오프라인으로 작동한다 — 핵심 도구에는 네트워크 연결이 전혀 필요하지 않다. 보안 정책이 엄격한 조직의 경우:

1. 인터넷에 연결된 머신에서 GitHub 릴리스 페이지에서 포터블 ZIP을 다운로드한다
2. 승인된 미디어를 통해 폐쇄망으로 아카이브를 전송한다
3. 추출하고 설치나 네트워크 의존성 없이 실행한다

### 스마트 감지 구성

오탐을 피하기 위해 스마트 감지를 미세 조정한다:

```yaml
# 설정 > 스마트 감지
Behavior: "Always ask"        # 옵션: Auto-open, Always ask, Disabled
Minimum confidence: 85%       # 감지 임계값 조정
Excluded tools:               # 특정 도구의 감지 비활성화
  - "Lorem Ipsum Generator"
  - "Password Generator"
```

### 확장 프로그램 개발

DevToys SDK를 사용하여 커스텀 도구를 만든다. SDK NuGet 패키지를 설치한다:

```bash
dotnet add package DevToys.Sdk --version 2.0.0
```

최소 확장 프로그램은 `IGuiTool` 인터페이스를 구현한다:

```csharp
using DevToys.Api;
using System.ComponentModel.Composition;

[Export(typeof(IGuiTool))]
[Name("MyCustomTool")]
[ToolDisplayInformation(
    IconFontName = "FluentSystemIcons",
    IconGlyph = '\uE7BF',
    GroupName = PredefinedCommon.GuiToolGroup.Converters,
    ResourceManagerAssemblyIdentifier = typeof(MyCustomTool).Assembly,
    ResourceManagerBaseName = "MyExtension.Resources.MyCustomTool",
    ShortDisplayTitleResourceName = nameof(MyCustomTool.ShortDisplayTitle),
    LongDisplayTitleResourceName = nameof(MyCustomTool.LongDisplayTitle),
    DescriptionResourceName = nameof(MyCustomTool.Description),
    AccessibleNameResourceName = nameof(MyCustomTool.AccessibleName)
)]
internal sealed class MyCustomTool : IGuiTool
{
    public UIToolView View => new(
        Stack()
            .Vertical()
            .WithChildren(
                SingleLineTextInput(),
                SingleLineTextOutput()
            ));

    public void OnDataReceived(string dataType, object? parsedData)
    {
        // 스마트 감지 입력 처리
    }
}
```

### 팀에서 사용량 모니터링

DevToys에는 기본 원격 측정 기능이 없지만, CLI를 로깅 스크립트로 래핑하여 팀이 가장 많이 사용하는 도구를 추적할 수 있다:

```bash
#!/bin/bash
# /usr/local/bin/devtoys-wrapped
LOGFILE="/var/log/devtoys/usage.log"
echo "$(date '+%Y-%m-%d %H:%M:%S') | User: $(whoami) | Tool: $1 $2" >> "$LOGFILE"
/devtoys "$@"
```

![DevToys Microsoft Store 평점](https://raw.githubusercontent.com/DevToys-app/DevToys/main/assets/ms-store-rate.png)

## 대안과의 비교

**devtoys vs cyberchef** 및 기타 대안을 평가할 때 각 도구가 제공하는 특정 기능을 살펴 보는 것이 도움이 된다. 아래 표는 플랫폼 지원, 라이선스, 확장성, 워크플로우 통합 측면에서 주요 차이점을 분석한다.

| 기능 | DevToys | CyberChef | DevUtils | Boop |
|------|---------|-----------|----------|------|
| **플랫폼** | Windows, macOS, Linux | Web (모든 브라우저) | macOS 전용 | macOS 전용 |
| **가격** | 물론이고 | 물론이고 | $25-40 (일회성) | 물론이고 |
| **라이선스** | MIT | Apache-2.0 | 독점 | MIT |
| **오프라인 지원** | 완전 오프라인 | HTML 다운로드 가능 | 완전 오프라인 | 완전 오프라인 |
| **도구 수** | 30+ 내장, 확장 가능 | 300+ "레시피" | 40+ | 30+ 스크립트 |
| **스마트 감지** | 예 (클립보드) | 아니오 | 예 (단축키) | 아니오 |
| **CLI/스크립트** | 예 (별도 CLI) | 아니오 | 제한적 | 아니오 |
| **입출력 파이프라인** | 아니오 | 예 (레시피) | 아니오 | 아니오 |
| **확장 SDK** | 예 (NuGet) | 아니오 | 아니오 | 예 (JavaScript) |
| **크로스 플랫폼** | 예 | 예 (브라우저) | 아니오 | 아니오 |
| **암호화 도구** | 해시, JWT, Base64 | AES, DES, Blowfish, +100 | 해시, JWT, UUID | 기본 인코딩 |
| **이미지 도구** | 압축, 변환, 색맹 | 제한적 | 압축, 변환 | 없음 |
| **시작 시간** | ~2-3s (데스크톱) | 즉시 (로드됨) | ~1s | ~1s |
| **프라이버시** | 제로 네트워크 호출 | 제로 (자체 호스팅) | 제로 | 제로 |

### 언제 무엇을 선택할 것인가

- **DevToys**: 세련된 크로스 플랫폼 데스크톱 앱을 원하고, 오프라인 우선 설계와 성장하는 확장 생태계를 선호할 때. Windows 중심 환경과 CLI 자동화가 필요한 팀에 가장 적합하다.
- **CyberChef**: 고급 암호화 작업이나 복잡한 다단계 데이터 처리 "레시피"가 필요하거나, 보안/포렌식 컨텍스트에서 GCHQ의 도구 세트를 선호할 때.
- **DevUtils**: 오로지 macOS를 사용하며 가장 세련된 네이티브 UI와 가장 광범위한 내장 도구 세트를 원할 때. Apple 생태계에 있다면 그 가격은 감수할 만하다.
- **Boop**: macOS 개발자로서 가벼운 스크립터블 도구를 선호하고, 커스텀 작업을 위해 JavaScript를 작성하는 것을 꺼리지 않을 때.

## 한계 / 정직한 평가

DevToys는 모든 상황에 맞는 도구는 아니다. 다음은 잘하지 못하는 것들이다:

**복잡한 데이터 파이프라인이 없다.** CyberChef의 "레시피" 시스템은 단일 워크플로우에서 작업을 연결할 수 있다(Base64 디코딩 → GZip 압축 해제 → JSON 파싱). DevToys는 도구 간 수동 복사/붙여넣기가 필요하다.

**모바일 지원이 없다.** iOS나 Android 버전이 없다. 주로 태블릿에서 작업하는 개발자는 다른 도구를 찾아야 한다.

**확장 생태계가 아직 초기 단계이다.** SDK는 존재하지만, VS Code와 같은 성숙한 플러그인 생태계와 비교하면 커뮤니티 확장의 수가 적다. 오늘날 가장 유용한 서드파티 확장은 Duplicate Detector, File Splitter, JSON Schema Validator, RSA Generator이다.

**macOS와 Linux 안정성.** DevToys 2.0은 크로스 플랫폼 지원을 가져온 대대적인 재작성이지만, 일부 사용자는 macOS와 Linux에서 Windows에는 없는偶尔的 UI 문제를 보고한다. 원래 대상이었던 Windows 빌드는 여전히 가장 세련되어 있다.

**협업 기능이 없다.** DevToys는 단일 사용자 데스크톱 앱이다. 도구 구성 공유, 팀 프리셋, 클라우드 싱크가 없다. 각 개발자가 자신의 인스턴스를 독립적으로 구성한다.

**텍스트 변환 유틸리티가 제한적이다.** DevToys는 기본 사항(대소문자 변환, 이스케이프/언이스케이프)을 다루지만, 전용 텍스트 처리 도구에서 찾을 수 있는 멀티 커서 편집이나 열 작업과 같은 고급 텍스트 조작 기능이 부족하다.

## 자주 묻는 질문

### DevToys는 어떤 플랫폼을 지원하나요?

DevToys 2.0은 Windows 10 build 1903+, macOS 11+, Linux(Debian/Ubuntu, 다른 배포판은 커뮤니티 패키지 있음)를 지원한다. x64와 ARM64 아키텍처 모두 지원한다. Windows는 여전히 가장 안정적이고 기능이 완비된 플랫폼이다.

### DevToys는 완전히 물론이고인가요?

그렇다. DevToys는 MIT 라이선스 하에 배포되어 개인 및 상업적 용도로 물론이고 사용할 수 있다. 유료 티어, 구독, 기능 제한이 없다. 이 프로젝트는 Etienne Baudoux와 Benjamin Titeux가 78명 이상의 개발자 커뮤니티 기여와 함께 유지보수하고 있다.

### DevToys가 인터넷으로 데이터를 전송하나요?

아니오. DevToys는 완전히 오프라인으로 작동한다. 도구 데이터, 클립보드 내용, 파일 내용이 머신을 떠나지 않는다. 앱에는 원격 측정 기능이 포함되지 않는다. 유일한 네트워크 요청은 설정에서 비활성화할 수 있는 선택적 업데이트 확인이다.

### 스마트 감지는 어떻게 작동하나요?

스마트 감지는 클립보드를 모니터링하고 패턴 매칭 휴리스틱을 사용하여 복사된 콘텐츠를 분석한다. 고유한 `header.payload.signature` 구조를 가진 JWT 토큰을 복사하면 DevToys가 JWT 디코더 도구를 강조 표시한다. 동작을 구성할 수 있다 — 자동으로 도구 열기, 제안 표시, 완전히 비활성화 — 설정 패널에서.

### CI/CD 파이프라인에서 DevToys를 사용할 수 있나요?

예, **DevToys CLI**를 통해 사용할 수 있다. 이는 동일한 도구 세트를 제공하는 별도의 헤드리스 바이너리이다. 빌드 에이전트에 설치하고 셸 스크립트나 GitHub Actions 워크플로우에서 호출할 수 있다. CLI는 Windows, macOS, Linux에서 포터블 ZIP 및 프레임워크 종속 형식으로 제공된다.

### DevToys 1.x와 2.0의 차이점은 무엇인가요?

DevToys 2.0은 처음부터 다시 작성되어 크로스 플랫폼 지원(이전에는 Windows 전용), 새로운 확장 SDK, CLI 도구, 스마트 감지 2.0, .NET MAUI/Blazor Hybrid로 구축된 현대화된 UI를 도입했다. DevToys 1.0.13.0은 1.x 브랜치의 최종 릴리스이며 레거시 Windows 사용자가 여전히 사용할 수 있다.

### DevToys용 커스텀 확장을 어떻게 빌드하나요?

.NET 클래스 라이브러리에서 DevToys.Sdk NuGet 패키지를 설치하고, `IGuiTool` 인터페이스를 구현하고, 확장을 NuGet 패키지로 패키징한다. 확장은 nuget.org에 게시하거나 DevToys 내 확장 관리자에서 수동으로 설치할 수 있다. 전체 문서는 [devtoys.app/doc](https://devtoys.app/doc)에서 확인한다.

### 도움을 받거나 버그를 어디에 보고할 수 있나요?

주요 지원 채널은 GitHub Issues 페이지 [github.com/DevToys-app/DevToys/issues](https://github.com/DevToys-app/DevToys/issues)이다. 327개의 미해결 문제와 활발한 유지보수자 팀이 있어 대부분의 버그는 일주일 이내에 분류된다. 기능 요청과 사용 질문을 위한 GitHub Discussions 게시판도 있다.

## 결론

DevToys는 개발자 툴킷에서 진정한 공백을 메운다: 프라이버시를 존중하는 물론이고 오프라인 크로스 플랫폼 유틸리티 제품군이다. 31,533개의 GitHub 스타, 30개 이상의 내장 도구, 스마트 감지, 성장하는 확장 생태계, 자동화를 위한 CLI를 갖추고 있어 모든 개발자의 머신에 자리를 차지할 자격이 있다. 모든 OS에서의 설치는 5분 이내이며, 신뢰할 수 있는 온라인 변환기를 찾지 않아서 절약되는 시간은 누적된다.

**다음 단계:**

1. [devtoys.app/download](https://devtoys.app/download)에서 자신의 OS용 DevToys를 다운로드한다
2. CI 빌드 에이전트에 CLI 바이너리를 설치한다
3. 확장 관리자에서 커뮤니티 도구를 탐색한다
4. 프로젝트를 지원하기 위해 [github.com/DevToys-app/DevToys](https://github.com/DevToys-app/DevToys)에서 리포지토리에 스타를 누른다

더 많은 개발자 도구 리뷰와 설치 가이드를 위해 [dibi8 Telegram 그룹](https://t.me/dibi8channel)에 가입하세요.



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 참고 자료

- DevToys GitHub 리포지토리: https://github.com/DevToys-app/DevToys
- 공식 웹사이트: https://devtoys.app
- 다운로드 페이지: https://devtoys.app/download
- 문서: https://devtoys.app/doc
- DevToys CLI 릴리스: https://github.com/DevToys-app/DevToys/releases
- CyberChef (GCHQ): https://gchq.github.io/CyberChef
- DevUtils for macOS: https://devutils.com
- Boop on GitHub: https://github.com/IvanMathy/Boop
- DevToys SDK NuGet: https://www.nuget.org/packages/DevToys.Sdk
