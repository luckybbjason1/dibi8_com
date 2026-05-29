---
title: 'Subagent vs MCP Server vs Skill: When to Build Each Claude Code Extension (2026)'
description: 'Claude Code has three extension points — skills, subagents, and MCP servers — and they solve different problems. A decision framework for choosing the right one, with worked scenarios and the anti-patterns that waste your time.'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'MCP', 'CLI']
application_domain: LLM Frameworks
source_version: ''
licensing_model: Commercial (Anthropic)
license_type: 'Proprietary'
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/anthropics/claude-code'
stars: 0
maintainer: 'Anthropic'
last_maintained: '2026-05-28'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['claude-code', 'mcp', 'subagents', 'skills', 'agent-sdk', 'llm-frameworks', 'developer-tools']
aliases:
- /posts/claude-code-subagent-vs-mcp-vs-skill/
faq:
  - q: "What's the one-sentence difference between a skill, a subagent, and an MCP server?"
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
---

## Introduction

By 2026, Claude Code has three distinct ways to extend it — **skills**, **subagents**, and **MCP servers** — and the single most common question we get is "which one do I build?" The confusion is understandable: all three are "ways to make Claude do more," and the marketing blurs them together. But they sit on three completely different axes, and picking the wrong one means either over-engineering (a whole server for what a markdown file would do) or hitting a wall (a skill that can't actually reach your database).

This article gives you a decision framework. We'll define each extension point in one line, walk through the axis each one moves, run three real scenarios end to end, and call out the anti-patterns that waste a weekend. If you've already read [Custom Agent Authoring](/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/) and the [MCP Servers 2026 rankings](/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/), this is the piece that ties them together.

## The Three Extension Points, One Line Each

- **Skill** — teaches Claude *how* to do something. Packaged instructions, a playbook, a checklist, loaded into context only when relevant.
- **Subagent** — *who* does it. A delegated worker with its own context window, spawned to keep the parent conversation lean (see the [subagent patterns](/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/)).
- **MCP server** — *what* it can reach. A connection to an external system: a database, an API, a SaaS tool, a data source.

Say it as a sentence and the confusion dissolves: **a skill changes behavior, a subagent protects context, an MCP server adds capability.** They are not three answers to one question. They are answers to three different questions.

## The Axis Each One Moves

### Skills move the "knowledge" axis

A skill is the answer to *"Claude doesn't know our specific procedure."* Your release process, your code-review rubric, your incident-response runbook — knowledge that's situational. You don't want it in `CLAUDE.md` (that loads on every interaction and bloats the base context); you want it loaded only when the task calls for it. A skill is a markdown file with a trigger description; when the work matches, the detailed instructions enter the conversation, and otherwise they stay out of the way.

### Subagents move the "context" axis

A subagent is the answer to *"this work would blow up my context window."* The knowledge might already be there; the problem is that doing the work inline — reading 30 files, running a long exploration — would crowd out the reasoning you actually care about. A subagent runs it in a separate context and hands back only the conclusion. Nothing about *capability* changes; what changes is *whose working memory* pays for the exploration.

### MCP servers move the "capability" axis

An MCP server is the answer to *"Claude literally cannot reach this system."* Your Postgres database, your internal metrics API, your Stripe account, your Linear board. No amount of skill-writing or subagent-spawning conjures a database connection — that's a genuine new capability, and capabilities come from MCP servers. This is also the heaviest of the three: a separate process with deployment, authentication, and versioning to own.

## A Decision Framework

Ask these in order:

1. **"Does Claude need to reach a system it currently can't?"** → **MCP server.** (Database, API, SaaS, external data.)
2. **"Does Claude already have the capability, but the work would bloat my context?"** → **Subagent.** (Big exploration, parallel research, isolated experiments.)
3. **"Does Claude have the capability and the context, but doesn't know our specific way of doing it?"** → **Skill.** (Playbook, checklist, procedure.)

| If the problem is... | Build a... | Why |
| --- | --- | --- |
| Can't reach the system | MCP server | New capability |
| Context would explode | Subagent | Protect working memory |
| Doesn't know our procedure | Skill | Situational knowledge |
| Standards never get enforced | Subagent (custom agent) | Executable, version-controlled review |

The cheapest option that solves your problem is almost always the right one. A markdown file (skill or subagent) beats a deployed service (MCP server) whenever it can do the job.

## Worked Scenario 1: "Audit our codebase for SQL injection"

- **Capability?** Reading code — Claude already has it. No MCP server needed.
- **Context?** Auditing the whole codebase means reading dozens of files. That *would* bloat the parent. → **Subagent.**
- **Procedure?** You want the audit to follow OWASP's specific checklist. → **Skill** (or bake the checklist into a `security-auditor` custom agent's system prompt).

