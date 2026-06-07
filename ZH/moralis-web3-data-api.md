---
title: 'Moralis 2026: 为100K+ DApp提供实时链上数据的Web3数据API — 设置指南'
description: '2026年Moralis Web3数据API完整指南。学习如何使用JavaScript、Python和Unity SDK跨10多条链获取实时区块链数据、NFT元数据、代币价格和钱包余额。'
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
github_repo: 'https://github.com/MoralisWeb3/Moralis-JS'
stars: 3200
maintainer: 'MoralisWeb3'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: ['Moralis']
aliases:
- /zh/posts/moralis-web3-data-api/
---

{{</* resource-info */>}}

区块链数据是每个去中心化应用的生命线。无论您是在构建DeFi仪表板、NFT市场、钱包追踪器还是交易机器人，您的应用都需要快速、可靠地访问链上数据。在2026年，Moralis仍然是最广泛采用的Web3数据API，为超过100,000个去中心化应用提供跨10多条EVM兼容链的实时区块链数据。

Moralis消除了运行自有区块链节点、索引层和数据管道的复杂性。开发者无需花费数周时间设置基础设施，而是可以在几分钟内开始获取钱包余额、代币价格、NFT元数据和交易历史。本指南提供了从初始设置到高级集成的Moralis全面演练，帮助您充分发挥其潜力。

