---
title: "JustHireMe：AI Giúp Bạn Tự Động Tìm Việc, Từ Gửi Hồ Sơ Đến Nhận Offer"
description: "Đánh giá JustHireMe - bàn làm việc thông minh AI mã nguồn mở cho việc tìm kiếm việc làm. Hệ thống tình báo việc làm ưu tiên cục bộ, tự động thu thập vị trí, đánh giá mức độ phù hợp AI, tạo hồ sơ và thư xin việc tùy chỉnh."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - JavaScript
  - Python
  - TypeScript
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "50.9 MB"
file_md5: ""
download_url: "https://github.com/vasu-devs/JustHireMe.git"
backup_url: ""
github_repo: "https://github.com/vasu-devs/JustHireMe.git"
stars: 1749
maintainer: "vasu-devs"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /vi/posts/justhireme-ai-job-search-workbench/
faqs:
  - q: 'JustHireMe có miễn phí và mã nguồn mở không?'
    a: 'Có. JustHireMe là phần mềm mã nguồn mở theo giấy phép MIT, không có phí đăng ký hay chi phí ẩn. Bạn là chủ sở hữu toàn bộ hồ sơ và dữ liệu của mình, và thuật toán chấm điểm hoàn toàn minh bạch.'
  - q: 'JustHireMe có yêu cầu API key AI hoặc gửi dữ liệu của tôi lên đám mây không?'
    a: 'Không. JustHireMe hoạt động theo nguyên tắc ưu tiên cục bộ: toàn bộ tính toán AI chạy ngay trên máy của bạn mà không cần API key, và dữ liệu được lưu trữ trong cơ sở dữ liệu SQLite trên máy tính của bạn thay vì tải lên đám mây.'
  - q: 'JustHireMe có thể thu thập tin tuyển dụng từ những nền tảng nào?'
    a: 'Nó tự động tổng hợp việc làm từ LinkedIn, Indeed, Glassdoor, AngelList, Hacker News, trang tuyển dụng của các công ty và các mục việc làm từ xa. Thuật toán loại trùng sẽ tự động gộp cùng một vị trí khi nó xuất hiện trên nhiều nền tảng khác nhau.'
  - q: 'Điểm số khớp việc làm của JustHireMe hoạt động như thế nào?'
    a: 'Công cụ sử dụng khả năng hiểu ngữ nghĩa thay vì so khớp từ khóa, đối chiếu kỹ năng, kinh nghiệm, kỳ vọng lương và mục tiêu nghề nghiệp của bạn với yêu cầu của từng vị trí. Mỗi tin tuyển dụng nhận điểm từ 0-100, giúp bạn tập trung vào các vị trí đạt trên 80 điểm.'
  - q: 'JustHireMe được xây dựng trên nền tảng công nghệ nào?'
    a: 'Ứng dụng desktop sử dụng Tauri 2 kết hợp React 19 và TypeScript; phần backend chạy Python 3.13 với FastAPI và WebSockets; dữ liệu được lưu trong SQLite cùng cơ sở dữ liệu đồ thị Kuzu và kho vector LanceDB; và Playwright đảm nhiệm tự động hóa trình duyệt cho việc thu thập dữ liệu và nộp đơn.'
---
{</* resource-info */>}

## Vấn Đề: Tìm Việc Là Một Công Việc Toàn Thời Gian

Gửi 100 hồ sơ, nhận 2 phỏng vấn, 0 Offer. Đây không phải lỗi của bạn, là lỗi của hệ thống.

Mỗi trang web tuyển dụng là một hòn đảo:
- **LinkedIn**: Tìm kiếm nâng cao phải trả phí
- **Indeed**: Vị trí trùng lặp, thông tin hết hạn
- **Glassdoor**: Dữ liệu lương chậm cập nhật
- **Website công ty**: Mỗi nơi phải điền lại từ đầu
- **Email tuyển dụng**: 99% đọc xong không trả lời

Đau khổ hơn: Mỗi lần gửi phải **viết lại hồ sơ**, **viết lại thư xin việc**, **nghiên cứu lại công ty**.

## Giải Pháp: JustHireMe

**JustHireMe** là bàn làm việc thông minh AI mã nguồn mở cho việc tìm kiếm việc làm. Ưu tiên cục bộ, bảo mật riêng tư, một cú click tự động gửi.

**Triết lý cốt lõi**: Để AI làm việc lặp đi lặp lại, bạn chỉ đưa ra quyết định.

## Chức Năng Chính

### 1. Thu Thập Vị Trí Thông Minh

Tự động thu thập vị trí từ nhiều nền tảng:
- LinkedIn, Indeed, Glassdoor
- AngelList, Hacker News
- Trang tuyển dụng của công ty
- Khu vực làm việc từ xa

**Thuật toán loại bỏ trùng lặp**: Cùng một vị trí xuất hiện trên các nền tảng khác nhau, tự động gộp lại.

### 2. Đánh Giá Mức Độ Phù Hợp AI

Không phải ghép từ khóa, mà là **hiểu ngữ nghĩa thực sự**:
- Kỹ năng của bạn vs yêu cầu vị trí
- Kinh nghiệm của bạn vs cấp độ vị trí
- Mong đợi lương của bạn vs ngân sách
- Mục tiêu nghề nghiệp của bạn vs hướng công ty

