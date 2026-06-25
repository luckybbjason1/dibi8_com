---
title: 'Phân Tích Cổ Phiếu Hàng Ngày: Hệ Thống Thông Minh Đa Thị Trường Được Hỗ Trợ Bởi LLM'
description: 'Hệ thống phân tích cổ phiếu đa thị trường do LLM điều khiển với tin tức thời gian thực, bảng điều khiển ra quyết định và thông báo tự động. 48K sao. Hỗ trợ chạy theo lịch trình miễn phí.'
date: 2026-06-25
lastmod: 2026-06-25
draft: false
category: ai-trading
tags: ['phân-tích-cổ-phếu', 'llm', 'giao-dịch-định-lượng', 'ai-agent', 'đa-thị-trường', 'cổ-phếu-a', 'phân-tích-cảm-xúc', 'giao-dịch-tự-động']
slug: daily-stock-analysis-llm-powered-multi-market-stock-intelligence
featureImage: /images/articles/daily-stock-analysis-llm-powered-multi-market-stock-intelligence-system.png
lang: vi
github_repo: https://github.com/dailystockai/daily-stock
license: MIT
---



# Phân Tích Cổ Phiếu Hàng Ngày: Thông Minh Đa Thị Trường Được Hỗ Trợ Bởi LLM

**Phân Tích Cổ Phiếu Hàng Ngày** là một hệ thống phân tích cổ phiếu mã nguồn mở, được điều khiển bởi LLM, cung cấp thông tin đa thị trường với tổng hợp tin tức thời gian thực, bảng điều khiển ra quyết định tự động và hệ thống thông minh. Với **48.278 sao GitHub**, nó đã trở thành một trong những công cụ giao dịch định lượng phổ biến nhất cho nhà đầu tư cá nhân tìm kiếm phân tích cấp tổ chức.

Bài viết này bao gồm hướng dẫn cài đặt, nguồn dữ liệu thị trường, tích hợp LLM, cấu hình bảng điều khiển, phân tích tự động và chiến lược triển khai.

## TL;DR

Phân Tích Cổ Phiếu Hàng Ngày kết hợp dữ liệu thị trường thời gian thực, phân tích cảm xúc tin tức và thông tin do LLM cung cấp vào một nền tảng ra quyết định thống nhất. Nó hỗ trợ nhiều thị trường bao gồm cổ phiếu Mỹ, cổ phiếu A, tiền điện tử và hợp đồng tương lai. Hệ thống có thể chạy hoàn toàn miễn phí với phân tích tự động theo lịch trình, giúp nghiên cứu cổ phiếu cấp tổ chức dễ tiếp cận với mọi người.

## Phân Tích Cổ Phiếu Hàng Ngày Là Gì?

Phân Tích Cổ Phiếu Hàng Ngày là một nền tảng thông minh cổ phiếu toàn diện tận dụng các mô hình ngôn ngữ lớn để phân tích dữ liệu thị trường, cảm xúc tin tức và các chỉ báo kỹ thuật. Khác với các công cụ biểu đồ truyền thống chỉ hiển thị biến động giá, hệ thống này cung cấp phân tích ngữ cảnh giải thích TẠI SAO thị trường đang di chuyển VÀ ĐIỀU GÌ CÓ THỂ XẢY RA TIẾP THEO.

Nền tảng hỗ trợ nhiều thị trường và nguồn dữ liệu:

- **Thị trường Mỹ**: NYSE, NASDAQ, với dữ liệu thời gian thực và trễ
- **Cổ phiếu A**: Thị trường Thượng Hải và Thâm Quyến với phạm vi bao phủ toàn diện
- **Tiền điện tử**: Các giao dịch chính bao gồm Binance, Coinbase và Kraken
- **Hợp đồng tương lai & Hàng hóa**: Dầu, vàng, nông sản và chỉ số
- **Ngoại hối**: Các cặp tiền tệ chính với tỷ giá hối đoái thời gian thực

## Hướng Dẫn Cài Đặt

### Yêu Cầu Tiên Quyết

- **Python**: 3.10+ (khuyến nghị 3.11)
- **Cơ sở dữ liệu**: PostgreSQL 14+ hoặc SQLite (cho cài đặt nhẹ)
- **API LLM**: OpenAI, Anthropic hoặc mô hình cục bộ qua Ollama
- **API Dữ Liệu Thị Trường**: Tushare (cổ phiếu A), AKShare (miễn phí) hoặc nhà cung cấp trả phí
- **Hệ thống**: Tối thiểu 8GB RAM, 4GB cho chế độ SQLite

