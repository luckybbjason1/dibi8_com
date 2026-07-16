---
title: Deepset Haystack — Build Production-Ready RAG Applications with Python
description: Complete guide to Deepset Haystack, the open-source Python framework for building Retrieval-Augmented Generation (RAG) applications. Document indexing, retrieval pipelines, and LLM integration at scale.
category: llm-frameworks
tags: ['haystack', 'rag', 'retrieval-augmented-generation', 'deepset', 'document-processing', 'llm-pipeline']
slug: deepset-haystack-rag-framework-complete-guide
date: 2026-07-17 00:00:00+00:00
featureImage: /images/articles/deepset-haystack-rag.jpg
---

## TL;DR

Deepset Haystack is the leading open-source Python framework for building production-grade Retrieval-Augmented Generation (RAG) applications in 2026. This comprehensive guide covers document ingestion, embedding generation, vector search, pipeline orchestration, and LLM integration for building intelligent knowledge systems.

## What Is Haystack?

Haystack is an end-to-end framework for building custom LLM applications centered around retrieval-augmented generation. Developed by Deepset, it provides composable components for every step of the RAG pipeline — from document loading and preprocessing to retrieval, ranking, and generation. With 20k+ stars on GitHub, Haystack has become the go-to framework for enterprise RAG deployments.

### Key Features

- **End-to-End Pipeline**: Complete RAG pipeline from documents to answers
- **Document Store Agnostic**: Works with Elasticsearch, OpenSearch, Pinecone, Weaviate, Milvus, and more
- **Embedding Integration**: Built-in support for OpenAI, Hugging Face, Ollama, and custom embedders
- **Retrievers**: BM25, dense vector, hybrid search with cross-encoders
- **Rankers**: Cross-encoder reranking for improved precision
- **LLM Support**: OpenAI, Anthropic, Hugging Face, Ollama, vLLM, and custom providers
- **Evaluation Tools**: Built-in evaluation for retrieval and generation quality
- **Production Ready**: Tested at enterprise scale with monitoring and observability

### Architecture Overview

Haystack follows a component-based architecture where each piece of the pipeline is a modular, swappable component:

```
Documents → Preprocessing → Embedding → Storage → Retrieval → Reranking → Generation
    │            │              │           │          │           │           │
    └── FileConverter ──┘   └── Embedder ─┘   └── Retriever ─┘   └── Generator ──┘
```

## Installation Guide

### Basic Installation

```bash
pip install haystack-ai
# For full features with all document converters
pip install "haystack-ai[docx,pdf]"
```

### Provider-Specific Installations

```bash
# OpenAI integration
pip install openai

# Hugging Face integration
pip install transformers sentence-transformers torch

# Elasticsearch document store
pip install elasticsearch

# Weaviate document store
pip install weaviate-client
```

### Verify Installation

```python
from haystack import Pipeline, Component

# Check version
import haystack
print(f"Haystack version: {haystack.__version__}")

# Create a simple pipeline
pipeline = Pipeline()
print("Pipeline created successfully!")
```

## Building Your First RAG Pipeline

### Step 1: Document Ingestion

Load and preprocess documents:

```python
from haystack import Pipeline, Document
from haystack.components.converters import TextFileToDocument
from haystack.components.preprocessors import DocumentCleaner, DocumentSplitter
from haystack.components.embedders import SentenceTransformersDocumentEmbedder

# Load documents from directory
converter = TextFileToDocument()
cleaner = DocumentCleaner()
splitter = DocumentSplitter(split_by="word", split_length=500, split_overlap=50)

# Process documents
result = converter.run(sources=["./documents/*.txt"])
documents = result["documents"]

# Clean and split
result = cleaner.run(documents=documents)
documents = result["documents"]

result = splitter.run(documents=documents)
documents = result["documents"]

print(f"Processed {len(documents)} document chunks")
```

### Step 2: Generate Embeddings

Convert text to vector embeddings:

```python
from haystack.components.embedders import SentenceTransformersDocumentEmbedder

# Use local embeddings (no API key needed)
embedder = SentenceTransformersDocumentEmbedder(
    model="sentence-transformers/all-MiniLM-L6-v2",
    progress_bar=True
)

# Add embeddings to documents
result = embedder.run(documents=documents)
documents_with_embeddings = result["documents"]

print(f"Embedded {len(documents_with_embeddings)} documents")
```

### Step 3: Store in Vector Database

