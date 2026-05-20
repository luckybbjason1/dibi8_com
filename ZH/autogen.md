---
title: 'AutoGen: 58K+ Stars — 多智能体框架深度对比 CrewAI、LangGraph 2026'
description: 'AutoGen（微软）是一个用于构建多智能体 AI 系统的事件驱动编程框架。兼容 OpenAI、Azure、Ollama、Docker 和 VS Code。涵盖安装、群聊设置、生产加固及与替代方案的诚实对比。'
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
github_repo: 'https://github.com/microsoft/autogen'
stars: 58196
maintainer: 'microsoft'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['AutoGen', '多智能体', '微软', 'LLM框架', '智能体AI', 'Python', 'CrewAI替代品', 'LangGraph替代品']
aliases:
- /zh/posts/autogen/
- /zh/resources/llm-frameworks/autogen-multi-agent-framework/
---

{{</* resource-info */>}}

## 简介

构建单个调用 API 的 AI 智能体很简单。但要协调五个智能体进行辩论、编写代码、在 Docker 中执行，并在卡住时向人类求助 —— 这是大多数团队会碰壁的地方。微软的 AutoGen 诞生于微软研究院，如今在 GitHub 上拥有 **58,196 个 star**，是最早以对话优先架构直面这一问题的框架之一。本 AutoGen 教程将带您完成框架安装、多智能体群聊配置和生产环境部署 —— 然后与 CrewAI、LangGraph 和 OpenAI Agents SDK 进行诚实对比，帮助您为工作负载选择合适的工具。

## 什么是 AutoGen？

AutoGen 是一个用于构建多智能体 AI 应用的开源编程框架。它使开发者能够定义通过结构化对话进行通信的自主智能体，在沙箱环境中执行代码，并与人类操作员协作。该框架具有模型无关性 —— 支持 OpenAI GPT-4、Azure OpenAI、通过 Ollama 的本地模型以及任何 OpenAI 兼容端点。

## AutoGen 的工作原理

AutoGen 的架构分为四个层级：

| 层级 | 用途 | 入口点 |
|------|------|--------|
| **Core** | 智能体消息传递和状态的事件驱动运行时 | `autogen-core` |
| **AgentChat** | 基于 Core 构建的高级对话智能体 | `autogen-agentchat` |
| **Extensions** | 与 OpenAI、Docker、MCP、gRPC 的集成 | `autogen-ext` |
| **Studio** | 无需编写代码即可进行原型设计的 Web UI | `autogenstudio` |

其核心思维模型是智能体之间的消息传递。`AssistantAgent` 生成计划和代码。`UserProxyAgent` 在本地或 Docker 中执行代码并回传输出。`GroupChatManager` 根据选择策略（轮询、自动选择或自定义）在参与者之间路由消息。

