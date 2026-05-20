---
title: 'OpenHands: 74K+ Stars — 能写代码能运行的 AI 软件工程师 (2026 安装教程)'
description: 'OpenHands 是一款 AI 驱动的软件开发平台，可作为软件工程智能体。兼容 VS Code、Docker、GitHub、GitLab、Claude 和 OpenAI。涵盖 Docker 安装、模型配置、无头 CI/CD 模式和生产环境加固。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/OpenHands/OpenHands'
stars: 74200
maintainer: 'OpenHands'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['OpenHands', 'AI 编程智能体', 'Docker', 'SWE-bench', 'Claude', 'OpenAI', '自托管', '自动化']
aliases:
- /zh/posts/openhands/
- /zh/resources/llm-frameworks/openhands-architecture-ai-programmer-agent/
---

{{</* resource-info */>}}

## 简介

大多数 AI 编程工具只停留在代码补全阶段。你得到一个建议，复制粘贴进去，然后祈祷它能编译通过。OpenHands 采用完全不同的方法：它是一个完整的软件工程智能体，能够读取代码仓库、编辑文件、运行测试，并持续迭代直到任务完成。拥有超过 74,000 个 GitHub Star 和 SWE-bench Verified 72% 的得分，它是生产环境中部署最广泛的开源编程智能体。

本指南将带你完成 OpenHands 的本地安装、连接首选 LLM 提供商、与 GitHub 集成，以及在无头模式下运行 CI/CD 流水线。无论你是想要一个本地 AI 工程师处理日常任务，还是需要自主智能体批量解决问题，本教程都会提供真实的命令和配置。

## 什么是 OpenHands？

OpenHands（前身为 OpenDevin）是一个在 Docker 容器内运行的开源 AI 软件工程智能体。它采用控制器-沙盒架构：基于 Python 的控制器管理智能体循环（观察-思考-行动），而隔离的沙盒容器负责代码执行、文件操作和测试运行。

核心功能包括：
- **自主任务执行**：给它一个 GitHub Issue 或自然语言任务，它会端到端解决
- **沙盒代码执行**：所有代码在 Docker 容器内运行，与宿主机隔离
- **多智能体委派**：复杂任务会被拆分到多个专用子智能体
- **自带模型支持**：兼容 Claude、GPT、Gemini、通过 Ollama 或 vLLM 运行的本地模型，以及通过 LiteLLM 对接的 100+ 提供商
- **无头模式**：通过 API 程序化访问，支持 CI/CD 和批处理
- **Web UI + CLI**：同时提供浏览器界面和终端优先的工作流

OpenHands 的前身是 OpenDevin，于 2024 年初启动，随后更名并快速发展。截至 2026 年 5 月，项目已发布到 v1.7.0 版本，拥有超过 500 名贡献者，每周发布更新。MIT 许可证意味着你可以自由使用、修改和分发，没有任何商业限制。对于受监管的行业，企业自托管能力尤为关键——整个平台运行在公司内部基础设施中，数据不会离开你的网络。

## OpenHands 的工作原理

架构包含两个主要组件：

**控制器节点（Controller Node）**：一个 Python 服务器，管理智能体循环，通过 LiteLLM 处理 LLM 抽象，并协调沙盒生命周期。它接收任务，将其分解为步骤，调用 LLM 进行决策，并跟踪迭代状态。

**沙盒容器（Sandbox Container）**：每个任务都会生成一个 Docker 容器，所有代码执行都在其中进行。智能体在隔离环境中读取文件、运行 Shell 命令、执行测试和编写补丁。任务完成后，沙盒被销毁。

