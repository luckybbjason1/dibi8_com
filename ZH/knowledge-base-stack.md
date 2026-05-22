---
title: '知识库 Stack 2026：用 AnythingLLM + RAGFlow + mem0 搭"第二大脑"（$10-25/月）'
description: '5 组件自托管知识库 stack，给个人或团队用。AnythingLLM（UI + RAG）+ RAGFlow（深度文档解析）+ mem0（agent 记忆）+ AgentMemory MCP（暴露给 MCP host）+ 向量库选型。替代 $50-200/月 SaaS（Notion AI + Mem + Glean），$10-25/月自托管。'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Docker
  - Python
  - PostgreSQL
  - Redis
application_domain: Collections
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
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['collections']
tags: ['知识库', 'RAG', '第二大脑', 'Stack', '合集']
aliases:
  - /posts/knowledge-base-stack/
---

你有 500 个 PDF、2000 条笔记、10 年邮件，但编辑器里的 AI 一个都不知道存在。Notion AI 每座 $10/月还看不到本地文件。Glean 每年起步 $30k。Mem.ai 不错但是 SaaS —— 你的"第二大脑"住在别人的硬件上。

这个合集组装的是**5 组件自托管知识库 stack**，吃下所有东西（PDF / 笔记 / 网页 / 代码），本地向量化，让你用 chat + API 查询，并通过 MCP 暴露给 AI 编程 agent —— **月成本 $10-25**。

## TL;DR —— Stack 全貌

| # | 组件 | 角色 | 为什么 | 深度指南 |
|---|---|---|---|---|
| 1 | **AnythingLLM** | 一体化 RAG UI + 文档管理 + chat 界面 | "前门" —— 你和团队实际点进去的地方 | [AnythingLLM 本地 RAG 架构](/zh/resources/llm-frameworks/anythingllm-architecture-local-rag/) |
| 2 | **RAGFlow** | 深度文档解析（表格、公式、多栏 PDF）| AnythingLLM 解析停在"够用"，RAGFlow 处理硬文档 | [RAGFlow 指南](/zh/resources/llm-frameworks/ragflow/) |
| 3 | **mem0** | agent 持久化语义记忆层 | 跨 session "记住关于用户的事实"长期记忆 | [mem0 设置](/zh/resources/llm-frameworks/mem0/) |
| 4 | **AgentMemory MCP** | 把 mem0 暴露给任意 MCP host（Claude Desktop / OpenCode / Cursor）| 让编程 agent 通过 MCP 协议共享知识库 | [AgentMemory MCP](/zh/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/) |
| 5 | **向量库**（Chroma / Qdrant / Weaviate）| embedding 存储 + 相似搜索后端 | 看场景挑 —— 见 [向量库对比](/zh/resources/llm-frameworks/vector-database-comparison/) | [向量库对比 2026](/zh/resources/llm-frameworks/vector-database-comparison/) |

**月成本总计**（单干，10 GB 文档）：**$10-15** • **小团队（10 GB，5 用户）**：**$15-25** • **组织（100 GB，50 用户）**：**$60-150**

对比 SaaS 等价物：Notion AI + Mem + Glean Lite = 单干到小团队 $50-200/月。

## 1. 为什么 2026 该自托管知识库

三件事汇聚：

1. **本地 embedding 模型到生产质量** —— `nomic-embed-text` 和 `bge-large` 跑在 4GB VPS 上，embedding 速度 200 文档/分，检索 sub-100ms。不再需要"把数据发给 OpenAI 做 embedding"
2. **MCP 标准化了 agent 到知识库的集成** —— 一旦你的知识库说 MCP，所有 AI 编程 agent（Claude Desktop / OpenCode / Cursor / Continue）都能查它，不用写定制集成代码。见 [MCP server 注册中心指南](/zh/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) 看协议细节
3. **RAGFlow 把企业级文档解析开源了** —— 多栏 PDF / 合并单元格表格 / 嵌入公式。每个"自建 RAG" stack 都死在这步，现在解决了

