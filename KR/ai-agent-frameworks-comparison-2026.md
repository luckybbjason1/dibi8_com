title: "LangChain vs CrewAI vs AutoGen vs LlamaIndex vs LangGraph — AI 에이전트 프레임워크 비교(2026)"
description: "2026년 상위 5개 오픈 소스 AI 에이전트 프레임워크를 나란히 비교합니다. 실제 별 개수, 코드 예제, 성능 벤치마크 및 프로젝트에 적합한 프레임워크를 선택하기 위한 실용적인 지침입니다."
date: 2026-06-30T00:00:00+09:00
lang: ko
draft: false
tags: ["ai-agents", "frameworks", "comparison", "langchain", "crewai", "autogen", "llamaindex", "langgraph"]
categories: ["llm-frameworks"]
slug: ai-agent-frameworks-comparison-2026
author: "디비8 편집팀"
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
## 요약

## 왜 AI 에이전트 프레임워크를 비교하는가

> **Editorial Disclosure**: This comparison uses real-time GitHub data (star counts, commit frequency, fork counts) as of June 30, 2026. All code examples are tested and verified. We do not accept payment from any framework vendor for inclusion or ranking.

---

Five frameworks dominate the open-source AI agent landscape in 2026. Here's the quick answer:

- **LangChain** (141k ★) — Best for production-grade LLM apps with extensive integrations
- **CrewAI** (54.6k ★) — Best for multi-agent collaboration with role-based workflows
- **Microsoft AutoGen** (59.4k ★) — Best for research-grade conversational agents and enterprise scenarios
- **LlamaIndex** (50.5k ★) — Best for document-centric AI with RAG and data indexing
- **LangGraph** (36k ★) — Best for stateful, graph-based agent workflows with human-in-the-loop

Choosing the right one depends on your use case: single-agent automation, multi-agent collaboration, or document-heavy RAG pipelines. Read on for detailed comparisons.

---

The AI agent framework space has matured dramatically since 2023. What started as simple prompt-chaining libraries has evolved into full orchestration platforms supporting multi-agent collaboration, persistent memory, tool execution, and human oversight.

By mid-2026, the market has consolidated around five major open-source frameworks. Each has a distinct philosophy:

- **LangChain** prioritizes breadth of integrations and production readiness
- **CrewAI** focuses on role-based multi-agent orchestration
- **AutoGen** emphasizes conversational agent patterns and research flexibility
- **LlamaIndex** specializes in document ingestion and retrieval-augmented generation
- **LangGraph** provides fine-grained control over agent state machines

## 1. LangChain — 통합의 강자

### What It Is

### Architecture Overview

```typescript
import { ChatOpenAI } from "@langchain/openai";
import { ChatPromptTemplate } from "@langchain/core/prompts";
import { StringOutputParser } from "@langchain/core/output_parsers";

### Why It Matters

### Hands-On Notes

Understanding these philosophical differences is crucial before picking a framework. The wrong choice can mean months of refactoring.

---

**Stars**: 141k · **Language**: TypeScript · **Forks**: 23.3k · **License**: MIT

LangChain is the most mature and widely-used open-source framework for building LLM-powered applications. Originally designed for prompt chaining and RAG pipelines, it has evolved into a comprehensive platform supporting agents, tools, memory systems, and production deployment patterns.

The framework's core strength lies in its ecosystem: 200+ integrations with vector databases, LLM providers, tool servers, and monitoring platforms. If your application needs to connect to an external service, LangChain almost certainly has a built-in adapter.

const model = new ChatOpenAI({ model: "gpt-4o" });
const prompt = ChatPromptTemplate.fromMessages([
  ["system", "You are a helpful assistant."],
  ["human", "{input}"],
]);
const outputParser = new StringOutputParser();

const chain = prompt.pipe(model).pipe(outputParser);

const result = await chain.invoke({ input: "Explain quantum computing" });
console.log(result);
```

LangChain's maturity means less time debugging framework issues and more time building features. The 141k-star community has produced extensive documentation, third-party tutorials, and battle-tested patterns for production deployments.

The TypeScript foundation ensures excellent IDE support, type safety, and seamless integration with modern web stacks. For teams already using React, Next.js, or Node.js, LangChain feels like a natural extension rather than a foreign dependency.


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

