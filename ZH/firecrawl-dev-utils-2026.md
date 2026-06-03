---
title: 'Firecrawl：把任意网站变成 LLM 可直接使用的数据（127K Stars）——2026 实战指南'
description: 'Firecrawl 是开源的网页数据 API，能把网页抓取、爬取、映射、搜索成干净、可直接喂给 LLM 的 Markdown 或结构化 JSON。127,747 GitHub stars，AGPL-3.0。涵盖安装、官方 SDK、真实代码、自托管，以及与 Puppeteer、Scrapy、Axios 的客观对比。'
date: 2026-06-02 00:00:00+08:00
lastmod: 2026-06-02 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'firecrawl/firecrawl'
stars: 127747
maintainer: 'firecrawl'
last_maintained: '2026-06-02'
featureImage: 'https://raw.githubusercontent.com/firecrawl/firecrawl/main/img/open-source-cloud.png'
draft: false
categories: ['dev-utils']
tags: []
aliases:
- /posts/firecrawl-dev-utils-2026/
faqs:
  - q: '如何安装 Firecrawl？'
    a: '安装一个官方 SDK 即可。Node.js： ```bash npm install firecrawl ``` Python： ```bash pip install firecrawl-py ``` 然后用你从 [firecrawl.dev](https://firecrawl.dev) 获取的 API key 创建客户端。'
  - q: '除了 TypeScript，我能用别的语言使用 Firecrawl 吗？'
    a: '可以。Firecrawl 是一个 HTTP API，因此任何语言都能调用它。官方提供了 Node.js 和 Python 的 SDK，其他语言也可以用任意 HTTP 客户端直接请求 REST 端点。'
  - q: '我必须用托管 API，还是可以自托管？'
    a: '两者都支持。位于 `api.firecrawl.dev` 的托管 API 是最快的上手方式，但该项目本身是开源的，并附带 Docker Compose 配置，因此你可以把整套东西跑在自己的服务器上。'
  - q: 'scrape、crawl 和 map 有什么区别？'
    a: '`scrape` 处理单个 URL。`crawl` 会沿链接异步抓取整个站点。`map` 只返回站点上的 URL 列表，而不抓取其内容——适合用来规划爬取。'
  - q: 'Firecrawl 免费吗？它用什么协议？'
    a: '源代码在 AGPL-3.0 下免费且开源，官方 SDK 与 UI 组件则采用 MIT。托管云端 API 有免费额度，并提供更高用量的付费套餐。如果自托管，你需自行承担运行的基础设施成本。'
---

{{< resource-info >}}

## 引言

只要你试过把网页喂给 LLM，就会懂那种痛：原始 HTML 里塞满导航栏、广告、脚本和乱掉的排版，既浪费 token 又让模型犯迷糊。**Firecrawl** 正是为解决这个问题而生。它是一个开源的网页数据 API，能把任意 URL——甚至整个网站——转换成干净、可直接喂给 LLM 的 Markdown、结构化 JSON 或截图。凭借 GitHub 上超过 127,000 个 star，它已成为「把网页变成 AI 应用能用的数据」这一需求中最受欢迎的工具之一。本指南将带你了解 Firecrawl 能做什么、如何安装、可运行的真实代码、自托管方式，以及它与常见替代品的对比。

