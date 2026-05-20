---
title: 'Puppeteer: 94,300 GitHub Stars — Production Browser Automation Docker Guide 2026'
description: 'Puppeteer is a Node.js library for headless Chrome and Firefox automation. Supports Docker, GitHub Actions, Jest, Mocha, TypeScript. Covers puppeteer docker setup, production deployment, browser automation tutorial, and CI/CD integration.'
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
tags: ['puppeteer', 'browser-automation', 'headless-chrome', 'web-scraping', 'docker', 'testing', 'typescript']
aliases:
- /posts/puppeteer/
---

{{</* resource-info */>}}

## Introduction

Running browser automation at scale means wrestling with Chrome crashes, memory leaks in headless environments, and inconsistent selectors across page loads. Puppeteer, maintained by the Chrome DevTools team at Google, provides a high-level Node.js API to control Chrome and Firefox via the DevTools Protocol and WebDriver BiDi. With 94,300 GitHub stars, 540+ contributors, and 4.9 million weekly npm downloads, it remains the go-to library for teams that need reliable, scriptable browser control in production.

This puppeteer tutorial walks through a complete browser automation setup — from a working puppeteer docker deployment to CI/CD integration — with real configs, performance numbers, and honest trade-offs. Whether you are generating PDFs, scraping SPAs, or running end-to-end regression tests, these puppeteer production patterns apply directly.

## What Is Puppeteer?

Puppeteer is a Node.js library that provides a programmatic API to control Chrome, Chromium, and Firefox over the Chrome DevTools Protocol (CDP) and WebDriver BiDi. It runs headless by default, making it suitable for server environments, but can drive visible ("headful") browser windows when debugging is needed. The project shipped its first public release in 2017 and has since grown into an ecosystem that spans web scraping, PDF generation, screenshot automation, accessibility testing, and CI/CD pipelines.

The `puppeteer` package bundles Chromium automatically on install, while `puppeteer-core` omits the browser download — a distinction that matters in Docker and other constrained environments where you bring your own Chrome binary.

## How Puppeteer Works

