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
- /zh/posts/1inch-dex-aggregator-routing/
---

{{</* resource-info */>}}

去中心化金融已经远远超越了实验性阶段。进入 2026 年，交易者要求的不仅仅是流动性访问，而是能够最大化每一笔交易每一个基点的智能路由。**1inch** 站在这一演进的前沿，作为生态系统中最为精密的 DEX 聚合器运行。凭借其专有的 **Pathfinder 算法**，1inch 在横跨 10 多个区块链网络的 **300 多个流动性来源**之间路由交易，确保以最优的执行价格同时最小化滑点和 Gas 成本。

从一个简单的兑换优化器起步，1inch 已发展成为一套全面的 DeFi 基础设施套件。1inch Network 现在包含用于无 Gas 兑换的 **Fusion+**、高级**限价单**、强大的 **Portfolio API**，以及一个完全类型化的 **TypeScript SDK**，使开发者能够直接在他们的应用中嵌入机构级交易功能。无论你是构建零售交易界面、收益优化金库，还是算法套利机器人，理解 1inch 的路由机制对于在当今碎片化的流动性环境中最大化交易效率都至关重要。

本指南深入剖析 1inch 的聚合架构，提供使用官方 SDK 的实用代码示例、集成模式和生产部署策略。

## 1. 理解 DEX 聚合与 1inch 的角色

DEX 聚合器解决了 DeFi 中最持久的挑战之一：**流动性碎片化**。随着数百个去中心化交易所在多个链上运行 —— Uniswap、Curve、Balancer、PancakeSwap、SushiSwap 以及无数其他平台 —— 流动性存在于孤立的池中。某个代币交易对可能在一个 DEX 上拥有深厚的流动性池，而在另一个 DEX 上则池子很浅。没有聚合的情况下，交易者面临次优价格、过高的滑点和错失的机会。

1inch 通过在单个 DEX 之上充当**元层**来解决这一问题。1inch 的 Pathfinder 算法不是在一个交易所上执行兑换，而是同时检查所有可用的流动性来源，构建复杂的跨多个协议甚至多个区块链的多跳路由。2026 年，这一网络已覆盖：

| 链 | 主要 DEX 来源 | 近似流动性 |
|-------|-------------------|----------------------|
| Ethereum | Uniswap v3, Curve, Balancer, SushiSwap | $2.8B+ |
| Arbitrum | Camelot, Uniswap v3, SushiSwap | $890M+ |
| Optimism | Velodrome, Uniswap v3, Curve | $420M+ |
| Polygon | QuickSwap, Uniswap v3, Curve | $310M+ |
| BSC | PancakeSwap, BiSwap, Uniswap v3 | $1.2B+ |
| Base | Aerodrome, Uniswap v3, AlienBase | $650M+ |

其结果是价格执行表现始终优于单一 DEX 交易 **3-15%**，对于大额订单和冷门代币对的改善尤为显著。

## 2. Pathfinder 路由算法的工作原理

1inch 聚合能力的核心是 **Pathfinder** —— 一个专有的路由引擎，为每一次兑换实时求解优化问题。理解其机制有助于开发者就交易参数做出明智决策。

### 2.1 优化问题

当你请求将代币 A 兑换为代币 B 的报价时，Pathfinder 必须求解：*给定 N 个具有不同深度、费用和价格的流动性来源，什么跳跃和分割序列能最小化订单的总成交成本？*

这在计算上非常密集，因为：
- 必须查询 **300+ 来源**的当前储备和费用
- **多跳路径**（A → C → D → B）通常比直接交易对产生更好的价格
- **分割路由** —— 将一笔订单分摊到多条路径上 —— 可减少滑点
- Gas 成本因路由复杂度而异；更多跳跃意味着更高的执行成本
- **跨链桥**可能提供替代执行场所

### 2.2 发现和组装阶段

Pathfinder 分为两个不同的阶段运行：

**第一阶段 — 路由发现**：该算法探索源代币和目标代币之间所有可能的路径，深度可配置（通常为 4-6 跳）。它使用改进的 Bellman-Ford 方法在价格空间中发现负循环，有效找到表明价格低效性的套利相邻路径。