![firecrawl overview, via dibi8.com](https://raw.githubusercontent.com/firecrawl/firecrawl/main/img/open-source-cloud.png)

*firecrawl overview (source: firecrawl/firecrawl repo, via dibi8 analysis)*

## Firecrawl 是什么？

Firecrawl 是一个用于大规模搜索、抓取和爬取网站的网页数据 API，其明确目标就是产出可直接喂给 LLM 的内容。它不会把原始 HTML 丢给你，而是替你搞定那些棘手的环节——JavaScript 渲染、代理、反爬机制和内容清洗——最终交付 Markdown 或结构化 JSON。

它提供两种使用方式：托管的云端 API（地址 `api.firecrawl.dev`，注册即可获取 API key），以及可用 Docker 自托管的完全开源版本。核心代码采用 AGPL-3.0 协议，官方 SDK 和 UI 组件则为 MIT 协议。凭借 127,000+ 的 GitHub star 数和 Firecrawl 团队的持续维护，对于生产级 AI 数据管线而言，它是一个有充分支撑的选择。

## Firecrawl 如何工作

Firecrawl 暴露了一小组端点，每个只解决一件事。你用 Bearer API key（格式为 `fc-...`）做认证，按需调用其中之一：

1. **Scrape（抓取）**——把单个 URL 转换成 Markdown、HTML、截图或结构化 JSON。Firecrawl 会替你渲染 JavaScript 并剔除冗余内容。

2. **Crawl（爬取）**——只需给它一个 URL，Firecrawl 就会发现并抓取站点内所有可达页面，并遵守 `robots.txt`。爬取是异步进行的：你启动一个任务，然后轮询获取结果。

3. **Map（映射）**——瞬间返回一个站点上的全部 URL，便于规划爬取或生成站点地图。

4. **Search（搜索）**——对全网发起查询，拿回的是结果页面的完整内容，而不只是链接。

5. **Interact 与 Extract（交互与抽取）**——在抓取前对页面执行操作（点击、滚动、输入），并按你定义的 schema 提取结构化数据。

用 Node SDK 做一次最简抓取是这样的：

```typescript
import { Firecrawl } from 'firecrawl';

const app = new Firecrawl({ apiKey: 'fc-YOUR_API_KEY' });

const doc = await app.scrape('https://example.com', {
  formats: ['markdown'],
});

console.log(doc.markdown);
```

Firecrawl 是一个成熟的开源项目，背后有庞大的社区，这从它在 GitHub 上 127k+ 的 star 数便可见一斑。

![firecrawl architecture, via dibi8.com](https://raw.githubusercontent.com/firecrawl/firecrawl/main/img/firecrawl_logo.png)

*firecrawl architecture (source: firecrawl/firecrawl repo, via dibi8 analysis)*

## 安装与配置

对大多数人来说，最快的路径是用托管 API：到 [firecrawl.dev](https://firecrawl.dev) 注册，拿到 API key，再装一个 SDK。如果你想自托管，则需要一台常驻在线的机器——可以在 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) 开一台（新账号有免费试用额度），或选 [HTStack](https://my.htstack.com/aff.php?aff=27187) 的低延迟香港 VPS（与托管 dibi8.com 的是同一家 IDC）。

### Node.js SDK

```bash
npm install firecrawl
```

```typescript
import { Firecrawl } from 'firecrawl';

const app = new Firecrawl({ apiKey: 'fc-YOUR_API_KEY' });
```

### Python SDK

```bash
pip install firecrawl-py
```

```python
from firecrawl import Firecrawl

app = Firecrawl(api_key="fc-YOUR_API_KEY")
```

### 用 Docker 自托管

如果你更愿意把 Firecrawl 跑在自己的基础设施上，克隆仓库并使用自带的 Docker Compose 配置：

```bash
git clone https://github.com/firecrawl/firecrawl.git
cd firecrawl
docker compose up
```

这会启动 API 及其 worker。API 默认监听 `3002` 端口，因此你可以通过 `http://localhost:3002` 访问。把 SDK 指向自托管实例，只需设置 API 地址：

```typescript
const app = new Firecrawl({
  apiKey: 'fc-YOUR_API_KEY',
  apiUrl: 'http://localhost:3002',
});
```

### 配置

自托管通过环境变量进行配置。复制提供的模板并编辑：

```bash
cp apps/api/.env.example apps/api/.env
```

常用的配置项包括 `PORT`、`NUM_WORKERS_PER_QUEUE`，以及代理和渲染相关的可选集成。完整列表请参见仓库中的自托管指南。如果用托管 API，这一切都可以跳过——你唯一必须设置的就是 API key。

## 核心用法

下面是针对托管 API 的常见操作，使用 Node SDK。Python SDK 的方法与之一一对应。

### 抓取单个页面

```typescript
import { Firecrawl } from 'firecrawl';

const app = new Firecrawl({ apiKey: 'fc-YOUR_API_KEY' });

const doc = await app.scrape('https://example.com', {
  formats: ['markdown', 'html'],
});

console.log(doc.markdown);
```

### 爬取整个站点

`crawl` 会发现并抓取每一个可达页面。你可以限制页面数量，也可以限制爬取深度：

```typescript
const result = await app.crawl('https://example.com', {
  limit: 100,
  scrapeOptions: { formats: ['markdown'] },
});

for (const page of result.data) {
  console.log(page.metadata?.sourceURL, page.markdown?.slice(0, 80));
}
```

### 抽取结构化数据

传入一个 JSON schema，Firecrawl 就会返回带类型的数据，而非原始文本——非常适合提取标题、价格或任何固定字段：

```typescript
const doc = await app.scrape('https://example.com', {
  formats: [{
    type: 'json',
    schema: {
      type: 'object',
      properties: {
        title: { type: 'string' },
        description: { type: 'string' },
      },
    },
  }],
});

console.log(doc.json);
```

更多细节请查阅[官方文档](https://docs.firecrawl.dev)。

## 集成

由于 Firecrawl 本质上只是一个带轻量 SDK 的 HTTP API，它几乎能融入任何技术栈——Next.js、Express、Python 数据管线，或是 LangChain / LlamaIndex 的 RAG 应用（此时它充当文档加载器）。

### 在服务端路由中使用

一种典型做法是把抓取封装在你自己的端点之后：

```typescript
import { Firecrawl } from 'firecrawl';

const app = new Firecrawl({ apiKey: process.env.FIRECRAWL_API_KEY });

export async function scrapeHandler(url: string) {
  const doc = await app.scrape(url, { formats: ['markdown'] });
  return doc.markdown;
}
```

### 在 CI/CD 中跑定时爬取

对于周期性任务，可以从 GitHub Actions、GitLab CI 或任意调度器运行 Firecrawl。下面是一个简单的 GitHub Actions 工作流，每次 push 时抓取一个页面并保存为 Markdown：

```yaml
name: Firecrawl Scraper

on:
  push:
    branches: [ main ]

jobs:
  scrape:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm install firecrawl

      - name: Run scraper
        env:
          FIRECRAWL_API_KEY: ${{ secrets.FIRECRAWL_API_KEY }}
        run: node scrape.js > output.json
```

这样你的抓取任务既自动化又可复现，而 API key 存放在仓库 secrets 中，而非硬编码进代码。

### 小结

Firecrawl 以 API 为先的设计让它很容易接入现有项目。无论你是在为 RAG 管线供数据，还是要按计划刷新数据集，几行代码即可搞定。

## 性能表现与真实场景

Firecrawl 被用于各类生产场景。下面的数字旨在说明团队会跑的工作负载类型，并非官方厂商基准。

### 真实用例

#### 为 RAG 与 AI 搜索供数据
许多团队把 Firecrawl 当作检索增强生成（RAG）的数据摄取层：爬取一个文档站或知识库，拿到干净的 Markdown，切块后做嵌入。可直接喂给 LLM 的输出省去了原始 HTML 抓取通常需要的大部分预处理。

#### 竞品与电商监控
团队按计划爬取商品和价格页面，使商品目录与比价数据保持最新。得益于 JavaScript 渲染，单页应用（SPA）型店铺无需自己编写浏览器自动化即可处理。

#### 大规模 SEO 与内容审计
代理机构会对大型站点进行爬取，以盘点页面、发现死链、标记过时内容。`map` 端点在这里很好用——在投入更深的爬取之前，先拿到完整的 URL 列表。

### 性能说明

托管 API 的吞吐量取决于你套餐的并发上限，也取决于目标站点自身的限流与反爬机制。自托管允许你用 `NUM_WORKERS_PER_QUEUE` 调节并发，但随之你要自行承担代理与渲染的基础设施。一个经验法则：把爬取任务按「每分钟多少页」来规划，而不要把 Firecrawl 当成一个亚 100 毫秒的实时请求层。

![firecrawl contributors, via dibi8.com](https://contrib.rocks/image?repo=firecrawl/firecrawl)

*firecrawl contributors (source: firecrawl/firecrawl repo, via dibi8 analysis)*

## 与替代品对比

另请参阅我们的[相关开源工具](dibi8-internal-link)专题。

先把 Firecrawl 是什么、不是什么讲清楚会很有帮助。Firecrawl 是一个面向「LLM 可用输出」的托管（或可自托管）网页数据 API。Puppeteer 是浏览器自动化库，Scrapy 是 Python 爬虫框架，Axios 是通用 HTTP 客户端。它们在「从网上取数据」这点上有重叠，但处在不同的层次。

| 特性               | firecrawl/firecrawl      | Puppeteer               | Scrapy                  | Axios                   |
|--------------------|--------------------------|-------------------------|-------------------------|-------------------------|
| **Stars**          | 127,747                  | ~90k                    | ~55k                    | ~107k                   |
| **类型**           | 网页数据 API             | 浏览器自动化库          | 爬虫框架                | HTTP 客户端             |
| **语言**           | TypeScript               | JavaScript              | Python                  | JavaScript              |
| **协议**           | AGPL-3.0（SDK 为 MIT）   | Apache-2.0              | BSD-3-Clause            | MIT                     |
| **JS 渲染**        | 内置                     | 有（它本身就是浏览器）  | 需额外组件              | 无                      |
| **LLM 可用输出**   | 内置 Markdown / JSON     | 需自行实现              | 需自行实现              | 需自行实现              |
| **托管选项**       | 有（云端 API）           | 无                      | 无                      | 无                      |
| **自托管**         | 有（Docker）             | 不适用（库）            | 不适用（库）            | 不适用（库）            |
| **最适合**         | 网页 → LLM 数据管线      | 脚本化浏览器任务        | 自定义大型爬取          | 简单 HTTP 调用          |

当你的目标是「以最少的胶水代码为 LLM 拿到干净数据」时，Firecrawl 尤为突出：它用一套 API 同时搞定渲染、清洗和爬取。Puppeteer 让你完全掌控一个真实浏览器，但清洗、排队、扩容这些都得自己搭。Scrapy 非常适合大型自定义爬取——前提是你熟悉 Python 并愿意写 spider。Axios 只是 HTTP 客户端——拿来调 API 没问题，但它不做渲染也不做抽取。

对于想用最少粘合代码就拿到「LLM 可用网页数据」的开发者，这四者之中 Firecrawl 是最直接的选择。

## 局限与客观评价

Firecrawl 很强，但并非适合每一种任务：

1. **不是实时低延迟层**：爬取以异步任务方式运行，需要轮询获取结果；即便是单次抓取，也涉及渲染与清洗。如果你需要每个请求都做到亚 100 毫秒，请在前面加缓存，或重新考虑架构。

2. **反爬依然是难题**：Firecrawl 能处理许多反爬机制并提供代理选项，但没有任何工具能可靠绕过那些有严格防护或激进限流的站点。要预期部分目标会封禁或限流你，并请尊重各站点的服务条款。

3. **核心采用 AGPL-3.0**：托管 API 和 MIT 协议的 SDK 用于闭源应用没有问题，但如果你自托管并修改了 AGPL-3.0 的核心，copyleft 条款就会生效。在基于 fork 的核心做开发前，请和团队一起审阅许可证。

4. **托管套餐的成本与配额**：云端 API 按量计费。大型爬取会很快消耗额度，因此对于超大体量，你应当把托管账单与自托管的运维成本做对比。

5. **合规仍由你负责**：Firecrawl 让抓取变得简单，但它不替你判断哪些内容你有权抓取。遵守 `robots.txt`、服务条款和数据保护规定，都是你的责任。

正因为有这些取舍，在采用 Firecrawl 之前认真评估你的使用场景是值得的。

## 结语

Firecrawl 是把开放网络变成「LLM 真正能用的数据」的最实用方式之一，拥有 127k+ 的 GitHub star 和一支活跃的团队。它以 API 为先的设计——scrape、crawl、map、search、extract——意味着你只需几行代码就能从一个 URL 拿到干净的 Markdown，无论用托管云端还是用 Docker 自托管。顺理成章的下一步，就是去拿一个 API key，对你关心的某个页面跑一次抓取，亲眼看看清洗后的输出。

大规模抓取需要轮换代理——[WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f) 是业界标配之选。

- 加入 [dibi8 英文 Telegram 群](https://t.me/DIBI8_Group/2)，获取开源 AI 工具的第一手分享。
- 延伸阅读：[dibi8 上的相关指南](dibi8-internal-link)。

---

**来源与延伸阅读**：
- GitHub 仓库：https://github.com/firecrawl/firecrawl
- 官方文档：https://docs.firecrawl.dev

*以上部分链接为联盟（affiliate）链接。若你通过它们注册，dibi8.com 可能获得一笔佣金，而你无需支付任何额外费用。这有助于维持网站运营、保持内容免费。*

<!-- internal-link-candidates:
  related open-source tools -> ai-tools-directory
  related guides on dibi8 -> ai-coding-agent-landscape-2026-skills-mcp-opensource
-->
