---
title: 'GraphRAG：微软基于知识图谱的 RAG，让大模型答得更准（33K Stars）——2026 实战指南'
description: 'GraphRAG 是微软推出的模块化、基于知识图谱的 RAG 系统（33,403 个 GitHub star，MIT 协议）。本指南讲解安装、init/index/query 工作流、真实 CLI 示例，以及与 LangChain、Haystack 的诚实对比。'
date: 2026-06-02 00:00:00+08:00
lastmod: 2026-06-02 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'microsoft/graphrag'
stars: 33403
maintainer: 'microsoft'
last_maintained: '2026-06-02'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: []
aliases:
- /posts/graphrag-llm-frameworks-2026/
faqs:
  - q: '怎么安装 graphrag？'
    a: '从 PyPI 一条命令搞定（Python 3.10–3.12）： ```bash pip install graphrag ```'
  - q: '运行 graphrag 的系统要求是什么？'
    a: 'GraphRAG 需要 Python 3.10–3.12，以及通过 API key 访问一个语言模型（OpenAI、Azure OpenAI 或其他受支持的供应商）。任何支持 Python 的现代操作系统都能运行。'
  - q: '我可以为这个项目做贡献吗？'
    a: '可以。项目以 MIT 协议开源，欢迎贡献。贡献指南见 GitHub 上的 [CONTRIBUTING.md](https://github.com/microsoft/graphrag/blob/main/CONTRIBUTING.md) 文件。'
  - q: '怎么报告问题或 bug？'
    a: '用仓库的 GitHub Issues 页面。请尽量提供详细信息——错误消息、你的配置，以及复现问题的步骤。'
  - q: 'GraphRAG 和普通的向量 RAG 有什么区别？'
    a: '普通 RAG 取回几个相似文本块再据此作答。GraphRAG 在此之外，还会从你的文档中构建知识图谱和社区摘要，因此它既能回答宽泛的、语料库级的问题（全局搜索），也能回答聚焦实体的问题（局部搜索）。'
---

{{< resource-info >}}

## 引言

经典的检索增强生成（RAG）是按向量相似度取回若干文本块，再塞进提示词里。这套做法应付事实查找类问题没问题，但碰到需要"把散落线索串起来"、横跨整个语料库的问题就力不从心了。微软的 `graphrag` 走了另一条路：它用大模型从文档中抽取出一张由实体和关系构成的**知识图谱**，在图谱之上构建社区摘要，然后基于这套结构来回答问题。它在 GitHub 上有超过 33,403 个 star，采用 MIT 协议，是近两年关注度最高的 RAG 项目之一。本指南将带你安装 GraphRAG，跑通它真实的 `init` / `index` / `query` 工作流，并诚实地判断它是否适合你的场景。

## graphrag 是什么？

GraphRAG 是一套模块化、基于图谱的检索增强生成流水线。它不把文档当成一堆零散的文本块，而是用语言模型去读文本、抽取出实体以及实体之间的关系，再组装成一张知识图谱。随后它把图谱聚类成若干社区，并为每个社区生成摘要。

该项目由微软研究院（Microsoft Research）维护，用 Python 编写。它以命令行工具和 Python 库的形式分发，通过一个 `settings.yaml` 文件进行配置。最终它能回答那些宽泛的、覆盖整个语料库的问题（"这批文档里贯穿始终的主题有哪些？"）——而这类问题恰恰是普通向量 RAG 容易答不全的。

## graphrag 如何工作

GraphRAG 把问题拆成离线的索引阶段和在线的查询阶段：

1. **索引阶段**：GraphRAG 先把源文档切块，然后让大模型从每个文本块中抽取实体、关系和论断。这些信息被合并成一张知识图谱。图谱再被划分成若干社区（使用 Leiden 算法），由大模型为每个社区撰写一份摘要报告。

2. **查询——全局搜索（Global Search）**：对于关于整个语料库的宽泛问题，GraphRAG 以 map-reduce 的方式利用社区摘要：先在大量社区报告上做推理，再把各部分的答案汇总成最终回应。

3. **查询——局部搜索（Local Search）**：对于聚焦于某个具体实体的问题，GraphRAG 会取回该实体的邻居、关系以及相关的原文，再生成一个有针对性的答案。

这种双模式设计正是 GraphRAG 与普通向量库的分水岭：全局搜索给你全景，局部搜索给你细节。

## 安装与配置

