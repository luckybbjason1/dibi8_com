---
title: 'n8n AI 工作流自动化: 18.8万星自托管部署 — 比 Zapier 省 70%'
description: 'n8n（fair-code）是具有原生 AI 能力的可视化工作流自动化平台，支持 400+ 集成。兼容 Claude Code、OpenAI、Anthropic、Slack、Discord、Telegram。涵盖 Docker 部署、AI 节点配置、Webhook 部署和生产环境加固。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Sustainable Use License
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/n8n-io/n8n'
stars: 188782
maintainer: 'n8n-io'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['n8n', '工作流自动化', '自托管', 'AI 智能体', 'Docker', 'LangChain', '开源', '低代码']
aliases:
- /zh/posts/n8n/
- /zh/resources/dev-utils/n8n-ai-workflow-automation-self-hosted-2026/
---

{{</* resource-info */>}}

![n8n logo](https://raw.githubusercontent.com/n8n-io/n8n/master/assets/n8n-logo.png)
*n8n fair-code 工作流自动化平台 — 188K+ GitHub 星标，400+ 集成。*

## 简介

自动化平台已成为现代 SaaS 技术栈的连接纽带，但成本增长速度往往超过工作流本身的扩展速度。一家中型电商企业在 Zapier 上运行每月 1 万次的 8 步订单处理工作流，会消耗 8 万个任务额度，需要企业版套餐，月费超过 400 美元。同样的工作负载在自托管 n8n 上仅需每月 12 美元的 VPS，且没有执行次数限制。这一成本现实推动 n8n 在 GitHub 上获得 188,782 个星标，使其成为最受欢迎的工作流自动化项目之一。本指南将带你完成生产级自托管 n8n 的 AI 能力部署——从 Docker Compose 配置到队列模式扩展——附带可立即部署的真实配置文件。

## 什么是 n8n？

n8n（发音为 "n-eight-n"）是一个 fair-code 许可的工作流自动化平台，结合了基于 LangChain 构建的可视化节点编辑器和原生 AI 能力。它通过拖拽界面连接 400 多个应用和服务，同时允许使用自定义 JavaScript 和 Python 代码节点实现高级逻辑。与纯无代码工具不同，n8n 面向需要数据主权、无限执行次数和自托管能力的技术团队，无需担心供应商锁定。

## n8n 的工作原理

### 架构概述

![n8n architecture](https://docs.n8n.io/_images/common-workflow-diagram.png)
*n8n 工作流架构 — 触发器通过节点执行引擎连接到操作节点。*

n8n 采用基于节点的执行引擎，工作流以有向图的形式组织。每个节点代表一个动作——触发器、数据转换、API 调用、AI 模型推理——边定义数据流向。执行引擎基于 Node.js 运行，将工作流定义、凭据和执行历史存储在关系型数据库中。

**核心组件：**

- **工作流引擎**：基于 Node.js 的执行器，支持顺序或并行处理工作流
- **Web UI**：基于 Vue.js 的可视化编辑器，用于构建和调试工作流
- **数据库层**：SQLite（默认）或 PostgreSQL（生产环境），用于数据持久化
- **队列系统**：基于 Redis 的 BullMQ，用于跨工作进程分发任务
- **凭据保险箱**：AES-256 加密存储 API 密钥和 OAuth 令牌
- **AI 运行时**：基于 LangChain 的智能体节点，支持 OpenAI、Anthropic 和本地大语言模型

### 执行模式

| 模式 | 适用场景 | 吞吐量 |
|------|----------|--------|
| 普通模式 | 开发环境，<1000 次执行/天 | ~23 请求/秒 |
| 队列模式 (Redis) | 生产环境，>1000 次执行/天 | ~162 请求/秒 |
| 队列 + 多工作进程 | 企业级，>10000 次执行/天 | 水平扩展 |

队列模式通过将 Web UI 与工作流执行分离，通过 Redis 将任务分发给专用工作进程，实现 7 倍性能提升。

## 安装与配置

### 前置条件

```bash
# 推荐 Ubuntu 22.04 LTS
# 最低配置: 2 vCPU, 4 GB 内存, 20 GB SSD
# 推荐配置: 4 vCPU, 8 GB 内存, 50 GB SSD

# 安装 Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 安装 Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 基础 Docker Compose（开发环境）

```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=changeme
      - N8N_ENCRYPTION_KEY=your-32-char-encryption-key-here
      - GENERIC_TIMEZONE=UTC
      - TZ=UTC
    volumes:
      - n8n_data:/home/node/.n8n

volumes:
  n8n_data:
```

启动命令：

```bash
docker-compose -f docker-compose.dev.yml up -d
# 访问 http://localhost:5678
```

### 生产环境 Docker Compose（含 PostgreSQL）

```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  postgres:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_USER: n8n
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: n8n
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U n8n"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - n8n_network

  n8n:
    image: n8nio/n8n:latest
    restart: unless-stopped
    ports:
      - "127.0.0.1:5678:5678"
    environment:
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=n8n
      - DB_POSTGRESDB_USER=n8n
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      - N8N_HOST=${N8N_HOST:-automation.yourdomain.com}
      - N8N_PROTOCOL=https
      - WEBHOOK_URL=https://${N8N_HOST}/
      - N8N_METRICS=true
      - EXECUTIONS_MODE=regular
      - GENERIC_TIMEZONE=UTC
    volumes:
      - n8n_data:/home/node/.n8n
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - n8n_network

volumes:
  postgres_data:
  n8n_data:

networks:
  n8n_network:
    driver: bridge
```

环境变量文件 `.env`：

```bash
# .env
POSTGRES_PASSWORD=$(openssl rand -base64 32)
N8N_ENCRYPTION_KEY=$(openssl rand -hex 32)
N8N_HOST=automation.yourdomain.com
```

### 高吞吐队列模式

```yaml
# docker-compose.queue.yml
version: '3.8'

services:
  postgres:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_USER: n8n
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: n8n
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U n8n"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - n8n_network

  redis:
    image: redis:7-alpine
    restart: unless-stopped
    command: redis-server --requirepass ${REDIS_PASSWORD} --appendonly yes
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "-a", "${REDIS_PASSWORD}", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5
    networks:
      - n8n_network

  n8n-main:
    image: n8nio/n8n:latest
    restart: unless-stopped
    ports:
      - "127.0.0.1:5678:5678"
    environment:
      - EXECUTIONS_MODE=queue
      - QUEUE_BULL_REDIS_HOST=redis
      - QUEUE_BULL_REDIS_PORT=6379
      - QUEUE_BULL_REDIS_PASSWORD=${REDIS_PASSWORD}
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_DATABASE=n8n
      - DB_POSTGRESDB_USER=n8n
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      - N8N_HOST=${N8N_HOST}
      - N8N_PROTOCOL=https
      - WEBHOOK_URL=https://${N8N_HOST}/
      - N8N_METRICS=true
    volumes:
      - n8n_data:/home/node/.n8n
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - n8n_network

  n8n-worker:
    image: n8nio/n8n:latest
    restart: unless-stopped
    command: worker --concurrency=10
    environment:
      - EXECUTIONS_MODE=queue
      - QUEUE_BULL_REDIS_HOST=redis
      - QUEUE_BULL_REDIS_PORT=6379
      - QUEUE_BULL_REDIS_PASSWORD=${REDIS_PASSWORD}
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_DATABASE=n8n
      - DB_POSTGRESDB_USER=n8n
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
    deploy:
      replicas: 2
      resources:
        limits:
          cpus: '2'
          memory: 2G
    depends_on:
      - postgres
      - redis
    networks:
      - n8n_network

volumes:
  postgres_data:
  redis_data:
  n8n_data:

networks:
  n8n_network:
    driver: bridge
```

部署命令：

```bash
# 生成密钥
openssl rand -base64 32 > .postgres_password
openssl rand -base64 32 > .redis_password
openssl rand -hex 32 > .encryption_key

# 导出环境变量
export POSTGRES_PASSWORD=$(cat .postgres_password)
export REDIS_PASSWORD=$(cat .redis_password)
export N8N_ENCRYPTION_KEY=$(cat .encryption_key)
export N8N_HOST=automation.yourdomain.com

# 启动
docker-compose -f docker-compose.queue.yml up -d

# 验证
docker-compose ps
docker-compose logs -f n8n-main
```

### Nginx 反向代理与 SSL

```nginx
# /etc/nginx/sites-available/n8n
server {
    listen 80;
    server_name automation.yourdomain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name automation.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/automation.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/automation.yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:5678;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 300;
        proxy_connect_timeout 300;
    }

    location /webhook/ {
        proxy_pass http://127.0.0.1:5678;
        proxy_read_timeout 300;
    }
}
```

启用配置：

```bash
sudo ln -s /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# 获取 SSL 证书
sudo certbot --nginx -d automation.yourdomain.com
```

## 与 Claude Code、OpenAI、Slack、Discord 和 Telegram 集成

### OpenAI 聊天模型节点

```javascript
// n8n 中的 OpenAI Chat Model 配置
{
  "nodes": [
    {
      "parameters": {
        "model": "gpt-4o-mini",
        "options": {
          "temperature": 0.7,
          "maxTokens": 2048
        }
      },
      "id": "openai-chat-model",
      "name": "OpenAI Chat Model",
      "type": "@n8n/n8n-nodes-langchain.lmChatOpenAi",
      "typeVersion": 1,
      "position": [450, 300],
      "credentials": {
        "openAiApi": {
          "id": "cred-openai",
          "name": "OpenAI Account"
        }
      }
    }
  ]
}
```

在 n8n UI 中添加凭据：

```bash
# 导航到 Settings > Credentials > Add Credential
# 选择 "OpenAI API"
# 粘贴从 https://platform.openai.com/api-keys 获取的 API 密钥
```

### Anthropic Claude 聊天模型节点

```javascript
// Anthropic Claude Chat Model 配置
{
  "nodes": [
    {
      "parameters": {
        "model": "claude-3-5-sonnet-20241022",
        "options": {
          "temperature": 0.2,
          "maxTokens": 4096
        }
      },
      "name": "Anthropic Chat Model",
      "type": "@n8n/n8n-nodes-langchain.lmChatAnthropic",
      "credentials": {
        "anthropicApi": {
          "name": "Anthropic API"
        }
      }
    }
  ]
}
```

### Slack 通知工作流

```json
{
  "name": "AI Summary to Slack",
  "nodes": [
    {
      "parameters": {
        "event": "message"
      },
      "name": "Webhook Trigger",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1,
      "position": [250, 300],
      "webhookId": "ai-summary"
    },
    {
      "parameters": {
        "model": "gpt-4o-mini",
        "messages": {
          "message": [
            {
              "role": "user",
              "content": "=Summarize this data: {{ $json.body }}"
            }
          ]
        }
      },
      "name": "OpenAI Summary",
      "type": "@n8n/n8n-nodes-langchain.agent",
      "typeVersion": 1,
      "position": [450, 300]
    },
    {
      "parameters": {
        "channel": "#alerts",
        "text": "=AI Summary: {{ $json.output }}"
      },
      "name": "Slack Message",
      "type": "n8n-nodes-base.slack",
      "typeVersion": 2,
      "position": [650, 300],
      "credentials": {
        "slackApi": {
          "name": "Slack Bot"
        }
      }
    }
  ],
  "connections": {
    "Webhook Trigger": {
      "main": [[{"node": "OpenAI Summary", "type": "main", "index": 0}]]
    },
    "OpenAI Summary": {
      "main": [[{"node": "Slack Message", "type": "main", "index": 0}]]
    }
  }
}
```

### Telegram 机器人 Webhook

```javascript
// Telegram 触发节点配置
{
  "nodes": [
    {
      "parameters": {
        "updates": ["*"],
        "additionalFields": {}
      },
      "name": "Telegram Trigger",
      "type": "n8n-nodes-base.telegramTrigger",
      "typeVersion": 1,
      "position": [250, 300],
      "webhookId": "telegram-bot",
      "credentials": {
        "telegramApi": {
          "name": "Telegram Bot"
        }
      }
    },
    {
      "parameters": {
        "chatId": "={{ $json.message.chat.id }}",
        "text": "={{ $json.message.text }}",
        "additionalOptions": {}
      },
      "name": "Telegram Response",
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1,
      "position": [650, 300]
    }
  ]
}
```

### Discord 机器人集成

```bash
# 1. 在 https://discord.com/developers/applications 创建 Discord 应用
# 2. 创建机器人用户并复制令牌
# 3. 在 n8n 中: Settings > Credentials > Add Credential > Discord Bot API
# 4. 粘贴机器人令牌

# 工作流: Discord 消息触发 -> AI 处理 -> Discord 回复
```

```json
{
  "nodes": [
    {
      "parameters": {
        "events": ["messageCreate"],
        "options": {}
      },
      "name": "Discord Trigger",
      "type": "n8n-nodes-base.discordTrigger",
      "typeVersion": 1,
      "position": [250, 300],
      "credentials": {
        "discordBotApi": {
          "name": "Discord Bot"
        }
      }
    }
  ]
}
```

## 基准测试 / 实际用例

![n8n queue mode](https://docs.n8n.io/_images/hosting/scaling/queue-mode.png)
*n8n 队列模式架构 — Redis 将作业分发到多个工作进程。*

### 性能基准

| 指标 | 普通模式 | 队列模式 | 队列 + 4 工作进程 |
|------|-------------|------------|-------------------|
| 吞吐量 | ~23 请求/秒 | ~162 请求/秒 | ~400+ 请求/秒 |
| 失败率 | 高负载下 2-5% | 0% | 0% |
| 平均延迟 (p50) | 450ms | 120ms | 85ms |
| 平均延迟 (p99) | 3,200ms | 890ms | 340ms |
| 并发工作流 | 1 | 10 | 40 |

*来源: n8n 官方基准测试，队列模式，4 vCPU / 8 GB RAM 配置。*

### 成本对比: n8n 自托管 vs Zapier 云版

| 每月工作负载 | Zapier 费用 | n8n 自托管 | 节省比例 |
|-------------------|-------------|-----------------|-------|
| 1,000 个任务 | $19.99 | ~$12 (VPS) | 40% |
| 10,000 次执行 | $49 | ~$12 (VPS) | 75% |
| 50,000 次执行 | $199 | ~$24 (VPS + AI) | 88% |
| 100,000 次执行 | $399 | ~$24 (VPS + AI) | 94% |
| 无限 | $799+ | ~$12–48 (VPS) | 94%+ |

### 实际用例

**电商订单处理管道**: Shopify 商家每天通过 n8n 处理 500 个订单。工作流通过 PostgreSQL 验证库存，通过 ShipStation API 生成物流标签，通过 SendGrid 发送客户通知，并向 Slack 推送摘要。每个订单执行时间：2.3 秒。每月基础设施成本：$18。

**AI 客户支持智能体**: 一家 SaaS 公司通过 Claude 3.5 Sonnet 对支持工单进行分类和回复草稿生成。高置信度回复自动发送；低置信度转人工处理。每月处理 2,000 张工单，78% 无需人工干预即可解决。API 成本：约 $45/月。

**DevOps 告警聚合**: 工程团队将 PagerDuty、Datadog 和 Sentry 的告警聚合到单一 n8n 工作流中。严重告警触发 Telegram 消息；警告级别告警批量生成每小时 Slack 摘要。响应时间从 15 分钟缩短至 90 秒。

## 高级用法 / 生产环境加固

### 安全检查清单

```bash
# 1. 使用强加密密钥
export N8N_ENCRYPTION_KEY=$(openssl rand -hex 32)

# 2. 启用基础认证（或使用 SSO/OAuth）
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=$(openssl rand -base64 24)

# 3. 仅通过 HTTPS 访问
N8N_PROTOCOL=https
WEBHOOK_URL=https://automation.yourdomain.com/

# 4. 仅绑定到本地主机，通过 Nginx 代理
ports:
  - "127.0.0.1:5678:5678"

# 5. 启用执行数据清理
EXECUTIONS_DATA_PRUNE=true
EXECUTIONS_DATA_MAX_AGE=168  # 7 天

# 6. 设置执行超时
N8N_EXECUTIONS_TIMEOUT=300
N8N_EXECUTIONS_TIMEOUT_MAX=3600

# 7. 在工作进程容器中禁用编辑器
# （工作进程使用 command: worker，不暴露 UI）
```

### 数据库优化

```sql
-- n8n 生产环境 PostgreSQL 优化
ALTER SYSTEM SET shared_buffers = '512MB';
ALTER SYSTEM SET effective_cache_size = '2GB';
ALTER SYSTEM SET random_page_cost = 1.1;
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET wal_buffers = '16MB';
ALTER SYSTEM SET default_statistics_target = 100;

-- 添加索引加速查询
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_execution_entity_workflowid 
  ON execution_entity(workflowid);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_execution_entity_startedat 
  ON execution_entity(startedat);

-- 重载配置
SELECT pg_reload_conf();
```

### 使用 Prometheus 和 Grafana 监控

```yaml
# 添加到 docker-compose.queue.yml
  prometheus:
    image: prom/prometheus:latest
    restart: unless-stopped
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    command:
      - --config.file=/etc/prometheus/prometheus.yml
      - --storage.tsdb.path=/prometheus
    networks:
      - n8n_network
    ports:
      - "127.0.0.1:9090:9090"

  grafana:
    image: grafana/grafana:latest
    restart: unless-stopped
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD:-admin}
    volumes:
      - grafana_data:/var/lib/grafana
    networks:
      - n8n_network
    ports:
      - "127.0.0.1:3000:3000"
