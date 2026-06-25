---
  title: 'Daily Stock Analysis: LLM-Powered Multi-Market Stock Intelligence System'
  description: 'An LLM-driven multi-market stock analysis system with real-time news, decision dashboards, and automated notifications. 48K stars. Supports zero-cost scheduled runs.'
  date: 2026-06-25
  lastmod: 2026-06-25
  draft: false
  lang: en
  github_repo: https://github.com/dailystockai/daily-stock
  category: ai-trading
  tags: ['stock-analysis', 'llm', 'quantitative-trading', 'ai-agent', 'multi-market', 'a-stock', 'sentiment-analysis', 'automated-trading']
  slug: daily-stock-analysis-llm-powered-multi-market-stock-intelligence
  featureImage: /images/articles/daily-stock-analysis-llm-powered-multi-market-stock-intelligence-system.png
  license: MIT
---



# Daily Stock Analysis: LLM-Powered Multi-Market Stock Intelligence

**Daily Stock Analysis** is an open-source, LLM-driven stock analysis system that provides multi-market intelligence with real-time news aggregation, automated decision dashboards, and intelligent notification systems. With **48,278 GitHub stars**, it has become one of the most popular quantitative trading tools for retail investors seeking institutional-grade analysis.

This article covers installation, market data sources, LLM integration, dashboard configuration, automated analysis, and deployment strategies.

## TL;DR

Daily Stock Analysis combines real-time market data, news sentiment analysis, and LLM-powered insights into a unified decision-making platform. It supports multiple markets including US stocks, A-shares, cryptocurrencies, and futures. The system can run entirely for free with scheduled automated analysis, making institutional-quality stock research accessible to everyone.

## What Is Daily Stock Analysis?

Daily Stock Analysis is a comprehensive stock intelligence platform that leverages large language models to analyze market data, news sentiment, and technical indicators. Unlike traditional charting tools that only show price movements, this system provides contextual analysis that explains WHY markets are moving and WHAT might happen next.

The platform supports multiple markets and data sources:

- **US Markets**: NYSE, NASDAQ, with real-time and delayed data
- **A-Shares**: Shanghai and Shenzhen exchanges with comprehensive coverage
- **Cryptocurrency**: Major exchanges including Binance, Coinbase, and Kraken
- **Futures & Commodities**: Oil, gold, agricultural products, and indices
- **Forex**: Major currency pairs with real-time exchange rates

## Installation Guide

### Prerequisites

- **Python**: 3.10+ (3.11 recommended)
- **Database**: PostgreSQL 14+ or SQLite (for lightweight setups)
- **LLM API**: OpenAI, Anthropic, or local models via Ollama
- **Market Data API**: Tushare (A-shares), AKShare (free), or paid providers
- **System**: 8GB RAM minimum, 4GB for SQLite mode

### Option 1: Docker Deployment (Easiest)

```bash
# Clone the repository
git clone https://github.com/ZhuLinsen/daily_stock_analysis.git
cd daily_stock_analysis

# Configure environment variables
cp .env.example .env
# Edit .env with your API keys

# Start all services
docker compose up -d

# Check status
docker compose ps
```

### Option 2: Manual Installation

```bash
# Clone the repository
git clone https://github.com/ZhuLinsen/daily_stock_analysis.git
cd daily_stock_analysis

# Create virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
# or
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt

# Set up the database
python setup_database.py --init

# Configure LLM and data sources
cp config.example.yaml config.yaml
# Edit config.yaml with your settings

# Run the first analysis
python main.py --market us --date $(date +%Y-%m-%d)
```

### Option 3: Local LLM Setup (Free)

For users who want to avoid API costs entirely:

```bash
# Install Ollama for local LLM inference
curl -fsSL https://ollama.ai/install.sh | sh

# Pull a suitable model
ollama pull qwen2.5:14b

# Update config.yaml to use local model
cat >> config.yaml << EOF
llm:
  provider: ollama
  model: qwen2.5:14b
  base_url: http://localhost:11434
EOF

# Run analysis with zero API costs
python main.py --market a_shares --date $(date +%Y-%m-%d)
```

## Market Data Integration

### AKShare Integration (Free A-Share Data)

AKShare provides free access to Chinese market data without any API key:

```python
import akshare as ak

# Get daily A-share market data
df = ak.stock_zh_a_spot_em()
print(df.head())

# Get historical price data
hist_df = ak.stock_zh_a_hist(
    symbol="000001",
    period="daily",
    start_date="20260101",
    end_date="20260625",
    adjust="qfq"
)

# Get sector performance
sector_df = ak.stock_board_industry_name_em()
print(sector_df)
```

### Tushare Integration (Premium A-Share Data)

For more comprehensive A-share data including fundamentals:

```python
import tushare as ts

# Initialize with your API token
pro = ts.pro_api("YOUR_TUSHARE_TOKEN")

# Get daily A-share data
df = pro.daily(
    ts_code="000001.SZ",
    start_date="20260101",
    end_date="20260625"
)

# Get financial statements
income_df = pro.income(
    ts_code="000001.SZ",
    period="20260331",
    fields="total_operating_income,net_profit,total_expense"
)

# Get shareholder information
holder_df = pro.stock_holder_top10(
    ts_code="000001.SZ",
    ann_date="20260331"
)
```

### US Market Data

```python
import yfinance as yf

# Get US stock data
ticker = yf.Ticker("AAPL")
df = ticker.history(period="3mo")

# Get options chain
options = ticker.options

# Get analyst recommendations
recommendations = ticker.recommendations

# Get news sentiment
news = ticker.news
for item in news:
    print(f"{item['title']}: {item['providerPublishTime']}")
```

### Cryptocurrency Data

```python
import ccxt

# Connect to exchange
exchange = ccxt.binance({
    'apiKey': 'YOUR_API_KEY',
    'secret': 'YOUR_SECRET',
})

# Get ticker data
ticker = exchange.fetch_ticker('BTC/USDT')
print(f"Price: {ticker['last']}")
print(f"Volume: {ticker['quoteVolume']}")

# Get order book
order_book = exchange.fetch_order_book('ETH/USDT')
print(f"Bid: {order_book['bids'][0][0]}")
print(f"Ask: {order_book['asks'][0][0]}")
```

## LLM-Powered Analysis

### Sentiment Analysis Pipeline

The core of Daily Stock Analysis is its LLM-powered sentiment analysis pipeline:

```python
from daily_stock_analysis.llm import LLMAnalyzer
from daily_stock_analysis.data import MarketDataProvider

# Initialize components
llm = LLMAnalyzer(model="gpt-4o", temperature=0.3)
data_provider = MarketDataProvider(source="akshare")

# Fetch market data and news
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

# Run LLM analysis
analysis = llm.analyze_market(
    market_data=market_data,
    news_data=news_data,
    prompt_template="comprehensive_analysis"
)

print(f"Overall Sentiment: {analysis.sentiment}")
print(f"Confidence: {analysis.confidence:.1%}")
print(f"Key Factors: {', '.join.analysis.key_factors)}")
print(f"Risk Level: {analysis.risk_level}")
```

### Custom Analysis Prompts

You can customize the LLM analysis prompts for different use cases:

```python
# Technical analysis prompt
tech_prompt = """
Analyze the following stock technical indicators and provide:
1. Trend direction (bullish/bearish/neutral)
2. Key support and resistance levels
3. Momentum assessment
4. Volume analysis interpretation
5. Overall technical rating (1-10)

Data: {market_data}
"""

# Fundamental analysis prompt
fund_prompt = """
Analyze the following fundamental data and provide:
1. Revenue growth assessment
2. Profitability evaluation
3. Debt sustainability
4. Valuation comparison
5. Overall fundamental rating (1-10)

Data: {fundamental_data}
"""

# Combined analysis
combined = llm.analyze(
    prompt_template="combined_analysis",
    market_data=market_data,
    fundamental_data=fundamental_data,
    news_data=news_data
)
```

### Multi-Market Comparative Analysis

Compare stocks across different markets simultaneously:

```python
# Compare US tech stocks
us_techs = llm.compare_stocks(
    symbols=["AAPL", "MSFT", "GOOGL", "AMZN", "META"],
    market="us",
    comparison_metrics=["pe_ratio", "revenue_growth", "profit_margin"]
)

# Compare A-share sectors
a_share_sectors = llm.compare_sectors(
    sectors=["新能源", "半导体", "医药", "消费"],
    market="a_shares",
    time_period="1m"
)
```

