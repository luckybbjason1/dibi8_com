---
title: 'AAVE v4 2026：管理150亿美元以上存款的DeFi借贷协议 — 智能合约集成指南'
description: '2026年AAVE v4 DeFi借贷协议集成完整指南。学习如何存入和借入30多种加密资产、使用闪电贷、实施隔离模式，以及在您的DApp中集成GHO稳定币。'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Ai Trading
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/aave/aave-v3-core'
stars: 2100
maintainer: 'aave'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: ['AAVE']
aliases:
- /zh/posts/aave-v4-defi-lending-protocol/
---

{{</* resource-info */>}}

去中心化借贷已成为现代DeFi的基石，而AAVE站在这场革命的最前沿。AAVE在多条链上拥有超过150亿美元的总锁定价值，是加密货币生态系统中最大且经过最多实战检验的借贷协议。2025年底发布的AAVE v4引入了重大的架构改进，使其比以往任何时候都更高效、更安全、更开发者友好。

对于构建DeFi应用、交易机器人、收益聚合器或投资组合管理工具的开发者来说，了解如何与AAVE集成至关重要。本指南提供了AAVE v4的全面演练，涵盖从基本的供应和借贷操作到闪电贷、隔离模式和GHO稳定币等高级功能的所有内容。无论您是在编写Solidity智能合约还是构建前端界面，您都会找到实用的代码示例和架构见解来加速您的集成。

