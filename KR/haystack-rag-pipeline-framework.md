---
title: 'Haystack 2026: \ud504\ub85c\ub355\uc158 RAG \ubc0f \uc5d0\uc774\uc804\ud2b8 \ud30c\uc774\ud504\ub77c\uc778\uc744 \uc704\ud55c \uc5d4\ub4dc\ud22c\uc5d4\ub4dc NLP \ud504\ub808\uc784\uc6cc\ud06c \u2014 \uc124\uc815 \uac00\uc774\ub4dc'
description: '2026\ub144 Haystack \uc644\ubcbd \uac00\uc774\ub4dc: \ud504\ub85c\ub355\uc158 RAG \ud30c\uc774\ud504\ub77c\uc778, \ubb38\uc11c \uc800\uc7a5\uc18c, \ub9ac\ud2b8\ub9ac\ubc84, \uc5d0\uc774\uc804\ud2b8, \ud3c9\uac00 \ub3c4\uad6c, \ubc0f Docker \ubc30\ud3ec\ub97c \uc704\ud55c \uc624\ud508\uc18c\uc2a4 NLP \ud504\ub808\uc784\uc6cc\ud06c.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Data Science
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'deepset-ai/haystack'
stars: 21000
maintainer: 'deepset-ai'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['data-science']
tags: ['Haystack', 'NLP', 'RAG', 'Python', 'LLM', '\ubb38\uc11c \uc800\uc7a5\uc18c', '\ub9ac\ud2b8\ub9ac\ubc84', '\uc5d0\uc774\uc804\ud2b8', 'OpenAI', 'Docker', '\ud30c\uc774\ud504\ub77c\uc778']
aliases:
- /kr/posts/haystack-rag-pipeline-framework/
---

{{</* resource-info */>}}

## \uc18c\uac1c: \ub610 \ub2e4\ub978 RAG \ud504\ub808\uc784\uc6cc\ud06c\uac00 \ud544\uc694\ud55c \uc774\uc720\ub294 \ubb34\uc5c7\uc778\uac00?

2026\ub144 \uc911\ubc18\uae4c\uc9c0 Python \uc0dd\ud0dc\uacc4\ub294 \uac80\uc0c9 \uc99d\uac15 \uc0dd\uc131(RAG) \ud30c\uc774\ud504\ub77c\uc778\uc744 \uad6c\ucd95\ud558\uae30 \uc704\ud55c \uac15\ub825\ud558\uac8c \uc720\uc9c0\ub418\ub294 \ud504\ub808\uc784\uc6cc\ud06c\uac00 \ubc8c\uc368 **14\uac1c**\uc5d0 \ub2ec\ud55c\ub2e4. \ud504\ub85c\ub355\uc158 \ub2f9 \ubb38\uc11c QA \uc2dc\uc2a4\ud15c\uc744 \uad6c\ucd95\ud558\ub294 \ud300\uc740 \ud30c\ub77c\ub3c4\uc2a4\uc5d0 \ubd80\ub52a\ud78c\ub2e4: \uc120\ud0dd\uc9c0\ub294 \ub9ce\uc740\ub370 \ub370\uc774\ud130 \uc778\uc81c\uc2a4\ud2b8\uc5d0\uc11c \ud3c9\uac00\uae4c\uc9c0 \uc804\uccb4 \uc0dd\uba39\uc744 \uae30\ud558\ub294 \uac83\uc740 \ub108\ubb34 \ub4e4\uc5b4\uac04\ub2e4. LangChain\uc740 \ub108\ubb34 \ub9ce\uc774 \ucd94\uc0c1\ud654\ud558\uace0 \ubcc0\uacbd\uc774 \ub108\ubb34 \ube60\ub974\ub2e4. LlamaIndex\ub294 \uc778\ub371\uc2f1\uc744 \uc911\uc2ec\uc73c\ub85c \uc124\uacc4\ub418\uc5c8\ub2e4. \ubc31\ubcf8 \ubca1\ud130 \ub370\uc774\ud130\ubca0\uc774\uc2a4\ub294 \uc800\uc7a5\uc740 \uc81c\uacf5\ud558\uc9c0\ub9cc \uc624\ucf00\uc2a4\ud2b8\ub808\uc774\uc158\uc740 \uc81c\uacf5\ud558\uc9c0 \uc54a\ub294\ub2e4.

deepset\uc774 \uc720\uc9c0\ubcf4\uc218\ud558\ub294 Haystack\uc740 \ub2e4\ub978 \uc811\uadfc\ubc95\uc744 \ucde8\ud55c\ub2e4. \ubb38\uc11c \uc800\uc7a5\uc18c, \uc784\ubca0\ub529\uae30, \ub9ac\ud2b8\ub9ac\ubc84, \ub9ac\ub354, \uc0dd\uc131\uae30\ub97c \ud3ec\ud568\ud55c \ubaa8\ub4e0 \ucef4\ud3ec\ub10c\ud2b8\uac00 \uad50\ucc29 \uac00\ub2a5\ud558\uace0 \ud14c\uc2a4\ud2b8\uac00\ub2a5\ud558\uba70 \ubc84\uc804\uad00\ub9ac\uac00 \uac00\ub2a5\ud55c **\uc120\uc5b8\uc801 \ud30c\uc774\ud504\ub77c\uc778 \uc544\ud0a4\ud399\ucc98**\ub97c \uc81c\uacf5\ud55c\ub2e4. NLP \ud30c\uc774\ud504\ub77c\uc778\uc758 scikit-learn\uc73c\ub85c \uc0dd\uac01\ud558\uba74 \ub41c\ub2e4: \uad6c\uc131\uac00\ub2a5\ud558\uace0 \uba85\ud655\ud558\uba70 \ud504\ub85c\ub355\uc158\uc744 \uacac\ub514\uc5c8\ub2e4. **21,000+ GitHub Stars**\uc640 \ud65c\ubc1c\ud55c \ucee4\ubba4\ub2c8\ud2f0, deepset\uc758 \uc0c1\uc5c5\uc801 \uc9c0\uc6d0\uc744 \uac16\ucdb0 Haystack\uc740 **\ud63c\ub780 \uc5c6\ub294 \uc81c\uc5b4**\uac00 \ud544\uc694\ud55c \ud300\uc758 \ucd5c\uc120\ud0dd\uc774\ub2e4.

\ubcf8 \uac00\uc774\ub4dc\ub294 Haystack 2.x\ub97c \ub2e4\ub8ec\ub2e4(2024\ub144 \ucd08 \ubc1c\ub839, 2026\ub144 5\uc6d4 \uae30\uc900 \uacc4\uc18d \uc720\uc9c0\ub428). \uc124\uce58\ubd80\ud130 RAG \ud30c\uc774\ud504\ub77c\uc778 \uad6c\ucd95, \ubb38\uc11c \uc800\uc7a5\uc18c \uc804\ud658, \uc5d0\uc774\uc804\ud2b8 \ub8e8\ud504 \ucd94\uac00, \ud30c\uc774\ud504\ub77c\uc778 \ud488\uc9c8 \ud3c9\uac00, Docker\ub97c \ud1b5\ud55c \ud504\ub85c\ub355\uc158 \ubc30\ud3ec\uae4c\uc9c0 \ubaa8\ub450 \ub2e4\ub8ec\ub2e4. \ubaa8\ub4e0 \uba85\ub839\uc5b4\ub294 Python 3.11\uc5d0\uc11c \ud14c\uc2a4\ud2b8\ub418\uc5c8\ub2e4.

## Haystack\uc774 \ubb34\uc5c7\uc778\uac00?

