---
title: 'Fine-Tuning Stack 2026: Pipeline 5 Thành Phần Từ Dataset Đến LLM Triển Khai Production'
description: 'Stack fine-tuning LLM đầy đủ: Unsloth (experiment single-GPU nhanh) + Axolotl (production multi-GPU) + HuggingFace datasets/Hub + Weights & Biases (theo dõi eval) + vLLM (serving). $50-300/tháng hạ tầng training. Pipeline đầy đủ: chuẩn bị dataset → experiment → fine-tune production → eval → deploy.'
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
tags: ['Fine-Tuning', 'LLM', 'Stack', 'Collection']
aliases:
  - /posts/fine-tuning-stack/
---

Fine-tuning LLM năm 2026 cuối cùng có stack mạch lạc — những ngày của duct-tape HuggingFace Trainer + DeepSpeed config + script eval tùy chỉnh đã kết thúc. Bộ sưu tập này lắp ráp **pipeline 5 thành phần** đưa bạn từ dataset thô tới mô hình fine-tuned được triển khai production, với phân chia rõ giữa iterate nhanh (Unsloth) và deploy production (Axolotl). $50-300/tháng hạ tầng training tùy scale.

Nếu bạn đang xây mô hình đặc thù domain, instruction-tune mô hình base open-weight, làm align DPO/GRPO, hoặc chạy pipeline fine-tuning production — đây là stack.

## TL;DR — Stack Một Cái Nhìn

| # | Thành phần | Giai đoạn | Vai trò | Hướng dẫn sâu |
|---|---|---|---|---|
| 1 | **Unsloth** | Experiment | Fine-tuning single-GPU nhanh, tốc độ 2× + 70% ít VRAM | [Hướng dẫn Unsloth 2026](/vi/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/) |
| 2 | **Axolotl** | Production | Fine-tuning production multi-GPU dựa YAML | [Hướng dẫn Axolotl 2026](/vi/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/) |
| 3 | **HuggingFace datasets + Hub** | Data | Version dataset, share với team, push trọng số đã train | [HF docs] |
| 4 | **Weights & Biases** (hoặc thay thế) | Eval | Theo dõi đường cong loss, điểm eval, sweep hyperparameter | [W&B docs] |
| 5 | **vLLM** | Serving | Serving multi-tenant production mô hình fine-tuned | [So sánh Local LLM Runner](/vi/resources/llm-frameworks/local-llm-runner-comparison-2026/) |

**Tổng chi phí tháng** (không bao gồm vốn training):
- **Hobbyist** (thuê GPU 10h/tuần): **$30-60/tháng**
- **Team production** (1-2 GPU chuyên dụng + monitoring): **$200-400/tháng**
- **Lab AI nhỏ** (cluster 8× H100): **$2000-5000/tháng**

So với nền tảng fine-tuning managed: Together fine-tuning ~$0.50/M token (cộng dồn nhanh với dataset lớn), OpenAI fine-tuning $25/M token (điên ở scale). Self-host thắng ở bất kỳ volume có ý nghĩa + bạn sở hữu trọng số.

## 1. Vì Sao "Stack Fine-Tuning" Cần Định Nghĩa Năm 2026

3 dịch chuyển kết tinh stack:

1. **Unsloth + Axolotl đạt độ chín production** — phân chia "experiment nhanh + scale production" giờ sạch
2. **GRPO trở thành mặc định fine-tuning RL** (sau DeepSeek-R1) — cả Unsloth và Axolotl hỗ trợ native
3. **Mô hình base open-weight đạt class GPT-4** — Llama 3.3 70B, Qwen 3 32B, DeepSeek V3. Fine-tune chúng cho domain của bạn giờ thực sự cạnh tranh với lựa chọn closed

Kết quả: fine-tuning đã chuyển từ research → thực tiễn engineering. Stack phản ánh điều đó.

## 2. Kiến Trúc — Pipeline Experiment-to-Production

```
   ┌──────────────────────────────────────────────────┐
   │ Dataset (JSONL: prompt/response hoặc messages)   │
   │  → Thư viện HuggingFace datasets                 │
   │  → Push tới HuggingFace Hub (versioning)         │
   └────────────────┬─────────────────────────────────┘
                    │
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ Giai đoạn experiment (single GPU, iterate nhanh) │
   │  → Unsloth trên RTX 4090 / H100 thuê             │
   │  → 50+ chạy QLoRA ngắn để tìm công thức thắng    │
   │  → W&B log đường cong loss + điểm eval           │
   └────────────────┬─────────────────────────────────┘
                    │ (công thức thắng đã xác định)
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ Giai đoạn production (multi-GPU, training dài)   │
   │  → Axolotl YAML config (git-tracked)             │
   │  → Cluster 8× H100 cho fine-tune full / long-context│
   │  → W&B log eval cuối                              │
   └────────────────┬─────────────────────────────────┘
                    │
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ Giai đoạn deploy                                 │
   │  → Merge trọng số LoRA + base                    │
   │  → Push mô hình đã merge tới HuggingFace Hub     │
   │  → vLLM serve mô hình sau LiteLLM gateway        │
   └──────────────────────────────────────────────────┘
```

