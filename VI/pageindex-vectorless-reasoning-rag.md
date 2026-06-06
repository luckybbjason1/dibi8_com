---
title: "PageIndex：29K⭐Hệ thống RAG cách mạng, tìm kiếm tài liệu không cần vector database"
description: "PageIndex là hệ thống RAG mã nguồn mở không dùng vector của VectifyAI. 29K+ Stars, xây dựng cấu trúc cây tài liệu để tìm kiếm như con người, đạt 98.7% độ chính xác trên FinanceBench."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Go
  - Python
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "23.7 MB"
file_md5: ""
download_url: "https://github.com/VectifyAI/PageIndex"
backup_url: ""
github_repo: "https://github.com/VectifyAI/PageIndex"
stars: 31643
maintainer: "VectifyAI"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /vi/posts/pageindex-vectorless-reasoning-rag/
faqs:
  - q: 'PageIndex là gì và nó khác với RAG truyền thống như thế nào?'
    a: 'PageIndex là một hệ thống RAG mã nguồn mở của VectifyAI, truy xuất thông tin mà không cần cơ sở dữ liệu vector. Thay vì embedding và chia nhỏ (chunking) tài liệu, nó xây dựng một cấu trúc cây phân cấp cho mỗi tài liệu và sử dụng khả năng suy luận của LLM để duyệt qua cây đó, mô phỏng cách một chuyên gia đọc mục lục để tìm ra phần liên quan.'
  - q: 'PageIndex có cần cơ sở dữ liệu vector hay việc chia nhỏ tài liệu không?'
    a: 'Không. PageIndex loại bỏ cả hai. Nó không lưu trữ vector embedding, nhờ đó tránh được chi phí lưu trữ vector đắt đỏ, và nó không chia nhỏ tài liệu, qua đó giữ nguyên cấu trúc logic tự nhiên của tài liệu thay vì cắt xuyên qua nó.'
  - q: 'PageIndex chính xác đến mức nào trên benchmark FinanceBench?'
    a: 'PageIndex kết hợp với GPT-4 đạt độ chính xác 98.7% trên FinanceBench, một kết quả state-of-the-art. PageIndex với Claude-3 đạt 97.2%, trong khi RAG vector truyền thống chỉ đạt khoảng 79-82% trên cùng benchmark này.'
  - q: 'Làm thế nào để cài đặt và chạy một truy vấn cơ bản với PageIndex?'
    a: 'Cài đặt bằng `pip install pageindex`. Sau đó khởi tạo với `pi = PageIndex()`, nạp tài liệu qua `pi.load_pdf("file.pdf")`, và truy vấn bằng `result = pi.query("your question")`. Kết quả bao gồm cả câu trả lời lẫn các nguồn trích dẫn như số trang và chương.'
  - q: 'PageIndex phù hợp nhất với loại tài liệu nào?'
    a: 'PageIndex được thiết kế cho các tài liệu chuyên môn dài, nơi cấu trúc đóng vai trò quan trọng và cần có trích dẫn có thể giải thích được, chẳng hạn như báo cáo tài chính và bản cáo bạch, hợp đồng pháp lý và án lệ, tài liệu y khoa và báo cáo thử nghiệm lâm sàng, cùng các tài liệu kỹ thuật như tài liệu tham khảo API và sổ tay vận hành.'
---
{</* resource-info */>}

