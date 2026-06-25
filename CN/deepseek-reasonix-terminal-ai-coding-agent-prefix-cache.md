---
title: 'DeepSeek-Reasonix: Terminal AI Coding Agent Engineered for DeepSeek Prefix-Cache Stability'
description: 'A DeepSeek-native AI coding agent with engineered prefix-cache stability — 99.82% cache hit rate, ~$12/day for heavy usage vs ~$61 without cache. MIT licensed. Claude Code alternative using DeepSeek models.'
tags: ["ai-agent", "automation", "cli", "coding", "dev-tools", "development", "open-source", "terminal"]
date: 2026-06-22
lastmod: 2026-06-22
draft: false
categories: ['ai-tools']
slug: deepseek-reasonix-terminal-ai-coding-agent-prefix-cache
featureImage: /images/articles/deepseek-tui-anthropic-financial-agents--117cfa-1.png
aliases: ['/deepseek-reasonix']
sources:
  - name: 'GitHub'
    url: 'https://github.com/esengine/DeepSeek-Reasonix'
  - name: 'Website'
    url: 'https://esengine.github.io/DeepSeek-Reasonix/'
  - name: 'Discord'
    url: 'https://discord.gg/XF78rEME2D'
lang: en
---
---
title: 'DeepSeek-Reasonix: Terminal AI Coding Agent Engineered for DeepSeek Prefix-Cache Stability'
description: 'A DeepSeek-native AI coding agent with engineered prefix-cache stability — 99.82% cache hit rate, ~$12/day for heavy usage vs ~$61 without cache. MIT licensed. Claude Code alternative using DeepSeek models.'
date: 2026-06-22
lastmod: 2026-06-22
draft: false
tags: ['AI Tools', 'Coding Agent', 'DeepSeek', 'Terminal', 'Self-Hosted', 'Open Source']
categories: ['ai-tools']
slug: deepseek-reasonix-terminal-ai-coding-agent-prefix-cache

aliases: ['/deepseek-reasonix']
sources:
  - name: 'GitHub'
    url: 'https://github.com/esengine/DeepSeek-Reasonix'
  - name: 'Website'
    url: 'https://esengine.github.io/DeepSeek-Reasonix/'
  - name: 'Discord'
    url: 'https://discord.gg/XF78rEME2D'
---

# DeepSeek-Reasonix: Terminal AI Coding Agent Engineered for DeepSeek Prefix-Cache Stability

TL;DR — **DeepSeek-Reasonix** (aka Reasonix) is a terminal-first AI coding agent built exclusively around DeepSeek models, engineered for **prefix-cache stability** that keeps token costs dramatically lower than competing agents across long sessions. Real-world users report **99.82% cache hit rates** — paying ~$12/day for 435M input tokens instead of ~$61 without cache. MIT licensed, with an embedded web dashboard, configurable search engines, persistent sessions, and full MCP/skills/hooks support.

## What Is DeepSeek-Reasonix?

Reasonix is an AI coding agent for your terminal. Unlike general-purpose agents that support multiple backends, Reasonix is **DeepSeek-only by design** — every layer is tuned to leverage DeepSeek's prefix-cache mechanism for cost stability across long coding sessions.

The core insight: **cache stability isn't a feature you turn on; it's an invariant the loop is designed around.** By engineering the entire agent loop around byte-stable prefix caching, Reasonix keeps costs predictable even for heavy daily usage.

