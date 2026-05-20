---
title: 'eigenlayer-restaking-defi'
description: ''
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Ai Trading
source_version: ''
licensing_model: Open Source
license_type: BUSL-1.1
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/Layr-Labs/eigenlayer-contracts'
stars: 800
maintainer: 'Layr-Labs'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: ['EigenLayer']
aliases:
- /zh/posts/eigenlayer-restaking-defi/
---

{{</* resource-info */>}}

> **联盟营销披露**：本文包含 [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) 和 [Minara](https://minara.ai/r/OSXG4X) 的联盟链接。您通过这些链接注册时，我们可能会赚取佣金 —— 对您不产生额外费用。

---

## 什么是EigenLayer？为什么它如此重要？

EigenLayer是自以太坊转向权益证明（Proof-of-Stake）以来，质押经济领域最重要的创新。作为部署在以太坊主网上的再质押协议，EigenLayer使ETH质押者能够将其已质押的ETH重新用于保护额外的去中心化服务 —— 这些服务被称为**主动验证服务（AVS）** —— 而不仅仅局限于以太坊共识本身。截至2026年5月，EigenLayer的**总锁仓价值（TVL）已超过200亿美元**，按担保资本计算已成为规模最大的DeFi协议之一。

其核心概念既优雅又强大：新协议不再需要从零开始构建自己的验证者集，EigenLayer让它们能够**继承以太坊的经济安全性**，利用ETH验证者已经质押的资本。这种"共享安全"的概念显著降低了新去中心化基础设施的准入门槛，同时提高了质押者的资本效率 —— 他们现在可以在相同的底层质押上获得额外的收益。

## 再质押机制：底层工作原理

EigenLayer上的再质押允许以太坊验证者选择加入来保护额外的协议。当验证者进行再质押时，他们需要接受所选择的每个AVS定义的额外惩罚条件。

再质押仓位的生命周期遵循以下步骤：

```bash
# 第1步：在以太坊信标链上质押ETH
# 独立验证者最低需要32 ETH，或使用流动性质押代币（LST）

# 第2步：将已质押的ETH存入EigenLayer
# 可以是原生ETH或stETH、rETH、cbETH等LST
curl -X POST https://api.eigenlayer.com/restake \
  -H "Content-Type: application/json" \
  -d '{
    "strategy": "0x93c4b944...",
    "amount": "1000000000000000000",
    "staker": "0x您的地址..."
  }'
```

```solidity
// 第3步：EigenLayer策略管理器将资金存入底层策略
// 文件：StrategyManager.sol（简化版）
function depositIntoStrategy(
    IStrategy strategy,
    IERC20 token,
    uint256 amount
) external returns (uint256 shares) {
    // 将代币从质押者转移到策略合约
    token.safeTransferFrom(msg.sender, address(strategy), amount);
    // 策略执行存款并返回份额
    shares = strategy.deposit(token, amount);
    // 记录质押者的份额
    _addShares(msg.sender, strategy, shares);
    return shares;
}
```

```solidity
// 第4步：质押者委托给运营商
// 运营商运行AVS验证软件
function delegateTo(
    address operator,
    SignatureWithExpiry memory stakerSignatureAndExpiry,
    bytes32 approverSignatureAndExpiry
) external {
    require(isOperator(operator), "运营商未注册");
    delegationManager.delegateTo(
        operator, 
        stakerSignatureAndExpiry, 
        approverSignatureAndExpiry
    );
}
```

```solidity
// 第5步：运营商选择加入AVS惩罚条件
// AVS合约定义自定义验证和惩罚逻辑
interface IAVSRegistry {
    function registerOperatorToAVS(
        address operator,
        bytes32 salt,
        uint256 expiry,
        bytes memory signature
    ) external;
}

// 运营商选择加入EigenDA AVS
function optInToEigenDA(bytes memory blsPublicKey) external {
    eigenDARegistry.registerOperatorToAVS(
        msg.sender,
        keccak256(abi.encodePacked(block.timestamp)),
        block.timestamp + 7 days,
        blsSignature
    );
}
```

## 主动验证服务（AVS）：应用层

AVS是利用EigenLayer共享安全的协议和服务。它们涵盖数据可用性、预言机、跨链桥、排序器等多种用例。每个AVS定义自己的验证逻辑、奖励结构和惩罚条件。

### EigenDA：旗舰级数据可用性AVS

EigenDA是建立在EigenLayer上最知名的AVS。它为以太坊Rollup提供高吞吐量、低成本的数据可用性解决方案，是中心化数据可用性方案的去中心化替代方案。

```go
// EigenDA disperser客户端 - 将数据blob分散到EigenDA
package main

import (
    "context"
    "fmt"
    "time"

    disperser "github.com/Layr-Labs/eigenda/api/grpc/disperser"
    "google.golang.org/grpc"
    "google.golang.org/grpc/credentials/insecure"
)

func disperseBlob(data []byte) (*disperser.BlobStatus, error) {
    conn, err := grpc.Dial("disperser.eigenda.io:443", 
        grpc.WithTransportCredentials(insecure.NewCredentials()))
    if err != nil {
        return nil, err
    }
    defer conn.Close()

    client := disperser.NewDisperserClient(conn)
    ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
    defer cancel()

    // 使用自定义安全参数分散blob
    reply, err := client.DisperseBlob(ctx, &disperser.DisperseBlobRequest{
        Data: data,
        SecurityParams: []*disperser.SecurityParam{
            {
                QuorumId:           0,
                AdversaryThreshold: 25,
                QuorumThreshold:    50,
            },
        },
    })
    if err != nil {
        return nil, fmt.Errorf("分散失败: %w", err)
    }

    return reply.GetResult(), nil
}
```

```python
# EigenDA检索客户端 - 验证blob可用性
import asyncio
import grpc
from eigenda.api import retriever_pb2, retriever_pb2_grpc

async def retrieve_blob(batch_header_hash bytes, blob_index int):
    async with grpc.aio.insecure_channel('retriever.eigenda.io:443') as channel:
        stub = retriever_pb2_grpc.RetrieverStub(channel)
        
        request = retriever_pb2.RetrieveBlobRequest(
            batch_header_hash=batch_header_hash,
            blob_index=blob_index
        )
        
        response = await stub.RetrieveBlob(request)
        
        # 根据声明的承诺验证blob
        assert verify_kzg_proof(response.blob, response.kzg_proof), \
            "KZG证明验证失败"
        
        return response.blob
```

## 构建您的第一个AVS：完整开发者设置

本节提供在EigenLayer上构建AVS的分步指南。我们将创建一个简单的价格预言机AVS来演示关键模式。

### 前置条件

```bash
# 所需工具
node --version  # >= 18.0.0
foundry --version  # Forge 0.2.0+
go version  # >= 1.21

# 克隆EigenLayer中间件和合约
git clone https://github.com/Layr-Labs/eigenlayer-contracts.git
git clone https://github.com/Layr-Labs/eigenlayer-middleware.git
cd eigenlayer-middleware && forge install && cd ..
```

### 第1步：AVS合约架构

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@eigenlayer-middleware/BLSSignatureChecker.sol";
import "@eigenlayer-middleware/OperatorStateRetriever.sol";
import "./IPriceOracleAVS.sol";

contract PriceOracleAVS is BLSSignatureChecker, OperatorStateRetriever {
    
    // 运营商提交的价格数据
    struct PriceResponse {
        uint256 price;
        uint32 blockNumber;
        BN254.G1Point signature;
        BN254.G2Point pubkeyG2;
    }
    
    // 聚合价格及法定人数元数据
    struct AggregatedPriceUpdate {
        uint256 aggregatedPrice;
        uint32 quorumBlockNumber;
        bytes metadata;
    }
    
    // 追踪每种资产的最新确认价格
    mapping(bytes32 => AggregatedPriceUpdate) public latestPrices;
    
    event PriceUpdated(
        bytes32 indexed assetId,
        uint256 price,
        uint32 quorumBlockNumber
    );
    
    // 再质押集成
    IStakeRegistry public immutable stakeRegistry;
    IRegistryCoordinator public immutable registryCoordinator;
    
    constructor(
        address _stakeRegistry,
        address _registryCoordinator,
        address _blsSignatureChecker
    ) BLSSignatureChecker(_blsSignatureChecker) {
        stakeRegistry = IStakeRegistry(_stakeRegistry);
        registryCoordinator = IRegistryCoordinator(_registryCoordinator);
    }
    
    /// @notice 提交带BLS法定人数证书的聚合价格响应
    function confirmPriceUpdate(
        bytes32 assetId,
        uint256 proposedPrice,
        QuorumStakeTotals memory quorumStakeTotals,
        bytes32 apkHash,
        BN254.G1Point memory quorumApkIndices,
        BN254.G2Point memory nonSignerStakesAndSignature
    ) external {
        // 验证BLS法定人数签名
        require(
            checkSignatures(
                keccak256(abi.encodePacked(assetId, proposedPrice)),
                quorumStakeTotals,
                apkHash,
                quorumApkIndices,
                nonSignerStakesAndSignature
            ),
            "法定人数验证失败"
        );
        
        // 存储聚合价格
        latestPrices[assetId] = AggregatedPriceUpdate({
            aggregatedPrice: proposedPrice,
            quorumBlockNumber: uint32(block.number),
            metadata: abi.encode(quorumStakeTotals)
        });
        
        emit PriceUpdated(assetId, proposedPrice, uint32(block.number));
    }
}
```

### 第2步：运营商节点实现

```go
// operator/price_task_generator.go
package operator

import (
    "context"
    "crypto/sha256"
    "encoding/json"
    "fmt"
    "math/big"
    "time"

    "github.com/Layr-Labs/eigensdk-go/chainio/clients"
    "github.com/Layr-Labs/eigensdk-go/crypto/bls"
    "github.com/Layr-Labs/eigensdk-go/logging"
)

type PriceTaskGenerator struct {
    logger            logging.Logger
    ethClient         *clients.EthereumClient
    blsKeypair        *bls.KeyPair
    priceOracleAVS    *PriceOracleAVSClient
    aggregatorRpcUrl  string
}

func NewPriceTaskGenerator(
    logger logging.Logger,
    ethClient *clients.EthereumClient,
    blsKeypair *bls.KeyPair,
    aggregatorRpcUrl string,
) *PriceTaskGenerator {
    return &PriceTaskGenerator{
        logger:           logger,
        ethClient:        ethClient,
        blsKeypair:       blsKeypair,
        aggregatorRpcUrl: aggregatorRpcUrl,
    }
}

// 为给定任务生成并签名价格响应
func (g *PriceTaskGenerator) ProcessNewTask(
    ctx context.Context,
    task PriceOracleTask,
) (*SignedPriceResponse, error) {
    
    // 从多个CEX/DEX来源获取价格
    price, err := g.fetchAggregatedPrice(ctx, task.AssetId)
    if err != nil {
        return nil, fmt.Errorf("获取价格失败: %w", err)
    }
    
    // 构造响应摘要
    responseDigest := g.calculateResponseDigest(task, price)
    
    // 使用BLS12-381密钥对签名
    signature := g.blsKeypair.Sign(responseDigest)
    
    signedResponse := &SignedPriceResponse{
        TaskId:        task.TaskId,
        AssetId:       task.AssetId,
        Price:         price,
        BlockNumber:   task.CreationBlockNumber,
        Signature:     signature,
        PubkeyG1:      g.blsKeypair.GetPubKeyG1(),
        PubkeyG2:      g.blsKeypair.GetPubKeyG2(),
    }
    
    g.logger.Info("已签名价格响应",
        "asset", task.AssetId,
        "price", price,
        "taskId", task.TaskId,
    )
    
    return signedResponse, nil
}

// fetchAggregatedPrice查询多个来源并返回中位数
func (g *PriceTaskGenerator) fetchAggregatedPrice(
    ctx context.Context,
    assetId string,
) (*big.Int, error) {
    sources := []PriceSource{
        NewBinanceSource(),
        NewCoinbaseSource(),
        NewChainlinkSource(),
    }
    
    var prices []*big.Int
    for _, source := range sources {
        price, err := source.GetPrice(ctx, assetId)
        if err != nil {
            g.logger.Warn("价格来源失败", "source", source.Name(), "err", err)
            continue
        }
        prices = append(prices, price)
    }
    
    if len(prices) < 2 {
        return nil, fmt.Errorf("价格来源不足: 获得 %d 个, 需要2+", len(prices))
    }
    
    return calculateMedian(prices), nil
}
```

### 第3步：聚合器服务

```go
// aggregator/aggregator.go
package aggregator

import (
    "context"
    "fmt"
    "sync"
    
    "github.com/Layr-Labs/eigensdk-go/logging"
    "github.com/Layr-Labs/eigensdk-go/types"
)

// 聚合器收集签名响应并构建法定人数证书
type PriceAggregator struct {
    logger           logging.Logger
    avsRegistry      AVSRegistryReader
    priceOracleAVS   *PriceOracleAVSContract
    
    // 任务追踪
    tasks        map[uint32]*TaskState
    tasksMu      sync.RWMutex
    
    // 法定人数配置
    quorumThresholdPercentage uint32
    aggregatePubkeyTimeout    int64
}

func (a *PriceAggregator) ProcessSignedPriceResponse(
    response *SignedPriceResponse,
) error {
    a.tasksMu.Lock()
    defer a.tasksMu.Unlock()
    
    taskState, exists := a.tasks[response.TaskId]
    if !exists {
        return fmt.Errorf("任务 %d 不存在", response.TaskId)
    }
    
    if taskState.Status != TaskStatusPending {
        return fmt.Errorf("任务 %d 已处理", response.TaskId)
    }
    
    // 验证运营商是否已注册且已质押
    operatorStake, err := a.avsRegistry.GetOperatorStake(
        response.PubkeyG1,
        response.TaskId,
    )
    if err != nil {
        return fmt.Errorf("质押检查失败: %w", err)
    }
    
    if operatorStake.IsZero() {
        return fmt.Errorf("运营商无质押")
    }
    
    // 存储响应
    responseKey := types.Bytes32(response.Signature.Hash())
    taskState.Responses[responseKey] = response
    
    // 尝试聚合
    return a.tryAggregateResponses(taskState)
}
```

### 第4步：部署脚本

```bash
#!/bin/bash
# deploy_avs.sh - 将PriceOracle AVS部署到主网

set -e

# 配置
export PRIVATE_KEY=${PRIVATE_KEY:?"需要PRIVATE_KEY"}
export RPC_URL=${RPC_URL:-"https://eth-mainnet.g.alchemy.com/v2/$ALCHEMY_KEY"}
export EIGENLAYER_DEPLOYMENT=$(cat eigenlayer_deployment_block.json)

# 部署注册合约
echo "=== 部署注册协调器 ==="
forge script script/DeployPriceOracleAVS.s.sol:DeployRegistry \
    --rpc-url $RPC_URL \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    -vvvv

REGISTRY_COORDINATOR=$(cat broadcast/DeployPriceOracleAVS.s.sol/1/run-latest.json | jq -r '.transactions[0].contractAddress')

# 部署质押注册表
echo "=== 部署质押注册表 ==="
forge script script/DeployPriceOracleAVS.s.sol:DeployStakeRegistry \
    --rpc-url $RPC_URL \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    --sig "run(address)" $REGISTRY_COORDINATOR

echo "=== 部署完成 ==="
echo "注册协调器: $REGISTRY_COORDINATOR"
```

```solidity
// script/DeployPriceOracleAVS.s.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/PriceOracleAVS.sol";

contract DeployAVS is Script {
    function run(address stakeRegistry, address registryCoordinator) external {
        vm.startBroadcast();
        
        PriceOracleAVS priceOracleAVS = new PriceOracleAVS(
            stakeRegistry,
            registryCoordinator,
            EIGENLAYER_BLS_SIGNATURE_CHECKER
        );
        
        vm.stopBroadcast();
        
        console.log("PriceOracleAVS部署于:", address(priceOracleAVS));
    }
}
```

## 惩罚条件与风险管理

EigenLayer的关键方面之一是惩罚机制。当运营商选择加入AVS时，他们需要接受超出以太坊共识的额外惩罚条件。

```solidity
// PriceOracle AVS的自定义惩罚条件
interface ISlasher {
    function freezeOperator(address operator) external;
    function resetFrozenStatus(address operator) external;
}

contract PriceOracleSlashing {
    
    struct SlashingRecord {
        bytes32 reason;
        uint32 blockNumber;
        uint256 stakeAmount;
    }
    
    mapping(address => SlashingRecord[]) public slashingHistory;
    
    // 惩罚条件：
    // 1. 对同一任务签名不同的价格
    // 2. 未在响应窗口内响应
    // 3. 签名的价格超出偏差阈值
    
    function slashDivergentResponse(
        address operator,
        PriceResponse memory response1,
        PriceResponse memory response2,
        BN254.G1Point memory signature1,
        BN254.G1Point memory signature2
    ) external {
        require(
            verifyDoubleSigning(response1, response2, signature1, signature2),
            "不是有效的双重签名事件"
        );
        
        // 计算惩罚金额（AVS特定质押的100%）
        uint256 slashAmount = getAVSStake(operator);
        
        // 执行通过EigenLayer的惩罚
        delegationManager.queueWithdrawals(
            operator,
            strategies,
            shares // 扣除惩罚金额
        );
        
        emit OperatorSlashed(operator, slashAmount, "DIVERGENT_RESPONSE");
    }
}
```

```go
// 监控运营商健康状况并检测可惩罚事件
package monitoring

import (
    "context"
    "math/big"
    "time"
)

type SlashMonitor struct {
    ethClient       *ethclient.Client
    avsContract     *PriceOracleAVS
    alertWebhook    string
}

func (m *SlashMonitor) StartMonitoring(ctx context.Context) {
    ticker := time.NewTicker(12 * time.Second) // 以太坊出块时间
    defer ticker.Stop()
    
    for {
        select {
        case <-ctx.Done():
            return
        case <-ticker.C:
            m.checkForSlashableEvents(ctx)
        }
    }
}
```

## 奖励分配机制

EigenLayer的奖励分配允许AVS开发者激励运营商的验证工作。

```solidity
// PriceOracle AVS的奖励分配合约
contract PriceOracleRewards is IRewardsCoordinator {
    
    using SafeERC20 for IERC20;
    
    IERC20 public rewardToken;
    uint256 public rewardsPerBlock;
    
    struct OperatorRewardInfo {
        uint256 accumulatedRewards;
        uint256 lastUpdateBlock;
        uint256 tasksCompleted;
    }
    
    mapping(address => OperatorRewardInfo) public operatorRewards;
    
    function distributeRewards(
        uint32 taskId,
        address[] calldata participatingOperators,
        uint256[] calldata performanceScores
    ) external onlyOwner {
        require(
            participatingOperators.length == performanceScores.length,
            "长度不匹配"
        );
        
        uint256 totalScore = 0;
        for (uint i = 0; i < performanceScores.length; i++) {
            totalScore += performanceScores[i];
        }
        
        uint256 totalReward = rewardsPerBlock * TASK_BLOCK_WINDOW;
        
        for (uint i = 0; i < participatingOperators.length; i++) {
            uint256 operatorShare = (totalReward * performanceScores[i]) / totalScore;
            
            OperatorRewardInfo storage info = operatorRewards[participatingOperators[i]];
            info.accumulatedRewards += operatorShare;
            info.lastUpdateBlock = uint32(block.number);
            info.tasksCompleted += 1;
        }
        
        emit RewardsDistributed(totalReward, block.number);
    }
    
    function claimRewards() external {
        OperatorRewardInfo storage info = operatorRewards[msg.sender];
        uint256 amount = info.accumulatedRewards;
        require(amount > 0, "没有可领取的奖励");
        
        info.accumulatedRewards = 0;
        rewardToken.safeTransfer(msg.sender, amount);
        
        emit RewardsClaimed(msg.sender, amount);
    }
}
```

## 流动性再质押代币（LRT）集成

对于不想运行自己验证者基础设施的用户，流动性再质押代币提供了便捷的入口。

```typescript
// TypeScript SDK用于LRT交互
import { ethers, Contract } from 'ethers';
import { EigenLayerSDK } from '@eigenlayer/sdk';

const sdk = new EigenLayerSDK({
  provider: new ethers.JsonRpcProvider('https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY'),
  network: 'mainnet'
});

// 存入stETH获取Renzo (ezETH)
async function depositForLRT(stethAmount: bigint) {
  const renzo = await sdk.getLRTProtocol('renzo');
  
  const tx = await renzo.deposit({
    token: 'stETH',
    amount: stethAmount,
    receiver: walletAddress,
  });
  
  const receipt = await tx.wait();
  console.log(`存入 ${stethAmount} stETH，获得 ezETH`);
  console.log(`交易: ${receipt.hash}`);
}

// 检查所有AVS仓位的收益
async function aggregateLRTYield() {
  const portfolio = await sdk.getLRTPortfolio(walletAddress);
  
  for (const position of portfolio.positions) {
    console.log(`\n${position.lrtSymbol}:`);
    console.log(`  余额: ${position.balance}`);
    console.log(`  底层ETH: ${position.underlyingETH}`);
    console.log(`  30天收益率: ${position.thirtyDayYield}%`);
  }
}
```

## 常见问题解答（FAQ）

**Q1：EigenLayer再质押最低需要多少ETH？**

A：原生再质押需要完整的验证者押金32 ETH。不过EigenLayer支持stETH、rETH、cbETH等流动性质押代币（LST），没有最低限额 —— 您可以再质押任何金额。ezETH和rsETH等流动性再质押代币（LRT）进一步降低了门槛，允许低至0.01 ETH等值的存款。

**Q2：在多个AVS再质押时惩罚风险如何运作？**

A：每个AVS定义自己的惩罚条件，您的质押ETH同时受您验证的每个AVS的所有条件约束。每个AVS的最大可惩罚金额有上限，但多个AVS承诺会复合您的风险敞口。Slasher合约以编程方式执行条件 —— 常见的可惩罚行为包括停机、证明无效的状态转换以及签名冲突消息。

**Q3：EigenDA与其他数据可用性解决方案有什么区别？**

A：EigenDA是一个去中心化数据可用性层，通过EigenLayer获得以太坊质押资本的安全保障。与Celestia（自有验证者集）或EIP-4844 blob（吞吐量有限）相比，EigenDA提供：(1) 通过再质押继承的以太坊级经济安全，(2) 通过disperser/retriever架构实现水平扩展，(3) 每个Rollup可灵活配置法定人数，以及(4) 大规模显著更低的成本 —— 目前目标吞吐量为10 MB/s，每个blob低于$0.001。

**Q4：AVS奖励如何计算和分配？**

A：每个AVS运营自己的奖励计划，通常由协议费用或通胀代币发行资助。奖励按比例分配，基于：(1) 委托给每个运营商的质押金额，(2) 运营商的绩效分数（在线时间、正确响应），以及 (3) AVS特定的奖励率。RewardsCoordinator合约处理领取分配，运营商通常收取委托人赚取奖励的5-15%作为委托费。

**Q5：我可以随时提取再质押的ETH吗？**

A：不能 —— EigenLayer强制执行约7天的取消委托和提取延迟（以太坊"激活延迟"纪元）。这个冷却期是防范闪电贷攻击的安全措施，并给予协议处理任何待处理惩罚事件的时间。发起提取后，您的资金完成退出队列，在延迟期结束后可提取到您的钱包。

**Q6：构建AVS需要什么编程语言和框架？**

A：智能合约层使用Solidity（Foundry框架）。运营商节点通常使用EigenSDK以Go语言构建。BLS签名聚合需要`eigen-crypto`库。参考EigenDA实现使用Go构建disperser/retriever服务，Rust构建节点客户端。Docker和Kubernetes是生产部署的标准选择。

**Q7：运营商选择和委托如何运作？**

A：质押者在DelegationManager中浏览已注册的运营商，并将他们的再质押仓位委托给选择的运营商。运营商必须使用BLS公钥和最低质押要求注册。选择运营商时，请考虑：佣金率（5-15%）、AVS覆盖范围（他们验证哪些AVS）、历史绩效（在线率%）和再质押金额（通常越高越安全）。您可以无需解押即时重新委托。

---



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 快速开始：您的EigenLayer清单

```bash
# 1. 设置开发环境
git clone https://github.com/Layr-Labs/eigenlayer-contracts.git
cd eigenlayer-contracts && forge install

# 2. 配置环境
cp .env.example .env
# 编辑.env文件，填入您的RPC端点和私钥

# 3. 运行带有EigenLayer合约的本地测试网
anvil --fork-url $MAINNET_RPC --block-time 12
forge script script/DeployEigenLayer.s.sol --rpc-url http://localhost:8545 --broadcast

# 4. 部署您的AVS合约
forge script script/DeployYourAVS.s.sol --rpc-url http://localhost:8545 --broadcast

# 5. 启动运营商节点
cd operator/
go run main.go --config config.yaml

# 6. 监控运营
make telemetry
# 在 http://localhost:3000 打开Grafana仪表板
```

---

*免责声明：本指南仅供教育目的。再质押涉及重大的智能合约风险、惩罚风险和协议风险。在部署资金或代码之前，请务必进行自己的研究。DYOR —— 做好自己的研究。*

**准备好开始在EigenLayer上构建了吗？**
- 在 [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) 注册以获取用于质押的ETH
- 使用 [Minara](https://minara.ai/r/OSXG4X) 探索自动化AVS部署
- 关注我们的Telegram获取最新的EigenLayer资讯：**@dibi8crypto**

---

*© 2026 dibi8.com | 为DeFi开发者、交易者和研究人员而建。*
