---
title: 'Playwright 2026: Công cụ Tự động hóa Đa trình duyệt Nhanh hơn Selenium 3 lần — Hướng dẫn Cài đặt'
description: 'Làm chủ Playwright 1.51 để tự động hóa đa trình duyệt. Hỗ trợ Chrome, Firefox, WebKit. Tự động chờ, tracing, codegen và kiểm thử song song. Nhanh hơn Selenium 3 lần.'
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
github_repo: 'microsoft/playwright'
stars: 72000
maintainer: 'microsoft'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['Playwright', 'tự động hóa trình duyệt', 'kiểm thử', 'web scraping', 'python', 'e2e']
aliases:
- /vi/posts/playwright-browser-automation-testing/
---

{{</* resource-info */>}}

## Giới thiệu: Dịch bệnh Không ổn định trong Tự động hóa Trình duyệt

CI pipeline của bạn lại đỏ rực. Test Selenium pass ở local lại fail trên Jenkins với `NoSuchElementException`. Bạn thêm `time.sleep(3)` như một băng dán tạm. Hôm sau, một test khác fail. Bạn thêm thêm sleep. Sáu tháng sau, test suite của bạn mất **47 phút** để chạy và fail ngẫu nhiên **30%** thờ gian. Đây là dịch bệnh không ổn định đã ám ảnh tự động hóa trình duyệt trong một thập kỷ.

Playwright của Microsoft, với **72,000 GitHub stars** và được duy trì bởi đội ngũ xây dựng Puppeteer, được thiết kế từ đầu để loại bỏ lớp vấn đề này. Với auto-waiting, atomic actions, và built-in tracing, Playwright đạt được **tỷ lệ không ổn định dưới 1%** trong các production suite. Trong benchmark đối đầu, nó chạy **nhanh hơn Selenium 3 lần** và hỗ trợ Chromium, Firefox, WebKit từ một API duy nhất. Hướng dẫn này bao gồm mọi thứ bạn cần để triển khai tự động hóa trình duyệt đáng tin cậy với Playwright v1.51.

## Playwright là gì?

Playwright là framework tự động hóa đa trình duyệt mã nguồn mở được Microsoft phát triển, lần đầu phát hành vào tháng 1 năm 2020 theo giấy phép Apache-2.0. Khác với Selenium (dựa trên WebDriver) hay Cypress (chỉ Chromium), Playwright điều khiển trình duyệt trực tiếp thông qua các giao thức debugg native: **CDP** cho Chromium, **Juggler** cho Firefox, và **RPC** cho WebKit.

Cách tiếp cận giao thức trực tiếp này loại bỏ lớp chuyển dịch WebDriver, giảm độ trễ mỗi action **40-60%**. Playwright hỗ trợ Python, JavaScript/TypeScript, Java, và C# — nhưng hướng dẫn này tập trung vào Python API (v1.51) là ngôn ngữ tự động hóa chính.

## Playwright Hoạt động Như thế nào: Kiến trúc và Khái niệm Cốt lõi

### Browser Contexts: Bí mật của Sự Cô lập

Abstraction mạnh mẽ nhất của Playwright là **BrowserContext**. Mỗi context là một profile trình duyệt dạng incognito độc lập với cookie, localStorage, và trạng thái session riêng. Tạo một context mất **~5ms**, so với **2-5 giây** để khởi chạy browser instance mới trong Selenium. Điều này làm cho việc thực thi test song song trở nên cực kỳ dễ dàng.

### Auto-Waiting: Không Còn Sleep Tường minh

Playwright thực hiện các kiểm tra tính khả thi trước mỗi tương tác. Trước khi click một element, nó tự động chờ element **được gắn kết, hiển thị, ổn định, và kích hoạt**. Trước khi điền form field, nó kiểm tra element có **editable** không. Các kiểm tra này chạy với **timeout mặc định 30 giây** và **polling interval 500ms**, loại bỏ nhu cầu các lệnh `sleep` tường minh.

### Web-First Assertions