### Tùy Chọn 1: Triển Khai Docker (Dễ Nhất)

```bash
# Sao chép kho lưu trữ
git clone https://github.com/ZhuLinsen/daily_stock_analysis.git
cd daily_stock_analysis

# Cấu hình biến môi trường
cp .env.example .env
# Chỉnh sửa .env với khóa API của bạn

# Khởi động tất cả dịch vụ
docker compose up -d

# Kiểm tra trạng thái
docker compose ps
```

### Tùy Chọn 2: Cài Đặt Thủ Công

```bash
# Sao chép kho lưu trữ
git clone https://github.com/ZhuLinsen/daily_stock_analysis.git
cd daily_stock_analysis

# Tạo môi trường ảo
python -m venv venv
source venv/bin/activate  # Linux/Mac
# hoặc
venv\Scripts\activate     # Windows

# Cài đặt phụ thuộc
pip install -r requirements.txt

# Thiết lập cơ sở dữ liệu
python setup_database.py --init

# Cấu hình LLM và nguồn dữ liệu
cp config.example.yaml config.yaml
# Chỉnh sửa config.yaml với cài đặt của bạn

# Chạy phân tích đầu tiên
python main.py --market us --date $(date +%Y-%m-%d)
```

### Tùy Chọn 3: Thiết Lập LLM Cục Bộ (Miễn Phí)

Dành cho người dùng muốn tránh hoàn toàn chi phí API:

```bash
# Cài đặt Ollama cho suy luận LLM cục bộ
curl -fsSL https://ollama.ai/install.sh | sh

# Kéo mô hình phù hợp
ollama pull qwen2.5:14b

# Cập nhật config.yaml để sử dụng mô hình cục bộ
cat >> config.yaml << EOF
llm:
  provider: ollama
  model: qwen2.5:14b
  base_url: http://localhost:11434
EOF

# Chạy phân tích với chi phí API bằng không
python main.py --market a_shares --date $(date +%Y-%m-%d)
```

## Tích Hợp Dữ Liệu Thị Trường

### Tích Hợp AKShare (Dữ Liệu Cổ Phiếu A Miễn Phí)

AKShare cung cấp quyền truy cập miễn phí vào dữ liệu thị trường Trung Quốc mà không cần khóa API:

```python
import akshare as ak

# Lấy dữ liệu thị trường cổ phiếu A hàng ngày
df = ak.stock_zh_a_spot_em()
print(df.head())

# Lấy dữ liệu giá lịch sử
hist_df = ak.stock_zh_a_hist(
    symbol="000001",
    period="daily",
    start_date="20260101",
    end_date="20260625",
    adjust="qfq"
)

# Lấy hiệu suất ngành
sector_df = ak.stock_board_industry_name_em()
print(sector_df)
```

### Tích Hợp Tushare (Dữ Liệu Cổ Phiếu A Cao Cấp)

Để dữ liệu cổ phiếu A toàn diện hơn bao gồm thông tin cơ bản:

```python
import tushare as ts

# Khởi tạo với token API của bạn
pro = ts.pro_api("YOUR_TUSHARE_TOKEN")

# Lấy dữ liệu cổ phiếu A hàng ngày
df = pro.daily(
    ts_code="000001.SZ",
    start_date="20260101",
    end_date="20260625"
)

# Lấy báo cáo tài chính
income_df = pro.income(
    ts_code="000001.SZ",
    period="20260331",
    fields="total_operating_income,net_profit,total_expense"
)

# Lấy thông tin cổ đông
holder_df = pro.stock_holder_top10(
    ts_code="000001.SZ",
    ann_date="20260331"
)
```

### Dữ Liệu Thị Trường Mỹ

```python
import yfinance as yf

# Lấy dữ liệu cổ phiếu Mỹ
ticker = yf.Ticker("AAPL")
df = ticker.history(period="3mo")

# Lấy chuỗi quyền chọn
options = ticker.options

# Lấy khuyến nghị của chuyên gia
recommendations = ticker.recommendations

# Lấy cảm xúc tin tức
news = ticker.news
for item in news:
    print(f"{item['title']}: {item['providerPublishTime']}")
```

### Dữ Liệu Tiền Điện Tử

```python
import ccxt

# Kết nối đến giao dịch
exchange = ccxt.binance({
    'apiKey': 'YOUR_API_KEY',
    'secret': 'YOUR_SECRET',
})

# Lấy dữ liệu ticker
ticker = exchange.fetch_ticker('BTC/USDT')
print(f"Giá: {ticker['last']}")
print(f"Khối lượng: {ticker['quoteVolume']}")

# Lấy sổ lệnh
order_book = exchange.fetch_order_book('ETH/USDT')
print(f"Chúc mua: {order_book['bids'][0][0]}")
print(f"Chúc bán: {order_book['asks'][0][0]}")
```

