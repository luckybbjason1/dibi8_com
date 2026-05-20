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
- /posts/1inch-dex-aggregator-routing/
---

{{</* resource-info */>}}

Decentralized finance has matured far beyond its experimental roots. In 2026, traders demand not just access to liquidity, but intelligent routing that maximizes every basis point of their trades. **1inch** stands at the forefront of this evolution, operating as the most sophisticated DEX aggregator in the ecosystem. With its proprietary **Pathfinder algorithm**, 1inch routes transactions across more than **300 liquidity sources** spanning 10+ blockchain networks, ensuring optimal execution prices while minimizing slippage and gas costs.

What started as a simple swap optimizer has grown into a comprehensive DeFi infrastructure suite. The 1inch Network now encompasses **Fusion+** for gasless swaps, advanced **limit orders**, a powerful **Portfolio API**, and a fully typed **TypeScript SDK** that enables developers to embed institutional-grade trading capabilities directly into their applications. Whether you're building a retail trading interface, a yield optimization vault, or an algorithmic arbitrage bot, understanding 1inch's routing mechanics is essential for maximizing trading efficiency in today's fragmented liquidity landscape.

This guide provides a comprehensive technical deep-dive into 1inch's aggregation architecture, complete with practical code examples using the official SDK, integration patterns, and production deployment strategies.

## 1. Understanding DEX Aggregation and 1inch's Role

DEX aggregators solve one of DeFi's most persistent challenges: **liquidity fragmentation**. With hundreds of decentralized exchanges operating across multiple chains — Uniswap, Curve, Balancer, PancakeSwap, SushiSwap, and countless others — liquidity exists in silos. A single token pair might have deep pools on one DEX and shallow pools on another. Without aggregation, traders face suboptimal prices, excessive slippage, and missed opportunities.

1inch addresses this by functioning as a **meta-layer** above individual DEXes. Rather than executing a swap on a single exchange, 1inch's Pathfinder algorithm examines all available liquidity sources simultaneously, constructing complex multi-hop routes that can split a single trade across multiple protocols and even multiple blockchains. In 2026, this network spans:

| Chain | Primary DEX Sources | Approximate Liquidity |
|-------|-------------------|----------------------|
| Ethereum | Uniswap v3, Curve, Balancer, SushiSwap | $2.8B+ |
| Arbitrum | Camelot, Uniswap v3, SushiSwap | $890M+ |
| Optimism | Velodrome, Uniswap v3, Curve | $420M+ |
| Polygon | QuickSwap, Uniswap v3, Curve | $310M+ |
| BSC | PancakeSwap, BiSwap, Uniswap v3 | $1.2B+ |
| Base | Aerodrome, Uniswap v3, AlienBase | $650M+ |

The result is price execution that consistently outperforms single-DEX trading by **3-15%** on average, with particularly significant improvements for large orders and exotic token pairs.

## 2. How Pathfinder's Routing Algorithm Works

The heart of 1inch's aggregation capability is **Pathfinder** — a proprietary routing engine that solves an optimization problem in real-time for every swap. Understanding its mechanics helps developers make informed decisions about trade parameters.

### 2.1 The Optimization Problem

When you request a quote for swapping Token A to Token B, Pathfinder must solve: *Given N liquidity sources with varying depths, fees, and prices, what sequence of hops and splits minimizes the total cost of filling the order?*

This is computationally intensive because:
- **300+ sources** must be queried for current reserves and fees
- **Multi-hop paths** (A → C → D → B) often yield better prices than direct pairs
- **Split routing** — dividing one order across multiple paths — reduces slippage
- **Gas costs** vary by route complexity; more hops mean higher execution costs
- **Cross-chain bridges** may offer alternative execution venues

### 2.2 The Discovery and Assembly Phases

Pathfinder operates in two distinct phases:

**Phase 1 — Route Discovery**: The algorithm explores all possible paths between source and destination tokens up to a configurable depth (typically 4-6 hops). It uses a modified Bellman-Ford approach to discover negative cycles in price space, effectively finding arbitrage-adjacent routes that indicate price inefficiencies.

