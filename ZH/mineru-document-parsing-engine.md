---

lang: zh
title: 'MinerU：70.6K 星 — 将任何文档转换为 LLM 就绪的 Markdown'
description: 'MinerU（70,600+ GitHub star）将 PDF、DOCX、PPTX、XLSX、图像和网页转换为结构化 Markdown 和 JSON，用于 LLM、RAG 和 Agent 工作流程。 支持 109 种语言的 OCR、公式到 LaTeX、表格到 HTML，并在 CPU 或 GPU 上运行。'
tags: ["guide", "open-source", "ai-agents", "rag", "pdf", "ocr", "reference", "tutorial"]
date: 2026-06-27 00:00:00+08:00
slug: 'mineru-document-parsing-engine'
category: ai-tools
github_repo: 'https://github.com/opendatalab/MinerU'
license: MinerU Open Source License (Apache 2.0-based)
lang: zh
featureImage: /images/articles/mineru-docs.png

---


![MinerU logo](https://gcore.jsdelivr.net/gh/opendatalab/MinerU@master/docs/images/MinerU-logo.png)

*MinerU — 开源文档解析引擎，在短短一年多的时间里就获得了 70,600 颗 GitHub 星。*

在 AI 编码代理和 RAG 管道时代，最大的瓶颈不是模型能力，而是**数据质量**。 你可以拥有世界上最强大的法学硕士，但如果你的输入文档是凌乱的 PDF，其中有损坏的表格、难以阅读的公式和乱码标题，那么输出将是垃圾。

输入 **MinerU**，这是来自 OpenDataLab（InternLM 背后的团队）的文档解析工具，可将 PDF、DOCX、PPTX、XLSX、图像和网页转换为**干净、结构化的 Markdown 和 JSON** — 专为下游 LLM、RAG 和 Agent 工作流程而设计。

凭借**70,600+ GitHub 星**、**5,900 个分叉**和**仅今天就获得了 960 颗星**，MinerU 已迅速成为文档到 LLM 管道转换的首选开源解决方案。

## What Is MinerU?

MinerU诞生于中文大语言模型[InternLM](https://github.com/InternLM/InternLM)的预训练过程中。 该团队注意到，将科学论文和技术文档转换为机器可读的格式是一个巨大的难题，尤其是对于公式、表格和复杂的布局。

所以他们建立了MinerU。

与仅提取原始文本的传统 PDF 解析器不同，MinerU 了解文档结构：

- **删除**破坏语义一致性的页眉、页脚、脚注和页码
 - **保留**单列、多列和复杂布局的阅读顺序
 - **将**公式转换为 LaTeX，将表格转换为 HTML
 - **检测**扫描和乱码的 PDF 并自动启用 OCR
 - **支持** 109种语言进行OCR识别
 - **输出** 多模式 Markdown、NLP Markdown 和按阅读顺序排序的 JSON

结果是人工智能代理和法学硕士可以真正理解的文档内容。

## Installation and Setup

MinerU根据您的需求提供多种安装路径：

### pip（推荐给大多数用户）

```bash
pip install mineru
```

### 码头工人

```bash
docker pull mineru/mineru:latest
docker run --gpus all -v $(pwd):/data mineru/mineru:latest
```

### 本地发展

```bash
git clone https://github.com/opendatalab/MinerU.git
cd MinerU
pip install -e .
```

MinerU 支持 **仅 CPU** 和 **GPU 加速** 推理。 对于 GPU 加速，请安装 CUDA 支持：

```bash
pip install mineru[cuda]
```

在配备 Apple Silicon 的 macOS 上，MinerU 利用 MPS（金属性能着色器）进行加速。

## Three Parsing Engines

MinerU提供了三种不同的解析后端，每种都针对不同的场景进行了优化：

### 1. Pipeline后端（快速稳定）

“管道”后端是大多数用户的默认选择。 它快速、稳定并且不会产生幻觉。 它在 CPU 上高效运行，非常适合批处理。

```bash
mineru ./input.pdf -o ./output/
```

**最适合：** 大容量文档处理、CI/CD 管道、仅 CPU 环境。

### 2.VLM引擎（高精度）

VLM（视觉语言模型）引擎使用 MinerU 专有的“MinerU2.5-Pro-2604-1.2B”模型来实现最先进的解析精度。 它擅长处理具有混合布局、手写文本和密集公式的复杂文档。

```bash
mineru ./complex.pdf -o ./output/ --engine vlm-engine
```

**最适合：** 复杂的科学论文、扫描文档、手写内容、多语言 OCR。

### 3.混合动力发动机（平衡）

“混合”引擎将本机文本提取与基于 VLM 的分析相结合。 从 3.3 版本开始，它包含了一个“effort”参数，分为“medium”和“high”级别：

- **中等努力：** 比高速度快 35-220%，OmniDocBench 上的准确度仅下降 0.13 点
 - **高强度：** 通过图像分析支持实现最高准确度

```bash
mineru ./document.pdf -o ./output/ --engine hybrid-engine --effort medium
```

**最适合：** 您需要平衡速度和准确性的生产工作负载。

## Supported Formats

MinerU 支持多种输入格式：

| Format | Support Level | Notes |
|--------|--------------|-------|
| PDF | Native | Text PDFs, scanned PDFs, garbled PDFs |
| DOCX | Native | Full structural preservation |
| PPTX | Native | Slides, layouts, embedded content |
| XLSX | Native | Tables, formulas, charts |
| Images | OCR | JPEG, PNG, TIFF, BMP, and more |
| Web Pages | Scraping | Full-page conversion to Markdown |

原生 DOCX、PPTX 和 XLSX 支持（在版本 3.1.0 中添加）意味着 MinerU 可以**直接**解析这些格式，而无需先转换为 PDF - 与传统工作流程相比，速度显着提高。

## OCR: 109 Languages

MinerU 的 OCR 引擎支持 **109 种语言**，并在 3.4 版本中升级至 PP-OCRv6，在 OmniDocBench v1.6 基准测试中准确率提高了约 11%。

从3.4版本开始，MinerU简化了OCR语言配置。 现在，所有场景都通过优化的“ch” OCR 模型进行路由，而不是选择单独的语言（日语、繁体中文、英语、拉丁语），从而降低了配置复杂性，同时提高了准确性。

```bash
# Automatic OCR detection (recommended)
mineru ./scanned.pdf -o ./output/

# 对特定文档强制进行 OCR
 ./document.pdf -o ./output/ --ocr
 ````

## Real-World Use Cases

### RAG 管道数据准备

MinerU 专为 RAG（检索增强生成）工作流程而构建。 通过将文档转换为结构化 Markdown 并保留阅读顺序、标题和语义结构，RAG 系统可以更有效地分块和嵌入文档。

```python
import mineru as mu

结果 = mu.parse("./research_paper.pdf")
 # result.markdown：清理 Markdown 以进行嵌入
 # result.json：用于检索的结构化 JSON
 # result.layout：用于调试的可视化布局
 ````

### AI代理知识库

对于需要对文档进行推理的人工智能代理，MinerU 提供了最干净的输入。 删除页眉、页脚和页码可确保代理不会因重复的页面工件而感到困惑。

### 训练数据生产

MinerU 最初是为了支持 InternLM 的预训练管道而构建的。 它能够将复杂的科学论文转换为干净的文本，这对于为特定领域的法学硕士生成高质量的培训数据非常有价值。

### 批量文档处理

通过支持多线程并发推理和流式写入磁盘，M​​inerU 可以处理数千个文档，而无需手动拆分。 滑动窗口机制降低了长文档场景下的内存使用峰值。

## Integration Ecosystem

MinerU 与几乎所有主要的人工智能框架集成：

| Framework | Integration |
|-----------|-------------|
| LangChain | Native document loader |
| LlamaIndex | Document parser integration |
| RAGFlow | Built-in parser |
| RAG-Anything | Pipeline integration |
| Flowise | Visual workflow support |
| Dify | Document processing node |
| FastGPT | Native support |

### MCP 服务器

MinerU 还提供 **MCP 服务器**，用于与 Cursor、Claude Desktop 和 Windsurf 等 AI 编码工具集成。 这允许您直接在编码代理的工作流程中解析文档。

```bash
# Start the MCP server
mineru-mcp-server
```

## Performance Benchmarks

MinerU的“pipeline”后端在OmniDocBench v1.5**上取得**86.2的分数，超越了上一代VLM模型“MinerU2.0-2505-0.9B”的准确性。

“effort=medium”的混合引擎可提供：

- Linux 上的文本 PDF 场景 **~80% 提速**
 - 对于 Windows 上的文本 PDF 场景，速度 **~90%**
 - 对于 macOS 上的文本 PDF 场景，速度**~220%**
 - 与“effort=high”相比，准确率仅下降**0.13点**

## Why MinerU Stands Out

1. **专为 AI 而不是人类而构建。** 与通用 PDF 转换器不同，MinerU 的输出针对 LLM 消耗进行了优化 - 保留语义结构，同时消除混淆 AI 模型的噪音。

2. **多格式本机支持。** DOCX、PPTX、XLSX、PDF、图像和网页 - 全部进行本机解析，无需格式转换中介。

3. **大规模生产就绪。** 多线程并发、GPU/CPU 灵活性、Docker 部署以及强大的 API/CLI/路由器架构使 MinerU 适合企业工作负载。

4. **开放许可证。** 在版本 3.1.0 中从 AGPLv3 迁移到基于 Apache 2.0 的自定义许可证，显着减少了社区和商业用途的采用障碍。

5. **国产AI芯片支持。** 兼容Ascend、Cambricon、Enflame、Moore Threads等10+国产AI加速器。

## Getting Started

尝试 MinerU 最简单的方法是通过[在线网络应用程序](https://mineru.net/OpenSourceTools/Extractor?source=github)，它提供与桌面客户端相同的功能，无需安装。

对于开发人员来说，[Colab笔记本](https://colab.research.google.com/gist/myhloli/a3cb16570ab3cfeadf9d8f0ac91b4fca/mineru_demo.ipynb)提供了快速的交互式演示。

```bash
# Install and parse your first document
pip install mineru
mineru ./my-document.pdf -o ./output/ --format markdown
```

## Limitations

- **复杂布局：** 虽然 MinerU 可以很好地处理大多数文档类型，但极其复杂的布局（带有交错图形和表格的多列科学论文）可能仍然需要手动审核。 
- **VLM 的 GPU 要求：** VLM 引擎需要大量 VRAM（建议 8GB+）才能获得最佳性能。 
- **学习曲线：** 三引擎架构和各种配置选项可能会让初学者不知所措。

## Conclusion

MinerU 代表了文档到 LLM 转换的重要一步。 通过结合本机多格式解析、109 种语言 OCR 和 AI 优化的输出格式，它填补了现代 AI 数据管道中的关键空白。

无论您是构建 RAG 系统、培训特定领域的法学硕士，还是为 AI 代理创建知识库，MinerU 都能提供干净、结构化的输入，使这些系统真正发挥作用。

MinerU 拥有超过 70,600 颗星、活跃的开发团队和不断增长的框架集成，有望成为人工智能时代开源文档解析的事实上的标准。

## Resources

- GitHub 存储库：https://github.com/opendatalab/MinerU
 - 文档：https://opendatalab.github.io/MinerU/
 - 在线演示：https://mineru.net/OpenSourceTools/Extractor
 - 技术报告（v3.1）：https://arxiv.org/abs/2604.04771
 - 技术报告（v2.5）：https://arxiv.org/abs/2509.22186
 - 技术报告（v2.0）：https://arxiv.org/abs/2409.18839
 - HuggingFace 演示：https://huggingface.co/spaces/opendatalab/MinerU
 - ModelScope演示：https://www.modelscope.cn/studios/OpenDataLab/MinerU
 - Discord 社区：https://discord.gg/Tdedn9GTXq

**披露**：本文包含附属链接。 如果您通过我们的链接注册，我们可能会赚取少量佣金，而无需您支付额外费用。 这有助于支持独立的科技新闻业，并使 dibi8.com 等资源保持免费且无广告。