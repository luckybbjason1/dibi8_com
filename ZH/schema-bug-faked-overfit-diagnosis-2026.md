---
title: 'schema bug 伪造了我的 overfit 诊断：没人愿意谈的回测复盘'
description: '跑了 7 个量化实验，发现「教科书级 overfit」（Train PF 2.08 → OOS 0.94，比值 2.21）。然后才发现诊断本身就是错的 —— schema 字段静默错配导致 optimizer 用默认 10x leverage 跑，而不是进化出来的 2x。修正版本健康（比值 1.01）。这个 meta 教训比原诊断本身更难看。'
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
- /zh/posts/schema-bug-faked-overfit-diagnosis-2026/
faq:
  - q: "什么是 schema drift？为什么它能伪造回测结果？"
    a: "schema drift 指的是你 config 里的参数字段名跟运行时的 schema 已经对不上了。deserialization 会静默丢掉未知字段并使用默认值。如果这些默认值很激进（比如你本来想要 2x leverage，默认却是 10x），回测结果就会剧烈摇摆。数字看着像真的，但它来自一个跟你写的策略完全不同的策略。"
  - q: "原始的 overfit 诊断为什么看起来那么有说服力？"
    a: "教科书级特征：Train PF 2.08、OOS PF 0.94、比值 2.21。每个量化交易员都在文献里见过这个模式 —— optimizer 拟合了不会重复的噪音。「overfit」这个结论跟数据形状契合得天衣无缝。隐藏的 10x leverage 只是把所有东西都放大，让两个数字都变得极端。换成正确的 2x leverage，同样参数得到 Train 1.494 / OOS 1.478，比值 1.01 —— 无聊地稳定。"
  - q: "对于回测验证，meta 教训是什么？"
    a: "在信任任何回测结果之前，先验证你的参数字典确实加载了你写下的值。`from_dict()` 之后 `print(vars(params))`。如果某个字段被静默丢掉，你跑的就是另一个策略而不是你以为的那个。这一个 5 秒钟的检查本可以省下 7 次后续实验。"
  - q: "这是不是意味着这个策略其实没有 overfit？"
    a: "不完全。BTC 304 天的修正版本是稳定的（比值 1.01）。但跨资产在 8 个交易对上测试主要显示噪音（ratio_stdev > mean）。其中一个资产（DOT）看起来很棒，直到滚动前推分解暴露出 IS/OOS 比值 6.47 —— 真正教科书级的 overfit 藏在「跨资产成功」故事里面。这个策略只能算盈亏平衡，只不过原因跟最初诊断的不一样。"
  - q: "在生产环境里如何防御 schema drift？"
    a: "三层防御：（1）使用严格 deserialization（pydantic strict mode、dataclass 配 kw_only=True + frozen=True，或显式 Field validator 拒绝未知 key）。（2）把参数文件的 schema 版本和框架版本一起钉住。（3）在回测之前打印有效 params 并 assert 关键值（leverage、sl_atr_mult、各权重）。光靠严格 deserializer 就能静默捕获 90% 的此类问题。"
  - q: "经此事件后，新的「七不要」清单是什么？"
    a: "从 7 条扩展到 13 条。新增条目：不要信任没有 schema 验证的实验、不要在不足 200 个交易日的数据集上下结论、不要接受成交不足 30 次的 PF > 3、不要在没有跨资产验证的情况下上线策略、不要忽略 stdev/mean 比值（大于 1 = 噪音）、不要在没有分段分解的情况下汇报 PF、不要接受没有 IS/OOS 比值的报告。"
---

{{</* resource-info */>}}

# schema bug 伪造了我的 overfit 诊断

> **Meta Description**：跑了 7 个量化实验，「教科书级 overfit」最后被发现是个 schema bug。修正版本是稳定的。这个 meta 教训比原诊断本身更难看。

原始报告很干净。Train PF 2.08、OOS PF 0.94、比值 2.21。任何读过量化文献的人都能认出这个特征 —— optimizer 拟合了不会重复的噪音。归档为 overfit，继续下一题。

然后跑了后续实验。然后才发现诊断本身就是错的。

这是复盘。bug 不在策略里。bug 在于我们怎么相信那些数字。

## ⚡ TL;DR

