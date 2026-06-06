---
title: AiWind：1000+ AI 绘画提示词宝库，让 GPT-Image 2 和 Nanobanana 产出惊艳作品
description: AiWind là thư viện prompt AI miễn phí với 1000+ prompt chuyên nghiệp
  cho GPT-Image 2, Nanobanana, Stable Diffusion, Midjourney và các mô hình chính khác,
  bao phủ nhiều phong cách từ chân dung chân thực đến cyberpunk và 3D render.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Go
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: ''
last_maintained: '2026-05-15'
featureImage: ''
draft: false
aliases:
- /vi/posts/aiwind-ai-prompt-library/
faqs:
  - q: 'AiWind có miễn phí không?'
    a: 'Có, AiWind là thư viện prompt AI hoàn toàn miễn phí tại aiwind.org, không có gói trả phí. Nó cung cấp hơn 1000 prompt chuyên nghiệp và được cập nhật liên tục.'
  - q: 'AiWind hỗ trợ prompt cho những mô hình AI tạo ảnh nào?'
    a: 'AiWind bao gồm hơn 10 mô hình như GPT-Image 2, Nanobanana, Stable Diffusion, Midjourney, Flux-Kontext, Tencent Hunyuan, Google Imagen và ByteDance Seedream. Mỗi prompt đều có gợi ý về mô hình phù hợp nhất để sử dụng.'
  - q: 'Thư viện prompt của AiWind có những phong cách nghệ thuật nào?'
    a: 'AiWind phân loại prompt theo các phong cách như chân dung thực tế, cyberpunk, dựng hình 3D (phong cách Pixar), nhiếp ảnh phong cảnh, nhiếp ảnh ẩm thực, thời trang editorial, anime, truyền thống Trung Hoa (guofeng), chủ nghĩa siêu thực và đồ họa thông tin. Prompt có thể được lọc theo phong cách, mô hình hoặc từ khóa.'
  - q: 'AiWind khuyến nghị cài đặt CFG Scale và số bước như thế nào cho Stable Diffusion?'
    a: 'Bài viết khuyến nghị CFG Scale từ 7-12, 20-50 bước lấy mẫu, sampler DPM++ 2M Karras và độ phân giải 1024x1024 trở lên. Các thông số này cân bằng giữa mức độ tuân thủ prompt và chất lượng hình ảnh.'
  - q: 'AiWind so sánh với PromptHero, Lexica và Civitai như thế nào?'
    a: 'AiWind nổi bật nhờ truy cập hoàn toàn miễn phí, hỗ trợ tiếng Trung mạnh mẽ và phủ sóng hơn 10 mô hình, trong khi Lexica chỉ hỗ trợ khoảng 3 mô hình và Civitai tập trung chủ yếu vào Stable Diffusion. AiWind, PromptHero và Civitai đều hỗ trợ cộng đồng đóng góp prompt, còn Lexica thì không.'
---

{</* resource-info */>}

## Vấn đề: Tại sao AI vẽ của bạn luôn "thiếu gì đó"?

Bạn đã chi tiền đăng ký GPT-Image 2, Midjourney hoặc Stable Diffusion, nhưng hình ảnh tạo ra luôn:

- Biểu cảm nhân vật cứng nhắc như ma-nơ-canh nhựa
- Phong cảnh thiếu chiều sâu như dán sticker
- Phong cách không thống nhất, mâu thuẫn
- Thiếu chi tiết, phóng to thì thảm họa

**Vấn đề không ở mô hình, mà ở prompt.**

Hầu hết người viết prompt như nói: "Vẽ một cô gái đẹp". Nhưng AI cần biết: Phong cách gì? Ánh sáng thế nào? Bố cục ra sao? Cảm xúc gì?

## AiWind là gì?