**第二阶段 — 路由组装**：发现的路径使用多目标函数进行评分，该函数平衡：
- 预期输出金额（主要目标）
- Gas 成本估算（次要）
- 基于历史成交率的成功率
- MEV 保护需求

```typescript
// 通过 1inch API 请求报价 — Pathfinder 在内部处理路由
import { OneInchApi } from '@1inch/sdk';

const oneInch = new OneInchApi({
  apiKey: process.env.ONEINCH_API_KEY,
  networkId: 1, // 以太坊主网
});

// 获取将 1 ETH 兑换为 USDC 的最佳路由
const quote = await oneInch.getQuote({
  src: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH
  dst: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // USDC
  amount: '1000000000000000000', // 1 ETH（wei 单位）
  includeTokensInfo: true,
  includeProtocols: true,
  includeGas: true,
});

console.log('预期输出:', quote.dstAmount);
console.log('路由路径:', quote.protocols); // 显示完整路由路径
console.log('预估 Gas:', quote.tx.gas);
```

`protocols` 字段揭示了 Pathfinder 选择的实际路由 —— 例如，通过 Uniswap v3 分割 60% 和通过 Curve 分割 40%，或者通过 WETH → DAI → USDC 等中间代币路由以获得更好的价格。

## 3. 设置 1inch TypeScript SDK

官方 1inch SDK（GitHub 上的 `1inch/1inch-sdk`，400+ stars，MIT 许可证）为所有 1inch API 提供类型安全、基于 Promise 的接口。它处理请求签名、错误处理和响应解析。

### 3.1 安装和配置

```bash
# 通过 npm 安装
npm install @1inch/sdk

# 或使用 yarn
yarn add @1inch/sdk

# 安装对等依赖
npm install ethers axios dotenv
```

创建 `.env` 文件存放你的 API 凭证：

```bash
ONEINCH_API_KEY=your_api_key_here
PRIVATE_KEY=your_wallet_private_key
RPC_URL=https://mainnet.infura.io/v3/your_project_id
```

使用你的配置初始化 SDK：

```typescript
import { OneInchSdk } from '@1inch/sdk';
import { ethers } from 'ethers';
import * as dotenv from 'dotenv';

dotenv.config();

// 初始化 provider 和钱包
const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY!, provider);

// 初始化 1inch SDK
const sdk = new OneInchSdk({
  apiKey: process.env.ONEINCH_API_KEY!,
  networkId: 1, // 以太坊主网
  walletAddress: wallet.address,
});

console.log('1inch SDK 已为', wallet.address, '初始化');
```

### 3.2 SDK 架构概览

SDK 按命名空间组织，镜像 1inch 的 API 结构：

```typescript
// SDK 模块结构
import {
  SwapApi,        // 代币兑换和报价
  LimitOrderApi,  // 限价单创建和管理
  OrderbookApi,   // 订单簿操作
  GasPriceApi,    // Gas 价格估算
  SpotPriceApi,   // 代币价格喂价
  BalanceApi,     // 投资组合和余额追踪
  HistoryApi,     // 交易历史
} from '@1inch/sdk';

// 每个命名空间提供带类型的方法
const swapApi = sdk.swap;
const limitApi = sdk.limitOrder;
const balanceApi = sdk.balance;
```

## 4. 以最优路由执行兑换

1inch 的主要用例是以尽可能好的价格执行代币兑换。SDK 抽象了路由发现的复杂性，同时让开发者对参数有细粒度的控制。

### 4.1 基础兑换执行

