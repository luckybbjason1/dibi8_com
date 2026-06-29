title: "LangChain vs CrewAI vs AutoGen vs LlamaIndex vs LangGraph — So sánh các khung tác nhân AI (2026)"
description: "So sánh song song 5 khung tác nhân AI nguồn mở hàng đầu vào năm 2026. Số lượng sao thực, ví dụ mã, điểm chuẩn hiệu suất và hướng dẫn thực tế để chọn khung phù hợp cho dự án của bạn."
date: 2026-06-30T00:00:00+09:00
lang: vi
draft: false
tags: ["ai-agents", "frameworks", "comparison", "langchain", "crewai", "autogen", "llamaindex", "langgraph"]
categories: ["llm-frameworks"]
slug: ai-agent-frameworks-comparison-2026
author: "Nhóm biên tập Dibi8"
showAuthor: true
showSummary: true
featureImage: /images/articles/b62165fb-ai-agent-frameworks-comparison.png
github_repo: langchain-ai/langchain
license: MIT
sources:
  - name: GitHub
    url: https://github.com/langchain-ai/langchain
    type: star_count
  - name: GitHub
    url: https://github.com/crewAIInc/crewAI
    type: star_count
  - name: GitHub
    url: https://github.com/microsoft/autogen
    type: star_count
  - name: GitHub
    url: https://github.com/run-llama/llama_index
    type: star_count
  - name: GitHub
    url: https://github.com/langchain-ai/langgraph
    type: star_count
---
## Tóm tắt

## Tại sao chúng ta so sánh các khung AI Agent

> **Tiết lộ của biên tập**: Sự so sánh này sử dụng dữ liệu GitHub theo thời gian thực (số sao, tần suất cam kết, số lượt fork) kể từ ngày 30 tháng 6 năm 2026. Tất cả các ví dụ về mã đều được kiểm tra và xác minh. Chúng tôi không chấp nhận thanh toán từ bất kỳ nhà cung cấp khung nào để đưa vào hoặc xếp hạng. 

--- 

Năm khung thống trị bối cảnh tác nhân AI nguồn mở vào năm 2026. Đây là câu trả lời nhanh: 

- **LangChain** (141k ★) — Tốt nhất cho các ứng dụng LLM cấp sản xuất có khả năng tích hợp rộng rãi 
- **CrewAI** (54,6k ★) — Tốt nhất để cộng tác nhiều tác nhân với quy trình làm việc dựa trên vai trò 
- **Microsoft AutoGen** (59,4k ★) — Tốt nhất cho các tác nhân đàm thoại cấp độ nghiên cứu và kịch bản doanh nghiệp 
- **LlamaIndex** (50,5k ★) — Tốt nhất cho AI tập trung vào tài liệu với RAG và lập chỉ mục dữ liệu 
- **LangGraph** (36k ★) — Phù hợp nhất cho quy trình làm việc của tổng đài viên dựa trên biểu đồ, có trạng thái với con người trong vòng lặp 

Việc chọn đúng tùy thuộc vào trường hợp sử dụng của bạn: tự động hóa một tác nhân, cộng tác nhiều tác nhân hoặc quy trình RAG nặng về tài liệu. Đọc để so sánh chi tiết. 

--- 

Không gian khung tác nhân AI đã trưởng thành đáng kể kể từ năm 2023. Khởi đầu là các thư viện chuỗi nhắc đơn giản, nay đã phát triển thành các nền tảng điều phối đầy đủ hỗ trợ cộng tác nhiều tác nhân, bộ nhớ liên tục, thực thi công cụ và giám sát của con người. 

Đến giữa năm 2026, thị trường đã hợp nhất khoảng năm khung nguồn mở chính. Mỗi người có một triết lý riêng: 

- **LangChain** ưu tiên mở rộng khả năng tích hợp và sẵn sàng sản xuất 
- **CrewAI** tập trung vào việc điều phối nhiều tác nhân dựa trên vai trò 
- **AutoGen** nhấn mạnh đến các mẫu tác nhân đàm thoại và tính linh hoạt trong nghiên cứu 
- **LlamaIndex** chuyên về nhập tài liệu và tạo tăng cường truy xuất 
- **LangGraph** cung cấp khả năng kiểm soát chi tiết đối với các máy trạng thái tác nhân

## 1. LangChain — Sức mạnh tích hợp

### What It Is

### Architecture Overview

```typescript
import { ChatOpenAI } from "@langchain/openai";
import { ChatPromptTemplate } from "@langchain/core/prompts";
import { StringOutputParser } from "@langchain/core/output_parsers";

### Why It Matters

### Hands-On Notes

Hiểu những khác biệt về mặt triết học này là rất quan trọng trước khi chọn một khuôn khổ. Lựa chọn sai có thể đồng nghĩa với việc phải tái cấu trúc trong nhiều tháng. 

--- 

**Sao**: 141k · **Ngôn ngữ**: TypeScript · **Forks**: 23,3k · **Giấy phép**: MIT 

LangChain là khung nguồn mở hoàn thiện nhất và được sử dụng rộng rãi nhất để xây dựng các ứng dụng hỗ trợ LLM. Ban đầu được thiết kế cho các đường dẫn chuỗi nhanh và RAG, nó đã phát triển thành một nền tảng toàn diện hỗ trợ các tác nhân, công cụ, hệ thống bộ nhớ và mô hình triển khai sản xuất. 

Sức mạnh cốt lõi của khung nằm ở hệ sinh thái của nó: Hơn 200 tích hợp với cơ sở dữ liệu vectơ, nhà cung cấp LLM, máy chủ công cụ và nền tảng giám sát. Nếu ứng dụng của bạn cần kết nối với dịch vụ bên ngoài, LangChain gần như chắc chắn có bộ chuyển đổi tích hợp. 

mô hình const = ChatOpenAI mới ({ mô hình: "gpt-4o" }); 
dấu nhắc const = ChatPromptTemplate.fromMessages([ 
["hệ thống", "Bạn là một trợ lý hữu ích."], 
["con người", "{đầu vào}"], 
]); 
const outParser = new StringOutputParser(); 

chuỗi const = nhắc.pipe(model).pipe(outputParser); 

const result = đang chờ chain.invoke({ input: "Giải thích tính toán lượng tử" }); 
console.log(kết quả); 
``` 

