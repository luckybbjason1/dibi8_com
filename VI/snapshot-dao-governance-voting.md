---
title: 'snapshot-dao-governance-voting'
description: '{''en'': ''Comprehensive guide to Snapshot, the open-source off-chain DAO voting platform with 10M+ votes processed. Learn gas-free governance, voting strategies, delegation, SDK integration, and IPFS storage.'', ''zh'': ''Snapshot综合指南，这个开源链下DAO投票平台已处理超过1000万张选票。了解无Gas治理、投票策略、委托、SDK集成和IPFS存储。'', ''ko'': ''1,000만 개 이상의 투표를 처리한 오픈소스 오프체인 DAO 투표 플랫폼 Snapshot에 대한 종합 가이드. 가스 없는 거버넌스, 투표 전략, 위임, SDK 통합, IPFS 저장소를 알아보세요.'', ''vi'': ''Hướng dẫn toàn diện về Snapshot, nền tảng bỏ phiếu DAO off-chain mã nguồn mở đã xử lý 10M+ phiếu bầu. Tìm hiểu quản trị không tốn gas, chiến lược bỏ phiếu, ủy quyền, tích hợp SDK, và lưu trữ IPFS.''}'
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
github_repo: 'https://github.com/snapshot-labs/snapshot'
stars: 9500
maintainer: 'snapshot-labs'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: ['snapshot', 'dao', 'governance', 'voting', 'off-chain', 'eip-712', 'ipfs', 'delegation', 'defi', 'web3']
aliases:
- /vi/posts/snapshot-dao-governance-voting/
---

{{</* resource-info */>}}

