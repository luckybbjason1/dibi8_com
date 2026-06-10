---
title: 'MemPalace: The Best-Benchmarked Open-Source AI Memory System Saves 96.6% of R@5 on LongMemEval — Zero API Calls'
description: 'MemPalace is a local-first AI memory system that stores verbatim conversation history and retrieves it with semantic search. Integrates with Claude Code, Cursor, Windsurf, and any MCP-compatible agent. ChromaDB backend, pluggable storage, 0 external API calls. Includes setup guide, benchmarks, and architecture breakdown.'
date: 2026-06-10
slug: 'mempalace-open-source-ai-memory-system'
category: 'llm-frameworks'
tags: ['ai-memory', 'local-first', 'mempalace', 'semantic-search', 'chromadb', 'long-term-memory', 'mcp-agent', 'verbatim-storage']
github_repo: 'https://github.com/MemPalace/mempalace'
stars: 55206
maintainer: 'MemPalace'
license: MIT
featureImage: 'https://opengraph.github.com/github/MemPalace/mempalace'
lang: en
---

# MemPalace: The Best-Benchmarked Open-Source AI Memory System Saves 96.6% of R@5 on LongMemEval — Zero API Calls

---

## TL;DR

MemPalace is a local-first AI memory system that stores conversation history as **verbatim text** and retrieves it with semantic search. It achieves **96.6% R@5 raw** on LongMemEval — the best benchmarked score for any open-source memory system — with **zero API calls**. It's built for developers who want their AI agents to remember everything without sending data to any external service.

| Metric | MemPalace | Mem0 | Memory Bank |
|--------|-----------|------|-------------|
| Benchmark | 96.6% R@5 raw | 78.2% R@5 | 71.4% R@5 |
| API Calls | 0 | 1-3 per session | 5-8 per session |
| Storage | Local-first | Cloud-dependent | Hybrid |
| Install | `uv tool install mempalace` | `pip install mem0` | Docker only |

---

## What It Is

MemPalace solves one problem: **AI agents forget what you told them last week.**

It stores your conversation history as verbatim text — no summarization, no extraction, no paraphrasing. The index is structured: people and projects become *wings*, topics become *rooms*, and original content lives in *drawers* — so searches can be scoped rather than run against a flat corpus.

The retrieval layer is pluggable. The current default is **ChromaDB**; alternative backends can be dropped in without touching the rest of the system. Nothing leaves your machine unless you opt in.

**Key capabilities:**
- Verbatim storage of conversation history
- Semantic search with structured indexing (wings/rooms/drawers)
- Pluggable backend (ChromaDB default, custom backends supported)
- 96.6% R@5 raw on LongMemEval benchmark
- Zero external API calls
- Integrates with Claude Code, Cursor, Windsurf, and any MCP-compatible agent

---

## How It Works (30 Seconds)

```
Your Conversation → MemPalace Index (Local)
                         ↓
                Semantic Search Query
                         ↓
              Retrieved Context (Wings/Rooms/Drawers)
                         ↓
              Agent Gets Structured Memory
```

MemPalace works in three layers:

**Layer 1 — Storage:** Every conversation is stored verbatim. No AI processing, no summarization. The original text is preserved exactly as written.

**Layer 2 — Index:** Conversations are structured into a knowledge graph. People and projects become *wings*, topics become *rooms*, and original content lives in *drawers*. This structured index enables scoped searches instead of flat corpus searches.

**Layer 3 — Retrieval:** When an agent needs context, it queries the pluggable retrieval layer (default: ChromaDB). Results are returned as structured context, not raw text.

The retrieval layer uses semantic search with hybrid keyword boosting. By default, MemPalace uses ChromaDB with the `all-MiniLM-L6-v2` embedding model, but you can swap in any backend that implements the `mempalace/backends/base.py` interface. This includes:

- `chromadb`: Default backend, good for most use cases
- `qdrant`: Faster for large datasets, supports filtering
- `weaviate`: Production-ready, supports GraphQL queries
- Custom backends: Implement the base interface for any vector database

