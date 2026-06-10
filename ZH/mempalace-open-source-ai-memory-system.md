---
title: 'MemPalace：基准测试表现最佳的开源AI记忆系统，在LongMemEval上节省96.6%的R@5——零API调用'
description: 'MemPalace是一个本地优先的AI记忆系统，以逐字形式存储对话历史，并通过语义搜索进行检索。与Claude Code、Cursor、Windsurf及任何MCP兼容的智能体集成。基于ChromaDB后端，支持可插拔存储，零外部API调用。包含设置指南、基准测试和架构解析。'
date: 2026-06-10
slug: 'mempalace-open-source-ai-memory-system'
category: 'llm-frameworks'
tags: ['ai-memory', 'local-first', 'mempalace', 'semantic-search', 'chromadb', 'long-term-memory', 'mcp-agent', 'verbatim-storage']
github_repo: 'https://github.com/MemPalace/mempalace'
stars: 55206
maintainer: 'MemPalace'
license: MIT
featureImage: 'https://opengraph.github.com/github/MemPalace/mempalace'
lang: zh
---

# MemPalace：基准测试表现最佳的开源AI记忆系统，在LongMemEval上节省96.6%的R@5——零API调用

---

## 摘要

MemPalace是一个本地优先的AI记忆系统，它将对话历史以**逐字文本**形式存储，并通过语义搜索进行检索。它在LongMemEval上实现了**96.6%的原始R@5**成绩——这是任何开源记忆系统的最佳基准成绩，且**零API调用**。它专为希望AI智能体记住一切而不向任何外部服务发送数据的开发者设计。

|| 指标 | MemPalace | Mem0 | Memory Bank |
|--------|-----------|------|-------------|
|| 基准测试 | 96.6% 原始R@5 | 78.2% R@5 | 71.4% R@5 |
|| API调用 | 0 | 每次会话1-3次 | 每次会话5-8次 |
|| 存储方式 | 本地优先 | 依赖云端 | 混合 |
|| 安装方式 | `uv tool install mempalace` | `pip install mem0` | 仅Docker |

---

## 它是什么

MemPalace解决一个问题：**AI智能体会忘记你上周告诉它的内容。**

它将你的对话历史以逐字文本形式存储——不总结、不抽取、不复述。索引是结构化的：人物和项目成为*翼（wings）*，主题成为*房间（rooms）*，原始内容保存在*抽屉（drawers）*中——因此搜索可以限定范围，而不是在一个扁平语料库上运行。

检索层是可插拔的。当前默认是**ChromaDB**；可以更换其他后端而不触碰系统的其余部分。除非你主动选择加入，否则没有任何数据离开你的机器。

**关键功能：**
- 对话历史的逐字存储
- 带结构化索引（翼/房间/抽屉）的语义搜索
- 可插拔后端（默认ChromaDB，支持自定义后端）
- LongMemEval基准测试96.6%原始R@5
- 零外部API调用
- 与Claude Code、Cursor、Windsurf及任何MCP兼容的智能体集成

---

## 工作原理（30秒了解）

```
Your Conversation → MemPalace Index (Local)
                         ↓
                Semantic Search Query
                         ↓
              Retrieved Context (Wings/Rooms/Drawers)
                         ↓
              Agent Gets Structured Memory
```

MemPalace分为三个层级：

**第一层——存储：** 每条对话都以逐字形式存储。无需AI处理，无需总结。原文本被完全保留，与写入时一模一样。

**第二层——索引：** 对话被组织成一个知识图谱。人物和项目成为*翼*，主题成为*房间*，原始内容保存在*抽屉*中。这种结构化索引使得限定范围搜索成为可能，而不是扁平语料库搜索。

**第三层——检索：** 当智能体需要上下文时，它查询可插拔的检索层（默认：ChromaDB）。返回的结果是结构化上下文，而非原始文本。

检索层使用带有混合关键词增强的语义搜索。默认情况下，MemPalace使用ChromaDB和`all-MiniLM-L6-v2`嵌入模型，但你可以替换任何实现了`mempalace/backends/base.py`接口的后端。包括：

- `chromadb`：默认后端，适合大多数用例
- `qdrant`：大数据集更快，支持过滤
- `weaviate`：生产就绪，支持GraphQL查询
- 自定义后端：实现基础接口即可对接任何向量数据库

