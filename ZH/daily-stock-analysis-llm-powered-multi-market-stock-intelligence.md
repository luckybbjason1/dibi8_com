---
title: 每日股票分析：LLM驱动的多市场股票情报系统
description: 一个由LLM驱动的多市场分析系统，具备实时新闻、决策仪表盘和自动化通知。48K stars。支持零成本定时运行。
date: 2026-06-25
lastmod: 2026-06-25
draft: false
category: ai-trading
tags: ['股票分析', 'llm', '量化交易', 'ai代理', '多市场', 'a股', '情绪分析', '自动交易']
slug: daily-stock-analysis-llm-powered-multi-market-stock-intelligence
featureImage: /images/articles/daily-stock-analysis-llm-powered-multi-market-stock-intelligence-system.png
lang: zh
github_repo: https://github.com/dailystockai/daily-stock
license: MIT
---



# 每日股票分析：LLM驱动的多市场股票情报

**每日股票分析** 是一个开源的、由LLM驱动的股票分析系统，提供多市场情报，包括实时新闻聚合、自动化决策仪表盘和智能通知系统。凭借 **48,278 个 GitHub Stars**，它已成为寻求机构级分析的个人投资者中最受欢迎的量化交易工具之一。

本文涵盖安装、市场数据来源、LLM集成、仪表盘配置、自动化分析和部署策略。

## TL;DR

每日股票分析将实时市场数据、新闻情绪分析和LLM驱动的见解整合到一个统一的决策平台上。它支持包括美股、A股、加密货币和期货在内的多个市场。该系统可以完全免费运行定时自动化分析，让每个人都能获得机构级别的股票研究。

## 什么是每日股票分析？

每日股票分析是一个全面的股票情报平台，利用大语言模型来分析市场数据、新闻情绪和技术指标。与仅显示价格走势的传统图表工具不同，该系统提供上下文分析，解释市场为何波动以及接下来可能发生什么。

该平台支持多个市场和数据源：

- **美国市场**：纽约证券交易所、纳斯达克，支持实时和延迟数据
- **A股**：上海和深圳证券交易所，全面覆盖
- **加密货币**：包括币安、Coinbase和Kraken的主要交易所
- **期货与大宗商品**：石油、黄金、农产品和指数
- **外汇**：主要货币对，支持实时汇率

## 安装指南

### 前置条件

- **Python**：3.10+（推荐3.11）
- **数据库**：PostgreSQL 14+ 或 SQLite（轻量级设置）
- **LLM API**：OpenAI、Anthropic 或通过Ollama的本地模型
- **市场数据API**：Tushare（A股）、AKShare（免费）或付费提供商
- **系统**：最低8GB RAM，SQLite模式4GB

### 选项一：Docker部署（最简单）

```bash
# 克隆仓库
git clone https://github.com/ZhuLinsen/daily_stock_analysis.git
cd daily_stock_analysis

# 配置环境变量
cp .env.example .env
# 用你的API密钥编辑.env

# 启动所有服务
docker compose up -d

# 检查状态
docker compose ps
```

### 选项二：手动安装

```bash
# 克隆仓库
git clone https://github.com/ZhuLinsen/daily_stock_analysis.git
cd daily_stock_analysis

# 创建虚拟环境
python -m venv venv
source venv/bin/activate  # Linux/Mac
# 或
venv\Scripts\activate     # Windows

# 安装依赖
pip install -r requirements.txt

# 设置数据库
python setup_database.py --init

# 配置LLM和数据源
cp config.example.yaml config.yaml
# 用你的设置编辑config.yaml

# 运行首次分析
python main.py --market us --date $(date +%Y-%m-%d)
```

### 选项三：本地LLM设置（免费）

对于希望完全避免API费用的用户：

```bash
# 安装Ollama用于本地LLM推理
curl -fsSL https://ollama.ai/install.sh | sh

# 拉取合适的模型
ollama pull qwen2.5:14b

# 更新config.yaml以使用本地模型
cat >> config.yaml << EOF
llm:
  provider: ollama
  model: qwen2.5:14b
  base_url: http://localhost:11434
EOF

# 以零API成本运行分析
python main.py --market a_shares --date $(date +%Y-%m-%d)
```

