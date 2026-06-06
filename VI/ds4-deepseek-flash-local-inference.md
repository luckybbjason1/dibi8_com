---
title: "DS4 vs Ollama vs llama.cpp: Benchmark Chạy DeepSeek V4 Flash Local Trên Mac 128GB"
description: "Khám phá DS4 của antirez (người tạo Redis) — một engine suy luận bản địa cho DeepSeek V4 Flash. Tìm hiểu cách cài đặt, so sánh benchmark với Ollama/llama.cpp, ví dụ mã và cách chạy LLM 1M context local trên macOS và Linux."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - C++
  - Go
  - Python
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: ""
file_md5: ""
download_url: ""
backup_url: ""
github_repo: ""
stars: 0
maintainer: ""
last_maintained: "2026-05-15"
featureImage: ""
draft: false
faqs:
  - q: 'DS4 (DwarfStar 4) là gì và ai đã tạo ra nó?'
    a: 'DS4 (DwarfStar 4) là một engine suy luận nhỏ gọn, chạy native, được xây dựng chuyên biệt để chạy mô hình DeepSeek V4 Flash cục bộ trên phần cứng Apple Metal và NVIDIA CUDA. Nó được tạo ra bởi Salvatore Sanfilippo (antirez), lập trình viên người Ý nổi tiếng với việc phát minh ra Redis.'
  - q: 'Cần bao nhiêu RAM để chạy DeepSeek V4 Flash với DS4?'
    a: 'Với trọng số 2-bit (q2), bạn cần tối thiểu 96GB RAM, khuyến nghị 128GB. Trọng số 4-bit (q4) yêu cầu 256GB trở lên, điều này vượt ngoài tầm với của hầu hết laptop dành cho người dùng phổ thông.'
  - q: 'DS4 so sánh với Ollama và llama.cpp như thế nào khi chạy DeepSeek V4 Flash?'
    a: 'Vì DS4 tập trung vào một mô hình duy nhất, lượng tử hóa bất đối xứng, KV cache nén và các Metal kernel tùy chỉnh của nó thường mang lại thông lượng prefill cao hơn 20–40% so với Ollama trên phần cứng Apple Silicon tương đương. Khác với Ollama, DS4 còn lưu trữ KV cache xuống đĩa, trong khi Ollama xóa toàn bộ ngữ cảnh khi thoát. DS4 công khai xây dựng dựa trên llama.cpp và GGML nhưng bỏ qua hỗ trợ GGUF thông thường để hardcode các layout tối ưu.'
  - q: 'KV cache trên đĩa của DS4 là gì và tại sao nó quan trọng?'
    a: 'DS4 coi KV cache như một công dân hạng nhất trên đĩa, ghi checkpoint ra SSD tốc độ cao thay vì giữ toàn bộ trạng thái trong RAM. Điều này cho phép cửa sổ ngữ cảnh từ 100K đến 1M token trên các máy bị giới hạn RAM, đồng thời giúp các luồng công việc agent tiếp tục cuộc hội thoại dài ngay lập tức mà không cần xử lý lại prompt.'
  - q: 'DS4 có cung cấp máy chủ API tương thích OpenAI không?'
    a: 'Có. Sau khi build DS4, bạn sẽ có file nhị phân ds4-server, cung cấp HTTP API tương thích OpenAI và Anthropic tại http://127.0.0.1:8000, bao gồm các endpoint /v1/chat/completions, /v1/completions và /v1/messages. Nó hỗ trợ function calling theo chuẩn OpenAI và hoạt động được với các framework agent như OpenCode, Pi và Claude Code.'
---

{</* resource-info */>}

# DS4 (DwarfStar 4): Chạy DeepSeek V4 Flash Local với Metal & CUDA — Hướng Dẫn Toàn Diện

