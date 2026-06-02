---
title: 'TradingAgents: Framework Giao Dịch Đa Tác Tử LLM 82.000 Sao — Hướng Dẫn Thực Chiến 2026'
description: 'TradingAgents là framework đa tác tử LLM mã nguồn mở (82,254 GitHub stars, Apache-2.0) mô phỏng một công ty giao dịch: các tác tử phân tích, nghiên cứu, trader và quản trị rủi ro tranh luận ra quyết định BUY/SELL/HOLD. Dựa trên LangGraph. Bao gồm cài đặt, pipeline tác tử, CLI + Python API, và so sánh thẳng thắn với Qlib và bot đơn tác tử.'
date: 2026-06-02
slug: 'tradingagents-llm-multi-agent-trading-framework-2026'
category: 'ai-trading'
tags: ['TradingAgents', 'tác tử LLM', 'giao dịch thuật toán', 'LangGraph', 'đa tác tử', 'AI trading', 'quant', 'AI tài chính']
github_repo: 'https://github.com/TauricResearch/TradingAgents'
stars: 82254
maintainer: 'TauricResearch'
license: Apache-2.0
featureImage: 'https://raw.githubusercontent.com/TauricResearch/TradingAgents/main/assets/schema.png'
lang: vi
---

# TradingAgents: Framework Giao Dịch Đa Tác Tử LLM 82.000 Sao — Hướng Dẫn Thực Chiến 2026

## Giới thiệu

Hầu hết các dự án "bot giao dịch AI" chỉ là một LLM với một prompt bảo "quyết định có nên mua không". Cách đó sụp đổ ngay khi một quyết định thực sự cần kiểm tra cơ bản, quét tin tức, tranh luận tăng-giảm, và một bước phê duyệt rủi ro. Các bàn giao dịch thực không hoạt động như một bộ não — chúng hoạt động như một đội ngũ biết tranh luận.

TradingAgents hiện thực hóa điều đó theo đúng nghĩa đen. Đây là framework mã nguồn mở với **82,254 GitHub stars** và giấy phép **Apache-2.0**, do **TauricResearch** duy trì, mô hình hóa một công ty giao dịch thành một đội các tác tử LLM chuyên biệt — chúng chuyển nghiên cứu dọc theo pipeline và tranh luận trước khi đưa ra quyết định BUY/SELL/HOLD. Hướng dẫn này trình bày cách pipeline tác tử được kết nối, cách cài đặt và chạy (CLI và Python), cùng so sánh thẳng thắn với Qlib và bot đơn tác tử.

