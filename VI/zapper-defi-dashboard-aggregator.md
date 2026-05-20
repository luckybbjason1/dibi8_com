---
title: 'zapper-defi-dashboard-aggregator'
description: '{''en'': ''Comprehensive guide to Zapper, the DeFi dashboard aggregator tracking 500+ protocols. Learn portfolio tracking, yield farming analytics, Zap In/Out transactions, API integration, and custom dashboard building.'', ''zh'': ''Zapper综合指南，这个追踪500+协议的DeFi仪表盘聚合器。了解投资组合追踪、收益耕作分析、Zap In/Out交易、API集成和自定义仪表盘构建。'', ''ko'': ''500개 이상의 프로토콜을 추적하는 DeFi 대시보드 애그리게이터 Zapper에 대한 종합 가이드. 포트폴리오 추적, 이자 농사 분석, Zap In/Out 트랜잭션, API 통합, 커스텀 대시보드 구축을 알아보세요.'', ''vi'': ''Hướng dẫn toàn diện về Zapper, bảng điều khiển DeFi tổng hợp theo dõi 500+ giao thức. Tìm hiểu theo dõi danh mục, phân tích yield farming, giao dịch Zap In/Out, tích hợp API, và xây dựng bảng điều khiển tùy chỉnh.''}'
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
github_repo: 'https://github.com/Zapper-fi'
stars: 300
maintainer: 'Zapper-fi'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: ['zapper', 'defi', 'dashboard', 'portfolio', 'yield-farming', 'nft', 'api', 'zap-in', 'zap-out', 'aggregator']
aliases:
- /vi/posts/zapper-defi-dashboard-aggregator/
---

{{</* resource-info */>}}

