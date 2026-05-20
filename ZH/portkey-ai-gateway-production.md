---
title: 'Portkey AI Gateway 2026: 管理200+模型的LLM网关与可观测性 — 生产环境部署'
description: ''
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/Portkey-AI/gateway'
stars: 14000
maintainer: 'Portkey-AI'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Portkey AI Gateway']
aliases:
- /zh/posts/portkey-ai-gateway-production/
---

{{</* resource-info */>}}

在生产环境中管理多个大语言模型（LLM）提供商是一场噩梦。每个提供商都有自己的API格式、认证方案、速率限制和故障模式。你的应用代码中充斥着针对OpenAI、Anthropic、Google、Azure以及每月涌现的数十个新提供商的条件逻辑。**Portkey AI Gateway** 应运而生 —— 这款开源LLM网关将200+模型统一在单一API之后，提供负载均衡、故障转移路由、消费追踪、请求缓存和企业级可观测性。

在本综合指南中，我们将详细介绍Portkey AI Gateway的生产级部署。你将学习如何在多个提供商之间路由请求、实施智能故障转移、监控消费、缓存响应并实施安全防护 —— 同时保持应用代码的整洁和提供商无关性。

> **快速开始**：Portkey AI Gateway采用MIT许可证开源，拥有14,000+ GitHub星标。你可以选择自托管或使用托管云服务。准备好了吗？让我们开始吧。

---

## 什么是Portkey AI Gateway？

Portkey AI Gateway是一款开源AI网关，位于你的应用和LLM提供商之间。可以将其视为专为AI工作负载设计的智能反向代理。它统一了来自OpenAI、Anthropic、Google、Azure、Cohere、Mistral等20+提供商的200+模型的API接口，让你的代码只需要使用一种语言。

该网关处理了LLM生产部署中的棘手问题：

- **统一API**：一个端点对接20+提供商的200+模型
- **负载均衡**：在多个API密钥或提供商之间分配流量
- **故障转移路由**：提供商宕机时自动切换
- **请求缓存**：缓存相同请求以降低成本和延迟
- **消费追踪**：实时了解你的AI支出
- **提示词管理**：独立于代码进行提示词版本管理
- **安全防护**：执行内容策略和安全检查
- **可观测性**：完整的请求/响应日志记录、指标和链路追踪

无论你是运行单个模型的初创公司，还是管理数十个提供商的企业，Portkey都能提供你所需的基础设施层来将AI应用投入生产。

---

## 架构概述和部署选项

Portkey AI Gateway提供两种部署模式：**云（托管）** 和 **自托管**。该架构围绕一个轻量级、高性能的网关服务器构建，该服务器拦截LLM请求，应用你配置的策略，并将其路由到相应的提供商。

### 云部署

