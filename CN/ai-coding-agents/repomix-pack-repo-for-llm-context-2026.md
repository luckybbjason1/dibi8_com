---


title: "Run without installing — uses npx"
description: "Technical guide and comparison"
date: 2026-09-20
slug: "repomix-pack-repo-for-llm-context-2026"
category: "ai-tools"
tags: ["ai", "tools"]

categories: ["ai-coding-agents"]---


title: "repomix 2026: Pack Your Entire Codebase into One LLM-Rea...
description: "Technical guide and comparison"
date: 2026-06-09T00:00:00+08:00
lastmod: 2026-06-09T00:00:00+08:00
tech_stack: ['Node.js', TypeScript, CLI]
application_domain: Dev Utils
source_version: "v0.3"
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: 'https://github.com/yamadashy/repomix'
backup_url: ''
last_maintained: "2026-06-01"
draft: false
categories: ["dev-utils"]
tags: ["repomix", "repopack", "ai-coding", "llm-context", "codebase-packing", "claude", "chatgpt", "developer-tools", "open-source"]
aliases:
  - /posts/repomix-pack-repo-for-llm-context-2026/
faqs: - q: 'What is repomix and what was it called before?'
    a: 'repomix (formerly repopack) is an open-source CLI tool that packs an entire Git repository into a single structured text file, optimized for LLM context windows. It was renamed from "repopack" to "repomix" in 2025 to avoid confusion with npm''s existing "repack" command. Built by yamadashy and released under MIT.'
  - q: 'What output formats does repomix support?'
    a: 'repomix supports three output formats: plain text (default), XML (structured with file tags, best for Claude which uses XML natively), and Markdown (best for documentation workflows and GitHub Copilot). You select the format with --style plain|xml|markdown.'
  - q: 'How does repomix differ from just copying all files manually?'
    a: 'repomix automatically respects .gitignore rules, adds a token count estimate per file, generates a repository summary and directory tree at the top, handles binary file exclusion, and supports custom include/exclude glob patterns — all in one command. The output is formatted specifically for LLMs with file separators that the model can parse reliably.'
  - q: 'How large a codebase can repomix handle?'
    a: 'repomix works well up to around 100,000–200,000 tokens (roughly a 5,000–10,000 file project). For larger repos, use --include patterns to send only the relevant subsystem. The --output-show-line-numbers flag helps LLMs give accurate line references for edits.'
  - q: 'Can I use repomix with Claude Projects or ChatGPT memory?'
    a: 'Yes — the most common workflow is to run repomix, then paste or upload the output file to a Claude Project or a custom GPT. This gives the AI full codebase context for debugging, code review, documentation, or architecture discussions without iterating over dozens of files.'