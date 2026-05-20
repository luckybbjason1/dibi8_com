---
title: '1inch-dex-aggregator-routing'
description: '{''en'': ''Master 1inch DEX aggregator in 2026. Learn how Pathfinder routes trades across 300+ liquidity sources, implement Fusion+ gasless swaps, limit orders, and portfolio tracking with the TypeScript SDK.'', ''zh'': ''掌握 2026 年 1inch DEX 聚合器。了解 Pathfinder 如何跨 300+ 流动性来源路由交易，使用 TypeScript SDK 实现 Fusion+ 无 Gas 兑换、限价单和 portfolio 追踪。'', ''ko'': ''2026년 1inch DEX 집계기를 마스터하세요. Pathfinder가 300개 이상의 유동성 소스에서 거래를 라우팅하는 방법, Fusion+ 가스 없는 스왑, 한도 주문 및 TypeScript SDK를 사용한 포트폴리오 추적을 구현하세요.'', ''vi'': ''Làm chủ trình tổng hợp DEX 1inch năm 2026. Tìm hiểu cách Pathfinder định tuyến giao dịch qua 300+ nguồn thanh khoản, triển khai hoán đổi không gas Fusion+, lệnh giới hạn và theo dõi danh mục với SDK TypeScript.''}'
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
github_repo: 'https://github.com/1inch/1inch-sdk'
stars: 400
maintainer: '1inch'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: ['1inch']
aliases:
- /vi/posts/1inch-dex-aggregator-routing/
---

{{</* resource-info */>}}

Tài chính phi tập trung đã phát triển vượt xa thởi kỳ thử nghiệm. Năm 2026, các trader không chỉ đòi hỏi quyền truy cập thanh khoản, mà còn cần định tuyến thông minh để tối đa hóa từng basis point của giao dịch. **1inch** đứng ở tuyến đầu của sự tiến hóa này, vận hành như một DEX aggregator tinh vi nhất trong hệ sinh thái. Với thuật toán **Pathfinder** độc quyền, 1inch định tuyến giao dịch xuyên suốt **hơn 300 nguồn thanh khoản** trải rộng trên 10+ mạng blockchain, đảm bảo giá thực thi tối ưu đồng thởi giảm thiểu trượt giá và chi phí gas.

Từ một công cụ tối ưu hoán đổi đơn giản, 1inch đã phát triển thành một bộ cơ sở hạ tầng DeFi toàn diện. Mạng 1inch hiện nay bao gồm **Fusion+** cho hoán đổi không gas, **lệnh giới hạn** nâng cao, **Portfolio API** mạnh mẽ, và **TypeScript SDK** hoàn toàn typed cho phép các nhà phát triển tích hợp khả năng giao dịch cấp tổ chức trực tiếp vào ứng dụng của họ. Dù bạn đang xây dựng giao diện giao dịch bán lẻ, vault tối ưu hoá lợi nhuận, hay bot arbitrage thuật toán, việc hiểu cơ chế định tuyến của 1inch là điều cần thiết để tối đa hoá hiệu quả giao dịch trong bối cảnh thanh khoản phân mảnh ngày nay.

Hướng dẫn này cung cấp phân tích chuyên sâu kỹ thuật về kiến trúc tổng hợp của 1inch, kèm ví dụ mã thực tế sử dụng SDK chính thức, mẫu tích hợp và chiến lược triển khai production.

## 1. Hiểu về DEX Aggregation và Vai trò của 1inch

Các DEX aggregator giải quyết một trong những thách thức dai dẳng nhất của DeFi: **phân mảnh thanh khoản**. Với hàng trăm sàn giao dịch phi tập trung hoạt động trên nhiều chuỗi — Uniswap, Curve, Balancer, PancakeSwap, SushiSwap và vô số sàn khác — thanh khoản tồn tại trong các silo. Một cặp token có thể có pool sâu trên một DEX và pool nông trên DEX khác. Không có tổng hợp, các trader phải đối mặt với giá không tối ưu, trượt giá quá mức và cơ hội bị bỏ lỡ.

1inch giải quyết vấn đề này bằng cách hoạt động như một **meta-layer** phía trên các DEX riêng lẻ. Thay vì thực thi hoán đổi trên một sàn duy nhất, thuật toán Pathfinder của 1inch kiểm tra đồng thở tất cả các nguồn thanh khoản có sẵn, xây dựng các tuyến đường multi-hop phức tạp có thể chia một giao dịch qua nhiều giao thức và thậm chí nhiều blockchain. Năm 2026, mạng lưới này trải rộng:

| Chuỗi | Các DEX chính | Thanh khoản xấp xỉ |
|-------|-------------------|----------------------|
| Ethereum | Uniswap v3, Curve, Balancer, SushiSwap | $2.8B+ |
| Arbitrum | Camelot, Uniswap v3, SushiSwap | $890M+ |
| Optimism | Velodrome, Uniswap v3, Curve | $420M+ |
| Polygon | QuickSwap, Uniswap v3, Curve | $310M+ |
| BSC | PancakeSwap, BiSwap, Uniswap v3 | $1.2B+ |
| Base | Aerodrome, Uniswap v3, AlienBase | $650M+ |

