---
title: 'Pixelle-Video Đánh Giá: Công Cụ Tạo Video Ngắn Tự Động Bằng AI, Nhập Chủ Đề
  Nhận Video Hoàn Chỉnh'
description: Pixelle-Video là công cụ tạo video ngắn tự động hoàn toàn bằng AI mã
  nguồn mở. Nhập chủ đề để tự động tạo kịch bản, hình ảnh AI, lời thuyết minh và nhạc
  nền.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Python
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "27.1 MB"
file_md5: ''
download_url: https://github.com/AIDC-AI/Pixelle-Video
backup_url: ''
github_repo: https://github.com/AIDC-AI/Pixelle-Video
stars: 18065
maintainer: "AIDC-AI"
last_maintained: "2026-05-06"
featureImage: ''
draft: false
aliases:
- /vi/posts/pixelle-video-ai-short-video-generator/
faqs:
  - q: 'Pixelle-Video là gì?'
    a: 'Pixelle-Video là một AI engine mã nguồn mở, cấp phép MIT, có khả năng biến một chủ đề duy nhất thành một video ngắn hoàn chỉnh. Chỉ cần một đầu vào, nó tự động viết kịch bản, tạo hình ảnh hoặc video AI phù hợp, tổng hợp giọng đọc bằng TTS, và thêm nhạc nền trước khi render video cuối cùng.'
  - q: 'Pixelle-Video có miễn phí và mã nguồn mở không?'
    a: 'Có. Pixelle-Video được AIDC-AI phát hành dưới giấy phép MIT và hoàn toàn miễn phí để tự triển khai. Triển khai cục bộ không tốn chi phí ngoài việc cần GPU; tuy nhiên nếu thiếu phần cứng cục bộ, bạn có thể tùy chọn sử dụng các dịch vụ đám mây trả theo lượt dùng như RunningHub để tạo ảnh.'
  - q: 'Pixelle-Video hỗ trợ những mô hình AI nào?'
    a: 'Về tạo kịch bản, hỗ trợ OpenAI GPT-4o/GPT-4o-mini, Alibaba Tongyi Qianwen, DeepSeek V3/R1 và các mô hình Ollama cục bộ. Về tạo ảnh, hỗ trợ FLUX, Stable Diffusion, Qwen, Nano Banana và RunningHub. Về tổng hợp giọng nói, hỗ trợ Edge-TTS, Index-TTS và ChatTTS.'
  - q: 'Cách cài đặt và chạy Pixelle-Video như thế nào?'
    a: 'Clone repo bằng git, chạy pip install -r requirements.txt, điền API key vào config.json, sau đó khởi chạy giao diện bằng python webui.py. Gradio Web UI sẽ mở tại http://localhost:7860, nơi bạn nhập chủ đề, chọn giọng nói và template, rồi nhấn Generate Video.'
  - q: 'Pixelle-Video có thể làm gì ngoài tạo video cơ bản?'
    a: 'Công cụ này bao gồm ba mô-đun mở rộng: Digital Human Avatar — biến một bức ảnh thành video đầu người nói có đồng bộ môi bằng tiếng Hàn, tiếng Trung hoặc tiếng Anh; Image-to-Video — chuyển ảnh tĩnh thành video động; và Motion Transfer — ánh xạ chuyển động từ video tham chiếu lên ảnh tĩnh.'
---
{</* resource-info */>}

