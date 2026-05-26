---
title: 'Moss Trade Bot Factory 2026 리뷰: AI 에이전트 퀀트 워크벤치 — 왜 예쁜 백테스트는 거짓말을 하는가'
description: 'moss-trade-bot-skills v1.0.26 핸즈온 리뷰: Hyperliquid 퍼페추얼용 자연어 퀀트 agent 빌더. Decimal 정밀도 + 20단계 호가창 모델링 — 그러나 Sharpe 연간화 상수 버그와 진화 모드 활성화 시 교과서적 OVERFIT 트랩. 보안 감사, 버그 픽스, 5 전략 비교, 70/30 train/OOS 검증 결과 전 과정.'
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
tags: ['ai-agent', '퀀트', '백테스트', 'hyperliquid', '퍼페추얼', '오픈소스', '과적합', 'OOS 검증']
aliases:
- /kr/posts/moss-trade-bot-factory-2026-review/
faq:
  - q: "moss-trade-bot-factory는 설치해도 안전한가요?"
    a: "페이퍼 백테스트는 완전히 안전합니다. 코드 감사 결과: eval/exec 없음, HMAC 서명 API 호출이 secret을 절대 업로드하지 않음, MIT-0 라이선스, 지갑 개인키 접근 없음. 이 skill은 퀀트 전략 빌더이지 커스터디 서비스가 아닙니다. 라이브 트레이딩은 moss.site 플랫폼에 명시적으로 bind해야 하며, 자금은 항상 사용자 본인의 Hyperliquid 지갑에 남아 있습니다."
  - q: "Sharpe 연간화 버그가 뭔가요?"
    a: "backtest.py 828라인이 sqrt(8760) — 시간 단위 bar 연간화 상수 — 를 사용하지만 equity는 15분 bar로 step됩니다. 15m bar의 올바른 상수는 sqrt(35040) = sqrt(365 × 24 × 4)입니다. 결과: 모든 기본 Sharpe 값이 약 2배 낮게 편향됩니다. 간단한 수정: 로컬 코드의 8760을 35040으로 교체."
  - q: "진화 모드가 실제로 전략을 개선하나요?"
    a: "in-sample은 예, out-of-sample은 종종 아니오. 핸즈온 테스트: Train 기간(212일) Profit Factor 0.99 → 2.08(2배). OOS 기간(92일) PF 1.68 → 0.94 붕괴, 승률 14%p 하락, 수익 +7.22% → -2.43% 반전. 이는 교과서적 in-sample fitting — LLM 반사는 Train 노이즈를 외울 뿐 시장 구조를 학습하지 않습니다."
  - q: "왜 skill이 ai.moss.site를 디폴트로 사용하나요?"
    a: "Moss는 상업 AI 트레이딩 플랫폼이며, 오픈소스 skill은 그들의 배포 채널입니다. 플랫폼을 건드리지 않고 전체 백테스트 파이프라인을 오프라인으로 실행할 수 있습니다 — live_trade.py / package_upload.py / live_runner.py만 건너뛰면 됩니다. 플랫폼 통합은 leaderboard와 copy-trade 기능을 추가하지만 옵션입니다."
  - q: "진화된 파라미터를 라이브 트레이딩에 쓸 수 있나요?"
    a: "독립적인 OOS 검증 없이는 권장하지 않습니다. skill의 내장 진화 루프는 OOS split이 없습니다 — 테스트한 동일 데이터에서 segment를 반사하고 파라미터를 조정합니다. 자체 70/30 train/OOS split을 실행하고 진화된 파라미터가 out-of-sample에서 살아남는지 확인해야 합니다. 대부분의 진화 파라미터 세트는 이 테스트에 실패합니다."
  - q: "실측 데이터 기준 Hyperliquid 퍼페추얼에서 실제로 작동하는 전략은?"
    a: "v1.0.26 BTC 304일 데이터 한정: 평균 회귀가 주도하는 그리드 + 2-3x 레버리지가 유일하게 양의 수익(+4.36%)을 냈습니다. 추세 추종 + 5-10x 레버리지는 같은 기간에 -8% ~ -20% 손실. 이것은 regime-specific입니다 — BTC 2025-07 ~ 2026-04는 횡보장이었습니다. 같은 그리드 로직이 강한 추세장에서는 손실 가능성이 높습니다."
