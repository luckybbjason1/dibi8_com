---
title: Hermes Agent：Self-Improving AI Agent That Evolves With You
description: Hermes Agent is an open-source AI agent from Nous Research with a self-learning
  loop — creates skills from experience, continuously improves, remembers your preferences,
  and gets better the more you use it.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Docker
- Go
- Python
- Rust
- TypeScript
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "210.6 MB"
file_md5: ''
download_url: https://github.com/NousResearch/hermes-agent
backup_url: ''
github_repo: https://github.com/NousResearch/hermes-agent
stars: 156248
maintainer: "NousResearch"
last_maintained: "2026-05-16"
featureImage: ''
draft: false
aliases:
- /en/posts/hermes-agent-self-improving-ai-agent/
- /posts/genericagent-self-evolving-ai-agent/
- /posts/hermes-agent-self-improving-ai-agent/
faqs:
  - q: 'What makes Hermes Agent different from tools like Claude Code, Cursor, or GitHub Copilot?'
    a: 'Hermes Agent has a built-in self-learning loop, persistent memory across sessions, and a skills system that none of those tools offer. It also runs on 6 messaging platforms, supports cron scheduling and MCP, and is open source and self-hostable, while the others are CLI-, desktop-, or IDE-only and charge subscription or API fees.'
  - q: 'How does Hermes Agent''s self-improvement loop work?'
    a: 'After completing a task, Hermes analyzes what worked and what didn''t, extracts reusable patterns, creates a skill file documenting the approach, tests that skill on similar tasks, and refines it based on results. Over time this builds a personal skill library unique to the user.'
  - q: 'What kind of memory does Hermes Agent keep between sessions?'
    a: 'Hermes maintains two types of memory: User Profile Memory (coding style, projects, preferred tools, communication preferences, and common mistakes) and Session Memory (current project context, recent commands and outputs, and edited files). The profile memory persists even after restarting your computer.'
  - q: 'What messaging platforms can Hermes Agent run on?'
    a: 'Hermes Agent works as a multi-platform messaging bot on Telegram, Discord, Slack, WhatsApp, Signal, and Email, all configured via the `hermes gateway setup` command. The same commands and skills work across every platform.'
  - q: 'How do you install Hermes Agent and configure an LLM provider?'
    a: 'On Linux, macOS, or WSL2 you can install with a one-line curl script piped to bash, or clone the repo and run `./setup-hermes.sh`. You then set a provider with commands like `hermes config set provider openai` and `hermes config set model gpt-4o`, or use a local model via `hermes config set provider ollama`.'
---
{</* resource-info */>}

## The Problem: Most AI Agents Forget You

You spend hours teaching an AI assistant your workflow, your coding style, your project structure. Then you start a new session — and it's all gone. The agent treats you like a stranger every single time.

This is the fundamental limitation of most AI agents today: **no memory, no learning, no growth**. They're stateless by design, which makes them powerful tools but terrible long-term partners.

**Hermes Agent** solves this with a radical approach: it's the only agent with a built-in learning loop.

## What is Hermes Agent?