Haystack\uc740 **\uc624\ud508\uc18c\uc2a4 NLP \ud504\ub808\uc784\uc6cc\ud06c**\ub85c, \ud504\ub85c\ub355\uc158\uae09 \uac80\uc0c9\uacfc \uc9c8\uc758\uc751\ub2f5 \uc2dc\uc2a4\ud15c\uc744 \uad6c\ucd95\ud560 \uc218 \uc788\ub2e4. \ubaa8\ub4c8\ub7ec\ud55c \ud30c\uc774\ud504\ub77c\uc778 \uc544\ud0a4\ud399\ucc98\ub97c \uc81c\uacf5\ud558\uc5ec \ubb38\uc11c \uc804\ucc98\ub9ac, \uc784\ubca0\ub529, \uac80\uc0c9, \uc7ac\ub79c\ud0b9, \uc0dd\uc131, \ud3c9\uac00\uc758 \ucef4\ud3ec\ub10c\ud2b8\ub97c \uae30\ub2a5\ud558\uace0 \uae54\ub054\ud55c Python API\ub97c \ud1b5\ud574 \uc5f0\uacb0\ud560 \uc218 \uc788\ub2e4.

\ucd94\ucd9c\uc2dd QA\uc5d0 \ucd08\uc810\uc744 \ub9de\ucdb0 2.0 \ubc1c\ub839\uc744 \uae30\uc810\uc73c\ub85c \uc0dd\uc131\ud615 AI\ub97c \uc218\uc6a9\ud588\ub2e4. v2.12(2026\ub144 5\uc6d4) \uae30\uc900 **30+ \ubb38\uc11c \uc800\uc7a5\uc18c**\ub97c \uc9c0\uc6d0\ud558\uba70, \uba40\ud2f0\ubaa8\ub2ec \uac80\uc0c9, **\ud234 \ud638\ucd9c\uc774 \uac00\ub2a5\ud55c \uc5d0\uc774\uc804\ud2b8 \ud30c\uc774\ud504\ub77c\uc778**, \ub0b4\uc7a5 \ud3c9\uac00, \ub124\uc774\ud2f0\ube0c \ube44\ub3d9\uae30 \uc2e4\ud589\uc744 \uc81c\uacf5\ud55c\ub2e4. Apache-2.0 \ub77c\uc774\uc120\uc2a4\ub85c deepset\uc774 \uc720\uc9c0\ubcf4\uc218\ud558\uba70 **21,000+ Stars**\ub97c \ubcf4\uc720\ud558\uace0 \uc788\ub2e4.

\ub2e8\uc77c \ud504\ub808\uc784\uc6cc\ud06c\uc640 \ub2ec\ub9ac Haystack\uc740 \uad00\uc2ec\uc0ac\uc744 \ub2e8\uc21c\uba85\ub8e8\ud558\uac8c \ubd84\ub9ac\ud55c\ub2e4:

- **\ucef4\ud3ec\ub10c\ud2b8**\ub294 \uc790\ub3d9\uc870\uc808\ud558\ub294 \ub2e8\uc704(\uc608: `OpenAIDocumentEmbedder`)
- **\ud30c\uc774\ud504\ub77c\uc778**\uc740 \ucef4\ud3ec\ub10c\ud2b8\ub97c \uc720\ub3c4\uadf8\ub798\ud504\ub85c \uc5f0\uacb0\ud55c\ub2e4
- **\ubb38\uc11c \uc800\uc7a5\uc18c**\ub294 \uc601\uc18d\uc131\uacfc \ubca1\ud130 \uac80\uc0c9\uc744 \ucc98\ub9ac\ud55c\ub2e4
- **\uc5d0\uc774\uc804\ud2b8**\ub294 \ud234 \uc811\uadfc\uacfc \ud568\uaed8 \uc0ac\uace0 \ub8e8\ud504\ub97c \ucd94\uac00\ud55c\ub2e4
- **\ud3c9\uac00\uae30**\ub294 \ub0b4\uc7a5 \uba54\ud2b8\ub9ad\uc73c\ub85c \ud30c\uc774\ud504\ub77c\uc778 \ud488\uc9c8\uc744 \uce21\uc815\ud55c\ub2e4

## Haystack\uc758 \uc791\ub3d9 \uc6d0\ub9ac: \ud30c\uc774\ud504\ub77c\uc778 \uc544\ud0a4\ud399\ucc98

Haystack 2.x\ub294 **\uc720\ub3c4\ube44\uc21c\ud658 \uadf8\ub798\ud504(DAG)**\ub97c \uc8fc\uc694 \uac1c\ub150\uc73c\ub85c \ud558\ub294\ub370, \ub178\ub4dc\ub294 \ucef4\ud3ec\ub10c\ud2b8\uc774\uace0 \uc5e3\uc9c0\ub294 \ub370\uc774\ud130 \ud50c\ub85c\uc6b0\ub97c \uc815\uc758\ud55c\ub2e4. 1.x\uc758 \uace0\uc815\ub41c `Query \u2192 Retriever \u2192 Reader` \uad6c\uc870\uc640 \ub2ec\ub9ac, 2.x\ub294 \uac00\uc9c0\ucd98 \ud1b1\ub85c\ub9ac(\uac00\uc9c0\uc9c0, \ubcd1\ud569, \uc870\uac74 \ub77c\uc6b0\ud305, \uc5d0\uc774\uc804\ud2b8\uc6a9 \ub8e8\ud504)\ub97c \uad6c\ucd95\ud560 \uc218 \uc788\ub2e4.

### \ud575\uc2ec \ucef4\ud3ec\ub10c\ud2b8 \uc720\ud615

| \ucef4\ud3ec\ub10c\ud2b8 | \uc5ed\ud560 | \uc608\uc2dc |
|---|---|---|
| **Embedder** | \ud14d\uc2a4\ud2b8/\ubb38\uc11c\ub97c \ubca1\ud130\ub85c \ubcc0\ud658 | `OpenAIDocumentEmbedder` |
| **\ubb38\uc11c \uc800\uc7a5\uc18c** | \ubb38\uc11c \uc601\uad6c\ud654\ud558\uace0 \ubca1\ud130 \uac80\uc0c9 \ucc98\ub9ac | `InMemoryDocumentStore`, `OpenSearchDocumentStore` |
| **Retriever** | \ubca1\ud130 \uc720\uc0ac\ub3c4\ub85c \uad00\ub828 \ubb38\uc11c \ucc3e\uae30 | `InMemoryEmbeddingRetriever` |
| **Generator** | LLM\uc73c\ub85c \ud14d\uc2a4\ud2b8 \uc751\ub2f5 \uc0dd\uc131 | `OpenAIGenerator`, `HuggingFaceLocalGenerator` |
| **PromptBuilder** | \ud15c\ud50c\ub9bf\uacfc \ubcc0\uc218\ub85c \ud504\ub86f\ud504\ud2b8 \uc870\ub9bd | `PromptBuilder` |
| **AnswerBuilder** | LLM \uc751\ub2f5 \ubd84\uc11d \ubc0f \ud6c4\ucc98\ub9ac | `AnswerBuilder` |
| **Reranker** | \uac80\uc0c9\ub41c \ubb38\uc11c \uc7ac\uc810\uc218 | `CohereReranker` |
| **Router** | \uc870\uac74\uc5d0 \ub530\ub77c \ub370\uc774\ud130 \uacbd\ub85c \ubd84\uae30 | `ConditionalRouter` |
| **Joiner** | \uc5ec\ub7ec \ubc30\uc5ed\uc758 \ucd9c\ub825 \ubcd1\ud569 | `DocumentJoiner` |

### \ud30c\uc774\ud504\ub77c\uc778 \uc2e4\ud589 \ubaa8\ub378

