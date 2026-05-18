---
title: 'Bảng Xếp Hạng LLM Mã Nguồn Mở 2025: Llama, Mistral, Qwen, DeepSeek & Hơn Nữa'
description: 'Bảng xếp hạng và hướng dẫn chọn LLM mã nguồn mở tốt nhất 2025. So sánh Llama 3, Mistral, Qwen, DeepSeek qua các benchmark MMLU, HumanEval, MT-Bench.'
date: 2026-05-18 00:00:00+08:00
lastmod: 2026-05-18 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-18'
featureImage: ''
draft: false
aliases:
- /posts/open-source-llm-ranking-guide/
---

{</* resource-info */>}

Năm 2025 đánh dấu một cột mốc quan trọng trong lĩnh vực trí tuệ nhân tạo: các mô hình ngôn ngữ lớn mã nguồn mở đã bắt kịp và trong nhiều trường hợp vượt qua các đối thủ thương mại đóng. Từ Llama 3.1 405B của Meta đến DeepSeek V3 với kiến trúc MoE đột phá, ngườii dùng giờ đây có hàng chục lựa chọn chất lượng cao mà không phải trả phí API. Bài viết này cung cấp bảng xếp hạng toàn diện và hướng dẫn chọn model phù hợp nhất cho từng nhu cầu.

## Thế Giới LLM Mã Nguồn Mở Năm 2025

### Tại Sao Các Model Mã Nguồn Mở Đang Chiếm Ưu Thế?

