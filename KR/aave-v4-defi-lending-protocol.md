---
title: 'AAVE v4 2026: 150억 달러 이상의 예금을 관리하는 DeFi 대출 프로토콜 — 스마트 컨트랙트 통합 가이드'
description: '2026년 AAVE v4 DeFi 대출 프로토콜 통합 완벽 가이드. 30개 이상의 암호화폐 자산을 공급하고 차입하며, 플래시 론을 사용하고, 격리 모드를 구현하며, DApp에서 GHO 스테이블코인을 통합하는 방법을 배우세요.'
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
- /kr/posts/aave-v4-defi-lending-protocol/
---

{{</* resource-info */>}}

탈중앙화 대출은 현대 DeFi의 초석이 되었으며, AAVE는 이 혁명의 최전선에 서 있습니다. 여러 체인에서 150억 달러 이상의 총 잠긴 가치를 보유한 AAVE는 암호화폐 생태계에서 가장 크고 가장 많은 실전 테스트를 거친 대출 프로토콜입니다. 2025년 말에 출시된 AAVE v4는 중요한 아키텍처 개선을 도입하여 이전보다 더 효율적이고 안전하며 개발자 친화적으로 만들었습니다.

DeFi 애플리케이션, 트레이딩 봇, 수익 집계기 또는 포트폴리오 관리 도구를 구축하는 개발자에게 AAVE와의 통합 방법을 이해하는 것은 필수적입니다. 이 가이드는 기본적인 공급 및 대출 작업부터 플래시 론, 격리 모드, GHO 스테이블코인과 같은 고급 기능에 이르기까지 AAVE v4에 대한 포괄적인 연습을 제공합니다. Solidity 스마트 컨트랙트를 작성하든 프론트엔드 인터페이스를 구축하든, 통합을 가속화하는 실용적인 코드 예제와 아키텍처 인사이트를 찾을 수 있습니다.

