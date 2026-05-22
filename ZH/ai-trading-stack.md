---
title: 'AI 量化交易 Stack 2026：7 组件开源量化工作流（加密 + 预测市场）'
description: '自托管 AI 交易 stack：ta-lib（信号）+ vectorbt（回测）+ freqtrade（执行）+ AI Trader（AI 策略层）+ Hyperliquid（perp DEX 场所）+ Polymarket Agents（预测市场）+ Minara（AI+crypto hub）。$30-150/月基础设施，真生产级量化管线，不是玩具。'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack: [Python, Docker, PostgreSQL, WebSocket]
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
tags: ['AI 交易', '量化', '加密货币', 'Hyperliquid', 'Polymarket', 'Stack', '合集']
aliases:
  - /posts/ai-trading-stack/
---

> ⚠️ **免责声明**：本文是构建 AI 交易 stack 的技术指南，**不是投资建议**。量化交易有实质性的资本损失风险。部署真金前在 paper / testnet 上充分测试。过去回测表现不预测未来收益。

2026 散户量化的工具栈终于追上 2018 年对冲基金的水平：每一层都有开源框架、AI 增强策略、无中介把关的链上场所。和 SaaS 量化平台（3Commas $74/月、Cryptohopper $129/月、TradingView Premium $59/月）的取舍是学习曲线更陡 但**完全控制 + 零按笔手续费 + 你的 alpha 永不离开你的机器**。

这个合集组装 **7 组件**，覆盖信号生成 → 回测 → 实盘执行 → AI 策略层 → 场所 → 预测市场 → AI+crypto 用户友好 hub。基础设施成本 $30-150/月。你实际投入交易资本的组件你自己负责。

## TL;DR —— Stack 全貌

| # | 组件 | 层 | 角色 | 深度指南 |
|---|---|---|---|---|
| 1 | **ta-lib** | 信号 | 200+ 技术指标（RSI / MACD / Bollinger 等）| [ta-lib 指南](/zh/resources/ai-trading/ta-lib-technical-analysis-trading/) |
| 2 | **vectorbt** | 回测 | 向量化 Python 回测，比 for 循环快 100× | [vectorbt 2026](/zh/resources/ai-trading/vectorbt-quantitative-backtesting/) |
| 3 | **freqtrade** | 执行 | 生产级加密交易机器人，交易所无关 | [freqtrade AI 策略](/zh/resources/llm-frameworks/freqtrade-ai-trading-strategies/) |
| 4 | **AI Trader** | AI 策略 | LLM 驱动的策略生成 + 强化学习 | [AI trader 指南](/zh/resources/llm-frameworks/ai-trader/) |
| 5 | **Hyperliquid** | 场所 | 2026 顶 perp DEX，链上 order book，低费 | [Hyperliquid perp 交易](/zh/resources/ai-trading/hyperliquid-perp-dex-trading/) |
| 6 | **Polymarket Agents** | 预测市场 | AI agent 自主交易预测市场 | [Polymarket Agents](/zh/resources/llm-frameworks/polymarket-agents-ai-trading-bot-framework/) |
| 7 | **Minara** | AI+Crypto Hub | 加密/股票/商品 AI 接口，基于 Hyperliquid | [Minara AI 交易评测](/zh/resources/ai-trading/minara-ai-trading-hyperliquid-review-2026/) |

**基础设施总成本**（不含交易资本）：单干 dev **$30-80/月** • 多策略并发的小基金 **$80-150/月**

对比 SaaS 量化平台：3Commas Pro（$74）+ TradingView Premium（$59）+ CoinTracking（$21）= $154/月，且有 rate limit、IP 限执行、无法访问你策略代码源。

## 1. 为什么 2026 自建 AI 交易 stack

三股汇合：

1. **链上 perp DEX 主流深度达到** —— Hyperliquid 头部交易对 order book 达到 CEX 级流动性，秒级链上结算
2. **AI 策略生成真能用** —— LLM（Claude 4 / GPT-5）能读回测、提策略参数调整建议、out-of-sample 验证站得住脚，不只是曲线拟合
3. **无 API key 场所 + 加密通道** —— 钱包交易意味着没 SaaS 服务商能限制你、锁你的 key、或借"合规审查"采你的策略

2026 散户搭这个 stack 拥有 2018 对冲基金每座 $50k 的工具。

## 2. 架构 —— 信号 → 回测 → 实盘 → AI 循环

