---
title: 'Polymarket Agents: Xây Dựng Bot Giao Dịch AI cho Thị Trường Dự Đoán'
description: Polymarket Agents là một khung phát triển mã nguồn mở để xây dựng các
  tác nhân AI giao dịch tự động trên thị trường dự đoán Polymarket.
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
file_size: "107 KB"
file_md5: ''
download_url: https://github.com/Polymarket/agents
backup_url: ''
github_repo: https://github.com/Polymarket/agents
stars: 3513
maintainer: "Polymarket"
last_maintained: "2024-11-05"
featureImage: ''
draft: false
aliases:
- /vi/posts/polymarket-agents-ai-trading-bot-framework/
faqs:
  - q: 'Polymarket Agents là gì?'
    a: 'Polymarket Agents là một framework dành cho nhà phát triển, mã nguồn mở và được cấp phép MIT, dùng để xây dựng các AI agent giao dịch tự động trên thị trường dự đoán Polymarket. Nó cung cấp các tiện ích để phân tích thị trường, tích hợp với Polymarket API để lấy dữ liệu thời gian thực và tự động thực hiện giao dịch.'
  - q: 'Tôi cần thiết lập những gì trước khi chạy Polymarket Agents?'
    a: 'Bạn cần private key của ví Polygon và một OpenAI API key được thiết lập trong file .env, cùng với một môi trường ảo Python 3.9 đã cài các dependency từ requirements.txt. Bạn cũng phải nạp USDC vào ví Polygon của mình, vì các giao dịch trên Polymarket được thanh toán bằng USDC.'
  - q: 'Polymarket Agents sử dụng RAG cho các quyết định giao dịch như thế nào?'
    a: 'Nó dùng cơ sở dữ liệu vector Chroma để lưu trữ các bài báo và dữ liệu thị trường, chuyển văn bản thành embeddings để tìm kiếm ngữ nghĩa, truy xuất thông tin liên quan dựa trên bối cảnh thị trường hiện tại, và để LLM tổng hợp dữ liệu được truy xuất đó thành một quyết định giao dịch.'
  - q: 'Polymarket Agents hỗ trợ những chiến lược giao dịch nào?'
    a: 'Framework này hỗ trợ giao dịch dựa trên tin tức (LLM phân tích cảm xúc về các sự kiện), phát hiện chênh lệch giá (arbitrage) giữa các thị trường liên quan, giao dịch theo xu hướng dựa trên khối lượng và biến động giá, cùng phân tích cơ bản sử dụng RAG để truy vấn dữ liệu lịch sử.'
  - q: 'Làm thế nào để thực hiện một giao dịch bằng Polymarket Agents CLI?'
    a: 'Chạy lệnh CLI ''python scripts/python/cli.py trade --market-id <MARKET_ID> --side buy --size <SIZE>''. Bạn cũng có thể liệt kê các thị trường bằng ''get-all-markets --sort-by volume'' hoặc xem một thị trường cụ thể bằng ''get-market --market-id <MARKET_ID>''.'
---
{</* resource-info */>}