> **原始结论**：BTC 304 天上的教科书级 overfit（PF 2.08 → 0.94，比值 2.21）。
>
> **真实发现**：schema 字段错配。`evolved_final_params.json` 用的是 `leverage` / `tp_atr_mult` 字段名；当前 schema 用的是 `base_leverage` / `tp_rr_ratio`。`from_dict()` 把它们静默丢掉了。实际运行用的是默认 10x leverage，而不是进化出来的 2x。
>
> **修正后结果**：PF 1.494 / 1.478，比值 1.01。无聊地稳定。没有 overfit。
>
> **但同时**：跨资产测试仍然最多只是盈亏平衡。DOT 的滚动前推 IS/OOS 比值 6.47 —— 真正教科书级的 overfit 藏在「幸运段」的故事里。
>
> **Meta 教训**：在信任回测输出之前，先验证参数加载。5 秒钟的 `print(vars(params))` 本可以省下 7 次实验。

## 原始「发现」

我们在 BTC/USDC 15 分钟 K 线上跑 moss-trade-bot-skills v1.0.26 paper 模式，2025 年 7 月 → 2026 年 4 月。304 天，29184 根 K 线，70/30 切分。

策略是框架的参数 optimizer 进化出来的均值回归变种。进化出来的配置看起来很合理：低 trend 权重、高均值回归权重、保守的 2x leverage、对称的 sl/tp。

回测结果回来很干净：
- Train（212 天）：PF 2.08
- OOS（92 天）：PF 0.94
- 比值：2.21

Train/OOS 比值高于 2.0 是教科书级的 overfit 特征。我们归档为「进化找到了 2025 Q3-Q4 特有的噪音，没能泛化」。故事说得通，跟数据吻合，本节结束。

## 戳穿故事的后续实验

第二天我们尝试做多资产验证 —— 同样进化出来的参数，在 ETH 上跑同一时间窗口。预期模式：如果参数捕捉到了信号，应该能泛化。

ETH 跑完。PF 1.154 → 0.697，比值 1.66。轻度 overfit，大致跟我们的诊断一致。

然后我们用 ETH 数据范围匹配的更短 148 天窗口测 BTC。同一资产不同子窗口。

结果：PF 0.980 → 1.581，比值 0.62。模式**反过来**了。OOS 比 Train 更好。

诊断从这里开始崩塌。

同样的参数、同样的资产、不同的时间窗口给出相反的模式。要么策略是噪音（确实），要么窗口的 regime 差异很大（也确实），要么 —— 这才是我们最终去检查的 —— 参数根本不是我们以为的那个。

## schema drift 来了

在 Python 典型的 `dataclass.from_dict()` 模式里，未知字段会被静默丢掉。pydantic 也一样，除非你开 strict mode。

进化出来的配置文件包含：

```json
{
  "leverage": 2,
  "sl_atr_mult": 2.5,
  "tp_atr_mult": 2.5,
  ...
}
```

运行时的 `DecisionParams` schema 期望：

```python
base_leverage: float = 10.0
max_leverage: float = 40.0
sl_atr_mult: float = ...
tp_rr_ratio: float = ...
```

`leverage` → 被静默丢掉 → `base_leverage` 默认为 **10.0**。
`tp_atr_mult` → 被静默丢掉 → `tp_rr_ratio` 默认为它自己的值。

我们以为自己在跑的「进化出来的 2x leverage 配对称 2.5/2.5 ATR multiplier」实际上变成了「默认 10x leverage 配默认 tp_rr_ratio」。

`from_dict()` 之后 5 秒钟的 `print(vars(params))` 本可以暴露这一切。我们没做。

## 修正后的数字

同样的 BTC 304 天、同样的 70/30 切分、同样进化出来的参数 —— 但正确映射到当前 schema 字段：

- Train PF：1.494
- OOS PF：1.478
- 比值：**1.01**

那不是 overfit。那是我们见过最稳定的 Train/OOS 比值之一。

策略没坏。坏的是诊断。

## 还成立的部分

修正后的结果在 BTC 304 天上是稳定的，但跨资产测试讲了一个不那么好看的故事。

8 个加密交易对，同样 148 天窗口，同样修正后的参数：

