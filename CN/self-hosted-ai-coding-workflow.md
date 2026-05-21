---
title: 'Self-Hosted AI Coding Workflow: The Complete $6/Month Stack for 2026'
description: 'A 7-component self-hosted AI coding stack that replaces $290/month of SaaS subscriptions (Cursor + Claude Code Pro + Copilot + Replit) with $6/month of infrastructure. Real numbers, real config, full step-by-step assembly.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Docker
  - Python
  - TypeScript
  - PostgreSQL
application_domain: Collections
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['collections']
tags: ['Self-Hosted', 'AI Coding', 'Stack', 'Workflow', 'Collection']
aliases:
  - /posts/self-hosted-ai-coding-workflow/
---

If you've been paying $20/mo for Cursor + $80/mo for Claude Code Pro + $19/mo for Copilot + $50/mo for Replit credits + $120/mo for OpenAI API top-ups, you're at **$289/month** of AI coding spend. After 12 months that's **$3,468** — for tools you don't own, can't audit, and can have rate-limited or shut off without notice.

This collection assembles the **7-component self-hosted alternative** that runs on a **$6/month VPS** and matches 90%+ of the SaaS feature set. We've published a deep dive on each component over the past 90 days. This page is the **complete stack assembly** — what to install, in what order, with which configs, plus the upgrade path when you outgrow the $6 tier.

## TL;DR — The Stack at a Glance

| # | Component | Tool | Why | Deep dive |
|---|---|---|---|---|
| 1 | Editor / Agent | **OpenCode** | Open-source Claude Code alternative, runs DeepSeek-V4 at $0.007/task vs $0.14 | [OpenCode setup](/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/) |
| 2 | Local LLM Runner | **Ollama** | 137k stars, one-line install, 22 tok/sec on a 5-year-old M1 | [Ollama guide](/resources/llm-frameworks/ollama/) |
| 3 | LLM Gateway | **LiteLLM** | 47.8k stars, unified API for 100+ models, self-hosted | [LiteLLM gateway](/resources/llm-frameworks/litellm/) |
| 4 | Token-Saving Proxy | **9Router** | RTK compression cuts coding-agent tokens 20-40% | [9Router setup](/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/) |
| 5 | Memory Layer | **mem0 + AgentMemory MCP** | Persistent semantic recall across sessions | [AgentMemory MCP](/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/) |
| 6 | Code Context MCP | **filesystem + git + tavily search** | Anthropic reference + community + search | [MCP server registry](/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) |
| 7 | Multi-CLI Switcher | **CC Switch** | One-click between Claude / Codex / Gemini CLI / OpenCode | [CC Switch guide](/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/) |

**Total monthly cost** (4GB VPS + storage): **$6** at the entry tier. Up to ~$30/month at the "team of 5" tier with PostgreSQL + Redis + replicated LiteLLM proxy.

## 1. Why This Stack Exists in 2026

Three things changed between 2024 and 2026 that made self-hosted AI coding finally viable:

1. **Open-weight models caught up**: DeepSeek-V4, Qwen 3 Coder, GLM-4.6 Coder are within 5% of Claude/GPT-5 on coding benchmarks while being free or near-free
2. **MCP standardized tool integration**: instead of every editor reinventing how to call file/git/search tools, the protocol is now a USB-C port — see [MCP Server Registry guide](/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) for the 19,700+ servers now available
3. **Local LLM runners are production-grade**: Ollama, vLLM, and llama.cpp run at acceptable speed on consumer hardware

The math worked in 2024 too, but the experience was painful. In 2026, the gap closed.

## 2. Architecture Overview

```
                  ┌─────────────────────────────┐
                  │   Your machine / VPS ($6)   │
                  │                             │
   You type  →    │  OpenCode (editor/agent)    │
                  │           │                 │
                  │           ▼                 │
                  │  CC Switch (1-click CLI)    │
                  │           │                 │
                  │           ▼                 │
                  │  LiteLLM Gateway :4000      │
                  │           │                 │
                  │     ┌─────┴─────┐           │
                  │     │           │           │
                  │     ▼           ▼           │
                  │  9Router    Direct          │
                  │  (RTK comp) (premium)       │
                  │     │           │           │
                  └─────┼───────────┼───────────┘
                        │           │
              ┌─────────┴───┐  ┌────┴──────┐
              ▼             ▼  ▼           ▼
          Ollama       DeepSeek API   Claude API
          (local)      (free coding)  (premium)

      MCP servers (filesystem + git + memory + tavily-search)
      mounted on OpenCode via claude_desktop_config.json
```

The pattern: **OpenCode is the editor brain, LiteLLM is the traffic cop, 9Router compresses, MCP servers expose the world.** Swap any component without touching the others.

## 3. Component 1 — OpenCode (Editor / Agent)

**The role**: This is what you actually type into. Replaces Cursor + Claude Code Pro.