Kết quả là việc thực thi giá liên tục vượt trội hơn giao dịch DEX đơn lẻ **3-15%** trung bình, với cải thiện đặc biệt đáng kể cho các lệnh lớn và cặp token exotic.

## 2. Cách Thuật toán Định tuyến Pathfinder Hoạt động

Trái tim của khả năng tổng hợp 1inch là **Pathfinder** — một engine định tuyến độc quyền giải quyết bài toán tối ưu hoá real-time cho mỗi lần hoán đổi. Hiểu cơ chế của nó giúp các nhà phát triển đưa ra quyết định sáng suốt về tham số giao dịch.

### 2.1 Bài toán Tối ưu hoá

Khi bạn yêu cầu báo giá để hoán đổi Token A sang Token B, Pathfinder phải giải: *Với N nguồn thanh khoản có độ sâu, phí và giá khác nhau, chuỗi hop và split nào tối thiểu hoá tổng chi phí khớp lệnh?*

Đây là bài toán tính toán cường độ cao vì:
- Phải truy vấn **300+ nguồn** về dự trữ và phí hiện tại
- **Đường đi multi-hop** (A → C → D → B) thường cho giá tốt hơn cặp trực tiếp
- **Chia tách định tuyến** — chia một lệnh qua nhiều đường — giảm trượt giá
- Chi phí gas thay đổi theo độ phức tạp đường đi; nhiều hop hơn nghĩa là chi phí thực thi cao hơn
- **Cầu nối cross-chain** có thể cung cấp địa điểm thực thi thay thế

### 2.2 Các Phát Khám phá và Tập hợp

Pathfinder hoạt động trong hai pha riêng biệt:

**Pha 1 — Khám phá Tuyến đường**: Thuật toán khám phá tất cả các đường đi có thể giữa token nguồn và đích lên đến độ sâu có thể cấu hình (thường 4-6 hop). Nó sử dụng phương pháp Bellman-Ford được cải tiến để khám phá các chu kỳ âm trong không gian giá, hiệu quả tìm ra các đường liền kề arbitrage chỉ ra sự không hiệu quả về giá.

**Pha 2 — Tập hợp Tuyến đường**: Các đường đi được khám phá được chấm điểm bằng hàm đa mục tiêu cân bằng:
- Số lượng đầu ra dự kiến (mục tiêu chính)
- Ước tính chi phí gas (thứ cấp)
- Xác suất thành công dựa trên tỷ lệ fill lịch sử
- Yêu cầu bảo vệ MEV

```typescript
// Yêu cầu báo giá qua API 1inch — Pathfinder xử lý định tuyến bên trong
import { OneInchApi } from '@1inch/sdk';

const oneInch = new OneInchApi({
  apiKey: process.env.ONEINCH_API_KEY,
  networkId: 1, // Ethereum mainnet
});

// Lấy tuyến đường tối ưu để hoán đổi 1 ETH sang USDC
const quote = await oneInch.getQuote({
  src: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH
  dst: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // USDC
  amount: '1000000000000000000', // 1 ETH (wei)
  includeTokensInfo: true,
  includeProtocols: true,
  includeGas: true,
});

console.log('Đầu ra dự kiến:', quote.dstAmount);
console.log('Đường dẫn tuyến:', quote.protocols); // Hiển thị đường dẫn định tuyến đầy đủ
console.log('Gas ước tính:', quote.tx.gas);
```

Trường `protocols` tiết lộ tuyến đường thực tế mà Pathfinder đã chọn — ví dụ, chia 60% qua Uniswap v3 và 40% qua Curve, hoặc định tuyến qua token trung gian như WETH → DAI → USDC để có giá tốt hơn.

## 3. Thiết lập TypeScript SDK 1inch

SDK chính thức 1inch (`1inch/1inch-sdk` trên GitHub, 400+ stars, giấy phép MIT) cung cấp giao diện type-safe, promise-based cho tất cả API 1inch. Nó xử lý ký yêu cầu, xử lý lỗi và phân tích phản hồi.

### 3.1 Cài đặt và Cấu hình

```bash
# Cài đặt qua npm
npm install @1inch/sdk

# Hoặc với yarn
yarn add @1inch/sdk

# Cài đặt peer dependencies
npm install ethers axios dotenv
```

Tạo file `.env` cho thông tin xác thực API:

```bash
ONEINCH_API_KEY=your_api_key_here
PRIVATE_KEY=your_wallet_private_key
RPC_URL=https://mainnet.infura.io/v3/your_project_id
```

Khởi tạo SDK với cấu hình của bạn:

```typescript
import { OneInchSdk } from '@1inch/sdk';
import { ethers } from 'ethers';
import * as dotenv from 'dotenv';

dotenv.config();

// Khởi tạo provider và wallet
const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY!, provider);

// Khởi tạo SDK 1inch
const sdk = new OneInchSdk({
  apiKey: process.env.ONEINCH_API_KEY!,
  networkId: 1, // Ethereum mainnet
  walletAddress: wallet.address,
});

console.log('SDK 1inch đã khởi tạo cho', wallet.address);
```