---

{{</* resource-info */>}}

# Moss Trade Bot Factory 2026 리뷰: AI 에이전트 퀀트 워크벤치 — 왜 예쁜 백테스트는 거짓말을 하는가

> **Meta Description**: Moss Trade Bot Factory는 MIT-0 라이선스의 자연어 퀀트 agent 빌더로, Hyperliquid 퍼페추얼 전용입니다. 산업급 Decimal 정밀도 백테스트 엔진 — 그러나 Sharpe 버그 한 개와 진화 모드 활성화 시 교과서적 OVERFIT 트랩. 이 리뷰는 감사, 설치, 버그 픽스, 그리고 진짜 중요한 검증인 out-of-sample 다룹니다.

YouTube에서 "AI 트레이딩 봇으로 $50k 벌었어요" 비디오를 본 적 있다면 트릭을 압니다: 예쁜 백테스트 곡선, 진화된 파라미터, Sharpe 3.5, 그리고 브로커 대시보드 스크린샷. 거의 절대 보여주지 않는 것: 같은 파라미터를 봇이 본 적 없는 데이터에서 돌린 결과.

**in-sample 환상과 out-of-sample 현실 사이의 간극 — 이게 이 리뷰의 핵심입니다.**

Moss Trade Bot Factory(`moss-trade-bot-skills` v1.0.26, MIT-0)는 자연어 트레이딩 스타일 설명("Livermore 추세 추종, 보수적 레버리지, 돌파 전략")을 30+ Hyperliquid 퍼페추얼 파라미터로 변환하고, 패키지된 CSV 데이터로 로컬 백테스트를 실행하며, 옵션으로 LLM 반사 기반 진화를 제공하는 오픈소스 AI 에이전트입니다. 이틀간 집중 테스트 결과 — 보안 감사, Sharpe-연간화 버그 수정, 5 전략 비교, 진화 모드, 엄격한 70/30 train/OOS 검증 — 팬이나 비판자 누구도 말해주지 않는 미묘한 판단을 내립니다.

## ⚡ 90초 결론

> **본질**: 자연어 전략 설명을 30+ Hyperliquid 퍼페추얼 파라미터로 변환하고, 패키지된 CSV에서 Decimal 정밀도 백테스트를 실행하며, LLM 반사 기반 진화 루프를 제공하는 오픈소스 CLI skill.
>
> **아닌 것**: 라이브 트레이딩 시스템 아님(명시적 `--platform-url` ai.moss.site bind 없이는). 전통적 의미의 페이퍼 트레이딩 샌드박스 아님 — 백테스트는 과거 데이터 replay이지 실시간 시장 시뮬레이션이 아님.
>
> **적합 대상**: 산업급 백테스트 엔진 내부(Decimal 산술, 20단계 호가창, 청산 회계)를 보고 싶은 퀀트 학습자. 규칙 기반 템플릿과 자연어 LLM 생성 파라미터를 비교하는 전략 설계자.
>
> **부적합 대상**: 독립 OOS 검증 없이 진화된 파라미터를 라이브에 배포하려는 누구든. 진화 루프는 화장품 같은 LLM 코멘트를 단 in-sample fitting 머신이지 학습 시스템이 아닙니다. 아래에 증명합니다.
>
> **오픈소스 자세**: MIT-0 라이선스, eval/exec 없음, HMAC 서명 플랫폼 호출이 secret을 절대 업로드 안함, 지갑 개인키 접근 없음. 펀넬은 moss.site(상업 AI 트레이딩 플랫폼)이지만 로컬 백테스트 파이프라인은 완전 오프라인.

---

## Moss Trade Bot Factory가 무엇인가 (무엇이 아닌가)

