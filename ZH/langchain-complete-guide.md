---
title: 'LangChain完整入门指南2025：从零构建生产级AI应用'
description: 'LangChain 2025完整指南：深入解析核心组件、LangGraph与LangSmith生态，含代码示例与生产部署最佳实践。'
date: 2026-05-18 00:00:00+08:00
lastmod: 2026-05-18 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-18'
featureImage: ''
draft: false
aliases:
- /posts/langchain-complete-guide/
---

{</* resource-info */>}

LangChain自2022年10月开源以来，迅速成长为Python生态中最热门的LLM应用开发框架。截至2025年5月，其GitHub仓库已获得超过95,000颗星标，月下载量突破1,200万次。本文将带你系统掌握LangChain的核心架构、关键组件以及生产级部署策略。

## LangChain是什么？为什么2025年依然重要？

LangChain是一个用于开发由大型语言模型驱动的应用程序的编排框架。它本身不提供模型，而是通过一套标准化的抽象层，将模型调用、数据检索、工具使用和链式逻辑串联成完整的工作流。

LangChain的核心价值体现在三个维度：

- **模块化设计**：每个组件可独立替换，从OpenAI GPT-4切换到本地Llama 3只需改一行代码
- **生态整合**：内置300+集成，覆盖向量数据库、文档加载器、API工具等
- **生产就绪**：通过LangSmith提供全链路可观测性，通过LangGraph支持复杂多智能体应用

### LangChain生态系统全景图

2024年LangChain团队对项目进行了重大重构，形成了清晰的三层架构：

| 项目 | 定位 | 核心功能 |
|------|------|----------|
| LangChain | 基础编排框架 | 组件抽象、链式调用、数据加载 |
| LangGraph | 状态图引擎 | 循环工作流、多智能体协作、持久化状态 |
| LangSmith | 观测平台 | 调用追踪、性能评估、提示词管理 |

这三个项目协同工作，覆盖了从原型开发到生产运维的完整生命周期。开发者可以根据项目复杂度选择单独使用LangChain，或在需要复杂交互时引入LangGraph。

## LangChain核心组件深度解析

### Models：模型接口层

LangChain将模型调用抽象为两类接口：

1. **LLMs**：基于文本补全的模型（如GPT-3.5-turbo-instruct）
2. **Chat Models**：基于对话格式的模型（如GPT-4、Claude 3.5 Sonnet、Llama 3）

推荐使用Chat Models作为默认选择，因为所有主流模型厂商都已迁移到对话API格式。通过`init_chat_model()`函数，你可以用统一的方式初始化来自不同供应商的模型。

### Prompts：提示词工程基础设施

LangChain的提示词系统包含三个关键元素：

- **PromptTemplate**：带有变量插槽的模板，支持部分绑定（partial）
- **Example Selectors**：从示例库中动态选择最相关的few-shot示例
- **Output Parsers**：将模型输出解析为结构化数据（JSON、Pydantic对象等）

2025年新推出的`ChatPromptTemplate`支持多模态消息，可以混合文本、图片和工具调用，这对构建视觉理解应用至关重要。

### Chains：工作流编排核心

链是LangChain的核心抽象，表示组件之间的调用序列。常见模式包括：

- **LLM Chain**：Prompt → Model → Output Parser 的基础管道
- **Retrieval Chain**：RAG应用的标准模板，整合检索与生成功能
- **Router Chain**：根据输入类型动态路由到不同的子链
- **Sequential Chain**：多步骤串行处理，前一步输出作为后一步输入

### 文档处理与向量检索

RAG应用的数据处理流水线通常遵循以下流程：

1. **Document Loaders**：从PDF、网页、数据库等来源加载原始文档（内置100+加载器）
2. **Text Splitters**：按字符、token或语义边界切分文本
   - `RecursiveCharacterTextSplitter`：最常用的通用切分器
   - `SemanticChunker`：基于语义相似度的智能切分（实验性）
3. **Vector Stores**：存储文本嵌入向量，支持FAISS、Chroma、Pinecone、Milvus等
4. **Retrievers**：执行相似度搜索，返回与查询最相关的文档片段

2025年LangChain引入了`ParentDocumentRetriever`，它在检索时使用小块文本保证精确度，但在传递给LLM时使用完整父文档，显著提升了RAG的回答质量。