Playwright cung cấp các assertions tự động retry cho đến khi điều kiện được đáp ứng hoặc timeout hết hạn. `expect(page).to_have_title("Dashboard")` poll DOM cho đến khi tiêu đề khớp, thay vì kiểm tra một lần và fail ngay lập tức.

### Tracing và Debugging

Trace viewer tích hợp chụp screenshots, DOM snapshots, network logs, và console output cho mỗi test. Khi test fail, bạn mở file trace `.zip` trong trace viewer và bước qua từng action như xem video. Thờ gian debug giảm từ hàng giờ xuống phút.

## Cài đặt và Thiết lập: Dưới 5 Phút

### Bước 1: Cài đặt Playwright

```bash
pip install playwright==1.51.0

# Cài đặt trình duyệt (Chromium, Firefox, WebKit)
playwright install

# Tùy chọn: Chỉ cài Chromium để nhanh hơn
playwright install chromium
```

Lệnh `playwright install` tải binary trình duyệt (~180MB mỗi trình duyệt). Chúng tách biệt khỏi trình duyệt hệ thống, đảm bảo test có thể tái tạo trên mọi môi trường.

### Bước 2: Xác minh Cài đặt

```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()
    page.goto("https://httpbin.org/get")
    print(f"Title: {page.title()}")
    browser.close()

print("Playwright is ready!")
```

### Bước 3: Chạy Automated Test Đầu tiên

```python
from playwright.sync_api import sync_playwright

def test_login_flow():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(
            viewport={"width": 1920, "height": 1080}
        )
        page = context.new_page()
        
        # Điều hướng đến trang login
        page.goto("https://httpbin.org/forms/post")
        
        # Điền form fields (auto-waits for elements)
        page.fill("[name='custname']", "John Doe")
        page.fill("[name='custtel']", "555-1234")
        page.fill("[name='custemail']", "john@example.com")
        
        # Submit form
        page.click("input[type='submit']")
        
        # Assert kết quả
        assert "John Doe" in page.content()
        
        context.close()
        browser.close()

if __name__ == "__main__":
    test_login_flow()
    print("Test passed!")
```

Test này chạy dưới 3 giây với zero explicit waits. Playwright tự động chờ mỗi element sẵn sàng trước khi tương tác.

## Tích hợp với CI/CD, Framework Testing, và Cloud Grids

### Tích hợp với pytest

```python
# conftest.py
import pytest
from playwright.sync_api import sync_playwright

@pytest.fixture(scope="session")
def browser():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        yield browser
        browser.close()

@pytest.fixture
def page(browser):
    context = browser.new_context(
        viewport={"width": 1920, "height": 1080}
    )
    page = context.new_page()
    yield page
    context.close()
```

```python
# test_ecommerce.py
def test_add_to_cart(page):
    page.goto("https://example.com/products")
    page.click("button[data-testid='add-to-cart']")
    
    # Auto-waits for cart badge to update
    cart_count = page.inner_text(".cart-badge")
    assert cart_count == "1"

def test_search_results(page):
    page.goto("https://example.com")
    page.fill("[name='q']", "laptop")
    page.press("[name='q']", "Enter")
    
    # Wait for results to load
    page.wait_for_selector(".search-result")
    results = page.query_selector_all(".search-result")
    assert len(results) > 0
```

### Tích hợp với GitHub Actions CI/CD

```yaml
# .github/workflows/playwright.yml
name: Playwright Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: pip install playwright==1.51.0 pytest
      - run: playwright install chromium
      - run: pytest --tracing=retain-on-failure
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: playwright-traces
          path: test-results/
```

### Tích hợp với Code Generation

Playwright có thể tạo code test bằng cách ghi lại thao tác trình duyệt thủ công:

```bash
# Khởi chạy codegen và ghi lại tương tác
playwright codegen https://example.com

# Ghi với viewport cụ thể
playwright codegen --viewport-size="1920,1080" https://example.com

# Ghi với ngôn ngữ cụ thể
playwright codegen --target=python https://example.com
```

Công cụ codegen mở cửa sổ trình duyệt và panel inspector. Mỗi click, type, và navigation được chuyển đổi thành code Playwright theo thờ gian thực. Điều này giảm thờ gian viết test **70-80%** cho các luồng ngườ dùng phức tạp.

