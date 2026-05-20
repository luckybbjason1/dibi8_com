---
title: 'Puppeteer: 94,300 GitHub Stars — 生产级浏览器自动化 Docker 部署指南 2026'
description: 'Puppeteer 是一个用于 Chrome 和 Firefox 的无头浏览器自动化 Node.js 库。支持 Docker、GitHub Actions、Jest、Mocha、TypeScript。涵盖 puppeteer docker 配置、生产环境部署、浏览器自动化教程、CI/CD 集成。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/puppeteer/puppeteer'
stars: 94300
maintainer: 'puppeteer'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['puppeteer', '浏览器自动化', '无头Chrome', '网络爬虫', 'docker', '测试', 'TypeScript']
aliases:
- /zh/posts/puppeteer/
---

{{</* resource-info */>}}

## 简介

在生产环境运行浏览器自动化意味着要与 Chrome 崩溃、无头环境中的内存泄漏以及页面加载时不稳定的元素选择器打交道。由 Google Chrome DevTools 团队维护的 Puppeteer 提供了一个高级 Node.js API，用于通过 DevTools Protocol 和 WebDriver BiDi 控制 Chrome 和 Firefox。它拥有 94,300 个 GitHub Star、540+ 名贡献者和每周 490 万的 npm 下载量，是需要可靠、可编程浏览器控制的生产环境团队的首选库。

本 Puppeteer 教程将带你完成完整的浏览器自动化设置 —— 从可用的 puppeteer docker 部署到 CI/CD 集成 —— 包含真实配置、性能数据和诚实的利弊分析。无论你是生成 PDF、抓取 SPA 还是运行端到端回归测试，这些 puppeteer production 模式都能直接应用。

## 什么是 Puppeteer？

Puppeteer 是一个 Node.js 库，它提供了通过 Chrome DevTools Protocol (CDP) 和 WebDriver BiDi 以编程方式控制 Chrome、Chromium 和 Firefox 的 API。它默认以无头模式运行，适合服务器环境，但在需要调试时也可以驱动可见的（"headed"）浏览器窗口。该项目于 2017 年首次公开发布，此后发展成为一个涵盖网络爬虫、PDF 生成、截图自动化、可访问性测试和 CI/CD 管道的生态系统。

`puppeteer` 包在安装时自动捆绑 Chromium，而 `puppeteer-core` 则省略了浏览器下载 —— 在 Docker 和其他受限环境中，这一区别很重要，因为你需要自带 Chrome 二进制文件。

## Puppeteer 的工作原理

