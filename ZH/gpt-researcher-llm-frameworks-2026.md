---
title: 'GPT Researcher：自主深度研究报告智能体——2026 实战指南'
description: 'GPT Researcher 是一个开源深度研究智能体，能针对任意任务执行联网与本地研究并生成带引用的报告。27,473 GitHub 星标，Apache-2.0 许可。涵盖安装、异步 Python API、Docker 与真实代码示例。'
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
  - q: '如何安装 gpt-researcher？'
    a: '通过 pip 安装 Python 包： ```bash pip install gpt-researcher ```'
  - q: '可以用哪些 LLM 提供商和搜索引擎？'
    a: '默认 LLM 是 OpenAI，默认检索器是 Tavily，但两者都可通过环境变量和配置文件更换，智能体还支持包括基于 MCP 的来源在内的其他检索器。'
  - q: '运行它需要 API 密钥吗？'
    a: '需要。至少要在项目根目录的 `.env` 文件中设置 `OPENAI_API_KEY` 和 `TAVILY_API_KEY`。若使用兼容 OpenAI 的端点，再加上 `OPENAI_BASE_URL`。'
  - q: '如何运行带 Web 界面的完整应用？'
    a: '克隆仓库并运行 `docker-compose up --build`。这会在 `localhost:8000` 启动 FastAPI 服务端，在 `localhost:3000` 启动前端。你也可以只启动服务端：`python -m uvicorn main:app --reload`。'
  - q: 'conduct_research() 和 write_report() 是同步的吗？'
    a: '不是。两者都是异步方法。要在 async 函数内用 `await` 调用，并用 `asyncio.run()` 运行该函数。'
---

{{< resource-info >}}

## 引言

只要你用大语言模型（LLM）做过开发，多半都撞过同一堵墙：把一个问题变成一份资料扎实、有据可查的报告，是又慢又费人力的活儿。`assafelovic/gpt-researcher` 把这个环节自动化了。它是一个自主智能体，能联网搜索（也能读你本地的文件）、收集来源，并从一句查询出发写出一份带引用的研究报告。本指南将带你安装它、用 Python 跑起来，并把它接入真实工作流。