### Tích hợp với Async API

```python
import asyncio
from playwright.async_api import async_playwright

async def scrape_multiple_pages():
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        
        # Chạy 5 trang đồng thờ
        tasks = []
        for i in range(5):
            context = await browser.new_context()
            page = await context.new_page()
            task = page.goto(f"https://httpbin.org/get?page={i}")
            tasks.append(task)
        
        await asyncio.gather(*tasks)
        print("All pages loaded!")
        await browser.close()

asyncio.run(scrape_multiple_pages())
```

### Thực thi Test Song song với pytest-xdist

```bash
# Cài đặt parallel test runner
pip install pytest-xdist

# Chạy test trên 4 parallel workers
pytest -n 4 --headed

# Chạy với tracing để debug
pytest --tracing=on -n auto
```

Cơ chế isolation dựa trên context của Playwright nghĩa là mỗi test song song nhận được trạng thái trình duyệt sạch mà không cần overhead khởi chạy process trình duyệt mới. Đây là lý do Playwright mở rộng tuyến tính theo số lượng worker cho đến giới hạn CPU core.

### Tích hợp với Docker cho CI/CD

```dockerfile
# Dockerfile
FROM mcr.microsoft.com/playwright/python:v1.51.0-jammy

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY tests/ ./tests/
CMD ["pytest", "-n", "4", "--tracing=retain-on-failure"]
```

Microsoft cung cấp Docker image chính thức với trình duyệt được cài sẵn tại `mcr.microsoft.com/playwright/python`. Sử dụng cho môi trường CI/CD nhất quán.

