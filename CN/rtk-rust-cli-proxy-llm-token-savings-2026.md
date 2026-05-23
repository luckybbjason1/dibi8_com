---
title: 'rtk Review: The Rust CLI Proxy That Cuts AI Coding Bills by 80% (2026)'
description: 'rtk is a zero-dependency Rust binary that intercepts and compresses CLI output before it hits your LLM context. 60–90% token savings across 100+ commands and 13 AI coding tools (Claude Code, Cursor, Copilot, Codex, Gemini CLI). MIT licensed, <10ms overhead, 30-second install.'
date: 2026-05-22 00:00:00+08:00
lastmod: 2026-05-22 00:00:00+08:00
tech_stack: ['Rust', 'CLI', 'Shell hooks']
application_domain: Llm Frameworks
source_version: '0.28.2'
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: 'https://github.com/rtk-ai/rtk/releases'
backup_url: ''
github_repo: 'https://github.com/rtk-ai/rtk'
stars: 0
maintainer: 'rtk-ai'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['rtk', 'rust', 'cli', 'llm', 'token-optimization', 'ai-coding', 'claude-code', 'cursor', 'copilot', 'cost-optimization', 'open-source', 'developer-tools']
aliases:
- /posts/rtk/
- /resources/dev-utils/rtk-rust-cli-proxy-llm-token-savings-2026/
faqs:
  - q: "What is rtk and how much can it save on AI coding bills?"
    a: "rtk is an open-source Rust CLI proxy that compresses command output before it reaches your AI agent's context window. It cuts LLM token consumption by 60-90% across 13 AI coding tools (Claude Code, Cursor, GitHub Copilot, Gemini CLI, etc.). Real benchmark: $400/month Claude Code bill drops to ~$80, with <10ms latency overhead. MIT licensed. 30-second install."
  - q: "Does rtk send my code to any third party?"
    a: "No. rtk is a local-only binary. It only filters output between your shell and your AI tool's context window. Nothing is sent over the network."
  - q: "How much can I save on my Claude Code or Cursor bill with rtk?"
    a: "Real benchmark on a mid-sized TypeScript fullstack project shows 80% token reduction across typical AI coding sessions. If your monthly bill is $400, rtk drops it to ~$80. The AI agent receives the same actionable information — just without progress bars, redundant logs, and ASCII clutter."
  - q: "Will rtk break if Claude Code or Cursor updates?"
    a: "The hook mechanism is stable. rtk has been tracking Claude Code's hook API since version 0.10. If a breaking change ships, expect an rtk update within 24-48 hours."
  - q: "Is rtk safe for production CI/CD pipelines?"
    a: "Yes when used in agent workflows. Don't use it in set -e strict-mode pipelines that depend on exact command output text — but for AI agent loops that read output and decide next steps, rtk's compressed output is what the agent actually needs."
---

{{< resource-info >}}

## Quick Answer

**Q: What is rtk and how much can it save on AI coding bills?**

**A:** rtk is an open-source Rust CLI proxy that compresses command output before it reaches your AI agent's context window. It cuts LLM token consumption by **60-90%** across 13 AI coding tools (Claude Code, Cursor, GitHub Copilot, Gemini CLI, etc.). **Real benchmark: $400/month Claude Code bill drops to ~$80**, with <10ms latency overhead. MIT licensed. 30-second install.

---

> **TL;DR**: rtk is a single Rust binary, zero-dependency CLI proxy that filters and compresses command output before it reaches your AI agent's context window. It reduces LLM token consumption by **60–90%** across **100+ dev commands** and **13 AI coding tools**, with **<10ms overhead**. Install in 30 seconds, forget it's there, watch your API bill drop.

---

## Introduction

If you're using [Claude Code](/resources/llm-frameworks/), [Cursor alternatives](/collections/), GitHub Copilot, Gemini CLI, or any AI coding agent daily, you already know the productivity gains are real. What fewer developers talk about is the **cost curve**.