## Phân Tích Được Hỗ Trợ Bởi LLM

### Pipeline Phân Tích Cảm Xúc

Trọng tâm của Phân Tích Cổ Phiếu Hàng Ngày là pipeline phân tích cảm xúc do LLM cung cấp:

```python
from daily_stock_analysis.llm import LLMAnalyzer
from daily_stock_analysis.data import MarketDataProvider

# Khởi tạo các thành phần
llm = LLMAnalyzer(model="gpt-4o", temperature=0.3)
data_provider = MarketDataProvider(source="akshare")

# Lấy dữ liệu thị trường và tin tức
market_data = data_provider.get_market_data(
    symbol="000001.SZ",
    period="1d",
    indicators=["rsi", "macd", "bollinger"]
)

news_data = data_provider.get_news(
    symbol="000001.SZ",
    days=7,
    sources=["eastmoney", "cls", "cnbc"]
)

# Chạy phân tích LLM
analysis = llm.analyze_market(
    market_data=market_data,
    news_data=news_data,
    prompt_template="comprehensive_analysis"
)

print(f"Cảm Xúc Tổng Thể: {analysis.sentiment}")
print(f"Độ Tin Cậy: {analysis.confidence:.1%}")
print(f"Yếu Tố Chính: {', '.join(analysis.key_factors)}")
print(f"Mức Độ Rủi Ro: {analysis.risk_level}")
```

### Prompt Phân Tích Tùy Chỉnh

Bạn có thể tùy chỉnh prompt phân tích LLM cho các trường hợp sử dụng khác nhau:

```python
# Prompt phân tích kỹ thuật
tech_prompt = """
Phân tích các chỉ báo kỹ thuật cổ phiếu sau và cung cấp:
1. Hướng xu hướng (bullish/bearish/trung tính)
2. Mức hỗ trợ và kháng cự chính
3. Đánh giá động lượng
4. Giải thích phân tích khối lượng
5. Xếp hạng kỹ thuật tổng thể (1-10)

Dữ liệu: {market_data}
"""

# Prompt phân tích cơ bản
fund_prompt = """
Phân tích dữ liệu cơ bản sau và cung cấp:
1. Đánh giá tăng trưởng doanh thu
2. Đánh giá khả năng sinh lời
3. Tính bền vững của nợ
4. So sánh định giá
5. Xếp hạng cơ bản tổng thể (1-10)

Dữ liệu: {fundamental_data}
"""

# Phân tích kết hợp
combined = llm.analyze(
    prompt_template="combined_analysis",
    market_data=market_data,
    fundamental_data=fundamental_data,
    news_data=news_data
)
```

### Phân Tích So Sánh Đa Thị Trường

So sánh cổ phiếu trên các thị trường khác nhau đồng thời:

```python
# So sánh cổ phiếu công nghệ Mỹ
us_techs = llm.compare_stocks(
    symbols=["AAPL", "MSFT", "GOOGL", "AMZN", "META"],
    market="us",
    comparison_metrics=["pe_ratio", "revenue_growth", "profit_margin"]
)

# So sánh ngành cổ phiếu A
a_share_sectors = llm.compare_sectors(
    sectors=["Năng lượng mới", "Bán dẫn", "Dược phẩm", "Tiêu dùng"],
    market="a_shares",
    time_period="1m"
)
```

## Cấu Hình Bảng Điều Khiển

### Thiết Lập Bảng Điều Khiển Web

Phân Tích Cổ Phiếu Hàng Ngày bao gồm bảng điều khiển web tích hợp:

```bash
# Khởi động máy chủ bảng điều khiển
python dashboard.py --host 0.0.0.0 --port 8080

# Truy cập tại http://localhost:8080
```

Bảng điều khiển cung cấp:

- Tổng quan thị trường thời gian thực với bản đồ nhiệt
- Phân tích cổ phiếu cá nhân với biểu đồ tương tác
- So sánh hiệu suất ngành
- Dòng thời gian cảm xúc tin tức
- Báo cáo phân tích tự động

### Tùy Chỉnh Bảng Điều Khiển

