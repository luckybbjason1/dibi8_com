---
title: '스키마 버그가 가짜로 만든 Overfit 진단: 아무도 말하지 않는 백테스트 사후 분석'
description: '7번의 퀀트 실험을 돌려 「교과서적 overfit」을 발견했습니다 (Train PF 2.08 → OOS 0.94, ratio 2.21). 그런데 진단 자체가 틀렸다는 사실이 밝혀졌습니다 — 조용한 schema 필드 불일치 때문에 옵티마이저가 진화된 2x leverage 가 아니라 기본값 10x leverage 로 돌아갔던 것입니다. 교정된 버전은 건강합니다 (ratio 1.01). 메타 교훈은 원본보다 더 추합니다.'
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
- /kr/posts/schema-bug-faked-overfit-diagnosis-2026/
faq:
  - q: "schema drift 란 무엇이며 왜 백테스트 결과를 가짜로 만듭니까?"
    a: "schema drift 란 설정 파일의 파라미터 필드 이름이 런타임 schema 와 더 이상 일치하지 않는 것을 의미합니다. 디시리얼라이저는 알 수 없는 필드를 조용히 버리고 기본값을 사용합니다. 그 기본값이 공격적이라면 (예: 2x 를 의도했는데 10x leverage), 백테스트 결과는 극단적으로 흔들립니다. 숫자는 진짜처럼 보이지만 실제로는 작성한 전략이 아닌 다른 전략에서 나온 결과입니다."
  - q: "원본 overfit 진단은 어떻게 그렇게 설득력 있어 보였습니까?"
    a: "교과서적 시그니처입니다: Train PF 2.08, OOS PF 0.94, ratio 2.21. 모든 퀀트 트레이더는 문헌에서 이 패턴을 본 적이 있습니다 — 옵티마이저가 반복되지 않는 노이즈에 핏 되는 현상입니다. 「overfit」이라는 결론은 데이터 모양에 완벽하게 맞았습니다. 숨겨진 10x leverage 가 모든 것을 증폭시켜 양쪽 숫자를 극단적으로 만들었습니다. 올바른 2x leverage 로는 동일한 파라미터가 Train 1.494 / OOS 1.478, ratio 1.01 — 지루할 정도로 안정적입니다."
  - q: "백테스트 검증의 메타 교훈은 무엇입니까?"
    a: "어떤 백테스트 결과라도 신뢰하기 전에, 파라미터 딕셔너리가 실제로 작성한 값을 로드했는지 검증해야 합니다. `from_dict()` 이후에 `print(vars(params))` 를 호출하면 됩니다. 필드가 조용히 누락되었다면, 생각한 것과 다른 전략을 돌리고 있는 셈입니다. 이 5초짜리 체크 하나가 7개의 후속 실험을 절약했을 것입니다."
  - q: "그렇다면 이 전략에 overfit 이 존재하지 않는다는 뜻입니까?"
    a: "정확히 그렇지는 않습니다. BTC 304일 데이터에서 교정된 버전은 안정적입니다 (ratio 1.01). 그러나 8개 페어에 대한 크로스에셋 테스트는 대부분 노이즈를 보였습니다 (ratio_stdev > mean). 한 자산 (DOT) 은 좋아 보였지만 워크포워드 분해를 거치자 IS/OOS ratio 6.47 이 드러났습니다 — 「크로스에셋 성공」이라는 이야기 속에 실제 교과서적 overfit 이 숨어 있었던 것입니다. 전략은 손익분기 수준이며, 다만 원래 진단된 이유와는 다른 이유로 그렇습니다."
  - q: "프로덕션에서 schema drift 를 어떻게 방어합니까?"
    a: "세 가지 레이어가 있습니다: (1) 엄격한 디시리얼라이제이션을 사용합니다 (pydantic strict 모드, kw_only=True + frozen=True 의 dataclass, 또는 알 수 없는 키를 거부하는 명시적 Field validator). (2) 프레임워크 버전과 함께 파라미터 파일 schema 버전을 고정합니다. (3) 백테스트 직전에 유효 파라미터를 출력하고 핵심 값 (leverage, sl_atr_mult, weights) 을 단언합니다. 엄격한 디시리얼라이저만으로도 이런 사례의 90% 를 조용히 잡아냅니다."
  - q: "이 사건 이후의 새로운 「Seven Don'ts」리스트는 무엇입니까?"
    a: "7개에서 13개로 확장되었습니다. 새로 추가된 항목은: schema 검증 없는 실험을 신뢰하지 말 것, 200 거래일 미만 데이터셋에 대해 판단을 내리지 말 것, 30 트레이드 미만에서 PF > 3 을 받아들이지 말 것, 크로스에셋 검증 없이 전략을 출시하지 말 것, stdev/mean 비율을 무시하지 말 것 (1 초과 = 노이즈), 세그먼트별 분해 없이 PF 를 보고하지 말 것, IS/OOS ratio 없이 보고서를 받아들이지 말 것."
