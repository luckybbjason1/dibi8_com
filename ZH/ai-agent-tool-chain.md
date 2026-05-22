---
title: 'AI Agent 工具链 2026：6 组件 stack 搭生产级自主 agent'
description: '完整生产级 AI agent stack：LangGraph 状态机编排 + MCP servers 工具 + mem0 记忆 + OpenClaw 多 agent 协调 + Hermes Agent 自改进 + e2b 沙箱代码执行。$20-60/月自托管。真实组装含全部内链深度文。'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Python
  - TypeScript
  - Docker
  - PostgreSQL
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
tags: ['AI Agent', '工具链', 'LangGraph', 'MCP', 'Stack', '合集']
aliases:
  - /posts/ai-agent-tool-chain/
---

"AI agent" 在 2025 年停止做研究话题，在 2026 年成为生产工程类别。在交付真正自主 agent 的团队 —— 熬过重启的客服 bot、跨百文件重构的编程 agent、跑数小时的研究 agent —— 都汇聚到一个惊人一致的 stack。这个合集组装它。

**6 组件，$20-60/月自托管。** 如果你专门搭编程 agent，配 [自托管 AI 编程工作流](/zh/collections/self-hosted-ai-coding-workflow/)；本合集聚焦自主 agent 模式（长跑、多步、带工具）。

## TL;DR —— Stack 全貌

| # | 组件 | 角色 | 为什么 | 深度指南 |
|---|---|---|---|---|
| 1 | **LangGraph** | 有状态 agent 编排（大脑）| 持久化执行、human-in-loop、熬过崩溃 | [LangGraph 生产 2026](/zh/resources/llm-frameworks/langgraph-stateful-agent-orchestration-2026/) |
| 2 | **MCP servers**（filesystem / git / search / 领域特定）| 工具 & 上下文层（手和眼）| 标准化 agent-世界协议，19,700+ 可用 | [MCP Server 注册中心 2026](/zh/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) |
| 3 | **mem0 + AgentMemory MCP** | 持久化语义记忆（长期记忆）| 跨 session 回忆、事实提取、衰减 | [AgentMemory MCP](/zh/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/) |
| 4 | **OpenClaw** | 多 agent 协调（团队）| sub-agent 编排、委派、并行执行 | [OpenClaw 自托管](/zh/resources/llm-frameworks/openclaw-self-hosted-ai-assistant-setup-guide-2026/) |
| 5 | **Hermes Agent** | 自改进 agent 循环（学习层）| agent 跨运行自动改进 prompt 和工具使用 | [Hermes Agent 指南](/zh/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/) |
| 6 | **e2b 沙箱**（via `e2b-sandbox-mcp`）| 代码执行沙箱（安全游乐场）| 不拥有 VM 跑不可信代码，MCP 暴露 |（看 [MCP Server 注册中心](/zh/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) §6）|

**月成本总计**：单干 agent dev **$20-30/月** • 小团队或生产原型 **$40-60/月** • 多 agent 并发生产规模 ~$200/月

对比纯 SaaS：每个 agent 平台（LangChain Cloud / Vellum 等）起价 ~$99/月/dev；配 sandbox + 记忆 + 多 agent 产品很快到 $300-500/月。

## 1. 2026 为什么要自建 agent stack

今年三股力量汇合：

1. **LangGraph 到 1.x 并证明大规模持久化执行** —— "agent 重启后忘光" bug 解决
2. **MCP 标准化工具集成** —— 写一次工具作为 MCP server，在 Claude / OpenCode / Cursor / 你自己的 agent 都能用
3. **自改进循环可复现** —— Hermes Agent 等项目证明 agent 能基于结果数据迭代改进自己的 prompt

组合起来意味着：以前要 $500k/年 AI 基础设施预算的事，小团队 $30/月加长周末就能搞定。

## 2. 架构总览

```
                ┌──────────────────────────────────────┐
                │   用户 / 外部触发                     │
                └─────────────────┬────────────────────┘
                                  │
                                  ▼
        ┌───────────────────────────────────────────────────┐
        │  LangGraph（状态机 + checkpointer）              │
        │                                                   │
        │  ┌────────────┐  ┌──────────────┐  ┌──────────┐ │
        │  │ 规划       │→ │ 工具调用      │→ │ 批评      │ │
        │  │ node       │  │ node         │  │ node     │ │
        │  └────────────┘  └──────┬───────┘  └─────┬────┘ │
        │                          │                │      │
        └──────────────────────────┼────────────────┼──────┘
                                   │                │
                                   ▼                ▼
                ┌──────────────────────┐  ┌─────────────────┐
                │ MCP servers          │  │ mem0（记忆）    │
                │  - filesystem        │  │  via Agent-     │
                │  - git               │  │  Memory MCP     │
                │  - tavily-search     │  └─────────────────┘
                │  - e2b-sandbox       │
                │  - 领域特定          │
                └──────────────────────┘

   可选层：
   - OpenClaw 并行编排多个 LangGraph agent
   - Hermes Agent 观察结果并随时间重写 prompt
```

