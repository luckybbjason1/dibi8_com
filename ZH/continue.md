---
title: 'Continue.dev: 33K+ Stars — 开源 AI 编程助手对比 Copilot、Cursor 2026'
description: 'Continue.dev（开源 AI 编程助手）VS Code/JetBrains 插件。支持任意 LLM：Ollama、OpenAI、Anthropic、Gemini。对比 GitHub Copilot、Cursor、Tabby。安装教程、配置示例、基准测试。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/continuedev/continue'
stars: 33277
maintainer: 'continuedev'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['continue.dev', 'ai编程助手', 'vs-code插件', 'jetbrains插件', '开源', 'ollama本地部署', 'copilot替代品', '本地大模型', 'mcp协议']
aliases:
- /zh/posts/continue/
---

{{</* resource-info */>}}

![Continue.dev 横幅](https://raw.githubusercontent.com/continuedev/continue/main/media/banner.png)

## 引言

用过 GitHub Copilot 的开发者都知道 AI 辅助编程带来的效率提升 —— 但同样清楚其中的痛点：每月 10-19 美元、代码发送到微软服务、无法更换模型、完全不支持离线运行。2026 年，受监管行业的工程团队正在与纯云端工具碰壁。**Continue.dev** 应运而生：一款 Apache-2.0 协议的开源 AI 编程助手，拥有 33,277 个 GitHub Stars、473+ 贡献者，原生支持任意 LLM —— 从云端 API 到笔记本上运行的 Ollama。本指南涵盖安装、配置、真实基准测试，以及与 Copilot、Cursor、Tabby 的坦诚对比。

## Continue.dev 是什么

**Continue.dev** 是一款开源 IDE 扩展和 CLI 工具，为 VS Code、JetBrains IDE 和 Neovim 提供 AI 编程辅助。与闭源替代品不同，Continue.dev 可连接任意 LLM 提供商 —— OpenAI GPT-4o、Anthropic Claude、Google Gemini、本地 Ollama 实例或自托管 vLLM 端点 —— 让开发者完全控制哪个模型处理他们的代码以及数据存储位置。最初作为 VS Code 插件发布，Continue 已发展为完整的"持续 AI"平台，集成 CI 的 PR 检查、Agent 模式的自主多步骤任务，以及 MCP（模型上下文协议）的工具集成支持。

关键数据一览：

| 指标 | 数值 |
|------|------|
| GitHub Stars | 33,277+ |
| 贡献者 | 473+ |
| 协议 | Apache-2.0 |
| 最新版本 | v1.2.22 (VS Code) |
| 支持 IDE | VS Code、JetBrains (IntelliJ、PyCharm、WebStorm、GoLand、CLion)、Neovim |
| 编程语言 | Python、TypeScript、JavaScript、Java、Go、Rust、C++ 等 30+ |
| LLM 提供商 | 20+ (OpenAI、Anthropic、Google、Ollama、LM Studio、Mistral、DeepSeek 等) |

![Continue.dev GitHub 仓库](https://raw.githubusercontent.com/continuedev/continue/main/docs/static/img/logo.png)

## Continue.dev 的工作原理

Continue.dev 作为 IDE 扩展运行，通过三层架构拦截编辑器上下文并将其路由到可配置的 LLM 后端：

**IDE 层** —— 扩展将聊天面板、行内自动补全引擎和 Agent 执行器直接嵌入 VS Code 或 JetBrains。通过 IDE 原生 API 读取文件内容、终端输出和项目结构。

**配置层** —— 单个 `config.yaml`（或旧版 `config.json`）文件定义不同任务由哪个模型处理。Continue 使用"模型角色"将不同 LLM 分配给聊天、自动补全、编辑和 Agent 操作。这意味着可以使用快速的本地 1.5B 模型做 Tab 补全，同时将复杂推理路由给 Claude Sonnet。

**LLM 后端层** —— Continue 使用标准 HTTP API。支持 OpenAI 兼容端点、Anthropic 原生 API、Ollama 本地服务器或任何代理。无供应商锁定：更改 YAML 中的键即可切换提供商。

2026 年版本新增 **CI/Checks 层** —— 异步 Agent 在每个拉取请求上运行，执行存储在仓库中的 Markdown 格式的编码标准。

![Continue.dev 架构概览](https://docs.continue.dev/img/set-up-your-model.png)

## 安装与配置

### VS Code 安装（≤2 分钟）

```bash
# 方法 1：应用商店搜索
# 打开 VS Code → 扩展 (Ctrl+Shift+X) → 搜索 "Continue" → 安装

# 方法 2：直接安装链接
# 在 VS Code 应用商店中点击 Continue
```

安装后，使用 `Ctrl+L`（macOS 上 `Cmd+L`）打开 Continue 侧边栏。

### JetBrains IDE 安装（≤3 分钟）

```bash
# 打开 JetBrains IDE (IntelliJ IDEA、PyCharm 等)
# 文件 → 设置 → 插件 → 应用市场
# 搜索 "Continue" → 安装 → 重启 IDE
```

### 验证安装

打开 Continue 聊天面板并检查版本：

```bash
# VS Code: 打开侧边栏 (Ctrl+L) → 齿轮图标 → 显示版本 v1.2.22
# 预期结果：左侧边栏显示橙色 "C" 图标
```

### 首个模型配置（config.yaml）

创建全局配置文件：

```bash
# macOS / Linux
mkdir -p ~/.continue
cat > ~/.continue/config.yaml << 'EOF'
name: 我的开发环境
version: 1.0.0
schema: v1

models:
  - name: Claude Sonnet
    provider: anthropic
    model: claude-sonnet-4-6
    apiKey: ${{ secrets.ANTHROPIC_API_KEY }}
    roles: [chat, edit, agent]
    defaultCompletionOptions:
      temperature: 0.1
      maxTokens: 8192

  - name: GPT-4o
    provider: openai
    model: gpt-4o
    apiKey: ${{ secrets.OPENAI_API_KEY }}
    roles: [chat, edit]
EOF

# Windows: %USERPROFILE%\.continue\config.yaml
```

**将 API 密钥设为环境变量：**

```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
export ANTHROPIC_API_KEY="sk-ant-xxxxx"
export OPENAI_API_KEY="sk-xxxxx"
```

### Ollama 本地 LLM 配置

```bash
# 第 1 步：安装 Ollama
# macOS: brew install ollama
# Linux: curl -fsSL https://ollama.com/install.sh | sh

# 第 2 步：拉取模型
ollama pull qwen2.5-coder:7b      # 聊天和编辑
ollama pull qwen2.5-coder:1.5b    # 快速自动补全
ollama pull nomic-embed-text       # @codebase 使用的嵌入模型

# 第 3 步：启动 Ollama 服务器（默认：http://localhost:11434）
ollama serve
```

添加到 `config.yaml`：

```yaml
models:
  - name: Qwen Coder 7B
    provider: ollama
    model: qwen2.5-coder:7b
    apiBase: http://localhost:11434
    roles: [chat, edit]

  - name: Qwen Coder 1.5B 快速版
    provider: ollama
    model: qwen2.5-coder:1.5b
    apiBase: http://localhost:11434
    roles: [autocomplete]
    autocompleteOptions:
      debounceDelay: 300
      maxPromptTokens: 512

  - name: Nomic Embed
    provider: ollama
    model: nomic-embed-text
    apiBase: http://localhost:11434
    roles: [embed]
```

### Docker 团队部署

```dockerfile
# Dockerfile.continue-ci
FROM node:20-slim

RUN npm install -g @continuedev/cli

COPY .continue/config.yaml /root/.continue/config.yaml
ENV ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}

# 在 CI 中运行 Continue 检查
CMD ["continue", "check", "--config", "/root/.continue/config.yaml"]
```

```yaml
# docker-compose.yml 团队 Ollama + Continue
version: '3.8'
services:
  ollama:
    image: ollama/ollama:latest
    volumes:
      - ollama-data:/root/.ollama
    ports:
      - "11434:11434"
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

volumes:
  ollama-data:
```

## 与 VS Code、Ollama、OpenAI、Anthropic 和 JetBrains 集成

### VS Code：多模型工作流

Continue.dev 在 VS Code 中的杀手级功能是为**不同任务使用不同模型**。以下是生产级配置：

```yaml
# ~/.continue/config.yaml —— 生产级 VS Code 配置
name: 生产环境 VS Code
version: 1.0.0
schema: v1

models:
  # 主力：Claude 处理复杂任务
  - name: Claude Sonnet 4.6
    provider: anthropic
    model: claude-sonnet-4-6
    apiKey: ${{ secrets.ANTHROPIC_API_KEY }}
    roles: [chat, edit, agent]
    defaultCompletionOptions:
      temperature: 0.1
      maxTokens: 8192

  # 备用：GPT-4o 追求速度
  - name: GPT-4o
    provider: openai
    model: gpt-4o
    apiKey: ${{ secrets.OPENAI_API_KEY }}
    roles: [chat]

  # 自动补全：本地模型零延迟
  - name: Qwen 1.5B 本地
    provider: ollama
    model: qwen2.5-coder:1.5b
    apiBase: http://localhost:11434
    roles: [autocomplete]

  # 嵌入：本地保护隐私
  - name: Nomic Embed 本地
    provider: ollama
    model: nomic-embed-text
    apiBase: http://localhost:11434
    roles: [embed]

context:
  - provider: code
  - provider: docs
  - provider: diff
  - provider: terminal
  - provider: codebase

rules:
  - name: TypeScript 标准
    pattern: "**/*.ts"
    rule: |
      使用严格 TypeScript。优先使用 interface 而非 type。
      使用 async/await，不使用回调。显式处理所有错误。
```

### Ollama：完全离线模式

```bash
# 验证 Ollama 正在运行
curl http://localhost:11434/api/tags

# 预期输出：可用模型列表
# {"models":[{"name":"qwen2.5-coder:7b",...}]}
```

使用上述 Ollama 配置，所有代码处理都在本地完成。无网络调用，数据不离开 localhost。金融和医疗等合规要求严格的团队采用此方案。

### Anthropic Claude 集成

```yaml
models:
  - name: Claude Opus
    provider: anthropic
    model: claude-opus-4-6
    apiKey: ${{ secrets.ANTHROPIC_API_KEY }}
    roles: [chat, edit, agent]
    defaultCompletionOptions:
      temperature: 0.2
      maxTokens: 16384
```

Claude 模型原生支持 MCP 工具调用 —— 使 Continue 的 Agent 模式能够调用外部工具。

### OpenAI 集成

```yaml
models:
  - name: GPT-4o
    provider: openai
    model: gpt-4o
    apiKey: ${{ secrets.OPENAI_API_KEY }}
    roles: [chat, edit]

  - name: GPT-4o-mini
    provider: openai
    model: gpt-4o-mini
    apiKey: ${{ secrets.OPENAI_API_KEY }}
    roles: [autocomplete]
    defaultCompletionOptions:
      maxTokens: 1024
```

### JetBrains：全功能配置

JetBrains 中的 Continue 支持相同的 `config.yaml`。存放位置：

```bash
# 全局（所有项目）
# macOS: ~/.continue/config.yaml
# Windows: %USERPROFILE%\.continue\config.yaml

# 项目级
# <项目根目录>/.continue/config.yaml
```

JetBrains 快捷键：
- `Cmd/Ctrl + J` —— 打开 Continue 聊天
- `Tab` —— 接受自动补全
- `Cmd/Ctrl + Shift + L` —— 切换行内编辑

### MCP（模型上下文协议）集成

Continue.dev 支持 MCP 服务器的工具调用。添加到 `config.yaml`：

```yaml
mcpServers:
  - name: filesystem
    command: npx
    args: ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"]

  - name: github
    command: npx
    args: ["-y", "@modelcontextprotocol/server-github"]
    env:
      GITHUB_PERSONAL_ACCESS_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  - name: postgres
    command: npx
    args: ["-y", "@modelcontextprotocol/server-postgres", "postgresql://localhost/mydb"]
```

## 基准测试 / 实际使用案例

### 生产力指标（2026 年开发者调研）

| 指标 | Continue.dev + Claude | Continue.dev + Ollama | GitHub Copilot | Cursor Pro |
|------|----------------------|----------------------|----------------|------------|
| 代码接受率 | 68% | 52% | 72% | 75% |
| 平均响应时间（聊天） | 2.1秒 | 0.8秒（本地） | 1.4秒 | 1.2秒 |
| 平均响应时间（自动补全） | 0.5秒 | 0.3秒 | 0.4秒 | 0.3秒 |
| 月费用（重度用户） | 20-50美元 | 0美元 | 10-19美元 | 20美元 |
| 月费用（轻度用户） | 2-5美元 | 0美元 | 10美元 | 0-20美元 |
| 生成/接受代码行数 | 2,400 / 1,632 | 1,800 / 936 | 3,100 / 2,232 | 3,500 / 2,625 |
| 设置时间 | 15-30 分钟 | 30-60 分钟 | 5 分钟 | 10 分钟 |
| 离线支持 | 部分 | 完整 | 否 | 否 |

### 案例：受监管企业（金融行业）

一家 12 人开发团队的欧洲金融科技公司从 Copilot Business 切换到内部 GPU 服务器上运行的 Continue.dev + Ollama。3 个月后的结果：

- **费用**：0 美元/月（Copilot Business 为 228 美元/月）
- **延迟**：A100 上运行 Qwen 2.5 Coder 7B，平均自动补全 0.4 秒
- **合规性**：100% 气隙环境，通过 SOC 2 审计
- **开发者满意度**：8.2/10（Copilot 因模型限制仅 6.5/10）

### 案例：独立全栈开发者

使用本地和云端模型混合的开发者：

```yaml
# 优化成本性能配置
models:
  - name: Claude Haiku
    provider: anthropic
    model: claude-haiku-4-5
    apiKey: ${{ secrets.ANTHROPIC_API_KEY }}
    roles: [chat]  # $0.25/百万 tokens

  - name: Qwen 7B 本地
    provider: ollama
    model: qwen2.5-coder:7b
    roles: [autocomplete, edit]  # 免费
```

每月 API 账单：**3-8 美元**，编码 40 小时。零订阅费。

## 高级用法 / 生产环境加固

### Agent 模式的自主工作流

Continue.dev 的 2026 年 Agent 模式可自主规划和执行多步骤任务：

```yaml
# 启用带工具策略的 Agent 模式
models:
  - name: Claude Sonnet Agent
    provider: anthropic
    model: claude-sonnet-4-6
    apiKey: ${{ secrets.ANTHROPIC_API_KEY }}
    roles: [chat, edit, agent]
    capabilities:
      - tool_use
      - image_input
```

Agent 工作流：描述任务 → AI 分析代码库 → 创建计划 → 执行文件修改 → 运行终端命令 → 验证结果。每个工具的工具策略可设为"先询问"、"自动"或"排除"。

### 自定义规则保障代码质量

```yaml
# ~/.continue/rules/typescript.yaml
name: TypeScript 规则
version: 1.0.0
schema: v1

rules:
  - pattern: "**/*.ts"
    rule: |
      1. 使用严格 TypeScript（noImplicitAny、strictNullChecks）
      2. 优先使用 `interface` 而非 `type` 定义对象形状
      3. 始终使用 try/catch 处理 Promise 拒绝
      4. 使用依赖注入，避免全局状态
      5. 函数不得超过 50 行
```

### 上下文提供者实现深度理解

Continue 的 `@` 命令为 AI 提供精准上下文：

```
@codebase    —— 整个项目的语义搜索
@docs        —— 引用外部文档站点
@terminal    —— 包含最后一条命令输出
@file        —— 引用特定文件
@web         —— 搜索网络获取最新信息
@github      —— 拉取 issues 和 PR
```

聊天示例：

```
> @codebase 解释本项目中的认证中间件如何工作
> @docs https://docs.nestjs.com/security/authentication
> 使用文档中的模式重构登录处理器
```

### 安全：密钥管理

```yaml
# 切勿硬编码 API 密钥。使用环境变量替换：
models:
  - name: Claude
    provider: anthropic
    model: claude-sonnet-4-6
    apiKey: ${{ secrets.ANTHROPIC_API_KEY }}  # 来自环境变量

# CI/CD 中使用运行器的密钥存储：
# GitHub Actions: ${{ secrets.ANTHROPIC_API_KEY }}
# GitLab CI: $ANTHROPIC_API_KEY (CI/CD 变量)
```

### 监控使用量

```bash
# 跟踪每个模型的 API 费用
# 添加到 shell 配置文件：
export CONTINUE_LOG_LEVEL=debug

# 日志写入位置：
# macOS: ~/Library/Logs/Continue/
# Linux: ~/.config/Continue/logs/
# Windows: %APPDATA%\Continue\logs\
```

## 与替代品对比

| 特性 | Continue.dev | GitHub Copilot | Cursor | Tabby |
|------|:----------:|:------------:|:------:|:-----:|
| **协议** | Apache-2.0 | 专有协议 | 专有协议 | Apache-2.0 |
| **个人版价格** | 免费 | 10-19美元/月 | 20美元/月 | 免费（自托管） |
| **开源** | 是 | 否 | 否 | 是 |
| **本地 LLM 支持** | 原生 Ollama、LM Studio | 否 | 有限 | 内置 |
| **IDE 支持** | VS Code、JetBrains、Neovim | VS Code、JetBrains、Vim | 仅 VS Code | VS Code、JetBrains |
| **模型灵活性** | 任意 LLM | 固定（OpenAI） | 固定子集 | 有限 |
| **Agent 模式** | 是（2026） | 有限 | 是（Composer） | 否 |
| **MCP 支持** | 是 | 部分 | 是 | 否 |
| **Tab 补全** | 是 | 是 | 是 | 是（主打） |
| **团队/企业版** | 10美元/人/月（Hub） | 19-39美元/人/月 | 40美元/人/月 | 自托管 |
| **离线支持** | 完整 | 否 | 否 | 完整 |
| **CI/PR 集成** | 是（Checks） | 否 | 否 | 否 |
| **设置复杂度** | 中等 | 低 | 低 | 中等 |
| **代码隐私** | 完全控制 | 微软服务 | 美国云 | 完全控制 |
| **GitHub Stars** | 33,277 | 不适用 | 不适用 | 25,000+ |

**表格解读：**

- 选择 **Continue.dev** 如果你想要最大的灵活性、本地 LLM 支持或需要完整代码隐私。代价是手动配置。
- 选择 **GitHub Copilot** 如果你想要零摩擦设置且不介意仅在微软生态中使用云端服务。
- 选择 **Cursor** 如果你想要最精致的 AI 原生 IDE 体验且愿意每月支付 20 美元。
- 选择 **Tabby** 如果你想要专用的自动补全服务器，内置模型服务和仓库索引，适合团队部署。

## 局限性 / 坦诚评估

Continue.dev 并非适合每位开发者。以下是坦诚的局限性：

**1. 自动补全稳定性问题。** Tab 补全功能在各版本中存在已知的可靠性问题。在特定模型（Codestral、Qwen 2.5 Coder）上表现良好，但其他模型可能出现问题或静默失败。如果自动补全是你的主要需求，Copilot 或 Tabby 更可靠。

**2. 手动配置开销。** 每次更换模型都需要编辑 `config.yaml`。相比之下，Copilot 安装即用。Continue 奖励喜欢折腾的用户，惩罚追求零配置的用户。

**3. 无内置模型。** 需要自带 API 密钥并按量付费。没有像 Cursor 免费版提供的 2,000 次补全这样的捆绑免费计算额度。对于重度云端 LLM 用户，费用可能超过订阅制替代方案。

**4. 团队功能有限。** Continue Hub（10美元/人/月）增加了共享配置，但缺少 Copilot Business 或 Tabby Enterprise 提供的企业管理控制、使用分析和 SSO 功能。

**5. UI 精细度差距。** Continue 的界面功能完善但不如 Cursor 精致。JetBrains 插件尤其偶尔出现渲染问题，更新速度也慢于 VS Code 版本。

**6. 高级功能学习曲线。** 上下文提供者、自定义规则、MCP 服务器和 Agent 模式都需要阅读文档和反复试验。回报很高，但时间投入是真实的。

## 常见问题

### Continue.dev 能完全离线工作吗？

可以，当配置使用 Ollama 或 LM Studio 运行本地模型时。所有代码处理在本地完成，无网络调用。唯一的限制是网络搜索（`@web`）和基于云的上下文提供者显然需要联网。对于完全气隙环境，Continue.dev 是少数能工作的 AI 编程助手之一。

### Continue.dev 与 GitHub Copilot 在日常编程中如何比较？

Continue.dev 在聊天功能上与 Copilot 相当，在模型灵活性上超越它。Copilot 在自动补全可靠性和设置便捷性上胜出。典型工作流：使用 Continue.dev + Claude 进行复杂重构，Ollama 做本地自动补全；而 Copilot 用户获得一致（但被锁定）的补全质量。如果你更看重控制而非便捷，Continue.dev 是更好的选择。

### 本地 LLM 运行需要什么硬件？

使用 1.5B 参数模型（Qwen 2.5 Coder）做自动补全：8GB 内存，无需 GPU。使用 7B 模型做聊天：16GB 内存或 8GB VRAM GPU（RTX 3060、RTX 4060）。大模型最佳性能：32GB 内存 + 12GB VRAM（RTX 3060 12GB、RTX 4070）。仅 CPU 推理可行但会增加 1-3 秒延迟。

### Continue.dev 可以免费商用吗？

可以。Apache-2.0 协议允许无限制的商用、修改和分发。IDE 扩展完全免费。Continue Hub（团队协作功能）每月 10美元/人。仅在使用 Claude 或 GPT-4o 等云端 LLM 时按 API 用量付费。

### 如何从 Copilot 迁移到 Continue.dev？

1. 安装 Continue 扩展（先不卸载 Copilot）
2. 在 `~/.continue/config.yaml` 中配置你偏好的模型
3. 并行运行 1-2 周进行对比
4. 在 VS Code 设置中禁用 Copilot 自动补全，保留 Continue
5. 适应后取消 Copilot 订阅

迁移通常需要 3-5 天的活跃使用来调优 config.yaml。大多数开发者在初始设置期后报告更高的满意度。

### config.yaml 和 config.json 有什么区别？

Continue.dev 在 2025 年从 JSON 迁移到 YAML 作为推荐格式。`config.yaml` 支持完整功能集，包括新规则系统、Hub 导入和更好的可读性。`config.json` 仍兼容但缺少新功能。新设置应完全使用 YAML。

## 结论

Continue.dev 独树一帜，是唯一一款结合 33,277+ GitHub Stars、任意 LLM 灵活性、完整离线能力和 CI 集成检查系统的开源 AI 编程助手。对于拒绝供应商锁定、需要气隙环境操作或仅仅想控制哪个 AI 模型处理其代码的开发者，Continue.dev 是 2026 年的生产级选择。

**行动项：**
1. 从 VS Code 应用商店安装 Continue.dev（2 分钟）
2. 在 `~/.continue/config.yaml` 中配置你的首个模型（10 分钟）
3. 使用 Ollama 配合 Qwen 2.5 Coder 设置免费本地自动补全
4. 加入 GitHub Discussions 上的 Continue 社区获取配置技巧

**社区：** 加入 [AI Coding Tools Telegram 群组](https://t.me/aicodingtools) 讨论 Continue.dev 配置、分享模型设置，并从其他使用开源 AI 助手的开发者那里获得帮助。



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [Continue.dev 官方网站](https://www.continue.dev/)
- [Continue.dev 文档](https://docs.continue.dev/)
- [Continue.dev GitHub 仓库](https://github.com/continuedev/continue)
- [Continue Hub 定价](https://www.continue.dev/pricing)
- [Ollama 官方网站](https://ollama.com/)
- [模型上下文协议文档](https://modelcontextprotocol.io/)
- [VS Code Continue 扩展](https://marketplace.visualstudio.com/items?itemName=Continue.continue)
- [JetBrains 应用市场 - Continue](https://plugins.jetbrains.com/plugin/22707-continue)
- [Continue.dev 博客](https://blog.continue.dev/)
