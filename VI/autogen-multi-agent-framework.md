---
title: 'Hướng Dẫn AutoGen 2025: Xây Dựng Hệ Thống AI Đa Agent Dễ Dàng'
description: 'Hướng dẫn chi tiết Microsoft AutoGen 2025: kiến trúc multi-agent, ConversableAgent, GroupChat, code execution và triển khai production systems.'
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
- /posts/autogen-multi-agent-framework/
---

{</* resource-info */>}

Khi các tác vụ AI ngày càng phức tạp — từ phân tích dữ liệu đa bước đến lập trình phần mềm tự động — một single LLM call không còn đủ để đạt kết quả chất lượng cao. **AutoGen**, framework multi-agent của Microsoft Research, giải quyết thách thức này bằng cách cho phép nhiều AI agents hợp tác, thảo luận và thực thi code để hoàn thành nhiệm vụ. Ra mắt vào năm 2023, AutoGen đã nhanh chóng đạt hơn 35.000 stars trên GitHub và trở thành một trong những công cụ hàng đầu cho việc xây dựng hệ thống AI đa agent. Bài viết này cung cấp hướng dẫn toàn diện từ cài đặt đến triển khai production.

## AutoGen Là Gì?

### Giới Thiệu Framework AutoGen Củ Microsoft

AutoGen là một framework mã nguồn mở cho phép phát triển các ứng dụng LLM bằng cách sử dụng **nhiều agents có thể trò chuyện với nhau** (conversable agents). Khác với các framework truyền thống tập trung vào single-chain execution, AutoGen tổ chức computation như một cuộc hội thoại giữa các agents — mỗi agent có vai trò, khả năng và trách nhiệm riêng.

Triết lý thiết kế của AutoGen dựa trên ba nguyên tắc:

1. **Conversable**: agents giao tiếp với nhau qua messages tự nhiên
2. **Customizable**: dễ dàng định nghĩa agents với các khả năng và hành vi tùy chỉnh
3. **Composable**: agents có thể kết hợp thành các hệ thống phức tạp

### AutoGen So Với Các Framework Agent Khác

| Framework | Đặc điểm chính | Số agents | Thực thi code | GitHub Stars (05/2025) |
|---|---|---|---|---|
| **AutoGen** | Conversational multi-agent | Không giới hạn | Có (native) | 35.000+ |
| **CrewAI** | Role-based agent teams | 3-5 agents | Không native | 25.000+ |
| **LangGraph** | Stateful DAG workflows | Theo đồ thị | Qua tools | 95.000+ (LangChain) |
| **MetaGPT** | Software engineering focus | 5+ roles | Có | 45.000+ |

AutoGen nổi bật ở khả năng **thực thi code trực tiếp** — agents không chỉ tạo code mà còn chạy nó, kiểm tra kết quả và tự sửa lỗi.

## Kiến Trúc AutoGen Và Các Khái Niệm Core

### ConversableAgent: Lớp Agent Cơ Sở

`ConversableAgent` là lớp cơ sở cho mọi agent trong AutoGen. Mỗi agent có:

- **Name**: định danh duy nhất trong hệ thống
- **System message**: hướng dẫn vai trò và hành vi
- **LLM config**: cấu hình model (GPT-4, Claude, local LLM)
- **Code execution config**: khả năng thực thi code (Python, shell)
- **Function map**: các hàm Python mà agent có thể gọi

### UserProxyAgent: Con Ngườitrong Vòng Lặp

`UserProxyAgent` đại diện cho ngườidùng con ngườitrong hệ thống. Agent này có thể:

- Nhập input từ ngườidùng khi được yêu cầu
- Thực thi code trên máy local
- Gửi kết quả thực thi cho các agents khác
- Quyết định khi nào kết thúc cuộc hội thoại

### AssistantAgent: Agent Viết Code

`AssistantAgent` là agent mặc định sử dụng LLM để viết code, phân tích và giải quyết vấn đề. Đây thường là "bộ não" của hệ thống — nó đưa ra kế hoạch, viết code và yêu cầu UserProxyAgent thực thi.

### GroupChat: Hợp Tác Đa Agent