**Phase 2 — Route Assembly**: Discovered paths are scored using a multi-objective function that balances:
- Expected output amount (primary objective)
- Gas cost estimation (secondary)
- Success probability based on historical fill rates
- MEV protection requirements

```typescript
// Request a quote through the 1inch API — Pathfinder handles routing internally
import { OneInchApi } from '@1inch/sdk';

const oneInch = new OneInchApi({
  apiKey: process.env.ONEINCH_API_KEY,
  networkId: 1, // Ethereum mainnet
});

// Get the optimal route for swapping 1 ETH to USDC
const quote = await oneInch.getQuote({
  src: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH
  dst: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // USDC
  amount: '1000000000000000000', // 1 ETH in wei
  includeTokensInfo: true,
  includeProtocols: true,
  includeGas: true,
});

console.log('Expected output:', quote.dstAmount);
console.log('Route paths:', quote.protocols); // Shows the full routing path
console.log('Estimated gas:', quote.tx.gas);
```

The `protocols` field reveals the actual route Pathfinder selected — for example, splitting 60% through Uniswap v3 and 40% through Curve, or routing through an intermediate token like WETH → DAI → USDC for better pricing.

## 3. Setting Up the 1inch TypeScript SDK

The official 1inch SDK (`1inch/1inch-sdk` on GitHub, 400+ stars, MIT license) provides a type-safe, promise-based interface to all 1inch APIs. It handles request signing, error handling, and response parsing.

### 3.1 Installation and Configuration

```bash
# Install via npm
npm install @1inch/sdk

# Or with yarn
yarn add @1inch/sdk

# Install peer dependencies
npm install ethers axios dotenv
```

Create a `.env` file for your API credentials:

```bash
ONEINCH_API_KEY=your_api_key_here
PRIVATE_KEY=your_wallet_private_key
RPC_URL=https://mainnet.infura.io/v3/your_project_id
```

Initialize the SDK with your configuration:

```typescript
import { OneInchSdk } from '@1inch/sdk';
import { ethers } from 'ethers';
import * as dotenv from 'dotenv';

dotenv.config();

// Initialize provider and wallet
const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY!, provider);

// Initialize the 1inch SDK
const sdk = new OneInchSdk({
  apiKey: process.env.ONEINCH_API_KEY!,
  networkId: 1, // Ethereum mainnet
  walletAddress: wallet.address,
});

console.log('1inch SDK initialized for', wallet.address);
```

### 3.2 SDK Architecture Overview

The SDK is organized into namespaces that mirror 1inch's API structure:

```typescript
// SDK module structure
import {
  SwapApi,        // Token swaps and quotes
  LimitOrderApi,  // Limit order creation and management
  OrderbookApi,   // Orderbook operations
  GasPriceApi,    // Gas price estimation
  SpotPriceApi,   // Token price feeds
  BalanceApi,     // Portfolio and balance tracking
  HistoryApi,     // Transaction history
} from '@1inch/sdk';

// Each namespace provides typed methods
const swapApi = sdk.swap;
const limitApi = sdk.limitOrder;
const balanceApi = sdk.balance;
```

## 4. Executing Swaps with Optimal Routing

The primary use case for 1inch is executing token swaps with the best possible price execution. The SDK abstracts away the complexity of route discovery while giving developers fine-grained control over parameters.

### 4.1 Basic Swap Execution

