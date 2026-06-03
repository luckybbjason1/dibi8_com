---
title: 'GPT Researcher: Autonomous Agent for Deep Research Reports — Practical 2026 Guide'
description: 'GPT Researcher is an open deep-research agent that runs web and local research on any task and writes cited reports. 27,473 GitHub stars, Apache-2.0. Covers installation, the async Python API, Docker, and real code examples.'
date: 2026-06-02 00:00:00+08:00
lastmod: 2026-06-02 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'assafelovic/gpt-researcher'
stars: 27473
maintainer: 'assafelovic'
last_maintained: '2026-06-02'
featureImage: 'https://contrib.rocks/image?repo=assafelovic/gpt-researcher&max=1000'
draft: false
categories: ['llm-frameworks']
tags: []
aliases:
- /posts/gpt-researcher-llm-frameworks-2026/
faqs:
  - q: 'How do I install gpt-researcher?'
    a: 'Install the Python package via pip: ```bash pip install gpt-researcher ```'
  - q: 'Which LLM providers and search engines can I use?'
    a: 'OpenAI is the default LLM and Tavily is the default retriever, but both are configurable through environment variables and the config file, and the agent supports additional retrievers including MCP-based sources.'
  - q: 'Do I need API keys to run it?'
    a: 'Yes. At minimum set `OPENAI_API_KEY` and `TAVILY_API_KEY` in a `.env` file in your project root. Add `OPENAI_BASE_URL` if you use an OpenAI-compatible endpoint.'
  - q: 'How do I run the full app with a web UI?'
    a: 'Clone the repo and run `docker-compose up --build`. This starts the FastAPI server on `localhost:8000` and the frontend on `localhost:3000`. You can also start just the server with `python -m uvicorn main:app --reload`.'
  - q: 'Are conduct_research() and write_report() synchronous?'
    a: 'No. Both are async methods. Call them with `await` inside an async function, and run that function with `asyncio.run()`.'
---

{{< resource-info >}}

## Introduction

If you build with large language models (LLMs), you have probably hit the same wall: turning a question into a well-sourced, factual report is slow, manual work. `assafelovic/gpt-researcher` automates that loop. It is an autonomous agent that searches the web (and your local files), gathers sources, and writes a cited research report — all from a single query. This guide walks through installing it, running it from Python, and wiring it into a real workflow.