![Pixelle-Video Web UI: kịch bản / TTS / phân cảnh / video](/images/articles/pixelle-video-ai-short-video-generator/webui.png)
*Nguồn: [github.com/AIDC-AI/Pixelle-Video](https://github.com/AIDC-AI/Pixelle-Video) — Web UI chính thức*

## Pixelle-Video là gì?

**Pixelle-Video** là công cụ tạo video ngắn tự động hoàn toàn bằng AI mã nguồn mở. Chỉ cần nhập một **chủ đề**, công cụ sẽ tự động hoàn thành toàn bộ quy trình sản xuất video:

- ✍️ **AI viết kịch bản** — Tự động tạo lời thuyết minh dựa trên chủ đề
- 🎨 **AI tạo hình ảnh/video** — Tạo hình minh họa AI hoặc video động cho mỗi cảnh
- 🗣️ **AI tổng hợp giọng nói** — Chuyển đổi kịch bản thành giọng nói tự nhiên
- 🎵 **Nhạc nền** — Tự động thêm BGM để tăng không khí
- 🎬 **Tổng hợp video một cú click** — Tự động render video hoàn chỉnh

**Không rào cản, không cần kinh nghiệm chỉnh sửa** — sáng tạo video đơn giản như viết một câu!

🔗 **GitHub**: [https://github.com/AIDC-AI/Pixelle-Video](https://github.com/AIDC-AI/Pixelle-Video)

---

## Tính năng nổi bật

| Tính năng | Mô tả |
|-----------|-------|
| **Tạo tự động hoàn toàn** | Nhập chủ đề → nhận video hoàn chỉnh |
| **AI viết kịch bản thông minh** | AI tự viết lời thuyết minh, không cần viết tay |
| **AI tạo hình ảnh** | Mỗi câu đều có hình minh họa AI đẹp mắt |
| **AI tạo video** | Hỗ trợ mô hình video WAN 2.1 tạo nội dung động |
| **Đa dạng TTS** | Edge-TTS, Index-TTS và nhiều giải pháp tổng hợp giọng nói |
| **Nhạc nền** | Hỗ trợ thêm BGM để video có không khí hơn |
| **Mẫu thị giác** | Nhiều mẫu để tạo phong cách video độc đáo |
| **Kích thước linh hoạt** | Hỗ trợ dọc, ngang và nhiều kích thước video khác |
| **Nhiều mô hình AI** | GPT, Tongyi Qianwen, DeepSeek, Ollama, v.v. |
| **Kiến trúc ComfyUI** | Thiết kế mô-đun, có thể tùy chỉnh mọi khả năng |

---

## Quy trình tạo video

Pixelle-Video sử dụng thiết kế mô-đun với quy trình rõ ràng:

**Tạo kịch bản → Lập kế hoạch hình ảnh → Xử lý từng khung hình → Tổng hợp video**

Mỗi giai đoạn đều hỗ trợ tùy chỉnh linh hoạt — có thể chọn mô hình AI khác nhau, công cụ âm thanh, phong cách thị giác, v.v. để đáp ứng nhu cầu sáng tạo cá nhân.

---

## Mô-đun mở rộng

Ngoài tạo video cơ bản, Pixelle-Video còn cung cấp các chức năng mở rộng mạnh mẽ:

### 👤 Avatar kỹ thuật số
Tải lên ảnh để tạo video nói chuyện với đồng bộ môi. Hỗ trợ đa ngôn ngữ bao gồm tiếng Hàn, tiếng Trung, tiếng Anh.

### 🖼️ Ảnh thành video
Chuyển đổi hình ảnh tĩnh thành video động bằng mô hình tạo video AI.

### 💃 Chuyển giao chuyển động
Tải lên video tham chiếu và ảnh để chuyển chuyển động sang ảnh — ví dụ: làm cho người trong ảnh nhảy theo video.

---

## Mô hình AI được hỗ trợ

### LLM (Tạo kịch bản)
- OpenAI GPT-4o / GPT-4o-mini
- Alibaba Tongyi Qianwen
- DeepSeek V3 / R1
- Ollama (triển khai cục bộ)
- Điểm cuối API tùy chỉnh

### Tạo hình ảnh
- FLUX (qua ComfyUI)
- Stable Diffusion
- Tongyi Qianwen tạo hình ảnh
- Dịch vụ đám mây RunningHub
- Mô hình Nano Banana

### TTS (Tổng hợp giọng nói)
- Edge-TTS (miễn phí, đa ngôn ngữ)
- Index-TTS (nhân bản giọng nói)
- ChatTTS
- Quy trình TTS ComfyUI tùy chỉnh

---

## Bắt đầu nhanh

### 1. Clone kho lưu trữ

```bash
git clone https://github.com/AIDC-AI/Pixelle-Video.git
cd Pixelle-Video
```

### 2. Cài đặt phụ thuộc

```bash
pip install -r requirements.txt
```

### 3. Cấu hình khóa API

Chỉnh sửa `config.json` với khóa API của bạn:

```json
{
  "llm": {
    "api_key": "khóa-api-của-bạn",
    "base_url": "https://api.openai.com/v1",
    "model": "gpt-4o"
  },
  "image": {
    "comfyui_url": "http://127.0.0.1:8188"
  }
}
```

### 4. Khởi động giao diện Web

```bash
python webui.py
```

Mở `http://localhost:7860` trong trình duyệt.

### 5. Tạo video đầu tiên

1. Nhập chủ đề, ví dụ: "Tại sao nên duy trì thói quen đọc sách"
2. Chọn giọng TTS yêu thích
3. Chọn mẫu thị giác
4. Nhấp "Tạo video"
5. Đợi 2-5 phút để nhận video hoàn chỉnh

---

## Kịch bản sử dụng

| Kịch bản | Ví dụ chủ đề |
|----------|-------------|
| **Chia sẻ kiến thức** | "10 thủ thuật Python người mới nên biết" |
| **Đánh giá sản phẩm** | "So sánh iPhone 16 vs Samsung S24" |
| **Kể chuyện** | "Hành trình của một nhà sáng lập startup" |
| **Nội dung giáo dục** | "Blockchain hoạt động như thế nào?" |
| **Bình luận tin tức** | "Xu hướng AI năm 2026" |
| **Đánh giá sách/phim** | "Bài học từ 'Thói quen nguyên tử'" |

---

## Ví dụ phong cách video

Pixelle-Video hỗ trợ nhiều phong cách video:

- 🌄 **Phong cách tài liệu** — Du lịch, thiên nhiên, câu chuyện nhân văn
- 🔍 **Phân tích văn hóa** — Phân tích sâu về xu hướng và hiện tượng
- 🔭 **Khoa học triết học** — Giải thích khái niệm phức tạp một cách đơn giản
- 🌱 **Phát triển cá nhân** — Tự cải thiện, nâng cao hiệu suất
- 🧠 **Suy nghĩ sâu sắc** — Tâm lý học, triết học, phản tỉnh
- 🏯 **Lịch sử văn hóa** — Trí tuệ cổ nhân, sự kiện lịch sử
- ☀️ **Cảm xúc** — Câu chuyện ấm áp, nguồn cảm hứng
- 📜 **Bình luận tiểu thuyết** — Đánh giá tiểu thuyết, phân tích nhân vật
- 🧬 **Kiến thức khoa học** — Kiến thức y tế, lời khuyên sức khỏe

---

## Kiến trúc kỹ thuật

Pixelle-Video được xây dựng trên kiến trúc **ComfyUI**:

- **Quy trình làm việc mô-đun** — Mỗi thành phần (LLM, TTS, tạo hình ảnh) là một nút độc lập
- **Đường ống tùy chỉnh** — Dễ dàng thay thế bất kỳ mô hình hoặc dịch vụ nào
- **Thiết kế ưu tiên API** — Tất cả khả năng được hiển thị qua REST API
- **Giao diện Web** — Giao diện dễ sử dụng dựa trên Gradio
- **Xử lý hàng loạt** — Tạo nhiều video đồng thời

---

## Hiệu suất và chi phí

| Tùy chọn | Chi phí | Tốc độ | Chất lượng |
|----------|---------|--------|------------|
| **Triển khai cục bộ** | Miễn phí (cần GPU) | Nhanh | Cao |
| **Đám mây RunningHub** | Trả theo lượng sử dụng | Tức thì | Cao |
| **Chế độ hỗn hợp** | Linh hoạt | Cân bằng | Cao |

Cấu hình khuyến nghị cho người mới:
- LLM: DeepSeek API (rẻ, chất lượng tốt)
- Hình ảnh: RunningHub (không cần GPU cục bộ)
- TTS: Edge-TTS (miễn phí, đa ngôn ngữ)

---

## So sánh với các công cụ khác

| Tính năng | Pixelle-Video | HeyGen | Synthesia | Pictory |
|-----------|--------------|--------|-----------|---------|
| **Mã nguồn mở** | ✅ | ❌ | ❌ | ❌ |
| **Sử dụng miễn phí** | ✅ | Hạn chế | Hạn chế | Hạn chế |
| **Triển khai cục bộ** | ✅ | ❌ | ❌ | ❌ |
| **Mô hình tùy chỉnh** | ✅ | ❌ | ❌ | ❌ |
| **Tích hợp ComfyUI** | ✅ | ❌ | ❌ | ❌ |
| **Nhân bản giọng nói** | ✅ | ✅ | ✅ | ❌ |
| **Con người kỹ thuật số** | ✅ | ✅ | ✅ | ❌ |
| **Chuyển giao chuyển động** | ✅ | ❌ | ❌ | ❌ |

---

## Mẹo để có kết quả tốt nhất

1. **Chủ đề cụ thể** — Chủ đề càng cụ thể, kịch bản càng tốt
2. **Chọn mẫu phù hợp** — Chọn mẫu phù hợp với phong cách nội dung
3. **Tiền tố gợi ý** — Sử dụng tiền tố gợi ý tiếng Anh để duy trì phong cách hình ảnh nhất quán
4. **Xem trước giọng nói** — Luôn xem trước TTS trước khi tạo video đầy đủ
5. **Tạo hàng loạt** — Tạo 3-5 phiên bản cùng lúc, chọn cái tốt nhất

---

## Bài viết liên quan

- [Free Claude Code: Công Cụ Proxy Mã Nguồn Mở Để Sử Dụng Claude Code CLI Miễn Phí](/vi/resources/ai-tools/free-claude-code-open-source-proxy/) — Trợ lý lập trình AI miễn phí
- [Agent Reach: Trao Siêu Năng Lực Internet cho AI Agent của Bạn](/vi/resources/llm-frameworks/agent-reach-ai-agent-internet-access/) — Công cụ kết nối AI agent với internet

---

## Kết luận

**Pixelle-Video** dân chủ hóa việc tạo video bằng cách kết hợp LLM, tạo hình ảnh, TTS và chỉnh sửa video thành một đường ống tự động duy nhất. Dù bạn là người sáng tạo nội dung, nhà giáo dục, nhà tiếp thị hay nhà phát triển, công cụ này đều có thể tiết kiệm hàng giờ thời gian sản xuất video.

Kiến trúc dựa trên ComfyUI có nghĩa là nó không chỉ là công cụ hộp đen — bạn có thể tùy chỉnh từng thành phần, thay thế mô hình và xây dựng quy trình tạo video của riêng mình.

**Phù hợp nhất cho**: Người sáng tạo nội dung, nhà giáo dục, nhà tiếp thị, nhà phát triển cần tạo video nhanh

**GitHub**: [https://github.com/AIDC-AI/Pixelle-Video](https://github.com/AIDC-AI/Pixelle-Video)

---


---

## Công Cụ Đề Xuất

Cho developer xây dựng hoặc triển khai công cụ AI mã nguồn mở:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 tín dụng miễn phí cho người dùng mới, 14+ region toàn cầu, droplet GPU/CPU một-cú-click cho AI workload.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Proxy Anthropic Claude / OpenAI / DeepSeek API. Hầu hết AI tool ở trên (chatbot, code gen, translation, search, v.v.) cần LLM API key — proxy này cho access ổn định top model với ~30% giá chính thức.
- **{{< aff "hostinger" "footer-cta-legacy" "Hostinger" >}}** — Lựa chọn VPS giá tốt cho thị trường Việt Nam.

*Affiliate link — không tăng chi phí của bạn nhưng giúp dibi8.com duy trì hoạt động.*

*Cập nhật lần cuối: 2026-05-06*
