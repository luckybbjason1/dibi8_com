---
title: "RTK (rtk-ai/rtk): AI 코딩의 90% Token 비용 절감"
description: "RTK는 Rust로 작성된 CLI 프록시로, 에이전트가 터미널 출력을 읽을 때 token 소비를 60-90% 줄입니다. 100+ 명령 지원, <10ms 지연. 81K GitHub stars 획득."
date: 2026-09-22
lastmod: 2026-09-22
tags: [github, rtk, token-optimization, claude-code, cost-reduction]
category: github-tools
image: https://raw.githubusercontent.com/rtk-ai/rtk/main/assets/hero.png
related_posts:
  - /ko/ecc-agent-harness
  - /ko/mattpocock-skills
  - /ko/rag-systems-2026
toc: true
---

## Token 비용 문제

AI 코딩 에이전트(Claude Code, Codex, Cursor)를 사용할 때 입력 token마다 비용을 지불합니다. `git log`나 `ls -la` 같은 명령은 수천 줄을 출력할 수 있으며, 각 줄이 비용입니다.

**RTK가 이 문제를 해결합니다.**

![RTK Hero](https://raw.githubusercontent.com/rtk-ai/rtk/main/assets/hero.png)

> **요약:** RTK는 CLI 출력을 LLM에 보내기 전에 필터링하고 압축합니다. 60-90% token 사용 감소, 중요한 정보 손실 없이.

## RTK 작동 방식

### 작동 메커니즘
```
실행: git status
↓
RTK가 인터셉트하고 필터링
↓
에이전트는 압축된 버전 받음 (90% 작음)
↓
비용 감소, 컨텍스트 창 보존
```

### 지원 명령 (100+)

**Git 작업:**
- `rtk git status`, `rtk git log`, `rtk git diff`
- `rtk gh pr list`, `rtk gh issue view`

**파일 작업:**
- `rtk find`, `rtk grep`, `rtk rg`
- `rtk cat`, `rtk head`, `rtk tail`

**패키지 관리:**
- `rtk npm list`, `rtk yarn why`
- `rtk cargo tree`, `rtk pip list`

**프로세스 모니터링:**
- `rtk ps`, `rtk top`, `rtk docker ps`

## 설치

### macOS/Linux (Homebrew - 추천)
```bash
brew install rtk
rtk init -g  # Claude Code/Copilot용 글로벌 훅
```

### Windows (winget)
```powershell
winget install rtk-ai.rtk
rtk init -g
```

### Cargo로
```bash
cargo install --git https://github.com/rtk-ai/rtk
rtk init -g
```

### 사전 구축된 바이너리

[releases에서 다운로드](https://github.com/rtk-ai/rtk/releases)

## 에이전트와 통합

### Claude Code / GitHub Copilot
```bash
rtk init -g
# bash에 자동으로 훅
```

### Gemini CLI
```bash
rtk init -g --gemini
```

### Codex (OpenAI)
```bash
rtk init -g --codex
```

### Cursor / Windsurf
```bash
rtk init -g --agent cursor
rtk init -g --agent windsurf
```

### Hermes
```bash
rtk init -g --agent hermes
```

## 벤치마크 결과

[rtk-ai.app/benchmarks](https://www.rtk-ai.app/benchmarks)에 따르면:

| 지표 | RTK 없음 | RTK 있음 | 절약 |
|------|----------|----------|------|
| 평균 token 사용 | 100% | 10-40% | **60-90%** |
| 세션당 비용 | $1.00 | $0.10-$0.40 | **60-90%** |
| 컨텍스트 창 사용 | 100% | 15-50% | **50-85%** |

### 실제 사례

작업: 500줄 변경된 PR 검토
- RTK 없음: 에이전트가 전체 `git diff` 읽음 → ~15,000 tokens
- RTK 있음: RTK가 중요 변경만 필터링 → ~2,500 tokens
- **절약: 12,500 tokens (~$0.05)**

## 왜 사용해야 하나요?

1. **비용을 크게 줄임** — 60-90% token 절약
2. **속도 향상** — 더 작은 출력 = 더 빠른 처리
3. **컨텍스트 보존** — token 제한을 넘지 않음
4. **제로 구성** — 설치하면 작동
5. **크로스 플랫폼** — macOS, Linux, Windows
6. **오픈 소스** — Apache 2.0 라이선스

## 대안과 비교

| 도구 | 가격 | Token 절약 | 복잡도 |
|------|------|-----------|--------|
| RTK | 무료 | 60-90% | 낮음 |
| Caveman | 무료 | ~30% | 중간 |
| Ponytail | 무료 | ~54% 코드 | 낮음 |
| 수동 필터 | 무료 | 가변 | 높음 |

## 중요 참고사항

> ⚠️ **RTK는 당신의.bill을 90% 줄이지 않습니다** — 그것은 출력 tokens를 90% 줄입니다. 프롬프트, 시스템 프롬프트, 대화 기록에서 오는 입력 tokens는 여전히 전체 계산됩니다.

그러나 입력 tokens는 일반적으로 총 비용의 대부분을 차지하므로, 실제 절약 vẫn 매우 큽니다.

## 결론

RTK는 AI 코딩 에이전트를 자주 사용하는 개발자의 **필수 도구**입니다. 1분 설치, 월간 시간과 수십 달러 절약.

**링크:** [github.com/rtk-ai/rtk](https://github.com/rtk-ai/rtk)
**웹사이트:** [rtk-ai.app](https://www.rtk-ai.app)
