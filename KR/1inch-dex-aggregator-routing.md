---
title: '1inch-dex-aggregator-routing'
description: '{''en'': ''Master 1inch DEX aggregator in 2026. Learn how Pathfinder routes trades across 300+ liquidity sources, implement Fusion+ gasless swaps, limit orders, and portfolio tracking with the TypeScript SDK.'', ''zh'': ''掌握 2026 年 1inch DEX 聚合器。了解 Pathfinder 如何跨 300+ 流动性来源路由交易，使用 TypeScript SDK 实现 Fusion+ 无 Gas 兑换、限价单和 portfolio 追踪。'', ''ko'': ''2026년 1inch DEX 집계기를 마스터하세요. Pathfinder가 300개 이상의 유동성 소스에서 거래를 라우팅하는 방법, Fusion+ 가스 없는 스왑, 한도 주문 및 TypeScript SDK를 사용한 포트폴리오 추적을 구현하세요.'', ''vi'': ''Làm chủ trình tổng hợp DEX 1inch năm 2026. Tìm hiểu cách Pathfinder định tuyến giao dịch qua 300+ nguồn thanh khoản, triển khai hoán đổi không gas Fusion+, lệnh giới hạn và theo dõi danh mục với SDK TypeScript.''}'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Ai Trading
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/1inch/1inch-sdk'
stars: 400
maintainer: '1inch'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: ['1inch']
aliases:
- /kr/posts/1inch-dex-aggregator-routing/
---

{{</* resource-info */>}}

탈중앙화 금융은 실험적인 뿌리를 훨씬 넘어 성숙했습니다. 2026년, 트레이더들은 단순한 유동성 접근을 넘어 매 거래의 모든 베이시스 포인트를 극대화하는 지능형 라우팅을 요구합니다. **1inch**는 이 진화의 최전선에 서 있으며, 생태계에서 가장 정교한 DEX 집계기로 작동합니다. 독점적인 **Pathfinder 알고리즘**을 통해 1inch는 10개 이상의 블록체인 네트워크에 걸쳐 **300개 이상의 유동성 소스**에서 거래를 라우팅하여 최적의 실행 가격을 보장하면서 슬리피지와 가스 비용을 최소화합니다.

간단한 스왑 최적화기로 시작한 것이 포괄적인 DeFi 인프라 제품군으로 성장했습니다. 1inch Network는 현재 **Fusion+**를 통한 가스 없는 스왑, 고급 **지정가 주문**, 강력한 **Portfolio API**, 그리고 기관급 거래 기능을 애플리케이션에 직접 임베드할 수 있는 완전히 타입화된 **TypeScript SDK**를 포함합니다. 소매 트레이딩 인터페이스, 수익 최적화 볼트 또는 알고리즘 차익거래 봇을 구축하든, 1inch의 라우팅 메커니즘을 이해하는 것은 오늘날의 단편화된 유동성 환경에서 거래 효율성을 극대화하는 데 필수적입니다.

이 가이드는 1inch의 집계 아키텍처에 대한 포괄적인 기술 심층 분석을 제공하며, 공식 SDK를 사용한 실용적인 코드 예제, 통합 패턴 및 프로덕션 배포 전략을 포함합니다.

## 1. DEX 집계 및 1inch의 역할 이해하기

DEX 집계기는 DeFi의 가장 지속적인 과제 중 하나를 해결합니다: **유동성 단편화**. 수많은 탈중앙화 거래소가 여러 체인에서 운영되는 가울 — Uniswap, Curve, Balancer, PancakeSwap, SushiSwap 및 무수히 많은 다른 거래소 — 유동성은 고립된 풀에 존재합니다. 단일 토큰 쌍이 하나의 DEX에서는 깊은 풀을 가지고 다른 DEX에서는 얕은 풀을 가질 수 있습니다. 집계 없이 트레이더는 최적이 아닌 가격, 과도한 슬리피지 및 놓친 기회에 직면합니다.

1inch는 개별 DEX 위에 **메타 레이어**로 기능하여 이 문제를 해결합니다. 1inch의 Pathfinder 알고리즘은 단일 거래소에서 스왑을 실행하는 대신, 모든 사용 가능한 유동성 소스를 동시에 검토하여 단일 거래를 여러 프로토콜과 심지어 여러 블록체인에 분할할 수 있는 복잡한 멀티 홉 경로를 구성합니다. 2026년 현재 이 네트워크는 다음을 포괄합니다:

| 체인 | 주요 DEX 소스 | 대략적인 유동성 |
|-------|-------------------|----------------------|
| Ethereum | Uniswap v3, Curve, Balancer, SushiSwap | $2.8B+ |
| Arbitrum | Camelot, Uniswap v3, SushiSwap | $890M+ |
| Optimism | Velodrome, Uniswap v3, Curve | $420M+ |
| Polygon | QuickSwap, Uniswap v3, Curve | $310M+ |
| BSC | PancakeSwap, BiSwap, Uniswap v3 | $1.2B+ |
| Base | Aerodrome, Uniswap v3, AlienBase | $650M+ |

