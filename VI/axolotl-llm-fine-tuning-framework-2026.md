---
title: 'Axolotl 2026: Framework Fine-Tuning LLM Dựa YAML 12k Sao — Hướng Dẫn Production Đầy Đủ'
description: 'Axolotl là framework fine-tuning LLM mã nguồn mở với config YAML đơn cho full / LoRA / QLoRA / DPO / GRPO. 12k GitHub sao, Apache 2.0. Hỗ trợ Llama / Mistral / Qwen / GLM / 10+ họ. Hướng dẫn cài đặt 2026 đầy đủ + khi nào Axolotl thắng Unsloth và HuggingFace TRL raw.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack: [Python, PyTorch, CUDA, YAML]
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/axolotl-ai-cloud/axolotl'
stars: 12000
maintainer: 'axolotl-ai-cloud'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Axolotl', 'fine-tuning', 'LoRA', 'QLoRA', 'DPO', 'mã nguồn mở']
aliases:
  - /posts/axolotl-llm-fine-tuning-framework-2026/
---

Nếu bạn từng thử fine-tune mô hình Llama và kết thúc viết 300 dòng PyTorch + DeepSpeed config + wrapper HuggingFace Trainer, bạn cảm thấy khoảng cách mà **Axolotl** lấp đầy. Một file YAML mô tả toàn bộ chạy fine-tuning — mô hình, dataset, config LoRA, hyperparameter, chiến lược phân tán — và Axolotl xử lý phần còn lại.

12k GitHub sao, Apache 2.0, hỗ trợ mọi họ LLM chính (Llama, Mistral, Mixtral, Qwen, GLM, GPT-OSS, HunYuan, v.v.) và mọi phương pháp fine-tuning quan trọng năm 2026 (full, LoRA, QLoRA, GPTQ, QAT, fine-tuning ưu tiên DPO/IPO/KTO/ORPO, học tăng cường GRPO/GDPO, mô hình hóa phần thưởng).

Đây là framework mà hầu hết pipeline fine-tuning production định cư khi vượt Hugging Face TRL nhưng không muốn cam kết với nền tảng cloud closed.

## TL;DR

- **Là gì**: Framework fine-tuning LLM mã nguồn mở, dựa YAML
- **GitHub**: 12k sao
- **License**: Apache 2.0 (an toàn cho sử dụng thương mại)
- **Mô hình**: Llama, Mistral, Mixtral, Qwen, GLM, GPT-OSS, HunYuan, Granite, Pythia, hơn nữa
- **Phương pháp**: Full / LoRA / QLoRA / GPTQ / QAT / DPO / IPO / KTO / ORPO / GRPO / GDPO / mô hình hóa phần thưởng
- **Phần cứng**: NVIDIA Ampere+ hoặc AMD GPU, Python 3.11+, PyTorch ≥2.9.1

## 1. Vì Sao Axolotl Tồn Tại (vấn đề nó giải quyết)

Ba pattern phổ biến Axolotl thay thế:

1. **Script HF Trainer tùy chỉnh** — 300 dòng boilerplate mỗi experiment, mong manh, không sống sót framework version bump
2. **Khảo cổ DeepSpeed config** — tìm ra kết hợp `zero_stage`, `offload_optimizer`, `gradient_checkpointing` nào hoạt động cho kích thước mô hình + GPU
3. **Nền tảng fine-tuning cloud** (Together, Fireworks, v.v.) — dễ nhưng bạn không sở hữu trọng số kết quả hoặc quy trình

Axolotl cho bạn UX "nền tảng cloud" (một file config, một lệnh) trong khi giữ bạn trên hạ tầng bạn sở hữu và trọng số bạn kiểm soát.

## 2. Thực Tế Phần Cứng

| Setup | Mô hình có thể fine-tune |
|---|---|
| GPU 24 GB (RTX 4090 / 3090) | Llama 3.2 8B QLoRA, Mistral 7B QLoRA |
| GPU 48 GB (A6000) | Llama 3.2 8B LoRA, Mistral 7B full fine-tune |
| GPU 80 GB (A100 / H100) | Llama 3.3 70B QLoRA, Mistral 8x7B QLoRA |
| 2× 80 GB (2× H100) | Llama 3.3 70B LoRA, Mixtral full fine-tune |
| Cluster 8× H100 | Full fine-tune cấp frontier |

