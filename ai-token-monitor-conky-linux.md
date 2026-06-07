---
title: 'AI Token Monitor: Track Claude, Gemini, Grok, Kimi Quota Live on Your Linux Desktop'
description: 'Free open-source desktop widget for Linux that shows real-time AI token quotas with HP-bar progress visualization inside Conky. Supports Claude, Gemini, Grok, and Kimi with live API polling and reset countdowns.'
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
tags: ['AI token monitor', 'Claude quota', 'Gemini quota tracker', 'Grok token', 'Kimi API', 'Conky widget', 'Linux desktop', 'open source', 'Python', 'developer tools']
aliases:
- /posts/ai-token-monitor-conky-linux/
faqs:
  - q: 'Does the AI Token Monitor work on macOS or Windows?'
    a: 'Currently the widget requires Conky, which is Linux-only. The core Python scripts (api_fetcher.py) work on any OS, but the visual display layer depends on Conky. A cross-platform version using tkinter exists in the repo (monitor.py) but is experimental — GNOME users report the frameless window may not render correctly.'
  - q: 'How does the tool read Claude API token balance?'
    a: 'It sends a minimal POST request to /v1/messages with max_tokens=1 and reads the anthropic-ratelimit-tokens-remaining and anthropic-ratelimit-tokens-limit response headers. This costs roughly 10 input tokens per check (cron every 5 min = ~2,880 tokens/day) — negligible for most plans.'
  - q: 'Is it safe to store API keys in ~/.config/.ai_monitor_keys?'
    a: 'The file is created with chmod 600, readable only by your user. It is excluded from git via .gitignore. It is no more or less secure than storing keys in a .env file — both rely on filesystem permissions. For shared machines, consider encrypting with gpg-agent or a secrets manager.'
  - q: 'Can I add a custom AI service not listed (e.g., Mistral, Together AI)?'
    a: 'Yes. In api_fetcher.py, add a block that calls your service API and writes to the cache dict with keys ok (bool), label (display string), and optionally pct (float 0-1). Then add the service name to the SERVICES list in conky_ai.py with its reset_h value.'
  - q: 'Why does Grok show "耗尽" (depleted) even when my account has credits?'
    a: 'The Grok check calls GET /v1/models — it returns 200 if authenticated and credits available, 403 if credits are exhausted. A 403 from xAI specifically means account balance is zero. If you have credits but see 403, verify the API key is correct in ~/.config/.ai_monitor_keys.'
---

{{< resource-info >}}

## The Problem: Juggling Six AI Services and Never Knowing Which One Is Out

Modern developers use four to eight AI services simultaneously — Claude for complex reasoning, Gemini for long-context analysis, Grok for real-time web data, Kimi for large document processing. Each service has its own quota dashboard, reset schedule, and billing page.

The result: you hit a rate limit mid-task, spend five minutes switching browser tabs, discover Gemini's free quota reset at midnight UTC (not your local midnight), and waste another ten minutes debugging why your Kimi call returned 429.

**AI Token Monitor** solves this with a persistent desktop widget that shows every service's status at a glance — without leaving your editor.

```
● Claude  ░░░░░░░░░  无余额
● Gemini  ░░░░░░░░░  配额用完
● Grok    ░░░░░░░░░  耗尽
● Kimi    █████████  22.4M剩
● Codex   ─────────  18:42:01
● Kilo    ─────────  18:42:01
```

## How It Works

The monitor has two components:

**`api_fetcher.py`** — a background script (cron every 5 min) that polls each service API and writes results to `~/token-monitor/api_cache.json`.

**`conky_ai.py`** — reads the cache every 30 seconds and outputs Conky-formatted text with inline `${color}` tags. Conky renders this as the desktop widget.

```
api_fetcher.py  →  api_cache.json  →  conky_ai.py  →  Conky display
   (cron/5m)         (JSON cache)        (30s poll)       (always on)
```

This architecture means API failures never freeze your desktop. The cache always has the last known state.

## HP-Bar Progress Visualization

The key feature is the **blood-bar style quota display** — a row of Unicode block characters that visually represent remaining quota:

| Color | State |
|-------|-------|
| `█████████` green | Above 50% quota |
| `████░░░░░` orange | 20–50% remaining |
| `█░░░░░░░░` red | Below 20% |
| `░░░░░░░░░` red | Exhausted / no balance |
| `─────────` gray | No API key configured |

The bar is 9 characters wide. Each `█` represents ~11% of quota.

## Installation

```bash
# 1. Clone
git clone https://github.com/luckybbjason1/ai-token-monitor
cd ai-token-monitor

# 2. Install
bash install.sh

# 3. Add API keys
nano ~/.config/.ai_monitor_keys

# 4. Restart Conky
pkill conky && conky --daemonize --pause=1
```

The installer automatically:
- Copies scripts to `~/token-monitor/`
- Adds `${execpi 30 python3 ~/token-monitor/conky_ai.py}` to your Conky config
- Sets up the cron job for `api_fetcher.py`

## Supported Services and API Methods

| Service | API Endpoint | What We Detect |
|---------|-------------|----------------|
| **Kimi** (Moonshot) | `GET /v1/users/me` | Exact token quota remaining |
| **Claude** (Anthropic) | `POST /v1/messages` | Rate-limit headers per window |
| **Gemini** (Google) | `POST .../generateContent` | 429 = quota exceeded |
| **Grok** (xAI) | `GET /v1/models` | 403 = balance exhausted |
| Codex / Kilo | — | Countdown to midnight UTC+8 |

For services without quota APIs (Codex, Kilo), the monitor shows a countdown to the standard daily reset at midnight UTC+8.

## Security Design

API keys are stored in `~/.config/.ai_monitor_keys` with `chmod 600`. The file is excluded from git. Keys are never echoed to terminal or written to log files — the fetcher reads them once at startup and they stay in memory only for the duration of the HTTP call.

For the cautious: review `api_fetcher.py` before installing. It makes only GET/POST requests to official API endpoints with your own keys. No data is sent anywhere except the respective AI service.

## Adding Custom Services

Open `api_fetcher.py` and add a block after the existing services:

```python
# ── Your Service ─────────────────────────────────
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
                'label': f'{remain//1000}K剩',
                'pct': remain / total
            }
        else:
            cache['YourService'] = {'ok': False, 'label': 'API Error'}
    except Exception:
        pass
```

Then add `{'name': 'YourService', 'reset_h': 24}` to the `SERVICES` list in `conky_ai.py`.

## Related Tools on dibi8

If you are managing multiple AI API costs, also check:

- [AI Coding 2026 Q2 Shootout — Claude Code vs Cursor vs Codex](/en/resources/dev-utils/ai-coding-2026-q2-claude-code-cursor-codex-gemini-shootout/) — real usage cost comparison for dev workflows
- [RTK Rust CLI Proxy — 80% AI Cost Savings](/en/resources/dev-utils/rtk-rust-cli-proxy-ai-coding-cost-save-80-percent-2026/) — automatically routes prompts to cut AI API costs by up to 80%
- [AI Coding Monthly Bill 2026](/en/resources/dev-utils/ai-coding-agent-monthly-bill-2026-real-receipts/) — actual receipts from six months of production AI usage

## Get the Code

The tool is fully open source under MIT license.

**GitHub:** [github.com/luckybbjason1/ai-token-monitor](https://github.com/luckybbjason1/ai-token-monitor)

Star the repo if it saved you from a mid-task rate-limit surprise. Issues and PRs welcome — especially for adding macOS support or new service integrations.