**dibi8's take** — We've spent the last quarter benchmarking AI coding cost across our own team's workflow. The $400/month Claude API bill we noticed in March 2026 was real, and the surprising finding was that **roughly 70% of those tokens were noise** — the AI agent dumping `git status` into context, then `git diff`, then `npm test` output, much of which was redundant log lines, progress bars, or stale ASCII tree printouts. rtk is the most direct fix we've seen — it lives at the command boundary so you don't have to rewrite a single workflow file.

Here's what typical AI tooling spend looks like for a professional developer in mid-2026:

| Usage Pattern | Monthly API Cost | Stack Context |
|-------------|----------------|---------------|
| Light (1–2 hrs/day) | $50–100 | Side projects, occasional agent help |
| Moderate (3–4 hrs/day) | $150–400 | Full-time development with agent assistance |
| Heavy / Team lead | $500–2,000+ | Agent-driven workflows, multi-file refactoring |

That doesn't include subscription fees: Claude Pro ($20), Cursor Pro ($20), ChatGPT Plus ($20), Copilot Pro ($10). Stack them up and you're at **$840+/year before API calls even start**.

But here's the painful part: **a significant chunk of that API spend is pure waste**. Every time your AI agent runs `git status`, `cat package.json`, `cargo test`, `docker ps`, or `aws ec2 describe-instances`, the raw output contains noise — blank lines, progress bars, ASCII art, redundant logs, verbose metadata — that gets stuffed into the LLM context window and billed at full token rate.

**rtk exists to eliminate that waste at the source.**

---

## What rtk Actually Does (And What It Doesn't)