![gpt-researcher overview, via dibi8.com](https://contrib.rocks/image?repo=assafelovic/gpt-researcher&max=1000)

*gpt-researcher contributors (source: assafelovic/gpt-researcher repo, via dibi8 analysis)*

## What Is GPT Researcher?

GPT Researcher describes itself as "the first open deep research agent designed for both web and local research on any given task." You give it a query; it plans the research, runs multiple searches, reads and filters the results, and synthesizes a report with citations.

The project has over 27,000 stars on GitHub and is maintained by `assafelovic` under the Apache-2.0 license. Its default branch is `master`.

## How GPT Researcher Works

Under the hood, GPT Researcher runs a planner-executor loop rather than a single prompt:

1. **Plan**: From your query, the agent generates a set of research sub-questions to cover the topic from several angles.

2. **Search and gather**: For each sub-question it queries a retriever (Tavily by default) and scrapes the resulting pages, keeping only the relevant passages as context.

3. **Write**: It feeds the aggregated context back to the LLM to produce a report — research reports, resource lists, outlines, and longer detailed reports are all supported, plus a Deep Research mode that explores a topic tree.

Configuration is done through environment variables and a config file rather than inline code, so you can change the LLM and retriever without touching your script.

![gpt-researcher star history, via dibi8.com](https://api.star-history.com/svg?repos=assafelovic/gpt-researcher&type=Date)

*gpt-researcher star history (source: assafelovic/gpt-researcher repo, via dibi8 analysis)*

## Installation & Setup

To run gpt-researcher as a scheduled production job you want an always-on box — spin one up on [DigitalOcean](https://m.do.co/c/eca87ac14ee0) (free trial credit for new accounts), or [HTStack](https://my.htstack.com/aff.php?aff=27187) for low-latency Hong Kong VPS (same IDC that hosts dibi8.com).

There are two common ways to run GPT Researcher: as a Python package inside your own code, or as the full app (Python API server plus web frontend) via Docker.

### Using pip (Python package)

First confirm Python is installed:

```sh
python3 --version
```

Then install the package:

```sh
pip install gpt-researcher
```

### API keys via .env

GPT Researcher uses an LLM (OpenAI by default) and a search retriever (Tavily by default). Create a `.env` file in your project root with both keys:

```plaintext
OPENAI_API_KEY=your_openai_key_here
TAVILY_API_KEY=your_tavily_key_here
```

If you point at a custom OpenAI-compatible endpoint, also set `OPENAI_BASE_URL`. A common first-run error is a missing key — if you see an authentication or "API key not found" error, check that the `.env` file exists and is loaded before you call the researcher.

### Using Docker (full app with frontend)

To run the complete application — the FastAPI server plus the web UI — clone the repo and use Docker Compose:

```sh
git clone https://github.com/assafelovic/gpt-researcher.git
cd gpt-researcher
docker-compose up --build
```

By default this starts the Python server on `localhost:8000` and the frontend on `localhost:3000`.

### Running the server without Docker

You can also start the FastAPI server directly:

```sh
python -m uvicorn main:app --reload
```

Then open `http://localhost:8000` in your browser.

## Core Usage

The Python API is built around the `GPTResearcher` class. Both research and report-writing are **async**, so you call them with `await` inside an async function.

### Example 1: A basic research report

```python
import asyncio
from gpt_researcher import GPTResearcher

async def main():
    query = "why is Nvidia stock going up?"
    researcher = GPTResearcher(query=query)
    # Conduct research: plan, search, scrape, and gather context
    research_result = await researcher.conduct_research()
    # Write the cited report from the gathered context
    report = await researcher.write_report()
    print(report)

asyncio.run(main())
```

### Example 2: Choosing a report type

`GPTResearcher` accepts a `report_type` argument so you can ask for a short summary, a resource list, or a longer detailed report instead of the default research report:

```python
import asyncio
from gpt_researcher import GPTResearcher

async def main():
    researcher = GPTResearcher(
        query="What are the latest advancements in natural language processing?",
        report_type="detailed_report",
    )
    await researcher.conduct_research()
    report = await researcher.write_report()
    print(report)

asyncio.run(main())
```

### Example 3: Inspecting the gathered sources

After research runs, you can pull out the underlying context and source URLs the agent used — useful for auditing or building your own citation list:

```python
import asyncio
from gpt_researcher import GPTResearcher

async def main():
    researcher = GPTResearcher(query="How does AI impact society?")
    await researcher.conduct_research()
    report = await researcher.write_report()

    # Access the sources and context behind the report
    sources = researcher.get_research_sources()
    context = researcher.get_research_context()
    print(f"Used {len(sources)} sources")
    print(report)

asyncio.run(main())
```

These examples are a starting point. Because the LLM and retriever are set through configuration, the same code runs against different providers without changes.

## Integration

GPT Researcher slots into existing Python workflows because it is a plain async library plus an optional HTTP service.

### Swapping LLM providers and retrievers

You are not locked into OpenAI or Tavily. The default LLM is OpenAI and the default retriever is Tavily, but both are configurable through environment variables and the config file. For example, to combine the default web search with MCP-based sources you set the retriever list:

```sh
export RETRIEVER=tavily,mcp
```

This hybrid setup lets the agent pull from both general web search and specialized data sources through the Model Context Protocol.

### Using it inside a notebook or service

Because the API is just two awaited calls, you can drop GPT Researcher into a Jupyter notebook, a background task, or a FastAPI endpoint:

```python
import asyncio
from gpt_researcher import GPTResearcher

async def research(topic: str) -> str:
    researcher = GPTResearcher(query=topic)
    await researcher.conduct_research()
    return await researcher.write_report()

report = asyncio.run(research("current trends in AI ethics"))
print(report)
```

For more complex pipelines, the repository also ships a multi-agent setup built on LangGraph and AG2, which coordinates several specialized agents to produce longer reports.

## Benchmarks & Real-World Use

### Real-world use cases

GPT Researcher is used to automate the slow parts of research and report writing:

1. **Automated research briefs**: Generating first-draft reports on a topic or product idea, with sources attached, instead of manual web searching.

2. **Literature and market scans**: Quickly gathering and summarizing material across many pages so a human can review the synthesis rather than read every source.

3. **Internal tooling**: Wrapping the async API in an internal service so non-technical teammates can request a sourced report from a query.

### Community signal

The README does not publish formal accuracy benchmarks, so treat any performance claim against your own task as something to verify. What is verifiable is community traction: over 27,473 GitHub stars and an active issue tracker indicate sustained adoption and maintenance. Run it on a representative query before relying on it for production.

## Comparison with Alternatives

See also our [related open-source tools](dibi8-internal-link) coverage.

GPT Researcher sits in the "autonomous research agent" category. Rather than invent competitor numbers, here is how to frame the comparison honestly:

| Aspect | GPT Researcher |
|----------------------|----------------------------------------|
| **Stars** | 27,473 |
| **Language** | Python |
| **License** | Apache-2.0 |
| **Maintainer** | Assaf Elovic (`assafelovic`) |
| **Focus** | Deep web + local research that outputs cited reports |
| **Default branch** | master |
| **LLM providers** | OpenAI by default; configurable via env/config |
| **Retrievers** | Tavily by default; supports MCP and other retrievers |
| **Frontend** | Yes — lightweight FastAPI UI and a Next.js + Tailwind app |
| **Multi-agent** | Yes — LangGraph / AG2 multi-agent pipeline |

### Why pick GPT Researcher?

- **End-to-end reports, not just answers**: It returns a structured, cited report rather than a single chat response.
- **Configurable stack**: LLM and retriever are swappable without rewriting your code.
- **Both a library and an app**: Use the async API in your own code, or run the bundled server and web UI.

## Limitations & Honest Assessment

GPT Researcher is capable, but be aware of the tradeoffs:

1. **API cost and latency**: Each run fans out into multiple LLM calls and page scrapes, so deep or detailed reports can be slow and run up token and search-API costs.
2. **Configuration surface**: Getting non-default LLMs, retrievers, or the multi-agent pipeline working takes time reading the docs and tuning the config.
3. **Internet dependency**: Web research needs network access and a working search API; offline use is limited to local-document mode.
4. **Quality tracks the model and sources**: Output is only as good as the underlying LLM and the pages it retrieves, so reports still need human fact-checking before you rely on them.
5. **Learning curve**: The async API is simple, but understanding report types, retrievers, and the multi-agent flow takes some ramp-up.

These are normal tradeoffs for an agent that orchestrates many LLM and search calls — worth knowing before you wire it into a production pipeline.

## Conclusion

`assafelovic/gpt-researcher` turns a single query into a sourced, structured report by orchestrating planning, web search, scraping, and LLM writing behind a small async API. With 27,000+ stars, an Apache-2.0 license, a configurable LLM/retriever stack, and a bundled web app, it is a practical building block for research automation. Next step: set your two API keys, run the basic Python example on a real question, and inspect the sources before scaling it up.

Large-scale scraping needs rotating proxies — [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f) is the standard choice.

- Join the [dibi8 English Telegram group](https://t.me/DIBI8_Group/2) for open-source AI tool drops.
- Read next: [related guides on dibi8](dibi8-internal-link).

---

**Sources & Further Reading**:
- GitHub repository: https://github.com/assafelovic/gpt-researcher
- Official docs / README: https://github.com/assafelovic/gpt-researcher#readme

*Some links above are affiliate links. dibi8.com may earn a commission if you sign up, at no extra cost to you. Helps keep the site running and the content free.*

<!-- internal-link-candidates:
  related open-source tools -> ai-tools-directory
  related guides on dibi8 -> ai-coding-agent-landscape-2026-skills-mcp-opensource
-->