**GitHub:** [esengine/DeepSeek-Reasonix](https://github.com/esengine/DeepSeek-Reasonix) · **Stars:** 23,000+ · **License:** MIT · **Language:** TypeScript (Go rewrite in progress)

> **Note:** The current TypeScript line (0.x) is in maintenance mode. Active development has moved to a **Go rewrite** on the [`main-v2`](https://github.com/esengine/DeepSeek-Reasonix/tree/main-v2) branch. See the [migration guide](https://github.com/esengine/DeepSeek-Reasonix/blob/main-v2/docs/MIGRATING.md) for details.

## The Three Pillars

### 1. Cache-First Loop

Reasonix's agent loop is designed to maximize prefix-cache hits. Every layer — from how prompts are structured to how tool calls are repaired — is optimized to keep the token stream cacheable. This is the foundation that makes the cost savings possible.

### 2. Tool-Call Repair

When a tool call fails or produces unexpected output, Reasonix repairs it intelligently rather than restarting the entire conversation. This prevents cache invalidation from single-point failures and keeps the prefix cache warm across extended sessions.

### 3. Cost Control

Built-in cost tracking and optimization at every level. The agent maintains a web dashboard showing real-time cache hit rates, token consumption, and cost projections. Users can configure spending limits and receive alerts.

## Real-World Cost Case Study

A single user on 2026-05-01 processed **435 million input tokens** in one day:

| Metric | With Reasonix Cache | Without Cache |
|--------|--------------------|---------------|
| Input tokens | 435M | 435M |
| Cache hit rate | **99.82%** | 0% |
| Estimated cost | **~$12** | **~$61** |
| Savings | **80% cheaper** | Baseline |

The savings compound over time. For teams running Reasonix across multiple developers, daily costs can drop from hundreds to tens of dollars.

## Capabilities

- **Plan Mode** — Structured planning before execution, reducing wasted tokens
- **Cell-Diff Renderer** — Visual diff output for code changes
- **MCP Server Support** — stdio, SSE, and Streamable HTTP transport
- **Persistent Sessions** — Per-workspace session storage with auto-checkpoints
- **Skills System** — Markdown playbooks the model can invoke (inline or subagent mode)
- **Memory System** — User-private knowledge pinned into the conversation prefix (user/feedback/project/reference types)
- **Hooks** — Shell commands on lifecycle events (PreToolUse gating, PostToolUse, UserPromptSubmit, Stop)
- **Embedded Web Dashboard** — Real-time cost monitoring, session management, and configuration
- **Configurable Web Search** — Bing (default), Baidu AI Search, SearXNG, Metaso, Tavily, Perplexity, Exa, Brave, or Ollama
- **Semantic Index** — Local Ollama or any OpenAI-compatible embedding endpoint
- **Transcript Replay** — Replay any session with full context
- **Event Log** — Detailed audit trail of all agent actions
- **Effort Knob** — Control reasoning depth per task

## Installation

Requires **Node.js ≥ 22**. Works on macOS, Linux, and Windows (PowerShell, Git Bash, Windows Terminal).

### Global Install (Recommended for Daily Use)

```bash
npm install -g reasonix
reasonix code my-project
```

On first run, paste your DeepSeek API key — it persists securely.

### One-Shot (No Global Install)

```bash
cd my-project
npx reasonix code
```

Always uses the latest package version.

### Short Alias

```bash
npm install -g dsnix    # exposes `dsnix` on PATH
npx dsnix@latest code   # one-shot via shorter command
```

A global `npm install -g reasonix` also drops a `dsnix` shim, so the two are interchangeable. Bare `reasonix` (no subcommand) launches `code` in the current directory.

### Get a DeepSeek API Key

Grab one at [platform.deepseek.com/api_keys](https://platform.deepseek.com/api_keys).

## CLI Commands

| Command | Description |
|---------|-------------|
| `reasonix` / `reasonix code [dir]` | The coding agent. **Start here.** |
| `reasonix chat` | Plain chat — no filesystem or shell tools. |
| `reasonix run "task"` | One-shot, streams to stdout. Good for pipes. |
| `reasonix doctor` | Health check: Node, API key, MCP wiring. |
| `reasonix update` | Upgrade Reasonix itself. |
| `reasonix replay` | Replay a previous session. |
| `reasonix diff` | Show pending changes. |
| `reasonix events` | View event log. |
| `reasonix stats` | Cost and usage statistics. |
| `reasonix index` | Semantic indexing. |
| `reasonix mcp` | MCP server management. |
| `reasonix prune-sessions` | Clean up old sessions. |

## Configuration

One JSON file at `~/.reasonix/config.json` plus per-project overrides under `<project>/.reasonix/`. The full configuration reference lives at [esengine.github.io/DeepSeek-Reasonix/configuration.html](https://esengine.github.io/DeepSeek-Reasonix/configuration.html).

### Basic Config File

```json
{
  "model": "deepseek-chat",
  "apiKey": "sk-your-key-here",
  "searchEngine": "bing",
  "hooks": {
    "PreToolUse": ["echo 'Running pre-tool hook'"],
    "PostToolUse": ["echo 'Tool completed'"],
    "Stop": ["echo 'Session ended'"]
  },
  "permissions": {
    "allowList": ["/usr/bin/git", "/usr/bin/docker"]
  }
}
```

### MCP Server Configuration

Reasonix supports MCP servers via stdio, SSE, and Streamable HTTP transport. One spec format works for both `config.json` and the `--mcp` flag:

```bash
# Start an MCP server and connect Reasonix
reasonix code --mcp http://localhost:3000/sse
```

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/tmp"]
    }
  }
}
```

### Skills System

Skills are Markdown playbooks the model can invoke in `inline` or `subagent` mode. They encode domain knowledge directly into the agent's workflow:

```markdown
---
name: my-custom-skill
mode: inline
---

# My Custom Skill

When the user mentions database migrations, follow these steps:
1. Run `reasonix doctor` to check health
2. Review the migration plan
3. Execute the migration
```

### Memory System

Reasonix supports four types of memory pinned into the conversation prefix:

- **`user`** — Personal knowledge about the developer (preferred patterns, coding style)
- **`feedback`** — Corrections and preferences learned from past sessions
- **`project`** — Architecture decisions, tech stack details, team conventions
- **`reference`** — Documentation excerpts, API references, code patterns

### Hooks and Lifecycle Events

Hooks are shell commands triggered on lifecycle events. Use `PreToolUse` for gating expensive operations:

```bash
# Only allow git operations in approved repos
# .reasonix/hooks/pre-tool-use.sh
if [[ ! "$REPO_PATH" =~ ^(~/projects/app|~/projects/lib)$ ]]; then
  echo "ERROR: Repository not in allowlist"
  exit 1
fi
```

### Web Search Engines

Switch the default search engine with `/search-engine`:

| Engine | Command | Use Case |
|--------|---------|----------|
| Bing | `/search-engine bing` | Default, broad coverage |
| Baidu AI Search | `/search-engine baidu` | Chinese-language results |
| SearXNG | `/search-engine searxng` | Self-hosted, privacy-focused |
| Metaso | `/search-engine metaso` | Technical/engineering focus |
| Tavily | `/search-engine tavily` | AI research oriented |
| Perplexity | `/search-engine perplexity` | Citation-rich answers |
| Exa | `/search-engine exa` | Semantic search |
| Brave | `/search-engine brave` | Privacy-respecting |
| Ollama | `/search-engine ollama` | Fully local, no API key |

### Semantic Index

Build a local semantic index for codebase-aware search:

```bash
# Index current project with local Ollama
reasonix index --provider ollama --model nomic-embed-text

# Or use any OpenAI-compatible endpoint
reasonix index --provider openai --endpoint https://your-api.com/embeddings
```

### Permissions System

Per-workspace shell allowlist with exact-prefix matching keeps the agent safe:

```json
{
  "permissions": {
    "allowList": [
      "/usr/bin/git",
      "/usr/bin/docker",
      "/usr/local/bin/",
      "~/projects/myapp/"
    ]
  }
}
```

## Practical Usage Examples

### Starting a New Project

```bash
# Initialize Reasonix in a new project
mkdir my-app && cd my-app
reasonix code .

# On first run, paste your DeepSeek API key
# Reasonix will analyze your project structure and suggest next steps
```

### Using Plan Mode

Plan mode structures reasoning before execution, reducing wasted tokens:

```bash
# Ask Reasonix to plan before implementing
"I need to add OAuth2 authentication to this Express.js app.
Please plan the implementation first, then execute."
```

Reasonix will:
1. Analyze the existing codebase
2. Propose an architecture
3. List the files that need changes
4. Execute the changes with cell-diff rendering

### Persistent Sessions with Auto-Checkpoints

Reasonix saves session state automatically:

```bash
# Resume a previous session
reasonix replay --last

# Or list all sessions
reasonix events --sessions

# Prune old sessions to save disk space
reasonix prune-sessions --older-than 30d
```

### Using the Embedded Web Dashboard

Launch the dashboard to monitor costs and manage sessions:

```bash
# Start the dashboard (runs alongside your coding session)
reasonix dashboard

# View real-time cache hit rates and token consumption
# Navigate to http://localhost:3001 in your browser
```

The dashboard shows:
- **Cost Overview** — Real-time spending with cache savings breakdown
- **Session Manager** — Browse, resume, and compare sessions
- **Configuration Editor** — Visual config file editor
- **Event Log** — Timestamped audit trail of all agent actions
- **Cache Heatmap** — Visual representation of prefix-cache hit distribution

### One-Shot Tasks

For quick tasks without starting an interactive session:

```bash
# Run a one-shot task and stream output to stdout
reasonix run "Refactor this Python file to use type hints"

# Pipe output to another command
reasonix run "List all TODO comments in this project" | grep -i "urgent"

# Use with cron for automated code review
reasonix run "Review all changes in git diff HEAD~1" >> /tmp/review.log
```

### Doctor Health Check

Before starting a session, verify everything is configured correctly:

```bash
reasonix doctor
# Output:
# ✅ Node.js v22.4.0
# ✅ API key configured
# ✅ MCP servers: 2 connected
# ✅ Search engine: Bing
# ✅ Workspace: /home/user/my-project
# ⚠️  Permission allowlist not configured
```

## How Reasonix Compares

| Feature | Reasonix | Claude Code | Cursor | Aider |
|---------|----------|-------------|--------|-------|
| Backend | **DeepSeek** | Anthropic | OpenAI/Anthropic | Any (OpenRouter) |
| License | **MIT** | Closed | Closed | Apache 2 |
| Cost profile | **Low per task** | Premium | Subscription + usage | Varies |
| Prefix-cache | **Engineered** | N/A | N/A | Incidental |
| Web dashboard | **Yes** | — | N/A (IDE) | — |
| Configurable search | `/search-engine` | — | — | — |
| Persistent sessions | **Yes** | Partial | N/A | — |
| Plan mode / MCP / hooks | **Yes** | Yes | Yes | Partial |
| Open community | **Yes** | — | — | Yes |

## What Reasonix Is NOT

Reasonix is opinionated. Some things it deliberately doesn't do:

- **Multi-provider flexibility.** DeepSeek-only by design. Coupling to one backend is the feature, not a limitation.
- **IDE integration.** Terminal-first. The diff lives in `git diff`, the file tree in `ls`. The dashboard is a companion, not a Cursor replacement.
- **Hardest-leaderboard reasoning.** Claude Opus still wins some benchmarks. DeepSeek is competitive on coding; for "solve this PhD proof" rather than "fix this auth bug," consider Claude.
- **Air-gapped / fully-free.** Reasonix needs a paid DeepSeek API key. For air-gapped or zero-cost runs, see Aider + Ollama or [Continue](https://continue.dev).

## Getting Started Checklist

1. Install Node.js ≥ 22
2. Get a DeepSeek API key from [platform.deepseek.com](https://platform.deepseek.com)
3. Install: `npm install -g reasonix`
4. Run: `reasonix code my-project`
5. Paste your API key on first run
6. Explore the embedded web dashboard for cost monitoring
7. Configure web search: `/search-engine bing` (default) or any supported provider
8. Try `/search-engine searxng` for self-hosted search

## Documentation

- **[Architecture](https://github.com/esengine/DeepSeek-Reasonix/blob/main/docs/ARCHITECTURE.md)** — Three pillars: cache-first loop, tool-call repair, cost control
- **[CLI Reference](https://github.com/esengine/DeepSeek-Reasonix/blob/main/docs/CLI-REFERENCE.md)** — Every subcommand, slash command, and keybinding
- **[Website](https://esengine.github.io/DeepSeek-Reasonix/)** — Getting started, dashboard mockup, TUI mockup
- **[Configuration Guide](https://esengine.github.io/DeepSeek-Reasonix/configuration.html)** — Full bilingual reference (EN/ZH)
- **[Benchmarks](https://github.com/esengine/DeepSeek-Reasonix/tree/main/benchmarks)** — τ-bench-lite harness, transcripts, cost methodology
- **[Contributing](https://github.com/esengine/DeepSeek-Reasonix/blob/main/CONTRIBUTING.md)** — Comment policy, error-handling rules, library-over-hand-rolled
- **[Migration Guide](https://github.com/esengine/DeepSeek-Reasonix/blob/main-v2/docs/MIGRATING.md)** — TypeScript → Go rewrite

## Frequently Asked Questions

### Q: Is Reasonix free?

Yes. Reasonix is MIT licensed. No tracking, no analytics, no cloud dependency. Everything runs locally on your machine. You only pay for the DeepSeek API key, which is significantly cheaper than Claude or GPT-4 due to prefix caching.

### Q: Do I need a DeepSeek API key?

Yes. Reasonix is DeepSeek-only by design. Get one at [platform.deepseek.com/api_keys](https://platform.deepseek.com/api_keys). The prefix-cache engineering means your API costs are typically 70-80% lower than using DeepSeek directly without Reasonix's cache optimization.

### Q: Can I use Reasonix with other AI models?

No. Reasonix is intentionally DeepSeek-only. The prefix-cache stability is the core feature — coupling to one backend allows every layer to be optimized for DeepSeek's specific caching behavior. If you need multi-provider support, consider Aider or Continue.

### Q: How does the Go rewrite differ from the TypeScript version?

The Go rewrite (branch `main-v2`) is the actively developed version. It offers better performance, lower memory usage, and improved cache stability. The TypeScript version (0.x) is in maintenance mode — only bug fixes land there. See the [migration guide](https://github.com/esengine/DeepSeek-Reasonix/blob/main-v2/docs/MIGRATING.md) for details.

### Q: Is Reasonix suitable for teams?

Yes. Reasonix supports per-workspace configurations, allowing each developer to have their own settings while sharing project-level conventions. The persistent session system and semantic index make it easy to onboard new team members. The embedded dashboard helps managers monitor API costs across the team.

### Q: How does Reasonix handle tool-call failures?

Reasonix uses its "Tool-Call Repair" pillar to intelligently fix failed tool calls rather than restarting the entire conversation. This prevents cache invalidation from single-point failures. For example, if a shell command fails, Reasonix analyzes the error, adjusts the command, and retries — all while keeping the prefix cache warm.

### Q: Can I use Reasonix with GitLab or Bitbucket?

Yes. Reasonix works with any Git repository regardless of hosting provider. The agent interacts with your local filesystem and git commands, so it doesn't matter whether your repo is on GitHub, GitLab, Bitbucket, or self-hosted. The `reasonix doctor` command will verify your workspace setup.

### Q: What's the difference between Plan Mode and regular coding?

Plan Mode structures the agent's thinking before making changes. Instead of immediately modifying files, Reasonix will:
1. Analyze the codebase
2. Propose an architecture or approach
3. List all files that need changes
4. Execute the changes with cell-diff rendering

This reduces wasted tokens and is especially useful for complex refactoring tasks.

### Q: Does Reasonix support Windows?

Yes. Reasonix works on Windows via PowerShell, Git Bash, or Windows Terminal. The only requirement is Node.js ≥ 22. All features including MCP servers, skills, and hooks work identically on Windows.

### Q: How do I add custom skills to Reasonix?

Create a Markdown file following the skill format and place it in your project's `.reasonix/skills/` directory. Each skill can be in `inline` mode (executed as part of the main loop) or `subagent` mode (run as a separate reasoning step):

```markdown
---
name: django-best-practices
mode: inline
---

# Django Best Practices

When working with Django projects:
1. Always use class-based views for complex logic
2. Use Django ORM methods instead of raw SQL
3. Apply middleware for authentication checks
4. Use Django signals sparingly
```

Then reference it in your prompt: `/django-best-practices Refactor this view to use class-based views.`

### Q: Can I use Reasonix for code review?

Absolutely. Use the `reasonix diff` command to show pending changes, or `reasonix run "Review all changes in git diff HEAD~1"` for automated code reviews. The cell-diff renderer makes it easy to see exactly what the agent proposes to change.

### Q: How do I migrate from Claude Code to Reasonix?

Both tools use the same skill and MCP server formats. The main differences are:
- Reasonix uses DeepSeek instead of Anthropic models
- Reasonix is MIT licensed; Claude Code is closed source
- Reasonix has an embedded web dashboard; Claude Code is terminal-only
- Reasonix is terminal-first; Claude Code has IDE integration

Most skills and MCP configurations transfer directly. The main adjustment is the API key and cost profile.

### Q: What are the non-goals of Reasonix?

Reasonix deliberately does NOT:
- Support multiple AI providers (DeepSeek-only)
- Integrate with IDEs like VS Code (terminal-first)
- Compete on hardest-leaderboard reasoning benchmarks
- Work in air-gapped or zero-cost environments (requires paid API key)

If these are priorities for you, consider alternatives like Aider + Ollama or Continue.

Reasonix has an active bilingual Discord community with channels for setup help (`#help` / `#求助`), workflow showcases, feature ideas, and contributor-only PR coordination.

- **Discord:** [discord.gg/XF78rEME2D](https://discord.gg/XF78rEME2D)
- **GitHub Discussions:** Feature wishlists, design feedback, and show-and-tell
- **Good First Issues:** Scoped starter tickets with background, code pointers, and acceptance criteria
- **Advocate Badge:** Earned by sustained community contributors

## Sources

- [DeepSeek-Reasonix on GitHub](https://github.com/esengine/DeepSeek-Reasonix)
- [Reasonix Website](https://esengine.github.io/DeepSeek-Reasonix/)
- [Configuration Guide](https://esengine.github.io/DeepSeek-Reasonix/configuration.html)
- [Architecture Document](https://github.com/esengine/DeepSeek-Reasonix/blob/main/docs/ARCHITECTURE.md)
- [Benchmarks](https://github.com/esengine/DeepSeek-Reasonix/tree/main/benchmarks)

---

**Want to code with AI at a fraction of the cost?** Reasonix's engineered prefix-cache stability delivers 99%+ cache hit rates — turning $61/day into $12.

**Join the Dibi8 community:** [Telegram Group](https://t.me/DIBI8_Group/2)