最快的入门方式是使用Portkey的托管云服务。在 [Portkey.ai](https://portkey.ai) 注册，创建API密钥，你就可以开始路由请求了。云选项为你处理扩展、更新和基础设施维护。

### 自托管部署

对于具有严格数据驻留或安全要求的组织，自托管是最佳选择。该网关可以通过Docker、Kubernetes或作为独立的Node.js应用程序部署。

**使用Docker部署：**

```bash
# 克隆仓库
git clone https://github.com/Portkey-AI/gateway.git
cd gateway

# 使用Docker运行
docker run -p 8787:8787 -e PORTKEY_GATEWAY_API_KEY=your-gateway-key portkeyai/gateway:latest
```

**使用Docker Compose部署：**

```yaml
version: '3.8'
services:
  portkey-gateway:
    image: portkeyai/gateway:latest
    ports:
      - "8787:8787"
    environment:
      - PORTKEY_GATEWAY_API_KEY=${GATEWAY_API_KEY}
      - CACHE_ENABLED=true
      - CACHE_TTL=3600
    volumes:
      - ./config:/app/config
    restart: unless-stopped
```

**部署到Kubernetes：**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: portkey-gateway
spec:
  replicas: 3
  selector:
    matchLabels:
      app: portkey-gateway
  template:
    metadata:
      labels:
        app: portkey-gateway
    spec:
      containers:
      - name: gateway
        image: portkeyai/gateway:latest
        ports:
        - containerPort: 8787
        env:
        - name: PORTKEY_GATEWAY_API_KEY
          valueFrom:
            secretKeyRef:
              name: portkey-secrets
              key: gateway-api-key
---
apiVersion: v1
kind: Service
metadata:
  name: portkey-gateway-service
spec:
  selector:
    app: portkey-gateway
  ports:
  - port: 80
    targetPort: 8787
  type: ClusterIP
```

对于生产部署，我们建议使用Kubernetes并至少3个副本以确保高可用性。如果你需要一个可靠的云平台来托管你的集群，[DigitalOcean Kubernetes](https://m.do.co/c/eca87ac14ee0) 提供了一个开发者友好的托管Kubernetes服务，与Portkey完美搭配。

---

## 配置提供商和API密钥

在路由请求之前，你需要配置你的LLM提供商。Portkey使用提供商配置系统来安全地存储你的API密钥，并将它们映射到命名的提供商实例。

### 设置提供商

创建 `providers.yaml` 配置文件：

```yaml
providers:
  openai-primary:
    type: openai
    api_key: ${OPENAI_API_KEY}
    organization: ${OPENAI_ORG_ID}
    
  anthropic-primary:
    type: anthropic
    api_key: ${ANTHROPIC_API_KEY}
    
  azure-gpt4:
    type: azure-openai
    api_key: ${AZURE_API_KEY}
    resource_name: ${AZURE_RESOURCE_NAME}
    deployment_id: gpt-4
    api_version: 2025-12-01
    
  google-gemini:
    type: google
    api_key: ${GOOGLE_API_KEY}
    
  mistral-local:
    type: mistral
    api_key: ${MISTRAL_API_KEY}
    base_url: http://mistral-service:8000/v1
```

### 加载配置

```bash
# 设置环境变量
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GATEWAY_API_KEY="pk-..."

# 使用配置启动网关
docker run -p 8787:8787 \
  -e PORTKEY_GATEWAY_API_KEY=$GATEWAY_API_KEY \
  -v $(pwd)/providers.yaml:/app/config/providers.yaml \
  portkeyai/gateway:latest
```

---

## 统一API：一个端点对接200+模型

Portkey的核心价值在于其统一API。无论你调用的是哪个模型或提供商，请求格式都保持不变。网关负责将标准化的Portkey格式转换为每个提供商的原生格式。

### 基础对话补全请求

```bash
curl -X POST http://localhost:8787/v1/chat/completions \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o",
    "provider": "openai-primary",
    "messages": [
      {"role": "system", "content": "你是一个有帮助的助手。"},
      {"role": "user", "content": "用简单的术语解释量子计算。"}
    ]
  }'
```

### 即时切换提供商

```bash
# 相同的请求，不同的提供商 —— 只需更改model/provider字段
curl -X POST http://localhost:8787/v1/chat/completions \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-sonnet-4",
    "provider": "anthropic-primary",
    "messages": [
      {"role": "user", "content": "用简单的术语解释量子计算。"}
    ],
    "max_tokens": 1024
  }'
```

### Python SDK示例

```python
from portkey_ai import Portkey

# 初始化客户端
portkey = Portkey(
    api_key="your-gateway-api-key",
    virtual_key="openai-primary"  # 引用已配置的提供商
)

# 对话补全
response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": "你是一个有帮助的助手。"},
        {"role": "user", "content": "写一个Python函数来计算斐波那契数。"}
    ]
)
print(response.choices[0].message.content)
```

### 流式响应

```python
import portkey_ai

portkey = portkey_ai.Portkey(api_key="your-gateway-api-key")

stream = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "写一首关于AI的诗。"}],
    stream=True
)

for chunk in stream:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="")
```

---

## 负载均衡和故障转移路由

生产级AI系统不能容忍提供商宕机。Portkey的负载均衡和故障转移路由确保你的应用即使提供商出现故障也能保持在线。

### 轮询负载均衡

在多个API密钥或提供商之间均匀分配流量：

```yaml
# config/load-balance.yaml
strategies:
  gpt4-pool:
    type: load_balance
    providers:
      - provider: openai-primary
        weight: 1
      - provider: azure-gpt4
        weight: 1
      - provider: openai-backup
        weight: 1
```

```python
# 使用负载均衡池
response = portkey.chat.completions.create(
    model="gpt-4o",
    config="gpt4-pool",  # 引用策略
    messages=[{"role": "user", "content": "你好！"}]
)
```

### 优先级故障转移路由

定义自动故障切换的链路：

```yaml
strategies:
  production-fallback:
    type: fallback
    targets:
      - provider: azure-gpt4
        timeout: 10
        retry: 2
      - provider: openai-primary
        timeout: 15
        retry: 1
      - provider: anthropic-primary
        model: claude-sonnet-4
        timeout: 15
      - provider: google-gemini
        model: gemini-2.5-pro
        timeout: 20
