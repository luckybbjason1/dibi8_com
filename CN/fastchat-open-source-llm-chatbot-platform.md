---
title: FastChat — Build Your Own Open-Source ChatGPT Clone with LLM Chatbots
description: Complete guide to LMSYS FastChat, the open-source platform for training, serving, and evaluating large language model chatbots. Build production AI assistants with Vicuna, Alpaca, and more.
category: llm-frameworks
tags: ['fastchat', 'llm-chatbot', 'openai-alternative', 'vicuna', 'alpaca', 'llm-evaluation']
slug: fastchat-open-source-llm-chatbot-platform
date: 2026-07-17 00:00:00+00:00
featureImage: /images/articles/fastchat-llm-chatbot-platform.jpg
---

## TL;DR

LMSYS FastChat is the most comprehensive open-source platform for building, serving, and evaluating LLM-powered chatbots in 2026. From fine-tuning models like Vicuna and Alpaca to deploying production-grade conversational AI, this guide covers every aspect of the FastChat ecosystem.

## What Is FastChat?

FastChat is an open platform developed by the Large Model System Organization (LMSYS) for training, serving, and evaluating large language model chatbots. It provides tools for creating instruction-tuned models, running benchmarks, and deploying chat interfaces — all while maintaining full transparency and reproducibility.

### Key Features

- **Model Training**: Train instruction-tuned models from base checkpoints using RLHF or direct preference optimization
- **Multiple Model Support**: Out-of-the-box support for Vicuna, Alpaca, LLaMA, and custom architectures
- **OpenAI-Compatible API**: Drop-in replacement for OpenAI's API with your own models
- **Web Chat Interface**: Beautiful, responsive UI for testing and deploying chatbots
- **Evaluation Benchmarks**: Built-in evaluation on MT-Bench, AlpacaEval, and other standard benchmarks
- **Multi-GPU Serving**: Efficient deployment across multiple GPUs with tensor parallelism
- **Community Driven**: Backed by LMSYS Org's research community with thousands of contributors

### Architecture Overview

FastChat follows a modular architecture:

1. **FastChat Models**: Core model implementations supporting various architectures
2. **FastChat Serve**: High-performance serving engine with OpenAI API compatibility
3. **FastChat Train**: Training pipeline for instruction tuning and RLHF
4. **FastChat Eval**: Evaluation framework for benchmarking model performance
5. **FastChat Data**: Curated datasets for training and evaluation

#### The Model Worker Architecture

FastChat uses a distributed worker architecture where each model runs as an independent worker process:

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────┐
│  Controller  │────▶│  Model Worker│────▶│  Web UI / API   │
│  (port 21001)│     │  (port 21002)│     │  (port 7860)    │
└─────────────┘     └──────────────┘     └─────────────────┘
       │                    │
       │              ┌──────────────┐
       │              │  Model Worker│
       │              │  (port 21003)│
       │              └──────────────┘
       │
┌─────────────┐
│  Model Worker│
│  (port 21004)│
└─────────────┘
```

The controller manages load balancing, health checks, and routing between workers. Multiple workers can serve different models or handle requests for the same model in parallel.

## Installation Guide

### Quick Start with Docker

```bash
docker pull lmsysorg/fastchat:latest
docker run -p 8000:8000 lmsysorg/fastchat:latest
```

### Manual Installation

```bash
git clone https://github.com/lm-sys/FastChat.git
cd FastChat
pip install -e ".[model_worker,webui]"
```

Install specific model dependencies:

```bash
# For LLaMA-based models
pip install transformers accelerate

# For vLLM acceleration
pip install vllm

# For TensorRT-LLM
pip install tensorrt_llm
```

### Verify Installation

```python
import fastchat
print(fastchat.__version__)

# Test model loading
from fastchat.model import load_model
model, tokenizer = load_model(
    "lmsys/vicuna-7b-v1.5",
    device="cuda"
)
print("Model loaded successfully!")
```

## Available Models

| Model | Parameters | Base Model | Best For |
|-------|-----------|------------|----------|
| Vicuna-7B-v1.5 | 7B | LLaMA 2 | General conversation |
| Vicuna-13B-v1.5 | 13B | LLaMA 2 | Complex reasoning |
| Vicuna-33B-v1.5 | 33B | LLaMA 2 | Maximum capability |
| Alpaca-7B | 7B | LLaMA | Instruction following |
| Koala-13B | 13B | LLaMA | Academic tasks |
| ChatGLM2-6B | 6B | GLM | Chinese language |
| Baichuan2-7B | 7B | Baichuan | Chinese business |

### Loading Pre-trained Models

```python
from fastchat.model import load_model, get_conversation_template

