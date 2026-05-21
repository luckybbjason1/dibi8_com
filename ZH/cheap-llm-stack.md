---
title: '便宜跑大模型 Stack 2026：用免费层 + Token 压缩把生产 AI 月成本压到 $0-15'
description: '5 组件 stack 跑真实 AI 负载月成本 $0-15：Ollama 本地 + DeepSeek API + Gemini 免费层 + RTK 压缩 + 9Router 编排。真实成本数学、按任务类型的模型选择、组装顺序。'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Python
  - Docker
  - Go
  - Rust
application_domain: Collections
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
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['collections']
tags: ['便宜大模型', '免费层', '成本优化', 'Stack', '合集']
aliases:
  - /posts/cheap-llm-stack/
---

大部分"LLM 成本优化"建议就是"用便宜的模型"。这个合集野心更大：**5 组件 stack 处理真实生产负载（编程 agent、内容生成、搜索、基础 agent）月总成本 $0-15**。不是玩票。不是"100 请求/天还行"。真正的日常生产推理，价格能把 SaaS 干死。

诀窍不是单个工具 —— 是编排。免费层封顶请求数，不封顶输出；本地模型封顶质量，不封顶请求；token 压缩砍计费支出；智能路由把每个任务发给最便宜能干的 provider。组合起来，数学结果荒唐到笑。

## TL;DR —— Stack 全貌

| # | 组件 | 成本 | 角色 | 深度指南 |
|---|---|---|---|---|
| 1 | **Ollama**（本地）| $0 | 重/敏感负载在自己硬件上 | [Ollama 指南](/zh/resources/llm-frameworks/ollama/) |
| 2 | **DeepSeek API** | $2-8/月 | 硬任务便宜推理（$0.27/M 输入 vs Claude $3）| [DeepSeek vs OpenAI](/zh/resources/llm-frameworks/deepseek-ds4-vs-openai-api/) |
| 3 | **Gemini CLI 免费层** | $0 | 1000 请求/天，通用 LLM 任务，免费 | [AI 搜索工具](/zh/resources/ai-tools/ai-search-tools-perplexity-gemini-chatgpt/) |
| 4 | **RTK 代理** | $0（自托管）| 进入计费 API 前压缩 prompt 20-40% | [RTK 设置](/zh/resources/llm-frameworks/rtk-rust-cli-proxy-ai-token-saver/) |
| 5 | **9Router** | $0（自托管）| 自动按任务路由到最便宜能干的 provider | [9Router 指南](/zh/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/) |

**月成本总计**（轻：100 次/天）：**$0-3** • **中**（500 次/天）：**$2-8** • **重**（2000 次/天）：**$5-15**

对比纯 API 同量级：分别 $40 / $200 / $800。**生产规模下省 20-50×**。

## 1. "便宜"为何 2026 才可行

过去 12 个月三件事变了：

1. **DeepSeek-V4 用 1/10 价格打到 Claude Sonnet 质量**（输入 $0.27/M vs $3/M）。80% 任务里质量差距无所谓
2. **免费层认真起来了**：Gemini 给 1000 免费请求/天，GLM-4.6 出免费层，OpenRouter 轮换社区赞助免费模型。组合预算 ~3000 免费调用/天
3. **RTK（Repetition-Token Compression）真好用**：去掉 20-40% 纯冗余 token（文件头、system prompt 每 session 重复 10×）

堆这三个 —— 本地 fallback + 便宜 API + 免费层轮换 + 压缩 —— 便宜质量前沿往前推得很猛。

## 2. 架构 —— 智能路由模式

```
   你的应用
       │
       ▼
   9Router（决定每个调用去哪）
       │
       ├─► 本地 Ollama         （敏感 / 离线 / 草稿）
       │
       ├─► RTK 代理 → DeepSeek （要质量的硬任务，压缩过）
       │
       ├─► Gemini 免费层       （1k 请求/天，简单任务）
       │
       └─► OpenRouter 免费     （轮换社区模型，实验）
```

每个 provider 有"专长区"。9Router（或不想加新服务就写 10 行 Python 包装器）检查任务后路由。

## 3. 组件 1 —— Ollama（本地，$0）

**角色**：敏感的、不想被计费的、草稿质量的，全归它。

