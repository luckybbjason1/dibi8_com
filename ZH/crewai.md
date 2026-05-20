---
title: 'CrewAI: 51000+ Star 构建多智能体 AI 团队 — 完整设置指南 2026'
description: 'CrewAI (crewAIInc/crewAI) 是一个用于编排角色扮演、自主 AI 智能体的 Python 框架。兼容 OpenAI、Anthropic、Ollama、LangChain 和 LlamaIndex。涵盖安装、智能体角色、任务工作流、生产部署和基准测试。'
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
tags: ['crewai', '多智能体', 'ai智能体', 'python', 'llm编排', '自动化', '开源', '机器学习']
aliases:
- /zh/posts/crewai/
- /zh/resources/llm-frameworks/crewai-multi-agent-orchestration/
---

{{</* resource-info */>}}

> 如何在 30 分钟内安装 CrewAI、配置智能体角色、编排任务并交付生产级多智能体系统。

## 简介

构建单个 LLM 驱动的智能体很简单。但要编排五个智能体协同完成研究、写作、编辑、事实核查和发布内容，且互不干扰，这是完全不同的挑战。CrewAI 通过基于角色的编排模型解决了这个问题，让开发者能够定义专门的智能体，为其分配任务，并以协调团队的形式运行它们。CrewAI 在 GitHub 上拥有超过 51,759 个星标和 318 位贡献者，已成为 2026 年 Python 多智能体协作的首选框架。本指南将带你完成 CrewAI 的安装、配置你的第一个 crew，并通过真实配置、基准测试和诚实的权衡分析将其部署到生产环境。

## 什么是 CrewAI？

CrewAI 是一个开源 Python 框架，用于编排基于角色扮演的自主 AI 智能体，这些智能体在复杂任务上进行协作工作。它提供两个核心抽象：**Crews**（具有明确定义角色、目标和背景故事的智能体团队）和 **Flows**（通过条件逻辑和状态管理来串联多个 crew 的事件驱动工作流）。与单一的 LLM 提示不同，CrewAI 智能体可以委派工作、使用工具，并通过顺序、层级或并行执行来生成结构化输出。

## CrewAI 的工作原理

CrewAI 的架构将智能体定义与编排逻辑分离：

