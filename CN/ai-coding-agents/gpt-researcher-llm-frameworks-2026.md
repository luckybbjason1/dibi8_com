---


title: "GPT Researcher: Autonomous Agent for Deep Research Reports — Practical 2026 Guide"
description: "Technical guide and comparison"
date: 2026-09-20
slug: "gpt-researcher-llm-frameworks-2026"
category: "ai-tools"
tags: ["ai", "tools"]

categories: ["ai-coding-agents"]---


title: "GPT Researcher: Autonomous Agent for Deep Research Repor...
description: "Technical guide and comparison"
date: 2026-06-02T00:00:00+08:00
lastmod: 2026-06-02T00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
last_maintained: "2026-06-02"
draft: false
categories: ["llm-frameworks"]
tags: ["]
aliases:
  - /posts/gpt-researcher-llm-frameworks-2026/
faqs: - q: 'How do I install gpt-researcher?'
    a: 'Install the Python package via pip: ```bash pip install gpt-researcher ```'
  - q: 'Which LLM providers and search engines can I use?'
    a: 'OpenAI is the default LLM and Tavily is the default retriever", "but both are configurable through environment variables and the config file", "and the agent supports additional retrievers including MCP-based sources.'
  - q: 'Do I need API keys to run it?'
    a: 'Yes. At minimum set ``OPENAI_API_KEY`` and ``TAVILY_API_KEY`` in a ``.env`` file in your project root. Add ``OPENAI_BASE_URL`` if you use an OpenAI-compatible endpoint.'
  - q: 'How do I run the full app with a web UI?'
    a: 'Clone the repo and run ``docker-compose up --build``. This starts the FastAPI server on ``localhost:8000`` and the frontend on ``localhost:3000``. You can also start just the server with ``python -m uvicorn main:app --reload``.'
  - q: 'Are conduct_research() and write_report() synchronous?'
    a: 'No. Both are async methods. Call them with ``await`` inside an async function", "and run that function with ``asyncio.run()``."
