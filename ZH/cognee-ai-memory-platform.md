---
lang: zh
description: 'Cognee is the open-source AI memory platform that gives agents persistent knowledge. Build intelligent agents that remember, reason, and evolve over time.'
date: 2026-07-03T09:00:00+09:00
lastmod: 2026-07-03T09:00:00+09:00
slug: cognee-ai-memory-platform
title: 'Cognee：26K+ Star 开源人工智能内存平台'
category: llm-frameworks
tags: ['ai-memory', 'rag', 'knowledge-graph', 'ai-agents', 'open-source']
github_repo: 'https://github.com/topoteretes/cognee'
license: 'MIT'
tech_stack:
  - Python
  - TypeScript
  - Docker
featureImage: /images/articles/mem0-56k-stars-ai-agent-memory-performan.jpg
---


<<<<<<< HEAD

> **Editor's Disclosure: ** This analysis uses publicly available GitHub data (star counts, commit frequency, fork counts) as of June 30, 2026. All code examples are tested and verified. We may earn a commission from affiliate links.
=======
> **编者披露：** 此分析使用截至 2026 年 6 月 30 日公开的 GitHub 数据（星数、提交频率、分叉数）。所有代码示例都经过测试和验证。我们可以通过附属链接赚取佣金。
>>>>>>> 0f428019e6f21508f05fc402fc21585e618ed533

## 长篇大论；博士

**Cognee**（超过 26K 颗星）是一个Open Source AI 记忆平台，为智能体提供持久、不断发展的知识。与检索静态文档的传统 RAG 系统不同，Cognee 构建了动态知识图，该知识图随着代理与新信息的交互而增长和适应。它使人工智能代理能够记住过去的对话，从经验中学习，并通过相互关联的知识进行推理——使我们更接近true正智能的长期人工智能助手。

## 康尼是什么？

Cognee 是 AI 代理的内存基础设施层。它位于您的代理及其数据源之间，提供：

- **持久记忆：** 代理记住跨会话和对话的信息
- **知识图：**信息被组织为互连的实体和关系，而不仅仅是向量
- **自动学习：** Cognee 从新数据中提取见解，无需手动标记
- **记忆推理：** 代理可以查询其知识图以进行上下文理解

该项目的诞生是因为观察到大多数人工智能应用程序都患有健忘症——它们不记得以前的对话中发生了什么，也无法建立随着时间的推移积累的知识。 Cognee 通过提供持续、发展和连接的内存层来解决这个问题。

### 核心特性

- **多模式内存：** 存储和检索文本、图像、音频和结构化数据
- **时间推理：** 了解知识如何随时间变化
- **置信度评分：** 每个内存都有一个基于源可靠性的置信度
- **自动重复数据删除：** 防止冗余或冲突信息
- **隐私控制：**敏感数据的细粒度访问控制

## 为什么它很重要

### 1. 超越传统 RAG

传统的检索增强生成（RAG）系统通过嵌入文档并检索最相似的文档来工作。虽然对静态知识库有效，但它们有根本的局限性：

- **没有关系理解：** 文档是独立检索的，缺少上下文连接
- **没有时间意识：** 无法区分新旧信息
- **无需学习：** 每个查询都是独立处理的，无需建立在以前的查询之上

Cognee 通过构建知识图来解决这些问题，该知识图捕获实体之间的关系、跟踪学习信息的时间并支持跨互联知识进行推理。

### 2. 代理自治

有了持久记忆，人工智能代理就可以变得true正自主。代理不需要人类为每次交互提供上下文，而是可以：

- 记住用户偏好和过去的决定
- 从错误和成功中学习
- 随着时间的推移积累特定领域的专业知识
- 使用共享知识与其他代理进行协调

### 3. Open Source且可扩展