model, tokenizer = load_model(
    "lmsys/vicuna-7b-v1.5",
    device="cuda",
    num_gpus=1,
    max_gpu_memory="22GiB"
)

# Create conversation template
conv = get_conversation_template("vicuna")
conv.append_message(conv.roles[0], "Hello, who are you?")
conv.append_message(conv.roles[1], None)

# Generate response
state = model.chat(
    conv,
    temperature=0.7,
    max_new_tokens=512
)

print(state.messages[-1][2])
```

## Building Your Own Chatbot

### Step 1: Prepare Training Data

Create instruction-response pairs:

```json
[
    {
        "instruction": "Explain quantum computing in simple terms.",
        "input": "",
        "output": "Quantum computing uses quantum bits (qubits) that can exist in multiple states simultaneously..."
    },
    {
        "instruction": "Write a Python function to calculate Fibonacci numbers.",
        "input": "",
        "output": "def fibonacci(n):\n    if n <= 1:\n        return n\n    return fibonacci(n-1) + fibonacci(n-2)"
    }
]
```

### Step 2: Fine-Tune with FastChat Train

```bash
python -m fastchat.train.train \
    --model_name_or_path lmsys/vicuna-7b-v1.5 \
    --data_path ./training_data.json \
    --output_dir ./my-finetuned-model \
    --num_train_epochs 3 \
    --per_device_train_batch_size 4 \
    --gradient_accumulation_steps 8 \
    --learning_rate 2e-5 \
    --fp16 True \
    --save_steps 100 \
    --logging_steps 10 \
    --lr_scheduler_type cosine \
    --warmup_ratio 0.03 \
    --weight_decay 0.0 \
    --max_seq_length 2048
```

### Step 3: Evaluate Your Model

```bash
python -m fastchat.eval.evaluate_benchmark \
    --model-path ./my-finetuned-model \
    --benchmark mt_bench \
    --num-questions 800
```

## Deploying to Production

### OpenAI-Compatible API Server

```python
from fastapi import FastAPI
from pydantic import BaseModel
from fastchat.serve.api_provider import OpenAIAPIClient

app = FastAPI()

class ChatRequest(BaseModel):
    model: str
    messages: list
    temperature: float = 0.7
    max_tokens: int = 2048

@app.post("/v1/chat/completions")
async def create_chat_completion(request: ChatRequest):
    client = OpenAIAPIClient(
        model_name=request.model,
        temperature=request.temperature
    )
    
    response = await client.chat_completion(
        messages=request.messages,
        max_tokens=request.max_tokens
    )
    
    return response
```

Start the server:

```bash
python -m fastchat.serve.openai_api_server \
    --model-path lmsys/vicuna-7b-v1.5 \
    --host 0.0.0.0 \
    --port 8000
```

Test with curl:

```bash
curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "vicuna-7b",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### Multi-GPU Deployment

For models larger than a single GPU can hold:

```bash
python -m fastchat.serve.multi_model_worker \
    --model-path lmsys/vicuna-33b-v1.5 \
    --num-gpus 4 \
    --worker-address http://worker1:21001
```

Configure model parallelism:

```python
from fastchat.serve.model_worker import ModelWorker

worker = ModelWorker(
    controller_address="http://controller:21001",
    worker_address="http://worker1:21002",
    model_names=["vicuna-33b"],
    model_path="lmsys/vicuna-33b-v1.5",
    num_gpus=4
)
```

### Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fastchat-service
spec:
  replicas: 2
  selector:
    matchLabels:
      app: fastchat
  template:
    spec:
      containers:
      - name: fastchat
        image: lmsysorg/fastchat:v1.0
        command: ["python", "-m", "fastchat.serve.openai_api_server"]
        args:
          - "--model-path"
          - "lmsys/vicuna-13b-v1.5"
          - "--host"
          - "0.0.0.0"
          - "--port"
          - "8000"
        resources:
          limits:
            nvidia.com/gpu: 1
        ports:
        - containerPort: 8000
```

### Load Balancing with Multiple Workers

Deploy multiple worker instances behind a load balancer:

```bash
# Worker 1
python -m fastchat.serve.model_worker \
    --controller-address http://controller:21001 \
    --worker-address http://worker1:21002 \
    --model-path lmsys/vicuna-7b-v1.5 \
    --limit-worker-concurrency 16

# Worker 2
python -m fastchat.serve.model_worker \
    --controller-address http://controller:21001 \
    --worker-address http://worker2:21003 \
    --model-path lmsys/vicuna-7b-v1.5 \
    --limit-worker-concurrency 16
