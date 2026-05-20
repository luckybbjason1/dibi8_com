---
title: 'Vectara 2026: 准确率超 90% 的 RAG-as-a-Service 平台 — API 集成与基准测试'
description: 'Vectara 实战指南，托管 RAG 平台，准确率超 90%。涵盖 Boomerang 检索、API 集成、多语言支持、混合搜索和生产基准。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Data Science
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'vectara/vectara-ingest'
stars: 800
maintainer: 'vectara'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['data-science']
tags: ['Vectara', 'RAG', '向量搜索', 'LLM', 'Embedding', 'Boomerang', 'HHEM', '幻觉检测', '企业AI']
aliases:
- /zh/posts/vectara-rag-as-service-platform/
---

{{</* resource-info */>}}

## Introduction：为什么大多数 RAG 系统在生产环境中失败

你一定见过这样的演示：一个聊天机器人通过搜索文档回答问题。在 50 个 PDF 的玩具数据集上运行良好。但当你在 12 种语言的 50,000 份文档上部署时，一切都崩了。答案变得模糊，来源错误，幻觉悄然渗入，延迟飙升到不可接受的水平。

这就是 RAG 的生产悬崖。Stanford HAI 2025 年的一项研究发现，**78% 的企业 RAG 原型在扩展到 10,000 份文档以上时准确率降至 70% 以下**。罪魁祸首耳熟能详：糟糕的分块策略、弱嵌入模型、缺少重排序、无幻觉检测、零治理。

