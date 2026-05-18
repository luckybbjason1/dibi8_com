---
title: 'So Sánh Framework Fine-Tuning LLM 2025: LoRA, QLoRA, PEFT và Unsloth'
description: 'So sánh chi tiết các framework fine-tuning LLM 2025: LoRA, QLoRA, PEFT Hugging Face và Unsloth. Hướng dẫn chọn phương pháp tối ưu VRAM và tốc độ.'
date: 2026-05-18 00:00:00+08:00
lastmod: 2026-05-18 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
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
last_maintained: '2026-05-18'
featureImage: ''
draft: false
aliases:
- /posts/llm-fine-tuning-frameworks-comparison/
---

{</* resource-info */>}

Fine-tuning là kỹ thuật cho phép điều chỉnh mô hình ngôn ngữ lớn để hoạt động tốt hơn trên tác vụ hoặc miền dữ liệu cụ thể. Tuy nhiên, việc fine-tuning toàn bộ tham số của một mô hình như Llama 3 70B đòi hỏi hàng trăm GB VRAM — con số nằm ngoài tầm với của hầu hết các tổ chức. Các phương pháp fine-tuning hiệu quả tham số (Parameter-Efficient Fine-Tuning — PEFT) ra đờii để giải quyết bài toán này. Bài viết so sánh chi tiết bốn công nghệ hàng đầu năm 2025: LoRA, QLoRA, PEFT, và Unsloth.

## Tại Sao Cần Fine-Tune Large Language Models?

### Full Fine-Tuning So Với Parameter-Efficient Fine-Tuning

Full fine-tuning cập nhật toàn bộ tham số của mô hình. Với Llama 3 70B (70 tỷ tham số ở độ chính xác 16-bit), bạn cần khoảng 140GB chỉ để lưu trữ trọng số, chưa kể optimizer states và gradients. Tổng cộng có thể cần 500-700GB VRAM — chỉ có thể thực hiện trên cluster nhiều GPU A100.