### Agents：自主决策智能体

Agent是LangChain中最强大的组件。它让LLM自主决定调用哪些工具、以什么顺序调用。核心架构包括：

- **Agent Executor**：运行循环，管理工具调用与观察（observation）
- **Tools**：LLM可调用的函数，可以是API、代码执行或数据库查询
- **ReAct框架**：推理（Reasoning）与行动（Acting）交替进行，Agent在每一步都输出思考过程

### Memory：对话状态管理

Memory组件管理对话历史的存储与检索。两种主要模式：

- **Buffer Memory**：保存完整对话历史，适合短对话
- **Summary Memory**：对历史进行摘要，适合长对话场景

在LangGraph普及后，复杂的记忆管理更推荐使用图的持久化层来实现。

## LangChain vs LangGraph vs LangSmith：三者如何分工？

很多初学者对这三个项目的关系感到困惑。简单来说：

**LangChain**负责"做什么"——提供所有基础组件的抽象接口。你用它写Prompt、调模型、加载文档。它是静态的、声明式的。

**LangGraph**负责"怎么做"——管理工作流的执行顺序。当你的应用需要循环、条件分支或多智能体协作时，LangGraph通过有向状态图（directed state graph）精确控制每一步的流转。它弥补了LangChain原生只支持DAG（有向无环图）的局限。

**LangSmith**负责"做得怎样"——提供全链路的可观测性。每一次模型调用、每一次检索、每一个token的延迟都被记录下来，方便调试和优化。

三者的关系就像乐高积木（LangChain）、拼装说明书（LangGraph）和质量检测仪（LangSmith）。

## 快速上手：5分钟构建你的第一个RAG应用

### 环境安装

```bash
pip install langchain langchain-openai langchain-community
pip install faiss-cpu  # 或 chromadb
```

### 基础LLM调用

```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate

llm = ChatOpenAI(model="gpt-4o-mini")
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个技术文档助手。"),
    ("human", "{question}")
])
chain = prompt | llm
response = chain.invoke({"question": "什么是RAG？"})
```

### 完整RAG应用

```python
from langchain_community.document_loaders import WebBaseLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_openai import OpenAIEmbeddings
from langchain_community.vectorstores import FAISS
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain.chains import create_retrieval_chain

# 加载与切分文档
loader = WebBaseLoader("https://python.langchain.com/docs/concepts/")
docs = loader.load()
splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
chunks = splitter.split_documents(docs)

# 构建向量索引
vectorstore = FAISS.from_documents(chunks, OpenAIEmbeddings())
retriever = vectorstore.as_retriever(search_kwargs={"k": 4})

# 创建RAG链
qa_prompt = ChatPromptTemplate.from_template("""
基于以下上下文回答问题：
{context}
问题：{input}
""")
doc_chain = create_stuff_documents_chain(llm, qa_prompt)
rag_chain = create_retrieval_chain(retriever, doc_chain)

result = rag_chain.invoke({"input": "LangChain的核心组件有哪些？"})
```

这段代码涵盖了文档加载、切分、索引、检索和生成的完整RAG流水线。

## 高级模式：让应用更强大

### 流式输出与异步执行

生产环境的用户体验要求实时响应。LangChain原生支持流式输出：

```python
for chunk in rag_chain.stream({"input": "解释RAG原理"}):
    if answer_chunk := chunk.get("answer"):
        print(answer_chunk, end="")
```

异步支持通过`ainvoke`、`astream`方法提供，与FastAPI、Sanic等异步框架无缝集成。

### 错误处理与Fallback策略

模型调用可能因网络、限流或内容审核失败。LangChain提供多层fallback机制：

1. **模型级Fallback**：主模型失败时自动切换到备用模型
2. **提示词Fallback**：精简版提示词应对token超限
3. **Retry逻辑**：指数退避重试，可配置重试次数和等待时间

### 自定义工具与Agent

```python
from langchain_core.tools import tool
from langchain.agents import create_react_agent, AgentExecutor

@tool
def calculate(expression: str) -> float:
    """执行数学计算。"""
    return eval(expression)

tools = [calculate]
agent = create_react_agent(llm, tools, prompt)
executor = AgentExecutor(agent=agent, tools=tools, verbose=True)
```

