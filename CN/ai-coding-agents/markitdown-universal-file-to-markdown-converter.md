---


title: "Full installation with all format support"
description: "You have a PDF, a Word doc, a PowerPoint, an Excel spreadsheet — maybe even a scanned image with handwritten notes"
date: 2026-09-20
slug: "markitdown-universal-file-to-markdown-converter"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---



th--.png

* * *
## Introduction

You have a PDF, a Word doc, a PowerPoint, an Excel spreadsheet — maybe even a scanned image with handwritten notes. You need the text inside. Not the formatting. Not the layout. Just the content, clean and structured, ready for an LLM to digest.

For years, the answer was "buy a commercial API" or "write your own parser for each format." Neither scales. Neither is free.

MarkItDown solves this. Microsoft's AutoGen team built a single Python tool that converts 20+ file types to clean Markdown — PDFs, Word docs, PowerPoints, Excel sheets, images with OCR, audio with transcription, HTML, CSV, JSON, XML, ZIP archives, YouTube URLs, EPUBs, and more. 153,000+ GitHub stars. MIT licensed. Zero configuration.

This is the tool you install once and never think about again. Until you need it — and then it saves you hours.

![MarkItDown — Microsoft's universal file-to-Markdown converter](https://opengraph.github.com/github/microsoft/markitdown)

## What Is MarkItDown?

MarkItDown is a Python utility library and CLI tool developed by Microsoft's AutoGen team. It converts arbitrary files and documents into Markdown format optimized for LLM consumption. Unlike general-purpose converters that preserve visual formatting, MarkItDown focuses on semantic content extraction — the text, tables, lists, and metadata that an LLM actually needs to understand.

The key insight: LLMs don't need pixel-perfect rendering. They need structured text. Markdown is the closest thing LLMs have to a native language — they've been trained on billions of Markdown documents and understand it natively. MarkItDown bridges the gap between "I have a file" and "I have text my LLM can reason about."

````bash
pip install 'markitdown[all]'
`````

That's the entire installation. The ``[all]`` extras bundle covers all supported file formats. Individual format extras are also available: `````bash
pip install 'markitdown[pdf,docx,pptx]'
`````

Install only what you need to keep dependencies lean.

## How MarkItDown Works

MarkItDown uses a plugin-based architecture. Each file format has a dedicated extractor that handles format-specific parsing: `````
Input File ──► Format Detector ──► Format-Specific Parser ──► Markdown Output
                │                      │
                │                  PDF → PyMuPDF
                │                  DOCX → python-docx
                │                  PPTX → python-pptx
                │                  XLSX → openpyxl
                │                  Images → pytesseract (OCR)
                │                  Audio → speech recognition
                │                  HTML → BeautifulSoup
                │                  YouTube → yt-dlp + transcript API
                ▼
         Unsupported → Raw text fallback
`````

The format detector examines file headers (magic bytes) and extensions to route to the correct parser. If neither matches, it falls back to treating the file as raw text — which handles obscure formats gracefully.

Each parser extracts content semantically: tables become Markdown tables, headings become ````#```` markers, lists become ````-```` bullets. The output is clean, token-efficient Markdown that preserves document structure without visual noise.

## Installation & Setup

### Quick Start (Recommended)

`````bash
# Full installation with all format support
pip install 'markitdown[all]'

# Verify installation
markitdown --version
`````

### Using uv (Fastest)

`````bash
uv venv --python=3.12 .venv
source .venv/bin/activate
uv pip install 'markitdown[all]'
`````

### From Source (Development)

`````bash
git clone git@github.com:microsoft/markitdown.git
cd markitdown
pip install -e 'packages/markitdown[all]'
`````

### Optional Dependencies

Install specific format support to reduce dependencies: `````bash
# PDF support only
pip install 'markitdown[pdf]'

# Document suite
pip install 'markitdown[docx,pptx,xlsx]'

# Image + audio (includes OCR and speech recognition)
pip install 'markitdown[images,audio]'
`````

### Docker Deployment

`````bash
docker pull ghcr.io/microsoft/markitdown:latest
docker run -v $(pwd):/data markitdown /data/document.pdf > output.md
`````

## Integration with Mainstream Tools

### LangChain Integration

`````python
from langchain_community.document_loaders import MarkItDownLoader

loader = MarkItDownLoader("report.pdf")
documents = loader.load()

for doc in documents: print(doc.page_content[:500])
`````

### LlamaIndex Integration

`````python
from llama_index.readers.markitdown import MarkItDownReader

reader = MarkItDownReader()
documents = reader.load_data("presentation.pptx")
`````

### Unstructured.io Pipeline

`````python
from unstructured.partition.auto import partition

# MarkItDown complements unstructured.io
# Use MarkItDown for clean Markdown output,
# unstructured for chunking and metadata extraction
`````

### Haystack Document Store

`````python
from haystack.document_stores import InMemoryDocumentStore
from markitdown import MarkItDown

md = MarkItDown()
result = md.convert("annual_report.docx")

doc_store = InMemoryDocumentStore()
doc_store.write_documents([
    {"content": result.text_content, "metadata": result.metadata}
])
`````

### Vector Database Pipeline (RAG)

`````python
from markitdown import MarkItDown
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma

# Convert file to Markdown
md = MarkItDown()
converted = md.convert("technical_spec.pdf")

# Split into chunks for embedding
splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
)
chunks = splitter.split_text(converted.text_content)

# Create embeddings and store in vector DB
embeddings = OpenAIEmbeddings()
vectorstore = Chroma.from_texts(chunks, embeddings)

# Query
results = vectorstore.similarity_search("What are the API rate limits?")
`````

## Benchmarks & Real-World Use Cases

### Conversion Accuracy by File Type

| File Type | Accuracy | Notes |
| 