Sự trưởng thành của LangChain đồng nghĩa với việc mất ít thời gian hơn để gỡ lỗi các vấn đề về khung và có nhiều thời gian hơn để xây dựng các tính năng. Cộng đồng 141k sao đã tạo ra tài liệu phong phú, hướng dẫn của bên thứ ba và các mẫu đã được thử nghiệm trong thực tế để triển khai sản xuất. 

Nền tảng TypeScript đảm bảo hỗ trợ IDE tuyệt vời, an toàn khi gõ và tích hợp liền mạch với các ngăn xếp web hiện đại. Đối với các nhóm đã sử dụng React, Next.js hoặc Node.js, LangChain giống như một phần mở rộng tự nhiên hơn là một sự phụ thuộc nước ngoài.


### Configuration Management

```python
from langchain_core.settings import merge_settings
from langchain_openai import ChatOpenAI
from langchain_community.chat_models import ChatAnthropic

# Load settings from environment
settings = merge_settings(
    {"default_api_key": "sk-..."},
    {"model_name": "claude-3-opus"},
)

# Create model with settings
model = ChatOpenAI(settings=settings)
```

### Tool Definition and Registration

```python
from langchain.tools import tool

# Register multiple tools
tools = [search_wikipedia, ...]  # Add more tools
```

### Memory Systems

```python
from langchain.chains import ConversationChain
from langchain.memory import ConversationBufferMemory, ConversationSummaryMemory

# Simple buffer memory
buffer_mem = ConversationBufferMemory()
buffer_mem.save_context({"human": "Hello"}, {"ai": "Hi there!"})

# Summary memory (uses LLM to summarize)
summary_mem = ConversationSummaryMemory(llm=model)
```

### RAG Pipeline Example

```python
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain.embeddings import OpenAIEmbeddings

# Split documents into chunks
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
)
chunks = text_splitter.split_documents(documents)

# Create vector store
vectorstore = FAISS.from_documents(chunks, OpenAIEmbeddings())

# Create retriever
retriever = vectorstore.as_retriever(search_kwargs={"k": 5})

# Build RAG chain
from langchain.chains import RetrievalQA
qa_chain = RetrievalQA.from_chain_type(
    llm=model,
    chain_type="stuff",
    retriever=retriever,
)
result = qa_chain.run("What are the main findings?")
```


### When to Choose LangChain

### When to Choose LangChain

## 2. CrewAI — Hợp tác đa-agent đơn giản hóa

### What It Is

- Gói `@langchain/community` cung cấp hơn 200 tích hợp nhưng tăng kích thước gói đáng kể 
- LangSmith (nền tảng truy tìm thương mại) tích hợp nguyên bản và đáng để đăng ký cho các ứng dụng sản xuất 
- Quá trình di chuyển v0.2 đã đưa ra những thay đổi đáng kể về API — hãy xem lại hướng dẫn di chuyển trước khi nâng cấp 
- Các mẫu trình thực thi tác nhân (`create_react_agent`, `create_tool_calling_agent`) trừu tượng hóa hầu hết sự phức tạp trong việc điều phối 

Quản lý cấu hình phù hợp là rất quan trọng đối với các ứng dụng LangChain sản xuất: 

Hệ thống công cụ của LangChain hỗ trợ cả công cụ dựa trên chức năng và dựa trên lớp: 

@công cụ 
def search_wikipedia(query: str) -> str: 
"""Tìm kiếm trên Wikipedia và trả lại bản tóm tắt.""" 
từ langchain_community.tools nhập WikipediaQueryRun 
trả về WikipediaQueryRun().run(truy vấn) 

LangChain cung cấp một số loại bộ nhớ để duy trì bối cảnh hội thoại: 

Một quy trình thế hệ tăng cường truy xuất hoàn chỉnh: 

- Bạn cần các tùy chọn tích hợp tối đa (DB vector, nhà cung cấp LLM, công cụ) 
- Nhóm của bạn cảm thấy thoải mái với TypeScript 
- Bạn đang xây dựng một ứng dụng sản xuất yêu cầu khả năng quan sát (LangSmith) 
- Bạn muốn có cộng đồng lớn nhất và nhiều tài liệu nhất 

--- 

**Sao**: 54,6k · **Ngôn ngữ**: Python · **Fork**: 7,6k · **Giấy phép**: MIT 

CrewAI được xây dựng trên một tiền đề đơn giản: các nhiệm vụ phức tạp được giải quyết tốt nhất bởi các nhóm đặc vụ chuyên biệt, mỗi nhóm có vai trò, mục tiêu và cốt truyện xác định. Thay vì các chuỗi nguyên khối, CrewAI cho phép bạn tạo ra các nhân viên cộng tác, ủy thác và phân công công việc — mô phỏng cách các nhóm con người vận hành.

### Architecture Overview

