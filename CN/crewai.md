---
title: 'CrewAI: Build Multi-Agent AI Teams with 51K+ Stars — Complete Setup Guide 2026'
description: 'CrewAI (crewAIInc/crewAI) is a Python framework for orchestrating role-playing, autonomous AI agents. Compatible with OpenAI, Anthropic, Ollama, LangChain, and LlamaIndex. Covers installation, agent roles, task workflows, production deployment, and benchmarks.'
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
github_repo: 'https://github.com/crewAIInc/crewAI'
stars: 51759
maintainer: 'crewAIInc'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['crewai', 'multi-agent', 'ai-agents', 'python', 'llm-orchestration', 'automation', 'open-source', 'machine-learning']
aliases:
- /posts/crewai/
- /resources/llm-frameworks/crewai-multi-agent-orchestration/
---

{{</* resource-info */>}}

> How to install CrewAI, configure agent roles, wire tasks, and ship production-ready multi-agent systems in under 30 minutes.

## Introduction

Building a single LLM-powered agent is straightforward. Orchestrating five agents that research, write, edit, fact-check, and publish content — without stepping on each other — is a different problem entirely. CrewAI solves this with a role-based orchestration model that lets developers define specialized agents, assign them tasks, and run them as coordinated teams. With over 51,759 GitHub stars and 318 contributors, CrewAI has become the go-to Python framework for multi-agent collaboration in 2026. This guide walks through how to install CrewAI, configure your first crew, and deploy it to production with real configs, benchmarks, and honest trade-offs.

## What Is CrewAI?

CrewAI is an open-source Python framework for orchestrating role-playing, autonomous AI agents that work collaboratively on complex tasks. It provides two core abstractions: **Crews** (teams of agents with defined roles, goals, and backstories) and **Flows** (event-driven workflows that chain crews with conditional logic and state management). Unlike monolithic LLM prompts, CrewAI agents delegate work, use tools, and produce structured outputs through sequential, hierarchical, or parallel execution.

## How CrewAI Works

CrewAI's architecture separates agent definition from orchestration logic:

