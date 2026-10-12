---


title: "Agent Skills: How Development Teams Can Ship Production-Ready Code 5x Faster"
description: "Technical guide and comparison"
date: 2026-09-20
slug: "agent-skills-production-grade-ai-coding"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---


title: "Agent Skills: How Development Teams Can Ship Production-...
description: "Technical guide and comparison"
  skills and 7 slash commands that turn AI coding agents into senior software engineers.
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack: - Go
- JavaScript
- TypeScript
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
  - /en/posts/agent-skills-production-grade-ai-coding/
- /posts/addy-osmani-agent-skills-production-grade-ai-coding-agents/
- /posts/agent-skills-production-grade-ai-coding/
- /posts/ai-coding-assistants-2026/
faqs: - q: 'What is Agent Skills by Addy Osmani?'
    a: 'Agent Skills is an open-source collection of 20 production-grade engineering skills and 7 slash commands that encode senior-engineer workflows, quality gates, and best practices for AI coding agents. It is built by Addy Osmani and maps to the full software development lifecycle: DEFINE, PLAN, BUILD, VERIFY, REVIEW, SHIP.'
  - q: 'Which AI coding agents does Agent Skills work with?'
    a: 'Agent Skills works with Claude Code, Cursor, Gemini CLI, Windsurf, OpenCode, GitHub Copilot, Kiro, and Codex. Each agent has a dedicated directory with skill manifests, and skills auto-activate based on file type and context.'
  - q: 'What are the 7 slash commands in Agent Skills?'
    a: 'The 7 commands are /spec (define what to build), /plan (break work into small atomic tasks), /build (build incrementally), /test (prove it works with tests), /review (review before merge), /code-simplify (clarity over cleverness), and /ship (deploy to production). Each command automatically activates the relevant skills based on what you are editing.'
  - q: 'How do I install Agent Skills for Claude Code?'
    a: 'For Claude Code you can clone the repo into your project with ``gh repo clone addyosmani/agent-skills .claude/skills``, or install it as a plugin with ``claude plugin install addyosmani/agent-skills``.'
  - q: 'What is an anti-rationalization table in Agent Skills?'
    a: 'An anti-rationalization table is a feature embedded in each skill that pre-emptively flags common excuses developers and AI agents use to cut corners (such as "I''ll add tests later") and provides a counter-argument. The tables are derived from real post-mortems and code-review feedback at Google-scale organizations.'