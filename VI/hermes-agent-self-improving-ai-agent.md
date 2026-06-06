---
title: Hermes Agent：AI Agent tự tiến hóa, càng dùng càng hiểu bạn
description: Hermes Agent là tác nhân AI mã nguồn mở của Nous Research, có vòng lặp
  học tập tích hợp — tạo kỹ năng từ kinh nghiệm, cải thiện liên tục, ghi nhớ sở thích
  của bạn.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Docker
- Python
- TypeScript
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "210.6 MB"
file_md5: ''
download_url: https://github.com/NousResearch/hermes-agent
backup_url: ''
github_repo: https://github.com/NousResearch/hermes-agent
stars: 156248
maintainer: "NousResearch"
last_maintained: "2026-05-16"
featureImage: ''
draft: false
aliases:
- /vi/posts/genericagent-self-evolving-ai-agent.vi/
- /vi/posts/hermes-agent-self-improving-ai-agent/
faqs:
  - q: 'Hermes Agent khác gì so với các công cụ như Claude Code, Cursor hay GitHub Copilot?'
    a: 'Hermes Agent có sẵn vòng lặp tự học, bộ nhớ bền vững xuyên suốt các phiên làm việc, và một hệ thống kỹ năng mà không công cụ nào trong số đó cung cấp. Nó cũng chạy được trên 6 nền tảng nhắn tin, hỗ trợ lập lịch cron và MCP, đồng thời là mã nguồn mở và có thể tự lưu trữ; trong khi những công cụ kia chỉ giới hạn ở CLI, máy tính để bàn hoặc IDE, và thu phí thuê bao hoặc phí API.'
  - q: 'Vòng lặp tự cải thiện của Hermes Agent hoạt động như thế nào?'
    a: 'Sau khi hoàn thành một tác vụ, Hermes phân tích điều gì đã hiệu quả và điều gì không, trích xuất các mẫu có thể tái sử dụng, tạo một tệp kỹ năng ghi lại cách tiếp cận đó, kiểm thử kỹ năng ấy trên các tác vụ tương tự, rồi tinh chỉnh dựa trên kết quả. Theo thời gian, điều này xây dựng nên một thư viện kỹ năng cá nhân riêng biệt cho từng người dùng.'
  - q: 'Hermes Agent lưu giữ loại bộ nhớ nào giữa các phiên làm việc?'
    a: 'Hermes duy trì hai loại bộ nhớ: Bộ nhớ Hồ sơ Người dùng (phong cách lập trình, các dự án, công cụ ưa thích, sở thích giao tiếp và các lỗi thường gặp) và Bộ nhớ Phiên (ngữ cảnh dự án hiện tại, các lệnh và kết quả gần đây, cùng các tệp đã chỉnh sửa). Bộ nhớ hồ sơ vẫn được giữ lại ngay cả sau khi bạn khởi động lại máy tính.'
  - q: 'Hermes Agent có thể chạy trên những nền tảng nhắn tin nào?'
    a: 'Hermes Agent hoạt động như một bot nhắn tin đa nền tảng trên Telegram, Discord, Slack, WhatsApp, Signal và Email, tất cả đều được cấu hình thông qua lệnh `hermes gateway setup`. Cùng một bộ lệnh và kỹ năng đều hoạt động trên mọi nền tảng.'
  - q: 'Làm thế nào để cài đặt Hermes Agent và cấu hình nhà cung cấp LLM?'
    a: 'Trên Linux, macOS hoặc WSL2, bạn có thể cài đặt bằng một script curl một dòng đưa qua bash, hoặc clone repo rồi chạy `./setup-hermes.sh`. Sau đó bạn thiết lập nhà cung cấp bằng các lệnh như `hermes config set provider openai` và `hermes config set model gpt-4o`, hoặc dùng một mô hình cục bộ qua `hermes config set provider ollama`.'
---
{</* resource-info */>}

## Vấn đề: Hầu hết các tác nhân AI đều quên bạn

