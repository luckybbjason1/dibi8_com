---
title: '自托管 AI 编程工作流：2026 年 $6/月 完整 stack'
description: '7 个组件的自托管 AI 编程 stack，用 $6/月 的基础设施替换掉 $290/月 的 SaaS 订阅（Cursor + Claude Code Pro + Copilot + Replit）。真实数字、真实配置、完整一步步组装指南。'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Docker
  - Python
  - TypeScript
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
tags: ['自托管', 'AI 编程', 'Stack', '工作流', '合集']
aliases:
  - /posts/self-hosted-ai-coding-workflow/
---

如果你正在付 $20/月 给 Cursor + $80/月 给 Claude Code Pro + $19/月 给 Copilot + $50/月 给 Replit credits + $120/月 给 OpenAI API 充值，你的 AI 编程月支出是 **$289/月**。12 个月就是 **$3,468** —— 而这些工具你不拥有、不能审计、随时可能被限流或停服。

这篇合集组装的是 **7 组件自托管替代方案**，跑在 **$6/月 VPS** 上，覆盖 SaaS 90%+ 的功能。我们过去 90 天写了每个组件的深度指南。这篇是**完整 stack 组装指南** —— 装什么、按什么顺序装、用哪份 config，以及超过 $6 tier 后的升级路径。

## TL;DR —— Stack 全貌

| # | 组件 | 工具 | 为什么选 | 深度指南 |
|---|---|---|---|---|
| 1 | 编辑器 / Agent | **OpenCode** | 开源版 Claude Code，DeepSeek-V4 跑 $0.007/任务 vs $0.14 | [OpenCode 设置](/zh/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/) |
| 2 | 本地 LLM Runner | **Ollama** | 137k stars，一行装，5 年老 M1 跑 22 tok/秒 | [Ollama 指南](/zh/resources/llm-frameworks/ollama/) |
| 3 | LLM 网关 | **LiteLLM** | 47.8k stars，100+ 模型统一 API，自托管 | [LiteLLM 网关](/zh/resources/llm-frameworks/litellm/) |
| 4 | Token 节省代理 | **9Router** | RTK 压缩砍编程 agent token 20-40% | [9Router 设置](/zh/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/) |
| 5 | 记忆层 | **mem0 + AgentMemory MCP** | 跨 session 持久化语义记忆 | [AgentMemory MCP](/zh/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/) |
| 6 | 代码上下文 MCP | **filesystem + git + tavily 搜索** | Anthropic 官方 + 社区 + 搜索 | [MCP server 目录](/zh/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) |
| 7 | 多 CLI 切换器 | **CC Switch** | 一键切 Claude / Codex / Gemini CLI / OpenCode | [CC Switch 指南](/zh/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/) |

**月成本总计**（4GB VPS + 存储）：入门 tier **$6**。"5 人团队 tier" + Postgres + Redis + 多副本 LiteLLM 约 **$30/月**。

## 1. 这个 Stack 为什么 2026 年才可行

2024 到 2026 之间三件事变了，自托管 AI 编程终于能用：

1. **开源权重模型追上来了**：DeepSeek-V4 / Qwen 3 Coder / GLM-4.6 Coder 在编程 benchmark 上和 Claude/GPT-5 差距已经 <5%，而且免费或近免费
2. **MCP 标准化工具集成**：编辑器不再各自重新发明怎么调文件/git/搜索工具，协议成了 USB-C —— 看 [MCP server 目录指南](/zh/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) 现有 19,700+ server
3. **本地 LLM runner 生产可用**：Ollama / vLLM / llama.cpp 在消费级硬件上跑出可接受速度

2024 年数学上也成立，但体验痛苦。2026 年差距闭合了。

## 2. 架构总览