| 资产 | Train PF | OOS PF | 比值 |
|---|---|---|---|
| ETH | 1.154 | 0.697 | 1.66 |
| BNB | 1.512 | 0.213 | 7.10 |
| AVAX | 0.581 | 1.302 | 0.45 |
| LINK | 1.055 | 0.519 | 2.03 |
| ARB | 0.628 | 1.527 | 0.41 |
| DOT | 1.647 | 1.907 | 0.86 |
| NEAR | 0.358 | 1.415 | 0.25 |

比值标准差（2.42）超过均值（1.82）。当一个指标的离散度比它的中心趋势还大，你看到的就是噪音。

DOT 看起来像那个出挑的 —— Train 1.65、OOS 1.91，两边都强。但把 DOT 的 148 天切成五段约 30 天的子段后，单单 Segment 1（2025 年 10-11 月）就扛起了 PF 7.82 和全部 +1.67% 的收益。剩下四段加起来是 -0.68%。所谓「跨资产 alpha」就是一个走运的月份。

滚动前推测试证实了这一点：Segment 1 作 in-sample，Segment 2-5 作 out-of-sample。IS PF 7.82 → OOS PF 1.21。**IS/OOS 比值 6.47** —— 真正教科书级的 overfit 藏在一个表面数字看起来不错的资产里。

## 防御措施

三层，按投入/价值排序：

**1. 严格 deserialization。** 让你的参数加载器拒绝未知字段。在 Python 里：

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

原来的 `from_dict()` 把字段过滤到有效字段集合，**但遇到未知字段不抛错**。一个缺失的 `raise` 害我们花掉了 7 次实验。

**2. 在回测之前打印有效 params。** 三行：

```python
params = DecisionParams.from_dict(raw)
print(f"Effective: leverage={params.base_leverage}, sl={params.sl_atr_mult}, tp={params.tp_rr_ratio}")
assert params.base_leverage == raw.get("base_leverage", raw.get("leverage")), "leverage mismatch"
```

**3. 钉住参数文件的 schema 版本。** 当框架的 schema 改了，旧参数文件应该大声失败，而不是静默降级。

## 新的「七不要」—— 现在是十三条

经此事件，原来的 7 条回测纪律涨到了 13 条。新增 6 条直接来自这些实验：

- **不要信任没有 schema 验证的实验。** 回测前先打印 params。
- **不要在不足 200 个交易日的数据集上下结论。** 同一资产的 148 天子窗口给出了相反诊断。
- **不要接受成交不足 30 次的 PF > 3。** 默认红旗。
- **不要在没有跨资产验证的情况下上线策略。** 单资产稳定是必要条件，不是充分条件。
- **不要忽略 stdev/mean 比值。** 超过 1 就是噪音，不管均值看起来多好。
- **不要在没有分段分解的情况下汇报 PF。** 单窗口汇总会掩盖幸运段假象。

## 难的部分

原始报告在我们的存档里躺了一天，直到后续实验把它戳穿。如果我们停在「Train PF 2.08 → OOS 0.94、比值 2.21」，我们就会自信地分享一个错误的诊断。数字是真的。围绕数字编出来的故事不是。

回测结果容易产出、容易汇总、容易分享。验证数字背后的假设更难、更慢、更不讨好。但这是唯一一步能区分「我们跑了一个东西，结果是这样」和「我们知道发生了什么」。

如果这次复盘你只带走一个习惯：在每次回测之前打印你的有效 params。5 秒钟。省下 7 次实验。

## 推荐基础设施

用于滚动前推 + 多资产实验的脚手架：

- **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** —— 200 美元额度，方便开 GPU/CPU droplet
- **{{< aff "htstack" "footer-cta" "HTStack" >}}** —— 香港 VPS，到亚洲交易所 API 低延迟

*Affiliate 链接 —— 价格相同，支持 dibi8.com。*

---

**相关阅读**：[Moss Trade Bot Factory 2026 评测](https://dibi8.com/zh/resources/ai-trading/moss-trade-bot-factory-2026-review/) · [回测 OVERFIT 5 种模式 2026](https://dibi8.com/zh/resources/ai-trading/backtest-overfit-5-patterns-2026/) · [Backtrader Python 回测](https://dibi8.com/zh/resources/ai-trading/backtrader-python-backtesting/)
