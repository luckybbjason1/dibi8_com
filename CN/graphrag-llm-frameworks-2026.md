---
title: 'GraphRAG: Microsoft''s Graph-Based RAG for Better LLM Answers (33K Stars) — Practical 2026 Guide'
description: 'GraphRAG is Microsoft''''s modular, knowledge-graph-based RAG system (33,403 GitHub stars, MIT license). This guide covers installation, the init/index/query workflow, real CLI examples, and an honest comparison with LangChain and Haystack.'
date: 2026-06-02 00:00:00+08:00
lastmod: 2026-06-02 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'microsoft/graphrag'
stars: 33403
maintainer: 'microsoft'
last_maintained: '2026-06-02'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: []
aliases:
- /posts/graphrag-llm-frameworks-2026/
faqs:
  - q: 'How do I install graphrag?'
    a: 'Install it from PyPI with a single command (Python 3.10–3.12): ```bash pip install graphrag ```'
  - q: 'What are the system requirements for running graphrag?'
    a: 'GraphRAG needs Python 3.10–3.12 and access to a language model (OpenAI, Azure OpenAI, or another supported provider) via an API key. It runs on any modern operating system that supports Python.'
  - q: 'Can I contribute to the project?'
    a: 'Yes. The project is open-source under the MIT license, and contributions are welcome. See the [CONTRIBUTING.md](https://github.com/microsoft/graphrag/blob/main/CONTRIBUTING.md) file on GitHub for guidelines.'
  - q: 'How do I report an issue or bug?'
    a: 'Use the GitHub Issues page for the repository. Include as much detail as possible — error messages, your configuration, and steps to reproduce the problem.'
  - q: 'How is GraphRAG different from regular vector RAG?'
    a: 'Regular RAG retrieves a few similar chunks and answers from them. GraphRAG additionally builds a knowledge graph and community summaries from your documents, which lets it answer broad, corpus-wide questions (global search) as well as entity-focused ones (local search).'
---

{{< resource-info >}}

## Introduction

Classic Retrieval-Augmented Generation (RAG) retrieves a handful of text chunks by vector similarity and stuffs them into the prompt. That works for fact-lookup questions but struggles with "connect the dots" queries that span a whole corpus. Microsoft's `graphrag` takes a different route: it uses an LLM to extract a **knowledge graph** of entities and relationships from your documents, builds community summaries over that graph, and then answers questions against that structure. With over 33,403 stars on GitHub and an MIT license, it is one of the most-watched RAG projects of the past two years. This guide walks through installing GraphRAG, running its real `init` / `index` / `query` workflow, and deciding honestly whether it fits your use case.

## What Is graphrag?

GraphRAG is a modular, graph-based Retrieval-Augmented Generation pipeline. Instead of treating your documents as a flat pile of chunks, it uses a language model to read the text, pull out entities and the relationships between them, and assemble a knowledge graph. It then clusters that graph into communities and generates summaries for each community.

The project is maintained by Microsoft Research and is written in Python. It is distributed as a command-line tool and a Python library, configured through a `settings.yaml` file. The result is a system that can answer broad, corpus-wide questions ("What are the main themes across these documents?") that ordinary vector RAG tends to miss.

## How graphrag Works

GraphRAG splits the problem into an offline indexing phase and an online query phase:

1. **Indexing**: GraphRAG chunks your source documents, then prompts an LLM to extract entities, relationships, and claims from each chunk. These are merged into a single knowledge graph. The graph is partitioned into communities (using the Leiden algorithm), and the LLM writes a summary report for each community.

2. **Querying — Global Search**: For broad questions about the whole corpus, GraphRAG uses the community summaries in a map-reduce fashion: it reasons over many community reports, then combines the partial answers into a final response.

3. **Querying — Local Search**: For questions centered on a specific entity, GraphRAG retrieves that entity's neighbors, relationships, and the relevant source text, then generates a focused answer.

This two-mode design is what separates GraphRAG from a plain vector store: global search gives you the big picture, local search gives you the detail.

## Installation & Setup

To run graphrag as a scheduled production job you want an always-on box — spin one up on [DigitalOcean](https://m.do.co/c/eca87ac14ee0) (free trial credit for new accounts), or [HTStack](https://my.htstack.com/aff.php?aff=27187) for low-latency Hong Kong VPS (same IDC that hosts dibi8.com).

GraphRAG requires Python 3.10–3.12. The recommended way to install it is via pip:

```bash
pip install graphrag
```

Once installed, you initialize a workspace. This creates the configuration files and folder structure GraphRAG expects:

```bash
mkdir -p ./ragtest/input
# put your .txt or .csv documents into ./ragtest/input
python -m graphrag init --root ./ragtest
```

The `init` command generates a `settings.yaml` and a `.env` file in the project root. Open `.env` and set your model API key, for example:

```bash
GRAPHRAG_API_KEY=<your-openai-or-azure-key>
```

### Common Error and Fix

A frequent first-run problem is a missing or empty API key. If indexing fails immediately with an authentication error, confirm that `GRAPHRAG_API_KEY` is set in `./ragtest/.env` and that the model names in `settings.yaml` match models your key can actually access. Switching the configured model to one available on your account usually resolves it.

## Core Usage

After `init`, the typical workflow is: drop documents in the input folder, build the index, then query it.

### Step 1: Build the Index

Run the indexing pipeline over your workspace. This is the expensive step — it makes many LLM calls to extract the graph:

```bash
python -m graphrag index --root ./ragtest
```

When it finishes, GraphRAG writes the entity graph, community reports, and embeddings as Parquet files under `./ragtest/output`.

### Step 2: Global Search

Use global search for broad, corpus-wide questions that require synthesizing across many documents:

```bash
python -m graphrag query \
  --root ./ragtest \
  --method global \
  --query "What are the major themes in these documents?"
```

### Step 3: Local Search

Use local search when your question centers on a specific entity or a narrow part of the corpus:

```bash
python -m graphrag query \
  --root ./ragtest \
  --method local \
  --query "What is the relationship between Entity A and Entity B?"
```

These three commands — `init`, `index`, and `query` — cover the core GraphRAG loop. For configuration options, prompt tuning, and advanced settings, see the official documentation: [https://microsoft.github.io/graphrag/](https://microsoft.github.io/graphrag/)

## Integration

Because indexing produces plain Parquet outputs (entities, relationships, community reports, and text-unit embeddings), GraphRAG integrates cleanly with the rest of the Python data ecosystem.

### Working with the Output

You can load the generated graph and reports directly with pandas for inspection, custom retrieval, or downstream analytics:

```python
import pandas as pd

entities = pd.read_parquet("./ragtest/output/entities.parquet")
relationships = pd.read_parquet("./ragtest/output/relationships.parquet")
community_reports = pd.read_parquet("./ragtest/output/community_reports.parquet")

print(entities.head())
print(community_reports[["title", "summary"]].head())
```

### Customizing with settings.yaml

GraphRAG's behavior is controlled through the `settings.yaml` file created by `init`. There you choose the chat and embedding models, set chunk size, tune concurrency, and point at your input data. A simplified excerpt looks like this:

```yaml
models:
  default_chat_model:
    type: openai_chat
    model: gpt-4o-mini
  default_embedding_model:
    type: openai_embedding
    model: text-embedding-3-small

chunks:
  size: 1200
  overlap: 100

input:
  type: file
  file_type: text
  base_dir: "input"
```

Editing this file is how you adapt GraphRAG to a different model provider, document type, or chunking strategy — no code changes required.

## Real-World Use

GraphRAG, developed by Microsoft Research under the MIT license, has been adopted for knowledge-base, research, and analytics workloads where questions span an entire corpus rather than a single document.

### Where It Shines

The graph-plus-community-summary approach is most valuable when you need "sensemaking" over a large body of text — for example, summarizing themes across a set of reports, tracing how entities relate across many documents, or answering questions whose evidence is scattered across the corpus. In those scenarios, GraphRAG's global search tends to produce more comprehensive answers than a baseline vector RAG that only sees a few top-k chunks.

### Cost Awareness

Indexing is LLM-intensive: GraphRAG calls the model repeatedly to extract entities and relationships and to write community reports, so the cost scales with corpus size and the model you choose. Many teams start with a smaller, cheaper chat model (such as `gpt-4o-mini`) to control indexing cost, then evaluate whether a stronger model is worth it for their data.

## Comparison with Alternatives

See also our [related open-source tools](dibi8-internal-link) coverage.

GraphRAG, LangChain, and Haystack solve overlapping but different problems. GraphRAG is a focused, opinionated graph-RAG pipeline; LangChain and Haystack are general frameworks for building LLM applications and RAG pipelines of many kinds. The table below is a rough orientation, not a head-to-head benchmark — star counts and issue counts move over time, so treat them as approximate.

| Feature | **GraphRAG** | **LangChain** | **Haystack** |
|---|---|---|---|
| Primary focus | Graph-based RAG pipeline | General LLM app framework | RAG / search framework |
| Language | Python | Python | Python |
| License | MIT | MIT | Apache-2.0 |
| Maintainer | Microsoft | LangChain, Inc. | deepset |
| Knowledge graph extraction | Built-in | Via integrations | Via integrations |
| Global (corpus-wide) querying | Yes | Not built-in | Not built-in |
| Out-of-the-box breadth | Narrow (graph RAG only) | Very broad | Broad |
| Documentation | Comprehensive | Comprehensive | Comprehensive |

### Why Choose GraphRAG?

- **Built for corpus-wide questions**: Its global search and community summaries are designed for "what are the themes across everything?" queries that plain vector RAG handles poorly.
- **Graph extraction included**: Entity and relationship extraction is part of the pipeline, not something you assemble yourself.
- **Backed by Microsoft Research**: Active development, solid documentation, and a steady stream of research-driven improvements.

### Considerations

If you simply need top-k retrieval for short factual answers, a general framework like LangChain or Haystack with a vector store is lighter-weight and cheaper to run. GraphRAG earns its extra indexing cost specifically when the *structure* of the corpus matters to the answer.

## Limitations & Honest Assessment

GraphRAG is a strong tool for the right job, but it has real trade-offs:

1. **Indexing is expensive**: Building the graph makes many LLM calls, so both cost and time grow with corpus size. This is the single biggest factor to budget for.
2. **Configuration takes effort**: Getting good results often requires tuning chunk size, prompts, and model choices in `settings.yaml`. It is not a one-line drop-in.
3. **Overkill for simple lookups**: For narrow Q&A where the answer lives in one chunk, classic vector RAG is faster and far cheaper.
4. **Operational overhead**: You manage an indexing pipeline and its Parquet outputs, plus periodic re-indexing as your documents change.
5. **Quality depends on the model**: Entity and relationship extraction quality follows the strength of the chat model you configure, which ties answer quality directly to your model budget.

These trade-offs are the key things to weigh when deciding whether GraphRAG fits your specific use case.

## Conclusion

GraphRAG is a well-maintained, modular graph-based RAG system from Microsoft Research, with over 33,403 stars on GitHub, written in Python and licensed under MIT. Its strength is answering questions whose evidence is spread across an entire corpus — something plain vector RAG handles poorly. The trade-off is indexing cost and configuration effort. A good next step is to run `python -m graphrag init` on a small document set and compare a global-search answer against your current RAG setup.

- Join the [dibi8 English Telegram group](https://t.me/DIBI8_Group/2) for open-source AI tool drops.
- Read next: [related guides on dibi8](dibi8-internal-link).

---

**Sources & Further Reading**:
- GitHub repository: https://github.com/microsoft/graphrag
- Official docs / README: https://github.com/microsoft/graphrag#readme

*Some links above are affiliate links. dibi8.com may earn a commission if you sign up, at no extra cost to you. Helps keep the site running and the content free.*

<!-- internal-link-candidates:
  related open-source tools -> ai-tools-directory
  related guides on dibi8 -> ai-coding-agent-landscape-2026-skills-mcp-opensource
-->
