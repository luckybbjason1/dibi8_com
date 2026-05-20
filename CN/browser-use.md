---
title: 'Browser Use: 94K+ Stars — Benchmarking AI Browser Automation in 2026'
description: 'Browser Use is an open-source Python framework that connects LLMs to real browsers via Playwright. Supports OpenAI, Anthropic, Gemini, and local models. Covers setup, WebVoyager benchmarks, Selenium comparison, production hardening, and Docker deployment.'
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
github_repo: 'https://github.com/browser-use/browser-use'
stars: 94731
maintainer: 'browser-use'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['browser-use', 'ai-agents', 'playwright', 'browser-automation', 'web-scraping', 'llm', 'python', 'open-source']
aliases:
- /posts/browser-use/
---

{{</* resource-info */>}}

![Browser Use Logo](https://raw.githubusercontent.com/browser-use/browser-use/main/docs/static/img/browser-use-logo.png)

> **GitHub**: [browser-use/browser-use](https://github.com/browser-use/browser-use) | **Stars**: 94,731 | **License**: MIT | **Version**: 0.12.7

---

## Introduction

Writing and maintaining Selenium scripts for modern web automation is a slow death by a thousand selectors. A class name changes, a button moves, and your entire pipeline collapses at 3 AM. Browser Use, an open-source Python framework launched in late 2024 by Magnus Müller and Gregor Žunič, takes a different approach: it hands the browser controls to a large language model and lets the AI figure out what to click, type, and read. With 94,731 GitHub stars, 319 contributors, and an 89.1% success rate on the WebVoyager benchmark, it has become the de facto open-source standard for AI-driven browser automation. This tutorial covers the setup, real benchmark data, integration with popular LLMs, and a head-to-head comparison against Selenium, Puppeteer, and Scrapy.

---

## What Is Browser Use?

Browser Use is a Python library (≥3.11) that connects any LangChain-compatible LLM to a real web browser via Playwright. Instead of hardcoding CSS selectors or XPath expressions, you describe the task in natural language — "find the cheapest flight from NYC to SFO next Friday" — and the agent handles navigation, form filling, clicking, and data extraction autonomously.

### Key Design Principles

- **Model-agnostic**: Works with OpenAI GPT-4o/5.1, Anthropic Claude Sonnet 4, Google Gemini 3 Flash, and local models via LiteLLM.
- **DOM distillation**: Strips pages to essential interactive elements before sending them to the LLM, cutting token consumption by up to 60%.
- **Multi-tab support**: Agents can operate across multiple browser tabs simultaneously.
- **Persistent memory**: Maintains context and conversation history across navigation steps.
- **Built on Playwright**: Inherits all Playwright features — stealth mode, proxy support, network interception, and video recording.

---

## How Browser Use Works

Browser Use operates on a continuous **observe → plan → act → verify** loop:

### Architecture Overview

```
┌─────────────┐    DOM + Screenshot     ┌─────────────┐
│   Browser   │ ──────────────────────> │     LLM     │
│  (Playwright)│                        │(Claude/GPT/)│
│             │ <────────────────────── │   Gemini    │
└─────────────┘     Action (click/type) └─────────────┘
      ↑                                        │
      └────────── Page State Change ───────────┘
```

![Browser Use Agent Loop Architecture](https://raw.githubusercontent.com/browser-use/browser-use/main/docs/static/img/agent-loop-diagram.png)

### The Agent Loop in Detail

1. **Capture**: Browser Use takes a DOM snapshot and screenshot of the current page.
2. **Distill**: The DOM is filtered to only interactive elements (buttons, inputs, links), reducing noise.
3. **Reason**: The LLM receives the distilled page state and the user's goal, then plans the next action.
4. **Execute**: Browser Use translates the LLM's decision into Playwright API calls (`page.click()`, `page.fill()`).
5. **Verify**: The loop repeats until the task is complete or `max_steps` is reached.

```python
from browser_use import Agent, Browser
from langchain_openai import ChatOpenAI
import asyncio

async def main():
    browser = Browser()
    agent = Agent(
        task="Find the number of stars of the browser-use repo",
        llm=ChatOpenAI(model="gpt-4.1"),
        browser=browser,
    )
    result = await agent.run()
    print(result)

if __name__ == "__main__":
    asyncio.run(main())
```

---

## Installation & Setup

### Prerequisites

- Python 3.11 or higher
- A Playwright-compatible browser (Chromium recommended)
- An API key from your preferred LLM provider

### Step 1: Install Browser Use

```bash
# Using uv (recommended)
uv init
uv add browser-use
uv sync

# Using pip
pip install browser-use

# Install Chromium if not already present
playwright install chromium
```

### Step 2: Configure Environment Variables

```bash
# .env file
OPENAI_API_KEY=sk-your-openai-key
ANTHROPIC_API_KEY=sk-ant-your-anthropic-key
GOOGLE_API_KEY=your-google-api-key

# Optional: Browser Use Cloud for stealth browsers
BROWSER_USE_API_KEY=your-cloud-key
```

### Step 3: Run Your First Agent

```python
import asyncio
from browser_use import Agent, Browser, ChatBrowserUse

async def main():
    browser = Browser()
    agent = Agent(
        task="List the top 20 posts on Hacker News today with their points",
        llm=ChatBrowserUse(),
        browser=browser,
    )
    result = await agent.run()
    print(result.output)

if __name__ == "__main__":
    asyncio.run(main())
```

![Browser Use Quick Start Interface](https://docs.browser-use.com/assets/images/quickstart-browser-use-cloud.png)

### Docker Setup (Production)

```dockerfile
# Dockerfile
FROM python:3.11-slim

WORKDIR /app
RUN pip install browser-use playwright
RUN playwright install chromium
RUN playwright install-deps

COPY . .
CMD ["python", "agent.py"]
```

```yaml
# docker-compose.yml
version: '3.8'
services:
  browser-use:
    build: .
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
    volumes:
      - ./scripts:/app
    command: python agent.py
```

---

## Integration with Popular Tools

### OpenAI GPT-4o / GPT-5.1

```python
from browser_use import Agent, Browser
from langchain_openai import ChatOpenAI
import asyncio

async def search_flights():
    agent = Agent(
        task="Find the cheapest flight from NYC to London next week",
        llm=ChatOpenAI(model="gpt-4o", temperature=0),
        browser=Browser(),
    )
    return await agent.run()

asyncio.run(search_flights())
```

### Anthropic Claude Sonnet 4

```python
from browser_use import Agent, Browser
from langchain_anthropic import ChatAnthropic
import asyncio

async def extract_data():
    agent = Agent(
        task="Extract all pricing plans from example.com/pricing",
        llm=ChatAnthropic(model="claude-sonnet-4-6"),
        browser=Browser(),
    )
    result = await agent.run()
    print(result.output)

asyncio.run(extract_data())
```

### Google Gemini 3 Flash

```python
from browser_use import Agent, Browser
from langchain_google_genai import ChatGoogleGenerativeAI
import asyncio

async def research_topic():
    agent = Agent(
        task="Research the latest AI news and summarize top 5 stories",
        llm=ChatGoogleGenerativeAI(model="gemini-3-flash-preview"),
        browser=Browser(),
    )
    return await agent.run()

asyncio.run(research_topic())
```

### Ollama (Local Models)

```python
from browser_use import Agent, Browser
from langchain_ollama import ChatOllama
import asyncio

async def local_automation():
    agent = Agent(
        task="Fill out the contact form on example.com/contact",
        llm=ChatOllama(model="qwen2.5:72b"),
        browser=Browser(),
    )
    return await agent.run()

asyncio.run(local_automation())
```

### Playwright Direct Integration

```python
from playwright.async_api import async_playwright
from browser_use import Agent
from langchain_openai import ChatOpenAI

async def hybrid_automation():
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        
        # Deterministic Playwright step
        await page.goto("https://example.com")
        
        # Hand off to Browser Use agent for complex task
        agent = Agent(
            task="Navigate to pricing and extract all plan details",
            llm=ChatOpenAI(model="gpt-4o"),
            browser=browser,
        )
        result = await agent.run()
        await browser.close()
        return result
```

---

## Benchmarks / Real-World Use Cases

### WebVoyager Benchmark Results

The WebVoyager benchmark evaluates browser agents on 586 diverse real-world web tasks. Browser Use ranks #7 on the global leaderboard with an 89.1% success rate — the highest among fully open-source frameworks.

![WebVoyager Leaderboard showing Browser Use at 89.1%](https://docs.browser-use.com/assets/images/webvoyager-benchmark-2026.png)

| Rank | System | Score | Organization |
|------|--------|-------|-------------|
| 1 | Alumnium | 98.6% | Alumnium |
| 2 | Surfer 2 | 97.1% | H Company |
| 3 | Magnitude | 93.9% | Magnitude |
| 4 | AIME Browser-Use | 92.34% | Aime |
| 6 | Browserable | 90.4% | Browserable |
| **7** | **Browser Use** | **89.1%** | **Browser Use** |
| 8 | GLM-5V-Turbo | 88.5% | Z.ai |
| 9 | Agent Kura | 87.0% | Kura |
| 9 | OpenAI Operator | 87% | OpenAI |
| 11 | Skyvern 2.0 | 85.85% | Skyvern |
| 12 | Project Mariner | 83.5% | Google |

### Performance Metrics (vs Traditional Tools)

| Metric | Browser Use (AI) | Playwright | Puppeteer | Selenium |
|--------|-----------------|-----------|-----------|----------|
| Cold start to first navigation | ~0.5–0.8s | ~0.4–0.7s | ~0.3–0.5s | ~1.2–2.5s |
| Idle RAM (per instance) | ~100–150MB | ~90–130MB | ~60–100MB | ~180–280MB |
| Static pages / minute | ~8–15 (AI loop) | ~35–55 | ~40–60 | ~18–35 |
| Novel site success rate | 89.1% | N/A | N/A | N/A |
| Selector maintenance | None | High | High | High |
| LLM cost per 10-step task | $0.02–$0.30 | $0 | $0 | $0 |

### Real-World Cost Analysis

| LLM Provider | Cost per Task (avg 10 steps) | Best For |
|-------------|---------------------------|----------|
| GPT-4o | ~$0.15–$0.30 | Complex reasoning tasks |
| Claude Sonnet 4 | ~$0.10–$0.20 | Production reliability |
| Gemini 3 Flash | ~$0.02–$0.05 | Cost-sensitive batch jobs |
| Local (Qwen2.5-72B) | ~$0.005 (GPU cost) | Privacy-first deployments |

### Use Case: Automated Price Monitoring

```python
import asyncio
from browser_use import Agent, Browser
from langchain_openai import ChatOpenAI

async def monitor_prices():
    urls = [
        "https://amazon.com/dp/B0DHTYW7P5",
        "https://bestbuy.com/site/xyz",
        "https://newegg.com/product/abc",
    ]
    
    results = []
    for url in urls:
        agent = Agent(
            task=f"Go to {url} and extract the current price, availability, and seller name",
            llm=ChatOpenAI(model="gpt-4o-mini"),
            browser=Browser(),
        )
        result = await agent.run()
        results.append({"url": url, "data": result.output})
    
    return results

# Run daily via cron or scheduled task
prices = asyncio.run(monitor_prices())
```

---

## Advanced Usage / Production Hardening

### Parallel Agent Execution

```python
import asyncio
from browser_use import Agent, Browser
from langchain_openai import ChatOpenAI

async def run_parallel_agents(tasks):
    browser = Browser()
    agents = [
        Agent(task=task, llm=ChatOpenAI(model="gpt-4o-mini"), browser=browser)
        for task in tasks
    ]
    results = await asyncio.gather(*[agent.run() for agent in agents])
    return results

tasks = [
    "Find iPhone 16 price on Amazon",
    "Find iPhone 16 price on Best Buy",
    "Find iPhone 16 price on Apple Store",
]

results = asyncio.run(run_parallel_agents(tasks))
```

### Proxy Configuration for Scraping

```python
from browser_use import Browser, BrowserConfig
from browser_use import Agent
from langchain_openai import ChatOpenAI

config = BrowserConfig(
    proxy={
        "server": "http://proxy.example.com:8080",
        "username": "user",
        "password": "pass",
    },
    headless=True,
)

browser = Browser(config=config)
agent = Agent(
    task="Extract data from a geo-restricted site",
    llm=ChatOpenAI(model="gpt-4o"),
    browser=browser,
)
```

### Session Persistence and Authentication

```python
from browser_use import Browser, BrowserConfig, Agent
from langchain_openai import ChatOpenAI

# Use persistent browser profile to maintain login state
config = BrowserConfig(
    user_data_dir="./browser_profile",
    headless=False,  # Use headed mode for initial login
)

async def authenticated_task():
    browser = Browser(config=config)
    agent = Agent(
        task="Download my monthly invoice from the billing page",
        llm=ChatOpenAI(model="gpt-4o"),
        browser=browser,
    )
    return await agent.run()
```

### Error Handling and Retries

```python
import asyncio
from browser_use import Agent, Browser
from langchain_openai import ChatOpenAI

async def robust_agent(task, max_retries=3):
    for attempt in range(max_retries):
        try:
            agent = Agent(
                task=task,
                llm=ChatOpenAI(model="gpt-4o"),
                browser=Browser(),
                max_steps=25,  # Limit steps to prevent runaway loops
            )
            result = await agent.run()
            if result.success:
                return result
        except Exception as e:
            print(f"Attempt {attempt + 1} failed: {e}")
            await asyncio.sleep(2 ** attempt)  # Exponential backoff
    raise Exception(f"Task failed after {max_retries} attempts")
```

### Monitoring with Prometheus

```python
from prometheus_client import Counter, Histogram, start_http_server
from browser_use import Agent, Browser

agent_runs = Counter("browseruse_agent_runs_total", "Total agent runs")
agent_failures = Counter("browseruse_agent_failures_total", "Total agent failures")
agent_duration = Histogram("browseruse_agent_duration_seconds", "Agent run duration")

start_http_server(8000)

async def monitored_agent(task):
    agent_runs.inc()
    with agent_duration.time():
        try:
            agent = Agent(task=task, llm=llm, browser=Browser())
            result = await agent.run()
            return result
        except Exception:
            agent_failures.inc()
            raise
```

---

## Comparison with Alternatives

| Feature | Browser Use | Scrapy | Puppeteer | Selenium |
|---------|-------------|--------|-----------|----------|
| **Language** | Python | Python | JavaScript/TypeScript | Python, Java, C#, JS |
| **AI-Native** | Yes (LLM-driven) | No | No | No |
| **JavaScript Rendering** | Yes (via Playwright) | No (needs Splash/Playwright) | Yes (Chromium) | Yes (all browsers) |
| **Selector Maintenance** | None (AI vision) | High (XPath/CSS) | High (CSS) | High (XPath/CSS) |
| **Multi-Browser Support** | Chromium, Firefox, WebKit | N/A | Chromium only | Chrome, Firefox, Safari, Edge |
| **WebVoyager Success Rate** | 89.1% | N/A | N/A | N/A |
| **Speed (pages/min)** | ~8–15 | ~200+ (static) | ~40–60 | ~18–35 |
| **Setup Complexity** | Low (pip install) | Medium | Low (npm) | High (WebDriver) |
| **Cost per 1K tasks** | $20–$300 (LLM) | Free (infra only) | Free (infra only) | Free (infra only) |
| **Best For** | AI agents, complex tasks | Large-scale static scraping | Chrome automation, testing | Cross-browser testing, legacy |
| **GitHub Stars** | 94,731 | 54,200 | 90,800 | 25,400 |

### When to Choose What

- **Browser Use**: Complex multi-step tasks on dynamic sites where writing selectors is impractical. AI agents that need to adapt to changing UIs.
- **Scrapy**: High-volume extraction of static HTML pages. Best for structured crawling at scale.
- **Puppeteer**: Chrome-only automation where speed matters and you control the target site. Ideal for PDF generation and screenshots.
- **Selenium**: Cross-browser testing for enterprise applications with strict browser coverage requirements.

---

## Limitations / Honest Assessment

Browser Use is not a universal replacement for traditional browser automation. Here is what it is not good for:

1. **High-volume, low-cost scraping**: At $0.02–$0.30 per task in LLM costs, scraping 100,000 pages costs $2,000–$30,000. Scrapy + HTTP requests costs pennies for the same volume on static sites.

2. **Deterministic testing**: AI agents are non-deterministic. The same task may take different paths on each run. Use Playwright or Selenium for CI/CD test suites that require 100% reproducibility.

3. **Real-time applications**: Each action requires an LLM inference call (2–5 seconds). Sub-second response requirements are not achievable with the current agent loop architecture.

4. **Simple, stable sites**: If the target site never changes and has clean selectors, traditional automation is faster, cheaper, and more reliable.

5. **LLM dependency**: You are bound to the availability and pricing of third-party LLM APIs. Rate limits can bottleneck production workloads.

---

## Frequently Asked Questions

### What is Browser Use used for?
Browser Use is a Python framework that lets LLMs control web browsers via Playwright. It is used for AI-driven web automation — tasks like form filling, data extraction, price monitoring, and multi-step web workflows where traditional selector-based automation would be brittle or impractical.

### How does Browser Use compare to Selenium?
Browser Use requires zero selector maintenance (AI reads the page), handles dynamic UIs natively, and achieves 89.1% on the WebVoyager benchmark. Selenium is faster for simple tasks (~18–35 pages/min vs ~8–15), supports more browsers, and has no per-task LLM cost. Use Selenium for cross-browser testing; use Browser Use for complex AI-driven tasks.

### What LLMs work with Browser Use?
Any LangChain-compatible LLM: OpenAI GPT-4o/5.1, Anthropic Claude Sonnet 4, Google Gemini 3 Flash, and local models via Ollama (Qwen2.5, Llama 3, Mistral). The framework is model-agnostic through LiteLLM.

### How much does Browser Use cost?
The framework is free (MIT license). You pay for LLM API usage: approximately $0.02–$0.30 per 10-step task depending on the model. Browser Use Cloud offers managed stealth browsers starting at $29/month.

### Can I run Browser Use in Docker?
Yes. Install `browser-use` and `playwright` in a Python 3.11+ container, run `playwright install chromium`, and set your API keys via environment variables. A sample Dockerfile is provided in the Installation section above.

### Does Browser Use solve CAPTCHAs?
Browser Use does not solve CAPTCHAs natively. For protected sites, pair it with Browser Use Cloud (built-in CAPTCHA solving), or integrate with a dedicated CAPTCHA service like 2Captcha or CapSolver.

### How do I handle authentication in Browser Use?
Use persistent browser profiles (`user_data_dir` in `BrowserConfig`) to maintain cookies and login state across sessions. For OAuth or 2FA flows, run the initial login in headed mode, then switch to headless for subsequent tasks.

### What is the difference between Browser Use and Stagehand?
Browser Use is a fully autonomous agent framework — the LLM controls all navigation decisions. Stagehand (by Browserbase) adds AI primitives (`act()`, `extract()`, `observe()`) on top of Playwright for hybrid workflows where deterministic and AI-driven steps coexist. Choose Browser Use for full autonomy; choose Stagehand for surgical AI enhancement of existing Playwright scripts.

---

## Conclusion

Browser Use has earned its 94,731 GitHub stars by solving a genuine pain point: maintaining browser automation scripts on modern, ever-changing websites. Its 89.1% WebVoyager success rate, model-agnostic design, and Playwright foundation make it the best open-source choice for AI-driven web automation in 2026.

The framework is not without tradeoffs — LLM costs add up at scale, and deterministic testing remains the domain of Selenium and Playwright. But for teams building AI agents that need to navigate arbitrary websites, fill forms, extract data, and adapt to UI changes without human intervention, Browser Use is the most mature open-source option available.

**Action items**:
1. Clone the [browser-use/browser-use](https://github.com/browser-use/browser-use) repository
2. Run `pip install browser-use` and set up your first agent with the code examples above
3. Evaluate the WebVoyager benchmark against your use case
4. Join the [Browser Use Discord](https://link.browser-use.com/discord) for community support and production tips

> **Want more AI automation tutorials?** Join our [Telegram group](https://t.me/dibi8opensource) for weekly deep-dives on open-source AI tools, production deployment tips, and benchmark data.

---



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- [Browser Use GitHub Repository](https://github.com/browser-use/browser-use)
- [Browser Use Official Documentation](https://docs.browser-use.com)
- [Browser Use Cloud Platform](https://cloud.browser-use.com)
- [WebVoyager Benchmark Leaderboard](https://leaderboard.steel.dev/)
- [Playwright vs Puppeteer vs Selenium 2026 Benchmarks](https://use-apify.com/blog/playwright-vs-puppeteer-vs-selenium-2026)
- [AI Browser Automation Tools Comparison 2026](https://awesomeagents.ai/tools/best-ai-browser-automation-tools-2026/)
- [Browser Use Proxy Setup Guide](https://www.coronium.io/blog/browser-use-proxy-setup)
- [Stagehand vs Browser Use vs Playwright Comparison](https://www.nxcode.io/resources/news/stagehand-vs-browser-use-vs-playwright-ai-browser-automation-2026)

---

*This article was written for developers who need production-grade browser automation. All benchmark data is sourced from publicly available leaderboards and independent testing as of May 2026.*
