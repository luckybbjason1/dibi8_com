---
title: 'ChatTTS 2026：39.3k 星开源对话式 TTS，带笑声、停顿和 token 级 prosody 控制'
description: 'ChatTTS 是专为对话（不是朗读）打造的开源 TTS。GitHub 39.3k 星，最低 4 GB VRAM，RTX 4090 上 RTF 0.3，含笑声 / 停顿的精细 prosody 控制。2026 完整安装 + 生产设置指南。'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Python
  - PyTorch
  - CUDA
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/2noise/ChatTTS'
stars: 39300
maintainer: '2noise'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['ChatTTS', 'TTS', '语音', '对话', '开源']
aliases:
  - /posts/chattts-dialogue-tts-2026/
---

2026 多数开源 TTS 还是"90 年代 GPS 旁白加点混响"的味道。**ChatTTS** 是第一个被广泛采用的例外 —— 39.3k 星的生成式语音模型，专为**对话**（不是朗读）训练，含 token 级笑声 / 停顿 / 插入语 / prosody 控制，终于跨过"听了不让人皱眉"的门槛。

如果你在搭语音 agent、AI 播客、游戏多角色 TTS，或任何"平淡旁白会毁体验"的语音产品 —— ChatTTS 是 2026 年开源默认选择。

## TL;DR

- **是什么**：2noise 出的开源对话优化 TTS（中英双语）
- **GitHub**：39.3k 星
- **License**：代码 AGPL-3.0 + **模型 CC BY-NC 4.0** —— 开源权重仅非商用
- **VRAM**：30 秒片段最低 4 GB；8 GB 舒服
- **速度**：RTX 4090 RTF（实时因子）~0.3（比实时快）
- **训练数据**：开源版 40,000+ 小时 / 全模型 100,000+ 小时

## 1. ChatTTS 在对话上为何胜过传统 TTS

老分法：
- **拼接式 TTS**（festival 等）—— 机械、无 prosody、在消亡
- **神经 TTS**（Tacotron / FastSpeech / VITS）—— 流畅但单调，为朗读优化
- **商业 API**（ElevenLabs / OpenAI TTS）—— 自然但 $0.18-0.50/千字符，闭源

ChatTTS 处于第 4 类新坑：**带显式 prosody 控制 token 的自回归生成式 TTS**。你不只是打字 —— 可以标 `[laugh]`、`[uv_break]`（嗯）、`[lbreak]`（长停顿），模型产出的是声音表演，不只是说话。

对话用例（语音 agent / AI 播客 / 游戏 NPC 对白），这是"明显机器人"和"可能是电话信号差的真人"的差距。朗读场景下经典神经 TTS 通常还是更好。

## 2. 硬件要求（真实数字）

| 硬件 | 30 秒片段生成时间 | 实际用途 |
|---|---|---|
| 4 GB GPU（GTX 1650 / 3050）| ~25 秒 | 玩票，单片段 |
| 8 GB GPU（RTX 3060 / 4060）| ~10 秒 | 单干 dev，批量任务 |
| 12 GB GPU（RTX 3060 12GB / 4070）| ~5 秒 | 生产，低并发 |
| 24 GB GPU（RTX 4090 / A5000）| ~3 秒 | 生产，高并发 |
| 纯 CPU | ~3-5 分 | 交互用不实用 |

自托管生产入门：$0.30-0.50/小时 GPU 云（Vast.ai / RunPod，或 {{< aff "digitalocean" "chattts-gpu" "DigitalOcean GPU droplet" >}}）—— 任何有意义的量上比 ElevenLabs 便宜很多。

## 3. 快装（GPU 机器 10 分钟）

```bash
git clone https://github.com/2noise/ChatTTS
cd ChatTTS
pip install -r requirements.txt
# 或 pip:
pip install ChatTTS
```

Hello world：
```python
import ChatTTS
import torchaudio
import torch

chat = ChatTTS.Chat()
chat.load(compile=False)  # 首次运行后设 True 提速 ~30%

texts = ["你好，这是对话式 TTS 测试 [uv_break] 听起来自然吗？"]
wavs = chat.infer(texts)

torchaudio.save("out.wav", torch.from_numpy(wavs[0]), 24000)
```

首次运行下 ~2 GB 模型权重。后续秒级。

## 4. Prosody 控制 token（杀手特性）

ChatTTS 听起来有生命的原因 —— 这些标签在文本中间生效：