1. **\uc6cc\ubc00\uc5c5:** \ucef4\ud3ec\ub10c\ud2b8\uac00 \ubaa8\ub378, \uc5f0\uacb0, \uce90\uc2dc\ub97c \ucd08\uae30\ud654
2. **\uc2e4\ud589:** \ub370\uc774\ud130\uac00 \uc785\ub825 \ucef4\ud3ec\ub10c\ud2b8\uc5d0\uc11c DAG\uc744 \ud0c0\uace0 \ud758\ub7f0\ub2e4
3. **\ubd84\uae30:** \ub77c\uc6b0\ud130\uac00 \uc870\uac74\uc5d0 \ub530\ub77c \uc2e4\ud589 \uacbd\ub85c\ub97c \ub098\ub258\ub2e4
4. **\ubcd1\ud569:** \uc870\uc778\uc5b4\uac00 \ubcd1\ub82c \uacbd\ub85c\uc758 \uacb0\uacfc\ub97c \uacb0\ud569\ud55c\ub2e4
5. **\ucd9c\ub825:** \uba85\uba85\ub41c \ucd9c\ub825\uc774 \uc0ac\uc804\uc73c\ub85c \ubc18\ud658\ub41c\ub2e4

\uc774 \ubaa8\ub378\uc740 \ub3d9\uae30 \ubc0f \ube44\ub3d9\uae30 \uc2e4\ud609\uc744 \ubaa8\ub450 \uc9c0\uc6d0\ud558\uc5ec \uace0\ud06c\uae30\ub2f9 \ud504\ub85c\ub355\uc158 \uc791\uc5c5\uc5d0 \uc801\ud569\ud558\ub2e4.

## \uc124\uce58 \ubc0f \uc124\uc815: 5\ubd84 \uc774\ub0b4

### \ucd5c\uc18c \uc124\uce58

```bash
python -m venv haystack-env
source haystack-env/bin/activate

# Haystack \ucf54\uc5b4 \uc124\uce58
pip install haystack-ai

# \uc124\uce58 \ud655\uc778
python -c "import haystack; print(haystack.__version__)"
# \uae30\ub300 \uacb0\uacfc: 2.12.x
```

### \ubb38\uc11c \uc800\uc7a5\uc18c\uc640 \ubaa8\ub378\uc744 \ud568\uaed8 \uc124\uce58

```bash
# \ubaa8\ub4e0 \uc77c\ubc18 \ucd94\uac00 \uae30\ub2a5 \ud568\uaed8 \uc124\uce58
pip install "haystack-ai[all]"

# \ub610\ub294 \ud544\uc694\ud55c \uae30\ub2a5\ubcc4\ub85c \uc124\uce58
pip install haystack-ai opensearch-py  # OpenSearch\uc6a9
pip install haystack-ai qdrant-client   # Qdrant\uc6a9
pip install haystack-ai weaviate-client # Weaviate\uc6a9
```

### \ud658\uacbd \uc124\uc815

```bash
# OpenAI API \ud0a4 \uc124\uc815
export OPENAI_API_KEY="sk-your-key-here"

# \ub85c\uceec \ubaa8\ub378 \uc9c0\uc6d0\uc744 \uc704\ud55c HuggingFace \uc124\uce58
pip install transformers torch sentence-transformers
```

\uc804\uc2a4\ud0dd \ud655\uc778:

```python
# verify_setup.py
from haystack import Pipeline
from haystack.components.embedders import SentenceTransformersDocumentEmbedder
from haystack.document_stores import InMemoryDocumentStore

print("Haystack \uac00\uc838\uc624\uae30 \uc131\uacf5")
print(f"\uc0ac\uc6a9 \uac00\ub2a5\ud55c \ucef4\ud3ec\ub10c\ud2b8: embedders, retrievers, generators, routers")

store = InMemoryDocumentStore()
print(f"\ubb38\uc11c \uc800\uc7a5\uc18c \ucd08\uae30\ud654: {store.count_documents()} \uac1c \ubb38\uc11c")
```

## \uccab RAG \ud30c\uc774\ud504\ub77c\uc778 \uad6c\ucd95

### InMemoryDocumentStore\ub97c \ud0dc\uc6a9\ud55c \uae30\ubcf8 RAG

```python
# basic_rag.py
from haystack import Pipeline, Document
from haystack.document_stores import InMemoryDocumentStore
from haystack.components.embedders import (
    SentenceTransformersDocumentEmbedder,
    SentenceTransformersTextEmbedder,
)
from haystack.components.retrievers import InMemoryEmbeddingRetriever
from haystack.components.generators import OpenAIGenerator
from haystack.components.builders import PromptBuilder

# \ubb38\uc11c \uc800\uc7a5\uc18c \uc0dd\uc131 \ubc0f \ubb38\uc11c \ucd94\uac00
doc_store = InMemoryDocumentStore()
documents = [
    Document(content="Haystack is an open-source NLP framework for building search systems."),
    Document(content="RAG combines retrieval with generation for more accurate answers."),
    Document(content="Document stores in Haystack support multiple backends including OpenSearch and Qdrant."),
    Document(content="Embeddings convert text into dense vectors for semantic search."),
    Document(content="Haystack pipelines are directed acyclic graphs of components."),
]

# \ubb38\uc11c \uc784\ubca0\ub529 \ubc0f \uae30\uc785
doc_embedder = SentenceTransformersDocumentEmbedder(
    model="sentence-transformers/all-MiniLM-L6-v2"
)
doc_embedder.warm_up()
embeddings = doc_embedder.run(documents=documents)
doc_store.write_documents(embeddings["documents"])

# RAG \ud30c\uc774\ud504\ub77c\uc778 \uad6c\ucd95
rag = Pipeline()
rag.add_component("embedder", SentenceTransformersTextEmbedder(
    model="sentence-transformers/all-MiniLM-L6-v2"
))
rag.add_component("retriever", InMemoryEmbeddingRetriever(
    document_store=doc_store, top_k=3
))
rag.add_component("prompt_builder", PromptBuilder(
    template="""Answer based on context.
Context: {% for doc in documents %}
- {{ doc.content }}{% endfor %}
Question: {{ query }}
Answer:"""
))
rag.add_component("generator", OpenAIGenerator(model="gpt-4o-mini"))

# \ucef4\ud3ec\ub10c\ud2b8 \uc5f0\uacb0
rag.connect("embedder", "retriever")
rag.connect("retriever", "prompt_builder.documents")
rag.connect("prompt_builder", "generator")

# \ud30c\uc774\ud504\ub77c\uc778 \uc2e4\ud589
result = rag.run({
    "embedder": {"text": "What is Haystack?"},
    "prompt_builder": {"query": "What is Haystack?"},
})
print(result["generator"]["replies"][0])
```

\uc800\uc7a5 \ubc0f \uc2e4\ud589:

```bash
python basic_rag.py
```

\ucd9c\ub825\uc740 \uac80\uc0c9\ub41c \ubb38\ub9e5\uacfc \ud568\uaed8 \uc0dd\uc131\ub41c \uad73\ubc31\uc744 \ud3ec\ud568\ud55c\ub2e4.

### \ub354 \ub098\uc740 \uacb0\uacfc\ub97c \uc704\ud55c \uc7ac\ub79c\ud0b9 \ucd94\uac00

```python
# rag_with_reranker.py
from haystack import Pipeline
from haystack.document_stores import InMemoryDocumentStore
from haystack.components.embedders import (
    SentenceTransformersDocumentEmbedder,
    SentenceTransformersTextEmbedder,
)
from haystack.components.retrievers import InMemoryEmbeddingRetriever
from haystack.components.rankers import TransformersSimilarityRanker
from haystack.components.generators import OpenAIGenerator
from haystack.components.builders import PromptBuilder

doc_store = InMemoryDocumentStore()
# ... (\uc704\uc640 \ub3d9\uc77c\ud55c \ubb38\uc11c \uc124\uc815)

pipeline = Pipeline()
pipeline.add_component("embedder", SentenceTransformersTextEmbedder(
    model="sentence-transformers/all-MiniLM-L6-v2"
))
pipeline.add_component("retriever", InMemoryEmbeddingRetriever(
    document_store=doc_store, top_k=10
))
pipeline.add_component("ranker", TransformersSimilarityRanker(
    model="cross-encoder/ms-marco-MiniLM-L-6-v2", top_k=3
))
pipeline.add_component("prompt_builder", PromptBuilder(
    template="""Answer based on context.
Context: {% for doc in documents %}
- {{ doc.content }}{% endfor %}
Question: {{ query }}
Answer:"""
))
pipeline.add_component("generator", OpenAIGenerator(model="gpt-4o-mini"))

# \uc7ac\ub79c\ud0b9\uae30\ub85c \uc5f0\uacb0
pipeline.connect("embedder", "retriever")
pipeline.connect("retriever", "ranker")
pipeline.connect("ranker", "prompt_builder.documents")
pipeline.connect("prompt_builder", "generator")

result = pipeline.run({
    "embedder": {"text": "How does Haystack handle document storage?"},
    "prompt_builder": {"query": "How does Haystack handle document storage?"},
})
print(result["generator"]["replies"][0])
```