**Ngày:** 2026-05-19  
**Danh mục:** AI Trading  
**Thẻ:** Zapper, DeFi, Dashboard, Yield Farming, NFT, Portfolio, API, Web3  
**Công cụ:** [Zapper](https://zapper.xyz)  
**GitHub:** [Zapper-fi](https://github.com/Zapper-fi) — ⭐ 300+ sao, Giấy phép MIT

---

> Bắt đầu theo dõi danh mục DeFi của bạn ngay hôm nay! Đăng ký trên [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) hoặc [OKX](https://www.promoohubly.com/join/12190433) để bắt đầu hành trình DeFi.

---

## 1. Giới thiệu: Cuộc Cách Mạng Bảng Điều Khiển DeFi trong năm 2026

Tài chính Phi tập trung (DeFi) đã bùng nổ thành một hệ sinh thái nghìn tỷ đô la bao gồm các giao thức cho vay, sàn giao dịch phi tập trung (DEX), bộ tổng hợp yield, nền tảng phái sinh, và thị trường NFT. Đến năm 2026, ngườidùng DeFi chuyên sâu tương tác với 20-50+ giao thức đồng thờigian, khiến việc theo dõi danh mục và quản lý vị thế ngày càng phức tạp. Sự phân mảnh thanh khoản trên các chuỗi Layer-1, Rollup Layer-2, và app-chain đã tạo ra nhu cầu cấp bách cho các giải pháp bảng điều khiển thống nhất.

**Zapper** đã nổi lên như bảng điều khiển DeFi tổng hợp hàng đầu, cung cấp cho ngườidùng cái nhìn toàn diện, thờigian thực về toàn bộ danh mục on-chain của họ trên **500+ giao thức** và nhiều mạng blockchain. Được sáng lập bởi [Zapper-fi](https://github.com/Zapper-fi) và vận hành theo giấy phép MIT, Zapper cho phép ngườidùng theo dõi tài sản, giám sát các vị thế yield farming, quản lý bộ sưu tập NFT, và thực hiện các giao dịch phức tạp thông qua một giao diện thống nhất, trực quan.

Không giống như các công cụ theo dõi danh mục cơ bản chỉ hiển thị số dư token, Zapper cung cấp **quản lý DeFi có thể thực thi** — cho phép ngườidùng "Zap In" và "Zap Out" khỏi các vị thế thanh khoản, chuyển cầu tài sản xuyên chuỗi, nhận thưởng, và khám phá các cơ hội yield mới. Cơ sở hạ tầng API mạnh mẽ của nó cũng cho phép các nhà phát triển tích hợp khả năng tổng hợp dữ liệu của Zapper vào ứng dụng của riêng họ.

Hướng dẫn toàn diện này bao gồm kiến trúc của Zapper, các mẫu tích hợp API, khả năng theo dõi yield, trình xây dựng giao dịch, và các chiến lược triển khai thực tế cho các nhà phát triển và ngườidùng DeFi chuyên sâu trong năm 2026.

---

## 2. Kiến trúc lõi: Zapper Tổng Hợp Dữ Liệu DeFi Như Thế Nào

### 2.1 Lớp Tổng Hợp Dữ Liệu Đa Giao Thức

Cơ sở hạ tầng phụ trợ của Zapper kết nối với hàng trăm giao thức DeFi thông qua một hệ thống tích hợp mô-đun. Mỗi tích hợp giao thức trừu tượng hóa sự phức tạp của tương tác hợp đồng thông minh thành các mô hình dữ liệu chuẩn hóa:

```typescript
// Kiến trúc tích hợp giao thức Zapper
interface ProtocolPosition {
  // Định danh duy nhất
  protocolId: string;           // ví dụ: "aave-v3", "uniswap-v3"
  network: string;              // "ethereum", "polygon", "arbitrum"
  
  // Phân tích tài sản
  tokens: TokenBalance[];
  
  // Siêu dữ liệu vị thế
  positionType: 'lending' | 'liquidity-pool' | 'staking' | 'yield-farming' | 'locked';
  
  // Chỉ số tài chính
  balances: {
    supplied: BigNumber;
    borrowed: BigNumber;
    claimable: BigNumber;
    totalValueUSD: number;
  };
  
  // Chỉ số yield
  yield: {
    apy: number;                // APY hiện tại
    dailyYieldUSD: number;
    totalEarnedUSD: number;
    rewardTokens: RewardToken[];
  };
}

interface TokenBalance {
  address: string;
  symbol: string;
  decimals: number;
  balance: BigNumber;
  balanceUSD: number;
  priceUSD: number;
}
```

### 2.2 Đồng Bộ Danh Mục Thờigian Thực

```typescript
// Lấy danh mục đầy đủ bằng API Zapper
import { ZapperClient } from '@zapper-fi/zapper-api';

const client = new ZapperClient({
  apiKey: process.env.ZAPPER_API_KEY,
  baseUrl: 'https://api.zapper.xyz'
});

// Lấy tất cả các vị thế giao thức cho một địa chỉ
async function getPortfolio(address: string): Promise<PortfolioSummary> {
  const [apps, balances] = await Promise.all([
    client.v2.apps.getApps(),
    client.v2.balances.getBalances({
      addresses: [address],
      networks: ['ethereum', 'polygon', 'arbitrum', 'optimism', 'base']
    })
  ]);

  // Tổng hợp các vị thế theo danh mục
  const portfolio: PortfolioSummary = {
    totalNetWorth: 0,
    categories: {
      wallet: [],
      lending: [],
      liquidity: [],
      staking: [],
      nfts: [],
      claimable: []
    },
    protocols: new Map()
  };

  balances.data.forEach((position: any) => {
    const value = position.balanceUSD || 0;
    portfolio.totalNetWorth += value;
    
    // Phân loại vị thế
    switch (position.appId) {
      case 'tokens':
        portfolio.categories.wallet.push(position);
        break;
      case 'aave-v3':
      case 'compound':
      case 'morpho':
        portfolio.categories.lending.push(position);
        break;
      case 'uniswap-v3':
      case 'balancer-v2':
      case 'curve':
        portfolio.categories.liquidity.push(position);
        break;
      default:
        if (position.positionType === 'staking') {
          portfolio.categories.staking.push(position);
        }
    }
  });

  return portfolio;
}

// Thực thi
const portfolio = await getPortfolio('0xMyAddress...');
console.log(`Tổng Giá trị Tài sản Ròng: $${portfolio.totalNetWorth.toLocaleString()}`);
console.log(`Vị thế Lending: ${portfolio.categories.lending.length}`);
console.log(`Vị thế LP: ${portfolio.categories.liquidity.length}`);
```

### 2.3 Hệ Thống Oracle Giá Token

```typescript
// Tổng hợp giá Zapper
async function getTokenPrices(
  client: ZapperClient,
  tokens: string[],
  network: string = 'ethereum'
): Promise<Map<string, number>> {
  const prices = new Map<string, number>();
  
  // Yêu cầu giá theo lô (tối đa 100 mỗi lần gọi)
  const batchSize = 100;
  for (let i = 0; i < tokens.length; i += batchSize) {
    const batch = tokens.slice(i, i + batchSize);
    
    const response = await client.v2.prices.getPrices({
      network,
      addresses: batch
    });
    
    response.data.forEach((price: any) => {
      prices.set(price.address.toLowerCase(), price.priceUSD);
    });
  }
  
  return prices;
}

// Sử dụng
const tokenPrices = await getTokenPrices(
  client,
  [
    '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2', // WETH
    '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48', // USDC
    '0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984'  // UNI
  ]
);

console.log('WETH:', tokenPrices.get('0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'));
console.log('USDC:', tokenPrices.get('0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'));
```

---

## 3. Xác Thực API và Thiết Lập

### 3.1 Lấy API Key

```bash
# Bước 1: Đăng ký tại https://zapper.xyz và điều hướng đến Cài đặt Nhà phát triển
# Bước 2: Tạo API key
# Bước 3: Lưu trữ an toàn trong biến môi trường

export ZAPPER_API_KEY="your_api_key_here"
export ZAPPER_API_URL="https://api.zapper.xyz"
```

### 3.2 Khởi Tạo SDK

```typescript
// Khởi tạo SDK Zapper với xác thực
import { ZapperClient } from '@zapper-fi/zapper-api';

// Tùy chọn 1: Khởi tạo trực tiếp
const client = new ZapperClient({
  apiKey: process.env.ZAPPER_API_KEY,
  timeout: 30000,           // Thờigian chờ 30 giây
  retries: 3                // Tự động thử lại yêu cầu thất bại
});

// Tùy chọn 2: Sử dụng cấu hình môi trường
const client = ZapperClient.fromEnvironment();
```

```python
# Thiết lập SDK Python
import os
from zapper_api import ZapperClient

client = ZapperClient(
    api_key=os.getenv('ZAPPER_API_KEY'),
    base_url='https://api.zapper.xyz'
)

# Xác minh kết nối
health = client.health.check()
print(f"Trạng thái API: {health.status}")
print(f"Mạng được hỗ trợ: {len(health.networks)}")
print(f"Giao thức tích hợp: {health.protocolCount}")
```

```bash
# Ví dụ xác thực cURL
curl -X GET "https://api.zapper.xyz/v2/balances?addresses[]=0x...&networks[]=ethereum" \
  -H "Authorization: Bearer ${ZAPPER_API_KEY}" \
  -H "Content-Type: application/json"
```

---

## 4. Theo Dõi Danh Mục: Tổng Quan Vị Thế DeFi Đầy Đủ

### 4.1 Lấy Tất Cả Vị Thế

```typescript
// Lấy danh mục toàn diện với tất cả các vị thế
async function getFullPortfolio(address: string) {
  const response = await client.v2.balances.getBalances({
    addresses: [address],
    networks: ['ethereum', 'polygon', 'arbitrum', 'optimism', 'base', 'avalanche'],
    includeMeta: true
  });

  // Xử lý và phân loại các vị thế
  const breakdown = {
    wallet: { value: 0, tokens: [] },
    lending: { supplied: 0, borrowed: 0, netValue: 0, protocols: [] },
    liquidityPools: { value: 0, pools: [] },
    staking: { value: 0, positions: [] },
    nfts: { value: 0, collections: [] },
    claimable: { value: 0, rewards: [] }
  };

  response.data.forEach((position: any) => {
    const category = categorizePosition(position);
    
    switch (category) {
      case 'wallet':
        breakdown.wallet.value += position.balanceUSD;
        breakdown.wallet.tokens.push({
          symbol: position.symbol,
          balance: formatUnits(position.balance, position.decimals),
          valueUSD: position.balanceUSD
        });
        break;
        
      case 'lending':
        const supplied = position.balances?.supplied?.balanceUSD || 0;
        const borrowed = position.balances?.borrowed?.balanceUSD || 0;
        breakdown.lending.supplied += supplied;
        breakdown.lending.borrowed += borrowed;
        breakdown.lending.netValue += (supplied - borrowed);
        breakdown.lending.protocols.push(position.appName);
        break;
        
      case 'liquidity':
        breakdown.liquidityPools.value += position.balanceUSD;
        breakdown.liquidityPools.pools.push({
          protocol: position.appName,
          tokens: position.tokens.map((t: any) => t.symbol),
          valueUSD: position.balanceUSD,
          apy: position.yield?.apy || 0
        });
        break;
        
      case 'staking':
        breakdown.staking.value += position.balanceUSD;
        breakdown.staking.positions.push(position);
        break;
    }
  });

  return breakdown;
}

// Hàm trợ giúp
function categorizePosition(position: any): string {
  if (position.appId === 'tokens') return 'wallet';
  if (['aave-v3', 'compound', 'morpho', 'spark'].includes(position.appId)) return 'lending';
  if (['uniswap-v3', 'balancer-v2', 'curve', 'sushi'].includes(position.appId)) return 'liquidity';
  if (position.positionType === 'staking') return 'staking';
  return 'other';
}
```

### 4.2 Theo Dõi Danh Mục NFT

```typescript
// Theo dõi nắm giữ NFT trên các thị trường
async function getNFTPortfolio(address: string) {
  const nfts = await client.v2.nfts.getNftsForAddress({
    address,
    networks: ['ethereum', 'polygon'],
    includeFloorPrice: true,
    includeMetadata: true
  });

  const nftSummary = {
    totalCollections: 0,
    totalNFTs: 0,
    estimatedValueUSD: 0,
    collections: [] as any[]
  };

  nfts.data.forEach((collection: any) => {
    const collectionValue = collection.floorPriceUSD * collection.tokenIds.length;
    
    nftSummary.totalCollections++;
    nftSummary.totalNFTs += collection.tokenIds.length;
    nftSummary.estimatedValueUSD += collectionValue;
    
    nftSummary.collections.push({
      name: collection.collectionName,
      contract: collection.contractAddress,
      count: collection.tokenIds.length,
      floorPriceUSD: collection.floorPriceUSD,
      estimatedValueUSD: collectionValue,
      tokens: collection.tokenIds
    });
  });

  return nftSummary;
}

// Hiển thị danh mục NFT
const nftPortfolio = await getNFTPortfolio('0xMyAddress...');
console.log(`\n📊 Tóm Tắt Danh Mục NFT`);
console.log(`Bộ sưu tập: ${nftPortfolio.totalCollections}`);
console.log(`Tổng NFT: ${nftPortfolio.totalNFTs}`);
console.log(`Giá trị Ước tính: $${nftPortfolio.estimatedValueUSD.toLocaleString()}`);

nftPortfolio.collections
  .sort((a, b) => b.estimatedValueUSD - a.estimatedValueUSD)
  .forEach(c => {
    console.log(`\n  ${c.name}: ${c.count} vật phẩm @ $${c.floorPriceUSD.toFixed(2)} sàn = $${c.estimatedValueUSD.toFixed(2)}`);
  });
```

---

## 5. Theo Dõi và Phân Tích Yield Farming

### 5.1 Giám Sát Các Vị Thế Yield Đang Hoạt Động

```typescript
// Theo dõi các vị thế yield farming với phân tích APY
interface YieldPosition {
  protocol: string;
  poolName: string;
  network: string;
  depositedTokens: TokenAmount[];
  depositedValueUSD: number;
  rewardTokens: RewardInfo[];
  apy: {
    total: number;
    base: number;        // APY pool cơ bản
    rewards: number;     // APY token thưởng
  };
  dailyYieldUSD: number;
  totalEarnedUSD: number;
  impermanentLoss?: number;
}

interface RewardInfo {
  token: string;
  tokenPriceUSD: number;
  dailyAmount: number;
  dailyValueUSD: number;
  claimableAmount: number;
}

// Lấy các vị thế yield
async function getYieldPositions(address: string): Promise<YieldPosition[]> {
  const balances = await client.v2.balances.getBalances({
    addresses: [address],
    networks: ['ethereum', 'arbitrum', 'optimism'],
    appId: ['uniswap-v3', 'balancer-v2', 'curve', 'convex', 'yearn', 'pendle']
  });

  const yieldPositions: YieldPosition[] = [];

  balances.data.forEach((position: any) => {
    if (position.yield?.apy > 0) {
      yieldPositions.push({
        protocol: position.appName,
        poolName: position.label || 'Pool Không xác định',
        network: position.network,
        depositedTokens: position.tokens.map((t: any) => ({
          symbol: t.symbol,
          amount: formatUnits(t.balance, t.decimals),
          valueUSD: t.balanceUSD
        })),
        depositedValueUSD: position.balanceUSD,
        rewardTokens: position.yield.rewardTokens?.map((r: any) => ({
          token: r.symbol,
          tokenPriceUSD: r.priceUSD,
          dailyAmount: r.dailyAmount,
          dailyValueUSD: r.dailyValueUSD,
          claimableAmount: r.claimable
        })) || [],
        apy: {
          total: position.yield.apy,
          base: position.yield.baseApy || 0,
          rewards: position.yield.rewardApy || 0
        },
        dailyYieldUSD: position.yield.dailyYieldUSD || 0,
        totalEarnedUSD: position.yield.totalEarnedUSD || 0,
        impermanentLoss: position.il?.percent
      });
    }
  });

  return yieldPositions.sort((a, b) => b.depositedValueUSD - a.depositedValueUSD);
}

// Hiển thị bảng điều khiển yield
const positions = await getYieldPositions('0xMyAddress...');

console.log('\n🌾 Các Vị Thế Yield Đang Hoạt Động\n');
console.log('-'.repeat(80));

let totalDeposited = 0;
let totalDailyYield = 0;

positions.forEach(pos => {
  totalDeposited += pos.depositedValueUSD;
  totalDailyYield += pos.dailyYieldUSD;
  
  console.log(`\n${pos.protocol} — ${pos.poolName} (${pos.network})`);
  console.log(`  Đã gửi: $${pos.depositedValueUSD.toLocaleString()}`);
  console.log(`  APY: ${pos.apy.total.toFixed(2)}% (Cơ bản: ${pos.apy.base.toFixed(2)}% + Thưởng: ${pos.apy.rewards.toFixed(2)}%)`);
  console.log(`  Yield Hàng ngày: $${pos.dailyYieldUSD.toFixed(2)}`);
  console.log(`  Tổng Đã Kiếm: $${pos.totalEarnedUSD.toLocaleString()}`);
  
  if (pos.impermanentLoss) {
    console.log(`  ⚠️ IL: ${pos.impermanentLoss.toFixed(2)}%`);
  }
  
  pos.rewardTokens.forEach(r => {
    console.log(`  Thưởng: ${r.dailyAmount.toFixed(4)} ${r.token}/ngày ($${r.dailyValueUSD.toFixed(2)})`);
  });
});

console.log(`\n${'='.repeat(80)}`);
console.log(`Tổng Đã Gửi: $${totalDeposited.toLocaleString()}`);
console.log(`Tổng Yield Hàng ngày: $${totalDailyYield.toFixed(2)} (${(totalDailyYield * 365 / totalDeposited * 100).toFixed(2)}% APY)`);
console.log(`Dự Phóng Hàng tháng: $${(totalDailyYield * 30).toFixed(2)}`);
```

### 5.2 Khám Phá Cơ Hội Yield

```typescript
// Khám phá cơ hội yield mới
async function discoverYields(
  network: string = 'ethereum',
  minTvl: number = 1_000_000,  // TVL tối thiểu $1M
  minApy: number = 5            // APY tối thiểu 5%
) {
  const opportunities = await client.v2.yields.getYieldOpportunities({
    network,
    minTvl,
    minApy,
    sortBy: 'apy',
    sortDirection: 'desc',
    limit: 50
  });

  return opportunities.data.map((opp: any) => ({
    protocol: opp.protocol,
    poolName: opp.name,
    tokens: opp.tokens.map((t: any) => t.symbol),
    tvlUSD: opp.tvlUSD,
    apy: {
      total: opp.apy.total,
      base: opp.apy.base,
      rewards: opp.apy.rewards
    },
    riskLevel: opp.riskLevel,     // low | medium | high
    ilRisk: opp.impermanentLossRisk
  }));
}

// Tìm cơ hội yield tốt nhất
const bestYields = await discoverYields('ethereum', 10_000_000, 10);

console.log('\n🏆 Cơ Hội Yield Hàng Đầu (TVL > $10M, APY > 10%)\n');
bestYields.slice(0, 10).forEach((opp, i) => {
  console.log(`${i + 1}. ${opp.protocol} — ${opp.poolName}`);
  console.log(`   Token: ${opp.tokens.join('/')}`);
  console.log(`   TVL: $${(opp.tvlUSD / 1e6).toFixed(1)}M | APY: ${opp.apy.total.toFixed(2)}%`);
  console.log(`   Rủi ro: ${opp.riskLevel} | Rủi ro IL: ${opp.ilRisk || 'N/A'}`);
  console.log();
});
```

---

## 6. Trình Xây Dựng Giao Dịch: Zap In và Zap Out

### 6.1 Cung Cấp Thanh Khoản Đơn Giản Hóa (Zap In)

Một trong những tính năng mạnh mẽ nhất của Zapper là **Transaction Builder**, cho phép ngườidùng tham gia các vị thế thanh khoản phức tạp chỉ với một giao dịch. Thay vì thủ công hoán đổi, phê duyệt, và gửi token, tính năng "Zap In" của Zapper xử lý mọi thứ:

```typescript
// Zap vào vị thế Uniswap V3
async function zapInUniswapV3(
  fromToken: string,        // Địa chỉ token để zap
  amount: string,            // Số lượng (wei)
  poolAddress: string,       // Pool Uniswap V3
  tickLower: number,         // Tick dưới
  tickUpper: number,         // Tick trên
  slippage: number = 0.005   // Ngưỡng trượt giá 0.5%
) {
  const zapParams = {
    fromToken,
    amount,
    toProtocol: 'uniswap-v3',
    toPool: poolAddress,
    tickRange: { lower: tickLower, upper: tickUpper },
    slippageTolerance: slippage,
    recipient: '0xMyAddress...'
  };

  // Tạo dữ liệu giao dịch
  const tx = await client.v2.zap.generateZapInTransaction(zapParams);

  console.log('Giao dịch sẵn sàng:');
  console.log(`  Đến: ${tx.to}`);
  console.log(`  Giá trị: ${tx.value}`);
  console.log(`  Ước tính Gas: ${tx.gasEstimate}`);
  console.log(`  Bước: ${tx.steps?.length || 1}`);

  // Ký và gửi
  const receipt = await wallet.sendTransaction({
    to: tx.to,
    data: tx.data,
    value: tx.value,
    gasLimit: tx.gasEstimate * 120n / 100n  // Đệm 20%
  });

  return receipt.hash;
}

// Ví dụ: Zap 1 ETH vào pool ETH/USDC
const txHash = await zapInUniswapV3(
  '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH
  ethers.parseEther('1').toString(),
  '0x8ad599c3A0ff1De082011EFDDc58f1908eb6e6D8',     // Pool ETH/USDC 0.3%
  -887220,                                            // Phạm vi dưới đầy đủ
  887220                                              // Phạm vi trên đầy đủ
);

console.log(`Zap In hoàn tất: ${txHash}`);
```

### 6.2 Thoát Vị Thế (Zap Out)

```typescript
// Zap out khỏi vị thế thanh khoản
async function zapOutPosition(
  protocol: string,         // ví dụ: 'uniswap-v3'
  positionId: string,       // ID NFT vị thế hoặc định danh
  toToken: string,          // Token nhận
  slippage: number = 0.005
) {
  const zapParams = {
    fromProtocol: protocol,
    positionId,
    toToken,
    slippageTolerance: slippage,
    recipient: '0xMyAddress...',
    // Tùy chọn: nhận thưởng trước khi thoát
    claimRewards: true,
    // Tùy chọn: đóng vị thế hoặc thoát một phần
    exitPercentage: 100  // 100% = thoát hoàn toàn
  };

  const tx = await client.v2.zap.generateZapOutTransaction(zapParams);

  console.log('Giao dịch Zap Out:');
  console.log(`  Đầu ra dự kiến: ${tx.expectedOutput}`);
  console.log(`  Đầu ra tối thiểu (có trượt giá): ${tx.minOutput}`);

  const receipt = await wallet.sendTransaction({
    to: tx.to,
    data: tx.data,
    value: tx.value,
    gasLimit: tx.gasEstimate * 120n / 100n
  });

  return receipt.hash;
}

// Thoát hoàn toàn khỏi vị thế Uniswap V3
const exitTx = await zapOutPosition(
  'uniswap-v3',
  '12345',  // ID token NFT
  '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48'  // Nhận USDC
);
```

### 6.3 Giao Dịch Đa Bước Phức Tạp

```typescript
// Bridge + Zap In (vào vị thế xuyên chuỗi)
async function bridgeAndZap(
  fromChain: string,       // Chuỗi nguồn
  toChain: string,          // Chuỗi đích
  fromToken: string,
  amount: string,
  targetProtocol: string,
  targetPool: string
) {
  const route = await client.v2.bridge.getBridgeRoute({
    fromChain,
    toChain,
    fromToken,
    amount,
    recipient: '0xMyAddress...'
  });

  // Bước 1: Giao dịch bridge
  const bridgeTx = await wallet.sendTransaction({
    to: route.bridgeContract,
    data: route.bridgeData,
    value: route.value
  });

  console.log(`Bridge tx: ${bridgeTx.hash}`);

  // Chờ bridge hoàn tất
  await client.v2.bridge.waitForBridge(bridgeTx.hash, fromChain, toChain);

  // Bước 2: Zap vào vị thế trên chuỗi đích
  const zapTx = await client.v2.zap.generateZapInTransaction({
    fromToken: route.destToken,
    amount: route.destAmount,
    toProtocol: targetProtocol,
    toPool: targetPool
  });

  const receipt = await destChainWallet.sendTransaction({
    to: zapTx.to,
    data: zapTx.data,
    value: zapTx.value,
    gasLimit: zapTx.gasEstimate * 120n / 100n
  });

  return receipt.hash;
}
```

---

## 7. Các Mẫu Tích Hợp API Nâng Cao

### 7.1 Cập Nhật Thờigian Thực WebSocket

```typescript
// Cập nhật danh mục thờigian thực qua WebSocket
import { ZapperWebSocket } from '@zapper-fi/zapper-api';

const ws = new ZapperWebSocket({
  apiKey: process.env.ZAPPER_API_KEY,
  url: 'wss://ws.zapper.xyz'
});

// Đăng ký cập nhật địa chỉ
ws.subscribe('address:0xMyAddress...', (update: any) => {
  switch (update.type) {
    case 'balance_change':
      console.log(`💰 Cập nhật số dư: ${update.token} = ${update.newBalance}`);
      break;
    case 'new_position':
      console.log(`📈 Phát hiện vị thế mới: ${update.protocol} — ${update.valueUSD}`);
      break;
    case 'yield_claimed':
      console.log(`🎁 Đã nhận thưởng: ${update.amount} ${update.token}`);
      break;
    case 'nft_transfer':
      console.log(`🖼️ NFT đã chuyển: ${update.collection} #${update.tokenId}`);
      break;
  }
});

// Quản lý kết nối
ws.onConnect(() => console.log('Đã kết nối Zapper WS'));
ws.onDisconnect(() => console.log('Đã ngắt kết nối, đang thử lại...'));
ws.onError((err) => console.error('Lỗi WS:', err));
```

### 7.2 Dữ Liệu Lịch sử và Theo Dõi Lãi/Lỗ

```typescript
// Hiệu suất danh mục lịch sử
async function getHistoricalPerformance(
  address: string,
  days: number = 90
) {
  const history = await client.v2.analytics.getHistoricalBalances({
    address,
    granularity: 'daily',
    daysBack: days
  });

  const performance = {
    startValue: history.data[0]?.totalUSD || 0,
    endValue: history.data[history.data.length - 1]?.totalUSD || 0,
    peakValue: Math.max(...history.data.map((d: any) => d.totalUSD)),
    troughValue: Math.min(...history.data.map((d: any) => d.totalUSD)),
    dailyChanges: [] as any[]
  };

  // Tính toán thay đổi hàng ngày
  for (let i = 1; i < history.data.length; i++) {
    const prev = history.data[i - 1].totalUSD;
    const curr = history.data[i].totalUSD;
    const change = curr - prev;
    const changePct = (change / prev) * 100;

    performance.dailyChanges.push({
      date: history.data[i].timestamp,
      value: curr,
      change,
      changePct
    });
  }

  // Chỉ số tóm tắt
  const totalReturn = performance.endValue - performance.startValue;
  const totalReturnPct = (totalReturn / performance.startValue) * 100;

  console.log('\n📈 Hiệu Suất Danh Mục (90 Ngày Qua)');
  console.log(`Giá trị Bắt đầu: $${performance.startValue.toLocaleString()}`);
  console.log(`Giá trị Hiện tại: $${performance.endValue.toLocaleString()}`);
  console.log(`Giá trị Đỉnh: $${performance.peakValue.toLocaleString()}`);
  console.log(`Tổng Lợi nhuận: $${totalReturn.toLocaleString()} (${totalReturnPct.toFixed(2)}%)`);
  console.log(`Drawdown Tối đa: ${((performance.peakValue - performance.troughValue) / performance.peakValue * 100).toFixed(2)}%`);

  return performance;
}

// P&L theo giao thức
async function getProtocolPnL(
  address: string,
  protocol: string,
  days: number = 30
) {
  const pnl = await client.v2.analytics.getProtocolPnL({
    address,
    protocol,
    period: `${days}d`
  });

  return {
    deposits: pnl.data.totalDeposited,
    withdrawals: pnl.data.totalWithdrawn,
    feesEarned: pnl.data.feesEarned,
    rewardsClaimed: pnl.data.rewardsClaimed,
    impermanentLoss: pnl.data.impermanentLoss,
    netPnL: pnl.data.netPnL
  };
}
```

### 7.3 Thao Tác Hàng Loạt

```typescript
// Truy vấn danh mục hàng loạt cho nhiều địa chỉ
async function batchPortfolioQuery(addresses: string[]) {
  const batchSize = 20;  // Tối đa 20 địa chỉ mỗi yêu cầu
  const results = [];

  for (let i = 0; i < addresses.length; i += batchSize) {
    const batch = addresses.slice(i, i + batchSize);

    const response = await client.v2.balances.getBalances({
      addresses: batch,
      networks: ['ethereum', 'arbitrum', 'polygon']
    });

    results.push(...response.data);
  }

  // Tổng hợp trên tất cả các địa chỉ
  const aggregate = {
    totalValue: 0,
    protocolExposure: new Map<string, number>(),
    tokenExposure: new Map<string, number>()
  };

  results.forEach((portfolio: any) => {
    aggregate.totalValue += portfolio.totalUSD;
    
    // Phơi nhiễm giao thức
    portfolio.positions.forEach((pos: any) => {
      const current = aggregate.protocolExposure.get(pos.appName) || 0;
      aggregate.protocolExposure.set(pos.appName, current + pos.balanceUSD);
    });
  });

  return aggregate;
}

// Sử dụng: Phân tích ví cá voi
const whaleAddresses = [
  '0x...',  // Cá voi đã biết 1
  '0x...',  // Cá voi đã biết 2
  // ... thêm địa chỉ
];

const whaleData = await batchPortfolioQuery(whaleAddresses);
console.log(`Giá Trị Danh Mục Tổng hợp: $${whaleData.totalValue.toLocaleString()}`);

// Phơi nhiễm giao thức hàng đầu
const sortedExposure = [...whaleData.protocolExposure.entries()]
  .sort((a, b) => b[1] - a[1])
  .slice(0, 10);

console.log('\nPhơi Nhiễm Giao Thức Hàng Đầu:');
sortedExposure.forEach(([protocol, value]) => {
  console.log(`  ${protocol}: $${value.toLocaleString()}`);
});
```

---

## 8. Xây Dựng Bảng Điều Khiển Tùy Chỉnh với Dữ Liệu Zapper

### 8.1 Tích Hợp Thành Phần React

```tsx
// React hook cho dữ liệu danh mục Zapper
import { useState, useEffect } from 'react';
import { ZapperClient } from '@zapper-fi/zapper-api';

const client = new ZapperClient({ apiKey: process.env.REACT_APP_ZAPPER_KEY });

export function usePortfolio(address: string | undefined) {
  const [portfolio, setPortfolio] = useState<any>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!address) return;

    const fetchPortfolio = async () => {
      setLoading(true);
      setError(null);

      try {
        const response = await client.v2.balances.getBalances({
          addresses: [address],
          networks: ['ethereum', 'polygon', 'arbitrum']
        });

        setPortfolio(response.data);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Tải thất bại');
      } finally {
        setLoading(false);
      }
    };

    fetchPortfolio();

    // Tự động làm mới mỗi 60 giây
    const interval = setInterval(fetchPortfolio, 60000);
    return () => clearInterval(interval);
  }, [address]);

  return { portfolio, loading, error };
}

