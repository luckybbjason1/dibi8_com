---
title: 'Browser Use: 94K+ Stars — 2026年 AI 浏览器自动化基准测试与实战'
description: 'Browser Use 是一款开源 Python 框架，通过 Playwright 连接 LLM 与真实浏览器。支持 OpenAI、Anthropic、Gemini 及本地模型。涵盖安装配置、WebVoyager 基准测试、Selenium 对比、生产环境加固与 Docker 部署。'
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
tags: ['browser-use', 'ai智能体', 'playwright', '浏览器自动化', '网络爬虫', '大语言模型', 'python', '开源']
aliases:
- /zh/posts/browser-use/
---

{{</* resource-info */>}}

![Browser Use Logo](https://raw.githubusercontent.com/browser-use/browser-use/main/docs/static/img/browser-use-logo.png)

> **GitHub**: [browser-use/browser-use](https://github.com/browser-use/browser-use) | **Stars**: 94,731 | **License**: MIT | **Version**: 0.12.7

---

## 引言

用 Selenium 编写和维护现代网页自动化脚本，无异于被一千个选择器凌迟处死。一个 class 名变了，一个按钮挪了位置，你的整个流水线就在凌晨 3 点崩掉。Browser Use 是 Magnus Müller 和 Gregor Žunič 于 2024 年底发布的开源 Python 框架，它走了一条截然不同的路：把浏览器控制权交给大语言模型，让 AI 自己决定点什么、填什么、读什么。凭借 94,731 个 GitHub Star、319 位贡献者以及 WebVoyager 基准测试 89.1% 的成功率，Browser Use 已成为 AI 驱动浏览器自动化的事实开源标准。本教程涵盖安装配置、真实基准数据、与主流 LLM 的集成，以及与 Selenium、Puppeteer、Scrapy 的正面对比。

---

## Browser Use 是什么？

Browser Use 是一个 Python 库（要求 ≥3.11），通过 Playwright 将任何兼容 LangChain 的 LLM 连接到真实浏览器。你无需硬编码 CSS 选择器或 XPath 表达式，只需用自然语言描述任务 —— "找到下周从纽约到旧金山最便宜的航班" —— 智能体便会自主完成导航、填表、点击和数据提取。

### 核心设计原则

- **模型无关**：支持 OpenAI GPT-4o/5.1、Anthropic Claude Sonnet 4、Google Gemini 3 Flash，以及通过 LiteLLM 接入的本地模型。
- **DOM 精简**：在将页面发送给 LLM 之前，仅保留必要的交互元素，Token 消耗降低多达 60%。
- **多标签页支持**：智能体可同时跨多个浏览器标签页操作。
- **持久记忆**：在导航步骤之间保持上下文和对话历史。
- **基于 Playwright**：继承 Playwright 的全部能力 —— 隐身模式、代理支持、网络拦截和视频录制。

---

## Browser Use 的工作原理

Browser Use 基于持续的 **观察 → 规划 → 执行 → 验证** 循环运行：

### 架构概览

```
┌─────────────┐    DOM + 截图          ┌─────────────┐
│   浏览器     │ ─────────────────────> │     LLM     │
│ (Playwright)│                        │(Claude/GPT/)│
│             │ <───────────────────── │   Gemini    │
└─────────────┘     动作 (点击/输入)    └─────────────┘
      ↑                                       │
      └────────── 页面状态变更 ────────────────┘
```

![Browser Use Agent Loop Architecture](https://raw.githubusercontent.com/browser-use/browser-use/main/docs/static/img/agent-loop-diagram.png)

### 智能体循环详解

1. **捕获**：Browser Use 对当前页面进行 DOM 快照和截图。
2. **精简**：DOM 被过滤为仅保留交互元素（按钮、输入框、链接），减少干扰信息。
3. **推理**：LLM 接收精简后的页面状态和用户的任务目标，规划下一步动作。
4. **执行**：Browser Use 将 LLM 的决策转换为 Playwright API 调用（`page.click()`、`page.fill()`）。
5. **验证**：循环重复，直到任务完成或达到 `max_steps` 上限。

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

## 安装与配置

### 前置条件

- Python 3.11 或更高版本
- Playwright 兼容浏览器（推荐使用 Chromium）
- 所选 LLM 提供商的 API Key

### 第一步：安装 Browser Use

```bash
# 使用 uv（推荐）
uv init
uv add browser-use
uv sync

# 使用 pip
pip install browser-use

# 安装 Chromium（如果尚未安装）
playwright install chromium
```

### 第二步：配置环境变量

```bash
# .env 文件
OPENAI_API_KEY=sk-your-openai-key
ANTHROPIC_API_KEY=sk-ant-your-anthropic-key
GOOGLE_API_KEY=your-google-api-key

# 可选：Browser Use Cloud 隐身浏览器
BROWSER_USE_API_KEY=your-cloud-key
```

### 第三步：运行你的第一个智能体

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

### Docker 部署（生产环境）

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

## 与主流工具集成

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

### Ollama（本地模型）

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

### Playwright 直接集成

```python
from playwright.async_api import async_playwright
from browser_use import Agent
from langchain_openai import ChatOpenAI

async def hybrid_automation():
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        
        # 确定性 Playwright 步骤
        await page.goto("https://example.com")
        
        # 将复杂任务移交给 Browser Use 智能体
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

## 基准测试 / 真实场景用例

### WebVoyager 基准测试结果

WebVoyager 基准测试基于 586 个真实网页任务评估浏览器智能体。Browser Use 以 89.1% 的成功率位列全球排行榜第 7 名 —— 是全开源框架中的最高排名。

![WebVoyager Leaderboard showing Browser Use at 89.1%](https://docs.browser-use.com/assets/images/webvoyager-benchmark-2026.png)

| 排名 | 系统 | 得分 | 组织 |
|------|------|------|------|
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

### 性能指标（对比传统工具）

| 指标 | Browser Use (AI) | Playwright | Puppeteer | Selenium |
|------|-----------------|-----------|-----------|----------|
| 冷启动到首次导航 | ~0.5–0.8s | ~0.4–0.7s | ~0.3–0.5s | ~1.2–2.5s |
| 空闲内存（每实例） | ~100–150MB | ~90–130MB | ~60–100MB | ~180–280MB |
| 静态页面/分钟 | ~8–15（AI 循环） | ~35–55 | ~40–60 | ~18–35 |
| 陌生站点成功率 | 89.1% | N/A | N/A | N/A |
| 选择器维护成本 | 无 | 高 | 高 | 高 |
| LLM 成本（每 10 步任务） | $0.02–$0.30 | $0 | $0 | $0 |

### 真实成本分析

| LLM 提供商 | 每任务成本（平均 10 步） | 适用场景 |
|-----------|------------------------|----------|
| GPT-4o | ~$0.15–$0.30 | 复杂推理任务 |
| Claude Sonnet 4 | ~$0.10–$0.20 | 生产环境可靠性 |
| Gemini 3 Flash | ~$0.02–$0.05 | 成本敏感的批量任务 |
| 本地 (Qwen2.5-72B) | ~$0.005（GPU 成本） | 隐私优先的部署 |

### 用例：自动化价格监控

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

# 通过 cron 或定时任务每日运行
prices = asyncio.run(monitor_prices())
```

---

## 高级用法 / 生产环境加固

### 并行智能体执行

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

### 代理配置（用于爬虫）

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

### 会话持久化与认证

```python
from browser_use import Browser, BrowserConfig, Agent
from langchain_openai import ChatOpenAI

# 使用持久化浏览器配置文件来保持 Cookie 和登录状态
config = BrowserConfig(
    user_data_dir="./browser_profile",
    headless=False,  # 初始登录使用有头模式
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

### 错误处理与重试

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
                max_steps=25,  # 限制步数防止无限循环
            )
            result = await agent.run()
            if result.success:
                return result
        except Exception as e:
            print(f"Attempt {attempt + 1} failed: {e}")
            await asyncio.sleep(2 ** attempt)  # 指数退避
    raise Exception(f"Task failed after {max_retries} attempts")
```

### Prometheus 监控集成

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

## 与替代方案对比

| 特性 | Browser Use | Scrapy | Puppeteer | Selenium |
|------|-------------|--------|-----------|----------|
| **编程语言** | Python | Python | JavaScript/TypeScript | Python, Java, C#, JS |
| **AI 原生** | 是（LLM 驱动） | 否 | 否 | 否 |
| **JavaScript 渲染** | 是（通过 Playwright） | 否（需 Splash/Playwright） | 是（Chromium） | 是（所有浏览器） |
| **选择器维护** | 无（AI 视觉） | 高（XPath/CSS） | 高（CSS） | 高（XPath/CSS） |
| **多浏览器支持** | Chromium, Firefox, WebKit | N/A | 仅 Chromium | Chrome, Firefox, Safari, Edge |
| **WebVoyager 成功率** | 89.1% | N/A | N/A | N/A |
| **速度（页面/分钟）** | ~8–15 | ~200+（静态） | ~40–60 | ~18–35 |
| **配置复杂度** | 低（pip install） | 中等 | 低（npm） | 高（WebDriver） |
| **每 1K 任务成本** | $20–$300（LLM） | 免费（仅基础设施） | 免费（仅基础设施） | 免费（仅基础设施） |
| **适用场景** | AI 智能体、复杂任务 | 大规模静态页面爬取 | Chrome 自动化、测试 | 跨浏览器测试、遗留系统 |
| **GitHub Stars** | 94,731 | 54,200 | 90,800 | 25,400 |

### 选型建议

- **Browser Use**：在动态网站上执行复杂多步骤任务，编写选择器不切实际时。需要适应 UI 变化的 AI 智能体。
- **Scrapy**：大规模提取静态 HTML 页面。结构化爬取的最佳选择。
- **Puppeteer**：需要速度且你控制目标站点的纯 Chrome 自动化。适合 PDF 生成和截图。
- **Selenium**：企业级跨浏览器测试，有严格的浏览器覆盖要求。

---

## 局限性 / 客观评估

Browser Use 并非传统浏览器自动化的万能替代品。以下场景不适用：

1. **高容量低成本爬取**：按每任务 $0.02–$0.30 的 LLM 成本计算，爬取 10 万页需 $2,000–$30,000。Scrapy + HTTP 请求在静态站点上仅需几美分。

2. **确定性测试**：AI 智能体具有非确定性。同一任务每次运行可能走不同路径。CI/CD 测试套件需要 100% 可复现性，应使用 Playwright 或 Selenium。

3. **实时应用**：每个动作都需要调用 LLM 推理（2–5 秒）。当前智能体循环架构无法满足亚秒级响应要求。

4. **简单稳定的站点**：如果目标站点从不变化且选择器清晰，传统自动化更快、更便宜、更可靠。

5. **LLM 依赖**：你受限于第三方 LLM API 的可用性和定价。速率限制可能成为生产工作负载的瓶颈。

---

## 常见问题

### Browser Use 是用来做什么的？
Browser Use 是一款 Python 框架，通过 Playwright 让 LLM 控制浏览器。它用于 AI 驱动的网页自动化 —— 如填表、数据提取、价格监控和多步骤网页工作流，在这些场景中传统的基于选择器的自动化脆弱或不可行。

### Browser Use 与 Selenium 相比如何？
Browser Use 无需维护选择器（AI 读取页面），原生处理动态 UI，在 WebVoyager 上达到 89.1% 的成功率。Selenium 在简单任务上更快（~18–35 页/分钟 vs ~8–15），支持更多浏览器，没有每任务的 LLM 成本。跨浏览器测试选 Selenium；复杂 AI 驱动任务选 Browser Use。

### Browser Use 支持哪些 LLM？
任何兼容 LangChain 的 LLM：OpenAI GPT-4o/5.1、Anthropic Claude Sonnet 4、Google Gemini 3 Flash，以及通过 Ollama 接入的本地模型（Qwen2.5、Llama 3、Mistral）。框架通过 LiteLLM 实现模型无关。

### Browser Use 的成本是多少？
框架本身免费（MIT 许可证）。LLM API 使用费约为每 10 步任务 $0.02–$0.30，具体取决于模型。Browser Use Cloud 提供托管隐身浏览器，起步价 $29/月。

### 可以在 Docker 中运行 Browser Use 吗？
可以。在 Python 3.11+ 容器中安装 `browser-use` 和 `playwright`，运行 `playwright install chromium`，并通过环境变量设置 API Key。上面的安装章节提供了 Dockerfile 示例。

### Browser Use 能解决 CAPTCHA 吗？
Browser Use 本身不能解决 CAPTCHA。对于受保护的站点，可搭配 Browser Use Cloud（内置 CAPTCHA 解决），或集成 2Captcha、CapSolver 等专用 CAPTCHA 服务。

### 如何在 Browser Use 中处理认证？
使用持久化浏览器配置文件（`BrowserConfig` 中的 `user_data_dir`）来保持 Cookie 和登录状态。对于 OAuth 或 2FA 流程，初始登录使用有头模式，后续任务切换为无头模式。

### Browser Use 与 Stagehand 有什么区别？
Browser Use 是完全自主的智能体框架 —— LLM 控制所有导航决策。Stagehand（由 Browserbase 开发）在 Playwright 之上添加 AI 原语（`act()`、`extract()`、`observe()`），适合确定性与 AI 驱动步骤共存的混合工作流。全自主选 Browser Use；精确增强现有 Playwright 脚本选 Stagehand。

---

## 结论

Browser Use 凭借 94,731 个 GitHub Star，解决了真实痛点：在现代、不断变化的网站上维护浏览器自动化脚本。其 89.1% 的 WebVoyager 成功率、模型无关的设计和 Playwright 基础使其成为 2026 年 AI 驱动网页自动化的最佳开源选择。

该框架并非没有权衡 —— LLM 成本在大规模下会累积，确定性测试仍是 Selenium 和 Playwright 的领域。但对于需要构建能够导航任意网站、填表、提取数据并在无需人工干预的情况下适应 UI 变化的 AI 智能体的团队，Browser Use 是目前最成熟的开源方案。

> **想要更多 AI 自动化教程？** 加入我们的 [Telegram 群组](https://t.me/dibi8opensource) 获取开源 AI 工具每周深度解析、生产部署技巧和基准数据。

**行动清单**：
1. 克隆 [browser-use/browser-use](https://github.com/browser-use/browser-use) 仓库
2. 运行 `pip install browser-use`，用上面的示例配置你的第一个智能体
3. 针对你的使用场景评估 WebVoyager 基准
4. 加入 [Browser Use Discord](https://link.browser-use.com/discord) 获取社区支持和生产环境技巧

---



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与扩展阅读

- [Browser Use GitHub 仓库](https://github.com/browser-use/browser-use)
- [Browser Use 官方文档](https://docs.browser-use.com)
- [Browser Use Cloud 平台](https://cloud.browser-use.com)
- [WebVoyager 基准排行榜](https://leaderboard.steel.dev/)
- [Playwright vs Puppeteer vs Selenium 2026 基准](https://use-apify.com/blog/playwright-vs-puppeteer-vs-selenium-2026)
- [2026 AI 浏览器自动化工具对比](https://awesomeagents.ai/tools/best-ai-browser-automation-tools-2026/)
- [Browser Use 代理配置指南](https://www.coronium.io/blog/browser-use-proxy-setup)
- [Stagehand vs Browser Use vs Playwright 对比](https://www.nxcode.io/resources/news/stagehand-vs-browser-use-vs-playwright-ai-browser-automation-2026)

---

*本文面向需要生产级浏览器自动化的开发者。所有基准数据来源于公开排行榜和 2026 年 5 月的独立测试。*
