---
title: 'Dify: 5 分钟可视化构建生产级 AI Agent — 141K+ Stars 安装配置指南 2026'
description: 'Dify 是开源 LLM 应用开发平台，提供可视化工作流构建器、RAG 管道和 Agent 编排功能。兼容 OpenAI、Anthropic、Ollama、Qdrant 和 Weaviate。涵盖 Docker 部署、API 集成、生产环境加固，以及与 Flowise、n8n 和 LangChain 的对比分析。'
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
github_repo: 'https://github.com/langgenius/dify'
stars: 141955
maintainer: 'langgenius'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Dify', 'AI 智能体构建器', 'LLM 工作流', 'RAG', 'Docker 部署', '开源 AI', '可视化工作流', '生产级 AI']
aliases:
- /zh/posts/dify/
- /zh/resources/llm-frameworks/dify-architecture-b2b-agent-orchestration/
---

{{</* resource-info */>}}

大多数团队以艰难的方式交付 AI 聊天机器人。他们将 Flask 路由连接到 OpenAI API，在 JSON 文件中手工编写提示模板，并从零开始构建 RAG 管道——包括嵌入模型、向量存储和分块逻辑。三个月后，原型无法维护，产品经理无法在没有开发人员的情况下更新提示，知识库同步是一个静默失败的定时任务。

**Dify** 解决了这个问题。它是一个开源平台，将可视化工作流设计、生产级 RAG、多模型支持和 API 发布打包到一个可部署的堆栈中。凭借 **141,955 个 GitHub Stars**、**1,298 名贡献者**以及每 2-4 周的发布节奏，Dify 已成为希望交付 AI 应用而无需编写编排样板代码的团队的首选。本指南将在 5 分钟内带你完成生产级 Dify 设置，然后展示如何将其与实际工具集成并进行扩展。

## 什么是 Dify？

**Dify** 是一个面向生产的 Agent 工作流开发平台。可以把它视为原始 LLM API 与最终用户 AI 产品之间缺失的应用层。Dify 提供了一个可视化画布，你可以在其中拖放和连接节点——LLM 调用、知识检索、HTTP 请求、代码执行、条件分支——构建完整的 AI 应用程序。

该平台基于 **Beehive（六边形）架构**构建，组件模块化：Python Flask API 服务、Celery 工作队列、Next.js 前端、用于模型提供商的插件守护进程，以及用于代码执行的安全沙箱。它支持 **30+ 向量数据库**（Weaviate、Qdrant、pgvector、Milvus）、**20+ LLM 提供商**（OpenAI、Anthropic、Azure OpenAI、AWS Bedrock、Ollama、Groq），并内置混合搜索、重排序、可观测性和 RESTful API 生成。

你可以构建的关键应用类型：

- **聊天助手** — 具有记忆、知识库和工具调用功能的对话式 AI
- **文本生成器** — 用于摘要、翻译、代码生成的单次补全应用
- **Agent** — 具有 ReAct、函数调用和思维链推理的自主 AI
- **工作流** — 具有条件逻辑和并行执行的多步骤可视化管道

## Dify 的工作原理

Dify 的架构将关注点分离到通过明确定义的 API 通信的离散服务中。理解这一点有助于你调试、扩展和加固部署。

### 架构概览

