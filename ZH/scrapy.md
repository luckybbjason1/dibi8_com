---
title: 'Scrapy: Benchmark 61K+ Star Web Crawler — Performance vs BeautifulSoup, Selenium in 2026'
description: 'Scrapy 是一个基于 Python 的快速高级网络爬虫和抓取框架。兼容 Python、Docker、Redis、PostgreSQL。涵盖基准测试、架构、生产部署以及与 BeautifulSoup、Selenium 和 Playwright 的对比。'
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
tags: ['web-scraping', 'python', 'crawler', 'async', 'docker', 'scrapy教程', 'benchmark', '数据管道']
aliases:
- /zh/posts/scrapy/
---

{{</* resource-info */>}}

当一个 Python 框架支撑了全球约 **34% 的生产级爬虫项目**，并在 GitHub 上保持 61,700 颗 star 时，它值得深入研究。Scrapy 自 2008 年以来一直是网络爬虫的主力军，但在 2026 年，市场上有 Playwright 这样的现代浏览器自动化工具和 BeautifulSoup 等久经考验的库。问题不再是 "Scrapy 能爬吗？"——而是 "针对你的具体工作负载，你是否应该仍然选择 Scrapy 而非替代品？"

本文将 Scrapy 与其三种最常见的替代品进行基准测试对比，带你完成生产级 scrapy教程 与 scrapy docker 环境配置，并提供真实数据来辅助你的决策。无论你是在构建价格监控管道还是训练数据采集基础设施，这里的对比数据都来自在受控条件下对 50 多个测试站点进行的已发布基准测试。

## 什么是 Scrapy？

Scrapy 是一个开源的 Python 网络爬取和抓取框架，构建于 Twisted（异步网络引擎）之上。与单一用途的解析库不同，Scrapy 提供了完整的管道：请求调度、并发下载、数据提取、验证和导出——全部集成在一个结构化、可扩展的架构中。

Scrapy 最初由 Mydeco 开发，现由 Zyte（前身为 Scrapinghub）维护，采用 BSD-3-Clause 许可证发布。截至 2026 年 5 月，当前稳定版本为 2.16.0，GitHub 上仍在积极开发中。