**Ngày:** 2026-05-19  
**Danh mục:** AI Trading  
**Thẻ:** Snapshot, DAO, Quản trị, Bỏ phiếu, DeFi, Web3, IPFS, Blockchain  
**Công cụ:** [Snapshot](https://snapshot.org)  
**GitHub:** [snapshot-labs/snapshot](https://github.com/snapshot-labs/snapshot) — ⭐ 9,500 sao, Giấy phép MIT

---

> Quan tâm đến giao dịch token quản trị? Đăng ký trên [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) để bắt đầu giao dịch token DAO.

---

## 1. Giới thiệu: Tại sao Quản trị DAO quan trọng vào năm 2026

Các Tổ chức Tự trị Phi tập trung (DAO) đã thay đổi căn bản cách các cộng đồng đưa ra quyết định tập thể. Đến năm 2026, các DAO quản lý hơn **50 tỷ USD** tài sản kho bạc trên các giao thức DeFi, dự án NFT, mạng lưới hạ tầng và các tập thể đầu tư. Tuy nhiên, bỏ phiếu on-chain trên các mạng như Ethereum vẫn đắt đỏ một cách cấm đoán trong thờigian tắc nghẽn cao, với mỗi phiếu bầu tốn 5–50 USD phí gas. Rào cản tài chính này làm mất quyền của các chủ sở hữu token nhỏ hơn và làm suy yếu tinh thần dân chủ của phi tập trung hóa.

**Snapshot** xuất hiện như một giải pháp cho thách thức này. Được ra mắt bởi [Snapshot Labs](https://github.com/snapshot-labs), Snapshot là một nền tảng bỏ phiếu off-chain mã nguồn mở cho phép quản trị không tốn phí gas cho các DAO. Với hơn **10 triệu phiếu bầu** đã được xử lý, 9.500+ sao GitHub, và được áp dụng bởi hầu hết mọi giao thức DeFi lớn — bao gồm Uniswap, Aave, Compound, Balancer, và Gitcoin — Snapshot đã trở thành tiêu chuẩn ngành cho quản trị DAO.

Không giống như các hệ thống bỏ phiếu on-chain thực thi mỗi phiếu bầu như một giao dịch blockchain, Snapshot tận dụng **IPFS** cho lưu trữ dữ liệu phi tập trung và **Thông điệp Đã ký Ethereum** cho xác thực phiếu bầu. Kiến trúc này loại bỏ hoàn toàn chi phí gas trong khi duy trì khả năng xác minh mật mã và tính minh bạch. Các phiếu bầu được ký bằng khóa riêng của ngườidùng, chứng minh quyền sở hữu token mà không tốn gas.

Hướng dẫn toàn diện này khám phá kiến trúc, chiến lược bỏ phiếu, cơ chế ủy quyền, tích hợp SDK, và các mẫu triển khai thực tế của Snapshot cho các nhà phát triển và nhà vận hành DAO trong năm 2026.

---

## 2. Kiến trúc lõi: Snapshot cho phép Bỏ phiếu Không tốn Gas như thế nào

### 2.1 Mô hình Bỏ phiếu Off-Chain

Phương pháp tiếp cận cách mạng của Snapshot dựa trên việc tách biệt **tín hiệu bỏ phiếu** khỏi **thực thi bỏ phiếu**. Quản trị on-chain truyền thống yêu cầu mọi ngườitham gia gửi một giao dịch, trả phí gas tỷ lệ thuận với mức độ tắc nghẽn mạng. Snapshot đảo ngược mô hình này:

```typescript
// Bỏ phiếu on-chain truyền thống (đắt)
// Mỗi cử tri trả gas cho giao dịch này
await governorContract.castVote(
  proposalId,    // uint256
  support,       // 0=chống, 1=ủng hộ, 2=phiếu trắng
  { value: 0, gasPrice: 50000000000 } // ~$5-50 phí gas
);
```

```typescript
// Bỏ phiếu off-chain Snapshot (không tốn gas)
// Ngườidùng ký một thông điệp bằng ví — chi phí gas bằng không
const voteMessage = {
  from: userAddress,
  space: "uniswap.eth",           // không gian DAO
  proposal: proposalId,           // hash IPFS của đề xuất
  choice: 1,                      // 1=ủng hộ, 2=chống, 3=phiếu trắng
  reason: "Hỗ trợ đa dạng hóa kho bạc",
  app: "snapshot",                // ứng dụng khách bỏ phiếu
  metadata: '{}'                  // siêu dữ liệu JSON tùy chọn
};

// Ký với dữ liệu kiểu EIP-712 — hoàn toàn không tốn gas
const signature = await signer.signTypedData(
  domain,
  types,
  voteMessage
);
```

Thông điệp đã ký được phát sóng đến trung tâm của Snapshot và được ghim vào IPFS, tạo ra một bản ghi vĩnh viễn, có thể xác minh mà không cần giao dịch blockchain nào.

### 2.2 Lưu trữ Dữ liệu trên IPFS

Tất cả dữ liệu Snapshot — đề xuất, phiếu bầu, và không gian — được lưu trữ trên **Hệ thống Tệp Liên Hành tinh (IPFS)**, đảm bảo khả năng chống kiểm duyệt và tính vĩnh viễn:

```json
{
  "proposal": {
    "id": "QmYwAPJzv5CZsnAzt8auVK914vhC2pW9e4iPApvb1xUcGz",
    "ipfs": "QmYwAPJzv5CZsnAzt8auVK914vhC2pW9e4iPApvb1xUcGz",
    "title": "Đề xuất Đa dạng hóa Kho bạc Q2 2026",
    "body": "## Tóm tắt\n\nĐề xuất này tìm kiếm sự phê duyệt...",
    "choices": ["Ủng hộ", "Chống", "Phiếu trắng"],
    "start": 1716105600,
    "end": 1716710400,
    "snapshot": 18945231,
    "state": "closed",
    "author": "0x2775b1c75658Be0F640272CCb8c72ac986009e38",
    "space": {
      "id": "uniswap.eth",
      "name": "Uniswap"
    },
    "type": "single-choice",
    "scores": [12500000, 3200000, 450000],
    "scores_total": 16150000,
    "scores_updated": 1716710400,
    "votes": 1847
  }
}
```

Trường `snapshot` chỉ định số khối Ethereum mà tại đó số dư token được tính, ngăn chặn các cuộc tấn công flash loan và đảm bảo tính toán trọng số phiếu bầu công bằng.

---

## 3. Thiết lập Không gian DAO trên Snapshot

### 3.1 Tạo Không gian của bạn

Bất kỳ dự án nào cũng có thể tạo một không gian quản trị trên Snapshot. Quá trình này bao gồm cấu hình miền ENS và chọn lựa chiến lược:

```bash
# Bước 1: Đảm bảo bạn sở hữu một miền ENS
# ID không gian của bạn sẽ là tên ENS (ví dụ: mydao.eth)

# Bước 2: Thiết lập bản ghi văn bản ENS
# Đặt bản ghi snapshot trỏ đến cài đặt không gian
ens records set mydao.eth text snapshot "ipfs://Qm..."
```

```typescript
// Bước 3: Cấu hình cài đặt không gian qua API Snapshot
import snapshot from '@snapshot-labs/snapshot.js';

const spaceConfig = {
  name: "MyDAO Governance",
  about: "Quản trị phi tập trung cho giao thức MyDAO",
  avatar: "https://mydao.xyz/logo.png",
  network: "1",                    // Ethereum mainnet
  symbol: "MYDAO",                 // Ký hiệu token
  skin: "mydao",                   // Giao diện tùy chỉnh
  // Xác thực bỏ phiếu
  validation: {
    name: "basic",
    params: {}
  },
  // Chiến lược bỏ phiếu (trọng số token)
  strategies: [
    {
      name: "erc20-balance-of",
      params: {
        address: "0x1234...abcd",  // Hợp đồng token MYDAO
        decimals: 18,
        symbol: "MYDAO"
      }
    }
  ],
  // Ngưỡng đề xuất
  filters: {
    minScore: 1000,               // Số token tối thiểu để tạo đề xuất
    onlyMembers: false
  },
  // Thông số bỏ phiếu
  voting: {
    delay: 86400,                 // Trì hoãn bỏ phiếu 1 ngày
    period: 172800,               // Thờigian bỏ phiếu 2 ngày
    type: "single-choice",        // Phương pháp bỏ phiếu
    quorum: 100000                // Tham gia tối thiểu
  }
};

// Gửi cấu hình không gian
await snapshot.utils.subgraphRequest(
  'https://hub.snapshot.org/graphql',
  {
    space: {
      __args: { id: 'mydao.eth' },
      ...spaceConfig
    }
  }
);
```

### 3.2 Xác minh Không gian

Sau khi cấu hình, xác minh không gian của bạn có thể truy cập được:

```bash
# Truy vấn không gian qua GraphQL
curl -X POST https://hub.snapshot.org/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query { space(id: \"mydao.eth\") { id name about network symbol strategies { name params } } }"
  }'
```

```python
# Script xác minh Python
import requests

def verify_snapshot_space(space_id: str) -> dict:
    """Xác minh cấu hình không gian Snapshot."""
    query = """
    query GetSpace($id: String!) {
      space(id: $id) {
        id
        name
        about
        network
        symbol
        members
        admins
        moderators
        strategies {
          name
          params
        }
        filters {
          minScore
          onlyMembers
        }
        voting {
          delay
          period
          type
          quorum
        }
      }
    }
    """

    response = requests.post(
        "https://hub.snapshot.org/graphql",
        json={"query": query, "variables": {"id": space_id}},
        headers={"Content-Type": "application/json"}
    )

    data = response.json()

    if data.get("data", {}).get("space"):
        space = data["data"]["space"]
        print(f"Không gian '{space['name']}' xác minh thành công!")
        print(f"Mạng: {space['network']}")
        print(f"Chiến lược: {[s['name'] for s in space['strategies']]}")
        print(f"Điểm tối thiểu: {space['filters']['minScore']}")
        return space
    else:
        raise ValueError(f"Không tìm thấy không gian '{space_id}'")

# Xác minh
space = verify_snapshot_space("mydao.eth")
```

---

## 4. Chiến lược Bỏ phiếu: Quản trị Trọng số Token Linh hoạt

### 4.1 Thư viện Chiến lược Tích hợp

Snapshot hỗ trợ 50+ chiến lược bỏ phiếu quyết định cách tính quyền bỏ phiếu. Các chiến lược phổ biến nhất bao gồm:

| Chiến lược | Trường hợp sử dụng | Ví dụ DAO |
|------------|-------------------|-----------|
| `erc20-balance-of` | Số dư token đơn giản | Uniswap, Aave |
| `erc721` | Quyền sở hữu NFT | Bored Ape Yacht Club |
| `contract-call` | Logic tùy chỉnh qua hợp đồng thông minh | Compound |
| `delegation` | Quyền bỏ phiếu được ủy quyền | Gitcoin |
| `whitelist` | Cử tri được phê duyệt trước | Đầu tư DAO |
| `snapshot-multichain` | Số dư token đa chuỗi | Across Protocol |

### 4.2 Cấu hình Chiến lược Tùy chỉnh

```typescript
// Cấu hình đa chiến lược cho các DAO phức tạp
const advancedStrategies = [
  // Chiến lược 1: Token quản trị cơ bản
  {
    name: "erc20-balance-of",
    params: {
      address: "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984", // UNI
      decimals: 18,
      symbol: "UNI"
    }
  },
  // Chiến lược 2: Token đã stake trong kho tiền
  {
    name: "contract-call",
    params: {
      address: "0xA4eC3511849f88F1A6b09E8426f85e0fc70F6e5B",
      decimals: 18,
      symbol: "stUNI",
      methodABI: {
        name: "balanceOf",
        type: "function",
        inputs: [{ name: "account", type: "address" }],
        outputs: [{ name: "balance", type: "uint256" }],
        stateMutability: "view"
      }
    }
  },
  // Chiến lược 3: Token LP với hệ số nhân
  {
    name: "erc20-balance-of-with-multiplier",
    params: {
      address: "0x1d42064Fc4Beb5F8aAF85F4617AE8b3b5B8Bd801", // UNI/ETH LP
      decimals: 18,
      symbol: "UNI-LP",
      multiplier: 2  // Quyền bỏ phiếu gấp 2 cho chủ sở hữu LP
    }
  }
];

// Tính quyền bỏ phiếu cho một địa chỉ
async function getVotingPower(
  address: string,
  strategies: any[],
  snapshot: number  // số khối
): Promise<bigint> {
  const response = await fetch('https://score.snapshot.org/api/scores', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      params: {
        space: "mydao.eth",
        network: "1",
        strategies,
        addresses: [address],
        snapshot
      }
    })
  });

  const data = await response.json();
  return BigInt(data.result.scores[0][address] || 0);
}

// Ví dụ sử dụng
const votingPower = await getVotingPower(
  "0x2775b1c75658Be0F640272CCb8c72ac986009e38",
  advancedStrategies,
  18945231
);
console.log(`Quyền bỏ phiếu: ${votingPower} token`);
```

### 4.3 Chiến lược Bỏ phiếu Bậc hai

Đối với các DAO tìm kiếm kết quả dân chủ hơn, Snapshot hỗ trợ bỏ phiếu bậc hai:

```json
{
  "strategy": {
    "name": "quadratic-balance-of",
    "params": {
      "address": "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984",
      "decimals": 18,
      "symbol": "UNI",
      "coefficient": 1  // sqrt(token_balance) * hệ số
    }
  }
}
```

Với bỏ phiếu bậc hai, ngườidùng có 10.000 token có 100 quyền bỏ phiếu (√10.000), trong khi ngườidùng có 100 token có 10 quyền bỏ phiếu (√100) — giảm ảnh hưởng của chủ sở hữu cá voi.

---

## 5. Ủy quyền: Nền Dân chủ Đại diện trong DAO

### 5.1 Ủy quyền Hoạt động như thế nào

Ủy quyền cho phép chủ sở hữu token giao quyền bỏ phiếu của họ cho các đại diện đáng tin cậy, tăng tỷ lệ tham gia và cho phép chuyên môn hóa quản trị:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVotingDelegate {
    /// @notice Ủy quyền quyền bỏ phiếu cho một đại diện
    /// @param delegatee Địa chỉ nhận quyền bỏ phiếu
    function delegate(address delegatee) external;

    /// @notice Lấy số phiếu hiện tại cho một tài khoản
    /// @param account Địa chỉ cần kiểm tra
    /// @return votes Quyền bỏ phiếu hiện tại
    function getCurrentVotes(address account) external view returns (uint96);

    /// @notice Lấy phiếu trước đó tại một khối cụ thể
    /// @param account Địa chỉ cần kiểm tra
    /// @param blockNumber Số khối cho tra cứu lịch sử
    /// @return votes Quyền bỏ phiếu tại khối đó
    function getPriorVotes(
        address account,
        uint256 blockNumber
    ) external view returns (uint96);
}
```

```typescript
// Thiết lập Ủy quyền Snapshot
import Snapshot from '@snapshot-labs/snapshot.js';

const client = new Snapshot.Client712('https://hub.snapshot.org');

// Tạo giao dịch ủy quyền (không tốn gas qua chữ ký)
async function delegateVotingPower(
  signer: any,
  delegator: string,
  delegatee: string,
  space: string  // "uniswap.eth" hoặc rỗng cho toàn cục
): Promise<string> {
  const delegation = {
    delegatee,
    space,        // Chuỗi rỗng = ủy quyền toàn cục
    timestamp: Math.floor(Date.now() / 1000)
  };

  const receipt = await client.delegate(
    signer,
    delegator,
    delegation
  );

  return receipt;  // Hash IPFS của bản ghi ủy quyền
}

// Ủy quyền phiếu UNI cho một chuyên gia quản trị
const txHash = await delegateVotingPower(
  signer,
  "0xMyAddress...",
  "0xGovernanceExpert...",  // Đại diện đáng tin cậy
  "uniswap.eth"             // Ủy quyền theo không gian
);

console.log(`Bản ghi ủy quyền: ${txHash}`);
```

### 5.2 Truy vấn Bảng điều khiển Ủy quyền

```graphql
# Truy vấn các ủy quyền hiện tại cho một không gian
query GetDelegations($space: String!, $delegate: String!) {
  delegations(
    where: {
      space: $space,
      delegate: $delegate
    },
    orderBy: timestamp,
    orderDirection: desc
  ) {
    id
    delegator
    delegate
    space
    timestamp
  }
}
```

```bash
# Thực thi truy vấn ủy quyền
curl -X POST https://hub.snapshot.org/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query { delegations(where: {space: \"uniswap.eth\", delegate: \"0x2775b1c75658Be0F640272CCb8c72ac986009e38\"}) { delegator timestamp } }"
  }'
```

---

## 6. Tích hợp Chương trình: Snapshot SDK

### 6.1 Cài đặt và Thiết lập

```bash
# Cài đặt Snapshot.js SDK
npm install @snapshot-labs/snapshot.js ethers

# Hoặc với yarn
yarn add @snapshot-labs/snapshot.js ethers
```

```typescript
// Khởi tạo ứng dụng khách Snapshot
import snapshot from '@snapshot-labs/snapshot.js';
import { Wallet } from 'ethers';

const hub = 'https://hub.snapshot.org';  // Hub mainnet
const client = new snapshot.Client712(hub);

// Thiết lập nhà cung cấp và ngườiký
const provider = new ethers.JsonRpcProvider('https://eth.llamarpc.com');
const signer = new Wallet(process.env.PRIVATE_KEY, provider);
```

### 6.2 Tạo Đề xuất qua Chương trình

```typescript
// Tạo đề xuất quản trị qua SDK
async function createProposal(
  signer: any,
  author: string,
  space: string
): Promise<string> {
  const proposal = {
    space: "mydao.eth",
    type: "single-choice",        // "single-choice" | "approval" | "quadratic" | "ranked-choice" | "weighted"
    title: "Đề xuất Phân bổ Kho bạc Q2 2026",
    body: `## Tóm tắt

Đề xuất này phân bổ quỹ kho bạc cho hoạt động Q2 2026.

## Chi tiết

- Phát triển: 40% (800 ETH)
- Marketing: 30% (600 ETH)
- Kiểm toán bảo mật: 20% (400 ETH)
- Tài trợ cộng đồng: 10% (200 ETH)

## Triển khai

Nếu được thông qua, đa chữ ký kho bạc sẽ thực hiện chuyển khoản trong vòng 7 ngày.

## Tài liệu tham khảo

- [Báo cáo Kho bạc Q1 2026](https://mydao.xyz/treasury/q1-2026)
- [Bảng tính Ngân sách](https://mydao.xyz/budget/q2-2026)`,
    choices: ["Ủng hộ", "Chống", "Phiếu trắng"],
    start: Math.floor(Date.now() / 1000) + 86400,    // Bắt đầu sau 24h
    end: Math.floor(Date.now() / 1000) + 259200,      // Kết thúc sau 72h
    snapshot: await provider.getBlockNumber(),         // Khối hiện tại
    discussion: "https://forum.mydao.xyz/t/q2-treasury",
    plugins: '{}',
    app: "mydao-governance"
  };

  const receipt = await client.proposal(
    signer,
    author,
    proposal
  );

  return receipt;  // Trả về hash IPFS
}

// Thực thi
const proposalId = await createProposal(
  signer,
  "0xAuthorAddress...",
  "mydao.eth"
);

console.log(`Đề xuất đã tạo: ${proposalId}`);
```

### 6.3 Bỏ phiếu qua API

```typescript
// Gửi phiếu bầu qua chương trình
async function castVote(
  signer: any,
  voter: string,
  proposalId: string,
  choice: number,      // 1=Ủng hộ, 2=Chống, 3=Phiếu trắng
  reason: string
): Promise<string> {
  const vote = {
    space: "mydao.eth",
    proposal: proposalId,     // Hash IPFS từ tạo đề xuất
    type: "single-choice",
    choice: choice,
    reason: reason,
    app: "mydao-governance",
    metadata: '{}'
  };

  const receipt = await client.vote(
    signer,
    voter,
    vote
  );

  return receipt;  // Hash IPFS của phiếu bầu
}

// Bỏ phiếu với lý do
const voteReceipt = await castVote(
  signer,
  "0xVoterAddress...",
  "QmYwAPJzv5CZsnAzt8auVK914vhC2pW9e4iPApvb1xUcGz",
  1,  // Ủng hộ
  "Ủng hộ đề xuất này vì phân bổ ngân sách phù hợp với các ưu tiên chiến lược được nêu trong lộ trình."
);

console.log(`Phiếu bầu đã ghi nhận: ${voteReceipt}`);
```

### 6.4 Truy vấn Bỏ phiếu Hàng loạt

```typescript
// Truy vấn tất cả phiếu bầu cho một đề xuất
async function getProposalVotes(
  proposalId: string,
  first: number = 100,
  skip: number = 0
): Promise<any[]> {
  const query = `
    query GetVotes($proposal: String!, $first: Int!, $skip: Int!) {
      votes(
        where: { proposal: $proposal }
        first: $first
        skip: $skip
        orderBy: "created"
        orderDirection: desc
      ) {
        id
        voter
        choice
        vp          // quyền bỏ phiếu
        vp_by_strategy
        reason
        created
        ipfs
      }
    }
  `;

  const response = await fetch('https://hub.snapshot.org/graphql', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      query,
      variables: { proposal: proposalId, first, skip }
    })
  });

  const data = await response.json();
  return data.data.votes;
}

