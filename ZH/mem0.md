---
title: 'Mem0: 56K+ Stars — AI智能体内存性能调优指南 2026'
description: 'Mem0 (mem0ai) 是面向 AI 智能体的通用记忆层。兼容 Claude Code、OpenAI、LangChain、CrewAI、Cursor。涵盖 mem0 教程、持久化记忆设置、向量存储调优和生产部署基准测试。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/mem0ai/mem0'
stars: 56205
maintainer: 'mem0ai'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['mem0', 'ai-agent-memory', '持久化记忆', 'langchain', '向量存储', '内存调优', 'mem0教程', 'mem0-vs-langchain', 'crewai', '开源']
aliases:
- /zh/posts/mem0/
---

{{</* resource-info */>}}

## 引言

每位 AI 智能体开发者都会撞上同一堵墙：智能体失忆。用户在一个会话中告诉聊天机器人自己是素食者且对坚果过敏，两小时后智能体却推荐花生咖喱。这不是提示工程的问题——这是记忆架构的问题。无状态的 LLM 没有内置机制来跨会话持久化事实。Mem0 (mem0ai/mem0) 通过一个即插即用的记忆层解决了这个问题，获得 56,205+ GitHub Stars，90,000+ 开发者采用。本指南涵盖从安装到生产级调优的完整 mem0 设置流程，包含真实基准测试、向量存储配置，以及与 LangChain、CrewAI 和 OpenAI 智能体的集成代码。

## Mem0 是什么？

Mem0 是一款面向 LLM 应用和 AI 智能体的开源通用记忆层。它采用混合架构，结合向量相似度搜索与结构化记忆提取，跨对话提取、存储和检索用户特定的事实。系统会自动将原始聊天消息提炼成语义事实（"用户是素食者"），去重后并在推理时返回最相关的记忆——全部通过 REST API 或 Python/TypeScript SDK 完成。

## Mem0 的工作原理

Mem0 的架构将记忆分为四个操作层：

**1. 提取层**：一个 LLM（可配置，默认 GPT-4o-mini）处理传入消息并提取结构化事实。2026 年 4 月发布的 token 高效算法采用单遍层次提取，相比全上下文基线 token 用量减少 3-4 倍。

**2. 嵌入层**：提取的事实使用嵌入模型（默认：text-embedding-3-small）向量化后存储到向量数据库。Mem0 支持 19 种向量存储后端，包括 Qdrant、Chroma、PGVector、Pinecone、Weaviate、Milvus 和 Azure AI Search。

**3. 检索层**：查询时，Mem0 执行混合检索，结合向量相似度、元数据过滤、重排序和多信号评分。多信号检索综合考虑时效性、相关性和重要性来返回最优记忆。

**4. 图层（Pro 版）**：超越平面向量存储，Mem0 Pro 构建知识图谱，理解实体关系——支持多跳推理（"James 和谁一起工作？"需要连接 "James 在 TechCorp 工作" + "Sarah 在 TechCorp 工作"）。

```
┌──────────────────────────────────────────────────────┐
│                    用户消息                           │
└──────────────────────┬───────────────────────────────┘
                       │
          ┌────────────▼────────────┐
          │   提取层 (LLM)           │  ← 提取事实
          └────────────┬────────────┘
                       │
          ┌────────────▼────────────┐
          │   嵌入模型               │  ← 向量化
          └────────────┬────────────┘
                       │
          ┌────────────▼────────────┐
          │   向量存储               │  ← Qdrant/Chroma/PGVector
          └────────────┬────────────┘
                       │
          ┌────────────▼────────────┐
          │   混合检索               │  ← 搜索 + 重排序
          └────────────┬────────────┘
                       │
          ┌────────────▼────────────┐
          │   注入提示词             │  ← 上下文增强
          └─────────────────────────┘
```

## 安装与设置

### 云端设置（最快路径）

```bash
# 安装 Python 客户端
pip install mem0ai

# 设置 API 密钥（从 https://app.mem0.ai 获取）
export MEM0_API_KEY="m0-your-key-here"
```

