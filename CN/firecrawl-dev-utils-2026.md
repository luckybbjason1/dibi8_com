---
title: 'Firecrawl: Turn Any Website into LLM-Ready Data (127K Stars) — Practical 2026 Guide'
description: 'Firecrawl is the open-source web data API that scrapes, crawls, maps, and searches the web into clean, LLM-ready markdown or structured JSON. 127,747 GitHub stars, AGPL-3.0. Covers install, the official SDKs, real code, self-hosting, and an honest comparison with Puppeteer, Scrapy, and Axios.'
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
  - q: 'How do I install Firecrawl?'
    a: 'Install one of the official SDKs. For Node.js: ```bash npm install firecrawl ``` For Python: ```bash pip install firecrawl-py ``` Then create a client with your API key from [firecrawl.dev](https://firecrawl.dev).'
  - q: 'Can I use Firecrawl with languages other than TypeScript?'
    a: 'Yes. Firecrawl is an HTTP API, so any language can call it. There are official SDKs for Node.js and Python, and you can hit the REST endpoints directly from anything else with an HTTP client.'
  - q: 'Do I have to use the hosted API, or can I self-host?'
    a: 'Both are supported. The hosted API at `api.firecrawl.dev` is the quickest start, but the project is open source and ships a Docker Compose setup so you can run the whole thing on your own server.'
  - q: 'What is the difference between scrape, crawl, and map?'
    a: '`scrape` handles one URL. `crawl` follows links to scrape an entire site asynchronously. `map` just returns the list of URLs on a site without scraping their content — useful for planning a crawl.'
  - q: 'Is Firecrawl free, and what is its license?'
    a: 'The source code is free and open under AGPL-3.0, with the official SDKs and UI components under MIT. The hosted cloud API has a free tier plus paid plans for higher volume. If you self-host, you run it at your own infrastructure cost.'
---

{{< resource-info >}}

## Introduction

If you have ever tried to feed web pages into an LLM, you know the pain: raw HTML is full of nav bars, ads, scripts, and broken layout that waste tokens and confuse the model. **Firecrawl** solves exactly this. It is an open-source web data API that takes any URL — or an entire website — and returns clean, LLM-ready markdown, structured JSON, or screenshots. With over 127,000 stars on GitHub, it has become one of the most popular tools for turning the web into data your AI app can actually use. This guide walks you through what Firecrawl does, how to install it, real working code, self-hosting, and how it compares with the usual alternatives.

