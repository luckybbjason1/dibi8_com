---
title: "AI-Trader: 14K⭐ 완전 자동화 AI 트레이딩 에이전트, AI가 24시간 매매 대행"
description: "AI-Trader는 HKUDS가 개발한 오픈소스 완전 자동화 AI 트레이딩 에이전트 시스템으로, 14K+ Stars를 보유하고 있으며 주식, 암호화폐, 외환 다중 시장 자동 거래를 지원합니다."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Python
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "14.6 MB"
file_md5: ""
download_url: "https://github.com/HKUDS/AI-Trader"
backup_url: ""
github_repo: "https://github.com/HKUDS/AI-Trader"
stars: 18072
maintainer: "HKUDS"
last_maintained: "2026-05-13"
featureImage: ""
draft: false
aliases:
- /kr/posts/ai-trader/
faqs:
  - q: 'HKUDS가 개발한 AI-Trader란 무엇인가요?'
    a: 'AI-Trader는 홍콩대학교 데이터과학 연구실(HKUDS)이 개발한 오픈소스 완전 자동화 AI 트레이딩 에이전트 시스템입니다. 강화학습과 멀티 에이전트 협업 방식을 활용해 주식, 암호화폐, 외환, 선물 거래를 지원하며 MIT 라이선스로 배포됩니다.'
  - q: 'AI-Trader는 어떤 시장과 자산을 지원하나요?'
    a: 'AI-Trader는 네 가지 시장을 지원합니다: 주식(미국, 홍콩, A주), 암호화폐(BTC, ETH, 알트코인), 외환(주요 통화쌍), 선물(원자재 및 지수). 각 시장별로 모멘텀, 추세 추종, 캐리 트레이드, 스프레드 거래 등 맞춤형 전략 유형이 적용됩니다.'
  - q: 'AI-Trader는 어떤 강화학습 알고리즘을 사용하나요?'
    a: 'AI-Trader는 딥 강화학습을 사용하며, 학습 알고리즘으로 PPO(Proximal Policy Optimization)를, 시퀀스 모델링에는 LSTM 네트워크를 활용합니다. 에이전트는 배포 전 과거 시장 데이터로 사전 학습됩니다.'
  - q: 'AI-Trader의 멀티 에이전트 아키텍처는 어떻게 구성되나요?'
    a: 'AI-Trader는 거래를 전담 에이전트별로 분리합니다: 분석 에이전트(기술적, 펀더멘털, 센티먼트 분석), 매수/매도/보유를 결정하는 결정 에이전트, 포트폴리오 리스크를 모니터링하고 손절매를 실행하는 리스크 에이전트, 주문 처리 및 슬리피지 제어를 담당하는 실행 에이전트로 구성됩니다.'
  - q: '실제 자금 위험 없이 AI-Trader를 테스트할 수 있나요?'
    a: '네, 가능합니다. AI-Trader에는 과거 데이터를 활용한 고정밀 백테스팅 엔진과 페이퍼 트레이딩 모드(설정 파일에서 mode: paper로 지정)가 내장되어 있습니다. 프로젝트 문서에서는 실거래 배포 전에 반드시 페이퍼 트레이딩을 먼저 사용하도록 권장하고 있습니다.'
---
{</* resource-info */>}

## AI-Trader란?

**AI-Trader**는 **HKUDS(홍콩대학교 데이터과학 연구소)**에서 개발한 오픈소스 완전 자동화 AI 트레이딩 에이전트 시스템입니다. **14,311+ GitHub Stars**와 **2,418+ Forks**를 보유하고 있으며, 2026년 가장 발전된 AI 기반 퀀트 트레이딩 시스템 중 하나입니다.

고정된 규칙에 의존하는 기존 트레이딩 봇과 달리, AI-Trader는 **강화학습**과 **다중 에이전트 협업**을 사용하여 실시간으로 시장 상황에 적응합니다.