// Lấy thống kê phiếu bầu
async function getVoteStats(proposalId: string): Promise<any> {
  const votes = await getProposalVotes(proposalId, 1000);

  const stats = {
    totalVotes: votes.length,
    totalVotingPower: votes.reduce((sum, v) => sum + parseFloat(v.vp), 0),
    results: {}
  };

  votes.forEach(vote => {
    const choice = vote.choice;
    if (!stats.results[choice]) {
      stats.results[choice] = { count: 0, vp: 0 };
    }
    stats.results[choice].count++;
    stats.results[choice].vp += parseFloat(vote.vp);
  });

  return stats;
}

// Sử dụng
const stats = await getVoteStats("QmYwAPJzv5CZsnAzt8auVK914vhC2pW9e4iPApvb1xUcGz");
console.log(`Tổng cử tri: ${stats.totalVotes}`);
console.log(`Tổng VP: ${stats.totalVotingPower}`);
console.log("Kết quả:", stats.results);
```

---

## 7. Tích hợp Đa chuỗi và Đa nền tảng

### 7.1 Chiến lược Bỏ phiếu Đa chuỗi

Snapshot hỗ trợ bỏ phiếu trên nhiều blockchain đồng thờigian:

```typescript
// Chiến lược đa chuỗi: tổng hợp token trên các mạng
const multichainStrategies = [
  {
    name: "erc20-balance-of",
    network: "1",  // Ethereum
    params: {
      address: "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984",
      decimals: 18,
      symbol: "UNI"
    }
  },
  {
    name: "erc20-balance-of",
    network: "137",  // Polygon
    params: {
      address: "0xb33EaAd8d922B1083446DC23f610c2567fB5180f",
      decimals: 18,
      symbol: "UNI"
    }
  },
  {
    name: "erc20-balance-of",
    network: "42161",  // Arbitrum
    params: {
      address: "0xFa7F8980b0f1E64A2062791cc3b0871572f1F7f0",
      decimals: 18,
      symbol: "UNI"
    }
  }
];

