---
title: 'Supertonic 评测：99M 参数本地 TTS，31 语言、ONNX 跑 CPU（2026）'
description: 'Supertonic（GitHub 9.9K+ stars）由韩国语音 AI 公司 Supertone Inc. 推出，是 2026 年最具说服力的本地多语种 TTS 模型。9900 万参数、31 种语言（含韩语/日语/越南语/中文）、44.1kHz 录音棚级音质、10 个表情标签，通过 ONNX Runtime 跑在 CPU 上——无云端、无 API、无 GPU。Python、Node.js、浏览器（WebGPU/WASM）、iOS、Android、Rust、Flutter 全平台 SDK。完整功能拆解、安装、代码示例与 2026 本地 TTS 横向对比。'
date: 2026-05-23 00:00:00+08:00
lastmod: 2026-05-23 00:00:00+08:00
tech_stack: []
application_domain: AI Tools
source_version: 'v2.0.0'
licensing_model: Open Source
license_type: MIT (code) / OpenRAIL-M (model)
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/supertone-inc/supertonic'
stars: 9900
maintainer: 'supertone-inc'
last_maintained: '2026-01-06'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['supertonic', 'text-to-speech', 'tts', 'on-device-ai', 'onnx', 'multilingual', 'open-source-tts', 'edge-ai', 'korean-tts', 'japanese-tts']
aliases:
- /zh/posts/supertonic-on-device-multilingual-tts-2026/
---

## 本地 TTS 的真问题

过去很多年，"好用的多语种 TTS"基本等价于调别人家的云 API——Google Cloud TTS、Amazon Polly、ElevenLabs、OpenAI Voice。声音自然，宽带下延迟可以接受，按字符计费的单价小到没人在意，直到月底账单出来。

裂缝出现在三个地方。**隐私**——医疗、法律、任何受监管的场景，不可能把每段脚本都发给第三方。**延迟抖动**——网络一卡，声音就断。**规模成本**——一旦每月合成超过 100 小时音频，按字符计费的账单立刻变成大头。再加上**离线场景**——车载、飞行中、偏远厂区、自助终端，必须本地推理，没得商量。

开源本地 TTS 一直在追赶，但权衡很扎眼：要么是英文专用的小模型（Piper、Coqui 的小变体），要么是必须上 GPU 才能跑出实用速度的多语种巨无霸（XTTS-v2、Bark）。"又快、又多语种、又轻量、还是真开源权重"这个甜蜜点一直没人击中。

