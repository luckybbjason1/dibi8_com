---
title: 'Schema Bug Faked My Overfit Diagnosis: The Backtest Postmortem Nobody Talks About'
description: 'Ran 7 quant experiments, found "textbook overfit" (Train PF 2.08 → OOS 0.94, ratio 2.21). Then discovered the diagnosis itself was wrong — silent schema field mismatch made the optimizer run with default 10x leverage instead of the evolved 2x. The corrected version is healthy (ratio 1.01). The meta-lesson is uglier than the original.'
date: 2026-05-26 00:00:00+08:00
lastmod: 2026-05-26 00:00:00+08:00
tech_stack: ['Python', 'pandas', 'numpy', 'vectorbt', 'backtrader', 'pydantic']
application_domain: AI Trading
source_version: 'moss-trade-bot-skills v1.0.26'
licensing_model: Open Source
license_type: MIT
github_repo: ''
stars: 0
maintainer: 'dibi8 editorial'
last_maintained: '2026-05-26'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: ['backtest', 'overfit', 'quant', 'schema-drift', 'walk-forward', 'postmortem', '2026']
aliases:
- /posts/schema-bug-faked-overfit-diagnosis-2026/
faq:
  - q: "What is schema drift and why does it fake backtest results?"
    a: "Schema drift means parameter field names in your config no longer match the runtime schema. The deserializer silently drops unknown fields and uses defaults. If those defaults are aggressive (like 10x leverage when you intended 2x), backtest results swing massively. The numbers look real but they came from a different strategy than the one you wrote."
  - q: "How did the original overfit diagnosis look so convincing?"
    a: "Textbook signature: Train PF 2.08, OOS PF 0.94, ratio 2.21. Every quant trader has seen this pattern in literature — the optimizer fits noise that doesn't repeat. The conclusion 'overfit' fit the data shape perfectly. The hidden 10x leverage just amplified everything, making both numbers extreme. With the correct 2x leverage, the same parameters give Train 1.494 / OOS 1.478 ratio 1.01 — boringly stable."
  - q: "What's the meta-lesson for backtest validation?"
    a: "Before trusting any backtest result, validate that your parameter dictionary actually loaded the values you wrote. `print(vars(params))` after `from_dict()`. If a field silently dropped, you're running a different strategy than you think. This single 5-second check would have saved 7 follow-up experiments."
  - q: "Does this mean overfit doesn't exist in this strategy?"
    a: "Not exactly. The corrected version on BTC 304d is stable (ratio 1.01). But cross-asset testing on 8 pairs showed mostly noise (ratio_stdev > mean). One asset (DOT) looked great until walk-forward decomposition revealed IS/OOS ratio 6.47 — actual textbook overfit hiding inside a 'cross-asset success' story. The strategy is break-even, just for different reasons than originally diagnosed."
  - q: "How do you defend against schema drift in production?"
    a: "Three layers: (1) Use strict deserialization (pydantic strict mode, dataclass with kw_only=True + frozen=True, or explicit Field validator that rejects unknown keys). (2) Pin parameter file schema version alongside framework version. (3) Print effective params right before backtest and assert key values (leverage, sl_atr_mult, weights). The strict deserializer alone catches 90% of these silently."
  - q: "What's the new 'Seven Don'ts' list after this?"
    a: "Expanded from 7 to 13. The new entries: don't trust experiments without schema validation, don't make calls on datasets under 200 trading days, don't accept PF > 3 with under 30 trades, don't ship strategies without cross-asset validation, don't ignore stdev/mean ratio (over 1 = noise), don't report PF without per-segment decomposition, don't accept reports without IS/OOS ratio."
---

{{</* resource-info */>}}

# Schema Bug Faked My Overfit Diagnosis

> **Meta Description**: Ran 7 quant experiments, "textbook overfit" turned out to be a schema bug. The corrected version is stable. The meta-lesson is uglier than the original.

The original report was clean. Train PF 2.08, OOS PF 0.94, ratio 2.21. Anyone who has read quant literature recognizes this signature — the optimizer fits noise that doesn't repeat. Filed it as overfit, moved on.

Then came the follow-up experiments. And the discovery that the diagnosis itself was wrong.