Điểm số 0-100, chỉ xem vị trí từ 80 điểm trở lên.

### 3. Tùy Chỉnh Hồ Sơ Tự Động

**Viết lại hồ sơ** cho từng vị trí:
- Làm nổi bật kỹ năng liên quan
- Điều chỉnh mô tả dự án
- Ghép từ khóa
- Tối ưu hóa bố cục

Không phải điền mẫu, mà là **viết lại AI thực sự**.

### 4. Tạo Thư Xin Việc

Mỗi thư xin việc là **duy nhất**:
- Nghiên cứu bối cảnh công ty
- Trích dẫn dự án cụ thể
- Trình bày kinh nghiệm liên quan
- Bày tỏ sự quan tâm chân thành

HR có thể phân biệt mẫu và bài viết tâm huyết.

### 5. Quản Lý CRM Cục Bộ

Tất cả dữ liệu lưu trữ cục bộ:
- Cơ sở dữ liệu SQLite
- Lịch sử vị trí
- Theo dõi trạng thái gửi hồ sơ
- Quản lý lịch phỏng vấn

**Ưu tiên riêng tư**: Dữ liệu của bạn không tải lên đám mây.

## Kiến Trúc Công Nghệ

| Tầng | Công Nghệ |
|------|-----------|
| Desktop | Tauri 2 + React 19 + TypeScript |
| Backend | Python 3.13 + FastAPI + WebSockets |
| Cơ sở dữ liệu | SQLite + Kuzu Graph DB + LanceDB Vector DB |
| Mô hình AI | LLM cục bộ + Tìm kiếm ngữ nghĩa |
| Tự động hóa | Playwright tự động hóa trình duyệt |

**Ưu tiên cục bộ**: Tất cả tính toán AI hoàn thành cục bộ, không cần API Key.

## Cài Đặt Và Sử Dụng

```bash
# Clone kho lưu trữ
git clone https://github.com/vasu-devs/JustHireMe.git
cd JustHireMe

# Cài đặt phụ thuộc frontend
npm install

# Khởi động máy chủ phát triển
npm run dev

# Khởi động ứng dụng desktop
npm run tauri dev
```

## Quy Trình Sử Dụng

1. **Thiết lập hồ sơ**: Tải lên hồ sơ, điền kỹ năng và mục tiêu
2. **Cấu hình nguồn thu thập**: Chọn nền tảng tuyển dụng để giám sát
3. **Chạy thu thập**: AI tự động thu thập vị trí mới nhất
4. **Xem phù hợp**: Sắp xếp theo điểm phù hợp, lọc vị trí cao điểm
5. **Gửi một cú click**: AI tạo tài liệu tùy chỉnh, tự động gửi
6. **Theo dõi tiến độ**: CRM quản lý tất cả trạng thái đơn xin việc

## Tại Sao Mã Nguồn Mở?

Tìm việc không nên bị độc quyền bởi nền tảng:
- **Quyền sở hữu dữ liệu**: Hồ sơ của bạn, dữ liệu của bạn
- **Thuật toán minh bạch**: Biết AI đánh giá như thế nào
- **Sử dụng miễn phí**: Không phí đăng ký, không chi phí ẩn
- **Cộng đồng thúc đẩy**: Mọi người cùng cải thiện

## Phù Hợp Với Ai?

- **Người tìm việc**: Muốn gửi nhiều hơn, tốt hơn, nhanh hơn
- **Freelancer**: Tìm hợp đồng và dự án
- **Người chuyển ngành**: Cần hồ sơ tùy chỉnh
- **Sinh viên mới tốt nghiệp**: Không biết bắt đầu từ đâu
- **Chuyên gia cao cấp**: Muốn nhận cơ hội chất lượng một cách thụ động

## Bài Viết Liên Quan

- [Agent Reach：Biến AI Agent thành bậc thầy Internet chỉ với một cú click](/vi/resources/llm-frameworks/agent-reach-ai-agent-internet-access/)
- [Free Claude Code：Sử dụng Claude Code miễn phí](/vi/resources/ai-tools/free-claude-code-open-source-proxy/)
- [OpenClaw 42 trường hợp sử dụng thực tế：AI Agent đã thay đổi cuộc sống của chúng ta như thế nào](/vi/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/)

---

**Địa chỉ dự án**: [github.com/vasu-devs/JustHireMe](https://github.com/vasu-devs/JustHireMe)

**Stars**: 471 ⭐ | **Forks**: 91 | **Ngôn ngữ**: Python 47.3%, TypeScript 27.5%

---

## Công Cụ Đề Xuất

Cho developer xây dựng hoặc triển khai công cụ AI mã nguồn mở:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 tín dụng miễn phí cho người dùng mới, 14+ region toàn cầu, droplet GPU/CPU một-cú-click cho AI workload.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Proxy Anthropic Claude / OpenAI / DeepSeek API. Hầu hết AI tool ở trên (chatbot, code gen, translation, search, v.v.) cần LLM API key — proxy này cho access ổn định top model với ~30% giá chính thức.
- **{{< aff "hostinger" "footer-cta-legacy" "Hostinger" >}}** — Lựa chọn VPS giá tốt cho thị trường Việt Nam.

*Affiliate link — không tăng chi phí của bạn nhưng giúp dibi8.com duy trì hoạt động.*