Parameter-efficient fine-tuning chỉ cập nhật một lượng nhỏ tham số bổ sung (thường <1% tổng số tham số), giảm yêu cầu VRAM xuống hàng chục lần trong khi vẫn đạt hiệu suất tương đương 90-99% so với full fine-tuning [^1^](https://huggingface.co/docs/peft).

### Khi Nào Fine-Tune, Khi Nào Dùng RAG?

Fine-tuning phù hợp khi bạn cần thay đổi hành vi của mô hình (writing style, format output, tác vụ chuyên biệt). RAG phù hợp khi cần cung cấp kiến thức domain-specific mà không cần thay đổi trọng số mô hình. Trong thực tế, nhiều hệ thống tốt nhất kết hợp cả hai.

## LoRA (Low-Rank Adaptation)

### LoRA Hoạt Động Như Thế Nào?

LoRA, được giới thiệu trong bài báo năm 2021 của Microsoft Research [^2^](https://arxiv.org/abs/2106.09685), dựa trên một insight quan trọng: ma trận cập nhật trong quá trình fine-tuning có rank thấp. Thay vì cập nhật toàn bộ ma trận trọng số W, LoRA thêm hai ma trận nhỏ A và B sao cho:

```
W' = W + BA
```

Trong đó A có kích thước (r × d) và B có kích thước (d × r), với r << d. Rank r thường chọn từ 8 đến 128, giảm số tham số cần huấn luyện từ d×d xuống 2×d×r.

### Các Hyperparameter Quan Trọng

| Tham Số | Mô Tả | Giá Trị Phổ Biến |
|---------|-------|------------------|
| rank (r) | Rank của ma trận phân rã | 8, 16, 32, 64, 128 |
| alpha | Scaling factor | 2× rank (thường) |
| dropout | Tỷ lệ dropout | 0.0 - 0.1 |
| target_modules | Các lớp áp dụng LoRA | q_proj, v_proj, k_proj, o_proj |

### Các Module Mục Tiêu

Với kiến trúc transformer, LoRA thường áp dụng cho các projection layers trong attention mechanism:

- `q_proj`: Query projection
- `k_proj`: Key projection
- `v_proj`: Value projection
- `o_proj`: Output projection
- `gate_proj`, `up_proj`, `down_proj`: Feed-forward layers (tùy chọn)

Áp dụng LoRA cho cả attention và feed-forward layers tăng số tham số huấn luyện nhưng thường cho kết quả tốt hơn.

## QLoRA: Quantization + LoRA Cho GPU Phổ Thông

### Quantization 4-bit Với bitsandbytes

QLoRA, giới thiệu năm 2023 bởi Tim Dettmers [^3^](https://github.com/TimDettmers/bitsandbytes), kết hợp quantization 4-bit với LoRA để fine-tune model lớn trên GPU consumer. Thay vì lưu toàn bộ model ở 16-bit (cần ~140GB cho 70B), QLoRA lưu model base ở 4-bit (~35GB) và chỉ giữ LoRA adapters ở 16-bit.

### Double Quantization Và NF4

QLoRA sử dụng hai kỹ thuật tối ưu:

- **NF4 (Normal Float 4-bit)**: Định dạng 4-bit tối ưu cho trọng số neural network có phân phối chuẩn
- **Double Quantization**: Quantize cả các hằng số tĩnh trong quá trình quantization, giảm thêm bộ nhớ khoảng 0.5GB cho model 65B

### Paged Optimizers

Paged optimizers sử dụng bộ nhớ CPU để offload optimizer states khi GPU hết VRAM, cho phép fine-tune model lớn hơn khả năng vật lý của GPU. Điều này đặc biệt hữu ích khi sequence length dài hoặc batch size lớn.

### So Sánh QLoRA Và LoRA

| Tiêu Chí | LoRA | QLoRA |
|----------|------|-------|
| VRAM (Llama 3 8B) | ~16GB | ~6GB |
| VRAM (Llama 3 70B) | ~140GB+ | ~36GB |
| Tốc độ huấn luyện | Nhanh hơn 20-30% | Chậm hơn do dequantization |
| Chất lượng output | Cao nhất | ~97-99% so với LoRA |
| GPU phổ thông | Không | RTX 4090 (24GB) được |

## PEFT: Thư Viện Fine-Tuning Thống Nhất Củaa Hugging Face

### Tổng Quan Thư Viện PEFT

PEFT (Parameter-Efficient Fine-Tuning) là thư viện của Hugging Face cung cấp API thống nhất cho tất cả các phương pháp fine-tuning hiệu quả tham số [^1^](https://huggingface.co/docs/peft). PEFT tích hợp chặt chẽ với thư viện Transformers và Accelerate, cho phép chuyển đổi giữa các phương pháp chỉ bằng vài dòng code.

### Các Phương Pháp Được Hỗ Trợ

PEFT hỗ trợ nhiều phương pháp fine-tuning:

- **LoRA**: Phổ biến nhất, cân bằng tốt giữa hiệu suất và tài nguyên
- **IA3**: Tương tự LoRA nhưng chỉ huấn luyện vector tỷ lệ, ít tham số hơn
- **AdaLoRA**: Tự động điều chỉnh rank cho từng layer
- **Prefix Tuning**: Thêm prefix vectors vào đầu mỗi layer
- **Prompt Tuning**: Huấn luyện soft prompts
- **P-Tuning**: Tương tự prompt tuning với mạng nhỏ

### Tích Hợp Với Transformers Và Accelerate

```python
from peft import LoraConfig, get_peft_model
from transformers import AutoModelForCausalLM

model = AutoModelForCausalLM.from_pretrained("meta-llama/Llama-3-8B")

peft_config = LoraConfig(
    r=16,
    lora_alpha=32,
    target_modules=["q_proj", "v_proj"],
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM"
)

model = get_peft_model(model, peft_config)
model.print_trainable_parameters()  # Chỉ ~0.5% tham số
```

### Lưu Và Tải Adapters

PEFT cho phép lưu chỉ các adapter weights (chỉ vài MB) thay vì toàn bộ model (hàng chục GB). Điều này giúp chia sẻ và deployment nhanh chóng:

```python
# Lưu adapter
model.save_pretrained("./lora-adapter")

# Tải adapter
from peft import PeftModel
model = PeftModel.from_pretrained(base_model, "./lora-adapter")
```

## Unsloth: Framework Fine-Tuning Nhanh Nhất

### Điều Gì Làm Unsloth Nhanh Hơn 2-5 Lần?

Unsloth, ra mắt năm 2024 [^4^](https://github.com/unslothai/unsloth), là framework fine-tuning tối ưu hóa hiệu suất nhất hiện nay. Unsloth tự nhận nhanh hơn 2-5 lần so với PEFT + Flash Attention 2 tiêu chuẩn nhờ nhiều kỹ thuật tối ưu:

- **Handwritten GPU kernels**: CUDA kernels được viết tay tối ưu cho từng thao tác
- **Tối ưu bộ nhớ**: Giảm VRAM sử dụng đến 80%
- **Fused operations**: Gộp nhiều thao tác thành một kernel duy nhất
- **Tự động patching**: Tự động thay thế các hàm của Transformers bằng phiên bản tối ưu

### Giảm VRAM Sử Dụng

Unsloth cho phép fine-tune Llama 3 8B trên GPU chỉ 4GB VRAM — điều không thể với các framework khác:

| Model | VRAM Tiêu Chuẩn | VRAM Unsloth | Tiết Kiệm |
|-------|-----------------|--------------|-----------|
| Llama 3 8B (LoRA) | 16GB | 5.3GB | 67% |
| Llama 3 8B (QLoRA) | 6GB | 4.2GB | 30% |
| Mistral 7B (QLoRA) | 6GB | 4.0GB | 33% |
| Gemma 2 9B (QLoRA) | 7GB | 5.1GB | 27% |

### Các Model Và Kiến Trúc Được Hỗ Trợ

Unsloth hỗ trợ hầu hết các model phổ biến: Llama 3.x, Mistral, Gemma, Qwen, Phi, và nhiều model khác. Tuy nhiên, Unsloth yêu cầu sử dụng FastLanguageModel thay vì AutoModel tiêu chuẩn.

### Unsloth Pro So Với Phiên Bản Miễn Phí

Unsloth có phiên bản Pro với các tính năng bổ sung:

- **Flash Attention 3**: Tối ưu mới nhất cho GPU Hopper
- **Đào tạo 2x nhanh hơn**: So với phiên bản free
- **Support ưu tiên**: Hỗ trợ kỹ thuật 1-1
- **Giá**: Từ $30/tháng

Phiên bản miễn phí đã đầy đủ tính năng cho hầu hết các use case.

## So Sánh Trực Tiếp

### So Sánh Tốc Độ Huấn Luyện

| Framework | Tốc Độ (samples/sec, Llama 3 8B) | So Với Baseline |
|-----------|-----------------------------------|-----------------|
| PEFT + Flash Attention 2 | 2.4 | 1.0x (baseline) |
| PEFT + Flash Attention 2 + QLoRA | 2.1 | 0.88x |
| Unsloth (LoRA) | 6.2 | 2.6x |
| Unsloth (QLoRA) | 5.8 | 2.4x |

### So Sánh VRAM Yêu Cầu

| VRAM Có Sẵn | Phương Pháp Tốt Nhất | Model Tối Đa |
|-------------|----------------------|--------------|
| 4-6 GB | Unsloth QLoRA | Llama 3 8B |
| 8-12 GB | Unsloth LoRA | Llama 3 8B |
| 16-24 GB | LoRA hoặc Unsloth | Llama 3 70B (QLoRA) |
| 40-48 GB | LoRA | Llama 3 70B |
| 80 GB | LoRA full-rank cao | Llama 3 70B |

### So Sánh Chất Lượng Model

| Phương Pháp | % Tham Số Huấn Luyện | Chất Lượng So Với Full FT |
|-------------|----------------------|---------------------------|
| Full Fine-tuning | 100% | 100% (baseline) |
| LoRA (r=64) | 2.5% | 98-99% |
| QLoRA (r=64) | 2.5% | 96-98% |
| LoRA (r=16) | 0.6% | 95-97% |
| IA3 | 0.4% | 94-96% |

## Hướng Dẫn Fine-Tuning Từng Bước

### Chuẩn Bị Môi Trường

Bạn có thể fine-tuning trên nhiều nền tảng:

- **Google Colab**: Miễn phí GPU T4 (16GB), phù hợp model nhỏ với QLoRA
- **RunPod**: GPU thuê theo giờ (RTX 4090, A100), linh hoạt
- **Local**: RTX 4090 24GB hoặc RTX 3090 cho model đến 8B

### Chuẩn Bị Dataset

Dataset cần được định dạng theo dạng hội thoại:

```json
[
  {
    "messages": [
      {"role": "system", "content": "Bạn là trợ lý chuyên về y khoa."},
      {"role": "user", "content": "Triệu chứng của bệnh tiểu đường là gì?"},
      {"role": "assistant", "content": "Các triệu chứng phổ biến bao gồm..."}
    ]
  }
]
```

### Fine-Tuning Llama 3 Với LoRA/QLoRA

```python
from transformers import TrainingArguments, Trainer
from peft import LoraConfig, get_peft_model

# 1. Load model và tokenizer
model = AutoModelForCausalLM.from_pretrained("meta-llama/Meta-Llama-3-8B")
tokenizer = AutoTokenizer.from_pretrained("meta-llama/Meta-Llama-3-8B")

# 2. Áp dụng LoRA
peft_config = LoraConfig(r=16, lora_alpha=32, target_modules=["q_proj", "v_proj"])
model = get_peft_model(model, peft_config)

# 3. Cấu hình training
training_args = TrainingArguments(
    output_dir="./results",
    num_train_epochs=3,
    per_device_train_batch_size=4,
    learning_rate=2e-4,
    logging_steps=10,
    save_strategy="epoch"
)

# 4. Training
trainer = Trainer(model=model, args=training_args, train_dataset=dataset)
trainer.train()
```

### Fine-Tuning Với Unsloth (Nhanh Hơn)

```python
from unsloth import FastLanguageModel, UnslothTrainer

model, tokenizer = FastLanguageModel.from_pretrained(
    model_name="unsloth/Meta-Llama-3.1-8B",
    max_seq_length=2048,
    load_in_4bit=True,
)

model = FastLanguageModel.get_peft_model(
    model, r=16, target_modules=["q_proj", "k_proj", "v_proj", "o_proj"]
)

trainer = UnslothTrainer(model=model, tokenizer=tokenizer, train_dataset=dataset)
trainer.train()
```

### Đánh Giá Model

Sau fine-tuning, đánh giá model trên tập validation:

- **Perplexity**: Đo lường khả năng dự đoán của model
- **BLEU/ROUGE**: So sánh với reference answers
- **LLM-as-a-judge**: Dùng GPT-4 đánh giá chất lượng câu trả lờii
- **Human evaluation**: Đánh giá thủ công trên mẫu nhỏ

### Merge Adapters Và Export GGUF

```python
# Merge LoRA vào base model
model = model.merge_and_unload()
model.save_pretrained("./merged-model")

# Hoặc export sang GGUF cho Ollama
# Sử dụng llama.cpp convert script
```

## Các Phương Pháp Tốt Nhất

### Chọn Base Model Phù Hợp

| Use Case | Model Đề Xuất | Kích Thước |
|----------|---------------|------------|
| Chatbot tiếng Việt | Qwen2.5, Vistral | 7B |
| Coding assistant | DeepSeek Coder, Codestral | 7B-22B |
| General purpose | Llama 3.1, Mistral | 8B |
| Tóm tắt văn bản | Llama 3.1, Gemma 2 | 9B |

### Chuẩn Bị Và Làm Sạch Dataset

- **Chất lượng > số lượng**: 1,000 ví dụ chất lượng cao tốt hơn 10,000 ví dụ kém chất lượng
- **Đa dạng prompts**: Bao gồm nhiều cách diễn đạt cùng một yêu cầu
- **Xử lý dữ liệu nhạy cảm**: Loại bỏ PII trước khi training
- **Cân bằng classes**: Đảm bảo phân phối đều giữa các category

### Tuning Hyperparameter

- **Learning rate**: 1e-4 đến 5e-4 (QLoRA có thể cao hơn một chút)
- **Rank (r)**: 8-16 cho đơn giản, 32-128 cho phức tạp
- **Alpha**: Thường bằng 2× rank
- **Epochs**: 1-3 (quá nhiều epochs dễ overfit)
- **Batch size**: Càng lớn càng ổn định, nhưng cần nhiều VRAM

### Tránh Overfitting Và Catastrophic Forgetting

- Sử dụng early stopping dựa trên validation loss
- Giữ lại một phần dữ liệu general trong training set
- Dùng techniques như replay buffer hoặc EWC
- Đánh giá model trên cả tác vụ mới và tác vụ cũ

## Triển Khai Model Đã Fine-Tune

### Merge LoRA Weights Với Base Model

```python
from peft import PeftModel

base_model = AutoModelForCausalLM.from_pretrained("meta-llama/Llama-3-8B")
model = PeftModel.from_pretrained(base_model, "./lora-adapter")
model = model.merge_and_unload()
model.save_pretrained("./full-model")
```

### Chuyển Đổi Sang GGUF

```bash
python convert-hf-to-gguf.py --outfile model.gguf ./full-model
```

### Triển Khai Với vLLM

```python
from vllm import LLM

llm = LLM(model="./full-model")
output = llm.generate("Câu hỏi của ngườii dùng")
```

### Upload Lên Hugging Face Hub

```python
from huggingface_hub import HfApi
api = HfApi()
api.upload_folder(folder_path="./full-model", repo_id="username/my-model")
```

## Các Công Cụ Thay Thế Và Bổ Trợ

### Axolotl

Axolotl là framework fine-tuning YAML-based cho phép định nghĩa toàn bộ quá trình training trong một file config duy nhất. Phù hợp cho ngườii dùng muốn workflow đơn giản, không cần viết code Python.

### LLaMA-Factory

LLaMA-Factory cung cấp giao diện web UI trực quan cho việc fine-tuning, hỗ trợ hơn 100 model architectures. Đặc biệt phù hợp cho ngườii mới bắt đầu nhờ UI thân thiện.

### Torchtune

Torchtune là thư viện fine-tuning native PyTorch của Meta, tối ưu cho các model Llama. Ưu điểm là tích hợp chặt với PyTorch ecosystem nhưng hỗ trợ ít model hơn PEFT.

## Kết Luận

Năm 2025, Unsloth là lựa chọn tốt nhất cho hầu hết các trường hợp fine-tuning nhờ tốc độ vượt trội và tiết kiệm VRAM. PEFT + Transformers vẫn là lựa chọn đáng tin cậy với ecosystem rộng nhất. QLoRA là giải pháp cứu cánh khi VRAM hạn chế. LoRA tiêu chuẩn phù hợp khi bạn có đủ tài nguyên và muốn chất lượng cao nhất.

## Câu Hỏi Thường Gặp

### LoRA Hay QLoRA: Nên Dùng Cái Nào?

Dùng QLoRA nếu VRAM GPU của bạn dưới 16GB — đây là lựa chọn duy nhất để fine-tune model lớn trên GPU phổ thông. Dùng LoRA nếu bạn có 24GB VRAM trở lên và muốn chất lượng cao nhất. Với model nhỏ (7B-8B), cả hai cho kết quả tương đương.

### Unsloth Có Thực Sự Nhanh Hơn PEFT Tiêu Chuẩn Không?

Có. Benchmark độc lập cho thấy Unsloth nhanh hơn 2-5 lần so với PEFT + Flash Attention 2 tiêu chuẩn khi fine-tuning Llama và Mistral models. Tuy nhiên, Unsloth hỗ trợ ít model architectures hơn PEFT, nên hãy kiểm tra model của bạn có được hỗ trợ không.

### Cần Bao Nhiêu VRAM Để Fine-Tuning?

Với Unsloth QLoRA: 4GB có thể fine-tune Llama 3 8B. Với PEFT QLoRA: 6GB cho model 8B. Với LoRA đầy đủ: 16GB cho model 8B, 36GB cho model 70B (QLoRA), hoặc 140GB+ cho model 70B (LoRA).

### Có Thể Fine-Tune Trên Google Colab Miễn Phí Không?

Có. Colab free cung cấp GPU T4 16GB, đủ để fine-tune model 7B với QLoRA hoặc Unsloth. Tuy nhiên, session Colab free có giới hạn 12 giờ và có thể bị ngắt. Đối với model lớn hơn, cần Colab Pro hoặc nền tảng thuê GPU như RunPod.

### Sự Khác Biệt Giữa PEFT Và Full Fine-Tuning Là Gì?

PEFT chỉ huấn luyện <1% tham số của model (thường là adapter layers), giảm VRAM cần thiết đi hàng chục lần. Full fine-tuning cập nhật toàn bộ trọng số, cần nhiều tài nguyên hơn nhưng có thể đạt chất lượng cao hơn một chút trên một số tác vụ. Trong thực tế, PEFT đạt 95-99% hiệu suất của full fine-tuning.

---

## Hạ Tầng Đề Xuất

Để chạy các công cụ trên 24/7 ổn định, lựa chọn hạ tầng rất quan trọng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 tín dụng miễn phí 60 ngày, 14+ region toàn cầu.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp. dibi8.com cũng host ở đây.
- **[Hostinger](https://www.hostinger.com/vn?REFERRALCODE=22RPIAOJIYJN)** — VPS giá tốt cho thị trường Việt Nam.

*Đây là affiliate link, không tăng chi phí của bạn nhưng giúp dibi8.com duy trì hoạt động.*

