---
title: 'Moss Trade Bot Factory Review 2026: AI Agent Quant Workbench — Why Pretty Backtests Lie'
description: 'Hands-on review of moss-trade-bot-skills v1.0.26: a natural-language quant agent builder for Hyperliquid perps. Industrial-grade backtest engine with Decimal precision and depth-book modeling — but a Sharpe annualization bug and a textbook OVERFIT trap once you enable evolution. Setup walkthrough, OOS validation results, and the honest take on whether evolved params survive out-of-sample.'
date: 2026-05-26 00:00:00+08:00
lastmod: 2026-05-26 00:00:00+08:00
tech_stack: ['Python', 'pandas', 'numpy', 'ccxt', 'Hyperliquid']
application_domain: Ai Trading
source_version: 'v1.0.26'
licensing_model: Open Source
license_type: MIT-0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/moss-site/moss-trade-bot-skills'
stars: 98
maintainer: 'moss-site'
last_maintained: '2026-05-25'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: ['ai-agent', 'quant', 'backtest', 'hyperliquid', 'perpetuals', 'open-source', 'overfitting', 'oos-validation']
aliases:
- /posts/moss-trade-bot-factory-2026-review/
faq:
  - q: "Is moss-trade-bot-factory safe to install?"
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
---

{{</* resource-info */>}}

# Moss Trade Bot Factory Review 2026: AI Agent Quant Workbench — Why Pretty Backtests Lie

> **Meta Description**: Moss Trade Bot Factory is an MIT-licensed natural-language quant agent builder for Hyperliquid perps with an industrial-grade Decimal-precision backtest engine — but a Sharpe bug and a textbook OVERFIT trap once you enable evolution. This review covers the audit, the install, the bug fix, and the only validation that matters: out-of-sample.

If you've ever opened a YouTube "I made $50k with my AI trading bot" video, you've seen the trick: pretty backtest curves, evolved parameters, a Sharpe ratio of 3.5, and a screenshot of the broker dashboard. What you almost never see is the same params run on data the bot has never touched.

**That gap — between in-sample fantasy and out-of-sample reality — is what this review is about.**

Moss Trade Bot Factory (`moss-trade-bot-skills` v1.0.26, MIT-0) is an open-source AI agent that turns natural-language trading style descriptions ("Livermore trend-following, conservative leverage, breakout strategy") into fully parameterized Hyperliquid perp strategies, runs local backtests on shipped CSV data, and optionally evolves parameters via LLM reflection. After two days of hands-on testing — including a security audit, a Sharpe-annualization bug fix, five strategy comparisons, evolution mode, and a strict 70/30 train/OOS validation — the verdict is more nuanced than either fans or skeptics will tell you.

## ⚡ TL;DR — 90-Second Verdict

> **What it is**: An open-source CLI skill that converts natural-language strategy descriptions into 30+ Hyperliquid perp parameters, runs Decimal-precision backtests on shipped CSV data, and offers an LLM-reflection-driven evolution loop.
>
> **What it's not**: A live trading system (without explicit `--platform-url` bind to ai.moss.site). Not a paper-trading sandbox in the traditional sense — backtests are historical replay, not real-time market emulation.
>
> **Best for**: Quant learners who want to see industrial-grade backtest internals (Decimal arithmetic, 20-level depth book modeling, liquidation accounting). Strategy designers comparing rule-based templates against natural-language LLM-generated parameters.
>
> **Not for**: Anyone planning to deploy evolved params to live without independent OOS validation. The evolution loop is an in-sample fitting machine with cosmetic LLM commentary, not a learning system. We document the proof below.
>
> **Open-source posture**: MIT-0 license, no `eval`/`exec`, HMAC-signed platform calls that never upload secrets, no wallet private key access. The funnel is moss.site (a commercial AI trading platform), but the local backtest pipeline runs entirely offline.

---

## What Moss Trade Bot Factory Is (And Isn't)