## 市场数据集成

### AKShare集成（免费A股数据）

AKShare提供免费的中国市场数据访问，无需任何API密钥：

```python
import akshare as ak

# 获取每日A股市场数据
df = ak.stock_zh_a_spot_em()
print(df.head())

# 获取历史价格数据
hist_df = ak.stock_zh_a_hist(
    symbol="000001",
    period="daily",
    start_date="20260101",
    end_date="20260625",
    adjust="qfq"
)

# 获取板块表现
sector_df = ak.stock_board_industry_name_em()
print(sector_df)
```

### Tushare集成（高级A股数据）

对于更全面的基本面A股数据：

```python
import tushare as ts

# 用你的API令牌初始化
pro = ts.pro_api("YOUR_TUSHARE_TOKEN")

# 获取每日A股数据
df = pro.daily(
    ts_code="000001.SZ",
    start_date="20260101",
    end_date="20260625"
)

# 获取财务报表
income_df = pro.income(
    ts_code="000001.SZ",
    period="20260331",
    fields="total_operating_income,net_profit,total_expense"
)

# 获取股东信息
holder_df = pro.stock_holder_top10(
    ts_code="000001.SZ",
    ann_date="20260331"
)
```

### 美国市场数据

```python
import yfinance as yf

# 获取美股数据
ticker = yf.Ticker("AAPL")
df = ticker.history(period="3mo")

# 获取期权链
options = ticker.options

# 获取分析师推荐
recommendations = ticker.recommendations

# 获取新闻情绪
news = ticker.news
for item in news:
    print(f"{item['title']}: {item['providerPublishTime']}")
```

### 加密货币数据

```python
import ccxt

# 连接到交易所
exchange = ccxt.binance({
    'apiKey': 'YOUR_API_KEY',
    'secret': 'YOUR_SECRET',
})

# 获取行情数据
ticker = exchange.fetch_ticker('BTC/USDT')
print(f"价格: {ticker['last']}")
print(f"成交量: {ticker['quoteVolume']}")

# 获取订单簿
order_book = exchange.fetch_order_book('ETH/USDT')
print(f"买单: {order_book['bids'][0][0]}")
print(f"卖单: {order_book['asks'][0][0]}")
```

## LLM驱动分析

### 情绪分析管道

每日股票分析的核心是其LLM驱动的情绪分析管道：

```python
from daily_stock_analysis.llm import LLMAnalyzer
from daily_stock_analysis.data import MarketDataProvider

# 初始化组件
llm = LLMAnalyzer(model="gpt-4o", temperature=0.3)
data_provider = MarketDataProvider(source="akshare")

# 获取市场数据和新闻
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

# 运行LLM分析
analysis = llm.analyze_market(
    market_data=market_data,
    news_data=news_data,
    prompt_template="comprehensive_analysis"
)

print(f"总体情绪: {analysis.sentiment}")
print(f"置信度: {analysis.confidence:.1%}")
print(f"关键因素: {', '.join(analysis.key_factors)}")
print(f"风险等级: {analysis.risk_level}")
```

### 自定义分析提示

你可以为不同用例定制LLM分析提示：

```python
# 技术分析提示
tech_prompt = """
分析以下股票技术指标并提供：
1. 趋势方向（看涨/看跌/中性）
2. 关键支撑和阻力位
3. 动能评估
4. 成交量分析解读
5. 总体技术评级（1-10）

数据: {market_data}
"""

# 基本面分析提示
fund_prompt = """
分析以下基本面数据并提供：
1. 收入增长评估
2. 盈利能力评价
3. 债务可持续性
4. 估值比较
5. 总体基本面评级（1-10）

数据: {fundamental_data}
"""

# 综合分析
combined = llm.analyze(
    prompt_template="combined_analysis",
    market_data=market_data,
    fundamental_data=fundamental_data,
    news_data=news_data
)
```

### 多市场对比分析

同时比较不同市场的股票：

```python
# 比较美股科技股
us_techs = llm.compare_stocks(
    symbols=["AAPL", "MSFT", "GOOGL", "AMZN", "META"],
    market="us",
    comparison_metrics=["pe_ratio", "revenue_growth", "profit_margin"]
)

# 比较A股板块
a_share_sectors = llm.compare_sectors(
    sectors=["新能源", "半导体", "医药", "消费"],
    market="a_shares",
    time_period="1m"
)
```