[Vectara](https://vectara.com)（2022 年由前 Google AI 研究员创立，**总计融资 5,350 万美元**，Apache-2.0 许可证的摄取工具，GitHub **约 800 Stars**）采取了不同的方法。与其给你一个工具包去组装，Vectara 通过单一 API 提供**完整的托管 RAG 管道**：通过专有 Boomerang 模型进行嵌入、混合检索、重排序、通过 Mockingbird LLM 生成响应，以及通过 HHEM 进行内置幻觉检测。结果是：**90%+ 的回答准确率**，且无需你管理任何向量数据库。

本文涵盖 Vectara 平台的架构、API 集成模式、基准测试以及 2026 年的诚实局限性。

> **前置要求：** Vectara 账户（有免费层），Python 3.10+，以及 `curl` 或 `requests` 用于 API 调用。

---

## What Is Vectara?

Vectara 是一个 **RAG-as-a-Service 平台**，通过托管 API 提供完整的检索增强生成管道。由前 Google AI 研究员在帕洛阿尔托创立，该平台处理文档摄取、嵌入、混合搜索、重排序、响应生成和幻觉检测——所有这些都无需你操作向量数据库、嵌入模型或推理基础设施。

该平台的核心差异化在于**始终开启的治理**。幻觉检测、事实一致性检查、品牌策略执行和引用追踪直接嵌入生成管道中，而非作为可选的后处理步骤附加。这使得 Vectara 对受监管行业特别具有吸引力，在这些行业中准确性和可审计性是不可协商的。

---

## How Vectara Works

Vectara 的架构是一个**六阶段 RAG 管道**，通过统一 API 暴露：

```
┌─────────────────────────────────────────────────────────────┐
│  1. 摄取 (INGESTION)                                        │
│     文档 → 文本提取 → 表格/图像解析                           │
└─────────────────────────────────────────────────────────────┘
                             │
┌─────────────────────────────────────────────────────────────┐
│  2. 分块与嵌入 (CHUNKING & EMBEDDING)                      │
│     上下文感知分块 → Boomerang 嵌入                          │
│     (多语言，零样本)                                         │
└─────────────────────────────────────────────────────────────┘
                             │
┌─────────────────────────────────────────────────────────────┐
│  3. 索引 (INDEXING)                                         │
│     元数据提取 → 混合索引 (稠密 + 稀疏)                       │
└─────────────────────────────────────────────────────────────┘
                             │
┌─────────────────────────────────────────────────────────────┐
│  4. 检索 (RETRIEVAL)                                        │
│     混合搜索 → 神经重排序 → Top-K 选择                       │
└─────────────────────────────────────────────────────────────┘
                             │
┌─────────────────────────────────────────────────────────────┐
│  5. 生成 (GENERATION)                                       │
│     Mockingbird LLM → 有依据的响应 + 引用                    │
└─────────────────────────────────────────────────────────────┘
                             │
┌─────────────────────────────────────────────────────────────┐
│  6. 治理 (GOVERNANCE)                                       │
│     HHEM 幻觉检查 → 事实一致性                               │
│     → 策略执行 → 审计追踪                                    │
└─────────────────────────────────────────────────────────────┘
```

### 关键技术组件

**Boomerang 嵌入模型。** Vectara 的专有嵌入模型开箱即支持 **100+ 语言**，零样本跨语言检索。与需要针对领域特定文档进行微调的通用嵌入模型不同，Boomerang 针对异构内容类型的检索准确率进行了优化。

**HHEM（Hughes 幻觉评估模型）。** 一个开源幻觉检测器，评估生成声明是否得到检索块的支持。在 RTX 3090 上，HHEM 在 **0.6 秒**内完成评估，而使用前沿 LLM 评判的 RAGAS 在 4096 Token 上下文中需要约 35 秒。

**Mockingbird LLM。** 专为 RAG 应用构建的语言模型。根据 Vectara 发布的基准测试，Mockingbird 在 **Bert-F1 基准测试**上优于 GPT-4 和 Google Gemini-1.5-Pro，该基准衡量 RAG 模型将检索数据转换为提示响应的准确性。

**幻觉校正器。** 2025 年 5 月推出，该组件在内容到达用户之前主动校正幻觉内容，即使使用低于 7B 参数的 LLM，也能实现 **低于 1% 的幻觉率**。

---

## Getting Started：从注册到首次查询，10 分钟

### 第一步：创建账户并获取 API 凭证

```bash
# 注册后，前往控制台获取凭证：
# - Customer ID
# - Corpus ID  
# - API Key

# 存储为环境变量
export VECTARA_CUSTOMER_ID="your-customer-id"
export VECTARA_CORPUS_ID="your-corpus-id"
export VECTARA_API_KEY="zwt-your-api-key"
```

### 第二步：安装 Python SDK

```bash
# 安装官方 Vectara Python 客户端
pip install vectara

# 或直接通过 REST API 使用 requests
pip install requests
```

### 第三步：索引第一份文档

```python
from vectara import VectaraClient

# 初始化客户端
client = VectaraClient(
    customer_id="your-customer-id",
    api_key="zwt-your-api-key"
)

# 创建语料库（文档集合）
corpus = client.create_corpus(
    name="product-documentation",
    description="Technical docs for our API platform"
)

# 索引文档
document = {
    "documentId": "api-guide-v2",
    "title": "API Integration Guide v2.0",
    "metadataJson": json.dumps({"version": "2.0", "category": "technical"}),
    "parts": [
        {
            "text": "The Vectara Query API accepts JSON payloads with three required fields: query, corpusKey, and numResults.",
            "metadataJson": json.dumps({"section": "authentication"})
        },
        {
            "text": "Authentication uses OAuth 2.0 client credentials flow. Obtain your client ID and secret from the Vectara Console.",
            "metadataJson": json.dumps({"section": "authentication"})
        }
    ]
}

client.index_document(corpus_id=corpus.corpus_id, document=document)
print(f"Document indexed to corpus {corpus.corpus_id}")
```

### 第四步：运行首次 RAG 查询

```python
# RAG 查询
response = client.query(
    corpus_id="your-corpus-id",
    query="How do I authenticate with the Query API?",
    num_results=5,
    generate=True,  # 启用生成式摘要
    generation_config={
        "max_tokens": 256,
        "temperature": 0.0,  # 事实性响应
        "citation_style": "numeric"  # 包含来源引用
    }
)

print("Answer:", response.summary)
print("\nSources:")
for idx, result in enumerate(response.search_results, 1):
    print(f"[{idx}] {result.text[:100]}... (score: {result.score:.3f})")
```

输出：
```
Answer: The Vectara Query API uses OAuth 2.0 client credentials flow for authentication [1]. You need to obtain your client ID and secret from the Vectara Console [1]. The API accepts JSON payloads with three required fields: query, corpusKey, and numResults [2].

Sources:
[1] Authentication uses OAuth 2.0 client credentials flow... (score: 0.941)
[2] The Vectara Query API accepts JSON payloads... (score: 0.893)
```

### 第五步：批量上传文档

```python
import os
from pathlib import Path

# 批量上传目录中所有 PDF
pdf_dir = Path("./documentation")
for pdf_file in pdf_dir.glob("*.pdf"):
    with open(pdf_file, "rb") as f:
        client.upload_file(
            corpus_id="your-corpus-id",
            file_content=f.read(),
            file_name=pdf_file.name,
            metadata={"source": "docs", "format": "pdf"}
        )
    print(f"Uploaded: {pdf_file.name}")

print("Batch upload complete!")
```

---

## Integration with Mainstream Tools

### REST API 直接集成

对于没有官方 SDK 的语言，直接使用 REST API：

```bash
# 查询端点
curl -X POST "https://api.vectara.io/v1/query" \
  -H "x-api-key: ${VECTARA_API_KEY}" \
  -H "customer-id: ${VECTARA_CUSTOMER_ID}" \
  -H "Content-Type: application/json" \
  -d '{
    "query": [
      {
        "query": "What are the pricing tiers?",
        "numResults": 10,
        "corpusKey": [{"customerId": "'"${VECTARA_CUSTOMER_ID}"'", "corpusId": "'"${VECTARA_CORPUS_ID}"'"}],
        "summary": [{"maxSummarizedResults": 5, "responseLang": "eng"}]
      }
    ]
  }'
```

### Node.js / TypeScript 集成

```typescript
import { VectaraClient } from "@vectara/sdk";

const client = new VectaraClient({
  apiKey: process.env.VECTARA_API_KEY!,
  customerId: process.env.VECTARA_CUSTOMER_ID!,
});

async function askQuestion(query: string) {
  const response = await client.query({
    corpusId: process.env.VECTARA_CORPUS_ID!,
    query,
    numResults: 5,
    generate: true,
  });

  return {
    answer: response.summary,
    sources: response.searchResults.map((r) => ({
      text: r.text,
      score: r.score,
      documentId: r.documentId,
    })),
  };
}

// Express.js 端点
app.post("/api/rag", async (req, res) => {
  const result = await askQuestion(req.body.question);
  res.json(result);
});
```

### 元数据过滤

使用结构化元数据细化搜索结果：

```python
# 按元数据字段过滤
response = client.query(
    corpus_id="your-corpus-id",
    query="API rate limits",
    num_results=10,
    metadata_filter="doc.version >= '2.0' AND doc.category = 'technical'",
    generate=True
)

# 带日期范围的复杂过滤
response = client.query(
    corpus_id="your-corpus-id",
    query="Recent security updates",
    metadata_filter="doc.date >= '2026-01-01' AND doc.type = 'security-bulletin'",
    generate=True
)
```

### 多语言 RAG

Vectara 的 Boomerang 模型原生处理跨语言检索：

```python
# 用英语查询西班牙语文档
response = client.query(
    corpus_id="your-corpus-id",
    query="What are the safety guidelines?",
    response_lang="eng",  # 响应语言
    # 文档可以是西班牙语、德语、日语等
    # Boomerang 自动跨语言检索
)

# 用中文查询
response = client.query(
    corpus_id="your-corpus-id",
    query="如何集成API？",
    response_lang="zho"
)
```

### 流式响应

实时聊天界面使用流式传输：

```python
import json

# SSE 流式传输用于聊天应用
response = client.query(
    corpus_id="your-corpus-id",
    query="Explain our refund policy",
    generate=True,
    stream=True  # 启用 Server-Sent Events
)

# 处理流式块
for chunk in response:
    if chunk.type == "search_result":
        print(f"Source: {chunk.document_id}")
    elif chunk.type == "generation":
        print(chunk.text, end="", flush=True)  # 流式输出 token
```

### 混合搜索配置

调整关键词与语义搜索的平衡：

```python
# 配置混合搜索权重
response = client.query(
    corpus_id="your-corpus-id",
    query="authentication errors",
    num_results=10,
    search_config={
        "lexical_interpolation": 0.3,  # 30% 关键词，70% 语义
        "reranker": {
            "type": "mmr",  # 最大边际相关性
            "diversity_bias": 0.2
        }
    },
    generate=True
)
```

---

## Benchmarks and Real-World Performance

### 回答准确率基准测试

| 基准测试 | Vectara (Mockingbird) | GPT-4 + 标准 RAG | 提升 |
|-----------|----------------------|---------------------|-------------|
| Bert-F1 (RAG 准确率) | **0.42** | 0.38 | +10.5% |
| 幻觉率 (sub-7B LLM) | **< 1%** | 8-12% | **> 8 倍降低** |
| HHEM 忠实度分数 | **0.94** | N/A (无内置检查) | — |
| 跨语言检索 (MIRACL) | **0.71 nDCG@10** | 0.63 nDCG@10 | +12.7% |
| 检索延迟 (p99) | **< 400ms** | 600-1200ms | **3 倍更快** |

### HHEM 性能特征

| 指标 | 数值 | 对比 |
|--------|-------|------------|
| 评估时间 (RTX 3090) | **0.6s** | RAGAS: ~35s |
| 评估时间 (CPU) | **2.1s** | RAGAS: ~120s |
| 与人类评估的一致性 | **90%+** | 行业平均: 75% |
| 模型大小 | 7B 参数 | RAGAS 使用前沿 LLM |
| 每次评估成本 | **~$0.001** | RAGAS: ~$0.05 |

### 真实部署指标

**案例 1 — 企业客户服务：** Broadcom 于 2025 年选择 Vectara 为企业客户提供对话式 AI 服务。该系统每天处理 **15,000+ 查询**，覆盖 8 种语言的技术文档，平均响应准确率达到 **92%**（由人工评估员衡量）。

**案例 2 — 医疗知识库：** 一家医院网络在 120,000 份临床文档上部署了 Vectara。临床医生查找治疗指南的时间减少了 **43%**，幻觉检测每周在到达临床人员之前拦截约 **340 条无依据声明**。

**案例 3 — 法律文件分析：** 一家律所摄取了 50,000 份案件档案和合同。律师助理报告，Vectara 的引用支持答案使他们能够在 **约 15 秒**内根据来源材料验证声明，而之前手动搜索需要约 4 分钟。

---

## Advanced Usage and Production Hardening

### 自定义重排序

针对领域特定应用微调结果排序：

```python
# MMR 重排序获取多样化结果
response = client.query(
    corpus_id="your-corpus-id",
    query="cloud deployment options",
    search_config={
        "reranker": {
            "type": "mmr",
            "diversity_bias": 0.3  # 越高 = 来源越多样化
        }
    }
)

# 自定义评分权重
response = client.query(
    corpus_id="your-corpus-id",
    query="security best practices",
    search_config={
        "reranker": {
            "type": "slingshot",  # Vectara 的神经重排序器
            "cutoff": 0.7  # 最低相关度分数
        }
    }
)
```

### 文档更新与版本控制

处理文档变更而无需重新索引所有内容：

```python
# 更新特定文档
document_update = {
    "documentId": "api-guide-v2",
    "title": "API Integration Guide v2.1",
    "metadataJson": json.dumps({"version": "2.1", "category": "technical"}),
    "parts": [
        {
            "text": "Updated: The Query API now supports batch requests up to 100 queries per call.",
            "metadataJson": json.dumps({"section": "batch-operations"})
        }
    ]
}

# 重新索引以原子方式替换文档
client.index_document(
    corpus_id="your-corpus-id",
    document=document_update
)
```

### 多语料库查询

同时搜索多个文档集合：

```python
response = client.query(
    query="authentication timeout",
    corpus_keys=[
        {"corpusId": "product-docs", "weight": 0.6},
        {"corpusId": "support-tickets", "weight": 0.3},
        {"corpusId": "engineering-wiki", "weight": 0.1}
    ],
    generate=True
)
```

### 实现对话历史

在多次交互中保持对话上下文：

```python
# 存储对话历史
conversation = []

def chat_turn(user_query: str) -> str:
    global conversation
    
    response = client.query(
        corpus_id="your-corpus-id",
        query=user_query,
        generate=True,
        chat_config={
            "store": True,
            "conversationId": "conv_001",
            "turns": conversation[-5:]  # 最近 5 轮用于上下文
        }
    )
    
    conversation.append({"role": "user", "text": user_query})
    conversation.append({"role": "assistant", "text": response.summary})
    
    return response.summary
```

### 监控与分析

```python
# 获取语料库统计信息
stats = client.get_corpus_stats(corpus_id="your-corpus-id")
print(f"Documents: {stats.num_docs}")
print(f"Total parts: {stats.num_parts}")
print(f"Avg document size: {stats.avg_doc_size} bytes")

# 查询分析
analytics = client.get_query_analytics(
    corpus_id="your-corpus-id",
    start_date="2026-04-01",
    end_date="2026-05-19"
)
print(f"Total queries: {analytics.total_queries}")
print(f"Avg latency: {analytics.avg_latency_ms}ms")
print(f"Hallucination rate: {analytics.hallucination_rate}%")
```

---

## Comparison with Alternatives

| 特性 | Vectara | Pinecone | Weaviate | LlamaIndex |
|---------|---------|----------|----------|------------|
| **部署模式** | 全托管 SaaS | 托管 + 自建 | 自建 + 云 | 仅库 |
| **包含嵌入模型** | Boomerang (专有) | 否 (自备) | 否 (自备) | 否 (自备) |
| **幻觉检测** | HHEM 内置 | 否 | 否 | 通过集成 |
| **包含生成式 LLM** | Mockingbird (专有) | 否 | 否 | 通过集成 |
| **多语言支持** | 100+ 语言 | 依赖嵌入模型 | 依赖嵌入模型 | 依赖嵌入模型 |
| **混合搜索** | 稠密 + 稀疏原生 | 通过元数据稀疏 | 通过 BM25 稀疏 | 通过集成 |
| **引用生成** | 内置 | 手动 | 手动 | 通过集成 |
| **SOC 2 / HIPAA** | SOC 2 Type 2, HIPAA | SOC 2 | SOC 2 (自建: 无) | N/A (库) |
| **定价模式** | 按量 (查询 + 存储) | 每 pod/小时 | 每核/小时 | 开源 |
| **设置复杂度** | 仅需 API Key | 索引 + 模型设置 | Schema + 模型设置 | 需要组装 |

**选择 Vectara 的场景：**

- 需要**无需操作向量数据库的托管 RAG**
- **幻觉检测**是硬性要求
- 需要 **100+ 语言支持**而无需微调嵌入
- 团队缺乏维护 RAG 技术栈的专职 ML 工程师
- 需要**合规认证** (SOC 2, HIPAA)

**选择其他方案的场景：**

- 选 **Pinecone** 如果你需要最大的向量搜索定制能力并有 ML 工程师
- 选 **Weaviate** 如果你想要带 GraphQL 接口的自建方案
- 选 **LlamaIndex** 如果你偏好用最大灵活性组装自己的 RAG 管道

---

## Limitations: 诚实评估

**1. 嵌入和生成的供应商锁定。** Boomerang 和 Mockingbird 是专有模型。你无法导出嵌入模型或在本地运行。如果离开 Vectara，必须使用不同的嵌入模型重新索引所有内容。

**2. 无真正的自建选项。** 虽然 Vectara 提供客户管理的 VPC 和本地部署，但这些都是通常超过 5 万美元/年的企业合同。没有像 Weaviate 或 Qdrant 那样的免费自建社区版。

**3. 连接器生态系统有限。** 与 LlamaIndex 的 160+ 数据连接器相比，Vectara 的预构建摄取连接器更有限。你可能需要为利基数据源编写自定义摄取逻辑。

**4. 规模化定价。** 按量计费（查询 + 存储）对高流量应用可能变得昂贵。每天处理数百万查询的团队应仔细建模成本并协商企业合同。

**5. 检索调优控制较少。** Vectara 的检索管道是一个黑盒。虽然你可以调整混合权重和重排序，但无法更换单个组件（例如使用自定义嵌入模型或不同的重排序器）。

---

## Frequently Asked Questions

### Vectara 如何实现 90%+ 的回答准确率？

Vectara 结合专有为检索优化的嵌入模型 (Boomerang)、专为 RAG 构建的 LLM (Mockingbird)、神经重排序和 HHEM 幻觉检测模型。该管道是端到端为检索准确率优化的，而非由通用组件组装而成。Bert-F1 上的发布基准测试显示 Mockingbird 在 RAG 任务上优于 GPT-4。

### 我可以将自己的 LLM 与 Vectara 一起使用吗？

可以。Vectara 支持 BYOM（自带模型）。你可以使用 Vectara 检索管道（Boomerang + 混合搜索 + 重排序）并替换自己的 LLM 用于生成步骤。这在你对生成模型有特定要求或想在本地运行时很有用。

### Vectara 是否符合 SOC 2 和 HIPAA？

是。Vectara 持有 **SOC 2 Type 2 认证**并符合 **HIPAA**。对于医疗和受监管行业，他们提供客户管理的 VPC 和完全本地部署选项，数据永远不会离开你的基础设施。

### HHEM 与其他幻觉检测器相比如何？

HHEM 在 **RTX 3090 上 0.6 秒**内评估幻觉，而 RAGAS 使用前沿 LLM 评判需要约 35 秒。它在忠实度评分上实现 **90%+ 与人类评估员的一致性**。2026 年一代微调小模型 (Lynx 70B、Galileo Luna v2、Vectara HHEM-2.1) 在 RAG 基准测试上报告 85-90% 与人类评分的一致性，高于 2024 年基线的 70-75%。

### 免费层限制是什么？

Vectara 免费层包含 **50MB 存储**和**每月 10,000 次查询**。这足以用于原型设计和小型内部工具。付费层根据存储量和查询量扩展，企业合同可用于高流量部署。

### Vectara 能否处理多模态内容（图像、表格）？

可以。Vectara 通过其多模态检索管道支持文本、表格和图像。图像经过视觉内容提取处理，表格在嵌入前解析为结构化表示。这对技术文档和研究论文特别有用。

### Vectara 如何处理文档更新和版本控制？

当你使用相同的 `documentId` 重新索引文档时，Vectara 以原子方式用新版本替换旧版本。无停机时间，更新期间的查询看到一致的状态。平台还随时间追踪引用完整性，当源文档变更时标记可能需要更新的响应。

---

## Conclusion：让 Vectara 处理 RAG 的繁重工作

从零构建生产 RAG 系统意味着管理嵌入模型、向量数据库、重排序器、生成 LLM、幻觉检测器和监控——这是大多数产品团队无法承担的巨额工程投资。Vectara 将整个技术栈压缩为单次 API 调用，开箱即达 **90%+ 准确率**。

对于需要准确、受治理、有引用支持的 AI 响应而无需操作基础设施的团队，Vectara 是 2026 年最成熟的托管 RAG 平台。从免费层开始，索引你的第一个语料库，自己衡量准确率。

> **参与讨论：** 在我们的 [Telegram 群组](https://t.me/dibi8ai_zh) 分享你的 Vectara 部署结果——我们比较检索基准、分享语料库调优策略，每周评审摄取管道。

---

## Sources & Further Reading

- [Vectara 官方网站](https://vectara.com)
- [Vectara 文档](https://docs.vectara.com)
- [Vectara Ingest GitHub 仓库](https://github.com/vectara/vectara-ingest)
- [HHEM 幻觉评估模型 (Hugging Face)](https://huggingface.co/vectara)
- [Boomerang 嵌入模型论文](https://vectara.com/blog)
- [Mockingbird LLM 基准测试](https://vectara.com/blog/mockingbird)
- [Stanford HAI RAG 研究 2025](https://hai.stanford.edu)

---



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## Affiliate Disclosure

本文包含联盟链接。如果你通过我们的链接注册 [DigitalOcean](https://m.do.co/c/eca87ac14ee0)，我们会获得佣金，不会额外增加你的费用。我们只推荐用于自身部署的服务。Vectara 提供免费层，无需信用卡，所有摄取工具在 Apache-2.0 许可证下开源。