// Thành phần bảng điều khiển
export function PortfolioDashboard({ address }: { address: string }) {
  const { portfolio, loading, error } = usePortfolio(address);

  if (loading) return <div>Đang tải danh mục...</div>;
  if (error) return <div>Lỗi: {error}</div>;
  if (!portfolio) return null;

  return (
    <div className="dashboard">
      <h1>Tổng Quan Danh Mục</h1>
      
      <div className="total-value">
        <h2>${portfolio.totalUSD?.toLocaleString()}</h2>
        <span>Tổng Giá trị Tài sản Ròng</span>
      </div>

      <div className="positions-grid">
        {portfolio.positions?.map((pos: any) => (
          <PositionCard key={pos.key} position={pos} />
        ))}
      </div>
    </div>
  );
}

function PositionCard({ position }: { position: any }) {
  return (
    <div className="position-card">
      <div className="protocol">
        <img src={position.appImg} alt={position.appName} />
        <span>{position.appName}</span>
      </div>
      <div className="value">
        ${position.balanceUSD?.toLocaleString()}
      </div>
      {position.yield?.apy > 0 && (
        <div className="apy">
          APY: {position.yield.apy.toFixed(2)}%
        </div>
      )}
    </div>
  );
}
```

### 8.2 Hệ Thống Cảnh Báo Yield

```typescript
// Giám sát và cảnh báo yield tự động
import { schedule } from 'node-cron';