堆这三个 —— 本地 embedding + MCP 暴露 + RAGFlow 级解析 —— "我就用 Notion AI" 的决策对于有隐私顾虑或 > 5 GB 源文档的用户翻转了。

## 2. 架构总览

```
   ┌────────────────────────────────────────────────────┐
   │ VPS ($10-25/月)                                     │
   │                                                    │
   │  ┌────────────────────────────────────────────┐   │
   │  │ AnythingLLM（Web UI）                       │   │
   │  │   ↕                                         │   │
   │  │   文档 → embedding 管线                    │   │
   │  └────────────┬───────────────────────────────┘   │
   │               │                                    │
   │   "硬 PDF"    │  "易文档"                          │
   │       ↓       │       ↓                            │
   │  ┌─────────┐  │  ┌──────────────┐                  │
   │  │ RAGFlow │  │  │（AnythingLLM │                  │
   │  │ 解析器  │  │  │  内置）      │                  │
   │  └────┬────┘  │  └──────┬───────┘                  │
   │       └───────┴─────────┘                          │
   │               ↓                                    │
   │      ┌────────────────┐                            │
   │      │ 向量库          │                           │
   │      │（Chroma 本地）│                              │
   │      └────────┬───────┘                            │
   │               ↓                                    │
   │  ┌─────────────────────────────────┐               │
   │  │ 查询路由                         │               │
   │  │   ├─► AnythingLLM chat UI       │               │
   │  │   ├─► mem0（agent 记忆层）      │               │
   │  │   └─► AgentMemory MCP server    │               │
   │  │         ↓                        │               │
   │  │    （Claude / Cursor / OpenCode）│               │
   │  └─────────────────────────────────┘               │
   └────────────────────────────────────────────────────┘
```

分工：AnythingLLM 是用户前门，RAGFlow 处理 AnythingLLM 解析器搞不定的文档，向量库是共享检索后端，mem0 + AgentMemory MCP 把同一份知识暴露给 AI 编程 agent。

## 3. 组件 1 —— AnythingLLM（前门）

**角色**：你和团队实际点进去的东西。文档上传、workspace 组织、跟文档 chat、用户管理 —— 一个自托管 app 全包。

**为什么选它**：28k+ stars，单 Docker 容器 10 分钟部署，是所有开源 RAG 工具里 Web UI 最精美的。chat 后端支持 40+ LLM provider（Ollama / DeepSeek / Claude / GPT-5 / OpenRouter），成本灵活性留住。

**快装**：
```bash
docker run -d --name anythingllm \
  -p 3001:3001 \
  -v anythingllm-storage:/app/server/storage \
  -e LLM_PROVIDER=ollama \
  -e EMBEDDING_ENGINE=native \
  mintplexlabs/anythingllm:latest
```

开 `http://your-vps:3001`，建 workspace，拖 PDF 进去。内置解析器搞 80% 文档。剩 20% 路由给 RAGFlow（下个组件）。

**完整设置**（团队认证 / workspace 结构 / LLM provider 路由）：[AnythingLLM 本地 RAG 架构](/zh/resources/llm-frameworks/anythingllm-architecture-local-rag/)。

## 4. 组件 2 —— RAGFlow（深度文档解析）

**角色**：AnythingLLM 内置解析器对某个文档输出垃圾时 —— 多栏 PDF / 扫描论文 / 复杂表格 / 公式重的学术 paper —— RAGFlow 接手。

**为什么选它**：RAGFlow 的 "DeepDoc" 解析器对每页用视觉模型，保留表格结构（合并单元格、嵌套行），按语义块而非 token 数 chunk 文档。结果是硬文档检索准确率提升 3-5×。

**快装**：
```bash
docker compose -f https://github.com/infiniflow/ragflow/raw/main/docker/docker-compose.yml up -d
# Web UI :80, API :9380
```

**工作流模式**：AnythingLLM 是日常 driver。某个文档检索质量下降时，过一遍 RAGFlow 重处理，把解析好的 chunk 存回共享向量库。

