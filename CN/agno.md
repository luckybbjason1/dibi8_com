---
title: 'Agno: 40K+ Stars — Lightweight AI Agent Framework Deep Dive vs CrewAI, AutoGen in 2026'
description: 'Agno is a lightweight open-source Python SDK for building AI agent platforms with 40K+ GitHub stars. Supports OpenAI, Anthropic, Ollama, Docker, AWS. Covers installation, multi-agent systems, benchmarks, production hardening, and comparison with CrewAI, AutoGen, and LangChain.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/agno-agi/agno'
stars: 40233
maintainer: 'agno-agi'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['agno', 'ai-agent', 'python-sdk', 'multi-agent', 'open-source', 'lightweight-framework', 'agent-platform', 'ollama', 'openai']
aliases:
- /posts/agno/
---

{{</* resource-info */>}}

Choosing an AI agent framework in 2026 feels like navigating a minefield. Over the past 18 months, dozens of libraries have emerged promising to "simplify" agent development, yet most introduce more abstraction than value. Teams report spending weeks learning graph-based orchestration semantics only to discover their use case needed nothing more than a lightweight tool-calling loop. Agno (formerly Phidata) cuts through this noise with a runtime-first philosophy: build agents fast, serve them as services, and own your entire stack. With **40,233 GitHub stars**, **452 contributors**, and a fresh Apache-2.0 license, it has become the go-to framework for Python teams shipping production agent systems. This guide — a practical **agno tutorial** for 2026 — walks through **agno setup**, architecture, real code examples, benchmarks in the **agno vs crewai** debate, and the hard truths about where this **lightweight ai framework** falls short.