interface YieldAlert {
  condition: 'apy_drop' | 'apy_spike' | 'il_warning' | 'reward_change';
  threshold: number;
  protocol?: string;
  action: 'notify' | 'auto_compound' | 'exit';
}

class YieldMonitor {
  private client: ZapperClient;
  private alerts: YieldAlert[] = [];

  constructor(apiKey: string) {
    this.client = new ZapperClient({ apiKey });
  }

  addAlert(alert: YieldAlert) {
    this.alerts.push(alert);
  }

  async checkPositions(address: string) {
    const positions = await this.getYieldPositions(address);
    const previous = await this.loadPreviousData(address);

    for (const position of positions) {
      const prev = previous.get(position.poolName);

      for (const alert of this.alerts) {
        if (alert.protocol && alert.protocol !== position.protocol) continue;

        switch (alert.condition) {
          case 'apy_drop':
            if (prev && (position.apy.total / prev.apy - 1) * 100 < -alert.threshold) {
              await this.sendAlert(`🚨 APY giảm ${alert.threshold}% trên ${position.poolName}: ${position.apy.total.toFixed(2)}%`);
            }
            break;

          case 'il_warning':
            if (position.impermanentLoss && position.impermanentLoss > alert.threshold) {
              await this.sendAlert(`⚠️ Cảnh báo IL trên ${position.poolName}: ${position.impermanentLoss.toFixed(2)}%`);
            }
            break;

          case 'reward_change':
            const rewardChange = position.rewardTokens.reduce(
              (sum, r) => sum + r.dailyValueUSD, 0
            );
            if (prev && Math.abs(rewardChange - prev.dailyRewards) > alert.threshold) {
              await this.sendAlert(`💰 Thay đổi thưởng trên ${position.poolName}: $${rewardChange.toFixed(2)}/ngày`);
            }
            break;
        }
      }
    }

    // Lưu dữ liệu hiện tại để so sánh lần tới
    await this.saveCurrentData(address, positions);
  }