```python
# mem0_quickstart.py
import os
from mem0 import MemoryClient

client = MemoryClient(api_key=os.getenv("MEM0_API_KEY"))

# 从对话中存储记忆
messages = [
    {"role": "user", "content": "I'm a vegetarian and allergic to nuts."},
    {"role": "assistant", "content": "Got it! I'll remember your dietary preferences."},
]
client.add(messages, user_id="user123")

# 检索相关记忆
results = client.search(
    "What are my dietary restrictions?",
    user_id="user123"
)
print(results)
```

### 自托管设置（Docker）

适合需要数据驻留或离线部署的团队：

```bash
# 克隆仓库
git clone https://github.com/mem0ai/mem0.git
cd mem0

# 使用 Docker 启动
make bootstrap
# 创建管理员用户，生成 API 密钥，启动服务器和管理面板
```

```yaml
# docker-compose.yml 生产环境配置
docker run -d \
  -p 8000:8000 \
  -e MEM0_API_KEY=your-admin-key \
  -e VECTOR_STORE_PROVIDER=qdrant \
  -e VECTOR_STORE_URL=http://qdrant:6333 \
  -e LLM_PROVIDER=openai \
  -e OPENAI_API_KEY=$OPENAI_API_KEY \
  mem0/mem0-server:latest
```

### 开源 SDK（本地）

```bash
pip install mem0ai openai chromadb
```

```python
from mem0 import Memory

# 使用自定义向量存储初始化
m = Memory()

# 添加对话
messages = [
    {"role": "user", "content": "I'm planning to watch a movie tonight."},
    {"role": "assistant", "content": "How about thrillers?"},
    {"role": "user", "content": "I love sci-fi but hate horror."},
]
m.add(messages, user_id="alice", metadata={"category": "movies"})

# 使用元数据过滤搜索
results = m.search("movie recommendations", filters={"user_id": "alice"})
```

## 内存配置与性能调优

### 使用 YAML 自定义配置

`mem0config.yaml` 文件控制记忆流水线的每个组件：

```yaml
# mem0config.yaml — 生产级调优配置
llm:
  provider: openai
  config:
    model: "gpt-4o-mini"
    temperature: 0.1
    max_tokens: 2000

embedder:
  provider: openai
  config:
    model: "text-embedding-3-small"
    embedding_dims: 1536

vector_store:
  provider: qdrant
  config:
    host: "localhost"
    port: 6333
    collection_name: "mem0"
    on_disk: true  # 启用持久化存储

reranker:
  provider: cohere
  config:
    model: "rerank-multilingual-v3.0"

custom_instructions: |
  提取用户偏好、个人事实和上下文。
  重点关注饮食限制、过敏和技术偏好。
  忽略临时状态和一次性请求。
```

```python
from mem0 import Memory

# 加载自定义配置
config_path = "mem0config.yaml"
m = Memory.from_config(config_path)
```

### 向量存储后端对比

| 后端 | 适用场景 | 延迟 | 持久化 | 扩展性 |
|------|----------|------|--------|--------|
| Qdrant | 生产环境、混合搜索 | <10ms | 磁盘 | 水平扩展 |
| Chroma | 本地开发、原型设计 | <20ms | 文件 | 单节点 |
| PGVector | PostgreSQL 生态 | <30ms | 数据库管理 | 读副本 |
| Pinecone | 无服务器、托管 | <15ms | 云 | 自动扩展 |
| Milvus | 十亿级规模 | <20ms | 分布式 | 分片 |

### 性能调优清单

```python
# 1. 为高吞吐量应用启用异步记忆
from mem0 import MemoryClient
import asyncio

client = MemoryClient()

async def batch_store(messages_list):
    tasks = [client.add_async(msgs, user_id=f"user_{i}")
             for i, msgs in enumerate(messages_list)]
    return await asyncio.gather(*tasks)

# 2. 使用元数据过滤限定搜索范围
results = client.search(
    "project updates",
    filters={
        "user_id": "alice",
        "metadata.category": "work"
    },
    limit=10
)

# 3. 使用 top_k 调整检索深度
results = client.search(
    "dietary preferences",
    user_id="alice",
    top_k=5,  # 减少提升速度，增加提升覆盖度
    rerank=True
)
```

