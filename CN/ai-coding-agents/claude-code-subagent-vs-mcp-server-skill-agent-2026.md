---


title: "Subagent vs MCP Server vs Skill: When to Build Each Claude Code Extension (2026)"
description: "Technical guide and comparison"
date: 2026-09-20
slug: "claude-code-subagent-vs-mcp-server-skill-agent-2026"
category: "ai-tools"
tags: ["ai", "tools"]

categories: ["ai-coding-agents"]---


title: "Subagent vs MCP Server vs Skill: When to Build Each Clau...
description: "Technical guide and comparison"
date: 2026-05-28T00:00:00+08:00
lastmod: 2026-05-29T00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', MCP, CLI]
application_domain: LLM Frameworks
source_version: ''
licensing_model: Commercial (Anthropic)
license_type: Proprietary
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
last_maintained: "2026-05-28"
draft: false
categories: ["llm-frameworks"]
tags: ["claude-code", "mcp", "subagents", "skills", "agent-sdk", "llm-frameworks", "developer-tools"]
aliases:
  - /posts/claude-code-subagent-vs-mcp-vs-skill/
faq: - q: "What's the one-sentence difference between a skill, a subagent, and an MCP server?"
    a: "A skill teaches Claude HOW to do something (packaged instructions and knowledge loaded into context), a subagent is WHO does it (a delegated worker with its own context window), and an MCP server is WHAT it can reach (a connection to external tools and data). Skills change behavior, subagents protect context, MCP servers add capabilities — three different axes, not three competing options."
  - q: "If I need Claude to query our internal database, is that a skill, a subagent, or an MCP server?"
    a: "An MCP server. Anything that connects Claude to an external system — a database, an internal API, a SaaS platform, a ticketing system — is an integration, and integrations are exactly what MCP servers exist for. A skill can document HOW to phrase good queries, and a subagent can be the worker that runs the analysis in isolation, but the actual connection to the database is the MCP server's job. You often end up using all three together."
  - q: "When should I write a skill instead of just putting instructions in CLAUDE.md?"
    a: "Use CLAUDE.md for always-on, project-wide rules that apply to every interaction. Write a skill when the guidance is situational — a multi-step procedure, a domain playbook, a checklist — that you only want loaded when it's relevant. Skills keep your base context lean: the detailed instructions for 'how to cut a release' only enter the conversation when you're actually cutting a release, instead of bloating every prompt."
  - q: "Can a subagent use MCP servers and skills?"
    a: "Yes. A subagent runs as a full Claude conversation, so it inherits access to the MCP servers connected to the session and can load skills relevant to its task. This is the common composition: an MCP server exposes the database, a skill encodes the analysis methodology, and a subagent runs the whole thing in an isolated context so the heavy query output never pollutes the parent. The three layers stack."
  - q: "Why not just build everything as MCP servers since they're the most powerful?"
    a: "Because MCP servers are the heaviest to build and maintain — they're separate processes with their own deployment, auth, and versioning. If your need is 'Claude should follow this checklist' that's a skill (a markdown file). If it's 'do this exploration without bloating my context' that's a subagent (a markdown file). Reaching for an MCP server when a skill would do is over-engineering: you've shipped a service to solve a documentation problem."
  - q: "Do skills, subagents, and MCP servers all work in CI / headless mode?"
    a: "Yes, all three. Skills and subagents are version-controlled files in your repo, so CI picks them up automatically. MCP servers need to be configured and reachable from the CI environment (credentials in CI secrets, network access to the service). The headless -p mode respects all three; the only practical gotcha is making sure your MCP server's auth works without an interactive login when running unattended."
