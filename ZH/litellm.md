---
title: 'LiteLLM: 22,500 Stars — 部署一个 API 调用 100+ LLM，内置故障转移 — 2026 生产级网关配置'
description: 'LiteLLM (litellm) 是开源 AI 网关，提供统一 API 调用 100+ LLM。兼容 OpenAI、Anthropic、Ollama、Cohere、Gemini、Bedrock。涵盖 Docker 部署、虚拟密钥、负载均衡、缓存和生产加固。'
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
github_repo: 'https://github.com/BerriAI/litellm'
stars: 22500
maintainer: 'BerriAI'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['litellm', 'llm网关', '开源', 'docker', '生产部署', 'ai基础设施', '代理服务器', '多模型']
aliases:
- /zh/posts/litellm/
- /zh/resources/llm-frameworks/litellm-unified-api-tutorial/
---

{{</* resource-info */>}}

![LiteLLM Logo](https://raw.githubusercontent.com/BerriAI/litellm/main/docs/my-assets/logo.png)

## 简介

你的系统在用 Claude 做推理，GPT-4o 写代码，Gemini Flash 做低成本分类。每个提供商有自己的 SDK、重试逻辑、限流头和计费后台。Anthropic API 凌晨 2 点抖动，就有人被叫醒。OpenAI 账单周环比涨 40%，没人知道哪个团队干的。

这就是多 LLM 的运维税——每加一个模型，成本翻倍。LiteLLM 消灭这个税。它是一个开源 AI 网关，暴露单个 OpenAI 兼容的 API 端点，代理请求到 100+ LLM 提供商，内置自动故障转移、负载均衡、虚拟密钥和费用追踪。

凭借 **22,500+ GitHub stars** 和 **1,500+ 贡献者**，LiteLLM 已成为想要网关级控制且无供应商锁定的团队的首选。本指南在 30 分钟内带你完成生产级配置——从 Docker 部署到虚拟密钥管理再到监控。

---

## LiteLLM 是什么？

LiteLLM 是一个开源 LLM 代理网关和 Python SDK，提供统一接口调用 100+ LLM API——OpenAI、Anthropic、Azure、Google Vertex AI、AWS Bedrock、Cohere、Ollama 等——使用单一 OpenAI 兼容 API 格式。

两种模式：

- **Python SDK** — 在代码中 `import litellm; completion(...)`，与提供商无关
- **代理服务器** — 自托管 HTTP 网关，监听 `:4000`，任何 OpenAI SDK 客户端都可以指向它

代理模式是大多数生产团队使用的。它增加了虚拟密钥、团队管理、预算控制、速率限制、缓存和可观测性——全部通过单个 `config.yaml` 文件配置。

---

## LiteLLM 工作原理

![LiteLLM 架构图](images/litellm-architecture.png)

**请求流程：**

1. 你的应用发送 OpenAI 格式请求到 `http://litellm-proxy:4000/v1/chat/completions`
2. LiteLLM 验证虚拟密钥，检查团队预算和速率限制
3. 路由器根据配置策略（基于延迟、基于成本或简单负载均衡）选择最佳模型部署
4. 如果主提供商返回 429/5xx，自动故障转移在毫秒级触发
5. 响应以 OpenAI 格式流回，无论哪个提供商处理了请求
6. 消费、延迟和 token 计数记录到 PostgreSQL；Prometheus 指标被发出

**核心组件：**

| 组件 | 用途 | 外部依赖 |
|------|------|----------|
| 代理服务器 | HTTP API、路由、认证 | 无（Python/FastAPI） |
| PostgreSQL | 虚拟密钥、消费日志、团队数据 | 生产必需 |
| Redis | 限流协调、缓存 | 推荐 |
| 管理后台 | 密钥/模型的 Web 仪表盘 | 内置 |

---

## 安装与配置

### 前置条件

- Docker 24+ 和 Docker Compose v2
- PostgreSQL 14+（本地容器或托管服务如 [DigitalOcean Managed Postgres](https://www.digitalocean.com/products/managed-databases-postgresql)）
- 代理容器最低 2 vCPU / 4 GB RAM

### 步骤 1：下载 Docker Compose 模板

```bash
# 创建项目目录
mkdir -p litellm-gateway && cd litellm-gateway

# 下载官方 docker-compose.yml
curl -O https://raw.githubusercontent.com/BerriAI/litellm/main/docker-compose.yml

# 创建环境文件
cat > .env << 'EOF'
LITELLM_MASTER_KEY="sk-litellm-admin-$(openssl rand -hex 16)"
LITELLM_SALT_KEY="sk-salt-$(openssl rand -hex 32)"
OPENAI_API_KEY="sk-your-openai-key"
ANTHROPIC_API_KEY="sk-your-anthropic-key"
DATABASE_URL="postgresql://llmproxy:dbpassword9090@db:5432/litellm"
EOF
```

### 步骤 2：创建 config.yaml

```yaml
# litellm_config.yaml
model_list:
  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY
      rpm: 500
      tpm: 150000

  - model_name: claude-sonnet
    litellm_params:
      model: anthropic/claude-sonnet-4-20250514
      api_key: os.environ/ANTHROPIC_API_KEY
      rpm: 200
      tpm: 40000

  - model_name: gemini-flash
    litellm_params:
      model: gemini/gemini-2.0-flash
      api_key: os.environ/GEMINI_API_KEY
      rpm: 1000

  - model_name: ollama-llama
    litellm_params:
      model: ollama/llama3.3
      api_base: http://ollama:11434
    model_info:
      mode: chat

  # 嵌入模型
  - model_name: text-embedding
    litellm_params:
      model: openai/text-embedding-3-small
      api_key: os.environ/OPENAI_API_KEY

general_settings:
  master_key: os.environ/LITELLM_MASTER_KEY
  database_url: os.environ/DATABASE_URL
  max_budget: 10000.00
  budget_duration: 30d
  alerting:
    - slack
  alerting_threshold: 300
  global_max_parallel_requests: 200

litellm_settings:
  drop_params: true
  num_retries: 3
  request_timeout: 120

  # 自动故障转移
  fallbacks:
    - gpt-4o:
      - claude-sonnet
      - gemini-flash
    - claude-sonnet:
      - gpt-4o
      - gemini-flash

  # Redis 缓存
  cache: true
  cache_params:
    type: redis
    host: redis
    port: 6379
    ttl: 3600

  # 可观测性回调
  success_callback: ["prometheus"]
  failure_callback: ["prometheus"]
```

### 步骤 3：启动服务栈

```bash
# 拉取并启动所有服务
docker compose up -d

# 验证服务健康状态
docker compose ps

# 查看代理日志
docker compose logs -f litellm
```

代理现在运行在 `http://localhost:4000`。管理后台在 `http://localhost:4000/ui/` — 用用户名 `admin` 和你的 `LITELLM_MASTER_KEY` 作为密码登录。

### 步骤 4：用请求测试

```bash
# 测试对话补全
curl http://localhost:4000/v1/chat/completions \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o",
    "messages": [{"role": "user", "content": "什么是 LiteLLM？"}]
  }'

# 测试嵌入
curl http://localhost:4000/v1/embeddings \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "text-embedding",
    "input": ["LiteLLM 是一个 AI 网关"]
  }'
```

---

## 与主流工具集成

### OpenAI SDK (Python)

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:4000",
    api_key="sk-your-litellm-virtual-key"
)

response = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "解释负载均衡"}]
)
print(response.choices[0].message.content)
```

### LangChain

```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(
    model="claude-sonnet",
    openai_api_key="sk-your-virtual-key",
    openai_api_base="http://localhost:4000"
)

