---
title: "Cut Claude Code Token Usage by 65% With Caveman — Same Quality, Fewer Tokens"
description: "Learn how Caveman, a Claude Code skill with 57K GitHub stars, reduces token usage by 65% without losing quality. Includes installation, usage, real benchmarks, and code examples."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Docker
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
github_repo: "https://github.com/JuliusBrussee/caveman.git"
stars: 61775
maintainer: "JuliusBrussee"
last_maintained: "2026-05-12"
featureImage: ""
draft: false
aliases:
- /posts/caveman/
faqs:
  - q: 'What is Caveman for Claude Code?'
    a: 'Caveman is a Claude Code skill that makes Claude respond in compressed, terse, caveman-style language by dropping filler, articles, and polite preamble. It reduces output tokens by 65% on average without losing technical accuracy.'
  - q: 'How much does Caveman reduce token usage?'
    a: 'Across the repository''s reproducible benchmarks, Caveman cut output tokens by 65% on average, ranging from 22% to 87% depending on how verbose the original task was. For example, explaining a React re-render bug dropped from 1,180 to 159 tokens (87% saved).'
  - q: 'Does Caveman make Claude less accurate or ''dumber''?'
    a: 'No. Caveman leaves the model''s thinking and reasoning tokens untouched and only compresses the final output text. The model still reasons at full capability and all technical content is preserved; only fluff is removed.'
  - q: 'How do you install Caveman for Claude Code?'
    a: 'Clone the repo into your global skills directory with ''git clone https://github.com/JuliusBrussee/caveman.git ~/.claude/skills/caveman'', then restart Claude Code. The skill auto-loads. It also supports Cursor, Cline, Windsurf, and Codex via their respective rules files.'
  - q: 'What intensity levels and commands does Caveman offer?'
    a: 'Caveman has three levels: Lite (removes filler, keeps grammar), Full (default mode, drops articles and uses fragments), and Ultra (maximum telegraphic compression). It also ships sub-commands like /caveman-commit, /caveman-review, /caveman-stats, and /caveman:compress for rewriting memory files such as CLAUDE.md.'
---
{</* resource-info */>}

If you use Claude Code daily, you have probably noticed the token counter climbing fast. Long explanations, polite filler sentences, and repeated context all add up. More tokens mean slower responses and a higher bill at the end of the month.

**Caveman** is a Claude Code skill that solves this by making Claude speak in compressed, terse language — like a caveman. The result? **65% fewer output tokens on average**, with zero loss in technical accuracy. It has already earned **57,003 stars on GitHub** and is one of the most popular productivity skills in the Claude Code ecosystem.

In this post, I will explain why token consumption matters, how Caveman works under the hood, how to install and use it, and what real benchmarks look like.

---

## Why Token Consumption Matters for Claude Code Users

Claude Code is an agentic coding assistant. Unlike a simple chatbot, it reads your codebase, runs commands, and produces multi-step plans. Every word it outputs costs tokens. Every token costs money.

Here is why controlling token usage is critical:

