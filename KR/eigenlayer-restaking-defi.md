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
- /kr/posts/eigenlayer-restaking-defi/
---

{{</* resource-info */>}}

> **제휴 공개**: 본 문서에는 [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) 및 [Minara](https://minara.ai/r/OSXG4X) 제휴 링크가 포함되어 있습니다. 이 링크를 통해 등록하시면 커미션을 받을 수 있으며, 추가 비용은 발생하지 않습니다.

---

## EigenLayer란 무엇이며 왜 중요한가?

EigenLayer는 지분 증명(PoS) 이후 이더리움 스테이킹 경제에서 가장 중요한 혁신입니다. 이더리움 메인넷에 론칭된 재스테이킹 프로토콜로, EigenLayer는 ETH 스테이커들이 이미 스테이킹된 ETH를 재사용하여 이더리움 컨센서스를 넘어선 추가적인 분산형 서비스 — **적극적 검증 서비스(AVS)** — 를 보호할 수 있게 합니다. 2026년 5월 기준으로 EigenLayer의 **총 예치 가치(TVL)는 200억 달러를 돌파**하여 담당 자본 기준 최대 규모의 DeFi 프로토콜 중 하나가 되었습니다.

핵심 아이디어는 우아하면서도 강력합니다: 모든 새로운 프로토콜이 처음부터 자체 검증자 세트를 구축할 필요 없이, EigenLayer는 이미 ETH 검증자들이 스테이킹한 자본을 활용하여 **이더리움의 경제적 보안을 상속**받을 수 있게 합니다. 이 "공유 보안" 개념은 새로운 분산형 인프라의 진입 장벽을 극적으로 낮추면서, 동일한 기본 스테이크에서 이제 추가 보상을 받을 수 있는 스테이커들의 자본 효율성을 높입니다.

## 재스테이킹 메커니즘: 낮은 수준의 작동 방식

EigenLayer에서의 재스테이킹은 이더리움 검증자들이 추가 프로토콜 보안에 옵트인할 수 있게 합니다. 검증자가 재스테이킹할 때, 선택한 각 AVS에서 정의한 추가 슬래싱 조건에 자신을 노출시킵니다.

재스테이킹 포지션의 라이프사이클은 다음 단계를 따릅니다:

```bash
# 1단계: 이더리움 비콘 체인에서 ETH 스테이킹
# 단독 검증자는 32 ETH, 또는 유동성 스테이킹 토큰(LST) 사용

# 2단계: 스테이킹된 ETH를 EigenLayer에 입금
# 네이티브 ETH 또는 stETH, rETH, cbETH 같은 LST 가능
curl -X POST https://api.eigenlayer.com/restake \
  -H "Content-Type: application/json" \
  -d '{
    "strategy": "0x93c4b944...",
    "amount": "1000000000000000000",
    "staker": "0x귀하의주소..."
  }'
```

```solidity
// 3단계: EigenLayer 전략 관리자가 기본 전략에 입금
// 파일: StrategyManager.sol (단순화)
function depositIntoStrategy(
    IStrategy strategy,
    IERC20 token,
    uint256 amount
) external returns (uint256 shares) {
    // 토큰을 스테이커에서 전략 계약으로 전송
    token.safeTransferFrom(msg.sender, address(strategy), amount);
    // 전략이 입금을 실행하고 지분 반환
    shares = strategy.deposit(token, amount);
    // 스테이커의 지분 기록
    _addShares(msg.sender, strategy, shares);
    return shares;
}
```

```solidity
// 4단계: 스테이커가 오퍼레이터에 위임
// 오퍼레이터는 AVS 검증 소프트웨어를 실행
function delegateTo(
    address operator,
    SignatureWithExpiry memory stakerSignatureAndExpiry,
    bytes32 approverSignatureAndExpiry
) external {
    require(isOperator(operator), "오퍼레이터 미등록");
    delegationManager.delegateTo(
        operator, 
        stakerSignatureAndExpiry, 
        approverSignatureAndExpiry
    );
}
```

```solidity
// 5단계: 오퍼레이터가 AVS 슬래싱 조건에 옵트인
// AVS 계약이 커스텀 검증 및 슬래싱 로직 정의
interface IAVSRegistry {
    function registerOperatorToAVS(
        address operator,
        bytes32 salt,
        uint256 expiry,
        bytes memory signature
    ) external;
}

// 오퍼레이터가 EigenDA AVS에 옵트인
function optInToEigenDA(bytes memory blsPublicKey) external {
    eigenDARegistry.registerOperatorToAVS(
        msg.sender,
        keccak256(abi.encodePacked(block.timestamp)),
        block.timestamp + 7 days,
        blsSignature
    );
}
```

## 적극적 검증 서비스(AVS): 애플리케이션 레이어

AVS는 EigenLayer의 공유 보안을 활용하는 프로토콜과 서비스입니다. 데이터 가용성부터 오라클, 브리지, 시퀀서 등 다양한 사용 사례를 포괄합니다. 각 AVS는 자체 검증 로직, 보상 구조, 슬래싱 조건을 정의합니다.

### EigenDA: 주력 데이터 가용성 AVS

EigenDA는 EigenLayer 위에 구축된 가장 유명한 AVS입니다. 이더리움 롤업을 위한 고처리량, 저비용 데이터 가용성 솔루션을 제공하며, 중앙화된 데이터 가용성 솔루션에 대한 탈중앙화 대안 역할을 합니다.

```go
// EigenDA disperser 클라이언트 - EigenDA에 blob 분산
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

    // 커스텀 보안 파라미터로 blob 분산
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
        return nil, fmt.Errorf("분산 실패: %w", err)
    }

    return reply.GetResult(), nil
}
```

```python
# EigenDA 검색 클라이언트 - blob 가용성 검증
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
        
        # blob을 주장된 커밋먼트 대해 검증
        assert verify_kzg_proof(response.blob, response.kzg_proof), \
            "KZG 증명 검증 실패"
        
        return response.blob
```

## 첫 번째 AVS 구축하기: 완전한 개발자 설정

본 섹션은 EigenLayer에서 AVS를 구축하기 위한 단계별 가이드를 제공합니다. 핵심 패턴을 보여주는 간단한 가격 오라클 AVS를 생성합니다.

### 전제 조건

```bash
# 필수 도구
node --version  # >= 18.0.0
foundry --version  # Forge 0.2.0+
go version  # >= 1.21

# EigenLayer 미들웨어 및 계약 복제
git clone https://github.com/Layr-Labs/eigenlayer-contracts.git
git clone https://github.com/Layr-Labs/eigenlayer-middleware.git
cd eigenlayer-middleware && forge install && cd ..
```

### 1단계: AVS 계약 아키텍처

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@eigenlayer-middleware/BLSSignatureChecker.sol";
import "@eigenlayer-middleware/OperatorStateRetriever.sol";
import "./IPriceOracleAVS.sol";

contract PriceOracleAVS is BLSSignatureChecker, OperatorStateRetriever {
    
    // 오퍼레이터가 제출한 가격 데이터
    struct PriceResponse {
        uint256 price;
        uint32 blockNumber;
        BN254.G1Point signature;
        BN254.G2Point pubkeyG2;
    }
    
    // 정족수 메타데이터가 포함된 집계 가격
    struct AggregatedPriceUpdate {
        uint256 aggregatedPrice;
        uint32 quorumBlockNumber;
        bytes metadata;
    }
    
    // 자산별 최신 확인 가격 추적
    mapping(bytes32 => AggregatedPriceUpdate) public latestPrices;
    
    event PriceUpdated(
        bytes32 indexed assetId,
        uint256 price,
        uint32 quorumBlockNumber
    );
    
    // 재스테이킹 통합
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
    
    /// @notice BLS 정족수 인증서와 함께 집계 가격 응답 제출
    function confirmPriceUpdate(
        bytes32 assetId,
        uint256 proposedPrice,
        QuorumStakeTotals memory quorumStakeTotals,
        bytes32 apkHash,
        BN254.G1Point memory quorumApkIndices,
        BN254.G2Point memory nonSignerStakesAndSignature
    ) external {
        // BLS 정족수 서명 검증
        require(
            checkSignatures(
                keccak256(abi.encodePacked(assetId, proposedPrice)),
                quorumStakeTotals,
                apkHash,
                quorumApkIndices,
                nonSignerStakesAndSignature
            ),
            "정족수 검증 실패"
        );
        
        // 집계 가격 저장
        latestPrices[assetId] = AggregatedPriceUpdate({
            aggregatedPrice: proposedPrice,
            quorumBlockNumber: uint32(block.number),
            metadata: abi.encode(quorumStakeTotals)
        });
        
        emit PriceUpdated(assetId, proposedPrice, uint32(block.number));
    }
}
```

### 2단계: 오퍼레이터 노드 구현

```go
// operator/price_task_generator.go
package operator

import (
    "context"
    "crypto/sha256"
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

// 주어진 작업에 대한 가격 응답 생성 및 서명
func (g *PriceTaskGenerator) ProcessNewTask(
    ctx context.Context,
    task PriceOracleTask,
) (*SignedPriceResponse, error) {
    
    // 여러 CEX/DEX 소스에서 가격 조회
    price, err := g.fetchAggregatedPrice(ctx, task.AssetId)
    if err != nil {
        return nil, fmt.Errorf("가격 조회 실패: %w", err)
    }
    
    // 응답 다이제스트 생성
    responseDigest := g.calculateResponseDigest(task, price)
    
    // BLS12-381 키페어로 서명
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
    
    g.logger.Info("가격 응답 서명됨",
        "asset", task.AssetId,
        "price", price,
        "taskId", task.TaskId,
    )
    
    return signedResponse, nil
}

// fetchAggregatedPrice는 여러 소스를 조회하고 중간값 반환
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
            g.logger.Warn("가격 소스 실패", "source", source.Name(), "err", err)
            continue
        }
        prices = append(prices, price)
    }
    
    if len(prices) < 2 {
        return nil, fmt.Errorf("가격 소스 부족: %d개 획득, 2+ 필요", len(prices))
    }
    
    return calculateMedian(prices), nil
}
```

### 3단계: 집계기 서비스

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

// 집계기는 서명된 응답을 수집하고 정족수 인증서를 구축
type PriceAggregator struct {
    logger           logging.Logger
    avsRegistry      AVSRegistryReader
    priceOracleAVS   *PriceOracleAVSContract
    
    tasks        map[uint32]*TaskState
    tasksMu      sync.RWMutex
    
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
        return fmt.Errorf("작업 %d 없음", response.TaskId)
    }
    
    if taskState.Status != TaskStatusPending {
        return fmt.Errorf("작업 %d 이미 처리됨", response.TaskId)
    }
    
    // 오퍼레이터가 등록되었고 스테이크되었는지 확인
    operatorStake, err := a.avsRegistry.GetOperatorStake(
        response.PubkeyG1,
        response.TaskId,
    )
    if err != nil {
        return fmt.Errorf("스테이크 확인 실패: %w", err)
    }
    
    if operatorStake.IsZero() {
        return fmt.Errorf("오퍼레이터에 스테이크 없음")
    }
    
    // 응답 저장
    responseKey := types.Bytes32(response.Signature.Hash())
    taskState.Responses[responseKey] = response
    
    // 집계 시도
    return a.tryAggregateResponses(taskState)
}
```