### 3.2 Tổng quan Kiến trúc SDK

SDK được tổ chức thành các namespace phản ánh cấu trúc API của 1inch:

```typescript
// Cấu trúc module SDK
import {
  SwapApi,        // Hoán đổi token và báo giá
  LimitOrderApi,  // Tạo và quản lý lệnh giới hạn
  OrderbookApi,   // Thao tác orderbook
  GasPriceApi,    // Ước tính giá gas
  SpotPriceApi,   // Price feed token
  BalanceApi,     // Theo dõi portfolio và số dư
  HistoryApi,     // Lịch sử giao dịch
} from '@1inch/sdk';

// Mỗi namespace cung cấp các phương thức typed
const swapApi = sdk.swap;
const limitApi = sdk.limitOrder;
const balanceApi = sdk.balance;
```

## 4. Thực thi Hoán đổi với Định tuyến Tối ưu

Trường hợp sử dụng chính của 1inch là thực thi hoán đổi token với mức giá thực thi tốt nhất có thể. SDK trừu tượng hoá sự phức tạp của việc khám phá tuyến đường đồng thở cho phép các nhà phát triển kiểm soát chi tiết các tham số.

### 4.1 Thực thi Hoán đổi Cơ bản

```typescript
import { OneInchSdk } from '@1inch/sdk';

async function executeSwap() {
  const sdk = new OneInchSdk({
    apiKey: process.env.ONEINCH_API_KEY!,
    networkId: 1,
  });

  // Định nghĩa tham số hoán đổi
  const swapParams = {
    src: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH gốc
    dst: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // USDC
    amount: '500000000000000000', // 0.5 ETH
    from: wallet.address,
    slippage: 1, // Trượt giá tối đa 1%
    disableEstimate: false,
    allowPartialFill: false,
    includeTokensInfo: true,
    includeProtocols: true,
    compatibility: true,
  };

  // Bước 1: Nhận báo giá (mô phỏng)
  const quote = await sdk.swap.getQuote(swapParams);
  console.log('Báo giá đã nhận:');
  console.log('- Đầu vào:', quote.srcAmount);
  console.log('- Đầu ra dự kiến:', quote.dstAmount);
  console.log('- Tuyến giá:', quote.protocols);

  // Bước 2: Xây dựng giao dịch
  const tx = await sdk.swap.buildTx({
    ...swapParams,
    receiver: wallet.address, // Nơi USDC sẽ được gửi đến
  });

  // Bước 3: Ký và gửi giao dịch
  const sentTx = await wallet.sendTransaction({
    to: tx.to,
    data: tx.data,
    value: tx.value,
    gasLimit: tx.gas,
    maxFeePerGas: tx.maxFeePerGas,
    maxPriorityFeePerGas: tx.maxPriorityFeePerGas,
  });

  console.log('Giao dịch đã gửi:', sentTx.hash);
  const receipt = await sentTx.wait();
  console.log('Giao dịch đã xác nhận trong khối:', receipt?.blockNumber);
}

executeSwap().catch(console.error);
```

### 4.2 Xử lý Trượt giá và Fill Một phần

Dung sai trượt giá là quan trọng trong thị trường biến động. SDK cung cấp kiểm soát chi tiết:

```typescript
// Cài đặt bảo thủ cho giao dịch lớn
const largeTradeParams = {
  src: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE',
  dst: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0',
  amount: '50000000000000000000', // 50 ETH — lệnh lớn!
  from: wallet.address,
  slippage: 0.5, // Trượt giá chặt chẽ 0.5% để đảm bảo độ chính xác
  allowPartialFill: false, // Thực thi tất cả hoặc không gì
  // Bật bảo vệ MEV (khuyến nghị cho giao dịch lớn)
  referrer: 'your_app_name',
  fee: 0, // Không phí bổ sung
};

// Đối với các giao dịch nhỏ hơn, khẩn cấp hơn, bạn có thể nới lỏng trượt giá
const quickTradeParams = {
  ...largeTradeParams,
  amount: '1000000000000000000', // 1 ETH
  slippage: 3, // Chấp nhận trượt giá 3% để đổi lấy tốc độ
  allowPartialFill: true, // Chấp nhận thực thi một phần
  // Ưu tiên tốc độ hơn giá tối ưu
  protocols: 'UNISWAP_V3,SUSHI,CURVE', // Danh sách trắng các giao thức cụ thể
};
```

### 4.3 Hoán đổi Cross-Chain qua Bridge API

Khả năng tổng hợp của 1inch mở rộng vượt ra ngoài single chain. Bridge API tìm các tuyến đường tối ưu xuyên chuỗi:

```typescript
// Bridge từ Ethereum USDC sang Arbitrum ETH
const bridgeQuote = await sdk.crossChain.getQuote({
  srcChain: 1,        // Ethereum
  dstChain: 42161,    // Arbitrum
  srcToken: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // USDC trên Ethereum
  dstToken: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH trên Arbitrum
  amount: '1000000000', // 1000 USDC (6 số thập phân)
  walletAddress: wallet.address,
});

console.log('Tuyến bridge:', bridgeQuote.selectedRoute);
console.log('Thởi gian ước tính:', bridgeQuote.estimatedTime, 'giây');
console.log('Lượng đích:', bridgeQuote.dstTokenAmount);

// Thực thi giao dịch bridge
const bridgeTx = await sdk.crossChain.buildTx({
  ...bridgeQuote.params,
  walletAddress: wallet.address,
});

const sentBridgeTx = await wallet.sendTransaction({
  to: bridgeTx.to,
  data: bridgeTx.data,
  value: bridgeTx.value,
  gasLimit: bridgeTx.gasLimit,
});
```

## 5. Fusion+: Thực thi Hoán đổi Không Gas

Một trong những tính năng sáng tạo nhất của 1inch là **Fusion+** — một cơ chế hoán đổi không gas tận dụng cơ chế đấu giá Hà Lan và các nhà tạo lập thị trường chuyên nghiệp (resolver) để thực thi giao dịch mà ngườ dùng không phải trả gas trước.

### 5.1 Fusion+ Hoạt động Như thế nào

Các hoán đổi truyền thống yêu cầu ngườ dùng trả phí gas bằng token gốc (ETH trên Ethereum). Fusion+ loại bỏ rào cản này:

1. **Ngườ dùng ký ý định** hoán đổi ở mức giá chấp nhận tối thiểu
2. **Các resolver cạnh tranh** trong một cuộc đấu giá Hà Lan để khớp lệnh
3. **Resolver chiến thắng** thực thi giao dịch, trả gas thay mặt ngườ dùng
4. **Phí của resolver** được nhúng trong tỷ giá hoán đổi, vô hình với ngườ dùng

```typescript
// Thực thi hoán đổi Fusion+ không gas
import { FusionOrder } from '@1inch/sdk/fusion';

async function executeFusionSwap() {
  const fusionSdk = sdk.fusion;

  // Tạo lệnh Fusion+ (không cần gas cho ngườ dùng!)
  const fusionOrder = await fusionSdk.createOrder({
    srcToken: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH
    dstToken: '0xA0b86a33E6441e0A421e56E4773C3C0b8C6E51f0', // USDC
    amount: '1000000000000000000', // 1 ETH
    walletAddress: wallet.address,
    // Tham số Fusion+
    preset: 'fast', // 'fast', 'medium', hoặc 'slow'
    // Mức hoàn trả tối thiểu bạn chấp nhận (fusion tìm mức giá thực tế tốt nhất)
    minReturn: '1800000000', // Tối thiểu 1800 USDC
    // Thởi gian đấu giá — thởi gian resolver cạnh tranh
    auctionDuration: 180, // 180 giây
  });

  console.log('Lệnh Fusion đã tạo:', fusionOrder.orderHash);

  // Ký lệnh bằng ví của bạn (không cần gas!)
  const signature = await wallet.signTypedData(
    fusionOrder.domain,
    fusionOrder.types,
    fusionOrder.message
  );

  // Gửi lệnh đã ký đến relayer 1inch
  const submitted = await fusionSdk.submitOrder({
    order: fusionOrder,
    signature,
    from: wallet.address,
  });

  console.log('Lệnh Fusion đã gửi:', submitted.orderHash);
  console.log('Theo dõi tại: https://1inch.io/fusion-order/' + submitted.orderHash);

  // Poll trạng thái thực thi
  const checkStatus = async () => {
    const status = await fusionSdk.getOrderStatus(submitted.orderHash);
    console.log('Trạng thái lệnh:', status.status); // 'pending', 'filled', 'expired'
    if (status.status === 'filled') {
      console.log('Hash giao dịch:', status.txHash);
      console.log('Đầu ra thực tế:', status.dstTokenAmount);
      return true;
    }
    return false;
  };

  // Poll mỗi 10 giây
  const interval = setInterval(async () => {
    const done = await checkStatus();
    if (done) clearInterval(interval);
  }, 10000);
}
```

### 5.2 Giải thích Các Preset Fusion+

| Preset | Thởi gian đấu giá | Ưu tiên | Tốt nhất cho |
|--------|-----------------|----------|----------|
| `fast` | 60 giây | Cao | Hoán đổi nhạy cảm về thởi gian, phí resolver cao hơn |
| `medium` | 180 giây | Trung bình | Cân bằng tốc độ và chi phí |
| `slow` | 600 giây | Thấp | Tiết kiệm tối đa, thực thi kiên nhẫn |