### 带自定义指令的记忆

```python
# 引导提取和存储哪些事实
m = Memory.from_config({
    "custom_instructions": """
    提取并存储：
    - 用户的姓名、职业、地点
    - 技术偏好（语言、框架、工具）
    - 饮食限制和过敏
    - 沟通偏好

    不要存储：
    - 临时情绪或情感状态
    - 一次性请求
    - 未经同意的第三方信息
    """
})
```

## 与 LangChain、CrewAI 和 OpenAI 集成

### LangChain 集成

```bash
pip install langchain langchain-openai mem0ai
```

```python
# langchain_mem0_agent.py
import os
from typing import List, Dict
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage, AIMessage
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from mem0 import MemoryClient

# 初始化
llm = ChatOpenAI(model="gpt-4o-mini")
mem0 = MemoryClient(api_key=os.getenv("MEM0_API_KEY"))

# 带记忆注入的提示词模板
prompt = ChatPromptTemplate.from_messages([
    ("system", """你是拥有长期记忆的助手。
    关于用户的相关历史上下文：
    {memories}

    使用这些上下文来个性化你的回答。"""),
    MessagesPlaceholder(variable_name="history"),
    ("human", "{input}")
])

def get_memories(user_id: str, query: str) -> str:
    """检索相关记忆并格式化为字符串。"""
    results = mem0.search(query, user_id=user_id, limit=5)
    return "\n".join([r["memory"] for r in results])

def chat(user_id: str, message: str, history: List = None):
    """带记忆增强上下文的对话。"""
    if history is None:
        history = []

    memories = get_memories(user_id, message)
    formatted_prompt = prompt.format_messages(
        memories=memories,
        history=history,
        input=message
    )

    response = llm.invoke(formatted_prompt)

    # 存储交互
    messages = [
        {"role": "user", "content": message},
        {"role": "assistant", "content": response.content}
    ]
    mem0.add(messages, user_id=user_id)

    return response.content

# 运行对话
user_id = "traveler_42"
response1 = chat(user_id, "I'm planning a trip to Tokyo next month.")
print(response1)

# 后续会话 — 智能体记住了
response2 = chat(user_id, "What should I pack for my trip?")
# 输出引用东京、时间以及旅行者的偏好
```

### CrewAI 集成

```bash
pip install crewai mem0ai
```

```python
# crewai_mem0_crew.py
import os
from crewai import Agent, Task, Crew
from crewai_tools import tool
from mem0 import MemoryClient

mem0 = MemoryClient(api_key=os.getenv("MEM0_API_KEY"))

@tool
def retrieve_user_context(user_id: str, query: str) -> str:
    """检索关于用户的记忆用于个性化。"""
    results = mem0.search(query, user_id=user_id, limit=5)
    return "\n".join([f"- {r['memory']}" for r in results])

@tool
def store_interaction(user_id: str, content: str) -> str:
    """存储智能体交互中学到的事实。"""
    messages = [{"role": "assistant", "content": content}]
    mem0.add(messages, user_id=user_id)
    return "Stored."

# 定义带有记忆工具的智能体
researcher = Agent(
    role="Personal Researcher",
    goal="Provide personalized research based on user history",
    backstory="You remember user preferences and tailor research accordingly.",
    tools=[retrieve_user_context, store_interaction],
    verbose=True,
    memory=True
)

# 使用记忆的任务
task = Task(
    description="""Research travel options for user {{user_id}}.
    First retrieve their preferences, then provide personalized recommendations.
    Query: travel preferences""",
    expected_output="Personalized travel recommendations",
    agent=researcher
)

crew = Crew(agents=[researcher], tasks=[task])
result = crew.kickoff(inputs={"user_id": "user123"})
print(result)
```

### OpenAI Agents SDK 集成

```bash
pip install openai-agents mem0ai
```

