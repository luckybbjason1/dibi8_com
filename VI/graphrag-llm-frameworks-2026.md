---
title: 'GraphRAG: Hệ RAG dựa trên đồ thị tri thức của Microsoft cho câu trả lời LLM tốt hơn (33K Stars) — Hướng dẫn thực chiến 2026'
description: 'GraphRAG là hệ thống RAG mô-đun, dựa trên đồ thị tri thức của Microsoft (33.403 sao GitHub, giấy phép MIT). Hướng dẫn này trình bày cách cài đặt, quy trình init/index/query, ví dụ CLI thực tế và so sánh thẳng thắn với LangChain và Haystack.'
date: 2026-06-02 00:00:00+08:00
lastmod: 2026-06-02 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'microsoft/graphrag'
stars: 33403
maintainer: 'microsoft'
last_maintained: '2026-06-02'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: []
aliases:
- /posts/graphrag-llm-frameworks-2026/
faqs:
  - q: 'Cài graphrag thế nào?'
    a: 'Cài từ PyPI chỉ với một lệnh (Python 3.10–3.12): ```bash pip install graphrag ```'
  - q: 'Yêu cầu hệ thống để chạy graphrag là gì?'
    a: 'GraphRAG cần Python 3.10–3.12 và quyền truy cập một mô hình ngôn ngữ (OpenAI, Azure OpenAI hoặc nhà cung cấp được hỗ trợ khác) qua khóa API. Nó chạy trên mọi hệ điều hành hiện đại hỗ trợ Python.'
  - q: 'Tôi có thể đóng góp cho dự án không?'
    a: 'Có. Dự án là mã nguồn mở theo giấy phép MIT và hoan nghênh đóng góp. Xem hướng dẫn ở tệp [CONTRIBUTING.md](https://github.com/microsoft/graphrag/blob/main/CONTRIBUTING.md) trên GitHub.'
  - q: 'Báo lỗi hoặc sự cố thế nào?'
    a: 'Dùng trang GitHub Issues của kho mã. Hãy đưa càng nhiều chi tiết càng tốt — thông báo lỗi, cấu hình của bạn và các bước tái hiện vấn đề.'
  - q: 'GraphRAG khác RAG vector thông thường ở điểm nào?'
    a: 'RAG thông thường lấy về vài đoạn tương đồng rồi trả lời dựa trên đó. GraphRAG còn xây thêm một đồ thị tri thức và các bản tóm tắt cộng đồng từ tài liệu của bạn, nhờ đó nó trả lời được cả câu hỏi rộng bao trùm cả kho (tìm kiếm toàn cục) lẫn câu hỏi tập trung vào thực thể (tìm kiếm cục bộ).'
---

{{< resource-info >}}

## Giới thiệu

RAG (Sinh có tăng cường bằng truy xuất) cổ điển lấy về một vài đoạn văn bản theo độ tương đồng vector rồi nhồi vào prompt. Cách này ổn với các câu hỏi tra cứu sự kiện, nhưng đuối sức với những câu hỏi kiểu "nối các mảnh thông tin lại" trải dài khắp một kho tài liệu. `graphrag` của Microsoft đi một hướng khác: nó dùng LLM để trích xuất một **đồ thị tri thức** gồm các thực thể và quan hệ từ tài liệu của bạn, xây dựng các bản tóm tắt cộng đồng trên đồ thị đó, rồi trả lời câu hỏi dựa vào cấu trúc này. Với hơn 33.403 sao trên GitHub và giấy phép MIT, đây là một trong những dự án RAG được theo dõi nhiều nhất hai năm qua. Hướng dẫn này sẽ dẫn bạn cài đặt GraphRAG, chạy đúng quy trình `init` / `index` / `query` thực tế của nó, và đánh giá thẳng thắn xem nó có hợp với bài toán của bạn hay không.

## graphrag là gì?

GraphRAG là một pipeline RAG mô-đun, dựa trên đồ thị. Thay vì coi tài liệu như một đống đoạn rời rạc, nó dùng mô hình ngôn ngữ đọc văn bản, rút ra các thực thể và quan hệ giữa chúng, rồi ráp lại thành một đồ thị tri thức. Sau đó nó gom cụm đồ thị thành các cộng đồng và sinh bản tóm tắt cho từng cộng đồng.

Dự án do Microsoft Research bảo trì và được viết bằng Python. Nó được phát hành dưới dạng công cụ dòng lệnh và thư viện Python, cấu hình qua một tệp `settings.yaml`. Kết quả là một hệ thống có thể trả lời những câu hỏi rộng, bao trùm cả kho tài liệu ("Các chủ đề chính xuyên suốt những tài liệu này là gì?") — vốn là điều mà RAG vector thông thường hay bỏ sót.

