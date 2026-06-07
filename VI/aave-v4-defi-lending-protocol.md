# AAVE v4 2026: Giao Thức Cho Vay DeFi Quản Lý 15 Tỷ USD — Hướng Dẫn Tích Hợp Smart Contract

Cho vay phi tập trung đã trở thành cột mốc của DeFi hiện đại, và AAVE đang đứng đầu trong cuộc cách mạng này. Với tổng giá trị bị khóa vượt quá 15 tỷ đô la trên nhiều chuỗi, AAVE là giao thức cho vay lớn nhất và được thử nghiệm kỹ lưỡng nhất trong hệ sinh thái tiền điện tử. Việc ra mắt AAVE v4 vào cuối năm 2025 đã mang lại những cải tiến kiến trúc quan trọng, làm cho nó trở nên hiệu quả hơn, an toàn hơn và thuận tiện cho nhà phát triển hơn bao giờ hết.

Đối với các nhà phát triển xây dựng ứng dụng DeFi, bot giao dịch, thu thập lợi nhuận hoặc công cụ quản lý danh mục đầu tư, việc hiểu cách tích hợp với AAVE là rất quan trọng. Hướng dẫn này cung cấp một hướng dẫn toàn diện về AAVE v4, bao gồm mọi thứ từ các hoạt động cơ bản như cho vay và cung cấp vốn đến các tính năng nâng cao như cho vay nhanh, chế độ cách ly và đồng ổn định GHO. Dù bạn đang viết hợp đồng thông minh Solidity hay xây dựng giao diện người dùng phía trước, bạn sẽ tìm thấy các ví dụ mã thực tế và góc nhìn kiến trúc để tăng tốc quá trình tích hợp của mình.


---
---
## AAVE là Gì?

AAVE là một giao thức thanh khoản nguồn mở, không giữ tài sản giúp người dùng cung cấp và vay các tài sản tiền điện tử. Ban đầu được ra mắt dưới dạng ETHLend vào năm 2017 và tái định vị thương hiệu thành AAVE vào năm 2018, giao thức này đã phát triển qua nhiều phiên bản chính. Phiên bản AAVE v3 được ra mắt vào năm 2023 với khả năng cửa hàng chuỗi liên kết, và AAVE v4 xuất hiện vào cuối năm 2025 với kiến trúc linh hoạt, hiệu quả vốn cải thiện và hỗ trợ tinh thể lỏng tài khoản nội tại.

Giao thức này hoạt động thông qua một loạt hợp đồng thông minh được triển khai trên Ethereum, Polygon, Arbitrum, Optimism, Avalanche, Base và nhiều mạng lưới khác. Người dùng cung cấp tài sản nhận lại aTokens làm trả, mà lãi suất tăng theo thời gian. Người vay có thể lấy khoản vay quá bảo đảm trong chế độ lãi suất biến đổi hoặc ổn định, với sự linh hoạt để chuyển đổi giữa chúng.

AAVE v4 giới thiệu một số sáng tạo kiến trúc:

- **Kiến trúc bể linh hoạt** tách quản lý rủi ro khỏi logic cho vay chính
- **Giản lược hóa flash loan nội tại** với điểm nhập thống nhất
- **Chế độ cách ly nâng cao** để liệt kê tài sản dài đuôi với nguy cơ giới hạn
- **Tầng thanh khoản chuỗi liên kết** được xây dựng trên Chainlink CCIP
- **GHO thị trường tiền tệ nội tại** với việc phát hành trực tiếp đối lập bảo đảm
- **Kiểm tra hợp đồng thông minh tích hợp** cho giao dịch không tốn khí và phục hồi xã hội

---
---
## Hiểu cấu trúc AAVE v4

Trước khi đi vào code, cần hiểu các thành phần kiến trúc cơ bản của AAVE v4.

**Hợp đồng Pool.** Hợp đồng trung tâm quản lý tất cả các hoạt động cung cấp, vay và thanh lý. Trong phiên bản 4, pool chuyển giao quyết định liên quan đến rủi ro cho các module bên ngoài trong khi vẫn duy trì trạng thái cơ bản.

