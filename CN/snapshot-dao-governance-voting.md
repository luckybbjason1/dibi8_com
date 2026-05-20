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
- /posts/snapshot-dao-governance-voting/
---

{{</* resource-info */>}}

**Date:** 2026-05-19  
**Category:** AI Trading  
**Tags:** Snapshot, DAO, Governance, Voting, DeFi, Web3, IPFS, Blockchain  
**Tool:** [Snapshot](https://snapshot.org)  
**GitHub:** [snapshot-labs/snapshot](https://github.com/snapshot-labs/snapshot) — ⭐ 9,500 stars, MIT License

---

> Interested in trading governance tokens? Register on [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) to get started with DAO token trading.

---

## 1. Introduction: Why DAO Governance Matters in 2026

Decentralized Autonomous Organizations (DAOs) have fundamentally transformed how communities make collective decisions. By 2026, DAOs manage over $50 billion in treasury assets across DeFi protocols, NFT projects, infrastructure networks, and investment collectives. However, on-chain voting on networks like Ethereum remains prohibitively expensive during high congestion periods, with single votes costing $5–$50 in gas fees. This financial barrier disenfranchises smaller token holders and undermines the democratic ethos of decentralization.

**Snapshot** emerged as the definitive solution to this challenge. Launched by [Snapshot Labs](https://github.com/snapshot-labs), Snapshot is an open-source, off-chain voting platform that enables gas-free governance for DAOs. With over **10 million votes processed**, 9,500+ GitHub stars, and adoption by virtually every major DeFi protocol — including Uniswap, Aave, Compound, Balancer, and Gitcoin — Snapshot has become the industry standard for DAO governance.

Unlike on-chain voting systems that execute every vote as a blockchain transaction, Snapshot leverages **IPFS** for decentralized data storage and **Ethereum Signed Messages** for vote authentication. This architecture eliminates gas costs entirely while maintaining cryptographic verifiability and transparency. Votes are signed with users' private keys, proving token ownership without spending gas.

This comprehensive guide explores Snapshot's architecture, voting strategies, delegation mechanisms, SDK integration, and real-world implementation patterns for developers and DAO operators in 2026.

---

## 2. Core Architecture: How Snapshot Enables Gas-Free Voting

### 2.1 The Off-Chain Voting Paradigm

Snapshot's revolutionary approach rests on separating **vote signaling** from **vote execution**. Traditional on-chain governance requires every participant to submit a transaction, paying gas fees proportional to network congestion. Snapshot inverts this model:

```typescript
// Traditional on-chain voting (expensive)
// Each voter pays gas for this transaction
await governorContract.castVote(
  proposalId,    // uint256
  support,       // 0=against, 1=for, 2=abstain
  { value: 0, gasPrice: 50000000000 } // ~$5-50 in gas
);
```

```typescript
// Snapshot off-chain voting (gas-free)
// User signs a message with their wallet — zero gas cost
const voteMessage = {
  from: userAddress,
  space: "uniswap.eth",           // DAO namespace
  proposal: proposalId,           // IPFS hash of proposal
  choice: 1,                      // 1=for, 2=against, 3=abstain
  reason: "Support treasury diversification",
  app: "snapshot",                // voting client
  metadata: '{}'                  // optional JSON metadata
};

// Sign with EIP-712 typed data — completely gas-free
const signature = await signer.signTypedData(
  domain,
  types,
  voteMessage
);
```

The signed message is broadcast to Snapshot's hub and pinned to IPFS, creating a permanent, verifiable record without any blockchain transaction.

### 2.2 IPFS-Backed Data Storage

All Snapshot data — proposals, votes, and spaces — is stored on the **InterPlanetary File System (IPFS)**, ensuring censorship resistance and permanence:

```json
{
  "proposal": {
    "id": "QmYwAPJzv5CZsnAzt8auVK914vhC2pW9e4iPApvb1xUcGz",
    "ipfs": "QmYwAPJzv5CZsnAzt8auVK914vhC2pW9e4iPApvb1xUcGz",
    "title": "Treasury Diversification Proposal Q2 2026",
    "body": "## Summary\n\nThis proposal seeks approval...",
    "choices": ["For", "Against", "Abstain"],
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

The `snapshot` field specifies the Ethereum block number at which token balances are counted, preventing flash loan attacks and ensuring fair vote weight calculation.

---
## 3. Setting Up a DAO Space on Snapshot

### 3.1 Creating Your Space

Any project can create a governance space on Snapshot. The process involves ENS domain configuration and strategy selection:

```bash
# Step 1: Ensure you own an ENS domain
# Your space ID will be your ENS name (e.g., mydao.eth)

# Step 2: Set ENS text records
# Set snapshot record to point to your space settings
ens records set mydao.eth text snapshot "ipfs://Qm..."
```

```typescript
// Step 3: Configure space settings via Snapshot API
import snapshot from '@snapshot-labs/snapshot.js';

const spaceConfig = {
  name: "MyDAO Governance",
  about: "Decentralized governance for MyDAO protocol",
  avatar: "https://mydao.xyz/logo.png",
  network: "1",                    // Ethereum mainnet
  symbol: "MYDAO",                 // Token symbol
  skin: "mydao",                   // Custom theme
  // Voting validation
  validation: {
    name: "basic",
    params: {}
  },
  // Voting strategies (token-weighted)
  strategies: [
    {
      name: "erc20-balance-of",
      params: {
        address: "0x1234...abcd",  // MYDAO token contract
        decimals: 18,
        symbol: "MYDAO"
      }
    }
  ],
  // Proposal thresholds
  filters: {
    minScore: 1000,               // Min tokens to create proposal
    onlyMembers: false
  },
  // Voting parameters
  voting: {
    delay: 86400,                 // 1 day voting delay
    period: 172800,               // 2 day voting period
    type: "single-choice",        // Voting method
    quorum: 100000                // Minimum participation
  }
};

// Submit space configuration
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

### 3.2 Space Verification

After configuration, verify your space is accessible:

```bash
# Query space via GraphQL
curl -X POST https://hub.snapshot.org/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query { space(id: \"mydao.eth\") { id name about network symbol strategies { name params } } }"
  }'
```

```python
# Python verification script
import requests

def verify_snapshot_space(space_id: str) -> dict:
    """Verify Snapshot space configuration."""
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
        print(f"Space '{space['name']}' verified successfully!")
        print(f"Network: {space['network']}")
        print(f"Strategies: {[s['name'] for s in space['strategies']]}")
        print(f"Min Score: {space['filters']['minScore']}")
        return space
    else:
        raise ValueError(f"Space '{space_id}' not found")

# Verify
space = verify_snapshot_space("mydao.eth")
```

---

## 4. Voting Strategies: Flexible Token-Weighted Governance

### 4.1 Built-in Strategy Library

Snapshot supports 50+ voting strategies that determine how voting power is calculated. The most commonly used strategies include:

| Strategy | Use Case | Example DAOs |
|----------|----------|--------------|
| `erc20-balance-of` | Simple token balance | Uniswap, Aave |
| `erc721` | NFT ownership | Bored Ape Yacht Club |
| `contract-call` | Custom logic via smart contract | Compound |
| ` delegation` | Delegated voting power | Gitcoin |
| `whitelist` | Pre-approved voters | Investment DAOs |
| `snapshot-multichain` | Multi-chain token balances | Across Protocol |

### 4.2 Configuring Custom Strategies

```typescript
// Multi-strategy configuration for complex DAOs
const advancedStrategies = [
  // Strategy 1: Base governance token
  {
    name: "erc20-balance-of",
    params: {
      address: "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984", // UNI
      decimals: 18,
      symbol: "UNI"
    }
  },
  // Strategy 2: Staked tokens in vault
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
  // Strategy 3: LP tokens with multiplier
  {
    name: "erc20-balance-of-with-multiplier",
    params: {
      address: "0x1d42064Fc4Beb5F8aAF85F4617AE8b3b5B8Bd801", // UNI/ETH LP
      decimals: 18,
      symbol: "UNI-LP",
      multiplier: 2  // 2x voting power for LP holders
    }
  }
];

// Calculate voting power for an address
async function getVotingPower(
  address: string,
  strategies: any[],
  snapshot: number  // block number
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

// Example usage
const votingPower = await getVotingPower(
  "0x2775b1c75658Be0F640272CCb8c72ac986009e38",
  advancedStrategies,
  18945231
);
console.log(`Voting power: ${votingPower} tokens`);
```

### 4.3 Quadratic Voting Strategy

For DAOs seeking more democratic outcomes, Snapshot supports quadratic voting:

```json
{
  "strategy": {
    "name": "quadratic-balance-of",
    "params": {
      "address": "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984",
      "decimals": 18,
      "symbol": "UNI",
      "coefficient": 1  // sqrt(token_balance) * coefficient
    }
  }
}
```

With quadratic voting, a user with 10,000 tokens has 100 voting power (√10,000), while a user with 100 tokens has 10 voting power (√100) — reducing the influence of whale holders.

---

## 5. Delegation: Representative Democracy in DAOs

### 5.1 How Delegation Works

Delegation allows token holders to assign their voting power to trusted representatives, increasing participation rates and enabling governance specialization:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVotingDelegate {
    /// @notice Delegate voting power to a representative
    /// @param delegatee Address to delegate voting power to
    function delegate(address delegatee) external;

    /// @notice Get current votes for an account
    /// @param account Address to check
    /// @return votes Current voting power
    function getCurrentVotes(address account) external view returns (uint96);

    /// @notice Get prior votes at a specific block
    /// @param account Address to check
    /// @param blockNumber Block number for historical lookup
    /// @return votes Voting power at that block
    function getPriorVotes(
        address account,
        uint256 blockNumber
    ) external view returns (uint96);
}
```

```typescript
// Snapshot delegation setup
import Snapshot from '@snapshot-labs/snapshot.js';

const client = new Snapshot.Client712('https://hub.snapshot.org');

// Create delegation transaction (gas-free via signature)
async function delegateVotingPower(
  signer: any,
  delegator: string,
  delegatee: string,
  space: string  // "uniswap.eth" or empty for global
): Promise<string> {
  const delegation = {
    delegatee,
    space,        // Empty string = global delegation
    timestamp: Math.floor(Date.now() / 1000)
  };

  const receipt = await client.delegate(
    signer,
    delegator,
    delegation
  );

  return receipt;  // IPFS hash of delegation record
}

// Delegate UNI votes to a governance expert
const txHash = await delegateVotingPower(
  signer,
  "0xMyAddress...",
  "0xGovernanceExpert...",  // Trusted delegate
  "uniswap.eth"             // Space-specific delegation
);

console.log(`Delegation recorded: ${txHash}`);
```

### 5.2 Delegation Dashboard Query

```graphql
# Query current delegations for a space
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
# Execute delegation query
curl -X POST https://hub.snapshot.org/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query { delegations(where: {space: \"uniswap.eth\", delegate: \"0x2775b1c75658Be0F640272CCb8c72ac986009e38\"}) { delegator timestamp } }"
  }'
```

---

## 6. Programmatic Integration: Snapshot SDK

### 6.1 Installation and Setup

```bash
# Install Snapshot.js SDK
npm install @snapshot-labs/snapshot.js ethers

# Or with yarn
yarn add @snapshot-labs/snapshot.js ethers
```

```typescript
// Initialize Snapshot client
import snapshot from '@snapshot-labs/snapshot.js';
import { Wallet } from 'ethers';

const hub = 'https://hub.snapshot.org';  // Mainnet hub
const client = new snapshot.Client712(hub);

// Setup provider and signer
const provider = new ethers.JsonRpcProvider('https://eth.llamarpc.com');
const signer = new Wallet(process.env.PRIVATE_KEY, provider);
```

### 6.2 Creating Proposals Programmatically

```typescript
// Create a governance proposal via SDK
async function createProposal(
  signer: any,
  author: string,
  space: string
): Promise<string> {
  const proposal = {
    space: "mydao.eth",
    type: "single-choice",        // "single-choice" | "approval" | "quadratic" | "ranked-choice" | "weighted"
    title: "Q2 2026 Treasury Allocation Proposal",
    body: `## Summary

This proposal allocates treasury funds for Q2 2026 operations.

## Details

- Development: 40% (800 ETH)
- Marketing: 30% (600 ETH)
- Security audits: 20% (400 ETH)
- Community grants: 10% (200 ETH)

## Implementation

If passed, the treasury multi-sig will execute transfers within 7 days.

## References

- [Treasury Report Q1 2026](https://mydao.xyz/treasury/q1-2026)
- [Budget Spreadsheet](https://mydao.xyz/budget/q2-2026)`,
    choices: ["For", "Against", "Abstain"],
    start: Math.floor(Date.now() / 1000) + 86400,    // Start in 24h
    end: Math.floor(Date.now() / 1000) + 259200,      // End in 72h
    snapshot: await provider.getBlockNumber(),         // Current block
    discussion: "https://forum.mydao.xyz/t/q2-treasury",
    plugins: '{}',
    app: "mydao-governance"
  };

  const receipt = await client.proposal(
    signer,
    author,
    proposal
  );

  return receipt;  // Returns IPFS hash
}

// Execute
const proposalId = await createProposal(
  signer,
  "0xAuthorAddress...",
  "mydao.eth"
);

console.log(`Proposal created: ${proposalId}`);
```

### 6.3 Casting Votes via API

```typescript
// Submit a vote programmatically
async function castVote(
  signer: any,
  voter: string,
  proposalId: string,
  choice: number,      // 1=For, 2=Against, 3=Abstain
  reason: string
): Promise<string> {
  const vote = {
    space: "mydao.eth",
    proposal: proposalId,     // IPFS hash from proposal creation
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

  return receipt;  // IPFS hash of vote
}

// Cast a vote with reasoning
const voteReceipt = await castVote(
  signer,
  "0xVoterAddress...",
  "QmYwAPJzv5CZsnAzt8auVK914vhC2pW9e4iPApvb1xUcGz",
  1,  // For
  "Supporting this proposal because the budget allocation aligns with our strategic priorities outlined in the roadmap."
);

console.log(`Vote recorded: ${voteReceipt}`);
```

### 6.4 Batch Vote Queries

```typescript
// Query all votes for a proposal
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
        vp          # voting power
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

// Get vote statistics
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

// Usage
const stats = await getVoteStats("QmYwAPJzv5CZsnAzt8auVK914vhC2pW9e4iPApvb1xUcGz");
console.log(`Total voters: ${stats.totalVotes}`);
console.log(`Total VP: ${stats.totalVotingPower}`);
console.log("Results:", stats.results);
```

---

## 7. Multi-Chain and Cross-Platform Integration

### 7.1 Multi-Chain Voting Strategies

Snapshot supports voting across multiple blockchains simultaneously:

```typescript
// Multi-chain strategy: aggregate tokens across networks
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

// Fetch combined voting power across chains
const scores = await snapshot.utils.getScores(
  "uniswap.eth",
  multichainStrategies,
  "1",  // Main network
  ["0xVoterAddress..."],
  await provider.getBlockNumber()
);

console.log("Cross-chain voting power:", scores);
```

### 7.2 Webhook Notifications

```typescript
// Set up webhook for proposal events
import express from 'express';

const app = express();
app.use(express.json());

// Snapshot webhook endpoint
app.post('/webhooks/snapshot', (req, res) => {
  const event = req.body;

  switch (event.event) {
    case 'proposal/created':
      console.log(`New proposal: ${event.id}`);
      notifyDiscord(event);
      break;
    case 'proposal/end':
      console.log(`Voting ended: ${event.id}`);
      tallyResults(event);
      break;
    case 'vote':
      console.log(`New vote on ${event.proposal.id}`);
      updateLeaderboard(event);
      break;
  }

  res.status(200).send('OK');
});

function notifyDiscord(proposal: any) {
  // Send notification to Discord webhook
  const message = {
    embeds: [{
      title: `📋 New Proposal: ${proposal.title}`,
      url: `https://snapshot.org/#/${proposal.space.id}/proposal/${proposal.id}`,
      description: proposal.body.substring(0, 200) + '...',
      fields: [
        { name: 'Space', value: proposal.space.name, inline: true },
        { name: 'Author', value: proposal.author, inline: true },
        { name: 'End Date', value: new Date(proposal.end * 1000).toISOString(), inline: true }
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

app.listen(3000, () => console.log('Webhook server listening on port 3000'));
```

---

## 8. Real-World Use Cases and Best Practices

### 8.1 Protocol Parameter Changes

DeFi protocols use Snapshot to vote on critical parameters:

```typescript
// Aave-style risk parameter proposal
interface RiskParameterProposal {
  asset: string;              // Token address
  parameter: string;          // "ltv" | "liquidationThreshold" | "reserveFactor"
  currentValue: number;
  proposedValue: number;
  justification: string;
  riskAnalysis: string;       // Link to Gauntlet/Chaos analysis
}

const aaveProposal: RiskParameterProposal = {
  asset: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2", // WETH
  parameter: "liquidationThreshold",
  currentValue: 8250,         // 82.5%
  proposedValue: 8000,        // 80.0%
  justification: "Reduce risk exposure due to market volatility",
  riskAnalysis: "https://gauntlet.network/analyses/aave-weth-2026-05"
};
```

### 8.2 Treasury Management

```typescript
// Treasury allocation voting categories
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
    { category: "Development", percentage: 40, amount: BigInt("800000000000000000000"), recipient: "0xDevMultisig...", unlockDate: 1719792000 },
    { category: "Marketing", percentage: 30, amount: BigInt("600000000000000000000"), recipient: "0xMktMultisig...", unlockDate: 1719792000 },
    { category: "Security", percentage: 20, amount: BigInt("400000000000000000000"), recipient: "0xSecMultisig...", unlockDate: 1719792000 },
    { category: "Grants", percentage: 10, amount: BigInt("200000000000000000000"), recipient: "0xGrtMultisig...", unlockDate: 1719792000 }
  ],
  vestingSchedule: {
    cliff: 90 * 86400,      // 90 day cliff
    duration: 365 * 86400,  // 1 year vesting
    interval: 30 * 86400    // Monthly releases
  }
};
```

### 8.3 Security Best Practices

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
    - discussion_min_duration: "7 days"

  voting_security:
    - snapshot_block: "use_proposal_creation_block"
    - voting_delay: "minimum_24_hours"
    - voting_period: "minimum_3_days"
    - quorum_required: true

  monitoring:
    - enable_webhooks: true
    - discord_notifications: true
    - unusual_activity_alerts: true
    - delegate_change_alerts: true
```

---

## 9. Frequently Asked Questions (FAQ)

### 9.1 What is Snapshot and how does it differ from on-chain governance?

Snapshot is an **off-chain voting platform** for DAOs that eliminates gas costs while maintaining cryptographic security. Unlike on-chain governance (e.g., Compound's Governor Bravo), where every vote is a blockchain transaction costing $5–$50 in gas, Snapshot uses **EIP-712 signed messages** that are stored on IPFS. This makes participation accessible to all token holders regardless of portfolio size. The trade-off is that Snapshot votes are not automatically executable — they require a separate on-chain transaction (often via a multi-sig or timelock contract) to implement the decision.

### 9.2 Is Snapshot voting secure? Can votes be manipulated?

Snapshot votes are cryptographically secure. Each vote is signed with the voter's private key using EIP-712 typed data signing, making them tamper-proof. The vote data is pinned to IPFS, ensuring permanent, censorship-resistant storage. However, Snapshot's **off-chain nature means vote execution is not automatic** — the DAO's multi-sig signers must execute the will of the voters on-chain. This creates a "social contract" layer of trust. Many DAOs mitigate this by using **Snapshot + Safe (Gnosis Safe)** together, where the multi-sig signers are contractually or reputationally bound to execute passed proposals.

### 9.3 How are voting power and token balances calculated?

Voting power is determined by **strategies** configured for each space. The most common strategy is `erc20-balance-of`, which checks the voter's token balance at a specific block number (the `snapshot` block). This prevents:
- **Flash loan attacks**: Tokens borrowed in the same transaction cannot be used for voting
- **Double voting**: The same tokens cannot be moved and voted again
- **Last-minute accumulation**: Users cannot buy tokens after a proposal is created to influence the vote

Multiple strategies can be combined, and custom strategies allow for complex logic like staked tokens, LP positions, NFT holdings, or delegated voting power.

### 9.4 Can I delegate my voting power to someone else?

Yes, **delegation** is a core feature of Snapshot governance. Token holders can delegate their voting power to trusted representatives — often governance experts, core contributors, or active community members. This is particularly valuable for:
- **Small holders** who lack time to research proposals
- **Institutional holders** who prefer professional governance participation
- **Increasing quorum** by aggregating otherwise inactive votes

Delegation can be **space-specific** (only for one DAO) or **global** (across all Snapshot spaces). Delegated votes can be reclaimed at any time, and delegates can be changed without penalty. The Snapshot UI provides a [dedicated delegation page](https://snapshot.org/#/delegate) for managing delegations.

### 9.5 How do I integrate Snapshot into my own application?

Snapshot provides multiple integration options:
- **Snapshot.js SDK**: Full-featured JavaScript SDK for proposal creation, voting, and delegation
- **GraphQL API**: Query proposals, votes, spaces, and voting power via the public GraphQL endpoint
- **Webhooks**: Real-time notifications for proposal events
- **Embed**: iframe integration for embedding voting interfaces in your dApp

The most common integration pattern is using the GraphQL API to display governance data in your frontend, combined with the SDK for vote submission. All integrations require an Ethereum-compatible wallet connection (MetaMask, WalletConnect, etc.).

---



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## 10. Conclusion: The Future of Decentralized Governance

Snapshot has fundamentally democratized DAO governance by removing the financial barrier to participation. With **10 million+ votes processed**, support for **50+ voting strategies**, multi-chain compatibility, and a robust SDK ecosystem, Snapshot stands as the foundational infrastructure for decentralized decision-making in 2026.

As DAOs evolve toward greater automation, we expect to see deeper integration between Snapshot's off-chain signaling and on-chain execution through **Safe{Core}**, **Zodiac modules**, and **Account Abstraction (ERC-4337)**. The emergence of **AI-assisted governance** — where language models analyze proposals and provide voting recommendations — will further transform how communities participate in collective decision-making.

For developers building the next generation of governance tools, Snapshot's MIT-licensed codebase, active developer community, and modular architecture provide an ideal foundation. Whether you're launching a new DeFi protocol, managing an NFT community, or building infrastructure for decentralized organizations, Snapshot offers the flexibility, security, and scalability required for modern DAO governance.

---

> **Start trading governance tokens today!** Register on [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) to buy, sell, and stake tokens from leading DAOs like Uniswap, Aave, and Compound.

---

**License:** MIT  
**Maintainer:** [Snapshot Labs](https://github.com/snapshot-labs)  
**GitHub Stars:** 9,500+  
**Website:** [snapshot.org](https://snapshot.org)