```typescript
import { OneInchSdk } from '@1inch/sdk';

async function executeSwap() {
  const sdk = new OneInchSdk({
    apiKey: process.env.ONEINCH_API_KEY!,
    networkId: 1,
  });

  // Define swap parameters
  const swapParams = {
    src: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // Native ETH
    dst: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // USDC
    amount: '500000000000000000', // 0.5 ETH
    from: wallet.address,
    slippage: 1, // 1% max slippage
    disableEstimate: false,
    allowPartialFill: false,
    includeTokensInfo: true,
    includeProtocols: true,
    compatibility: true,
  };

  // Step 1: Get a quote (simulation)
  const quote = await sdk.swap.getQuote(swapParams);
  console.log('Quote received:');
  console.log('- Input:', quote.srcAmount);
  console.log('- Expected output:', quote.dstAmount);
  console.log('- Price route:', quote.protocols);

  // Step 2: Build the transaction
  const tx = await sdk.swap.buildTx({
    ...swapParams,
    receiver: wallet.address, // Where USDC will be sent
  });

  // Step 3: Sign and send the transaction
  const sentTx = await wallet.sendTransaction({
    to: tx.to,
    data: tx.data,
    value: tx.value,
    gasLimit: tx.gas,
    maxFeePerGas: tx.maxFeePerGas,
    maxPriorityFeePerGas: tx.maxPriorityFeePerGas,
  });

  console.log('Transaction sent:', sentTx.hash);
  const receipt = await sentTx.wait();
  console.log('Transaction confirmed in block:', receipt?.blockNumber);
}

executeSwap().catch(console.error);
```

### 4.2 Handling Slippage and Partial Fills

Slippage tolerance is critical in volatile markets. The SDK provides granular control:

```typescript
// Conservative settings for large trades
const largeTradeParams = {
  src: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE',
  dst: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0',
  amount: '50000000000000000000', // 50 ETH — large order!
  from: wallet.address,
  slippage: 0.5, // Tight 0.5% slippage for precision
  allowPartialFill: false, // All-or-nothing execution
  // Enable MEV protection (recommended for large trades)
  referrer: 'your_app_name',
  fee: 0, // No additional fee
};

// For smaller, more urgent trades, you can relax slippage
const quickTradeParams = {
  ...largeTradeParams,
  amount: '1000000000000000000', // 1 ETH
  slippage: 3, // 3% slippage acceptable for speed
  allowPartialFill: true, // Accept partial execution
  // Prioritize speed over optimal price
  protocols: 'UNISWAP_V3,SUSHI,CURVE', // Whitelist specific protocols
};
```

### 4.3 Cross-Chain Swaps via the Bridge API

1inch's aggregation extends beyond single chains. The Bridge API finds optimal routes across chains:

```typescript
// Bridge from Ethereum USDC to Arbitrum ETH
const bridgeQuote = await sdk.crossChain.getQuote({
  srcChain: 1,        // Ethereum
  dstChain: 42161,    // Arbitrum
  srcToken: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // USDC on Ethereum
  dstToken: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH on Arbitrum
  amount: '1000000000', // 1000 USDC (6 decimals)
  walletAddress: wallet.address,
});

console.log('Bridge route:', bridgeQuote.selectedRoute);
console.log('Estimated duration:', bridgeQuote.estimatedTime, 'seconds');
console.log('Destination amount:', bridgeQuote.dstTokenAmount);

// Execute the bridge transaction
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

## 5. Fusion+: Gasless Swap Execution

One of 1inch's most innovative features is **Fusion+** — a gasless swapping mechanism that leverages Dutch auction mechanics and professional market makers (resolvers) to execute trades without the user paying gas upfront.

### 5.1 How Fusion+ Works

Traditional swaps require users to pay gas fees in the native token (ETH on Ethereum). Fusion+ eliminates this barrier:

1. **User signs an intent** to swap at a minimum acceptable rate
2. **Resolvers compete** in a Dutch auction to fill the order
3. **The winning resolver** executes the transaction, paying gas on behalf of the user
4. **The resolver's fee** is embedded in the swap rate, invisible to the user

```typescript
// Execute a Fusion+ gasless swap
import { FusionOrder } from '@1inch/sdk/fusion';