그 결과 평균적으로 단일 DEX 거래보다 **3-15%** 일관되게 우수한 가격 실행이 이루어지며, 특히 대량 주문과 이국적인 토큰 쌍에서 상당한 개선이 나타납니다.

## 2. Pathfinder의 라우팅 알고리즘 작동 방식

1inch의 집계 기능의 핵심은 **Pathfinder**입니다 — 모든 스왑에 대해 실시간으로 최적화 문제를 해결하는 독점 라우팅 엔진입니다. 이 메커니즘을 이해하면 개발자가 실행 매개변수에 대해 정보에 입각한 결정을 내릴 수 있습니다.

### 2.1 최적화 문제

토큰 A를 토큰 B로 스왑하기 위한 견적을 요청하면 Pathfinder는 다음을 해결해야 합니다: *깊이, 수수료 및 가격이 각기 다른 N개의 유동성 소스가 주어졌을 때, 주문의 총 비용을 최소화하는 홉과 분할의 시퀀스는 무엇인가?*

이는 다음 이유로 계산 집약적입니다:
- **300개 이상의 소스**의 현재 예비금과 수수료를 쿼리해야 함
- **멀티 홉 경로**(A → C → D → B)가 직접 쌍보다 더 나은 가격을 자주 제공함
- **분할 라우팅** — 하나의 주문을 여러 경로에 분할 — 슬리피지를 줄임
- 가스 비용은 경로 복잡도에 따라 다륾; 더 많은 홉은 더 높은 실행 비용을 의미함
- **크로스체인 브리지**가 대체 실행 장소를 제공할 수 있음

### 2.2 발견 및 조립 단계

Pathfinder는 두 개의 별개 단계에서 작동합니다:

**1단계 — 경로 발견**: 알고리즘은 구성 가능한 깊이(일반적으로 4-6 홉)까지 소스 및 대상 토큰 사이의 모든 가능한 경로를 탐색합니다. 수정된 Bellman-Ford 접근 방식을 사용하여 가격 공간에서 음의 사이클을 발견하여, 실질적으로 가격 비효율성을 나타내는 차익거래 인접 경로를 찾습니다.

**2단계 — 경로 조립**: 발견된 경로는 다음을 균형 있게 조정하는 다중 목적 함수를 사용하여 점수가 매겨집니다:
- 예상 출력 금액(주요 목표)
- 가스 비용 추정(2차)
- 과거 채우기 비율을 기반으로 한 성공 확률
- MEV 보호 요구사항

```typescript
// 1inch API를 통해 견적 요청 — Pathfinder가 낶에서 라우팅을 처리
import { OneInchApi } from '@1inch/sdk';

const oneInch = new OneInchApi({
  apiKey: process.env.ONEINCH_API_KEY,
  networkId: 1, // Ethereum 메인넷
});

// 1 ETH를 USDC로 스왑하기 위한 최적 경로 가져오기
const quote = await oneInch.getQuote({
  src: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH
  dst: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // USDC
  amount: '1000000000000000000', // 1 ETH (wei 단위)
  includeTokensInfo: true,
  includeProtocols: true,
  includeGas: true,
});

console.log('예상 출력:', quote.dstAmount);
console.log('경로:', quote.protocols); // 전체 라우팅 경로 표시
console.log('예상 가스:', quote.tx.gas);
```

`protocols` 필드는 Pathfinder가 선택한 실제 경로를 보여줍니다 — 예를 들어, Uniswap v3을 통해 60%를 분할하고 Curve을 통해 40%를 분할하거나, 더 나은 가격을 위해 WETH → DAI → USDC와 같은 중간 토큰을 통해 라우팅합니다.

## 3. 1inch TypeScript SDK 설정하기

공식 1inch SDK(GitHub의 `1inch/1inch-sdk`, 400개 이상의 스타, MIT 라이선스)는 모든 1inch API에 대해 타입 안전하고 Promise 기반 인터페이스를 제공합니다. 요청 서명, 오류 처리 및 응답 파싱을 처리합니다.

### 3.1 설치 및 구성

```bash
# npm을 통해 설치
npm install @1inch/sdk

# 또는 yarn 사용
yarn add @1inch/sdk

# 피어 의존성 설치
npm install ethers axios dotenv
```

API 자격 증명을 위한 `.env` 파일 생성:

```bash
ONEINCH_API_KEY=your_api_key_here
PRIVATE_KEY=your_wallet_private_key
RPC_URL=https://mainnet.infura.io/v3/your_project_id
```

구성으로 SDK 초기화:

```typescript
import { OneInchSdk } from '@1inch/sdk';
import { ethers } from 'ethers';
import * as dotenv from 'dotenv';

dotenv.config();

// Provider 및 지갑 초기화
const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY!, provider);

// 1inch SDK 초기화
const sdk = new OneInchSdk({
  apiKey: process.env.ONEINCH_API_KEY!,
  networkId: 1, // Ethereum 메인넷
  walletAddress: wallet.address,
});

console.log('1inch SDK가', wallet.address, '에 대해 초기화됨');
```

### 3.2 SDK 아키텍처 개요

SDK는 1inch의 API 구조를 반영하는 네임스페이스로 구성됩니다:

```typescript
// SDK 모듈 구조
import {
  SwapApi,        // 토큰 스왑 및 견적
  LimitOrderApi,  // 지정가 주문 생성 및 관리
  OrderbookApi,   // 오더북 작업
  GasPriceApi,    // 가스 가격 추정
  SpotPriceApi,   // 토큰 가격 피드
  BalanceApi,     // 포트폴리오 및 잔액 추적
  HistoryApi,     // 거래 내역
} from '@1inch/sdk';

// 각 네임스페이스는 타입이 지정된 메서드를 제공
const swapApi = sdk.swap;
const limitApi = sdk.limitOrder;
const balanceApi = sdk.balance;
```

## 4. 최적의 라우팅으로 스왑 실행하기

1inch의 주요 사용 사례는 가능한 최상의 가격 실행으로 토큰 스왑을 실행하는 것입니다. SDK는 라우트 발견의 복잡성을 추상화하면서 매개변수에 대한 세밀한 제어를 개발자에게 제공합니다.

### 4.1 기본 스왑 실행

```typescript
import { OneInchSdk } from '@1inch/sdk';

async function executeSwap() {
  const sdk = new OneInchSdk({
    apiKey: process.env.ONEINCH_API_KEY!,
    networkId: 1,
  });

  // 스왑 매개변수 정의
  const swapParams = {
    src: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // 기본 ETH
    dst: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // USDC
    amount: '500000000000000000', // 0.5 ETH
    from: wallet.address,
    slippage: 1, // 최대 1% 슬리피지
    disableEstimate: false,
    allowPartialFill: false,
    includeTokensInfo: true,
    includeProtocols: true,
    compatibility: true,
  };

  // 1단계: 견적 받기 (시뮬레이션)
  const quote = await sdk.swap.getQuote(swapParams);
  console.log('견적 수신:');
  console.log('- 입력:', quote.srcAmount);
  console.log('- 예상 출력:', quote.dstAmount);
  console.log('- 가격 경로:', quote.protocols);

  // 2단계: 트랜잭션 구축
  const tx = await sdk.swap.buildTx({
    ...swapParams,
    receiver: wallet.address, // USDC가 전송될 주소
  });

  // 3단계: 트랜잭션 서명 및 전송
  const sentTx = await wallet.sendTransaction({
    to: tx.to,
    data: tx.data,
    value: tx.value,
    gasLimit: tx.gas,
    maxFeePerGas: tx.maxFeePerGas,
    maxPriorityFeePerGas: tx.maxPriorityFeePerGas,
  });

  console.log('트랜잭션 전송됨:', sentTx.hash);
  const receipt = await sentTx.wait();
  console.log('블록에서 트랜잭션 확인됨:', receipt?.blockNumber);
}

executeSwap().catch(console.error);
```

### 4.2 슬리피지 및 부분 채우기 처리

변동성이 큰 시장에서 슬리피지 허용 오차는 중요합니다. SDK는 세밀한 제어를 제공합니다:

```typescript
// 대량 거래를 위한 보수적 설정
const largeTradeParams = {
  src: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE',
  dst: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0',
  amount: '50000000000000000000', // 50 ETH — 대량 주문!
  from: wallet.address,
  slippage: 0.5, // 정밀도를 위한 타이트한 0.5% 슬리피지
  allowPartialFill: false, // 전부 또는 전무 실행
  // MEV 보호 활성화 (대량 거래에 권장)
  referrer: 'your_app_name',
  fee: 0, // 추가 수수료 없음
};

// 더 작고 긴급한 거래의 경우 슬리피지를 완화할 수 있음
const quickTradeParams = {
  ...largeTradeParams,
  amount: '1000000000000000000', // 1 ETH
  slippage: 3, // 속도를 위해 3% 슬리피지 허용 가능
  allowPartialFill: true, // 부분 실행 허용
  // 최적 가격보다 속도 우선
  protocols: 'UNISWAP_V3,SUSHI,CURVE', // 특정 프로토콜 화이트리스트
};
```

### 4.3 Bridge API를 통한 크로스체인 스왑

1inch의 집계는 단일 체인을 넘어 확장됩니다. Bridge API는 체인 간 최적 경로를 찾습니다:

```typescript
// Ethereum USDC에서 Arbitrum ETH로 브리지
const bridgeQuote = await sdk.crossChain.getQuote({
  srcChain: 1,        // Ethereum
  dstChain: 42161,    // Arbitrum
  srcToken: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // Ethereum의 USDC
  dstToken: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // Arbitrum의 ETH
  amount: '1000000000', // 1000 USDC (6 소수점)
  walletAddress: wallet.address,
});

console.log('브리지 경로:', bridgeQuote.selectedRoute);
console.log('예상 소요 시간:', bridgeQuote.estimatedTime, '초');
console.log('대상 금액:', bridgeQuote.dstTokenAmount);

// 브리지 트랜잭션 실행
const bridgeTx = await sdk.crossChain.buildTx({
  ...bridgeQuote.params,
  walletAddress: wallet.address,
});

const sentBridgeTx = await wallet.sendTransaction({
  to: bridgeTx.to,
  data: bridgeTx.data,
  value: bridgeTx.value,
  gasLimit: bridgeTx.gasLimit,
});
```

## 5. Fusion+: 가스 없는 스왑 실행

1inch의 가장 혁신적인 기능 중 하나는 **Fusion+**입니다 — 네덜란드 경매 메커니즘과 전문 마켓 메이커(리졸버)를 활용하여 사용자가 사전에 가스를 지불하지 않고도 거래를 실행하는 가스 없는 스왑 메커니즘입니다.

### 5.1 Fusion+ 작동 방식

전통적인 스왑은 사용자가 기본 토큰으로 가스 수수료를 지불해야 합니다(Ethereum의 ETH). Fusion+는 이 장벽을 제거합니다:

1. **사용자가 의도에 서명** — 최소 허용 비율로 스왑
2. **리졸버가 네덜란드 경매에서 경쟁** — 주문을 채우기 위해
3. **승리한 리졸버**가 트랜잭션을 실행하고 사용자를 대신해 가스를 지불
4. **리졸버의 수수료**는 스왑 비율에 내장되어 사용자에게 보이지 않음

```typescript
// Fusion+ 가스 없는 스왑 실행
import { FusionOrder } from '@1inch/sdk/fusion';

async function executeFusionSwap() {
  const fusionSdk = sdk.fusion;

  // Fusion+ 주문 생성 (사용자에게 가스가 필요 없음!)
  const fusionOrder = await fusionSdk.createOrder({
    srcToken: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH
    dstToken: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // USDC
    amount: '1000000000000000000', // 1 ETH
    walletAddress: wallet.address,
    // Fusion+ 매개변수
    preset: 'fast', // 'fast', 'medium', 또는 'slow'
    // 허용하는 최소 반환 (fusion이 최상의 실제 비율을 찾음)
    minReturn: '1800000000', // 최소 1800 USDC
    // 경매 지속 시간 — 리졸버가 경쟁하는 시간
    auctionDuration: 180, // 180초
  });

  console.log('Fusion 주문 생성됨:', fusionOrder.orderHash);

  // 지갑으로 주문 서명 (가스가 필요 없음!)
  const signature = await wallet.signTypedData(
    fusionOrder.domain,
    fusionOrder.types,
    fusionOrder.message
  );

  // 서명된 주문을 1inch 중계기에 제출
  const submitted = await fusionSdk.submitOrder({
    order: fusionOrder,
    signature,
    from: wallet.address,
  });

  console.log('Fusion 주문 제출됨:', submitted.orderHash);
  console.log('추적: https://1inch.io/fusion-order/' + submitted.orderHash);

  // 실행 상태 폴
  const checkStatus = async () => {
    const status = await fusionSdk.getOrderStatus(submitted.orderHash);
    console.log('주문 상태:', status.status); // 'pending', 'filled', 'expired'
    if (status.status === 'filled') {
      console.log('트랜잭션 해시:', status.txHash);
      console.log('실제 출력:', status.dstTokenAmount);
      return true;
    }
    return false;
  };

  // 10초마다 폴
  const interval = setInterval(async () => {
    const done = await checkStatus();
    if (done) clearInterval(interval);
  }, 10000);
}
```

### 5.2 Fusion+ 프리셋 설명

| 프리셋 | 경매 지속 시간 | 우선순위 | 가장 적합한 대상 |
|--------|-----------------|----------|----------|
| `fast` | 60초 | 높음 | 시간에 민감한 스왑, 더 높은 리졸버 수수료 |
| `medium` | 180초 | 중간 | 속도와 비용의 균형 |
| `slow` | 600초 | 낮음 | 최대 절약, 인내심 있는 실행 |