```
                  ┌─────────────────────────────┐
                  │   你的机器 / VPS ($6)        │
                  │                             │
   你打字  →      │  OpenCode（编辑器/agent）   │
                  │           │                 │
                  │           ▼                 │
                  │  CC Switch（一键 CLI 切换）│
                  │           │                 │
                  │           ▼                 │
                  │  LiteLLM Gateway :4000      │
                  │           │                 │
                  │     ┌─────┴─────┐           │
                  │     │           │           │
                  │     ▼           ▼           │
                  │  9Router    直连            │
                  │  (RTK 压缩)  (premium)     │
                  │     │           │           │
                  └─────┼───────────┼───────────┘
                        │           │
              ┌─────────┴───┐  ┌────┴──────┐
              ▼             ▼  ▼           ▼
          Ollama       DeepSeek API   Claude API
          （本地）     （便宜推理）   （premium）

      MCP servers (filesystem + git + memory + tavily-search)
      通过 claude_desktop_config.json 挂在 OpenCode 上
```

模式：**OpenCode 是编辑器大脑，LiteLLM 是流量警察，9Router 做压缩，MCP servers 提供世界。** 任意组件可换，不影响其他。

## 3. 组件 1 —— OpenCode（编辑器 / Agent）

**角色**：你实际在里面打字的东西。替代 Cursor + Claude Code Pro。

**为什么选它**：原生支持 MCP 的开源 agent。同一个重构任务（400 行 React 组件），OpenCode + DeepSeek-V4 = 18 秒 $0.007。Claude Code (Sonnet) = 12 秒 $0.14。便宜 20 倍，慢 5%。

**快装**：
```bash
npm install -g @opencode-ai/opencode
opencode --version  # 1.x
```

把它配置指向 LiteLLM 网关（下一个组件），完事。

**完整设置**（含 provider 路由规则 / MCP server 连接 / 编辑器集成）见 [OpenCode 完整指南](/zh/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/)。

## 4. 组件 2 —— Ollama（本地 LLM Runner）

**角色**：在你自己硬件上跑小模型。敏感代码的 100% 离线选项。

**为什么选它**：137k stars。单二进制安装。Llama 3.2 3B 在 5 年老 M1 MacBook + 8GB RAM 跑 22 tok/秒。Qwen 3 Coder 14B 在 16GB M-series Mac 或任何 32GB Linux 上跑得舒服。

**快装**：
```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama pull qwen3-coder:14b
ollama serve  # 暴露 :11434 OpenAI 兼容 API
```

LiteLLM 自动认 Ollama 当 provider。

**完整设置**（含按硬件 tier 的模型选择 + 量化的取舍）见 [Ollama 生产指南](/zh/resources/llm-frameworks/ollama/)。

## 5. 组件 3 —— LiteLLM（统一网关）

**角色**：一个 OpenAI 兼容 API 在所有模型前面 —— Ollama（本地）/ DeepSeek（便宜）/ Claude（premium）/ Gemini（免费层）。编辑器只跟 LiteLLM 说话，LiteLLM 按你的 config 路由。

**为什么选它**：47.8k stars，LLM 网关里星数最多。1k RPS 下 P95 8ms。自托管免费。详细对比看 [Portkey vs LiteLLM vs OpenRouter 2026 指南](/zh/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/)。

**在 4GB VPS 上快速部署**（中国大陆用户推荐 {{< aff "htstack" "stack-vps" "HTStack 的香港 VPS" >}} 拿 <30ms 延迟；其他地方推荐 {{< aff "digitalocean" "stack-droplet" "DigitalOcean $6 droplet" >}}）：

```bash
docker run -d --name litellm -p 4000:4000 \
  -e LITELLM_MASTER_KEY=sk-your-secret \
  -e OLLAMA_API_BASE=http://host.docker.internal:11434 \
  -e DEEPSEEK_API_KEY=$DEEPSEEK_KEY \
  -e ANTHROPIC_API_KEY=$CLAUDE_KEY \
  ghcr.io/berriai/litellm:main-stable
```

**完整设置**（虚拟 key / 账单跟踪 / fallback 规则）见 [LiteLLM 生产网关 2026](/zh/resources/llm-frameworks/litellm/)。

