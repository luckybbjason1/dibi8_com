---


title: "Claude Code Skill Authoring: How to Package Procedures Claude Loads Only When Relevant (2026)"
description: "Technical guide and comparison"
date: 2026-09-20
slug: "claude-code-skill-authoring-guide-2026"
category: "ai-tools"
tags: ["ai", "tools"]

categories: ["ai-coding-agents"]---


title: "Claude Code Skill Authoring: How to Package Procedures C...
description: "Technical guide and comparison"
date: 2026-05-28T00:00:00+08:00
lastmod: 2026-05-29T00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', Markdown, YAML]
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
tags: ["claude-code", "skills", "agent-sdk", "ai-coding-agents", "llm-frameworks", "developer-tools", "prompt-engineering"]
aliases:
  - /posts/claude-code-skill-authoring/
faq: - q: "Where do skills live and what's the minimum a SKILL.md needs?"
    a: "A skill is a directory under .claude/skills// (project-scoped) or ~/.claude/skills// (user-scoped), containing a SKILL.md file. The minimum is YAML frontmatter with a name and a description, followed by the instructions in the body. The directory can also hold supporting files — reference docs, scripts, templates — that the skill points to, but SKILL.md with those two frontmatter fields is the irreducible core."
  - q: "What's the difference between a skill and just putting instructions in CLAUDE.md?"
    a: "CLAUDE.md loads on every single interaction — it's for always-on, project-wide rules. A skill loads only when its description matches the task at hand. Use CLAUDE.md for 'always use tabs, never commit to main directly.' Use a skill for situational procedures like 'how to cut a release' or 'how to debug a flaky test' — knowledge you don't want bloating every prompt, only present when you're actually doing that thing. The skill keeps your base context lean."
  - q: "How does the description field control when a skill loads?"
    a: "The description is the trigger signal. Claude reads skill descriptions to decide which skill is relevant to the current task, then loads that skill's full body into context. So the description must describe WHEN to use the skill with concrete cues — 'Use when cutting a release, publishing a version, or tagging a build' — not just what it is. A vague description ('release helper') means the skill exists but never fires at the right moment."
  - q: "What is progressive disclosure and why does it matter for skills?"
    a: "Progressive disclosure means the skill loads its lightweight SKILL.md first, and only pulls in heavier supporting files (detailed references, large templates, scripts) when the task actually needs them. You keep SKILL.md short and point to references/big-spec.md for the deep detail. This protects context: the trigger and the overview are cheap to load for routing, and the expensive detail only enters the conversation once the skill is genuinely engaged."
  - q: "Can a skill include scripts or just instructions?"
    a: "Both. A skill directory can bundle scripts (a Python helper, a shell script), templates, and reference documents alongside SKILL.md. The body can instruct Claude to run a bundled script or read a bundled reference. This is how a skill becomes more than a prompt — it's a packaged capability with its instructions, its reference material, and its executable helpers all version-controlled together in one directory."
  - q: "When should I write a subagent instead of a skill?"
    a: "Write a skill when you need to teach a procedure that runs in the current conversation. Write a subagent when the work needs its own context window — heavy exploration, parallel research, or independent review that would otherwise bloat the parent. They compose: a subagent can load a skill to follow your methodology while running in isolation. The rule of thumb from the extension-decision framework — skill changes behavior, subagent protects context, MCP server adds capability."