```typescript
// Theo dõi vòng đờ lệnh Fusion
const orderEvents = fusionSdk.subscribeToOrderEvents(fusionOrder.orderHash);

orderEvents.on('created', (data) => {
  console.log('Lệnh đã phát sóng đến các resolver');
});

orderEvents.on('auctionStarted', (data) => {
  console.log('Đấu giá Hà Lan đang hoạt động, tỷ giá hiện tại:', data.currentRate);
});

orderEvents.on('filled', (data) => {
  console.log('Lệnh đã được resolver khớp:', data.resolver);
  console.log('Lượng đầu ra cuối cùng:', data.dstAmount);
  console.log('Bạn đã trả KHÔNG gas!');
});

orderEvents.on('expired', () => {
  console.log('Lệnh hết hạn không được khớp — thử lại với minReturn tốt hơn');
});
```

## 6. Lệnh Giới hạn và Giao dịch Lập trình

Ngoài các hoán đổi thị trường, 1inch cung cấp một **giao thức lệnh giới hạn** mạnh mẽ cho phép các trader chỉ định giá chính xác để thực thi — tương tự các sàn giao dịch tập trung nhưng hoàn toàn tự lưu ký.

### 6.1 Tạo Lệnh Giới hạn

```typescript
// Tạo lệnh giới hạn để mua DAI bằng ETH ở giá cụ thể
const limitOrder = await sdk.limitOrder.createOrder({
  makerAsset: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH (bạn bán)
  takerAsset: '0x6B175474E89094C44Da98b954EedeAC495271d0F', // DAI (bạn mua)
  makingAmount: '500000000000000000', // 0.5 ETH
  takingAmount: '900000000000000000000', // Kỳ vọng tối thiểu 900 DAI
  // Lệnh hết hạn sau 24 giờ
  expiration: Math.floor(Date.now() / 1000) + 86400,
  // Cho phép khớp một phần (hành vi tương tự DCA)
  partializable: true,
  // Địa chỉ nhận token đã mua
  receiver: wallet.address,
});

// Ký lệnh giới hạn
const limitSignature = await wallet.signTypedData(
  limitOrder.domain,
  limitOrder.types,
  limitOrder.message
);

// Gửi lên orderbook 1inch
const placedOrder = await sdk.limitOrder.submitOrder({
  order: limitOrder,
  signature: limitSignature,
});

console.log('Lệnh giới hạn đã đặt:', placedOrder.orderHash);
console.log('Giá khớp dự kiến:', 900 / 0.5, 'DAI mỗi ETH');
```

### 6.2 Lắng nghe Lệnh được Khớp

```typescript
// Thiết lập webhook hoặc listener poll cho lệnh được khớp
import { LimitOrderWatcher } from '@1inch/sdk/watcher';

const watcher = new LimitOrderWatcher({
  apiKey: process.env.ONEINCH_API_KEY!,
  networkId: 1,
  pollInterval: 5000, // Kiểm tra mỗi 5 giây
});

// Theo dõi lệnh cụ thể của bạn
watcher.watchOrder(placedOrder.orderHash, (event) => {
  if (event.type === 'filled') {
    console.log('Lệnh đã được khớp hoàn toàn!');
    console.log('Giao dịch:', event.txHash);
    console.log('Lượng đã khớp:', event.filledAmount);
  } else if (event.type === 'partiallyFilled') {
    console.log('Khớp một phần:', event.filledRatio, '%');
    console.log('Còn lại:', event.remainingAmount);
  } else if (event.type === 'expired') {
    console.log('Lệnh hết hạn — đặt lệnh mới nếu vẫn quan tâm');
  }
});

// Bắt đầu theo dõi
watcher.start();
```

## 7. Portfolio API và Theo dõi Số dư

**Portfolio API** cung cấp khả năng theo dõi toàn diện số dư token, lịch sử giao dịch và P&L trên tất cả các chuỗi được hỗ trợ — rất quan trọng cho việc xây dựng bảng điều khiển giao dịch và công cụ báo cáo thuế.

### 7.1 Lấy Số dư Multi-Chain

```typescript
// Lấy tất cả số dư token trên các chuỗi được hỗ trợ
const portfolio = await sdk.balance.getBalances({
  walletAddress: '0xYourWalletAddress',
  chainIds: [1, 42161, 137, 10, 8453], // Truy vấn multi-chain
  // Bao gồm metadata cho mỗi token
  includeMetadata: true,
  // Bao gồm giá trị USD ở giá hiện tại
  includeUsdValues: true,
});

// Xử lý và hiển thị số dư
for (const chainBalance of portfolio.balances) {
  console.log(`\n=== Chuỗi ID: ${chainBalance.chainId} ===`);
  for (const token of chainBalance.tokens) {
    console.log(`${token.symbol}: ${token.balance} ($${token.usdValue})`);
  }
}

// Tổng giá trị portfolio trên tất cả các chuỗi
const totalValue = portfolio.balances.reduce((sum, chain) => {
  return sum + chain.tokens.reduce((s, t) => s + parseFloat(t.usdValue || '0'), 0);
}, 0);

console.log(`\nTổng Giá trị Portfolio: $${totalValue.toFixed(2)}`);
```

### 7.2 Lịch sử Giao dịch và Phân tích P&L

