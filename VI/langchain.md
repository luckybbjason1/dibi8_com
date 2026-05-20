---
title: 'LangChain: 3 Cach Trien Khai AI Agent San Sang Production voi 137K+ Stars — Huong Dan Deployment Day Du 2026'
description: 'LangChain (LC) la framework Python/JS de xay dung ung dung LLM voi 700+ tich hop. Hoc cach cai dat LangChain, trien khai voi Docker, tich hop voi OpenAI, Anthropic, Ollama, va mo rong production voi LangSmith, LangGraph agents, va Kubernetes.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/langchain-ai/langchain'
stars: 137165
maintainer: 'langchain-ai'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['langchain', 'llm', 'ai-agent', 'rag', 'production-deployment', 'docker', 'python', 'openai', 'langsmith', 'langgraph']
aliases:
- /vi/posts/langchain/
- /vi/resources/llm-frameworks/langchain-complete-guide/
---

{{</* resource-info */>}}

![LangChain Logo](https://raw.githubusercontent.com/langchain-ai/langchain/master/docs/static/img/brand/wordmark.png)

![LangChain Architecture](https://python.langchain.com/assets/images/rag_concepts-5c2d984a185b8cc47623e6d4818f073f.png)

## Gioi thieu

Hau het cac demo LLM chet trong notebook Jupyter. Khoang cach giua mot prototype hoat dong va mot AI agent san sang production la noi cac team dot tien engineering: dau ra khong nhat quan, loi khong the truy vet, chi phi API vuot tam kiem soat, va cac ban trien khai sup do khi tai tang. LangChain, framework ung dung LLM duoc su dung rong rai nhat voi hon 137.000 sao GitHub va hon 3.900 nguoi dong gop, ton tai de thu hep khoang cach do. Tutorial nay cho ban thay cach cai dat LangChain, xay dung agent co the trien khai, va chay no trong production voi Docker, Kubernetes, va cong cu quan sat — trong vong duoi 30 phut.

## LangChain la gi?

LangChain la framework Python va TypeScript ma nguon mo de xay dung ung dung duoc cung cap boi cac mo hinh ngon ngu lon. No cung cap thu vien component module hoa — chains, agents, memory, document loaders, vector stores, va output parsers — ma developer co the ket hop thanh cac AI workflow phuc tap. Voi hon 700 tich hop bao gom OpenAI, Anthropic, Ollama, Pinecone, Chroma, va hang chuc he thong doanh nghiep, LangChain dong vai tro nhu mo lien ket giua API LLM tho va cac dich vu AI san sang production. Du an da dat den 1.0 LTS vao thang 10 nam 2025, gioi thieu semantic versioning, content blocks chuan hoa, va dam bao tuong thich nguoc tren toan bo chuoi phien ban 1.x.

## LangChain hoat dong nhu the nao

### Tong quan kien truc

Kien truc cua LangChain tach biet moi quan tam thanh nam lop:

1. **Model I/O** — Cac giao dien chuan hoa cho chat models, LLMs, va embeddings. Chuyen tu OpenAI GPT-4o sang Anthropic Claude 3.5 Sonnet chi bang cach thay doi mot dong import.
2. **Retrieval** — Document loaders, text splitters, embedding models, va vector stores tao thanh pipeline RAG. Tai PDF, HTML, hoac trang Notion, chia nho, embedding, va truy van theo ng nghia.
3. **Agents** — API `create_agent` (LangChain 1.0+) dieu phoi viec chon cong cu, vong lap suy luan, va phe duyet con nguoi trong vong lap. Agents quyet dinh goi cong cu nao, theo thu tu nao, va khi nao dung lai.
4. **Chains** — Cac workflow co the ket hop ma lien ket cac component theo trinh tu. Mot chuoi RetrievalQA ket noi retriever voi LLM de tra loi cau hoi tren tai lieu.
5. **Quan sat (Observability)** — LangSmith truy vet moi lan goi, do luong do tre, luong token su dung, va chi phi. Traces ghi lai dau vao, dau ra, va cac buoc trung gian de gỡ loi.

```
Truy van nguoi dung → Agent/Chain → [Goi cong cu → Goi LLM → Truy xuat] → Phan hoi
                ↓
            LangSmith (truy vet, metrics, danh gia)
```

![LangChain RAG Flow](https://python.langchain.com/assets/images/rag_indexing-6b1e22092b4c169a9075d080d71a5e95.png)

### Cac khai niem cot loi

**Giao dien Runnable.** Moi component trong LangChain trien khai giao thuc `Runnable` voi cac phuong thuc `.invoke()`, `.batch()`, va `.stream()`. Giao dien thong nhat nay cho phep ban xu ly mot single prompt, mot chuoi muoi component, hoac mot do thi da-agent mot cach dong nhat.

**Content Blocks.** LangChain 1.0 gioi thieu `.content_blocks` tren messages — mot dinh dang thong nhat cho van ban, hinh anh, goi cong cu, va traces suy luan tren tat ca cac nha cung cap. Khong con phan tich cu phap message theo nha cung cap.

**Model Profiles.** Cac chat model lo ra kha nang thong qua thuoc tinh `.profile`, cho phep phat hien tinh nang dong. Code cua ban co the kiem tra xem model co ho tro goi cong cu hoac vision truoc khi thu.

## Cai dat va thiet lap

### Cai dat co ban

LangChain duoc cai dat qua pip trong vong duoi 60 giay. Python 3.10+ la bat buoc tu phien ban 1.0.

```bash
# Cai dat framework cot loi
pip install langchain-core==1.4.0 langchain

# Cai dat tich hop OpenAI
pip install langchain-openai

# Cai dat tich hop Anthropic
pip install langchain-anthropic

# Cai dat tich hop cong dong (vector stores, loaders, tools)
pip install langchain-community

# Cai dat LangGraph cho agent workflows
pip install langgraph

# Cai dat LangSmith cho kha nang quan sat
pip install langsmith
```

### Xac minh cai dat

```python
import langchain_core
print(langchain_core.__version__)
# Output: 1.4.0

from langchain_openai import ChatOpenAI
from langchain_anthropic import ChatAnthropic

# Kiem tra khoi tao model
openai_model = ChatOpenAI(model="gpt-4o", temperature=0)
anthropic_model = ChatAnthropic(model="claude-3-5-sonnet-20241022")

print("LangChain installed successfully with OpenAI and Anthropic providers")
```

### Cau hinh moi truong

```bash
# File .env
OPENAI_API_KEY=sk-proj-xxxxx
ANTHROPIC_API_KEY=sk-ant-xxxxx
LANGSMITH_API_KEY=ls-xxxxx
LANGSMITH_TRACING=true
LANGSMITH_PROJECT=production-agents
```

### Thiet lap Docker (Khuyen nghi cho Production)

```dockerfile
# Dockerfile
FROM python:3.12-slim

WORKDIR /app

# Cai dat cac phu thuoc he thong
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Sao chep va cai dat cac phu thuoc Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Sao chep ma ung dung
COPY . .

# Nguoi dung non-root de bao mat
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Kiem tra suc khoe
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]
```

```txt
# requirements.txt
langchain-core==1.4.0
langchain==1.3.0
langchain-openai==1.2.0
langchain-anthropic==1.4.0
langgraph==0.4.0
langsmith==0.7.0
uvicorn==0.34.0
fastapi==0.115.0
pydantic==2.10.0
python-dotenv==1.0.0
redis==5.2.0
httpx==0.28.0
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - LANGSMITH_API_KEY=${LANGSMITH_API_KEY}
      - LANGSMITH_TRACING=true
      - REDIS_URL=redis://redis:6379
    depends_on:
      - redis
      - chroma
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data
    restart: unless-stopped

  chroma:
    image: chromadb/chroma:latest
    volumes:
      - chroma_data:/chroma/chroma
    restart: unless-stopped

volumes:
  redis_data:
  chroma_data:
```

### Build va chay

```bash
# Build image
docker build -t langchain-production-app .

# Chay voi docker-compose
docker-compose up -d

# Kiem tra trien khai
curl http://localhost:8000/health
```

## Tich hop voi OpenAI, Anthropic, Ollama, va Vector Stores

### Tich hop OpenAI GPT-4o

```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate

# Khoi tao model
model = ChatOpenAI(
    model="gpt-4o",
    temperature=0.1,
    max_tokens=4096,
    timeout=30,
    max_retries=3,
)

# Tao chain
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful assistant that answers questions about {topic}."),
    ("human", "{question}"),
])

chain = prompt | model

# Goi
response = chain.invoke({
    "topic": "machine learning",
    "question": "Explain backpropagation in 3 sentences."
})
print(response.content)
```

### Tich hop Anthropic Claude

```python
from langchain_anthropic import ChatAnthropic

claude = ChatAnthropic(
    model="claude-3-5-sonnet-20241022",
    temperature=0.1,
    timeout=30,
    max_retries=3,
)

# Cung mot prompt hoat dong tren moi nha cung cap
claude_chain = prompt | claude
response = claude_chain.invoke({
    "topic": "distributed systems",
    "question": "What is the CAP theorem?"
})
print(response.content)
```

### Model cuc bo Ollama

```python
from langchain_ollama import ChatOllama

local_model = ChatOllama(
    model="llama3.3",
    temperature=0.1,
    base_url="http://localhost:11434",
)

response = local_model.invoke("Explain quantum computing simply.")
print(response.content)
```

### Pipeline RAG voi Chroma Vector Store

```python
from langchain_community.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_openai import OpenAIEmbeddings
from langchain_chroma import Chroma
from langchain.chains import RetrievalQA

# Tai va chia tai lieu
loader = PyPDFLoader("./documents.pdf")
docs = loader.load()

splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
    length_function=len,
)
chunks = splitter.split_documents(docs)

# Luu tru trong co so du lieu vector
embeddings = OpenAIEmbeddings(model="text-embedding-3-large")
vectorstore = Chroma.from_documents(
    documents=chunks,
    embedding=embeddings,
    persist_directory="./chroma_db",
)

# Tao chuoi QA
qa_chain = RetrievalQA.from_chain_type(
    llm=ChatOpenAI(model="gpt-4o", temperature=0),
    chain_type="stuff",
    retriever=vectorstore.as_retriever(search_kwargs={"k": 5}),
    return_source_documents=True,
)

# Truy van
result = qa_chain.invoke({"query": "What are the key findings?"})
print(result["result"])
```

### Agent voi cong cu

```python
from langchain import hub
from langchain.agents import create_tool_calling_agent, AgentExecutor
from langchain_core.tools import tool
from langchain_openai import ChatOpenAI

# Dinh nghia cac cong cu tuy chinh
@tool
def search_knowledge_base(query: str) -> str:
    """Search internal knowledge base for technical documentation."""
    return f"Results for '{query}': Found 3 relevant documents."

@tool
def calculate(expression: str) -> str:
    """Evaluate a mathematical expression."""
    try:
        result = eval(expression)
        return str(result)
    except Exception as e:
        return f"Error: {str(e)}"

# Tao agent
tools = [search_knowledge_base, calculate]
llm = ChatOpenAI(model="gpt-4o", temperature=0)
prompt = hub.pull("hwchase17/openai-functions-agent")
agent = create_tool_calling_agent(llm, tools, prompt)
agent_executor = AgentExecutor(agent=agent, tools=tools, verbose=True)

# Chay agent
result = agent_executor.invoke({
    "input": "What is 1250 * 37 and search for deployment docs?"
})
print(result["output"])
```

## Benchmarks / Truong hop su dung thuc te

### Benchmark hieu nang

Du lieu benchmark duoc thu thap tren AWS c5.4xlarge (16 vCPU, 32GB RAM) voi gpt-3.5-turbo va sentence-transformers/all-mpnet-base-v2:

| Chi so | LangChain | LlamaIndex | Haystack | Semantic Kernel |
|--------|-----------|------------|----------|-----------------|
| QPS (truy van/giay) | 78.2 | 85.4 | 102.5 | 65.4 |
| Dinh bo nho (MB) | 1,203 | 980 | 856 | 987 |
| Do tre byte dau (ms) | 210 | 165 | 92 | 185 |
| Do chinh xac RAG (SQuAD) | 82.3% | 88.1% | 85.1% | 79.8% |
| So luong tich hop | 700+ | 300+ | 150+ | 80+ |
| Sao GitHub | 137,165 | 39,200 | 17,900 | 26,300 |
| Thoi gian len production | 2-3 ngay | 1-2 ngay | 3-5 ngay | 4-7 ngay |

LangChain doi toc do truy xuat tho lay tinh linh hoat dieu phoi. Haystack dan dau ve QPS truy xuat tai lieu tho nhung thieu kha nang agent. LlamaIndex cung cap con duong nhanh nhat den RAG nhung pham vi hep hon. Semantic Kernel tich hop native voi Azure nhung he sinh thai ma nguon mo nho hon.

### Cac nghien cuu truong hop production

**Tu dong hoa ho tro khach hang (SaaS, 500K nguoi dung).** Cong ty B2B SaaS da thay the bot ho tro dua tren quy tac bang agent LangChain tich hop co so kien thuc, CRM, va he thong ticketing. Agent tu dong xu ly 78% cac truy van cap 1, nang cap cac van de phuc tap len nhan vien con nguoi voi day du ng canh cuoc tro chuyen. Thoi gian phan hoi trung binh giam tu 4.2 gio xuong con 12 giay.

**Phan tich tai lieu phap ly (Cong ty luat, 50 luat su).** Doi litig su dung LangChain RAG tren 50.000 tai lieu vu an. Pipeline tai PDF, chia nho voi semantic chunking, luu embeddings trong Pinecone, va tao ban thao memo co trich dan. Thoi gian nghien cuu cua luat su moi vu giam 60%.

**Tro ly tao ma (Fintech, 200 ky su).** Cong cu nha phat trien noi bo tren LangChain ket noi voi GitHub, tai lieu, va spec API. Ky su mo ta tinh nang bang ngon ngu tu nhien; agent tao ke hoach trien khai, ban thao ma, va test case. Thoi gian prototype tinh nang giam tu 3 ngay xuong 4 gio.

## Su dung nang cao / Cung co Production

### LangGraph cho cac workflow agent phuc tap

LangGraph mo rong LangChain voi dieu phoi agent dua tren do thi. No ho tro chu trinh, phan nhanh, va con nguoi trong vong lap — thiet yeu cho cac agent production can cong phe duyet.

```python
from langgraph.graph import StateGraph, END
from typing import TypedDict, Annotated, Sequence
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain_openai import ChatOpenAI
import operator

# Dinh nghia trang thai
class AgentState(TypedDict):
    messages: Annotated[Sequence[BaseMessage], operator.add]
    next_step: str

# Dinh nghia cac nut
def agent_node(state: AgentState):
    model = ChatOpenAI(model="gpt-4o")
    response = model.invoke(state["messages"])
    return {"messages": [response], "next_step": "human_review"}

def human_review(state: AgentState):
    # Trong production, noi nay tam dung cho phe duyet con nguoi
    last_msg = state["messages"][-1].content
    if "DELETE" in last_msg.upper() or "DROP" in last_msg.upper():
        return {"next_step": "reject"}
    return {"next_step": "execute"}

def execute_tool(state: AgentState):
    return {"messages": [AIMessage(content="Action executed successfully.")], "next_step": END}

def reject_action(state: AgentState):
    return {"messages": [AIMessage(content="Action rejected by policy.")], "next_step": END}

# Xay dung do thi
workflow = StateGraph(AgentState)
workflow.add_node("agent", agent_node)
workflow.add_node("human_review", human_review)
workflow.add_node("execute", execute_tool)
workflow.add_node("reject", reject_action)

workflow.set_entry_point("agent")
workflow.add_edge("agent", "human_review")
workflow.add_conditional_edges(
    "human_review",
    lambda x: x["next_step"],
    {"execute": "execute", "reject": "reject"}
)
workflow.add_edge("execute", END)
workflow.add_edge("reject", END)

# Bien dich va chay
app = workflow.compile()
result = app.invoke({"messages": [HumanMessage(content="Delete all user records from the database.")]})
print(result["messages"][-1].content)
```

### Xu ly loi va thu lai

Cac agent production that bai. Xu ly mot cach thanh lich.

```python
from langchain_core.runnables import RunnableConfig
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10),
    reraise=True
)
def invoke_with_retry(chain, inputs, config: RunnableConfig = None):
    try:
        return chain.invoke(inputs, config=config)
    except Exception as e:
        # Ghi vao LangSmith de phan tich
        print(f"Invocation failed: {e}. Retrying...")
        raise

# Su dung
config = RunnableConfig(tags=["production", "customer-facing"])
result = invoke_with_retry(qa_chain, {"query": "What are the terms?"}, config)
```

### Gioi han toc do va kiem soat chi phi

```python
from langchain_core.rate_limiters import InMemoryRateLimiter
import time

# Gioi han toc do: 10 yeu cau moi phut
rate_limiter = InMemoryRateLimiter(
    requests_per_second=10/60,
    check_every_n_seconds=1,
    max_bucket_size=5,
)

model = ChatOpenAI(
    model="gpt-4o",
    rate_limiter=rate_limiter,
    max_tokens=2000,  # Gioi han cung dau ra token
)

# Theo doi chi phi moi yeu cau
from langchain.callbacks import get_openai_callback

with get_openai_callback() as cb:
    response = model.invoke("Summarize this 50-page report.")
    print(f"Tokens: {cb.total_tokens}, Cost: ${cb.total_cost:.4f}")
```

### Giam sat voi LangSmith

```python
import os

# Bat tracing
os.environ["LANGSMITH_TRACING"] = "true"
os.environ["LANGSMITH_API_KEY"] = "ls-xxxxx"
os.environ["LANGSMITH_PROJECT"] = "production-agents"

from langsmith import Client
client = Client()

# Danh gia lap trinh
from langsmith.evaluation import evaluate

def accuracy_evaluator(run, example):
    prediction = run.outputs["output"]
    expected = example.outputs["expected_answer"]
    score = 1.0 if expected.lower() in prediction.lower() else 0.0
    return {"key": "accuracy", "score": score}

results = evaluate(
    lambda x: agent_executor.invoke(x),
    data="my-dataset-name",
    evaluators=[accuracy_evaluator],
)
```

### Trien khai Kubernetes

```yaml
# k8s-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: langchain-app
  labels:
    app: langchain-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: langchain-app
  template:
    metadata:
      labels:
        app: langchain-app
    spec:
      containers:
      - name: app
        image: langchain-production-app:latest
        ports:
        - containerPort: 8000
        env:
        - name: OPENAI_API_KEY
          valueFrom:
            secretKeyRef:
              name: api-secrets
              key: openai-key
        - name: LANGSMITH_API_KEY
          valueFrom:
            secretKeyRef:
              name: api-secrets
              key: langsmith-key
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "2000m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 10
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /ready
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  name: langchain-service
spec:
  selector:
    app: langchain-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8000
  type: ClusterIP
```

```bash
# Trien khai len Kubernetes
kubectl apply -f k8s-deployment.yaml
kubectl get pods -l app=langchain-app
kubectl logs -f deployment/langchain-app
```

### Redis caching cho cac truy van thuong xuyen

```python
import redis
import json
import hashlib
from langchain.globals import set_llm_cache
from langchain_community.cache import RedisCache

# Ket noi Redis
redis_client = redis.Redis.from_url("redis://localhost:6379")
set_llm_cache(RedisCache(redis_client=redis_client))

# Khoa cache dua tren hash dau vao
def get_cache_key(prefix: str, text: str) -> str:
    hash_val = hashlib.md5(text.encode()).hexdigest()
    return f"{prefix}:{hash_val}"

# Kiem tra cache truoc khi goi LLM dat do
def cached_invoke(chain, inputs: dict, ttl: int = 3600):
    cache_key = get_cache_key("llm", json.dumps(inputs, sort_keys=True))
    cached = redis_client.get(cache_key)
    if cached:
        return json.loads(cached)

    result = chain.invoke(inputs)
    redis_client.setex(cache_key, ttl, json.dumps({"output": result.content}))
    return result
```

![LangChain Integration Map](https://raw.githubusercontent.com/langchain-ai/langchain/master/docs/static/img/social_share.png)

## So sanh voi cac lra chon thay the

| Tinh nang | LangChain | LlamaIndex | Haystack | Semantic Kernel |
|-----------|-----------|------------|----------|-----------------|
| **Trong tam chinh** | Workflow da buoc, dieu phoi agent | Danh muc tai lieu, toi uu tim kiem | Tim kiem ng nghia, pipeline RAG | Tich hop doanh nghiep, he sinh thai MS |
| **Ho tro ngon ngu** | Python, TypeScript | Python, TypeScript | Python | C#, Python, Java |
| **Sao GitHub** | 137,165 | 39,200 | 17,900 | 26,300 |
| **Giay phep** | MIT | MIT | Apache-2.0 | MIT |
| **So tich hop** | 700+ | 300+ | 150+ | 80+ |
| **Hieu nang RAG** | Tot (82.3% chinh xac) | Tot nhat (88.1% chinh xac) | Tot (85.1% chinh xac) | Trung binh (79.8% chinh xac) |
| **Kha nang agent** | Nang cao (LangGraph) | Co ban | Han che | Trung binh (Planner) |
| **Kha nang quan sat** | LangSmith (native) | Callback co ban + LangSmith | Hinh anh hoa pipeline tich hop | Azure Monitor |
| **Thoi gian xay RAG** | 2-3 ngay | 1-2 ngay | 3-5 ngay | 4-7 ngay |
| **Do truong thanh production** | LTS 1.0 (10/2025) | Pre-1.0, on dinh | 1.0+ on dinh | 1.0+ on dinh |
| **Chi phi (Framework)** | Mien phi | Mien phi | Mien phi | Mien phi |
| **Dam may quan ly** | LangSmith $39/user/thang | LlamaCloud theo luong su dung | deepset Cloud tuy chinh | Azure AI Services |
| **Duong cong hoc tap** | Trung binh | Nhe nhang | Trung binh | Trung binh |
| **Con nguoi trong vong lap** | Native (LangGraph) | Han che | Co ban | Qua Azure Logic Apps |
| **Phu hop nhat** | Agent phuc tap, workflow da cong cu | Q&A tai lieu, co so kien thuc | Tim kiem doanh nghiep, tuan thu | Moi truong MS, team .NET |

## Han che / Danh gia trung thuc

**Khong phai nhanh nhat cho truy xuat tho.** Neu use case cua ban hoan toan la tim kiem va truy xuat tai lieu, LlamaIndex hoac Haystack se vuot troi hon LangChain ve do tre va do chinh xac. Diem manh cua LangChain la dieu phoi, khong phai toc do truy xuat tho.

**Duong cong hoc tap doc hon cho cac truong hop don gian.** Mot ung dung "chat voi PDF" co ban yeu cau hieu ve loaders, splitters, embeddings, vector stores, va chains. Cac cong cu nhu RAGFlow hoac Verba cung cap con duong nhanh hon cho nguoi khong phai developer.

**Su phat trien nhanh tao ra phien ban drift.** Mac du co cam ket LTS 1.0, he sinh thai van phat trien nhanh. Cac tich hop cong dong (`langchain-community`) co the gioi thieu cac thay doi pha vo trong phien ban minor. Co dinh phien ban chinh xac trong production.

**Chi phi LangSmith ty le theo muc su dung.** Tier mien phi bao gom 5.000 traces hang thang — du cho prototype nhung khong du cho production. Mot team 5 nguoi xu ly 100.000 traces hang thang tra khoang $220/thang chi cho LangSmith, chua ke chi phi API LLM.

**Rui ro over-engineering.** Tinh linh hoat cua LangChain lam developer xay dung cac do thi agent phuc tap noi mot loi goi prompt + API don gian la du. Bat dau don gian, chi them phuc tap khi metrics chung minh dieu do.

**He sinh thai C# va Java han che.** Cac team trong moi truong Microsoft-centric co the thay su ho tro .NET first-class cua Semantic Kernel tu nhien hon phuong phap Python-first cua LangChain.

## Cau hoi thuong gap

### Su khac biet giua LangChain va LangGraph?

LangChain la framework cot loi de xay dung ung dung LLM voi chains, prompts, va tich hop model. LangGraph la thu vien mo rong them kha nang dieu phoi dua tren do thi cho cac workflow agent phuc tap voi chu trinh, phan nhanh, va phe duyet con nguoi trong vong lap. Hay nghi LangChain nhu thu vien component va LangGraph nhu engine workflow. Ca hai deu duoc LangChain Inc duy tri va chia se cung chu ky phat hanh.

### Lam the nao de chuyen doi giua cac nha cung cap LLM trong LangChain?

Thay doi import lop model. Giao dien `BaseChatModel` chuan hoa cua LangChain co nghia la code viet cho OpenAI hoat dong voi Anthropic, Google, Ollama, hoac bat ky nha cung cap nao duoc ho tro chi voi thay doi toi thieu. Thuoc tinh `.content_blocks` trong 1.0+ chuan hoa dinh dang message tren tat ca cac nha cung cap, loai bo ma phan tich cu phap theo nha cung cap.

### LangChain co mien phi cho thuong mai khong?

Co. LangChain duoc cap phep MIT va mien phi cho ca su dung thuong mai va ca nhan. Framework cot loi, LangGraph, va tat ca cac tich hop cong dong khong co phi giay phep. LangSmith (nen tang quan sat) cung cap tier mien phi voi 5.000 traces hang thang; cac goi tra phi bat dau tu $39 moi nguoi dung moi thang. Chi phi API LLM tu OpenAI, Anthropic, hoac cac nha cung cap khac duoc tinh rieng.

### Stack trien khai khuyen nghi cho LangChain trong production?

Cho cac trien khai production, su dung container Docker voi may chu WSGI/ASGI (Uvicorn hoac Gunicorn), Redis cho caching va trang thai phien, vector store (Chroma cho quy mo nho, Pinecone hoac Weaviate cho quy mo lon), va LangSmith cho kha nang quan sat. Trien khai tren Kubernetes de mo rong ngang. Dat gioi han tai nguyen, kiem tra suc khoe, va gioi han toc do. Co dinh tat ca phien ban phu thuoc va chay danh gia truoc moi lan trien khai.

### LangChain xu ly loi va thu lai nhu the nao?

LangChain cung cap logic thu lai built-in voi exponential backoff thong qua tham so `max_retries` tren cac lop model. Cho production, boc cac duong dan quan trong bang Tenacity de kiem soat chinh sach thu lai mot cach chi tiet. Su dung xu ly ngoai le co cau truc de phan biet giua loi co the thu lai (gioi han toc do, timeout) va loi cuoi cung (dau vao khong hop le, loi xac thuc). Ghi tat ca cac that bai vao LangSmith de phan tich sau su co.

### Toi co the tu host LangSmith khong?

LangSmith tu host chi co san tren cac goi Enterprise voi gia tuy chinh. Cho cac team yeu cau kha nang quan sat on-premises, cac lra chon ma nguon mo bao gom Langfuse (giay phep MIT), Phoenix by Arize (mien phi), va Helicone (ma nguon mo). Cac cong cu nay tich hop voi LangChain thong qua OpenTelemetry hoac callbacks truc tiep.

### Lam the nao de mo rong LangChain agents xu ly 1.000+ nguoi dung dong thoi?

Mo rong theo chieu ngang bang cach chay nhieu instance container phia sau mot bo can bang tai. Su dung cac mau bat dong bo (`ainvoke`, `astream`) de toi da hoa thong luong tren moi worker. Trien khai Redis caching cho cac truy van thuong duoc hoi. Thiet lap connection pooling cho co so du lieu va API ben ngoai. Giam sat luong token su dung va chi phi moi yeu cau qua LangSmith. Xem xet su dung he thong hang doi (Celery, RQ) cho cac tac vu agent chay lau thay vi cac yeu cau HTTP dong bo.

## Ket luan

137.000 sao GitHub cua LangChain phan anh vi the cua no nhu framework mac dinh cho cac ung dung LLM production. Phien ban 1.0 LTS da mang lai tinh on dinh ma cac trien khai doanh nghiep yeu cau: semantic versioning, cac giao dien chuan hoa, va dam bao tuong thich nguoc. Huong dan nay da bao gom cach cai dat LangChain, dong goi voi Docker, trien khai tren Kubernetes, va cung co voi kha nang quan sat va xu ly loi.

**Cac buoc tiep theo:**
1. Clone [kho LangChain](https://github.com/langchain-ai/langchain) va chay quickstart
2. Trien khai container dau tien cua ban voi Dockerfile va file compose o tren
3. Thiet lap LangSmith tracing de thiet lap duong co ban quan sat truoc khi di live
4. Tham gia [cong dong Discord LangChain](https://discord.gg/langchain) va [Nhom Telegram AI Dev](https://t.me/ai_source_code_hub) de thao luan ve trien khai production



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguon va tai lieu tham khao

- [Tai lieu chinh thuc LangChain](https://docs.langchain.com/)
- [Kho GitHub LangChain](https://github.com/langchain-ai/langchain)
- [Tai lieu LangGraph](https://langchain-ai.github.io/langgraph/)
- [Nen tang LangSmith](https://smith.langchain.com/)
- [Ghi chu phat hanh LangChain 1.0](https://github.com/langchain-ai/langchain/releases)
- [So sanh LangChain vs LlamaIndex — Latenode](https://latenode.com/blog/langchain-vs-llamaindex-2025-complete-rag-framework-comparison)
- [Huong dan trien khai Docker LangChain — DevOpsness](https://www.devopsness.com/blog/production-ai-applications-langchain-docker)
- [Huong dan AI Agent Production — GroovyWeb](https://www.groovyweb.co/blog/building-production-ready-ai-agents-practical-guide)
- [So sanh cong cu giam sat LLM — Integrity Studio](https://integritystudio.ai/blog/best-llm-monitoring-tools-2025)
- [Chinh sach phien ban va phat hanh LangChain](https://docs.langchain.com/oss/python/versioning)
- [Gia LangChain — CheckThat.ai](https://checkthat.ai/brands/langchain/pricing)