[AiWind](https://aiwind.org/) là **thư viện prompt AI miễn phí**, thu thập **1000+ prompt vẽ AI chuyên nghiệp**, được tối ưu hóa cho các mô hình tạo hình ảnh AI chính.

### Các mô hình được hỗ trợ

| Mô hình | Loại | Đặc điểm |
|------|------|------|
| **GPT-Image 2** | OpenAI | Hiểu ngữ nghĩa mạnh, render chữ tốt |
| **Nanobanana** | Trung Quốc | Hỗ trợ tiếng Trung xuất sắc, tốc độ nhanh |
| **Stable Diffusion** | Mã nguồn mở | Tùy biến mạnh, hệ sinh thái phong phú |
| **Midjourney** | Thương mại | Tính nghệ thuật cao, thẩm mỹ tốt |
| **Flux-Kontext** | Mã nguồn mở | Hiểu ngữ cảnh, tính nhất quán tốt |
| **Hunyuan** | Tencent | Tối ưu cảnh tiếng Trung |
| **Imagen** | Google | Độ chân thực như ảnh |
| **Seedream** | ByteDance | Tối ưu di động |

### Các phong cách được bao phủ

- **Chân dung chân thực** — Ánh sáng, chất da, chi tiết biểu cảm
- **Cyberpunk** — Neon, máy móc, cảm giác tương lai
- **3D Render** — Phong cách Pixar, chất liệu chân thực, trưng bày sản phẩm
- **Nhiếp ảnh phong cảnh** — Phối cảnh khí quyển, giờ vàng, phơi sáng dài
- **Ảnh ẩm thực đẹp** — Nguyên liệu lơ lửng, hơi nước, chất liệu
- **Ảnh thời trang đẹp** — Phong cách Vogue, editorial, haute couture
- **Anime** — Hoạt hình, minh họa, thiết kế nhân vật
- **Phong cách Trung Hoa** — Hanfu, thủy mặc, công bút họa
- **Siêu thực** — Giấc mơ, gương vỡ, nghệ thuật khái niệm
- **Infographic** — Công thức nấu ăn, dữ liệu, thiết kế tối giản

## Ví dụ prompt được chọn lọc

### 1. Chân dung chân thực — Siêu mẫu tóc vàng Dubai đêm

```
Siêu mẫu tóc vàng Dubai đêm
Từ khóa: dubai, night, blonde
Phong cách: Nhiếp ảnh thời trang, chân dung đêm
Áp dụng: GPT-Image 2, Midjourney
```

**Hiệu quả**: Người mẫu tóc vàng trước cảnh đêm Dubai, ánh đèn thành phố làm nền, tạo cảm giác tạp chí thời trang cao cấp.

### 2. Ảnh ẩm thực đẹp — Nguyên liệu lơ lửng 8K

```
Nguyên liệu lơ lửng 8K ảnh ẩm thực đẹp
Từ khóa: food, 8k, suspended
Phong cách: Nhiếp ảnh ẩm thực thương mại, bố cục lơ lửng
Áp dụng: Nanobanana, Stable Diffusion
```

**Hiệu quả**: Nguyên liệu lơ lửng giữa không trung, giọt nước bắn tung, chất lượng siêu nét 8K, phù hợp menu nhà hàng và quảng cáo.

### 3. 3D Render — Chàng trai nắng phong cách Pixar

```
Chàng trai nắng phong cách Pixar
Từ khóa: pixar, disney, 3d
Phong cách: Nhân vật hoạt hình 3D, phong cách Pixar
Áp dụng: GPT-Image 2, Flux
```

**Hiệu quả**: Ánh nắng chiếu lên mặt chàng trai, da có tán xạ bề mặt dưới, mắt có phản chiếu highlight, chất lượng nhân vật điển hình Pixar.

### 4. Siêu thực — Tên lửa phóng từ bóng đèn

```
Tên lửa phóng từ bóng đèn
Từ khóa: surreal, rocket, lightbulb
Phong cách: Chủ nghĩa siêu thực, nghệ thuật khái niệm
Áp dụng: Midjourney, Stable Diffusion
```

**Hiệu quả**: Tên lửa phóng từ bóng đèn, mảnh vỡ thủy tinh bay tứ tán, sáng tạo đầy ý tưởng, phù hợp poster và bìa.

### 5. Phong cách Trung Hoa — Mỹ nữ đồ sứ Hanfu

```
Mỹ nữ đồ sứ Hanfu
Từ khóa: hanfu, chinese, traditional
Phong cách: Công bút họa truyền thống Trung Quốc, tranh mỹ nữ
Áp dụng: Nanobanana, Hunyuan
```

**Hiệu quả**: Mỹ nữ mặc Hanfu, cầm bình sứ, nền có yếu tố sơn thủy, công bút tinh tế, màu sắc trang nhã.

### 6. Ảnh thời trang đẹp — Bìa Vogue săn mồi hắc ám

```
Bìa Vogue săn mồi hắc ám
Từ khóa: vogue, editorial, predatory
Phong cách: Editorial thời trang cao cấp, mỹ học hắc ám
Áp dụng: GPT-Image 2, Midjourney
```

**Hiệu quả**: Ánh mắt người mẫu sắc lạnh, trang điểm hắc ám, bố cục tham khảo bìa Vogue, chất lượng cao cấp.

## Cách sử dụng AiWind

### Bước 1: Duyệt thư viện prompt

Truy cập [aiwind.org](https://aiwind.org/), duyệt 1000+ prompt. Hỗ trợ lọc theo phong cách, mô hình, từ khóa.

### Bước 2: Xem chi tiết

Nhấn vào bất kỳ prompt nào để xem:
- Prompt tiếng Anh đầy đủ
- Mô hình và tham số được đề xuất
- Hình ảnh ví dụ
- Phân loại thẻ

### Bước 3: Sao chép sử dụng

Sao chép prompt vào công cụ tạo hình ảnh AI của bạn:

```
# Ví dụ Midjourney
/imagine prompt: Siêu mẫu tóc vàng Dubai đêm, dubai night blonde, 
fashion photography, golden hour lighting, 
editorial style, 8k, ultra detailed --ar 3:4 --v 6

# Ví dụ Stable Diffusion
Prompt tích cực: dubai night blonde supermodel, fashion photography,
golden hour, editorial, 8k, ultra detailed, 
best quality, masterpiece
Prompt tiêu cực: blurry, low quality, distorted face, extra limbs
```

### Bước 4: Đóng góp chia sẻ

Nếu bạn có prompt xuất sắc, hãy đóng góp cho AiWind để giúp cộng đồng phát triển.

## Kỹ thuật Prompt Engineering

### 1. Prompt có cấu trúc

```
[Chủ thể] + [Phong cách] + [Ánh sáng] + [Bố cục] + [Từ chất lượng]

Ví dụ:
Chủ thể: Siêu mẫu tóc vàng đứng trước cảnh đêm Dubai
Phong cách: Nhiếp ảnh thời trang, phong cách editorial Vogue
Ánh sáng: Giờ vàng, ánh đèn thành phố làm nền
Bố cục: Cận cảnh, quy tắc một phần ba
Chất lượng: 8K, siêu nét, chất lượng tốt nhất, kiệt tác
```

### 2. Điều chỉnh trọng số (Stable Diffusion)

```
(Siêu mẫu tóc vàng:1.3) có nghĩa là tăng trọng số
[Cảnh đêm:0.8] có nghĩa là giảm trọng số
```

### 3. Prompt tiêu cực

```
 blurry, lowres, bad anatomy, bad hands, text, error, 
 missing fingers, extra digit, fewer digits, cropped, 
 worst quality, low quality, normal quality, 
 jpeg artifacts, signature, watermark, username
```

### 4. Tinh chỉnh tham số

| Tham số | Tác dụng | Giá trị đề xuất |
|------|------|--------|
| **CFG Scale** | Mức độ tuân thủ prompt | 7-12 |
| **Steps** | Số bước lặp | 20-50 |
| **Sampler** | Bộ lấy mẫu | DPM++ 2M Karras |
| **Resolution** | Độ phân giải | 1024x1024 hoặc cao hơn |

## So sánh với công cụ tương tự

| Tính năng | AiWind | PromptHero | Lexica | Civitai |
|------|--------|-----------|--------|---------|
| **Miễn phí** | ✅ Hoàn toàn | ⚠️ Một phần | ✅ Có | ✅ Có |
| **Hỗ trợ tiếng Trung** | ✅ Xuất sắc | ❌ Yếu | ❌ Yếu | ⚠️ Trung bình |
| **Bao phủ mô hình** | 10+ mô hình | 5+ mô hình | 3 mô hình | Chủ yếu SD |
| **Chất lượng prompt** | Chuyên nghiệp | Cộng đồng | Cộng đồng | Cộng đồng |
| **Hình ảnh ví dụ** | ✅ Có | ✅ Có | ✅ Có | ✅ Có |
| **Tính năng đóng góp** | ✅ Có | ✅ Có | ❌ Không | ✅ Có |
| **Hệ thống phân loại** | Chi tiết | Trung bình | Trung bình | Thẻ |

## Kết luận

AiWind là **thư viện prompt vẽ AI tốt nhất cho người dùng tiếng Trung**.

- 1000+ prompt, bao phủ các mô hình và phong cách chính
- Hoàn toàn miễn phí, cập nhật liên tục
- Giao diện tiếng Trung, prompt tiếng Trung
- Hình ảnh ví dụ hiển thị hiệu quả trực quan

Nếu bạn luôn cảm thấy "thiếu gì đó" khi tạo hình ảnh bằng AI, hãy tìm cảm hứng tại AiWind.

**Website**: [aiwind.org](https://aiwind.org/)  
**Tính năng**: 1000+ prompt | Hỗ trợ 10+ mô hình | Miễn phí sử dụng

## Bài viết liên quan

- [Pixelle-Video: AI Tạo Video Ngắn Tự Động](/vi/resources/ai-tools/pixelle-video-ai-short-video-generator/)
- [TabPFN: Mô Hình Cơ Sở Cho Dữ Liệu Bảng](/vi/resources/ai-tools/tabpfn-foundation-model-tabular-data/)
- [Hermes Agent: AI Agent Tự Cải Thiện](/vi/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/)

---

## Công Cụ Đề Xuất

Cho developer xây dựng hoặc triển khai công cụ AI mã nguồn mở:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 tín dụng miễn phí cho người dùng mới, 14+ region toàn cầu, droplet GPU/CPU một-cú-click cho AI workload.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Proxy Anthropic Claude / OpenAI / DeepSeek API. Hầu hết AI tool ở trên (chatbot, code gen, translation, search, v.v.) cần LLM API key — proxy này cho access ổn định top model với ~30% giá chính thức.
- **{{< aff "hostinger" "footer-cta-legacy" "Hostinger" >}}** — Lựa chọn VPS giá tốt cho thị trường Việt Nam.

*Affiliate link — không tăng chi phí của bạn nhưng giúp dibi8.com duy trì hoạt động.*