// Lấy quyền bỏ phiếu kết hợp trên các chuỗi
const scores = await snapshot.utils.getScores(
  "uniswap.eth",
  multichainStrategies,
  "1",  // Mạng chính
  ["0xVoterAddress..."],
  await provider.getBlockNumber()
);

console.log("Quyền bỏ phiếu đa chuỗi:", scores);
```

### 7.2 Thông báo Webhook

```typescript
// Thiết lập webhook cho sự kiện đề xuất
import express from 'express';

const app = express();
app.use(express.json());

// Điểm cuối Webhook Snapshot
app.post('/webhooks/snapshot', (req, res) => {
  const event = req.body;

  switch (event.event) {
    case 'proposal/created':
      console.log(`Đề xuất mới: ${event.id}`);
      notifyDiscord(event);
      break;
    case 'proposal/end':
      console.log(`Bỏ phiếu kết thúc: ${event.id}`);
      tallyResults(event);
      break;
    case 'vote':
      console.log(`Phiếu bầu mới trên ${event.proposal.id}`);
      updateLeaderboard(event);
      break;
  }

  res.status(200).send('OK');
});

function notifyDiscord(proposal: any) {
  // Gửi thông báo đến webhook Discord
  const message = {
    embeds: [{
      title: `📋 Đề xuất Mới: ${proposal.title}`,
      url: `https://snapshot.org/#/${proposal.space.id}/proposal/${proposal.id}`,
      description: proposal.body.substring(0, 200) + '...',
      fields: [
        { name: 'Không gian', value: proposal.space.name, inline: true },
        { name: 'Tác giả', value: proposal.author, inline: true },
        { name: 'Ngày kết thúc', value: new Date(proposal.end * 1000).toISOString(), inline: true }
      ],
      timestamp: new Date().toISOString()
    }]
  };

  fetch(process.env.DISCORD_WEBHOOK_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(message)
  });
}

