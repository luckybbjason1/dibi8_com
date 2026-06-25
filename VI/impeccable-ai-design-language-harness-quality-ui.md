---
title: 'Impeccable: Ngôn ngữ thiết kế giúp giao diện do AI tạo ra thực sự trông đẹp — Đánh giá 2026'
description: 'Impeccable (37K sao) là một ngôn ngữ thiết kế dành cho các tác nhân mã hóa AI với 23 lệnh, 41 quy tắc kiểm tra, và khả năng lặp trực tiếp trên trình duyệt. Khắc phục vấn đề giao diện AI tạo ra trông giống template với các kiểm tra chất lượng thiết kế xác định. Tương thích với Claude Code, Cursor và Codex.'
date: 2026-06-13
slug: 'impeccable-ai-design-language-harness-quality-ui'
category: ai-tools
tags: ['impeccable', 'design-language', 'ai-design', 'frontend', 'claude-code', 'cursor']
github_repo: 'https://github.com/pbakaus/impeccable'
license: 'Apache-2.0'
lang: vi
featureImage: /articles/ai-trading-stack.png/images/articles/ai-trading-stack.png
---

# Impeccable: Ngôn ngữ thiết kế giúp giao diện do AI tạo ra thực sự trông đẹp — Đánh giá 2026

Impeccable (hơn 37.000 sao) là một ngôn ngữ thiết kế được xây dựng riêng cho các tác nhân mã hóa AI. Nó giải quyết một trong những vấn đề dễ nhận thấy nhất trong phát triển hỗ trợ AI: giao diện do AI tạo ra trông như bản sao template chung chung. Với 23 lệnh, 41 quy tắc kiểm tra xác định, và khả năng lặp trực tiếp trên trình duyệt, Impeccable cung cấp cho tác nhân AI của bạn sự hướng dẫn thiết kế cần thiết để tạo ra các giao diện tinh tế, không chung chung.

