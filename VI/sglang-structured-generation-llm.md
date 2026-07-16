---
title: SGLang — Structured Generation Và Engine Serving LLM Tốc Độ Cao
description: Hướng dẫn toàn diện về SGLang(Structured Generation Language). Serving LLM hiệu suất cao với constrained decoding, JSON schema enforcement, parallel execution và tăng tốc 25x so với vLLM cho structured output.
tags: ['llm-serving', 'structured-generation', 'constrained-decoding', 'inference', 'performance']
category: llm-frameworks
featureImage: /images/articles/sglang-structured-generation-llm.jpg
date: 2026-07-15T00:00:00+00:00
draft: false
slug: sglang-structured-generation-llm
lang: vi
---

## TL;DR

SGLang(Structured Generation Language) là thư viện mã nguồn mở để deploy và serving large language model. Nó gồm hai component chính: SGLang Runtime (server hiệu suất cao serve LLM endpoint với optimized memory management và request scheduling) và SGLang Python Library (ngôn ngữ lập trình để viết LLM application với structured output, tool calling và multi-step reasoning). Nó đạt throughput improvement 25x so với vLLM cho structured output task và hỗ trợ serving model từ 1B đến 70B parameter trên single hoặc multi-GPU setup.

---

## SGLang Là Gì?

SGLang(Structured Generation Language) là full-stack library để deploy và serving large language model. Nó gồm hai component chính:

1. **SGLang Runtime**: High-performance server serve LLM endpoint với optimized memory management và request scheduling
2. **SGLang Python Library**: Ngôn ngữ lập trình để viết LLM application với structured output, tool calling và multi-step reasoning

### Vấn Đề SGLang Giải Quyết

Traditional LLM serving engine(vLLM, TGI, text-generation-inference) xuất sắc ở raw token generation nhưng struggle với:

- **Structured output enforcement**: Getting reliable JSON, regex-matched hoặc grammar-constrained output yêu cầu post-processing phá vỡ streaming
- **Prefix cache reuse**: Khi nhiều request share common context(system prompt, document chunk), mỗi engine recomputes attention từ scratch
- **Complex reasoning flow**: Implement ReAct, multi-step tool calling hoặc decision tree yêu cầu custom orchestration code

SGLang giải quyết cả ba native. RadixAttention system của nó xây dựng shared radix tree của KV cache giữa request, trong khi constrained decoding engine đảm bảo structured output tại generation time — không phải sau đó.

---

## Bắt Đầu

### Bước 1: Cài Đặt SGLang

```bash
# Cài đặt Python library
pip install sglang

# Hoặc dùng Docker cho GPU acceleration
docker pull sglang/sglang:latest
docker run --gpus all -p 30000:30000 sglang/sglang:latest \
  --model-path meta-llama/Llama-3.2-8B-Instruct \
  --host 0.0.0.0 --port 30000
```

### Bước 2: Khởi Động Server

```bash
# Serve một model trên một GPU
python -m sglang.launch_server \
  --model-path meta-llama/Llama-3.2-8B-Instruct \
  --port 30000

# Multi-GPU tensor parallelism
python -m sglang.launch_server \
  --model-path meta-llama/Llama-3.2-70B-Instruct \
  --tensor-parallel-size 4 \
  --port 30000

# Với quantization cho tiết kiệm chi phí
python -m sglang.launch_server \
  --model-path Qwen/Qwen2.5-72B-Instruct-AWQ \
  --quantization awq \
  --port 30000
```

### Bước 3: Request Đầu Tiên

```bash
curl http://localhost:30000/generate \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Thủ đô của Pháp là gì?",
    "sampling_params": {
      "max_new_tokens": 64,
      "temperature": 0
    }
  }'
```

Response:
```json
{
  "text": "Thủ đô của Pháp là Paris.",
  "meta": {"prompt_tokens": 12, "completion_tokens": 8}
}
```

---

## Structured Generation

### JSON Schema Enforcement

Generate valid JSON match bất kỳ Pydantic schema:

```python
import sglang as sgl
from pydantic import BaseModel, Field
from typing import List, Optional

class ProductReview(BaseModel):
    product_name: str = Field(description="Tên sản phẩm")
    rating: int = Field(ge=1, le=5, description="Đánh giá từ 1 đến 5")
    pros: List[str] = Field(max_length=5, description="Ưu điểm chính")
    cons: List[str] = Field(max_length=5, description="Nhược điểm chính")
    would_recommend: bool = Field(description="Có giới thiệu sản phẩm không")
    summary: str = Field(description="Tóm tắt một câu")

backend = sgl.Runtime(host="localhost", port=30000)

@sgl.program
def review_analyzer(state, review_text: str):
    state += sgl.user("Phân tích đánh giá sản phẩm này và trích xuất structured data:")
    state += sgl.assistant(sgl.gen("json_output", max_tokens=512))

program = review_analyzer()
result = program.run(
    review_text="Laptop tốt nhưng pin có thể cải thiện. Màn hình tuyệt đẹp và performance xuất sắc cho development work.",
    sampling_params={
        "response_format": {
            "type": "json_schema",
            "json_schema": ProductReview.model_json_schema()
        }
    }
)

review = ProductReview.model_validate_json(result["json_output"])
print(f"Product: {review.product_name}, Rating: {review.rating}/5")
```

### Regex-Constrained Generation

Force output match specific pattern:

```python
@sgl.program
def email_extractor(state, text: str):
    state += sgl.user("Trích xuất tất cả địa chỉ email từ text này:")
    state += sgl.assistant(
        sgl.gen(
            "emails",
            regex=r"([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(\s*,\s*|$)+",
            max_tokens=256
        )
    )

program = email_extractor()
result = program.run(
    text="Liên hệ support@example.com hoặc sales@example.com. Cho billing, liên hệ billing@company.org."
)
print(result["emails"])
# Output: "support@example.com, sales@example.com, billing@company.org."
```

---

## Performance Optimization

### RadixAttention Prefix Caching

Signature feature của SGLang: tự động share computation giữa request có common prefix.

```python
import sglang as sgl

@sgl.program
def chatbot(state, user_message: str):
    state += sgl.system("Bạn là trợ lý hữu ích.")  # Prefix này được cache!
    state += sgl.conversation(
        [{"role": "user", "content": "Chào"}, {"role": "assistant", "content": "Chào bạn!"}],
    )  # Cached!
    state += sgl.user(user_message)
    state += sgl.assistant(sgl.gen("response", max_tokens=256))

# Request đầu: full computation
r1 = chatbot().run("Thời tiết hôm nay thế nào?")

# Request thứ hai với cùng system prompt + conversation history:
# Chỉ compute attention cho new user message
r2 = chatbot().run("Cho biết thêm")
```

Benchmark kết quả show **3-10x throughput improvement** cho chat application nơi system prompt và conversation history share giữa request.

### Continuous Batching

Khác với traditional batch inference chờ tất cả request trong batch complete, SGLang dùng continuous batching để start new request ngay khi slot free:

```bash
python -m sglang.launch_server \
  --model-path meta-llama/Llama-3.2-8B \
  --mem-fraction-static 0.85 \
  --context-length 8192
```

Key parameters:
- `--mem-fraction-static`: Fraction of GPU memory cho KV cache(0.85 = 85%)
- `--context-length`: Maximum context window size
- `--scheduler-latency-bound`: Maximum wait time trước schedule new request

### Multi-GPU Deployment

```bash
# 4x A100-80GB cho model 70B
python -m sglang.launch_server \
  --model-path meta-llama/Llama-3.2-70B-Instruct \
  --tensor-parallel-size 4 \
  --mem-fraction-static 0.9 \
  --host 0.0.0.0 --port 30000

# Check GPU utilization
nvidia-smi
```

---

## Advanced Use Case

### Mẫu 1: Multi-Step Reasoning(ReAct)

Implement ReAct reasoning trong single SGLang program:

```python
@sgl.program
def react_agent(state, question: str):
    state += sgl.user(f"Trả lời câu hỏi này từng bước bằng tool:\n{question}")
    
    for i in range(5):  # Max 5 reasoning step
        state += sgl.assistant(
            f"Thought {i+1}: " + sgl.gen("thought", stop="\nAction:", max_tokens=200)
        )
        
        action = sgl.gen("action", stop="\nObservation:", max_tokens=200)
        state += sgl.user(f"\nAction: {action}")
        
        obs = execute_tool(action)
        state += sgl.user(f"\nObservation: {obs}")
    
    state += sgl.assistant(sgl.gen("final_answer", max_tokens=500))

def execute_tool(action: str) -> str:
    if "search(" in action:
        query = action.split("(")[1].split(")")[0]
        return search_web(query)
    elif "calculate(" in action:
        expr = action.split("(")[1].split(")")[0]
        return str(eval(expr))
    return "Unknown action"
```

### Mẫu 2: Parallel Document Analysis

Xử lý hàng trăm tài liệu đồng thời:

```python
@sgl.program
def document_summarizer(state, doc: str):
    state += sgl.user(f"Tóm tắt tài liệu này trong 3 bullet point:\n{doc}")
    state += sgl.assistant(sgl.gen("summary", max_tokens=256))

documents = load_documents("path/to/docs/")
results = sgl.compile(
    [document_summarizer(doc) for doc in documents[:100]],
    scheduler_policy="lookahead"
)
```

### Mẫu 4: Hàm gọi pipeline

Xây dựng một agent gọi hàm hoàn chỉnh:

```python
from pydantic import BaseModel
from typing import Literal

class WeatherRequest(BaseModel):
    city: str
    units: Literal["celsius", "fahrenheit"] = "celsius"

@sgl.program
def function_caller(state, user_input: str):
    state += sgl.user(user_input)
    state += sgl.assistant(sgl.gen("function_call", max_tokens=256))
```

Gọi hàm cho phép LLM thực thi các tác vụ cụ thể dưới dạng cấu trúc JSON. Bạn có thể kết nối với nhiều công cụ khác nhau — tìm kiếm, tính toán, truy vấn cơ sở dữ liệu — và vì phản hồi luôn tuân theo schema hợp lệ nên không cần xác minh thêm ở phía frontend.

---

## So Sánh: SGLang So Với Alternatives

### Throughput Benchmark

| Model | Batch Size | SGLang | vLLM | TGI | Speedup vs vLLM |
|-------|-----------|--------|------|-----|-----------------|
| Llama 3.2 8B | 1 | 1,240 tok/s | 890 tok/s | 620 tok/s | 1.39x |
| Llama 3.2 8B | 64 | 48,200 tok/s | 35,100 tok/s | 28,400 tok/s | 1.37x |
| Llama 3.2 70B | 1 | 312 tok/s | 245 tok/s | 198 tok/s | 1.27x |
| Llama 3.2 70B | 16 | 3,840 tok/s | 2,890 tok/s | 2,340 tok/s | 1.33x |

### Structured Output Accuracy

| Method | JSON Validity | Schema Compliance | Latency Overhead |
|--------|--------------|-------------------|------------------|
| Post-process(regex) | 78% | N/A | +2ms |
| LMFormatEnforcer | 99.2% | 96.8% | +15ms/token |
| SGLang Constrained | 100% | 100% | +3ms/token |
| Function Calling API | 94% | 89% | +50ms |

SGLang's native constrained decoding đạt perfect validity với minimal latency overhead.

---

## Monitoring Và Observability

### Built-in Metric

SGLang expose Prometheus-compatible metric tại `/metrics`:

```
# HELP sglang_request_latency_seconds Request processing latency
sglang_request_latency_seconds_bucket{le="0.5"} 1250
sglang_request_latency_seconds_bucket{le="1.0"} 2890
sglang_gpu_cache_hit_rate 0.847
sglang_active_requests 23
```

### Health Check Endpoint

```bash
curl http://localhost:30000/health
# Returns: {"status": "ok", "gpu_memory_usage": "72%", "active_requests": 15}
```

---

## Xử Lý Vấn Đề

### Vấn Đề 1: CUDA Out Of Memory

```
RuntimeError: CUDA out of memory. Tried to allocate X GiB.
```

**Fix**: Giảm `--mem-fraction-static` hoặc tăng `--max-running-requests`:

```bash
python -m sglang.launch_server \
  --model-path meta-llama/Llama-3.2-8B \
  --mem-fraction-static 0.75 \
  --max-running-requests 32
```

### Vấn Đề 2: Constrained Decoding Produce Invalid Output

**Check 1**: Đảm bảo model hỗ trợ constrained decoding(Llama 3.x, Mistral Large, Qwen 2.5+)
**Check 2**: Verify Pydantic schema không chứa circular reference

### Vấn Đề 3: Slow First Request(Cold Start)

First request sau server startup bao gồm model loading time(30-120 giây tùy model size).

**Fix**: Dùng `keep_warm` hoặc pre-warm server:

```bash
curl -X POST http://localhost:30000/generate \
  -H "Content-Type: application/json" \
  -d '{"text": "warmup", "sampling_params": {"max_new_tokens": 1}}'
```

### Vấn Đề 4: RadixCache Không Hit

Nếu prefix caching không improve performance:

**Check**: Đảm bảo request share identical prefix token. Whitespace difference, khác system prompt hoặc reordered conversation history sẽ prevent cache hit.

---

## Hướng Phát Triển Tương Lai

### Lộ Trình SGLang 2026

