---
title: "PageIndex：29K⭐Vectorless RAG System — Document Retrieval Without Vector Database"
description: "PageIndex is a vectorless, reasoning-driven RAG system open-sourced by VectifyAI. 29K+ Stars, achieves human-like retrieval through document tree structures, reaching 98.7% accuracy on FinanceBench."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Python
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "23.7 MB"
file_md5: ""
download_url: "https://github.com/VectifyAI/PageIndex"
backup_url: ""
github_repo: "https://github.com/VectifyAI/PageIndex"
stars: 31643
maintainer: "VectifyAI"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /posts/pageindex-vectorless-reasoning-rag/
faqs:
  - q: 'What is PageIndex and how is it different from traditional RAG?'
    a: 'PageIndex is an open-source RAG system from VectifyAI that retrieves information without a vector database. Instead of embedding and chunking documents, it builds a hierarchical tree structure of each document and uses LLM reasoning to traverse it, mimicking how a human expert reads a table of contents to find the relevant section.'
  - q: 'Does PageIndex require a vector database or document chunking?'
    a: 'No. PageIndex eliminates both. It does not store vector embeddings, avoiding expensive vector storage costs, and it does not chunk documents, which preserves their natural logical structure instead of cutting through it.'
  - q: 'How accurate is PageIndex on the FinanceBench benchmark?'
    a: 'PageIndex paired with GPT-4 reaches 98.7% accuracy on FinanceBench, a state-of-the-art result. PageIndex with Claude-3 reaches 97.2%, while traditional vector RAG scores around 79-82% on the same benchmark.'
  - q: 'How do I install and run a basic query with PageIndex?'
    a: 'Install it with `pip install pageindex`. Then initialize with `pi = PageIndex()`, load a document via `pi.load_pdf("file.pdf")`, and query with `result = pi.query("your question")`. The result includes both an answer and citation sources such as page numbers and chapters.'
  - q: 'What kinds of documents is PageIndex best suited for?'
    a: 'PageIndex is designed for long, professional documents where structure matters and explainable citations are needed, such as financial reports and prospectuses, legal contracts and case law, medical literature and clinical trial reports, and technical documentation like API references and operation manuals.'
---
{</* resource-info */>}