`GroupChat` cho phép nhiều hơn hai agents tham gia cùng một cuộc hội thoại. Các agents trong group chat có thể:

- Trò chuyện theo thứ tự round-robin
- Sử dụng speaker selection strategy để chọn agent tiếp theo
- Chia sẻ context và kết quả với nhau

### Quản Lý Lịch Sử Và Bộ Nhớ

AutoGen tự động lưu trữ toàn bộ lịch sử hội thoại giữa các agents. Mỗi message bao gồm:

- **Role**: ai là ngườigửi (assistant, user, function)
- **Content**: nội dung message
- **Metadata**: thông tin bổ sung như function calls

Lịch sử này được truyền cho LLM ở mỗi turn, cho phép agents duy trì context trong suốt cuộc hội thoại.

## Cài Đặt Và Thiết Lập

### Cài Đặt AutoGen

```bash
# Cài đặt phiên bản stable mới nhất (v0.2+)
pip install pyautogen

# Hoặc cài từ source
pip install git+https://github.com/microsoft/autogen.git

# Cài với tính năng bổ sung
pip install "pyautogen[retrievechat]"  # RAG support
pip install "pyautogen[lmm]"           # Vision support
```

### Cấu Hình LLM Endpoints

```python
import autogen

# Cấu hình OpenAI
config_list = [
    {
        "model": "gpt-4o",
        "api_key": "your-openai-api-key",
    }
]

# Hoặc cấu hình Azure OpenAI
config_list_azure = [
    {
        "model": "gpt-4",
        "api_key": "your-azure-api-key",
        "base_url": "https://your-resource.openai.azure.com/",
        "api_type": "azure",
        "api_version": "2024-02-15-preview"
    }
]
```

## Xây Dựng Hệ Thống Multi-Agent Đầu Tiên

### Tạo Cuộc Hội Thoại Hai Agent Đơn Giản

```python
import autogen

# Cấu hình LLM
config_list = [{"model": "gpt-4o-mini", "api_key": "your-key"}]

# Tạo Assistant Agent
assistant = autogen.AssistantAgent(
    name="assistant",
    llm_config={"config_list": config_list},
    system_message="Bạn là trợ lý hữu ích. Viết code Python và để ngườidùng thực thi."
)

# Tạo User Proxy Agent
user_proxy = autogen.UserProxyAgent(
    name="user_proxy",
    human_input_mode="NEVER",
    max_consecutive_auto_reply=10,
    is_termination_msg=lambda x: x.get("content", "").rstrip().endswith("TERMINATE"),
    code_execution_config={"work_dir": "coding", "use_docker": False},
    llm_config={"config_list": config_list},
)

# Bắt đầu hội thoại
user_proxy.initiate_chat(
    assistant,
    message="Viết code Python để vẽ biểu đồ hàm sin(x) từ 0 đến 2*pi và lưu thành file PNG."
)
```

### Bật Thực Thi Code

AutoGen có thể thực thi code trong sandbox environment:

```python
code_execution_config = {
    "work_dir": "coding_workspace",  # Thư mục làm việc
    "use_docker": True,               # Chạy trong container Docker
    "timeout": 120,                   # Timeout 120 giây
    "last_n_messages": 3,             # Số message gần nhất để extract code
}
```

**Khuyến nghị bảo mật**: luôn bật `use_docker=True` trong production để cô lập code execution.

### Thiết Lập Điều Kiện Kết Thúc

```python
# Tự động kết thúc khi agent reply "TERMINATE"
is_termination_msg = lambda x: "TERMINATE" in x.get("content", "")

# Hoặc giới hạn số lượng reply tự động
max_consecutive_auto_reply=5
```

## Advanced Agent Patterns

### GroupChat Với Nhiều Agents