![gpt-researcher 概览，via dibi8.com](https://contrib.rocks/image?repo=assafelovic/gpt-researcher&max=1000)

*gpt-researcher 贡献者（来源：assafelovic/gpt-researcher 仓库，经 dibi8 分析）*

## GPT Researcher 是什么？

GPT Researcher 把自己定位为「首个面向联网与本地研究、可处理任意任务的开源深度研究智能体」。你给它一句查询，它会规划研究路径、执行多轮搜索、阅读并筛选结果，最后综合成一份带引用的报告。

该项目在 GitHub 上拥有超过 27,000 颗星，由 `assafelovic` 以 Apache-2.0 许可维护，默认分支为 `master`。

## GPT Researcher 的工作原理

它底层跑的是一套「规划-执行」循环，而不是单次提示：

1. **规划**：根据你的查询，智能体生成一组研究子问题，从多个角度覆盖整个主题。

2. **搜索与收集**：针对每个子问题，它调用检索器（默认是 Tavily）进行查询并抓取结果页面，只保留相关段落作为上下文。

3. **撰写**：它把汇总后的上下文回传给 LLM，生成报告——研究报告、资源清单、提纲，以及篇幅更长的详细报告都支持，此外还有一个会展开主题树的深度研究（Deep Research）模式。

配置通过环境变量和配置文件完成，而不是写死在代码里，因此你可以不动脚本就更换 LLM 和检索器。

![gpt-researcher 星标历史，via dibi8.com](https://api.star-history.com/svg?repos=assafelovic/gpt-researcher&type=Date)

*gpt-researcher 星标历史（来源：assafelovic/gpt-researcher 仓库，经 dibi8 分析）*

## 安装与配置

若要把 gpt-researcher 作为定时生产任务运行，你需要一台常开的机器——可以在 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) 开一台（新账号有免费试用额度），或选 [HTStack](https://my.htstack.com/aff.php?aff=27187) 的低延迟香港 VPS（与托管 dibi8.com 的是同一家 IDC）。

运行 GPT Researcher 常见有两种方式：作为 Python 包嵌入你自己的代码，或通过 Docker 跑完整应用（Python API 服务端 + Web 前端）。

### 使用 pip（Python 包）

先确认已安装 Python：

```sh
python3 --version
```

然后安装该包：

```sh
pip install gpt-researcher
```

### 通过 .env 配置 API 密钥

GPT Researcher 需要一个 LLM（默认 OpenAI）和一个搜索检索器（默认 Tavily）。在项目根目录创建 `.env` 文件，填入两个密钥：

```plaintext
OPENAI_API_KEY=your_openai_key_here
TAVILY_API_KEY=your_tavily_key_here
```

如果你指向的是兼容 OpenAI 的自定义端点，还要设置 `OPENAI_BASE_URL`。首次运行最常见的错误就是缺少密钥——若遇到鉴权或「API key not found」之类的报错，请检查 `.env` 文件是否存在、是否在调用研究器之前被正确加载。

### 使用 Docker（含前端的完整应用）

要运行完整应用——FastAPI 服务端加 Web 界面——克隆仓库并使用 Docker Compose：

```sh
git clone https://github.com/assafelovic/gpt-researcher.git
cd gpt-researcher
docker-compose up --build
```

默认情况下，这会在 `localhost:8000` 启动 Python 服务端，在 `localhost:3000` 启动前端。

### 不用 Docker 直接启动服务端

你也可以直接启动 FastAPI 服务端：

```sh
python -m uvicorn main:app --reload
```

然后在浏览器中打开 `http://localhost:8000`。

## 核心用法

Python API 围绕 `GPTResearcher` 类构建。研究和撰写报告都是**异步**的，因此要在 async 函数内用 `await` 调用。

### 示例 1：一份基础研究报告

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

### 示例 2：选择报告类型

`GPTResearcher` 接受一个 `report_type` 参数，让你不再只拿到默认的研究报告，而是可以要一份简短摘要、资源清单，或篇幅更长的详细报告：

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

### 示例 3：查看收集到的来源

研究跑完后，你可以取出智能体所用的底层上下文和来源 URL——这对审核或自建引用清单很有用：

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

这些示例只是起点。由于 LLM 和检索器都通过配置设定，同一份代码无需改动即可跑在不同的提供商上。

## 集成

GPT Researcher 能轻松嵌入现有的 Python 工作流，因为它本质上就是一个纯异步库，外加一个可选的 HTTP 服务。

### 更换 LLM 提供商与检索器

你并不会被锁死在 OpenAI 或 Tavily 上。默认 LLM 是 OpenAI、默认检索器是 Tavily，但两者都可通过环境变量和配置文件更换。例如，要把默认的联网搜索与基于 MCP 的来源结合，可设置检索器列表：

```sh
export RETRIEVER=tavily,mcp
```

这种混合配置让智能体既能从通用网络搜索取材，也能通过模型上下文协议（MCP）接入专门的数据源。

### 在 notebook 或服务中使用

由于这套 API 只需两次 await 调用，你可以把 GPT Researcher 直接放进 Jupyter notebook、后台任务，或一个 FastAPI 端点里：

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

面对更复杂的流水线，该仓库还附带了一套基于 LangGraph 和 AG2 构建的多智能体方案，由多个专职智能体协同来产出更长的报告。

## 基准测试与真实使用

### 真实使用场景

GPT Researcher 主要用于把研究和写报告中最慢的环节自动化：

1. **自动化研究简报**：针对某个主题或产品想法生成初稿报告，并附上来源，替代手动联网搜索。

2. **文献与市场扫描**：跨大量页面快速收集并归纳材料，让人去审阅综合结论，而不必逐篇阅读每个来源。

3. **内部工具**：把异步 API 包装成内部服务，让非技术同事也能从一句查询拿到带来源的报告。

### 社区信号

README 没有公布正式的准确率基准，因此对于任何关于性能的说法，都应放到你自己的任务上去验证。可验证的是社区热度：超过 27,473 颗 GitHub 星标和活跃的 issue 列表，说明它持续被采用和维护。在用于生产之前，先拿一个有代表性的查询跑一遍。

## 与替代方案的对比

另见我们对[相关开源工具](dibi8-internal-link)的报道。

GPT Researcher 属于「自主研究智能体」这一类。与其编造竞品数字，不如这样诚实地对照：

| 维度 | GPT Researcher |
|----------------------|----------------------------------------|
| **星标** | 27,473 |
| **语言** | Python |
| **许可** | Apache-2.0 |
| **维护者** | Assaf Elovic（`assafelovic`） |
| **定位** | 联网 + 本地深度研究，输出带引用的报告 |
| **默认分支** | master |
| **LLM 提供商** | 默认 OpenAI；可经环境变量/配置更换 |
| **检索器** | 默认 Tavily；支持 MCP 及其他检索器 |
| **前端** | 有——轻量 FastAPI 界面，以及 Next.js + Tailwind 应用 |
| **多智能体** | 有——LangGraph / AG2 多智能体流水线 |

### 为什么选 GPT Researcher？

- **端到端的报告，而非单条答案**：它返回的是结构化、带引用的报告，而不是一句聊天回复。
- **可配置的技术栈**：LLM 和检索器都可更换，无需重写代码。
- **既是库也是应用**：可以在自己的代码里用异步 API，也可以跑它自带的服务端和 Web 界面。

## 局限与客观评估

GPT Researcher 很能干，但要清楚它的取舍：

1. **API 成本与延迟**：每次运行都会扩散成多次 LLM 调用与页面抓取，因此深度或详细报告可能既慢又消耗较多 token 和搜索 API 费用。
2. **配置面较大**：要让非默认的 LLM、检索器或多智能体流水线跑起来，需要花时间读文档、调配置。
3. **依赖联网**：联网研究需要网络访问和可用的搜索 API；离线只能用本地文档模式，功能有限。
4. **质量随模型与来源浮动**：输出的好坏取决于底层 LLM 和它抓到的页面，因此报告在被你依赖前仍需人工核查。
5. **学习曲线**：异步 API 本身简单，但弄懂报告类型、检索器和多智能体流程需要一点上手时间。

对于一个要编排大量 LLM 与搜索调用的智能体来说，这些都是正常的取舍——在接入生产流水线前值得心里有数。

## 结语

`assafelovic/gpt-researcher` 通过编排规划、联网搜索、抓取与 LLM 撰写，把一句查询变成一份有来源、有结构的报告，而这一切都藏在一套小巧的异步 API 背后。凭借 27,000+ 星标、Apache-2.0 许可、可配置的 LLM/检索器技术栈以及自带的 Web 应用，它是研究自动化里一块实用的基石。下一步：设好你的两个 API 密钥，拿一个真实问题跑一遍基础 Python 示例，并在扩大规模前先查看来源。

大规模抓取需要轮换代理——[WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f) 是业界常用之选。

- 加入 [dibi8 英文 Telegram 群](https://t.me/DIBI8_Group/2)，获取开源 AI 工具速递。
- 延伸阅读：[dibi8 相关指南](dibi8-internal-link)。

---

**来源与延伸阅读**：
- GitHub 仓库：https://github.com/assafelovic/gpt-researcher
- 官方文档 / README：https://github.com/assafelovic/gpt-researcher#readme

*以上部分链接为联盟链接。若你通过它们注册，dibi8.com 可能获得一笔佣金，而你不会因此多付任何费用。这有助于维持网站运营、保持内容免费。*

<!-- internal-link-candidates:
  related open-source tools -> ai-tools-directory
  related guides on dibi8 -> ai-coding-agent-landscape-2026-skills-mcp-opensource
-->
