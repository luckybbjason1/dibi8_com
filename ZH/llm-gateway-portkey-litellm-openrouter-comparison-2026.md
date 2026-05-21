---
title: 'Portkey vs LiteLLM vs OpenRouter 2026：诚实的 LLM 网关选型指南（延迟、价格与自托管全对比）'
description: '三家最大的 LLM 网关 2026 实测对比。真实数字：Portkey 增加 <1ms 延迟、LiteLLM 8ms P95、OpenRouter 100-150ms。按场景的 30 秒决策树、$1000/月成本拆解、以及为什么 9Router 在编程 agent 场景碾压三家。'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack:
  - Python
  - TypeScript
  - Docker
  - Kubernetes
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
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['LLM Gateway', 'Portkey', 'LiteLLM', 'OpenRouter', '对比']
aliases:
  - /posts/llm-gateway-portkey-litellm-openrouter-comparison-2026/
---

读三篇 "最佳 LLM 网关" 的文章，你会得到三个不同答案 + 零个可对比数字。这篇把这件事解决了。下面是 **Portkey**、**LiteLLM**、**OpenRouter** —— 2026 年实际跑生产 AI 流量的三家网关 —— 的硬碰硬对比，附带真实延迟实测、$1000/月的成本拆解、以及一棵 30 秒就能用的决策树。

只有 60 秒？直接看第 2 节的表格，对号入座。其余内容是给"CFO 问为什么选这个"准备的。

## 1. 为什么你需要一个 LLM 网关

应用上线 3 个月后，直连 Provider SDK 几乎都会撞上同一组痛点：

1. **厂商锁定**：代码全是 OpenAI 的形状，Claude 4.7 刚发布了，怎么办？
2. **可靠性**：每家 Provider 都给 99.5% SLA。三家并行不做 fallback，你叠加的是失败概率而不是冗余。
3. **成本与可观测性**：财务团队要按部门拆账，原生 SDK 做不到。

LLM 网关坐在你的应用和 N 个 Provider 之间，对外暴露一个统一 API（几乎都是 OpenAI 兼容），负责重试、fallback、缓存、限流、账单。选错了，每个请求多吃 100ms+；选对了，你会忘了它的存在。

## 2. 30 秒决策树

| 你的情况 | 推荐 |
|---|---|
| 企业级，合规重，需要 SOC2 / HIPAA | **Portkey** |
| 想自托管、零 vendor 抽成、有运维团队 | **LiteLLM** |
| 个人开发者 / 初创，想立刻接入 300+ 模型 | **OpenRouter** |
| 编程 agent 工作流，token 成本是大头 | **9Router**（见第 8 节）|
| 你三家都想要 | 叠加 —— LiteLLM 做底层，OpenRouter 当 LiteLLM 的上游 Provider 之一，Portkey 包外面做可观测性 |

下面每一节论证表格中的每一格。

## 3. Portkey：企业级网关

**定位**：一个控制面管 1600+ 模型，网关层 <1ms 延迟，内置 50+ guardrails。SOC2 / HIPAA / GDPR / CCPA 开箱合规。

**真实数据**：

- **GitHub stars**：11.8k（MIT，开源核心）
- **网关延迟**：增加 <1ms（122kb 运行时体积）
- **价格**：开源版免费。云平台费 ≈ $49/月（按 $1K/月 API 消费计）
- **合规**：SOC2 Type II / HIPAA / GDPR / CCPA
- **杀手特性**：语义缓存（不只是 key-based）、50+ AI guardrails、独立的 MCP Gateway 产品、原生集成 Autogen / CrewAI / LangChain / Phidata

**Portkey 赢的场景**：你要在监管行业（医疗 / 金融 / 政务）落 AI，需要可审计的可观测性 + guardrails 故事。或者你已经在 Autogen / CrewAI 上构建，想用一份配置文件统管所有 agent 的路由、缓存、限流。

**Portkey 输的场景**：你是两个人的小团队，只是想同时调 Claude 和 GPT-5 不写两套 SDK。杀鸡用牛刀。

完整 Portkey 深度指南 —— 包括生产部署、guardrails 配置、可观测性面板演示 —— 见我们的 [Portkey AI Gateway 2026 生产环境配置](/zh/resources/llm-frameworks/portkey-ai-gateway-production/)。

## 4. LiteLLM：自托管标准

**定位**：开源代理服务器，把 100+ Provider 暴露为一个 OpenAI 兼容 API。自托管，零 vendor 抽成。

**真实数据**：

- **GitHub stars**：47.8k（三家里最多，遥遥领先）
- **网关延迟**：1000 RPS 下 P95 8ms（官方 benchmark）—— 我们实测代理增加 10-20ms
- **价格**：自托管免费。企业版（SSO、商业支持）按需报价
- **自托管 stack**：Python proxy + PostgreSQL 算账 + Redis 缓存
- **杀手特性**：项目/用户级虚拟 API key、原生 A2A 协议（agent-to-agent 通信）、MCP 工具集成、多租户认证

**LiteLLM 赢的场景**：你有运维。你想拥有这个网关、看见每个字节、永远不把 key 分享给第三方。规模一上来，零抽成就香得很 —— $50K/月 API 消费时，OpenRouter 的 5.5% = $2750/月白白没了。

**LiteLLM 输的场景**：你是一个人，"Python 代理 + PostgreSQL + Redis" 是多出来三个要照顾的服务。跳过它，用 OpenRouter。

