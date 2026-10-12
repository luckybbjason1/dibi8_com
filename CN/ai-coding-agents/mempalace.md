---


title: "MemPalace: Give Your AI a Perfect Memory (Free, Open Source, 51K+ Stars)"
description: "6% Recall Benchmark & Best AI Memo"
date: 2026-09-20
slug: "mempalace"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---


title: "MemPalace vs Mem0: 96.6% Recall Benchmark & Best AI Memo..."
description: "6% Recall Benchmark & Best AI Memo"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack: - Go
  - Python
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: ""
file_md5: ""
download_url: ""
backup_url: ""
last_maintained: "2026-05-15"
draft: false
aliases:
  - /posts/mempalace/
faqs: - q: 'What is MemPalace and how does it give an AI memory?'
    a: 'MemPalace is a free, open-source, local-first AI memory system that stores your conversation and project history as verbatim text and retrieves it with semantic search. It creates a structured memory layer outside the model so your AI assistant can recall exact past context instead of starting every chat from zero.'
  - q: 'How do you install MemPalace?'
    a: 'MemPalace is a Python tool that installs via uv (uv tool install mempalace) or pip (pip install mempalace). After installing, run mempalace init ~/projects/myapp to initialize it for your project.'
  - q: 'How does MemPalace compare to Mem0 on recall accuracy?'
    a: 'On the LongMemEval benchmark, MemPalace reports a 96.6% recall rate versus 89.2% for Mem0. MemPalace also runs fully locally with zero API calls, while Mem0 requires a paid OpenAI API.'
  - q: 'How does MemPalace organize stored memory?'
    a: 'MemPalace uses a palace metaphor with three levels: Wings for people and projects, Rooms for topics within those projects, and Drawers that hold the original content stored verbatim. This lets you scope a search to a specific project wing or topic room instead of querying a flat vector database.'
  - q: 'Does MemPalace work with Claude Code and other AI tools?'
    a: 'Yes. MemPalace ships native plugins including a .claude-plugin directory for Claude Code, a .codex-plugin directory for OpenAI Codex, and a .agents/plugins directory for MCP-compatible tools, plus support for Gemini CLI and local models. It exposes an MCP-compatible endpoint out of the box for persistent coding-agent memory.'