### 4단계: 배포 스크립트

```bash
#!/bin/bash
# deploy_avs.sh - PriceOracle AVS를 메인넷에 배포

set -e

# 설정
export PRIVATE_KEY=${PRIVATE_KEY:?"PRIVATE_KEY 필요"}
export RPC_URL=${RPC_URL:-"https://eth-mainnet.g.alchemy.com/v2/$ALCHEMY_KEY"}
export EIGENLAYER_DEPLOYMENT=$(cat eigenlayer_deployment_block.json)

# 레지스트리 계약 배포
echo "=== 레지스트리 코디네이터 배포 ==="
forge script script/DeployPriceOracleAVS.s.sol:DeployRegistry \
    --rpc-url $RPC_URL \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    -vvvv

REGISTRY_COORDINATOR=$(cat broadcast/DeployPriceOracleAVS.s.sol/1/run-latest.json | jq -r '.transactions[0].contractAddress')

# 스테이크 레지스트리 배포
echo "=== 스테이크 레지스트리 배포 ==="
forge script script/DeployPriceOracleAVS.s.sol:DeployStakeRegistry \
    --rpc-url $RPC_URL \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    --sig "run(address)" $REGISTRY_COORDINATOR

echo "=== 배포 완료 ==="
echo "레지스트리 코디네이터: $REGISTRY_COORDINATOR"
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
        
        console.log("PriceOracleAVS 배포 위치:", address(priceOracleAVS));
    }
}
```

