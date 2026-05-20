---
title: 'n8n AI Workflow Automation: Self-Hosted Setup with 188K+ Stars — Save 70% vs Zapier in 2026'
description: 'n8n (fair-code) is a workflow automation platform with native AI capabilities and 400+ integrations. Compatible with Claude Code, OpenAI, Anthropic, Slack, Discord, Telegram. Covers Docker setup, AI node configuration, webhook deployment, and production hardening.'
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
tags: ['n8n', 'workflow-automation', 'self-hosted', 'ai-agents', 'docker', 'langchain', 'open-source', 'low-code']
aliases:
- /posts/n8n/
- /resources/dev-utils/n8n-ai-workflow-automation-self-hosted-2026/
---

{{</* resource-info */>}}

![n8n logo](https://raw.githubusercontent.com/n8n-io/n8n/master/assets/n8n-logo.png)
*The n8n fair-code workflow automation platform — 188K+ GitHub stars, 400+ integrations.*

## Introduction

Automation platforms have become the connective tissue of modern SaaS stacks, but the bill scales faster than the workflows. A mid-size e-commerce company running 8-step order processing workflows 10,000 times per month on Zapier consumes 80,000 tasks — requiring an enterprise plan at $400+/month. The same workload on self-hosted n8n runs on a $12 VPS with zero execution limits. That cost reality has driven n8n to 188,782 GitHub stars, making it one of the most starred workflow automation projects in existence. This guide walks through a production-grade self-hosted n8n deployment with AI capabilities — from Docker Compose setup to queue-mode scaling — with real configs you can deploy today.

## What Is n8n?

n8n (pronounced "n-eight-n") is a fair-code workflow automation platform that combines a visual node-based editor with native AI capabilities built on LangChain. It connects 400+ applications and services through a drag-and-drop interface while allowing custom JavaScript and Python code nodes for advanced logic. Unlike pure no-code tools, n8n targets technical teams who need data sovereignty, unlimited executions, and the ability to self-host without vendor lock-in.

## How n8n Works

### Architecture Overview

![n8n architecture](https://docs.n8n.io/_images/common-workflow-diagram.png)
*n8n workflow architecture — triggers connect to actions via a node-based execution engine.*

n8n uses a node-based execution engine where workflows are directed graphs. Each node represents an action — trigger, data transformation, API call, AI model inference — and edges define data flow. The execution engine runs on Node.js and stores workflow definitions, credentials, and execution history in a relational database.

**Core components:**

- **Workflow Engine**: Node.js-based executor that processes workflows sequentially or in parallel
- **Web UI**: Vue.js-based visual editor for building and debugging workflows
- **Database Layer**: SQLite (default) or PostgreSQL (production) for persistence
- **Queue System**: Redis-backed BullMQ for distributing work across worker processes
- **Credential Vault**: AES-256 encrypted storage for API keys and OAuth tokens
- **AI Runtime**: LangChain-powered agent nodes with support for OpenAI, Anthropic, and local LLMs

### Execution Modes

| Mode | Use Case | Throughput |
|------|----------|------------|
| Regular | Development, <1,000 execs/day | ~23 req/s |
| Queue (Redis) | Production, >1,000 execs/day | ~162 req/s |
| Queue + Workers | Enterprise, >10,000 execs/day | Horizontal scale |

The queue mode delivers a 7x performance improvement by separating the web UI from workflow execution, distributing tasks across dedicated worker processes via Redis.

## Installation & Setup

### Prerequisites

```bash
# Ubuntu 22.04 LTS recommended
# Minimum: 2 vCPU, 4 GB RAM, 20 GB SSD
# Recommended: 4 vCPU, 8 GB RAM, 50 GB SSD

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Basic Docker Compose (Development)

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

Start with:

```bash
docker-compose -f docker-compose.dev.yml up -d
# Access at http://localhost:5678
```

### Production Docker Compose with PostgreSQL

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

Environment variables in `.env`:

```bash
# .env
POSTGRES_PASSWORD=$(openssl rand -base64 32)
N8N_ENCRYPTION_KEY=$(openssl rand -hex 32)
N8N_HOST=automation.yourdomain.com
```

### Queue Mode for High Throughput

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

Deploy:

```bash
# Generate secrets
openssl rand -base64 32 > .postgres_password
openssl rand -base64 32 > .redis_password
openssl rand -hex 32 > .encryption_key

# Export environment
export POSTGRES_PASSWORD=$(cat .postgres_password)
export REDIS_PASSWORD=$(cat .redis_password)
export N8N_ENCRYPTION_KEY=$(cat .encryption_key)
export N8N_HOST=automation.yourdomain.com

# Launch
docker-compose -f docker-compose.queue.yml up -d

# Verify
docker-compose ps
docker-compose logs -f n8n-main
```

### Nginx Reverse Proxy with SSL

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

Enable:

```bash
sudo ln -s /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Obtain SSL certificate
sudo certbot --nginx -d automation.yourdomain.com
```

## Integration with Claude Code, OpenAI, Slack, Discord, and Telegram

### OpenAI Chat Model Node

```javascript
// OpenAI Chat Model configuration in n8n
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

Add the credential in n8n UI:

```bash
# Navigate to Settings > Credentials > Add Credential
# Select "OpenAI API"
# Paste your API key from https://platform.openai.com/api-keys
```

### Anthropic Claude Chat Model Node

```javascript
// Anthropic Claude Chat Model configuration
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

### Slack Notification Workflow

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

### Telegram Bot Webhook

```javascript
// Telegram trigger node configuration
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

### Discord Bot Integration

```bash
# 1. Create a Discord application at https://discord.com/developers/applications
# 2. Create a bot user and copy the token
# 3. In n8n: Settings > Credentials > Add Credential > Discord Bot API
# 4. Paste the bot token

# Workflow: Discord message trigger -> AI processing -> Discord response
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

## Benchmarks / Real-World Use Cases

![n8n queue mode](https://docs.n8n.io/_images/hosting/scaling/queue-mode.png)
*n8n queue mode architecture — Redis distributes jobs across worker processes.*

### Performance Benchmarks

| Metric | Regular Mode | Queue Mode | Queue + 4 Workers |
|--------|-------------|------------|-------------------|
| Throughput | ~23 req/s | ~162 req/s | ~400+ req/s |
| Failure Rate | 2-5% under load | 0% | 0% |
| Avg Latency (p50) | 450ms | 120ms | 85ms |
| Avg Latency (p99) | 3,200ms | 890ms | 340ms |
| Concurrent Workflows | 1 | 10 | 40 |

*Source: Official n8n benchmarks, queue mode with Redis on 4 vCPU / 8 GB RAM.*

### Cost Comparison: n8n Self-Hosted vs Zapier Cloud

| Monthly Workloads | Zapier Cost | n8n Self-Hosted | Savings |
|-------------------|-------------|-----------------|---------|
| 1,000 tasks | $19.99 | ~$12 (VPS) | 40% |
| 10,000 executions | $49 | ~$12 (VPS) | 75% |
| 50,000 executions | $199 | ~$24 (VPS + AI) | 88% |
| 100,000 executions | $399 | ~$24 (VPS + AI) | 94% |
| Unlimited | $799+ | ~$12–48 (VPS) | 94%+ |

### Real-World Use Cases

**E-commerce Order Pipeline**: A Shopify merchant processes 500 orders/day through n8n. The workflow validates inventory via PostgreSQL, generates shipping labels through ShipStation API, sends customer notifications via SendGrid, and posts summaries to Slack. Total execution time: 2.3 seconds per order. Monthly infrastructure cost: $18.

**AI Customer Support Agent**: A SaaS company routes support tickets through Claude 3.5 Sonnet for classification and response drafting. High-confidence responses auto-send; low-confidence route to human agents. Handles 2,000 tickets/month with 78% resolution rate without human intervention. API cost: ~$45/month.

**DevOps Alert Aggregation**: Engineering teams aggregate alerts from PagerDuty, Datadog, and Sentry into a single n8n workflow. Critical alerts trigger Telegram messages; warnings batch into hourly Slack digests. Response time reduced from 15 minutes to 90 seconds.

## Advanced Usage / Production Hardening

### Security Checklist

```bash
# 1. Use strong encryption key
export N8N_ENCRYPTION_KEY=$(openssl rand -hex 32)

# 2. Enable basic auth (or use SSO/OAuth)
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=$(openssl rand -base64 24)

# 3. Run behind HTTPS only
N8N_PROTOCOL=https
WEBHOOK_URL=https://automation.yourdomain.com/

# 4. Bind to localhost only, proxy through Nginx
ports:
  - "127.0.0.1:5678:5678"

# 5. Enable execution data pruning
EXECUTIONS_DATA_PRUNE=true
EXECUTIONS_DATA_MAX_AGE=168  # 7 days

# 6. Set execution timeout
N8N_EXECUTIONS_TIMEOUT=300
N8N_EXECUTIONS_TIMEOUT_MAX=3600

# 7. Disable editor in worker containers
# (Workers use command: worker, no UI exposed)
```

### Database Optimization

```sql
-- PostgreSQL tuning for n8n production
ALTER SYSTEM SET shared_buffers = '512MB';
ALTER SYSTEM SET effective_cache_size = '2GB';
ALTER SYSTEM SET random_page_cost = 1.1;
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET wal_buffers = '16MB';
ALTER SYSTEM SET default_statistics_target = 100;

-- Add indexes for faster queries
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_execution_entity_workflowid 
  ON execution_entity(workflowid);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_execution_entity_startedat 
  ON execution_entity(startedat);

-- Reload configuration
SELECT pg_reload_conf();
```

### Monitoring with Prometheus and Grafana

```yaml
# Add to docker-compose.queue.yml
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

### Log Rotation

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

### Backup Strategy

```bash
#!/bin/bash
# backup-n8n.sh - Run daily via cron

BACKUP_DIR=/opt/backups/n8n
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

# Backup PostgreSQL
docker exec n8n-postgres pg_dump -U n8n n8n | gzip > $BACKUP_DIR/n8n_db_$DATE.sql.gz

# Backup n8n data volume
docker run --rm -v n8n_n8n_data:/data -v $BACKUP_DIR:/backup alpine tar czf /backup/n8n_data_$DATE.tar.gz -C /data .

# Keep only last 7 days
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

# Sync to S3 (optional)
# aws s3 sync $BACKUP_DIR s3://your-backup-bucket/n8n/
```

Add to crontab:

```bash
# Run backup daily at 2 AM
0 2 * * * /opt/n8n/backup-n8n.sh >> /var/log/n8n-backup.log 2>&1
```

## Comparison with Alternatives

| Feature | n8n | Dify | Flowise | Make |
|---------|-----|------|---------|------|
| **License** | Sustainable Use License | Dify OSL | Apache-2.0 | Proprietary |
| **GitHub Stars** | 188,782 | 85,000+ | 35,000+ | N/A (closed) |
| **Self-Hosted** | Full-featured | Full-featured | Full-featured | Cloud only |
| **Integrations** | 400+ nodes | ~80 native + HTTP | ~100 via LangChain | 2,000+ apps |
| **AI Framework** | LangChain (native) | Custom RAG | LangChain/LlamaIndex | Pre-built modules |
| **Visual Editor** | Node-based canvas | Flow-based | Flow-based | Module-based |
| **Custom Code** | JS + Python nodes | Limited | Python nodes | Restricted |
| **Queue/Scaling** | Redis BullMQ | Celery | Basic | Auto-scaled |
| **Pricing (hosted)** | From $20/mo | From $59/mo | From $35/mo | From $9/mo |
| **Execution Model** | Per-execution | Per-message | Per-prediction | Per-operation |
| **Best For** | Ops + AI workflows | Chat-first RAG apps | LLM prototyping | Business SaaS |

**When to choose n8n over alternatives:**

- You need workflow automation AND AI capabilities in one platform
- Data must stay on-premises (GDPR, HIPAA, FedRAMP)
- Workflows exceed 10 steps with complex branching logic
- Cost per execution matters at scale
- Your team has JavaScript/Python skills for custom nodes

## Limitations / Honest Assessment

**Learning curve exists.** n8n is not a 5-minute setup for non-technical users. The visual editor requires understanding node connections, data pinning, expression syntax, and credential management. Budget 2-3 days for a developer to become productive.

**Self-hosting is not free infrastructure.** While n8n has no license cost, you manage OS patching, database backups, SSL certificates, monitoring, and scaling. For teams without DevOps capacity, n8n Cloud at $20/month is the pragmatic choice.

**Fewer native integrations than Zapier/Make.** n8n has 400+ nodes versus Zapier's 7,000+ and Make's 2,000+. Niche SaaS tools may require building custom HTTP nodes or community contributions.

**AI features require separate API costs.** OpenAI, Anthropic, and other LLM providers bill separately. A workflow calling GPT-4o 10,000 times/month adds $50-200 in API fees on top of infrastructure.

**Fair-code license has restrictions.** The Sustainable Use License prohibits competing with n8n's cloud offering. For most internal use cases this is irrelevant, but consult legal before reselling n8n-hosted services.

**Webhook reliability.** Webhooks in default mode depend on the main process being available. For mission-critical webhook reception, queue mode with dedicated webhook processors is required.

## Frequently Asked Questions

### How much does n8n self-hosted cost per month?

Infrastructure costs range from $5/month on a 2 GB VPS (suitable for <1,000 executions/day) to $50-100/month for queue-mode deployments handling 100,000+ executions. Compare this to Zapier's Professional plan at $49/month for only 2,000 tasks. The break-even point for self-hosting typically occurs at 3,000+ monthly workflow executions.

### What is the difference between n8n and Zapier?

n8n uses a per-execution pricing model (one workflow run = one execution regardless of step count), while Zapier charges per-task (each step in a workflow counts as one task). A 10-step workflow running 1,000 times costs 1,000 executions on n8n versus 10,000 tasks on Zapier. n8n also offers self-hosting, custom code nodes, and AI agent capabilities that Zapier does not.

### Can n8n run without internet access?

Yes. A self-hosted n8n instance on your internal network can run workflows using local databases, internal APIs, and self-hosted LLMs via Ollama. However, cloud-based integrations (OpenAI, Slack, etc.) require outbound internet access. For fully air-gapped environments, use local models and on-premises services exclusively.

### How do I update n8n to the latest version?

```bash
# Pull latest image
docker-compose pull

# Restart with zero-downtime (queue mode)
docker-compose up -d

# Verify version
docker-compose exec n8n-main n8n --version
```

Always back up your database before major version upgrades. Review the changelog at https://github.com/n8n-io/n8n/blob/master/CHANGELOG.md for breaking changes.

### Is n8n suitable for enterprise production use?

Yes, with queue mode enabled. n8n supports LDAP/SAML SSO, role-based access control, audit logging, external secrets managers, and log streaming to SIEM tools. Queue mode with Redis and multiple workers achieves 400+ executions/second. Organizations like Siemens, Mozilla, and over 200 Fortune 500 companies use n8n in production.

### How do I troubleshoot failing workflows?

Check execution logs in the n8n UI (Settings > Executions). Enable debug logging with `N8N_LOG_LEVEL=debug`. For webhook issues, verify `WEBHOOK_URL` matches your public domain. For database errors, check PostgreSQL connection pool limits. Common fix: `docker-compose logs -f n8n-main | grep ERROR`.

### What databases does n8n support?

n8n officially supports SQLite (default, development only), PostgreSQL (recommended for production), and MySQL. SQLite is not suitable for production because it does not support concurrent writes from multiple workers. PostgreSQL 14+ with connection pooling (PgBouncer) is the production standard.

## Conclusion

n8n delivers workflow automation with AI capabilities at a fraction of commercial platform costs. The self-hosted route requires upfront Docker and Linux knowledge, but the payoff is substantial: unlimited executions, complete data control, and native LangChain integration for AI agent workflows. Start with the basic Docker Compose setup, migrate to queue mode when throughput demands increase, and implement the security and monitoring configurations outlined in this guide for production hardening.

**Your next steps:**
1. Deploy the Docker Compose setup on a VPS ([DigitalOcean](https://www.digitalocean.com/pricing))
2. Configure your first OpenAI-powered workflow
3. Join the n8n community at [community.n8n.io](https://community.n8n.io)
4. Follow our [Telegram group](https://t.me/dibi8opensource) for automation tips and updates

*This article contains affiliate links. We may earn a commission if you purchase through these links — at no extra cost to you.*



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- n8n Official Documentation: https://docs.n8n.io/
- n8n GitHub Repository: https://github.com/n8n-io/n8n
- n8n AI Agent Node Reference: https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.agent/
- n8n Docker Setup Guide: https://docs.n8n.io/hosting/installation/docker/
- n8n Queue Mode Documentation: https://docs.n8n.io/hosting/scaling/queue-mode/
- n8n Environment Variables: https://docs.n8n.io/hosting/configuration/environment-variables/
- DigitalOcean n8n Tutorial: https://www.digitalocean.com/community/tutorials/how-to-setup-n8n
- n8n Pricing: https://n8n.io/pricing/
- n8n Community Forum: https://community.n8n.io
- n8n Security Best Practices: https://docs.n8n.io/hosting/security/
