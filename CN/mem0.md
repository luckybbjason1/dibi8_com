---
title: 'Mem0: 56K+ Stars — AI Agent Memory Performance Tuning Guide 2026'
description: 'Mem0 (mem0ai) is a universal memory layer for AI agents. Compatible with Claude Code, OpenAI, LangChain, CrewAI, Cursor. Covers mem0 tutorial, persistent memory setup, vector store tuning, and production deployment benchmarks.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/mem0ai/mem0'
stars: 56205
maintainer: 'mem0ai'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['mem0', 'ai-agent-memory', 'persistent-memory', 'langchain', 'vector-store', 'memory-tuning', 'mem0-tutorial', 'mem0-vs-langchain', 'crewai', 'open-source']
aliases:
- /posts/mem0/
---

{{</* resource-info */>}}

## Introduction

Every AI agent developer hits the same wall: the agent forgets. A user tells your chatbot they are vegetarian and allergic to nuts in one session, and two hours later the agent recommends a peanut curry. This is not a prompt engineering problem — it is a memory architecture problem. State-free LLMs have no built-in mechanism to persist facts across sessions. Mem0 (mem0ai/mem0) fixes this with a drop-in memory layer that 56,205+ GitHub stars and 90,000+ developers have adopted. This guide covers the complete mem0 setup from installation to production tuning, with real benchmarks, vector store configuration, and integration code for LangChain, CrewAI, and OpenAI agents.

## What Is Mem0?

Mem0 is an open-source universal memory layer for LLM applications and AI agents. It extracts, stores, and retrieves user-specific facts across conversations using a hybrid architecture that combines vector similarity search with structured memory extraction. The system automatically distills raw chat messages into semantic facts ("User is a vegetarian"), deduplicates them, and surfaces the most relevant memories at inference time — all through a REST API or Python/TypeScript SDK.

## How Mem0 Works

Mem0's architecture separates memory into four operational layers:

**1. Extraction Layer**: An LLM (configurable, default GPT-4o-mini) processes incoming messages and extracts structured facts. The April 2026 token-efficient algorithm uses single-pass hierarchical extraction that reduces token usage by 3-4x compared to full-context baselines.

**2. Embedding Layer**: Extracted facts are vectorized using an embedding model (default: text-embedding-3-small) and stored in a vector database. Mem0 supports 19 vector store backends including Qdrant, Chroma, PGVector, Pinecone, Weaviate, Milvus, and Azure AI Search.

**3. Retrieval Layer**: At query time, Mem0 performs hybrid retrieval combining vector similarity with metadata filtering, reranking, and multi-signal scoring. The multi-signal retrieval considers recency, relevance, and importance to surface the best memories.

**4. Graph Layer (Pro tier)**: Beyond flat vector storage, Mem0 Pro builds a knowledge graph that understands entity relationships — enabling multi-hop reasoning ("Who does James work with?" requires connecting "James works at TechCorp" + "Sarah works at TechCorp").

```
┌──────────────────────────────────────────────────────┐
│                    User Message                       │
└──────────────────────┬───────────────────────────────┘
                       │
          ┌────────────▼────────────┐
          │   Extraction (LLM)      │  ← Extract facts
          └────────────┬────────────┘
                       │
          ┌────────────▼────────────┐
          │   Embedding Model       │  ← Vectorize
          └────────────┬────────────┘
                       │
          ┌────────────▼────────────┐
          │   Vector Store          │  ← Qdrant/Chroma/PGVector
          └────────────┬────────────┘
                       │
          ┌────────────▼────────────┐
          │   Hybrid Retrieval      │  ← Search + Rerank
          └────────────┬────────────┘
                       │
          ┌────────────▼────────────┐
          │   Injected into Prompt  │  ← Context enrichment
          └─────────────────────────┘
```

## Installation & Setup

### Cloud Setup (Fastest Path)

```bash
# Install the Python client
pip install mem0ai

# Set your API key from https://app.mem0.ai
export MEM0_API_KEY="m0-your-key-here"
```