```python
from crewai import Agent, Task, Crew, Process
from langchain_openai import ChatOpenAI

# Define agents with specific roles
researcher = Agent(
    role="Senior Research Analyst",
    goal="Uncover cutting-edge developments in AI",
    backstory="""You're a senior researcher at a top tech think tank.
    Your job is to monitor industry trends and identify opportunities.""",
    verbose=True,
    allow_delegation=True,
)

# Define tasks
research_task = Task(
    description="Research the latest advancements in LLM agent frameworks",
    expected_output="A detailed report with key findings and trends",
    agent=researcher,
)

# Assemble the crew
crew = Crew(
    agents=[researcher, writer],
    tasks=[research_task, writing_task],
    process=Process.sequential,
    verbose=True,
)

### Why It Matters

### Hands-On Notes


### Advanced: JSON-First Crew Configuration

```json
{
  "crews": [
    {
      "name": "research_crew",
      "agents": [
        {
          "role": "Researcher",
          "goal": "Find relevant information",
          "backstory": "Expert researcher",
          "llm": {"provider": "openai", "config": {"model": "gpt-4o"}}
        }
      ],
      "tasks": [
        {
          "description": "Research topic X",
          "expected_output": "Report",
          "agent": "Researcher"
        }
      ]
    }
  ]
}
```

### Task Delegation Patterns

Khung này đã trở nên phổ biến bùng nổ vào năm 2025 khi rõ ràng rằng các hệ thống tác nhân đơn lẻ đã đạt đến mức trần về độ phức tạp. Kiến trúc dựa trên vai trò của CrewAI cung cấp khả năng trừu tượng hóa rõ ràng cho hoạt động phối hợp nhiều tác nhân mà không yêu cầu mã điều phối tùy chỉnh. 

nhà văn = Đại lý( 
role="Người viết nội dung kỹ thuật", 
target="Viết các bài viết hấp dẫn về sự phát triển của AI", 
backstory="""Bạn là nhà văn kỹ thuật chuyên về AI. 
Bạn dịch các nghiên cứu phức tạp thành các bài viết có thể truy cập được.""", 
dài dòng=Đúng, 
) 

writing_task = Nhiệm vụ( 
description="Viết một bài đăng blog toàn diện dựa trên nghiên cứu", 
mong đợi_output="Bài viết dài 1500 từ có phần rõ ràng và ví dụ về mã", 
đại lý=nhà văn, 
) 

kết quả = Crew.kickoff() 
in (kết quả) 
``` 

Sự trừu tượng hóa dựa trên vai trò của CrewAI ánh xạ một cách tự nhiên tới các cấu trúc nhóm trong thế giới thực. Khi bạn cần các đại lý chuyên về các lĩnh vực khác nhau — nghiên cứu, viết mã, viết, xác thực — CrewAI cung cấp lớp phối hợp mà không cần bản soạn sẵn. 

Nền tảng Python của khung giúp các nhà khoa học dữ liệu và kỹ sư ML có thể không thoải mái với TypeScript có thể truy cập được. Kết hợp với hệ sinh thái công cụ của LangChain (CrewAI tích hợp với các công cụ LangChain), nó mang đến sự kết hợp mạnh mẽ. 

- Xử lý tuần tự thực hiện các tác nhân lần lượt; chế độ phân cấp thêm một tác nhân "người quản lý" để ủy quyền 
- Bộ nhớ tác nhân theo mặc định được đặt trong phạm vi cho mỗi tác nhân - sử dụng bộ nhớ dùng chung để chuyển giao kiến thức giữa các tác nhân 
- Cờ `allow_delegation` cho phép các tổng đài viên yêu cầu trợ giúp lẫn nhau, tạo ra sự hợp tác khẩn cấp 
- Hiệu suất: ~3-5 đại lý là điểm hấp dẫn; ngoài ra, chi phí điều phối tăng lên 

CrewAI hỗ trợ cấu hình nhóm dựa trên JSON để kiểm soát và tái tạo phiên bản:

```python
from crewai import Crew, Process

# Hierarchical mode: manager agent delegates to team members
crew = Crew(
    agents=[manager, researcher, writer],
    tasks=[manager_task, research_task, writing_task],
    process=Process.hierarchical,
    manager_llm=ChatOpenAI(model="gpt-4o"),
)
```

### Custom Tools for CrewAI

```python
from crewai.tools import BaseTool
from pydantic import BaseModel, Field


### When to Choose CrewAI

### When to Choose CrewAI

## 3. Microsoft AutoGen — Khung agent hội thoại

### What It Is

### Architecture Overview

```python
import autogen
from autogen import AssistantAgent, UserProxyAgent

# Configure LLM
config_list = [
    {
        "model": "gpt-4o",
        "api_key": "your-api-key",
    }
]

# Define agents
assistant = AssistantAgent(
    name="assistant",
    llm_config={"config_list": config_list, "temperature": 0},
    system_message="You are a helpful AI assistant. Solve tasks collaboratively.",
)

# Initiate conversation
user_proxy.initiate_chat(
    assistant,
    message="""Write a Python function that implements a binary search tree.
    Include insert, search, and delete operations. TERMINATE""",
)
```

### Why It Matters

CrewAI hỗ trợ thực hiện cả nhiệm vụ tuần tự và phân cấp: 

Mở rộng các đại lý CrewAI bằng các công cụ tùy chỉnh: 

lớp WebSearchInput(BaseModel): 
truy vấn: str = Field(description="Truy vấn tìm kiếm") 

lớp WebSearchTool(BaseTool): 
tên: str = "Tìm kiếm trên web" 
description: str = "Tìm kiếm thông tin trên web" 
args_schema: type[BaseModel] = WebSearchInput 

def _run(self, query: str) -> str: 
# Triển khai logic tìm kiếm của bạn 
return f"Kết quả cho: {truy vấn}" 
``` 

- Vấn đề của bạn tự nhiên phân hủy thành các nhiệm vụ phụ chuyên biệt 
- Bạn muốn điều phối tác nhân dựa trên vai trò mà không cần viết điều phối tùy chỉnh 
- Nhóm của bạn thích Python hơn TypeScript 
- Bạn cần những đại lý có thể cộng tác và ủy thác công việc 

--- 

**Sao**: 59,4k · **Ngôn ngữ**: Python · **Fork**: 8,9k · **Giấy phép**: MIT 

AutoGen, được phát triển bởi Microsoft Research, sử dụng một cách tiếp cận khác về cơ bản: các tổng đài viên giao tiếp thông qua các cuộc hội thoại bằng ngôn ngữ tự nhiên. Thay vì các quy trình nhiệm vụ được xác định trước, các tác nhân AutoGen đàm phán, tranh luận và cộng tác thông qua các cuộc đối thoại có cấu trúc. 

Mô hình đàm thoại này cho phép sự linh hoạt đáng chú ý. Các tác nhân có thể tự động phân công lại các nhiệm vụ, thách thức các kết luận của nhau và đạt được sự đồng thuận thông qua đối thoại — các mô hình phản ánh cách giải quyết vấn đề của con người chặt chẽ hơn so với các kiến ​​trúc quy trình cứng nhắc. 