```typescript
// Fusion 주문 라이프사이클 모니터링
const orderEvents = fusionSdk.subscribeToOrderEvents(fusionOrder.orderHash);

orderEvents.on('created', (data) => {
  console.log('리졸버에 주문 브로드캐스트됨');
});

orderEvents.on('auctionStarted', (data) => {
  console.log('네덜란드 경매 활성화, 현재 비율:', data.currentRate);
});

orderEvents.on('filled', (data) => {
  console.log('리졸버가 주문 채움:', data.resolver);
  console.log('최종 출력 금액:', data.dstAmount);
  console.log('가스를 ZERO로 지불했습니다!');
});

orderEvents.on('expired', () => {
  console.log('주문이 채워지지 않고 만료됨 — 더 나은 minReturn으로 재시도');
});
```

## 6. 지정가 주문 및 프로그래밍 방식 트레이딩

시장가 스왑을 넘어 1inch는 트레이더가 정확한 실행 가격을 지정할 수 있는 강력한 **지정가 주문 프로토콜**을 제공합니다 — 중앙화 거래소와 유사하지만 완전히 자기 수탁 방식입니다.

### 6.1 지정가 주문 생성

```typescript
// 특정 가격으로 ETH로 DAI를 매수하는 지정가 주문 생성
const limitOrder = await sdk.limitOrder.createOrder({
  makerAsset: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH (판매하는 것)
  takerAsset: '0x6B175474E89094C44Da98b954EedeAC495271d0F', // DAI (구매하는 것)
  makingAmount: '500000000000000000', // 0.5 ETH
  takingAmount: '900000000000000000000', // 최소 900 DAI 기대
  // 주문은 24시간 후 만료
  expiration: Math.floor(Date.now() / 1000) + 86400,
  // 부분 채우기 허용 (DCA와 유사한 동작)
  partializable: true,
  // 구매한 토큰을 받을 주소
  receiver: wallet.address,
});

// 지정가 주문 서명
const limitSignature = await wallet.signTypedData(
  limitOrder.domain,
  limitOrder.types,
  limitOrder.message
);

// 1inch 오더북에 제출
const placedOrder = await sdk.limitOrder.submitOrder({
  order: limitOrder,
  signature: limitSignature,
});

console.log('지정가 주문 배치됨:', placedOrder.orderHash);
console.log('예상 체결 가격:', 900 / 0.5, 'ETH당 DAI');
```

### 6.2 주문 체결 수신 대기

```typescript
// 주문 체결을 위한 웹훅 또는 폴 리스너 설정
import { LimitOrderWatcher } from '@1inch/sdk/watcher';

const watcher = new LimitOrderWatcher({
  apiKey: process.env.ONEINCH_API_KEY!,
  networkId: 1,
  pollInterval: 5000, // 5초마다 확인
});

// 특정 주문 감시
watcher.watchOrder(placedOrder.orderHash, (event) => {
  if (event.type === 'filled') {
    console.log('주문이 완전히 채워짐!');
    console.log('트랜잭션:', event.txHash);
    console.log('채워진 금액:', event.filledAmount);
  } else if (event.type === 'partiallyFilled') {
    console.log('부분 체결:', event.filledRatio, '%');
    console.log('남은 금액:', event.remainingAmount);
  } else if (event.type === 'expired') {
    console.log('주문 만료 — 여전히 관심이 있다면 새로운 주문을 배치하세요');
  }
});

// 감시 시작
watcher.start();
```

## 7. Portfolio API 및 잔액 추적

**Portfolio API**는 모든 지원되는 체인에서 토큰 잔액, 거래 내역 및 손익에 대한 포괄적인 추적을 제공합니다 — 트레이딩 대시보드 및 세금 보고 도구 구축에 필수적입니다.

### 7.1 멀티체인 잔액 가져오기

```typescript
// 지원되는 모든 체인에서 토큰 잔액 가져오기
const portfolio = await sdk.balance.getBalances({
  walletAddress: '0xYourWalletAddress',
  chainIds: [1, 42161, 137, 10, 8453], // 멀티체인 쿼리
  // 각 토큰에 대한 메타데이터 포함
  includeMetadata: true,
  // 현재 가격의 USD 가치 포함
  includeUsdValues: true,
});

// 잔액 처리 및 표시
for (const chainBalance of portfolio.balances) {
  console.log(`\n=== 체인 ID: ${chainBalance.chainId} ===`);
  for (const token of chainBalance.tokens) {
    console.log(`${token.symbol}: ${token.balance} ($${token.usdValue})`);
  }
}

// 모든 체인에서의 총 포트폴리오 가치
const totalValue = portfolio.balances.reduce((sum, chain) => {
  return sum + chain.tokens.reduce((s, t) => s + parseFloat(t.usdValue || '0'), 0);
}, 0);

console.log(`\n총 포트폴리오 가치: $${totalValue.toFixed(2)}`);
```

### 7.2 거래 내역 및 손익 분석