![PageIndex — banner chính thức](/images/articles/pageindex-vectorless-reasoning-rag/banner.png)
*Nguồn: [github.com/VectifyAI/PageIndex](https://github.com/VectifyAI/PageIndex) — banner chính thức*

## PageIndex là gì?

**PageIndex** là hệ thống RAG (Retrieval-Augmented Generation) mã nguồn mở được phát triển bởi **VectifyAI**, thay đổi hoàn toàn cách thức tìm kiếm tài liệu truyền thống. Khác với cơ sở dữ liệu vector truyền thống, PageIndex sử dụng phương pháp **dựa trên suy luận**, xây dựng **cấu trúc cây phân cấp** của tài liệu để tìm kiếm như con người.

- 🌲 **Cây lập chỉ mục** — Tổ chức tài liệu như mục lục
- 🧠 **Tìm kiếm dựa trên suy luận** — LLM suy luận thay vì độ tương đồng vector
- ❌ **Không cần vector database** — Tiết kiệm chi phí lưu trữ vector đắt đỏ
- ❌ **Không cần chunking** — Giữ nguyên cấu trúc tự nhiên của tài liệu
- 📊 **98.7% độ chính xác** — SOTA trên bài kiểm tra FinanceBench

GitHub: https://github.com/VectifyAI/PageIndex  
Stars: **29.202+** | Ngôn ngữ: Python | Giấy phép: Apache-2.0

---

## Tại sao RAG truyền thống không đủ tốt?

### Vấn đề của RAG vector truyền thống

| Vấn đề | Giải thích |
|--------|-----------|
| **Tương đồng ≠ Liên quan** | Tìm kiếm vector tìm thấy những gì ngữ nghĩa tương tự, nhưng không nhất thiết là thực sự liên quan |
| **Chunking phá hủy cấu trúc** | Chia nhỏ bắt buộc làm đứt gãy cấu trúc logic của tài liệu |
| **Tìm kiếm hộp đen** | Tìm kiếm vector không thể giải thích, không thể truy vết tại sao trả về kết quả này |
| **Chi phí cao** | Cần duy trì cơ sở dữ liệu vector, chi phí lưu trữ và tính toán cao |
| **Tài liệu dài kém hiệu quả** | Độ chính xác tìm kiếm tài liệu chuyên nghiệp dài (báo cáo tài chính, tài liệu pháp lý) thấp |

### Giải pháp của PageIndex

PageIndex mô phỏng cách **chuyên gia con người** đọc tài liệu:
1. Xem cấu trúc mục lục trước (cây lập chỉ mục)
2. Suy luận nên đi đến chương nào dựa trên câu hỏi
3. Tìm kiếm sâu trong chương liên quan

---

## Nguyên lý công nghệ cốt lõi

### 1. Tạo cấu trúc cây tài liệu

PageIndex chuyển đổi PDF thành cấu trúc cây phân cấp:

```json
{
  "title": "Financial Stability",
  "node_id": "0006",
  "start_index": 21,
  "end_index": 22,
  "summary": "The Federal Reserve monitors financial vulnerabilities...",
  "nodes": [
    {
      "title": "Monitoring Financial Vulnerabilities",
      "node_id": "0007",
      "start_index": 22,
      "end_index": 28
    },
    {
      "title": "Domestic and International Cooperation",
      "node_id": "0008",
      "start_index": 28,
      "end_index": 31
    }
  ]
}
```

### 2. Tìm kiếm cây dựa trên suy luận

Khi người dùng đặt câu hỏi, LLM sẽ:
1. **Hiểu câu hỏi** — Phân tích ý định truy vấn
2. **Duyệt cấu trúc cây** — Suy luận nút nào có thể chứa câu trả lời
3. **Tìm kiếm sâu trong nút liên quan** — Tìm thông tin cụ thể trong nút ứng viên
4. **Trả về kết quả** — Kèm theo trích dẫn nguồn (số trang, chương)

### 3. Tìm kiếm cây Monte Carlo tương tự AlphaGo

PageIndex lấy cảm hứng từ AlphaGo, sử dụng **thuật toán tìm kiếm cây**:
- **Chọn** — Chọn nút hứa hẹn nhất
- **Mở rộng** — Mở rộng nút con
- **Đánh giá** — LLM đánh giá mức độ liên quan của nút
- **Lan truyền ngược** — Cập nhật trọng số nút

---

## Bắt đầu nhanh

### Cài đặt

```bash
# Clone repository
git clone https://github.com/VectifyAI/PageIndex.git
cd PageIndex

# Cài đặt dependencies
pip3 install --upgrade -r requirements.txt
```

### Cấu hình API Key

```bash
# Tạo file .env
echo "OPENAI_API_KEY=your_openai_key_here" > .env
```

### Tạo cây tài liệu

```bash
# Tạo cấu trúc cây PageIndex cho PDF
python3 run_pageindex.py --pdf_path /path/to/your/document.pdf
```

### Tham số tùy chọn

```bash
--model                  # Mô hình LLM (mặc định: gpt-4o-2024-11-20)
--toc-check-pages       # Số trang kiểm tra mục lục (mặc định: 20)
--max-pages-per-node    # Số trang tối đa mỗi nút (mặc định: 10)
--max-tokens-per-node   # Số token tối đa mỗi nút (mặc định: 20000)
--if-add-node-summary   # Thêm tóm tắt nút (mặc định: yes)
```

---

## Ví dụ thực tế

### Ví dụ 1: Phân tích tài liệu tài chính

```python
from pageindex import PageIndex

# Tải cây tài liệu
pi = PageIndex(tree_path="financial_report.json")

# Truy vấn
result = pi.query(
    "Tốc độ tăng trưởng doanh thu Q3 là bao nhiêu?",
    top_k=3
)

print(result.answer)
# "Doanh thu Q3 tăng 23% so với cùng kỳ năm ngoái, doanh thu từ dịch vụ đám mây..."

print(result.sources)
# [{"page": 45, "section": "Financial Results", "node_id": "0012"}]
```

### Ví dụ 2: Xem xét hợp đồng pháp lý

```python
# Tải tài liệu hợp đồng
pi = PageIndex(tree_path="contract.pdf.json")

# Truy vấn điều khoản cụ thể
result = pi.query(
    "Điều kiện chấm dứt trong Điều 7 là gì?"
)

# PageIndex sẽ tự động định vị chương liên quan
```

### Ví dụ 3: Nghiên cứu bài báo học thuật

```python
# Tải bài báo
pi = PageIndex(tree_path="paper.pdf.json")

# Truy vấn suy luận xuyên chương
result = pi.query(
    "Phương pháp luận trong Chương 3 liên quan thế nào đến kết quả trong Chương 5?"
)

# PageIndex sẽ duyệt cấu trúc cây để tìm thông tin liên quan
```

---

## So sánh với đối thủ

| Đặc tính | PageIndex | RAG vector truyền thống | LlamaIndex | LangChain |
|----------|-----------|------------------------|------------|-----------|
| Vector database | ❌ Không cần | ✅ Bắt buộc | ✅ Bắt buộc | ✅ Bắt buộc |
| Chunking | ❌ Không cần | ✅ Bắt buộc | ✅ Bắt buộc | ✅ Bắt buộc |
| Dựa trên suy luận | ✅ | ❌ | ❌ | ❌ |
| Khả năng giải thích | ✅ Có thể truy vết | ❌ Hộp đen | ⚠️ Một phần | ⚠️ Một phần |
| Tài liệu dài | ✅ Xuất sắc | ⚠️ Bình thường | ⚠️ Bình thường | ⚠️ Bình thường |
| Tài liệu chuyên nghiệp | ✅ Xuất sắc | ⚠️ Bình thường | ⚠️ Bình thường | ⚠️ Bình thường |
| Độ chính xác | ✅ 98.7% | ~75% | ~80% | ~78% |

---

## Mô hình kinh doanh và cơ hội kiếm tiền

### 1. Phân tích tài liệu doanh nghiệp

Giấy phép Apache-2.0 của PageIndex cho phép sử dụng thương mại:
- **Phân tích tài chính** — Phân tích tự động báo cáo tài chính, hồ sơ SEC
- **Tư vấn pháp lý** — Xem xét hợp đồng, nghiên cứu vụ án
- **Tài liệu y tế** — Phân tích hồ sơ bệnh án, tài liệu y khoa
- **Tài liệu chính phủ** — Phân tích chính sách, tìm kiếm quy định

### 2. Xây dựng sản phẩm SaaS

Xây dựng dựa trên PageIndex:
- **Nền tảng Q&A tài liệu thông minh**
- **Hệ thống cơ sở tri thức doanh nghiệp**
- **Trình tạo báo cáo tự động**
- **Công cụ xem xét tuân thủ**

### 3. Dịch vụ tư vấn

Cung cấp liên quan đến PageIndex:
- **Tư vấn kỹ thuật**
- **Phát triển tùy chỉnh**
- **Dịch vụ đào tạo**

---

## Hiệu suất benchmark

### Kết quả FinanceBench

| Hệ thống | Độ chính xác |
|----------|-------------|
| **PageIndex (Mafin 2.5)** | **98.7%** |
| RAG vector truyền thống | ~75% |
| Giải pháp thương mại khác | ~80% |

PageIndex đạt **state-of-the-art** trong Q&A tài liệu tài chính, chứng minh ưu thế của tìm kiếm dựa trên suy luận.

---

## Tùy chọn triển khai

### 1. Tự lưu trữ (mã nguồn mở)

```bash
git clone https://github.com/VectifyAI/PageIndex.git
pip3 install -r requirements.txt
python3 run_pageindex.py --pdf_path your.pdf
```

Phù hợp: Đội ngũ kỹ thuật, kịch bản nhạy cảm với dữ liệu

### 2. Dịch vụ đám mây

- **Nền tảng Chat**: https://chat.pageindex.ai
- **API**: https://pageindex.ai/developer
- **Tích hợp MCP**: Hỗ trợ Claude, Cursor, v.v.

Phù hợp: Khởi động nhanh, môi trường production

### 3. Phiên bản doanh nghiệp

- Triển khai private
- Đường ống OCR tùy chỉnh
- Hỗ trợ chuyên dụng

---

## Cộng đồng và tài nguyên

- **GitHub**: https://github.com/VectifyAI/PageIndex
- **Tài liệu**: https://docs.pageindex.ai
- **Blog**: https://pageindex.ai/blog
- **Discord**: https://discord.com/invite/VuXuf29EUj
- **API**: https://pageindex.ai/developer

---

## Tóm tắt

PageIndex là sự tiến hóa thế hệ tiếp theo của công nghệ RAG:

✅ **29K+ Stars** — Cộng đồng công nhận  
✅ **Không cần vector DB** — Tiết kiệm chi phí cơ sở hạ tầng đắt đỏ  
✅ **Dựa trên suy luận** — Thực sự hiểu cấu trúc tài liệu  
✅ **98.7% độ chính xác** — Dẫn đầu ngành  
✅ **Có thể giải thích** — Mọi tìm kiếm đều có thể truy vết  
✅ **Mã nguồn mở** — Apache-2.0, thân thiện thương mại  

**Phù hợp với ai?**
- Nhà phân tích tài chính: Xử lý báo cáo tài chính, hồ sơ SEC
- Cố vấn pháp lý: Xem xét hợp đồng, quy định
- Nhà nghiên cứu: Phân tích bài báo, tài liệu
- Nhà phát triển: Xây dựng ứng dụng AI tài liệu

**Bắt đầu ngay**: https://github.com/VectifyAI/PageIndex

---

## Related Articles

- [Goose AI Agent: AI Agent mã nguồn mở cho code và tự động hóa](/vi/resources/llm-frameworks/goose-ai-agent-open-source-automation/) — Công cụ AI mã nguồn mở khác
- [Free Claude Code: Sử dụng Claude Code CLI miễn phí với bất kỳ nhà cung cấp AI nào](/vi/resources/ai-tools/free-claude-code-open-source-proxy/) — Công cụ AI coding
- [Agent Reach: Kết nối AI Agent của bạn với Internet](/vi/resources/llm-frameworks/agent-reach-ai-agent-internet-access/) — Kết nối AI với internet
- [42 Real-World OpenClaw Use Cases: Cách mọi người sử dụng AI Agent trong cuộc sống hàng ngày](/vi/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/) — Trường hợp sử dụng AI Agent

---


---

## Hạ Tầng Đề Xuất Cho Tự Lưu Trữ

Để chạy stack này 24/7 ổn định, lựa chọn hạ tầng rất quan trọng:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 tín dụng miễn phí 60 ngày, 14+ region toàn cầu. Lựa chọn mặc định cho developer độc lập.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — VPS Hong Kong, độ trễ thấp với người dùng Việt Nam. dibi8.com cũng được host ở đây.
- **{{< aff "hostinger" "footer-cta-legacy" "Hostinger" >}}** — Lựa chọn VPS giá tốt cho thị trường Việt Nam, giảm 60% gói đầu tiên.

*Đây là affiliate link, không phát sinh chi phí thêm cho bạn nhưng giúp dibi8.com duy trì hoạt động.*

*Last updated: 2026-05-07*
