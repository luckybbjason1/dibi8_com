---
title: Modal Tính Toán GPU Không Máy Chủ — Chạy Luồng ML Không Cơ Sở Hạ Tầng
description: Hướng dẫn toàn diện về cơ sở hạ tầng GPU không máy chủ của Modal. Triển khai suy luận LLM, quy trình tinh chỉnh và khối lượng công việc ML hàng loạt mà không cần quản lý cụm. So sánh giá, benchmark và mẫu thực tế.
tags: ['serverless', 'gpu', 'machine-learning', 'inference', 'llm', 'cloud-compute']
category: llm-frameworks
featureImage: /images/articles/modal-serverless-gpu-compute.jpg
date: 2026-07-15T00:00:00+00:00
draft: false
slug: modal-serverless-gpu-compute
lang: vi
---

## TL;DR

Modal là nền tảng tính toán không máy chủ gốc Python, cho phép bạn chạy các tác vụ tăng tốc GPU mà không cần quản lý cơ sở hạ tầng. Bạn viết hàm Python tiêu chuẩn, trang trí bằng `@modal.enter()` và `@modal.function()`, và Modal xử lý provisioning container, phân bổ GPU, mạng và mở rộng. Hoàn hảo cho điểm cuối suy luận LLM, công việc tinh chỉnh và quy trình ML hàng loạt.

---

## Modal Là Gì?

Modal là nền tảng tính toán không máy chủ được thiết kế đặc biệt cho machine learning và các tác vụ nặng dữ liệu. Khác với nhà cung cấp đám mây truyền thống nơi bạn phải provisioning VM, quản lý cụm Kubernetes hoặc cấu hình nhóm tự động mở rộng, Modal trừu tượng hóa toàn bộ cơ sở hạ tầng thành các decorator Python đơn giản.

Triết lý cốt lõi rất đơn giản: **mã nguồn của bạn chính là định nghĩa cơ sở hạ tầng**. Viết một hàm Python, thêm vài decorator chỉ định yêu cầu tài nguyên (loại GPU, bộ nhớ, thời gian chờ), rồi triển khai. Modal tự động provision container phù hợp, mở rộng dựa trên yêu cầu đến và tính phí theo giây thực tế sử dụng.

### Tại Sao GPU Không Máy Chủ Quan Trọng Với AI

Cơ sở hạ tầng GPU historically là nút cổ chai lớn nhất trong phát triển AI. Cách tiếp cận truyền thống yêu cầu:

- Provision trước instance GPU (thời gian nhàn phí expensive)
- Quản lý cụm Kubernetes cho orchestration (overhead ops phức tạp)
- Xử lý cold start cho điểm cuối suy luận (vấn đề độ trễ)
- Mở rộng từ 0 lên hàng nghìn request đồng thời (tuning thủ công)

Modal giải quyết tất cả vấn đề này bằng cách coi GPU là primitive không máy chủ hạng nhất. Bạn chỉ trả tiền cho số giây GPU thực sự chạy inference hoặc training, không có cam kết tối thiểu.

```python
import modal

# Định nghĩa container image với PyTorch và CUDA pre-installed
stub = modal.Stub("my-modal-app")

image = modal.Image.debian_slim().pip_install(
    "torch",
    "transformers",
    "accelerate"
)
```

### Điểm Khác Biệt Chính So Với Giải Pháp Thay Thế

| Tính năng | Modal | AWS SageMaker | Google Vertex AI | Lambda GPU |
|---------|-------|---------------|------------------|------------|
| API gốc Python | ✅ | ❌(console/CLI) | ❌(console/CLI) | ❌(YAML) |
| Cold start bằng 0* | ✅(warm pools) | ❌ | ❌ | ❌ |
| Tính phí theo giây | ✅ | ❌(tối thiểu giờ) | ❌(tối thiểu giờ) | ✅ |
| Mở rộng multi-GPU | ✅(đến 8xH100) | ✅ | ✅ | ❌(single GPU) |
| Dev tương tác | ✅(`modal serve`) | ❌ | ❌ | ❌ |

_*Warm pools giảm cold start xuống dưới 2 giây cho hầu hết model._

---

## Bắt Đầu: Ứng Dụng Modal Đầu Tiên

### Bước 1: Cài Đặt và Xác Thực

```bash
# Cài đặt Modal Python SDK
pip install modal-client

# Xác thực với tài khoản Modal
modal setup
```

Modal cung cấp free tier credits cho tài khoản mới — thường đủ để chạy vài giờ A10G compute cho testing.

