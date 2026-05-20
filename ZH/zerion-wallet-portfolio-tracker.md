---
title: 'zerion-wallet-portfolio-tracker'
description: ''
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
github_repo: 'https://github.com/zeriontech'
stars: 200
maintainer: 'zeriontech'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: ['Zerion']
aliases:
- /zh/posts/zerion-wallet-portfolio-tracker/
---

{{</* resource-info */>}}

**日期：** 2026-05-19  
**分类：** AI 交易  
**工具：** Zerion  
**GitHub：** [zeriontech](https://github.com/zeriontech)（★ 200 · MIT 许可证）  
**联盟披露：** *本文包含联盟链接。如果您通过我们的合作伙伴链接注册，我们可能会获得佣金 —— 无需您额外付费。我们的编辑观点保持独立。*

---

## 简介：2026 年 DeFi 投资组合追踪的重要性

去中心化金融（DeFi）已从一个小众实验演变为一个数万亿美元的生态系统。随着数千个协议分布在 10 多个区块链上，管理您的加密资产变得越来越复杂。**Zerion** —— 由 [zeriontech](https://github.com/zeriontech) 开发的开源 DeFi 投资组合追踪器，已成为超过 100 万用户管理超过 **50 亿美元追踪资产** 的首选解决方案。

在 MIT 许可下发布，Zerion 提供一个统一的仪表板来追踪钱包、监控收益农场仓位、管理 NFT 收藏品和分析交易历史 —— 全部在多链环境下实时进行。无论您是 casual 投资者还是专业 DeFi 交易员，Zerion 强大的 API 和移动应用都能让投资组合管理变得无缝。

**👉 准备好开始交易了吗？[立即在 Binance 注册](https://www.bsmkweb.cc/register?ref=DIBI8)，享受市场上最低的手续费。**

---

## Zerion 是什么？了解核心架构

Zerion 是一个 **DeFi 投资组合聚合器**，旨在为用户提供其链上资产的完整视图。与传统仅支持一两个链的投资组合追踪器不同，Zerion 集成了 **以太坊、Polygon、Arbitrum、Optimism、Base、BNB Chain、Avalanche、Fantom、Gnosis** 等 —— 使其成为最全面的追踪解决方案之一。

该平台通过子图查询、直接 RPC 调用和专有索引基础设施的组合来索引链上数据。然后，这些数据被规范化并通过直观的界面展示，显示：

- 代币余额和价格变动
- 流动性池仓位
- 收益农场和质押奖励
- 带有地板价数据的 NFT 持仓
- 包含 Gas 费用的完整交易历史

---

## 快速入门指南：首次设置 Zerion

使用 Zerion 入门只需不到五分钟。按照以下步骤连接您的钱包并开始追踪您的投资组合。

### 第一步 — 访问 Zerion 网页应用

```bash
# 无需安装 — Zerion 是一个基于网页的 dApp
# 官方网址：https://app.zerion.io
# 连接钱包前务必验证 SSL 证书
```

### 第二步 — 连接您的钱包

```javascript
// Zerion 支持的钱包连接器
const supportedWallets = [
  "MetaMask",
  "WalletConnect",
  "Coinbase Wallet",
  "Rainbow",
  "Zerion Wallet",
  "Ledger（通过 WalletConnect）"
];
```

### 第三步 — 签署认证消息

```javascript
// 示例：签署认证消息（只读）
const message = "Sign this message to authenticate with Zerion\nNonce: 123456";
const signature = await signer.signMessage(message);
// 这是一个只读操作 —— 不执行任何交易
```

### 第四步 — 查看您的投资组合仪表板

```bash
# 您的投资组合仪表板显示：
# - 投资组合总价值（美元等值）
# - 24 小时变化（%）和绝对值（$）
# - 按链分配的资产
# - 按协议分配的资产
# - 最近交易
# - 收益机会
```

---

## 深入了解：多链钱包追踪

Zerion 的突出功能之一是能够同时在 **10 多个区块链** 上聚合数据。在 2026 年，随着 DeFi 活动在 Layer 1 和 Layer 2 之间越来越分散，这种多链架构变得至关重要。

### 支持的网络（2026 年）

```yaml
# Zerion 支持的网络完整列表
ethereum:
  chain_id: 1
  type: "Layer 1"
  features: ["完整支持", "NFT 追踪", "DeFi 仓位"]

polygon:
  chain_id: 137
  type: "Layer 2 / 侧链"
  features: ["完整支持", "低 Gas 追踪"]

arbitrum:
  chain_id: 42161
  type: "Optimistic Rollup"
  features: ["完整支持", "Nitro 升级兼容"]

optimism:
  chain_id: 10
  type: "Optimistic Rollup"
  features: ["完整支持", "Bedrock 升级兼容"]

base:
  chain_id: 8453
  type: "Optimistic Rollup"
  features: ["完整支持", "Coinbase 集成"]

bnb_chain:
  chain_id: 56
  type: "Layer 1"
  features: ["完整支持", "BSC DeFi 协议"]

avalanche:
  chain_id: 43114
  type: "Layer 1（子网）"
  features: ["C-Chain 支持", "DeFi 仓位"]
```

### 查看跨链余额

```javascript
// Zerion API：获取多链投资组合
const fetchPortfolio = async (address) => {
  const response = await fetch(
    `https://api.zerion.io/v1/wallets/${address}/portfolio`,
    {
      headers: {
        "Authorization": `Basic ${API_KEY}`,
        "Accept": "application/json"
      }
    }
  );
  const data = await response.json();
  return data;  // 返回：{ total_value, chain_breakdown, assets, positions }
};
```

---

## 收益追踪：监控您的 DeFi 回报

Zerion 的收益追踪模块监控您在借贷协议、流动性池和质押合约中的仓位。

### 支持的收益协议

```python
# Zerion 追踪这些协议的仓位
yield_protocols = {
    "借贷": ["Aave", "Compound", "Morpho", "Radiant"],
    "流动性池": ["Uniswap", "Curve", "Balancer", "SushiSwap"],
    "质押": ["Lido", "Rocket Pool", "Frax Ether", "Coinbase Staked ETH"],
    "金库": ["Yearn Finance", "Beefy Finance", "Convex Finance"]
}
```

### 计算净收益

```javascript
// 示例：从 Aave 仓位计算净收益
const calculateNetYield = (position) => {
  const supplyAPY = position.supply_apy;        // 例如：3.45%
  const borrowAPY = position.borrow_apy;        // 例如：5.21%
  const rewardsAPY = position.rewards_apy;      // 例如：1.82%
  
  const netYield = supplyAPY - borrowAPY + rewardsAPY;
  
  return {
    protocol: position.protocol,
    net_yield_annualized: netYield,
    daily_yield: position.balance * (netYield / 365),
    health_factor: position.health_factor
  };
};
```

---

## NFT 投资组合管理

Zerion 不仅支持同质化代币，还提供全面的 **NFT 投资组合追踪**，包含地板价数据、稀有度评分和收藏品分析。

```javascript
// Zerion API：获取 NFT 持仓
const fetchNFTs = async (address) => {
  const response = await fetch(
    `https://api.zerion.io/v1/wallets/${address}/nft-positions`,
    { headers: { "Authorization": `Basic ${API_KEY}` } }
  );
  const { data } = await response.json();
  
  return data.map(nft => ({
    collection: nft.collection.name,
    token_id: nft.nft.token_id,
    floor_price_eth: nft.collection.floor_price,
    floor_price_usd: nft.collection.floor_price * ethPrice,
    estimated_value: nft.estimated_price
  }));
};
```

---

## 交易历史与分析

Zerion 提供完整的交易历史记录，附带详细的元数据。

```javascript
// Zerion API：带过滤器的交易历史查询
const fetchTransactions = async (address, filters) => {
  const queryParams = new URLSearchParams({
    currency: "usd",
    page: filters.page || 1,
    limit: filters.limit || 50,
    chain: filters.chain || "all",
    type: filters.type || "all",
    status: filters.status || "confirmed"
  });
  
  const response = await fetch(
    `https://api.zerion.io/v1/wallets/${address}/transactions?${queryParams}`,
    { headers: { "Authorization": `Basic ${API_KEY}` } }
  );
  
  return await response.json();
};
```

---

## 开发者 API：使用 Zerion 构建应用

Zerion 提供强大的 **REST API**，开发者可用它来集成投资组合数据到自己的应用中。

```bash
# Zerion API 使用基本认证
API_KEY=$(echo -n 'YOUR_API_KEY:' | base64)

# 测试认证
curl -X GET "https://api.zerion.io/v1/wallets/0x.../portfolio" \
  -H "Authorization: Basic ${API_KEY}" \
  -H "Accept: application/json"
```

```javascript
// 获取代币实时价格
const getTokenPrice = async (tokenAddress, chain = "ethereum") => {
  const response = await fetch(
    `https://api.zerion.io/v1/fungibles/${tokenAddress}?currency=usd`,
    {
      headers: {
        "Authorization": `Basic ${btoa(API_KEY + ":")}`,
        "Accept": "application/json"
      }
    }
  );
  
  const { data } = await response.json();
  return {
    price: data.attributes.market_data.price,
    change_24h: data.attributes.market_data.change_24h,
    market_cap: data.attributes.market_data.market_cap
  };
};
```

```javascript
// 订阅实时投资组合更新
const ws = new WebSocket("wss://api.zerion.io/v1/ws");

ws.onopen = () => {
  ws.send(JSON.stringify({
    type: "authenticate",
    payload: { api_key: API_KEY }
  }));
  
  ws.send(JSON.stringify({
    type: "subscribe",
    payload: {
      scope: ["portfolio", "transactions"],
      address: "0xYourWalletAddress"
    }
  }));
};
```

---

## 移动应用：随时随地的 DeFi

Zerion 的移动应用（iOS 和 Android）将网页仪表板的全部功能带到您的口袋中。

```bash
# iOS：https://apps.apple.com/app/zerion-wallet/id1456732565
# Android：https://play.google.com/store/apps/details?id=io.zerion.android
# 功能包括：
# - 大额交易推送通知
# - WalletConnect v2 集成
# - 内置兑换功能（0x API）
# - NFT 画廊与 AR 预览
# - 追踪任何地址的观察列表
```

---

## 安全最佳实践

```bash
# 1. 始终确认网址为 https://app.zerion.io
# 2. 绝不分享您的私钥或助记词
# 3. 大额投资组合使用硬件钱包
# 4. 定期撤销不必要的代币授权
# 5. 在相关交易所账户启用 2FA
```

---

## 常见问题解答（FAQ）

**Q1：Zerion 是免费的吗？**
A：是的，Zerion 的个人投资组合追踪完全免费。公司通过内置兑换功能（小额费用）、开发者高级 API 和 Zerion 钱包的内置交易功能盈利。

**Q2：Zerion 能窃取我的资金吗？**
A：不能。Zerion 是 **只读** 投资组合追踪器。它无法发起交易或转移您的资金。您只需签署认证消息，而非交易。

**Q3：Zerion 支持哪些区块链？**
A：截至 2026 年，Zerion 支持以太坊、Polygon、Arbitrum、Optimism、Base、BNB Chain、Avalanche、Fantom、Gnosis Chain、zkSync、Scroll、Linea 和 Mantle。

**Q4：Zerion 如何计算投资组合价值？**
A：Zerion 从多个去中心化交易所和预言机提供商聚合价格数据。代币价值使用实时 DEX 流动性数据计算，而 NFT 估值使用地板价和机器学习价格估算。

**Q5：我可以追踪多少个钱包？**
A：无限制。您可以通过 Zerion 的观察列表功能追踪无限数量的钱包。这对基金经理、DAO 财库和多地址用户特别有用。

**Q6：我可以用 Zerion 进行报税吗？**
A：是的，Zerion 提供 CSV 导出功能，兼容大多数加密税务软件，包括 Koinly、CoinTracker、TokenTax 和 TurboTax。

**Q7：Zerion 网页应用和 Zerion 钱包有什么区别？**
A：Zerion 网页应用是连接外部钱包的投资组合追踪器。Zerion 钱包是原生移动钱包应用，内置投资组合追踪、兑换功能和 WalletConnect 支持。

**Q8：Zerion 与 DeBank 相比如何？**
A：两者都是领先的 DeFi 投资组合追踪器。Zerion 提供更精致的用户界面、更好的移动体验和 MIT 许可证下的开源组件。许多高级用户同时使用两者互补。

---



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 结论

在多链 DeFi 的碎片化世界中，Zerion 作为最全面且用户友好的投资组合追踪解决方案脱颖而出。凭借 **50 亿美元以上的追踪资产**、对 **10 多个区块链** 的支持以及开发者友好的 API，它已成为任何认真对待 DeFi 的人必备的工具。

**准备好探索 DeFi 交易世界了吗？[在 Binance 注册](https://www.bsmkweb.cc/register?ref=DIBI8) —— 全球领先的加密货币交易所，最低交易费用和最深流动性。**

---

*免责声明：本文仅供信息参考，不构成财务建议。加密货币投资存在重大风险。在做出投资决策前，请务必进行自己的研究。本文包含联盟链接 —— 当您使用我们的合作伙伴链接时，我们可能会获得补偿，对您不产生额外费用。*