```python
from haystack_integrations.document_stores.weaviate import WeaviateDocumentStore
from haystack.components.writers import DocumentWriter

# Connect to Weaviate
document_store = WeaviateDocumentStore(url="http://localhost:8080")

# Write documents to store
writer = DocumentWriter(document_store=document_store)
result = writer.run(documents=documents_with_embeddings)
print(f"Wrote {result['written']} documents to store")
```

### Step 4: Build Retrieval Pipeline

```python
from haystack_integrations.components.retrievers.weaviate import WeaviateEmbeddingRetriever
from haystack.components.builders import PromptBuilder
from haystack_integrations.components.generators.openai import OpenAIGenerator

# Define retrieval and generation components
retriever = WeaviateEmbeddingRetriever(document_store=document_store)

prompt_builder = PromptBuilder(template="""
    Context:
    {% for doc in documents %}
    {{ doc.content }}
    {% endfor %}
    
    Question: {{ question }}
    
    Answer based on the context above:
""")

generator = OpenAIGenerator(model="gpt-4o")

# Build the pipeline
rag_pipeline = Pipeline()
rag_pipeline.add_component("retriever", retriever)
rag_pipeline.add_component("prompt_builder", prompt_builder)
rag_pipeline.add_component("generator", generator)

# Connect components
rag_pipeline.connect("retriever.documents", "prompt_builder.documents")
rag_pipeline.connect("prompt_builder.prompt", "generator.prompt")
```

### Step 5: Query the Pipeline

```python
def ask_question(query: str, top_k: int = 5) -> str:
    result = rag_pipeline.run({
        "retriever": {"query": query, "top_k": top_k},
        "prompt_builder": {"question": query}
    })
    return result["generator"]["replies"][0]

answer = ask_question("What are the main features of Haystack?")
print(answer)
```

## Advanced Retrieval Strategies

### Hybrid Search (BM25 + Dense)

Combine keyword and semantic search for best results:

```python
from haystack_integrations.document_stores.elasticsearch import ElasticsearchDocumentStore
from haystack_integrations.components.retrievers.elasticsearch import ElasticsearchEmbeddingRetriever

# Elasticsearch supports hybrid search natively
document_store = ElasticsearchDocumentStore(
    hosts="http://localhost:9200",
    index="documents"
)

# Hybrid retriever combines BM25 and dense vectors
retriever = ElasticsearchEmbeddingRetriever(
    document_store=document_store,
    top_k=10,
    filters={"field_type": "dense"}
)
```

### Cross-Encoder Reranking

Improve retrieval precision with cross-encoder reranking:

```python
from haystack_integrations.components.rankers.transformers import TransformersRanker

# Rerank retrieved documents using a cross-encoder
ranker = TransformersRanker(
    model="cross-encoder/ms-marco-MiniLM-L-6-v2",
    top_k=5
)

# Integrate into pipeline
rag_pipeline.add_component("ranker", ranker)
rag_pipeline.connect("retriever.documents", "ranker.documents")
```

### Multi-Query Retrieval

Generate multiple queries for better coverage:

```python
from haystack.components.generators.chat import OpenAIChatGenerator
from haystack.components.builders import PromptBuilder

multi_query_prompt = PromptBuilder(template="""
    You are an AI assistant that generates search queries.
    Given the following question, generate 3 different search queries
    that could help find the answer.
    
    Question: {{ question }}
    
    Generate exactly 3 queries, one per line:
""")

multi_query_gen = OpenAIChatGenerator(model="gpt-4o-mini")

# Build multi-query pipeline
mq_pipeline = Pipeline()
mq_pipeline.add_component("prompt_builder", multi_query_prompt)
mq_pipeline.add_component("generator", multi_query_gen)
mq_pipeline.connect("prompt_builder.prompt", "generator.prompt")

# Get multiple queries
result = mq_pipeline.run({"prompt_builder": {"question": original_query}})
queries = result["generator"]["replies"][0].split("\n")[:3]

# Retrieve for each query
all_docs = []
for q in queries:
    docs = retriever.run(query=q.strip(), top_k=5)["documents"]
    all_docs.extend(docs)

# Deduplicate and rank
unique_docs = deduplicate_documents(all_docs)
```

## LLM Integration

### Supported LLM Providers

| Provider | Package | Models |
|----------|---------|--------|
| OpenAI | haystack-integrations-generators-openai | GPT-4o, GPT-4 Turbo, o1 |
| Anthropic | haystack-integrations-generators-anthropic | Claude 3.5 Sonnet, Haiku |
| Hugging Face | haystack-integrations-generators-hugging-face | Any HF model |
| Ollama | haystack-integrations-generators-ollama | Local models |
| vLLM | haystack-integrations-generators-vllm | High-throughput serving |
| Cohere | haystack-integrations-generators-cohere | Command R+, R |