```typescript
// 완전한 거래 내역 가져오기
const history = await sdk.history.getTransactions({
  walletAddress: wallet.address,
  chainIds: [1, 42161], // Ethereum 및 Arbitrum
  limit: 100,
  offset: 0,
  // 거래 유형으로 필터링
  types: ['swap', 'approval', 'limitOrder'],
});

// 스왑 성과 분석
const swaps = history.transactions.filter(tx => tx.type === 'swap');

const swapAnalysis = swaps.map(swap => ({
  timestamp: swap.timestamp,
  inputToken: swap.srcToken.symbol,
  inputAmount: swap.srcAmount,
  outputToken: swap.dstToken.symbol,
  outputAmount: swap.dstAmount,
  effectivePrice: parseFloat(swap.dstAmount) / parseFloat(swap.srcAmount),
  gasCostUsd: swap.gasCostUsd,
  route: swap.protocols?.join(' → '),
}));

console.table(swapAnalysis);

// 누적 거래량 계산
const totalVolume = swaps.reduce((sum, tx) => {
  return sum + parseFloat(tx.srcUsdValue || '0');
}, 0);
console.log(`총 스왑 거래량: $${totalVolume.toFixed(2)}`);
```

### 7.3 실시간 포트폴리오 대시보드 구축

```typescript
// WebSocket 기반 실시간 포트폴리오 업데이트
import { PortfolioWebSocket } from '@1inch/sdk/websocket';

const ws = new PortfolioWebSocket({
  apiKey: process.env.ONEINCH_API_KEY!,
  walletAddress: wallet.address,
});

ws.on('balanceUpdate', (update) => {
  console.log(`잔액 업데이트: ${update.tokenSymbol} = ${update.newBalance}`);
  console.log(`USD 가치 변동: $${update.usdValueChange}`);
  // 대시보드 UI를 여기서 업데이트
});

ws.on('newTransaction', (tx) => {
  console.log('새 트랜잭션 감지됨:', tx.hash);
  console.log('유형:', tx.type);
  console.log('가치:', tx.usdValue);
  // 실시간 알림 또는 UI 업데이트 트리거
});

ws.connect();
```

## 8. 프로덕션 통합 패턴

프로덕션에서 1inch 통합을 배포하려면 보안, 안정성 및 성능에 주의가 필요합니다.

### 8.1 오류 처리 및 재시도 로직

```typescript
// 재시도가 있는 강력한 스왑 실행
async function executeSwapWithRetry(
  params: SwapParams,
  maxRetries = 3
): Promise<TransactionReceipt> {
  let lastError: Error | null = null;

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      // 각 시도 전에 견적 새로고침 (가격이 변합니다!)
      const freshQuote = await sdk.swap.getQuote(params);
      console.log(`시도 ${attempt}: 예상 출력 = ${freshQuote.dstAmount}`);

      // 가격이 너무 많이 움직였는지 확인
      if (parseFloat(freshQuote.dstAmount) < params.minExpectedOutput!) {
        throw new Error('가격이 허용 가능한 임계값을 벗어나 이동했습니다');
      }

      const tx = await sdk.swap.buildTx({ ...params });
      const sentTx = await wallet.sendTransaction({
        to: tx.to,
        data: tx.data,
        value: tx.value,
        gasLimit: Math.floor(parseInt(tx.gas) * 1.2), // 20% 가스 버퍼
        maxFeePerGas: tx.maxFeePerGas,
        maxPriorityFeePerGas: tx.maxPriorityFeePerGas,
      });

      const receipt = await sentTx.wait(2); // 2개 확인 대기
      console.log('스왑 확인됨:', receipt?.hash);
      return receipt!;

    } catch (error) {
      lastError = error as Error;
      console.error(`시도 ${attempt} 실패:`, error);

      // 지수 백오프로 재시도 전 대기
      if (attempt < maxRetries) {
        const delay = Math.pow(2, attempt) * 1000;
        await new Promise(r => setTimeout(r, delay));
      }
    }
  }

  throw new Error(`${maxRetries}번 시도 후 스왑 실패: ${lastError?.message}`);
}
```

### 8.2 속도 제한 및 API 키 관리

```typescript
// 고빈도 사용을 위한 속도 제한 API 클라이언트
import { RateLimiter } from 'limiter';

class OneInchRateLimitedClient {
  private limiter: RateLimiter;
  private sdk: OneInchSdk;

  constructor(apiKey: string, requestsPerSecond = 5) {
    this.sdk = new OneInchSdk({ apiKey, networkId: 1 });
    this.limiter = new RateLimiter({ tokensPerInterval: requestsPerSecond, interval: 'second' });
  }

  async getQuote(params: any) {
    await this.limiter.removeTokens(1);
    return this.sdk.swap.getQuote(params);
  }

  async buildTx(params: any) {
    await this.limiter.removeTokens(1);
    return this.sdk.swap.buildTx(params);
  }
}

// 사용법
const client = new OneInchRateLimitedClient(
  process.env.ONEINCH_API_KEY!,
  3 // 보수적인 초당 3회 요청
);
```

