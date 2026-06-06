---
title: Pixelle-Video 评测：AI 全自动短视频生成引擎，输入主题自动生成完整视频
description: Pixelle-Video 是一款开源 AI 全自动短视频生成引擎，输入主题即可自动生成文案、AI 配图、语音解说和背景音乐的完整视频。
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Python
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "27.1 MB"
file_md5: ''
download_url: https://github.com/AIDC-AI/Pixelle-Video
backup_url: ''
github_repo: https://github.com/AIDC-AI/Pixelle-Video
stars: 18065
maintainer: "AIDC-AI"
last_maintained: "2026-05-06"
featureImage: ''
draft: false
aliases:
- /zh/posts/pixelle-video-ai-short-video-generator/
faqs:
  - q: 'Pixelle-Video 是什么？'
    a: 'Pixelle-Video 是一款开源、MIT 授权的 AI 引擎，能将单个主题自动生成完整的短视频。只需输入一个主题，它就会自动撰写脚本、生成配套 AI 图片或视频、用 TTS 合成配音，并在渲染最终视频前添加背景音乐。'
  - q: 'Pixelle-Video 是免费开源的吗？'
    a: '是的。Pixelle-Video 由 AIDC-AI 以 MIT 许可证发布，可免费自行部署。本地部署除需要 GPU 外无额外费用；如果没有本地硬件，也可以选择使用 RunningHub 等按需付费的云服务来生成图像。'
  - q: 'Pixelle-Video 支持哪些 AI 模型？'
    a: '脚本生成方面支持 OpenAI GPT-4o/GPT-4o-mini、阿里巴巴通义千问、DeepSeek V3/R1 以及本地 Ollama 模型。图像生成方面支持 FLUX、Stable Diffusion、Qwen、Nano Banana 和 RunningHub。语音合成方面支持 Edge-TTS、Index-TTS 和 ChatTTS。'
  - q: '如何安装和运行 Pixelle-Video？'
    a: '使用 git 克隆仓库，运行 pip install -r requirements.txt，将 API 密钥填入 config.json，然后执行 python webui.py 启动界面。Gradio Web UI 将在 http://localhost:7860 打开，在那里输入主题、选择声音和模板，点击 Generate Video 即可生成视频。'
  - q: 'Pixelle-Video 除基础视频生成外还能做什么？'
    a: '它包含三个扩展模块：数字人 Avatar，可将一张照片转换为支持韩语、中文或英语的唇形同步讲话头像视频；Image-to-Video，可将静态图片制作成动态视频；Motion Transfer，可将参考视频中的动作映射到静止图像上。'
---
{</* resource-info */>}

