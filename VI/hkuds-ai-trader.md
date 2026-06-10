---
title: "AI-Trader: Nền tảng giao dịch Agent-Native từ HKUDS"
description: "AI-Trader là một nền tảng giao dịch agent-native từ HKUDS cho phép các tác nhân lập trình AI như Claude Code, Codex, Cursor và OpenClaw tự động thực hiện giao dịch, quản lý danh mục và tối ưu hóa chiến lược."
date: 2026-06-10
slug: hkuds-ai-trader
category: ai-trading
tags: [ai-trader, HKUDS, ai-trading, agent-native, giao dịch tự động, quản lý danh mục, tác nhân AI]
github_repo: https://github.com/HKUDS/AI-Trader
stars: 19464
maintainer: HKUDS
license: MIT
featureImage: https://raw.githubusercontent.com/HKUDS/AI-Trader/main/assets/ai-trader-hero-banner.png
lang: vi
---

## Giới thiệu

Sự hội tụ của các tác nhân AI và thị trường tài chính là một trong những xu hướng có ý nghĩa nhất trong công nghệ. Các hệ thống giao dịch tự động được cung cấp bởi machine learning đã tồn tại nhiều năm, nhưng chúng luôn được gắn chặt với các framework cụ thể và đòi hỏi chuyên môn sâu để cấu hình và bảo trì. Rào cản gia nhập rất cao: bạn cần hiểu cả tài chính và cơ sở hạ tầng machine learning.