```python
# mem0_quickstart.py
import os
from mem0 import MemoryClient

client = MemoryClient(api_key=os.getenv("MEM0_API_KEY"))

# Store a memory from a conversation
messages = [
    {"role": "user", "content": "I'm a vegetarian and allergic to nuts."},
    {"role": "assistant", "content": "Got it! I'll remember your dietary preferences."},
]
client.add(messages, user_id="user123")

# Retrieve relevant memories
results = client.search(
    "What are my dietary restrictions?",
    user_id="user123"
)
print(results)
```

### Self-Hosted Setup (Docker)

For teams that need data residency or air-gapped deployments:

```bash
# Clone the repository
git clone https://github.com/mem0ai/mem0.git
cd mem0

# Bootstrap with Docker
make bootstrap
# Creates admin user, generates API key, starts server + dashboard
```

```yaml
# docker-compose.yml for production
docker run -d \
  -p 8000:8000 \
  -e MEM0_API_KEY=your-admin-key \
  -e VECTOR_STORE_PROVIDER=qdrant \
  -e VECTOR_STORE_URL=http://qdrant:6333 \
  -e LLM_PROVIDER=openai \
  -e OPENAI_API_KEY=$OPENAI_API_KEY \
  mem0/mem0-server:latest
```

### Open Source SDK (Local)

```bash
pip install mem0ai openai chromadb
```

```python
from mem0 import Memory

# Initialize with custom vector store
m = Memory()

# Add a conversation
messages = [
    {"role": "user", "content": "I'm planning to watch a movie tonight."},
    {"role": "assistant", "content": "How about thrillers?"},
    {"role": "user", "content": "I love sci-fi but hate horror."},
]
m.add(messages, user_id="alice", metadata={"category": "movies"})

# Search with metadata filtering
results = m.search("movie recommendations", filters={"user_id": "alice"})
```

## Memory Configuration & Performance Tuning

### Custom Configuration with YAML

The `mem0config.yaml` file controls every component of the memory pipeline:

```yaml
# mem0config.yaml — Production tuning config
llm:
  provider: openai
  config:
    model: "gpt-4o-mini"
    temperature: 0.1
    max_tokens: 2000

embedder:
  provider: openai
  config:
    model: "text-embedding-3-small"
    embedding_dims: 1536

vector_store:
  provider: qdrant
  config:
    host: "localhost"
    port: 6333
    collection_name: "mem0"
    on_disk: true  # Enable persistent storage

reranker:
  provider: cohere
  config:
    model: "rerank-multilingual-v3.0"

custom_instructions: |
  Extract user preferences, personal facts, and context.
  Focus on dietary restrictions, allergies, and technical preferences.
  Ignore temporary states and one-time requests.
```

```python
from mem0 import Memory

# Load custom configuration
config_path = "mem0config.yaml"
m = Memory.from_config(config_path)
```

### Vector Store Backend Comparison

| Backend | Best For | Latency | Persistence | Scaling |
|---------|----------|---------|-------------|---------|
| Qdrant | Production, hybrid search | <10ms | On-disk | Horizontal |
| Chroma | Local dev, prototyping | <20ms | File-based | Single node |
| PGVector | Postgres ecosystems | <30ms | Database-managed | Read replicas |
| Pinecone | Serverless, managed | <15ms | Cloud | Auto-scaling |
| Milvus | Billion-scale | <20ms | Distributed | Sharding |

### Performance Tuning Checklist

```python
# 1. Enable async memory for high-throughput apps
from mem0 import MemoryClient
import asyncio

client = MemoryClient()

async def batch_store(messages_list):
    tasks = [client.add_async(msgs, user_id=f"user_{i}")
             for i, msgs in enumerate(messages_list)]
    return await asyncio.gather(*tasks)

# 2. Use metadata filtering to scope searches
results = client.search(
    "project updates",
    filters={
        "user_id": "alice",
        "metadata.category": "work"
    },
    limit=10
)

# 3. Adjust retrieval depth with top_k
results = client.search(
    "dietary preferences",
    user_id="alice",
    top_k=5,  # Reduce for speed, increase for coverage
    rerank=True
)
```