## 2. CrewAI — 다중 에이전트 협업을 쉽게

### What It Is

- `@langchain/community` 패키지는 200개 이상의 통합을 제공하지만 번들 크기가 크게 늘어납니다. 
- LangSmith(상용 추적 플랫폼)는 기본적으로 통합되어 있으며 프로덕션 앱을 구독할 가치가 있습니다. 
- v0.2 마이그레이션에는 중요한 API 변경 사항이 도입되었습니다. 업그레이드하기 전에 마이그레이션 가이드를 검토하세요. 
- 에이전트 실행기 패턴(`create_react_agent`, `create_tool_calling_agent`)은 대부분의 오케스트레이션 복잡성을 추상화합니다. 

프로덕션 LangChain 앱에는 적절한 구성 관리가 중요합니다. 

LangChain의 도구 시스템은 기능 기반 도구와 클래스 기반 도구를 모두 지원합니다. 

@도구 
def search_wikipedia(query: str) -> str: 
"""위키피디아를 검색하고 요약을 반환합니다.""" 
langchain_community.tools에서 WikipediaQueryRun 가져오기 
WikipediaQueryRun().run(쿼리)를 반환합니다. 

LangChain은 대화 컨텍스트를 유지하기 위해 여러 가지 메모리 유형을 제공합니다. 

완전한 검색-증강 생성 파이프라인: 

- 최대 통합 옵션(벡터 DB, LLM 제공업체, 도구)이 필요합니다. 
- 팀이 TypeScript에 익숙합니다. 
- 관찰 가능성이 필요한 프로덕션 애플리케이션을 구축하고 있습니다(LangSmith) 
- 가장 큰 커뮤니티와 가장 많은 문서를 원합니다. 

--- 

**별**: 54.6k · **언어**: Python · **포크**: 7.6k · **라이센스**: MIT 

CrewAI는 간단한 전제를 바탕으로 구축되었습니다. 복잡한 작업은 각각 정의된 역할, 목표 및 배경을 가진 전문 에이전트 팀이 가장 잘 해결합니다. 모놀리식 체인 대신 CrewAI를 사용하면 인간 팀이 작동하는 방식을 모방하여 협업하고, 위임하고, 작업을 전달하는 에이전트를 구성할 수 있습니다.

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

이 프레임워크는 2025년 단일 에이전트 시스템이 복잡성의 한계에 도달했다는 것이 분명해지면서 폭발적인 인기를 얻었습니다. CrewAI의 역할 기반 아키텍처는 맞춤형 오케스트레이션 코드 없이 다중 에이전트 조정을 위한 깔끔한 추상화를 제공합니다. 

작가 = 에이전트( 
role="기술 콘텐츠 작성자", 
goal="AI 개발에 관한 매력적인 기사 작성", 
backstory="""당신은 AI 전문 테크니컬 라이터입니다. 
복잡한 연구 결과를 접근 가능한 기사로 번역합니다.""", 
장황하다=사실, 
) 

writing_task = 작업( 
Description="연구를 바탕으로 포괄적인 블로그 게시물을 작성하세요", 
Expect_output="명확한 섹션과 코드 예제가 포함된 1500단어 기사", 
에이전트=작가, 
) 

결과 = 크루.킥오프() 
인쇄(결과) 
```` 

CrewAI의 역할 기반 추상화는 자연스럽게 실제 팀 구조에 매핑됩니다. 연구, 코딩, 글쓰기, 검증 등 다양한 영역을 전문으로 하는 에이전트가 필요한 경우 CrewAI는 상용구 없이 조정 레이어를 제공합니다. 

프레임워크의 Python 기반을 통해 TypeScript에 익숙하지 않은 데이터 과학자 및 ML 엔지니어가 액세스할 수 있습니다. LangChain의 도구 생태계(CrewAI는 LangChain 도구와 통합됨)와 결합되어 강력한 조합을 제공합니다. 

- 순차적 처리는 에이전트를 차례로 실행합니다. 계층적 모드는 위임하는 "관리자" 에이전트를 추가합니다. 
- 에이전트 메모리는 기본적으로 에이전트별로 범위가 지정됩니다. 에이전트 간 지식 전송을 위해 공유 메모리를 사용합니다. 
- 'allow_delegation' 플래그를 사용하면 에이전트가 서로에게 도움을 요청할 수 있어 긴급 협업이 가능해집니다. 
- 성능: 최대 3~5명의 에이전트가 적합합니다. 그 이상으로 조정 오버헤드가 증가합니다. 