```typescript
import { OneInchSdk } from '@1inch/sdk';

async function executeSwap() {
  const sdk = new OneInchSdk({
    apiKey: process.env.ONEINCH_API_KEY!,
    networkId: 1,
  });

  // 定义兑换参数
  const swapParams = {
    src: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // 原生 ETH
    dst: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // USDC
    amount: '500000000000000000', // 0.5 ETH
    from: wallet.address,
    slippage: 1, // 最大 1% 滑点
    disableEstimate: false,
    allowPartialFill: false,
    includeTokensInfo: true,
    includeProtocols: true,
    compatibility: true,
  };

  // 第一步：获取报价（模拟）
  const quote = await sdk.swap.getQuote(swapParams);
  console.log('报价已接收:');
  console.log('- 输入:', quote.srcAmount);
  console.log('- 预期输出:', quote.dstAmount);
  console.log('- 价格路由:', quote.protocols);

  // 第二步：构建交易
  const tx = await sdk.swap.buildTx({
    ...swapParams,
    receiver: wallet.address, // USDC 将发送至此处
  });

  // 第三步：签名并发送交易
  const sentTx = await wallet.sendTransaction({
    to: tx.to,
    data: tx.data,
    value: tx.value,
    gasLimit: tx.gas,
    maxFeePerGas: tx.maxFeePerGas,
    maxPriorityFeePerGas: tx.maxPriorityFeePerGas,
  });

  console.log('交易已发送:', sentTx.hash);
  const receipt = await sentTx.wait();
  console.log('交易已在区块确认:', receipt?.blockNumber);
}

executeSwap().catch(console.error);
```

### 4.2 处理滑点和部分成交

在波动市场中，滑点容忍度至关重要。SDK 提供了细粒度的控制：

```typescript
// 大额交易的保守设置
const largeTradeParams = {
  src: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE',
  dst: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0',
  amount: '50000000000000000000', // 50 ETH — 大额订单！
  from: wallet.address,
  slippage: 0.5, // 严格的 0.5% 滑点以确保精确
  allowPartialFill: false, // 全有或全无执行
  // 启用 MEV 保护（大额交易推荐）
  referrer: 'your_app_name',
  fee: 0, // 无额外费用
};

// 对于较小的、更紧急的交易，可以放宽滑点
const quickTradeParams = {
  ...largeTradeParams,
  amount: '1000000000000000000', // 1 ETH
  slippage: 3, // 可接受 3% 滑点以换取速度
  allowPartialFill: true, // 接受部分执行
  // 优先速度而非最优价格
  protocols: 'UNISWAP_V3,SUSHI,CURVE', // 白名单指定协议
};
```

### 4.3 通过 Bridge API 进行跨链兑换

1inch 的聚合超越单一链。Bridge API 找到跨链最优路由：

```typescript
// 从以太坊 USDC 桥接到 Arbitrum ETH
const bridgeQuote = await sdk.crossChain.getQuote({
  srcChain: 1,        // 以太坊
  dstChain: 42161,    // Arbitrum
  srcToken: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // 以太坊上的 USDC
  dstToken: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // Arbitrum 上的 ETH
  amount: '1000000000', // 1000 USDC（6 位小数）
  walletAddress: wallet.address,
});

console.log('桥接路由:', bridgeQuote.selectedRoute);
console.log('预估时间:', bridgeQuote.estimatedTime, '秒');
console.log('目标金额:', bridgeQuote.dstTokenAmount);

// 执行桥接交易
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

## 5. Fusion+：无 Gas 兑换执行

1inch 最具创新性的功能之一是 **Fusion+** —— 一种无 Gas 兑换机制，利用荷兰拍卖机制和专业做市商（解析器）代表用户执行交易，用户无需预先支付 Gas。

### 5.1 Fusion+ 的工作原理

传统兑换需要用户以原生代币支付 Gas 费用（以太坊上的 ETH）。Fusion+ 消除了这一障碍：

1. **用户签署意图**以最低可接受汇率进行兑换
2. **解析器在荷兰拍卖中竞争**以填充订单
3. **获胜的解析器**执行交易，代表用户支付 Gas
4. **解析器的费用**嵌入在兑换汇率中，对用户不可见

```typescript
// 执行 Fusion+ 无 Gas 兑换
import { FusionOrder } from '@1inch/sdk/fusion';