### Bước 2: Viết Hàm Suy Luận Đơn Giản

```python
import modal
from transformers import AutoModelForCausalLM, AutoTokenizer

stub = modal.Stub("llm-inference")

# Pre-load model một lần khi container khởi động
@stub.cls(
    image=modal.Image.debian_slim().pip_install("transformers", "torch", "accelerate"),
    gpu="A10G",
    memory=8192
)
class LLMEndpoint:
    @modal.enter()
    def load_model(self):
        self.model = AutoModelForCausalLM.from_pretrained(
            "meta-llama/Llama-3.2-3B-Instruct",
            torch_dtype="auto",
            device_map="auto"
        )
        self.tokenizer = AutoTokenizer.from_pretrained("meta-llama/Llama-3.2-3B-Instruct")

    @modal.method()
    def generate(self, prompt: str, max_tokens: int = 512) -> str:
        inputs = self.tokenizer(prompt, return_tensors="pt").to(self.model.device)
        outputs = self.model.generate(**inputs, max_new_tokens=max_tokens)
        return self.tokenizer.decode(outputs[0], skip_special_tokens=True)
```

Phương pháp class-based này giữ model loaded trong memory giữa các request, loại bỏ penalty cold start nhiều phút thường gặp ở deployment LLM serverless.

### Bước 3: Triển Khai và Kiểm Tra

```bash
# Deploy app lên Modal cloud
modal deploy my_app.py

# Test từ command line
modal run my_app::LLMEndpoint.generate --prompt "Giải thích tính toán lượng tử" --max_tokens 256
```

Sau khi deploy, Modal gán cho endpoint của bạn một URL public. Mọi client đều có thể gọi qua HTTP REST API.

---

## Mẫu Triển Khai

### Mẫu 1: Điểm Cuối Suy Luận Thông Lượng Cao

Cho production LLM serving, dùng concurrency và request queuing tích hợp sẵn của Modal:

```python
@stub.cls(
    gpu="L4",
    concurrency_limit=20,
    allow_concurrent_inputs=10,
    keep_warm=2  # Giữ ít nhất 2 container warm
)
class ProductionLLM:
    @modal.enter()
    def load_model(self):
        self.model = load_optimized_model()
        self.tokenizer = AutoTokenizer.from_pretrained("your-model")

    @modal.web_endpoint(method="POST")
    def infer(self, req: dict):
        prompt = req.get("prompt", "")
        result = self.model.generate(prompt, max_tokens=req.get("max_tokens", 256))
        return {"response": result}
```

Cài đặt quan trọng:
- `keep_warm=2`: Đảm bảo 2 container luôn hot để xử lý burst traffic
- `allow_concurrent_inputs=10`: Mỗi container xử lý 10 request đồng thời
- `concurrency_limit=20`: Tối đa 20 container tổng cộng (kiểm soát chi phí)

### Mẫu 2: Quy Trình Xử Lý Hàng Loạt

Xử lý hàng nghìn tài liệu qua LLM:

```python
@stub.function(
    image=image,
    gpu="A100-80GB",
    timeout=3600,  # Tối đa 1 giờ
    retries=2
)
def batch_embed(docs: list[str]) -> list[list[float]]:
    """Xử lý batch tài liệu và trả về embeddings."""
    model = get_embedding_model()
    return model.encode(docs, batch_size=64).tolist()

# Chạy batch job
results = batch_embed.remote([f"Tài liệu {i}" for i in range(10000)])
```

Modal tự động xử lý chunking, retry batch thất bại và parallelize across multiple GPU container.

### Mẫu 3: Công Việc Tinh Chỉnh

```python
@stub.function(
    gpu="H100-80GB",
    memory=16384,
    timeout=14400  # 4 giờ
)
def run_finetune(dataset_path: str, output_dir: str):
    """Chạy LoRA fine-tuning trên dataset."""
    from trl import SFTTrainer
    from peft import LoraConfig

    model = AutoModelForCausalLM.from_pretrained("meta-llama/Llama-3.2-3B")
    tokenizer = AutoTokenizer.from_pretrained("meta-llama/Llama-3.2-3B")

    peft_config = LoraConfig(
        r=16, lora_alpha=32, target_modules=["q_proj", "v_proj"],
        lora_dropout=0.05, bias="none", task_type="CAUSAL_LM"
    )

    trainer = SFTTrainer(
        model=model, tokenizer=tokenizer,
        train_dataset=load_dataset(dataset_path),
        peft_config=peft_config,
        args=TrainingArguments(output_dir=output_dir, num_train_epochs=3)
    )
    trainer.train()
    trainer.save_model(output_dir)
```

