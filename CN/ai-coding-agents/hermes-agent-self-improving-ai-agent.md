---


title: "Run a skill every day at 9 AM"
description: "AI tool guide"
date: 2026-09-20
slug: "hermes-agent-self-improving-ai-agent"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---


title: "Run a skill every day at 9 AM"
description: "AI tool guide"
  loop — creates skills from experience, continuously improves, remembers your preferences,
  and gets better the more you use it.
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack: - Docker
- Go
- Python
- Rust
- TypeScript
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "210.6 MB"
file_md5: ''
download_url: https://github.com/NousResearch/hermes-agent
backup_url: ''
last_maintained: "2026-05-16"
draft: false
aliases:
  - /en/posts/hermes-agent-self-improving-ai-agent/
- /posts/genericagent-self-evolving-ai-agent/
- /posts/hermes-agent-self-improving-ai-agent/
faqs: - q: 'What makes Hermes Agent different from tools like Claude Code, Cursor, or GitHub Copilot?'
    a: 'Hermes Agent has a built-in self-learning loop, persistent memory across sessions, and a skills system that none of those tools offer. It also runs on 6 messaging platforms, supports cron scheduling and MCP, and is open source and self-hostable, while the others are CLI-, desktop-, or IDE-only and charge subscription or API fees.'
  - q: 'How does Hermes Agent''s self-improvement loop work?'
    a: 'After completing a task, Hermes analyzes what worked and what didn''t, extracts reusable patterns, creates a skill file documenting the approach, tests that skill on similar tasks, and refines it based on results. Over time this builds a personal skill library unique to the user.'
  - q: 'What kind of memory does Hermes Agent keep between sessions?'
    a: 'Hermes maintains two types of memory: User Profile Memory (coding style, projects, preferred tools, communication preferences, and common mistakes) and Session Memory (current project context, recent commands and outputs, and edited files). The profile memory persists even after restarting your computer.'
  - q: 'What messaging platforms can Hermes Agent run on?'
    a: 'Hermes Agent works as a multi-platform messaging bot on Telegram, Discord, Slack, WhatsApp, Signal, and Email, all configured via the ``hermes gateway setup`` command. The same commands and skills work across every platform.'
  - q: 'How do you install Hermes Agent and configure an LLM provider?'
    a: 'On Linux, macOS, or WSL2 you can install with a one-line curl script piped to bash, or clone the repo and run ``./setup-hermes.sh``. You then set a provider with commands like ``hermes config set provider openai`` and ``hermes config set model gpt-4o``, or use a local model via ``hermes config set provider ollama``.'