### Memory with Custom Instructions

```python
# Guide what facts get extracted and stored
m = Memory.from_config({
    "custom_instructions": """
    Extract and store:
    - User's name, profession, location
    - Technical preferences (languages, frameworks, tools)
    - Dietary restrictions and allergies
    - Communication preferences

    Do NOT store:
    - Temporary mood or emotional states
    - One-time requests
    - Third-party information without consent
    """
})
```

## Integration with LangChain, CrewAI, and OpenAI

### LangChain Integration

```bash
pip install langchain langchain-openai mem0ai
```

```python
# langchain_mem0_agent.py
import os
from typing import List, Dict
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage, AIMessage
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from mem0 import MemoryClient

# Initialize
llm = ChatOpenAI(model="gpt-4o-mini")
mem0 = MemoryClient(api_key=os.getenv("MEM0_API_KEY"))

# Prompt template with memory injection
prompt = ChatPromptTemplate.from_messages([
    ("system", """You are a helpful assistant with long-term memory.
    Relevant past context about the user:
    {memories}

    Use this context to personalize your responses."""),
    MessagesPlaceholder(variable_name="history"),
    ("human", "{input}")
])

def get_memories(user_id: str, query: str) -> str:
    """Retrieve relevant memories as formatted string."""
    results = mem0.search(query, user_id=user_id, limit=5)
    return "\n".join([r["memory"] for r in results])

def chat(user_id: str, message: str, history: List = None):
    """Chat with memory-augmented context."""
    if history is None:
        history = []

    memories = get_memories(user_id, message)
    formatted_prompt = prompt.format_messages(
        memories=memories,
        history=history,
        input=message
    )

    response = llm.invoke(formatted_prompt)

    # Store the interaction
    messages = [
        {"role": "user", "content": message},
        {"role": "assistant", "content": response.content}
    ]
    mem0.add(messages, user_id=user_id)

    return response.content

# Run a conversation
user_id = "traveler_42"
response1 = chat(user_id, "I'm planning a trip to Tokyo next month.")
print(response1)

# Later session — agent remembers
response2 = chat(user_id, "What should I pack for my trip?")
# Output references Tokyo, time of year, traveler's preferences
```

### CrewAI Integration

```bash
pip install crewai mem0ai
```

```python
# crewai_mem0_crew.py
import os
from crewai import Agent, Task, Crew
from crewai_tools import tool
from mem0 import MemoryClient

mem0 = MemoryClient(api_key=os.getenv("MEM0_API_KEY"))

@tool
def retrieve_user_context(user_id: str, query: str) -> str:
    """Retrieve memories about the user for personalization."""
    results = mem0.search(query, user_id=user_id, limit=5)
    return "\n".join([f"- {r['memory']}" for r in results])

@tool
def store_interaction(user_id: str, content: str) -> str:
    """Store facts learned during agent interaction."""
    messages = [{"role": "assistant", "content": content}]
    mem0.add(messages, user_id=user_id)
    return "Stored."

# Define agents with memory tools
researcher = Agent(
    role="Personal Researcher",
    goal="Provide personalized research based on user history",
    backstory="You remember user preferences and tailor research accordingly.",
    tools=[retrieve_user_context, store_interaction],
    verbose=True,
    memory=True
)

# Task that uses memory
task = Task(
    description="""Research travel options for user {{user_id}}.
    First retrieve their preferences, then provide personalized recommendations.
    Query: travel preferences""",
    expected_output="Personalized travel recommendations",
    agent=researcher
)

crew = Crew(agents=[researcher], tasks=[task])
result = crew.kickoff(inputs={"user_id": "user123"})
print(result)
```

### OpenAI Agents SDK Integration

