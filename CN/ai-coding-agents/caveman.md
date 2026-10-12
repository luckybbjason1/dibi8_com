---


title: "Cut Claude Code Token Usage by 65% With Caveman — Same Quality, Fewer Tokens"
description: "AI tool guide"
date: 2026-09-20
slug: "caveman"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---


title: "Cut Claude Code Token Usage by 65% With Caveman — Same Quality, Fewer Tokens"
description: "AI tool guide"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack: - Docker
  - Go
  - JavaScript
  - Python
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "2.4 MB"
file_md5: ""
download_url: "https://github.com/JuliusBrussee/caveman.git"
backup_url: ""
last_maintained: "2026-05-12"
draft: false
aliases:
  - /posts/caveman/
faqs: - q: 'What is Caveman for Claude Code?'
    a: 'Caveman is a Claude Code skill that makes Claude respond in compressed, terse, caveman-style language by dropping filler, articles, and polite preamble. It reduces output tokens by 65% on average without losing technical accuracy.'
  - q: 'How much does Caveman reduce token usage?'
    a: 'Across the repository''s reproducible benchmarks, Caveman cut output tokens by 65% on average, ranging from 22% to 87% depending on how verbose the original task was. For example, explaining a React re-render bug dropped from 1,180 to 159 tokens (87% saved).'
  - q: 'Does Caveman make Claude less accurate or ''dumber''?'
    a: 'No. Caveman leaves the model''s thinking and reasoning tokens untouched and only compresses the final output text. The model still reasons at full capability and all technical content is preserved; only fluff is removed.'
  - q: 'How do you install Caveman for Claude Code?'
    a: 'Clone the repo into your global skills directory with ''git clone https://github.com/JuliusBrussee/caveman.git ~/.claude/skills/caveman'', then restart Claude Code. The skill auto-loads. It also supports Cursor, Cline, Windsurf, and Codex via their respective rules files.'
  - q: 'What intensity levels and commands does Caveman offer?'
    a: 'Caveman has three levels: Lite (removes filler, keeps grammar), Full (default mode, drops articles and uses fragments), and Ultra (maximum telegraphic compression). It also ships sub-commands like /caveman-commit, /caveman-review, /caveman-stats, and /caveman:compress for rewriting memory files such as CLAUDE.md.'
