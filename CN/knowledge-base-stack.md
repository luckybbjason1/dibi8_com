---
title: 'The Knowledge Base Stack 2026: Build Your "Second Brain" with AnythingLLM + RAGFlow + mem0 ($10-25/Month)'
description: 'A 5-component self-hosted knowledge base stack for personal or team use. AnythingLLM (UI + RAG) + RAGFlow (deep doc parsing) + mem0 (agent memory) + AgentMemory MCP (MCP exposure) + vector DB pick. Replaces $50-200/mo SaaS (Notion AI + Mem + Glean) with $10-25/mo self-hosted.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Docker
  - Python
  - PostgreSQL
  - Redis
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
tags: ['Knowledge Base', 'RAG', 'Second Brain', 'Stack', 'Collection']
aliases:
  - /posts/knowledge-base-stack/
---

You've got 500 PDFs, 2,000 notes, 10 years of email, and the AI in your editor doesn't know any of it exists. Notion AI is $10/seat/mo and can't see your local files. Glean costs $30k/year minimum. Mem.ai is great but it's a SaaS — your "second brain" lives on someone else's hardware.

This collection assembles the **5-component self-hosted knowledge base stack** that ingests everything (PDFs, notes, web pages, code), embeds it locally, lets you query it via chat + API, and exposes it to your AI coding agents via MCP — for **$10-25/month** total infrastructure cost.

## TL;DR — The Stack at a Glance

| # | Component | Role | Why | Deep dive |
|---|---|---|---|---|
| 1 | **AnythingLLM** | All-in-one RAG UI + document manager + chat interface | The "front door" — what you and your team actually click into | [AnythingLLM local RAG architecture](/resources/llm-frameworks/anythingllm-architecture-local-rag/) |
| 2 | **RAGFlow** | Deep document parsing (tables, formulas, multi-column PDFs) | Where AnythingLLM stops at "good enough" parsing, RAGFlow handles the hard documents | [RAGFlow guide](/resources/llm-frameworks/ragflow/) |
| 3 | **mem0** | Persistent semantic memory layer for agents | Long-term "remember this fact about the user" across sessions | [mem0 setup](/resources/llm-frameworks/mem0/) |
| 4 | **AgentMemory MCP** | Exposes mem0 to any MCP host (Claude Desktop, OpenCode, Cursor) | Lets your coding agent share the knowledge base via MCP protocol | [AgentMemory MCP](/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/) |
| 5 | **Vector DB** (Chroma / Qdrant / Weaviate) | Embedding storage + similarity search backend | Pick varies — see [Vector DB comparison](/resources/llm-frameworks/vector-database-comparison/) | [Vector DB comparison 2026](/resources/llm-frameworks/vector-database-comparison/) |

**Total monthly cost** (solo, 10 GB of docs): **$10-15** • **Small team (10 GB, 5 users)**: **$15-25** • **Org (100 GB, 50 users)**: **$60-150**

Compare against SaaS equivalents: Notion AI + Mem + Glean Lite = $50-200/mo for solo-to-small-team coverage.

## 1. Why Self-Host a Knowledge Base in 2026

Three things converged:

1. **Local embedding models hit production quality** — `nomic-embed-text` and `bge-large` run on a 4GB VPS, embed at 200 docs/min, retrieve at sub-100ms. No more "send your data to OpenAI for embeddings."
2. **MCP standardized agent-to-knowledge integration** — once your knowledge base speaks MCP, every AI coding agent (Claude Desktop, OpenCode, Cursor, Continue) can query it without custom integration code. See our [MCP server registry guide](/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) for the protocol details.
3. **RAGFlow shipped enterprise-grade document parsing as open source** — multi-column PDFs, tables with merged cells, embedded formulas. The thing every "DIY RAG" stack failed at, now solved.

Stack the three — local embedding + MCP exposure + RAGFlow-grade parsing — and the "I'll just use Notion AI" decision flips for anyone with privacy concerns or > 5 GB of source documents.

## 2. Architecture Overview

```
   ┌────────────────────────────────────────────────────┐
   │ VPS ($10-25/mo)                                    │
   │                                                    │
   │  ┌────────────────────────────────────────────┐   │
   │  │ AnythingLLM (web UI)                       │   │
   │  │   ↕                                         │   │
   │  │   Documents → embedding pipeline           │   │
   │  └────────────┬───────────────────────────────┘   │
   │               │                                    │
   │   "hard PDFs" │  "easy docs"                       │
   │       ↓       │       ↓                            │
   │  ┌─────────┐  │  ┌──────────────┐                  │
   │  │ RAGFlow │  │  │ (anythingLLM │                  │
   │  │ parser  │  │  │  built-in)   │                  │
   │  └────┬────┘  │  └──────┬───────┘                  │
   │       └───────┴─────────┘                          │
   │               ↓                                    │
   │      ┌────────────────┐                            │
   │      │ Vector DB      │                            │
   │      │ (Chroma local) │                            │
   │      └────────┬───────┘                            │
   │               ↓                                    │
   │  ┌─────────────────────────────────┐               │
   │  │ Query routing                   │               │
   │  │   ├─► AnythingLLM chat UI       │               │
   │  │   ├─► mem0 (agent memory layer) │               │
   │  │   └─► AgentMemory MCP server    │               │
   │  │         ↓                        │               │
   │  │    (Claude / Cursor / OpenCode)  │               │
   │  └─────────────────────────────────┘               │
   └────────────────────────────────────────────────────┘
```