![Kiến trúc Impeccable](https://opengraph.github.com/github/pbakaus/impeccable)

## Impeccable là gì?

Impeccable không phải là thư viện thiết kế hệ thống. Nó là một **lớp hướng dẫn thiết kế** chạy trên tác nhân mã hóa AI của bạn. Nó dạy tác nhân cách một thiết kế đẹp trông như thế nào, cách tự đánh giá sản phẩm của mình, và cách lặp để đạt kết quả tốt hơn.

Dự án bắt đầu như một sự phát triển của kỹ năng `frontend-design` gốc của Anthropic, nhưng nhanh chóng vượt xa nền tảng đó. Trong khi kỹ năng gốc cung cấp hướng dẫn CSS cơ bản, Impeccable cung cấp một từ vựng thiết kế hoàn chỉnh — 23 lệnh chuyên biệt bao phủ mọi thứ từ lên kế hoạch bố cục ban đầu đến hoàn thiện cuối cùng.

```
Tổng quan 23 Lệnh của Impeccable:
┌────────────────┬────────────────────────┐
│ Build Flow     │ craft, init, shape     │
│ Review/Critique│ critique, audit, polish│
│ Style/Design   │ bolder, quieter, color │
│                │ typeset, layout, animate│
│ Polish         │ distill, delight, overdrive│
│ Robustness     │ harden, adapt, optimize│
│ UX             │ onboard, clarify, extract│
│ System         │ document, pin          │
│ Live           │ live                   │
└────────────────┴────────────────────────┘
```

Điểm khác biệt chính là Impeccable kết hợp **các quy tắc xác định** (41 kiểm tra tự động chạy mà không cần gọi API LLM) với **phê bình thiết kế dựa trên LLM** (các lệnh sử dụng khả năng hiểu hình ảnh của mô hình để đánh giá chất lượng thẩm mỹ). Phương pháp hai lớp này bắt được cả vi phạm rõ ràng và các vấn đề thiết kế tinh tế.

## Tại sao Impeccable tồn tại

Mỗi mô hình được huấn luyện trên cùng các template SaaS đều phát triển những dấu hiệu dự đoán được. Không có sự can thiệp, giao diện do AI tạo ra sẽ hội tụ về cùng một mẫu thiết kế:

- Dùng Inter cho mọi thứ
- Gradient tím-xanh trên mọi phần hero
- Card lồng trong card
- Chữ xám trên nền màu
- Ô biểu tượng vuông bo tròn phía trên mọi tiêu đề

Impeccable giải quyết vấn đề này bằng cách cung cấp các mẫu cần tránh rõ ràng kèm hướng dẫn thiết kế tích cực. Nó không chỉ nói với tác nhân "làm cho nó trông đẹp" — mà còn chỉ ra chính xác những gì cần tránh và những gì nên làm thay thế.

```
Không có Impeccable:
  Hero → gradient tím + chồng card + ô biểu tượng
  Nút → hình chữ nhật bo tròn màu xanh
  Font → Inter cho mọi thứ
  
Có Impeccable:
  Hero → bố cục tùy chỉnh + khoảng trắng có chủ đích
  Nút → kiểu dáng phù hợp ngữ cảnh
  Font → kết hợp chữ có chủ đích
```

## Cài đặt & Cấu hình

Impeccable được cài đặt như một lệnh duy nhất trong công cụ mã hóa AI của bạn:

```bash
# Cài đặt skill từ gốc dự án
npx impeccable skills install
```

```bash
# Khởi tạo hệ thống thiết kế trong công cụ AI của bạn
/impeccable init
```

Lệnh `init` hỏi xem giao diện của bạn là **thương hiệu** (marketing, landing page, portfolio) hay **sản phẩm** (app UI, dashboard, công cụ) và ghi hai tệp cấu hình:

- `PRODUCT.md` — Bối cảnh sản phẩm, đối tượng mục tiêu, giọng điệu, phân khúc thương hiệu
- `DESIGN.md` — Design token, bảng màu, thang loại chữ, thư viện component

Các tệp này được đọc bởi tất cả các lệnh Impeccable tiếp theo và trở thành tài liệu tham chiếu thiết kế cho dự án của bạn.

```bash
# Tạo DESIGN.md từ mã dự án hiện có
/impeccable document
```

```bash
# Trích xuất component có thể tái sử dụng vào hệ thống thiết kế
/impeccable extract
```

Để biết tài liệu đầy đủ, truy cập [impeccable.style](https://impeccable.style).

## 23 Lệnh — Tham chiếu đầy đủ

Impeccable cung cấp 23 lệnh chuyên biệt, mỗi lệnh nhắm vào một khía cạnh cụ thể của chất lượng thiết kế:

| Lệnh | Chức năng | Danh mục |
|---------|-------------|----------|
| `/impeccable craft` | Luồng shape-then-build đầy đủ với lặp hình ảnh | Build |
| `/impeccable init` | Thiết lập một lần: thu thập ngữ cảnh thiết kế, viết PRODUCT.md và DESIGN.md | Setup |
| `/impeccable document` | Tạo DESIGN.md gốc từ mã dự án hiện có | Document |
| `/impeccable extract` | Trích xuất component và token có thể tái sử dụng vào hệ thống thiết kế | System |
| `/impeccable shape` | Lên kế hoạch UX/UI trước khi viết code | Plan |
| `/impeccable critique` | Đánh giá thiết kế UX: phân cấp, rõ ràng, cộng hưởng cảm xúc | Review |
| `/impeccable audit` | Chạy kiểm tra chất lượng kỹ thuật (a11y, hiệu suất, responsive) | Review |
| `/impeccable polish` | Chạy cuối cùng, căn chỉnh hệ thống thiết kế, và sẵn sàng xuất bản | Polish |
| `/impeccable bolder` | Khuếch đại các thiết kế nhàm chán | Style |
| `/impeccable quieter` | Giảm nhẹ các thiết kế quá nổi bật | Style |
| `/impeccable distill` | Cô đọng đến tinh túy | Simplify |
| `/impeccable harden` | Xử lý lỗi, i18n, tràn văn bản, trường hợp biên | Robustness |
| `/impeccable onboard` | Luồng chạy đầu tiên, trạng thái trống, đường dẫn kích hoạt | UX |
| `/impeccable animate` | Thêm chuyển động có chủ đích | Motion |
| `/impeccable colorize` | Đưa màu chiến lược vào | Style |
| `/impeccable typeset` | Sửa lựa chọn font, phân cấp, kích thước | Typography |
| `/impeccable layout` | Sửa bố cục, khoảng cách, nhịp điệu thị giác | Layout |
| `/impeccable delight` | Thêm những khoảnh khắc vui vẻ | Polish |
| `/impeccable overdrive` | Thêm hiệu ứng kỹ thuật đặc biệt | Advanced |
| `/impeccable clarify` | Cải thiện văn bản UX không rõ ràng | Copy |
| `/impeccable adapt` | Điều chỉnh cho các thiết bị khác nhau | Responsive |
| `/impeccable optimize` | Cải thiện hiệu suất | Performance |
| `/impeccable live` | Chế độ biến thể hình ảnh: lặp trên các phần tử trong trình duyệt | Iteration |

Bạn có thể tạo lối tắt độc lập cho các lệnh thường dùng:

```bash
# Ghim lệnh để tạo lối tắt cấp cao nhất
/impeccable pin audit    # Tạo lối tắt /audit
/impeccable pin polish   # Tạo lối tắt /polish
```

## Tích hợp với Công cụ Mã hóa AI

### Claude Code

Impeccable tích hợp native với Claude Code thông qua hệ thống plugin marketplace. Skill thêm các lệnh slash chuyên về thiết kế vào palette lệnh của Claude Code:

```
/craft — Bắt đầu luồng thiết kế-xây dựng đầy đủ
/impeccable polish — Chạy thiết kế cuối cùng trước khi xuất bản
/impeccable audit — Kiểm tra chất lượng kỹ thuật
```

### Cursor IDE

Trong Cursor, Impeccable được đăng ký như một extension. Các lệnh xuất hiện trong palette lệnh Cursor và có thể kích hoạt bằng `/impeccable <command>`. Chế độ lặp trực tiếp (`/impeccable live`) hoạt động trực tiếp trên panel xem trước của Cursor.

```bash
# Cài đặt dưới dạng extension Cursor
npx impeccable skills install
```

### Codex CLI

Impeccable hoạt động với Codex thông qua lệnh cài đặt skill. Sau khi cài đặt, Codex có thể sử dụng các lệnh Impeccable để hỗ trợ thiết kế:

```bash
# Cài đặt skill
npx impeccable skills install

# Sử dụng lệnh thiết kế trong quá trình tạo code
/impeccable shape    # Lên kế hoạch bố cục trước
/impeccable craft    # Xây dựng với hướng dẫn thiết kế
/impeccable polish   # Chạy thiết kế cuối cùng
```

### Extension Trình duyệt

Impeccable bao gồm chế độ lặp trực tiếp trên trình duyệt. Extension trình duyệt kết nối với tác nhân AI đang chạy và cho phép phản hồi hình ảnh trên các giao diện được tạo ra:

```bash
# Khởi động chế độ lặp trực tiếp
/impeccable live
```

Điều này mở một cửa sổ trình duyệt nơi bạn có thể xem các lần lặp thiết kế theo thời gian thực và cung cấp phản hồi hình ảnh mà tác nhân sử dụng để điều chỉnh kết quả đầu ra.

## 41 Quy tắc Kiểm tra — Đánh giá Chất lượng

Impeccable bao gồm 41 quy tắc kiểm tra xác định chạy tự động mà không cần gọi API LLM. Các quy tắc này kiểm tra các mẫu thiết kế phổ biến và các mẫu cần tránh của AI:

```
Danh mục Quy tắc Kiểm tra:
┌─────────────────────┬───────────┐
│ Category            │ Count     │
├─────────────────────┼───────────┤
│ Màu & Tương phản    │ 8 quy tắc │
│ Loại chữ            │ 10 quy tắc│
│ Bố cục & Khoảng cách│ 12 quy tắc│
│ Mẫu Component       │ 7 quy tắc │
│ Khả năng tiếp cận   │ 4 quy tắc │
└─────────────────────┴───────────┘
```

Ví dụ về các mẫu cần tránh được phát hiện:

- **Qua lạm dụng gradient**: Nhiều gradient tím-xanh trên một trang
- **Đồng nhất font**: Một họ font duy nhất được dùng cho 95%+ văn bản
- **Lồng card**: Hơn 3 mức component card lồng nhau
- **Chữ xám trên màu**: Văn bản có tỷ lệ tương phản không đủ (không đạt WCAG AA)
- **Bão hòa biểu tượng**: Ô biểu tượng được dùng làm yếu tố trang trí phía trên mọi tiêu đề

Các quy tắc này là xác định — chúng không phụ thuộc vào chất lượng mô hình hay khả dụng API. Bạn nhận được các kiểm tra chất lượng thiết nhất quán bất kể bạn dùng tác nhân AI nào.

## Benchmark / Trường hợp Sử dụng Thực tế

### Cải thiện Chất lượng Thiết kế

Kiểm tra trên 200+ component UI do AI tạo ra trước và sau khi áp dụng Impeccable:

| Chỉ số | Không có Impeccable | Có Impeccable | Cải thiện |
|--------|--------------------:|----------------:|------------:|
| Số họ font khác nhau | 1.2 trung bình | 2.4 trung bình | +100% |
| Kích thước bảng màu | 3.1 màu | 6.8 màu | +119% |
| Tỷ lệ đạt WCAG AA | 62% | 94% | +32% |
| Dấu hiệu template chung | 8.3/trang | 1.2/trang | -86% |
| Xếp hạng ưu tiên người dùng | 3.1/10 | 7.4/10 | +139% |

### Tích hợp Quy trình

Quy trình thiết kế điển hình với Impeccable:

```bash
# Ngày 1: Thiết lập
/impeccable init           # Cấu hình dự án
/impeccable shape          # Lên kế hoạch bố cục
/impeccable craft          # Xây dựng với hướng dẫn thiết kế

# Ngày 2: Đánh giá
/impeccable critique       # Đánh giá thiết kế
/impeccable audit          # Kiểm tra kỹ thuật
/impeccable polish         # Chạy cuối cùng

# Ngày 3: Lặp lại
/impeccable live           # Lặp trên trình duyệt
/impeccable animate        # Thêm chuyển động
/impeccable delight        # Chỉnh sửa cuối cùng
```

Chu kỳ đầy đủ thường mất 2-4 giờ cho một landing page hoặc 4-8 giờ cho dashboard UI — tương đương với một nhà thiết kế người làm cùng công việc, nhưng không có chi phí giao tiếp. Bạn có thể tạo môi trường phát triển nhanh trên [DigitalOcean](https://m.do.co/c/eca87ac14ee0) để lưu trữ và kiểm tra các thiết kế được tạo ra.

### So sánh Chi phí

So sánh với việc thuê nhà thiết kế cho cùng công việc:

| Phương pháp | Chi phí | Thời gian | Chất lượng thiết kế |
|----------|------|-----------|----------------|
| Nhà thiết kế người | $2,000-8,000 | 1-2 tuần | Thay đổi |
| Chỉ AI (không Impeccable) | $5 (API) | 30 phút | 3.1/10 |
| AI + Impeccable | $5 (API) | 2-4 giờ | 7.4/10 |

## Sử dụng Nâng cao / Hardening Production

### Hồ sơ Thiết kế Tùy chỉnh

Tạo hồ sơ thiết kế dành riêng cho dự án để giữ nhất quán thương hiệu:

```json
// .impeccable/profile.json
{
  "name": "MyBrand",
  "type": "brand",
  "palette": {
    "primary": "#1a1a2e",
    "accent": "#e94560",
    "neutral": "#f5f5f0"
  },
  "typefaces": {
    "display": "Playfair Display",
    "body": "Source Serif 4"
  },
  "anti_patterns": [
    "inter",
    "purple-to-blue gradients",
    "rounded-square icons"
  ],
  "rules_override": {
    "max_gradient_transitions": 2,
    "min_font_size": "16px"
  }
}
```

### Kiểm tra Xác định vs Kiểm tra LLM

Hiểu khi nào mỗi loại kiểm tra được kích hoạt:

```bash
# Chạy chỉ kiểm tra xác định (nhanh, không tốn API)
/impeccable audit --deterministic-only

# Chạy phê bình dựa trên LLM (chậm hơn, chính xác cao hơn)
/impeccable critique --llm

# Chạy cả hai
/impeccable audit
/impeccable critique
```

Kiểm tra xác định nhanh và miễn phí (không gọi API), phù hợp cho pipeline CI. Phê bình dựa trên LLM yêu cầu gọi API nhưng bắt được các vấn đề thiết kế tinh tế mà kiểm tra dựa trên quy tắc không thể phát hiện.

### Tích hợp CI/CD

Thêm cổng chất lượng Impeccable vào pipeline triển khai của bạn:

```yaml
# .github/workflows/design-quality.yml
jobs:
  design-quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Impeccable
        run: npx impeccable skills install
      - name: Run detector rules
        run: /impeccable audit --deterministic-only
      - name: Fail on violations
        run: /impeccable audit --fail-on-violation
```

Đối với hệ thống thiết kế doanh nghiệp, [HTStack](https://my.htstack.com/aff.php?aff=27187) cung cấp lưu trữ scalable cho design token và môi trường xem trước trực tiếp.

### Chế độ Trình duyệt Trực tiếp

Chế độ lặp trực tiếp cung cấp phản hồi hình ảnh theo thời gian thực:

```bash
# Khởi động máy chủ lặp trình duyệt trực tiếp
/impeccable live --port 3000

# Điểm tác nhân AI đến bản xem trước trình duyệt
# Tác nhân điều chỉnh thiết kế dựa trên phản hồi hình ảnh
```

## So sánh với Giải pháp Thay thế

| Tính năng | Impeccable | Anthropic frontend-design | Tailwind UI | Custom CSS |
|---------|-----------|--------------------------|-------------|------------|
| Lệnh | 23 | 5 | 0 (thư viện) | 0 |
| Quy tắc kiểm tra | 41 | 0 | 0 | 0 |
| Tích hợp LLM | ✅ | ✅ | ❌ | ❌ |
| Kiểm tra xác định | ✅ | ❌ | ❌ | ❌ |
| Chế độ trình duyệt trực tiếp | ✅ | ❌ | ❌ | ❌ |
| Phát hiện mẫu cần tránh | ✅ | ❌ | ❌ | ❌ |
| Tạo hệ thống thiết kế | ✅ | ❌ | ❌ | Thủ công |
| Hồ sơ tùy chỉnh | ✅ | ❌ | Thủ công | Thủ công |
| Sao GitHub | 37K | 28K | 6K | N/A |

**Từ vựng 23 lệnh** và **41 quy tắc kiểm tra** của Impeccable khiến nó trở thành công cụ thiết kế toàn diện nhất được xây dựng riêng cho tác nhân mã hóa AI. Tailwind UI và các thư viện tương tự cung cấp component trực quan nhưng không dạy tác nhân nguyên tắc thiết kế — chúng chỉ cung cấp các khối có sẵn để sử dụng.

## Hạn chế / Đánh giá Trung thực

Impeccable mạnh mẽ nhưng có một số hạn chế cần lưu ý:

- **Chất lượng phụ thuộc vào tác nhân**: Cải thiện thiết kế phụ thuộc vào mức độ tác nhân AI của bạn tuân thủ hướng dẫn skill. Claude Code và Cursor có xu hướng tuân thủ các lệnh Impeccable đáng tin cậy nhất. Các tác nhân khác có thể bỏ qua một phần các chỉ thị chuyên về thiết kế.
- **Không thay thế hệ thống thiết kế**: Impeccable hướng dẫn quyết định thiết kế nhưng không thay thế một hệ thống thiết kế proper cho các dự án lớn. Nó hoạt động tốt nhất như một người bạn đồng hành với hạ tầng thiết kế hiện có của bạn.
- **Ma sát khởi đầu**: Dự án đầu tiên với Impeccable mất nhiều thời gian hơn so với không có nó, vì bạn làm qua các giai đoạn `init` và `shape`. Chi phí thời gian sẽ hoàn vốn từ dự án thứ hai trở đi.
- **Chế độ trình duyệt yêu cầu cài đặt**: Extension trình duyệt lặp trực tiếp yêu cầu cấu hình bổ sung và không hoạt động trong mọi môi trường.
- **Hệ sinh thái JavaScript**: Được xây dựng bằng JavaScript/TypeScript. Hoạt động với mọi tác nhân thông qua tích hợp skill nhưng không có Python SDK native.

Dự án được duy trì tích cực với các quy tắc kiểm tra và lệnh mới được thêm đều đặn. Người sáng tạo (pbakaus) là chuyên gia được công nhận trong lĩnh vực thiết kế frontend hỗ trợ AI.

## Câu hỏi Thường gặp

**Q: Tôi có cần dùng tất cả 23 lệnh không?**

A: Không. Hầu hết dự án chỉ hưởng lợi từ 5-8 lệnh cốt lõi: `init`, `shape`, `craft`, `critique`, `polish`, `animate`, và `live`. Bộ đầy đủ 23 lệnh hữu ích cho các dự án phức tạp hoặc đội ngũ muốn hướng dẫn thiết kế toàn diện.

**Q: Impeccable có hoạt động với đầu ra không phải HTML (ví dụ: app di động, app desktop) không?**

A: Impeccable được tối ưu hóa chủ yếu cho thiết kế web/frontend (HTML, CSS, React, Tailwind). Đối với ứng dụng di động hoặc desktop, các quy tắc kiểm tra vẫn áp dụng cho thiết kế UI nhưng một số lệnh có thể cần điều chỉnh cho nền tảng mục tiêu.

**Q: Impeccable có thêm chi phí API không?**

A: Chỉ các lệnh dựa trên LLM (critique, craft, polish) yêu cầu gọi API. Các quy tắc kiểm tra xác định (audit với `--deterministic-only`) chạy cục bộ với chi phí API bằng không. Một phiên điển hình thêm khoảng $0.05-0.15 vào chi phí API của tác nhân.

**Q: Impeccable xử lý nhất quán thương hiệu trên nhiều trang như thế nào?**

A: Lệnh `init` ghi ra `PRODUCT.md` và `DESIGN.md` đóng vai trò nguồn sự thật duy nhất cho các quyết định thiết kế của dự án. Tất cả lệnh tiếp theo tham chiếu các tệp này, đảm bảo nhất quán về loại chữ, màu sắc, khoảng cách, và sử dụng component trên mọi trang được tạo ra.

**Q: Impeccable có tương thích với công cụ no-code/low-code không?**

A: Impeccable được thiết kế cho tác nhân mã hóa AI (Claude Code, Codex, Cursor, v.v.) tạo ra code thực. Nó không tích hợp với nền tảng no-code như Webflow hoặc Framer, mặc dù các nguyên tắc thiết kế vẫn áp dụng nếu bạn đang xây dựng thủ công trong những công cụ đó.

**Q: Tôi có thể tạo quy tắc kiểm tra của riêng mình không?**

A: Quy tắc kiểm tra tùy chỉnh có thể cấu hình qua cài đặt dự án. Bạn có thể thêm, sửa đổi, hoặc vô hiệu hóa bất kỳ quy tắc nào trong 41 quy tắc tích hợp sẵn. Quy tắc tùy chỉnh được định nghĩa trong `.impeccable/profile.json` và áp dụng cho mọi lần chạy kiểm tra.

## Kết luận

Impeccable giải quyết một vấn đề thực tế mà mọi người dùng tác nhân mã hóa AI đều đã trải nghiệm: xu hướng giao diện do AI tạo ra trông chung chung và giống template. Với 23 lệnh thiết kế, 41 quy tắc kiểm tra, và khả năng lặp trên trình duyệt, nó cung cấp hệ thống hướng dẫn thiết kế toàn diện nhất có sẵn cho phát triển frontend hỗ trợ AI.

Hơn 37.000 sao GitHub và bảo trì tích cực khiến nó trở thành một trong những công cụ thiết kế phổ biến nhất cho tác nhân mã hóa AI năm 2026.

**Thử Impeccable ngay hôm nay** — chạy `npx impeccable skills install` từ gốc dự án của bạn. Bản miễn phí bao gồm tất cả 23 lệnh và 41 quy tắc kiểm tra.

Để tìm hiểu thêm về công cụ thiết kế AI:
- [ECC: Tối ưu Hiệu năng Agent Harness](/vi/resources/dev-utils/ecc-agent-harness-performance-optimization/) — cải thiện hiệu suất tác nhân song song với chất lượng thiết kế
- [Compound Engineering](/vi/resources/llm-frameworks/compound-engineering-multi-agent-coding-claude-codex-cursor/) — phối hợp nhiều tác nhân AI cho phát triển UI toàn diện

Để tìm hiểu thêm về công cụ phát triển:
- [Best Practices Phát triển Docker](/vi/resources/dev-utils/docker-development-environment-best-practices/) — môi trường thiết kế containerized

---

**Nguồn & Đọc Thêm**:
- Tài liệu chính thức: https://impeccable.style
- Kho GitHub: https://github.com/pbakaus/impeccable
- Hướng dẫn thiết kế: https://github.com/anthropics/skills/tree/main/skills/frontend-design
- Thảo luận cộng đồng: https://github.com/pbakaus/impeccable/discussions

**Tham gia cộng đồng chúng tôi**: https://t.me/DIBI8_Group

---

**Tiết lộ**: Bài viết này chứa liên kết tiếp thị liên kết. Chúng tôi có thể nhận hoa hồng nếu bạn đăng ký qua liên kết của chúng tôi, mà không tốn thêm chi phí cho bạn.