**GitHub:** [https://github.com/HKUDS/AI-Trader](https://github.com/HKUDS/AI-Trader)

| 지표 | 수치 |
|------|------|
| Stars | 14,311+ |
| Forks | 2,418+ |
| 언어 | Python |
| 라이선스 | MIT |
| 오늘 | 189 stars |

## AI-Trader가 다른 점

### 1. 100% 에이전트 네이티브 아키텍처

기존 트레이딩 봇은 "스크립트 네이티브"입니다 — 미리 프로그래밍된 규칙을 실행합니다. AI-Trader는 "에이전트 네이티브"입니다:

- **자율 의사결정** — AI가 매수, 매도, 보유 시점을 결정
- **시장 분석 에이전트** — 여러 전문 에이전트가 다양한 측면 분석 (기술적, 기본적, 감성)
- **리스크 관리 에이전트** — 전용 에이전트가 포트폴리오 리스크 모니터링 및 손절 실행
- **실행 에이전트** — 주문 처리, 슬리피지 제어, 거래소 상호작용

### 2. 다중 시장 지원

| 시장 | 자산 | 전략 유형 |
|------|------|-----------|
| 주식 | 미국, 홍콩, A주 | 모멘텀 + 평균 회귀 |
| 암호화폐 | BTC, ETH, 알트코인 | 추세 추종 + 차익거래 |
| 외환 | 주요 통화쌍 | 캐리 트레이드 + 기술적 |
| 선물 | 상품, 지수 | 스프레드 트레이딩 |

### 3. 강화학습 코어

AI-Trader는 전략 최적화를 위해 **심층 강화학습(DRL)**을 사용합니다:

```python
# 간소화된 훈련 루프
from ai_trader import TradingAgent, MarketEnv

env = MarketEnv(market='crypto', assets=['BTC', 'ETH'])
agent = TradingAgent(
    algorithm='PPO',  # Proximal Policy Optimization
    network='LSTM',   # Long Short-Term Memory
    risk_tolerance=0.02  # 최대 일일 손실 2%
)

# 역사적 데이터로 훈련
agent.train(env, episodes=10000, batch_size=64)

# 실전 트레이딩 배포 (먼저 모의 트레이딩!)
agent.deploy(mode='paper', exchange='binance')
```

### 4. 다중 에이전트 협업

시스템은 **계층적 다중 에이전트 아키텍처**를 사용합니다:

```
┌─────────────────────────────────────┐
│      포트폴리오 관리 에이전트        │
│    (자본 배분, 리밸런싱)           │
└──────────────┬──────────────────────┘
               │
    ┌──────────┼──────────┐
    │          │          │
┌───▼───┐ ┌───▼───┐ ┌───▼───┐
│시장   │ │리스크 │ │실행   │
│분석   │ │관리   │ │에이전트│
└────────┘ └───────┘ └────────┘
```

## 핵심 기능

### 실시간 시장 분석
- **기술적 지표** — 50+ 지표 (RSI, MACD, 볼린저 밴드, 일목균형표)
- **오더 플로우 분석** — Level 2 데이터 처리, 고래 감지
- **감성 분석** — Twitter, Reddit, 뉴스 감성 점수
- **온체인 분석** — 암호화폐: 지갑 추적, 거래소 유입

### 리스크 관리
- **포지션 사이징** — 켈리 기준, 변동성 기반 사이징
- **자동 손절** — 트레일링 스톱, 시간 기반 청산
- **드로다운 보호** — 드로다운 임계값 초과 시 자동 일시정지
- **상관관계 모니터링** — 상관관계 높은 자산 과집중 방지

### 백테스팅 엔진
- **역사적 시뮬레이션** — 10+년 데이터로 전략 테스트
- **워크포워드 분석** — 과적합 방지
- **거래 비용 모델링** — 슬리피지, 수수료, 시장 충격
- **몬테카를로 시뮬레이션** — 무작위 시나리오 스트레스 테스트

## 설치

```bash
# 저장소 클론
git clone https://github.com/HKUDS/AI-Trader.git
cd AI-Trader

# 의존성 설치
pip install -r requirements.txt

# API 키 구성 (테스트는 모의 트레이딩 권장)
cp config.example.yaml config.yaml
# config.yaml에 거래소 API 키 입력

# 먼저 백테스트 실행
python backtest.py --strategy momentum --market crypto --assets BTC,ETH

# 모의 트레이딩 시작
python trade.py --mode paper --config config.yaml
```

## 성능 벤치마크

백테스트 결과 기준 (2020-2025):

| 전략 | 연간 수익률 | 최대 드로다운 | 샤프 비율 |
|------|------------|--------------|-----------|
| 모멘텀 | 45.2% | 18.3% | 1.82 |
| 평균 회귀 | 32.1% | 12.7% | 1.65 |
| 다중 에이전트 | 58.7% | 15.2% | 2.14 |
| BTC 매수 보유 | 67.3% | 84.2% | 0.89 |

*면책 조항: 과거 성과가 미래 결과를 보장하지 않습니다. 항상 모의 트레이딩부터 시작하세요.*

## 커뮤니티 및 리소스

- **GitHub:** [HKUDS/AI-Trader](https://github.com/HKUDS/AI-Trader)
- **문서:** [https://ai-trader.readthedocs.io](https://ai-trader.readthedocs.io)
- **Discord:** [커뮤니티 가입](https://discord.gg/ai-trader)

## 관련 기사

- [Polymarket 트레이딩 봇: 자동화 예측 시장 거래](/kr/resources/dev-utils/polymarket-trading-bot-stack/)
- [Free Claude Code: 무료 AI 코딩 도우미](/kr/resources/ai-tools/free-claude-code-open-source-proxy/)
- [Agent Reach: AI 에이전트 인터넷 접근](/kr/resources/llm-frameworks/agent-reach-ai-agent-internet-access/)

## 면책 조항

**트레이딩은 상당한 손실 위험이 있습니다.** AI-Trader는 교육 및 연구 목적으로만 제공됩니다. 반드시:
1. 모의 트레이딩부터 시작
2. 감당할 수 있는 금액만 투자
3. 배포 전 전략 원리 이해
4. 성과 정기 모니터링
5. 소프트웨어 최신 상태 유지

---


---

## 추천 도구

오픈소스 AI 도구 개발/배포 시 권장:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전, AI 워크로드용 원클릭 droplet.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

*마지막 업데이트: 2026-05-08 | Stars: 14,311+ | 라이선스: MIT*

## 추천 도구

**AI 에이전트로 트레이딩? 포트폴리오 관리는 여전히 별도 도구가 필요.**

- **{{< aff "minara" "llm-footer" "Minara AI" >}}** — AI 기반 암호화폐 지갑, DCA·리밸런싱·온체인 알림 자동화. 커스텀 AI 트레이더와 페어링하면 액티브 전략 세션 사이 핸즈오프 포트폴리오 관리.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영에 도움이 됩니다.*

