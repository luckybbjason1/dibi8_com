---
title: 'Fine-Tuning Stack 2026：从数据集到生产部署 LLM 的 5 组件管线'
description: '完整 LLM 微调 stack：Unsloth（单 GPU 快速实验）+ Axolotl（生产多 GPU）+ HuggingFace datasets/Hub + Weights & Biases（eval 跟踪）+ vLLM（serving）。$50-300/月训练基础设施。完整管线：数据集准备 → 实验 → 生产微调 → eval → 部署。'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack: [Python, PyTorch, CUDA, YAML]
application_domain: Collections
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['collections']
tags: ['Fine-Tuning', 'LLM', 'Stack', '合集']
aliases:
  - /posts/fine-tuning-stack/
---

2026 LLM 微调终于有了一致的 stack —— 用胶带粘 HuggingFace Trainer + DeepSpeed config + 自定义 eval 脚本的日子结束了。这个合集组装的是 **5 组件管线**，从原始数据集到生产部署的微调模型，快速迭代（Unsloth）和生产部署（Axolotl）干净分离。按规模 $50-300/月训练基础设施。

如果你在建领域特定模型、给开源权重基础模型做 instruction-tuning、做 DPO/GRPO 对齐、跑生产微调管线 —— 就这个 stack。

## TL;DR —— Stack 全貌

| # | 组件 | 阶段 | 角色 | 深度指南 |
|---|---|---|---|---|
| 1 | **Unsloth** | 实验 | 单 GPU 快速微调，2× 速度 + 70% VRAM 节省 | [Unsloth 2026 指南](/zh/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/) |
| 2 | **Axolotl** | 生产 | YAML 驱动的多 GPU 生产微调 | [Axolotl 2026 指南](/zh/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/) |
| 3 | **HuggingFace datasets + Hub** | 数据 | 数据集版本控制、团队共享、推训练权重 | [HF docs] |
| 4 | **Weights & Biases**（或替代品）| Eval | 跟踪 loss 曲线、eval 分数、超参扫描 | [W&B docs] |
| 5 | **vLLM** | Serving | 微调模型的生产多租户服务 | [Local LLM Runner 对比](/zh/resources/llm-frameworks/local-llm-runner-comparison-2026/) |

**月成本总计**（不含训练资本）：
- **业余**（每周租 GPU 10 小时）：**$30-60/月**
- **生产团队**（1-2 独立 GPU + 监控）：**$200-400/月**
- **小 AI lab**（8× H100 集群）：**$2000-5000/月**

对比托管微调平台：Together 微调 ~$0.50/M token（大数据集累得快），OpenAI 微调 $25/M token（规模化离谱）。自托管在任何有意义量上都赢 + 你拥有权重。

## 1. 为什么 2026 "微调 stack"该定型

3 个变化结晶 stack：

1. **Unsloth + Axolotl 达到生产成熟** —— "快速实验 + 生产扩展"分工现在干净
2. **GRPO 成 RL 微调默认**（DeepSeek-R1 之后）—— Unsloth 和 Axolotl 都原生支持
3. **开源权重基础模型到 GPT-4 级** —— Llama 3.3 70B / Qwen 3 32B / DeepSeek V3。为你的领域微调这些现在真正能和闭源替代竞争

结果：微调从研究 → 工程实践。stack 反映这一点。

## 2. 架构 —— 实验到生产管线

```
   ┌──────────────────────────────────────────────────┐
   │ 数据集（JSONL：prompt/response 或 messages）     │
   │  → HuggingFace datasets 库                       │
   │  → 推到 HuggingFace Hub（版本控制）              │
   └────────────────┬─────────────────────────────────┘
                    │
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ 实验阶段（单 GPU，快速迭代）                     │
   │  → 租 RTX 4090 / H100 上 Unsloth                 │
   │  → 50+ 短 QLoRA 跑找赢配方                       │
   │  → W&B 记 loss 曲线 + eval 分                    │
   └────────────────┬─────────────────────────────────┘
                    │（找到赢配方）
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ 生产阶段（多 GPU，长训练）                       │
   │  → Axolotl YAML config（git 跟踪）              │
   │  → 8× H100 集群做 full / 长上下文微调           │
   │  → W&B 记最终 eval                                │
   └────────────────┬─────────────────────────────────┘
                    │
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ 部署阶段                                          │
   │  → 合 LoRA + base 权重                            │
   │  → 推合好模型到 HuggingFace Hub                  │
   │  → vLLM 在 LiteLLM 网关后服务模型                │
   └──────────────────────────────────────────────────┘
```

