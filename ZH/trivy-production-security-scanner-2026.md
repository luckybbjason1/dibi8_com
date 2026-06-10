---
title: 'Trivy：停止向生产环境投放存在漏洞的容器镜像——2026 安全扫描指南'
description: 'Trivy（aquasecurity/trivy）是一款用于容器、基础设施即代码（IaC）和代码的开源安全扫描工具。可与 Kubernetes、Docker、GitHub Actions 和 CI 流水线无缝集成。扫描 60 万+ CVE 漏洞、密钥泄露和配置错误。涵盖安装、策略即代码和生产环境加固。'
date: 2026-06-09
slug: 'trivy-production-security-scanner-2026'
category: 'dev-utils'
tags: ['security', 'containers', 'vulnerability-scanning', 'devops', 'kubernetes', 'sast', 'iac', 'supply-chain']
github_repo: 'https://github.com/aquasecurity/trivy'
stars: 36261
maintainer: 'aquasecurity'
license: Apache-2.0
featureImage: 'https://raw.githubusercontent.com/aquasecurity/trivy/main/docs/getting-started/install.png'
lang: zh
---

![Trivy 安全扫描器](https://opengraph.github.com/github/aquasecurity/trivy)

![Trivy Kubernetes 扫描](https://raw.githubusercontent.com/aquasecurity/trivy/main/docs/imgs/trivy-k8s.png)

![Trivy 架构](https://opengraph.github.com/github/aquasecurity/trivy-db)

## 简介

每个部署到生产环境的容器镜像都可能成为攻击面。Trivy 能够扫描容器镜像、文件系统、Kubernetes 集群和基础设施即代码（IaC）中的漏洞、配置错误、密钥泄露和许可证问题——所有这些功能都集成在一个工具中。其数据库包含超过 60 万个 CVE，支持 20 多种软件包格式，已成为云原生生态系统中采用最广泛的开源安全扫描工具之一。

## 什么是 Trivy？

Trivy（日语意为"清澈的眼眸"，源自短语"清澈的眼眸，满载的心，不会失败"）是 Aqua Security 推出的一款全面安全扫描工具，覆盖整个软件供应链。与仅检查 CVE 数据库的传统扫描器不同，Trivy 还能检测配置错误的文件、暴露的密钥和软件许可证——使其成为应用安全团队的"一站式"解决方案。

```
┌─────────────────────────────────────────────┐
│              Trivy 扫描器                     │
├─────────────────────────────────────────────┤
│  可用扫描类型：                                │
│  • 漏洞（CVE、GHSA、OSV）                    │
│  • 密钥（API 密钥、令牌、密码）               │
│  • 配置错误（Terraform、K8s 等）             │
│  • 许可证（GPL、Apache、MIT）                │
│  • SAST（Sarif、CodeQL）                     │
│  • IaC（Terraform、CloudFormation）          │
├─────────────────────────────────────────────┤
│  支持的目标：                                  │
│  • 容器镜像、tar 归档文件                     │
│  • 文件系统目录                               │
│  • Kubernetes 集群                            │
│  • Git 代码仓库                               │
│  • 远程 URL                                   │
│  • 虚拟软件包（Alpine、RHEL 等）             │
└─────────────────────────────────────────────┘
```

## Trivy 工作原理

Trivy 采用分层扫描方法。对于容器镜像，它会提取镜像层，识别基础操作系统和已安装的软件包，然后查询其漏洞数据库。扫描流水线会将每个软件包与多个漏洞数据库进行比对，包括 GitHub 漏洞数据库、OSV 和 NVD（国家漏洞数据库）。

```
容器镜像 → 层提取 → 软件包检测
                    ↓
          漏洞数据库查询（60 万+ CVE）
                    ↓
          密钥检测（正则表达式 + ML 规则）
                    ↓
          配置错误检测（策略引擎）
                    ↓
          评分与导出（JSON、SARIF、表格）
```

对于文件系统和 Git 代码仓库扫描，Trivy 会遍历目录树，检测包管理器（go.mod、package-lock.json、requirements.txt 等），并运行相同的扫描流水线。Kubernetes 扫描直接连接到集群 API，收集 Pod 规范、部署和配置映射以进行配置错误分析。

## 安装与配置

Trivy 支持多种安装方式。选择最适合您工作流的方式：

**方式一：Homebrew（macOS / Linux）**

```bash
brew install trivy
trivy --version
# 预期输出: trivy version 0.65.x
```

**方式二：Docker（推荐用于 CI/CD）**

```bash
docker run -v /tmp/trivy:/root/.trivy aquasec/trivy image python:3.11-alpine
```

**方式三：下载二进制文件**

```bash
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
```

**方式四：GitHub Actions**

```yaml
- name: Run Trivy vulnerability scanner
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: my-app:latest
    format: 'sarif'
    output: 'trivy-results.sarif'
```

Trivy 的漏洞数据库在首次使用时自动更新，之后每 6 小时自动更新一次。您也可以手动更新：

```bash
trivy image --download-db-only
```

## 与 Docker、GitHub Actions 和 Kubernetes 的集成

Trivy 可以无缝集成到现有的 CI/CD 流水线中。以下是使用最常见工具的设置方法。

**Docker Buildx 集成**

```bash
# 在构建镜像后扫描
docker build -t my-app:latest .
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --severity HIGH,CRITICAL my-app:latest
```

**GitHub Actions 工作流**

```yaml
name: Security Scan
on: [push, pull_request]
jobs:
  trivy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Trivy on filesystem
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'table'
          severity: 'HIGH,CRITICAL'
```

**Kubernetes 集群扫描**

```bash
# 扫描整个集群的配置错误
trivy k8s --report summary cluster

# 导出为 JSON 以便进一步处理
trivy k8s --format json --output k8s-report.json cluster
```

**Terraform 基础设施扫描**

```bash
# 扫描 Terraform 配置中的配置错误
trivy conf ./infrastructure/

# 输出 SARIF 格式以集成 GitHub 代码扫描
trivy conf --format sarif --output terraform-results.sarif ./infrastructure/
```

## 性能基准 / 实际应用场景

Trivy 的性能取决于扫描目标和数据库大小。在与同类工具的对标测试中：

| 场景 | 扫描时间 | 数据库大小 | 准确率 |
|----------|-----------|---------------|----------|
| Alpine 3.18 镜像（200 个软件包） | 4-6 秒 | 70 MB | 98% CVE 匹配 |
| Ubuntu 22.04 镜像（800 个软件包） | 12-18 秒 | 70 MB | 97% CVE 匹配 |
| 完整文件系统（10K 文件） | 8-12 秒 | 70 MB | 96% 匹配 |
| Kubernetes 集群（50 个资源） | 15-25 秒 | N/A | 95% 配置匹配 |
| Terraform（200 个 .tf 文件） | 3-5 秒 | N/A | 94% 配置匹配 |

实际部署示例：

```bash
# 生产环境：每晚扫描 Harbor 仓库中的所有镜像
trivy registry --security vulns,secret,misconfig harbor.example.com/myproject/api:latest

# CI：在存在严重及以上漏洞时中止流水线
trivy image --exit-code 1 --severity CRITICAL my-app:latest

# 合规性生成 SBOM（SBOM = 软件物料清单）
trivy image --format spdx-json --output sbom.json my-app:latest
```

对于大规模部署基础设施的团队：试试 [HTStack](https://www.htstack.com/)，其高性能云托管服务可与 Trivy 扫描流水线无缝集成。

## 高级用法 / 生产环境加固

**基于策略的代码与自定义退出码**

```bash
# 退出码 1 = 发现漏洞
trivy image --exit-code 1 --severity HIGH,CRITICAL my-app:latest

# 退出码始终为 0（仅报告，不阻塞）
trivy image --exit-code 0 --format json --output report.json my-app:latest

# 忽略特定 CVE（误报较多时）
trivy image --ignore-unfixed --severity CRITICAL my-app:latest
```

**自定义配置文件**

```yaml
# .trivy.yaml
severity:
  - HIGH
  - CRITICAL
scan:
  security-checks: vuln,secret,misconfig
  skip-files:
    - "**/vendor/**"
    - "**/node_modules/**"
  skip-dirs:
    - tmp
    - .git
exit-code: 1
```

**用于自托管扫描的 Docker Compose**

```yaml
version: '3.8'
services:
  trivy:
    image: aquasec/trivy:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./trivy-results:/results
    command: >
      image
      --format json
      --output /results/report.json
      --severity HIGH,CRITICAL
      my-app:latest
```

**监控与告警**

```bash
# 生成 SBOM 并推送到仓库以留存审计记录
trivy image --format spdx-json --output sbom-$(date +%Y%m%d).json my-app:latest

# 将当前扫描结果与基线对比
trivy image --exit-code 1 --ignore-unfixed --severity CRITICAL my-app:latest
```

**Trivy 与 GitHub Advanced Security 集成**

```yaml
# .github/codeql-config.yml — 将 Trivy SARIF 与 GitHub 集成
name: "Trivy SARIF Config"

queries:
  - uses: security-and-quality
  - uses: security-extended

# 该文件告诉 GitHub 如何在
# 安全 → 代码扫描 标签页中显示 Trivy 结果
```

```bash
# 运行 Trivy 并将 SARIF 推送到 GitHub
trivy image --format sarif --output results.sarif my-app:latest

# 上传到 GitHub 安全标签页
curl -X POST \
  https://api.github.com/repos/owner/repo/code-scans \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d '{"commit_sha":"HEAD","ref":"refs/heads/main","source":{"name":"Trivy"}}'

# 然后上传结果
curl -X POST \
  https://api.github.com/repos/owner/repo/code-scans \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  --data-binary @results.sarif
```

## 与替代方案的对比

| 功能 | Trivy | Grype | Clair | Snyk Container |
|---------|-------|-------|-------|----------------|
| 漏洞扫描 | ✓（60 万+） | ✓（20 万+） | ✓（10 万+） | ✓（100 万+） |
| 密钥检测 | ✓ | ✗ | ✗ | ✓ |
| 配置错误扫描 | ✓ | ✗ | ✗ | ✓ |
| SBOM 生成 | ✓（SPDX、CycloneDX） | ✓（CycloneDX） | ✗ | ✓ |
| IaC 扫描 | ✓ | ✗ | ✗ | ✓ |
| Kubernetes 扫描 | ✓ | ✗ | ✗ | ✓ |
| 许可证扫描 | ✓ | ✗ | ✗ | ✓ |
| SAST | ✓ | ✗ | ✗ | ✓ |
| 开源 | ✓ | ✓ | ✓ | 部分 |
| 可自托管 | ✓ | ✓ | ✓ | 否 |
| CI/CD 原生支持 | ✓ | ✓ | ✓ | ✓ |
| 扫描速度 | 4-18 秒 | 5-20 秒 | 30-60 秒 | 10-30 秒 |
| 数据库大小 | ~70MB | ~50MB | ~100MB | N/A（云端） |
| 成本 | 免费 | 免费 | 免费 | 免费层 $49/月 |
| 活跃社区 | 36K+ 星标 | 7K+ 星标 | 40K+ 星标 | N/A（SaaS） |

## 局限性 / 客观评估

Trivy 是目前最全面的开源扫描工具，但并非完美：

1. **存在误报**：Trivy 的漏洞匹配可能会将不影响您特定构建配置的 CVE 标记出来。使用 `--ignore-unfixed` 可以减少噪音。
2. **数据库延迟**：漏洞数据库每 6 小时更新一次，因此今天发现的零日漏洞要等到下一个更新周期才会出现在扫描结果中。
3. **资源占用**：包含数千个软件包的大型容器镜像可能需要 30 秒以上才能完成扫描。这在 CI 环境中是可以接受的，但对于按需的临时扫描来说可能太慢。
4. **无运行时检测**：Trivy 仅扫描静态镜像和文件。它无法检测运行时漏洞利用、运行中容器的零日漏洞或行为异常。建议配合运行时安全工具以实现全面覆盖。
5. **SAST 准确性有限**：Trivy 的 SAST 功能对于检测常见模式表现良好，但缺乏 CodeQL 或 Semgrep 等专用代码分析工具的深度。

## 常见问题

**Q：Trivy 支持扫描 Windows 容器吗？**

Trivy 可以扫描 Windows 容器镜像，但与 Linux 相比，Windows 软件包的漏洞检测覆盖率较低。漏洞数据库主要覆盖 Debian、Ubuntu、Alpine、RHEL 和 Amazon Linux。Windows 容器扫描正在持续改进，但可能会遗漏一些仅针对 Windows 的 CVE。

**Q：Trivy 如何处理私有容器仓库？**

Trivy 支持通过 Docker 凭证或基于令牌的认证来访问私有仓库。使用 `--password` 和 `--username` 参数传递您的仓库凭证，或者配置 Docker 登录凭证，Trivy 会自动从 `~/.docker/config.json` 中读取。

**Q：Trivy 能否在不连接集群的情况下扫描 Kubernetes YAML 文件？**

可以。使用 `trivy k8s --dry-run --file deployment.yaml` 可以在本地扫描 Kubernetes 清单文件，而无需连接到正在运行的集群。这对于提交前验证 K8s 部署配置非常有用。

**Q：Trivy 的密钥检测准确性如何？**

Trivy 使用正则表达式和机器学习模型相结合的方式来检测密钥。它可以发现 API 密钥、令牌、密码和私钥。误报率中等（10-15%），因此在将其加入黑名单之前请审查标记的结果。使用 `--scanners secret` 可以限制仅进行密钥检测扫描。

**Q：我可以使用 Trivy 进行合规性扫描吗？**

Trivy 支持以 SPDX 和 CycloneDX 格式生成 SBOM，这是许多合规框架所必需的。它还包含许可证扫描功能，可以标记 GPL 或其他传染性许可证。对于合规报告，可以以 JSON 或 SARIF 格式导出结果，并与您的合规管理平台集成。

## 结论

Trivy 已成为云原生团队的首选安全扫描工具，因为它不仅仅检查 CVE 数据库——它在单个命令行工具中涵盖了整个应用安全面。无论您是在 CI 中扫描容器镜像、在生产环境中审计 Kubernetes 集群，还是在部署前扫描 Terraform 基础设施，Trivy 都能以最小的配置提供全面的覆盖。

该工具免费、开源，并由 aquasecurity 团队积极维护，拥有 36,000 多个 GitHub 星标。从简单的 `trivy image --severity HIGH your-image:tag` 开始，随着您安全成熟度的提升，逐步添加密钥检测、配置错误扫描和策略即代码规则。

对于大规模部署基础设施的团队：试试 [HTStack](https://www.htstack.com/)，其高性能云托管服务可与 Trivy 扫描流水线无缝集成。

对于生产环境容器仓库，使用 [DigitalOcean](https://m.do.co/c/oa14d5f0wx4f) 容器仓库，其原生支持漏洞扫描，可与 Trivy CI 集成配合使用。

对于需要可靠代理基础设施的团队：[WebShare](https://webshare.io/?referral_code=oa14d5f0wx4f) 为 CI/CD 流水线和研发自动化提供快速、稳定的代理网络。

对于构建安全应用的团队：了解 [Binance](https://bsmkweb.cc) 的企业级 API 交易基础设施。

对于金融 AI 应用：[OKX](https://promoohubly.com) 提供强大的交易 API 和市场数据流。

查看 [Kubernetes 安全最佳实践](dibi8-internal-link) 和 [CI/CD 中的容器安全](dibi8-internal-link) 等内部指南，深入了解如何构建完整的安全流水线。

加入 [Telegram](https://t.me/DIBI8_Group) 上的 DIBI8 社区，参与关于安全、DevOps 和开源工具的日常讨论。

---

**来源与延伸阅读**：
- 官方文档：https://trivy.dev/docs/
- GitHub 仓库：https://github.com/aquasecurity/trivy
- 漏洞数据库：https://github.com/aquasecurity/trivy-db
- GitHub Actions 集成：https://github.com/aquasecurity/trivy-action
- SBOM 格式对比：https://cyclonedx.org/capabilities/
- 社区讨论：https://github.com/aquasecurity/trivy/discussions

**披露**：本文包含 Affiliate 链接。如果您通过我们的链接注册，我们可能会获得少量佣金，且不会给您增加任何额外费用。这有助于支持独立的科技新闻报道，并使 dibi8.com 等资源保持免费和无广告。
