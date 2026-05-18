---
title: 'LiteLLM统一调用多模型教程2025：一个API接入100+大模型'
description: 'LiteLLM完整教程：用统一API调用OpenAI、Anthropic、Gemini等100+模型。涵盖代理部署、负载均衡、成本优化等企业级实践。'
date: 2026-05-18 00:00:00+08:00
lastmod: 2026-05-18 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-18'
featureImage: ''
draft: false
aliases:
- /posts/litellm-unified-api-tutorial/
---

{</* resource-info */>}

如果你正在同时对接 OpenAI、Anthropic、Google Gemini 和多个开源模型，你一定受够了为每个供应商写一套完全不同的 SDK 代码。LiteLLM 正是为解决这个问题而生——它提供了一套统一的 OpenAI 兼容接口，让你用同一套代码调用超过 100 个 LLM 提供商。

根据 GitHub 数据，截至 2025 年 5 月，LiteLLM 已获得超过 15,000 星标，被包括 Stripe、Shopify 在内的数千家企业用于生产环境。本文将带你从安装到生产部署，全面掌握 LiteLLM 的核心用法。

## 什么是 LiteLLM？为什么它改变了 LLM 调用方式？

LiteLLM 本质上是一个**LLM 网关（Gateway）**和**统一 API 抽象层**。它由 BerriAI 团队开发，主要解决三个核心痛点：

1. **API 格式碎片化**：每个模型供应商都有独特的认证方式、请求格式和错误处理逻辑
2. **多模型路由困难**：生产环境需要根据成本、延迟或可用性智能切换模型
3. **缺乏集中管控**：企业需要统一的密钥管理、用量监控和预算控制

### LiteLLM 的核心能力一览

| 功能 | 说明 | 适用场景 |
|------|------|----------|
| 统一 API 接口 | 将 100+ 提供商转换为 OpenAI 兼容格式 | 多模型集成项目 |
| 代理服务器 | 提供 HTTP API + 虚拟密钥管理 | 企业级 LLM 网关 |
| 智能路由 | 按成本/延迟/可用性自动选择模型 | 高可用生产环境 |
| 故障转移 | 模型不可用时自动切换备用 | 关键业务应用 |
| 响应缓存 | 缓存频繁查询降低 API 成本 | 客服/问答类应用 |
| 用量追踪 | 实时监控各团队/项目的花费 | 成本分摊与预算管控 |

## LiteLLM 支持哪些模型提供商？

LiteLLM 的提供商覆盖范围在同类工具中最为全面。以下为主要支持的提供商分类：

### 商业 API 提供商

- **OpenAI**：GPT-4o、GPT-4o-mini、o1/o3 系列、DALL-E、Whisper
- **Anthropic**：Claude 3.5/3.7 Sonnet、Claude 3 Opus、Claude 3 Haiku
- **Google**：Gemini 1.5 Pro/Flash、Gemini 2.0 Flash
- **Azure OpenAI**：企业级 GPT-4 部署
- **AWS Bedrock**：Claude、Llama、Titan、Nova 等
- **GCP Vertex AI**：Gemini、Llama 系列
- **Groq**：极低延迟推理（Llama 3 70B 每秒 800+ tokens）
- **Cohere**：Command R+、Embed 系列
- **Together AI**：开源模型推理 API

### 开源与本地模型

- **Ollama**：本地运行 Llama、Mistral、Qwen 等
- **vLLM**：高性能开源模型推理服务
- **Hugging Face TGI**：文本生成推理服务器
- **Replicate**：云端开源模型运行