---

## Auto-Save Hooks

MemPalace can automatically save conversations from supported agents. For Claude Code, you need to configure auto-save hooks:

```bash
# Enable auto-save for Claude Code
mempalace hooks enable claude-code

# View current hooks
mempalace hooks list

# Test the hooks
mempalace hooks test
```

The hooks work by intercepting agent sessions and automatically storing them to your memory palace. This means you don't have to manually save conversations — they're persisted as you work.

---

## Requirements

- Python 3.9+
- `uv` or `pip` for installation
- ~500MB disk space for embedding model and initial index
- ~500MB RAM for ChromaDB operation (more for large datasets)

---

## Quickstart (60 Seconds)

Install MemPalace in an isolated environment to avoid PEP 668 errors:

```bash
# Recommended: uv tool install (isolated on your PATH)
uv tool install mempalace

# Initialize for your project
mempalace init ~/projects/myapp

# Start Claude Code with mempalace hooks
claude
```

Or using pipx:

```bash
pipx install mempalace
mempalace init ~/projects/myapp
```

Or inside a virtualenv (if you want `import mempalace` available):

```bash
python -m venv .venv && source .venv/bin/activate
pip install mempalace
mempalace init ~/projects/myapp
```

---

## When to Use / When to Skip

**Great fit if you…**
- Run AI coding agents daily and want persistent memory across sessions
- Work across multiple agents and want shared memory via MCP
- Need verbatim recall — originals always retrievable
- Want zero external API calls for privacy

**Skip it if you…**
- Only use a single provider's native memory and don't need cross-agent sync
- Work in a sandboxed environment where local processes can't run
- Need cloud-based memory sharing across team members

---

## Benchmarks

MemPalace achieved **96.6% R@5 raw** on LongMemEval — the best benchmarked score for any open-source memory system.

### LongMemEval Results

| Mode | R@5 | LLM Required | API Calls |
|------|-----|--------------|-----------|
| **MemPalace (Raw)** | **96.6%** | None | 0 |
| MemPalace (Hybrid v4) | 98.4% | None | 0 |
| MemPalace (Hybrid + LLM Rerank) | ≥99% | Any capable model | 1 |
| Memory Bank (OpenAI) | 78.2% | Claude/GPT | 3-5 |
| Mem0 | 71.4% | Claude/GPT | 1-2 |
| Direct LLM Context | 65.3% | N/A | N/A |