> **제휴 공개:** 이 기사에는 [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) 및 [OKX](https://www.promoohubly.com/join/12190433)의 제휴 링크가 포함되어 있습니다. 당사 링크를 통해 등록하시면 추가 비용 없이 커미션을 받을 수 있습니다.

---

## AAVE란 무엇인가

AAVE는 사용자가 암호화폐 자산을 공급하고 차입할 수 있는 오픈 소스 비수탁형 유동성 프로토콜입니다. 2017년에 ETHLend로 처음 출시되어 2018년에 AAVE로 리브랜딩되었으며, 이 프로토콜은 여러 주요 버전을 통해 발전해 왔습니다. 2023년에 출시된 AAVE v3는 크로스체인 포털 기능을 갖추고 있으며, 2025년 말에 출시된 AAVE v4는 모듈형 아키텍처, 개선된 자본 효율성 및 네이티브 계정 추상화 지원을 갖추고 있습니다.

이 프로토콜은 Ethereum, Polygon, Arbitrum, Optimism, Avalanche, Base 및 기타 여러 네트워크에 배포된 일련의 스마트 컨트랙트를 통해 작동합니다. 자산을 공급하는 사용자는 aToken을 받으며, 이는 실시간으로 이자가 누적됩니다. 대출인은 가변 또는 고정 이율 모드로 과잉 담론 대출을 받을 수 있으며, 둘 사이를 유연하게 전환할 수 있습니다.

AAVE v4는 여러 아키텍처 혁신을 도입합니다:

- **모듈형 풀 아키텍처** — 리스크 관리를 핵심 대출 로직에서 분리
- **네이티브 플래시 론 단순화** — 통합 진입점
- **강화된 격리 모드** — 제한된 리스크로 롱테일 자산 상장
- **Chainlink CCIP 기반 크로스체인 유동성 레이어**
- **담론에 대해 직접 민팅되는 GHO 네이티브 머니 마켓**
- **가스 없는 트랜잭션 및 소셜 복구를 위한 계정 추상화 통합**

---

## AAVE v4 아키텍처 이해하기

코드로 들어가기 전에 AAVE v4의 핵심 아키텍처 구성 요소를 이해하는 것이 중요합니다.

**풀 컨트랙트.** 모든 공급, 대출 및 청산 작업을 관리하는 중앙 컨트랙트입니다. v4에서 풀은 리스크별 의사결정을 외부 모듈에 위임하면서 핵심 상태를 유지합니다.

**aToken.** 공급된 유동성을 나타내는 이자가 붙는 토큰입니다. DAI를 공급하면 aDAI를 받습니다. 이자가 누적됨에 따라 aToken의 잔액이 자동으로 증가합니다.

**가변 부채 토큰.** 가변 이율 대출 포지션을 추적하는 비전송 가능한 토큰입니다. 이는 대출인이 빚진 부채를 나타납니다.

**고정 부채 토큰.** 가변 부채 토큰과 유사하지만 대출 시점에 고정된 이자율을 가집니다. AAVE v4는 이자율 변동성을 줄이기 위해 고정 요금 메커니즘을 개선했습니다.

**가격 오라클.** Chainlink 가격 피드는 담론 계수, 청산 임계값 및 대출 능력을 결정하기 위한 자산 평가를 제공합니다.

**리스크 모듈.** v4의 새로운 모듈형 구성 요소로, 리스크 매개변수, 담론 구성 및 격리 모드 로직을 캡슐화합니다. 이러한 분리를 통해 거버넌스는 핵심 풀을 수정하지 않고도 리스크 설정을 업데이트할 수 있습니다.

---

## 개발 환경 설정

AAVE v4와 통합하려면 제대로 구성된 개발 환경이 필요합니다.

### Hardhat 프로젝트 설정

```bash
mkdir aave-integration && cd aave-integration
npm init -y
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox
npx hardhat init
```

### AAVE 종속성 설치

```bash
npm install @aave/core-v4 @aave/periphery-v4
npm install ethers dotenv
```

### 환경 구성

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

## 핵심 스마트 컨트랙트 통합

AAVE v4와 상호작용하기 위한 주요 인터페이스는 `IPool` 컨트랙트입니다. 모든 공급, 대출 및 상환 작업은 이 컨트랙트를 통해 이루어집니다.

### AAVE에 자산 공급하기

AAVE에 자산을 공급하면 ERC-20 토큰을 풀에 예치하고 교환으로 aToken을 받습니다. 이 aToken은 이자가 누적됨에 따라 자동으로 증가합니다.

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
        // 사용자로부터 이 컨트랙트로 토큰 전송
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        
        // 풀이 토큰을 사용할 수 있도록 승인
        IERC20(asset).approve(address(pool), amount);
        
        // msg.sender를 대신하여 AAVE 풀에 공급
        pool.supply(asset, amount, msg.sender, 0);
    }
}
```

### 자산 대출하기

대출을 받으려면 사용자가 충분한 담론을 공급해야 합니다. 최대 대출 금액은 공급 자산의 담론 계수에 의해 결정됩니다.

```solidity
contract AaveBorrower {
    IPool public immutable pool;
    
    constructor(address _pool) {
        pool = IPool(_pool);
    }
    
    function borrowAsset(
        address asset,
        uint256 amount,
        uint256 interestRateMode // 1 = 고정, 2 = 가변
    ) external {
        // 가변 또는 고정 이율로 대출
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

### 공급된 자산 인출하기

```solidity
function withdrawAsset(
    address asset,
    uint256 amount // 전액 인출하려면 type(uint256).max 사용
) external {
    // aToken을 인출하고 기본 자산을 받습니다
    pool.withdraw(asset, amount, msg.sender);
}
```

---

## 사용자 계정 데이터 읽기

AAVE는 건강 요소, 사용 가능한 대출 한도 및 담론 내역을 포함한 사용자별 정보를 집계하는 데이터 제공자 컨트랙트를 제공합니다.

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

### ethers.js를 사용한 JavaScript 통합

프론트엔드 및 스크립팅 통합을 위해 ethers.js는 편리한 인터페이스를 제공합니다.

```javascript
const { ethers } = require('ethers');
require('dotenv').config();

// Ethereum 메인넷의 AAVE v4 풀 컨트랙트
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
  console.log('총 담론 (USD):', ethers.formatUnits(data.totalCollateralBase, 8));
  console.log('총 부채 (USD):', ethers.formatUnits(data.totalDebtBase, 8));
  console.log('사용 가능한 대출 (USD):', ethers.formatUnits(data.availableBorrowsBase, 8));
  console.log('건강 요소:', ethers.formatUnits(data.healthFactor, 18));
  return data;
}
```

---

## 플래시 론 사용하기

플래시 론은 단일 트랜잭션 블록 내에서 차입과 상환을 완료해야 하는 무담론 대출입니다. AAVE는 DeFi에서 플래시 론을 개척했으며, v4는 통합 인터페이스로 구현을 간소화합니다.

### 플래시 론 수신자 컨트랙트

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
        // 플래시 론 수신 - 여기에 차익 거래 로직 구현
        uint256 amountOwed = amount + premium;
        
        // 예시: DEX 간 차익 거래
        // 1. DEX A에서 차입한 자산 교환
        // 2. DEX B에서 받은 자산 교환
        // 3. 이익 = finalAmount - amountOwed
        
        // 상환 승인
        IERC20(asset).approve(address(pool), amountOwed);
        
        return true;
    }
}
```

### 다중 자산 플래시 론

여러 자산이 필요한 고급 전략의 경우 전체 플래시 론 인터페이스를 사용합니다.

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

## 격리 모드 및 리스크 관리

AAVE v4는 특정 담론 자산에 대해 제한된 노출 한도로 대출을 허용하는 격리 모드를 강화했습니다. 이는 롱테일 자산을 안전하게 통합하는 데 중요합니다.

### 격리 모드에서 공급하기

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
        // 자산이 격리 모드에서 사용할 수 있는지 확인
        (,,,,,, bool isolationModeEnabled) = 
            IPoolDataProvider(address(0)).getReserveConfigurationData(asset);
        
        require(isolationModeEnabled, 'Asset not enabled for isolation');
        
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        IERC20(asset).approve(address(pool), amount);
        
        // 격리 모드 플래그로 공급
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

### 격리 모드 제약 조건 확인

```javascript
async function checkIsolationModeConstraints(userAddress, asset) {
  const reserveData = await pool.getReserveData(asset);
  const userConfig = await pool.getUserConfiguration(userAddress);
  
  console.log('격리 모드 총 부채:', 
    reserveData.isolationModeTotalDebt.toString());
  console.log('격리 모드 활성화:', 
    reserveData.configuration.data & (1 << 60) !== 0);
  
  // 사용자의 격리 모드 담론 확인
  const userReserveConfig = await dataProvider.getUserReserveData(asset, userAddress);
  console.log('사용자 담론:', 
    ethers.formatUnits(userReserveConfig.currentATokenBalance, 18));
}
```

---

## GHO 스테이블코인 통합

GHO는 AAVE 프로토콜을 통해 공급된 담론에 대해 직접 민팅되는 AAVE의 네이티브 탈중앙화 스테이블코인입니다. v4에서 GHO 통합은 풀 아키텍처의 네이티브 기능입니다.

### 담론에 대해 GHO 민팅하기

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
        // AAVE 풀에 충분한 담론이 필요함
        pool.borrow(
            address(gho),   // GHO 주소
            amount,
            2,              // 가변 이율
            0,              // 추천 코드
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
        // stkAAVE 보유자는 GHO 대출 이율 할인을 받음
        return gho.getDiscountPercent(user);
    }
}
```