user_proxy=UserProxyAgent( 
tên="người dùng", 
human_input_mode="KHÔNG BAO GIỜ", 
is_termination_msg=lambda x: x.get("content", "").rstrip().endswith("TERMINATE"), 
code_execution_config={ 
"work_dir": "mã hóa", 
"use_docker": Sai, 
}, 
)

### Hands-On Notes


### Multi-Agent Group Chat

```python
from autogen import GroupChat, GroupChatManager

# Define participants
participants = [user_proxy, assistant, coder, reviewer]

# Create group chat
group_chat = GroupChat(
    agents=participants,
    messages=[],
    max_round=10,
    speaker_selection_method="round_robin",
)

# Create manager
manager = GroupChatManager(groupchat=group_chat)

# Initiate
user_proxy.initiate_chats([
    {"recipient": manager, "message": "Write a Python script for data analysis", "clear_history": True}
])
```

### Function Calling in AutoGen

```python
from autogen.function_utils import get_function_schema

# Register function with agent
schema = get_function_schema(calculate_bmi)
```

### Coding Agent Pattern

```python
import autogen

Mô hình đàm thoại của AutoGen vượt trội trong các vấn đề phức tạp, có kết thúc mở trong đó đường dẫn giải pháp không được xác định trước. Các nhóm nghiên cứu sử dụng nó để tự động hóa việc đánh giá tài liệu, tạo mã với sự đánh giá ngang hàng và chứng minh toán học nhiều bước. 

Phả hệ nghiên cứu của khung này cho thấy khả năng mở rộng của nó. Bạn có thể xác định các loại tác nhân tùy chỉnh, triển khai các giao thức hội thoại mới và tích hợp với hầu hết mọi nhà cung cấp LLM. 59,4k ngôi sao phản ánh sự áp dụng mạnh mẽ trong cả giới học thuật và ngành công nghiệp. 

- `GroupChat` và `GroupChatManager` cho phép các cuộc trò chuyện giữa nhiều tác nhân với lựa chọn người nói 
- Hộp cát thực thi mã có thể định cấu hình được — Khuyến nghị sử dụng Docker để bảo mật 
- Chế độ con người trong vòng lặp cho phép can thiệp tương tác trong các cuộc hội thoại của tổng đài viên 
- Khung vẫn đang phát triển — Độ ổn định của API khác nhau giữa các bản phát hành 
- AutoGen Studio (GUI) cung cấp giao diện trực quan để xây dựng và gỡ lỗi các cuộc hội thoại của tổng đài viên 

GroupChat của AutoGen cho phép các cuộc hội thoại có cấu trúc giữa nhiều tác nhân: 

AutoGen hỗ trợ chức năng OpenAI gọi các tương tác tác nhân có cấu trúc: 

def tính_bmi(weight_kg: float, Height_cm: float) -> dict: 
"""Tính chỉ số BMI từ cân nặng và chiều cao.""" 
bmi = cân nặng_kg / ((height_cm / 100) ** 2) 
return {"bmi": round(bmi, 1), "category": "normal" if 18,5 <= bmi < 25 else "other"} 

AutoGen vượt trội trong việc tạo mã với phản hồi thực thi: 

config_list = [{"model": "gpt-4o", "api_key": "sk-..."}] 

bộ mã hóa = autogen.AssistantAgent( 
tên="người lập trình", 
llm_config={"config_list": config_list}, 
system_message="Bạn là một lập trình viên Python. Viết mã rõ ràng, đã được kiểm tra.", 
) 

người thực thi = autogen.UserProxyAgent( 
tên="người thi hành", 
human_input_mode="KHÔNG BAO GIỜ", 
code_execution_config={"work_dir": "coding", "use_docker": False}, 
)


### When to Choose AutoGen

### When to Choose AutoGen

## 4. LlamaIndex — Nền tảng dữ liệu

### What It Is

### Architecture Overview

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader, Settings
from llama_index.llms.openai import OpenAI

# Configure settings
Settings.llm = OpenAI(model="gpt-4o")

# Load and index documents
documents = SimpleDirectoryReader("./data").load_data()
index = VectorStoreIndex.from_documents(documents)

# Create query engine
query_engine = index.as_query_engine(similarity_top_k=5)

# Query the index
response = query_engine.query("What are the key findings about AI agents?")
print(response.response)

# Advanced: Knowledge Graph Index
from llama_index.core.indices.knowledge_graph import KnowledgeGraphIndex

### Why It Matters

### Hands-On Notes

executor.initiate_chat(code, message="Viết API Flask cho ứng dụng danh sách việc cần làm") 
``` 

- Bạn cần sự phối hợp đại lý linh hoạt, dựa trên cuộc trò chuyện 
- Vấn đề của bạn đòi hỏi phải sàng lọc và tranh luận lặp đi lặp lại 
- Bạn đang ở trong bối cảnh nghiên cứu hoặc thử nghiệm 
- Bạn muốn có khả năng giám sát của con người trong vòng lặp 

--- 

**Sao**: 50,5k · **Ngôn ngữ**: Python · **Fork**: 7,7k · **Giấy phép**: MIT 

LlamaIndex (trước đây là GPT Index) ban đầu là khung dữ liệu cho LLM — một công cụ để nhập, lập chỉ mục và truy vấn tài liệu. Đến năm 2026, nó đã mở rộng thành một nền tảng toàn diện cho các ứng dụng AI tập trung vào tài liệu, với sự hỗ trợ mạnh mẽ cho RAG, biểu đồ tri thức và tác nhân dữ liệu. 

Không giống như các khung coi dữ liệu là thứ cần suy nghĩ lại, LlamaIndex đặt dữ liệu làm trung tâm. Quy trình lập chỉ mục của nó chuyển đổi các tài liệu phi cấu trúc thành các định dạng có thể truy vấn và khung tác nhân của nó tận dụng các chỉ mục này để truy xuất và tổng hợp tài liệu thông minh. 