### Using Ollama for Local LLMs

Run LLMs entirely locally with no API costs:

```python
from haystack_integrations.components.generators.ollama import OllamaGenerator

generator = OllamaGenerator(
    model="llama3.1:8b",
    url="http://localhost:11434",
    generation_kwargs={
        "temperature": 0.7,
        "num_ctx": 4096,
    }
)

# Generate response
result = generator.run(prompt="Explain RAG in simple terms")
print(result["replies"][0])
```

### Streaming Responses

Stream LLM responses in real-time:

```python
from haystack_integrations.components.generators.openai import OpenAIGenerator

generator = OpenAIGenerator(
    model="gpt-4o",
    streaming_callback=lambda chunk: print(chunk.data.choices[0].delta.content, end="")
)

result = generator.run(prompt="Write a detailed explanation of machine learning")
```

## Evaluation and Monitoring

### Retrieval Evaluation

Evaluate how well your retriever finds relevant documents:

```python
from haystack import Pipeline
from haystack.dataclasses import Document, GeneratedAnswer
from haystack_integrations.components.evaluators.ragas import RagasEvaluator

# Create evaluation pipeline
evaluator = RagasEvaluator(
    metrics=["faithfulness", "context_precision", "context_recall"],
    generator=OpenAIGenerator(model="gpt-4o"),
    embedder=SentenceTransformersDocumentEmbedder(
        model="sentence-transformers/all-MiniLM-L6-v2"
    )
)

# Evaluate on test dataset
results = evaluator.run(
    questions=test_questions,
    ground_truths=test_answers,
    contexts=retrieved_documents
)

print(f"Average faithfulness: {results['faithfulness']:.3f}")
print(f"Average context recall: {results['context_recall']:.3f}")
```

### Custom Evaluation Metrics

Build custom evaluation pipelines:

```python
from haystack import component

@component
class RelevanceChecker:
    @component.output_types(is_relevant=bool, confidence=float)
    def run(self, query: str, document: Document) -> dict:
        # Simple relevance scoring
        keywords = set(query.lower().split())
        doc_words = set(document.content.lower().split())
        
        overlap = keywords.intersection(doc_words)
        precision = len(overlap) / max(len(keywords), 1)
        recall = len(overlap) / max(len(doc_words), 1)
        
        return {
            "is_relevant": precision > 0.3,
            "confidence": (precision + recall) / 2
        }

# Use in pipeline
pipeline = Pipeline()
pipeline.add_component("checker", RelevanceChecker())
```

## Production Deployment

### Docker Deployment

```dockerfile
FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

requirements.txt:
```
haystack-ai
fastapi
uvicorn
openai
sentence-transformers
```

### FastAPI Integration

Build a REST API around your RAG pipeline:

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from haystack import Pipeline

app = FastAPI(title="RAG API")

# Load pipeline at startup
rag_pipeline = load_rag_pipeline()

class QueryRequest(BaseModel):
    question: str
    top_k: int = 5
    use_reranking: bool = True

class QueryResponse(BaseModel):
    answer: str
    sources: list
    confidence: float

@app.post("/query", response_model=QueryResponse)
async def query(request: QueryRequest):
    try:
        result = await rag_pipeline.ainvoke({
            "retriever": {"query": request.question, "top_k": request.top_k},
            "prompt_builder": {"question": request.question}
        })
        
        answer = result["generator"]["replies"][0]
        
        return QueryResponse(
            answer=answer,
            sources=result.get("sources", []),
            confidence=result.get("confidence", 0.0)
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```

### Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rag-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: rag
  template:
    spec:
      containers:
      - name: rag-api
        image: rag-service:latest
        ports:
        - containerPort: 8000
        resources:
          limits:
            cpu: "2"
            memory: "4Gi"
            nvidia.com/gpu: 1
        env:
        - name: OPENAI_API_KEY
          valueFrom:
            secretKeyRef:
              name: api-keys
              key: openai
        - name: WEAVIATE_URL
          valueFrom:
            secretKeyRef:
              name: weaviate
              key: url
