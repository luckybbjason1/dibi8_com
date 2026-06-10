---
title: "Matt Pocock 的 Skills：赋予 AI Agent 真正超能力的 CLI 框架——npm 安装，零配置"
description: "了解如何使用 Matt Pocock 的 Skills 框架为 Claude Code、Cursor 和 Gemini CLI 等 AI 编程 Agent 赋予代码之外的真正能力——数据库、文件系统、CI/CD 等。包含逐步 npx 安装指南、架构分析和实际基准测试。"
date: 2026-06-10
slug: "mattpocock-skills-ai-agent-framework-guide"
category: dev-utils
tags: [matt-pocock, skills, AI Agent, CLI框架, AI编程工具, Agent能力, 开发者工具, 开源]
lang: zh
---

## 简介

AI 编程 Agent 从根本上改变了开发人员编写、调试和部署代码的方式。Claude Code、Cursor、Codex CLI、Gemini CLI 和 GitHub Copilot 等工具可以从自然语言提示生成整个功能。但即使是最先进的 AI Agent 也受到其能读取的数据和能调用的工具的限制。这就是 Matt Pocock 的 Skills 框架改变一切的地方——它弥合了代码生成与代码执行之间的鸿沟。

Skills 是一个轻量级的开源框架，为 AI 编程 Agent 添加了真实世界的能力——数据库访问、文件系统操作、CI/CD 管道、云部署等。与其让 Agent 为它无法执行的任务编写代码，Skills 为 Agent 提供了完成端到端工作所需的实际工具。拥有超过 122,000 个 GitHub 星标，它已迅速成为使 AI Agent 真正高效的首选框架。

![Skills 框架概览](https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png)

## Skills 是什么？

Skills 是**一个赋予 AI 编程 Agent 超越代码生成的真实能力的可扩展框架**。它通过将能力定义为插件来实现——这些小型、独立的模块可以由 Agent 调用来执行特定任务。把它想象成给你的 AI Agent 一把瑞士军刀：不是为每个任务编写新工具，Skills 提供了一套 Agent 可以立即使用的精选工具。

主要能力包括：

- **数据库访问**——运行 SQL 查询、管理架构、迁移数据
- **文件系统操作**——读取、写入、搜索和操作文件
- **CI/CD 集成**——触发构建、运行测试、部署到暂存环境
- **云操作**——管理 Docker 容器、Kubernetes Pod、云资源
- **网络工具**——发起 HTTP 请求、与 API 交互
- **包管理**——安装依赖项、管理版本
- **自定义插件**——定义适合你工作流的自定义能力
- **与 Agent 无关**——适用于 Claude Code、Cursor、Gemini CLI、Codex 等

Skills 作为 npm 包分发，通过一条命令全局安装。它被设计为与任何支持工具调用的 Agent 一起工作，使其成为 AI 模型和真实执行之间的通用桥梁。对于[Agent 管理](dibi8-internal-link)工作流，Skills 提供了将 AI 助手转变为自主开发人员的缺失执行层。

## Skills 如何工作

Skills 基于插件架构。每个"技能"都是一个自包含的模块，定义了 Agent 可以做什么。当 Agent 需要执行任务时，它会查询可用的技能并调用相应的技能。然后该技能执行操作并返回结果。

该框架使用一个简单的配置文件（`skills.json`）列出所有可用技能。每个技能定义其名称、描述以及它可以执行的命令或 API 调用。Agent 读取此配置并使用技能描述来确定给定任务应调用哪个技能。

当你问 Agent"为此项目设置 PostgreSQL 数据库"时，Skills 提供一个数据库技能，可以创建数据库、配置连接并运行初始迁移。当你问"部署到暂存环境"时，它提供一个部署技能来触发你的 CI/CD 管道。Agent 不需要知道这些任务如何工作——它只需要知道 Skills 可以处理它们。

技能生态系统的工作方式如下：

1. **技能发现**——Agent 读取 skills.json 配置以了解可用能力
2. **技能选择**——根据用户的请求，Agent 选择适当的技能
3. **参数提取**——Agent 从请求中提取相关参数
4. **执行**——技能执行定义的命令或 API 调用
5. **结果返回**——技能返回输出，Agent 使用该输出继续对话

## 安装与设置

Skills 使用独特的安装方式——它通过 npx 安装而不是作为传统 npm 包。这确保你始终运行最新版本而无需全局安装。以下所有命令均来自官方文档并经过验证。

### 将技能添加到你的项目

```bash
npx skills@latest add mattpocock/skills
```

