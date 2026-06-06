---
title: "MemPalace vs Mem0：96.6% 召回率测评！2026年最强开源 AI 记忆系统"
description: "MemPalace 是目前评测表现最好的开源 AI 记忆系统，51K+ Stars，免费且强大。本文详解其原理、安装与实战代码。"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Go
  - Python
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: ""
file_md5: ""
download_url: "https://github.com/MemPalace/mempalace"
backup_url: ""
github_repo: "https://github.com/MemPalace/mempalace"
stars: 0
maintainer: ""
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /zh/posts/mempalace/
faqs:
  - q: 'MemPalace 是什么？它如何赋予 AI 记忆能力？'
    a: 'MemPalace 是一款免费、开源、本地优先的 AI 记忆系统，它将你的对话和项目历史以原文形式存储，并通过语义搜索进行检索。它在模型之外建立了一个结构化的记忆层，让你的 AI 助手能够回忆起精确的历史上下文，而不必每次对话都从零开始。'
  - q: '如何安装 MemPalace？'
    a: 'MemPalace 是一个 Python 工具，可通过 uv（uv tool install mempalace）或 pip（pip install mempalace）安装。安装完成后，执行 mempalace init ~/projects/myapp 即可为你的项目进行初始化。'
  - q: 'MemPalace 与 Mem0 在召回准确率上有何差异？'
    a: '在 LongMemEval 基准测试中，MemPalace 报告的召回率为 96.6%，而 Mem0 为 89.2%。MemPalace 完全本地运行，无需任何 API 调用；而 Mem0 则需要付费的 OpenAI API。'
  - q: 'MemPalace 如何组织存储的记忆？'
    a: 'MemPalace 采用宫殿隐喻，分三个层级：Wings（翼）对应人员和项目，Rooms（室）对应项目内的主题，Drawers（抽屉）则以原文保存具体内容。这种结构让你可以将搜索范围精确限定在某个项目翼区或主题室，而无需查询一个扁平的向量数据库。'
  - q: 'MemPalace 能与 Claude Code 及其他 AI 工具配合使用吗？'
    a: '可以。MemPalace 原生提供多个插件，包括：面向 Claude Code 的 .claude-plugin 目录、面向 OpenAI Codex 的 .codex-plugin 目录、面向 MCP 兼容工具的 .agents/plugins 目录，以及对 Gemini CLI 和本地模型的支持。它开箱即暴露一个兼容 MCP 的端点，可用于持久化编程智能体的记忆。'
---

{</* resource-info */>}

# MemPalace：让你的 AI 助手永远记得你是谁

> 如果每次开启新对话，AI 都把你当成陌生人，那它还算不上真正的助手。MemPalace 解决了这个痛点。

## 极限测评对比：MemPalace vs Mem0 vs Mastra
评估 AI 记忆系统时，性能和资源消耗是核心。以下是 MemPalace 在权威的 **LongMemEval** 测评基准中的碾压级表现：

| 核心指标/特性 | MemPalace | Mem0 | Mastra | Hindsight |
| :--- | :--- | :--- | :--- | :--- |
| **上下文召回率** | **96.6%** | 89.2% | 85.5% | 91.0% |
| **API 调用依赖**| **零 (纯本地)** | 依赖 OpenAI API (付费) | 依赖 Anthropic API | 零依赖 |
| **存储底层架构**| 原文精准存储 + 向量检索 | 仅向量检索 | 图数据库 + 向量 | 仅向量检索 |
| **Claude Code 集成**| 完美原生支持 (MCP) | 需手动修改源码 | 支持 | 不支持 |


## 为什么 AI 需要长期记忆？

当前主流大模型（GPT-4、Claude、DeepSeek 等）的上下文窗口虽然越来越长，但**会话隔离**问题始终存在：

- 你昨天告诉 AI 自己乳糖不耐受，今天它推荐了一杯拿铁。
- 你花了半小时讲解项目背景，重启对话后一切归零。
- 你希望 AI 用简洁风格回复，但每次都要重新叮嘱。

**MemPalace** 是一个开源的 AI 记忆系统，核心目标只有一个：让 AI 助手能够记住长期对话历史、用户偏好和上下文信息。它在 GitHub 已获得 **51,745 Stars**，官方标语是 *"The best-benchmarked open-source AI memory system. And it's free."*

## MemPalace 的核心能力

| 能力 | 说明 |
|------|------|
| **长期记忆存储** | 自动提取对话中的关键信息，持久化到向量数据库 |
| **智能记忆检索** | 根据当前查询语义，召回最相关的历史记忆片段 |
| **用户画像构建** | 累积用户偏好、习惯、背景，形成动态用户模型 |
| **多会话连贯** | 跨会话保持上下文一致性，告别"每次重新认识" |
| **轻量易集成** | 提供 Python SDK 和 REST API，5 分钟接入现有项目 |

## 快速开始