[**Supertonic**](https://github.com/supertone-inc/supertonic)（GitHub：`supertone-inc/supertonic`，**9,900+ stars**）由韩国语音 AI 公司 Supertone Inc. 推出，是 2026 年最有希望补上这块缺口的项目。9900 万参数、31 种语言、ONNX runtime、CPU 上跑得很舒服——README 里甚至给出在飞行模式下的电纸书上跑出 0.3× 实时因子的数据。

---

## Supertonic 到底是什么

一个 flow-matching 文本到 latent 模块，配上一个语音 autoencoder，整体导出为 ONNX。具体看：

- **总参数 9900 万**——加载只要几秒，普通 CPU 上实时跑。作为参照，XTTS-v2 约 15 亿、Bark 约 9 亿。
- **开箱即用 31 种语言**：阿拉伯语、保加利亚语、克罗地亚语、捷克语、丹麦语、荷兰语、英语、爱沙尼亚语、芬兰语、法语、德语、希腊语、印地语、匈牙利语、印尼语、意大利语、**日语**、**韩语**、拉脱维亚语、立陶宛语、波兰语、葡萄牙语、罗马尼亚语、俄语、斯洛伐克语、斯洛文尼亚语、西班牙语、瑞典语、土耳其语、乌克兰语、**越南语**。
- **44.1kHz 音频输出**——真正的录音棚级采样率，不是大多数"够用就行" TTS 妥协的 22kHz。
- **10 个表情标签**——`<laugh>`、`<breath>`、`<sigh>` 等。直接内联在文本里，无需重训声音克隆就能让语气更自然。
- **`lang="na"` 模式**——不想指定语言代码时的语言无关生成。

协议：**代码 MIT，模型权重 OpenRAIL-M**。两边分开很关键：OpenRAIL-M 是"负责任 AI"协议，限制部分有害用途，但允许商业部署。发产品前请先读 model card。

---

## 性能数字

Supertone Inc. 在 benchmark 和 README 里给出的数字：

| 指标 | Supertonic | 常见基准 |
|---|---|---|
| 参数量 | 99M | 0.7B–2B |
| 朗读准确率（Minimax-MLS-test WER/CER） | 与大很多的模型相当 | — |
| 运行时内存 | 显著低于 GPU 基准 | — |
| Onyx Boox Go 6 电纸书飞行模式 RTF | 0.3× | n/a（跑不动） |
| CPU 延迟 | 可与 A100 GPU 基准抗衡 | — |

电纸书那个 benchmark 是头号宣传数字——这种数字传达的信号是"对，它真的哪都能跑"。现代手机 CPU 应该完全无压力。

---

## 运行时覆盖

Supertonic 是少数几个真正提供 SDK 绑定的开源 TTS，不是"你大概可以自己包一层"那种。截至 v2.0.0：

- **Python**（`pip install supertonic`）——主要集成方式
- **Node.js**——server 和 Electron app
- **浏览器**——WebGPU 可用时优先，WebAssembly 兜底
- **Java**——Android 和 JVM 后端
- **C++**、**C#**、**Go**、**Rust**——系统级集成
- **Swift / iOS**——一等公民原生绑定
- **Flutter**——跨平台移动

基本覆盖了 2026 年应用开发者可能想嵌 TTS 的所有地方。重活由 ONNX runtime 扛，Supertonic 提供模型相关的胶水代码。

---

## 快速上手（Python）

```bash
pip install supertonic
```

依赖就这一个。模型在首次调用时下载：

```python
from supertonic import TTS

tts = TTS(auto_download=True)
style = tts.get_voice_style(voice_name="M1")

text = "Supertonic is a lightning fast, on-device TTS system."

wav, duration = tts.synthesize(
    text=text,
    lang="en",
    voice_style=style,
    total_steps=8,
    speed=1.05,
)
tts.save_audio(wav, "output.wav")
```

中文把 `lang="en"` 换成 `lang="zh"`，韩语 `ko`、日语 `ja`、越南语 `vi`。声音风格（这里的 `M1`）跨语言保持一致——做多语种角色配音时很有用。

表情标签的用法：

```python
text = "I can't believe it. <laugh> That's incredible. <breath> Let me explain."
```

模型会内联解释标签，并在音频里产出对应的表达。

---

## 横向对比

2026 年的本地 TTS 战场，按实际交付能力排序：

### 对比 Piper（40K+ stars）
Piper 是本地 TTS 的老牌选手。**Piper 赢在**：单 voice 模型更小（几 MB），纯英文场景部署更简单。**Supertonic 赢在**：语种多得多、表情控制好得多、采样率更高、一个模型搞定所有语言而不是一种语言一个模型。

### 对比 XTTS-v2（Coqui）
XTTS-v2 有声音克隆，Supertonic 没主打这个。**XTTS-v2 赢在**：声音克隆质量。**Supertonic 赢在**：CPU 上的可用性、多运行时 SDK、模型体积、协议清晰度。

### 对比 Bark（Suno）
Bark 在非语音音频（音乐、音效）上有亮点。**Bark 赢在**：超越语音的风格化范围。**Supertonic 赢在**：速度、可部署性、31 种语言 vs Bark 的英文为主。

### 对比 ElevenLabs / OpenAI / Google Cloud
云端 TTS 在声音克隆保真度和顶级语音的纯自然度上仍然领先。**Supertonic 赢在**：没 API key、没按字符账单、不依赖网络、完整隐私。

---

## Supertonic 做不到什么

把期待校准好：

- **不支持从样本克隆声音。** 只能从内置 voice style 里选。需要克隆请看 XTTS-v2 或商业 API。
- **没有 token-by-token 流式合成**（公开版本里）——合成以片段为单位。
- **微调工具有限。** 模型权重以 OpenRAIL-M 开放，但训练 pipeline 没完全公开。
- **没有 22kHz 降级输出。** 永远是 44.1kHz。要低带宽你自己重采样。

---

## Supertonic 真正发光的场景

- **带语音功能的移动 app**——新手引导旁白、无障碍朗读、语言学习。打包一个 ONNX 文件，支持 31 种语言，二进制里也不用塞 API key。
- **医疗和法律工具**——敏感文档的语音播报，数据不出设备。
- **车载和机载系统**——完全离线，不用考虑网络降级。
- **韩语 / 日语 / 越南语 / 中文本地化**——开源 TTS 在亚洲语言上的窟窿一直很疼；Supertonic 用一个模型补掉了一大块。
- **边缘 IoT 设备**——自助终端、数字标牌、不连云端的智能音箱。

---

## 谁该用

**装上 Supertonic，如果你：**
- 发的 app 需要语音输出，又不想要随用量增长的云账单。
- 需要隐私（受监管行业）或离线（移动、机载、边缘）。
- 做非英语市场本地化，宁愿一个模型搞定也不想要 30 个。
- 想在没 GPU 的情况下拿到 44.1kHz 录音棚级音质。

**继续用云 TTS，如果你：**
- 需要从 30 秒样本克隆声音。
- 做超写实单角色内容，ElevenLabs 顶级线还领先。
- 需要流式部分音频（Supertonic 公开版还没开放）。

---

## 结论

Supertonic 是 2026 年最有说服力的"一个模型走天下"开源 TTS。9900 万参数足迹、31 种语言、多运行时 SDK，再加上电纸书上 0.3× RTF，把它牢牢钉在"是的，可以塞进移动 app 发版"这一档——几乎没有哪个之前的开源 TTS 真正做到。

对韩国、日本、越南或任何 TTS 长期被冷落的语言市场的开发者来说，更大的故事是：开源 TTS 与云 API 之间的质量差距正在急速收窄。五年前，英语是唯一一个开源 TTS 真能上生产的语言。2026 年，靠 Supertonic，这份名单终于真的覆盖了世界上大部分语言。

再搭一个[本地 LLM 运行时](https://dibi8.com/zh/resources/llm-frameworks/local-llm-runner-comparison-2026/)处理 prompt 侧，你就拥有了一套完全本地、零云依赖的语音 agent 栈。

---

**GitHub**：[supertone-inc/supertonic](https://github.com/supertone-inc/supertonic) · **协议**：MIT（代码）/ OpenRAIL-M（权重）· **最新**：v2.0.0（2026-01-06）· **Stars**：9.9K+ · **维护方**：Supertone Inc.