## 6. 组件 4 —— 9Router（Token 节省代理）

**角色**：坐在 LiteLLM 和你的"premium" provider（Claude / GPT-5）之间。压缩重复内容（文件头 / system prompt / 代码库上下文）再发出去。**编程 agent 计费 token 砍 20-40%。**

**为什么这点重要**：编程 agent 是病态 token 消耗者 —— 每轮都把整个代码库 context 发出去。Claude Sonnet 输入 $3/M token，这种烧法很快上头。9Router 的 RTK（Repetition-Token Compression）是唯一专为此 workload 设计的代理。

**快装**：
```bash
docker run -d --name 9router -p 9999:9999 \
  -e PROVIDERS=anthropic,openai,gemini,deepseek \
  ghcr.io/rtk-ai/9router:latest
```

把 LiteLLM 的 premium provider endpoint 指向 `localhost:9999` 而不是直连。

**完整设置**：[9Router 智能代理指南](/zh/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/)。

## 7. 组件 5 —— 记忆层（mem0 + AgentMemory MCP）

**角色**：跨编程 session 的持久化语义记忆。"记住我们用 Tailwind v4，auth 在 `src/lib/auth.ts`" —— agent 下周一还记得。

**为什么选它**：mem0 是 30k+ stars 的开源语义记忆层。AgentMemory 是把它暴露给任意 MCP host（OpenCode / Claude Desktop / Cursor）的 MCP server。

**快装**：
```bash
npm install -g @mem0/mem0-mcp
# 加到 OpenCode 的 MCP config:
# { "agentmemory": { "command": "mem0-mcp", "args": [] } }
```

**完整设置**（含 embedding 模型选 + 向量库挑选）见 [AgentMemory MCP 指南](/zh/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/)。

## 8. 组件 6 —— 代码上下文 MCP（filesystem + git + tavily 搜索）

**角色**：给 agent 眼睛和手。读你项目文件、看 git 历史、搜网 —— 全走 MCP 协议。

**最小集**：
- `modelcontextprotocol/server-filesystem`（Anthropic 官方）
- `modelcontextprotocol/server-git`（Anthropic 官方）
- `tavily-mcp`（给 LLM 预格式化的搜索结果）

**快装**（3 个都加到 OpenCode 的 `claude_desktop_config.json`）：
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"]
    },
    "git": {
      "command": "uvx",
      "args": ["mcp-server-git", "--repository", "/home/user/projects/your-repo"]
    },
    "tavily": {
      "command": "npx",
      "args": ["-y", "@tavily/mcp"],
      "env": {"TAVILY_API_KEY": "tvly-xxx"}
    }
  }
}
```

Tavily 免费层每月 1000 次搜索，足够撑住 $6 预算。

**19,700+ 可用 MCP server 完整目录 + 怎么再挑**：见 [MCP Server 注册中心完全指南 2026](/zh/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/)。

## 9. 组件 7 —— CC Switch（多 CLI 编排）

**角色**：你想直接用 Claude Code 原生跑一个任务 —— 或者跳到 Codex 拿 Rust 速度 —— CC Switch 是一键切换。单一 config，所有 AI CLI 共享 MCP servers。

**为什么选它**：75k stars 的 Rust + Tauri 桌面 app，意味着你不用再维护 5 份独立的 `~/.claude_desktop_config.json` 给 5 个不同 CLI。

**快装**：从 [farion1231/cc-switch releases](https://github.com/farion1231/cc-switch/releases) 下载，一键配置每个 CLI。

**完整指南**：[CC Switch 统一 AI CLI 控制中心](/zh/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/)。

## 10. 组装顺序 —— Day 1 设置（90 分钟）

从零开始按这个顺序做：

1. **开服务器**（15 分）—— 订一个 {{< aff "digitalocean" "assembly-vps" "DigitalOcean $6 droplet" >}}，装 Docker，开端口 4000（LiteLLM）+ 9999（9Router）+ 11434（Ollama）
2. **先 Ollama**（10 分）—— 装 + 拉 `qwen3-coder:14b`（~9 GB）。确认 `curl localhost:11434/api/tags` 能用
3. **再 LiteLLM**（15 分）—— 用第 5 节的环境变量 docker run。确认 `curl localhost:4000/v1/models -H "Authorization: Bearer sk-your-secret"` 列出 Ollama 模型
4. **第三 9Router**（10 分）—— 可选但推荐。加到 LiteLLM 的 premium provider config
5. **第四 OpenCode**（15 分）—— 本地装，指向 `https://your-vps:4000/v1` 的 LiteLLM，测一个基础 prompt
6. **第五 MCP servers**（15 分）—— filesystem + git + tavily 加到 OpenCode config。让它"列这个 repo 的文件"测一下
7. **第六 mem0 + AgentMemory**（10 分）—— `npm i -g mem0-mcp`，加到 config，说"记住我们用 Tailwind v4"
8. **最后 CC Switch**（可选）—— 想要 native Claude Code / Codex 并存才装

