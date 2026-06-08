---
title: 'Odysseus: The Self-Hosted AI Workspace That Hit 63,000 GitHub Stars in 9 Days — 2026 Setup Guide'
description: 'Odysseus is an open-source, privacy-first AI workspace (63 k GitHub stars in 9 days, MIT). One Docker command gives you chat, agents, deep research, email triage, calendar, notes, and a model cookbook — all on your own hardware. This guide covers installation, key features, and how it stacks up against ChatGPT Plus and Claude.ai.'
date: 2026-06-09 00:00:00+08:00
lastmod: 2026-06-09 00:00:00+08:00
tech_stack: []
application_domain: AI Tools
source_version: '1.0'
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: 'https://github.com/pewdiepie-archdaemon/odysseus'
backup_url: ''
github_repo: 'pewdiepie-archdaemon/odysseus'
stars: 63159
maintainer: 'pewdiepie-archdaemon'
last_maintained: '2026-06-08'
featureImage: 'https://raw.githubusercontent.com/pewdiepie-archdaemon/odysseus/main/docs/odysseus.jpg'
draft: false
categories: ['ai-tools']
tags: ['Odysseus', 'self-hosted AI', 'AI workspace', 'local LLM', 'privacy', 'Docker', 'open source', 'ChatGPT alternative', 'Ollama', 'deep research']
aliases:
- /posts/odysseus-self-hosted-ai-workspace-2026/
faqs:
  - q: 'Does Odysseus require a GPU?'
    a: 'No. Odysseus itself is lightweight. The GPU requirement only applies if you want to run local models via the Cookbook feature. You can connect to remote APIs (OpenAI, Anthropic, OpenRouter) or a separate Ollama instance without any local GPU.'
  - q: 'How is Odysseus different from Open WebUI?'
    a: 'Open WebUI focuses on chat and RAG over Ollama. Odysseus adds a full suite on top: agents with MCP tool calling, deep research with visual reports, an AI-aware email client, CalDAV calendar, notes with reminders, and a model Cookbook that detects your VRAM and auto-recommends compatible models. It is closer to a self-hosted ChatGPT Plus than a plain Ollama front-end.'
  - q: 'Which LLM backends does Odysseus support?'
    a: 'Out of the box: vLLM, llama.cpp, Ollama, OpenRouter, OpenAI, and GitHub Copilot. You add model servers in Settings; no code changes are needed. The Cookbook feature also installs and serves compatible GGUF, FP8, and AWQ models automatically based on your detected VRAM.'
  - q: 'Is it safe to expose Odysseus to the internet?'
    a: 'The default Docker Compose binds to 127.0.0.1 only. For LAN access set APP_BIND=0.0.0.0 in .env and keep AUTH_ENABLED=true. For public internet, put it behind a reverse proxy (Nginx, Caddy) with TLS. The maintainers explicitly advise against binding to 0.0.0.0 without authentication.'
  - q: 'Can I use Odysseus on mobile?'
    a: 'Yes. Odysseus ships as a Progressive Web App (PWA) and is fully responsive. On iOS or Android you can "Add to Home Screen" for a near-native feel. The Cookbook and Agent features work on mobile too, though GPU-intensive model serving is still a desktop/server concern.'
---

Odysseus launched on GitHub on 31 May 2026 and crossed 63,000 stars by 8 June — roughly **7,000 new stars per day**, making it one of the fastest-rising open-source AI projects of 2026. The premise is simple: everything you get from a $20/month ChatGPT Plus subscription, running on your own hardware, with your own data, under an MIT licence.

## What Odysseus Actually Is

At its core Odysseus is a Python web app (FastAPI + Uvicorn backend, vanilla JS front-end) that wraps several well-tested open-source components into a coherent workspace. You get:

- **Chat** — send messages to any local or remote LLM. Add a model server in Settings with a URL and key; Odysseus handles the rest. Supported backends: vLLM, llama.cpp, Ollama, OpenRouter, OpenAI, GitHub Copilot.
- **Agent** — hand the agent a goal plus tools (web, files, shell, MCP servers, memory) and it runs autonomously. The agent layer is built on top of [opencode](https://github.com/anomalyco/opencode), the open-source coding agent.
- **Cookbook** — scans your hardware, detects available VRAM, and recommends GGUF / FP8 / AWQ models you can download and serve in one click. Powered by [llmfit](https://github.com/AlexsJones/llmfit).
- **Deep Research** — multi-step agentic research that searches the web, reads sources, and synthesises a structured visual report. Adapted from Alibaba's [Tongyi DeepResearch](https://github.com/Alibaba-NLP/DeepResearch).
- **Compare** — blind side-by-side model comparison. The same prompt goes to multiple models; you rate the answers without knowing which model produced which.
- **Documents** — multi-tab Markdown / HTML / CSV editor where you write; AI assists, suggests, and makes targeted edits on request.
- **Memory / Skills** — ChromaDB vector store with fastembed (ONNX) gives the agent persistent memory. Import/export supported.
- **Email** — IMAP/SMTP inbox with AI triage: urgency detection, auto-tagging, summarisation, and reply-draft generation.
- **Notes & Tasks** — sticky notes with reminders, a todo list, and cron-style scheduled tasks the agent can act on.
- **Calendar** — local-first calendar with CalDAV sync to Radicale, Nextcloud, Apple Calendar, or Fastmail.
- **PWA / Mobile** — responsive design, installable as a home-screen app on iOS and Android.

## Quick Start (Docker)

The fastest path to a running instance:

```bash
git clone https://github.com/pewdiepie-archdaemon/odysseus.git
cd odysseus
cp .env.example .env          # optional but recommended
docker compose up -d --build
```

Open **http://localhost:7000**. On first boot Odysseus prints a temporary admin password to the Docker logs:

```bash
docker compose logs odysseus | grep "Admin password"
```

Log in, change the password in Settings, then add your first model server (Ollama on localhost, or an OpenAI API key).

## Native Install (Linux / macOS)

For GPU-accelerated local models on Apple Silicon, run native rather than Docker (Docker cannot access the Metal GPU):

```bash
git clone https://github.com/pewdiepie-archdaemon/odysseus.git
cd odysseus
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
python setup.py
python -m uvicorn app:app --host 127.0.0.1 --port 7000
```

Apple Silicon shortcut:

```bash
./start-macos.sh        # binds to 127.0.0.1:7860
```

Requirements: Python 3.11+. `tmux` is needed by Cookbook for background model downloads.

## The Cookbook Feature in Depth

Cookbook is the standout differentiator. It:

1. Detects your GPU model and available VRAM
2. Scores a curated model catalogue against your hardware using `llmfit`'s fit algorithm (VRAM × quantisation × context window)
3. Lets you click **Download & Serve** — it fetches the model in the background, launches the appropriate runtime (vLLM for FP8/AWQ, llama.cpp for GGUF), and registers it in your model list automatically

For users who do not want to manage Ollama separately, Cookbook effectively replaces it while providing smarter model selection.

## Memory and Agent Skills

Odysseus stores agent memory in ChromaDB using fastembed for embeddings (pure ONNX, no Python GPU dependency for inference). Memory is chunked, embedded, and retrieved via hybrid search (vector + keyword). Skills can be imported from the community or defined locally — the format is compatible with the broader agent-skills ecosystem.

## How It Compares

| Feature | Odysseus | Open WebUI | ChatGPT Plus |
|---|---|---|---|
| Self-hosted | ✅ | ✅ | ❌ |
| Agent + MCP tools | ✅ | Partial | ✅ |
| Deep Research | ✅ | ❌ | ✅ |
| Email triage | ✅ | ❌ | ❌ |
| Calendar (CalDAV) | ✅ | ❌ | ❌ |
| Model Cookbook | ✅ | ❌ | N/A |
| Blind model compare | ✅ | ❌ | ❌ |
| Cost per month | Hardware only | Hardware only | $20 |

## Caveats

Odysseus is version 1.0, released less than two weeks ago. Expect rough edges: some Cookbook runtimes need manual `tmux` for background tasks on Linux, the CalDAV sync has known edge cases with recurring events, and mobile PWA performance varies by browser. The issue tracker is active and the maintainer is responsive.

For production-grade agent deployments, established frameworks (LangGraph, CrewAI) still offer more battle-tested reliability. Odysseus is best framed as a personal AI workspace — powerful, flexible, and private — rather than an enterprise automation platform.

## Bottom Line

If you want a ChatGPT-like experience on your own hardware without a monthly subscription, Odysseus is the most complete open-source option available today. The 63,000 stars in nine days reflect genuine community excitement, not hype. Clone the repo, `docker compose up`, and you have a fully working AI workspace in under five minutes.

**GitHub:** [pewdiepie-archdaemon/odysseus](https://github.com/pewdiepie-archdaemon/odysseus)