---

{{</* resource-info */>}}

# 스키마 버그가 가짜로 만든 Overfit 진단

> **메타 설명**: 7번의 퀀트 실험을 돌렸고, 「교과서적 overfit」은 알고 보니 schema 버그였습니다. 교정된 버전은 안정적입니다. 메타 교훈은 원본보다 더 추합니다.

원본 보고서는 깨끗했습니다. Train PF 2.08, OOS PF 0.94, ratio 2.21. 퀀트 문헌을 읽어본 사람이라면 누구나 이 시그니처를 알아봅니다 — 옵티마이저가 반복되지 않는 노이즈에 핏 되는 현상입니다. overfit 으로 분류하고 넘어갔습니다.

그 후 후속 실험이 진행되었습니다. 그리고 진단 자체가 틀렸다는 사실이 발견되었습니다.

이것은 사후 분석입니다. 버그는 전략에 있는 것이 아닙니다. 버그는 우리가 그 숫자를 어떻게 믿었는가에 있습니다.

## ⚡ TL;DR

> **원본 결론**: BTC 304일 데이터에서 교과서적 overfit (PF 2.08 → 0.94, ratio 2.21).
>
> **실제 발견**: schema 필드 불일치. `evolved_final_params.json` 은 `leverage` / `tp_atr_mult` 필드 이름을 사용했지만, 현재 schema 는 `base_leverage` / `tp_rr_ratio` 를 사용합니다. `from_dict()` 가 이를 조용히 버렸습니다. 실제 실행은 진화된 2x 가 아니라 기본값 10x leverage 로 이루어졌습니다.
>
> **교정된 결과**: PF 1.494 / 1.478, ratio 1.01. 지루할 정도로 안정적. overfit 이 아닙니다.
>
> **하지만 또한**: 크로스에셋 테스트는 여전히 잘해야 손익분기를 보여줍니다. DOT 워크포워드 IS/OOS ratio 6.47 — 「운 좋은 세그먼트」 이야기 속에 실제 교과서적 overfit 이 숨어 있었습니다.
>
> **메타 교훈**: 백테스트 출력을 신뢰하기 전에 파라미터 로딩을 검증하십시오. `print(vars(params))` 5초가 7개의 실험을 절약했을 것입니다.

## 원본 「발견」

moss-trade-bot-skills v1.0.26 paper 모드를 BTC/USDC 15분봉으로 돌렸습니다, 2025년 7월 → 2026년 4월. 304일, 29184 봉, 70/30 분할.

전략은 프레임워크의 파라미터 옵티마이저가 진화시킨 평균회귀 변형이었습니다. 진화된 구성은 합리적으로 보였습니다: 낮은 트렌드 가중치, 높은 평균회귀 가중치, 보수적인 2x leverage, 대칭적인 sl/tp.

백테스트 결과는 깨끗하게 나왔습니다:
- Train (212일): PF 2.08
- OOS (92일): PF 0.94
- Ratio: 2.21

Train/OOS ratio 가 2.0 을 넘는 것은 교과서적 overfit 시그니처입니다. 「진화가 2025년 3-4분기 특정 노이즈를 찾았고 일반화되지 않았다」로 분류했습니다. 그럴듯한 이야기이고, 데이터에 맞았으며, 세션은 거기서 끝났습니다.

## 이야기를 깨뜨린 후속 실험

다음 날 멀티에셋 검증을 시도했습니다 — 같은 진화 파라미터를 같은 윈도우의 ETH 에 적용. 예상 패턴: 파라미터가 시그널을 포착했다면 일반화되어야 합니다.