## graphrag hoạt động thế nào

GraphRAG chia bài toán thành giai đoạn lập chỉ mục ngoại tuyến và giai đoạn truy vấn trực tuyến:

1. **Lập chỉ mục**: GraphRAG chia nhỏ tài liệu nguồn, rồi yêu cầu LLM trích xuất thực thể, quan hệ và luận điểm từ mỗi đoạn. Những thứ này được hợp nhất thành một đồ thị tri thức duy nhất. Đồ thị được phân hoạch thành các cộng đồng (bằng thuật toán Leiden), và LLM viết một báo cáo tóm tắt cho mỗi cộng đồng.

2. **Truy vấn — Tìm kiếm toàn cục (Global Search)**: Với câu hỏi rộng về toàn bộ kho tài liệu, GraphRAG dùng các bản tóm tắt cộng đồng theo kiểu map-reduce: nó suy luận trên nhiều báo cáo cộng đồng, rồi gộp các câu trả lời thành phần thành câu trả lời cuối cùng.

3. **Truy vấn — Tìm kiếm cục bộ (Local Search)**: Với câu hỏi xoay quanh một thực thể cụ thể, GraphRAG lấy về các thực thể lân cận, quan hệ và đoạn văn bản gốc liên quan, rồi sinh câu trả lời tập trung.

Chính thiết kế hai chế độ này tách GraphRAG khỏi một kho vector thông thường: tìm kiếm toàn cục cho bạn bức tranh tổng thể, tìm kiếm cục bộ cho bạn chi tiết.

## Cài đặt & Thiết lập