```typescript
// Lấy lịch sử giao dịch đầy đủ
const history = await sdk.history.getTransactions({
  walletAddress: wallet.address,
  chainIds: [1, 42161], // Ethereum và Arbitrum
  limit: 100,
  offset: 0,
  // Lọc theo loại giao dịch
  types: ['swap', 'approval', 'limitOrder'],
});

// Phân tích hiệu suất hoán đổi
const swaps = history.transactions.filter(tx => tx.type === 'swap');

const swapAnalysis = swaps.map(swap => ({
  timestamp: swap.timestamp,
  inputToken: swap.srcToken.symbol,
  inputAmount: swap.srcAmount,
  outputToken: swap.dstToken.symbol,
  outputAmount: swap.dstAmount,
  effectivePrice: parseFloat(swap.dstAmount) / parseFloat(swap.srcAmount),
  gasCostUsd: swap.gasCostUsd,
  route: swap.protocols?.join(' → '),
}));

console.table(swapAnalysis);

// Tính khối lượng tích lũy
const totalVolume = swaps.reduce((sum, tx) => {
  return sum + parseFloat(tx.srcUsdValue || '0');
}, 0);
console.log(`Tổng khối lượng hoán đổi: $${totalVolume.toFixed(2)}`);
```

### 7.3 Xây dựng Bảng điều khiển Portfolio Real-time

```typescript
// Cập nhật portfolio real-time dựa trên WebSocket
import { PortfolioWebSocket } from '@1inch/sdk/websocket';

const ws = new PortfolioWebSocket({
  apiKey: process.env.ONEINCH_API_KEY!,
  walletAddress: wallet.address,
});

ws.on('balanceUpdate', (update) => {
  console.log(`Cập nhật số dư: ${update.tokenSymbol} = ${update.newBalance}`);
  console.log(`Thay đổi giá trị USD: $${update.usdValueChange}`);
  // Cập nhật UI bảng điều khiển của bạn tại đây
});

ws.on('newTransaction', (tx) => {
  console.log('Phát hiện giao dịch mới:', tx.hash);
  console.log('Loại:', tx.type);
  console.log('Giá trị:', tx.usdValue);
  // Kích hoạt cảnh báo real-time hoặc cập nhật UI
});

ws.connect();
```

## 8. Mẫu Tích hợp Production

Triển khai tích hợp 1inch trong production đòi hỏi sự chú ý đến bảo mật, độ tin cậy và hiệu suất.

### 8.1 Xử lý Lỗi và Logic Thử lại

```typescript
// Thực thi hoán đổi với thử lại
async function executeSwapWithRetry(
  params: SwapParams,
  maxRetries = 3
): Promise<TransactionReceipt> {
  let lastError: Error | null = null;

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      // Làm mới báo giá trước mỗi lần thử (giá thay đổi!)
      const freshQuote = await sdk.swap.getQuote(params);
      console.log(`Lần thử ${attempt}: Đầu ra dự kiến = ${freshQuote.dstAmount}`);

      // Kiểm tra xem giá có di chuyển quá nhiều không
      if (parseFloat(freshQuote.dstAmount) < params.minExpectedOutput!) {
        throw new Error('Giá di chuyển vượt quá ngưỡng chấp nhận được');
      }

      const tx = await sdk.swap.buildTx({ ...params });
      const sentTx = await wallet.sendTransaction({
        to: tx.to,
        data: tx.data,
        value: tx.value,
        gasLimit: Math.floor(parseInt(tx.gas) * 1.2), // Buffer gas 20%
        maxFeePerGas: tx.maxFeePerGas,
        maxPriorityFeePerGas: tx.maxPriorityFeePerGas,
      });

      const receipt = await sentTx.wait(2); // Chờ 2 xác nhận
      console.log('Hoán đổi đã xác nhận:', receipt?.hash);
      return receipt!;

    } catch (error) {
      lastError = error as Error;
      console.error(`Lần thử ${attempt} thất bại:`, error);

      // Chờ trước khi thử lại với exponential backoff
      if (attempt < maxRetries) {
        const delay = Math.pow(2, attempt) * 1000;
        await new Promise(r => setTimeout(r, delay));
      }
    }
  }

  throw new Error(`Hoán đổi thất bại sau ${maxRetries} lần thử: ${lastError?.message}`);
}
```

### 8.2 Giới hạn Tốc độ và Quản lý Khóa API

```typescript
// Client API giới hạn tốc độ cho sử dụng tần suất cao
import { RateLimiter } from 'limiter';

class OneInchRateLimitedClient {
  private limiter: RateLimiter;
  private sdk: OneInchSdk;

  constructor(apiKey: string, requestsPerSecond = 5) {
    this.sdk = new OneInchSdk({ apiKey, networkId: 1 });
    this.limiter = new RateLimiter({ tokensPerInterval: requestsPerSecond, interval: 'second' });
  }

  async getQuote(params: any) {
    await this.limiter.removeTokens(1);
    return this.sdk.swap.getQuote(params);
  }

  async buildTx(params: any) {
    await this.limiter.removeTokens(1);
    return this.sdk.swap.buildTx(params);
  }
}

// Sử dụng
const client = new OneInchRateLimitedClient(
  process.env.ONEINCH_API_KEY!,
  3 // Thận trọng: 3 yêu cầu mỗi giây
);
```