app.listen(3000, () => console.log('Máy chủ Webhook đang lắng nghe trên cổng 3000'));
```

---

## 8. Trường hợp Sử dụng Thực tế và Thực tiễn Tốt nhất

### 8.1 Thay đổi Thông số Giao thức

Các giao thức DeFi sử dụng Snapshot để bỏ phiếu về các thông số quan trọng:

```typescript
// Đề xuất thông số rủi ro kiểu Aave
interface RiskParameterProposal {
  asset: string;              // Địa chỉ token
  parameter: string;          // "ltv" | "liquidationThreshold" | "reserveFactor"
  currentValue: number;
  proposedValue: number;
  justification: string;
  riskAnalysis: string;       // Liên kết phân tích Gauntlet/Chaos
}

const aaveProposal: RiskParameterProposal = {
  asset: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2", // WETH
  parameter: "liquidationThreshold",
  currentValue: 8250,         // 82.5%
  proposedValue: 8000,        // 80.0%
  justification: "Giảm tiếp xúc rủi ro do biến động thị trường",
  riskAnalysis: "https://gauntlet.network/analyses/aave-weth-2026-05"
};
```

### 8.2 Quản lý Kho bạc

```typescript
// Danh mục bỏ phiếu phân bổ kho bạc
interface TreasuryProposal {
  totalAllocation: bigint;
  allocations: Allocation[];
  vestingSchedule: VestingTerms;
}