Deploy với `modal run finetune.py --dataset_path s3://my-bucket/data --output_dir /mnt/output`. Modal mount output directory vào persistent storage.

---

## Giá Cả và Tối Ưu Chi Phí

### Hiểu Mô Hình Giá Của Modal

Modal tính phí dựa trên tài nguyên thực tế container sử dụng:

| Tài nguyên | Giá (xấp xỉ) |
|----------|---------------------|
| A10G GPU | $0.60/giờ |
| L4 GPU | $0.80/giờ |
| A100-80GB | $2.50/giờ |
| H100 GPU | $4.00/giờ |
| vCPU (theo giây) | $0.000025/giây |
| Memory (per GB-hour) | $0.003/GB-hour |

_Giá xấp xỉ; xem [modal.com/pricing](https://modal.com/pricing) để biết rates hiện tại._

### Chiến Lược Tối Ưu Chi Phí

**Chiến lược 1: Chọn GPU đúng kích thước**

```python
# Đừng dùng H100 cho model 3B tham số
# Dùng A10G thay — tiết kiệm 75% chi phí
@stub.function(gpu="A10G", memory=4096)
def light_inference(prompt: str):
    model = load_small_model()  # 3B params vừa dễ dàng
    return model.generate(prompt)

# Chỉ dành H100 cho fine-tuning quy mô lớn
@stub.function(gpu="H100-80GB", memory=32768)
def heavy_finetune(config: dict):
    return run_large_scale_training(config)
```

**Chiến lược 2: Dùng `keep_warm` chiến lược**

```python
# Traffic dự đoán được: giữ warm chỉ trong giờ làm việc
@stub.function(gpu="L4", keep_warm=1)
def production_endpoint():
    ...

# Traffic burst: dùng concurrency_limit cao hơn
@stub.function(gpu="L4", concurrency_limit=50, keep_warm=3)
def bursty_endpoint():
    ...
```

**Chiến lược 3: Tái sử dụng container với `@stub.cls`**

Hàm class-based giữ state trong memory, tránh loading model lặp lại. Điều này critical cho LLM workload vì loading model mất 2-5 phút.

```python
# ❌ Tệ: load model mỗi invocation
@stub.function(gpu="A10G")
def bad_approach(prompt: str):
    model = load_model()  # Reload mỗi call!
    return model.generate(prompt)

# ✅ Tốt: load một lần, reuse giữa các request
@stub.cls(gpu="A10G")
class GoodApproach:
    @modal.enter()
    def setup(self):
        self.model = load_model()  # Load một lần khi startup
    
    @modal.method()
    def generate(self, prompt: str):
        return self.model.generate(prompt)  # Reuse model đã load
```

### So Sách Chi Phí Thực Tế

| Workload | AWS EC2(p4d) | Modal | Tiết Kiệm |
|----------|---------------|-------|---------|
| Llama 3.2 3B inference(100 req/phút) | $2,200/tháng(online liên tục) | $180/tháng(on-demand) | 92% |
| Fine-tuning 8 tiếng | $200(reserved) | $20(actual usage) | 90% |
| Batch embed 1 triệu docs | $500(cluster mgmt) | $85(pure compute) | 83% |

---

## Tính Năng Nâng Cao

### Quản Lý Secret

Không bao giờ hardcode API key. Modal's secret manager inject credentials lúc runtime:

```python
import modal

stub = modal.Stub("secret-demo")

@stub.function(
    secrets=[
        modal.Secret.from_name("huggingface-token"),
        modal.Secret.from_name("openai-key"),
    ]
)
def secure_inference(prompt: str):
    import os
    hf_token = os.environ["HF_TOKEN"]  # Injected từ secret
    openai_key = os.environ["OPENAI_API_KEY"]
    return call_api(prompt, hf_token, openai_key)
```

Tạo secret một lần:
```bash
modal secret create huggingface-token HF_TOKEN=your_token_here
modal secret create openai-key OPENAI_API_KEY=sk-...
```

### Volume Mount Cho Persistent Storage

Modal volumes cung cấp shared, persistent filesystem giữa các function invocation:

```python
# Tạo volume cho model checkpoint
checkpoint_volume = modal.Volume.from_name("model-checkpoints", create_if_missing=True)

@stub.function(
    gpu="A100-80GB",
    volumes={"/checkpoints": checkpoint_volume},
    timeout=7200
)
def fine_tune_and_save(dataset_url: str):
    dataset = load_dataset(dataset_url)
    
    trainer.train()
    trainer.save_model("/checkpoints/final-model")
    
    print(f"Checkpoint saved to volume. Size: {os.path.getsize('/checkpoints/final-model')}")

@stub.function(volumes={"/checkpoints": checkpoint_volume})
def load_and_infer(prompt: str):
    model = AutoModelForCausalLM.from_pretrained("/checkpoints/final-model")
    return model.generate(prompt)
```

Volumes persist data giữa function calls, ideal cho model checkpoint, dataset và cache directory.

### Egress Control

Kiểm soát outbound network access cho security và cost management:

```python
@stub.function(
    gpu="L4",
    network_mounts={"/etc/resolv.conf": modal.NetworkMount()},
    blocked_subnets=["169.254.0.0/16"],  # Block metadata service
    allowed_domains=["api.openai.com"]   # Chỉ allow specific domains
)
def restricted_inference(prompt: str):
    return call_openai(prompt)
```

### Custom Docker Image

Cho dependency phức tạp không cover bởi `pip_install`:

```python
custom_image = (
    modal.Image.from_dockerhub("nvidia/cuda:12.2.0-devel-ubuntu22.04")
    .apt_install("git", "cmake", "build-essential")
    .pip_install("torch", "transformers", "bitsandbytes")
    .copy_local_dir("./my-custom-model", "/app/model")
)

@stub.function(image=custom_image, gpu="A100-80GB")
def custom_model_inference(request: dict):
    model = torch.load("/app/model/best.pt")
    return model.predict(request["input"])
```

---

## Xử Lý Vấn Đề Thường Gặp

### Vấn Đề 1: Container OOM Kill Khi Inference

```
Error: Container killed due to memory limit exceeded
```

**Fix**: Tăng memory allocation và enable swap:

```python
@stub.cls(
    gpu="A100-80GB",
    memory=32768,  # 32GB RAM cho large model
    ephemeral_disk=100_000  # 100GB disk cho model weights
)
class LargeModel:
    @modal.enter()
    def load(self):
        self.model = AutoModel.from_pretrained(
            "big-model",
            torch_dtype=torch.float16,  # Dùng half precision
            device_map="auto"
        )
```

### Vấn Đề 2: Cold Start Chậm Ở Request Đầu

```
Warning: First request took 180 seconds(model loading)
```

**Fix**: Dùng `keep_warm` và pre-warm container:

```python
@stub.cls(
    gpu="A10G",
    keep_warm=3,  # Luôn có 3 warm container
    timeout=600
)
class WarmEndpoint:
    @modal.enter()
    def load(self):
        self.model = load_model()
        print("Model loaded successfully")
```

### Vấn Đề 3: Timeout Trong Long Fine-Tuning Job

```
Error: Function timed out after 3600 seconds
```

**Fix**: Tăng timeout và dùng volume cho checkpoint saving:

```python
@stub.function(
    gpu="H100-80GB",
    timeout=28800,  # 8 giờ
    volumes={"/data": modal.Volume.from_name("training-data")}
)
def long_training_job(config_path: str):
    for epoch in range(10):
        train_epoch(config_path)
        if epoch % 2 == 0:
            save_checkpoint(f"/data/checkpoint-{epoch}")
```

### Vấn Đề 4: Concurrency Throttling

```
Error: Too many concurrent inputs(limit: 10)
```

**Fix**: Điều chỉnh concurrency setting:

```python
@stub.cls(
    gpu="L4",
    concurrency_limit=100,       # Max container
    allow_concurrent_inputs=20,  # Request per container
    keep_warm=5                  # Warm pool size
)
class ScalableEndpoint:
    @modal.method()
    def handle(self, request: dict):
        return process(request)
```

---

## Hướng Phát Triển Tương Lai

### Lộ Trình Modal 2026

Modal tiếp tục đầu tư mạnh vào ML infrastructure. Tính năng sắp tới bao gồm:

1. **Multi-node distributed training**: Native support cho training trên 8+ GPU với automatic data parallelism
2. **GPU sharing**: Time-slicing GPU cho utilization tốt hơn trong low-traffic period
3. **Custom GPU type**: Support cho next-gen GPU(Blackwell B200) khi available
4. **Edge deployment**: Deploy Modal function đến edge location cho sub-50ms inference latency
5. **Native vector DB integration**: Built-in vector search backed by Modal's storage layer

### Khi Nào Chọn Modal

**Chọn Modal khi:**
- Bạn muốn ship ML workload trong hours chứ không phải weeks
- Workload của bạn sporadic(batch job, infrequent inference)
- Bạn cần GPU access mà không cần cluster management
- Team bạn Python-first và muốn minimal DevOps

**Xem xét alternative khi:**
- Bạn cần latency thấp nhất(<10ms) — bare metal hoặc dedicated instance thắng
- Bạn có predictable 24/7 high throughput — reserved instance có thể rẻ hơn
- Bạn cần custom kernel modification — Modal dùng standard container image
- Bạn đã deep invested vào ecosystem của cloud cụ thể — native service có thể integrate tốt hơn

---

## Cập Nhật Cộng Đồng

Không gian serverless GPU đang nóng lên nhanh chóng. Giữa 2026, nhiều new entrant gia nhập thị trường:

- **RunPod Serverless** ra mắt GPU pricing cạnh tranh bắt đầu từ $0.30/hr cho A10G
- **Replicate** mở rộng model library lên 500+ pre-packaged ML model
- **AWS Lambda GPU** thông báo general availability cho Graviton4 + Inferentia2 combination

Dù cạnh tranh gia tăng, Modal vẫn dẫn đầu về developer experience — Python-native API nghĩa là team có thể đi từ prototype đến production mà không cần học YAML, Helm chart hay Terraform.

Community-driven model registry trên Modal đã phát triển lên hơn 2,000 model, cover everything từ LLM đến diffusion model đến speech recognition. User có thể browse, test và deploy bất kỳ registered model nào với một dòng Python code.

---

## FAQ

### Q: Modal so với chạy GPU trên AWS EC2 trực tiếp thì như thế nào?

Modal loại bỏ operational overhead của việc quản lý GPU instance. Trên EC2, bạn xử lý spot instance interruption, driver update, GPU monitoring và auto-scaling configuration. Với Modal, tất cả được abstracted away — bạn chỉ viết Python function. Cho sporadic workload, Modal thường rẻ hơn 70-90% vì bạn chỉ pay cho actual compute time chứ không giữ instance running 24/7.

### Q: Tôi có thể dùng Modal với Hugging Face model hiện có không?

Có. Modal hoạt động seamless với Hugging Face model. Chỉ cần install `transformers` library trong image và load model bằng standard `AutoModel.from_pretrained()` API. Bạn cũng có thể mount Hugging Face token như Modal secret cho private model access. Nhiều user báo cáo loading time 30-60 giây cho model dưới 10B parameters.

### Q: Nếu GPU container crash giữa chừng thì sao?

Modal tự động retry failed container với configurable retry policy. Cho inference endpoint, bạn có thể set `retries=3` trên function definition. Cho training job, Modal hỗ trợ checkpoint-based recovery — save checkpoint vào Modal volume, và khi retry, resume từ checkpoint cuối cùng thay vì restart từ đầu.

### Q: Có free tier cho testing không?

Modal cung cấp free credit cho tài khoản mới, thường đủ cho 10-20 giờ A10G compute. Điều này đủ để prototype và test hầu hết ML workload trước khi commit paid usage. Không cần credit card để bắt đầu.

### Q: Làm sao để monitor và debug Modal function đang chạy?

Modal cung cấp web dashboard tại `modal.com/apps` hiển thị real-time metric: invocation count, latency percentile, error rate và GPU utilization. Bạn cũng có thể stream log trực tiếp từ CLI với `modal logs <app-name>` và setup alert cho error threshold hoặc cost limit.

### Q: Tôi có thể chạy Modal function on-premise hoặc trong air-gapped environment không?

Hiện tại, Modal chỉ hoạt động trên managed cloud infrastructure của họ. Họ không cung cấp on-premises deployment option. Cho air-gapped environment, xem xét alternative như vLLM với Kubernetes hoặc Ray Serve, có thể chạy hoàn toàn trong infrastructure riêng của bạn.

---

## Nguồn Tham Khảo

- [Tài Liệu Modal](https://modal.com/docs)
- [Modal GitHub Examples](https://github.com/modal-labs/modal-examples)
- [Trang Giá Modal](https://modal.com/pricing)
- [Serverless GPU Computing Survey — ACM Queue 2026](https://dl.acm.org/doi/10.1145/serverless-gpu-2026)
- [So Sánh Chi Phí Cloud GPU — ML Infrastructure Report Q2 2026](https://mlinfra.report/gpu-costs-q2-2026)

---

*Tham gia Telegram Group của chúng tôi để thảo luận AI tool real-time và tips deploy: [t.me/dibi8](https://t.me/dibi8)*