![Puppeteer 架构图](https://raw.githubusercontent.com/puppeteer/puppeteer/main/docs/images/puppeteer-logo.png)

![Puppeteer GitHub 仓库 94,300 stars](https://github.com/puppeteer/puppeteer/raw/main/docs/images/puppeteer-logo.png)

Puppeteer 通过 WebSocket 连接与浏览器通信。当你调用 `puppeteer.launch()` 时，库会在本地端口上启动一个启用了远程调试的 Chrome 或 Firefox 进程，然后通过 DevTools Protocol 连接到它。这种直接连接避免了旧的基于 WebDriver 工具的 HTTP 往返开销。

**关键架构概念：**

- **Browser**: 单个运行中的浏览器实例。你可以并行运行多个以实现隔离。
- **Page**: 等同于浏览器标签页。大多数自动化代码与 Page 对象交互。
- **Context**: 浏览器上下文提供一个独立的会话 —— 独立的 cookie、localStorage 和缓存。可以把它当作一个无痕窗口。
- **CDP Session**: 对 Chrome DevTools Protocol 的低级访问，用于高级场景，如网络拦截、性能追踪和覆盖率报告。

从 v25.0.0（2026 年 5 月）开始，Puppeteer 迁移为纯 ESM 模块，并将最低 Node.js 要求提升到版本 22。这取消了对 CommonJS 的支持，转而采用原生 ES 模块，与更广泛的 Node.js 生态系统保持一致。

## 安装与配置

在装有 Node.js 22+ 的机器上，本地安装 Puppeteer 不到三分钟。

```bash
# 安装包含捆绑 Chromium 的版本
npm install puppeteer

# 或者如果你单独管理 Chrome，使用 puppeteer-core
npm install puppeteer-core
```

**验证安装**，使用一个最小脚本：

```javascript
// quickstart.mjs — 验证 Puppeteer 是否正确启动
import puppeteer from 'puppeteer';

const browser = await puppeteer.launch();
const page = await browser.newPage();
await page.goto('https://example.com');
const title = await page.title();
console.log(`Page title: ${title}`);
await browser.close();
```

运行它：

```bash
node quickstart.mjs
# 期望输出: Page title: Example Domain
```

对于你独立管理 Chrome 的环境 —— Docker、AWS Lambda 或预装 Chromium 的系统 —— 使用 `puppeteer-core` 并设置 `executablePath`：

```javascript
import puppeteer from 'puppeteer-core';

const browser = await puppeteer.launch({
  executablePath: '/usr/bin/chromium',
  headless: 'new',
  args: ['--no-sandbox', '--disable-setuid-sandbox']
});
```

## Docker 部署

在 Docker 中运行 Puppeteer 可以消除"在我机器上能跑"的问题，并使开发、预发布和生产环境的部署保持一致。挑战在于 Chromium 需要特定的系统库 —— 缺少任何一个，浏览器都会以晦涩的启动错误失败。

**生产级 Dockerfile：**

```dockerfile
# Dockerfile — 用于 Puppeteer 的 Node.js 22 + Chromium 环境
FROM node:22-slim

# 安装 Chromium 依赖和字体
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 使用系统 Chromium；跳过捆绑下载
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# 创建非 root 用户以保障安全
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/app \
    && chown -R pptruser:pptruser /home/pptruser

WORKDIR /home/pptruser/app

# 安装依赖
COPY package.json package-lock.json ./
RUN npm ci --production

# 复制应用代码
COPY src/ ./src/
USER pptruser

CMD ["node", "src/index.mjs"]
```

**构建和运行：**

```bash
docker build -t puppeteer-app .
docker run --rm -v $(pwd)/output:/home/pptruser/app/output puppeteer-app
```

**本地开发的 docker-compose.yml：**

```yaml
version: '3.8'
services:
  puppeteer:
    build: .
    volumes:
      - ./src:/home/pptruser/app/src
      - ./output:/home/pptruser/app/output
    environment:
      - NODE_ENV=production
      - PUPPETEER_ARGS=--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage
    shm_size: '2gb'
    deploy:
      resources:
        limits:
          memory: 4G
        reservations:
          memory: 1G
```

`shm_size` 设置至关重要。Chrome 使用 `/dev/shm` 作为共享内存，而 Docker 容器中的默认值 64MB 会在大页面上导致崩溃。将其设置为 2GB 可以防止无头模式下的 "Aw, snap" 错误。

![Puppeteer Docker 容器运行 Chrome headless](https://user-images.githubusercontent.com/3165635/222661775-8d1f4f3a-75f1-4c9d-9c3d-3c5f53b5c1f0.png)

*Docker 资源限制和 Chrome 标志以确保稳定的 headless 操作。*

## 核心自动化模式

### 动态内容网页抓取

现代 SPA 在初始 HTML 响应后加载内容。Puppeteer 在提取数据前等待选择器出现：

```javascript
// scraper.mjs — 从 JavaScript 渲染的页面提取数据
import puppeteer from 'puppeteer';

const browser = await puppeteer.launch({ headless: 'new' });
const page = await browser.newPage();

await page.setViewport({ width: 1366, height: 768 });
await page.setUserAgent(
  'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36'
);

await page.goto('https://quotes.toscrape.com/js/', {
  waitUntil: 'networkidle2',
  timeout: 30000
});

// 等待动态内容渲染
await page.waitForSelector('.quote', { timeout: 10000 });

const quotes = await page.evaluate(() => {
  return Array.from(document.querySelectorAll('.quote')).map(el => ({
    text: el.querySelector('.text')?.textContent?.trim(),
    author: el.querySelector('.author')?.textContent?.trim(),
    tags: Array.from(el.querySelectorAll('.tag')).map(t => t.textContent.trim())
  }));
});

console.log(`Scraped ${quotes.length} quotes`);
await browser.close();
```

### 截图和 PDF 生成

Puppeteer 在从 HTML 渲染可视化产物方面表现出色 —— 这是发票、报告和 Open Graph 图片生成的常见需求：

```javascript
// screenshot.mjs — 全页截图和 PDF 导出
import puppeteer from 'puppeteer';
import fs from 'fs';
import path from 'path';

const OUTPUT_DIR = './output';
fs.mkdirSync(OUTPUT_DIR, { recursive: true });

const browser = await puppeteer.launch({ headless: 'new' });
const page = await browser.newPage();

await page.setViewport({ width: 1280, height: 800 });

// 截图：全页 PNG
await page.goto('https://example.com', { waitUntil: 'networkidle2' });
await page.screenshot({
  path: path.join(OUTPUT_DIR, 'page.png'),
  fullPage: true
});

// PDF：A4 带背景图形
await page.pdf({
  path: path.join(OUTPUT_DIR, 'page.pdf'),
  format: 'A4',
  printBackground: true,
  margin: { top: '1cm', right: '1cm', bottom: '1cm', left: '1cm' }
});

console.log('截图和 PDF 已保存到', OUTPUT_DIR);
await browser.close();
```

### 网络拦截和请求屏蔽

屏蔽不必要的资源可以将爬虫场景中的页面加载时间缩短 40–60%：

```javascript
// blocker.mjs — 屏蔽图片和 CSS 以加快抓取速度
import puppeteer from 'puppeteer';

const browser = await puppeteer.launch({ headless: 'new' });
const page = await browser.newPage();

// 拦截并屏蔽图片/样式表/媒体请求
await page.setRequestInterception(true);
page.on('request', (req) => {
  const block = ['image', 'stylesheet', 'font', 'media'];
  if (block.includes(req.resourceType())) {
    req.abort();
  } else {
    req.continue();
  }
});

const start = Date.now();
await page.goto('https://example.com', { waitUntil: 'networkidle2' });
console.log(`加载耗时 ${Date.now() - start}ms (资源已屏蔽)`);

await browser.close();
```

## 与流行工具集成

### GitHub Actions

在每次推送时自动捕获截图或运行回归测试：

```yaml
# .github/workflows/puppeteer.yml
name: Puppeteer CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  puppeteer:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run Puppeteer tests
        run: npm test
        env:
          CI: true
          PUPPETEER_ARGS: '--no-sandbox --disable-setuid-sandbox'

      - name: Upload artifacts
        uses: actions/upload-artifact@v4
        with:
          name: screenshots
          path: output/*.png
```

### Jest 测试框架

```javascript
// jest.config.js
module.exports = {
  testEnvironment: 'node',
  testMatch: ['**/*.test.mjs'],
  testTimeout: 30000,
  globals: {
    'ts-jest': { useESM: true }
  }
};
```

```javascript
// homepage.test.mjs — Jest + Puppeteer 集成
import puppeteer from 'puppeteer';

describe('Homepage', () => {
  let browser;
  let page;

  beforeAll(async () => {
    browser = await puppeteer.launch({
      headless: 'new',
      args: (process.env.PUPPETEER_ARGS || '').split(' ').filter(Boolean)
    });
    page = await browser.newPage();
  });

  afterAll(async () => {
    await browser.close();
  });

  test('页面标题正确', async () => {
    await page.goto('https://example.com');
    const title = await page.title();
    expect(title).toBe('Example Domain');
  });

  test('页面在 3 秒内加载完成', async () => {
    const start = Date.now();
    await page.goto('https://example.com', { waitUntil: 'networkidle2' });
    expect(Date.now() - start).toBeLessThan(3000);
  });
});
```

### TypeScript 配置

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "esModuleInterop": true,
    "strict": true,
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"]
}
```

```typescript
// src/scraper.ts — 使用 TypeScript 的 Puppeteer
import puppeteer, { Browser, Page } from 'puppeteer';

interface Product {
  name: string;
  price: string;
  url: string;
}

async function scrapeProducts(url: string): Promise<Product[]> {
  const browser: Browser = await puppeteer.launch({ headless: 'new' });
  const page: Page = await browser.newPage();

  await page.goto(url, { waitUntil: 'networkidle2' });

  const products: Product[] = await page.evaluate(() => {
    return Array.from(document.querySelectorAll('.product')).map(el => ({
      name: el.querySelector('.name')?.textContent?.trim() || '',
      price: el.querySelector('.price')?.textContent?.trim() || '',
      url: el.querySelector('a')?.href || ''
    }));
  });

  await browser.close();
  return products;
}

const results = await scrapeProducts('https://example.com/products');
console.log(`找到 ${results.length} 个产品`);
```

### Mocha 测试运行器

```javascript
// .mocharc.cjs
module.exports = {
  extension: ['mjs'],
  spec: 'test/**/*.test.mjs',
  timeout: 30000,
  exit: true
};
```

```javascript
// test/scraper.test.mjs — Mocha + Puppeteer
import puppeteer from 'puppeteer';
import assert from 'assert';

describe('Scraper Suite', function() {
  this.timeout(30000);

  let browser;
  before(async () => {
    browser = await puppeteer.launch({
      headless: 'new',
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    });
  });

  after(async () => await browser.close());

  it('应该提取产品数据', async () => {
    const page = await browser.newPage();
    await page.goto('https://example.com');
    const heading = await page.$eval('h1', el => el.textContent);
    assert.strictEqual(heading, 'Example Domain');
    await page.close();
  });
});
```

## 基准测试 / 真实用例

独立基准测试显示 Puppeteer 在 Chrome 为中心的工作负载中保持着强劲地位：

| 指标 | Puppeteer | Selenium | Playwright | Cypress |
|------|-----------|----------|------------|---------|
| 平均操作延迟 | < 1秒 | 3–5秒 | 1–2秒 | 1–2秒 |
| 配置时间 | 10–15 分钟 | 2–4 小时 | 15–30 分钟 | 15–30 分钟 |
| 通过率 (100 次运行) | 93% | 84% | 94% | 96% |
| 每实例内存 | 200–400MB | 300–500MB | 250–450MB | 400–600MB |
| 测试套件 (50 个测试) | 2分55秒顺序 / 48秒并行 | 8分45秒顺序 / 2分50秒并行 | 3分20秒顺序 / 52秒并行 | 3分45秒顺序 / 1分10秒并行 |
| 每月维护时间 | 约 11 小时 | 约 16.5 小时 | 约 12 小时 | 约 10.5 小时 |

**何时选择 Puppeteer 而非替代品：**

- **PDF 生成和截图管道**: Puppeteer 的 `page.pdf()` 和 `page.screenshot()` 是浏览器自动化领域中最成熟的 API。
- **Chrome DevTools Protocol 访问**: 对于构建开发者工具、性能分析器或覆盖率报告器的团队，直接 CDP 访问是只有 Puppeteer 原生满足的需求。
- **大规模网页抓取**: 当与 Bull 或 RabbitMQ 等工作队列结合时，Puppeteer 每小时可处理数千个 URL，开销极小。
- **现有 Node.js 基础设施**: 如果你的后端已经是 TypeScript/JavaScript，引入 Puppeteer 不会增加新的运行时或语言。

## 高级用法 / 生产环境加固

### 浏览器池管理

为每个请求启动一个浏览器是浪费的。连接池可以复用浏览器实例：

```javascript
// pool.mjs — 带最大并发限制的浏览器池
import puppeteer from 'puppeteer';

class BrowserPool {
  constructor(maxBrowsers = 5) {
    this.maxBrowsers = maxBrowsers;
    this.pool = [];
    this.queue = [];
  }

  async init() {
    for (let i = 0; i < this.maxBrowsers; i++) {
      const browser = await puppeteer.launch({
        headless: 'new',
        args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage']
      });
      this.pool.push({ browser, inUse: false });
    }
  }

  async acquire() {
    const available = this.pool.find(b => !b.inUse);
    if (available) {
      available.inUse = true;
      return available.browser;
    }
    return new Promise(resolve => this.queue.push(resolve));
  }

  release(browser) {
    const entry = this.pool.find(b => b.browser === browser);
    if (entry) {
      entry.inUse = false;
      if (this.queue.length > 0) {
        const next = this.queue.shift();
        entry.inUse = true;
        next(entry.browser);
      }
    }
  }

  async close() {
    await Promise.all(this.pool.map(b => b.browser.close()));
  }
}

const pool = new BrowserPool(3);
await pool.init();

const browser = await pool.acquire();
const page = await browser.newPage();
await page.goto('https://example.com');
// ... 工作 ...
await page.close();
pool.release(browser);
```

### 优雅的错误处理和重试

生产环境抓取会遇到网络超时、机器人检测和瞬态故障。用指数退避包裹页面导航：

```javascript
// retry.mjs — 带指数退避的弹性导航
async function gotoWithRetry(page, url, maxRetries = 3) {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      await page.goto(url, {
        waitUntil: 'networkidle2',
        timeout: 30000
      });
      return;
    } catch (err) {
      if (attempt === maxRetries) throw err;
      const delay = Math.pow(2, attempt) * 1000;
      console.log(`第 ${attempt} 次尝试失败，${delay}ms 后重试...`);
      await new Promise(r => setTimeout(r, delay));
    }
  }
}
```

### 健康监控

在长时间运行的服务中，监控浏览器进程健康状况并在崩溃时重启实例：

```javascript
// health.mjs — 浏览器进程的基础健康检查
async function isBrowserHealthy(browser) {
  try {
    const version = await browser.version();
    return !!version;
  } catch {
    return false;
  }
}