**aTokens.** Token có lãi suất đại diện cho lượng thanh khoản được cung cấp. Khi bạn cung cấp DAI, bạn nhận được aDAI. Số dư của aTokens tăng tự động theo thời gian cùng với lãi suất tích lũy.

**Token Nợ biến đổi.** Các token không chuyển nhượng theo dõi vị trí vay có lãi suất biến đổi. Chúng đại diện cho nợ phải trả của người vay và tăng lên khi lãi suất tích lũy.

**Token Nợ ổn định.** Tương tự như token nợ biến đổi nhưng với lãi suất ổn định được xác định tại thời điểm vay. AAVE v4 cải thiện cơ chế phí nợ ổn định để giảm sự biến động về lãi suất.

**Oracle Giá trị.** Các nguồn cung cấp giá từ Chainlink cung cấp đánh giá tài sản để xác định các yếu tố bảo đảm, ngưỡng thanh lý và khả năng vay.

**Module Rủi ro.** Một thành phần mới trong phiên bản 4, bao gồm các tham số rủi ro, cấu hình bảo đảm và logic chế độ cách ly. Sự tách biệt này cho phép quản trị viên cập nhật các thiết lập về rủi ro mà không cần sửa đổi hợp đồng pool cơ bản.

---
---
## Thiết lập Môi Trường Phát Triển

Để tích hợp với AAVE v4, bạn cần một môi trường phát triển được cấu hình đúng.

### Cài Đặt Dự Án Hardhat

```bash
mkdir aave-integration && cd aave-integration
npm init -y
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox
npx hardhat init
```

### Cài Đặt Các Trình Truy Cập AAVE

```bash
npm install @aave/core-v4 @aave/periphery-v4
npm install ethers dotenv
```

### Cấu Hình Môi Trường

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
---
## Hợp đồng Thông minh Trung tâm

Giao diện chính để tương tác với AAVE v4 là hợp đồng `IPool`. Tất cả các hoạt động cung cấp, vay và trả nợ đều đi qua hợp đồng này.

### Cung cấp Tài sản vào AAVE