프로젝트 주소 [github.com/moss-site/moss-trade-bot-skills](https://github.com/moss-site/moss-trade-bot-skills), `moss-site` GitHub 조직(Moss AI, [moss.site](https://moss.site), 2025-07 설립) 소속. v1.0.26 기준(2026-05-25 릴리스) 98 stars, 14 forks, 101 commits, 3명 contributor(slowfirary 79, fei-moss 14, lokix006 1).

메커닉상 skill은 3단계로 작동:

1. **파싱**: 자연어 입력("BTC 보수적 그리드, 최근 90일")이 agent에 의해 구조화된 `params.json`으로 파싱됨. 30+ 전술/성격 파라미터 — 5개 시그널 가중치(추세/모멘텀/평균회귀/거래량/변동성), 레버리지, entry/exit 임계값, ATR 기반 stop/target 배수, regime-switching 파라미터.

2. **리플레이**: 백테스트 엔진이 패키지된 Hyperliquid CSV 데이터(15m bar, 43 심볼, 148–304일)를 읽고 다음으로 거래 replay:
   - Decimal 정밀도 회계(Moss 플랫폼 Go `shopspring/decimal` 백엔드 정렬)
   - 20단계 동결 호가창 템플릿(현실적 슬리피지 모델링)
   - 명시적 청산 회계 — 유지증거금 침범 감지
   - Cross-margin 시뮬레이션(단일 합약, 다자산 포트폴리오 마진 아님)
   - 시간당 funding 정산(고정 비율 `0.0000125`, 실제 역사적 funding 아님)

3. **반사 & 진화**(옵션): 백테스트 윈도우를 segment(기본 4000 bars ≈ 41.7일/segment)로 분할, 각 segment 베이스라인 실행, 그 후 LLM agent를 호출하여 segment 레벨 요약(exit reasons, 평균 손익, 시장 컨텍스트)을 읽고 segment별 파라미터 스케줄 생성, 베이스라인 대비 ±30% drift 제한. 성격 파라미터(시그널 가중치, 레버리지, long_bias) 잠금.

README의 pitch는 실제: vectorbt 같은 장난감보다 더 한 것입니다. Decimal 정밀도와 호가창 모델링이 우리가 리뷰한 대부분의 오픈소스 퀀트 도구를 앞섭니다. 백테스트 내부가 산업급 replay 코드가 어떤 것인지 진정으로 가르쳐줍니다.

**그렇게 잘 안 맞는** pitch는 진화 루프. 곧 다룹니다.

## 백테스트 엔진은 실제로 어떻게 작동하나

퀀트 도구를 평가하는 누구에게나 엔진 내부가 마케팅보다 더 중요. `scripts/core/backtest.py`에서 세 가지가 두드러집니다:

### 1. Look-Ahead Bias 방어(대부분 양호)

Replay 메인 루프는 전략에 bar `range(last_fed_idx + 1, end_idx)`를 공급 — 평가 bar 종가 전에 엄격히 멈춤. 실행용 mark price는 `open + (close-open)/15`로 합성, 다음 15m bar 첫 분의 가격 모의. 원리상 정확하지만 bar 내 가격 선형 변화 가정으로 고변동성 regime에서 왜곡. 버그 아님, 알려진 근사.

### 2. 청산 모델링(정확)

각 replay step에서 bar high(숏)과 bar low(롱)에 대해 유지증거금 침범 검사. 침범 시 청산가에 강제 청산. 결과의 `blowup_count`는 전략이 얼마나 자주 wipe됐는지 추적 — BTC 304일 × 5 전략 테스트에서 blowup count는 0, 레버리지 cap과 ATR 스톱이 실제 트리거됨을 확인.

### 3. Sharpe 연간화 상수 버그

`backtest.py:828` 원본:

```python
sharpe = (valid_returns.mean() / valid_returns.std(ddof=0) * np.sqrt(8760)) ...
```

여기서 `8760`은 시간 단위 bar 연간화 상수(`365 × 24`). 그러나 `equity`는 15분 간격으로 step됨(line 735 `equity_points.append` 참조). 15m bar의 올바른 상수는 `35040` = `365 × 24 × 4`. 원래 상수는 Moss 플랫폼 Go 백엔드 verify parity 매칭이지만, **어떤 로컬 백테스트 비교나 절대 Sharpe 해석에서도 모든 기본 Sharpe 값이 약 2배 낮게 편향됩니다**.

한 줄 수정:

```python
ANNUALIZATION_FACTOR = 35040  # 15m bars per year
sharpe = (valid_returns.mean() / valid_returns.std(ddof=0) * np.sqrt(ANNUALIZATION_FACTOR)) ...
```

moss.site에 백테스트 업로드해서 verify할 계획이면 `8760` 유지. 로컬에서 학습/비교한다면 `35040`.

## 설치: 끝까지 10분

이건 우리가 단 한 번의 env-var 싸움 없이 설치한 유일한 AI 에이전트 skill입니다. 표준 워크플로우:

```bash
git clone --depth 1 --branch v1.0.26 https://github.com/moss-site/moss-trade-bot-skills.git
cd moss-trade-bot-skills/moss-trade-bot-factory/scripts
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
```

의존성은 최소: `pandas≥2.0`, `numpy≥1.24`, `ccxt≥4.0`. `dataset_catalog.py` 처음 실행 시 GitHub Release Asset에서 ~100MB 역사적 CSV 데이터 일회성 다운로드(moss.site 아님 — 그들은 재현성을 위해 태그된 릴리스에 SHA256으로 데이터를 핀합니다). 이후 모든 것은 오프라인.

사용 가능 심볼 리스트:

```bash
python3 dataset_catalog.py --list --timeframe 15m
```

43개 Hyperliquid 심볼 커버: BTC(304일), ETH/SOL/ADA/AAVE 등(148일), 토큰화된 미국 주식(TSLA, NVDA, MSTR), 상품(GOLD, SILVER, BRENTOIL, SP500).

## 5 전략 비교: 실제로 작동하는 것

BTC 전체 304일 윈도우(2025-07-01 ~ 2026-04-30)에서 5개 수공예 전략 실행, $10,000 시작 자본. 같은 데이터, 같은 엔진, 다른 파라미터 철학.

| 전략 | 레버리지 | 최종 자본 | 수익 | 승률 | 최대 DD | PF | 거래 |
|---|---|---|---|---|---|---|---|
| 보수적 그리드(평균회귀) | 2x | $10,436 | **+4.36%** ✅ | 51.9% | -22.8% | 1.27 | 214 |
| 고빈도 돌파 | 10x | $9,207 | -7.93% | 42.0% | -17.4% | 1.04 | 100 |
| 변동성 적응 | 3x | $9,175 | -8.25% | 42.9% | -14.9% | 0.85 | 49 |
| 거래량 모멘텀 | 5x | $9,098 | -9.02% | 44.1% | -14.9% | 0.65 | 34 |
| **Livermore 추세** | **5x** | **$7,989** | **-20.11%** ❌ | 36.2% | -26.6% | 0.80 | 105 |

세 가지 멈춰서 생각할 발견:

**레버리지와 수익은 엄격히 반비례**. 2x 그리드 승. 10x 돌파는 5x 추세 추종보다 살짝 나을 뿐. 자연어 생성 전략을 횡보 시장에서 돌리면 3x 초과는 구조적 과잉자신.

**승률은 운명이 아님**. Livermore 추세 36.2% 승률은 추세 전략에 정상(추세 전략은 적은 수의 큰 승리로 많은 작은 손실을 덮을 것을 기대). 손실 이유는 승률 아님 — BTC 윈도우가 횡보/혼란 시장이라 추세가 계속 가짜 돌파. 옳은 전략, 잘못된 regime.

**5 전략 0 폭락**. 레버리지 cap과 ATR 스톱이 광고대로 작동. 10x 레버리지에서도 청산 안 됨. 리스크 관리 프리미티브 견고.

## 진화의 함정: 예쁜 백테스트, 빈 OOS

리뷰가 논쟁적이 되는 부분. README는 진화 루프를 "핵심 혁신"으로 판매 — 성격 잠금하면서 전술 파라미터 미세 조정하는 segment별 반사. 규율 있게 들림: ±30% drift 제한, 분리된 segment 품질 신호, walk-forward 반사.

또한 OOS에서 실패하는 예쁜 백테스트를 만들어냅니다.

### 우리의 방법론

1. BTC 304일을 Train(70% = 212일) + OOS(30% = 92일)로 split
2. Train에서 베이스라인(보수적 그리드 파라미터 고정), 5 × ~41일 segment 분할
3. 수동으로 반사 agent 역할: 실패 segment 식별(Seg 4: -6.11%, 42.3% 승률, 시장 -19.6% 하락 중 regime 잘못 라벨됨 SIDEWAYS), 전술 전용 미세 조정으로 5라운드 진화 스케줄 생성(entry_threshold 0.45 → 0.50, sl_atr_mult 3.0 → 2.5, tp_atr_mult 2.0 → 2.5)
4. 진화 스케줄 적용하여 Train에서 베이스라인 재실행
5. **진화된 최종 파라미터 잠금. OOS에서 실행. 아무것도 조정하지 않음.**

### 결과

| 지표 | Train Base | Train 진화 | OOS Base | OOS 진화 |
|---|---|---|---|---|
| 수익 | +3.02% | **+5.60%** ✅ | +7.22% | **-2.43%** ❌ |
| 연간화 | +5.20% | +9.64% | +28.63% | -9.64% |
| 승률 | 57.6% | 49.3% | 53.1% | 39.1% |
| 최대 DD | -16.34% | -9.25% ✅ | -6.64% | -4.77% |
| **Profit Factor** | 0.99 | **2.08** ✅ | 1.68 | **0.94** ❌ |
| 거래 | 116 | 69 | 49 | 23 |

Train 두 열을 먼저 읽으세요. Profit Factor 2배. 최대 Drawdown 반감. 어떤 in-sample 지표 기준이든 진화는 화려하게 성공. 실패한 Seg 4는 -6.11% → +3.20% 회복 — 정확히 타겟된 수정.

이제 OOS 두 열을 읽으세요. Profit Factor가 1.68에서 0.94로 붕괴. 승률 14%p 하락. 보지 못한 92일에서 +7.22% 베이스라인 수익이 "개선된" 파라미터로 -2.43% 손실로 변함.

이것이 in-sample fitting의 교과서적 시그니처. 진화 루프는 시장 구조를 학습하지 않음 — Train segment 노이즈를 외움. LLM 반사는 추론처럼 보였음("Seg 4는 하락장에서 평균 회귀 진입 때문에 실패; 스톱 조이고 임계값 올리기") — 그러나 증명은 OOS 차이에: **Train +2.58%p 개선이 OOS -9.65%p 퇴화로 번역됨**.

### 왜 이게 한 skill을 넘어서 중요한가

"AI 주도 파라미터 최적화" 또는 "반사적 진화"를 마케팅하면서 OOS 검증 결과를 보여주지 않는 모든 퀀트 도구는 같은 함정을 팝니다. 패턴은 보편적:

1. Train 기간 반사가 모든 실패 segment에 대해 이야기를 찾음
2. 전술 미세 조정이 이야기에 맞춤
3. in-sample 지표가 극적으로 개선(PF 2배, drawdown 반감)
4. OOS가 진실을 드러냄: 파라미터가 신호가 아닌 노이즈를 외움

Moss는 독점 죄인 아님. skill은 오픈소스, 데이터는 가용, 버그는 수정 가능. 다음 세대 이런 도구에 원하는 것은 내장 OOS gate: 독립 OOS 검증을 통과하지 않으면 진화된 파라미터 게시 거부. 그때까지 모든 진화 보고서를 in-sample 마케팅으로 취급하세요.

## 솔직한 가격과 펀넬 분석

skill 자체는 무료(MIT-0). 펀넬은 moss.site에서 가능한 것:

- 봇을 Moss 플랫폼에 bind하여 라이브 copy-trade(자신의 지갑 via Hyperliquid 실자금)
- 플랫폼 검증을 위해 백테스트 업로드
- leaderboard에서 경쟁
- 다른 agent 신호 구독

플랫폼 쪽은 테스트하지 않았습니다. README는 이것이 연구 및 교육 도구라고 명시, 그렇게 유지했습니다. 라이브 트레이딩하려면 자신의 Hyperliquid 지갑, 실제 USDC, Train-only 백테스트 지표를 무시할 인내심이 필요.

org는 명확한 펀넬 모드에서 운영(6 repos, star 있는 1개 외 지원 인프라: `moss-og-pass-nft` 멤버십, `moss-bounty-x402-client` 결제, `Hyperliquid-copy-trade` 실행). 악마 아님 — 표준 open-core 배포 — 그러나 skill이 모든 플랫폼 접촉 명령에 대해 `ai.moss.site`를 디폴트로 할 때 알 가치 있음.

## 이 skill이 올바른 도구일 때

사용하세요 만약:

- 산업급 백테스트 엔진이 어떤지 학습하고 싶을 때(Decimal 산술, 호가창, 청산 회계)
- 규칙 기반 전략 템플릿 비교 + 일관된 harness 원할 때
- 실제 Hyperliquid 역사 데이터에서 페이퍼 백테스트 실행, 데이터 파이프라인 직접 작성 원치 않을 때
- Sharpe 연간화 버그 수정할 수 있을 만큼 Python 읽고, 자체 OOS 검증 단계 추가할 때까지 진화 루프 무시 가능

건너뛰세요 만약:

- OOS 검증 엄격 학습 없이 라이브 트레이딩하고 싶을 때
- "진화된" 백테스트 결과가 forward 성과로 번역되길 기대할 때
- walk-forward 분석, regime-specific OOS 검증, 유의성 테스트 필요 — 어느 것도 내장 안 됨
- 플랫폼 펀넬 생각하고 싶지 않고 완전 커뮤니티 주도 도구 원할 때

## 만난 한계

이틀 집중 테스트 후:

- **Sharpe 연간화 버그**(위). 한 줄 수정 가능.
- **train/test split 내장 없음**. 자체 CSV slicer와 결과 비교기 작성 필요. 우리 것은 [95至尊交易员记忆 아카이브](https://github.com/luckybbjason1/home-hermes/tree/main/95%E8%87%B3%E5%B0%8A%E4%BA%A4%E6%98%93%E5%91%98%E8%AE%B0%E5%BF%86).
- **Regime 감지 라벨이 틀릴 수 있음**. Seg 4는 SIDEWAYS 라벨이었지만 BTC가 -19.6% 하락. `core/regime.py` 자체 감사 자격 있음.
- **Funding rate가 고정 상수**(`0.0000125`/시간). 실제 Hyperliquid funding은 변동. 장기간 포지션은 백테스트 vs 라이브 발산.
- **다자산 cross-margin 없음**. 단일 합약 cross-margin만. 포트폴리오 전략은 커스텀 작업 필요.

## 자체 호스팅 추천 인프라

자체 퀀트 백테스트 파이프라인을 24/7 안정적으로 운영하려면 안정된 VPS가 중요:

- **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — 신규 가입 시 60일 $200 크레딧. 백테스트 파이프라인 프로토타이핑하는 인디 퀀트의 좋은 진입점.
- **{{< aff "htstack" "footer-cta" "HTStack" >}}** — 홍콩 VPS, 중국 본토에서 저지연 접근. dibi8.com을 호스팅하는 동일 IDC.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영에 도움이 됩니다.*

## 최종 판단

Moss Trade Bot Factory는 2026년에 리뷰한 가장 진짜 유용한 오픈소스 퀀트 skill입니다. 백테스트 엔진은 산업급. HMAC 클라이언트는 정확히 설계. MIT-0 라이선스는 이례적으로 관대. Hyperliquid CSV 데이터셋은 실제이며 SHA256으로 핀.

하지만 진화 루프에 대한 마케팅 강조는 초보자를 in-sample fit 파라미터를 실자금에 배포하게 오도. 프로젝트가 OOS 검증 gate를 추가할 때까지(또는 누군가 fork 추가까지), 진화 기능을 *신뢰하지 말아야 할 것*을 가르치는 교육 도구로 취급하세요, alpha 경로로 아님.

설치하고, Sharpe 버그 수정하고, 5개 수공예 전략 실행해 엔진 동작 보고, 자체 train/OOS splitter 작성하세요. 그 마지막 단계 — 아무도 가르치지 않고 Moss가 강제하지 않는 — 가 퀀트의 단일 가장 중요한 습관.

봇은 자신의 edge에 대해 정직하라고 가르치지 않습니다. 그건 직접 해야 합니다.

---

**GitHub**: [moss-site/moss-trade-bot-skills](https://github.com/moss-site/moss-trade-bot-skills) · **License**: MIT-0 · **Latest**: v1.0.26(2026-05-25) · **Stars**: 98 · **Maintainer**: moss-site / Moss AI([moss.site](https://moss.site))
