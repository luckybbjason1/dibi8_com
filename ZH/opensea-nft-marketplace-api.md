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
- /zh/posts/opensea-nft-marketplace-api/
---

{{</* resource-info */>}}

自2021年爆发式增长以来，非同质化代币（NFT）生态系统已经显著成熟。从一个数字艺术品的小众市场，它已发展成为涵盖游戏、房地产、身份认证和去中心化金融的数十亿美元基础设施层。在这一转型的中心是[OpenSea](https://opensea.io/)——全球最大的NFT市场，以及其强大的[OpenSea API](https://docs.opensea.io/reference/api-overview)，使开发者能够构建程序化交易系统、分析仪表板和自动化的藏品管理工具。

在这份2026年综合指南中，我们将探索关于OpenSea API的所有内容：从获取API密钥和设置Python SDK，到上架NFT、执行交易、通过WebSocket进行实时事件流，以及在生产环境中处理速率限制。无论您是在构建交易机器人、投资组合追踪器还是市场聚合器，本指南都提供了完整的技术基础。

---

## 什么是OpenSea API？

OpenSea API是一个基于REST和WebSocket的编程接口，提供对OpenSea NFT市场的完整访问。它允许开发者查询NFT藏品、检索资产元数据、上架销售物品、完成订单、追踪账户活动，以及订阅实时事件流——所有这些都无需手动与OpenSea网站交互。

截至2026年，OpenSea API支持多个区块链网络，包括以太坊、Polygon、Arbitrum、Optimism、Base和Zora。该API由[ProjectOpenSea](https://github.com/ProjectOpenSea)维护，已成为NFT市场集成的事实标准，其官方JavaScript SDK仓库拥有超过**1,200个GitHub星标**，并且有一个活跃的开发者社区为Python、Go和Rust贡献封装库。

该API遵循现代REST约定，使用JSON请求/响应格式，采用基于API密钥的身份验证，并使用标准HTTP状态码进行错误处理。对于实时应用，WebSocket API提供交易、上架、转账和藏品更新的事件流，延迟低于一秒。

---

## 快速入门：API密钥设置与身份验证

在进行任何API调用之前，您需要通过OpenSea开发者门户注册API密钥。所有认证端点都需要API密钥，它决定了您的速率限制等级。

### 步骤1：创建开发者账户

访问[OpenSea开发者仪表板](https://docs.opensea.io/reference/api-keys)，使用您的钱包或电子邮件地址登录。完成开发者验证流程，包括同意API服务条款并提供预期用途的简要描述。

### 步骤2：生成您的API密钥

获得批准后，从仪表板创建新的API密钥。您将收到两个凭证：

- **API密钥**：用于识别您的应用
- **API密钥**：用于签名某些认证请求

将这些凭证安全地存储在环境变量中：

```bash
# .env文件
OPENSEA_API_KEY=your_api_key_here
OPENSEA_API_SECRET=your_api_secret_here
```

### 步骤3：测试您的身份验证

使用简单的健康检查验证您的API密钥是否正常工作：

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

# 通过获取藏品测试身份验证
response = requests.get(
    f"{BASE_URL}/collections",
    headers=headers,
    params={"chain": "ethereum", "limit": 5}
)

print(f"状态: {response.status_code}")
print(f"藏品数量: {len(response.json()['collections'])}")
```

### 步骤4：安装SDK

安装官方JavaScript SDK或社区Python封装库：

```bash
# 官方JavaScript SDK
npm install opensea-js

# Python社区SDK
pip install opensea-api

# 或直接requests
pip install requests python-dotenv
```

---

## OpenSea API端点概览

OpenSea API按逻辑端点组组织，涵盖NFT市场的每个方面。理解这些端点类别对于构建高效应用至关重要。

### 藏品与元数据端点

藏品端点提供关于NFT藏品的全面元数据，包括地板价、交易量统计、特征分布和社交链接。

```python
def get_collection_details(collection_slug: str):
    """获取NFT藏品的详细信息。"""
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

# 使用示例
crypto_punks = get_collection_details("cryptopunks")
print(f"CryptoPunks地板价: {crypto_punks['floor_price']} ETH")
```

### 资产查询端点

资产端点允许您检索单个NFT的元数据、所有权信息和上架状态。

```python
def get_asset_details(chain: str, address: str, token_id: str):
    """检索特定NFT资产的元数据。"""
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

# 获取特定无聊猿
bored_ape = get_asset_details(
    chain="ethereum",
    address="0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D",
    token_id="1234"
)
print(f"资产: {bored_ape['name']}")
print(f"特征数量: {len(bored_ape['traits'])}")
```

### 上架与订单端点

上架端点管理NFT销售订单的创建、检索和取消。这些是程序化交易的核心端点。

```python
def get_listings_by_collection(collection_slug: str, limit: int = 20):
    """获取特定藏品的活跃上架。"""
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

# 获取最便宜的上架
listings = get_listings_by_collection("boredapeyachtclub", limit=10)
for listing in sorted(listings, key=lambda x: float(x["price"])):
    print(f"价格: {listing['price']} | 代币: {listing['token']['identifier']}")
```

### 账户与活动端点

追踪任何以太坊地址的钱包活动、持有资产和历史事件。

```python
def get_account_events(account_address: str, event_type: str = "order", limit: int = 50):
    """检索特定账户的活动事件。"""
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

# 监控鲸鱼钱包活动
whale_address = "0x3b417faee9d1458e"
events = get_account_events(whale_address, event_type="sale", limit=20)
for event in events:
    print(f"{event['timestamp']}: {event['asset']} 以 {event['payment']} 售出")
```

---

## 构建Python SDK集成

虽然官方OpenSea SDK是用JavaScript/TypeScript编写的，但Python开发者可以使用requests库或社区维护的包来构建强大的集成。以下是一个生产就绪的Python SDK封装，处理身份验证、分页、错误重试和速率限制。

### 完整的Python SDK类

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
    """用于OpenSea API的生产就绪Python SDK。"""
    
    BASE_URL = "https://api.opensea.io/api/v2"
    
    def __init__(self, api_key: Optional[str] = None, max_retries: int = 3):
        self.api_key = api_key or os.getenv("OPENSEA_API_KEY")
        if not self.api_key:
            raise ValueError("需要API密钥。请设置OPENSEA_API_KEY环境变量。")
        
        self.session = requests.Session()
        self.session.headers.update({
            "X-API-KEY": self.api_key,
            "Accept": "application/json",
            "Content-Type": "application/json"
        })
        
        # 配置重试策略
        retry_strategy = Retry(
            total=max_retries,
            backoff_factor=1,
            status_forcelist=[429, 500, 502, 503, 504],
        )
        adapter = HTTPAdapter(max_retries=retry_strategy)
        self.session.mount("https://", adapter)
    
    def _request(self, method: str, endpoint: str, **kwargs) -> Dict[str, Any]:
        """发起带速率限制处理的认证请求。"""
        url = urljoin(self.BASE_URL, endpoint)
        
        try:
            response = self.session.request(method, url, **kwargs)
            
            # 处理速率限制
            if response.status_code == 429:
                reset_time = int(response.headers.get("X-RateLimit-Reset", 60))
                logger.warning(f"速率受限。等待 {reset_time} 秒...")
                time.sleep(reset_time)
                response = self.session.request(method, url, **kwargs)
            
            response.raise_for_status()
            return response.json()
            
        except requests.exceptions.RequestException as e:
            logger.error(f"请求失败: {e}")
            raise
    
    def get_collections(
        self, 
        chain: str = "ethereum", 
        limit: int = 100,
        next_cursor: Optional[str] = None
    ) -> Dict[str, Any]:
        """检索带分页的NFT藏品。"""
        params = {"chain": chain, "limit": min(limit, 100)}
        if next_cursor:
            params["next"] = next_cursor
        
        return self._request("GET", "/collections", params=params)
    
    def get_collection_stats(self, collection_slug: str) -> Dict[str, Any]:
        """获取地板价、交易量和供应量统计。"""
        return self._request("GET", f"/collections/{collection_slug}/stats")
    
    def get_nft(
        self, 
        chain: str, 
        contract_address: str, 
        token_id: str
    ) -> Dict[str, Any]:
        """获取特定NFT的详细信息。"""
        endpoint = f"/chain/{chain}/contract/{contract_address}/nfts/{token_id}"
        return self._request("GET", endpoint)
    
    def get_listings(
        self, 
        chain: str, 
        contract_address: str, 
        token_id: str,
        limit: int = 50
    ) -> List[Dict[str, Any]]:
        """获取特定NFT的活跃上架。"""
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
        """获取价格最低的活跃上架。"""
        listings = self.get_listings(chain, contract_address, token_id, limit=1)
        return listings[0] if listings else None


# 初始化SDK
sdk = OpenSeaAPI()

# 获取藏品统计
stats = sdk.get_collection_stats("boredapeyachtclub")
print(f"地板价: {stats['total']['floor_price']}")
print(f"交易量: {stats['total']['volume']}")
```

---

## 程序化上架、购买和出售NFT

程序化交易是OpenSea API最强大的功能。您可以上架NFT销售、接受报价，并完全通过代码完成订单。

### 创建上架

要上架NFT，您需要创建一个Seaport订单。这需要使用所有者的私钥对订单进行签名：

```python
from web3 import Web3

# 连接到以太坊节点
w3 = Web3(Web3.HTTPProvider("https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY"))

# 构建上架参数
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
                "startAmount": "1000000000000000000",  # wei单位的1 ETH
                "endAmount": "1000000000000000000",
                "recipient": "0xYourWalletAddress"
            },
            {
                "itemType": 0,
                "token": "0x0000000000000000000000000000000000000000",
                "identifierOrCriteria": "0",
                "startAmount": "25000000000000000",  # 2.5%手续费
                "endAmount": "25000000000000000",
                "recipient": "0x0000a26b00c1F0DF003000390027140000fAa719"  # OpenSea手续费
            }
        ],
        "orderType": 0,
        "startTime": int(time.time()),
        "endTime": int(time.time()) + 86400 * 7,  # 7天
        "zoneHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "salt": "0x" + os.urandom(32).hex(),
        "conduitKey": "0x0000007b02230091a7ed01230072f7006a004d60a8d4e71d599b8104250f0000",
        "totalOriginalConsiderationItems": 2
    },
    "signature": "0x..."  # 使用所有者私钥签名
}

# 提交订单到OpenSea
response = requests.post(
    f"{BASE_URL}/orders/ethereum/seaport/listings",
    headers=headers,
    json=listing_data
)
print(f"上架创建: {response.status_code}")
```

### 完成订单（购买NFT）

要购买已上架的NFT，检索订单并提交完成交易：

```python
def fulfill_order(order_hash: str, buyer_address: str):
    """完成现有订单以购买NFT。"""
    # 获取订单详情
    order_response = requests.get(
        f"{BASE_URL}/orders/ethereum/seaport/{order_hash}",
        headers=headers
    )
    order = order_response.json()
    
    # 构建完成交易
    fulfillment_data = {
        "order_hash": order_hash,
        "fulfiller": buyer_address,
        "offer": order["protocol_data"]["parameters"]["offer"],
        "consideration": order["protocol_data"]["parameters"]["consideration"]
    }
    
    # 提交到Seaport合约
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

# 购买最便宜的上架物品
cheapest = min(listings, key=lambda x: float(x["price"]))
tx = fulfill_order(cheapest["order_hash"], "0xBuyerWalletAddress")
```

### 批量操作

对于高频交易，使用批量端点处理多个操作：

```python
def batch_get_listings(requests_list: List[Dict]) -> List[Dict]:
    """在单个请求中获取多个上架。"""
    response = requests.post(
        f"{BASE_URL}/listings/batch",
        headers=headers,
        json={"requests": requests_list}
    )
    return response.json()["results"]

# 批量请求多个藏品
collections = ["boredapeyachtclub", "cryptopunks", "azuki"]
requests_list = [{"collection": c, "limit": 5} for c in collections]
batch_results = batch_get_listings(requests_list)
```

---

## 使用WebSocket进行实时事件流

OpenSea WebSocket API支持实时监控市场事件。这对于需要即时更新的交易机器人、通知系统和分析平台至关重要。

### WebSocket连接设置

```python
import json
import asyncio
import websockets

class OpenSeaStreamClient:
    """用于实时OpenSea事件流的WebSocket客户端。"""
    
    WS_URL = "wss://stream.opensea.io/socket"
    
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.subscriptions = []
        self.running = False
    
    async def connect(self):
        """建立带身份验证的WebSocket连接。"""
        self.ws = await websockets.connect(
            self.WS_URL,
            extra_headers={"X-API-KEY": self.api_key}
        )
        logger.info("WebSocket已连接")
    
    async def subscribe(self, event_type: str, filters: dict = None):
        """订阅特定事件流。"""
        payload = {
            "topic": event_type,
            "filters": filters or {}
        }
        await self.ws.send(json.dumps({
            "method": "SUBSCRIBE",
            "params": [payload]
        }))
        logger.info(f"已订阅: {event_type}")
    
    async def listen(self, callback):
        """监听传入事件。"""
        self.running = True
        while self.running:
            try:
                message = await self.ws.recv()
                data = json.loads(message)
                await callback(data)
            except websockets.exceptions.ConnectionClosed:
                logger.warning("连接关闭，重新连接...")
                await self.connect()
                for sub in self.subscriptions:
                    await self.subscribe(sub["type"], sub.get("filters"))
    
    async def disconnect(self):
        """关闭WebSocket连接。"""
        self.running = False
        await self.ws.close()


# 事件处理器
async def handle_event(event: dict):
    """处理传入的市场事件。"""
    event_type = event.get("event_type")
    payload = event.get("payload", {})
    
    if event_type == "item_listed":
        print(f"[上架] {payload['name']} 价格 {payload['base_price']} ETH")
    elif event_type == "item_sold":
        print(f"[售出] {payload['name']} 以 {payload['sale_price']} ETH")
    elif event_type == "item_cancelled":
        print(f"[取消] {payload['name']}")
    elif event_type == "collection_offer":
        print(f"[报价] {payload['collection_slug']} 的藏品报价")


# 运行事件流
async def main():
    client = OpenSeaStreamClient(api_key=API_KEY)
    await client.connect()
    
    # 订阅事件
    await client.subscribe("item_listed", {"collection_slug": "boredapeyachtclub"})
    await client.subscribe("item_sold", {"collection_slug": "boredapeyachtclub"})
    
    # 开始监听
    await client.listen(handle_event)

# asyncio.run(main())
```

### 事件类型参考

WebSocket API支持多种事件类型以满足不同用例：

```python
# 可用事件类型
EVENT_TYPES = {
    "item_listed": "新上架创建",
    "item_sold": "物品已购买",
    "item_cancelled": "上架已取消",
    "item_received_bid": "新出价",
    "item_received_offer": "新报价",
    "collection_offer": "全藏品报价",
    "trait_offer": "特定特征报价",
    "item_metadata_updated": "NFT元数据已刷新",
    "item_transfer": "代币已转账"
}
```

---

## 速率限制与最佳实践

理解速率限制对于生产应用至关重要。超过限制会导致临时封禁，可能中断交易操作。

### 速率限制等级

| 等级 | 每秒请求数 | 突发限制 | 使用场景 |
|------|-----------|---------|---------|
| 免费 | 1 | 5 | 开发、测试 |
| 开发者 | 10 | 50 | 小型应用 |
| 专业版 | 40 | 200 | 交易机器人、分析 |
| 企业版 | 120+ | 600+ | 高频交易 |

### 速率限制响应头

每个API响应都包含速率限制头：

```python
def check_rate_limits(response: requests.Response):
    """提取和监控速率限制状态。"""
    limit = response.headers.get("X-RateLimit-Limit")
    remaining = response.headers.get("X-RateLimit-Remaining")
    reset = response.headers.get("X-RateLimit-Reset")
    
    print(f"速率限制: {remaining}/{limit}")
    print(f"重置时间: {reset} 秒")
    
    # 如果接近限制则警告
    if int(remaining) < 10:
        logger.warning(f"接近速率限制！剩余 {remaining} 次请求")
    
    return {
        "limit": int(limit) if limit else None,
        "remaining": int(remaining) if remaining else None,
        "reset": int(reset) if reset else None
    }

# 应用到每次请求
response = requests.get(f"{BASE_URL}/collections", headers=headers)
limits = check_rate_limits(response)
```

### 实现退避策略

```python
import random

class AdaptiveRateLimiter:
    """带指数退避的自适应速率限制器。"""
    
    def __init__(self, base_delay: float = 1.0, max_delay: float = 60.0):
        self.base_delay = base_delay
        self.max_delay = max_delay
        self.current_delay = base_delay
        self.consecutive_errors = 0
    
    def wait(self):
        """使用自适应延迟等待。"""
        jitter = random.uniform(0, 0.5)
        time.sleep(self.current_delay + jitter)
    
    def on_success(self):
        """成功请求后减少延迟。"""
        self.consecutive_errors = 0
        self.current_delay = max(self.base_delay, self.current_delay * 0.8)
    
    def on_error(self, status_code: int):
        """错误后增加延迟。"""
        self.consecutive_errors += 1
        if status_code == 429:
            self.current_delay = min(
                self.max_delay,
                self.current_delay * 2 ** self.consecutive_errors
            )
            logger.warning(f"速率受限。退避: {self.current_delay}秒")


# 在请求循环中使用
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

### 缓存策略

```python
from functools import lru_cache
from datetime import datetime, timedelta

class OpenSeaCache:
    """用于API响应的简单TTL缓存。"""
    
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

# 缓存藏品元数据（很少变化）
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

## 构建交易机器人：完整示例

以下是一个监控藏品地板价差异的套利嗅探交易机器人的完整示例：

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
    """使用OpenSea API的简单套利检测机器人。"""
    
    def __init__(self, api: OpenSeaAPI, min_profit_pct: float = 15.0):
        self.api = api
        self.min_profit_pct = min_profit_pct
        self.watchlist = []
        self.callbacks: List[Callable] = []
    
    def add_collection(self, collection_slug: str, floor_threshold: float):
        """添加藏品的观察列表。"""
        self.watchlist.append({
            "slug": collection_slug,
            "threshold": floor_threshold
        })
    
    def on_opportunity(self, callback: Callable):
        """注册套利机会的回调。"""
        self.callbacks.append(callback)
    
    def analyze_collection(self, collection: dict) -> List[ArbitrageOpportunity]:
        """扫描藏品中的低价上架。"""
        slug = collection["slug"]
        
        # 获取地板价和活跃上架
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
            
            # 检查是否显著低于地板价
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
                
                # 通知回调
                for cb in self.callbacks:
                    cb(opp)
        
        return opportunities
    
    def run(self, interval: int = 30):
        """以指定检查间隔运行机器人。"""
        logger.info(f"启动机器人，监控 {len(self.watchlist)} 个藏品")
        
        try:
            while True:
                for collection in self.watchlist:
                    try:
                        opps = self.analyze_collection(collection)
                        if opps:
                            logger.info(f"在 {collection['slug']} 中发现 {len(opps)} 个机会")
                    except Exception as e:
                        logger.error(f"分析 {collection['slug']} 时出错: {e}")
                
                time.sleep(interval)
        except KeyboardInterrupt:
            logger.info("用户停止机器人")


# 使用示例
def notify_discord(opp: ArbitrageOpportunity):
    """发送Discord通知。"""
    message = f"""
    **套利警报！**
    藏品: {opp.collection}
    代币: #{opp.token_id}
    上架价: {opp.listed_price:.4f} ETH
    地板价: {opp.estimated_value:.4f} ETH
    利润: {opp.profit_margin:.1f}%
    [查看上架]({opp.listing_url})
    """
    # send_to_discord_webhook(message)

bot = NFTArbitrageBot(sdk, min_profit_pct=20.0)
bot.add_collection("boredapeyachtclub", floor_threshold=30.0)
bot.add_collection("azuki", floor_threshold=10.0)
bot.on_opportunity(notify_discord)
# bot.run(interval=60)
```

---

## 错误处理与调试

生产应用需要强大的错误处理。OpenSea API返回结构化的错误响应：

```python
class OpenSeaAPIError(Exception):
    """OpenSea API错误的自定义异常。"""
    
    def __init__(self, message: str, status_code: int = None, response_data: dict = None):
        super().__init__(message)
        self.status_code = status_code
        self.response_data = response_data or {}

def handle_api_error(response: requests.Response):
    """解析并引发适当的异常。"""
    try:
        error_data = response.json()
    except ValueError:
        error_data = {"message": response.text}
    
    error_map = {
        400: ("错误请求", ValueError),
        401: ("未授权 - 检查API密钥", PermissionError),
        403: ("禁止 - 权限不足", PermissionError),
        404: ("资源未找到", KeyError),
        429: ("超出速率限制", TimeoutError),
        500: ("内部服务器错误", RuntimeError),
        503: ("服务不可用", ConnectionError)
    }
    
    error_msg, error_class = error_map.get(
        response.status_code, 
        (f"HTTP {response.status_code}", RuntimeError)
    )
    
    detail = error_data.get("message", error_data.get("detail", "未知错误"))
    raise error_class(f"{error_msg}: {detail}")

# 在SDK中应用
class RobustOpenSeaAPI(OpenSeaAPI):
    def _request(self, method: str, endpoint: str, **kwargs):
        response = self.session.request(method, self.BASE_URL + endpoint, **kwargs)
        if not response.ok:
            handle_api_error(response)
        return response.json()
```

---

## 常见问题解答

### 如何获取OpenSea API密钥？

访问[OpenSea开发者仪表板](https://docs.opensea.io/reference/api-keys)，使用您的钱包登录，完成开发者申请。批准通常需要1-3个工作日。您需要描述您的用例并同意API服务条款。企业级密钥需要额外的验证和直接的合作协议。

### OpenSea API的速率限制是多少？

速率限制取决于您的API等级。免费等级允许每秒1个请求，突发限制为5。开发者等级提高到每秒10个请求，突发限制为50。专业等级支持每秒40个请求，突发限制为200。企业等级为高频交易应用提供每秒120+个请求。检查每个响应中的`X-RateLimit-*`头以监控您的使用情况。

### 我可以通过API买卖NFT吗？

是的，API支持完整的程序化交易。您可以创建上架、接受报价，并完全通过API完成订单。但是，您需要拥有NFT的钱包的私钥。所有交易都通过Seaport协议执行，需要链上签名和Gas费用。

### OpenSea API支持哪些区块链？

截至2026年，OpenSea API支持以太坊主网、Polygon（PoS和zkEVM）、Arbitrum One、Optimism、Base、Zora和Sepolia测试网。每条链都有自己的端点前缀（例如`/chain/ethereum/`、`/chain/polygon/`）。跨链聚合端点允许同时查询多个网络。

### OpenSea有官方Python SDK吗？

OpenSea没有官方Python SDK。官方SDK是[opensea-js](https://github.com/ProjectOpenSea/opensea-js)（JavaScript/TypeScript）。但是，存在几个社区维护的Python包，您也可以使用`requests`库轻松构建自己的集成，如本指南中所示。REST API文档完善，遵循标准约定。

### 如何流式传输实时事件？

使用WebSocket API，地址为`wss://stream.opensea.io/socket`。订阅`item_listed`、`item_sold`和`item_cancelled`等事件类型，并可选按藏品筛选。WebSocket连接需要在`X-API-KEY`头中提供您的API密钥。为生产可靠性实现重新连接逻辑。

### 什么是Seaport协议？

Seaport是OpenSea的去中心化NFT交易协议。它是一个处理订单匹配、完成和费用分配的开源智能合约标准。当您通过API创建或完成订单时，您正在与链上的Seaport合约交互。该协议支持基于条件的订单、部分填充和批量执行等高级功能。

---



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 结论

OpenSea API是2026年最全面且经过实战检验的NFT市场API。凭借对多个区块链的支持、实时WebSocket流和完整的程序化交易功能，它为开发者构建复杂的NFT应用提供了所需的一切。

本指南的关键要点：

- **身份验证**：从开发者仪表板获取您的API密钥，并始终使用环境变量
- **SDK策略**：使用官方JavaScript SDK或构建带有重试逻辑的自定义Python封装
- **交易**：理解Seaport订单创建和完成以进行程序化买卖
- **实时**：利用WebSocket流进行即时事件通知
- **速率限制**：实施自适应退避和缓存以保持在等级限制内
- **错误处理**：为生产可靠性构建强大的错误处理

无论您是在构建简单的投资组合追踪器还是高频交易机器人，OpenSea API都提供了与全球最大的NFT市场进行程序化交互所需的基础设施。从本指南中的示例开始，监控您的速率限制，并随着需求的增长扩展您的应用。

---

*本文撰写于2026-05-19。API规范和速率限制可能会发生变化。请参阅[官方OpenSea文档](https://docs.opensea.io/)获取最新更新。*
