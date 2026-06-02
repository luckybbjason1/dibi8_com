---
title: 'TradingAgents: 8.2만 스타의 LLM 멀티 에이전트 트레이딩 프레임워크 — 2026 실전 가이드'
description: 'TradingAgents는 오픈소스 LLM 멀티 에이전트 프레임워크입니다(82,254 GitHub stars, Apache-2.0). 트레이딩 회사를 시뮬레이션해 분석가·리서처·트레이더·리스크 에이전트가 BUY/SELL/HOLD 결정을 토론합니다. LangGraph 기반. 설치, 에이전트 파이프라인, CLI + Python API, Qlib·단일 에이전트 봇과의 솔직한 비교를 다룹니다.'
date: 2026-06-02
slug: 'tradingagents-llm-multi-agent-trading-framework-2026'
category: 'ai-trading'
tags: ['TradingAgents', 'LLM 에이전트', '알고리즘 트레이딩', 'LangGraph', '멀티 에이전트', 'AI 트레이딩', '퀀트', '금융 AI']
github_repo: 'https://github.com/TauricResearch/TradingAgents'
stars: 82254
maintainer: 'TauricResearch'
license: Apache-2.0
featureImage: 'https://raw.githubusercontent.com/TauricResearch/TradingAgents/main/assets/schema.png'
lang: ko
---

# TradingAgents: 8.2만 스타의 LLM 멀티 에이전트 트레이딩 프레임워크 — 2026 실전 가이드

## 들어가며

대부분의 "AI 트레이딩 봇" 프로젝트는 "살지 말지 결정하라"는 프롬프트를 붙인 단일 LLM입니다. 하지만 실제 결정에 펀더멘털 점검, 뉴스 스캔, 강세 대 약세 논쟁, 리스크 승인이 필요한 순간 그 단일 두뇌 구조는 무너집니다. 진짜 트레이딩 데스크는 하나의 두뇌로 움직이지 않습니다 — 서로 논쟁하는 팀으로 움직입니다.

TradingAgents는 이것을 문자 그대로 구현했습니다. **82,254 GitHub stars**, **Apache-2.0** 라이선스, **TauricResearch**가 유지보수하는 오픈소스 프레임워크로, 트레이딩 회사를 각자 역할이 있는 LLM 에이전트 팀으로 모델링합니다 — 리서치를 파이프라인을 따라 넘기고, 토론한 뒤에야 BUY/SELL/HOLD 결정을 내립니다. 이 가이드는 에이전트 파이프라인이 어떻게 연결되는지, 설치·실행(CLI와 Python), 그리고 Qlib·단일 에이전트 봇과의 솔직한 비교를 다룹니다.