---

## 自动保存钩子

MemPalace可以自动保存来自受支持智能体的对话。对于Claude Code，你需要配置自动保存钩子：

```bash
# Enable auto-save for Claude Code
mempalace hooks enable claude-code

# View current hooks
mempalace hooks list

# Test the hooks
mempalace hooks test
```

这些钩子通过拦截智能体会话并将它们自动存储到你的记忆宫殿中来工作。这意味着你不需要手动保存对话——它们会在你工作时自动持久化。

---

## 系统要求

- Python 3.9+
- 使用`uv`或`pip`进行安装
- 嵌入模型和初始索引约需500MB磁盘空间
- ChromaDB运行约需500MB RAM（大数据集需要更多）

---

## 快速开始（60秒）

在隔离环境中安装MemPalace以避免PEP 668错误：

```bash
# Recommended: uv tool install (isolated on your PATH)
uv tool install mempalace

# Initialize for your project
mempalace init ~/projects/myapp

# Start Claude Code with mempalace hooks
claude
```

或使用pipx：

```bash
pipx install mempalace
mempalace init ~/projects/myapp
```

或在虚拟环境中安装（如果你需要`import mempalace`可用）：

```bash
python -m venv .venv && source .venv/bin/activate
pip install mempalace
mempalace init ~/projects/myapp
```

---

## 何时使用 / 何时跳过

**非常适合如果你…**
- 每天使用AI编程智能体，希望跨会话保持持久记忆
- 在多个智能体之间工作，希望通过MCP共享记忆
- 需要逐字回忆——原始内容始终可检索
- 希望零外部API调用以保护隐私

**可以跳过如果…**
- 只使用单一提供商的原生记忆，不需要跨智能体同步
- 在本地进程无法运行的沙盒环境中工作
- 需要跨团队成员的云端记忆共享

---

## 基准测试

MemPalace在LongMemEval上实现了**96.6%的原始R@5**——这是任何开源记忆系统的最佳基准成绩。

### LongMemEval结果

|| 模式 | R@5 | 需要的LLM | API调用 |
|------|-----|--------------|-----------|
|| **MemPalace（原始）** | **96.6%** | 无 | 0 |
|| MemPalace（混合v4） | 98.4% | 无 | 0 |
|| MemPalace（混合 + LLM重排） | ≥99% | 任何可用模型 | 1 |
|| Memory Bank（OpenAI） | 78.2% | Claude/GPT | 3-5 |
|| Mem0 | 71.4% | Claude/GPT | 1-2 |
|| 直接LLM上下文 | 65.3% | 不适用 | 不适用 |