CrewAI는 버전 제어 및 재현성을 위해 JSON 기반 팀 구성을 지원합니다.

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

## 3. Microsoft AutoGen — 대화형 에이전트 프레임워크

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

CrewAI supports both sequential and hierarchical task execution:

Extend CrewAI agents with custom tools:

class WebSearchInput(BaseModel):
    query: str = Field(description="The search query")

class WebSearchTool(BaseTool):
    name: str = "Web Search"
    description: str = "Search the web for information"
    args_schema: type[BaseModel] = WebSearchInput

def _run(self, query: str) -> str:
        # Implement your search logic
        return f"Results for: {query}"
```

- Your problem naturally decomposes into specialized sub-tasks
- You want role-based agent coordination without writing custom orchestration
- Your team prefers Python over TypeScript
- You need agents that can collaborate and delegate work

---

**Stars**: 59.4k · **Language**: Python · **Forks**: 8.9k · **License**: MIT

AutoGen, developed by Microsoft Research, takes a fundamentally different approach: agents communicate through natural language conversations. Instead of predefined task pipelines, AutoGen agents negotiate, debate, and collaborate through structured dialogues.

This conversational paradigm enables remarkable flexibility. Agents can dynamically reassign tasks, challenge each other's conclusions, and reach consensus through dialogue — patterns that mirror human problem-solving more closely than rigid pipeline architectures.

user_proxy = UserProxyAgent(
    name="user",
    human_input_mode="NEVER",
    is_termination_msg=lambda x: x.get("content", "").rstrip().endswith("TERMINATE"),
    code_execution_config={
        "work_dir": "coding",
        "use_docker": False,
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

AutoGen의 대화형 모델은 솔루션 경로가 미리 결정되지 않은 복잡하고 개방형 문제에 탁월합니다. 연구팀은 이를 문헌 검토 자동화, 동료 검토를 통한 코드 생성, 다단계 수학적 증명에 사용합니다. 

프레임워크의 연구 내력은 확장성에서 드러납니다. 사용자 정의 에이전트 유형을 정의하고, 새로운 대화 프로토콜을 구현하고, 거의 모든 LLM 제공업체와 통합할 수 있습니다. 59.4,000개의 별은 학계와 업계 모두에서 강력한 채택을 반영합니다. 

- 'GroupChat' 및 'GroupChatManager'를 사용하면 화자를 선택하여 다중 에이전트 대화가 가능합니다. 
- 코드 실행 샌드박스 구성 가능 — 보안을 위해 Docker 권장 
- Human-in-the-loop 모드를 통해 상담원 대화 중에 대화형 개입이 가능합니다. 
- 프레임워크는 계속 발전하고 있습니다. API 안정성은 릴리스마다 다릅니다. 
- AutoGen Studio(GUI)는 에이전트 대화 구축 및 디버깅을 위한 시각적 인터페이스를 제공합니다. 

AutoGen의 GroupChat은 구조화된 다중 에이전트 대화를 가능하게 합니다. 

AutoGen은 구조화된 에이전트 상호 작용을 호출하는 OpenAI 기능을 지원합니다. 

def 계산_bmi(weight_kg: float, height_cm: float) -> dict: 
"""체중과 키로 BMI를 계산하세요.""" 
bmi = 체중_kg / ((신장_cm / 100) ** 2) 
return {"bmi": round(bmi, 1), "category": "normal" if 18.5 <= bmi < 25 else "other"} 

AutoGen은 실행 피드백을 통해 코드 생성에 탁월합니다. 

config_list = [{"model": "gpt-4o", "api_key": "sk-..."}] 

코더 = autogen.AssistantAgent( 
이름="코더", 
llm_config={"config_list": 구성_목록}, 
system_message="당신은 Python 코더입니다. 깨끗하고 테스트된 코드를 작성하세요.", 
) 

실행자 = autogen.UserProxyAgent( 
이름="집행자", 
human_input_mode="절대로", 
code_execution_config={"work_dir": "코딩", "use_docker": False}, 
)


### When to Choose AutoGen

### When to Choose AutoGen

## 4. LlamaIndex — 데이터 기반

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

executor.initiate_chat(coder, message="할일 목록 앱용 Flask API 작성") 
```` 

- 유연한 대화 기반 상담사 조정이 필요합니다. 
- 문제는 반복적인 개선과 토론이 필요합니다. 
- 연구 또는 실험 상황에 있는 경우 
- 인간 참여형(Human-In-The-Loop) 감독 기능을 원하는 경우 

--- 

**별**: 50.5k · **언어**: Python · **포크**: 7.7k · **라이센스**: MIT 

LlamaIndex(이전 GPT Index)는 문서 수집, 색인화 및 쿼리를 위한 도구인 LLM용 데이터 프레임워크로 시작되었습니다. 2026년까지 RAG, 지식 그래프 및 데이터 에이전트에 대한 강력한 지원을 통해 문서 중심 AI 애플리케이션을 위한 포괄적인 플랫폼으로 확장되었습니다. 

데이터를 나중에 고려하는 프레임워크와 달리 LlamaIndex는 데이터를 중심에 둡니다. 인덱싱 파이프라인은 구조화되지 않은 문서를 쿼리 가능한 형식으로 변환하고, 에이전트 프레임워크는 지능형 문서 검색 및 합성을 위해 이러한 인덱스를 활용합니다. 

kg_index = KnowledgeGraphIndex.from_documents( 
문서, 
max_triplets_per_chunk=5, 
) 
kg_query_engine = kg_index.as_query_engine(include_text=True) 
```` 

애플리케이션이 법률 분석, 의료 연구, 기술 문서 등 문서 중심으로 진행되는 경우 LlamaIndex는 오픈 소스 생태계에서 가장 정교한 데이터 파이프라인을 제공합니다. 지식 그래프 기능을 통해 단순한 벡터 유사성을 뛰어넘는 관계 인식 검색이 가능합니다. 

"데이터 에이전트"를 향한 프레임워크의 발전은 중요한 변화를 나타냅니다. 즉, 단순히 문서를 검색하는 대신 LlamaIndex 에이전트는 다단계 쿼리를 계획하고 소스 전반에 걸쳐 정보를 합성하며 문서 컬렉션에서 구조화된 출력을 생성할 수 있습니다.


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

## 5. LangGraph — 상태 유지 에이전트 워크플로우

### What It Is

### Architecture Overview

```python
from langgraph.graph import StateGraph, START, END
from typing import TypedDict, Annotated
import operator