```bash
pip install openai-agents mem0ai
```

```python
# openai_agents_mem0.py
import os
from dataclasses import dataclass
from agents import Agent, Runner, function_tool
from mem0 import MemoryClient

mem0 = MemoryClient(api_key=os.getenv("MEM0_API_KEY"))

@dataclass
class UserContext:
    user_id: str

@function_tool
def add_to_memory(ctx, messages: str) -> str:
    """Store facts about the user."""
    parsed = [{"role": "user", "content": m} for m in messages.split("\n")]
    mem0.add(parsed, user_id=ctx.context.user_id)
    return "Memory stored."

@function_tool
def search_memory(ctx, query: str) -> str:
    """Search for relevant memories."""
    results = mem0.search(query, user_id=ctx.context.user_id, limit=5)
    return "\n".join([r["memory"] for r in results])

memory_agent = Agent(
    name="MemoryAgent",
    instructions="You are a helpful assistant that remembers user preferences.",
    tools=[add_to_memory, search_memory],
    model="gpt-4o-mini"
)

async def run_agent():
    context = UserContext(user_id="user_42")
    result = await Runner.run(
        memory_agent,
        "I'm a vegetarian who loves Italian food.",
        context=context
    )
    print(result.final_output)

# asyncio.run(run_agent())
```

### Docker Compose Production Stack

```yaml
# mem0-production-stack.yml
version: "3.8"

services:
  qdrant:
    image: qdrant/qdrant:latest
    ports:
      - "6333:6333"
      - "6334:6334"
    volumes:
      - qdrant_storage:/qdrant/storage
    environment:
      - QDRANT__SERVICE__GRPC_PORT=6334

  mem0-server:
    image: mem0/mem0-server:latest
    ports:
      - "8000:8000"
    environment:
      - MEM0_API_KEY=${MEM0_API_KEY}
      - VECTOR_STORE_PROVIDER=qdrant
      - VECTOR_STORE_URL=http://qdrant:6333
      - LLM_PROVIDER=openai
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - EMBEDDER_PROVIDER=openai
      - OPENAI_EMBEDDING_MODEL=text-embedding-3-small
    depends_on:
      - qdrant

  mem0-dashboard:
    image: mem0/mem0-dashboard:latest
    ports:
      - "3000:3000"
    environment:
      - MEM0_API_URL=http://mem0-server:8000
      - MEM0_API_KEY=${MEM0_API_KEY}

volumes:
  qdrant_storage:
```

## Benchmarks / Real-World Use Cases

### LoCoMo and LongMemEval Results

Mem0's new token-efficient algorithm (released April 2026) delivers significant accuracy improvements at lower token cost:

| Benchmark | Metric | Old Algorithm | New Algorithm (April 2026) | Improvement |
|-----------|--------|---------------|---------------------------|-------------|
| LoCoMo | Overall Accuracy | 66.9% | **92.5%** | +25.6 points |
| LoCoMo | Mean Tokens/Query | ~26,000 | **6,956** | 3.7x reduction |
| LongMemEval | Overall Accuracy | 65.3% | **94.4%** | +29.1 points |
| LongMemEval | Mean Tokens/Query | ~25,000 | **6,787** | 3.7x reduction |
| BEAM (1M) | Accuracy | 42.5% | **64.1%** | +21.6 points |
| BEAM (10M) | Accuracy | 30.2% | **48.6%** | +18.4 points |

### Per-Category Breakdown (LoCoMo)

| Category | Old Score | New Score | Delta |
|----------|-----------|-----------|-------|
| Single-hop | 76.6% | 94.6% | +18.0 |
| Multi-hop | 70.2% | 95.4% | +25.2 |
| Open-domain | 57.3% | 82.3% | +25.0 |
| Temporal | 63.2% | 92.5% | +29.3 |

### Production Use Cases

