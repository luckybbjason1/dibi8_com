---


title: "Moss Trade Bot Factory Review 2026: AI Agent Quant Workbench — Why Pretty Backtests Lie"
description: "Technical guide and comparison"
date: 2026-09-20
slug: "moss-trade-bot-factory-2026-review"
category: "ai-tools"
tags: ["ai", "tools"]

categories: ["ai-coding-agents"]---


title: "Moss Trade Bot Factory Review 2026: AI Agent Quant Workb...
description: "Technical guide and comparison"
date: 2026-05-26T00:00:00+08:00
lastmod: 2026-05-26T00:00:00+08:00
tech_stack: [Python, pandas, numpy, ccxt, Hyperliquid]
application_domain: Ai Trading
source_version: "v1.0.26"
licensing_model: Open Source
license_type: MIT-0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
last_maintained: "2026-05-25"
draft: false
categories: ["ai-trading"]
tags: ["ai-agent", "quant", "backtest", "hyperliquid", "perpetuals", "open-source", "overfitting", "oos-validation"]
aliases:
  - /posts/moss-trade-bot-factory-2026-review/
faq: - q: "Is moss-trade-bot-factory safe to install?"
    a: "Yes for paper trading. Code audit confirms no eval/exec, HMAC-signed API calls that never upload your secret, MIT-0 license, and no wallet private key access. The skill is a quant strategy builder, not a custodial service. Live trading requires explicit bind to moss.site platform and connects to your own Hyperliquid wallet."
  - q: "What is the Sharpe annualization bug?"
    a: "backtest.py line 828 uses sqrt(8760) — the hourly annualization factor — but equity is stepped by 15-minute bars. The correct constant for 15m bars is sqrt(35040) = sqrt(365 × 24 × 4). Result: all default Sharpe values are systematically biased low by ~2x. Easy fix: replace 8760 with 35040 in your local copy."
  - q: "Does evolution mode actually improve results?"
    a: "In-sample yes, out-of-sample often no. Our hands-on test: Train period (212 days) Profit Factor improved 0.99 → 2.08 (doubled). OOS period (92 days) PF collapsed 1.68 → 0.94, win rate dropped 14 percentage points, return reversed +7.22% → -2.43%. This is textbook in-sample fitting — the LLM reflection memorizes Train noise rather than learning market structure."
  - q: "Why does the skill default to ai.moss.site platform?"
    a: "Moss is a commercial AI trading platform; the open-source skill is their distribution channel. You can run the entire backtest pipeline offline without touching the platform — just skip live_trade.py / package_upload.py / live_runner.py. The platform integration adds leaderboard and copy-trading features but is optional."
  - q: "Can I use evolved params for live trading?"
    a: "Not recommended without independent OOS validation. The skill's built-in evolution loop has no OOS split — it reflects on segments and adjusts params on the same data it was tested on. Run your own 70/30 train/OOS split and verify evolved params survive out-of-sample before any real capital. Most evolved param sets fail this test."
  - q: "What strategies actually work on Hyperliquid perps based on the data?"
    a: "Limited to v1.0.26 BTC 304-day data: mean-revert dominated grids on 2-3x leverage produced the only positive return (+4.36%). Trend-following with 5-10x leverage lost -8% to -20% over the same window. This is regime-specific — BTC 2025-07 to 2026-04 was choppy. The same grid logic would likely lose in a strong trending market."