![Kiến trúc pipeline tác tử TradingAgents, via dibi8.com](https://raw.githubusercontent.com/TauricResearch/TradingAgents/main/assets/schema.png)

*TradingAgents mô hình hóa một công ty giao dịch: nhà phân tích → nhà nghiên cứu (tăng vs giảm) → trader → đội rủi ro → quản lý danh mục (nguồn: TauricResearch/TradingAgents, via phân tích dibi8)*

## TradingAgents là gì?

TradingAgents là một framework LLM đa tác tử mô phỏng quy trình của một công ty giao dịch thực để tạo ra một quyết định giao dịch có nghiên cứu cho một cổ phiếu và ngày cho trước. Thay vì một mô hình đoán mò, các tác tử chuyên biệt mỗi cái làm một việc, chuyển phát hiện về phía trước, và tranh luận để chốt quyết định.

Đây là một **framework nghiên cứu**, được cộng đồng Tauric Research xây dựng để nghiên cứu cách các tác tử LLM cộng tác trong suy luận tài chính — không phải bot in tiền dùng-ngay, và rõ ràng **không phải lời khuyên đầu tư**. Nó viết bằng Python và xây trên **LangGraph**, thứ điều phối đồ thị tác tử và truyền trạng thái.

## TradingAgents hoạt động thế nào

Framework là một pipeline có hướng gồm các đội tác tử. Mỗi giai đoạn thu hẹp dữ liệu thô thành một quyết định có thể bảo vệ được.

1. **Đội phân tích** — bốn chuyên gia thu thập bằng chứng: nhà phân tích cơ bản (báo cáo tài chính, tỷ số), nhà phân tích tâm lý (tín hiệu mạng xã hội/Reddit), nhà phân tích tin tức (vĩ mô + tin doanh nghiệp), nhà phân tích kỹ thuật (chỉ báo giá như MACD, RSI).
2. **Đội nghiên cứu** — một nhà nghiên cứu phe tăng và một phe giảm tranh luận về phát hiện của nhà phân tích qua vài vòng, làm nổi bật lập luận mạnh nhất mỗi bên.
3. **Trader** — tổng hợp cuộc tranh luận thành một kế hoạch giao dịch cụ thể (hướng + lý do).
4. **Đội quản trị rủi ro** — các tác tử rủi ro tích cực, trung lập và thận trọng kiểm tra áp lực kế hoạch từ các khẩu vị rủi ro khác nhau.
5. **Quản lý danh mục** — phê duyệt hoặc từ chối, tạo ra quyết định cuối cùng **BUY / SELL / HOLD**.

![Đội phân tích TradingAgents, via dibi8.com](https://raw.githubusercontent.com/TauricResearch/TradingAgents/main/assets/analyst.png)

*Đội phân tích thu thập cơ bản, tâm lý, tin tức và kỹ thuật (nguồn: TauricResearch/TradingAgents, via phân tích dibi8)*

Mỗi tác tử là một lệnh gọi LLM với prompt theo vai trò và quyền truy cập công cụ dữ liệu. LangGraph quản lý trạng thái dùng chung để các tác tử sau thấy được đầu ra của tác tử trước.

## Cài đặt & Thiết lập

TradingAgents chạy trên Python 3.10+. Bạn clone repo và cài dependencies; nó cần hai API key — một nhà cung cấp LLM (mặc định OpenAI) và **FinnHub** cho dữ liệu tài chính.

Để chạy TradingAgents như một tác vụ production theo lịch, bạn cần một máy luôn bật — tạo một máy trên [DigitalOcean](https://m.do.co/c/eca87ac14ee0) (tín dụng dùng thử miễn phí cho tài khoản mới), hoặc [HTStack](https://my.htstack.com/aff.php?aff=27187) cho VPS Hong Kong độ trễ thấp (cùng IDC host dibi8.com). Nếu cần VPS giá rẻ để thử nghiệm trước, [Hostinger](https://www.hostinger.com/vn?REFERRALCODE=22RPIAOJIYJN) cũng là lựa chọn hợp lý cho người mới.

```bash
# 1. Clone
git clone https://github.com/TauricResearch/TradingAgents.git
cd TradingAgents

# 2. Môi trường cô lập (conda hoặc venv)
conda create -n tradingagents python=3.10 -y && conda activate tradingagents

# 3. Cài dependencies
pip install -r requirements.txt
```

Thích virtualenv thuần thay vì conda? Cả hai đều được:

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
```

Đặt hai API key bắt buộc làm biến môi trường:

```bash
export OPENAI_API_KEY=sk-your-key-here
export FINNHUB_API_KEY=your-finnhub-key   # bậc miễn phí đủ để test
```

Hoặc giữ trong `.env` cục bộ để khỏi export lại mỗi shell:

```bash
# .env  (đừng bao giờ commit file này)
OPENAI_API_KEY=sk-your-key-here
FINNHUB_API_KEY=your-finnhub-key
```

Nếu thấy `KeyError: 'FINNHUB_API_KEY'`, biến chưa được export trong shell hiện tại. Nếu lệnh gọi LLM trả về 429, bạn bị giới hạn tốc độ phía OpenAI — chậm lại hoặc đổi mô hình trong config (bên dưới).

## Cách dùng cốt lõi

Đường nhanh nhất là CLI tương tác, nó hỏi bạn mã cổ phiếu và ngày rồi stream suy luận của từng tác tử:

```bash
python -m cli.main
```

Để tự động hóa, điều khiển từ Python bằng API `TradingAgentsGraph`. Bạn truyền mã và ngày, nhận lại trạng thái tác tử cùng quyết định cuối:

```python
from tradingagents.graph.trading_graph import TradingAgentsGraph
from tradingagents.default_config import DEFAULT_CONFIG

ta = TradingAgentsGraph(debug=True, config=DEFAULT_CONFIG.copy())
# Phân tích NVDA tại một ngày cụ thể (point-in-time, không nhìn trước)
_, decision = ta.propagate("NVDA", "2024-05-10")
print(decision)   # -> BUY / SELL / HOLD + lý do
```

Bạn kiểm soát chi phí và độ sâu qua config. TradingAgents chia việc giữa một mô hình "deep-thinking" (suy luận nặng) và một mô hình "quick-thinking" (rẻ, gọi nhiều):

```python
config = DEFAULT_CONFIG.copy()
config["llm_provider"] = "openai"
config["deep_think_llm"] = "gpt-4o"        # dùng cho tranh luận / suy luận khó
config["quick_think_llm"] = "gpt-4o-mini"  # dùng cho bước tác tử thường
config["max_debate_rounds"] = 2            # nhiều vòng hơn = sâu hơn nhưng đắt hơn
config["online_tools"] = True              # lấy dữ liệu trực tiếp vs cache
ta = TradingAgentsGraph(debug=True, config=config)
```

Đặt `max_debate_rounds` thấp khi đang học — mỗi vòng thêm nhân lên số lệnh gọi LLM trên toàn đội tác tử.

Bạn cũng có thể chọn chạy nhà phân tích nào, để cắt chi phí khi chỉ quan tâm, ví dụ, cơ bản và tin tức:

```python
config["selected_analysts"] = ["fundamentals", "news"]  # bỏ qua tâm lý + kỹ thuật
ta = TradingAgentsGraph(debug=True, config=config)
```

Để quét một danh sách theo dõi, lặp lệnh gọi qua nhiều mã cho cùng một ngày:

```python
watchlist = ["NVDA", "AAPL", "TSLA"]
for ticker in watchlist:
    _, decision = ta.propagate(ticker, "2024-05-10")
    print(f"{ticker}: {decision.splitlines()[0]}")   # dòng đầu = quyết định
```

Trạng thái trả về chứa toàn bộ cuộc tranh luận để bạn xem *tại sao*, không chỉ *cái gì*:

```python
final_state, decision = ta.propagate("NVDA", "2024-05-10")
print(final_state["investment_debate_state"]["bull_history"])   # lập luận phe tăng
print(final_state["investment_debate_state"]["bear_history"])   # lập luận phe giảm
print(final_state["final_trade_decision"])                       # lý do cuối
```

## Tích hợp

Vì bước quyết định chỉ là một lệnh gọi Python trả về BUY/SELL/HOLD kèm lý do, TradingAgents lắp vào nửa nghiên cứu của pipeline. Nó **không tự đặt lệnh** — bạn nối đầu ra của nó vào lớp thực thi hoặc ghi log của riêng mình:

```python
_, decision = ta.propagate("AAPL", "2024-06-01")
if "BUY" in decision:
    log_signal("AAPL", "BUY", source="tradingagents")
    # chuyển tiếp tới lớp broker / paper-trading của bạn ở đây
```

Lớp dữ liệu cũng có thể thay thế: FinnHub cho cơ bản và tin tức, công cụ giá/chỉ báo cho kỹ thuật, và nguồn mạng xã hội cho tâm lý.

Để tái tạo quyết định mỗi sáng phiên, gói một script trong cron:

```bash
# Chạy quét danh sách theo dõi lúc 08:00 các ngày trong tuần
0 8 * * 1-5 cd /opt/TradingAgents && /opt/.venv/bin/python screen_watchlist.py >> /var/log/ta.log 2>&1
```

Bạn không bị khóa vào OpenAI — trỏ mô hình deep/quick sang nhà cung cấp khác qua cùng config:

```python
config["llm_provider"] = "anthropic"
config["deep_think_llm"] = "claude-sonnet-4-6"
config["quick_think_llm"] = "claude-haiku-4-5"
```

## Benchmark & Sử dụng thực tế

TradingAgents được dùng làm bàn thử nghiệm nghiên cứu: bạn phát lại một ngày lịch sử, để các tác tử suy luận chỉ trên dữ liệu khả dụng khi đó (point-in-time), rồi nghiên cứu quyết định và bản ghi tranh luận. Giá trị thực của nó là **khả năng giải thích** — khác với mô hình hộp đen, mỗi quyết định đi kèm bằng chứng của nhà phân tích và lập luận tăng/giảm, đó là lý do dự án phổ biến để nghiên cứu suy luận LLM trong tài chính hơn là một công cụ kiếm tiền cắm-là-chạy.

![Đội quản trị rủi ro TradingAgents, via dibi8.com](https://raw.githubusercontent.com/TauricResearch/TradingAgents/main/assets/risk.png)

*Đội rủi ro kiểm tra áp lực mọi kế hoạch giao dịch trước khi quản lý danh mục ký duyệt (nguồn: TauricResearch/TradingAgents, via phân tích dibi8)*

Một lần chạy hoàn tất trả về một quyết định kèm chuỗi suy luận — đại khái:

```text
FINAL TRANSACTION PROPOSAL: BUY
Rationale: Nhà phân tích cơ bản nêu doanh thu data-center tăng tốc;
luận điểm phe tăng (mở rộng biên lợi nhuận) thắng phe giảm (định giá) qua 2 vòng;
đội rủi ro: lập trường trung lập, kích thước vị thế thận trọng. Quản lý danh mục: duyệt.
```

Vì bản ghi tranh luận được lưu, bạn có thể so sánh quyết định thay đổi ra sao khi đổi mô hình hoặc thêm vòng tranh luận:

```python
for rounds in (1, 3):
    config["max_debate_rounds"] = rounds
    ta = TradingAgentsGraph(config=config)
    _, d = ta.propagate("NVDA", "2024-05-10")
    print(rounds, "rounds ->", d.splitlines()[0])
```

## So sánh với các lựa chọn thay thế

Xem thêm phần [công cụ mã nguồn mở liên quan](dibi8-internal-link) của chúng tôi.

TradingAgents, Qlib và bot đơn tác tử giải các bài toán khác nhau. Đây là chỗ chúng thực sự khác.

| Tính năng | TradingAgents | Qlib | Bot LLM đơn tác tử |
|---|---|---|---|
| Cách tiếp cận | Tranh luận đa tác tử LLM | Mô hình factor ML | Một LLM + prompt |
| Đơn vị cốt lõi | Tác tử phân tích/nghiên cứu/trader/rủi ro | Tín hiệu LightGBM/LSTM | Một lệnh gọi quyết định |
| Khả năng giải thích | Cao (toàn bộ bản ghi tranh luận) | Trung bình (độ quan trọng đặc trưng) | Thấp |
| Dữ liệu | FinnHub + tin tức + tâm lý + kỹ thuật | DB giá/factor point-in-time | Tùy bạn prompt |
| GitHub stars | 82,254 | 43,948 | đa dạng |
| Xây trên | LangGraph | Python tự viết | đa dạng |
| Phù hợp nhất | Nghiên cứu suy luận LLM cho một giao dịch | Chiến lược cắt ngang ML | Demo nhanh |

Tóm tắt thẳng thắn: nếu bạn muốn tín hiệu **thống kê** trên một rổ cổ phiếu, Qlib sinh ra cho việc đó. Nếu bạn muốn nghiên cứu **một đội LLM suy luận thế nào** tới một quyết định có dấu vết kiểm toán đầy đủ, TradingAgents thú vị hơn. Chúng bổ trợ, không phải đối thủ.

## Hạn chế / Đánh giá thẳng thắn

TradingAgents bao quát nhiều, nhưng không dành cho tất cả, và giả vờ ngược lại chỉ lãng phí thời gian của bạn.

- **Không phải lời khuyên đầu tư, không phải trader thời gian thực.** Nó xuất ra một ý kiến có nghiên cứu; không đặt lệnh và không đảm bảo gì. Repo nói rõ điều đó.
- **Chi phí LLM tích lũy.** Một lần chạy đa tác tử đầy đủ với các vòng tranh luận là nhiều lệnh gọi LLM mỗi mã mỗi ngày. Theo dõi hóa đơn OpenAI.
- **Chất lượng quyết định phụ thuộc mô hình.** Mô hình quick-think rẻ làm giảm chất lượng phân tích; kết quả tốt giả định mô hình deep-think đủ mạnh.
- **Giới hạn dữ liệu.** Bậc FinnHub miễn phí và nguồn tâm lý không đầy đủ; khoảng trống âm thầm làm yếu phân tích.
- **Backtest cẩn thận.** Nó tránh nhìn trước theo ngày, nhưng biến quyết định tác tử thành chiến lược giao dịch có tính phí là việc của bạn, không phải của framework.

Với chiến lược crypto dựa trên AI nói riêng, [Minara](https://minara.ai/r/OSXG4X) (AI + crypto) đi theo hướng khác, và thực thi gốc sàn chạy trên [Binance](https://www.bsmkweb.cc/register?ref=DIBI8).

## Câu hỏi thường gặp

**TradingAgents có miễn phí không?**
Có. Nó là mã nguồn mở theo Apache-2.0 (82,254 GitHub stars). Chi phí thực của bạn là sử dụng API LLM (OpenAI) và bậc dữ liệu trả phí (FinnHub), không phải bản thân framework.

**TradingAgents có đặt lệnh thật không?**
Không. Nó tạo một quyết định BUY/SELL/HOLD kèm lý do. Thực thi lệnh, giới hạn rủi ro, kết nối broker là thứ bạn xây trên đầu ra của nó.

**Tôi cần API key nào?**
Hai: một key nhà cung cấp LLM (mặc định OPENAI_API_KEY) và một FINNHUB_API_KEY cho dữ liệu tài chính. Bậc FinnHub miễn phí đủ để test.

**Một lần phân tích tốn bao nhiêu lệnh gọi LLM?**
Tùy `max_debate_rounds` và mô hình chọn. Mỗi mã/ngày chạy toàn bộ pipeline phân tích → nghiên cứu → trader → rủi ro, nên khi học hãy giảm vòng tranh luận và dùng mô hình quick-think rẻ.

**Cái này khác gì hỏi ChatGPT "có nên mua NVDA"?**
TradingAgents ép buộc suy luận có cấu trúc, đa góc nhìn — nhà phân tích riêng biệt, tranh luận tăng/giảm rõ ràng, và rà soát rủi ro — và trả về toàn bộ bản ghi, thay vì một câu trả lời chưa được kiểm chứng.

## Kết luận

TradingAgents là dự án mã nguồn mở thú vị nhất 2026 để nghiên cứu cách một đội tác tử LLM suy luận tới một quyết định giao dịch — không phải vì nó in tiền, mà vì nó cho thấy quá trình ở từng bước. Dấu vết kiểm toán chính là sản phẩm: bạn thấy chính xác nhà phân tích nào nêu cảnh báo gì, phe tăng và giảm tranh luận ra sao, và đội rủi ro định kích thước vị thế thế nào. Clone nó, chạy một mã qua CLI, và đọc toàn bộ bản ghi tranh luận trước khi tin bất kỳ tín hiệu nào nó tạo ra.

- Tham gia [nhóm Telegram dibi8 tiếng Việt](https://t.me/DIBI8_Group/18) để nhận tin công cụ AI mã nguồn mở và thảo luận quant.
- Đọc tiếp: [các hướng dẫn liên quan trên dibi8](dibi8-internal-link).
- Tạo một máy nghiên cứu trên [DigitalOcean](https://m.do.co/c/eca87ac14ee0) và chạy phân tích đầu tiên tối nay.

---

**Nguồn & Đọc thêm**:
- Kho GitHub: https://github.com/TauricResearch/TradingAgents
- Tài liệu chính thức / README: https://github.com/TauricResearch/TradingAgents#readme
- LangGraph (điều phối): https://github.com/langchain-ai/langgraph

*Một số liên kết bên trên là liên kết tiếp thị. Nếu bạn đăng ký qua các liên kết này, dibi8.com có thể nhận hoa hồng mà bạn không tốn thêm chi phí.*

<!-- internal-link-candidates:
  công cụ mã nguồn mở liên quan -> ai-tools-directory
  các hướng dẫn liên quan trên dibi8 -> ai-coding-agent-landscape-2026-skills-mcp-opensource
-->