```

## Comparison with Alternatives

| Feature | Haystack | LangChain | LlamaIndex | RAGFlow |
|---------|----------|-----------|------------|---------|
| Python Native | ✅ | ✅ | ✅ | Partial |
| Type Safety | Good | Limited | Moderate | Limited |
| Evaluation | Built-in | Manual | Manual | Basic |
| Multi-Document Store | 15+ | 20+ | 10+ | 5+ |
| Learning Curve | Easy | Steep | Moderate | Easy |
| Enterprise Features | ✅ | Partial | Partial | ✅ |
| Open Source | MIT | MIT | Apache 2.0 | Apache 2.0 |

### Document Preprocessing Pipeline

Efficient preprocessing is critical for RAG quality:

```python
from haystack.components.preprocessors import RecursiveDocumentSplitter
from haystack.components.preprocessors import DocumentCleaner
from haystack.components.extractors import NamedEntityExtractor

# Advanced document splitting
splitter = RecursiveDocumentSplitter(
    split_by="sentence",
    split_length=5,
    split_overlap=2,
    split_threshold=0.5
)

# Clean documents
cleaner = DocumentCleaner(
    lowercase=True,
    remove_empty_lines=True,
    remove_extra_whitespace=True,
    remove_repeated_substrings=True
)

# Extract entities for metadata enrichment
extractor = NamedEntityExtractor(
    device="cuda" if torch.cuda.is_available() else "cpu"
)

# Full preprocessing pipeline
preprocess_pipeline = Pipeline()
preprocess_pipeline.add_component("cleaner", cleaner)
preprocess_pipeline.add_component("splitter", splitter)
preprocess_pipeline.add_component("extractor", extractor)
preprocess_pipeline.connect("cleaner.documents", "splitter.documents")
preprocess_pipeline.connect("splitter.documents", "extractor.documents")

result = preprocess_pipeline.run({"cleaner": {"documents": raw_documents}})
processed_docs = result["extractor"]["documents"]
```

### Hybrid Search Implementation

Combine keyword and semantic search for best retrieval:

```python
from haystack_integrations.document_stores.elasticsearch import ElasticsearchDocumentStore
from haystack_integrations.components.retrievers.elasticsearch import ElasticsearchEmbeddingRetriever
from haystack_integrations.components.rankers.elasticsearch import ElasticsearchRanker

# Connect to Elasticsearch cluster
document_store = ElasticsearchDocumentStore(
    hosts="http://localhost:9200",
    index="rag_documents"
)

# Hybrid retriever combines BM25 + dense vectors
retriever = ElasticsearchEmbeddingRetriever(
    document_store=document_store,
    top_k=10,
    filters={"source_type": "pdf"},
    query_embedding=query_embedding,
    return_embedding=True
)

# Rank results with cross-encoder
ranker = ElasticsearchRanker(
    model="cross-encoder/ms-marco-MiniLM-L-6-v2",
    top_k=5
)

# Build hybrid pipeline
hybrid_pipeline = Pipeline()
hybrid_pipeline.add_component("retriever", retriever)
hybrid_pipeline.add_component("ranker", ranker)
hybrid_pipeline.connect("retriever.documents", "ranker.documents")

result = hybrid_pipeline.run({
    "retriever": {"query": user_question},
    "ranker": {"query": user_question}
})
```

### Multi-Tenant RAG Architecture

Support multiple users with isolated knowledge bases:

```python
from haystack import Pipeline, Document

class MultiTenantRAG:
    def __init__(self):
        self.tenant_pipelines = {}
        self.tenant_stores = {}
    
    def setup_tenant(self, tenant_id: str, document_store_url: str):
        """Initialize RAG pipeline for a tenant"""
        store = WeaviateDocumentStore(url=document_store_url)
        
        retriever = WeaviateEmbeddingRetriever(document_store=store)
        prompt_builder = PromptBuilder(template=self.template)
        generator = OpenAIGenerator(model="gpt-4o")
        
        pipeline = Pipeline()
        pipeline.add_component("retriever", retriever)
        pipeline.add_component("prompt_builder", prompt_builder)
        pipeline.add_component("generator", generator)
        pipeline.connect("retriever.documents", "prompt_builder.documents")
        pipeline.connect("prompt_builder.prompt", "generator.prompt")
        
        self.tenant_pipelines[tenant_id] = pipeline
        self.tenant_stores[tenant_id] = store
    
    async def query(self, tenant_id: str, question: str) -> dict:
        """Query tenant-specific RAG pipeline"""
        pipeline = self.tenant_pipelines.get(tenant_id)
        if not pipeline:
            raise ValueError(f"Tenant {tenant_id} not configured")
        
        result = await pipeline.arun({
            "retriever": {"query": question, "top_k": 5},
            "prompt_builder": {"question": question}
        })
        
        return {
            "answer": result["generator"]["replies"][0],
            "sources": len(result["retriever"]["documents"])
        }
