---


title: "One-line install via npx"
description: "AI tool guide"
date: 2026-09-20
slug: "agent-reach-ai-agent-internet-access"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---


title: "Agent Reach: Give Your AI Agent Internet Superpowers"
description: "AI tool guide"
  access to YouTube, Twitter, Reddit, Xiaohongshu, Bilibili and 15+ platforms with
  one command.
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack: - Docker
- Go
- JavaScript
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
last_maintained: "2026-05-15"
draft: false
aliases:
  - /en/posts/agent-reach-ai-agent-internet-access/
- /posts/agent-reach-ai-agent-internet-access/
- /posts/agent-reach-give-your-ai-agent-internet-superpowers/
- /posts/agent-reach/
faqs: - q: 'What is Agent Reach and what does it do?'
    a: 'Agent Reach is an open-source MIT-licensed scaffolding tool created by Panniantong that gives AI agents instant access to 15+ internet platforms with a single command. It automates selecting, installing, and configuring the best open-source tool for each platform rather than wrapping them in an abstraction layer.'
  - q: 'Which platforms does Agent Reach support?'
    a: 'It supports 15+ platforms including Web, YouTube, RSS, GitHub, Twitter/X, Reddit, Bilibili, Xiaohongshu, Douyin, LinkedIn, WeChat, Weibo, V2EX, Xueqiu, Podcast transcription, and AI web search. Capabilities range from reading webpages and extracting YouTube subtitles to searching tweets, reading Reddit comments, and posting on Xiaohongshu.'
  - q: 'How do you install Agent Reach?'
    a: 'You can install it with one command via npx using ''npx skills add Panniantong/Agent-Reach'', or by cloning the GitHub repo. The agent then installs the agent-reach CLI via pip, detects and installs system dependencies (Node.js, gh CLI, mcporter), configures Exa MCP search, registers SKILL.md, and runs ''agent-reach doctor'' to verify the setup.'
  - q: 'How does Agent Reach store credentials and keep them secure?'
    a: 'Cookies and tokens are stored locally in ~/.agent-reach/config.yaml with 600 file permissions. All code and dependencies are open source and auditable, and Agent Reach recommends using throwaway dedicated accounts for cookie-based platforms to reduce ban risk.'
  - q: 'Which AI agents and coding tools is Agent Reach compatible with?'
    a: 'Agent Reach works with Claude Code, GitHub Copilot, OpenAI Codex CLI, Cursor, Windsurf, Gemini CLI, and any MCP-compatible agent. Each platform is implemented as an independent, swappable channel file, so you can replace the underlying tool for any platform without lock-in.'