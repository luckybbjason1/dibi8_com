---
title: "PageIndex：29K⭐革命性 RAG 系统，不用向量数据库也能做文档检索"
description: "PageIndex 是 VectifyAI Open Source的向量无关、推理驱动 RAG 系统。29K+ Stars，通过构建文档树结构实现人类般的检索，在 FinanceBench 达到 98.7% 准确率。"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Go
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
- /zh/posts/pageindex-vectorless-reasoning-rag/
faqs:
  - q: 'PageIndex 是什么？它和传统 RAG 有何不同？'
    a: 'PageIndex 是 VectifyAI 开源的 RAG 系统，无需向量数据库即可检索信息。它不对文档做嵌入和分块，而是为每篇文档构建一棵层级树结构，并利用 LLM 推理来遍历这棵树，模拟人类专家阅读目录、定位相关章节的方式。'
  - q: 'PageIndex 需要向量数据库或文档分块吗？'
    a: '不需要。PageIndex 把两者都省掉了。它不存储向量嵌入，从而避免了高昂的向量存储成本；它也不对文档分块，因此能保留文档天然的逻辑结构，而不是把它切碎。'
  - q: 'PageIndex 在 FinanceBench 基准测试上的准确率如何？'
    a: 'PageIndex 搭配 GPT-4 在 FinanceBench 上达到 98.7% 的准确率，属于 state-of-the-art 水平。PageIndex 搭配 Claude-3 达到 97.2%，而传统向量 RAG 在同一基准上的得分约为 79-82%。'
  - q: '我该如何安装 PageIndex 并运行一次基础查询？'
    a: '用 `pip install pageindex` 安装。然后用 `pi = PageIndex()` 初始化，通过 `pi.load_pdf("file.pdf")` 加载文档，再用 `result = pi.query("your question")` 进行查询。返回结果中既包含答案，也包含页码、章节等引用来源。'
  - q: 'PageIndex 最适合处理哪类文档？'
    a: 'PageIndex 专为那些结构很重要、且需要可解释引用的长篇专业文档而设计，例如财报和招股说明书、法律合同和判例法、医学文献和临床试验报告，以及 API 参考、操作手册等技术文档。'
---
{</* resource-info */>}