![Dify 架构图](https://res.cloudinary.com/asset-cloudinary/image/upload/v1776523341/Dify_-_railway_arch_xp1wuv.png)

| 服务 | 端口 | 技术 | 用途 |
|------|------|------|------|
| Web 前端 | 3000 | Next.js | 可视化构建器、仪表盘、管理界面 |
| API 服务 | 5001 | Python Flask | REST API 端点、业务逻辑 |
| Worker | — | Celery | 异步任务处理、文档索引 |
| Worker Beat | — | Celery | 定时任务调度器 |
| 插件守护进程 | 5002 | Python | 模型提供商插件运行时 |
| 沙箱 | 5003 | Python | 安全代码执行环境 |
| SSRF 代理 | — | Nginx | 出站请求安全隔离 |

### 数据层

| 组件 | 默认 | 替代方案 |
|------|------|----------|
| 元数据数据库 | PostgreSQL 15 | AWS RDS、Cloud SQL |
| 缓存/队列 | Redis 7 | AWS ElastiCache、Redis Cloud |
| 向量存储 | Weaviate 1.27 | Qdrant、Milvus、pgvector |
| 文件存储 | 本地卷 | S3、MinIO、GCS |

### 工作流执行引擎

Dify 的工作流引擎使用 DAG（有向无环图）执行模型，支持并行处理。工作流中的每个节点可以顺序或并行线程运行，变量池系统支持跨节点数据共享同时保持隔离。引擎强制执行 **每个工作流 500 步** 和 **1,200 秒超时** 的执行限制，以防止失控进程。

## 安装与配置

### 前置条件

在开始之前，确保你的机器满足以下要求：

| 资源 | 最低配置 | 推荐配置 |
|------|---------|---------|
| CPU | 2 核 | 4+ 核 |
| 内存 | 4 GiB | 8 GiB |
| 磁盘 | 20 GB | 50 GB SSD |
| Docker | 19.03+ | 最新版 |
| Docker Compose | 2.24.0+ | 最新版 |

### 第一步 — 克隆 Dify

从 GitHub 克隆最新版本：

```bash
git clone --branch "$(curl -s https://api.github.com/repos/langgenius/dify/releases/latest | jq -r .tag_name)" https://github.com/langgenius/dify.git
```

这将检出最新的稳定标签（截至撰写时为 v1.14.2）。

### 第二步 — 配置环境

```bash
cd dify/docker
cp .env.example .env
```

编辑 `.env` 设置安全的密钥：

```bash
# 生成加密安全的密钥
SECRET=$(openssl rand -hex 32)
sed -i "s/SECRET_KEY=.*/SECRET_KEY=${SECRET}/" .env
```

`.env` 中需要检查的关键变量：

```bash
# 核心设置
CONSOLE_API_URL=http://localhost:5001
CONSOLE_WEB_URL=http://localhost:3000
SERVICE_API_URL=http://localhost:5001
APP_API_URL=http://localhost:5001
APP_WEB_URL=http://localhost:3000

# 数据库
DB_USERNAME=postgres
DB_PASSWORD=difyai123456
DB_HOST=db
DB_PORT=5432
DB_DATABASE=dify

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_DB=0

# 向量存储（默认 Weaviate）
VECTOR_STORE=weaviate
WEAVIATE_ENDPOINT=http://weaviate:8080
WEAVIATE_API_KEY=WVF5YThaHlkYwhGUSmCRgsX3tD5ngdN8pkih
```

### 第三步 — 启动 Dify

```bash
docker compose up -d
```

这将启动 11 个容器：5 个核心服务和 6 个依赖项。验证一切正常运行：

```bash
docker compose ps
```

你应该看到所有容器处于 `Up (healthy)` 状态。首次启动需要 60-90 秒，因为 API 服务需要运行数据库迁移。

### 第四步 — 初始化管理员账户

打开浏览器并访问：

```
http://localhost/install
```

使用你的邮箱和密码完成设置向导。设置完成后，在以下地址登录：

```
http://localhost
```

### 第五步 — 添加第一个模型提供商

导航到 **设置 → 模型提供商** 并为至少一个提供商添加 API 密钥。对于 OpenAI：

1. 从提供商列表中选择 "OpenAI"
2. 粘贴你的 API 密钥（`sk-...`）
3. 点击 "保存"

使用 Ollama 进行本地开发：

1. 确保 Ollama 正在本地运行（`ollama serve`）
2. 从提供商列表中选择 "Ollama"
3. 将基础 URL 设置为 `http://host.docker.internal:11434`
4. 选择已下载的模型（例如 `llama3.1:8b`）

```bash
# 拉取轻量级模型进行测试
ollama pull llama3.1:8b
```

你的 Dify 实例现在已准备好构建 AI 应用程序。

## 与流行工具集成

### OpenAI / Anthropic Claude

添加主要 LLM 提供商是一个配置更改，而不是部署操作。在 **设置 → 模型提供商** 中添加 API 密钥后，创建你的第一个聊天应用：

1. 前往 **工作室 → 创建应用 → 聊天助手**
2. 命名为 "支持助手"
3. 在提示编辑器中编写你的系统提示
4. 从下拉菜单中选择你的模型（GPT-4o、Claude Sonnet 等）
5. 点击 **发布**

通过 API 访问应用：

```bash
curl -X POST 'http://localhost/v1/chat-messages' \
  -H 'Authorization: Bearer YOUR_APP_API_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "inputs": {},
    "query": "如何重置我的密码？",
    "response_mode": "streaming",
    "conversation_id": "",
    "user": "user-123"
  }'
```

### Ollama（本地 LLM）

对于隔离网络或成本敏感的环境，Ollama 集成让你可以运行本地模型：

```bash
# 启动 Ollama
ollama serve

# 拉取模型
ollama pull llama3.1:8b
ollama pull qwen2.5:14b
```

在 Dify 中，前往 **设置 → 模型提供商 → Ollama** 并配置：

| 字段 | 值 |
|------|-----|
| 模型名称 | `llama3.1:8b` |
| 基础 URL | `http://host.docker.internal:11434` |

使用本地模型进行开发，并在生产环境中切换到云模型，而无需更改应用逻辑。

### Qdrant 向量存储

用 Qdrant 替换 Weaviate 以获得更好的扩展性能：

```bash
cd dify/docker
cp envs/vectorstores/qdrant.env.example envs/vectorstores/qdrant.env
```

编辑 `envs/vectorstores/qdrant.env`：

```bash
VECTOR_STORE=qdrant
QDRANT_URL=http://qdrant:6333
QDRANT_API_KEY=your-api-key
QDRANT_CLIENT_TIMEOUT=20
```

将 Qdrant 添加到你的 `docker-compose.override.yaml`：

```yaml
services:
  qdrant:
    image: qdrant/qdrant:latest
    ports:
      - "6333:6333"
    volumes:
      - qdrant_data:/qdrant/storage
    environment:
      - QDRANT__SERVICE__API_KEY=your-api-key

volumes:
  qdrant_data:
```

重启 Dify：

```bash
docker compose down
docker compose up -d
```

### Weaviate

Weaviate 是默认的向量存储，开箱即用。对于生产环境，使用外部 Weaviate 集群：

```bash
# 在 .env 中
VECTOR_STORE=weaviate
WEAVIATE_ENDPOINT=https://your-cluster.weaviate.network
WEAVIATE_API_KEY=your-api-key
```

### Claude Code 集成

将你的 Dify 应用导出为 MCP（模型上下文协议）服务器并连接到 Claude Code：

1. 在你的 Dify 应用中，前往 **API 访问 → MCP 服务器**
2. 启用 MCP 发布
3. 复制 MCP 服务器 URL
4. 在 Claude Code 中运行：

```bash
claude config add mcp.dify http://localhost:5001/your-mcp-endpoint
```

你的 Dify 工作流现在可以直接从 Claude Code 对话中调用。

## 基准测试 / 实际用例

### 性能特征

基于社区基准测试和负载测试数据：

| 指标 | 1 CPU / 2 GB 内存 | 4 CPU / 8 GB 内存 | 8 CPU / 16 GB 内存 |
|------|------------------|------------------|-------------------|
| QPS（无模型调用） | 3 req/s | 8 req/s | 11 req/s |
| QPS（使用 GPT-4o） | 2 req/s | 5 req/s | 6 req/s |
| P95 延迟（工作流） | 2.1s | 1.2s | 0.8s |
| 并发用户 | ~20 | ~100 | ~500 |

*注意：实际吞吐量在很大程度上取决于 LLM 提供商延迟和工作流复杂性。*

### 文档索引性能

| 操作 | 100 份文档 | 1,000 份文档 | 10,000 份文档 |
|------|-----------|-------------|--------------|
| 上传 + 分块 | 30s | 4 分钟 | 35 分钟 |
| 嵌入（OpenAI） | 45s | 6 分钟 | 50 分钟 |
| 总索引时间 | 75s | 10 分钟 | 85 分钟 |

### 成本对比（自托管月度）

| 规模 | VPS 成本 | LLM 成本 | 总计 |
|------|---------|---------|------|
| 开发 / 1 用户 | $20 | $5-10 | $25-30 |
| 小团队 / 50 用户 | $40 | $50-100 | $90-140 |
| 企业 / 500 用户 | $200 | $500-1,000 | $700-1,200 |

### 实际部署模式

**客户支持聊天机器人** — 一家 40 人的 SaaS 公司部署了基于 800 页产品文档训练的 Dify 聊天机器人。解决率从 45% 提高到 78%，支持工单量在第一个月内下降了 35%。

**内部知识助手** — 一家金融科技团队在 50,000 份内部文档上构建了 RAG 驱动的助手。员工平均在 2.3 秒内获得有来源的答案，取代了原本需要 5-10 分钟的手动 wiki 搜索。

**潜在客户资格 Agent** — 一家 B2B 初创公司构建了一个工作流，使用 GPT-4o 为入站潜在客户评分，查询 PostgreSQL 数据库获取历史转化数据，并通过 Slack 将热门潜在客户路由给销售团队。响应时间：每条潜在客户不到 10 秒。

## 高级用法 / 生产环境加固

### 环境隔离

对于生产环境，切勿使用默认的 `.env` 值。创建特定于环境的配置：

```bash
# 生产环境
cp .env .env.production
```

生产环境的关键更改：

```bash
# 安全
SECRET_KEY=$(openssl rand -hex 48)
CONSOLE_API_URL=https://dify.yourcompany.com
CONSOLE_WEB_URL=https://dify.yourcompany.com
SERVICE_API_URL=https://dify.yourcompany.com

# 数据库（外部）
DB_HOST=your-rds-endpoint.amazonaws.com
DB_USERNAME=dify_prod
DB_PASSWORD=<strong-password>

# Redis（外部）
REDIS_HOST=your-elasticache-endpoint
REDIS_PASSWORD=<strong-password>
REDIS_USE_SSL=true

# 文件存储（S3）
STORAGE_TYPE=s3
S3_USE_AWS_MANAGED_IAM=false
S3_ENDPOINT=https://s3.amazonaws.com
S3_BUCKET_NAME=dify-prod-uploads
S3_ACCESS_KEY=AKIA...
S3_SECRET_KEY=...
S3_REGION=us-east-1
```

### 反向代理与 SSL

使用 Nginx 或 Traefik 进行 TLS 终止：

```nginx
server {
    listen 443 ssl http2;
    server_name dify.yourcompany.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /v1/ {
        proxy_pass http://localhost:5001;
        proxy_set_header Host $host;
        proxy_read_timeout 300s;
    }
}
```

### 监控与可观测性

Dify 通过 API 服务暴露指标。对于生产监控，设置：

```yaml
# docker-compose.monitoring.yaml
services:
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3001:3000"
    volumes:
      - grafana_data:/var/lib/grafana

  node-exporter:
    image: prom/node-exporter:latest
    ports:
      - "9100:9100"

volumes:
  grafana_data:
```

需要跟踪的关键指标：

| 指标 | 警告阈值 | 严重阈值 |
|------|---------|---------|
| API 响应时间 (P95) | > 2s | > 5s |
| Worker 队列深度 | > 100 | > 500 |
| 错误率 | > 1% | > 5% |
| 磁盘使用率 | > 70% | > 85% |
| 内存使用率 | > 75% | > 90% |

### 备份策略

```bash
#!/bin/bash
# backup-dify.sh — 通过 cron 每日运行

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=/backups/dify

# PostgreSQL 备份
docker exec dify-db pg_dump -U postgres dify > $BACKUP_DIR/dify_db_$DATE.sql

# Redis 备份
docker exec dify-redis redis-cli BGSAVE

# 文件存储备份（如果使用本地卷）
tar czf $BACKUP_DIR/dify_uploads_$DATE.tar.gz /var/lib/docker/volumes/dify_uploads/

# 上传到 S3（可选）
aws s3 sync $BACKUP_DIR/ s3://your-backup-bucket/dify/ --delete
```

### 扩展 Worker

对于高容量文档处理，水平扩展 Celery worker：

```bash
# docker-compose.override.yaml
services:
  worker:
    deploy:
      replicas: 3
    environment:
      - CELERY_WORKER_CONCURRENCY=8

  worker-beat:
    deploy:
      replicas: 1  # 保持恰好 1 个 beat 实例
```

## 与替代品对比

| 功能 | Dify | Flowise | n8n | LangChain |
|------|------|---------|-----|-----------|
| **GitHub Stars** | 141,955 | 51,000 | 182,000 | 110,000 |
| **许可证** | Apache-2.0 | MIT | Fair-code | MIT |
| **主要用例** | AI 应用平台 | LLM 原型设计 | 工作流自动化 | 代码优先框架 |
| **可视化构建器** | 是（画布） | 是（节点图） | 是（线性流） | 否（纯代码） |
| **学习曲线** | 很低 | 中等 | 中等 | 高 |
| **内置 RAG** | 优秀（数据集原生） | 良好（LangChain） | 基础（通过节点） | 自行构建 |
| **向量数据库支持** | 30+ | 10+ | 5+ | 20+ |
| **LLM 提供商** | 20+ | 15+ | 10+ | 50+ |
| **多 Agent** | 中等 | 强（v2.0） | 基础 | 强（LangGraph） |
| **非技术用户** | 同类最佳 | 不理想 | 不理想 | 否 |
| **SaaS 连接器** | ~80 | ~100 | 400+ | 自行构建 |
| **自托管** | Docker、K8s、Helm | Docker、K8s | Docker、K8s | N/A（库） |
| **API 生成** | 自动生成 | 手动 | 基于 Webhook | 手动 |
| **评估工具** | 强（数据集） | 最少 | 无 | LangSmith（外部） |
| **最低内存（自托管）** | 4 GB | 1 GB | 300 MB | N/A |
| **云价格（入门）** | $59/月 | $35/月 | $24/月 | 免费（库） |

### 选择建议

- **选择 Dify** 当你构建面向客户的 AI 应用、需要强 RAG、希望非技术团队成员管理提示和知识库，或需要自动生成 API。Dify 是从创意到部署 AI 产品的最快路径。
- **选择 Flowise** 当你是喜欢 LangChain 抽象的开发人员，并希望获得可视化原型层。Flowise 拥有最干净的"导出"路径——将流程导出为 JSON 并转换为 Python LangChain 代码。
- **选择 n8n** 当你的 AI Agent 是更大自动化工作流中的一个步骤。n8n 的 400+ SaaS 连接器和久经考验的调度、重试和错误处理在运维密集型集成方面无可匹敌。
- **选择 LangChain** 当你需要完整的代码级控制、CI/CD 集成、亚秒级延迟，或低代码工具无法表达的复杂多 Agent 编排。

## 局限性 / 客观评估

Dify 并非适用于每个 AI 项目。以下是它**不擅长**的方面：

**1. 亚秒级延迟工作负载**
Dify 简单工作流的 P95 延迟约为 1.2 秒，主要是由于节点之间的数据库查询。如果你需要亚 500ms 的响应（例如实时建议引擎），请使用代码优先框架如 LangGraph 或部署专用的 FastAPI 服务。

**2. 复杂数据结构**
工作流画布对深度嵌套对象的支持较浅。当你需要具有嵌套数组和条件字段的复杂输入/输出模式时，Dify 会强制使用变通方法，而在代码中则不需要这些变通。

**3. 重型工作流自动化**
Dify 工作流以 AI 为中心。如果你的自动化主要在 Salesforce、HubSpot、Slack 和数据库之间移动数据，且 AI 成分很少，n8n 是更合适的选择。与 n8n 的 400+ 集成相比，Dify 的非 AI 连接器库有限。

**4. 大规模多 Agent 系统**
虽然 Dify 支持 Agent 节点，但具有共享状态和动态规划的复杂多 Agent 协作最好由 LangGraph 或 CrewAI 处理。Dify 的 Agent 能力足以应对大多数用例，但不适用于研究级多 Agent 编排。

**5. 内存受限的文档处理**
数据集索引是同步的，大型上传可能需要数分钟。使用非常大的知识库（100K+ 文档）进行文档处理会显示内存压力，需要谨慎的 worker 扩展。

## 常见问题解答

**问：如何在云 VPS 上安装 Dify？**
安装过程与本地安装相同。配置至少 4 GB 内存的 VPS（DigitalOcean、Hetzner 或 AWS Lightsail 均可），安装 Docker 和 Docker Compose，克隆仓库，然后运行 `docker compose up -d`。对于一键部署，可以使用 [DigitalOcean Dify Marketplace 应用](https://www.digitalocean.com)。

**问：Dify 可以完全离线运行吗？**
可以。将 Ollama 配置为你的模型提供商，并运行 Llama 3.1、Qwen 2.5 或 Mistral 等本地模型。所有 Dify 服务在 Docker 内运行，不需要外部依赖。唯一的限制是，没有互联网访问，你无法使用云 LLM API。

**问：如何将 Dify 升级到新版本？**
```bash
cd dify/docker
docker compose down
git fetch --tags
git checkout $(curl -s https://api.github.com/repos/langgenius/dify/releases/latest | jq -r .tag_name)
docker compose pull
docker compose up -d
```
升级前，请务必查看发布说明，了解破坏性变更和新要求的环璄变量。

**问：Dify 的聊天助手和 Agent 应用类型有什么区别？**
聊天助手应用遵循固定的提示模板，并可选知识检索。Agent 应用使用 ReAct 或函数调用推理来自主决定调用哪些工具以及调用顺序。对于简单的问答使用聊天助手，对于需要工具使用和推理的复杂任务使用 Agent。

**问：我可以使用自己的嵌入模型代替 OpenAI 的吗？**
可以。Dify 支持多种嵌入提供商，包括 Ollama（本地）、Cohere、Jina 和 Hugging Face。前往 **设置 → 模型提供商** 添加你首选的嵌入模型。你甚至可以为嵌入和生成使用不同的模型。

**问：Dify 如何处理数据隐私和安全？**
Dify 是自托管的——你的数据永远不会离开你的基础设施，除非你选择使用云 LLM API。所有文件存储、向量嵌入和对话历史记录都保存在你的 PostgreSQL 和向量数据库中。SSRF 代理隔离出站请求，沙箱在受限环境中运行不受信任的代码。

**问：创建知识库或应用的数量有限制吗？**
开源版本没有硬限制。实际限制取决于你的基础设施：文档的磁盘空间、嵌入的向量数据库容量以及 API worker 的查询吞吐量。大多数团队在单个 8 GB 内存实例上运行 50+ 应用和 20+ 知识库而没有问题。

**问：我可以为 Dify 贡献代码或构建自定义插件吗？**
可以。Dify 拥有活跃的插件生态系统。你可以使用 Python 构建自定义模型提供商插件、工具插件或 Agent 策略插件。插件守护进程在开发期间支持热重载，使迭代循环快速。详情请参阅[插件开发文档](https://docs.dify.ai/en/plugins)。

## 结论

Dify 填补了纯框架和简单聊天机器人构建器之间的空白。它为你提供具有**生产级 RAG**、**自动生成 API** 和**多模型支持**的**可视化工作流构建器**，全部集成在单个可部署堆栈中。对于交付 AI 应用（而不仅仅是原型设计）的团队来说，这种组合可以节省数周的集成工作。

在 5 分钟内，你克隆了 Dify，启动了 11 个容器，创建了管理员账户，并连接了第一个 LLM 提供商。从那时起，你可以构建聊天机器人、Agent、文本生成器和复杂工作流——所有这些都带有非技术团队成员可以使用的可视化画布。

**本周行动清单：**
1. 使用上述 Docker Compose 设置在你的基础设施上部署 Dify
2. 使用你的产品文档创建知识库
3. 构建聊天助手应用并使用 REST API 进行测试
4. 在 Telegram 上的 [dibi8 开发者社区](https://t.me/dibi8hub) 分享你的部署经验

*想在 30 分钟内启动一个在线业务？Systeme.io 提供免费的漏斗构建器、邮件营销和自动化工具——无需信用卡。立即在 [Systeme.io](https://systeme.io) 注册并开始构建你的数字业务。*

*本文包含联盟链接。如果你通过这些链接购买，我们可能会赚取佣金，而不会向你收取额外费用。这有助于我们维护此类开源工具指南。*



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

1. Dify 官方文档 — https://docs.dify.ai/
2. Dify GitHub 仓库 — https://github.com/langgenius/dify
3. Dify Docker Compose 部署指南 — https://docs.dify.ai/en/self-host/quick-start/docker-compose
4. Dify API 参考 — https://docs.dify.ai/en/use-dify/publish/developing-with-apis
5. Dify 插件开发 — https://docs.dify.ai/en/plugins
6. Dify 架构博客文章 — https://dify.ai/blog/dify-rolls-out-new-architecture
7. Dify v1.14.2 发布说明 — https://github.com/langgenius/dify/releases/tag/1.14.2
8. Flowise GitHub 仓库 — https://github.com/FlowiseAI/Flowise
9. n8n GitHub 仓库 — https://github.com/n8n-io/n8n
10. LangChain 文档 — https://python.langchain.com/
11. 对比分析：Dify vs Flowise vs n8n — https://rapidclaw.dev/blog/low-code-ai-agent-platforms-compared-2026
12. Ollama 本地 LLM 设置 — https://ollama.com/download
