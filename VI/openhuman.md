---
title: 'OpenHuman là gì?'
lang: vi
description: 'content/vi/resources/openhuman.md'
date: 2026-06-18
layout: article
category: resources
slug: openhuman
featureImage: /articles/what-is-openhuman.jpg/images/articles/what-is-openhuman.jpg
---


# OpenHuman: Agent AI Chạy Cục bộ Phát triển Nhanh nhất (31K Stars) — Nền tảng AI Mã nguồn mở 2026

Bạn có thể đã nhận ra một quy luật khá phổ biến: mua một công cụ AI mới, dành hàng giờ để cấu hình khóa API, kết nối các tích hợp, và dạy agent hiểu về cơ sở mã của bạn — rồi cuối cùng nó quên sạch mọi thứ chỉ vì bạn khởi động lại. Đó chính là vấn đề "khởi động lạnh" mà bất kỳ trợ lý AI nào cũng phải đối mặt.

OpenHuman giải quyết vấn đề này theo một hướng hoàn toàn khác. Chỉ trong vòng một tháng, với 29.805 sao trên GitHub, nó đã trở thành agent AI phát triển nhanh nhất năm 2026. Nhưng điều thực sự đáng chú ý là: nó ghi nhớ bạn.

Memory Tree — một kho lưu trữ Markdown theo phong cách Obsidian được lưu trữ cục bộ trên máy của bạn — giúp OpenHuman học hỏi dần về các dự án, sở thích và quy trình làm việc của bạn theo thời gian. Không phụ thuộc vào đám mây. Không tràn ngập khóa API. Chỉ một agent chạy ưu tiên cục bộ, càng dùng càng thông minh.

Đây không phải là ChatGPT Desktop có giao diện đẹp hơn. Đây là một cách tư duy hoàn toàn mới về vai trò của trợ lý AI khi quyền riêng tư, khả năng ghi nhớ và các tích hợp thực sự được đặt lên hàng đầu.

## OpenHuman là gì?

OpenHuman là một **trợ lý agentic mã nguồn mở** được thiết kế để hòa nhập vào quy trình làm việc hàng ngày của bạn trong khi mọi thứ vẫn chạy cục bộ. Khác với các trợ lý dạng trò chuyện tồn tại trong trình duyệt, OpenHuman là một **ứng dụng desktop** với:

- **Memory Tree**: Một kho lưu trữ Markdown liên tục, tương thích Obsidian, lưu giữ lịch sử quy trình làm việc, sở thích và ngữ cảnh dự án — đồng bộ cục bộ, chưa bao giờ gửi lên đám mây
- **Định tuyến mô hình**: Hỗ trợ tích hợp hơn 50 mô hình AI thông qua một tài khoản duy nhất, kèm theo cân bằng tải tự động và cơ chế dự phòng
- **118+ tích hợp**: Các kết nối dựa trên OAuth cho GitHub, Slack, Notion, Figma và nhiều dịch vụ khác — không cần quản lý thủ công từng khóa API
- **TokenJuice**: Lớp nén thông minh token, giảm 60–95% lượng token tiêu thụ trong cửa sổ ngữ cảnh mà không làm giảm độ chính xác

Dự án bắt đầu từ tháng 2 năm 2026 và đã nhanh chóng tích lũy được **31.869 sao trên GitHub** cùng **3.089 bản fork**. OpenHuman được phát hành theo giấy phép GPL-3.0 và được phát triển bởi TinyHumans AI — một nhóm tập trung vào các công cụ AI ưu tiên quyền riêng tư.

```yaml
# Cấu hình OpenHuman — Vị trí Memory Tree
# Mọi dữ liệu mặc định chỉ tồn tại trên máy của bạn
memory:
  vault_path: ~/.openhuman/vault
  sync_mode: local  # hoặc "managed" nếu muốn đồng bộ đám mây tùy chọn
  model_default: gpt-4o
  model_fallback: claude-sonnet-4
  token_compression: true
```

