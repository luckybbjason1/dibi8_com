---
title: 'Unsloth 2026: Fine-Tuning LLM Nhanh 64.9k Sao — Tốc Độ 2×, VRAM Ít Hơn 70%, Thân Thiện Single-GPU'
description: 'Unsloth fine-tune LLM nhanh hơn 2× với ít hơn 70% VRAM so với baseline HuggingFace TRL. 64.9k GitHub sao, dual Apache 2.0 + AGPL-3.0 license. Hỗ trợ Llama 3, Mistral, Qwen 3, Gemma, DeepSeek cho LoRA / QLoRA / DPO / GRPO. Hướng dẫn fine-tuning single-GPU đầy đủ 2026.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack: [Python, PyTorch, CUDA, Triton]
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/unslothai/unsloth'
stars: 64900
maintainer: 'unslothai'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Unsloth', 'fine-tuning', 'LoRA', 'QLoRA', 'GRPO', 'training nhanh']
aliases:
  - /posts/unsloth-fast-llm-fine-tuning-2026/
---

Nếu [Axolotl](/vi/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/) là framework fine-tuning multi-GPU production, **Unsloth** là vua tốc độ single-GPU. Bằng cách viết lại kernel training LLM trong Triton + Python tùy chỉnh thay vì dựa vào autograd chung của PyTorch, Unsloth fine-tune mô hình **nhanh hơn 2×** với **ít hơn 70% VRAM** so với baseline HuggingFace TRL.

64.9k GitHub sao, dual Apache 2.0 / AGPL-3.0 license. Hỗ trợ 500+ mô hình (Llama 3-3.2, Mistral, Qwen 3-3.6, Gemma, DeepSeek, Phi-4, gpt-oss). Tool fine-tuning mặc định khi có GPU consumer 24 GB đơn và cần iterate nhanh.

## TL;DR

- **Là gì**: Thư viện fine-tuning LLM single-GPU nhanh
- **GitHub**: 64.9k sao
- **License**: Dual Apache 2.0 + AGPL-3.0 (Apache cho sử dụng SaaS-friendly; AGPL kích hoạt khi redistribute phái sinh)
- **Tốc độ**: Nhanh hơn 2× training, ít hơn 70% VRAM vs baseline HF TRL (một số phương pháp giảm VRAM tới 80%)
- **Mô hình**: Llama 3-3.2, Mistral, Qwen 3-3.6, Gemma 1-4, DeepSeek, gpt-oss, Phi-4
- **Phương pháp**: Full / LoRA / QLoRA / DPO / GRPO / training FP8 / pretraining
- **Phần cứng**: NVIDIA (series RTX 30/40/50), AMD hạn chế, Apple Silicon inference, CPU chỉ inference

## 1. Tốc Độ 2× Của Unsloth Là Thật (không phải marketing)

Hầu hết tuyên bố "tăng tốc" trong ML là chiêu (benchmark cherry-pick, v.v.). Cái của Unsloth là thật và hiện trong log training:

1. **Kernel Triton tùy chỉnh** cho các operation fused matmul + softmax thống trị thời gian training
2. **Tính gradient thủ công** (không overhead autograd PyTorch mỗi bước)
3. **Attention tiết kiệm memory** với activation checkpointing thông minh hơn
4. **Fast path 4-bit / 8-bit** duy trì độ chính xác nhưng skip dequantization

Hiệu ứng kết hợp: Fine-tuning Llama 3 8B QLoRA trên RTX 3090 — HF TRL ~3.5 giờ / 16 GB VRAM. Unsloth ~1.5 giờ / 5 GB VRAM. Cùng dataset, cùng hyperparameter, cùng điểm eval cuối.

## 2. Thực Tế Phần Cứng

| GPU | Kích thước mô hình có thể QLoRA fine-tune (với giảm 70% VRAM của Unsloth) |
|---|---|
| 8 GB (RTX 3060 8GB) | Llama 3.2 3B QLoRA, Phi-4 mini |
| 12 GB (RTX 3060 12GB / 4070) | Llama 3.2 8B QLoRA, Mistral 7B QLoRA |
| 24 GB (RTX 3090 / 4090) | Llama 3.3 70B QLoRA (vâng, trên single 4090!) |
| 48 GB (A6000) | Llama 3.3 70B LoRA, Mixtral QLoRA |