### 1. 安装

```bash
pip install mempalace
```

### 2. 初始化记忆系统

```python
from mempalace import Memory Palace

# 初始化记忆宫殿
mp = MemoryPalace(
    backend="chroma",        # 支持 chroma / milvus / pgvector
    embedding_model="BAAI/bge-small-en-v1.5",
    collection_name="user_001"
)
```

### 3. 存储记忆

```python
# 从对话中提取并保存关键信息
mp.remember(
    content="用户张三对乳糖不耐受，不能饮用含乳制品的咖啡。",
    tags=["饮食禁忌", "健康"],
    importance=0.9
)

mp.remember(
    content="用户偏好简洁直接的回答风格，避免冗长解释。",
    tags=["沟通风格", "偏好"],
    importance=0.8
)
```

### 4. 检索记忆

```python
# 在新对话开始前，自动召回相关记忆
memories = mp.recall(
    query="推荐一款适合用户的下午茶饮品",
    top_k=3,
    min_relevance=0.75
)

for m in memories:
    print(f"[记忆召回] {m.content} (相关度: {m.score:.2f})")
```

### 5. 注入系统提示

```python
# 将召回的记忆注入到系统提示中，让 LLM "想起"用户
system_prompt = f"""你是一位贴心的 AI 助手。以下是你对当前用户的已知信息：

{mp.format_memories(memories)}

请基于以上背景，用用户偏好的风格回答问题。"""

response = llm.chat(system=system_prompt, user="我想点杯喝的，有什么推荐？")
```

## 架构亮点

MemPalace 在设计上做了几个关键取舍：

1. **记忆分层**：区分"事实记忆"（用户基本信息）和"情景记忆"（具体对话事件），检索时动态加权。
2. **重要性衰减**：低频访问的记忆逐渐降级，避免噪声干扰；高频强相关记忆自动置顶。
3. **隐私优先**：本地向量数据库运行，数据不出境；支持端到端加密存储。
4. **模块化后端**：ChromaDB 适合本地原型，Milvus / PGVector 适合生产规模。

## 与其他方案对比

| 方案 | 开源 | 本地部署 | 记忆粒度 | Stars |
|------|------|----------|----------|-------|
| MemPalace | ✅ | ✅ | 句子级 | 51K+ |
| MemGPT | ✅ | ✅ | 会话级 | 12K+ |
| 商业 API 记忆 | ❌ | ❌ | 会话级 | — |

MemPalace 的**句子级记忆提取**意味着它能精准定位到"用户讨厌香菜"这样的原子事实，而不是把整个会话打包存储，召回准确率更高。

## 适用场景

- **个人 AI 助手**：长期陪伴型聊天机器人，越用越懂你。
- **客服系统**：记住客户历史工单和偏好，提升服务体验。
- **写作/编程助手**：记住你的代码风格、常用框架、项目结构。
- **教育辅导**：追踪学生知识薄弱点，个性化推荐练习。

## 结语

MemPalace 用开源和免费的方式，把"AI 长期记忆"这一高门槛能力民主化。如果你正在构建需要持续关系的 AI 应用，它值得作为基础设施层优先考虑。

GitHub 仓库：[github.com/MemPalace/mempalace](https://github.com/MemPalace/mempalace) — 51,745 Stars 且持续增长。

---

## Related Articles


- [构建持久化 AI Agent：记忆、工具与规划](/resources/llm-frameworks/hello-agents-ai-agent-building-tutorial/)

---


---

## 推荐工具

跑或部署开源 AI 工具时，推荐：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心，AI 工作流 droplet 一键部署。
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Claude / OpenAI / DeepSeek API 中转。上面的 AI 工具 (chatbot / 代码生成 / 翻译 / 搜索 等) 大多需要 LLM API key — 这个中转给你稳定访问顶级模型, 价格约官方 30%。

*推广链接 — 不增加你的成本，能支持 dibi8.com 持续运营。*

*本文首发于 [dibi8.com](https://dibi8.com)，转载请注明出处。*

## FAQ：MemPalace 生产环境避坑指南

**Q: 运行 MemPalace 需要多少 RAM 内存？ (how much RAM for MemPalace)**
A: 它做了极致优化。普通测试 8GB 内存即可丝滑运行；但如果是生产环境，挂载成千上万个长期对话 Session，推荐使用 16GB 或更高。

**Q: 我能把 MemPalace 接入给 Claude Code 当记忆库吗？**
A: 完全可以！它开箱即支持 MCP (Model Context Protocol) 接口，能让你的 Claude Code 编程智能体拥有永久记忆。

**Q: 本地记忆存储该选 ChromaDB 还是 Pinecone？**
A: 必须是 ChromaDB！MemPalace 内置 ChromaDB 实现了零延迟和零网络请求成本，对于注重代码隐私的本地 Agent 工作流来说，远超需要联网的 Pinecone。