心智模型：**LangGraph 是决定下一步做什么的大脑。MCP servers 是做事的手。mem0 是大脑记住的东西。OpenClaw 把它扩展到团队。Hermes 让团队随运行变聪明。**

## 3. 组件 1 —— LangGraph（编排大脑）

**角色**：状态机。每个 agent 决策、每次工具调用、每次转移都作为 node 和 edge 存在 LangGraph 里。state 持久化到 Postgres。崩溃可恢复。人可在任意 node 中断。

**为什么选它**：32.6k stars，v1.2.1，LangChain 团队出。唯一广泛采用的 "agent 熬过 deploy" 是默认而非附加的框架。

**快装**：
```bash
pip install -U langgraph langgraph-checkpoint-postgres
```

定义 agent 为图（规划 → 工具 → 批评 → 循环）。配 `PostgresSaver` 编译。带 `thread_id` 跑。runtime 处理其他。

**完整设置**（4 杀手特性 / 生产部署模式 / 从 LangChain `AgentExecutor` 迁移）：[LangGraph 有状态 agent 编排 2026](/zh/resources/llm-frameworks/langgraph-stateful-agent-orchestration-2026/)。

## 4. 组件 2 —— MCP Servers（工具 & 上下文）

**角色**：agent 采取的每个外部动作 —— 读文件 / 跑 shell 命令 / 搜网 / 查 DB —— 都流过 MCP server。

**为什么这关键**：MCP 出现前（2025 早期），每个 agent 框架重新实现相同 20 个工具（filesystem / 网搜 / 代码执行），互不通用。今天你接好 Anthropic 7 reference + 3-5 个专用，agent 就有超能力，不用写工具代码。

**自主 agent 最小 MCP 集**：
- `modelcontextprotocol/server-filesystem`（读项目文件）
- `modelcontextprotocol/server-git`（看 git 状态）
- `tavily-mcp` 或 `brave-search-mcp-server`（网搜）
- `e2b-sandbox-mcp`（沙箱代码执行 —— 见组件 6）
- 1-2 个领域特定（Postgres MCP / Slack MCP / Stripe MCP）

**完整 19,700+ MCP server 菜单 + 挑选清单**：[MCP Server 注册中心完全指南 2026](/zh/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/)。

## 5. 组件 3 —— mem0 + AgentMemory MCP（长期记忆）

**角色**：agent 跨运行记住的东西。没这层，每次 agent 调用从零上下文起步。有这层，agent 记住用户事实、项目、过往决策、过往失败。

**两层模式**：
- **mem0** 存语义记忆（Python service，向量库后端）
- **AgentMemory MCP** 把 mem0 暴露给任意 MCP 感知 host（你的 LangGraph node / Claude Desktop / OpenCode）

**快装**：
```bash
docker run -d --name mem0 -p 8765:8765 mem0ai/mem0-server:latest
npm install -g @mem0/mem0-mcp
# 然后把 agentmemory 加到 LangGraph 的 MCP toolset
```

**完整设置**：[AgentMemory MCP 持久化记忆 2026](/zh/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/)。

## 6. 组件 4 —— OpenClaw（多 agent 协调）

**角色**：单 LangGraph agent 不够时 —— 你要 "researcher" + "writer" + "critic" 三人组协作 —— OpenClaw 是编排器，委派和聚合。

**为什么选它而不是 CrewAI**：OpenClaw 自托管、MCP 原生、与 LangGraph 干净集成（每个"专家 agent"自己可以是一个 LangGraph）。CrewAI 不错但云优先，难和自定义状态机组合。

**快装**：
```bash
docker run -d --name openclaw \
  -p 7050:7050 \
  -v ~/.openclaw:/data \
  ghcr.io/openclaw/openclaw:latest
```

**完整设置**（含 sub-agent 委派模式 + 用例库）：[OpenClaw 自托管 AI 助手设置指南 2026](/zh/resources/llm-frameworks/openclaw-self-hosted-ai-assistant-setup-guide-2026/) 和 [awesome OpenClaw 用例](/zh/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/) 参考。

## 7. 组件 5 —— Hermes Agent（自改进循环）

**角色**：长期观察 agent 结果，识别哪些 prompt 和工具序列产生好/坏结果，自动重写 prompt。你的 agent 不用你 babysit 就变好。

**为什么这重要**：静态 agent prompt 衰减 —— v1 有效的随你代码库演化、领域转移、新工具出现而失效。Hermes Agent 是唯一专为自改进 agent 循环广泛采用的开源框架。

**快装**：
```bash
pip install hermes-agent
# 接成 LangGraph 工作流的 "post-run observer"
```

模式：Hermes 看 LangGraph trace log（via LangSmith 导出），关联结果质量分和 prompt 版本，生成新 prompt 候选，A/B 测试。

**完整设置**（含奖励函数设计 + prompt 突变策略）：[Hermes Agent 自改进 AI agent](/zh/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/)。

## 8. 组件 6 —— e2b 沙箱（安全代码执行）

**角色**：agent 决定跑 Python / shell / Node 代码时（数据分析 / 代码生成 / 研究工作流常见），e2b 提供隔离云沙箱让不可信代码不触你基础设施。