Đây là câu chuyện "fine-tune trên phần cứng consumer". Llama 70B QLoRA trên RTX 4090 $1500 không thể với HF TRL — Unsloth làm thành thường lệ.

Cho thuê cloud: H100 trên Vast.ai (~$1.50/giờ) xử mọi thứ; cho experiment rẻ hơn, instance RTX 4090 $0.40-0.60/giờ hoạt động tốt trên {{< aff "digitalocean" "unsloth-gpu" "DigitalOcean GPU droplet" >}}.

## 3. Cài Nhanh (5 phút)

```bash
pip install unsloth
```

Hello world — fine-tune Llama 3.2 8B QLoRA trong ~20 dòng:

```python
from unsloth import FastLanguageModel
from trl import SFTTrainer
from datasets import load_dataset

model, tokenizer = FastLanguageModel.from_pretrained(
    model_name = "unsloth/llama-3.2-8b-bnb-4bit",
    max_seq_length = 2048,
    load_in_4bit = True,
)

model = FastLanguageModel.get_peft_model(
    model, r=16, lora_alpha=32, target_modules="all-linear"
)

dataset = load_dataset("tatsu-lab/alpaca", split="train")

trainer = SFTTrainer(
    model = model,
    tokenizer = tokenizer,
    train_dataset = dataset,
    dataset_text_field = "text",
    max_seq_length = 2048,
    args = {"num_train_epochs": 1, "per_device_train_batch_size": 4},
)
trainer.train()
model.save_pretrained("./outputs/llama-alpaca-lora")
```

Đó là tất cả. Cùng mô hình, cùng dữ liệu — chạy với kernel tối ưu Unsloth.

## 4. Catalog Mô Hình Đã Pre-Quantized

Unsloth duy trì các phiên bản pre-quantized 4-bit / 8-bit của mô hình phổ biến tại `huggingface.co/unsloth`. Dùng các này tiết kiệm 5-15 phút tải xuống ban đầu + lượng tử hóa mỗi lần chạy mới:

- `unsloth/llama-3.2-8b-bnb-4bit`
- `unsloth/mistral-7b-v0.3-bnb-4bit`
- `unsloth/qwen3-coder-14b-bnb-4bit`
- `unsloth/gemma-3-9b-bnb-4bit`
- `unsloth/DeepSeek-V3-bnb-4bit` (cho người dũng cảm trên 48 GB+)

Luôn kiểm tra HF profile của Unsloth cho phiên bản pre-quantized của mô hình mục tiêu trước khi tải từ nhà phát hành gốc.

## 5. GRPO — Fine-Tuning Học Tăng Cường Nhanh

GRPO (Group Relative Policy Optimization) là mặc định fine-tuning RL 2026 (kỹ thuật đằng sau DeepSeek-R1). Implementation GRPO của Unsloth dùng ít hơn 80% VRAM so với HF TRL, làm GRPO khả thi trên single GPU 24 GB thay vì yêu cầu node multi-GPU.

```python
from trl import GRPOConfig, GRPOTrainer
from unsloth import FastLanguageModel, PatchFastRL

PatchFastRL("GRPO", FastLanguageModel)

# ... load mô hình với FastLanguageModel như mục 3 ...

def reward_fn(completions, **kwargs):
    return [1.0 if "correct" in c else 0.0 for c in completions]  # logic reward của bạn

trainer = GRPOTrainer(
    model=model,
    args=GRPOConfig(output_dir="./outputs/grpo", num_train_epochs=1),
    train_dataset=dataset,
    reward_funcs=[reward_fn],
)
trainer.train()
```

Cho suy luận đặc thù domain (toán, code, output có cấu trúc), GRPO + Unsloth trên single GPU giờ là cách hiệu quả chi phí nhất để nướng cải thiện suy luận vào mô hình cơ sở.

## 6. Unsloth vs Axolotl vs HuggingFace TRL

