---
title: 'Flowise: 52K+ Stars 可视化拖拽构建 AI Agent — 2026 5分钟快速上手指南'
description: 'Flowise 是一个开源可视化 LLM 工作流与 AI Agent 构建工具。支持 LangChain、Ollama、OpenAI、Qdrant、Weaviate、Chroma 等 200+ 集成。本文涵盖 Docker 安装、生产环境加固、API 部署及客观局限性分析。'
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
github_repo: 'https://github.com/FlowiseAI/Flowise'
stars: 52948
maintainer: 'FlowiseAI'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Flowise', 'LangChain', 'AI Agent', 'RAG', 'Docker', '大语言模型', '开源', '无代码']
aliases:
- /zh/posts/flowise/
- /zh/resources/ai-tools/flowise-ai-workflow-builder-lowcode/
---

{{</* resource-info */>}}

## 引言

开发基于大语言模型（LLM）的应用曾经意味着需要编写数百行 Python 代码，手动连接模型、向量数据库、检索链和记忆模块。Flowise 的出现彻底改变了这一局面。凭借 52,948 个 GitHub Stars 和活跃的开发者社区，Flowise 是一款开源可视化构建工具，让你通过拖拽节点、连接组件的方式构建 AI Agent 和 RAG 流水线 —— 完全不需要编写代码。无论你是想快速搭建一个客服机器人原型，还是在 $5/月的 VPS 上部署文档问答系统，本指南将带你从零开始，在五分钟内完成生产级 Flowise 环境搭建。

## Flowise 是什么？

Flowise 是一款基于 LangChain 的开源可视化 LLM 工作流与 AI Agent 构建工具。它提供了一个节点式画布，每个组件（聊天模型、Embedding、向量数据库、工具、Agent、Chain）都被封装成一个可拖拽的节点，通过连线即可形成可执行的流水线。Flowise 支持超过 200 个 LangChain 集成，包括 OpenAI、Anthropic、Ollama、Qdrant、Weaviate 和 Chroma，是目前集成能力最丰富的可视化 AI 构建工具之一。

## Flowise 的工作原理

Flowise 采用模块化架构，可视化节点与 LangChain 类一一映射。理解这个架构能帮助你构建更复杂的流程并更快定位问题。