This is the postmortem. The strategy isn't where the bug is. The bug is in how we believed the numbers.

## ⚡ TL;DR

> **Original conclusion**: Textbook overfit on BTC 304d (PF 2.08 → 0.94, ratio 2.21).
>
> **Real finding**: Schema field mismatch. `evolved_final_params.json` used `leverage` / `tp_atr_mult` field names; current schema uses `base_leverage` / `tp_rr_ratio`. `from_dict()` silently dropped them. Actual run used default 10x leverage, not the evolved 2x.
>
> **Corrected result**: PF 1.494 / 1.478, ratio 1.01. Boringly stable. Not overfit.
>
> **But also**: Cross-asset test still shows break-even at best. DOT walk-forward IS/OOS ratio 6.47 — actual textbook overfit hiding in a "lucky segment" story.
>
> **Meta-lesson**: Validate parameter loading before trusting backtest output. Five seconds of `print(vars(params))` would have saved seven experiments.

## The Original "Discovery"

We ran moss-trade-bot-skills v1.0.26 paper mode on BTC/USDC 15m bars, July 2025 → April 2026. 304 days, 29184 bars, 70/30 split.

The strategy was a mean-revert variant evolved by the framework's parameter optimizer. The evolved configuration looked sensible: low trend weight, high mean-revert weight, conservative 2x leverage, symmetric sl/tp.

Backtest results came back clean:
- Train (212 days): PF 2.08
- OOS (92 days): PF 0.94
- Ratio: 2.21

Train/OOS ratio above 2.0 is the textbook overfit signature. We filed it under "evolution found Q3-Q4 2025 specific noise, didn't generalize." Plausible story, matched the data, end of session.

## The Follow-up That Broke the Story

The next day we tried multi-asset validation — same evolved parameters on ETH for the same window. Expected pattern: if parameters captured signal, they should generalize.

ETH ran. PF 1.154 → 0.697, ratio 1.66. Mild overfit, mostly consistent with our diagnosis.

Then we tested BTC on a shorter 148-day window matching ETH's data range. Different sub-window of the same asset.

Result: PF 0.980 → 1.581, ratio 0.62. **Reversed** pattern. OOS better than Train.

That's where the diagnosis started failing.

Same parameters, same asset, different time windows giving opposite patterns. Either the strategy is noise (true), or the windows have very different regimes (also true), or — and this is what we eventually checked — the parameters weren't what we thought.

## The Schema Drift

In Python's typical `dataclass.from_dict()` pattern, unknown fields are silently dropped. Pydantic does it too unless you set strict mode.

The evolved configuration file contained:

```json
{
  "leverage": 2,
  "sl_atr_mult": 2.5,
  "tp_atr_mult": 2.5,
  ...
}
```

The runtime `DecisionParams` schema expected:

```python
base_leverage: float = 10.0
max_leverage: float = 40.0
sl_atr_mult: float = ...
tp_rr_ratio: float = ...
```

`leverage` → silently dropped → `base_leverage` defaults to **10.0**.
`tp_atr_mult` → silently dropped → `tp_rr_ratio` defaults to its own value.

The "evolved 2x leverage with symmetric 2.5/2.5 ATR multipliers" we thought we were running was actually "default 10x leverage with whatever the default tp_rr_ratio is."

Five seconds of `print(vars(params))` after `from_dict()` would have shown this. We didn't do it.

## The Corrected Numbers

Same BTC 304d, same 70/30 split, same evolved parameters — but mapped correctly to current schema fields:

- Train PF: 1.494
- OOS PF: 1.478
- Ratio: **1.01**

That's not overfit. That's one of the most stable Train/OOS ratios we've ever seen.

The strategy isn't broken. The diagnosis was broken.

## What Was Still True

The corrected results are stable on BTC 304d, but cross-asset testing tells a less flattering story.

Eight crypto pairs, same 148-day window, same corrected parameters:

| Asset | Train PF | OOS PF | Ratio |
|---|---|---|---|
| ETH | 1.154 | 0.697 | 1.66 |
| BNB | 1.512 | 0.213 | 7.10 |
| AVAX | 0.581 | 1.302 | 0.45 |
| LINK | 1.055 | 0.519 | 2.03 |
| ARB | 0.628 | 1.527 | 0.41 |
| DOT | 1.647 | 1.907 | 0.86 |
| NEAR | 0.358 | 1.415 | 0.25 |