```yaml
# dashboard_config.yaml
dashboard:
  refresh_interval: 300  # 5 phút
  default_market: "a_shares"
  charts:
    - type: "heatmap"
      title: "Bản Đồ Nhiệt Thị Trường"
      data_source: "sector_performance"
    - type: "line"
      title: "Lịch Sử Giá Cổ Phiếu"
      data_source: "historical_prices"
    - type: "sentiment"
      title: "Cảm Xúc Tin Tức"
      data_source: "llm_sentiment"
  alerts:
    - threshold: 0.8
      action: "notification"
      channels: ["email", "telegram"]
```

### Xuất Báo Cáo

```bash
# Tạo báo cáo hàng ngày định dạng PDF
python report_generator.py --format pdf --output daily_report.pdf

# Tạo báo cáo HTML với biểu đồ
python report_generator.py --format html --output daily_report.html

# Xuất dữ liệu phân tích dưới dạng CSV
python report_generator.py --format csv --output analysis_data.csv
```

## Lên Lịch Tự Động

### Thiết Lập Cron Job

Lên lịch chạy phân tích tự động:

```bash
# Chỉnh sửa crontab
crontab -e

# Thêm phân tích hàng ngày lúc 7 giờ sáng
0 7 * * * cd /path/to/daily_stock_analysis && python main.py --market a_shares --auto

# Thêm phân tích thị trường Mỹ sau khi mở cửa
0 21 * * 1-5 cd /path/to/daily_stock_analysis && python main.py --market us --auto

# Báo cáo tổng hợp hàng tuần vào Chủ Nhật
0 9 * * 0 cd /path/to/daily_stock_analysis && python weekly_report.py
```

### Dịch Vụ Systemd

Cho hoạt động nền liên tục:

```ini
# /etc/systemd/system/daily-stock-analysis.service
[Unit]
Description=Dịch Vụ Phân Tích Cổ Phiếu Hàng Ngày
After=network.target postgresql.service

[Service]
Type=simple
User=stockuser
WorkingDirectory=/opt/daily_stock_analysis
ExecStart=/opt/daily_stock_analysis/venv/bin/python main.py --daemon
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
```

```bash
# Kích hoạt và khởi động dịch vụ
sudo systemctl enable daily-stock-analysis
sudo systemctl start daily-stock-analysis
sudo systemctl status daily-stock-analysis
```

## Hệ Thống Thông Báo

### Thông Báo Telegram

```bash
# Cấu hình bot Telegram
python notify.py --setup telegram \
  --bot-token "${TELEGRAM_BOT_TOKEN}" \
  --chat-id "${TELEGRAM_CHAT_ID}"

# Gửi thông báo thử nghiệm
python notify.py --send "Phân tích hàng ngày hoàn tất cho AAPL" \
  --channel telegram
```

### Thông Báo Email

```python
from daily_stock_analysis.notify import Notifier

# Cấu hình trình thông báo email
notifier = Notifier(
    provider="smtp",
    smtp_server="smtp.gmail.com",
    smtp_port=587,
    username="your_email@gmail.com",
    password="your_app_password"
)

# Gửi báo cáo phân tích
notifier.send_email(
    to="your_email@gmail.com",
    subject="Báo Cáo Phân Tích Cổ Phiếu Hàng Ngày",
    body=analysis_report,
    attach_pdf=True
)
```

### Thông Báo Webhook Tùy Chỉnh

```python
# Gửi đến webhook tùy chỉnh (ví dụ: Slack, Discord)
notifier.send_webhook(
    url="https://hooks.slack.com/services/YOUR/WEBHOOK/URL",
    payload={
        "text": f"Phân tích hoàn tất cho {symbol}",
        "blocks": [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"*{symbol}* - Cảm xúc: {sentiment}"
                }
            }
        ]
    }
)
```

## So Sánh: Phân Tích Cổ Phiếu Hàng Ngày vs Giải Pháp Thay Thế

| Tính Năng | Phân Tích CP Hàng Ngày | TradingView | Wind Financial | Choice Info |
|
Tham gia cộng đồng: [Telegram](https://t.me/DIBI8_Group) · [HuggingFace](https://huggingface.co/collections/nvidia/cosmos3)

Liên kết nội bộ: [nvidia-cosmos-world-models-platform-2026](https://dibi8.com/vi/resources/ai-tools/nvidia-cosmos-world-models-platform-2026) · [bytedance-ui-tars-desktop-ai-agent-guide](https://dibi8.com/vi/resources/ai-tools/bytedance-ui-tars-desktop-ai-agent-guide)

**Tiết lộ**: Bài viết này đề cập đến các công cụ có thể có quan hệ liên kết. Chúng tôi không chấp nhận thanh toán cho đánh giá. Tất cả ý kiến đều là của riêng chúng tôi.