Tùy chọn thuê cloud: H100 trên Vast.ai $1.50-2/giờ, hoặc cho workload bền vững dùng {{< aff "digitalocean" "axolotl-gpu" "DigitalOcean GPU droplet" >}}. Cho latency thân thiện Trung Quốc ngắn hơn, {{< aff "htstack" "axolotl-vps-hk" "HTStack Hong Kong" >}} hoạt động cho phía chuẩn bị data + monitoring (training thực ở lại GPU thuê).

## 3. Cài Nhanh (15 phút)

```bash
git clone https://github.com/axolotl-ai-cloud/axolotl
cd axolotl
pip install -e '.[flash-attn,deepspeed]'
```

Chạy training tối thiểu — QLoRA fine-tune Llama 3.2 8B trên dataset mẫu:

```yaml
# config.yml
base_model: meta-llama/Llama-3.2-8B
datasets:
  - path: tatsu-lab/alpaca
    type: alpaca
adapter: qlora
lora_r: 16
lora_alpha: 32
load_in_4bit: true
num_epochs: 3
output_dir: ./outputs/llama-alpaca
```

```bash
axolotl train config.yml
```

Đó là tất cả. Cùng YAML hoạt động trên 1 GPU, 8 GPU, hoặc multi-node — Axolotl tự phát hiện qua accelerate/DeepSpeed.

## 4. Config YAML Là Tính Năng Killer

Vì sao YAML thực sự là trừu tượng đúng ở đây:

- **Thân thiện Git**: mỗi fine-tune là file config trong repo. Tái lập bằng checkout
- **Ma trận experiment**: parameter sweep qua thay thế `yq` hoặc W&B sweep. Không 50 script copy-paste
- **Bàn giao team**: ML engineer viết YAML, ops engineer chạy. Hợp đồng rõ
- **Tự nâng cấp**: Axolotl duy trì tương thích ngược config qua các phiên bản, experiment 6 tháng cũ vẫn chạy

So với script tùy chỉnh: mỗi fine-tune là snowflake, version bump phá vỡ, chia sẻ team là "đây, copy notebook của tôi".

## 5. Bảng Tra Phương Pháp Fine-Tuning

| Phương pháp | Khi nào dùng | VRAM (mô hình 8B) |
|---|---|---|
| **Full** fine-tune | Có nhiều compute, muốn chất lượng tốt nhất | ~80 GB |
| **LoRA** | Hầu hết trường hợp, cân bằng chi phí/chất lượng | ~24-32 GB |
| **QLoRA** | Experiment rẻ, VRAM eo hẹp | ~12-16 GB |
| **GPTQ** | Mô hình đã lượng tử, tập trung suy luận | ~8 GB |
| **DPO** | Dữ liệu ưu tiên (cặp chosen/rejected), align không cần RL | LoRA + ~30% |
| **GRPO** | RL thực với tín hiệu thưởng, domain toán/code | LoRA + ~50% |
| **KTO** | Ưu tiên nhị phân (thumbs up/down), đơn giản hơn DPO | LoRA + ~30% |

Hầu hết team 2026: QLoRA cho experiment, LoRA cho deploy production, DPO cho lần align.

## 6. Workflow Thực Tế

```
1. Chuẩn bị dataset (JSONL với format prompt/response hoặc messages)
   └─> push tới HuggingFace Hub để versioning

2. Viết config.yml Axolotl (mô hình + dataset + phương pháp + hyperparameter)
   └─> git commit (giờ tái lập được)

3. Bật instance GPU (Vast.ai / DigitalOcean / HTStack)
   └─> clone repo, pip install Axolotl

4. axolotl preprocess config.yml (tokenize một lần, cache)
   └─> verify thống kê dataset khớp kỳ vọng

5. axolotl train config.yml
   └─> W&B log đường cong loss. Train cho N epoch.

6. axolotl inference --base-model llama3-8b --lora ./outputs/lora
   └─> Kiểm tra response trên prompt held-out

7. Merge LoRA + base → push tới HuggingFace Hub hoặc serve qua vLLM
```

