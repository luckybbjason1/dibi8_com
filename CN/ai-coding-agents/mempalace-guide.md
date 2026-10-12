---


title: "Claude Code Session Memory: How to Integrate MemPalace for 96.6% Recall (2026 Guide)"
description: "Technical guide and comparison"
date: 2026-09-20
slug: "mempalace-guide"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---


title: "Claude Code Session Memory: How to Integrate MemPalace f..."
description: "Technical guide and comparison"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack: - Go
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
  - /posts/mempalace-guide/
faqs: - q: 'How do you add persistent memory to Claude Code?'
    a: 'Run MemPalace locally and pass its MCP endpoint to Claude Code by configuring claude_code_config.json to point at http://localhost:8787/mcp with read/write access. Claude then queries MemPalace as a semantic vector database whenever it needs historical context.'
  - q: 'Does Claude Code memory persist across sessions and reboots?'
    a: 'Yes. Because MemPalace writes data to a local SQLite/ChromaDB disk instance, the AI''s memory persists across reboots, crashes, and entirely new terminal sessions, rather than being lost when the terminal closes.'
  - q: 'What recall rate does MemPalace achieve on the LongMemEval benchmark?'
    a: 'MemPalace achieves a 96.6% recall rate on the LongMemEval benchmark, compared to 81.2% for a Pinecone cloud setup and 0% for raw Claude Code, which forgets everything on exit.'
  - q: 'Is MemPalace data stored locally or sent to the cloud?'
    a: 'MemPalace stores data 100% locally using ChromaDB, so no project context is sent to external cloud servers. This differs from Pinecone, which sends data to cloud servers.'
  - q: 'Is MemPalace free to use?'
    a: 'Yes. MemPalace is open source under the MIT license and costs $0 with no API or subscription fees, unlike Pinecone which charges subscription or usage fees.'