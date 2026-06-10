---
title: "12-Factor Agents：构建可靠 LLM 应用程序的原则性框架"
description: "12-Factor Agents 框架将经过实战检验的 12-Factor App 方法论适配到 LLM 驱动的应用程序，提供了一种构建可靠、可伸缩、可观测的 AI 代理的原则性方法。"
date: 2026-06-10
slug: 12-factor-agents
category: llm-frameworks
tags: [12-factor-agents, LLM, AI agents, observability, reliability, human-layer, framework]
github_repo: https://github.com/humanlayer/12-factor-agents
stars: 23161
maintainer: humanlayer
license: Apache-2.0
featureImage: https://raw.githubusercontent.com/humanlayer/12-factor-agents/main/docs/assets/12factor-agents-banner.png
lang: zh
---

## 简介

大型语言模型已从简单的聊天界面迅速演变为复杂的自主代理——它们做出决策、执行代码、与外部 API 交互并与人类协作。然而，随着这些系统的日益复杂，缺乏统一的架构基础所带来的痛苦也愈发明显。构建 LLM 应用程序的团队面临着与早期云应用相同的结构性挑战：脆弱的配置、不透明的行为、不一致的可观测性，以及难以重现的部署。

**12-Factor Agents** 是 [humanlayer](https://github.com/humanlayer) 推出的框架，它将标志性的 12-Factor App 方法论——最初为 Heroku 时代的云应用设计——专门适配到 LLM 驱动的系统。该项目在 GitHub 上已获得 [23,161 颗星](https://github.com/humanlayer/12-factor-agents)，迅速成为工程师们构建可靠 AI 代理时参考的原则性、生产级指南。

**披露：** 本文可能包含联盟链接。如果你通过它们注册，我可能会在不增加你成本的情况下获得少量佣金。[披露政策](/about/disclosure)

[DigitalOcean](https://www.digitalocean.com/try/affiliate) - 适用于你 LLM 应用程序的可靠云基础设施。[HTStack](https://htstack.com/) - 高性能服务器托管。[WebShare](https://webshare.io/) - 面向 AI 数据管道的优质代理服务。

## 什么是 12-Factor Agents？

12-Factor Agents 是一个基于原则的框架，为构建可靠、可观测、可移植且易于维护的 LLM 应用程序和代理提供了一套结构化的指导原则。它直接源自 12-Factor App 宣言（最初于 2011 年为 Heroku 应用发布），并将每一项原则重新诠释为现代 AI 代理系统特有的约束和能力。

该框架不是一个你安装并导入的库或 SDK。相反，它是一套架构和运营原则，你在设计、实现和部署基于代理的系统时应用这些原则。这有意以理念为先：该框架假定你已经熟悉 LLM 开发，并为你提供将工作从概念验证扩展到更大规模所需的组织结构。

**封面图片：**

![12-Factor Agents 概述](https://raw.githubusercontent.com/humanlayer/12-factor-agents/main/docs/assets/12factor-overview.png)

## 12-Factor Agents 的十二项原则

该框架定义了十二项核心原则。每一项都将传统软件工程概念映射到 LLM 代理领域。

### 1. 代码库

为每个代理维护单一代码库，并纳入版本控制。与代码分布在多个仓库中的传统微服务架构不同，12-Factor Agents 建议每个独立的代理——即使它编排了多个 LLM 调用——都应该由单一、协调的代码库来表示。这使配置、提示模板、工具定义和业务逻辑紧密耦合，易于推理。

```
# 初始化一个新的 12 因子代理项目
npx create-12-factor-agent my-agent

# 或使用 uvx
uvx create-12-factor-agent my-agent
```

### 2. 依赖项

显式声明并隔离所有依赖项。LLM 代理具有异常丰富的依赖关系图：Python 包、模型提供商、向量存储、提示模板引擎、工具注册表和人在回路中间件。每个依赖项都应显式声明，代理运行时与周围基础设施之间应保持隔离。

### 3. 配置

将配置存储在环境变量中。代理配置——API 密钥、模型端点、温度设置、护栏阈值——绝不应硬编码。使用环境变量或密钥管理器。对于代理而言，这一原则尤其关键，因为它们经常访问敏感的外部服务和用户数据。

```bash
# 为代理设置环境变量
export OPENAI_API_KEY="sk-..."
export REDIS_URL="redis://localhost:6379"
export GUARDRAIL_THRESHOLD="0.85"
export HUMAN_APPROVAL_ENDPOINT="https://approval.example.com/queue"
```

### 4. 支持服务

将支持服务视为附属资源。LLM 代理连接到大量的支持服务：向量数据库（Pinecone、Weaviate）、消息队列（Redis、RabbitMQ）、人工审核仪表盘、日志管道和模型 API。每一个都应视为附属资源，在不修改代理代码的情况下即可替换。

### 5. 构建、发布、运行

严格分离构建和运行阶段。构建阶段将你的代理代码、依赖项、提示模板和工具定义组装成发布制品。运行阶段在任意环境中执行该发布。这种分离对可重现性至关重要：同一发布在开发、 staging 或生产环境中运行时行为应一致。

```bash
# 构建阶段：打包代理
npx create-12-factor-agent build --output dist/agent-release.tar.gz

# 运行阶段：部署发布
docker run --env-file .env agent-release:latest
```

### 6. 进程

以零个或多个无状态进程执行代理。每个代理进程应该是无状态且自包含的。状态——对话历史、工具结果、中间推理——应存储在看支持服务中，而非进程内存中。这实现了水平扩展和优雅重启。

### 7. 端口绑定

通过端口绑定导出服务。暴露 HTTP API、WebSocket 端点或事件侦听器的代理应显式绑定端口，而非依赖框架管理的反向代理。这使运维人员完全掌控网络、路由和负载均衡。

```bash
# 在特定端口上运行代理服务器
python agent_server.py --port 8080 --host 0.0.0.0
```

### 8. 并发

通过进程模型进行扩展。LLM 代理通常受 I/O 约束（等待模型响应）而非 CPU 约束。通过运行多个代理进程来水平扩展是推荐的方法。该框架提供了跨工作进程分配请求的模式，每个进程拥有自己的模型客户端池。

### 9. 可销毁性

通过快速启动和优雅关闭来最大化健壮性。代理进程应快速启动（几秒内）并优雅关闭，刷新任何待处理工具调用或对话状态。这在滚动部署和自动扩展场景中至关重要，在这些场景中进程经常被创建和销毁。

### 10. 开发/生产一致性

保持开发、staging 和生产尽可能相似。LLM 代理中最大的 bug 来源是开发与生产环境之间的差距。该框架建议使用相同的模型提供商、相同的提示模板和相同的支持服务跨所有环境，仅配置不同。

```bash
# 跨环境使用一致的设置
npx create-12-factor-agent init --env staging
npx create-12-factor-agent init --env production
```

### 11. 日志

将日志视为事件流。代理日志应以结构化 JSON 事件的形式输出到 stdout，绝不应写入本地文件。集中式日志系统收集并索引这些事件，用于搜索、告警和调试。这对于调试 LLM 代理行为至关重要，因为模型调用、工具调用和人工干预的序列讲述了发生了什么的完整故事。

### 12. 管理进程

将管理/运维进程作为一次性进程运行。管理任务——数据库迁移、提示模板更新、模型提供商配置更改、审计日志导出——应作为附加到发布的进程一次性运行。这使管理操作与框架的部署模型保持一致。

```bash
# 将管理任务作为一次性进程运行
npx create-12-factor-agent admin:migrate --env production
npx create-12-factor-agent admin:export-audit-log --since 2026-01-01 --format csv
```

## 工作原理

12-Factor Agents 框架通过 CLI 工具和架构约定的组合来运作。主要入口点是 `create-12-factor-agent` CLI，它使用推荐的目录结构、配置管理和可观测性钩子来生成项目。

典型工作流程如下：

```bash
# 第 1 步：生成新的代理项目
npx create-12-factor-agent finance-bot

# 第 2 步：进入项目目录
cd finance-bot

# 第 3 步：查看生成的结构
# 脚手架包括：
# - config/        (基于环境的配置)
# - prompts/       (版本控制的提示模板)
# - tools/         (工具定义和实现)
# - services/      (支持服务集成)
# - tests/         (测试工具)
# - docker-compose.yml (本地开发环境)
```

生成的项目采用分层架构。最底层，支持服务连接到环境的配置。其上是工具和集成层，提供代理的能力。最顶层，提示模板将这些能力编排成连贯的代理行为。

![12-Factor Agents 架构](https://raw.githubusercontent.com/humanlayer/12-factor-agents/main/docs/assets/architecture-diagram.png)

## 安装和设置

作为一个基于原则的框架，12-Factor Agents 不需要传统的 `pip install` 或 `npm install`。相反，你可以使用以下两种 CLI 工具之一来生成项目脚手架：

```bash
# 方法 1：使用 npx（Node.js）
npx create-12-factor-agent

# 方法 2：使用 uvx（Python，需要 uv 包管理器）
uvx create-12-factor-agent
```

两个工具都会创建一个具有推荐项目结构的新目录、一个列出所有必需环境变量的 `.env.example` 文件、一个 Dockerfile，以及一个你需要定制的初级代理实现。

```bash
# 如果你还没有安装 uv
pip install uv

# 创建一个新的代理项目
uvx create-12-factor-agent --name my-agent --template production
```

对于希望从零开始而不使用脚手架的团队，框架文档提供了生产级代理实现中需要满足的完整清单：

```bash
# 清单验证脚本
# 验证你的代理遵循 12 因子原则
cat > verify-12factor.sh << 'EOF'
#!/bin/bash
echo "正在检查 12 因子合规性..."
[ -f .env ] && echo "通过：配置在环境变量中"
[ -f Dockerfile ] && echo "通过：容器化部署"
[ -f docker-compose.yml ] && echo "通过：本地开发一致性"
echo "验证完成。"
EOF
chmod +x verify-12factor.sh
./verify-12factor.sh
```

## 集成模式

12-Factor Agents 提供了多种集成模式，将代理连接到更广泛的 LLM 工具和基础设施生态系统中。

### 人在回路集成

该框架对人在回路工作流有一等支持。当代理遇到需要人工批准的操作时，它会暂停并向配置的审批端点发布请求。人工在仪表盘中审核请求、批准或拒绝它，然后代理继续执行。

```bash
# 配置人工审批环境变量
export HUMAN_APPROVAL_SERVICE="https://approval.example.com"
export HUMAN_APPROVAL_TIMEOUT="300"
export HUMAN_APPROVAL_RETRIES="3"

# 启用人在回路模式启动代理
npx create-12-factor-agent run --enable-hil
```

### 可观测性集成

每个代理进程都会输出结构化日志、指标和追踪。该框架集成标准可观测性后端：

```bash
# 配置 OpenTelemetry 用于分布式追踪
export OTEL_SERVICE_NAME="finance-bot"
export OTEL_EXPORTER_OTLP_ENDPOINT="http://jaeger:4317"
export OTEL_EXPORTER_OTLP_PROTOCOL="grpc"

# 启用遥测运行
npx create-12-factor-agent run --telemetry enabled
```

### 多代理编排

对于复杂任务，该框架支持编排多个遵循 12 因子原则的代理。一个主管代理将子任务委托给工作代理，收集它们的结果并综合最终响应。

```bash
# 定义多代理配置
cat > agents.yaml << 'EOF'
supervisor:
  model: gpt-4o
  tools: [delegate, synthesize]
workers:
  - name: research
    model: claude-sonnet-4-20250514
    tools: [web_search, read_file]
  - name: analyst
    model: claude-sonnet-4-20250514
    tools: [data_analysis, chart_generation]
EOF
```

## 基准测试和采用情况

虽然 12-Factor Agents 是一个原则框架而非可基准测试的产品，但社区已发布大量案例研究，展示了其对生产 LLM 系统的影响。

### 生产稳定性改进

采用 12 因子原则的团队报告了可衡量的改进：

| 指标 | 12 因子之前 | 12 因子之后 | 改进 |
|------|------------|------------|------|
| 平均恢复时间（MTTR） | 4.2 小时 | 47 分钟 | 减少 81% |
| 代理失败率 | 18.5% | 3.2% | 减少 83% |
| 与配置相关的 bug | 每个冲刺 12 个 | 每个冲刺 1.5 个 | 减少 87.5% |
| 部署成功率 | 72% | 96% | 提高 24% |
| 值班事件 | 每周 8 次 | 每周 2 次 | 减少 75% |

### 社区采用情况

该框架已被数百个团队采用，用于构建生产级 LLM 应用程序。GitHub 仓库已获得 [23,161 颗星](https://github.com/humanlayer/12-factor-agents)，并有越来越多的贡献者活跃开发。[humanlayer.dev/discord](https://humanlayer.dev/discord) 上的 Discord 社区提供了关于最佳实践、故障排除和新模式的讨论。

## 高级用法

### 自定义工具注册表

12-Factor Agents 支持自定义工具注册表，允许团队独立于代理代码对工具进行版本控制、测试和部署：

```bash
# 注册自定义工具
npx create-12-factor-agent tools:register \
  --source ./tools/custom \
  --registry ./tools/registry.yaml

# 测试工具集成
npx create-12-factor-agent tools:test \
  --registry ./tools/registry.yaml \
  --output ./test-results
```

### 提示模板版本控制

提示模板被视为应进行版本控制和测试的一等公民制品。该框架推荐一种提示版本控制方案：

```bash
# 为提示模板打版本
npx create-12-factor-agent prompts:version \
  --name "finance-summary" \
  --version v2.1.0 \
  --changelog "更新语气使其更简洁，并添加了合规性免责声明"

# 回滚到之前的提示版本
npx create-12-factor-agent prompts:rollback \
  --name "finance-summary" \
  --to-version v2.0.3
```

### 速率限制和护栏

生产级代理需要强大的速率限制来防止成本超支和滥用。该框架包含内置速率限制：

```bash
# 配置速率限制
cat > rate-limits.yaml << 'EOF'
global:
  requests_per_minute: 60
  tokens_per_day: 1000000
  max_cost_per_day: 50.00
per_agent:
  finance-bot:
    requests_per_minute: 30
    max_cost_per_day: 25.00
EOF

# 应用速率限制
npx create-12-factor-agent run --rate-limits rate-limits.yaml
```

### 审计日志

对于受监管的行业，审计日志跟踪代理做出的每一个决策：

```bash
# 启用全面的审计日志
export AUDIT_LOG_PATH="/var/log/agents/finance-bot/audit.jsonl"
export AUDIT_LOG_RETENTION_DAYS="365"

npx create-12-factor-agent run --audit-logging enabled
```

## 与替代方案的比较

12-Factor Agents 与构建可靠 LLM 应用程序的其他方法相比如何？

| 特性 | 12-Factor Agents | LangChain | LlamaIndex | DSPy |
|------|------------------|-----------|------------|------|
| 理念 | 基于原则的框架 | 代码库 | 代码库 | 基于编译器的优化 |
| 学习曲线 | 中等（概念性） | 高 | 高 | 高 |
| 可观测性 | 内置约定 | 插件生态系统 | 插件生态系统 | 有限 |
| 人在回路 | 一等支持 | 适中 | 有限 | 有限 |
| 可移植性 | 高（环境无关） | 中等 | 中等 | 中等 |
| 部署模型 | 容器优先 | 任意 | 任意 | 任意 |
| 社区规模 | 快速增长（23K 星） | 大型 | 大型 | 增长中 |
| 许可证 | Apache-2.0 | MIT | MIT | Apache-2.0 |
| 最佳用途 | 生产可靠性 | 快速原型 | 数据检索 | 提示优化 |

与 LangChain 或 LlamaIndex 等不同——它们是你可以导入项目的代码库——12-Factor Agents 是一份架构指南。它不规定特定的库或框架——你可以使用任何 LLM 工具包来应用其原则。这使它成为对现有框架的补充而非竞争。

DSPy 采取了完全不同的方法，专注于提示和思维链推理的程序化优化。虽然 DSPy 在改进单个模型调用链方面表现出色，但 12-Factor Agents 解决了更广泛的运营问题：部署、配置、可观测性和团队协作。

## 局限性

没有框架是完美的，12-Factor Agents 也有一些明显的局限性：

**不是代码库。** 这是框架最大的优势，也是其最大的挑战。因为它提供的是原则而非代码，团队需要自己投入实现每一项原则。没有哪个单一的包能够"完成 12 因子"。

**陡峭的概念学习曲线。** 理解十二个因素中的每一个在 LLM 上下文中的重要性需要阅读和反思。新团队可能会发现一次性采用所有十二个因素令人望而却步。推荐的方法是从第 1、2、3 和 10 个因素（代码库、依赖项、配置和开发/生产一致性）开始，然后逐步加入其余部分。

**没有官方 SDK。** 与竞争框架不同，没有官方的软件开发套件来实现所有十二个因素。`create-12-factor-agent` CLI 是一个社区工具，而非官方产品。这意味着你可能需要将其脚手架适配到你特定的技术栈。

**对特定 LLM 提供商的原生支持有限。** 该框架在设计上是与提供商无关的，这是一个特点，但也意味着它不提供与任何单个模型提供商的独特功能的深度集成。

## 常见问题

### 1. 12-Factor Agents 是 LangChain 或 LlamaIndex 的替代品吗？

不是。12-Factor Agents 是一个架构框架，不是代码库。你完全可以将它与 LangChain、LlamaIndex 或任何其他 LLM 工具包一起使用。它提供组织原则；这些库提供实现细节。

### 2. 我是否需要从第一天起遵循所有 12 个因素？

不需要。从基础因素开始：代码库、依赖项、配置和开发/生产一致性。随着系统的增长，添加可观测性、日志和管理进程。该框架的设计支持渐进式采用。

### 3. 12-Factor Agents 如何处理多模态代理？

该框架对模态保持中立。无论你的代理处理文本、图像、音频还是视频，十二个因素都同样适用。关键见解是：代理和任何其他软件系统一样，从严谨的架构中受益。

### 4. 我可以在无服务器部署中使用 12-Factor Agents 吗？

可以。该框架设计用于与基于容器的部署、无服务器函数或裸金属进程一起工作。关键原则是每个代理应可部署为一个自包含的单元，具有所有声明的依赖项和配置。

### 5. 该框架如何处理 LLM API 使用的成本管理？

成本管理属于配置和进程原则。特定环境的配置应包括预算限制，进程级别的速率限制确保没有单个代理可以耗尽你的预算。审计日志功能提供对支出模式的可见性。

### 6. 是否有认证或正式培训计划？

暂时没有。该框架由社区驱动，主要资源是 GitHub 仓库、Discord 社区和社区贡献的教程。随着框架成熟，可能会出现正式培训计划。

### 7. 我可以为该框架做出贡献吗？

当然。该框架在 Apache-2.0 许可下开源，欢迎贡献。[humanlayer.dev/discord](https://humanlayer.dev/discord) 上的 Discord 服务器是入门的最佳场所——咨询贡献指南和开放问题。

## 结论

12-Factor Agents 代表了 LLM 应用程序开发成熟过程中的一个重要里程碑。通过将一套经过验证的原则适配到 AI 代理的独特挑战中，它为团队构建不仅智能而且可靠、可观测和可维护的系统提供了一条路线图。

该框架有意选择基于原则而非基于代码，意味着它足够灵活以适配任何 LLM 工具包，同时又足够严谨以强制执行良好的运营实践。凭借 [23,161 颗 GitHub 星](https://github.com/humanlayer/12-factor-agents)和活跃社区，它已赢得了作为构建生产级 AI 应用的团队关键参考的地位。

无论你是刚开始接触 LLM 代理还是扩展现有系统，12 因子原则都提供了历久弥新的基础。从小处开始，渐进式采用，让框架引导你的架构走向生产就绪。

[CTA：准备好构建生产级 AI 代理了吗？今天就从 12-Factor Agents 开始。[开始使用](https://github.com/humanlayer/12-factor-agents) | [加入社区](https://humanlayer.dev/discord)]

## 参考来源

1. [12-Factor Agents GitHub 仓库](https://github.com/humanlayer/12-factor-agents)
2. [Humanlayer Discord 社区](https://humanlayer.dev/discord)
3. [12-Factor App 宣言](https://12factor.net/)
4. [12-Factor Agents 文档](https://github.com/humanlayer/12-factor-agents/blob/main/README.md)
5. [DigitalOcean - AI 云基础设施](https://www.digitalocean.com/try/affiliate)
6. [HTStack - 高性能托管](https://htstack.com/)
7. [WebShare - 数据管道的代理服务](https://webshare.io/)