The project lives at [github.com/moss-site/moss-trade-bot-skills](https://github.com/moss-site/moss-trade-bot-skills) under the `moss-site` GitHub org (Moss AI, [moss.site](https://moss.site), founded 2025-07). As of v1.0.26 (released 2026-05-25) it has 98 stars, 14 forks, 101 commits, and three contributors (slowfirary 79 commits, fei-moss 14, lokix006 1).

Mechanically, the skill works in three stages:

1. **Parse**: Natural-language input ("BTC conservative grid for the last 90 days") is parsed by the agent into a structured `params.json` covering 30+ tactical and personality parameters — five signal weights (trend / momentum / mean-revert / volume / volatility), leverage, entry/exit thresholds, ATR-based stop and target multipliers, regime-switching parameters, and more.

2. **Replay**: Backtest engine reads shipped Hyperliquid CSV data (15m bars, 43 symbols, 148–304 days of coverage) and replays trades using:
   - Decimal-precision accounting (aligned with the Moss platform's Go `shopspring/decimal` backend)
   - 20-level frozen depth book templates for realistic slippage modeling
   - Explicit liquidation accounting via maintenance margin breach detection
   - Cross-margin simulation (single contract, not multi-asset portfolio margin)
   - Funding rate settlement at hourly intervals (fixed rate `0.0000125`, not real historical funding)

3. **Reflect & Evolve** (optional): Splits the backtest window into segments (default 4000 bars ≈ 41.7 days per segment), runs baseline on each segment, then invokes an LLM agent to read segment-level summaries (exit reasons, win/loss averages, market context) and produce a per-segment parameter schedule that drift-bounded ±30% from baseline. Personality parameters (signal weights, leverage, long_bias) are locked.

The pitch in the README is real: this is more than a vectorbt-style toy. The Decimal precision and depth-book modeling put it ahead of most open-source quant tools we've reviewed. The backtest internals genuinely teach you what production replay code looks like.

The pitch that doesn't quite land is the evolution loop. We'll get to that.

## How the Backtest Engine Actually Works

For anyone evaluating quant tools, the engine internals matter more than the marketing. Three things stand out in `scripts/core/backtest.py`:

### 1. Look-Ahead Bias Defense (Mostly Good)

The replay loop feeds the strategy bars `range(last_fed_idx + 1, end_idx)` — strictly stopping before the evaluation bar's close. Mark price for execution is synthesized as `open + (close-open)/15`, simulating the first minute of the next 15m bar. This is correct in principle but assumes linear price progression within a bar, which is wrong during high-volatility regimes. Not a bug, but a known approximation.

### 2. Liquidation Modeling (Correct)

Maintenance margin breach is checked against bar high (for shorts) and bar low (for longs) on every replay step. Position is force-closed at the liquidation price if a breach occurs. The `blowup_count` field in results tracks how many times your strategy got wiped — across all five strategies we tested on 304 days of BTC data, blowup count was 0, confirming the leverage caps and ATR stops actually trigger.

### 3. The Sharpe Annualization Bug

`backtest.py:828` originally read:

```python
sharpe = (valid_returns.mean() / valid_returns.std(ddof=0) * np.sqrt(8760)) ...
```

Here `8760` is the hourly-bar annualization constant (`365 × 24`). But `equity` is stepped at 15-minute intervals (see `equity_points.append` at line 735). The correct constant is `35040` = `365 × 24 × 4`. The original constant matches the Moss platform's Go backend for verify parity, but for any local backtest comparison or absolute Sharpe interpretation, **all default Sharpe values are biased low by approximately 2x**.

Easy fix:

```python
ANNUALIZATION_FACTOR = 35040  # 15m bars per year
sharpe = (valid_returns.mean() / valid_returns.std(ddof=0) * np.sqrt(ANNUALIZATION_FACTOR)) ...
```

If you plan to upload backtests to moss.site for verification, revert to `8760`. If you're learning quant or comparing strategies locally, use `35040`.

## Installation: 10 Minutes End-to-End

This is the only AI agent skill we've installed without a single env-var fight. The standard workflow:

```bash
git clone --depth 1 --branch v1.0.26 https://github.com/moss-site/moss-trade-bot-skills.git
cd moss-trade-bot-skills/moss-trade-bot-factory/scripts
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
```

Dependencies are minimal: `pandas≥2.0`, `numpy≥1.24`, `ccxt≥4.0`. First run of `dataset_catalog.py` triggers a one-time download of ~100MB of historical CSV data from a GitHub Release Asset (not from moss.site — they pin data by SHA256 to a tagged release for reproducibility). After that, everything runs offline.

To list available symbols:

```bash
python3 dataset_catalog.py --list --timeframe 15m
```

Output covers 43 Hyperliquid symbols: BTC (304 days), ETH/SOL/ADA/AAVE etc. (148 days), plus tokenized stocks (TSLA, NVDA, MSTR) and commodities (GOLD, SILVER, BRENTOIL, SP500).

## Five Strategy Comparison: What Actually Works

We ran five hand-crafted strategies across BTC's full 304-day window (2025-07-01 to 2026-04-30) with $10,000 starting capital. Same data, same engine, different parameter philosophies.

| Strategy | Leverage | Final Equity | Return | Win Rate | Max DD | PF | Trades |
|---|---|---|---|---|---|---|---|
| Conservative Grid (mean-revert) | 2x | $10,436 | **+4.36%** ✅ | 51.9% | -22.8% | 1.27 | 214 |
| High-Frequency Breakout | 10x | $9,207 | -7.93% | 42.0% | -17.4% | 1.04 | 100 |
| Volatility-Adaptive | 3x | $9,175 | -8.25% | 42.9% | -14.9% | 0.85 | 49 |
| Volume Momentum | 5x | $9,098 | -9.02% | 44.1% | -14.9% | 0.65 | 34 |
| **Livermore Trend** | **5x** | **$7,989** | **-20.11%** ❌ | 36.2% | -26.6% | 0.80 | 105 |

Three findings worth pausing on:

**Leverage and return were strictly inversely correlated.** The 2x grid won. The 10x breakout did better than the 5x trend follower but only barely. There's a strong empirical case here that for natural-language-generated strategies on choppy markets, anything above 3x is structural overconfidence.

**Win rate is not destiny.** Livermore Trend's 36.2% win rate is normal for trend-following (trend strategies expect a small number of large wins to overcome many small losses). The reason it lost wasn't its win rate — it was that the BTC window was a sideways/choppy market where trends kept failing. Right strategy, wrong regime.

**Zero blowups across all five.** The leverage caps and ATR-based stops work as advertised. We never hit forced liquidation, even on 10x leverage. The risk-management primitives are solid.

## The Evolution Trap: Pretty Backtests, Empty OOS

Here's where the review gets controversial. The README sells the evolution loop as the "core innovation" — segment-by-segment reflection that micro-tunes tactical parameters while keeping personality locked. It sounds disciplined: ±30% drift bounds, blocked-segment quality signals, walk-forward reflection.

It also produces beautiful backtests that fail out-of-sample.

### Our Methodology

1. Split BTC 304 days into Train (70% = 212 days) and OOS (30% = 92 days).
2. Run baseline (conservative grid params unchanged) on Train, segmented into 5 × ~41-day chunks.
3. Manually act as the reflection agent: identify failing segment (Seg 4: -6.11%, 42.3% win rate, market dropped -19.6% during a regime mislabeled SIDEWAYS), generate a 5-round evolution schedule with tactical-only tweaks (entry_threshold 0.45 → 0.50, sl_atr_mult 3.0 → 2.5, tp_atr_mult 2.0 → 2.5).
4. Re-run baseline on Train with the evolution schedule applied.
5. **Lock the evolved final params. Run them on OOS. Do not adjust anything.**

### The Results

| Metric | Train Base | Train Evolved | OOS Base | OOS Evolved |
|---|---|---|---|---|
| Return | +3.02% | **+5.60%** ✅ | +7.22% | **-2.43%** ❌ |
| Annualized | +5.20% | +9.64% | +28.63% | -9.64% |
| Win Rate | 57.6% | 49.3% | 53.1% | 39.1% |
| Max DD | -16.34% | -9.25% ✅ | -6.64% | -4.77% |
| **Profit Factor** | 0.99 | **2.08** ✅ | 1.68 | **0.94** ❌ |
| Trades | 116 | 69 | 49 | 23 |

Read the Train columns first. Profit Factor doubled. Max Drawdown halved. By any in-sample metric, the evolution succeeded brilliantly. The failing Seg 4 recovered from -6.11% to +3.20% — exactly the targeted fix.

Now read the OOS columns. Profit Factor collapsed from 1.68 to 0.94. Win rate dropped 14 percentage points. The +7.22% baseline return on the unseen 92 days turned into a -2.43% loss with the "improved" parameters.

This is the textbook signature of in-sample fitting. The evolution loop didn't learn market structure — it memorized Train-segment noise. The LLM reflection looked like reasoning ("Seg 4 failed due to mean-revert entries on a downtrend; tighten stops and raise threshold"), but the proof is in the OOS gap: **+2.58 percentage points improvement on Train translated to -9.65 percentage points degradation on OOS**.

### Why This Matters Beyond One Skill

Every quant tool that markets "AI-driven parameter optimization" or "reflective evolution" without showing OOS validation results is selling the same trap. The pattern is universal:

1. Train-period reflection finds a story for every failing segment
2. Tactical micro-tuning fits the story
3. In-sample metrics improve dramatically (PF doubles, drawdown halves)
4. OOS reveals the truth: the params memorized noise, not signal

Moss isn't uniquely guilty. The skill is open-source, the data is available, the bug is fixable. What we want from the next generation of these tools is a built-in OOS gate: refuse to publish evolved params unless they pass independent OOS validation. Until then, treat any evolution report as in-sample marketing.

## Honest Pricing & Funnel Analysis

The skill itself is free (MIT-0). The funnel is moss.site, where you can:

- Bind your bot to the Moss platform for live copy-trading (real funds on Hyperliquid via your own wallet)
- Upload backtests for platform verification
- Compete on the leaderboard
- Subscribe to other agents' signals

We did not test the platform side. The README disclaims this is a research and educational tool, and we kept it that way. If you want to live-trade, you'll need your own Hyperliquid wallet, real USDC, and the patience to ignore Train-only backtest metrics.

The org runs in clear funnel mode (6 repos, one with stars, the rest support infrastructure: `moss-og-pass-nft` for membership, `moss-bounty-x402-client` for payments, `Hyperliquid-copy-trade` for execution). Not evil — standard open-core distribution — but worth knowing when the skill defaults to `ai.moss.site` for every platform-touching command.

## When This Skill Is the Right Tool

Use it if:

- You want to learn what industrial-grade backtest engines look like (Decimal arithmetic, depth book, liquidation accounting)
- You're comparing rule-based strategy templates and want a consistent harness
- You want to run paper backtests on real Hyperliquid historical data without writing the data pipeline yourself
- You can read enough Python to fix the Sharpe annualization bug and ignore the evolution loop until you've added your own OOS validation step

Skip it if:

- You want to live-trade without learning the OOS validation rigor
- You expect "evolved" backtest results to translate to forward performance
- You need walk-forward analysis, regime-specific OOS validation, or significance testing — none of those are built in
- You don't want to think about platform funnel and would rather use a completely community-driven tool

## Limitations We Hit

After two days of intensive testing:

- **Sharpe annualization bug** (covered above). Fixable in one line.
- **No built-in train/test split**. You'll need to write your own CSV slicer and result comparator. We have ours in [our 95至尊交易员记忆 archive](https://github.com/luckybbjason1/home-hermes/tree/main/95%E8%87%B3%E5%B0%8A%E4%BA%A4%E6%98%93%E5%91%98%E8%AE%B0%E5%BF%86).
- **Regime detection labels can be wrong**. Seg 4 was labeled SIDEWAYS but BTC dropped -19.6% during that window. The regime detector in `core/regime.py` deserves its own audit.
- **Funding rate is a fixed constant** (`0.0000125` per hour). Real Hyperliquid funding fluctuates. Long-duration positions will see backtest-vs-live divergence here.
- **No multi-asset cross-margin**. Single-contract cross-margin only. Portfolio strategies need custom work.

## Recommended Infrastructure for Self-Hosting

If you want to run your own quant backtest pipeline 24/7 with a dedicated VPS:

- **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — $200 free credit for 60 days. Good entry point for indie quants prototyping backtest pipelines.
- **{{< aff "htstack" "footer-cta" "HTStack" >}}** — Hong Kong VPS with low-latency access from mainland China. Same IDC that hosts dibi8.com.

*Affiliate links — they don't cost you extra and help keep dibi8.com running.*

## Bottom Line

Moss Trade Bot Factory is the most genuinely useful open-source quant skill we've reviewed in 2026. The backtest engine is industrial-grade. The HMAC client is correctly designed. The MIT-0 license is unusually permissive. The Hyperliquid CSV dataset is real and SHA256-pinned.

But the marketing emphasis on the evolution loop misleads beginners into shipping in-sample-fit parameters to live capital. Until the project adds OOS validation gates (or until someone forks and adds them), treat the evolution feature as a teaching tool for what *not* to trust, not a path to alpha.

Install it, fix the Sharpe bug, run five hand-crafted strategies to see how the engine behaves, then write your own train/OOS splitter. That last step — the one nobody teaches and Moss doesn't enforce — is the single most important habit in quant.

The bots aren't going to teach you to be honest about your edge. You have to do that yourself.

---

**GitHub**: [moss-site/moss-trade-bot-skills](https://github.com/moss-site/moss-trade-bot-skills) · **License**: MIT-0 · **Latest**: v1.0.26 (2026-05-25) · **Stars**: 98 · **Maintainer**: moss-site / Moss AI ([moss.site](https://moss.site))