## 슬래싱 조건 및 리스크 관리

EigenLayer의 핵심 측면 중 하나는 슬래싱 메커니즘입니다. 오퍼레이터가 AVS에 옵트인하면 이더리움 컨센서스를 넘어 추가 슬래싱 조건에 동의하게 됩니다.

```solidity
// PriceOracle AVS용 커스텀 슬래싱 조건
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
    
    // 슬래싱 조건:
    // 1. 동일한 작업에 대해 다른 가격 서명
    // 2. 응답 윈도우 내에서 응답하지 않음
    // 3. 편차 임계값을 초과하는 가격 서명
    
    function slashDivergentResponse(
        address operator,
        PriceResponse memory response1,
        PriceResponse memory response2,
        BN254.G1Point memory signature1,
        BN254.G1Point memory signature2
    ) external {
        require(
            verifyDoubleSigning(response1, response2, signature1, signature2),
            "유효한 이중 서명 이벤트 아님"
        );
        
        // 슬래시 금액 계산 (AVS 특정 스테이크의 100%)
        uint256 slashAmount = getAVSStake(operator);
        
        // EigenLayer를 통해 슬래시 실행
        delegationManager.queueWithdrawals(
            operator,
            strategies,
            shares // 슬래시 금액 감소
        );
        
        emit OperatorSlashed(operator, slashAmount, "DIVERGENT_RESPONSE");
    }
}
```

