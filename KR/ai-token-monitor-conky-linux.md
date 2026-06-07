---
title: 'AI Token Monitor: Linux 데스크탑에서 Claude, Gemini, Grok, Kimi 쿼터 실시간 추적'
description: '오픈소스 Linux 데스크탑 위젯으로 Conky 안에서 AI 토큰 쿼터를 HP 바 스타일 진행 막대로 실시간 표시. Claude, Gemini, Grok, Kimi 실제 API 폴링 및 리셋 카운트다운 지원.'
date: 2026-06-06 00:00:00+08:00
lastmod: 2026-06-06 00:00:00+08:00
tech_stack: ['Python', 'Conky', 'Linux']
application_domain: Dev Utils
source_version: '1.0.0'
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'luckybbjason1/ai-token-monitor'
stars: 0
maintainer: 'luckybbjason1'
last_maintained: '2026-06-06'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['AI 토큰 모니터', 'Claude 쿼터', 'Gemini 쿼터 추적', 'Grok 토큰', 'Kimi API', 'Conky 위젯', 'Linux 데스크탑', '오픈소스', 'Python', '개발자 도구']
aliases:
- /kr/posts/ai-token-monitor-conky-linux/
faqs:
  - q: 'AI Token Monitor가 macOS나 Windows에서도 작동하나요?'
    a: '현재 위젯 표시 레이어는 Linux 전용 Conky에 의존합니다. 핵심 Python 스크립트(api_fetcher.py)는 어느 OS에서나 실행되지만, 시각적 렌더링은 Conky가 필요합니다. 저장소에 tkinter 기반 크로스 플랫폼 버전(monitor.py)이 있지만 GNOME에서 프레임 없는 창이 보이지 않을 수 있어 실험적입니다.'
  - q: 'Claude API 토큰 잔액을 어떻게 읽나요?'
    a: '/v1/messages에 max_tokens=1로 최소 POST 요청을 보내고 응답 헤더의 anthropic-ratelimit-tokens-remaining 및 anthropic-ratelimit-tokens-limit 값을 읽습니다. 체크당 약 10개 입력 토큰을 소비하며, 5분 cron 기준 하루 약 2,880 토큰으로 대부분 요금제에서 무시 가능한 수준입니다.'
  - q: 'API 키를 ~/.config/.ai_monitor_keys에 저장하는 게 안전한가요?'
    a: '파일은 chmod 600으로 생성되어 현재 사용자만 읽을 수 있습니다. .gitignore로 git에서 제외됩니다. .env 파일에 저장하는 것과 동일한 보안 수준으로 파일 시스템 권한에 의존합니다. 공유 머신이라면 gpg-agent나 시크릿 매니저로 암호화하는 것을 권장합니다.'
  - q: '목록에 없는 AI 서비스(예: Mistral, Together AI)를 추가할 수 있나요?'
    a: 'api_fetcher.py에 해당 서비스 API를 호출하는 블록을 추가하고 ok(불리언), label(표시 문자열), 선택적으로 pct(0-1 사이 소수)를 캐시 dict에 씁니다. 그런 다음 conky_ai.py의 SERVICES 목록에 서비스 이름과 reset_h 값을 추가하면 됩니다.'
  - q: 'Grok이 잔액이 있는데도 "耗尽"(소진)으로 표시되는 이유는?'
    a: 'Grok 체크는 GET /v1/models를 호출합니다. 인증 유효 및 잔액 있을 때 200, 잔액 소진 시 403을 반환합니다. xAI의 403은 계정 잔액 0을 의미합니다. 잔액이 있는데 403이 표시된다면 ~/.config/.ai_monitor_keys의 API 키가 올바른지 확인하세요.'
---

{{< resource-info >}}

## 문제: 여섯 개 AI 서비스를 동시에 관리하면서 어느 것이 소진됐는지 알 수 없다

현대 개발자는 동시에 4~8개의 AI 서비스를 사용합니다 — Claude는 복잡한 추론, Gemini는 긴 컨텍스트 분석, Grok은 실시간 웹 데이터, Kimi는 대용량 문서 처리. 각 서비스마다 독립적인 쿼터 대시보드, 리셋 일정, 청구 페이지가 있습니다.

결과는 이렇습니다: 작업 도중 레이트 리밋에 걸려 5분 동안 브라우저 탭을 전환하다가, Gemini 무료 쿼터가 UTC 자정(내 현지 자정이 아님)에 리셋된다는 걸 발견하고, Kimi가 왜 429를 반환하는지 디버깅하는 데 또 10분을 낭비하게 됩니다.

**AI Token Monitor**는 항상 보이는 데스크탑 위젯으로 이 문제를 해결합니다 — 편집기를 떠나지 않고도 모든 서비스 상태를 한눈에 확인할 수 있습니다.

```
● Claude  ░░░░░░░░░  무잔액
● Gemini  ░░░░░░░░░  쿼터소진
● Grok    ░░░░░░░░░  소진
● Kimi    █████████  22.4M 잔여
● Codex   ─────────  18:42:01
● Kilo    ─────────  18:42:01
```

## 작동 방식

모니터는 두 가지 컴포넌트로 구성됩니다:

**`api_fetcher.py`** — 백그라운드 스크립트(5분마다 cron 실행)로 각 서비스 API를 폴링하고 결과를 `~/token-monitor/api_cache.json`에 씁니다.

**`conky_ai.py`** — 30초마다 캐시를 읽고 Conky 인라인 `${color}` 태그가 포함된 텍스트를 출력합니다. Conky가 이를 데스크탑 위젯으로 렌더링합니다.

```
api_fetcher.py  →  api_cache.json  →  conky_ai.py  →  Conky 표시
  (cron/5분)        (JSON 캐시)        (30초 폴링)    (항상 표시)
```

이 아키텍처 덕분에 API 오류가 발생해도 데스크탑이 멈추지 않습니다. 캐시에는 항상 마지막으로 알려진 상태가 저장되어 있습니다.

## HP 바 스타일 진행 막대

핵심 기능은 **HP 바 스타일 쿼터 시각화** — 유니코드 블록 문자 행이 남은 쿼터를 직관적으로 표현합니다:

| 색상 | 상태 |
|------|------|
| `█████████` 초록 | 쿼터 50% 이상 |
| `████░░░░░` 주황 | 20~50% 잔여 |
| `█░░░░░░░░` 빨강 | 20% 미만 |
| `░░░░░░░░░` 빨강 | 소진 / 잔액 없음 |
| `─────────` 회색 | API 키 미설정 |

진행 막대는 9글자 너비입니다. `█` 하나가 약 11% 쿼터를 나타냅니다.

## 설치

```bash
# 1. 클론
git clone https://github.com/luckybbjason1/ai-token-monitor
cd ai-token-monitor

# 2. 설치
bash install.sh

# 3. API 키 추가
nano ~/.config/.ai_monitor_keys

# 4. Conky 재시작
pkill conky && conky --daemonize --pause=1
```

설치 스크립트가 자동으로:
- 스크립트를 `~/token-monitor/`에 복사
- Conky 설정에 `${execpi 30 python3 ~/token-monitor/conky_ai.py}` 추가
- `api_fetcher.py`의 cron 작업 설정

## 지원 서비스 및 API 방식

| 서비스 | API 엔드포인트 | 감지 항목 |
|--------|-------------|-----------|
| **Kimi** (Moonshot) | `GET /v1/users/me` | 정확한 잔여 토큰 쿼터 |
| **Claude** (Anthropic) | `POST /v1/messages` | 레이트 리밋 헤더 |
| **Gemini** (Google) | `POST .../generateContent` | 429 = 쿼터 소진 |
| **Grok** (xAI) | `GET /v1/models` | 403 = 잔액 소진 |
| Codex / Kilo | — | UTC+8 자정까지 카운트다운 |

## 보안 설계

API 키는 `~/.config/.ai_monitor_keys`에 `chmod 600` 권한으로 저장됩니다. `.gitignore`로 git에서 제외됩니다. 키는 터미널에 출력되거나 로그 파일에 기록되지 않습니다 — fetcher는 시작 시 한 번 읽고 HTTP 호출 동안만 메모리에 유지합니다.

## 커스텀 서비스 추가

`api_fetcher.py`에 블록을 추가하세요:

```python
# ── 커스텀 서비스 ─────────────────────────────────
key = keys.get('yourservice')
if key:
    try:
        r = requests.get('https://api.yourservice.com/v1/usage',
                         headers={'Authorization': f'Bearer {key}'}, timeout=8)
        if r.status_code == 200:
            data = r.json()
            remain = data['quota_remaining']
            total  = data['quota_total']
            cache['YourService'] = {
                'ok': True,
                'label': f'{remain//1000}K 잔여',
                'pct': remain / total
            }
        else:
            cache['YourService'] = {'ok': False, 'label': 'API 오류'}
    except Exception:
        pass
```

그런 다음 `conky_ai.py`의 `SERVICES` 목록에 `{'name': 'YourService', 'reset_h': 24}`를 추가하세요.

## dibi8 관련 도구

여러 AI API 비용을 관리하고 있다면 다음도 참고하세요:

- [2026 Q2 AI 코딩 비교 — Claude Code vs Cursor vs Codex](/kr/resources/dev-utils/ai-coding-2026-q2-claude-code-cursor-codex-gemini-shootout/) — 실제 개발 워크플로우 비용 비교
- [RTK Rust CLI 프록시 — AI 비용 80% 절감](/kr/resources/dev-utils/rtk-rust-cli-proxy-ai-coding-cost-save-80-percent-2026/) — 가장 저렴한 가용 모델로 프롬프트 자동 라우팅
- [2026 AI 코딩 월간 청구서](/kr/resources/dev-utils/ai-coding-agent-monthly-bill-2026-real-receipts/) — 6개월 프로덕션 AI 사용 실제 영수증

## 코드 받기

MIT 라이선스 완전 오픈소스입니다.

**GitHub:** [github.com/luckybbjason1/ai-token-monitor](https://github.com/luckybbjason1/ai-token-monitor)

작업 도중 레이트 리밋 기습을 피하는 데 도움이 됐다면 Star 부탁드립니다. Issue와 PR 환영합니다 — 특히 macOS 지원이나 새 서비스 통합에 기여해주시면 감사합니다.