```python
from autogen import GroupChat, GroupChatManager

# Định nghĩa các agents
planner = autogen.AssistantAgent(
    name="planner",
    system_message="Bạn lập kế hoạch. Đưa ra kế hoạch bước-by-bước.",
    llm_config={"config_list": config_list}
)

coder = autogen.AssistantAgent(
    name="coder",
    system_message="Bạn viết code Python chất lượng cao.",
    llm_config={"config_list": config_list}
)

reviewer = autogen.AssistantAgent(
    name="reviewer",
    system_message="Bạn review code và đưa ra feedback.",
    llm_config={"config_list": config_list}
)

# Thiết lập GroupChat
groupchat = GroupChat(
    agents=[user_proxy, planner, coder, reviewer],
    messages=[],
    max_round=20,
    speaker_selection_method="round_robin"
)

manager = GroupChatManager(groupchat=groupchat, llm_config={"config_list": config_list})

user_proxy.initiate_chat(manager, message="Xây dựng ứng dụng Flask đơn giản với CRUD API.")
```

### Sequential Chat Workflows

```python
# Chạy nhiều cuộc hội thoại liên tiếp với context carryover
result = user_proxy.initiate_chats(
    [
        {"recipient": planner, "message": "Lập kế hoạch xây dựng chatbot.", "summary_method": "last_msg"},
        {"recipient": coder, "message": "Viết code theo kế hoạch.", "summary_method": "last_msg"},
        {"recipient": reviewer, "message": "Review code đã viết.", "summary_method": "last_msg"},
    ]
)
```

### Nested Chat Patterns

Nested cho phép một agent đóng vai trò như một "ngườimôi giới" — nhận message, chuyển nội bộ cho các agents khác xử lý, rồi trả lờingườigửi ban đầu:

```python
# Thiết lập nested chat cho coding assistant
coding_assistant.register_nested_chats(
    trigger=planner,
    chat_queue=[
        {"recipient": coder, "message": lambda x: x},
        {"recipient": reviewer, "message": lambda x: x},
    ]
)
```

### Human-in-the-Loop Và Approval Modes

```python
# Chế độ ALWAYS: luôn hỏi ngườidùng trước mỗi action
user_proxy = autogen.UserProxyAgent(
    name="user_proxy",
    human_input_mode="ALWAYS",  # Luôn chờ ngườidùng
)

# Chế độ TERMINATE: chỉ hỏi khi cần quyết định quan trọng
human_input_mode="TERMINATE"
```

### Tạo Agent Classes Tùy Chỉnh

```python
from autogen import ConversableAgent

class DataAnalystAgent(ConversableAgent):
    def __init__(self, **kwargs):
        super().__init__(
            name="data_analyst",
            system_message="Bạn là chuyên gia phân tích dữ liệu.",
            **kwargs
        )

    def analyze_data(self, data_path):
        # Logic phân tích tùy chỉnh
        pass
```

## AutoGen Với Local Và Open-Source Models

### Sử Dụng Ollama Với AutoGen

```python
config_list_local = [
    {
        "model": "llama3.1:8b",
        "base_url": "http://localhost:11434/v1",
        "api_key": "ollama",  # Ollama không cần API key thực
    }
]

assistant = autogen.AssistantAgent(
    name="local_assistant",
    llm_config={"config_list": config_list_local}
)
```

### Tích Hợp vLLM Và LM Studio

```python
# vLLM config
config_vllm = [{
    "model": "meta-llama/Llama-3.1-8B-Instruct",
    "base_url": "http://localhost:8000/v1",
    "api_key": "dummy",
}]

# LM Studio config (OpenAI-compatible)
config_lmstudio = [{
    "model": "local-model",
    "base_url": "http://localhost:1234/v1",
    "api_key": "dummy",
}]
```

### Chiến Lược Tối Ưu Chi Phí

| Chiến lược | Mô tả | Tiết kiệm ước tính |
|---|---|---|
| **Model routing** | Dùng model nhỏ cho tasks đơn giản, model lớn cho tasks phức tạp | 40-60% |
| **Local LLM cho dev** | Dùng Ollama/LM Studio trong development | 100% (dev phase) |
| **Caching responses** | Lưu cache các queries phổ biến | 20-30% |
| **Group chat limits** | Giới hạn max_round và auto-replies | 30-50% |

## Use Cases Thực Tế

### Pipeline Phân Tích Dữ Liệu Tự Động

Một hệ thống gồm 3 agents tự động phân tích dataset:

1. **Data Loader Agent**: tải và làm sạch dữ liệu
2. **Analyst Agent**: thực hiện phân tích thống kê và trực quan hóa
3. **Reporter Agent**: tổng hợp kết quả thành báo cáo

### Hệ Thống Code Review Đa Agent

- **Coder Agent**: viết code theo yêu cầu
- **Tester Agent**: viết unit tests
- **Reviewer Agent**: review code quality và best practices
- **User Proxy**: thực thi tests và phê duyệt

### Trợ Lý Nghiên Cứu Với Tìm Kiếm Web

```python
from autogen.agentchat.contrib.web_surfer import WebSurferAgent

web_surfer = WebSurferAgent(
    name="web_surfer",
    llm_config={"config_list": config_list},
    summarizer_llm_config={"config_list": config_list},
    browser_config={"viewport_size": (4096, 1600)},
)
```

### Workflow Tạo Nội Dung

- **Research Agent**: thu thập thông tin về chủ đề
- **Writer Agent**: viết bài dựa trên thông tin thu thập
- **Editor Agent**: chỉnh sửa và cải thiện chất lượng

## AutoGen Và LangGraph: Nên Chọn Cái Nào?

### AutoGen Cho Multi-Agent Hội Thoại

Chọn AutoGen khi:

- Agents cần **trò chuyện tự nhiên** với nhau qua nhiều turns
- Cần **thực thi code** trực tiếp trong workflow
- Cần **human-in-the-loop** với approval workflows
- Dự án tập trung vào **research và data analysis**

### LangGraph Cho Stateful DAG Workflows

Chọn LangGraph khi:

- Workflow có cấu trúc **đồ thị cố định** với nodes và edges rõ ràng
- Cần **streaming và async execution** hiệu suất cao
- Ứng dụng cần **integration sâu với LangChain ecosystem**
- Dự án yêu cầu **observability qua LangSmith**

### Khả Năng Tích Hợp

Cả hai framework có thể bổ sung cho nhau. Ví dụ: dùng LangGraph để điều phối luồng dữ liệu tổng thể, và AutoGen để xử lý các sub-tasks phức tạp cần collaboration đa agent.

## Best Practices Và Mẹo Production

### Quản Lý Chi Phí Token

```python
# Giới hạn max_tokens cho mỗi response
llm_config = {
    "config_list": config_list,
    "cache_seed": 42,  # Bật caching
    "temperature": 0.1,  # Giảm randomness, tiết kiệm tokens
}
```

### Xử Lý Lỗi Và Retry

```python
import openai

# Cấu hình retry
custom_config = {
    "config_list": config_list,
    "timeout": 60,
    "max_retries": 3,
}
```

### Bảo Mật Cho Thực Thi Code

| Cấp độ | Mô tả | Khuyến nghị |
|---|---|---|
| **No execution** | Tắt hoàn toàn code execution | Production public |
| **Docker sandbox** | Chạy trong container cô lập | Production internal |
| **Local execution** | Chạy trực tiếp trên máy | Development only |

```python
# Luôn dùng Docker trong production
code_execution_config = {
    "use_docker": True,
    "image": "python:3.11-slim",
    "timeout": 60,
}
```

### Debug Cuộc Hội Thoại Agent

```python
# Bật logging chi tiết
import logging
logging.basicConfig(level=logging.DEBUG)

# Hoặc dùng GroupChat với speaker selection tự động
# để theo dõi luồng hội thoại
```

## FAQ — Các Câu Hỏi Thường Gặp

### AutoGen được sử dụng cho mục đích gì?

AutoGen được thiết kế để xây dựng các ứng dụng AI multi-agent — nơi nhiều AI agents hợp tác để hoàn thành nhiệm vụ phức tạp. Các use cases phổ biến bao gồm: phân tích dữ liệu tự động, lập trình phần mềm có AI pair programming, nghiên cứu tự động với tìm kiếm web, tạo nội dung đa bước, và xử lý các workflow business phức tạp.

### AutoGen có miễn phí và mã nguồn mở không?