> **联盟营销披露：** 本文包含[Binance](https://www.bsmkweb.cc/register?ref=DIBI8)和[OKX](https://www.promoohubly.com/join/12190433)的联盟链接。当您通过我们的链接注册时，我们可能会赚取佣金，而不会给您带来额外费用。

---

## AAVE是什么

AAVE是一个开源的非托管流动性协议，使用户能够供应和借贷加密货币资产。最初于2017年以ETHLend的名义推出，并于2018年重新品牌为AAVE，该协议经历了多个主要版本的演变。AAVE v3于2023年推出，具有跨链门户功能，而AAVE v4于2025年底到来，采用模块化架构、改进的资本效率和原生账户抽象支持。

该协议通过部署在以太坊、Polygon、Arbitrum、Optimism、Avalanche、Base及其他多个网络上的一系列智能合约运作。供应资产的用户会收到aToken作为回报，这些aToken实时累积利息。借款人可以以可变或稳定利率模式获得超额抵押贷款，并可以在它们之间灵活切换。

AAVE v4引入了多项架构创新：

- **模块化池架构**将风险管理与核心借贷逻辑分离
- **原生闪电贷简化**统一入口点
- **增强的隔离模式**用于在风险有限的情况下上架长尾资产
- **基于Chainlink CCIP构建的跨链流动性层**
- **直接针对抵押品铸造的GHO原生货币市场**
- **账户抽象集成**用于无gas交易和社交恢复

---

## 理解AAVE v4架构

在深入代码之前，了解AAVE v4的核心架构组件非常重要。

**池合约。** 管理所有供应、借贷和清算操作的中央合约。在v4中，池将风险特定的决策委托给外部模块，同时保持核心状态。

**aToken。** 代表供应流动性的计息代币。当您供应DAI时，您会收到aDAI。随着利息的累积，aToken的余额会自动增长。

**可变债务代币。** 追踪可变利率借贷头寸的不可转让代币。这些代表借款人所欠的债务，并随着利息的复利而增加。

**稳定债务代币。** 类似于可变债务代币，但在借贷时锁定稳定利率。AAVE v4改进了稳定费用机制，以减少利率波动。

**价格预言机。** Chainlink价格提供资产估值，用于确定抵押因子、清算阈值和借贷能力。

**风险模块。** v4中的新模块化组件，封装风险参数、抵押品配置和隔离模式逻辑。这种分离允许治理在不修改核心池的情况下更新风险设置。

---

## 设置开发环境

要与AAVE v4集成，您需要正确配置的开发环境。

### Hardhat项目设置

```bash
mkdir aave-integration && cd aave-integration
npm init -y
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox
npx hardhat init
```

### 安装AAVE依赖

```bash
npm install @aave/core-v4 @aave/periphery-v4
npm install ethers dotenv
```

### 环境配置

```bash
# .env
ETHEREUM_RPC=https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY
PRIVATE_KEY=your_private_key
```

```javascript
// hardhat.config.js
require('@nomicfoundation/hardhat-toolbox');
require('dotenv').config();

module.exports = {
  solidity: '0.8.24',
  networks: {
    hardhat: {
      forking: {
        url: process.env.ETHEREUM_RPC,
        blockNumber: 21000000,
      },
    },
    mainnet: {
      url: process.env.ETHEREUM_RPC,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
```

---

## 核心智能合约集成

与AAVE v4交互的主要接口是`IPool`合约。所有供应、借贷和还款操作都通过这个合约进行。

### 向AAVE供应资产

当您向AAVE供应资产时，您将ERC-20代币存入池中，并收到aToken作为交换。这些aToken会随着利息的累积自动增长。

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IPool} from '@aave/core-v4/contracts/interfaces/IPool.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract AaveSupplier {
    IPool public immutable pool;
    
    constructor(address _pool) {
        pool = IPool(_pool);
    }
    
    function supplyAsset(
        address asset,
        uint256 amount
    ) external {
        // 从用户转账代币到此合约
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        
        // 授权池花费代币
        IERC20(asset).approve(address(pool), amount);
        
        // 代表msg.sender供应到AAVE池
        pool.supply(asset, amount, msg.sender, 0);
    }
}
```

### 借贷资产

借贷要求用户有足够的抵押品供应。最大借贷金额由供应资产的抵押因子决定。

```solidity
contract AaveBorrower {
    IPool public immutable pool;
    
    constructor(address _pool) {
        pool = IPool(_pool);
    }
    
    function borrowAsset(
        address asset,
        uint256 amount,
        uint256 interestRateMode // 1 = 稳定, 2 = 可变
    ) external {
        // 以可变或稳定利率借贷
        pool.borrow(asset, amount, interestRateMode, 0, msg.sender);
    }
    
    function repayAsset(
        address asset,
        uint256 amount,
        uint256 interestRateMode
    ) external {
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        IERC20(asset).approve(address(pool), amount);
        pool.repay(asset, amount, interestRateMode, msg.sender);
    }
}
```

### 提取供应的资产

```solidity
function withdrawAsset(
    address asset,
    uint256 amount // 使用 type(uint256).max 全额提取
) external {
    // 提取aToken并接收基础资产
    pool.withdraw(asset, amount, msg.sender);
}
```

---

## 读取用户账户数据

AAVE提供一个数据提供合约，聚合用户特定的信息，包括健康因子、可用借贷额度和抵押品明细。

```solidity
import {IPoolDataProvider} from '@aave/core-v4/contracts/interfaces/IPoolDataProvider.sol';

contract AaveDataReader {
    IPoolDataProvider public immutable dataProvider;
    
    constructor(address _dataProvider) {
        dataProvider = IPoolDataProvider(_dataProvider);
    }
    
    function getUserData(address user) external view returns (
        uint256 totalCollateralBase,
        uint256 totalDebtBase,
        uint256 availableBorrowsBase,
        uint256 currentLiquidationThreshold,
        uint256 ltv,
        uint256 healthFactor
    ) {
        return dataProvider.calculateUserAccountData(user);
    }
    
    function getReserveConfiguration(address asset) 
        external 
        view 
        returns (
            uint256 decimals,
            uint256 ltv,
            uint256 liquidationThreshold,
            uint256 liquidationBonus,
            uint256 reserveFactor,
            bool usageAsCollateralEnabled,
            bool borrowingEnabled
        ) 
    {
        return dataProvider.getReserveConfigurationData(asset);
    }
}
```

### 使用ethers.js的JavaScript集成

对于前端和脚本集成，ethers.js提供了便捷的接口。

```javascript
const { ethers } = require('ethers');
require('dotenv').config();

