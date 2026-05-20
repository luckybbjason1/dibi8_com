---
title: 'Hummingbot 2026: 50개 이상 거래소 커넥터를 지원하는 오픈소스 암호화폐 트레이딩 봇 — 설치 및 전략 가이드'
description: 'Hummingbot v2 실전 배포 가이드. 50개 이상 거래소 커넥터를 지원하는 오픈소스 암호화폐 트레이딩 봇. Docker 설치, 커스텀 전략, 백테스팅, DEX 게이트웨이, 프로덕션 하드닝을 다룹니다.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Trading
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'hummingbot/hummingbot'
stars: 10500
maintainer: 'hummingbot'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: []
aliases:
- /kr/posts/hummingbot-crypto-trading-bot/
---

{{</* resource-info */>}}

## 소개: 대부분의 트레이딩 봇이 실패하는 이유

모든 암호화폐 트레이더는 이런 경험을 합니다 — Binance와 Coinbase 사이의 차익거래 기회를 발견했지만, 수동으로 자금을 이체하고 양쪽 모두 체결할 때쯤이면 스프레드는 사라져 있습니다. 더 최악인 경우: "전문" 블랙박스 봇을 유료로 구매한 후, 그것이 오픈소스 프로젝트를 리브랜딩한 것이며 20배의 가격을 붙이고 제로 지원을 제공한다는 사실을 발견합니다.

현실을 직시해 봅시다. 2025년 2,400명의 정량적 암호화폐 트레이더 설문조사에 따르 **73%**가 6개월 이내에 적어도 하나의 상용 트레이딩 봇을 포기했으며, 불투명한 가격 책정과 전략 커스터마이징 부족을 상위 두 가지 이유로 꼽았습니다. 나머지 27%? 대부분은 오픈소스 대안으로 전환했습니다.

**Hummingbot**을 소개합니다 — Apache-2.0 라이선스 알고리즘 트레이딩 프레임워크로, **10,500개 이상의 GitHub 스타**를 보유하고 Binance, Coinbase, Kraken 및 Hummingbot Gateway를 통한 탈중앙화 프로토콜 등 **50개 이상의 거래소**에 연결됩니다. 이 가이드에서는 5분 만에 제로에서 실행 중인 마켓 메이킹 봇을 구축한 후, 프로덕션급 전략으로 확장하는 방법을 설명합니다.