```

```bash
# 网关按顺序尝试每个目标直到成功
curl -X POST http://localhost:8787/v1/chat/completions \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "config": "production-fallback",
    "messages": [{"role": "user", "content": "关键业务查询"}]
  }'
```

### 基于请求属性的条件路由

根据内容、用户或其他请求属性路由请求：

```yaml
strategies:
  smart-router:
    type: conditional
    rules:
      - condition: "request.messages[0].content.length > 4000"
        target: 
          provider: anthropic-primary
          model: claude-sonnet-4  # 更好的长上下文处理
      - condition: "request.user == 'code-assistant'"
        target:
          provider: openai-primary
          model: gpt-4o
      - condition: "default"
        target:
          provider: azure-gpt4
          model: gpt-4o-mini
```

---

## 请求缓存：降低成本和延迟

LLM API调用既昂贵又缓慢。Portkey的语义缓存存储响应并为类似查询提供缓存结果，显著降低成本和延迟。

### 启用缓存

```yaml
cache:
  enabled: true
  mode: semantic  # 或 "exact" 用于精确匹配缓存
  ttl: 3600       # 缓存生存时间（秒）
  max_size: 10000 # 最大缓存条目数
  similarity_threshold: 0.95  # 语义缓存的相似度阈值
```

```python
# 首次调用命中提供商并缓存结果
response1 = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "什么是Kubernetes？"}],
    cache=True
)

# 类似调用以极低成本立即返回缓存结果
response2 = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "给我解释一下Kubernetes"}],
    cache=True
)
```

### 缓存统计和失效

```bash
# 检查缓存指标
curl http://localhost:8787/v1/admin/cache/stats \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

```bash
# 使特定缓存条目失效
curl -X POST http://localhost:8787/v1/admin/cache/invalidate \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "pattern": "kubernetes",
    "provider": "openai-primary"
  }'
```

---

## 消费追踪和成本可观测性

了解你在提供商、模型和用户之间的AI支出对于预算管理至关重要。Portkey开箱即用地提供细粒度的成本追踪。

### 成本追踪设置

```python
import portkey_ai

portkey = portkey_ai.Portkey(
    api_key="your-gateway-api-key",
    metadata={
        "user_id": "user-12345",
        "project": "customer-support-bot",
        "environment": "production",
        "team": "ai-platform"
    }
)

response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "帮助处理我的订单"}]
)

# 从响应中访问成本信息
print(f"输入token: {response.usage.prompt_tokens}")
print(f"输出token: {response.usage.completion_tokens}")
print(f"总成本: ${response.usage.estimated_cost}")
```

### 查询消费分析

```bash
# 按提供商获取消费报告
curl "http://localhost:8787/v1/admin/analytics/spend?start_date=2026-05-01&end_date=2026-05-19&group_by=provider" \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

```bash
# 按用户获取消费报告
curl "http://localhost:8787/v1/admin/analytics/spend?start_date=2026-05-01&end_date=2026-05-19&group_by=user_id" \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

### 预算告警

```yaml
alerts:
  daily-budget:
    type: budget
    threshold: 500  # 美元
    period: daily
    channels:
      - type: webhook
        url: https://hooks.slack.com/services/YOUR/WEBHOOK/URL
      - type: email
        address: team@company.com
  
  abnormal-spike:
    type: anomaly
    baseline_multiplier: 3
    window: 1h
    channels:
      - type: pagerduty
        integration_key: your-pd-key
```

---

## 提示词管理和版本控制

独立于应用代码管理提示词，使非技术团队成员能够在无需部署的情况下迭代提示词。Portkey的提示词管理系统提供版本控制、A/B测试和动态变量替换。

### 创建托管提示词

```python
from portkey_ai import Portkey

portkey = Portkey(api_key="your-gateway-api-key")

# 部署提示词版本
prompt = portkey.prompts.deploy(
    name="customer-support-classifier",
    version="1.2.0",
    prompt=[
        {"role": "system", "content": "你是一个支持工单分类器。将工单分类为：计费、技术、功能请求或投诉。"},
        {"role": "user", "content": "工单: {{ticket_content}}"}
    ],
    model="gpt-4o-mini",
    parameters={
        "temperature": 0.2,
        "max_tokens": 50
    }
)
```