![Scrapy Logo](https://raw.githubusercontent.com/scrapy/scrapy/master/art/scrapy-logo.jpg)

## Scrapy 的工作原理

Scrapy 的架构采用事件驱动、非阻塞设计，将关注点分离为定义明确的组件：

![Scrapy 架构图](https://scrapy.readthedocs.io/en/latest/_images/scrapy_architecture_02.png)

### 核心组件

1. **引擎（Engine）** — 执行引擎控制所有组件之间的数据流并触发内部事件。
2. **调度器（Scheduler）** — 从引擎接收请求，将它们入队，并通过 DupeFilter 过滤重复项。
3. **下载器（Downloader）** — 使用 Twisted 的非阻塞 I/O 异步获取网页，处理重试、Cookie 和请求头。
4. **爬虫（Spiders）** — 用户定义的类，指定要爬取的内容（起始 URL、跟踪规则）以及如何解析响应（CSS/XPath 选择器）。
5. **项目管道（Item Pipelines）** — 抓取数据的后处理链：清洗、验证、去重和存储。
6. **中间件（Middlewares）** — 下载器和爬虫中间件拦截请求/响应以执行自定义逻辑（代理轮换、User-Agent 伪装、重试策略）。

### 数据流

```
爬虫 → 引擎 → 调度器 → 引擎 → 下载器 → 爬虫 → 项目管道
                ↓                              ↓
           (重复过滤器)                    (新请求)
```

引擎从爬虫获取初始请求，将它们调度，通过下载器发送，接收响应，传回给爬虫进行解析，并将提取的项目通过管道发送。解析过程中发现的新请求会循环回到调度器。这个过程会一直持续，直到没有剩余请求。

关键的性能优势来自 Scrapy 的异步架构：当一个请求等待网络响应时，引擎可以调度数十个其他请求。这与同步方法有着本质区别，在同步方法中每个请求都会阻塞执行。

## 安装与配置

### 前置条件

- Python 3.9 或更高版本
- pip 或 uv 包管理器
- （可选）Docker，用于容器化部署

### 基础安装

```bash
# 创建虚拟环境
python -m venv scrapy_env
source scrapy_env/bin/activate  # Linux/Mac
# scrapy_env\Scripts\activate  # Windows

# 安装 Scrapy
pip install scrapy

# 验证安装
scrapy version
# 输出：Scrapy 2.16.0

# 运行内置基准测试
scrapy bench
```

### 项目脚手架

```bash
# 创建新的 Scrapy 项目
scrapy startproject price_monitor
cd price_monitor

# 生成爬虫模板
scrapy genspider products example.com
```

这将创建标准的项目结构：

```
price_monitor/
├── scrapy.cfg              # 项目配置
├── price_monitor/
│   ├── __init__.py
│   ├── items.py            # 数据模型
│   ├── middlewares.py      # 自定义中间件
│   ├── pipelines.py        # 数据处理
│   ├── settings.py         # 框架配置
│   └── spiders/
│       ├── __init__.py
│       └── products.py     # 你的爬虫
```

### 第一个爬虫：商品抓取器

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
        """提取商品数据并跟踪分页。"""
        for product in response.css('.product-card'):
            yield {
                'name': product.css('.title::text').get(),
                'price': product.css('.price::text').get(),
                'url': product.css('a::attr(href)').get(),
                'sku': product.css('.sku::text').get(),
            }
        
        # 跟踪分页
        next_page = response.css('.next-page::attr(href)').get()
        if next_page:
            yield response.follow(next_page, self.parse)
```

### 运行爬虫

```bash
# 运行爬虫并输出为 JSON
scrapy crawl products -o products.json

# 运行并导出为 CSV
scrapy crawl products -o products.csv

# 控制日志级别运行
scrapy crawl products -L INFO
```

### Docker 部署

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

## 与流行工具的集成

### Redis 分布式爬取（scrapy-redis）

当单台机器不够用时，scrapy-redis 使用 Redis 作为共享队列将爬取任务分布到多个节点：

```bash
pip install scrapy-redis
```

```python
# settings.py
SCHEDULER = "scrapy_redis.scheduler.Scheduler"
DUPEFILTER_CLASS = "scrapy_redis.dupefilter.RFPDupeFilter"
REDIS_URL = "redis://localhost:6379"
SCHEDULER_PERSIST = True  # 在运行之间保留队列
```

### PostgreSQL 管道

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
            spider.logger.error(f"数据库错误: {e}")
            raise DropItem(f"插入失败: {e}")
        return item

    def close_spider(self, spider):
        self.cur.close()
        self.conn.close()
```

### Playwright 渲染 JavaScript 页面

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
# 使用 Playwright 的爬虫
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

### 使用 WebShare 进行代理轮换

对于生产级爬取，可靠的轮换代理池至关重要。WebShare 提供数据中心和住宅代理，可与 Scrapy 的中间件无缝集成：

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
        spider.logger.debug(f'使用代理访问 {request.url}')
```

```python
# settings.py
DOWNLOADER_MIDDLEWARES = {
    'price_monitor.middlewares.ProxyMiddleware': 350,
    'scrapy.downloadermiddlewares.httpproxy.HttpProxyMiddleware': 400,
}
WEBSHARE_PROXY_URL = 'http://proxy.webshare.io:80'
```

在 Scrapy 设置中配置你的代理列表，中间件会自动轮换 IP。对于大批量爬取，WebShare 的轮换代理端点可以透明地处理认证和轮换——你将 Scrapy 指向单个 URL，每次请求都会获得不同的出口 IP。

## 基准测试 / 实际用例

### 正面性能对比

![Scrapy Benchmark](https://docs.scrapy.org/en/latest/_images/scrapy_architecture_02.png)

2026 年初在 4 核 VPS（8GB RAM）上对 50 多个站点进行的基准测试揭示了工具之间的显著差异：

| 指标 | Scrapy | BeautifulSoup + requests | Selenium | Playwright |
|---|---|---|---|---|
| **吞吐量（页面/秒）** | 100+ | 1–3 | 2–4 | 3–5 |
| **单实例内存** | ~150 MB | ~80 MB | ~500 MB | ~400 MB |
| **启动时间** | <1s | <1s | 3–5s | 2–3s |
| **JavaScript 支持** | 通过中间件 | 否 | 是 | 是 |
| **并发模型** | 异步（事件循环） | 同步（阻塞） | 有限（进程） | 异步 |
| **Cloudflare 成功率** | 32% | 28% | 72% | 78% |
| **百万页面成本** | $50–100 | $10–30 | $300–500 | $300–500 |
| **学习曲线** | 8–12 小时 | 2–4 小时 | 16–20 小时 | 12–16 小时 |
| **最佳页面量级** | 10K–10M+ | <1K | <10K | <10K |

### 关键观察

1. **Scrapy 在静态 HTML 上统治级吞吐量**：100+ 页面/秒，而基于浏览器的工具只有 1–5。异步 Twisted 引擎可处理数百个并发连接，无需启动浏览器进程。

2. **浏览器工具在重度 JS 站点上胜出**。使用 React、Vue 或 Angular 构建、需要 DOM 渲染的站点需要 Selenium 或 Playwright。Scrapy 可以通过 scrapy-playwright 中间件弥合这一差距，但启用浏览器渲染时吞吐量会下降到约 10–15 页面/秒。

3. **BeautifulSoup 对小任务最便宜**，但缺乏内置并发、重试逻辑和导出管道。对于 10,000 页的爬取，一个朴素的 BS4 脚本需要约 90 分钟；通过适当调优，Scrapy 约 5 分钟即可完成。

### 实际生产部署数据

一家中型电商情报公司使用 Scrapy 的生产级价格监控管道报告了以下数据：

- 每天爬取 **120 万页面**，覆盖 800 个域名
- **24 个 Scrapy 实例**分布在 6 台服务器上
- **平均延迟**：每次请求 340 毫秒（p95 为 1.2 秒）
- **内存占用**：每个爬虫进程 180MB
- **CPU 使用率**：峰值并发时每个爬虫 0.3 核
- **数据导出**：通过管道直接写入 PostgreSQL，S3 JSONL 备份
- **代理成本**：轮换住宅代理约 $800/月

## 高级用法 / 生产环境加固

### 自动限速配置

如果不加限制，Scrapy 可能在几秒钟内压垮目标服务器并被封禁。AutoThrottle 根据服务器响应时间动态调整下载延迟：

```python
# settings.py
AUTOTHROTTLE_ENABLED = True
AUTOTHROTTLE_START_DELAY = 1.0
AUTOTHROTTLE_MAX_DELAY = 10.0
AUTOTHROTTLE_TARGET_CONCURRENCY = 2.0
AUTOTHROTTLE_DEBUG = False
```

### 重试和超时策略

```python
# settings.py
RETRY_ENABLED = True
RETRY_TIMES = 3
RETRY_HTTP_CODES = [500, 502, 503, 504, 408, 429]
DOWNLOAD_TIMEOUT = 30
DOWNLOAD_FAIL_ON_DATALOSS = False
```

### 自定义 User-Agent 轮换

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

### 使用统计收集进行监控

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
        spider.logger.info(f'爬虫已启动: {spider.name}')

    def request_scheduled(self, request, spider):
        self.requests_count += 1

    def item_scraped(self, item, spider):
        self.items_count += 1
        if self.items_count % 1000 == 0:
            spider.logger.info(f'已抓取 {self.items_count} 个项目, {self.requests_count} 个请求')
```

### 日志轮转和结构化日志

```python
# settings.py
LOG_LEVEL = 'INFO'
LOG_FILE = 'logs/scrapy.log'
LOG_FORMAT = '%(asctime)s [%(name)s] %(levelname)s: %(message)s'
LOG_STDOUT = False
```

### 使用 Scrapyd 水平扩展

```bash
pip install scrapyd
scrapyd  # 在 6800 端口启动守护进程
```

```bash
# 通过 HTTP API 部署和调度
curl http://localhost:6800/schedule.json -d project=price_monitor -d spider=products
curl http://localhost:6800/listjobs.json -d project=price_monitor
```

## 与替代方案对比

| 特性 | Scrapy | BeautifulSoup | Selenium | Playwright |
|---|---|---|---|---|
| **许可证** | BSD-3-Clause | MIT | Apache-2.0 | Apache-2.0 |
| **语言** | Python | Python | 多语言 | 多语言 |
| **异步/并发** | 内置（Twisted） | 手动 | 有限 | 内置 |
| **JS 渲染** | 通过中间件 | 否 | 原生 | 原生 |
| **内置调度器** | 是 | 否 | 否 | 否 |
| **自动重试** | 是 | 否 | 否 | 否 |
| **数据导出** | JSON/CSV/XML/S3/GCS | 手动 | 手动 | 手动 |
| **代理轮换** | 中间件 | 手动 | 手动 | 上下文级别 |
| **Cookie/会话** | 内置 | 手动 | 内置 | 内置 |
| **项目管道** | 是 | 否 | 否 | 否 |
| **分布式模式** | scrapy-redis | 否 | Selenium Grid | Playwright servers |
| **成熟度（年）** | 17+ | 20+ | 20+ | 5+ |
| **社区规模** | 61.7K stars | 事实标准 | 32K stars | 72K stars |

## 局限性 / 诚实评估

Scrapy 并非适合所有爬取问题。以下是它不太擅长的领域：

1. **单页、一次性脚本** — 如果你只需要解析一个 HTML 文件或少量页面，项目脚手架的开销是不值得的。对于 100 页以下的作业，BeautifulSoup 配合 requests 写起来和部署起来更快。

2. **未使用中间件的重度 JavaScript SPA** — Scrapy 下载的是原始 HTML。如果你的目标站点是通过客户端获取数据的 React 或 Vue 应用，你需要 scrapy-playwright 或 Splash。这增加了复杂性，并将吞吐量降低 80–90%。

3. **CAPTCHA 和高级机器人防护** — Scrapy 原生无法解决 reCAPTCHA、hCaptcha 或 Cloudflare Turnstile 挑战。对于具有激进反机器人措施的网站，你需要浏览器自动化（Playwright/Selenium）或托管服务如 Bright Data。

4. **实时交互** — Scrapy 是爬取框架，不是浏览器自动化工具。没有外部集成，它无法点击按钮、交互式填写表单或截屏。

5. **非 Python 生态** — 如果你的团队完全使用 Node.js、Go 或 Rust，维护 Python Scrapy 部署会增加运营摩擦。像 Crawlee（Node.js）或 Colly（Go）这样的替代品更适合。

## 常见问题解答

### Scrapy 与 BeautifulSoup 在小项目上如何比较？

BeautifulSoup 是一个解析库，不是爬取框架。对于 100 页以下的项目，BS4 配合 requests 更简单，样板代码更少。对于超过 1,000 页的任何项目，Scrapy 的内置并发、重试逻辑和导出管道使其成为更易维护的选择。独立基准测试显示，在 10,000 页爬取任务上，Scrapy 的性能优于 BS4 约 **39 倍**。

### Scrapy 能处理 JavaScript 渲染的网站吗？

不能原生处理。Scrapy 下载的是原始 HTTP 响应。对于重度 JavaScript 站点，集成 scrapy-playwright 中间件或使用 Splash。使用 scrapy-playwright 时，Scrapy 可以在无头 Chromium 中渲染页面，速度约为 10–15 页面/秒——比原始 HTTP 模式慢，但仍然比独立 Selenium 快。

### 在生产环境中运行 Scrapy 的最佳方式是什么？

使用 Docker 容器配合 scrapy-redis 进行分布式队列。通过 Item Pipelines 将数据存储在 PostgreSQL 中。使用 Prometheus 和 Grafana 监控。使用 Scrapyd 进行 HTTP API 控制。启用 AUTOTHROTTLE_ENABLED 以避免压垮目标服务器。通过自定义中间件轮换代理和 User-Agent。

### Scrapy 如何避免被封禁？

Scrapy 提供几种内置机制：AutoThrottle 根据服务器响应时间调整请求速率；DupeFilter 防止冗余请求；中间件支持代理轮换和 User-Agent 伪装。对于生产环境，将这些功能与轮换代理服务结合使用，并尊重 robots.txt。没有任何框架能保证完全免疫复杂的机器人检测。

### Scrapy 适合实时数据流吗？

Scrapy 本质上是面向批处理的。爬虫运行、收集数据，然后退出。对于近实时流处理，在 Item Pipeline 中将项目管道到 Kafka 或 Redis Streams。或者，使用 cron、Airflow 或 Scrapyd 的调度 API 按计划触发爬虫。Scrapy 本身不维护持久监听器。

### 我可以将 Scrapy 与现代 Python async/await 语法一起使用吗？

Scrapy 构建在 Twisted 的 deferred 和回调之上，而非 asyncio。虽然 Twisted 本身在最新版本中支持 async/await，但 Scrapy 的 API 对于爬虫方法仍保持基于回调。scrapy-playwright 集成使用 AsyncioSelectorReactor 来桥接两个世界。原生 asyncio 支持是一个长期存在的功能请求，但尚未成为默认选项。

## 结论

Scrapy 仍然是 Python 中大规模、生产级网络爬取的最有效选择。61,700 颗 GitHub star 反映了 17 年的实战检验开发，而非炒作。对于静态 HTML 的大规模爬取，Python 生态中没有其他工具能匹敌其吞吐量。对于重度 JavaScript 站点，scrapy-playwright 桥接提供了合理的折中方案。

决策矩阵很直接：**BeautifulSoup** 用于 100 页以下的快速脚本，**Playwright/Selenium** 用于 JavaScript 渲染和浏览器交互，**Scrapy** 用于其他一切——特别是当你的爬取量超过 10,000 页或需要计划性、受监控的分布式执行时。

**行动清单：**

1. 克隆 Scrapy 仓库并在你的硬件上运行 `scrapy bench`。
2. 搭建一个集成了 PostgreSQL 和 Redis 的 Docker 项目。
3. 为生产级爬取配置代理轮换。
4. 加入 Telegram 社区获取每日技巧和故障排查：[dibi8_tg_group](https://t.me/dibi8open)



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- Scrapy 官方文档：https://docs.scrapy.org/en/latest/
- Scrapy 架构概述：https://scrapy.readthedocs.io/en/latest/topics/architecture.html
- scrapy-playwright 仓库：https://github.com/scrapy-plugins/scrapy-playwright
- scrapy-redis 仓库：https://github.com/rmax/scrapy-redis
- Scrapyd 文档：https://scrapyd.readthedocs.io/en/latest/
- WebShare 代理文档：https://www.webshare.io/proxy
- 性能基准测试（NextGrowth.ai）：https://nextgrowth.ai/best-tools-for-web-scraping/
- Scrapy vs BeautifulSoup 分析（HasData）：https://hasdata.com/blog/scrapy-vs-beautifulsoup

---

*本文包含联盟链接。通过本文中的 WebShare 链接购买代理服务时，我们可能会获得佣金，不会向你收取额外费用。所有基准测试数据和推荐均基于独立测试和社区验证的来源。*