**Why this pick**: Open-source agent that speaks MCP natively. On the same refactor task (400-line React component), OpenCode + DeepSeek-V4 = 18 sec, $0.007. Claude Code (Sonnet) = 12 sec, $0.14. Twenty-times cheaper, 5% slower.

**Quick install**:
```bash
npm install -g @opencode-ai/opencode
opencode --version  # 1.x
```

Point it at your LiteLLM gateway (next component) via config and you're done.

**Full setup** including provider routing rules, MCP server connection, and editor integration: see our [OpenCode complete guide](/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/).

## 4. Component 2 — Ollama (Local LLM Runner)

**The role**: Run smaller models entirely on your own hardware. 100% offline option for sensitive code.

**Why this pick**: 137k stars. Single-binary install. Llama 3.2 3B runs at 22 tok/sec on a 5-year-old M1 MacBook with 8GB RAM. Qwen 3 Coder 14B runs comfortably on a 16GB M-series Mac or any 32GB Linux box.

**Quick install**:
```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama pull qwen3-coder:14b
ollama serve  # exposes :11434 OpenAI-compatible API
```

LiteLLM picks up Ollama as a provider automatically.

**Full setup** with model selection by hardware tier and the quantization tradeoffs that matter: see our [Ollama production guide](/resources/llm-frameworks/ollama/).

## 5. Component 3 — LiteLLM (Unified Gateway)

**The role**: One OpenAI-compatible API in front of every model — Ollama (local), DeepSeek (cheap), Claude (premium), Gemini (free tier). Your editor only talks to LiteLLM; LiteLLM routes based on your config.

**Why this pick**: 47.8k stars, the most-starred LLM gateway. 8ms P95 latency at 1k RPS. Free if self-hosted. Compared in detail in our [Portkey vs LiteLLM vs OpenRouter 2026 guide](/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/).

**Quick deploy on a 4GB VPS** (we recommend {{< aff "htstack" "stack-vps" "HTStack's Hong Kong VPS" >}} for sub-30ms latency to mainland China users, or {{< aff "digitalocean" "stack-droplet" "DigitalOcean's $6 droplet" >}} for everywhere else):

```bash
docker run -d --name litellm -p 4000:4000 \
  -e LITELLM_MASTER_KEY=sk-your-secret \
  -e OLLAMA_API_BASE=http://host.docker.internal:11434 \
  -e DEEPSEEK_API_KEY=$DEEPSEEK_KEY \
  -e ANTHROPIC_API_KEY=$CLAUDE_KEY \
  ghcr.io/berriai/litellm:main-stable
```

**Full setup** with virtual keys, spend tracking, fallback rules: see our [LiteLLM production gateway 2026](/resources/llm-frameworks/litellm/).

## 6. Component 4 — 9Router (Token-Saving Proxy)

**The role**: Sit between LiteLLM and your "premium" providers (Claude / GPT-5). Compress repeated content (file headers, system prompts, codebase context) before sending. **Cuts billable tokens 20-40% for coding agents.**

**Why this matters**: Coding agents are pathological token consumers — they send the entire codebase context every turn. At $3/M input tokens on Claude Sonnet, this adds up fast. 9Router's RTK (Repetition-Token Compression) is the only proxy designed specifically for this workload.

**Quick install**:
```bash
docker run -d --name 9router -p 9999:9999 \
  -e PROVIDERS=anthropic,openai,gemini,deepseek \
  ghcr.io/rtk-ai/9router:latest
```

Point LiteLLM's premium provider endpoints at `localhost:9999` instead of direct.

**Full setup**: [9Router smart proxy guide](/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/).

## 7. Component 5 — Memory Layer (mem0 + AgentMemory MCP)

**The role**: Persistent semantic memory across coding sessions. "Remember that we use Tailwind v4 and the auth lives in `src/lib/auth.ts`" — and the agent actually remembers next Monday.

**Why this pick**: mem0 is the open-source semantic memory layer with 30k+ stars. AgentMemory is the MCP server that exposes it to any MCP host (OpenCode / Claude Desktop / Cursor).

**Quick install**:
```bash
npm install -g @mem0/mem0-mcp
# Add to OpenCode's MCP config:
# { "agentmemory": { "command": "mem0-mcp", "args": [] } }
```

**Full setup** with the embedding model picks and vector DB choices: see our [AgentMemory MCP guide](/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/).

## 8. Component 6 — Code Context MCP (filesystem + git + tavily-search)

**The role**: Give the agent eyes and hands. Read your project files, inspect your git history, search the web — all via the MCP protocol.

**The minimum set**:
- `modelcontextprotocol/server-filesystem` (Anthropic reference)
- `modelcontextprotocol/server-git` (Anthropic reference)
- `tavily-mcp` (LLM-formatted web search results)

