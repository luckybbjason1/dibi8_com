---
title: 'RAGFlow: 部署拥有 80K+ Stars 的生产级 RAG 引擎 — 2026 年 Docker 搭建与性能基准测试'
description: 'RAGFlow 是具备深度文档理解和内置 Agent 能力的开源检索增强生成（RAG）引擎。兼容 Ollama、OpenAI、Qdrant、Elasticsearch、Redis。涵盖 Docker 部署、文档导入、检索调优和生产环境加固。'
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
github_repo: 'https://github.com/infiniflow/ragflow'
stars: 80853
maintainer: 'infiniflow'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['ragflow', 'RAG引擎', '文档理解', 'Docker部署', 'LLM智能体', '生产级RAG', '开源AI']
aliases:
- /zh/posts/ragflow/
---

{{</* resource-info */>}}

![RAGFlow Logo](https://raw.githubusercontent.com/infiniflow/ragflow/main/web/public/logo.svg)

## 引言

大多数 RAG 管道在生产环境中失败，是因为它们将 PDF 和 PPT 视为纯文本处理。表格被搞乱，图片说明丢失，扫描文档变得无法阅读。结果是检索系统向 LLM 返回垃圾上下文，然后产生幻觉答案。拥有超过 80,000 个 GitHub Star 的开源 RAG 引擎 RAGFlow 正是为解决这个问题而构建的。其 DeepDoc 引擎可以理解文档布局，内置的 Agent 框架让你能够构建自主知识工作者，而不仅仅是聊天机器人。在本指南中，你将在生产服务器上部署 RAGFlow，配置文档导入，调优检索质量，并将其集成到现有的 LLM 技术栈中。

## 什么是 RAGFlow？

RAGFlow 是一个开源检索增强生成引擎，它将深度文档理解与 LLM 驱动的 Agent 相结合，从复杂的企业文档中提供有依据、带引用的回答。与依赖简单文本分割的通用 RAG 库不同，RAGFlow 分析文档结构 —— 表格、图像、标题和扫描页面 —— 以在导入过程中保留语义含义。它以基于 Docker 的平台形式交付，配有 Web UI、REST API 和 Agent 构建器，适合构建管道的开发人员和管理知识库的非技术用户。

## RAGFlow 的工作原理

![RAGFlow System Architecture](https://raw.githubusercontent.com/infiniflow/ragflow/main/docs/img/ragflow-architecture.png)

RAGFlow 的架构遵循模块化管道设计，包含六个核心阶段：

### 1. 文档导入（DeepDoc）

文档通过 **DeepDoc** 解析引擎进入 RAGFlow。DeepDoc 对 PDF、Word 文件、Excel 表格、PPT 幻灯片、图像和扫描副本执行布局分析。它使用基于视觉的文档布局模型识别表格、图形、标题、段落和文本块。此阶段还支持外部解析器（如 MinerU 和 Docling）处理专用格式。

### 2. 知识提取与分块

解析后，RAGFlow 应用基于模板的分块策略。你可以根据文档类型选择多种分块模式 —— 简单、手动、问答、表格、论文、书籍、法律、演示文稿、图片和单一模式。每个分块保留其结构上下文，RAGFlow 可选择性地提取关键词并生成相关问题以提高检索召回率。

### 3. 索引（混合搜索后端）

分块内容被索引到 **Elasticsearch**（默认）或 **Infinity** 中以支持混合搜索。同时支持全文搜索和密集向量搜索。系统使用可配置的嵌入模型计算嵌入向量，并将向量与倒排索引一起存储以支持关键词检索。

### 4. 检索与重排序

当查询到达时，RAGFlow 执行多渠道检索：关键词搜索、向量相似度搜索和知识图谱遍历（如果启用了 GraphRAG）。结果经过融合后，使用交叉编码器重排序器进行重排序，然后传递到 LLM 上下文窗口。

### 5. 带引用的生成

RAGFlow 构建一个包含检索到的带可追溯引用分块的提示词。LLM 基于检索到的上下文生成答案，RAGFlow 在响应旁边显示源分块，以便用户可以验证每个声明。

### 6. Agent 执行（可选）

除了简单的问答之外，RAGFlow 的 Agent 框架支持带记忆的多步骤工作流、工具调用、MCP（模型上下文协议）集成和在沙箱环境中的代码执行。Agent 可以浏览网页、查询数据库并链式执行多个检索操作。

### 基础设施技术栈

| 服务 | 用途 | 默认后端 |
|------|------|----------|
| 向量 + 全文存储 | 文档索引与搜索 | Elasticsearch 或 Infinity |
| 对象存储 | 上传文档的文件存储 | MinIO |
| 元数据库 | 用户数据、数据集配置、聊天历史 | MySQL |
| 缓存与队列 | 任务队列和会话缓存 | Redis |
| 文档解析器 | 布局分析与 OCR | DeepDoc（内置） |
| 前端 | 数据集管理的 Web UI | React + TypeScript |
| 后端 API | 核心编排逻辑 | Python + Go |

## 安装与设置

### 硬件要求

| 资源 | 最低要求 | 生产环境推荐 |
|------|---------|-------------|
| CPU | 4 核 (x86_64) | 8+ 核 |
| 内存 | 16 GB | 32+ GB |
| 磁盘 | 50 GB SSD | 200+ GB NVMe |
| Docker | 24.0.0+ | 最新稳定版 |
| Docker Compose | v2.26.1+ | 最新稳定版 |

> **注意：** RAGFlow 官方支持 x86_64 平台。ARM64 经社区测试，但需要自行构建 Docker 镜像。

### 部署前：系统调优

在启动 RAGFlow 之前，确保内核参数已为 Elasticsearch 调优：

```bash
# 检查当前的 vm.max_map_count
sysctl vm.max_map_count

# 设置为至少 262144（Elasticsearch 要求）
sudo sysctl -w vm.max_map_count=262144

# 在重启后保持持久
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

### 第一步：克隆代码仓库

```bash
git clone https://github.com/infiniflow/ragflow.git
cd ragflow/docker
git checkout -f v0.25.4
```

### 第二步：配置环境变量

```bash
# 编辑环境文件
cp .env .env.backup
nano .env
```

需要设置的关键变量：

```bash
# docker/.env
RAGFLOW_IMAGE=infiniflow/ragflow:v0.25.4
SVR_HTTP_PORT=80
MYSQL_PASSWORD=your_secure_mysql_password
MINIO_PASSWORD=your_secure_minio_password
REDIS_PASSWORD=your_secure_redis_password

# 选择文档引擎：elasticsearch 或 infinity
DOC_ENGINE=elasticsearch
```

### 第三步：使用 Docker Compose 启动

```bash
# CPU 部署
docker compose -f docker-compose.yml up -d

# GPU 加速文档解析（NVIDIA）
# sed -i '1i DEVICE=gpu' .env
# docker compose -f docker-compose.yml up -d
```

验证部署：

```bash
# 查看日志直到看到成功消息
docker logs -f ragflow-server

# 预期输出：
#     ____   ___    ______ ______ __
#    / __ \ /   |  / ____// ____// /____  _      __
#   / /_/ // /| | / / __ / /_   / // __ \| | /| / /
#  / _, _// ___ |/ /_/ // __/  / // /_/ /| |/ |/ /
# /_/ |_|/_/  |_|\____//_/    /_/ \____/ |__/|__/
#  * Running on all addresses (0.0.0.0)
```

### 第四步：配置 LLM 提供商

编辑 `service_conf.yaml.template` 添加你的 LLM API 密钥：

```yaml
# docker/service_conf.yaml.template
user_default_llm:
  factory: OpenAI
  api_key: sk-your-openai-api-key
  base_url: https://api.openai.com/v1
  default_model: gpt-4.1-mini
```

支持的 LLM 提供商包括 OpenAI、Anthropic、DeepSeek、Gemini、Azure OpenAI、Bedrock，以及通过 Ollama 或 vLLM 使用的本地模型。配置更改后重启容器：

```bash
docker compose -f docker-compose.yml down
docker compose -f docker-compose.yml up -d
```

### 第五步：访问 Web UI

打开浏览器，访问 `http://YOUR_SERVER_IP`。默认登录信息：

```
邮箱: admin@ragflow.io
密码: （首次登录时设置）
```

![RAGFlow Web Interface](https://raw.githubusercontent.com/infiniflow/ragflow/main/docs/img/login.png)

## 与主流工具集成

### Ollama（本地 LLM）

对于气隙环境或注重隐私的部署，将 RAGFlow 连接到 Ollama：

```yaml
# docker/service_conf.yaml.template
user_default_llm:
  factory: Ollama
  api_key: ""
  base_url: http://host.docker.internal:11434
  default_model: llama3.2
```

在使用前通过 Ollama 拉取模型：

```bash
ollama pull llama3.2
ollama pull nomic-embed-text
```

在 RAGFlow Web UI 的 **设置 > 模型提供商** 中配置嵌入模型。

### OpenAI（云端 API）

```yaml
user_default_llm:
  factory: OpenAI
  api_key: ${OPENAI_API_KEY}
  base_url: https://api.openai.com/v1
  default_model: gpt-4.1-mini
```

使用环境变量替换避免硬编码密钥：

```bash
# 在 .env 中
OPENAI_API_KEY=sk-your-key
```

### Elasticsearch 迁移到 Infinity

Infinity 是 RAGFlow 的融合上下文引擎，针对大规模部署进行了优化。切换方式：

```bash
# 1. 停止所有容器并清除卷
docker compose -f docker-compose.yml down -v

# 2. 更新 .env
sed -i 's/DOC_ENGINE=elasticsearch/DOC_ENGINE=infinity/' .env

# 3. 重新启动
docker compose -f docker-compose.yml up -d
```

> **警告：** 这将清除现有数据。迁移前请备份数据集。

### Redis 作为外部缓存

对于生产部署，使用外部 Redis 集群：

```yaml
# docker-compose.yml（节选）
services:
  redis:
    image: redis:7-alpine
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    deploy:
      resources:
        limits:
          memory: 2G
```

### Qdrant 作为替代向量存储

虽然 RAGFlow 原生使用 Elasticsearch 或 Infinity，但你可以通过 Python SDK 集成 Qdrant 用于自定义检索管道：

```python
from qdrant_client import QdrantClient
from ragflow_sdk import RAGFlow

# 同时连接两个系统
ragflow = RAGFlow(api_key="your-key", base_url="http://localhost:9380")
qdrant = QdrantClient(url="http://localhost:6333")

# 结合 RAGFlow 分块与 Qdrant 向量的自定义混合检索
chunks = ragflow.retrieve(dataset_id="ds_123", query="2025年年度收入")
vectors = qdrant.search(collection="financial_reports", vector=query_embedding, limit=5)
```

## 基准测试 / 实际应用案例

### 检索质量基准测试

AI Multiple 在 2026 年进行的一项基准测试比较了 RAGFlow 与其他框架，使用 100 个标准化查询，生成模型为 GPT-4.1-mini：

| 指标 | RAGFlow | LlamaIndex | Haystack | LangChain RAG |
|------|---------|------------|----------|---------------|
| 回答准确率 | 97% | 94% | 95% | 91% |
| 平均检索延迟 | 420ms | 380ms | 450ms | 510ms |
| 令牌效率（每查询） | 1,450 | 1,600 | 1,570 | 2,400 |
| 框架开销 | 8ms | 6ms | 5.9ms | 10ms |
| 引用 grounding 分数 | 96% | 88% | 90% | 82% |

RAGFlow 在准确率和引用 grounding 方面领先，这归功于 DeepDoc 的布局感知解析，它能保留表格结构和图片说明，而其他框架在文本分割时会将其剥离。

### 文档解析性能

| 文档类型 | RAGFlow (DeepDoc) | LlamaIndex | Haystack |
|---------|-------------------|------------|----------|
| 含表格的 PDF | 完整结构保留 | 扁平文本 | 扁平文本 |
| 扫描版 PDF (OCR) | 原生支持 | 需要扩展 | 需要扩展 |
| PPT 幻灯片 | 幻灯片感知分块 | 按幻灯片 | 按幻灯片 |
| Excel 电子表格 | 单元格级提取 | CSV 转换 | CSV 转换 |
| 多语言文档 | 跨语言查询 | 单语言 | 单语言 |

### 生产部署配置参考

| 配置档 | 用户数 | 文档数 | 硬件 | 月度云成本 |
|--------|--------|--------|------|-----------|
| 团队 (10 用户) | 10 | 10,000 | 4 vCPU, 16 GB RAM | ~$80 (DigitalOcean) |
| 部门 (100 用户) | 100 | 100,000 | 8 vCPU, 32 GB RAM | ~$200 (DigitalOcean) |
| 企业 (1000+ 用户) | 1000+ | 100万+ | 16 vCPU, 64 GB RAM + GPU | ~$800+ (云端) |

> 寻找可靠的 RAGFlow 云主机？通过 [DigitalOcean](https://www.digitalocean.com/) 一键部署 Docker，或使用 [HTStack](https://www.htstack.com/) 获得内置监控的托管容器托管服务。

## 高级用法 / 生产环境加固

### 使用反向代理启用 HTTPS

```nginx
# /etc/nginx/sites-available/ragflow
server {
    listen 443 ssl http2;
    server_name ragflow.yourcompany.com;

    ssl_certificate /etc/letsencrypt/live/ragflow.yourcompany.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ragflow.yourcompany.com/privkey.pem;

    location / {
        proxy_pass http://localhost:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 300s;
    }
}
```

### 启用 GraphRAG 进行多跳推理

GraphRAG 从文档中提取知识图谱，实现跨文档推理：

```python
# 通过 RAGFlow Web UI 或 API
POST /api/datasets/{dataset_id}/chunks/graph
{
  "method": "ligh",
  "entity_types": ["人物", "组织", "产品", "事件"],
  "max_workers": 4
}
```

GraphRAG 对法律文档、研究论文和财务报告特别有效，因为这些文档中实体之间的关系跨越多个页面。

### 配置沙箱（代码执行）

RAGFlow 的 Agent 可以在沙箱环境中执行 Python 和 JavaScript 代码。这需要 gVisor：

```bash
# 安装 gVisor（沙箱必需）
sudo apt-get install -y runsc

# 在 docker-compose.yml 中启用
services:
  ragflow:
    environment:
      - ENABLE_SANDBOX=true
    devices:
      - /dev/kvm
```

### 使用 Prometheus 监控

```yaml
# 添加到 docker-compose.yml
services:
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
```

需要监控的关键指标：

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'ragflow'
    static_configs:
      - targets: ['ragflow-server:9380']
    metrics_path: /metrics
```

### 备份策略

```bash
#!/bin/bash
# /opt/ragflow/backup.sh

BACKUP_DIR="/backups/ragflow/$(date +%Y%m%d)"
mkdir -p $BACKUP_DIR

# 备份 MySQL
docker exec ragflow-mysql mysqldump -u root -p$MYSQL_PASSWORD ragflow > $BACKUP_DIR/mysql.sql

# 备份 Elasticsearch 索引
docker exec ragflow-es curl -sX POST "localhost:9200/_snapshot/backup" \
  -H 'Content-Type: application/json' \
  -d'{"indices": "ragflow_*"}'

# 备份 MinIO 对象
docker exec ragflow-minio mc mirror /data $BACKUP_DIR/minio

# 同步到远程存储
rclone sync $BACKUP_DIR s3:my-backup-bucket/ragflow/
```

## 与替代方案对比

| 特性 | RAGFlow | LlamaIndex | Haystack | LangChain RAG |
|------|---------|------------|----------|---------------|
| **GitHub Stars** | 80,853 | 49,500 | 25,300 | 105,000 |
| **许可证** | Apache-2.0 | MIT | Apache-2.0 | MIT |
| **深度文档解析** | DeepDoc（内置） | LlamaParse（付费） | 基础 | 基础 |
| **可视化工作流构建器** | 是 | 否 | 否 | 否 |
| **内置 Web UI** | 是 | 否 | 否 | 否 |
| **Agent 框架** | 原生（带记忆） | 外部 | 外部 | LangGraph |
| **混合搜索** | 全文 + 向量 | 仅向量 | 全文 + 向量 | 取决于存储 |
| **GraphRAG 支持** | 是 | 是 | 通过扩展 | 通过扩展 |
| **扫描文档 OCR** | 原生 | 付费插件 | 通过扩展 | 通过扩展 |
| **代码执行沙箱** | 是（gVisor） | 否 | 否 | 否 |
| **自托管部署** | Docker Compose | Python 包 | Python 包 | Python 包 |
| **MCP 协议支持** | 是 | 否 | 否 | 否 |
| **REST API** | 完整 API | 需要自建 | 需要自建 | 需要自建 |
| **企业 SSO** | 是 | 仅云端 | 仅云端 | 仅云端 |

### 如何选择

- **RAGFlow**：你需要一个具备深度文档理解、可视化 UI 和内置 Agent 功能的完整自托管 RAG 平台。最适合处理复杂文档（PDF、扫描件、电子表格）并希望完全控制数据的企业。
- **LlamaIndex**：你正在构建具有特定索引需求的自定义 Python 应用，更喜欢库而非平台。最适合需要最大灵活性且不介意自建 UI 的开发人员。
- **Haystack**：你需要来自 deepset 的具有强大评估工具和企业支持的生产级管道框架。最适合优先考虑管道可观测性和测试的团队。
- **LangChain RAG**：你想要最大的集成生态系统，不介意自己组装组件。最适合需要快速迭代原型的初创公司。

## 局限性 / 客观评估

**不是轻量级工具。** RAGFlow 至少需要 16 GB 内存和多个后端服务（Elasticsearch、MySQL、Redis、MinIO）。这不是单一二进制部署。如果你需要一个简单的 RAG 设置用于 side project，可以考虑更轻的替代方案，如 LightRAG 或直接 LlamaIndex 实现。

**官方镜像仅支持 x86。** ARM64 平台（包括 Apple Silicon 和 AWS Graviton）需要从源代码自行构建 Docker 镜像。这会增加大量部署时间。

**高级功能有学习曲线。** 可视化 UI 覆盖了 80% 的用例，但启用 GraphRAG、配置自定义嵌入管道或构建 Agent 需要仔细阅读文档。

**没有原生多区域复制。** 虽然你可以备份和恢复数据集，但 RAGFlow 不为底层存储提供内置的跨区域复制。你需要单独配置 MySQL 和 Elasticsearch 复制。

**精简镜像不包含嵌入模型。** 从 v0.22.0 开始，仅发布精简镜像。你必须在运行时下载嵌入模型或连接到外部嵌入服务。

## 常见问题解答

### 生产环境部署 RAGFlow 需要什么硬件？

对于服务 50+ 用户的生产部署，请使用至少 8 vCPU 核心、32 GB RAM 和 200 GB NVMe SSD 的服务器。如果你使用 OCR 解析大型扫描 PDF，请添加至少 8 GB VRAM 的 GPU 来加速 DeepDoc 任务。对于 10 人以下的小团队，最低配置（4 vCPU、16 GB RAM）即可满足。

### RAGFlow 可以只使用本地 LLM 吗？

可以。RAGFlow 集成 Ollama、vLLM、Xinference 和 LocalAI。在 `service_conf.yaml.template` 中配置 LLM 提供商，填写本地推理服务器的 base URL。对于嵌入模型，通过 Ollama 拉取嵌入模型（如 `nomic-embed-text`）并在 Web UI 的模型提供商中配置。

### RAGFlow 如何处理扫描 PDF 和图像？

RAGFlow 的 DeepDoc 引擎包含内置 OCR 管道，可处理扫描 PDF、PNG 和 JPEG。它使用文档布局分析模型在应用 OCR 之前识别文本区域、表格和图像。提取的文本保持其结构上下文 —— 表格以表格形式保留，不会被扁平化为段落。

### 使用 RAGFlow 时我的数据安全吗？

自托管时，所有数据都保留在你的基础设施上。文档存储在 MinIO 中，向量存储在 Elasticsearch/Infinity 中，元数据存储在 MySQL 中 —— 全部在你的网络内。除非你配置了云 LLM 提供商，否则 RAGFlow 不会将文档发送到外部服务。为获得最大隐私，请使用本地 LLM 和嵌入模型。

### 如何将 RAGFlow 升级到新版本？

首先，备份 MySQL 数据库和 Elasticsearch 索引。然后拉取新 Docker 镜像，更新 `.env` 中的 `RAGFLOW_IMAGE` 变量，并重启容器。请务必查看版本间的发布说明，了解重大变更。

```bash
cd ragflow/docker
git fetch --tags
git checkout -f v0.25.4
# 在 .env 中更新镜像标签
docker compose -f docker-compose.yml down
docker compose -f docker-compose.yml pull
docker compose -f docker-compose.yml up -d
```

### 我可以将 RAGFlow 集成到现有应用中吗？

可以。RAGFlow 暴露了完整的 REST API，并提供 Python 和 JavaScript SDK。你可以以编程方式创建数据集、上传文档、启动聊天会话和检索答案。API 文档可在 RAGFlow 实例的 `/api/docs` 查看。

### RAGFlow 支持哪些文档格式？

RAGFlow 支持 Word（DOC、DOCX）、PowerPoint（PPT、PPTX）、Excel（XLS、XLSX）、PDF、TXT、Markdown、图像（PNG、JPG、BMP、TIFF）、扫描副本、HTML 和 CSV。它还支持从 Confluence、Notion、Google Drive、Discord 和 S3 导入数据。

### RAGFlow 支持多租户吗？

RAGFlow 支持在单个实例内使用基于角色的访问控制管理多用户和数据集。对于真正的多租户（具有独立数据的隔离租户），你目前需要运行单独的 RAGFlow 实例，或在应用层实现租户过滤。

## 结论

RAGFlow 是唯一的开源 RAG 平台，将深度文档理解、生产级 Web UI 和内置 Agent 功能整合在一个可部署系统中。凭借 80,853 个 GitHub Star 和活跃的开发周期，它已证明对需要超越基础文本分割 RAG 管道的团队具有价值。基于 Docker 的部署可在 30 分钟内完成，混合搜索架构提供比纯框架替代方案明显更优的检索质量。

**你的后续步骤：**

1. 克隆代码仓库，使用 Docker Compose 在你的服务器上部署 RAGFlow
2. 上传一个包含表格的复杂 PDF，并在 Web UI 中验证解析质量
3. 配置你首选的 LLM 提供商（OpenAI、DeepSeek 或 Ollama）
4. 为生产使用设置 HTTPS 和自动备份
5. 加入社区获取支持和功能更新

加入我们的 [Telegram 开发者社区](https://t.me/dibi8opensource) 获取部署技巧和生产 RAG 讨论。分享你的 RAGFlow 配置 —— 我们精选最佳配置在每周通讯中展示。

*本文中的部分链接是联盟链接。如果你通过这些链接购买托管服务，我们可能会获得佣金。这不会影响我们的编辑推荐。*



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [RAGFlow GitHub 代码仓库](https://github.com/infiniflow/ragflow)
- [RAGFlow 官方文档](https://ragflow.io/docs/dev/)
- [RAGFlow 快速入门指南](https://ragflow.io/docs/dev/)
- [RAGFlow Docker 部署 README](https://github.com/infiniflow/ragflow/blob/main/docker/README.md)
- [DeepDoc 文档理解](https://github.com/infiniflow/ragflow/tree/main/deepdoc)
- [RAGFlow REST API 参考](https://ragflow.io/docs/dev/category/references)
- [RAGFlow 与其他 RAG 框架基准测试](https://aimultiple.com/rag-frameworks)
- [LlamaIndex GitHub 代码仓库](https://github.com/run-llama/llama_index)
- [Haystack GitHub 代码仓库](https://github.com/deepset-ai/haystack)
- [2026 年最佳开源 RAG 框架对比](https://www.firecrawl.dev/blog/best-open-source-rag-frameworks)
- [RAGFlow 架构详解](https://milvus.io/ai-quick-reference/what-is-ragflow-and-how-does-it-work)
- [RAGFlow VPS 生产部署](https://zhujibaike.com/2497.html)