![CrewAI Logo](https://raw.githubusercontent.com/crewAIInc/crewAI/main/docs/images/crewai_logo.png)

**核心组件：**

| 组件 | 用途 | 配置文件 |
|------|------|----------|
| **Agent** | 具有目标、背景故事和工具的基于角色的 AI 工作者 | `agents.yaml` |
| **Task** | 分配给智能体的工作单元，包含预期输出 | `tasks.yaml` |
| **Crew** | 通过定义的过程执行任务的智能体团队 | `crew.py` |
| **Flow** | 通过状态管理串联多个 crew 的事件驱动工作流 | `flow.py` |
| **Tool** | 外部能力（搜索、API、计算） | `tools/` |
| **Process** | 执行策略：顺序、层级或并行 | `crew.py` |

![CrewAI Architecture](https://github.com/crewAIInc/crewAI/raw/main/docs/images/asset.png)

**执行流程：**

1. Flow 接收输入并初始化状态
2. 基于过程类型将任务分派给智能体
3. 智能体执行任务，可选择使用工具
4. 任务输出作为上下文输入到后续任务
5. 返回最终结果及 token 使用量指标

上图展示了 CrewAI 的双模型架构：**Crews** 处理单一工作流内的智能体协作，而 **Flows** 提供了将多个 crew 与状态管理和条件路由相连接的事件驱动骨干。

## 安装与设置

### 前置条件

CrewAI 需要 Python 3.10–3.13 以及至少一个 LLM 提供商的 API 密钥。

```bash
# 检查 Python 版本
python --version  # 必须是 3.10、3.11、3.12 或 3.13

# 安装 uv（推荐的包管理器）
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 安装 CrewAI

```bash
# 安装 CrewAI 核心框架
uv pip install crewai

# 或安装包含可选工具的版本
uv pip install 'crewai[tools]'

# 验证安装
crewai version
```

### 创建新项目

```bash
# 搭建新的 CrewAI 项目
crewai create crew research_crew

# 进入项目目录
cd research_crew

# 安装项目依赖
crewai install
```

生成的项目结构：

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

### 配置环境变量

```bash
# .env — 将此文件添加到 .gitignore！
OPENAI_API_KEY=sk-your-openai-key-here
SERPER_API_KEY=your-serper-api-key
```

对于通过 Ollama 使用本地 LLM（无需 API 密钥）：

```bash
# 拉取本地模型
ollama pull llama3.1

# 在智能体配置中使用：ollama/llama3.1
```

## 定义你的第一个智能体

编辑 `src/research_crew/config/agents.yaml` 来定义基于角色的智能体：

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

每个智能体的关键配置选项：

| 参数 | 描述 | 示例 |
|------|------|------|
| `role` | 智能体的工作职责 | `Senior Research Analyst` |
| `goal` | 智能体要达到的目标 | 研究 `{topic}` |
| `backstory` | 塑造智能体行为的背景 | 经验和性格 |
| `llm` | 通过 LiteLLM 使用的模型 | `openai/gpt-4o` |
| `max_iter` | 每个任务的最大推理循环次数 | `15` |
| `verbose` | 在控制台打印思考过程 | `true` |
| `allow_delegation` | 可以委派给其他智能体 | `false` |

## 定义任务并连接 Crew

### 任务配置

编辑 `src/research_crew/config/tasks.yaml`：

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

### Crew 定义

在 `src/research_crew/crew.py` 中连接智能体和任务：

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

### 入口点与执行

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

运行 crew：

```bash
# 通过 CLI 执行
crewai run

# 或通过 Python 直接运行
python -m research_crew.main
```

预期输出：

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
[完整的编辑后文章显示在此处]
Token usage: UsageMetrics(total_tokens=18432, prompt_tokens=14201, ...)
```

## 高级用法：Flows、工具和生产模式

### 使用 CrewAI Flows 进行复杂编排

Flows 提供具有状态管理的事件驱动编排：

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

### 创建自定义工具

```python
# src/research_crew/tools/custom_tool.py
from crewai.tools import tool
import requests

@tool("Web Search")
def web_search(query: str) -> str:
    """Search the web for information on a given query."""
    response = requests.get(
        "https://serpapi.com/search",
        params={"q": query, "api_key": "${SERPER_API_KEY}"}
    )
    return response.json()["organic_results"][0]["snippet"]
```

在你的 crew 中注册工具：

```python
# 在 crew.py 中，导入并附加
from research_crew.tools.custom_tool import web_search

@agent
def researcher(self) -> Agent:
    return Agent(
        config=self.agents_config["researcher"],
        tools=[web_search],  # 附加自定义工具
        allow_delegation=False,
    )
```

### 使用管理器智能体的层级过程

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

### 使用 FastAPI 进行生产部署

```python
# api_server.py — 生产部署
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

# 运行：uvicorn api_server:app --host 0.0.0.0 --port 8000
```

## 基准测试 / 实际用例

### 性能基准测试

![CrewAI 基准测试图表 — 显示多智能体框架间的 token 效率对比，数据来源于 2026 年 5 月的社区基准测试](https://docs.crewai.com/images/crewai-performance-chart.png)

CrewAI 与其他框架在标准多智能体研究任务上的性能对比：

| 指标 | CrewAI | AutoGen | LangGraph | Agno |
|------|--------|---------|-----------|------|
| 首次成功运行所需时间 | ~15 分钟 | ~30 分钟 | ~60 分钟 | ~20 分钟 |
| Token 成本（标准化） | 1.5–2x | 5–6x | 1x 基准 | 1.2x |
| GitHub 星标 (2026年5月) | 51,759 | ~38,000 | ~28,000 | ~15,000 |
| Hello-world 代码行数 | ~20 | ~40 | ~50 | ~25 |
| 内置检查点 | 部分 | 无 | 是 (Postgres/Redis) | 无 |
| 异步支持 | 是 | 是 | 是 | 是 |
| 本地 LLM 支持 (Ollama) | 是 | 是 | 是 | 是 |

### 实际用例

**自动化研究报告：** 一家金融科技初创公司使用 CrewAI 生成每日市场分析报告。研究员智能体抓取财务数据，分析智能体识别趋势，写作智能体生成最终报告 —— 全部在早上 8 点前完成。

**内容生产流水线：** 一家媒体公司运行 4 智能体 crew 来撰写博客文章：研究 → 写作 → 编辑 → SEO 优化。产出从每周 3 篇增加到 12 篇。

**代码审查自动化：** 一家 SaaS 团队使用 CrewAI 分流拉取请求。一个智能体总结变更，另一个检查安全模式，第三个生成审查评论。

## 与流行工具集成

### OpenAI / Anthropic / Google Gemini

CrewAI 使用 LiteLLM 进行提供商无关的模型路由：

```yaml
# agents.yaml — 每个智能体的模型选择
researcher:
  role: Research Analyst
  llm: anthropic/claude-sonnet-4-20250514
  # 或: openai/gpt-4o
  # 或: gemini/gemini-2.0-flash
```

### Ollama（本地 LLM）

```yaml
researcher:
  role: Research Analyst
  llm: ollama/llama3.1
  # 需要：ollama pull llama3.1
```

### LangChain 工具

```python
# 在 CrewAI 中使用 LangChain 工具
from langchain_community.tools import WikipediaQueryRun
from langchain_community.utilities import WikipediaAPIWrapper
from crewai import Agent

wiki_tool = WikipediaQueryRun(api_wrapper=WikipediaAPIWrapper())

agent = Agent(
    role="Researcher",
    goal="Research topics thoroughly",
    tools=[wiki_tool],  # LangChain 工具直接可用
    verbose=True,
)
```

### LlamaIndex（RAG 集成）

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from crewai.tools import tool

@tool("Document Search")
def document_search(query: str) -> str:
    """Search internal documents for relevant information."""
    documents = SimpleDirectoryReader("./docs").load_data()
    index = VectorStoreIndex.from_documents(documents)
    query_engine = index.as_query_engine()
    return str(query_engine.query(query))
```

### Docker 部署

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

## 与替代方案对比

| 特性 | CrewAI | AutoGen | LangGraph | Agno |
|------|--------|---------|-----------|------|
| 编排模型 | 基于角色的 crew | 对话式智能体 | 状态图 | 轻量级智能体 |
| 原型开发速度 | 15 分钟（最快） | 30 分钟 | 60 分钟（最陡） | 20 分钟 |
| Token 效率 | 中等 (1.5–2x) | 最高开销 (5–6x) | 最佳 (1x) | 良好 (1.2x) |
| 生产级检查点 | 部分 + CrewAI+ | 无内置 | 是 (Postgres/Redis) | 无 |
| 可观测性 | CrewAI+（成长中） | 基础 OTEL | LangSmith（深入） | 最小化 |
| 学习曲线 | 低 | 中等 | 陡峭 | 低 |
| 维护者势头 | 活跃 | 维护模式 | 活跃 | 活跃 |
| 最适合 | 快速原型、基于角色的工作流 | 研究、代码编写智能体 | 有状态的生产工作流 | 简单智能体任务 |

## 局限性 / 诚实评估

**CrewAI 不适合的场景：**

1. **复杂状态机：** 如果你的工作流需要带有分支和时间旅行调试的循环图，LangGraph 的显式图模型更合适。

2. **超高量生产：** 与 LangGraph 的完整状态持久化相比，CrewAI 的检查点是部分的。对于每天需要审计追踪的数千次运行，LangGraph 经过了更多生产验证。

3. **Token 敏感预算：** CrewAI 的智能体默认较为冗长。在同等任务上，预计 Token 消耗是 LangGraph 的 1.5–2 倍。中等生产工作负载的预算约为每月 $100–$500。

4. **实时延迟要求：** 多智能体编排增加了固有延迟。一个使用 GPT-4o 的 3 智能体顺序 crew 需要 45–90 秒。不适合亚秒级响应需求。

5. **深度可观测性：** CrewAI+ 提供监控，但 LangSmith 提供更深入的追踪，包括每个节点的 Token 核算和重放功能。

## 常见问题解答

**Q: CrewAI 需要什么 Python 版本？**
A: CrewAI 需要 Python 3.10 至 3.13。不支持 Python 3.9 或更早版本。使用 `pyenv` 在系统上管理多个 Python 版本。

**Q: 如何安装支持本地 LLM 的 CrewAI？**
A: 正常使用 `pip install crewai` 安装，然后单独安装 Ollama。在智能体配置中设置 `llm: ollama/llama3.1`（或你偏好的模型）。本地推理不需要 API 密钥。

**Q: CrewAI 可以使用非 OpenAI 模型吗？**
A: 可以。CrewAI 支持任何 LiteLLM 兼容的模型，包括 Anthropic Claude、Google Gemini、Azure OpenAI、DeepSeek、Mistral 以及通过 Ollama 的本地模型。在智能体配置中使用 `provider/model-name` 格式。

**Q: CrewAI Crews 和 Flows 的区别是什么？**
A: Crews 是通过顺序、层级或并行过程协作完成任务的智能体团队。Flows 是通过条件逻辑、通过 Pydantic 模型进行状态管理和分支来串联多个 crew 的事件驱动工作流。Crews 用于单工作流协作，Flows 用于多阶段流水线。

**Q: 在生产环境中运行 CrewAI crew 的成本是多少？**
A: 对于每天运行 100 次的 3 智能体 crew 使用 GPT-4o，预计 LLM API 成本约为每月 $100–$300。为简单任务使用 GPT-4o-mini 等更便宜的模型可以将成本降低 40–60%。CrewAI 本身是免费开源的（MIT 许可证）。

**Q: 如何调试输出质量不佳的 CrewAI 智能体？**
A: 在智能体上设置 `verbose: true` 以查看其思考过程。使用 `max_iter` 限制推理循环。添加结构化输出模式来强制格式。在每次运行后查看 Token 使用指标。对于持续存在的问题，简化任务描述并验证工具配置。

**Q: CrewAI 对于企业使用是否已具备生产就绪性？**
A: 对于中小规模的生产工作负载，是的。CrewAI+ 增加了托管可观测性和部署功能，起价为每月 $99。对于高容量或需要审计的关键工作负载，考虑将 CrewAI 与自定义检查点配对或评估 LangGraph。

## 结论

CrewAI 提供了从想法到可运行的多智能体系统的最快路径。其基于角色的抽象 —— 具有明确定义角色、目标和背景故事的智能体协作完成任务 —— 与团队的实际工作方式清晰对应。在 30 分钟内，你可以安装 CrewAI、搭建项目、定义智能体和任务，并运行你的第一个 crew。对于生产环境，添加 Flows 进行事件驱动编排，使用 FastAPI 提供 HTTP 端点，使用 Docker 进行部署。

**今天开始的行动项目：**

1. 安装 CrewAI：`pip install crewai`
2. 搭建你的第一个项目：`crewai create crew my_project`
3. 在 `agents.yaml` 中定义 2–3 个具有不同角色的智能体
4. 使用 `crewai run` 运行你的 crew
5. 加入 CrewAI 社区获取支持和高级模式

加入 Telegram 讨论：[加入 dibi8.com 社区](https://t.me/dibi8tech) 获取多智能体 AI 技巧和生产部署策略。



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [CrewAI GitHub 仓库](https://github.com/crewAIInc/crewAI)
- [CrewAI 官方文档](https://docs.crewai.com/en/introduction)
- [CrewAI 快速入门指南](https://docs.crewai.com/en/quickstart)
- [CrewAI Flows 文档](https://docs.crewai.com/en/concepts/flows)
- [CrewAI 工具参考](https://docs.crewai.com/en/concepts/tools)
- [LangGraph vs CrewAI vs AutoGen 对比 2026](https://rightaichoice.com/compare/langgraph-vs-crewai-vs-autogen)
- [CrewAI 多智能体教程 2026](https://tech-insider.org/crewai-tutorial-multi-agent-ai-python-2026/)
- [CrewAI + IBM watsonx 教程](https://github.com/IBM/ibmdotcom-tutorials/blob/main/crew-ai-projects/crewAI-multiagent-retail-example.md)

*披露声明：本文包含联盟链接。如果你点击链接并进行购买，我们可能会获得佣金，无需额外费用。这有助于支持我们独立的技术研究、测试和免费教育内容的创建。所有推荐均基于我们对工具自行评估的结果。*