![PageIndex official hero banner](/images/articles/pageindex-vectorless-reasoning-rag/banner.png)
*Source: [github.com/VectifyAI/PageIndex](https://github.com/VectifyAI/PageIndex) — official banner*

## What is PageIndex?

**PageIndex** is an open-source RAG (Retrieval-Augmented Generation) system developed by **VectifyAI** that fundamentally changes traditional document retrieval. Unlike conventional vector databases, PageIndex uses a **reasoning-driven** approach, achieving human-like retrieval by constructing **hierarchical tree structures** of documents.

- 🌲 **Tree Structure Index** — Organizes documents like a table of contents
- 🧠 **Reasoning-Driven Retrieval** — LLM reasoning instead of vector similarity
- ❌ **No Vector Database Required** — Eliminates expensive vector storage costs
- ❌ **No Chunking Needed** — Preserves natural document structure
- 📊 **98.7% Accuracy** — SOTA on FinanceBench benchmark

GitHub: https://github.com/VectifyAI/PageIndex  
Stars: **29,202+** | Language: Python | License: Apache-2.0

---

## Why Traditional RAG Isn't Good Enough

### Problems with Traditional Vector RAG

| Problem | Explanation |
|---------|-------------|
| **Similarity ≠ Relevance** | Vector search finds semantically similar content, but not necessarily truly relevant results |
| **Chunking Destroys Structure** | Forced chunking cuts through document logical structure |
| **Black Box Retrieval** | Vector search is unexplainable, can't trace why this result was returned |
| **High Costs** | Requires maintaining vector databases with expensive storage and computation |
| **Poor Performance on Long Documents** | Low retrieval accuracy for professional long documents (financial reports, legal files) |

### PageIndex's Solution

PageIndex mimics how **human experts** read documents:
1. First look at the table of contents structure (tree index)
2. Reason which chapters should contain the answer based on the question
3. Deep dive into relevant chapters

---

## Core Technical Principles

### 1. Document Tree Structure Generation

PageIndex converts PDFs into hierarchical tree structures:

```json
{
  "title": "Financial Stability",
  "node_id": "0006",
  "start_index": 21,
  "end_index": 22,
  "summary": "The Federal Reserve monitors financial vulnerabilities...",
  "nodes": [
    {
      "title": "Monitoring Financial Vulnerabilities",
      "node_id": "0007",
      "start_index": 22,
      "end_index": 28
    },
    {
      "title": "Domestic and International Cooperation",
      "node_id": "0008",
      "start_index": 28,
      "end_index": 31
    }
  ]
}
```

### 2. Reasoning-Driven Tree Search

When a user asks a question, the LLM will:
1. **Understand the Question** — Analyze query intent
2. **Traverse Tree Structure** — Reason which nodes likely contain the answer
3. **Deep Dive into Relevant Nodes** — Search for specific information in candidate nodes
4. **Return Results** — With citation sources (page numbers, chapters)

### 3. Monte Carlo Tree Search Inspired by AlphaGo

PageIndex draws inspiration from AlphaGo, using **tree search algorithms**:
- **Selection** — Choose the most promising nodes
- **Expansion** — Expand child nodes
- **Evaluation** — LLM evaluates node relevance
- **Backpropagation** — Update node weights

---

## Quick Start

### Installation

```bash
pip install pageindex
```

### Basic Usage

```python
from pageindex import PageIndex

# Initialize
pi = PageIndex()

# Load PDF
pi.load_pdf("financial_report.pdf")

# Query
result = pi.query("What are the main risks mentioned in Q3?")
print(result.answer)
print(result.sources)  # Citation sources
```

### Advanced Configuration

```python
# Custom LLM
pi = PageIndex(
    llm="gpt-4",
    temperature=0.1,
    max_depth=5  # Tree search depth
)

# Batch processing
pi.load_pdfs(["report1.pdf", "report2.pdf", "report3.pdf"])
results = pi.batch_query([
    "What is the revenue growth?",
    "What are the risk factors?",
    "What is the cash flow situation?"
])
```

---

## Performance Benchmarks

### FinanceBench Test Results

| Model | Accuracy | Notes |
|-------|----------|-------|
| **PageIndex + GPT-4** | **98.7%** | SOTA |
| PageIndex + Claude-3 | 97.2% | Excellent |
| Traditional RAG + GPT-4 | 82.1% | Baseline |
| Traditional RAG + Claude-3 | 79.5% | Baseline |

### Comparison with Vector RAG

| Metric | PageIndex | Traditional Vector RAG |
|--------|-----------|------------------------|
| Indexing Speed | 3x faster | Requires embedding computation |
| Storage Cost | 90% reduction | Vector storage is expensive |
| Retrieval Accuracy | 98.7% | ~80% |
| Explainability | ✅ Citation sources | ❌ Black box |
| Long Document Support | ✅ Native | ❌ Requires chunking |

---

## Use Cases

### Financial Analysis
- Annual report analysis
- Prospectus review
- Risk assessment
- Compliance checking

### Legal Document Review
- Contract analysis
- Case law research
- Regulatory document review
- Due diligence

### Medical Literature
- Clinical trial reports
- Drug instructions
- Medical guidelines
- Research paper review

### Technical Documentation
- API documentation
- System architecture docs
- Operation manuals
- Technical specifications

---

## Architecture Design

```
┌─────────────────────────────────────────┐
│           User Query                     │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│      Query Understanding (LLM)           │
│  - Intent analysis                       │
│  - Keyword extraction                    │
│  - Question classification               │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│      Tree Structure Traversal            │
│  - Node relevance scoring                │
│  - Pruning optimization                │
│  - Multi-path exploration                │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│      Content Retrieval                   │
│  - Precise positioning                   │
│  - Context expansion                     │
│  - Source marking                        │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│      Answer Generation (LLM)             │
│  - Information synthesis               │
│  - Answer structuring                    │
│  - Citation addition                     │
└─────────────────────────────────────────┘
```

---

## Community & Ecosystem

- **GitHub Stars**: 29,202+
- **Contributors**: 50+
- **Release Cycle**: Weekly updates
- **Community**: Active Discord channel

### Related Projects
- **VectifyAI**: Commercial version providing enterprise-grade support
- **PageIndex Hub**: Community-contributed document templates
- **PageIndex CLI**: Command-line tool for batch processing

---

## Summary

PageIndex represents a paradigm shift in document retrieval:
- **No vector database** required, dramatically reducing costs
- **Reasoning-driven** retrieval, more aligned with human thinking
- **Explainable** results, every answer has traceable sources
- **High accuracy**, reaching 98.7% on professional benchmarks

For scenarios requiring processing large volumes of professional documents (finance, law, medicine), PageIndex is an option worth prioritizing.

---

## Related Articles

- [Free Claude Code: Use Claude Code CLI for Free with Any AI Provider](/resources/ai-tools/free-claude-code-open-source-proxy/)
- [Scanners-Box: 200+ Cybersecurity Tools Collection](/resources/dev-utils/scanners-box-cybersecurity-tools-collection/)
- [Goose AI Agent: Open-Source AI Agent for Coding, Research & Automation](/resources/llm-frameworks/goose-ai-agent-open-source-automation/)

---

## Recommended Infrastructure for Self-Hosting

If you want to run this stack reliably 24/7, infrastructure choice matters:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

<!--auto-references-->
## References & Sources

- [PageIndex](https://github.com/VectifyAI/PageIndex)
- [FinanceBench](https://github.com/patronus-ai/financebench)