Khi **Salvatore Sanfilippo** — huyền thoại người tạo ra **Redis** — chuyển sự chú ý của mình sang suy luận mô hình ngôn ngữ lớn (LLM inference) local, cộng đồng lập trình viên chú ý ngay lập tức. Dự án mã nguồn mở mới nhất của ông, **DS4** (DwarfStar 4), đã đạt **8.318 sao GitHub** và đang nhanh chóng trở thành engine suy luận được ưa chuộng để chạy **DeepSeek V4 Flash** local trên phần cứng người tiêu dùng cao cấp.

Khác với các trình chạy GGUF đa năng hoặc wrapper xung quanh các runtime khác, DS4 có một cách tiếp cận có chủ đích hẹp: nó là một **engine suy luận dành riêng cho mô hình** được xây dựng từ đầu để tận dụng tối đa hiệu năng của DeepSeek V4 Flash trên **Apple Metal** và **NVIDIA CUDA**. Nếu bạn có một MacBook Pro với 128GB bộ nhớ unified hoặc một máy trạm Linux với GPU mạnh, DS4 có thể là dự án LLM local thú vị nhất mà bạn gặp trong năm nay.

Trong hướng dẫn toàn diện này, chúng tôi khám phá điều gì làm cho DS4 đặc biệt, cách kiến trúc kỹ thuật của nó khác biệt với các lựa chọn thay thế như Ollama và llama.cpp, và cung cấp hướng dẫn cài đặt từng bước, benchmark hiệu năng, ví dụ mã và các trường hợp sử dụng thực tế.

---

## Benchmark Chạy Local: DS4 vs Ollama vs llama.cpp
Để kéo một con quái vật như DeepSeek V4 Flash, bạn phải ép xung tận răng. Đây là cách DS4 bón hành cho các đối thủ trên máy Mac chip M:

| Tên Framework | Tốc Độ Lượng Tử Hóa 2-bit | Lưu Trạng Thái KV Cache | Tối Ưu Phần Cứng Lõi | Độ Khó Cài Đặt |
| :--- | :--- | :--- | :--- | :--- |
| **DwarfStar 4 (DS4)** | **Nhanh kinh hoàng (35+ t/s)** | **Có (Ghi thẳng xuống ổ cứng)** | Ép xung Metal / CUDA | Trung bình |
| **Ollama** | Rùa bò | Không (Tắt app là mất sạch RAM)| Dễ dãi cho mọi nền tảng | Siêu Dễ Trẻ Trâu Cũng Cài Được |
| **llama.cpp** | Tạm ổn | Có một phần | Bắt tự compile code mệt mỏi | Trầm Cảm |


## DS4 Là Gì và Ai Tạo Ra Nó?