interface Allocation {
  category: string;
  percentage: number;
  amount: bigint;
  recipient: string;
  unlockDate: number;
}

const treasuryVote: TreasuryProposal = {
  totalAllocation: BigInt("2000000000000000000000"), // 2.000 ETH
  allocations: [
    { category: "Phát triển", percentage: 40, amount: BigInt("800000000000000000000"), recipient: "0xDevMultisig...", unlockDate: 1719792000 },
    { category: "Marketing", percentage: 30, amount: BigInt("600000000000000000000"), recipient: "0xMktMultisig...", unlockDate: 1719792000 },
    { category: "Bảo mật", percentage: 20, amount: BigInt("400000000000000000000"), recipient: "0xSecMultisig...", unlockDate: 1719792000 },
    { category: "Tài trợ", percentage: 10, amount: BigInt("200000000000000000000"), recipient: "0xGrtMultisig...", unlockDate: 1719792000 }
  ],
  vestingSchedule: {
    cliff: 90 * 86400,      // Thờigian chờ 90 ngày
    duration: 365 * 86400,  // Vesting 1 năm
    interval: 30 * 86400    // Phát hành hàng tháng
  }
};
```

### 8.3 Thực tiễn Bảo mật Tốt nhất

```yaml
# snapshot-security-checklist.yml
space_security:
  admin_keys:
    - use_multisig: true
    - minimum_signers: 3
    - hardware_wallets_required: true

  proposal_validation:
    - min_score_threshold: 10000
    - require_forum_discussion: true
    - discussion_min_duration: "7 ngày"

  voting_security:
    - snapshot_block: "sử dụng khối tạo đề xuất"
    - voting_delay: "tối thiểu 24 giờ"
    - voting_period: "tối thiểu 3 ngày"
    - quorum_required: true

  monitoring:
    - enable_webhooks: true
    - discord_notifications: true
    - unusual_activity_alerts: true
    - delegate_change_alerts: true