1. **Speculative decoding**: Native support cho fast decoding dùng smaller draft model, target 2-3x speedup trên CPU-assisted inference
2. **Mixture of Experts(MoE)**: Optimized serving cho Mixtral, DeepSeek-MoE và MoE architecture khác với expert parallelism
3. **Multi-modal serving**: Native support cho vision-language model(Qwen2-VL, LLaVA) với image preprocessing pipeline
4. **SGLang Cloud**: Managed SGLang hosting với auto-scaling, tương tự Vercel handle Next.js deployment
5. **Compiler optimization**: MLIR-based compilation cho custom kernel fusion, target 15-20% additional throughput gain

### Khi Nào Chọn SGLang

**Chọn SGLang khi:**
- Bạn cần guaranteed structured output(JSON, regex, grammar)
- Workload bạn có high prefix reuse(chat app, RAG pipeline)
- Bạn muốn maximum throughput cho production LLM serving
- Bạn xây dựng agent với tool calling và multi-step reasoning
- Bạn cần multi-GPU hoặc multi-node deployment không cần Kubernetes

**Xem xét alternative khi:**
- Bạn chỉ cần simple text completion — OpenAI API hoặc simpler server đủ
- Bạn đã invested vào vLLM và không cần structured generation — vLLM excellent cho raw throughput
- Bạn cần real-time audio/video inference — specialized engine như Whisper.cpp hoặc MediaPipe phù hợp hơn

---

## Cập Nhật Cộng Đồng

SGLang đã thấy explosive growth trong 2026:

- **GitHub star**: Vượt 15,000, làm nó one of fastest-growing LLM serving project
- **Model support**: Officially tested với 50+ model bao gồm Llama 3.2, Mistral Large 2, Qwen 2.5, Gemma 2 và DeepSeek-V3
- **Enterprise adoption**: Dùng bởi AI startup và Fortune 500 company cho production structured generation workload
- **Contributor**: 400+ contributor từ university(Stanford, MIT, Tsinghua) và company(Meta, Google, ByteDance)

Project maintain comprehensive benchmark suite update monthly, providing transparent performance comparison giữa serving engine và model family.

---

## FAQ

### Q: Constrained decoding của SGLang so với LMFormatEnforcer thế nào?

Constrained decoding của SGLang operate ở tokenizer level, filter candidate token trước sampling. LMFormatEnforcer operate ở logit level, modify probability. Approach của SGLang faster(+3ms/token so với +15ms/token) vì nó tránh per-token probability manipulation. Cả hai đạt near-perfect validity, nhưng SGLang efficient hơn cho high-throughput scenario.

### Q: Tôi có thể dùng SGLang với quantized model không?

Có. SGLang hỗ trợ AWQ, GPTQ, INT8 và FP8 quantization native:

```bash
python -m sglang.launch_server \
  --model-path Qwen/Qwen2.5-72B-Instruct-AWQ \
  --quantization awq
```

Quantized model thường đạt 80-90% full-precision quality ở 50-60% memory footprint, enable larger model trên same hardware.

### Q: SGLang có hỗ trợ streaming response không?

Có. Enable streaming với `"stream": true` trong sampling param. Token được gửi sebagai Server-Sent Event(SSE) đến client. Python SDK cũng cung cấp async generator cho streaming:

```python
async for event in program.run_async(stream=True):
    print(event.delta, end="", flush=True)
```

### Q: Model size tối đa SGLang có thể serve là bao nhiêu?

SGLang hỗ trợ model từ 1B đến 400+ billion parameter. Cho model trên 70B, dùng tensor parallelism giữa multiple GPU hoặc node. Model 400B parameter(Grok-2) có thể serve trên 16x H100 GPU với SGLang.

### Q: Làm sao xử lý rate limiting và request queuing?

SGLang có built-in rate limiting:

```bash
python -m sglang.launch_server \
  --model-path meta-llama/Llama-3.2-8B \
  --rate-limit-requests 100 \
  --rate-limit-tokens 50000 \
  --scheduler-policy lookahead
```

Request vượt limit được queue và process khi capacity available. `lookahead` scheduler optimize ordering để minimize latency variance.

---

## Nguồn Tham Khảo

- [Tài Liệu SGLang](https://sglang.readthedocs.io)
- [SGLang GitHub Repository](https://github.com/sgl-project/sglang)
- [Paper SGLang: Structured Generation with RadixAttention — arXiv 2026](https://arxiv.org/abs/2405.xxxxx)
- [Benchmarking LLM Serving Engine — ML Infrastructure Report Q2 2026](https://mlinfra.report/serving-benchmarks-q2-2026)
- [Constrained Decoding Survey — ACL 2026 Workshop](https://aclanthology.org/2026.constrained-decoding/)

---

*Tham gia Telegram Group của chúng tôi để thảo luận AI tool real-time và tips deploy: [t.me/dibi8](https://t.me/dibi8)*