## OpenHuman hoạt động như thế nào?

OpenHuman tuân theo kiến trúc **ưu tiên cục bộ** với các dịch vụ quản lý tùy chọn:

```
┌─────────────────────────────────────────────┐
│              OpenHuman Desktop App            │
├─────────────┬──────────────┬────────────────┤
│  Memory Tree│  Model       │  Integrations  │
│  (Local     │  Routing     │  (118+ via     │
│  Obsidian   │  (50+ models │   OAuth)       │
│  Vault)     │   layered)   │               │
├─────────────┴──────────────┴────────────────┤
│        TokenJuice (nén token 60-95%)          │
├─────────────────────────────────────────────┤
│        Runtime cục bộ (Rust-based, <50MB RAM) │
└─────────────────────────────────────────────┘
```

**Memory Tree** chính là đổi mới cốt lõi. Hãy tưởng tượng nó như một đồ thị kiến thức cá nhân tự xây dựng. Mọi cuộc trò chuyện, tham chiếu tệp và quyết định quy trình làm việc đều được lưu dưới dạng Markdown trong kho lưu trữ cục bộ của bạn. Khi bạn hỏi OpenHuman về một dự án từ hai tuần trước, nó không tìm kiếm lịch sử chat — nó đọc Memory Tree, thứ đã có sẵn ngữ cảnh có cấu trúc về dự án đó.

Lớp **dịch vụ quản lý** tùy chọn xử lý đăng nhập tài khoản, proxy tìm kiếm web và quy trình OAuth thông qua các connector của Composio. Bạn hoàn toàn có thể từ bỏ mọi thứ và chạy 100% cục bộ — nhưng lớp dịch vụ quản lý giúp việc bắt đầu với các tích hợp bên thứ ba thực sự không gặp trở ngại.

```bash
# Kiểm tra kích thước và cấu trúc Memory Tree của bạn
# Mọi dữ liệu đều là Markdown thuần — grep, ripgrep, Obsidian đều dùng được
find ~/.openhuman/vault -name '*.md' | wc -l
# Ví dụ: 847 tệp markdown trên 12 thư mục dự án

# Xem chỉ mục Memory Tree
cat ~/.openhuman/vault/_index.md
# Chứa các tham chiếu chéo tự động giữa các ghi nhớ
```

## Cài đặt & Thiết lập

OpenHuman là một ứng dụng desktop được phân phối thông qua các trình quản lý gói gốc — **không có npm, không có pip, không có Docker**. Đây là ứng dụng dựa trên Tauri, có gói chính thức cho macOS, Linux và Windows.

### macOS (Homebrew) — Được khuyến nghị

```bash
# Add repo chính thức và cài đặt
brew tap tinyhumansai/core
brew install openhuman

# Xác nhận cài đặt
openhuman --version
# Output: OpenHuman v0.12.x (build date, Rust backend)

# Khởi chạy từ terminal hoặc Spotlight
openhuman
```

### Linux (Debian/Ubuntu) — Kho APT Chính thức

```bash
# Thêm khóa GPG và kho lưu trữ APT
sudo apt-get install -y --no-install-recommends gnupg2 curl ca-certificates
curl -fsSL https://tinyhumansai.github.io/openhuman/apt/KEY.gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/openhuman.gpg
echo "deb [signed-by=/etc/apt/keyrings/openhuman.gpg arch=amd64] \
  https://tinyhumansai.github.io/openhuman/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/openhuman.list
sudo apt-get update
sudo apt-get install -y openhuman

# Xác nhận
openhuman --version
```

### Linux (Arch Linux — AUR)

```bash
# Recipe openhuman-bin AUR nằm ngay trong repo
# Sau khi đã publish lên AUR:
yay -S openhuman-bin
```

### Windows

