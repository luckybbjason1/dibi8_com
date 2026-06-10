---
title: 'Obscura: Rust Headless Browser for AI Agents — 14,000 Stars — 30MB Memory, 85ms Load — Setup Guide 2026'
description: 'Obscura (14,788 GitHub stars) is a Rust headless browser engine for AI agents and web scraping. 30MB memory, 85ms page load, built-in anti-detection. Drop-in replacement for headless Chrome with Puppeteer and Playwright support. Docker and binary installs.'
date: 2026-06-09
slug: 'obscura-rust-headless-browser-ai-agents-web-scraping'
category: 'dev-utils'
tags: ['obscura', 'headless browser', 'Rust browser', 'web scraping', 'AI agent tools', 'Puppeteer alternative', 'Playwright alternative', 'anti-detection', 'stealth browsing']
github_repo: 'https://github.com/h4ckf0r0day/obscura'
stars: 14788
maintainer: 'h4ckf0r0day'
license: Apache-2.0
featureImage: 'https://raw.githubusercontent.com/h4ckf0r0day/obscura/main/assets/icon.png'
lang: en
---

# Obscura: Rust Headless Browser for AI Agents — 14,000 Stars — 30MB Memory, 85ms Load — Setup Guide 2026

```
┌───────────────────────────────────────────────────┐
│             Obscura Architecture                    │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │           CLI / Server Interface              │   │
│  │  fetch │ serve │ scrape │ eval │ dump        │   │
│  └──────────────────────┬──────────────────────┘   │
│                         │                           │
│          ┌──────────────┼──────────────┐           │
│          ▼              ▼              ▼           │
│  ┌────────────┐  ┌────────────┐  ┌──────────┐    │
│  │  fetch()   │  │  serve()   │  │ scrape() │    │
│  │ Single page │  │ CDP server │  │ Parallel │    │
│  └─────┬──────┘  └─────┬──────┘  └────┬─────┘    │
│        │               │               │           │
│        ▼               ▼               ▼           │
│  ┌─────────────────────────────────────────────┐   │
│  │           Rust Core Engine                   │   │
│  │  • V8 JavaScript engine                      │   │
│  │  • Chrome DevTools Protocol (CDP)            │   │
│  │  • Stealth mode (anti-detection)             │   │
│  │  • Tracker blocking                          │   │
│  └─────────────────────────────────────────────┘   │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │     Drop-in replacement for Chrome           │   │
│  │     ✅ Puppeteer      ✅ Playwright          │   │
│  └─────────────────────────────────────────────┘   │
└───────────────────────────────────────────────────┘
```

Obscura is a headless browser engine written in Rust, purpose-built for web scraping and AI agent automation. At just 30MB of memory usage and 85ms page load times, it dramatically outperforms headless Chrome while providing built-in anti-detection features.

Created by `h4ckf0r0day`, Obscura has reached 14,788 GitHub stars and is designed as a drop-in replacement for headless Chrome when used with Puppeteer and Playwright. The key differentiator: it runs real JavaScript via V8 but with a fraction of the resource overhead.

This guide covers installation, CLI usage, CDP server setup, puppeteer/playwright integration, and production deployment.

## What Is Obscura?

Obscura is a headless browser engine that implements the Chrome DevTools Protocol (CDP) in Rust. Unlike headless Chrome, which is essentially a stripped-down Chrome browser, Obscura is built from the ground up for automation — not desktop browsing.

The key metrics that set Obscura apart:

| Metric | Obscura | Headless Chrome |
|--------|---------|----------------|
| Memory | **30 MB** | 200+ MB |
| Binary size | **70 MB** | 300+ MB |
| Anti-detect | **Built-in** | None |
| Page load | **85 ms** | ~500 ms |
| Startup | **Instant** | ~2 seconds |
| Puppeteer | **Yes** | Yes |
| Playwright | **Yes** | Yes |

This isn't a toy — it's a production-grade browser engine that happens to be 7x more memory-efficient than Chrome.

### Why "Obscura"?