**Case Study: Customer Support Agent**
- Company: SaaS platform with 50K+ users
- Setup: Mem0 OSS + Qdrant + GPT-4o-mini
- Results: 40% reduction in repeat questions, 25% faster resolution
- Memory stored: 2.3M facts across 180K conversations

**Case Study: AI Coding Assistant**
- Setup: Mem0 plugin for Claude Code
- Results: Agent remembers coding preferences (tabs vs spaces, preferred libraries), project structure context
- Key feature: Cross-session file context without re-indexing

**Case Study: Healthcare Scheduling Bot**
- Setup: Mem0 Enterprise (HIPAA compliant)
- Results: Persistent patient preferences, appointment history, insurance verification status
- Compliance: SOC 2 Type I + HIPAA BAA

## Advanced Usage / Production Hardening

### Security Configuration

```python
# Memory access control with metadata
def store_sensitive_memory(user_id: str, fact: str, classification: str):
    """Store memory with security classification."""
    messages = [{"role": "user", "content": fact}]
    mem0.add(
        messages,
        user_id=user_id,
        metadata={
            "classification": classification,  # "public", "internal", "confidential"
            "encrypted": True,
            "retention_days": 90
        }
    )

# Search with classification filter
results = client.search(
    "project preferences",
    filters={
        "user_id": "alice",
        "metadata.classification": ["public", "internal"]
    }
)
```

### Multi-Tenant Isolation

```python
# Organization-scoped memory for SaaS applications
def add_org_scoped_memory(org_id: str, user_id: str, messages: list):
    """Store memory scoped to both organization and user."""
    client.add(
        messages,
        user_id=f"{org_id}:{user_id}",
        metadata={"org_id": org_id, "isolation": "org-scoped"}
    )

# Admin query across all users in org
results = client.get_all(
    filters={"metadata.org_id": "org_123"},
    limit=100
)
```

### Memory Monitoring and Observability

```python
# Track memory metrics
import time

def timed_search(user_id: str, query: str):
    """Search with latency logging."""
    start = time.time()
    results = client.search(query, user_id=user_id)
    latency = (time.time() - start) * 1000

    print(f"Search latency: {latency:.1f}ms | Results: {len(results)}")

    # Log to your monitoring system
    # prometheus_histogram.observe(latency)
    return results

# Periodic memory health check
def memory_health_check(user_id: str):
    """Verify memory integrity for a user."""
    all_memories = client.get_all(filters={"user_id": user_id})

    return {
        "total_memories": len(all_memories),
        "oldest_memory": min(m["created_at"] for m in all_memories) if all_memories else None,
        "categories": len(set(m.get("metadata", {}).get("category", "") for m in all_memories)),
        "avg_score": sum(m.get("score", 0) for m in all_memories) / len(all_memories) if all_memories else 0
    }
```

### Rate Limiting and Cost Control

```python
# Implement client-side rate limiting
from functools import wraps
import time

class Mem0RateLimiter:
    """Simple rate limiter for Mem0 API calls."""
    def __init__(self, max_calls_per_minute=100):
        self.max_calls = max_calls_per_minute
        self.calls = []

    def can_call(self) -> bool:
        now = time.time()
        self.calls = [c for c in self.calls if now - c < 60]
        return len(self.calls) < self.max_calls

    def record_call(self):
        self.calls.append(time.time())

limiter = Mem0RateLimiter(max_calls_per_minute=60)

def rate_limited_add(messages, user_id):
    if not limiter.can_call():
        # Queue for later or skip non-critical memories
        print("Rate limit hit, queuing memory")
        return {"status": "queued"}
    limiter.record_call()
    return client.add(messages, user_id=user_id)
```

## Comparison with Alternatives