## 仪表盘配置

### Web仪表盘设置

每日股票分析包含内置Web仪表盘：

```bash
# 启动仪表盘服务器
python dashboard.py --host 0.0.0.0 --port 8080

# 访问 http://localhost:8080
```

仪表盘提供：

- 带有热力图的实时市场概览
- 带有交互式图表的个股分析
- 板块表现对比
- 新闻情绪时间线
- 自动化分析报告

### 仪表盘定制

```yaml
# dashboard_config.yaml
dashboard:
  refresh_interval: 300  # 5分钟
  default_market: "a_shares"
  charts:
    - type: "heatmap"
      title: "市场热力图"
      data_source: "sector_performance"
    - type: "line"
      title: "股价历史"
      data_source: "historical_prices"
    - type: "sentiment"
      title: "新闻情绪"
      data_source: "llm_sentiment"
  alerts:
    - threshold: 0.8
      action: "notification"
      channels: ["email", "telegram"]
```

### 导出报告

```bash
# 生成PDF格式的每日报告
python report_generator.py --format pdf --output daily_report.pdf

# 生成带图表的HTML报告
python report_generator.py --format html --output daily_report.html

# 导出分析数据为CSV
python report_generator.py --format csv --output analysis_data.csv
```

## 自动化调度

### Cron任务设置

计划自动分析运行：

```bash
# 编辑crontab
crontab -e

# 每天早上7点添加每日分析
0 7 * * * cd /path/to/daily_stock_analysis && python main.py --market a_shares --auto

# 美股开盘后添加美国市场分析
0 21 * * 1-5 cd /path/to/daily_stock_analysis && python main.py --market us --auto

# 每周日生成综合报告
0 9 * * 0 cd /path/to/daily_stock_analysis && python weekly_report.py
```

### Systemd服务

用于持久后台运行：

```ini
# /etc/systemd/system/daily-stock-analysis.service
[Unit]
Description=每日股票分析服务
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
# 启用并启动服务
sudo systemctl enable daily-stock-analysis
sudo systemctl start daily-stock-analysis
sudo systemctl status daily-stock-analysis
```

## 通知系统

### Telegram通知

```bash
# 配置Telegram机器人
python notify.py --setup telegram \
  --bot-token "${TELEGRAM_BOT_TOKEN}" \
  --chat-id "${TELEGRAM_CHAT_ID}"

# 发送测试通知
python notify.py --send "AAPL每日分析完成" \
  --channel telegram
```

### 邮件通知

```python
from daily_stock_analysis.notify import Notifier

# 配置邮件通知器
notifier = Notifier(
    provider="smtp",
    smtp_server="smtp.gmail.com",
    smtp_port=587,
    username="your_email@gmail.com",
    password="your_app_password"
)

# 发送分析报告
notifier.send_email(
    to="your_email@gmail.com",
    subject="每日股票分析报告",
    body=analysis_report,
    attach_pdf=True
)
```

### 自定义Webhook通知

```python
# 发送到自定义webhook（如Slack、Discord）
notifier.send_webhook(
    url="https://hooks.slack.com/services/YOUR/WEBHOOK/URL",
    payload={
        "text": f"分析完成 {symbol}",
        "blocks": [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"*{symbol}* - 情绪: {sentiment}"
                }
            }
        ]
    }
)
```

## 对比：每日股票分析 vs 替代品

| 功能 | 每日股票分析 | TradingView | 万得金融 | 同花顺 |
|
加入社区: [Telegram](https://t.me/DIBI8_Group) · [HuggingFace](https://huggingface.co/collections/nvidia/cosmos3)

内部链接: [nvidia-cosmos-world-models-platform-2026](https://dibi8.com/zh/resources/ai-tools/nvidia-cosmos-world-models-platform-2026) · [bytedance-ui-tars-desktop-ai-agent-guide](https://dibi8.com/zh/resources/ai-tools/bytedance-ui-tars-desktop-ai-agent-guide)

**披露声明**: 本文提及的工具可能存在联盟关系。我们不接受付费评测。所有观点均为我们自己独立撰写。