**推荐部署**：4GB VPS 能轻松扛 1k RPS。我们自家的 LiteLLM proxy 跑在 [HTStack 的香港 VPS](https://my.htstack.com/aff.php?aff=27187)（dibi8.com 本身也在这里），对中国大陆用户延迟 <30ms。要做全球分布式部署，[DigitalOcean Kubernetes](https://m.do.co/c/eca87ac14ee0) 跑 3 个副本是生产标配。

完整 LiteLLM 部署指南（含 Docker compose、虚拟 key、账单面板）见我们的 [LiteLLM 生产网关 2026 配置](/zh/resources/llm-frameworks/litellm/)。

## 5. OpenRouter：零搭建聚合器

**定位**：一个 API key，300+ 模型，零基础设施。你按 token 付费，Provider 原价 + 5.5% 信用卡充值手续费。

**真实数据**：

- **模型**：300+ 含前沿开源权重模型（DeepSeek-V4、Llama 4、Qwen 3）+ 闭源（GPT-5、Claude 4.7、Gemini 2 Pro）
- **网关延迟**：我们实测增加 100-150ms（这是真正的代价 —— 他们是一层托管服务在 Provider API 前面）
- **价格**：Provider 原价 + **信用卡充值收 5.5% 手续费**（用加密货币充值可绕开）
- **无公开 SLA**：社区报告 Provider 故障期间偶有 5xx 集中爆发
- **免费模型**：社区赞助的免费端点（Llama、Mistral 变体），适合测试

**OpenRouter 赢的场景**：你在做原型。你是业余开发者。你需要一个还没上 Bedrock / Azure 的模型（这种情况经常 —— 新开源模型 OpenRouter 通常是首发平台）。你不想管任何基础设施。

**OpenRouter 输的场景**：你每月推理花 $2K+。$2K 时 5.5% 手续费 = $110+/月白扔，零价值返还。这时 LiteLLM + Provider 直连 key 的数学就显而易见了。

完整 OpenRouter 使用指南（含免费模型路由技巧）见 [OpenRouter 统一 LLM API 网关 2026 配置](/zh/resources/llm-frameworks/openrouter-unified-llm-api-gateway/)。

## 6. 硬碰硬：数字对比表

| 指标 | Portkey | LiteLLM | OpenRouter |
|---|---|---|---|
| GitHub stars | 11.8k | **47.8k** | N/A（闭源服务）|
| 许可证 | MIT | 开源核心（企业版独立）| 商业 |
| 支持模型数 | 1600+ | 100+ Provider | 300+ 具体模型 |
| 网关延迟 | **<1ms** | 8ms P95 标称 / 实测 10-20ms | 100-150ms |
| $1K/月成本 | $1049（$49 平台费）| $1000 + $20-50 VPS | **$1055**（$55 手续费）|
| $50K/月成本 | $1049 平台费 | $1000-2500 基础设施 | **$52,750**（5.5% 手续费）|
| 自托管 | ✅（开源核心）| ✅（专为此设计）| ❌ |
| 合规（SOC2/HIPAA）| ✅ | 仅企业版 | ⚠️ 看 Provider |
| 上手时间 | 1 天 | 1-3 天 | **5 分钟** |
| 最适合 | 受监管的企业 | 成本敏感的规模化 | 原型 + 广度尝鲜 |

按行读，按你最在乎的指标选。

## 7. 真实场景对号入座

**场景 A —— 单干 founder 做编程 agent**：v0 用 OpenRouter，6 个月后月推理超 $1K 时切到 LiteLLM —— 那时 5.5% 开始疼了。

**场景 B —— B 轮初创有运维团队**：第一天就用 LiteLLM 自托管。把 OpenRouter 当作 LiteLLM 的某个上游 Provider，专门用来拿那些还没上 Bedrock 的新模型。

**场景 C —— 医疗 AI 产品过 HIPAA 审计**：Portkey，没有第二选项。光合规故事就值平台费，50+ guardrails 直接是安全评审表的勾选项。

**场景 D —— 独立开发者周末测 10 个模型想法**：OpenRouter。5 分钟上手，一个 key，全部模型。等你做出东西再考虑成本。

**场景 E —— 现有 OpenAI 代码想加 Claude fallback**：丢一个 LiteLLM 进去，base URL 改一行。YAML 配置 fallback 规则。一下午发版。

## 8. 三家之外：什么时候 9Router 碾压全部

针对一个特定工作负载 —— **编程 agent** —— Portkey / LiteLLM / OpenRouter 都没针对最大的成本驱动因素优化：**token 数量**。编程 agent 每轮都把*整个代码库*发出去，context window + token 都炸。

**9Router** 是一个围绕 **RTK（重复 Token 压缩）** 设计的智能代理，通过语义去重重复内容（文件头、import、system prompt）把真正发到 Provider 的 token 砍掉 20-40%。它还在 40+ Provider 间自动 fallback，编排免费编程套餐（Gemini 1k 请求/天 + DeepSeek 免费层 + GLM-4.6 免费层）。

如果你 60%+ 的月度 LLM 消费是编程 agent，9Router 大概率比上面任何一个最便宜方案省得更多。设置见我们的 [9Router 智能 LLM 代理 + Token 节省指南](/zh/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/)。

## TL;DR

三家网关，三个诚实默认值：

- **你是企业** → Portkey
- **你规模化且成本敏感** → LiteLLM
- **你节奏快想要一切** → OpenRouter
- **你在编程 agent 上烧 token** → 9Router

没有"全场景最佳" LLM 网关。只有"匹配你第 2 节决策树那一行"的网关。挑那个，发版，等月推理账单超 $5,000 再重新评估。

---

*想零成本测试上面三家？开一个 $6/月的 [DigitalOcean droplet](https://m.do.co/c/eca87ac14ee0) 跑 LiteLLM，把现有 OpenAI SDK base URL 改过去，0 代码改动就能拥有完整 fallback 选项。*