### 8.3 Các Thực hành Tốt nhất về Bảo mật

```typescript
// Xác thực đầu vào cho production swap
function validateSwapParams(params: SwapParams): void {
  // Xác thực địa chỉ token
  if (!ethers.isAddress(params.src) || !ethers.isAddress(params.dst)) {
    throw new Error('Định dạng địa chỉ token không hợp lệ');
  }

  // Xác thực số lượng là số dương
  if (BigInt(params.amount) <= 0n) {
    throw new Error('Số lượng phải là số dương');
  }

  // Kiểm tra slippage hợp lý (0.1% đến 50%)
  if (params.slippage < 0.1 || params.slippage > 50) {
    throw new Error('Slippage phải nằm trong khoảng 0.1% đến 50%');
  }

  // Ngăn lỗi phổ biến: hoán đổi token với chính nó
  if (params.src.toLowerCase() === params.dst.toLowerCase()) {
    throw new Error('Token nguồn và đích không thể giống nhau');
  }

  // Xác minh token không phải scam/honeypot đã biết (sử dụng danh sách bên ngoài)
  if (isTokenBlacklisted(params.dst)) {
    throw new Error('Token đích đã bị đưa vào danh sách đen');
  }
}

// Sử dụng ví phần cứng hoặc quản lý khóa an toàn
const wallet = new ethers.Wallet(
  await getKeyFromAWSKMS(), // Không bao giờ hardcode private key!
  provider
);
```

## 9. Câu hỏi Thường gặp

**Q1: 1inch kiếm tiền như thế nào nếu SDK miễn phí và mã nguồn mở?**

1inch tạo doanh thu thông qua **phí nguồn thanh khoản** và **phí quản trị giao thức** tùy chọn. Khi giao dịch được định tuyến qua một số DEX nhất định, 1inch có thể nhận một khoản phí giớ thiệu nhỏ. Đối với các nhà phát triển, SDK và API được sử dụng miễn phí, mặc dù ngườ dùng khối lượng cao có thể chọn mô hình **phí đối tác** để chia sẻ doanh thu với ứng dụng tích hợp. SDK được cấp phép MIT (`1inch/1inch-sdk`, 400+ stars trên GitHub) đảm bảo tính minh bạch hoàn toàn và tích hợp không cần phép.

**Q2: Sự khác biệt giữa hoán đổi thông thường và hoán đổi Fusion+ là gì?**

Các hoán đổi thông thường được **thực thi ngay lập tức trên chuỗi** — bạn trả gas, giao dịch được đào, và bạn nhận token. Điều này mang lại sự chắc chắn nhưng yêu cầu ETH để trả gas. Các **hoán đổi Fusion+** là **ý định không gas** — bạn ký các tham số hoán đổi bằng mã hoá, các resolver chuyên nghiệp cạnh tranh trong một cuộc đấu giá Hà Lan để khớp lệnh của bạn, và resolver chiến thắng trả gas. Fusion+ lý tưởng cho những ngườ dùng không có token gas gốc hoặc những ngườ tìm kiếm thực thi được bảo vệ MEV, mặc dù có thể mất 1-10 phút tùy thuộc vào preset được chọn.

**Q3: Tôi có thể sử dụng 1inch trên các chuỗi khác ngoài Ethereum không?**

Hoàn toàn có thể. 1inch hỗ trợ **hơn 10 mạng blockchain** bao gồm Ethereum, Arbitrum, Optimism, Polygon, BNB Chain, Base, Avalanche, Fantom, Gnosis và zkSync Era. Khởi tạo SDK chấp nhận tham số `networkId` tương ứng với EIP-155 chain ID của mỗi chuỗi. Các hoán đổi cross-chain cũng được hỗ trợ thông qua Bridge API, cho phép di chuyển tài sản liền mạch giữa các mạng với định tuyến tối ưu.

**Q4: Làm thế nào để bảo vệ giao dịch của tôi khỏi các cuộc tấn công MEV?**

1inch cung cấp nhiều cơ chế bảo vệ MEV: (1) **Lệnh Fusion+** được khớp bởi các resolver chuyên nghiệp, những ngườ nội bộ hoá việc thực thi, khiến việc chạy trước trở nên không thể; (2) **Thuật toán Pathfinder** có thể định tuyến qua **private mempools** và **Flashbots Protect** trên các chuỗi được hỗ trợ; (3) Đối với các giao dịch lớn, bật cờ `compatibility` sẽ thêm các kiểm tra slippage bổ sung; (4) Thiết lập dung sai `slippage` chặt chẽ làm giảm cửa sổ lợi nhuận cho các cuộc tấn công sandwich. Để bảo vệ tối đa cho các giao dịch giá trị cao, preset `slow` của Fusion+ được khuyến nghị.

**Q5: SDK 1inch có phù hợp cho giao dịch tổ chức hoặc giao dịch tần suất cao không?**