[Hermes Agent](https://github.com/NousResearch/hermes-agent) is an open-source AI agent created by [Nous Research](https://nousresearch.com) — the same team behind the Hermes family of open-source LLMs. With **136,579+ stars** on GitHub and **20,960+ forks**, it's one of the most popular AI agent frameworks in existence.

The project's tagline says it all: **"The agent that grows with you."**

Unlike other agents that are static tools, Hermes Agent:
- **Creates skills from experience** — learns your workflows and saves them as reusable skills
- **Improves skills during use** — refines its abilities based on feedback
- **Persists knowledge across sessions** — remembers who you are and what you like
- **Builds a deepening model of you** — the more you use it, the better it understands you

## Key Features

### 1. Built-in Learning Loop

Hermes Agent's core innovation is its **self-improvement cycle**:

```
Experience → Reflection → Skill Creation → Practice → Improvement
```

When you complete a task with Hermes, it:
1. **Analyzes** what worked and what didn't
2. **Extracts** reusable patterns
3. **Creates** a skill file documenting the approach
4. **Tests** the skill on similar tasks
5. **Refines** based on results

Over time, this creates a **personal skill library** that's unique to you.

### 2. 40+ Built-in Tools

Hermes Agent comes with a comprehensive toolset:

| Tool Category | Examples |
|-------------|---------|
| **File Operations** | Read, write, search, diff, patch |
| **Terminal** | Execute commands, shell sessions, background jobs |
| **Web** | Browse, scrape, download, API calls |
| **Code** | Syntax check, lint, format, test |
| **Git** | Commit, branch, diff, log, PR review |
| **System** | Process management, file monitoring, cron jobs |

The **toolset system** lets you enable only the tools you need, reducing token usage and improving focus.

### 3. Skills System (Procedural Memory)

Skills are Hermes Agent's secret weapon. They're **reusable procedure files** that capture:

- **Trigger conditions** — when to use this skill
- **Step-by-step instructions** — what to do
- **Pitfalls** — common mistakes to avoid
- **Verification steps** — how to confirm success

Example skill structure:
```yaml
---
name: "hugo-blog-deploy"
trigger: "deploy hugo blog"
steps:
  1. "Run hugo --minify --cleanDestinationDir"
  2. "Verify build succeeded"
  3. "Run deploy.sh"
  4. "Check live site with curl"
pitfalls:
  - "Future dates prevent building"
  - "Cloudflare cache may show stale content"
verification:
  - "curl -s https://site.com | grep title"
```

Skills can be:
- **Created automatically** from successful task completions
- **Downloaded from Skills Hub** — community-contributed skills
- **Written manually** for your specific workflows
- **Shared** with other users

### 4. Persistent Memory

Hermes Agent maintains **two types of memory**:

**User Profile Memory**:
- Your preferred coding style
- Projects you work on
- Tools you like
- Communication preferences
- Common mistakes you make (so it can catch them)

**Session Memory**:
- Current project context
- Recent commands and outputs
- Files you've been editing
- Conversations from this session

This memory persists across sessions, so Hermes **remembers you** even after you restart your computer.

### 5. Messaging Gateway

Hermes Agent isn't just a CLI tool — it's a **multi-platform messaging bot**:

| Platform | Setup | Use Case |
|---------|-------|---------|
| **Telegram** | `hermes gateway setup` | Mobile AI assistant |
| **Discord** | `hermes gateway setup` | Team collaboration |
| **Slack** | `hermes gateway setup` | Workplace integration |
| **WhatsApp** | `hermes gateway setup` | Personal assistant |
| **Signal** | `hermes gateway setup` | Privacy-focused |
| **Email** | `hermes gateway setup` | Async workflows |

Once configured, you can chat with Hermes from any of these platforms using the same commands and skills.

### 6. MCP Integration

Hermes Agent supports the **Model Context Protocol (MCP)**, allowing it to connect to any MCP server for extended capabilities:

- **Database servers** — query SQL databases
- **File servers** — access remote file systems
- **API servers** — interact with any REST API
- **Custom servers** — build your own integrations

This makes Hermes infinitely extensible — if you can build an MCP server, Hermes can use it.

### 7. Cron Scheduling

Hermes Agent can run **scheduled tasks** via its built-in cron system:

```bash
# Run a skill every day at 9 AM
hermes cron add --skill "daily-report" --schedule "0 9 * * *"

# Run a backup every week
hermes cron add --skill "backup-database" --schedule "0 2 * * 0"

# List all scheduled jobs
hermes cron list
```

Perfect for automation workflows that need to run on a schedule.

### 8. Security Features

Hermes Agent takes security seriously:

- **Command approval** — risky commands require explicit confirmation
- **DM pairing** — verify your identity before sensitive operations
- **Container isolation** — run untrusted code in isolated environments
- **Audit logging** — all actions are logged for review

## Quick Start

### Installation

```bash
# One-line install (Linux, macOS, WSL2)
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# Or clone and setup manually
git clone https://github.com/NousResearch/hermes-agent.git
cd hermes-agent
./setup-hermes.sh
```

### First Conversation

```bash
source ~/.bashrc    # reload shell
hermes              # start chatting
```

### Configure Providers

```bash
# Set your preferred LLM provider
hermes config set provider openai
hermes config set model gpt-4o

# Or use local models
hermes config set provider ollama
hermes config set model llama3.1
```

### Useful Commands

```bash
# Start fresh conversation
/new

# Change model on the fly
/model anthropic:claude-3-5-sonnet

# Set a personality
/personality developer

# Check your usage
/usage

# Browse available skills
/skills

# Use a specific skill
/hugo-blog-deploy

# Compress context to save tokens
/compress
```

## Architecture

Hermes Agent is built with a modular architecture:

```
Hermes Agent
├── CLI Interface (terminal UI)
├── Messaging Gateway (Telegram, Discord, etc.)
├── Agent Core (reasoning engine)
├── Skills System (procedural memory)
├── Memory Store (persistent storage)
├── Toolset Manager (40+ tools)
├── MCP Client (external integrations)
├── Cron Scheduler (automated tasks)
└── Security Layer (approval, isolation)
```

The entire system is written in **Python** (28M+ lines) with TypeScript components for the web interface.

## Use Cases

### For Developers
- **Code review assistant** — Hermes learns your codebase and reviews PRs
- **DevOps automation** — Deploy, monitor, and troubleshoot infrastructure
- **Documentation writer** — Auto-generate docs from code comments
- **Bug hunter** — Search for patterns that caused past bugs

### For Teams
- **Shared skill library** — Team-wide best practices as reusable skills
- **Onboarding accelerator** — New team members get instant access to team knowledge
- **24/7 operations** — Cron jobs handle routine maintenance
- **Multi-platform access** — Chat with Hermes from Slack, Discord, or Telegram

### For Power Users
- **Personal knowledge base** — Hermes remembers everything you teach it
- **Workflow automation** — Complex multi-step tasks become one command
- **Cross-platform assistant** — Same assistant on desktop, mobile, and web
- **Custom integrations** — Build MCP servers for your specific tools

## Performance Comparison

| Feature | Hermes Agent | Claude Code | Cursor | GitHub Copilot |
|---------|-------------|-----------|--------|----------------|
| **Self-learning** | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **Persistent memory** | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **Skills system** | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **Multi-platform** | ✅ 6 platforms | ❌ CLI only | ❌ Desktop only | ❌ IDE only |
| **Open source** | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **Cron scheduling** | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **MCP support** | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **Free tier** | ✅ Self-hosted | 💰 API costs | 💰 Subscription | 💰 Subscription |

## Limitations

- **Learning curve** — The skills system requires upfront investment
- **Local setup** — Self-hosting requires technical knowledge
- **Resource usage** — Persistent memory consumes storage over time
- **Provider costs** — LLM API calls still cost money (unless using local models)


---

## Related Articles

- [AI Tools Directory 2024](/resources/dev-utils/ai-tools-directory/) - 200+ tools
- [DS4: DeepSeek V4 Flash](/resources/ai-tools/ds4-deepseek-flash-local-inference/) - Local inference
- MemPalace: AI Memory - AI memory
- [Agent Reach: Internet Access](/resources/llm-frameworks/agent-reach-ai-agent-internet-access/) - AI internet
- Product Hunt Alternatives - Launch

## Conclusion

Hermes Agent represents a **fundamental shift** in how we think about AI assistants. Instead of treating AI as a disposable tool, Hermes treats it as a **long-term partner** that grows alongside you.

The self-improving loop, persistent memory, and skills system create a compounding effect: the more you use Hermes, the more valuable it becomes. This is the opposite of traditional AI tools that provide diminishing returns over time.

If you're tired of re-teaching your AI assistant the same things every session, Hermes Agent is worth exploring.

**GitHub**: [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)  
**Documentation**: [hermes-agent.nousresearch.com/docs](https://hermes-agent.nousresearch.com/docs/)  
**Stars**: 136,579+ | **Forks**: 20,960+ | **License**: Open Source  

Have you tried Hermes Agent? What's your experience with self-improving AI agents? Share your thoughts in the comments.

## Related Articles

- [Agent Reach: Give Your AI Agent Internet Superpowers](/resources/llm-frameworks/agent-reach-ai-agent-internet-access/)
- [Free Claude Code: Use Claude Code CLI for Free with Any AI Provider](/resources/ai-tools/free-claude-code-open-source-proxy/)
- [42 Real-World OpenClaw Use Cases: How People Use AI Agents in Daily Life](/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/)

---

## Recommended Infrastructure for Self-Hosting

If you want to run this stack reliably 24/7, infrastructure choice matters:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

<!--auto-references-->
## References & Sources

- [Model Context Protocol (MCP)](https://modelcontextprotocol.io)
- [Ollama](https://github.com/ollama/ollama)
- [Docker](https://docs.docker.com)
- [Nous Research](https://nousresearch.com)