分工是关键 —— Unsloth 快速迭代做"什么有效"探索，Axolotl 稳健做"现在扩展"生产跑。

## 3. 组件 1 —— Unsloth（实验阶段）

**角色**：你 80% 微调时间花的地方。迭代数据集格式、超参、基础模型选择。每实验周期：单租 GPU 30 分-3 小时。

**Unsloth 在这赢的理由**：比 HF TRL 快 2× = 每美元 2× 实验。少 70% VRAM = $1500 RTX 4090 上的实验，不需要 A100。看 [Unsloth 深度文](/zh/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/)。

**快装**：
```bash
pip install unsloth
```

**模式**：Vast.ai（$0.40-0.60/小时）或 RunPod 租 RTX 4090，周末跑 10-20 实验，找赢配方，团队评审用 notebook 记录。

## 4. 组件 2 —— Axolotl（生产阶段）

**角色**：找到赢配方后，扩规模 —— full fine-tune、更长上下文、多 epoch、多 GPU。Axolotl 用的 YAML config 可 git 跟踪、对运维交接友好。

**Axolotl 在这赢的理由**：开箱可用的多节点分布式训练，最广方法支持（DPO/GRPO/KTO/ORPO/GDPO），config-as-code 可复现。看 [Axolotl 深度文](/zh/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/)。

**快装**：
```bash
pip install axolotl
```

**模式**：从 Unsloth 赢配方拿超参 → 写 Axolotl YAML → 8× H100 集群跑（Vast.ai ~$15-25/小时）做最终 6-12 小时生产跑 → 最终权重推 HF Hub。

## 5. 组件 3 —— HuggingFace Datasets + Hub（数据层）

**角色**：数据集版本控制。跨团队分享数据集。推训练模型权重协作测试。

**为什么显然选这个**：HF 赢了 AI 数据集分发层（像代码的 GitHub，HF Hub 给模型+数据集）。每个微调工具原生集成。

**快装**：
```bash
pip install datasets
huggingface-cli login
```

**模式**：
```python
from datasets import load_dataset, Dataset

# 本地准备 + 推
data = Dataset.from_json("my_data.jsonl")
data.push_to_hub("yourname/my-finetune-dataset", private=True)

# 团队成员加载
data = load_dataset("yourname/my-finetune-dataset")
```

敏感数据（医疗 / 金融 / 专有）用 HF Hub **私有数据集** —— 有访问控制。

## 6. 组件 4 —— Weights & Biases（Eval 跟踪）

**角色**：你跑 50 实验找赢配方时，需要方法对比它们。W&B 是事实选择 —— 自动记 loss 曲线、eval 分、超参、硬件利用率。

**快装**（通过 env var 配合 Unsloth 和 Axolotl）：
```bash
pip install wandb
wandb login
export WANDB_PROJECT="my-finetune-project"
```

现在每个 Unsloth / Axolotl 训练跑自动记到你 W&B 仪表盘。

**成本**：W&B 免费层慷慨（单用户、无限公开项目）。团队 / 私有项目：$50/用户/月。替代品：**MLflow**（自托管、免费、不精美）、**TensorBoard**（基础但免费 + 本地）。

## 7. 组件 5 —— vLLM（Serving 阶段）

**角色**：微调好模型后，服务给用户。vLLM 是生产多租户服务选择 —— PagedAttention + continuous batching 让它成吞吐冠军。

完整 vLLM 为何在生产多用户服务上胜过 Ollama / LM Studio / llama.cpp 见 [Local LLM Runner 对比](/zh/resources/llm-frameworks/local-llm-runner-comparison-2026/)。

**快装 + 服务微调模型**：
```bash
pip install vllm
vllm serve yourname/my-finetuned-llama \
  --enable-lora \
  --lora-modules my-lora=path/to/lora_weights \
  --port 8000
```

在 [LiteLLM 网关](/zh/resources/llm-frameworks/litellm/) 后做认证 + 限流 + 客户级虚拟 key = 跑在你拥有基础设施上的生产就绪多租户 LLM API。