// 以太坊主网上的AAVE v4池合约
const POOL_ADDRESS = '0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2';
const POOL_DATA_PROVIDER = '0x7B4EB56E7CD4b454BA8ff71E4518426Fede81A62';

const provider = new ethers.JsonRpcProvider(process.env.ETHEREUM_RPC);

const POOL_ABI = [
  'function supply(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external',
  'function borrow(address asset, uint256 amount, uint256 interestRateMode, uint16 referralCode, address onBehalfOf) external',
  'function repay(address asset, uint256 amount, uint256 interestRateMode, address onBehalfOf) external returns (uint256)',
  'function withdraw(address asset, uint256 amount, address to) external returns (uint256)',
  'function getUserAccountData(address user) external view returns (uint256 totalCollateralBase, uint256 totalDebtBase, uint256 availableBorrowsBase, uint256 currentLiquidationThreshold, uint256 ltv, uint256 healthFactor)',
];

const pool = new ethers.Contract(POOL_ADDRESS, POOL_ABI, provider);

async function getUserAccountData(userAddress) {
  const data = await pool.getUserAccountData(userAddress);
  console.log('总抵押品 (USD):', ethers.formatUnits(data.totalCollateralBase, 8));
  console.log('总债务 (USD):', ethers.formatUnits(data.totalDebtBase, 8));
  console.log('可借贷额度 (USD):', ethers.formatUnits(data.availableBorrowsBase, 8));
  console.log('健康因子:', ethers.formatUnits(data.healthFactor, 18));
  return data;
}
```

---

## 使用闪电贷

闪电贷是必须在单个交易区块内借贷和偿还的无抵押贷款。AAVE开创了DeFi中的闪电贷，v4通过统一接口简化了实现。

### 闪电贷接收合约

```solidity
import {IFlashLoanSimpleReceiver} from '@aave/core-v4/contracts/flashloan/interfaces/IFlashLoanSimpleReceiver.sol';
import {IPool} from '@aave/core-v4/contracts/interfaces/IPool.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract FlashLoanArbitrage is IFlashLoanSimpleReceiver {
    IPool public immutable pool;
    address public owner;
    
    constructor(address _pool) {
        pool = IPool(_pool);
        owner = msg.sender;
    }
    
    modifier onlyPool() {
        require(msg.sender == address(pool), 'Caller must be pool');
        _;
    }
    
    function executeFlashLoan(
        address asset,
        uint256 amount,
        bytes calldata params
    ) external {
        require(msg.sender == owner, 'Only owner');
        pool.flashLoanSimple(address(this), asset, amount, params, 0);
    }
    
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external onlyPool returns (bool) {
        // 收到闪电贷 - 在此处实现套利逻辑
        uint256 amountOwed = amount + premium;
        
        // 示例：在DEX之间套利
        // 1. 在DEX A上交换借入的资产
        // 2. 在DEX B上交换收到的资产
        // 3. 利润 = finalAmount - amountOwed
        
        // 授权偿还
        IERC20(asset).approve(address(pool), amountOwed);
        
        return true;
    }
}
```

### 多资产闪电贷

对于需要多种资产的高级策略，使用完整的闪电贷接口。

```solidity
import {IFlashLoanReceiver} from '@aave/core-v4/contracts/flashloan/interfaces/IFlashLoanReceiver.sol';