async function executeFusionSwap() {
  const fusionSdk = sdk.fusion;

  // Create a Fusion+ order (gasless for the user!)
  const fusionOrder = await fusionSdk.createOrder({
    srcToken: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH
    dstToken: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // USDC
    amount: '1000000000000000000', // 1 ETH
    walletAddress: wallet.address,
    // Fusion+ parameters
    preset: 'fast', // 'fast', 'medium', or 'slow'
    // The minimum return you'll accept (fusion finds the best actual rate)
    minReturn: '1800000000', // Minimum 1800 USDC
    // Auction duration — how long resolvers compete
    auctionDuration: 180, // 180 seconds
  });

  console.log('Fusion order created:', fusionOrder.orderHash);

  // Sign the order with your wallet (no gas required!)
  const signature = await wallet.signTypedData(
    fusionOrder.domain,
    fusionOrder.types,
    fusionOrder.message
  );

  // Submit the signed order to the 1inch relayer
  const submitted = await fusionSdk.submitOrder({
    order: fusionOrder,
    signature,
    from: wallet.address,
  });

  console.log('Fusion order submitted:', submitted.orderHash);
  console.log('Track at: https://1inch.io/fusion-order/' + submitted.orderHash);

  // Poll for execution status
  const checkStatus = async () => {
    const status = await fusionSdk.getOrderStatus(submitted.orderHash);
    console.log('Order status:', status.status); // 'pending', 'filled', 'expired'
    if (status.status === 'filled') {
      console.log('Transaction hash:', status.txHash);
      console.log('Actual output:', status.dstTokenAmount);
      return true;
    }
    return false;
  };

  // Poll every 10 seconds
  const interval = setInterval(async () => {
    const done = await checkStatus();
    if (done) clearInterval(interval);
  }, 10000);
}
```

### 5.2 Fusion+ Presets Explained

| Preset | Auction Duration | Priority | Best For |
|--------|-----------------|----------|----------|
| `fast` | 60 seconds | High | Time-sensitive swaps, higher resolver fee |
| `medium` | 180 seconds | Medium | Balanced speed and cost |
| `slow` | 600 seconds | Low | Maximum savings, patient execution |

```typescript
// Monitor Fusion order lifecycle
const orderEvents = fusionSdk.subscribeToOrderEvents(fusionOrder.orderHash);

orderEvents.on('created', (data) => {
  console.log('Order broadcast to resolvers');
});

orderEvents.on('auctionStarted', (data) => {
  console.log('Dutch auction active, current rate:', data.currentRate);
});

orderEvents.on('filled', (data) => {
  console.log('Order filled by resolver:', data.resolver);
  console.log('Final output amount:', data.dstAmount);
  console.log('You paid ZERO gas!');
});

orderEvents.on('expired', () => {
  console.log('Order expired without fill — retry with better minReturn');
});
```

## 6. Limit Orders and Programmatic Trading

Beyond market swaps, 1inch offers a robust **limit order protocol** that allows traders to specify exact prices for execution — similar to centralized exchanges but fully self-custodial.

### 6.1 Creating Limit Orders

```typescript
// Create a limit order to buy DAI with ETH at a specific price
const limitOrder = await sdk.limitOrder.createOrder({
  makerAsset: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH (what you sell)
  takerAsset: '0x6B175474E89094C44Da98b954EedeAC495271d0F', // DAI (what you buy)
  makingAmount: '500000000000000000', // 0.5 ETH
  takingAmount: '900000000000000000000', // Expect 900 DAI minimum
  // Order expires in 24 hours
  expiration: Math.floor(Date.now() / 1000) + 86400,
  // Allow partial fills (DCA-like behavior)
  partializable: true,
  // Receiver address for the purchased tokens
  receiver: wallet.address,
});

// Sign the limit order
const limitSignature = await wallet.signTypedData(
  limitOrder.domain,
  limitOrder.types,
  limitOrder.message
);

// Submit to 1inch orderbook
const placedOrder = await sdk.limitOrder.submitOrder({
  order: limitOrder,
  signature: limitSignature,
});

console.log('Limit order placed:', placedOrder.orderHash);
console.log('Expected fill price:', 900 / 0.5, 'DAI per ETH');
```

### 6.2 Listening for Order Fills

```typescript
// Set up a webhook or polling listener for order fills
import { LimitOrderWatcher } from '@1inch/sdk/watcher';

