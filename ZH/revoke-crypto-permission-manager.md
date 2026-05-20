---
title: 'revoke-crypto-permission-manager'
description: ''
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Ai Trading
source_version: ''
licensing_model: Open Source
license_type: GPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/RevokeCash/revoke.cash'
stars: 2500
maintainer: 'RevokeCash'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: ['Revoke.cash']
aliases:
- /zh/posts/revoke-crypto-permission-manager/
---

{{</* resource-info */>}}

**日期：** 2026-05-19  
**分类：** AI 交易  
**工具：** Revoke.cash  
**GitHub：** [RevokeCash/revoke.cash](https://github.com/RevokeCash/revoke.cash)（★ 2,500 · GPL-3.0 许可证）  
**联盟披露：** *本文包含联盟链接。如果您通过我们的合作伙伴链接注册，我们可能会获得佣金 —— 无需您额外付费。我们的编辑观点保持独立。*

---

## 简介：代币授权背后的隐藏危险

每次您在 Uniswap 上交换代币、存入收益金库或铸造 NFT 时，您都在授予**代币授权** —— 允许智能合约花费您的代币的权限。大多数用户没有意识到这些授权通常默认为**无限金额**，并且无限期保持活跃，即使您已经停止使用该协议。

这种隐形威胁已导致数亿美元的损失。臭名昭著的 **Uniswap V2 漏洞**（2020 年）、**Badger DAO 前端攻击**（2021 年）以及无数其他事件都是由于 lingering 的无限代币授权被攻击者利用而成为可能的。

**Revoke.cash** —— 由 [RevokeCash](https://github.com/RevokeCash) 在 GPL-3.0 许可证下构建的开源代币授权管理器，凭借 **2,500+ GitHub 星标**和超过 **10 亿美元的保护 DeFi 资产**，已成为每个加密用户防御武器库中必不可少的安全工具。

**👉 想在安全的交易所交易吗？[在 Binance 注册](https://www.bsmkweb.cc/register?ref=DIBI8) —— 世界上最受信任的加密平台。**

---

## Revoke.cash 是什么？了解代币授权

当您与 DeFi 协议交互时，您必须首先**批准**协议的智能合约访问您的代币。这是一种 ERC-20 机制，旨在防止合约任意花费您的资金。然而，大多数 dApp 请求**无限授权**（`type(uint256).max`）以节省用户未来的 Gas 费用。

问题在哪里？该授权永远持续 —— 即使：
- 协议被黑客攻击
- 您停止使用该 dApp
- 恶意前端取代了合法前端
- 协议部署了有漏洞的升级

Revoke.cash 通过提供一个简单的界面来**查看和撤销**您在多个区块链上的所有代币授权来解决这个问题。

### ERC-20 授权机制

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    // Revoke.cash 帮助管理的批准功能
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

// 当您"批准"Uniswap 时，会发生以下情况：
// token.approve(uniswapRouter, 115792089237316195423570985008687907853269984665640564039457584007913129639935)
// 这个数字 = type(uint256).max = 无限
```

---

## 快速入门指南：使用 Revoke.cash

使用 Revoke.cash 入门只需不到两分钟。以下是如何审计和清理您的授权。

### 第一步 — 访问 Revoke.cash

```bash
# 官方网站（务必验证网址）
# https://revoke.cash
# 
# 需要避免的常见钓鱼域名：
# - revokecash.com（伪造）
# - revoke-cash.app（伪造）
# - revok3.cash（伪造）
# 首次访问后务必将官方网址添加到书签
```

### 第二步 — 连接您的钱包

```javascript
// Revoke.cash 支持所有主流钱包
const supportedWallets = [
  "MetaMask",
  "WalletConnect v2",
  "Coinbase Wallet",
  "Rainbow",
  "Ledger Live",
  "Trezor（通过 MetaMask）",
  "Phantom（EVM 模式）",
  "Trust Wallet"
];
```

### 第三步 — 查看所有活跃授权

```bash
# Revoke.cash 仪表板显示：
# ┌────────────────┬─────────────────┬──────────────┬──────────┐
# │ 代币           │ 已批准花费者    │ 金额         │ 风险     │
# ├────────────────┼─────────────────┼──────────────┼──────────┤
# │ USDC           │ Uniswap V3      │ 无限         │ ⚠️ 高   │
# │ WETH           │ Aave V3         │ 无限         │ ⚠️ 高   │
# │ DAI            │ 1inch           │ 5,000 DAI    │ 🟡 中   │
# │ USDT           │ 未知合约        │ 无限         │ 🔴 严重 │
# └────────────────┴─────────────────┴──────────────┴──────────┘
```

### 第四步 — 撤销风险授权

```javascript
// Revoke.cash 执行新的授权，金额 = 0
// 这有效地取消了之前的无限授权

// 示例：从可疑合约撤销 USDC 授权
const tokenContract = new ethers.Contract(
  "0xA0b86a33E6441c17d1dd4e6028a4b153575cC69A", // USDC
  ERC20_ABI,
  signer
);

// 将授权设置为 0 可撤销所有权限
const tx = await tokenContract.approve("0xSuspiciousContract", 0);
await tx.wait();
console.log("授权已撤销！交易：", tx.hash);
```

---

## 深入了解：Revoke.cash 的工作原理

Revoke.cash 没有任何特殊权限 —— 它只是为基本的区块链操作提供了一个用户友好的界面。

### 技术机制

```solidity
// 要"撤销"授权，您只需批准 0 个代币
// 这是删除先前授权的唯一方法

function revokeApproval(address token, address spender) external {
    // approve(spender, 0) 会覆盖之前的授权额度
    IERC20(token).approve(spender, 0);
    // 此交易后，花费者无法移动您的任何代币
}

// 替代方案：批准特定有限金额
function setLimitedApproval(address token, address spender, uint256 amount) external {
    IERC20(token).approve(spender, amount);
    // 花费者最多只能花费 'amount' 个代币
}
```

### 事件日志分析

```javascript
// Revoke.cash 从区块链读取 Approval 事件
const filter = {
  address: tokenAddress,           // 代币合约
  topics: [
    ethers.utils.id("Approval(address,address,uint256)"),
    ethers.utils.hexZeroPad(userAddress, 32),  // 您的地址（所有者）
    null                                       // 任何花费者
  ]
};

// 查询所有历史授权事件
const approvalEvents = await provider.getLogs({
  ...filter,
  fromBlock: 0,
  toBlock: "latest"
});
```

### 读取当前授权额度

```javascript
// 直接合约调用以检查当前授权
const checkAllowance = async (tokenAddress, owner, spender) => {
  const token = new ethers.Contract(tokenAddress, ERC20_ABI, provider);
  
  const allowance = await token.allowance(owner, spender);
  
  const MAX_UINT256 = ethers.BigNumber.from(
    "115792089237316195423570985008687907853269984665640564039457584007913129639935"
  );
  
  if (allowance.eq(MAX_UINT256)) {
    return { status: "无限", risk: "严重" };
  } else if (allowance.gt(0)) {
    return { status: "有限", amount: allowance.toString(), risk: "中等" };
  } else {
    return { status: "已撤销", risk: "无" };
  }
};
```

---

## 多链支持：跨网络保护资产

Revoke.cash 支持所有主要的 EVM 兼容链，允许您在任何与 DeFi 交互的地方审计授权。

### 支持的网络（2026 年）

```yaml
# 2026 年完整网络支持
ethereum:
  chain_id: 1
  rpc_required: true
  features: ["完整支持", "NFT 授权", "Permit2"]

polygon:
  chain_id: 137
  rpc_required: true
  features: ["完整支持", "低 Gas 撤销"]

arbitrum:
  chain_id: 42161
  rpc_required: true
  features: ["完整支持", "Nitro 兼容"]

optimism:
  chain_id: 10
  rpc_required: true
  features: ["完整支持", "Bedrock 兼容"]

base:
  chain_id: 8453
  rpc_required: true
  features: ["完整支持", "Coinbase 生态系统"]

bnb_chain:
  chain_id: 56
  rpc_required: true
  features: ["完整支持", "PancakeSwap 授权"]

avalanche:
  chain_id: 43114
  rpc_required: true
  features: ["C-Chain 支持", "TraderJoe 授权"]
```

### 切换网络

```javascript
// Revoke.cash 自动检测您当前的网络
// 在钱包中切换网络以审计不同链上的授权

const switchNetwork = async (chainId) => {
  await window.ethereum.request({
    method: "wallet_switchEthereumChain",
    params: [{ chainId: `0x${chainId.toString(16)}` }]
  });
  // Revoke.cash 将自动刷新新链的数据
};

// 示例：切换到 Polygon
await switchNetwork(137);
```

---

## 浏览器扩展：实时保护

Revoke.cash 提供了一个**浏览器扩展**，在您签署潜在危险授权之前提供主动安全警报。

### 扩展安装

```bash
# Chrome 网上应用店：
# https://chrome.google.com/webstore/detail/revokecash/revokecash-extension

# Firefox 附加组件：
# https://addons.mozilla.org/firefox/addon/revokecash/

# 功能：
# - 在签署无限授权之前发出警告
# - 批准已知恶意合约时发出警报
# - 显示估计的美元风险价值
# - 从弹出窗口一键撤销
```

### 扩展配置

```javascript
// 扩展设置（可通过弹出窗口配置）
const extensionConfig = {
  // 当授权超过此美元阈值时发出警告
  warnThresholdUSD: 1000,
  
  // 自动阻止已知的钓鱼合约
  blockKnownScams: true,
  
  // 显示每次授权的风险评级
  showRiskRating: true,
  
  // 对 Permit 签名发出警告（无 Gas 授权）
  warnOnPermit: true,
  
  // 暗色模式
  theme: "dark"
};
```

---

## 高级功能：Permit 和 Permit2 签名

现代 DeFi 使用 **gasless 授权**通过 EIP-2612 `permit()` 和 Uniswap 的 **Permit2** 合约。这些特别危险，因为它们不需要链上交易 —— 只需签名即可。

### 理解 Permit 签名

```solidity
// EIP-2612 permit：链下签名变成链上授权
function permit(
    address owner,
    address spender,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
) external {
    // 调用后，'spender' 可以花费 'value' 个代币
    // 用户从未发送交易 —— 只签署了一条消息！
}
```

### 撤销 Permit2 授权

```javascript
// 撤销 Permit2 需要向 Permit2 合约发送交易
const revokePermit2 = async (token, spender) => {
  const permit2 = new ethers.Contract(PERMIT2_ADDRESS, PERMIT2_ABI, signer);
  
  // 将金额设置为 0，到期时间设置为现在
  const tx = await permit2.approve(
    token,
    spender,
    0,                                      // amount = 0
    Math.floor(Date.now() / 1000)           // expiration = now
  );
  
  await tx.wait();
  console.log("Permit2 授权已撤销！");
};
```

---

## Gas 高效的撤销策略

撤销授权需要 Gas。以下是一些策略，可在保持安全的同时最小化成本。

### 批量撤销

```javascript
// 使用 multicall 在一次交易中撤销多个授权
const multicall3Address = "0xcA11bde05977b3631167028862bE2a173976CA11";

const batchRevoke = async (revocations) => {
  const multicall = new ethers.Contract(multicall3Address, MULTICALL_ABI, signer);
  
  const calls = revocations.map(({ token, spender }) => ({
    target: token,
    allowFailure: true,
    callData: new ethers.Contract(token, ERC20_ABI).interface.encodeFunctionData(
      "approve", [spender, 0]
    )
  }));
  
  const tx = await multicall.aggregate3(calls);
  await tx.wait();
  
  console.log(`在一次交易中撤销了 ${revocations.length} 个授权！`);
};
```

---

## 安全警报系统

Revoke.cash 监控已知的漏洞利用，并主动向可能拥有受损协议授权的用户发出警报。

```javascript
// 订阅安全警报（通过浏览器扩展或 Telegram）
const subscribeToAlerts = async (address) => {
  const alertConfig = {
    address: address,
    alertTypes: [
      "PROTOCOL_EXPLOIT",       // 当您批准的协议被黑客攻击时
      "NEW_UNLIMITED_APPROVAL",  // 当您授予无限授权时
      "SUSPICIOUS_CONTRACT"      // 当您批准标记的合约时
    ],
    channels: ["browser", "telegram", "email"]
  };
  
  return alertConfig;
};
```

---

## 代币授权安全的最佳实践

### 安全检查清单

```bash
# 每周例行：
# 1. 访问 revoke.cash 并扫描所有活跃授权
# 2. 撤销您未积极使用的协议的无限授权
# 3. 检查"风险"列以发现未知花费者

# 每次重大交易前：
# 1. 在 Etherscan 上验证合约地址
# 2. 检查花费者是否是已知协议
# 3. 如果提示无限授权，请设置自定义限额

# 协议被攻击后：
# 1. 立即检查 revoke.cash 查看您是否使用过该协议
# 2. 撤销所有受损合约的授权
# 3. 监控您的地址是否有未经授权的转账
```

### 使用有限授权

```javascript
// 代替无限授权，设置特定金额
const setLimitedApproval = async (token, spender, humanAmount) => {
  const decimals = await token.decimals();
  const amount = ethers.utils.parseUnits(humanAmount, decimals);
  
  // 只批准您需要的 + 小额缓冲
  const tx = await token.approve(spender, amount);
  await tx.wait();
  
  console.log(`批准了 ${humanAmount} 个代币给 ${spender}`);
};

// 示例：只为一次交换批准 1000 USDC
await setLimitedApproval(usdcContract, uniswapRouter, "1000");
```

---

## 常见问题解答（FAQ）

**Q1：Revoke.cash 是免费的吗？**
A：是的，Revoke.cash 完全免费。它是一个由社区维护的开源项目（GPL-3.0）。您只需为撤销交易支付标准的网络 Gas 费用。浏览器扩展也是免费的。

**Q2：Revoke.cash 能窃取我的代币吗？**
A：不能。Revoke.cash 是一个非托管界面 —— 它从不持有您的密钥或拥有任何特殊访问权限。您直接通过自己的钱包签署所有交易。代码在 GitHub 上完全开源且可审计。

**Q3：撤销和断开钱包连接有什么区别？**
A：断开钱包连接只会移除与 Revoke.cash 的前端连接。它不会移除区块链上的代币授权。撤销是一个链上操作，永久移除智能合约花费您代币的权限。

**Q4：我需要在每条区块链上分别撤销授权吗？**
A：是的，代币授权是特定于链的。如果您在以太坊上批准了 Uniswap 的 USDC，该授权仅存在于以太坊上。您需要在每个与 DeFi 协议交互过的链上检查和撤销授权。

**Q5：什么是 Permit2 授权，它们有何不同？**
A：Uniswap 的 Permit2 系统允许通过链下签名进行无 Gas 授权。这些不会显示为常规链上交易，但仍授予花费权限。Revoke.cash 可以通过专用界面检测和撤销 Permit2 授权。

**Q6：我应该撤销所有授权吗，即使是来自可信协议的？**
A：不一定。对于您经常使用的协议（如 Aave 或 Uniswap），保持授权很方便，且已建立协议的风险较低。重点撤销：（1）无限授权，（2）不再使用的协议授权，（3）未知合约授权。

**Q7：有人可以通过授权窃取我的 NFT 吗？**
A：是的！ERC-721 和 ERC-1155 代币授权的工作方式与 ERC-20 类似。如果您批准了 NFT 市场或随机合约，它们可以转移您的 NFT。Revoke.cash 也支持撤销 NFT 授权 —— 在仪表板上查找"NFT"标签。

**Q8：如果我不撤销授权会发生什么？**
A：您的代币将无限期地处于风险之中。如果已批准的合约被利用、被黑客攻击或变得恶意，您整个已批准的余额可能会在单笔交易中被耗尽。许多备受瞩目的黑客攻击（如 6 亿美元的 Poly Network 漏洞）都是由于 lingering 的授权而成为可能的。

---



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 结论

在 DeFi 中，安全不是一次性的设置 —— 而是一种持续的实践。Revoke.cash 凭借其 **2,500+ GitHub 星标**、**浏览器扩展**和**多链支持**，提供了审计和管理代币授权的最简单但最有效的方式。

凭借超过 **10 亿美元的保护资产**和对被攻击协议的定期安全警报，Revoke.cash 已证明自己是每个加密用户安全堆栈中的基本工具。将其作为每周习惯 —— 在 revoke.cash 上花 5 分钟，可能拯救您的整个投资组合。

**正在寻找安全的交易场所？[在 Binance 注册](https://www.bsmkweb.cc/register?ref=DIBI8) —— 全球最大的加密交易所，拥有行业领先的安全性、最低费用和保险基金保护。**

---

*免责声明：本文仅供信息参考，不构成财务或安全建议。始终验证合约地址，对重要持仓使用硬件钱包，并保持良好的操作安全。本文包含联盟链接 —— 当您使用我们的合作伙伴链接时，我们可能会获得补偿，对您不产生额外费用。*