```go
// 오퍼레이터 상태 모니터링 및 슬래시 가능 이벤트 감지
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
    ticker := time.NewTicker(12 * time.Second) // 이더리움 블록 시간
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

## 보상 배분 메커니즘

EigenLayer의 보상 배분은 AVS 개발자가 검증 작업에 대한 오퍼레이터 인센티브를 제공할 수 있게 합니다.

```solidity
// PriceOracle AVS용 보상 배분 계약
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
            "길이 불일치"
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
        require(amount > 0, "청구할 보상 없음");
        
        info.accumulatedRewards = 0;
        rewardToken.safeTransfer(msg.sender, amount);
        
        emit RewardsClaimed(msg.sender, amount);
    }
}
```

## 유동성 재스테이킹 토큰(LRT) 통합

자체 검증자 인프라를 실행하고 싶지 않은 사용자를 위해 유동성 재스테이킹 토큰은 접근 가능한 진입점을 제공합니다.

```typescript
// LRT 상호작용용 TypeScript SDK
import { ethers, Contract } from 'ethers';
import { EigenLayerSDK } from '@eigenlayer/sdk';

const sdk = new EigenLayerSDK({
  provider: new ethers.JsonRpcProvider('https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY'),
  network: 'mainnet'
});

// stETH를 Renzo (ezETH)에 입금
async function depositForLRT(stethAmount: bigint) {
  const renzo = await sdk.getLRTProtocol('renzo');
  
  const tx = await renzo.deposit({
    token: 'stETH',
    amount: stethAmount,
    receiver: walletAddress,
  });
  
  const receipt = await tx.wait();
  console.log(`${stethAmount} stETH 입금 완료, ezETH 수령`);
  console.log(`트랜잭션: ${receipt.hash}`);
  
  // 기본 AVS 노출 쿼리
  const avsExposure = await renzo.getAVSExposure(walletAddress);
  console.log('AVS 할당:', avsExposure);
}

