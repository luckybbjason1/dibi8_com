---
title: 'Scrapy: Benchmark 61K+ Star Web Crawler — Performance vs BeautifulSoup, Selenium in 2026'
description: 'Scrapy는 Python 기반의 빠른 고수준 웹 크롤링 및 스크래핑 프레임워크이다. Python, Docker, Redis, PostgreSQL과 호환된다. 벤치마크, 아키텍처, 프로덕션 배포, BeautifulSoup 및 Selenium과의 비교를 다룬다.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: BSD-3-Clause
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/scrapy/scrapy'
stars: 61700
maintainer: 'scrapy'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['web-scraping', 'python', 'crawler', 'async', 'docker', 'scrapy튜토리얼', '벤치마크', '데이터파이프라인']
aliases:
- /kr/posts/scrapy/
---

{{</* resource-info */>}}

단일 Python 프레임워크가 전 세계 약 **34%의 프로덕션 스크래핑 프로젝트**를 지원하고 GitHub에서 61,700개의 star를 유지하고 있다면, 깊이 있는 분석이 필요하다. Scrapy는 2008년부터 웹 크롤링의 주력 도구였지만, 2026년에는 Playwright와 같은 현대적인 브라우저 자동화 도구와 BeautifulSoup과 같은 검증된 라이브러리가 시장에 있다. 이제 질문은 "Scrapy가 크롤링할 수 있는가?"가 아니라 "특정 워크로드에 대해 여전히 Scrapy를 대안보다 선택해야 하는가?"이다.

이 기사는 Scrapy를 세 가지 가장 일반적인 대안과 벤치마크 비교하고, scrapy docker를 활용한 프로덕션급 scrapy튜토리얼 설정을 안내하며, 결정에 도움이 되는 실제 숫자를 제공한다. 가격 모니터링 파이프라인을 구축하든 훈련 데이터 수집 인프라를 구축하든, 여기의 비교 데이터는 통제된 조건 하에 50개 이상의 테스트 사이트에서 수행된 공개 벤치마크에서 나왔다.

## Scrapy란 무엇인가?

Scrapy는 비동기 네트워킹 엔진인 Twisted를 기반으로 구축된 오픈소스 Python 웹 크롤링 및 스크래핑 프레임워크이다. 단일 목적의 파싱 라이브러리와 달리 Scrapy는 요청 스케줄링, 동시 다운로드, 데이터 추출, 검증 및 낳보를 포함한 완전한 파이프라인을 제공한다 — 모두 구조화되고 확장 가능한 아키텍처 내에서 동작한다.

원래 Mydeco에서 개발되었고 현재는 Zyte(이전 Scrapinghub)에서 유지보수하는 Scrapy는 BSD-3-Clause 라이선스로 배포된다. 2026년 5월 기준 현재 안정 버전은 2.16.0이며 GitHub에서 활발한 개발이 계속되고 있다.

