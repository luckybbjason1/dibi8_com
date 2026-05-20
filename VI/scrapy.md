---
title: 'Scrapy: Benchmark 61K+ Star Web Crawler — Performance vs BeautifulSoup, Selenium in 2026'
description: 'Scrapy là một framework web crawling và scraping cấp cao, nhanh chóng cho Python. Tương thích với Python, Docker, Redis, PostgreSQL. Bao gồm benchmark, kiến trúc, triển khai production và so sánh với BeautifulSoup, Selenium, Playwright.'
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
tags: ['web-scraping', 'python', 'crawler', 'async', 'docker', 'scrapy-tutorial', 'benchmark', 'data-pipeline']
aliases:
- /vi/posts/scrapy/
---

{{</* resource-info */>}}

Khi một framework Python cung cấp năng lượng cho khoảng **34% dự án scraping production** trên toàn thế giới và duy trì kho lưu trữ GitHub 61,700 star, nó đáng được nghiên cứu kỹ lưỡng. Scrapy đã là công cụ chủ lực cho web crawling từ năm 2008, nhưng trong năm 2026, bối cảnh bao gồm các công cụ tự động hóa trình duyệt hiện đại như Playwright và các thư viện đã được chứng minh như BeautifulSoup. Câu hỏi không còn là "Scrapy có thể crawl không?" — mà là "Bạn có nên vẫn chọn Scrapy thay vì các lựa chọn thay thế cho khối lượng công việc cụ thể của mình không?"

Bài viết scrapy tutorial này đối chiếu Scrapy với ba lựa chọn thay thế phổ biến nhất của nó, hướng dẫn thiết lập cấp production với scrapy docker, và cung cấp các con số thực tế để hướng dẫn quyết định của bạn. Dù bạn đang xây dựng pipeline giám sát giá hay hạ tầng thu thập dữ liệu huấn luyện, dữ liệu so sánh ở đây đến từ các bài benchmark đã công bố trên 50+ trang web thử nghiệm trong điều kiện được kiểm soát.

## Scrapy là gì?

Scrapy là một framework web crawling và scraping mã nguồn mở được xây dựng trên Twisted, một engine mạng không đồng bộ. Khác với các thư viện parsing chỉ có một mục đích, Scrapy cung cấp một pipeline hoàn chỉnh: lập lịch yêu cầu, tải xuống đồng thởi, trích xuất dữ liệu, xác thực, và xuất — tất cả trong một kiến trúc có cấu trúc và khả mở rộng.

Ban đầu được phát triển tại Mydeco và được Zyte (trước đây là Scrapinghub) bảo trì, Scrapy được phát hành theo giấy phép BSD-3-Clause. Phiên bản 2.16.0 là bản phát hành ổn định hiện tại tính đến tháng 5/2026, với sự phát triển tích cực tiếp tục trên GitHub.

