---


title: "Clone and install"
description: "AI tool guide"
date: 2026-09-20
slug: "9router-smart-llm-proxy-token-saver-free-coding"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---


title: "Clone and install"
description: "AI tool guide"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack: - Docker
  - Go
  - Java
  - JavaScript
  - Rust
  - TypeScript
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "3.2 MB"
file_md5: ""
download_url: "https://github.com/rtk-ai/rtk"
backup_url: ""
last_maintained: "2026-05-15"
draft: false
aliases:
  - /posts/9router-smart-llm-proxy-token-saver-free-coding/
faqs: - q: 'What is 9Router and how does it work?'
    a: '9Router is an open-source, self-hosted smart proxy that sits between your AI coding tool and model providers, running on localhost:20128 by default. Instead of calling Claude or OpenAI directly, your tool sends requests to 9Router, which routes them across 40+ providers using intelligent fallback logic and token compression.'
  - q: 'Does 9Router cost money to use?'
    a: 'No. The 9Router software is free forever under an open-source MIT license and is self-hosted on your own hardware. It has no billing infrastructure and never charges you; you only pay providers directly for whatever subscriptions or API keys you configure, and free providers stay free. The dashboard''s cost figures are a savings tracker showing what equivalent paid-API usage would have cost.'
  - q: 'How much does 9Router reduce AI token usage?'
    a: 'Through its built-in RTK compression, 9Router compresses tool outputs like git diffs, grep results, and directory listings before they reach the LLM, saving 20-40% of input tokens per request. Its optional Caveman mode reduces verbose model output by up to 65%, and developers making 500+ daily calls report effective model consumption dropping 40-60%.'
  - q: 'Which AI coding tools and IDEs work with 9Router?'
    a: 'Any tool that supports a custom OpenAI-compatible API endpoint can connect to 9Router via http://localhost:20128/v1. Supported tools include Claude Code, OpenAI Codex CLI, Cursor IDE, GitHub Copilot, Cline, Continue, Roo Code, Antigravity, Droid, Kilo Code, and OpenCode.'
  - q: 'Can I use 9Router for AI coding at zero monthly cost?'
    a: 'Yes. You can build a combo using only free providers such as Kiro AI (free unlimited via AWS Builder ID, Google, or GitHub OAuth, no API key), OpenCode Free (zero auth passthrough), and Vertex AI ($300 free Google Cloud credits). Combined with RTK compression, this delivers production-quality responses at literally $0 per month.'