> **联盟营销披露：** 本文包含[Binance](https://www.bsmkweb.cc/register?ref=DIBI8)的联盟链接。当您通过我们的链接注册时，我们可能会赚取佣金，而不会给您带来额外费用。

---

## Moralis是什么

Moralis是一个统一的Web3数据API和开发平台，为开发者提供对区块链数据的实时访问。自2021年成立以来，它已经发展成为超过100,000个DApp的基础设施支柱，从小型独立项目到企业级DeFi协议。Moralis通过干净、文档完善的REST API和SDK来处理索引、规范化和提供区块链数据的繁重工作。

该平台支持以太坊、Polygon、BNB Chain、Arbitrum、Optimism、Avalanche、Base以及其他几条EVM兼容网络。它还提供对Solana等非EVM链的支持。核心价值主张很简单：无需操作复杂的节点基础设施和构建自定义索引器，开发者只需调用Moralis API端点即可接收结构化的、人类可读的数据。

Moralis提供几个关键的API组：

- **Web3 API** — 通用区块链查询、区块数据和交易详情
- **Token API** — 代币余额、转账、价格数据和元数据
- **NFT API** — NFT所有权、元数据、转账和收藏统计
- **Wallet API** — 投资组合追踪、净值计算和交易历史
- **Streams API** — 链上事件的实时Webhook
- **Auth API** — Web3认证和用户会话管理

---

## 为什么2026年选择Moralis

Web3基础设施格局已经显著成熟，但Moralis仍然保持领先，有以下几个令人信服的原因。

**统一的API接口。** 无需为不同类型的数据而管理多个提供商，Moralis提供单个API密钥，即可解锁代币数据、NFT信息、钱包投资组合和实时事件流。这降低了集成复杂性，使您的代码库更加简洁。

**跨链兼容性。** Moralis开箱即用地支持10多条EVM链。无论您定位哪条链，查询都使用相同的端点结构。从以太坊切换到Polygon只需要更改一个链参数，无需重写集成逻辑。

**实时数据交付。** Streams API在链上事件确认后几秒钟内即可发送Webhook。对于交易应用、投资组合追踪器和警报系统，这种延迟优势至关重要。

**企业级可靠性。** Moralis每月处理数十亿次API请求，保证99.9%的正常运行时间。其基础设施可自动扩展，以应对NFT空投、代币发布和市场波动期间的流量激增。

**丰富的SDK生态系统。** 适用于JavaScript、Python和Unity的官方SDK允许您在首选环境中集成Moralis。React hooks和Next.js绑定进一步加速前端开发。

---

## 设置您的Moralis账户

在编写任何代码之前，您需要一个Moralis账户和API密钥。

**第一步：** 访问admin.moralis.io的Moralis管理控制台并注册一个新账户。您可以使用电子邮件地址或连接Web3钱包。

**第二步：** 登录后，从仪表板创建一个新项目。给它一个描述性名称，如`defi-dashboard`或`nft-tracker`。

**第三步：** 导航到API密钥部分并复制您的默认API密钥。Moralis采用分层定价模型。免费层每月包含大量API调用，足以满足开发和小型生产应用的需求。

**第四步：** 使用环境变量保护您的API密钥。切勿将API密钥直接提交到源代码仓库。

```bash
# .env
MORALIS_API_KEY=your_api_key_here
```

使用`dotenv`或运行时内置的环境变量支持在您的应用中加载此变量。

```javascript
// server.js
require('dotenv').config();
const apiKey = process.env.MORALIS_API_KEY;
if (!apiKey) {
  throw new Error('MORALIS_API_KEY is not defined');
}
```

---

## 安装Moralis SDK

Moralis为多种编程语言和框架提供官方SDK。选择与您的技术栈匹配的版本。

### JavaScript / Node.js

```bash
npm install moralis
```

```javascript
// 在Node.js应用中初始化Moralis
const Moralis = require('moralis').default;

await Moralis.start({
  apiKey: process.env.MORALIS_API_KEY,
});

console.log('Moralis SDK initialized successfully');
```

### Python

```bash
pip install moralis
```

```python
# 在Python中初始化Moralis
from moralis import evm_api
import os

api_key = os.environ.get('MORALIS_API_KEY')
if not api_key:
    raise ValueError("MORALIS_API_KEY environment variable is required")

print("Moralis Python SDK ready")
```

### Unity

对于Unity开发者，Moralis通过Unity包管理器提供专用SDK包。从官方Moralis GitHub仓库导入包，然后在游戏启动脚本中初始化。

```csharp
// Unity C# 初始化
using MoralisUnity;
using MoralisUnity.Web3Api.Client;

async void Start()
{
    MoralisClient moralis = new MoralisClient(
        hostUrl: "https://deep-index.moralis.io/api/v2",
        applicationId: "your_app_id"
    );
    await moralis.StartAsync();
    Debug.Log("Moralis Unity SDK initialized");
}
```

---

## 使用Token API获取代币数据

Token API是Moralis中最常用的组件之一。它提供查询ERC-20代币余额、转账历史、价格数据和元数据的端点。

### 获取代币价格

获取任何代币的当前价格非常简单。Moralis汇总了来自多个去中心化交易所和流动性池的价格数据。

```javascript
const priceResponse = await Moralis.EvmApi.token.getTokenPrice({
  address: '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48',
  chain: '0x1', // 以太坊主网
});

console.log('Token Price:', priceResponse.result.usdPrice);
console.log('Price Change 24h:', priceResponse.result.usdPricePercentChange24h);
```

### 获取钱包代币余额

通过单个API调用检索特定钱包地址持有的所有ERC-20代币。

```javascript
const balances = await Moralis.EvmApi.token.getWalletTokenBalances({
  address: '0x1234567890123456789012345678901234567890',
  chain: '0x1',
});

balances.result.forEach((token) => {
  console.log(`${token.name}: ${token.balance} (${token.symbol})`);
});
```

### 获取代币转账记录

追踪钱包或特定代币合约的转入和转出记录。

```javascript
const transfers = await Moralis.EvmApi.token.getWalletTokenTransfers({
  address: '0x1234567890123456789012345678901234567890',
  chain: '0x1',
  limit: 10,
});

transfers.result.forEach((tx) => {
  console.log(`From: ${tx.fromAddress} To: ${tx.toAddress} Amount: ${tx.value}`);
});
```

### 获取代币元数据

检索任何ERC-20代币的详细元数据，包括名称、符号、小数位数和Logo。

```javascript
const metadata = await Moralis.EvmApi.token.getTokenMetadata({
  addresses: [
    '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48',
    '0x6B175474E89094C44Da98b954EedeAC495271d0F',
  ],
  chain: '0x1',
});

metadata.result.forEach((token) => {
  console.log(`${token.name} (${token.symbol}) - ${token.decimals} decimals`);
});
```

---

## 使用NFT API

NFT API提供对查询NFT所有权、元数据、转账和收藏级统计的全面支持。它同时支持ERC-721和ERC-1155标准。

### 获取钱包拥有的NFT

```javascript
const nfts = await Moralis.EvmApi.nft.getWalletNFTs({
  address: '0x1234567890123456789012345678901234567890',
  chain: '0x1',
  limit: 20,
});

nfts.result.forEach((nft) => {
  console.log(`Collection: ${nft.name} Token ID: ${nft.tokenId}`);
  console.log(`Metadata: ${nft.metadata}`);
});
```

### 通过代币ID获取NFT元数据

```javascript
const nftMetadata = await Moralis.EvmApi.nft.getNFTMetadata({
  address: '0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D',
  tokenId: '1',
  chain: '0x1',
});

console.log('Name:', nftMetadata.result.name);
console.log('Image:', nftMetadata.result.metadata?.image);
console.log('Attributes:', nftMetadata.result.metadata?.attributes);
```

### 获取收藏的NFT转账记录

```javascript
const transfers = await Moralis.EvmApi.nft.getNFTContractTransfers({
  address: '0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D',
  chain: '0x1',
  limit: 10,
});

transfers.result.forEach((tx) => {
  console.log(`Token ${tx.tokenId}: ${tx.fromAddress} -> ${tx.toAddress}`);
});
```

### Python示例：获取地板价

```python
from moralis import evm_api

params = {
    "address": "0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D",
    "chain": "eth"
}

result = evm_api.nft.get_nft_floor_price(
    api_key=api_key,
    params=params,
)

print(f"Floor Price: {result['floor_price']} ETH")
```

---

## 使用Streams API实现实时Webhook

Moralis的突出功能之一是Streams API，它支持链上事件的实时Webhook。您的应用无需轮询更改，而是在特定事件发生时接收推送通知。

### 设置Stream

```javascript
const { EvmChain } = require('@moralisweb3/common-evm-utils');

const stream = {
  chains: [EvmChain.ETHEREUM, EvmChain.POLYGON],
  description: 'Track USDC transfers',
  tag: 'usdc_transfers',
  includeNativeTxs: false,
  webhookUrl: 'https://your-app.com/webhooks/moralis',
  includeContractLogs: true,
  abi: [
    {
      anonymous: false,
      inputs: [
        { indexed: true, name: 'from', type: 'address' },
        { indexed: true, name: 'to', type: 'address' },
        { indexed: false, name: 'value', type: 'uint256' },
      ],
      name: 'Transfer',
      type: 'event',
    },
  ],
  topic0: ['Transfer(address,address,uint256)'],
  filter: {
    'address': '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48',
  },
  includeInternalTxs: false,
};

const newStream = await Moralis.Streams.add(stream);
console.log('Stream created:', newStream.result.id);
```

### 处理Webhook负载

您的Webhook端点在监控事件发生时接收结构化的JSON负载。

```javascript
// Express webhook处理程序
const express = require('express');
const crypto = require('crypto');
const app = express();
app.use(express.json());

app.post('/webhooks/moralis', (req, res) => {
  // 验证webhook签名以确保安全
  const signature = req.headers['x-signature'];
  const body = JSON.stringify(req.body);
  const hash = crypto
    .createHmac('sha256', process.env.MORALIS_STREAM_SECRET)
    .update(body)
    .digest('hex');

  if (signature !== hash) {
    return res.status(401).send('Unauthorized');
  }

  const events = req.body.confirmed || req.body.unconfirmed;
  events.forEach((event) => {
    console.log('Transfer detected:', {
      from: event.from,
      to: event.to,
      value: event.value,
      transactionHash: event.transactionHash,
    });
  });

  res.status(200).send('OK');
});

app.listen(3000, () => console.log('Webhook server running on port 3000'));
```

---

## 使用Auth API进行认证

Moralis通过提供完整的Auth API简化了Web3认证，该API处理消息签名、会话管理和用户资料链接。

### 请求消息签名

```javascript
const { EvmChain } = require('@moralisweb3/common-evm-utils');

const authMessage = await Moralis.Auth.requestMessage({
  chain: EvmChain.ETHEREUM,
  address: '0x1234567890123456789012345678901234567890',
  network: 'evm',
  domain: 'your-app.com',
  statement: 'Sign this message to authenticate with Your App',
  uri: 'https://your-app.com/login',
  expirationTime: new Date(Date.now() + 86400000), // 24小时
  timeout: 60,
});

console.log('Sign-in message:', authMessage.result.message);
```

### 验证已签名消息

```javascript
const authResult = await Moralis.Auth.verify({
  network: 'evm',
  message: authMessage.result.message,
  signature: '0x...signed_message...',
});

console.log('Authenticated user:', authResult.result.profileId);
console.log('Address:', authResult.result.address);
```

---

## 跨链开发模式

Moralis的一个强大方面是能够编写跨链兼容的代码。无论您定位哪个区块链，API结构都保持一致。

### 多链投资组合追踪器

```javascript
const chains = ['0x1', '0x89', '0x38', '0xa4b1']; // ETH, MATIC, BNB, ARB
const address = '0x1234567890123456789012345678901234567890';

const portfolio = {};

for (const chain of chains) {
  const balances = await Moralis.EvmApi.token.getWalletTokenBalances({
    address,
    chain,
  });
  
  const chainName = chain === '0x1' ? 'Ethereum'
    : chain === '0x89' ? 'Polygon'
    : chain === '0x38' ? 'BNB Chain'
    : 'Arbitrum';
  
  portfolio[chainName] = balances.result.map((t) => ({
    symbol: t.symbol,
    balance: t.balance,
    usdValue: t.usdPrice ? parseFloat(t.balance) * t.usdPrice : null,
  }));
}

console.log('Multi-chain portfolio:', JSON.stringify(portfolio, null, 2));
```

---

## 高级查询模式与优化

使用Moralis构建生产应用时，几种高级模式可帮助您优化性能并减少API使用。

### 分页处理

大多数Moralis列表端点支持基于游标的分页，以实现高效的数据检索。

```javascript
let cursor = null;
const allTransfers = [];

do {
  const response = await Moralis.EvmApi.token.getWalletTokenTransfers({
    address: '0x1234567890123456789012345678901234567890',
    chain: '0x1',
    limit: 100,
    cursor,
  });

  allTransfers.push(...response.result);
  cursor = response.pagination.cursor;
} while (cursor);

console.log(`Retrieved ${allTransfers.length} transfers`);
```

### 速率限制管理

```javascript
const axios = require('axios');
const rateLimit = require('axios-rate-limit');

const http = rateLimit(axios.create(), {
  maxRequests: 25,
  perMilliseconds: 1000,
});

async function safeApiCall(apiFunction) {
  try {
    return await apiFunction();
  } catch (error) {
    if (error.status === 429) {
      // 速率受限 - 实现指数退避
      await new Promise((r) => setTimeout(r, 2000));
      return safeApiCall(apiFunction);
    }
    throw error;
  }
}
```

### 使用Redis的缓存层

对于高流量应用，实施缓存层以减少冗余API调用。

```javascript
const Redis = require('ioredis');
const redis = new Redis();

async function getCachedTokenPrice(tokenAddress, chain) {
  const cacheKey = `price:${chain}:${tokenAddress}`;
  const cached = await redis.get(cacheKey);
  
  if (cached) {
    return JSON.parse(cached);
  }

  const price = await Moralis.EvmApi.token.getTokenPrice({
    address: tokenAddress,
    chain,
  });

  // 缓存60秒
  await redis.setex(cacheKey, 60, JSON.stringify(price.result));
  return price.result;
}
```

---

## 常见问题解答

### Moralis支持哪些链

Moralis支持以太坊、Polygon、BNB Chain、Arbitrum、Optimism、Avalanche、Base、Fantom、Cronos、Gnosis Chain以及几条测试网。它还提供Solana API支持，用于Solana网络上的NFT和代币数据。

### 是否有免费层可用

是的，Moralis提供免费层，每月包含大量API调用，通常足以满足开发环境和小型生产应用的需求。随着使用量的增长，您可以升级到提供更高速率限制和优先支持的付费层。

### Moralis与运行自己的节点相比如何

运行自己的节点需要大量的基础设施投资、持续维护以及索引和规范化数据的工程时间。Moralis通过简单的API调用提供索引的结构化数据，消除了这种运营负担。权衡在于Moralis是一个托管服务，大规模使用时会产生相关成本，而自托管节点提供完全的主权。

### 我可以在无服务器函数中使用Moralis吗

绝对可以。Moralis是一个无状态API服务，与Vercel Functions、AWS Lambda和Cloudflare Workers等无服务器架构完美配合。在您的处理函数内初始化SDK并直接进行API调用。没有持久连接或服务器端状态要求。

### Streams API的Webhook交付有多安全

Moralis使用密钥对所有Webhook负载进行签名，您可以在服务器上验证该密钥。始终根据使用您的流密钥的请求主体的HMAC-SHA256哈希验证`x-signature`头。这可以防止攻击者向您的端点发送伪造的Webhook请求。此外，使用HTTPS端点并考虑实施幂等性检查以处理重复交付。

### 官方支持哪些编程语言

Moralis官方为JavaScript/TypeScript（Node.js和浏览器）、Python和Unity（C#）提供SDK。对于其他语言，您可以直接使用标准HTTP客户端调用REST API。该API遵循OpenAPI规范，因此您还可以为Go、Rust、Java或任何其他语言生成客户端库。

---



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 结论

Moralis已将自己确立为在EVM兼容链上构建的开发者必不可少的Web3数据基础设施。其统一的API接口涵盖了从代币余额和NFT元数据到实时事件流和Web3认证的完整区块链数据需求 spectrum。凭借适用于JavaScript、Python和Unity的官方SDK，以及慷慨的免费层，入门门槛从未如此低。

随着Web3生态系统继续在Layer 2网络和替代链上扩展，拥有可靠的数据提供商变得越来越关键。Moralis处理多链索引的复杂性，因此您可以专注于构建使您的应用脱颖而出的功能。

准备好开始构建了吗？[在Binance注册](https://www.bsmkweb.cc/register?ref=DIBI8)为您的Web3开发钱包充值，并获取测试和部署所需的代币。