const watcher = new LimitOrderWatcher({
  apiKey: process.env.ONEINCH_API_KEY!,
  networkId: 1,
  pollInterval: 5000, // Check every 5 seconds
});

// Watch your specific order
watcher.watchOrder(placedOrder.orderHash, (event) => {
  if (event.type === 'filled') {
    console.log('Order completely filled!');
    console.log('Transaction:', event.txHash);
    console.log('Amount filled:', event.filledAmount);
  } else if (event.type === 'partiallyFilled') {
    console.log('Partial fill:', event.filledRatio, '%');
    console.log('Remaining:', event.remainingAmount);
  } else if (event.type === 'expired') {
    console.log('Order expired — place a new one if still interested');
  }
});

// Start watching
watcher.start();
```

## 7. Portfolio API and Balance Tracking

The **Portfolio API** provides comprehensive tracking of token balances, transaction history, and P&L across all supported chains — critical for building trading dashboards and tax reporting tools.

### 7.1 Fetching Multi-Chain Balances

```typescript
// Get all token balances across supported chains
const portfolio = await sdk.balance.getBalances({
  walletAddress: '0xYourWalletAddress',
  chainIds: [1, 42161, 137, 10, 8453], // Multi-chain query
  // Include metadata for each token
  includeMetadata: true,
  // Include USD values at current prices
  includeUsdValues: true,
});

// Process and display balances
for (const chainBalance of portfolio.balances) {
  console.log(`\n=== Chain ID: ${chainBalance.chainId} ===`);
  for (const token of chainBalance.tokens) {
    console.log(`${token.symbol}: ${token.balance} ($${token.usdValue})`);
  }
}

// Total portfolio value across all chains
const totalValue = portfolio.balances.reduce((sum, chain) => {
  return sum + chain.tokens.reduce((s, t) => s + parseFloat(t.usdValue || '0'), 0);
}, 0);

console.log(`\nTotal Portfolio Value: $${totalValue.toFixed(2)}`);
```

### 7.2 Transaction History and P&L Analysis

```typescript
// Fetch complete transaction history
const history = await sdk.history.getTransactions({
  walletAddress: wallet.address,
  chainIds: [1, 42161], // Ethereum and Arbitrum
  limit: 100,
  offset: 0,
  // Filter by transaction type
  types: ['swap', 'approval', 'limitOrder'],
});

// Analyze swap performance
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

// Calculate cumulative volume
const totalVolume = swaps.reduce((sum, tx) => {
  return sum + parseFloat(tx.srcUsdValue || '0');
}, 0);
console.log(`Total swap volume: $${totalVolume.toFixed(2)}`);
```

### 7.3 Building a Real-Time Portfolio Dashboard

```typescript
// WebSocket-based real-time portfolio updates
import { PortfolioWebSocket } from '@1inch/sdk/websocket';

const ws = new PortfolioWebSocket({
  apiKey: process.env.ONEINCH_API_KEY!,
  walletAddress: wallet.address,
});

ws.on('balanceUpdate', (update) => {
  console.log(`Balance update: ${update.tokenSymbol} = ${update.newBalance}`);
  console.log(`USD value change: $${update.usdValueChange}`);
  // Update your dashboard UI here
});

ws.on('newTransaction', (tx) => {
  console.log('New transaction detected:', tx.hash);
  console.log('Type:', tx.type);
  console.log('Value:', tx.usdValue);
  // Trigger real-time alerts or UI updates
});