### 使用变量渲染提示词

```python
# 渲染并执行托管提示词
response = portkey.prompts.render(
    name="customer-support-classifier",
    variables={
        "ticket_content": "我这个月被收取了两次订阅费用。"
    }
)

print(response.choices[0].message.content)
# 输出: "计费"
```

### A/B测试提示词

```python
# 在提示词版本之间运行A/B测试
response = portkey.prompts.render(
    name="customer-support-classifier",
    version="1.2.0",  # 50% 流量
    test_version="1.3.0-beta",  # 50% 流量
    variables={"ticket_content": "上传照片时应用崩溃"}
)
```

---

## 安全防护和内容安全

Portkey的安全防护系统允许你在请求和响应上强制执行内容策略，确保符合安全标准和业务规则。

### 配置安全防护

```yaml
guardrails:
  input-validation:
    - type: keyword_filter
      blocklist: ["password", "ssn", "credit_card", "secret_key"]
      action: block
    - type: pii_detector
      entities: ["email", "phone", "ssn"]
      action: mask
    - type: toxicity_check
      threshold: 0.8
      action: block
      
  output-validation:
    - type: content_policy
      categories: ["hate", "violence", "self-harm"]
      action: block
    - type: response_format
      required_schema:
        type: json_object
      action: retry
```

```python
# 对请求应用安全防护
response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "用户输入内容"}],
    guardrails=["input-validation", "output-validation"]
)
```

### 自定义安全防护函数

```python
from portkey_ai import Portkey
import json

portkey = Portkey(api_key="your-gateway-api-key")

def custom_validator(request, response):
    """自定义业务逻辑验证。"""
    try:
        data = json.loads(response.choices[0].message.content)
        if "confidence" not in data or data["confidence"] < 0.7:
            return False, "置信度分数太低"
        return True, None
    except json.JSONDecodeError:
        return False, "响应必须是有效的JSON"

portkey.guardrails.register("confidence-check", custom_validator)
```

---

## 可观测性：日志记录、指标和链路追踪

了解AI系统在生产环境中的行为是不可妥协的。Portkey通过请求/响应日志记录、token使用指标、延迟直方图和分布式链路追踪提供全面的可观测性。

### 请求日志

```bash
# 查询最近的请求日志
curl "http://localhost:8787/v1/admin/logs?limit=100&status=error" \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

```python
# 为每个请求启用详细日志记录
response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "你好"}],
    metadata={
        "trace_id": "trace-abc-123",
        "session_id": "session-xyz-789",
        "user_id": "user-456"
    }
)
```

### OpenTelemetry集成

```yaml
observability:
  tracing:
    enabled: true
    exporter: otlp
    endpoint: http://jaeger-collector:4317
  metrics:
    enabled: true
    exporter: prometheus
    port: 9090
```

### Prometheus指标

网关在 `/metrics` 暴露Prometheus兼容指标：

```bash
# 抓取指标
curl http://localhost:8787/metrics
```

关键指标包括：
- `portkey_requests_total` — 按提供商、模型、状态统计的总请求数
- `portkey_request_duration_seconds` — 请求延迟直方图
- `portkey_tokens_total` — 按类型（输入/输出）和模型的token使用量
- `portkey_cache_hits_total` — 缓存命中/未命中计数
- `portkey_spend_total` — 估算支出（美元）

### Grafana仪表板

导入Portkey的官方Grafana仪表板（ID: `portkey-ai-gateway`）以获得开箱即用的可视化：

```json
{
  "dashboard": {
    "title": "Portkey AI Gateway 概览",
    "panels": [
      {
        "title": "每秒请求数",
        "targets": [
          {
            "expr": "rate(portkey_requests_total[5m])"
          }
        ]
      },
      {
        "title": "P95延迟",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, portkey_request_duration_seconds_bucket)"
          }
        ]
      },
      {
        "title": "Token使用量",
        "targets": [
          {
            "expr": "sum by (model) (portkey_tokens_total)"
          }
        ]
      }
    ]
  }
}
```

---

## 生产部署清单

在将Portkey AI Gateway投入生产之前，请确保你已经完成了以下关键项目：

### 基础设施

```yaml
# 使用Redis缓存和PostgreSQL日志的生产级docker-compose
version: '3.8'
services:
  gateway:
    image: portkeyai/gateway:latest
    ports:
      - "8787:8787"
    environment:
      - PORTKEY_GATEWAY_API_KEY=${GATEWAY_API_KEY}
      - REDIS_URL=redis://redis:6379
      - DATABASE_URL=postgres://user:pass@postgres:5432/portkey
    depends_on:
      - redis
      - postgres
    deploy:
      replicas: 3
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
  
  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data
  
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: portkey
      POSTGRES_USER: user
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  redis-data:
  postgres-data:
```

### 安全清单

| 项目 | 状态 | 备注 |
|------|------|------|
| API密钥轮换 | 必需 | 每月轮换网关密钥 |
| TLS终止 | 必需 | 使用反向代理或负载均衡器 |
| 速率限制 | 必需 | 配置每用户和每IP限制 |
| PII脱敏 | 推荐 | 为生产工作负载启用 |
| 审计日志 | 必需 | 记录所有管理操作 |
| 网络隔离 | 推荐 | 部署在私有子网中 |

### 健康检查

```bash
# 网关健康端点
curl http://localhost:8787/health

# 预期响应
{"status": "healthy", "version": "2.5.0", "uptime": 86400}
```

```yaml
# Kubernetes存活和就绪探针
livenessProbe:
  httpGet:
    path: /health
    port: 8787
  initialDelaySeconds: 10
  periodSeconds: 15

readinessProbe:
  httpGet:
    path: /ready
    port: 8787
  initialDelaySeconds: 5
  periodSeconds: 5
```

---

## 常见问题：Portkey AI Gateway

### Portkey AI Gateway支持哪些模型？

Portkey支持来自20+提供商的200+模型，包括OpenAI（GPT-4o、GPT-4o-mini、o3）、Anthropic（Claude 4、Claude 3.5）、Google（Gemini 2.5）、Azure OpenAI、Cohere、Mistral、Together AI、Groq、Perplexity等。新提供商会定期添加。

### 我可以免费自托管Portkey AI Gateway吗？

是的。Portkey AI Gateway采用MIT许可证开源，自托管完全免费。云版本提供额外的托管功能，如Web仪表板和高级分析，采用按量付费定价。

### 请求缓存是如何工作的？

Portkey提供两种缓存模式：**精确匹配**（相同请求返回缓存响应）和 **语义匹配**（基于嵌入相似度的相似请求返回缓存响应）。缓存可按请求配置，具有TTL和相似度阈值参数。

### 使用Portkey时我的数据安全吗？

自托管时，所有请求数据都保留在你的基础设施内。该网关支持PII检测和脱敏、加密API密钥存储和审计日志记录。对于云选项，Portkey已通过SOC 2 Type II认证，并为HIPAA合规提供业务伙伴协议（BAA）。

### 故障转移路由如何处理提供商宕机？

故障转移路由通过定义提供商的优先级列表来工作。如果主提供商失败（超时、5xx错误、速率限制），网关会自动将请求重试给链中的下一个提供商。你可以为每个目标配置重试次数、超时和错误条件。

### 我可以将Portkey与现有的OpenAI SDK代码一起使用吗？

是的。Portkey提供与OpenAI SDK的即插即用兼容性。只需将 `base_url` 更改为你的网关端点并使用你的Portkey API密钥：

```python
import openai

client = openai.OpenAI(
    api_key="your-portkey-gateway-key",
    base_url="http://localhost:8787/v1"
)

# 你现有的代码无需更改即可工作
response = client.chat.completions.create(...)
```

---



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 结论

Portkey AI Gateway将管理多个LLM提供商的复杂性转化为一个已解决的基础设施问题。凭借其统一API、智能路由、语义缓存、消费追踪和全面的可观测性，你可以专注于构建出色的AI应用，而不是与提供商集成搏斗。

无论你选择托管云服务还是在自己的基础设施上自托管（可以考虑 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) 进行简单的Kubernetes部署），Portkey都能提供生产级AI系统所需的可靠性、成本控制和可见性。

从Docker快速开始，配置你的提供商，设置带故障转移路由的负载均衡，启用缓存，并连接你的可观测性堆栈。不到一小时，你就将拥有一个处理200+模型并具有完整可观测性的生产级LLM网关。

---

*发布日期：2026-05-19 | Portkey AI Gateway v2.5.0 | [GitHub: Portkey-AI/gateway](https://github.com/Portkey-AI/gateway)*