![AutoGen 架构](https://raw.githubusercontent.com/microsoft/autogen/main/website/static/img/autogen_agentchat.png)

*图 1：AutoGen AgentChat 高级架构，展示通过 GroupChatManager 通信的智能体。*

![AutoGen 核心层级](https://microsoft.github.io/autogen/stable/assets/images/layer_architecture-4405d9b57d3326304e08e6b8beca3c81.png)

*图 2：AutoGen 的分层架构 — Core 提供事件驱动运行时，AgentChat 添加对话抽象，Extensions 提供工具集成，Studio 提供无代码 UI。*

每个开发者都需要理解的核心概念：

- **智能体（Agent）**：具有 LLM 后端、系统消息和可选工具集的实体。
- **对话（Conversation）**：智能体之间交换的消息序列。
- **群聊（Group Chat）**：由中央路由器管理的多智能体对话。
- **代码执行器（Code Executor）**：沙箱（本地或 Docker），用于安全运行生成的代码。
- **人类参与（Human-in-the-loop）**：系统暂停等待人类批准的内置中断点。

## 安装与设置

AutoGen 需要 **Python 3.10+**。安装路径取决于您需要哪个层级。

### 基础安装（AgentChat）

```bash
# 创建虚拟环境
python -m venv .venv
source .venv/bin/activate

# 安装 AgentChat + OpenAI 扩展
pip install -U "autogen-agentchat" "autogen-ext[openai]"
```

### 完整安装（含所有扩展）

```bash
pip install -U "autogen-agentchat" "autogen-ext[openai,azure,docker,mcp]"
```

### 验证安装

```python
import autogen_agentchat
print(autogen_agentchat.__version__)
```

### 最小 "Hello World" 智能体

```python
import asyncio
from autogen_agentchat.agents import AssistantAgent
from autogen_ext.models.openai import OpenAIChatCompletionClient

async def main() -> None:
    agent = AssistantAgent(
        name="assistant",
        model_client=OpenAIChatCompletionClient(
            model="gpt-4o",
            api_key="YOUR_API_KEY"
        ),
        system_message="You are a helpful assistant."
    )
    result = await agent.run(task="Say 'Hello World!'")
    print(result.messages[-1].content)

asyncio.run(main())
```

运行：

```bash
export OPENAI_API_KEY="sk-..."
python hello_agent.py
```

### Docker 设置（推荐用于生产）

```bash
# 拉取官方镜像
docker pull mcr.microsoft.com/autogen/python:latest

# 使用 API 密钥运行
docker run -it \
  -e OPENAI_API_KEY="$OPENAI_API_KEY" \
  -v "$(pwd)/workspace:/workspace" \
  mcr.microsoft.com/autogen/python:latest
```

## 与流行工具集成

### OpenAI / Azure OpenAI

AutoGen 的 AgentChat 使用 `OpenAIChatCompletionClient` 同时支持 OpenAI 和 Azure 端点：

```python
from autogen_ext.models.openai import OpenAIChatCompletionClient

# 直接连接 OpenAI
openai_client = OpenAIChatCompletionClient(
    model="gpt-4o",
    api_key="sk-..."
)

# Azure OpenAI
azure_client = OpenAIChatCompletionClient(
    model="gpt-4o",
    base_url="https://YOUR_RESOURCE.openai.azure.com/openai/deployments/YOUR_DEPLOYMENT",
    api_key="YOUR_AZURE_KEY",
    api_version="2024-12-01-preview"
)
```

### Ollama（本地模型）

```python
from autogen_ext.models.openai import OpenAIChatCompletionClient

local_client = OpenAIChatCompletionClient(
    model="llama3.1:8b",
    base_url="http://localhost:11434/v1",
    api_key="placeholder",
    model_info={
        "vision": False,
        "function_calling": True,
        "json_output": False,
        "family": "unknown"
    }
)
```

### Docker 代码执行

```python
from autogen_ext.code_executors.docker import DockerCommandLineCodeExecutor
from autogen_agentchat.agents import CodeExecutorAgent

# 创建基于 Docker 的代码执行器
executor = DockerCommandLineCodeExecutor(
    image="python:3.12-slim",
    work_dir="./coding_workspace",
    timeout=60,
    stop_container=True
)

code_agent = CodeExecutorAgent(
    name="code_executor",
    code_executor=executor
)
```

### VS Code 扩展

AutoGen VS Code 扩展为智能体对话提供内联调试：

```bash
# 从应用商店安装（搜索 "AutoGen"）
# 或通过 CLI
code --install-extension microsoft.autogen
```

### 模型上下文协议（MCP）

AutoGen 0.5+ 支持用于工具发现的 MCP 服务器：

```python
from autogen_ext.tools.mcp import McpWorkbench

workbench = McpWorkbench(
    server_params={"command": "npx", "args": ["-y", "@modelcontextprotocol/server-filesystem", "."]}
)

# MCP 服务器的工具对智能体可用
```

## 基准测试 / 实际用例

### 任务完成基准

2026 年独立研究的基准测试显示 AutoGen 在标准智能体任务上的表现：

| 基准测试 | AutoGen | CrewAI | LangGraph | 说明 |
|----------|---------|--------|-----------|------|
| SimpleQA Verified (F1) | 0.62 | **0.71** | 0.68 | CrewAI 最高但慢 55-140% |
| BIRD-SQL (执行 %) | 54.1 | 54.3 | **55.9** | LangGraph 在 NL2SQL 上领先 |
| GAIA (任务完成 %) | 38.0 | N/A | N/A | 通过 Magnetic-One 多智能体团队 |
| WebArena | 32.8 | N/A | N/A | 基于浏览器的网页任务 |
| 复杂推理 (3-5 工具) | 68% | 71% | **76%** | 中等复杂度管道任务 |

来源：[Open Agent Specification Technical Report](https://arxiv.org/html/2510.04173v3)、[Magentic-One Paper](https://arxiv.org/pdf/2411.04468v1)、[Multi-Agent Framework Evaluation](https://arxiv.org/html/2604.16646v1)

![框架间基准对比](https://github.com/microsoft/autogen/raw/main/website/static/img/autogen_app.png)

*图 3：多智能体基准对比 — AutoGen 在对话式研究任务上领先，LangGraph 在结构化生产工作负载上表现出色。*

### 成本与延迟

**每年 10,000 次决策**工作负载的生产成本估算（2026 年社区报告）：

| 框架 | 年预估成本 | 平均延迟（简单） | 平均延迟（复杂） |
|------|-----------|-----------------|-----------------|
| LangGraph | $220–$365 | 180ms | 1.2s |
| CrewAI | $220–$365 | 220ms | 1.5s |
| AutoGen | $1,200–$1,460 | 2.1s | 5.8s |

AutoGen 较高的成本源于其对话模式：每个任务触发 20+ 次 LLM 调用，因为智能体会辩论和迭代，而 LangGraph 的基于图的执行仅需 2–8 次调用。

### AutoGen 的优势场景

AutoGen 在特定场景中优于替代方案：

- **多智能体研究**：具有不同角色的智能体辩论解决方案，捕获单智能体遗漏的错误。一项供应链优化研究显示 AutoGen 比单智能体系统少 3 倍代码和更少的人工干预。
- **迭代代码优化**：Coder + Executor 循环通过连续的错误纠正生成可工作的代码。内置的 Docker 沙箱安全执行 Python。
- **人类参与工作流**：内置支持暂停对话、等待人类输入、恢复 —— 无需外部编排。

## 高级用法 / 生产加固

### 带自定义选择器的群聊

```python
import asyncio
from autogen_agentchat.agents import AssistantAgent
from autogen_agentchat.teams import GroupChat, RoundRobinGroupChat
from autogen_agentchat.conditions import MaxMessageTermination, TextMentionTermination
from autogen_ext.models.openai import OpenAIChatCompletionClient

async def main():
    model_client = OpenAIChatCompletionClient(model="gpt-4o")

    # 定义专业智能体
    researcher = AssistantAgent(
        name="researcher",
        model_client=model_client,
        system_message="You are a research analyst. Gather facts and data."
    )

    writer = AssistantAgent(
        name="writer",
        model_client=model_client,
        system_message="You are a technical writer. Create clear documentation."
    )

    reviewer = AssistantAgent(
        name="reviewer",
        model_client=model_client,
        system_message="You are an editor. Review content for accuracy and clarity. "
                       "Respond with 'APPROVED' when the content is good."
    )

    # 终止条件：20 条消息后或审核者批准时停止
    termination = MaxMessageTermination(max_messages=20) | TextMentionTermination("APPROVED")

    # 轮询群聊
    team = RoundRobinGroupChat(
        participants=[researcher, writer, reviewer],
        termination_condition=termination
    )

    result = await team.run(task="Write a one-paragraph summary of quantum computing.")
    for msg in result.messages:
        print(f"[{msg.source}]: {msg.content[:100]}...")

asyncio.run(main())
```

### 基于选择器的群聊（动态路由）

```python
from autogen_agentchat.teams import SelectorGroupChat
from autogen_agentchat.conditions import MaxMessageTermination

# SelectorGroupChat 使用 LLM 决定下一个发言的智能体
team = SelectorGroupChat(
    participants=[researcher, writer, reviewer],
    model_client=model_client,
    termination_condition=MaxMessageTermination(max_messages=15),
    allow_repeated_speaker=False  # 防止同一智能体连续发言
)
```

### 自定义工具集成

```python
from autogen_core.tools import FunctionTool
from autogen_agentchat.agents import AssistantAgent

def search_knowledge_base(query: str) -> str:
    """Search internal knowledge base."""
    # 您的搜索逻辑
    return f"Results for '{query}': ..."

search_tool = FunctionTool(search_knowledge_base, description="Search company KB")

agent = AssistantAgent(
    name="kb_assistant",
    model_client=model_client,
    tools=[search_tool],
    system_message="Use the search_knowledge_base tool to answer questions."
)
```

### 长时间运行工作流的状态持久化

```python
from autogen_agentchat.teams import GroupChat
from autogen_core import CancellationToken

# 序列化对话状态
state = await team.save_state()

# 保存到 Redis / 数据库
import json
with open("team_state.json", "w") as f:
    json.dump(state, f)

# 之后：恢复并继续
with open("team_state.json") as f:
    state = json.load(f)
await team.load_state(state)
result = await team.run(task="Continue from where we left off.")
```

### 安全：沙箱代码执行

```python
from autogen_ext.code_executors.docker import DockerCommandLineCodeExecutor
import tempfile

# 始终对不受信任的代码使用 Docker
with tempfile.TemporaryDirectory() as work_dir:
    executor = DockerCommandLineCodeExecutor(
        image="python:3.12-slim",
        work_dir=work_dir,
        timeout=30,
        bind_mounts={"src": "/safe", "target": "/workspace"}
    )

    code_executor = CodeExecutorAgent(
        name="sandbox",
        code_executor=executor
    )
    # 智能体在容器内运行所有代码
```

### 使用 OpenTelemetry 监控

```python
from autogen_core import TRACE_LOGGER_NAME
import logging

# 启用 AutoGen 内部追踪
logging.getLogger(TRACE_LOGGER_NAME).setLevel(logging.DEBUG)

# 集成到 OTLP 收集器
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter

tracer = trace.get_tracer("autogen.production")
```

## 与替代方案对比

| 特性 | AutoGen | CrewAI | LangGraph | OpenAI Agents SDK |
|------|---------|--------|-----------|-------------------|
| **GitHub Stars** | 58,196 | ~47,700 | ~30,700 | ~25,500 |
| **架构** | 消息传递 / 对话 | 基于角色的团队 | 有向状态图 | 显式交接 |
| **学习曲线** | 中等 | 低 | 高 | 低 |
| **多智能体模型** | 带选择器的群聊 | 顺序 / 层级 | 图节点 + 边 | 智能体交接 |
| **检查点** | 手动保存/加载 | 有限 | 原生（时间旅行） | 上下文变量 |
| **代码执行** | Docker 沙箱（内置） | 需自定义工具 | 需自定义节点 | 需自定义工具 |
| **人类参与** | 原生支持 | 基础 | 原生（中断） | 基础 |
| **可观测性** | 对话追踪 | CrewAI Observability | LangSmith（原生） | OpenAI 追踪 |
| **模型支持** | 20+ 提供商 | 15+ 提供商 | 80+ 通过 LangChain | 仅 OpenAI |
| **令牌效率** | 20-35% 开销 | 10-18% 开销 | 15-25% 开销 | 5-10% 开销 |
| **生产就绪度** | 中等 | 中高 | 高 | 中高 |
| **最适合** | 研究、辩论、代码生成 | 业务工作流、原型设计 | 有状态生产工作流 | OpenAI 原生应用 |

### AutoGen vs CrewAI

**AutoGen** 将智能体视为对话参与者。智能体辩论、相互质疑结论、迭代解决方案。这使其非常适合研究任务和复杂调试，其中涌现行为有帮助。**CrewAI** 将智能体视为具有角色（"研究员"、"作家"、"编辑"）的员工。任务通过预定义管道流动。CrewAI 设置更快、使用更少令牌，但缺乏 AutoGen 的动态协作。

### AutoGen vs LangGraph

**LangGraph** 提供显式控制：每个节点、边和状态转换都在代码中定义。这种确定性使调试简单并支持带时间旅行的检查点。**AutoGen** 以控制换取灵活性 —— 智能体决定下一个谁发言，创造出涌现行为，可以发现 LangGraph 会遗漏的创造性解决方案。对于需要审计追踪的受监管行业，LangGraph 胜出。对于探索性研究，AutoGen 胜出。

### AutoGen vs OpenAI Agents SDK

**OpenAI Agents SDK** 是供应商锁定的，但与 OpenAI API 深度集成。如果您完全在 GPT-4 上运行且需要最小化设置，这是务实选择。一旦您需要本地模型（通过 Ollama）、Azure OpenAI 故障转移或多模型策略，AutoGen 的模型无关设计就会回报。

## 局限性 / 诚实评估

AutoGen 不是每个工作的正确工具。以下是它不擅长的：

1. **高吞吐量生产 API**：对话模式每次任务生成 20+ 次 LLM 调用。在 1,000 请求/分钟时，您的 LLM 费用和延迟将不可接受。对事务性工作负载使用 LangGraph。

2. **简单线性管道**：如果您的工作流是 "A 做步骤 1，B 做步骤 2，C 做步骤 3" 且无需回溯，CrewAI 的 `Process.sequential` 更简单更便宜。

3. **非 Python 团队**：虽然 AutoGen 有 .NET 移植版，但生态系统是 Python 优先的。TypeScript 和 Java 团队会发现 LangGraph（JS 支持）或 Semantic Kernel（.NET）更自然。

4. **严格合规要求**：AutoGen 缺乏相当于 LangSmith 时间旅行调试的内置审计追踪。您必须实现自己的日志和回放基础设施。

5. **维护模式考虑**：微软已将主要开发转向 **Microsoft Agent Framework 1.0**（2026 年 4 月 GA）。AutoGen 本身仍处于维护模式 —— 错误修复和安全补丁继续，但主要新功能转向 MAF。对于新项目，请同时评估 MAF 和 AutoGen。

## 常见问题解答

**Q：AutoGen 和 Microsoft Agent Framework 有什么区别？**

Microsoft Agent Framework (MAF) 是 AutoGen 的下一代演进，于 2026 年 4 月 GA。AutoGen 保持开源和 MIT 许可；MAF 添加企业功能、Azure 原生集成和基于图的工作流。AutoGen 仍适合研究和实验。对于新生产部署，请同时评估两者。

**Q：如何使用 Llama 或 Mistral 等本地模型运行 AutoGen？**

使用 Ollama 或任何 OpenAI 兼容的本地服务器。在 `OpenAIChatCompletionClient` 中将 `base_url` 设置为本地端点（例如 `http://localhost:11434/v1`）。提供 `model_info` 字典，让 AutoGen 知道模型的能力（视觉、函数调用、JSON 输出）。

**Q：AutoGen 智能体能安全执行代码吗？**

可以，通过 `DockerCommandLineCodeExecutor`。所有生成的代码在 Docker 容器中运行，具有可配置的超时和绑定挂载。切勿在生产中对不受信任的 LLM 生成代码使用 `LocalCommandLineCodeExecutor`。

**Q：GroupChat 中可以放多少个智能体？**

实际限制是 5–8 个。超过这个数量，对话选择器难以高效路由，令牌使用爆炸，延迟变得令人望而却步。对于更大的系统，拆分为多个 GroupChat 并层次化组合。

**Q：AutoGen 支持流式响应吗？**

是的，AgentChat 通过 `run_stream()` 支持流式：

```python
async for message in team.run_stream(task="Explain Kubernetes"):
    if message.source == "assistant":
        print(message.content, end="", flush=True)
```

流式是每消息级别（非每令牌），所以粒度比原始 OpenAI 流式更粗。

**Q：如何调试出问题的多智能体对话？**

启用详细日志并保存对话状态：

```python
# 打印每条消息
team = RoundRobinGroupChat(
    participants=[agent1, agent2],
    termination_condition=termination
)
result = await team.run(task="Debug task", max_turns=10)
for msg in result.messages:
    print(f"{msg.source} -> {msg.content[:200]}")
```

## 结论

AutoGen 通过解决一个难题赢得了 58,196 颗星：使多个 AI 智能体能够通过自然对话协作。其消息传递架构、内置 Docker 沙箱和原生人类参与支持，使其成为研究任务、迭代代码生成和工作流的 strongest 选择 —— 在这些场景中，智能体涌现的辩论比刚性管道产生更好的结果。

同样的灵活性在生产规模上变成了负担。每次任务 20+ 次 LLM 调用、有限的检查点和维护模式状态意味着 2026 年的大多数企业团队在将 AutoGen 用于关键任务系统之前，应评估 LangGraph（用于有状态工作流）或 CrewAI（用于基于角色的自动化）。

**行动项：**

1. 使用 `pip install "autogen-agentchat" "autogen-ext[openai]"` 安装 AutoGen AgentChat
2. 使用上面的代码示例为您的用例构建 3 智能体 GroupChat
3. 使用相同提示测量与 LangGraph 和 CrewAI 的令牌使用和延迟
4. 加入 [AutoGen Discord](https://aka.ms/autogen-discord) 获取社区支持
5. 关注 dibi8.com Telegram 群组获取每周 AI 工程深度内容



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [AutoGen 官方文档](https://microsoft.github.io/autogen/stable/)
- [AutoGen GitHub 仓库](https://github.com/microsoft/autogen)
- [AutoGen AgentChat API 参考](https://microsoft.github.io/autogen/stable/reference/python/autogen_agentchat.html)
- [Magentic-One：AutoGen 的通用多智能体系统](https://arxiv.org/pdf/2411.04468v1)
- [Open Agent Specification 基准结果](https://arxiv.org/html/2510.04173v3)
- [多智能体框架评估研究](https://arxiv.org/html/2604.16646v1)
- [CrewAI 文档](https://docs.crewai.com/)
- [LangGraph 文档](https://langchain-ai.github.io/langgraph/)
- [OpenAI Agents SDK 文档](https://platform.openai.com/docs/guides/agents)
- [AutoGen vs CrewAI：2026 基准指南](https://dev.to/kunpeng-ai-2026/autogen-vs-crewai-a-comprehensive-benchmark-and-selection-guide-for-2026-2nh1)