### 8.3 보안 모범 사례

```typescript
// 프로덕션 스왑을 위한 입력 유효성 검사
function validateSwapParams(params: SwapParams): void {
  // 토큰 주소 검증
  if (!ethers.isAddress(params.src) || !ethers.isAddress(params.dst)) {
    throw new Error('잘못된 토큰 주소 형식');
  }

  // 양이 양수인지 검증
  if (BigInt(params.amount) <= 0n) {
    throw new Error('금액은 양수여야 합니다');
  }

  // 슬리피지 건전성 검사 (0.1% ~ 50%)
  if (params.slippage < 0.1 || params.slippage > 50) {
    throw new Error('슬리피지는 0.1%에서 50% 사이여야 합니다');
  }

  // 일반적인 실수 방지: 자기 자신에게 스왑
  if (params.src.toLowerCase() === params.dst.toLowerCase()) {
    throw new Error('소스 및 대상 토큰은 동일할 수 없습니다');
  }

  // 토큰이 알려진 스캠/허니팟이 아닌지 확인 (외부 목록 사용)
  if (isTokenBlacklisted(params.dst)) {
    throw new Error('대상 토큰이 블랙리스트에 있습니다');
  }
}

// 하드웨어 지갑 또는 안전한 키 관리 사용
const wallet = new ethers.Wallet(
  await getKeyFromAWSKMS(), // 절대 개인키를 하드코딩하지 마세요!
  provider
);
```

## 9. 자주 묻는 질문

**Q1: SDK가 물론이고 오픈 소스인데 1inch는 어떻게 수익을 창출하나요?**

1inch는 **유동성 소스 수수료**와 선택적 **프로토콜 거버넌스 수수료**를 통해 수익을 창출합니다. 특정 DEX를 통해 거래가 라우팅될 때 1inch는 소액의 추천 수수료를 받을 수 있습니다. 개발자에게 SDK와 API는 물론 물론 사용할 수 있지만, 고거래량 사용자는 애플리케이션과 수익을 공유하는 **파트너 수수료** 모델을 선택할 수 있습니다. MIT 라이선스가 적용된 SDK(`1inch/1inch-sdk`, GitHub에서 400개 이상의 스타)는 완전한 투명성과 허가 없는 통합을 보장합니다.

**Q2: 일반 스왑과 Fusion+ 스왑의 차이점은 무엇인가요?**

일반 스왑은 **즉시 온체인에서 실행**됩니다 — 가스를 지불하고, 트랜잭션이 채굴 되고, 토큰을 받습니다. 이는 확실성을 제공하지만 가스를 위해 ETH가 필요합니다. **Fusion+ 스왑**은 **가스 없는 의도**입니다 — 스왑 매개변수를 암호화폐로 서명하고, 전문 리졸버가 네덜란드 경매에서 주문을 채우기 위해 경쟁하고, 승리한 리졸버가 가스를 지불합니다. Fusion+는 기본 가스 토큰이 없는 사용자나 MEV 보호 실행을 원하는 사용자에게 이상적이지만, 선택한 프리셋에 따라 1-10분이 소요될 수 있습니다.

**Q3: Ethereum 이외의 체인에서 1inch를 사용할 수 있나요?**

물론입니다. 1inch는 Ethereum, Arbitrum, Optimism, Polygon, BNB Chain, Base, Avalanche, Fantom, Gnosis, zkSync Era를 포함한 **10개 이상의 블록체인 네트워크**를 지원합니다. SDK 초기화는 각 체인의 EIP-155 체인 ID에 해당하는 `networkId` 매개변수를 허용합니다. 크로스체인 스왑도 Bridge API를 통해 지원되어 최적의 라우팅으로 네트워크 간 자산 이동이 원활합니다.

**Q4: MEV 공격으로부터 거래를 어떻게 보호하나요?**

1inch는 여러 MEV 보호 메커니즘을 제공합니다: (1) **Fusion+ 주문**은 실행을 낶부화하는 전문 리졸버에 의해 채워져 선행 거래가 불가능합니다; (2) **Pathfinder 알고리즘**은 지원되는 체인에서 **프라이빗 mempool** 및 **Flashbots Protect**를 통해 라우팅할 수 있습니다; (3) 대량 거래의 경우 `compatibility` 플래그를 활성화하면 추가 슬리피지 검사가 추가됩니다; (4) 엄격한 `slippage` 허용 오차를 설정하면 샌드위치 공격의 수익 창이 줄어듭니다. 고가치 거래에 대한 최대 보호를 위해 Fusion+의 `slow` 프리셋이 권장됩니다.