*来源：[LongMemEval基准测试](https://github.com/MemPalace/mempalace)——在10K文档检索任务上测量，95%置信区间。*

### 为什么96.6%很重要

大多数记忆系统通过**上下文扩展**来达成成绩——将更多令牌塞入窗口。MemPalace通过**结构化检索**达成成绩：翼 → 房间 → 抽屉。你不是在问"我说过的一切"，而是在问"关于项目Y中人物X的一切"。

原始96.6%的成绩**不需要API密钥、不需要云端、不需要任何阶段的LLM**。混合管线添加了关键词增强、时间邻近增强和偏好模式提取；独立测试集的98.4%才是诚实的可泛化数字。

---

## 知识图谱架构

结构化记忆图谱是MemPalace的核心机密。

```
                    [Wing: Person]
                   /              \
           [Room: Project A]   [Room: Project B]
              /     \               |
        [Drawer: #1] [Drawer: #2] [Drawer: #3]
         (original)  (original)   (original)
```

**工作原理：**

1. **翼** = 人物、组织或大型项目
2. **房间** = 翼内的主题、功能或工作流
3. **抽屉** = 原始对话片段

这种结构使得限定范围搜索成为可能：

```bash
# Search across all wings
mempalace search "auth implementation"

# Search within a specific wing
mempalace search "auth" --wing "Person-A"

# Search within a room
mempalace search "auth" --wing "Person-A" --room "Project-A"
```

### 备份与恢复

由于MemPalace在本地存储数据，你应该定期备份你的记忆：

```bash
# 备份你的记忆宫殿
mempalace backup ~/backups/mempalace-$(date +%Y-%m-%d).tar.gz

# 从备份恢复
mempalace restore ~/backups/mempalace-2026-06-10.tar.gz

# 使用cron调度自动备份
0 2 * * * mempalace backup ~/backups/mempalace-$(date +\%Y-\%m-\%d).tar.gz
```

备份包括所有记忆文件、配置和缓存的嵌入模型。你可以通过复制备份并在另一台机器上运行`mempalace init`来注册恢复的数据。

---

## MCP服务器集成

MemPalace内置MCP服务器，用于与Claude Code、Cursor和其他MCP兼容的智能体配合使用。

```bash
# Start the MCP server
mempalace mcp --port 8765

# In Claude Code config (~/.claude/settings.json):
{
  "mcpServers": {
    "mempalace": {
      "command": "mempalace",
      "args": ["mcp", "--port", "8765"]
    }
  }
}
```

MCP服务器提供：
- `mempalace_store`：存储对话片段
- `mempalace_query`：通过语义搜索检索上下文
- `mempalace_list_wings`：列出可用的翼
- `mempalace_list_rooms`：列出翼内的房间

---

## 深入：Python API

如果你不使用MCP兼容的智能体，可以直接使用MemPalace的Python API：

```python
import mempalace

# Initialize memory store
memory = mempalace.Store("~/projects/myapp")

# Store a conversation segment
memory.store({
    "role": "user",
    "content": "How do I implement OAuth2 with Google?"
})
memory.store({
    "role": "assistant", 
    "content": "You'll need to create a Google Cloud project..."
})

# Query for relevant context
results = memory.query("OAuth2 Google implementation")
for result in results:
    print(f"[{result.wing}/{result.room}]: {result.content[:200]}")

# List all wings
for wing in memory.list_wings():
    print(f"Wing: {wing.name} ({len(wing.rooms)} rooms)")
```

Python API与CLI类似，但提供了对记忆图谱的程序化访问。这适用于：
- 自定义智能体集成
- 批量处理对话历史
- 构建记忆仪表板
- 自动化备份工作流

---

## Docker部署

用于服务器端或容器化部署：

```bash
# Build the Docker image
docker build -t mempalace-server .

# Run the MCP server in Docker
docker run -d \
  --name mempalace \
  -v /data:/data \
  -p 8765:8765 \
  mempalace-server \
  mcp --port 8765
```

所有内容都在`/data`下持久化（记忆宫殿、配置和缓存的嵌入模型），因此请在此挂载卷。此设置适用于：
- 共享团队记忆（多台机器访问同一数据库）
- 需要智能体记忆的CI/CD流水线
- 具有Docker编排的生产环境

---

## 与替代方案对比

|| 功能 | MemPalace | Mem0 | Memory Bank | 本地RAG |
|---------|-----------|------|-------------|-----------|
|| 逐字存储 | ✓ | ✗ | ✗ | ✗ |
|| 结构化索引 | 翼/房间/抽屉 | 扁平向量 | 聊天历史 | 嵌入 |
|| 需要API | 0 | 1-3 | 5-8 | 0 |
|| 本地优先 | ✓ | ✗ | ✗ | ✓ |
|| MCP服务器 | 内置 | 插件 | 无 | 无 |
|| 基准测试 | 96.6% R@5 | 78.2% | 71.4% | 不适用 |
|| Stars | 55,206 | 12,400 | 8,900 | 18,200 |

MemPalace的结构化方法（翼 → 房间 → 抽屉）正是推动96.6%基准成绩的原因。其他系统使用扁平向量搜索或令牌扩展的上下文窗口，在约200K令牌时会遇到实际限制。

## 局限性 / 诚实评估

MemPalace并非适合所有人：

- **不适合云端团队**：如果你需要跨在不同机器上工作的团队成员共享记忆，MemPalace的本地优先设计对此没有帮助
- **需要Python环境**：安装需要`uv`或`pip`以及兼容的Python版本
- **默认ChromaDB**：虽然可插拔，但大多数用户将使用ChromaDB，嵌入模型需要约500MB RAM
- **无云端备份**：你的记忆保持本地。如果你的磁盘故障，记忆将消失（除非你已备份）

它专为希望AI智能体拥有持久、私密记忆的**个人开发者**而构建。

---

## 实际用例

### 用例1：持久编码上下文

```bash
# Start a new Claude Code session
claude

# Claude Code automatically queries MemPalace for relevant context
# when you ask about previous work on the same feature
> "Remember when we implemented OAuth2 last week?"
> [MemPalace retrieves: Wing "Person-A" → Room "Project-A" → Drawer: #3]
```

这个用例非常适合在长期项目上工作的开发者，他们需要AI智能体记住之前的实现、决策和约束条件。

### 用例2：研究上下文

```bash
# Store research notes from your agent
mempalace store "Research: LangGraph vs LangChain for agent orchestration"
mempalace store "Key finding: LangGraph has better state management..."

# Later, query for all research notes
mempalace search "agent orchestration comparison" --wing "Research"
```

非常适合希望在多个研究会话之间维护可搜索知识库的研究人员。

### 用例3：团队知识库

```bash
# Share memory across team members (Docker deployment)
docker run -d \
  --name mempalace \
  -v /data:/data \
  -p 8765:8765 \
  mempalace-server mcp --port 8765

# Each team member connects to the shared memory server
# with different access levels per project
```

适合需要共享记忆但希望保持数据隐私和控制的团队。

---

## 常见问题

### 问1：MemPalace会把我的数据存储在云端吗？
不会。MemPalace是本地优先的。你的对话历史、记忆索引和嵌入都保留在你的机器上。默认情况下不会向外部服务发送API调用。

### 问2：我可以在任何AI智能体上使用MemPalace吗？
可以，只要它支持MCP（模型上下文协议）。Claude Code、Cursor、Windsurf和其他MCP兼容的智能体开箱即用。对于非MCP智能体，你可以直接使用Python API。

### 问3：96.6%的基准测试成绩与其他记忆系统相比如何？
MemPalace在LongMemEval上的96.6%原始R@5是开源记忆系统的最佳基准成绩。大多数竞争者通过上下文扩展（存储更多令牌）实现70-80%的成绩，而非结构化检索。

### 问4：我可以从ChromaDB切换到其他后端吗？
可以。检索层是可插拔的。默认是ChromaDB，但你可以替换任何实现了`mempalace/backends/base.py`的后端。支持自定义后端。

### 问5：如果我删除记忆文件会怎样？
由于MemPalace是本地优先的，没有云端恢复机制。如果你删除了记忆文件，数据就消失了（除非你已手动备份）。如果你的记忆很有价值，请考虑设置自动备份。

---

## 来源与延伸阅读

- 官方文档：[mempalaceofficial.com](https://mempalaceofficial.com)
- GitHub仓库：[MemPalace/mempalace](https://github.com/MemPalace/mempalace)
- 基准测试：[benchmarks/BENCHMARKS.md](https://github.com/MemPalace/mempalace/blob/main/benchmarks/BENCHMARKS.md)
- LongMemEval结果：[96.6% R@5原始](https://github.com/MemPalace/mempalace#benchmarks)
- MCP服务器文档：[mempalaceofficial.com/concepts/the-palace](https://mempalaceofficial.com/concepts/the-palace.html)

---

## 结论：构建真正拥有记忆AI智能体

MemPalace解决了"金鱼智能体"问题。它以逐字形式存储对话历史，进行结构化索引，并以96.6%的准确率检索——零API调用。

**立即尝试：**

```bash
uv tool install mempalace
mempalace init ~/projects/myapp
```

如需在VPS或专用服务器上自托管记忆，请使用[HTStack](https://my.htstack.com/aff.php?aff=27187)获取实惠的GPU托管服务，或使用[DigitalOcean](https://m.do.co/c/eca87ac14ee0)实现轻松的云部署。

加入 **dibi8中文Telegram群** https://t.me/DIBI8_Group/4，讨论AI记忆系统、智能体架构和开源工具。

相关文章：
- [LangChain完整指南](dibi8-internal-link/llm-frameworks/langchain-complete-guide)
- [向量数据库对比](dibi8-internal-link/data-science/vector-database-comparison)
- [MCP深度解析](dibi8-internal-link/llm-frameworks/mcp-deep-dive)

*以上部分链接为联盟链接。如果你通过链接注册，dibi8.com可能会获得佣金，而你无需支付额外费用。这有助于维持网站运行和内容免费。*