```python
# openai_agents_mem0.py
import os
from dataclasses import dataclass
from agents import Agent, Runner, function_tool
from mem0 import MemoryClient

mem0 = MemoryClient(api_key=os.getenv("MEM0_API_KEY"))

@dataclass
class UserContext:
    user_id: str

@function_tool
def add_to_memory(ctx, messages: str) -> str:
    """存储关于用户的事实。"""
    parsed = [{"role": "user", "content": m} for m in messages.split("\n")]
    mem0.add(parsed, user_id=ctx.context.user_id)
    return "Memory stored."

@function_tool
def search_memory(ctx, query: str) -> str:
    """搜索相关记忆。"""
    results = mem0.search(query, user_id=ctx.context.user_id, limit=5)
    return "\n".join([r["memory"] for r in results])

memory_agent = Agent(
    name="MemoryAgent",
    instructions="You are a helpful assistant that remembers user preferences.",
    tools=[add_to_memory, search_memory],
    model="gpt-4o-mini"
)

async def run_agent():
    context = UserContext(user_id="user_42")
    result = await Runner.run(
        memory_agent,
        "I'm a vegetarian who loves Italian food.",
        context=context
    )
    print(result.final_output)

# asyncio.run(run_agent())
```

### Docker Compose 生产级部署

```yaml
# mem0-production-stack.yml
version: "3.8"

services:
  qdrant:
    image: qdrant/qdrant:latest
    ports:
      - "6333:6333"
      - "6334:6334"
    volumes:
      - qdrant_storage:/qdrant/storage
    environment:
      - QDRANT__SERVICE__GRPC_PORT=6334

  mem0-server:
    image: mem0/mem0-server:latest
    ports:
      - "8000:8000"
    environment:
      - MEM0_API_KEY=${MEM0_API_KEY}
      - VECTOR_STORE_PROVIDER=qdrant
      - VECTOR_STORE_URL=http://qdrant:6333
      - LLM_PROVIDER=openai
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - EMBEDDER_PROVIDER=openai
      - OPENAI_EMBEDDING_MODEL=text-embedding-3-small
    depends_on:
      - qdrant

  mem0-dashboard:
    image: mem0/mem0-dashboard:latest
    ports:
      - "3000:3000"
    environment:
      - MEM0_API_URL=http://mem0-server:8000
      - MEM0_API_KEY=${MEM0_API_KEY}

volumes:
  qdrant_storage:
```

## 基准测试 / 实际用例

### LoCoMo 和 LongMemEval 结果

Mem0 的新型 token 高效算法（2026 年 4 月发布）在更低 token 成本下实现显著精度提升：

| 基准测试 | 指标 | 旧算法 | 新算法（2026年4月） | 提升 |
|----------|------|--------|---------------------|------|
| LoCoMo | 总体准确率 | 66.9% | **92.5%** | +25.6 个百分点 |
| LoCoMo | 平均 Token/查询 | ~26,000 | **6,956** | 3.7 倍减少 |
| LongMemEval | 总体准确率 | 65.3% | **94.4%** | +29.1 个百分点 |
| LongMemEval | 平均 Token/查询 | ~25,000 | **6,787** | 3.7 倍减少 |
| BEAM (1M) | 准确率 | 42.5% | **64.1%** | +21.6 个百分点 |
| BEAM (10M) | 准确率 | 30.2% | **48.6%** | +18.4 个百分点 |

### 分类别细分（LoCoMo）

| 类别 | 旧分数 | 新分数 | 增量 |
|------|--------|--------|------|
| 单跳 | 76.6% | 94.6% | +18.0 |
| 多跳 | 70.2% | 95.4% | +25.2 |
| 开放域 | 57.3% | 82.3% | +25.0 |
| 时间性 | 63.2% | 92.5% | +29.3 |

### 生产用例

**用例：客户支持智能体**
- 公司：50K+ 用户的 SaaS 平台
- 配置：Mem0 OSS + Qdrant + GPT-4o-mini
- 成果：重复问题减少 40%，解决速度提升 25%
- 记忆存储：180K 对话中 2.3M 条事实