async function executeFusionSwap() {
  const fusionSdk = sdk.fusion;

  // 创建 Fusion+ 订单（用户无需 Gas！）
  const fusionOrder = await fusionSdk.createOrder({
    srcToken: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH
    dstToken: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // USDC
    amount: '1000000000000000000', // 1 ETH
    walletAddress: wallet.address,
    // Fusion+ 参数
    preset: 'fast', // 'fast', 'medium', 或 'slow'
    // 你愿意接受的最低回报（fusion 会找到最优实际汇率）
    minReturn: '1800000000', // 最少 1800 USDC
    // 拍卖持续时间 — 解析器竞争的时间
    auctionDuration: 180, // 180 秒
  });

  console.log('Fusion 订单已创建:', fusionOrder.orderHash);

  // 用你的钱包签名订单（无需 Gas！）
  const signature = await wallet.signTypedData(
    fusionOrder.domain,
    fusionOrder.types,
    fusionOrder.message
  );

  // 将签名订单提交到 1inch 中继器
  const submitted = await fusionSdk.submitOrder({
    order: fusionOrder,
    signature,
    from: wallet.address,
  });

  console.log('Fusion 订单已提交:', submitted.orderHash);
  console.log('追踪地址: https://1inch.io/fusion-order/' + submitted.orderHash);

  // 轮询执行状态
  const checkStatus = async () => {
    const status = await fusionSdk.getOrderStatus(submitted.orderHash);
    console.log('订单状态:', status.status); // 'pending', 'filled', 'expired'
    if (status.status === 'filled') {
      console.log('交易哈希:', status.txHash);
      console.log('实际输出:', status.dstTokenAmount);
      return true;
    }
    return false;
  };

  // 每 10 秒轮询一次
  const interval = setInterval(async () => {
    const done = await checkStatus();
    if (done) clearInterval(interval);
  }, 10000);
}
```

### 5.2 Fusion+ 预设说明

| 预设 | 拍卖持续时间 | 优先级 | 最适合 |
|--------|-----------------|----------|----------|
| `fast` | 60 秒 | 高 | 时间敏感的兑换，解析器费用较高 |
| `medium` | 180 秒 | 中 | 速度与成本的平衡 |
| `slow` | 600 秒 | 低 | 最大化节省，耐心执行 |

```typescript
// 监控 Fusion 订单生命周期
const orderEvents = fusionSdk.subscribeToOrderEvents(fusionOrder.orderHash);

orderEvents.on('created', (data) => {
  console.log('订单已广播给解析器');
});

orderEvents.on('auctionStarted', (data) => {
  console.log('荷兰拍卖进行中，当前汇率:', data.currentRate);
});

orderEvents.on('filled', (data) => {
  console.log('订单已被解析器填充:', data.resolver);
  console.log('最终输出金额:', data.dstAmount);
  console.log('你支付了零 Gas！');
});

orderEvents.on('expired', () => {
  console.log('订单过期未成交 — 使用更好的 minReturn 重试');
});
```

## 6. 限价单和程序化交易

除了市场兑换外，1inch 还提供了一个强大的**限价单协议**，允许交易者指定精确的成交价格 —— 类似于中心化交易所，但完全自托管。

### 6.1 创建限价单

```typescript
// 创建限价单以特定价格用 ETH 买入 DAI
const limitOrder = await sdk.limitOrder.createOrder({
  makerAsset: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH（你卖出的）
  takerAsset: '0x6B175474E89094C44Da98b954EedeAC495271d0F', // DAI（你买入的）
  makingAmount: '500000000000000000', // 0.5 ETH
  takingAmount: '900000000000000000000', // 期望最少 900 DAI
  // 订单 24 小时后过期
  expiration: Math.floor(Date.now() / 1000) + 86400,
  // 允许部分成交（类似 DCA 的行为）
  partializable: true,
  // 接收购买代币的地址
  receiver: wallet.address,
});

// 签名限价单
const limitSignature = await wallet.signTypedData(
  limitOrder.domain,
  limitOrder.types,
  limitOrder.message
);

// 提交到 1inch 订单簿
const placedOrder = await sdk.limitOrder.submitOrder({
  order: limitOrder,
  signature: limitSignature,
});

console.log('限价单已提交:', placedOrder.orderHash);
console.log('预期成交价格:', 900 / 0.5, '每 ETH 的 DAI');
```

### 6.2 监听订单成交

```typescript
// 设置 webhook 或轮询监听器以监听订单成交
import { LimitOrderWatcher } from '@1inch/sdk/watcher';