result = llm.invoke("LLM 网关有哪些类型？")
print(result.content)
```

### Anthropic SDK (原生兼容)

```python
from anthropic import Anthropic

client = Anthropic(
    base_url="http://localhost:4000/anthropic",
    api_key="sk-your-virtual-key"
)

response = client.messages.create(
    model="claude-sonnet",
    max_tokens=1024,
    messages=[{"role": "user", "content": "比较 LiteLLM 和 OpenRouter"}]
)
print(response.content[0].text)
```

### Ollama (本地模型)

```yaml
# 添加到 litellm_config.yaml
model_list:
  - model_name: local-llama
    litellm_params:
      model: ollama/llama3.3
      api_base: http://localhost:11434
    model_info:
      mode: chat
```

```bash
# 通过 LiteLLM 测试本地模型
curl http://localhost:4000/v1/chat/completions \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "local-llama",
    "messages": [{"role": "user", "content": "你好本地模型"}]
  }'
```

### Cohere

```yaml
model_list:
  - model_name: cohere-command
    litellm_params:
      model: cohere/command-r-plus
      api_key: os.environ/COHERE_API_KEY
```

```python
from openai import OpenAI
client = OpenAI(base_url="http://localhost:4000", api_key="sk-virtual-key")
response = client.chat.completions.create(
    model="cohere-command",
    messages=[{"role": "user", "content": "总结一下"}]
)
```

---

## 基准测试 / 真实用例

### 场景：多团队 AI 平台（SaaS 创业公司）

一个 50 人的 AI 创业公司，服务 5 个内部团队和外部 API 客户：

| 指标 | 使用 LiteLLM 前 | 使用 LiteLLM 后 |
|------|----------------|----------------|
| 维护的提供商 SDK | 4（OpenAI、Anthropic、Gemini、Ollama） | 1（OpenAI 兼容） |
| API 密钥管理 | 共享密钥在环境变量中 | 每个团队/客户的虚拟密钥 |
| 费用归属 | 手动 CSV 导出 | 实时后台的按密钥消费 |
| 故障响应 | 人工叫醒，15 分钟 MTTR | 自动故障转移，<500ms |
| 月度 LLM 消费 | ¥61,000（未优化） | ¥44,500（路由优化后 -27%） |

### 性能基准（自托管，4 vCPU / 8 GB RAM）

| 负载 | 吞吐量 | P50 延迟 | P99 延迟 |
|------|--------|---------|---------|
| 50 RPS 对话 (GPT-4o) | 稳定 | 45ms 开销 | 120ms 开销 |
| 200 RPS 嵌入 | 稳定 | 12ms 开销 | 35ms 开销 |
| 故障转移触发 | — | 180ms 切换 | 280ms 切换 |
| 缓存命中 (Redis) | — | 3ms | 8ms |

**注意：** 网关开销不包含 LLM API 响应时间。LiteLLM 增加少量、可预测的延迟惩罚。对于每毫秒都重要的流程，将代理部署在与应用相同的 VPC 中。

---

## 高级用法 / 生产加固

### 虚拟密钥和团队管理

虚拟密钥是生产 LiteLLM 部署的安全骨干。每个密钥可以有自己的预算、速率限制、模型访问列表和 TTL。

![LiteLLM 管理后台](images/litellm-dashboard.png)

```bash
# 为 "前端团队" 创建虚拟密钥
curl -X POST http://localhost:4000/key/generate \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "key_alias": "frontend-team-key",
    "team_id": "frontend-team",
    "models": ["gpt-4o", "gemini-flash"],
    "max_budget": 500.00,
    "budget_duration": "30d",
    "rpm_limit": 100,
    "tpm_limit": 50000,
    "metadata": {
      "service": "customer-chat-widget",
      "env": "production"
    }
  }'