## Dashboard Configuration

### Web Dashboard Setup

Daily Stock Analysis includes a built-in web dashboard:

```bash
# Start the dashboard server
python dashboard.py --host 0.0.0.0 --port 8080

# Access at http://localhost:8080
```

The dashboard provides:

- Real-time market overview with heat maps
- Individual stock analysis with interactive charts
- Sector performance comparisons
- News sentiment timeline
- Automated analysis reports

### Dashboard Customization

```yaml
# dashboard_config.yaml
dashboard:
  refresh_interval: 300  # 5 minutes
  default_market: "a_shares"
  charts:
    - type: "heatmap"
      title: "Market Heatmap"
      data_source: "sector_performance"
    - type: "line"
      title: "Stock Price History"
      data_source: "historical_prices"
    - type: "sentiment"
      title: "News Sentiment"
      data_source: "llm_sentiment"
  alerts:
    - threshold: 0.8
      action: "notification"
      channels: ["email", "telegram"]
```

### Exporting Reports

```bash
# Generate daily report in PDF
python report_generator.py --format pdf --output daily_report.pdf

# Generate HTML report with charts
python report_generator.py --format html --output daily_report.html

# Export analysis data as CSV
python report_generator.py --format csv --output analysis_data.csv
```

## Automated Scheduling

### Cron Job Setup

Schedule automatic analysis runs:

```bash
# Edit crontab
crontab -e

# Add daily analysis at 7 AM
0 7 * * * cd /path/to/daily_stock_analysis && python main.py --market a_shares --auto

# Add US market analysis after market open
0 21 * * 1-5 cd /path/to/daily_stock_analysis && python main.py --market us --auto

# Weekly comprehensive report on Sunday
0 9 * * 0 cd /path/to/daily_stock_analysis && python weekly_report.py
```

### Systemd Service

For persistent background operation:

```ini
# /etc/systemd/system/daily-stock-analysis.service
[Unit]
Description=Daily Stock Analysis Service
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
# Enable and start the service
sudo systemctl enable daily-stock-analysis
sudo systemctl start daily-stock-analysis
sudo systemctl status daily-stock-analysis
```

## Notification System

### Telegram Notifications

```bash
# Configure Telegram bot
python notify.py --setup telegram \
  --bot-token "${TELEGRAM_BOT_TOKEN}" \
  --chat-id "${TELEGRAM_CHAT_ID}"

# Send test notification
python notify.py --send "Daily analysis complete for AAPL" \
  --channel telegram
```

### Email Notifications

```python
from daily_stock_analysis.notify import Notifier

# Configure email notifier
notifier = Notifier(
    provider="smtp",
    smtp_server="smtp.gmail.com",
    smtp_port=587,
    username="your_email@gmail.com",
    password="your_app_password"
)

# Send analysis report
notifier.send_email(
    to="your_email@gmail.com",
    subject="Daily Stock Analysis Report",
    body=analysis_report,
    attach_pdf=True
)
```

### Custom Webhook Notifications

```python
# Send to custom webhook (e.g., Slack, Discord)
notifier.send_webhook(
    url="https://hooks.slack.com/services/YOUR/WEBHOOK/URL",
    payload={
        "text": f"Analysis complete for {symbol}",
        "blocks": [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"*{symbol}* - Sentiment: {sentiment}"
                }
            }
        ]
    }
)
```

## Comparison: Daily Stock Analysis vs Alternatives

| Feature | Daily Stock Analysis | TradingView | Wind Financial | Choice Info |
|
Join the community: [Telegram](https://t.me/DIBI8_Group) · [HuggingFace](https://huggingface.co/collections/nvidia/cosmos3)

Internal links: [nvidia-cosmos-world-models-platform-2026](https://dibi8.com/en/resources/ai-tools/nvidia-cosmos-world-models-platform-2026) · [bytedance-ui-tars-desktop-ai-agent-guide](https://dibi8.com/en/resources/ai-tools/bytedance-ui-tars-desktop-ai-agent-guide)

**Disclosure**: This article mentions tools that may have affiliate relationships. We do not accept payment for reviews. All opinions are our own.