![Flowise 架构图](https://raw.githubusercontent.com/FlowiseAI/Flowise/main/images/flowise.png)
*Flowise 可视化画布中连接的 LLM 节点 —— 每个节点对应一个 LangChain 类*

![Flowise 画布演示](https://docs.flowiseai.com/~gitbook/image?url=https%3A%2F%2F823733684-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252F00tYLwhz5RyR7fJEhrWy%252Fuploads%252FDOgMs2ywc1bdE09oa10c%252FFlowiseIntro.gif%3Falt%3Dmedia%26token%3D55bbcbc6-e586-4a79-8923-20c2b39e7bf9&width=768&dpr=3&quality=100&sign=c6ac7b1&sv=2)
*Flowise 拖拽式界面实战 —— 不写一行代码即可构建 RAG 流水线*

### 核心组件

1. **聊天模型（Chat Models）** —— LLM 引擎（OpenAI GPT-4o、Claude、Ollama 本地模型、Hugging Face、Bedrock、Gemini）
2. **Embedding** —— 将文本转换为向量以实现语义搜索（OpenAI、HuggingFace、Cohere）
3. **向量数据库（Vector Stores）** —— 持久化存储 Embedding 以供检索（Chroma、Qdrant、Weaviate、Pinecone、pgvector）
4. **文档加载器（Document Loaders）** —— 从 PDF、网页、文本文件、Notion、Confluence 导入数据
5. **Chains** —— 编排多步骤 LLM 操作（对话检索 QA、LLM Chain）
6. **Agents** —— 自主选择工具的自主推理系统（ReAct、OpenAI Functions）
7. **Memory** —— 在多轮对话中保持上下文（Buffer Memory、Window Buffer、Redis-backed）

### 三种构建模式

Flowise 提供三种可视化构建器：

- **Assistant** —— 面向初学者的聊天机器人构建器，支持 RAG。上传文档、配置回复并部署。
- **Chatflow** —— 完整节点式画布，可精确控制每个组件的自定义对话式 AI。
- **Agentflow** —— 多步骤 Agent 工作流，支持条件逻辑、循环、工具调用和人工审批。

每个构建的 Flow 都会自动暴露 REST API 端点和可嵌入的聊天组件，实现一键部署。

## 安装与配置

Flowise 提供四种安装方式，分别适合不同的环境和技能水平。

### 方式一：NPM（本地开发最快）

需要 Node.js v18.15.0 或 v20+。这是从安装到运行最快的路径。

```bash
# 全局安装 Flowise
npm install -g flowise

# 或安装指定版本
npm install -g flowise@3.1.2

# 启动 Flowise
npx flowise start
```

在浏览器中打开 `http://localhost:3000`。首次启动会在 `~/.flowise` 自动创建 SQLite 数据库。

### 方式二：Docker（推荐用于生产环境）

这是最可靠的部署方式。Flowise 在 Docker Hub 提供官方镜像，支持多架构。

```bash
# 拉取并运行官方镜像
docker run -d -p 3000:3000 \
  --name flowise \
  -e FLOWISE_USERNAME=admin \
  -e FLOWISE_PASSWORD=secure-password \
  flowiseai/flowise:latest
```

访问 `http://localhost:3000`，使用你设置的凭据登录。

### 方式三：Docker Compose（生产级，带数据库）

对于需要持久化的部署环境，使用 Docker Compose 配合 PostgreSQL 和卷挂载。

```yaml
# docker-compose.yml
version: '3.8'
services:
  flowise:
    image: flowiseai/flowise:latest
    ports:
      - "3000:3000"
    environment:
      - PORT=3000
      - DATABASE_TYPE=postgres
      - DATABASE_HOST=postgres
      - DATABASE_PORT=5432
      - DATABASE_NAME=flowise
      - DATABASE_USER=flowise
      - DATABASE_PASSWORD=${DB_PASSWORD:-changeme}
      - FLOWISE_USERNAME=${FLOWISE_USER:-admin}
      - FLOWISE_PASSWORD=${FLOWISE_PASS:-changeme}
      - SECRETKEY_PATH=/root/.flowise
      - JWT_AUTH_TOKEN_SECRET=${JWT_SECRET:-random-secret-change-in-prod}
      - JWT_REFRESH_TOKEN_SECRET=${JWT_REFRESH:-another-random-secret}
    volumes:
      - flowise_data:/root/.flowise
    depends_on:
      - postgres
    restart: unless-stopped

  postgres:
    image: postgres:16-alpine
    environment:
      - POSTGRES_USER=flowise
      - POSTGRES_PASSWORD=${DB_PASSWORD:-changeme}
      - POSTGRES_DB=flowise
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  flowise_data:
  postgres_data:
```

启动命令：

```bash
docker compose up -d
```

### 方式四：部署到 DigitalOcean 云服务器

如果你想在可靠的云 VPS 上托管 Flowise，可以在几分钟内部署到 DigitalOcean。

```bash
# 在全新的 Ubuntu 24.04 服务器上（2 vCPU / 2GB RAM / $12/月）
apt update && apt install -y docker.io docker-compose

# 克隆 Flowise 仓库
git clone https://github.com/FlowiseAI/Flowise.git
cd Flowise/docker

# 复制环境变量模板
cp .env.example .env

# 编辑配置文件
nano .env
```

DigitalOcean 部署的 `.env` 示例：

```bash
PORT=3000
DATABASE_TYPE=sqlite
DATABASE_PATH=/root/.flowise
SECRETKEY_PATH=/root/.flowise
LOG_PATH=/root/.flowise/logs
BLOB_STORAGE_PATH=/root/.flowise/storage
FLOWISE_USERNAME=admin
FLOWISE_PASSWORD=your-secure-password-here
JWT_AUTH_TOKEN_SECRET=$(openssl rand -hex 32)
JWT_REFRESH_TOKEN_SECRET=$(openssl rand -hex 32)
```

启动服务：

```bash
docker compose up -d
```

### 环境变量参考表

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `PORT` | HTTP 服务端口 | 3000 |
| `DATABASE_TYPE` | 数据库引擎（sqlite, postgres） | sqlite |
| `DATABASE_PATH` | SQLite 文件路径 | ~/.flowise |
| `FLOWISE_USERNAME` | 管理员用户名 | — |
| `FLOWISE_PASSWORD` | 管理员密码 | — |
| `JWT_AUTH_TOKEN_SECRET` | 访问令牌密钥 | 自动生成 |
| `JWT_REFRESH_TOKEN_SECRET` | 刷新令牌密钥 | 自动生成 |
| `BLOB_STORAGE_PATH` | 文件上传存储路径 | ~/.flowise/storage |
| `DISABLE_FLOWISE_TELEMETRY` | 关闭匿名遥测 | false |

## 与主流工具集成

### OpenAI 集成

大多数用户从 OpenAI 模型开始。在 Flowise UI 的 Credentials 中配置 API Key，然后在 Flow 中使用 `ChatOpenAI` 节点。

```bash
# 可选：将 OpenAI API Key 设置为环境变量
export OPENAI_API_KEY=sk-your-key-here
```

### Ollama（本地大模型）

使用 Ollama 运行本地模型可以消除 API 费用并确保数据不出服务器。此方案非常适合对隐私敏感的部署场景。

```yaml
# docker-compose-ollama.yml
version: '3.8'
services:
  ollama:
    image: ollama/ollama:latest
    ports:
      - "11434:11434"
    volumes:
      - ollama_data:/root/.ollama
    restart: unless-stopped

  flowise:
    image: flowiseai/flowise:latest
    ports:
      - "3000:3000"
    environment:
      - PORT=3000
      - OLLAMA_BASE_URL=http://ollama:11434
    depends_on:
      - ollama
    restart: unless-stopped

volumes:
  ollama_data:
```

拉取模型并开始使用：

```bash
# 拉取轻量级测试模型
docker exec -it ollama ollama pull qwen2:7b

# 或拉取 Llama 3
docker exec -it ollama ollama pull llama3.1:8b
```

在 Flowise 画布中，选择 `ChatOllama` 节点，将模型名设置为 `qwen2:7b` 或 `llama3.1:8b`。

### Chroma 向量数据库（RAG 设置）

对于生产级 RAG 流水线，Chroma 提供了一个轻量级向量数据库，与 Flowise 无缝协作。

```yaml
# 添加到 docker-compose.yml
  chroma:
    image: chromadb/chroma:latest
    ports:
      - "8000:8000"
    volumes:
      - chroma_data:/chroma/chroma
    restart: unless-stopped
```

在 Flowise 中构建 RAG 流水线：

1. 拖拽 **PDF Loader** 或 **Text File** 节点
2. 连接到 **Text Splitter** 节点（chunk size 设为 1000，overlap 设为 200）
3. 连接到 **OpenAI Embeddings**（或 **Ollama Embeddings**）节点
4. 连接到 **Chroma** 向量数据库节点
5. 添加 **Conversational Retrieval QA Chain** 节点
6. 将 **Chat Model**（ChatOpenAI 或 ChatOllama）连接到 Chain
7. 点击 **Save** 和 **Run**

### Qdrant（可扩展向量搜索）

对于高吞吐量的混合搜索 RAG 场景，Qdrant 的性能优于内存存储。

```yaml
# 在 compose 文件中添加 Qdrant
  qdrant:
    image: qdrant/qdrant:latest
    ports:
      - "6333:6333"
      - "6334:6334"
    volumes:
      - qdrant_data:/qdrant/storage
    restart: unless-stopped
```

在 Flowise 中使用 `Qdrant` 向量数据库节点，host 设置为 `http://qdrant:6333`。

### Weaviate（企业级向量数据库）

```yaml
  weaviate:
    image: semitechnologies/weaviate:latest
    ports:
      - "8080:8080"
    environment:
      QUERY_DEFAULTS_LIMIT: 25
      AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED: 'true'
      PERSISTENCE_DATA_PATH: '/var/lib/weaviate'
    volumes:
      - weaviate_data:/var/lib/weaviate
    restart: unless-stopped
```

### API 部署

每个 Flow 都会自动暴露 REST API。导出你的 Chatflow 并在任意地方集成。

```bash
# 使用 curl 测试已部署的 Flow
curl -X POST "http://localhost:3000/api/v1/prediction/your-chatflow-id" \
  -H "Content-Type: application/json" \
  -d '{
    "question": "退货政策是什么？",
    "overrideConfig": {
      "sessionId": "user_001"
    }
  }'
```

响应示例：

```json
{
  "text": "根据我们的文档，退货政策允许在购买后 30 天内凭原始收据退货。",
  "sourceDocuments": [
    {
      "pageContent": "购买后 30 天内接受退货...",
      "metadata": { "source": "return-policy.pdf", "page": 3 }
    }
  ]
}
```

Python SDK 示例：

```python
import requests

FLOWISE_API = "http://localhost:3000/api/v1/prediction/your-chatflow-id"

def ask(question, session_id="user_001"):
    resp = requests.post(FLOWISE_API, json={
        "question": question,
        "overrideConfig": {"sessionId": session_id}
    })
    return resp.json()["text"]

answer = ask("你们有哪些配送方式？")
print(answer)
```

### 嵌入网站

Flowise 为任意 Chatflow 生成 JavaScript 嵌入代码。将其粘贴到任意 HTML 页面即可：

![Flowise 嵌入组件](https://raw.githubusercontent.com/FlowiseAI/FlowiseChatEmbed/main/assets/embedded-chat-config.png)
*可自定义主题的嵌入聊天组件 —— 一个 script 标签即可部署到任意网站*

```html
<script type="module">
  import Chatbot from 'https://cdn.jsdelivr.net/npm/flowise-embed/dist/web.js';
  Chatbot.init({
    chatflowid: 'your-chatflow-id',
    apiHost: 'https://your-flowise-server.com',
    theme: {
      button: {
        backgroundColor: '#3B81F6',
        right: 20,
        bottom: 20,
        size: 'medium'
      },
      chatWindow: {
        title: '客服助手',
        welcomeMessage: '你好！有什么可以帮您的？',
        backgroundColor: '#ffffff',
        height: 700,
        width: 400
      }
    }
  });
</script>
```

## 基准测试 / 实际应用场景

根据社区报告和我们的实际测试，Flowise 的性能表现如下：

| 指标 | 数值 | 说明 |
|------|------|------|
| Docker 冷启动时间 | 3-5 秒 | 在 2 vCPU VPS 上 |
| 首响延迟 | 1.5-3 秒 | 使用 GPT-4o，取决于 prompt |
| RAG 查询端到端延迟 | 2-4 秒 | Chroma 向量库，1K chunks |
| 并发用户数 | 50-200 | SQLite 后端；更大规模请使用 PostgreSQL |
| 内存占用（空闲） | ~180 MB | 单容器 |
| 内存占用（活跃） | 300-600 MB | 取决于模型和上下文 |
| RAG Flow 搭建时间 | 10-15 分钟 | 从空白画布到可用聊天机器人 |
| 最低 VPS 配置 | 1 vCPU / 1 GB RAM | $4-5/月的 VPS 即可运行 |
| 推荐生产配置 | 2 vCPU / 4 GB RAM | 配合 PostgreSQL 使用 |

### 对比：Flowise vs 替代方案

| 特性 | Flowise | Dify | n8n | LangChain |
|------|---------|------|-----|-----------|
| GitHub Stars | 52,948 | 50,000+ | 49,500 | 110,000+ |
| 许可证 | MIT | Apache-2.0 | Fair-code | MIT |
| 可视化构建器 | 拖拽画布 | 应用中心式 UI | 工作流编辑器 | 纯代码 |
| 主要场景 | LLM 聊天机器人 & RAG | 全栈 AI 应用 | 工作流自动化 | 代码优先 SDK |
| LangChain 原生 | 是（直接映射） | 自定义抽象层 | 通过 AI 节点 | 它就是 LangChain |
| LLM 支持 | 200+（全部 LangChain） | 50+ | 70+ AI 节点 | 所有提供商 |
| 向量数据库 | Chroma, Qdrant, Weaviate, Pinecone, pgvector | 内置知识库 | 通过 LangChain 节点 | 全部 |
| 本地 LLM (Ollama) | 原生节点 | 原生集成 | 通过 HTTP 请求 | 原生 |
| 可嵌入聊天组件 | 是（自动生成） | 是 | 通过 webhook | 需手动构建 |
| REST API（自动生成） | 是 | 是 | 是 | 需手动构建 |
| 多 Agent 工作流 | Agentflow（顺序） | 工作流编排 | 是（AI 节点） | LangGraph |
| 调度/触发器 | 有限 | 有限 | 完整（cron、webhook） | 手动 |
| 自托管复杂度 | 低（单容器） | 中等（多服务） | 低-中等 | N/A（库） |
| 最低内存 | ~1 GB | 4 GB | 300 MB | N/A |
| 云版起步价 | $35/月 | $59/月 | ~$24/月 | N/A |
| 非技术用户体验 | 良好 | 优秀 | 良好 | 需要编程 |

### 如何选择

- **Flowise**：适合构建对话式 AI（聊天机器人、RAG）的团队，追求从原型到部署的最快路径，同时保持完整的 LangChain 兼容性。
- **Dify**：当你需要全栈 AI 应用平台，内置知识管理、Prompt 版本控制和团队协作时选择。
- **n8n**：当你的 AI Agent 是更广泛自动化流水线的一部分，需要 400+ SaaS 集成、调度和错误处理时选择。
- **LangChain**：当你需要完全的代码控制、Prompt 版本管理和 CI/CD 集成时直接使用。

## 高级用法 / 生产环境加固

### 安全检查清单

在将 Flowise 暴露到公网之前，请完成以下步骤：

```bash
# 1. 启用身份验证（必须）
FLOWISE_USERNAME=admin
FLOWISE_PASSWORD=$(openssl rand -base64 24)

# 2. 设置强 JWT 密钥
JWT_AUTH_TOKEN_SECRET=$(openssl rand -hex 64)
JWT_REFRESH_TOKEN_SECRET=$(openssl rand -hex 64)

# 3. 使用反向代理启用 HTTPS
# Nginx 配置片段：
server {
    listen 443 ssl http2;
    server_name flowise.yourdomain.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

# 4. 如需要可关闭遥测
DISABLE_FLOWISE_TELEMETRY=true

# 5. 为嵌入组件设置 CORS
CORS_ORIGINS=https://yourdomain.com,https://app.yourdomain.com
```

### 队列模式扩展

对于高流量部署，Flowise 支持基于 Redis 的队列处理与工作进程。

```yaml
# docker-compose-queue.yml
version: '3.8'
services:
  redis:
    image: redis:alpine
    restart: unless-stopped

  flowise:
    image: flowiseai/flowise:latest
    ports:
      - "3000:3000"
    environment:
      - PORT=3000
      - QUEUE_NAME=flowise-queue
      - QUEUE_REDIS_URL=redis://redis:6379
    restart: unless-stopped

  flowise-worker:
    image: flowiseai/flowise-worker:latest
    environment:
      - QUEUE_NAME=flowise-queue
      - QUEUE_REDIS_URL=redis://redis:6379
    restart: unless-stopped
```

水平扩展工作进程：

```bash
docker compose -f docker-compose-queue.yml up -d --scale flowise-worker=3
```

### 备份策略

```bash
# 备份 SQLite 数据库
docker exec flowise tar czf /tmp/backup.tar.gz /root/.flowise
docker cp flowise:/tmp/backup.tar.gz ./flowise-backup-$(date +%Y%m%d).tar.gz

# 备份 PostgreSQL
docker exec flowise-postgres pg_dump -U flowise flowise > flowise-db-$(date +%Y%m%d).sql

# 通过 cron 实现每日自动备份（添加到 crontab）
0 2 * * * /usr/local/bin/backup-flowise.sh >> /var/log/flowise-backup.log 2>&1
```

### Docker 监控

```bash
# 查看实时日志
docker compose logs -f flowise

# 检查资源使用
docker stats flowise

# 健康检查端点
curl http://localhost:3000/api/v1/ping
```

## 局限性 / 客观评估

Flowise 并非适用于所有 AI 项目。以下情况不建议使用 Flowise：

1. **复杂多 Agent 编排**：Flowise Agentflow 支持顺序 Agent，但循环式多 Agent 模式（如 LangGraph 或 AutoGen 中的模式）需要变通方案。构建研究型 Agent 或辩论式多 Agent 系统的团队应考虑直接使用 LangGraph。

2. **非聊天类工作流**：Flowise 针对对话式 AI 优化。批量文档处理、ETL 流水线或定时数据转换更适合由 n8n 或 Python 脚本处理。

3. **版本控制**：可视化 Flow 无法像代码一样在 Git 中进行 diff 比较。大型团队协作需要手动导出和版本化 JSON Flow 定义。

4. **高级调试**：虽然 Flowise 显示执行日志，但缺乏 Dify 原生提供的节点级时间分解和 token 使用量追踪。调试复杂的检索失败需要阅读原始日志。

5. **企业治理**：RBAC 存在于 Pro 版本中，但审计追踪、合规框架（ISO 42001、欧盟 AI 法案）和集群管理并非一等功能。受监管行业可能需要额外的治理层。

6. **LangChain 依赖**：Flowise 继承了 LangChain 的限制。如果 LangChain 停止支持某个模型或引入破坏性变更，Flowise 也会受到影响。对于 LangChain 用户这是优势，对其他人则是约束。

## 常见问题

### 没有 Node.js 的服务器如何安装 Flowise？

使用 Docker。官方 `flowiseai/flowise` 镜像已打包所有依赖。一条 `docker run` 命令即可运行，无需在宿主机上安装 Node.js、pnpm 或任何构建工具。

### Flowise 能否与 Llama 或 Qwen 等本地大模型配合工作？

可以。Flowise 原生集成 Ollama。启动 Ollama 容器（或本地实例），拉取任意 GGUF 模型，然后在 Flowise 画布中选择 `ChatOllama` 节点。你的数据永远不会离开服务器 —— 无需 API Key。

### 构建 RAG 聊天机器人时，Flowise 与 Dify 如何选择？

Flowise 搭建更快（单容器，无需数据库），并对每个 LangChain 组件提供精确控制。Dify 的知识库 UI 更精致，自动分块且调试体验更好。追求速度和 LangChain 兼容性选 Flowise；追求团队协作和内置知识管理选 Dify。

### Flowise 可以免费商用吗？

可以。Flowise 采用 MIT 许可证发布。你可以自托管、修改、嵌入商业产品、销售基于它的服务 —— 全部无需支付许可费。云托管版本有付费套餐，起步价 $35/月。

### Flowise 生产环境的最低服务器配置是什么？

$5/月的 VPS（1 vCPU / 1 GB RAM）配合 SQLite 即可处理中小型工作负载。生产环境配合 PostgreSQL 和多用户并发，建议分配 2 vCPU 和 4 GB RAM。Flowise 容器本身空闲时占用约 180 MB；通过 Ollama 自托管的 LLM 消耗资源最多。

### 可以将 Flowise 聊天机器人导出为 API 吗？

每个 Chatflow 和 Agentflow 都会自动获得 REST API 端点，路径为 `/api/v1/prediction/{flow-id}`。UI 会生成 curl、Python 和 JavaScript 代码片段。你也可以一键导出可嵌入的聊天组件。

### 如何将 Flowise 升级到新版本？

Docker 部署：拉取最新镜像并重启：

```bash
docker pull flowiseai/flowise:latest
docker compose up -d
```

NPM 安装：运行 `npm update -g flowise`。升级前始终备份 `~/.flowise` 目录。

*部分链接为联盟链接。我们可能获得佣金，但你无需支付额外费用。我们只推荐我们实际使用过的工具和服务。*

## 结论

Flowise 消除了从想法到部署 AI Agent 之间的障碍。凭借 52,948 个 GitHub Stars、MIT 许可证以及与 LangChain 组件模型直接映射的可视化画布，它是开发者的务实选择 —— 在不编写样板代码的前提下交付 LLM 驱动的聊天机器人和 RAG 系统。

从 `npx flowise start` 开始本地原型。使用 Docker Compose 配合 PostgreSQL 进入生产。连接 Ollama 实现完全私有、无需 API Key 的部署。需要扩展时，添加 Redis 队列工作进程和水平工作副本。

**本周行动清单：**
1. 使用 Docker 本地部署 Flowise（`docker run -p 3000:3000 flowiseai/flowise`）
2. 使用 PDF 加载器、文本分割器和 Chroma 向量库构建你的第一条 RAG 流水线
3. 导出 REST API 并在测试页面嵌入聊天组件
4. 加入 [FlowiseAI Telegram 群组](https://t.me/flowiseai) 获取社区支持和每周技巧



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

1. [Flowise 官方文档](https://docs.flowiseai.com/) —— 安装、配置和 API 参考的完整文档
2. [Flowise GitHub 仓库](https://github.com/FlowiseAI/Flowise) —— 源代码、Issues 和 Releases
3. [Flowise 云版定价](https://flowiseai.com/pricing) —— 云托管套餐和企业功能
4. [LangChain 文档](https://js.langchain.com/) —— Flowise 底层框架
5. [Ollama 下载](https://ollama.com/download) —— 私有化 LLM 运行时
6. [Chroma 数据库](https://www.trychroma.com/) —— 开源向量数据库
7. [Qdrant 向量数据库](https://qdrant.tech/) —— 高性能向量搜索
8. [Flowise vs Dify 对比](https://toolhalla.ai/blog/dify-vs-flowise-vs-langflow-2026) —— ToolHalla 详细对比
9. [Flowise 嵌入组件文档](https://www.npmjs.com/package/flowise-embed) —— 嵌入聊天机器人的 NPM 包
10. [DigitalOcean Docker 部署指南](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-24-04) —— Ubuntu 服务器 Docker 安装教程