**为什么 MCP 暴露的 e2b 胜过原生 e2b SDK**：`e2b-sandbox-mcp` server 让"在沙箱跑代码"变成你 LangGraph agent 的单一工具调用 —— 和 filesystem 读或网搜同样接口。

**快装**（加到 MCP config 里和其他一起）：
```json
{
  "mcpServers": {
    "e2b-sandbox": {
      "command": "npx",
      "args": ["-y", "@e2b/sandbox-mcp"],
      "env": { "E2B_API_KEY": "your-key" }
    }
  }
}
```

**成本**：e2b 有免费层（50 沙箱小时/月）。超出后 $0.000014/CPU-秒 —— 典型 agent 负载便宜。

**找它和 19,700+ 其他 MCP server**：[MCP Server 注册中心完全指南 2026](/zh/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) §6。

## 9. Day 1 组装顺序（3 小时）

1. **开 VPS + Postgres**（20 分）—— {{< aff "digitalocean" "agent-vps" "DigitalOcean $24/月 droplet（8 GB）" >}} + 托管 Postgres（$15/月）
2. **装 LangGraph + checkpointer**（15 分）—— `pip install`，写 30 行 hello-world 有状态 agent，验证它熬过 `kill -9` 后恢复
3. **加 MCP servers**（30 分）—— filesystem + git + tavily + e2b-sandbox 加到你 LangGraph node 的 MCP config
4. **加 mem0 + AgentMemory MCP**（20 分）—— Docker run mem0，agentmemory 加到 MCP toolset
5. **测第一个有用 agent**（45 分）—— "研究 → 摘要 → 写到文件" 管线，熬过重启，用 3 个工具，持久化记忆
6. **加 OpenClaw**（30 分）—— 真要多 agent 才加，否则跳过
7. **接 Hermes Agent 观察者**（20 分）—— 有稳定单 agent baseline 后才加。否则你在优化噪声

3 小时从零到拥有自己基础设施上的多工具有状态 agent。

## 10. 成本拆解

| 项 | 单干 agent dev | 团队原型 | 生产（3 agent 并发）|
|---|---|---|---|
| VPS | $24（8 GB）| $48（16 GB）| $120（32 GB + 副本）|
| 托管 Postgres | $15 | $30 | $60 |
| LangGraph | $0（OSS）| $0 | $0 |
| MCP servers | $0 | $0 | $0 |
| mem0 / AgentMemory MCP | $0 | $0 | $0 |
| OpenClaw | $0 | $0 | $0 |
| Hermes Agent | $0 | $0 | $0 |
| e2b 沙箱 | $0（免费层）| $5-10 | $30-60 |
| LLM API（DeepSeek 主 + Claude fallback）| $5-15 | $15-30 | $80-150 |
| LangSmith（可选，可观测性）| $0（免费层）| $39 | $99-499 |
| **总计** | **~$45-55/月** | **~$140-160/月** | **~$390-790/月** |

对比托管 agent 平台：LangChain Cloud $99/用户/月，Vellum 起价 $299/月，企业 agent 工具 $499+。

## 11. 升级路径

超过这个 stack 时：

- **超过 10 并发 agent** —— LangGraph 上独立 Kubernetes 集群带 autoscaling
- **要审计级 trace 保留** —— LangSmith 企业版或自托管可观测性（Grafana + Loki + Tempo）
- **多租户 agent SaaS** —— 加 LiteLLM 给客户级虚拟 key（[LiteLLM 指南](/zh/resources/llm-frameworks/litellm/)）
- **亚秒延迟需求** —— e2b 负载移到你控制的独立 Firecracker VM
- **受监管行业（医疗 / 金融）** —— 公开 MCP server 换成审过的内部 fork；加 Portkey 做 guardrail（[Portkey vs LiteLLM 2026](/zh/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/)）

## TL;DR —— Recipe

**6 组件搭生产级自主 agent，单干或团队原型 $20-60/月**：
1. **LangGraph** —— 有状态编排大脑
2. **MCP servers** —— 工具 & 上下文（filesystem + git + search + sandbox）
3. **mem0 + AgentMemory MCP** —— 长期记忆
4. **OpenClaw** —— 多 agent 协调
5. **Hermes Agent** —— 自改进循环
6. **e2b 沙箱** —— 安全代码执行

开一个 {{< aff "digitalocean" "footer-cta" "DigitalOcean $24/月 droplet" >}}，跟第 9 节做，你有熬过重启 / 记住上下文 / 安全跑代码 / 随时间自改进的 agent —— 跑在你自己拥有的基础设施上，比单座 Cursor 还便宜。

---

*配套合集：[自托管 AI 编程工作流](/zh/collections/self-hosted-ai-coding-workflow/) 给编程 agent 专属 stack。[知识库 Stack](/zh/collections/knowledge-base-stack/) 给你的 agent 一个 Glean 等价 RAG 后端。[便宜 LLM Stack](/zh/collections/cheap-llm-stack/) 覆盖成本侧。*
