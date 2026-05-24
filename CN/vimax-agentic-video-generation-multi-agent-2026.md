---
title: 'ViMax 评测：HKUDS 出品的智能体多场景视频生成框架（导演·编剧·制片·生成器，2026）'
description: 'ViMax（GitHub 7.1K+ stars）由香港大学数据科学实验室推出，是首个被广泛采纳的开源智能体视频生成框架。不再像 Sora、Runway 那样一句 prompt 直出短片，它把四个 AI 角色——导演、编剧、制片、视频生成器——编排起来，从一个想法生成长篇多场景视频。完整拆解智能体流水线、支持的后端（Gemini Flash、MiniMax、Google Veo）、安装步骤、idea-to-video 与 script-to-video 工作流，并诚实对比 Sora、OpenSora、Runway。'
date: 2026-05-23 00:00:00+08:00
lastmod: 2026-05-23 00:00:00+08:00
tech_stack: []
application_domain: AI Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/HKUDS/ViMax'
stars: 7100
maintainer: 'HKUDS'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['vimax', 'agentic-video', 'ai-video-generation', 'hkuds', 'multi-agent', 'veo', 'long-form-video', 'video-ai', 'open-source-video', 'rag-screenwriting']
aliases:
- /zh/posts/vimax-agentic-video-generation-multi-agent-2026/
---

## 2025 年压垮 AI 视频的三道天花板

2024–2025 年间所有冲进消费者视野的 AI 视频生成工具——Sora、Runway Gen-3、Pika、Luma Dream Machine、OpenSora——共享三道同样的天花板：

1. **只能出短片。** 5–10 秒是实际上限。再长一点，一致性就崩。
2. **一致性灾难。** 同一个角色换个镜头脸就变；同一个房间道具来回重排。单 prompt 流水线根本没有"这是场景 1 里那只狗"这种概念。
3. **只有画面。** 没有剧本、没有叙事弧线、没有同步音轨。你拿到的是会动的好看图片，不是一部*片子*。

做短视频片段，这些限制还能忍。一旦想用 AI 真的*讲个故事*——讲解视频、教育内容、品牌叙事——只要用户希望场景 2 在逻辑上接着场景 1，整条流水线就当场断掉。