**用例：AI 编程助手**
- 配置：Claude Code 的 Mem0 插件
- 成果：智能体记住编码偏好（tab vs 空格、偏好库）、项目结构上下文
- 关键特性：无需重新索引即可实现跨会话文件上下文

**用例：医疗预约机器人**
- 配置：Mem0 企业版（HIPAA 合规）
- 成果：持久化的患者偏好、预约历史、保险验证状态
- 合规：SOC 2 Type I + HIPAA BAA

## 高级用法 / 生产加固

### 安全配置

```python
# 使用元数据进行记忆访问控制
def store_sensitive_memory(user_id: str, fact: str, classification: str):
    """存储带安全等级的记忆。"""
    messages = [{"role": "user", "content": fact}]
    mem0.add(
        messages,
        user_id=user_id,
        metadata={
            "classification": classification,  # "public", "internal", "confidential"
            "encrypted": True,
            "retention_days": 90
        }
    )

# 带分类过滤的搜索
results = client.search(
    "project preferences",
    filters={
        "user_id": "alice",
        "metadata.classification": ["public", "internal"]
    }
)
```

### 多租户隔离

```python
# 面向 SaaS 应用的组织级记忆隔离
def add_org_scoped_memory(org_id: str, user_id: str, messages: list):
    """存储同时按组织和用户范围隔离的记忆。"""
    client.add(
        messages,
        user_id=f"{org_id}:{user_id}",
        metadata={"org_id": org_id, "isolation": "org-scoped"}
    )

# 管理员跨用户查询组织内所有记忆
results = client.get_all(
    filters={"metadata.org_id": "org_123"},
    limit=100
)
```

### 记忆监控与可观测性

```python
# 追踪记忆指标
import time

def timed_search(user_id: str, query: str):
    """带延迟日志的搜索。"""
    start = time.time()
    results = client.search(query, user_id=user_id)
    latency = (time.time() - start) * 1000

    print(f"搜索延迟: {latency:.1f}ms | 结果数: {len(results)}")

    # 记录到你的监控系统
    # prometheus_histogram.observe(latency)
    return results

# 定期记忆健康检查
def memory_health_check(user_id: str):
    """验证用户记忆的完整性。"""
    all_memories = client.get_all(filters={"user_id": user_id})

    return {
        "total_memories": len(all_memories),
        "oldest_memory": min(m["created_at"] for m in all_memories) if all_memories else None,
        "categories": len(set(m.get("metadata", {}).get("category", "") for m in all_memories)),
        "avg_score": sum(m.get("score", 0) for m in all_memories) / len(all_memories) if all_memories else 0
    }
```

### 速率限制与成本控制

```python
# 客户端速率限制实现
from functools import wraps
import time

class Mem0RateLimiter:
    """Mem0 API 调用的简单速率限制器。"""
    def __init__(self, max_calls_per_minute=100):
        self.max_calls = max_calls_per_minute
        self.calls = []

    def can_call(self) -> bool:
        now = time.time()
        self.calls = [c for c in self.calls if now - c < 60]
        return len(self.calls) < self.max_calls

    def record_call(self):
        self.calls.append(time.time())

limiter = Mem0RateLimiter(max_calls_per_minute=60)

def rate_limited_add(messages, user_id):
    if not limiter.can_call():
        # 稍后排队或跳过非关键记忆
        print("触发速率限制，记忆入队")
        return {"status": "queued"}
    limiter.record_call()
    return client.add(messages, user_id=user_id)
```

## 与替代品对比