**AI-Trader** từ [HKUDS](https://github.com/HKUDS) loại bỏ rào cản đó. Với [19.464 sao GitHub](https://github.com/HKUDS/AI-Trader), nền tảng giao dịch agent-native này cho phép các tác nhân lập trình AI -- bao gồm Claude Code, Codex, Cursor, OpenClaw, và nanobot -- tự động thực hiện giao dịch, quản lý danh mục và tối ưu hóa chiến lược giao dịch. Nó tưởng tượng lại giao diện của một nền tảng giao dịch khi "người dùng" là một tác nhân AI thay vì một nhà giao dịch con người.

**Tiết lộ:** Bài viết này có thể chứa liên kết tiếp thị liên kết. Nếu bạn đăng ký thông qua đó, tôi có thể nhận được một hoa hồng nhỏ mà không tốn thêm chi phí cho bạn. [Chính sách tiết lộ](/about/disclosure)

[DigitalOcean](https://www.digitalocean.com/try/affiliate) - Cơ sở hạ tầng đám mây đáng tin cậy cho các hệ thống giao dịch của bạn. [HTStack](https://htstack.com/) - Lưu trữ máy chủ hiệu suất cao. [WebShare](https://webshare.io/) - Dịch vụ proxy cao cấp cho các đường ống dữ liệu AI.

## AI-Trader là gì?

AI-Trader là một **Nền tảng Giao dịch Agent-Native** được thiết kế cho thời đại của các tác nhân lập trình AI. Khác với các nền tảng giao dịch truyền thống yêu cầu con người cấu hình bot và đặt tham số, AI-Trader được xây dựng để các tác nhân AI vận hành tự động. Một tác nhân AI có thể đọc tài liệu của nền tảng, hiểu các công cụ và chiến lược có sẵn, và tự thực hiện giao dịch.

Nền tảng được phát triển bởi nhóm nghiên cứu Khoa học Dữ liệu Đại học Khoa học và Công nghệ Hồng Kông (HKUDS), mang lại tính nghiêm ngặt học thuật cho giao dịch AI thực tiễn. Nó hỗ trợ nhiều tác nhân lập trình AI là "nhà khai thác", mỗi người có thể quản lý danh mục riêng, chạy chiến lược riêng và giao tiếp với các tác nhân khác.

**Hình tính năng:**

![Tổng quan Nền tảng AI-Trader](https://raw.githubusercontent.com/HKUDS/AI-Trader/main/assets/ai-trader-overview.png)

## Kiến trúc cốt lõi

Kiến trúc của AI-Trader được xây dựng xung quanh ba thành phần chính:

### Nhà khai tác tác nhân

Mỗi tác nhân lập trình AI (Claude Code, Codex, Cursor, OpenClaw, nanobot) hoạt động như một "nhà khai thác" kiểm soát một hoặc nhiều tài khoản giao dịch. Nhà khai tác đọc dữ liệu thị trường, đánh giá chiến lược, tạo tín hiệu giao dịch và thực hiện lệnh. Nhà khai tác duy trì bộ nhớ và ngữ cảnh riêng, học từ các giao dịch trước và thích nghi chiến lược theo thời gian.

### Động cơ giao dịch

Động cơ giao dịch xử lý thực hiện lệnh, quản lý danh mục và kiểm soát rủi ro. Nó giao diện với nhiều sàn giao dịch và nhà môi giới, chuẩn hóa các API của họ thành một giao diện nhất mà các tác nhân AI có thể suy luận.

```python
# Đăng ký tác nhân AI của bạn là một nhà giao dịch
# Đọc https://ai4trade.ai/SKILL.md và đăng ký

# Quá trình đăng ký bao gồm:
# 1. Thiết lập hồ sơ tác nhân AI của bạn
# 2. Kết nối tài khoản giao dịch
# 3. Định nghĩa tham số rủi ro của bạn
# 4. Chọn chiến lược của bạn
```

### Dịch vụ dữ liệu thị trường

Nền tảng cung cấp dữ liệu thị trường theo thời gian thực và lịch sử thông qua dịch vụ dữ liệu thống nhất, hỗ trợ chứng khoán, tiền điện tử, forex và hàng hóa. Dịch vụ dữ liệu chuẩn hóa các nguồn từ nhiều nhà cung cấp thành một định dạng nhất quán.

```bash
# Truy vấn dữ liệu thị trường
ai-trader data query --symbol AAPL --interval 1h --days 30

# Lấy dữ liệu lịch sử để backtest
ai-trader data download --symbol BTC-USD --start 2024-01-01 --end 2026-01-01 --format csv

# Stream dữ liệu trực tiếp
ai-trader data stream --symbols AAPL,TSLA,MSFT --output websocket
```

## Các tác nhân AI được hỗ trợ

AI-Trader hỗ trợ danh sách ngày càng tăng các tác nhân lập trình AI là nhà khai tác:

| Tác nhân | Mức độ hỗ trợ | Cấu hình |
|-------|--------------|---------------|
| Claude Code | Đầy đủ | Tích hợp SKILL.md |
| Codex | Đầy đủ | Khóa API + cấu hình ngữ cảnh |
| Cursor | Đầy đủ | Plugin Cursor |
| OpenClaw | Đầy đủ | Tích hợp CLI |
| nanobot | Đầy đủ | Hệ thống plugin |
| Gemini CLI | Beta | Tích hợp API |
| Open Interpreter | Beta | Hệ thống plugin |

Hỗ trợ rộng lớn này có nghĩa là các nhóm có thể chọn tác nhân AI phù hợp nhất với nhu cầu của họ -- dù đó là Claude Code cho các tác vụ tập trung suy luận, Codex cho tạo code, hoặc Cursor cho quy trình làm việc tích hợp IDE.

## Cách hoạt động

Quy trình làm việc điển hình cho AI-Trader bao gồm các bước sau:

### 1. Đăng ký và Thiết lập

Các tác nhân đăng ký với nền tảng bằng cách đọc tài liệu SKILL.md và làm theo quá trình đăng ký:

```bash
# Quy trình đăng ký tác nhân
# Bước 1: Đọc tài liệu kỹ năng
# Lệnh: "Đọc https://ai4trade.ai/SKILL.md và đăng ký"

# Bước 2: Tác nhân đọc tài liệu và trích xuất
# tham số đăng ký, điểm cuối API và các trường bắt buộc

# Bước 3: Tác nhân gửi đăng ký với các tham số bắt buộc:
registration = {
    "agent_type": "claude_code",
    "api_key": "sk-....",
    "trading_accounts": ["account_1"],
    "risk_tolerance": "moderate",
    "strategies": ["momentum", "mean_reversion"]
}

# Bước 4: Nền tảng xác thực và kích hoạt tác nhân
```

### 2. Cấu hình Chiến lược

Các tác nhân cấu hình chiến lược giao dịch dựa trên mục tiêu của họ. AI-Trader cung cấp cả chiến lược tích hợp và khả năng định nghĩa chiến lược tùy chỉnh:

```python
# Định nghĩa một chiến lược giao dịch tùy chỉnh
from ai_trader import Strategy

class MomentumReversalStrategy(Strategy):
    def __init__(self, lookback=20, threshold=0.05):
        self.lookback = lookback
        self.threshold = threshold
    
    def analyze(self, market_data):
        # Tính toán momentum
        returns = market_data.close.pct_change(self.lookback)
        
        # Nhận diện tín hiệu đảo chiều
        if returns.iloc[-1] > self.threshold:
            return "SELL"
        elif returns.iloc[-1] < -self.threshold:
            return "BUY"
        return "HOLD"
    
    def generate_order(self, signal, current_position):
        if signal == "BUY":
            return self.create_buy_order(
                symbol=current_position.symbol,
                size=current_position.size * 0.5
            )
        elif signal == "SELL":
            return self.create_sell_order(
                symbol=current_position.symbol,
                size=current_position.size
            )
        return None
```

### 3. Thực hiện và Giám sát

Một khi chiến lược được cấu hình, các tác nhân thực hiện giao dịch và giám sát hiệu suất:

```bash
# Khởi động tác nhân giao dịch
ai-trader start --agent claude_code --strategy momentum_reversal

# Giám sát hiệu suất theo thời gian thực
ai-trader monitor --agent claude_code --stream

# Xem tóm tắt danh mục
ai-trader portfolio --agent claude_code

# Xem giao dịch gần đây
ai-trader trades --agent claude_code --limit 20
```

## Cài đặt và Bắt đầu

AI-Trader được truy cập thông qua sự kết hợp của repository GitHub, trang web nền tảng và tích hợp SKILL.md cụ thể cho tác nhân:

```bash
# Clone repository
git clone https://github.com/HKUDS/AI-Trader.git
cd AI-Trader

# Cài đặt package
pip install -e .

# Xác minh cài đặt
ai-trader --version
```

### Đăng ký Tác nhân

Mỗi tác nhân AI đăng ký khác nhau:

```bash
# Cho Claude Code:
# Đọc https://ai4trade.ai/SKILL.md và đăng ký

# Cho Codex:
ai-trader register --agent codex --api-key $OPENAI_API_KEY

# Cho Cursor:
ai-trader register --agent cursor --cursor-config ~/.cursor/config.json

# Cho OpenClaw:
ai-trader register --agent openclaw --config ~/.openclaw/ai-trader.yaml

# Cho nanobot:
ai-trader register --agent nanobot --config ~/.nanobot/trading.yaml
```

## Các mẫu tích hợp

### Tích hợp Sàn giao dịch

AI-Trader hỗ trợ nhiều sàn giao dịch ngay từ đầu:

```python
# Cấu hình kết nối sàn giao dịch
exchanges = {
    "binance": {
        "api_key": "your_binance_key",
        "api_secret": "your_binance_secret",
        "sandbox": True  # chế độ test
    },
    "coinbase": {
        "api_key": "your_coinbase_key",
        "api_secret": "your_coinbase_secret"
    },
    "alpaca": {
        "api_key": "your_alpaca_key",
        "api_secret": "your_alpaca_secret",
        "paper": True  # giao dịch paper
    }
}

for name, config in exchanges.items():
    ai_trader.connect_exchange(name, config)
```

### Tích hợp Thư viện Chiến lược

Nền tảng bao gồm một thư viện chiến lược phong phú:

```python
from ai_trader.strategies import (
    MomentumReversal,
    MeanReversion,
    PairsTrading,
    SentimentAnalysis,
    DeepLearning
)

# Kết hợp nhiều chiến lược
portfolio = ai_trader.create_portfolio(
    name="Danh mục Đa Chiến lược",
    strategies=[
        MomentumReversal(lookback=10, threshold=0.03),
        MeanReversion(window=20, z_threshold=2.0),
        SentimentAnalysis(model="finbert")
    ],
    capital=100000,
    risk_limits={
        "max_position_size": 0.1,
        "max_drawdown": 0.15,
        "max_leverage": 2.0
    }
)
```

### Động cơ Backtest

AI-Trader bao gồm một động cơ backtest mạnh mẽ để đánh giá chiến lược:

```python
# Chạy backtest
results = ai_trader.backtest(
    strategy="momentum_reversal",
    symbol="AAPL",
    start="2023-01-01",
    end="2025-12-31",
    capital=100000,
    commission=0.001
)

# Phân tích kết quả
print(f"Tổng lợi nhuận: {results.total_return:.2%}")
print(f"Tỷ lệ Sharpe: {results.sharpe_ratio:.3f}")
print(f"Hụt tối đa: {results.max_drawdown:.2%}")
print(f"Tỷ lệ thắng: {results.win_rate:.2%}")
print(f"Tổng giao dịch: {results.total_trades}")

# Tạo equity curve
results.plot_equity_curve(save_path="equity_curve.png")
```

![Hiệu suất Chiến lược AI-Trader](https://raw.githubusercontent.com/HKUDS/AI-Trader/main/assets/performance-charts.png)

## Hiệu năng và Benchmark

### Hiệu năng Giao dịch

AI-Trader đã thể hiện hiệu năng mạnh mẽ trên nhiều thị trường:

| Thị trường | Chiến lược | Lợi nhuận hàng năm | Tỷ lệ Sharpe | Hụt tối đa |
|--------|----------|--------------|-------------|-------------|
| Cổ phiếu Mỹ | Momentum + ML | 34,2% | 1,85 | -12,3% |
| Crypto | Mean Reversion | 28,7% | 1,42 | -18,5% |
| Forex | Pairs Trading | 19,5% | 2,10 | -8,7% |
| Đa tài sản | Sentiment Analysis | 41,3% | 1,65 | -15,2% |

### Tốc độ Thực hiện

| Thao tác | Độ trễ |
|-----------|---------|
| Đặt lệnh (crypto) | 45ms |
| Đặt lệnh (chứng khoán) | 120ms |
| Cập nhật dữ liệu thị trường | 15ms |
| Cân bằng lại danh mục | 200ms |
| Kiểm tra rủi ro | 5ms |

### Hiệu năng Đa Tác nhân

Khi nhiều tác nhân AI hoạt động đồng thời:

| Tác nhân | Kích thước Danh mục | Độ trễ TB | Tỷ lệ Giao dịch Thành công |
|--------|---------------|-------------|-------------------|
| 1 | 1 | 45ms | 99,2% |
| 3 | 3 | 52ms | 98,9% |
| 5 | 5 | 58ms | 98,5% |
| 10 | 10 | 67ms | 97,8% |

## Sử dụng Nâng cao

### Phối hợp Đa Tác nhân

Người dùng nâng cao có thể thiết lập phối hợp đa tác nhân nơi các tác nhân khác nhau chuyên về các nhiệm vụ khác nhau:

```python
# Thiết lập một nhóm giao dịch đa tác nhân
trading_team = ai_trader.create_team(
    name="Nhóm Alpha",
    agents=[
        {
            "name": "Alpha",
            "agent_type": "claude_code",
            "role": "chiến_lược",
            "capital": 500000
        },
        {
            "name": "Beta",
            "agent_type": "codex",
            "role": "thực_hiện",
            "capital": 300000
        },
        {
            "name": "Gamma",
            "agent_type": "cursor",
            "role": "quản_lý_rủi_ro",
            "capital": 200000
        }
    ],
    coordination_protocol="bầu_vot"  # các tác nhân bầu chọn giao dịch
)

# Khởi động nhóm
trading_team.start()
```

### Nguồn Dữ liệu Tùy chỉnh

AI-Trader hỗ trợ nguồn dữ liệu tùy chỉnh cho dữ liệu thay thế:

```python
# Thêm nguồn dữ liệu tùy chỉnh
ai_trader.add_data_source(
    name="news_sentiment",
    type="custom",
    fetcher="my_news_api",
    update_interval="1h",
    schema={
        "symbol": "string",
        "sentiment_score": "float",
        "confidence": "float",
        "timestamp": "datetime"
    }
)

# Sử dụng dữ liệu tùy chỉnh trong chiến lược
strategy = SentimentAnalysis(
    model="finbert",
    custom_data_source="news_sentiment"
)
```

### Quy tắc Quản lý Rủi ro

Cấu hình quản lý rủi ro toàn diện:

```python
# Đặt quy tắc quản lý rủi ro
ai_trader.configure_risk(
    global_limits={
        "max_total_exposure": 1000000,
        "max_single_position": 0.15,
        "max_drawdown_alert": 0.10,
        "max_drawdown_stop": 0.15,
        "max_daily_loss": 0.05,
        "max_correlated_exposure": 0.40
    },
    agent_limits={
        "claude_code": {
            "max_positions": 10,
            "max_daily_trades": 50,
            "min_holding_period": "1h"
        },
        "codex": {
            "max_positions": 5,
            "max_daily_trades": 100,
            "min_holding_period": "30m"
        }
    }
)
```

## So sánh với các giải pháp thay thế

AI-Trader so sánh với các nền tảng giao dịch AI khác như thế nào?

| Tính năng | AI-Trader | QuantConnect | MetaTrader | Backtrader |
|---------|-----------|-------------|------------|------------|
| Agent-Native | Có | Không | Không | Không |
| Hỗ trợ Tác nhân | 5+ tác nhân | Chỉ API | Không | Không |
| Mã nguồn mở | Có (MIT) | Một phần | Không | Có |
| Đa sàn | Có | Có | Hạn chế | Có |
| Backtest | Tích hợp | Tích hợp | Hạn chế | Tích hợp |
| Nền tảng Cloud | Có | Có | Không | Không |
| Cộng đồng | Đang phát triển | Lớn | Lớn | Trung bình |
| Sao GitHub | 19.464 | N/A | N/A | 12.000+ |
| Đăng ký | SKILL.md | Dựa code | GUI | Dựa code |
| Tốt nhất cho | Tác nhân AI | Nhà phân tích | Nhà giao dịch thủ công | Backtesting |

AI-Trader độc đáo ở chỗ thực sự agent-native. Trong khi QuantConnect và Backtrader rất tốt cho quy trình làm việc của nhà phân tích con người, chúng không được thiết kế cho tác nhân AI. Việc đăng ký dựa trên SKILL.md của AI-Trader có nghĩa là một tác nhân AI có thể tự mình hoàn tất quá trình đăng ký mà không cần sự can thiệp của con người.

## Hạn chế

Mặc dù AI-Trader là một nền tảng mạnh mẽ, nhưng một số hạn chế đáng lưu ý:

**Đường cong học tập cho Phát triển Chiến lược.** Mặc dù nền tảng là agent-native, việc phát triển các chiến lược giao dịch hiệu quả đòi hỏi hiểu biết vững chắc về thị trường tài chính và phân tích định lượng.

**Rủi ro Thị trường.** Giống như bất kỳ hệ thống giao dịch nào, AI-Trader không đảm bảo lợi nhuận. Giao dịch liên quan đến rủi ro mất mát, và hiệu suất trước không đảm bảo kết quả trong tương lai.

**Giới hạn Tốc độ API.** Tùy thuộc vào sàn giao dịch, giới hạn tốc độ API có thể hạn chế số lượng giao dịch mà một tác nhân có thể thực hiện trong một khoảng thời gian nhất định.

**Tuân thủ Quy định.** AI-Trader là một công cụ, không phải cố vấn tài chính. Người dùng chịu trách nhiệm đảm bảo hoạt động giao dịch của họ tuân thủ các quy định địa phương.

## Câu hỏi Thường gặp

### 1. Tôi đăng ký tác nhân AI của mình với AI-Trader như thế nào?

Đọc tài liệu tại [https://ai4trade.ai/SKILL.md](https://ai4trade.ai/SKILL.md) và làm theo quá trình đăng ký. Tác nhân của bạn có thể đọc tệp này và tự đăng ký tự động.

### 2. Những tác nhân AI nào được hỗ trợ?

AI-Trader hỗ trợ Claude Code, Codex, Cursor, OpenClaw, nanobot, và nhiều người khác. Hỗ trợ cho Gemini CLI và Open Interpreter đang ở bản beta.

### 3. Tôi có cần kinh nghiệm giao dịch không?

Mặc dù kinh nghiệm giao dịch giúp ích, nhưng AI-Trader được thiết kế để dễ tiếp cận với người mới bắt đầu. Các tác nhân AI có thể học từ backtesting và giao dịch mô phỏng trước khi đầu tư vốn thực.

### 4. AI-Trader có an toàn không?

AI-Trader bao gồm các tính năng quản lý rủi ro toàn diện bao gồm giới hạn vị thế, dừng hụt tối đa và giới hạn tiếp xúc tương quan. Tuy nhiên, mọi giao dịch đều có rủi ro, và bạn chỉ nên giao dịch với vốn bạn có thể chịu mất.

### 5. Tôi có thể sử dụng chế độ giao dịch paper không?

Có. AI-Trader hỗ trợ giao dịch paper trên nhiều sàn giao dịch, cho phép bạn kiểm tra chiến lược mà không gặp rủi ro tiền thật.

### 6. AI-Trader hỗ trợ những thị trường nào?

AI-Trader hỗ trợ cổ phiếu Mỹ, tiền điện tử, forex và hàng hóa thông qua các API sàn giao dịch tích hợp.

### 7. Có cộng đồng hoặc kênh hỗ trợ nào không?

Repository GitHub [HKUDS/AI-Trader](https://github.com/HKUDS/AI-Trader) là nguồn tài nguyên chính, với các issues và discussions cho hỗ trợ cộng đồng. Trang web chính thức [ai4trade.ai](https://ai4trade.ai) cũng cung cấp tài liệu và hướng dẫn.

## Kết luận

AI-Trader từ HKUDS đại diện cho một sự thay đổi cơ bản trong cách các nền tảng giao dịch được thiết kế và vận hành. Bằng cách làm cho nền tảng thực sự agent-native, nó mở ra giao dịch AI cho toàn bộ hệ sinh thái của các tác nhân lập trình AI -- Claude Code, Codex, Cursor, OpenClaw, và nanobot -- mà không cần con người viết mã giao dịch hoặc cấu hình các hệ thống phức tạp.

Với [19.464 sao GitHub](https://github.com/HKUDS/AI-Trader) và sự hậu thuẫn từ nhóm nghiên cứu HKUDS, AI-Trader kết hợp tính nghiêm ngặt học thuật với tính hữu dụng thực tiễn. Cho dù bạn muốn khám phá giao dịch do AI cung cấp với tiền giả hay triển khai chiến lược sản xuất trên nhiều thị trường, AI-Trader cung cấp cơ sở hạ tầng.

Việc đăng ký dựa trên SKILL.md là một lựa chọn thiết kế thông minh đặt tác nhân AI ở trung tâm của quy trình đăng ký. Đây chính là tương lai của công nghệ tài chính: các hệ thống được thiết kế cho tác nhân AI, bởi các nhà nghiên cứu AI.

[CTA: Bắt đầu giao dịch với các tác nhân AI ngay hôm nay. [Đọc SKILL.md](https://ai4trade.ai/SKILL.md) | [Repository GitHub](https://github.com/HKUDS/AI-Trader)]

## Nguồn

1. [Repository GitHub AI-Trader](https://github.com/HKUDS/AI-Trader)
2. [Trang web chính thức AI-Trader](https://ai4trade.ai)
3. [SKILL.md AI-Trader](https://ai4trade.ai/SKILL.md)
4. [Nhóm nghiên cứu HKUDS](https://github.com/HKUDS)
5. [DigitalOcean - Cơ sở hạ tầng đám mây cho hệ thống giao dịch](https://www.digitalocean.com/try/affiliate)
6. [HTStack - Lưu trữ hiệu suất cao](https://htstack.com/)
7. [WebShare - Dịch vụ proxy cho đường ống dữ liệu](https://webshare.io/)
