---
title: Polymarket Agents：构建预测市场 AI 自动交易机器人的开源框架
description: Polymarket Agents 是一个开源开发者框架，用于构建在 Polymarket 预测市场上进行 AI 自主交易的智能代理。
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Docker
- Python
- TypeScript
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "107 KB"
file_md5: ''
download_url: https://github.com/Polymarket/agents
backup_url: ''
github_repo: https://github.com/Polymarket/agents
stars: 3513
maintainer: "Polymarket"
last_maintained: "2024-11-05"
featureImage: ''
draft: false
aliases:
- /zh/posts/polymarket-agents-ai-trading-bot-framework/
faqs:
  - q: '什么是 Polymarket Agents？'
    a: 'Polymarket Agents 是一个开源、采用 MIT 许可的开发者框架，用于构建在 Polymarket 预测市场上自主交易的 AI 智能体。它提供了分析市场的工具，可对接 Polymarket API 获取实时数据，并自动执行交易。'
  - q: '运行 Polymarket Agents 之前我需要做哪些准备？'
    a: '你需要在 .env 文件中设置 Polygon 钱包私钥和 OpenAI API key，还需要一个安装了 requirements.txt 中依赖的 Python 3.9 虚拟环境。此外，你必须为 Polygon 钱包充入 USDC，因为 Polymarket 上的交易以 USDC 结算。'
  - q: 'Polymarket Agents 如何利用 RAG 做出交易决策？'
    a: '它使用 Chroma 向量数据库来存储新闻文章和市场数据，将文本转换为 embeddings 以进行语义检索，根据当前市场背景检索相关信息，并让 LLM 将检索到的数据综合成交易决策。'
  - q: 'Polymarket Agents 支持哪些交易策略？'
    a: '该框架支持基于新闻的交易（由 LLM 对事件进行情绪分析）、跨相关市场的套利检测、基于成交量和价格走势的趋势跟随，以及利用 RAG 查询历史数据的基本面分析。'
  - q: '如何用 Polymarket Agents CLI 执行一笔交易？'
    a: '运行 CLI 命令 ''python scripts/python/cli.py trade --market-id <MARKET_ID> --side buy --size <SIZE>''。你也可以用 ''get-all-markets --sort-by volume'' 列出市场，或用 ''get-market --market-id <MARKET_ID>'' 查看单个市场。'
---
{</* resource-info */>}

