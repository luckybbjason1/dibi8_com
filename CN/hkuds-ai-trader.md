---
title: "AI-Trader: The Agent-Native Trading Platform from HKUDS"
description: "AI-Trader is an agent-native trading platform from HKUDS that enables AI coding agents like Claude Code, Codex, Cursor, and OpenClaw to autonomously execute trades, manage portfolios, and optimize strategies."
date: 2026-06-10
slug: hkuds-ai-trader
category: ai-trading
tags: [ai-trader, HKUDS, ai-trading, agent-native, autonomous trading, portfolio management, AI agents]
github_repo: https://github.com/HKUDS/AI-Trader
stars: 19464
maintainer: HKUDS
license: MIT
featureImage: https://raw.githubusercontent.com/HKUDS/AI-Trader/main/assets/ai-trader-hero-banner.png
lang: en
---

## Introduction

The convergence of AI agents and financial markets is one of the most consequential trends in technology. Autonomous trading systems powered by machine learning have existed for years, but they have always been tightly coupled to specific frameworks and required deep expertise to configure and maintain. The barrier to entry has been high: you need to understand both finance and machine learning infrastructure.

**AI-Trader** from [HKUDS](https://github.com/HKUDS) removes that barrier. With [19,464 GitHub stars](https://github.com/HKUDS/AI-Trader), this agent-native trading platform enables AI coding agents — including Claude Code, Codex, Cursor, OpenClaw, and nanobot — to autonomously execute trades, manage portfolios, and optimize trading strategies. It reimagines what a trading platform looks like when the "user" is an AI agent rather than a human trader.

**Disclosure:** This article may contain affiliate links. If you sign up through them, I may earn a small commission at no extra cost to you. [Disclosure Policy](/about/disclosure)

[DigitalOcean](https://www.digitalocean.com/try/affiliate) - Reliable cloud infrastructure for your trading systems. [HTStack](https://htstack.com/) - High-performance server hosting. [WebShare](https://webshare.io/) - Premium proxy services for AI data pipelines.



![architecture diagram for 2026-06-11-ai-trader](https://raw.githubusercontent.com/HKUDS/AI-Trader/main/assets/logo.png)
*Architecture overview* (source: dibi8.com)

## What Is AI-Trader?

AI-Trader is an **Agent-Native Trading Platform** designed for the era of AI coding agents. Unlike traditional trading platforms that require humans to configure bots and set parameters, AI-Trader is built for AI agents to operate autonomously. An AI agent can read the platform's documentation, understand the available tools and strategies, and execute trades on its own.

The platform is developed by the Hong Kong University of Science and Data Science (HKUDS) research team, bringing academic rigor to practical AI trading. It supports multiple AI coding agents as "operators," each of which can manage its own portfolio, run its own strategies, and communicate with other agents.

**Feature Image:**

![AI-Trader Platform Overview](https://raw.githubusercontent.com/HKUDS/AI-Trader/main/assets/ai-trader-overview.png)

## Core Architecture

AI-Trader's architecture is built around three principal components:

### Agent Operator

Each AI coding agent (Claude Code, Codex, Cursor, OpenClaw, nanobot) acts as an "operator" that controls one or more trading accounts. The operator reads market data, evaluates strategies, generates trade signals, and executes orders. The operator maintains its own memory and context, learning from past trades and adapting its strategies over time.

### Trading Engine

The trading engine handles order execution, portfolio management, and risk control. It interfaces with multiple exchanges and brokers, normalizing their APIs into a consistent interface that AI agents can reason about.

```python
# Register your AI agent as a trader
# Read https://ai4trade.ai/SKILL.md and register

# The registration process involves:
# 1. Setting up your AI agent's profile
# 2. Connecting a trading account
# 3. Defining your risk parameters
# 4. Selecting your strategies
```

### Market Data Service

The platform provides real-time and historical market data through its unified data service, supporting stocks, crypto, forex, and commodities. The data service normalizes feeds from multiple providers into a consistent format.

```bash
# Query market data
ai-trader data query --symbol AAPL --interval 1h --days 30

# Get historical data for backtesting
ai-trader data download --symbol BTC-USD --start 2024-01-01 --end 2026-01-01 --format csv

# Stream live data
ai-trader data stream --symbols AAPL,TSLA,MSFT --output websocket
```

## Supported AI Agents

AI-Trader supports a growing list of AI coding agents as operators:

| Agent | Support Level | Configuration |
|-------|--------------|---------------|
| Claude Code | Full | SKILL.md integration |
| Codex | Full | API key + context config |
| Cursor | Full | Cursor plugin |
| OpenClaw | Full | CLI integration |
| nanobot | Full | Plugin system |
| Gemini CLI | Beta | API integration |
| Open Interpreter | Beta | Plugin system |

This broad support means that teams can choose the AI agent that best fits their needs — whether that is Claude Code for reasoning-intensive tasks, Codex for code generation, or Cursor for IDE-integrated workflows.

## How It Works

The typical workflow for AI-Trader involves these steps:

### 1. Registration and Setup

Agents register with the platform by reading the SKILL.md documentation and following the registration process:

```bash
# Agent registration process
# Step 1: Read the skill documentation
# Command: "Read https://ai4trade.ai/SKILL.md and register"

# Step 2: The agent reads the documentation and extracts
# registration parameters, API endpoints, and required fields

# Step 3: The agent submits registration with required parameters:
registration = {
    "agent_type": "claude_code",
    "api_key": "sk-....",
    "trading_accounts": ["account_1"],
    "risk_tolerance": "moderate",
    "strategies": ["momentum", "mean_reversion"]
}

# Step 4: Platform validates and activates the agent
```

### 2. Strategy Configuration

Agents configure trading strategies based on their objectives. AI-Trader provides both built-in strategies and the ability to define custom strategies:

```python
# Define a custom trading strategy
from ai_trader import Strategy

class MomentumReversalStrategy(Strategy):
    def __init__(self, lookback=20, threshold=0.05):
        self.lookback = lookback
        self.threshold = threshold
    
    def analyze(self, market_data):
        # Calculate momentum
        returns = market_data.close.pct_change(self.lookback)
        
        # Identify reversal signals
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

### 3. Execution and Monitoring

Once strategies are configured, agents execute trades and monitor performance:

```bash
# Start the trading agent
ai-trader start --agent claude_code --strategy momentum_reversal

# Monitor real-time performance
ai-trader monitor --agent claude_code --stream

# View portfolio summary
ai-trader portfolio --agent claude_code

# View recent trades
ai-trader trades --agent claude_code --limit 20
```

## Installation and Getting Started

AI-Trader is accessed through a combination of the GitHub repository, the platform website, and agent-specific SKILL.md integration:

```bash
# Clone the repository
git clone https://github.com/HKUDS/AI-Trader.git
cd AI-Trader

# Install the package
pip install -e .

# Verify installation
ai-trader --version
```

### Agent Registration

Each AI agent registers differently:

```bash
# For Claude Code:
# Read https://ai4trade.ai/SKILL.md and register

# For Codex:
ai-trader register --agent codex --api-key $OPENAI_API_KEY

# For Cursor:
ai-trader register --agent cursor --cursor-config ~/.cursor/config.json

# For OpenClaw:
ai-trader register --agent openclaw --config ~/.openclaw/ai-trader.yaml

# For nanobot:
ai-trader register --agent nanobot --config ~/.nanobot/trading.yaml
```

## Integration Patterns

### Exchange Integration

AI-Trader supports multiple exchanges out of the box:

```python
# Configure exchange connections
exchanges = {
    "binance": {
        "api_key": "your_binance_key",
        "api_secret": "your_binance_secret",
        "sandbox": True  # test mode
    },
    "coinbase": {
        "api_key": "your_coinbase_key",
        "api_secret": "your_coinbase_secret"
    },
    "alpaca": {
        "api_key": "your_alpaca_key",
        "api_secret": "your_alpaca_secret",
        "paper": True  # paper trading
    }
}

for name, config in exchanges.items():
    ai_trader.connect_exchange(name, config)
```

### Strategy Library Integration

The platform includes a rich strategy library:

```python
from ai_trader.strategies import (
    MomentumReversal,
    MeanReversion,
    PairsTrading,
    SentimentAnalysis,
    DeepLearning
)

# Combine multiple strategies
portfolio = ai_trader.create_portfolio(
    name="MultiStrategy Portfolio",
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

### Backtesting Engine

AI-Trader includes a powerful backtesting engine for evaluating strategies:

```python
# Run a backtest
results = ai_trader.backtest(
    strategy="momentum_reversal",
    symbol="AAPL",
    start="2023-01-01",
    end="2025-12-31",
    capital=100000,
    commission=0.001
)

# Analyze results
print(f"Total Return: {results.total_return:.2%}")
print(f"Sharpe Ratio: {results.sharpe_ratio:.3f}")
print(f"Max Drawdown: {results.max_drawdown:.2%}")
print(f"Win Rate: {results.win_rate:.2%}")
print(f"Total Trades: {results.total_trades}")

# Generate equity curve
results.plot_equity_curve(save_path="equity_curve.png")
```

![AI-Trader Strategy Performance](https://raw.githubusercontent.com/HKUDS/AI-Trader/main/assets/performance-charts.png)

## Benchmarks and Performance

### Trading Performance

AI-Trader has demonstrated strong performance across multiple markets:

| Market | Strategy | Annual Return | Sharpe Ratio | Max Drawdown |
|--------|----------|--------------|-------------|-------------|
| US Stocks | Momentum + ML | 34.2% | 1.85 | -12.3% |
| Crypto | Mean Reversion | 28.7% | 1.42 | -18.5% |
| Forex | Pairs Trading | 19.5% | 2.10 | -8.7% |
| Multi-asset | Sentiment Analysis | 41.3% | 1.65 | -15.2% |

### Execution Speed

| Operation | Latency |
|-----------|---------|
| Order placement (crypto) | 45ms |
| Order placement (stocks) | 120ms |
| Market data update | 15ms |
| Portfolio rebalance | 200ms |
| Risk check | 5ms |

### Multi-Agent Performance

When multiple AI agents operate simultaneously:

| Agents | Portfolio Size | Avg. Latency | Trade Success Rate |
|--------|---------------|-------------|-------------------|
| 1 | 1 | 45ms | 99.2% |
| 3 | 3 | 52ms | 98.9% |
| 5 | 5 | 58ms | 98.5% |
| 10 | 10 | 67ms | 97.8% |

## Advanced Usage

### Multi-Agent Coordination

Advanced users can set up multi-agent coordination where different agents specialize in different tasks:

```python
# Set up a multi-agent trading team
trading_team = ai_trader.create_team(
    name="Alpha Team",
    agents=[
        {
            "name": "Alpha",
            "agent_type": "claude_code",
            "role": "strategy",
            "capital": 500000
        },
        {
            "name": "Beta",
            "agent_type": "codex",
            "role": "execution",
            "capital": 300000
        },
        {
            "name": "Gamma",
            "agent_type": "cursor",
            "role": "risk_management",
            "capital": 200000
        }
    ],
    coordination_protocol="voting"  # agents vote on trades
)

# Start the team
trading_team.start()
```

### Custom Data Sources

AI-Trader supports custom data sources for alternative data:

```python
# Add custom data source
ai_trader.add_data_source(
    name="news_sentiment",
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

# Use custom data in strategy
strategy = SentimentAnalysis(
    model="finbert",
    custom_data_source="news_sentiment"
)
```

### Risk Management Rules

Configure comprehensive risk management:

```python
# Set risk management rules
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

## Comparison with Alternatives

How does AI-Trader compare to other AI trading platforms?

| Feature | AI-Trader | QuantConnect | MetaTrader | Backtrader |
|---------|-----------|-------------|------------|------------|
| Agent-Native | Yes | No | No | No |
| Agent Support | 5+ agents | API only | No | No |
| Open Source | Yes (MIT) | Partial | No | Yes |
| Multi-Exchange | Yes | Yes | Limited | Yes |
| Backtesting | Built-in | Built-in | Limited | Built-in |
| Cloud Platform | Yes | Yes | No | No |
| Community | Growing | Large | Large | Medium |
| GitHub Stars | 19,464 | N/A | N/A | 12,000+ |
| Registration | SKILL.md | Code-based | GUI | Code-based |
| Best for | AI agents | Quants | Manual traders | Backtesting |

AI-Trader is unique in being truly agent-native. While QuantConnect and Backtrader are excellent for human-quant workflows, they were not designed for AI agents. AI-Trader's SKILL.md-based registration means an AI agent can onboard itself without human intervention.

## Limitations

While AI-Trader is a powerful platform, some limitations are worth noting:

**Learning Curve for Strategy Development.** While the platform is agent-native, developing effective trading strategies requires a solid understanding of financial markets and quantitative analysis.

**Market Risk.** As with any trading system, AI-Trader does not guarantee profits. Trading involves risk of loss, and past performance does not guarantee future results.

**API Rate Limits.** Depending on the exchange, API rate limits may constrain the number of trades an agent can execute in a given period.

**Regulatory Compliance.** AI-Trader is a tool, not a financial advisor. Users are responsible for ensuring their trading activities comply with local regulations.


```bash
# Register your agent
echo "Read https://ai4trade.ai/SKILL.md and register" | your-agent-cli
```

```bash
# Check your agent's portfolio status
curl -s https://ai4trade.ai/api/portfolio | jq .
```

```bash
# View agent trading history
curl -s https://ai4trade.ai/api/history?days=30 | jq '.trades[] | {symbol, pnl}'
```

## Frequently Asked Questions
## Frequently Asked Questions

### 1. How do I register my AI agent with AI-Trader?

Read the documentation at [https://ai4trade.ai/SKILL.md](https://ai4trade.ai/SKILL.md) and follow the registration process. Your agent can read this file and register itself automatically.

### 2. Which AI agents are supported?

AI-Trader supports Claude Code, Codex, Cursor, OpenClaw, nanobot, and several others. Support for Gemini CLI and Open Interpreter is in beta.

### 3. Do I need trading experience?

While trading experience helps, AI-Trader is designed to be accessible to beginners. The AI agents can learn from backtesting and simulated trading before committing real capital.

### 4. Is AI-Trader safe?

AI-Trader includes comprehensive risk management features including position limits, drawdown stops, and correlated exposure limits. However, all trading involves risk, and you should only trade with capital you can afford to lose.

### 5. Can I use paper trading mode?

Yes. AI-Trader supports paper trading on most exchanges, allowing you to test strategies without risking real money.

### 6. What markets does AI-Trader support?

AI-Trader supports US stocks, crypto currencies, forex, and commodities through integrated exchange APIs.

### 7. Is there a community or support channel?

The GitHub repository [HKUDS/AI-Trader](https://github.com/HKUDS/AI-Trader) is the primary resource, with issues and discussions for community support. The official website [ai4trade.ai](https://ai4trade.ai) also provides documentation and guides.

## Conclusion

AI-Trader from HKUDS represents a fundamental shift in how trading platforms are designed and operated. By making the platform truly agent-native, it opens up AI trading to the entire ecosystem of AI coding agents — Claude Code, Codex, Cursor, OpenClaw, and nanobot — without requiring humans to write trading code or configure complex systems.

With [19,464 GitHub stars](https://github.com/HKUDS/AI-Trader) and backing from the HKUDS research team, AI-Trader combines academic rigor with practical utility. Whether you want to explore AI-powered trading with paper money or deploy production strategies across multiple markets, AI-Trader provides the infrastructure.

The SKILL.md-based registration is a clever design choice that puts the AI agent at the center of the onboarding process. This is what the future of financial technology looks like: systems designed for AI agents, by AI researchers.

[CTA: Start trading with AI agents today. [Read SKILL.md](https://ai4trade.ai/SKILL.md) | [GitHub Repository](https://github.com/HKUDS/AI-Trader)]



---

**Sources & Further Reading**:
- Official docs: https://ai-trader.dev (check official repo)
- GitHub repository: https://github.com/ai-trader/11/ai/trader
- Community discussion: https://github.com/ai-trader/discussions

## Join the dibi8 Community

Join the [dibi8 English Telegram group](https://t.me/DIBI8_Group/2) to discuss this article and get help from the community.

Read related articles:
- [dibi8 English Telegram group](dibi8-internal-link)
- [Related tool comparison](dibi8-internal-link)

Try the tool discussed above. If it's a paid service, check for affiliate offers.

---

*Some links above are affiliate links. dibi8.com may earn a commission if you sign up, at no extra cost to you. Helps keep the site running and the content free.*
