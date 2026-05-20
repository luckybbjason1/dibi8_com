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
- /kr/posts/revoke-crypto-permission-manager/
---

{{</* resource-info */>}}

**날짜:** 2026-05-19  
**카테고리:** AI 트레이딩  
**도구:** Revoke.cash  
**GitHub:** [RevokeCash/revoke.cash](https://github.com/RevokeCash/revoke.cash)（★ 2,500 · GPL-3.0 라이선스）  
**제휴 공개:** *본 기사에는 제휴 링크가 포함되어 있습니다. 파트너 링크를 통해 등록하시면 커미션을 받을 수 있으며, 이는 추가 비용 없이 제공됩니다. 우리의 편집 의견은 독립적입니다.*

---

## 소개: 토큰 승인의 숨겨진 위험

Uniswap에서 토큰을 교환하거나, 수익 볼트에 입금하거나, NFT를 민팅할 때마다 **토큰 승인**을 부여하고 있습니다 — 스마트 계약이 귀하의 토큰을 사용할 수 있도록 하는 권한입니다. 대부분의 사용자는 이러한 승인이 종종 **무제한 금액**으로 기본 설정되며, 프로토콜 사용을 중단한 후에도 무기한 활성 상태로 유지된다는 것을 인식하지 못합니다.

이 보이지 않는 위협으로 수억 달러의 손실이 발생했습니다. 악명 높은 **Uniswap V2 취약점**(2020년), **Badger DAO 프론트엔드 공격**(2021년) 및 수많은 다른 사건은 공격자가 악용한 잔류 무제한 토큰 승인으로 인해 가능해졌습니다.

**Revoke.cash** — [RevokeCash](https://github.com/RevokeCash)이 GPL-3.0 라이선스 하에 구축한 오픈소스 토큰 승인 관리자는 **2,500개 이상의 GitHub 스타**와 **10억 달러 이상의 보호된 DeFi 자산**을 보유하고 있으며, 모든 암호화폐 사용자의 보안 도구 상자에 필수적인 보안 도구가 되었습니다.

**👉 안전한 거래소에서 거래하고 싶으신가요? [Binance에 등록](https://www.bsmkweb.cc/register?ref=DIBI8)하세요 — 세계에서 가장 신뢰받는 암호화폐 플랫폼입니다.**

---

## Revoke.cash란? 토큰 승인 이해하기

DeFi 프로토콜과 상호 작용하려면 먼저 프로토콜의 스마트 계약이 귀하의 토큰에 액세스할 수 있도록 **승인**해야 합니다. 이는 ERC-20 메커니즘으로, 계약이 임의로 자금을 사용하는 것을 방지하도록 설계되었습니다. 그러나 대부분의 dApp은 사용자가 향후 거래에서 가스를 절약할 수 있도록 **무제한 승인**(`type(uint256).max`)을 요청합니다.

문제는 무엇입니까? 해당 승인은 다음 경우에도 영원히 지속됩니다:
- 프로토콜이 해킹당한 경우
- dApp 사용을 중단한 경우
- 악의적인 프론트엔드가 합법적인 프론트엔드를 대체한 경우
- 프로토콜이 취약한 업그레이드를 배포한 경우

Revoke.cash는 여러 블록체인에서 모든 토큰 승인을 **보고 취소**할 수 있는 간단한 인터페이스를 제공하여 이 문제를 해결합니다.

### ERC-20 승인 메커니즘

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    // Revoke.cash가 관리하는 승인 기능
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

// Uniswap을 "승인"하면 다음이 발생합니다:
// token.approve(uniswapRouter, 115792089237316195423570985008687907853269984665640564039457584007913129639935)
// 이 숫자 = type(uint256).max = 무제한
```

---

## 빠른 시작 가이드: Revoke.cash 사용하기

Revoke.cash로 시작하는 데 2분이 채 걸리지 않습니다. 승인을 감사하고 정리하는 방법은 다음과 같습니다.

### 1단계 — Revoke.cash 방문

```bash
# 공식 웹사이트(URL 항상 확인)
# https://revoke.cash
# 
# 피싱 도메인:
# - revokecash.com (가짜)
# - revoke-cash.app (가짜)
# - revok3.cash (가짜)
# 첫 방문 후 공식 URL을 즐겨찾기에 추가하세요
```

### 2단계 — 지갑 연결

```javascript
// Revoke.cash는 모든 주요 지갑을 지원합니다
const supportedWallets = [
  "MetaMask",
  "WalletConnect v2",
  "Coinbase Wallet",
  "Rainbow",
  "Ledger Live",
  "Trezor (MetaMask 통해)",
  "Phantom (EVM 모드)",
  "Trust Wallet"
];
```

### 3단계 — 모든 활성 승인 보기

```bash
# Revoke.cash 대시보드 표시:
# ┌────────────────┬─────────────────┬──────────────┬──────────┐
# │ 토큰           │ 승인된 지출자   │ 금액         │ 위험     │
# ├────────────────┼─────────────────┼──────────────┼──────────┤
# │ USDC           │ Uniswap V3      │ 무제한       │ ⚠️ 높음  │
# │ WETH           │ Aave V3         │ 무제한       │ ⚠️ 높음  │
# │ DAI            │ 1inch           │ 5,000 DAI    │ 🟡 중간  │
# │ USDT           │ 알 수 없는 계약 │ 무제한       │ 🔴 심각  │
# └────────────────┴─────────────────┴──────────────┴──────────┘
```

### 4단계 — 위험한 승인 취소

```javascript
// Revoke.cash는 금액 = 0인 새 승인을 실행합니다
// 이는 이전의 무제한 승인을 효과적으로 취소합니다

// 예시: 의심스러운 계약에서 USDC 승인 취소
const tokenContract = new ethers.Contract(
  "0xA0b86a33E6441c17d1dd4e6028a4b153575cC69A", // USDC
  ERC20_ABI,
  signer
);

// 승인을 0으로 설정하면 모든 권한이 취소됩니다
const tx = await tokenContract.approve("0xSuspiciousContract", 0);
await tx.wait();
console.log("승인이 취소되었습니다! 거래:", tx.hash);
```

---

## 심층 분석: Revoke.cash의 작동 방식

Revoke.cash는 특별한 권한이 없습니다 — 기본 블록체인 작업을 위한 사용자 친화적인 인터페이스를 제공할 뿐입니다.

### 기술 메커니즘

```solidity
// "승인을 취소"하려면 토큰 0개만 승인하면 됩니다
// 이것이 이전 승인을 제거하는 유일한 방법입니다

function revokeApproval(address token, address spender) external {
    // approve(spender, 0)이 이전 허용 한도를 덮어씁니다
    IERC20(token).approve(spender, 0);
    // 이 거래 후 지출자는 귀하의 토큰을 이동할 수 없습니다
}

// 대안: 특정 제한된 금액 승인
function setLimitedApproval(address token, address spender, uint256 amount) external {
    IERC20(token).approve(spender, amount);
    // 지출자는 최대 'amount' 토큰만 지출할 수 있습니다
}
```

### 이벤트 로그 분석

```javascript
// Revoke.cash는 블록체인에서 승인 이벤트를 읽습니다
const filter = {
  address: tokenAddress,           // 토큰 계약
  topics: [
    ethers.utils.id("Approval(address,address,uint256)"),
    ethers.utils.hexZeroPad(userAddress, 32),  // 귀하의 주소 (소유자)
    null                                       // 모든 지출자
  ]
};

// 모든 과거 승인 이벤트 쿼리
const approvalEvents = await provider.getLogs({
  ...filter,
  fromBlock: 0,
  toBlock: "latest"
});

// 각 (소유자, 지출자, 토큰) 트리플렛에 대한 가장 최근의 이벤트가
// 현재 활성 승인을 나타냅니다
```

### 현재 허용 한도 읽기

```javascript
// 현재 허용 한도를 확인하기 위한 직접 계약 호출
const checkAllowance = async (tokenAddress, owner, spender) => {
  const token = new ethers.Contract(tokenAddress, ERC20_ABI, provider);
  
  const allowance = await token.allowance(owner, spender);
  
  const MAX_UINT256 = ethers.BigNumber.from(
    "115792089237316195423570985008687907853269984665640564039457584007913129639935"
  );
  
  if (allowance.eq(MAX_UINT256)) {
    return { status: "무제한", risk: "심각" };
  } else if (allowance.gt(0)) {
    return { status: "제한적", amount: allowance.toString(), risk: "중간" };
  } else {
    return { status: "취소됨", risk: "없음" };
  }
};
```

---

## 멀티체인 지원: 여러 네트워크에서 자산 보호

Revoke.cash는 모든 주요 EVM 호환 체인을 지원하여 DeFi와 상호 작용하는 모든 곳에서 승인을 감사할 수 있습니다.

### 지원 네트워크 (2026년)

```yaml
# 2026년 완전한 네트워크 지원
ethereum:
  chain_id: 1
  rpc_required: true
  features: ["전체 지원", "NFT 승인", "Permit2"]

polygon:
  chain_id: 137
  rpc_required: true
  features: ["전체 지원", "낮은 가스 취소"]

arbitrum:
  chain_id: 42161
  rpc_required: true
  features: ["전체 지원", "Nitro 호환"]

optimism:
  chain_id: 10
  rpc_required: true
  features: ["전체 지원", "Bedrock 호환"]

base:
  chain_id: 8453
  rpc_required: true
  features: ["전체 지원", "Coinbase 생태계"]

bnb_chain:
  chain_id: 56
  rpc_required: true
  features: ["전체 지원", "PancakeSwap 승인"]

avalanche:
  chain_id: 43114
  rpc_required: true
  features: ["C-Chain 지원", "TraderJoe 승인"]
```

### 네트워크 전환

```javascript
// Revoke.cash가 현재 네트워크를 자동 감지합니다
// 지갑에서 네트워크를 전환하여 다른 체인에서 승인을 감사합니다

const switchNetwork = async (chainId) => {
  await window.ethereum.request({
    method: "wallet_switchEthereumChain",
    params: [{ chainId: `0x${chainId.toString(16)}` }]
  });
  // Revoke.cash가 새 체인에 대해 자동으로 새로 고칩니다
};

// 예시: Polygon으로 전환
await switchNetwork(137);
```

---

## 브라우저 확장 프로그램: 실시간 보호

Revoke.cash는 잠재적으로 위험한 승인에 서명하기 전에 사전 보안 경고를 제공하는 **브라우저 확장 프로그램**을 제공합니다.

### 확장 프로그램 설치

```bash
# Chrome 웹 스토어:
# https://chrome.google.com/webstore/detail/revokecash/revokecash-extension

# Firefox 부가 기능:
# https://addons.mozilla.org/firefox/addon/revokecash/

# 기능:
# - 무제한 승인에 서명하기 전에 경고
# - 알려진 악성 계약 승인 시 알림
# - 위험에 처한 예상 USD 가치 표시
# - 팝업에서 원클릭 취소
```

### 확장 프로그램 설정

```javascript
// 확장 프로그램 설정(팝업을 통해 구성 가능)
const extensionConfig = {
  // 승인이 이 USD 임계값을 초과할 때 경고
  warnThresholdUSD: 1000,
  
  // 알려진 피싱 계약 자동 차단
  blockKnownScams: true,
  
  // 각 승인에 대한 위험 등급 표시
  showRiskRating: true,
  
  // Permit 서명에 대해 경고(가스 없는 승인)
  warnOnPermit: true,
  
  // 다크 모드
  theme: "dark"
};
```

---

## 고급: Permit 및 Permit2 서명

현대 DeFi는 EIP-2612 `permit()` 및 Uniswap의 **Permit2** 계약을 통해 **가스 없는 승인**을 사용합니다. 이들은 특히 위험합니다. 왜냐하면 온체인 트랜잭션이 필요하지 않고 서명만 필요하기 때문입니다.

### Permit 서명 이해

```solidity
// EIP-2612 permit: 오프체인 서명이 온체인 승인이 됩니다
function permit(
    address owner,
    address spender,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
) external {
    // 이 호출 후 'spender'는 'value' 토큰을 사용할 수 있습니다
    // 사용자는 트랜잭션을 본 적이 없습니다 — 메시지만 서명했습니다!
}
```

### Permit2 허용 한도 취소

```javascript
// Permit2 취소는 Permit2 계약에 대한 트랜잭션이 필요합니다
const revokePermit2 = async (token, spender) => {
  const permit2 = new ethers.Contract(PERMIT2_ADDRESS, PERMIT2_ABI, signer);
  
  // 금액을 0으로 설정하고 만료 시간을 현재로 설정
  const tx = await permit2.approve(
    token,
    spender,
    0,                                      // amount = 0
    Math.floor(Date.now() / 1000)           // expiration = now
  );
  
  await tx.wait();
  console.log("Permit2 허용 한도가 취소되었습니다!");
};
```

---

## 가스 효율적인 취소 전략

승인을 취소하는 데 가스가 필요합니다. 보안을 유지하면서 비용을 최소화하기 위한 전략은 다음과 같습니다.

### 일괄 취소

```javascript
// multicall을 사용하여 한 번의 트랜잭션에서 여러 승인을 취소합니다
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
  
  console.log(`한 번의 트랜잭션에서 ${revocations.length}개의 승인을 취소했습니다!`);
};
```

### 취소 타이밍

```bash
# 전략: 가스가 낮은 기간 동안 취소
# - 주말은 일반적으로 가스가 더 낮습니다
# - 이른 새벽 UTC(오전 2시 - 오전 6시)가 보통 가장 저렴합니다
# - https://etherscan.io/gastracker를 사용하여 모니터링하세요

# 취소를 위한 예상 가스 비용:
# ┌─────────────────┬──────────────┬──────────────────┐
# │ 네트워크         │ 가스 단위     │ 비용(20 gwei 기준)│
# ├─────────────────┼──────────────┼──────────────────┤
# │ Ethereum        │ ~46,000      │ ~$2.30           │
# │ Polygon         │ ~46,000      │ ~$0.02           │
# │ Arbitrum        │ ~46,000      │ ~$0.50           │
# │ Optimism        │ ~46,000      │ ~$0.30           │
# │ BNB Chain       │ ~46,000      │ ~$0.10           │
# └─────────────────┴──────────────┴──────────────────┘
```

---

## 보안 알림 시스템

Revoke.cash는 알려진 공격을 모니터링하고 손상된 프로토콜에 승인이 있을 수 있는 사용자에게 사전에 경고합니다.

```javascript
// 보안 경고 구독(브라우저 확장 프로그램 또는 Telegram을 통해)
const subscribeToAlerts = async (address) => {
  const alertConfig = {
    address: address,
    alertTypes: [
      "PROTOCOL_EXPLOIT",       // 승인한 프로토콜이 해킹당한 경우
      "NEW_UNLIMITED_APPROVAL", // 무제한 승인을 부여한 경우
      "SUSPICIOUS_CONTRACT"     // 플래그가 지정된 계약을 승인한 경우
    ],
    channels: ["browser", "telegram", "email"]
  };
  
  return alertConfig;
};
```

---

## 토큰 승인 보안 모범 사례

### 보안 체크리스트

```bash
# 주간 루틴:
# 1. revoke.cash를 방문하여 모든 활성 승인을 스캔합니다
# 2. 적극적으로 사용하지 않는 프로토콜에 대한 무제한 승인을 취소합니다
# 3. 알 수 없는 지출자에 대해 "위험" 열을 확인합니다

# 모든 주요 거래 전:
# 1. Etherscan에서 계약 주소를 확인합니다
# 2. 지출자가 알려진 프로토콜인지 확인합니다
# 3. 무제한 승인을 요청하는 경우 대신 사용자 지정 한도를 설정합니다

# 프로토콜 취약점 발생 후:
# 1. 해당 프로토콜을 사용한 적이 있는지 즉시 revoke.cash를 확인합니다
# 2. 손상된 계약의 모든 승인을 취소합니다
# 3. 승인되지 않은 이체에 대해 주소를 모니터링합니다
```

### 제한된 승인 사용

```javascript
// 무제한 승인 대신 특정 금액 설정
const setLimitedApproval = async (token, spender, humanAmount) => {
  const decimals = await token.decimals();
  const amount = ethers.utils.parseUnits(humanAmount, decimals);
  
  // 필요한 것만 + 소량의 버퍼 승인
  const tx = await token.approve(spender, amount);
  await tx.wait();
  
  console.log(`${humanAmount} 토큰을 ${spender}에 대해 승인했습니다`);
};

// 예시: 스왑을 위해 1000 USDC만 승인
await setLimitedApproval(usdcContract, uniswapRouter, "1000");
```

### "번거 지갑" 전략

```javascript
// 새로운/테스트되지 않은 프로토콜 탐색을 위한:
// 1. 별도의 "번거" 지갑 생성
// 2. 잃을 수 있는 자금만 이체
// 3. 번거 지갑에서 승인 부여
// 4. 사용 후 모든 승인을 취소하고 남은 자금을 다시 스윕

const burnerStrategy = {
  maxFunds: "0.1 ETH",           // 최대 노출
  approvalPolicy: "LIMITED_ONLY", // 무제한은 절대 안 됨
  postUseAction: "REVOKE_ALL"     // 사용 후 항상 정리
};
```

---

## 자주 묻는 질문 (FAQ)

**Q1: Revoke.cash는 물론인가요?**
A: 네, Revoke.cash는 완전히 물론입니다. 커뮤니티에서 유지 관리하는 오픈소스 프로젝트(GPL-3.0)입니다. 취소 거래에 대한 표준 네트워크 가스 요금만 지불하면 됩니다. 브라우저 확장 프로그램도 물론입니다.

**Q2: Revoke.cash가 내 토큰을 훔칠 수 있나요?**
A: 아니요. Revoke.cash는 비수탁 인터페이스입니다 — 키를 보유하거나 특별한 액세스 권한이 없습니다. 모든 거래는 자신의 지갑을 통해 직접 서명합니다. 코드는 GitHub에서 완전히 오픈소스이며 감사 가능합니다.

**Q3: 취소와 지갑 연결 해제의 차이점은 무엇인가요?**
A: 지갑 연결 해제는 Revoke.cash에 대한 프론트엔드 연결만 제거합니다. 블록체인에서 토큰 승인을 제거하지 않습니다. 취소는 스마트 계약이 귀하의 토큰을 지출할 수 있는 권한을 영구적으로 제거하는 온체인 작업입니다.

**Q4: 모든 블록체인에서 별도로 승인을 취소해야 하나요?**
A: 네, 토큰 승인은 체인별로 다릅니다. Ethereum에서 Uniswap에 대해 USDC를 승인했다면 해당 승인은 Ethereum에만 존재합니다. DeFi 프로토콜과 상호 작용한 각 체인에서 승인을 확인하고 취소해야 합니다.

**Q5: Permit2 승인은 무엇이며 어떻게 다른가요?**
A: Uniswap의 Permit2 시스템을 통해 오프체인 서명을 통한 가스 없는 승인이 가능합니다. 이들은 일반적인 온체인 트랜잭션으로 표시되지 않지만 여전히 지출 권한을 부여합니다. Revoke.cash는 전용 인터페이스를 통해 Permit2 허용 한도를 감지하고 취소할 수 있습니다.

**Q6: 신뢰할 수 있는 프로토콜의 승인도 모두 취소해야 하나요?**
A: 반드시 그런 것은 아닙니다. 정기적으로 사용하는 프로토콜(Aave나 Uniswap 등)의 경우 승인을 유지하는 것이 편리하고 확립된 프로토콜의 위험은 낮습니다. 다음에 중점을 두세요: (1) 무제한 승인, (2) 더 이상 사용하지 않는 프로토콜에 대한 승인, (3) 알 수 없는 계약에 대한 승인.

**Q7: 누군가 승인을 통해 내 NFT를 훔칠 수 있나요?**
A: 네! ERC-721 및 ERC-1155 토큰 승인은 ERC-20과 유사하게 작동합니다. NFT 마켓플레이스나 무작위 계약을 승인했다면 NFT를 전송할 수 있습니다. Revoke.cash는 NFT 승인 취소도 지원합니다 — 대시보드에서 "NFT" 탭을 찾아보세요.

**Q8: 승인을 취소하지 않으면 어떻게 되나요?**
A: 귀하의 토큰은 무기한 위험에 노출됩니다. 승인된 계약이 공격당하거나 해킹당하거나 악의적으로 변하면 승인된 전체 잔액이 단일 트랜잭션에서 소진될 수 있습니다. 많은 주목할만한 해킹(예: 6억 달러 Poly Network 취약점)은 잔류 승인으로 인해 가능했습니다.

---



## 추천 호스팅 및 인프라

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영을 지원합니다.*

## 결론

DeFi에서 보안은 일회성 설정이 아니라 지속적인 관행입니다. Revoke.cash는 **2,500개 이상의 GitHub 스타**, **브라우저 확장 프로그램** 및 **멀티체인 지원**을 통해 토큰 승인을 감사하고 관리하는 가장 간단하면서도 가장 효과적인 방법을 제공합니다.

**10억 달러 이상의 보호 자산**과 손상된 프로토콜에 대한 정기적인 보안 경고와 함께, Revoke.cash는 모든 암호화폐 사용자의 보안 스택에서 필수적인 도구임을 입증했습니다. 주간 습관으로 삼으세요 — revoke.cash에서 5분을 복고 전체 포트폴리오를 구할 수 있습니다.

**안전한 거래 장소를 찾고 계신가요? [Binance에 가입](https://www.bsmkweb.cc/register?ref=DIBI8)하세요 — 업계 최고의 보안, 최저 수수료 및 보험 기금 보호를 제공하는 세계 최대의 암호화폐 거래소입니다.**

---

*면책 조항: 본 문서는 정보 제공 목적으로만 작성되었으며 재무 또는 보안 조언을 구성하지 않습니다. 항상 계약 주소를 확인하고, 상당한 보유 자산에는 하드웨어 지갑을 사용하고, 좋은 운영 보안을 실천하세요. 이 게시물에는 제휴 링크가 포함되어 있으며, 파트너 링크를 사용하실 때 추가 비용 없이 보상을 받을 수 있습니다.*
