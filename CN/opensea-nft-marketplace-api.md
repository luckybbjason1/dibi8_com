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
- /posts/opensea-nft-marketplace-api/
---

{{</* resource-info */>}}

The non-fungible token (NFT) ecosystem has matured significantly since its explosive growth in 2021. What began as a niche market for digital art has evolved into a multi-billion dollar infrastructure layer spanning gaming, real estate, identity, and decentralized finance. At the center of this transformation stands [OpenSea](https://opensea.io/), the world's largest NFT marketplace, and its powerful [OpenSea API](https://docs.opensea.io/reference/api-overview) that enables developers to build programmatic trading systems, analytics dashboards, and automated collection management tools.

In this comprehensive 2026 guide, we will explore everything you need to know about the OpenSea API: from obtaining your API key and setting up the Python SDK to listing NFTs, executing trades, streaming real-time events via WebSocket, and handling rate limits in production environments. Whether you are building a trading bot, a portfolio tracker, or a marketplace aggregator, this guide provides the complete technical foundation.

---

## What Is the OpenSea API?

The OpenSea API is a RESTful and WebSocket-based programming interface that provides full access to the OpenSea NFT marketplace. It allows developers to query NFT collections, retrieve asset metadata, list items for sale, fulfill orders, track account activity, and subscribe to real-time event streams — all without manually interacting with the OpenSea website.

As of 2026, the OpenSea API supports multiple blockchain networks including Ethereum, Polygon, Arbitrum, Optimism, Base, and Zora. The API is maintained by [ProjectOpenSea](https://github.com/ProjectOpenSea) and has become the de facto standard for NFT marketplace integration, with over **1,200 GitHub stars** on its official JavaScript SDK repository and an active developer community contributing wrappers for Python, Go, and Rust.

The API follows modern REST conventions with JSON request/response formats, uses API key-based authentication, and implements standard HTTP status codes for error handling. For real-time applications, the WebSocket API provides event streaming for trades, listings, transfers, and collection updates with sub-second latency.

---

## Getting Started: API Key Setup and Authentication

Before making any API calls, you need to register for an API key through the OpenSea Developer Portal. The API key is required for all authenticated endpoints and determines your rate limit tier.

### Step 1: Create a Developer Account

Visit the [OpenSea Developer Dashboard](https://docs.opensea.io/reference/api-keys) and sign in with your wallet or email address. Complete the developer verification process, which includes agreeing to the API terms of service and providing a brief description of your intended use case.

### Step 2: Generate Your API Key

Once approved, create a new API key from the dashboard. You will receive two credentials:

- **API Key**: Used for identifying your application
- **API Secret**: Used for signing certain authenticated requests

Store these credentials securely in environment variables:

```bash
# .env file
OPENSEA_API_KEY=your_api_key_here
OPENSEA_API_SECRET=your_api_secret_here
```

### Step 3: Test Your Authentication

Verify your API key is working with a simple health check:

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

# Test authentication by fetching collections
response = requests.get(
    f"{BASE_URL}/collections",
    headers=headers,
    params={"chain": "ethereum", "limit": 5}
)

print(f"Status: {response.status_code}")
print(f"Collections: {len(response.json()['collections'])}")
```

### Step 4: SDK Installation

Install the official JavaScript SDK or a community Python wrapper:

```bash
# Official JavaScript SDK
npm install opensea-js

# Python community SDK
pip install opensea-api

# Or use requests directly
pip install requests python-dotenv
```

---

## OpenSea API Endpoints Overview

The OpenSea API is organized into logical endpoint groups covering every aspect of the NFT marketplace. Understanding these endpoint categories is essential for building efficient applications.

### Collections and Metadata Endpoints

Collection endpoints provide comprehensive metadata about NFT collections, including floor prices, volume statistics, trait distributions, and social links.

```python
def get_collection_details(collection_slug: str):
    """Fetch detailed information about an NFT collection."""
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

# Example usage
crypto_punks = get_collection_details("cryptopunks")
print(f"CryptoPunks floor: {crypto_punks['floor_price']} ETH")
```

### Asset Querying Endpoints

Asset endpoints allow you to retrieve individual NFT metadata, ownership information, and listing status.

```python
def get_asset_details(chain: str, address: str, token_id: str):
    """Retrieve metadata for a specific NFT asset."""
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

# Fetch a specific Bored Ape
bored_ape = get_asset_details(
    chain="ethereum",
    address="0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D",
    token_id="1234"
)
print(f"Asset: {bored_ape['name']}")
print(f"Traits count: {len(bored_ape['traits'])}")
```

### Listing and Order Endpoints

Listing endpoints manage the creation, retrieval, and cancellation of NFT sell orders. These are the core endpoints for programmatic trading.

```python
def get_listings_by_collection(collection_slug: str, limit: int = 20):
    """Get active listings for a specific collection."""
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

# Get cheapest listings
listings = get_listings_by_collection("boredapeyachtclub", limit=10)
for listing in sorted(listings, key=lambda x: float(x["price"])):
    print(f"Price: {listing['price']} | Token: {listing['token']['identifier']}")
```

### Account and Activity Endpoints

Track wallet activity, owned assets, and historical events for any Ethereum address.

```python
def get_account_events(account_address: str, event_type: str = "order", limit: int = 50):
    """Retrieve activity events for a specific account."""
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

# Monitor whale wallet activity
whale_address = "0x3b417faee9d1458e"
events = get_account_events(whale_address, event_type="sale", limit=20)
for event in events:
    print(f"{event['timestamp']}: {event['asset']} sold for {event['payment']}")
```

---

## Building a Python SDK Integration

While the official OpenSea SDK is written in JavaScript/TypeScript, Python developers can build robust integrations using the `requests` library or community-maintained packages. Here is a production-ready Python SDK wrapper that handles authentication, pagination, error retries, and rate limiting.

### Complete Python SDK Class

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
    """Production-ready Python SDK for the OpenSea API."""
    
    BASE_URL = "https://api.opensea.io/api/v2"
    
    def __init__(self, api_key: Optional[str] = None, max_retries: int = 3):
        self.api_key = api_key or os.getenv("OPENSEA_API_KEY")
        if not self.api_key:
            raise ValueError("API key required. Set OPENSEA_API_KEY environment variable.")
        
        self.session = requests.Session()
        self.session.headers.update({
            "X-API-KEY": self.api_key,
            "Accept": "application/json",
            "Content-Type": "application/json"
        })
        
        # Configure retry strategy
        retry_strategy = Retry(
            total=max_retries,
            backoff_factor=1,
            status_forcelist=[429, 500, 502, 503, 504],
        )
        adapter = HTTPAdapter(max_retries=retry_strategy)
        self.session.mount("https://", adapter)
    
    def _request(self, method: str, endpoint: str, **kwargs) -> Dict[str, Any]:
        """Make an authenticated request with rate limit handling."""
        url = urljoin(self.BASE_URL, endpoint)
        
        try:
            response = self.session.request(method, url, **kwargs)
            
            # Handle rate limiting
            if response.status_code == 429:
                reset_time = int(response.headers.get("X-RateLimit-Reset", 60))
                logger.warning(f"Rate limited. Waiting {reset_time} seconds...")
                time.sleep(reset_time)
                response = self.session.request(method, url, **kwargs)
            
            response.raise_for_status()
            return response.json()
            
        except requests.exceptions.RequestException as e:
            logger.error(f"Request failed: {e}")
            raise
    
    def get_collections(
        self, 
        chain: str = "ethereum", 
        limit: int = 100,
        next_cursor: Optional[str] = None
    ) -> Dict[str, Any]:
        """Retrieve NFT collections with pagination."""
        params = {"chain": chain, "limit": min(limit, 100)}
        if next_cursor:
            params["next"] = next_cursor
        
        return self._request("GET", "/collections", params=params)
    
    def get_collection_stats(self, collection_slug: str) -> Dict[str, Any]:
        """Get floor price, volume, and supply statistics."""
        return self._request("GET", f"/collections/{collection_slug}/stats")
    
    def get_nft(
        self, 
        chain: str, 
        contract_address: str, 
        token_id: str
    ) -> Dict[str, Any]:
        """Fetch a specific NFT's details."""
        endpoint = f"/chain/{chain}/contract/{contract_address}/nfts/{token_id}"
        return self._request("GET", endpoint)
    
    def get_listings(
        self, 
        chain: str, 
        contract_address: str, 
        token_id: str,
        limit: int = 50
    ) -> List[Dict[str, Any]]:
        """Get active listings for a specific NFT."""
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
        """Get the lowest-priced active listing."""
        listings = self.get_listings(chain, contract_address, token_id, limit=1)
        return listings[0] if listings else None


# Initialize SDK
sdk = OpenSeaAPI()

# Fetch collection stats
stats = sdk.get_collection_stats("boredapeyachtclub")
print(f"Floor: {stats['total']['floor_price']}")
print(f"Volume: {stats['total']['volume']}")
```

---

## Listing, Buying, and Selling NFTs Programmatically

Programmatic trading is the most powerful feature of the OpenSea API. You can list NFTs for sale, accept offers, and fulfill orders entirely through code.

### Creating a Listing

To list an NFT, you need to create a Seaport order. This requires signing the order with the owner's private key:

```python
from web3 import Web3

# Connect to Ethereum node
w3 = Web3(Web3.HTTPProvider("https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY"))

# Build listing parameters
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
                "startAmount": "1000000000000000000",  # 1 ETH in wei
                "endAmount": "1000000000000000000",
                "recipient": "0xYourWalletAddress"
            },
            {
                "itemType": 0,
                "token": "0x0000000000000000000000000000000000000000",
                "identifierOrCriteria": "0",
                "startAmount": "25000000000000000",  # 2.5% fee
                "endAmount": "25000000000000000",
                "recipient": "0x0000a26b00c1F0DF003000390027140000fAa719"  # OpenSea fee
            }
        ],
        "orderType": 0,
        "startTime": int(time.time()),
        "endTime": int(time.time()) + 86400 * 7,  # 7 days
        "zoneHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "salt": "0x" + os.urandom(32).hex(),
        "conduitKey": "0x0000007b02230091a7ed01230072f7006a004d60a8d4e71d599b8104250f0000",
        "totalOriginalConsiderationItems": 2
    },
    "signature": "0x..."  # Signed with owner's private key
}

# Submit order to OpenSea
response = requests.post(
    f"{BASE_URL}/orders/ethereum/seaport/listings",
    headers=headers,
    json=listing_data
)
print(f"Listing created: {response.status_code}")
```

### Fulfilling an Order (Buying an NFT)

To purchase a listed NFT, retrieve the order and submit a fulfillment transaction:

```python
def fulfill_order(order_hash: str, buyer_address: str):
    """Fulfill an existing order to purchase an NFT."""
    # Get order details
    order_response = requests.get(
        f"{BASE_URL}/orders/ethereum/seaport/{order_hash}",
        headers=headers
    )
    order = order_response.json()
    
    # Build fulfillment transaction
    fulfillment_data = {
        "order_hash": order_hash,
        " fulfiller": buyer_address,
        "offer": order["protocol_data"]["parameters"]["offer"],
        "consideration": order["protocol_data"]["parameters"]["consideration"]
    }
    
    # Submit to Seaport contract
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

# Buy the cheapest listed item
cheapest = min(listings, key=lambda x: float(x["price"]))
tx = fulfill_order(cheapest["order_hash"], "0xBuyerWalletAddress")
```

### Batch Operations

For high-frequency trading, use batch endpoints to process multiple operations:

```python
def batch_get_listings(requests_list: List[Dict]) -> List[Dict]:
    """Fetch multiple listings in a single request."""
    response = requests.post(
        f"{BASE_URL}/listings/batch",
        headers=headers,
        json={"requests": requests_list}
    )
    return response.json()["results"]

# Batch request multiple collections
collections = ["boredapeyachtclub", "cryptopunks", "azuki"]
requests_list = [{"collection": c, "limit": 5} for c in collections]
batch_results = batch_get_listings(requests_list)
```

---

## Real-Time Event Streaming with WebSocket

The OpenSea WebSocket API enables real-time monitoring of marketplace events. This is essential for trading bots, notification systems, and analytics platforms that need instant updates.

### WebSocket Connection Setup

```python
import json
import asyncio
import websockets

class OpenSeaStreamClient:
    """WebSocket client for real-time OpenSea event streaming."""
    
    WS_URL = "wss://stream.opensea.io/socket"
    
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.subscriptions = []
        self.running = False
    
    async def connect(self):
        """Establish WebSocket connection with authentication."""
        self.ws = await websockets.connect(
            self.WS_URL,
            extra_headers={"X-API-KEY": self.api_key}
        )
        logger.info("WebSocket connected")
    
    async def subscribe(self, event_type: str, filters: dict = None):
        """Subscribe to a specific event stream."""
        payload = {
            "topic": event_type,
            "filters": filters or {}
        }
        await self.ws.send(json.dumps({
            "method": "SUBSCRIBE",
            "params": [payload]
        }))
        logger.info(f"Subscribed to: {event_type}")
    
    async def listen(self, callback):
        """Listen for incoming events."""
        self.running = True
        while self.running:
            try:
                message = await self.ws.recv()
                data = json.loads(message)
                await callback(data)
            except websockets.exceptions.ConnectionClosed:
                logger.warning("Connection closed, reconnecting...")
                await self.connect()
                for sub in self.subscriptions:
                    await self.subscribe(sub["type"], sub.get("filters"))
    
    async def disconnect(self):
        """Close WebSocket connection."""
        self.running = False
        await self.ws.close()


# Event handler
async def handle_event(event: dict):
    """Process incoming marketplace events."""
    event_type = event.get("event_type")
    payload = event.get("payload", {})
    
    if event_type == "item_listed":
        print(f"[LISTED] {payload['name']} at {payload['base_price']} ETH")
    elif event_type == "item_sold":
        print(f"[SOLD] {payload['name']} for {payload['sale_price']} ETH")
    elif event_type == "item_cancelled":
        print(f"[CANCELLED] {payload['name']}")
    elif event_type == "collection_offer":
        print(f"[OFFER] Collection offer on {payload['collection_slug']}")


# Run event stream
async def main():
    client = OpenSeaStreamClient(api_key=API_KEY)
    await client.connect()
    
    # Subscribe to events
    await client.subscribe("item_listed", {"collection_slug": "boredapeyachtclub"})
    await client.subscribe("item_sold", {"collection_slug": "boredapeyachtclub"})
    
    # Start listening
    await client.listen(handle_event)

# asyncio.run(main())
```

### Event Types Reference

The WebSocket API supports multiple event types for different use cases:

```python
# Available event types
EVENT_TYPES = {
    "item_listed": "New listing created",
    "item_sold": "Item purchased",
    "item_cancelled": "Listing cancelled",
    "item_received_bid": "New bid placed",
    "item_received_offer": "New offer received",
    "collection_offer": "Collection-wide offer",
    "trait_offer": "Trait-specific offer",
    "item_metadata_updated": "NFT metadata refreshed",
    "item_transfer": "Token transferred"
}
```

---

## Rate Limiting and Best Practices

Understanding rate limits is critical for production applications. Exceeding limits results in temporary bans that can disrupt trading operations.

### Rate Limit Tiers

| Tier | Requests/Second | Burst Limit | Use Case |
|------|----------------|-------------|----------|
| Free | 1 | 5 | Development, testing |
| Developer | 10 | 50 | Small applications |
| Professional | 40 | 200 | Trading bots, analytics |
| Enterprise | 120+ | 600+ | High-frequency trading |

### Rate Limit Headers

Every API response includes rate limit headers:

```python
def check_rate_limits(response: requests.Response):
    """Extract and monitor rate limit status."""
    limit = response.headers.get("X-RateLimit-Limit")
    remaining = response.headers.get("X-RateLimit-Remaining")
    reset = response.headers.get("X-RateLimit-Reset")
    
    print(f"Rate Limit: {remaining}/{limit}")
    print(f"Resets in: {reset} seconds")
    
    # Warning if approaching limit
    if int(remaining) < 10:
        logger.warning(f"Approaching rate limit! {remaining} requests remaining")
    
    return {
        "limit": int(limit) if limit else None,
        "remaining": int(remaining) if remaining else None,
        "reset": int(reset) if reset else None
    }

# Apply to every request
response = requests.get(f"{BASE_URL}/collections", headers=headers)
limits = check_rate_limits(response)
```

### Implementing Backoff Strategies

```python
import random

class AdaptiveRateLimiter:
    """Adaptive rate limiter with exponential backoff."""
    
    def __init__(self, base_delay: float = 1.0, max_delay: float = 60.0):
        self.base_delay = base_delay
        self.max_delay = max_delay
        self.current_delay = base_delay
        self.consecutive_errors = 0
    
    def wait(self):
        """Wait with adaptive delay."""
        jitter = random.uniform(0, 0.5)
        time.sleep(self.current_delay + jitter)
    
    def on_success(self):
        """Reduce delay after successful request."""
        self.consecutive_errors = 0
        self.current_delay = max(self.base_delay, self.current_delay * 0.8)
    
    def on_error(self, status_code: int):
        """Increase delay after error."""
        self.consecutive_errors += 1
        if status_code == 429:
            self.current_delay = min(
                self.max_delay,
                self.current_delay * 2 ** self.consecutive_errors
            )
            logger.warning(f"Rate limited. Backoff: {self.current_delay}s")


# Usage in request loop
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

### Caching Strategies

```python
from functools import lru_cache
from datetime import datetime, timedelta

class OpenSeaCache:
    """Simple TTL cache for API responses."""
    
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

# Cache collection metadata (rarely changes)
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

## Building a Trading Bot: Complete Example

Here is a complete example of an arbitrage-sniffing trading bot that monitors floor prices across collections:

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
    """Simple arbitrage detection bot using OpenSea API."""
    
    def __init__(self, api: OpenSeaAPI, min_profit_pct: float = 15.0):
        self.api = api
        self.min_profit_pct = min_profit_pct
        self.watchlist = []
        self.callbacks: List[Callable] = []
    
    def add_collection(self, collection_slug: str, floor_threshold: float):
        """Add a collection to the watchlist."""
        self.watchlist.append({
            "slug": collection_slug,
            "threshold": floor_threshold
        })
    
    def on_opportunity(self, callback: Callable):
        """Register callback for arbitrage opportunities."""
        self.callbacks.append(callback)
    
    def analyze_collection(self, collection: dict) -> List[ArbitrageOpportunity]:
        """Scan collection for underpriced listings."""
        slug = collection["slug"]
        threshold = collection["threshold"]
        
        # Get floor price and active listings
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
            
            # Check if significantly below floor
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
                
                # Notify callbacks
                for cb in self.callbacks:
                    cb(opp)
        
        return opportunities
    
    def run(self, interval: int = 30):
        """Run the bot with specified check interval."""
        logger.info(f"Starting bot with {len(self.watchlist)} collections")
        
        try:
            while True:
                for collection in self.watchlist:
                    try:
                        opps = self.analyze_collection(collection)
                        if opps:
                            logger.info(f"Found {len(opps)} opportunities in {collection['slug']}")
                    except Exception as e:
                        logger.error(f"Error analyzing {collection['slug']}: {e}")
                
                time.sleep(interval)
        except KeyboardInterrupt:
            logger.info("Bot stopped by user")


# Usage example
def notify_discord(opp: ArbitrageOpportunity):
    """Send Discord notification for opportunity."""
    message = f"""
    **Arbitrage Alert!**
    Collection: {opp.collection}
    Token: #{opp.token_id}
    Listed: {opp.listed_price:.4f} ETH
    Floor: {opp.estimated_value:.4f} ETH
    Profit: {opp.profit_margin:.1f}%
    [View Listing]({opp.listing_url})
    """
    # send_to_discord_webhook(message)

bot = NFTArbitrageBot(sdk, min_profit_pct=20.0)
bot.add_collection("boredapeyachtclub", floor_threshold=30.0)
bot.add_collection("azuki", floor_threshold=10.0)
bot.on_opportunity(notify_discord)
# bot.run(interval=60)
```

---

## Error Handling and Debugging

Production applications require robust error handling. The OpenSea API returns structured error responses:

```python
class OpenSeaAPIError(Exception):
    """Custom exception for OpenSea API errors."""
    
    def __init__(self, message: str, status_code: int = None, response_data: dict = None):
        super().__init__(message)
        self.status_code = status_code
        self.response_data = response_data or {}

def handle_api_error(response: requests.Response):
    """Parse and raise appropriate exceptions."""
    try:
        error_data = response.json()
    except ValueError:
        error_data = {"message": response.text}
    
    error_map = {
        400: ("Bad Request", ValueError),
        401: ("Unauthorized - Check API key", PermissionError),
        403: ("Forbidden - Insufficient permissions", PermissionError),
        404: ("Resource not found", KeyError),
        429: ("Rate limit exceeded", TimeoutError),
        500: ("Internal server error", RuntimeError),
        503: ("Service unavailable", ConnectionError)
    }
    
    error_msg, error_class = error_map.get(
        response.status_code, 
        (f"HTTP {response.status_code}", RuntimeError)
    )
    
    detail = error_data.get("message", error_data.get("detail", "Unknown error"))
    raise error_class(f"{error_msg}: {detail}")

# Apply in SDK
class RobustOpenSeaAPI(OpenSeaAPI):
    def _request(self, method: str, endpoint: str, **kwargs):
        response = self.session.request(method, self.BASE_URL + endpoint, **kwargs)
        if not response.ok:
            handle_api_error(response)
        return response.json()
```

---

## FAQ: Frequently Asked Questions

### How do I get an OpenSea API key?

Visit the [OpenSea Developer Dashboard](https://docs.opensea.io/reference/api-keys), sign in with your wallet, and complete the developer application. Approval typically takes 1-3 business days. You will need to describe your use case and agree to the API terms of service. Enterprise-tier keys require additional verification and a direct partnership agreement.

### What are the rate limits for the OpenSea API?

Rate limits depend on your API tier. Free tier allows 1 request per second with a burst of 5. Developer tier increases this to 10 RPS with burst of 50. Professional tier supports 40 RPS with burst of 200. Enterprise tiers offer 120+ RPS for high-frequency trading applications. Check the `X-RateLimit-*` headers in every response to monitor your usage.

### Can I buy and sell NFTs through the API?

Yes, the API supports full programmatic trading. You can create listings, accept offers, and fulfill orders entirely through the API. However, you need the private key of the wallet that owns the NFTs. All transactions are executed through the Seaport protocol, which requires on-chain signatures and gas fees.

### Which blockchains does the OpenSea API support?

As of 2026, the OpenSea API supports Ethereum mainnet, Polygon (PoS and zkEVM), Arbitrum One, Optimism, Base, Zora, and Sepolia testnet. Each chain has its own endpoint prefix (e.g., `/chain/ethereum/`, `/chain/polygon/`). Cross-chain aggregation endpoints allow querying across multiple networks simultaneously.

### Is there an official Python SDK for OpenSea?

There is no official Python SDK from OpenSea. The official SDK is [opensea-js](https://github.com/ProjectOpenSea/opensea-js) (JavaScript/TypeScript). However, several community-maintained Python packages exist, and you can easily build your own integration using the `requests` library as demonstrated in this guide. The REST API is well-documented and follows standard conventions.

### How do I stream real-time events?

Use the WebSocket API at `wss://stream.opensea.io/socket`. Subscribe to event types like `item_listed`, `item_sold`, and `item_cancelled` with optional collection filters. The WebSocket connection requires your API key in the `X-API-KEY` header. Implement reconnection logic for production reliability.

### What is the Seaport protocol?

Seaport is OpenSea's decentralized NFT trading protocol. It is an open-source smart contract standard that handles order matching, fulfillment, and fee distribution. When you create or fulfill orders through the API, you are interacting with Seaport contracts on-chain. The protocol supports advanced features like criteria-based orders, partial fills, and bulk executions.

---



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Conclusion

The OpenSea API is the most comprehensive and battle-tested NFT marketplace API available in 2026. With support for multiple blockchains, real-time WebSocket streaming, and full programmatic trading capabilities, it provides everything developers need to build sophisticated NFT applications.

Key takeaways from this guide:

- **Authentication**: Obtain your API key from the Developer Dashboard and always use environment variables
- **SDK Strategy**: Use the official JavaScript SDK or build a custom Python wrapper with retry logic
- **Trading**: Understand Seaport order creation and fulfillment for programmatic buys/sells
- **Real-time**: Leverage WebSocket streams for instant event notifications
- **Rate Limits**: Implement adaptive backoff and caching to stay within your tier limits
- **Error Handling**: Build robust error handling for production reliability

Whether you are building a simple portfolio tracker or a high-frequency trading bot, the OpenSea API provides the infrastructure to interact with the world's largest NFT marketplace programmatically. Start with the examples in this guide, monitor your rate limits, and scale your application as your needs grow.

---

*This article was written on 2026-05-19. API specifications and rate limits are subject to change. Refer to the [official OpenSea documentation](https://docs.opensea.io/) for the latest updates.*