Ratio stdev (2.42) exceeds mean (1.82). When the spread of a metric is larger than its central tendency, you're looking at noise.

DOT looked like the standout — Train 1.65, OOS 1.91, both strong. But splitting DOT's 148 days into five ~30-day segments revealed Segment 1 alone (Oct-Nov 2025) carried PF 7.82 and the entire +1.67% return. The other four segments combined to -0.68%. The "cross-asset alpha" was one lucky month.

A walk-forward test confirmed: Segment 1 as in-sample, Segments 2-5 as out-of-sample. IS PF 7.82 → OOS PF 1.21. **IS/OOS ratio 6.47** — the actual textbook overfit hiding inside an asset where the surface-level numbers looked good.

## The Defenses

Three layers, in order of effort/value:

**1. Strict deserialization.** Make your parameter loader reject unknown fields. In Python:

```python
@dataclass(frozen=True, kw_only=True)
class DecisionParams:
    base_leverage: float = 10.0
    # ...
    
    @classmethod
    def from_dict(cls, d: dict) -> "DecisionParams":
        valid = {f.name for f in cls.__dataclass_fields__.values()}
        unknown = set(d.keys()) - valid
        if unknown:
            raise ValueError(f"Unknown fields: {unknown}")
        return cls(**{k: v for k, v in d.items() if k in valid})
```

The original `from_dict()` filtered to valid fields *without raising* on unknown fields. One missing `raise` cost seven experiments.

**2. Print effective params before backtest.** Three lines:

```python
params = DecisionParams.from_dict(raw)
print(f"Effective: leverage={params.base_leverage}, sl={params.sl_atr_mult}, tp={params.tp_rr_ratio}")
assert params.base_leverage == raw.get("base_leverage", raw.get("leverage")), "leverage mismatch"
```

**3. Pin parameter file schema version.** When the framework's schema changes, old parameter files should fail loudly, not silently degrade.

## The New "Seven Don'ts" — Now Thirteen

The original seven backtest discipline rules grew to thirteen after this incident. The six new ones come directly from these experiments:

- **Don't trust experiments without schema validation.** Print params before backtest.
- **Don't make calls on datasets under 200 trading days.** 148-day sub-windows of the same asset gave opposite diagnoses.
- **Don't accept PF > 3 with under 30 trades.** Default red flag.
- **Don't ship strategies without cross-asset validation.** Single-asset stability is necessary, not sufficient.
- **Don't ignore stdev/mean ratio.** Above 1 means noise, no matter how good the mean looks.
- **Don't report PF without per-segment decomposition.** Single-window summaries hide lucky-segment artifacts.

## The Hard Part

The original report sat in our archive for a day before the follow-up exposed it. If we had stopped at "Train PF 2.08 → OOS 0.94, ratio 2.21" we would have shared a confidently wrong diagnosis. The numbers were real. The story we told around them wasn't.

Backtest results are easy to produce, easy to summarize, easy to share. Validating the assumptions behind the numbers is harder, slower, and less rewarding. But it's the only step that distinguishes "we ran a thing and here's what happened" from "we know what happened."

If you only take one habit from this postmortem: print your effective params before every backtest. Five seconds. Saves seven experiments.

## Recommended Infrastructure

For walk-forward + multi-asset experiment scaffolding:

- **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — $200 credit, easy GPU/CPU droplets
- **{{< aff "htstack" "footer-cta" "HTStack" >}}** — Hong Kong VPS, low-latency to Asia exchange APIs

*Affiliate links — same price, supports dibi8.com.*

---

**Related**: [Moss Trade Bot Factory 2026 Review](https://dibi8.com/resources/ai-trading/moss-trade-bot-factory-2026-review/) · [Backtest OVERFIT 5 Patterns 2026](https://dibi8.com/resources/ai-trading/backtest-overfit-5-patterns-2026/) · [Backtrader Python Backtesting](https://dibi8.com/resources/ai-trading/backtrader-python-backtesting/)