contract MultiAssetFlashLoan is IFlashLoanReceiver {
    IPool public immutable pool;
    
    constructor(address _pool) {
        pool = IPool(_pool);
    }
    
    function executeMultiFlashLoan(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata interestRateModes,
        bytes calldata params
    ) external {
        pool.flashLoan(
            address(this),
            assets,
            amounts,
            interestRateModes,
            msg.sender,
            params,
            0
        );
    }
    
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external returns (bool) {
        for (uint i = 0; i < assets.length; i++) {
            uint256 amountOwed = amounts[i] + premiums[i];
            IERC20(assets[i]).approve(address(pool), amountOwed);
        }
        return true;
    }
}
```

---

## 隔离模式与风险管理

AAVE v4增强了隔离模式，允许针对具有有限敞口上限的特定抵押资产进行借贷。这对于安全集成长尾资产至关重要。

### 在隔离模式下供应

```solidity
contract IsolationModeSupplier {
    IPool public immutable pool;
    
    constructor(address _pool) {
        pool = IPool(_pool);
    }
    
    function supplyInIsolation(
        address asset,
        uint256 amount,
        address onBehalfOf
    ) external {
        // 检查资产是否可以在隔离模式下使用
        (,,,,,, bool isolationModeEnabled) = 
            IPoolDataProvider(address(0)).getReserveConfigurationData(asset);
        
        require(isolationModeEnabled, 'Asset not enabled for isolation');
        
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        IERC20(asset).approve(address(pool), amount);
        
        // 使用隔离模式标志供应
        pool.supply(asset, amount, onBehalfOf, 0);
    }
    
    function getIsolationModeTotalDebt(address asset) 
        external 
        view 
        returns (uint256) 
    {
        return pool.getReserveData(asset).isolationModeTotalDebt;
    }
}
```

### 检查隔离模式约束

```javascript
async function checkIsolationModeConstraints(userAddress, asset) {
  const reserveData = await pool.getReserveData(asset);
  const userConfig = await pool.getUserConfiguration(userAddress);
  
  console.log('隔离模式总债务:', 
    reserveData.isolationModeTotalDebt.toString());
  console.log('隔离模式已启用:', 
    reserveData.configuration.data & (1 << 60) !== 0);
  
  // 检查用户的隔离模式抵押品
  const userReserveConfig = await dataProvider.getUserReserveData(asset, userAddress);
  console.log('用户抵押品:', 
    ethers.formatUnits(userReserveConfig.currentATokenBalance, 18));
}
```

---

## GHO稳定币集成

GHO是AAVE的原生去中心化稳定币，通过AAVE协议直接针对供应的抵押品铸造。在v4中，GHO集成是池架构的原生功能。

### 针对抵押品铸造GHO

```solidity
import {IGhoToken} from '@aave/gho-core/contracts/gho/interfaces/IGhoToken.sol';

contract GhoMinter {
    IPool public immutable pool;
    IGhoToken public immutable gho;
    
    constructor(address _pool, address _gho) {
        pool = IPool(_pool);
        gho = IGhoToken(_gho);
    }
    
    function mintGho(
        uint256 amount,
        address onBehalfOf
    ) external {
        // 需要在AAVE池中有足够的抵押品
        pool.borrow(
            address(gho),   // GHO地址
            amount,
            2,              // 可变利率
            0,              // 推荐码
            onBehalfOf
        );
    }
    
    function repayGho(uint256 amount) external {
        IERC20(address(gho)).transferFrom(msg.sender, address(this), amount);
        IERC20(address(gho)).approve(address(pool), amount);
        pool.repay(address(gho), amount, 2, msg.sender);
    }
    
    function getGhoDiscountRate(address user) 
        external 
        view 
        returns (uint256) 
    {
        // stkAAVE持有者获得GHO借贷利率折扣
        return gho.getDiscountPercent(user);
    }
}
```

### GHO促进者模式

```solidity
import {IGhoFacilitator} from '@aave/gho-core/contracts/gho/interfaces/IGhoFacilitator.sol';

contract CustomGhoFacilitator is IGhoFacilitator {
    IGhoToken public immutable ghoToken;
    uint256 public bucketCapacity;
    uint256 public bucketLevel;
    
    constructor(address _ghoToken, uint256 _capacity) {
        ghoToken = IGhoToken(_ghoToken);
        bucketCapacity = _capacity;
    }
    
    function mint(uint256 amount) external {
        require(bucketLevel + amount <= bucketCapacity, 'Bucket capacity exceeded');
        bucketLevel += amount;
        ghoToken.mint(address(this), amount);
    }
    
    function burn(uint256 amount) external {
        bucketLevel -= amount;
        ghoToken.burn(amount);
    }
    
    function distributeFeesToTreasury() external {
        // 费用分配的实现
    }
}
```

---

## 跨链门户与桥接操作

AAVE v4利用Chainlink CCIP进行跨链流动性转移，允许用户在之间无缝移动他们的头寸。

### 跨链桥接aToken

```solidity
import {IPool} from '@aave/core-v4/contracts/interfaces/IPool.sol';