Phân chia là cái làm này hoạt động — iterate nhanh của Unsloth cho khám phá "cái gì hoạt động", độ chắc của Axolotl cho chạy production "giờ scale".

## 3. Thành Phần 1 — Unsloth (Giai Đoạn Experiment)

**Vai trò**: Nơi bạn dành 80% thời gian fine-tuning. Iterate trên format dataset, hyperparameter, lựa chọn mô hình base. Mỗi chu kỳ experiment: 30 phút - 3 giờ trên một GPU đơn thuê.

**Vì sao Unsloth thắng ở đây**: Nhanh hơn 2× HF TRL = 2× experiment per dollar. Ít hơn 70% VRAM = experiment trên RTX 4090 $1500 thay vì cần A100. Xem [Unsloth deep-dive](/vi/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/).

**Cài nhanh**:
```bash
pip install unsloth
```

**Pattern**: thuê RTX 4090 trên Vast.ai ($0.40-0.60/giờ) hoặc RunPod, chạy 10-20 experiment qua cuối tuần, tìm công thức thắng, capture trong notebook cho team review.

## 4. Thành Phần 2 — Axolotl (Giai Đoạn Production)

**Vai trò**: Khi đã tìm thấy công thức thắng, scale lên — full fine-tune, context dài hơn, multi-epoch, multi-GPU. Config YAML mà Axolotl dùng là git-trackable, thân thiện ops-handoff.

**Vì sao Axolotl thắng ở đây**: Training phân tán multi-node hoạt động box-ngoài, hỗ trợ phương pháp rộng nhất (DPO/GRPO/KTO/ORPO/GDPO), config-as-code cho tái lập. Xem [Axolotl deep-dive](/vi/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/).

**Cài nhanh**:
```bash
pip install axolotl
```

**Pattern**: Lấy hyperparameter từ công thức thắng Unsloth → viết YAML Axolotl → chạy trên cluster 8× H100 (Vast.ai ~$15-25/giờ) cho chạy production cuối 6-12 giờ → push trọng số cuối tới HF Hub.

## 5. Thành Phần 3 — HuggingFace Datasets + Hub (Layer Data)

**Vai trò**: Version dataset. Share datasets qua team. Push trọng số mô hình đã train cho testing cộng tác.

**Vì sao đây là pick rõ ràng**: HF đã thắng layer phân phối dataset AI (như GitHub cho code, HF Hub cho mô hình + datasets). Mọi tool fine-tuning tích hợp native với nó.

**Cài nhanh**:
```bash
pip install datasets
huggingface-cli login
```

**Pattern**:
```python
from datasets import load_dataset, Dataset

# Chuẩn bị local + push
data = Dataset.from_json("my_data.jsonl")
data.push_to_hub("yourname/my-finetune-dataset", private=True)

# Member team load
data = load_dataset("yourname/my-finetune-dataset")
```

Cho data nhạy cảm (y tế / tài chính / độc quyền), dùng **datasets riêng tư** trên HF Hub — có kiểm soát truy cập.

## 6. Thành Phần 4 — Weights & Biases (Theo Dõi Eval)

**Vai trò**: Khi chạy 50 experiment để tìm công thức thắng, cần cách so sánh chúng. W&B là lựa chọn de-facto — tự log đường cong loss, điểm eval, hyperparameter, sử dụng phần cứng.

**Cài nhanh** (hoạt động với cả Unsloth và Axolotl qua env var):
```bash
pip install wandb
wandb login
export WANDB_PROJECT="my-finetune-project"
```

Giờ mọi chạy training Unsloth / Axolotl tự log tới dashboard W&B của bạn.

**Chi phí**: W&B free tier hào phóng (user đơn, project public không giới hạn). Project team / private: $50/user/tháng. Lựa chọn: **MLflow** (self-host, free, ít polished), **TensorBoard** (cơ bản nhưng free + local).

## 7. Thành Phần 5 — vLLM (Giai Đoạn Serving)

**Vai trò**: Sau khi đã fine-tune mô hình, serve nó tới user. vLLM là lựa chọn serving multi-tenant production — PagedAttention + continuous batching làm nó nhà vô địch throughput.

Xem [So sánh Local LLM Runner](/vi/resources/llm-frameworks/local-llm-runner-comparison-2026/) cho rundown đầy đủ vì sao vLLM thắng Ollama / LM Studio / llama.cpp cho serving production multi-user.

**Cài nhanh + serve mô hình đã fine-tune**:
```bash
pip install vllm
vllm serve yourname/my-finetuned-llama \
  --enable-lora \
  --lora-modules my-lora=path/to/lora_weights \
  --port 8000
```

Sau [LiteLLM gateway](/vi/resources/llm-frameworks/litellm/) cho auth + rate limiting + virtual key per-customer = API LLM multi-tenant production-ready trên hạ tầng bạn sở hữu.

