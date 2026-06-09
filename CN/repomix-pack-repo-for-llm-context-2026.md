---
title: 'repomix 2026: Pack Your Entire Codebase into One LLM-Ready File — Zero Config'
description: 'repomix (formerly repopack) turns any Git repository into a single, structured plain-text file optimized for LLM context windows — supporting Claude, ChatGPT, Gemini, and Cursor. 14k+ stars, zero config, runs in seconds with npx.'
date: 2026-06-09 00:00:00+08:00
lastmod: 2026-06-09 00:00:00+08:00
tech_stack: ['Node.js', 'TypeScript', 'CLI']
application_domain: Dev Utils
source_version: 'v0.3'
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: 'https://github.com/yamadashy/repomix'
backup_url: ''
github_repo: 'yamadashy/repomix'
stars: 14200
maintainer: 'yamadashy'
last_maintained: '2026-06-01'
featureImage: '/images/articles/repomix-pack-repo-for-llm-context-2026/cover.jpg'
draft: false
categories: ['dev-utils']
tags: ['repomix', 'repopack', 'AI-coding', 'LLM-context', 'codebase-packing', 'Claude', 'ChatGPT', 'developer-tools', 'open-source']
aliases:
- /posts/repomix-pack-repo-for-llm-context-2026/
faqs:
  - q: 'What is repomix and what was it called before?'
    a: 'repomix (formerly repopack) is an open-source CLI tool that packs an entire Git repository into a single structured text file, optimized for LLM context windows. It was renamed from "repopack" to "repomix" in 2025 to avoid confusion with npm''s existing "repack" command. Built by yamadashy and released under MIT.'
  - q: 'What output formats does repomix support?'
    a: 'repomix supports three output formats: plain text (default), XML (structured with file tags, best for Claude which uses XML natively), and Markdown (best for documentation workflows and GitHub Copilot). You select the format with --style plain|xml|markdown.'
  - q: 'How does repomix differ from just copying all files manually?'
    a: 'repomix automatically respects .gitignore rules, adds a token count estimate per file, generates a repository summary and directory tree at the top, handles binary file exclusion, and supports custom include/exclude glob patterns — all in one command. The output is formatted specifically for LLMs with file separators that the model can parse reliably.'
  - q: 'How large a codebase can repomix handle?'
    a: 'repomix works well up to around 100,000–200,000 tokens (roughly a 5,000–10,000 file project). For larger repos, use --include patterns to send only the relevant subsystem. The --output-show-line-numbers flag helps LLMs give accurate line references for edits.'
  - q: 'Can I use repomix with Claude Projects or ChatGPT memory?'
    a: 'Yes — the most common workflow is to run repomix, then paste or upload the output file to a Claude Project or a custom GPT. This gives the AI full codebase context for debugging, code review, documentation, or architecture discussions without iterating over dozens of files.'
---

![repomix 2026: Pack Your Codebase for LLM Context — dibi8.com](/images/articles/repomix-pack-repo-for-llm-context-2026/cover.jpg)

When you ask Claude or ChatGPT to debug a multi-file issue or refactor a complex function, pasting code snippets one-by-one loses context fast. [repomix](https://github.com/yamadashy/repomix) solves this by turning your entire repository into one structured file — ready to drop into any LLM's context window in seconds.

## What repomix Does

repomix scans your repository, excludes files in `.gitignore`, and outputs a single text file containing:

1. **Repository summary** — total files, token estimate, language breakdown
2. **Directory tree** — full folder structure at a glance
3. **All source files** — each prefixed with a path header and optional line numbers

The result is immediately usable with Claude, ChatGPT, Gemini, Cursor, or any LLM that accepts file upload or long-form pasting.

## Zero Config Start

```bash
# Run without installing — uses npx
npx repomix

# Install globally
npm install -g repomix

# Pack specific directory
repomix ./src

# Pack remote GitHub repo directly (no git clone needed)
npx repomix --remote https://github.com/user/repo
```

That's it. `repomix output.txt` is created in the current directory.

## Output Formats

| Format | Flag | Best For |
|--------|------|----------|
| Plain text | `--style plain` (default) | ChatGPT, general LLMs |
| XML | `--style xml` | Claude (uses XML natively), structured parsing |
| Markdown | `--style markdown` | Copilot, documentation workflows |

```bash
# XML output for Claude
repomix --style xml --output repo-context.xml

# Markdown output
repomix --style markdown
```

## Filtering the Output

For large projects, include only what's relevant:

```bash
# Include only TypeScript files in src/
repomix --include "src/**/*.ts"

# Exclude test files and generated code
repomix --ignore "**/*.test.ts,dist/**,node_modules/**"

# Show line numbers (helps LLMs give accurate edit suggestions)
repomix --output-show-line-numbers
```

## repomix.config.json (Persistent Settings)

Create `repomix.config.json` in your repo root to save preferences:

```json
{
  "output": {
    "style": "xml",
    "filePath": "context.xml",
    "showLineNumbers": true,
    "removeComments": false
  },
  "ignore": {
    "useGitignore": true,
    "customPatterns": ["*.test.ts", "dist/**", "*.lock"]
  }
}
```

## Typical LLM Workflows

### Full Codebase Code Review

```bash
# Pack the repo, then paste into Claude
repomix --style xml --output review.xml
# → Upload to Claude Project or paste into conversation
# → "Review this codebase for security issues, architecture problems, and dead code."
```

### Bug Diagnosis Across Multiple Files

```bash
# Include only the affected subsystem
repomix --include "src/auth/**,src/middleware/**" --style xml
# → "Here's my authentication code. The JWT is being rejected on mobile but not desktop. Find the bug."
```

### Generating Documentation

```bash
repomix --style markdown --output docs-context.md
# → "Generate comprehensive JSDoc for every exported function in this codebase."
```

### Remote Repo Analysis (No Clone Required)

```bash
# Analyze an open-source project without cloning
npx repomix --remote https://github.com/some-org/some-project
# → "Summarize the architecture. What design patterns does this project use?"
```

## Security Note: `.repomixignore`

repomix respects `.gitignore` by default, but secrets that aren't gitignored (local `.env` files, API keys in config) can end up in output. Add a `.repomixignore` file to explicitly exclude sensitive files:

```
.env
.env.local
secrets/**
config/credentials.json
```

## repomix vs. Similar Tools

| Tool | Approach | Best For |
|------|----------|----------|
| **repomix** | Single file, LLM-optimized, XML/plain/MD | Any LLM, fastest start |
| Cursor | IDE-native context | Cursor users only |
| Aider | Adds LLM to git workflow | Git-integrated coding sessions |
| [Ollama](/resources/llm-frameworks/ollama/) | Runs local models | Self-hosted inference |

repomix doesn't replace any of these — it complements them by providing clean context input.

> **Need a server to build AI developer tools?** [DigitalOcean new users get $200 in credits](https://m.do.co/c/eca87ac14ee0) — enough to run a development server, host a private repomix pipeline, or deploy your AI-assisted codebase. No long-term commitment.

## Who Should Use repomix

**Use repomix if you:**
- Regularly ask LLMs to help debug multi-file issues
- Want to give Claude or ChatGPT full context for architecture reviews
- Need to onboard a new AI tool to a project quickly
- Work with large codebases that exceed typical snippet-pasting approaches

**GitHub:** [yamadashy/repomix](https://github.com/yamadashy/repomix) · 14.2k ⭐ · MIT