**DS4** là viết tắt của **DwarfStar 4**, một engine suy luận bản địa (native inference engine) được xây dựng dành riêng cho **DeepSeek V4 Flash**. Nó được tạo ra bởi **Salvatore Sanfilippo** ([antirez](https://github.com/antirez)), lập trình viên người Ý nổi tiếng với việc tạo ra **Redis**, một trong những kho dữ liệu in-memory được sử dụng rộng rãi nhất trên thế giới.

Cách tiếp cận của Sanfilippo với DS4 mang tính quan điểm đặc trưng: thay vì xây dựng một trình tải mô hình đa năng khác, ông chọn tập trung hoàn toàn vào việc làm cho **một mô hình** — DeepSeek V4 Flash — chạy cực kỳ tốt trên phần cứng local. Dự án không phải là một framework, không phải là một wrapper, và không phải là một trình chạy GGUF đa năng. Nó là một **Metal và CUDA graph executor dành riêng cho DeepSeek V4 Flash** với tải mô hình tùy chỉnh, render prompt, quản lý trạng thái KV và server API glue.

> "Dự án này sẽ không tồn tại nếu không có llama.cpp và GGML," Sanfilippo thừa nhận, dành toàn bộ công nhận cho Georgi Gerganov và cộng đồng llama.cpp. DS4 mượn các định dạng lượng tử hóa, ý tưởng kernel và kiến thức hệ sinh thái GGUF từ dự án đó, nhưng triển khai đường dẫn thực thi được tối ưu hóa riêng.

### Tại Sao Chọn DeepSeek V4 Flash?

Sanfilippo tin rằng DeepSeek V4 Flash là một mô hình đặc biệt hấp dẫn cho việc triển khai local. Đây là lý do:

1. **Tốc độ thông qua hiệu quả**: Với ít tham số hoạt động hơn trong quá trình suy luận, nó vượt trội hơn nhiều mô hình dense nhỏ hơn về thông lượng thô.
2. **Suy nghĩ tỷ lệ**: Ở chế độ thinking, độ dài phần suy luận của nó thích ứng với độ phức tạp của vấn đề — thường chỉ sử dụng 1/5 token suy nghĩ của các mô hình tương đương. Điều này làm cho nó thực tế cho các quy trình tác nhân thực tế nơi các mô hình khác sẽ bị đình trệ.
3. **Cửa sổ ngữ cảnh 1 triệu token**: Một trong những cửa sổ ngữ cảnh lớn nhất có sẵn trong bất kỳ mô hình open-weights nào, cho phép toàn bộ codebase, sách hoặc lịch sử hội thoại dài vừa trong một prompt duy nhất.
4. **Độ sâu kiến thức**: Với 284B tham số, nó biết đáng kể nhiều hơn các mô hình 27B hoặc 35B ở các rìa của kiến thức.
5. **Chất lượng viết vượt trội**: Người dùng báo cáo rằng nó "cảm giác như một mô hình biên giới" trong tiếng Anh, tiếng Ý và các ngôn ngữ khác.
6. **Bộ nhớ đệm KV nén**: Cho phép suy luận ngữ cảnh dài trên máy local và hỗ trợ **lưu trữ bộ nhớ đệm KV trên đĩa** — một yếu tố thay đổi cuộc chơi cho các quy trình tác nhân.
7. **Khả thi lượng tử hóa 2-bit**: Khi được lượng tử hóa không đối xứng (chỉ các routed experts), trọng số 2-bit chạy đáng ngạc nhiên tốt, vừa với các MacBook 96-128GB.

---

## Kiến Trúc Kỹ Thuật: Tối Ưu Hóa Metal so với CUDA

Kiến trúc của DS4 phản ánh một triết lý thiết kế rõ ràng: **tối đa hóa hiệu năng cho phần cứng mục tiêu**, ngay cả khi điều đó có nghĩa là hy sinh tính tổng quát. Dự án duy trì ba mục tiêu build:

| Mục Tiêu Build | Nền Tảng | Trường Hợp Sử Dụng |
|-------------|----------|----------|
| `make` | macOS | Build production tối ưu Metal |
| `make cuda-spark` | Linux (DGX Spark / GB10) | CUDA cho hệ thống NVIDIA GB10 |
| `make cuda-generic` | Linux (GPU CUDA khác) | Hỗ trợ GPU CUDA chung |
| `make cpu` | Bất kỳ | Chỉ để tham chiếu/gỡ lỗi |

### Metal trên macOS

Backend Metal là **mục tiêu tối ưu hóa chính** của DS4 cho macOS. Nó tận dụng kiến trúc bộ nhớ unified của Apple để loại bỏ nút thắt cổ chai truyền PCIe làm khổ các thiết lập GPU rời. Trên một Mac Studio M3 Ultra với 512GB RAM, DS4 đạt được:

- **468 tokens/giây prefill** trên prompt dài (11.709 tokens)
- **36,86 tokens/giây generation** với lượng tử hóa q2
- **448 tokens/giây prefill** và **35,5 tokens/giây generation** với q4

Các con số này cạnh tranh — và trong một số trường hợp vượt qua — những gì người dùng đạt được với llama.cpp hoặc Ollama trên phần cứng tương đương, đặc biệt là cho các khối lượng công việc ngữ cảnh dài nơi bộ nhớ đệm KV nén và prefill theo chunk của DS4 tỏa sáng.

### CUDA trên Linux

Đối với các máy trạm Linux, DS4 cung cấp hai đường dẫn build CUDA. Mục tiêu `cuda-spark` được tinh chỉnh cho nền tảng NVIDIA DGX Spark (GB10), trong khi `cuda-generic` hỗ trợ một loạt GPU CUDA local rộng hơn. Trên một DGX Spark GB10 với 128GB RAM, engine đạt **343 tokens/giây prefill** và **13,75 tokens/giây generation** với trọng số q2.

Đường dẫn CUDA chia sẻ cùng một engine thực thi đồ thị, nén bộ nhớ đệm KV và server API với bản build Metal, đảm bảo hành vi nhất quán trên các nền tảng.

### Đường Dẫn CPU: Chỉ Để Chẩn Đoán

DS4 bao gồm một backend CPU, nhưng Sanfilippo rõ ràng: **"Đừng coi đường dẫn CPU là mục tiêu production."** Nó tồn tại để xác thực tính đúng đắn, chẩn đoán tokenizer và kiểm thử hồi quy. Trên thực tế, trên các phiên bản macOS hiện tại, đường dẫn CPU có thể kích hoạt một lỗi kernel trong triển khai bộ nhớ ảo làm sập hệ thống — một lời nhắc nhở mạnh mẽ rằng đây là phần mềm chất lượng alpha.

### Các Đổi Mới Kiến Trúc Chính

1. **Lượng tử hóa 2-bit không đối xứng**: Khác với lượng tử hóa đều làm suy giảm tất cả các lớp như nhau, q2 quant của DS4 áp dụng `IQ2_XXS` cho các chiếu up/gate MoE routed và `Q2_K` cho các chiếu down, trong khi để nguyên shared experts, projections và các lớp routing. Điều này bảo toàn chất lượng ở nơi quan trọng nhất.

2. **Bộ nhớ đệm KV nén với lưu trữ đĩa**: DS4 coi bộ nhớ đệm KV là một "công dân đĩa hạng nhất." Thay vì giả định trạng thái KV phải nằm trong RAM, nó ghi các checkpoint vào SSD nhanh. Điều này cho phép cửa sổ ngữ cảnh 100K-300K (và thậm chí 1M) trên các máy có RAM hạn chế.

3. **Exact DSML tool-call replay**: Để tích hợp tác nhân, DS4 ghi nhớ chính xác văn bản DSML mà mô hình đã tạo cho mỗi lệnh gọi công cụ, được khóa bởi các ID không thể đoán. Khi các client stateless gửi lại kết quả công cụ, server phát lại chính xác các byte, tránh mismatch tiền tố và tính toán lại tốn kém.

4. **Model-specific graph executor**: Bằng cách không cố gắng hỗ trợ mọi tệp GGUF tồn tại, DS4 loại bỏ overhead của việc phân phối tensor chung và có thể hardcode các layout bộ nhớ tối ưu và chiến lược kernel fusion cho kiến trúc MoE của DeepSeek V4 Flash.

---

## Hướng Dẫn Cài Đặt cho macOS và Linux

### Điều Kiện Tiên Quyết

**macOS:**
- macOS 14+ (Sonoma hoặc mới hơn)
- Mac Apple Silicon (M1/M2/M3/M4 hoặc các biến thể Ultra)
- **Tối thiểu 96GB RAM** cho trọng số q2; **128GB khuyến nghị**
- **256GB+ RAM** cho trọng số q4
- Xcode Command Line Tools

**Linux (CUDA):**
- Ubuntu 22.04+ hoặc bản phân phối tương thích
- GPU NVIDIA với hỗ trợ CUDA
- CUDA Toolkit 12.x+
- **96GB+ RAM hệ thống** cho q2; **256GB+** cho q4
- `build-essential`, `curl`, `git`

### Bước 1: Sao Chép Repository

```bash
git clone https://github.com/antirez/ds4.git
cd ds4
```

### Bước 2: Tải Trọng Số Mô Hình

DS4 chỉ hoạt động với các tệp GGUF được chế tạo đặc biệt của riêng nó. Sử dụng script tải xuống được cung cấp:

```bash
# Cho máy RAM 96-128GB (khuyến nghị)
./download_model.sh q2-imatrix

# Cho máy RAM 256GB+
./download_model.sh q4-imatrix

# Tùy chọn: hỗ trợ speculative decoding
./download_model.sh mtp
```

Script tải từ Hugging Face (`antirez/deepseek-v4-gguf`), lưu trữ tệp trong `./gguf/`, và tạo một symlink tại `./ds4flash.gguf`.

### Bước 3: Build Engine

**macOS (Metal):**
```bash
make
```

**Linux (CUDA — DGX Spark / GB10):**
```bash
make cuda-spark
```

**Linux (CUDA — GPU chung):**
```bash
make cuda-generic
```

**Chỉ CPU (chẩn đoán):**
```bash
make cpu
```

Điều này tạo ra hai binary:
- `./ds4` — CLI tương tác
- `./ds4-server` — Server HTTP API tương thích OpenAI/Anthropic

### Bước 4: Xác Minh Cài Đặt

```bash
# Kiểm tra one-shot nhanh
./ds4 -p "Explain the CAP theorem in one paragraph."

# Xem tất cả tùy chọn
./ds4 --help
./ds4-server --help
```

---

## Benchmark Hiệu Năng: DS4 so với Ollama so với llama.cpp

Benchmark suy luận LLM nổi tiếng là khó — các con số thay đổi theo độ dài prompt, lượng tử hóa, kích thước batch và phần cứng. Dù vậy, các con số được công bố của DS4 cho thấy hiệu năng ấn tượng, đặc biệt cho **prefill ngữ cảnh dài**.

### Benchmark Chính Thức DS4 (Metal, `--ctx 32768`, greedy decoding, `-n 256`)

| Máy | Quant | Prompt | Prefill | Generation |
|---------|-------|--------|---------|------------|
| MacBook Pro M3 Max, 128GB | q2 | ngắn | 58,52 t/s | 26,68 t/s |
| MacBook Pro M3 Max, 128GB | q2 | 11.709 tokens | **250,11 t/s** | 21,47 t/s |
| Mac Studio M3 Ultra, 512GB | q2 | ngắn | 84,43 t/s | 36,86 t/s |
| Mac Studio M3 Ultra, 512GB | q2 | 11.709 tokens | **468,03 t/s** | 27,39 t/s |
| Mac Studio M3 Ultra, 512GB | q4 | ngắn | 78,95 t/s | 35,50 t/s |
| DGX Spark GB10, 128GB | q2 | 7.047 tokens | 343,81 t/s | 13,75 t/s |

### DS4 So Sánh Như Thế Nào

**so với Ollama:**
Ollama xuất sắc trong việc bắt đầu nhanh và hỗ trợ hàng trăm mô hình. Tuy nhiên, như một trình chạy đa năng, nó không thể áp dụng các tối ưu hóa dành riêng cho mô hình mà DS4 sử dụng. Đối với DeepSeek V4 Flash cụ thể, hỗn hợp lượng tử hóa không đối xứng, bộ nhớ đệm KV nén và kernel Metal tùy chỉnh của DS4 thường mang lại **thông lượng prefill tốt hơn 20-40%** trên phần cứng Apple Silicon tương đương.

**so với llama.cpp:**
llama.cpp là dự án nền tảng đã làm cho suy luận LLM local trở nên khả thi. DS4 công khai thừa nhận sự nợ nần của mình với llama.cpp và GGML. Nơi DS4 phân kỳ là trong **sự tập trung vào một mô hình**: bằng cách không hỗ trợ các tệp GGUF tùy ý, DS4 có thể hardcode các layout tensor, loại bỏ overhead phân phối chung và xác thực tính đúng đắn so với logit API DeepSeek chính thức. Đối với người dùng chỉ quan tâm đến DeepSeek V4 Flash, DS4 cung cấp một trải nghiệm "hoàn thiện" hơn với API server tích hợp, lưu đĩa KV caching và tích hợp tác nhân.

**Kết Luận:** Nếu bạn muốn một con dao Thụy Sĩ cho nhiều mô hình, Ollama hoặc llama.cpp là lựa chọn tốt hơn. Nếu bạn muốn DeepSeek V4 Flash chạy nhanh và đáng tin cậy nhất trên Mac Studio hoặc máy trạm CUDA của bạn, DS4 được xây dựng dành riêng cho công việc đó.

---

## Ví Dụ Mã cho Suy Luận

### CLI Prompt One-Shot

```bash
./ds4 -p "Write a Python function to implement merge sort."
```

### Phiên Chat Tương Tác

```bash
./ds4
```

Điều này khởi động một cuộc trò chuyện đa lượt với trạng thái KV liên tục. Các lệnh hữu ích:
- `/help` — Hiển thị các lệnh có sẵn
- `/think` — Bật chế độ suy nghĩ (mặc định)
- `/think-max` — Nỗ lực suy luận tối đa
- `/nothink` — Tắt suy nghĩ cho phản hồi nhanh hơn
- `/ctx 100000` — Đặt kích thước cửa sổ ngữ cảnh
- `/read FILE` — Bao gồm nội dung tệp trong ngữ cảnh
- `/quit` — Thoát

### Chế Độ Server với API Tương Thích OpenAI

```bash
./ds4-server \
  --ctx 100000 \
  --kv-disk-dir /tmp/ds4-kv \
  --kv-disk-space-mb 8192
```

Server khởi động tại `http://127.0.0.1:8000` với các endpoint sau:
- `GET /v1/models`
- `POST /v1/chat/completions`
- `POST /v1/completions`
- `POST /v1/messages` (tương thích Anthropic)

### Ví Dụ cURL (Chat Completions)

```bash
curl http://127.0.0.1:8000/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "deepseek-v4-flash",
    "messages": [
      {"role": "user", "content": "List three Redis design principles."}
    ],
    "stream": true
  }'
```

### Ví Dụ Client Python

```python
import openai

client = openai.OpenAI(
    base_url="http://127.0.0.1:8000/v1",
    api_key="dsv4-local"
)

response = client.chat.completions.create(
    model="deepseek-v4-flash",
    messages=[
        {"role": "system", "content": "You are a helpful coding assistant."},
        {"role": "user", "content": "Refactor this function to use list comprehensions."}
    ],
    stream=True,
    temperature=0.7
)

for chunk in response:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="")
```

### Ví Dụ Sử Dụng Công Cụ

DS4 hỗ trợ function calling theo kiểu OpenAI. Server chuyển đổi các schema công cụ sang định dạng DSML của DeepSeek và ánh xạ kết quả tự động:

```bash
curl http://127.0.0.1:8000/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "deepseek-v4-flash",
    "messages": [{"role": "user", "content": "What is the weather in Tokyo?"}],
    "tools": [{
      "type": "function",
      "function": {
        "name": "get_weather",
        "parameters": {
          "type": "object",
          "properties": {
            "location": {"type": "string"}
          },
          "required": ["location"]
        }
      }
    }],
    "tool_choice": "auto"
  }'
```

---

## Trường Hợp Sử Dụng: DS4 Xuất Sắc Ở Đâu

### 1. Phát Triển AI Local & Tác Nhân Lập Trình

DS4 được thiết kế rõ ràng cho **các quy trình tác nhân lập trình**. API server tương thích OpenAI của nó hoạt động với các framework tác nhân phổ biến như **OpenCode**, **Pi** và **Claude Code**. Bộ nhớ đệm KV trên đĩa có nghĩa là sau một lần prefill ban đầu tốn kém (thường 25K+ token cho thiết lập tác nhân), các lượt sau tái sử dụng prefix đã lưu thay vì tính toán lại từ đầu.

### 2. Triển Khai LLM Ưu Tiên Quyền Riêng Tư

Đối với các tổ chức xử lý dữ liệu nhạy cảm — tài liệu pháp lý, hồ sơ y tế, mã nguồn độc quyền — chạy DeepSeek V4 Flash local với DS4 đảm bảo **dữ liệu không rời khỏi máy của bạn**. Không có khóa API cần quản lý, không có giới hạn tốc độ và không bị khóa vào nhà cung cấp.

### 3. Triển Khai Edge

Với lượng tử hóa 2-bit cho phép hoạt động trên hệ thống 96GB và bộ nhớ đệm KV nén tràn ra đĩa, DS4 mang khả năng LLM hạng biên đến **phần cứng edge** mà trước đây yêu cầu API đám mây. Một Mac Studio trong cơ sở an toàn giờ đây có thể xử lý ngữ cảnh triệu token mà không cần kết nối internet.

### 4. Nghiên Cứu & Phân Tích Ngữ Cảnh Dài

Cửa sổ ngữ cảnh 1 triệu token mở ra những khả năng trước đây không thực tế:
- Phân tích toàn bộ hồ sơ vụ án pháp lý trong một lượt
- Xem xét lịch sử repository git đầy đủ với context diff đầy đủ
- Xử lý sách, bài nghiên cứu và các tập tài liệu
- Duy trì lịch sử hội thoại kéo dài hàng tháng mà không bị cắt ngắn

### 5. Tối Ưu Chi Phí

Với chi phí bằng không cho mỗi token, suy luận local với DS4 loại bỏ chi phí API cho các quy trình khối lượng cao. Khoản đầu tư phần cứng ban đầu (một Mac cao cấp hoặc máy trạm) nhanh chóng hoàn vốn khi xử lý hàng triệu token mỗi tháng.

---

## Các Hạn Chế Bạn Cần Biết

DS4 rất mạnh, nhưng điều quan trọng là phải hiểu các ràng buộc của nó:

1. **Chất lượng alpha**: Sanfilippo rõ ràng rằng mã là chất lượng alpha. Nó chỉ tồn tại trong thời gian ngắn và sẽ mất vài tháng để trưởng thành. Hãy mong đợi lỗi và các điểm thô ráp.

2. **Hỗ trợ một mô hình**: DS4 chỉ chạy các GGUF DeepSeek V4 Flash được tạo riêng cho dự án này. Bạn không thể tải các tệp GGUF tùy ý hoặc các mô hình khác.

3. **Yêu cầu bộ nhớ cao**: Hoạt động thực tế yêu cầu 96-128GB RAM cho trọng số q2 và 256GB+ cho q4. Điều này loại trừ hầu hết các laptop người tiêu dùng.

4. **Đường dẫn CPU bị hỏng trên macOS**: Một lỗi kernel VM macOS gây sập hệ thống khi chạy suy luận CPU. Metal là đường dẫn macOS khả thi duy nhất.

5. **Không có batching yêu cầu**: Server xử lý một yêu cầu suy luận tại một thời điểm. Các yêu cầu đồng thời xếp hàng và chờ đến lượt.

6. **MTP speculative decoding là thử nghiệm**: Đường dẫn MTP tùy chọn hiện chỉ cung cấp tốc độ tăng tối đa nhẹ, không phải lợi ích generation có ý nghĩa.

7. **Phát triển có hỗ trợ AI**: Codebase được xây dựng với sự hỗ trợ nặng từ GPT-5.5. Nếu bạn không thoải mái với mã được tạo bởi AI, DS4 có thể không phù hợp với bạn.

8. **Phạm vi nền tảng**: Được tối ưu hóa cho Metal (macOS) và CUDA (Linux). Hỗ trợ Windows và AMD GPU không phải là ưu tiên hiện tại.

---

## Kết Luận

DS4 đại diện cho một can đảm về tương lai của suy luận LLM local: **làm một điều xuất sắc** thay vì nhiều điều đầy đủ. Bằng cách tập trung độc quyền vào DeepSeek V4 Flash, Salvatore Sanfilippo đã tạo ra một engine vượt trội hơn các lựa chọn thay thế đa năng trên mô hình cụ thể mà nó nhắm đến, đồng thời cung cấp các tính năng sẵn sàng production như lưu đĩa KV caching, replay tool-call chính xác và API tương thích OpenAI.

Đối với các nhà phát triển có phần cứng để chạy nó — một Mac Studio cao cấp hoặc máy trạm Linux trang bị CUDA — DS4 cung cấp một con đường hấp dẫn đến **suy luận riêng tư, nhanh chóng và miễn phí** với một trong những mô hình open-weights có khả năng nhất hiện có. Cửa sổ ngữ cảnh 1 triệu token, các chế độ suy nghĩ thông minh và kiến trúc KV nén làm cho nó đặc biệt phù hợp cho tác nhân lập trình, phân tích tài liệu dài và các triển khai quan trọng về quyền riêng tư.

Khi dự án trưởng thành từ alpha sang ổn định, DS4 có thể trở thành cách xác định để chạy DeepSeek V4 Flash local. Nếu bạn có phần cứng và trường hợp sử dụng, nó hoàn toàn đáng để đánh giá cùng với Ollama và llama.cpp.

---

**Sẵn sàng thử DS4?** Truy cập [github.com/antirez/ds4](https://github.com/antirez/ds4), sao chép repository, tải trọng số q2-imatrix và trải nghiệm suy luận local hạng biên ngay hôm nay.

---

*Được xuất bản bởi dibi8 Tech Team. Để biết thêm hướng dẫn về công cụ AI, tài nguyên dành cho nhà phát triển và phần mềm mã nguồn mở, hãy truy cập [dibi8.com](https://dibi8.com).*

## FAQ: Ép Xung DS4 Tới Bến Cùng Lời Khuyên Phần Cứng

**Q: Có chạy nổi DeepSeek V4 Flash trên MacBook Pro M3 không? (run DeepSeek V4 on MacBook Pro M3)**
A: Nổi chứ! Nhờ trò lượng tử hóa 2-bit và bú đồ họa Metal, cắm vào bản M3 Max 128GB RAM là chạy mượt như sunsilk. Ram 64GB thì gánh mấy bản nhỏ hơn vẫn ngon.

**Q: Chạy DS4 ở nhà so với thuê API của DeepSeek thì cái nào hời hơn?**
A: Nếu nuôi mấy con bot code chạy 24/7, tiền API có khi đốt hàng ngàn đô mỗi tháng. Đầu tư một con Mac khủng chạy DS4 là xài cả đời, đách tốn thêm đồng bạc lẻ nào cho API.

**Q: Cái trò lưu KV Cache xuống đĩa cứng của DS4 ảo tới mức nào?**
A: Thằng Ollama tắt tab là bay hết trí nhớ, lúc chat lại phải ngồi đợi nó suy nghĩ. Còn DS4 nó dump cả đống KV Cache xuống SSD. Bạn vứt cái log chat 100k token vào, mai mở lên chat tiếp ngay tắp lự, không phải đợi nó đọc lại từ đầu!

---

## Hạ Tầng Đề Xuất Cho Tự Lưu Trữ

Để chạy stack này 24/7 ổn định, lựa chọn hạ tầng rất quan trọng:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 tín dụng miễn phí 60 ngày, 14+ region toàn cầu. Lựa chọn mặc định cho developer độc lập.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — VPS Hong Kong, độ trễ thấp với người dùng Việt Nam. dibi8.com cũng được host ở đây.
- **{{< aff "hostinger" "footer-cta-legacy" "Hostinger" >}}** — Lựa chọn VPS giá tốt cho thị trường Việt Nam, giảm 60% gói đầu tiên.

*Đây là affiliate link, không phát sinh chi phí thêm cho bạn nhưng giúp dibi8.com duy trì hoạt động.*