  private async sendAlert(message: string) {
    // Gửi đến Telegram, Discord, hoặc email
    await fetch(process.env.ALERT_WEBHOOK_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ text: message })
    });
  }

  startMonitoring(address: string, interval: string = '*/15 * * * *') {
    // Kiểm tra mỗi 15 phút theo mặc định
    schedule(interval, () => this.checkPositions(address));
    console.log(`Giám sát yield đã bắt đầu cho ${address}`);
  }
}

// Sử dụng
const monitor = new YieldMonitor(process.env.ZAPPER_API_KEY);

monitor.addAlert({
  condition: 'apy_drop',
  threshold: 20,  // Cảnh báo nếu APY giảm 20%
  action: 'notify'
});

monitor.addAlert({
  condition: 'il_warning',
  threshold: 5,   // Cảnh báo nếu IL vượt quá 5%
  action: 'notify'
});

monitor.startMonitoring('0xMyAddress...');
```

---

## 9. Câu hỏi Thường gặp (FAQ)

### 9.1 Zapper là gì và nó khác gì so với các công cụ theo dõi danh mục khác?

Zapper là một **bảng điều khiển DeFi tổng hợp** toàn diện vượt xa việc chỉ theo dõi số dư. Khác với các công cụ theo dõi danh mục cơ bản (Zerion, DeBank), Zapper cung cấp **quản lý DeFi có thể thực thi** — cho phép ngườidùng "Zap In" và "Zap Out" khỏi các vị thế, nhận thưởng, chuyển cầu tài sản, và thực thi các giao dịch phức tạp trực tiếp từ bảng điều khiển. Với hỗ trợ cho **500+ giao thức** trên nhiều chuỗi và API mạnh mẽ cho nhà phát triển, Zapper đóng vai trò vừa là trình quản lý danh mục cho ngườidùng, vừa là nền tảng hạ tầng cho nhà phát triển. Trình xây dựng giao dịch của nó trừu tượng hóa sự phức tạp của các thao tác DeFi đa bước thành hành động một cú nhấp chuột.

### 9.2 Zapper có miễn phí không? Giới hạn tốc độ API là bao nhiêu?

Bảng điều khiển web của Zapper **hoàn toàn miễn phí** cho tất cả ngườidùng. API hoạt động theo mô hình freemium: gói miễn phí bao gồm 100 yêu cầu/phút và truy cập các endpoint cơ bản, đủ cho hầu hết các dự án cá nhân và ứng dụng nhỏ. Các gói trả phí cung cấp giới hạn tốc độ cao hơn (lên đến 10.000 yêu cầu/phút), truy cập WebSocket cho dữ liệu thờigian thực, và hỗ trợ ưu tiên. Các gói doanh nghiệp với cơ sở hạ tầng chuyên dụng có sẵn cho các ứng dụng giao dịch tần suất cao hoặc trình quản lý danh mục quy mô lớn. Kiểm tra [trang giá của Zapper](https://zapper.xyz/pricing) để biết mức giá hiện tại.

### 9.3 Zapper tính giá token và giá trị danh mục như thế nào?

Zapper tổng hợp dữ liệu giá từ nhiều sàn giao dịch phi tập trung (DEX) và oracle giá, bao gồm Chainlink, Uniswap V3, Curve, và Balancer. Đối với token thanh khoản, giá được tính bằng **khối lượng giao dịch có trọng số trung bình (VWAP)** trên các pool DEX chính. Đối với token ít thanh khoản hoặc khối lượng thấp, Zapper sử dụng kết hợp giá oracle và giá giao dịch cuối cùng với chỉ báo độ tin cậy. Giá trị danh mục được tính theo thờigian thực bằng cách nhân số dư token với giá hiện tại. Tất cả dữ liệu giá được làm mới mỗi 60 giây, với các token quan trọng được cập nhật thường xuyên hơn trong thờigian biến động cao.

### 9.4 Tôi có thể thực thi giao dịch trực tiếp thông qua Zapper không?

Có, **Transaction Builder** của Zapper cho phép thực thi giao dịch trực tiếp cho hầu hết các giao thức được hỗ trợ. Ngườidùng có thể "Zap In" vào các pool thanh khoản (gửi một token duy nhất sẽ tự động được hoán đổi và ghép cặp), "Zap Out" (thoát vị thế về một token mong muốn), nhận thưởng, chuyển cầu tài sản xuyên chuỗi, và thực hiện hoán đổi. Tất cả giao dịch được ký thông qua ví đã kết nối (MetaMask, WalletConnect, Coinbase Wallet, v.v.). Zapper không lưu ký quỹ tài sản của bạn — bạn duy trì toàn quyền kiểm soát các khóa riêng của mình.

### 9.5 Làm thế nào để tích hợp API Zapper vào ứng dụng của riêng tôi?

Zapper cung cấp **RESTful API** với tài liệu toàn diện tại [docs.zapper.xyz](https://docs.zapper.xyz). Các bước tích hợp: (1) Đăng ký API key tại [zapper.xyz](https://zapper.xyz), (2) Cài đặt SDK chính thức (`npm install @zapper-fi/zapper-api`) hoặc sử dụng yêu cầu HTTP trực tiếp, (3) Xác thực bằng API key trong header `Authorization: Bearer`. Các endpoint chính bao gồm `/v2/balances` (dữ liệu danh mục), `/v2/apps` (danh sách giao thức), `/v2/prices` (giá token), và `/v2/transactions` (xây dựng giao dịch). Hỗ trợ WebSocket có sẵn trên các gói trả phí cho cập nhật thờigian thực.

---



## Hosting Và Hạ Tầng Được Đề Xuất

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit $200 trong 60 ngày.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## 10. Kết luận: Tương Lai của Quản Lý Danh Mục DeFi

Khi DeFi tiếp tục tăng trưởng bùng nổ trên hàng trăm giao thức và hàng chục mạng blockchain, nhu cầu về các giải pháp quản lý danh mục thống nhất chưa bao giờ lớn hơn. Zapper giải quyết thách thức này bằng cách cung cấp một bảng điều khiển duy nhất tổng hợp các vị thế từ **500+ giao thức**, theo dõi hiệu suất yield farming, quản lý bộ sưu tập NFT, và cho phép thực thi giao dịch một cú nhấp chuột.

Đối với các nhà phát triển, cơ sở hạ tầng API của Zapper cung cấp một nền tảng vững chắc để xây dựng các ứng dụng DeFi tùy chỉnh — từ công cụ theo dõi danh mục và bộ tối ưu hóa yield đến các công cụ quản lý rủi ro cho tổ chức. Sự kết hợp của phủ sóng dữ liệu toàn diện, cập nhật thờigian thực, và khả năng xây dựng giao dịch mạnh mẽ làm cho Zapper trở thành một thành phần thiết yếu của bộ công cụ nhà phát triển DeFi.

Nhìn về nửa cuối năm 2026, chúng tôi dự đoán các tích hợp sâu hơn với ví **Account Abstraction (ERC-4337)**, các giao thức **giao dịch dựa trên ý định**, và các tính năng **tối ưu hóa danh mục dựa trên AI**. Khi ranh giới giữa DeFi, NFT, và token xã hội tiếp tục mờ nhạt, vị thế của Zapper như bảng điều khiển thống nhất cho mọi tài sản on-chain ngày càng có giá trị.

Dù bạn là ngườidùng DeFi bình thường theo dõi pool thanh khoản đầu tiên hay một tổ chức quản lý hàng triệu đô la trên hàng chục giao thức, Zapper cung cấp các công cụ, dữ liệu, và hạ tầng cần thiết để điều hướng bối cảnh DeFi phức tạp một cách tự tin.

---

> **Bắt đầu hành trình DeFi của bạn ngay hôm nay!** Đăng ký trên [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) hoặc [OKX](https://www.promoohubly.com/join/12190433) để bắt đầu giao dịch và theo dõi danh mục của bạn với Zapper.

---

**Giấy phép:** MIT  
**Ngườibảo trì:** [Zapper-fi](https://github.com/Zapper-fi)  
**Sao GitHub:** 300+  
**Trang web:** [zapper.xyz](https://zapper.xyz)