![Polymarket Agents CLI hiển thị các lệnh](/images/articles/polymarket-agents-ai-trading-bot-framework/cli.png)
*Polymarket Agents CLI — ảnh chính thức từ [github.com/Polymarket/agents](https://github.com/Polymarket/agents)*

## Polymarket Agents là gì?

**Polymarket Agents** là một khung phát triển mã nguồn mở và bộ tiện ích để xây dựng các tác nhân AI giao dịch tự động trên **Polymarket** — nền tảng thị trường dự đoán lớn nhất thế giới.

Khung này cho phép nhà phát triển:
- 🤖 Xây dựng các tác nhân AI phân tích thị trường và thực hiện giao dịch tự động
- 📊 Tích hợp với API Polymarket để có dữ liệu thị trường thời gian thực
- 🔍 Sử dụng RAG (Tạo sinh Tăng cường Truy xuất) để đưa ra quyết định giao dịch sáng suốt
- 📰 Thu thập dữ liệu từ dịch vụ cá cược, nhà cung cấp tin tức và tìm kiếm web
- 🧠 Tận dụng các công cụ LLM toàn diện để kỹ thuật lời nhắc và phân tích thị trường

🔗 **GitHub**: [https://github.com/Polymarket/agents](https://github.com/Polymarket/agents)

---

## Polymarket là gì?

**Polymarket** là một nền tảng thị trường dự đoán phi tập trung nơi người dùng có thể giao dịch về kết quả của các sự kiện thế giới thực:

- **Chính trị** — Kết quả bầu cử, quyết định chính sách
- **Tiền mã hóa** — Dự đoán giá Bitcoin, phê duyệt ETF
- **Thể thao** — Kết quả trận đấu, nhà vô địch
- **Khoa học** — Đột phá nghiên cứu, sứ mệnh không gian
- **Giải trí** — Người chiến thắng giải thưởng, doanh thu phòng vé

Các nhà giao dịch mua cổ phiếu "Có" hoặc "Không" dựa trên dự đoán của họ, với giá phản ánh xác suất đồng thuận của thị trường.

---

## Tính năng chính

| Tính năng | Mô tả |
|-----------|-------|
| **Tích hợp API Polymarket** | Truy cập đầy đủ dữ liệu thị trường, sổ lệnh và thực hiện giao dịch |
| **Tiện ích tác nhân AI** | Công cụ xây dựng tác nhân giao dịch tự động |
| **RAG cục bộ và từ xa** | Hỗ trợ cơ sở dữ liệu vector cho tin tức và dữ liệu thị trường |
| **Dữ liệu đa nguồn** | Tích hợp dịch vụ cá cược, API tin tức, tìm kiếm web |
| **Kỹ thuật lời nhắc LLM** | Công cụ toàn diện cho suy luận nhận biết ngữ cảnh |
| **Giao diện CLI** | Công cụ dòng lệnh để phân tích thị trường và giao dịch |
| **Hỗ trợ Docker** | Triển khai container hóa để dễ dàng thiết lập |
| **Giấy phép MIT** | Miễn phí và mã nguồn mở |

---

## Kiến trúc

Polymarket Agents có các thành phần mô-đun có thể được duy trì và mở rộng bởi cộng đồng:

### API cốt lõi

| Thành phần | Mục đích |
|-----------|----------|
| **Chroma.py** | Cơ sở dữ liệu vector cho nguồn tin tức và dữ liệu API |
| **Gamma.py** | Khách hàng API Polymarket Gamma để lấy siêu dữ liệu thị trường |
| **Polymarket.py** | Lớp API chính cho dữ liệu thị trường và thực hiện giao dịch |
| **Objects.py** | Mô hình dữ liệu Pydantic cho giao dịch, thị trường, sự kiện |

### Lệnh CLI

Giao diện người dùng chính để tương tác với Polymarket:

```bash
# Lấy tất cả thị trường được sắp xếp theo khối lượng
python scripts/python/cli.py get-all-markets --limit 10 --sort-by volume

# Lấy chi tiết thị trường cụ thể
python scripts/python/cli.py get-market --market-id <MARKET_ID>

# Thực hiện giao dịch
python scripts/python/cli.py trade --market-id <MARKET_ID> --side buy --size <SIZE>
```

---

## Bắt đầu nhanh

### 1. Clone kho lưu trữ

```bash
git clone https://github.com/polymarket/agents.git
cd agents
```

### 2. Thiết lập môi trường

```bash
# Tạo môi trường ảo
virtualenv --python=python3.9 .venv
source .venv/bin/activate

# Cài đặt phụ thuộc
pip install -r requirements.txt
```

### 3. Cấu hình khóa API

Tạo tệp `.env`:

```env
POLYGON_WALLET_PRIVATE_KEY="khóa riêng tư ví của bạn"
OPENAI_API_KEY="khóa API OpenAI của bạn"
```

### 4. Nạp USDC vào ví

Chuyển USDC vào ví Polygon của bạn để giao dịch.

### 5. Chạy CLI

```bash
# Đặt đường dẫn Python
export PYTHONPATH="."

# Chạy CLI
python scripts/python/cli.py
```

Hoặc thực hiện giao dịch trực tiếp:

```bash
python agents/application/trade.py
```

### 6. Lựa chọn Docker

```bash
./scripts/bash/build-docker.sh
./scripts/bash/run-docker-dev.sh
```

---

## Chiến lược giao dịch

Polymarket Agents hỗ trợ nhiều chiến lược giao dịch dựa trên AI:

### 1. Giao dịch dựa trên tin tức
- Theo dõi nguồn tin tức để biết diễn biến sự kiện
- Sử dụng LLM để phân tích tình cảm và tác động
- Thực hiện giao dịch dựa trên kết quả dự đoán

### 2. Phát hiện chênh lệch giá
- So sánh giá trên các thị trường liên quan
- Xác định xác suất định giá sai
- Thực hiện giao dịch chênh lệch giá không rủi ro

### 3. Theo dõi xu hướng
- Phân tích khối lượng giao dịch và biến động giá
- Xác định đà trên các thị trường cụ thể
- Đi theo xu hướng để có lợi nhuận

### 4. Phân tích cơ bản
- Nghiên cứu bối cảnh và các yếu tố của sự kiện
- Sử dụng RAG để truy vấn dữ liệu lịch sử
- Đưa ra dự đoán sáng suốt

---

## Nguồn dữ liệu

Khung này tích hợp nhiều nguồn dữ liệu:

| Nguồn | Loại | Trường hợp sử dụng |
|-------|------|-------------------|
| **API tin tức** | Tin tức thời gian thực | Theo dõi sự kiện |
| **Tìm kiếm web** | Thông tin chung | Nghiên cứu nền tảng |
| **Dịch vụ cá cược** | So sánh tỷ lệ cược | Phát hiện giá |
| **Mạng xã hội** | Phân tích tình cảm | Phát hiện xu hướng |
| **Dữ liệu on-chain** | Dữ liệu giao dịch | Tình báo thị trường |

---

## Triển khai RAG

Tạo sinh tăng cường truy xuất để giao dịch sáng suốt:

1. **Cơ sở dữ liệu vector** — Chroma DB lưu trữ bài báo tin tức và dữ liệu thị trường
2. **Nhúng** — Chuyển đổi văn bản thành vector để tìm kiếm ngữ nghĩa
3. **Truy xuất** — Truy vấn thông tin liên quan dựa trên ngữ cảnh thị trường
4. **Tạo sinh** — LLM tổng hợp dữ liệu đã truy xuất thành quyết định giao dịch

---

## Quản lý rủi ro

Các cân nhắc quan trọng cho giao dịch tự động:

| Rủi ro | Giảm thiểu |
|--------|-----------|
| **Rủi ro thị trường** | Quy mô vị thế, cắt lỗ |
| **Rủi ro thanh khoản** | Giao dịch trên thị trường có khối lượng cao |
| **Rủi ro mô hình** | Kiểm tra lại chiến lược trước khi giao dịch thực |
| **Rủi ro vận hành** | Theo dõi hiệu suất bot thường xuyên |
| **Rủi ro quy định** | Tuân thủ quy định địa phương |

---

## So sánh với các công cụ khác

| Tính năng | Polymarket Agents | Bot tùy chỉnh | Giao dịch thủ công |
|-----------|------------------|---------------|-------------------|
| **Mã nguồn mở** | ✅ | Khác nhau | Không áp dụng |
| **Tích hợp AI** | ✅ | Tùy chọn | ❌ |
| **Hỗ trợ RAG** | ✅ | Hiếm | ❌ |
| **Dữ liệu đa nguồn** | ✅ | Tùy chọn | ❌ |
| **Giao diện CLI** | ✅ | Khác nhau | Không áp dụng |
| **Cộng đồng** | ✅ | Khác nhau | ❌ |
| **Tốc độ** | Nhanh | Nhanh | Chậm |
| **Không cảm xúc** | ✅ | ✅ | ❌ |

---

## Trường hợp sử dụng

### 1. Giao dịch sự kiện chính trị
- Kết quả bầu cử
- Quyết định chính sách
- Bỏ phiếu lập pháp

### 2. Dự đoán thị trường tiền mã hóa
- Biến động giá Bitcoin
- Phê duyệt ETF
- Quyết định quy định

### 3. Cá cược thể thao
- Kết quả trận đấu
- Nhà vô địch
- Hiệu suất cầu thủ

### 4. Thị trường giải trí
- Người chiến thắng giải thưởng
- Dự đoán doanh thu phòng vé
- Kết quả chương trình truyền hình thực tế

---

## Kho lưu trữ liên quan

| Kho lưu trữ | Mục đích |
|-------------|----------|
| [py-clob-client](https://github.com/Polymarket/py-clob-client) | Khách hàng Python cho Polymarket CLOB |
| [python-order-utils](https://github.com/Polymarket/python-order-utils) | Tạo và ký đơn hàng |
| [clob-client](https://github.com/Polymarket/clob-client) | Khách hàng TypeScript cho CLOB |
| [Langchain](https://github.com/langchain-ai/langchain) | Suy luận nhận biết ngữ cảnh |
| [Chroma](https://docs.trychroma.com) | Cơ sở dữ liệu vector |

---

## Tài nguyên đọc

- [Thị trường dự đoán: Điểm nghẽn và Giải pháp Tiếp theo](https://mirror.xyz/1kx.eth/jnQhA56Kx9p3RODKiGzqzHGGEODpbskivUUNdd7hwh0)
- [Tiền mã hóa + Ứng dụng AI](https://vitalik.eth.limo/general/2024/01/30/cryptoai.html) của Vitalik Buterin
- [Siêu dự đoán](https://hbr.org/2016/05/superforecasting-how-to-upgrade-your-companys-judgment)

---

## Bài viết liên quan

- [28 Tools Behind a $1M Polymarket Trading Bot: Full Stack Breakdown](/vi/resources/dev-utils/polymarket-trading-bot-stack/) — Kiến trúc bot giao dịch hoàn chỉnh
- [Free Claude Code: Công Cụ Proxy Mã Nguồn Mở Để Sử Dụng Claude Code CLI Miễn Phí](/vi/resources/ai-tools/free-claude-code-open-source-proxy/) — Trợ lý lập trình AI

---

## Kết luận

**Polymarket Agents** cung cấp một nền tảng vững chắc để xây dựng bot giao dịch dựa trên AI trên các thị trường dự đoán. Kiến trúc mô-đun, tích hợp API toàn diện và khả năng RAG làm cho nó phù hợp cho cả người mới bắt đầu và nhà phát triển có kinh nghiệm.

**Phù hợp nhất cho**: Nhà phát triển quan tâm đến giao dịch thuật toán, thị trường dự đoán và ra quyết định dựa trên AI

**GitHub**: [https://github.com/Polymarket/agents](https://github.com/Polymarket/agents)

---


---

## Hạ Tầng Đề Xuất Cho Tự Lưu Trữ

Để chạy stack này 24/7 ổn định, lựa chọn hạ tầng rất quan trọng:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 tín dụng miễn phí 60 ngày, 14+ region toàn cầu. Lựa chọn mặc định cho developer độc lập.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — VPS Hong Kong, độ trễ thấp với người dùng Việt Nam. dibi8.com cũng được host ở đây.
- **{{< aff "hostinger" "footer-cta-legacy" "Hostinger" >}}** — Lựa chọn VPS giá tốt cho thị trường Việt Nam, giảm 60% gói đầu tiên.

*Đây là affiliate link, không phát sinh chi phí thêm cho bạn nhưng giúp dibi8.com duy trì hoạt động.*

*Cập nhật lần cuối: 2026-05-06*