| 特性 | Mem0 | LangChain Memory | LlamaIndex Memory | Chroma（原始） |
|------|------|------------------|-------------------|---------------|
| **架构** | 混合 向量+图+KV | 键值+向量 | 向量+索引 | 纯向量数据库 |
| **GitHub Stars** | 56,205 | 100K+ (LangChain) | 41,000 | 18,500 |
| **LOCOMO 分数** | 92.5%（新算法） | 58.10% | 62.47% | N/A（仅存储） |
| **LongMemEval 分数** | 94.4% | 49.0% | 52.9% | N/A |
| **图记忆** | Pro 版 ($249/月) | 无 | 部分 | 无 |
| **托管服务** | 是 (app.mem0.ai) | 否 | 否 | 否 |
| **自托管** | Docker，完整栈 | 仅库 | 仅库 | Docker |
| **SOC 2 / HIPAA** | 是 (企业版) | 否 | 否 | 否 |
| **向量后端** | 19 种支持 | 10+ | 15+ | 仅自身 |
| **多智能体共享** | 是 (OSS) | 有限 | 否 | 手动 |
| **入门定价** | 免费 (10K 记忆) | 免费 (OSS) | 免费 (OSS) | 免费 (OSS) |
| **时间推理** | 良好 (82.3% 开放域) | 有限 | 基础 | 无 |
| **LLM 提取** | 自动事实提取 | 手动/摘要 | 手动 | 无 |
| **集成范围** | 20+ 框架 | LangChain 原生 | LlamaIndex 原生 | 任意 |

### 选择建议

- **选择 Mem0**：当你需要托管记忆服务，支持自动事实提取，广泛的框架支持，以及生产级合规。
- **选择 LangChain Memory**：当你完全使用 LangGraph，希望零额外基础设施，并需要过程记忆支持。
- **选择 LlamaIndex Memory**：当你的主要需求是以文档为中心的 RAG 配合记忆增强，而非对话持久化。
- **选择 Chroma**：当你仅需要向量数据库并计划自行构建所有记忆逻辑。

## 局限性 / 诚实评估

Mem0 并非适合所有用例。以下是它不太擅长的领域：

**1. 时间推理差距**：在 LongMemEval 时间性子任务上，Mem0 得分 49-82%（视类别而定）。Zep 配合 Graphiti 由于显式时间锚定图存储，在时间任务上达到 63.8-71.2%。如果你的智能体需要推理事件序列（"X 之前发生了什么？"），Mem0 可能不足。

**2. 图记忆定价**：图功能锁定在 $249/月的 Pro 版。$19/月的 Starter 版仅提供向量相似度搜索。对于预算有限但需要关系感知记忆的团队，Zep（$25/月）或 Cognee（免费自托管）等替代品提供更低价位的图功能。

**3. 有损提取**：Mem0 从对话中提取结构化事实，这意味着会丢失一些细节——说话者归属、精确时间戳和中间推理步骤可能被丢弃。对于逐字对话回忆，原始 RAG 存储消息的方式优于 Mem0（逐字回忆基准上 61.4% vs 86%+）。

**4. 不是完整的智能体框架**：Mem0 是记忆层，不是智能体编排框架。你仍然需要 LangChain、CrewAI 或 OpenAI Agents SDK 进行工具调用、规划和多步推理。

**5. 自托管复杂性**：Docker 设置简单，但生产级自托管需要管理向量存储（Qdrant/Chroma）、LLM API 密钥、嵌入流水线和监控。托管平台消除了这个负担，但引入了数据驻留顾虑。

## 常见问题

**Q: Mem0 Platform 和 Mem0 Open Source 有什么区别？**

A: Mem0 Platform (app.mem0.ai) 是托管云服务，提供自动扩展、仪表板分析和 SOC 2 合规。Mem0 Open Source 是自托管版本，让你完全控制数据和基础设施。OSS 版本拥有相同的核心记忆引擎，但需要你自己管理向量存储、LLM 提供者和扩展。

**Q: mem0 与 langchain memory 在生产环境中如何选择？**

A: LangChain Memory (LangMem) 免费且原生集成 LangGraph，但缺乏托管服务、自动事实提取和企业合规认证。Mem0 提供跨任何框架的独立 API，支持自动记忆提取，企业版提供 SOC 2/HIPAA 合规。如果你不是专门使用 LangGraph，Mem0 是更灵活的选择。

**Q: 能否在不发送数据到外部 API 的情况下使用 Mem0？**

