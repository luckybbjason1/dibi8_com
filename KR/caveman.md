---
title: "Claude Code 토큰 비용 65% 절감: Caveman 스킬 완벽 가이드"
description: "GitHub 57K Star Claude Code 스킬 Caveman으로 AI 코딩 비용 절반 이상 줄이는 방법. 설치, 사용법, 벤치마크, MCP 미들웨어까지 상세 정리."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Docker
  - Go
  - JavaScript
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "2.4 MB"
file_md5: ""
download_url: ""
backup_url: ""
github_repo: ""
stars: 61775
maintainer: "JuliusBrussee"
last_maintained: "2026-05-12"
featureImage: ""
draft: false
aliases:
- /kr/posts/caveman/
faqs:
  - q: 'Claude Code용 Caveman은 무엇인가요?'
    a: 'Caveman은 Claude가 불필요한 표현, 관사, 정중한 서두를 생략하고 압축된 원시인 스타일의 간결한 언어로 응답하도록 만드는 Claude Code 스킬입니다. 기술적 정확성을 그대로 유지하면서 평균 65%의 출력 토큰을 줄여줍니다.'
  - q: 'Caveman은 토큰 사용량을 얼마나 줄여주나요?'
    a: '저장소에 포함된 재현 가능한 벤치마크 기준으로, Caveman은 평균 65%의 출력 토큰을 절감했으며, 원래 작업이 얼마나 장황했느냐에 따라 22%에서 87%까지 다양합니다. 예를 들어 React 리렌더 버그 설명은 1,180 토큰에서 159 토큰으로 줄었습니다(87% 절감).'
  - q: 'Caveman을 사용하면 Claude가 덜 정확해지거나 ''멍청해지나요''?'
    a: '아닙니다. Caveman은 모델의 사고 및 추론 토큰에는 전혀 손대지 않고 최종 출력 텍스트만 압축합니다. 모델은 여전히 최대 역량으로 추론하며, 모든 기술 내용은 그대로 보존되고 불필요한 말만 제거됩니다.'
  - q: 'Claude Code에 Caveman을 어떻게 설치하나요?'
    a: '''git clone https://github.com/JuliusBrussee/caveman.git ~/.claude/skills/caveman'' 명령으로 저장소를 글로벌 스킬 디렉터리에 클론한 뒤 Claude Code를 재시작하면 스킬이 자동으로 로드됩니다. Cursor, Cline, Windsurf, Codex도 각각의 규칙 파일을 통해 지원됩니다.'
  - q: 'Caveman이 제공하는 강도 레벨과 명령어는 무엇인가요?'
    a: 'Caveman에는 세 가지 레벨이 있습니다: Lite(불필요한 표현 제거, 문법 유지), Full(기본 모드, 관사 생략 및 단편 문장 사용), Ultra(최대 전보식 압축). 또한 /caveman-commit, /caveman-review, /caveman-stats, 그리고 CLAUDE.md 같은 메모리 파일을 재작성하는 /caveman:compress 같은 서브 커맨드도 제공합니다.'
---
{</* resource-info */>}

# Claude Code 토큰 비용 65% 절감: Caveman 스킬 완벽 가이드

> 🪨 "왜 많은 토큰 쓰나? 적은 토큰으로도 됨"  
> — GitHub 57,003 Star, Claude Code 공식 스킬

AI 코딩 에이전트를 매일 쓰는 개발자라면 한 가지 고민이 있습니다. **토큰 비용**. Claude Code, Cursor, Windsurf, Cline… 도구는 좋은데 답변이 길어질수록 지갑이 얇아집니다. 오늘 소개할 **Caveman**은 이 문제를 단숨에 해결하는 Claude Code 스킬입니다. 설치는 1줄, 효과는 평균 **65% 토큰 절감**. 기술적 정확도는 그대로 유지하면서 말이죠.

---

## Caveman이란?

Caveman은 [JuliusBrussee](https://github.com/JuliusBrussee)가 만든 Claude Code 스킬로, AI의 출력 토큰을 **구석기인 말투**로 압축합니다. 문법을 과감히 생략하고, 관사(article)를 버리고, 핵심만 짚어 말하는 방식입니다. 이게 단순 개그가 아닙니다. 실제 벤치마크에서 평균 65%, 최대 87%의 토큰 절감을 기록했으며, 기술적 정확도는 100% 유지됩니다.

- **GitHub Stars**: 57,003
- **커밋 수**: 156+
- **지원 에이전트**: 30+ (Claude Code, Cursor, Windsurf, Cline, Copilot, Gemini CLI, Codex, Continue, Roo, Augment, Aider, Goose, Warp, Replit Agent 등)
- **공식 사이트**: [getcaveman.dev](https://getcaveman.dev/)

---

## 왜 Caveman을 써야 할까?

### 1. 비용 절감 (평균 65%)

출력 토큰이 줄면 API 비용이 그만큼 줄어듭니다. 벤치마크 결과는 놀랍습니다.

| 작업 | 일반 (토큰) | Caveman (토큰) | 절감률 |
|------|------------|---------------|--------|
| React 리렌더 버그 설명 | 1,180 | 159 | **87%** |
| Auth 미들웨어 토큰 만료 수정 | 704 | 121 | **83%** |
| PostgreSQL 커넥션 풀 설정 | 2,347 | 380 | **84%** |
| Git rebase vs merge 설명 | 702 | 292 | **58%** |
| Callback → async/await 리팩토링 | 387 | 301 | **22%** |
| 마이크로서비스 vs 모놀리식 설계 | 446 | 310 | **30%** |
| PR 보안 이슈 리뷰 | 678 | 398 | **41%** |
| Docker 멀티스테이지 빌드 | 1,042 | 290 | **72%** |
| PostgreSQL 레이스 컨디션 디버깅 | 1,200 | 232 | **81%** |
| React Error Boundary 구현 | 3,454 | 456 | **87%** |
| **평균** | **1,214** | **294** | **65%** |

*범위: 22%~87% 절감. Caveman은 출력 토큰만 줄입니다. 사고/추론 토큰은 건드리지 않습니다.*

### 2. 응답 속도 ~3배 향상

생성할 토큰이 적어지니 응답 속도가 획기적으로 빨라집니다. 긴 기술 문서 설명도 순식간에 끝납니다.

### 3. 가독성 상승

"장황한 답변의 벽" 대신 핵심만 콕콕 짚어주는 스타일. 오히려 읽기 쉽고, 기억에도 잘 남습니다.

### 4. 정확도 유지 — 심지어 개선

2026년 3월 논문 ["Brevity Constraints Reverse Performance Hierarchies in Language Models"](https://arxiv.org/abs/2604.00025)에 따르면, 대형 모델에게 간결한 응답을 강제하면 **정확도가 26%p 향상**되고 성능 순위가 완전히 뒤집힌다고 합니다. 장황함이 항상 정답은 아닙니다.

### 5. 재미

코드 리뷰가 코미디가 됩니다. 매일 쓰는 도구가 지루하지 않다는 건 큰 장점입니다.

---

## 설치 방법 (1줄)

Caveman은 30개 이상의 AI 에이전트를 자동 감지하고, 각자의 네이티브 방식으로 설치합니다. 없는 에이전트는 스킵하고, 재실행해도 안전합니다.

### macOS / Linux / WSL / Git Bash

```bash
curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.ps1 | iex
```

### 설치 옵션

| 플래그 | 설명 |
|--------|------|
| `--all` | 플러그인 + 후크 + 상태줄 + MCP shrink + 현재 디렉토리 규칙 파일. 풀 패키지. |
| `--minimal` | 플러그인/확장만. 후크, MCP shrink, 규칙 파일 제외. |
| `--dry-run` | 미리보기. 실제로 아무것도 쓰지 않음. |
| `--only <agent>` | 특정 에이전트만 설치 (반복 가능). |
| `--with-hooks` | Claude Code 단독 후크 + 상태줄 + 통계 배지 연결. 기본 ON. |
| `--with-mcp-shrink` | MCP shrink 미들웨어 등록. 기본 ON. |

---

## 사용법: 3단계 강도

Caveman은 상황에 따라 3단계 강도를 선택할 수 있습니다.

| 레벨 | 명령어 | 효과 |
|------|--------|------|
| **Lite** | `/caveman lite` | 필러 제거, 문법 유지. 프로페셔널하지만 장황함 없음. |
| **Full** | `/caveman full` | 기본 Caveman. 관사 제거, 단편문, 완전한 그런트 스타일. |
| **Ultra** | `/caveman ultra` | 최대 압축. 전보체. 모든 것을 축약. |

### Before / After 예시

**일반:**
> "In order to resolve the React re-rendering issue, you should consider memoizing the component using React.memo or implementing a custom comparison function with useMemo to prevent unnecessary re-renders when the props haven't actually changed."

**Caveman Full:**
> "React re-render bug. Fix: wrap in React.memo. Props same? No render. Done."

**Caveman Ultra:**
> "Rerender bug. React.memo. Props diff? Skip render."

같은 기술 정보. 토큰은 1/4~1/8.

---

## Caveman 스킬 모음

| 스킬 | 기능 |
|------|------|
| `/caveman-commit` | 간결한 커밋 메시지. Conventional Commits, 제목 50자 이내. |
| `/caveman-review` | 한 줄 PR 코멘트: `L42: 🔴 bug: user null. Add guard.` |
| `/caveman-help` | 빠른 참조 카드. 모든 모드, 스킬, 명령어. |
| `/caveman-stats` | 실제 세션 토큰 사용량 + 추정 절감액 + USD. `--all`로 누적, `--since 7d`로 기간 필터, `--share`로 트윗용 한 줄. |
| `/caveman:compress <file>` | 메모리 파일(예: `CLAUDE.md`)을 Caveman 말투로 재작성. 백업은 `<file>.original.md`. 세션 시작 시 입력 토큰 ~46% 절감. |

### Caveman Subagents (Claude Code 전용)

| 서브에이전트 | 역할 |
|-------------|------|
| `cavecrew-investigator` | 읽기 전용 로케이터. 하이쿠 스타일. |
| `cavecrew-builder` | 1~2개 파일 수술적 편집. 3개 이상 거부. |
| `cavecrew-reviewer` | 한 줄 발견 사항. 하이쿠. |

서브에이전트 출력은 메인 컨텍스트에 주입됩니다. 기본 Explore/리뷰어 에이전트보다 **~60% 적은 토큰**을 사용해 긴 세션에서 메인 컨텍스트를 오래 유지합니다.

### 상태줄 절감 배지

기본 ON. `/caveman-stats` 첫 실행 후 상태줄에 `[CAVEMAN] ⛏ 12.4k` (누적 절감 토큰)가 표시되고, 실행할 때마다 갱신됩니다. 끄려면 `CAVEMAN_STATUSLINE_SAVINGS=0`.

---

## caveman-shrink: MCP 미들웨어

Caveman은 MCP 서버를 감싸는 stdio 프록시 `caveman-shrink`도 제공합니다. `tools/list`, `prompts/list`, `resources/list` 응답의 `description` 필드를 압축합니다. 코드, URL, 경로, 식별자는 바이트 단위 그대로 유지.

```json
{
  "mcpServers": {
    "fs-shrunk": {
      "command": "npx",
      "args": ["caveman-shrink", "npx", "@modelcontextprotocol/server-filesystem", "/path/to/dir"]
    }
  }
}
```

npm 패키지: [`caveman-shrink`](https://www.npmjs.com/package/caveman-shrink). V1은 툴콜 응답 본문이나 요청 페이로드는 건드리지 않습니다. `install.sh`가 자동 등록합니다(`--minimal`로 스킵).

---

## 과학적 근거

2026년 3월 발표된 논문 **"Brevity Constraints Reverse Performance Hierarchies in Language Models"** (arXiv:2604.00025)는 다음을 입증했습니다:

- 간결한 응답 제약 시 특정 벤치마크에서 **정확도 26%p 향상**
- 성능 계층 구조가 완전히 역전됨
- 장황함 ≠ 정확함

Caveman은 이 원리를 실제 코딩 워크플로우에 적용한 도구입니다.

---

## 자주 묻는 질문 (FAQ)

**Q: Caveman은 생각/추론 토큰도 줄이나요?**  
A: 아닙니다. 출력 토큰만 줄입니다. AI의 "머리"는 그대로 두고 "입"만 작게 만듭니다.

**Q: 기술 정보가 손실되나요?**  
A: 벤치마크상 100% 정확도 유지. 코드, URL, 경로, 식별자는 바이트 단위 보존.

**Q: 한국어로도 작동하나요?**  
A: Claude Code 스킬은 언어에 구애받지 않습니다. Caveman의 "말투 규칙"은 한국어 출력에도 동일하게 적용되어 장황한 설명을 압축합니다.

**Q: 이미 설치한 에이전트에 덮어쓰기 되나요?**  
A: 안전하게 재실행 가능. 없는 에이전트는 스킵.

**Q: 팀 전체에 적용하려면?**  
A: `--all` 플래그로 저장소별 규칙 파일도 함께 배포. `.clinerules`, `.cursorrules` 등 자동 생성.

---

## 결론

Caveman은 단순한 "밈"이 아닙니다. **57K Star**를 받은 실전 도구이며, Claude Code 생태계에서 가장 효과적인 토큰 최적화 솔루션입니다. 1줄 설치로 평균 65% 비용 절감, ~3배 속도 향상, 오히려 개선되는 정확도까지.

AI 코딩 비용이 부담스럽다면, 오늘 바로 Caveman을 설치하세요.

```bash
curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash
```

더 알아보기: [github.com/JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) | [getcaveman.dev](https://getcaveman.dev/)

---

*본 게시물은 dibi8.com에서 2026년 5월 10일에 작성되었습니다.*

---

## 추천 도구

오픈소스 AI 도구 개발/배포 시 권장:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전, AI 워크로드용 원클릭 droplet.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API 프록시. 위의 AI 도구 대부분 (챗봇, 코드 생성, 번역, 검색 등) LLM API 키 필요 — 이 프록시로 안정적인 톱 모델 액세스, 공식 가격의 ~30%.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