contract AaveCrossChainBridge {
    IPool public immutable sourcePool;
    address public immutable ccipRouter;
    
    constructor(address _pool, address _router) {
        sourcePool = IPool(_pool);
        ccipRouter = _router;
    }
    
    function bridgeATokenToChain(
        address aToken,
        uint256 amount,
        uint64 destinationChainSelector,
        address recipient
    ) external {
        // 从用户头寸中提取aToken
        uint256 withdrawn = sourcePool.withdraw(
            getUnderlying(aToken),
            amount,
            address(this)
        );
        
        // 授权并通过CCIP桥接
        IERC20(getUnderlying(aToken)).approve(ccipRouter, withdrawn);
        
        // 到目标链的CCIP传输逻辑
        // 在目标链上，为接收者供应到AAVE池
    }
    
    function getUnderlying(address aToken) 
        internal 
        pure 
        returns (address) 
    {
        // 返回aToken的基础资产
        return address(0); // 实现细节
    }
}
```

---

## 清算机器人实现

清算是协议偿付能力的关键机制。构建清算机器人既可以盈利，又可以为协议健康做出贡献。

```solidity
contract AaveLiquidator {
    IPool public immutable pool;
    
    constructor(address _pool) {
        pool = IPool(_pool);
    }
    
    function liquidatePosition(
        address collateralAsset,
        address debtAsset,
        address user,
        uint256 debtToCover,
        bool receiveAToken
    ) external {
        // 授权用于偿还的债务资产
        IERC20(debtAsset).transferFrom(msg.sender, address(this), debtToCover);
        IERC20(debtAsset).approve(address(pool), debtToCover);
        
        // 执行清算
        pool.liquidationCall(
            collateralAsset,
            debtAsset,
            user,
            debtToCover,
            receiveAToken
        );
        
        // 将清算的抵押品转移给调用者
        if (receiveAToken) {
            // 转移aToken
        } else {
            // 基础资产已发送到此合约
        }
    }
    
    function checkLiquidatable(address user) 
        external 
        view 
        returns (bool, uint256 healthFactor) 
    {
        (, , , , , healthFactor) = pool.getUserAccountData(user);
        return (healthFactor < 1e18, healthFactor);
    }
}
```

### JavaScript清算扫描器

```javascript
async function scanForLiquidations(usersToCheck) {
  const liquidatableUsers = [];
  
  for (const user of usersToCheck) {
    try {
      const data = await pool.getUserAccountData(user);
      const healthFactor = ethers.formatUnits(data.healthFactor, 18);
      
      if (parseFloat(healthFactor) < 1.0) {
        liquidatableUsers.push({
          address: user,
          healthFactor,
          totalCollateral: ethers.formatUnits(data.totalCollateralBase, 8),
          totalDebt: ethers.formatUnits(data.totalDebtBase, 8),
        });
        console.log(`可清算: ${user} 健康因子: ${healthFactor}`);
      }
    } catch (error) {
      console.error(`检查 ${user} 时出错:`, error.message);
    }
  }
  
  return liquidatableUsers;
}
```

---

## 使用React的前端集成

现代DeFi前端通常使用wagmi和viem进行区块链交互。

```typescript
// hooks/useAave.ts
import { useContractWrite, usePrepareContractWrite } from 'wagmi';
import { parseUnits } from 'viem';

const POOL_ABI = [
  {
    name: 'supply',
    type: 'function',
    stateMutability: 'nonpayable',
    inputs: [
      { name: 'asset', type: 'address' },
      { name: 'amount', type: 'uint256' },
      { name: 'onBehalfOf', type: 'address' },
      { name: 'referralCode', type: 'uint16' },
    ],
    outputs: [],
  },
] as const;