![Agno Framework Banner](https://raw.githubusercontent.com/agno-agi/agno/main/imgs/banner.png)

## What Is Agno?

**Agno is an open-source Python SDK for building, running, and managing AI agent platforms.** Originally launched as Phidata, the project was rebranded to Agno in late 2024 and re-licensed under Apache-2.0. At its core, Agno provides three integrated layers: a Python SDK for defining agents and multi-agent teams, a stateless FastAPI runtime called **AgentOS** for production deployment, and a control-plane UI for monitoring, session management, and team operations.

Agno's value proposition is simple: you build agents with plain Python classes, attach tools from a library of 100+ pre-built integrations, and deploy them as API services without learning graph DSLs or role-based abstractions. The framework supports **23+ LLM providers** including OpenAI, Anthropic Claude, Google Gemini, Cohere, and local models via Ollama. Agent initialization takes roughly **3 microseconds**, with memory usage clocking in at approximately **6.5 KiB per agent** — roughly 50x less overhead than comparable frameworks.

## How Agno Works

### Architecture Overview

Agno's architecture separates concerns into three distinct layers, each replaceable independently:

```
┌─────────────────────────────────────────────────────────────┐
│                    Control Plane (AgentOS UI)                │
│         Chat · Trace Inspection · Session Management         │
├─────────────────────────────────────────────────────────────┤
│                    Runtime (AgentOS API)                     │
│    FastAPI · Session Storage · RBAC · Scheduling · Auth    │
├─────────────────────────────────────────────────────────────┤
│                      SDK Layer                               │
│  Agent · Team · Tools · Memory · Knowledge · Guardrails    │
├─────────────────────────────────────────────────────────────┤
│              Model Providers (23+ supported)                 │
│  OpenAI · Anthropic · Gemini · Ollama · Cohere · Grok ... │
└─────────────────────────────────────────────────────────────┘
```

![Agno AgentOS Dashboard](https://mintcdn.com/agno-v2/8V9aTUOgPNSFLOye/images/demo-os.png)

*The AgentOS control plane provides chat, trace inspection, and session management out of the box.*

### Core Concepts

**Agent**: The fundamental unit. An Agno agent wraps an LLM call with a model, tools, instructions, memory, and knowledge base. Agents are plain Python objects with no hidden state.

**Team**: A collection of agents that share memory, tools, and knowledge. Teams enable multi-agent orchestration without requiring graph definitions — agents communicate through shared context.

**Tools**: 100+ pre-built tool integrations including web search (DuckDuckGo, Google), file operations (PDF, CSV, DOCX), APIs, databases, and MCP (Model Context Protocol) servers.

**Memory & Knowledge**: First-class systems for persistent storage. User memories, session state, and RAG knowledge bases are stored in **your** database — Agno does not hold your data hostage in a managed service.

**AgentOS Runtime**: A stateless FastAPI backend that serves agents as REST APIs. Handles session read/write, context injection, human approval loops, and OpenTelemetry tracing automatically.

## Installation & Setup — Agno Setup in Under 5 Minutes

Following this **agno setup** guide, you'll have a working agent in under two minutes with zero external dependencies beyond Python 3.10+.

### Step 1: Create Virtual Environment

```bash
# Using uv (recommended)
curl -LsSf https://astral.sh/uv/install.sh | sh
uv venv --python 3.12
source .venv/bin/activate

# Or using standard venv
python3 -m venv ~/.venvs/agno
source ~/.venvs/agno/bin/activate
```

### Step 2: Install Agno

```bash
# Minimal install
uv pip install -U agno

# With OpenAI support
uv pip install -U agno openai

# Full install with common tools
uv pip install -U agno openai duckduckgo-search chromadb
```

### Step 3: Verify Installation

```bash
python -c "import agno; print(agno.__version__)"
# Expected: 2.6.8 or newer
```

### Step 4: Run Your First Agent

Create `basic_agent.py`:

```python
from agno.agent import Agent

agent = Agent(
    model="openai:gpt-4o",
    description="You are a helpful coding assistant.",
    markdown=True,
)

agent.print_response("Explain the difference between asyncio and threading in Python.", stream=True)
```

```bash
export OPENAI_API_KEY="sk-your-key-here"
python basic_agent.py
```

That's it — a working agent in 10 lines of Python. No YAML configs, no graph definitions, no ceremony.

## Integration with OpenAI, Anthropic, Ollama, Docker, and AWS

### OpenAI Integration

```python
from agno.agent import Agent
from agno.models.openai import OpenAIChat

agent = Agent(
    model=OpenAIChat(id="gpt-4o"),
    tools=[DuckDuckGoTools()],
    show_tool_calls=True,
    markdown=True,
)

agent.print_response("Latest news in quantum computing", stream=True)
```

### Anthropic Claude Integration

```python
from agno.agent import Agent
from agno.models.anthropic import Claude

agent = Agent(
    model=Claude(id="claude-sonnet-4-20250514"),
    description="You are a research analyst specializing in market trends.",
    markdown=True,
)

agent.print_response("Analyze the EV market in Southeast Asia.", stream=True)
```

### Ollama Integration (Local Models)

```python
from agno.agent import Agent
from agno.models.ollama import Ollama

agent = Agent(
    model=Ollama(id="qwen3"),
    description="You are a local AI assistant running entirely offline.",
    markdown=True,
)

agent.print_response("Explain recursion with a Python example.", stream=True)
```

```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Pull a model
ollama pull qwen3

# Run
python ollama_agent.py
```

### Docker Deployment

```dockerfile
FROM python:3.12-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
EXPOSE 8000

CMD ["python", "workbench.py"]
```

```yaml
# docker-compose.yml
version: '3.8'
services:
  agentos:
    build: .
    ports:
      - "8000:8000"
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - AGNO_ENV=production
    volumes:
      - ./data:/app/data
    restart: unless-stopped
```

### AWS Deployment (ECS with Fargate)

```bash
# Build and push to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

docker build -t agno-agent .
docker tag agno-agent:latest $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/agno-agent:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/agno-agent:latest

# Deploy to Fargate
aws ecs create-service \
  --cluster agno-production \
  --service-name agent-service \
  --task-definition agno-task:1 \
  --desired-count 2 \
  --launch-type FARGATE
```

## Benchmarks / Real-World Use Cases

### Performance Benchmarks

This **ai agent tutorial** includes real numbers. Agno's lightweight design shows measurable advantages in head-to-head testing:

![Agno Performance Comparison](https://docs.agno.com/_next/image?url=%2Fassets%2Fagno-og.jpg&w=1200&q=75)

![Agno 文档网站](https://docs.agno.com/introduction)

| Metric | Agno | CrewAI | AutoGen | LangGraph |
|--------|------|--------|---------|-----------|
| Agent initialization | ~3 μs | ~12 ms | ~45 ms | ~150 ms |
| Memory per agent | ~6.5 KiB | ~320 KiB | ~1.2 MiB | ~2.8 MiB |
| Cold start (local) | 45 ms | 890 ms | 2.1 s | 4.5 s |
| LLM providers supported | 23+ | 8+ | 12+ | 15+ |
| Built-in tools | 100+ | 25+ | 40+ | 60+ |
| Lines for basic agent | 7 | 25 | 35 | 40+ |

These numbers matter at scale. A service running 1,000 concurrent agent sessions consumes roughly **6.5 MiB** with Agno versus **2.8 GiB** with LangGraph — a 400x memory difference that directly impacts your cloud bill.

### Production Use Cases

**Data Labeling Pipelines**: ML teams use Agno to label text, image, audio, and video datasets. The multi-modal input support means a single agent pipeline can handle mixed media without framework switching.

**Product Copilots**: Teams embed Agno agents directly into their products via the AgentOS API. Session storage and memory enable conversational continuity across user sessions.

**Document Processing**: Knowledge agents with hybrid RAG search over ChromaDB, LanceDB, or PostgreSQL vector stores process legal contracts, medical records, and financial reports.

**Synthetic Data Generation**: Data science teams generate training pairs and preference datasets for fine-tuning, leveraging Agno's structured output capabilities.

## Advanced Usage / Production Hardening

### Multi-Agent Systems

Agno teams let you compose agent groups without graph definitions:

```python
from agno.agent import Agent
from agno.models.openai import OpenAIChat
from agno.tools.duckduckgo import DuckDuckGoTools
from agno.team import Team

# Research agent
researcher = Agent(
    name="Researcher",
    model=OpenAIChat(id="gpt-4o-mini"),
    tools=[DuckDuckGoTools()],
    description="Find recent data and statistics on any topic.",
)

# Writer agent
writer = Agent(
    name="Writer",
    model=OpenAIChat(id="gpt-4o"),
    description="Write polished articles from research notes.",
)

# Compose team
team = Team(
    name="Content Team",
    members=[researcher, writer],
    instructions="Collaborate to produce well-researched, engaging content.",
)

team.print_response("Write an article about renewable energy trends in 2026.", stream=True)
```

### Agentic RAG with Knowledge Base

```python
from agno.agent import Agent
from agno.knowledge.embedder.google import GeminiEmbedder
from agno.knowledge.knowledge import Knowledge
from agno.models.google import Gemini
from agno.vectordb.chroma import ChromaDb
from agno.vectordb.search import SearchType

knowledge = Knowledge(
    vector_db=ChromaDb(
        collection="docs",
        path="tmp/chromadb",
        persistent_client=True,
        search_type=SearchType.hybrid,
        embedder=GeminiEmbedder(id="gemini-embedding-001"),
    ),
)

knowledge.insert(url="https://docs.agno.com/introduction.md", skip_if_exists=True)

agent = Agent(
    model=Gemini(id="gemini-3-flash-preview"),
    knowledge=knowledge,
    search_knowledge=True,
    markdown=True,
)

agent.print_response("What is Agno?", stream=True)
```

### Production Service with Session Storage

```python
from agno.agent import Agent
from agno.db.sqlite import SqliteDb
from agno.os import AgentOS
from agno.tools.workspace import Workspace

workbench = Agent(
    name="Workbench",
    model="openai:gpt-5.5",
    db=SqliteDb(db_file="workbench.db"),
    memory=True,
    tools=[Workspace(root="./workspace", allowed=["read", "list", "search", "shell"])],
    instructions="Help the user organize and analyze their workspace files.",
    markdown=True,
)

# Serve as API
AgentOS.agent = workbench
AgentOS.serve(host="0.0.0.0", port=8000)
```

```bash
# Start the service
python workbench.py

# Test via curl
curl -X POST http://localhost:8000/v1/agents/workbench/run \
  -H "Content-Type: application/json" \
  -d '{"message": "Organize my downloads folder", "session_id": "user-123"}'
```

### Security & Monitoring

```python
from agno.agent import Agent
from agno.os import AgentOS

# Enable human approval for destructive tools
agent = Agent(
    name="SecureAgent",
    model="openai:gpt-4o",
    tools=[Workspace(root="./data", allowed=["read", "list"])],  # No write/delete
    human_approval=True,  # Require approval for tool calls
    audit_trail=True,     # Log all actions
    markdown=True,
)

# OpenTelemetry tracing (auto-configured in AgentOS)
AgentOS.agent = agent
AgentOS.serve(host="0.0.0.0", port=8000)
```

## Comparison with Alternatives

| Feature | Agno | CrewAI | AutoGen | LangChain + LangGraph |
|---------|------|--------|---------|----------------------|
| **GitHub Stars** | 40,233 | 51,000+ | 58,000+ | 96,000+ / 31,000+ |
| **License** | Apache-2.0 | MIT | MIT (Code) / CC-BY-4.0 (Docs) | MIT |
| **Architecture** | SDK + FastAPI Runtime + Control Plane | Role-based Teams | Conversational Multi-Agent | Graph-based Orchestration |
| **Agent Init Speed** | ~3 μs | ~12 ms | ~45 ms | ~150 ms |
| **Memory Overhead** | ~6.5 KiB | ~320 KiB | ~1.2 MiB | ~2.8 MiB |
| **LLM Providers** | 23+ | 8+ | 12+ | 15+ |
| **Built-in Tools** | 100+ | 25+ | 40+ | 60+ |
| **Learning Curve** | Low | Medium | High | High |
| **Best For** | Production agents as services | Role-based business workflows | Research / Microsoft ecosystem | Complex stateful workflows |
| **Self-hosted Data** | Yes (your DB) | Partial | Yes | Yes |
| **MCP Support** | Yes | No | Limited | Yes |
| **AgentOS UI** | Yes (built-in) | No | No | LangSmith (separate) |
| **Community** | 452 contributors | Growing | Microsoft backed | Largest ecosystem |

**When to choose Agno**: You need lightweight agents running as production services with session management, tracing, and low memory footprint. You want to ship fast without learning graph DSLs.

**When to choose CrewAI**: Your use case maps cleanly to role-based teams (researcher, writer, editor) and you want a structured workflow with minimal setup friction.

**When to choose AutoGen**: You're in the Microsoft ecosystem, building research tools, or need conversational multi-agent systems with built-in code execution.

**When to choose LangGraph**: Your workflow requires explicit state machines, checkpointing, replay, and fine-grained branching control that graph semantics provide.

## Limitations / Honest Assessment — What This Lightweight AI Framework Is NOT Good For

Agno is not the right tool for every agent use case. Here is what to consider before adopting:

**No graph semantics**: If your workflow requires explicit state transitions, checkpointing, and replayable execution paths, LangGraph's graph model is a better fit. Agno's team-based orchestration is simpler but less precise for complex branching logic.

**Smaller community than LangChain**: With 452 contributors versus LangChain's 3,000+, third-party tutorials and StackOverflow answers are fewer. The documentation has improved rapidly but still has gaps in edge-case scenarios.

**Python-only**: Unlike LangChain which supports JavaScript/TypeScript and AutoGen which has a .NET path, Agno is Python-only. Full-stack teams using Node.js or .NET will need language bridges.

**Younger ecosystem**: The rebrand from Phidata to Agno (late 2024) and the 1.x to 2.x migration changed package layouts and APIs. Some older community tutorials use deprecated imports.

**AgentOS lock-in considerations**: While the SDK is fully open-source, the hosted AgentOS UI at agno.com offers premium features. Teams should verify which features require paid plans before committing to the control plane.

## Frequently Asked Questions

### How does Agno compare to LangGraph for production use?

Agno prioritizes runtime overhead and service packaging — you get a FastAPI backend with sessions and tracing in minutes. LangGraph provides more control over state management and branching but requires learning graph semantics and carries significantly higher memory overhead. For teams shipping agent APIs, Agno removes boilerplate. For teams building complex deterministic workflows, LangGraph's explicit state model is worth the learning curve.

### Can I run Agno with local models only?

Yes. Agno integrates with Ollama, LM Studio, and any OpenAI-compatible local endpoint. The `Ollama` model provider lets you run entirely offline with models like Llama 3, Qwen3, or Mistral. No API keys or cloud dependencies are required for local deployments.

### What databases does Agno support for session storage?

Agno supports SQLite, PostgreSQL, MySQL, and LanceDB for session storage and memory. The `SqliteDb`, `PostgresDb`, and `LanceDb` classes handle session read/write automatically — no manual SQL required. Vector databases supported include ChromaDB, LanceDB, and pgvector for RAG knowledge bases.

### Is Agno suitable for enterprise deployments?

Yes, with caveats. Agno's AgentOS runtime includes RBAC, human approval loops, audit trails, and OpenTelemetry observability — all requirements for enterprise deployments. However, the project is younger than LangChain, and enterprise support (SLAs, dedicated support) is only available through Agno's commercial offerings. Teams with strict compliance requirements should evaluate self-hosting versus managed options.

### How do I migrate from Phidata to Agno?

The migration involves updating package imports from `phidata` to `agno` and adapting to the 2.x API changes. The Agno team provides a [migration guide](https://docs.agno.com/migration) covering common patterns. Key changes include the `Agent` class replacing `PhiAgent`, the `Team` class replacing `PhiTeam`, and the AgentOS runtime being a separate module. Most migrations take a few hours for medium-sized codebases.

### Can I use Agno without the AgentOS runtime?

Absolutely. The SDK layer is fully independent. You can build and run agents as standalone Python scripts, integrate them into existing FastAPI/Django/Flask apps, or use only the agent and tool components. AgentOS is an optional convenience layer for teams who want session management and monitoring out of the box.

## Conclusion

Agno fills a specific gap in the agent framework landscape: it gives Python teams a fast, lightweight way to build and deploy agent services without the complexity of graph-based orchestration. The **3 μs agent initialization**, **6.5 KiB memory footprint**, and **100+ pre-built tools** translate directly to lower infrastructure costs and faster development cycles.

For teams shipping production agents in 2026, the decision framework is straightforward: start with Agno if you need lightweight, API-first agents; evaluate CrewAI if role-based teams fit your mental model; consider AutoGen for Microsoft-centric or research workloads; and reach for LangGraph only when explicit state machine semantics are non-negotiable.

The 40,233 GitHub stars and 452-contributor community signal that Agno has crossed the threshold from promising project to production-viable platform. The best way to evaluate it is to run the 10-line example from the Installation section and measure the setup time against the alternatives.

**Action items**: Clone the [Agno GitHub repository](https://github.com/agno-agi/agno), run your first agent, then deploy it to a [DigitalOcean](https://www.digitalocean.com/) droplet using the Docker setup above. Join the [Agno community on Discord](https://discord.gg/agno) for real-time support.



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- [Agno GitHub Repository](https://github.com/agno-agi/agno) — Official source code, 40,233 stars
- [Agno Documentation](https://docs.agno.com) — Complete docs with examples and API reference
- [Agno AgentOS](https://os.agno.com) — Hosted control plane for agent management
- [FutureAGI Framework Comparison 2026](https://futureagi.com/blog/oss-agent-frameworks-2026) — Detailed comparison of open-source agent frameworks
- [Deepchecks AI Agent Frameworks 2025](https://deepchecks.com/best-ai-agent-frameworks/) — Framework benchmarks and use case analysis
- [CrewAI vs LangGraph vs AutoGen vs Agno](https://ronniehuss.co.uk/crewai-vs-langgraph-vs-autogen-vs-agno/) — Founder-focused framework comparison
- [AI Agents Kit Comparison 2026](https://aiagentskit.com/blog/best-ai-agent-frameworks-compared/) — Community-driven framework rankings
- [Agno vs CrewAI Detailed Comparison](https://respan.ai/market-map/compare/agno-vs-crewai) — Feature-by-feature analysis with community reviews

---

*This article contains affiliate links. If you sign up for services through these links, dibi8.com may receive a commission at no extra cost to you.*