**消费级硬件实测**（2026 数字）：
- **8 GB RAM**（M1 / 中端 PC）：Llama 3.2 3B 跑 20+ tok/秒 —— 自动补全、分类、草稿写作够用
- **16 GB RAM**（M2/M3 / 不错的 PC）：Qwen 3 Coder 14B 15 tok/秒 —— 生产级编程
- **32 GB RAM**（Mac Studio / 工作站）：Llama 3.3 70B Q4 8 tok/秒 —— Claude Sonnet 同级质量，慢点

**免费，永久，无 rate limit**。唯一成本是机器跑的电费。

完整安装 + 模型选择：[Ollama 生产指南](/zh/resources/llm-frameworks/ollama/)。

## 4. 组件 2 —— DeepSeek API（$2-8/月）

**角色**：本地不够好时，你的默认付费 provider。

**为什么价格/质量碾压所有人**：
- DeepSeek-V4 $0.27/M 输入 token vs Claude Sonnet $3/M vs GPT-5 $2.50/M
- 编程 benchmark 与 Claude Sonnet 平均差 ~5%
- 低峰时段再给 50% 折扣（UTC 16:30-00:30）

**诚实 tradeoff**：小众话题幻觉略多。冷启动略慢。批量推理省 11× 成本，值。

**快速开始** —— 在 platform.deepseek.com 注册，$10 credits 单干 dev 撑 2-3 个月。

完整设置 + 什么时候*不要*用 DeepSeek：[DeepSeek-V4 vs OpenAI API 对比](/zh/resources/llm-frameworks/deepseek-ds4-vs-openai-api/)。

## 5. 组件 3 —— Gemini CLI 免费层（$0）

**角色**：通用任务（Q&A、摘要、简单编程）免费 1000 请求/天。

**数学**：1000 调用/天 × 30 天 = 30,000 调用/月免费。UTC 午夜前烧光就 fallback 到 DeepSeek。

**注意点**：Google 在免费层会记录你的 prompt 做"模型改进" —— 别发专有代码或 PII。

**快装**：
```bash
npm install -g @google/gemini-cli
gemini auth login  # 开浏览器，用你的 Google 账号
gemini "解释这个正则：/^[a-z]+$/i"
```

或直接调 Gemini REST API —— 同 1000/天预算。

伴侣综览：Gemini vs Perplexity vs ChatGPT 免费层各自强项：[AI 搜索工具对比](/zh/resources/ai-tools/ai-search-tools-perplexity-gemini-chatgpt/)。

## 6. 组件 4 —— RTK 代理（$0，自托管）

**角色**：坐在你的应用和任意付费 API 之间。在每次调用前压缩重复内容（system prompt、文件头、文档片段）。**不改代码，账单少 20-40%。**

**原理**：语义去重。同一份 2000-token system prompt 今天发了 50 次，RTK 第 2 次起识别它，发个指针而不是完整文本。

**快装**：
```bash
docker run -d --name rtk -p 8765:8765 \
  ghcr.io/rtk-ai/rtk:latest
```

把 API base URL 从 `https://api.deepseek.com/v1` 改成 `http://localhost:8765/v1/deepseek`，完事。

RTK 工作原理 + benchmark 完整深度：[RTK Rust CLI 代理 + token 节省](/zh/resources/llm-frameworks/rtk-rust-cli-proxy-ai-token-saver/)。

## 7. 组件 5 —— 9Router（$0，自托管）

**角色**：编排器。按任务类型、剩余预算、provider 可用性决定每个调用归谁。

**为什么要它**：没 9Router 你每个调用手挑 provider。有 9Router 你定一次规则（"编程任务 → DeepSeek via RTK，简单 Q&A → Gemini 免费，fallback → Ollama"）然后忘掉。

**附加值**：9Router 自带 RTK 压缩层给 premium provider 用，加自动 fallback —— 免费层撞当日上限时自动切。

**快装**：
```bash
docker run -d --name 9router -p 9999:9999 \
  -e PROVIDERS=ollama,deepseek,gemini,openrouter \
  ghcr.io/rtk-ai/9router:latest
```

完整配置 + 免费编程套餐配方：[9Router 智能代理指南](/zh/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/)。

## 8. 路由表 —— 谁干什么

单干 dev 的可用默认路由配置：