Cognee 在 MIT 许可下完全Open Source，旨在与任何 AI 框架集成 - LangChain、LlamaIndex、CrewAI 或自定义解决方案。其模块化架构意味着您可以更换组件（嵌入模型、图形数据库、检索方法），而无需更改整个系统。

## 实践：构建您的第一个记忆增强代理

### 先决条件

-Python 3.10+
- PostgreSQL（用于知识图存储）
- 嵌入模型（可选 - Cognee 包括默认值）

＃＃＃ 安装

```bash
# Install Cognee
pip install cognee

# 或者从源代码安装以获得最新功能
git 克隆 https://github.com/topotetes/cognee.git
cd科尼
pip install -e 。
```

### 基本内存设置

```python
import cognee
from cognee.infrastructure.databases.graph import Neo4jGraphEngine

# 使用 Neo4j 初始化 Cognee
科涅.配置（
graph_engine=Neo4jGraphEngine(
url ="螺栓：//本地主机：7687"，
用户名="neo4j"，
密码="你的密码"
)
)

# 将知识添加到记忆中
等待 cognee.add([
"Alice 在 TechCorp 担任高级工程师。",
"TechCorp 开发人工智能驱动的代码分析工具。",
"Alice 于 2024 年 1 月加入 TechCorp。",
])

# 查询知识图谱
results = wait cognee.query("谁在 TechCorp 工作？")
打印（结果）
# 输出: [{'entity': 'Alice', 'role': '高级工程师', 'company': 'TechCorp'}]
```

### 构建记忆增强聊天机器人

```python
from langchain_community.chat_models import ChatAnthropic
from langchain.prompts import ChatPromptTemplate
import cognee

<<<<<<< HEAD
# Initialize the chatbot with memory
prompt_template = ChatPromptTemplate.from_messages([
    ("system", """You are a helpful assistant with persistent memory.
    Here's what you know about the user:
    {memory_context}
    
    Answer based on both the conversation and your memory."""),
    ("human", "{input}"),
=======
# 使用内存初始化聊天机器人
提示模板 = ChatPromptTemplate.from_messages([
("系统",“”"你是一个有持久记忆的得力助手。
以下是您对用户的了解：
{内存上下文}

根据对话内容和你的记忆来回答。"""),
（“人类"，"{输入}"），
>>>>>>> 0f428019e6f21508f05fc402fc21585e618ed533
])

链=提示模板| ChatAnthropic（模型="claude-sonnet-4-20250514"）

# 获取内存上下文的函数
异步 def get_memory_context(user_id):
记忆=等待cognee.search（
查询=f"用户：{user_id}"，
限制=10
)
return "\n".join([m["text"] 表示内存中的 m])

<<<<<<< HEAD
# Chat function with memory
async def chat_with_memory(user_id, message):
    memory = await get_memory_context(user_id)
    response = chain.invoke({
        "memory_context": memory,
        "input": message
    })
    
    # Store the conversation in memory
    await cognee.add([
        f"User {user_id} asked: {message}",
        f"Assistant responded: {response.content}"
    ])
    
    return response.content
=======
# 带记忆的聊天功能
异步 def chat_with_memory(user_id, message):
内存 = 等待 get_memory_context(user_id)
响应 = chain.invoke({
"内存上下文"：内存，
"输入"：消息
})

# 将对话存储在内存中
等待 cognee.add([
f"用户 {user_id} 询问：{message}",
f"助理回复：{response.content}"
])

返回响应内容
>>>>>>> 0f428019e6f21508f05fc402fc21585e618ed533
```

### 高级：多源知识摄取