![PageIndex 官方 hero banner](/images/articles/pageindex-vectorless-reasoning-rag/banner.png)
*来源：[github.com/VectifyAI/PageIndex](https://github.com/VectifyAI/PageIndex) — 官方 banner*

## PageIndex 是什么？

**PageIndex** 是由 **VectifyAI** 开发的Open Source RAG（检索增强生成）系统，它彻底改变了传统文档检索的方式。与传统向量数据库不同，PageIndex 使用**推理驱动**的方法，通过构建文档的**层次树结构**来实现人类般的检索。

- 🌲 **树结构索引** — 像目录一样组织文档
- 🧠 **推理驱动检索** — LLM 推理而非向量相似度
- ❌ **无需向量数据库** — 省去昂贵的向量存储成本
- ❌ **无需分块** — 保持文档自然结构
- 📊 **98.7% 准确率** — FinanceBench 基准测试 SOTA

GitHub: https://github.com/VectifyAI/PageIndex  
Stars: **29,202+** | 语言: Python | 协议: Apache-2.0

---

## 为什么传统 RAG 不够好？

### 传统向量 RAG 的问题

| 问题 | 说明 |
|------|------|
| **相似度 ≠ 相关性** | 向量搜索找语义相似的，但不一定是真正相关的 |
| **分块破坏结构** | 强制分块会切断文档逻辑结构 |
| **黑盒检索** | 向量搜索不可解释，无法追溯为什么返回这个结果 |
| **成本高昂** | 需要维护向量数据库，存储和计算成本高 |
| **长文档效果差** | 专业长文档（财报、法律文件）检索精度低 |

### PageIndex 的解决方案

PageIndex 模拟**人类专家**阅读文档的方式：
1. 先看目录结构（树索引）
2. 根据问题推理应该去哪个章节
3. 在相关章节中深入查找

---

## 核心技术原理

### 1. 文档树结构生成

PageIndex 将 PDF 转换为层次化的树结构：

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

### 2. 推理驱动的树搜索

当用户提问时，LLM 会：
1. **理解问题** — 分析查询意图
2. **遍历树结构** — 推理哪些节点可能包含答案
3. **深入相关节点** — 在候选节点中查找具体信息
4. **返回结果** — 附带引用来源（页码、章节）

### 3. 与 AlphaGo 类似的蒙特卡洛树搜索

PageIndex 受 AlphaGo 启发，使用**树搜索算法**：
- **选择** — 选择最有希望的节点
- **扩展** — 展开子节点
- **评估** — LLM 评估节点相关性
- **回溯** — 更新节点权重

---

## 快速开始

### 安装

```bash
# 克隆仓库
git clone https://github.com/VectifyAI/PageIndex.git
cd PageIndex

# 安装依赖
pip3 install --upgrade -r requirements.txt
```

### 配置 API Key

```bash
# 创建 .env 文件
echo "OPENAI_API_KEY=your_openai_key_here" > .env
```

### 生成文档树

```bash
# 为 PDF 生成 PageIndex 树结构
python3 run_pageindex.py --pdf_path /path/to/your/document.pdf
```

### 可选参数

```bash
--model                  # LLM 模型（默认: gpt-4o-2024-11-20）
--toc-check-pages       # 检查目录的页数（默认: 20）
--max-pages-per-node    # 每节点最大页数（默认: 10）
--max-tokens-per-node   # 每节点最大 token（默认: 20000）
--if-add-node-summary   # 添加节点摘要（默认: yes）
```

---

## 实战示例

### 示例 1：金融文档分析

```python
from pageindex import PageIndex

# 加载文档树
pi = PageIndex(tree_path="financial_report.json")

# 查询
result = pi.query(
    "What was the Q3 revenue growth rate?",
    top_k=3
)

print(result.answer)
# "Q3 revenue grew by 23% year-over-year, driven by cloud services..."

print(result.sources)
# [{"page": 45, "section": "Financial Results", "node_id": "0012"}]
```

### 示例 2：法律合同审查

```python
# 加载合同文档
pi = PageIndex(tree_path="contract.pdf.json")

# 查询特定条款
result = pi.query(
    "What are the termination conditions in Section 7?"
)

# PageIndex 会自动定位到相关章节
```

### 示例 3：学术论文研究

```python
# 加载论文
pi = PageIndex(tree_path="paper.pdf.json")

# 跨章节推理查询
result = pi.query(
    "How does the methodology in Section 3 relate to the results in Section 5?"
)

# PageIndex 会遍历树结构，找到关联信息
```

---

## 与竞品对比

| 特性 | PageIndex | 传统向量 RAG | LlamaIndex | LangChain |
|------|-----------|--------------|------------|-----------|
| 向量数据库 | ❌ 不需要 | ✅ 必需 | ✅ 必需 | ✅ 必需 |
| 分块 | ❌ 不需要 | ✅ 必需 | ✅ 必需 | ✅ 必需 |
| 推理驱动 | ✅ | ❌ | ❌ | ❌ |
| 可解释性 | ✅ 可追溯 | ❌ 黑盒 | ⚠️ 部分 | ⚠️ 部分 |
| 长文档 | ✅ 优秀 | ⚠️ 一般 | ⚠️ 一般 | ⚠️ 一般 |
| 专业文档 | ✅ 优秀 | ⚠️ 一般 | ⚠️ 一般 | ⚠️ 一般 |
| 准确率 | ✅ 98.7% | ~75% | ~80% | ~78% |

---

## 商业模式与赚钱机会

### 1. 企业级文档分析

PageIndex 的 Apache-2.0 协议允许商业使用：
- **金融分析** — 自动分析财报、SEC 文件
- **法律咨询** — 合同审查、案例研究
- **医疗文档** — 病历分析、医学文献
- **政府文件** — 政策分析、法规检索

### 2. 构建 SaaS 产品

基于 PageIndex 构建：
- **智能文档问答平台**
- **企业知识库系统**
- **自动报告生成器**
- **合规审查工具**

### 3. 咨询服务

提供 PageIndex 相关：
- **技术咨询**
- **定制开发**
- **培训服务**

---

## 性能基准

### FinanceBench 测试结果

| 系统 | 准确率 |
|------|--------|
| **PageIndex (Mafin 2.5)** | **98.7%** |
| 传统向量 RAG | ~75% |
| 其他商业方案 | ~80% |

PageIndex 在金融文档问答上达到 **state-of-the-art**，证明了推理驱动检索的优越性。

---

## 部署选项

### 1. 自托管（Open Source）

```bash
git clone https://github.com/VectifyAI/PageIndex.git
pip3 install -r requirements.txt
python3 run_pageindex.py --pdf_path your.pdf
```

适合：技术团队、数据敏感场景

### 2. 云服务

- **Chat 平台**: https://chat.pageindex.ai
- **API**: https://pageindex.ai/developer
- **MCP 集成**: 支持 Claude、Cursor 等

适合：快速启动、生产环境

### 3. 企业版

- 私有化部署
- 定制 OCR 管道
- 专属支持

---

## 社区与资源

- **GitHub**: https://github.com/VectifyAI/PageIndex
- **文档**: https://docs.pageindex.ai
- **博客**: https://pageindex.ai/blog
- **Discord**: https://discord.com/invite/VuXuf29EUj
- **API**: https://pageindex.ai/developer

---

## 总结

PageIndex 是 RAG 技术的下一代演进：

✅ **29K+ Stars** — 社区认可  
✅ **无需向量 DB** — 省去昂贵基础设施  
✅ **推理驱动** — 真正理解文档结构  
✅ **98.7% 准确率** — 业界领先  
✅ **可解释** — 每次检索都可追溯  
✅ **Open Source** — Apache-2.0，商业友好  

**适合谁？**
- 金融分析师：处理财报、SEC 文件
- 法律顾问：审查合同、法规
- 研究人员：分析论文、文献
- 开发者：构建文档 AI 应用

**立即开始**: https://github.com/VectifyAI/PageIndex

---

## Related Articles

- [Goose AI Agent: Open Source AI 代理，自动化代码和工作流](/zh/resources/llm-frameworks/goose-ai-agent-open-source-automation/) — 另一个Open Source AI 工具
- [Free Claude Code: 让 Claude Code CLI 免费使用的Open Source代理工具](/zh/resources/ai-tools/free-claude-code-open-source-proxy/) — AI 编码工具
- [Agent Reach: 让你的 AI Agent 一键连接互联网](/zh/resources/llm-frameworks/agent-reach-ai-agent-internet-access/) — 让 AI 连接互联网
- [42 Real-World OpenClaw Use Cases: 人们如何在Daily Life中使用 AI 代理](/zh/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/) — AI 代理用例

---


---

## 推荐自托管基础设施

要 7×24 稳定跑这套，服务器选择很关键：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心。开源 AI 工具自托管首选。
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — 香港 VPS，国内访问低延迟。**这就是 dibi8.com 自家所在的 IDC**，生产环境已验证。

*以上为推广链接，不会增加你的成本，但能支持 dibi8.com 持续运营。*

*Last updated: 2026-05-07*
