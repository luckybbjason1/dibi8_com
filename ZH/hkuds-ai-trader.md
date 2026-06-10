---
title: "AI-Trader：来自 HKUDS 的原生 AI 交易平台"
description: "AI-Trader 是 HKUDS 推出的原生 AI 交易平台，使 Claude Code、Codex、Cursor 和 OpenClaw 等 AI 编程代理能够自主执行交易、管理投资组合和优化策略。"
date: 2026-06-10
slug: hkuds-ai-trader
category: ai-trading
tags: [ai-trader, HKUDS, ai-trading, 原生代理, 自主交易, 投资组合管理, AI 代理]
github_repo: https://github.com/HKUDS/AI-Trader
stars: 19464
maintainer: HKUDS
license: MIT
featureImage: https://raw.githubusercontent.com/HKUDS/AI-Trader/main/assets/ai-trader-hero-banner.png
lang: zh
---

## 简介

AI 代理与金融市场的融合是技术领域最具影响力的趋势之一。由机器学习驱动的自主交易系统已经存在多年，但它们始终与特定框架紧密耦合，并且需要专业知识才能配置和维护。入门门槛一直很高：你需要同时理解金融和机器学习基础设施。

**AI-Trader**（来自 [HKUDS](https://github.com/HKUDS)）消除了这一门槛。凭借 [19,464 个 GitHub 星标](https://github.com/HKUDS/AI-Trader)，这个原生 AI 交易平台使 AI 编程代理——包括 Claude Code、Codex、Cursor、OpenClaw 和 nanobot——能够自主执行交易、管理投资组合和优化交易策略。它重新定义了当"用户"是 AI 代理而非人类交易者时的交易平台是什么样子的。

**披露：** 本文可能包含联盟链接。如果你通过这些链接注册，我可能会获得少量佣金，而无需你支付额外费用。[披露政策](/about/disclosure)

[DigitalOcean](https://www.digitalocean.com/try/affiliate) - 可靠的云基础设施，用于你的交易系统。[HTStack](https://htstack.com/) - 高性能服务器托管。[WebShare](https://webshare.io/) - 为 AI 数据管道提供的高级代理服务。

## 什么是 AI-Trader？

AI-Trader 是一个**原生 AI 交易平台**，专为 AI 编程代理时代设计。与需要人类配置机器人和设置参数的传统交易平台不同，AI-Trader 是为 AI 代理自主运行而构建的。AI 代理可以阅读平台的文档，了解可用的工具和策略，并自行执行交易。

该平台由香港科技大学数据科学（HKUDS）研究团队开发，将学术严谨性带入实用的 AI 交易中。它支持多个 AI 编程代理作为"操作员"，每个代理可以管理自己的投资组合、运行自己的策略并与其他代理通信。

**功能图片：**

![AI-Trader 平台概览](https://raw.githubusercontent.com/HKUDS/AI-Trader/main/assets/ai-trader-overview.png)

## 核心架构

AI-Trader 的架构围绕三个主要组件构建：

### 代理操作员

每个 AI 编程代理（Claude Code、Codex、Cursor、OpenClaw、nanobot）都充当控制一个或多个交易账户的"操作员"。操作员读取市场数据、评估策略、生成交易信号并执行订单。操作员维护自己的记忆和上下文，从过去的交易中学习并随着时间的推移调整策略。

### 交易引擎

交易引擎处理订单执行、投资组合管理和风险控制。它与多个交易所和经纪人接口，将其 API 规范化为 AI 代理可以推理的一致接口。

```python
# 注册你的 AI 代理作为交易者
# 阅读 https://ai4trade.ai/SKILL.md 并注册

# 注册流程包括：
# 1. 设置你的 AI 代理配置
# 2. 连接交易账户
# 3. 定义你的风险参数
# 4. 选择你的策略
```

### 市场数据服务

该平台通过统一数据服务提供实时和历史市场数据，支持股票、加密货币、外汇和大宗商品。数据服务将多个提供商的馈送规范化为一致的格式。

```bash
# 查询市场数据
ai-trader data query --symbol AAPL --interval 1h --days 30

# 获取历史数据进行回测
ai-trader data download --symbol BTC-USD --start 2024-01-01 --end 2026-01-01 --format csv

# 流式传输实时数据
ai-trader data stream --symbols AAPL,TSLA,MSFT --output websocket
```

## 支持的 AI 代理

AI-Trader 支持越来越多的 AI 编程代理作为操作员：

| 代理 | 支持级别 | 配置 |
|-------|--------------|---------------|
| Claude Code | 完整 | SKILL.md 集成 |
| Codex | 完整 | API 密钥 + 上下文配置 |
| Cursor | 完整 | Cursor 插件 |
| OpenClaw | 完整 | CLI 集成 |
| nanobot | 完整 | 插件系统 |
| Gemini CLI | Beta | API 集成 |
| Open Interpreter | Beta | 插件系统 |

这种广泛的支持意味着团队可以选择最适合他们需求的 AI 代理——无论是用于推理密集型任务的 Claude Code、用于代码生成的 Codex，还是用于 IDE 集成工作流的 Cursor。

## 工作原理

AI-Trader 的典型工作流程包括以下步骤：

### 1. 注册和设置

代理通过阅读 SKILL.md 文档并按照注册流程与平台注册：

```bash
# 代理注册流程
# 第1步：阅读技能文档
# 命令："阅读 https://ai4trade.ai/SKILL.md 并注册"

# 第2步：代理读取文档并提取
# 注册参数、API 端点和必填字段

# 第3步：代理使用必填参数提交注册：
registration = {
    "agent_type": "claude_code",
    "api_key": "sk-....",
    "trading_accounts": ["account_1"],
    "risk_tolerance": "moderate",
    "strategies": ["momentum", "mean_reversion"]
}

# 第4步：平台验证并激活代理
```

### 2. 策略配置

代理根据其目标配置交易策略。AI-Trader 提供内置策略和定义自定义策略的能力：

```python
# 定义自定义交易策略
from ai_trader import Strategy

class MomentumReversalStrategy(Strategy):
    def __init__(self, lookback=20, threshold=0.05):
        self.lookback = lookback
        self.threshold = threshold
    
    def analyze(self, market_data):
        # 计算动量
        returns = market_data.close.pct_change(self.lookback)
        
        # 识别反转信号
        if returns.iloc[-1] > self.threshold:
            return "SELL"
        elif returns.iloc[-1] < -self.threshold:
            return "BUY"
        return "HOLD"
    
    def generate_order(self, signal, current_position):
        if signal == "BUY":
            return self.create_buy_order(
                symbol=current_position.symbol,
                size=current_position.size * 0.5
            )
        elif signal == "SELL":
            return self.create_sell_order(
                symbol=current_position.symbol,
                size=current_position.size
            )
        return None
```

### 3. 执行和监控

策略配置完成后，代理执行交易并监控表现：

```bash
# 启动交易代理
ai-trader start --agent claude_code --strategy momentum_reversal

# 监控实时表现
ai-trader monitor --agent claude_code --stream

# 查看投资组合摘要
ai-trader portfolio --agent claude_code

# 查看最近交易
ai-trader trades --agent claude_code --limit 20
```

## 安装和入门

AI-Trader 通过 GitHub 仓库、平台网站和代理特定 SKILL.md 集成的组合来访问：

```bash
# 克隆仓库
git clone https://github.com/HKUDS/AI-Trader.git
cd AI-Trader

# 安装包
pip install -e .

# 验证安装
ai-trader --version
```

### 代理注册

每个 AI 代理的注册方式不同：

```bash
# 对于 Claude Code：
# 阅读 https://ai4trade.ai/SKILL.md 并注册

# 对于 Codex：
ai-trader register --agent codex --api-key $OPENAI_API_KEY

# 对于 Cursor：
ai-trader register --agent cursor --cursor-config ~/.cursor/config.json

# 对于 OpenClaw：
ai-trader register --agent openclaw --config ~/.openclaw/ai-trader.yaml

# 对于 nanobot：
ai-trader register --agent nanobot --config ~/.nanobot/trading.yaml
```

## 集成模式

### 交易所集成

AI-Trader 开箱即用地支持多个交易所：

```python
# 配置交易所连接
exchanges = {
    "binance": {
        "api_key": "your_binance_key",
        "api_secret": "your_binance_secret",
        "sandbox": True  # 测试模式
    },
    "coinbase": {
        "api_key": "your_coinbase_key",
        "api_secret": "your_coinbase_secret"
    },
    "alpaca": {
        "api_key": "your_alpaca_key",
        "api_secret": "your_alpaca_secret",
        "paper": True  # 模拟交易
    }
}

for name, config in exchanges.items():
    ai_trader.connect_exchange(name, config)
```

### 策略库集成

平台包含丰富的策略库：

```python
from ai_trader.strategies import (
    MomentumReversal,
    MeanReversion,
    PairsTrading,
    SentimentAnalysis,
    DeepLearning
)

# 结合多种策略
portfolio = ai_trader.create_portfolio(
    name="多策略投资组合",
    strategies=[
        MomentumReversal(lookback=10, threshold=0.03),
        MeanReversion(window=20, z_threshold=2.0),
        SentimentAnalysis(model="finbert")
    ],
    capital=100000,
    risk_limits={
        "max_position_size": 0.1,
        "max_drawdown": 0.15,
        "max_leverage": 2.0
    }
)
```

### 回测引擎

AI-Trader 包含强大的回测引擎用于评估策略：

```python
# 运行回测
results = ai_trader.backtest(
    strategy="momentum_reversal",
    symbol="AAPL",
    start="2023-01-01",
    end="2025-12-31",
    capital=100000,
    commission=0.001
)

# 分析结果
print(f"总回报: {results.total_return:.2%}")
print(f"夏普比率: {results.sharpe_ratio:.3f}")
print(f"最大回撤: {results.max_drawdown:.2%}")
print(f"胜率: {results.win_rate:.2%}")
print(f"总交易次数: {results.total_trades}")

# 生成本金曲线
results.plot_equity_curve(save_path="equity_curve.png")
```

![AI-Trader 策略表现](https://raw.githubusercontent.com/HKUDS/AI-Trader/main/assets/performance-charts.png)

## 基准和性能

### 交易表现

AI-Trader 在多个市场中展示了强劲的表现：

| 市场 | 策略 | 年化回报 | 夏普比率 | 最大回撤 |
|--------|----------|--------------|-------------|-------------|
| 美股 | 动量 + ML | 34.2% | 1.85 | -12.3% |
| 加密货币 | 均值回归 | 28.7% | 1.42 | -18.5% |
| 外汇 | 配对交易 | 19.5% | 2.10 | -8.7% |
| 多资产 | 情感分析 | 41.3% | 1.65 | -15.2% |

### 执行速度

| 操作 | 延迟 |
|-----------|---------|
| 订单放置（加密货币） | 45ms |
| 订单放置（股票） | 120ms |
| 市场数据更新 | 15ms |
| 投资组合再平衡 | 200ms |
| 风险检查 | 5ms |

### 多代理表现

当多个 AI 代理同时运行时：

| 代理数 | 投资组合大小 | 平均延迟 | 交易成功率 |
|--------|---------------|-------------|-------------------|
| 1 | 1 | 45ms | 99.2% |
| 3 | 3 | 52ms | 98.9% |
| 5 | 5 | 58ms | 98.5% |
| 10 | 10 | 67ms | 97.8% |

## 高级用法

### 多代理协调

高级用户可以设置多代理协调，其中不同代理专精于不同任务：

```python
# 设置多代理交易团队
trading_team = ai_trader.create_team(
    name="Alpha 团队",
    agents=[
        {
            "name": "Alpha",
            "agent_type": "claude_code",
            "role": "策略",
            "capital": 500000
        },
        {
            "name": "Beta",
            "agent_type": "codex",
            "role": "执行",
            "capital": 300000
        },
        {
            "name": "Gamma",
            "agent_type": "cursor",
            "role": "风险管理",
            "capital": 200000
        }
    ],
    coordination_protocol="投票"  # 代理对交易进行投票
)

# 启动团队
trading_team.start()
```

### 自定义数据源

AI-Trader 支持另类数据的自定义数据源：

```python
# 添加自定义数据源
ai_trader.add_data_source(
    name="新闻情感",
    type="custom",
    fetcher="my_news_api",
    update_interval="1h",
    schema={
        "symbol": "string",
        "sentiment_score": "float",
        "confidence": "float",
        "timestamp": "datetime"
    }
)

# 在策略中使用自定义数据
strategy = SentimentAnalysis(
    model="finbert",
    custom_data_source="新闻情感"
)
```

### 风险管理规则

配置全面的风险管理：

```python
# 设置风险管理规则
ai_trader.configure_risk(
    global_limits={
        "max_total_exposure": 1000000,
        "max_single_position": 0.15,
        "max_drawdown_alert": 0.10,
        "max_drawdown_stop": 0.15,
        "max_daily_loss": 0.05,
        "max_correlated_exposure": 0.40
    },
    agent_limits={
        "claude_code": {
            "max_positions": 10,
            "max_daily_trades": 50,
            "min_holding_period": "1h"
        },
        "codex": {
            "max_positions": 5,
            "max_daily_trades": 100,
            "min_holding_period": "30m"
        }
    }
)
```

## 与替代方案比较

AI-Trader 与其他 AI 交易平台相比如何？

| 功能 | AI-Trader | QuantConnect | MetaTrader | Backtrader |
|---------|-----------|-------------|------------|------------|
| 原生代理 | 是 | 否 | 否 | 否 |
| 代理支持 | 5+ 代理 | 仅 API | 否 | 否 |
| 开源 | 是（MIT） | 部分 | 否 | 是 |
| 多交易所 | 是 | 是 | 有限 | 是 |
| 回测 | 内置 | 内置 | 有限 | 内置 |
| 云平台 | 是 | 是 | 否 | 否 |
| 社区 | 增长中 | 大型 | 大型 | 中等 |
| GitHub 星标 | 19,464 | 不适用 | 不适用 | 12,000+ |
| 注册 | SKILL.md | 基于代码 | GUI | 基于代码 |
| 最佳用途 | AI 代理 | 量化交易员 | 手动交易者 | 回测 |

AI-Trader 的独特之处在于它真正是原生代理的。虽然 QuantConnect 和 Backtrader 非常适合人类量化工作流，但它们并非为 AI 代理设计。AI-Trader 基于 SKILL.md 的注册意味着 AI 代理可以在没有人类干预的情况下自行完成入职流程。

## 局限性

虽然 AI-Trader 是一个强大的平台，但也有一些值得注意的局限性：

**策略开发的入门门槛。** 虽然平台是原生代理的，但开发有效的交易策略需要对金融市场和定量分析有扎实的理解。

**市场风险。** 与任何交易系统一样，AI-Trader 不保证利润。交易涉及亏损风险，过去的表现不能保证未来的结果。

**API 速率限制。** 根据交易所的不同，API 速率限制可能会限制代理在给定时间内可以执行的交易数量。

**合规性。** AI-Trader 是一个工具，不是财务顾问。用户有责任确保其交易活动符合当地法规。

## 常见问题

### 1. 我如何将 AI 代理注册到 AI-Trader？

阅读 [https://ai4trade.ai/SKILL.md](https://ai4trade.ai/SKILL.md) 的文档并按照注册流程操作。你的代理可以读取此文件并自动注册。

### 2. 支持哪些 AI 代理？

AI-Trader 支持 Claude Code、Codex、Cursor、OpenClaw、nanobot 等多种代理。Gemini CLI 和 Open Interpreter 的支持处于 beta 阶段。

### 3. 我需要交易经验吗？

虽然交易经验有帮助，但 AI-Trader 旨在对初学者友好。AI 代理可以在投入真实资金之前从回测和模拟交易中学习。

### 4. AI-Trader 安全吗？

AI-Trader 包含全面的风险管理功能，包括仓位限制、回撤停止和相关性 exposure 限制。然而，所有交易都涉及风险，你应该只使用你能承受损失的资金进行交易。

### 5. 我可以使用模拟交易模式吗？

可以。AI-Trader 支持大多数交易所的模拟交易，让你在不冒真实资金风险的情况下测试策略。

### 6. AI-Trader 支持哪些市场？

AI-Trader 通过集成的交易所 API 支持美股、加密货币、外汇和大宗商品。

### 7. 有社区或支持渠道吗？

GitHub 仓库 [HKUDS/AI-Trader](https://github.com/HKUDS/AI-Trader) 是主要资源，通过问题和讨论提供社区支持。官方网站 [ai4trade.ai](https://ai4trade.ai) 也提供文档和指南。

## 结论

HKUDS 的 AI-Trader 代表了交易平台设计和运营的根本性转变。通过使平台真正成为原生代理的，它向整个 AI 编程代理生态系统——Claude Code、Codex、Cursor、OpenClaw 和 nanobot——敞开了 AI 交易的大门——而无需人类编写交易代码或配置复杂的系统。

凭借 [19,464 个 GitHub 星标](https://github.com/HKUDS/AI-Trader)和 HKUDS 研究团队的支持，AI-Trader 将学术严谨性与实用功能相结合。无论你是想用模拟资金探索 AI 驱动的交易，还是在多个市场部署生产级策略，AI-Trader 都提供了基础设施。

基于 SKILL.md 的注册是一个巧妙的设计选择，将 AI 代理放在入职流程的中心。这就是金融技术的未来：由 AI 研究人员为 AI 代理设计的系统。

[CTA：今天开始用 AI 代理交易。[阅读 SKILL.md](https://ai4trade.ai/SKILL.md) | [GitHub 仓库](https://github.com/HKUDS/AI-Trader)]

## 参考资料

1. [AI-Trader GitHub 仓库](https://github.com/HKUDS/AI-Trader)
2. [AI-Trader 官方网站](https://ai4trade.ai)
3. [AI-Trader SKILL.md](https://ai4trade.ai/SKILL.md)
4. [HKUDS 研究小组](https://github.com/HKUDS)
5. [DigitalOcean - 交易系统的云基础设施](https://www.digitalocean.com/try/affiliate)
6. [HTStack - 高性能托管](https://htstack.com/)
7. [WebShare - 数据管道代理服务](https://webshare.io/)