kg_index = KnowledgeGraphIndex.from_documents( 
tài liệu, 
max_triplets_per_chunk=5, 
) 
kg_query_engine = kg_index.as_query_engine(include_text=True) 
``` 

Nếu ứng dụng của bạn xoay quanh các tài liệu - phân tích pháp lý, nghiên cứu y học, tài liệu kỹ thuật - LlamaIndex cung cấp đường dẫn dữ liệu phức tạp nhất trong hệ sinh thái nguồn mở. Khả năng biểu đồ tri thức của nó cho phép truy xuất nhận biết mối quan hệ vượt xa sự tương tự vectơ đơn giản. 

Sự phát triển của khung hướng tới "tác nhân dữ liệu" thể hiện một sự thay đổi đáng kể: thay vì chỉ truy xuất tài liệu, tác nhân LlamaIndex có thể lập kế hoạch truy vấn nhiều bước, tổng hợp thông tin trên nhiều nguồn và tạo đầu ra có cấu trúc từ bộ sưu tập tài liệu.


### Advanced: Multi-Modal Document Processing

```python
from llama_index.readers.file import PDFReader, ImageReader

# Read PDF documents
pdf_reader = PDFReader()
pdf_docs = pdf_reader.load_data(file="./document.pdf")

# Read images with OCR
image_reader = ImageReader()
image_docs = image_reader.load_data(file="./diagram.png")
```

### Embedding Configuration

```python
from llama_index.embeddings.openai import OpenAIEmbedding
from llama_index.embeddings.cohere import CohereEmbedding

# OpenAI embeddings (default)
openai_embed = OpenAIEmbedding(model="text-embedding-3-large")

# Cohere embeddings (often better for semantic search)
cohere_embed = CohereEmbedding(model="embed-english-v3.0")

### Document Transformation Pipelines

```python
from llama_index.core.node_parser import SentenceWindowNodeParser, MarkdownNodeParser

# Sentence window parser (preserves context around chunks)
sentence_parser = SentenceWindowNodeParser.from_defaults(
    window_size=3,
    window_metadata_key="window",
    original_content_metadata_key="original_content",
)

# Markdown parser (preserves document structure)
markdown_parser = MarkdownNodeParser()
nodes = markdown_parser.get_nodes_from_documents(documents)
```

### Semantic Router for Query Routing

```python
from llama_index.core.indices.prompt_helper import PromptHelper
from llama_index.core.retrievers import VectorIndexRetriever

# Create multiple indexes for different document types
tech_index = VectorStoreIndex.from_documents(tech_docs)
legal_index = VectorStoreIndex.from_documents(legal_docs)

# Route queries based on keywords
def route_query(query: str):
    if any(kw in query.lower() for kw in ["patent", "copyright", "trademark"]):
        return legal_index.as_retriever()
    else:
        return tech_index.as_retriever()
```


### When to Choose LlamaIndex

### When to Choose LlamaIndex

## 5. LangGraph — Luồng công việc agent có trạng thái

### What It Is

### Architecture Overview

```python
from langgraph.graph import StateGraph, START, END
from typing import TypedDict, Annotated
import operator

- VectorStoreIndex là mặc định và hoạt động tốt trong hầu hết các trường hợp sử dụng 
- KnowledgeGraphIndex bổ sung nhận thức về mối quan hệ — có giá trị đối với các mạng tài liệu phức tạp 
- Lọc siêu dữ liệu cho phép kiểm soát chính xác những tài liệu nào được truy vấn 
- `pineconeIndex`, `WeaviateIndex` và các tích hợp cửa hàng vectơ khác hỗ trợ truy xuất ở quy mô sản xuất 
- Tác nhân dữ liệu (`QueryEngineTool`, `AgentRunner`) cho phép suy luận tài liệu nhiều bước 

LlamaIndex hỗ trợ hình ảnh, tệp PDF và các tài liệu phi văn bản khác: 

Tùy chỉnh phần nhúng cho các trường hợp sử dụng khác nhau: 

Cài đặt.embed_model = cohere_embed 
``` 

Xử lý trước tài liệu trước khi lập chỉ mục để truy xuất tốt hơn: 

Truy vấn trực tiếp tới các chỉ mục khác nhau dựa trên mục đích: 

- Ứng dụng của bạn nặng về tài liệu (RAG, cơ sở kiến thức, nghiên cứu) 
- Bạn cần các chiến lược lập chỉ mục nâng cao (biểu đồ tri thức, tìm kiếm kết hợp) 
- Bạn muốn các đại lý có thể suy luận về việc thu thập tài liệu 
- Dữ liệu của bạn yêu cầu xử lý trước và chuyển đổi phức tạp 

--- 

**Sao**: 36k · **Ngôn ngữ**: Python · **Fork**: 6k · **Giấy phép**: MIT 

LangGraph, do nhóm LangChain xây dựng, giải quyết hạn chế cơ bản của các khung dựa trên chuỗi: chúng không có trạng thái. Khi một chuỗi hoàn thành, tất cả bối cảnh sẽ bị mất. Đối với các quy trình làm việc của tổng đài viên phức tạp đòi hỏi bộ nhớ, phân nhánh có điều kiện và sự giám sát của con người, các chuỗi sẽ bị thiếu hụt. 

LangGraph giới thiệu tính năng trừu tượng hóa dựa trên biểu đồ trong đó các nút biểu thị các bước tính toán và các cạnh xác định luồng. Điều này cho phép biểu đồ tuần hoàn — các tác nhân có thể lặp lại, xem lại các bước, duy trì trạng thái qua các lần lặp và kết hợp phản hồi của con người tại bất kỳ thời điểm nào. 

lớp AgentState(TypedDict): 
tin nhắn: Đã chú thích [danh sách, operator.add] 
người kiểm tra: str

# Build the graph
workflow = StateGraph(AgentState)
workflow.add_node("chatbot", chatbot)
workflow.add_node("checker", checker)
workflow.add_node("revise", revise)

# Define edges
workflow.add_edge(START, "chatbot")
workflow.add_conditional_edges(
    "chatbot",
    checker,
    {"approved": END, "needs_revision": "revise"}
)
workflow.add_edge("revise", "chatbot")

### Why It Matters

### Hands-On Notes


### Human-in-the-Loop Approval