| 标签 | 效果 |
|---|---|
| `[laugh]` | 插入笑声 |
| `[laugh_0]` 到 `[laugh_2]` | 笑声强度 |
| `[uv_break]` | 嗯式填充停顿 |
| `[lbreak]` | 较长停顿（句式）|
| `[oral_0]` 到 `[oral_9]` | 口语化强度（越高越随意）|
| `[speed_0]` 到 `[speed_9]` | 语速（5 = 正常）|
| `[break_0]` 到 `[break_7]` | 离散停顿时长 |

例：
```python
text = "我跟他说 [uv_break] 这不可能是真的 [laugh] [lbreak] 但他坚持。"
wavs = chat.infer([text])
```

这是关上"机器人 vs 人"差距的关键。少用，过度标会变排练腔。

## 5. 多说话人 —— 跨 session 稳定声音

ChatTTS 默认每次调用生成不同"说话人"。要一致角色（NPC 声音 / 持久 agent 人格），预先 seed 一个说话人复用：

```python
# 生成并保存稳定说话人
rand_spk = chat.sample_random_speaker()
torch.save(rand_spk, "speaker_alice.pt")

# 后续调用用
spk = torch.load("speaker_alice.pt")
params_infer_code = ChatTTS.Chat.InferCodeParams(spk_emb=spk)
wavs = chat.infer(texts, params_infer_code=params_infer_code)
```

模式：setup 时预生成 5-10 个不同说话人 embedding。每个角色配一个。整个生产中声音保持稳定。

## 6. 许可证警告（生产前必读）

**两个 license，两套义务**：
- **代码**：AGPL-3.0 —— 强 copyleft，衍生作品必须以 AGPL 开源
- **模型权重**：CC BY-NC 4.0 —— **仅非商用**

商业生产：联系 2noise 拿模型商业授权，或基于 ChatTTS 开源架构从头微调自己的模型（工作量大但法律干净）。

玩票、研究、内部工具、多数 agent 原型：NC 许可没问题。

这是唯一采用门槛。若产品直接靠生成语音变现，把许可成本算进去（或换商业友好替代品如 Coqui XTTS-v2）。

## 7. 生产模式

agent 语音 / 播客管线：

```
   文本输入（来自 LLM agent / 脚本生成器）
            │
            ▼
   轻预处理（按规则加 prosody 标签）
            │
            ▼
   ChatTTS 推理（GPU 后端 FastAPI service）
            │
            ▼
   输出音频（WAV / Opus / 流式）
            │
            ▼
   可选后处理（响度归一 / 降噪）
```

跑在带 GPU 的 {{< aff "htstack" "chattts-vps-hk" "HTStack 香港 GPU VPS" >}} 或 Vast.ai 实例上，FastAPI 暴露，你的 stack 每分钟生成成本 ~$0.001（vs ElevenLabs ~$0.30/分）。

## 8. 何时用 ChatTTS vs 替代品

| 场景 | 挑 |
|---|---|
| 对话 / 多角色 / agent 语音 | **ChatTTS** |
| 有声书旁白（单声 / 长篇）| Coqui XTTS-v2 或商业 |
| 30 秒样本语音克隆 | OpenVoice 或 Coqui XTTS-v2 |
| 最低延迟（<200ms）实时 agent | 商业（Deepgram Aura / ElevenLabs Flash）|
| 不计成本要最高质量旁白 | ElevenLabs |
| 商业用，必须拥有模型 | 微调的 Coqui XTTS-v2 |

## 9. 坑

1. **过度标 prosody** —— 到处洒 `[laugh]` 和 `[uv_break]` 听起来很排练。少即多
2. **忘 seed 说话人** —— 没 `spk_emb` 的每次调用都是不同声音。永远预生成
3. **在 CPU 跑还抱怨速度** —— 没 GPU 时 RTF 差 30-100×。租 GPU 就完事
4. **忽视 NC 许可** —— 用 ChatTTS 做付费语音产品有法律风险

## TL;DR

ChatTTS = **第一个把对话处理得有说服力的开源 TTS**。39.3k 星，4 GB VRAM 起步，通过控制 token 感知 prosody，通过 embedding seed 稳定说话人。用于语音 agent / AI 播客 / NPC。商用注意 CC BY-NC 许可。

开个 GPU 实例，跑第 3 节 10 行安装，5 分钟内你就听到为啥它取代了讨论里所有其他开源 TTS。

---

*dibi8 多模态内容 stack 的一部分 —— 看即将上线的多模态内容 Pipeline 合集，ChatTTS + Whisper + Stable Diffusion + ComfyUI 完整音视频创作管线。*