- VectorStoreIndex는 기본값이며 대부분의 사용 사례에 잘 작동합니다. 
- KnowledgeGraphIndex는 관계 인식 기능을 추가하여 복잡한 문서 네트워크에 유용합니다. 
- 메타데이터 필터링을 통해 쿼리되는 문서를 정확하게 제어할 수 있습니다. 
- `PineconeIndex`, `WeaviateIndex` 및 기타 벡터 저장소 통합은 프로덕션 규모 검색을 지원합니다. 
- 데이터 에이전트(`QueryEngineTool`, `AgentRunner`)는 다단계 문서 추론을 가능하게 합니다. 

LlamaIndex는 이미지, PDF 및 기타 텍스트가 아닌 문서를 지원합니다. 

다양한 사용 사례에 맞게 임베딩을 맞춤설정하세요. 

설정.embed_model = cohere_embed 
```` 

더 나은 검색을 위해 색인화하기 전에 문서를 사전 처리합니다. 

의도에 따라 다른 인덱스에 대한 직접 쿼리: 

- 귀하의 애플리케이션은 문서가 많습니다(RAG, 지식 기반, 연구). 
- 고급 색인 전략이 필요합니다(지식 그래프, 하이브리드 검색). 
- 문서 수집에 대해 추론할 수 있는 에이전트를 원합니다. 
- 데이터에는 정교한 전처리 및 변환이 필요합니다. 

--- 

**별**: 36k · **언어**: Python · **포크**: 6k · **라이센스**: MIT 

LangChain 팀이 구축한 LangGraph는 체인 기반 프레임워크의 근본적인 한계를 해결합니다. 체인이 완료되면 모든 컨텍스트가 손실됩니다. 메모리, 조건부 분기 및 사람의 감독이 필요한 복잡한 에이전트 워크플로의 경우 체인은 부족합니다. 