1. **Cost scales linearly with output length.** If Claude generates 2,000 tokens instead of 500, you pay four times as much for that single interaction.
2. **Long outputs slow you down.** Reading a wall of text to find the one code block you need wastes time.
3. **Context windows are finite.** When Claude chatters, it leaves less room for your actual code and instructions in the conversation history.
4. **Verbose does not mean better.** A March 2026 paper, *"Brevity Constraints Reverse Performance Hierarchies in Language Models"* ([arXiv:2604.00025](https://arxiv.org/abs/2604.00025)), found that forcing models to be brief **improved accuracy by 26 percentage points** on some benchmarks. Less fluff can actually mean more correctness.

The takeaway: fewer tokens is not just cheaper — it is often better.

---

## How Caveman Works

Caveman is a **Claude Code skill** (also available for Cline, Cursor, Windsurf, and Codex). It injects a lightweight prompt constraint that tells Claude to drop filler, remove articles, use sentence fragments, and get straight to the point.

The key insight is that **thinking/reasoning tokens are untouched**. Caveman does not make Claude "dumber." It only compresses the **output** — the final text that reaches your terminal. The model still reasons at full capability; it just speaks more efficiently afterward.

Caveman offers three intensity levels:

| Level | Trigger | Behavior |
|-------|---------|----------|
| **Lite** | `/caveman lite` | Removes filler, keeps grammar. Professional but concise. |
| **Full** | `/caveman full` | Default mode. Drops articles, uses fragments, full caveman style. |
| **Ultra** | `/caveman ultra` | Maximum compression. Telegraphic. Abbreviates everything. |

There is also a **Wenyan mode** that uses classical Chinese literary compression for the absolute minimum token count, but Full mode is what most developers use.

---

## Installation and Setup

Caveman supports multiple AI coding tools. Choose the one you use:

### Claude Code

Clone the skill into your global skills directory:

```bash
git clone https://github.com/JuliusBrussee/caveman.git \
  ~/.claude/skills/caveman
```

Restart Claude Code. The skill auto-loads.

### Cursor

Copy the rules file into your Cursor project:

```bash
cp caveman/.cursor/.cursorrules /path/to/your/project/
```

### Cline / Roo Code

Install via the Cline marketplace or copy the `.clinerules` file to your project root.

### Windsurf

Copy the `.windsurf` rules into your project configuration.

### Codex (OpenAI)

Use the `$caveman` trigger after loading the skill.

---

## How to Use Caveman

Once installed, trigger it with any of these phrases:

- `/caveman`
- `talk like caveman`
- `caveman mode`
- `less tokens please`

To return to normal:

- `stop caveman`
- `normal mode`

### Example: Asking for a Code Review

**Without Caveman:**

```text
User: Review this auth middleware for security issues.
Claude: Certainly! I would be happy to review your authentication middleware for potential security vulnerabilities. Let me examine the code carefully...
[700+ tokens of polite preamble and explanation]
```

**With Caveman:**

```text
User: /caveman
User: Review this auth middleware for security issues.
Claude: L42: 🔴 bug — user null. Add guard.
L58: 🟡 weak token expiry. Use 15min max.
L71: 🔴 secret in env var? Move to vault.
```

Same technical content. No throat-clearing. **41% fewer tokens** in this real benchmark case.

### Built-in Skills

Caveman ships with several sub-commands:

| Command | Purpose |
|---------|---------|
| `/caveman-commit` | Terse commit messages (Conventional Commits, ≤50 chars) |
| `/caveman-review` | One-line PR comments. No fluff. |
| `/caveman-help` | Quick-reference card for all modes. |
| `/caveman-stats` | Real session token usage + estimated savings in USD. |
| `/caveman:compress <file>` | Rewrites a memory file (e.g., `CLAUDE.md`) into caveman-speak. Cuts ~46% of input tokens. |

---

## Real Benchmarks and Results

The Caveman repository includes reproducible benchmarks using the real Claude API. Here are the numbers:

| Task | Normal (tokens) | Caveman (tokens) | Saved |
|------|----------------:|-----------------:|------:|
| Explain React re-render bug | 1,180 | 159 | **87%** |
| Fix auth middleware token expiry | 704 | 121 | **83%** |
| Set up PostgreSQL connection pool | 2,347 | 380 | **84%** |
| Explain git rebase vs merge | 702 | 292 | **58%** |
| Refactor callback to async/await | 387 | 301 | **22%** |
| Architecture: microservices vs monolith | 446 | 310 | **30%** |
| Review PR for security issues | 678 | 398 | **41%** |
| Docker multi-stage build | 1,042 | 290 | **72%** |
| Debug PostgreSQL race condition | 1,200 | 232 | **81%** |
| Implement React error boundary | 3,454 | 456 | **87%** |
| **Average** | **1,214** | **294** | **65%** |

Range: **22% to 87%** savings depending on how verbose the original task is.

### What You Gain

- **Speed:** Less text to generate means faster responses.
- **Readability:** No walls of text. Just answers.
- **Accuracy:** All technical info is preserved; only fluff is removed.
- **Cost:** 65% fewer output tokens directly translates to a lower API bill.

---

## Practical Code Example

Here is a side-by-side comparison for a common developer task: asking Claude to explain a Docker multi-stage build.

**Normal Mode (1,042 tokens):**

```text
Certainly! I would be happy to explain how a multi-stage Docker build works and why it is beneficial for your Node.js application.

A multi-stage build is a feature in Docker that allows you to use multiple FROM statements in a single Dockerfile. Each FROM instruction can use a different base image, and each stage can copy artifacts from previous stages. This approach is particularly useful because it helps you create smaller, more secure final images by separating the build environment from the runtime environment.

Let me walk you through a typical example for a Node.js application...
```

**Caveman Mode (290 tokens):**

```text
Multi-stage build = smaller image.

Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json .
RUN npm ci
COPY . .
RUN npm run build

Stage 2: Run
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["node", "dist/main.js"]

Why: builder has gcc, python, devdeps. Runtime no need. Image go from 1.2GB to 180MB.
```

Same technical depth. Same code. **72% fewer tokens.**

---

## Summary

Caveman is not a gimmick. It is a **practical, scientifically grounded** optimization for anyone who uses Claude Code heavily. By compressing Claude's output into terse, caveman-style language, it delivers:

- **65% average token reduction**
- **Faster responses**
- **Easier-to-read output**
- **Lower API costs**
- **Unchanged reasoning quality**

If your monthly Claude Code bill is climbing or you are tired of scrolling through polite preamble to find the actual answer, Caveman is worth installing today.

**Get it here:** [github.com/JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman)

**Star count:** 57,003 and growing.

---

*Have you tried Caveman? Drop your token savings in the comments below.*

---

## Recommended Tools

For developers building or deploying open-source AI tools, we recommend:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for new users, 14+ global regions, one-click GPU/CPU droplets ideal for AI workloads.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API proxy. Most AI tools above (chatbots, code gen, translation, search, etc) need an LLM API key — this proxy delivers stable access to top models at ~30% of official pricing.

*Affiliate link — supports dibi8.com at no cost to you.*

<!--auto-references-->
## References & Sources

- [Caveman](https://github.com/JuliusBrussee/caveman)
- [Claude Code](https://docs.claude.com/en/docs/claude-code/overview)
- [Cline](https://github.com/cline/cline)
- [Docker](https://docs.docker.com/)