// 모든 AVS 포지션에서 수익 확인
async function aggregateLRTYield() {
  const portfolio = await sdk.getLRTPortfolio(walletAddress);
  
  for (const position of portfolio.positions) {
    console.log(`\n${position.lrtSymbol}:`);
    console.log(`  잔액: ${position.balance}`);
    console.log(`  기본 ETH: ${position.underlyingETH}`);
    console.log(`  30일 수익률: ${position.thirtyDayYield}%`);
  }
}
```

## FAQ: EigenLayer에 대해 자주 묻는 질문

**Q1: EigenLayer 재스테이킹에 필요한 최소 ETH는 얼마인가요?**

A: 네이티브 재스테이킹의 경우 32 ETH가 필요합니다. 그러나 EigenLayer는 stETH, rETH, cbETH와 같은 유동성 스테이킹 토큰(LST)을 지원하며 최소 금액 제한이 없습니다 — 0.01 ETH 등가로 입금할 수 있는 ezETH, rsETH와 같은 유동성 재스테이킹 토큰(LRT)이 진입 장벽을 더 낮춥니다.

**Q2: 여러 AVS에 걸쳐 재스테이킹할 때 슬래싱 리스크는 어떻게 작동하나요?**

A: 각 AVS는 자체 슬래싱 조건을 정의하며, 스테이킹된 ETH는 검증하는 모든 AVS의 조건에 동시에 적용됩니다. AVS당 최대 슬래시 금액은 제한되지만 여러 AVS 커밋이 리스크 노출을 복합시킵니다. Slasher 계약이 프로그래밍 방식으로 조건을 시행하며, 일반적인 슬래시 가능 위반에는 다운타임, 잘못된 상태 전환 증명, 충돌 메시지 서명이 포함됩니다.

**Q3: EigenDA와 다른 데이터 가용성 솔루션의 차이점은 무엇인가요?**

A: EigenDA는 EigenLayer를 통해 이더리움의 스테이킹 자본으로 보안되는 탈중앙화 데이터 가용성 레이어입니다. Celestia(자체 검증자 세트)나 EIP-4844 blob(처리량 제한)과 비교하여 EigenDA는: (1) 재스테이킹을 통해 상속되는 이더리움급 경제적 보안, (2) 분산자/검색기 아키텍처를 통한 수평 확장성, (3) 롤업당 유연한 정족수 구성, (4) 규모에 따른 획기적으로 낮은 비용 — 현재 blob당 $0.001 미만으로 10 MB/s 처리량을 목표로 합니다.

**Q4: AVS 보상은 어떻게 계산되고 배분되나요?**

A: 각 AVS는 프로토콜 수수료나 인플레이션 토큰 발행으로 자체 보상 프로그램을 운영합니다. 보상은 다음을 기준으로 비례 배분됩니다: (1) 각 오퍼레이터에 위임된 스테이크 금액, (2) 오퍼레이터 성과 점수(가동 시간, 정확한 응답), (3) AVS별 보상률. RewardsCoordinator 계약이 청구 배분을 처리하며, 오퍼레이터는 일반적으로 위임자가 얻은 보상에 대해 5-15% 수수료를 받습니다.

**Q5: 언제든 재스테이킹된 ETH를 인출할 수 있나요?**

A: 아니요 — EigenLayer는 약 7일(이더리움 "활성화 지연" 에폭)의 위임 취소 및 인출 지연을 강제합니다. 이 쿨다운 기간은 플래시론 공격에 대한 보안 조치이며 보류 중인 슬래싱 이벤트를 처리할 시간을 제공합니다. 인출을 시작한 후 자금은 종료 큐를 완료하고 지연 기간이 만료된 후 지갑으로 인출 가능해집니다.

**Q6: AVS를 구축하려면 어떤 프로그래밍 언어와 프레임워크가 필요한가요?**

A: 스마트 계약 레이어는 Solidity(Foundry 프레임워크)를 사용합니다. 오퍼레이터 노드는 일반적으로 EigenSDK를 사용한 Go로 구축됩니다. BLS 서명 집계에는 `eigen-crypto` 라이브러리가 필요합니다. 참조 EigenDA 구현은 분산자/검색기 서비스에 Go, 노드 클라이언트에 Rust를 사용합니다. Docker와 Kubernetes가 프로덕션 배포의 표준입니다.

**Q7: 오퍼레이터 선택과 위임은 어떻게 작동하나요?**

A: 스테이커들은 DelegationManager에서 등록된 오퍼레이터를 탐색하고 원하는 오퍼레이터에게 재스테이킹 포지션을 위임합니다. 오퍼레이터는 BLS 공개 키와 최소 스테이크 요구사항으로 등록해야 합니다. 오퍼레이터 선택 시 고려사항: 커미션 비율(5-15%), AVS 커버리지(어떤 AVS를 검증하는지), 과거 성과(가동 시간 %), 재스테이킹 금액(높을수록 일반적으로 더 안전). 언스테이킹 없이 즉시 재위임할 수 있습니다.

---



## 추천 호스팅 및 인프라

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영을 지원합니다.*

## 시작하기: EigenLayer 체크리스트

```bash
# 1. 개발 환경 설정
git clone https://github.com/Layr-Labs/eigenlayer-contracts.git
cd eigenlayer-contracts && forge install

