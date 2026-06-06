---
title: Hermes Agent：一个会自我进化的 AI 代理，越用越懂你
description: Hermes Agent 是 Nous Research 打造的Open Source AI 代理，拥有自我学习循环——从经验中创建技能、持续改进、记住你的偏好，越用越懂你。
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Go
- Python
- TypeScript
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "210.6 MB"
file_md5: ''
download_url: https://github.com/NousResearch/hermes-agent
backup_url: ''
github_repo: https://github.com/NousResearch/hermes-agent
stars: 156248
maintainer: "NousResearch"
last_maintained: "2026-05-16"
featureImage: ''
draft: false
aliases:
- /zh/posts/genericagent-self-evolving-ai-agent.zh/
- /zh/posts/hermes-agent-self-improving-ai-agent/
faqs:
  - q: 'Hermes Agent 与 Claude Code、Cursor 或 GitHub Copilot 这类工具有什么不同？'
    a: 'Hermes Agent 内置了自学习循环、跨会话的持久记忆，以及一套技能系统，这些都是那些工具所不具备的。它还能在 6 个消息平台上运行，支持 cron 定时调度和 MCP，并且开源、可自托管；而其他工具只局限于 CLI、桌面端或 IDE，且要收取订阅费或 API 费用。'
  - q: 'Hermes Agent 的自我提升循环是如何运作的？'
    a: '完成一项任务后，Hermes 会分析哪些做法有效、哪些无效，提取出可复用的模式，创建一个记录该方法的技能文件，在类似任务上测试这个技能，再根据结果加以优化。随着时间推移，这会构建出一个专属于该用户的个人技能库。'
  - q: 'Hermes Agent 会在会话之间保留哪些类型的记忆？'
    a: 'Hermes 维护两类记忆：用户画像记忆（编码风格、项目、偏好的工具、沟通偏好以及常犯的错误）和会话记忆（当前项目上下文、最近的命令与输出，以及编辑过的文件）。即使在重启电脑之后，用户画像记忆依然会保留。'
  - q: 'Hermes Agent 可以在哪些消息平台上运行？'
    a: 'Hermes Agent 可作为多平台消息机器人运行于 Telegram、Discord、Slack、WhatsApp、Signal 和 Email，全部通过 `hermes gateway setup` 命令进行配置。同一套命令和技能在每个平台上都能通用。'
  - q: '如何安装 Hermes Agent 并配置 LLM 提供商？'
    a: '在 Linux、macOS 或 WSL2 上，你可以用一行 curl 脚本管道传给 bash 来安装，或者克隆代码仓库后运行 `./setup-hermes.sh`。随后你可以用类似 `hermes config set provider openai` 和 `hermes config set model gpt-4o` 的命令来设置提供商，或通过 `hermes config set provider ollama` 使用本地模型。'
---
{</* resource-info */>}

## 问题：大多数 AI 代理都把你忘了

你花了几个小时教 AI 助手你的工作流、编码风格、项目结构。然后你开启了一个新会话——一切都没了。这个代理每次都把你当成陌生人。

这就是当今大多数 AI 代理的根本局限：**没有记忆、没有学习、没有成长**。它们按设计就是无状态的，这使它们成为强大的工具，但却是糟糕的长期合作伙伴。

**Hermes Agent** 用一个激进的方法解决了这个问题：它是唯一内置学习循环的代理。

## 什么是 Hermes Agent？

