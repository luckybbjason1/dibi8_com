---
title: 'LlamaIndex: 49K+ Stars — 프로덕션 RAG 배포 가이드 2026'
description: 'LlamaIndex는 LLM을 이용한 프로덕션 RAG 시스템 구축을 위한 데이터 프레임워크이다. OpenAI, Anthropic, Ollama, Qdrant, Weaviate, Chroma를 지원한다. Docker 배포, 쿼리 엔진, 에이전트, LangChain/Haystack/RAGFlow와의 벤치마크를 다룬다.'
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
github_repo: 'https://github.com/run-llama/llama_index'
stars: 49517
maintainer: 'run-llama'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['llamaindex', 'rag', 'llm', '벡터-데이터베이스', '검색-증강-생성', 'openai', 'ollama', 'qdrant', 'python', 'docker']
aliases:
- /kr/posts/llamaindex/
---

{{</* resource-info */>}}

![LlamaIndex Logo](https://raw.githubusercontent.com/run-llama/llama_index/main/docs/docs/_static/assets/LlamaSquareBlack.svg)

## 소개

대부분의 RAG 튜토리얼은 Jupyter Notebook에서 멈춘다. PDF를 로드하고, `VectorStoreIndex.from_documents()`를 호출하고, 괜찮은 답변을 얻으면 작업이 끝났다고 생각한다. 그런 다음 배포를 시도한다——임베딩 단계가 시작할 때 40분이 걸리고, 컨테이너가 인덱스가 지속되지 않아서 충돌하며, 사용자가 불만을 제기한 답변에 대해 실제로 어떤 문서가 검색되었는지 전혀 알 수 없다.

LlamaIndex는 프로덕션 RAG 시스템을 구축하는 팀들의 선호 데이터 프레임워크로 자리 잡았다. **49,517개의 GitHub Stars**, **1,866명의 기여자**, 그리고 2026년 5월 0.14.22 버전을 출시하는 릴리스 속도는 이 프로젝트가 빠르게 발전하고 있음을 보여준다. 이 가이드는 Docker 배포부터 쿼리 라우팅, 모니터링 및 강화까지 프로덕션급 RAG 파이프라인 구축을 다룬다. **llamaindex vs langchain**을 평가하든, 실제 배포 시나리오를 다루는 **llamaindex 튜토리얼**이 필요하든, 이 문서는 풀스택 지침을 제공한다.

## LlamaIndex란 무엇인가?

**LlamaIndex**는 검색 증강 생성(RAG) 파이프라인을 통해 대형 언어 모델(LLM)을 외부 데이터 소스에 연결하는 오픈소스 데이터 프레임워크이다. 데이터 로딩, 인덱싱, 쿼리 및 에이전트 오케스트레이션 도구를 제공하며, 160개 이상의 데이터 커넥터와 주요 벡터 데이터베이스 및 LLM 제공업체와의 네이티브 통합을 갖추고 있다.

처음에는 인덱싱에 집중했으나(이름에서 알 수 있듯이), LlamaIndex는 에이전트 애플리케이션 구축을 위한 완전한 플랫폼으로 확장되었다. 이 프레임워크는 수집 파이프라인, 여러 인덱스 유형, 라우팅이 있는 쿼리 엔진, 이벤트 기반 워크플로우를 처리한다. 모든 구성 요소는 MIT 라이선스하에 있으며 PyPI를 통해 설치할 수 있다.

## LlamaIndex 작동 방식

### 핵심 아키텍처

LlamaIndex는 책임을 네 가지 계층으로 분리한다:

1. **데이터 로딩** — `SimpleDirectoryReader`와 160개 이상의 LlamaHub 커넥터가 PDF, 데이터베이스, API 및 클라우드 스토리지를 `Document` 객체로 파싱한다.
2. **인덱싱** — 문서는 `Node`로 분할된다. 임베딩은 인덱스(`VectorStoreIndex`, `SummaryIndex`, `TreeIndex`, `KnowledgeGraphIndex`)로 입력된다.
3. **쿼리** — `QueryEngine`, `ChatEngine`, `RouterQueryEngine`이 검색, 후처리 및 응답 합성을 처리한다.
4. **에이전트 및 워크플로우** — 이벤트 기반 `Workflow` 클래스와 에이전트 도구가 인간 개입 기능과 함께 다단계 추론을 가능하게 한다.

![RAG 아키텍처](https://cdn.hashnode.com/res/hashnode/image/upload/v1724944925051/e525c6cb-6a99-4eec-8b47-3dc827ddff25.png)

### 핵심 설계 결정

- **원시 문서 대신 Node**: 인덱싱 전 청킹이 발생하여 사용 사례별로 중첩 및 크기를 조정할 수 있다.
- **StorageContext 추상화**: 인덱스를 디스크, S3 또는 모든 벡터 스토어에 지속할 수 있으며 코드 변경이 필요 없다.
- **구성 가능한 검색기**: 벡터 + 키워드 + 그래프 검색기가 `RouterQueryEngine`을 통해 결합된다.
- **네이티브 비동기**: `.aquery()` 및 비동기 수집은 네이티브 기능이며 나중에 추가된 것이 아니다.

## 설치 및 설정

### 기본 설치

```bash
# 가상 환경 생성
python -m venv venv && source venv/bin/activate

# 핵심 프레임워크 설치
pip install llama-index

# 특정 통합 설치
pip install llama-index-vector-stores-qdrant
pip install llama-index-llms-openai
pip install llama-index-embeddings-openai
```

### 환경 설정

```bash
# .env 파일
export OPENAI_API_KEY="sk-..."
export OPENAI_EMBEDDING_MODEL="text-embedding-3-large"

# 로컬 LLM용
export OLLAMA_BASE_URL="http://localhost:11434"
```

### 첫 번째 RAG 파이프라인

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader

# 문서 로드
documents = SimpleDirectoryReader("./data").load_data()

# 벡터 인덱스 구축
index = VectorStoreIndex.from_documents(documents)

# 쿼리 엔진 생성
query_engine = index.as_query_engine()

# 쿼리
response = query_engine.query("What are the key takeaways?")
print(response)
```

### 인덱스 지속화

```python
import os
from llama_index.core import StorageContext, load_index_from_storage

PERSIST_DIR = "./storage"

if not os.path.exists(PERSIST_DIR):
    documents = SimpleDirectoryReader("./data").load_data()
    index = VectorStoreIndex.from_documents(documents)
    index.storage_context.persist(persist_dir=PERSIST_DIR)
else:
    storage_context = StorageContext.from_defaults(persist_dir=PERSIST_DIR)
    index = load_index_from_storage(storage_context)
```

이 패턴은 매번 재시작할 때 임베딩을 다시 계산하지 않도록 방지한다. 10,000개 문서 코퍼스의 경우, 각 배포 시 6분 이상과 API 비용을 절약한다.

## 인기 도구와의 통합

### OpenAI / Anthropic

```python
from llama_index.llms.openai import OpenAI
from llama_index.embeddings.openai import OpenAIEmbedding
from llama_index.core import Settings

Settings.llm = OpenAI(model="gpt-4o-mini")
Settings.embed_model = OpenAIEmbedding(model="text-embedding-3-large")

index = VectorStoreIndex.from_documents(documents)
query_engine = index.as_query_engine()
```

### Ollama (로컬 LLM)

```python
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.core import Settings

Settings.llm = Ollama(model="llama3.2", request_timeout=60.0)
Settings.embed_model = OllamaEmbedding(model_name="nomic-embed-text")

index = VectorStoreIndex.from_documents(documents)
query_engine = index.as_query_engine()
```

### Qdrant (벡터 데이터베이스)

```python
from llama_index.vector_stores.qdrant import QdrantVectorStore
from llama_index.core import StorageContext
import qdrant_client

client = qdrant_client.QdrantClient(url="http://localhost:6333")
vector_store = QdrantVectorStore(client=client, collection_name="my_docs")
storage_context = StorageContext.from_defaults(vector_store=vector_store)

index = VectorStoreIndex.from_documents(documents, storage_context=storage_context)
```

### Weaviate

```python
from llama_index.vector_stores.weaviate import WeaviateVectorStore
import weaviate

client = weaviate.Client(url="http://localhost:8080")
vector_store = WeaviateVectorStore(weaviate_client=client, index_name="Documents")
storage_context = StorageContext.from_defaults(vector_store=vector_store)

index = VectorStoreIndex.from_documents(documents, storage_context=storage_context)
```

### Chroma

```python
from llama_index.vector_stores.chroma import ChromaVectorStore
import chromadb

chroma_client = chromadb.PersistentClient(path="./chroma_db")
chroma_collection = chroma_client.get_or_create_collection("docs")
vector_store = ChromaVectorStore(chroma_collection=chroma_collection)
storage_context = StorageContext.from_defaults(vector_store=vector_store)

index = VectorStoreIndex.from_documents(documents, storage_context=storage_context)
```

## 벤치마크 / 실제 사용 사례

### RAG 성능 벤치마크

2025-2026년 GPT-4o-mini로 10,000개 문서 코퍼스에서의 독립 벤치마크:

| 지표 | LlamaIndex | LangChain | Haystack | RAGFlow |
|---|---|---|---|---|
| RAG 정확도 (RAGAS) | 0.81 | 0.72 | 0.79 | 0.77 |
| 평균 쿼리 지연 시간 | 0.9s | 1.2s | 1.1s | 1.4s |
| 인덱스 구축 시간 (1만 문서) | 6분 | 8분 | 7분 | 9분 |
| 메모리 사용량 | 낮음 | 중간 | 중간 | 높음 |
| 컨텍스트 창 활용률 | 78% | 65% | 72% | 68% |

출처: 2025-2026년 커뮤니티 벤치마크 및 독립 테스트 보고서 집계. 실제 결과는 구성에 따라 다름.

### 프로덕션 사용 사례

- **기업 지식 기반**: 핀테크 회사가 `VectorStoreIndex` + Qdrant로 50만 개의 규제 PDF를 인덱싱하여 서브초 쿼리 지연 시간을 달성했다.
- **다중 문서 Q&A**: 법률 팀이 벡터 검색(판례법)과 키워드 검색(정확한 법규 인용) 간에 쿼리를 라우팅하기 위해 `RouterQueryEngine`을 사용한다.
- **지능형 연구 어시스턴트**: 도구 호출 에이전트의 `Workflow` 클래스가 다단계 연구, 웹 검색 및 인용 생성을 수행한다.
- **메모리가 있는 챗봇**: `CondensePlusContextMode`가 있는 `ChatEngine`이 전문 문서 기반 다중 턴 대화를 처리한다.

### LlamaIndex 선택 시점

| 시나리오 | 권장 접근법 |
|---|---|
| 문서 중심 Q&A | `VectorStoreIndex` + 쿼리 엔진 |
| 여러 데이터 소스 | `RouterQueryEngine` + 다중 인덱스 |
| 다중 턴 대화 | `ChatEngine` + 메모리 |
| 복잡한 추론 | `Workflow` + 에이전트 도구 |
| 구조화된 추출 | `PydanticProgram` 응답 모델 |

## 고급 사용법 / 프로덕션 강화

### 라우터 쿼리 엔진

의도에 따라 쿼리를 다른 인덱스로 라우팅:

```python
from llama_index.core.tools import QueryEngineTool, ToolMetadata
from llama_index.core.query_engine import RouterQueryEngine
from llama_index.core.selectors import PydanticSingleSelector

# 여러 인덱스 생성
vector_index = VectorStoreIndex(nodes)
summary_index = SummaryIndex(nodes)

# 쿼리 엔진 구축
vector_engine = vector_index.as_query_engine()
summary_engine = summary_index.as_query_engine()

# 설명이 있는 도구 정의
query_engine_tools = [
    QueryEngineTool(
        query_engine=vector_engine,
        metadata=ToolMetadata(
            name="semantic_search",
            description="Useful for finding specific facts and details"
        ),
    ),
    QueryEngineTool(
        query_engine=summary_engine,
        metadata=ToolMetadata(
            name="summarization",
            description="Useful for getting high-level summaries"
        ),
    ),
]

# 라우터가 쿼리별 최적의 엔진을 선택
router_engine = RouterQueryEngine(
    selector=PydanticSingleSelector.from_defaults(),
    query_engine_tools=query_engine_tools,
)

response = router_engine.query("Summarize the main points")
```

### 커스텀 Node 후처리기

```python
from llama_index.core.postprocessor import BaseNodePostprocessor
from llama_index.core.schema import NodeWithScore, QueryBundle

class ScoreThresholdPostprocessor(BaseNodePostprocessor):
    def __init__(self, threshold: float = 0.7):
        self.threshold = threshold
        super().__init__()

    def _postprocess_nodes(
        self, nodes: list[NodeWithScore], query_bundle: QueryBundle | None = None
    ) -> list[NodeWithScore]:
        return [n for n in nodes if n.score >= self.threshold]

# 쿼리 엔진에서 사용
query_engine = index.as_query_engine(
    node_postprocessors=[ScoreThresholdPostprocessor(threshold=0.75)]
)
```

### 비동기 쿼리 파이프라인

```python
import asyncio

async def batch_queries(queries: list[str]) -> list[str]:
    tasks = [query_engine.aquery(q) for q in queries]
    responses = await asyncio.gather(*tasks)
    return [str(r) for r in responses]

queries = [
    "What is the refund policy?",
    "How do I reset my password?",
    "What are the SLA terms?",
]

results = asyncio.run(batch_queries(queries))
for q, r in zip(queries, results):
    print(f"Q: {q}\nA: {r}\n")
```

### Docker 배포

```dockerfile
# Dockerfile
FROM python:3.12-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
EXPOSE 8000

CMD ["python", "app.py"]
```

```python
# app.py - FastAPI 서비스
from fastapi import FastAPI
from llama_index.core import StorageContext, load_index_from_storage
from pydantic import BaseModel
import os

app = FastAPI()

PERSIST_DIR = os.environ.get("PERSIST_DIR", "./storage")
storage_context = StorageContext.from_defaults(persist_dir=PERSIST_DIR)
index = load_index_from_storage(storage_context)
query_engine = index.as_query_engine()

class QueryRequest(BaseModel):
    query: str

@app.post("/query")
async def query_docs(request: QueryRequest):
    response = query_engine.query(request.query)
    return {
        "answer": str(response),
        "sources": [n.metadata for n in response.source_nodes],
    }
```

```yaml
# docker-compose.yml
version: "3.8"
services:
  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - PERSIST_DIR=/app/storage
    volumes:
      - ./storage:/app/storage:ro

  qdrant:
    image: qdrant/qdrant:latest
    ports:
      - "6333:6333"
    volumes:
      - qdrant_data:/qdrant/storage

volumes:
  qdrant_data:
```

### DigitalOcean 배포

클릭 인프라의 프로덕션 배포를 위해 **DigitalOcean**은 간단한 경로를 제공한다. App Platform은 자동 HTTPS를 갖춘 Docker 컨테이너를 지원하며, 관리형 데이터베이스가 벡터 스토어 백엔드를 호스팅할 수 있다.

Docker Compose 스택을 DigitalOcean Droplet에 배포:

```bash
# Droplet에서
docker-compose up -d

# 또는 doctl 사용
doctl apps create --spec .do/app.yaml
```

*본 문서에는 DigitalOcean의 제휴 링크가 포함되어 있다. 추천 링크를 통해 가입하면 커미션을 받을 수 있으며, 이는 추가 비용 없이 제공된다.*

### 콜백을 사용한 모니터링

```python
from llama_index.core.callbacks import CallbackManager, TokenCountingHandler
import tiktoken

token_counter = TokenCountingHandler(
    tokenizer=tiktoken.encoding_for_model("gpt-4o-mini").encode,
    verbose=True,
)
Settings.callback_manager = CallbackManager([token_counter])

# 쿼리 후
print(f"LLM Tokens: {token_counter.total_llm_token_count}")
print(f"Embedding Tokens: {token_counter.total_embedding_token_count}")
```

### 프로덕션 체크리스트

| 관심사 | 구현 방식 |
|---|---|
| 인덱스 지속화 | 빌드 시 `storage_context.persist()` 호출 |
| 핫 리로드 | 시작 시 스토리지에서 로드 |
| API 속도 제한 | FastAPI 미들웨어 추가 |
| 입력 검증 | 모든 엔드포인트에 Pydantic 스키마 |
| 출처 인용 | `source_nodes` 메타데이터 반환 |
| 토큰 예산 | `TokenCountingHandler` 모니터링 |
| 비동기 지원 | 동시 부하를 위해 `.aquery()` 사용 |
| 비밀 관리 | 환경 변수 사용, 하드코딩 금지 |

## 대안과의 비교

| 기능 | LlamaIndex | LangChain | Haystack | RAGFlow |
|---|---|---|---|---|
| **핵심 포지션** | 데이터 인덱싱 및 검색 | 에이전트 오케스트레이션 및 체인 | 프로덕션 RAG 파이프라인 | 시각적 RAG 빌더 |
| **GitHub Stars** | 49.5k | 95k | 25.3k | 80.9k |
| **라이선스** | MIT | MIT | Apache-2.0 | Apache-2.0 |
| **데이터 커넥터** | 160+ | 100+ | 30+ | 50+ |
| **인덱스 유형** | 8+ (벡터, 트리, 그래프 등) | 기본 (FAISS, Chroma) | 커스텀 (문서 스토어) | 벡터 + 전문 검색 |
| **쿼리 라우팅** | 네이티브 `RouterQueryEngine` | LangGraph / 수동 | 파이프라인 기반 | 워크플로우 기반 |
| **검색 속도** | LangChain 대비 40% 빠름 | 기준선 | 경쟁력 있음 | 느림 (시각적 오버헤드) |
| **에이전트 지원** | 워크플로우 + 도구 | LangGraph 에이전트 | 커스텀 에이전트 | 내장 에이전트 템플릿 |
| **학습 곡선** | RAG에 부드러움 | 가파름 (고도 모듈화) | 중간 | 낮음 (시각적 UI) |
| **최적 대상** | 문서 Q&A, RAG | 복잡한 다중 에이전트 시스템 | 엔터프라이즈 프로덕션 | 노코드 RAG 구축 |

**선택 방법**: 주요 요구사항이 빠르고 정확한 문서 검색일 때 LlamaIndex를 사용한다. 많은 도구가 있는 복잡한 에이전트 워크플로우를 구축할 때 LangChain을 사용한다. 엔터프라이즈 모니터링과 감사 가능성이 가장 중요할 때 Haystack을 사용한다. 팀이 시각적 저코드 방식을 선호할 때 RAGFlow를 사용한다.

## 한계 / 솔직한 평가

**LlamaIndex가 적합하지 않은 분야**:

1. **복잡한 다중 에이전트 오케스트레이션**: LangGraph는 조걸 분기, 순환 및 병렬 실행을 위한 더 나은 추상화를 제공한다.
2. **노코드 사용자**: RAGFlow의 시각적 빌더는 드래그 앤 드롭 인터페이스를 선호하는 팀에 더 적합하다.
3. **복잡한 문서 파싱**: LlamaParse가 유료 서비스로 존재하지만, RAGFlow의 DeepDoc 파서가 복잡한 PDF(표, 레이아웃)를 더 효과적으로 처리한다.
4. **비 Python 기술 스택**: TypeScript 지원이 존재하나(`llamaindex` npm 패키지), 기능 완성도가 Python에 뒤처진다.
5. **소규모 리소스 환경**: 이 프레임워크는 많은 모듈을 임포트한다. 제한된 엣지 배포의 경우 `txtai`나 직접 API 호출이 더 나은 선택일 수 있다.

## 자주 묻는 질문

**Q1: LlamaIndex와 LangChain의 차이점은 무엇인가?**

LlamaIndex는 데이터 수집, 인덱싱 및 검색 최적화에 집중한다. LangChain은 LLM 작업을 연결하기 위한 범용 오케스트레이션 프레임워크이다. 팀은 종종 둘을 결합한다: LlamaIndex가 검색 레이어를 처리하고, LangChain이 에이전트 로직을 관리한다. RAG 프로젝트에서 **llamaindex vs langchain**을 결정할 때, LlamaIndex는 더 빠른 설정과 더 나은 검색 성능을 제공한다.

**Q2: LlamaIndex를 로컬 모델만으로 사용할 수 있나?**

예. Ollama 통합은 Llama 3.2, Mistral, CodeLlama를 포함한 Ollama를 통해 사용 가능한 모든 모델을 지원한다. `OLLAMA_BASE_URL`을 설정하고 LLM으로 `Ollama`, 임베딩으로 `OllamaEmbedding`을 사용한다. 이는 모든 외부 API 의존성을 제거한다.

**Q3: LlamaIndex를 수백만 개 문서로 확장하려면?**

프로덕션 벡터 데이터베이스(Qdrant, Weaviate 또는 Pinecone)를 메모리 내 스토리지 대신 사용한다. 수집을 쿼리 서비스와 분리된 배치 작업으로 실행한다. 병렬 노드 파싱 및 배치 임베딩 생성이 있는 `IngestionPipeline`을 고려한다.

**Q4: LlamaIndex는 스트리밍 응답을 지원하나?**

예. `as_query_engine()`에 `streaming=True`를 전달하고 응답을 반복한다:

```python
query_engine = index.as_query_engine(streaming=True)
response = query_engine.query("Explain the architecture")
for token in response.response_gen:
    print(token, end="")
```

**Q5: RAG 파이프라인 품질을 어떻게 평가하나?**

LlamaIndex는 내장 평가 모듈을 제공한다:

```python
from llama_index.core.evaluation import FaithfulnessEvaluator, RelevancyEvaluator

faith_eval = FaithfulnessEvaluator()
relevancy_eval = RelevancyEvaluator()

response = query_engine.query("What is the refund policy?")
faith_result = faith_eval.evaluate(response=response)
relevancy_result = relevancy_eval.evaluate(response=response, query="What is the refund policy?")

print(f"Faithful: {faith_result.passing}")
print(f"Relevant: {relevancy_result.passing}")
```

**Q6: LlamaIndex는 상업용으로 물론 물인가?**

예. 핵심 프레임워크는 MIT 라이선스로 상업적 사용이 물이다. LlamaIndex 회사는 LlamaParse(문서 파싱) 및 LlamaCloud(호스팅 서비스)와 같은 유료 서비스를 제공하지만, 오픈소스 프레임워크에는 사용 제한이 없다.

## 결론

LlamaIndex는 프로덕션 RAG 시스템 구축을 간단하게 만들면서도 튜닝에 필요한 낮은 수준의 난을 숨기지 않는 특정하고 가치 있는 틈새를 차지하고 있다. **49K+ Stars**와 활발한 커뮤니티는 그 성숙도를 반영한다. 애플리케이션이 문서 검색, 의미 검색 또는 지식 기반 Q&A를 중심으로 한다면, LlamaIndex는 구조와 유연성 사이에서 적절한 균형을 제공한다.

![LlamaIndex 프로덕션 아키텍처](https://cdn.sanity.io/images/7m9jw85w/production/fc2fb39d84bcf6ae0ca2e4130844c076bc9a20a0-2464x1210.png)

**다음 단계**: 저장소를 클론하고, 5줄 퀵스타트를 실행한 다음, Docker 설정을 인프라에 배포하라. 질문과 커뮤니티 지원은 [dibi8 Telegram 그룹](https://t.me/dibi8community)에 가입하여 프로덕션 RAG 시스템을 구축하는 다른 개발자들과 연결되거나, [LlamaIndex Discord](https://discord.com/invite/eN6D2HQ4aX) 및 [GitHub 저장소](https://github.com/run-llama/llama_index)에서 논의를 팔로우하라.

*제휴 고지: 본 문서에는 DigitalOcean 링크가 포함되어 있다. 이 링크를 통해 서비스를 구매하면 보상을 받을 수 있다. 이는 편집 독립성이나 추천에 영향을 주지 않는다.*



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- [LlamaIndex 공식 문서](https://developers.llamaindex.ai/python/framework/)
- [LlamaIndex GitHub 저장소](https://github.com/run-llama/llama_index)
- [LlamaHub — 데이터 커넥터](https://llamahub.ai)
- [LlamaIndex vs LangChain: 2025 비교](https://latenode.com/blog/langchain-vs-llamaindex-2025-complete-rag-framework-comparison)
- [RAG 프레임워크 벤치마크 2025](https://langcopilot.com/posts/2025-09-18-top-rag-frameworks-2024-complete-guide)
- [Real Python: LlamaIndex 가이드](https://realpython.com/llamaindex-examples/)
- [Haystack GitHub](https://github.com/deepset-ai/haystack)
- [RAGFlow GitHub](https://github.com/infiniflow/ragflow)