### GHO 퍼실리테이터 패턴

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
        // 수수료 분배 구현
    }
}
```

---

## 크로스체인 포털 및 브리지 작업

AAVE v4는 Chainlink CCIP를 활용하여 크로스체인 유동성 전송을 수행하여 사용자가 포지션을 원활하게 이동할 수 있도록 합니다.

### 체인 간 aToken 브리징

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
        // 사용자 포지션에서 aToken 인출
        uint256 withdrawn = sourcePool.withdraw(
            getUnderlying(aToken),
            amount,
            address(this)
        );
        
        // CCIP를 통해 브리지하기 위해 승인
        IERC20(getUnderlying(aToken)).approve(ccipRouter, withdrawn);
        
        // 대상 체인으로의 CCIP 전송 로직
        // 대상 체인에서 수신자를 위해 AAVE 풀에 공급
    }
    
    function getUnderlying(address aToken) 
        internal 
        pure 
        returns (address) 
    {
        // aToken의 기본 자산 반환
        return address(0); // 구현 세부 정보
    }
}
```

---

## 청산 봇 구현

청산은 프로토콜 솔벤시의 핵심 메커니즘입니다. 청산 봇을 구축하면 수익성이 있을 뿐만 아니라 프로토콜 건강에 기여할 수 있습니다.

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
        // 상환을 위한 부채 자산 승인
        IERC20(debtAsset).transferFrom(msg.sender, address(this), debtToCover);
        IERC20(debtAsset).approve(address(pool), debtToCover);
        
        // 청산 실행
        pool.liquidationCall(
            collateralAsset,
            debtAsset,
            user,
            debtToCover,
            receiveAToken
        );
        
        // 청산된 담론을 호출자에게 전송
        if (receiveAToken) {
            // aToken 전송
        } else {
            // 기본 자산이 이미 이 컨트랙트로 전송됨
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

### JavaScript 청산 스캐너

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
        console.log(`청산 가능: ${user} 건강 요소: ${healthFactor}`);
      }
    } catch (error) {
      console.error(`확인 오류 ${user}:`, error.message);
    }
  }
  
  return liquidatableUsers;
}
```

---

## React를 사용한 프론트엔드 통합

현대적인 DeFi 프론트엔드는 일반적으로 wagmi 및 viem을 사용하여 블록체인 상호작용을 수행합니다.

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
      {isLoading ? '공급 중...' : 'AAVE에 공급'}
    </button>
  );
}
```

---

## 자주 묻는 질문

### AAVE v4에서 대출을 위한 최소 담론 비율은 얼마인가

