---
title: 'n8n AI 워크플로 자동화: 18.8만 Star 자체 호스팅 설정 — Zapier 대비 70% 절약'
description: 'n8n(fair-code)은 네이티브 AI 기능과 400+ 통합을 갖춘 워크플로 자동화 플랫폼이다. Claude Code, OpenAI, Anthropic, Slack, Discord, Telegram과 호환. Docker 설정, AI 노드 구성, Webhook 배포, 프로덕션 강화를 다룬다.'
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
tags: ['n8n', '워크플로-자동화', '자체-호스팅', 'AI-에이전트', 'Docker', 'LangChain', '오픈소스', '로우코드']
aliases:
- /kr/posts/n8n/
- /kr/resources/dev-utils/n8n-ai-workflow-automation-self-hosted-2026/
---

{{</* resource-info */>}}

![n8n logo](https://raw.githubusercontent.com/n8n-io/n8n/master/assets/n8n-logo.png)
*n8n fair-code 워크플로 자동화 플랫폼 — 188K+ GitHub 스타, 400+ 통합.*

## 소개

자동화 플랫폼은 현대 SaaS 스택의 연결 조직이 되었지만, 비용은 워크플로보다 빠르게 증가한다. 중견 이커머스 기업이 Zapier에서 월 1만 회의 8단계 주문 처리 워크플로를 실행하면 8만 개의 태스크를 소모하여 엔터프라이즈 플랜이 필요하고 월 $400 이상이 든다. 동일한 워크로드를 자체 호스팅 n8n에서 실행하면 $12짜리 VPS에서 제로 실행 한도로 동작한다. 이러한 비용 현실 덕분에 n8n은 GitHub에서 188,782개의 Star를 획득하여 가장 인기 있는 워크플로 자동화 프로젝트 중 하나가 되었다. 이 가이드는 Docker Compose 설정부터 큐 모드 스케일링까지 프로덕션급 자체 호스팅 n8n 배포와 AI 기능을 단계별로 설명하며, 오늘 바로 배포할 수 있는 실제 구성 파일을 제공한다.

## n8n이란?

n8n(발음은 "n-eight-n")은 LangChain 기반으로 구축된 시각적 노드 기반 편집기와 네이티브 AI 기능을 결합한 fair-code 워크플로 자동화 플랫폼이다. 드래그 앤 드롭 인터페이스로 400개 이상의 애플리케이션과 서비스를 연결하고, 고급 로직을 위한 커스텀 JavaScript 및 Python 코드 노드를 지원한다. 순수 노코드 도구와 달리 n8n은 데이터 주권, 무제한 실행, 벤더 락인 없이 자체 호스팅이 필요한 기술 팀을 대상으로 한다.

## n8n 작동 방식

### 아키텍처 개요

![n8n architecture](https://docs.n8n.io/_images/common-workflow-diagram.png)
*n8n 워크플로 아키텍처 — 트리거가 노드 실행 엔진을 통해 액션에 연결됩니다.*

n8n은 노드 기반 실행 엔진을 사용하며, 워크플로는 방향성 그래프로 표현된다. 각 노드는 액션을 나타내고 — 트리거, 데이터 변환, API 호출, AI 모델 추론 — 엣지는 데이터 흐름을 정의한다. 실행 엔진은 Node.js 기반이며 워크플로 정의, 자격 증명, 실행 이력을 관계형 데이터베이스에 저장한다.

**핵심 컴포넌트:**

- **워크플로 엔진**: Node.js 기반 실행기, 순차 또는 병렬 워크플로 처리
- **Web UI**: Vue.js 기반 시각적 편집기, 워크플로 구축 및 디버깅
- **데이터베이스 계층**: SQLite(기본) 또는 PostgreSQL(프로덕션), 영속성 저장
- **큐 시스템**: Redis 기반 BullMQ, 워커 프로세스 간 작업 분배
- **자격 증명 금고**: AES-256 암호화 저장, API 키 및 OAuth 토큰 보관
- **AI 런타임**: LangChain 기반 에이전트 노드, OpenAI, Anthropic, 로컬 LLM 지원

### 실행 모드

| 모드 | 사용 사례 | 처리량 |
|------|----------|--------|
| 일반 | 개발, <1,000회 실행/일 | ~23 req/s |
| 큐 (Redis) | 프로덕션, >1,000회 실행/일 | ~162 req/s |
| 큐 + 워커 | 엔터프라이즈, >10,000회 실행/일 | 수평 확장 |

큐 모드는 Web UI와 워크플로 실행을 분리하고, Redis를 통해 전용 워커 프로세스에 작업을 분배하여 7배 성능 향상을 제공한다.

## 설치 및 설정

### 사전 요구사항

```bash
# Ubuntu 22.04 LTS 권장
# 최소: 2 vCPU, 4 GB RAM, 20 GB SSD
# 권장: 4 vCPU, 8 GB RAM, 50 GB SSD

# Docker 설치
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Docker Compose 설치
sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 기본 Docker Compose (개발)

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

시작:

```bash
docker-compose -f docker-compose.dev.yml up -d
# http://localhost:5678 접속
```

### 프로덕션 Docker Compose (PostgreSQL 포함)

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

`.env` 파일의 환경 변수:

```bash
# .env
POSTGRES_PASSWORD=$(openssl rand -base64 32)
N8N_ENCRYPTION_KEY=$(openssl rand -hex 32)
N8N_HOST=automation.yourdomain.com
```

### 고처리량 큐 모드

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

배포:

```bash
# 비밀 키 생성
openssl rand -base64 32 > .postgres_password
openssl rand -base64 32 > .redis_password
openssl rand -hex 32 > .encryption_key

# 환경 변수 낳출
export POSTGRES_PASSWORD=$(cat .postgres_password)
export REDIS_PASSWORD=$(cat .redis_password)
export N8N_ENCRYPTION_KEY=$(cat .encryption_key)
export N8N_HOST=automation.yourdomain.com

# 실행
docker-compose -f docker-compose.queue.yml up -d

# 확인
docker-compose ps
docker-compose logs -f n8n-main
```

### Nginx 리버스 프록시 (SSL)

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

활성화:

```bash
sudo ln -s /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# SSL 인증서 획득
sudo certbot --nginx -d automation.yourdomain.com
```

## Claude Code, OpenAI, Slack, Discord, Telegram 연동

### OpenAI 채팅 모델 노드

```javascript
// n8n의 OpenAI Chat Model 구성
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

c8n UI에서 자격 증명 추가:

```bash
# Settings > Credentials > Add Credential 이동
# "OpenAI API" 선택
# https://platform.openai.com/api-keys 에서 복사한 API 키 붙여넣기
```

### Anthropic Claude 채팅 모델 노드

```javascript
// Anthropic Claude Chat Model 구성
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

### Slack 알림 워크플로

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

### Telegram 봇 Webhook

```javascript
// Telegram 트리거 노드 구성
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

### Discord 봇 연동

```bash
# 1. https://discord.com/developers/applications 에서 Discord 애플리케이션 생성
# 2. 봇 사용자 생성 및 토큰 복사
# 3. n8n에서: Settings > Credentials > Add Credential > Discord Bot API
# 4. 봇 토큰 붙여넣기

# 워크플로: Discord 메시지 트리거 -> AI 처리 -> Discord 응답
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

## 벤치마크 / 실제 사용 사례

![n8n queue mode](https://docs.n8n.io/_images/hosting/scaling/queue-mode.png)
*n8n 큐 모드 아키텍처 — Redis가 작업을 여러 워커 프로세스에 분배합니다.*

### 성능 벤치마크

| 메트릭 | 일반 모드 | 큐 모드 | 큐 + 4 워커 |
|--------|-------------|------------|-------------------|
| 처리량 | ~23 req/s | ~162 req/s | ~400+ req/s |
| 실패율 | 고부하 시 2-5% | 0% | 0% |
| 평균 지연 (p50) | 450ms | 120ms | 85ms |
| 평균 지연 (p99) | 3,200ms | 890ms | 340ms |
| 동시 워크플로 | 1 | 10 | 40 |

*출처: n8n 공식 벤치마크, 4 vCPU / 8 GB RAM 구성의 큐 모드.*

### 비용 비교: n8n 자체 호스팅 vs Zapier 클라우드

| 월간 워크로드 | Zapier 비용 | n8n 자체 호스팅 | 절약 비율 |
|-------------------|-------------|-----------------|-------|
| 1,000 태스크 | $19.99 | ~$12 (VPS) | 40% |
| 10,000 실행 | $49 | ~$12 (VPS) | 75% |
| 50,000 실행 | $199 | ~$24 (VPS + AI) | 88% |
| 100,000 실행 | $399 | ~$24 (VPS + AI) | 94% |
| 무제한 | $799+ | ~$12–48 (VPS) | 94%+ |

### 실제 사용 사례

**이커머스 주문 파이프라인**: Shopify 판매자가 n8n으로 하루 500개 주문을 처리한다. 워크플로는 PostgreSQL로 재고를 검증하고, ShipStation API로 배송 라벨을 생성하고, SendGrid로 고객 알림을 발송하고, Slack에 요약을 게시한다. 주문당 실행 시간: 2.3초. 월간 인프라 비용: $18.

**AI 고객 지원 에이전트**: SaaS 기업이 지원 티켓을 Claude 3.5 Sonnet으로 분류하고 답변 초안을 작성한다. 높은 신뢰도의 답변은 자동 발송되고, 낮은 신뢰도는 인간 에이전트로 라우팅된다. 월 2,000장 티켓 중 78%를 인간 개입 없이 해결한다. API 비용: 약 $45/월.

**DevOps 알림 집계**: 엔지니어링 팀이 PagerDuty, Datadog, Sentry의 알림을 단일 n8n 워크플로로 집계한다. 심각한 알림은 Telegram 메시지를 트리거하고, 경고는 시간별 Slack 요약으로 일괄 처리된다. 응답 시간이 15분에서 90초로 단축되었다.

## 고급 사용법 / 프로덕션 강화

### 보안 체크리스트

```bash
# 1. 강력한 암호화 키 사용
export N8N_ENCRYPTION_KEY=$(openssl rand -hex 32)

# 2. 기본 인증 활성화 (또는 SSO/OAuth 사용)
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=$(openssl rand -base64 24)

# 3. HTTPS 전용
N8N_PROTOCOL=https
WEBHOOK_URL=https://automation.yourdomain.com/

# 4. localhost에만 바인딩, Nginx를 통해 프록시
ports:
  - "127.0.0.1:5678:5678"

# 5. 실행 데이터 정리 활성화
EXECUTIONS_DATA_PRUNE=true
EXECUTIONS_DATA_MAX_AGE=168  # 7일

# 6. 실행 타임아웃 설정
N8N_EXECUTIONS_TIMEOUT=300
N8N_EXECUTIONS_TIMEOUT_MAX=3600

# 7. 워커 컨테이너에서 편집기 비활성화
# (워커는 command: worker 사용, UI 노출 없음)
```

### 데이터베이스 최적화

```sql
-- 프로덕션용 PostgreSQL 튜닝
ALTER SYSTEM SET shared_buffers = '512MB';
ALTER SYSTEM SET effective_cache_size = '2GB';
ALTER SYSTEM SET random_page_cost = 1.1;
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET wal_buffers = '16MB';
ALTER SYSTEM SET default_statistics_target = 100;

-- 쿼리 속도 향상을 위한 인덱스
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_execution_entity_workflowid 
  ON execution_entity(workflowid);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_execution_entity_startedat 
  ON execution_entity(startedat);

-- 설정 다시 로드
SELECT pg_reload_conf();
```

### Prometheus 및 Grafana 모니터링

```yaml
# docker-compose.queue.yml에 추가
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

### 로그 로테이션

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

### 백업 전략

```bash
#!/bin/bash
# backup-n8n.sh - cron을 통해 매일 실행

BACKUP_DIR=/opt/backups/n8n
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

# PostgreSQL 백업
docker exec n8n-postgres pg_dump -U n8n n8n | gzip > $BACKUP_DIR/n8n_db_$DATE.sql.gz

# n8n 데이터 볼륨 백업
docker run --rm -v n8n_n8n_data:/data -v $BACKUP_DIR:/backup alpine tar czf /backup/n8n_data_$DATE.tar.gz -C /data .

# 최근 7일만 유지
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

# S3 동기화 (선택)
# aws s3 sync $BACKUP_DIR s3://your-backup-bucket/n8n/
```

crontab 추가:

```bash
# 매일 오전 2시 백업 실행
0 2 * * * /opt/n8n/backup-n8n.sh >> /var/log/n8n-backup.log 2>&1
```

## 대안과의 비교

| 기능 | n8n | Dify | Flowise | Make |
|---------|-----|------|---------|------|
| **라이선스** | Sustainable Use License | Dify OSL | Apache-2.0 | 독점 소프트웨어 |
| **GitHub Star** | 188,782 | 85,000+ | 35,000+ | N/A (비공개) |
| **자체 호스팅** | 전체 기능 | 전체 기능 | 전체 기능 | 클라우드 전용 |
| **통합 수** | 400+ 노드 | ~80 네이티브 + HTTP | ~100 LangChain | 2,000+ 앱 |
| **AI 프레임워크** | LangChain (네이티브) | 커스텀 RAG | LangChain/LlamaIndex | 사전 구축 모듈 |
| **시각적 편집기** | 노드 기반 캔버스 | 플로우 기반 | 플로우 기반 | 모듈 기반 |
| **커스텀 코드** | JS + Python 노드 | 제한적 | Python 노드 | 제한적 |
| **큐/확장** | Redis BullMQ | Celery | 기본 | 자동 확장 |
| **호스팅 가격** | $20/월부터 | $59/월부터 | $35/월부터 | $9/월부터 |
| **실행 모델** | 실행당 | 메시지당 | 예측당 | 작업당 |
| **적합한 용도** | 운영 + AI 워크플로 | 대화형 RAG 앱 | LLM 프로토타이핑 | 비즈니스 SaaS |

**대안 대신 n8n을 선택해야 할 때:**

- 워크플로 자동화와 AI 기능을 하나의 플랫폼에서 모두 필요할 때
- 데이터가 온프레미스에 유지되어야 할 때 (GDPR, HIPAA, FedRAMP)
- 워크플로가 10단계 이상이고 복잡한 분기 로직이 포함될 때
- 대규모에서 실행 비용이 중요 고려사항일 때
- 팀에 커스텀 노드용 JavaScript/Python 기술이 있을 때

## 한계 / 정직한 평가

**학습 곡선이 존재한다.** n8n은 비기술 사용자에게 5분이면 설정되는 도구가 아니다. 시각적 편집기는 노드 연결, 데이터 고정, 표현식 구문, 자격 증명 관리를 이해해야 한다. 개발자가 생산성을 발휘하기까지 2-3일을 예상하라.

**자체 호스팅은 물리적 인프라 비용이 들지 않는다는 의미가 아니다.** n8n은 라이선스 비용이 없지만, OS 패치, 데이터베이스 백업, SSL 인증서, 모니터링, 확장을 직접 관리해야 한다. DevOps 역량이 없는 팀에게는 n8n 클라우드 $20/월이 실용적인 선택이다.

**Zapier/Make보다 네이티브 통합이 적다.** n8n은 400+ 노드를 가지고 있는 반면, Zapier는 7,000+, Make는 2,000+ 앱을 지원한다. 틈새 SaaS 도구는 커스텀 HTTP 노드나 커뮤니티 기여가 필요할 수 있다.

**AI 기능은 별도의 API 비용이 필요하다.** OpenAI, Anthropic 및 기타 LLM 제공업체는 별도로 과금한다. GPT-4o를 월 1만 회 호출하는 워크플로는 인프라 비용 외에 API 비용으로 $50-200을 추가한다.

**Fair-code 라이선스에 제한이 있다.** Sustainable Use License는 n8n의 클라우드 서비스와 경쟁하는 것을 금지한다. 대부분의 내 사용 사례에는 영향이 없지만, n8n 호스팅 서비스를 재판매하기 전에 법무팀에 상담하라.

**Webhook 안정성.** 기본 모드의 Webhook은 메인 프로세스의 가용성에 의존한다. 미션 크리티컬한 Webhook 수신을 위해서는 전용 Webhook 프로세서가 있는 큐 모드가 필요하다.

## 자주 묻는 질문

### n8n 자체 호스팅 월간 비용은 얼마인가?

인프라 비용은 월 $5의 2 GB VPS(일 1,000회 미만 실행에 적합)부터 $50-100(월 10만+ 실행을 처리하는 큐 모드 배포)까지 다양하다. Zapier 프로페셔널 플랜 $49/월이 2,000개 태스크에 불과한 것과 비교하면, 자체 호스팅의 손익 분기점은 보통 월 3,000회 이상의 워크플로 실행에서 발생한다.

### n8n과 Zapier의 차이점은 무엇인가?

n8n은 실행 기반 과금 모델(한 번의 워크플로 실행 = 한 번의 실행, 단계 수와 무관)을 사용하고, Zapier는 태스크 기반 과금(워크플로의 각 단계가 하나의 태스크)을 사용한다. 10단계 워크플로를 1,000회 실행하면 n8n에서는 1,000회 실행이고, Zapier에서는 10,000개 태스크이다. n8n은 또한 Zapier가 제공하지 않는 자체 호스팅, 커스텀 코드 노드, AI 에이전트 기능을 제공한다.

### n8n은 인터넷 없이도 실행할 수 있는가?

그렇다. 내 네트워크의 자체 호스팅 n8n 인스턴스는 로컬 데이터베이스, 내 API, Ollama를 통한 자체 호스팅 LLM을 사용하여 워크플로를 실행할 수 있다. 그러나 클라우드 기반 통합(OpenAI, Slack 등)은 아웃바운드 인터넷 액세스가 필요하다. 완전히 에어갭 환경에서는 로컬 모델과 온프레미스 서비스만 사용하라.

### n8n을 최신 버전으로 업데이트하려면 어떻게 해야 하는가?

```bash
# 최신 이미지 가져오기
docker-compose pull

# (큐 모드) 무중단 재시작
docker-compose up -d

# 버전 확인
docker-compose exec n8n-main n8n --version
```

주요 버전 업그레이드 전에 반드시 데이터베이스를 백업하라. 변경 로그는 https://github.com/n8n-io/n8n/blob/master/CHANGELOG.md 에서 확인할 수 있다.

### n8n은 엔터프라이즈 프로덕션 환경에 적합한가?

그렇다. 큐 모드를 활성화하면 된다. n8n은 LDAP/SAML SSO, 역할 기반 액세스 제어, 감사 로그, 외부 비밀 관리자, SIEM 로그 스트리밍을 지원한다. Redis와 다중 워커가 있는 큐 모드는 초당 400+ 실행을 달성한다. 지멘스, 모질라, 포춘 500대 기업 200곳 이상이 프로덕션에서 n8n을 사용하고 있다.

### 실패한 워크플로를 어떻게 해결하는가?

n8n UI에서 실행 로그를 확인하라(Settings > Executions). `N8N_LOG_LEVEL=debug`로 디버깅 로그를 활성화하라. Webhook 문제의 경우 `WEBHOOK_URL`이 공개 도메인과 일치하는지 확인하라. 데이터베이스 오류의 경우 PostgreSQL 연결 풀 제한을 확인하라. 일반적인 해결: `docker-compose logs -f n8n-main | grep ERROR`.

### n8n은 어떤 데이터베이스를 지원하는가?

n8n은 공식적으로 SQLite(기본, 개발 전용), PostgreSQL(프로덕션 권장), MySQL을 지원한다. SQLite는 다중 워커의 동시 쓰기를 지원하지 않으므로 프로덕션에 적합하지 않다. PgBouncer가 있는 PostgreSQL 14+가 프로덕션 표준이다.

## 결론

n8n은 상용 플랫폼 비용의 일부로 AI 기능을 갖춘 워크플로 자동화를 제공한다. 자체 호스팅 경로는 사전 Docker와 Linux 지식을 필요로 하지만, 그 대가는 상당하다: 무제한 실행, 완전한 데이터 제어, AI 에이전트 워크플로를 위한 네이티브 LangChain 통합. 기본 Docker Compose 설정부터 시작하여, 처리량 요구가 증가할 때 큐 모드로 마이그레이션하고, 이 가이드에 설명된 보안 및 모니터링 구성을 구현하여 프로덕션 환경을 강화하라.

**다음 단계:**
1. VPS에 Docker Compose 설정 배포하기 ([DigitalOcean](https://www.digitalocean.com/pricing))
2. 첫 번째 OpenAI 기반 워크플로 구성하기
3. [community.n8n.io](https://community.n8n.io)에서 n8n 커뮤니티 가입하기
4. [Telegram 그룹](https://t.me/dibi8opensource)에서 자동화 팁과 업데이트 받기

*이 문서에는 제휴 링크가 포함되어 있다. 이 링크를 통해 구매하면 추가 비용 없이 우리에게 커미션이 지급될 수 있다.*



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 참고 자료

- n8n 공식 문서: https://docs.n8n.io/
- n8n GitHub 저장소: https://github.com/n8n-io/n8n
- n8n AI 에이전트 노드 참조: https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.agent/
- n8n Docker 설정 가이드: https://docs.n8n.io/hosting/installation/docker/
- n8n 큐 모드 문서: https://docs.n8n.io/hosting/scaling/queue-mode/
- n8n 환경 변수: https://docs.n8n.io/hosting/configuration/environment-variables/
- DigitalOcean n8n 튜토리얼: https://www.digitalocean.com/community/tutorials/how-to-setup-n8n
- n8n 가격: https://n8n.io/pricing/
- n8n 커뮤니티 포럼: https://community.n8n.io
- n8n 보안 모범 사례: https://docs.n8n.io/hosting/security/