Tải bộ cài đặt MSI từ [trang GitHub Releases](https://github.com/tinyhumansai/openhuman/releases/latest) hoặc từ [tinyhumans.ai](https://tinyhumans.ai/openhuman). Bộ cài đặt bao gồm cập nhật tự động thông qua trình cập nhật tích hợp sẵn.

```powershell
# Sau khi cài đặt, xác nhận từ PowerShell
openhuman --version
```

> **Lưu ý quan trọng**: OpenHuman hiện đang trong giai đoạn **beta sớm**. Vẫn còn một số vấn đề nhỏ. Các tính năng cốt lõi (Memory Tree, định tuyến mô hình, tích hợp cơ bản) đã ổn định, nhưng một số trigger theo thời gian thực và tính năng lưu trữ vẫn yêu cầu backend quản lý.

## Tích hợp với các công cụ phổ biến

118+ tích hợp của OpenHuman là tính năng nổi bật nhất. Thay vì phải cấu hình OAuth thủ công cho từng dịch vụ, bạn chỉ cần đăng nhập một lần qua lớp quản lý của OpenHuman và có quyền truy cập vào một API thống nhất.

### Tích hợp GitHub

```bash
# Cấu hình tích hợp GitHub
# OpenHuman tự động tải cấu trúc repo vào Memory Tree mỗi 20 phút
openhuman configure github --repo tinyhumansai/openhuman

# Sau khi thiết lập, hãy hỏi OpenHuman về bất kỳ tệp nào trong repo
# "Indexer của Memory Tree hoạt động như thế nào?"
# → OpenHuman đọc cấu trúc repo từ cache cục bộ
#   và đưa ra câu trả lời chính xác, không cần tìm kiếm web
```

### Tương thích với Obsidian

Vì Memory Tree là một kho lưu trữ Markdown tiêu chuẩn, nó hoạt động liền mạch với Obsidian:

```bash
# Mở Memory Tree của bạn trong Obsidian
# Toàn bộ lịch sử trò chuyện AI đã có sẵn dưới dạng ghi chú
# Bạn có thể tìm kiếm, liên kết và tổ chức giống như các ghi chú thông thường

# Xác nhận cấu trúc kho lưu trữ
tree ~/.openhuman/vault --dirsfirst
# Output:
# .openhuman/vault/
# ├── _index.md
# ├── projects/
# │   ├── project-alpha/
# │   │   ├── context.md
# │   │   ├── decisions.md
# │   │   └── references.md
# └── workflows/
#     ├── coding-patterns.md
#     └── design-decisions.md
```

### Lớp Connector Composio

Composio cung cấp khung tích hợp dựa trên OAuth:

```bash
# Liệt kê các connector Composio có sẵn
openhuman integrations list

# Bật connector mới
openhuman integrations enable notion --scope write

# Kiểm tra connector đang hoạt động
openhuman integrations status
# Output: 23/118 connectors active
#   GitHub ✓ | Slack ✓ | Notion ✓ | Figma ✗ | Jira ✗
```

### Định tuyến mô hình với nhiều nhà cung cấp

```bash
# Cấu hình thứ tự mô hình ưu tiên
openhuman config models \
  --primary gpt-4o \
  --fallback claude-sonnet-4 \
  --economy claude-haiku \
  --local ollama/llama3.2

# Ví dụ tỷ lệ nén TokenJuice
# Không nén: 8.420 tokens
# Với TokenJuice: 1.890 tokens (giảm 77,5%)
# Tác động đến độ chính xác: <2% trên các bài kiểm tra chuẩn
```

## Kiểm định & Hiệu năng thực tế

### Hiệu quả của Memory Tree

Trong các bài kiểm tra, Memory Tree của OpenHuman cho thấy sự cải thiện đo lường được về độ chính xác ngữ cảnh theo thời gian:

|| Chỉ số | Tuần 1 | Tuần 4 | Tuần 8 |
||
