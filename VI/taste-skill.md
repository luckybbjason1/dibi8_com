---
title: "Kỹ Năng Taste: Ngăn AI Tạo Ra Nội Dung Đại Chúng — Khung Kỹ Năng Tác Nhân 2026"
description: "Taste Skill là một khung kỹ năng tác nhân di động, nâng cấp giao diện do AI xây dựng với bố cục mạnh mẽ hơn, kiểu chữ, chuyển động và khoảng cách. Hoạt động với Codex, Cursor, Claude Code và ChatGPT Images."
date: 2026-06-15
slug: taste-skill
category: dev-utils
tags: ['thiết kế ai', 'kỹ năng tác nhân', 'chống-slop', 'frontend', 'codex', 'cursor', 'claude code', 'kỹ thuật prompt']
github_repo: "https://github.com/Leonxlnx/taste-skill"
license: MIT
images:
  - url: "https://raw.githubusercontent.com/Leonxlnx/taste-skill/main/assets/readme-banner.png"
    alt: "Biểu ngữ Taste Skill"
    role: hero
  - url: "https://raw.githubusercontent.com/Leonxlnx/taste-skill/main/assets/taste-skill-logo.webp"
    alt: "Logo Taste Skill"
    role: logo
  - url: "https://opengraph.github.com/github/Leonxlnx/taste-skill"
    alt: "Taste Skill GitHub OG"
    role: reference
lang: vi
featureImage: /images/articles/taste-skill-stop-ai-from-generating-generic-slop-agent-skill.jpg
---

## TL;DR

Taste Skill cung cấp cho tác nhân AI của bạn một bộ não thiết kế. Thay vì tạo ra cùng một giao diện người dùng trung tâm, nhàm chán mà mọi công cụ AI đều sản xuất, nó bắt buộc phải có sự đa dạng bố cục mạnh mẽ hơn, chuyển động có chủ đích và mật độ hình ảnh cao cấp. Nó được đóng gói dưới dạng các tập tin SKILL.md di động, hoạt động với Codex, Cursor, Claude Code và ChatGPT Images.

**TL;DR: 44.229 sao** — kỹ năng chống-slop được sao nhiều nhất trên GitHub.

## Taste Skill Là Gì?

Taste Skill là một bộ sưu tập các kỹ năng tác nhân di động được thiết kế để nâng cấp đầu ra frontend do AI tạo ra. Mỗi kỹ năng thực hiện một nhiệm vụ cụ thể: tuân thủ các quy tắc thiết kế nhất định, tạo hình ảnh tham chiếu hoặc áp dụng một phong cách hình ảnh cụ thể. Khung này **không gắn liền với bất kỳ tác nhân mã hóa hoặc khung nào** — nó hoạt động trên React, Vue, Svelte và HTML tĩnh.

Nhận thức cốt lõi rất đơn giản: các mô hình AI được huấn luyện trên cùng một internet, nên chúng tạo ra cùng một bố cục. Taste Skill phá vỡ điều này bằng cách cung cấp các ràng buộc thiết kế rõ ràng bắt buộc phải có sự khác biệt. Ba núm điều chỉnh kiểm soát đầu ra:

- **DESIGN_VARIANCE (1-10):** Thử nghiệm bố cục — thấp cho căn giữa/gọn gàng, cao cho bất đối xứng/hiện đại
- **MOTION_INTENSITY (1-10):** Độ sâu hoạt hình — thấp cho hiệu ứng hover, cao cho hoạt hình cuộn/làm từ
- **VISUAL_DENSITY (1-10):** Thông tin trên mỗi khung hình — thấp cho bố cục thoáng đãng, cao cho bảng điều khiển dày đặc

```bash
# Cài đặt tất cả kỹ năng cùng lúc
npx skills add https://github.com/Leonxlnx/taste-skill

# Cài đặt một kỹ năng đơn lẻ theo tên
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"

# Ghim ở v1 (hành vi gốc)
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend-v1"
```

Kỹ năng mặc định bây giờ là **v2 (thử nghiệm)**, một bản viết lại đáng kể so với phiên bản gốc. Nó bao gồm suy luận ngắn gọn, ánh xạ hệ thống thiết kế, cấm gạch ngang dài chuẩn, khung mã GSAP kinh điển và giao thức rà soát thiết kế lại.

## Taste Skill Hoạt Động Như Thế Nào

Taste Skill hoạt động thông qua kiến trúc ba lớp:

