---
title: 'Supermemory: The Fastest Open-Source AI Memory API for Building LLM Apps That Remember Everything'
description: 'Supermemory is an open-source memory engine and app for AI applications. Fast, scalable memory API with vector search, graph search, and session management. Integrates with LangChain, LlamaIndex, CrewAI, and any Python/JS app. Self-hosted, zero external dependencies. Includes setup guide, benchmarks, and production deployment.'
tags: ["ai-agent", "ai-memory", "api", "memory", "open-source", "persistence", "self-hosted"]
date: 2026-06-10
slug: 'supermemory-open-source-ai-memory-api'
category: llm-frameworks
github_repo: 'https://github.com/supermemoryai/supermemory'
license: MIT
lang: en
featureImage: /articles/aitoearn-open-source-ai-content-monetiza-9c8ad4.png/images/articles/aitoearn-open-source-ai-content-monetiza-9c8ad4.png
---

# Supermemory: The Fastest Open-Source AI Memory API for Building LLM Apps That Remember Everything

---

## TL;DR

Supermemory is an open-source memory engine and app for AI applications. It provides a memory API with vector search, graph search, and session management. It's the fastest self-hosted memory solution, designed for LLM apps that need persistent memory without external dependencies.

Supermemory is an open-source memory engine and app for AI applications. It provides a memory API with vector search, graph search, and session management. It's the fastest self-hosted memory solution, designed for LLM apps that need persistent memory without external dependencies.

| Metric | Supermemory | Mem0 | LangChain Memory |
|--------|-------------|------|------------------|
| Latency | < 5ms | 15-30ms | 50-100ms |
| Setup | `pip install supermemory` | Docker | Complex |
| Dependencies | None | Cloud API | Many |
| Self-hosted | ✓ | Limited | N/A |

Supermemory achieves sub-5ms latency for memory retrieval — the fastest among open-source memory engines. It's designed for developers who want persistent memory for their LLM apps without external dependencies. All data stays on your infrastructure, giving you full control over privacy and security. With support for 1M+ entries, 50+ languages, and 3+ search modes (vector, graph, full-text), Supermemory is the most scalable memory solution for AI applications.

---

## What It Is

Supermemory solves one problem: **LLM apps forget everything between sessions.**

It provides a memory API that stores conversations, user preferences, and knowledge as structured data. Unlike simple vector databases, Supermemory combines vector search with graph relationships — so your app can remember not just "what was said" but "who said it, when, and how it connects to other things."

**Key capabilities:**
- Vector search for semantic similarity
- Graph search for relationship querying
- Session management for conversation threads
- Self-hosted with zero external dependencies
- Python and JavaScript API
- Integrates with LangChain, LlamaIndex, CrewAI

Supermemory is designed for developers who want persistent memory for their LLM apps without relying on external APIs or cloud services. All data stays on your infrastructure, giving you full control over privacy and security. It supports 1M+ entries, 50+ languages, and 3+ search modes (vector, graph, full-text) — making it the most scalable memory solution for AI applications.

---

## How It Works (30 Seconds)

```
User Input → Supermemory API → Memory Store
                           ↓
              Semantic Search (Vector)
              + Relationship Search (Graph)
                           ↓
              Structured Context Returned
                           ↓
              LLM Gets Rich Context
```

Supermemory works in three layers:

**Layer 1 — Storage:** Conversations, preferences, and facts are stored as structured data. Each memory entry has metadata: user ID, timestamp, source, and relationships.

**Layer 2 — Index:** Memories are indexed for both vector search (semantic similarity) and graph search (relationship querying). This dual-indexing enables both "find similar memories" and "find memories about person X from project Y."

**Layer 3 — Retrieval:** When your app needs context, it queries the memory API. Results include both semantic matches and relationship graphs — so the LLM gets structured context, not raw text.

---

## Quickstart (60 Seconds)

Install Supermemory in your Python project:

```bash
pip install supermemory

# Initialize memory for your app
python -c "import supermemory; m = supermemory.Memory(); m.init()"

# Store a memory
m.add("User likes spicy food")
m.add("User is allergic to shellfish")

# Retrieve relevant memories
memories = m.search("dietary preferences")
print(memories)
```

Or using Docker for production:

```bash
docker run -d \
  --name supermemory \
  -p 8000:8000 \
  supermemoryai/supermemory:latest

# API available at http://localhost:8000
```

---

## When to Use / When to Skip

**Great fit if you…**
- Build LLM apps that need persistent memory
- Want self-hosted memory without external dependencies
- Need both vector and graph search
- Use LangChain, LlamaIndex, or CrewAI

**Skip it if you…**
- Need cloud-based memory sharing across users
- Work in environments where Python can't run
- Only need simple key-value storage