# 2. 환경 구성
cp .env.example .env
# .env 파일을 RPC 엔드포인트와 개인키로 편집

# 3. EigenLayer 계약이 있는 로컬 테스트넷 실행
anvil --fork-url $MAINNET_RPC --block-time 12
forge script script/DeployEigenLayer.s.sol --rpc-url http://localhost:8545 --broadcast

# 4. AVS 계약 배포
forge script script/DeployYourAVS.s.sol --rpc-url http://localhost:8545 --broadcast

# 5. 오퍼레이터 노드 시작
cd operator/
go run main.go --config config.yaml

# 6. 운영 모니터링
make telemetry
# http://localhost:3000에서 Grafana 대시보드 열기
```

---

*면책 조항: 본 가이드는 교육 목적만을 위한 것입니다. 재스테이킹에는 상당한 스마트 계약 리스크, 슬래싱 리스크, 프로토콜 리스크가 포함됩니다. 자금이나 코드를 배포하기 전에 항상 자체 연구를 수행하십시오. DYOR — Do Your Own Research(자체 연구 수행).*

**EigenLayer에서 구축을 시작할 준비가 되셨나요?**
- 스테이킹용 ETH를 획득하려면 [Binance](https://www.bsmkweb.cc/register?ref=DIBI8)에 등록하세요
- [Minara](https://minara.ai/r/OSXG4X)로 자동화된 AVS 배포를 탐색하세요
- 최신 EigenLayer 정보를 위해 Telegram을 팔로우하세요: **@dibi8crypto**

---

*© 2026 dibi8.com | DeFi 개발자, 트레이더, 연구원을 위해 제작되었습니다.*