**Q5: 1inch SDK는 기관 또는 고빈도 트레이딩에 적합한가요?**

1inch SDK는 **광범위한 호환성**을 위해 설계되었으며 초저지연 HFT를 위한 것은 아닙니다. 기관 사용 사례의 경우 다음을 고려하세요: (1) 공개 SDK가 아닌 **전용 속도 제한**이 있는 직접 API 액세스; (2) 1초 미만 견적 생성을 위한 **자체 Pathfinder 인스턴스** 실행; (3) 실시간 시장 데이터를 위한 **WebSocket 가격 피드** 사용; (4) 1inch의 API 서버와의 **동일 위치 배치**. SDK는 포트폴리오 관리, 스왑 실행 및 트레이딩 UI 구축에 탁월하지만 100ms 미만의 지연 시간 요구사항에는 사용자 정의 인프라가 필요할 수 있습니다.

**Q6: 1inch에서 지정가 주문은 어떻게 작동하며, 온체인인가요?**

1inch 지정가 주문은 **오프체인 오더북과 온체인 결제** 모델을 사용합니다. 주문은 EIP-712 타입 데이터 서명을 통해 서명되고 1inch의 중계기 네트워크에 브로드캐스트됩니다. **테이커**(마켓 메이커 또는 차익거래 봇)가 이를 채우기로 결정할 때까지 오프체인 상태를 유지하며, 이 시점에서 결제는 온체인에서 발생합니다. 이 설계는 주문 배치 및 취소에 대한 가스 비용을 없앱니다. 주문은 **완전히 채울 수 있거나** **부분적으로 채울 수 있으며**(DCA와 유사한 전략 활성화), 생성 시 설정된 타임스탬프를 기준으로 만료됩니다.

**Q7: 1inch를 자체 트레이딩 봇이나 DeFi 프로토콜에 통합할 수 있나요?**

예 — MIT 라이선스가 적용된 SDK는 이를 명시적으로 허용합니다. 일반적인 통합 패턴에는 다음이 포함됩니다: (1) 1inch를 스왑 백엔드로 사용하는 **DEX 인터페이스 앱**; (2) 보상 복리 및 리밸런싱에 1inch를 사용하는 **수익 집계기**; (3) 가격 차이를 모니터링하고 1inch의 최적 라우팅을 통해 실행하는 **차익거래 봇**; (4) 내장 스왑 기능을 제공하는 **지갑 애플리케이션**; (5) Portfolio API를 사용하는 **세금 보고 도구**. 모든 통합은 1inch의 [서비스 약관](https://1inch.io/terms) 및 API 사용 정책을 준수해야 합니다.



## 추천 호스팅 및 인프라

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영을 지원합니다.*

## 10. 결론 및 시작하기

1inch는 DeFi 트레이딩 스택에서 **필수 인프라**로 자리매김했습니다. 300개 이상의 유동성 소스에서 라우팅하는 Pathfinder 알고리즘의 능력은 일관되게 우수한 가격 실행을 제공하며, Fusion+ 가스 없는 스왑과 포괄적인 Portfolio API와 같은 기능은 개발자에게 차세대 트레이딩 애플리케이션을 구축할 수 있는 강력한 도구를 제공합니다.

**TypeScript SDK**(`1inch/1inch-sdk`, 400 스타, MIT 라이선스)는 프로덕션 준비가 되어 타입 안전한 인터페이스를 제공하여 다중 소스 라우팅의 복잡성을 추상화하면서 실행 매개변수에 대한 세밀한 제어를 유지합니다. 단순한 토큰 스왑을 실행하든, 정교한 트레이딩 대시보드를 구축하든, DeFi 프로토콜에 지정가 주문을 통합하든, 1inch는 필요한 인프라 계층을 제공합니다.

**시작은 간단합니다:**
1. [1inch Developer Portal](https://portal.1inch.io)에서 API 키 받기
2. SDK 설치: `npm install @1inch/sdk`
3. 이 가이드의 코드 예제를 특정 사용 사례에 따라 따르기
4. 개발자 지원을 위해 [1inch Discord](https://discord.gg/1inch) 참여

DeFi 활동에 대한 신뢰할 수 있는 중앙화 거래소를 찾는 트레이더에게 [Binance](https://www.bsmkweb.cc/register?ref=DIBI8)는 깊은 유동성과 경쟁력 있는 수수료를 제공하고, [OKX](https://www.promoohubly.com/join/12190433)는 고급 트레이딩 도구와 멀티체인 지원을 제공합니다. 중앙화 거래소의 효율성과 1inch의 탈중앙화 집계의 결합은 2026년의 멀티체인 환경을 위한 완전한 트레이딩 툴킷을 만듭니다.

오늘 1inch로 구축을 시작하여 사용자에게 DeFi가 제공할 수 있는 최상의 가격 실행을 제공하세요.