[Hermes Agent](https://github.com/NousResearch/hermes-agent) 是由 [Nous Research](https://nousresearch.com) 创建的Open Source AI 代理——正是打造了 Hermes Open Source大语言模型系列的同一个团队。它在 GitHub 上拥有 **136,579+ 星标** 和 **20,960+ 复刻**，是现存最受欢迎的 AI 代理框架之一。

项目的标语说明了一切：**"与你共同成长的代理。"**

与其他作为静态工具的代理不同，Hermes Agent：
- **从经验中创建技能** —— 学习你的工作流并将它们保存为可复用的技能
- **在使用过程中改进技能** —— 基于反馈精炼其能力
- **跨会话持久化知识** —— 记住你是谁以及你喜欢什么
- **建立对你的深度模型** —— 你用得越多，它就越懂你

## 核心功能

### 1. 内置学习循环

Hermes Agent 的核心创新是其**自我改进循环**：

```
经验 → 反思 → 技能创建 → 实践 → 改进
```

当你用 Hermes 完成任务时，它会：
1. **分析** 什么有效、什么无效
2. **提取** 可复用的模式
3. **创建** 记录方法技能文件
4. **测试** 技能在类似任务上的表现
5. **精炼** 基于结果进行优化

随着时间的推移，这会创建一个**专属于你的个人技能库**。

### 2. 40+ 内置工具

Hermes Agent 配备了全面的工具集：

| 工具类别 | 示例 |
|-------------|---------|
| **文件操作** | 读取、写入、搜索、差异对比、补丁 |
| **终端** | 执行命令、Shell 会话、后台作业 |
| **网页** | 浏览、抓取、下载、API 调用 |
| **代码** | 语法检查、代码检查、格式化、测试 |
| **Git** | 提交、分支、差异、日志、PR 审查 |
| **系统** | 进程管理、文件监控、定时任务 |

**工具集系统**让你只启用需要的工具，减少 Token 使用量并提高专注度。

### 3. 技能系统（程序性记忆）

技能是 Hermes Agent 的秘密武器。它们是**可复用的程序文件**，捕获：

- **触发条件** —— 何时使用此技能
- **分步说明** —— 该做什么
- **陷阱** —— 要避免的常见错误
- **验证步骤** —— 如何确认成功

示例技能结构：
```yaml
---
name: "hugo-blog-deploy"
trigger: "deploy hugo blog"
steps:
  1. "Run hugo --minify --cleanDestinationDir"
  2. "Verify build succeeded"
  3. "Run deploy.sh"
  4. "Check live site with curl"
pitfalls:
  - "Future dates prevent building"
  - "Cloudflare cache may show stale content"
verification:
  - "curl -s https://site.com | grep title"
```

技能可以：
- **自动创建** —— 从成功完成的任务中
- **从技能中心下载** —— 社区贡献的技能
- **手动编写** —— 针对你的特定工作流
- **与他人分享**

### 4. 持久记忆

Hermes Agent 维护**两种类型的记忆**：

**用户档案记忆**：
- 你喜欢的编码风格
- 你参与的项目
- 你喜欢的工具
- 沟通偏好
- 你常犯的错误（这样它就能帮你避免）

**会话记忆**：
- 当前项目上下文
- 最近的命令和输出
- 你一直在编辑的文件
- 本次会话的对话

这种记忆跨会话持久化，所以即使你重启电脑，Hermes **也记得你**。

### 5. 消息网关

Hermes Agent 不仅仅是一个 CLI 工具——它是一个**多平台消息机器人**：

| 平台 | 设置 | 使用场景 |
|---------|-------|---------|
| **Telegram** | `hermes gateway setup` | 移动 AI 助手 |
| **Discord** | `hermes gateway setup` | 团队协作 |
| **Slack** | `hermes gateway setup` | 工作场所集成 |
| **WhatsApp** | `hermes gateway setup` | 个人助手 |
| **Signal** | `hermes gateway setup` | 注重隐私 |
| **Email** | `hermes gateway setup` | 异步工作流 |

配置完成后，你可以从任何这些平台与 Hermes 聊天，使用相同的命令和技能。

### 6. MCP 集成

Hermes Agent 支持**模型上下文协议（MCP）**，允许它连接到任何 MCP 服务器以获得扩展能力：

- **数据库服务器** —— 查询 SQL 数据库
- **文件服务器** —— 访问远程文件系统
- **API 服务器** —— 与任何 REST API 交互
- **自定义服务器** —— 构建你自己的集成

这使 Hermes 具有无限的可扩展性——如果你能构建 MCP 服务器，Hermes 就能使用它。

### 7. 定时任务调度

Hermes Agent 可以通过其内置的定时系统运行**定时任务**：

```bash
# 每天早上 9 点运行一个技能
hermes cron add --skill "daily-report" --schedule "0 9 * * *"

# 每周运行备份
hermes cron add --skill "backup-database" --schedule "0 2 * * 0"

# 列出所有定时任务
hermes cron list
```

非常适合需要按计划运行的自动化工作流。

### 8. 安全功能

Hermes Agent 认真对待安全：

- **命令审批** —— 风险命令需要显式确认
- **私信配对** —— 敏感操作前验证你的身份
- **容器隔离** —— 在隔离环境中运行不受信任的代码
- **审计日志** —— 所有操作都被记录以供审查

## 快速开始

### 安装

```bash
# 一行命令安装（Linux、macOS、WSL2）
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# 或者手动克隆并设置
git clone https://github.com/NousResearch/hermes-agent.git
cd hermes-agent
./setup-hermes.sh
```

### 首次对话

```bash
source ~/.bashrc    # 重新加载 Shell
hermes              # 开始聊天
```

### 配置提供商

```bash
# 设置你喜欢的 LLM 提供商
hermes config set provider openai
hermes config set model gpt-4o

# 或者使用本地模型
hermes config set provider ollama
hermes config set model llama3.1
```

### 常用命令

```bash
# 开启全新对话
/new

# 随时切换模型
/model anthropic:claude-3-5-sonnet

# 设置个性
/personality developer

# 检查使用情况
/usage

# 浏览可用技能
/skills

# 使用特定技能
/hugo-blog-deploy

# 压缩上下文以节省 Token
/compress
```

## 架构

Hermes Agent 采用模块化架构构建：

```
Hermes Agent
├── CLI 界面（终端 UI）
├── 消息网关（Telegram、Discord 等）
├── 代理核心（推理引擎）
├── 技能系统（程序性记忆）
├── 记忆存储（持久化存储）
├── 工具集管理器（40+ 工具）
├── MCP 客户端（外部集成）
├── 定时调度器（自动化任务）
└── 安全层（审批、隔离）
```

整个系统使用 **Python**（2800 万+ 行代码）编写，Web 界面使用 TypeScript 组件。

## 使用场景

### 对于开发者
- **代码审查助手** —— Hermes 学习你的代码库并审查 PR
- **DevOps 自动化** —— 部署、监控和排查基础设施问题
- **文档编写器** —— 从代码注释自动生成文档
- **Bug 猎手** —— 搜索导致过去 Bug 的模式

### 对于团队
- **共享技能库** —— 团队最佳实践作为可复用技能
- **入职加速器** —— 新团队成员即时访问团队知识
- **7×24 运营** —— 定时任务处理日常维护
- **多平台访问** —— 从 Slack、Discord 或 Telegram 与 Hermes 聊天

### 对于高级用户
- **个人知识库** —— Hermes 记住你教它的一切
- **工作流自动化** —— 复杂的多步骤任务变成一个命令
- **跨平台助手** —— 桌面、移动端和 Web 上使用同一个助手
- **自定义集成** —— 为你的特定工具构建 MCP 服务器

## 性能对比

| 功能 | Hermes Agent | Claude Code | Cursor | GitHub Copilot |
|---------|-------------|-----------|--------|----------------|
| **自我学习** | ✅ 是 | ❌ 否 | ❌ 否 | ❌ 否 |
| **持久记忆** | ✅ 是 | ❌ 否 | ❌ 否 | ❌ 否 |
| **技能系统** | ✅ 是 | ❌ 否 | ❌ 否 | ❌ 否 |
| **多平台** | ✅ 6 个平台 | ❌ 仅 CLI | ❌ 仅桌面端 | ❌ 仅 IDE |
| **Open Source** | ✅ 是 | ❌ 否 | ❌ 否 | ❌ 否 |
| **定时调度** | ✅ 是 | ❌ 否 | ❌ 否 | ❌ 否 |
| **MCP 支持** | ✅ 是 | ❌ 否 | ❌ 否 | ❌ 否 |
| **免费层** | ✅ 自托管 | 💰 API 费用 | 💰 订阅 | 💰 订阅 |

## 局限性

- **学习曲线** —— 技能系统需要前期投入
- **本地设置** —— 自托管需要技术知识
- **资源使用** —— 持久记忆随时间消耗存储空间
- **提供商成本** —— LLM API 调用仍然花钱（除非使用本地模型）

## 结论

Hermes Agent 代表了我们对 AI 助手认知的**根本性转变**。它不是将 AI 视为一次性工具，而是将其视为**与你共同成长的长期合作伙伴**。

自我改进循环、持久记忆和技能系统创造了复利效应：你用 Hermes 越多，它就越有价值。这与传统 AI 工具随时间提供递减回报的情况正好相反。

如果你厌倦了每次会话都重新教你的 AI 助手同样的事情，Hermes Agent 值得探索。

**GitHub**: [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)  
**文档**: [hermes-agent.nousresearch.com/docs](https://hermes-agent.nousresearch.com/docs/)  
**星标**: 136,579+ | **复刻**: 20,960+ | **许可证**: Open Source  

你尝试过 Hermes Agent 吗？你对自我改进的 AI 代理有什么体验？在评论中分享你的想法。

## 相关文章

- [Agent Reach：让你的 AI Agent 一键连接互联网](/zh/resources/llm-frameworks/agent-reach-ai-agent-internet-access/)
- [Free Claude Code：不花一分钱，让顶级 AI 帮你写代码](/zh/resources/ai-tools/free-claude-code-open-source-proxy/)
- [OpenClaw 42 个真实用例：AI 代理已经这样改变我们的生活](/zh/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/)

---

## 推荐自托管基础设施

要 7×24 稳定跑这套，服务器选择很关键：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心。开源 AI 工具自托管首选。
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — 香港 VPS，国内访问低延迟。**这就是 dibi8.com 自家所在的 IDC**，生产环境已验证。

*以上为推广链接，不会增加你的成本，但能支持 dibi8.com 持续运营。*