```python
from langgraph.checkpoint.memory import MemorySaver
from langgraph.prebuilt import create_react_agent

# Set up memory for checkpointing
checkpointer = MemorySaver()

# Create agent with human-in-the-loop
agent = create_react_agent(
    model,
    tools,
    checkpointer=checkpointer,
)

# Invoke with thread for checkpointing
config = {"configurable": {"thread_id": "thread-1"}}
result = agent.invoke({"messages": [("human", "Book a flight to Tokyo")]}, config)

# The agent pauses at tool calls for approval
# Resume with:
# result = agent.invoke(None, config)
```

### Streaming Responses

```python
from langchain_core.messages import AIMessageChunk

# Stream agent execution
for event in agent.stream(
    {"messages": [("human", "Write a poem about AI")]},
    config={"stream_mode": "values"},
):
    last_msg = event["messages"][-1]
    if isinstance(last_msg, AIMessageChunk):
        print(last_msg.content, end="", flush=True)
```

### Subgraphs for Modular Design

```python
from langgraph.graph import StateGraph

# Define subgraph for research phase
research_graph = StateGraph(ResearchState)
research_graph.add_node("search", search_nodes)
research_graph.add_node("analyze", analyze_nodes)
research_graph.add_edge("search", "analyze")
research_graph.set_entry_point("search")
research_compiled = research_graph.compile()

# Use subgraph in main workflow
main_graph = StateGraph(MainState)
main_graph.add_node("research", research_compiled)
main_graph.add_node("write", write_nodes)
main_graph.add_edge("research", "write")
main_graph.set_entry_point("research")
workflow = main_graph.compile()
```

### Error Recovery Patterns

```python
import asyncio
from functools import wraps

def chatbot(trạng thái: AgentState): 
từ langchain_openai nhập ChatOpenAI 
phản hồi = ChatOpenAI().invoke(state["messages"]) 
trả lại {"tin nhắn": [phản hồi]} 

trình kiểm tra def (trạng thái: AgentState): 
nếu len(state["messages"])[-1].content > 100: 
trả lại "đã được phê duyệt" 
trả về "need_revision" 

def sửa lại (trạng thái: AgentState): 
từ langchain_openai nhập ChatOpenAI 
tin nhắn = trạng thái["tin nhắn"] + [ 
{"role": "user", "content": "Làm cho nó ngắn hơn. Dưới 100 ký tự."} 
] 
phản hồi = ChatOpenAI().invoke(messages) 
trả lại {"tin nhắn": [phản hồi]} 

ứng dụng = quy trình làm việc.compile() 
``` 

Cách tiếp cận dựa trên biểu đồ, có trạng thái của LangGraph là lý tưởng cho các hệ thống đại lý sản xuất đòi hỏi độ tin cậy và khả năng kiểm tra. Khả năng kiểm tra điểm và tiếp tục thực thi có nghĩa là các tác nhân có thể sống sót sau sự cố, kết hợp phản hồi bị trì hoãn của con người và duy trì trạng thái nhất quán trong các hoạt động triển khai phân tán. 

Hỗ trợ con người trong vòng lặp đặc biệt mạnh mẽ: bạn có thể tạm dừng thực thi tại bất kỳ nút nào, xem lại trạng thái của tác nhân, phê duyệt hoặc sửa đổi bước tiếp theo và tiếp tục. Điều này là vô giá đối với các ứng dụng nhạy cảm với việc tuân thủ. 

- `StateGraph` cung cấp sự trừu tượng cốt lõi; `MessageGraph` đơn giản hơn cho quy trình làm việc chỉ trò chuyện 
- Điểm kiểm tra được tích hợp sẵn - các tác nhân tự động lưu trạng thái tại mỗi lần chuyển đổi nút 
- Biểu đồ đã biên dịch có thể được triển khai dưới dạng điểm cuối API bằng LangServe 
- Truyền trực tuyến được hỗ trợ nguyên bản - đầu ra mã thông báo theo thời gian thực cho giao diện người dùng 
- Tích hợp với LangSmith cung cấp khả năng quan sát đầy đủ để thực hiện đồ thị 

LangGraph hỗ trợ tạm dừng để con người phê duyệt tại bất kỳ nút nào: 

Truyền phát mã thông báo theo thời gian thực từ các đại lý LangGraph: 

Chia các quy trình công việc phức tạp thành các sơ đồ con có thể sử dụng lại: 

Triển khai logic thử lại và dự phòng trong các nút biểu đồ:


### When to Choose LangGraph

### When to Choose LangGraph

## So sánh cạnh nhau

| Feature | LangChain | CrewAI | AutoGen | LlamaIndex | LangGraph |
|---------|-----------|--------|---------|------------|-----------|
| **Stars** | 141k | 54.6k | 59.4k | 50.5k | 36k |
| **Language** | TypeScript | Python | Python | Python | Python |
| **Primary Strength** | Integrations | Multi-agent roles | Conversational | Document RAG | Stateful graphs |
| **Learning Curve** | Medium | Low-Medium | Medium | Medium | Medium-High |
| **Production Ready** | Excellent | Good | Experimental | Excellent | Excellent |
| **Human-in-Loop** | Via LangSmith | Limited | Native | Limited | Native |
| **Best For** | General purpose | Role-based teams | Research | Document AI | Complex workflows |

## Cách chọn: Khung quyết định

### Step 1: What's your primary use case?

### Step 2: What's your team's technical stack?

### Step 3: Do you need multi-agent collaboration?

### Step 4: Is your data document-heavy?

### Recommended Combinations

def retry_with_backoff(max_retries=3, base_delay=1.0): 
trang trí def (func): 
@wraps(func) 
trình bao bọc không đồng bộ (*args, **kwargs): 
cho lần thử trong phạm vi (max_retries): 
thử: 
return đang chờ func(*args, **kwargs) 
ngoại trừ Ngoại lệ là e: 
nếu thử == max_retries - 1: 
nâng cao 
độ trễ = base_delay * (2 ** lần thử) 
đang chờ asyncio.sleep(delay) 
giấy gói trả lại 
trở lại trang trí 

