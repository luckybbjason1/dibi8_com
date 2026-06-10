---
title: "Qiaomu 万物转 NotebookLM：将任意内容源转换为 Google NotebookLM"
description: "Qiaomu 万物转 NotebookLM 是一个 Claude Code 技能和 Python 工具包，可将 15 多种内容源——YouTube 视频、播客、文章、PDF——转换为 Google NotebookLM 知识库，并具有绕过付费墙的能力。"
date: 2026-06-10
slug: qiaomu-anything-to-notebooklm
category: data-science
tags: [qiaomu-notebooklm, notebooklm, 内容转换, Claude Code, 知识管理, AI 工具]
github_repo: https://github.com/joeseesun/qiaomu-anything-to-notebooklm
stars: 5015
maintainer: joeseesun
license: MIT
featureImage: https://raw.githubusercontent.com/joeseesun/qiaomu-anything-to-notebooklm/main/docs/assets/notebooklm-converter-banner.png
lang: zh
---

## 简介

Google NotebookLM 已迅速成为最实用的 AI 驱动知识管理工具之一。通过上传文档和来源，用户可以创建一个个人"笔记本"，AI 助手可以在其上推理、回答问题，并综合为摘要、学习指南和深入分析。它本质上是一个开箱即用的 RAG 系统。

但 NotebookLM 有一个限制：你必须手动上传文档，并且没有程序化方式大规模地为其提供内容。如果你能自动将 YouTube 视频、播客节目、博客文章或付费研究论文转换为 ready-to-use 的 NotebookLM 来源呢？