| 任务类型 | Provider | 为什么 |
|---|---|---|
| 内联代码补全 | **Ollama**（Qwen 3 Coder 14B 本地）| 延迟比质量重要 |
| 代码生成（函数级）| **DeepSeek-V4 via RTK** | 质量重要，压缩省钱 |
| 多文件 refactor | **DeepSeek-V4 via RTK** 或 fallback **Claude** | 硬任务，DeepSeek 卡住就上 premium |
| 通用 Q&A / 解释代码 | **Gemini 免费层** | 免费、快、够用 |
| 联网搜索 + 引用 | **Gemini 免费层**（自带 grounding）| 免费 vs $20/月 Perplexity Pro |
| 敏感代码 review | **Ollama** 本地 | 永不出本机 |
| 批量内容生成（1000+ 篇）| **DeepSeek-V4 低峰**| 便宜 × 50% 低峰折扣 = $0.135/M |
| 简单 agent（Slack bot / 排程）| **Gemini 免费层** | 简单任务 1k/天够用 |

## 9. $0-15/月 数学

**轻使用**（单干 dev，平均 100 调用/天）：
- Gemini 免费覆盖 ~70% → $0
- DeepSeek 处理另 30%（~900 调用/月，多数小）→ $1-3
- Ollama 跑敏感（无 API 费）→ $0
- **总计：$1-3/月**（vs 纯 API $40+）

**中使用**（500 调用/天，含部分编程）：
- Gemini 免费：还有 ~1000 调用/天空间
- DeepSeek 做认真编程：~3000 调用/月配 RTK 压缩 → $3-8
- Ollama fallback → $0
- **总计：$3-8/月**（vs 纯 API $200+）

**重使用**（2000 调用/天，agent 工作流）：
- Gemini 上午 10 点就烧完，fallback 接管
- DeepSeek 重负载，RTK 省 ~30% → $5-12
- 低峰批量任务 → 再省 50%
- Ollama 跑批量分类、敏感 → $0
- **总计：$5-15/月**（vs 纯 API $800+）

## 10. Day 1 安装顺序（60 分钟）

1. **Ollama**（15 分）—— 装、拉 Llama 3.2 3B + Qwen 3 Coder 14B
2. **DeepSeek 账号**（5 分）—— 注册、拿 API key、充 $10
3. **Gemini CLI**（5 分）—— `npm i -g @google/gemini-cli`，Google 账号授权
4. **RTK 代理**（10 分）—— Docker run，指向 DeepSeek
5. **9Router**（10 分）—— Docker run，配 4 provider
6. **测路由**（15 分）—— 发 5 种不同任务，确认每种命中预期 provider

60 分钟后，你机器上有真正生产级的便宜 LLM 路由器。

## 11. 何时升级（升到什么）

$0-15 stack 撑到你撞上以下任一情况：

- **延迟需求 < 500ms** —— 加 Claude/GPT-5 跑热路径（DeepSeek 留批量）
- **合规要求只用美国数据 provider** —— 砍 DeepSeek + Gemini，用 OpenRouter + provider filtering 或自托管更多
- **批量负载需要 SLA** —— 加托管 LiteLLM 网关 + 多付费 provider + 重试逻辑（看 [LiteLLM 网关 2026](/zh/resources/llm-frameworks/litellm/)）
- **要完整可观测性** —— 加 Portkey（$1k 消费时 $49 平台费，看 [Portkey vs LiteLLM 2026](/zh/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/)）

要点：这个 stack *不是*天花板，是地板 —— 让你 deliberately 扩支出而不是被迫从第一天买 $200/月 SaaS 套餐。

## TL;DR —— Recipe

**5 工具，$0-15/月，60 分钟搭好**：
1. **Ollama** —— 本地 & 敏感
2. **DeepSeek-V4** —— 便宜 API 跑硬任务
3. **Gemini CLI 免费层** —— 1k 请求/天免费通用 LLM
4. **RTK 代理** —— 计费 API 上 20-40% token 节省
5. **9Router** —— 智能路由编排

你当前 AI SaaS 月支出 $30+ 的话这 stack 立刻回本。在笔记本上跑就行（便宜 LLM 不必非要 VPS —— 但 {{< aff "digitalocean" "footer-cta" "$6/月 DigitalOcean droplet" >}} 适合团队常驻）。

---

*这个合集和 [自托管 AI 编程工作流](/zh/collections/self-hosted-ai-coding-workflow/) 配套食用最佳 —— 共享 Ollama + 9Router + RTK 三个底层组件。*
