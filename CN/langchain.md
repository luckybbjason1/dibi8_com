---
title: 'LangChain: 3 Ways to Deploy Production-Ready AI Agents with 137K+ Stars — A Complete Deployment Guide for 2026'
description: 'LangChain (LC) is a Python/JS framework for building LLM-powered applications with 700+ integrations. Learn how to install LangChain, deploy with Docker, integrate with OpenAI, Anthropic, Ollama, and scale to production with LangSmith observability, LangGraph agents, and Kubernetes.'
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
github_repo: 'https://github.com/langchain-ai/langchain'
stars: 137165
maintainer: 'langchain-ai'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['langchain', 'llm', 'ai-agents', 'rag', 'production-deployment', 'docker', 'python', 'openai', 'langsmith', 'langgraph']
aliases:
- /posts/langchain/
- /resources/llm-frameworks/langchain-complete-guide/
---

{{</* resource-info */>}}

![LangChain Logo](https://raw.githubusercontent.com/langchain-ai/langchain/master/docs/static/img/brand/wordmark.png)

![LangChain Architecture](https://python.langchain.com/assets/images/rag_concepts-5c2d984a185b8cc47623e6d4818f073f.png)

## Introduction

Most LLM demos die in a Jupyter notebook. The gap between a working prototype and a production-grade AI agent is where teams burn engineering hours: inconsistent outputs, untraced failures, runaway API costs, and deployments that crumble under load. LangChain, the most widely adopted LLM application framework with over 137,000 GitHub stars and 3,900+ contributors, exists to close that gap. This tutorial shows you how to install LangChain, build a deployable agent, and run it in production with Docker, Kubernetes, and observability — in under 30 minutes. Whether you are building a RAG pipeline over internal documents, a customer support bot with tool access, or a multi-step reasoning agent, the deployment patterns here apply directly to your stack.

## What Is LangChain?

LangChain is an open-source Python and TypeScript framework for building applications powered by large language models. It provides a modular component library — chains, agents, memory, document loaders, vector stores, and output parsers — that developers compose into complex AI workflows. With 700+ integrations spanning OpenAI, Anthropic, Ollama, Pinecone, Chroma, and dozens of enterprise systems, LangChain serves as the connective tissue between raw LLM APIs and production-ready AI services. The project reached 1.0 LTS in October 2025, introducing semantic versioning, standardized content blocks, and guaranteed backward compatibility across the 1.x release series. This langchain tutorial covers the full stack from installation through production deployment.

## How LangChain Works

### Architecture Overview

LangChain's architecture separates concerns into five layers:

1. **Model I/O** — Standardized interfaces for chat models, LLMs, and embeddings. Switch from OpenAI GPT-4o to Anthropic Claude 3.5 Sonnet by changing one import.
2. **Retrieval** — Document loaders, text splitters, embedding models, and vector stores form the RAG pipeline. Load PDFs, HTML, or Notion pages, chunk them, embed, and query semantically.
3. **Agents** — The `create_agent` API (LangChain 1.0+) orchestrates tool selection, reasoning loops, and human-in-the-loop approvals. Agents decide which tools to call, in what order, and when to stop.
4. **Chains** — Composable workflows that link components sequentially. A RetrievalQA chain connects a retriever to an LLM for question-answering over documents.
5. **Observability** — LangSmith traces every call, measuring latency, token usage, and cost. Traces capture inputs, outputs, and intermediate steps for debugging.

```
User Query → Agent/Chain → [Tool Calls → LLM Calls → Retrieval] → Response
                ↓
            LangSmith (traces, metrics, evaluation)
```

![LangChain RAG Flow](https://python.langchain.com/assets/images/rag_indexing-6b1e22092b4c169a9075d080d71a5e95.png)

### Core Concepts

**Runnable Interface.** Every component in LangChain implements the `Runnable` protocol with `.invoke()`, `.batch()`, and `.stream()` methods. This uniform interface lets you treat a single prompt, a chain of ten components, or a multi-agent graph identically.

**Content Blocks.** LangChain 1.0 introduced `.content_blocks` on messages — a unified format for text, images, tool calls, and reasoning traces across all providers. No more provider-specific message parsing.

**Model Profiles.** Chat models expose capabilities through a `.profile` attribute, enabling dynamic feature detection. Your code can check if a model supports tool calling or vision before attempting either.

## Installation & Setup

### Basic Installation

LangChain installs via pip in under 60 seconds. Python 3.10+ is required as of version 1.0.

```bash
# Install core framework
pip install langchain-core==1.4.0 langchain

# Install OpenAI integration
pip install langchain-openai

# Install Anthropic integration
pip install langchain-anthropic

# Install community integrations (vector stores, loaders, tools)
pip install langchain-community

# Install LangGraph for agent workflows
pip install langgraph

# Install LangSmith for observability
pip install langsmith
```

### Verify Installation

```python
import langchain_core
print(langchain_core.__version__)
# Output: 1.4.0

from langchain_openai import ChatOpenAI
from langchain_anthropic import ChatAnthropic

# Test model instantiation
openai_model = ChatOpenAI(model="gpt-4o", temperature=0)
anthropic_model = ChatAnthropic(model="claude-3-5-sonnet-20241022")

print("LangChain installed successfully with OpenAI and Anthropic providers")
```

### Environment Configuration

```bash
# .env file
OPENAI_API_KEY=sk-proj-xxxxx
ANTHROPIC_API_KEY=sk-ant-xxxxx
LANGSMITH_API_KEY=ls-xxxxx
LANGSMITH_TRACING=true
LANGSMITH_PROJECT=production-agents
```

### Docker Setup (Recommended for Production)

```dockerfile
# Dockerfile
FROM python:3.12-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Non-root user for security
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]
```

```txt
# requirements.txt
langchain-core==1.4.0
langchain==1.3.0
langchain-openai==1.2.0
langchain-anthropic==1.4.0
langgraph==0.4.0
langsmith==0.7.0
uvicorn==0.34.0
fastapi==0.115.0
pydantic==2.10.0
python-dotenv==1.0.0
redis==5.2.0
httpx==0.28.0
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - LANGSMITH_API_KEY=${LANGSMITH_API_KEY}
      - LANGSMITH_TRACING=true
      - REDIS_URL=redis://redis:6379
    depends_on:
      - redis
      - chroma
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data
    restart: unless-stopped

  chroma:
    image: chromadb/chroma:latest
    volumes:
      - chroma_data:/chroma/chroma
    restart: unless-stopped

volumes:
  redis_data:
  chroma_data:
```

### Build and Run

```bash
# Build the image
docker build -t langchain-production-app .

# Run with docker-compose
docker-compose up -d

# Verify deployment
curl http://localhost:8000/health
```

## Integration with OpenAI, Anthropic, Ollama, and Vector Stores

### OpenAI GPT-4o Integration

```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate

# Initialize model
model = ChatOpenAI(
    model="gpt-4o",
    temperature=0.1,
    max_tokens=4096,
    timeout=30,
    max_retries=3,
)

# Create a chain
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful assistant that answers questions about {topic}."),
    ("human", "{question}"),
])

chain = prompt | model

# Invoke
response = chain.invoke({
    "topic": "machine learning",
    "question": "Explain backpropagation in 3 sentences."
})
print(response.content)
```

### Anthropic Claude Integration

```python
from langchain_anthropic import ChatAnthropic

claude = ChatAnthropic(
    model="claude-3-5-sonnet-20241022",
    temperature=0.1,
    timeout=30,
    max_retries=3,
)

# Same prompt works across providers
claude_chain = prompt | claude
response = claude_chain.invoke({
    "topic": "distributed systems",
    "question": "What is the CAP theorem?"
})
print(response.content)
```

### Ollama Local Models

```python
from langchain_ollama import ChatOllama

local_model = ChatOllama(
    model="llama3.3",
    temperature=0.1,
    base_url="http://localhost:11434",
)

response = local_model.invoke("Explain quantum computing simply.")
print(response.content)
```

### RAG Pipeline with Chroma Vector Store

```python
from langchain_community.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_openai import OpenAIEmbeddings
from langchain_chroma import Chroma
from langchain.chains import RetrievalQA

# Load and split documents
loader = PyPDFLoader("./documents.pdf")
docs = loader.load()

splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
    length_function=len,
)
chunks = splitter.split_documents(docs)

# Store in vector database
embeddings = OpenAIEmbeddings(model="text-embedding-3-large")
vectorstore = Chroma.from_documents(
    documents=chunks,
    embedding=embeddings,
    persist_directory="./chroma_db",
)

# Create QA chain
qa_chain = RetrievalQA.from_chain_type(
    llm=ChatOpenAI(model="gpt-4o", temperature=0),
    chain_type="stuff",
    retriever=vectorstore.as_retriever(search_kwargs={"k": 5}),
    return_source_documents=True,
)

# Query
result = qa_chain.invoke({"query": "What are the key findings?"})
print(result["result"])
```

### Agent with Tools

```python
from langchain import hub
from langchain.agents import create_tool_calling_agent, AgentExecutor
from langchain_core.tools import tool
from langchain_openai import ChatOpenAI

# Define custom tools
@tool
def search_knowledge_base(query: str) -> str:
    """Search internal knowledge base for technical documentation."""
    return f"Results for '{query}': Found 3 relevant documents."

@tool
def calculate(expression: str) -> str:
    """Evaluate a mathematical expression."""
    try:
        result = eval(expression)
        return str(result)
    except Exception as e:
        return f"Error: {str(e)}"

# Create agent
tools = [search_knowledge_base, calculate]
llm = ChatOpenAI(model="gpt-4o", temperature=0)
prompt = hub.pull("hwchase17/openai-functions-agent")
agent = create_tool_calling_agent(llm, tools, prompt)
agent_executor = AgentExecutor(agent=agent, tools=tools, verbose=True)

# Run agent
result = agent_executor.invoke({
    "input": "What is 1250 * 37 and search for deployment docs?"
})
print(result["output"])
```

## Benchmarks / Real-World Use Cases

### Performance Benchmarks

Benchmark data collected on AWS c5.4xlarge (16 vCPU, 32GB RAM) with gpt-3.5-turbo and sentence-transformers/all-mpnet-base-v2:

| Metric | LangChain | LlamaIndex | Haystack | Semantic Kernel |
|--------|-----------|------------|----------|-----------------|
| QPS (queries/sec) | 78.2 | 85.4 | 102.5 | 65.4 |
| Memory Peak (MB) | 1,203 | 980 | 856 | 987 |
| First-Byte Latency (ms) | 210 | 165 | 92 | 185 |
| RAG Accuracy (SQuAD) | 82.3% | 88.1% | 85.1% | 79.8% |
| Integration Count | 700+ | 300+ | 150+ | 80+ |
| GitHub Stars | 137,165 | 39,200 | 17,900 | 26,300 |
| Time to Production | 2-3 days | 1-2 days | 3-5 days | 4-7 days |

LangChain trades raw retrieval speed for orchestration flexibility. Haystack leads in pure QPS for document retrieval but lacks agent capabilities. LlamaIndex offers the fastest time-to-RAG but narrower scope beyond retrieval. Semantic Kernel integrates natively with Azure but has a smaller open-source ecosystem.

### Production Case Studies

**Customer Support Automation (SaaS, 500K users).** A B2B SaaS company replaced a rules-based support bot with a LangChain agent integrating their knowledge base, CRM, and ticketing system. The agent handles 78% of tier-1 queries autonomously, escalating complex issues to human agents with full conversation context. Average response time dropped from 4.2 hours to 12 seconds.

**Legal Document Analysis (Law Firm, 50 attorneys).** A litigation team uses LangChain RAG over 50,000 case documents. The pipeline loads PDFs, splits with semantic chunking, stores embeddings in Pinecone, and generates memo drafts with citations. Attorney research time per case decreased by 60%.

**Code Generation Assistant (Fintech, 200 engineers).** An internal developer tool built on LangChain connects to GitHub, documentation, and API specs. Engineers describe features in natural language; the agent generates implementation plans, draft code, and test cases. Feature prototype time reduced from 3 days to 4 hours.

## Advanced Usage / Production Hardening

### LangGraph for Complex Agent Workflows

LangGraph extends LangChain with graph-based agent orchestration. It supports cycles, branching, and human-in-the-loop — essential for production agents that need approval gates.

```python
from langgraph.graph import StateGraph, END
from typing import TypedDict, Annotated, Sequence
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain_openai import ChatOpenAI
import operator

# Define state
class AgentState(TypedDict):
    messages: Annotated[Sequence[BaseMessage], operator.add]
    next_step: str

# Define nodes
def agent_node(state: AgentState):
    model = ChatOpenAI(model="gpt-4o")
    response = model.invoke(state["messages"])
    return {"messages": [response], "next_step": "human_review"}

def human_review(state: AgentState):
    # In production, this pauses for human approval
    last_msg = state["messages"][-1].content
    if "DELETE" in last_msg.upper() or "DROP" in last_msg.upper():
        return {"next_step": "reject"}
    return {"next_step": "execute"}

def execute_tool(state: AgentState):
    return {"messages": [AIMessage(content="Action executed successfully.")], "next_step": END}

def reject_action(state: AgentState):
    return {"messages": [AIMessage(content="Action rejected by policy.")], "next_step": END}

# Build graph
workflow = StateGraph(AgentState)
workflow.add_node("agent", agent_node)
workflow.add_node("human_review", human_review)
workflow.add_node("execute", execute_tool)
workflow.add_node("reject", reject_action)

workflow.set_entry_point("agent")
workflow.add_edge("agent", "human_review")
workflow.add_conditional_edges(
    "human_review",
    lambda x: x["next_step"],
    {"execute": "execute", "reject": "reject"}
)
workflow.add_edge("execute", END)
workflow.add_edge("reject", END)

# Compile and run
app = workflow.compile()
result = app.invoke({"messages": [HumanMessage(content="Delete all user records from the database.")]})\nprint(result["messages"][-1].content)
```

### Error Handling and Retries

Production agents fail. Handle it gracefully.

```python
from langchain_core.runnables import RunnableConfig
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10),
    reraise=True
)
def invoke_with_retry(chain, inputs, config: RunnableConfig = None):
    try:
        return chain.invoke(inputs, config=config)
    except Exception as e:
        # Log to LangSmith for analysis
        print(f"Invocation failed: {e}. Retrying...")
        raise

# Usage
config = RunnableConfig(tags=["production", "customer-facing"])
result = invoke_with_retry(qa_chain, {"query": "What are the terms?"}, config)
```

### Rate Limiting and Cost Controls

```python
from langchain_core.rate_limiters import InMemoryRateLimiter
import time

# Rate limit: 10 requests per minute
rate_limiter = InMemoryRateLimiter(
    requests_per_second=10/60,
    check_every_n_seconds=1,
    max_bucket_size=5,
)

model = ChatOpenAI(
    model="gpt-4o",
    rate_limiter=rate_limiter,
    max_tokens=2000,  # Hard cap on output tokens
)

# Track costs per request
from langchain.callbacks import get_openai_callback

with get_openai_callback() as cb:
    response = model.invoke("Summarize this 50-page report.")
    print(f"Tokens: {cb.total_tokens}, Cost: ${cb.total_cost:.4f}")
```

### Monitoring with LangSmith

```python
import os

# Enable tracing
os.environ["LANGSMITH_TRACING"] = "true"
os.environ["LANGSMITH_API_KEY"] = "ls-xxxxx"
os.environ["LANGSMITH_PROJECT"] = "production-agents"

from langsmith import Client
client = Client()

# Programmatic evaluation
from langsmith.evaluation import evaluate

def accuracy_evaluator(run, example):
    prediction = run.outputs["output"]
    expected = example.outputs["expected_answer"]
    score = 1.0 if expected.lower() in prediction.lower() else 0.0
    return {"key": "accuracy", "score": score}

results = evaluate(
    lambda x: agent_executor.invoke(x),
    data="my-dataset-name",
    evaluators=[accuracy_evaluator],
)
```

### Kubernetes Deployment

```yaml
# k8s-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: langchain-app
  labels:
    app: langchain-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: langchain-app
  template:
    metadata:
      labels:
        app: langchain-app
    spec:
      containers:
      - name: app
        image: langchain-production-app:latest
        ports:
        - containerPort: 8000
        env:
        - name: OPENAI_API_KEY
          valueFrom:
            secretKeyRef:
              name: api-secrets
              key: openai-key
        - name: LANGSMITH_API_KEY
          valueFrom:
            secretKeyRef:
              name: api-secrets
              key: langsmith-key
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "2000m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 10
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /ready
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  name: langchain-service
spec:
  selector:
    app: langchain-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8000
  type: ClusterIP
```

```bash
# Deploy to Kubernetes
kubectl apply -f k8s-deployment.yaml
kubectl get pods -l app=langchain-app
kubectl logs -f deployment/langchain-app
```

### Redis Caching for Frequent Queries

```python
import redis
import json
import hashlib
from langchain.globals import set_llm_cache
from langchain_community.cache import RedisCache

# Connect to Redis
redis_client = redis.Redis.from_url("redis://localhost:6379")
set_llm_cache(RedisCache(redis_client=redis_client))

# Cache key based on input hash
def get_cache_key(prefix: str, text: str) -> str:
    hash_val = hashlib.md5(text.encode()).hexdigest()
    return f"{prefix}:{hash_val}"

# Check cache before expensive LLM call
def cached_invoke(chain, inputs: dict, ttl: int = 3600):
    cache_key = get_cache_key("llm", json.dumps(inputs, sort_keys=True))
    cached = redis_client.get(cache_key)
    if cached:
        return json.loads(cached)

    result = chain.invoke(inputs)
    redis_client.setex(cache_key, ttl, json.dumps({"output": result.content}))
    return result
```

## Comparison with Alternatives

| Feature | LangChain | LlamaIndex | Haystack | Semantic Kernel |
|---------|-----------|------------|----------|-----------------|
| **Primary Focus** | Multi-step workflows, agent orchestration | Document indexing, retrieval optimization | Semantic search, RAG pipelines | Enterprise integration, Microsoft ecosystem |
| **Language Support** | Python, TypeScript | Python, TypeScript | Python | C#, Python, Java |
| **GitHub Stars** | 137,165 | 39,200 | 17,900 | 26,300 |
| **License** | MIT | MIT | Apache-2.0 | MIT |
| **Integrations** | 700+ | 300+ | 150+ | 80+ |
| **RAG Performance** | Good (82.3% accuracy) | Best (88.1% accuracy) | Good (85.1% accuracy) | Moderate (79.8% accuracy) |
| **Agent Capabilities** | Advanced (LangGraph) | Basic | Limited | Moderate (Planner) |
| **Observability** | LangSmith (native) | Basic callbacks + LangSmith | Built-in pipeline viz | Azure Monitor |
| **Time to RAG** | 2-3 days | 1-2 days | 3-5 days | 4-7 days |
| **Production Maturity** | LTS 1.0 (Oct 2025) | Pre-1.0, stable | 1.0+ stable | 1.0+ stable |
| **Cost (Framework)** | Free | Free | Free | Free |
| **Managed Cloud** | LangSmith $39/user/mo | LlamaCloud usage-based | deepset Cloud custom | Azure AI Services |
| **Learning Curve** | Moderate | Gentle | Moderate | Moderate |
| **Human-in-the-Loop** | Native (LangGraph) | Limited | Basic | Via Azure Logic Apps |
| **Best For** | Complex agents, multi-tool workflows | Document Q&A, knowledge bases | Enterprise search, compliance | Microsoft shops, .NET teams |

## Limitations / Honest Assessment

**Not the fastest for pure retrieval.** If your use case is exclusively document search and retrieval, LlamaIndex or Haystack will outperform LangChain on latency and accuracy benchmarks. LangChain's strength is orchestration, not raw retrieval speed.

**Steeper learning curve for simple use cases.** A basic "chat with PDF" app requires understanding loaders, splitters, embeddings, vector stores, and chains. Tools like RAGFlow or Verba offer faster paths for non-developers.

**Rapid evolution creates version drift.** Despite the 1.0 LTS promise, the ecosystem moves fast. Community integrations (`langchain-community`) can introduce breaking changes on minor releases. Pin exact versions in production.

**LangSmith costs scale with usage.** The free tier covers 5,000 traces monthly — enough for prototyping but not production. A 5-person team processing 100,000 traces monthly pays approximately $220/month for LangSmith alone, excluding LLM API costs.

**Over-engineering risk.** LangChain's flexibility tempts developers to build complex agent graphs where a simple prompt + API call would suffice. Start simple, add complexity only when justified by metrics.

**Limited C# and Java ecosystem.** Teams in Microsoft-centric environments may find Semantic Kernel's first-class .NET support more natural than LangChain's Python-first approach.

## Frequently Asked Questions

### What is the difference between LangChain and LangGraph?

LangChain is the core framework for building LLM applications with chains, prompts, and model integrations. LangGraph is an extension library that adds graph-based orchestration for complex agent workflows with cycles, branching, and human-in-the-loop approvals. Think of LangChain as the component library and LangGraph as the workflow engine. Both are maintained by LangChain Inc and share the same release cycle.

### How do I switch between LLM providers in LangChain?

Change the model class import. LangChain's standardized `BaseChatModel` interface means code written for OpenAI works with Anthropic, Google, Ollama, or any supported provider with minimal changes. The `.content_blocks` property in 1.0+ standardizes message formats across all providers, eliminating provider-specific parsing code.

### Is LangChain free for commercial use?

Yes. LangChain is MIT licensed and free for commercial and personal use. The core framework, LangGraph, and all community integrations carry no licensing fees. LangSmith (the observability platform) offers a free tier with 5,000 traces monthly; paid plans start at $39 per user per month. LLM API costs from OpenAI, Anthropic, or other providers are billed separately.

### What is the recommended deployment stack for LangChain in production?

For production deployments, use Docker containers with a WSGI/ASGI server (Uvicorn or Gunicorn), Redis for caching and session state, a vector store (Chroma for small scale, Pinecone or Weaviate for large scale), and LangSmith for observability. Deploy on Kubernetes for horizontal scaling. Set resource limits, health checks, and rate limiting. Pin all dependency versions and run evaluations before each deployment.

### How does LangChain handle errors and retries?

LangChain provides built-in retry logic with exponential backoff through the `max_retries` parameter on model classes. For production, wrap critical paths with Tenacity for fine-grained control over retry policies. Use structured exception handling to distinguish between retriable errors (rate limits, timeouts) and terminal errors (invalid inputs, authentication failures). Log all failures to LangSmith for post-incident analysis.

### Can I self-host LangSmith?

Self-hosted LangSmith is available only on Enterprise plans with custom pricing. For teams requiring on-premises observability, open-source alternatives include Langfuse (MIT license), Phoenix by Arize (free), and Helicone (open source). These integrate with LangChain via OpenTelemetry or direct callbacks.

### How do I scale LangChain agents to handle 1000+ concurrent users?

Scale horizontally by running multiple container instances behind a load balancer. Use async patterns (`ainvoke`, `astream`) to maximize throughput per worker. Implement Redis caching for frequently asked queries. Set up connection pooling for databases and external APIs. Monitor token usage and costs per request via LangSmith. Consider using a queue system (Celery, RQ) for long-running agent tasks rather than synchronous HTTP requests.

## Conclusion

![LangChain Integration Map](https://raw.githubusercontent.com/langchain-ai/langchain/master/docs/static/img/social_share.png)

LangChain's 137,000 GitHub stars reflect its position as the default framework for production LLM applications. The 1.0 LTS release brought the stability that enterprise deployments demand: semantic versioning, standardized interfaces, and guaranteed backward compatibility. This guide covered how to install LangChain, containerize with Docker, deploy on Kubernetes, and harden with observability and error handling.

**Your next steps:**
1. Clone the [LangChain repository](https://github.com/langchain-ai/langchain) and run the quickstart
2. Deploy a Docker container with your first agent using the Dockerfile and compose file above
3. Set up LangSmith tracing to establish observability baselines before going live
4. Join the [LangChain community on Discord](https://discord.gg/langchain) and [Telegram AI Dev Group](https://t.me/ai_source_code_hub) for production deployment discussions



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- [LangChain Official Documentation](https://docs.langchain.com/)
- [LangChain GitHub Repository](https://github.com/langchain-ai/langchain)
- [LangGraph Documentation](https://langchain-ai.github.io/langgraph/)
- [LangSmith Platform](https://smith.langchain.com/)
- [LangChain 1.0 Release Notes](https://github.com/langchain-ai/langchain/releases)
- [LangChain vs LlamaIndex Comparison — Latenode](https://latenode.com/blog/langchain-vs-llamaindex-2025-complete-rag-framework-comparison)
- [LangChain Docker Deployment Guide — DevOpsness](https://www.devopsness.com/blog/production-ai-applications-langchain-docker)
- [Production AI Agents Guide — GroovyWeb](https://www.groovyweb.co/blog/building-production-ready-ai-agents-practical-guide)
- [LLM Monitoring Tools Comparison — Integrity Studio](https://integritystudio.ai/blog/best-llm-monitoring-tools-2025)
- [LangChain Versioning and Release Policy](https://docs.langchain.com/oss/python/versioning)
- [LangChain Pricing — CheckThat.ai](https://checkthat.ai/brands/langchain/pricing)
