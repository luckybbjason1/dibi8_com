---
title: "Browser Harness：让 LLM 自主操控浏览器的自愈型神器"
description: "Browser Harness là framework điều khiển trình duyệt tự phục hồi, cho phép LLM tự động hoàn thành mọi tác vụ web. 11K+ Stars, viết bằng Python, hỗ trợ Playwright và Selenium."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Go
  - Python
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "1.2 MB"
file_md5: ""
download_url: "https://github.com/browser-use/browser-harness"
backup_url: ""
github_repo: "https://github.com/browser-use/browser-harness"
stars: 13142
maintainer: "browser-use"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
faqs:
  - q: 'Browser Harness là gì?'
    a: 'Browser Harness là một framework điều khiển trình duyệt tự phục hồi (self-healing), cho phép các mô hình ngôn ngữ lớn tự động hoàn thành các tác vụ web theo cách giống như con người. Nó được viết bằng Python, hỗ trợ cả Playwright lẫn Selenium, và do nhóm browser-use duy trì.'
  - q: 'Cơ chế tự phục hồi của Browser Harness hoạt động như thế nào?'
    a: 'Khi một thao tác thất bại, Browser Harness sẽ chụp ảnh màn hình, để LLM chẩn đoán vấn đề, tạo ra chiến lược mới và thử lại. Nó lặp lại chu trình phát hiện - phân tích - tạo lại - thử lại này cho đến khi tác vụ thành công hoặc xác nhận rằng tác vụ không thể hoàn thành.'
  - q: 'Browser Harness khác gì so với Playwright và Selenium?'
    a: 'Playwright và Selenium dựa vào các CSS selector hoặc XPath cố định, vốn sẽ hỏng khi trang thay đổi và đòi hỏi phải bảo trì thủ công. Thay vào đó, Browser Harness dùng một LLM để hiểu ngữ nghĩa của trang, tự động lập kế hoạch cho các tác vụ nhiều bước, và tự phục hồi khi selector thất bại, nhờ vậy bạn chỉ cần mô tả mục tiêu bằng ngôn ngữ tự nhiên thay vì lập trình từng bước.'
  - q: 'Browser Harness có thể xử lý CAPTCHA và nội dung động không?'
    a: 'Browser Harness có thể giải một số CAPTCHA bằng LLM và tự động chờ nội dung động, nhưng bài viết lưu ý rằng một số CAPTCHA phức tạp vẫn cần đến sự can thiệp của con người.'
  - q: 'Những hạn chế chính của Browser Harness là gì?'
    a: 'Các hạn chế của nó là chi phí (các lệnh gọi LLM API phát sinh phí, mặc dù có thể dùng các mô hình cục bộ), tốc độ (nó chậm hơn so với tự động hóa truyền thống vì mô hình cần thời gian để suy luận), độ an toàn (cần có các rào chắn nghiêm ngặt để ngăn thao tác sai), và những CAPTCHA phức tạp mà vẫn có thể cần đến con người.'
---
{</* resource-info */>}

## Vấn đề: Web crawler truyền thống đã chết, kỷ nguyên AI cần mô hình mới

Bạn viết một script crawler tuyệt đẹp, ngày hôm sau website thay đổi layout, tất cả đều hỏng. Bạn sửa lại selector, một tuần sau đường dẫn CDN thay đổi, lại hỏng. Bạn thêm xử lý ngoại lệ, nhưng captcha xuất hiện, hoàn toàn bị kẹt.

**Tự động hóa web truyền thống có ba điểm yếu chí mạng:**

1. **Mong manh** — Cấu trúc trang thay đổi, script toàn bộ die
2. **Tĩnh** — Chỉ thực thi quy trình định sẵn, không ứng phó được sự cố
3. **Bị động** — Gặp captcha, popup, lỗi tải là bó tay

Chúng ta cần một phương thức tự động hóa **như con người duyệt web** — nhìn thấy trang, hiểu ý định, tự sửa chữa.