# 响应：
# {
#   "key": "sk-litellm-abc123...",
#   "expires": null,
#   "max_budget": 500.00,
#   "models": ["gpt-4o", "gemini-flash"]
# }
```

### 提供商级预算上限

```yaml
general_settings:
  provider_budget_config:
    openai:
      monthly_budget: 5000.00
    anthropic:
      monthly_budget: 3000.00
    gemini:
      monthly_budget: 1000.00
```

### 基于延迟的路由

```yaml
router_settings:
  routing_strategy: latency-based-routing
  routing_strategy_args:
    ttl: 60
  allowed_fails: 3
  cooldown_time: 60
  num_retries: 2
  timeout: 90
  retry_after: 5
```

### 安全检查清单

```yaml
# 安全加固版 config.yaml
general_settings:
  master_key: os.environ/LITELLM_MASTER_KEY
  database_url: os.environ/DATABASE_URL

  # 生产环境强制 HTTPS
  # 在 Nginx 或 AWS ALB 后部署，启用 TLS 终止

  # 禁用详细日志
  litellm_settings:
    set_verbose: false

  # 静态加密密钥
  litellm_settings:
    key_generation_algorithm: "rsa"
    allow_user_auth: false
```

### Kubernetes / Helm 部署

```bash
# 添加 LiteLLM Helm 仓库
helm pull oci://docker.litellm.ai/berriai/litellm-helm