export function useSupplyAsset(asset: string, amount: string, decimals: number) {
  const { config } = usePrepareContractWrite({
    address: '0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2',
    abi: POOL_ABI,
    functionName: 'supply',
    args: [
      asset as `0x${string}`,
      parseUnits(amount, decimals),
      '0xYourAddress' as `0x${string}`,
      0,
    ],
  });

  return useContractWrite(config);
}
```

```tsx
// components/SupplyButton.tsx
import { useSupplyAsset } from '../hooks/useAave';

export function SupplyButton({ asset, amount }: { asset: string; amount: string }) {
  const { write, isLoading } = useSupplyAsset(asset, amount, 18);

  return (
    <button 
      onClick={() => write?.()} 
      disabled={isLoading}
      className="supply-btn"
    >
      {isLoading ? '供应中...' : '供应到AAVE'}
    </button>
  );
}
```

---

## 常见问题解答

### AAVE v4上的最低抵押比率是多少

最低抵押比率取决于特定资产。ETH和WBTC等主要资产的贷款价值比通常为80%，意味着您可以借贷抵押品价值的80%。然而，每种资产都有自己的风险参数，由AAVE治理设定。健康因子必须保持在1.0以上以避免清算，健康因子低于1.0时您的头寸将变得可以被清算人清算。

### AAVE v4中的闪电贷如何运作

闪电贷允许您无需抵押即可借贷任何可用金额的资产，前提是借贷金额加上费用在同一交易区块内归还。AAVE v4中的费用通常为0.09%。如果贷款在交易结束时未偿还，整个交易将回滚。闪电贷通常用于套利、抵押品交换、自我清算和债务再融资。

### 稳定利率和可变利率之间有什么区别

可变利率根据AAVE池内的供需动态波动。它们使用算法模型，随着利用率接近100%而增加。稳定利率以溢价提供可预测的借贷成本，但在极端市场条件下可以被重新平衡。在AAVE v4中，稳定利率机制得到改进，减少了重新平衡事件的频率。

### 隔离模式如何保护协议

AAVE v4中的隔离模式允许某些长尾资产用作抵押品，但有严格的限制。当用户供应隔离模式资产时，他们只能借贷特定的批准资产，其总借贷能力受债务上限限制。这可以防止单一波动资产威胁整个协议的偿付能力。隔离模式对于流动性有限的新上市代币尤为重要。

### GHO是什么，它与其他稳定币有何不同

GHO是AAVE的原生去中心化稳定币，与美元锚定。与由法币储备支持的中心化稳定币不同，GHO是在AAVE协议内针对超额抵押头寸算法铸造的。stkAAVE代币持有者获得GHO借贷利率的折扣。GHO旨在完全去中心化、抗审查，并与AAVE的借贷市场深度集成。

### 我可以在Layer 2网络上集成AAVE v4吗

可以，AAVE v4部署在多个Layer 2网络上，包括Arbitrum、Optimism、Base和Polygon。跨链的集成模式几乎相同，但您应该使用每个网络的适当合约地址和RPC端点。Layer 2部署通常提供显著更低的gas成本，同时通过rollup架构保持相同的安全保证。

---



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 结论

AAVE v4代表了多年DeFi创新的结晶，将强大的借贷机制与现代架构改进相结合。其模块化设计、通过隔离模式增强的风险管理、原生GHO稳定币集成和跨链功能使其成为在以太坊及其他平台上构建金融应用的开发者的首选。

该协议广泛的文档、经过实战检验的智能合约和活跃的开发者社区为集成提供了坚实的基础。无论您是构建简单的收益聚合器还是与AAVE组合使用的复杂DeFi协议，本指南中概述的模式都将加速您的开发。

准备好在AAVE上开始构建了吗？您需要ETH作为gas费以及要供应的资产。[在Binance注册](https://www.bsmkweb.cc/register?ref=DIBI8)或[注册OKX](https://www.promoohubly.com/join/12190433)为您的开发钱包充值，并获取测试和部署所需的代币。
