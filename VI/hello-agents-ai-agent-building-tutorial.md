---
title: "Hello-Agents: Cách Hướng Dẫn AI Agent Mã Nguồn Mở Của Datawhale Giúp Bạn Xây Dựng Agent Cấp Sản Xuất Từ Con Số 0"
description: "Datawhale Hello-Agents là hướng dẫn AI agent mã nguồn mở phổ biến nhất trên GitHub, bao gồm 16 chương đầy đủ về ReAct, AutoGen, LangGraph, MCP, Agentic RL và hơn 45,600 Stars."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Go
  - JavaScript
  - Python
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "197.3 MB"
file_md5: ""
download_url: "https://github.com/datawhalechina/hello-agents"
backup_url: ""
github_repo: "https://github.com/datawhalechina/hello-agents"
stars: 50847
maintainer: "datawhalechina"
last_maintained: "2026-05-14"
featureImage: ""
draft: false
faqs:
  - q: 'Datawhale Hello-Agents là gì?'
    a: 'Hello-Agents là một hướng dẫn mã nguồn mở miễn phí từ cộng đồng Datawhale của Trung Quốc, dạy cách xây dựng AI agent từ đầu. Nó cung cấp chương trình học gồm 16 chương kèm code chạy được, có sẵn dưới dạng sách trực tuyến, tài liệu cục bộ và file PDF tải về được.'
  - q: 'Chương trình 16 chương của Hello-Agents bao gồm những chủ đề nào?'
    a: 'Nó bao quát nền tảng về agent và LLM, các mô hình kinh điển (ReAct, Plan-and-Solve, Reflection), các nền tảng low-code (Coze, Dify, n8n), các framework chuyên nghiệp (AutoGen, AgentScope, LangGraph), bộ nhớ và RAG, kỹ thuật ngữ cảnh, các giao thức giao tiếp (MCP, A2A, ANP), Agentic RL (SFT, RLHF, GRPO), đánh giá, và ba nghiên cứu tình huống capstone toàn diện.'
  - q: 'Bạn cần ngôn ngữ lập trình và môi trường nào để học Hello-Agents?'
    a: 'Code chủ yếu là Python (khoảng 72.5%) với Jupyter notebooks. Thiết lập được khuyến nghị là Python 3.9+, một OpenAI API key hoặc quyền truy cập GitHub Models, tùy chọn thêm Ollama cho mô hình cục bộ và Chroma hoặc Weaviate làm cơ sở dữ liệu vector cho các chương RAG.'
  - q: 'Hello-Agents có miễn phí không và giấy phép của nó là gì?'
    a: 'Có, Hello-Agents hoàn toàn miễn phí theo giấy phép mã nguồn mở, và file PDF đầy đủ có sẵn miễn phí qua GitHub releases hoặc website Datawhale. File PDF có watermark Datawhale để ngăn việc bán lại thương mại nhưng vẫn dùng được trọn vẹn cho việc học cá nhân.'
  - q: 'Bạn có thể xây dựng những dự án thực tế nào khi học theo Hello-Agents?'
    a: 'Hướng dẫn này bao gồm ba nghiên cứu tình huống toàn diện: một Trợ lý Du lịch Thông minh điều phối nhiều agent chuyên biệt thông qua việc gọi công cụ MCP, một agent Nghiên cứu Chuyên sâu Tự động tìm kiếm và tổng hợp các phát hiện trên web thành một báo cáo, và một mô phỏng Cyber Town được lấp đầy bởi các AI agent với tính cách và thói quen riêng biệt.'
---
{</* resource-info */>}

## Hello-Agents Là Gì?

**Hello-Agents** là **hướng dẫn AI agent mã nguồn mở có hệ thống** được tạo bởi cộng đồng giáo dục AI mã nguồn mở nổi tiếng **Datawhale** của Trung Quốc. Dự án đã đạt **45,600+ Stars** trên GitHub, trở thành điểm khởi đầu uy tín cho bất kỳ ai muốn chuyển từ "người dùng LLM" thành "người xây dựng hệ thống Agent".

**GitHub**: https://github.com/datawhalechina/hello-agents
**Stars**: 45,600+
**Giấy phép**: Apache 2.0

---

## Tại Sao Cần Hello-Agents?

Năm 2025 được công nhận rộng rãi là "Năm của AI Agent". Từ Operator của OpenAI đến giao thức A2A của Google, từ MCP của Anthropic đến UI-TARS của ByteDance, toàn bộ ngành công nghiệp đang chuyển hướng sang các hệ thống thông minh tự chủ có thể nhận thức, lập kế hoạch và hành động thay mặt người dùng.