**[ViMax](https://github.com/HKUDS/ViMax)**（GitHub：`HKUDS/ViMax`，**截至 2026 年 5 月 7,100+ stars**）由香港大学数据科学实验室推出，是首个被广泛采纳的开源尝试，思路是把视频生成当成*多智能体编排问题*，而不是一次性生成问题，来打破上面这三道天花板。

它的 slogan 说得很直接：**"Director, Screenwriter, Producer, and Video Generator All-in-One."**

---

## 四个智能体角色

ViMax 的架构赌注是：现实世界里的视频制作本来就是多角色流水线，那 AI 视频制作也应该是。框架定义了四个自主智能体角色，每个都有不同的 LLM 驱动任务：

### 🎬 编剧 Screenwriter
把一个高层想法（"一只猫和一只狗成为朋友，后来遇到一只新猫"）展开成*完整的结构化剧本*——角色、场景切分、对白、转场。背后是**基于 RAG 的长剧本引擎**，能把冗长故事智能切成多场景结构。这一层是分钟级长视频能讲通的关键。

### 🎭 导演 Director
把剧本翻译成*镜头级分镜*。决定多机位布置、构图、节奏、场景转场。输出明确的镜头描述，给下游生成器去渲染。

### 🎯 制片 Producer
一致性引擎。挑选参考图、用 MLLM（多模态 LLM）一致性校验确保同一个角色在不同镜头里长得一样，编排资源。这一层专门解决"角色重排"那个老问题。

### 🎥 视频生成器 Video Generator
最后的渲染层。并行生成镜头，为每一帧合成图像，再把帧拼成视频。真正的像素级生成委托给底层模型（Veo 等）来做。

每个角色都是一个独立的 LLM 智能体，自带 prompt、自带上下文窗口、自带确定性输出契约——教科书级的 [12-Factor Agents](https://dibi8.com/zh/resources/llm-frameworks/12-factor-agents-production-llm-software-2026/) 第 10 条（"小而专注的智能体"）应用。

---

## 技术栈

- **语言**：Python 3.12，用 `uv` 管理依赖。
- **多智能体框架**：自研编排层。
- **支持的 chat 模型**：Google Gemini 2.5 Flash Lite（通过 OpenRouter）、MiniMax-M2.7（1M 上下文）、MiniMax-M2.5（204K 上下文）。长上下文窗口在这里很重要——编剧 Agent 需要把整部剧本都放在工作记忆里。
- **图像生成**：Google Nanobana API。
- **视频生成**：Google Veo API。
- **协议**：MIT——代码很宽松；上游模型 API 各自有商业条款。

把像素级生成委托给商用 API（Veo、Nanobana）这个选择是诚实的。开源视频模型的视觉质量还没追上前沿商用模型，硬装作追上了只会毁掉 demo。ViMax 的贡献是*编排*——像素引擎你自己挑。

---

## 快速上手

```bash
git clone https://github.com/HKUDS/ViMax.git
cd ViMax
uv sync
```

依赖安装就这两行。你需要至少一个 chat 模型的 API key（OpenRouter 接 Gemini 就行），再加 Google 的 Veo + Nanobana 做视频和图像生成。

### Idea-to-Video 工作流

```python
idea = "If a cat and a dog are best friends, what would happen when they meet a new cat?"
user_requirement = "For children, do not exceed 3 scenes."
style = "Cartoon"
# Run: python main_idea2video.py
```

编剧把想法展开成 3 个场景的剧本。导演规划镜头。制片选参考图并强制一致性。视频生成器渲染每个场景并拼接。

### Script-to-Video 工作流

如果你已经有现成剧本，`main_script2video.py` 直接吃剧本，跳过编剧那一步。其余三个 Agent 照跑。

---

## 它与 Sora、Runway、OpenSora 的差别

| 维度 | ViMax | Sora / Runway / OpenSora |
|---|---|---|
| **流水线** | 多智能体（剧本 → 分镜 → 素材 → 视频） | 直接 prompt → 视频 |
| **叙事** | 基于 RAG 的结构化剧本生成 | 单 prompt，无剧本结构 |
| **一致性** | 制片 Agent + MLLM 校验 + 参考图筛选 | 镜头间帧级漂移 |
| **时长** | 多场景，分钟级以上 | 秒级短片 |
| **创作可控** | 单 Agent 可覆盖（重写剧本、重做分镜） | 有限，主要靠事后剪辑 |
| **音频** | 音视频同步绑定 | 视频为主 |
| **开源** | 是（MIT） | OpenSora 是；Sora / Runway 否 |

诚实的反方：Sora 和 Runway 在单镜头像素级质量上肉眼可见地更强。ViMax 赢在*跨镜头一致性*。要做 10 秒技术 demo，选 Sora；要做 90 秒讲解视频、第 4 个场景里那只狗还得是同一只狗，那 ViMax 这种编排才是你要的。

---

## ViMax 不是什么

把预期校准好：

- **不是一个完全开源的视频模型。** 它编排的是对商用视频/图像模型的调用。要做端到端自托管，得等开源视频模型这一层追上来。
- **不是无代码工具。** 当下的界面就是 Python 脚本加配置文件。智能体部分很精巧，但 UX 还是"研究者原型"。
- **还没有正式 release。** main 分支 329 个 commit，没打 tag。准备好接受 API 频繁变动。
- **README 里没有性能 benchmark。** ViMax 主打的是*定性*优势（一致性、长度、叙事），定量的消融实验暂未公开。
- **对 Google API 有硬依赖。** Veo 和 Nanobana 不免费也不开源，预算要算上。

---

## 真实使用场景

ViMax 这套智能体流水线真正能挪动指针的地方：

- **教育 / 讲解视频**——多场景、角色连续、叙事结构。经典的"老师讲解 + 动画示例"格式。
- **儿童内容**——同一组角色跨场景的小故事（README 里的示例用法）。
- **营销分镜**——从一份 campaign brief 生成完整剧本+分镜，给营销团队过审后再走（更贵的）生成步骤。
- **长一点的社媒内容**——60–90 秒、有完整微叙事的 TikTok / Reels 内容（区别于已经刷烂的 5 秒单镜头片段）。
- **影视前期可视化（previs）**——可负担、能保持角色一致性、能真服务于制作规划的前期预览。

对这些场景来说，*没有* ViMax 时的备选要么是昂贵的真人制作，要么是撑不起一个故事的短片 AI 工具。

---

## ViMax 在 2026 年 AI 视频版图里的位置

可以把 ViMax 和以下组件搭配：
- **图像生成器**——已经内置（Nanobana），也可以换成 Stable Diffusion / ComfyUI 跑自托管的[图像生成工作流](https://dibi8.com/zh/resources/ai-tools/comfyui-architecture-node-based-ai-image/)。
- **配音 TTS**——[Supertonic](https://dibi8.com/zh/resources/ai-tools/supertonic-on-device-multilingual-tts-2026/) 提供端侧多语种语音；和 ViMax 搭起来就是完整的带旁白视频流水线。
- **长上下文 LLM**——MiniMax-M2.7 的 1M 上下文是跑全长剧本的实战选择。12-Factor 那条"自己管好上下文窗口"在这里特别适用——编剧 Agent 正是上下文纪律最关键的地方。

ViMax + Supertonic + 开源图像生成，是 2026 年最接近"描述一部电影，得到一部电影"的流水线，而且大部分环节都在用户自己手里。

---

## 谁该试 ViMax

**装上，如果你：**
- 需要叙事连贯、30 秒以上的视频。
- 接受为最终生成付 Google API 的钱，但希望编排层在自己手里。
- 在研究多智能体创意工作流，需要一个参考实现。
- 给客户做内容工具，需要一条能在几分钟内产出可由人复核的草样的流水线。

**跳过，如果你：**
- 只要 10 秒单镜头视频，Sora/Runway 已经够用。
- 受不了研究者级别的 Python 工具链。
- 需要完全端到端自托管（再等开源视频模型一轮迭代）。

---

## 结论

ViMax 是 2026 年最有说服力的证据：**AI 视频质量的下一跳不是更大的模型，而是更好的编排**。把视频制作当成多智能体问题、分出导演 / 编剧 / 制片 / 生成器四个独立角色，HKUDS 打开了单 prompt 扩散模型从根本上交付不了的"长篇连贯视频"。

MIT 协议 + HKUDS 的学术背景 + 几个月攒出来的 7,100 stars，指向一个开源视频社区等了很久的工具。它还很早期——没有正式 release、没有 benchmark、强依赖商用 API——但架构方向是对的。期待这种模式（用智能体编排生成模型）在未来 12 个月里扩散到每一个创意 AI 垂类。

如果你拍过任何一部带剧本的视频，这套 AI 工作流终于第一次和真实创作流程对上号了。

---

**GitHub**：[HKUDS/ViMax](https://github.com/HKUDS/ViMax) · **协议**：MIT · **Stars**：7.1K+ · **作者**：香港大学数据科学实验室 · **状态**：积极开发中，尚无正式 tag release
