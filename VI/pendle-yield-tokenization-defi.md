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
- /vi/posts/pendle-yield-tokenization-defi/
---

{{</* resource-info */>}}

> **Tuyên bố tiếp thị liên kết**: Bài viết này chứa các liên kết tiếp thị đến [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) và [OKX](https://www.promoohubly.com/join/12190433). Chúng tôi có thể nhận được hoa hồng khi bạn đăng ký qua các liên kết này — không phát sinh chi phí thêm cho bạn.

---

## Pendle là gì và tại sao nó thay đổi DeFi?

Pendle là giao thức token hóa lợi nhuận hàng đầu trong tài chính phi tập trung, cho phép ngườii dùng tách các tài sản sinh lợi thành hai thành phần riêng biệt: **Token Gốc (PT)** và **Token Lợi nhuận (YT)**. Đổi mới mang tính đột phá này, ra mắt trên Ethereum và hiện đang hoạt động trên nhiều chuỗi, đã xác định lại cách ngườii tham gia DeFi tương tác với lợi nhuận. Tính đến tháng 5 năm 2026, Pendle đã vượt quá **5 tỷ USD Tổng Giá trị Khóa (TVL)** và hỗ trợ **hơn 30 tài sản sinh lợi**, trở thành một trong các giao thức thu nhập cố định tinh vi nhất trong hệ sinh thái tiền mã hóa.

Hiểu biết cốt lõi đằng sau Pendle là lợi nhuận và gốc có hồ sơ rủi ro và lợi nhuận về cơ bản khác nhau. Bằng cách tách chúng, Pendle tạo ra hai thị trường riêng biệt: thị trường lãi suất cố định cho PT (giao dịch chiết khấu và có thể chuộc 1:1 khi đáo hạn) và thị trường lợi nhuận đầu cơ cho YT (nắm bắt tất cả lợi nhuận tương lai từ tài sản cơ sở). Sự tách biệt này mở khóa các chiến lược mạnh mẽ cho phòng ngừa rủi ro, đầu cơ, đòn bẩy lợi nhuận và cho vay lãi suất cố định mà trước đây không thể thực hiện trong DeFi.

## Cơ chế Token hóa Lợi nhuận: Cách Pendle hoạt động

Tại cốt lõi của Pendle là tiêu chuẩn token SY (Standardized Yield), bao bọc bất kỳ token sinh lợi nào thành một giao diện thống nhất. Khi bạn gửi tài sản như stETH vào Pendle, giao thức đúc SY-stETH, sau đó tách thành PT-stETH và YT-stETH.

```solidity
// Luồng Token hóa Lợi nhuận Pendle
// Tệp: PendleRouter.sol (đơn giản hóa)

interface IPendleRouter {
    struct TokenizeYieldInput {
        address SY;
        address underlying;
        uint256 amountIn;
        address to;
    }
    
    /// @notice Token hóa tài sản sinh lợi thành PT và YT
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
        // Bước 1: Chuyển tài sản cơ sở từ ngườii dùng
        IERC20(input.underlying).transferFrom(
            msg.sender, 
            address(this), 
            input.amountIn
        );
        
        // Bước 2: Gửi vào bao bọc SY
        address SY = input.SY;
        uint256 syAmount = ISY(SY).deposit(
            address(this),
            input.underlying,
            input.amountIn,
            0 // minShares
        );
        
        // Bước 3: Đúc PT và YT từ SY
        address PT = SYToPT[SY];
        address YT = SYToYT[SY];
        
        // Cả PT và YT được đúc với số lượng bằng nhau
        amountPYOut = syAmount;
        amountYTOut = syAmount;
        
        IPT(PT).mint(input.to, amountPYOut);
        IYT(YT).mint(input.to, amountYTOut);
        
        emit Tokenized(input.underlying, input.amountIn, amountPYOut);
    }
}
```

```solidity
// Triển khai Token Sinh lợi Chuẩn hóa (SY) cho Lido stETH
// Tệp: SYStETH.sol

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
    
    /// @notice Gửi stETH và nhận token SY
    function deposit(
        address receiver,
        address tokenIn,
        uint256 amountTokenToDeposit,
        uint256 minSharesOut
    ) external returns (uint256 amountSharesOut) {
        require(tokenIn == address(stETH) || tokenIn == address(wstETH), "Token không hợp lệ");
        
        if (tokenIn == address(stETH)) {
            // Bọc stETH thành wstETH (xử lý rebasing)
            IERC20(stETH).safeTransferFrom(msg.sender, address(this), amountTokenToDeposit);
            uint256 wstETHAmount = wstETH.wrap(amountTokenToDeposit);
            amountSharesOut = wstETHAmount;
        } else {
            IERC20(wstETH).safeTransferFrom(msg.sender, address(this), amountTokenToDeposit);
            amountSharesOut = amountTokenToDeposit;
        }
        
        require(amountSharesOut >= minSharesOut, "Đầu ra không đủ");
        _mint(receiver, amountSharesOut);
    }
    
    /// @notice Xem trước tỷ giá hiện tại
    function exchangeRate() public view override returns (uint256) {
        // Trả về tỷ giá wstETH:stETH bao gồm phần thưởng staking tích lũy
        return wstETH.stEthPerToken();
    }
    
    /// @notice Nhận lợi nhuận từ tài sản cơ sở và phân phối cho ngườii giữ YT
    function claimRewards(address user) external returns (uint256[] memory rewardAmounts) {
        // Tính lợi nhuận tích lũy kể từ lần nhận cuối
        uint256 yieldAccrued = _calculateYieldAccrual(user);
        
        // Chuyển lợi nhuận cho ngườii giữ YT
        if (yieldAccrued > 0) {
            IERC20(stETH).safeTransfer(user, yieldAccrued);
        }
        
        rewardAmounts = new uint256[](1);
        rewardAmounts[0] = yieldAccrued;
    }
}
```

```solidity
// Hợp đồng Token Gốc (PT)
// Tệp: PTStETH.sol

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
    
    /// @notice Chuộc PT 1:1 lấy tài sản cơ sở khi/tại đáo hạn
    function redeem(
        address receiver,
        uint256 amountPTToRedeem
    ) external returns (uint256 amountSyOut) {
        require(block.timestamp >= maturity, "Chưa đáo hạn");
        
        // Đốt token PT
        _burn(msg.sender, amountPTToRedeem);
        
        // Chuộc SY lấy tài sản cơ sở
        amountSyOut = ISY(SY).redeem(
            receiver,
            amountPTToRedeem,
            address(ISY(SY).yieldToken()),
            0
        );
    }
    
    /// @notice Tính APY ngầm định từ giá PT
    function getImpliedApy() external view returns (uint256 impliedApy) {
        uint256 ptPrice = _getMarketPrice();
        uint256 timeToMaturity = maturity - block.timestamp;
        
        // APY ngầm định = (1/PT_Price)^(1/số_năm) - 1
        // PT ở 0.95 với đáo hạn 1 năm = ~5.26% lợi nhuận cố định
        impliedApy = _calculateImpliedFromPrice(ptPrice, timeToMaturity);
    }
}
```

```solidity
// Hợp đồng Token Lợi nhuận (YT)
// Tệp: YTStETH.sol

contract YTStETH is YTBase {
    
    address public immutable SY;
    address public immutable PT;
    uint256 public immutable maturity;
    
    // Theo dõi chỉ số lợi nhuận tích lũy của ngườii dùng
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
    
    /// @notice Nhận lợi nhuận tích lũy cho ngườii gọi
    function claimYield(address user) external returns (uint256 yieldOut) {
        _updateUserYield(user);
        
        yieldOut = accruedRewards[user];
        if (yieldOut > 0) {
            accruedRewards[user] = 0;
            // Chuyển từ phần thưởng tích lũy của SY
            ISY(SY).claimRewards(user);
        }
    }
    
    /// @notice Cập nhật lợi nhuận tích lũy của ngườii dùng dựa trên chỉ số toàn cục
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
    
    /// @notice YT có thể chuộc lấy lợi nhuận còn lại sau đáo hạn
    function redeemAfterMaturity(address user) external {
        require(block.timestamp > maturity, "Chưa sau đáo hạn");
        
        uint256 ytBalance = balanceOf(user);
        require(ytBalance > 0, "Không có số dư YT");
        
        _updateUserYield(user);
        
        // Đốt YT
        _burn(user, ytBalance);
        
        // Nhận bất kỳ phần thưởng còn lại
        uint256 remainingRewards = accruedRewards[user];
        if (remainingRewards > 0) {
            accruedRewards[user] = 0;
            ISY(SY).transferReward(user, remainingRewards);
        }
    }
}
```

## AMM Pendle: Giao dịch Lợi nhuận như Chuyên gia

AMM độc quyền của Pendle được thiết kế đặc biệt để giao dịch PT và YT, sử dụng đường cong chuyên dụng tính đến khấu hao thờii gian khi tài sản đến gần đáo hạn.

```solidity
// AMM Thị trường Pendle
// Tệp: PendleMarket.sol

contract PendleMarket is IPendleMarket {
    
    address public immutable PT;
    address public immutable SY;
    uint256 public immutable expiry;
    
    // Trạng thái AMM
    uint256 public totalPt;
    uint256 public totalSy;
    uint256 public totalLp;
    
    // Tham số đường cong cho giao dịch lợi nhuận
    int256 public immutable rateScalar;
    int256 public immutable rateAnchor;
    int256 public immutable feeRate;
    
    struct SwapInput {
        address tokenIn;
        uint256 amountIn;
        address tokenOut;
        uint256 minAmountOut;
    }
    
    /// @notice Hoán đổi giữa PT và SY sử dụng đường cong AMM chuyên dụng
    function swapExactPtForSy(
        SwapInput calldata input
    ) external returns (uint256 amountSyOut) {
        // Tính giá dựa trên thờii gian đến đáo hạn
        uint256 timeToMaturity = expiry - block.timestamp;
        
        // Đường cong chuyên dụng của Pendle: khi đến gần đáo hạn,
        // giá PT hội tụ về 1.0 (giá mệnh giá)
        uint256 ptRate = _getPtExchangeRate(timeToMaturity);
        
        // Áp dụng công thức AMM
        amountSyOut = _ammSwap(
            input.amountIn,
            totalPt,
            totalSy,
            ptRate,
            true // chiều ptToSy
        );
        
        require(amountSyOut >= input.minAmountOut, "Trượt giá quá cao");
        
        // Cập nhật dự trữ
        totalPt += input.amountIn;
        totalSy -= amountSyOut;
        
        emit Swap(msg.sender, input.tokenIn, input.tokenOut, input.amountIn, amountSyOut);
    }
    
    /// @notice Tính tỷ giá PT sử dụng đường cong logit
    function _getPtExchangeRate(
        uint256 timeToMaturity
    ) internal view returns (uint256 ptRate) {
        int256 lnImpliedRate = _getLnImpliedRate(timeToMaturity);
        int256 rateScalarInt = rateScalar;
        
        // ptRate = exp(-lnImpliedRate / rateScalar) / (1 + exp(-lnImpliedRate / rateScalar))
        ptRate = _logitCurve(lnImpliedRate, rateScalarInt, rateAnchor);
    }
    
    /// @notice Toán học hoán đổi AMM cốt lõi
    function _ammSwap(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut,
        uint256 exchangeRate,
        bool ptToSy
    ) internal pure returns (uint256 amountOut) {
        // Pendle sử dụng đường cong động điều chỉnh dựa trên thờii gian đến đáo hạn
        // Gần đáo hạn: đường cong tiến đến tổng không đổi (x + y = k)
        // Xa đáo hạn: đường cong tiến đến tích không đổi (x * y = k)
        
        uint256 proportion = (amountIn * 1e18) / reserveIn;
        uint256 curveFactor = _calculateCurveFactor(exchangeRate);
        
        if (ptToSy) {
            amountOut = (reserveOut * proportion * curveFactor) / 1e36;
        } else {
            amountOut = (reserveOut * proportion) / (curveFactor * 1e18 / 1e18);
        }
        
        // Áp dụng phí hoán đổi
        uint256 fee = (amountOut * uint256(feeRate)) / 1e18;
        amountOut -= fee;
    }
}
```

```typescript
// SDK TypeScript cho giao dịch Pendle
import { PendleSDK } from '@pendle/sdk-v2';
import { ethers } from 'ethers';

const provider = new ethers.JsonRpcProvider('https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY');
const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

const pendle = new PendleSDK({
  chainId: 1,
  provider,
  signer,
});

// Hoán đổi PT lấy SY cơ sở
async function swapPtForSy(
  marketAddress: string,
  ptAmount: bigint,
  minSyOut: bigint
) {
  const market = pendle.getMarket(marketAddress);
  
  // Phê duyệt chi tiêu PT
  await market.PT.approve(marketAddress, ptAmount);
  
  // Thực hiện hoán đổi với bảo vệ trượt giá
  const tx = await market.swapExactPtForSy(
    ptAmount,
    minSyOut,
    {
      deadline: Math.floor(Date.now() / 1000) + 300, // 5 phút
      recipient: await signer.getAddress(),
    }
  );
  
  const receipt = await tx.wait();
  console.log(`Đã hoán đổi ${ptAmount} PT lấy SY. TX: ${receipt.hash}`);
  
  return receipt;
}

// Cung cấp thanh khoản cho thị trường PT/SY
async function addLiquidity(
  marketAddress: string,
  syAmount: bigint,
  ptAmount: bigint
) {
  const market = pendle.getMarket(marketAddress);
  
  // Cung cấp thanh khoản hai chiều
  const tx = await market.addLiquidityDual(
    syAmount,
    ptAmount,
    0, // minLpOut (đặt với dung sai trượt giá phù hợp)
    {
      deadline: Math.floor(Date.now() / 1000) + 300,
    }
  );
  
  const receipt = await tx.wait();
  
  // Phân tích token LP nhận được
  const lpTokens = parseLPTokensFromReceipt(receipt);
  console.log(`Đã thêm thanh khoản. Nhận ${lpTokens} token LP`);
  
  return lpTokens;
}

// Tính APY ngầm định từ dữ liệu thị trường
async function getMarketImpliedApy(marketAddress: string) {
  const market = pendle.getMarket(marketAddress);
  
  const marketData = await market.getMarketData();
  const ptPrice = marketData.ptPrice;
  const timeToMaturity = marketData.expiry - Math.floor(Date.now() / 1000);
  
  // Công thức APY ngầm định
  const yearsToMaturity = timeToMaturity / (365.25 * 24 * 3600);
  const impliedApy = (1 / ptPrice) ** (1 / yearsToMaturity) - 1;
  
  console.log(`Giá PT: ${ptPrice}`);
  console.log(`Thờii gian đến đáo hạn: ${yearsToMaturity.toFixed(2)} năm`);
  console.log(`APY ngầm định: ${(impliedApy * 100).toFixed(2)}%`);
  
  return impliedApy;
}
```

## Các chiến lược PT và YT: Thu nhập Cố định, Đầu cơ Lợi nhuận, v.v.

Pendle mở khóa nhiều chiến lược tinh vi phục vụ các khẩu vị rủi ro và quan điểm thị trường khác nhau.

### Chiến lược Thu nhập Cố định (Mua PT)

```solidity
// Chiến lược: Mua PT chiết khấu để có lợi nhuận cố định
// Ví dụ: Mua PT-stETH ở 0.95, chuộc 1.0 khi đáo hạn trong 1 năm
// Lợi nhuận cố định = (1 - 0.95) / 0.95 = 5.26%

contract FixedIncomeStrategy {
    
    IPendleRouter public immutable router;
    address public immutable ptMarket;
    address public immutable pt;
    
    struct FixedIncomePosition {
        uint256 ptPurchased;
        uint256 costBasis;
        uint256 maturityDate;
        uint256 lockedYield; // lợi nhuận cố định được tính trước
    }
    
    mapping(address => FixedIncomePosition) public positions;
    
    /// @notice Mua PT để khóa lợi nhuận cố định
    function buyFixedIncome(
        address market,
        uint256 amountIn,
        uint256 minPtOut,
        uint256 deadline
    ) external returns (uint256 ptReceived) {
        // Tính giá PT và APY cố định ngầm định
        uint256 ptPrice = _getPtPrice(market);
        uint256 timeToMaturity = _getTimeToMaturity(market);
        
        // Tính lợi nhuận cố định
        uint256 fixedYield = ((1e18 - ptPrice) * 1e18) / ptPrice;
        uint256 annualizedYield = (fixedYield * (365 days)) / timeToMaturity;
        
        // Thực hiện mua PT
        ptReceived = router.swapExactSyForPt(
            market,
            amountIn,
            minPtOut,
            router.createDefaultLimitOrder(deadline)
        );
        
        // Ghi nhận vị thế
        positions[msg.sender] = FixedIncomePosition({
            ptPurchased: ptReceived,
            costBasis: amountIn,
            maturityDate: block.timestamp + timeToMaturity,
            lockedYield: fixedYield
        });
        
        emit FixedIncomePurchased(msg.sender, ptReceived, annualizedYield);
    }
    
    /// @notice Chuộc PT khi đáo hạn để nhận gốc đảm bảo + lợi nhuận
    function redeemAtMaturity() external {
        FixedIncomePosition storage pos = positions[msg.sender];
        require(block.timestamp >= pos.maturityDate, "Chưa đáo hạn");
        
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

### Chiến lược Lợi nhuận Đòn bẩy (Mua YT)

```solidity
// Chiến lược: Mua YT để có đòn bẩy đối với lợi nhuận staking
// Nếu lợi nhuận staking ETH trung bình 4% nhưng bạn kỳ vọng 6%, mua YT để lợi nhuận

contract LeveragedYieldStrategy {
    
    IPendleRouter public immutable router;
    address public immutable yt;
    address public immutable sy;
    
    struct YieldPosition {
        uint256 ytPurchased;
        uint256 costPerYt; // giá đã trả cho YT
        uint256 entryImpliedYield;
    }
    
    mapping(address => YieldPosition) public positions;
    
    /// @notice Mua YT để có đòn bẩy đối với lợi nhuận
    function longYield(
        address market,
        uint256 amountIn,
        uint256 minYtOut
    ) external returns (uint256 ytReceived) {
        // Giá YT phản ánh kỳ vọng lợi nhuận tương lai của thị trường
        uint256 ytPrice = _getYtPrice(market);
        uint256 impliedYield = _getImpliedApy(market);
        
        // Mua YT: mỗi YT đại diện cho quyền nhận 1 đơn vị lợi nhuận từ tài sản cơ sở
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
    
    /// @notice Nhận lợi nhuận tích lũy từ vị thế YT
    function claimAccumulatedYield() external returns (uint256 totalYield) {
        YieldPosition storage pos = positions[msg.sender];
        require(pos.ytPurchased > 0, "Không có vị thế");
        
        // Nhận từ hợp đồng YT
        totalYield = IYT(yt).claimYield(msg.sender);
        
        emit YieldClaimed(msg.sender, totalYield);
    }
    
    /// @notice Đóng vị thế và tính lãi lỗ
    function closeYieldLong() external returns (int256 pnl) {
        YieldPosition storage pos = positions[msg.sender];
        
        // Nhận bất kỳ lợi nhuận đang chờ
        uint256 pendingYield = IYT(yt).claimYield(msg.sender);
        
        // Bán YT lại cho thị trường
        uint256 syReceived = router.swapExactYtForSy(
            address(yt),
            pos.ytPurchased,
            0
        );
        
        // Lãi lỗ = giá trị nhận được - chi phí ban đầu
        uint256 totalReceived = syReceived + pendingYield;
        pnl = int256(totalReceived) - int256((pos.ytPurchased * pos.costPerYt) / 1e18);
        
        delete positions[msg.sender];
        emit YieldLongClosed(msg.sender, totalReceived, pnl);
    }
}
```

### Chiến lược Cung cấp Thanh khoản

```typescript
// Chiến lược LP: Kiếm phí từ giao dịch PT/SY + lợi nhuận cố định trên phần PT
async function provideLiquidityStrategy(
  marketAddress: string,
  totalCapital: bigint
) {
  const market = pendle.getMarket(marketAddress);
  
  // Chia vốn: 50% SY, 50% PT cho LP cân bằng
  const syForLp = totalCapital / 2n;
  const ptForLp = totalCapital / 2n;
  
  // Mua PT (bằng cách chia SY hoặc hoán đổi)
  // Tùy chọn 1: Đúc PT+YT từ SY, giữ YT, dùng PT cho LP
  const { ptOut, ytOut } = await pendle.mintPyFromSy(
    market.SY,
    ptForLp + syForLp // đúc từ tổng, sẽ chia
  );
  
  // Thêm thanh khoản với PT + SY
  const lpTokens = await market.addLiquidityDual(
    syForLp,
    ptOut / 2n,
    0
  );
  
  // Giữ YT còn lại để có đòn bẩy lợi nhuận
  console.log(`Vị thế LP: ${lpTokens} token LP`);
  console.log(`Vị thế YT: ${ytOut} token YT (đòn bẩy lợi nhuận)`);
  
  // Thiết lập tự động tái đầu tư
  const autoCompounder = new PendleAutoCompounder({
    market: marketAddress,
    harvestInterval: 86400, // hàng ngày
    minHarvestAmount: ethers.parseEther('0.01'),
  });
  
  await autoCompounder.start();
  
  return { lpTokens, ytOut, autoCompounder };
}
```

## Xây dựng trên Pendle: Hướng dẫn Tích hợp dành cho Nhà phát triển

### Đọc Dữ liệu Thị trường Pendle

```typescript
// Tải dữ liệu thị trường toàn diện từ Pendle
import { PendleMarketReader } from '@pendle/sdk-v2/market';

async function analyzePendleMarkets() {
  const reader = new PendleMarketReader({
    chainId: 1,
    provider,
  });
  
  // Lấy tất cả các thị trường đang hoạt động
  const markets = await reader.getActiveMarkets();
  
  for (const market of markets) {
    const data = await reader.getMarketSnapshot(market.address);
    
    console.log(`\n=== ${market.underlyingSymbol} (${data.expiryDate}) ===`);
    console.log(`Giá PT: ${data.ptPrice.toFixed(4)}`);
    console.log(`Giá YT: ${data.ytPrice.toFixed(4)}`);
    console.log(`APY Ngầm định: ${(data.impliedApy * 100).toFixed(2)}%`);
    console.log(`APY Cơ sở: ${(data.underlyingApy * 100).toFixed(2)}%`);
    console.log(`Thanh khoản: $${(data.liquidityUSD / 1e6).toFixed(2)}M`);
    console.log(`Khối lượng 24h: $${(data.volume24h / 1e6).toFixed(2)}M`);
    
    // Phân tích chênh lệch lợi nhuận
    const yieldSpread = data.underlyingApy - data.impliedApy;
    console.log(`Chênh lệch Lợi nhuận: ${(yieldSpread * 100).toFixed(2)}%`);
    
    if (yieldSpread > 0.01) {
      console.log(`⚠️  ĐỊNH GIÁ THẤP: Thị trường trả ít hơn lợi nhuận cơ sở`);
    } else if (yieldSpread < -0.01) {
      console.log(`🟢 ĐỊNH GIÁ CAO: Thị trường trả nhiều hơn lợi nhuận cơ sở`);
    }
  }
}
```

### Tích hợp Pendle Router

```solidity
// Tích hợp Pendle vào giao thức DeFi của bạn
contract MyDeFiProtocol {
    
    IPendleRouter public immutable pendleRouter;
    
    /// @notice Sử dụng PT làm tài sản thế chấp với giá trị đáo hạn có thể dự đoán
    function depositPtCollateral(
        address pt,
        uint256 amount
    ) external returns (uint256 collateralValue) {
        // PT khi đáo hạn = 1 tài sản cơ sở, nên giá trị = amount * 1.0
        // Trước đáo hạn, áp dụng hệ số chiết khấu
        uint256 timeToMaturity = IPT(pt).maturity() - block.timestamp;
        uint256 discountFactor = _calculateDiscountFactor(timeToMaturity);
        
        collateralValue = (amount * discountFactor) / 1e18;
        
        // Chuyển PT từ ngườii dùng
        IERC20(pt).transferFrom(msg.sender, address(this), amount);
        
        _recordCollateral(msg.sender, pt, amount, collateralValue);
    }
    
    /// @notice Zap vào vị thế sinh lợi qua Pendle
    function zapIntoYield(
        address underlying,
        uint256 amount,
        uint256 minYtOut
    ) external returns (uint256 ytReceived) {
        // Lấy bao bọc SY cho tài sản cơ sở này
        address sy = pendleRouter.getSY(underlying);
        
        // Phê duyệt và gửi
        IERC20(underlying).approve(address(pendleRouter), amount);
        
        // Đúc SY, sau đó chia thành YT (giữ PT trong hợp đồng để phòng ngừa rủi ro)
        (uint256 ptOut, ytReceived) = pendleRouter.mintPyFromToken(
            IPendleRouter.TokenizeYieldInput({
                SY: sy,
                underlying: underlying,
                amountIn: amount,
                to: address(this)
            })
        );
        
        // Gửi YT cho ngườii dùng, giữ PT làm dự trữ
        IYT(pendleRouter.YT(sy)).transfer(msg.sender, ytReceived);
        
        emit ZappedIntoYield(msg.sender, underlying, amount, ytReceived);
    }
    
    function _calculateDiscountFactor(
        uint256 timeToMaturity
    ) internal pure returns (uint256) {
        // Chiết khấu tuyến tính: tại đáo hạn = 1.0, tại 1 năm = 0.95
        if (timeToMaturity == 0) return 1e18;
        
        uint256 maxDiscount = 0.05e18; // 5% chiết khấu tối đa
        uint256 discount = (maxDiscount * timeToMaturity) / (365 days);
        
        return 1e18 - discount;
    }
}
```

```typescript
// Trợ giúp SDK: Tính điểm vào/ra tối ưu
class PendleStrategyAnalyzer {
  
  constructor(private sdk: PendleSDK) {}
  
  async findOptimalEntries(minLiquidityUSD: number = 1_000_000) {
    const markets = await this.sdk.getMarkets();
    const opportunities = [];
    
    for (const market of markets) {
      if (market.liquidityUSD < minLiquidityUSD) continue;
      
      const snapshot = await market.getSnapshot();
      const underlyingApy = await this.getUnderlyingApy(market.underlying);
      
      // Cơ hội Long PT (lợi nhuận cố định)
      if (snapshot.impliedApy > underlyingApy * 1.2) {
        opportunities.push({
          market: market.address,
          strategy: 'LONG_PT',
          reason: 'Lợi nhuận ngầm định cao hơn cơ sở 20%+',
          expectedReturn: snapshot.impliedApy,
          risk: 'thấp',
        });
      }
      
      // Cơ hội Long YT (đầu cơ lợi nhuận)
      if (snapshot.impliedApy < underlyingApy * 0.8) {
        opportunities.push({
          market: market.address,
          strategy: 'LONG_YT',
          reason: 'Lợi nhuận ngầm định thấp hơn cơ sở 20%+',
          expectedReturn: underlyingApy - snapshot.impliedApy,
          risk: 'trung bình',
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
    const redemptionValue = ptAmount; // PT chuộc 1:1 khi đáo hạn
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

## Oracle Lợi nhuận và Khám phá Giá

Giá PT của Pendle đóng vai trò như một oracle phi tập trung cho tỷ lệ lợi nhuận tương lai — một nguyên thủ quan trọng cho các thị trường thu nhập cố định DeFi.

```solidity
// Sử dụng Pendle làm oracle lợi nhuận
contract PendleYieldOracle {
    
    IPendleMarket public immutable market;
    address public immutable PT;
    uint256 public immutable maturity;
    
    /// @notice Lấy APY ngầm định hiện tại từ định giá PT
    function getImpliedApy() external view returns (uint256 impliedApy) {
        uint256 ptPrice = _getPtPrice();
        uint256 timeToMaturity = maturity - block.timestamp;
        
        // APY = (1/PT_Price)^(365/timeToMaturityDays) - 1
        uint256 yearsToMaturity = (timeToMaturity * 1e18) / (365 days);
        
        // Sử dụng xấp xỉ: ln(1/PT) / số năm
        uint256 lnRatio = _ln((1e18 * 1e18) / ptPrice);
        impliedApy = (lnRatio * 1e18) / yearsToMaturity;
    }
    
    /// @notice Lấy cấu trúc kỳ hạn lợi nhuận (nhiều đáo hạn)
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
        require(x > 0, "Đầu vào không hợp lệ");
        
        uint256 result = 0;
        uint256 y = x;
        
        while (y >= 2e18) {
            y = y / 2;
            result += 0.693147e18; // ln(2)
        }
        
        // Chuỗi Taylor: ln(1+z) = z - z^2/2 + z^3/3 - ...
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

## FAQ: Các câu hỏi thường gặp về Pendle

**Q1: PT và YT khác nhau như thế nào?**

A: PT (Token Gốc) đại diện cho quyền chuộc 1 đơn vị tài sản cơ sở khi đáo hạn. Nó giao dịch chiết khấu so với mệnh giá (ví dụ: 0.95 cho stETH) và hội tụ về 1.0 khi đáo hạn gần, cung cấp lợi nhuận cố định. YT (Token Lợi nhuận) nắm bắt tất cả lợi nhuận tích lũy từ tài sản cơ sở cho đến đáo hạn. Nếu bạn nắm giữ YT, bạn nhận được tất cả phần thưởng staking, lãi vay hoặc lợi nhuận giao thức do tài sản cơ sở tạo ra. Khi đáo hạn, PT có thể được chuộc 1:1 lấy tài sản cơ sở, trong khi YT hết giá trị sau khi tất cả lợi nhuận được phân phối.

**Q2: AMM của Pendle khác Uniswap hoặc Curve như thế nào?**

A: AMM của Pendle sử dụng đường cong logit chuyên dụng được thiết kế riêng cho tài sản PT và YT. Không giống như AMM tích không đổi (Uniswap) hoặc stableswap (Curve), đường cong của Pendle tính đến bản chất suy giảm theo thờii gian của PT — khi đáo hạn gần, giá PT được đảm bảo toán học sẽ hội tụ về 1.0. Các tham số `rateScalar` và `rateAnchor` điều khiển độ dốc đường cong, trong khi APY ngầm định được suy ra từ giá PT và thờii gian đến đáo hạn. Thiết kế chuyên biệt này giảm thiểu tổn thất vĩnh viễn cho LP vì quỹ đạo giá dễ dự đoán hơn.

**Q3: Điều gì xảy ra khi PT hoặc YT đạt đáo hạn?**

A: Tại đáo hạn, PT có thể được chuộc 1:1 lấy token SY (Standardized Yield), sau đó có thể được mở bọc thành tài sản cơ sở (ví dụ: stETH). Ví dụ: nếu bạn nắm giữ 100 PT-stETH đã đáo hạn, bạn có thể chuộc chính xác 100 SY-stETH, tương đương 100 stETH giá trị. YT ngừng tích lũy lợi nhuận tại đáo hạn và có thể được đốt để nhận bất kỳ phần thưởng tích lũy cuối cùng. Sau đáo hạn, cả PT và YT đều không còn giá trị kinh tế, vì vậy ngườii giao dịch phải thoát vị thế trước hoặc tại đáo hạn.

**Q4: Cung cấp thanh khoản trên Pendle hoạt động như thế nào và rủi ro là gì?**

A: LP cung cấp cả PT và SY cho các thị trường Pendle và nhận token LP đại diện cho phần chia sẻ của họ trong nhóm. Thu nhập LP đến từ: (1) phí hoán đổi từ giao dịch PT/SY, (2) tích lũy lợi nhuận cố định trên phần PT của danh mục, và (3) phần thưởng khuyến khích tiềm năng. Không giống như AMM truyền thống, đường cong chuyên dụng của Pendlengăn chặn đáng kể tổn thất vĩnh viễn vì chuyển động giá PT bị giới hạn bởi ngày đáo hạn của nó. Tuy nhiên, rủi ro bao gồm: rủi ro hợp đồng thông minh, depeg tài sản cơ sở (ví dụ: stETH mất neo ETH), và chi phí cơ hội nếu lợi nhuận di chuyển chống lại vị thế LP.

**Q5: Tôi có thể sử dụng Pendle để phòng ngừa rủi ro các vị thế sinh lợi của mình không?**

A: Chắc chắn rồi. Pendle cho phép nhiều chiến lược phòng ngừa rủi ro: (1) **Khóa lợi nhuận**: Nếu bạn đang kiếm lợi nhuận biến động trên stETH và mong đợi tỷ lệ giảm, hãy bán YT để khóa mức lợi nhuận hiện tại trong khi giữ gốc. (2) **Chuyển đổi lãi suất cố định**: Chuyển đổi lợi nhuận biến động thành cố định bằng cách token hóa và bán YT, chỉ giữ PT. (3) **Short lợi nhuận**: Nếu bạn tin rằng lợi nhuận được định giá quá cao, hãy bán YT — nếu lợi nhuận thực tế thấp hơn tỷ lệ ngầm định, bạn sẽ lãi. (4) **Delta trung lập**: Kết hợp long tài sản cơ sở với short YT để cô lập và giao dịch thành phần lợi nhuận riêng biệt khỏi rủi ro giá.

**Q6: Pendle hỗ trợ những tài sản cơ sở nào?**

A: Tính đến tháng 5 năm 2026, Pendle hỗ trợ hơn 30 tài sản sinh lợi trên Ethereum, Arbitrum, Optimism và BNB Chain. Các tài sản chính bao gồm: Lido stETH, Rocket Pool rETH, Coinbase cbETH, frxETH, aUSDC/aDAI (Aave), cUSDC (Compound), sDAI (Spark), gmBTC/gmETH (GMX), GLP, sUSDe (Ethena), và nhiều token vault từ Yearn, Beefy và các bộ tổng hợp lợi nhuận khác. Tài sản mới được thêm thường xuyên thông qua các đề xuất quản trị.

**Q7: Tôi tính chính xác lợi nhuận khi mua PT như thế nào?**

A: Lợi nhuận PT được tính như sau: `Lợi nhuận Cố định % = (1 - PT_Price) / PT_Price`. Đối với APY hàng năm: `APY = (1 / PT_Price)^(365 / days_to_maturity) - 1`. Ví dụ: PT giao dịch ở 0.95 với đáo hạn 180 ngày: lợi nhuận = (1 - 0.95) / 0.95 = 5.26%; APY = (1/0.95)^(365/180) - 1 ≈ 10.8%. Những lợi nhuận này được đảm bảo nếu bạn nắm giữ đến đáo hạn, khiến PT về chức năng tương đương trái phiếu chiết khấu trong tài chính truyền thống.

---



## Hosting Và Hạ Tầng Được Đề Xuất

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit $200 trong 60 ngày.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Bắt đầu: Danh sách kiểm tra Tích hợp Pendle của bạn

```bash
# 1. Cài đặt SDK Pendle
npm install @pendle/sdk-v2 ethers

# 2. Thiết lập môi trường
export PRIVATE_KEY=your_private_key
export RPC_URL=https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY

# 3. Sao chép kho ví dụ chiến lược
git clone https://github.com/pendle-finance/pendle-sdk-core-v2-public.git
cd pendle-sdk-core-v2-public
npm install

# 4. Chạy script ví dụ
npx ts-node examples/market-scan.ts     # Quét tất cả thị trường
npx ts-node examples/buy-pt.ts         # Thực hiện mua PT
npx ts-node examples/provide-lp.ts     # Thêm thanh khoản
npx ts-node examples/claim-yield.ts    # Nhận lợi nhuận YT

# 5. Chạy kiểm tra
npm test
```

```typescript
// Khởi động nhanh: Quy trình token hóa lợi nhuận hoàn chỉnh
import { PendleSDK, Market } from '@pendle/sdk-v2';

async function quickstart() {
  const sdk = new PendleSDK({
    chainId: 1,
    provider: new ethers.JsonRpcProvider(process.env.RPC_URL),
    signer: new ethers.Wallet(process.env.PRIVATE_KEY),
  });
  
  // 1. Tìm một thị trường
  const market = await sdk.getMarket(
    '0x1234...', // Địa chỉ thị trường PT-stETH
  );
  
  // 2. Token hóa: Chia stETH thành PT + YT
  const { ptOut, ytOut } = await market.tokenizeYield(
    ethers.parseEther('10'), // 10 stETH
    0 // đầu ra tối thiểu
  );
  console.log(`Nhận ${ptOut} PT + ${ytOut} YT`);
  
  // 3. Giao dịch: Hoán đổi PT để khóa lợi nhuận cố định
  await market.swapExactPtForSy(
    ptOut / 2n, // Bán một nửa PT
    0
  );
  
  // 4. Theo dõi: Theo dõi tích lũy lợi nhuận
  setInterval(async () => {
    const accrued = await market.getAccruedYield(ytOut);
    console.log(`Lợi nhuận tích lũy: ${accrued}`);
  }, 60000);
}

quickstart().catch(console.error);
```

---

*Tuyên bố từ chối trách nhiệm: Hướng dẫn này chỉ nhằm mục đích giáo dục. Token hóa lợi nhuận bao gồm rủi ro hợp đồng thông minh, rủi ro thị trường, và rủi ro depeg tài sản cơ sở. Luôn tiến hành nghiên cứu của riêng bạn trước khi triển khai vốn. Các tỷ lệ lợi nhuận được hiển thị là ước tính và không được đảm bảo. DYOR — Tự nghiên cứu của bạn.*

**Sẵn sàng bắt đầu giao dịch lợi nhuận trên Pendle?**
- Đăng ký trên [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) để mua tài sản sinh lợi
- Mở tài khoản [OKX](https://www.promoohubly.com/join/12190433) để giao dịch DeFi nâng cao
- Theo dõi chúng tôi trên Telegram để cập nhật tin tức Pendle mới nhất: **@dibi8crypto**

---

*© 2026 dibi8.com | Được xây dựng cho nhà phát triển DeFi, trader, và nhà nghiên cứu.*