**完整 RAGFlow 设置**（DeepDoc 调优 + 管线集成）：[RAGFlow 指南](/zh/resources/llm-frameworks/ragflow/)。

## 5. 组件 3 —— mem0（agent 记忆层）

**角色**：跨 chat session 和跨 agent 持久化的语义记忆。"记住用户用 Tailwind v4，auth 在 `src/lib/auth.ts`" —— 任何跟 mem0 说话的 agent 下个 session / 下个月 / 明年都拿到这个事实。

**为什么选它**：30k+ stars。专为 agent 记忆设计（不是通用向量库）。自动从对话提取事实、去重、老事实自然衰减。

**快装**：
```bash
pip install mem0ai
# 或作为 service:
docker run -d --name mem0 -p 8765:8765 \
  -e VECTOR_DB=chroma \
  mem0ai/mem0-server:latest
```

**用法**：把 mem0 接成 AnythingLLM workspace 的 writeback 层。每次 chat 对话自动提炼成 mem0 事实。你的 AI 编程 agent（下个组件）就同时拿到文档语料 AND 对话提取的事实。

**完整 mem0 设置**（embedding 模型选 + 衰减策略调）：[mem0 设置指南](/zh/resources/llm-frameworks/mem0/)。

## 6. 组件 4 —— AgentMemory MCP（接编程 agent 的桥）

**角色**：把 mem0（可选还有 AnythingLLM 向量库）暴露给任意 MCP host —— Claude Desktop / OpenCode / Cursor / Continue / Hermes Agent。你的知识库现在说每个现代 AI 编程 agent 都懂的协议。

**为什么这关键**：没 MCP 时，把定制知识库集成进每个 AI 编程工具需要每个工具一份定制代码。有 AgentMemory MCP 时，在 `claude_desktop_config.json` 加一次，每个 MCP 感知的 agent 都拿到它。

**快装**：
```bash
npm install -g @mem0/mem0-mcp
# 加到 OpenCode / Claude Desktop MCP config:
# { "agentmemory": { "command": "mem0-mcp", "env": { "MEM0_URL": "http://localhost:8765" } } }
```

**效果**：你的编程 agent 现在能回答"基于我们的项目文档和过往对话，新 auth 流程应该怎么设计？" —— 带引用，引用同时来自 PDF 和过往决策。

**完整设置**（团队共享 AgentMemory MCP）：[AgentMemory MCP 指南](/zh/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/)。

## 7. 组件 5 —— 向量库选型

**角色**：AnythingLLM / RAGFlow / mem0 三家背后的共享 embedding 存储后端。

**三个可行选择**（完整对比：[向量库对比 2026](/zh/resources/llm-frameworks/vector-database-comparison/)）：

- **Chroma** —— 单干 / 小团队最佳。单文件 SQLite 式简单。嵌入模式 = 零额外服务。AnythingLLM 默认
- **Qdrant** —— 生产团队最佳。Rust 写的，sub-10ms 延迟，水平扩展。Docker compose 跑起来
- **Weaviate** —— 需要混合搜索（向量 + 关键词）时最佳。运维更重但检索模式更强

**默认推荐**：从 Chroma 起（AnythingLLM 已内置）。语料 > 100 GB 或查询延迟 > 200ms 时迁 Qdrant。

```bash
# 超出 Chroma 时上 Qdrant:
docker run -d --name qdrant -p 6333:6333 -p 6334:6334 \
  -v qdrant-storage:/qdrant/storage \
  qdrant/qdrant:latest
```

## 8. Day 1 安装顺序（90 分钟）