```

## Web Chat Interface

### Launch the Demo UI

```bash
python -m fastchat.serve.webui --host 0.0.0.0 --port 7860
```

Access at `http://localhost:7860` to interact with your deployed model through a beautiful web interface.

### Customizing the UI

Modify `fastchat/serve/gradio_web_server.py` to customize:

- Brand colors and logos
- Available models list
- Temperature and parameter controls
- Conversation history management
- Export functionality

### Embedding in External Applications

Embed the chat interface in your existing application:

```html
<iframe 
    src="http://your-fastchat-server:7860/embed" 
    width="100%" 
    height="600px"
    frameborder="0">
</iframe>
```

## Advanced Topics

### Reinforcement Learning from Human Feedback (RLHF)

Train models using human preferences:

```bash
python -m fastchat.train.rlhf.train \
    --model_name_or_path lmsys/vicuna-7b-v1.5 \
    --ref_model_path lmsys/vicuna-7b-v1.5 \
    --data_path ./human_feedback_data.json \
    --output_dir ./rlhf-finetuned-model \
    --num_train_epochs 1 \
    --learning_rate 1e-5
```

### Direct Preference Optimization (DPO)

Alternative to RLHF that directly optimizes policy from preference data:

```bash
python -m fastchat.train.dpo.train \
    --model_name_or_path lmsys/vicuna-7b-v1.5 \
    --data_path ./preference_data.json \
    --output_dir ./dpo-finetuned-model \
    --num_train_epochs 3 \
    --learning_rate 1e-5 \
    --per_device_train_batch_size 2 \
    --gradient_accumulation_steps 8
```

### Model Quantization for Edge Deployment

Reduce model size for mobile or edge devices:

```bash
# Quantize to 4-bit
python -m fastchat.model.quantize quantize \
    --model-path lmsys/vicuna-7b-v1.5 \
    --output-path ./vicuna-7b-q4 \
    --bits 4

# Load quantized model
from fastchat.model import load_model
model, tokenizer = load_model("./vicuna-7b-q4", device="cpu")
```

### Evaluating with MT-Bench

Run the official MT-Bench evaluation:

```bash
python -m fastchat.eval.evaluate_mtbench \
    --model-path ./my-finetuned-model \
    --judge-model lmsys/vicuna-13b-v1.5 \
    --output-file ./mtbench_results.json
```

### Streaming Responses

Enable streaming for real-time token generation:

```python
from fastchat.serve.stream_manager import StreamManager

stream_manager = StreamManager(
    model=model,
    tokenizer=tokenizer,
    max_new_tokens=512,
    temperature=0.7
)

for token in stream_manager.stream(conv):
    print(token, end="", flush=True)
```

## Performance Comparison

| Configuration | Tokens/sec | VRAM | Latency (p99) |
|--------------|-----------|------|---------------|
| Vicuna-7B + CPU | 15 tok/s | N/A | 2.5s |
| Vicuna-7B + RTX 3090 | 45 tok/s | 12 GB | 0.8s |
| Vicuna-13B + 2x A100 | 30 tok/s | 48 GB | 1.2s |
| Vicuna-33B + 4x A100 | 18 tok/s | 96 GB | 2.0s |
| Vicuna-7B + vLLM | 80 tok/s | 8 GB | 0.4s |

## Integration Examples

### ChatGPT Plugin Integration

```python
# Use FastChat as a backend for ChatGPT plugins
from fastchat.serve.api_provider import OpenAIAPIClient

client = OpenAIAPIClient(model_name="custom-vicuna")

response = client.chat_completion(
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "What is machine learning?"}
    ]
)
```

### LangChain Integration

```python
from langchain.llms import HuggingFacePipeline
from transformers import AutoTokenizer, AutoModelForCausalLM

# Load model
tokenizer = AutoTokenizer.from_pretrained("lmsys/vicuna-7b-v1.5")
model = AutoModelForCausalLM.from_pretrained(
    "lmsys/vicuna-7b-v1.5",
    torch_dtype=torch.float16,
    device_map="auto"
)

# Create pipeline
pipeline = HuggingFacePipeline(
    model=model,
    tokenizer=tokenizer,
    max_new_tokens=512,
    temperature=0.7
)

# Use with LangChain
from langchain.chains import ConversationChain
conversation = ConversationChain(llm=pipeline)
response = conversation.predict(input="Tell me about AI.")
```

### RAG (Retrieval-Augmented Generation) Pipeline

Combine FastChat with vector databases for knowledge-grounded responses:

```python
from langchain.vectorstores import FAISS
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.chains import RetrievalQA

# Load vector store
embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")
vectorstore = FAISS.load_local("./knowledge_base", embeddings)

# Create retriever
retriever = vectorstore.as_retriever(search_kwargs={"k": 5})

# Build RAG chain
qa_chain = RetrievalQA.from_chain_type(
    llm=pipeline,
    chain_type="stuff",
    retriever=retriever
)

# Query with context
result = qa_chain.run("What are the key features of this product?")
```

## Production Checklist

- [ ] Set up monitoring with Ray Dashboard
- [ ] Configure autoscaling for variable workloads
- [ ] Implement retry logic for transient failures
- [ ] Use streaming responses for better UX
- [ ] Monitor GPU utilization and memory usage
- [ ] Set up alerts for cluster health
- [ ] Document resource requirements for each deployment
- [ ] Implement rate limiting for API endpoints
- [ ] Add input sanitization to prevent prompt injection
- [ ] Set up logging for audit trails

### Streamlit Web Application

Build a custom chat interface with Streamlit:

```python
import streamlit as st
from fastchat.serve.api_provider import OpenAIAPIClient

st.title("My AI Assistant")

if "messages" not in st.session_state:
    st.session_state.messages = []

for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

if prompt := st.chat_input("Ask me anything..."):
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)
    
    client = OpenAIAPIClient(model_name="vicuna-7b")
    response = client.chat_completion(messages=st.session_state.messages)
    
    st.session_state.messages.append({
        "role": "assistant",
        "content": response["choices"][0]["message"]["content"]
    })
    with st.chat_message("assistant"):
        st.markdown(response["choices"][0]["message"]["content"])
```

### WebSocket Real-Time Chat

For real-time streaming responses via WebSocket:

```python
from fastapi import FastAPI, WebSocket
import json

app = FastAPI()

@app.websocket("/ws/chat")
async def chat_websocket(websocket: WebSocket):
    await websocket.accept()
    
    model, tokenizer = load_model("lmsys/vicuna-7b-v1.5")
    
    while True:
        data = await websocket.receive_text()
        message = json.loads(data)
        
        # Stream tokens one by one
        response = ""
        for token in model.stream_chat(message["prompt"]):
            response += token
            await websocket.send_text(json.dumps({"token": token}))
        
        await websocket.send_text(json.dumps({"done": True, "response": response}))
```

## Security Considerations

### Prompt Injection Prevention

Protect your model against malicious inputs:

```python
def sanitize_prompt(prompt: str) -> str:
    # Remove system-level instructions
    prompt = re.sub(r'^(system|ignore previous).*$', '', prompt, flags=re.IGNORECASE)
    
    # Limit prompt length
    if len(prompt) > 2000:
        prompt = prompt[:2000]
    
    return prompt.strip()

# Usage
safe_prompt = sanitize_prompt(user_input)
response = model.chat(safe_prompt)
```

### Rate Limiting and Abuse Prevention

Implement rate limiting for public-facing APIs:

```python
from slowapi import Limiter
from slowapi.util import get_remote_address

limiter = Limiter(key_func=get_remote_address)

@limiter.limit("10/minute")
@app.post("/chat")
async def chat(request: Request, data: ChatRequest):
    return process_chat(data)
```

### Content Moderation

Add a moderation layer before responses reach users:

```python
from transformers import pipeline

moderator = pipeline(
    "text-classification",
    model="facebook/roberta-hate-speech-dynabench-r4-target"
)

def moderate_response(text: str) -> bool:
    result = moderator(text)[0]
    return result["label"] == "hate"

# Check both input and output
if moderate_response(user_input):
    return {"error": "Input contains inappropriate content"}

response = model.generate(user_input)
if moderate_response(response):
    return {"error": "Response filtered for safety"}
```

## Model Comparison Matrix

| Model | Params | Training Data | MT-Bench Score | Best For |
|-------|--------|---------------|----------------|----------|
| Vicuna-7B-v1.5 | 7B | 650K conversations | 6.45 | General chat |
| Vicuna-13B-v1.5 | 13B | 650K conversations | 6.72 | Complex tasks |
| Vicuna-33B-v1.5 | 33B | 650K conversations | 7.12 | Maximum quality |
| Alpaca-7B | 7B | 52K instructions | 5.80 | Instruction following |
| Koala-13B | 13B | 118K conversations | 6.50 | Academic tasks |
| ChatGLM2-6B | 6B | Chinese data | N/A | Chinese language |
| Baichuan2-7B | 7B | Chinese data | N/A | Chinese business |

## Deployment Architectures