const watcher = new LimitOrderWatcher({
  apiKey: process.env.ONEINCH_API_KEY!,
  networkId: 1,
  pollInterval: 5000, // 每 5 秒检查一次
});

// 监听你的特定订单
watcher.watchOrder(placedOrder.orderHash, (event) => {
  if (event.type === 'filled') {
    console.log('订单完全成交！');
    console.log('交易:', event.txHash);
    console.log('成交金额:', event.filledAmount);
  } else if (event.type === 'partiallyFilled') {
    console.log('部分成交:', event.filledRatio, '%');
    console.log('剩余:', event.remainingAmount);
  } else if (event.type === 'expired') {
    console.log('订单过期 — 如果仍有意下单请重新提交');
  }
});

// 开始监听
watcher.start();
```

## 7. Portfolio API 和余额追踪

**Portfolio API** 提供跨所有支持链的代币余额、交易历史和盈亏的全面追踪 —— 对于构建交易仪表板和税务报告工具至关重要。

### 7.1 获取多链余额

```typescript
// 获取跨支持链的所有代币余额
const portfolio = await sdk.balance.getBalances({
  walletAddress: '0xYourWalletAddress',
  chainIds: [1, 42161, 137, 10, 8453], // 多链查询
  // 包含每个代币的元数据
  includeMetadata: true,
  // 包含当前价格的 USD 价值
  includeUsdValues: true,
});

// 处理和显示余额
for (const chainBalance of portfolio.balances) {
  console.log(`\n=== 链 ID: ${chainBalance.chainId} ===`);
  for (const token of chainBalance.tokens) {
    console.log(`${token.symbol}: ${token.balance} ($${token.usdValue})`);
  }
}

// 跨所有链的投资组合总价值
const totalValue = portfolio.balances.reduce((sum, chain) => {
  return sum + chain.tokens.reduce((s, t) => s + parseFloat(t.usdValue || '0'), 0);
}, 0);

console.log(`\n投资组合总价值: $${totalValue.toFixed(2)}`);
```

### 7.2 交易历史和盈亏分析

```typescript
// 获取完整的交易历史
const history = await sdk.history.getTransactions({
  walletAddress: wallet.address,
  chainIds: [1, 42161], // 以太坊和 Arbitrum
  limit: 100,
  offset: 0,
  // 按交易类型筛选
  types: ['swap', 'approval', 'limitOrder'],
});

// 分析兑换表现
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

// 计算累计交易量
const totalVolume = swaps.reduce((sum, tx) => {
  return sum + parseFloat(tx.srcUsdValue || '0');
}, 0);
console.log(`总兑换交易量: $${totalVolume.toFixed(2)}`);
```

### 7.3 构建实时投资组合仪表板

```typescript
// 基于 WebSocket 的实时投资组合更新
import { PortfolioWebSocket } from '@1inch/sdk/websocket';

const ws = new PortfolioWebSocket({
  apiKey: process.env.ONEINCH_API_KEY!,
  walletAddress: wallet.address,
});

ws.on('balanceUpdate', (update) => {
  console.log(`余额更新: ${update.tokenSymbol} = ${update.newBalance}`);
  console.log(`USD 价值变化: $${update.usdValueChange}`);
  // 在此处更新你的仪表板 UI
});

ws.on('newTransaction', (tx) => {
  console.log('检测到新交易:', tx.hash);
  console.log('类型:', tx.type);
  console.log('价值:', tx.usdValue);
  // 触发实时警报或 UI 更新
});