要把 graphrag 当成定时跑的生产任务，你需要一台常开的机器——可以在 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) 上开一台（新账户有免费试用额度），或者用 [HTStack](https://my.htstack.com/aff.php?aff=27187) 的低延迟香港 VPS（与托管 dibi8.com 的是同一家 IDC）。

GraphRAG 需要 Python 3.10–3.12。推荐通过 pip 安装：

```bash
pip install graphrag
```

装好后，初始化一个工作区。这一步会创建 GraphRAG 所需的配置文件和目录结构：

```bash
mkdir -p ./ragtest/input
# put your .txt or .csv documents into ./ragtest/input
python -m graphrag init --root ./ragtest
```

`init` 命令会在项目根目录生成一个 `settings.yaml` 和一个 `.env` 文件。打开 `.env`，填入你的模型 API key，例如：

```bash
GRAPHRAG_API_KEY=<your-openai-or-azure-key>
```

### 常见报错与修复

第一次运行最常见的问题是 API key 缺失或为空。如果索引一启动就报认证错误，请确认 `./ragtest/.env` 里已设置 `GRAPHRAG_API_KEY`，并且 `settings.yaml` 中的模型名称是你的 key 确实能访问到的模型。把配置里的模型换成你账户可用的那个，通常就能解决。

## 核心用法

`init` 之后，典型流程是：把文档放进 input 目录，建立索引，然后查询。

### 第一步：建立索引

在工作区上运行索引流水线。这一步开销最大——它会发起大量大模型调用来抽取图谱：

```bash
python -m graphrag index --root ./ragtest
```

跑完后，GraphRAG 会把实体图谱、社区报告和嵌入向量以 Parquet 文件的形式写到 `./ragtest/output` 目录下。

### 第二步：全局搜索

当问题宽泛、覆盖整个语料库、需要跨多篇文档综合时，用全局搜索：

```bash
python -m graphrag query \
  --root ./ragtest \
  --method global \
  --query "What are the major themes in these documents?"
```

### 第三步：局部搜索

当问题聚焦于某个具体实体或语料库的某一小块时，用局部搜索：

```bash
python -m graphrag query \
  --root ./ragtest \
  --method local \
  --query "What is the relationship between Entity A and Entity B?"
```

`init`、`index`、`query` 这三条命令就覆盖了 GraphRAG 的核心闭环。关于配置项、提示词调优和进阶设置，请参阅官方文档：[https://microsoft.github.io/graphrag/](https://microsoft.github.io/graphrag/)

## 集成

由于索引产出的是标准 Parquet 文件（实体、关系、社区报告以及文本单元的嵌入向量），GraphRAG 能干净地融入 Python 数据生态的其余部分。

### 直接处理产出文件

你可以用 pandas 直接加载生成的图谱和报告，用于检查、自定义检索或下游分析：

```python
import pandas as pd

entities = pd.read_parquet("./ragtest/output/entities.parquet")
relationships = pd.read_parquet("./ragtest/output/relationships.parquet")
community_reports = pd.read_parquet("./ragtest/output/community_reports.parquet")

print(entities.head())
print(community_reports[["title", "summary"]].head())
```

### 通过 settings.yaml 自定义

GraphRAG 的行为由 `init` 创建的 `settings.yaml` 文件控制。在里面你可以选择对话模型和嵌入模型、设置切块大小、调节并发，并指定输入数据。一段简化后的片段如下：

```yaml
models:
  default_chat_model:
    type: openai_chat
    model: gpt-4o-mini
  default_embedding_model:
    type: openai_embedding
    model: text-embedding-3-small

chunks:
  size: 1200
  overlap: 100

input:
  type: file
  file_type: text
  base_dir: "input"
```

改这个文件，就是你让 GraphRAG 适配不同模型供应商、不同文档类型或不同切块策略的方式——无需改动任何代码。

## 真实场景应用

GraphRAG 由微软研究院开发、采用 MIT 协议，已被用于知识库、研究和分析类工作负载——这些场景的问题往往横跨整个语料库，而不是局限于单篇文档。

### 它的强项

"图谱 + 社区摘要"这套打法，在你需要对大量文本做"意义梳理（sensemaking）"时最有价值——比如归纳一批报告中贯穿的主题、追踪实体在多篇文档间的关联，或回答证据散落在整个语料库各处的问题。在这类场景里，GraphRAG 的全局搜索往往能给出比"只看 top-k 几个文本块"的基线向量 RAG 更全面的答案。

### 成本意识

索引阶段非常吃大模型：GraphRAG 会反复调用模型来抽取实体和关系、撰写社区报告，因此成本会随语料库规模和你选的模型而上升。很多团队会先用一个更小、更便宜的对话模型（比如 `gpt-4o-mini`）来控制索引成本，再评估对自己的数据来说是否值得换用更强的模型。

## 与替代方案对比

也可以看看我们对[相关开源工具](dibi8-internal-link)的报道。

GraphRAG、LangChain 和 Haystack 解决的问题有重叠，但侧重不同。GraphRAG 是一套专注、有明确取向的图谱 RAG 流水线；LangChain 和 Haystack 则是用于构建各类 LLM 应用和 RAG 流水线的通用框架。下表只是一个大致的方位参考，并非正面跑分——star 数和 issue 数会随时间变化，请当作近似值看待。

| 特性 | **GraphRAG** | **LangChain** | **Haystack** |
|---|---|---|---|
| 主要定位 | 基于图谱的 RAG 流水线 | 通用 LLM 应用框架 | RAG / 搜索框架 |
| 语言 | Python | Python | Python |
| 协议 | MIT | MIT | Apache-2.0 |
| 维护方 | 微软 | LangChain, Inc. | deepset |
| 内置知识图谱抽取 | 内置 | 需借助集成 | 需借助集成 |
| 全局（语料库级）查询 | 支持 | 非内置 | 非内置 |
| 开箱即用的覆盖广度 | 窄（只做图谱 RAG） | 非常广 | 广 |
| 文档 | 完善 | 完善 | 完善 |

### 为什么选 GraphRAG？

- **为语料库级问题而生**：它的全局搜索和社区摘要专为"整体上有哪些主题？"这类普通向量 RAG 很难处理的问题而设计。
- **自带图谱抽取**：实体和关系的抽取是流水线的一部分，不用你自己拼装。
- **微软研究院背书**：开发活跃、文档扎实，并持续有研究驱动的改进。

### 需要权衡之处

如果你只是需要做 top-k 检索来回答简短的事实性问题，那么用 LangChain 或 Haystack 配一个向量库会更轻量、运行成本也更低。GraphRAG 那笔额外的索引开销，专门在"语料库的*结构*本身对答案很重要"时才划得来。

## 局限与诚实评估

对路的活儿 GraphRAG 是把好手，但它有实打实的取舍：

1. **索引很烧钱**：构建图谱要发起大量大模型调用，所以成本和耗时都会随语料库规模增长。这是最需要提前算账的一项。
2. **配置要下功夫**：要拿到好结果，往往得在 `settings.yaml` 里调切块大小、提示词和模型选择。它不是一行就能接入的方案。
3. **简单查找用它是杀鸡用牛刀**：对于答案就在单个文本块里的窄问答，经典向量 RAG 更快、也便宜得多。
4. **运维负担**：你要管理一条索引流水线及其 Parquet 产出，文档变化时还得定期重建索引。
5. **质量看模型**：实体和关系抽取的质量取决于你配置的对话模型的强弱，这就把答案质量直接绑到了你的模型预算上。

在判断 GraphRAG 是否适合你的具体场景时，这些取舍是要重点掂量的。

## 结语

GraphRAG 是微软研究院出品的一套维护良好、模块化、基于图谱的 RAG 系统，GitHub 上有超过 33,403 个 star，用 Python 编写，采用 MIT 协议。它的强项是回答那些证据散落在整个语料库中的问题——这正是普通向量 RAG 的短板。代价则是索引成本和配置投入。一个不错的下一步：拿一小份文档跑一遍 `python -m graphrag init`，把全局搜索的答案和你现有的 RAG 方案比一比。

- 加入 [dibi8 英文 Telegram 群](https://t.me/DIBI8_Group/2)，获取开源 AI 工具速递。
- 接着读：[dibi8 上的相关指南](dibi8-internal-link)。

---

**来源与延伸阅读**：
- GitHub 仓库：https://github.com/microsoft/graphrag
- 官方文档 / README：https://github.com/microsoft/graphrag#readme

*以上部分链接为联盟（affiliate）链接。如果你通过它们注册，dibi8.com 可能获得一笔佣金，你无需额外付费。这有助于维持网站运转、让内容保持免费。*

<!-- internal-link-candidates:
  related open-source tools -> ai-tools-directory
  related guides on dibi8 -> ai-coding-agent-landscape-2026-skills-mcp-opensource
-->