![OpenHands 架构图](https://raw.githubusercontent.com/All-Hands-AI/OpenHands/main/docs/static/img/system_architecture_overview.png)

智能体循环遵循以下模式：

```
1. 观察（OBSERVE）：读取任务描述、仓库状态、先前操作的结果
2. 思考（THINK）：LLM 生成计划（编辑哪个文件、运行什么命令）
3. 行动（ACT）：执行计划操作（read_file、write_file、run_cmd 等）
4. 观察（OBSERVE）：捕获结果（输出、错误、测试结果）
5. 重复（REPEAT）：持续迭代直到任务完成或达到最大迭代次数
```

每个任务通常消耗 30-50 次 LLM 调用。v1.5 版本新增的内存压缩器（memory condenser）会总结较早的上下文，保持上下文窗口聚焦，从而减少长任务的延迟和 Token 消耗。

## 安装与设置

### 前置条件

安装 OpenHands 之前，请确保你已具备：

- **Docker Desktop** 已安装并运行（需要 Docker socket 访问权限）
- **4GB+ 内存**（并发会话建议 8GB）
- **Python 3.12+**（通过 uv 安装 CLI 时需要）
- **LLM API 密钥**（Anthropic、OpenAI、Google 或本地模型端点）

### 方案一：通过 uv 安装 CLI（推荐）

使用 uv 安装是启动 OpenHands 最快的方式：

```bash
# 安装 uv（如果尚未安装）
curl -LsSf https://astral.sh/uv/install.sh | sh

# 安装 OpenHands
uv tool install openhands --python 3.12

# 启动 GUI 服务器
openhands serve
```

服务器在 `http://localhost:3000` 启动。打开浏览器，选择 LLM 提供商，输入 API 密钥，即可开始分配任务。

![OpenHands Web UI](https://raw.githubusercontent.com/All-Hands-AI/OpenHands/main/docs/static/img/screenshot.png)

后续升级：

```bash
uv tool upgrade openhands --python 3.12
```

### 方案二：直接通过 Docker 运行

如果你更倾向于不安装 Python 工具的 Docker 方式：

```bash
# 拉取最新镜像
docker pull ghcr.io/openhands/openhands:latest

# 运行并挂载 Docker socket（沙盒管理必需）
docker run -it --rm \
  -p 3000:3000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e SANDBOX_RUNTIME_CONTAINER_IMAGE=ghcr.io/openhands/openhands:latest \
  ghcr.io/openhands/openhands:latest
```

`--mount-cwd` 标志将当前工作目录挂载到沙盒中：

```bash
openhands serve --mount-cwd
```

如需 GPU 加速本地模型：

```bash
openhands serve --gpu
```

### 方案三：通过 pip 安装

```bash
pip install openhands-ai

# 启动 Web UI
openhands serve
```

### Windows 安装注意事项

在 Windows 上，所有命令需在 WSL2（Ubuntu）内运行：

```powershell
# 在 PowerShell 管理员权限下
wsl --install -d Ubuntu
wsl -d Ubuntu
```

然后在 WSL 内：

```bash
# 先安装 Docker Desktop for Windows，然后：
uv tool install openhands --python 3.12
openhands serve
```

## 配置与首个任务

### 设置 LLM 提供商

启动 OpenHands 后，在设置面板（齿轮图标）中配置你的模型：

1. **选择提供商**：Anthropic（Claude）、OpenAI（GPT）、Google（Gemini）或本地模型
2. **选择模型**：推荐使用 `anthropic/claude-sonnet-4-20250514` 以获得最佳效果
3. **输入 API 密钥**：粘贴你的提供商 API 密钥
4. **保存更改**

如需高级配置，开启高级设置，使用 LiteLLM 前缀格式设置自定义模型：

```
anthropic/claude-sonnet-4-5-20250929
openai/gpt-5-2025-08-07
gemini/gemini-3-pro-preview
deepseek/deepseek-chat
```

### 使用本地模型（Ollama）

需要离线部署的团队可按以下步骤操作：

```bash
# 启动 Ollama 并加载强大的编程模型
ollama run qwen3-coder:32b

# 在 OpenHands 设置中配置：
# 自定义模型：openai/qwen3-coder:32b
# 基础 URL：http://host.docker.internal:11434/v1
# API 密钥：ollama（任意值均可）
```

### 运行第一个任务

在 `localhost:3000` 打开 UI：

1. 在聊天框输入任务："为 app.py 中的 main 函数添加文档字符串"
2. 智能体会生成沙盒、读取文件、编写文档字符串并确认更改
3. 接受前审查差异

处理 GitHub Issue：

```
修复 issue #42 中描述的身份验证错误。
克隆仓库、复现错误、实现修复并运行测试套件。
```

## 与 VS Code、GitHub、Docker 和 CI/CD 集成

### 通过 ACP 集成 VS Code

OpenHands v1.5+ 包含用于 IDE 集成的 Agent Control Plane：

```bash
# 安装 OpenHands VS Code 扩展
# 在 VS Code 扩展市场中搜索 "OpenHands"

# 配置扩展连接本地 OpenHands 服务器
# 设置 > OpenHands > 服务器 URL：http://localhost:3000
```

ACP 协议允许 VS Code 直接向 OpenHands 发送任务，并以差异补丁形式接收结构化编辑。

### GitHub 集成

将 OpenHands 连接到你的 GitHub 仓库以实现自动化 Issue 解决：

```bash
# 设置细粒度的 GitHub PAT（个人访问令牌）
export GITHUB_TOKEN=ghp_your_token_here

# 使用 GitHub 凭证启动 OpenHands
docker run -it --rm \
  -p 3000:3000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GITHUB_TOKEN=$GITHUB_TOKEN \
  ghcr.io/openhands/openhands:latest
```

在 UI 中粘贴 GitHub Issue URL，OpenHands 将自动执行以下步骤：
1. 克隆仓库
2. 阅读 Issue 描述
3. 复现 Bug
4. 实现修复
5. 运行测试验证
6. 生成差异供审查

### GitLab 集成

GitLab 支持（v1.5 新增）配置方式类似：

```bash
export GITLAB_TOKEN=glpat-your-token
docker run -it --rm \
  -p 3000:3000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GITLAB_TOKEN=$GITLAB_TOKEN \
  ghcr.io/openhands/openhands:latest
```

### 生产环境 Docker Compose

持久化部署请使用 Docker Compose：

```yaml
version: "3.8"
services:
  openhands:
    image: ghcr.io/openhands/openhands:latest
    ports:
      - "3000:3000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./workspace:/workspace
    environment:
      - SANDBOX_RUNTIME_CONTAINER_IMAGE=ghcr.io/openhands/openhands:latest
      - LLM_API_KEY=${LLM_API_KEY}
      - LLM_MODEL=anthropic/claude-sonnet-4-20250514
      - SANDBOX_NETWORK_DISABLED=true
      - LOG_LEVEL=info
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
```

部署：

```bash
docker-compose up -d
```

部署完成后，你可以通过 `docker-compose logs -f openhands` 查看实时日志。建议在生产环境中配合反向代理（如 Nginx 或 Traefik）使用，并启用 HTTPS 以加密通信。对于高可用性部署，可以考虑在多个节点上运行 OpenHands，并使用共享存储卷来保持会话状态的一致性。

### CI/CD 流水线无头模式

无头模式在无交互 UI 的情况下运行 OpenHands，适用于自动化场景：

```bash
# 以无头模式运行任务
openhands --headless -t "为认证模块编写单元测试"

# 从文件加载任务
openhands --headless -f task.txt

# JSON 输出供流水线解析
openhands --headless --json -t "修复 routes.py 中的 API 端点" > output.jsonl
```

GitHub Actions 工作流示例：

```yaml
name: OpenHands 自动修复
on:
  issues:
    types: [labeled]
jobs:
  fix:
    if: github.event.label.name == 'auto-fix'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: 运行 OpenHands
        run: |
          docker run --rm \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v $(pwd):/workspace \
            -e LLM_API_KEY=${{ secrets.ANTHROPIC_API_KEY }} \
            ghcr.io/openhands/openhands:latest \
            openhands --headless --json \
            -f .openhands/task.txt > results.jsonl
```

### MCP 服务器集成

OpenHands 支持 Model Context Protocol (MCP) 服务器以扩展功能：

```json
{
  "mcpServers": {
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/workspace"]
    }
  }
}
```

## 基准测试 / 实际应用场景

### SWE-bench Verified 性能表现

SWE-bench Verified 在 500 个真实 GitHub Issue 上测试智能体。得分越高表示智能体能够自主解决更多生产环境 Bug。

| 智能体 + 模型 | SWE-bench Verified | 备注 |
|---|---|---|
| OpenHands + Claude Opus 4.6 | ~72% | 开源框架最佳成绩 |
| OpenHands + Claude Sonnet 4.6 | ~67% | 推荐的成本/质量平衡 |
| OpenHands + GPT-5 | ~55% | 适合已使用 OpenAI 的团队 |
| OpenHands + Qwen3-Coder-32B (本地) | ~32% | 日常任务可接受 |
| OpenHands + Devstral 24B | ~47% | 最佳开源权重模型 |
| Claude Code + Claude Opus 4.6 | ~78% | 最高首次通过成功率 |
| Aider + Claude Opus 4.6 | ~62% | 强大的 CLI 替代方案 |

### 每次成功修复的成本

典型 SWE-bench 任务消耗约 55K Token：

| 模型 | 每次尝试成本 | 成功率 | 每次成功成本 |
|---|---|---|---|
| Claude Opus 4.7 | ~$1.50 | 87.6% | ~$1.71 |
| GPT-5.3-Codex | ~$0.90 | 85.0% | ~$1.06 |
| Claude Sonnet 4.6 | ~$0.40 | 67% | ~$0.60 |
| Qwen3.6 Plus (托管) | ~$0.20 | 78.8% | ~$0.25 |

### 实际部署指标

基于社区报告的生产环境部署数据：

- **Issue 解决率**：30-40% 的标记 Bug 在首次尝试时自主解决
- **代码审查辅助**：200 行以内 PR 的审查时间减少 60%
- **测试生成**：新模块通过 "为 X 编写测试" 提示达到 80%+ 覆盖率
- **文档生成**：文档字符串和 README 生成任务准确率达 90%+

![OpenHands Star History](https://api.star-history.com/svg?repos=OpenHands/OpenHands&type=Date)

### 使用 OpenHands 的企业

AMD、Apple、Google 和 Netflix 均已内部部署 OpenHands 用于自动化维护任务。最常见的用例包括跨多个仓库的依赖升级、漏洞修复扫描和 PR 审查自动化。

## 高级用法 / 生产环境加固

### 安全清单

运行自主代码执行智能体需要谨慎的安全配置：

**1. 沙盒网络隔离**

```yaml
environment:
  - SANDBOX_NETWORK_DISABLED=true
```

这会阻止沙盒容器发出出站请求。仅在需要安装依赖包的任务中有选择地启用。

**2. Docker Socket 安全**

挂载 Docker socket 实际上等于 root 访问权限。可通过以下方式缓解：

```bash
docker run --security-opt no-new-privileges \
  --cap-drop ALL \
  --cap-add SYS_ADMIN \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/openhands/openhands:latest
```

**3. 细粒度的 GitHub PAT**

切勿使用组织范围的令牌。将 PAT 限定到特定仓库：

```bash
# 在 GitHub > 设置 > 开发者设置 中创建细粒度 PAT
# 仅选择：内容（读/写）、Issue（读）、拉取请求（写）
```

**4. 密钥管理**

将密钥挂载为只读卷，而非环境变量：

```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
  - /opt/secrets:/secrets:ro
environment:
  - LLM_API_KEY_FILE=/secrets/anthropic_key
```

### 多智能体委派

大型功能开发可启用多智能体模式：

```bash
# 在 config.toml 或通过环境变量配置
[agent]
enable_multi_agent = true
max_subagents = 3
```

父智能体将 "构建带认证的 REST API" 分解为：
- 子智能体 1：实现 API 端点
- 子智能体 2：编写认证中间件
- 子智能体 3：创建数据库模型

### 内存压缩器调优

长任务可调整内存压缩器设置：

```toml
[llm]
enable_condenser = true
condenser_max_history = 240  # 240 个事件后总结（默认：240）
```

### 监控与日志

启用结构化 JSON 日志以实现可观测性：

```bash
openhands --headless --json -t "你的任务" 2>&1 | tee openhands.log
```

解析日志获取指标：

```bash
# 统计 LLM 调用次数
jq 'select(.type == "llm")' openhands.log | wc -l

# 查找错误
jq 'select(.type == "error")' openhands.log

# 计算任务耗时
jq 'select(.type == "finish") | .timestamp' openhands.log
```

### Kubernetes 扩展

团队部署可使用社区维护的 Helm Chart：

```bash
# 添加 OpenHands Helm 仓库
helm repo add openhands https://charts.openhands.dev
helm repo update

# 使用配置值安装
helm install openhands openhands/openhands \
  --set llm.apiKey=$LLM_API_KEY \
  --set llm.model=anthropic/claude-sonnet-4-20250514 \
  --set sandbox.networkDisabled=true \
  --set replicas=2
```

## 与替代方案对比

| 功能 | OpenHands | Claude Code | Aider | Codex CLI |
|---|---|---|---|---|
| **许可证** | MIT (开源) | 专有 (闭源) | Apache-2.0 (开源) | 专有 (闭源) |
| **GitHub Stars** | 74,200 | 不适用 | 39,000 | 不适用 |
| **界面** | Web UI + CLI | 仅 CLI | 仅 CLI | 仅 CLI |
| **沙盒隔离** | Docker 容器 | 宿主机文件系统 | 宿主机文件系统 | 宿主机文件系统 |
| **模型支持** | 100+ 通过 LiteLLM | 仅 Claude | 100+ 通过 API | 仅 OpenAI |
| **SWE-bench Verified** | ~72% (Claude) | ~78% (Claude) | ~62% (Claude) | ~55% (GPT) |
| **首次通过成功率** | ~65% | ~78% | ~71% | ~60% |
| **多智能体** | 是 (原生) | 是 (子智能体) | 否 | 否 |
| **自托管** | 是 (默认) | 否 | 是 | 否 |
| **设置时间** | 10-15 分钟 | 2 分钟 | 5-10 分钟 | 2 分钟 |
| **成本** | 免费 + API | $17-200/月 | 免费 + API | $20/月 + API |
| **CI/CD 集成** | 无头 + JSON | 有限 | 可脚本化 | 有限 |
| **IDE 集成** | VS Code (ACP) | 无 | 无 | VS Code (官方) |

### 如何选择

- **OpenHands**：需要自托管的自主智能体，带沙盒执行和多智能体支持。希望完全控制基础设施和模型选择。
- **Claude Code**：追求最高首次通过成功率，已使用 Claude，不需要自托管。偏好简单 CLI 而非 Docker 复杂性。
- **Aider**：习惯终端操作，需要 git 原生操作和自动提交，想要轻量级工具无容器开销。
- **Codex CLI**：深度集成 OpenAI 生态，需要官方 VS Code 支持，偏好托管服务。

## 局限性 / 客观评估

OpenHands 并非适用于所有场景。以下情况不适合使用：

**1. 需要视觉反馈的前端/UI 任务**：智能体无法"看到"渲染效果。"居中这个按钮"或"修复 CSS 渐变"等任务通常需要多次迭代，因为智能体缺乏视觉验证。

**2. 快速原型开发**：Docker 沙盒启动每次任务增加 10-30 秒延迟。对于快速一次性编辑，Aider 或 Cursor 更快。

**3. 无法运行 Docker 的小型机器**：如果你无法运行 Docker Desktop（企业锁定笔记本、ARM Chromebook），OpenHands 无法工作。Docker socket 挂载是硬性要求。

**4. 模糊需求**："改进代码库"或"重构架构"等模糊任务会让智能体陷入循环。它需要具体、可测试的指令。

**5. 复杂任务的 Token 成本**：每个任务消耗 30-50 次 LLM 调用。按 Claude Sonnet 每次调用约 $0.01 计算，即每个任务 $0.30-0.50。大批量处理时成本会快速累积。

**6. 学习曲线**：多智能体系统、事件流和配置选项虽然强大，但相比 Devin 两分钟注册流程要复杂得多。预计需要 1-2 小时的设置和实验才能实现高效使用。

## 常见问题

### 运行 OpenHands 需要什么硬件？

最低要求：现代 CPU、4GB 内存和 Docker Desktop。本地模型需要至少 24GB VRAM 的 GPU（RTX 4090 或更高）才能以可接受速度运行 Qwen3-Coder-32B。云 API 模型完全不需要 GPU。

### OpenHands 可以完全离线运行吗？

可以，通过 Ollama、vLLM 或 LM Studio 使用本地模型。将基础 URL 设置为本地端点（如 `http://localhost:11434/v1`），API 密钥可使用任意值。复杂任务性能会比前沿 API 低 20-30%，但日常 Bug 修复和重构没有问题。

### OpenHands 与 Devin 相比如何？

Devin（$20-500/月）更容易设置（2 分钟注册），但锁定在 Cognition 的模型和基础设施中。OpenHands 需要 10-15 分钟设置，但提供完整的模型选择、自托管和无供应商锁定。SWE-bench Verified 得分：OpenHands ~72% 对比 Devin ~50%。

### 我的代码在 OpenHands 中安全吗？

代码在任务完成后会被销毁的 Docker 沙盒容器中运行。如果设置了 `SANDBOX_NETWORK_DISABLED=true`，沙盒没有网络访问权限。但挂载 Docker socket 赋予控制器显著的主机访问权限，因此应在专用机器或 VM 上运行 OpenHands，而非生产笔记本。

### OpenHands 可以与现有 CI/CD 流水线集成吗？

可以，通过无头模式。`--headless --json` 标志生成结构化 JSONL 输出，任何 CI 系统都可以解析。典型的 GitHub Actions 工作流会克隆仓库，对已标记 Issue 运行 OpenHands，并从生成的差异创建 PR。

### 哪些模型与 OpenHands 配合最好？

Claude Sonnet 4.6 在大多数任务中提供最佳的成本与质量平衡。Claude Opus 4.6 准确率最高但 Token 成本高 3-4 倍。GPT-5 对已在 OpenAI 平台上的团队效果不错。本地部署最佳选择是 Qwen3-Coder-32B 或 Devstral 24B。

### OpenHands 陷入循环时如何调试？

检查 UI 中的事件日志，寻找重复失败的行动。常见修复方法：（1）提供更具体的指令，（2）切换到更强的模型，（3）将任务拆分为更小的子任务，（4）在设置中增加 `max_iterations` 限制。

## 结论

OpenHands 是 2026 年最出色的开源 AI 软件工程智能体。其 74,000+ GitHub Stars、72% 的 SWE-bench 得分和 Docker 沙盒架构使其成为需要自主编码能力且无供应商锁定的团队的正确选择。

设置过程约 10-15 分钟：通过 uv 或 Docker 安装，配置 LLM 提供商，开始分配任务。生产使用时，启用沙盒网络隔离，使用细粒度 GitHub PAT，并部署无头模式用于 CI/CD 集成。

**后续步骤：**
1. 克隆仓库：`git clone https://github.com/OpenHands/OpenHands.git`
2. 安装：`uv tool install openhands --python 3.12`
3. 启动：`openhands serve` 并在 `localhost:3000` 连接
4. 加入 Slack 社区获取支持和功能更新



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [OpenHands GitHub 仓库](https://github.com/OpenHands/OpenHands) — 源代码和发布版本
- [官方文档](https://docs.openhands.dev/) — 完整安装和 API 文档
- [OpenHands LLM 配置指南](https://docs.openhands.dev/openhands/usage/llms/llms) — 模型推荐和提供商设置
- [无头模式文档](https://docs.openhands.dev/openhands/usage/cli/headless) — CI/CD 和脚本参考
- [SWE-bench 排行榜](https://www.swebench.com/) — 官方基准测试结果
- [LiteLLM 提供商文档](https://docs.litellm.ai/docs/providers) — 支持的模型提供商
- [OpenHands 社区论坛](https://github.com/OpenHands/OpenHands/discussions) — 问答和故障排除
- [Agent Control Plane 文档](https://docs.openhands.dev/openhands/usage/key-features) — VS Code 集成和多智能体设置

---

*本指南独立维护并定期更新。最后验证时间：2026年5月。*