SDK 1inch được thiết kế cho **khả năng tương thích rộng** thay vì HFT độ trễ siêu thấp. Đối với các trường hợp sử dụng tổ chức, hãy xem xét: (1) **Truy cập API trực tiếp** với giới hạn tốc độ chuyên dụng thay vì SDK công khai; (2) Chạy **phiên bản Pathfinder riêng** của bạn để tạo báo giá dưới giây; (3) Sử dụng **price feed WebSocket** cho dữ liệu thị trường real-time; (4) Triển khai **co-location** với máy chủ API của 1inch. SDK xuất sắc trong quản lý portfolio, thực thi hoán đổi và xây dựng giao diện giao dịch, nhưng yêu cầu độ trễ dưới 100ms có thể cần cơ sở hạ tầng tùy chỉnh.

**Q6: Lệnh giới hạn trên 1inch hoạt động như thế nào, chúng có trên chuỗi không?**

Các lệnh giới hạn 1inch sử dụng mô hình **sổ lệnh ngoài chuỗi với thanh toán trên chuỗi**. Các lệnh được ký thông qua chữ ký dữ liệu typed EIP-712 và phát sóng đến mạng relayer của 1inch. Chúng vẫn ngoài chuỗi cho đến khi một **taker** (nhà tạo lập thị trường hoặc bot arbitrage) quyết định khớp chúng, tại thởi điểm đó việc thanh toán diễn ra trên chuỗi. Thiết kế này loại bỏ chi phí gas cho việc đặt và huỷ lệnh. Các lệnh có thể được **khớp đầy đủ** hoặc **khớp một phần** (cho phép các chiến lược tương tự DCA), và hết hạn dựa trên timestamp được đặt khi tạo.

**Q7: Tôi có thể tích hợp 1inch vào bot giao dịch hoặc giao thức DeFi của riêng mình không?**

Có — SDK được cấp phép MIT cho phép điều này một cách rõ ràng. Các mẫu tích hợp phổ biến bao gồm: (1) **Ứng dụng giao diện DEX** sử dụng 1inch làm backend hoán đổi; (2) **Yield aggregator** sử dụng 1inch để tái đầu tư phần thưởng và cân bằng lại; (3) **Bot arbitrage** giám sát sự khác biệt giá và thực thi thông qua định tuyến tối ưu của 1inch; (4) **Ứng dụng ví** cung cấp chức năng hoán đổi tích hợp; (5) **Công cụ báo cáo thuế** sử dụng Portfolio API. Tất cả các tích hợp phải tuân thủ [Điều khoản Dịch vụ](https://1inch.io/terms) và chính sách sử dụng API của 1inch.



## Hosting Và Hạ Tầng Được Đề Xuất

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit $200 trong 60 ngày.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## 10. Kết luận và Bắt đầu

1inch đã thiết lập mình như một **cơ sở hạ tầng thiết yếu** trong stack giao dịch DeFi. Khả năng của thuật toán Pathfinder trong việc định tuyến qua 300+ nguồn thanh khoản mang lại việc thực thi giá liên tục vượt trội, trong khi các tính năng như hoán đổi không gas Fusion+ và Portfolio API toàn diện cung cấp cho các nhà phát triển các công cụ mạnh mẽ để xây dựng các ứng dụng giao dịch thế hệ tiếp theo.

**TypeScript SDK** (`1inch/1inch-sdk`, 400 stars, giấy phép MIT) cung cấp một giao diện type-safe sẵn sàng production trừu tượng hoá sự phức tạp của định tuyến đa nguồn đồng thở duy trì kiểm soát chi tiết đối với các tham số thực thi. Dù bạn đang thực thi một hoán đổi token đơn giản, xây dựng bảng điều khiển giao dịch phức tạp, hay tích hợp lệnh giới hạn vào giao thức DeFi, 1inch cung cấp lớp cơ sở hạ tầng bạn cần.

**Bắt đầu rất đơn giản:**
1. Lấy khóa API từ [1inch Developer Portal](https://portal.1inch.io)
2. Cài đặt SDK: `npm install @1inch/sdk`
3. Làm theo ví dụ mã trong hướng dẫn này cho trường hợp sử dụng cụ thể của bạn
4. Tham gia [1inch Discord](https://discord.gg/1inch) để được hỗ trợ nhà phát triển

Đối với các trader tìm kiếm một sàn giao dịch tập trung đáng tin cậy đi kèm với hoạt động DeFi của họ, [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) cung cấp thanh khoản sâu và phí cạnh tranh, trong khi [OKX](https://www.promoohubly.com/join/12190433) cung cấp các công cụ giao dịch nâng cao và hỗ trợ đa chuỗi. Sự kết hợp của hiệu quả sàn giao dịch tập trung với khả năng tổng hợp phi tập trung của 1inch tạo ra một bộ công cụ giao dịch hoàn chỉnh cho bối cảnh đa chuỗi năm 2026.

Bắt đầu xây dựng với 1inch ngay hôm nay và mang đến cho ngườ dùng của bạn khả năng thực thi giá tốt nhất mà DeFi có thể cung cấp.