### Single-GPU Deployment

Ideal for development and light production use:

```
+----------------------------------+
|     FastChat Server              |
|  +---------------------------+   |
|  |   Model Worker             |   |
|  |   (7B model)               |   |
|  |   RTX 3090 24GB            |   |
|  +---------------------------+   |
|     OpenAI API Compatible        |
+----------------------------------+
```

### Multi-GPU Tensor Parallel

For models exceeding single GPU memory:

```
+--------------------------------------------+
|          Controller                         |
|         (port 21001)                        |
+----------------------+----------------------+
|   Worker 1           |      Worker 2        |
|   A100 40GB          |      A100 40GB       |
|   Part of            |      Part of         |
|   model              |      model           |
+----------------------+----------------------+
```

### Multi-Node Cluster

Enterprise-scale deployment across multiple machines:

```
+------------------------------------------------------+
|                    Load Balancer                      |
+-------------------+-------------------+----------------+
|  Node 1           |  Node 2           |  Node 3        |
|  4xA100 80GB      |  4xA100 80GB      |  4xA100 80GB   |
|  Vicuna-33B       |  Vicuna-33B       |  Vicuna-7B     |
+-------------------+-------------------+----------------+
```

## FAQ

### Q1: How does FastChat compare to Ollama?

FastChat provides more flexibility for custom model training and evaluation, while Ollama focuses on simplicity. FastChat supports more model architectures and offers better control over serving configurations.

### Q2: Can I use FastChat with non-Llama models?

Yes, FastChat supports LLaMA, Mistral, Falcon, BLOOM, GPT-J, and many other architectures. The model registry includes dozens of pre-configured templates.

### Q3: What hardware do I need for production deployment?

Minimum: 1x GPU with 12GB VRAM for 7B models. Recommended: 2x A100 40GB for 13B+ models. For high-throughput serving, consider vLLM or TensorRT-LLM acceleration.

### Q4: How do I handle concurrent users?

Use FastChat's built-in load balancing with multiple model workers. Each worker handles a portion of requests, and the controller distributes traffic automatically.

### Q5: Is FastChat suitable for commercial use?

Yes, FastChat is MIT licensed. However, check the licenses of individual models you train or serve, as some base models may have additional restrictions.

### Q6: How do I prevent prompt injection attacks?

Implement input filtering, use system prompts to define behavior boundaries, and consider adding a separate moderation model to scan user inputs before passing them to the main model.

### Q7: Can I add custom tools or function calling to FastChat?

Yes, FastChat supports function calling through custom conversation templates. You can define tool schemas and let the model decide which tools to call based on user intent.


## FAQ

### Q1: How does FastChat compare to Ollama?

FastChat provides more flexibility for custom model training and evaluation, while Ollama focuses on simplicity. FastChat supports more model architectures and offers better control over serving configurations.

### Q2: Can I use FastChat with non-Llama models?

Yes, FastChat supports LLaMA, Mistral, Falcon, BLOOM, GPT-J, and many other architectures. The model registry includes dozens of pre-configured templates.

### Q3: What hardware do I need for production deployment?

Minimum: 1x GPU with 12GB VRAM for 7B models. Recommended: 2x A100 40GB for 13B+ models. For high-throughput serving, consider vLLM or TensorRT-LLM acceleration.

### Q4: How do I handle concurrent users?

Use FastChat's built-in load balancing with multiple model workers. Each worker handles a portion of requests, and the controller distributes traffic automatically.

### Q5: Is FastChat suitable for commercial use?

Yes, FastChat is MIT licensed. However, check the licenses of individual models you train or serve, as some base models may have additional restrictions.

### Q6: How do I prevent prompt injection attacks?

Implement input filtering, use system prompts to define behavior boundaries, and consider adding a separate moderation model to scan user inputs before passing them to the main model.

### Q7: Can I add custom tools/function calling to FastChat?

Yes, FastChat supports function calling through custom conversation templates. You can define tool schemas and let the model decide which tools to call based on user intent.

## Sources

- [FastChat GitHub Repository](https://github.com/lm-sys/FastChat)
- [LMSYS Org Research](https://lmsys.org/)
- [Vicuna Model Card](https://lmsys.org/blog/2023-03-30-vicuna/)
- [MT-Bench Evaluation](https://huggingface.co/datasets/lmsys/mt_bench)
- [FastChat Documentation](https://github.com/lm-sys/FastChat/blob/main/docs/)

## Call to Action

Build your own AI assistant with FastChat's open-source platform. [Get started](https://dibi8.com/auth/) with our deployment guides and model training tutorials.
