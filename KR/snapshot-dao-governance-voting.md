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
- /kr/posts/snapshot-dao-governance-voting/
---

{{</* resource-info */>}}

**날짜:** 2026-05-19  
**카테고리:** AI 트레이딩  
**태그:** Snapshot, DAO, 거버넌스, 투표, DeFi, Web3, IPFS, 블록체인  
**도구:** [Snapshot](https://snapshot.org)  
**GitHub:** [snapshot-labs/snapshot](https://github.com/snapshot-labs/snapshot) — ⭐ 9,500 스타, MIT 라이선스

---

> 거버넌스 토큰 거래에 관심이 있으신가요? [바이낸스](https://www.bsmkweb.cc/register?ref=DIBI8)에 가입하여 DAO 토큰 거래를 시작하세요.

---

## 1. 소개: 2026년 DAO 거버넌스가 중요한 이유

탈중앙화 자율 조직(DAO)은 커뮤니티가 집단적 결정을 내리는 방식을 근본적으로 변화시켰습니다. 2026년까지 DAO는 DeFi 프로토콜, NFT 프로젝트, 인프라 네트워크 및 투자 집단 전반에 걸쳐 500억 달러 이상의 재무 자산을 관리합니다. 그러나 이더리움과 같은 네트워크에서 온체인 투표는 높은 혼잡 기간 동안 여전히 비용이 너무 비싸며, 단일 투표에 5~50달러의 가스비가 듭니다. 이러한 재정적 장벽은 소규모 토큰 보유자의 참여를 제한하고 탈중앙화의 민주적 정신을 훼손합니다.

**Snapshot**은 이러한 과제에 대한 확실한 솔루션으로 등장했습니다. [Snapshot Labs](https://github.com/snapshot-labs)에서 출시한 Snapshot은 DAO를 위한 가스 없는 거버넌스를 가능하게 하는 오픈소스 오프체인 투표 플랫폼입니다. **1,000만 개 이상의 투표**를 처리하고 GitHub에서 9,500개 이상의 스타를 보유하며, Uniswap, Aave, Compound, Balancer, Gitcoin을 포함한 거의 모든 주요 DeFi 프로토콜에서 채택되어 Snapshot은 DAO 거버넌스의 업계 표준이 되었습니다.

온체인 투표 시스템과 달리 Snapshot은 **IPFS**를 분산형 데이터 저장소로, **이더리움 서명 메시지**를 투표 인증으로 활용합니다. 이 아키텍처는 암호화학적 검증성과 투명성을 유지하면서 가스 비용을 완전히 제거합니다. 투표는 사용자의 개인 키로 서명되어 가스를 소비하지 않고 토큰 소유권을 증명합니다.

이 종합 가이드는 2026년 개발자와 DAO 운영자를 위한 Snapshot의 아키텍처, 투표 전략, 위임 메커니즘, SDK 통합 및 실제 구현 패턴을 살펴 봅니다.

---

## 2. 핵심 아키텍처: Snapshot이 가스 없는 투표를 가능하게 하는 방법

### 2.1 오프체인 투표 패러다임

Snapshot의 혁명적인 접근 방식은 **투표 신호**와 **투표 실행**을 분리하는 것에 기반합니다. 기존 온체인 거버넌스는 모든 참가자가 네트워크 혼잡에 비례하는 가스비를 지불하는 트랜잭션을 제출해야 합니다. Snapshot은 이 모델을 뒤집습니다:

```typescript
// 기존 온체인 투표 (비쌈)
// 각 투표자가 이 트랜잭션에 대해 가스비를 지불
await governorContract.castVote(
  proposalId,    // uint256
  support,       // 0=반대, 1=찬성, 2=기권
  { value: 0, gasPrice: 50000000000 } // ~$5-50 가스비
);
```

```typescript
// Snapshot 오프체인 투표 (가스 없음)
// 사용자가 지갑으로 메시지 서명 — 가스비 제로
const voteMessage = {
  from: userAddress,
  space: "uniswap.eth",           // DAO 네임스페이스
  proposal: proposalId,           // 제안의 IPFS 해시
  choice: 1,                      // 1=찬성, 2=반대, 3=기권
  reason: "재무 다각화 지원",
  app: "snapshot",                // 투표 클라이언트
  metadata: '{}'                  // 선택적 JSON 메타데이터
};

// EIP-712 타입 데이터 서명 — 완전히 가스 없음
const signature = await signer.signTypedData(
  domain,
  types,
  voteMessage
);
```

서명된 메시지는 Snapshot의 허브에 브로드캐스트되고 IPFS에 고정되어 블록체인 트랜잭션 없이 영구적이고 검증 가능한 기록을 생성합니다.

### 2.2 IPFS 기반 데이터 저장소

모든 Snapshot 데이터 — 제안, 투표, 스페이스 —는 **IPFS(성간 파일 시스템)**에 저장되어 검열 저항성과 영구성을 보장합니다:

```json
{
  "proposal": {
    "id": "QmYwAPJzv5CZsnAzt8auVK914vhC2pW9e4iPApvb1xUcGz",
    "ipfs": "QmYwAPJzv5CZsnAzt8auVK914vhC2pW9e4iPApvb1xUcGz",
    "title": "2026년 2분기 재무 다각화 제안",
    "body": "## 요약\n\n본 제안은 승인을 요청합니다...",
    "choices": ["찬성", "반대", "기권"],
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

`snapshot` 필드는 토큰 잔액을 계산하는 이더리움 블록 번호를 지정하여 플래시론 공격을 방지하고 공정한 투표 가중치 계산을 보장합니다.

---

## 3. Snapshot에서 DAO 스페이스 설정

### 3.1 스페이스 생성

모든 프로젝트는 Snapshot에서 거버넌스 스페이스를 만들 수 있습니다. 이 과정에는 ENS 도메인 구성과 전략 선택이 포함됩니다:

```bash
# 1단계: ENS 도메인 소유 확인
# 스페이스 ID는 ENS 이름이 됩니다 (예: mydao.eth)

# 2단계: ENS 텍스트 레코드 설정
# 스냅샷 레코드를 스페이스 설정으로 지정
ens records set mydao.eth text snapshot "ipfs://Qm..."
```

```typescript
// 3단계: Snapshot API를 통해 스페이스 설정 구성
import snapshot from '@snapshot-labs/snapshot.js';

const spaceConfig = {
  name: "MyDAO 거버넌스",
  about: "MyDAO 프로토콜의 탈중앙화 거버넌스",
  avatar: "https://mydao.xyz/logo.png",
  network: "1",                    // 이더리움 메인넷
  symbol: "MYDAO",                 // 토큰 심볼
  skin: "mydao",                   // 커스텀 테마
  // 투표 검증
  validation: {
    name: "basic",
    params: {}
  },
  // 투표 전략 (토큰 가중)
  strategies: [
    {
      name: "erc20-balance-of",
      params: {
        address: "0x1234...abcd",  // MYDAO 토큰 계약
        decimals: 18,
        symbol: "MYDAO"
      }
    }
  ],
  // 제안 임계값
  filters: {
    minScore: 1000,               // 제안 생성 최소 토큰 수
    onlyMembers: false
  },
  // 투표 매개변수
  voting: {
    delay: 86400,                 // 1일 투표 지연
    period: 172800,               // 2일 투표 기간
    type: "single-choice",        // 투표 방식
    quorum: 100000                // 최소 참여도
  }
};

// 스페이스 설정 제출
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

### 3.2 스페이스 검증

구성 후 스페이스에 접근 가능한지 확인합니다:

```bash
# GraphQL을 통해 스페이스 조회
curl -X POST https://hub.snapshot.org/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query { space(id: \"mydao.eth\") { id name about network symbol strategies { name params } } }"
  }'
```

```python
# Python 검증 스크립트
import requests

def verify_snapshot_space(space_id: str) -> dict:
    """Snapshot 스페이스 구성을 검증합니다."""
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
        print(f"스페이스 '{space['name']}' 검증 성공!")
        print(f"네트워크: {space['network']}")
        print(f"전략: {[s['name'] for s in space['strategies']]}")
        print(f"최소 점수: {space['filters']['minScore']}")
        return space
    else:
        raise ValueError(f"스페이스 '{space_id}'를 찾을 수 없음")

# 검증
space = verify_snapshot_space("mydao.eth")
```

---

## 4. 투표 전략: 유연한 토큰 가중 거버넌스

### 4.1 내장 전략 라이브러리

Snapshot은 투표권 계산 방법을 결정하는 50개 이상의 투표 전략을 지원합니다. 가장 일반적으로 사용되는 전략은 다음과 같습니다:

| 전략 | 사용 사례 | 예시 DAO |
|------|----------|----------|
| `erc20-balance-of` | 단순 토큰 잔액 | Uniswap, Aave |
| `erc721` | NFT 소유권 | Bored Ape Yacht Club |
| `contract-call` | 스마트 컨트랙트를 통한 커스텀 로직 | Compound |
| `delegation` | 위임된 투표권 | Gitcoin |
| `whitelist` | 사전 승인된 투표자 | 투자 DAO |
| `snapshot-multichain` | 멀티체인 토큰 잔액 | Across Protocol |

### 4.2 커스텀 전략 구성

```typescript
// 복잡한 DAO를 위한 멀티 전략 구성
const advancedStrategies = [
  // 전략 1: 기본 거버넌스 토큰
  {
    name: "erc20-balance-of",
    params: {
      address: "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984", // UNI
      decimals: 18,
      symbol: "UNI"
    }
  },
  // 전략 2: 볼트에 예치된 토큰
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
  // 전략 3: 멀티플라이어가 있는 LP 토큰
  {
    name: "erc20-balance-of-with-multiplier",
    params: {
      address: "0x1d42064Fc4Beb5F8aAF85F4617AE8b3b5B8Bd801", // UNI/ETH LP
      decimals: 18,
      symbol: "UNI-LP",
      multiplier: 2  // LP 보유자에게 2배 투표권
    }
  }
];

// 주소의 투표권 계산
async function getVotingPower(
  address: string,
  strategies: any[],
  snapshot: number  // 블록 번호
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

// 사용 예시
const votingPower = await getVotingPower(
  "0x2775b1c75658Be0F640272CCb8c72ac986009e38",
  advancedStrategies,
  18945231
);
console.log(`투표권: ${votingPower} 토큰`);
```

### 4.3 이차 투표 전략

더 민주적인 결과를 원하는 DAO를 위해 Snapshot은 이차 투표를 지원합니다:

```json
{
  "strategy": {
    "name": "quadratic-balance-of",
    "params": {
      "address": "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984",
      "decimals": 18,
      "symbol": "UNI",
      "coefficient": 1  // sqrt(token_balance) * 계수
    }
  }
}
```

이차 투표를 통해 10,000 토큰을 보유한 사용자는 100의 투표권을 가지고(√10,000), 100 토큰을 보유한 사용자는 10의 투표권을 가집니다(√100) — 고래 보유자의 영향력을 줄입니다.

---

## 5. 위임: DAO의 대의민주주의

### 5.1 위임의 작동 방식

위임을 통해 토큰 보유자는 신뢰할 수 있는 대표자에게 투표권을 할당하여 참여율을 높이고 거버넌스 전문화를 가능하게 합니다:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVotingDelegate {
    /// @notice 투표권을 대표자에게 위임
    /// @param delegatee 투표권을 위임할 주소
    function delegate(address delegatee) external;

    /// @notice 계정의 현재 투표수 조회
    /// @param account 확인할 주소
    /// @return votes 현재 투표권
    function getCurrentVotes(address account) external view returns (uint96);

    /// @notice 특정 블록의 이전 투표수 조회
    /// @param account 확인할 주소
    /// @param blockNumber 과거 조회용 블록 번호
    /// @return votes 해당 블록의 투표권
    function getPriorVotes(
        address account,
        uint256 blockNumber
    ) external view returns (uint96);
}
```

```typescript
// Snapshot 위임 설정
import Snapshot from '@snapshot-labs/snapshot.js';

const client = new Snapshot.Client712('https://hub.snapshot.org');

// 위임 트랜잭션 생성 (서명을 통한 가스 없음)
async function delegateVotingPower(
  signer: any,
  delegator: string,
  delegatee: string,
  space: string  // "uniswap.eth" 또는 전역용 공백
): Promise<string> {
  const delegation = {
    delegatee,
    space,        // 빈 문자열 = 전역 위임
    timestamp: Math.floor(Date.now() / 1000)
  };

  const receipt = await client.delegate(
    signer,
    delegator,
    delegation
  );

  return receipt;  // 위임 기록의 IPFS 해시
}

// UNI 투표를 거버넌스 전문가에게 위임
const txHash = await delegateVotingPower(
  signer,
  "0xMyAddress...",
  "0xGovernanceExpert...",  // 신뢰할 수 있는 위임자
  "uniswap.eth"             // 스페이스별 위임
);

console.log(`위임 기록: ${txHash}`);
```

### 5.2 위임 대시보드 쿼리

```graphql
# 스페이스의 현재 위임 조회
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
# 위임 쿼리 실행
curl -X POST https://hub.snapshot.org/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query { delegations(where: {space: \"uniswap.eth\", delegate: \"0x2775b1c75658Be0F640272CCb8c72ac986009e38\"}) { delegator timestamp } }"
  }'
```

---

## 6. 프로그래매틱 통합: Snapshot SDK

### 6.1 설치 및 설정

```bash
# Snapshot.js SDK 설치
npm install @snapshot-labs/snapshot.js ethers

# 또는 yarn 사용
yarn add @snapshot-labs/snapshot.js ethers
```

```typescript
// Snapshot 클라이언트 초기화
import snapshot from '@snapshot-labs/snapshot.js';
import { Wallet } from 'ethers';

const hub = 'https://hub.snapshot.org';  // 메인넷 허브
const client = new snapshot.Client712(hub);

// 제공자 및 서명자 설정
const provider = new ethers.JsonRpcProvider('https://eth.llamarpc.com');
const signer = new Wallet(process.env.PRIVATE_KEY, provider);
```

### 6.2 프로그래매틱 제안 생성

```typescript
// SDK를 통한 거버넌스 제안 생성
async function createProposal(
  signer: any,
  author: string,
  space: string
): Promise<string> {
  const proposal = {
    space: "mydao.eth",
    type: "single-choice",        // "single-choice" | "approval" | "quadratic" | "ranked-choice" | "weighted"
    title: "2026년 2분기 재무 할당 제안",
    body: `## 요약

본 제안은 2026년 2분기 운영을 위한 재무 자금 할당을 합니다.

## 상세 내용

- 개발: 40% (800 ETH)
- 마케팅: 30% (600 ETH)
- 보안 감사: 20% (400 ETH)
- 커뮤니티 보조금: 10% (200 ETH)

## 구현

통과되면 재무 다중서명은 7일 이내에 이체를 실행합니다.

## 참고자료

- [1분기 2026 재무 보고서](https://mydao.xyz/treasury/q1-2026)
- [예산 스프레드시트](https://mydao.xyz/budget/q2-2026)`,
    choices: ["찬성", "반대", "기권"],
    start: Math.floor(Date.now() / 1000) + 86400,    // 24시간 후 시작
    end: Math.floor(Date.now() / 1000) + 259200,      // 72시간 후 종료
    snapshot: await provider.getBlockNumber(),         // 현재 블록
    discussion: "https://forum.mydao.xyz/t/q2-treasury",
    plugins: '{}',
    app: "mydao-governance"
  };

  const receipt = await client.proposal(
    signer,
    author,
    proposal
  );

  return receipt;  // IPFS 해시 반환
}

// 실행
const proposalId = await createProposal(
  signer,
  "0xAuthorAddress...",
  "mydao.eth"
);

console.log(`제안 생성됨: ${proposalId}`);
```

### 6.3 API를 통한 투표

```typescript
// 프로그래매틱 투표 제출
async function castVote(
  signer: any,
  voter: string,
  proposalId: string,
  choice: number,      // 1=찬성, 2=반대, 3=기권
  reason: string
): Promise<string> {
  const vote = {
    space: "mydao.eth",
    proposal: proposalId,     // 제안 생성의 IPFS 해시
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

  return receipt;  // 투표의 IPFS 해시
}

// 근거와 함께 투표
const voteReceipt = await castVote(
  signer,
  "0xVoterAddress...",
  "QmYwAPJzv5CZsnAzt8auVK914vhC2pW9e4iPApvb1xUcGz",
  1,  // 찬성
  "예산 할당이 로드맵에 명시된 전략적 우선순위와 일치하기 때문에 이 제안을 지지합니다."
);

console.log(`투표 기록: ${voteReceipt}`);
```

### 6.4 배치 투표 쿼리

```typescript
// 제안의 모든 투표 조회
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
        vp          # 투표권
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

// 투표 통계 가져오기
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

// 사용법
const stats = await getVoteStats("QmYwAPJzv5CZsnAzt8auVK914vhC2pW9e4iPApvb1xUcGz");
console.log(`총 투표자: ${stats.totalVotes}`);
console.log(`총 VP: ${stats.totalVotingPower}`);
console.log("결과:", stats.results);
```

---

## 7. 멀티체인 및 크로스 플랫폼 통합

### 7.1 멀티체인 투표 전략

Snapshot은 동시에 여러 블록체인에서 투표를 지원합니다:

```typescript
// 멀티체인 전략: 네트워크 전반에 걸쳐 토큰 집계
const multichainStrategies = [
  {
    name: "erc20-balance-of",
    network: "1",  // 이더리움
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

// 체인 전반의 결합 투표권 가져오기
const scores = await snapshot.utils.getScores(
  "uniswap.eth",
  multichainStrategies,
  "1",  // 메인 네트워크
  ["0xVoterAddress..."],
  await provider.getBlockNumber()
);

console.log("크로스체인 투표권:", scores);
```

### 7.2 Webhook 알림

```typescript
// 제안 이벤트를 위한 Webhook 설정
import express from 'express';

const app = express();
app.use(express.json());

// Snapshot Webhook 엔드포인트
app.post('/webhooks/snapshot', (req, res) => {
  const event = req.body;

  switch (event.event) {
    case 'proposal/created':
      console.log(`새 제안: ${event.id}`);
      notifyDiscord(event);
      break;
    case 'proposal/end':
      console.log(`투표 종료: ${event.id}`);
      tallyResults(event);
      break;
    case 'vote':
      console.log(`${event.proposal.id}의 새 투표`);
      updateLeaderboard(event);
      break;
  }

  res.status(200).send('OK');
});

function notifyDiscord(proposal: any) {
  // Discord Webhook으로 알림 전송
  const message = {
    embeds: [{
      title: `📋 새 제안: ${proposal.title}`,
      url: `https://snapshot.org/#/${proposal.space.id}/proposal/${proposal.id}`,
      description: proposal.body.substring(0, 200) + '...',
      fields: [
        { name: '스페이스', value: proposal.space.name, inline: true },
        { name: '작성자', value: proposal.author, inline: true },
        { name: '종료일', value: new Date(proposal.end * 1000).toISOString(), inline: true }
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

app.listen(3000, () => console.log('Webhook 서버가 3000 포트에서 대기 중'));
```

---

## 8. 실제 사용 사례 및 모범 사례

### 8.1 프로토콜 파라미터 변경

DeFi 프로토콜은 Snapshot을 사용하여 중요한 파라미터에 대해 투표합니다:

```typescript
// Aave 스타일의 리스크 파라미터 제안
interface RiskParameterProposal {
  asset: string;              // 토큰 주소
  parameter: string;          // "ltv" | "liquidationThreshold" | "reserveFactor"
  currentValue: number;
  proposedValue: number;
  justification: string;
  riskAnalysis: string;       // Gauntlet/Chaos 분석 링크
}

const aaveProposal: RiskParameterProposal = {
  asset: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2", // WETH
  parameter: "liquidationThreshold",
  currentValue: 8250,         // 82.5%
  proposedValue: 8000,        // 80.0%
  justification: "시장 변동성으로 인한 리스크 노출 감소",
  riskAnalysis: "https://gauntlet.network/analyses/aave-weth-2026-05"
};
```

### 8.2 재무 관리

```typescript
// 재무 할당 투표 카테고리
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
  totalAllocation: BigInt("2000000000000000000000"), // 2,000 ETH
  allocations: [
    { category: "개발", percentage: 40, amount: BigInt("800000000000000000000"), recipient: "0xDevMultisig...", unlockDate: 1719792000 },
    { category: "마케팅", percentage: 30, amount: BigInt("600000000000000000000"), recipient: "0xMktMultisig...", unlockDate: 1719792000 },
    { category: "보안", percentage: 20, amount: BigInt("400000000000000000000"), recipient: "0xSecMultisig...", unlockDate: 1719792000 },
    { category: "보조금", percentage: 10, amount: BigInt("200000000000000000000"), recipient: "0xGrtMultisig...", unlockDate: 1719792000 }
  ],
  vestingSchedule: {
    cliff: 90 * 86400,      // 90일 절벽
    duration: 365 * 86400,  // 1년 베스팅
    interval: 30 * 86400    // 월간 릴리스
  }
};
```

### 8.3 보안 모범 사례

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
    - discussion_min_duration: "7일"

  voting_security:
    - snapshot_block: "제안 생성 블록 사용"
    - voting_delay: "최소 24시간"
    - voting_period: "최소 3일"
    - quorum_required: true

  monitoring:
    - enable_webhooks: true
    - discord_notifications: true
    - unusual_activity_alerts: true
    - delegate_change_alerts: true
```

---

## 9. 자주 묻는 질문 (FAQ)

### 9.1 Snapshot이란 무엇이며 온체인 거버넌스와 어떻게 다른가요?

Snapshot은 암호화학적 보안을 유지하면서 가스 비용을 제거하는 **오프체인 투표 플랫폼**입니다. 온체인 거버넌스(예: Compound의 Governor Bravo)와 달리, 여기서 모든 투표는 5~50달러의 가스비가 드는 블록체인 트랜잭션입니다. Snapshot은 IPFS에 저장된 **EIP-712 서명 메시지**를 사용합니다. 이를 통해 모든 포트폴리오 크기의 토큰 보유자가 참여할 수 있습니다. 단, Snapshot 투표는 자동으로 실행되지 않으며 — 별도의 온체인 트랜잭션(종종 멀티시그 또는 타임록 컨트랙트를 통해)이 필요합니다.

### 9.2 Snapshot 투표는 안전한가요? 투표가 조작될 수 있나요?

Snapshot 투표는 암호화학적으로 안전합니다. 각 투표는 EIP-712 타입 데이터 서명으로 투표자의 개인 키로 서명되어 변조가 불가능합니다. 투표 데이터는 IPFS에 고정되어 영구적이고 검열에 강한 저장을 보장합니다. 그러나 Snapshot의 **오프체인 특성은 투표 실행이 자동이 아님**을 의미합니다 — DAO의 멀티시그 서명자가 온체인에서 투표자의 의지를 실행해야 합니다. 이는 신뢰의 "사회적 계약" 계층을 만듭니다. 많은 DAO가 **Snapshot + Safe (Gnosis Safe)**를 함께 사용하여 이를 완화합니다.

### 9.3 투표권과 토큰 잔액은 어떻게 계산되나요?

투표권은 각 스페이스에 대해 구성된 **전략**에 의해 결정됩니다. 가장 일반적인 전략은 `erc20-balance-of`로, 특정 블록 번호(`snapshot` 블록)에서 투표자의 토큰 잔액을 확인합니다. 이는 다음을 방지합니다:
- **플래시론 공격**: 동일한 트랜잭션에서 빌린 토큰을 투표에 사용할 수 없음
- **이중 투표**: 동일한 토큰을 이동하고 다시 투표할 수 없음
- **마지막 순간 축적**: 사용자가 제안 생성 후 토큰을 구매하여 투표에 영향을 줄 수 없음

여러 전략을 결합할 수 있으며, 커스텀 전략은 스테이킹 토큰, LP 포지션, NFT 보유, 위임된 투표권과 같은 복잡한 로직을 허용합니다.

### 9.4 투표권을 다른 사람에게 위임할 수 있나요?

네, **위임**은 Snapshot 거버넌스의 핵심 기능입니다. 토큰 보유자는 신뢰할 수 있는 대표자 — 종종 거버넌스 전문가, 핵심 기여자, 활발한 커뮤니티 구성원 — 에게 투표권을 위임할 수 있습니다. 이는 특히 다음에 가치가 있습니다:
- 제안을 연구할 시간이 부족한 **소규모 보유자**
- 전문 거버넌스 참여를 선호하는 **기관 보유자**
- 그렇지 않으면 비활성한 투표를 집계하여 **정족수 증가**

위임은 **스페이스별**(하나의 DAO에만 해당) 또는 **전역**(모든 Snapshot 스페이스에 해당)일 수 있습니다. 위임된 투표는 언제든지 회수할 수 있으며, 패널티 없이 위임자를 변경할 수 있습니다. Snapshot UI는 위임을 관리하기 위한 [전용 위임 페이지](https://snapshot.org/#/delegate)를 제공합니다.

### 9.5 Snapshot을 내 애플리케이션에 어떻게 통합하나요?

Snapshot은 여러 통합 옵션을 제공합니다:
- **Snapshot.js SDK**: 제안 생성, 투표, 위임을 위한 풀기능 JavaScript SDK
- **GraphQL API**: 공개 GraphQL 엔드포인트를 통해 제안, 투표, 스페이스, 투표권 조회
- **Webhook**: 제안 이벤트에 대한 실시간 알림
- **Embed**: dApp에 투표 인터페이스를 임베드하기 위한 iframe 통합

가장 일반적인 통합 패턴은 GraphQL API를 사용하여 프론트엔드에 거버넌스 데이터를 표시하고 SDK를 투표 제출과 결합하는 것입니다. 모든 통합에는 이더리움 호환 지갑 연결이 필요합니다(MetaMask, WalletConnect 등).

---



## 추천 호스팅 및 인프라

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영을 지원합니다.*

## 10. 결론: 탈중앙화 거버넌스의 미래

Snapshot은 참여의 재정적 장벽을 제거하여 DAO 거버넌스를 근본적으로 민주화했습니다. **1,000만 개 이상의 투표**를 처리하고, **50개 이상의 투표 전략**을 지원하며, 멀티체인 호환성과 강력한 SDK 생태계를 갖춘 Snapshot은 2026년 탈중앙화 의사결정의 기반 인프라로 자리 잡았습니다.

DAO가 더 큰 자동화를 향해 발전함에 따라, **Safe{Core}**, **Zodiac 모듈**, **계정 추상화(ERC-4337)**를 통한 Snapshot의 오프체인 신호와 온체인 실행 간의 더 깊은 통합을 기대합니다. **AI 지원 거버넌스**의 출현 — 언어 모델이 제안을 분석하고 투표 권장 사항을 제공하는 것 — 은 커뮤니티가 집단 의사결정에 참여하는 방식을 더욱 변화시킬 것입니다.

차세대 거버넌스 도구를 구축하는 개발자에게 Snapshot의 MIT 라이선스 코드베이스, 활발한 개발자 커뮤니티, 모듈형 아키텍처는 이상적인 기반을 제공합니다. 새로운 DeFi 프로토콜을 출시하든, NFT 커뮤니티를 관리하든, 탈중앙화 조직을 위한 인프라를 구축하든, Snapshot은 현대 DAO 거버넌스에 필요한 유연성, 보안성, 확장성을 제공합니다.

---

> **오늘 거버넌스 토큰 거래를 시작하세요!** [바이낸스](https://www.bsmkweb.cc/register?ref=DIBI8)에 가입하여 Uniswap, Aave, Compound 등 주요 DAO의 토큰을 매수, 매도, 스테이킹하세요.

---

**라이선스:** MIT  
**관리자:** [Snapshot Labs](https://github.com/snapshot-labs)  
**GitHub 스타:** 9,500+  
**웹사이트:** [snapshot.org](https://snapshot.org)