| Feature | Mem0 | LangChain Memory | LlamaIndex Memory | Chroma (Raw) |
|---------|------|------------------|-------------------|--------------|
| **Architecture** | Hybrid Vector + Graph + KV | Key-value + Vector | Vector + Index | Pure Vector DB |
| **GitHub Stars** | 56,205 | 100K+ (LangChain) | 41,000 | 18,500 |
| **LOCOMO Score** | 92.5% (new algo) | 58.10% | 62.47% | N/A (just storage) |
| **LongMemEval Score** | 94.4% | 49.0% | 52.9% | N/A |
| **Graph Memory** | Pro tier ($249/mo) | No | Partial | No |
| **Managed Service** | Yes (app.mem0.ai) | No | No | No |
| **Self-Hosted** | Docker, full stack | Library only | Library only | Docker |
| **SOC 2 / HIPAA** | Yes (Enterprise) | No | No | No |
| **Vector Backends** | 19 supported | 10+ | 15+ | Self only |
| **Multi-Agent Sharing** | Yes (OSS) | Limited | No | Manual |
| **Pricing Entry** | Free (10K memories) | Free (OSS) | Free (OSS) | Free (OSS) |
| **Temporal Reasoning** | Good (82.3% open-domain) | Limited | Basic | No |
| **LLM Extraction** | Automatic fact extraction | Manual/Summary | Manual | None |
| **Integration Scope** | 20+ frameworks | LangChain-native | LlamaIndex-native | Any |

### When to Choose What

- **Choose Mem0** when you want a managed memory service with automatic fact extraction, broad framework support, and production-grade compliance.
- **Choose LangChain Memory** when you are all-in on LangGraph and want zero additional infrastructure with procedural memory support.
- **Choose LlamaIndex Memory** when your primary need is document-centric RAG with memory augmentation, not conversational persistence.
- **Choose Chroma** when you only need a vector database and plan to build all memory logic yourself.

## Limitations / Honest Assessment

Mem0 is not the right tool for every use case. Here is what it does not do well:

**1. Temporal reasoning gap**: On LongMemEval temporal sub-tasks, Mem0 scores 49-82% depending on the category. Zep with Graphiti hits 63.8-71.2% on temporal tasks due to explicit time-anchored graph storage. If your agent needs to reason about sequences of events ("what happened before X?"), Mem0 may fall short.

**2. Graph memory pricing**: Graph features are locked behind the $249/month Pro tier. The Starter tier at $19/month only gets vector similarity search. For teams that need relationship-aware memory on a budget, alternatives like Zep ($25/month) or Cognee (free self-hosted) offer graph at lower price points.

**3. Lossy extraction**: Mem0 extracts structured facts from conversations, which means some nuance is lost — speaker attribution, exact timestamps, and intermediate reasoning steps can be discarded. For verbatim conversation recall, raw RAG over stored messages outperforms Mem0 (61.4% vs 86%+ on verbatim recall benchmarks).

**4. Not a full agent framework**: Mem0 is a memory layer, not an agent orchestration framework. You still need LangChain, CrewAI, or OpenAI Agents SDK for tool calling, planning, and multi-step reasoning.

**5. Self-hosted complexity**: The Docker setup is straightforward, but production self-hosting requires managing the vector store (Qdrant/Chroma), LLM API keys, embedding pipelines, and monitoring. The managed platform removes this burden but introduces data residency concerns.

## Frequently Asked Questions

**Q: What is the difference between Mem0 Platform and Mem0 Open Source?**

A: Mem0 Platform (app.mem0.ai) is the managed cloud service with automatic scaling, dashboard analytics, and SOC 2 compliance. Mem0 Open Source is the self-hosted version that gives you full control over data and infrastructure. The OSS version has the same core memory engine but requires you to manage the vector store, LLM provider, and scaling yourself.

**Q: How does mem0 compare to langchain memory for production use?**

A: LangChain Memory (LangMem) is free and integrates natively with LangGraph, but lacks a managed service, automatic fact extraction, and enterprise compliance certifications. Mem0 provides a standalone API that works across any framework, with automatic memory extraction and SOC 2/HIPAA compliance on Enterprise plans. If you are not using LangGraph exclusively, Mem0 is the more flexible choice.

**Q: Can I use Mem0 without sending data to external APIs?**

