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
- /kr/posts/opensea-nft-marketplace-api/
---

{{</* resource-info */>}}

2021년 폭발적 성장 이후 대체 불가능한 토큰(NFT) 생태계는 상당히 성숙해졌습니다. 디지털 아트 틈새 시장으로 시작했던 것이 게임, 부동산, 신원 인증, 탈중앙화 금융을 아우르는 수십억 달러 규모의 인프라 레이어로 진화했습니다. 이러한 변혁의 중심에는 세계 최대의 NFT 마켓플레이스인 [OpenSea](https://opensea.io/)와 개발자가 프로그래밍 방식 거래 시스템, 분석 대시보드, 자동화된 컬렉션 관리 도구를 구축할 수 있게 해주는 강력한 [OpenSea API](https://docs.opensea.io/reference/api-overview)가 있습니다.

이 종합적인 2026 가이드에서는 API 키 획득과 Python SDK 설정부터 NFT 상장, 거래 실행, WebSocket을 통한 실시간 이벤트 스트리밍, 프로덕션 환경의 속도 제한 처리까지 OpenSea API에 대해 알아야 할 모든 것을 살펴 보겠습니다. 트레이딩 봇, 포트폴리오 추적기 또는 마켓플레이스 애그리게이터를 구축하든 이 가이드는 완전한 기술 기초를 제공합니다.

---

## OpenSea API란 무엇인가?

OpenSea API는 OpenSea NFT 마켓플레이스에 대한 전체 액세스를 제공하는 RESTful 및 WebSocket 기반 프로그래밍 인터페이스입니다. 개발자가 NFT 컬렉션을 쿼리하고, 자산 메타데이터를 검색하고, 판매용 아이템을 상장하고, 주문을 이행하고, 계정 활동을 추적하고, 실시간 이벤트 스트림을 구독할 수 있게 해줍니다 — 이 모든 것을 OpenSea 웹사이트와 수동으로 상호작용하지 않고도 할 수 있습니다.

2026년 현재 OpenSea API는 이더리움, 폴리곤, 아비트럼, 옵티미즘, 베이스, 조라 등 여러 블록체인 네트워크를 지원합니다. 이 API는 [ProjectOpenSea](https://github.com/ProjectOpenSea)에서 유지 관리하며 공식 JavaScript SDK 저장소에서 **1,200개 이상의 GitHub 스타**를 보유하고 Python, Go, Rust용 래퍼를 기여하는 활발한 개발자 커뮤니티와 함께 NFT 마켓플레이스 통합의 사실상 표준이 되었습니다.

이 API는 현대적인 REST 규칙을 따륩니며 JSON 요청/응답 형식을 사용하고, API 키 기반 인증을 사용하며, 오류 처리를 위해 표준 HTTP 상태 코드를 구현합니다. 실시간 애플리케이션의 경우 WebSocket API는 1초 미만의 지연 시간으로 거래, 상장, 전송, 컬렉션 업데이트에 대한 이벤트 스트리밍을 제공합니다.

---

## 시작하기: API 키 설정 및 인증

API 호출을 하기 전에 OpenSea 개발자 포털을 통해 API 키를 등록해야 합니다. 모든 인증 엔드포인트에는 API 키가 필요하며, 이는 속도 제한 계층을 결정합니다.

### 1단계: 개발자 계정 만들기

[OpenSea 개발자 대시보드](https://docs.opensea.io/reference/api-keys)를 방문하여 지갑이나 이메일 주소로 로그인하세요. API 서비스 약관 동의 및 예상 사용 사례에 대한 간략한 설명 제공을 포함한 개발자 인증 절차를 완료하세요.

### 2단계: API 키 생성

승인이 되면 대시보드에서 새 API 키를 만드세요. 두 가지 자격 증명을 받게 됩니다:

- **API 키**: 애플리케이션 식별에 사용
- **API 시크릿**: 특정 인증 요청 서명에 사용

이 자격 증명을 안전하게 환경 변수에 저장하세요:

```bash
# .env 파일
OPENSEA_API_KEY=your_api_key_here
OPENSEA_API_SECRET=your_api_secret_here
```

### 3단계: 인증 테스트

간단한 헬스 체크로 API 키가 작동하는지 확인하세요:

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

# 컬렉션 가져오기로 인증 테스트
response = requests.get(
    f"{BASE_URL}/collections",
    headers=headers,
    params={"chain": "ethereum", "limit": 5}
)

print(f"상태: {response.status_code}")
print(f"컬렉션: {len(response.json()['collections'])}")
```

### 4단계: SDK 설치

공식 JavaScript SDK 또는 커뮤니티 Python 래퍼를 설치하세요:

```bash
# 공식 JavaScript SDK
npm install opensea-js

# 커뮤니티 Python SDK
pip install opensea-api

# 또는 requests 직접 사용
pip install requests python-dotenv
```

---

## OpenSea API 엔드포인트 개요

OpenSea API는 NFT 마켓플레이스의 모든 측면을 다루는 논리적 엔드포인트 그룹으로 구성되어 있습니다. 이러한 엔드포인트 카테고리를 이해하는 것은 효율적인 애플리케이션을 구축하는 데 필수적입니다.

### 컬렉션 및 메타데이터 엔드포인트

컬렉션 엔드포인트는 바닥 가격, 거래량 통계, 특성 분포, 소셜 링크를 포함한 NFT 컬렉션에 대한 포괄적인 메타데이터를 제공합니다.

```python
def get_collection_details(collection_slug: str):
    """NFT 컬렉션의 상세 정보를 가져옵니다."""
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

# 사용 예시
crypto_punks = get_collection_details("cryptopunks")
print(f"CryptoPunks 바닥: {crypto_punks['floor_price']} ETH")
```

### 자산 조회 엔드포인트

자산 엔드포인트를 통해 개별 NFT의 메타데이터, 소유권 정보, 상장 상태를 검색할 수 있습니다.

```python
def get_asset_details(chain: str, address: str, token_id: str):
    """특정 NFT 자산의 메타데이터를 검색합니다."""
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

# 특정 복싱 에이프 가져오기
bored_ape = get_asset_details(
    chain="ethereum",
    address="0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D",
    token_id="1234"
)
print(f"자산: {bored_ape['name']}")
print(f"특성 개수: {len(bored_ape['traits'])}")
```

### 상장 및 주문 엔드포인트

상장 엔드포인트는 NFT 판매 주문의 생성, 검색, 취소를 관리합니다. 이들은 프로그래밍 방식 거래의 핵심 엔드포인트입니다.

```python
def get_listings_by_collection(collection_slug: str, limit: int = 20):
    """특정 컬렉션의 활성 상장을 가져옵니다."""
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

# 가장 저렴한 상장 가져오기
listings = get_listings_by_collection("boredapeyachtclub", limit=10)
for listing in sorted(listings, key=lambda x: float(x["price"])):
    print(f"가격: {listing['price']} | 토큰: {listing['token']['identifier']}")
```

### 계정 및 활동 엔드포인트

모든 이더리움 주소의 지갑 활동, 소유 자산, 이력 이벤트를 추적합니다.

```python
def get_account_events(account_address: str, event_type: str = "order", limit: int = 50):
    """특정 계정의 활동 이벤트를 검색합니다."""
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

# 고래 지갑 활동 모니터링
whale_address = "0x3b417faee9d1458e"
events = get_account_events(whale_address, event_type="sale", limit=20)
for event in events:
    print(f"{event['timestamp']}: {event['asset']}이(가) {event['payment']}에 판매됨")
```

---

## Python SDK 통합 구축하기

공식 OpenSea SDK는 JavaScript/TypeScript로 작성되어 있지만, Python 개발자는 requests 라이브러리나 커뮤니티에서 유지 관리하는 패키지를 사용하여 강력한 통합을 구축할 수 있습니다. 다음은 인증, 페이징, 오류 재시도, 속도 제한을 처리하는 프로덕션 준비 Python SDK 래퍼입니다.

### 완전한 Python SDK 클래스

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
    """OpenSea API용 프로덕션 준비 Python SDK."""
    
    BASE_URL = "https://api.opensea.io/api/v2"
    
    def __init__(self, api_key: Optional[str] = None, max_retries: int = 3):
        self.api_key = api_key or os.getenv("OPENSEA_API_KEY")
        if not self.api_key:
            raise ValueError("API 키가 필요합니다. OPENSEA_API_KEY 환경 변수를 설정하세요.")
        
        self.session = requests.Session()
        self.session.headers.update({
            "X-API-KEY": self.api_key,
            "Accept": "application/json",
            "Content-Type": "application/json"
        })
        
        # 재시도 전략 구성
        retry_strategy = Retry(
            total=max_retries,
            backoff_factor=1,
            status_forcelist=[429, 500, 502, 503, 504],
        )
        adapter = HTTPAdapter(max_retries=retry_strategy)
        self.session.mount("https://", adapter)
    
    def _request(self, method: str, endpoint: str, **kwargs) -> Dict[str, Any]:
        """속도 제한 처리와 함께 인증된 요청을 수행합니다."""
        url = urljoin(self.BASE_URL, endpoint)
        
        try:
            response = self.session.request(method, url, **kwargs)
            
            # 속도 제한 처리
            if response.status_code == 429:
                reset_time = int(response.headers.get("X-RateLimit-Reset", 60))
                logger.warning(f"속도 제한됨. {reset_time}초 대기...")
                time.sleep(reset_time)
                response = self.session.request(method, url, **kwargs)
            
            response.raise_for_status()
            return response.json()
            
        except requests.exceptions.RequestException as e:
            logger.error(f"요청 실패: {e}")
            raise
    
    def get_collections(
        self, 
        chain: str = "ethereum", 
        limit: int = 100,
        next_cursor: Optional[str] = None
    ) -> Dict[str, Any]:
        """페이징이 있는 NFT 컬렉션을 검색합니다."""
        params = {"chain": chain, "limit": min(limit, 100)}
        if next_cursor:
            params["next"] = next_cursor
        
        return self._request("GET", "/collections", params=params)
    
    def get_collection_stats(self, collection_slug: str) -> Dict[str, Any]:
        """바닥 가격, 거래량, 공급량 통계를 가져옵니다."""
        return self._request("GET", f"/collections/{collection_slug}/stats")
    
    def get_nft(
        self, 
        chain: str, 
        contract_address: str, 
        token_id: str
    ) -> Dict[str, Any]:
        """특정 NFT의 상세 정보를 가져옵니다."""
        endpoint = f"/chain/{chain}/contract/{contract_address}/nfts/{token_id}"
        return self._request("GET", endpoint)
    
    def get_listings(
        self, 
        chain: str, 
        contract_address: str, 
        token_id: str,
        limit: int = 50
    ) -> List[Dict[str, Any]]:
        """특정 NFT의 활성 상장을 가져옵니다."""
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
        """가장 저렴한 활성 상장을 가져옵니다."""
        listings = self.get_listings(chain, contract_address, token_id, limit=1)
        return listings[0] if listings else None


# SDK 초기화
sdk = OpenSeaAPI()

# 컬렉션 통계 가져오기
stats = sdk.get_collection_stats("boredapeyachtclub")
print(f"바닥: {stats['total']['floor_price']}")
print(f"거래량: {stats['total']['volume']}")
```

---

## 프로그래밍 방식으로 NFT 상장, 구매 및 판매하기

프로그래밍 방식 거래는 OpenSea API의 가장 강력한 기능입니다. 코드를 통해 NFT를 상장하고, 오퍼를 수락하고, 주문을 이행할 수 있습니다.

### 상장 생성하기

NFT를 상장하려면 Seaport 주문을 생성해야 합니다. 이는 소유자의 개인 키로 주문에 서명해야 합니다:

```python
from web3 import Web3

# 이더리움 노드에 연결
w3 = Web3(Web3.HTTPProvider("https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY"))

# 상장 매개변수 구성
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
                "startAmount": "1000000000000000000",  # wei 단위의 1 ETH
                "endAmount": "1000000000000000000",
                "recipient": "0xYourWalletAddress"
            },
            {
                "itemType": 0,
                "token": "0x0000000000000000000000000000000000000000",
                "identifierOrCriteria": "0",
                "startAmount": "25000000000000000",  # 2.5% 수수료
                "endAmount": "25000000000000000",
                "recipient": "0x0000a26b00c1F0DF003000390027140000fAa719"  # OpenSea 수수료
            }
        ],
        "orderType": 0,
        "startTime": int(time.time()),
        "endTime": int(time.time()) + 86400 * 7,  # 7일
        "zoneHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "salt": "0x" + os.urandom(32).hex(),
        "conduitKey": "0x0000007b02230091a7ed01230072f7006a004d60a8d4e71d599b8104250f0000",
        "totalOriginalConsiderationItems": 2
    },
    "signature": "0x..."  # 소유자의 개인 키로 서명
}

# OpenSea에 주문 제출
response = requests.post(
    f"{BASE_URL}/orders/ethereum/seaport/listings",
    headers=headers,
    json=listing_data
)
print(f"상장 생성됨: {response.status_code}")
```

### 주문 이행하기 (NFT 구매)

상장된 NFT를 구매하려면 주문을 검색하고 이행 트랜잭션을 제출하세요:

```python
def fulfill_order(order_hash: str, buyer_address: str):
    """기존 주문을 이행하여 NFT를 구매합니다."""
    # 주문 상세 정보 가져오기
    order_response = requests.get(
        f"{BASE_URL}/orders/ethereum/seaport/{order_hash}",
        headers=headers
    )
    order = order_response.json()
    
    # 이행 트랜잭션 구성
    fulfillment_data = {
        "order_hash": order_hash,
        "fulfiller": buyer_address,
        "offer": order["protocol_data"]["parameters"]["offer"],
        "consideration": order["protocol_data"]["parameters"]["consideration"]
    }
    
    # Seaport 컨트랙트에 제출
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

# 가장 저렴한 상장 아이템 구매
cheapest = min(listings, key=lambda x: float(x["price"]))
tx = fulfill_order(cheapest["order_hash"], "0xBuyerWalletAddress")
```

### 배치 작업

고빈도 거래를 위해 배치 엔드포인트를 사용하여 여러 작업을 처리하세요:

```python
def batch_get_listings(requests_list: List[Dict]) -> List[Dict]:
    """단일 요청으로 여러 상장을 가져옵니다."""
    response = requests.post(
        f"{BASE_URL}/listings/batch",
        headers=headers,
        json={"requests": requests_list}
    )
    return response.json()["results"]

# 여러 컬렉션에 대한 배치 요청
collections = ["boredapeyachtclub", "cryptopunks", "azuki"]
requests_list = [{"collection": c, "limit": 5} for c in collections]
batch_results = batch_get_listings(requests_list)
```

---

## WebSocket을 통한 실시간 이벤트 스트리밍

OpenSea WebSocket API는 마켓플레이스 이벤트의 실시간 모니터링을 가능하게 합니다. 이는 즉각적인 업데이트가 필요한 트레이딩 봇, 알림 시스템, 분석 플랫폼에 필수적입니다.

### WebSocket 연결 설정

```python
import json
import asyncio
import websockets

class OpenSeaStreamClient:
    """실시간 OpenSea 이벤트 스트리밍을 위한 WebSocket 클라이언트."""
    
    WS_URL = "wss://stream.opensea.io/socket"
    
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.subscriptions = []
        self.running = False
    
    async def connect(self):
        """인증과 함께 WebSocket 연결을 설정합니다."""
        self.ws = await websockets.connect(
            self.WS_URL,
            extra_headers={"X-API-KEY": self.api_key}
        )
        logger.info("WebSocket 연결됨")
    
    async def subscribe(self, event_type: str, filters: dict = None):
        """특정 이벤트 스트림을 구독합니다."""
        payload = {
            "topic": event_type,
            "filters": filters or {}
        }
        await self.ws.send(json.dumps({
            "method": "SUBSCRIBE",
            "params": [payload]
        }))
        logger.info(f"구독함: {event_type}")
    
    async def listen(self, callback):
        """들어오는 이벤트를 수신합니다."""
        self.running = True
        while self.running:
            try:
                message = await self.ws.recv()
                data = json.loads(message)
                await callback(data)
            except websockets.exceptions.ConnectionClosed:
                logger.warning("연결 종료됨, 재연결 중...")
                await self.connect()
                for sub in self.subscriptions:
                    await self.subscribe(sub["type"], sub.get("filters"))
    
    async def disconnect(self):
        """WebSocket 연결을 닫습니다."""
        self.running = False
        await self.ws.close()


# 이벤트 핸들러
async def handle_event(event: dict):
    """들어오는 마켓플레이스 이벤트를 처리합니다."""
    event_type = event.get("event_type")
    payload = event.get("payload", {})
    
    if event_type == "item_listed":
        print(f"[상장] {payload['name']} 가격 {payload['base_price']} ETH")
    elif event_type == "item_sold":
        print(f"[판매] {payload['name']}이(가) {payload['sale_price']} ETH에 판매됨")
    elif event_type == "item_cancelled":
        print(f"[취소] {payload['name']}")
    elif event_type == "collection_offer":
        print(f"[오퍼] {payload['collection_slug']}에 대한 컬렉션 오퍼")


# 이벤트 스트림 실행
async def main():
    client = OpenSeaStreamClient(api_key=API_KEY)
    await client.connect()
    
    # 이벤트 구독
    await client.subscribe("item_listed", {"collection_slug": "boredapeyachtclub"})
    await client.subscribe("item_sold", {"collection_slug": "boredapeyachtclub"})
    
    # 수신 시작
    await client.listen(handle_event)

# asyncio.run(main())
```

### 이벤트 유형 참조

WebSocket API는 다양한 사용 사례를 위한 여러 이벤트 유형을 지원합니다:

```python
# 사용 가능한 이벤트 유형
EVENT_TYPES = {
    "item_listed": "새 상장 생성됨",
    "item_sold": "아이템 구매됨",
    "item_cancelled": "상장 취소됨",
    "item_received_bid": "새 입찰",
    "item_received_offer": "새 오퍼",
    "collection_offer": "전체 컬렉션 오퍼",
    "trait_offer": "특정 특성 오퍼",
    "item_metadata_updated": "NFT 메타데이터 새로고침됨",
    "item_transfer": "토큰 전송됨"
}
```

---

## 속도 제한 및 모범 사례

속도 제한을 이해하는 것은 프로덕션 애플리케이션에 매우 중요합니다. 제한을 초과하면 거래 운영을 중단시킬 수 있는 임시 차단이 발생합니다.

### 속도 제한 계층

| 계층 | 초당 요청 | 버스트 제한 | 사용 사례 |
|------|----------|------------|----------|
| 묶음 | 1 | 5 | 개발, 테스트 |
| 개발자 | 10 | 50 | 소규모 애플리케이션 |
| 전문가 | 40 | 200 | 트레이딩 봇, 분석 |
| 기업 | 120+ | 600+ | 고빈도 거래 |

### 속도 제한 헤더

모든 API 응답은 속도 제한 헤더를 포함합니다:

```python
def check_rate_limits(response: requests.Response):
    """속도 제한 상태를 추출하고 모니터링합니다."""
    limit = response.headers.get("X-RateLimit-Limit")
    remaining = response.headers.get("X-RateLimit-Remaining")
    reset = response.headers.get("X-RateLimit-Reset")
    
    print(f"속도 제한: {remaining}/{limit}")
    print(f"초기화까지: {reset}초")
    
    # 제한에 근접하면 경고
    if int(remaining) < 10:
        logger.warning(f"속도 제한에 근접! 남은 요청 {remaining}개")
    
    return {
        "limit": int(limit) if limit else None,
        "remaining": int(remaining) if remaining else None,
        "reset": int(reset) if reset else None
    }

# 모든 요청에 적용
response = requests.get(f"{BASE_URL}/collections", headers=headers)
limits = check_rate_limits(response)
```

### 백오프 전략 구현

```python
import random

class AdaptiveRateLimiter:
    """지수 백오프가 있는 적응형 속도 제한기."""
    
    def __init__(self, base_delay: float = 1.0, max_delay: float = 60.0):
        self.base_delay = base_delay
        self.max_delay = max_delay
        self.current_delay = base_delay
        self.consecutive_errors = 0
    
    def wait(self):
        """적응형 지연과 함께 대기합니다."""
        jitter = random.uniform(0, 0.5)
        time.sleep(self.current_delay + jitter)
    
    def on_success(self):
        """성공한 요청 후 지연을 줄입니다."""
        self.consecutive_errors = 0
        self.current_delay = max(self.base_delay, self.current_delay * 0.8)
    
    def on_error(self, status_code: int):
        """오류 후 지연을 증가시킵니다."""
        self.consecutive_errors += 1
        if status_code == 429:
            self.current_delay = min(
                self.max_delay,
                self.current_delay * 2 ** self.consecutive_errors
            )
            logger.warning(f"속도 제한됨. 백오프: {self.current_delay}초")


# 요청 루프에서 사용
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

### 캐싱 전략

```python
from functools import lru_cache
from datetime import datetime, timedelta

class OpenSeaCache:
    """API 응답을 위한 간단한 TTL 캐시."""
    
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

# 컬렉션 메타데이터 캐싱 (드물게 변경됨)
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

## 트레이딩 봇 구축: 완전한 예제

다음은 컬렉션 간 바닥 가격을 모니터링하는 차익 거래 탐지 트레이딩 봇의 완전한 예제입니다:

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
    """OpenSea API를 사용하는 간단한 차익 거래 탐지 봇."""
    
    def __init__(self, api: OpenSeaAPI, min_profit_pct: float = 15.0):
        self.api = api
        self.min_profit_pct = min_profit_pct
        self.watchlist = []
        self.callbacks: List[Callable] = []
    
    def add_collection(self, collection_slug: str, floor_threshold: float):
        """감시 목록에 컬렉션을 추가합니다."""
        self.watchlist.append({
            "slug": collection_slug,
            "threshold": floor_threshold
        })
    
    def on_opportunity(self, callback: Callable):
        """차익 거래 기회에 대한 콜백을 등록합니다."""
        self.callbacks.append(callback)
    
    def analyze_collection(self, collection: dict) -> List[ArbitrageOpportunity]:
        """저가 상장을 위해 컬렉션을 스캔합니다."""
        slug = collection["slug"]
        
        # 바닥 가격과 활성 상장 가져오기
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
            
            # 바닥 가격보다 현저히 낮은지 확인
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
                
                # 콜백 알림
                for cb in self.callbacks:
                    cb(opp)
        
        return opportunities
    
    def run(self, interval: int = 30):
        """지정된 확인 간격으로 봇을 실행합니다."""
        logger.info(f"봇 시작, {len(self.watchlist)}개 컬렉션 모니터링 중")
        
        try:
            while True:
                for collection in self.watchlist:
                    try:
                        opps = self.analyze_collection(collection)
                        if opps:
                            logger.info(f"{collection['slug']}에서 {len(opps)}개의 기회 발견")
                    except Exception as e:
                        logger.error(f"{collection['slug']} 분석 중 오류: {e}")
                
                time.sleep(interval)
        except KeyboardInterrupt:
            logger.info("사용자가 봇을 중지함")


# 사용 예시
def notify_discord(opp: ArbitrageOpportunity):
    """기회에 대한 Discord 알림을 볃냅니다."""
    message = f"""
    **차익 거래 알림!**
    컬렉션: {opp.collection}
    토큰: #{opp.token_id}
    상장 가격: {opp.listed_price:.4f} ETH
    바닥 가격: {opp.estimated_value:.4f} ETH
    수익: {opp.profit_margin:.1f}%
    [상장 보기]({opp.listing_url})
    """
    # send_to_discord_webhook(message)

bot = NFTArbitrageBot(sdk, min_profit_pct=20.0)
bot.add_collection("boredapeyachtclub", floor_threshold=30.0)
bot.add_collection("azuki", floor_threshold=10.0)
bot.on_opportunity(notify_discord)
# bot.run(interval=60)
```

---

## 오류 처리 및 디버깅

프로덕션 애플리케이션에는 강력한 오류 처리가 필요합니다. OpenSea API는 구조화된 오류 응답을 반환합니다:

```python
class OpenSeaAPIError(Exception):
    """OpenSea API 오류용 사용자 정의 예외."""
    
    def __init__(self, message: str, status_code: int = None, response_data: dict = None):
        super().__init__(message)
        self.status_code = status_code
        self.response_data = response_data or {}

def handle_api_error(response: requests.Response):
    """적절한 예외를 구문 분석하고 발생시킵니다."""
    try:
        error_data = response.json()
    except ValueError:
        error_data = {"message": response.text}
    
    error_map = {
        400: ("잘못된 요청", ValueError),
        401: ("인증되지 않음 - API 키 확인", PermissionError),
        403: ("금지됨 - 권한 부족", PermissionError),
        404: ("리소스를 찾을 수 없음", KeyError),
        429: ("속도 제한 초과", TimeoutError),
        500: ("낮부 서버 오류", RuntimeError),
        503: ("서비스를 사용할 수 없음", ConnectionError)
    }
    
    error_msg, error_class = error_map.get(
        response.status_code, 
        (f"HTTP {response.status_code}", RuntimeError)
    )
    
    detail = error_data.get("message", error_data.get("detail", "알 수 없는 오류"))
    raise error_class(f"{error_msg}: {detail}")

# SDK에 적용
class RobustOpenSeaAPI(OpenSeaAPI):
    def _request(self, method: str, endpoint: str, **kwargs):
        response = self.session.request(method, self.BASE_URL + endpoint, **kwargs)
        if not response.ok:
            handle_api_error(response)
        return response.json()
```

---

## 자주 묻는 질문

### OpenSea API 키는 어떻게 얻나요?

[OpenSea 개발자 대시보드](https://docs.opensea.io/reference/api-keys)를 방문하여 지갑으로 로그인하고 개발자 신청을 완료하세요. 승인은 일반적으로 1-3영업일이 소요됩니다. 사용 사례를 설명하고 API 서비스 약관에 동의해야 합니다. 엔터프라이즈 계층 키에는 추가 인증과 직접적인 파트너십 계약이 필요합니다.

### OpenSea API의 속도 제한은 무엇인가요?

속도 제한은 API 계층에 따라 다릅니다. 묶음 계층은 초당 1개 요청, 버스트 5개를 허용합니다. 개발자 계층은 이를 초당 10개 요청, 버스트 50개로 증가시킵니다. 전문가 계층은 초당 40개 요청, 버스트 200개를 지원합니다. 엔터프라이즈 계층은 고빈도 트레이딩 애플리케이션을 위해 초당 120개 이상을 제공합니다. 사용량을 모니터링하려면 모든 응답의 `X-RateLimit-*` 헤더를 확인하세요.

### API를 통해 NFT를 사고 팔 수 있나요?

예, API는 완전한 프로그래밍 방식 거래를 지원합니다. 코드를 통해 상장을 생성하고, 오퍼를 수락하고, 주문을 이행할 수 있습니다. 하지만 NFT를 소유한 지갑의 개인 키가 필요합니다. 모든 거래는 가스 비용이 필요한 온체인 서명이 필요한 Seaport 프로토콜을 통해 실행됩니다.

### OpenSea API는 어떤 블록체인을 지원하나요?

2026년 현재 OpenSea API는 이더리움 메인넷, 폴리곤(PoS 및 zkEVM), 아비트럼 원, 옵티미즘, 베이스, 조라, 세폴리아 테스트넷을 지원합니다. 각 체인에는 자체 엔드포인트 접두사가 있습니다(예: `/chain/ethereum/`, `/chain/polygon/`). 교차 체인 애그리게이션 엔드포인트를 통해 여러 네트워크를 동시에 쿼리할 수 있습니다.

### OpenSea에 공식 Python SDK가 있나요?

OpenSea에는 공식 Python SDK가 없습니다. 공식 SDK는 [opensea-js](https://github.com/ProjectOpenSea/opensea-js)(JavaScript/TypeScript)입니다. 하지만 여러 커뮤니티에서 유지 관리하는 Python 패키지가 존재하며, 이 가이드에서 설명한 것처럼 requests 라이브러리를 사용하여 자체 통합을 쉽게 구축할 수 있습니다. REST API는 잘 문서화되어 있고 표준 규칙을 따릅니다.

### 실시간 이벤트를 어떻게 스트리밍하나요?

`wss://stream.opensea.io/socket`에서 WebSocket API를 사용하세요. 선택적 컬렉션 필터와 함께 `item_listed`, `item_sold`, `item_cancelled` 등의 이벤트 유형을 구독하세요. WebSocket 연결에는 `X-API-KEY` 헤더에 API 키가 필요합니다. 프로덕션 안정성을 위해 재연결 로직을 구현하세요.

### Seaport 프로토콜이란 무엇인가요?

Seaport는 OpenSea의 탈중앙화된 NFT 트레이딩 프로토콜입니다. 주문 매칭, 이행, 수수료 분배를 처리하는 오픈 소스 스마트 컨트랙트 표준입니다. API를 통해 주문을 생성하거나 이행할 때, 온체인의 Seaport 컨트랙트와 상호작용하는 것입니다. 이 프로토콜은 조건 기반 주문, 부분 채우기, 대량 실행과 같은 고급 기능을 지원합니다.

---



## 추천 호스팅 및 인프라

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영을 지원합니다.*

## 결론

OpenSea API는 2026년 현재 가장 포괄적이고 실전 검증된 NFT 마켓플레이스 API입니다. 여러 블록체인에 대한 지원, 실시간 WebSocket 스트리밍, 완전한 프로그래밍 방식 거래 기능을 갖추고 있어 정교한 NFT 애플리케이션을 구축하는 데 필요한 모든 것을 개발자에게 제공합니다.

이 가이드의 핵심 요점:

- **인증**: 개발자 대시보드에서 API 키를 얻고 항상 환경 변수를 사용하세요
- **SDK 전략**: 공식 JavaScript SDK를 사용하거나 재시도 로직으로 사용자 정의 Python 래퍼를 구축하세요
- **거래**: 프로그래밍 방식 매수/매도를 위해 Seaport 주문 생성 및 이행을 이해하세요
- **실시간**: 즉각적인 이벤트 알림을 위해 WebSocket 스트림을 활용하세요
- **속도 제한**: 계층 제한 내에서 유지하기 위해 적응형 백오프와 캐싱을 구현하세요
- **오류 처리**: 프로덕션 안정성을 위해 강력한 오류 처리를 구축하세요

간단한 포트폴리오 추적기든 고빈도 트레이딩 봇이든, OpenSea API는 세계 최대의 NFT 마켓플레이스와 프로그래밍 방식으로 상호작용하는 데 필요한 인프라를 제공합니다. 이 가이드의 예제부터 시작하고, 속도 제한을 모니터링하며, 필요에 따라 애플리케이션을 확장하세요.

---

*이 문서는 2026-05-19에 작성되었습니다. API 사양과 속도 제한은 변경될 수 있습니다. 최신 업데이트는 [공식 OpenSea 문서](https://docs.opensea.io/)를 참조하세요.*
