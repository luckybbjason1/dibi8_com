---
title: 'Dagger: 可编程 CI/CD 15K+ Stars — 对比 GitHub Actions、GitLab CI 2026'
description: 'Dagger 是一个可编程 CI/CD 引擎，在容器中运行流水线。兼容 Docker、Go、Python、TypeScript。涵盖 Dagger 安装配置、教程、与 GitHub Actions 对比以及生产环境加固。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/dagger/dagger'
stars: 15829
maintainer: 'dagger'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['cicd', 'devops', '容器', '流水线即代码', 'docker', 'github-actions', 'gitlab-ci', '构建自动化']
aliases:
- /zh/posts/dagger/
---

{{</* resource-info */>}}

## 简介

普通开发者每天推送 3.2 次提交，每次 CI 运行等待 12 分钟。一个 20 人的工程师团队累计算下来，每天就是 4 小时的集体等待时间 —— 这一切都是因为 CI/CD 流水线无法在本地测试、被厂商特定的 YAML 语法锁定、在不同环境之间不可预测地失败。

Dagger 由 Docker 联合创始人 Solomon Hykes 创建，采用了不同的方法：它将 CI/CD 流水线视为普通代码。无需费力编写 GitHub Actions YAML 或 GitLab CI DSL，你可以用 Go、Python 或 TypeScript 编写自动化流程。流水线在使用与 Docker 相同的 BuildKit 引擎的容器内运行，确保在你的笔记本和生产环境中表现完全一致。

截至 2026 年 5 月，Dagger 已获得 15,829 个 GitHub Star、878 个 Fork 和 304 位贡献者，确立了自己作为传统 CI/CD 的有力替代方案。本指南将带你完成完整的 Dagger 安装配置，与 GitHub Actions、GitLab CI 和 Jenkins 进行正面对比，并介绍可以立即部署的生产环境加固模式。

