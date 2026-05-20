---
title: 'opensea-nft-marketplace-api'
description: '{''en'': ''Complete guide to the OpenSea NFT marketplace API covering API key setup, Python SDK integration, programmatic listing/buying/selling of NFTs, real-time WebSocket event streaming, rate limiting strategies, and building a production trading bot.'', ''zh'': ''OpenSea NFT市场API完整指南，涵盖API密钥设置、Python SDK集成、NFT程序化上架/购买/出售、实时WebSocket事件流、速率限制策略以及构建生产级交易机器人。'', ''ko'': ''OpenSea NFT 마켓플레이스 API의 완전한 가이드로 API 키 설정, Python SDK 통합, NFT 프로그래밍 방식 상장/구매/판매, 실시간 WebSocket 이벤트 스트리밍, 속도 제한 전략 및 프로덕션 트레이딩 봇 구축을 다룹니다.'', ''vi'': ''Hướng dẫn đầy đủ về API thị trường NFT OpenSea bao gồm thiết lập khóa API, tích hợp Python SDK, niêm yết/mua/bán NFT lập trình, phát trực tuyến sự kiện WebSocket thở gian thực, chiến lược giới hạn tốc độ và xây dựng bot giao dịch sản xuất.''}'
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
github_repo: 'https://github.com/ProjectOpenSea/opensea-js'
stars: 1200
maintainer: 'ProjectOpenSea'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: ['en', 'zh', 'ko', 'vi']
aliases:
- /vi/posts/opensea-nft-marketplace-api/
---

{{</* resource-info */>}}