ws.connect();
```

## 8. 生产集成模式

在生产环境中部署 1inch 集成需要注意安全性、可靠性和性能。

### 8.1 错误处理和重试逻辑

```typescript
// 带重试的稳健兑换执行
async function executeSwapWithRetry(
  params: SwapParams,
  maxRetries = 3
): Promise<TransactionReceipt> {
  let lastError: Error | null = null;

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      // 每次尝试前刷新报价（价格会变化！）
      const freshQuote = await sdk.swap.getQuote(params);
      console.log(`尝试 ${attempt}: 预期输出 = ${freshQuote.dstAmount}`);

      // 检查价格是否变动过大
      if (parseFloat(freshQuote.dstAmount) < params.minExpectedOutput!) {
        throw new Error('价格超出可接受阈值');
      }

      const tx = await sdk.swap.buildTx({ ...params });
      const sentTx = await wallet.sendTransaction({
        to: tx.to,
        data: tx.data,
        value: tx.value,
        gasLimit: Math.floor(parseInt(tx.gas) * 1.2), // 20% Gas 缓冲
        maxFeePerGas: tx.maxFeePerGas,
        maxPriorityFeePerGas: tx.maxPriorityFeePerGas,
      });

      const receipt = await sentTx.wait(2); // 等待 2 个确认
      console.log('兑换已确认:', receipt?.hash);
      return receipt!;

    } catch (error) {
      lastError = error as Error;
      console.error(`尝试 ${attempt} 失败:`, error);

      // 重试前等待指数退避
      if (attempt < maxRetries) {
        const delay = Math.pow(2, attempt) * 1000;
        await new Promise(r => setTimeout(r, delay));
      }
    }
  }

  throw new Error(`兑换在 ${maxRetries} 次尝试后失败: ${lastError?.message}`);
}
```

### 8.2 速率限制和 API 密钥管理

```typescript
// 用于高频使用的速率限制 API 客户端
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

// 使用
const client = new OneInchRateLimitedClient(
  process.env.ONEINCH_API_KEY!,
  3 // 保守的每秒 3 次请求
);
```

### 8.3 安全最佳实践

```typescript
// 生产兑换的输入验证
function validateSwapParams(params: SwapParams): void {
  // 验证代币地址
  if (!ethers.isAddress(params.src) || !ethers.isAddress(params.dst)) {
    throw new Error('代币地址格式无效');
  }

  // 验证金额为正
  if (BigInt(params.amount) <= 0n) {
    throw new Error('金额必须为正数');
  }

  // 滑点合理性检查（0.1% 至 50%）
  if (params.slippage < 0.1 || params.slippage > 50) {
    throw new Error('滑点必须在 0.1% 至 50% 之间');
  }

  // 防止常见错误：代币自我兑换
  if (params.src.toLowerCase() === params.dst.toLowerCase()) {
    throw new Error('源代币和目标代币不能相同');
  }

  // 验证代币不是已知的诈骗/貔貅币（使用外部列表）
  if (isTokenBlacklisted(params.dst)) {
    throw new Error('目标代币已被拉黑');
  }
}