Tuy nhiên, đối với hầu hết các nhà phát triển, khoảng cách giữa "sử dụng chatbot" và "xây dựng Agent thực sự" vẫn còn rất lớn. Hello-Agents chính là giải pháp toàn diện lấp đầy khoảng trống này.

---

## Chương Trình Học 16 Chương Đầy Đủ

### Phần 1: Nền Tảng Agent & Mô Hình Ngôn Ngữ
- **Chương 1: Lần Đầu Gặp Gỡ Agent** — Định nghĩa, lịch sử tiến hóa và các mô hình chính
- **Chương 2: Lịch Sử Phát Triển Agent** — Từ AI biểu tượng qua AlphaGo đến hệ thống tự chủ dựa trên LLM
- **Chương 3: Nền Tảng LLM** — Kiến trúc Transformer, cơ chế attention, kỹ thuật prompting

### Phần 2: Xây Dựng Agent LLM Đầu Tiên
- **Chương 4: Các Mô Hình Agent Cổ Điển** — Triển khai ReAct, Plan-and-Solve, Reflection từ con số 0
- **Chương 5: Agent Nền Tảng Low-Code** — Thực chiến với Coze, Dify, n8n
- **Chương 6: Thực Hành Phát Triển Framework** — So sánh thực chiến AutoGen, AgentScope, LangGraph
- **Chương 7: Tự Xây Dựng Framework Agent** — Xây dựng framework agent tối thiểu chỉ với OpenAI API và thư viện chuẩn

### Phần 3: Mở Rộng Kiến Thức Nâng Cao
- **Chương 8: Bộ Nhớ & Truy Xuất** — Bộ nhớ ngắn hạn, bộ nhớ dài hạn, hệ thống tìm kiếm vector RAG
- **Chương 9: Kỹ Thuật Ngữ Cảnh** — Chiến lược cửa sổ, kỹ thuật tóm tắt, cấu trúc ngữ cảnh phân cấp
- **Chương 10: Giao Thức Liên Lạc Agent** — Phân tích sâu 3 giao thức MCP, A2A, ANP
- **Chương 11: Agentic RL** — Pipeline huấn luyện đầy đủ SFT, RLHF, GRPO
- **Chương 12: Đánh Giá Hiệu Suất Agent** — Các bài kiểm tra benchmark AgentBench, SWE-bench

### Phần 4: Các Case Study Toàn Diện
- **Chương 13: Trợ Lý Du Lịch Thông Minh** — Thực chiến gọi công cụ MCP với đa agent hợp tác
- **Chương 14: Agent Nghiên Cứu Sâu Tự Động** — Tái tạo khả năng DeepResearch của OpenAI
- **Chương 15: Xây Dựng Thị Trấn Mạng** — Mô phỏng động lực xã hội đa agent và hành vi nổi lên

### Phần 5: Dự Án Tổng Hợp & Triển Vọng
- **Chương 16: Dự Án Tổng Hợp** — Thiết kế và xây dựng ứng dụng agent thông minh hoàn chỉnh từ con số 0

---

## Điểm Nổi Bật Cốt Lõi

| Khả Năng | Hello-Agents | Tài Liệu Framework | Bootcamp Trả Phí | Video Hướng Dẫn |
|----------|-------------|-------------------|-----------------|-----------------|
| Chương trình có cấu trúc | 16 chương tiến bộ | Phân mảnh | Đa dạng | Không có cấu trúc |
| Độ sâu lý thuyết | Từ Transformer đến RL | Chỉ framework | Thường nông cạn | Thường nông cạn |
| Lập trình thực hành | Mỗi chương | Chỉ ví dụ | Hạn chế | Hiếm khi hoàn chỉnh |
| Low-code + Code-native | Cả hai | Chỉ code | Thường một trong hai | Chất lượng hỗn hợp |
| Chủ đề nâng cao | Đầy đủ chương | Hiếm khi | Chỉ cấp cao | Gần như không bao giờ |
| Dự án thực tế | 3 case study | Thường không | 1-2 dự án | Hiếm khi cấp sản xuất |
| Cộng đồng & cập nhật | 71 người đóng góp | Kiểm soát bởi vendor | N/A | Không đáng tin |
| Giá | Miễn phí | Miễn phí | $500-$5000 | Miễn phí |

---

## Bắt Đầu Nhanh