你现在拥有 $6/月 的 AI 编程 stack，覆盖 $289/月 SaaS 套餐的 90%。

## 11. 月成本拆解

| 项 | 入门 tier | 5 人团队 tier |
|---|---|---|
| VPS（4 GB → 16 GB）| $6 | $24 |
| Ollama 模型 | $0（自己拥有硬盘）| $0 |
| LiteLLM | $0（自托管）| $0 |
| 9Router | $0（自托管）| $0 |
| Tavily 搜索 | $0（1k req 免费层）| $5（付费层）|
| mem0 / AgentMemory | $0（自托管）| $0 |
| DeepSeek API（硬任务的便宜推理）| ~$2-5 | ~$10-15 |
| Claude API（罕用，premium fallback）| ~$1-3 | ~$5-10 |
| **总计** | **~$6-14** | **~$30-50** |

对比 Cursor + Claude Code Pro + Copilot + Replit + OpenAI 充值 = $289/月。

## 12. 升级路径

stack 超过 $6 tier 时（不止 1 个 dev / 不止 1 个项目 / 持久化 state 重要）：

- **加 Postgres** 给 LiteLLM 做账单跟踪 + 项目级虚拟 key（{{< aff "digitalocean" "upgrade-postgres" "DigitalOcean 托管 Postgres" >}} $15/月）
- **加 Redis** 给 LiteLLM 缓存（1 GB 托管 Redis $10/月）
- **LiteLLM 上 LB + 3 副本** —— 见 [Portkey vs LiteLLM 2026 指南](/zh/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/) 第 4 节的 Kubernetes 模式
- **加 Grafana + Loki** 做完整可观测性 —— 记每个 prompt、每次 fallback、每次成本尖峰
- **加 team-level RBAC** 走 LiteLLM 企业版（按需定价）

关键点：你从 $6/月起步，**完整拥有整个 stack**。每次升级是对应具体需求的成本决策 —— 而不是 SaaS 锁定陷阱。

## TL;DR —— 7 组件 recipe

1. **OpenCode** —— 编辑器大脑
2. **Ollama** —— 本地 fallback
3. **LiteLLM** —— 统一网关
4. **9Router** —— token 压缩
5. **mem0 + AgentMemory** —— 持久化记忆
6. **MCP servers**（filesystem + git + tavily）—— 上下文 + 工具
7. **CC Switch** —— 多 CLI 编排

总计：$6/月。总计：90 分钟组装。总计：零 vendor 锁定。

你每月 AI 编程 SaaS 烧 $200+，这个 stack 第一周就回本。开一个 {{< aff "digitalocean" "footer-cta" "DigitalOcean $6 droplet" >}}，跟第 10 节做，下周回来报数。

---

*收藏这页 —— 每季度根据新开源版本更新组件选择。最后更新：2026-05-21。*
