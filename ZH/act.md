---
title: 'act: 70,410 GitHub Stars — 本地运行 GitHub Actions，2026 生产级 CI/CD 指南'
description: 'act (nektos/act) 是一个使用 Docker 容器在本地运行 GitHub Actions 工作流的 CLI 工具。兼容 Docker、GitHub Actions、Go 和 VS Code。涵盖安装、配置、密钥管理、runner 镜像和生产环境加固。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/nektos/act'
stars: 70410
maintainer: 'nektos'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['act', 'github-actions', 'ci-cd', 'docker', '本地开发', 'devops', '测试', '自动化']
aliases:
- /zh/posts/act/
---

{{</* resource-info */>}}

![act logo](https://raw.githubusercontent.com/nektos/act/master/img/act-logo.png)

## 引言

每个编写过 GitHub Actions 工作流的开发者都经历过这种痛苦：你修改了 `.github/workflows/ci.yml`，提交、推送，等待 3-5 分钟让 runner 执行，结果在第 4 步因为缺少环境变量或 shell 命令的拼写错误而失败。反馈循环缓慢，消耗你的 GitHub Actions 分钟数，并用 "fix CI" 的提交信息污染你的提交历史。到了 2026 年，随着 CI/CD 流水线管控着每一次部署，这种低效已无法接受。[act](https://github.com/nektos/act) 是由 Casey Lee 和 nektos 组织开发的 Go 语言命令行工具，通过在 Docker 容器中本地运行 GitHub Actions 工作流来解决这个问题——它匹配 GitHub 的环境变量、文件系统布局和 runner 行为。凭借 GitHub 上 70,410 颗星和繁荣的集成生态，act 已成为本地 CI/CD 开发的标准工具。

## 什么是 act？

act 是一个 CLI 工具，它从 `.github/workflows/` 读取 GitHub Actions 工作流文件，并使用 Docker 容器在本地执行，忠实复现 GitHub Actions 的运行时环境。本 tutorial 涵盖完整的 act 设置——从安装到生产加固——让你可以在推送到 GitHub 之前验证每个工作流更改。

## act 的工作原理

act 作为本地 GitHub Actions runner 模拟器运行。当你在仓库中运行 `act` 时，它会执行以下步骤：

1. **工作流发现**：扫描 `.github/workflows/` 中的 YAML 工作流文件
2. **事件解析**：根据事件类型（push、pull_request 等）确定触发哪些工作流
3. **依赖解析**：构建作业依赖关系的有向无环图（DAG）
4. **镜像准备**：拉取或构建指定 runner 的 Docker 镜像
5. **容器执行**：在与 GitHub 兼容的环境变量和文件系统挂载的 Docker 容器中运行每个步骤
6. **产物收集**：收集输出、产物和日志

![act 架构图](https://raw.githubusercontent.com/nektos/act/master/img/act-quickstart-2.gif)

该工具直接使用 Docker Engine API，这意味着任何与 Docker 兼容的容器运行时都可以作为后端。环境变量（`GITHUB_SHA`、`GITHUB_REF`、`GITHUB_REPOSITORY` 等）和文件系统结构（`/github/workspace`、`/github/event.json`、`/github/home`）的配置与 GitHub 在其托管 runner 上提供的内容一致。

### Runner 镜像大小

act 提供三种镜像层级，在保真度和磁盘空间之间取得平衡：

| 镜像大小 | 下载 | 磁盘空间 | 使用场景 |
|---|---|---|---|
| Micro | ~50 MB | <200 MB | 仅 Node.js，快速冒烟测试 |
| Medium | ~200 MB | ~500 MB | 包含必要工具，适合大多数工作流 |
| Large | ~5 GB | ~18-75 GB | 完整 GitHub runner 对等性，完整工具链 |

默认的 Medium 镜像（`catthehacker/ubuntu:act-latest`）包含 Python、Node.js、Go、Ruby、Java、.NET 和常用构建工具。Large 镜像（`catthehacker/ubuntu:full-*`）是实际 GitHub 托管 runner 的文件系统转储，提供最接近的对等性。

## 安装与配置

act 在任何安装了 Docker 的平台上都能在 60 秒内完成安装。选择你的方法：

### macOS (Homebrew)

```bash
# 通过 Homebrew 安装 act
brew install act

# 验证安装
act --version
# act version 0.2.88
```

### Linux (Bash 脚本)

```bash
# 一行命令安装（需要 bash 和 curl）
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# 备选方案：下载预构建二进制文件
wget https://github.com/nektos/act/releases/download/v0.2.88/act_Linux_x86_64.tar.gz
tar xzf act_Linux_x86_64.tar.gz
sudo mv act /usr/local/bin/
```

### Windows (Chocolatey / Scoop / WinGet)

```powershell
# Chocolatey
choco install act-cli

# Scoop
scoop install act

# WinGet
winget install nektos.act
```

### GitHub CLI 扩展

```bash
# 作为 gh CLI 扩展安装
gh extension install https://github.com/nektos/gh-act

# 通过 gh 运行
gh act
```

### 从源码构建 (Go 1.20+)

```bash
git clone https://github.com/nektos/act.git
cd act/
make build
sudo make install
```

### 安装后配置

首次运行时，act 会提示你选择默认镜像大小：

```bash
# 首次运行 — 选择默认 runner 镜像
act
? Please choose the default image you want to use with act:
  - Large size image: ~17GB download, ~75GB disk space, closest to GitHub runners
  - Medium size image: ~500MB, includes essential tools (RECOMMENDED)
  - Micro size image: <200MB, Node.js only
```

这会在 `~/.actrc` 中创建你的默认配置：

```bash
# ~/.actrc — 默认配置
cat ~/.actrc
-P ubuntu-latest=catthehacker/ubuntu:act-latest
```

### Docker 前置要求

act 需要 Docker Engine API。运行前请确认：

```bash
# 确认 Docker 正在运行
docker info

# 确认 Docker API 可访问
docker version
```

**注意：** Podman 不受官方支持（issue #303）。对于无根设置或替代方案，在 macOS 上使用 Docker Desktop、Rancher Desktop 或 Colima。

## 与 Docker、VS Code、GitHub Enterprise 和 Make 的集成

### Docker 集成

act 使用 Docker 作为执行引擎。每个工作流作业在隔离的容器中运行：

```bash
# 使用自定义 runner 镜像运行
act -P ubuntu-latest=node:20-slim

# 指定自定义 Docker 主机（远程引擎）
export DOCKER_HOST=tcp://remote-docker:2376
act

# 在 Apple Silicon 上使用容器架构标志
act --container-architecture linux/amd64
```

通过挂载主机 Docker socket 支持 Docker-in-Docker (DinD) 工作流：

```yaml
# .github/workflows/dind-test.yml
name: Docker Build Test
on: push
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Docker image
        run: docker build -t myapp:latest .
```

### VS Code 扩展 (GitHub Local Actions)

[GitHub Local Actions](https://marketplace.visualstudio.com/items?itemName=SanjulaGanepola.github-local-actions) VS Code 扩展为 act 提供了图形界面：

```bash
# 从 VS Code 市场安装扩展
# 按 Cmd+Shift+P → "Extensions: Install Extensions" → 搜索 "GitHub Local Actions"
```

安装扩展后：
- 从侧边栏打开 Act 面板
- 查看 `.github/workflows/` 中的所有工作流
- 点击任意工作流在本地运行
- 在集成终端中查看实时日志

![VS Code GitHub Local Actions 扩展](https://raw.githubusercontent.com/SanjulaGanepola/github-local-actions/main/resources/screencast.gif)

### GitHub Enterprise 支持

act 支持私有 GitHub Enterprise Server 实例：

```bash
# 针对 GitHub Enterprise Server 运行
act --github-instance github.company.com

# 带身份验证
act --github-instance github.company.com -s GITHUB_TOKEN=ghp_xxxxxxxx
```

### 用 act 替代 Make

许多团队使用 act 作为本地任务运行器，用 GitHub Actions 工作流替代 Makefile：

```yaml
# .github/workflows/tasks.yml
name: Local Tasks
on: workflow_dispatch
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run linter
        run: npm run lint
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: npm test
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: npm run build
```

```bash
# 在本地运行任务替代 make
act -j lint
act -j test
act -j build
```

## 基准测试 / 实际用例

### 反馈循环对比

| 场景 | 推送到 GitHub | 使用 act 本地运行 | 节省时间 |
|---|---|---|---|
| 修复工作流拼写错误 | 3-5 分钟 | 15-30 秒 | 90% |
| 调试失败测试 | 5-10 分钟（多次推送） | 每次迭代 30-60 秒 | 85% |
| 测试矩阵 (3 OS × 2 Node 版本) | 8-15 分钟 | 2-3 分钟 | 80% |
| 密钥/配置验证 | 3-5 分钟 | 20-40 秒 | 90% |
| 工作流语法检查 | 2-3 分钟 | 10-15 秒（dry-run） | 92% |

### 案例：减少 CI 分钟消耗

一个中型工程团队（25 名开发者）每天运行 200 次工作流推送：

- **使用 act 前**：每天约 600 次失败的 CI 运行，消耗约 3,000 GitHub Actions 分钟
- **使用 act 后**：开发者先在本地验证；失败的 CI 运行降至约 80 次/天
- **每月节省**：约 66,000 GitHub Actions 分钟 = 约 $400-1,300/月（取决于 runner 类型）

### 按镜像大小的启动时间

| 镜像 | 首次拉取 | 冷启动 | 热启动 |
|---|---|---|---|
| Micro (node:16-slim) | ~10 秒 | 5 秒 | 2 秒 |
| Medium (catthehacker/ubuntu:act-latest) | ~45 秒 | 15 秒 | 5 秒 |
| Large (catthehacker/ubuntu:full-latest) | ~8 分钟 | 45 秒 | 15 秒 |

## 高级用法 / 生产环境加固

### 密钥管理

切勿在测试中提交密钥。act 提供多种安全模式：

```bash
# 选项 1：交互式提示（推荐手动运行）
act -s MY_SECRET

# 选项 2：环境变量查找
export MY_SECRET=supersecurevalue
act -s MY_SECRET

# 选项 3：密钥文件 (.secrets，格式与 .env 相同)
cat > .secrets << 'EOF'
MY_SECRET=supersecurevalue
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
EOF
act --secret-file .secrets

# 选项 4：对于 GITHUB_TOKEN（建议使用只读 PAT）
act -s GITHUB_TOKEN=ghp_xxxxxxxxxxxx
```

立即将 `.secrets` 添加到 `.gitignore`：

```bash
echo ".secrets" >> .gitignore
echo "*.secrets" >> .gitignore
```

### 仓库变量（vars 上下文）

支持 GitHub 的 `vars` 上下文用于仓库级配置：

```bash
# 设置变量
act --var DEPLOY_ENV=staging --var API_VERSION=v2

# 或使用变量文件
cat > .variables << 'EOF'
DEPLOY_ENV=staging
API_VERSION=v2
EOF
act --var-file .variables
```

### 使用载荷文件模拟事件

通过提供 JSON 载荷文件测试依赖事件数据的工作流：

```bash
# 模拟 pull_request 事件
cat > pull-request.json << 'EOF'
{
  "pull_request": {
    "head": { "ref": "feature/new-login" },
    "base": { "ref": "main" },
    "number": 42
  }
}
EOF
act pull_request -e pull-request.json
```

```bash
# 模拟带标签的 push
cat > tag-push.json << 'EOF'
{ "ref": "refs/tags/v1.2.3" }
EOF
act push -e tag-push.json
```

```bash
# 模拟带输入的 workflow_dispatch
cat > workflow-inputs.json << 'EOF'
{
  "inputs": {
    "environment": "production",
    "version": "2.0.0"
  }
}
EOF
act workflow_dispatch -e workflow-inputs.json
```

### Dry-Run 模式

在不实际运行的情况下验证工作流语法并查看执行计划：

```bash
# 列出所有将要运行的作业
act -l

# Dry run（不实际执行）
act -n

# 带详细输出的 dry run
act -n -v
```

### 配置文件 (.actrc)

通过 `.actrc` 进行项目特定配置：

```bash
# 项目根目录的 .actrc
cat > .actrc << 'EOF'
--container-architecture linux/amd64
--action-offline-mode
-P ubuntu-latest=catthehacker/ubuntu:act-latest
--env-file .env
--secret-file .secrets
EOF
```

配置优先级（从高到低）：
1. CLI 参数
2. `./.actrc`（项目根目录）
3. `~/.actrc`（主目录）
4. `$XDG_CONFIG_HOME/act/actrc`

### 跳过本地运行的作业/步骤

标记不应在本地运行的步骤：

```yaml
# 在你的工作流文件中
jobs:
  deploy:
    if: ${{ !github.event.act }}  # 本地运行时跳过部署作业
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

  notify:
    runs-on: ubuntu-latest
    steps:
      - name: 本地运行时跳过 Slack 通知
        if: ${{ !env.ACT }}
        run: |
          curl -X POST -H 'Content-type: application/json' \
            --data '{"text":"Deployment complete"}' ${{ secrets.SLACK_WEBHOOK }}
```

通过事件传递 act 标志：

```bash
cat > event.json << 'EOF'
{ "act": true }
EOF
act -e event.json
```

### 产物收集

在本地收集工作流产物：

```bash
# 指定产物服务器路径
act --artifact-server-path /tmp/artifacts

# 产物将保存到 /tmp/artifacts/<workflow>/<artifact-name>/
ls -la /tmp/artifacts/
```

### 离线模式

对于隔离或低带宽环境：

```bash
# 预拉取镜像
act --action-offline-mode

# 这将重用本地缓存的操作仓库和 Docker 镜像
# 无需从 GitHub 或 Docker Hub 获取
```

## 与替代方案对比

| 功能 | act | GitHub Actions Runner | Drone CI | Jenkins |
|---|---|---|---|---|
| **本地执行** | 原生（Docker） | 可行（配置复杂） | 基于 Docker | 需要 Java + 插件 |
| **GitHub 对等性** | 高（相同 YAML 语法） | 完整（官方 runner） | 中（不同语法） | 低（依赖插件） |
| **配置时间** | <1 分钟 | 10-30 分钟 | 5-10 分钟 | 15-30 分钟 |
| **资源使用** | 低（Docker 容器） | 中-高（VM/服务） | 中（Docker） | 高（JVM + 插件） |
| **密钥管理** | 文件、环境变量、交互式 | 仅 GitHub UI | Drone UI / CLI | Credentials 插件 |
| **自托管选项** | 不适用（仅本地） | 官方自托管 runner | 完整服务器部署 | 完整服务器部署 |
| **价格** | 免费（开源） | 免费（公开仓库） / $0.008/分钟（私有） | 免费（开源） / 云版 $15/月起 | 免费（开源） |
| **社区规模** | 70,410 GitHub stars | GitHub 原生 | 27,000+ stars | 成熟的企业级 |
| **学习曲线** | 低（使用 GitHub 语法） | 中 | 中 | 高 |
| **IDE 集成** | VS Code 扩展 | 有限 | 有限 | 丰富 |

**选择 act 的时机：**
- **act**：本地开发、工作流调试、提交前验证、学习 GitHub Actions
- **GitHub Actions Runner**：在 GitHub 基础设施或自托管集群上运行生产 CI/CD
- **Drone CI**：团队需要容器原生流水线且偏好不同语法
- **Jenkins**：企业级 CI/CD，需要丰富的插件生态和遗留集成

## 局限性 / 客观评估

act 是开发和调试工具，不是生产 CI/CD 的替代品。采用前请了解以下限制：

1. **仅支持 Linux runner**：Windows (`windows-latest`) 和 macOS (`macos-latest`) runner 不支持容器化执行。`-self-hosted` 标志可以直接在 macOS/Windows 主机上运行作业，但这会绕过容器隔离，且无法匹配 GitHub 的 runner 环境。

2. **默认镜像不完整**：Medium runner 镜像未包含 GitHub 托管 runner 上预装的所有工具。`swift`、`gcloud` 或特定 Android SDK 组件等软件可能需要在 workflow 中手动安装。

3. **Docker-in-Docker 限制**：通过 socket 挂载可以在 act 容器内运行 Docker 命令，但嵌套容器场景和 Docker 内的 Kubernetes 需要额外配置。

4. **服务支持不完整**：作业定义中的 Docker Compose `services` 支持有限（issue #173）。数据库和缓存可能需要外部编排。

5. **网络和缓存差异**：GitHub Actions 缓存（`actions/cache`）和服务容器在本地表现不同。缓存命中/未命中和网络延迟不会完全匹配生产环境。

6. **不支持 GitHub 托管的操作市场**：某些复合操作或依赖 GitHub 内部 API 的操作可能在本地运行失败。

7. **Large 镜像磁盘需求**：Large 镜像约 18-75 GB，对于存储空间有限的笔记本电脑不实用。大多数团队应在日常开发中使用 Medium 镜像。

## 常见问题

### Q1: act 需要联网吗？

首次运行需要——act 需要从 GitHub 拉取 Docker 镜像和克隆操作仓库。之后，你可以使用 `--action-offline-mode` 配合缓存的镜像和操作工作。离线前使用 `docker pull` 预拉取镜像。

### Q2: 如何只运行工作流中的特定作业？

使用 `-j` 标志后跟工作流 YAML 中定义的作业 ID：

```bash
# 只运行 "test" 作业
act -j test

# 从特定工作流文件运行作业
act -j lint -W .github/workflows/checks.yml
```

### Q3: act 可以与私有 GitHub 仓库或 GitHub Enterprise 一起使用吗？

可以。对于私有仓库，通过 `-s GITHUB_TOKEN` 提供个人访问令牌。对于 GitHub Enterprise Server，使用 `--github-instance`：

```bash
act --github-instance github.mycompany.com -s GITHUB_TOKEN=ghp_xxx
```

### Q4: 为什么我的工作流失败并报 "MODULE_NOT_FOUND"？

使用本地操作（例如 `uses: ./`）时，如果未正确检出仓库，会出现此错误。确保你的仓库名称与检出路径匹配。如果你的仓库名为 `my-project`，检出步骤应包含 `path: "my-project"`。

### Q5: 如何调试失败的步骤？

使用详细日志（`-v`）运行 act，并保留容器以供检查：

```bash
# 详细输出
act -v

# 对特定作业使用详细输出
act -j test -v

# 容器名称会打印在日志中；失败后检查它
docker exec -it <container-name> /bin/bash
```

### Q6: act 适合运行生产 CI/CD 流水线吗？

不适合。act 专为本地开发和调试设计。对于生产 CI/CD，请使用 GitHub 托管 runner、自托管 runner，或专门的 CI/CD 平台如 GitHub Actions、Drone 或 Jenkins。

### Q7: 如何将 act 更新到最新版本？

使用你安装时所用的相同包管理器：

```bash
# Homebrew
brew upgrade act

# Chocolatey
choco upgrade act-cli

# Scoop
scoop update act

# Bash 脚本（重新运行安装器）
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
```

## 结论

凭借 70,410 颗星和与 GitHub Actions 更新保持同步的发布节奏，act 已在每位开发者的工具箱中占有一席之地。在推送前本地验证工作流的能力消除了提交-推送-等待-失败-修复的昂贵反馈循环。用不到一分钟安装它，配置你的 `.actrc`，并开始将 CI/CD 定义视为可以在你的机器上测试的一等代码。

**行动项：**
1. 使用你偏好的包管理器安装 act
2. 在有工作流的仓库中运行 `act -l` 查看可用作业
3. 使用默认 runner 配置创建 `.actrc` 文件
4. 设置 `.secrets` 文件（并添加到 `.gitignore`）用于本地密钥管理
5. 与团队分享本指南，标准化本地 CI/CD 开发

加入 [dibi8 开发者 Telegram 社区](https://t.me/dibi8)，讨论 act 配置、分享工作流优化，并从在生产环境中使用 act 的工程师那里获得帮助。



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [act GitHub 仓库](https://github.com/nektos/act) — 官方源代码，70,410 stars
- [act 用户指南](https://nektosact.com/) — 完整文档
- [act 安装指南](https://nektosact.com/installation/index.html) — 平台特定安装方法
- [act Runner 参考](https://nektosact.com/usage/runners.html) — Docker 镜像选项和大小
- [act 使用指南](https://nektosact.com/usage/index.html) — 事件、密钥、配置
- [VS Code: GitHub Local Actions 扩展](https://marketplace.visualstudio.com/items?itemName=SanjulaGanepola.github-local-actions)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [catthehacker/docker_images](https://github.com/catthehacker/docker_images) — act 使用的社区 runner 镜像