![firecrawl overview, via dibi8.com](https://raw.githubusercontent.com/firecrawl/firecrawl/main/img/open-source-cloud.png)

*firecrawl overview (source: firecrawl/firecrawl repo, via dibi8 analysis)*

## What Is Firecrawl?

Firecrawl is a web data API for searching, scraping, and crawling websites at scale, with the explicit goal of producing LLM-ready output. Instead of returning raw HTML, it handles the hard parts — JavaScript rendering, proxies, anti-bot measures, and content cleanup — and hands you markdown or structured JSON.

It is offered two ways: a hosted cloud API at `api.firecrawl.dev` (you sign up for an API key), and a fully open-source version you can self-host with Docker. The core is published under AGPL-3.0, while the official SDKs and UI components are MIT-licensed. With 127,000+ GitHub stars and active maintenance by the Firecrawl team, it is a well-supported choice for production AI data pipelines.

## How Firecrawl Works

Firecrawl exposes a small set of endpoints, each solving one job. You authenticate with a Bearer API key (format `fc-...`) and call the one you need:

1. **Scrape** — Convert a single URL into markdown, HTML, a screenshot, or structured JSON. Firecrawl renders JavaScript and strips boilerplate for you.

2. **Crawl** — Give it one URL and Firecrawl discovers and scrapes every reachable page on the site, respecting `robots.txt`. Crawls run asynchronously: you start a job and poll for results.

3. **Map** — Instantly return all the URLs on a site, useful for planning a crawl or building a sitemap.

4. **Search** — Query the web and get back the full page content of the results, not just links.

5. **Interact & Extract** — Perform actions on a page (click, scroll, type) before scraping, and pull structured data against a schema you define.

A minimal scrape with the Node SDK looks like this:

```typescript
import { Firecrawl } from 'firecrawl';

const app = new Firecrawl({ apiKey: 'fc-YOUR_API_KEY' });

const doc = await app.scrape('https://example.com', {
  formats: ['markdown'],
});

console.log(doc.markdown);
```

Firecrawl is a mature open-source project with a large community behind it, as reflected by its 127k+ stars on GitHub.

![firecrawl architecture, via dibi8.com](https://raw.githubusercontent.com/firecrawl/firecrawl/main/img/firecrawl_logo.png)

*firecrawl architecture (source: firecrawl/firecrawl repo, via dibi8 analysis)*

## Installation & Setup

For most users, the fastest path is the hosted API: sign up at [firecrawl.dev](https://firecrawl.dev), grab an API key, and install an SDK. If you want to self-host, you will need an always-on box — spin one up on [DigitalOcean](https://m.do.co/c/eca87ac14ee0) (free trial credit for new accounts), or [HTStack](https://my.htstack.com/aff.php?aff=27187) for a low-latency Hong Kong VPS (the same IDC that hosts dibi8.com).

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

### Self-Hosting with Docker

If you prefer to run Firecrawl on your own infrastructure, clone the repo and use the bundled Docker Compose setup:

```bash
git clone https://github.com/firecrawl/firecrawl.git
cd firecrawl
docker compose up
```

This brings up the API and its workers. By default the API listens on port `3002`, so you can reach it at `http://localhost:3002`. Point your SDK at the self-hosted instance by setting the API URL:

```typescript
const app = new Firecrawl({
  apiKey: 'fc-YOUR_API_KEY',
  apiUrl: 'http://localhost:3002',
});
```

### Configuration

Self-hosting is configured through environment variables. Copy the provided template and edit it:

```bash
cp apps/api/.env.example apps/api/.env
```

Keys you will commonly set include `PORT`, `NUM_WORKERS_PER_QUEUE`, and optional integrations for proxies and rendering. See the repo's self-hosting guide for the full list. With the hosted API you skip all of this — your only required setting is the API key.

## Core Usage

Below are the most common operations against the hosted API, using the Node SDK. The Python SDK mirrors these method-for-method.

### Scrape a Single Page

```typescript
import { Firecrawl } from 'firecrawl';

const app = new Firecrawl({ apiKey: 'fc-YOUR_API_KEY' });

const doc = await app.scrape('https://example.com', {
  formats: ['markdown', 'html'],
});

console.log(doc.markdown);
```

### Crawl a Whole Site

`crawl` discovers and scrapes every reachable page. You can cap the number of pages and limit how deep it goes:

```typescript
const result = await app.crawl('https://example.com', {
  limit: 100,
  scrapeOptions: { formats: ['markdown'] },
});

for (const page of result.data) {
  console.log(page.metadata?.sourceURL, page.markdown?.slice(0, 80));
}
```

### Extract Structured Data

Pass a JSON schema and Firecrawl returns typed data instead of raw text — ideal for pulling titles, prices, or any fixed fields:

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

For full details, check out the [official documentation](https://docs.firecrawl.dev).

## Integration

Because Firecrawl is just an HTTP API with thin SDKs, it drops into almost any stack — Next.js, Express, a Python data pipeline, or a LangChain / LlamaIndex RAG app where it serves as the document loader.

### Use It in a Server Route

A typical pattern is to wrap a scrape behind your own endpoint:

```typescript
import { Firecrawl } from 'firecrawl';

const app = new Firecrawl({ apiKey: process.env.FIRECRAWL_API_KEY });

export async function scrapeHandler(url: string) {
  const doc = await app.scrape(url, { formats: ['markdown'] });
  return doc.markdown;
}
```

### Run Scheduled Crawls in CI/CD

For recurring jobs, run Firecrawl from GitHub Actions, GitLab CI, or any scheduler. Here is a simple GitHub Actions workflow that scrapes a page on every push and saves the markdown:

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

This keeps your scraping tasks automated and reproducible, with the API key kept in repository secrets rather than in code.

### Summary

Firecrawl's API-first design makes it easy to add to an existing project. Whether you are feeding a RAG pipeline or refreshing a dataset on a schedule, it fits in with a few lines of code.

## Benchmarks & Real-World Use

Firecrawl is used across a range of production scenarios. The figures below are illustrative of the kinds of workloads teams run, not official vendor benchmarks.

### Real-World Use Cases

#### Feeding RAG and AI Search
Many teams use Firecrawl as the ingestion layer for retrieval-augmented generation: crawl a documentation site or knowledge base, get clean markdown, chunk it, and embed it. The LLM-ready output removes most of the preprocessing that raw HTML scraping normally requires.

#### Competitive and E-commerce Monitoring
Teams crawl product and pricing pages on a schedule to keep catalogs and price comparisons current. JavaScript rendering means single-page-app storefronts work without writing custom browser automation.

#### Large-Scale SEO and Content Audits
Agencies run crawls over large sites to inventory pages, surface broken links, and flag outdated content. The `map` endpoint is handy here for getting a full URL list before committing to a deeper crawl.

### Performance Notes

Throughput on the hosted API depends on your plan's concurrency limit, and on the target site's own rate limits and anti-bot measures. Self-hosting lets you tune concurrency with `NUM_WORKERS_PER_QUEUE`, but you then take on proxy and rendering infrastructure yourself. As a rule of thumb, plan for crawl jobs to be measured in pages-per-minute rather than treating Firecrawl as a real-time, sub-100ms request layer.

![firecrawl contributors, via dibi8.com](https://contrib.rocks/image?repo=firecrawl/firecrawl)

*firecrawl contributors (source: firecrawl/firecrawl repo, via dibi8 analysis)*

## Comparison with Alternatives

See also our [related open-source tools](dibi8-internal-link) coverage.

It helps to be clear about what Firecrawl is and is not. Firecrawl is a managed (or self-hostable) web-data API focused on LLM-ready output. Puppeteer is a browser automation library, Scrapy is a Python crawling framework, and Axios is a generic HTTP client. They overlap in "getting data off the web," but they sit at different layers.

| Feature            | firecrawl/firecrawl      | Puppeteer               | Scrapy                  | Axios                   |
|--------------------|--------------------------|-------------------------|-------------------------|-------------------------|
| **Stars**          | 127,747                  | ~90k                    | ~55k                    | ~107k                   |
| **Type**           | Web data API             | Browser automation lib  | Crawling framework      | HTTP client             |
| **Language**       | TypeScript               | JavaScript              | Python                  | JavaScript              |
| **License**        | AGPL-3.0 (SDKs MIT)      | Apache-2.0              | BSD-3-Clause            | MIT                     |
| **JS rendering**   | Built in                 | Yes (it is the browser) | Add-on needed           | No                      |
| **LLM-ready output**| Markdown / JSON built in | DIY                     | DIY                     | DIY                     |
| **Hosted option**  | Yes (cloud API)          | No                      | No                      | No                      |
| **Self-host**      | Yes (Docker)             | N/A (library)           | N/A (library)           | N/A (library)           |
| **Best for**       | Web → LLM data pipelines | Scripted browser tasks  | Custom large crawls     | Simple HTTP calls       |

Firecrawl stands out when your goal is *clean data for an LLM* with minimal plumbing: it handles rendering, cleanup, and crawling behind one API. Puppeteer gives you full control of a real browser but you build everything (cleanup, queueing, scaling) yourself. Scrapy is excellent for large, custom crawls if you are comfortable in Python and willing to write spiders. Axios is just an HTTP client — fine for hitting an API, but it does no rendering or extraction.

For developers who want LLM-ready web data with the least amount of glue code, Firecrawl is the most direct option of the four.

## Limitations & Honest Assessment

Firecrawl is a strong tool, but it is not the right fit for every job:

1. **Not a real-time, low-latency layer**: Crawls run as asynchronous jobs you poll for, and even a single scrape involves rendering and cleanup. If you need sub-100ms responses on every request, put a cache in front or rethink the architecture.

2. **Anti-scraping is still hard**: Firecrawl handles many anti-bot measures and offers proxy options, but no tool reliably bypasses sites with strict protections or aggressive rate limits. Expect some targets to block or throttle you, and respect each site's terms of service.

3. **AGPL-3.0 on the core**: The hosted API and the MIT-licensed SDKs are fine for closed-source apps, but if you self-host and modify the AGPL-3.0 core, the copyleft terms apply. Review the license with your team before building on a forked core.

4. **Cost and quotas on the hosted plan**: The cloud API is metered. Large crawls consume credits quickly, so for very high volume you should compare the hosted bill against the operational cost of self-hosting.

5. **You still own compliance**: Firecrawl makes scraping easy, but it does not decide what you are allowed to scrape. Honoring `robots.txt`, terms of service, and data-protection rules is on you.

These tradeoffs make it worth assessing your use case carefully before adopting Firecrawl.

## Conclusion

Firecrawl is one of the most practical ways to turn the open web into data an LLM can actually use, with 127k+ GitHub stars and an active team behind it. Its API-first design — scrape, crawl, map, search, extract — means you can go from a URL to clean markdown in a few lines, whether you use the hosted cloud or self-host with Docker. The natural next step is to grab an API key, run a scrape on a page you care about, and see the cleaned-up output for yourself.

Large-scale scraping needs rotating proxies — [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f) is the standard choice.

- Join the [dibi8 English Telegram group](https://t.me/DIBI8_Group/2) for open-source AI tool drops.
- Read next: [related guides on dibi8](dibi8-internal-link).

---

**Sources & Further Reading**:
- GitHub repository: https://github.com/firecrawl/firecrawl
- Official docs: https://docs.firecrawl.dev

*Some links above are affiliate links. dibi8.com may earn a commission if you sign up, at no extra cost to you. Helps keep the site running and the content free.*

<!-- internal-link-candidates:
  related open-source tools -> ai-tools-directory
  related guides on dibi8 -> ai-coding-agent-landscape-2026-skills-mcp-opensource
-->