```

```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'n8n'
    static_configs:
      - targets: ['n8n-main:5678']
    metrics_path: /metrics
```

### 日志轮转

```bash
# /etc/logrotate.d/n8n
/opt/n8n/logs/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 644 root root
    postrotate
        docker restart n8n-main
    endscript
}
```

### 备份策略

```bash
#!/bin/bash
# backup-n8n.sh - 通过 cron 每日运行

BACKUP_DIR=/opt/backups/n8n
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

# 备份 PostgreSQL
docker exec n8n-postgres pg_dump -U n8n n8n | gzip > $BACKUP_DIR/n8n_db_$DATE.sql.gz

# 备份 n8n 数据卷
docker run --rm -v n8n_n8n_data:/data -v $BACKUP_DIR:/backup alpine tar czf /backup/n8n_data_$DATE.tar.gz -C /data .

# 仅保留最近 7 天
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

# 同步到 S3（可选）
# aws s3 sync $BACKUP_DIR s3://your-backup-bucket/n8n/
```

添加到 crontab：

```bash
# 每天凌晨 2 点运行备份
0 2 * * * /opt/n8n/backup-n8n.sh >> /var/log/n8n-backup.log 2>&1
```

## 与替代品对比

| 特性 | n8n | Dify | Flowise | Make |
|---------|-----|------|---------|------|
| **许可证** | Sustainable Use License | Dify OSL | Apache-2.0 | 专有软件 |
| **GitHub 星标** | 188,782 | 85,000+ | 35,000+ | N/A (闭源) |
| **自托管** | 全功能 | 全功能 | 全功能 | 仅云版 |
| **集成数量** | 400+ 节点 | ~80 原生 + HTTP | ~100 通过 LangChain | 2,000+ 应用 |
| **AI 框架** | LangChain (原生) | 自定义 RAG | LangChain/LlamaIndex | 预构建模块 |
| **可视化编辑器** | 节点画布 | 流程式 | 流程式 | 模块式 |
| **自定义代码** | JS + Python 节点 | 有限 | Python 节点 | 受限 |
| **队列/扩展** | Redis BullMQ | Celery | 基础 | 自动扩展 |
| **托管价格** | $20/月起 | $59/月起 | $35/月起 | $9/月起 |
| **执行模式** | 按执行次数 | 按消息数 | 按预测次数 | 按操作数 |
| **适用场景** | 运维 + AI 工作流 | 对话优先的 RAG | LLM 原型开发 | 商业 SaaS |

**何时选择 n8n 而非替代品：**

- 需要工作流自动化和 AI 能力统一平台
- 数据必须保留在本地（GDPR、HIPAA、FedRAMP 合规）
- 工作流超过 10 步且包含复杂分支逻辑
- 执行成本在大规模下是关键考量
- 团队具备 JavaScript/Python 技能用于自定义节点

## 局限性 / 诚实的评估

**学习曲线存在。** n8n 对非技术用户来说不是 5 分钟就能上手的工具。可视化编辑器需要理解节点连接、数据钉住、表达式语法和凭据管理。预计开发者需要 2-3 天才能达到熟练水平。

**自托管并非零基础设施成本。** 虽然 n8n 没有许可费用，但你需要自行管理操作系统补丁、数据库备份、SSL 证书、监控和扩展。没有 DevOps 能力的团队，选择 n8n 云版 $20/月是更务实的选择。

**原生集成少于 Zapier/Make。** n8n 有 400+ 节点，相比 Zapier 的 7,000+ 和 Make 的 2,000+ 应用。小众 SaaS 工具可能需要构建自定义 HTTP 节点或等待社区贡献。

**AI 功能需要额外的 API 费用。** OpenAI、Anthropic 和其他大语言模型提供商单独计费。每月调用 GPT-4o 1 万次的工作流会增加 $50-200 的 API 费用。

**Fair-code 许可有限制。** Sustainable Use License 禁止与 n8n 的云服务竞争。大多数内部使用场景不受影响，但在转售 n8n 托管服务之前请咨询法务。

**Webhook 可靠性。** 默认模式下的 Webhook 依赖于主进程可用。对于关键的 Webhook 接收，需要队列模式配合专用 Webhook 处理器。

## 常见问题

### n8n 自托管每月成本是多少？

基础设施费用从每月 $5 的 2 GB VPS（适合 <1000 次执行/天）到 $50-100（队列模式部署，每月 10 万+ 次执行）。相比之下 Zapier 专业版 $49/月仅包含 2,000 个任务。自托管的盈亏平衡点通常在每月 3,000+ 次工作流执行时达到。

### n8n 和 Zapier 有什么区别？

n8n 使用按执行次数计费（一次工作流运行 = 一次执行，与步骤数无关），而 Zapier 按任务计费（工作流中的每个步骤都算作一个任务）。一个包含 10 步的工作流运行 1,000 次，在 n8n 上消耗 1,000 次执行，在 Zapier 上消耗 10,000 个任务。n8n 还提供自托管、自定义代码节点和 AI 智能体功能，这些是 Zapier 所不具备的。

### n8n 可以在没有互联网的环境中运行吗？

可以。部署在内网的 n8n 实例可以使用本地数据库、内部 API 和通过 Ollama 运行的本地大语言模型来执行工作流。但云端集成（OpenAI、Slack 等）需要外网访问。对于完全隔离的环境，请仅使用本地模型和本地服务。

### 如何将 n8n 更新到最新版本？

```bash
# 拉取最新镜像
docker-compose pull