A: 可以。Mem0 Open Source 支持完全本地部署，使用 Ollama 进行 LLM 推理，以及本地向量存储如 Chroma 或 Qdrant。将 LLM 提供者配置为 "ollama" 搭配本地模型（如 llama3），嵌入器使用本地 sentence-transformers 模型。数据不会离开你的网络。

**Q: 生产环境应使用什么向量存储？**

A: Qdrant 是生产部署的推荐选择，因为它具备混合搜索能力（稠密+稀疏向量）、水平扩展支持和亚 10ms 查询延迟。如果已运行 PostgreSQL，PGVector 是理想选择。Pinecone 适合需要自动扩展且无需运维开销的无服务器部署。

**Q: 如何从 LangChain Memory 迁移到 Mem0？**

A: 迁移是渐进的。首先在现有 LangChain 记忆旁初始化 Mem0。在两个系统中同时存储新对话。使用 Mem0 的 `search()` API 检索记忆并通过 `memories` 变量注入 LangChain 提示词。建立信心后，完全切换到 Mem0。Mem0 文档提供了迁移指南。

**Q: Mem0 的大规模使用定价如何？**

A: Hobby 版免费，每月 10K 记忆和 1K 检索。Starter 版 $19/月，50K 记忆和 5K 检索。Pro 版 $249/月，无限记忆、图记忆和分析。Enterprise 版定制定价，包含本地部署、SSO 和 SLA 保证。从 Starter 到 Pro 的跃升是需要图功能的团队的主要定价顾虑。

**Q: Mem0 是否支持多模态记忆（图像、音频）？**

A: 是，Mem0 Open Source 支持多模态输入，包括图像和音频文件。多模态功能从非文本内容中提取语义信息并存储为可检索的记忆条目。这需要 GPT-4o 或 Claude 3.5 Sonnet 等多模态 LLM。

## 结论

Mem0 解决了 AI 智能体开发中最持久的问题之一：跨会话记忆。凭借 56,205 GitHub Stars、19 种向量存储后端，以及新型 token 高效算法（在 LoCoMo 上达到 92.5%，token 成本比全上下文基线低 3.7 倍），它是生产环境中采用最广泛的开源记忆层。免费版可处理 10K 记忆用于原型设计，自托管 Docker 栈为企业部署提供完整的数据控制权。

**行动项：**

1. 克隆 mem0ai/mem0 仓库，使用 `pip install mem0ai` 运行快速入门
2. 在 app.mem0.ai 注册免费 API 密钥
3. 将 Mem0 搜索集成到你的 LangChain 或 CrewAI 智能体提示词中
4. 在你自己的对话数据集上，将当前记忆解决方案与 Mem0 的检索进行基准对比

**加入社区：** [t.me/dibi8community](https://t.me/dibi8community) — 分享你的 Mem0 部署经验，并从其他构建记忆驱动智能体的开发者那里获取帮助。

*本文中的部分链接为联盟链接。如果你通过这些链接购买，我们可能会获得佣金，不会额外收取费用。这有助于我们维护 dibi8.com 并资助开源研究。*



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- Mem0 官方文档: https://docs.mem0.ai/introduction
- Mem0 GitHub 仓库: https://github.com/mem0ai/mem0
- Mem0 研究 — 基准测试: https://mem0.ai/research
- LangChain 集成指南: https://docs.mem0.ai/integrations/langchain
- CrewAI 集成: https://docs.mem0.ai/integrations/crewai
- OpenAI Agents SDK 集成: https://docs.mem0.ai/integrations/openai-agents-sdk
- Mem0 平台定价: https://mem0.ai/pricing
- LoCoMo 基准论文: https://arxiv.org/abs/2402.03771
- LongMemEval 基准: https://github.com/memory-benchmark/LongMemEval
- PRISM 论文（帕累托高效检索）: https://arxiv.org/html/2605.12260v1
- AWS Agent SDK + Mem0 公告: https://aws.amazon.com/blogs/machine-learning
- Atlan — 2026 最佳 AI 智能体记忆框架: https://atlan.com/know/best-ai-agent-memory-frameworks-2026/
- Evermind — Mem0 替代品 2026: https://evermind.ai/blogs/mem0-alternative