ETH 가 돌았습니다. PF 1.154 → 0.697, ratio 1.66. 가벼운 overfit, 대체로 우리 진단과 일치했습니다.

그 다음 ETH 의 데이터 범위와 일치하는 더 짧은 148일 윈도우에서 BTC 를 테스트했습니다. 같은 자산의 다른 서브 윈도우입니다.

결과: PF 0.980 → 1.581, ratio 0.62. **반대로 뒤집힌** 패턴. OOS 가 Train 보다 좋았습니다.

거기서 진단이 무너지기 시작했습니다.

같은 파라미터, 같은 자산, 다른 시간 윈도우가 반대 패턴을 만들어냈습니다. 전략이 노이즈이거나 (참), 윈도우들이 매우 다른 레짐을 가지고 있거나 (이것도 참), 아니면 — 결국 이것이 우리가 확인한 것입니다 — 파라미터가 우리가 생각한 것이 아니었던 것입니다.

## Schema Drift

Python 의 전형적인 `dataclass.from_dict()` 패턴에서, 알 수 없는 필드는 조용히 버려집니다. Pydantic 도 strict 모드를 설정하지 않는 한 마찬가지입니다.

진화된 구성 파일에는 다음이 포함되어 있었습니다:

```json
{
  "leverage": 2,
  "sl_atr_mult": 2.5,
  "tp_atr_mult": 2.5,
  ...
}
```

런타임 `DecisionParams` schema 는 다음을 기대했습니다:

```python
base_leverage: float = 10.0
max_leverage: float = 40.0
sl_atr_mult: float = ...
tp_rr_ratio: float = ...
```

`leverage` → 조용히 버려짐 → `base_leverage` 가 기본값 **10.0** 으로.
`tp_atr_mult` → 조용히 버려짐 → `tp_rr_ratio` 가 자체 기본값으로.

우리가 돌리고 있다고 생각한 「대칭적인 2.5/2.5 ATR 승수가 있는 진화된 2x leverage」는 실제로는 「기본값 10x leverage 와 기본값 tp_rr_ratio」였습니다.

`from_dict()` 이후 5초짜리 `print(vars(params))` 가 이를 보여줬을 것입니다. 우리는 하지 않았습니다.

## 교정된 숫자

같은 BTC 304일, 같은 70/30 분할, 같은 진화 파라미터 — 그러나 현재 schema 필드에 올바르게 매핑:

- Train PF: 1.494
- OOS PF: 1.478
- Ratio: **1.01**

이것은 overfit 이 아닙니다. 우리가 본 것 중 가장 안정적인 Train/OOS ratio 중 하나입니다.

전략은 망가지지 않았습니다. 진단이 망가졌습니다.

## 여전히 사실이었던 것

교정된 결과는 BTC 304일에서 안정적이지만, 크로스에셋 테스트는 덜 칭찬할 만한 이야기를 들려줍니다.

8개 암호화폐 페어, 같은 148일 윈도우, 같은 교정된 파라미터:

| 자산 | Train PF | OOS PF | Ratio |
|---|---|---|---|
| ETH | 1.154 | 0.697 | 1.66 |
| BNB | 1.512 | 0.213 | 7.10 |
| AVAX | 0.581 | 1.302 | 0.45 |
| LINK | 1.055 | 0.519 | 2.03 |
| ARB | 0.628 | 1.527 | 0.41 |
| DOT | 1.647 | 1.907 | 0.86 |
| NEAR | 0.358 | 1.415 | 0.25 |

Ratio stdev (2.42) 가 평균 (1.82) 을 초과합니다. 지표의 분산이 중심 경향보다 클 때, 당신이 보고 있는 것은 노이즈입니다.

DOT 가 두드러져 보였습니다 — Train 1.65, OOS 1.91, 양쪽 모두 강했습니다. 그러나 DOT 의 148일을 다섯 개의 약 30일 세그먼트로 분할하자 Segment 1 만 (2025년 10-11월) PF 7.82 와 전체 +1.67% 수익을 가지고 있었음이 드러났습니다. 나머지 네 세그먼트의 합계는 -0.68% 였습니다. 「크로스에셋 알파」는 운 좋은 한 달이었습니다.