**Có**, AutoGen hoàn toàn miễn phí và mã nguồn mở dưới giấy phép MIT. Tuy nhiên, AutoGen sử dụng LLM APIs (như OpenAI GPT-4) để hoạt động — và đây là nơi phát sinh chi phí. Bạn có thể giảm chi phí đáng kể bằng cách sử dụng local LLMs qua Ollama hoặc LM Studio.

### AutoGen và CrewAI khác nhau như thế nào?

**AutoGen** tập trung vào **conversational agents** với khả năng thực thi code trực tiếp — agents trò chuyện tự nhiên với nhau qua nhiều turns. **CrewAI** sử dụng mô hình **role-based** — mỗi agent có vai trò cụ thể (researcher, writer, editor) và thực hiện tasks theo thứ tự. AutoGen phù hợp cho tasks phân tích dữ liệu và lập trình; CrewAI phù hợp cho content creation và business workflows.

### AutoGen có chạy với local LLMs không?

**Có**, AutoGen hỗ trợ bất kỳ LLM nào tương thích OpenAI API — bao gồm Ollama, vLLM, LM Studio, và TGI (Text Generation Inference). Chất lượng kết quả phụ thuộc vào model: models 7B-13B parameters đủ tốt cho tasks đơn giản; tasks phức tạp vẫn cần GPT-4 hoặc Claude 3.5.

### AutoGen xử lý bảo mật thực thi code như thế nào?

AutoGen cung cấp ba cấp độ bảo mật cho code execution:

1. **No execution**: tắt hoàn toàn — agents chỉ tạo code nhưng không chạy
2. **Docker sandbox**: chạy code trong container Docker cô lập — khuyến nghị cho production
3. **Local execution**: chạy trực tiếp trên máy — chỉ dùng trong development

Luôn bật `use_docker=True` trong production và giới hạn network access của container để ngăn chặn các cuộc gọi API không mong muốn.

## Kết Luận Và Tài Nguyên Khởi Động

AutoGen đại diện cho một bước tiến quan trọng trong cách chúng ta xây dựng ứng dụng AI — thay vì dựa vào một single LLM call, chúng ta có thể tạo ra các hệ sinh thái agents hợp tác, mỗi agent mang một vai trò chuyên biệt. Khả năng thực thi code trực tiếp của AutoGen đặc biệt mạnh mẽ — nó biến LLM từ một "ngườivit lách" thành một "kỹ sư phần mềm" có khả năng viết, chạy và debug code.

Để bắt đầu với AutoGen:

1. **Đọc tài liệu chính thức**: [microsoft.github.io/autogen](https://microsoft.github.io/autogen)
2. **Chạy examples trên GitHub**: [github.com/microsoft/autogen](https://github.com/microsoft/autogen) có hơn 50 ví dụ cho mọi use case
3. **Thử nghiệm với GPT-4o-mini**: bắt đầu với model rẻ tiền để làm quen trước khi chuyển sang GPT-4
4. **Thiết lập Ollama**: chạy local LLM để tiết kiệm chi phí trong development
5. **Tham gia Discord community**: hơn 15.000 thành viên sẵn sàng hỗ trợ

Multi-agent systems đang trở thành tiêu chuẩn cho các ứng dụng AI phức tạp — và AutoGen là một trong những công cụ tốt nhất để bắt đầu hành trình này trong năm 2025.

---

**Tài liệu tham khảo:**

- [AutoGen Official Documentation](https://microsoft.github.io/autogen)
- [AutoGen GitHub Repository](https://github.com/microsoft/autogen)
- [CrewAI GitHub Repository](https://github.com/crewAIInc/crewAI)
- [OpenAI API Documentation](https://openai.com)
- [Ollama Official Website](https://ollama.com)

---

## Hạ Tầng Đề Xuất

Để chạy các công cụ trên 24/7 ổn định, lựa chọn hạ tầng rất quan trọng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 tín dụng miễn phí 60 ngày, 14+ region toàn cầu.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp. dibi8.com cũng host ở đây.
- **[Hostinger](https://www.hostinger.com/vn?REFERRALCODE=22RPIAOJIYJN)** — VPS giá tốt cho thị trường Việt Nam.

*Đây là affiliate link, không tăng chi phí của bạn nhưng giúp dibi8.com duy trì hoạt động.*