![Pixelle-Video Web UI：视频脚本 / 配音 / 分镜 / 生成结果](/images/articles/pixelle-video-ai-short-video-generator/webui.png)
*来源：[github.com/AIDC-AI/Pixelle-Video](https://github.com/AIDC-AI/Pixelle-Video) — 官方 Web UI*

## Pixelle-Video 是什么？

**Pixelle-Video** 是一款开源的 AI 全自动短视频生成引擎。只需输入一个**主题**，它就能自动完成整个视频制作流程：

- ✍️ **AI 智能文案** — 根据主题自动生成解说词
- 🎨 **AI 配图/视频** — 为每句话生成匹配的 AI 插图或动态视频
- 🗣️ **AI 语音合成** — 将文案转换为自然语音解说
- 🎵 **背景音乐** — 自动添加 BGM 增强氛围
- 🎬 **一键合成视频** — 自动渲染最终视频

**零门槛，零剪辑经验** — 视频创作变成一句话的事！

🔗 **GitHub**: [https://github.com/AIDC-AI/Pixelle-Video](https://github.com/AIDC-AI/Pixelle-Video)

---

## 核心功能亮点

| 功能 | 说明 |
|------|------|
| **全自动生成** | 输入主题 → 获得完整视频 |
| **AI 智能文案** | AI 自动写解说词，无需手动写脚本 |
| **AI 生成配图** | 每句话都配上精美的 AI 插图 |
| **AI 生成视频** | 支持 WAN 2.1 等视频模型创建动态内容 |
| **多 TTS 支持** | Edge-TTS、Index-TTS 等众多语音合成方案 |
| **背景音乐** | 支持添加 BGM，让视频更有氛围 |
| **视觉模板** | 多种模板可选，打造独特视频风格 |
| **灵活尺寸** | 支持竖屏、横屏等多种视频尺寸 |
| **多种 AI 模型** | GPT、通义千问、DeepSeek、Ollama 等 |
| **ComfyUI 架构** | 模块化设计，可自定义任意能力 |

---

## 视频生成流程

Pixelle-Video 采用模块化设计，整个视频生成流程清晰简洁：

**文案生成 → 配图规划 → 逐帧处理 → 视频合成**

每个环节都支持灵活定制，可选择不同的 AI 模型、音频引擎、视觉风格等，满足个性化创作需求。

---

## 扩展模块

除了基础视频生成，Pixelle-Video 还提供强大的扩展功能：

### 👤 数字人口播
上传照片，生成带口型同步的说话视频。支持韩语、中文、英语等多语言。

### 🖼️ 图生视频
将静态图片转换为动态视频，使用 AI 视频生成模型。

### 💃 动作迁移
上传参考视频和图片，将动作迁移到图片上 — 比如让照片里的人跟着视频跳舞。

---

## 支持的 AI 模型

### LLM（文案生成）
- OpenAI GPT-4o / GPT-4o-mini
- 阿里通义千问
- DeepSeek V3 / R1
- Ollama（本地部署）
- 自定义 API 端点

### 图像生成
- FLUX（通过 ComfyUI）
- Stable Diffusion
- 通义千问图像生成
- RunningHub 云服务
- Nano Banana 模型

### TTS（语音合成）
- Edge-TTS（免费，多语言）
- Index-TTS（声音克隆）
- ChatTTS
- 自定义 ComfyUI TTS 工作流

---

## 快速入门

### 1. 克隆仓库

```bash
git clone https://github.com/AIDC-AI/Pixelle-Video.git
cd Pixelle-Video
```

### 2. 安装依赖

```bash
pip install -r requirements.txt
```

### 3. 配置 API 密钥

编辑 `config.json` 填入你的 API 密钥：

```json
{
  "llm": {
    "api_key": "你的API密钥",
    "base_url": "https://api.openai.com/v1",
    "model": "gpt-4o"
  },
  "image": {
    "comfyui_url": "http://127.0.0.1:8188"
  }
}
```

### 4. 启动 Web 界面

```bash
python webui.py
```

浏览器打开 `http://localhost:7860`

### 5. 生成你的第一个视频

1. 输入主题，如"为什么要养成阅读习惯"
2. 选择喜欢的 TTS 音色
3. 选择视觉模板
4. 点击"生成视频"
5. 等待 2-5 分钟获得完整视频

---

## 使用场景

| 场景 | 示例主题 |
|------|---------|
| **知识分享** | "Python 新手必知的 10 个技巧" |
| **产品评测** | "iPhone 16 vs 三星 S24 对比" |
| **故事讲述** | "一个创业者的旅程" |
| **教育内容** | "区块链是如何工作的？" |
| **新闻评论** | "2026 年 AI 发展趋势" |
| **书评/影评** | "《原子习惯》的启示" |

---

## 视频风格示例

Pixelle-Video 支持多种视频风格：

- 🌄 **人文纪实类** — 旅行、自然、人文故事
- 🔍 **文化解构类** — 深度解读趋势和现象
- 🔭 **科学思辨类** — 复杂概念简单讲
- 🌱 **个人成长类** — 自我提升、效率提升
- 🧠 **深度思考类** — 心理学、哲学、反思
- 🏯 **历史文化类** — 古人智慧、历史事件
- ☀️ **情感类** — 暖心故事、励志内容
- 📜 **小说解说类** — 小说评论、人物分析
- 🧬 **知识科普类** — 医学常识、健康知识

---

## 技术架构

Pixelle-Video 基于 **ComfyUI** 架构构建：

- **模块化工作流** — 每个组件（LLM、TTS、图像生成）都是独立节点
- **可定制流水线** — 轻松替换任何模型或服务
- **API 优先设计** — 所有能力通过 REST API 暴露
- **Web 界面** — 基于 Gradio 的易用界面
- **批量处理** — 同时生成多个视频

---

## 性能与成本

| 方案 | 成本 | 速度 | 质量 |
|------|------|------|------|
| **本地部署** | 免费（需要 GPU） | 快 | 高 |
| **RunningHub 云端** | 按量付费 | 即时 | 高 |
| **混合模式** | 灵活 | 均衡 | 高 |

新手推荐配置：
- LLM: DeepSeek API（便宜，质量好）
- 图像: RunningHub（无需本地 GPU）
- TTS: Edge-TTS（免费，多语言）

---

## 与其他工具对比

| 功能 | Pixelle-Video | HeyGen | Synthesia | Pictory |
|------|--------------|--------|-----------|---------|
| **开源** | ✅ | ❌ | ❌ | ❌ |
| **免费使用** | ✅ | 有限 | 有限 | 有限 |
| **本地部署** | ✅ | ❌ | ❌ | ❌ |
| **自定义模型** | ✅ | ❌ | ❌ | ❌ |
| **ComfyUI 集成** | ✅ | ❌ | ❌ | ❌ |
| **声音克隆** | ✅ | ✅ | ✅ | ❌ |
| **数字人** | ✅ | ✅ | ✅ | ❌ |
| **动作迁移** | ✅ | ❌ | ❌ | ❌ |

---

## 最佳实践技巧

1. **主题具体化** — 越具体的主题，生成的脚本越好
2. **模板匹配** — 根据内容风格选择合适的模板
3. **提示词前缀** — 使用英文提示词前缀保持图像风格一致
4. **语音预览** — 生成完整视频前先预览 TTS 效果
5. **批量生成** — 同时生成 3-5 个版本，挑选最好的

---

## 相关文章

- [Free Claude Code：让 Claude Code CLI 免费使用的开源代理工具](/zh/resources/ai-tools/free-claude-code-open-source-proxy/) — 免费 AI 编程助手
- [Agent Reach：让你的 AI Agent 一键连接互联网](/zh/resources/llm-frameworks/agent-reach-ai-agent-internet-access/) — AI 智能体联网工具

---

## 总结

**Pixelle-Video** 将 LLM、图像生成、TTS 和视频剪辑整合为单一自动化流水线，让视频创作民主化。无论你是内容创作者、教育工作者、营销人员还是开发者，这款工具都能节省大量视频制作时间。

基于 ComfyUI 的架构意味着它不只是黑盒工具 — 你可以自定义每个组件、替换模型、构建自己的视频生成工作流。

**最适合**：需要快速视频制作的内容创作者、教育工作者、营销人员、开发者

**GitHub**: [https://github.com/AIDC-AI/Pixelle-Video](https://github.com/AIDC-AI/Pixelle-Video)

---

*最后更新：2026-05-06*

---

## 推荐工具

跑或部署开源 AI 工具时，推荐：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心，AI 工作流 droplet 一键部署。
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Claude / OpenAI / DeepSeek API 中转。上面的 AI 工具 (chatbot / 代码生成 / 翻译 / 搜索 等) 大多需要 LLM API key — 这个中转给你稳定访问顶级模型, 价格约官方 30%。

*推广链接 — 不增加你的成本，能支持 dibi8.com 持续运营。*