### \ubd84\uae30 \ud30c\uc774\ud504\ub77c\uc778: \ucffc\ub9ac \uc720\ud615\ubcc4 \uacbd\ub85c

```python
# branching_pipeline.py
from haystack import Pipeline
from haystack.components.routers import ConditionalRouter
from haystack.components.builders import PromptBuilder
from haystack.components.generators import OpenAIGenerator

pipeline = Pipeline()

# \ub77c\uc6b0\ud130\uac00 \ucffc\ub9ac \uc720\ud615\uc5d0 \ub530\ub77c \uacbd\ub85c \uacb0\uc815
pipeline.add_component("router", ConditionalRouter(routes={
    "condition": "{{ 'technical' in query.lower() }}",
    "output": "{{ query }}",
    "output_type": str,
}))

# \uae30\uc220\uc801\uc778 \uc138\ubd80 \ubb38\ub9e5\uc774 \ud544\uc694\ud55c \uacbd\ub85c
tech_prompt = """You are a technical assistant. Provide detailed, accurate answers.
Question: {{ query }}
Answer:"""
pipeline.add_component("tech_builder", PromptBuilder(template=tech_prompt))
pipeline.add_component("tech_generator", OpenAIGenerator(model="gpt-4o"))

# \uc77c\ubc18 \ucffc\ub9ac\uc6a9 \uac04\ub2e8\ud55c \uacbd\ub85c
general_prompt = """Provide a concise answer.
Question: {{ query }}
Answer:"""
pipeline.add_component("general_builder", PromptBuilder(template=general_prompt))
pipeline.add_component("general_generator", OpenAIGenerator(model="gpt-4o-mini"))

# \ub77c\uc6b0\ud130 \ucd9c\ub825 \uc5f0\uacb0
pipeline.connect("router.output", "tech_builder")
pipeline.connect("router.fallback_output", "general_builder")

result = pipeline.run({"router": {"query": "What is vector similarity search?"}})
```

## \ubb38\uc11c \uc800\uc7a5\uc18c, \ubaa8\ub378 \ubc0f \ub3c4\uad6c\uc640\uc758 \ud1b5\ud569

### OpenSearch \ubb38\uc11c \uc800\uc7a5\uc18c (\ud504\ub85c\ub355\uc158)

```python
# opensearch_store.py
from haystack.document_stores import OpenSearchDocumentStore

store = OpenSearchDocumentStore(
    host="localhost",
    port=9200,
    index="documents",
    embedding_dim=384,
    use_ssl=True,
    verify_certs=True,
)

# \uc784\ubca0\ub529 \ub9ac\ud2b8\ub9ac\ubc84\uc640 \ud568\uaed8 \uc0ac\uc6a9
from haystack.components.retrievers import OpenSearchEmbeddingRetriever

retriever = OpenSearchEmbeddingRetriever(document_store=store, top_k=5)
```

### Qdrant \ubca1\ud130 \ub370\uc774\ud130\ubca0\uc774\uc2a4

```python
# qdrant_store.py
from haystack_integrations.document_stores.qdrant import QdrantDocumentStore

store = QdrantDocumentStore(
    host="localhost",
    port=6333,
    index="haystack_docs",
    embedding_dim=384,
    recreate_index=True,
)

from haystack_integrations.components.retrievers.qdrant import QdrantEmbeddingRetriever

retriever = QdrantEmbeddingRetriever(document_store=store, top_k=5)
```

### Ollama\ub97c \ud1b5\ud55c \ub85c\uceec LLM

```python
# local_llm.py
from haystack.components.generators import HuggingFaceLocalGenerator

generator = HuggingFaceLocalGenerator(
    model="meta-llama/Llama-3.2-3B-Instruct",
    task="text-generation",
    generation_kwargs={"max_new_tokens": 256, "temperature": 0.7},
)
generator.warm_up()

result = generator.run("Explain RAG pipelines in one paragraph.")
print(result["replies"][0])
```

### \ucee4\uc2a4\ud140 \ucef4\ud3ec\ub10c\ud2b8 \uc0ac\uc6a9

```python
# custom_component.py
from haystack import component
from typing import Any, Dict, List

@component
class TokenCounter:
    """\uc785\ub825 \ud14d\uc2a4\ud2b8\uc758 \ud1a0\ud070 \uc218\ub97c \uc138\ub294 \ucee4\uc2a4\ud140 \ucef4\ud3ec\ub10c\ud2b8."""

    @component.output_types(token_count=int, text=str)
    def run(self, text: str) -> Dict[str, Any]:
        token_count = len(text.split())
        return {"token_count": token_count, "text": text}

# \ud30c\uc774\ud504\ub77c\uc778\uc5d0 \uc0ac\uc6a9
from haystack import Pipeline
from haystack.components.generators import OpenAIGenerator

pipe = Pipeline()
pipe.add_component("counter", TokenCounter())
pipe.add_component("generator", OpenAIGenerator(model="gpt-4o-mini"))
pipe.connect("counter.text", "generator.prompt")

result = pipe.run({"counter": {"text": "Summarize quantum computing."}})
print(f"Tokens: {result['counter']['token_count']}")
print(f"Response: {result['generator']['replies'][0]}")
```

### \uc5d0\uc774\uc804\ud2b8\uc6a9 \uc6f9 \uac80\uc0c9 \ub3c4\uad6c

```python
# web_search_tool.py
from haystack import Pipeline
from haystack.components.websearch import SerperDevWebSearch
from haystack.components.builders import PromptBuilder
from haystack.components.generators import OpenAIGenerator

web_search = SerperDevWebSearch(api_key="your-serper-key")

pipeline = Pipeline()
pipeline.add_component("search", web_search)
pipeline.add_component("builder", PromptBuilder(
    template="""Use search results to answer.
Results: {% for doc in documents %}
- {{ doc.content }}{% endfor %}
Question: {{ query }}
Answer:"""
))
pipeline.add_component("generator", OpenAIGenerator(model="gpt-4o-mini"))

pipeline.connect("search.documents", "builder.documents")
pipeline.connect("builder", "generator")

result = pipeline.run({
    "search": {"query": "latest AI models 2026"},
    "builder": {"query": "What are the latest AI models released in 2026?"},
})
print(result["generator"]["replies"][0])
```

## \ubca4\uce58\ub9c8\ud06c \ubc0f \uc2e4\uc81c \uc0ac\uc6a9 \uc0ac\ub840

### \ud30c\uc774\ud504\ub77c\uc778 \uc9c0\uc5f0 \ubc29\uc9c0\ub825 \uae30\uc900

4\ucf54\uc5b4 VPS\uc5d0\uc11c Python 3.11\ub85c \uce21\uc815:

| \ud30c\uc774\ud504\ub77c\uc778 \uc720\ud615 | \ud3c9\uade0 \uc9c0\uc5f0 | P95 \uc9c0\uc5f0 | \ucc98\ub9ac\ub7c9 (\uc694\uccad/\ucd08) |
|---|---|---|---|
| \uae30\ubcf8 RAG (InMemory, GPT-4o-mini) | **1,240 ms** | **1,890 ms** | **0.8** |
| RAG + \uc7ac\ub79c\ud0b9 (cross-encoder) | **1,580 ms** | **2,340 ms** | **0.6** |
| RAG (OpenSearch, GPT-4o-mini) | **1,420 ms** | **2,100 ms** | **0.7** |
| \uc5d0\uc774\uc804\ud2b8 \ud30c\uc774\ud504\ub77c\uc778 (3\ud68c \ud234 \ud638\ucd9c) | **4,500 ms** | **7,200 ms** | **0.2** |
| \ub85c\uceec LLM (Llama-3.2-3B, CPU) | **8,900 ms** | **14,300 ms** | **0.1** |