# 重启（队列模式零停机）
docker-compose up -d

# 验证版本
docker-compose exec n8n-main n8n --version
```

主要版本升级前务必备份数据库。在 https://github.com/n8n-io/n8n/blob/master/CHANGELOG.md 查看破坏性变更。

### n8n 适合企业生产环境吗？

适合，但需要启用队列模式。n8n 支持 LDAP/SAML 单点登录、基于角色的访问控制、审计日志、外部密钥管理器和 SIEM 日志流。队列模式配合 Redis 和多工作进程可实现每秒 400+ 次执行。西门子、Mozilla 和超过 200 家财富 500 强企业在生产中使用 n8n。

### 如何排查故障工作流？

在 n8n UI 中查看执行日志（Settings > Executions）。使用 `N8N_LOG_LEVEL=debug` 启用调试日志。对于 Webhook 问题，验证 `WEBHOOK_URL` 是否与公网域名匹配。对于数据库错误，检查 PostgreSQL 连接池限制。常用排查命令：`docker-compose logs -f n8n-main | grep ERROR`。

### n8n 支持哪些数据库？

n8n 官方支持 SQLite（默认，仅开发环境）、PostgreSQL（推荐生产环境）和 MySQL。SQLite 不适合生产环境，因为它不支持多工作进程的并发写入。PostgreSQL 14+ 配合连接池（PgBouncer）是生产环境的标准选择。

## 结论

n8n 以远低于商业平台的成本提供 AI 能力加持的工作流自动化。自托管路线需要预先掌握 Docker 和 Linux 知识，但回报丰厚：无限执行次数、完全数据控制和原生 LangChain 集成用于 AI 智能体工作流。从基础 Docker Compose 配置开始，在吞吐需求增加时迁移到队列模式，并实施本指南中的安全和监控配置以加固生产环境。

**你的下一步：**
1. 在 VPS 上部署 Docker Compose 配置（推荐 [DigitalOcean](https://www.digitalocean.com/pricing)）
2. 配置你的第一个 OpenAI 驱动的工作流
3. 加入 n8n 社区 [community.n8n.io](https://community.n8n.io)
4. 关注我们的 [Telegram 群组](https://t.me/dibi8opensource) 获取自动化技巧和更新

*本文包含联盟营销链接。如果你通过这些链接购买产品，我们可能获得佣金——对你不额外收费。*



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- n8n 官方文档: https://docs.n8n.io/
- n8n GitHub 仓库: https://github.com/n8n-io/n8n
- n8n AI 智能体节点参考: https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.agent/
- n8n Docker 部署指南: https://docs.n8n.io/hosting/installation/docker/
- n8n 队列模式文档: https://docs.n8n.io/hosting/scaling/queue-mode/
- n8n 环境变量: https://docs.n8n.io/hosting/configuration/environment-variables/
- DigitalOcean n8n 教程: https://www.digitalocean.com/community/tutorials/how-to-setup-n8n
- n8n 定价: https://n8n.io/pricing/
- n8n 社区论坛: https://community.n8n.io
- n8n 安全最佳实践: https://docs.n8n.io/hosting/security/