Khi bạn cung cấp tài sản vào AAVE, bạn sẽ gửi các token ERC-20 vào bể và nhận lại aTokens. Các aTokens này tự động tích lũy lãi suất.

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
        // Chuyển tiền từ người dùng đến hợp đồng này
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        
        // Cho phép bể sử dụng token
        IERC20(asset).approve(address(pool), amount);
        
        // Cung cấp tài sản vào bể AAVE thay mặt cho msg.sender
        pool.supply(asset, amount, msg.sender, 0);
    }
}
```

### Vay Tài sản

Vay yêu cầu người dùng phải có đủ tài sản bảo đảm. Số tiền vay tối đa được xác định bởi yếu tố bảo đảm của các tài sản đã cung cấp.

```solidity
contract AaveBorrower {
    IPool public immutable pool;
    
    constructor(address _pool) {
        pool = IPool(_pool);
    }
    
    function borrowAsset(
        address asset,
        uint256 amount,
        uint256 interestRateMode // 1 = ổn định, 2 = biến đổi
    ) external {
        // Vay với lãi suất ổn định hoặc biến đổi
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

### Rút Trở Lại Tài sản đã Cung cấp

```solidity
function withdrawAsset(
    address asset,
    uint256 amount // sử dụng type(uint256).max để rút toàn bộ
) external {
    // Rút aTokens và nhận lại tài sản gốc
    pool.withdraw(asset, amount, msg.sender);
}
```

---
---
## Đọc Thông Tin Tài Khoản Người Dùng

AAVE cung cấp một hợp đồng cung cấp dữ liệu người dùng mà tích hợp thông tin cụ thể về người dùng bao gồm yếu tố sức khỏe, số dư vay có sẵn và phân giải bảo đảm.

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

### Kết Nối JavaScript với ethers.js

Đối với tích hợp phía trước-end và lập trình, ethers.js cung cấp một giao diện thuận tiện.

```javascript
const { ethers } = require('ethers');
require('dotenv').config();

// Hợp đồng bể AAVE v4 trên Ethereum mainnet
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
  console.log('Total Collateral (USD):', ethers.formatUnits(data.totalCollateralBase, 8));
  console.log('Total Debt (USD):', ethers.formatUnits(data.totalDebtBase, 8));
  console.log('Available Borrows (USD):', ethers.formatUnits(data.availableBorrowsBase, 8));
  console.log('Health Factor:', ethers.formatUnits(data.healthFactor, 18));
  return data;
}
```

---
---
## Làm việc với Vay Flash

Vay flash là khoản vay không thế chấp phải được vay và trả trong một giao dịch khối duy nhất. AAVE đã tiên phong về vay flash trong DeFi, và phiên bản v4 đơn giản hóa việc triển khai bằng cách sử dụng giao diện thống nhất.

### Hợp đồng Nhận Vay Flash

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
        // Vay flash đã nhận - triển khai logic arbitrage ở đây
        uint256 amountOwed = amount + premium;
        
        // Ví dụ: arbitrage giữa các DEX
        // 1. Đổi asset vay trên DEX A
        // 2. Đổi asset nhận được trên DEX B
        // 3. Lợi nhuận = finalAmount - amountOwed
        
        // Phê duyệt thanh toán
        IERC20(asset).approve(address(pool), amountOwed);
        
        return true;
    }
}
```

### Vay Flash Nhiều Asset

Đối với các chiến lược nâng cao yêu cầu nhiều asset, sử dụng giao diện vay flash đầy đủ.

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
---
## Mode Tách Bạch và Quản Lý Rủi Ro

AAVE v4 đã cải thiện chế độ tách bạch, cho phép vay đối với các tài sản bảo đảm cụ thể với giới hạn rủi ro được giới hạn. Điều này rất quan trọng để tích hợp an toàn các tài sản dài hạn.

### Cung cấp trong Chế Độ Tách Bạch

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
        // Kiểm tra xem tài sản có thể được sử dụng trong chế độ tách bạch hay không
        (,,,,,, bool isolationModeEnabled) = 
            IPoolDataProvider(address(0)).getReserveConfigurationData(asset);
        
        require(isolationModeEnabled, 'Tài sản chưa được kích hoạt cho chế độ tách bạch');
        
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        IERC20(asset).approve(address(pool), amount);
        
        // Cung cấp với cờ chế độ tách bạch
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

### Kiểm Tra Giới Hạn Chế Độ Tách Bạch

```javascript
async function checkIsolationModeConstraints(userAddress, asset) {
  const reserveData = await pool.getReserveData(asset);
  const userConfig = await pool.getUserConfiguration(userAddress);
  
  console.log('Tổng Nợ trong Chế Độ Tách Bạch:', 
    reserveData.isolationModeTotalDebt.toString());
  console.log('Chế Độ Tách Bạch Được Kích Hoạt:', 
    (reserveData.configuration.data & (1 << 60)) !== 0);
  
  // Kiểm tra tài sản bảo đảm của người dùng trong chế độ tách bạch
  const userReserveConfig = await dataProvider.getUserReserveData(asset, userAddress);
  console.log('Tài Sản Bảo Đảm Của Người Dùng:', 
    ethers.formatUnits(userReserveConfig.currentATokenBalance, 18));
}
```

---
---
## Liên Kết GHO Stablecoin

GHO là stablecoin bản địa của AAVE, được phát hành dựa trên tài sản bảo đảm thông qua giao thức AAVE. Trong v4, việc liên kết GHO là nguyên thủy trong cấu trúc bể.

### Phát Hành GHO Dựa Trên Tài Sản Bảo Đảm

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
        // Yêu cầu có đủ tài sản bảo đảm trong bể AAVE
        pool.borrow(
            address(gho),   // Địa chỉ GHO
            amount,
            2,              // Tỷ lệ lãi suất biến đổi
            0,              // Mã giới thiệu
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
        // Người sở hữu stkAAVE nhận ưu đãi trên lãi suất GHO
        return gho.getDiscountPercent(user);
    }
}
```