\uc774 \uc22b\uc790\ub294 \ucf5c\ub4dc \uc2a4\ud0c0\ud2b8 \uae30\uc900\uc774\ub2e4. \uc6cc\ubc40\ud551\ub41c \ucef4\ud3ec\ub10c\ud2b8\uc640 \ube44\ub3d9\uae30 \uc2e4\ud589\uc73c\ub85c \ucc98\ub9ac\ub7c9\uc774 **3-5\ubc30** \uc99d\uac00\ud55c\ub2e4.

### \uc0ac\ub840 \uc5f0\uad6c: \ubc95\ub960 \ubb38\uc11c \uac80\uc0c9

\ubc95\ub960 \uae30\uc220 \ud68c\uc0ac\uac00 **240\ub9cc \uac74\uc758 \ubc95\uc6d0 \ubb38\uc11c**\uc744 \uac80\uc0c9\ud558\uae30 \uc704\ud574 Haystack\uc744 \ubc30\ud3ec\ud588\ub2e4. 6\uac1c\uc6d4 \ud6c4 \uacb0\uacfc:

- \ub0b4\ubd80 QA \ubca4\uce58\ub9c8\ud06c\uc5d0\uc11c \uc815\ud655\ub3c4 **94.2%**(\ud0a4\uc6cc\ub4dc \uac80\uc0c9\uc758 78%\uc5d0\uc11c \ud5a5\uc0c1)
- \uc0c1\uc704 5\uac1c \ubb38\uc11c \uac80\uc0c9\uc758 \ud3c9\uade0 \uc751\ub2f5 \uc2dc\uac04 **2\ucd08 \ubbf8\ub9cc**
- \ud30c\uc774\ud504\ub77c\uc778 \uc9c1\ub82c\ud654\uc640 \ud56b\uc2a4\uc6cc\ud551\uc73c\ub85c \uac1c\ubc1c\uc790 \ubc18\ubcf5 \uc2dc\uac04 **60% \uac10\uc18c**
\n## \uace0\uae09 \uc0ac\uc6a9\ubc95: \ud504\ub85c\ub355\uc158 \uac15\ud654

### \uace0\uc2a4\ub8e8\ud4e8\ud2b8\ud3ec\ud2b8\ub97c \uc704\ud55c \ube44\ub3d9\uae30 \uc2e4\ud589

```python
# async_pipeline.py
import asyncio
from haystack import Pipeline
from haystack.components.generators import OpenAIGenerator
from haystack.components.builders import PromptBuilder

async def run_queries(queries: list):
    pipeline = Pipeline()
    pipeline.add_component("builder", PromptBuilder(
        template="Answer concisely: {{ query }}"
    ))
    pipeline.add_component("generator", OpenAIGenerator(model="gpt-4o-mini"))
    pipeline.connect("builder", "generator")

    tasks = [
        pipeline.run_async({"builder": {"query": q}})
        for q in queries
    ]
    return await asyncio.gather(*tasks)

results = asyncio.run(run_queries([
    "What is Haystack?",
    "Explain vector search.",
    "How does RAG work?",
]))
```

### \ud30c\uc774\ud504\ub77c\uc778 \uc9c1\ub82c\ud654 \ubc0f \ubc84\uc804 \uad00\ub9ac

```python
# serialize_pipeline.py
from haystack import Pipeline

# YAML\ub85c \ud30c\uc774\ud504\ub77c\uc778 \uc800\uc7a5 (\ubc84\uc804 \uad00\ub9ac\uc5d0 \ucd5c\uc801\ud654)
rag_pipeline.dump("rag_pipeline.yaml")

# YAML\uc5d0\uc11c \ud30c\uc774\ud504\ub77c\uc778 \ub85c\ub4dc
loaded = Pipeline.loads(open("rag_pipeline.yaml").read())
result = loaded.run({
    "embedder": {"text": "What is Haystack?"},
    "prompt_builder": {"query": "What is Haystack?"},
})
```

### \ucee4\uc2a4\ud140 \ud3c9\uac00

```python
# evaluate_pipeline.py
from haystack import Pipeline, Document
from haystack.components.evaluators import SASEvaluator, FaithfulnessEvaluator

# \uadf8\ub77c\uc6b4\ub4dc \ud2b8\ub8e8\uc2a4 \ub370\uc774\ud130
ground_truth = [
    {"query": "What is Haystack?", "expected": "An NLP framework"},
    {"query": "What is RAG?", "expected": "Retrieval-Augmented Generation"},
]

# \ud30c\uc774\ud504\ub77c\uc778 \uc2e4\ud589 \ubc0f \uc608\ucd95 \uac12 \uc218\uc9d1
predictions = []
for item in ground_truth:
    result = rag_pipeline.run({
        "embedder": {"text": item["query"]},
        "prompt_builder": {"query": item["query"]},
    })
    predictions.append(result["generator"]["replies"][0])

# \uc758\ubbf9 \uc720\uc0ac\ub3c4\ub85c \ud3c9\uac00
sas_evaluator = SASEvaluator()
sas_result = sas_evaluator.run(
    ground_truth_answers=[g["expected"] for g in ground_truth],
    predicted_answers=predictions,
)
print(f"SAS Score: {sas_result['score']:.3f}")
```

### Docker \ubc30\ud3ec

```dockerfile
# Dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
EXPOSE 8000
CMD ["python", "serve.py"]
```

```python
# serve.py
from fastapi import FastAPI
from haystack import Pipeline
import yaml

app = FastAPI()

# \uc2dc\uc791 \uc2dc \ud55c \ubc88 \ud30c\uc774\ud504\ub77c\uc778 \ub85c\ub4dc
with open("rag_pipeline.yaml") as f:
    pipeline = Pipeline.loads(f.read())

@app.post("/query")
async def query(question: str):
    result = pipeline.run({
        "embedder": {"text": question},
        "prompt_builder": {"query": question},
    })
    return {
        "answer": result["generator"]["replies"][0],
        "documents": [d.content for d in result.get("retriever", {}).get("documents", [])],
    }
```

```yaml
# docker-compose.yml
version: "3.8"
services:
  haystack-api:
    build: .
    ports:
      - "8000:8000"
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
    depends_on:
      - opensearch

  opensearch:
    image: opensearchproject/opensearch:2.14.0
    environment:
      - discovery.type=single-node
      - DISABLE_SECURITY_PLUGIN=true
    ports:
      - "9200:9200"
    volumes:
      - osdata:/usr/share/opensearch/data

volumes:
  osdata:
```