```

### Embedding Model Selection Guide

Choosing the right embedding model impacts retrieval quality:

| Model | Dimensions | Max Tokens | mAP Score | Speed | Best For |
|-------|-----------|------------|-----------|-------|----------|
| all-MiniLM-L6-v2 | 384 | 256 | 42.3 | Fast | General purpose |
| all-mpnet-base-v2 | 768 | 512 | 58.7 | Medium | High accuracy |
| text-embedding-3-small | 1536 | 8191 | 61.2 | Fast | OpenAI API |
| text-embedding-3-large | 3072 | 8191 | 63.5 | Slow | Maximum accuracy |
| e5-mistral-7b-instruct | 4096 | 8192 | 65.1 | Slow | Research |

```python
# Benchmark embedding models
from sentence_transformers import SentenceTransformer
import numpy as np

def benchmark_model(model_name: str, test_queries: list, relevant_docs: list) -> float:
    model = SentenceTransformer(model_name)
    
    query_embeddings = model.encode(test_queries)
    doc_embeddings = model.encode(relevant_docs)
    
    # Compute recall@K
    scores = np.dot(query_embeddings, doc_embeddings.T)
    recalls = []
    for i, score_row in enumerate(scores):
        top_k_idx = np.argsort(score_row)[-5:]
        if i in top_k_idx:
            recalls.append(1.0)
        else:
            recalls.append(0.0)
    
    return np.mean(recalls)

# Compare models
models = [
    "all-MiniLM-L6-v2",
    "all-mpnet-base-v2",
    "text-embedding-3-small"
]

for model in models:
    recall = benchmark_model(model, queries, docs)
    print(f"{model}: Recall@5 = {recall:.3f}")
```

## Production Checklist

- [ ] Select appropriate embedding model for your use case
- [ ] Configure document chunking strategy based on content type
- [ ] Set up monitoring for retrieval quality metrics
- [ ] Implement caching for repeated queries
- [ ] Add rate limiting for API endpoints
- [ ] Configure fallback providers for reliability
- [ ] Set up logging for audit trails
- [ ] Test with production-quality input data
- [ ] Implement prompt injection detection
- [ ] Document resource requirements for each deployment


## FAQ

### Q1: How does Haystack compare to LangChain?

Haystack focuses specifically on RAG pipelines with a simpler, more opinionated approach. LangChain is more general-purpose but requires more boilerplate for RAG. Haystack has better built-in evaluation tools and cleaner abstractions for document processing.

### Q2: Can I use Haystack without any cloud APIs?

Yes, Haystack works entirely offline with local models. Use Ollama for LLMs, sentence-transformers for embeddings, and Elasticsearch or Chroma for document storage. No API keys required.

### Q3: What document formats does Haystack support?

Haystack supports PDF, DOCX, TXT, HTML, Markdown, CSV, JSON, images (with OCR), and email files through its converter components. Custom converters can be added for proprietary formats.

### Q4: How do I handle large document collections?

Use chunking strategies appropriate for your data size. For millions of documents, combine Elasticsearch with hybrid search and implement pagination. Consider using distributed document stores like Weaviate or Milvus for horizontal scaling.

### Q5: Is Haystack suitable for production use?

Yes, Haystack is used in production by many enterprises. It supports monitoring, logging, and can be deployed with standard containerization tools. The pipeline architecture makes it easy to add retries, caching, and rate limiting.

### Q6: How do I evaluate my RAG pipeline?

Use Haystack's built-in evaluators for retrieval quality (recall, precision) and generation quality (faithfulness, answer relevance). Run evaluations regularly as you modify your pipeline configuration.

### Q7: Can I customize the retrieval strategy?

Yes, Haystack supports BM25, dense vector, hybrid search, and cross-encoder reranking. You can combine multiple strategies and tune parameters like top_k, similarity thresholds, and filter conditions.

## Sources

- [Haystack Documentation](https://docs.haystack.deepset.ai/)
- [Haystack GitHub Repository](https://github.com/deepset-ai/haystack)
- [Deepset Blog](https://www.deepset.ai/blog)
- [Haystack Integrations](https://docs.haystack.deepset.ai/docs/integrations)

## Call to Action

Build production-ready RAG applications with Haystack. [Start building](https://dibi8.com/auth/) today with our deployment guides and pipeline templates.