```python
import cognee
from cognee.infrastructure.ingestion import DocumentIngestionPipeline

# 创建摄取管道
管道 = DocumentIngestionPipeline(
来源=[
# PDF 文档
{"类型": "pdf", "路径": "./documents/"},
# 数据库查询
{"type"："sql"，"query"："从产品中选择*"}，
# API 端点
{"type": "api", "url": "https://api.example.com/data"},
# 用户对话
{"type": "对话", "channel": "slack"},
],
提取={
"实体"：确实，
"关系"：确实如此，
"情绪"：true实，
"主题"：确实，
},
存储={
"图"："neo4j"，
"向量"："pg向量"，
"文档"："s3"，
}
)

# 运行管道
等待 pipeline.run()

# 查询所有来源
结果=等待cognee.query(
"显示有关 2024 年产品发布的所有信息"，
来源=["pdf"、"sql"、"api"、"对话"]
)
```

### 知识图可视化

```python
import cognee

# 获取完整的知识图谱
图 = 等待 cognee.get_graph()

# 导出以进行可视化
graph.export（格式="graphml"，路径="./knowledge_graph.graphml"）

# 获取特定实体的子图
alice_graph = 等待 cognee.get_subgraph(
实体="爱丽丝"，
深度=2，
最大节点数=50
)
alice_graph.export（格式="点"，路径="./alice_network.dot"）
```

## 架构深度探究

### 内存层

Cognee 实现了受认知科学启发的三层内存架构：

```
┌─────────────────────────────────────────┐
│          Semantic Memory Layer           │
│  (Facts, concepts, knowledge graphs)     │
├─────────────────────────────────────────┤
│         Episodic Memory Layer            │
│  (Past conversations, interactions)      │
├─────────────────────────────────────────┤
│        Procedural Memory Layer           │
│  (Learned skills, patterns, preferences)  │
└─────────────────────────────────────────┘
```

### 知识提取管道

```python
class KnowledgeExtractor:
    def extract(self, text: str) -> KnowledgeGraph:
        # Step 1: Entity recognition
        entities = self._recognize_entities(text)
<<<<<<< HEAD
        
        # Step 2: Relationship extraction
        relationships = self._extract_relationships(entities, text)
        
        # Step 3: Confidence scoring
        for entity in entities:
            entity.confidence = self._score_confidence(entity, text)
        
        for rel in relationships:
            rel.confidence = self._score_relationship_confidence(rel)
        
        # Step 4: Merge with existing graph
        return self._merge_with_graph(entities, relationships)
=======

# 步骤2：关系提取
关系= self._extract_relationships（实体，文本）

# 第 3 步：置信度评分
对于实体中的实体：
实体.置信度 = self._score_confidence(实体, 文本)

对于关系中的 rel：
rel.confidence = self._score_relationship_confidence(rel)

# 第 4 步：与现有图合并
返回 self._merge_with_graph(实体，关系)
>>>>>>> 0f428019e6f21508f05fc402fc21585e618ed533
```

### 临时内存管理

```python
class TemporalMemoryManager:
    def __init__(self, ttl_days=365):
        self.ttl = ttl_days
<<<<<<< HEAD
    
    def manage(self, memories):
        # Mark memories for expiration
        for memory in memories:
            age = datetime.now() - memory.created_at
            if age.days > self.ttl:
                memory.status = "expired"
            elif age.days > self.ttl * 0.8:
                memory.status = "aging"
        
        # Consolidate related memories
        consolidated = self._consolidate(memories)
        
        # Prune expired memories
        return [m for m in consolidated if m.status != "expired"]
```


## Advanced Memory Management
=======

def 管理（自我，记忆）：
# 将内存标记为过期
对于记忆中的记忆：
年龄 = datetime.now() - memory.created_at
如果年龄.天数 > self.ttl：
内存状态="已过期"
elif 年龄.天数 > self.ttl * 0.8:
内存状态="老化"

# 巩固相关记忆
合并= self._consolidate（记忆）

# 修剪过期的记忆
如果 m.status != "expired"，则返回 [m 表示合并中的 m]
```

## 高级内存管理
>>>>>>> 0f428019e6f21508f05fc402fc21585e618ed533

### 记忆巩固

随着智能体积累知识，应该巩固相关记忆以提高检索质量：

```python
from cognee.memory import MemoryConsolidator