The name references the Latin word for "darkness" or "hidden" — apt for a browser built for stealth. In an era of bot detection, AI agent fingerprinting, and anti-scraping measures, Obscura provides built-in anti-detection capabilities that headless Chrome simply doesn't have.

## How Obscura Works

Obscura uses the V8 JavaScript engine (the same engine that powers Chrome and Node.js) to execute JavaScript, but its browser rendering pipeline is custom-built in Rust. This means it gets Chrome-level JavaScript compatibility with Rust-level performance.

```
Request (fetch / scrape / serve)
    │
    ▼
┌─────────────────────────────┐
│    Command Parser            │
│  (CLI args, CDP commands)    │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│    Navigation Manager        │
│  (URL resolution, redirects, │
│   proxy handling)            │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│    V8 JavaScript Engine      │
│  (JS execution, DOM building, │
│   CSS rendering, APIs)       │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│    Output Processor          │
│  (HTML dump, JSON, text,     │
│   eval result, assets)       │
└─────────────────────────────┘
```

The `serve` command starts a CDP-compatible server that accepts connections from Puppeteer and Playwright. The `fetch` command runs one-off page operations. The `scrape` command runs parallel page operations with configurable concurrency.

## Installation & Setup

### Binary Install (Recommended)

Download the latest binary from the [Releases page](https://github.com/h4ckf0r0day/obscura/releases):

```bash
# Linux x86_64
curl -LO https://github.com/h4ckf0r0day/obscura/releases/latest/download/obscura-x86_64-linux.tar.gz
tar xzf obscura-x86_64-linux.tar.gz
./obscura fetch https://example.com --eval "document.title"

# Linux ARM64 (aarch64)
curl -LO https://github.com/h4ckf0r0day/obscura/releases/latest/download/obscura-aarch64-linux.tar.gz
tar xzf obscura-aarch64-linux.tar.gz

# macOS Apple Silicon
curl -LO https://github.com/h4ckf0r0day/obscura/releases/latest/download/obscura-aarch64-macos.tar.gz
tar xzf obscura-aarch64-macos.tar.gz

# macOS Intel
curl -LO https://github.com/h4ckf0r0day/obscura/releases/latest/download/obscura-x86_64-macos.tar.gz
tar xzf obscura-x86_64-macos.tar.gz

# Windows
# Download the .zip from the releases page and extract manually
```

No Chrome, no Node.js, no dependencies. Release archives include both `obscura` and `obscura-worker` binaries — keep them in the same directory for the parallel `scrape` command.

Linux releases target Ubuntu 22.04 (glibc 2.35+) for compatibility with common LTS servers.

### Arch Linux (AUR)

```bash
yay -S obscura-browser
```

### Docker

```bash
docker run -d --name obscura -p 127.0.0.1:9222:9222 h4ckf0r0day/obscura
```

The Docker image is multi-stage built on `distroless/cc` — no shell, no package manager, approximately 57 MB compressed.

### Build from Source

```bash
git clone https://github.com/h4ckf0r0day/obscura.git
cd obscura

# Standard build (first build takes ~5 min due to V8 compilation)
cargo build --release

# With stealth mode (anti-detection + tracker blocking)
cargo build --release --features stealth
```

Requires Rust 1.75+ ([rustup.rs](https://rustup.rs)). Subsequent builds are fast thanks to cargo's caching.

## Quick Start

### Fetch a Page

```bash
# Get the page title
obscura fetch https://example.com --eval "document.title"

# Extract all links
obscura fetch https://example.com --dump links

# Render JavaScript and dump HTML
obscura fetch https://news.ycombinator.com --dump html

# Write output to a file
obscura fetch https://example.com --dump text --output page.txt

# Stream raw response body (binary-safe; for images, JSON, CSS)
obscura fetch https://picsum.photos/200/300 --dump original > photo.jpg

# List every sub-resource URL (NDJSON format)
obscura fetch https://example.com --dump assets

# Fetch through a proxy
obscura --proxy socks5://127.0.0.1:1080 fetch https://example.com --dump text

# Wait for dynamic content to load
obscura fetch https://example.com --wait-until networkidle0

# Set navigation timeout for slow pages
obscura fetch https://example.com --timeout 10
```

### Start the CDP Server

For Puppeteer/Playwright compatibility:

```bash
# Standard CDP server
obscura serve --port 9222

# With stealth mode (anti-detection + tracker blocking)
obscura serve --port 9222 --stealth
```

Once running, connect with Puppeteer or Playwright:

```javascript
// Puppeteer connection
const puppeteer = require('puppeteer-core');

const browser = await puppeteer.connect({
  browserURL: 'http://127.0.0.1:9222',
});

const page = await browser.newPage();
await page.goto('https://example.com');
console.log(await page.title());
```

```javascript
// Playwright connection
const { chromium } = require('@playwright/test');

const browser = await chromium.connectOverCDP('http://127.0.0.1:9222');
const context = await browser.newContext();
const page = await context.newPage();
await page.goto('https://example.com');
console.log(await page.title());
```

### Scrape in Parallel

```bash
# Scrape multiple pages in parallel
obscura scrape url1 url2 url3 ... \
  --concurrency 25 \
  --eval "document.querySelector('h1').textContent"

# Scrape and save results
obscura scrape site.com/page1 site.com/page2 \
  --concurrency 50 \
  --dump html \
  --output-dir ./scraped/
```

The `scrape` command requires both `obscura` and `obscura-worker` binaries in the same directory.

## Integration with Popular Frameworks

### Puppeteer Integration

```javascript
// Use Obscura as a Puppeteer browser
const puppeteer = require('puppeteer-extra');
const StealthPlugin = require('puppeteer-extra-plugin-stealth');
puppeteer.use(StealthPlugin());

// Connect to Obscura CDP server
const browser = await puppeteer.connect({
  browserURL: 'http://localhost:9222',
  defaultViewport: null,
});

// Your existing Puppeteer code works unchanged
const page = await browser.newPage();
await page.goto('https://target-site.com');
const data = await page.$$eval('.item', items =>
  items.map(i => i.textContent)
);
```

### Playwright Integration

```python
# Python Playwright connection
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.connect_over_cdp(
        "http://localhost:9222"
    )
    page = browser.new_page()
    page.goto("https://example.com")
    print(page.title())
    browser.close()
```

### AI Agent Integration

```python
# Use Obscura in an AI agent workflow
import subprocess

def fetch_page_text(url):
    """Fetch a page and extract text using Obscura"""
    result = subprocess.run(
        ["./obscura", "fetch", url, "--dump", "text"],
        capture_output=True, text=True, timeout=30
    )
    return result.stdout

# AI agent can use this to fetch and analyze web content
def analyze_page(agent, url):
    content = fetch_page_text(url)
    agent.prompt(f"Analyze this page content:\n{content}")
```

### Web Scraping Pipeline

```bash
#!/bin/bash
# Automated scraping pipeline using Obscura

# Define target URLs
urls=(
  "https://example.com/page1"
  "https://example.com/page2"
  "https://example.com/page3"
)

# Scrape all pages in parallel
obscura scrape "${urls[@]}" \
  --concurrency 20 \
  --dump html \
  --output-dir ./output/ \
  --timeout 15

# Post-process results
for f in ./output/*.html; do
  echo "Processing: $(basename $f)"
  ./obscura fetch "$f" --dump text --output "${f%.html}.txt"
done
```

## Benchmarks & Performance

### Resource Usage

| Scenario | Obscura | Headless Chrome |
|----------|---------|----------------|
| Idle browser | 30 MB RAM | 200+ MB RAM |
| Single page load | ~5 MB additional | ~50 MB additional |
| 100 concurrent pages | ~300 MB total | ~20+ GB total |
| Binary size | 70 MB | 300+ MB |
| Docker image | 57 MB (distroless) | 500+ MB |

### Page Load Performance

| Page Type | Obscura | Headless Chrome |
|-----------|---------|----------------|
| Static HTML | ~15 ms | ~80 ms |
| JS-rendered SPA | ~85 ms | ~500 ms |
| Heavy dashboard | ~200 ms | ~1500 ms |
| Page startup | Instant | ~2 seconds |

### Memory Scaling Test (100 concurrent pages)

```bash
# Test with Obscura
obscura scrape $(seq -w 1 100 | sed 's/^/https://example.com\/page_/') \
  --concurrency 100 \
  --dump text \
  --output /dev/null
# Total RAM: ~280-320 MB

# Equivalent test with headless Chrome (Puppeteer)
# Total RAM: ~15-25 GB
```

## Advanced Usage

### Stealth Mode

The stealth feature provides built-in anti-detection capabilities:

```bash
# Build with stealth support
cargo build --release --features stealth

# Or use the binary with stealth flag
./obscura serve --port 9222 --stealth

# Stealth mode includes:
# - Navigator plugin spoofing
# - WebGL renderer obfuscation
# - Permissions API handling
# - Chrome runtime property masking
# - Tracker script blocking
```

### Proxy Support

```bash
# HTTP proxy
obscura --proxy http://user:pass@proxy.example.com:8080 \
  fetch https://example.com

# SOCKS5 proxy
obscura --proxy socks5://127.0.0.1:1080 \
  fetch https://example.com

# Proxy with Puppeteer
const browser = await puppeteer.connect({
  browserURL: 'http://localhost:9222',
  defaultBrowserOptions: {
    args: ['--proxy-server=http://proxy:8080']
  }
});
```

### Custom Navigation Options

```bash
# Wait for specific element to appear
obscura fetch https://example.com \
  --wait-selector ".content-loaded"

# Wait for specific network condition
obscura fetch https://example.com \
  --wait-until networkidle0

# Custom viewport size
obscura fetch https://example.com \
  --viewport 1920x1080

# User agent override
obscura fetch https://example.com \
  --user-agent "Mozilla/5.0 (compatible; MyBot/1.0)"
```

### Cookie and Session Management

```bash
# Set cookies before loading a page
obscura --cookie "session=abc123; token=xyz789" \
  fetch https://private.example.com

# Extract cookies from a session
obscura fetch https://example.com \
  --dump cookies --output cookies.json
```

## Comparison with Alternatives

| Feature | Obscura | Headless Chrome | Playwright Browser | Selenium |
|---------|---------|----------------|-------------------|----------|
| Memory usage | 30 MB | 200+ MB | 150+ MB | 300+ MB |
| Language | Rust | C++ | TypeScript/JS | Multi |
| CDP support | Native | Native | Via Chrome | Via Chrome |
| Puppeteer | ✅ Yes | ✅ Yes | ✅ Yes | ❌ No |
| Playwright | ✅ Yes | ✅ Yes | ✅ Yes | ❌ No |
| Anti-detect | ✅ Built-in | ❌ Plugin needed | Plugin needed | ❌ No |
| Parallel scraping | ✅ Native | ❌ Heavy | ❌ Heavy | ❌ No |
| Install complexity | Binary/Docker | Large binary | Node.js + Chrome | WebDriver |
| Startup time | Instant | ~2s | ~3s | ~5s |
| License | Apache-2.0 | BSD | Apache-2.0 | Apache-2.0 |

## Limitations / Honest Assessment

Obscura is powerful but not a perfect replacement for every use case:

1. **Young project** — Despite 14,788 stars, Obscura is still in active development. Edge cases in complex JavaScript frameworks may not be fully covered.

2. **Desktop browsing not optimized** — It's built for automation, not desktop use. UI rendering, accessibility features, and print output may differ from Chrome.

3. **No built-in proxy rotation** — While it supports proxy connections, there's no built-in proxy pool or rotation. You'll need an external proxy service for large-scale scraping.

4. **Limited browser extensions** — Unlike Chrome, Obscura doesn't support browser extensions (AdBlock, uBlock, etc.). You'll need to implement ad-blocking logic in your scripts.

5. **Docker image is minimal** — The 57 MB Docker image has no shell or package manager. Debugging inside the container requires the `obscura` binary's built-in logging flags.

6. **Obscura Cloud is beta** — The hosted version (managed infrastructure, residential proxies) is currently in waitlist/beta. The open-source engine remains fully featured with no feature gating.

## Frequently Asked Questions

**Q: Can Obscura replace headless Chrome in my existing Puppeteer scripts?**

A: Yes, as long as you connect via CDP (`browserURL` or `connectOverCDP`). The browser-level behavior matches Chrome closely since it uses the same V8 engine and implements the CDP protocol.

**Q: How does the stealth mode compare to puppeteer-extra-stealth?**

A: Obscura's stealth mode is built into the engine rather than added as a post-processing layer. This means it handles fingerprinting at the browser level (navigator properties, WebGL, audio context) rather than patching them after the fact — resulting in more consistent results.

**Q: Can I use Obscura for browser testing?**

A: Yes, for most use cases. Its CDP compatibility means you can run existing Playwright/Puppeteer test suites against Obscura. However, some tests that rely on Chrome-specific rendering or extension behavior may need adjustment.

**Q: Is there an official Docker image?**

A: Yes, `h4ckf0r0day/obscura` is available on Docker Hub. It's a multi-stage build on `distroless/cc` for minimal size (57 MB compressed).

**Q: What about JavaScript compatibility?**

A: Obscura uses the V8 engine, the same engine as Chrome. JavaScript compatibility is essentially identical to Chrome — no missing APIs, no polyfills needed.

**Q: Can I run Obscura on serverless platforms?**

A: Since it's a single binary with zero dependencies, you can run it anywhere that supports statically compiled Rust binaries — Lambda, Cloud Functions, Fly.io, etc.

## Conclusion

Obscura represents a significant advance in headless browser technology. At 30MB memory, 85ms page loads, and built-in anti-detection, it solves the fundamental problem that has plagued web scraping and AI agent automation for years: Chrome is simply too heavy for large-scale, concurrent browser operations.

For AI agents that need to browse the web, scrape content, or interact with JavaScript-heavy sites — Obscura provides the performance headroom that headless Chrome simply cannot match. The Puppeteer and Playwright compatibility means your existing scripts work unchanged.

The upcoming Obscura Cloud hosted service (managed infrastructure + residential proxies) will make it even easier to deploy at scale, while the open-source engine stays Apache-2.0 with no feature gating.

![Obscura Architecture](https://raw.githubusercontent.com/h4ckf0r0day/obscura/main/assets/icon.png)

![Obscura Swiftproxy Sponsor](https://raw.githubusercontent.com/h4ckf0r0day/obscura/main/assets/sponsors/swiftproxy2.png)

![Obscura ProxyEmpire Sponsor](https://raw.githubusercontent.com/h4ckf0r0day/obscura/main/assets/sponsors/proxyempire.png)

**Try Obscura:** [github.com/h4ckf0r0day/obscura](https://github.com/h4ckf0r0day/obscura)

**Related articles:**
- [Codegraph](https://dibi8.com/codegraph-pre-indexed-code-knowledge-graph-ai-agents) — Pre-indexed code knowledge graph for AI agents
- [MarkItDown](https://dibi8.com/microsoft-markitdown-file-to-markdown-converter-cli) — Convert any file to markdown

**Sources & Further Reading:**
- GitHub repository: https://github.com/h4ckf0r0day/obscura
- Docker Hub: https://hub.docker.com/r/h4ckf0r0day/obscura
- Releases page: https://github.com/h4ckf0r0day/obscura/releases
- CDP documentation: https://chromedevtools.github.io/devtools-protocol/
- V8 engine: https://v8.dev

---

Join our community for more AI tool deep-dives: [t.me/DIBI8_Group](https://t.me/DIBI8_Group)

**Disclaimer:** This article is for informational purposes only. Always review source code before running third-party software in production. Affiliate disclosure: Some links above may contain affiliate codes. We may earn a commission at no extra cost to you.