Xu hướng mã nguồn mở trong AI đã tạo ra một vòng phản hồi tích cực: càng nhiều tổ chức công bố model, cộng đồng càng có nhiều dữ liệu để cải thiện; càng cải thiện, càng nhiều ngườii dùng chuyển sang mã nguồn mở. Theo thống kê từ Hugging Face, lượt tải model mã nguồn mở tăng 340% trong năm 2024 [^1^](https://huggingface.co/spaces/open-llm-leaderboard).

Các lý do chính khiến doanh nghiệp chuyển sang mã nguồn mở:

- **Kiểm soát dữ liệu**: Dữ liệu không rờii khỏi hệ thống
- **Chi phí dự đoán được**: Không phụ thuộc vào giá API có thể thay đổi
- **Tùy chỉnh**: Fine-tune trên dữ liệu riêng không giới hạn
- **Không rate limit**: Chạy bao nhiêu request tùy ý

### Các Benchmark Chính: MMLU, HumanEval, MT-Bench

Để so sánh các LLM một cách khách quan, cộng đồng sử dụng nhiều benchmark:

- **MMLU (Massive Multitask Language Understanding)**: Đo khả năng hiểu biết đa lĩnh vực (57 chủ đề từ toán học đến luật), điểm tính theo %
- **HumanEval**: Đo khả năng viết code Python, tính theo pass@1 (tỷ lệ giải đúng từ lần thử đầu)
- **MT-Bench (Multi-Turn Benchmark)**: Đo khả năng hội thoại đa lượt, chấm điểm bởi GPT-4
- **MATH**: Đo khả năng giải toán đại số, hình học, số học

### Cách Đọc Bảng Xếp Hạng LLM

Hai bảng xếp hạng uy tín nhất hiện nay:

- **Open LLM Leaderboard (Hugging Face)**: Tổng hợp điểm nhiều benchmark tự động [^1^](https://huggingface.co/spaces/open-llm-leaderboard)
- **LMSYS Chatbot Arena**: Xếp hạng dựa trên đánh giá của ngườii dùng thực (ELO rating), model nào thắng nhiều hơn được xếp cao hơn [^2^](https://chat.lmsys.org)

## Meta Llama 3/3.1/3.2: Tiêu Chuẩn Mã Nguồn Mở

### Các Biến Thể Model

Meta ra mắt Llama 3 tháng 4/2024, tiếp theo là Llama 3.1 (tháng 7/2024) và Llama 3.2 (tháng 9/2024) [^3^](https://ai.meta.com/llama):

- **Llama 3.2 1B/3B**: Model nhỏ cho edge devices
- **Llama 3.1 8B**: Cân bằng hiệu suất và tài nguyên
- **Llama 3.1 70B**: Hiệu suất cao cho server
- **Llama 3.1 405B**: Model mã nguồn mở lớn nhất từ trước đến nay

### Khả Năng Và Cải Tiến

Llama 3.1 đem lại nhiều cải tiến quan trọng:

- **Context window 128K**: Gấp 8 lần Llama 3 gốc (16K)
- **Multilingual**: Hỗ trợ 8 ngôn ngữ chính thức
- **Tool use**: Gọi hàm và sử dụng công cụ tích hợp
- **Better reasoning**: Cải thiện đáng kể khả năng suy luận

### Điểm Benchmark

| Model | MMLU | HumanEval | MT-Bench |
|-------|------|-----------|----------|
| Llama 3.1 8B | 69.4% | 72.6% | 8.1 |
| Llama 3.1 70B | 86.0% | 80.5% | 8.6 |
| Llama 3.1 405B | 88.6% | 85.2% | 9.0 |

### Lưu Ý Về Giấy Phép

Llama 3 sử dụng giấy phép đặc biệt của Meta: miễn phí cho ứng dụng có ít hơn 700 triệu ngườii dùng. Các công ty lớn hơn cần xin giấy phép riêng. Không giống Apache 2.0 thuần túy, có một số hạn chế cần lưu ý.

## Mistral AI: Xuất Sắc Từ Châu Âu

### Di Sản Mistral 7B

Khi ra mắt tháng 9/2023, Mistral 7B gây chấn động bằng cách vượt qua Llama 2 13B chỉ với một nửa kích thước [^4^](https://mistral.ai). Đây là minh chứng cho thấy kiến trúc tốt quan trọng hơn kích thước thuần túy.

### Mixtral 8x7B Và 8x22B (MoE)

Mixtral sử dụng kiến trúc Mixture of Experts (MoE):

- **8x7B**: 8 chuyên gia, mỗi lượt forward chỉ kích hoạt 2 (12B active)
- **8x22B**: Phiên bản mở rộng, mỗi lượt forward 39B active từ tổng 141B

MoE cho phép model lớn mà vẫn nhanh vì chỉ một phần được kích hoạt mỗi lần.

### Mistral Large Và Codestral

- **Mistral Large**: Model thương mại mạnh nhất, cạnh tranh với GPT-4
- **Codestral 22B**: Chuyên viết code, hỗ trợ 80+ ngôn ngữ lập trình, fill-in-the-middle

### Điểm Benchmark

| Model | MMLU | HumanEval | MT-Bench |
|-------|------|-----------|----------|
| Mistral 7B | 62.5% | 65.4% | 7.3 |
| Mixtral 8x7B | 70.6% | 74.4% | 8.3 |
| Mistral Large | 86.3% | 86.9% | 8.6 |
| Codestral 22B | 72.2% | 88.2% | 8.1 |

## Qwen (Alibaba): Ngôi Sao Đang Lên Từ Trung Quốc

### Series Qwen2 Và Qwen2.5

Qwen là dòng model do Alibaba Cloud phát triển, trở thành một trong những model mã nguồn mở tốt nhất năm 2024-2025 [^5^](https://huggingface.co/Qwen). Qwen2.5 ra mắt tháng 9/2024 với nhiều cải tiến:

- **Qwen2.5 0.5B đến 72B**: Phủ phổ từ edge đến server
- **Context window 128K**: Hỗ trợ xử lý tài liệu dài
- **Cải thiện đáng kể** về instruction following và reasoning

### Khả Năng Đa Ngôn Ngữ

Qwen2.5 hỗ trợ hơn 29 ngôn ngữ, trong đó có tiếng Việt. Đây là một trong những model hiếm hoi có khả năng tiếng Việt tốt ngay từ pretrained weights mà không cần fine-tune.

### CodeQwen Cho Lập Trình

CodeQwen1.5-7B đạt 83.7% trên HumanEval — vượt trội hơn nhiều model cùng kích thước. CodeQwen hỗ trợ hơn 92 ngôn ngữ lập trình và có context window 64K.

### Điểm Benchmark

| Model | MMLU | HumanEval | MT-Bench |
|-------|------|-----------|----------|
| Qwen2.5 7B | 74.2% | 78.9% | 8.1 |
| Qwen2.5 14B | 79.8% | 82.1% | 8.4 |
| Qwen2.5 72B | 86.1% | 86.6% | 8.8 |

## DeepSeek: Hiệu Quả Kết Hợp Hiệu Suất

### DeepSeek V2.5 Và V3

DeepSeek, phát triển bởi công ty Trung Quốc DeepSeek AI, gây tiếng vang với kiến trúc MLA (Multi-head Latent Attention) giúp giảm VRAM trong inference [^6^](https://deepseek.com):

- **DeepSeek V2.5**: 236B tổng, 21B active mỗi token
- **DeepSeek V3**: 671B tổng, 37B active — mạnh ngang GPT-4o

### Kiến Trúc MoE Củaa DeepSeek

DeepSeek V3 sử dụng kiến trúc MoE với 671 tỷ tham số nhưng chỉ kích hoạt 37 tỷ mỗi token. Điều này cho phép:

- Chi phí training thấp hơn 10 lần so với model dense tương đương
- Inference nhanh hơn với ít VRAM hơn
- Chất lượng ngang GPT-4o trên nhiều benchmark

### DeepSeek Coder Series

DeepSeek Coder v2 đạt 90.2% trên HumanEval — một trong những model coding tốt nhất hiện nay, vượt cả GPT-4 trên một số tác vụ.

### Điểm Benchmark

| Model | MMLU | HumanEval | MT-Bench |
|-------|------|-----------|----------|
| DeepSeek V2.5 | 82.5% | 89.0% | 8.6 |
| DeepSeek V3 | 88.5% | 92.0% | 8.9 |
| DeepSeek Coder v2 | 76.2% | 90.2% | 8.4 |

## Google Gemma: Nhẹ Và Dễ Tiếp Cận

### Gemma 2 (2B, 9B, 27B)

Google ra mắt Gemma 2 tháng 6/2024 với ba kích thước [^1^](https://huggingface.co/spaces/open-llm-leaderboard):

- **Gemma 2 2B**: Chạy mượt trên điện thoại, điểm MMLU 51.3%
- **Gemma 2 9B**: Cân bằng, điểm MMLU 71.8%
- **Gemma 2 27B**: Hiệu suất cao, điểm MMLU 84.6%

### Chiến Lược Open-Weight Củaa Google

Gemma sử dụng giấy phép Gemma Terms of Use — cho phép sử dụng thương mại miễn phí nhưng có một số hạn chế so với Apache 2.0 thuần túy. Google coi Gemma như một phần của chiến lược "open-weight" — công bố trọng số nhưng không công bố training data hoặc full training pipeline.

## Microsoft Phi: Nhỏ Nhưng Mạnh Mẽ

### Series Phi-3 Và Phi-4

Microsoft đẩy mạnh dòng model nhỏ với hiệu suất vượt trội:

- **Phi-3 Mini (3.8B)**: Mạnh ngang model 7B khác nhờ training data chất lượng cao
- **Phi-3 Small (7B)**: Cân bằng tốt cho nhiều tác vụ
- **Phi-3 Medium (14B)**: Tiệm cận model 30B khác
- **Phi-4 (14B)**: Ra mắt cuối 2024, cải thiện đáng kể reasoning

### Hiệu Suất Đáng Kinh Ngạc Cho Model Nhỏ

Phi-3 Mini đạt 68.8% MMLU — cao hơn cả Llama 3 8B (68.4%) dù chỉ có một nửa kích thước. Bí quyết nằm ở training data được lọc kỹ lưỡng: "data quality is the new data quantity."

### Triển Khai Trên Edge Và Mobile

Với kích thước nhỏ, Phi-3 là lựa chọn lý tưởng cho triển khai trên thiết bị edge, mobile app, và các ứng dụng yêu cầu inference nhanh với tài nguyên hạn chế.

## Ma Trận So Sánh Hiệu Suất

### Bảng So Sánh Benchmark

| Model | Kích Thước | MMLU | HumanEval | MT-Bench | Context |
|-------|-----------|------|-----------|----------|---------|
| Llama 3.1 405B | 405B | 88.6% | 85.2% | 9.0 | 128K |
| DeepSeek V3 | 671B/37B | 88.5% | 92.0% | 8.9 | 128K |
| Qwen2.5 72B | 72B | 86.1% | 86.6% | 8.8 | 128K |
| Mistral Large | ~120B | 86.3% | 86.9% | 8.6 | 128K |
| Llama 3.1 70B | 70B | 86.0% | 80.5% | 8.6 | 128K |
| Gemma 2 27B | 27B | 84.6% | 71.8% | 8.2 | 8K |
| Qwen2.5 14B | 14B | 79.8% | 82.1% | 8.4 | 128K |
| Phi-4 | 14B | 78.5% | 82.4% | 8.3 | 16K |
| Llama 3.1 8B | 8B | 69.4% | 72.6% | 8.1 | 128K |
| Qwen2.5 7B | 7B | 74.2% | 78.9% | 8.1 | 128K |

### Yêu Cầu VRAM Theo Model

| Model | VRAM (4-bit) | VRAM (8-bit) | GPU Đề Xuất |
|-------|-------------|-------------|-------------|
| 2B-3B | 2-3 GB | 4-5 GB | RTX 3060 |
| 7B-9B | 5-7 GB | 9-11 GB | RTX 3090/4090 |
| 14B | 9-10 GB | 17-18 GB | RTX 4090, A6000 |
| 70B | 40-45 GB | 75-80 GB | 2× A100 40GB |
| 405B | 230-250 GB | 450-500 GB | 8× A100 80GB |

## Làm Thế Nào Để Chọn LLM Mã Nguồn Mở Phù Hợp?

### Decision Framework Theo Use Case

### Tốt Nhất Cho Lập Trình: DeepSeek Coder, Codestral

Nếu ứng dụng của bạn liên quan đến code generation, code completion, hoặc code review:

- **DeepSeek Coder v2**: Tốt nhất tổng thể, 90.2% HumanEval
- **Codestral 22B**: Fill-in-the-middle tốt nhất, 80+ ngôn ngữ
- **Qwen2.5 Coder 7B**: Cân bằng hiệu suất và tài nguyên

### Tốt Nhất Cho Chatbot: Llama 3.1, Qwen2.5

Với ứng dụng chatbot đa năng:

- **Llama 3.1 70B**: MT-Bench cao nhất, ecosystem rộng
- **Qwen2.5 72B**: Hỗ trợ tiếng Việt tốt, context window 128K
- **DeepSeek V3**: Reasoning tốt, giá trị cao

### Tốt Nhất Cho Local Deployment: Mistral, Phi, Gemma

Nếu chạy trên máy cá nhân hoặc server giới hạn:

- **Mistral 7B**: Hiệu suất tốt nhất cho 7B class
- **Phi-3 Mini**: Nhỏ nhất với hiệu suất chấp nhận được
- **Gemma 2 2B**: Chạy trên điện thoại

### Tốt Nhất Cho Doanh Nghiệp: Llama 3.1, Mistral Large

Với yêu cầu enterprise: hỗ trợ, bảo mật, compliance:

- **Llama 3.1 405B**: Mạnh nhất, được nhiều vendor hỗ trợ
- **Mistral Large**: Có commercial support từ Mistral AI

## Tải Và Chạy Các Model

### Hugging Face Hub

Hugging Face là nền tảng chính để tải model mã nguồn mở:

```python
from transformers import AutoModelForCausalLM, AutoTokenizer

model = AutoModelForCausalLM.from_pretrained("meta-llama/Llama-3.1-8B-Instruct")
tokenizer = AutoTokenizer.from_pretrained("meta-llama/Llama-3.1-8B-Instruct")
```

### Thư Viện Model Ollama

Ollama là cách dễ nhất để chạy model local [^7^](https://ollama.com/library):

```bash
ollama run llama3.1:8b
ollama run mistral
ollama run qwen2.5:7b
```

### GPT4All Và LM Studio

- **GPT4All**: Desktop app miễn phí, download và chạy model với vài click
- **LM Studio**: Giao diện đẹp, hỗ trợ chat và API server

### Triển Khai Cloud

- **RunPod**: Thuê GPU theo giờ, từ $0.2/giờ (RTX 3090)
- **Together AI**: API cho hàng trăm model mã nguồn mở với giá cạnh tranh

## Tương Lai Củaa LLM Mã Nguồn Mở

### Xu Hướng Đáng Chú Ý Năm 2025

- **Model MoE**: DeepSeek V3 chứng minh MoE là tương lai — model khổng lồ, inference rẻ
- **Multimodal**: Qwen2-VL, Llama 3.2 Vision mở rộng sang hình ảnh
- **Reasoning**: O1-like reasoning đang được tái tạo trong mã nguồn mở (QwQ, DeepSeek-R1)
- **Agentic AI**: Model có khả năng gọi công cụ và thực hiện tác vụ tự động

### Khoảng Cách Giữa Mở Và Đóng

Năm 2023, GPT-4 dẫn trước mã nguồn mở rất xa. Năm 2025, Llama 3.1 405B và DeepSeek V3 đã bắt kịp GPT-4o trên hầu hết các benchmark. Khoảng cách đang thu hẹp nhanh chóng, và với một số tác vụ chuyên biệt, model mã nguồn mở fine-tuned thậm chí vượt trội hơn.

### Các Vấn Đề Pháp Lý

Ngày càng nhiều quốc gia quan tâm đến việc quản lý model AI mã nguồn mở. EU AI Act yêu cầu các model "general-purpose" phải tuân thủ một số quy định nhất định. Tuy nhiên, so với model đóng, mã nguồn mở vẫn có tính minh bạch cao hơn, giúp việc audit và tuân thủ dễ dàng hơn.

## Kết Luận

Năm 2025 là thờii điểm vàng để áp dụng LLM mã nguồn mở. Với các model như DeepSeek V3, Llama 3.1 405B, và Qwen2.5 72B, bạn có thể đạt được hiệu suất ngang GPT-4 mà không tốn chi phí API. Hãy chọn model dựa trên use case cụ thể: coding chọn DeepSeek Coder, chatbot đa năng chọn Llama 3.1 hoặc Qwen2.5, deployment local chọn Mistral hoặc Phi.

## Câu Hỏi Thường Gặp

### Model Mã Nguồn Mở Tốt Nhất Năm 2025 Là Gì?

Tổng thể, DeepSeek V3 và Llama 3.1 405B là hai model mã nguồn mở mạnh nhất năm 2025, ngang ngửa GPT-4o. Tuy nhiên, "tốt nhất" phụ thuộc vào use case: coding thì DeepSeek Coder v2, chatbot thì Llama 3.1 70B, tiếng Việt thì Qwen2.5.

### Có Thể Dùng LLM Mã Nguồn Mở Cho Mục Đích Thương Mại Không?

Hầu hết các model mã nguồn mở cho phép sử dụng thương mại, nhưng có một số hạn chế:

- **Llama 3**: Miễn phí nếu <700 triệu ngườii dùng
- **Mistral**: Apache 2.0 (tự do)
- **Qwen2.5**: Qwen License (cho phép thương mại)
- **DeepSeek**: MIT License (tự do nhất)
- **Gemma**: Giấy phép riêng, có một số hạn chế

### Model Mã Nguồn Mở Nào Tốt Nhất Cho Lập Trình?

DeepSeek Coder v2 (90.2% HumanEval) là lựa chọn hàng đầu cho coding. Codestral 22B cũng rất mạnh với khả năng fill-in-the-middle. Qwen2.5 Coder 7B là lựa chọn tốt nếu VRAM hạn chế.

### LLM Mã Nguồn Mở So Với GPT-4 Như Thế Nào?

Năm 2025, Llama 3.1 405B và DeepSeek V3 đã bắt kịp GPT-4o trên hầu hết các benchmark đánh giá chung. Trên một số tác vụ chuyên biệt (coding, toán học), model mã nguồn mở thậm chí vượt trội. Tuy nhiên, GPT-4 vẫn dẫn đầu ở khả năng đa modal và một số tác vụ phức tạp.

### Cần Phần Cứng Gì Để Chạy Llama 3 70B?

Với quantization 4-bit, Llama 3 70B cần khoảng 40-45GB VRAM — có thể chạy trên 2× RTX 4090 (24GB) hoặc 1× A100 80GB. Với 8-bit, cần 75-80GB (2× A100 80GB hoặc 1× H100). Với full precision (16-bit), cần khoảng 140GB VRAM.

---

## Hạ Tầng Đề Xuất

Để chạy các công cụ trên 24/7 ổn định, lựa chọn hạ tầng rất quan trọng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 tín dụng miễn phí 60 ngày, 14+ region toàn cầu.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp. dibi8.com cũng host ở đây.
- **[Hostinger](https://www.hostinger.com/vn?REFERRALCODE=22RPIAOJIYJN)** — VPS giá tốt cho thị trường Việt Nam.

*Đây là affiliate link, không tăng chi phí của bạn nhưng giúp dibi8.com duy trì hoạt động.*