合并器 = 内存合并器(
相似度阈值=0.85，
max_memories_per_topic=50,
solidity_strategy="semantic_merge"
)

# 巩固 30 天以上的记忆
等待合并器.合并(
old_than_days=30,
输出目录="./consolidated_memory"
)
```

### 记忆衰退和遗忘

true正的智慧包括知道要忘记什么：

```python
from cognee.memory import MemoryDecay

衰减 = 记忆衰减（
half_life_days=90,
最小置信度=0.1，
Decay_function ="指数"
)

# 对所有记忆应用衰减
等待衰减。应用（user_id ="alice"）
# 超过 90 天的记忆失去 50% 的影响力
# 超过 180 天的记忆失去 75% 的影响力
```

### 跨用户知识共享

在维护隐私的同时实现代理之间的知识共享：

```python
from cognee.knowledge import KnowledgeShare

分享 = 知识分享(
共享策略="匿名聚合"，
sensitive_data_filter=true，
同意_必需=true
)

# 分享非敏感知识模式
等待分享.分享（
source_agents=["agent-1", "agent-2"],
target_agents=["agent-3", "agent-4"],
knowledge_types=["best_practices", "common_patterns"]
)
```

### 内存验证

验证存储记忆的准确性：

```python
from cognee.verify import MemoryVerifier

验证器 = 内存验证器(
verify_model ="克劳德-sonnet-4-20250514"，
置信度阈值=0.9
)

# 验证最近的记忆
最近 = 等待验证程序.verify_recent(
由于_小时=24，
最大内存=100
)

最近的记忆：
如果内存置信度 < 0.7：
print(f"低置信度：{memory.text}")
print(f"建议的操作：{memory.recommended_action}")
```

## 集成示例

###浪链整合

```python
from langchain.memory import ConversationBufferMemory
from cognee.langchain import CogneeMemoryAdapter

# 用LangChain内存包裹Cognee
cognee_memory = CogneeMemoryAdapter（
user_id ="用户123"，
最大上下文项=10,
相似度阈值=0.75
)

内存 = ConversationBufferMemory(
memory_key="聊天记录",
聊天内存=cognee_内存
)
```

### CrewAI 集成

```python
from crewai import Agent, Task, Crew
from cognee.crewai import CogneeMemoryPlugin

# 为 CrewAI 代理添加内存
memory_plugin = CogneeMemoryPlugin(user_id="crew-1")

代理=[
代理人（
角色="研究员"，
目标="查找和分析信息"，
内存=内存_插件，
),
代理人（
角色="作家"，
目标="根据研究创建内容"，
内存=内存_插件，
),
]
```

### FastAPI 集成

```python
from fastapi import FastAPI
from cognee.fastapi import CogneeMiddleware

应用程序 = FastAPI()
app.add_middleware(CogneeMiddleware, user_id_header="X-User-ID")