```

---

## 9. Câu hỏi Thường gặp (FAQ)

### 9.1 Snapshot là gì và nó khác gì với quản trị on-chain?

Snapshot là một nền tảng **bỏ phiếu off-chain** cho DAO loại bỏ chi phí gas trong khi duy trì bảo mật mật mã. Khác với quản trị on-chain (ví dụ: Governor Bravo của Compound), nơi mỗi phiếu bầu là một giao dịch blockchain với phí gas 5-50 USD, Snapshot sử dụng **Thông điệp đã ký EIP-712** được lưu trữ trên IPFS. Điều này làm cho việc tham gia có thể tiếp cận được với mọi chủ sở hữu token bất kể kích thước danh mục. Đánh đổi là các phiếu bầu Snapshot không tự động thực thi — chúng cần một giao dịch on-chain riêng biệt (thường qua đa chữ ký hoặc hợp đồng timelock) để thực hiện quyết định.

### 9.2 Bỏ phiếu Snapshot có an toàn không? Có thể thao túng phiếu bầu không?

Bỏ phiếu Snapshot an toàn về mặt mật mã. Mỗi phiếu bầu được ký bằng khóa riêng của cử tri sử dụng dữ liệu kiểu EIP-712, làm cho chúng không thể can thiệp. Dữ liệu phiếu bầu được ghim vào IPFS, đảm bảo lưu trữ vĩnh viễn, chống kiểm duyệt. Tuy nhiên, **bản chất off-chain của Snapshot có nghĩa là thực thi phiếu bầu không tự động** — các bên ký đa chữ ký của DAO phải thực thi ý chí của cử tri on-chain. Điều này tạo ra một lớp "hợp đồng xã hội" niềm tin. Nhiều DAO giảm thiểu điều này bằng cách sử dụng **Snapshot + Safe (Gnosis Safe)** cùng nhau.

### 9.3 Quyền bỏ phiếu và số dư token được tính như thế nào?

Quyền bỏ phiếu được xác định bởi các **chiến lược** được cấu hình cho mỗi không gian. Chiến lược phổ biến nhất là `erc20-balance-of`, kiểm tra số dư token của cử tri tại một số khối cụ thể (khối `snapshot`). Điều này ngăn chặn:
- **Tấn công flash loan**: Token vay trong cùng một giao dịch không thể dùng để bỏ phiếu
- **Bỏ phiếu kép**: Cùng một token không thể di chuyển và bỏ phiếu lại
- **Tích lũy phút cuối**: Ngườidùng không thể mua token sau khi đề xuất được tạo để ảnh hưởng đến phiếu bầu

Nhiều chiến lược có thể được kết hợp, và các chiến lược tùy chỉnh cho phép logic phức tạp như token đã stake, vị thế LP, nắm giữ NFT, hoặc quyền bỏ phiếu được ủy quyền.

### 9.4 Tôi có thể ủy quyền quyền bỏ phiếu của mình cho ngườikhác không?

Có, **Ủy quyền** là một tính năng cốt lõi của quản trị Snapshot. Chủ sở hữu token có thể ủy quyền quyền bỏ phiếu của họ cho các đại diện đáng tin cậy — thường là chuyên gia quản trị, ngườicóng hiến lõi, hoặc thành viên cộng đồng tích cực. Điều này đặc biệt có giá trị cho:
- **Chủ sở hữu nhỏ** thiếu thờigian nghiên cứu đề xuất
- **Chủ sở hữu tổ chức** thích sự tham gia quản trị chuyên nghiệp
- **Tăng quórum** bằng cách tổng hợp các phiếu bầu không hoạt động

Ủy quyền có thể là **theo không gian** (chỉ cho một DAO) hoặc **toàn cục** (trên tất cả các không gian Snapshot). Các phiếu bầu được ủy quyền có thể được thu hồi bất cứ lúc nào, và đại diện có thể được thay đổi không bị phạt. Giao diện Snapshot cung cấp một [trang ủy quyền chuyên dụng](https://snapshot.org/#/delegate).

### 9.5 Làm thế nào để tích hợp Snapshot vào ứng dụng của riêng tôi?

Snapshot cung cấp nhiều tùy chọn tích hợp:
- **Snapshot.js SDK**: SDK JavaScript đầy đủ tính năng cho tạo đề xuất, bỏ phiếu, và ủy quyền
- **GraphQL API**: Truy vấn đề xuất, phiếu bầu, không gian, và quyền bỏ phiếu qua điểm cuối GraphQL công khai
- **Webhook**: Thông báo thờigian thực cho các sự kiện đề xuất
- **Embed**: Tích hợp iframe để nhúng giao diện bỏ phiếu vào dApp của bạn

Mô hình tích hợp phổ biến nhất là sử dụng API GraphQL để hiển thị dữ liệu quản trị trong frontend của bạn, kết hợp với SDK để gửi phiếu bầu. Tất cả các tích hợp yêu cầu kết nối ví tương thích Ethereum (MetaMask, WalletConnect, v.v.).

---



## Hosting Và Hạ Tầng Được Đề Xuất

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit $200 trong 60 ngày.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## 10. Kết luận: Tương lai của Quản trị Phi tập trung

Snapshot đã dân chủ hóa quản trị DAO một cách căn bản bằng cách loại bỏ rào cản tài chính đối với việc tham gia. Với **hơn 10 triệu phiếu bầu đã xử lý**, hỗ trợ **50+ chiến lược bỏ phiếu**, khả năng tương thích đa chuỗi, và hệ sinh thái SDK mạnh mẽ, Snapshot là cơ sở hạ tầng nền tảng cho ra quyết định phi tập trung vào năm 2026.

Khi các DAO phát triển hướng tới tự động hóa lớn hơn, chúng tôi mong đợi thấy sự tích hợp sâu hơn giữa tín hiệu off-chain của Snapshot và thực thi on-chain thông qua **Safe{Core}**, **Mô-đun Zodiac**, và **Tóm tắt Tài khoản (ERC-4337)**. Sự xuất hiện của **Quản trị hỗ trợ AI** — nơi các mô hình ngôn ngữ phân tích đề xuất và cung cấp khuyến nghị bỏ phiếu — sẽ thay đổi thêm cách cộng đồng tham gia vào ra quyết định tập thể.

Đối với các nhà phát triển xây dựng thế hệ công cụ quản trị tiếp theo, cơ sở mã MIT được cấp phép, cộng đồng nhà phát triển tích cực, và kiến trúc mô-đun của Snapshot cung cấp một nền tảng lý tưởng. Dù bạn đang khởi chạy một giao thức DeFi mới, quản lý một cộng đồng NFT, hoặc xây dựng hạ tầng cho các tổ chức phi tập trung, Snapshot cung cấp sự linh hoạt, bảo mật, và khả năng mở rộng cần thiết cho quản trị DAO hiện đại.

---

> **Bắt đầu giao dịch token quản trị ngay hôm nay!** Đăng ký trên [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) để mua, bán, và stake token từ các DAO hàng đầu như Uniswap, Aave, và Compound.

---

**Giấy phép:** MIT  
**Ngườibảo trì:** [Snapshot Labs](https://github.com/snapshot-labs)  
**Sao GitHub:** 9.500+  
**Trang web:** [snapshot.org](https://snapshot.org)