워크포워드 테스트가 확인했습니다: Segment 1 을 IS, Segments 2-5 를 OOS 로. IS PF 7.82 → OOS PF 1.21. **IS/OOS ratio 6.47** — 표면 수치가 좋아 보이는 자산 속에 숨어 있던 실제 교과서적 overfit.

## 방어선

세 가지 레이어, 노력/가치 순:

**1. 엄격한 디시리얼라이제이션.** 파라미터 로더가 알 수 없는 필드를 거부하게 만드십시오. Python 에서:

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

원본 `from_dict()` 는 유효한 필드로 필터링했지만 알 수 없는 필드에 대해 *예외를 던지지 않았습니다*. `raise` 하나가 빠진 비용이 7번의 실험이었습니다.

**2. 백테스트 전에 유효 파라미터 출력.** 세 줄:

```python
params = DecisionParams.from_dict(raw)
print(f"Effective: leverage={params.base_leverage}, sl={params.sl_atr_mult}, tp={params.tp_rr_ratio}")
assert params.base_leverage == raw.get("base_leverage", raw.get("leverage")), "leverage mismatch"
```

**3. 파라미터 파일 schema 버전 고정.** 프레임워크의 schema 가 변경되면, 오래된 파라미터 파일은 조용히 저하되는 것이 아니라 시끄럽게 실패해야 합니다.

## 새로운 「Seven Don'ts」— 이제 13개

원본 7개의 백테스트 규율 규칙이 이 사건 이후 13개로 늘었습니다. 새로운 6개는 이 실험들에서 직접 나옵니다:

- **schema 검증 없는 실험을 신뢰하지 말 것.** 백테스트 전에 파라미터를 출력하십시오.
- **200 거래일 미만 데이터셋에 대해 판단을 내리지 말 것.** 같은 자산의 148일 서브 윈도우가 반대 진단을 내놓았습니다.
- **30 트레이드 미만에서 PF > 3 을 받아들이지 말 것.** 기본 적신호.
- **크로스에셋 검증 없이 전략을 출시하지 말 것.** 단일 자산의 안정성은 필요하지만 충분하지 않습니다.
- **stdev/mean 비율을 무시하지 말 것.** 1 초과는 평균이 아무리 좋아 보여도 노이즈를 의미합니다.
- **세그먼트별 분해 없이 PF 를 보고하지 말 것.** 단일 윈도우 요약은 운 좋은 세그먼트 아티팩트를 숨깁니다.

## 힘든 부분

원본 보고서는 후속 실험이 폭로하기 전까지 하루 동안 우리 아카이브에 있었습니다. 만약 「Train PF 2.08 → OOS 0.94, ratio 2.21」에서 멈췄다면 자신만만하게 틀린 진단을 공유했을 것입니다. 숫자는 진짜였습니다. 우리가 그것을 둘러싸고 들려준 이야기는 그렇지 않았습니다.

백테스트 결과는 만들기 쉽고, 요약하기 쉽고, 공유하기 쉽습니다. 숫자 뒤의 가정을 검증하는 것은 더 어렵고, 더 느리며, 보상이 적습니다. 그러나 그것이 「우리는 뭔가를 돌렸고 이게 일어난 일입니다」와 「우리는 무슨 일이 일어났는지 압니다」를 구분하는 유일한 단계입니다.

이 사후 분석에서 단 하나의 습관만 가져간다면: 모든 백테스트 전에 유효 파라미터를 출력하십시오. 5초. 7번의 실험을 절약합니다.

## 권장 인프라

워크포워드 + 멀티에셋 실험 스캐폴딩용:

- **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — $200 크레딧, 손쉬운 GPU/CPU droplet
- **{{< aff "htstack" "footer-cta" "HTStack" >}}** — 홍콩 VPS, 아시아 거래소 API 까지 저지연

*제휴 링크 — 가격은 동일하며, dibi8.com 을 후원합니다.*

---

**관련 글**: [Moss Trade Bot Factory 2026 리뷰](https://dibi8.com/kr/resources/ai-trading/moss-trade-bot-factory-2026-review/) · [백테스트 OVERFIT 5가지 패턴 2026](https://dibi8.com/kr/resources/ai-trading/backtest-overfit-5-patterns-2026/) · [Backtrader Python 백테스팅](https://dibi8.com/kr/resources/ai-trading/backtrader-python-backtesting/)