최소 담론 비율은 특정 자산에 따라 다릅니다. ETH 및 WBTC와 같은 주요 자산의 대출 대 가치 비율은 일반적으로 80%로, 담론 가치의 최대 80%까지 대출받을 수 있습니다. 그러나 각 자산에는 AAVE 거버넌스에서 설정한 자체 리스크 매개변수가 있습니다. 청산을 피하기 위해서는 건강 요소가 1.0 이상이어야 하며, 건강 요소가 1.0 미만이면 포지션이 키퍼에 의해 청산될 수 있습니다.

### AAVE v4에서 플래시 론은 어떻게 작동하나

플래시 론을 사용하면 담론 없이 사용 가능한 금액의 자산을 대출받을 수 있으며, 대출 금액에 수수료를 더한 금액이 동일한 트랜잭션 블록 내에서 상환되어야 합니다. AAVE v4의 수수료는 일반적으로 0.09%입니다. 트랜잭션 종료 시까지 대출이 상환되지 않으면 전체 트랜잭션이 되돌려집니다. 플래시 론은 일반적으로 차익 거래, 담론 스왑, 자가 청산, 부채 재조정에 사용됩니다.

### 고정 이율과 가변 이율의 차이점은 무엇인가

가변 이율은 AAVE 풀 내의 수요와 공급 역학에 따라 변동합니다. 활용률이 100%에 가까워짐에 따라 이율이 상승하는 알고리즘 모델을 사용합니다. 고정 이율은 프리미엄을 지불하고 예측 가능한 대출 비용을 제공하지만, 극단적인 시장 상황에서는 재조정될 수 있습니다. AAVE v4에서는 고정 이율 메커니즘이 개선되어 재조정 이벤트의 빈도가 줄었습니다.

### 격리 모드는 프로토콜을 어떻게 보호하나

AAVE v4의 격리 모드에서는 특정 롱테일 자산을 엄격한 제한과 함께 담론으로 사용할 수 있습니다. 사용자가 격리 모드 자산을 공급하면 특정 승인된 자산만 대출받을 수 있으며 총 대출 능력은 부채 상한에 의해 제한됩니다. 이는 단일 변동성 자산이 전체 프로토콜의 솔벤시를 위협하는 것을 방지합니다. 격리 모드는 유동성이 제한된 새로 상장된 토큰에 특히 중요합니다.

### GHO는 무엇이며 다른 스테이블코인과 어떻게 다른가

GHO는 미국 달러에 페그된 AAVE의 네이티브 탈중앙화 스테이블코인입니다. 법정 통화 준비금으로 뒷받침되는 중앙화 스테이블코인과 달리, GHO는 AAVE 프로토콜 내에서 과잉 담론 포지션에 대해 알고리즘적으로 민팅됩니다. stkAAVE 토큰 보유자는 GHO 대출 이율 할인을 받습니다. GHO는 완전히 탈중앙화되고 검열에 강하며 AAVE의 대출 시장과 깊이 통합되도록 설계되었습니다.

### Layer 2 네트워크에서 AAVE v4를 통합할 수 있나

네, AAVE v4는 Arbitrum, Optimism, Base 및 Polygon을 포함한 여러 Layer 2 네트워크에 배포되어 있습니다. 체인 간 통합 패턴은 거의 동일하지만, 각 네트워크에 적합한 컨트랙트 주소와 RPC 엔드포인트를 사용해야 합니다. Layer 2 배포는 일반적으로 롤업 아키텍처를 통해 동일한 보안 보장을 유지하면서 상당히 낮은 가스 비용을 제공합니다.

---



## 추천 호스팅 및 인프라

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영을 지원합니다.*

## 결론

AAVE v4는 견고한 대출 메커니즘과 현대적인 아키텍처 개선을 결합한 수년간의 DeFi 혁신의 결정체를 나타냅니다. 모듈형 설계, 격리 모드를 통한 강화된 리스크 관리, 네이티브 GHO 스테이블코인 통합, 크로스체인 기능을 통해 Ethereum 및 그 이상의 플랫폼에서 금융 애플리케이션을 구축하는 개발자에게 최적의 선택이 되었습니다.

이 프로토콜의 광범위한 문서, 실전 테스트된 스마트 컨트랙트 및 활발한 개발자 커뮤니티는 통합을 위한 강력한 기반을 제공합니다. 단순한 수익 집계기를 구축하든 AAVE와 결합하는 정교한 DeFi 프로토콜을 구축하든, 이 가이드에 설명된 패턴이 개발을 가속화할 것입니다.

AAVE에서 구축을 시작할 준비가 되셨나요? 가스비용을 위한 ETH와 공급할 자산이 필요합니다. [Binance에 등록하거나](https://www.bsmkweb.cc/register?ref=DIBI8) [OKX에 가입하여](https://www.promoohubly.com/join/12190433) 개발 지갑에 자금을 입금하고 테스트 및 배포에 필요한 토큰을 확보하세요.