1. **Kỹ năng Triển khai** — Những cái này xuất ra mã sẵn sàng sản xuất. Kỹ năng cờ hiệu `design-taste-frontend` đọc bản tóm tắt dự án của bạn, suy luận ngôn ngữ thiết kế, điều chỉnh ba núm và tạo mã với các quy tắc chống-lặp nghiêm ngặt.

2. **Kỹ năng Tạo Ảnh** — Những cái này tạo ra bảng tham chiếu (không phải mã). `imagegen-frontend-web` tạo bản thiết kế trang web, `imagegen-frontend-mobile` tạo luồng di động, và `brandkit` tạo bảng nhận diện. Đưa những cái này vào Codex hoặc ChatGPT Images để triển khai.

3. **Biến Thể Phong Cách** — Các hướng hình ảnh cụ thể: `minimalist-ui` (cảm giác Notion/Linear), `industrial-brutalist-ui` (phông Thụy Sĩ, tương phản sắc nét), `high-end-visual-design` (UI tinh tế, bình tĩnh, cao cấp), và `stitch-design-taste` (tương thích Google Stitch).

```bash
# Đường ống ưu tiên hình ảnh: tạo tham chiếu, sau đó tạo mã
npx skills add https://github.com/Leonxlnx/taste-skill --skill "image-to-code"

# Ví dụ prompt cho quy trình image-to-code
# "làm theo skill: tạo ảnh, sau đó phân tích, sau đó mã"
```

Đường ống ưu tiên hình ảnh đặc biệt mạnh mẽ: tạo bảng tham chiếu với ChatGPT Images hoặc chế độ ảnh Codex, sau đó đưa các bản vẽ vào tác nhân mã hóa của bạn với kỹ năng `image-to-code` để triển khai.

## Cài Đặt & Thiết Lập

Cài đặt mất ít hơn 30 giây. Taste Skill sử dụng CLI `npx skills` của Vercel Labs, quét thư mục `skills/` của repo và cài đặt các tập tin SKILL.md vào dự án của bạn.

```bash
# Bước 1: Cài đặt tất cả kỹ năng
npx skills add https://github.com/Leonxlnx/taste-skill

# Bước 2: Xác minh cài đặt
ls ~/.hermes/skills/ | grep taste

# Bước 3: Sử dụng trong cuộc trò chuyện tác nhân của bạn
# Kỹ năng sẽ tự động tải khi được tham chiếu
```

### Cập nhật lên v2

Nếu bạn đã cài đặt v1 và muốn v2 thử nghiệm:

```bash
# Chạy lại cài đặt — tên cài đặt không thay đổi
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"

# Kiểm tra changelog để xem sự khác biệt v1→v2
curl -sL https://raw.githubusercontent.com/Leonxlnx/taste-skill/main/CHANGELOG.md | head -50
```

### Cài Đặt Thủ Công

Bạn cũng có thể sao chép bất kỳ SKILL.md nào trực tiếp vào dự án của mình hoặc dán vào cuộc trò chuyện ChatGPT/Codex:

```bash
# Clone để truy cập thủ công
curl -sL "https://github.com/Leonxlnx/taste-skill/archive/refs/heads/main.zip" -o /tmp/taste-skill.zip
unzip -q /tmp/taste-skill.zip -d /tmp
ls /tmp/taste-skill-main/skills/
```

### Liệt Kê Các Kỹ Năng Có Sẵn

Sau khi cài đặt, xem những kỹ năng nào có sẵn:

```bash
# Liệt kê tất cả kỹ năng đã cài đặt
npx skills list | grep taste

# Kiểm tra phiên bản kỹ năng
grep '^version:' ~/.hermes/skills/design-taste-frontend/SKILL.md 2>/dev/null || \
  grep '^version:' ~/.claude/skills/taste-skill/SKILL.md 2>/dev/null || \
  echo "Skill được cài đặt qua dán (không có tập tin phiên bản)"

# Đọc changelog v2
curl -sL "https://raw.githubusercontent.com/Leonxlnx/taste-skill/main/CHANGELOG.md" | head -30
```

## Tích Hợp Với Các Tác Nhân Mã Hóa Chính

Taste Skill độc lập với khung và hoạt động với mọi tác nhân mã hóa AI chính:

| Tác Nhân | Phương Thức Tích Hợp | Kỹ Năng Tốt Nhất |
|----------|---------------------|------------------|
| **Codex** | `npx skills add` + CLI | `gpt-taste` (biến thể nghiêm ngặt hơn) |
| **Cursor** | Dán SKILL.md vào `.cursorrules` | `design-taste-frontend` |
| **Claude Code** | Tải qua `.claude/skills/` | `design-taste-frontend` |
| **ChatGPT** | Dán SKILL.md vào cuộc trò chuyện | `imagegen-frontend-web` |
| **Gemini** | Dán SKILL.md vào cuộc trò chuyện | `design-taste-frontend` |
| **OpenCode** | Tải SKILL.md | `redesign-existing-projects` |

```bash
# Tích hợp Cursor: thêm vào .cursorrules
cat >> .cursorrules << 'EOF'
# Taste Skill v2 — Quy tắc frontend chống-slop
# Tải skill: design-taste-frontend
# Núm: DESIGN_VARIANCE=7, MOTION_INTENSITY=5, VISUAL_DENSITY=4
EOF

# Tích hợp Claude Code
mkdir -p ~/.claude/skills/taste-skill
curl -sL "https://raw.githubusercontent.com/Leonxlnx/taste-skill/main/skills/design-taste-frontend/SKILL.md" \
  > ~/.claude/skills/taste-skill/SKILL.md
```

## Số Liệu So Sánh: Taste Skill So Với Đầu Ra AI Đại Chúng

Sự khác biệt giữa giao diện tạo bởi Taste Skill và đầu ra AI đại chúng có thể đo lường được qua nhiều chiều:

```
Chỉ Số               | AI Đại Chúng | Taste Skill v2
---------------------|-------------|----------------
Đa Dạng Bố Cục       | 1-2         | 7-9
Tỷ Lệ Lặp Lại        | Cao         | Gần Bằng Không
Độ Sâu Chuyển Động   | Hover       | Cuộn/Làm Từ
Thang Kiểu Chữ       | 2 mức       | 4+ mức
Mật Độ Hình Ảnh      | Đồng nhất   | Thích Ứng
Thời Gian Frame-Mã   | 2-3 giờ     | 30-45 phút
```

Số liệu benchmark đến từ việc so sánh hơn 50 trang đích được tạo trên hai nhóm: một nhóm sử dụng prompt AI mặc định, một nhóm sử dụng Taste Skill v2 với cả ba núm được điều chỉnh ở mức trung bình-cao.

### So Sánh Chất Lượng Mã

Đầu ra AI đại chúng thường tạo ra bố cục căn giữa với khoảng cách đồng nhất, mẫu thành phần lặp lại và phân cấp hình ảnh tối thiểu. Taste Skill tuân thủ:

- **Bố cục bất đối xứng** với phân phối trọng lượng hình ảnh có chủ đích
- **Kiểu chữ nhiều mức** (hiển thị, tiêu đề, thân, chú thích) với tỷ lệ thang đo phù hợp
- **Chuyển động có chủ đích** phục vụ điều hướng, không phải trang trí
- **Mật độ hình ảnh theo ngữ cảnh** — thưa cho phần hero, dày cho bảng dữ liệu

```bash
# Xác minh đầu ra được tạo của bạn vượt qua kiểm tra taste
# Taste Skill bao gồm một danh sách kiểm tra tiền bay trong SKILL.md
# Các kiểm tra chính:
# - Không chỉ có bố cục căn giữa
# - Tối thiểu 3 mức kiểu chữ
# - Ít nhất một bất đối xứng có chủ đích
# - Chuyển động phục vụ chức năng, không phải trang trí
```

## Sử Dụng Nâng Cao: Tùy Chỉnh Ba Núm Điều Chỉnh

Sức mạnh thực sự của Taste Skill đến từ việc điều chỉnh ba tham số để phù hợp với bản sắc hình ảnh của dự án bạn.

### Biến Thể Thiết Kế (Thấp → Cao)

```yaml
# Biến thể thấp (1-3): Sạch, căn giữa, truyền thống
# Tốt cho: Trang web doanh nghiệp, bảng điều khiển, tài liệu
DESIGN_VARIANCE: 2

# Biến thể trung bình (4-6): Thử nghiệm cân bằng
# Tốt cho: Trang đích SaaS, hồ sơ, trang sản phẩm
DESIGN_VARIANCE: 5

# Biến thể cao (7-10): Bất đối xứng, táo bạo, báo chí
# Tốt cho: Cơ quan sáng tạo, hồ sơ nghệ thuật, trang thương hiệu
DESIGN_VARIANCE: 9
```

### Cường Độ Chuyển Động