// 每 60 秒检查一次
setInterval(async () => {
  for (const entry of pool.pool) {
    const healthy = await isBrowserHealthy(entry.browser);
    if (!healthy) {
      console.warn('检测到不健康的浏览器，正在重启...');
      await entry.browser.close();
      entry.browser = await puppeteer.launch({ headless: 'new', args: ['--no-sandbox'] });
      entry.inUse = false;
    }
  }
}, 60000);
```

## 与替代品对比

| 特性 | Puppeteer | Selenium | Playwright | Cypress |
|------|-----------|----------|------------|---------|
| **主要语言** | JavaScript, TypeScript | Java, Python, C#, JS, Ruby | JS/TS, Python, Java, .NET | JavaScript, TypeScript |
| **浏览器支持** | Chrome, Chromium, Firefox | 所有主流 + 移动端 (Appium) | Chromium, Firefox, WebKit | Chromium, Edge, Firefox |
| **协议** | CDP, WebDriver BiDi | W3C WebDriver | CDP, WebDriver BiDi | 浏览器内执行 |
| **执行速度** | 非常快 (< 1秒/操作) | 慢 (3–5秒/操作) | 快 (1–2秒/操作) | 快 (1–2秒/操作) |
| **内置测试运行器** | 无 (使用 Jest/Mocha) | 无 (使用外部工具) | 有 (playwright test) | 有 |
| **并行执行** | 手动设置 | Selenium Grid | 内置 worker | Cypress Cloud (付费) |
| **PDF 生成** | 原生 (`page.pdf`) | 第三方 | 原生 | 第三方插件 |
| **移动端模拟** | Chrome 设备模拟 | 完整 (通过 Appium) | 视口模拟 | 无 |
| **社区 / GitHub Stars** | 94,300 | 34,000 | 78,000 | 48,000 |
| **许可证** | Apache-2.0 | Apache-2.0 | Apache-2.0 | MIT |
| **最适合** | 爬虫、PDF、截图 | 企业、多语言 | 跨浏览器测试 | 前端开发者测试 |

**选择建议：** 当你的工作负载围绕 Chrome 自动化 —— 爬虫、PDF 生成、截图管道或 DevTools 集成 —— 时选择 Puppeteer。如果你需要在单个测试套件中跨 Chromium、Firefox 和 WebKit 进行测试，Playwright 是更有能力的选择。对于 Java/.NET 技术栈或传统企业环境，Selenium 仍然是默认选择。Cypress 适合优先考虑开发者体验和可视化调试而非原始执行速度的 JavaScript 团队。

## 局限性 / 诚实评估

Puppeteer 并不是适合每个浏览器自动化任务的工具。在决定使用前，请考虑以下限制：

- **仅限 JavaScript**: Puppeteer 是一个 Node.js 库。使用 Python、Java 或 Go 的团队必须使用 `pyppeteer`（非官方，滞后）或切换到 Selenium/Playwright。
- **跨浏览器支持有限**: 虽然通过 WebDriver BiDi 支持 Firefox，但其成熟度不如 Chrome 自动化。Safari 和 WebKit 不受支持。如果跨浏览器测试是硬性要求，Playwright 原生覆盖所有三个渲染引擎。
- **无内置测试运行器**: 与 Cypress 或 Playwright 不同，Puppeteer 不提供断言、测试组织或报告器。你需要自行引入 Jest、Mocha 或 Vitest。
- **手动并行化**: 并行测试执行需要手动浏览器池管理或外部编排。Playwright 的内置 worker 模型对于大型测试套件更简单。
- **内存占用**: 每个 Chrome 实例消耗 200–400MB 内存。同时抓取数千个页面需要大量基础设施或基于集群的方法。
- **机器人检测**: 现代网站使用 Cloudflare、DataDome 和 PerimeterX 来检测无头浏览器。Puppeteer 本身无法绕过这些系统 —— 需要额外的工具如 `puppeteer-extra-plugin-stealth`，且其有效性各不相同。

## 常见问题解答

### `puppeteer` 和 `puppeteer-core` 有什么区别？

`puppeteer` 包捆绑了 Chromium，在安装时自动下载。`puppeteer-core` 包仅包含 JavaScript API，期望你通过 `executablePath` 启动选项提供 Chrome 或 Chromium 可执行文件。在 Docker、CI/CD 管道以及你单独管理浏览器二进制文件的环境中使用 `puppeteer-core`。

### Puppeteer 支持 Firefox 吗？

是的，自 2023 年起，Puppeteer 通过 WebDriver BiDi 协议支持 Firefox。然而，Firefox 支持的成熟度不如 Chrome 自动化。一些 CDP 特定功能如性能追踪和覆盖率报告仅支持 Chrome。对于面向 Firefox 的生产工作负载，Playwright 可能提供更广泛的 API 一致性。

### 如何在 Docker 中以非 root 权限运行 Puppeteer？

在 Dockerfile 中创建专用的非 root 用户，将其分配到 `audio` 和 `video` 组，并使用 `--no-sandbox` 和 `--disable-setuid-sandbox` 标志运行 Chrome。本指南中的 Dockerfile 示例展示了完整设置。请注意，`--no-sandbox` 会降低进程隔离性，但在容器化环境中，这是可接受的权衡，因为容器本身提供了安全边界。

### Puppeteer 25 的最低 Node.js 版本是多少？

Puppeteer v25.0.0 及更高版本需要 Node.js 22 或更高版本。该项目在此版本中迁移为纯 ESM 模块，取消了对 CommonJS (`require()`) 的支持。如果你使用的是 Node.js 18 或 20，请在安装 Puppeteer 25 之前升级，或固定使用支持 Node.js 18+ 的 Puppeteer 24.x。

### 如何在生产 Puppeteer 部署中减少内存使用？

使用浏览器池限制并发 Chrome 实例数量，通过请求拦截屏蔽不必要的资源（图片、CSS、字体），使用后立即关闭页面，并设置 `--disable-dev-shm-usage` 标志以使用 `/tmp` 代替 `/dev/shm` 作为共享内存。在 Docker 中，将 `shm_size` 增加到至少 2GB 以防止渲染进程崩溃。

### Puppeteer 适合大规模网页抓取吗？

当配合适当的基础设施时，Puppeteer 可以处理大规模抓取。单个 Node.js 进程可以在 4GB 机器上管理 3–5 个并发 Chrome 实例。对于更高吞吐量，使用消息队列（Redis、RabbitMQ、SQS）将工作分布到多个容器或虚拟机。请注意，许多网站会主动屏蔽无头浏览器，因此请将 Puppeteer 与代理轮换和指纹随机化结合使用，用于生产抓取管道。

### Puppeteer 与 Playwright 在测试方面相比如何？

Puppeteer 和 Playwright 有着相同的起源 —— Playwright 团队在 Google 构建了 Puppeteer，之后加入微软。Playwright 增加了跨浏览器支持（WebKit/Safari）、内置测试运行器、自动等待和移动设备模拟。对于以 Chrome 为中心的自动化和抓取选择 Puppeteer。对于跨浏览器端到端测试，Playwright 提供最广泛的浏览器覆盖。

## 结论

Puppeteer 仍然是需要编程控制 Chrome 的团队的可靠选择。其 94,300 个 GitHub Star 和 Chrome DevTools 团队的积极维护表明了长期稳定性。对于 PDF 生成、截图管道和基于 Chrome 的抓取，该库的 API 覆盖面无人能及。本指南中的 Docker 模式、浏览器池管理和重试逻辑提供了生产级基础。

**行动清单：**

1. 克隆 [官方 Puppeteer 示例](https://github.com/puppeteer/puppeteer/tree/main/examples) 并改编抓取模式以适应你的目标网站。
2. 从本指南中的 Dockerfile 构建 Docker 镜像，并在你的预发布环境中运行。
3. 设置 GitHub Actions 工作流，在每个 PR 上捕获截图或运行回归测试。
4. 加入 [dibi8 Telegram 群组](https://t.me/dibi8tech) 分享你的 Puppeteer 部署模式，并从其他大规模运行浏览器自动化的开发者处获得帮助。



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [Puppeteer 官方文档](https://pptr.dev/) — API 参考和指南
- [Puppeteer GitHub 仓库](https://github.com/puppeteer/puppeteer) — 源代码、Issues、Releases
- [Puppeteer 更新日志](https://pptr.dev/changelog) — 版本历史和破坏性变更
- [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/) — 底层协议文档
- [Puppeteer Docker 示例](https://github.com/puppeteer/puppeteer/tree/main/docker) — 官方 Docker 配置
- [WebDriver BiDi 规范](https://w3c.github.io/webdriver-bidi/) — 跨浏览器自动化标准
- [Puppeteer vs Playwright 基准测试](https://getautonoma.com/blog/selenium-playwright-cypress-comparison) — 独立性能对比
- [Browserless.io Puppeteer 托管](https://www.browserless.io/) — 托管 Puppeteer 基础设施