## 8. Day 1 管线设置（3-4 小时）

1. **JSONL 格式数据集**（看情况）—— 准备 `train.jsonl` 和 `eval.jsonl`，推 HF Hub 私有
2. **租 RTX 4090 GPU**（10 分）—— Vast.ai 或 {{< aff "digitalocean" "ftstack-experiment-gpu" "DigitalOcean GPU droplet" >}} 给实验阶段
3. **装 Unsloth + W&B**（10 分）—— `pip install unsloth wandb`
4. **第一次 QLoRA 跑**（60 分）—— Unsloth 指南第 3 节，微调 Llama 3.2 8B 1 epoch，验 W&B log 出现
5. **迭代 5-10 短实验**（~半天）—— 变学习率、LoRA rank、数据集切片。找到最佳 eval 分配方
6. **配方翻译成 Axolotl YAML**（30 分）—— 同超参 YAML 格式，git commit
7. **租 8× H100 集群**做生产跑（Vast.ai ~$15-20/小时 × 6-12 小时 = $90-240），数据 + 监控侧在 {{< aff "htstack" "ftstack-prod-vps" "HTStack 香港 VPS" >}}
8. **跑 Axolotl 生产训练** —— 最终权重推 HF Hub
9. **vLLM 部署** —— 微调模型服务在独立 24 GB GPU + LiteLLM 网关
10. **对比基础模型 eval** —— 你的微调真的在 eval 集上打败基础？没？迭代

3-4 小时设置 + 1-2 周实验后，你有自己的微调模型部署生产。

## 9. 成本拆解

| 项 | 业余 | 生产团队 | 小 AI lab |
|---|---|---|---|
| 实验 GPU（按需租）| $30-60/月 | $100-200/月 | $300-500/月 |
| 生产训练（跑租）| $0-50/月 | $200-400/月 | $1500-3000/月 |
| 独立服务 GPU（vLLM）| $0（用 Ollama 代替）| $200/月（RTX 4090）| $1000/月（H100）|
| HF Hub | $0（公开 + 1 GB 内私有免费）| $9/月（Pro）| $20/用户/月（企业）|
| W&B | $0（免费层）| $50/用户/月 | $50/用户/月 |
| 杂项存储 / 带宽 | $5 | $20 | $50 |
| **总计** | **~$35-115/月** | **~$580-880/月** | **~$2870-4570/月** |

对比托管：Together 微调 $0.50/M token × 100M token 数据集 = 每次微调跑 $50 × 10 实验 = $500/月仅实验。自托管 >10 微调/月时赢。

## 10. 升级路径

超出这个 stack 时：

- **常规要微调 >70B 模型** —— 买或长租 H100 集群代替租
- **合规 / 数据驻地** —— Vast.ai 切到你管辖内独立裸机
- **多租户微调 SaaS** —— 加用户隔离层；考虑 LangSmith 或类似托管 eval
- **持续微调循环** —— 配 [AI Agent 工具链](/zh/collections/ai-agent-tool-chain/) 做生产模型衰减时自动重训触发
- **领域特定 RL** —— 加奖励建模 + GRPO 循环（Unsloth 和 Axolotl 都支持；只是更耗算力）

## TL;DR —— Recipe

**5 组件搭生产 LLM 微调，业余到生产团队 $50-300/月**：
1. **Unsloth** —— 单 GPU 快速实验阶段
2. **Axolotl** —— 生产多 GPU 阶段
3. **HuggingFace datasets + Hub** —— 数据版本控制 + 模型分发
4. **Weights & Biases** —— eval 跟踪
5. **vLLM** —— 生产服务

实验租 {{< aff "digitalocean" "footer-cta" "GPU droplet" >}}，生产跑扩到 Vast.ai 8× H100，最终模型部署在独立 24 GB GPU。端到端自托管，权重你拥有，成本随严肃程度扩展。

---

*配套合集：[便宜 LLM Stack](/zh/collections/cheap-llm-stack/) 部署后覆盖推理成本侧。[AI Agent 工具链](/zh/collections/ai-agent-tool-chain/) 做自动微调循环。[知识库 Stack](/zh/collections/knowledge-base-stack/) 在某些情况下 RAG 是微调的替代品。*