Hệ sinh thái token không thể thay thế (NFT) đã phát triển đáng kể kể từ sự bùng nổ tăng trưởng vào năm 2021. Từ một thị trường ngách cho nghệ thuật kỹ thuật số, nó đã phát triển thành một lớp cơ sở hạ tầng trị giá hàng tỷ đô la bao gồm game, bất động sản, danh tính và tài chính phi tập trung. Ở trung tâm của sự chuyển đổi này là [OpenSea](https://opensea.io/), thị trường NFT lớn nhất thế giới, và [OpenSea API](https://docs.opensea.io/reference/api-overview) mạnh mẽ của nó cho phép các nhà phát triển xây dựng hệ thống giao dịch lập trình, bảng phân tích và công cụ quản lý bộ sưu tập tự động.

Trong hướng dẫn toàn diện 2026 này, chúng ta sẽ khám phá mọi thứ bạn cần biết về OpenSea API: từ lấy khóa API và thiết lập Python SDK đến niêm yết NFT, thực hiện giao dịch, phát trực tuyến sự kiện thở gian thực qua WebSocket, và xử lý giới hạn tốc độ trong môi trường sản xuất. Cho dù bạn đang xây dựng bot giao dịch, trình theo dõi danh mục đầu tư hay bộ tổng hợp thị trường, hướng dẫn này cung cấp nền tảng kỹ thuật đầy đủ.

---

## OpenSea API là gì?

OpenSea API là một giao diện lập trình dựa trên REST và WebSocket cung cấp quyền truy cập đầy đủ vào thị trường NFT OpenSea. Nó cho phép các nhà phát triển truy vấn bộ sưu tập NFT, truy xuất metadata tài sản, niêm yết vật phẩm để bán, thực hiện lệnh, theo dõi hoạt động tài khoản và đăng ký luồng sự kiện thở gian thực — tất cả mà không cần tương tác thủ công với trang web OpenSea.

Tính đến năm 2026, OpenSea API hỗ trợ nhiều mạng blockchain bao gồm Ethereum, Polygon, Arbitrum, Optimism, Base và Zora. API được duy trì bởi [ProjectOpenSea](https://github.com/ProjectOpenSea) và đã trở thành tiêu chuẩn thực tế cho tích hợp thị trường NFT, với hơn **1.200 ngôi sao GitHub** trên kho SDK JavaScript chính thức của nó và một cộng đồng nhà phát triển năng động đóng góp các trình bao bọc cho Python, Go và Rust.

API tuân theo các quy ước REST hiện đại với định dạng yêu cầu/phản hồi JSON, sử dụng xác thực dựa trên khóa API và triển khai mã trạng thái HTTP chuẩn để xử lý lỗi. Đối với các ứng dụng thở gian thực, API WebSocket cung cấp phát trực tuyến sự kiện cho các giao dịch, niêm yết, chuyển giao và cập nhật bộ sưu tập với độ trễ dưới một giây.

---

## Bắt Đầu: Thiết Lập Khóa API và Xác Thực

Trước khi thực hiện bất kỳ cuộc gọi API nào, bạn cần đăng ký khóa API thông qua OpenSea Developer Portal. Khóa API là bắt buộc cho tất cả các endpoint đã xác thực và xác định cấp giới hạn tốc độ của bạn.

### Bước 1: Tạo Tài Khoản Nhà Phát Triển

Truy cập [OpenSea Developer Dashboard](https://docs.opensea.io/reference/api-keys) và đăng nhập bằng ví hoặc địa chỉ email của bạn. Hoàn thành quy trình xác minh nhà phát triển, bao gồm đồng ý với các điều khoản dịch vụ API và cung cấp mô tả ngắn gọn về trường hợp sử dụng dự kiến của bạn.

### Bước 2: Tạo Khóa API của Bạn

Sau khi được phê duyệt, hãy tạo khóa API mới từ bảng điều khiển. Bạn sẽ nhận được hai thông tin xác thực:

- **Khóa API**: Dùng để xác định ứng dụng của bạn
- **Khóa Bí Mật API**: Dùng để ký một số yêu cầu đã xác thực

Lưu trữ các thông tin xác thực này một cách an toàn trong các biến môi trường:

```bash
# Tệp .env
OPENSEA_API_KEY=your_api_key_here
OPENSEA_API_SECRET=your_api_secret_here
```

### Bước 3: Kiểm Tra Xác Thực của Bạn

Xác minh khóa API của bạn đang hoạt động bằng kiểm tra sức khỏe đơn giản:

```python
import os
import requests
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv("OPENSEA_API_KEY")
BASE_URL = "https://api.opensea.io/api/v2"

headers = {
    "X-API-KEY": API_KEY,
    "Accept": "application/json"
}

# Kiểm tra xác thực bằng cách lấy các bộ sưu tập
response = requests.get(
    f"{BASE_URL}/collections",
    headers=headers,
    params={"chain": "ethereum", "limit": 5}
)

print(f"Trạng thái: {response.status_code}")
print(f"Số bộ sưu tập: {len(response.json()['collections'])}")
```

### Bước 4: Cài Đặt SDK

Cài đặt SDK JavaScript chính thức hoặc trình bao bọc Python do cộng đồng duy trì:

```bash
# SDK JavaScript chính thức
npm install opensea-js

# SDK Python cộng đồng
pip install opensea-api

# Hoặc sử dụng requests trực tiếp
pip install requests python-dotenv
```

---

## Tổng Quan Các Endpoint OpenSea API

OpenSea API được tổ chức thành các nhóm endpoint logic bao gồm mọi khía cạnh của thị trường NFT. Hiểu các danh mục endpoint này là điều cần thiết để xây dựng các ứng dụng hiệu quả.

### Endpoint Bộ Sưu Tập và Metadata

Các endpoint bộ sưu tập cung cấp metadata toàn diện về các bộ sưu tập NFT, bao gồm giá sàn, thống kê khối lượng, phân phối đặc điểm và liên kết xã hội.

```python
def get_collection_details(collection_slug: str):
    """Lấy thông tin chi tiết về một bộ sưu tập NFT."""
    endpoint = f"{BASE_URL}/collections/{collection_slug}"
    response = requests.get(endpoint, headers=headers)
    
    data = response.json()
    return {
        "name": data["name"],
        "slug": data["collection"],
        "contract_address": data["contracts"][0]["address"],
        "floor_price": data["floor_prices"][0]["value"] if data.get("floor_prices") else None,
        "total_supply": data["total_supply"],
        "category": data.get("category"),
        "created_date": data["created_date"]
    }

# Ví dụ sử dụng
crypto_punks = get_collection_details("cryptopunks")
print(f"Giá sàn CryptoPunks: {crypto_punks['floor_price']} ETH")
```

### Endpoint Truy Vấn Tài Sản

Các endpoint tài sản cho phép bạn truy xuất metadata NFT riêng lẻ, thông tin sở hữu và trạng thái niêm yết.

```python
def get_asset_details(chain: str, address: str, token_id: str):
    """Truy xuất metadata cho một tài sản NFT cụ thể."""
    endpoint = f"{BASE_URL}/chain/{chain}/contract/{address}/nfts/{token_id}"
    response = requests.get(endpoint, headers=headers)
    
    data = response.json()["nft"]
    return {
        "identifier": data["identifier"],
        "token_standard": data["token_standard"],
        "name": data["name"],
        "description": data.get("description"),
        "image_url": data["image_url"],
        "metadata_url": data["metadata_url"],
        "traits": data.get("traits", []),
        "owners": data.get("owners", [])
    }

# Lấy một Bored Ape cụ thể
bored_ape = get_asset_details(
    chain="ethereum",
    address="0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D",
    token_id="1234"
)
print(f"Tài sản: {bored_ape['name']}")
print(f"Số đặc điểm: {len(bored_ape['traits'])}")
```

### Endpoint Niêm Yết và Lệnh

Các endpoint niêm yết quản lý việc tạo, truy xuất và hủy các lệnh bán NFT. Đây là các endpoint cốt lõi cho giao dịch lập trình.

```python
def get_listings_by_collection(collection_slug: str, limit: int = 20):
    """Lấy các niêm yết đang hoạt động cho một bộ sưu tập cụ thể."""
    endpoint = f"{BASE_URL}/listings/collection/{collection_slug}/all"
    params = {"limit": limit}
    
    response = requests.get(endpoint, headers=headers, params=params)
    listings = response.json()["listings"]
    
    return [{
        "order_hash": l["order_hash"],
        "price": l["price"]["current"]["value"],
        "currency": l["price"]["current"]["currency"],
        "token": {
            "contract": l["protocol_data"]["parameters"]["offer"][0]["token"],
            "identifier": l["protocol_data"]["parameters"]["offer"][0]["identifierOrCriteria"]
        },
        "maker": l["protocol_data"]["parameters"]["offerer"],
        "expiration": l["expiration_time"]
    } for l in listings]

# Lấy các niêm yết rẻ nhất
listings = get_listings_by_collection("boredapeyachtclub", limit=10)
for listing in sorted(listings, key=lambda x: float(x["price"])):
    print(f"Giá: {listing['price']} | Token: {listing['token']['identifier']}")
```

### Endpoint Tài Khoản và Hoạt Động

Theo dõi hoạt động ví, tài sản sở hữu và các sự kiện lịch sử cho bất kỳ địa chỉ Ethereum nào.

```python
def get_account_events(account_address: str, event_type: str = "order", limit: int = 50):
    """Truy xuất các sự kiện hoạt động cho một tài khoản cụ thể."""
    endpoint = f"{BASE_URL}/events/accounts/{account_address}"
    params = {
        "event_type": event_type,
        "limit": limit
    }
    
    response = requests.get(endpoint, headers=headers, params=params)
    events = response.json().get("asset_events", [])
    
    return [{
        "event_type": e["event_type"],
        "order_hash": e.get("order_hash"),
        "asset": e.get("asset", {}).get("name"),
        "quantity": e.get("quantity"),
        "payment": e.get("payment", {}).get("quantity") if e.get("payment") else None,
        "timestamp": e["event_timestamp"]
    } for e in events]

# Giám sát hoạt động ví cá voi
whale_address = "0x3b417faee9d1458e"
events = get_account_events(whale_address, event_type="sale", limit=20)
for event in events:
    print(f"{event['timestamp']}: {event['asset']} đã bán với giá {event['payment']}")
```

---

## Xây Dựng Tích Hợp Python SDK

Trong khi SDK OpenSea chính thức được viết bằng JavaScript/TypeScript, các nhà phát triển Python có thể xây dựng các tích hợp mạnh mẽ bằng thư viện `requests` hoặc các gói do cộng đồng duy trì. Dưới đây là trình bao bọc SDK Python sẵn sàng cho sản xuất xử lý xác thực, phân trang, thử lại lỗi và giới hạn tốc độ.

### Lớp Python SDK Đầy Đủ

```python
import os
import time
import logging
from typing import Optional, List, Dict, Any
from urllib.parse import urljoin

import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class OpenSeaAPI:
    """SDK Python sẵn sàng cho sản xuất cho OpenSea API."""
    
    BASE_URL = "https://api.opensea.io/api/v2"
    
    def __init__(self, api_key: Optional[str] = None, max_retries: int = 3):
        self.api_key = api_key or os.getenv("OPENSEA_API_KEY")
        if not self.api_key:
            raise ValueError("Cần khóa API. Đặt biến môi trường OPENSEA_API_KEY.")
        
        self.session = requests.Session()
        self.session.headers.update({
            "X-API-KEY": self.api_key,
            "Accept": "application/json",
            "Content-Type": "application/json"
        })
        
        # Cấu hình chiến lược thử lại
        retry_strategy = Retry(
            total=max_retries,
            backoff_factor=1,
            status_forcelist=[429, 500, 502, 503, 504],
        )
        adapter = HTTPAdapter(max_retries=retry_strategy)
        self.session.mount("https://", adapter)
    
    def _request(self, method: str, endpoint: str, **kwargs) -> Dict[str, Any]:
        """Thực hiện yêu cầu đã xác thực với xử lý giới hạn tốc độ."""
        url = urljoin(self.BASE_URL, endpoint)
        
        try:
            response = self.session.request(method, url, **kwargs)
            
            # Xử lý giới hạn tốc độ
            if response.status_code == 429:
                reset_time = int(response.headers.get("X-RateLimit-Reset", 60))
                logger.warning(f"Bị giới hạn tốc độ. Chờ {reset_time} giây...")
                time.sleep(reset_time)
                response = self.session.request(method, url, **kwargs)
            
            response.raise_for_status()
            return response.json()
            
        except requests.exceptions.RequestException as e:
            logger.error(f"Yêu cầu thất bại: {e}")
            raise
    
    def get_collections(
        self, 
        chain: str = "ethereum", 
        limit: int = 100,
        next_cursor: Optional[str] = None
    ) -> Dict[str, Any]:
        """Truy xuất các bộ sưu tập NFT với phân trang."""
        params = {"chain": chain, "limit": min(limit, 100)}
        if next_cursor:
            params["next"] = next_cursor
        
        return self._request("GET", "/collections", params=params)
    
    def get_collection_stats(self, collection_slug: str) -> Dict[str, Any]:
        """Lấy giá sàn, khối lượng và thống kê nguồn cung."""
        return self._request("GET", f"/collections/{collection_slug}/stats")
    
    def get_nft(
        self, 
        chain: str, 
        contract_address: str, 
        token_id: str
    ) -> Dict[str, Any]:
        """Lấy chi tiết của một NFT cụ thể."""
        endpoint = f"/chain/{chain}/contract/{contract_address}/nfts/{token_id}"
        return self._request("GET", endpoint)
    
    def get_listings(
        self, 
        chain: str, 
        contract_address: str, 
        token_id: str,
        limit: int = 50
    ) -> List[Dict[str, Any]]:
        """Lấy các niêm yết đang hoạt động cho một NFT cụ thể."""
        endpoint = f"/orders/{chain}/seaport/listings"
        params = {
            "asset_contract_address": contract_address,
            "token_ids": token_id,
            "limit": limit
        }
        return self._request("GET", endpoint, params=params)
    
    def get_best_listing(
        self, 
        chain: str, 
        contract_address: str, 
        token_id: str
    ) -> Optional[Dict[str, Any]]:
        """Lấy niêm yết đang hoạt động có giá thấp nhất."""
        listings = self.get_listings(chain, contract_address, token_id, limit=1)
        return listings[0] if listings else None


# Khởi tạo SDK
sdk = OpenSeaAPI()

# Lấy thống kê bộ sưu tập
stats = sdk.get_collection_stats("boredapeyachtclub")
print(f"Giá sàn: {stats['total']['floor_price']}")
print(f"Khối lượng: {stats['total']['volume']}")
```

---

## Niêm Yết, Mua và Bán NFT Bằng Lập Trình

Giao dịch lập trình là tính năng mạnh mẽ nhất của OpenSea API. Bạn có thể niêm yết NFT để bán, chấp nhận đề nghị và thực hiện lệnh hoàn toàn thông qua mã.

### Tạo Niêm Yết

Để niêm yết một NFT, bạn cần tạo lệnh Seaport. Điều này yêu cầu ký lệnh bằng khóa riêng của chủ sở hữu:

```python
from web3 import Web3

# Kết nối với nút Ethereum
w3 = Web3(Web3.HTTPProvider("https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY"))

# Xây dựng thông số niêm yết
listing_data = {
    "parameters": {
        "offerer": "0xYourWalletAddress",
        "zone": "0x0000000000000000000000000000000000000000",
        "offer": [{
            "itemType": 2,  # ERC721
            "token": "0xNFTContractAddress",
            "identifierOrCriteria": "1234",
            "startAmount": "1",
            "endAmount": "1"
        }],
        "consideration": [
            {
                "itemType": 0,  # ETH
                "token": "0x0000000000000000000000000000000000000000",
                "identifierOrCriteria": "0",
                "startAmount": "1000000000000000000",  # 1 ETH tính bằng wei
                "endAmount": "1000000000000000000",
                "recipient": "0xYourWalletAddress"
            },
            {
                "itemType": 0,
                "token": "0x0000000000000000000000000000000000000000",
                "identifierOrCriteria": "0",
                "startAmount": "25000000000000000",  # Phí 2.5%
                "endAmount": "25000000000000000",
                "recipient": "0x0000a26b00c1F0DF003000390027140000fAa719"  # Phí OpenSea
            }
        ],
        "orderType": 0,
        "startTime": int(time.time()),
        "endTime": int(time.time()) + 86400 * 7,  # 7 ngày
        "zoneHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "salt": "0x" + os.urandom(32).hex(),
        "conduitKey": "0x0000007b02230091a7ed01230072f7006a004d60a8d4e71d599b8104250f0000",
        "totalOriginalConsiderationItems": 2
    },
    "signature": "0x..."  # Đã ký bằng khóa riêng của chủ sở hữu
}

# Gửi lệnh đến OpenSea
response = requests.post(
    f"{BASE_URL}/orders/ethereum/seaport/listings",
    headers=headers,
    json=listing_data
)
print(f"Niêm yết đã tạo: {response.status_code}")
```

### Thực Hiện Lệnh (Mua NFT)

Để mua một NFT đã niêm yết, hãy truy xuất lệnh và gửi giao dịch thực hiện:

```python
def fulfill_order(order_hash: str, buyer_address: str):
    """Thực hiện lệnh hiện có để mua NFT."""
    # Lấy chi tiết lệnh
    order_response = requests.get(
        f"{BASE_URL}/orders/ethereum/seaport/{order_hash}",
        headers=headers
    )
    order = order_response.json()
    
    # Xây dựng giao dịch thực hiện
    fulfillment_data = {
        "order_hash": order_hash,
        "fulfiller": buyer_address,
        "offer": order["protocol_data"]["parameters"]["offer"],
        "consideration": order["protocol_data"]["parameters"]["consideration"]
    }
    
    # Gửi đến hợp đồng Seaport
    seaport_address = "0x0000000000000068F116a894984e2DB1123eB395"
    seaport_contract = w3.eth.contract(
        address=seaport_address,
        abi=SEAPORT_ABI
    )
    
    tx = seaport_contract.functions.fulfillBasicOrder(
        fulfillment_data
    ).build_transaction({
        "from": buyer_address,
        "value": int(order["price"]["current"]["value"]),
        "gas": 300000,
        "nonce": w3.eth.get_transaction_count(buyer_address)
    })
    
    return tx

# Mua vật phẩm niêm yết rẻ nhất
cheapest = min(listings, key=lambda x: float(x["price"]))
tx = fulfill_order(cheapest["order_hash"], "0xBuyerWalletAddress")
```

### Các Thao Tác Hàng Loạt

Để giao dịch tần suất cao, hãy sử dụng các endpoint hàng loạt để xử lý nhiều thao tác:

```python
def batch_get_listings(requests_list: List[Dict]) -> List[Dict]:
    """Lấy nhiều niêm yết trong một yêu cầu duy nhất."""
    response = requests.post(
        f"{BASE_URL}/listings/batch",
        headers=headers,
        json={"requests": requests_list}
    )
    return response.json()["results"]

# Yêu cầu hàng loạt nhiều bộ sưu tập
collections = ["boredapeyachtclub", "cryptopunks", "azuki"]
requests_list = [{"collection": c, "limit": 5} for c in collections]
batch_results = batch_get_listings(requests_list)
```

---

## Phát Trực Tuyến Sự Kiện Thở Gian Thực với WebSocket

API WebSocket OpenSea cho phép giám sát các sự kiện thị trường thở gian thực. Điều này là điều cần thiết cho các bot giao dịch, hệ thống thông báo và nền tảng phân tích cần cập nhật tức thì.

### Thiết Lập Kết Nối WebSocket

```python
import json
import asyncio
import websockets

class OpenSeaStreamClient:
    """Client WebSocket để phát trực tuyến sự kiện OpenSea thở gian thực."""
    
    WS_URL = "wss://stream.opensea.io/socket"
    
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.subscriptions = []
        self.running = False
    
    async def connect(self):
        """Thiết lập kết nối WebSocket với xác thực."""
        self.ws = await websockets.connect(
            self.WS_URL,
            extra_headers={"X-API-KEY": self.api_key}
        )
        logger.info("WebSocket đã kết nối")
    
    async def subscribe(self, event_type: str, filters: dict = None):
        """Đăng ký luồng sự kiện cụ thể."""
        payload = {
            "topic": event_type,
            "filters": filters or {}
        }
        await self.ws.send(json.dumps({
            "method": "SUBSCRIBE",
            "params": [payload]
        }))
        logger.info(f"Đã đăng ký: {event_type}")
    
    async def listen(self, callback):
        """Lắng nghe các sự kiện đến."""
        self.running = True
        while self.running:
            try:
                message = await self.ws.recv()
                data = json.loads(message)
                await callback(data)
            except websockets.exceptions.ConnectionClosed:
                logger.warning("Kết nối đóng, đang kết nối lại...")
                await self.connect()
                for sub in self.subscriptions:
                    await self.subscribe(sub["type"], sub.get("filters"))
    
    async def disconnect(self):
        """Đóng kết nối WebSocket."""
        self.running = False
        await self.ws.close()


# Bộ xử lý sự kiện
async def handle_event(event: dict):
    """Xử lý các sự kiện thị trường đến."""
    event_type = event.get("event_type")
    payload = event.get("payload", {})
    
    if event_type == "item_listed":
        print(f"[NIÊM YẾT] {payload['name']} giá {payload['base_price']} ETH")
    elif event_type == "item_sold":
        print(f"[ĐÃ BÁN] {payload['name']} với giá {payload['sale_price']} ETH")
    elif event_type == "item_cancelled":
        print(f"[ĐÃ HỦY] {payload['name']}")
    elif event_type == "collection_offer":
        print(f"[ĐỀ NGHỊ] Đề nghị bộ sưu tập cho {payload['collection_slug']}")


# Chạy luồng sự kiện
async def main():
    client = OpenSeaStreamClient(api_key=API_KEY)
    await client.connect()
    
    # Đăng ký các sự kiện
    await client.subscribe("item_listed", {"collection_slug": "boredapeyachtclub"})
    await client.subscribe("item_sold", {"collection_slug": "boredapeyachtclub"})
    
    # Bắt đầu lắng nghe
    await client.listen(handle_event)

# asyncio.run(main())
```

### Tham Chiếu Các Loại Sự Kiện

API WebSocket hỗ trợ nhiều loại sự kiện cho các trường hợp sử dụng khác nhau:

```python
# Các loại sự kiện có sẵn
EVENT_TYPES = {
    "item_listed": "Niêm yết mới được tạo",
    "item_sold": "Vật phẩm đã được mua",
    "item_cancelled": "Niêm yết đã bị hủy",
    "item_received_bid": "Đặt giá mới",
    "item_received_offer": "Đề nghị mới",
    "collection_offer": "Đề nghị toàn bộ bộ sưu tập",
    "trait_offer": "Đề nghị đặc điểm cụ thể",
    "item_metadata_updated": "Metadata NFT đã được làm mới",
    "item_transfer": "Token đã được chuyển"
}
```

---

## Giới Hạn Tốc Độ và Các Phương Pháp Tốt Nhất

Hiểu các giới hạn tốc độ là rất quan trọng cho các ứng dụng sản xuất. Vượt quá giới hạn dẫn đến lệnh cấm tạm thởi có thể làm gián đoạn các hoạt động giao dịch.

### Các Cấp Giới Hạn Tốc Độ

| Cấp | Yêu Cầu/Giây | Giới Hạn Đột Biến | Trường Hợp Sử Dụng |
|------|--------------|-------------------|-------------------|
| Miễn Phí | 1 | 5 | Phát triển, thử nghiệm |
| Nhà Phát Triển | 10 | 50 | Ứng dụng nhỏ |
| Chuyên Nghiệp | 40 | 200 | Bot giao dịch, phân tích |
| Doanh Nghiệp | 120+ | 600+ | Giao dịch tần suất cao |

### Các Tiêu Đề Giới Hạn Tốc Độ

Mỗi phản hồi API đều bao gồm các tiêu đề giới hạn tốc độ:

```python
def check_rate_limits(response: requests.Response):
    """Trích xuất và giám sát trạng thái giới hạn tốc độ."""
    limit = response.headers.get("X-RateLimit-Limit")
    remaining = response.headers.get("X-RateLimit-Remaining")
    reset = response.headers.get("X-RateLimit-Reset")
    
    print(f"Giới hạn tốc độ: {remaining}/{limit}")
    print(f"Đặt lại sau: {reset} giây")
    
    # Cảnh báo nếu đang tiến gần giới hạn
    if int(remaining) < 10:
        logger.warning(f"Đang tiến gần giới hạn tốc độ! Còn {remaining} yêu cầu")
    
    return {
        "limit": int(limit) if limit else None,
        "remaining": int(remaining) if remaining else None,
        "reset": int(reset) if reset else None
    }

# Áp dụng cho mỗi yêu cầu
response = requests.get(f"{BASE_URL}/collections", headers=headers)
limits = check_rate_limits(response)
```

### Triển Khai Các Chiến Lược Backoff

```python
import random

class AdaptiveRateLimiter:
    """Bộ giới hạn tốc độ thích ứng với backoff hàm mũ."""
    
    def __init__(self, base_delay: float = 1.0, max_delay: float = 60.0):
        self.base_delay = base_delay
        self.max_delay = max_delay
        self.current_delay = base_delay
        self.consecutive_errors = 0
    
    def wait(self):
        """Chờ với độ trễ thích ứng."""
        jitter = random.uniform(0, 0.5)
        time.sleep(self.current_delay + jitter)
    
    def on_success(self):
        """Giảm độ trễ sau yêu cầu thành công."""
        self.consecutive_errors = 0
        self.current_delay = max(self.base_delay, self.current_delay * 0.8)
    
    def on_error(self, status_code: int):
        """Tăng độ trễ sau lỗi."""
        self.consecutive_errors += 1
        if status_code == 429:
            self.current_delay = min(
                self.max_delay,
                self.current_delay * 2 ** self.consecutive_errors
            )
            logger.warning(f"Bị giới hạn tốc độ. Backoff: {self.current_delay}s")


# Sử dụng trong vòng lặp yêu cầu
limiter = AdaptiveRateLimiter(base_delay=0.5)

for page in range(100):
    limiter.wait()
    try:
        response = requests.get(f"{BASE_URL}/assets", headers=headers, params={"offset": page * 50})
        response.raise_for_status()
        limiter.on_success()
        process_assets(response.json())
    except requests.exceptions.HTTPError as e:
        limiter.on_error(e.response.status_code)
```

### Các Chiến Lược Lưu Vào Bộ Nhớ Đệm

```python
from functools import lru_cache
from datetime import datetime, timedelta

class OpenSeaCache:
    """Bộ nhớ đệm TTL đơn giản cho các phản hồi API."""
    
    def __init__(self, ttl_seconds: int = 60):
        self.cache = {}
        self.ttl = ttl_seconds
    
    def get(self, key: str):
        if key in self.cache:
            value, expiry = self.cache[key]
            if datetime.now() < expiry:
                return value
            del self.cache[key]
        return None
    
    def set(self, key: str, value):
        expiry = datetime.now() + timedelta(seconds=self.ttl)
        self.cache[key] = (value, expiry)

# Lưu vào bộ nhớ đệm metadata bộ sưu tập (ít thay đổi)
collection_cache = OpenSeaCache(ttl_seconds=300)

def get_cached_collection(slug: str):
    cached = collection_cache.get(slug)
    if cached:
        return cached
    
    data = sdk.get_collection_stats(slug)
    collection_cache.set(slug, data)
    return data
```

---

## Xây Dựng Bot Giao Dịch: Ví Dụ Hoàn Chỉnh

Dưới đây là ví dụ hoàn chỉnh về bot giao dịch phát hiện chênh lệch giá giám sát giá sàn trên các bộ sưu tập:

```python
import time
from dataclasses import dataclass
from typing import Callable

@dataclass
class ArbitrageOpportunity:
    collection: str
    token_id: str
    listed_price: float
    estimated_value: float
    profit_margin: float
    listing_url: str


class NFTArbitrageBot:
    """Bot phát hiện chênh lệch giá đơn giản sử dụng OpenSea API."""
    
    def __init__(self, api: OpenSeaAPI, min_profit_pct: float = 15.0):
        self.api = api
        self.min_profit_pct = min_profit_pct
        self.watchlist = []
        self.callbacks: List[Callable] = []
    
    def add_collection(self, collection_slug: str, floor_threshold: float):
        """Thêm bộ sưu tập vào danh sách theo dõi."""
        self.watchlist.append({
            "slug": collection_slug,
            "threshold": floor_threshold
        })
    
    def on_opportunity(self, callback: Callable):
        """Đăng ký callback cho các cơ hội chênh lệch giá."""
        self.callbacks.append(callback)
    
    def analyze_collection(self, collection: dict) -> List[ArbitrageOpportunity]:
        """Quét bộ sưu tập để tìm các niêm yết giá thấp."""
        slug = collection["slug"]
        
        # Lấy giá sàn và các niêm yết đang hoạt động
        stats = self.api.get_collection_stats(slug)
        floor_price = float(stats["total"]["floor_price"])
        
        listings = self.api.get_listings(
            chain="ethereum",
            contract_address=collection.get("contract"),
            limit=50
        )
        
        opportunities = []
        for listing in listings:
            price = float(listing["price"])
            
            # Kiểm tra xem có thấp hơn đáng kể so với giá sàn không
            if price < floor_price * (1 - self.min_profit_pct / 100):
                opp = ArbitrageOpportunity(
                    collection=slug,
                    token_id=listing["token_id"],
                    listed_price=price,
                    estimated_value=floor_price,
                    profit_margin=((floor_price - price) / price) * 100,
                    listing_url=f"https://opensea.io/assets/ethereum/{collection['contract']}/{listing['token_id']}"
                )
                opportunities.append(opp)
                
                # Thông báo các callback
                for cb in self.callbacks:
                    cb(opp)
        
        return opportunities
    
    def run(self, interval: int = 30):
        """Chạy bot với khoảng thở gian kiểm tra được chỉ định."""
        logger.info(f"Khởi động bot với {len(self.watchlist)} bộ sưu tập")
        
        try:
            while True:
                for collection in self.watchlist:
                    try:
                        opps = self.analyze_collection(collection)
                        if opps:
                            logger.info(f"Tìm thấy {len(opps)} cơ hội trong {collection['slug']}")
                    except Exception as e:
                        logger.error(f"Lỗi phân tích {collection['slug']}: {e}")
                
                time.sleep(interval)
        except KeyboardInterrupt:
            logger.info("Bot đã dừng bởi ngưởi dùng")


# Ví dụ sử dụng
def notify_discord(opp: ArbitrageOpportunity):
    """Gửi thông báo Discord cho cơ hội."""
    message = f"""
    **Cảnh Báo Chênh Lệch Giá!**
    Bộ Sưu Tập: {opp.collection}
    Token: #{opp.token_id}
    Niêm Yết: {opp.listed_price:.4f} ETH
    Giá Sàn: {opp.estimated_value:.4f} ETH
    Lợi Nhuận: {opp.profit_margin:.1f}%
    [Xem Niêm Yết]({opp.listing_url})
    """
    # send_to_discord_webhook(message)

bot = NFTArbitrageBot(sdk, min_profit_pct=20.0)
bot.add_collection("boredapeyachtclub", floor_threshold=30.0)
bot.add_collection("azuki", floor_threshold=10.0)
bot.on_opportunity(notify_discord)
# bot.run(interval=60)
```

---

## Xử Lý Lỗi và Gỡ Lỗi

Các ứng dụng sản xuất yêu cầu xử lý lỗi mạnh mẽ. API OpenSea trả về các phản hồi lỗi có cấu trúc:

```python
class OpenSeaAPIError(Exception):
    """Ngoại lệ tùy chỉnh cho lỗi API OpenSea."""
    
    def __init__(self, message: str, status_code: int = None, response_data: dict = None):
        super().__init__(message)
        self.status_code = status_code
        self.response_data = response_data or {}

def handle_api_error(response: requests.Response):
    """Phân tích và nâng các ngoại lệ thích hợp."""
    try:
        error_data = response.json()
    except ValueError:
        error_data = {"message": response.text}
    
    error_map = {
        400: ("Yêu Cầu Không Hợp Lệ", ValueError),
        401: ("Chưa Xác Thực - Kiểm tra khóa API", PermissionError),
        403: ("Bị Cấm - Quyền không đủ", PermissionError),
        404: ("Không tìm thấy tài nguyên", KeyError),
        429: ("Vượt quá giới hạn tốc độ", TimeoutError),
        500: ("Lỗi máy chủ nội bộ", RuntimeError),
        503: ("Dịch vụ không khả dụng", ConnectionError)
    }
    
    error_msg, error_class = error_map.get(
        response.status_code, 
        (f"HTTP {response.status_code}", RuntimeError)
    )
    
    detail = error_data.get("message", error_data.get("detail", "Lỗi không xác định"))
    raise error_class(f"{error_msg}: {detail}")

# Áp dụng trong SDK
class RobustOpenSeaAPI(OpenSeaAPI):
    def _request(self, method: str, endpoint: str, **kwargs):
        response = self.session.request(method, self.BASE_URL + endpoint, **kwargs)
        if not response.ok:
            handle_api_error(response)
        return response.json()
```

---

## Câu Hỏi Thường Gặp

### Làm thế nào để lấy khóa API OpenSea?

Truy cập [OpenSea Developer Dashboard](https://docs.opensea.io/reference/api-keys), đăng nhập bằng ví của bạn và hoàn thành đơn đăng ký nhà phát triển. Việc phê duyệt thường mất 1-3 ngày làm việc. Bạn cần mô tả trường hợp sử dụng của mình và đồng ý với các điều khoản dịch vụ API. Khóa cấp doanh nghiệp yêu cầu xác minh bổ sung và thỏa thuận đối tác trực tiếp.

### Các giới hạn tốc độ của OpenSea API là gì?

Giới hạn tốc độ phụ thuộc vào cấp API của bạn. Cấp miễn phí cho phép 1 yêu cầu mỗi giây với đột biến 5. Cấp nhà phát triển tăng lên 10 RPS với đột biến 50. Cấp chuyên nghiệp hỗ trợ 40 RPS với đột biến 200. Các cấp doanh nghiệp cung cấp 120+ RPS cho các ứng dụng giao dịch tần suất cao. Kiểm tra các tiêu đề `X-RateLimit-*` trong mỗi phản hồi để giám sát việc sử dụng của bạn.

### Tôi có thể mua và bán NFT thông qua API không?

Có, API hỗ trợ giao dịch lập trình đầy đủ. Bạn có thể tạo niêm yết, chấp nhận đề nghị và thực hiện lệnh hoàn toàn thông qua API. Tuy nhiên, bạn cần khóa riêng của ví sở hữu NFT. Tất cả các giao dịch đều được thực hiện thông qua giao thức Seaport, yêu cầu chữ ký trên chuỗi và phí gas.

### OpenSea API hỗ trợ những blockchain nào?

Tính đến năm 2026, OpenSea API hỗ trợ Ethereum mainnet, Polygon (PoS và zkEVM), Arbitrum One, Optimism, Base, Zora và Sepolia testnet. Mỗi chuỗi có tiền tố endpoint riêng (ví dụ: `/chain/ethereum/`, `/chain/polygon/`). Các endpoint tổng hợp đa chuỗi cho phép truy vấn đồng thởi trên nhiều mạng.

### Có SDK Python chính thức cho OpenSea không?

Không có SDK Python chính thức từ OpenSea. SDK chính thức là [opensea-js](https://github.com/ProjectOpenSea/opensea-js) (JavaScript/TypeScript). Tuy nhiên, có một số gói Python do cộng đồng duy trì, và bạn có thể dễ dàng xây dựng tích hợp của riêng mình bằng thư viện `requests` như được trình bày trong hướng dẫn này. REST API được tài liệu hóa đầy đủ và tuân theo các quy ước chuẩn.

### Làm thế nào để phát trực tuyến các sự kiện thở gian thực?

Sử dụng API WebSocket tại `wss://stream.opensea.io/socket`. Đăng ký các loại sự kiện như `item_listed`, `item_sold` và `item_cancelled` với bộ lọc bộ sưu tập tùy chọn. Kết nối WebSocket yêu cầu khóa API của bạn trong tiêu đề `X-API-KEY`. Triển khai logic kết nối lại để đảm bảo độ tin cậy trong sản xuất.

### Giao thức Seaport là gì?

Seaport là giao thức giao dịch NFT phi tập trung của OpenSea. Đó là một tiêu chuẩn hợp đồng thông minh nguồn mở xử lý khớp lệnh, thực hiện và phân phối phí. Khi bạn tạo hoặc thực hiện lệnh thông qua API, bạn đang tương tác với các hợp đồng Seaport trên chuỗi. Giao thức hỗ trợ các tính năng nâng cao như lệnh dựa trên tiêu chí, điền một phần và thực hiện hàng loạt.

---



## Hosting Và Hạ Tầng Được Đề Xuất

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit $200 trong 60 ngày.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Kết Luận

OpenSea API là API thị trường NFT toàn diện và đã qua thử nghiệm thực tế nhất có sẵn vào năm 2026. Với hỗ trợ cho nhiều blockchain, phát trực tuyến WebSocket thở gian thực và khả năng giao dịch lập trình đầy đủ, nó cung cấp cho các nhà phát triển mọi thứ họ cần để xây dựng các ứng dụng NFT phức tạp.

Các điểm chính từ hướng dẫn này:

- **Xác Thực**: Lấy khóa API từ Developer Dashboard và luôn sử dụng các biến môi trường
- **Chiến Lược SDK**: Sử dụng SDK JavaScript chính thức hoặc xây dựng trình bao bọc Python tùy chỉnh với logic thử lại
- **Giao Dịch**: Hiểu cách tạo và thực hiện lệnh Seaport để mua/bán lập trình
- **Thở Gian Thực**: Tận dụng luồng WebSocket để nhận thông báo sự kiện tức thì
- **Giới Hạn Tốc Độ**: Triển khai backoff thích ứng và lưu vào bộ nhớ đệm để duy trì trong giới hạn cấp của bạn
- **Xử Lý Lỗi**: Xây dựng xử lý lỗi mạnh mẽ để đảm bảo độ tin cậy trong sản xuất

Cho dù bạn đang xây dựng trình theo dõi danh mục đầu tư đơn giản hay bot giao dịch tần suất cao, OpenSea API đều cung cấp cơ sở hạ tầng để tương tác lập trình với thị trường NFT lớn nhất thế giới. Bắt đầu với các ví dụ trong hướng dẫn này, giám sát các giới hạn tốc độ của bạn và mở rộng ứng dụng khi nhu cầu phát triển.

---

*Bài viết này được viết vào 2026-05-19. Thông số kỹ thuật API và giới hạn tốc độ có thể thay đổi. Tham khảo [tài liệu OpenSea chính thức](https://docs.opensea.io/) để biết các cập nhật mới nhất.*