| Chọn | Khi nào |
|---|---|
| **Unsloth** | Single GPU, iterate nhanh, fine-tuning RL, phần cứng consumer, prototyping |
| **Axolotl** | Production multi-GPU, multi-node, hỗ trợ phương pháp rộng (DPO/IPO/KTO/ORPO/GRPO/GDPO), workflow YAML config-as-code. Xem [Hướng dẫn Axolotl 2026](/vi/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/) |
| **HuggingFace TRL** | Truy cập API trực tiếp, nghiên cứu thuật toán RL tùy chỉnh, cần sửa trainer internal |
| **Nền tảng cloud** (Together, Fireworks, OpenAI fine-tuning) | Không muốn sở hữu hạ tầng, không quan tâm tính di động trọng số |

Mặc định thành thật 2026: **Unsloth cho giai đoạn experiment, Axolotl cho giai đoạn deploy production**. Cả hai wrap PyTorch + TRL bên dưới, nên phương pháp học trong Unsloth port sang Axolotl.

## 7. Lưu Ý License (Phần AGPL)

Unsloth dual-licensed:
- **Apache 2.0**: cover sử dụng thư viện core. An toàn dùng trong app nào
- **AGPL-3.0**: kích hoạt nếu bạn distribute Unsloth đã modified hoặc chạy nó như service expose Unsloth's API bên ngoài

Hàm ý thực tế:
- ✅ Dùng Unsloth để fine-tune mô hình của bạn, deploy mô hình đó trong product nào. Ổn
- ✅ Fine-tune trên GPU SaaS bạn thuê, mang trọng số tới deploy riêng. Ổn
- ⚠️ Xây "fine-tuning-as-a-service" expose Unsloth trực tiếp. AGPL kích hoạt — service phải là AGPL

Cho 99% user (bạn đang fine-tune mô hình cho product riêng), Apache là cái áp dụng.

## 8. Pattern Production

Hai pattern hầu hết team định cư:

**Pattern A — Pure Unsloth (shop single-GPU)**:
```
Thuê RTX 4090 trên Vast.ai → Experiment Unsloth QLoRA → 
Merge LoRA + base → Push tới HF Hub → Serve qua vLLM
```

**Pattern B — Hybrid Unsloth + Axolotl (team production)**:
```
Unsloth trên laptop dev cho 50 experiment nhanh
↓ tìm thấy winner
Axolotl trên cluster 8× H100 cho full fine-tune cuối cùng dài context, multi-epoch
↓ mô hình production
Push tới HF Hub → Serve qua vLLM sau LiteLLM gateway
```

Pattern hybrid chỉ trả tiền cluster khi có ứng viên đáng scale.

## 9. Khi *Không* Dùng Unsloth

- **Training phân tán multi-node** — Unsloth tập trung tối ưu single-GPU. Axolotl xử multi-node tốt hơn
- **Cần phương pháp fine-tuning nghiên cứu tiên tiến** — TRL có phương pháp mới trước; Unsloth adopt sau ổn định
- **AMD GPU chính** — Hỗ trợ AMD của Unsloth hạn chế (hoạt động nhưng không tối ưu); dùng Axolotl hoặc TRL ở đó
- **Bạn không thực sự cần tốc độ** — Nếu job chạy qua đêm dù sao, tốc độ 2× không quan trọng, và HF TRL chuẩn hóa hơn

## TL;DR

Unsloth = **vua tốc độ fine-tuning LLM single-GPU**. 64.9k sao, nhanh hơn 2× + ít hơn 70% VRAM vs HuggingFace TRL, dual Apache/AGPL license. Llama 70B QLoRA trên single RTX 4090 giờ là thường lệ.

Pair với [Axolotl](/vi/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/) cho giai đoạn production multi-GPU. Thuê {{< aff "digitalocean" "footer-cta" "instance GPU" >}} hoặc dùng Vast.ai khi cần train.

---

*Một phần của Fine-Tuning Stack dibi8 — xem bộ sưu tập Fine-Tuning Stack sắp tới cho pipeline đầy đủ từ chuẩn bị dataset đến triển khai production.*
