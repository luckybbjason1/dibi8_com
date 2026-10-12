---


title: "Get all markets sorted by volume"
description: "Technical guide and comparison"
date: 2026-09-20
slug: "polymarket-agents-ai-trading-bot-framework"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---


title: "Polymarket Agents: Build AI Trading Bots for Prediction ...
description: "Technical guide and comparison"
  AI agents that trade autonomously on Polymarket prediction markets.
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack: - Docker
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
last_maintained: "2024-11-05"
draft: false
aliases:
  - /en/posts/polymarket-agents-ai-trading-bot-framework/
- /posts/ai-trader-fully-automated-trading-agent/
- /posts/polymarket-agents-ai-trading-bot-framework/
faqs: - q: 'What is Polymarket Agents?'
    a: 'Polymarket Agents is an open-source, MIT-licensed developer framework for building AI agents that trade autonomously on Polymarket prediction markets. It provides utilities to analyze markets, integrate with the Polymarket API for real-time data, and execute trades automatically.'
  - q: 'What do I need to set up before running Polymarket Agents?'
    a: 'You need a Polygon wallet private key and an OpenAI API key set in a .env file, plus a Python 3.9 virtual environment with dependencies installed from requirements.txt. You must also fund your Polygon wallet with USDC, since trades on Polymarket are settled in USDC.'
  - q: 'How does Polymarket Agents use RAG for trading decisions?'
    a: 'It uses a Chroma vector database to store news articles and market data, converts text into embeddings for semantic search, retrieves relevant information based on the current market context, and lets the LLM synthesize that retrieved data into a trading decision.'
  - q: 'What trading strategies does Polymarket Agents support?'
    a: 'The framework supports news-based trading (LLM sentiment analysis of events), arbitrage detection across related markets, trend following based on volume and price movements, and fundamental analysis using RAG to query historical data.'
  - q: 'How do I execute a trade with the Polymarket Agents CLI?'
    a: 'Run the CLI command ''python scripts/python/cli.py trade --market-id  --side buy --size ''. You can also list markets with ''get-all-markets --sort-by volume'' or inspect a single market with ''get-market --market-id ''.'