Bạn dành hàng giờ dạy trợ lý AI về quy trình làm việc, phong cách lập trình, cấu trúc dự án của bạn. Sau đó bạn bắt đầu một phiên mới — và tất cả đều biến mất. Tác nhân đối xử với bạn như một người lạ mỗi lần.

Đây là hạn chế cơ bản của hầu hết các tác nhân AI ngày nay: **không có bộ nhớ, không có học tập, không có sự phát triển**. Chúng được thiết kế không trạng thái, khiến chúng trở thành công cụ mạnh mẽ nhưng là đối tác dài hạn tồi tệ.

**Hermes Agent** giải quyết vấn đề này bằng một cách tiếp cận triệt để: đây là tác nhân duy nhất có vòng lặp học tập tích hợp.

## Hermes Agent là gì?

[Hermes Agent](https://github.com/NousResearch/hermes-agent) là tác nhân AI mã nguồn mở được tạo bởi [Nous Research](https://nousresearch.com) — chính là đội ngũ đằng sau dòng LLM mã nguồn mở Hermes. Với **136.579+ sao** trên GitHub và **20.960+ fork**, đây là một trong những khung tác nhân AI phổ biến nhất hiện có.

Slogan của dự án nói lên tất cả: **"Tác nhân phát triển cùng bạn."**

Không giống như các tác nhân khác là công cụ tĩnh, Hermes Agent:
- **Tạo kỹ năng từ kinh nghiệm** — học quy trình làm việc của bạn và lưu chúng thành kỹ năng có thể tái sử dụng
- **Cải thiện kỹ năng trong quá trình sử dụng** — tinh chỉnh khả năng dựa trên phản hồi
- **Duy trì kiến thức xuyên suốt các phiên** — nhớ bạn là ai và bạn thích gì
- **Xây dựng mô hình sâu sắc về bạn** — càng sử dụng nhiều, nó càng hiểu bạn hơn

## Tính năng chính

### 1. Vòng lặp học tập tích hợp

Đổi mới cốt lõi của Hermes Agent là **chu kỳ tự cải thiện**:

```
Kinh nghiệm → Suy ngẫm → Tạo kỹ năng → Thực hành → Cải thiện
```

Khi bạn hoàn thành một tác vụ với Hermes, nó sẽ:
1. **Phân tích** điều gì hiệu quả và điều gì không
2. **Trích xuất** các mẫu có thể tái sử dụng
3. **Tạo** tệp kỹ năng ghi lại phương pháp
4. **Kiểm tra** kỹ năng trên các tác vụ tương tự
5. **Tinh chỉnh** dựa trên kết quả

Theo thời gian, điều này tạo ra một **thư viện kỹ năng cá nhân** độc đáo cho bạn.

### 2. 40+ công cụ tích hợp

Hermes Agent đi kèm với bộ công cụ toàn diện:

| Danh mục công cụ | Ví dụ |
|-------------|---------|
| **Thao tác tệp** | Đọc, ghi, tìm kiếm, so sánh, vá |
| **Terminal** | Thực thi lệnh, phiên shell, tác vụ nền |
| **Web** | Duyệt, thu thập, tải xuống, gọi API |
| **Mã nguồn** | Kiểm tra cú pháp, lint, định dạng, kiểm tra |
| **Git** | Commit, nhánh, diff, log, xem xét PR |
| **Hệ thống** | Quản lý tiến trình, giám sát tệp, cron |

**Hệ thống toolset** cho phép bạn chỉ bật các công cụ cần thiết, giảm mức sử dụng token và cải thiện sự tập trung.

### 3. Hệ thống kỹ năng (Bộ nhớ thủ tục)

Kỹ năng là vũ khí bí mật của Hermes Agent. Chúng là **tệp thủ tục có thể tái sử dụng** ghi lại:

- **Điều kiện kích hoạt** — khi nào sử dụng kỹ năng này
- **Hướng dẫn từng bước** — phải làm gì
- **Cạm bẫy** — những sai lầm phổ biến cần tránh
- **Bước xác minh** — cách xác nhận thành công

Kỹ năng có thể:
- **Tự động tạo** từ các lần hoàn thành tác vụ thành công
- **Tải từ Skills Hub** — kỹ năng do cộng đồng đóng góp
- **Viết thủ công** cho quy trình làm việc cụ thể của bạn
- **Chia sẻ** với người dùng khác

### 4. Bộ nhớ lâu dài

Hermes Agent duy trì **hai loại bộ nhớ**:

**Bộ nhớ hồ sơ người dùng**:
- Phong cách lập trình ưa thích của bạn
- Các dự án bạn đang làm việc
- Công cụ bạn thích
- Sở thích giao tiếp
- Lỗi phổ biến bạn mắc phải (để nó có thể bắt chúng)

**Bộ nhớ phiên**:
- Ngữ cảnh dự án hiện tại
- Lệnh và đầu ra gần đây
- Tệp bạn đang chỉnh sửa
- Cuộc trò chuyện từ phiên này

Bộ nhớ này tồn tại xuyên suốt các phiên, vì vậy Hermes **nhớ bạn** ngay cả sau khi bạn khởi động lại máy tính.

### 5. Cổng tin nhắn

Hermes Agent không chỉ là công cụ CLI — nó là **bot tin nhắn đa nền tảng**:

| Nền tảng | Thiết lập | Trường hợp sử dụng |
|---------|-------|---------|
| **Telegram** | `hermes gateway setup` | Trợ lý AI di động |
| **Discord** | `hermes gateway setup` | Cộng tác nhóm |
| **Slack** | `hermes gateway setup` | Tích hợp nơi làm việc |
| **WhatsApp** | `hermes gateway setup` | Trợ lý cá nhân |
| **Signal** | `hermes gateway setup` | Tập trung vào quyền riêng tư |
| **Email** | `hermes gateway setup` | Quy trình không đồng bộ |

Sau khi cấu hình, bạn có thể trò chuyện với Hermes từ bất kỳ nền tảng nào trong số này bằng cách sử dụng cùng các lệnh và kỹ năng.

### 6. Tích hợp MCP

Hermes Agent hỗ trợ **Giao thức ngữ cảnh mô hình (MCP)**, cho phép nó kết nối với bất kỳ máy chủ MCP nào để có khả năng mở rộng:

- **Máy chủ cơ sở dữ liệu** — truy vấn cơ sở dữ liệu SQL
- **Máy chủ tệp** — truy cập hệ thống tệp từ xa
- **Máy chủ API** — tương tác với bất kỳ REST API nào
- **Máy chủ tùy chỉnh** — xây dựng tích hợp của riêng bạn

Điều này làm cho Hermes có khả năng mở rộng vô hạn — nếu bạn có thể xây dựng máy chủ MCP, Hermes có thể sử dụng nó.

### 7. Lập lịch Cron

Hermes Agent có thể chạy **tác vụ đã lên lịch** thông qua hệ thống cron tích hợp:

```bash
# Chạy một kỹ năng mỗi ngày lúc 9 giờ sáng
hermes cron add --skill "daily-report" --schedule "0 9 * * *"

# Chạy sao lưu mỗi tuần
hermes cron add --skill "backup-database" --schedule "0 2 * * 0"

# Liệt kê tất cả các tác vụ đã lên lịch
hermes cron list
```

Hoàn hảo cho các quy trình tự động cần chạy theo lịch trình.

### 8. Tính năng bảo mật

Hermes Agent coi trọng bảo mật:

- **Phê duyệt lệnh** — các lệnh rủi ro cần xác nhận rõ ràng
- **Ghép nối DM** — xác minh danh tính của bạn trước các thao tác nhạy cảm
- **Cách ly container** — chạy mã không đáng tin cậy trong môi trường cách ly
- **Ghi nhật ký kiểm toán** — tất cả hành động được ghi lại để xem xét

## Bắt đầu nhanh

### Cài đặt

```bash
# Cài đặt một dòng (Linux, macOS, WSL2)
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# Hoặc clone và thiết lập thủ công
git clone https://github.com/NousResearch/hermes-agent.git
cd hermes-agent
./setup-hermes.sh
```

### Cuộc trò chuyện đầu tiên

```bash
source ~/.bashrc    # tải lại shell
hermes              # bắt đầu trò chuyện
```

### Cấu hình nhà cung cấp

```bash
# Đặt nhà cung cấp LLM ưa thích của bạn
hermes config set provider openai
hermes config set model gpt-4o

# Hoặc sử dụng mô hình cục bộ
hermes config set provider ollama
hermes config set model llama3.1
```

### Các lệnh hữu ích

```bash
# Bắt đầu cuộc trò chuyện mới
/new

# Thay đổi mô hình ngay lập tức
/model anthropic:claude-3-5-sonnet

# Đặt tính cách
/personality developer

# Kiểm tra mức sử dụng
/usage

# Duyệt các kỹ năng có sẵn
/skills

# Sử dụng một kỹ năng cụ thể
/hugo-blog-deploy

# Nén ngữ cảnh để tiết kiệm token
/compress
```

## Kiến trúc

Hermes Agent được xây dựng với kiến trúc mô-đun:

```
Hermes Agent
├── Giao diện CLI (UI terminal)
├── Cổng tin nhắn (Telegram, Discord, v.v.)
├── Lõi tác nhân (công cụ suy luận)
├── Hệ thống kỹ năng (bộ nhớ thủ tục)
├── Kho lưu trữ bộ nhớ (lưu trữ lâu dài)
├── Trình quản lý toolset (40+ công cụ)
├── Máy khách MCP (tích hợp bên ngoài)
├── Bộ lập lịch Cron (tác vụ tự động)
└── Lớp bảo mật (phê duyệt, cách ly)
```

Toàn bộ hệ thống được viết bằng **Python** (28M+ dòng) với các thành phần TypeScript cho giao diện web.

## Trường hợp sử dụng

### Dành cho nhà phát triển
- **Trợ lý xem xét mã** — Hermes học cơ sở mã của bạn và xem xét PR
- **Tự động hóa DevOps** — Triển khai, giám sát và khắc phục sự cố cơ sở hạ tầng
- **Trình tạo tài liệu** — Tự động tạo tài liệu từ chú thích mã
- **Thợ săn lỗi** — Tìm kiếm các mẫu gây ra lỗi trong quá khứ

### Dành cho nhóm
- **Thư viện kỹ năng chia sẻ** — Thực tiễn tốt nhất của nhóm dưới dạng kỹ năng có thể tái sử dụng
- **Máy gia tốc onboarding** — Thành viên nhóm mới có quyền truy cập ngay lập tức vào kiến thức nhóm
- **Vận hành 24/7** — Các công việc cron xử lý bảo trì thường ngày
- **Truy cập đa nền tảng** — Trò chuyện với Hermes từ Slack, Discord hoặc Telegram

### Dành cho người dùng nâng cao
- **Cơ sở kiến thức cá nhân** — Hermes ghi nhớ mọi thứ bạn dạy nó
- **Tự động hóa quy trình** — Các tác vụ phức tạp nhiều bước trở thành một lệnh
- **Trợ lý đa nền tảng** — Cùng một trợ lý trên máy tính để bàn, di động và web
- **Tích hợp tùy chỉnh** — Xây dựng máy chủ MCP cho các công cụ cụ thể của bạn

## So sánh hiệu suất

| Tính năng | Hermes Agent | Claude Code | Cursor | GitHub Copilot |
|---------|-------------|-----------|--------|----------------|
| **Tự học** | ✅ Có | ❌ Không | ❌ Không | ❌ Không |
| **Bộ nhớ lâu dài** | ✅ Có | ❌ Không | ❌ Không | ❌ Không |
| **Hệ thống kỹ năng** | ✅ Có | ❌ Không | ❌ Không | ❌ Không |
| **Đa nền tảng** | ✅ 6 nền tảng | ❌ Chỉ CLI | ❌ Chỉ desktop | ❌ Chỉ IDE |
| **Mã nguồn mở** | ✅ Có | ❌ Không | ❌ Không | ❌ Không |
| **Lập lịch Cron** | ✅ Có | ❌ Không | ❌ Không | ❌ Không |
| **Hỗ trợ MCP** | ✅ Có | ❌ Không | ❌ Không | ❌ Không |
| **Miễn phí** | ✅ Tự lưu trữ | 💰 Chi phí API | 💰 Đăng ký | 💰 Đăng ký |

## Hạn chế

- **Đường cong học tập** — Hệ thống kỹ năng cần đầu tư trước
- **Thiết lập cục bộ** — Tự lưu trữ cần kiến thức kỹ thuật
- **Sử dụng tài nguyên** — Bộ nhớ lâu dài tiêu thụ dung lượng lưu trữ theo thời gian
- **Chi phí nhà cung cấp** — Cuộc gọi API LLM vẫn tốn tiền (trừ khi sử dụng mô hình cục bộ)

## Kết luận

Hermes Agent đại diện cho một **sự chuyển đổi cơ bản** trong cách chúng ta nghĩ về trợ lý AI. Thay vì coi AI là công cụ dùng một lần, Hermes coi nó là **đối tác dài hạn phát triển cùng bạn**.

Vòng lặp tự cải thiện, bộ nhớ lâu dài và hệ thống kỹ năng tạo ra hiệu ứng gộp: bạn càng sử dụng Hermes nhiều, nó càng có giá trị. Điều này ngược lại hoàn toàn với các công cụ AI truyền thống mang lại lợi nhuận giảm dần theo thời gian.

Nếu bạn đã chán việc dạy lại trợ lý AI của mình những điều tương tự trong mỗi phiên, Hermes Agent đáng để khám phá.

**GitHub**: [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)  
**Tài liệu**: [hermes-agent.nousresearch.com/docs](https://hermes-agent.nousresearch.com/docs/)  
**Sao**: 136.579+ | **Fork**: 20.960+ | **Giấy phép**: Mã nguồn mở  

Bạn đã thử Hermes Agent chưa? Bạn có kinh nghiệm gì với các tác nhân AI tự cải thiện? Chia sẻ suy nghĩ của bạn trong phần bình luận.

## Bài viết liên quan

- [Agent Reach: Truy cập Internet cho tác nhân AI](/vi/resources/llm-frameworks/agent-reach-ai-agent-internet-access/)
- [Free Claude Code: Công cụ proxy mã nguồn mở để sử dụng Claude Code CLI miễn phí](/vi/resources/ai-tools/free-claude-code-open-source-proxy/)
- [OpenClaw 42 trường hợp sử dụng thực tế: Tác nhân AI đã thay đổi cuộc sống của chúng ta](/vi/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/)

---

## Hạ Tầng Đề Xuất Cho Tự Lưu Trữ

Để chạy stack này 24/7 ổn định, lựa chọn hạ tầng rất quan trọng:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 tín dụng miễn phí 60 ngày, 14+ region toàn cầu. Lựa chọn mặc định cho developer độc lập.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — VPS Hong Kong, độ trễ thấp với người dùng Việt Nam. dibi8.com cũng được host ở đây.
- **{{< aff "hostinger" "footer-cta-legacy" "Hostinger" >}}** — Lựa chọn VPS giá tốt cho thị trường Việt Nam, giảm 60% gói đầu tiên.

*Đây là affiliate link, không phát sinh chi phí thêm cho bạn nhưng giúp dibi8.com duy trì hoạt động.*

