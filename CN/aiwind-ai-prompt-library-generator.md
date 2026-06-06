---
title: AiWind：1000+ AI 绘画提示词宝库，让 GPT-Image 2 和 Nanobanana 产出惊艳作品
description: AiWind 是一个免费 AI 提示词库，收录 1000+ 针对 GPT-Image 2、Nanobanana、Stable Diffusion、Midjourney
  等主流模型的专业提示词，覆盖写实肖像、赛博朋克、3D 渲染等多种风格。
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Go
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: ''
last_maintained: '2026-05-15'
featureImage: ''
draft: false
aliases:
- /posts/aiwind-ai-prompt-library/
faqs:
  - q: 'Is AiWind free to use?'
    a: 'Yes, AiWind is a completely free AI prompt library at aiwind.org with no paid tiers. It offers over 1000 professional prompts and is continuously updated.'
  - q: 'Which AI image models does AiWind support prompts for?'
    a: 'AiWind covers 10+ models including GPT-Image 2, Nanobanana, Stable Diffusion, Midjourney, Flux-Kontext, Tencent Hunyuan, Google Imagen, and ByteDance Seedream. Each prompt entry recommends which models it works best with.'
  - q: 'What art styles are available in the AiWind prompt library?'
    a: 'AiWind organizes prompts into styles such as realistic portraits, cyberpunk, 3D rendering (Pixar-style), landscape photography, food photography, fashion editorial, anime, Chinese traditional (guofeng), surrealism, and infographics. Prompts can be filtered by style, model, or keyword.'
  - q: 'What CFG Scale and step settings does AiWind recommend for Stable Diffusion?'
    a: 'The article recommends a CFG Scale of 7-12, 20-50 sampling steps, the DPM++ 2M Karras sampler, and a resolution of 1024x1024 or higher. These parameters balance prompt adherence with image quality.'
  - q: 'How does AiWind compare to PromptHero, Lexica, and Civitai?'
    a: 'AiWind stands out for fully free access, strong Chinese-language support, and coverage of 10+ models, whereas Lexica covers about 3 models and Civitai focuses mainly on Stable Diffusion. AiWind, PromptHero, and Civitai all support community prompt submissions, while Lexica does not.'
---

{</* resource-info */>}

## 问题：为什么你的 AI 绘画总是"差点意思"？

你花了大价钱订阅了 GPT-Image 2、Midjourney 或 Stable Diffusion，但生成的图片总是：

- 人物表情僵硬，像塑料模特
- 风景缺乏层次感，像贴图拼接
- 风格不统一，前后矛盾
- 细节缺失，放大后惨不忍睹

**问题不在模型，而在提示词。**

大多数人写提示词就像在说："画一个漂亮女孩"。但 AI 需要知道：什么风格？什么光线？什么构图？什么情绪？

## 什么是 AiWind？