// 使用硬件钱包或安全密钥管理
const wallet = new ethers.Wallet(
  await getKeyFromAWSKMS(), // 切勿硬编码私钥！
  provider
);
```

## 9. 常见问题

**Q1：如果 SDK 免费且开源，1inch 如何盈利？**

1inch 通过**流动性来源费用**和可选的**协议治理费用**产生收入。当交易通过某些 DEX 路由时，1inch 可能会收到少量推荐费。对于开发者来说，SDK 和 API 免费使用，尽管高量用户可以选择**合作伙伴费用**模式，与集成应用共享收入。MIT 许可的 SDK（`1inch/1inch-sdk`，GitHub 上 400+ stars）确保完全的透明度和无需许可的集成。

**Q2：普通兑换和 Fusion+ 兑换有什么区别？**

普通兑换**立即在链上执行** —— 你支付 Gas，交易被打包出块，你收到代币。这提供了确定性但需要 ETH 支付 Gas。**Fusion+ 兑换**是**无 Gas 意图** —— 你加密签名你的兑换参数，专业解析器在荷兰拍卖中竞争填充你的订单，获胜的解析器支付 Gas。Fusion+ 非常适合没有原生 Gas 代币的用户或寻求 MEV 保护执行的用户，不过根据选择的预设可能需要 1-10 分钟。

**Q3：我可以在以太坊以外的链上使用 1inch 吗？**

当然。1inch 支持 **10 多个区块链网络**，包括 Ethereum、Arbitrum、Optimism、Polygon、BNB Chain、Base、Avalanche、Fantom、Gnosis 和 zkSync Era。SDK 初始化接受对应每条链 EIP-155 链 ID 的 `networkId` 参数。跨链兑换也通过 Bridge API 支持，允许通过最优路由在不同网络之间无缝移动资产。

**Q4：如何保护我的交易免受 MEV 攻击？**

1inch 提供多种 MEV 保护机制：(1) **Fusion+ 订单**由专业解析器填充，他们将执行内部化，使抢先交易成为不可能；(2) **Pathfinder 算法**可以在支持链上通过**私有内存池**和 **Flashbots Protect** 路由；(3) 对于大额交易，启用 `compatibility` 标志会添加额外的滑点检查；(4) 设置严格的 `slippage` 容忍度会缩小三明治攻击的利润窗口。对于高价值交易的最大保护，推荐使用 Fusion+ 的 `slow` 预设。

**Q5：1inch SDK 是否适合机构或高频交易？**

1inch SDK 设计用于**广泛的兼容性**而非超低延迟 HFT。对于机构用例，请考虑：(1) 使用专用速率限制的**直接 API 访问**而非公共 SDK；(2) 运行你自己的 **Pathfinder 实例**以实现亚秒级报价生成；(3) 使用 **WebSocket 价格喂价**获取实时市场数据；(4) 实施与 1inch API 服务器的**同地部署**。SDK 在投资组合管理、兑换执行和构建交易 UI 方面表现出色，但亚 100 毫秒的延迟需求可能需要自定义基础设施。

**Q6：1inch 上的限价单如何工作，它们是链上的吗？**

1inch 限价单使用**链下订单簿与链上结算**模型。订单通过 EIP-712 类型数据签名签名并广播到 1inch 的中继器网络。它们保持链下状态直到**吃单方**（做市商或套利机器人）决定填充，此时结算在链上发生。这种设计消除了下单和取消订单的 Gas 成本。订单可以是**完全可填充**或**部分可填充**（启用类似 DCA 的策略），并根据创建时设置的时间戳过期。

**Q7：我可以将 1inch 集成到我自己的交易机器人或 DeFi 协议中吗？**

可以 —— MIT 许可的 SDK 明确允许这样做。常见的集成模式包括：(1) 使用 1inch 作为兑换后端的 **DEX 界面应用**；(2) 使用 1inch 进行奖励复利和再平衡的**收益聚合器**；(3) 监控价格差异并通过 1inch 最优路由执行的**套利机器人**；(4) 提供内置兑换功能的**钱包应用**；(5) 使用 Portfolio API 的**税务报告工具**。所有集成都必须遵守 1inch 的[服务条款](https://1inch.io/terms)和 API 使用政策。



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 10. 结论和入门指南

1inch 已确立自身作为 DeFi 交易堆栈中**必不可少的基础设施**。其 Pathfinder 算法跨 300+ 流动性来源路由的能力持续提供更优的价格执行，而 Fusion+ 无 Gas 兑换和全面的 Portfolio API 等功能为开发者提供了构建下一代交易应用的强大工具。

**TypeScript SDK**（`1inch/1inch-sdk`，400 stars，MIT 许可证）提供了一个生产就绪、类型安全的接口，抽象了多来源路由的复杂性，同时保留了对执行参数的细粒度控制。无论你是执行简单的代币兑换、构建复杂的交易仪表板，还是将限价单集成到你的 DeFi 协议中，1inch 都提供了你需要的基础设施层。

**入门非常简单：**
1. 从 [1inch Developer Portal](https://portal.1inch.io) 获取 API 密钥
2. 安装 SDK：`npm install @1inch/sdk`
3. 按照本指南中的代码示例针对你的特定用例操作
4. 加入 [1inch Discord](https://discord.gg/1inch) 获取开发者支持

对于寻求与其 DeFi 活动配合使用的可靠中心化交易所的交易者，[Binance](https://www.bsmkweb.cc/register?ref=DIBI8) 提供深厚的流动性和有竞争力的费用，而 [OKX](https://www.promoohubly.com/join/12190433) 提供先进的交易工具和多链支持。中心化交易所的效率与 1inch 的去中心化聚合相结合，为 2026 年的多链格局打造了完整的交易工具包。

今天就开始使用 1inch 构建，为你的用户提供 DeFi 所能提供的最佳价格执行。