完整提供商列表可参考 [LiteLLM 官方文档](https://docs.litellm.ai/docs/providers)。

## 安装与快速上手

安装 LiteLLM SDK 只需一行命令：

```bash
pip install litellm
```

### 第一次统一调用

```python
import litellm

# 调用 OpenAI
response = litellm.completion(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Hello!"}]
)

# 切换到 Anthropic —— 完全相同的代码结构
response = litellm.completion(
    model="claude-3-5-sonnet-20241022",
    messages=[{"role": "user", "content": "Hello!"}]
)

# 切换到 Google Gemini —— 依然相同的代码
response = litellm.completion(
    model="gemini/gemini-1.5-pro",
    messages=[{"role": "user", "content": "Hello!"}]
)
```

注意模型名称的**提供商前缀规则**：
- 无前缀：默认使用 OpenAI（如 `gpt-4o`）
- `claude-*`：Anthropic（如 `claude-3-5-sonnet-20241022`）
- `gemini/`：Google（如 `gemini/gemini-1.5-pro`）
- `ollama/`：本地 Ollama（如 `ollama/llama3.1`）
- `groq/`：Groq（如 `groq/llama3-70b-8192`）

### 异步支持

生产环境建议直接使用异步版本：

```python
import litellm

async def async_call():
    response = await litellm.acompletion(
        model="gpt-4o",
        messages=[{"role": "user", "content": "异步调用示例"}]
    )
    return response.choices[0].message.content
```

## LiteLLM Proxy Server：企业级部署核心

对于生产环境，**LiteLLM Proxy** 才是真正的主角。它提供一个独立的 HTTP 服务，所有内部应用通过它访问 LLM，实现集中管控。

### 启动代理服务器

```bash
litellm --config config.yaml
```

### config.yaml 配置详解

```yaml
model_list:
  - model_name: gpt-4o          # 自定义别名
    litellm_params:
      model: gpt-4o
      api_key: os.environ/OPENAI_API_KEY

  - model_name: claude-sonnet
    litellm_params:
      model: claude-3-5-sonnet-20241022
      api_key: os.environ/ANTHROPIC_API_KEY

  - model_name: llama-3-groq
    litellm_params:
      model: groq/llama3-70b-8192
      api_key: os.environ/GROQ_API_KEY

router_settings:
  routing_strategy: simple-shuffle  # 负载均衡策略
  num_retries: 3                    # 失败重试次数
  timeout: 30                       # 超时秒数

general_settings:
  master_key: os.environ/LITELLM_MASTER_KEY  # 管理密钥
  database_url: os.environ/DATABASE_URL       # PostgreSQL 用于持久化
```

### 虚拟密钥管理

LiteLLM Proxy 允许为不同团队创建**虚拟 API Key**，每个虚拟 Key 可设置独立的：

- **预算上限**：如每月 $100
- **速率限制**：如 100 RPM
- **可用模型白名单**：如仅限 GPT-4o-mini
- **元数据标签**：用于费用分摊

```bash
# 创建虚拟 Key
curl -X POST http://localhost:4000/key/generate \
  -H "Authorization: Bearer sk-master-xxx" \
  -d '{
    "max_budget": 100,
    "models": ["gpt-4o-mini"],
    "rpm_limit": 100,
    "team_id": "engineering"
  }'
```

### 负载均衡与故障转移

```yaml
model_list:
  - model_name: llama-3         # 同一个别名对应多个后端
    litellm_params:
      model: groq/llama3-70b-8192
      rpm: 100
  
  - model_name: llama-3         # 同别名 —— 自动负载均衡
    litellm_params:
      model: together_ai/meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo
      rpm: 60
```

当 `groq` 不可用时，请求自动路由到 `together_ai`。你还可以设置 `fallbacks` 规则，指定任意模型间的故障转移策略。

## 高级功能实战

### 智能路由与模型选择

```python
from litellm import Router

router = Router(
    model_list=[...],
    routing_strategy="latency-based",  # 基于延迟选择
    fallback_dict={"gpt-4o": ["claude-3-5-sonnet"]},
    cooldown_time=300                  # 失败模型冷却 5 分钟
)
```

支持的策略包括：`simple-shuffle`、`least-busy`、`latency-based`、`cost-based`。

### 响应缓存

```yaml
caching:
  - type: redis
    host: localhost
    port: 6379
    password: xxx
```

启用后，完全相同的查询（模型+消息）将命中缓存，不消耗 API Token。在客服问答场景下，缓存可降低 30-60% 的 API 成本。

### Embedding 模型统一调用

```python
import litellm

response = litellm.aembedding(
    model="text-embedding-3-large",
    input=["这是第一段文本", "这是第二段文本"]
)

# 切换到开源 embedding 模型
response = litellm.aembedding(
    model="ollama/nomic-embed-text",
    input=["这是第一段文本"]
)
```

## 如何用 LiteLLM 构建多模型应用？

### 场景一：智能模型降级

生产环境中，高成本模型应在必要时才调用。LiteLLM Router 可以实现"先尝试低成本模型，不满足再升级"的策略：

```python
from litellm import Router

router = Router(
    model_list=[
        {"model_name": "cheap", "litellm_params": {"model": "gpt-4o-mini"}},
        {"model_name": "premium", "litellm_params": {"model": "gpt-4o"}},
    ],
    routing_strategy="simple-shuffle",
    fallbacks=[{"cheap": ["premium"]}]  # 失败时自动升级
)

# 实际调用时始终使用 "cheap"，失败自动切换到 "premium"
response = router.completion(model="cheap", messages=messages)
```

这种策略在客服场景中可降低 60-80% 的 API 成本。

### 场景二：多供应商负载均衡

当某个供应商出现延迟或故障时，自动切换到备用供应商：

```yaml
model_list:
  - model_name: llama-3-70b
    litellm_params:
      model: together_ai/meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo
      api_key: os.environ/TOGETHER_API_KEY
  - model_name: llama-3-70b
    litellm_params:
      model: groq/llama3-70b-8192
      api_key: os.environ/GROQ_API_KEY
```

两个后端使用相同的模型别名 `llama-3-70b`，LiteLLM 自动在两者之间轮询。当 Groq 达到速率限制时，请求无缝路由到 Together AI。

### 场景三：多团队成本分摊

通过虚拟 Key 的 `metadata` 和 `team_id` 字段，可以实现精细化的成本追踪：

```bash
curl -X POST http://localhost:4000/key/generate \
  -H "Authorization: Bearer sk-master-xxx" \
  -d '{
    "max_budget": 500,
    "models": ["gpt-4o", "gpt-4o-mini"],
    "metadata": {"project": "chatbot-v2", "env": "production", "team": "ai-platform"},
    "team_id": "team-ai-platform"
  }'
```

在管理界面中，你可以按团队、项目、环境维度查看花费明细，精确到每一次 API 调用。

## LiteLLM 与 LangChain/LlamaIndex 集成

LiteLLM 最大的一个优势是**零成本集成**：因为它本身就是 OpenAI 兼容格式，LangChain 和 LlamaIndex 可直接使用。

### 与 LangChain 配合使用

```python
from langchain_openai import ChatOpenAI
import os

# 将 LangChain 指向 LiteLLM Proxy
os.environ["OPENAI_API_KEY"] = "sk-virtual-key-from-litellm"
os.environ["OPENAI_API_BASE"] = "http://localhost:4000"

llm = ChatOpenAI(model="claude-sonnet")  # 通过 Proxy 调用 Claude
response = llm.invoke("Hello!")
```

### 与 LlamaIndex 配合使用

```python
from llama_index.llms.openai import OpenAI

llm = OpenAI(
    api_key="sk-virtual-key",
    api_base="http://localhost:4000",
    model="gpt-4o"
)
```

**核心优势**：你的应用代码完全不用改，只需要改环境变量，就可以从直连 OpenAI 切换到通过 LiteLLM Proxy 管理的多模型架构。

## LiteLLM vs 替代方案：选哪个？

| 特性 | LiteLLM | Portkey | 直接集成 | LangChain 模型抽象 |
|------|---------|---------|----------|-------------------|
| 统一 API | ✅ 100+ 提供商 | ✅ 20+ 提供商 | ❌ 每套独立代码 | ⚠️ 仅支持部分 |
| 代理服务器 | ✅ 完整企业级 | ✅ 有 | ❌ 自建 | ❌ 无 |
| 虚拟密钥 | ✅ 原生支持 | ✅ 支持 | ❌ 自建 | ❌ 无 |
| 用量追踪 | ✅ 内置 | ✅ 内置 | ❌ 自建 | ⚠️ Callback |
| 负载均衡 | ✅ 多种策略 | ✅ 支持 | ❌ 自建 | ❌ 无 |
| 开源许可 | ✅ MIT | ❌ 部分开源 | N/A | ✅ MIT |
| 自托管 | ✅ 完全支持 | ⚠️ 有限 | N/A | N/A |

**选择建议**：
- **个人/小团队**：直接用 LiteLLM SDK 替换多供应商 SDK
- **中大型企业**：部署 LiteLLM Proxy 作为 LLM 网关
- **需要 AI 网关+安全**：可评估 Portkey（但 LiteLLM 的社区更大）

## 成本优化策略

企业使用 LiteLLM 最关心的往往是成本控制。以下是经过验证的优化策略：

1. **路由到最便宜的可满足需求的模型**：将简单查询路由到 GPT-4o-mini 或 Claude Haiku，复杂查询才用 GPT-4o
2. **使用开源替代**：通过 Groq 或 Together AI 运行开源模型，成本可降低 50-90%
3. **启用缓存**：对高频重复查询启用 Redis 缓存
4. **设置预算告警**：通过 Proxy 的预算功能为每个团队设置上限
5. **监控仪表板**：LiteLLM 内置 UI 展示实时花费、请求量、错误率

## 生产部署要点

### Docker 部署

```dockerfile
FROM ghcr.io/berriai/litellm:main-latest
COPY config.yaml /app/config.yaml
CMD ["--config", "/app/config.yaml", "--port", "4000"]
```

### Kubernetes 部署

LiteLLM 官方提供 Helm Chart：

```bash
helm repo add litellm https://berriai.github.io/litellm
helm install litellm litellm/litellm \
  --set config.master_key=sk-master-xxx
```

### 安全最佳实践

- 始终使用虚拟 Key，禁止直接使用供应商 API Key
- 启用请求/响应日志审计（可选排除消息内容以符合隐私要求）
- 使用 PostgreSQL 持久化用量数据
- 配置 SSL/TLS 终止
- 启用 RBAC（基于角色的访问控制）

## 常见问题 FAQ

**LiteLLM 是免费使用的吗？**

是的。LiteLLM SDK 和 Proxy 均采用 MIT 开源协议，完全免费。你只需支付实际调用模型提供商产生的 API 费用。企业版提供额外的 UI 支持和 SLA 保障。

**LiteLLM 支持哪些 LLM 提供商？**

截至 2025 年 5 月，LiteLLM 支持超过 100 个提供商，包括 OpenAI、Anthropic、Google Gemini、Azure OpenAI、AWS Bedrock、GCP Vertex AI、Groq、Cohere、Together AI、Ollama、vLLM、Hugging Face 等完整列表见 [官方文档](https://docs.litellm.ai/docs/providers)。

**LiteLLM 如何处理 API Key 管理？**

LiteLLM Proxy 提供虚拟 Key 系统：管理员持有 Master Key，为各团队/应用分配虚拟 Key。虚拟 Key 可独立设置预算、速率限制和可用模型列表，无需暴露真实供应商 API Key。

**LiteLLM 可以与自托管模型配合工作吗？**

完全可以。通过配置 Ollama、vLLM、TGI 或 Hugging Face Endpoints，你可以将本地或私有云部署的模型接入 LiteLLM Proxy，与商业 API 统一管理。

**LiteLLM SDK 和 Proxy 有什么区别？**

SDK 是一个 Python 库，在你的应用中直接调用，适合开发阶段快速切换模型。Proxy 是一个独立 HTTP 服务，提供虚拟 Key、负载均衡、用量追踪等企业级功能，适合生产环境部署。两者可以独立使用，也可以组合使用。

---

更多技术细节可参考 [LiteLLM GitHub 仓库](https://github.com/BerriAI/litellm) 和 [官方文档](https://docs.litellm.ai/docs/proxy)。

---

## 推荐基础设施

要 7×24 稳跑上述工具，服务器选择关键：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 $200 试用 60 天，全球 14+ 节点，一键 droplet 适配 AI 工作流。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟。**dibi8.com 自家所在 IDC**，生产验证。

*推广链接，不增加你的成本，能支持 dibi8.com 运营。*

