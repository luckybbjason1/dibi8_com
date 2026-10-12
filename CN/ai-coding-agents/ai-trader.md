---


title: "Simplified training loop"
description: "AI tool guide"
date: 2026-09-20
slug: "ai-trader"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---


title: "Simplified training loop"
description: "AI tool guide"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack: - Go
  - Python
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "14.6 MB"
file_md5: ""
download_url: "https://github.com/HKUDS/AI-Trader"
backup_url: ""
last_maintained: "2026-05-13"
draft: false
aliases:
  - /posts/ai-trader/
faqs: - q: 'What is AI-Trader by HKUDS?'
    a: 'AI-Trader is an open-source fully automated AI trading agent system developed by the Hong Kong University Data Science Lab (HKUDS). It uses reinforcement learning and multi-agent collaboration to trade stocks, crypto, forex, and futures, and is released under the MIT license.'
  - q: 'Which markets and assets does AI-Trader support?'
    a: 'AI-Trader supports four markets: stocks (US, HK, and A-shares), crypto (BTC, ETH, and altcoins), forex (major pairs), and futures (commodities and indices). Each market uses tailored strategy types such as momentum, trend following, carry trade, and spread trading.'
  - q: 'What reinforcement learning algorithm does AI-Trader use?'
    a: 'AI-Trader uses Deep Reinforcement Learning, with PPO (Proximal Policy Optimization) as the training algorithm and an LSTM network for sequence modeling. Agents are trained on historical market data before deployment.'
  - q: 'How is AI-Trader''s multi-agent architecture organized?'
    a: 'AI-Trader splits trading into specialized agents: Analysis Agents (technical, fundamental, sentiment), a Decision Agent that chooses buy/sell/hold, a Risk Agent that monitors portfolio risk and runs stop-loss, and an Execution Agent that handles order placement and slippage control.'
  - q: 'Can I test AI-Trader without risking real money?'
    a: 'Yes. AI-Trader includes a high-fidelity backtesting engine for historical simulation and a paper trading mode (set mode: paper in the config). The project documentation recommends always using paper trading before deploying to live trading.'
