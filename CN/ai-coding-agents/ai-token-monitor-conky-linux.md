---


title: "The Problem: Juggling Six AI Services and Never Knowing Which One Is Out"
description: "Technical guide and comparison"
date: 2026-09-20
slug: "ai-token-monitor-conky-linux"
category: "ai-tools"
tags: ["ai", "tools"]

categories: ["ai-coding-agents"]
---


title: "AI Token Monitor: Track Claude, Gemini, Grok, Kimi Quota...
description: "Technical guide and comparison"
date: 2026-06-06T00:00:00+08:00
lastmod: 2026-06-06T00:00:00+08:00
tech_stack: [Python, Conky, Linux]
application_domain: Dev Utils
source_version: "1.0.0"
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
last_maintained: "2026-06-06"
draft: false
categories: ["dev-utils"]
tags: ["ai token monitor", "claude quota", "gemini quota tracker", "grok token", "kimi api", "conky widget", "linux desktop", "open source", "python", "developer tools"]
aliases:
  - /posts/ai-token-monitor-conky-linux/
faqs: - q: 'Does the AI Token Monitor work on macOS or Windows?'
    a: 'Currently the widget requires Conky, which is Linux-only. The core Python scripts (api_fetcher.py) work on any OS, but the visual display layer depends on Conky. A cross-platform version using tkinter exists in the repo (monitor.py) but is experimental — GNOME users report the frameless window may not render correctly.'
  - q: 'How does the tool read Claude API token balance?'
    a: 'It sends a minimal POST request to /v1/messages with max_tokens=1 and reads the anthropic-ratelimit-tokens-remaining and anthropic-ratelimit-tokens-limit response headers. This costs roughly 10 input tokens per check (cron every 5 min = ~2,880 tokens/day) — negligible for most plans.'
  - q: 'Is it safe to store API keys in ~/.config/.ai_monitor_keys?'
    a: 'The file is created with chmod 600, readable only by your user. It is excluded from git via .gitignore. It is no more or less secure than storing keys in a .env file — both rely on filesystem permissions. For shared machines, consider encrypting with gpg-agent or a secrets manager.'
  - q: 'Can I add a custom AI service not listed (e.g., Mistral, Together AI)?'
    a: 'Yes. In api_fetcher.py, add a block that calls your service API and writes to the cache dict with keys ok (bool), label (display string), and optionally pct (float 0-1). Then add the service name to the SERVICES list in conky_ai.py with its reset_h value.'
  - q: 'Why does Grok show "耗尽" (depleted) even when my account has credits?'
    a: 'The Grok check calls GET /v1/models — it returns 200 if authenticated and credits available, 403 if credits are exhausted. A 403 from xAI specifically means account balance is zero. If you have credits but see 403, verify the API key is correct in ~/.config/.ai_monitor_keys.'