```
   ┌──────────────────────────────────────────────────┐
   │ 市场数据（websocket / REST）                     │
   │  - Hyperliquid order book + trades               │
   │  - Polymarket 预测市场赔率                       │
   │  - CEX（Binance / OKX）跨场所套利               │
   └────────────────┬─────────────────────────────────┘
                    │
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ 信号层：ta-lib                                   │
   │  → RSI / MACD / Bollinger / 200+ 指标            │
   └────────────────┬─────────────────────────────────┘
                    │
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ 回测：vectorbt                                   │
   │  → 跨年数据向量化，秒级                          │
   │  → 滚动 walk-forward 优化                        │
   └────────────────┬─────────────────────────────────┘
                    │（策略验证）
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ 执行：freqtrade 或 Hyperliquid 直连              │
   │  → CEX：freqtrade（Binance / OKX /...）          │
   │  → DEX：Hyperliquid Python SDK 直连              │
   │  → 预测：Polymarket Agents                       │
   └────────────────┬─────────────────────────────────┘
                    │
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ AI 循环：AI Trader                               │
   │  → 读实时 PnL + 市场数据                         │
   │  → 提策略调整                                    │
   │  → 交回 backtest 验证                            │
   └──────────────────────────────────────────────────┘
```

不会写代码想要 AI agent 体验的用户：**Minara** 在 Hyperliquid 之上提供用户友好 hub 层。

## 3. 组件 1 —— ta-lib（信号生成）

**角色**：信号层。RSI / MACD / Bollinger Bands / ADX 等所有 200+ 经典技术指标，一个快速 C 库带 Python 绑定。

**为什么选它**：30+ 年实战检验。每个量化框架要么用 ta-lib 要么重实现它的函数。用原版。

**快装**：
```bash
# Linux
apt install libta-lib-dev
pip install TA-Lib

# 或预编译 wheel:
pip install TA-Lib-Precompiled
```

**Hello world** —— 1000 根 K 线计算 RSI <10ms：
```python
import talib
import numpy as np
close = np.random.random(1000)
rsi = talib.RSI(close, timeperiod=14)
```

完整指南含 walk-forward 指标组合模式：[ta-lib 技术分析交易](/zh/resources/ai-trading/ta-lib-technical-analysis-trading/)。

## 4. 组件 2 —— vectorbt（回测）

**角色**：跨年数据秒级回测策略，不是几分钟。向量化 numpy 操作比 Backtrader 等 for-loop 回测快 50-100×。

**为什么选它**：walk-forward 优化、参数扫描、蒙特卡洛模拟、Sharpe / Sortino / Calmar 指标、仓位大小 —— 全内置。严肃散户量化的事实选择。

**快装**：
```bash
pip install vectorbt
```

**回测例**——1 年 BTCUSDT 上的布林带挤压：
```python
import vectorbt as vbt
import yfinance as yf

data = yf.download("BTC-USD", start="2024-01-01")["Close"]
bb = vbt.IndicatorFactory.from_talib("BBANDS").run(data)
entries = data < bb.lowerband
exits = data > bb.upperband

pf = vbt.Portfolio.from_signals(data, entries, exits, init_cash=10000, fees=0.001)
print(pf.stats())  # Sharpe / 回撤 / 总收益等
```

完整指南含 walk-forward 和蒙特卡洛：[vectorbt 量化回测](/zh/resources/ai-trading/vectorbt-quantitative-backtesting/)。

## 5. 组件 3 —— freqtrade（CEX 实盘执行）

**角色**：中心化交易所交易的执行层（Binance / OKX / Kraken / KuCoin / Coinbase Pro 等 20+）。生产级 —— 处理订单管理、错误恢复、仓位跟踪、交易所 rate limit。

**为什么选它**：~31k GitHub stars，5+ 年实战。策略热加载、dry-run 模式（实时数据上的纸面交易）、Telegram bot 集成、web UI、Docker 部署。开源 CEX 交易机器人默认。

**快装**：
```bash
docker compose -f https://github.com/freqtrade/freqtrade/raw/stable/docker-compose.yml up -d
# UI at http://localhost:8080
```

策略 `.py` 丢进 `user_data/strategies/`，配交易所 API key，dry-run 起步，验证 2 周，切实盘。

部署在低延迟 VPS —— 我们内部 freqtrade 实例跑在 {{< aff "htstack" "trading-vps-hk" "HTStack 的香港 VPS" >}} 上拿亚洲交易所 sub-50ms 延迟，或 {{< aff "digitalocean" "trading-vps-us" "DigitalOcean droplet" >}} 在纽约给偏美场所。

完整设置含 AI 策略模式：[freqtrade AI 交易策略](/zh/resources/llm-frameworks/freqtrade-ai-trading-strategies/)。

## 6. 组件 4 —— AI Trader（AI 策略层）