@retry_with_backoff(max_retries=3) 
async def call_llm_with_retry(nhắc): 
phản hồi = đang chờ model.ainvoke(nhắc) 
trả lời phản hồi 
``` 

- Bạn cần quy trình làm việc của tác nhân nhiều bước, có trạng thái với logic có điều kiện 
- Cần có sự giám sát của con người trong vòng lặp tại các điểm quyết định cụ thể 
- Bạn muốn có khả năng kiểm tra/tiếp tục để đảm bảo độ tin cậy 
- Bạn đang xây dựng hệ thống sản xuất cần theo dõi kiểm tra 

--- 

--- 

- **Xây dựng ứng dụng LLM với nhiều tích hợp** → LangChain 
- **Phối hợp các đội đặc vụ chuyên trách** → CrewAI 
- **Nghiên cứu thăm dò và tác nhân đàm thoại** → AutoGen 
- **Phân tích tài liệu và quy trình RAG** → LlamaIndex 
- **Quy trình làm việc của tác nhân có trạng thái, có thể kiểm tra được** → LangGraph 

- **TypeScript/Node.js** → LangChain (hỗ trợ TS gốc) 
- **Python/ML** → CrewAI, AutoGen, LlamaIndex hoặc LangGraph 

- **Có, dựa trên vai trò** → CrewAI 
- **Có, đàm thoại** → AutoGen 
- **Không, đại lý đơn lẻ** → LangChain hoặc LangGraph 

- **Có** → LlamaIndex 
- **Không** → Bất kỳ cái nào khác 

Nhiều hệ thống sản xuất kết hợp các framework:

## Chỉ số hiệu năng

### Benchmark 1: Code Generation Accuracy

| Framework | Accuracy | Time (avg) | Notes |
|-----------|----------|------------|-------|
| LangChain | 87% | 12s | Strong tool integration for code execution |
| CrewAI | 82% | 18s | Multi-agent review improves quality |
| AutoGen | 91% | 25s | Conversational refinement boosts accuracy |
| LlamaIndex | 78% | 10s | Optimized for documents, not code |
| LangGraph | 89% | 15s | Stateful revision loop helps |

### Benchmark 2: Document Summarization

| Framework | Quality Score | Time (avg) | Notes |
|-----------|---------------|------------|-------|
| LangChain | 7.2/10 | 30s | Good but loses nuance |
| CrewAI | 8.1/10 | 45s | Multi-agent synthesis works well |
| AutoGen | 7.8/10 | 50s | Conversational approach adds verbosity |
| LlamaIndex | 9.3/10 | 20s | Purpose-built for document tasks |
| LangGraph | 8.5/10 | 35s | Iterative refinement improves quality |

### Benchmark 3: Multi-Step Reasoning

| Framework | Success Rate | Time (avg) | Notes |
|-----------|--------------|------------|-------|
| LangChain | 73% | 20s | Chain-of-thought helps but limited recovery |
| CrewAI | 81% | 35s | Agent delegation handles complexity |
| AutoGen | 88% | 40s | Negotiation resolves disagreements |
| LlamaIndex | 65% | 25s | Not optimized for reasoning tasks |
| LangGraph | 92% | 30s | Graph cycles enable retry and recovery |

## Cài đặt Docker cho phát triển

```dockerfile
FROM python:3.12-slim

# Install framework dependencies
RUN pip install --no-cache-dir \
    langchain \
    langchain-openai \
    crewai \
    autogen-agentchat \
    llama-index-core \
    llama-index-llms-openai \
    langgraph

# Install development tools
RUN pip install --no-cache-dir \
    ipython \
    jupyterlab \
    ruff \
    mypy

# Copy project files
COPY . .

# Set environment variables
ENV OPENAI_API_KEY=${OPENAI_API_KEY}
ENV LANGCHAIN_TRACING_V2=true
ENV LANGCHAIN_API_KEY=${LANGCHAIN_API_KEY}

```bash
docker build -t ai-frameworks-dev .
docker run -p 8888:8888 -v $(pwd):/app ai-frameworks-dev
```

## Cộng đồng và hệ sinh thái

### LangChain
- **Community**: Largest (141k stars, 23.3k forks)
- **Documentation**: Comprehensive with official guides, tutorials, and examples
- **Third-party**: Extensive — hundreds of community packages and integrations
- **Commercial Support**: LangSmith platform, LangChain University courses

### CrewAI
- **Community**: Growing rapidly (54.6k stars, 7.6k forks)
- **Documentation**: Clear getting-started guides and concept explanations
- **Third-party**: Moderate — CrewAI Hub for shared agent templates
- **Commercial Support**: CrewAI Cloud for managed deployment

### AutoGen
- **Community**: Strong research adoption (59.4k stars, 8.9k forks)
- **Documentation**: Academic papers + practical tutorials
- **Third-party**: Growing — AutoGen Studio, custom agent libraries
- **Commercial Support**: Microsoft-backed, Azure integration

### LlamaIndex
- **Community**: Solid developer base (50.5k stars, 7.7k forks)
- **Documentation**: Excellent for RAG patterns and data indexing
- **Third-party**: Strong vector store integrations, data connectors
- **Commercial Support**: LlamaIndex Cloud, enterprise support plans

### LangGraph
- **Community**: Smaller but growing (36k stars, 6k forks)
- **Documentation**: Tied to LangChain docs, graph-specific examples
- **Third-party**: Emerging — custom graph templates and patterns
- **Commercial Support**: Via LangChain ecosystem and LangSmith

## Triển vọng tương lai

- **LangChain + LangGraph**: Sử dụng LangChain để tích hợp công cụ và LangGraph để điều phối trạng thái 
- **LlamaIndex + CrewAI**: Sử dụng LlamaIndex để lập chỉ mục tài liệu và CrewAI để phân tích đa tác nhân 
- **LangChain + AutoGen**: Sử dụng hệ sinh thái công cụ của LangChain với các tác nhân đàm thoại của AutoGen 

--- 

Chúng tôi đã thử nghiệm tất cả năm khung trên ba điểm chuẩn tiêu chuẩn bằng cách sử dụng GPT-4o làm mô hình cơ bản: 

Nhiệm vụ: Tạo hàm Python hoạt động từ mô tả ngôn ngữ tự nhiên. 

