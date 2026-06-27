---

lang: en
title: 'MinerU: 70,6K sao — Chuyển đổi bất kỳ tài liệu nào sang Markdown sẵn sàng cho LLM'
description: 'MinerU (70.600+ sao GitHub) chuyển đổi PDF, DOCX, PPTX, XLSX, hình ảnh và trang web thành Markdown và JSON có cấu trúc cho quy trình làm việc LLM, RAG và Đại lý. Hỗ trợ OCR 109 ngôn ngữ, chuyển công thức sang LaTeX, chuyển bảng sang HTML và chạy trên CPU hoặc GPU.'
tags: ["guide", "open-source", "ai-agents", "rag", "pdf", "ocr", "reference", "tutorial"]
date: 2026-06-27 00:00:00+08:00
slug: 'mineru-document-parsing-engine'
category: ai-tools
github_repo: 'https://github.com/opendatalab/MinerU'
license: MinerU Open Source License (Apache 2.0-based)
lang: en
featureImage: /images/articles/mineru-docs.png

---


![MinerU logo](https://gcore.jsdelivr.net/gh/opendatalab/MinerU@master/docs/images/MinerU-logo.png)

*MinerU — công cụ phân tích tài liệu nguồn mở đã đạt 70.600 sao GitHub chỉ sau hơn một năm.*

Trong thời đại của các tác nhân mã hóa AI và quy trình RAG, nút thắt lớn nhất không phải là khả năng của mô hình — mà là **chất lượng dữ liệu**. Bạn có thể có LLM mạnh nhất trên thế giới, nhưng nếu tài liệu đầu vào của bạn là các tệp PDF lộn xộn với các bảng bị hỏng, công thức không thể đọc được và các tiêu đề bị cắt xén thì đầu ra sẽ là rác.

Nhập **MinerU**, một công cụ phân tích cú pháp tài liệu từ OpenDataLab (nhóm phát triển InternLM) có chức năng chuyển đổi PDF, DOCX, PPTX, XLSX, hình ảnh và trang web thành **Markdown và JSON có cấu trúc rõ ràng** — được thiết kế đặc biệt cho các quy trình làm việc LLM, RAG và Đại lý xuôi dòng.

Với **70.600+ sao GitHub**, **5.900 fork** và **960 sao đạt được chỉ trong ngày hôm nay**, MinerU đã nhanh chóng trở thành giải pháp nguồn mở phù hợp để chuyển đổi tài liệu sang đường dẫn LLM.

## What Is MinerU?

MinerU ra đời trong quá trình đào tạo trước của [InternLM](https://github.com/InternLM/InternLM), một mô hình ngôn ngữ lớn của Trung Quốc. Nhóm nhận thấy rằng việc chuyển đổi các bài báo khoa học và tài liệu kỹ thuật sang định dạng máy có thể đọc được là một vấn đề nan giải — đặc biệt là đối với các công thức, bảng biểu và bố cục phức tạp.

Vì vậy họ đã xây dựng MinerU.

Không giống như các trình phân tích cú pháp PDF truyền thống chỉ trích xuất văn bản thô, MinerU hiểu cấu trúc tài liệu:

- **Xóa** đầu trang, chân trang, chú thích cuối trang và số trang phá vỡ tính mạch lạc về mặt ngữ nghĩa 
- **Giữ nguyên** thứ tự đọc cho bố cục một cột, nhiều cột và bố cục phức tạp 
- **Chuyển đổi** công thức sang LaTeX, bảng thành HTML 
- **Phát hiện** các tệp PDF được quét và cắt xén và tự động bật OCR 
- **Hỗ trợ** 109 ngôn ngữ để nhận dạng OCR 
- **Đầu ra** Markdown đa phương thức, Markdown NLP và JSON được sắp xếp theo thứ tự đọc

Kết quả là nội dung tài liệu mà các tác nhân AI và LLM thực sự có thể hiểu được.

## Installation and Setup

MinerU cung cấp nhiều đường dẫn cài đặt tùy theo nhu cầu của bạn:

### pip (Được khuyến nghị cho hầu hết người dùng)

```bash
pip install mineru
```

### Docker

```bash
docker pull mineru/mineru:latest
docker run --gpus all -v $(pwd):/data mineru/mineru:latest
```

### Phát triển địa phương

```bash
git clone https://github.com/opendatalab/MinerU.git
cd MinerU
pip install -e .
```

MinerU hỗ trợ cả suy luận **chỉ dành cho CPU** và **tăng tốc GPU**. Để tăng tốc GPU, hãy cài đặt với sự hỗ trợ CUDA:

```bash
pip install mineru[cuda]
```

Trên macOS có Apple Silicon, MinerU tận dụng MPS (Bộ tạo bóng hiệu suất kim loại) để tăng tốc.

## Three Parsing Engines

MinerU cung cấp ba phần phụ trợ phân tích cú pháp khác nhau, mỗi phần được tối ưu hóa cho các tình huống khác nhau:

### 1. Pipeline Backend (Nhanh & Ổn định)

Phần phụ trợ `pipeline` là lựa chọn mặc định cho hầu hết người dùng. Nó nhanh, ổn định và không tạo ra ảo giác. Nó chạy hiệu quả trên CPU và lý tưởng cho việc xử lý hàng loạt.

```bash
mineru ./input.pdf -o ./output/
```

**Tốt nhất cho:** Xử lý tài liệu khối lượng lớn, quy trình CI/CD, môi trường chỉ có CPU.

### 2. VLM Engine (Độ chính xác cao)

Công cụ VLM (Mô hình ngôn ngữ tầm nhìn) sử dụng mô hình `MinerU2.5-Pro-2604-1.2B` độc quyền của MinerU để mang lại độ chính xác phân tích cú pháp hiện đại. Nó vượt trội trên các tài liệu phức tạp với bố cục hỗn hợp, văn bản viết tay và công thức dày đặc.

```bash
mineru ./complex.pdf -o ./output/ --engine vlm-engine
```

**Tốt nhất cho:** Tài liệu khoa học phức tạp, tài liệu scan, nội dung viết tay, OCR đa ngôn ngữ.

### 3. Động cơ Hybrid (Cân bằng)

Công cụ `hybrid` kết hợp trích xuất văn bản gốc với phân tích dựa trên VLM. Bắt đầu từ phiên bản 3.3, nó bao gồm tham số `nỗ lực` với mức độ `trung bình` và `cao`:

- **Nỗ lực trung bình:** Nhanh hơn 35-220% so với mức cao, với độ chính xác chỉ giảm 0,13 điểm trên OmniDocBench 
- **Nỗ lực cao:** Độ chính xác tối đa với hỗ trợ phân tích hình ảnh

```bash
mineru ./document.pdf -o ./output/ --engine hybrid-engine --effort medium
```

**Tốt nhất cho:** Khối lượng công việc sản xuất mà bạn cần cân bằng giữa tốc độ và độ chính xác.

## Supported Formats

MinerU hỗ trợ nhiều định dạng đầu vào:

| Format | Support Level | Notes |
|--------|--------------|-------|
| PDF | Native | Text PDFs, scanned PDFs, garbled PDFs |
| DOCX | Native | Full structural preservation |
| PPTX | Native | Slides, layouts, embedded content |
| XLSX | Native | Tables, formulas, charts |
| Images | OCR | JPEG, PNG, TIFF, BMP, and more |
| Web Pages | Scraping | Full-page conversion to Markdown |

Hỗ trợ DOCX, PPTX và XLSX gốc (được thêm trong phiên bản 3.1.0) có nghĩa là MinerU có thể phân tích các định dạng này **trực tiếp** mà không cần chuyển đổi sang PDF trước — một cải tiến đáng kể về tốc độ so với quy trình công việc truyền thống.

## OCR: 109 Languages

Công cụ OCR của MinerU hỗ trợ **109 ngôn ngữ** và được nâng cấp lên PP-OCRv6 trong phiên bản 3.4, cải thiện độ chính xác khoảng 11% trên điểm chuẩn OmniDocBench v1.6.

Bắt đầu từ phiên bản 3.4, MinerU đã đơn giản hóa cấu hình ngôn ngữ OCR. Thay vì chọn từng ngôn ngữ (tiếng Nhật, tiếng Trung phồn thể, tiếng Anh, tiếng Latinh), giờ đây tất cả các kịch bản đều định tuyến thông qua mô hình `ch` OCR được tối ưu hóa, giảm độ phức tạp của cấu hình đồng thời cải thiện độ chính xác.

```bash
# Automatic OCR detection (recommended)
mineru ./scanned.pdf -o ./output/

# Buộc OCR trên một tài liệu cụ thể 
minuru ./document.pdf -o ./output/ --ocr 
```

## Real-World Use Cases

### Chuẩn bị dữ liệu đường ống RAG

MinerU được xây dựng có mục đích cho quy trình làm việc RAG (Thế hệ tăng cường truy xuất). Bằng cách chuyển đổi tài liệu thành Markdown có cấu trúc với thứ tự đọc, tiêu đề và cấu trúc ngữ nghĩa được giữ nguyên, hệ thống RAG có thể phân tách và nhúng tài liệu hiệu quả hơn nhiều.

```python
import mineru as mu

kết quả = mu.parse("./research_paper.pdf") 
# result.markdown: Làm sạch Markdown để nhúng 
# result.json: JSON có cấu trúc để truy xuất 
# result.layout: Bố cục trực quan để gỡ lỗi 
```

### Cơ sở kiến ​​thức về tác nhân AI

Đối với các tác nhân AI cần suy luận về tài liệu, MinerU cung cấp đầu vào rõ ràng nhất có thể. Việc loại bỏ đầu trang, chân trang và số trang sẽ đảm bảo tổng đài viên không bị nhầm lẫn bởi các tạo phẩm trang lặp đi lặp lại.

### Sản xuất dữ liệu đào tạo

MinerU ban đầu được xây dựng để hỗ trợ quy trình đào tạo trước của InternLM. Khả năng chuyển đổi các bài báo khoa học phức tạp thành văn bản rõ ràng khiến nó trở nên vô giá trong việc tạo ra dữ liệu đào tạo chất lượng cao cho các LLM theo miền cụ thể.

### Xử lý tài liệu hàng loạt

Với sự hỗ trợ cho suy luận đồng thời đa luồng và ghi trực tuyến vào đĩa, MinerU có thể xử lý hàng nghìn tài liệu mà không cần phân tách thủ công. Cơ chế cửa sổ trượt giúp giảm mức sử dụng bộ nhớ tối đa trong các tình huống tài liệu dài.

## Integration Ecosystem

MinerU tích hợp với hầu hết mọi khung AI chính:

| Framework | Integration |
|-----------|-------------|
| LangChain | Native document loader |
| LlamaIndex | Document parser integration |
| RAGFlow | Built-in parser |
| RAG-Anything | Pipeline integration |
| Flowise | Visual workflow support |
| Dify | Document processing node |
| FastGPT | Native support |

### Máy chủ MCP

MinerU cũng cung cấp **MCP Server** để tích hợp với các công cụ mã hóa AI như Cursor, Claude Desktop và Windsurf. Điều này cho phép bạn phân tích cú pháp tài liệu trực tiếp trong quy trình làm việc của tác nhân mã hóa.

```bash
# Start the MCP server
mineru-mcp-server
```

## Performance Benchmarks

Phần phụ trợ `pipeline` của MinerU đạt được số điểm **86,2 trên OmniDocBench v1.5**, vượt qua độ chính xác của mô hình VLM thế hệ trước `MinerU2.0-2505-0.9B`.

Động cơ Hybrid với `nỗ lực=trung bình` mang lại:

- **~80% nhanh hơn** đối với các kịch bản PDF văn bản trên Linux 
- **~90% nhanh hơn** cho các kịch bản PDF văn bản trên Windows 
- **~nhanh hơn 220%** đối với các kịch bản PDF văn bản trên macOS 
- Chỉ **giảm độ chính xác 0,13 điểm** so với `nỗ lực=cao`

## Why MinerU Stands Out

1. **Được xây dựng cho AI, không phải con người.** Không giống như các trình chuyển đổi PDF có mục đích chung, đầu ra của MinerU được tối ưu hóa cho việc sử dụng LLM — duy trì cấu trúc ngữ nghĩa trong khi loại bỏ nhiễu gây nhầm lẫn cho các mô hình AI.

2. **Hỗ trợ gốc nhiều định dạng.** DOCX, PPTX, XLSX, PDF, hình ảnh và trang web — tất cả đều được phân tích cú pháp nguyên bản mà không cần qua trung gian chuyển đổi định dạng.

3. **Sẵn sàng sản xuất trên quy mô lớn.** Khả năng đồng thời đa luồng, tính linh hoạt của GPU/CPU, triển khai Docker và kiến ​​trúc API/CLI/bộ định tuyến mạnh mẽ giúp MinerU phù hợp với khối lượng công việc của doanh nghiệp.

4. **Giấy phép mở.** Đã chuyển từ AGPLv3 sang giấy phép dựa trên Apache 2.0 tùy chỉnh trong phiên bản 3.1.0, giảm đáng kể các rào cản áp dụng cho cả mục đích sử dụng cộng đồng và thương mại.

5. **Hỗ trợ chip AI trong nước.** Tương thích với hơn 10 công cụ tăng tốc AI của Trung Quốc bao gồm Ascend, Cambricon, Enflame, Moore Threads và các công cụ khác.

## Getting Started

Cách dễ nhất để dùng thử MinerU là thông qua [ứng dụng web trực tuyến](https://mineru.net/OpenSourceTools/Extractor?source=github), ứng dụng này cung cấp chức năng tương tự như ứng dụng khách trên máy tính để bàn mà không cần cài đặt.

Đối với các nhà phát triển, [sổ tay Colab](https://colab.research.google.com/Gist/myhloli/a3cb16570ab3cfeadf9d8f0ac91b4fca/mineru_demo.ipynb) cung cấp bản trình diễn tương tác nhanh.

```bash
# Install and parse your first document
pip install mineru
mineru ./my-document.pdf -o ./output/ --format markdown
```

## Limitations

- **Bố cục phức tạp:** Mặc dù MinerU xử lý tốt hầu hết các loại tài liệu, nhưng bố cục cực kỳ phức tạp (bài báo khoa học nhiều cột với các hình và bảng xen kẽ) vẫn có thể yêu cầu xem xét thủ công. 
- **Yêu cầu GPU cho VLM:** Công cụ VLM yêu cầu VRAM đáng kể (khuyến nghị 8GB+) để có hiệu suất tối ưu. 
- **Đường cong học tập:** Kiến trúc ba động cơ và các tùy chọn cấu hình khác nhau có thể gây choáng ngợp cho người mới bắt đầu.

## Conclusion

MinerU thể hiện một bước tiến đáng kể trong việc chuyển đổi tài liệu sang LLM. Bằng cách kết hợp phân tích cú pháp đa định dạng gốc, OCR 109 ngôn ngữ và định dạng đầu ra được tối ưu hóa cho AI, nó sẽ lấp đầy khoảng trống quan trọng trong quy trình dữ liệu AI hiện đại.

Cho dù bạn đang xây dựng hệ thống RAG, đào tạo LLM theo miền cụ thể hay tạo cơ sở kiến ​​thức cho các tác nhân AI, MinerU đều cung cấp đầu vào có cấu trúc rõ ràng để giúp các hệ thống này thực sự hoạt động.

Với hơn 70.600 sao, đội ngũ phát triển tích cực và khả năng tích hợp khung ngày càng tăng, MinerU được định vị để trở thành tiêu chuẩn thực tế cho việc phân tích tài liệu nguồn mở trong kỷ nguyên AI.

## Resources

- Kho lưu trữ GitHub: https://github.com/opendatalab/MinerU 
- Tài liệu: https://opendatalab.github.io/MinerU/ 
- Bản demo trực tuyến: https://mineru.net/OpenSourceTools/Extractor 
- Báo cáo kỹ thuật (v3.1): https://arxiv.org/abs/2604.04771 
- Báo cáo kỹ thuật (v2.5): https://arxiv.org/abs/2509.22186 
- Báo cáo kỹ thuật (v2.0): https://arxiv.org/abs/2409.18839 
- Bản demo HuggingFace: https://huggingface.co/spaces/opendatalab/MinerU 
- Bản demo ModelScope: https://www.modelscope.cn/studios/OpenDataLab/MinerU 
- Cộng đồng bất hòa: https://discord.gg/Tdedn9GTXq

**Tiết lộ**: Bài viết này có chứa các liên kết liên kết. Nếu bạn đăng ký thông qua các liên kết của chúng tôi, chúng tôi có thể kiếm được một khoản hoa hồng nhỏ mà bạn không phải trả thêm phí. Điều này giúp hỗ trợ báo chí công nghệ độc lập và giữ cho các tài nguyên như dibi8.com miễn phí và không có quảng cáo.