## Browser Harness là gì?

[Browser Harness](https://github.com/browser-use/browser-harness) là **framework điều khiển trình duyệt tự phục hồi**, cho phép LLM (mô hình ngôn ngữ lớn) tự động hoàn thành mọi tác vụ web như con người.

- **11,251+ Stars** trên GitHub
- **1,019+ Forks**
- Viết bằng **Python**
- Hỗ trợ **Playwright** và **Selenium**
- Được team **browser-use** duy trì

Slogan cốt lõi: **"Self-healing harness that enables LLMs to complete any task."**

## Khả năng cốt lõi

### 1. Tự phục hồi (Self-Healing)

Tự động hóa truyền thống:
```python
# Selector mong manh, trang thay đổi là die
button = driver.find_element(By.CSS_SELECTOR, "#submit-btn")
button.click()
```

Browser Harness:
```python
# LLM hiểu ngữ nghĩa trang, tự tìm nút đúng
# Dù id thay đổi cũng hiểu qua ngữ cảnh
result = harness.execute("Nhấn nút gửi")
# Nếu không tìm thấy nút, LLM phân tích trang và đề xuất phương án thay thế
```

**Cơ chế tự phục hồi**:
- Thao tác thất bại → Chụp màn hình phân tích → LLM chẩn đoán → Tạo chiến lược mới → Thử lại
- Lặp cho đến khi thành công hoặc xác nhận không thể hoàn thành

### 2. Hiểu ngữ nghĩa (Semantic Understanding)

Browser Harness không phụ thuộc CSS selector mà để LLM **hiểu nội dung trang**:

```python
# Nói LLM mục tiêu, không phải bước
harness.execute("Tìm tai nghe không dây trên Amazon, sắp xếp theo đánh giá, chọn kết quả đầu tiên thêm vào giỏ")

# LLM tự động:
# 1. Tìm ô tìm kiếm
# 2. Nhập "wireless headphones"
# 3. Tìm menu sắp xếp
# 4. Chọn "Customer Reviews"
# 5. Tìm sản phẩm đầu tiên
# 6. Nhấn "Add to Cart"
```

### 3. Lập kế hoạch đa bước

```python
from browser_harness import Harness

harness = Harness(model="gpt-4o")

# Tác vụ phức tạp đa bước
task = """
Đặt vé máy bay từ Bắc Kinh đến Thượng Hải thứ Tư tuần sau,
yêu cầu:
- Khởi hành buổi sáng
- Giá dưới 1000 tệ
- China Eastern hoặc Air China
- Không cần hành lý ký gửi
"""

result = harness.execute(task)
# LLM lập kế hoạch:
# 1. Mở Ctrip/Qu哪儿
# 2. Chọn một chiều
# 3. Nhập Bắc Kinh → Thượng Hải
# 4. Chọn ngày thứ Tư tuần sau
# 5. Lọc chuyến bay buổi sáng
# 6. Sắp xếp theo giá
# 7. Lọc China Eastern/Air China
# 8. Chọn vé không hành lý
# 9. Điền thông tin hành khách
# 10. Gửi đơn hàng
```

### 4. Nhận thức thị giác (Visual Perception)

Browser Harness gửi ảnh chụp màn hình cho LLM, cho phép mô hình "nhìn thấy" web:

```python
# Phân tích ảnh chụp màn hình
screenshot = harness.screenshot()
analysis = harness.llm.analyze_image(screenshot, 
    "Trang này có biểu mẫu gì? Hãy mô tả nhãn và loại của mỗi ô nhập")

# LLM trả về:
# "Trang có biểu mẫu đăng nhập:
#  - Ô nhập tên người dùng (type=text)
#  - Ô nhập mật khẩu (type=password)
#  - Hộp kiểm Ghi nhớ tôi
#  - Nút đăng nhập"
```

### 5. So sánh với công cụ hiện có

| Tính năng | Browser Harness | Playwright | Selenium | Scrapy |
|------|----------------|-----------|----------|--------|
| **Tự phục hồi** | ✅ Tự sửa | ❌ Thủ công | ❌ Thủ công | ❌ Thủ công |
| **Hiểu ngữ nghĩa** | ✅ LLM điều khiển | ❌ Selector | ❌ Selector | ❌ XPath |
| **Lập kế hoạch đa bước** | ✅ Tự động | ⚠️ Cần code | ⚠️ Cần code | ⚠️ Cần code |
| **Xử lý captcha** | ✅ LLM giải | ❌ Cần bên thứ 3 | ❌ Cần bên thứ 3 | ❌ Cần bên thứ 3 |
| **Nội dung động** | ✅ Tự đợi | ⚠️ Cần cấu hình | ⚠️ Cần cấu hình | ⚠️ Cần cấu hình |
| **Độ khó học** | Thấp (ngôn ngữ tự nhiên) | Trung bình | Trung bình | Cao |

## Thiết kế kiến trúc

```
Browser Harness
├── LLM Core (GPT-4o / Claude / Local LLM)
├── Browser Controller (Playwright / Selenium)
├── Self-Healing Engine
│   ├── Error Detection
│   ├── Screenshot Analysis
│   ├── Strategy Regeneration
│   └── Retry Logic
├── Task Planner
│   ├── Goal Decomposition
│   ├── Step Sequencing
│   └── Dependency Resolution
└── Safety Guardrails
    ├── URL Whitelist
    ├── Action Limits
    └── Human-in-the-Loop
```

## Cài đặt và sử dụng

### Cài đặt

```bash
pip install browser-harness

# Cài đặt phụ thuộc trình duyệt
playwright install
```

### Cách dùng cơ bản

```python
from browser_harness import Harness

# Khởi tạo
harness = Harness(
    model="gpt-4o",  # hoặc "claude-3-5-sonnet"
    browser="chromium",
    headless=False   # Chế độ hiển thị để debug
)

# Thực thi tác vụ đơn giản
result = harness.execute("Mở Google tìm kiếm 'Python tutorial'")

# Thực thi tác vụ phức tạp
task = """
1. Truy cập github.com
2. Tìm 'browser-use/browser-harness'
3. Nhấn nút Star
4. Trả về số star
"""
result = harness.execute(task)
print(result)  # "Số Stars hiện tại: 11251"
```

### Cấu hình nâng cao

```python
from browser_harness import Harness, Config

config = Config(
    max_retries=3,           # Số lần thử lại tối đa
    retry_delay=2,           # Thời gian chờ thử lại (giây)
    screenshot_on_error=True, # Chụp màn hình khi lỗi
    human_in_the_loop=True,   # Thao tác quan trọng cần xác nhận người
    url_whitelist=[           # Danh sách trắng URL
        "*.github.com",
        "*.google.com"
    ]
)

harness = Harness(model="gpt-4o", config=config)
```

## Kịch bản ứng dụng thực tế

### Kịch bản 1: Kiểm thử tự động

```python
# Để LLM kiểm thử website của bạn
test_cases = [
    "Đăng ký người dùng mới, xác minh nhận email xác nhận",
    "Thêm sản phẩm vào giỏ hàng, kiểm tra tính tổng giá đúng",
    "Gửi biểu mẫu để trống trường bắt buộc, xác minh thông báo lỗi"
]

for test in test_cases:
    result = harness.execute(test)
    assert result.success, f"Kiểm thử thất bại: {test}"
```

### Kịch bản 2: Thu thập dữ liệu

```python
# Crawler thông minh, tự thích ứng thay đổi website
data = harness.execute("""
Truy cập example.com/products,
trích xuất tất cả sản phẩm:
- Tên
- Giá
- Đánh giá
- Tình trạng tồn kho
Lưu dạng JSON
""")
```

### Kịch bản 3: Tự động hóa văn phòng

```python
# Tự động xử lý tác vụ web hàng ngày
harness.execute("""
1. Đăng nhập hệ thống bồi thường công ty
2. Nộp đơn bồi thường công tác tháng trước
3. Tải lên PDF hóa đơn
4. Điền người phê duyệt
5. Gửi đơn
""")
```

### Kịch bản 4: Giám sát đối thủ

```python
# Kiểm tra giá đối thủ mỗi ngày
harness.execute("""
Truy cập amazon.com, tìm kiếm từ khóa sản phẩm cốt lõi của chúng ta,
ghi lại giá và đánh giá của 10 kết quả đầu,
tạo báo cáo so sánh
""")
```

## So sánh với dự án tương tự

| Dự án | Stars | Đặc điểm | Kịch bản phù hợp |
|------|-------|------|---------|
| **Browser Harness** | 11K+ | Tự phục hồi, LLM điều khiển | Tác vụ web chung |
| **Playwright** | 66K+ | Hiệu năng cao, đa trình duyệt | Kiểm thử tự động |
| **Selenium** | 30K+ | Trưởng thành ổn định | Tự động hóa truyền thống |
| **Scrapy** | 52K+ | Crawl quy mô lớn | Thu thập dữ liệu |
| **Crawl4AI** | 8K+ | AI crawler | Trích xuất nội dung |

## Hạn chế

- **Chi phí** — Gọi API LLM có phí (nhưng dùng được mô hình local)
- **Tốc độ** — Chậm hơn tự động hóa truyền thống (cần thời gian suy nghĩ)
- **Bảo mật** — Cần chính sách bảo mật nghiêm ngặt để tránh thao tác sai
- **Captcha phức tạp** — Một số captcha vẫn cần can thiệp người

## Kết luận

Browser Harness đại diện cho **mô hình mới của tự động hóa web** — từ "selector cứng nhắc" đến "agent hiểu biết".

- Khả năng tự phục hồi giảm đáng kể chi phí bảo trì
- Giao diện ngôn ngữ tự nhiên hạ thấp rào cản sử dụng
- Khả năng suy luận của LLM xử lý quy trình phức tạp
- Nhận thức thị giác giải quyết điểm mù của tự động hóa truyền thống

Nếu bạn đã chán việc sửa script crawler bị crash hàng tuần, Browser Harness đáng để thử.

**GitHub**: [browser-use/browser-harness](https://github.com/browser-use/browser-harness)  
**Stars**: 11,251+ | **Ngôn ngữ**: Python | **Giấy phép**: Mã nguồn mở

## Bài viết liên quan

- [Hermes Agent: AI Agent Tự Cải Thiện](/vi/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/)
- [Agent Reach: Trao Siêu Năng Lực Internet Cho AI Agent](/vi/resources/llm-frameworks/agent-reach-ai-agent-internet-access/)

---

## Công Cụ Đề Xuất

Cho developer xây dựng hoặc triển khai công cụ AI mã nguồn mở:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 tín dụng miễn phí cho người dùng mới, 14+ region toàn cầu, droplet GPU/CPU một-cú-click cho AI workload.
- **{{< aff "hostinger" "footer-cta-legacy" "Hostinger" >}}** — Lựa chọn VPS giá tốt cho thị trường Việt Nam.

*Affiliate link — không tăng chi phí của bạn nhưng giúp dibi8.com duy trì hoạt động.*

## Công Cụ Đề Xuất

**Cần access Claude hoặc OpenAI API ổn định?** Hầu hết project trong space này cuối cùng đều hit rate limit hoặc giá wall của Anthropic / OpenAI.

- **{{< aff "shiyunapi" "llm-footer" "Shiyunapi" >}}** — Proxy Claude / OpenAI / DeepSeek API. Một key cho phép access nhiều top model, ~30% giá chính thức; đặc biệt hữu ích khi iterate agent prompt hoặc bị restrict direct API access trong region.

*Affiliate link — không tốn thêm chi phí và giúp dibi8.com vận hành.*