## 8. Setup Pipeline Day 1 (3-4 giờ)

1. **Datasets ở format JSONL** (varies) — chuẩn bị `train.jsonl` và `eval.jsonl`, push tới HF Hub private
2. **Thuê GPU RTX 4090** (10 phút) — Vast.ai hoặc {{< aff "digitalocean" "ftstack-experiment-gpu" "DigitalOcean GPU droplet" >}} cho giai đoạn experiment
3. **Cài Unsloth + W&B** (10 phút) — `pip install unsloth wandb`
4. **Chạy QLoRA đầu** (60 phút) — Mục 3 của hướng dẫn Unsloth, fine-tune Llama 3.2 8B 1 epoch, verify W&B log xuất hiện
5. **Iterate 5-10 experiment ngắn** (~nửa ngày) — vary learning rate, LoRA rank, slice dataset. Tìm công thức điểm eval tốt nhất
6. **Dịch công thức sang YAML Axolotl** (30 phút) — cùng hyperparameter format YAML, git commit
7. **Thuê cluster 8× H100** cho chạy production (Vast.ai ~$15-20/giờ × 6-12 giờ = $90-240) trên {{< aff "htstack" "ftstack-prod-vps" "HTStack VPS Hong Kong" >}} cho phía data + monitoring
8. **Chạy training production Axolotl** — push trọng số cuối tới HF Hub
9. **Deploy qua vLLM** — serve mô hình fine-tuned trên GPU chuyên dụng 24 GB + LiteLLM gateway
10. **Eval đối với mô hình base** — fine-tune của bạn có thực sự đánh bại base trên eval set? Không? iterate

Sau 3-4 giờ setup + 1-2 tuần experiment, bạn có mô hình fine-tuned riêng được triển khai production.

## 9. Phân Tích Chi Phí

| Item | Hobbyist | Team production | Lab AI nhỏ |
|---|---|---|---|
| GPU experiment (thuê khi cần) | $30-60/tháng | $100-200/tháng | $300-500/tháng |
| Training production (thuê cho chạy) | $0-50/tháng | $200-400/tháng | $1500-3000/tháng |
| GPU serving chuyên dụng (vLLM) | $0 (dùng Ollama thay) | $200/tháng (RTX 4090) | $1000/tháng (H100) |
| HF Hub | $0 (free cho public + private tới 1 GB) | $9/tháng (Pro) | $20/user/tháng (Enterprise) |
| W&B | $0 (free tier) | $50/user/tháng | $50/user/tháng |
| Lưu trữ / bandwidth khác | $5 | $20 | $50 |
| **Tổng** | **~$35-115/tháng** | **~$580-880/tháng** | **~$2870-4570/tháng** |

So với managed: Together fine-tuning $0.50/M token × dataset 100M token = $50 per chạy fine-tuning × 10 experiment = $500/tháng chỉ cho experiment. Self-host thắng ở trên ~10 fine-tune/tháng.

## 10. Đường Nâng Cấp

Khi vượt stack này:

- **Cần fine-tune mô hình > 70B thường xuyên** — Mua hoặc thuê dài hạn cluster H100 thay vì thuê
- **Compliance / data residency** — Di chuyển từ Vast.ai sang bare-metal chuyên dụng ở quản hạt của bạn
- **SaaS fine-tuning multi-tenant** — Thêm layer cô lập user; xem xét LangSmith hoặc eval managed tương tự
- **Vòng fine-tuning liên tục** — Pair với [AI Agent Tool Chain](/vi/collections/ai-agent-tool-chain/) cho trigger retrain tự động khi mô hình production suy giảm
- **RL đặc thù domain** — Thêm reward modeling + vòng GRPO (cả Unsloth và Axolotl hỗ trợ; chỉ cần nhiều compute hơn)

## TL;DR — Recipe

**5 thành phần cho fine-tuning LLM production, hobbyist tới team production $50-300/tháng**:
1. **Unsloth** — giai đoạn experiment single-GPU nhanh
2. **Axolotl** — giai đoạn production multi-GPU
3. **HuggingFace datasets + Hub** — versioning data + phân phối mô hình
4. **Weights & Biases** — theo dõi eval
5. **vLLM** — serving production

Thuê {{< aff "digitalocean" "footer-cta" "GPU droplet" >}} cho experiment, scale tới Vast.ai 8× H100 cho chạy production, deploy mô hình cuối trên GPU chuyên dụng 24 GB. End-to-end self-host, trọng số bạn sở hữu, chi phí scale với mức độ nghiêm túc.

---

*Bộ sưu tập đồng hành: [Stack LLM Rẻ](/vi/collections/cheap-llm-stack/) cover phía chi phí suy luận sau deploy. [AI Agent Tool Chain](/vi/collections/ai-agent-tool-chain/) cho vòng fine-tuning tự động. [Stack Knowledge Base](/vi/collections/knowledge-base-stack/) cho RAG như thay thế fine-tuning trong một số trường hợp.*