### Mô Hình Facilitator GHO

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
        // IMPLEMENTATION CHO PHÂN CHIA PHÍ VÀO QUỸ
    }
}
```

---
---
## Cổng Liên Kênh và Hoạt Động của Bộ Kết Nối

AAVE v4 sử dụng Chainlink CCIP để chuyển đổi thanh khoản giữa các chuỗi, cho phép người dùng di chuyển vị trí của họ giữa các mạng một cách mượt mà.

### Di Chuyển aTokens qua Các Chuỗi

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
        // Trích xuất aToken từ vị trí của người dùng
        uint256 withdrawn = sourcePool.withdraw(
            getUnderlying(aToken),
            amount,
            address(this)
        );
        
        // Phê chuẩn và chuyển đổi qua CCIP
        IERC20(getUnderlying(aToken)).approve(ccipRouter, withdrawn);
        
        // Logic chuyển đổi qua chuỗi đích
        // Trên chuỗi đích, cung cấp vào bể AAVE cho người nhận
    }
    
    function getUnderlying(address aToken) 
        internal 
        pure 
        returns (address) 
    {
        // Trả lại tài sản gốc tương ứng với aToken
        return address(0); // Chi tiết triển khai
    }
}
```

---
---
## Thí Hành Bot Phá Hủy

Phá hủy là một cơ chế quan trọng để duy trì tính toàn vẹn của giao thức. Xây dựng một bot phá hủy có thể mang lại lợi nhuận đồng thời góp phần cải thiện sức khỏe của giao thức.

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
        // Phê chuẩn tài sản nợ cho việc thanh toán
        IERC20(debtAsset).transferFrom(msg.sender, address(this), debtToCover);
        IERC20(debtAsset).approve(address(pool), debtToCover);
        
        // Thực hiện phá hủy
        pool.liquidationCall(
            collateralAsset,
            debtAsset,
            user,
            debtToCover,
            receiveAToken
        );
        
        // Trả lại tài sản bảo đảm đã phá hủy cho người gọi
        if (receiveAToken) {
            // Trả lại aTokens
        } else {
            // Tài sản gốc đã được gửi đến hợp đồng này
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

### Thí Hành.Scanner JavaScript Phá Hủy

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
        console.log(`Phá hủy có thể: ${user} HF: ${healthFactor}`);
      }
    } catch (error) {
      console.error(`Lỗi kiểm tra ${user}:`, error.message);
    }
  }
  
  return liquidatableUsers;
}
```

---
---
## Liên Kết Frontend với React

Blockchain interactions trong các giao diện người dùng DeFi hiện đại thường sử dụng wagmi và viem.

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
  }
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
      {isLoading ? 'Supplying...' : 'Supply to AAVE'}
    </button>
  );
}
```

---
---
## Câu Hỏi Thường Gặp

### Tỷ Suất Đảm Bảo Miễn Phí Borrrow trên AAVE v4 là bao nhiêu?

Tỷ suất đảm bảo tối thiểu phụ thuộc vào tài sản cụ thể. Các tài sản chính như ETH và WBTC thường có tỷ lệ cho vay đối với giá trị tài sản (LTV) là 80%, nghĩa là bạn có thể vay đến 80% của giá trị tài sản đảm bảo. Tuy nhiên, mỗi tài sản đều có các tham số rủi ro được thiết lập bởi AAVE governance. Chỉ số sức khỏe phải duy trì trên 1.0 để tránh bị bán đấu giá, và chỉ số sức khỏe dưới 1.0 làm cho vị trí của bạn đủ điều kiện bị bán đấu giá bởi keeper.

### Flash Loans hoạt động như thế nào trên AAVE v4?

Flash loans cho phép bạn vay bất kỳ lượng tài sản nào có sẵn mà không cần tài sản đảm bảo, miễn là tổng số tiền vay cộng với phí được trả lại trong cùng một khối giao dịch. Phí thường là 0.09% trên AAVE v4. Nếu khoản vay không được thanh toán trước khi kết thúc giao dịch, toàn bộ giao dịch sẽ bị hủy bỏ. Flash loans thường được sử dụng cho việc kiếm chênh lệch giá, hoán đổi tài sản đảm bảo, tự bán đấu giá và tái cơ cấu vị trí nợ.