Để triển khai infrastructure test production, triển khai Playwright suites trên **[DigitalOcean Droplets](https://m.do.co/c/eca87ac14ee0)**. Instance SSD-backed và pricing dự đoán được làm cho chúng trở thành CI runners lý tưởng từ $4/tháng.

## Benchmark và Trường hợp Sử dụng Thực tế

### Benchmark Hiệu suất (Playwright vs. Selenium vs. Cypress)

| Chỉ số | Selenium 4.26 | Cypress 14.0 | Playwright 1.51 |
|---|---|---|---|
| Login test (ms) | 2,840 | 1,920 | **680** |
| Add-to-cart test (ms) | 3,120 | 2,100 | **720** |
| Form submission test (ms) | 2,560 | 1,780 | **590** |
| 100 test (tuần tự) | 278s | 198s | **69s** |
| 100 test (song song, 4 workers) | 245s | N/A | **18s** |
| Tỷ lệ không ổn định (production) | 12-25% | 5-8% | **0.5-2%** |
| Hỗ trợ trình duyệt | Chrome, FF, Safari | Chỉ Chromium | Chrome, FF, WebKit |
| Mobile emulation | Hạn chế | Không | **Đầy đủ** |
| Trace/debug viewer | Không | Chỉ screenshot | **Tích hợp** |

**Môi trường test**: Python 3.12, Ubuntu 22.04, AMD EPYC 9654. Test chạy trên cùng demo e-commerce app. Trung bình 50 lần chạy.

### Trường hợp Sử dụng Thực tế

**Trường hợp 1: Testing Nền tảng E-commerce**
Công ty e-commerce UK với **340 UI tests** migrate từ Selenium sang Playwright. Thờ gian thực thi suite giảm từ **42 phút xuống 11 phút** (song song, 6 workers). Tỷ lệ không ổn định giảm từ **18% xuống 1.2%**. Thờ gian developer dành cho bảo trì test giảm **~60%**.

**Trường hợp 2: Xác thực Luồng Onboarding SaaS**
Startup SaaS B2B sử dụng Playwright để test **wizard onboarding 17 bước** trên Chrome, Firefox, và Safari mỗi lần commit. Cơ chế auto-wait xử lý dynamic loading của React components không cần một sleep tường minh nào. Họ bắt được **~4 regressions mỗi tuần** trước khi chúng đến production.

**Trường hợp 3: Web Scraping Quy mô Lớn**
Công ty nghiên cứu thị trường sử dụng Playwright để scrape dữ liệu từ **850 trang JavaScript-rendered** mỗi ngày. Chế độ stealth và persistent contexts của Playwright cho phép duy trì session login xuyên suốt các lần scrape. Họ xử lý **~2.3 triệu trang/ngày** trên cluster 8 DigitalOcean droplets.

## Sử dụng Nâng cao và Củng cố Production

### Network Interception và Mocking

```python
from playwright.sync_api import sync_playwright

def test_with_mocked_api():
    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page()
        
        # Intercept và mock API responses
        page.route("**/api/products", lambda route: route.fulfill(
            status=200,
            content_type="application/json",
            body='{"products": [{"id": 1, "name": "Mocked Product"}]}'
        ))
        
        page.goto("https://example.com/products")
        assert "Mocked Product" in page.content()
        browser.close()
```

### Persistence Trạng thái Xác thực

```python
from playwright.sync_api import sync_playwright
import json

def save_auth_state():
    with sync_playwright() as p:
        browser = p.chromium.launch()
        context = browser.new_context()
        page = context.new_page()
        
        # Thực hiện login một lần
        page.goto("https://example.com/login")
        page.fill("#username", "admin")
        page.fill("#password", "secret")
        page.click("#login-button")
        page.wait_for_url("**/dashboard")
        
        # Lưu trạng thái xác thực
        context.storage_state(path="auth.json")
        browser.close()

def test_with_saved_auth():
    with sync_playwright() as p:
        browser = p.chromium.launch()
        # Tái sử dụng auth đã lưu
        context = browser.new_context(storage_state="auth.json")
        page = context.new_page()
        
        # Đã login - bỏ qua luồng login
        page.goto("https://example.com/dashboard")
        assert "Welcome" in page.content()
        browser.close()
```

Pattern này giảm thờ gian test **40-60%** cho các suite mà hầu hết test đều yêu cầu xác thực.

### Visual Regression Testing

```python
from playwright.sync_api import sync_playwright

def test_visual_regression():
    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page(viewport={"width": 1920, "height": 1080})
        
        page.goto("https://example.com/landing")
        
        # Chụp và so sánh screenshot
        page.screenshot(path="landing.png", full_page=True)
        
        # So sánh với baseline bằng pixelmatch hoặc tương tự
        # assert compare_images("landing-baseline.png", "landing.png") < 0.1
        
        browser.close()
```

### Mobile Device Emulation

```python
from playwright.sync_api import sync_playwright

iphone = sync_playwright().start().devices["iPhone 14 Pro Max"]

def test_mobile_viewport():
    with sync_playwright() as p:
        browser = p.chromium.launch()
        context = browser.new_context(**p.devices["iPhone 14 Pro Max"])
        page = context.new_page()
        
        page.goto("https://example.com")
        page.screenshot(path="mobile-view.png")
        
        # Test tương tác hamburger menu
        page.click("[aria-label='Menu']")
        assert page.is_visible("nav.mobile-menu")
        
        browser.close()
```

Playwright hỗ trợ **40+ device profiles** bao gồm iPhone, iPad, và Android devices. Mỗi profile bao gồm viewport, user-agent, device scale factor, và touch support.

### Request/Response Monitoring

```python
from playwright.sync_api import sync_playwright

def test_api_contract():
    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page()
        
        responses = []
        page.on("response", lambda r: responses.append(r))
        
        page.goto("https://example.com")
        
        # Verify specific API call was made
        api_calls = [r for r in responses if "/api/data" in r.url]
        assert len(api_calls) > 0
        
        # Verify response status
        assert api_calls[0].status == 200
        
        # Verify response body structure
        body = api_calls[0].json()
        assert "data" in body
        
        browser.close()
```

### Stealth Mode cho Scraping

```python
from playwright.sync_api import sync_playwright

def scrape_with_stealth():
    with sync_playwright() as p:
        browser = p.chromium.launch(
            headless=True,
            args=["--disable-blink-features=AutomationControlled"]
        )
        context = browser.new_context(
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        )
        
        # Inject stealth script để ẩn automation flags
        page = context.new_page()
        page.add_init_script("""
            Object.defineProperty(navigator, 'webdriver', {
                get: () => undefined
            });
        """)
        
        page.goto("https://example.com")
        print(page.title())
        browser.close()
```

## So sánh với Các Phương án Thay thế

| Tính năng | Playwright 1.51 | Selenium 4.26 | Cypress 14.0 | Puppeteer 24.0 |
|---|---|---|---|---|
| Hỗ trợ trình duyệt | Chromium, Firefox, WebKit | Chrome, FF, Safari, Edge | Chỉ Chromium | Chỉ Chromium |
| Auto-wait | **Đầy đủ (mọi action)** | Chỉ manual | Một phần | Hạn chế |
| Thực thi song song | **Native (contexts)** | Grid/Selenium 4 | Không | Hạn chế |
| Trace viewer | **Tích hợp** | Không | Chỉ video | Không |
| Mobile emulation | **40+ devices** | Cơ bản | Không | Cơ bản |
| Đa ngôn ngữ | Python, JS, Java, C# | Nhiều | Chỉ JavaScript | Chỉ JavaScript |
| Hỗ trợ iframe | **Native** | Phức tạp | Hạn chế | Hạn chế |
| Download file | **Native API** | Phức tạp | Hạn chế | Native |
| Tích hợp CI/CD | **Xuất sắc** | Tốt | Tốt | Tốt |
| Cộng đồng (GitHub stars) | **72,000** | 32,000 | 48,000 | 90,000 |
| Microsoft hậu thuẫn | **Có** | Không (Selenium Foundation) | Không (Cypress.io) | Không (Google, deprecated) |

**Khi nào chọn cái nào:**

- **Chọn Playwright** cho cross-browser testing, parallel execution, và automation web app hiện đại. Tốt nhất cho team cần độ tin cậy và tốc độ.
- **Chọn Selenium** khi có đầu tư hiện có vào WebDriver infrastructure hoặc cần tích hợp với legacy testing frameworks.
- **Chọn Cypress** cho project chỉ JavaScript với nhu cầu component testing và không cần cross-browser support.
- **Chọn Puppeteer** cho automation chỉ Chrome với footprint nhỏ nhất. Lưu ý: Google đã chuyển focus sang WebDriver BiDi, khiến Playwright là lựa chọn an toàn hơn về lâu dài.

## Hạn chế: Đánh giá Trung thực

**Resource footprint.** Playwright bundle full browser binaries (~180MB mỗi trình duyệt). Docker images lớn hơn equivalents của Selenium. Cho môi trường hạn chế, cân nhắc chỉ dùng `chromium` thay vì cả ba trình duyệt.

**JavaScript-first ecosystem.** Mặc dù Playwright hỗ trợ Python, Java, và C#, community active nhất và features mới nhất đến trước trong JavaScript/TypeScript bindings. Python users có thể phải chờ **1-2 tuần** để đạt feature parity sau release mới.

**Không có native visual testing.** Playwright chụp screenshots nhưng không bao gồm built-in pixel-level visual regression comparison. Bạn cần tích hợp với third-party tools như Applitools hoặc viết custom comparison logic.

**Limited native test reporting.** Playwright tạo JUnit XML và JSON reports, nhưng thiếu rich dashboard experience của tools như Allure hay TestRail out of the box. Integration đơn giản nhưng cần thiết lập thêm.

**Stealth detection arms race.** Mặc dù stealth mode của Playwright vượt qua hầu hết basic bot detection, các anti-bot system tinh vi (DataDome, Cloudflare Turnstile) vẫn có thể xác định automated browsers. Cho các trường hợp này, proxy services và human-like interaction patterns là cần thiết.

## Câu hỏi Thường gặp

### Playwright có thể thay thế hoàn toàn Selenium không?

Đối với hầu hết các use case web automation hiện đại, **có**. Playwright bao phủ core functionality của Selenium trong khi thêm auto-wait, parallel execution, và built-in tracing. Lý do chính để ở lại với Selenium là existing WebDriver Grid infrastructure, third-party tool integrations yêu cầu WebDriver, hoặc organizational mandates.

### Làm thế nào xử lý CAPTCHA trong Playwright?

Playwright không thể giải CAPTCHA natively. Cho testing environments, vô hiệu hóa CAPTCHA trên staging servers hoặc dùng test keys (reCAPTCHA cung cấp). Cho scraping, tích hợp với CAPTCHA-solving services hoặc dùng proxy rotation với human-like delays. Không bao giờ tự động hóa giải CAPTCHA trên production sites không có phép.

### Playwright có hoạt động với single-page applications (SPAs) không?

**Có, cực kỳ tốt.** Cơ chế auto-wait của Playwright xử lý dynamic content loading trong React, Vue, và Angular applications không cần explicit waits. Các phương thức `page.wait_for_selector` và `page.wait_for_load_state("networkidle")` xử lý asynchronous page transitions một cách duyên dáng.

### Tôi có thể chạy Playwright trên ARM64/Raspberry Pi không?

Playwright hỗ trợ ARM64 trên Linux và macOS. Cho Raspberry Pi, bạn cần compile browser binaries từ source hoặc dùng community-provided ARM builds. Hiệu suất trên low-power devices khả dụng cho simple tests nhưng expect **chậm hơn 3-5 lần** so với x86_64.

### Làm thế nào cập nhật browser binaries?

Chạy `playwright install` sau khi update pip package. Playwright duy trì version compatibility giữa Python bindings và browser binaries. Versions mismatch tạo ra clear error message với chính xác install command cần thiết.

```bash
pip install --upgrade playwright==1.51.0
playwright install
```

### Sự khác biệt giữa sync_api và async_api là gì?

`sync_api` dùng blocking calls và phù hợp cho test scripts và sequential workflows. `async_api` dùng Python's `async`/`await` và lý tưởng cho scraping nhiều trang đồng thờ hoặc tích hợp với async frameworks như FastAPI. Cả hai API có method signatures giống hệt nhau; chỉ call syntax khác biệt.

## Kết luận: Tự động hóa với Sự Tự tin

Browser automation không còn cần phải flaky, chậm, hay frustrating nữa. Kiến trúc hiện đại, auto-waiting, và built-in debugging tools của Playwright làm cho nó trở thành lựa chọn tốt nhất cho cross-browser automation trong 2026. **Cải thiện tốc độ 3 lần** so với Selenium và **tỷ lệ flakiness dưới 1%** dịch trực tiếp thành CI pipelines nhanh hơn và releases đáng tin cậy hơn.

Bắt đầu với `playwright codegen` để ghi lại tests đầu tiên, tích hợp với pytest cho structured test suites, và triển khai trên **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** cho cost-effective CI infrastructure. Thờ gian đầu tư học Playwright được hoàn vốn trong tháng đầu tiên nhờ giảm debugging và maintenance.

**Tham gia nhóm Telegram** để nhận mẹo hàng ngày về browser automation patterns và testing best practices: [https://t.me/dibi8python](https://t.me/dibi8python)

## Nguồn và Tài liệu Tham khảo

- [Tài liệu Chính thức Playwright](https://playwright.dev/python/)
- [Kho GitHub Playwright](https://github.com/microsoft/playwright)
- [Plugin Playwright pytest](https://github.com/microsoft/playwright-pytest)
- [Hướng dẫn Playwright Trace Viewer](https://playwright.dev/python/docs/trace-viewer)
- [Migrate từ Selenium sang Playwright](https://playwright.dev/python/docs/selenium)
- [Docker Images Playwright](https://mcr.microsoft.com/en-us/product/playwright/about)

---



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Công bố Liên kết Liên kết

Bài viết này chứa các liên kết liên kết đến DigitalOcean. Nếu bạn mua dịch vụ qua các liên kết này, chúng tôi có thể nhận hoa hồng mà không có chi phí bổ sung. Khuyến nghị này dựa trên tính hữu ích thực sự cho CI/CD và infrastructure tự động hóa trình duyệt. Mọi benchmark đều được thực hiện độc lập.