Workflow "30 dòng YAML + một lệnh" biến fine-tuning từ project nghiên cứu thành thực tiễn engineering có thể deploy.

## 7. Axolotl vs Unsloth vs HuggingFace TRL

| Chọn | Khi nào |
|---|---|
| **Axolotl** | Pipeline fine-tuning production, multi-node, hỗ trợ phương pháp rộng (DPO/GRPO/KTO/ORPO), workflow YAML-config-as-code |
| **Unsloth** | GPU đơn, muốn 2× tốc độ + tiết kiệm 70% VRAM, fine-tuning RL cụ thể. Xem [deep-dive Unsloth](/vi/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/) |
| **HuggingFace TRL** | Điều khiển cấp thấp, vòng lặp tùy chỉnh, paper nghiên cứu. Hầu hết code production giờ wrap TRL qua Axolotl hoặc Unsloth |
| **Together / Fireworks / OpenAI fine-tuning** | Không muốn sở hữu hạ tầng, không quan tâm tính di động trọng số, giá $$$ premium |

Khuyến nghị mặc định 2026: **Axolotl cho multi-GPU production + Unsloth cho experiment single-GPU nhanh**. Bổ sung nhau, không cạnh tranh.

## 8. Mẹo Production

5 điều cắn user Axolotl lần đầu:

1. **Pad token tokenizer** — nhiều config thiếu `tokenizer.pad_token = eos_token`. Mặc định Axolotl xử mô hình đã biết; verify cho mô hình mới
2. **`max_seq_length` và OOM** — bắt đầu nhỏ (1024), tăng cho đến khi OOM, sau đó lùi 10%. Đừng đoán
3. **Thời gian compile Flash Attention** — cài đầu có thể mất 20-30 phút compile FA2. Kiên nhẫn
4. **Format dataset không khớp** — field `type` phải khớp data. `alpaca` ≠ `sharegpt` ≠ `chat_template`. Đọc docs
5. **Confusion DeepSpeed ZeRO stage** — Stage 1 = không offload (nhanh nhất, nhiều VRAM nhất). Stage 2 = optimizer offload. Stage 3 = full param offload (chậm nhất, ít VRAM nhất). Khớp với ngân sách VRAM

## 9. Khi *Không* Dùng Axolotl

- **Bạn chỉ muốn chat với mô hình local** — Fine-tuning không cần. Dùng [Ollama](/vi/resources/llm-frameworks/local-llm-runner-comparison-2026/) với mô hình instruct cơ sở
- **Dataset nhỏ (<1000 ví dụ)** — Few-shot prompting có thể đánh bại fine-tuning, hoặc dùng RAG (xem [Stack Knowledge Base](/vi/collections/knowledge-base-stack/))
- **Đã hài lòng với mô hình cơ sở trên task của bạn** — Đừng fine-tune chỉ để fine-tune. Chi phí > lợi ích cho đến khi có thể chứng minh cải thiện benchmark
- **Cần chu kỳ iterate <24 giờ trên GPU laptop** — Tốc độ 2× và giảm 70% VRAM của Unsloth phù hợp hơn

## TL;DR

Axolotl = **framework fine-tuning LLM dựa YAML, mặc định multi-GPU production 2026**. 12k sao, Apache 2.0, hỗ trợ mọi họ mô hình chính + mọi phương pháp fine-tuning quan trọng. Pair với Unsloth (tốc độ single-GPU) cho pipeline fine-tuning experiment-to-production đầy đủ.

Bật instance H100, viết YAML 20 dòng ở mục 3, và 15 phút sau bạn có chạy fine-tuning đi.

---

*Một phần của Fine-Tuning Stack dibi8 — pair với [Unsloth cho iterate single-GPU nhanh](/vi/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/). Cho bức tranh LLM ops đầy đủ xem bộ sưu tập Fine-Tuning Stack sắp tới.*