```bash
# Đọc trực tuyến
# https://datawhalechina.github.io/hello-agents/

# Thiết lập cục bộ
git clone https://github.com/datawhalechina/hello-agents.git
cd hello-agents
# Tham khảo Extra-Chapter/07 để cấu hình môi trường

# Chạy ReAct Agent chương 4
python code/chapter4/react_agent.py
```

---

## Ví Dụ Mã: Xây Dựng ReAct Agent Từ Con Số 0

```python
import openai
import json

tools = [
    {
        "type": "function",
        "function": {
            "name": "search_web",
            "description": "Tìm kiếm thông tin trên web",
            "parameters": {
                "type": "object",
                "properties": {"query": {"type": "string"}},
                "required": ["query"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "calculate",
            "description": "Thực hiện phép tính toán học",
            "parameters": {
                "type": "object",
                "properties": {"expression": {"type": "string"}},
                "required": ["expression"]
            }
        }
    }
]

def search_web(query): return f"Kết quả tìm kiếm: {query}"
def calculate(expr): return str(eval(expr))

messages = [
    {"role": "system", "content": "Bạn là trợ lý hữu ích. Sử dụng công cụ khi cần."},
    {"role": "user", "content": "Dân số Tokyo chia cho 1000 là bao nhiêu?"}
]

for step in range(5):
    response = openai.chat.completions.create(
        model="gpt-4", messages=messages, tools=tools, tool_choice="auto"
    )
    message = response.choices[0].message
    messages.append(message)
    
    if message.tool_calls:
        for tc in message.tool_calls:
            name = tc.function.name
            args = json.loads(tc.function.arguments)
            result = search_web(**args) if name == "search_web" else calculate(**args)
            messages.append({"role": "tool", "tool_call_id": tc.id, "content": result})
    else:
        print("Câu trả lời cuối cùng:", message.content)
        break
```

> Vòng lặp "suy nghĩ → gọi công cụ → quan sát kết quả → suy nghĩ lại" này chính là cơ chế cốt lõi mà các Agent hàng đầu như OpenAI Operator và Claude Computer Use sử dụng.

---

## Đối Tượng Phù Hợp

| Đối tượng | Giá trị |
|-----------|---------|
| **Người tìm việc AI Engineer** | Nắm vững năng lực cốt lõi Agent Engineering, câu hỏi phỏng vấn từ đề thực tế của các công ty lớn |
| **Đội ngũ sản phẩm** | Dùng chương low-code để nhanh chóng tạo prototype, dùng chương framework để hợp tác hiệu quả với dev |
| **Nhà nghiên cứu/Học giả** | Chương Agentic RL và đánh giá đủ sâu để làm điểm khởi đầu cho dự án nghiên cứu |
| **Lập trình viên độc lập/Nhà sáng lập** | Cấu trúc capstone và thư viện dự án cộng đồng cung cấp cảm hứng và tham chiếu cho sản phẩm hóa |

---

## Tóm Tắt

Hello-Agents là tài nguyên học phát triển AI agent toàn diện nhất, dễ hiểu nhất và có hỗ trợ cộng đồng mạnh mẽ nhất hiện có. Nó kết hợp **độ sâu của khóa học đại học**, **tính thực tiễn của bootcamp**, **sức sống cộng đồng của dự án mã nguồn mở**, và **mức giá của tài liệu miễn phí**.

Cuộc cách mạng agent không phải sắp đến — nó đã ở đây. Hello-Agents đảm bảo bạn không chỉ là người quan sát, mà là người xây dựng.

> 💡 Muốn biết thêm công cụ AI và dự án mã nguồn mở? Theo dõi [dibi8.com](https://dibi8.com) để nhận các lựa chọn được chọn lọc hàng tuần.

---

## Hạ Tầng Đề Xuất Cho Tự Lưu Trữ

Để chạy stack này 24/7 ổn định, lựa chọn hạ tầng rất quan trọng:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 tín dụng miễn phí 60 ngày, 14+ region toàn cầu. Lựa chọn mặc định cho developer độc lập.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — VPS Hong Kong, độ trễ thấp với người dùng Việt Nam. dibi8.com cũng được host ở đây.
- **{{< aff "hostinger" "footer-cta-legacy" "Hostinger" >}}** — Lựa chọn VPS giá tốt cho thị trường Việt Nam, giảm 60% gói đầu tiên.

*Đây là affiliate link, không phát sinh chi phí thêm cho bạn nhưng giúp dibi8.com duy trì hoạt động.*

