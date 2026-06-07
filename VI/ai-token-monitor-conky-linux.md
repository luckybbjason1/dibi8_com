---
title: 'AI Token Monitor: Theo dõi hạn ngạch Claude, Gemini, Grok, Kimi trực tiếp trên Linux'
description: 'Widget desktop Linux mã nguồn mở hiển thị hạn ngạch AI token theo thời gian thực bằng thanh tiến trình kiểu HP bar trong Conky. Hỗ trợ Claude, Gemini, Grok, Kimi với polling API thực và đếm ngược reset.'
date: 2026-06-06 00:00:00+08:00
lastmod: 2026-06-06 00:00:00+08:00
tech_stack: ['Python', 'Conky', 'Linux']
application_domain: Dev Utils
source_version: '1.0.0'
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'luckybbjason1/ai-token-monitor'
stars: 0
maintainer: 'luckybbjason1'
last_maintained: '2026-06-06'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['AI token monitor', 'Claude hạn ngạch', 'Gemini quota tracker', 'Grok token', 'Kimi API', 'Conky widget', 'Linux desktop', 'mã nguồn mở', 'Python', 'công cụ developer']
aliases:
- /vi/posts/ai-token-monitor-conky-linux/
faqs:
  - q: 'AI Token Monitor có hoạt động trên macOS hoặc Windows không?'
    a: 'Hiện tại lớp hiển thị widget phụ thuộc vào Conky chỉ dành cho Linux. Các script Python cốt lõi (api_fetcher.py) chạy trên mọi hệ điều hành, nhưng kết xuất hình ảnh cần Conky. Repository có phiên bản đa nền tảng dựa trên tkinter (monitor.py) nhưng cửa sổ không viền có thể không hiển thị trên GNOME — đây là tính năng thử nghiệm.'
  - q: 'Công cụ đọc số dư token Claude API như thế nào?'
    a: 'Gửi POST request tối thiểu tới /v1/messages với max_tokens=1 và đọc các header phản hồi anthropic-ratelimit-tokens-remaining cùng anthropic-ratelimit-tokens-limit. Mỗi lần kiểm tra tiêu thụ khoảng 10 input token, cron 5 phút một lần tốn khoảng 2.880 token/ngày — không đáng kể với hầu hết gói.'
  - q: 'Lưu API key trong ~/.config/.ai_monitor_keys có an toàn không?'
    a: 'File được tạo với chmod 600, chỉ user hiện tại mới đọc được. Được loại trừ khỏi git qua .gitignore. Mức độ bảo mật tương đương lưu trong file .env — đều dựa vào quyền hệ thống file. Với máy dùng chung, nên mã hóa bằng gpg-agent hoặc secret manager.'
  - q: 'Có thể thêm dịch vụ AI tùy chỉnh chưa có trong danh sách (ví dụ Mistral, Together AI) không?'
    a: 'Có. Trong api_fetcher.py, thêm block gọi API dịch vụ của bạn và ghi vào cache dict với các key ok (bool), label (chuỗi hiển thị) và tùy chọn pct (float 0-1). Sau đó thêm tên dịch vụ và giá trị reset_h vào danh sách SERVICES trong conky_ai.py.'
  - q: 'Tại sao Grok hiển thị "耗尽" (hết) dù tài khoản còn số dư?'
    a: 'Kiểm tra Grok gọi GET /v1/models — trả về 200 khi xác thực hợp lệ và còn số dư, 403 khi hết số dư. Mã 403 từ xAI đặc biệt có nghĩa là số dư tài khoản bằng 0. Nếu còn số dư mà vẫn thấy 403, hãy kiểm tra lại API key trong ~/.config/.ai_monitor_keys.'
---

{{< resource-info >}}

## Vấn đề: Quản lý sáu dịch vụ AI cùng lúc mà không biết cái nào đã hết hạn ngạch

Các developer hiện đại sử dụng đồng thời 4 đến 8 dịch vụ AI — Claude cho lập luận phức tạp, Gemini phân tích ngữ cảnh dài, Grok lấy dữ liệu web thời gian thực, Kimi xử lý tài liệu lớn. Mỗi dịch vụ có dashboard hạn ngạch riêng, lịch reset riêng và trang thanh toán riêng.

Kết quả: bạn vào rate limit giữa chừng công việc, mất 5 phút chuyển tab trình duyệt, phát hiện hạn ngạch miễn phí của Gemini reset vào UTC nửa đêm (không phải nửa đêm giờ địa phương của bạn), rồi lãng phí thêm 10 phút debug tại sao Kimi trả về 429.

**AI Token Monitor** giải quyết điều này bằng một widget desktop luôn hiển thị — không cần rời khỏi trình soạn thảo, một cái nhìn là biết trạng thái mọi dịch vụ.

```
● Claude  ░░░░░░░░░  Không có số dư
● Gemini  ░░░░░░░░░  Hết hạn ngạch
● Grok    ░░░░░░░░░  Đã hết
● Kimi    █████████  22.4M còn lại
● Codex   ─────────  18:42:01
● Kilo    ─────────  18:42:01
```

## Cách hoạt động

Monitor gồm hai thành phần:

**`api_fetcher.py`** — script nền (cron mỗi 5 phút) poll API từng dịch vụ và ghi kết quả vào `~/token-monitor/api_cache.json`.

**`conky_ai.py`** — đọc cache mỗi 30 giây và xuất text định dạng Conky với inline `${color}` tag. Conky render thành widget desktop.

```
api_fetcher.py  →  api_cache.json  →  conky_ai.py  →  Hiển thị Conky
  (cron/5 phút)    (cache JSON)       (poll 30s)     (luôn hiển thị)
```

Kiến trúc này đảm bảo lỗi API không đóng băng desktop. Cache luôn lưu trạng thái cuối cùng đã biết.

## Thanh tiến trình kiểu HP bar

Tính năng chính là **hiển thị hạn ngạch kiểu thanh HP** — hàng ký tự Unicode block trực quan thể hiện hạn ngạch còn lại:

| Màu sắc | Trạng thái |
|---------|-----------|
| `█████████` xanh lá | Hơn 50% hạn ngạch |
| `████░░░░░` cam | Còn 20–50% |
| `█░░░░░░░░` đỏ | Dưới 20% |
| `░░░░░░░░░` đỏ | Đã hết / không có số dư |
| `─────────` xám | Chưa cấu hình API key |

Thanh tiến trình rộng 9 ký tự. Mỗi `█` đại diện cho khoảng 11% hạn ngạch.

## Cài đặt

```bash
# 1. Clone
git clone https://github.com/luckybbjason1/ai-token-monitor
cd ai-token-monitor

# 2. Cài đặt
bash install.sh

# 3. Thêm API key
nano ~/.config/.ai_monitor_keys

# 4. Khởi động lại Conky
pkill conky && conky --daemonize --pause=1
```

Script cài đặt tự động:
- Sao chép script vào `~/token-monitor/`
- Thêm `${execpi 30 python3 ~/token-monitor/conky_ai.py}` vào cấu hình Conky
- Thiết lập cron job cho `api_fetcher.py`

## Dịch vụ được hỗ trợ và phương thức API

| Dịch vụ | API Endpoint | Nội dung phát hiện |
|---------|-------------|-------------------|
| **Kimi** (Moonshot) | `GET /v1/users/me` | Hạn ngạch token còn lại chính xác |
| **Claude** (Anthropic) | `POST /v1/messages` | Header rate-limit theo cửa sổ |
| **Gemini** (Google) | `POST .../generateContent` | 429 = hết hạn ngạch |
| **Grok** (xAI) | `GET /v1/models` | 403 = hết số dư |
| Codex / Kilo | — | Đếm ngược đến nửa đêm UTC+8 |

## Thiết kế bảo mật

API key lưu trong `~/.config/.ai_monitor_keys` với quyền `chmod 600`. Bị loại trừ khỏi git qua `.gitignore`. Key không bao giờ được in ra terminal hay ghi vào file log — fetcher đọc một lần khi khởi động và chỉ giữ trong bộ nhớ trong thời gian gọi HTTP.

## Thêm dịch vụ tùy chỉnh

Thêm block vào `api_fetcher.py`:

```python
# ── Dịch vụ tùy chỉnh ────────────────────────────
key = keys.get('yourservice')
if key:
    try:
        r = requests.get('https://api.yourservice.com/v1/usage',
                         headers={'Authorization': f'Bearer {key}'}, timeout=8)
        if r.status_code == 200:
            data = r.json()
            remain = data['quota_remaining']
            total  = data['quota_total']
            cache['YourService'] = {
                'ok': True,
                'label': f'{remain//1000}K còn lại',
                'pct': remain / total
            }
        else:
            cache['YourService'] = {'ok': False, 'label': 'Lỗi API'}
    except Exception:
        pass
```

Sau đó thêm `{'name': 'YourService', 'reset_h': 24}` vào danh sách `SERVICES` trong `conky_ai.py`.

## Công cụ liên quan trên dibi8

Nếu bạn đang quản lý chi phí nhiều AI API, hãy tham khảo thêm:

- [So sánh AI coding Q2 2026 — Claude Code vs Cursor vs Codex](/vi/resources/dev-utils/ai-coding-2026-q2-claude-code-cursor-codex-gemini-shootout/) — so sánh chi phí workflow phát triển thực tế
- [RTK Rust CLI Proxy — Tiết kiệm 80% chi phí AI](/vi/resources/dev-utils/rtk-rust-cli-proxy-ai-coding-cost-save-80-percent-2026/) — tự động định tuyến prompt đến model rẻ nhất có sẵn
- [Hóa đơn coding AI hàng tháng 2026](/vi/resources/dev-utils/ai-coding-agent-monthly-bill-2026-real-receipts/) — biên lai thực tế 6 tháng sử dụng AI production

## Tải code

Hoàn toàn mã nguồn mở theo giấy phép MIT.

**GitHub:** [github.com/luckybbjason1/ai-token-monitor](https://github.com/luckybbjason1/ai-token-monitor)

Nếu công cụ này giúp bạn tránh được bất ngờ rate limit giữa chừng công việc, hãy Star repository. Issues và PR luôn được chào đón — đặc biệt cho hỗ trợ macOS hoặc tích hợp dịch vụ mới.
