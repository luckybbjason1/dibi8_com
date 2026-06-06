---
title: 'Polymarket Agents: Build AI Trading Bots for Prediction Markets'
description: Polymarket Agents is an open-source developer framework for building
  AI agents that trade autonomously on Polymarket prediction markets.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Docker
- Go
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
- /en/posts/polymarket-agents-ai-trading-bot-framework/
- /posts/ai-trader-fully-automated-trading-agent/
- /posts/polymarket-agents-ai-trading-bot-framework/
faqs:
  - q: 'What is Polymarket Agents?'
    a: 'Polymarket Agents is an open-source, MIT-licensed developer framework for building AI agents that trade autonomously on Polymarket prediction markets. It provides utilities to analyze markets, integrate with the Polymarket API for real-time data, and execute trades automatically.'
  - q: 'What do I need to set up before running Polymarket Agents?'
    a: 'You need a Polygon wallet private key and an OpenAI API key set in a .env file, plus a Python 3.9 virtual environment with dependencies installed from requirements.txt. You must also fund your Polygon wallet with USDC, since trades on Polymarket are settled in USDC.'
  - q: 'How does Polymarket Agents use RAG for trading decisions?'
    a: 'It uses a Chroma vector database to store news articles and market data, converts text into embeddings for semantic search, retrieves relevant information based on the current market context, and lets the LLM synthesize that retrieved data into a trading decision.'
  - q: 'What trading strategies does Polymarket Agents support?'
    a: 'The framework supports news-based trading (LLM sentiment analysis of events), arbitrage detection across related markets, trend following based on volume and price movements, and fundamental analysis using RAG to query historical data.'
  - q: 'How do I execute a trade with the Polymarket Agents CLI?'
    a: 'Run the CLI command ''python scripts/python/cli.py trade --market-id <MARKET_ID> --side buy --size <SIZE>''. You can also list markets with ''get-all-markets --sort-by volume'' or inspect a single market with ''get-market --market-id <MARKET_ID>''.'
---
{</* resource-info */>}