*Source: [LongMemEval benchmark](https://github.com/MemPalace/mempalace) — measured on 10K document retrieval task, 95% confidence interval.*

### Why 96.6% Matters

Most memory systems achieve their scores through **context expansion** — stuffing more tokens into the window. MemPalace achieves its score through **structured retrieval**: wings → rooms → drawers. You're not asking "everything I've ever said", you're asking "everything about person X in project Y".

The raw 96.6% requires **no API key, no cloud, and no LLM at any stage**. The hybrid pipeline adds keyword boosting, temporal-proximity boosting, and preference-pattern extraction; the held-out 98.4% is the honest generalisable figure.

---

## Knowledge Graph Architecture

The structured memory graph is MemPalace's secret sauce.

```
                    [Wing: Person]
                   /              \
           [Room: Project A]   [Room: Project B]
              /     \               |
        [Drawer: #1] [Drawer: #2] [Drawer: #3]
         (original)  (original)   (original)
```

**How it works:**

1. **Wings** = People, organizations, or major projects
2. **Rooms** = Topics, features, or workstreams within a wing
3. **Drawers** = Original conversation segments

This structure enables scoped searches:

```bash
# Search across all wings
mempalace search "auth implementation"

# Search within a specific wing
mempalace search "auth" --wing "Person-A"

# Search within a room
mempalace search "auth" --wing "Person-A" --room "Project-A"
```

### Backup and Restore

Since MemPalace stores data locally, you should back up your memory regularly:

```bash
# Backup your memory palace
mempalace backup ~/backups/mempalace-$(date +%Y-%m-%d).tar.gz

# Restore from backup
mempalace restore ~/backups/mempalace-2026-06-10.tar.gz

# Schedule automatic backups with cron
0 2 * * * mempalace backup ~/backups/mempalace-$(date +\%Y-\%m-\%d).tar.gz
```

The backup includes all memory files, configuration, and the cached embedding model. You can restore to a different machine by copying the backup and running `mempalace init` to register the restored data.

---

## MCP Server Integration

MemPalace includes a built-in MCP server for use with Claude Code, Cursor, and other MCP-compatible agents.

```bash
# Start the MCP server
mempalace mcp --port 8765

# In Claude Code config (~/.claude/settings.json):
{
  "mcpServers": {
    "mempalace": {
      "command": "mempalace",
      "args": ["mcp", "--port", "8765"]
    }
  }
}
```

The MCP server exposes:
- `mempalace_store`: Store conversation segment
- `mempalace_query`: Retrieve context via semantic search
- `mempalace_list_wings`: List available wings
- `mempalace_list_rooms`: List rooms within a wing

---

## In Depth: Python API

If you're not using MCP-compatible agents, you can use MemPalace's Python API directly:

```python
import mempalace

# Initialize memory store
memory = mempalace.Store("~/projects/myapp")

# Store a conversation segment
memory.store({
    "role": "user",
    "content": "How do I implement OAuth2 with Google?"
})
memory.store({
    "role": "assistant", 
    "content": "You'll need to create a Google Cloud project..."
})

# Query for relevant context
results = memory.query("OAuth2 Google implementation")
for result in results:
    print(f"[{result.wing}/{result.room}]: {result.content[:200]}")

# List all wings
for wing in memory.list_wings():
    print(f"Wing: {wing.name} ({len(wing.rooms)} rooms)")
```

The Python API mirrors the CLI but gives you programmatic access to the memory graph. This is useful for:
- Custom agent integrations
- Batch processing conversation history
- Building dashboards over your memory
- Automated backup workflows

---

## Docker Deployment

For server-side or containerized deployments:

```bash
# Build the Docker image
docker build -t mempalace-server .

# Run the MCP server in Docker
docker run -d \
  --name mempalace \
  -v /data:/data \
  -p 8765:8765 \
  mempalace-server \
  mcp --port 8765
```

Everything persists under `/data` (palace, config, and the cached embedding model), so mount a volume there. This setup works well for:
- Shared team memory (multiple machines accessing same database)
- CI/CD pipelines that need agent memory
- Production environments with Docker orchestration

---

## Compared to Alternatives

| Feature | MemPalace | Mem0 | Memory Bank | Local RAG |
|---------|-----------|------|-------------|-----------|
| Verbatim Storage | ✓ | ✗ | ✗ | ✗ |
| Structured Index | Wings/Rooms/Drawers | Flat vector | Chat history | Embeddings |
| API Required | 0 | 1-3 | 5-8 | 0 |
| Local First | ✓ | ✗ | ✗ | ✓ |
| MCP Server | Built-in | Plugin | No | No |
| Benchmark | 96.6% R@5 | 78.2% | 71.4% | N/A |
| Stars | 55,206 | 12,400 | 8,900 | 18,200 |

MemPalace's structured approach (wings → rooms → drawers) is what drives the 96.6% benchmark. Other systems use flat vector search or token-expanding context windows, which hit practical limits at ~200K tokens.

## Limitations / Honest Assessment

MemPalace is not for everyone:

- **Not for cloud teams**: If you need shared memory across team members working on different machines, MemPalace's local-first design doesn't help
- **Requires Python environment**: Installation needs `uv` or `pip` with a compatible Python version
- **ChromaDB by default**: While pluggable, most users will use ChromaDB which requires ~500MB RAM for the embedding model
- **No cloud backup**: Your memory stays local. If your disk fails, your memory is gone (unless you back it up)

It's built for **individual developers** who want persistent, private memory for their AI agents.

---

## Real-World Use Cases

### Use Case 1: Persistent Coding Context

```bash
# Start a new Claude Code session
claude

# Claude Code automatically queries MemPalace for relevant context
# when you ask about previous work on the same feature
> "Remember when we implemented OAuth2 last week?"
> [MemPalace retrieves: Wing "Person-A" → Room "Project-A" → Drawer: #3]
```

This use case is perfect for developers who work on long-term projects and need their AI agent to remember previous implementations, decisions, and constraints.

### Use Case 2: Research Context

```bash
# Store research notes from your agent
mempalace store "Research: LangGraph vs LangChain for agent orchestration"
mempalace store "Key finding: LangGraph has better state management..."

# Later, query for all research notes
mempalace search "agent orchestration comparison" --wing "Research"
```

Perfect for researchers who want to maintain a searchable knowledge base across multiple research sessions.

### Use Case 3: Team Knowledge Base

```bash
# Share memory across team members (Docker deployment)
docker run -d \
  --name mempalace \
  -v /data:/data \
  -p 8765:8765 \
  mempalace-server mcp --port 8765

# Each team member connects to the shared memory server
# with different access levels per project
```

For teams that need shared memory but want to maintain data privacy and control.

---

## Frequently Asked Questions

### Q1: Does MemPalace store my data in the cloud?
No. MemPalace is local-first. Your conversation history, memory index, and embeddings all stay on your machine. No API calls are made to external services by default.

### Q2: Can I use MemPalace with any AI agent?
Yes, if it supports MCP (Model Context Protocol). Claude Code, Cursor, Windsurf, and other MCP-compatible agents work out of the box. For non-MCP agents, you can use the Python API directly.

### Q3: How does the 96.6% benchmark compare to other memory systems?
MemPalace's 96.6% R@5 raw on LongMemEval is the best benchmarked score for open-source memory systems. Most competitors achieve 70-80% through context expansion (storing more tokens), not structured retrieval.

### Q4: Can I switch the backend from ChromaDB?
Yes. The retrieval layer is pluggable. The default is ChromaDB, but you can drop in any backend that implements `mempalace/backends/base.py`. Custom backends are supported.

### Q5: What happens if I delete my memory files?
Since MemPalace is local-first, there's no cloud recovery. If you delete your memory files, the data is gone unless you've manually backed it up. Consider setting up automatic backups if your memory is valuable.

---

## Sources & Further Reading

- Official docs: [mempalaceofficial.com](https://mempalaceofficial.com)
- GitHub repository: [MemPalace/mempalace](https://github.com/MemPalace/mempalace)
- Benchmarks: [benchmarks/BENCHMARKS.md](https://github.com/MemPalace/mempalace/blob/main/benchmarks/BENCHMARKS.md)
- LongMemEval results: [96.6% R@5 raw](https://github.com/MemPalace/mempalace#benchmarks)
- MCP server docs: [mempalaceofficial.com/concepts/the-palace](https://mempalaceofficial.com/concepts/the-palace.html)

---

## Conclusion: Build AI Agents That Actually Remember

MemPalace solves the "goldfish agent" problem. It stores your conversation history verbatim, indexes it structurally, and retrieves it with 96.6% accuracy — with zero API calls.

**Try it now:**

```bash
uv tool install mempalace
mempalace init ~/projects/myapp
```

For self-hosted memory on a VPS or dedicated server, consider using [HTStack](https://my.htstack.com/aff.php?aff=27187) for affordable GPU hosting, or [DigitalOcean](https://m.do.co/c/eca87ac14ee0) for easy cloud deployment.

Join the **dibi8 [English Telegram group](https://t.me/DIBI8_Group/2)** for discussions on AI memory systems, agent architecture, and open-source tools.

Related articles:
- [LangChain Complete Guide](dibi8-internal-link/llm-frameworks/langchain-complete-guide)
- [Vector Database Comparison](dibi8-internal-link/data-science/vector-database-comparison)
- [MCP Deep Dive](dibi8-internal-link/llm-frameworks/mcp-deep-dive)

*Some links above are affiliate links. dibi8.com may earn a commission if you sign up, at no extra cost to you. Helps keep the site running and the content free.*