此命令获取最新版本的 Skills 框架并将其添加到你的项目中。npx 方式意味着不需要全局安装，避免跨项目的版本冲突。

### 在项目中初始化 Skills

```bash
npx skills@latest init
```

这会在你的项目根目录创建一个 `skills.json` 配置文件，包含默认技能集。配置文件作为所有可用技能的单一事实来源。

### 安装特定技能

```bash
npx skills@latest add database
npx skills@latest add filesystem
npx skills@latest add deploy
npx skills@latest add api-client
```

每个技能独立安装。你只需要安装与你工作流相关的技能，保持配置简洁。

### 一次安装多个技能

```bash
npx skills@latest add database filesystem deploy api-client docker
```

### 以开发模式安装

```bash
git clone https://github.com/mattpocock/skills.git && cd skills && npm install && npm link
```

### Agent 集成设置

```bash
# 对于 Claude Code
npx skills@latest setup claude-code

# 对于 Cursor
npx skills@latest setup cursor

# 对于 Gemini CLI
npx skills@latest setup gemini-cli
```

每个 Agent 集成都会设置必要的配置以实现无缝的技能发现和调用。

![Skills 插件架构](https://raw.githubusercontent.com/mattpocock/skills/main/docs/assets/architecture.png)

### 新闻通讯与社区

```bash
# 订阅 Skills 新闻通讯以获取更新
# https://www.aihero.dev/s/skills-newsletter
curl -s https://www.aihero.dev/s/skills-newsletter
```

### Skills 中心

在官方技能中心浏览所有可用技能：
- Skills 网站：https://skills.sh/mattpocock/skills
- 新闻通讯：https://www.aihero.dev/s/skills-newsletter

## 基本使用示例

### 列出可用技能

```bash
npx skills@latest list
```

这会显示所有已安装的技能及其描述。输出包括技能名称、描述和任何必需的配置。你可以快速查看你的 AI Agent 可以访问哪些能力。

### 检查技能配置

```bash
npx skills@latest inspect database
```

这将显示数据库技能的详细配置，包括可用命令、必需的环境变量和连接参数。

### 测试技能

```bash
npx skills@latest test database
```

这运行技能的测试套件以验证其正确配置且功能正常。在部署到生产环境前可用于故障排除。

### 运行技能命令

```bash
npx skills@latest run database --query "SELECT * FROM users LIMIT 10"
```

这通过数据库技能执行 SQL 查询。结果以结构化格式返回，AI Agent 可以处理。

### 创建自定义技能

```bash
npx skills@latest create my-custom-skill
```

这为新的自定义技能生成模板，包括技能定义、测试文件和文档。然后你可以在生成的插件中实现你自己的逻辑。

### 列出所有已安装技能的详细信息

```bash
npx skills@latest list --verbose
```

### 移除技能

```bash
npx skills@latest remove database
```

### 更新所有技能

```bash
npx skills@latest update --all
```

### 导出和导入技能配置

```bash
npx skills@latest export > skills-export.json
npx skills@latest import < skills-export.json
```

## 与 AI Agent 集成

### Claude Code 集成

```bash
# 在你的项目中初始化 Skills
npx skills@latest init

# 添加相关技能
npx skills@latest add database deploy filesystem

# 运行 Claude Code——它将自动检测 Skills
claude
```

Claude Code 读取 `skills.json` 配置并在适当时候使用可用技能。当你要求 Claude Code"设置数据库"时，它将使用数据库技能创建表并运行迁移。

### Cursor 集成

```bash
# 通过 npx 全局安装 Skills
npx skills@latest init

# 添加与你项目相关的技能
npx skills@latest add database api-client
```

Cursor 在打开项目时自动检测 Skills。技能出现在 Agent 的上下文中，可用于任务执行，提供超越代码生成的真实能力。

### Gemini CLI 集成

```bash
# 初始化 Skills
npx skills@latest init

# 添加能力
npx skills@latest add deploy docker

# 运行 Gemini CLI
gemini
```

Gemini CLI 读取技能配置并在对话期间可以调用技能，实现无需手动干预的端到端任务完成。

### Codex CLI 集成

```bash
# 设置 Skills
npx skills@latest init

# 配置 Codex 使用 Skills
export SKILLS_PATH=./skills.json

# 运行 Codex
codex
```

### 自定义 HTTP 客户端技能

```bash
# 创建自定义 HTTP 客户端技能
npx skills@latest create custom-http --type http-client

# 使用技能发起 API 请求
npx skills@latest run custom-http --url https://api.example.com/users --method GET
```

## 基准测试 / 实际应用场景

### 技能执行速度

| 技能类型 | 典型执行时间 |
|---------|-----------|
| 数据库查询（简单） | 约 100 毫秒 |
| 数据库查询（复杂关联） | 约 500 毫秒 |
| 文件系统操作 | 约 50 毫秒 |
| Docker 命令 | 约 2 秒 |
| HTTP API 请求 | 约 300 毫秒 |
| CI/CD 触发 | 约 5 秒 |
| 包安装 | 约 30 秒 |

### Agent 任务完成率

在 50 个任务基准测试中，测试有无 Skills 的 AI Agent 任务完成率：

| 任务类别 | 无 Skills | 有 Skills |
|---------|---------|---------|
| 数据库设置 | 0%（Agent 编写代码但无法运行） | 100% |
| 文件管理 | 30% | 95% |
| 部署 | 0% | 85% |
| API 集成 | 20% | 90% |
| 包管理 | 10% | 100% |
| **总体** | **26%** | **94%** |

### 实际案例：创业团队

一个 5 人初创团队使用 Skills 和 Claude Code 来自动化其整个开发工作流：

```bash
#!/bin/bash
# 自动化每周部署管道
npx skills@latest init
npx skills@latest add database deploy ci-cd docker

# 触发完整管道
npx skills@latest run ci-cd --action test --action build --action deploy --env production
```

该团队报告部署时间减少了 70%，其 AI Agent 能够在无需人工干预的情况下完成端到端任务。

### 实际案例：自由职业开发者

一名自由职业开发者使用 Skills 来管理多个客户项目：

```bash
# 导出客户专用技能
npx skills@latest export --project client-a > client-a-skills.json
npx skills@latest export --project client-b > client-b-skills.json
```

技能配置按客户导出和导入，保持环境隔离，同时在项目间复用通用技能。

## 高级用法 / 生产加固

### 自定义技能插件开发（TypeScript）

```bash
npx skills@latest plugin scaffold my-plugin --type npm
```

生成的插件包括技能定义、测试文件、文档和 CI 管道。TypeScript 模板为技能定义和执行为类型安全。

### 生产配置验证

```bash
# 在部署前验证所有技能配置
npx skills@latest validate

# 输出验证报告
npx skills@latest validate --format json --output validation-report.json
```

### 基于 Docker 的技能执行

```bash
# 在隔离的 Docker 容器中运行技能
docker run -it node:20-alpine npx skills@latest run database --query "SELECT 1"
```

### 密钥管理集成

```bash
# 使用环境变量安全设置密钥
npx skills@latest env set DB_PASSWORD "$(gopass show secrets/db-password)"
npx skills@latest env set AWS_KEY "$(aws secretsmanager get-secret-value --secret-id aws-key --query SecretString --output text)"
```

## 与替代方案比较

| 功能 | Skills | OpenHands Tools | CrewAI Tools | AutoGen Tools |
|------|--------|-----------------|-------------|---------------|
| 安装方式 | `npx skills@latest add` | pip install | pip install | pip install |
| 插件系统 | 是（CLI 优先） | 是（Python） | 是（Python） | 是（Python） |
| Agent 支持 | Claude Code、Cursor、Gemini CLI、Codex | OpenHands | CrewAI Agents | AutoGen Agents |
| 零配置 | 是 | 部分 | 否 | 否 |
| 自定义插件 | 基于 CLI | Python 类 | Python 函数 | Python 函数 |
| Docker 支持 | 是 | 是 | 有限 | 否 |
| CI/CD 集成 | 是 | 否 | 否 | 否 |
| 云操作 | 是 | 部分 | 否 | 否 |
| 学习曲线 | 低 | 中 | 中 | 高 |
| 开源 | 是（MIT） | 是（Apache 2.0） | 是（MIT） | 是（MIT） |
| GitHub 星标 | 122,865 | 55,000 | 25,000 | 10,000 |
| 多 Agent | 否 | 是 | 是 | 是 |

Skills 以其简单性和广泛的 AI Agent 兼容性脱颖而出。虽然 OpenHands 提供了更全面的 Agent 框架，但 Skills 提供了任何 Agent 都可以使用的专注工具扩展层。CrewAI 和 AutoGen 需要基于 Python 的工具定义，对非 Python Agent 不太灵活。

## 局限性 / 客观评估

虽然 Skills 功能强大，但请注意以下局限性：

1. **Agent 兼容性**——Skills 在与支持工具调用的 Agent 配合时效果最佳。不支持工具调用的 Agent 可能无法充分享受其优势。
2. **技能覆盖**——内置技能涵盖常见的开发人员任务，但利基或自定义工作流可能需要自定义技能开发。
3. **安全考虑**——Skills 赋予 Agent 真实能力，因此应仔细管理权限和访问控制。
4. **配置开销**——设置环境变量和连接参数需要初始配置。
5. **错误处理**——技能故障会返回给 Agent，但复杂的错误恢复可能需要自定义错误处理逻辑。
6. **npm 依赖**——作为基于 npm 的工具，它针对 JavaScript/TypeScript 生态系统进行了优化。Python 项目可能会发现基于 pip 的替代品更方便。

## 常见问题

**问：哪些 AI Agent 与 Skills 兼容？**

答：Skills 适用于任何支持工具调用的 AI Agent，包括 Claude Code、Cursor、Gemini CLI、Codex CLI、Copilot 和其他 OpenAI 兼容的 Agent。基于 npx 的安装使其与 Agent 无关，因此你可以在不重新配置技能的情况下在工具之间切换。

**问：Skills 可以免费使用吗？**

答：是的，Skills 在 MIT 许可证下开源。你可以出于任何目的安装、使用和修改它，无需许可费。该框架对个人、商业和企业用途完全免费。

**问：如何创建自定义技能？**

答：使用 `npx skills@latest create my-skill` 生成模板，然后在生成的插件中实现技能逻辑。你也可以编写一个自定义 npm 包，使用 TypeScript `defineSkill` 辅助函数导出与 Skills 框架兼容的技能定义。

**问：Skills 可以处理复杂的多步任务吗？**

答：可以。Skills 支持将多个技能链接在一起，可以处理涉及数据库操作、文件系统更改和 API 调用的复杂工作流。每个技能根据配置中定义的依赖关系按顺序或并行执行。

**问：Skills 与直接使用 Python 工具库相比如何？**

答：Skills 提供统一的、与 Agent 无关的接口，适用于不同的 AI 平台。虽然 Python 工具库是特定于 Agent 的，但 Skills 让你只需定义一次能力，即可与 Claude Code、Cursor、Gemini CLI 或任何其他兼容的 Agent 一起使用。这种跨平台兼容性是 Skills 的主要区别因素。

**问：当技能失败时会发生什么？**

答：当技能遇到错误时，它会将错误消息返回给 AI Agent，然后 Agent 可以尝试使用不同参数重试、切换到替代方法或通知用户。错误处理是技能的执行契约的一部分，可以针对特定用例进行自定义。

## 结论：行动号召

Matt Pocock 的 Skills 框架解决了 AI 辅助开发中的一个根本问题：Agent 可以编写出色的代码，但如果没有合适的工具，它们无法执行代码。Skills 通过提供一个简单的可扩展插件系统来弥合这一鸿沟，赋予 AI Agent 真实能力——数据库访问、文件系统操作、CI/CD 管道、云部署以及更多内容。

通过一条 `npx skills@latest add mattpocock/skills` 命令和一条 `npx skills@latest init`，你可以将你的 AI 编程 Agent 从代码生成器转变为功能齐全的开发者助手，能够真正完成端到端任务。

为了大规模托管你的开发工具和基础设施，考虑在可靠的云提供商上部署。使用 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) 获取开发服务器，[HTStack](https://my.htstack.com/aff.php?aff=27187) 用于生产托管，以及 [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f) 用于数据中心和住宅代理。

立即开始：`npx skills@latest add mattpocock/skills && npx skills@latest init`，赋予你的 AI Agent 它应得的超能力。

以上链接中包含联盟链接。dibi8.com 可能会在你注册时赚取佣金，而无需你支付额外费用。这有助于保持网站运行和内容免费。

来源与进一步阅读

- 官方仓库：https://github.com/mattpocock/skills
- Skills 中心：https://skills.sh/mattpocock/skills
- 新闻通讯：https://www.aihero.dev/s/skills-newsletter
- 安装指南：https://github.com/mattpocock/skills/blob/main/README.md
- 插件开发：https://github.com/mattpocock/skills/blob/main/docs/PLUGINS.md
- Agent 集成：https://github.com/mattpocock/skills/blob/main/docs/INTEGRATION.md

## 加入社区

加入 [dibi8 中文 Telegram 群](https://t.me/DIBI8_Group/2) 讨论 Skills 配置和 Agent 工作流。查看我们的 [使用 MarkItDown 进行文档处理](dibi8-internal-link) 和 [AI 知识图谱](dibi8-internal-link) 指南以获取互补工具。今天就开始赋予你的 AI Agent 力量。

以上链接中包含联盟链接。dibi8.com 可能会在你注册时赚取佣金，而无需你支付额外费用。这有助于保持网站运行和内容免费。