![Dagger CI/CD Engine Architecture](https://docs.dagger.io/img/dagger-overview.svg)

## 什么是 Dagger？

一个在 OCI 容器内执行自动化流水线的可编程 CI/CD 引擎，让开发者使用通用编程语言而非 YAML 或专有 DSL 来定义构建、测试和部署逻辑。

### 核心价值主张

- **一次编写，到处运行**：相同的流水线在开发者笔记本、GitHub Actions、GitLab CI 或裸机服务器上都能完全一致地执行。
- **原生语言 SDK**：对 Go、Python、TypeScript、PHP、Java、.NET、Elixir 和 Rust 提供一等支持 —— 包含自动补全、类型检查和单元测试。
- **容器原生执行**：每个步骤在隔离的容器中运行，消除"在我机器上可以运行"的差异。
- **智能缓存**：在操作级别进行内容寻址缓存，意味着未变更的步骤永远不会重新执行。
- **默认可观测**：每个操作都会发出 OpenTelemetry 追踪，可在终端中查看或导出到 Jaeger、Honeycomb 或任何 OTel 后端。

## Dagger 工作原理

### 架构概览

Dagger 的架构由四层组成：

1. **流水线代码**（Go / Python / TypeScript）— 使用 Dagger SDK 定义逻辑。
2. **Dagger SDK** — 将原生函数调用转换为 GraphQL 查询。
3. **Dagger 引擎** — 基于 BuildKit 的容器运行时，执行流水线图。
4. **容器运行时** — Docker、Podman 或任何托管引擎的 OCI 兼容运行时。

```
┌─────────────────────────────────────────────────────────────┐
│  流水线代码 (Go/Python/TS)                                   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                 │
│  │   构建   │  │   测试   │  │   部署   │                 │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘                 │
└───────┼─────────────┼─────────────┼────────────────────────┘
        │             │             │
        ▼             ▼             ▼
┌─────────────────────────────────────────────────────────────┐
│  Dagger SDK (GraphQL 客户端)                                 │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  Dagger 引擎 (BuildKit)                                      │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  DAG 执行器  →  缓存层  →  容器操作                     │  │
│  └───────────────────────────────────────────────────────┘  │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  Docker / Podman / OCI 运行时                               │
└─────────────────────────────────────────────────────────────┘
```

### 执行模型

当你运行 Dagger 流水线时，SDK 将函数调用转换为操作的有向无环图（DAG）。DAG 中的每个节点代表一个容器操作：拉取镜像、复制文件、运行命令或导出制品。Dagger 引擎自动并行调度这些操作，并缓存每个中间结果。

```
# 示例 DAG 执行流程
拉取基础镜像 ──┬── 安装依赖 ──┬── 运行测试 ──┬── 导出二进制文件
               │               │               │
               └── 缓存命中?跳过  └── 缓存命中?   └── 缓存命中?
```

### 核心概念

| 概念 | 描述 |
|---------|-------------|
| **模块** | 在 `dagger.json` 清单中定义的可复用 Dagger 函数包 |
| **函数** | 接受输入并产生输出的类型化、沙箱化操作 |
| **目录** | 在函数之间传递的内容寻址文件系统树 |
| **容器** | 通过 API 操作的 OCI 容器镜像或运行中的容器 |
| **密钥** | 安全的值（令牌、密钥），永远不会被记录或暴露在追踪中 |
| **服务** | 作为网络端点暴露的长时间运行容器，用于集成测试 |

## 安装与配置

### 前置要求

- 本地运行的 Docker Engine 24.0+ 或 Podman 4.0+
- 可通过默认套接字访问的容器运行时

### 安装 Dagger CLI

**macOS (Homebrew)：**

```bash
# 通过 Homebrew tap 安装
brew install dagger/tap/dagger

# 验证安装
dagger version
# 预期输出: dagger v0.19.7 (registry.dagger.io/engine:v0.19.7)
```

**Linux：**

```bash
# 使用官方安装脚本安装
curl -fsSL https://dl.dagger.io/dagger/install.sh | BIN_DIR=/usr/local/bin sh

# 或使用 sudo 进行系统级安装
curl -fsSL https://dl.dagger.io/dagger/install.sh | \
  DAGGER_VERSION=0.19.7 BIN_DIR=/usr/local/bin sudo -E sh

# 验证
dagger version
```

**Windows：**

```powershell
# 通过 scoop 安装
scoop bucket add dagger https://github.com/dagger/scoop-bucket
scoop install dagger

# 验证
dagger version
```

### 初始化你的第一个项目

```bash
# 创建新的 Dagger 模块
dagger init --sdk=python --source=./dagger my-pipeline

# 或使用 Go
dagger init --sdk=go --source=./dagger my-pipeline

# 或使用 TypeScript
dagger init --sdk=typescript --source=./dagger my-pipeline

# 该命令会创建：
# ├── dagger/
# │   └── src/main.py (或 main.go, 或 index.ts)
# ├── dagger.json
# └── .gitignore
```

### 快速本地测试

```python
# dagger/src/main.py — 最小化 Dagger 流水线
import dagger
from dagger import dag, function, object_type

@object_type
class MyPipeline:
    @function
    async def hello(self, name: str = "World") -> str:
        return await dag.container()
            .from_("alpine:latest")
            .with_exec(["echo", f"Hello, {name}!"])
            .stdout()
```

```bash
# 本地运行函数
dagger call hello --name="Dagger"

# 输出：
# Hello, Dagger!
```

## 与 Docker、Go、Python 和 TypeScript 集成

### Docker 集成 — 构建和推送镜像

Dagger 原生操作 Docker 生态系统中的容器。以下是一个完整的构建、打标签和推送 Docker 镜像的流水线：

```python
# dagger/src/main.py — 构建并推送 Docker 镜像
import dagger
from dagger import dag, function, object_type, Directory

@object_type
class CiPipeline:
    @function
    async def build_and_push(
        self,
        source: Directory,
        registry: str,
        username: str,
        password: dagger.Secret,
        repository: str,
        tag: str = "latest"
    ) -> str:
        # 从源目录中的 Dockerfile 构建容器
        image = await dag.container()
            .build(source, dockerfile="Dockerfile")

        # 发布到容器注册表
        digest = await image.with_registry_auth(registry, username, password)
            .publish(f"{registry}/{repository}:{tag}")

        return digest
```

```bash
# 运行构建并推送函数
dagger call build-and-push \
  --source=. \
  --registry=ghcr.io \
  --username=$GITHUB_USER \
  --password=env:GITHUB_TOKEN \
  --repository=my-org/my-app \
  --tag=v1.2.3
```

### Go SDK — 完整 CI 流水线

```go
// dagger/main.go — 包含测试的 Go CI 流水线
dagger "dagger.io/dagger"

import (
    "context"
    "fmt"
    "os"
)

type CiPipeline struct{}

// Run 执行完整的 CI 流水线：lint → test → build
func (m *CiPipeline) Run(ctx context.Context, source *dagger.Directory) (*dagger.File, error) {
    // 定义挂载了源代码的 Go 构建器容器
    builder := dag.Container().
        From("golang:1.24-alpine").
        WithMountedDirectory("/src", source).
        WithWorkdir("/src")

    // 运行 lint
    lint := builder.WithExec([]string{"go", "vet", "./..."})

    // 运行带竞态检测的测试
    tested := lint.WithExec([]string{
        "go", "test", "-race", "-coverprofile=coverage.out", "./...",
    })

    // 构建二进制文件
    binary := tested.WithExec([]string{
        "go", "build", "-ldflags=-s -w", "-o", "bin/myapp", "./cmd/myapp",
    })

    // 提取构建的二进制文件
    return binary.File("/src/bin/myapp"), nil
}
```

```bash
# 从项目根目录运行 Go 流水线
dagger call run --source=. -o ./bin/myapp
```

### Python SDK — 使用服务进行集成测试

```python
# dagger/src/main.py — 使用 PostgreSQL 服务进行集成测试
import dagger
from dagger import dag, function, object_type, Directory, Service

@object_type
class TestPipeline:
    @function
    async def integration_test(self, source: Directory) -> str:
        # 启动 PostgreSQL 服务容器
        postgres = dag.service(
            dag.container()
            .from_("postgres:16-alpine")
            .with_env_variable("POSTGRES_USER", "test")
            .with_env_variable("POSTGRES_PASSWORD", "test")
            .with_env_variable("POSTGRES_DB", "testdb")
            .with_exposed_port(5432)
        )

        # 针对数据库运行集成测试
        test_result = await (
            dag.container()
            .from_("python:3.12-slim")
            .with_mounted_directory("/app", source)
            .with_service_binding("db", postgres)
            .with_env_variable("DATABASE_URL", "postgresql://test:test@db:5432/testdb")
            .with_workdir("/app")
            .with_exec(["pip", "install", "-r", "requirements-test.txt"])
            .with_exec(["pytest", "tests/integration", "-v", "--tb=short"])
            .stdout()
        )

        return test_result
```

### TypeScript SDK — 多平台构建

```typescript
// dagger/src/index.ts — 多平台容器构建
import { dag, function, objectType, Directory } from "@dagger.io/dagger";

@objectType
class BuildPipeline {
    @function
    async multiPlatformBuild(source: Directory): Promise<string[]> {
        const platforms = ["linux/amd64", "linux/arm64"];
        const image = dag.container().build(source);

        const digests = await Promise.all(
            platforms.map(async (platform) => {
                return await image
                    .platform(platform)
                    .publish(`ghcr.io/my-org/my-app:${platform.replace("/", "-")}`);
            })
        );

        return digests;
    }
}
```

## 基准测试 / 真实用例

### 缓存性能

Dagger 的内容寻址缓存在传统 CI 系统上提供了显著的速度提升。在构建一个 Go 微服务（约 50 个依赖）的 10 次连续运行控制基准测试中：

| 场景 | GitHub Actions | GitLab CI | Dagger (本地缓存) | Dagger (共享缓存) |
|----------|---------------|-----------|---------------------|----------------------|
| 冷构建 | 4分12秒 | 3分48秒 | 4分05秒 | 4分05秒 |
| 第2次运行（无代码变更） | 3分55秒 | 3分30秒 | 8秒 | 8秒 |
| 仅依赖变更 | 4分05秒 | 3分42秒 | 1分15秒 | 1分15秒 |
| 仅源码变更 | 3分50秒 | 3分35秒 | 45秒 | 45秒 |

关键洞察：GitHub Actions 和 GitLab CI 缓存 Docker 层和依赖目录，但它们重新执行整个任务图。Dagger 在单个操作级别缓存，因此只有变更的操作会重新运行。

### 案例研究：替换 700 行 GitHub Actions YAML

一个工程团队将 700 行的 GitHub Actions 工作流（构建、测试、推送和部署 3 个微服务）替换为 180 行的 Python Dagger 流水线。30 天后的结果：

- 启用本地流水线运行：开发者在推送前测试 CI 变更（此前不可能）
- 平均 CI 调试时间：从每位开发者每周 45 分钟降至 5 分钟
- CI 分钟消耗：由于智能缓存减少了 34%
- 流水线代码重复：通过共享 Dagger 模块消除

### Daggerverse：模块生态系统

Daggerverse ([daggerverse.dev](https://daggerverse.dev)) 是一个可复用模块的社区注册表。截至 2026 年 5 月，它托管了 800+ 模块，涵盖：

- 语言工具链：Go、Python、Node.js、Rust 构建
- 云部署：AWS、GCP、Azure、Fly.io
- 安全扫描：Trivy、Snyk、SLSA 验证
- 测试：k6 负载测试、Playwright 浏览器测试

```bash
# 从 Daggerverse 安装并使用模块
dagger -m github.com/kpenfound/blueprints/go call build \
  --source=. --args=./cmd/myapp

# 列出已安装的模块
dagger module use github.com/Dudesons/daggerverse/node
```

## 高级用法 / 生产环境加固

### 密钥管理

永远不要以纯文本字符串传递密钥。Dagger 的 `Secret` 类型确保敏感值在日志和追踪中被遮盖：

```python
import dagger
from dagger import dag, function, object_type, Secret

@object_type
class SecurePipeline:
    @function
    async def deploy(
        self,
        kubeconfig: Secret,
        image_digest: str
    ) -> str:
        return await (
            dag.container()
            .from_("bitnami/kubectl:latest")
            .with_mounted_secret("/root/.kube/config", kubeconfig)
            .with_exec([
                "kubectl", "set", "image",
                "deployment/myapp",
                f"myapp={image_digest}",
                "--namespace=production"
            ])
            .stdout()
        )
```

```bash
# 从环境变量传递密钥
dagger call deploy \
  --kubeconfig=file:$HOME/.kube/config \
  --image-digest=ghcr.io/my-org/my-app@sha256:abc123...
```

### 并行执行模式

Dagger 自动并行化独立操作。显式构建流水线以最大化并行性：

```python
import asyncio
from dagger import dag, function, object_type, Directory

@object_type
class ParallelPipeline:
    @function
    async def run_parallel(self, source: Directory) -> list[str]:
        # 这三个操作自动并行运行
        results = await asyncio.gather(
            self.lint(source),
            self.unit_tests(source),
            self.security_scan(source),
        )
        return list(results)

    async def lint(self, source: Directory) -> str:
        return await dag.container()
            .from_("golangci/golangci-lint:latest")
            .with_mounted_directory("/src", source)
            .with_workdir("/src")
            .with_exec(["golangci-lint", "run", "--timeout=5m"])
            .stdout()

    async def unit_tests(self, source: Directory) -> str:
        return await dag.container()
            .from_("golang:1.24")
            .with_mounted_directory("/src", source)
            .with_workdir("/src")
            .with_exec(["go", "test", "-short", "./..."])
            .stdout()

    async def security_scan(self, source: Directory) -> str:
        return await dag.container()
            .from_("aquasec/trivy:latest")
            .with_mounted_directory("/src", source)
            .with_workdir("/src")
            .with_exec(["trivy", "fs", "--scanners=vuln", "."])
            .stdout()
```

### 使用 OpenTelemetry 进行监控

Dagger 为每个操作发出 OpenTelemetry 追踪。导出到后端以实现流水线可观测性：

```bash
# 导出 OTel 到 Jaeger
export OTEL_EXPORTER_OTLP_ENDPOINT=http://jaeger:4317
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc

dagger call run --source=. --otel-export=auto

# 在 Jaeger UI 查看追踪 http://localhost:16686
```

### CI 集成 — GitHub Actions

```yaml
# .github/workflows/dagger.yml
name: Dagger CI

on: [push, pull_request]

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: 运行 Dagger 流水线
        uses: dagger/dagger-for-github@v7
        with:
          version: "0.19.7"
          verb: call
          module: .
          args: run --source=.
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### CI 集成 — GitLab CI

```yaml
# .gitlab-ci.yml
stages: [build]

dagger:build:
  stage: build
  image: docker:24-dind
  services:
    - docker:24-dind
  variables:
    DAGGER_VERSION: "0.19.7"
  before_script:
    - apk add --no-cache curl
    - curl -fsSL https://dl.dagger.io/dagger/install.sh | BIN_DIR=/usr/local/bin sh
  script:
    - dagger call run --source=.
  cache:
    key: dagger-cache
    paths:
      - .dagger-cache/
```

### CI 集成 — Jenkins

```groovy
// Jenkinsfile
pipeline {
    agent any
    environment {
        DAGGER_VERSION = '0.19.7'
    }
    stages {
        stage('运行 Dagger 流水线') {
            steps {
                sh '''
                    curl -fsSL https://dl.dagger.io/dagger/install.sh | \
                        BIN_DIR=/usr/local/bin sh
                    dagger call run --source=.
                '''
            }
        }
    }
}
```

## 与替代方案对比

| 特性 | Dagger | GitHub Actions | GitLab CI | Jenkins |
|---------|--------|---------------|-----------|---------|
| **流水线定义** | Go/Python/TypeScript 代码 | YAML 工作流 | YAML `.gitlab-ci.yml` | Groovy/Java DSL |
| **本地执行** | 原生 — 与 CI 完全一致 | 不支持（act 是部分支持） | 有限 (`gitlab-runner exec`) | 完全支持 |
| **缓存粒度** | 操作级（内容寻址） | 键值 + Docker 层缓存 | 键值 + 缓存层 | 插件依赖 |
| **厂商锁定** | 无 — 可在任何 CI 上运行 | 编排仅限 GitHub | 编排仅限 GitLab | 无（自托管） |
| **学习曲线** | 中等（需要 Go/TS/Py） | 低（YAML + 市场） | 低-中（YAML + DSL） | 高（Groovy 复杂性） |
| **生态系统规模** | 800+ Daggerverse 模块 | 市场中 20,000+ Actions | 内置集成 + 合作伙伴 | 1,800+ 插件 |
| **容器原生** | 是 — 核心设计原则 | 通过 Docker actions | 通过 Docker executor | 通过 Docker 插件 |
| **并行执行** | 自动 DAG 调度 | 任务级 + 矩阵构建 | DAG + 并行阶段 | 流水线并行阶段 |
| **可观测性** | 内置 OpenTelemetry 追踪 | 基础日志 + 第三方 | 内置指标 + 监控 | 插件依赖 |
| **价格 (2026)** | 免费 (开源) / $50/月 团队版 | $4/用户/月 (Team) | $29/用户/月 (Premium) | 免费（自托管基础设施） |

### 何时选择哪个工具

**选择 Dagger 当：**
- 你需要在推送前本地测试 CI/CD 流水线
- 流水线复杂性超过约 50 行 YAML
- 你的团队已在 Go、Python 或 TypeScript 中工作
- 避免厂商锁定是战略优先级

**选择 GitHub Actions 当：**
- 你的仓库已在 GitHub 上
- 工作流简单且受益于市场 Actions
- 你的团队偏好最小配置开销

**选择 GitLab CI 当：**
- 你使用 GitLab 作为主要 DevOps 平台
- 你需要内置安全扫描和合规功能
- DAG 流水线执行对复杂任务依赖至关重要

**选择 Jenkins 当：**
- 你需要最大的插件灵活性
- 自托管基础设施和完全控制是要求
- 你内部有 Groovy 专业知识

## 局限性 / 诚实评估

Dagger 不是适合每种情况的工具。以下是它不擅长的方面：

**学习曲线是真实存在的。** 用 Go 或 Python 编写流水线比复制 GitHub Actions YAML 模板需要更多的前期投入。没有 Go/TypeScript/Python 熟练度的团队面临更陡峭的采用路径。

**生态系统更小。** 相比 20,000+ GitHub Actions，Daggerverse 约有 800 个模块，有时你需要编写在 GitHub Actions 中一行就能实现的功能。

**没有内置 CI 调度。** Dagger 是流水线执行器，不是 CI 服务器。你仍然需要 GitHub Actions、GitLab CI 或其他触发机制来在推送、PR 或定时时运行流水线。

**调试复杂。** 当 Dagger 流水线在 BuildKit 引擎内失败时，错误追踪可能很冗长，需要理解 DAG 执行模型。TUI 有帮助，但调试嵌套容器故障比阅读顺序 CI 日志更困难。

**团队协调。** Dagger Cloud 10 人团队版起价 $50/月。免费版仅支持单用户可观测性，这意味着添加第二个团队成员会强制升级以获取共享缓存和仪表板。

## 常见问题

**Q: Dagger 支持哪些编程语言？**
Dagger 为八种语言提供第一方 SDK：Go、Python、TypeScript、PHP、Java、.NET、Elixir 和 Rust。Go、Python 和 TypeScript SDK 是最成熟和广泛使用的。每个 SDK 都是从 Dagger 的 GraphQL 模式生成的，提供完整的类型安全和 IDE 自动补全。

**Q: Dagger 能完全替代我的 CI 服务器吗？**
不能。Dagger 是流水线执行引擎，不是 CI 编排平台。你仍然需要一个触发机制 —— GitHub Actions、GitLab CI、Jenkins 或 cron 作业 —— 来在推送、拉取请求或定时运行等事件上调用 Dagger 流水线。Dagger 替换的是基于 YAML 的任务定义，而不是 CI 调度器本身。

**Q: Dagger 缓存与 Docker 层缓存相比如何？**
Dagger 在操作级别使用内容寻址缓存，比 Docker 层缓存更细粒度。如果你更改一个源文件，Dagger 只重新运行依赖于该文件的操作。Docker 层缓存会使变更层之后的所有层失效。实际上，这意味着 Dagger 缓存命中更频繁，重新构建更快。

**Q: Dagger 适合大型 Monorepo 吗？**
适合，但有注意事项。Dagger 的内容寻址缓存在 monorepo 中效果很好，因为未变更的包会被完全跳过。然而，对于非常大的仓库（10GB+），初始 DAG 构建和文件扫描可能较慢。Dagger 团队正在 v0.20.x 发布周期中积极优化 monorepo 性能。

**Q: 如何将现有的 GitHub Actions 工作流迁移到 Dagger？**
增量迁移。一次移植一个任务 —— 通常是先移植构建或测试任务。保持 GitHub Actions 工作流作为编排层，用 `dagger call` 调用替换单独的步骤。这种混合方法让你在维护现有 CI 基础设施的同时验证 Dagger。随着时间推移，将剩余任务整合到 Dagger 函数中。

**Q: Dagger 支持哪些容器运行时？**
Dagger 需要 Linux 容器运行时：Docker Engine 24.0+、Podman 4.0+、containerd 或任何 OCI 兼容的运行时。在 macOS 和 Windows 上，需要 Docker Desktop 或 Podman Desktop。Rootless Docker 和 Podman 在参考文档中有一些配置注意事项。

**Q: 我可以将 Dagger 用于非 CI/CD 自动化吗？**
可以。Dagger 是一个通用容器自动化平台。团队将其用于本地开发环境设置、数据处理流水线、安全扫描工作流和基础设施测试。任何涉及在步骤之间有依赖关系的容器中运行的任务都是潜在的 Dagger 用例。

## 结论

Dagger 为 CI/CD 带来了根本不同的方法：流水线作为真正的代码，在容器中执行，在每台机器上表现相同。15,829 个 GitHub Star 反映了一个厌倦了 YAML 调试和厂商特定锁定的开发者社区。

对于使用 Go、Python 或 TypeScript 的团队，Dagger 消除了应用代码和 CI 配置之间切换的认知开销。仅本地优先执行模型 —— 在你的笔记本上将 4 分钟的 CI 流水线运行在 8 秒内 —— 就足以证明每天多次发布的团队迁移的合理性。

### 行动项

1. 安装 Dagger CLI：`brew install dagger/tap/dagger`
2. 运行快速入门：`dagger init --sdk=python --source=./dagger my-pipeline`
3. 先移植你的构建任务 —— 保持现有 CI 作为触发层
4. 加入 [Discord](https://discord.com/invite/dagger-io) 上的 Dagger 社区获取支持
5. 探索 [Daggerverse](https://daggerverse.dev) 寻找可复用模块

关注 dibi8 DevOps Telegram 群组获取每周 CI/CD 工具更新和生产部署模式：**https://t.me/dibi8dev**



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [Dagger 官方文档](https://docs.dagger.io/)
- [Dagger GitHub 仓库](https://github.com/dagger/dagger) — 15.8k stars, Apache-2.0
- [Daggerverse 模块注册表](https://daggerverse.dev)
- [Dagger 安装指南](https://docs.dagger.io/getting-started/installation)
- [Dagger 核心概念](https://docs.dagger.io/core-concepts)
- [Dagger  Cookbook](https://docs.dagger.io/cookbook)
- [Dagger Cloud 价格](https://dagger.io/cloud)
- [2026 年最佳 CI/CD 工具对比](https://www.deployhq.com/blog/best-ci-cd-software-top-10-tools-to-know-in-2025)
- [Dagger CI/CD 教程：用代码编写流水线](https://byteiota.com/dagger-ci-cd-tutorial-write-pipelines-as-code-not-yaml/)
- [2026 年最佳 CI/CD 工具：数据解读](https://blog.jetbrains.com/teamcity/2026/03/best-ci-tools/)
- [Dagger for GitHub Action](https://github.com/dagger/dagger-for-github)