**Answer:** a `security-auditor` subagent whose system prompt encodes the checklist. One artifact, two axes covered. No server.

## Worked Scenario 2: "Show me which customers churned last month"

- **Capability?** That data lives in your warehouse. Claude can't reach it. → **MCP server** (a warehouse/SQL MCP).
- **Context?** A big result set could be noisy. → run the query inside a **subagent** that returns just the summary.
- **Procedure?** "Churn" has a specific definition at your company. → a **skill** documenting the churn query logic.

**Answer:** all three, composed. The MCP server connects, the skill defines "churn," the subagent runs it cleanly. This is the canonical full-stack case.

## Worked Scenario 3: "Make sure every release follows our checklist"

- **Capability?** Git, file reads — already there. No server.
- **Context?** Light. No subagent strictly needed for protection.
- **Procedure?** Entirely the point — your team's release steps. → **Skill**, or a custom agent if you want it to *enforce* and produce a report.

**Answer:** a skill (or a release-gate custom agent). Building an MCP server here would be pure over-engineering.

## Anti-Patterns

- **The MCP-server-for-everything trap.** Shipping a service to solve a documentation problem. If you're not connecting to an external system, you probably don't need a server. (Browse the [MCP server registry](/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) to see what genuinely warrants one.)
- **The bloated CLAUDE.md.** Stuffing every procedure into always-on context. Move situational playbooks into skills so your base context stays sharp.
- **The mega-subagent.** A subagent that "does everything" is just the parent with a worse memory. Split by concern.
- **Skill that needed a capability.** Writing a beautiful skill for "analyze our metrics" when Claude can't reach the metrics. No instructions substitute for the missing MCP connection.

## The Principle

The three extension points map to three resources: **knowledge** (skills), **context** (subagents), and **capability** (MCP servers). Diagnose which resource you're actually short on, and the choice makes itself. Most teams over-reach for MCP servers because they sound powerful, when a markdown file would have shipped the same outcome by lunch. Build the lightest thing that moves the axis you're stuck on.

## Setting Up Production-Ready Claude Code

Running all three layers — especially MCP servers — at scale wants stable infrastructure:

1. **A reliable host for MCP servers and CI.** MCP servers are long-running processes; you need a box that stays up. **{{< aff "htstack" "footer-cta" "HTStack" >}}** — Hong Kong VPS with low-latency mainland-China access and stable BGP. Same IDC that hosts dibi8.com, where we run our own MCP servers and agent pipelines. $5-12/month value tier.

2. **Cloud headroom for parallel layers.** When subagents fan out and MCP servers run alongside, you want spare CPU. **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — $200 free credit for 60 days across 14+ regions.

3. **A skills bundle.** The fastest way to internalize the skill/subagent/server split is to study working examples. We packaged five battle-tested skills as a $19 bundle on Gumroad — see the floating CTA in the corner — including custom agent definitions and the orchestrator prompts that compose all three layers.

## Related Reading

- [Custom Agent Authoring Guide](/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/) — how to actually build the subagent half.
- [Subagent Patterns](/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) — the five workflows for the context axis.
- [MCP Servers 2026 Rankings](/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/) — choosing the capability layer.
- [MCP Server Registry Guide](/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) — the catalog of what's worth connecting.

## Verdict

Stop asking "skill, subagent, or MCP server?" as if they compete. Ask instead: am I short on **knowledge**, **context**, or **capability**? Knowledge → skill. Context → subagent. Capability → MCP server. The full-stack cases use all three, layered. And when in doubt, build the cheapest artifact that moves your axis — a markdown file beats a deployed service every time it can.