rtk (GitHub: [rtk-ai/rtk](https://github.com/rtk-ai/rtk)) is not another AI model, not a chat interface, and not a Copilot replacement. Its job is singular and precise:

> "rtk filters and compresses command outputs before they reach your LLM context."

It sits as a transparent proxy layer between your AI agent and the shell:

```
Without rtk:
Claude Code --git status--> shell --> git --> raw 2,000-token output

With rtk:
Claude Code --git status--> RTK --> git --> filtered 200-token output
```

**Core specs at a glance:**

| Feature | Detail |
|---------|--------|
| **Binary** | Single Rust binary, zero runtime dependencies |
| **Coverage** | 100+ commands across git, testing, builds, Docker, AWS, K8s |
| **Latency** | <10ms filtering overhead |
| **Integration** | Auto-rewrite hook — AI tools call rtk transparently |
| **License** | MIT, fully open source |

---

## Real Numbers: 80% Token Reduction in a 30-Minute Claude Code Session

The rtk documentation provides a detailed benchmark. We reproduced it on a mid-sized TypeScript fullstack project and confirmed the savings are accurate:

| Operation | Frequency | Raw Tokens | rtk Tokens | Savings |
|-----------|-----------|------------|------------|---------|
| `ls` / `tree` | 10× | 2,000 | 400 | **-80%** |
| `cat` / file reads | 20× | 40,000 | 12,000 | **-70%** |
| `grep` / `rg` | 8× | 16,000 | 3,200 | **-80%** |
| `git status` | 10× | 3,000 | 600 | **-80%** |
| `git diff` | 5× | 10,000 | 2,500 | **-75%** |
| `git log` | 5× | 2,500 | 500 | **-80%** |
| `git add/commit/push` | 8× | 1,600 | 120 | **-92%** |
| `cargo test` / `npm test` | 5× | 25,000 | 2,500 | **-90%** |
| `pytest` / `go test` | several | 14,000 | 1,400 | **-90%** |
| **Total** | | **~118,000** | **~23,900** | **-80%** |

**What an 80% reduction means in practice:**

If your Claude Code API bill runs $400/month, rtk drops it to ~$80. The agent receives the *same actionable information* — just without the noise. You're not sacrificing context; you're removing clutter.

---

## The Four Compression Strategies Behind rtk

rtk doesn't blindly truncate output. It applies command-specific strategies:

### 1. Smart Filtering

Removes LLM-irrelevant noise: comments, whitespace, boilerplate, progress bars, ASCII decorations. `git push` with rtk returns `ok main` instead of 15 lines of enumeration and compression stats.

### 2. Grouping

Aggregates similar items by category. `git status` doesn't list files line-by-line — it groups them by directory: `src/ (8 files)`. Test failures show `FAILED: 2/15 tests` with only the specific failures expanded.

### 3. Smart Truncation

Preserves structure while cutting redundancy. `cat` a 500-line config file and rtk keeps the structure but compresses values. Use `rtk read file.rs -l aggressive` to strip bodies and keep only function signatures.

### 4. Deduplication

Collapses repeated lines — common in Docker logs and test output — into `... (repeated 47x)`.

---

## Universal Compatibility: 13 AI Tools, One Install

rtk's ecosystem coverage is exceptional. It doesn't lock you into one agent:

| AI Tool | Install Command | Interception Method |
|---------|-----------------|---------------------|
| **Claude Code** | `rtk init -g` | PreToolUse hook (bash) |
| **GitHub Copilot (VS Code)** | `rtk init -g --copilot` | PreToolUse hook |
| **Cursor** | `rtk init -g --agent cursor` | hooks.json |
| **Gemini CLI** | `rtk init -g --gemini` | BeforeTool hook |
| **Codex (OpenAI)** | `rtk init -g --codex` | AGENTS.md + RTK.md |
| **Windsurf** | `rtk init --agent windsurf` | .windsurfrules |
| **Cline / Roo Code** | `rtk init --agent cline` | .clinerules |
| **OpenCode** | `rtk init -g --opencode` | Plugin TS |
| **OpenClaw** | `openclaw plugins install ./openclaw` | Plugin TS |
| **Hermes** | `rtk init --agent hermes` | Python plugin |
| **Kilo Code** | `rtk init --agent kilocode` | .kilocode/rules |
| **Google Antigravity** | `rtk init --agent antigravity` | rules file |

Switch between tools without losing your token savings. rtk follows your workflow, not the other way around.

If you're juggling multiple AI agents at once (which is common in 2026), pair rtk with [CC Switch](/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/) for unified management.

---

## Installation: 30 Seconds, Zero Config

### macOS (Homebrew — recommended)

```bash
brew install rtk
rtk init -g   # Install auto-rewrite hook for your default AI tool
# Restart Claude Code / Cursor / your agent
```

### Linux

```bash
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
rtk init -g
```

### Windows (WSL recommended for full hook support)

```bash
# Inside WSL — full features
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
rtk init -g
```

### Verify

```bash
rtk --version   # rtk 0.28.2
rtk gain        # View token savings stats
```

After installation, **keep using your tools exactly as before**. The hook transparently rewrites bash commands — `git status` becomes `rtk git status` — without any change to your workflow.

---

## Hands-On: From Git Workflows to AWS and Kubernetes

### Git Operations

```bash
rtk git status        # Compact status
rtk git log -n 10     # One-line commits
rtk git diff          # Condensed diff
rtk git push          # Returns: ok main
```

### Test Runners: Failures Only

```bash
rtk pytest            # 90% token savings, failures only
rtk cargo test        # Same for Rust
rtk test <cmd>        # Generic test wrapper
```

### Lint & Build: Grouped by Rule

```bash
rtk lint              # ESLint grouped by rule/file
rtk tsc               # TypeScript errors grouped by file
rtk ruff check        # Python lint, 80% savings
```

### Docker & K8s: Deduplicated Logs

```bash
rtk docker ps         # Compact container list
rtk docker logs <id>  # Deduplicated logs
rtk kubectl pods      # Compact pod list
```

### AWS: Stripped + Sanitized

```bash
rtk aws ec2 describe-instances   # Compact instance list
rtk aws lambda list-functions    # Name/runtime/memory, secrets stripped
rtk aws s3 ls                    # Truncated with tee recovery
```

### Data & Analytics: Structured Output

```bash
rtk json config.json    # Structure without values (safe)
rtk deps                # Dependency summary
rtk summary <long cmd>  # Heuristic summary
```

---

## Limitations and Pro Tips

### Known Limitations

1. **Bash-only interception**: Claude Code's built-in `Read`, `Grep`, `Glob` tools bypass the bash hook. Workaround: use shell commands (`cat`, `rg`, `find`) or explicit `rtk read`, `rtk grep`.

2. **Windows native**: Auto-rewrite requires a Unix shell. Native Windows (cmd/PowerShell) falls back to CLAUDE.md injection mode — works, but requires explicit `rtk` prefix. WSL gives full support.

3. **Edge cases may need full output**: rtk saves raw output via tee on failure. Use `-v` / `--verbose` flags when you need more detail.

### Best Practices

- **Install and forget**: The hook works transparently; don't force yourself to prepend `rtk`
- **Check `rtk gain` weekly**: Understand your savings profile
- **Run `rtk discover`**: Find commands in your history that could benefit from rtk but aren't covered yet
- **Exclude sensitive commands**: In `~/.config/rtk/config.toml`: `exclude_commands = ["curl", "playwright"]`

---

## How rtk Compares to Alternatives

| Tool | Layer | Approach | Scope | Setup Friction |
|------|-------|----------|-------|----------------|
| **rtk** | CLI proxy | Output filtering/compression | 100+ commands, 13 agents | 30s, zero config |
| **Morph** | API gateway | Model routing + context compaction | Generic API calls | Requires code changes |
| **LiteLLM** | LLM proxy | Caching + routing + observability | Multi-model APIs | Service deployment |
| **LLMLingua** | Prompt layer | Semantic compression | Prompt text | Manual integration |
| **ccusage** | Monitoring | Tracking only, no compression | Claude Code only | Read-only |

rtk's unique advantage: **it lives at the command layer, requires zero code changes, zero infrastructure, and zero new abstractions.** It's a transparent filter you install once and never think about again.

---

## Bottom Line: The Highest-ROI Tool You'll Install This Year

In 2026's developer tooling landscape, everyone is building *more* — more features, more models, more integrations. rtk is a rare example of building *less*, but better. It doesn't replace your AI agent; it just makes it cheaper to feed.

- **No workflow changes**
- **No code changes**
- **No infrastructure**
- **MIT license, completely free**
- **60–90% real token savings**

If you're paying for AI coding tools, rtk isn't a "nice to have." It's the tool that makes every other tool more economically viable.

```bash
# 30 seconds. Start saving today.
brew install rtk
rtk init -g
```

---

## Recommended Hosting for AI Coding Setups

If you're running AI agents that need persistent shell access (CI runners, remote devboxes, self-hosted Claude Code servers), here are battle-tested VPS providers we use:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $5/mo droplet handles single-developer AI coding workloads, $200 in free credits for new accounts
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong / Singapore VPS for low-latency Asia-Pacific access, USD $4/mo entry

For a complete budget-conscious LLM stack including rtk, see our [Cheap LLM Stack collection](/collections/cheap-llm-stack/).

*This article contains affiliate links. We may earn a commission if you purchase through these links — at no extra cost to you.*

---

## Further Reading

- [rtk GitHub Repository](https://github.com/rtk-ai/rtk)
- [rtk Official Documentation](https://rtk-ai.app/guide)
- [CC Switch — Manage Multiple AI Coding CLIs](/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/)
- [Cheap LLM Stack — Complete Budget Setup](/collections/cheap-llm-stack/)
- [n8n AI Workflow Automation](/resources/llm-frameworks/n8n-ai-workflow-automation-self-hosted-2026/)

---

## FAQ

### Does rtk send my code to any third party?

No. rtk is a local-only binary. It only filters output between your shell and your AI tool's context window. Nothing is sent over the network.

### Will rtk break if I update Claude Code / Cursor?

The hook mechanism is stable. rtk has been tracking Claude Code's hook API since 0.10. If a breaking change ships, expect an rtk update within 24-48 hours.

### Can I use rtk with custom in-house AI agents?

Yes — rtk has a Python plugin pattern (used by Hermes) that you can adapt. Documentation in `/docs/plugins/` on GitHub.

### How does rtk compare to just using `--no-pager` or `--quiet` flags everywhere?

rtk is command-aware. `git --no-pager log` still produces verbose output. rtk's `git log` strategy specifically converts to one-line summaries with deduplication. It's the difference between "less verbose" and "structurally compressed."

### Is rtk safe for production CI/CD?

Yes when used in agent workflows. Don't use it in `set -e` strict-mode pipelines that depend on exact command output text — but for AI agent loops that read output and decide next steps, rtk's compressed output is what the agent actually needs.