![TradingAgents 에이전트 파이프라인 아키텍처, via dibi8.com](https://raw.githubusercontent.com/TauricResearch/TradingAgents/main/assets/schema.png)

*TradingAgents는 트레이딩 회사를 모델링합니다: 분석가 → 리서처(강세 vs 약세) → 트레이더 → 리스크 팀 → 포트폴리오 매니저 (출처: TauricResearch/TradingAgents, via dibi8 분석)*

## TradingAgents란?

TradingAgents는 실제 트레이딩 회사의 워크플로우를 시뮬레이션해, 주어진 종목과 날짜에 대해 리서치된 트레이딩 결정을 만들어내는 멀티 에이전트 LLM 프레임워크입니다. 하나의 모델이 추측하는 대신, 전문화된 에이전트들이 각자 한 가지 일을 하고, 발견을 앞으로 넘기고, 확정 전에 그 결정을 논쟁으로 가려냅니다.

이것은 **리서치 프레임워크**로, Tauric Research 커뮤니티가 LLM 에이전트가 금융 추론에 어떻게 협업하는지 연구하기 위해 만들었습니다 — 즉시 돈을 찍는 봇이 아니며, 명시적으로 **투자 조언이 아닙니다**. Python으로 작성되었고 **LangGraph** 위에 구축되어, LangGraph가 에이전트 그래프와 상태 전달을 오케스트레이션합니다.

## TradingAgents 작동 원리

이 프레임워크는 에이전트 팀들의 방향성 파이프라인입니다. 각 단계가 원시 데이터를 방어 가능한 결정으로 좁혀갑니다.

1. **분석가 팀** — 네 명의 전문가가 증거를 모읍니다: 펀더멘털 분석가(재무제표, 비율), 센티먼트 분석가(소셜/Reddit 신호), 뉴스 분석가(거시 + 기업 뉴스), 기술적 분석가(MACD, RSI 같은 가격 지표).
2. **리서치 팀** — 강세 리서처와 약세 리서처가 분석가의 발견을 여러 라운드에 걸쳐 토론하며, 양쪽의 가장 강한 논거를 끌어냅니다.
3. **트레이더** — 토론을 구체적인 트레이딩 플랜(방향 + 근거)으로 종합합니다.
4. **리스크 관리 팀** — 공격적·중립적·보수적 리스크 에이전트가 서로 다른 리스크 성향에서 플랜을 스트레스 테스트합니다.
5. **포트폴리오 매니저** — 승인 또는 거부하여 최종 **BUY / SELL / HOLD** 결정을 만듭니다.

![TradingAgents 분석가 팀, via dibi8.com](https://raw.githubusercontent.com/TauricResearch/TradingAgents/main/assets/analyst.png)

*분석가 팀이 펀더멘털·센티먼트·뉴스·기술적 지표를 모읍니다 (출처: TauricResearch/TradingAgents, via dibi8 분석)*

각 에이전트는 역할별 프롬프트와 데이터 도구 접근을 가진 LLM 호출입니다. LangGraph가 공유 상태를 관리해 뒤의 에이전트가 앞 에이전트의 출력을 볼 수 있게 합니다.

## 설치 & 설정

TradingAgents는 Python 3.10+에서 실행됩니다. 저장소를 클론하고 의존성을 설치합니다; API 키 두 개가 필요합니다 — LLM 제공자(기본 OpenAI)와 금융 데이터용 **FinnHub**.

TradingAgents를 예약된 프로덕션 작업으로 돌리려면 항상 켜져 있는 머신이 필요합니다 — [DigitalOcean](https://m.do.co/c/eca87ac14ee0)에서 하나 띄우거나(신규 계정 무료 크레딧), 아시아에서 저지연 접속이 필요하면 [HTStack](https://my.htstack.com/aff.php?aff=27187)의 홍콩 VPS(dibi8.com을 호스팅하는 것과 같은 IDC)를 쓰세요.

```bash
# 1. 클론
git clone https://github.com/TauricResearch/TradingAgents.git
cd TradingAgents

# 2. 격리 환경 (conda 또는 venv)
conda create -n tradingagents python=3.10 -y && conda activate tradingagents

# 3. 의존성 설치
pip install -r requirements.txt
```

conda 대신 순수 virtualenv가 좋다면? 둘 다 됩니다:

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
```

필수 API 키 두 개를 환경 변수로 설정합니다:

```bash
export OPENAI_API_KEY=sk-your-key-here
export FINNHUB_API_KEY=your-finnhub-key   # 무료 등급으로 테스트 가능
```

또는 매 셸마다 export하지 않도록 로컬 `.env`에 보관합니다:

```bash
# .env  (이 파일은 절대 커밋하지 마세요)
OPENAI_API_KEY=sk-your-key-here
FINNHUB_API_KEY=your-finnhub-key
```

`KeyError: 'FINNHUB_API_KEY'`가 보이면 현재 셸에 변수가 export되지 않은 것입니다. LLM 호출이 429를 반환하면 OpenAI 쪽에서 레이트 리밋이 걸린 것이니 — 속도를 늦추거나 설정에서 모델을 바꾸세요(아래).

## 핵심 사용법

가장 빠른 길은 대화형 CLI로, 종목과 날짜를 입력받아 각 에이전트의 추론을 스트리밍합니다:

```bash
python -m cli.main
```

자동화에는 `TradingAgentsGraph` API로 Python에서 구동합니다. 종목과 날짜를 넘기면 에이전트 상태와 최종 결정을 돌려받습니다:

```python
from tradingagents.graph.trading_graph import TradingAgentsGraph
from tradingagents.default_config import DEFAULT_CONFIG

ta = TradingAgentsGraph(debug=True, config=DEFAULT_CONFIG.copy())
# 특정 날짜 기준 NVDA 분석 (point-in-time, 미래 참조 없음)
_, decision = ta.propagate("NVDA", "2024-05-10")
print(decision)   # -> BUY / SELL / HOLD + 근거
```

비용과 깊이는 설정으로 제어합니다. TradingAgents는 작업을 "딥 싱킹" 모델(무거운 추론)과 "퀵 싱킹" 모델(저렴, 고빈도 호출)로 나눕니다:

```python
config = DEFAULT_CONFIG.copy()
config["llm_provider"] = "openai"
config["deep_think_llm"] = "gpt-4o"        # 토론 / 어려운 추론용
config["quick_think_llm"] = "gpt-4o-mini"  # 일상적 에이전트 단계용
config["max_debate_rounds"] = 2            # 라운드가 많을수록 깊지만 비쌈
config["online_tools"] = True              # 실시간 데이터 vs 캐시
ta = TradingAgentsGraph(debug=True, config=config)
```

학습 단계에서는 `max_debate_rounds`를 낮게 두세요 — 라운드가 하나 늘 때마다 에이전트 팀 전체의 LLM 호출이 배가됩니다.

어떤 분석가를 돌릴지도 선택할 수 있어, 펀더멘털과 뉴스만 필요할 때 비용을 줄입니다:

```python
config["selected_analysts"] = ["fundamentals", "news"]  # 센티먼트 + 기술적 건너뛰기
ta = TradingAgentsGraph(debug=True, config=config)
```

관심 종목 리스트를 스크리닝하려면 같은 날짜로 여러 종목을 루프 호출합니다:

```python
watchlist = ["NVDA", "AAPL", "TSLA"]
for ticker in watchlist:
    _, decision = ta.propagate(ticker, "2024-05-10")
    print(f"{ticker}: {decision.splitlines()[0]}")   # 첫 줄 = 결정
```

반환된 상태에는 전체 토론이 담겨 있어 *무엇*뿐 아니라 *왜*를 들여다볼 수 있습니다:

```python
final_state, decision = ta.propagate("NVDA", "2024-05-10")
print(final_state["investment_debate_state"]["bull_history"])   # 강세 논거
print(final_state["investment_debate_state"]["bear_history"])   # 약세 논거
print(final_state["final_trade_decision"])                       # 최종 근거
```

## 통합

결정 단계가 BUY/SELL/HOLD와 근거를 반환하는 Python 호출일 뿐이므로, TradingAgents는 파이프라인의 리서치 절반에 들어갑니다. 그것은 **직접 주문을 넣지 않습니다** — 출력을 당신의 실행 또는 로깅 레이어에 연결합니다:

```python
_, decision = ta.propagate("AAPL", "2024-06-01")
if "BUY" in decision:
    log_signal("AAPL", "BUY", source="tradingagents")
    # 여기서 브로커 / 모의투자 레이어로 전달
```

데이터 레이어도 플러그형입니다: 펀더멘털·뉴스는 FinnHub, 기술적 지표는 가격/지표 도구, 센티먼트는 소셜 소스.

매 장 시작마다 결정을 재생성하려면 cron으로 스크립트를 감쌉니다:

```bash
# 평일 08:00에 관심 종목 스크리닝 실행
0 8 * * 1-5 cd /opt/TradingAgents && /opt/.venv/bin/python screen_watchlist.py >> /var/log/ta.log 2>&1
```

OpenAI에 묶이지 않습니다 — 같은 설정으로 딥/퀵 모델을 다른 제공자로 향하게 하세요:

```python
config["llm_provider"] = "anthropic"
config["deep_think_llm"] = "claude-sonnet-4-6"
config["quick_think_llm"] = "claude-haiku-4-5"
```

## 벤치마크 & 실사용

TradingAgents는 리서치 테스트베드로 쓰입니다: 과거 날짜를 재생하고, 에이전트가 그 당시 가용한 데이터만으로 추론하게 한 뒤(point-in-time), 결정과 토론 기록을 연구합니다. 진짜 가치는 **설명 가능성**입니다 — 블랙박스 모델과 달리 모든 결정에 분석가의 증거와 강세/약세 논거가 따라붙으며, 이것이 이 프로젝트가 즉시 쓰는 수익 도구라기보다 금융에서의 LLM 추론 연구에 인기 있는 이유입니다.

![TradingAgents 리스크 관리 팀, via dibi8.com](https://raw.githubusercontent.com/TauricResearch/TradingAgents/main/assets/risk.png)

*리스크 팀이 포트폴리오 매니저가 승인하기 전 모든 트레이딩 플랜을 스트레스 테스트합니다 (출처: TauricResearch/TradingAgents, via dibi8 분석)*

완료된 실행은 결정과 추론 흐름을 반환합니다 — 대략 이렇게:

```text
FINAL TRANSACTION PROPOSAL: BUY
Rationale: 펀더멘털 분석가가 데이터센터 매출 가속을 지적;
강세 논거(마진 확대)가 2라운드에 걸쳐 약세 논거(밸류에이션)를 압도;
리스크 팀: 중립 입장, 포지션 보수적. 포트폴리오 매니저: 승인.
```

토론 기록이 보존되므로, 모델을 바꾸거나 토론 라운드를 더할 때 결정이 어떻게 변하는지 비교할 수 있습니다:

```python
for rounds in (1, 3):
    config["max_debate_rounds"] = rounds
    ta = TradingAgentsGraph(config=config)
    _, d = ta.propagate("NVDA", "2024-05-10")
    print(rounds, "rounds ->", d.splitlines()[0])
```

## 대안과의 비교

저희의 [관련 오픈소스 도구](dibi8-internal-link) 정리도 함께 보세요.

TradingAgents, Qlib, 단일 에이전트 봇은 서로 다른 문제를 풉니다. 실제로 어디가 다른지 정리합니다.

| 특징 | TradingAgents | Qlib | 단일 에이전트 LLM 봇 |
|---|---|---|---|
| 접근 | LLM 멀티 에이전트 토론 | ML 팩터 모델 | 단일 LLM + 프롬프트 |
| 핵심 단위 | 분석가/리서처/트레이더/리스크 에이전트 | LightGBM/LSTM 신호 | 단일 결정 호출 |
| 설명 가능성 | 높음 (전체 토론 기록) | 중간 (피처 중요도) | 낮음 |
| 데이터 | FinnHub + 뉴스 + 센티먼트 + 기술적 | point-in-time 가격/팩터 DB | 프롬프트한 만큼 |
| GitHub stars | 82,254 | 43,948 | 다양 |
| 기반 | LangGraph | 자체 Python | 다양 |
| 적합 용도 | 한 트레이드에 대한 LLM 추론 연구 | ML 횡단면 전략 | 빠른 데모 |

솔직한 요약: 종목 유니버스에 대한 **통계적** 신호를 원하면 Qlib이 그 목적으로 만들어졌습니다. **LLM 팀이 어떻게 추론**해 전체 감사 추적이 있는 결정에 이르는지 연구하고 싶다면 TradingAgents가 더 흥미롭습니다. 둘은 경쟁이 아니라 보완 관계입니다.

## 한계 / 솔직한 평가

TradingAgents는 다루는 범위가 넓지만, 모두에게 맞지는 않으며 그런 척하는 것은 시간 낭비입니다.

- **투자 조언이 아니며, 실시간 트레이더도 아닙니다.** 리서치된 의견을 출력할 뿐, 주문을 넣지 않고 어떤 보장도 하지 않습니다. 저장소에 명확히 적혀 있습니다.
- **LLM 비용이 쌓입니다.** 토론 라운드가 있는 완전한 멀티 에이전트 실행은 종목·날짜당 많은 LLM 호출입니다. OpenAI 청구서를 주시하세요.
- **결정 품질은 모델에 달려 있습니다.** 저렴한 퀵 싱킹 모델은 분석을 떨어뜨립니다; 좋은 결과는 유능한 딥 싱킹 모델을 전제로 합니다.
- **데이터 커버리지 한계.** FinnHub 무료 등급과 센티먼트 소스는 불완전하며, 빈틈이 조용히 분석을 약화시킵니다.
- **백테스트는 신중히.** 날짜 기준으로 미래 참조를 피하지만, 에이전트 결정을 수수료를 고려한 거래 가능 전략으로 만드는 것은 프레임워크가 아니라 당신의 몫입니다.

AI 기반 암호화폐 전략을 다룬다면 [Minara](https://minara.ai/r/OSXG4X)(AI + 암호화폐)가 다른 영역을 커버하고, 거래소 네이티브 실행은 [Binance](https://www.bsmkweb.cc/register?ref=DIBI8)에서 이뤄집니다.

## 자주 묻는 질문

**TradingAgents는 무료인가요?**
네. Apache-2.0 오픈소스입니다(GitHub 82,254 stars). 실제 비용은 LLM API 사용량(OpenAI)과 유료 데이터 등급(FinnHub)이지 프레임워크 자체가 아닙니다.

**TradingAgents가 실제 거래를 넣나요?**
아니요. 근거가 딸린 BUY/SELL/HOLD 결정을 만듭니다. 주문 실행·리스크 한도·브로커 연결은 그 출력 위에 직접 구축합니다.

**어떤 API 키가 필요한가요?**
두 개: LLM 제공자 키(기본 OPENAI_API_KEY)와 금융 데이터용 FINNHUB_API_KEY. FinnHub 무료 등급으로 테스트에 충분합니다.

**한 번 분석에 LLM 호출이 얼마나 드나요?**
`max_debate_rounds`와 선택한 모델에 따라 다릅니다. 종목·날짜마다 분석가 → 리서처 → 트레이더 → 리스크 파이프라인 전체가 돌므로, 학습 단계에서는 토론 라운드를 낮추고 저렴한 퀵 싱킹 모델을 쓰세요.

**ChatGPT에 "NVDA 사야 하나"라고 묻는 것과 뭐가 다른가요?**
TradingAgents는 구조화된 다관점 추론을 강제합니다 — 별도의 분석가, 명시적 강세/약세 토론, 리스크 리뷰 — 그리고 하나의 검증되지 않은 답이 아니라 전체 기록을 반환합니다.

## 결론

TradingAgents는 2026년, LLM 에이전트 팀이 어떻게 트레이딩 결정에 도달하는지 연구하기에 가장 흥미로운 오픈소스 프로젝트입니다 — 돈을 찍어서가 아니라, 매 단계 작업 과정을 보여주기 때문입니다. 감사 추적이 곧 제품입니다: 어느 분석가가 어떤 경고를 올렸는지, 강세와 약세가 어떻게 논쟁했는지, 리스크 팀이 왜 그렇게 포지션을 잡았는지 정확히 볼 수 있습니다. 클론하고, CLI로 한 종목을 돌리고, 그것이 내놓는 어떤 신호든 신뢰하기 전에 전체 토론 기록을 읽으세요.

- 오픈소스 AI 도구 소식과 퀀트 토론은 [dibi8 한국어 Telegram 그룹](https://t.me/DIBI8_Group/9)에서.
- 함께 읽기: [dibi8의 관련 가이드](dibi8-internal-link).
- [DigitalOcean](https://m.do.co/c/eca87ac14ee0)에서 리서치 머신을 띄우고 오늘 밤 첫 분석을 실행하세요.

---

**출처 & 더 읽을거리**:
- GitHub 저장소: https://github.com/TauricResearch/TradingAgents
- 공식 문서 / README: https://github.com/TauricResearch/TradingAgents#readme
- LangGraph(오케스트레이션): https://github.com/langchain-ai/langgraph

*위 링크 중 일부는 제휴 링크입니다. 가입 시 dibi8.com이 수수료를 받을 수 있으며, 귀하의 비용에는 영향이 없습니다.*

<!-- internal-link-candidates:
  관련 오픈소스 도구 -> ai-tools-directory
  dibi8의 관련 가이드 -> ai-coding-agent-landscape-2026-skills-mcp-opensource
-->