![Scrapy Logo](https://raw.githubusercontent.com/scrapy/scrapy/master/art/scrapy-logo.jpg)

## Scrapy의 작동 방식

Scrapy의 아키텍처는 관심사를 명확하게 분리한 이벤트 기반 비차단 디자인을 따른다:

![Scrapy 아키텍처](https://scrapy.readthedocs.io/en/latest/_images/scrapy_architecture_02.png)

### 핵심 컴포넌트

1. **엔진(Engine)** — 실행 엔진은 모든 컴포넌트 간의 데이터 흐름을 제어하고 날부 이벤트를 트리거한다.
2. **스케줄러(Scheduler)** — 엔진에서 요청을 받아 대기열에 넣고 DupeFilter를 통해 중복을 필터링한다.
3. **다운로더(Downloader)** — Twisted의 비차단 I/O를 사용하여 웹 페이지를 비동기로 가져오고, 재시도, 쿠키, 헤더를 처리한다.
4. **스파이더(Spiders)** — 크롤링할 내용(시작 URL, 팔로우 규칙)과 응답을 파싱하는 방법(CSS/XPath 선택자)을 정의하는 사용자 정의 클래스이다.
5. **아이템 파이프라인(Item Pipelines)** — 스크랩된 데이터의 후처리 체인: 클리닝, 검증, 중복 제거, 저장.
6. **미들웨어(Middlewares)** — 다운로더 및 스파이더 미들웨어는 요청/응답을 가로채어 사용자 정의 로직(프록시 로테이션, User-Agent 스푸핑, 재시도 정책)을 수행한다.

### 데이터 흐름

```
스파이더 → 엔진 → 스케줄러 → 엔진 → 다운로더 → 스파이더 → 아이템 파이프라인
                  ↓                                    ↓
             (중복 필터)                          (새 요청)
```

엔진은 스파이더에서 초기 요청을 가져와 스케줄링하고, 다운로더를 통해 전송하고, 응답을 받아 스파이더로 다시 전달하여 파싱하고, 추출된 아이템을 파이프라인을 통해 전송한다. 파싱 중 발견된 새 요청은 스케줄러로 다시 순환한다. 남은 요청이 없을 때까지 이 루프가 계속된다.

핵심 성능 이점은 Scrapy의 비동기 아키텍처에서 나온다: 하나의 요청이 네트워크 응답을 기다리는 동안 엔진은 수십 개의 다른 요청을 스케줄링할 수 있다. 이는 각 요청이 실행을 차단하는 동기 방식과 근본적으로 다르다.

## 설치 및 설정

### 전제 조건

- Python 3.9 이상
- pip 또는 uv 패키지 매니저
- (선택) Docker — 컨테이너화된 배포용

### 기본 설치

```bash
# 가상 환경 생성
python -m venv scrapy_env
source scrapy_env/bin/activate  # Linux/Mac
# scrapy_env\Scripts\activate  # Windows

# Scrapy 설치
pip install scrapy

# 설치 확인
scrapy version
# 출력: Scrapy 2.16.0

# 내장 벤치마크 실행
scrapy bench
```

### 프로젝트 스캐폴드

```bash
# 새 Scrapy 프로젝트 생성
scrapy startproject price_monitor
cd price_monitor

# 스파이더 템플릿 생성
scrapy genspider products example.com
```

표준 프로젝트 구조가 생성된다:

```
price_monitor/
├── scrapy.cfg              # 프로젝트 설정
├── price_monitor/
│   ├── __init__.py
│   ├── items.py            # 데이터 모델
│   ├── middlewares.py      # 커스텀 미들웨어
│   ├── pipelines.py        # 데이터 처리
│   ├── settings.py         # 프레임워크 설정
│   └── spiders/
│       ├── __init__.py
│       └── products.py     # 사용자 스파이더
```

### 첫 번째 스파이더: 상품 스크래퍼

```python
# price_monitor/spiders/products.py
import scrapy

class ProductsSpider(scrapy.Spider):
    name = 'products'
    allowed_domains = ['example.com']
    start_urls = ['https://example.com/products']
    
    custom_settings = {
        'CONCURRENT_REQUESTS': 16,
        'DOWNLOAD_DELAY': 0.5,
        'AUTOTHROTTLE_ENABLED': True,
    }

    def parse(self, response):
        """상품 데이터 추출 및 페이지네이션 팔로우."""
        for product in response.css('.product-card'):
            yield {
                'name': product.css('.title::text').get(),
                'price': product.css('.price::text').get(),
                'url': product.css('a::attr(href)').get(),
                'sku': product.css('.sku::text').get(),
            }
        
        # 페이지네이션 팔로우
        next_page = response.css('.next-page::attr(href)').get()
        if next_page:
            yield response.follow(next_page, self.parse)
```

### 스파이더 실행

```bash
# 스파이더 실행 및 JSON 출력
scrapy crawl products -o products.json

# CSV 낳보로 실행
scrapy crawl products -o products.csv

# 로그 레벨 제어와 함께 실행
scrapy crawl products -L INFO
```

### Docker 배포

```dockerfile
# Dockerfile
FROM python:3.12-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
CMD ["scrapy", "crawl", "products"]
```

```yaml
# docker-compose.yml
version: '3.8'
services:
  scrapy:
    build: .
    volumes:
      - ./output:/app/output
    environment:
      - SCRAPY_SETTINGS_MODULE=price_monitor.settings
    depends_on:
      - redis
      - postgres
  
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
  
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: scrapy_data
      POSTGRES_USER: scraper
      POSTGRES_PASSWORD: scraper_pass
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

## 인기 도구와의 통합

### Redis를 활용한 분산 크롤링 (scrapy-redis)

단일 머신으로는 부족할 때, scrapy-redis는 Redis를 공유 큐로 사용하여 크롤링을 여러 노드에 분산한다:

```bash
pip install scrapy-redis
```

```python
# settings.py
SCHEDULER = "scrapy_redis.scheduler.Scheduler"
DUPEFILTER_CLASS = "scrapy_redis.dupefilter.RFPDupeFilter"
REDIS_URL = "redis://localhost:6379"
SCHEDULER_PERSIST = True  # 실행 간 큐 유지
```

### PostgreSQL 파이프라인

```python
# pipelines.py
import psycopg2
from scrapy.exceptions import DropItem

class PostgresPipeline:
    def open_spider(self, spider):
        self.conn = psycopg2.connect(
            host='postgres', dbname='scrapy_data',
            user='scraper', password='scraper_pass'
        )
        self.cur = self.conn.cursor()
        self.cur.execute('''
            CREATE TABLE IF NOT EXISTS products (
                id SERIAL PRIMARY KEY,
                name TEXT,
                price TEXT,
                url TEXT UNIQUE,
                sku TEXT,
                scraped_at TIMESTAMP DEFAULT NOW()
            )
        ''')
        self.conn.commit()

    def process_item(self, item, spider):
        try:
            self.cur.execute('''
                INSERT INTO products (name, price, url, sku)
                VALUES (%s, %s, %s, %s)
                ON CONFLICT (url) DO NOTHING
            ''', (item['name'], item['price'], item['url'], item['sku']))
            self.conn.commit()
        except psycopg2.Error as e:
            spider.logger.error(f"DB 오류: {e}")
            raise DropItem(f"삽입 실패: {e}")
        return item

    def close_spider(self, spider):
        self.cur.close()
        self.conn.close()
```

### JavaScript 렌더링 페이지용 Playwright

```bash
pip install scrapy-playwright
```

```python
# settings.py
DOWNLOAD_HANDLERS = {
    "http": "scrapy_playwright.handler.ScrapyPlaywrightDownloadHandler",
    "https": "scrapy_playwright.handler.ScrapyPlaywrightDownloadHandler",
}
TWISTED_REACTOR = "twisted.internet.asyncioreactor.AsyncioSelectorReactor"
```

```python
# Playwright를 사용하는 스파이더
import scrapy
from scrapy_playwright.page import PageMethod

class JSSpider(scrapy.Spider):
    name = 'js_site'
    
    def start_requests(self):
        yield scrapy.Request(
            'https://spa-example.com/products',
            meta={
                'playwright': True,
                'playwright_page_methods': [
                    PageMethod('wait_for_selector', '.product-loaded'),
                    PageMethod('click', '.load-more'),
                    PageMethod('wait_for_selector', '.product-item'),
                ]
            }
        )

    def parse(self, response):
        for item in response.css('.product-item'):
            yield {
                'name': item.css('.name::text').get(),
                'price': item.css('.price::text').get(),
            }
```

### WebShare를 활용한 프록시 로테이션

프로덕션 크롤링을 위해 안정적인 로테이팅 프록시 풀은 필수적이다. WebShare는 데이터센터 및 레지덴셜 프록시를 제공하여 Scrapy의 미들웨어와 깔끔하게 통합된다:

```python
# middlewares.py
import base64

class ProxyMiddleware:
    def __init__(self, proxy_url):
        self.proxy_url = proxy_url

    @classmethod
    def from_crawler(cls, crawler):
        return cls(proxy_url=crawler.settings.get('WEBSHARE_PROXY_URL'))

    def process_request(self, request, spider):
        request.meta['proxy'] = self.proxy_url
        spider.logger.debug(f'{request.url}에 프록시 사용 중')
```

```python
# settings.py
DOWNLOADER_MIDDLEWARES = {
    'price_monitor.middlewares.ProxyMiddleware': 350,
    'scrapy.downloadermiddlewares.httpproxy.HttpProxyMiddleware': 400,
}
WEBSHARE_PROXY_URL = 'http://proxy.webshare.io:80'
```

프록시 목록을 Scrapy 설정에 구성하면 미들웨어가 IP를 자동으로 로테이션한다. 대용량 스크래핑의 경우 WebShare의 로테이팅 프록시 엔드포인트는 인증과 로테이션을 투명하게 처리한다 — Scrapy를 단일 URL로 향하게 하면 요청마다 다른 이그레스 IP를 얻는다.

## 벤치마크 / 실제 사용 사례

### 동등 조건 성능 비교

![Scrapy Benchmark](https://docs.scrapy.org/en/latest/_images/scrapy_architecture_02.png)

2026년 초 4코어 VPS(8GB RAM)에서 50개 이상의 사이트를 대상으로 수행된 벤치마크는 도구 간 상당한 차이를 보여준다:

| 지표 | Scrapy | BeautifulSoup + requests | Selenium | Playwright |
|---|---|---|---|---|
| **처리량 (페이지/초)** | 100+ | 1–3 | 2–4 | 3–5 |
| **인스턴스당 메모리** | ~150 MB | ~80 MB | ~500 MB | ~400 MB |
| **시작 시간** | <1초 | <1초 | 3–5초 | 2–3초 |
| **JavaScript 지원** | 미들웨어 통해 | 없음 | 있음 | 있음 |
| **동시성 모델** | 비동기 (이벤트 루프) | 동기 (차단) | 제한적 (프로세스) | 비동기 |
| **Cloudflare 성공률** | 32% | 28% | 72% | 78% |
| **100만 페이지 비용** | $50–100 | $10–30 | $300–500 | $300–500 |
| **학습 곡선** | 8–12시간 | 2–4시간 | 16–20시간 | 12–16시간 |
| **최적 페이지 규모** | 10K–10M+ | <1K | <10K | <10K |

### 주요 관찰 사항

1. **Scrapy가 정적 HTML에서 처리량을 지배한다**: 100+ 페이지/초 vs 브라우저 기반 도구의 1–5. 비동기 Twisted 엔진은 브라우저 프로세스를 생성하지 않고도 수백 개의 동시 연결을 처리한다.

2. **브라우저 도구가 JS 중심 사이트에서 승리한다**. React, Vue, Angular로 빌드되어 DOM 렌더링이 필요한 사이트는 Selenium이나 Playwright가 필요하다. Scrapy는 scrapy-playwright 미들웨어를 통해 이 간극을 메울 수 있지만, 브라우저 렌더링이 필요할 때 처리량은 약 10–15 페이지/sec로 떨어진다.

3. **BeautifulSoup은 소규모 작업에 가장 저렴**하지만 내장 동시성, 재시도 로직, 낳보 파이프라인이 없다. 10,000페이지 크롤의 경우, 단순한 BS4 스크립트는 약 90분이 소요된다; 적절한 튜닝으로 Scrapy는 약 5분에 완료한다.

### 실제 프로덕션 배포 프로필

중규모 전자상거래 인텔리전스 회사의 프로덕션 가격 모니터링 파이프라인이 Scrapy 사용으로 다음과 같은 수치를 보고했다:

- 하루 **120만 페이지**를 800개 도메인에서 크롤링
- **24개 Scrapy 인스턴스**가 6대 서버에 분산
- **평균 지연 시간**: 요청당 340ms (p95 1.2초)
- **메모리 사용량**: 스파이더 프로세스당 180MB
- **CPU 사용량**: 피크 동시성에서 스파이더당 0.3코어
- **데이터 낳보**: 파이프라인을 통한 PostgreSQL 직접 저장, S3 JSONL 백업
- **프록시 비용**: 로테이팅 레지덴셜 프록시 월 $800

## 고급 사용법 / 프로덕션 강화

### 자동 스로틀 구성

스로틀링 없이는 Scrapy가 대상 서버를 압도하고 수 초 내에 차단될 수 있다. AutoThrottle은 서버 응답 시간에 기반하여 다운로드 지연을 동적으로 조정한다:

```python
# settings.py
AUTOTHROTTLE_ENABLED = True
AUTOTHROTTLE_START_DELAY = 1.0
AUTOTHROTTLE_MAX_DELAY = 10.0
AUTOTHROTTLE_TARGET_CONCURRENCY = 2.0
AUTOTHROTTLE_DEBUG = False
```

### 재시도 및 타임아웃 정책

```python
# settings.py
RETRY_ENABLED = True
RETRY_TIMES = 3
RETRY_HTTP_CODES = [500, 502, 503, 504, 408, 429]
DOWNLOAD_TIMEOUT = 30
DOWNLOAD_FAIL_ON_DATALOSS = False
```

### 커스텀 User-Agent 로테이션

```python
# middlewares.py
import random

USER_AGENTS = [
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0',
]

class RotateUserAgentMiddleware:
    def process_request(self, request, spider):
        request.headers['User-Agent'] = random.choice(USER_AGENTS)
```

### 통계 수집을 통한 모니터링

```python
# extensions.py
from scrapy import signals

class StatsCollector:
    def __init__(self):
        self.requests_count = 0
        self.items_count = 0

    @classmethod
    def from_crawler(cls, crawler):
        ext = cls()
        crawler.signals.connect(ext.spider_opened, signal=signals.spider_opened)
        crawler.signals.connect(ext.request_scheduled, signal=signals.request_scheduled)
        crawler.signals.connect(ext.item_scraped, signal=signals.item_scraped)
        return ext

    def spider_opened(self, spider):
        spider.logger.info(f'스파이더 열림: {spider.name}')

    def request_scheduled(self, request, spider):
        self.requests_count += 1

    def item_scraped(self, item, spider):
        self.items_count += 1
        if self.items_count % 1000 == 0:
            spider.logger.info(f'{self.items_count}개 아이템, {self.requests_count}개 요청 스크랩됨')
```

### 로그 로테이션 및 구조화된 로깅

```python
# settings.py
LOG_LEVEL = 'INFO'
LOG_FILE = 'logs/scrapy.log'
LOG_FORMAT = '%(asctime)s [%(name)s] %(levelname)s: %(message)s'
LOG_STDOUT = False
```

### Scrapyd를 활용한 수평 확장

```bash
pip install scrapyd
scrapyd  # 6800번 포트에서 데몬 시작
```

```bash
# HTTP API를 통한 배포 및 스케줄링
curl http://localhost:6800/schedule.json -d project=price_monitor -d spider=products
curl http://localhost:6800/listjobs.json -d project=price_monitor
```

## 대안과의 비교

| 기능 | Scrapy | BeautifulSoup | Selenium | Playwright |
|---|---|---|---|---|
| **라이선스** | BSD-3-Clause | MIT | Apache-2.0 | Apache-2.0 |
| **언어** | Python | Python | 멀티 | 멀티 |
| **비동기/동시성** | 내장 (Twisted) | 수동 | 제한적 | 내장 |
| **JS 렌더링** | 미들웨어 통해 | 없음 | 네이티브 | 네이티브 |
| **내장 스케줄러** | 있음 | 없음 | 없음 | 없음 |
| **자동 재시도** | 있음 | 없음 | 없음 | 없음 |
| **피드 낳보** | JSON/CSV/XML/S3/GCS | 수동 | 수동 | 수동 |
| **프록시 로테이션** | 미들웨어 | 수동 | 수동 | 컨텍스트 수준 |
| **쿠키/세션** | 내장 | 수동 | 내장 | 내장 |
| **아이템 파이프라인** | 있음 | 없음 | 없음 | 없음 |
| **분산 모드** | scrapy-redis | 없음 | Selenium Grid | Playwright servers |
| **성숙도 (년)** | 17+ | 20+ | 20+ | 5+ |
| **커뮤니티 규모** | 61.7K stars | 사실상 표준 | 32K stars | 72K stars |

## 한계 / 솔직한 평가

Scrapy는 모든 스크래핑 문제에 적합한 도구가 아니다. 다음은 잘 수행하지 못하는 영역이다:

1. **단일 페이지, 일회성 스크립트** — 단일 HTML 파일이나 소량의 페이지를 파싱해야 하는 경우, 프로젝트 스캐폴드 오버헤드가 그만한 가치가 없다. 100페이지 미만 작업의 경우 BeautifulSoup과 requests가 작성 및 배포가 더 빠르다.

2. **미들웨어 없는 무거운 JavaScript SPA** — Scrapy는 원시 HTML을 다운로드한다. 대상 사이트가 클라이언트 사이드에서 데이터를 가져오는 React나 Vue 애플리케이션인 경우 scrapy-playwright나 Splash가 필요하다. 이는 복잡성을 추가하고 처리량을 80–90% 감소시킨다.

3. **CAPTCHA 및 고급 봇 보호** — Scrapy는 네이티브로 reCAPTCHA, hCaptcha 또는 Cloudflare Turnstile 과제를 해결할 수 없다. 공격적인 안티봇 조치가 있는 사이트의 경우 브라우저 자동화(Playwright/Selenium)나 Bright Data와 같은 관리 서비스가 필요하다.

4. **실시간 상호작용** — Scrapy는 크롤링 프레임워크이지 브라우저 자동화 도구가 아니다. 외부 통합 없이는 버튼 클릭, 대화형 폼 작성, 스크린샷 촬영을 할 수 없다.

5. **비 Python 생태계** — 팀이 전적으로 Node.js, Go 또는 Rust에서 작업하는 경우 Python Scrapy 배포를 유지관리하는 것은 운영적 마찰을 추가한다. Crawlee(Node.js)나 Colly(Go)와 같은 대안이 더 적합하다.

## 자주 묻는 질문

### Scrapy와 BeautifulSoup은 소규모 프로젝트에서 어떻게 비교되는가?

BeautifulSoup은 크롤링 프레임워크가 아닌 파싱 라이브러리이다. 100페이지 미만 프로젝트의 경우 BS4와 requests가 더 간단하고 보일러플레이트가 더 적다. 1,000페이지 이상의 프로젝트에서는 Scrapy의 내장 동시성, 재시도 로직, 낳보 파이프라인이 더 유지보수하기 쉬운 선택이 된다. 독립 벤치마크에 따를 10,000페이지 크롤에서 Scrapy는 BS4보다 약 **39배** 빠르다.

### Scrapy는 JavaScript 렌더링 웹사이트를 처리할 수 있는가?

네이티브로는 처리할 수 없다. Scrapy는 원시 HTTP 응답을 다운로드한다. 무거운 JavaScript 사이트의 경우 scrapy-playwright 미들웨어를 통합하거나 Splash를 사용한다. scrapy-playwright를 사용하면 Scrapy는 헤드리스 Chromium에서 페이지를 렌더링할 수 있으며, 속도는 약 10–15 페이지/초이다 — 원시 HTTP 모드보다 느리지만 여전히 독립형 Selenium보다 빠르다.

### 프로덕션에서 Scrapy를 실행하는 최선의 방법은 무엇인가?

scrapy-redis를 사용한 Docker 컨테이너로 분산 큐를 구성한다. Item Pipelines를 통해 PostgreSQL에 데이터를 저장한다. Prometheus와 Grafana로 모니터링한다. Scrapyd로 HTTP API 제어를 수행한다. AUTOTHROTTLE_ENABLED를 설정하여 대상 서버를 압도하지 않도록 한다. 커스텀 미들웨어를 통해 프록시와 User-Agent를 로테이션한다.

### Scrapy는 차단을 어떻게 피하는가?

Scrapy는 여러 가지 내장 메커니즘을 제공한다: AutoThrottle은 서버 응답 시간에 기반하여 요청 속도를 조정한다; DupeFilter는 중복 요청을 방지한다; 미들웨어는 프록시 로테이션과 User-Agent 스푸핑을 지원한다. 프로덕션 환경에서는 이러한 기능을 로테이팅 프록시 서비스와 결합하고 robots.txt를 존중한다. 어떤 프레임워크도 정교한 봇 탐지에 완전히 면역을 보장할 수는 없다.

### Scrapy는 실시간 데이터 스트리밍에 적합한가?

Scrapy는 기본적으로 배치 지향적이다. 스파이더가 실행되고, 데이터를 수집한 다음 종료한다. 근실시간 스트리밍의 경우 Item Pipeline에서 아이템을 Kafka나 Redis Streams로 파이프한다. 또는 cron, Airflow 또는 Scrapyd의 스케줄링 API를 사용하여 스케줄에 따라 스파이더를 트리거한다. Scrapy 자체는 영구적인 리스너를 유지하지 않는다.

### Scrapy를 현대 Python async/await 구문과 함께 사용할 수 있는가?

Scrapy는 asyncio가 아닌 Twisted의 deferred와 콜백을 기반으로 구축되었다. Twisted 자체가 최근 버전에서 async/await를 지원하지만, Scrapy의 API는 스파이더 메소드에 대해 여전히 콜백 기반이다. scrapy-playwright 통합은 두 세계를 연결하기 위해 AsyncioSelectorReactor를 사용한다. 네이티브 asyncio 지원은 오래된 기능 요청이지만 아직 기본값은 아니다.

## 결론

Scrapy는 Python에서 대규모, 프로덕션급 웹 크롤링을 위한 가장 생산적인 선택으로 남아 있다. 61,700개의 GitHub star는 17년간의 실전 검증된 개발을 반영하며, 과장이 아니다. 정적 HTML의 대규모 크롤링에서 Python 생태계의 어떤 도구도 그 처리량을 따라갈 수 없다. 무거운 JavaScript 사이트의 경우 scrapy-playwright 브리지가 합리적인 타협점을 제공한다.

의사결정 매트릭스는 간단하다: 100페이지 미만의 빠른 스크립트에는 **BeautifulSoup**, JavaScript 렌더링과 브라우저 상호작용에는 **Playwright/Selenium**, 그 외 모든 것에는 **Scrapy** — 특히 크롤 볼륨이 10,000페이지를 초과하거나 예약된, 모니터링되는 분산 실행이 필요한 경우.

**실행 항목:**

1. Scrapy 저장소를 클론하고 하드웨어에서 `scrapy bench`를 실행한다.
2. PostgreSQL 및 Redis 통합이 포함된 Docker 기반 프로젝트를 설정한다.
3. 프로덕션 크롤링을 위해 프록시 로테이션을 구성한다.
4. 일일 팁과 문제 해결을 위해 Telegram 커뮤니티에 가입한다: [dibi8_tg_group](https://t.me/dibi8open)



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 참고 자료

- Scrapy 공식 문서: https://docs.scrapy.org/en/latest/
- Scrapy 아키텍처 개요: https://scrapy.readthedocs.io/en/latest/topics/architecture.html
- scrapy-playwright 저장소: https://github.com/scrapy-plugins/scrapy-playwright
- scrapy-redis 저장소: https://github.com/rmax/scrapy-redis
- Scrapyd 문서: https://scrapyd.readthedocs.io/en/latest/
- WebShare 프록시 문서: https://www.webshare.io/proxy
- 성능 벤치마크 (NextGrowth.ai): https://nextgrowth.ai/best-tools-for-web-scraping/
- Scrapy vs BeautifulSoup 분석 (HasData): https://hasdata.com/blog/scrapy-vs-beautifulsoup

---

*이 기사에는 제휴 링크가 포함되어 있다. 이 기사의 WebShare 링크를 통해 프록시 서비스를 구매할 때, 추가 비용 없이 커미션을 받을 수 있다. 모든 벤치마크 데이터와 추천은 독립적인 테스트와 커뮤니티 검증 출처에 기반한다.*
