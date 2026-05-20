---
title: 'pendle-yield-tokenization-defi'
description: ''
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
github_repo: 'https://github.com/pendle-finance/pendle-core-v2-public'
stars: 500
maintainer: 'pendle-finance'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: ['Pendle']
aliases:
- /kr/posts/pendle-yield-tokenization-defi/
---

{{</* resource-info */>}}

> **제휴 공개**: 본 문서에는 [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) 및 [OKX](https://www.promoohubly.com/join/12190433) 제휴 링크가 포함되어 있습니다. 이 링크를 통해 등록하시면 커미션을 받을 수 있으며, 추가 비용은 발생하지 않습니다.

---

## Pendle이란 무엇이며 왜 DeFi를 변화시키는가?

Pendle은 분산형 금융에서 최고의 수익 토큰화 프로토콜로, 사용자가 수익 창출 자산을 두 가지 구성 요소로 분리할 수 있게 합니다: **원금 토큰(PT)** 및 **수익 토큰(YT)**. Ethereum에서 출시되어 현재 여러 체인에서 운영되는 이 획기적인 혁신은 DeFi 참가자들이 수익과 상호작용하는 방식을 재정의했습니다. 2026년 5월 기준으로 Pendle의 **총 예치 가치(TVL)는 50억 달러를 돌파**했으며 **30개 이상의 수익 자산**을 지원하여 암호화폐 생태계에서 가장 정교한 고정 수익 프로토콜 중 하나가 되었습니다.

Pendle의 핵심 통찰은 수익과 원금이 근본적으로 다른 위험 및 수익 프로파일을 가지고 있다는 것입니다. 이를 분리함으로써 Pendle은 두 개의 독립적인 시장을 만듭니다: 할인된 가격에 거래되고 만기에 1:1로 상환되는 PT의 고정금리 시장과 기저 자산의 모든 미래 수익을 포착하는 YT의 투기적 수익 시장. 이러한 분리는 기존 DeFi에서는 불가능했던 강력한 헤징, 투기, 레버리지 수익 노출 및 고정금리 대출 전략을 잠금 해제합니다.

## 수익 토큰화 메커니즘: Pendle의 작동 방식

Pendle의 핵심은 SY(Standardized Yield) 토큰 표준으로, 모든 수익 창출 토큰을 통합 인터페이스로 포장합니다. stETH와 같은 자산을 Pendle에 예치하면 프로토콜은 SY-stETH를 발행한 다음 이를 PT-stETH와 YT-stETH로 분할합니다.

```solidity
// Pendle 수익 토큰화 흐름
// 파일: PendleRouter.sol (간소화)

interface IPendleRouter {
    struct TokenizeYieldInput {
        address SY;
        address underlying;
        uint256 amountIn;
        address to;
    }
    
    /// @notice 수익 자산을 PT와 YT로 토큰화
    function mintPYFromToken(
        TokenizeYieldInput calldata input
    ) external returns (uint256 amountPYOut, uint256 amountYTOut);
}

contract PendleRouter is IPendleRouter {
    
    mapping(address => address) public SYToPT;
    mapping(address => address) public SYToYT;
    
    function mintPYFromToken(
        TokenizeYieldInput calldata input
    ) external returns (uint256 amountPYOut, uint256 amountYTOut) {
        // 1단계: 사용자로부터 기저 자산 전송
        IERC20(input.underlying).transferFrom(
            msg.sender, 
            address(this), 
            input.amountIn
        );
        
        // 2단계: SY 래퍼에 예치
        address SY = input.SY;
        uint256 syAmount = ISY(SY).deposit(
            address(this),
            input.underlying,
            input.amountIn,
            0 // minShares
        );
        
        // 3단계: SY에서 PT와 YT 발행
        address PT = SYToPT[SY];
        address YT = SYToYT[SY];
        
        // PT와 YT는 동일한 양으로 발행
        amountPYOut = syAmount;
        amountYTOut = syAmount;
        
        IPT(PT).mint(input.to, amountPYOut);
        IYT(YT).mint(input.to, amountYTOut);
        
        emit Tokenized(input.underlying, input.amountIn, amountPYOut);
    }
}
```

```solidity
// Lido stETH용 표준화 수익 토큰(SY) 구현
// 파일: SYStETH.sol

contract SYStETH is SYBase {
    
    IStETH public immutable stETH;
    IWstETH public immutable wstETH;
    
    constructor(
        address _stETH,
        address _wstETH
    ) SYBase("SY stETH", "SY-stETH", IERC20Metadata(_wstETH)) {
        stETH = IStETH(_stETH);
        wstETH = IWstETH(_wstETH);
    }
    
    /// @notice stETH를 예치하고 SY 토큰 수령
    function deposit(
        address receiver,
        address tokenIn,
        uint256 amountTokenToDeposit,
        uint256 minSharesOut
    ) external returns (uint256 amountSharesOut) {
        require(tokenIn == address(stETH) || tokenIn == address(wstETH), "유효하지 않은 토큰");
        
        if (tokenIn == address(stETH)) {
            // stETH를 wstETH로 래핑(리베이스 처리)
            IERC20(stETH).safeTransferFrom(msg.sender, address(this), amountTokenToDeposit);
            uint256 wstETHAmount = wstETH.wrap(amountTokenToDeposit);
            amountSharesOut = wstETHAmount;
        } else {
            IERC20(wstETH).safeTransferFrom(msg.sender, address(this), amountTokenToDeposit);
            amountSharesOut = amountTokenToDeposit;
        }
        
        require(amountSharesOut >= minSharesOut, "출력 불충분");
        _mint(receiver, amountSharesOut);
    }
    
    /// @notice 현재 환율 미리보기
    function exchangeRate() public view override returns (uint256) {
        // 누적 스테이킹 보상을 포함한 wstETH:stETH 환율 반환
        return wstETH.stEthPerToken();
    }
    
    /// @notice 기저 자산에서 수익을 청구하고 YT 보유자에게 분배
    function claimRewards(address user) external returns (uint256[] memory rewardAmounts) {
        // 마지막 청구 이후 누적 수익 계산
        uint256 yieldAccrued = _calculateYieldAccrual(user);
        
        // 수익을 YT 보유자에게 전송
        if (yieldAccrued > 0) {
            IERC20(stETH).safeTransfer(user, yieldAccrued);
        }
        
        rewardAmounts = new uint256[](1);
        rewardAmounts[0] = yieldAccrued;
    }
}
```

```solidity
// 원금 토큰(PT) 계약
// 파일: PTStETH.sol

contract PTStETH is PTBase {
    
    uint256 public immutable maturity;
    address public immutable SY;
    address public immutable YT;
    
    constructor(
        string memory _name,
        string memory _symbol,
        address _SY,
        address _YT,
        uint256 _maturity
    ) ERC20(_name, _symbol) {
        SY = _SY;
        YT = _YT;
        maturity = _maturity;
    }
    
    /// @notice 만기 시 PT를 1:1로 기저 자산으로 상환
    function redeem(
        address receiver,
        uint256 amountPTToRedeem
    ) external returns (uint256 amountSyOut) {
        require(block.timestamp >= maturity, "아직 만기되지 않음");
        
        // PT 토큰 소각
        _burn(msg.sender, amountPTToRedeem);
        
        // SY를 기저 자산으로 상환
        amountSyOut = ISY(SY).redeem(
            receiver,
            amountPTToRedeem,
            address(ISY(SY).yieldToken()),
            0
        );
    }
    
    /// @notice PT 가격에서 암묵적 APY 계산
    function getImpliedApy() external view returns (uint256 impliedApy) {
        uint256 ptPrice = _getMarketPrice();
        uint256 timeToMaturity = maturity - block.timestamp;
        
        // 암묵적 APY = (1/PT_Price)^(1/연수) - 1
        // 1년 만기에 PT 가격 0.95 = ~5.26% 고정 수익률
        impliedApy = _calculateImpliedFromPrice(ptPrice, timeToMaturity);
    }
}
```

```solidity
// 수익 토큰(YT) 계약
// 파일: YTStETH.sol

contract YTStETH is YTBase {
    
    address public immutable SY;
    address public immutable PT;
    uint256 public immutable maturity;
    
    // 사용자의 누적 수익 인덱스 추적
    mapping(address => uint256) public userIndex;
    mapping(address => uint256) public accruedRewards;
    
    constructor(
        string memory _name,
        string memory _symbol,
        address _SY,
        address _PT,
        uint256 _maturity
    ) ERC20(_name, _symbol) {
        SY = _SY;
        PT = _PT;
        maturity = _maturity;
    }
    
    /// @notice 호출자를 위한 누적 수익 청구
    function claimYield(address user) external returns (uint256 yieldOut) {
        _updateUserYield(user);
        
        yieldOut = accruedRewards[user];
        if (yieldOut > 0) {
            accruedRewards[user] = 0;
            // SY의 누적 보상에서 전송
            ISY(SY).claimRewards(user);
        }
    }
    
    /// @notice 글로벌 인덱스를 기반으로 사용자의 누적 수익 업데이트
    function _updateUserYield(address user) internal {
        uint256 currentIndex = ISY(SY).yieldIndex();
        uint256 userIdx = userIndex[user];
        
        if (userIdx == 0) {
            userIndex[user] = currentIndex;
            return;
        }
        
        uint256 balance = balanceOf(user);
        if (balance > 0 && currentIndex > userIdx) {
            uint256 yieldAccrued = (balance * (currentIndex - userIdx)) / 1e18;
            accruedRewards[user] += yieldAccrued;
        }
        
        userIndex[user] = currentIndex;
    }
    
    /// @notice 만기 후 YT는 남은 수익을 청구할 수 있음
    function redeemAfterMaturity(address user) external {
        require(block.timestamp > maturity, "만기 이후가 아님");
        
        uint256 ytBalance = balanceOf(user);
        require(ytBalance > 0, "YT 잔액 없음");
        
        _updateUserYield(user);
        
        // YT 소각
        _burn(user, ytBalance);
        
        // 남은 보상 청구
        uint256 remainingRewards = accruedRewards[user];
        if (remainingRewards > 0) {
            accruedRewards[user] = 0;
            ISY(SY).transferReward(user, remainingRewards);
        }
    }
}
```

## Pendle AMM: 프로처럼 수익 거래하기

Pendle의 자체 AMM은 만기에 다가감에 따라 시간 감가를 고려하는 특수 곡선을 사용하여 PT와 YT를 거래하도록 특별히 설계되었습니다.

```solidity
// Pendle 마켓 AMM
// 파일: PendleMarket.sol

contract PendleMarket is IPendleMarket {
    
    address public immutable PT;
    address public immutable SY;
    uint256 public immutable expiry;
    
    // AMM 상태
    uint256 public totalPt;
    uint256 public totalSy;
    uint256 public totalLp;
    
    // 수익 거래를 위한 곡선 파라미터
    int256 public immutable rateScalar;
    int256 public immutable rateAnchor;
    int256 public immutable feeRate;
    
    struct SwapInput {
        address tokenIn;
        uint256 amountIn;
        address tokenOut;
        uint256 minAmountOut;
    }
    
    /// @notice 특수 AMM 곡선을 사용한 PT와 SY 간 스왑
    function swapExactPtForSy(
        SwapInput calldata input
    ) external returns (uint256 amountSyOut) {
        // 만기까지 남은 시간을 기준으로 가격 계산
        uint256 timeToMaturity = expiry - block.timestamp;
        
        // Pendle의 특수 곡선: 만기에 다가감에 따라
        // PT 가격은 1.0(액면가)에 수렴
        uint256 ptRate = _getPtExchangeRate(timeToMaturity);
        
        // AMM 공식 적용
        amountSyOut = _ammSwap(
            input.amountIn,
            totalPt,
            totalSy,
            ptRate,
            true // ptToSy 방향
        );
        
        require(amountSyOut >= input.minAmountOut, "슬리피지 너무 높음");
        
        // 준비금 업데이트
        totalPt += input.amountIn;
        totalSy -= amountSyOut;
        
        emit Swap(msg.sender, input.tokenIn, input.tokenOut, input.amountIn, amountSyOut);
    }
    
    /// @notice logit 곡선을 사용한 PT 환율 계산
    function _getPtExchangeRate(
        uint256 timeToMaturity
    ) internal view returns (uint256 ptRate) {
        int256 lnImpliedRate = _getLnImpliedRate(timeToMaturity);
        int256 rateScalarInt = rateScalar;
        
        // ptRate = exp(-lnImpliedRate / rateScalar) / (1 + exp(-lnImpliedRate / rateScalar))
        ptRate = _logitCurve(lnImpliedRate, rateScalarInt, rateAnchor);
    }
    
    /// @notice 핵심 AMM 스왑 수학
    function _ammSwap(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut,
        uint256 exchangeRate,
        bool ptToSy
    ) internal pure returns (uint256 amountOut) {
        // Pendle은 만기까지 남은 시간을 기반으로 조정되는 동적 곡선 사용
        // 만기 근처: 곡선은 일정 합계(x + y = k)에 수렴
        // 만기에서 멈: 곡선은 일정 곱(x * y = k)에 수렴
        
        uint256 proportion = (amountIn * 1e18) / reserveIn;
        uint256 curveFactor = _calculateCurveFactor(exchangeRate);
        
        if (ptToSy) {
            amountOut = (reserveOut * proportion * curveFactor) / 1e36;
        } else {
            amountOut = (reserveOut * proportion) / (curveFactor * 1e18 / 1e18);
        }
        
        // 스왑 수수료 적용
        uint256 fee = (amountOut * uint256(feeRate)) / 1e18;
        amountOut -= fee;
    }
}
```

```typescript
// Pendle 거래용 TypeScript SDK
import { PendleSDK } from '@pendle/sdk-v2';
import { ethers } from 'ethers';

const provider = new ethers.JsonRpcProvider('https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY');
const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

const pendle = new PendleSDK({
  chainId: 1,
  provider,
  signer,
});

// PT를 기저 SY로 스왑
async function swapPtForSy(
  marketAddress: string,
  ptAmount: bigint,
  minSyOut: bigint
) {
  const market = pendle.getMarket(marketAddress);
  
  // PT 지출 승인
  await market.PT.approve(marketAddress, ptAmount);
  
  // 슬리피지 보호와 함께 스왑 실행
  const tx = await market.swapExactPtForSy(
    ptAmount,
    minSyOut,
    {
      deadline: Math.floor(Date.now() / 1000) + 300, // 5분
      recipient: await signer.getAddress(),
    }
  );
  
  const receipt = await tx.wait();
  console.log(`${ptAmount} PT를 SY로 스왑. TX: ${receipt.hash}`);
  
  return receipt;
}

// PT/SY 마켓에 유동성 제공
async function addLiquidity(
  marketAddress: string,
  syAmount: bigint,
  ptAmount: bigint
) {
  const market = pendle.getMarket(marketAddress);
  
  // 양면 유동성 제공
  const tx = await market.addLiquidityDual(
    syAmount,
    ptAmount,
    0, // minLpOut (적절한 슬리피지 허용치 설정)
    {
      deadline: Math.floor(Date.now() / 1000) + 300,
    }
  );
  
  const receipt = await tx.wait();
  
  // 수령한 LP 토큰 파싱
  const lpTokens = parseLPTokensFromReceipt(receipt);
  console.log(`유동성 추가 완료. ${lpTokens} LP 토큰 수령`);
  
  return lpTokens;
}

// 시장 데이터에서 암묵적 APY 계산
async function getMarketImpliedApy(marketAddress: string) {
  const market = pendle.getMarket(marketAddress);
  
  const marketData = await market.getMarketData();
  const ptPrice = marketData.ptPrice;
  const timeToMaturity = marketData.expiry - Math.floor(Date.now() / 1000);
  
  // 암묵적 APY 공식
  const yearsToMaturity = timeToMaturity / (365.25 * 24 * 3600);
  const impliedApy = (1 / ptPrice) ** (1 / yearsToMaturity) - 1;
  
  console.log(`PT 가격: ${ptPrice}`);
  console.log(`만기까지: ${yearsToMaturity.toFixed(2)} 년`);
  console.log(`암묵적 APY: ${(impliedApy * 100).toFixed(2)}%`);
  
  return impliedApy;
}
```

## PT 및 YT 전략: 고정 수익, 수익 투기 등

Pendle은 다양한 위험 선호도와 시장 관점에 맞는 여러 정교한 전략을 잠금 해제합니다.

### 고정 수익 전략(PT 구매)

```solidity
// 전략: 고정 수익을 위해 할인된 가격에 PT 구매
// 예시: 0.95에 PT-stETH 구매, 1년 만기에 1.0으로 상환
// 고정 수익률 = (1 - 0.95) / 0.95 = 5.26%

contract FixedIncomeStrategy {
    
    IPendleRouter public immutable router;
    address public immutable ptMarket;
    address public immutable pt;
    
    struct FixedIncomePosition {
        uint256 ptPurchased;
        uint256 costBasis;
        uint256 maturityDate;
        uint256 lockedYield; // 사전 계산된 고정 수익
    }
    
    mapping(address => FixedIncomePosition) public positions;
    
    /// @notice 고정 수익 잠금을 위해 PT 구매
    function buyFixedIncome(
        address market,
        uint256 amountIn,
        uint256 minPtOut,
        uint256 deadline
    ) external returns (uint256 ptReceived) {
        // PT 가격 및 암묵적 고정 수익률 계산
        uint256 ptPrice = _getPtPrice(market);
        uint256 timeToMaturity = _getTimeToMaturity(market);
        
        // 고정 수익률 계산
        uint256 fixedYield = ((1e18 - ptPrice) * 1e18) / ptPrice;
        uint256 annualizedYield = (fixedYield * (365 days)) / timeToMaturity;
        
        // PT 구매 실행
        ptReceived = router.swapExactSyForPt(
            market,
            amountIn,
            minPtOut,
            router.createDefaultLimitOrder(deadline)
        );
        
        // 포지션 기록
        positions[msg.sender] = FixedIncomePosition({
            ptPurchased: ptReceived,
            costBasis: amountIn,
            maturityDate: block.timestamp + timeToMaturity,
            lockedYield: fixedYield
        });
        
        emit FixedIncomePurchased(msg.sender, ptReceived, annualizedYield);
    }
    
    /// @notice 만기 시 PT 상환으로 보장된 원금 + 수익 수령
    function redeemAtMaturity() external {
        FixedIncomePosition storage pos = positions[msg.sender];
        require(block.timestamp >= pos.maturityDate, "만기되지 않음");
        
        uint256 underlyingReceived = IPT(pt).redeem(
            msg.sender,
            pos.ptPurchased
        );
        
        uint256 profit = underlyingReceived - pos.costBasis;
        
        delete positions[msg.sender];
        emit FixedIncomeRedeemed(msg.sender, underlyingReceived, profit);
    }
}
```

### 레버리지 수익 전략(YT 구매)

```solidity
// 전략: YT를 통한 수익 롱 포지션으로 스테이킹 수익에 대한 레버리지 노출
// ETH 스테이킹 수익률이 평균 4%인데 6%로 예상하면 YT를 구매하여 수익

contract LeveragedYieldStrategy {
    
    IPendleRouter public immutable router;
    address public immutable yt;
    address public immutable sy;
    
    struct YieldPosition {
        uint256 ytPurchased;
        uint256 costPerYt; // YT 지불 가격
        uint256 entryImpliedYield;
    }
    
    mapping(address => YieldPosition) public positions;
    
    /// @notice 레버리지 수익 노출을 위해 YT 구매
    function longYield(
        address market,
        uint256 amountIn,
        uint256 minYtOut
    ) external returns (uint256 ytReceived) {
        // YT 가격은 시장의 미래 수익 기대를 반영
        uint256 ytPrice = _getYtPrice(market);
        uint256 impliedYield = _getImpliedApy(market);
        
        // YT 구매: 각 YT는 기저 자산 1단위의 수익에 대한 청구권을 나타냄
        ytReceived = router.swapExactSyForYt(
            market,
            amountIn,
            minYtOut,
            _createLimitOrder()
        );
        
        positions[msg.sender] = YieldPosition({
            ytPurchased: ytReceived,
            costPerYt: (amountIn * 1e18) / ytReceived,
            entryImpliedYield: impliedYield
        });
        
        emit YieldLongOpened(msg.sender, ytReceived, impliedYield);
    }
    
    /// @notice YT 포지션에서 누적 수익 청구
    function claimAccumulatedYield() external returns (uint256 totalYield) {
        YieldPosition storage pos = positions[msg.sender];
        require(pos.ytPurchased > 0, "포지션 없음");
        
        // YT 계약에서 청구
        totalYield = IYT(yt).claimYield(msg.sender);
        
        emit YieldClaimed(msg.sender, totalYield);
    }
    
    /// @notice 포지션 청산 및 손익 계산
    function closeYieldLong() external returns (int256 pnl) {
        YieldPosition storage pos = positions[msg.sender];
        
        // 대기 중인 수익 청구
        uint256 pendingYield = IYT(yt).claimYield(msg.sender);
        
        // YT를 시장에 다시 판매
        uint256 syReceived = router.swapExactYtForSy(
            address(yt),
            pos.ytPurchased,
            0
        );
        
        // 손익 = 수령 가치 - 초기 비용
        uint256 totalReceived = syReceived + pendingYield;
        pnl = int256(totalReceived) - int256((pos.ytPurchased * pos.costPerYt) / 1e18);
        
        delete positions[msg.sender];
        emit YieldLongClosed(msg.sender, totalReceived, pnl);
    }
}
```

### 유동성 공급 전략

```typescript
// LP 전략: PT/SY 거래 수익 + PT 부분 고정 수익
async function provideLiquidityStrategy(
  marketAddress: string,
  totalCapital: bigint
) {
  const market = pendle.getMarket(marketAddress);
  
  // 자본 분할: 50% SY, 50% PT로 균형 잡힌 LP
  const syForLp = totalCapital / 2n;
  const ptForLp = totalCapital / 2n;
  
  // PT 확보(SY 분할 또는 스왑으로)
  // 옵션 1: SY에서 PT+YT 발행, YT 보유, LP용 PT 사용
  const { ptOut, ytOut } = await pendle.mintPyFromSy(
    market.SY,
    ptForLp + syForLp // 전체에서 발행, 분할 예정
  );
  
  // PT + SY로 유동성 추가
  const lpTokens = await market.addLiquidityDual(
    syForLp,
    ptOut / 2n,
    0
  );
  
  // 수익 노출을 위한 남은 YT 보유
  console.log(`LP 포지션: ${lpTokens} LP 토큰`);
  console.log(`YT 포지션: ${ytOut} YT 토큰(수익 노출)`);
  
  // 자동 복리 설정
  const autoCompounder = new PendleAutoCompounder({
    market: marketAddress,
    harvestInterval: 86400, // 일일
    minHarvestAmount: ethers.parseEther('0.01'),
  });
  
  await autoCompounder.start();
  
  return { lpTokens, ytOut, autoCompounder };
}
```

## Pendle 기반 구축: 개발자 통합 가이드

### Pendle 시장 데이터 읽기

```typescript
// Pendle에서 포괄적 시장 데이터 가져오기
import { PendleMarketReader } from '@pendle/sdk-v2/market';

async function analyzePendleMarkets() {
  const reader = new PendleMarketReader({
    chainId: 1,
    provider,
  });
  
  // 모든 활성 시장 가져오기
  const markets = await reader.getActiveMarkets();
  
  for (const market of markets) {
    const data = await reader.getMarketSnapshot(market.address);
    
    console.log(`\n=== ${market.underlyingSymbol} (${data.expiryDate}) ===`);
    console.log(`PT 가격: ${data.ptPrice.toFixed(4)}`);
    console.log(`YT 가격: ${data.ytPrice.toFixed(4)}`);
    console.log(`암묵적 APY: ${(data.impliedApy * 100).toFixed(2)}%`);
    console.log(`기저 APY: ${(data.underlyingApy * 100).toFixed(2)}%`);
    console.log(`유동성: $${(data.liquidityUSD / 1e6).toFixed(2)}M`);
    console.log(`24h 거래량: $${(data.volume24h / 1e6).toFixed(2)}M`);
    
    // 수익 스프레드 분석
    const yieldSpread = data.underlyingApy - data.impliedApy;
    console.log(`수익 스프레드: ${(yieldSpread * 100).toFixed(2)}%`);
    
    if (yieldSpread > 0.01) {
      console.log(`⚠️  과소평가: 시장이 기저 수익보다 적게 지불`);
    } else if (yieldSpread < -0.01) {
      console.log(`🟢 과대평가: 시장이 기저 수익보다 많이 지불`);
    }
  }
}
```

### Pendle Router 통합

```solidity
// Pendle을 DeFi 프로토콜에 통합
contract MyDeFiProtocol {
    
    IPendleRouter public immutable pendleRouter;
    
    /// @notice 예측 가능한 만기 가치로 PT를 담당으로 사용
    function depositPtCollateral(
        address pt,
        uint256 amount
    ) external returns (uint256 collateralValue) {
        // 만기 시 PT = 1 기저 자산, 따라서 가치 = amount * 1.0
        // 만기 전, 할인 계수 적용
        uint256 timeToMaturity = IPT(pt).maturity() - block.timestamp;
        uint256 discountFactor = _calculateDiscountFactor(timeToMaturity);
        
        collateralValue = (amount * discountFactor) / 1e18;
        
        // 사용자로부터 PT 전송
        IERC20(pt).transferFrom(msg.sender, address(this), amount);
        
        _recordCollateral(msg.sender, pt, amount, collateralValue);
    }
    
    /// @notice Pendle을 통해 수익 포지션으로 진입
    function zapIntoYield(
        address underlying,
        uint256 amount,
        uint256 minYtOut
    ) external returns (uint256 ytReceived) {
        // 이 기저 자산의 SY 래퍼 가져오기
        address sy = pendleRouter.getSY(underlying);
        
        // 승인 및 예치
        IERC20(underlying).approve(address(pendleRouter), amount);
        
        // SY 발행 후 YT로 분할(PT는 헤징용으로 계약에 보관)
        (uint256 ptOut, ytReceived) = pendleRouter.mintPyFromToken(
            IPendleRouter.TokenizeYieldInput({
                SY: sy,
                underlying: underlying,
                amountIn: amount,
                to: address(this)
            })
        );
        
        // YT는 사용자에게, PT는 예비로 보관
        IYT(pendleRouter.YT(sy)).transfer(msg.sender, ytReceived);
        
        emit ZappedIntoYield(msg.sender, underlying, amount, ytReceived);
    }
    
    function _calculateDiscountFactor(
        uint256 timeToMaturity
    ) internal pure returns (uint256) {
        // 선형 할인: 만기 시 = 1.0, 1년 시 = 0.95
        if (timeToMaturity == 0) return 1e18;
        
        uint256 maxDiscount = 0.05e18; // 5% 최대 할인
        uint256 discount = (maxDiscount * timeToMaturity) / (365 days);
        
        return 1e18 - discount;
    }
}
```

```typescript
// SDK 헬퍼: 최적 진입/청산 포인트 계산
class PendleStrategyAnalyzer {
  
  constructor(private sdk: PendleSDK) {}
  
  async findOptimalEntries(minLiquidityUSD: number = 1_000_000) {
    const markets = await this.sdk.getMarkets();
    const opportunities = [];
    
    for (const market of markets) {
      if (market.liquidityUSD < minLiquidityUSD) continue;
      
      const snapshot = await market.getSnapshot();
      const underlyingApy = await this.getUnderlyingApy(market.underlying);
      
      // PT 롱(고정 수익) 기회
      if (snapshot.impliedApy > underlyingApy * 1.2) {
        opportunities.push({
          market: market.address,
          strategy: 'LONG_PT',
          reason: '암묵적 수익률이 기저보다 20%+ 높음',
          expectedReturn: snapshot.impliedApy,
          risk: '낮음',
        });
      }
      
      // YT 롱(수익 투기) 기회
      if (snapshot.impliedApy < underlyingApy * 0.8) {
        opportunities.push({
          market: market.address,
          strategy: 'LONG_YT',
          reason: '암묵적 수익률이 기저보다 20%+ 낮음',
          expectedReturn: underlyingApy - snapshot.impliedApy,
          risk: '중간',
        });
      }
    }
    
    return opportunities.sort((a, b) => b.expectedReturn - a.expectedReturn);
  }
  
  async simulatePtHoldToMaturity(
    marketAddress: string,
    investmentAmount: bigint
  ) {
    const market = this.sdk.getMarket(marketAddress);
    const snapshot = await market.getSnapshot();
    
    const ptAmount = (investmentAmount * 1e18n) / BigInt(Math.floor(snapshot.ptPrice * 1e18));
    const redemptionValue = ptAmount; // PT는 만기 시 1:1 상환
    const profit = redemptionValue - investmentAmount;
    const roi = Number((profit * 10000n) / investmentAmount) / 100;
    
    const daysToMaturity = Math.floor(
      (snapshot.expiry - Date.now() / 1000) / 86400
    );
    
    const apy = roi * (365 / daysToMaturity);
    
    return {
      investment: investmentAmount,
      ptReceived: ptAmount,
      redemptionValue,
      profit,
      roi: `${roi}%`,
      daysToMaturity,
      apy: `${apy.toFixed(2)}%`,
    };
  }
}
```

## 수익 오라클 및 가격 발견

Pendle의 PT 가격은 선도 수익률에 대한 탈중앙화 오라클 역할을 합니다 — DeFi 고정 수익 시장의 중요한 기본 요소입니다.

```solidity
// Pendle을 수익 오라클로 사용
contract PendleYieldOracle {
    
    IPendleMarket public immutable market;
    address public immutable PT;
    uint256 public immutable maturity;
    
    /// @notice PT 가격에서 현재 암묵적 APY 가져오기
    function getImpliedApy() external view returns (uint256 impliedApy) {
        uint256 ptPrice = _getPtPrice();
        uint256 timeToMaturity = maturity - block.timestamp;
        
        // APY = (1/PT_Price)^(365/timeToMaturityDays) - 1
        uint256 yearsToMaturity = (timeToMaturity * 1e18) / (365 days);
        
        // 근사 사용: ln(1/PT) / 연수
        uint256 lnRatio = _ln((1e18 * 1e18) / ptPrice);
        impliedApy = (lnRatio * 1e18) / yearsToMaturity;
    }
    
    /// @notice 수익률 구조 가져오기(여러 만기)
    function getYieldCurve(
        address[] calldata ptMarkets
    ) external view returns (uint256[] memory maturities, uint256[] memory apys) {
        maturities = new uint256[](ptMarkets.length);
        apys = new uint256[](ptMarkets.length);
        
        for (uint i = 0; i < ptMarkets.length; i++) {
            IPendleMarket m = IPendleMarket(ptMarkets[i]);
            uint256 ptPrice = m.getPtPrice();
            uint256 mat = m.expiry();
            uint256 timeToMaturity = mat - block.timestamp;
            
            maturities[i] = timeToMaturity;
            apys[i] = _calculateApyFromPtPrice(ptPrice, timeToMaturity);
        }
    }
    
    function _ln(uint256 x) internal pure returns (uint256) {
        require(x > 0, "유효하지 않은 입력");
        
        uint256 result = 0;
        uint256 y = x;
        
        while (y >= 2e18) {
            y = y / 2;
            result += 0.693147e18; // ln(2)
        }
        
        // 테일러 급수: ln(1+z) = z - z^2/2 + z^3/3 - ...
        uint256 z = y - 1e18;
        uint256 zPow = z;
        int256 sign = 1;
        
        for (uint i = 1; i <= 10; i++) {
            uint256 term = (zPow * 1e18) / (i * 1e18);
            if (sign > 0) {
                result += term;
            } else {
                result -= term;
            }
            zPow = (zPow * z) / 1e18;
            sign = -sign;
        }
        
        return result;
    }
}
```

## Pendle V2 아키텍처 심층 분석

```solidity
// Pendle V2 핵심 아키텍처
// 파일: PendleRouterBase.sol

abstract contract PendleRouterBase is IPendleRouter {
    
    // 수익 토큰화: SY를 PT + YT로 분할
    function mintPYFromToken(
        TokenizeYieldInput calldata input
    ) external payable returns (uint256 netPyOut, uint256 netYtOut) {
        // 사용자로부터 토큰 가져오기
        _transferFrom(input.tokenIn, msg.sender, address(this), input.amountIn);
        
        // SY로 래핑
        uint256 netSyOut = _mintSY(input.SY, input.tokenIn, input.amountIn);
        
        // PT와 YT 발행
        (netPyOut, netYtOut) = _mintPY(input.SY, input.to, netSyOut);
    }
    
    // 정확한 SY를 PT로 스왑
    function swapExactSyForPt(
        address market,
        uint256 exactSyIn,
        uint256 minPtOut,
        ApproxParams calldata guessPtOut
    ) external returns (uint256 netPtOut, uint256 netSyFee) {
        // SY를 마켓으로 전송
        _transferFrom(IERC20(market.SY()), msg.sender, market, exactSyIn);
        
        // 마켓 AMM에서 스왑 실행
        (netPtOut, netSyFee) = IPendleMarket(market).swapSyForPt(
            msg.sender,
            exactSyIn,
            minPtOut,
            guessPtOut
        );
    }
    
    // 만기 후 PT + YT를 SY로 상환
    function redeemPyToToken(
        address receiver,
        address YT,
        uint256 netPyIn,
        address tokenOut,
        uint256 minTokenOut
    ) external returns (uint256 netTokenOut) {
        // PT와 YT 소각
        IPY(YT.PT()).burn(msg.sender, netPyIn);
        IYT(YT).burn(msg.sender, netPyIn);
        
        // SY 상환
        address SY = IYT(YT).SY();
        uint256 netSyOut = ISY(SY).redeem(address(this), netPyIn, tokenOut, 0);
        
        // SY를 원하는 출력 토큰으로 변환
        netTokenOut = _redeemSY(SY, tokenOut, netSyOut);
        require(netTokenOut >= minTokenOut, "출력 불충분");
        
        _transferOut(tokenOut, receiver, netTokenOut);
    }
    
    // 헬퍼: 차익을 위한 플래시 스왑
    function flashSwap(
        address market,
        bool ptToSy,
        uint256 amountIn,
        bytes calldata callbackData
    ) external {
        if (ptToSy) {
            // PT 플래시 대출, SY로 매도, 차익 실행, PT 상환
            uint256 ptToBorrow = amountIn;
            _flashLoanPT(market, ptToBorrow);
            
            // 콜백이 차익 전략 실행
            IFlashCallback(msg.sender).flashCallback(callbackData);
            
            // PT + 수수료 상환
            _repayPT(market, ptToBorrow + _calculateFlashFee(ptToBorrow));
        }
    }
}
```

```python
# 기관 수익 관리용 Python SDK
import asyncio
from dataclasses import dataclass
from decimal import Decimal
from pendle_sdk import PendleSDK, MarketSnapshot

@dataclass
class YieldStrategy:
    name: str
    market_address: str
    allocation_pct: Decimal
    expected_apy: Decimal
    risk_score: int  # 1-10

class InstitutionalYieldManager:
    
    def __init__(self, rpc_url: str, wallet_key: str):
        self.sdk = PendleSDK(rpc_url=rpc_url, private_key=wallet_key)
        self.strategies: list[YieldStrategy] = []
    
    async def analyze_yield_opportunities(self) -> list[dict]:
        """모든 Pendle 시장에서 최적의 위험 조정 수익 스캔"""
        markets = await self.sdk.get_all_markets()
        opportunities = []
        
        for market in markets:
            snapshot = await market.get_snapshot()
            
            # 위험 조정 수익 계산
            sharpe_ratio = self._calculate_sharpe(snapshot)
            
            opportunities.append({
                'market': market.address,
                'asset': market.underlying_symbol,
                'maturity': snapshot.expiry_date,
                'pt_apy': snapshot.pt_implied_apy,
                'underlying_apy': snapshot.underlying_apy,
                'liquidity_usd': snapshot.liquidity_usd,
                'sharpe_ratio': sharpe_ratio,
                'recommendation': self._generate_recommendation(snapshot)
            })
        
        return sorted(opportunities, key=lambda x: x['sharpe_ratio'], reverse=True)
    
    async def execute_yield_portfolio(self, total_capital: Decimal):
        """여러 PT 전략에 자본 배포"""
        opportunities = await self.analyze_yield_opportunities()
        
        # 양의 캐리가 있는 유동성 시장 필터링
        viable = [o for o in opportunities 
                  if o['liquidity_usd'] > 1_000_000 
                  and o['pt_apy'] > 0.03]
        
        # 상위 5개 기회에 자본 배포
        for opp in viable[:5]:
            allocation = total_capital * Decimal('0.2')
            
            print(f"${allocation}를 {opp['asset']} PT에 배포 "
                  f"({opp['maturity']}) @ {opp['pt_apy']:.2%} APY")
            
            await self._buy_pt(opp['market'], allocation)
        
        return await self.get_portfolio_summary()
    
    async def get_portfolio_summary(self) -> dict:
        """현재 포트폴리오 포지션 및 손익 가져오기"""
        positions = await self.sdk.get_positions()
        
        total_value = sum(p.current_value for p in positions)
        total_cost = sum(p.cost_basis for p in positions)
        unrealized_pnl = total_value - total_cost
        
        # 가중 평균 수익률 계산
        weighted_yield = sum(
            p.current_value * p.implied_apy / total_value 
            for p in positions
        )
        
        return {
            'total_value': total_value,
            'total_cost': total_cost,
            'unrealized_pnl': unrealized_pnl,
            'unrealized_pnl_pct': unrealized_pnl / total_cost,
            'weighted_avg_apy': weighted_yield,
            'positions': len(positions),
            'maturities': list(set(p.maturity for p in positions))
        }
    
    def _calculate_sharpe(self, snapshot: MarketSnapshot) -> Decimal:
        """수익 기회의 단순화된 샤프 비율 계산"""
        excess_yield = snapshot.pt_implied_apy - Decimal('0.02')  # 무위험 대비
        volatility = Decimal('0.05')  # 가정 5% 수익 변동성
        return excess_yield / volatility if volatility > 0 else Decimal(0)
    
    def _generate_recommendation(self, snapshot: MarketSnapshot) -> str:
        spread = snapshot.underlying_apy - snapshot.pt_implied_apy
        if spread > Decimal('0.02'):
            return "LONG_PT"
        elif spread < Decimal('-0.02'):
            return "LONG_YT"
        return "HOLD"
```

## FAQ: Pendle에 대해 자주 묻는 질문

**Q1: PT와 YT의 차이점은 무엇인가요?**

A: PT(원금 토큰)는 만기 시 기저 자산 1단위를 상환할 권리를 나타냅니다. 액면가 할인으로 거래되며(예: stETH의 경우 0.95) 만기에 다가감에 따라 1.0으로 수렴하여 고정 수익을 제공합니다. YT(수익 토큰)는 만기까지 기저 자산의 모든 수익 축적을 포착합니다. YT를 보유하면 모든 스테이킹 보상, 대출 이자 또는 프로토콜 수익을 받습니다. 만기 시 PT는 1:1로 기저 자산을 상환할 수 있고 YT는 모든 수익이 분배된 후 가치가 없어집니다.

**Q2: Pendle의 AMM은 Uniswap이나 Curve와 어떻게 다른가요?**

A: Pendle의 AMM은 PT와 YT 자산을 위해 특별히 설계된 전문화된 logit 곡선을 사용합니다. 일정한 곱 AMM(Uniswap)이나 스테이블스왑(Curve)과 달리 Pendle의 곡선은 PT의 시간 감쇠 특성을 고려합니다 — 만기에 다가감에 따라 PT 가격은 수학적으로 1.0으로 수렴하도록 보장됩니다. `rateScalar` 및 `rateAnchor` 파라미터가 곡선 경사도를 제어하고 암묵적 APY는 PT 가격과 만기까지 남은 시간에서 도출됩니다. 이 전문 설계는 가격 궤적이 더 예측 가능하기 때문에 LP의 비영구적 손실을 최소화합니다.

**Q3: PT나 YT가 만기에 도달하면 어떻게 되나요?**

A: 만기 시 PT는 기저 SY(Standardized Yield) 토큰에 대해 1:1로 상환될 수 있으며, 이는 기저 자산(예: stETH)으로 언랩할 수 있습니다. 예를 들어, 만기가 된 100 PT-stETH를 보유하고 있다면 정확히 100 SY-stETH를 상환할 수 있으며, 이는 100 stETH 가치에 해당합니다. YT는 만기 시 수익 축적을 중지하고 최종 누적 보상을 청구하기 위해 소각할 수 있습니다. 만기 후 PT와 YT 모두 더 이상 경제적 가치가 없으므로 거래자는 만기 전이나 만기 시 포지션을 종료해야 합니다.

**Q4: Pendle에서 유동성 공급은 어떻게 작동하며 위험은 무엇인가요?**

A: LP는 PT와 SY를 Pendle 마켓에 제공하고 풀 지분을 나타내는 LP 토큰을 받습니다. LP 수익은 다음에서 발생합니다: (1) PT/SY 거래의 스왑 수수료, (2) 포트폴리오의 PT 부분의 고정 수익 축적, (3) 잠재적 인센티브 보상. 기존 AMM과 달리 Pendle의 전문화된 곡선은 PT 가격 움직임이 만기 날짜에 의해 제한되기 때문에 비영구적 손실을 크게 줄입니다. 그러나 위험은 스마트 계약 위험, 기저 자산 디페그(예: stETH가 ETH 페그 상실), 수익률이 LP 포지션에 반대로 움직이는 경우 기회 비용을 포함합니다.

**Q5: Pendle을 수익 창출 포지션을 헤징하는 데 사용할 수 있나요?**

A: 물론입니다. Pendle은 여러 헤징 전략을 가능하게 합니다: (1) **수익 잠금**: stETH에서 변동 수익을 얻고 있고 비율이 하락할 것으로 예상하면 YT를 매도하여 현재 수익 수준을 잠금하면서 원금은 유지합니다. (2) **고정금리 전환**: 토큰화하고 YT를 매도하여 변동 수익을 고정금리로 변환하고 PT만 보유합니다. (3) **수익 숏**: 수익이 과대평가되었다고 판단하면 YT를 매도합니다 — 실제 수익이 암묵적 비율보다 낮으면 수익을 얻습니다. (4) **델타 중립**: 기저 자산의 롱과 YT의 숏을 결합하여 가격 노출과 별도로 수익 성분을 격리하고 거래합니다.

**Q6: Pendle은 어떤 기저 자산을 지원하나요?**

A: 2026년 5월 기준으로 Pendle은 Ethereum, Arbitrum, Optimism 및 BNB Chain에서 30개 이상의 수익 자산을 지원합니다. 주요 자산으로는 Lido stETH, Rocket Pool rETH, Coinbase cbETH, frxETH, aUSDC/aDAI(Aave), cUSDC(Compound), sDAI(Spark), gmBTC/gmETH(GMX), GLP, sUSDe(Ethena), Yearn, Beefy 및 기타 수익 집계자의 다양한 볼트 토큰이 포함됩니다. 새로운 자산은 거버넌스 제안을 통해 정기적으로 추가됩니다.

**Q7: PT 구매 시 정확한 수익률을 어떻게 계산하나요?**

A: PT 수익률은 다음과 같이 계산됩니다: `고정 수익률% = (1 - PT_가격) / PT_가격`. 연간 APY: `APY = (1 / PT_가격)^(365 / 만기일수) - 1`. 예를 들어, 180일 만기에 0.95로 거래되는 PT: 수익률 = (1 - 0.95) / 0.95 = 5.26%; APY = (1/0.95)^(365/180) - 1 ≈ 10.8%. 만기까지 보유하면 이러한 수익은 보장되므로 PT는 전통 금융에서 기능적으로 영채와 동일합니다.

---



## 추천 호스팅 및 인프라

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영을 지원합니다.*

## 시작하기: Pendle 통합 체크리스트

```bash
# 1. Pendle SDK 설치
npm install @pendle/sdk-v2 ethers

# 2. 환경 설정
export PRIVATE_KEY=your_private_key
export RPC_URL=https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY

# 3. 예제 전략 저장소 클론
git clone https://github.com/pendle-finance/pendle-sdk-core-v2-public.git
cd pendle-sdk-core-v2-public
npm install

# 4. 예제 스크립트 실행
npx ts-node examples/market-scan.ts     # 모든 시장 스캔
npx ts-node examples/buy-pt.ts         # PT 구매 실행
npx ts-node examples/provide-lp.ts     # 유동성 추가
npx ts-node examples/claim-yield.ts    # YT 수익 청구

# 5. 테스트 실행
npm test
```

```typescript
// 퀵 스타트: 완전한 수익 토큰화 워크플로우
import { PendleSDK, Market } from '@pendle/sdk-v2';

async function quickstart() {
  const sdk = new PendleSDK({
    chainId: 1,
    provider: new ethers.JsonRpcProvider(process.env.RPC_URL),
    signer: new ethers.Wallet(process.env.PRIVATE_KEY),
  });
  
  // 1. 마켓 찾기
  const market = await sdk.getMarket(
    '0x1234...', // PT-stETH 마켓 주소
  );
  
  // 2. 토큰화: stETH를 PT + YT로 분할
  const { ptOut, ytOut } = await market.tokenizeYield(
    ethers.parseEther('10'), // 10 stETH
    0 // 최소 출력
  );
  console.log(`${ptOut} PT + ${ytOut} YT 수령`);
  
  // 3. 거래: 고정 수익 잠금을 위해 PT 스왑
  await market.swapExactPtForSy(
    ptOut / 2n, // PT 절반 매도
    0
  );
  
  // 4. 모니터링: 수익 축적 추적
  setInterval(async () => {
    const accrued = await market.getAccruedYield(ytOut);
    console.log(`축적된 수익: ${accrued}`);
  }, 60000);
}

quickstart().catch(console.error);
```

---

*면책 조항: 본 가이드는 교육 목적만을 위한 것입니다. 수익 토큰화에는 스마트 계약 위험, 시장 위험 및 기저 자산 디페그 위험이 포함됩니다. 자본을 배포하기 전에 항상 자체 연구를 수행하십시오. 표시된 수익률은 추정치이며 보장되지 않습니다. DYOR — Do Your Own Research(자체 연구 수행).*

**Pendle에서 수익 거래를 시작할 준비가 되셨나요?**
- 수익 자산을 획득하려면 [Binance](https://www.bsmkweb.cc/register?ref=DIBI8)에 등록하세요
- 고급 DeFi 거래를 위해 [OKX](https://www.promoohubly.com/join/12190433) 계정을 개설하세요
- 최신 Pendle 정보를 위해 Telegram을 팔로우하세요: **@dibi8crypto**

---

*© 2026 dibi8.com | DeFi 개발자, 트레이더, 연구원을 위해 제작되었습니다.*