工具的定义只需要Python函数加上`@tool`装饰器，LangChain会自动生成schema供LLM理解。

## 生产部署最佳实践

### 安全防御

- **Prompt Injection防护**：使用LangChain的`HuggingFaceTokenProtection`和输入过滤器
- **输出校验**：通过Pydantic模型校验LLM输出的结构合法性
- **权限隔离**：Agent的工具调用需遵循最小权限原则，代码执行必须在沙箱环境

### 性能优化

- **向量索引分区**：按数据源或时间维度分片，减少单次搜索空间
- **Embedding缓存**：对高频查询的embedding结果进行Redis缓存
- **模型量化**：本地部署时使用INT8/INT4量化模型，降低内存占用
- **批处理**：利用`batch()`方法并行处理多个请求

### 部署方案

Docker容器化是最推荐的部署方式：

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

配合LangSmith的实时监控，可以追踪每一次请求的完整调用链路，快速定位延迟瓶颈。

## 2025年LangChain替代方案对比

| 框架 | 核心优势 | 适用场景 | GitHub星标（2025.05） |
|------|----------|----------|----------------------|
| LangChain | 生态最全、集成最多 | 通用LLM应用 | 95,000+ |
| LlamaIndex | RAG管道最成熟 | 文档问答、知识库 | 39,000+ |
| Haystack | 企业级搜索 | 电商搜索、企业搜索 | 16,000+ |
| CrewAI | 多智能体编排最简单 | 自动化工作流 | 25,000+ |
| AutoGen | 对话式Agent | 代码生成、数据分析 | 33,000+ |

选择框架时应考虑团队技术栈、应用类型和长期维护成本。LangChain的通用性使其成为大多数团队的安全选择。

## 常见问题（FAQ）

### LangChain主要用于什么场景？

LangChain适用于几乎所有LLM驱动的应用开发，最常见的场景包括：RAG文档问答、AI智能客服、代码助手、自动化数据分析、多Agent协作系统。从个人side project到企业级SaaS都有广泛采用。

### LangChain是免费使用的吗？

LangChain框架本身完全开源免费（MIT许可证）。但你需要为底层LLM API调用付费（如OpenAI、Anthropic的按量计费）。如果连接本地模型（如Ollama），则调用成本为零。LangSmith提供免费额度，超出后按调用次数收费。

### LangChain和LlamaIndex哪个更适合RAG？

LlamaIndex在纯RAG场景下更专业，提供更细粒度的索引策略和查询优化。LangChain的优势在于通用性和生态广度，适合需要同时集成工具调用、Agent决策和检索的复合应用。两者也可以结合使用——用LlamaIndex做检索后端，LangChain做整体编排。

### LangChain支持JavaScript/TypeScript吗？

支持。LangChain.js是官方维护的JavaScript/TypeScript版本，API设计与Python版保持一致。它支持Node.js、Deno和浏览器环境，与Next.js、Express等框架配合良好。不过Python版的生态更丰富，集成数量约为JS版的2倍。

### LangChain可以与本地LLM（如Ollama）一起使用吗？

完全可以。通过`ChatOllama`类即可连接本地Ollama服务。只需安装`langchain-ollama`包，然后初始化模型即可。这是降低API成本和保护数据隐私的最佳实践。

## 下一步学习路径

掌握LangChain后，建议按以下顺序深入：

1. 学习LangGraph，构建带状态的多Agent系统
2. 配置LangSmith，建立完整的观测和评估流程
3. 探索更专业的RAG优化技术（如重排序、查询重写）
4. 研究模型微调，在特定领域超越通用模型表现

LangChain的[官方文档](https://python.langchain.com)和[GitHub仓库](https://github.com/langchain-ai/langchain)是持续学习的最佳资源。框架迭代速度快，建议关注官方博客获取最新动态。

---

## 推荐基础设施

要 7×24 稳跑上述工具，服务器选择关键：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 $200 试用 60 天，全球 14+ 节点，一键 droplet 适配 AI 工作流。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟。**dibi8.com 自家所在 IDC**，生产验证。

*推广链接，不增加你的成本，能支持 dibi8.com 运营。*