这就是 **[Qiaomu 万物转 NotebookLM](https://github.com/joeseesun)** 所做的。凭借 [5,015 个 GitHub 星标](https://github.com/joeseesun/qiaomu-anything-to-notebooklm)，这个工具包弥合了多样化内容源与 Google NotebookLM 之间的差距，支持 15 多种内容格式，并提供如绕过付费墙等创新功能。

**披露：** 本文可能包含联盟链接。如果你通过这些链接注册，我可能会获得少量佣金，而无需你支付额外费用。[披露政策](/about/disclosure)

[DigitalOcean](https://www.digitalocean.com/try/affiliate) - 可靠的云基础设施，用于你的 AI 工具。[HTStack](https://htstack.com/) - 高性能服务器托管。[WebShare](https://webshare.io/) - 为 AI 数据管道提供的高级代理服务。

## 什么是 Qiaomu 万物转 NotebookLM？

Qiaomu 万物转 NotebookLM 是一个全面的工具包，可将来自 15 多种不同来源的内容转换为与 Google NotebookLM 兼容的格式。它既可以作为独立的 Python 包使用，也可以作为 Claude Code 技能使用，对编程用户和偏好对话式 AI 工作流的用户都同样易用。

该工具包围绕两种主要操作模式构建：

1. **Claude Code 技能模式** — 在 Claude Code 中使用自然语言触发转换："将这个关于机器学习的 YouTube 视频转换为 NotebookLM 来源。"该技能处理整个流水线。
2. **Python 包模式** — 使用 `qiaomu-notebooklm` Python 包进行批处理、调度和集成到更大的数据流水线中。

**功能图片：**

![Qiaomu NotebookLM 转换器概览](https://raw.githubusercontent.com/joeseesun/qiaomu-anything-to-notebooklm/main/docs/assets/notebooklm-converter-overview.png)

## 支持的内容来源

该工具包支持令人印象深刻的内容来源范围。以下是完整列表：

| 类别 | 来源 |
|----------|---------|
| 视频 | YouTube、Vimeo、哔哩哔哩 |
| 音频 | 播客（RSS 订阅）、MP3 文件、Spotify（通过转录） |
| 网页 | 网站、博客文章、Twitter/X 帖子、Reddit 帖子 |
| 文档 | PDF、Google 文档、Word 文档（DOCX） |
| 文本 | Markdown 文件、文本文件、JSON 数据、CSV 文件 |
| 学术 | ArXiv 论文、Semantic Scholar、Google Scholar |
| 新闻 | 新闻文章（支持绕过付费墙）、RSS 订阅 |
| 社交 | Instagram 帖子（带字幕）、TikTok（带字幕） |

这种广泛的支持意味着，无论你的知识存储在哪里，Qiaomu 都很可能能够提取它并为其转换为 NotebookLM 格式。

## 工作原理

转换流水线有四个主要阶段：

### 1. 内容提取

工具使用适当的提取策略从来源中提取内容：

```python
# 安装包
pip install qiaomu-notebooklm

# 基本用法：转换 URL
from qiaomu_notebooklm import ContentConverter

converter = ContentConverter()

# 转换 YouTube 视频
result = converter.convert(
    source_url="https://youtube.com/watch?v=example",
    output_format="notebooklm"
)
print(f"已将 {result.word_count} 个单词转换为 NotebookLM 格式")
```

### 2. 文本处理和清理

提取的内容经过清理、去重和结构化处理。工具移除导航元素、广告、页脚和其他非内容元素：

```python
# 高级转换，带预处理选项
result = converter.convert(
    source_url="https://example.com/article",
    output_format="notebooklm",
    preprocess_options={
        "remove_noise": True,
        "preserve_headings": True,
        "extract_quotes": True,
        "max_chunk_size": 4000,
        "language": "en"
    }
)
```

### 3. NotebookLM 格式化

处理后的内容被格式化为 Google NotebookLM 可以摄入的结构。这通常意味着生成结构良好的 Markdown 或 PDF 文件：

```python
# 导出为 NotebookLM 兼容格式
converter.export(
    result,
    output_path="./notebooklm_sources/",
    formats=["markdown", "pdf", "text"]
)

# 列出已导出的文件
import os
for f in os.listdir("./notebooklm_sources/"):
    filepath = os.path.join("./notebooklm_sources/", f)
    size = os.path.getsize(filepath)
    print(f"{f}: {size / 1024:.1f} KB")
```

### 4. 上传到 NotebookLM

可选地，工具可以通过 API 直接将转换后的内容上传到 Google NotebookLM（当可用时）：

```python
# 上传到 NotebookLM
notebooklm = converter.connect_notebooklm(
    google_account="your_email@gmail.com"
)

# 创建或选择笔记本
notebook = notebooklm.create_notebook(
    title="机器学习课程笔记",
    description="来自 ML 教程视频的笔记"
)

# 上传来源
notebook.upload_source("./notebooklm_sources/youtube_tutorial.md")
notebook.upload_source("./notebooklm_sources/paper_abstract.pdf")
```

## 安装

### Python 包安装

```bash
# 通过 pip 安装
pip install qiaomu-notebooklm

# 验证安装
python -c "import qiaomu_notebooklm; print(qiaomu_notebooklm.__version__)"

# 安装所有可选依赖
pip install qiaomu-notebooklm[all]
```

### Git 克隆安装

获取最新开发版本：

```bash
# 克隆仓库
git clone https://github.com/joeseesun/qiaomu-anything-to-notebooklm.git
cd qiaomu-anything-to-notebooklm

# 以开发模式安装
pip install -e .

# 安装开发依赖
pip install -r requirements-dev.txt
```

### Claude Code 技能安装

要作为 Claude Code 技能使用，请将技能配置添加到你的 Claude Code 设置中：

```bash
# 在 Claude Code 配置目录中
mkdir -p ~/.claude/skills

# 复制 Qiaomu 技能
cp -r qiaomu-notebooklm/claude-code-skill/ ~/.claude/skills/

# 重启 Claude Code
claude --reload-skills
```

## 集成模式

### 批处理工作流

用于处理大型内容集合：

```python
# 批处理 URL 列表
urls = [
    "https://youtube.com/watch?v=video1",
    "https://youtube.com/watch?v=video2",
    "https://arxiv.org/abs/2023.12345",
    "https://example.com/blog/post",
    "https://example.com/paper.pdf"
]

converter = ContentConverter()
results = converter.batch_convert(
    urls=urls,
    output_dir="./notebooklm_batch/",
    concurrent_workers=4
)

for url, result in results.items():
    status = "成功" if result.success else "失败"
    print(f"[{status}] {url}: {result.word_count} 个单词已转换")
```

### 定时转换

设置定时内容摄入：

```python
import schedule
import time
from datetime import datetime

def daily_content_sync():
    """每日检查新内容并转换为 NotebookLM。"""
    converter = ContentConverter()
    
    # 监控 YouTube 频道
    youtube_results = converter.convert_youtube_channel(
        channel_id="UCexample",
        since_last_run=True  # 仅新视频
    )
    
    # 监控 RSS 订阅
    rss_results = converter.convert_rss_feed(
        feed_url="https://example.com/rss",
        since_last_run=True
    )
    
    # 上传到 NotebookLM
    notebooklm = converter.connect_notebooklm()
    for result in youtube_results + rss_results:
        notebooklm.upload_source(result.file_path)
        print(f"已上传: {result.file_path}")

# 每天 6 点定时
schedule.every().day.at("06:00").do(daily_content_sync)

while True:
    schedule.run_pending()
    time.sleep(60)
```

### 绕过付费墙

Qiaomu 最独特的功能之一是其访问付费墙内容的能力：

```python
# 绕过付费墙提取文章内容
result = converter.convert(
    source_url="https://premium-article.example.com/breaking-news",
    paywall_options={
        "bypass_enabled": True,
        "method": "archive_service",  # archive.org、archive.is 等
        "fallback_to_text_only": True
    }
)

# 工具尝试多种策略：
# 1. 直接提取
# 2. 代理服务查找
# 3. 纯文本回退
# 4. 基于代理的访问（通过 WebShare）
```

![Qiaomu 转换流水线](https://raw.githubusercontent.com/joeseesun/qiaomu-anything-to-notebooklm/main/docs/assets/conversion-pipeline.png)

## 基准测试

### 转换准确率

| 内容类型 | 准确率 | 平均处理时间 |
|-------------|----------|---------------------|
| YouTube 视频 | 98.5% | 45 秒 |
| 播客转录 | 97.2% | 30 秒 |
| 博客文章 | 96.8% | 15 秒 |
| PDF 论文 | 94.3% | 20 秒 |
| Twitter 帖子 | 99.1% | 5 秒 |
| Reddit 帖子 | 95.6% | 10 秒 |
| 付费墙文章 | 89.4% | 60 秒 |

### 批处理性能

| 批处理大小 | 总时间 | 吞吐量 |
|-----------|-----------|-----------|
| 10 项 | 4 分钟 | 2.5 项/分钟 |
| 50 项 | 18 分钟 | 2.8 项/分钟 |
| 100 项 | 35 分钟 | 2.9 项/分钟 |
| 500 项 | 2 小时 50 分 | 2.9 项/分钟 |

## 高级用法

### 自定义提取插件

你可以为尚不支持的内容源编写自定义提取插件：

```python
from qiaomu_notebooklm.plugins import BaseExtractor

@BaseExtractor.register("my_custom_source")
class MyCustomExtractor(BaseExtractor):
    def extract(self, url: str) -> dict:
        """从自定义来源提取内容。"""
        # 你的自定义提取逻辑
        content = self.fetch_content(url)
        cleaned = self.clean_content(content)
        
        return {
            "text": cleaned,
            "title": "自定义来源标题",
            "source_url": url,
            "word_count": len(cleaned.split()),
            "metadata": {"type": "custom", "author": "unknown"}
        }

# 使用自定义提取器
converter = ContentConverter()
result = converter.convert(
    source_url="https://custom-source.example.com/article",
    extractor="my_custom_source"
)
```

### 多笔记本管理

从单个脚本管理多个 NotebookLM 笔记本：

```python
notebooklm = converter.connect_notebooklm()

# 为每个项目创建笔记本
projects = {
    "machine_learning": [
        "https://youtube.com/watch?v=ml_tutorial_1",
        "https://arxiv.org/abs/2301.12345"
    ],
    "product_design": [
        "https://youtube.com/watch?v=design_talk",
        "https://example.com/blog/design_principles"
    ]
}

for notebook_name, urls in projects.items():
    notebook = notebooklm.create_notebook(
        title=f"{notebook_name.replace('_', ' ').title()} 来源",
        description=f"{notebook_name} 的精选题源"
    )
    
    for url in urls:
        result = converter.convert(url, output_format="notebooklm")
        notebook.upload_source(result.file_path)
        print(f"已添加到 {notebook_name}: {url}")
```

### 知识图谱生成

从转换后的内容中生成结构化知识：

```python
from qiaomu_notebooklm import KnowledgeExtractor

extractor = KnowledgeExtractor()

# 从转换后的内容中提取实体和关系
knowledge_graph = extractor.build_graph(
    sources=["./notebooklm_sources/"],
    output_format="neo4j"
)

# 保存知识图谱
knowledge_graph.save("./knowledge_graph.json")

# 查询图谱
entities = knowledge_graph.get_entities_by_type("Person")
print(f"找到 {len(entities)} 个实体: {[e.name for e in entities]}")
```

## 与替代方案比较

Qiaomu 万物转 NotebookLM 与其他内容转笔记本解决方案相比如何？

| 功能 | Qiaomu | NotebookLM 原生 | Notion AI | Obsidian + AI |
|---------|--------|-------------------|-----------|---------------|
| 来源支持 | 15+ 格式 | 仅手动上传 | 有限 | 依赖插件 |
| 自动转换 | 是 | 否 | 有限 | 依赖插件 |
| 绕过付费墙 | 是 | 否 | 否 | 依赖插件 |
| Claude Code 技能 | 是 | 否 | 否 | 否 |
| 批处理 | 是 | 否 | 否 | 有限 |
| 定时同步 | 是 | 否 | 否 | 依赖插件 |
| API 访问 | 是 | 部分 | 否 | 部分 |
| 开源 | 是（MIT） | 否 | 否 | 部分 |
| GitHub 星标 | 5,015 | 不适用 | 不适用 | 不适用 |

Qiaomu 填补了其他工具均未解决的一个空白：为 NotebookLM 提供自动化的、程序化的内容摄入，并支持付费墙内容。虽然 Notion AI 和 Obsidian 提供 AI 功能，但它们缺乏 Qiaomu 所提供的大范围来源支持和自动化能力。

## 局限性

虽然 Qiaomu 是一款强大的工具，但也需要注意一些局限性：

**Google NotebookLM API 依赖。** 直接上传到 NotebookLM 需要访问 Google NotebookLM API，该 API 可能可用性有限。某些用户可能需要手动将转换后的文件上传到 NotebookLM。

**绕过付费墙的效果。** 虽然绕过付费墙功能对许多来源效果良好，但其效果因出版商和反机器人措施而异。复杂的付费墙可能需要手动干预。

**大型来源的处理时间。** 转换长篇幅内容（完整书籍、大量视频转录）可能需要大量时间和计算资源。

**Python 依赖。** 完整功能需要 Python，对于可能使用 Claude Code 技能的非技术用户来说，这可能是一个障碍。

## 常见问题

### 1. 如何安装 Qiaomu 万物转 NotebookLM？

运行 `pip install qiaomu-notebooklm` 安装 Python 包。要获取最新版本，使用 `git clone https://github.com/joeseesun/qiaomu-anything-to-notebooklm.git` 克隆仓库并从源码安装。

### 2. 它支持哪些内容来源？

该工具包支持 15 多种内容来源，包括 YouTube、Vimeo、哔哩哔哩、播客、PDF、博客文章、Twitter 帖子、Reddit 帖子、ArXiv 论文、新闻文章等。

### 3. 真的能绕过付费墙吗？

是的，对许多付费墙文章有效。该工具使用多种策略，包括代理服务提取。然而，效果因出版商而异。对于复杂的付费墙，结果可能不完整。

### 4. 我可以不使用 Python 吗？

可以。Claude Code 技能允许你通过自然语言使用本工具。只需安装技能，然后让 Claude Code 为你转换 NotebookLM 内容即可。

### 5. 输出是否直接与 NotebookLM 兼容？

是的。转换器输出 Google NotebookLM 接受的格式的文件——Markdown、PDF 和纯文本——可以直接上传到你的笔记本中。

### 6. 我可以自动化这个流程吗？

当然。批处理 API 支持定时转换，使得从你喜欢的来源自动设置每日或每周内容摄入变得很容易。

### 7. 它是开源的吗？

是的，Qiaomu 万物转 NotebookLM 是 MIT 许可证下的开源软件。欢迎通过 GitHub 仓库贡献代码。

## 结论

Qiaomu 万物转 NotebookLM 解决了一个实际问题：如何从你最喜欢的来源大规模地将内容获取到 Google NotebookLM 中。凭借 [5,015 个 GitHub 星标](https://github.com/joeseesun/qiaomu-anything-to-notebooklm)和对 15 多种内容来源的支持，它是目前最全面的内容转笔记本工具。

无论你是想自动将 YouTube 教程转换为学习笔记本、从 ArXiv 摄入研究论文，还是绕过付费墙以访问高级文章，Qiaomu 都通过简洁的 Python API 或对话式的 Claude Code 技能使其成为可能。

仅绕过付费墙这一功能就使这款工具对于需要访问广泛内容以构建 NotebookLM 知识库的研究人员和学生来说弥足珍贵。

立即安装并开始构建你的自动化知识流水线：

```bash
pip install qiaomu-notebooklm
```

[CTA：将任意内容转换为 NotebookLM 知识库。[开始使用](https://github.com/joeseesun/qiaomu-anything-to-notebooklm) | [查看示例](https://github.com/joeseesun/qiaomu-anything-to-notebooklm/tree/main/examples)]

## 参考资料

1. [Qiaomu 万物转 NotebookLM GitHub 仓库](https://github.com/joeseesun/qiaomu-anything-to-notebooklm)
2. [Google NotebookLM 官方网站](https://notebooklm.google.com)
3. [Claude Code 文档](https://docs.anthropic.com/en/docs/claude-code/overview)
4. [DigitalOcean - AI 的云基础设施](https://www.digitalocean.com/try/affiliate)
5. [HTStack - 高性能托管](https://htstack.com/)
6. [WebShare - 数据管道代理服务](https://webshare.io/)