### Sự khác biệt giữa lãi suất ổn định và lãi suất biến động là gì?

Lãi suất biến động thay đổi dựa trên dinh dưỡng cung cầu trong bể AAVE. Chúng sử dụng mô hình thuật toán nơi lãi suất tăng khi mức sử dụng tiếp cận 100%. Lãi suất ổn định cung cấp chi phí vay đáng tin cậy với một khoản phí cao hơn nhưng có thể được cân bằng lại dưới các điều kiện thị trường cực đoan. Trên AAVE v4, cơ chế lãi suất ổn định đã được cải thiện để giảm tần suất các sự kiện cân bằng.

### Cách Isolation Mode bảo vệ giao thức?

Isolation Mode trên AAVE v4 cho phép một số tài sản dài hạn nhất định được sử dụng như tài sản đảm bảo với các giới hạn nghiêm ngặt. Khi người dùng cung cấp tài sản trong chế độ Isolation Mode, họ chỉ có thể vay các tài sản đã được phê duyệt cụ thể và tổng sức mạnh vay của họ bị giới hạn bởi một trần nợ. Điều này ngăn chặn một tài sản biến động duy nhất đe dọa khả năng thanh toán của toàn bộ giao thức. Chế độ Isolation Mode đặc biệt quan trọng đối với các mã thông báo mới niêm yết có tính lỏng lẻo hạn chế.

### GHO là gì và khác biệt so với các stablecoin khác?

GHO là stablecoin bản địa của AAVE, được cố định theo đô la Mỹ. Không giống như các stablecoin tập trung dựa trên dự trữ tiền mặt fiat, GHO được phát hành bằng thuật toán chống lại vị trí đảm bảo quá mức trong giao thức AAVE. Người sở hữu stkAAVE nhận ưu đãi về lãi suất vay GHO. GHO được thiết kế để hoàn toàn phân quyền, không thể kiểm duyệt và tích hợp sâu với thị trường cho vay của AAVE.

### Có thể tích hợp AAVE v4 trên các mạng Layer 2 không?

Có, AAVE v4 được triển khai trên nhiều mạng Layer 2 bao gồm Arbitrum, Optimism, Base và Polygon. Các mẫu tích hợp gần như giống nhau giữa các chuỗi, nhưng bạn nên sử dụng địa chỉ hợp đồng phù hợp và điểm kết nối RPC cho mỗi mạng. Triển khai Layer 2 thường cung cấp chi phí gas thấp hơn đáng kể trong khi vẫn duy trì cùng một bảo mật thông qua cấu trúc rollup.

---
---
## Kết luận

AAVE v4 là kết quả của nhiều năm đổi mới DeFi, tích hợp cơ chế cho vay mạnh mẽ cùng với các cải tiến kiến trúc hiện đại. Thiết kế linh hoạt, quản lý rủi ro được nâng cao thông qua chế độ tách biệt, tích hợp native GHO stablecoin và khả năng liên chuỗi làm cho nó trở thành lựa chọn hàng đầu cho các nhà phát triển xây dựng ứng dụng tài chính trên Ethereum và hơn thế.

Dokumentation phong phú của giao thức, smart contract đã được thử nghiệm kỹ lưỡng, cộng đồng nhà phát triển hoạt động mạnh mẽ cung cấp nền tảng vững chắc cho việc tích hợp. Dù bạn đang xây dựng một trình thu thập lợi nhuận đơn giản hay một giao thức DeFi phức tạp kết hợp với AAVE, các mẫu trong hướng dẫn này sẽ tăng tốc quá trình phát triển của bạn.

Bạn đã sẵn sàng bắt đầu xây dựng trên AAVE? Bạn sẽ cần ETH để trả phí gas và tài sản để cung cấp. [Dokumentation Moralis](https://docs.moralis.io) hoặc [đăng ký OKX](https://www.promoohubly.com/join/12190433) để tài trợ ví phát triển của bạn và thu thập các token cần thiết cho việc thử nghiệm và triển khai.