The split: AnythingLLM is the user-facing front door, RAGFlow handles documents AnythingLLM's parser stumbles on, the vector DB is the shared retrieval backend, and mem0 + AgentMemory MCP expose the same knowledge to your AI coding agents.

## 3. Component 1 — AnythingLLM (The Front Door)

**The role**: This is what you and your team click into. Document upload, workspace organization, chat-with-your-docs, user management — all in one self-hosted app.

**Why this pick**: 28k+ stars, single Docker container deploys in 10 minutes, has the most polished web UI of any open-source RAG tool. Supports 40+ LLM providers as the chat backend (Ollama / DeepSeek / Claude / GPT-5 / OpenRouter) so you keep cost flexibility.

**Quick install**:
```bash
docker run -d --name anythingllm \
  -p 3001:3001 \
  -v anythingllm-storage:/app/server/storage \
  -e LLM_PROVIDER=ollama \
  -e EMBEDDING_ENGINE=native \
  mintplexlabs/anythingllm:latest
```

Open `http://your-vps:3001`, create a workspace, drag in PDFs. Built-in parser handles 80% of documents. For the other 20%, route to RAGFlow (next component).

**Full setup** including team auth, workspace structure, and LLM provider routing: [AnythingLLM local RAG architecture](/resources/llm-frameworks/anythingllm-architecture-local-rag/).

## 4. Component 2 — RAGFlow (Deep Document Parsing)

**The role**: When AnythingLLM's built-in parser produces garbage for a document — multi-column PDFs, scanned papers, complex tables, formula-heavy academic papers — RAGFlow steps in.

**Why this pick**: RAGFlow's "DeepDoc" parser uses a vision model on each page, preserves table structure (merged cells, nested rows), and chunks documents by semantic block instead of token count. The output is 3-5× more accurate retrieval for hard documents.

**Quick install**:
```bash
docker compose -f https://github.com/infiniflow/ragflow/raw/main/docker/docker-compose.yml up -d
# Web UI on :80, API on :9380
```

**Workflow pattern**: AnythingLLM is the daily driver. When retrieval quality drops for a specific doc, re-process it through RAGFlow, save the parsed chunks back to the shared vector DB.

**Full RAGFlow setup** including DeepDoc tuning and pipeline integration: [RAGFlow guide](/resources/llm-frameworks/ragflow/).

## 5. Component 3 — mem0 (Agent Memory Layer)

**The role**: Persistent semantic memory that survives across chat sessions and across agents. "Remember the user is using Tailwind v4 and the auth lives in `src/lib/auth.ts`" — and any agent that talks to mem0 gets that fact next session, next month, next year.

**Why this pick**: 30k+ stars. Built specifically for agent memory (not general-purpose vector DB). Auto-extracts facts from conversations, deduplicates, decays old facts naturally.

**Quick install**:
```bash
pip install mem0ai
# Or run as a service:
docker run -d --name mem0 -p 8765:8765 \
  -e VECTOR_DB=chroma \
  mem0ai/mem0-server:latest
```

**Use case**: Connect mem0 as a writeback layer to your AnythingLLM workspace. Every chat conversation auto-distills into mem0 facts. Your AI coding agent (next component) then has both the document corpus AND the conversation-extracted facts available.

**Full mem0 setup** including embedding model picks and decay policy tuning: [mem0 setup guide](/resources/llm-frameworks/mem0/).

## 6. Component 4 — AgentMemory MCP (The Bridge to Coding Agents)

**The role**: Exposes mem0 (and optionally the AnythingLLM vector DB) to any MCP host — Claude Desktop, OpenCode, Cursor, Continue, Hermes Agent. Your knowledge base now speaks the protocol every modern AI coding agent understands.

**Why this matters**: Without MCP, integrating a custom knowledge base with each AI coding tool requires custom code per tool. With AgentMemory MCP, you add it once to your `claude_desktop_config.json` and every MCP-aware agent gets it.

**Quick install**:
```bash
npm install -g @mem0/mem0-mcp
# Add to OpenCode / Claude Desktop MCP config:
# { "agentmemory": { "command": "mem0-mcp", "env": { "MEM0_URL": "http://localhost:8765" } } }
```

**The result**: Your coding agent can now answer "based on our project docs and our past conversations, how should I structure the new auth flow?" — with citations from both your PDFs and your prior decisions.

**Full setup** including how to share AgentMemory MCP across a team: [AgentMemory MCP guide](/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/).

## 7. Component 5 — Vector DB Pick

**The role**: The shared embedding storage backend behind AnythingLLM, RAGFlow, and mem0.

**The three viable picks** (full comparison: [Vector DB comparison 2026](/resources/llm-frameworks/vector-database-comparison/)):

