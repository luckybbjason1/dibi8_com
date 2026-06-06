---
title: "AI-Trader: 14K⭐ Hệ thống Giao dịch AI Tự động Hoàn toàn, Để AI Giám sát Thị trường 24/7"
description: "AI-Trader là hệ thống đại lý giao dịch AI tự động hoàn toàn mã nguồn mở do HKUDS phát triển, 14K+ Stars, hỗ trợ giao dịch tự động đa thị trường chứng khoán, tiền điện tử, ngoại hối."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Python
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "14.6 MB"
file_md5: ""
download_url: "https://github.com/HKUDS/AI-Trader"
backup_url: ""
github_repo: "https://github.com/HKUDS/AI-Trader"
stars: 18072
maintainer: "HKUDS"
last_maintained: "2026-05-13"
featureImage: ""
draft: false
aliases:
- /vi/posts/ai-trader/
faqs:
  - q: 'AI-Trader của HKUDS là gì?'
    a: 'AI-Trader là hệ thống giao dịch AI tự động hoàn toàn mã nguồn mở, được phát triển bởi Phòng thí nghiệm Khoa học Dữ liệu của Đại học Hồng Kông (HKUDS). Hệ thống sử dụng học tăng cường và cơ chế cộng tác đa tác nhân để giao dịch cổ phiếu, tiền mã hóa, ngoại hối và hợp đồng tương lai, được phát hành theo giấy phép MIT.'
  - q: 'AI-Trader hỗ trợ những thị trường và tài sản nào?'
    a: 'AI-Trader hỗ trợ bốn thị trường: cổ phiếu (Mỹ, Hồng Kông và cổ phiếu hạng A), tiền mã hóa (BTC, ETH và altcoin), ngoại hối (các cặp tiền tệ chính) và hợp đồng tương lai (hàng hóa và chỉ số). Mỗi thị trường áp dụng các loại chiến lược riêng biệt như momentum, theo xu hướng, carry trade và giao dịch chênh lệch giá.'
  - q: 'AI-Trader sử dụng thuật toán học tăng cường nào?'
    a: 'AI-Trader sử dụng Học Tăng cường Sâu (Deep Reinforcement Learning), với PPO (Proximal Policy Optimization) làm thuật toán huấn luyện và mạng LSTM cho mô hình hóa chuỗi thời gian. Các tác nhân được huấn luyện trên dữ liệu thị trường lịch sử trước khi triển khai thực tế.'
  - q: 'Kiến trúc đa tác nhân của AI-Trader được tổ chức như thế nào?'
    a: 'AI-Trader phân chia hoạt động giao dịch thành các tác nhân chuyên biệt: Tác nhân Phân tích (kỹ thuật, cơ bản và tâm lý thị trường), Tác nhân Quyết định lựa chọn mua/bán/giữ, Tác nhân Rủi ro theo dõi rủi ro danh mục và thực hiện cắt lỗ, cùng Tác nhân Thực thi xử lý đặt lệnh và kiểm soát trượt giá.'
  - q: 'Tôi có thể kiểm tra AI-Trader mà không cần dùng tiền thật không?'
    a: 'Hoàn toàn có thể. AI-Trader tích hợp công cụ backtest độ trung thực cao để mô phỏng lịch sử và chế độ giao dịch thử nghiệm (đặt mode: paper trong file cấu hình). Tài liệu dự án khuyến nghị luôn sử dụng chế độ giao dịch thử nghiệm trước khi triển khai vào giao dịch thực tế.'
---
{</* resource-info */>}

## AI-Trader là gì?

**AI-Trader** là hệ thống đại lý giao dịch AI tự động hoàn toàn mã nguồn mở được phát triển bởi **HKUDS** (Phòng thí nghiệm Khoa học Dữ liệu Đại học Hồng Kông). Với **14,311+ GitHub Stars** và **2,418+ Forks**, đây là một trong những hệ thống giao dịch định lượng dựa trên AI tiên tiến nhất năm 2026.

Khác với các bot giao dịch truyền thống dựa vào quy tắc cố định, AI-Trader sử dụng **học tăng cường** và **hợp tác đa tác nhân** để thích ứng với điều kiện thị trường theo thời gian thực.