![Polymarket Agents CLI showing available commands](/images/articles/polymarket-agents-ai-trading-bot-framework/cli.png)
*Polymarket Agents CLI — official screenshot from [github.com/Polymarket/agents](https://github.com/Polymarket/agents)*

## What is Polymarket Agents?

**Polymarket Agents** is an open-source developer framework and set of utilities for building AI agents that trade autonomously on **Polymarket** — the world's largest prediction market platform.

This framework enables developers to:
- 🤖 Build AI agents that analyze markets and execute trades automatically
- 📊 Integrate with Polymarket API for real-time market data
- 🔍 Use RAG (Retrieval-Augmented Generation) for informed trading decisions
- 📰 Source data from betting services, news providers, and web search
- 🧠 Leverage comprehensive LLM tools for prompt engineering and market analysis

🔗 **GitHub**: [https://github.com/Polymarket/agents](https://github.com/Polymarket/agents)

---

## What is Polymarket?

**Polymarket** is a decentralized prediction market platform where users trade on the outcomes of real-world events:

- **Politics** — Election results, policy decisions
- **Crypto** — Bitcoin price predictions, ETF approvals
- **Sports** — Game outcomes, championship winners
- **Science** — Research breakthroughs, space missions
- **Entertainment** — Award winners, box office results

Traders buy "Yes" or "No" shares based on their predictions, with prices reflecting the market's consensus probability.

---

## Key Features

| Feature | Description |
|---------|-------------|
| **Polymarket API Integration** | Full access to market data, order book, and trade execution |
| **AI Agent Utilities** | Tools for building autonomous trading agents |
| **Local & Remote RAG** | Vector database support for news and market data retrieval |
| **Multi-Source Data** | Betting services, news APIs, web search integration |
| **LLM Prompt Engineering** | Comprehensive tools for context-aware reasoning |
| **CLI Interface** | Command-line tool for market analysis and trading |
| **Docker Support** | Containerized deployment for easy setup |
| **MIT License** | Free and open-source |

---

## Architecture

Polymarket Agents features modular components that can be maintained and extended by the community:

### Core APIs

| Component | Purpose |
|-----------|---------|
| **Chroma.py** | Vector database for news sources and API data |
| **Gamma.py** | Polymarket Gamma API client for market metadata |
| **Polymarket.py** | Main API class for market data and trade execution |
| **Objects.py** | Pydantic data models for trades, markets, events |

### CLI Commands

The primary user interface for interacting with Polymarket:

```bash
# Get all markets sorted by volume
python scripts/python/cli.py get-all-markets --limit 10 --sort-by volume

# Get specific market details
python scripts/python/cli.py get-market --market-id <MARKET_ID>

# Execute a trade
python scripts/python/cli.py trade --market-id <MARKET_ID> --side buy --size <SIZE>
```

---

## Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/polymarket/agents.git
cd agents
```

### 2. Set Up Environment

```bash
# Create virtual environment
virtualenv --python=python3.9 .venv
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

### 3. Configure API Keys

Create `.env` file:

```env
POLYGON_WALLET_PRIVATE_KEY="your-wallet-private-key"
OPENAI_API_KEY="your-openai-api-key"
```

### 4. Load Wallet with USDC

Transfer USDC to your Polygon wallet for trading.

### 5. Run CLI

```bash
# Set Python path
export PYTHONPATH="."

# Run CLI
python scripts/python/cli.py
```

Or execute trades directly:

```bash
python agents/application/trade.py
```

### 6. Docker Alternative

```bash
./scripts/bash/build-docker.sh
./scripts/bash/run-docker-dev.sh
```

---

## Trading Strategies

Polymarket Agents supports various AI-driven trading strategies:

### 1. News-Based Trading
- Monitor news sources for event developments
- Use LLM to analyze sentiment and impact
- Execute trades based on predicted outcomes

### 2. Arbitrage Detection
- Compare prices across related markets
- Identify mispriced probabilities
- Execute risk-free arbitrage trades

### 3. Trend Following
- Analyze market volume and price movements
- Identify momentum in specific markets
- Ride trends for profit

### 4. Fundamental Analysis
- Research event background and factors
- Use RAG to query historical data
- Make informed predictions

---

## Data Sources

The framework integrates multiple data sources:

| Source | Type | Use Case |
|--------|------|----------|
| **News APIs** | Real-time news | Event tracking |
| **Web Search** | General information | Background research |
| **Betting Services** | Odds comparison | Price discovery |
| **Social Media** | Sentiment analysis | Trend detection |
| **On-Chain Data** | Transaction data | Market intelligence |

---

## RAG Implementation

Retrieval-Augmented Generation for informed trading:

1. **Vector Database** — Chroma DB stores news articles and market data
2. **Embedding** — Convert text to vectors for semantic search
3. **Retrieval** — Query relevant information based on market context
4. **Generation** — LLM synthesizes retrieved data into trading decisions

---

## Risk Management

Important considerations for automated trading:

| Risk | Mitigation |
|------|-----------|
| **Market Risk** | Position sizing, stop-losses |
| **Liquidity Risk** | Trade in high-volume markets |
| **Model Risk** | Backtest strategies before live trading |
| **Operational Risk** | Monitor bot performance regularly |
| **Regulatory Risk** | Comply with local regulations |

---

## Comparison with Other Tools

| Feature | Polymarket Agents | Custom Bot | Manual Trading |
|---------|------------------|------------|----------------|
| **Open Source** | ✅ | Varies | N/A |
| **AI Integration** | ✅ | Optional | ❌ |
| **RAG Support** | ✅ | Rare | ❌ |
| **Multi-Source Data** | ✅ | Optional | ❌ |
| **CLI Interface** | ✅ | Varies | N/A |
| **Community** | ✅ | Varies | ❌ |
| **Speed** | Fast | Fast | Slow |
| **Emotion-Free** | ✅ | ✅ | ❌ |

---

## Use Cases

### 1. Political Event Trading
- Election outcomes
- Policy decisions
- Legislative votes

### 2. Crypto Market Predictions
- Bitcoin price movements
- ETF approvals
- Regulatory decisions

### 3. Sports Betting
- Game outcomes
- Championship winners
- Player performance

### 4. Entertainment Markets
- Award winners
- Box office predictions
- Reality show outcomes

---

## Related Repositories

| Repository | Purpose |
|-----------|---------|
| [py-clob-client](https://github.com/Polymarket/py-clob-client) | Python client for Polymarket CLOB |
| [python-order-utils](https://github.com/Polymarket/python-order-utils) | Order generation and signing |
| [clob-client](https://github.com/Polymarket/clob-client) | TypeScript client for CLOB |
| [Langchain](https://github.com/langchain-ai/langchain) | Context-aware reasoning |
| [Chroma](https://docs.trychroma.com) | Vector database |

---

## Reading Resources

- [Prediction Markets: Bottlenecks and Next Unlocks](https://mirror.xyz/1kx.eth/jnQhA56Kx9p3RODKiGzqzHGGEODpbskivUUNdd7hwh0)
- [Crypto + AI Applications](https://vitalik.eth.limo/general/2024/01/30/cryptoai.html) by Vitalik Buterin
- [Superforecasting](https://hbr.org/2016/05/superforecasting-how-to-upgrade-your-companys-judgment)

---

## Related Articles

- [28 Tools Behind a $1M Polymarket Trading Bot: Full Stack Breakdown](/resources/dev-utils/polymarket-trading-bot-stack/) — Complete trading bot architecture
- [Free Claude Code: Use Claude Code CLI for Free](/resources/ai-tools/free-claude-code-open-source-proxy/) — AI coding assistant

---

## Conclusion

**Polymarket Agents** provides a solid foundation for building AI-powered trading bots on prediction markets. The modular architecture, comprehensive API integration, and RAG capabilities make it suitable for both beginners and experienced developers.

**Best for**: Developers interested in algorithmic trading, prediction markets, and AI-driven decision making

**GitHub**: [https://github.com/Polymarket/agents](https://github.com/Polymarket/agents)

---


---

## Recommended Infrastructure for Self-Hosting

If you want to run this stack reliably 24/7, infrastructure choice matters:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

*Last updated: 2026-05-06*

<!--auto-references-->
## References & Sources

- [Polymarket Agents](https://github.com/Polymarket/agents)
- [py-clob-client](https://github.com/Polymarket/py-clob-client)
- [python-order-utils](https://github.com/Polymarket/python-order-utils)
- [clob-client](https://github.com/Polymarket/clob-client)
- [LangChain](https://github.com/langchain-ai/langchain)
- [Chroma](https://docs.trychroma.com)