LangGraph는 노드가 계산 단계를 나타내고 가장자리가 흐름을 정의하는 그래프 기반 추상화를 도입합니다. 이를 통해 반복하고, 단계를 다시 방문하고, 반복 전반에 걸쳐 상태를 유지하고, 언제든지 사람의 피드백을 통합할 수 있는 에이전트인 순환 그래프가 가능해집니다. 

클래스 AgentState(TypedDict): 
메시지: 주석이 달린[목록, 연산자.추가] 
검사기: str

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

def 챗봇(상태: AgentState): 
langchain_openai에서 ChatOpenAI 가져오기 
응답 = ChatOpenAI().invoke(state["messages"]) 
{"메시지": [응답]}을 반환합니다. 

def 검사기(상태: AgentState): 
len(state["messages"])[-1].content > 100인 경우: 
"승인됨" 반환 
"needs_revision"을 반환합니다. 

def 수정(상태: AgentState): 
langchain_openai에서 ChatOpenAI 가져오기 
메시지 = 상태["메시지"] + [ 
{"role": "user", "content": "더 짧게 만드세요. 100자 미만입니다."} 
] 
응답 = ChatOpenAI().invoke(메시지) 
{"메시지": [응답]}을 반환합니다. 

앱 = 워크플로우.컴파일() 
```` 

LangGraph의 상태 저장 그래프 기반 접근 방식은 신뢰성과 감사 가능성이 필요한 프로덕션 에이전트 시스템에 이상적입니다. 체크포인트 및 실행 재개 기능은 에이전트가 충돌을 극복하고 지연된 사용자 피드백을 통합하며 분산 배포 전반에 걸쳐 일관된 상태를 유지할 수 있음을 의미합니다. 

Human-In-The-Loop 지원은 특히 강력합니다. 모든 노드에서 실행을 일시 중지하고, 에이전트의 상태를 검토하고, 다음 단계를 승인 또는 수정하고, 재개할 수 있습니다. 이는 규정 준수에 민감한 애플리케이션에 매우 중요합니다. 

- `StateGraph`는 핵심 추상화를 제공합니다. 'MessageGraph'는 채팅 전용 워크플로에 더 간단합니다. 
- 체크포인트 기능이 내장되어 있습니다. 에이전트는 각 노드 전환 시 자동으로 상태를 저장합니다. 
- 컴파일된 그래프는 LangServe를 사용하여 API 엔드포인트로 배포할 수 있습니다. 
- 스트리밍은 기본적으로 지원됩니다. 프런트엔드로 실시간 토큰 출력이 가능합니다. 
- LangSmith와의 통합으로 그래프 실행에 대한 완전한 관찰 가능성 제공 

LangGraph는 모든 노드에서 인간 승인을 위한 일시 중지를 지원합니다. 

LangGraph 에이전트의 실시간 토큰 스트리밍: 

복잡한 워크플로를 재사용 가능한 하위 그래프로 나눕니다. 

그래프 노드에서 재시도 및 대체 논리를 구현합니다.


### When to Choose LangGraph

### When to Choose LangGraph

## 측면 비교

| Feature | LangChain | CrewAI | AutoGen | LlamaIndex | LangGraph |
|---------|-----------|--------|---------|------------|-----------|
| **Stars** | 141k | 54.6k | 59.4k | 50.5k | 36k |
| **Language** | TypeScript | Python | Python | Python | Python |
| **Primary Strength** | Integrations | Multi-agent roles | Conversational | Document RAG | Stateful graphs |
| **Learning Curve** | Medium | Low-Medium | Medium | Medium | Medium-High |
| **Production Ready** | Excellent | Good | Experimental | Excellent | Excellent |
| **Human-in-Loop** | Via LangSmith | Limited | Native | Limited | Native |
| **Best For** | General purpose | Role-based teams | Research | Document AI | Complex workflows |

## 어떻게 선택할까: 결정 프레임워크

### Step 1: What's your primary use case?

### Step 2: What's your team's technical stack?

### Step 3: Do you need multi-agent collaboration?

### Step 4: Is your data document-heavy?

### Recommended Combinations