---

## Benchmarks

Supermemory achieves sub-5ms latency for memory retrieval — the fastest among open-source memory engines.

### Performance Comparison

| Metric | Supermemory | Mem0 | LangChain |
|--------|-------------|------|-----------|
| Latency | < 5ms | 15-30ms | 50-100ms |
| Setup Time | 60s | 5min | 30min |
| Memory Limit | 1M entries | 100K entries | 10K entries |
| Dependencies | 0 | 3-5 | 10+ |

*Source: [Supermemory benchmarks](https://github.com/supermemoryai/supermemory)*

---

## Python API

```python
import supermemory

# Initialize memory
m = supermemory.Memory()
m.init()

# Add memories with metadata
m.add("User likes spicy food", tags=["diet", "preference"])
m.add("User works at Google", tags=["work", "company"])

# Semantic search
results = m.search("dietary preferences", top_k=5)

# Graph search
connected = m.get_connections("User works at Google")

# Session management
session = m.create_session()
session.add("User preferences")
session.query("What does this user like?")
```

### Advanced Features

```python
# Add memories with timestamps
m.add("Meeting with John at 3pm", timestamp="2026-06-10T15:00:00")

# Filter by metadata
filtered = m.search("meeting", metadata={"tags": ["work"]})

# Update memories
m.update("User likes spicy food", "User prefers very spicy food")

# Delete memories
m.delete("Outdated memory")

# Backup and restore
m.backup("backup.tar.gz")
m.restore("backup.tar.gz")
```

The Python API provides full CRUD operations, metadata filtering, and session management. It's designed for both simple use cases and complex production deployments.

---

## Docker Production Deployment

For production environments, use Docker to deploy Supermemory:

```bash
# Build the Docker image
docker build -t supermemory-server .

# Run with environment variables
docker run -d \
  --name supermemory \
  -e SUPERMEMORY_PORT=8000 \
  -e SUPERMEMORY_HOST=0.0.0.0 \
  -v /data/supermemory:/data \
  -p 8000:8000 \
  supermemory-server

# Check logs
docker logs -f supermemory

# Health check
curl http://localhost:8000/health
```

Docker deployment supports:
- Persistent data storage via volume mounts
- Environment variable configuration
- Health check endpoints
- Log management and monitoring
- Horizontal scaling with Docker Swarm or Kubernetes

---

## API Reference

Supermemory exposes a REST API for programmatic access:

```bash
# Get all memories
curl http://localhost:8000/memories

# Add a new memory
curl -X POST http://localhost:8000/memories \
  -H "Content-Type: application/json" \
  -d '{"text": "User prefers dark mode", "tags": ["preference"]}'

# Search memories
curl "http://localhost:8000/memories/search?q=dark+mode&limit=5"

# Delete a memory
curl -X DELETE http://localhost:8000/memories/{id}
```

The API supports:
- CRUD operations for memories
- Vector search queries
- Graph relationship queries
- Session management endpoints
- Batch operations for bulk imports

---

## Use Cases

### Use Case 1: Customer Support Bot

```python
# Store customer preferences
memory.add("Customer prefers email contact", tags=["customer", "contact"])
memory.add("Customer has premium subscription", tags=["customer", "subscription"])

# Retrieve context for support queries
context = memory.search("premium features", top_k=10)
```

### Use Case 2: Personalized Recommendation Engine

```python
# Track user interactions
memory.add("User clicked on Python tutorial", tags=["interaction", "python"])
memory.add("User completed SQL course", tags=["interaction", "sql"])

# Generate recommendations based on history
recommendations = memory.search("user learning path", top_k=5)
```

### Use Case 3: Research Knowledge Base

```python
# Store research notes
memory.add("Paper: Attention Is All You Need", tags=["research", "transformer"])
memory.add("Experiment: BERT vs GPT on NLI", tags=["research", "experiment"])

# Cross-reference findings
related = memory.get_connections("transformer models")
```

---

## JavaScript API

```javascript
import { Memory } from 'supermemory';

const m = new Memory();
await m.init();

await m.add('User likes spicy food', { tags: ['diet'] });
const results = await m.search('dietary preferences', { top_k: 5 });
```

---

## LangChain Integration

```python
from langchain.memory import SupermemoryMemory

memory = SupermemoryMemory(
    session_id="user-123",
    return_messages=True
)

chat_history = memory.chat_memory
print(chat_history.messages)
```

---

## Compared to Alternatives

| Feature | Supermemory | Mem0 | LangChain Memory |
|---------|-------------|------|------------------|
| Self-hosted | ✓ | Limited | N/A |
| Vector Search | ✓ | ✓ | ✓ |
| Graph Search | ✓ | ✗ | ✗ |
| Python API | ✓ | ✓ | ✓ |
| JS API | ✓ | ✗ | ✗ |
| Latency | < 5ms | 15-30ms | 50-100ms |
| Dependencies | 0 | 3-5 | 10+ |

Supermemory's dual-indexing approach enables both semantic and relationship queries, making it the most versatile memory solution for AI applications.

---

## Limitations / Honest Assessment

Supermemory is not for everyone:

- **Not for cloud teams**: Self-hosted means you manage the infrastructure
- **Python-first**: JavaScript API exists but Python is the primary language
- **No team sharing**: Memory is per-app, not shared across organizations

It's built for **individual developers and small teams** who want persistent memory for their LLM apps without external dependencies.

---

## Security Considerations

For production deployments, ensure you:

- Use HTTPS for all API connections
- Enable authentication via API keys or JWT tokens
- Regularly backup your memory data
- Monitor access logs for suspicious activity
- Encrypt sensitive memories at rest using AES-256

```bash
# Enable HTTPS with Let's Encrypt
sudo certbot --nginx -d supermemory.yourdomain.com

# Configure API key authentication
export SUPERMEMORY_API_KEY=*** Start with security enabled
docker run -d \
  --name supermemory \
  -e SUPERMEMORY_API_KEY=*** \
  -p 443:443 \
  supermemory-server
```

Supermemory stores sensitive data including conversations and preferences. For production use, implement these security measures to protect your data. Regular security audits and penetration testing are recommended for high-security deployments.

### Q1: Does Supermemory require any external services?
No. Supermemory is self-hosted with zero external dependencies. Everything runs on your own infrastructure.

### Q2: Can I use Supermemory with any LLM framework?
Yes. It provides Python and JavaScript APIs that work with LangChain, LlamaIndex, CrewAI, or any framework that can make HTTP requests.

### Q3: What's the difference between vector search and graph search?
Vector search finds semantically similar memories. Graph search finds memories connected by relationships (same user, same project, same time period). Supermemory provides both.

### Q4: How many memories can Supermemory handle?
Supermemory supports up to 1 million entries per app instance. For larger datasets, you can scale horizontally across multiple instances.

### Q5: Can I use Supermemory in production?
Yes. Supermemory includes Docker deployment options and is designed for production use. The self-hosted architecture means you control the infrastructure.

### Q6: How does Supermemory handle data privacy?
All data stays on your infrastructure. No external APIs are called. You can encrypt data at rest and in transit using standard TLS.

### Q7: Can I migrate data from other memory systems?
Yes. Supermemory supports bulk import via CSV, JSON, and custom data formats. Migration scripts are available for common systems.

---

## Sources & Further Reading

- Official docs: [supermemory.dev](https://supermemory.dev)
- GitHub repository: [supermemoryai/supermemory](https://github.com/supermemoryai/supermemory)
- Python API docs: [GitHub](https://github.com/supermemoryai/supermemory#python-api)
- JavaScript API docs: [GitHub](https://github.com/supermemoryai/supermemory#javascript-api)

---

## Conclusion: Build LLM Apps That Actually Remember

Supermemory solves the "goldfish LLM app" problem. It stores memories as structured data, indexes them for both vector and graph search, and returns structured context — all self-hosted with zero external dependencies.

**Try it now:**

```bash
pip install supermemory
python -c "import supermemory; m = supermemory.Memory(); m.init()"
```

For self-hosted memory on a VPS, consider using [HTStack](https://my.htstack.com/aff.php?aff=27187) for affordable GPU hosting, or [DigitalOcean](https://m.do.co/c/eca87ac14ee0) for easy cloud deployment.

**Quick Start Command:**

```bash
# One-liner setup
pip install supermemory && python -c "
import supermemory
m = supermemory.Memory()
m.init()
m.add('Test memory')
print('Supermemory initialized!')
print(m.search('test'))
"
```

This command demonstrates how to initialize Supermemory, add a test memory, and search for it — all in one command. It's perfect for getting started quickly with your own LLM applications.

Supermemory solves the "goldfish LLM app" problem by providing persistent memory that actually remembers everything your users say. It's the most scalable memory solution for AI applications, with support for 1M+ entries, 50+ languages, and 3+ search modes (vector, graph, full-text).

Join the **dibi8 [English Telegram group](https://t.me/DIBI8_Group/2)** for discussions on AI memory systems and LLM app architecture.

Related articles:
- [Vector Database Comparison](/resources/llm-frameworks/vector-database-comparison/)

*Some links above are affiliate links. dibi8.com may earn a commission if you sign up, at no extra cost to you. Helps keep the site running and the content free.*