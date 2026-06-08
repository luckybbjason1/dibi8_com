---
title: 'Odysseus: Không Gian Làm Việc AI Tự Lưu Trữ Đạt 63.000 Sao GitHub Trong 9 Ngày — Hướng Dẫn 2026'
description: 'Odysseus là không gian làm việc AI mã nguồn mở, ưu tiên quyền riêng tư (63.000 sao trong 9 ngày, giấy phép MIT). Một lệnh Docker duy nhất giúp bạn có chat, AI agent, nghiên cứu chuyên sâu, phân loại email, lịch, ghi chú và Cookbook mô hình — tất cả chạy trên phần cứng của bạn. Bài viết hướng dẫn cài đặt, tính năng chính và so sánh với ChatGPT Plus.'
date: 2026-06-09 00:00:00+08:00
lastmod: 2026-06-09 00:00:00+08:00
tech_stack: []
application_domain: AI Tools
source_version: '1.0'
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: 'https://github.com/pewdiepie-archdaemon/odysseus'
backup_url: ''
github_repo: 'pewdiepie-archdaemon/odysseus'
stars: 63159
maintainer: 'pewdiepie-archdaemon'
last_maintained: '2026-06-08'
featureImage: 'https://raw.githubusercontent.com/pewdiepie-archdaemon/odysseus/main/docs/odysseus.jpg'
draft: false
categories: ['ai-tools']
tags: ['Odysseus', 'AI tự lưu trữ', 'không gian làm việc AI', 'LLM cục bộ', 'quyền riêng tư', 'Docker', 'mã nguồn mở', 'thay thế ChatGPT', 'Ollama', 'nghiên cứu chuyên sâu']
aliases:
- /vi/posts/odysseus-self-hosted-ai-workspace-2026/
faqs:
  - q: 'Odysseus có cần GPU để chạy không?'
    a: 'Không. Bản thân Odysseus rất nhẹ. GPU chỉ cần thiết khi bạn muốn chạy mô hình cục bộ qua tính năng Cookbook. Bạn có thể kết nối với API từ xa (OpenAI, Anthropic, OpenRouter) hoặc instance Ollama riêng mà không cần GPU cục bộ.'
  - q: 'Odysseus khác Open WebUI ở điểm nào?'
    a: 'Open WebUI tập trung vào chat và RAG qua Ollama. Odysseus bổ sung thêm một bộ tính năng đầy đủ: AI agent hỗ trợ MCP tool calling, nghiên cứu chuyên sâu với báo cáo trực quan, ứng dụng email tích hợp AI, lịch CalDAV, ghi chú có nhắc nhở, và Cookbook tự động phát hiện VRAM để gợi ý mô hình tương thích. Nó gần với một ChatGPT Plus tự lưu trữ hơn là giao diện Ollama thông thường.'
  - q: 'Odysseus hỗ trợ những backend LLM nào?'
    a: 'Hỗ trợ sẵn: vLLM, llama.cpp, Ollama, OpenRouter, OpenAI và GitHub Copilot. Thêm server mô hình trong Cài đặt bằng cách nhập URL và key là xong, không cần sửa code. Tính năng Cookbook cũng tự động cài đặt và chạy các mô hình GGUF, FP8, AWQ tương thích dựa trên VRAM được phát hiện.'
  - q: 'Có an toàn khi mở Odysseus ra internet không?'
    a: 'Docker Compose mặc định chỉ bind vào 127.0.0.1. Để truy cập qua LAN, đặt APP_BIND=0.0.0.0 trong .env và giữ AUTH_ENABLED=true. Khi mở ra internet công khai, bắt buộc phải dùng reverse proxy (Nginx, Caddy) kết hợp TLS. Nhà phát triển khuyến cáo rõ ràng không nên bind ra 0.0.0.0 khi chưa bật xác thực.'
  - q: 'Có thể dùng Odysseus trên điện thoại không?'
    a: 'Có. Odysseus là PWA (Progressive Web App) với thiết kế đáp ứng hoàn toàn. Trên iOS hoặc Android, bạn có thể "Thêm vào màn hình chính" để có trải nghiệm gần như ứng dụng native. Các tính năng Cookbook và Agent cũng hoạt động trên di động, nhưng việc chạy mô hình cục bộ cần GPU vẫn đòi hỏi máy tính hoặc server.'
---

Odysseus ra mắt trên GitHub ngày 31 tháng 5 năm 2026 và đạt 63.000 sao vào ngày 8 tháng 6 — trung bình khoảng **7.000 sao mới mỗi ngày**, trở thành một trong những dự án AI mã nguồn mở tăng trưởng nhanh nhất năm 2026. Ý tưởng cốt lõi đơn giản: tất cả những gì bạn nhận được từ gói ChatGPT Plus $20/tháng, chạy trên phần cứng của chính bạn, với dữ liệu của riêng bạn, dưới giấy phép MIT.

## Odysseus Thực Chất Là Gì

Về mặt kỹ thuật, Odysseus là ứng dụng web Python (backend FastAPI + Uvicorn, frontend vanilla JS) tích hợp nhiều thành phần mã nguồn mở đã được kiểm chứng thành một không gian làm việc thống nhất:

- **Chat** — trò chuyện với bất kỳ LLM cục bộ hoặc từ xa nào. Thêm server mô hình trong Cài đặt với URL và key; Odysseus xử lý phần còn lại. Backend hỗ trợ: vLLM, llama.cpp, Ollama, OpenRouter, OpenAI, GitHub Copilot.
- **Agent** — giao mục tiêu và công cụ (web, file, shell, MCP server, bộ nhớ) cho AI, để nó tự thực hiện toàn bộ tác vụ. Layer agent được xây dựng trên [opencode](https://github.com/anomalyco/opencode).
- **Cookbook** — quét phần cứng, phát hiện VRAM khả dụng, gợi ý mô hình GGUF / FP8 / AWQ phù hợp và cho phép tải xuống, chạy bằng một cú nhấp. Được hỗ trợ bởi [llmfit](https://github.com/AlexsJones/llmfit).
- **Nghiên Cứu Chuyên Sâu (Deep Research)** — nghiên cứu đa bước tự động: tìm kiếm web, đọc nguồn, tổng hợp thành báo cáo trực quan có cấu trúc. Phát triển từ [Tongyi DeepResearch](https://github.com/Alibaba-NLP/DeepResearch) của Alibaba.
- **So Sánh (Compare)** — so sánh mù nhiều mô hình song song. Cùng một prompt gửi đến nhiều mô hình; bạn đánh giá mà không biết mô hình nào tạo ra câu trả lời nào.
- **Tài Liệu (Documents)** — trình soạn thảo đa tab Markdown / HTML / CSV theo phương châm "bạn viết, AI hỗ trợ".
- **Bộ Nhớ / Kỹ Năng (Memory / Skills)** — vector store ChromaDB + fastembed (ONNX) cung cấp bộ nhớ lâu dài cho agent. Hỗ trợ import/export.
- **Email** — hộp thư IMAP/SMTP với AI phân loại: phát hiện mức độ khẩn cấp, tự động gắn thẻ, tóm tắt, soạn thảo trả lời.
- **Ghi Chú & Công Việc (Notes & Tasks)** — ghi chú với nhắc nhở, danh sách việc cần làm, và các tác vụ theo lịch mà agent có thể thực hiện tự động.
- **Lịch (Calendar)** — lịch ưu tiên cục bộ với đồng bộ CalDAV tới Radicale, Nextcloud, Apple Calendar hoặc Fastmail.
- **PWA / Di Động** — thiết kế đáp ứng, cài được lên màn hình chính iOS/Android.

## Khởi Động Nhanh (Docker)

```bash
git clone https://github.com/pewdiepie-archdaemon/odysseus.git
cd odysseus
cp .env.example .env          # tùy chọn nhưng khuyến nghị
docker compose up -d --build
```

Mở **http://localhost:7000**. Lần chạy đầu tiên, Odysseus in mật khẩu admin tạm thời vào Docker logs:

```bash
docker compose logs odysseus | grep "Admin password"
```

Đăng nhập, đổi mật khẩu trong Cài đặt, rồi thêm server mô hình đầu tiên (Ollama cục bộ hoặc OpenAI API key).

## Cài Đặt Native (Linux / macOS)

Người dùng Apple Silicon nên chạy native thay vì Docker để sử dụng GPU Metal:

```bash
git clone https://github.com/pewdiepie-archdaemon/odysseus.git
cd odysseus
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
python setup.py
python -m uvicorn app:app --host 127.0.0.1 --port 7000
```

Khởi động nhanh trên Apple Silicon:

```bash
./start-macos.sh        # bind vào 127.0.0.1:7860
```

Yêu cầu: Python 3.11+. Cookbook cần `tmux` để tải model nền.

## So Sánh Với Các Công Cụ Khác

| Tính Năng | Odysseus | Open WebUI | ChatGPT Plus |
|---|---|---|---|
| Tự lưu trữ | ✅ | ✅ | ❌ |
| Agent + MCP tool | ✅ | Một phần | ✅ |
| Nghiên cứu chuyên sâu | ✅ | ❌ | ✅ |
| Phân loại email AI | ✅ | ❌ | ❌ |
| Lịch (CalDAV) | ✅ | ❌ | ❌ |
| Model Cookbook | ✅ | ❌ | N/A |
| So sánh mô hình mù | ✅ | ❌ | ❌ |
| Chi phí hàng tháng | Chỉ phần cứng | Chỉ phần cứng | $20 |

## Lưu Ý

Odysseus hiện là phiên bản 1.0, mới ra mắt chưa đến 2 tuần. Một số điểm cần lưu ý: trên Linux, Cookbook có một số runtime cần `tmux` thủ công cho tác vụ nền; đồng bộ CalDAV có lỗi đã biết với sự kiện lặp lại; hiệu suất PWA trên di động khác nhau tùy trình duyệt. Tuy nhiên, issue tracker được quản lý tích cực và nhà phát triển phản hồi nhanh.

Với triển khai agent cấp độ sản xuất, các framework đã được kiểm chứng như LangGraph hay CrewAI vẫn đáng tin cậy hơn. Odysseus phù hợp nhất như một **không gian làm việc AI cá nhân** — mạnh mẽ, linh hoạt và bảo vệ quyền riêng tư.

## Kết Luận

Nếu bạn muốn trải nghiệm AI như ChatGPT trên phần cứng của chính mình, không tốn phí hàng tháng, không đẩy dữ liệu lên cloud, Odysseus là lựa chọn mã nguồn mở hoàn chỉnh nhất hiện tại. 63.000 sao trong 9 ngày phản ánh sự ủng hộ thực sự từ cộng đồng, không phải hype. Clone repo, chạy `docker compose up`, 5 phút sau bạn có đầy đủ không gian làm việc AI.

**GitHub:** [pewdiepie-archdaemon/odysseus](https://github.com/pewdiepie-archdaemon/odysseus)