**角色**："AI 交易"里的"AI"。读实时 PnL、市场体制、最近回测结果 —— 提参数调整和新策略候选。把人类"我觉得市场变了"的直觉和系统化回测管线桥起来。

**为什么这重要**：静态策略衰减。2026 年 5 月的加密市场不是 2024 年 1 月的市场。没调整循环时，你策略的 edge 在 6-12 个月内被侵蚀。AI Trader 是唯一专为此循环广泛采用的开源框架。

**快装**：
```bash
pip install ai-trader
# 配 LLM provider（Claude / DeepSeek / Gemini）
```

模式：AI Trader 每晚跑，读前日 PnL + 市场数据，生 5-10 策略变体候选，交 vectorbt 做 walk-forward 验证，浮出顶 1-2 给人审，再通过 freqtrade 部署。

完整设置：[AI Trader 指南](/zh/resources/llm-frameworks/ai-trader/)。

## 7. 组件 5 —— Hyperliquid（Perp DEX 场所）

**角色**：链上 perp DEX 场所。到 2026 年 Hyperliquid 是 Binance 之外最深的 perp order book —— 且不像 Binance 没 KYC 屏蔽、没提现限额、链上结算可审计。

**为什么这对 AI 交易重要**：通过钱包签名直接 Python SDK 访问意味着无需管 API key、无 rate limit（除了 gas 等效的链上限）。代码里执行策略不碰 CEX 仪表盘。

**快装**：
```bash
pip install hyperliquid-python-sdk
```

```python
from hyperliquid.exchange import Exchange
from hyperliquid.info import Info

info = Info("https://api.hyperliquid.xyz")
print(info.l2_snapshot("BTC"))  # 实时 order book
# 交易需要钱包配置 —— 见深度文
```

完整指南含钱包配置和订单类型：[Hyperliquid perp DEX 交易](/zh/resources/ai-trading/hyperliquid-perp-dex-trading/)。

## 8. 组件 6 —— Polymarket Agents（预测市场）

**角色**：完全不同的 alpha 来源 —— 预测市场。Polymarket 是 USDC 结算的预测市场，结果绑定真实事件（选举、体育、宏观事件）。低效定价创造 AI 可利用的 edge，crypto-native 市场没有的。

**为什么这是沉睡的赌注**：多数散户量化完全忽视预测市场。Polymarket Agents 框架专为自主 AI agent 研究事件、建模结果、下注而建。

**用例**：
- 新闻驱动交易（AI 读突发新闻，更新概率估计）
- 跨场所套利（Polymarket vs Kalshi 定价差距）
- 事件条件加密仓位（用"6 月 Fed 降息" YES 下注对冲 BTC 短仓）

完整设置：[Polymarket Agents —— AI 交易机器人框架](/zh/resources/llm-frameworks/polymarket-agents-ai-trading-bot-framework/)。

## 9. 组件 7 —— Minara（非程序员的 AI+Crypto Hub）

**角色**：想要 AI 驱动交易但不写 Python 的用户 —— Minara 在 Hyperliquid 之上提供用户友好对话界面。AI 问答、实时市场分析、跨加密+股票+商品交易执行，全在一个 chat 式 UI。

**为什么适合这个 stack**：哪怕硬核量化也需要"第二屏"工具做快速市场检查、临时问题、手动对冲。Minara 是 AI 原生答案（vs TradingView 传统制图）。纯非程序员想 AI 驱动交易：Minara 是独立入口。

**开始**：{{< aff "minara" "minara-trading-platform" "Minara 注册" >}} —— 基于 Hyperliquid，底层执行和上面技术 stack 用同一 DEX 通道。把它当对话层用；技术 stack（1-6 组件）做系统化策略。

完整评测：[Minara Hyperliquid AI 交易 2026 评测](/zh/resources/ai-trading/minara-ai-trading-hyperliquid-review-2026/)。

## 10. Day 1 安装顺序（4-5 小时，投真金之前）

1. **VPS + Python 环境**（15 分）—— {{< aff "htstack" "trading-vps-setup" "HTStack HK VPS" >}} 4 GB，装 Python 3.11 + Docker
2. **ta-lib + vectorbt**（15 分）—— `pip install`，在 1 年 BTC 数据上跑样本回测
3. **freqtrade dry-run**（30 分）—— Docker compose，用只读 Binance API key 配置，纸面跑基础 Bollinger 策略 2 周后再实盘
4. **Hyperliquid testnet**（30 分）—— 拿 testnet USDC，装 SDK，testnet 上下测试订单验证执行
5. **AI Trader 集成**（45 分）—— 配 DeepSeek（便宜）或 Claude（premium）API key，指向你 freqtrade dry-run 日志
6. **Polymarket Agents**（30 分）—— 钱包配置，注 $50 USDC 测试，部署一个"新闻驱动预测"agent
7. **Minara 账户**（10 分）—— {{< aff "minara" "minara-day1-signup" "注册" >}} 拿对话 UI；做系统化也建议留个临时市场检查工具
8. **2 周纸面交易最少**（实时）—— 部署真金前，所有实盘执行 dry-run / testnet 跑 2 周，证明你没把明显的事搞砸