**GitHub:** [https://github.com/HKUDS/AI-Trader](https://github.com/HKUDS/AI-Trader)

| Chỉ số | Giá trị |
|--------|---------|
| Stars | 14,311+ |
| Forks | 2,418+ |
| Ngôn ngữ | Python |
| Giấy phép | MIT |
| Hôm nay | 189 stars |

## Tại sao AI-Trader khác biệt

### 1. Kiến trúc Gốc Đại lý 100%

Các bot giao dịch truyền thống là "gốc kịch bản" — chúng thực thi các quy tắc được lập trình trước. AI-Trader là "gốc đại lý":

- **Ra quyết định tự chủ** — AI quyết định khi nào mua, bán hoặc giữ
- **Tác nhân phân tích thị trường** — Nhiều tác nhân chuyên môn phân tích các khía cạnh khác nhau (kỹ thuật, cơ bản, tâm lý)
- **Tác nhân quản lý rủi ro** — Các tác nhân chuyên dụng giám sát rủi ro danh mục và thực thi cắt lỗ
- **Tác nhân thực thi** — Xử lý đặt lệnh, kiểm soát trượt giá và tương tác sàn giao dịch

### 2. Hỗ trợ Đa thị trường

| Thị trường | Tài sản | Loại chiến lược |
|------------|---------|-----------------|
| Chứng khoán | Mỹ, Hồng Kông, A-share | Động lượng + Hồi quy trung bình |
| Tiền điện tử | BTC, ETH, altcoin | Theo dõi xu hướng + Chênh lệch giá |
| Ngoại hối | Các cặp tiền chính | Carry trade + Kỹ thuật |
| Hợp đồng tương lai | Hàng hóa, chỉ số | Giao dịch chênh lệch |

### 3. Cốt lõi Học tăng cường

AI-Trader sử dụng **Học tăng cường Sâu (DRL)** để tối ưu hóa chiến lược:

```python
# Vòng lặp huấn luyện đơn giản
from ai_trader import TradingAgent, MarketEnv

env = MarketEnv(market='crypto', assets=['BTC', 'ETH'])
agent = TradingAgent(
    algorithm='PPO',  # Tối ưu hóa Chính sách Xấp xỉ
    network='LSTM',   # Bộ nhớ Ngắn-Dài hạn
    risk_tolerance=0.02  # Tổn thất tối đa 2% mỗi ngày
)

# Huấn luyện trên dữ liệu lịch sử
agent.train(env, episodes=10000, batch_size=64)

# Triển khai giao dịch thực (trước tiên là giao dịch giả lập!)
agent.deploy(mode='paper', exchange='binance')
```

### 4. Hợp tác Đa tác nhân

Hệ thống sử dụng **kiến trúc đa tác nhân phân cấp**:

```
┌─────────────────────────────────────┐
│      Tác nhân Quản lý Danh mục      │
│    (Phân bổ vốn, cân bằng lại)     │
└──────────────┬──────────────────────┘
               │
    ┌──────────┼──────────┐
    │          │          │
┌───▼───┐ ┌───▼───┐ ┌───▼───┐
│Phân   │ │Quản lý│ │Thực   │
│tích   │ │Rủi ro │ │thi    │
│Thị    │ │       │ │Tác    │
│trường │ │       │ │nhân   │
└────────┘ └───────┘ └────────┘
```

## Tính năng Chính

### Phân tích Thị trường Thời gian Thực
- **Chỉ báo kỹ thuật** — 50+ chỉ báo (RSI, MACD, Bollinger Bands, Ichimoku)
- **Phân tích dòng lệnh** — Xử lý dữ liệu Level 2, phát hiện cá voi
- **Phân tích tâm lý** — Điểm tâm lý Twitter, Reddit, tin tức
- **Phân tích on-chain** — Tiền điện tử: Theo dõi ví, dòng chảy sàn giao dịch

### Quản lý Rủi ro
- **Xác định quy mô vị thế** — Tiêu chí Kelly, xác định quy mô dựa trên biến động
- **Cắt lỗ tự động** — Cắt lỗ theo dõi, thoát lệnh theo thời gian
- **Bảo vệ Drawdown** — Tạm dừng tự động khi drawdown vượt ngưỡng
- **Giám sát tương quan** — Tránh tập trung quá mức vào tài sản tương quan

### Công cụ Backtest
- **Mô phỏng lịch sử** — Kiểm tra chiến lược trên 10+ năm dữ liệu
- **Phân tích Walk-forward** — Ngăn ngừa overfitting
- **Mô hình hóa chi phí giao dịch** — Trượt giá, phí, tác động thị trường
- **Mô phỏng Monte Carlo** — Kiểm tra stress với các kịch bản ngẫu nhiên

## Cài đặt

```bash
# Sao chép kho lưu trữ
git clone https://github.com/HKUDS/AI-Trader.git
cd AI-Trader

# Cài đặt phụ thuộc
pip install -r requirements.txt

# Cấu hình khóa API (khuyến nghị giao dịch giả lập cho thử nghiệm)
cp config.example.yaml config.yaml
# Chỉnh sửa config.yaml với khóa API sàn giao dịch của bạn

# Chạy backtest trước
python backtest.py --strategy momentum --market crypto --assets BTC,ETH

# Bắt đầu giao dịch giả lập
python trade.py --mode paper --config config.yaml
```

## Hiệu suất Benchmark

Dựa trên kết quả backtest (2020-2025):

| Chiến lược | Lợi nhuận Hàng năm | Drawdown Tối đa | Tỷ lệ Sharpe |
|------------|-------------------|-----------------|--------------|
| Động lượng | 45.2% | 18.3% | 1.82 |
| Hồi quy trung bình | 32.1% | 12.7% | 1.65 |
| Đa tác nhân | 58.7% | 15.2% | 2.14 |
| Mua & Giữ BTC | 67.3% | 84.2% | 0.89 |

*Tuyên bố miễn trừ: Hiệu suất trong quá khứ không đảm bảo kết quả trong tương lai. Luôn bắt đầu với giao dịch giả lập.*

## Cộng đồng & Tài nguyên

- **GitHub:** [HKUDS/AI-Trader](https://github.com/HKUDS/AI-Trader)
- **Tài liệu:** [https://ai-trader.readthedocs.io](https://ai-trader.readthedocs.io)
- **Discord:** [Tham gia cộng đồng](https://discord.gg/ai-trader)

## Bài viết Liên quan

- [Bot Giao dịch Polymarket: Giao dịch Thị trường Dự đoán Tự động](/vi/resources/dev-utils/polymarket-trading-bot-stack/)
- [Free Claude Code: Trợ lý Lập trình AI Miễn phí](/vi/resources/ai-tools/free-claude-code-open-source-proxy/)
- [Agent Reach: Truy cập Internet của Đại lý AI](/vi/resources/llm-frameworks/agent-reach-ai-agent-internet-access/)

## Tuyên bố Miễn trừ Trách nhiệm

**Giao dịch liên quan đến rủi ro mất mát đáng kể.** AI-Trader chỉ dành cho mục đích giáo dục và nghiên cứu. Luôn:
1. Bắt đầu bằng giao dịch giả lập
2. Không bao giờ rủi ro nhiều hơn số tiền bạn có thể chịu mất
3. Hiểu chiến lược trước khi triển khai
4. Theo dõi hiệu suất thường xuyên
5. Giữ phần mềm được cập nhật

---


---

## Công Cụ Đề Xuất

Cho developer xây dựng hoặc triển khai công cụ AI mã nguồn mở:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 tín dụng miễn phí cho người dùng mới, 14+ region toàn cầu, droplet GPU/CPU một-cú-click cho AI workload.
- **{{< aff "hostinger" "footer-cta-legacy" "Hostinger" >}}** — Lựa chọn VPS giá tốt cho thị trường Việt Nam.

*Affiliate link — không tăng chi phí của bạn nhưng giúp dibi8.com duy trì hoạt động.*

*Cập nhật lần cuối: 2026-05-08 | Stars: 14,311+ | Giấy phép: MIT*

## Công Cụ Đề Xuất

**Trading với AI agent? Vẫn cần portfolio manager cho phần còn lại.**

- **{{< aff "minara" "llm-footer" "Minara AI" >}}** — Ví crypto AI, tự động hóa DCA, rebalancing và cảnh báo on-chain. Pair với AI trader tùy chỉnh để hands-off portfolio management giữa các session strategy active.

*Affiliate link — không tốn thêm chi phí và giúp dibi8.com vận hành.*