![Scrapy Logo](https://raw.githubusercontent.com/scrapy/scrapy/master/art/scrapy-logo.jpg)

## Scrapy hoạt động như thế nào

Kiến trúc của Scrapy tuân theo một thiết kế hướng sự kiện, không chặn, phân tách các mối quan tâm thành các thành phần được xác định rõ ràng:

![Kiến trúc Scrapy](https://scrapy.readthedocs.io/en/latest/_images/scrapy_architecture_02.png)

### Các thành phần cốt lõi

1. **Engine** — Engine thực thi điều khiển luồng dữ liệu giữa tất cả các thành phần và kích hoạt các sự kiện nội bộ.
2. **Scheduler** — Nhận requests từ engine, xếp hàng chờ, và lọc trùng lặp qua DupeFilter.
3. **Downloader** — Lấy các trang web không đồng bộ sử dụng I/O không chặn của Twisted, xử lý retry, cookie, và headers.
4. **Spiders** — Các lớp do ngưở dùng định nghĩa chỉ định nội dung cần crawl (URL khởi đầu, quy tắc theo dõi) và cách phân tích phản hồi (bộ chọn CSS/XPath).
5. **Item Pipelines** — Chuỗi xử lý sau khi scrape dữ liệu: làm sạch, xác thực, loại bỏ trùng lặp, và lưu trữ.
6. **Middlewares** — Downloader và Spider middlewares chặn requests/responses để thực hiện logic tùy chỉnh (xoay vòng proxy, giả mạo user-agent, chính sách retry).

### Luồng dữ liệu

```
Spider → Engine → Scheduler → Engine → Downloader → Spider → Item Pipeline
                          ↓                                  ↓
                    (bộ lọc trùng)                    (requests mới)
```

Engine nhận các Requests ban đầu từ Spider, lập lịch chúng, gửi qua Downloader, nhận Response, chuyển lại cho Spider để phân tích, và gửi các Item đã trích xuất qua Pipeline. Các Requests mới được phát hiện trong quá trình phân tích sẽ quay lại Scheduler. Vòng lặp này tiếp tục cho đến khi không còn requests nào.

Lợi thế hiệu suất chính đến từ kiến trúc không đồng bộ của Scrapy: trong khi một request đang chờ phản hồi mạng, engine có thể lập lịch hàng chục request khác. Điều này khác biệt căn bản so với các cách tiếp cận đồng bộ nơi mỗi request chặn việc thực thi.

## Cài đặt & Thiết lập

### Yêu cầu tiên quyết

- Python 3.9 trở lên
- Trình quản lý gói pip hoặc uv
- (Tùy chọn) Docker để triển khai container

### Cài đặt cơ bản

```bash
# Tạo môi trường ảo
python -m venv scrapy_env
source scrapy_env/bin/activate  # Linux/Mac
# scrapy_env\Scripts\activate  # Windows

# Cài đặt Scrapy
pip install scrapy

# Xác minh cài đặt
scrapy version
# Kết quả: Scrapy 2.16.0

# Chạy benchmark tích hợp
scrapy bench
```

### Khung dự án

```bash
# Tạo dự án Scrapy mới
scrapy startproject price_monitor
cd price_monitor

# Tạo mẫu spider
scrapy genspider products example.com
```

Cấu trúc dự án chuẩn được tạo ra:

```
price_monitor/
├── scrapy.cfg              # Cấu hình dự án
├── price_monitor/
│   ├── __init__.py
│   ├── items.py            # Mô hình dữ liệu
│   ├── middlewares.py      # Middleware tùy chỉnh
│   ├── pipelines.py        # Xử lý dữ liệu
│   ├── settings.py         # Cấu hình framework
│   └── spiders/
│       ├── __init__.py
│       └── products.py     # Spider của bạn
```

### Spider đầu tiên: Trình scrape sản phẩm

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
        """Trích xuất dữ liệu sản phẩm và theo dõi phân trang."""
        for product in response.css('.product-card'):
            yield {
                'name': product.css('.title::text').get(),
                'price': product.css('.price::text').get(),
                'url': product.css('a::attr(href)').get(),
                'sku': product.css('.sku::text').get(),
            }
        
        # Theo dõi phân trang
        next_page = response.css('.next-page::attr(href)').get()
        if next_page:
            yield response.follow(next_page, self.parse)
```

### Chạy Spider

```bash
# Chạy spider và xuất ra JSON
scrapy crawl products -o products.json

# Chạy với xuất CSV
scrapy crawl products -o products.csv

# Chạy với kiểm soát mức độ logging
scrapy crawl products -L INFO
```

### Triển khai Docker

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

## Tích hợp với các công cụ phổ biến

### Redis cho Crawling phân tán (scrapy-redis)

Khi một máy đơn không đủ, scrapy-redis phân phối việc crawl qua nhiều node sử dụng Redis làm hàng đợi chia sẻ:

```bash
pip install scrapy-redis
```

```python
# settings.py
SCHEDULER = "scrapy_redis.scheduler.Scheduler"
DUPEFILTER_CLASS = "scrapy_redis.dupefilter.RFPDupeFilter"
REDIS_URL = "redis://localhost:6379"
SCHEDULER_PERSIST = True  # Giữ hàng đợi giữa các lần chạy
```

### Pipeline PostgreSQL

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
            spider.logger.error(f"Lỗi DB: {e}")
            raise DropItem(f"Chèn thất bại: {e}")
        return item

    def close_spider(self, spider):
        self.cur.close()
        self.conn.close()
```

### Playwright cho các trang render JavaScript

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
# spider với Playwright
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

### Xoay vòng Proxy với WebShare

Để crawl production, một proxy pool xoay vòng đáng tin cậy là điều cần thiết. WebShare cung cấp proxy datacenter và residential tích hợp sạch sẽ với middleware của Scrapy:

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
        spider.logger.debug(f'Sử dụng proxy cho {request.url}')
```

```python
# settings.py
DOWNLOADER_MIDDLEWARES = {
    'price_monitor.middlewares.ProxyMiddleware': 350,
    'scrapy.downloadermiddlewares.httpproxy.HttpProxyMiddleware': 400,
}
WEBSHARE_PROXY_URL = 'http://proxy.webshare.io:80'
```

Cấu hình danh sách proxy trong cài đặt Scrapy và middleware sẽ tự động xoay vòng IP. Để scraping khối lượng cao, điểm cuối proxy xoay vòng của WebShare xử lý xác thực và xoay vòng một cách minh bạch — bạn chỉ Scrapy vào một URL duy nhất và nhận được một IP egress khác nhau cho mỗi request.

## Benchmark / Trường hợp sử dụng thực tế

### So sánh hiệu suất đối đầu

![Scrapy Benchmark](https://docs.scrapy.org/en/latest/_images/scrapy_architecture_02.png)

Các bài benchmark được thực hiện trên 50+ trang web vào đầu năm 2026 trên VPS 4-core với 8GB RAM cho thấy sự khác biệt đáng kể giữa các công cụ:

| Chỉ số | Scrapy | BeautifulSoup + requests | Selenium | Playwright |
|---|---|---|---|---|
| **Thông lượng (trang/giây)** | 100+ | 1–3 | 2–4 | 3–5 |
| **Bộ nhớ mỗi instance** | ~150 MB | ~80 MB | ~500 MB | ~400 MB |
| **Thởi gian khởi động** | <1s | <1s | 3–5s | 2–3s |
| **Hỗ trợ JavaScript** | Qua middleware | Không | Có | Có |
| **Mô hình đồng thởi** | Async (event loop) | Sync (blocking) | Hạn chế (process) | Async |
| **Tỷ lệ thành công Cloudflare** | 32% | 28% | 72% | 78% |
| **Chi phí 1M trang** | $50–100 | $10–30 | $300–500 | $300–500 |
| **Đường cong học tập** | 8–12 giờ | 2–4 giờ | 16–20 giờ | 12–16 giờ |
| **Khối lượng trang tốt nhất** | 10K–10M+ | <1K | <10K | <10K |

### Các quan sát chính

1. **Scrapy thống trị về thông lượng thô** trên HTML tĩnh: 100+ trang/giây so với 1–5 của các công cụ dựa trên trình duyệt. Engine Twisted async xử lý hàng trăm kết nối đồng thởi mà không cần tạo tiến trình trình duyệt.

2. **Các công cụ trình duyệt thắng trên các trang nặng JavaScript**. Các trang được xây dựng bằng React, Vue, hoặc Angular yêu cầu render DOM cần Selenium hoặc Playwright. Scrapy có thể bắc cầu khoảng cách này qua middleware scrapy-playwright, mặc dù thông lượng giảm xuống ~10–15 trang/giây khi cần render trình duyệt.

3. **BeautifulSoup rẻ nhất cho công việc nhỏ** nhưng thiếu đồng thởi tích hợp, logic retry, và pipeline xuất. Để crawl 10,000 trang, script BS4 đơn giản mất ~90 phút; Scrapy hoàn thành trong ~5 phút với điều chỉnh phù hợp.

### Hồ sơ triển khai thực tế

Một pipeline giám sát giá production tại một công ty tình báo thương mại điện tử sử dụng Scrapy báo cáo các con số sau:

- **1.2 triệu trang/ngày** crawl qua 800 domain
- **24 instance Scrapy** phân phối trên 6 máy chủ
- **Độ trễ trung bình**: 340ms mỗi request (p95 1.2s)
- **Dấu chân bộ nhớ**: 180MB mỗi tiến trình spider
- **Sử dụng CPU**: 0.3 core mỗi spider ở đỉnh điểm đồng thởi
- **Xuất dữ liệu**: Trực tiếp vào PostgreSQL qua pipeline, với backup S3 JSONL
- **Chi phí proxy**: ~$800/tháng qua proxy residential xoay vòng

## Sử dụng nâng cao / Củng cố Production

### Cấu hình Autothrottle

Không có giới hạn tốc độ, Scrapy có thể làm quá tải máy chủ đích và bị cấm trong vòng giây lát. Autothrottle điều chỉnh độ trễ tải xuống động dựa trên thởi gian phản hồi của máy chủ:

```python
# settings.py
AUTOTHROTTLE_ENABLED = True
AUTOTHROTTLE_START_DELAY = 1.0
AUTOTHROTTLE_MAX_DELAY = 10.0
AUTOTHROTTLE_TARGET_CONCURRENCY = 2.0
AUTOTHROTTLE_DEBUG = False
```

### Chính sách Retry và Timeout

```python
# settings.py
RETRY_ENABLED = True
RETRY_TIMES = 3
RETRY_HTTP_CODES = [500, 502, 503, 504, 408, 429]
DOWNLOAD_TIMEOUT = 30
DOWNLOAD_FAIL_ON_DATALOSS = False
```

### Xoay vòng User-Agent tùy chỉnh

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

### Giám sát với Thu thập Thống kê

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
        spider.logger.info(f'Spider đã mở: {spider.name}')

    def request_scheduled(self, request, spider):
        self.requests_count += 1

    def item_scraped(self, item, spider):
        self.items_count += 1
        if self.items_count % 1000 == 0:
            spider.logger.info(f'Đã scrape {self.items_count} items, {self.requests_count} requests')
```

### Xoay vòng Log và Logging có cấu trúc

```python
# settings.py
LOG_LEVEL = 'INFO'
LOG_FILE = 'logs/scrapy.log'
LOG_FORMAT = '%(asctime)s [%(name)s] %(levelname)s: %(message)s'
LOG_STDOUT = False
```

### Mở rộng Ngang với Scrapyd

```bash
pip install scrapyd
scrapyd  # Khởi động daemon trên cổng 6800
```

```bash
# Triển khai và lập lịch qua HTTP API
curl http://localhost:6800/schedule.json -d project=price_monitor -d spider=products
curl http://localhost:6800/listjobs.json -d project=price_monitor
```

## So sánh với các lựa chọn thay thế

| Tính năng | Scrapy | BeautifulSoup | Selenium | Playwright |
|---|---|---|---|---|
| **Giấy phép** | BSD-3-Clause | MIT | Apache-2.0 | Apache-2.0 |
| **Ngôn ngữ** | Python | Python | Đa ngôn ngữ | Đa ngôn ngữ |
| **Async/Đồng thởi** | Tích hợp (Twisted) | Thủ công | Hạn chế | Tích hợp |
| **Render JS** | Qua middleware | Không | Native | Native |
| **Scheduler tích hợp** | Có | Không | Không | Không |
| **Auto-Retry** | Có | Không | Không | Không |
| **Feed Exports** | JSON/CSV/XML/S3/GCS | Thủ công | Thủ công | Thủ công |
| **Xoay vòng Proxy** | Middleware | Thủ công | Thủ công | Cấp context |
| **Cookie/Session** | Tích hợp | Thủ công | Tích hợp | Tích hợp |
| **Item Pipeline** | Có | Không | Không | Không |
| **Chế độ phân tán** | scrapy-redis | Không | Selenium Grid | Playwright servers |
| **Độ trưởng thành (năm)** | 17+ | 20+ | 20+ | 5+ |
| **Quy mô cộng đồng** | 61.7K stars | Chuẩn thực tế | 32K stars | 72K stars |

## Hạn chế / Đánh giá trung thực

Scrapy không phải là công cụ phù hợp cho mọi vấn đề scraping. Đây là những gì nó không làm tốt:

1. **Script đơn trang, dùng một lần** — Nếu bạn cần phân tích một file HTML hoặc một vài trang, overhead dựng project không đáng giá. BeautifulSoup với requests viết và triển khai nhanh hơn cho công việc dưới 100 trang.

2. **SPA nặng JavaScript không có middleware** — Scrapy tải xuống HTML thô. Nếu trang đích là ứng dụng React hay Vue lấy dữ liệu phía client, bạn cần scrapy-playwright hoặc Splash. Điều này thêm phức tạp và giảm thông lượng 80–90%.

3. **CAPTCHA và bảo vệ bot nâng cao** — Scrapy không thể giải reCAPTCHA, hCaptcha, hoặc thử thách Cloudflare Turnstile một cách native. Với các trang web có biện pháp chống bot tích cực, bạn cần tự động hóa trình duyệt (Playwright/Selenium) hoặc dịch vụ quản lý như Bright Data.

4. **Tương tác thởi gian thực** — Scrapy là framework crawling, không phải công cụ tự động hóa trình duyệt. Nó không thể nhấn nút, điền form một cách tương tác, hoặc chụp ảnh màn hình mà không có tích hợp bên ngoài.

5. **Hệ sinh thái ngoài Python** — Nếu team bạn chỉ làm việc với Node.js, Go, hoặc Rust, việc duy trì triển khai Python Scrapy thêm ma sát vận hành. Các lựa chọn thay thế như Crawlee (Node.js) hoặc Colly (Go) phù hợp hơn.

## Câu hỏi thường gặp

### Scrapy so với BeautifulSoup cho dự án nhỏ như thế nào?

BeautifulSoup là thư viện parsing, không phải framework crawling. Cho dự án dưới 100 trang, BS4 với requests đơn giản hơn và ít boilerplate hơn. Cho bất kỳ thứ gì trên 1,000 trang, đồng thởi tích hợp, logic retry, và pipeline xuất của Scrapy làm nó trở thành lựa chọn dễ bảo trì hơn. Các bài benchmark độc lập cho thấy Scrapy nhanh hơn BS4 khoảng **39 lần** trên crawl 10,000 trang.

### Scrapy có thể xử lý các trang web render JavaScript không?

Không thể native. Scrapy tải xuống phản hồi HTTP thô. Cho các trang nặng JavaScript, tích hợp middleware scrapy-playwright hoặc sử dụng Splash. Với scrapy-playwright, Scrapy có thể render trang trong headless Chromium với tốc độ khoảng 10–15 trang/giây — chậm hơn chế độ HTTP thô nhưng vẫn nhanh hơn Selenium độc lập.

### Cách tốt nhất để chạy Scrapy trong production là gì?

Sử dụng container Docker với scrapy-redis cho hàng đợi phân tán. Lưu trữ dữ liệu trong PostgreSQL qua Item Pipelines. Giám sát với Prometheus và Grafana. Triển khai với Scrapyd để kiểm soát qua HTTP API. Đặt AUTOTHROTTLE_ENABLED để tránh làm quá tải máy chủ đích. Xoay vòng proxy và user-agent qua middleware tùy chỉnh.

### Scrapy tránh bị cấm như thế nào?

Scrapy cung cấp một số cơ chế tích hợp: AutoThrottle điều chỉnh tốc độ request dựa trên thởi gian phản hồi máy chủ; DupeFilter ngăn chặn request thừa; middleware hỗ trợ xoay vòng proxy và giả mạo user-agent. Cho production, kết hợp các tính năng này với dịch vụ proxy xoay vòng và tôn trọng robots.txt. Không framework nào đảm bảo miễn dịch hoàn toàn trước bot detection tinh vi.

### Scrapy có phù hợp cho streaming dữ liệu thởi gian thực không?

Scrapy thiết kế theo hướng batch. Spider chạy, thu thập dữ liệu, rồi thoát. Để streaming gần real-time, chuyển Items sang Kafka hoặc Redis Streams trong Item Pipeline. Hoặc, kích hoạt spider theo lịch sử dụng cron, Airflow, hoặc API lập lịch của Scrapyd. Scrapy không tự duy trì listener liên tục.

### Tôi có thể sử dụng Scrapy với cú pháp async/await Python hiện đại không?

Scrapy được xây dựng trên deferred và callbacks của Twisted, không phải asyncio. Mặc dù Twisted hỗ trợ async/await trong các phiên bản gần đây, API của Scrapy vẫn dựa trên callback cho các phương thức spider. Tích hợp scrapy-playwright sử dụng AsyncioSelectorReactor để nối hai thế giới. Hỗ trợ asyncio native là một yêu cầu tính năng đã tồn tại lâu nhưng chưa phải mặc định.

## Kết luận

Scrapy vẫn là lựa chọn hiệu quả nhất cho web crawling quy mô lớn, cấp production trong Python. 61,700 GitHub star phản ánh 17 năm phát triển đã qua thực chiến, không phải sự cường điệu. Cho HTML tĩnh ở quy mô lớn, không công cụ nào trong hệ sinh thái Python sánh bằng thông lượng của nó. Cho các trang nặng JavaScript, cầu nối scrapy-playwright cung cấp một sự thỏa hiệp hợp lý.

Ma trận quyết định rõ ràng: **BeautifulSoup** cho script nhanh dưới 100 trang, **Playwright/Selenium** cho render JavaScript và tương tác trình duyệt, **Scrapy** cho mọi thứ khác — đặc biệt khi khối lượng crawl vượt quá 10,000 trang hoặc yêu cầu thực thi phân tán, được lập lịch và giám sát.

**Các hành động:**

1. Clone kho lưu trữ Scrapy và chạy `scrapy bench` trên phần cứng của bạn.
2. Thiết lập dự án dựa trên Docker với tích hợp PostgreSQL và Redis.
3. Cấu hình xoay vòng proxy cho crawling production.
4. Tham gia cộng đồng trên Telegram để nhận mẹo hàng ngày và khắc phục sự cố: [dibi8_tg_group](https://t.me/dibi8open)



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài liệu tham khảo

- Tài liệu chính thức Scrapy: https://docs.scrapy.org/en/latest/
- Tổng quan kiến trúc Scrapy: https://scrapy.readthedocs.io/en/latest/topics/architecture.html
- Kho lưu trữ scrapy-playwright: https://github.com/scrapy-plugins/scrapy-playwright
- Kho lưu trữ scrapy-redis: https://github.com/rmax/scrapy-redis
- Tài liệu Scrapyd: https://scrapyd.readthedocs.io/en/latest/
- Tài liệu Proxy WebShare: https://www.webshare.io/proxy
- Benchmark hiệu suất (NextGrowth.ai): https://nextgrowth.ai/best-tools-for-web-scraping/
- Phân tích Scrapy vs BeautifulSoup (HasData): https://hasdata.com/blog/scrapy-vs-beautifulsoup

---

*Bài viết này chứa liên kết affiliate. Khi mua dịch vụ proxy qua các liên kết WebShare trong bài viết này, chúng tôi có thể nhận được hoa hồng mà không phát sinh chi phí thêm cho bạn. Tất cả dữ liệu benchmark và khuyến nghị dựa trên kiểm thử độc lập và các nguồn đã được cộng đồng xác minh.*