![Polymarket Agents CLI 命令清单](/images/articles/polymarket-agents-ai-trading-bot-framework/cli.png)
*Polymarket Agents CLI — 官方截图来自 [github.com/Polymarket/agents](https://github.com/Polymarket/agents)*

## Polymarket Agents 是什么？

**Polymarket Agents** 是一个开源的开发者框架和工具集，用于构建在 **Polymarket** —— 全球最大的预测市场平台 —— 上进行 AI 自主交易的智能代理。

这个框架使开发者能够：
- 🤖 构建分析市场并自动执行交易的 AI 代理
- 📊 集成 Polymarket API 获取实时市场数据
- 🔍 使用 RAG（检索增强生成）做出明智的交易决策
- 📰 从博彩服务、新闻提供商和网络搜索获取数据
- 🧠 利用全面的 LLM 工具进行提示工程和市场分析

🔗 **GitHub**: [https://github.com/Polymarket/agents](https://github.com/Polymarket/agents)

---

## 什么是 Polymarket？

**Polymarket** 是一个去中心化的预测市场平台，用户可以在上面交易现实世界事件的结果：

- **政治** — 选举结果、政策决策
- **加密货币** — 比特币价格预测、ETF 批准
- **体育** — 比赛结果、冠军得主
- **科学** — 研究突破、太空任务
- **娱乐** — 奖项得主、票房结果

交易者根据预测购买"是"或"否"的股份，价格反映市场共识概率。

---

## 核心功能

| 功能 | 说明 |
|------|------|
| **Polymarket API 集成** | 完整访问市场数据、订单簿和交易执行 |
| **AI 代理工具** | 构建自主交易代理的工具 |
| **本地和远程 RAG** | 新闻和市场数据检索的向量数据库支持 |
| **多源数据** | 博彩服务、新闻 API、网络搜索集成 |
| **LLM 提示工程** | 上下文感知推理的综合工具 |
| **CLI 界面** | 市场分析和交易的命令行工具 |
| **Docker 支持** | 容器化部署，易于设置 |
| **MIT 许可证** | 免费开源 |

---

## 架构

Polymarket Agents 采用模块化组件设计，可由社区维护和扩展：

### 核心 API

| 组件 | 用途 |
|------|------|
| **Chroma.py** | 新闻源和 API 数据的向量数据库 |
| **Gamma.py** | Polymarket Gamma API 客户端，获取市场元数据 |
| **Polymarket.py** | 主要 API 类，用于市场数据和交易执行 |
| **Objects.py** | 交易、市场、事件的 Pydantic 数据模型 |

### CLI 命令

与 Polymarket 交互的主要用户界面：

```bash
# 获取按交易量排序的所有市场
python scripts/python/cli.py get-all-markets --limit 10 --sort-by volume

# 获取特定市场详情
python scripts/python/cli.py get-market --market-id <MARKET_ID>

# 执行交易
python scripts/python/cli.py trade --market-id <MARKET_ID> --side buy --size <SIZE>
```

---

## 快速入门

### 1. 克隆仓库

```bash
git clone https://github.com/polymarket/agents.git
cd agents
```

### 2. 设置环境

```bash
# 创建虚拟环境
virtualenv --python=python3.9 .venv
source .venv/bin/activate

# 安装依赖
pip install -r requirements.txt
```

### 3. 配置 API 密钥

创建 `.env` 文件：

```env
POLYGON_WALLET_PRIVATE_KEY="你的钱包私钥"
OPENAI_API_KEY="你的OpenAI API密钥"
```

### 4. 钱包充值 USDC

向你的 Polygon 钱包转入 USDC 用于交易。

### 5. 运行 CLI

```bash
# 设置 Python 路径
export PYTHONPATH="."

# 运行 CLI
python scripts/python/cli.py
```

或直接执行交易：

```bash
python agents/application/trade.py
```

### 6. Docker 替代方案

```bash
./scripts/bash/build-docker.sh
./scripts/bash/run-docker-dev.sh
```

---

## 交易策略

Polymarket Agents 支持多种 AI 驱动的交易策略：

### 1. 新闻驱动交易
- 监控新闻源获取事件进展
- 使用 LLM 分析情绪和影响
- 基于预测结果执行交易

### 2. 套利检测
- 比较相关市场的价格
- 识别定价错误的概率
- 执行无风险套利交易

### 3. 趋势跟踪
- 分析市场交易量和价格变动
- 识别特定市场的动量
- 顺势而为获取利润

### 4. 基本面分析
- 研究事件背景和因素
- 使用 RAG 查询历史数据
- 做出明智的预测

---

## 数据源

该框架集成多个数据源：

| 数据源 | 类型 | 用途 |
|--------|------|------|
| **新闻 API** | 实时新闻 | 事件跟踪 |
| **网络搜索** | 一般信息 | 背景研究 |
| **博彩服务** | 赔率比较 | 价格发现 |
| **社交媒体** | 情绪分析 | 趋势检测 |
| **链上数据** | 交易数据 | 市场情报 |

---

## RAG 实现

用于明智交易的检索增强生成：

1. **向量数据库** — Chroma DB 存储新闻文章和市场数据
2. **嵌入** — 将文本转换为向量进行语义搜索
3. **检索** — 基于市场上下文查询相关信息
4. **生成** — LLM 将检索到的数据综合为交易决策

---

## 风险管理

自动交易的重要考虑因素：

| 风险 | 缓解措施 |
|------|---------|
| **市场风险** | 仓位控制、止损 |
| **流动性风险** | 在高交易量市场交易 |
| **模型风险** | 实盘交易前回测策略 |
| **操作风险** | 定期监控机器人性能 |
| **监管风险** | 遵守当地法规 |

---

## 与其他工具对比

| 功能 | Polymarket Agents | 自定义机器人 | 手动交易 |
|------|------------------|------------|----------|
| **开源** | ✅ | 视情况而定 | 不适用 |
| **AI 集成** | ✅ | 可选 | ❌ |
| **RAG 支持** | ✅ | 很少 | ❌ |
| **多源数据** | ✅ | 可选 | ❌ |
| **CLI 界面** | ✅ | 视情况而定 | 不适用 |
| **社区** | ✅ | 视情况而定 | ❌ |
| **速度** | 快 | 快 | 慢 |
| **无情绪** | ✅ | ✅ | ❌ |

---

## 使用场景

### 1. 政治事件交易
- 选举结果
- 政策决策
- 立法投票

### 2. 加密货币市场预测
- 比特币价格走势
- ETF 批准
- 监管决策

### 3. 体育博彩
- 比赛结果
- 冠军得主
- 球员表现

### 4. 娱乐市场
- 奖项得主
- 票房预测
- 真人秀结果

---

## 相关仓库

| 仓库 | 用途 |
|------|------|
| [py-clob-client](https://github.com/Polymarket/py-clob-client) | Polymarket CLOB 的 Python 客户端 |
| [python-order-utils](https://github.com/Polymarket/python-order-utils) | 订单生成和签名 |
| [clob-client](https://github.com/Polymarket/clob-client) | CLOB 的 TypeScript 客户端 |
| [Langchain](https://github.com/langchain-ai/langchain) | 上下文感知推理 |
| [Chroma](https://docs.trychroma.com) | 向量数据库 |

---

## 阅读资源

- [预测市场：瓶颈与下一个突破](https://mirror.xyz/1kx.eth/jnQhA56Kx9p3RODKiGzqzHGGEODpbskivUUNdd7hwh0)
- [加密货币 + AI 应用](https://vitalik.eth.limo/general/2024/01/30/cryptoai.html) 作者：Vitalik Buterin
- [超级预测](https://hbr.org/2016/05/superforecasting-how-to-upgrade-your-companys-judgment)

---

## 相关文章

- [28 Tools Behind a $1M Polymarket Trading Bot: Full Stack Breakdown](/zh/resources/dev-utils/polymarket-trading-bot-stack/) — 完整的交易机器人架构
- [Free Claude Code：让 Claude Code CLI 免费使用的开源代理工具](/zh/resources/ai-tools/free-claude-code-open-source-proxy/) — AI 编程助手

---

## 总结

**Polymarket Agents** 为在预测市场上构建 AI 驱动的交易机器人提供了坚实的基础。模块化架构、全面的 API 集成和 RAG 能力使其适合初学者和经验丰富的开发者。

**最适合**：对算法交易、预测市场和 AI 驱动决策感兴趣的开发者

**GitHub**: [https://github.com/Polymarket/agents](https://github.com/Polymarket/agents)

---

*最后更新：2026-05-06*

---

## 推荐自托管基础设施

要 7×24 稳定跑这套，服务器选择很关键：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心。开源 AI 工具自托管首选。
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — 香港 VPS，国内访问低延迟。**这就是 dibi8.com 自家所在的 IDC**，生产环境已验证。

*以上为推广链接，不会增加你的成本，但能支持 dibi8.com 持续运营。*