Để chạy graphrag như một tác vụ sản xuất theo lịch, bạn cần một máy luôn bật — dựng một máy trên [DigitalOcean](https://m.do.co/c/eca87ac14ee0) (tài khoản mới có tín dụng dùng thử miễn phí), hoặc [HTStack](https://my.htstack.com/aff.php?aff=27187) để có VPS Hồng Kông độ trễ thấp (cùng IDC đang host dibi8.com).

GraphRAG cần Python 3.10–3.12. Cách cài đặt được khuyến nghị là dùng pip:

```bash
pip install graphrag
```

Sau khi cài, bạn khởi tạo một workspace. Bước này tạo ra các tệp cấu hình và cấu trúc thư mục mà GraphRAG cần:

```bash
mkdir -p ./ragtest/input
# put your .txt or .csv documents into ./ragtest/input
python -m graphrag init --root ./ragtest
```

Lệnh `init` sinh ra một `settings.yaml` và một tệp `.env` ở thư mục gốc dự án. Mở `.env` và đặt khóa API mô hình của bạn, ví dụ:

```bash
GRAPHRAG_API_KEY=<your-openai-or-azure-key>
```

### Lỗi thường gặp và cách khắc phục

Sự cố hay gặp nhất ở lần chạy đầu là thiếu hoặc rỗng khóa API. Nếu việc lập chỉ mục thất bại ngay lập tức với lỗi xác thực, hãy kiểm tra rằng `GRAPHRAG_API_KEY` đã được đặt trong `./ragtest/.env`, và tên các mô hình trong `settings.yaml` đúng là những mô hình mà khóa của bạn thực sự truy cập được. Đổi mô hình đã cấu hình sang mô hình có sẵn trong tài khoản của bạn thường sẽ khắc phục được.

## Cách dùng cốt lõi

Sau `init`, quy trình điển hình là: bỏ tài liệu vào thư mục input, dựng chỉ mục, rồi truy vấn.

### Bước 1: Dựng chỉ mục

Chạy pipeline lập chỉ mục trên workspace của bạn. Đây là bước tốn kém nhất — nó gọi LLM rất nhiều lần để trích xuất đồ thị:

```bash
python -m graphrag index --root ./ragtest
```

Khi hoàn tất, GraphRAG ghi đồ thị thực thể, báo cáo cộng đồng và embedding dưới dạng các tệp Parquet trong `./ragtest/output`.

### Bước 2: Tìm kiếm toàn cục

Dùng tìm kiếm toàn cục cho các câu hỏi rộng, bao trùm cả kho tài liệu, đòi hỏi tổng hợp từ nhiều tài liệu:

```bash
python -m graphrag query \
  --root ./ragtest \
  --method global \
  --query "What are the major themes in these documents?"
```

### Bước 3: Tìm kiếm cục bộ

Dùng tìm kiếm cục bộ khi câu hỏi xoay quanh một thực thể cụ thể hoặc một phần hẹp của kho tài liệu:

```bash
python -m graphrag query \
  --root ./ragtest \
  --method local \
  --query "What is the relationship between Entity A and Entity B?"
```

Ba lệnh này — `init`, `index` và `query` — bao trọn vòng lặp cốt lõi của GraphRAG. Về các tùy chọn cấu hình, tinh chỉnh prompt và thiết lập nâng cao, xem tài liệu chính thức: [https://microsoft.github.io/graphrag/](https://microsoft.github.io/graphrag/)

## Tích hợp

Vì việc lập chỉ mục tạo ra các tệp Parquet thuần (thực thể, quan hệ, báo cáo cộng đồng và embedding của các đơn vị văn bản), GraphRAG tích hợp gọn gàng với phần còn lại của hệ sinh thái dữ liệu Python.

### Làm việc với đầu ra

Bạn có thể nạp trực tiếp đồ thị và báo cáo đã sinh bằng pandas để kiểm tra, truy xuất tùy chỉnh hay phân tích phía sau:

```python
import pandas as pd

entities = pd.read_parquet("./ragtest/output/entities.parquet")
relationships = pd.read_parquet("./ragtest/output/relationships.parquet")
community_reports = pd.read_parquet("./ragtest/output/community_reports.parquet")

print(entities.head())
print(community_reports[["title", "summary"]].head())
```

### Tùy chỉnh bằng settings.yaml

Hành vi của GraphRAG được điều khiển qua tệp `settings.yaml` mà `init` tạo ra. Ở đó bạn chọn mô hình chat và mô hình embedding, đặt kích thước đoạn (chunk), tinh chỉnh mức song song và trỏ tới dữ liệu đầu vào. Một đoạn trích đơn giản hóa trông như sau:

```yaml
models:
  default_chat_model:
    type: openai_chat
    model: gpt-4o-mini
  default_embedding_model:
    type: openai_embedding
    model: text-embedding-3-small

chunks:
  size: 1200
  overlap: 100

input:
  type: file
  file_type: text
  base_dir: "input"
```

Chỉnh sửa tệp này chính là cách bạn điều chỉnh GraphRAG cho phù hợp với nhà cung cấp mô hình khác, loại tài liệu khác hay chiến lược chia đoạn khác — không cần đụng tới mã nguồn.

## Ứng dụng thực tế

GraphRAG, do Microsoft Research phát triển dưới giấy phép MIT, đã được dùng cho các tải công việc về cơ sở tri thức, nghiên cứu và phân tích — nơi câu hỏi trải khắp cả kho tài liệu chứ không gói gọn trong một tài liệu.

### Nơi nó tỏa sáng

Cách tiếp cận "đồ thị cộng với tóm tắt cộng đồng" có giá trị nhất khi bạn cần "tạo nghĩa (sensemaking)" trên một khối văn bản lớn — chẳng hạn tóm tắt các chủ đề xuyên suốt một tập báo cáo, truy vết cách các thực thể liên hệ qua nhiều tài liệu, hay trả lời những câu hỏi có bằng chứng nằm rải rác khắp kho. Trong những tình huống đó, tìm kiếm toàn cục của GraphRAG thường cho câu trả lời đầy đủ hơn so với RAG vector cơ bản vốn chỉ thấy vài đoạn top-k.

### Ý thức về chi phí

Lập chỉ mục ngốn LLM: GraphRAG gọi mô hình lặp đi lặp lại để trích xuất thực thể, quan hệ và viết báo cáo cộng đồng, nên chi phí tăng theo quy mô kho tài liệu và mô hình bạn chọn. Nhiều nhóm bắt đầu với một mô hình chat nhỏ và rẻ hơn (như `gpt-4o-mini`) để kiểm soát chi phí lập chỉ mục, rồi mới đánh giá xem một mô hình mạnh hơn có đáng giá với dữ liệu của họ không.

## So sánh với các lựa chọn thay thế

Xem thêm bài viết của chúng tôi về [các công cụ mã nguồn mở liên quan](dibi8-internal-link).

GraphRAG, LangChain và Haystack giải những bài toán chồng lấn nhưng khác trọng tâm. GraphRAG là một pipeline RAG đồ thị tập trung và có chủ kiến rõ ràng; LangChain và Haystack là các framework đa dụng để xây dựng đủ loại ứng dụng LLM và pipeline RAG. Bảng dưới chỉ để định hướng sơ bộ, không phải so kè trực tiếp — số sao và số issue thay đổi theo thời gian, nên hãy xem là con số gần đúng.

| Đặc điểm | **GraphRAG** | **LangChain** | **Haystack** |
|---|---|---|---|
| Trọng tâm chính | Pipeline RAG dựa trên đồ thị | Framework ứng dụng LLM đa dụng | Framework RAG / tìm kiếm |
| Ngôn ngữ | Python | Python | Python |
| Giấy phép | MIT | MIT | Apache-2.0 |
| Đơn vị bảo trì | Microsoft | LangChain, Inc. | deepset |
| Trích xuất đồ thị tri thức tích hợp | Tích hợp sẵn | Qua tích hợp | Qua tích hợp |
| Truy vấn toàn cục (cả kho) | Có | Không tích hợp sẵn | Không tích hợp sẵn |
| Độ rộng dùng được ngay | Hẹp (chỉ RAG đồ thị) | Rất rộng | Rộng |
| Tài liệu | Đầy đủ | Đầy đủ | Đầy đủ |

### Vì sao chọn GraphRAG?

- **Sinh ra cho câu hỏi cả kho tài liệu**: Tìm kiếm toàn cục và tóm tắt cộng đồng được thiết kế cho các câu hỏi kiểu "xuyên suốt mọi thứ có những chủ đề nào?" mà RAG vector thuần xử lý kém.
- **Trích xuất đồ thị đi kèm sẵn**: Trích xuất thực thể và quan hệ là một phần của pipeline, không phải thứ bạn phải tự ráp.
- **Có Microsoft Research chống lưng**: Phát triển tích cực, tài liệu vững và dòng cải tiến dựa trên nghiên cứu đều đặn.

### Điều cần cân nhắc

Nếu bạn chỉ cần truy xuất top-k cho các câu trả lời sự kiện ngắn, một framework đa dụng như LangChain hay Haystack kèm một kho vector sẽ nhẹ hơn và rẻ hơn để vận hành. Chi phí lập chỉ mục tăng thêm của GraphRAG chỉ xứng đáng khi chính *cấu trúc* của kho tài liệu mới quan trọng đối với câu trả lời.

## Hạn chế & Đánh giá thẳng thắn

GraphRAG là công cụ mạnh cho đúng việc, nhưng nó có những đánh đổi thực sự:

1. **Lập chỉ mục tốn kém**: Dựng đồ thị gọi LLM rất nhiều, nên cả chi phí lẫn thời gian đều tăng theo quy mô kho tài liệu. Đây là yếu tố lớn nhất cần dự trù ngân sách.
2. **Cấu hình tốn công**: Để có kết quả tốt thường phải tinh chỉnh kích thước đoạn, prompt và lựa chọn mô hình trong `settings.yaml`. Đây không phải giải pháp cắm-là-chạy một dòng.
3. **Quá mức cho tra cứu đơn giản**: Với hỏi-đáp hẹp mà câu trả lời nằm trong một đoạn, RAG vector cổ điển nhanh hơn và rẻ hơn nhiều.
4. **Gánh nặng vận hành**: Bạn phải quản lý một pipeline lập chỉ mục cùng các đầu ra Parquet của nó, cộng thêm việc lập chỉ mục lại định kỳ khi tài liệu thay đổi.
5. **Chất lượng phụ thuộc mô hình**: Chất lượng trích xuất thực thể và quan hệ đi theo độ mạnh của mô hình chat bạn cấu hình, gắn chất lượng câu trả lời trực tiếp với ngân sách mô hình của bạn.

Những đánh đổi này chính là điều then chốt cần cân nhắc khi quyết định GraphRAG có hợp với bài toán cụ thể của bạn hay không.

## Kết luận

GraphRAG là một hệ thống RAG mô-đun, dựa trên đồ thị, được bảo trì tốt từ Microsoft Research, với hơn 33.403 sao trên GitHub, viết bằng Python và dùng giấy phép MIT. Điểm mạnh của nó là trả lời những câu hỏi mà bằng chứng nằm rải rác khắp cả kho tài liệu — đúng chỗ RAG vector thuần còn yếu. Đánh đổi là chi phí lập chỉ mục và công sức cấu hình. Một bước tiếp theo hợp lý là chạy `python -m graphrag init` trên một bộ tài liệu nhỏ và so câu trả lời tìm kiếm toàn cục với thiết lập RAG hiện tại của bạn.

- Tham gia [nhóm Telegram tiếng Anh của dibi8](https://t.me/DIBI8_Group/2) để nhận cập nhật công cụ AI mã nguồn mở.
- Đọc tiếp: [các hướng dẫn liên quan trên dibi8](dibi8-internal-link).

---

**Nguồn & Đọc thêm**:
- Kho GitHub: https://github.com/microsoft/graphrag
- Tài liệu chính thức / README: https://github.com/microsoft/graphrag#readme

*Một số liên kết phía trên là liên kết tiếp thị (affiliate). dibi8.com có thể nhận hoa hồng nếu bạn đăng ký, mà bạn không phải trả thêm chi phí. Điều này giúp duy trì website hoạt động và nội dung được miễn phí.*

<!-- internal-link-candidates:
  related open-source tools -> ai-tools-directory
  related guides on dibi8 -> ai-coding-agent-landscape-2026-skills-mcp-opensource
-->