ws.connect();
```

## 8. Production Integration Patterns

Deploying 1inch integration in production requires attention to security, reliability, and performance.

### 8.1 Error Handling and Retry Logic

```typescript
// Robust swap execution with retries
async function executeSwapWithRetry(
  params: SwapParams,
  maxRetries = 3
): Promise<TransactionReceipt> {
  let lastError: Error | null = null;

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      // Refresh the quote before each attempt (prices change!)
      const freshQuote = await sdk.swap.getQuote(params);
      console.log(`Attempt ${attempt}: Expected output = ${freshQuote.dstAmount}`);

      // Check if price moved too much
      if (parseFloat(freshQuote.dstAmount) < params.minExpectedOutput!) {
        throw new Error('Price moved beyond acceptable threshold');
      }

      const tx = await sdk.swap.buildTx({ ...params });
      const sentTx = await wallet.sendTransaction({
        to: tx.to,
        data: tx.data,
        value: tx.value,
        gasLimit: Math.floor(parseInt(tx.gas) * 1.2), // 20% gas buffer
        maxFeePerGas: tx.maxFeePerGas,
        maxPriorityFeePerGas: tx.maxPriorityFeePerGas,
      });

      const receipt = await sentTx.wait(2); // Wait for 2 confirmations
      console.log('Swap confirmed:', receipt?.hash);
      return receipt!;

    } catch (error) {
      lastError = error as Error;
      console.error(`Attempt ${attempt} failed:`, error);

      // Wait before retry with exponential backoff
      if (attempt < maxRetries) {
        const delay = Math.pow(2, attempt) * 1000;
        await new Promise(r => setTimeout(r, delay));
      }
    }
  }

  throw new Error(`Swap failed after ${maxRetries} attempts: ${lastError?.message}`);
}
```

### 8.2 Rate Limiting and API Key Management

```typescript
// Rate-limited API client for high-frequency usage
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

// Usage
const client = new OneInchRateLimitedClient(
  process.env.ONEINCH_API_KEY!,
  3 // Conservative 3 requests per second
);
```

### 8.3 Security Best Practices

```typescript
// Input validation for production swaps
function validateSwapParams(params: SwapParams): void {
  // Validate token addresses
  if (!ethers.isAddress(params.src) || !ethers.isAddress(params.dst)) {
    throw new Error('Invalid token address format');
  }

  // Validate amount is positive
  if (BigInt(params.amount) <= 0n) {
    throw new Error('Amount must be positive');
  }

  // Sanity check slippage (0.1% to 50%)
  if (params.slippage < 0.1 || params.slippage > 50) {
    throw new Error('Slippage must be between 0.1% and 50%');
  }

  // Prevent common mistake: swapping token to itself
  if (params.src.toLowerCase() === params.dst.toLowerCase()) {
    throw new Error('Source and destination tokens cannot be the same');
  }

  // Verify token is not a known scam/honeypot (use external list)
  if (isTokenBlacklisted(params.dst)) {
    throw new Error('Destination token is blacklisted');
  }
}