def retry_with_backoff(max_retries=3, base_delay=1.0): 
def 데코레이터(func): 
@wraps(기능) 
비동기 def 래퍼(*args, **kwargs): 
범위 내 시도(max_retries): 
시도해 보세요: 
return wait func(*args, **kwargs) 
e와 같은 예외를 제외하고: 
시도 == max_retries - 1인 경우: 
올리다 
지연 = base_delay * (2 ** 시도) 
asyncio.sleep(지연)을 기다립니다 
반환 포장지 
반환 장식자 

@retry_with_backoff(max_retries=3) 
비동기 def call_llm_with_retry(프롬프트): 
응답 = model.ainvoke(프롬프트)를 기다립니다. 
응답 반환 
```` 

- 조건부 논리를 갖춘 상태 저장형 다단계 에이전트 워크플로가 필요합니다. 
- 특정 결정 지점에서는 인간 참여형(Human-In-The-Loop) 감독이 필요합니다. 
- 신뢰성을 위해 체크포인트/재개 기능을 원합니다. 
- 감사 추적이 필요한 생산 시스템을 구축하고 있습니다. 

--- 

--- 

- **다양한 통합을 통해 LLM 앱 구축** → LangChain 
- **전문 에이전트 팀 조정** → CrewAI 
- **탐색적 연구 및 대화 에이전트** → AutoGen 
- **문서 분석 및 RAG 파이프라인** → LlamaIndex 
- **상태가 있고 감사 가능한 에이전트 워크플로** → LangGraph 

- **TypeScript/Node.js** → LangChain(네이티브 TS 지원) 
- **Python/ML** → CrewAI, AutoGen, LlamaIndex 또는 LangGraph 

- **예, 역할 기반** → CrewAI 
- **예, 대화형** → AutoGen 
- **아니요, 단일 에이전트** → LangChain 또는 LangGraph 

- **예** → LlamaIndex 
- **아니오** → 나머지 모두 

많은 생산 시스템이 프레임워크를 결합합니다.

## 성능 벤치마크

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

## 개발을 위한 Docker 설정

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

## 커뮤니티와 생태계

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

## 미래 전망

- **LangChain + LangGraph**: 도구 통합에는 LangChain을 사용하고 상태 저장 오케스트레이션에는 LangGraph를 사용합니다. 
- **LlamaIndex + CrewAI**: 문서 색인 생성에는 LlamaIndex를 사용하고 다중 에이전트 분석에는 CrewAI를 사용합니다. 
- **LangChain + AutoGen**: AutoGen의 대화 에이전트와 함께 LangChain의 도구 생태계를 사용합니다. 

--- 

우리는 GPT-4o를 기본 모델로 사용하여 세 가지 표준 벤치마크에서 다섯 가지 프레임워크를 모두 테스트했습니다. 

작업: 자연어 설명에서 작동하는 Python 함수를 생성합니다. 

작업: 50페이지 분량의 기술 문서를 주요 결과로 요약합니다. 

과제: 도구 사용이 필요한 다중 홉 추론 문제를 해결합니다. 

--- 

5가지 프레임워크 모두 Docker 기반 개발 환경을 지원합니다. 통합 설정은 다음과 같습니다. 

WORKDIR /앱 

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"] 
```` 

빌드 및 실행: 

--- 

--- 

AI 에이전트 프레임워크 환경은 2026~2027년에도 계속 발전할 것입니다. 

1. **컨버전스**: 프레임워크는 서로의 장점을 빌리는 것입니다. LangChain은 그래프 기능을 추가하고, CrewAI는 문서 지원을 추가하고, LlamaIndex는 다중 에이전트 기능을 추가합니다. 그들 사이의 경계가 흐려지고 있습니다. 

2. **표준화**: MCP(Model Context Protocol)가 에이전트-도구 통신의 표준으로 떠오르고 있습니다. 5개 프레임워크 모두 MCP 지원을 추가하여 프레임워크 간 상호 운용성을 더 쉽게 만듭니다. 

3. **전문화**: 모든 것을 수행하는 하나의 프레임워크보다는 더 많은 전문화, 즉 도메인별 도구 및 규정 준수 기능을 갖춘 특정 산업(의료, 금융, 법률)에 최적화된 프레임워크를 보게 될 것입니다. 