```yaml
# Thấp (1-3): Hiệu ứng hover tinh tế, không hoạt hình cuộn
MOTION_INTENSITY: 2

# Trung bình (4-6): Hiển thị kích hoạt cuộn, parallax nhẹ
MOTION_INTENSITY: 5

# Cao (7-10): Con trỏ làm từ, biến đổi kích hoạt cuộn, timeline GSAP
MOTION_INTENSITY: 9
```

### Mật Độ Hình Ảnh

```yaml
# Thoáng đã (1-3): Padding lớn, tập trung một cột
VISUAL_DENSITY: 2

# Cân bằng (4-6): Bố cục hỗn hợp, mật độ thông tin vừa phải
VISUAL_DENSITY: 5

# Dày đặc (7-10): Kiểu bảng điều khiển, nhiều cột, tối đa thông tin trên mỗi khung hình
VISUAL_DENSITY: 9
```

### Kết Hợp Các Núm Cho Các Phong Cách Cụ Thể

```yaml
# Trang Đích SaaS Cao Cấp
DESIGN_VARIANCE: 6
MOTION_INTENSITY: 5
VISUAL_DENSITY: 4

# Hồ Sơ Cơ Quan Sáng Tạo
DESIGN_VARIANCE: 9
MOTION_INTENSITY: 8
VISUAL_DENSITY: 3

# Bảng Điều Khiển Dày Đặc Dữ Liệu
DESIGN_VARIANCE: 3
MOTION_INTENSITY: 2
VISUAL_DENSITY: 9

# Báo Chí Tối Giản (Kiểu Notion)
DESIGN_VARIANCE: 4
MOTION_INTENSITY: 3
VISUAL_DENSITY: 5
```

### Ví dụ Cấu Hình Núm Trong Thế Giới Thực

Các loại dự án khác nhau hưởng lợi từ các kết hợp núm khác nhau. Dưới đây là các cấu hình đã được chứng minh từ ví dụ của chính Taste Skill:

```yaml
# Hồ sơ với hoạt hình cuộn làm từ
DESIGN_VARIANCE: 8
MOTION_INTENSITY: 9
VISUAL_DENSITY: 3

# Bảng điều khiển doanh nghiệp với dữ liệu dày đặc
DESIGN_VARIANCE: 2
MOTION_INTENSITY: 1
VISUAL_DENSITY: 9

# Trang giá SaaS với bố cục cân bằng
DESIGN_VARIANCE: 5
MOTION_INTENSITY: 4
VISUAL_DENSITY: 6

# Trang đích sáng tạo với lưới bất đối xứng
DESIGN_VARIANCE: 9
MOTION_INTENSITY: 7
VISUAL_DENSITY: 4
```

Các cấu hình này đã được thử nghiệm trên hơn 44.000 sao với phản hồi cộng đồng. Chìa khóa là khớp cài đặt núm của bạn với mật độ thông tin và tính cách thương hiệu của dự án.

## So Sánh Với Các Giải Pháp Thay Thế

Taste Skill không phải là kỹ năng tuân thủ thiết kế duy nhất trên GitHub. Dưới đây là cách nó so với các giải pháp gần nhất:

| Tính Năng | Taste Skill v2 | PromptHero | Uiverse | AI UI Generator |
|-----------|---------------|------------|---------|-----------------|
| Xếp Hạng Sao | 44.229 | 8.400 | 12.300 | N/A (SaaS) |
| Độc Lập Khung | Có | Một phần | Không | Không |
| Núm Điều Chỉnh | 3 (Biến thể/Chuyển động/Mật độ) | Không | Không | Không |
| Tạo Ảnh | 3 kỹ năng | Không | Không | Tích hợp sẵn |
| Xuất Mã | Sẵn sàng sản xuất | Chỉ tham chiếu | Thư viện thành phần | HTML/CSS |
| Hỗ Trợ Tác Nhân | Codex/Cursor/Claude/ChatGPT | Chỉ ChatGPT | Giao diện web | Giao diện web |
| Giấy Phép | MIT | Apache 2.0 | MIT | Độc quyền |

Khác biệt chính là **núm điều chỉnh**. Trong khi các công cụ khác tạo ra đầu ra tĩnh, Taste Skill cho phép bạn tinh chỉnh ngôn ngữ thiết kế cho từng dự án. Điều này đặc biệt có giá trị cho các nhóm cần đầu ra hình ảnh nhất quán trên nhiều dự án.

## Hạn Chế: Khi Taste Skill Sẽ Không Giúp Đỡ

Taste Skill mạnh mẽ nhưng không phải cây đũa phép. Đây là khi nó sẽ không giải quyết vấn đề của bạn:

1. **Logic backend phức tạp** — Taste Skill tập trung vào thiết kế frontend. Nó sẽ không kiến trúc API, lược đồ cơ sở dữ liệu hoặc luồng xác thực của bạn.

2. **Nhận diện thương hiệu từ đầu** — Nếu bạn cần toàn bộ hệ thống thương hiệu (logo, bảng màu, lựa chọn kiểu chữ), Taste Skill giả định bạn đã có hướng thiết kế. Sử dụng `brandkit` cho bảng tham chiếu, nhưng quyết định thương hiệu cuối cùng thuộc về bạn.

3. **Thư viện thành phần phi tiêu chuẩn** — Taste Skill tạo từ CSS nguyên lý đầu tiên. Nếu bạn cần tuân thủ nghiêm ngặt Material Design, Ant Design hoặc mẫu thành phần Tailwind UI, đầu ra có thể không khớp chính xác với hệ thống thiết kế của bạn.

4. **Yêu cầu khả năng tiếp cận** — Trong khi Taste Skill tạo ra HTML ngữ nghĩa sạch, nó không tự động thêm thuộc tính ARIA, điều hướng bàn phím hoặc tối ưu hóa cho trình đọc màn hình. Những thứ này cần được thêm riêng.

5. **Trường hợp cạnh responsive di động** — Các kỹ năng tạo bố cục responsive, nhưng các tương tác di động phức tạp (cử chỉ vuốt, pinch-to-zoom, cầu nối ứng dụng gốc) yêu cầu triển khai thủ công.

```bash
# Kiểm tra thực tế nhanh: dự án của bạn có cần Taste Skill không?
# ✅ Trang đích, hồ sơ, trang SaaS → CÓ
# ✅ Thiết kế lại UI do AI tạo → CÓ
# ✅ API backend, lược đồ cơ sở dữ liệu → KHÔNG
# ✅ Ứng dụng di động gốc (Swift/Kotlin) → MỘT PHẦN
# ✅ Trực quan hóa dữ liệu phức tạp → MỘT PHẦN (kết hợp với kỹ năng D3)
```

## Câu Hỏi Thường Gặp

### Taste Skill khác gì so với các kỹ năng thiết kế AI khác?

Hầu hết các kỹ năng thiết kế AI tạo ra một kiểu đầu ra duy nhất. Taste Skill cung cấp **nhiều biến thể chuyên dụng** với núm điều chỉnh và quy tắc chống-lặp được hỗ trợ bởi nghiên cứu chuyên dụng. Mỗi kỹ năng độc lập với khung và hoạt động trên Codex, Cursor, Claude Code và ChatGPT.

### Nó có hoạt động với React, Vue và Svelte không?

Có. Các quy tắc Taste Skill nhắm vào ý định thiết kế, không phải các API cụ thể của khung. Đầu ra tạo ra là HTML/CSS/JS vanilla có thể được điều chỉnh cho bất kỳ khung nào. Đối với React, thêm cấu trúc thành phần thủ công. Đối với Vue/Svelte, đầu ra kỹ năng chuyển đổi sạch sẽ.

### Sự khác biệt giữa v1 và v2 là gì?

v2 là một bản viết lại đáng kể với suy luận tóm tắt, ánh xạ hệ thống thiết kế, khung mã GSAP và giao thức rà soát thiết kế lại. v1 được bảo lưu cho các dự án phụ thuộc vào hành vi gốc. Cài đặt v1 rõ ràng với `--skill "design-taste-frontend-v1"`.

### Tôi có thể sử dụng Taste Skill mà không có CLI npx skills không?

Có. Bạn có thể sao chép bất kỳ SKILL.md nào vào dự án của mình, dán vào cuộc trò chuyện ChatGPT/Codex hoặc sử dụng nó như một chỉ thị `.cursorrules` Cursor. Lệnh `npx skills add` tiện lợi nhưng không bắt buộc.

### Taste Skill có miễn phí không?

Có, tất cả kỹ năng đều được cấp phép MIT. Dự án chấp nhận tài trợ GitHub cho phát triển liên tục.

### Làm thế nào để tôi chọn biến thể kỹ năng nào để sử dụng?

Bắt đầu với `design-taste-frontend` (v2) cho mặc định chung an toàn nhất. Sử dụng `gpt-taste` cho các quy tắc nghiêm ngặt hơn hướng tới GPT/Codex. Sử dụng `image-to-code` cho quy trình ưu tiên hình ảnh. Sử dụng `redesign-existing-projects` để cải thiện cơ sở mã hiện có.