- **Chroma** — Best for solo / small team. Single-file SQLite-like simplicity. Embedded mode = zero extra services. Default for AnythingLLM.
- **Qdrant** — Best for production team. Rust-based, sub-10ms latency, scales horizontally. Docker compose handles it.
- **Weaviate** — Best when you need hybrid search (vector + keyword). Heavier ops but more powerful retrieval modes.

**Default recommendation**: Start with Chroma (already inside AnythingLLM). Migrate to Qdrant when your corpus > 100 GB or query latency > 200ms.

```bash
# Qdrant if/when you outgrow Chroma:
docker run -d --name qdrant -p 6333:6333 -p 6334:6334 \
  -v qdrant-storage:/qdrant/storage \
  qdrant/qdrant:latest
```

## 8. Day 1 Setup Order (90 minutes)

1. **Spin up VPS** (10 min) — Order a {{< aff "digitalocean" "kb-vps" "DigitalOcean $12/mo droplet" >}} (8 GB tier; 4 GB is too tight for parsing + embedding + LLM), install Docker
2. **AnythingLLM first** (15 min) — Single docker run, browse to :3001, create admin account + first workspace
3. **Upload 10 test documents** (10 min) — Mix of PDFs, .md notes, .docx — see what AnythingLLM's built-in parser handles
4. **RAGFlow second** (20 min) — docker compose, browse to :80, re-process the 2-3 documents AnythingLLM stumbled on
5. **mem0 third** (10 min) — pip install + run as service, point at the Chroma instance AnythingLLM uses
6. **AgentMemory MCP fourth** (10 min) — npm install, add to Claude Desktop / OpenCode config
7. **Test the full pipeline** (15 min) — Upload doc to AnythingLLM → chat → mem0 captures fact → ask same question in Claude Desktop via MCP → cite both sources

After 90 minutes you have a personal Glean-equivalent running on a $12/mo droplet.

## 9. Cost Breakdown

| Item | Solo (10 GB docs) | Small team (10 GB, 5 users) | Org (100 GB, 50 users) |
|---|---|---|---|
| VPS | $12 (8 GB) | $24 (16 GB) | $120 (64 GB + replica) |
| AnythingLLM | $0 (self-host) | $0 | $0 |
| RAGFlow | $0 (self-host) | $0 | $0 |
| mem0 / AgentMemory MCP | $0 (self-host) | $0 | $0 |
| Vector DB (Chroma → Qdrant) | $0 | $0 | $0 (Qdrant self-host) |
| Embedding (local Ollama bge-large) | $0 | $0 | $0 |
| Chat LLM (DeepSeek for cheap, Claude for hard) | $0-5 | $0-10 | $20-30 |
| Backup storage | $1 | $2 | $20 |
| **Total** | **~$13-18/mo** | **~$26-36/mo** | **~$160-170/mo** |

Compare against SaaS equivalents:
- Solo: Notion AI ($10) + Mem.ai ($15) = $25/mo, can't see local files
- Small team: same × 5 users = $125/mo
- Org: Glean Lite ~$30/user/mo × 50 = $1,500/mo

## 10. Upgrade Path

When you outgrow this stack:

- **Corpus > 1 TB or > 10M docs** — Move Qdrant to dedicated 32 GB box, add sharding
- **Multi-region team** — Replicate AnythingLLM read replicas in multiple regions, single write master in {{< aff "htstack" "upgrade-hk-vps" "HTStack HK" >}} for China-friendly latency
- **Need full text + vector hybrid** — Migrate vector DB from Chroma to Weaviate
- **Audit / SOC2 compliance** — Pair with Portkey for LLM call observability (see [LLM Gateway comparison 2026](/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/))
- **Multi-tenant SaaS** — Add LiteLLM for virtual-key-per-customer ([LiteLLM guide](/resources/llm-frameworks/litellm/))

## TL;DR — The Recipe

**5 components, $10-25/mo for solo-to-small-team**:
1. **AnythingLLM** — front door + chat UI
2. **RAGFlow** — deep document parser (hard PDFs)
3. **mem0** — agent memory layer
4. **AgentMemory MCP** — bridge to coding agents
5. **Vector DB** (Chroma → Qdrant at scale)

Replaces $50-200/mo of SaaS (Notion AI + Mem + Glean Lite) with self-hosted you own. 90-minute setup, MCP-native so every coding agent benefits.

Spin up a {{< aff "digitalocean" "footer-cta" "DigitalOcean $12/mo droplet" >}} for the entry tier, follow section 8, and your knowledge base is queryable from Claude Desktop / Cursor / OpenCode by tomorrow.

---

*Companion collections: [Self-Hosted AI Coding Workflow](/collections/self-hosted-ai-coding-workflow/) plugs this knowledge base into your coding agent stack. [Cheap LLM Stack](/collections/cheap-llm-stack/) covers the chat-LLM cost side. [Cross-Border AI Marketing Stack](/collections/cross-border-ai-marketing-stack/) for Chinese teams needing China-friendly hosting.*