1. **开 VPS**（10 分）—— 订一个 {{< aff "digitalocean" "kb-vps" "DigitalOcean $12/月 droplet" >}}（8 GB 档；4 GB 不够跑解析 + embedding + LLM），装 Docker
2. **先 AnythingLLM**（15 分）—— 单 docker run，浏览到 :3001，建管理员账号 + 第一个 workspace
3. **上传 10 个测试文档**（10 分）—— PDF / .md 笔记 / .docx 混杂 —— 看 AnythingLLM 内置解析器搞得定哪些
4. **第二 RAGFlow**（20 分）—— docker compose，浏览到 :80，重处理 2-3 个 AnythingLLM 搞不定的文档
5. **第三 mem0**（10 分）—— pip install + 作为 service 跑，指向 AnythingLLM 用的 Chroma 实例
6. **第四 AgentMemory MCP**（10 分）—— npm install，加到 Claude Desktop / OpenCode config
7. **测全管线**（15 分）—— 文档传 AnythingLLM → chat → mem0 抓取事实 → 在 Claude Desktop 通过 MCP 问同问题 → 引用两个来源

90 分钟后你有 $12/月 droplet 上的个人 Glean 等价物。

## 9. 成本拆解

| 项 | 单干（10 GB 文档）| 小团队（10 GB，5 用户）| 组织（100 GB，50 用户）|
|---|---|---|---|
| VPS | $12（8 GB）| $24（16 GB）| $120（64 GB + 副本）|
| AnythingLLM | $0（自托管）| $0 | $0 |
| RAGFlow | $0（自托管）| $0 | $0 |
| mem0 / AgentMemory MCP | $0（自托管）| $0 | $0 |
| 向量库（Chroma → Qdrant）| $0 | $0 | $0（Qdrant 自托管）|
| Embedding（本地 Ollama bge-large）| $0 | $0 | $0 |
| Chat LLM（DeepSeek 跑便宜，Claude 跑硬任务）| $0-5 | $0-10 | $20-30 |
| 备份存储 | $1 | $2 | $20 |
| **总计** | **~$13-18/月** | **~$26-36/月** | **~$160-170/月** |

对比 SaaS 等价物：
- 单干：Notion AI（$10）+ Mem.ai（$15）= $25/月，看不到本地文件
- 小团队：同 × 5 用户 = $125/月
- 组织：Glean Lite ~$30/用户/月 × 50 = $1500/月

## 10. 升级路径

超过这个 stack 时：

- **语料 > 1 TB 或 > 1000 万文档** —— Qdrant 上独立 32 GB 机器，加分片
- **多地区团队** —— AnythingLLM 多地区只读副本，单写 master 上 {{< aff "htstack" "upgrade-hk-vps" "HTStack HK" >}} 给中国友好延迟
- **要全文 + 向量混合** —— 向量库从 Chroma 迁到 Weaviate
- **审计 / SOC2 合规** —— 配 Portkey 做 LLM 调用可观测性（看 [LLM Gateway 对比 2026](/zh/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/)）
- **多租户 SaaS** —— 加 LiteLLM 配客户级虚拟 key（[LiteLLM 指南](/zh/resources/llm-frameworks/litellm/)）

## TL;DR —— Recipe

**5 组件，单干到小团队 $10-25/月**：
1. **AnythingLLM** —— 前门 + chat UI
2. **RAGFlow** —— 深度文档解析（硬 PDF）
3. **mem0** —— agent 记忆层
4. **AgentMemory MCP** —— 接编程 agent 的桥
5. **向量库**（Chroma → 规模时 Qdrant）

替代 $50-200/月 SaaS（Notion AI + Mem + Glean Lite），自托管你拥有。90 分钟搭好，MCP 原生所以每个编程 agent 都受益。

开一个 {{< aff "digitalocean" "footer-cta" "DigitalOcean $12/月 droplet" >}} 起入门档，跟第 8 节做，明天你的知识库就能从 Claude Desktop / Cursor / OpenCode 查询。

---

*配套合集：[自托管 AI 编程工作流](/zh/collections/self-hosted-ai-coding-workflow/) 把这个知识库插进编程 agent stack。[便宜 LLM Stack](/zh/collections/cheap-llm-stack/) 覆盖 chat-LLM 成本侧。[跨境出海 AI 营销 Stack](/zh/collections/cross-border-ai-marketing-stack/) 给需要中国友好 hosting 的中国团队。*