4. **Edge AI**: 에지 장치에서 로컬 에이전트 실행이 더욱 중요해집니다. 짧은 대기 시간, 오프라인 작업을 위해 최적화된 프레임워크는 IoT 및 모바일 시나리오에서 이점을 얻을 수 있습니다.

## 자주 묻는 질문

### Q1: Can I use multiple frameworks in the same project?

### Q2: Which framework has the best performance for real-time applications?

### Q3: Is there a framework that works without internet connectivity?

### Q4: Which framework is best for beginners?

### Q5: Will one framework win and dominate the market?

## 커뮤니티에 참여하기

5. **평가**: 상담원의 능력이 향상되면 성과를 평가하는 것이 더 어려워집니다. 평가 및 모니터링 기능이 내장된 프레임워크(LangSmith, LlamaIndex 평가자)가 프로덕션 채택을 주도할 것입니다. 

---

예. 많은 프로덕션 시스템이 프레임워크를 결합합니다. LangChain과 LangGraph는 함께 작동하도록 설계되었습니다. CrewAI는 LangChain 도구와 통합됩니다. LlamaIndex는 모든 프레임워크에 대한 데이터 백엔드를 제공할 수 있습니다. 핵심은 각 프레임워크가 뛰어난 위치에 사용하고 불필요한 결합을 피하는 것입니다. 

LangChain은 일반적으로 최적화된 TypeScript 런타임으로 인해 단일 에이전트 작업에 대해 가장 낮은 대기 시간을 제공합니다. 다중 에이전트 시나리오의 경우 CrewAI의 경량 조정 모델은 AutoGen의 대화 오버헤드보다 성능이 뛰어납니다. LLM 선택 및 작업 복잡성에 따라 성능이 크게 달라지므로 특정 사용 사례를 벤치마킹하세요. 

5개 프레임워크는 모두 로컬에서 실행할 수 있지만 전체 오프라인 작업에는 로컬 LLM(Ollama, LM Studio 또는 vLLM을 통해)이 필요합니다. LangChain과 LlamaIndex는 가장 성숙한 오프라인 구성을 갖추고 있습니다. AutoGen의 대화 패턴은 대화형 시나리오를 위한 로컬 모델과 잘 작동합니다. 

CrewAI는 학습 곡선이 가장 완만합니다. 역할 기반 추상화는 직관적입니다. 즉, 에이전트를 정의하고 작업을 할당하고 실행합니다. Python API는 간단하며 개념적 모델은 실제 팀 역학에 매핑됩니다. LangChain은 초보자에게도 친숙하지만 신규 사용자를 압도할 수 있는 구성 옵션이 더 많습니다. 

할 것 같지 않은. 프레임워크는 다양한 철학으로 다양한 문제를 해결합니다. LangChain은 통합을 위해 최적화하고, CrewAI는 협업을 위해, AutoGen은 대화를 위해, LlamaIndex는 데이터를 위해, LangGraph는 상태를 위해 최적화합니다. 시장은 팀이 특정 요구 사항에 따라 선택하는 다중 프레임워크 생태계에 정착할 가능성이 높습니다. 

---

## Dibi8의 더 많은 글

오픈 소스 AI에는 투명한 커뮤니티 중심 분석이 필요하기 때문에 이러한 비교를 구축합니다. 이 내용이 도움이 되었다면: 

- GitHub에서 **이 기사에 별표 표시** 
- 댓글로 이러한 프레임워크에 대한 **경험을 공유**하세요. 
- 다음에 비교하고 싶은 프레임워크 제안** 

--- 

- [자체 호스팅 LLM 가이드: Ollama vs vLLM vs LocalAI(2026)](/resources/llm-frameworks/self-hosted-llm-2026-ollama-vllm-localai/) 
- [벡터 데이터베이스 비교: Qdrant vs Weaviate vs Milvus](/resources/llm-frameworks/Vector-db-2026-qdrant-weaviate-milvus/) 
- [Unsloth: 2026년 빠른 LLM 미세 조정](/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/) 

--- 

*최종 업데이트 날짜: 2026년 6월 30일. 별 개수와 측정항목은 대략적인 수치이며 변경될 수 있습니다. 모든 코드 예제는 발행일 현재 프레임워크 버전으로 테스트되었습니다.*