A: Yes. Mem0 Open Source supports fully local deployments using Ollama for LLM inference and local vector stores like Chroma or Qdrant. Configure the LLM provider as "ollama" with a local model (e.g., llama3) and the embedder as a local sentence-transformers model. No data leaves your network.

**Q: What vector store should I use for production?**

A: Qdrant is the recommended choice for production deployments due to its hybrid search capabilities (dense + sparse vectors), horizontal scaling support, and sub-10ms query latency. PGVector is ideal if you already run PostgreSQL. Pinecone works well for serverless deployments that need auto-scaling without ops overhead.

**Q: How do I migrate from LangChain Memory to Mem0?**

A: The migration is incremental. Start by initializing Mem0 alongside your existing LangChain memory. Store new conversations in both systems. Use Mem0's `search()` API to retrieve memories and inject them into your LangChain prompts via the `memories` variable. Once confidence is high, switch the memory source exclusively to Mem0. The Mem0 docs provide a migration guide at mem0.ai/migration.

**Q: What is the pricing for Mem0 at scale?**

A: The Hobby tier is free with 10K memories and 1K retrievals per month. Starter at $19/month gives 50K memories and 5K retrievals. Pro at $249/month adds unlimited memories, graph memory, and analytics. Enterprise plans are custom-priced with on-prem deployment, SSO, and SLA guarantees. The jump from Starter to Pro is the main pricing concern for teams that need graph features.

**Q: Does Mem0 support multi-modal memory (images, audio)?**

A: Yes, Mem0 Open Source supports multi-modal inputs including images and audio files. The multi-modal feature extracts semantic information from non-text content and stores it as retriably memory entries. This requires a multi-modal LLM like GPT-4o or Claude 3.5 Sonnet.

## Conclusion

Mem0 solves one of the most persistent problems in AI agent development: cross-session memory. With 56,205 GitHub stars, 19 vector store backends, and a new token-efficient algorithm that hits 92.5% on LoCoMo at 3.7x lower token cost than full-context baselines, it is the most adopted open-source memory layer in production. The free tier handles 10K memories for prototyping, and the self-hosted Docker stack gives full data control for enterprise deployments.

**Action items:**

1. Clone the mem0ai/mem0 repo and run the quickstart with `pip install mem0ai`
2. Sign up for a free API key at app.mem0.ai
3. Integrate Mem0 search into your LangChain or CrewAI agent prompts
4. Benchmark your current memory solution against Mem0's retrieval on your own conversation dataset

**Join the community:** [t.me/dibi8community](https://t.me/dibi8community) — share your Mem0 deployment experience and get help from other developers building memory-powered agents.

*Some links in this article are affiliate links. We may earn a commission if you purchase through these links, at no extra cost to you. This helps us maintain dibi8.com and fund open-source research.*



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- Mem0 Official Documentation: https://docs.mem0.ai/introduction
- Mem0 GitHub Repository: https://github.com/mem0ai/mem0
- Mem0 Research — Benchmarking: https://mem0.ai/research
- LangChain Integration Guide: https://docs.mem0.ai/integrations/langchain
- CrewAI Integration: https://docs.mem0.ai/integrations/crewai
- OpenAI Agents SDK Integration: https://docs.mem0.ai/integrations/openai-agents-sdk
- Mem0 Platform Pricing: https://mem0.ai/pricing
- LoCoMo Benchmark Paper: https://arxiv.org/abs/2402.03771
- LongMemEval Benchmark: https://github.com/memory-benchmark/LongMemEval
- PRISM Paper (Pareto-Efficient Retrieval): https://arxiv.org/html/2605.12260v1
- AWS Agent SDK + Mem0 Announcement: https://aws.amazon.com/blogs/machine-learning
- Atlan — Best AI Agent Memory Frameworks 2026: https://atlan.com/know/best-ai-agent-memory-frameworks-2026/
- Evermind — Mem0 Alternatives 2026: https://evermind.ai/blogs/mem0-alternative