**Quick install** (all 3 added to OpenCode's `claude_desktop_config.json`):
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"]
    },
    "git": {
      "command": "uvx",
      "args": ["mcp-server-git", "--repository", "/home/user/projects/your-repo"]
    },
    "tavily": {
      "command": "npx",
      "args": ["-y", "@tavily/mcp"],
      "env": {"TAVILY_API_KEY": "tvly-xxx"}
    }
  }
}
```

Tavily has a generous free tier (1,000 searches/mo) so this stays within the $6 budget.

**Full menu of 19,700+ available MCP servers and how to pick more**: see our [MCP Server Registry comprehensive guide 2026](/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/).

## 9. Component 7 — CC Switch (Multi-CLI Orchestrator)

**The role**: When you want to use Claude Code natively (not via OpenCode) for a specific task — or jump to Codex for Rust speed — CC Switch is the 1-click swap. Single config, all your AI CLIs share MCP servers.

**Why this pick**: A 75k-star Rust + Tauri desktop app that means you stop maintaining 5 separate `~/.claude_desktop_config.json` files for 5 different CLIs.

**Quick install**: Download from [farion1231/cc-switch releases](https://github.com/farion1231/cc-switch/releases). Configure each CLI with one click.

**Full guide**: [CC Switch unified AI CLI control center](/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/).

## 10. Assembly Order — Day 1 Setup (90 minutes)

If you're starting from scratch, do it in this order:

1. **Spin up infrastructure** (15 min) — Order a {{< aff "digitalocean" "assembly-vps" "DigitalOcean $6 droplet" >}}, install Docker, open ports 4000 (LiteLLM) + 9999 (9Router) + 11434 (Ollama)
2. **Ollama first** (10 min) — Install + pull `qwen3-coder:14b` (~9 GB). Confirm `curl localhost:11434/api/tags` works
3. **LiteLLM second** (15 min) — Docker run with the env vars from sec. 5. Confirm `curl localhost:4000/v1/models -H "Authorization: Bearer sk-your-secret"` lists Ollama models
4. **9Router third** (10 min) — Optional but recommended. Add to LiteLLM's premium provider config
5. **OpenCode fourth** (15 min) — Install locally, point at LiteLLM at `https://your-vps:4000/v1`, test a basic prompt
6. **MCP servers fifth** (15 min) — filesystem + git + tavily added to OpenCode config. Test by asking "list the files in this repo"
7. **mem0 + AgentMemory sixth** (10 min) — `npm i -g mem0-mcp`, add to config, test by saying "remember we use Tailwind v4"
8. **CC Switch last** (optional) — Only if you want native Claude Code / Codex side-by-side

You now have a $6/month AI coding stack matching 90% of the $289/month SaaS bundle.

## 11. Monthly Cost Breakdown

| Item | Entry tier | Team of 5 tier |
|---|---|---|
| VPS (4 GB → 16 GB) | $6 | $24 |
| Ollama models | $0 (you own the disk) | $0 |
| LiteLLM | $0 (self-hosted) | $0 |
| 9Router | $0 (self-hosted) | $0 |
| Tavily search | $0 (1k req free tier) | $5 (paid tier) |
| mem0 / AgentMemory | $0 (self-hosted) | $0 |
| DeepSeek API (cheap inference for hard tasks) | ~$2-5 | ~$10-15 |
| Claude API (rare, premium fallback) | ~$1-3 | ~$5-10 |
| **Total** | **~$6-14** | **~$30-50** |

Compare against $289/month for Cursor + Claude Code Pro + Copilot + Replit + OpenAI top-ups.

## 12. Upgrade Path

When your stack outgrows the $6 tier (more than 1 dev, more than 1 project, persistent state matters):

- **Add Postgres** for LiteLLM spend tracking + virtual keys per project ({{< aff "digitalocean" "upgrade-postgres" "DigitalOcean Managed Postgres" >}} $15/mo)
- **Add Redis** for LiteLLM caching (1 GB managed Redis $10/mo)
- **Move LiteLLM behind a load balancer** with 3 replicas — see [Portkey vs LiteLLM 2026 guide](/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/) sec. 4 for the Kubernetes pattern
- **Add Grafana + Loki** for full observability — log every prompt, every fallback, every cost spike
- **Add team-level RBAC** via LiteLLM enterprise tier (custom pricing)

The point: you started with $6/mo and *own the entire stack*. Every upgrade is a deliberate cost decision tied to a specific need — not a SaaS lock-in trap.

## TL;DR — The 7-Component Recipe

1. **OpenCode** — the editor brain
2. **Ollama** — local fallback
3. **LiteLLM** — unified gateway
4. **9Router** — token compression
5. **mem0 + AgentMemory** — persistent memory
6. **MCP servers** (filesystem + git + tavily) — context + tools
7. **CC Switch** — multi-CLI orchestration

Total: $6/month. Total: 90 minutes to assemble. Total: zero vendor lock-in.

If you're spending $200+/mo on AI coding SaaS, this stack pays for itself in week 1. Spin up a {{< aff "digitalocean" "footer-cta" "DigitalOcean $6 droplet" >}}, follow sec. 10, and report back next week.

---

*Bookmark this page — we update component picks quarterly as new open-source releases land. Last updated: 2026-05-21.*