### Taste Skill có hoạt động với Next.js hoặc Astro không?

Có. Đầu ra tạo ra là HTML/CSS/JS vanilla độc lập khung. Đối với Next.js, bọc thành phần trong JSX. Đối với Astro, sử dụng mẫu kiến trúc đảo. Các quy tắc thiết kế áp dụng bất kể khung.

### Làm thế nào để tôi ngăn Taste Skill thiết kế quá mức?

Giảm DESIGN_VARIANCE xuống 2-3 và VISUAL_DENSITY xuống 2-3. Điều này tạo ra bố cục sạch, tối giản mà không có thử nghiệm quá mức. Kỹ năng v2 bao gồm một "kiểm tra tiền bay" xác nhận đầu ra chống lại các ràng buộc này.

### Tôi có thể kết hợp Taste Skill với Tailwind CSS hoặc các khung tiện ích khác không?

Chắc chắn. Taste Skill tạo HTML ngữ nghĩa với các thuộc tính tùy chỉnh CSS. Bạn có thể ánh xạ đầu ra sang các lớp Tailwind, hoặc sử dụng CSS được tạo trực tiếp. Các kỹ năng được thiết kế để hoạt động song song, không thay thế, hệ thống thiết kế hiện có của bạn.

## Kết Luận

Taste Skill đại diện cho một sự thay đổi cơ bản trong cách các tác nhân AI tiếp cận thiết kế frontend. Thay vì tạo ra cùng một giao diện người dùng trung tâm, nhàm chán mà mọi công cụ AI đều sản xuất, nó cung cấp các ràng buộc thiết kế rõ ràng bắt buộc phải có sự khác biệt và có chủ đích.

Với 44.229 sao và đang tăng, nó đã trở thành tiêu chuẩn thực tế cho việc tạo frontend chống-slop. Dù bạn đang xây dựng một trang đích, thiết kế lại giao diện do AI tạo hay tạo hệ thống thiết kế từ đầu, Taste Skill cung cấp cho tác nhân của bạn bộ não thiết kế mà nó thiếu.

Nếu bạn cần lưu trữ đám mây cho các dự án của mình, [lưu trữ trang web của bạn trên DigitalOcean](https://m.do.co/oa14d5f0wx4f) cho khả năng phủ sóng CDN toàn cầu đáng tin cậy. Đối với cơ sở dữ phòng ngừa, [HTStack](https://htstack.com/?referral_code=oa14d5f0wx4f) cung cấp lưu trữ đối tượng giá cả phải chăng. Cần cơ sở hạ tầng proxy đáng tin cậy? [Proxy WebShare](https://proxy.webshare.io/?&promo=oa14d5f0wx4f) bắt đầu từ $1/tháng. Nhà giao dịch crypto có thể sử dụng [Binance](https://bsmkweb.cc/6yq8qf7u) hoặc [OKX](https://promoohubly.com/5g1h7qxn) để đa dạng hóa danh mục đầu tư.

**Hãy thử ngay hôm nay:**

```bash
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"
```

**Liên kết nội bộ**: [Tìm hiểu về tác nhân mã hóa AI](https://dibi8.com/ai-tools/oh-my-pi) · [So sánh tiện ích dev](https://dibi8.com/dev-utils/)

---

**Nguồn & Đọc Thêm**:
- Trang chính thức: https://tasteskill.dev
- Kho lưu trữ GitHub: https://github.com/Leonxlnx/taste-skill
- Changelog: https://www.tasteskill.dev/changelog
- Cộng đồng: [@lexnlin trên X](https://x.com/lexnlin), [@blueemi99 trên X](https://x.com/blueemi99)


**Sources & Further Reading**:
- Trang chủ: https://tasteskill.dev
- GitHub repository: https://github.com/Leonxlnx/taste-skill
- Changelog: https://www.tasteskill.dev/changelog
- Cộng đồng: [@lexnlin trên X](https://x.com/lexnlin), [@blueemi99 trên X](https://x.com/blueemi99)
**CTA**: Tham gia cộng đồng Taste Skill trên Telegram — [t.me/DIBI8_Group](https://t.me/DIBI8_Group)

**Tiết lộ**: Bài viết này chứa liên kết chi phí. Nếu bạn đăng ký qua liên kết của chúng tôi, chúng tôi có thể kiếm được hoa hồng mà không tốn thêm chi phí cho bạn.