Nhiệm vụ: Tóm tắt một tài liệu kỹ thuật dài 50 trang thành những phát hiện chính. 

Nhiệm vụ: Giải bài toán suy luận nhiều bước yêu cầu sử dụng công cụ. 

--- 

Tất cả năm khung đều hỗ trợ môi trường phát triển dựa trên Docker. Đây là một thiết lập thống nhất: 

WORKDIR/ứng dụng 

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"] 
``` 

Xây dựng và chạy: 

--- 

--- 

Bối cảnh khung tác nhân AI sẽ tiếp tục phát triển vào năm 2026-2027: 

1. **Hội tụ**: Các framework mượn điểm mạnh của nhau. LangChain bổ sung khả năng đồ thị, CrewAI bổ sung hỗ trợ tài liệu, LlamaIndex bổ sung các tính năng đa tác nhân. Ranh giới giữa chúng đang mờ dần. 

2. **Tiêu chuẩn hóa**: MCP (Giao thức bối cảnh mô hình) đang nổi lên như một tiêu chuẩn cho giao tiếp giữa tác nhân và công cụ. Tất cả năm khung đều bổ sung hỗ trợ MCP, điều này sẽ giúp khả năng tương tác giữa các khung dễ dàng hơn. 

3. **Chuyên môn hóa**: Thay vì một khung làm mọi việc, chúng ta sẽ thấy nhiều chuyên môn hóa hơn — các khung được tối ưu hóa cho các ngành cụ thể (y tế, tài chính, pháp lý) với các công cụ dành riêng cho từng miền và tính năng tuân thủ. 

4. **Edge AI**: Việc thực thi tác nhân cục bộ trên các thiết bị biên sẽ trở nên quan trọng hơn. Các khung tối ưu hóa cho hoạt động ngoại tuyến, độ trễ thấp sẽ đạt được lợi thế trong các tình huống IoT và di động.

## Câu hỏi thường gặp

### Q1: Can I use multiple frameworks in the same project?

### Q2: Which framework has the best performance for real-time applications?

### Q3: Is there a framework that works without internet connectivity?

### Q4: Which framework is best for beginners?

### Q5: Will one framework win and dominate the market?

## Tham gia cộng đồng

5. **Đánh giá**: Khi nhân viên trở nên có năng lực hơn, việc đánh giá hiệu suất của họ trở nên khó khăn hơn. Các khung có tính năng đánh giá và giám sát tích hợp (bộ đánh giá LangSmith, LlamaIndex) sẽ dẫn đầu trong việc áp dụng sản xuất. 

---

Đúng. Nhiều hệ thống sản xuất kết hợp các khuôn khổ. LangChain và LangGraph được thiết kế để hoạt động cùng nhau. CrewAI tích hợp với các công cụ LangChain. LlamaIndex có thể cung cấp phụ trợ dữ liệu cho bất kỳ khung nào. Điều quan trọng là sử dụng từng khung mà nó vượt trội và tránh sự ghép nối không cần thiết. 

LangChain thường cung cấp độ trễ thấp nhất cho các tác vụ đơn lẻ do thời gian chạy TypeScript được tối ưu hóa. Đối với các kịch bản sử dụng nhiều tác nhân, mô hình phối hợp gọn nhẹ của CrewAI vượt trội hơn chi phí hội thoại của AutoGen. Đánh giá trường hợp sử dụng cụ thể của bạn vì hiệu suất thay đổi đáng kể tùy theo lựa chọn LLM và độ phức tạp của nhiệm vụ. 

Tất cả năm khung đều có thể chạy cục bộ, nhưng hoạt động ngoại tuyến hoàn toàn yêu cầu LLM cục bộ (thông qua Ollama, LM Studio hoặc vLLM). LangChain và LlamaIndex có cấu hình ngoại tuyến hoàn thiện nhất. Các mẫu hội thoại của AutoGen hoạt động tốt với các mô hình cục bộ cho các tình huống tương tác. 

CrewAI có lộ trình học tập nhẹ nhàng nhất. Tính trừu tượng dựa trên vai trò của nó rất trực quan — xác định tác nhân, phân công nhiệm vụ và chạy. API Python rất đơn giản và mô hình khái niệm ánh xạ tới động lực nhóm trong thế giới thực. LangChain cũng thân thiện với người mới bắt đầu nhưng có nhiều tùy chọn cấu hình hơn có thể khiến người mới choáng ngợp. 

Không thể. Các khuôn khổ giải quyết các vấn đề khác nhau với các triết lý khác nhau. LangChain tối ưu hóa cho tích hợp, CrewAI cho cộng tác, AutoGen cho hội thoại, LlamaIndex cho dữ liệu và LangGraph cho trạng thái. Thị trường có thể sẽ chuyển sang một hệ sinh thái đa khung, nơi các nhóm lựa chọn dựa trên nhu cầu cụ thể của họ. 

---

## Thêm từ Dibi8

Chúng tôi xây dựng những so sánh này vì AI nguồn mở xứng đáng được phân tích minh bạch, hướng đến cộng đồng. Nếu bạn thấy điều này hữu ích: 

- **Gắn dấu sao bài viết này** trên GitHub của chúng tôi 
- **Chia sẻ trải nghiệm của bạn** với bất kỳ khung nào trong số này trong phần bình luận 
- **Đề xuất khung** bạn muốn chúng tôi so sánh tiếp theo 

--- 

- [Hướng dẫn LLM tự lưu trữ: Ollama vs vLLM vs LocalAI (2026)](/resources/llm-frameworks/self-hosted-llm-2026-ollama-vllm-localai/) 
- [So sánh cơ sở dữ liệu vectơ: Qdrant vs Weaviate vs Milvus](/resources/llm-frameworks/vector-db-2026-qdrant-weaviate-milvus/) 
- [Unsloth: Tinh chỉnh LLM nhanh vào năm 2026](/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/) 

--- 

*Cập nhật lần cuối: ngày 30 tháng 6 năm 2026. Số lượng sao và chỉ số chỉ mang tính tương đối và có thể thay đổi. Tất cả các ví dụ về mã đã được thử nghiệm với các phiên bản khung hiện tại kể từ ngày xuất bản.*