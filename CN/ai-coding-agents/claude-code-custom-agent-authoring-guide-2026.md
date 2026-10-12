---


title: "Claude Code Custom Agent Authoring: Build Reusable Subagents That Enforce Your Standards (2026)"
description: "Technical guide and comparison"
date: 2026-09-20
slug: "claude-code-custom-agent-authoring-guide-2026"
category: "ai-tools"
tags: ["ai", "tools"]

categories: ["ai-coding-agents"]
---


title: "Claude Code Custom Agent Authoring: Build Reusable Subag...
description: "Technical guide and comparison"
date: 2026-05-28T00:00:00+08:00
lastmod: 2026-05-29T00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', CLI, Markdown, YAML]
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
tags: ["claude-code", "subagents", "custom-agents", "agent-sdk", "ai-coding-agents", "llm-frameworks", "developer-tools"]
aliases:
  - /posts/claude-code-custom-agent-authoring/
faq: - q: "Where do custom agent definition files live, and what format are they?"
    a: "Custom agents are Markdown files with YAML frontmatter, stored in .claude/agents/ in your project (or ~/.claude/agents/ for ones you want available across every project). The filename minus the .md extension is not the agent's identity — the name field in the frontmatter is. The frontmatter declares name, description, an optional tools allowlist, and an optional model; everything below the closing