[AiWind](https://aiwind.org/) 是一个**免费 AI 提示词库**，收录了 **1000+ 专业级 AI 绘画提示词**，专门针对主流 AI 图像生成模型优化。

### 支持的模型

| 模型 | 类型 | 特点 |
|------|------|------|
| **GPT-Image 2** | OpenAI | 语义理解强，文字渲染好 |
| **Nanobanana** | 国产 | 中文支持优秀，速度快 |
| **Stable Diffusion** | 开源 | 可定制性强，生态丰富 |
| **Midjourney** | 商业 | 艺术感强，美学在线 |
| **Flux-Kontext** | 开源 | 上下文理解，连贯性好 |
| **Hunyuan** | 腾讯 | 中文场景优化 |
| **Imagen** | Google | 照片级真实感 |
| **Seedream** | 字节 | 移动端优化 |

### 覆盖的风格分类

- **写实肖像** — 光影、肤质、表情细节
- **赛博朋克** — 霓虹、机械、未来感
- **3D 渲染** — 皮克斯风、写实材质、产品展示
- **风景摄影** — 大气透视、黄金时刻、长曝光
- **美食大片** — 悬浮食材、蒸汽、质感
- **时尚大片** — Vogue 风格、editorial、高定
- **二次元** — 动漫、插画、角色设计
- **国风** — 汉服、水墨、工笔画
- **超现实** — 梦境、裂镜、概念艺术
- **信息图** — 食谱、数据、极简设计

## 精选提示词示例

### 1. 写实肖像 — 迪拜夜色金发超模

```
迪拜夜色金发超模
关键词: dubai, night, blonde
风格: 时尚摄影，夜景人像
适用: GPT-Image 2, Midjourney
```

**效果**: 金发模特在迪拜夜景前，城市灯光作为背景光，营造高级时尚杂志感。

### 2. 美食大片 — 悬浮食材 8K

```
悬浮食材8K美食大片
关键词: food, 8k, suspended
风格: 商业美食摄影，悬浮构图
适用: Nanobanana, Stable Diffusion
```

**效果**: 食材在空中悬浮，水滴飞溅，8K 超高清质感，适合餐厅菜单和广告。

### 3. 3D 渲染 — 皮克斯风阳光少年

```
皮克斯风阳光少年
关键词: pixar, disney, 3d
风格: 3D 动画角色，皮克斯风格
适用: GPT-Image 2, Flux
```

**效果**: 阳光洒在少年脸上，皮肤有次表面散射，眼睛有高光反射，典型的皮克斯角色质感。

### 4. 超现实 — 灯泡中的火箭升空

```
灯泡中的火箭升空
关键词: surreal, rocket, lightbulb
风格: 超现实主义，概念艺术
适用: Midjourney, Stable Diffusion
```

**效果**: 火箭从灯泡中发射，玻璃碎片四散，创意十足，适合海报和封面。

### 5. 国风 — 汉服花瓶仕女图

```
汉服花瓶仕女图
关键词: hanfu, chinese, traditional
风格: 中国传统工笔画，仕女图
适用: Nanobanana, Hunyuan
```

**效果**: 仕女身着汉服，手持花瓶，背景有山水元素，工笔细腻，色彩典雅。

### 6. 时尚大片 — 暗黑猎食 Vogue 封面

```
暗黑猎食Vogue封面
关键词: vogue, editorial, predatory
风格: 高端时尚编辑，暗黑美学
适用: GPT-Image 2, Midjourney
```

**效果**: 模特眼神锐利，妆容暗黑，构图参考 Vogue 封面，质感高级。

## 如何使用 AiWind

### 步骤 1：浏览提示词库

访问 [aiwind.org](https://aiwind.org/)，浏览 1000+ 提示词。支持按风格、模型、关键词筛选。

### 步骤 2：查看详情

点击任意提示词，查看：
- 完整英文提示词
- 推荐模型和参数
- 示例图片
- 标签分类

### 步骤 3：复制使用

复制提示词到你的 AI 图像生成工具：

```
# Midjourney 示例
/imagine prompt: 迪拜夜色金发超模, dubai night blonde, 
fashion photography, golden hour lighting, 
editorial style, 8k, ultra detailed --ar 3:4 --v 6

# Stable Diffusion 示例
正向提示词: dubai night blonde supermodel, fashion photography,
golden hour, editorial, 8k, ultra detailed, 
best quality, masterpiece
负向提示词: blurry, low quality, distorted face, extra limbs
```

### 步骤 4：投稿分享

如果你有优秀的提示词，可以投稿到 AiWind，帮助社区成长。

## 提示词工程技巧

### 1. 结构化提示词

```
[主体] + [风格] + [光线] + [构图] + [质量词]

示例:
主体: 金发超模站在迪拜夜景前
风格: 时尚摄影，Vogue 编辑风格
光线: 金色时刻，城市灯光背景光
构图: 中景，三分法
质量: 8K，超高清，最佳质量，杰作
```

### 2. 权重控制（Stable Diffusion）

```
(金发超模:1.3) 表示增加权重
[夜景:0.8] 表示降低权重
```

### 3. 负面提示词

```
 blurry, lowres, bad anatomy, bad hands, text, error, 
 missing fingers, extra digit, fewer digits, cropped, 
 worst quality, low quality, normal quality, 
 jpeg artifacts, signature, watermark, username
```

### 4. 参数调优

| 参数 | 作用 | 推荐值 |
|------|------|--------|
| **CFG Scale** | 提示词遵循度 | 7-12 |
| **Steps** | 迭代步数 | 20-50 |
| **Sampler** | 采样器 | DPM++ 2M Karras |
| **Resolution** | 分辨率 | 1024x1024 或更高 |

## 与同类工具对比

| 特性 | AiWind | PromptHero | Lexica | Civitai |
|------|--------|-----------|--------|---------|
| **免费** | ✅ 完全 | ⚠️ 部分 | ✅ 是 | ✅ 是 |
| **中文支持** | ✅ 优秀 | ❌ 弱 | ❌ 弱 | ⚠️ 一般 |
| **模型覆盖** | 10+ 模型 | 5+ 模型 | 3 模型 | 主要是 SD |
| **提示词质量** | 专业级 | 社区级 | 社区级 | 社区级 |
| **图片示例** | ✅ 有 | ✅ 有 | ✅ 有 | ✅ 有 |
| **投稿功能** | ✅ 有 | ✅ 有 | ❌ 无 | ✅ 有 |
| **分类系统** | 详细 | 一般 | 一般 | 标签 |

## 结论

AiWind 是**中文用户最好的 AI 绘画提示词库**。

- 1000+ 提示词，覆盖主流模型和风格
- 完全免费，持续更新
- 中文界面，中文提示词
- 示例图片直观展示效果

如果你用 AI 生成图片总觉得"差点意思"，来 AiWind 找灵感吧。

**网站**: [aiwind.org](https://aiwind.org/)  
**功能**: 1000+ 提示词 | 10+ 模型支持 | 免费使用

## Related Articles

- [Pixelle-Video: AI Auto Short Video Generator](/resources/ai-tools/pixelle-video-ai-short-video-generator/)
- [TabPFN: Foundation Model for Tabular Data](/resources/ai-tools/tabpfn-foundation-model-tabular-data/)
- [Hermes Agent: Self-Improving AI Agent](/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/)

---

## Recommended Tools

For developers building or deploying open-source AI tools, we recommend:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for new users, 14+ global regions, one-click GPU/CPU droplets ideal for AI workloads.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API proxy. Most AI tools above (chatbots, code gen, translation, search, etc) need an LLM API key — this proxy delivers stable access to top models at ~30% of official pricing.

*Affiliate link — supports dibi8.com at no cost to you.*

<!--auto-references-->
## References & Sources

- [Stable Diffusion](https://github.com/Stability-AI/generative-models)
- [Flux](https://github.com/black-forest-labs/flux)
- [Civitai](https://github.com/civitai/civitai)