\ud06c\ub77c\uc6b0\ub4dc VPS \ubc30\ud3ec\uc758 \uacbd\uc6b0, [DigitalOcean](https://m.do.co/c/eca87ac14ee0) App Platform\uc740 Git\uc5d0\uc11c \uc9c1\uc811 Docker \ubc30\ud3ec\ub97c \uc9c0\uc6d0\ud55c\ub2e4. `Dockerfile`\uc744 \ud478\uc2dc\ud558\uace0 \uc800\uc7a5\uc18c\ub97c \uc5f0\uacb0\ud558\uba74 \ud50c\ub7ab\ud3fc\uc774 \uc124\uc815 \uc5c6\uc774 Haystack API\ub97c \ube4c\ub4dc\ud558\uace0 \ud638\uc2a4\ud305\ud55c\ub2e4.

## \ub300\uc548 \uacfc\uc758 \ube44\uad50

| \uae30\ub2a5 | Haystack 2.x | LangChain | LlamaIndex | Semantic Kernel |
|---|---|---|---|---|
| **\ub77c\uc774\uc120\uc2a4** | **Apache-2.0** | MIT | MIT | MIT |
| **GitHub Stars** | **21,000+** | 98,000+ | 41,000+ | 22,000+ |
| **\uc8fc\uc694 \ucd08\uc810** | **\ud504\ub85c\ub355\uc158 RAG/\uac80\uc0c9** | \uc77c\ubc18 LLM \uc624\ucf00\uc2a4\ud2b8\ub808\uc774\uc158 | \uc778\ub371\uc2f1 \uac80\uc0c9 | \uba40\ud2f0 \uc5d0\uc774\uc804\ud2b8 (Microsoft) |
| **\ud30c\uc774\ud504\ub77c\uc778 \ucd94\uc0c1\ud654** | **\uc120\uc5b8\uc801 DAG** | \uccb4\uc778/\uc5d0\uc774\uc804\ud2b8 \ucf54\ub4dc** | \ucffc\ub9ac \uc5d4\uc9c4** | \ud50c\ub7ec\uadf8\uc778 + \uacc4\ud68d\uae30 |
| **\ubb38\uc11c \uc800\uc7a5\uc18c \uc635\uc158** | **30+ \ubc31\uc5d4\ub4dc** | \ud1b5\ud569\uc744 \ud1b5\ud574 | \ud1b5\ud569\uc744 \ud1b5\ud574 | \uc81c\ud55c\uc801 |
| **\ub0b4\uc7a5 \ud3c9\uac00** | **\uc608 (5+ \uba54\ud2b8\ub9ad)** | LangSmith (\uc678\ubd80) | \uae30\ubcf8 | \uc544\ub2c8\uc624 |
| **\ud30c\uc774\ud504\ub77c\uc778 \uc9c1\ub82c\ud654** | **\uc608 (YAML/JSON)** | LangServe | \uc544\ub2c8\uc624 | \uc544\ub2c8\uc624 |
| **\ub124\uc774\ud2f0\ube0c \ube44\ub3d9\uae30** | **\uc608** | \ubd80\ubd84 | \ubd80\ubd84 | \uc608 |
| **\uc140\ud504 \ud638\uc2a4\ud2f1 \ubc30\ud3ec** | **Docker/FastAPI** | LangServe | LlamaDeploy | Azure \uc911\uc2ec |
| **\uc5d0\uc774\uc804\ud2b8 \ud234 \ud638\ucd9c** | **\uc608** | \uc608 | \uc608 | \uc608 (\uac15\ub825) |
| **\ud559\uc2b5 \uace1\uc120** | **\uc911\ubc18\ub3c4** | \ub0ae\uc74c(\uac04\ub2e8), \ub192\uc74c(\uace0\uae09) | \ub0ae\uc74c | \uc911\ubc18\ub3c4 |

Haystack\ub294 **\ubb38\uc11c \uc911\uc2ec\uc758 \uac80\uc0c9\uacfc QA \uc2dc\uc2a4\ud15c**\uc744 \uad6c\ucd95\ud558\ub294 \ud300\uc5d0 \ub72f\uc5b4\ub098\uba70, \ud30c\uc774\ud504\ub77c\uc778 \uac00\ub3d9\uc131, \ud3c9\uac00, \ubc30\ud3ec \uc720\uc5f0\uc131\uc774 \uc911\uc694\ud55c \uacbd\uc6b0\uc5d0 \ucd5c\uc0c1\uc758 \uc120\ud0dd\uc774\ub2e4. LangChain\uc740 \ubc1c\uc18d \ud504\ub85c\ud1a0\ud0c0\uc785\uacfc \uc77c\ubc18\uc801\uc778 LLM \uae30\ubcf8 \ucf54\ub4dc\uc5d0 \ub354 \uc801\ud569\ud558\ub2e4. LlamaIndex\ub294 \uc778\ub371\uc2f1 \uc804\ub7b5\uc744 \ucd5c\uc801\ud654\ud558\uc9c0\ub9cc \ud30c\uc774\ud504\ub77c\uc778 \uc81c\uc5b4\ub97c \ub354 \ub9ce\uc774 \uc81c\uacf5\ud558\uc9c0 \uc54a\ub294\ub2e4. Semantic Kernel\uc740 \uba40\ud2f0-\uc5d0\uc774\uc804\ud2b8 \uc2dc\uc2a4\ud15c\uc744 \uad6c\ucd95\ud558\ub294 Microsoft \uc911\uc2ec\uc758 \uae30\uc5c5\uc5d0 \ucd5c\uc801\ud654\ub418\uc5b4 \uc788\ub2e4.

## \ud55c\uacc4: \uc815\uc9c1\ud55c \ud3c9\uac00

**LangChain\ubcf4\ub2e4 \uc791\uc740 \uc0dd\ud0dc\uacc4:** Haystack\uc740 \uc81c3\uc790 \ud1b5\ud569\uacfc \ucee4\ubba4\ub2c8\ud2f0 \ud29c\ud1a0\ub9ac\u얼\uc774 \uc801\ub2e4. \ud575\uc2ec\uc740 \uaca9\uace0\ud558\uc9c0\ub9cc \uc0dd\ub099\ud55c \uc6a9\ub3c4\uc5d0 \ub300\ud574 \ucee4\uc2a4\ud380 \ucef4\ud3ec\ub10c\ud2b8\ub97c \uc791\uc131\ud560 \ud544\uc694\uac00 \uc788\uc744 \uc218 \uc788\ub2e4.

**\ubcf5\uc7a1\ud55c \ud30c\uc774\ud504\ub77c\uc778\uc758 \ud559\uc2b5 \uace1\uc120:** DAG \ucd94\uc0c1\ud654\ub294 \uac15\ub825\ud558\uc9c0\ub9cc \ucef4\ud3ec\ub10c\ud2b8 \uc785\ucd9c\ub825\uc744 \uc774\ud574\ud560 \ud544\uc694\uac00 \uc788\ub2e4. \uae30\ubcf8\uc790\uc5d0\uac90 \ud30c\uc774\ud504\ub77c\uc778 \uc5f0\uacb0 \uc624\ub958\ub97c \ub514\ubc84\uae45\ud558\ub294 \uac83\uc774 \ub2f9\ud655\uc2a4\ub7fd\uc9c0 \uc54a\uc744 \uc218 \uc788\ub2e4.

**\ud3c9\uac00\ub294 \uc790\ub3d9\uc774 \uc544\ub2d8:** LangSmith\uac00 \uc790\ub3d9\uc73c\ub85c \ud2b8\ub808\uc774\uc2f1\ud558\ub294 \uac83\uacfc \ub2ec\ub9ac, Haystack \ud3c9\uac00\ub294 \ud30c\uc774\ud504\ub77c\uc778\uc5d0 \uba85\uc2dc\uc801\uc73c\ub85c \uc5f0\uacb0\ub418\uc5b4\uc57c \ud55c\ub2e4. \uadf8\ub77c\uc6b4\ub4dc \ud2b8\ub8e8\uc2a4 \ub370\uc774\ud130\uc14b\uc744 \uad00\ub9ac\ud558\uace0 \uc815\uae30\uc801\uc73c\ub85c \ud3c9\uac00\ub97c \uc2e4\ud589\ud574\uc57c \ud55c\ub2e4.

**\uad00\ub9ac\ub418\ub294 \ud074\ub77c\uc6b0\ub4dc \uc11c\ube44\uc2a4 \uc5c6\uc74c:** Haystack\uc740 \uc5c5\uc870 \ud504\ub808\uc784\uc6cc\ud06c\ub97c \uc81c\uacf5\ud560 \ubfd0 — \ud638\uc2a4\ud2f1\uc740 \uc9c1\uc811 \ucc44\uc6b4\ud2b8\uac00 \uc54c\uc544\uc57c \ud55c\ub2e4. \uad00\ub9ac\ud558\ub294 RAG \ud50c\ub7ab\ud3fc\uc744 \uc6d0\ud558\ub294 \ud300\uc758 \uacbd\uc6b0(Docker \uc6b4\uc601 \uc5c5\ubb34\uc5c6\uc774), Vercel AI SDK\uc640 \ubca1\ud130 DB \ud638\uc2a4\ud305 \uac19\uc740 \ub300\uc548\uc774 \ub354 \uac04\ub2e8\ud560 \uc218 \uc788\ub2e4.

**\ub85c\uceec LLM \uc9c0\uc6d0\uc5d0 GPU \ud544\uc694:** \ud504\ub85c\ub355\uc158\uae09 \ub85c\uceec \ubaa8\ub378(Llama 3, Mistral)\uc744 \uc2e4\ud589\ud558\ub824\uba74 GPU \ub9ac\uc18c\uc2a4\uac00 \ud544\uc694\ud558\ub2e4. CPU-\uc804\uc6a9 \ucd94\ub860\uc740 \uc0c1\ud638\uc791\uc6a9\uc6a9 \ub178\ub4e4\uc5d0 \ub108\ubb34 \ub290\ub9ac\ub2e4.

## \uc790\uc8fc \ubb3b\ub294 \uc9c8\ubb38

### Haystack 1.x\uc640 2.x \uc911 \uc5b4\ub5a4 \uac83\uc744 \uc0ac\uc6a9\ud574\uc57c \ud558\ub098?

Haystack 2.x(2024\ub144 1\uc6d4 \ubc1c\ub839)\ub294 2026\ub144 5\uc6d4 \uae30\uc900 \uc720\uc77c\ud558\uac8c \uc801\uade0 \uc720\uc9c0\ub418\ub294 \ube0c\ub79c\uce58\ub2e4. 1.x\ub294 2024\ub144 \ub9cc\uc5d0 \uc9c0\uc6d0 \uc885\ub8cc\ub418\uc5c8\ub2e4. \ubaa8\ub4e0 \uc2e0\uaddc \ud504\ub85c\uc81d\ud2b8\ub294 2.x\ub97c \uc0ac\uc6a9\ud574\uc57c \ud55c\ub2e4. \ud30c\uc774\ud504\ub77c\uc778 API\uac00 \uc644\uc804\ud788 \ub2e4\ub974\ub2e4 — 1.x\ub294 \uc0ac\uc804 \uc815\uc758\ub41c \ub178\ub4dc \uc720\ud615\uc744 \uc0ac\uc6a9\ud558\ub294 `Pipeline` \ud074\ub798\uc2a4\ub97c \uc0ac\uc6a9\ud558\uace0, 2.x\ub294 \ucef4\ud3ec\ub10c\ud2b8 \uae30\ubc18 DAG \uc2dc\uc2a4\ud15c\uc744 \uc0ac\uc6a9\ud55c\ub2e4.

### OpenAI \uc5c6\uc774 Haystack\uc744 \uc0ac\uc6a9\ud560 \uc218 \uc788\ub098?

\ubb3c\ub860\ub2e4. Haystack\uc740 **\ubaa8\ub4e0 \uc0dd\uc131\uae30**\ub97c \uc9c0\uc6d0\ud55c\ub2e4 — \ucef4\ud3ec\ub10c\ud2b8 \uc778\ud130\ud398\uc774\uc2a4\ub97c \uad6c\ud604\ud558\uba74 \ub41c\ub2e4. Hugging Face \ubaa8\ub378(\ub85c\uceec\ubc0f API), Cohere, Anthropic, Azure OpenAI, Ollama, \ub610\ub294 \uc0ac\uc6a9\uc790 \uc815\uc758 LLM \ub7a8\ud37c\ub97c \uc0ac\uc6a9\ud560 \uc218 \uc788\ub2e4. \ubb38\uc11c \uc800\uc7a5\uc18c\uc640 \ub9ac\ud2b8\ub9ac\ubc84 \ucef4\ud3ec\ub10c\ud2b8\ub3c4 \ubaa8\ub378-\uc911\ub9bd\uc801\uc774\ub2e4.

### \ubb38\uc11c \uc800\uc7a5\uc18c\ub97c \uc5b4\ub5bb\uac8c \uc120\ud0dd\ud558\ub098?

\ud504\ub85c\ud1a0\ud0c0\uc774\ud551\uc5d0\uc11c\ub294 `InMemoryDocumentStore`\ub97c \uc0ac\uc6a9\ud558\ub77c. \ud504\ub85c\ub355\uc158\uc5d0\uc11c:
- **OpenSearch:** \uc774\ubbf8 Elasticsearch/OpenSearch \ud074\ub7ec\uc2a4\ud130\ub97c \uc6b4\uc601\ud558\uace0 \uc788\ub2e4\uba74 \ucd5c\uc120
- **Qdrant:** \uc21c\uc218 \ubca1\ud130 \uac80\uc0c9\uc5d0 \ucd5c\uc801, \ub0ae\uc740 \ub9ac\uc18c\uc2a4 \uc0ac\uc6a9
- **Weaviate:** \ud558\uc774\ube0c\ub9ac\ub4dc \uac80\uc0c9(BM25 + \ubca1\ud130)\uc758 \ub0b4\uc7a5 \uae30\ub2a5\uc774 \uc6b0\uc218\ud568
- **PostgreSQL + pgvector:** \ubaa8\ub4e0 \uac83\uc744 \ud558\ub098\uc758 \ub370\uc774\ud130\ubca0\uc774\uc2a4\ub85c \ucc98\ub9ac\ud558\uace0 \uc2f6\ub2e4\uba74 \ucd5c\uc120

### Haystack\uc740 \uc2e4\uc2dc\uac04 \uc751\uc6a9\uc5d0 \uc801\ud569\ud55a\ub098?

\uc6cc\ubc40\ud551\ub41c \ud30c\uc774\ud504\ub77c\uc778\uacfc \ube44\ub3d9\uae30 \uc2e4\ud589\uc73c\ub85c \uac04\ub2e8\ud55c RAG\uc5d0\uc11c **<500ms**\uc758 \uc5d4\ub4dc\ud22c\uc5d4\ub4dc \uc9c0\uc5f0\uc744 \ub2ec\uc131\ud55c\ub2e4(LLM \uc0dd\uc131 \uc2dc\uac04 \uc81c\uc678). \uc9c4\uc815\uc73c\ub85c \uc2e4\uc2dc\uac04\uc778 \uc0ac\uc6a9\uc0ac\ub840(<200ms)\uc758 \uacbd\uc6b0 \uce90\uc2f1 \ub808\uc774\uc5b4\ub97c \ucd94\uac00\ud558\uac70\ub098 `run_async()`\uc758 \uc2a4\ud2b8\ub9ac\ubc0d \uc0dd\uc131\uae30\ub97c \uc0ac\uc6a9\ud558\ub77c.

### Haystack\uc740 \ud30c\uc774\ud504\ub77c\uc778 \ubc84\uc804 \uad00\ub9ac\ub97c \uc5b4\ub5bb\uac8c \ucc98\ub9ac\ud558\ub098?

\ud30c\uc774\ud504\ub77c\uc778\uc740 YAML\uacfc JSON\uc73c\ub85c \uc9c1\ub82c\ud654\ud560 \uc218 \uc788\uace0 \ubc84\uc804 \uad00\ub9ac\uc5d0 \ucee4\ubc0b\ud560 \uc218 \uc788\ub2e4. \ucef4\ud3ec\ub10c\ud2b8\ub294 \ud074\ub798\uc2a4 \uc774\ub984\uacfc \ub9e4\uac1c\ubcc0\uc218\ub85c \ucc38\uc870\ub418\uc5b4 \uc788\uc5b4 \ucc28\uc774\ub97c \uc77d\uae30 \uc27d\uac8c \ub9cc\ub4e0\ub2e4. `pipeline.dump()`\uacfc `Pipeline.loads()` \uba54\uc11c\ub4dc\ub294 \ub3d9\uc77c\ud55c YAML\uc774 \ub2e4\ub978 \ud658\uacbd\uc5d0\uc11c \ub3d9\uc77c\ud55c \ub3d9\uc791\uc744 \ub9cc\ub4dc\ub294 \ubc18\ubcf5 \uac00\ub2a5\ud55c \ubc30\ud3ec\uc744 \uac00\ub2a5\ud558\uac8c \ud55c\ub2e4.

### \ud504\ub85c\ub355\uc158\uc744 \uc704\ud55c \uad8c\uc7a5 \ubc30\ud3ec \uc544\ud0a4\ud399\cc98\ub294 \ubb34\uc5c7\uc778\uac00?

\ud504\ub85c\ub355\uc158: (1) Docker\ub85c Haystack API\ub97c \ucee8\ud14c\uc774\ub108\ud654, (2) \uad00\ub9ac\ud558\ub294 \ubca1\ud130 \ub370\uc774\ud130\ubca0\uc774\uc2a4(Qdrant Cloud, AWS\uc758 OpenSearch)\ub97c \uc0ac\uc6a9, (3) \uc790\ub3d9 \ud655\uc7a5\uc774 \uac00\ub2a5\ud55c \ub85c\ub4dc\ubc38\ub7f0\uc11c \ub4a4\uc5d0 API\ub97c \uc2e4\ud589, (4) Redis\ub85c \ube48\ubc88\ud55c \ucffc\ub9ac\ub97c \uce90\uc2f1, (5) Haystack\uc758 \ub0b4\uc7a5 \ud3c9\uac00\uae30\ub97c \ud65c\uc6a9\ud55c \ub9e4\uc8fc \ud3c9\uac00 \uc2a4\ucf00\uc904\ub9c1. \uc6d4 $24\uc758 DigitalOcean Droplet\uc740 \uc77c\ubc18\uc801\uc778 RAG \uc791\uc5c5\ub7c9\uc5d0\uc11c 50-100\uba85\uc758 \ub3d9\uc2dc \uc0ac\uc6a9\uc790\ub97c \ucc98\ub9ac\ud560 \uc218 \uc788\ub2e4.

## \uacb0\ub860: \uc624\ub798 \uac00\ub294 \ud30c\uc774\ud504\ub77c\uc778\uc744 \uad6c\ucd95\ud558\ub77c

\ub370\ubaa8 RAG \uc571\uacfc \ud504\ub85c\ub355\uc158 \uac80\uc0c9 \uc2dc\uc2a4\ud15c\uc758 \ucc28\uc774\ub294 LLM\uc774 \uc544\ub2c8\ub77c \uadf8 \uc8fc\ubcc0\uc758 \uc544\ud0a4\ud399\ucc98\uc5d0 \uc788\ub2e4. Haystack\uc740 \uadf8 \uc544\ud0a4\ud399\ucc98\ub97c \uc81c\uacf5\ud55c\ub2e4: \uad50\ucc29 \uac00\ub2a5\ud55c \ucef4\ud3ec\ub10c\ud2b8, \uc9c1\ub82c\ud654 \uac00\ub2a5\ud55c \ud30c\uc774\ud504\ub77c\uc778, \ub0b4\uc7a5 \ud3c9\uac00, \ubc0f \ub2c8\uc988\uc5d0 \ub530\ub77c \uc131\uc7a5\ud558\ub294 \ubc30\ud3ec \uc720\uc5f0\uc131.

\uc624\ub298 Haystack\uc744 \uc124\uce58\ud558\uace0 \ud558\ub098\uc758 \ud30c\uc774\ud504\ub77c\uc778\uc744 \uad6c\ucd95\ud574\ub77c. \uc120\uc5b8\uc801 DAG \ubaa8\ub378\uc740 \ucc98\uc74c\uc5d0\ub294 \ub0af\uc120\uc744 \ud488\uaca0\uc9c0\ub9cc \uc77c\uc8fc\uc77c \uc548\uc5d0 \ub9ac\ud2b8\ub9ac\ubc84\ub97c \uad50\ucc29\ud558\uace0 \uc7ac\ub79c\ucee4\ub97c \ucd94\uac00\ud558\uba70 \ubd84\uae30 \ub85c\uc9c1\uc744 \ubc14\uafb8\ub294 \uac8c \uc751\uc6a9\uc744 \ub2e4\uc2dc \uc791\uc131\ud560 \ud544\uc694\uc5c6\uc774 \ud560 \uc218 \uc788\ub2e4\ub294 \uac83\uc744 \uac10\uc0ac\ud560 \uac83\uc774\ub2e4.

\ubb38\uc11c \uac80\uc0c9\uc744 \ud504\ub85c\ub355\uc158\uc73c\ub85c \ud06c\uae30\ub97c \ud655\uc7a5\ud558\ub294 \ud300\uc5d0\uac90 Haystack\uc740 \ubc29\ud574\ud558\uc9c0 \uc54a\uc73c\uba74\uc11c \ud544\uc694\ud55c \uc81c\uc5b4\ub97c \uc81c\uacf5\ud558\ub294 \ud504\ub808\uc784\uc6cc\ud06c\uc774\ub2e4. [DigitalOcean](https://m.do.co/c/eca87ac14ee0)\uc744 \ud1b5\ud574 VPS\uc5d0 \ubc30\ud3ec\ud558\uac70\ub098 Telegram\uc5d0\uc11c \uc6b0\ub9ac \ucee4\ubba4\ub2c8\ud2f0\uc640 \ud504\ub85c\ub355\uc158 \ud328\ud134\uc744 \ub17c\uc758\ud558\ub77c \u2014 \uc6b0\ub9ac\ub294 \ub9e4\uc77c \ud30c\uc774\ud504\ub77c\uc778 \uad6c\uc131, \ud3c9\uac00 \ubca4\uce58\ub9c8\ud06c, \ubc30\ud3ec \ud15c\ud50c\ub9bf\uc744 \uacf5\uc720\ud55c\ub2e4.



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## \ucc38\uace0 \uc790\ub8cc \ubc0f \ucd94\uac00 \ud559\uc2b5

- Haystack GitHub \uc800\uc7a5\uc18c: https://github.com/deepset-ai/haystack
- \uacf5\uc2dd \ubb38\uc11c: https://docs.haystack.deepset.ai/
- Haystack \ud1b5\ud569 \ud5c8\ube0c: https://haystack.deepset.ai/integrations
- "Building Search Systems with Haystack 2.x" \u2014 deepset \ube14\ub85c\uadf8, 2026
- "RAG Evaluation Best Practices" \u2014 dibi8.com \ub0b4\ubd80 \uc5f0\uad6c

---

**\uc81c\ud734 \uacf5\uac1c:** \ubcf8 \uae00\uc758 \uc77c\ubd80 \ub9c1\ud06c\ub294 \uc81c\ud734 \ub9c1\ud06c\uc774\ub2e4. \uc6b0\ub9ac\uc758 [DigitalOcean \ucd94\ucc9c \ub9c1\ud06c](https://m.do.co/c/eca87ac14ee0)\ub97c \ud1b5\ud574 \uac00\uc785\ud558\uba74 $200 \ud06c\ub808\ub527\uc744 \ubc1b\uace0 \uc6b0\ub9ac\ub3c4 \ucd94\ucc9c \ubcf4\ub108\uc2a4\ub97c \ubc1b\ub2e4 \u2014 \ucda9\uac00 \ube44\uc6a9\uc5c6\uc774. \uc774\ub294 \uc6b0\ub9ac\uc758 \ub3c5\ub9bd\uc801\uc778 \uc5f0\uad6c\uc744 \uc9c0\uc6d0\ud558\uace0 \ucf58\ud150\ucce4\uc744 \ubb34\ub8cc\ub85c \uc720\uc9c0\ud55c\ub2e4.
