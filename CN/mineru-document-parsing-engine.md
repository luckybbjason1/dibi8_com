---
lang: en
title: "MinerU: 70.6K Stars — Convert Any Document to LLM-Ready Markdown"
description: 'MinerU (70,600+ GitHub stars) transforms PDF, DOCX, PPTX, XLSX, images and web pages into structured Markdown and JSON for LLM, RAG and Agent workflows. Supports 109-language OCR, formula-to-LaTeX, table-to-HTML, and runs on CPU or GPU.'
tags: ["guide", "open-source", "ai-agents", "rag", "pdf", "ocr", "reference", "tutorial"]
date: 2026-06-27 00:00:00+08:00
slug: 'mineru-document-parsing-engine'
category: ai-tools
github_repo: 'https://github.com/opendatalab/MinerU'
license: MinerU Open Source License (Apache 2.0-based)
lang: en
featureImage: /images/articles/mineru-docs.png
---

![MinerU logo](https://gcore.jsdelivr.net/gh/opendatalab/MinerU@master/docs/images/MinerU-logo.png)

*MinerU — the open-source document parsing engine that turned 70,600 GitHub stars in just over a year.*

In the age of AI coding agents and RAG pipelines, the biggest bottleneck isn't model capability — it's **data quality**. You can have the most powerful LLM in the world, but if your input documents are messy PDFs with broken tables, unreadable formulas, and garbled headers, the output will be garbage.

Enter **MinerU**, a document parsing tool from OpenDataLab (the team behind InternLM) that converts PDF, DOCX, PPTX, XLSX, images, and web pages into **clean, structured Markdown and JSON** — specifically designed for downstream LLM, RAG, and Agent workflows.

With **70,600+ GitHub stars**, **5,900 forks**, and **960 stars gained today alone**, MinerU has quickly become the go-to open-source solution for document-to-LLM-pipeline conversion.

## What Is MinerU?

MinerU was born during the pre-training process of [InternLM](https://github.com/InternLM/InternLM), a Chinese large language model. The team noticed that converting scientific papers and technical documents into machine-readable format was a massive pain point — especially for formulas, tables, and complex layouts.

So they built MinerU.

Unlike traditional PDF parsers that just extract raw text, MinerU understands document structure:

- **Removes** headers, footers, footnotes, and page numbers that break semantic coherence
- **Preserves** reading order for single-column, multi-column, and complex layouts
- **Converts** formulas to LaTeX, tables to HTML
- **Detects** scanned and garbled PDFs and automatically enables OCR
- **Supports** 109 languages for OCR recognition
- **Outputs** multimodal Markdown, NLP Markdown, and JSON sorted by reading order

The result is document content that AI agents and LLMs can actually understand.

## Installation and Setup

MinerU offers multiple installation paths depending on your needs:

### pip (Recommended for most users)

```bash
pip install mineru
```

### Docker

```bash
docker pull mineru/mineru:latest
docker run --gpus all -v $(pwd):/data mineru/mineru:latest
```

### Local Development

```bash
git clone https://github.com/opendatalab/MinerU.git
cd MinerU
pip install -e .
```

MinerU supports both **CPU-only** and **GPU-accelerated** inference. For GPU acceleration, install with CUDA support:

```bash
pip install mineru[cuda]
```

On macOS with Apple Silicon, MinerU leverages MPS (Metal Performance Shaders) for acceleration.

## Three Parsing Engines

MinerU provides three different parsing backends, each optimized for different scenarios:

### 1. Pipeline Backend (Fast & Stable)

The `pipeline` backend is the default choice for most users. It's fast, stable, and produces no hallucinations. It runs efficiently on CPU and is ideal for batch processing.

```bash
mineru ./input.pdf -o ./output/
```

**Best for:** High-volume document processing, CI/CD pipelines, CPU-only environments.

### 2. VLM Engine (High Accuracy)

The VLM (Vision Language Model) engine uses MinerU's proprietary `MinerU2.5-Pro-2604-1.2B` model for state-of-the-art parsing accuracy. It excels on complex documents with mixed layouts, handwritten text, and dense formulas.

```bash
mineru ./complex.pdf -o ./output/ --engine vlm-engine
```

**Best for:** Complex scientific papers, scanned documents, handwritten content, multi-language OCR.

### 3. Hybrid Engine (Balanced)

The `hybrid` engine combines native text extraction with VLM-based analysis. Starting from version 3.3, it includes an `effort` parameter with `medium` and `high` levels:

- **Medium effort:** 35-220% faster than high, with only 0.13-point accuracy drop on OmniDocBench
- **High effort:** Maximum accuracy with image analysis support

```bash
mineru ./document.pdf -o ./output/ --engine hybrid-engine --effort medium
```

**Best for:** Production workloads where you need to balance speed and accuracy.

## Supported Formats

MinerU supports a comprehensive range of input formats:

| Format | Support Level | Notes |
|--------|--------------|-------|
| PDF | Native | Text PDFs, scanned PDFs, garbled PDFs |
| DOCX | Native | Full structural preservation |
| PPTX | Native | Slides, layouts, embedded content |
| XLSX | Native | Tables, formulas, charts |
| Images | OCR | JPEG, PNG, TIFF, BMP, and more |
| Web Pages | Scraping | Full-page conversion to Markdown |

The native DOCX, PPTX, and XLSX support (added in version 3.1.0) means MinerU can parse these formats **directly** without converting to PDF first — a significant speed improvement over traditional workflows.

## OCR: 109 Languages

MinerU's OCR engine supports **109 languages** and was upgraded to PP-OCRv6 in version 3.4, improving accuracy by approximately 11% on the OmniDocBench v1.6 benchmark.

Starting from version 3.4, MinerU simplified the OCR language configuration. Instead of selecting individual languages (Japanese, Traditional Chinese, English, Latin), all scenarios now route through the optimized `ch` OCR model, reducing configuration complexity while improving accuracy.

```bash
# Automatic OCR detection (recommended)
mineru ./scanned.pdf -o ./output/

# Force OCR on a specific document
mineru ./document.pdf -o ./output/ --ocr
```

## Real-World Use Cases

### RAG Pipeline Data Preparation

MinerU is purpose-built for RAG (Retrieval-Augmented Generation) workflows. By converting documents into structured Markdown with preserved reading order, headings, and semantic structure, RAG systems can chunk and embed documents far more effectively.

```python
import mineru as mu

result = mu.parse("./research_paper.pdf")
# result.markdown: Clean Markdown for embedding
# result.json: Structured JSON for retrieval
# result.layout: Visual layout for debugging
```

### AI Agent Knowledge Base

For AI agents that need to reason over documents, MinerU provides the cleanest possible input. The removal of headers, footers, and page numbers ensures agents don't get confused by repetitive page artifacts.

### Training Data Production

MinerU was originally built to support InternLM's pre-training pipeline. Its ability to convert complex scientific papers into clean text makes it invaluable for producing high-quality training data for domain-specific LLMs.

### Batch Document Processing

With support for multi-threaded concurrent inference and streaming writes to disk, MinerU can process thousands of documents without manual splitting. The sliding-window mechanism reduces peak memory usage in long-document scenarios.

## Integration Ecosystem

MinerU integrates with virtually every major AI framework:

| Framework | Integration |
|-----------|-------------|
| LangChain | Native document loader |
| LlamaIndex | Document parser integration |
| RAGFlow | Built-in parser |
| RAG-Anything | Pipeline integration |
| Flowise | Visual workflow support |
| Dify | Document processing node |
| FastGPT | Native support |

### MCP Server

MinerU also provides an **MCP Server** for integration with AI coding tools like Cursor, Claude Desktop, and Windsurf. This allows you to parse documents directly within your coding agent's workflow.

```bash
# Start the MCP server
mineru-mcp-server
```

## Performance Benchmarks

MinerU's `pipeline` backend achieves a score of **86.2 on OmniDocBench v1.5**, surpassing the accuracy of the previous-generation VLM model `MinerU2.0-2505-0.9B`.

The Hybrid engine with `effort=medium` delivers:

- **~80% faster** for text PDF scenarios on Linux
- **~90% faster** for text PDF scenarios on Windows
- **~220% faster** for text PDF scenarios on macOS
- Only **0.13-point accuracy drop** compared to `effort=high`

## Why MinerU Stands Out

1. **Built for AI, not humans.** Unlike general-purpose PDF converters, MinerU's output is optimized for LLM consumption — preserving semantic structure while removing noise that confuses AI models.

2. **Multi-format native support.** DOCX, PPTX, XLSX, PDF, images, and web pages — all parsed natively without format conversion intermediaries.

3. **Production-ready at scale.** Multi-threaded concurrency, GPU/CPU flexibility, Docker deployment, and a robust API/CLI/router architecture make MinerU suitable for enterprise workloads.

4. **Open license.** Moved from AGPLv3 to a custom Apache 2.0-based license in version 3.1.0, significantly reducing adoption barriers for both community and commercial use.

5. **Domestic AI chip support.** Compatible with 10+ Chinese AI accelerators including Ascend, Cambricon, Enflame, Moore Threads, and others.

## Getting Started

The easiest way to try MinerU is through the [online web application](https://mineru.net/OpenSourceTools/Extractor?source=github), which offers the same functionality as the desktop client with no installation required.

For developers, the [Colab notebook](https://colab.research.google.com/gist/myhloli/a3cb16570ab3cfeadf9d8f0ac91b4fca/mineru_demo.ipynb) provides a quick interactive demo.

```bash
# Install and parse your first document
pip install mineru
mineru ./my-document.pdf -o ./output/ --format markdown
```

## Limitations

- **Complex layouts:** While MinerU handles most document types well, extremely complex layouts (multi-column scientific papers with interleaved figures and tables) may still require manual review.
- **GPU requirement for VLM:** The VLM engine requires significant VRAM (8GB+ recommended) for optimal performance.
- **Learning curve:** The three-engine architecture and various configuration options can be overwhelming for beginners.

## Conclusion

MinerU represents a significant step forward in document-to-LLM conversion. By combining native multi-format parsing, 109-language OCR, and AI-optimized output formatting, it fills a critical gap in the modern AI data pipeline.

Whether you're building a RAG system, training a domain-specific LLM, or creating a knowledge base for AI agents, MinerU provides the clean, structured input that makes these systems actually work.

With 70,600+ stars, an active development team, and growing framework integrations, MinerU is positioned to become the de facto standard for open-source document parsing in the AI era.

## Resources

- GitHub repository: https://github.com/opendatalab/MinerU
- Documentation: https://opendatalab.github.io/MinerU/
- Online demo: https://mineru.net/OpenSourceTools/Extractor
- Technical report (v3.1): https://arxiv.org/abs/2604.04771
- Technical report (v2.5): https://arxiv.org/abs/2509.22186
- Technical report (v2.0): https://arxiv.org/abs/2409.18839
- HuggingFace demo: https://huggingface.co/spaces/opendatalab/MinerU
- ModelScope demo: https://www.modelscope.cn/studios/OpenDataLab/MinerU
- Discord community: https://discord.gg/Tdedn9GTXq

**Disclosure**: This article contains affiliate links. If you sign up through our links, we may earn a small commission at no additional cost to you. This helps support independent tech journalism and keeps resources like dibi8.com free and ad-free.