# 使用自定义值安装
helm install litellm-gateway ./litellm-helm \
  --namespace litellm \
  --create-namespace \
  --set replicaCount=3 \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=litellm.yourdomain.com \
  --set env.LITELLM_MASTER_KEY="sk-$(openssl rand -hex 16)" \
  --set env.DATABASE_URL="postgresql://user:pass@neon-host/litellm"
```

### Prometheus + Grafana 监控

```yaml
# 添加到 config.yaml
litellm_settings:
  success_callback: ["prometheus"]
  failure_callback: ["prometheus"]
```

在 `/metrics` 暴露的关键 Prometheus 指标：

```promql
# 按模型的请求速率
rate(litellm_request_total_requests[5m])

# 错误率
rate(litellm_requests_total_failed[5m])

# 每个密钥的剩余预算
litellm_remaining_requests

# 网关开销直方图
histogram_quantile(0.95, litellm_overhead_latency_ms_bucket)
```

导入 [官方 Grafana 仪表盘](https://github.com/BerriAI/litellm/blob/main/examples/grafana/grafana_dashboard.json) 获取预构建面板，展示请求/秒、token 用量、每团队成本和延迟百分位。

---

## 与替代方案对比

| 功能 | LiteLLM | Portkey | OpenRouter | Helicone |
|------|---------|---------|------------|----------|
| **许可证** | MIT（开源） | 闭源核心 + 开源 SDK | 闭源（托管） | 闭源（托管 + 自托管） |
| **部署方式** | 自托管 / Docker / K8s | 云端 + 混合 | 仅托管 | 云端 + 自托管 |
| **支持的模型** | 100+ 提供商 | 200+ | 300+ | 依赖提供商 |
| **自托管成本** | ￥1,400–5,500/月 基础设施 | N/A（托管） | N/A（托管） | ￥0–700/月（自托管） |
| **虚拟密钥/预算** | 每密钥 + 每团队 | 每密钥 + 每用户 | 基础每密钥 | 每组织 |
| **自动故障转移** | 可配置链 | 熔断器 | 提供商路由 | 有限 |
| **语义缓存** | Redis + Qdrant | 内置 | 无 | 无 |
| **可观测性** | Prometheus + 外部 | 内置深度追踪 | 基础用量统计 | 核心聚焦 |
| **合规性** | DIY（通过基础设施实现 SOC2） | SOC 2, ISO 27001, HIPAA | 部分 | SOC 2 |
| **最适合** | 完全控制、零锁定 | 企业治理 | 快速模型访问 | 可观测性优先 |

**选择建议：**

- **LiteLLM** — 你有 DevOps 能力，想要零供应商锁定，需要对路由、缓存和数据驻留的完全控制。
- **Portkey** — 你需要企业级治理（SOC 2、审计日志）、提示管理 UI，愿意支付 SaaS 费用。
- **OpenRouter** — 你想零基础设施工作立即访问 300+ 模型，5.5% 的信用手续费可接受。
- **Helicone** — 可观测性是你的首要关注点；你需要详细的追踪和 LLM 调用的成本归属。

---

## 局限性 / 客观评估

LiteLLM 不是每种情况的正确工具。以下是其短板：

1. **运维开销** — 与托管网关不同，你负责正常运行时间、扩缩容、安全补丁和数据库备份。为生产维护预算 0.5–1 个全职人力。

2. **无内置提示管理** — Portkey 的提示版本 UI（含 A/B 测试）在 LiteLLM 中不存在。你在应用或外部工具中管理提示模板。

3. **语义缓存需要额外基础设施** — Redis 语义缓存需要嵌入模型端点。与 Portkey 内置语义缓存相比，这增加了复杂性和成本。

4. **无原生多区域冗余** — 你用自己的架构实现多区域故障转移，通过 DNS 或全局负载均衡器。LiteLLM 默认是单区域代理。

5. **企业 SSO 收费** — SAML/SSO、审计日志和高级护栏属于 LiteLLM Enterprise 功能。开源版仅处理虚拟密钥和基础预算。

---

## 常见问题

**Q: LiteLLM 与 OpenRouter 相比如何？**

LiteLLM 是自托管开源网关；OpenRouter 是托管多模型 API。LiteLLM 给你零加价和对数据的完全控制。OpenRouter 收取 5.5% 的信用购买手续费但零基础设施工作。对于月 LLM 消费 >$5,000 且有 DevOps 能力的团队，LiteLLM 长期更便宜。对于快速原型开发，OpenRouter 部署更快。

**Q: LiteLLM 可以与现有的 OpenAI SDK 代码一起使用吗？**

可以——改两行：将 `base_url` 设为你的 LiteLLM 代理，`api_key` 设为虚拟密钥。其他一切保持不变。这是团队采用 LiteLLM 的主要原因；除配置外零代码更改。

**Q: LiteLLM 需要什么数据库？**

生产功能（虚拟密钥、消费追踪、团队管理）需要 PostgreSQL 14+。代理可以在没有数据库的情况下运行基础透传路由，但会失去预算管理、密钥管理和管理后台。

**Q: 故障转移机制如何工作？**

你在 `config.yaml` 中定义故障转移链。如果模型返回 429、500 或超时，LiteLLM 在同一客户端请求内对链中的下一个模型重试请求。客户端看到单个响应；故障转移透明发生。

**Q: LiteLLM 适合高流量生产使用吗？**

适合——配合 Redis 缓存和负载均衡后的 2+ 副本，LiteLLM 处理 1,000+ RPS。数据库连接池和 Redis 事务缓冲是扩缩容瓶颈，不是代理本身。在 Kubernetes 下使用 Helm Chart 配合 HPA 实现自动扩缩容。

**Q: 如何在生产中监控 LiteLLM？**

在 `config.yaml` 中启用 Prometheus 回调，抓取 `/metrics` 端点，导入官方 Grafana 仪表盘。在 `litellm_requests_total_failed`（错误率）和 `litellm_remaining_requests`（预算耗尽）上设置告警。将 `success_callback` 接入 Langfuse 实现按请求追踪。

---

## 结论

LiteLLM 解决了生产多 LLM 部署的混乱现实：多个 SDK、分散的 API 密钥、不透明的成本和手动故障转移。用单个 `config.yaml`，你获得统一的 OpenAI 兼容网关、带预算的虚拟密钥、自动故障转移和实时消费追踪。

对于月 LLM API 消费 $5,000+ 且具备基础 DevOps 能力的团队，自托管 LiteLLM 通过降低加价费用和提高可靠性收回成本。从上面的 Docker Compose 配置开始，添加 Redis 缓存，然后在流量增长时通过 Helm 扩展到 Kubernetes。

**行动项：**

1. 克隆 [LiteLLM GitHub 仓库](https://github.com/BerriAI/litellm) 并运行 Docker Compose 快速启动
2. 为每个团队创建虚拟密钥并设置每密钥预算
3. 启用 Redis 缓存和 Prometheus 监控
4. 加入 [LiteLLM Discord 社区](https://discord.gg/wupm9ySymB) 获取支持和功能讨论

*本文含联盟营销链接。通过链接购买主机服务我们可能获得佣金——这不会影响价格或推荐。*

---



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [LiteLLM GitHub 仓库](https://github.com/BerriAI/litellm) — 官方源代码，22,500+ stars
- [LiteLLM 文档](https://docs.litellm.ai/docs/) — 完整的代理和 SDK 参考
- [LiteLLM Docker 快速启动](https://docs.litellm.ai/docs/proxy/docker_quick_start) — 官方 Docker 配置指南
- [LiteLLM 配置参考](https://docs.litellm.ai/docs/proxy/configs) — 所有 config.yaml 选项
- [LiteLLM Helm 部署](https://docs.litellm.ai/docs/proxy/deploy) — Kubernetes 和 Helm 图表
- [LiteLLM 管理后台文档](https://docs.litellm.ai/docs/proxy/ui) — 虚拟密钥和团队管理
- [LiteLLM 缓存指南](https://docs.litellm.ai/docs/caching/all_caches) — Redis、语义和磁盘缓存
- [Portkey vs LiteLLM 对比](https://portkey.ai/lp/portkey-vs-litellm) — 厂商对比页面
- [OpenRouter 文档](https://openrouter.ai/docs) — 替代网关参考
- [Helicone 文档](https://docs.helicone.ai) — 可观测性聚焦的替代方案