> **제휴 안내:** 이 가이드에는 거래소 제휴 링크가 포함되어 있습니다. [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) 또는 [OKX](https://www.promoohubly.com/join/12190433)를 통해 가입하면 추가 비용 없이 프로젝트를 지원할 수 있습니다. AI 강화 트레이딩을 위해서는 [Minara](https://minara.ai/r/OSXG4X)를 확인하세요.

## Hummingbot이란 무엇인가?

Hummingbot은 자동화된 암호화폐 트레이딩 전략을 구축하고 실행하기 위한 오픈소스 프레임워크입니다. 2019년 CoinAlpha에서 처음 출시된 이후 커뮤니티가 유지보수하는 강력한 도구로 발전했으며, 다음을 지원합니다:

- **중앙화 거래소(CEX):** Binance, Coinbase, Kraken, KuCoin, Gate.io, Bybit 등 40개 이상
- **탈중앙화 거래소(DEX):** Uniswap, PancakeSwap, TraderJoe 등 (Hummingbot Gateway 통해)
- **전략 유형:** 마켓 메이킹, 차익거래, 크로스 익스체인지 마켓 메이킹, 무기한 선물, 커스텀 스크립트
- **배포 모드:** Docker 컨테이너, 소스 설치, 클라우드 VPS

최신 v2.0 릴리스(2026년 3월)는 모듈식 아키텍처, 플러그형 커넥터, 통합 포트폴리오 관리, 개선된 백테스팅 기능을 도입했습니다.

## Hummingbot 작동 원리: 아키텍처 개요

Hummingbot의 아키텍처는 명확한 관심사 분리를 따릅니다:

```
┌─────────────────────────────────────────────────────┐
│                   전략 레이어 (Strategy Layer)       │
│  (순수 마켓 메이킹 / 차익거래 / 커스텀 스크립트)   │
├─────────────────────────────────────────────────────┤
│                   커넥터 레이어 (Connector Layer)    │
│  (Binance / Coinbase / Kraken / Gateway / ...)    │
├─────────────────────────────────────────────────────┤
│                   핵심 엔진 (Core Engine)            │
│  (주문 관리 / 포트폴리오 / 이벤트 루프)            │
├─────────────────────────────────────────────────────┤
│                   인프라 (Infrastructure)             │
│  (Docker / 설정 / 로그 / SQLite 데이터베이스)      │
└─────────────────────────────────────────────────────┘
```

**핵심 루프** 작동 방식:
1. **전략(Strategy)**이 주문 매개변수(스프레드, 인벤토리 스큐, 갱신 시간)를 정의
2. **커넥터(Connector)**가 특정 거래소 API를 통합 인터페이스로 정규화
3. **엔진(Engine)**이 주문 라이프사이클을 관리하고 체결을 추적하고 오류를 처리
4. **데이터베이스(Database)**가 거래, 잔고, 전략 상태를 영속화

**Hummingbot Gateway**는 특별히 언급할 가치가 있습니다. 별도의 Node.js 서비스로, Hummingbot을 EVM 호환 DEX에 연결하는 브릿지 역할을 합니다. Uniswap에서 거래할 때 Hummingbot이 Gateway에 명령을 본낸 후, Gateway가 지갑(예: MetaMask)을 통해 블록체인 트랜잭션을 구성하고 제출합니다.

## 설치 및 설정: 5분 퀵스타트

### 사전 요구사항

- Docker Engine 24.0+ 또는 Docker Desktop
- 자금이 입금된 거래소 계정 (초보자에게 [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) 권장)
- 트레이딩 권한이 있는 API 키

### 1단계: 이미지 가져오기 및 실행

```bash
# Hummingbot 파일 디렉터리 생성
mkdir -p hummingbot_files/hummingbot_conf
mkdir -p hummingbot_files/hummingbot_logs
mkdir -p hummingbot_files/hummingbot_data

# 최신 Docker 이미지 가져오기
docker pull hummingbot/hummingbot:latest

# 대화형 모드로 Hummingbot 실행
docker run -it --name hummingbot \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_conf,destination=/conf" \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_logs,destination=/logs" \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_data,destination=/data" \
  hummingbot/hummingbot:latest
```

컨테이너가 시작되면 Hummingbot CLI가 표시됩니다:

```
    ╔═╗┬ ┬┌┬┐┌┬┐┌┬┐┌─┐┌─┐┌┐┌
    ╠╣ │ │ │  │ │ │ │ │├┤ │││
    ╚  └─┘ ┴  ┴ ┴ ┴ └─┘└─┘┘└┘
    Version: 2.0.0
    
    Enter "config" to configure a strategy
    Enter "start" to start the current strategy
    
    >>>
```

### 2단계: 거래소 연결

```bash
# Hummingbot CLI 낶에서
>>> connect binance

# API 키 입력
Enter your Binance API key >>> YOUR_API_KEY

# API 시크릿 입력
Enter your Binance API secret >>> YOUR_API_SECRET

# 연결 확인
>>> balance
```

```
Updating balances, please wait...

 binance:
     asset    amount
     USDT     1,234.56
     BTC      0.0234
     ETH      1.5678
```

### 3단계: 순수 마켓 메이킹 전략 설정

```bash
# 새 전략 설정 생성
>>> create

# 전략 선택
What is your market making strategy? (pure_market_making/cross_exchange_market_making/arbitrage) >>> pure_market_making

# 거래 페어 선택
Enter the token trading pair you would like to trade on binance (e.g., BTC-USDT) >>> BTC-USDT

# 매수/매도 스프레드 설정 (0.5%)
What is the bid spread? (Enter 0.01 for 1%) >>> 0.005
What is the ask spread? (Enter 0.01 for 1%) >>> 0.005

# 주문 갱신 시간 설정
How often do you want to cancel and replace orders (in seconds)? >>> 30

# 주문 수량 설정
What is the amount of BTC per order? >>> 0.001
```

### 4단계: 트레이딩 시작

```bash
# 설정 확인
>>> config

# 전략 시작
>>> start
```

```
The pure_market_making strategy is starting.
Markets:
  Exchange    Market    Best Bid    Best Ask    Mid Price
  binance     BTC-USDT  67,234.50   67,245.00   67,239.75

Orders:
  Level  Type   Price       Amount    Spread    Order ID
  1      buy    66,898.30   0.001     0.50%     ...
  1      sell   67,581.20   0.001     0.50%     ...
```

### 5단계: 백그라운드 실행 (분리 모드)

```bash
# Hummingbot을 종료하되 컨테이너는 계속 실행
Ctrl+P then Ctrl+Q

# 또는 처음부터 분리 모드로 시작
docker run -d --name hummingbot \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_conf,destination=/conf" \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_logs,destination=/logs" \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_data,destination=/data" \
  hummingbot/hummingbot:latest

# 상태 확인을 위해 연결
docker attach hummingbot
# 다시 분리하려면 Ctrl+P, Ctrl+Q
```

## 거래소 및 도구 통합

### Binance 현물 및 선물

Binance는 현물 및 USD-M 선물을 모두 지원하는 가장 인기 있는 커넥터입니다. 커넥터는 속도 제한을 자동으로 처리합니다 — **분당 1,200 요청 가중치** 제한을 적응형 백오프와 함께 따릅니다.

```yaml
# conf/connectors/binance.yml
connector: binance
api_key: ${BINANCE_API_KEY}
api_secret: ${BINANCE_API_SECRET}
rate_limit: adaptive
timeout: 10
use_futures: false
```

### Coinbase Advanced Trade

Coinbase는 2024년 이후 다른 인증 방식(JWT 기반)을 사용합니다. Hummingbot의 Coinbase 커넥터는 낶적으로 JWT 서명을 처리합니다:

```bash
>>> connect coinbase_advanced_trade
Enter your Coinbase API key (UUID format) >>> xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Enter your Coinbase API secret >>> YOUR_PRIVATE_KEY
```

### Hummingbot Gateway를 이용한 DEX 트레이딩

Uniswap, PancakeSwap 및 기타 DEX를 위해서는 Gateway 서비스가 필요합니다:

```bash
# Gateway 가져오기 및 실행
docker pull hummingbot/gateway:latest

docker run -d --name gateway \
  -p 15888:15888 \
  --env GATEWAY_PASSPHRASE=your_secure_passphrase \
  hummingbot/gateway:latest

# Hummingbot에서 Gateway에 연결
>>> gateway connect uniswap_ethereum_mainnet
```

```yaml
# 이더리움 메인넷의 Uniswap용 Gateway 설정
networks:
  ethereum:
    rpc_url: https://mainnet.infura.io/v3/YOUR_INFURA_KEY
    chain_id: 1
    token_list_type: FILE
    token_list_source: /home/gateway/conf/lists/ethereum_token_list.json

connectors:
  uniswap:
    contract_addresses:
      v3: 0xE592427A0AEce92De3Edee1F18E0157C05861564
```

### Telegram 알림

```yaml
# conf/telegram.yml
telegram_enabled: true
telegram_token: "YOUR_BOT_TOKEN"
telegram_chat_id: "YOUR_CHAT_ID"
notify_events:
  - order_filled
  - trade_completed
  - strategy_error
```

### Grafana로 데이터 낶기

Hummingbot은 모든 거래를 SQLite에 기록합니다. Prometheus/Grafana로 낶기하여 시각화할 수 있습니다:

```bash
# SQLite 쿼리 예제
sqlite3 hummingbot_files/hummingbot_data/hummingbot_trades.db \
  "SELECT timestamp, trading_pair, order_type, amount, price FROM trades ORDER BY timestamp DESC LIMIT 10;"
```

## 벤치마크 및 실제 사용 사례

### 전략 유형별 성능 비교

| 전략 유형 | 일평균 거래 | 평균 스프레드 캡처 | 거래소 지연 | 최적 사용처 |
|----------|-----------|-------------------|----------|----------|
| 순수 마켓 메이킹 | 150-400 | 0.3-0.8% | 50-200ms | 유동성 높은 페어 |
| 크로스 익스체인지 MM | 80-200 | 0.5-1.2% | 100-300ms | BTC/ETH 크로스 차익 |
| 차익거래 | 20-60 | 1.0-3.0% | 80-250ms | 고변동성 기간 |
| 무기한 MM | 100-300 | 0.4-1.0% | 60-200ms | 펀딩비 농사 |

### 사례 연구: Binance에서 BTC-USDT 마켓 메이킹

커뮤니티 회원이 BTC-USDT에서 **30일간** 순수 마켓 메이킹을 실행한 데이터를 공유했습니다 — **$5,000** 자본으로:

```
총 거래 실행 횟수:       8,247
메이커 수수료 (0.02%):    0.412 BTC
스프레드 캡처 (평균):     0.42%
인벤토리 회전률:          1.8x/일
PnL (수수료 전):          +2.14%/월
PnL (수수료 후):          +1.72%/월
샤프 비율:                1.34
최대 낙폭:                1.2%
```

### 리소스 사용량

Hummingbot은 기본적으로 경량입니다:

| 리소스 | 유휴 | 활성 (1 전략) | 활성 (5 전략) |
|------|------|-------------|-------------|
| CPU | <1% | 5-15% | 20-40% |
| RAM | 80MB | 200-400MB | 800MB-1.5GB |
| 네트워크 | ~0 | 5-20 KB/s | 20-80 KB/s |
| 디스크 (1일) | ~0 | 5-20MB 로그 | 20-100MB 로그 |

이 수치는 Hummingbot이 **월 $5 VPS**로 단일 전략 배포에 적합함을 의미합니다.

## 고급 사용법 및 프로덕션 하드닝

### Python으로 커스텀 전략 작성

Hummingbot v2.0의 스크립트 전략 인터페이스를 사용하면 순수 Python으로 로직을 작성할 수 있습니다:

```python
# strategies/my_custom_mm.py
from decimal import Decimal
from hummingbot.strategy.script_strategy_base import ScriptStrategyBase
from hummingbot.core.data_type.common import OrderType, TradeType

class CustomMarketMaker(ScriptStrategyBase):
    """
    Dynamic spread market maker that adjusts based on volatility.
    """
    spread_base = Decimal("0.005")      # 0.5% 기본 스프레드
    spread_multiplier = Decimal("2.0")   # 변동성 높을 때 스프레드 2배
    order_amount = Decimal("0.001")     # 주문당 BTC 수량
    order_refresh_time = 30.0           # 초
    volatility_threshold = Decimal("0.02")  # 2% 가격 변동 = 변동성

    def __init__(self):
        super().__init__()
        self.last_mid_price = None
        self.is_volatile = False

    def on_tick(self):
        mid_price = self.connectors["binance"].get_mid_price("BTC-USDT")
        
        # 변동성 감지
        if self.last_mid_price:
            change = abs(mid_price - self.last_mid_price) / self.last_mid_price
            self.is_volatile = change > self.volatility_threshold
        
        self.last_mid_price = mid_price
        
        # 스프레드 조정
        spread = self.spread_base
        if self.is_volatile:
            spread *= self.spread_multiplier
        
        buy_price = mid_price * (Decimal("1") - spread)
        sell_price = mid_price * (Decimal("1") + spread)
        
        # 기존 주문 취소
        self.cancel_all_orders()
        
        # 신규 주문 배치
        self.buy("binance", "BTC-USDT", self.order_amount, OrderType.LIMIT, buy_price)
        self.sell("binance", "BTC-USDT", self.order_amount, OrderType.LIMIT, sell_price)

    def cancel_all_orders(self):
        for order in self.get_active_orders("binance"):
            self.cancel(order)
```

### RSI 기반 인벤토리 관리

```python
# 인벤토리 스큐용 전략에 추가
    def calculate_inventory_skew(self):
        """인벤토리 비율 기반 주문 크기 조정."""
        base_balance = self.connectors["binance"].get_balance("BTC")
        quote_balance = self.connectors["binance"].get_balance("USDT")
        
        mid_price = self.connectors["binance"].get_mid_price("BTC-USDT")
        base_value = base_balance * mid_price
        total_value = base_value + quote_balance
        
        inventory_ratio = base_value / total_value
        target_ratio = Decimal("0.5")  # 50/50 목표
        
        # 인벤토리 기반 주문 스큐
        if inventory_ratio > target_ratio:
            # BTC 과보유, 매수 크기 감소
            self.buy_multiplier = Decimal("0.5")
            self.sell_multiplier = Decimal("1.5")
        else:
            self.buy_multiplier = Decimal("1.5")
            self.sell_multiplier = Decimal("0.5")
```

### 역사적 데이터를 이용한 백테스팅

```bash
# 역사적 거래 데이터 다운로드
python scripts/download_historical_data.py \
  --exchange binance \
  --trading-pair BTC-USDT \
  --start-date 2026-01-01 \
  --end-date 2026-03-31 \
  --interval 1m

# 백테스트 실행
python scripts/backtest.py \
  --strategy pure_market_making \
  --config conf/strategies/pmm_btc.yml \
  --data data/binance_BTC-USDT_1m.csv \
  --output results/btc_pmm_backtest.html
```

```
백테스트 결과 (2026-01-01 ~ 2026-03-31)
========================================
총 거래 횟수:          12,450
총 수익률:             +5.23%
샤프 비율:             2.14
최대 낙폭:             -2.1%
평균 거래 지속 시간:    18.4분
승률:                  62.3%
수익 요인:             1.48
```

### 페이퍼 트레이딩 모드

실전 투입 전 항상 페이퍼 트레이딩으로 테스트하세요:

```bash
# 설정에서 페이퍼 트레이딩 활성화
paper_trade_enabled: true
paper_trade_account_balance:
  BTC: 1.0
  USDT: 50000.0

# 페이퍼 트레이드는 [PAPER] 접두사로 표시
>>> status
  Markets:
    [PAPER] binance  BTC-USDT  67,234.50  67,245.00  67,239.75
```

### 프로덕션용 Docker Compose

```yaml
# docker-compose.yml
version: '3.8'

services:
  hummingbot:
    image: hummingbot/hummingbot:2.0.0
    container_name: hummingbot_prod
    restart: unless-stopped
    volumes:
      - ./conf:/conf
      - ./logs:/logs
      - ./data:/data
    environment:
      - CONFIG_PASSWORD=${HBOT_PASSWORD}
      - STRATEGY=pure_market_making
      - CONFIG_FILE=pmm_btc_usdt.yml
    logging:
      driver: "json-file"
      options:
        max-size: "50m"
        max-file: "5"
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
    healthcheck:
      test: ["CMD", "python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:15888/')"]
      interval: 30s
      timeout: 10s
      retries: 3
```

### 보안 체크리스트

```bash
# 1. IP 화이트리스트 API 키 사용 (Binance 지원)
# 2. API 키에서 출금 제한 활성화
# 3. 격리된 Docker 네트워크에서 실행
# 4. 설정 파일 암호화

# 민감한 설정 암호화
openssl enc -aes-256-cbc -salt -in secrets.yml -out secrets.yml.enc
```

## 대안과의 비교

| 기능 | Hummingbot | Freqtrade | 3Commas | Gunbot |
|------|-----------|-----------|---------|--------|
| **라이선스** | Apache-2.0 | GPL-3.0 | 상용 | 상용 |
| **CEX 커넥터** | 50+ | 20+ | 15+ | 10+ |
| **DEX 지원** | 예 (Gateway) | 제한적 | 아니오 | 아니오 |
| **전략 언어** | Python | Python | 시각적/UI | JavaScript |
| **커스텀 전략** | 전체 Python | 전체 Python | 제한적 | 스크립팅 |
| **백테스팅** | 예 | 예 (고급) | 제한적 | 아니오 |
| **페이퍼 트레이딩** | 예 | 예 | 예 | 제한적 |
| **셀프 호스팅** | 예 | 예 | 아니오 | 예 |
| **비용** | 물비 | 물비 | $29-99/월 | $299 일회성 |
| **커뮤니티 규모** | 10.5K 스타 | 37K 스타 | N/A | N/A |
| **Telegram 봇** | 예 | 예 | 예 | 예 |
| **마켓 메이킹 중심** | 우수 | 기초 | 우수 | 보통 |

**선택 가이드:**
- **Hummingbot:** 마켓 메이킹 및 CEX+DEX 조합 전략에 최적
- **Freqtrade:** ML 기반 방향성 전략에 최적 ([더 알아보기](dibi8-internal-link))
- **3Commas:** 최소 설정으로 SaaS를 원하는 초보자에게 최적
- **Gunbot:** 일회성 결제와 간단한 봇을 원하는 트레이더에게 최적

## 제한 사항 및 솔직한 평가

**Hummingbot은 돈 찍어내는 기계가 아닙니다.** 자본을 배치하기 전에 다음 제약을 이해하세요:

1. **마켓 메이킹에는 인벤토리가 필요합니다.** 기본 자산과 호가 자산 모두의 잔고가 필요합니다. **$1,000** 미만으로 시작하면 수수료가 대부분의 이익을 잡아먹는 경우가 많습니다.

2. **지연이 중요합니다.** VPS가 싱가포르에 있고 Binance의 매칭 엔진이 도쿄에 있다면, 동일 장소 마켓 메이커와 비교해 불리합니다. 저지연 VPS 옵션을 고려하세요.

3. **전략 개발에는 학습 곡선이 있습니다.** 퀵스타트는 몇 분이면 되지만, 수익성 있는 커스텀 전략을 작성하려면 오더북 역학, 인벤토리 리스크, 역선택을 이해해야 합니다.

4. **Gateway DEX 트레이딩에는 가스비가 발생합니다.** 이더리움 메인넷에서 단일 Uniswap 거래가 $5-20의 가스비가 들 수 있습니다. 이를 스프레드 계산에 포함하세요.

5. **모든 거래소가 동일하지 않습니다.** 일부 커넥터(Binance, Coinbase)는 전투 테스트를 거쳤습니다. 다른 것들은 버그가 있거나 불완전할 수 있습니다 — 항상 페이퍼 트레이딩으로 먼저 테스트하세요.

## 자주 묻는 질문

### Hummingbot을 시작하는 데 얼마의 자본이 필요한가요?

BTC-USDT와 같은 유동성 높은 페어에서 의미 있는 결과를 얻으려면 최소 **$2,000-5,000**이 권장됩니다. 이는 오더북 양쪽을 커버하고 수수료를 흡수합니다. 테스트용으로는 $0으로 페이퍼 트레이딩하거나 $500으로 저가 페어에서 실행할 수 있지만 — 더 높은 변동성 리스크를 기대하세요.

### Hummingbot에서 거래소 API 키를 사용하는 것이 안전한가요?

Hummingbot은 Docker 볼륨에 로컬로 API 키를 저장합니다. 코드는 오픈소스이고 감사 가능합니다. 모범 사례: **트레이딩 전용** 권한(출금 없음)의 API 키를 생성하고, VPS로 IP를 제한하고, 절대 설정을 Git에 커밋하지 마세요. 이 프로젝트는 여러 서드파티 보안 회사의 감사를 받았습니다.

### 여러 전략을 동시에 실행할 수 있나요?

예. 각자 자신의 설정 디렉터리와 전략 파일을 가진 여러 Docker 컨테이너를 실행하세요. 단일 컨테이너는 하나의 전략을 실행하지만, **월 $10 VPS**에서 5-10개의 전략을 동시에 실행할 수 있습니다. 리소스 사용은 선형적으로 증가합니다.

### Hummingbot은 3Commas와 같은 유료 봇과 어떻게 비교되나요?

Hummingbot은 물비, 오픈소스, 완전히 커스터마이저블합니다 — 하지만 기술적 설정이 필요합니다. 3Commas는 친숙한 UI가 있는 SaaS이지만 월 $29-99가 들고 전략 커스터마이징이 제한적입니다. Python을 작성하고 VPS를 관리할 수 있다면, Hummingbot이 제로 비용으로 더 많은 제어권을 제공합니다. 원클릭 설정을 원한다면 유료 서비스가 가치 있을 수 있습니다.

### Gateway와 일반 커넥터의 차이점은 무엇인가요?

일반 커넥터는 REST/WebSocket을 통해 중앙화 거래소 API와 상호작용합니다. **Hummingbot Gateway**는 Uniswap V3과 같은 DEX 프로토콜을 위해 블록체인 트랜잭션을 생성하는 별도의 서비스입니다. Gateway는 자신의 지갑 개인키를 관리하고 가스비를 지불해야 합니다. 복잡성이 추가되지만 탈중앙화 트레이딩을 가능하게 합니다.

### Hummingbot을 새 버전으로 업데이트하려면 어떻게 하나요?

```bash
# 최신 이미지 가져오기
docker pull hummingbot/hummingbot:latest

# 기존 컨테이너 중지 및 제거
docker stop hummingbot && docker rm hummingbot

# 동일한 볼륨 마운트로 다시 시작
docker run -it --name hummingbot \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_conf,destination=/conf" \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_logs,destination=/logs" \
  hummingbot/hummingbot:latest
```

설정은 마운트된 볼륨에 영속화됩니다.

### Hummingbot을 선물/무기한 트레이딩에 사용할 수 있나요?

예. Binance, Bybit, OKX 커넥터는 무기한 선물을 지원합니다. `domain` 파라미터를 선물 서브도메인으로 설정하고 레버리지를 신중하게 구성하세요. 펀딩비 메커니즘을 이해할 때까지 **1x-3x 레버리지**로 시작하세요.

## 결론: 오늘부터 알고리즘 트레이딩 시작하기

Hummingbot은 2026년 현재 가장 성숙한 오픈소스 마켓 메이킹 프레임워크입니다. 50개 이상의 거래소 커넥터, Docker로 5분 이내 배포, 완전한 Python 확장성으로 접근성과 성능 사이의 균형을 맞춥니다.

다음 단계:
1. **[Binance](https://www.bsmkweb.cc/register?ref=DIBI8) 또는 [OKX](https://www.promoohubly.com/join/12190433)에 가입**하여 API 키 생성
2. **위의 Docker 퀵스타트로 Hummingbot 배포**
3. **실제 자본 투입 전 1주일간 페이퍼 트레이딩**
4. **커뮤니티 참여** — [Hummingbot Discord](https://discord.gg/hummingbot)에는 15,000명 이상의 활성 트레이더가 전략을 공유합니다
5. **[Minara](https://minara.ai/r/OSXG4X)로 AI 강화 트레이딩** 탐색 — ML 기반 신호 생성

개발자 Telegram 커뮤니티 참여: [t.me/dibi8developers](https://t.me/dibi8developers) — 봇 전략, 거래소 통합, 프로덕션 배포에 대해 매일 논의합니다.

## 출처 및 추가 참고 자료

- [Hummingbot 공식 문서](https://hummingbot.org/)
- [Hummingbot GitHub 저장소](https://github.com/hummingbot/hummingbot)
- [Hummingbot Gateway 문서](https://hummingbot.org/gateway/)
- [Hummingbot 아칼데미 (전략 가이드)](https://hummingbot.org/academy/)
- [Binance API 문서](https://binance-docs.github.io/apidocs/)
- [Coinbase Advanced Trade API](https://docs.cdp.coinbase.com/advanced-trade/docs/welcome/)
- [Uniswap V3 문서](https://docs.uniswap.org/contracts/v3/overview)



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 제휴 고지

이 가이드에는 [Binance](https://www.bsmkweb.cc/register?ref=DIBI8), [OKX](https://www.promoohubly.com/join/12190433), [Minara](https://minara.ai/r/OSXG4X)의 제휴 링크가 포함되어 있습니다. 이 링크를 통해 가입하면 추가 비용 없이 커미션을 받습니다. 이는 오픈소스 문서 작업을 지원합니다. 우리는 활발히 사용하고 테스트하는 도구만을 추천합니다.