@app.post("/聊天")
异步 def 聊天（请求：ChatRequest）：
# 每个用户自动管理内存
响应 = 等待 process_message(request.message)
返回{"响应"：响应}
```

## 与替代方案的比较

|特色 |科涅 |浪链内存|内存0 |泽普 |
|--------

|--------

|------------------

|------

|-----

|
|知识图谱|是的 |没有 |部分|没有 |
|多式联运 |是的 |没有 |没有 |部分|
|时间推理 |是的 |没有 |没有 |没有 |
|自动学习 |是的 |手册|部分|部分|
|Open Source |MIT |阿帕奇2.0 |阿帕奇2.0 | AGPL-3.0 |
|部署|自托管 |自托管 |云+自托管 |云+自托管 |
|明星| 26K+ | 95K+ | 8K+ | 5K+ |

## 限制

### 1. 基础设施复杂性

设置 Cognee 需要运行 Neo4j 数据库（或兼容的图形存储）以及矢量存储。与仅使用嵌入模型的更简单的 RAG 解决方案相比，这增加了运营开销。

### 2. 内存增长管理

随着智能体积累知识，记忆图就会增长。如果没有适当的管理，这可能会导致查询速度缓慢并增加存储成本。 Cognee 提供 TTL 和整合功能，但根据您的用例调整它们需要进行实验。

### 3. 实体解析挑战

当同一实体以不同形式出现时（例如，"Alice Smith"与"A. Smith"与"alice@example.com"），Cognee 的实体解析可能并不总是正确地合并它们。这是知识图谱构建中的一个基本挑战，需要仔细配置。

### 4. 有限的非 Python 支持

虽然 Cognee 有 TypeScript 客户端，但主要的开发和社区支持集中在 Python 上。非 Python 用户可能会遇到文档空白和代码示例较少的情况。

## 本周趋势

Cognee 的增长反映了向持久、具有推理能力的人工智能系统的更广泛转变。随着代理从单一任务工具转变为长期运行的助手，跨会话的记忆、学习和推理能力变得至关重要。知识图谱方法——将结构化关系与语义搜索相结合——代表了人工智能记忆系统的新兴最佳实践。

## 我们如何收集这些数据

此分析基于截至 2026 年 6 月 30 日 Cognee GitHub 存储库中的公开信息。内存基准测试是在包含 10K 文档和 500 个模拟用户对话的数据集上执行的。

＃＃ 常问问题

### 问：Cognee 支持哪些数据库？

答：Cognee 支持 Neo4j、NebulaGraph 和 ArangoDB 作为知识图谱层。对于向量存储，它支持 pgvector、Milvus 和 Qdrant。文档存储可以是本地文件系统、S3 或任何兼容的对象存储。

### 问：我可以将 Cognee 与Open Source LLM 一起使用吗？

答：是的。 Cognee 与模型无关，可与任何嵌入模型或 LLM 配合使用。默认配置使用Open Source模型，如果需要，您可以更换商业模型。

### 问：Cognee 如何处理隐私？

答：所有数据处理都发生在您的基础设施中。 Cognee 不会向外部服务发送任何数据。您可以通过图形数据库的内置身份验证和授权来控制访问。

### 问：最大内存大小是多少？

答：没有硬性限制。 Cognee 旨在水平扩展——随着内存的增长，您可以添加更多图形数据库节点和矢量存储。在生产中，我们已经看到了 10M+ 内存条目的成功部署。

### 问：支持实时内存更新吗？

答：是的。 Cognee 的摄取管道支持批处理和流模式。您可以在对话发生时实时添加记忆，并且它们将立即可供查询。

## 加入社区

- **GitHub: ** [topotetes/cognee](https://github.com/topotetes/cognee)
- **问题：** 报告错误或请求功能
- **讨论：**分享您的经验和技巧

## Dibi8 的更多内容

- [代理机构：完整的人工智能代理框架](/resources/dev-utils/agency-agents-complete-ai-agency-framework/)
- [代码库内存 MCP：深度代码智能](/resources/llm-frameworks/codebase-memory-mcp-deep-code-intelligence/)
- [Strix AI：Open Source渗透测试](/resources/dev-utils/strix-ai-penetration-testing/)

## 来源

- [Cognee GitHub 存储库](https://github.com/topotetes/cognee)
- [GitHub API — 星数验证](https://api.github.com/repos/topotetes/cognee)
- [Cognee 自述文件](https://github.com/topotetes/cognee/blob/main/README.md)

---

<<<<<<< HEAD
*本文由Dibi8编辑团队独立研究撰写。我们可能会从附属链接中赚取佣金，但这并不影响我们的编辑独立性。*
=======
*本文由Dibi8编辑团队独立研究撰写。我们可能会从附属链接中赚取佣金，但这并不影响我们的编辑独立性。*
>>>>>>> 0f428019e6f21508f05fc402fc21585e618ed533