![Puppeteer architecture diagram](https://raw.githubusercontent.com/puppeteer/puppeteer/main/docs/images/puppeteer-logo.png)

![Puppeteer GitHub repository showing 94,300 stars](https://github.com/puppeteer/puppeteer/raw/main/docs/images/puppeteer-logo.png)

Puppeteer communicates with the browser over a WebSocket connection. When you call `puppeteer.launch()`, the library starts a Chrome or Firefox process with remote debugging enabled on a local port, then connects to it via the DevTools Protocol. This direct connection avoids the HTTP round-trips that older WebDriver-based tools incur.

**Key architectural concepts:**

- **Browser**: A single running browser instance. You can run multiple in parallel for isolation.
- **Page**: Equivalent to a browser tab. Most automation code interacts with Page objects.
- **Context**: A browser context provides an isolated session — separate cookies, localStorage, and cache. Think of it as an incognito window.
- **CDP Session**: Low-level access to the Chrome DevTools Protocol for advanced use cases like network interception, performance tracing, and coverage reporting.

Starting with v25.0.0 (May 2026), Puppeteer moved to ESM-only modules and bumped the minimum Node.js requirement to version 22. This eliminated CommonJS support in favor of native ES modules, aligning with the broader Node.js ecosystem.

## Installation & Setup

A local Puppeteer install takes under three minutes on a machine with Node.js 22+.

```bash
# Install with bundled Chromium
npm install puppeteer

# Or use puppeteer-core if you manage Chrome separately
npm install puppeteer-core
```

**Verify the installation** with a minimal script:

```javascript
// quickstart.mjs — verify Puppeteer launches correctly
import puppeteer from 'puppeteer';

const browser = await puppeteer.launch();
const page = await browser.newPage();
await page.goto('https://example.com');
const title = await page.title();
console.log(`Page title: ${title}`);
await browser.close();
```

Run it:

```bash
node quickstart.mjs
# Expected output: Page title: Example Domain
```

For environments where you manage Chrome independently — Docker, AWS Lambda, or systems with pre-installed Chromium — use `puppeteer-core` and set the `executablePath`:

```javascript
import puppeteer from 'puppeteer-core';

const browser = await puppeteer.launch({
  executablePath: '/usr/bin/chromium',
  headless: 'new',
  args: ['--no-sandbox', '--disable-setuid-sandbox']
});
```

## Docker Deployment

Running Puppeteer in Docker eliminates the "works on my machine" problem and makes deployments deterministic across dev, staging, and production. The challenge is that Chromium requires specific system libraries — miss one and the browser fails with cryptic startup errors.

**Production Dockerfile:**

```dockerfile
# Dockerfile — Node.js 22 with Chromium for Puppeteer
FROM node:22-slim

# Install Chromium dependencies and fonts
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

# Use system Chromium; skip bundled download
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Create non-root user for security
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/app \
    && chown -R pptruser:pptruser /home/pptruser

WORKDIR /home/pptruser/app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci --production

# Copy application code
COPY src/ ./src/
USER pptruser

CMD ["node", "src/index.mjs"]
```

**Build and run:**

```bash
docker build -t puppeteer-app .
docker run --rm -v $(pwd)/output:/home/pptruser/app/output puppeteer-app
```

**docker-compose.yml for local development:**

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

The `shm_size` setting is critical. Chrome uses `/dev/shm` for shared memory, and the default 64MB in Docker containers causes crashes on large pages. Setting it to 2GB prevents "Aw, snap" errors in headless mode.

![Puppeteer Docker container running Chrome headless](https://user-images.githubusercontent.com/3165635/222661775-8d1f4f3a-75f1-4c9d-9c3d-3c5f53b5c1f0.png)

*Docker resource limits and Chrome flags for stable headless operation.*

## Core Automation Patterns

### Web Scraping with Dynamic Content

Modern SPAs load content after the initial HTML response. Puppeteer waits for selectors before extracting data:

```javascript
// scraper.mjs — extract data from a JavaScript-rendered page
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

// Wait for dynamic content to render
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

### Screenshot and PDF Generation

Puppeteer excels at rendering visual artifacts from HTML — a common requirement for invoicing, reporting, and Open Graph image generation:

```javascript
// screenshot.mjs — full-page capture and PDF export
import puppeteer from 'puppeteer';
import fs from 'fs';
import path from 'path';

const OUTPUT_DIR = './output';
fs.mkdirSync(OUTPUT_DIR, { recursive: true });

const browser = await puppeteer.launch({ headless: 'new' });
const page = await browser.newPage();

await page.setViewport({ width: 1280, height: 800 });

// Screenshot: full-page PNG
await page.goto('https://example.com', { waitUntil: 'networkidle2' });
await page.screenshot({
  path: path.join(OUTPUT_DIR, 'page.png'),
  fullPage: true
});

// PDF: A4 with background graphics
await page.pdf({
  path: path.join(OUTPUT_DIR, 'page.pdf'),
  format: 'A4',
  printBackground: true,
  margin: { top: '1cm', right: '1cm', bottom: '1cm', left: '1cm' }
});

console.log('Screenshot and PDF saved to', OUTPUT_DIR);
await browser.close();
```

### Network Interception and Request Blocking

Blocking unnecessary resources cuts page load time by 40–60% in scraping scenarios:

```javascript
// blocker.mjs — block images and CSS for faster scraping
import puppeteer from 'puppeteer';

const browser = await puppeteer.launch({ headless: 'new' });
const page = await browser.newPage();

// Intercept and block image/stylesheet/media requests
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
console.log(`Loaded in ${Date.now() - start}ms (resources blocked)`);

await browser.close();
```

## Integration with Popular Tools

### GitHub Actions

Automate screenshot capture or regression tests on every push:

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

### Jest Testing Framework

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
// homepage.test.mjs — Jest + Puppeteer integration
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

  test('page title is correct', async () => {
    await page.goto('https://example.com');
    const title = await page.title();
    expect(title).toBe('Example Domain');
  });

  test('navigation loads within 3 seconds', async () => {
    const start = Date.now();
    await page.goto('https://example.com', { waitUntil: 'networkidle2' });
    expect(Date.now() - start).toBeLessThan(3000);
  });
});
```

### TypeScript Setup

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
// src/scraper.ts — TypeScript with Puppeteer
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
console.log(`Found ${results.length} products`);
```

### Mocha Test Runner

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

  it('should extract product data', async () => {
    const page = await browser.newPage();
    await page.goto('https://example.com');
    const heading = await page.$eval('h1', el => el.textContent);
    assert.strictEqual(heading, 'Example Domain');
    await page.close();
  });
});
```

## Benchmarks / Real-World Use Cases

Independent benchmarks show Puppeteer holding a strong position for Chrome-centric workloads:

| Metric | Puppeteer | Selenium | Playwright | Cypress |
|--------|-----------|----------|------------|---------|
| Avg. action latency | < 1s | 3–5s | 1–2s | 1–2s |
| Setup time | 10–15 min | 2–4 hours | 15–30 min | 15–30 min |
| Pass rate (100 runs) | 93% | 84% | 94% | 96% |
| Memory per instance | 200–400MB | 300–500MB | 250–450MB | 400–600MB |
| Test suite (50 tests) | 2m 55s seq / 48s parallel | 8m 45s seq / 2m 50s parallel | 3m 20s seq / 52s parallel | 3m 45s seq / 1m 10s parallel |
| Monthly maintenance | ~11h | ~16.5h | ~12h | ~10.5h |

**When to choose Puppeteer over alternatives:**

- **PDF generation and screenshot pipelines**: Puppeteer's `page.pdf()` and `page.screenshot()` are the most mature APIs in the browser automation space.
- **Chrome DevTools Protocol access**: For teams building developer tools, performance profilers, or coverage reporters, direct CDP access is a requirement only Puppeteer satisfies natively.
- **Web scraping at scale**: When combined with a worker queue like Bull or RabbitMQ, Puppeteer processes thousands of URLs per hour with minimal overhead.
- **Existing Node.js infrastructure**: If your backend is already TypeScript/JavaScript, adding Puppeteer introduces no new runtime or language.

## Advanced Usage / Production Hardening

### Browser Pool Management

Launching one browser per request is wasteful. A connection pool reuses browser instances:

```javascript
// pool.mjs — reusable browser pool with max concurrency
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
// ... work ...
await page.close();
pool.release(browser);
```

### Graceful Error Handling and Retries

Production scraping encounters network timeouts, bot detection, and transient failures. Wrap page navigation with exponential backoff:

```javascript
// retry.mjs — resilient navigation with exponential backoff
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
      console.log(`Attempt ${attempt} failed, retrying in ${delay}ms...`);
      await new Promise(r => setTimeout(r, delay));
    }
  }
}
```

### Health Monitoring

In long-running services, monitor browser process health and restart crashed instances:

```javascript
// health.mjs — basic health check for browser processes
async function isBrowserHealthy(browser) {
  try {
    const version = await browser.version();
    return !!version;
  } catch {
    return false;
  }
}

// Periodic check every 60 seconds
setInterval(async () => {
  for (const entry of pool.pool) {
    const healthy = await isBrowserHealthy(entry.browser);
    if (!healthy) {
      console.warn('Unhealthy browser detected, restarting...');
      await entry.browser.close();
      entry.browser = await puppeteer.launch({ headless: 'new', args: ['--no-sandbox'] });
      entry.inUse = false;
    }
  }
}, 60000);
```

## Comparison with Alternatives

| Feature | Puppeteer | Selenium | Playwright | Cypress |
|---------|-----------|----------|------------|---------|
| **Primary Languages** | JavaScript, TypeScript | Java, Python, C#, JS, Ruby | JS/TS, Python, Java, .NET | JavaScript, TypeScript |
| **Browser Support** | Chrome, Chromium, Firefox | All major + mobile (Appium) | Chromium, Firefox, WebKit | Chromium, Edge, Firefox |
| **Protocol** | CDP, WebDriver BiDi | W3C WebDriver | CDP, WebDriver BiDi | In-browser execution |
| **Execution Speed** | Very fast (< 1s/action) | Slow (3–5s/action) | Fast (1–2s/action) | Fast (1–2s/action) |
| **Built-in Test Runner** | No (uses Jest/Mocha) | No (uses external) | Yes (playwright test) | Yes |
| **Parallel Execution** | Manual setup | Selenium Grid | Built-in workers | Cypress Cloud (paid) |
| **PDF Generation** | Native (`page.pdf`) | Third-party | Native | Third-party plugins |
| **Mobile Emulation** | Chrome device emulation | Full (via Appium) | Viewport simulation | None |
| **Community / GitHub Stars** | 94,300 | 34,000 | 78,000 | 48,000 |
| **License** | Apache-2.0 | Apache-2.0 | Apache-2.0 | MIT |
| **Best For** | Scraping, PDFs, screenshots | Enterprise, multi-language | Cross-browser testing | Frontend developer testing |

**Selection guidance:** Choose Puppeteer when your workload centers on Chrome automation — scraping, PDF generation, screenshot pipelines, or DevTools integration. If you need cross-browser testing across Chromium, Firefox, and WebKit in a single test suite, Playwright is the more capable choice. For Java/.NET shops or legacy enterprise environments, Selenium remains the default. Cypress fits JavaScript teams that prioritize developer experience and visual debugging over raw execution speed.

## Limitations / Honest Assessment

Puppeteer is not the right tool for every browser automation task. Consider these constraints before committing:

- **JavaScript-only**: Puppeteer is a Node.js library. Teams using Python, Java, or Go must use `pyppeteer` (unofficial, lagging) or switch to Selenium/Playwright.
- **Limited cross-browser support**: While Firefox support exists via WebDriver BiDi, it is less mature than Chrome automation. Safari and WebKit are not supported. If cross-browser testing is a hard requirement, Playwright covers all three rendering engines natively.
- **No built-in test runner**: Unlike Cypress or Playwright, Puppeteer does not ship with assertions, test organization, or reporters. You bring your own Jest, Mocha, or Vitest setup.
- **Manual parallelization**: Parallel test execution requires manual browser pool management or external orchestration. Playwright's built-in worker model is simpler for large test suites.
- **Memory footprint**: Each Chrome instance consumes 200–400MB of RAM. Scraping thousands of pages concurrently requires significant infrastructure or a cluster-based approach.
- **Bot detection**: Modern websites use Cloudflare, DataDome, and PerimeterX to detect headless browsers. Puppeteer alone does not bypass these systems — additional tools like `puppeteer-extra-plugin-stealth` are necessary and their effectiveness varies.

## Frequently Asked Questions

### What is the difference between `puppeteer` and `puppeteer-core`?

The `puppeteer` package bundles Chromium and downloads it on install. The `puppeteer-core` package contains only the JavaScript API and expects you to provide a Chrome or Chromium executable via the `executablePath` launch option. Use `puppeteer-core` in Docker, CI/CD pipelines, and environments where you manage the browser binary separately.

### Does Puppeteer support Firefox?

Yes, since 2023 Puppeteer supports Firefox through the WebDriver BiDi protocol. However, Firefox support is less mature than Chrome automation. Some CDP-specific features like performance tracing and coverage reporting are Chrome-only. For production workloads targeting Firefox, Playwright may offer broader API parity.

### How do I run Puppeteer in Docker without root privileges?

Create a dedicated non-root user in your Dockerfile, assign it to the `audio` and `video` groups, and run Chrome with `--no-sandbox` and `--disable-setuid-sandbox` flags. The example Dockerfile in this guide demonstrates the full setup. Note that `--no-sandbox` reduces process isolation, which is an acceptable trade-off in containerized environments where the container itself provides the security boundary.

### What is the minimum Node.js version for Puppeteer 25?

Puppeteer v25.0.0 and later require Node.js 22 or higher. The project moved to ESM-only modules in this release, dropping CommonJS (`require()`) support. If you are on Node.js 18 or 20, upgrade before installing Puppeteer 25, or pin to Puppeteer 24.x which supports Node.js 18+.

### How can I reduce memory usage in production Puppeteer deployments?

Use a browser pool to limit concurrent Chrome instances, block unnecessary resources (images, CSS, fonts) via request interception, close pages immediately after use, and set the `--disable-dev-shm-usage` flag to use `/tmp` instead of `/dev/shm` for shared memory. In Docker, increase `shm_size` to at least 2GB to prevent renderer process crashes.

### Is Puppeteer suitable for large-scale web scraping?

Puppeteer handles large-scale scraping when paired with proper infrastructure. A single Node.js process can manage 3–5 concurrent Chrome instances on a 4GB machine. For higher throughput, distribute work across multiple containers or VMs using a message queue (Redis, RabbitMQ, SQS). Be aware that many websites actively block headless browsers, so combine Puppeteer with proxy rotation and fingerprint randomization for production scraping pipelines.

### How does Puppeteer compare to Playwright for testing?

Puppeteer and Playwright share the same origins — the Playwright team built Puppeteer at Google before moving to Microsoft. Playwright adds cross-browser support (WebKit/Safari), a built-in test runner, auto-waiting, and mobile device emulation. Choose Puppeteer for Chrome-centric automation and scraping. Choose Playwright for cross-browser end-to-end testing with the broadest browser coverage.

## Conclusion

Puppeteer remains a solid choice for teams that need programmatic Chrome control. Its 94,300 GitHub stars and active maintenance by the Chrome DevTools team signal long-term stability. For PDF generation, screenshot pipelines, and Chrome-based scraping, the library's API surface is unmatched. The Docker patterns, browser pool management, and retry logic in this guide provide a production-ready foundation.

**Action items:**

1. Clone the [official Puppeteer examples](https://github.com/puppeteer/puppeteer/tree/main/examples) and adapt the scraper pattern to your target site.
2. Build the Docker image from the Dockerfile in this guide and run it in your staging environment.
3. Set up the GitHub Actions workflow to capture screenshots or run regression tests on every PR.
4. Join the [dibi8 Telegram group](https://t.me/dibi8tech) to share your Puppeteer deployment patterns and get help from other developers running browser automation at scale.



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- [Puppeteer Official Documentation](https://pptr.dev/) — API reference and guides
- [Puppeteer GitHub Repository](https://github.com/puppeteer/puppeteer) — Source code, issues, releases
- [Puppeteer Changelog](https://pptr.dev/changelog) — Version history and breaking changes
- [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/) — Low-level protocol docs
- [Puppeteer Docker Examples](https://github.com/puppeteer/puppeteer/tree/main/docker) — Official Docker configurations
- [WebDriver BiDi Specification](https://w3c.github.io/webdriver-bidi/) — Cross-browser automation standard
- [Puppeteer vs Playwright Benchmark Study](https://getautonoma.com/blog/selenium-playwright-cypress-comparison) — Independent performance comparison
- [Browserless.io Puppeteer Hosting](https://www.browserless.io/) — Managed Puppeteer infrastructure