5 小时设置 + 2 周纸面交易后，你有真生产级量化 stack 跑在自己拥有的基础设施上。

## 11. 成本拆解

| 项 | 单干散户 | 主动策略 dev | 小基金（3 策略实盘）|
|---|---|---|---|
| VPS | $12-24 | $24-48 | $60-120 |
| 数据 feed（多数交易所有免费 websocket）| $0 | $0-20 | $50-150 |
| LLM API（AI Trader 策略生成）| $5-15 | $20-50 | $80-200 |
| Hyperliquid（gas 等效手续费）| per-trade | per-trade | per-trade |
| Polymarket（per-trade）| per-trade | per-trade | per-trade |
| Minara 订阅（如用）| $0（免费层）| $0-30 | $0-50 |
| **总基础设施** | **~$30-50/月** | **~$70-150/月** | **~$200-500/月** |

**不含**：交易资本本身。场所 per-trade 手续费。税务软件（建议另订 CoinTracking 或 Koinly）。

对比 SaaS 量化平台：3Commas Pro（$74）+ TradingView Premium（$59）+ CoinTracking（$21）= $154/月，且延迟更差、无源代码访问、IP 限执行。

## 12. 升级路径

超过这个 stack 时：

- **>10 并发策略** —— freqtrade 上 Kubernetes 集群带策略级隔离
- **<50ms 延迟关键** —— 在交易所数据中心 colo（亚洲 Binance 用 AWS Tokyo，美区 OKX 用 AWS NYC）
- **多资产（加密 + 股票 + 期货）** —— 加 Interactive Brokers 集成；用 QuantConnect 等托管量化平台与本 stack 并行
- **审计级交易记录** —— 加 immudb 或 Apache Kafka 做防篡改交易日志
- **资本 > $1M** —— 找懂加密的 CPA；如管别人钱结构化为基金（LP/GP）

## 13. 诚实风险讨论

这个 stack 让搭量化交易系统比 2018 容易 10×。**它不让实际策略本身更容易找到。** 多数回测看起来盈利的量化策略实盘执行失败因为：

- 历史数据里的**幸存者偏差**（倒闭的交易所、退市的对）
- **滑点** —— 回测假设按中间价成交；实盘吃 spread
- **体制变化** —— 2022 熊起作用的在 2026 牛可能不行
- **集中风险** —— 100% 单场所意味着单个 hack/监管动作清零你
- **心理压力** —— 看真钱波动和看回测股权曲线不同

搭 stack。纸面交易 1-3 月。从你完全能损失的资本起步。慢慢扩。想了解多数散户量化为何失败读 [Marcos Lopez de Prado 的《Advances in Financial Machine Learning》](https://www.amazon.com/Advances-Financial-Machine-Learning-Marcos/dp/1119482089)。

## TL;DR —— Recipe

**7 组件搭自托管 AI 量化交易，$30-150/月基础设施（不含交易资本）**：
1. **ta-lib** —— 信号生成（200+ 指标）
2. **vectorbt** —— 向量化回测
3. **freqtrade** —— 生产 CEX 执行
4. **AI Trader** —— AI 策略调整循环
5. **Hyperliquid** —— 链上 perp DEX 场所
6. **Polymarket Agents** —— 预测市场 alpha
7. **Minara** —— 非程序员的 AI+crypto 对话 hub（{{< aff "minara" "footer-minara" "在这注册" >}}）

开一个 {{< aff "htstack" "footer-htstack" "HTStack HK VPS" >}} 拿低延迟执行，部署真金前纸面交易 2-4 周，从你能损失的资本起步，实盘表现匹配回测预期后才扩。

---

*配套合集：[便宜 LLM Stack](/zh/collections/cheap-llm-stack/) 给 AI Trader 的 LLM API 成本侧。[AI Agent 工具链](/zh/collections/ai-agent-tool-chain/) 想让自主 agent 驱动交易循环。[自托管 AI 编程工作流](/zh/collections/self-hosted-ai-coding-workflow/) 给策略代码开发侧。*

*⚠️ 重申：非投资建议。风险自担。*