![CrewAI Logo](https://raw.githubusercontent.com/crewAIInc/crewAI/main/docs/images/crewai_logo.png)

**Core Components:**

| Component | Purpose | Config File |
|-----------|---------|-------------|
| **Agent** | A role-based AI worker with goals, backstory, and tools | `agents.yaml` |
| **Task** | A unit of work assigned to an agent with expected output | `tasks.yaml` |
| **Crew** | A team of agents executing tasks via a defined process | `crew.py` |
| **Flow** | An event-driven workflow chaining crews with state management | `flow.py` |
| **Tool** | External capabilities (search, APIs, calculations) | `tools/` |
| **Process** | Execution strategy: sequential, hierarchical, or parallel | `crew.py` |

![CrewAI Architecture](https://github.com/crewAIInc/crewAI/raw/main/docs/images/asset.png)

**Execution Flow:**

1. Flow receives input and initializes state
2. Tasks are dispatched to agents based on process type
3. Agents execute tasks, optionally using tools
4. Task outputs feed into subsequent tasks as context
5. Final result is returned with token usage metrics

The diagram above shows CrewAI's dual-model architecture: **Crews** handle agent collaboration within a single workflow, while **Flows** provide the event-driven backbone for chaining multiple crews with state management and conditional routing.

## Installation & Setup

### Prerequisites

CrewAI requires Python 3.10–3.13 and an API key from at least one LLM provider.

```bash
# Check Python version
python --version  # Must be 3.10, 3.11, 3.12, or 3.13

# Install uv (recommended package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Install CrewAI

```bash
# Install CrewAI core framework
uv pip install crewai

# Or with optional tools package
uv pip install 'crewai[tools]'

# Verify installation
crewai version
```

### Create a New Project

```bash
# Scaffold a new CrewAI project
crewai create crew research_crew

# Navigate into the project
cd research_crew

# Install project dependencies
crewai install
```

The generated project structure:

```
research_crew/
├── .gitignore
├── pyproject.toml
├── README.md
├── .env
└── src/
    └── research_crew/
        ├── __init__.py
        ├── main.py
        ├── crew.py
        ├── config/
        │   ├── agents.yaml
        │   └── tasks.yaml
        └── tools/
            ├── __init__.py
            └── custom_tool.py
```

### Configure Environment Variables

```bash
# .env — add this file to .gitignore!
OPENAI_API_KEY=sk-your-openai-key-here
SERPER_API_KEY=your-serper-api-key
```

For local LLMs via Ollama (no API key needed):

```bash
# Pull a local model
ollama pull llama3.1

# In agent config, use: ollama/llama3.1
```

## Define Your First Agents

Edit `src/research_crew/config/agents.yaml` to define role-based agents:

```yaml
# src/research_crew/config/agents.yaml

researcher:
  role: >
    Senior Research Analyst
  goal: >
    Conduct thorough research on {topic} and gather
    comprehensive, accurate, and up-to-date information.
  backstory: >
    You are a seasoned research analyst with 15 years of
    experience in technology analysis. You find obscure but
    critical data points and synthesize complex information.
  llm: openai/gpt-4o
  max_iter: 15
  verbose: true

writer:
  role: >
    Technical Content Writer
  goal: >
    Transform research findings on {topic} into a
    well-structured, engaging article.
  backstory: >
    You are an award-winning technical writer who excels at
    making complex topics accessible without sacrificing accuracy.
  llm: openai/gpt-4o
  max_iter: 10
  verbose: true

editor:
  role: >
    Senior Content Editor
  goal: >
    Review and polish the article about {topic} to ensure
    factual accuracy, grammar, and readability.
  backstory: >
    You are a meticulous editor with a sharp eye for factual
    errors and logical inconsistencies.
  llm: openai/gpt-4o-mini
  max_iter: 8
  verbose: true
```

Key configuration options per agent:

| Parameter | Description | Example |
|-----------|-------------|---------|
| `role` | Agent's job title and function | `Senior Research Analyst` |
| `goal` | What the agent aims to achieve | Research on `{topic}` |
| `backstory` | Context shaping agent's behavior | Experience and personality |
| `llm` | LLM model via LiteLLM | `openai/gpt-4o` |
| `max_iter` | Max reasoning loops per task | `15` |
| `verbose` | Print thought process to console | `true` |
| `allow_delegation` | Can delegate to other agents | `false` |

## Define Tasks and Wire the Crew

### Task Configuration

Edit `src/research_crew/config/tasks.yaml`:

```yaml
# src/research_crew/config/tasks.yaml

research_task:
  description: >
    Research the topic: {topic}. Gather at least 10 key data points
    from multiple authoritative sources. Include statistics,
    expert opinions, and recent developments.
  expected_output: >
    A structured research brief with 10+ data points, source
    citations, and a summary of key findings.
  agent: researcher

writing_task:
  description: >
    Using the research brief provided, write a comprehensive
    technical article about {topic}. Target 1500 words.
    Use clear headings, examples, and engaging prose.
  expected_output: >
    A markdown-formatted article with introduction, body
    sections, and conclusion. Minimum 1500 words.
  agent: writer
  context: [research_task]

editing_task:
  description: >
    Edit the article for clarity, grammar, factual accuracy,
    and readability. Ensure all claims are supported by the
    research brief.
  expected_output: >
    A polished final article ready for publication.
    Include an editor's note summarizing changes made.
  agent: editor
  context: [writing_task]
  output_file: output/final_article.md
```

### Crew Definition

Wire agents and tasks in `src/research_crew/crew.py`:

```python
# src/research_crew/crew.py
from crewai import Agent, Crew, Process, Task
from crewai.project import CrewBase, agent, crew, task

@CrewBase
class ResearchCrew:
    """Research crew for producing high-quality articles."""

    agents_config = "config/agents.yaml"
    tasks_config = "config/tasks.yaml"

    @agent
    def researcher(self) -> Agent:
        return Agent(
            config=self.agents_config["researcher"],
            tools=[],
            allow_delegation=False,
        )

    @agent
    def writer(self) -> Agent:
        return Agent(
            config=self.agents_config["writer"],
            tools=[],
            allow_delegation=False,
        )

    @agent
    def editor(self) -> Agent:
        return Agent(
            config=self.agents_config["editor"],
            tools=[],
            allow_delegation=False,
        )

    @task
    def research_task(self) -> Task:
        return Task(config=self.tasks_config["research_task"])

    @task
    def writing_task(self) -> Task:
        return Task(config=self.tasks_config["writing_task"])

    @task
    def editing_task(self) -> Task:
        return Task(
            config=self.tasks_config["editing_task"],
            output_file="output/final_article.md",
        )

    @crew
    def crew(self) -> Crew:
        return Crew(
            agents=self.agents,
            tasks=self.tasks,
            process=Process.sequential,
            verbose=True,
        )
```

### Entry Point and Execution

```python
# src/research_crew/main.py
#!/usr/bin/env python
from research_crew.crew import ResearchCrew

def run():
    """Run the research crew."""
    inputs = {
        "topic": "AI coding assistants in 2026"
    }
    result = ResearchCrew().crew().kickoff(inputs=inputs)
    print("\n\n========== FINAL OUTPUT ==========\n")
    print(result.raw)
    print(f"\nToken usage: {result.token_usage}")

if __name__ == "__main__":
    run()
```

Run the crew:

```bash
# Execute via CLI
crewai run

# Or run directly with Python
python -m research_crew.main
```

Expected output:

```
[2026-05-20 10:23:15] Working Agent: Senior Research Analyst
[2026-05-20 10:23:15] Starting Task: Research the topic: AI coding assistants in 2026...
...
[2026-05-20 10:24:02] Working Agent: Technical Content Writer
[2026-05-20 10:24:02] Starting Task: Using the research brief provided...
...
[2026-05-20 10:25:18] Working Agent: Senior Content Editor
...
========== FINAL OUTPUT ==========
[The complete edited article appears here]
Token usage: UsageMetrics(total_tokens=18432, prompt_tokens=14201, ...)
```

## Advanced Usage: Flows, Tools, and Production Patterns

### Using CrewAI Flows for Complex Orchestration

Flows provide event-driven orchestration with state management:

```python
# src/research_crew/flow.py
from crewai.flow.flow import Flow, listen, start
from pydantic import BaseModel
from research_crew.crew import ResearchCrew

class ArticleState(BaseModel):
    topic: str = ""
    word_count: int = 0
    final_article: str = ""

class ArticleFlow(Flow[ArticleState]):

    @start()
    def get_topic(self):
        self.state.topic = "Multi-agent AI frameworks in 2026"
        print(f"Starting flow for topic: {self.state.topic}")

    @listen(get_topic)
    def run_research_crew(self):
        result = ResearchCrew().crew().kickoff(
            inputs={"topic": self.state.topic}
        )
        self.state.final_article = result.raw
        self.state.word_count = len(result.raw.split())

    @listen(run_research_crew)
    def validate_output(self):
        if self.state.word_count < 1000:
            print("WARNING: Article too short, triggering revision")
        else:
            print(f"Article validated: {self.state.word_count} words")
            with open("output/article.md", "w") as f:
                f.write(self.state.final_article)

if __name__ == "__main__":
    ArticleFlow().kickoff()
```

### Creating Custom Tools

```python
# src/research_crew/tools/custom_tool.py
from crewai.tools import tool
import requests

@tool("Web Search")
def web_search(query: str) -> str:
    """Search the web for information on a given query."""
    # Integration with search API
    response = requests.get(
        "https://serpapi.com/search",
        params={"q": query, "api_key": "${SERPER_API_KEY}"}
    )
    return response.json()["organic_results"][0]["snippet"]
```

Register the tool in your crew:

```python
# In crew.py, import and attach
from research_crew.tools.custom_tool import web_search

@agent
def researcher(self) -> Agent:
    return Agent(
        config=self.agents_config["researcher"],
        tools=[web_search],  # Attach custom tool
        allow_delegation=False,
    )
```

### Hierarchical Process with Manager Agent

```python
@crew
def crew(self) -> Crew:
    return Crew(
        agents=self.agents,
        tasks=self.tasks,
        process=Process.hierarchical,
        manager_llm="openai/gpt-4o",
        verbose=True,
    )
```

### Production Deployment with FastAPI

```python
# api_server.py — Production deployment
from fastapi import FastAPI, BackgroundTasks
from pydantic import BaseModel
from research_crew.crew import ResearchCrew
import uuid

app = FastAPI(title="CrewAI Research API")
jobs: dict = {}

class CrewRequest(BaseModel):
    topic: str

@app.post("/research")
async def start_research(request: CrewRequest, background: BackgroundTasks):
    job_id = str(uuid.uuid4())
    jobs[job_id] = {"status": "queued", "topic": request.topic}
    background.add_task(
        lambda: run_crew(job_id, request.topic)
    )
    return {"job_id": job_id, "status": "queued"}

@app.get("/status/{job_id}")
async def get_status(job_id: str):
    return jobs.get(job_id, {"error": "Job not found"})

def run_crew(job_id: str, topic: str):
    jobs[job_id]["status"] = "running"
    result = ResearchCrew().crew().kickoff(inputs={"topic": topic})
    jobs[job_id]["status"] = "completed"
    jobs[job_id]["result"] = result.raw

# Run: uvicorn api_server:app --host 0.0.0.0 --port 8000
```

## Benchmarks / Real-World Use Cases

### Performance Benchmarks

![CrewAI Benchmarks showing token efficiency comparison across multi-agent frameworks — data from community benchmarks as of May 2026](https://docs.crewai.com/images/crewai-performance-chart.png)

CrewAI's performance compared to other frameworks on a standard multi-agent research task:

| Metric | CrewAI | AutoGen | LangGraph | Agno |
|--------|--------|---------|-----------|------|
| Time to first working run | ~15 min | ~30 min | ~60 min | ~20 min |
| Token cost (normalized) | 1.5–2x | 5–6x | 1x baseline | 1.2x |
| GitHub stars (May 2026) | 51,759 | ~38,000 | ~28,000 | ~15,000 |
| Lines to hello-world | ~20 | ~40 | ~50 | ~25 |
| Built-in checkpointing | Partial | No | Yes (Postgres/Redis) | No |
| Async support | Yes | Yes | Yes | Yes |
| Local LLM support (Ollama) | Yes | Yes | Yes | Yes |

### Real-World Use Cases

**Automated Research Reports:** A fintech startup uses CrewAI to generate daily market analysis reports. A researcher agent scrapes financial data, an analyst agent identifies trends, and a writer agent produces the final report — all before 8 AM.

**Content Production Pipeline:** A media company runs a 4-agent crew for blog posts: research → writing → editing → SEO optimization. Output increased from 3 to 12 articles per week.

**Code Review Automation:** A SaaS team uses CrewAI to triage pull requests. An agent summarizes changes, another checks for security patterns, and a third generates review comments.

## Integration with Popular Tools

### OpenAI / Anthropic / Google Gemini

CrewAI uses LiteLLM for provider-agnostic model routing:

```yaml
# agents.yaml — model selection per agent
researcher:
  role: Research Analyst
  llm: anthropic/claude-sonnet-4-20250514
  # or: openai/gpt-4o
  # or: gemini/gemini-2.0-flash
```

### Ollama (Local LLMs)

```yaml
researcher:
  role: Research Analyst
  llm: ollama/llama3.1
  # Requires: ollama pull llama3.1
```

### LangChain Tools

```python
# Using LangChain tools inside CrewAI
from langchain_community.tools import WikipediaQueryRun
from langchain_community.utilities import WikipediaAPIWrapper
from crewai import Agent

wiki_tool = WikipediaQueryRun(api_wrapper=WikipediaAPIWrapper())

agent = Agent(
    role="Researcher",
    goal="Research topics thoroughly",
    tools=[wiki_tool],  # LangChain tool works directly
    verbose=True,
)
```

### LlamaIndex (RAG Integration)

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from crewai.tools import tool

# Build a RAG index
@tool("Document Search")
def document_search(query: str) -> str:
    """Search internal documents for relevant information."""
    documents = SimpleDirectoryReader("./docs").load_data()
    index = VectorStoreIndex.from_documents(documents)
    query_engine = index.as_query_engine()
    return str(query_engine.query(query))
```

### Docker Deployment

```dockerfile
# Dockerfile
FROM python:3.12-slim

WORKDIR /app
COPY pyproject.toml .
COPY src/ ./src/

RUN pip install crewai crewai-tools
RUN crewai install

EXPOSE 8000

CMD ["crewai", "run"]
```

```yaml
# docker-compose.yml
version: "3.8"
services:
  crewai:
    build: .
    env_file: .env
    volumes:
      - ./output:/app/output
    ports:
      - "8000:8000"
```

## Comparison with Alternatives

| Feature | CrewAI | AutoGen | LangGraph | Agno |
|---------|--------|---------|-----------|------|
| Orchestration model | Role-based crew | Conversational agents | Stateful graph | Lightweight agent |
| Time to prototype | 15 min (fastest) | 30 min | 60 min (steepest) | 20 min |
| Token efficiency | Moderate (1.5–2x) | Highest overhead (5–6x) | Best (1x) | Good (1.2x) |
| Production checkpointing | Partial + CrewAI+ | No built-in | Yes (Postgres/Redis) | No |
| Observability | CrewAI+ (growing) | Basic OTEL | LangSmith (deep) | Minimal |
| Learning curve | Low | Medium | Steep | Low |
| Maintainer momentum | Active | Maintenance mode | Active | Active |
| Best for | Fast prototyping, role-based workflows | Research, code-writing agents | Stateful production workflows | Simple agent tasks |

## Limitations / Honest Assessment

**What CrewAI is NOT good for:**

1. **Complex state machines:** If your workflow requires cyclical graphs with branching and time-travel debugging, LangGraph's explicit graph model is a better fit.

2. **Ultra-high-volume production:** CrewAI's checkpointing is partial compared to LangGraph's full state persistence. For thousands of daily runs requiring audit trails, LangGraph is more battle-tested.

3. **Token-sensitive budgets:** CrewAI's agents are verbose by default. On equivalent tasks, expect 1.5–2x the token consumption of LangGraph. Budget $100–$500/month for moderate production workloads.

4. **Real-time latency requirements:** Multi-agent orchestration adds inherent latency. A 3-agent sequential crew with GPT-4o takes 45–90 seconds. Not suitable for sub-second response requirements.

5. **Deep observability:** CrewAI+ provides monitoring but LangSmith offers deeper tracing with per-node token accounting and replay capability.

## Frequently Asked Questions

**Q: What Python version does CrewAI require?**
A: CrewAI requires Python 3.10 to 3.13. It does not support Python 3.9 or earlier. Use `pyenv` to manage multiple Python versions on your system.

**Q: How do I install CrewAI with local LLM support?**
A: Install CrewAI normally with `pip install crewai`, then install Ollama separately. In your agent config, set `llm: ollama/llama3.1` (or your preferred model). No API keys are needed for local inference.

**Q: Can CrewAI work with non-OpenAI models?**
A: Yes. CrewAI supports any LiteLLM-compatible model including Anthropic Claude, Google Gemini, Azure OpenAI, DeepSeek, Mistral, and local models via Ollama. Use the format `provider/model-name` in your agent config.

**Q: What is the difference between CrewAI Crews and Flows?**
A: Crews are teams of agents that collaborate on tasks through sequential, hierarchical, or parallel processes. Flows are event-driven workflows that chain multiple crews with conditional logic, state management via Pydantic models, and branching. Use Crews for single-workflow collaboration and Flows for multi-stage pipelines.

**Q: How much does it cost to run a CrewAI crew in production?**
A: For a 3-agent crew with GPT-4o running 100 times/day, expect $100–$300/month in LLM API costs. Using cheaper models like GPT-4o-mini for simpler tasks (editing, formatting) can reduce costs by 40–60%. CrewAI itself is free and open-source (MIT license).

**Q: How do I debug CrewAI agents that produce poor results?**
A: Set `verbose: true` on agents to see their thought process. Use `max_iter` to limit reasoning loops. Add structured output schemas to enforce format. Review token usage metrics after each run. For persistent issues, simplify task descriptions and verify tool configurations.

**Q: Is CrewAI production-ready for enterprise use?**
A: For small-to-medium production workloads, yes. CrewAI+ adds managed observability and deployment features starting at $99/month. For high-volume or audit-critical workloads, consider pairing CrewAI with custom checkpointing or evaluating LangGraph.

## Conclusion

CrewAI delivers the fastest path from idea to working multi-agent system. Its role-based abstraction — agents with defined roles, goals, and backstories collaborating on tasks — maps cleanly to how teams actually work. In under 30 minutes, you can install CrewAI, scaffold a project, define agents and tasks, and run your first crew. For production, add Flows for event-driven orchestration, FastAPI for HTTP endpoints, and Docker for deployment.

**Action items to get started today:**

1. Install CrewAI: `pip install crewai`
2. Scaffold your first project: `crewai create crew my_project`
3. Define 2–3 agents with distinct roles in `agents.yaml`
4. Run your crew with `crewai run`
5. Join the CrewAI community for support and advanced patterns

Join the discussion on Telegram: [Join dibi8.com community](https://t.me/dibi8tech) for multi-agent AI tips and production deployment strategies.



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- [CrewAI GitHub Repository](https://github.com/crewAIInc/crewAI)
- [CrewAI Official Documentation](https://docs.crewai.com/en/introduction)
- [CrewAI Quickstart Guide](https://docs.crewai.com/en/quickstart)
- [CrewAI Flows Documentation](https://docs.crewai.com/en/concepts/flows)
- [CrewAI Tools Reference](https://docs.crewai.com/en/concepts/tools)
- [LangGraph vs CrewAI vs AutoGen Comparison 2026](https://rightaichoice.com/compare/langgraph-vs-crewai-vs-autogen)
- [CrewAI Multi-Agent Tutorial 2026](https://tech-insider.org/crewai-tutorial-multi-agent-ai-python-2026/)
- [CrewAI + IBM watsonx Tutorial](https://github.com/IBM/ibmdotcom-tutorials/blob/main/crew-ai-projects/crewAI-multiagent-retail-example.md)

*Disclosure: This article contains affiliate links. If you click on a link and make a purchase, we may receive a commission at no additional cost to you. This helps support our independent technical research, testing, and the creation of free educational content. All recommendations are based on our own evaluation of the tools.*