// Use a hardware wallet or secure key management
const wallet = new ethers.Wallet(
  await getKeyFromAWSKMS(), // Never hardcode private keys!
  provider
);
```

## 9. Frequently Asked Questions

**Q1: How does 1inch make money if the SDK is free and open-source?**

1inch generates revenue through **liquidity source fees** and optional **protocol governance fees**. When a trade is routed through certain DEXes, 1inch may receive a small referral fee. For developers, the SDK and API are free to use, though high-volume users can opt into a **partner fee** model that shares revenue with the integrating application. The MIT-licensed SDK (`1inch/1inch-sdk`, 400+ GitHub stars) ensures complete transparency and permissionless integration.

**Q2: What is the difference between a regular swap and a Fusion+ swap?**

Regular swaps execute **on-chain immediately** — you pay gas, the transaction mines, and you receive your tokens. This offers certainty but requires ETH for gas. **Fusion+ swaps** are **gasless intents** — you cryptographically sign your swap parameters, professional resolvers compete in a Dutch auction to fill your order, and the winning resolver pays the gas. Fusion+ is ideal for users without native gas tokens or those seeking MEV-protected execution, though it may take 1-10 minutes depending on the preset selected.

**Q3: Can I use 1inch on chains other than Ethereum?**

Absolutely. 1inch supports **10+ blockchain networks** including Ethereum, Arbitrum, Optimism, Polygon, BNB Chain, Base, Avalanche, Fantom, Gnosis, and zkSync Era. The SDK initialization accepts a `networkId` parameter corresponding to each chain's EIP-155 chain ID. Cross-chain swaps are also supported via the Bridge API, allowing seamless movement of assets between networks with optimal routing.

**Q4: How do I protect my trades from MEV attacks?**

1inch provides multiple MEV protection mechanisms: (1) **Fusion+ orders** are filled by professional resolvers who internalize execution, making frontrunning impossible; (2) The **Pathfinder algorithm** can route through **private mempools** and **Flashbots Protect** on supported chains; (3) For large trades, enabling the `compatibility` flag adds additional slippage checks; (4) Setting tight `slippage` tolerances reduces the profit window for sandwich attacks. For maximum protection on high-value trades, Fusion+ with the `slow` preset is recommended.

**Q5: Is the 1inch SDK suitable for institutional or high-frequency trading?**

The 1inch SDK is designed for **broad compatibility** rather than ultra-low-latency HFT. For institutional use cases, consider: (1) **Direct API access** with dedicated rate limits rather than the public SDK; (2) Running your own **Pathfinder instance** for sub-second quote generation; (3) Using the **WebSocket price feeds** for real-time market data; (4) Implementing **co-location** with 1inch's API servers. The SDK excels at portfolio management, swap execution, and building trading UIs, but sub-100ms latency requirements may need custom infrastructure.

**Q6: How do limit orders work on 1inch, and are they on-chain?**

1inch limit orders use an **off-chain orderbook with on-chain settlement** model. Orders are signed via EIP-712 typed data signatures and broadcast to 1inch's relayer network. They remain off-chain until a **taker** (market maker or arbitrage bot) decides to fill them, at which point the settlement occurs on-chain. This design eliminates gas costs for placing and canceling orders. Orders can be **fully fillable** or **partially fillable** (enabling DCA-like strategies), and expire based on the timestamp set at creation.

**Q7: Can I integrate 1inch into my own trading bot or DeFi protocol?**

Yes — the MIT-licensed SDK explicitly permits this. Common integration patterns include: (1) **DEX interface apps** that use 1inch as the swap backend; (2) **Yield aggregators** that use 1inch for reward compounding and rebalancing; (3) **Arbitrage bots** that monitor price differences and execute via 1inch's optimal routing; (4) **Wallet applications** offering built-in swap functionality; (5) **Tax reporting tools** using the Portfolio API. All integrations must comply with 1inch's [Terms of Service](https://1inch.io/terms) and API usage policies.



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## 10. Conclusion and Getting Started

1inch has established itself as **essential infrastructure** in the DeFi trading stack. Its Pathfinder algorithm's ability to route across 300+ liquidity sources delivers consistently superior price execution, while features like Fusion+ gasless swaps and the comprehensive Portfolio API provide developers with powerful tools for building next-generation trading applications.

The **TypeScript SDK** (`1inch/1inch-sdk`, 400 stars, MIT license) offers a production-ready, type-safe interface that abstracts away the complexity of multi-source routing while preserving fine-grained control over execution parameters. Whether you're executing a simple token swap, building a sophisticated trading dashboard, or integrating limit orders into your DeFi protocol, 1inch provides the infrastructure layer you need.

**Getting started is straightforward:**
1. Obtain an API key from [1inch Developer Portal](https://portal.1inch.io)
2. Install the SDK: `npm install @1inch/sdk`
3. Follow the code examples in this guide for your specific use case
4. Join the [1inch Discord](https://discord.gg/1inch) for developer support

For traders seeking a reliable centralized exchange companion to their DeFi activities, [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) offers deep liquidity and competitive fees, while [OKX](https://www.promoohubly.com/join/12190433) provides advanced trading tools and multi-chain support. The combination of centralized exchange efficiency with 1inch's decentralized aggregation creates a complete trading toolkit for 2026's multi-chain landscape.

Start building with 1inch today and give your users the best price execution DeFi has to offer.
