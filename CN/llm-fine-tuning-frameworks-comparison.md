---
title: 'LLM Fine-Tuning Frameworks Compared: LoRA, QLoRA, PEFT & Unsloth (2025)'
description: 'Compare LLM fine-tuning frameworks: LoRA, QLoRA, PEFT, and Unsloth. Learn parameter-efficient fine-tuning with benchmarks, VRAM requirements, and step-by-step tutorials.'
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

Fine-tuning large language models used to require millions of dollars in GPU clusters and weeks of training time. In 2025, parameter-efficient fine-tuning (PEFT) techniques let you adapt a 70-billion-parameter model on a single consumer GPU in hours, not days.

This guide compares the four dominant fine-tuning approaches: LoRA, QLoRA, Hugging Face PEFT, and Unsloth. We will cover how each method works, their trade-offs in speed and memory, a hands-on tutorial for fine-tuning Llama 3, and best practices for producing high-quality fine-tuned models.

## Why Fine-Tune Large Language Models?

### Full Fine-Tuning vs Parameter-Efficient Fine-Tuning

Full fine-tuning updates every parameter in a pre-trained model. For Llama 3 70B, this means adjusting 70 billion parameters, requiring ~1.4 TB of GPU memory just to store the model, optimizer states, and gradients. This approach is prohibitively expensive for most teams.

Parameter-efficient fine-tuning (PEFT) freezes the base model weights and trains only a small number of additional parameters, typically 0.1% to 1% of the total. Techniques like LoRA inject trainable low-rank matrices into specific layers, achieving comparable performance to full fine-tuning at a fraction of the computational cost.

### When to Fine-Tune vs Use RAG

Fine-tuning and retrieval-augmented generation (RAG) solve different problems. Fine-tuning teaches a model new behaviors, writing styles, task formats, or domain knowledge baked into the model weights. RAG provides access to external, frequently changing knowledge without retraining.

Choose fine-tuning when you need consistent output formatting, specialized domain expertise, or instruction-following behavior. Choose RAG when your knowledge base changes frequently, you need source citations, or you want to reduce hallucinations on factual queries.

Many production systems combine both: fine-tune for behavior and tone, then use RAG for grounding in specific documents.

### GPU Memory Challenges and Solutions

GPU memory is the primary bottleneck in LLM fine-tuning. A 7B parameter model in FP32 requires 28 GB of memory. Add optimizer states (Adam requires 2x model size) and gradients (1x model size), and you need 84 GB for full fine-tuning, exceeding most consumer GPUs.

Solutions include:

- **Quantization**: Store weights in 4-bit or 8-bit precision instead of 32-bit
- **Gradient checkpointing**: Recompute activations during backward pass to save memory
- **Parameter-efficient methods**: Train fewer parameters (LoRA, adapters)
- **Offloading**: Move optimizer states to CPU or disk (DeepSpeed ZeRO-Offload)
- **Paged optimizers**: Use unified memory to spill to CPU RAM when GPU memory is exhausted

## Understanding LoRA (Low-Rank Adaptation)

### How LoRA Works: Low-Rank Decomposition

[LoRA](https://arxiv.org/abs/2106.09685), introduced by Hu et al. at Microsoft in 2021, is the foundational technique underlying modern parameter-efficient fine-tuning. Instead of updating full weight matrices during fine-tuning, LoRA decomposes weight updates into two smaller matrices.

For a pre-trained weight matrix $W \in \mathbb{R}^{d \times k}$, LoRA represents the update as $\Delta W = BA$, where $B \in \mathbb{R}^{d \times r}$ and $A \in \mathbb{R}^{r \times k}$. The rank $r$ is typically 4 to 64, dramatically smaller than the original dimensions. During inference, the adapted weight is $W' = W + BA$.

This decomposition reduces trainable parameters from $d \times k$ to $r \times (d + k)$. For a 4096 x 4096 matrix with rank 16, LoRA trains only 131,072 parameters instead of 16,777,216, a 128x reduction.

### LoRA Hyperparameters: Rank, Alpha, Dropout

Three hyperparameters control LoRA's behavior:

- **Rank (r)**: Controls the expressiveness of the adaptation. Higher rank captures more complex patterns but increases parameters and overfitting risk. Typical values: 8, 16, 32, 64. Start with 16 and adjust based on validation loss.
- **Alpha (lora_alpha)**: Scales the LoRA weights. The effective scaling is `alpha / rank`. Common practice sets `alpha = 2 * rank`. Higher alpha amplifies the fine-tuning signal.
- **Dropout (lora_dropout)**: Regularization applied to LoRA layers. Values between 0.0 and 0.1 typically work best. Use 0.05 for small datasets, 0.0 for large datasets.

### Target Modules and Configuration

LoRA can be applied to specific layers. For transformer models, the most common target modules are the query and value projection matrices:

```python
from peft import LoraConfig

lora_config = LoraConfig(
    r=16,
    lora_alpha=32,
    target_modules=["q_proj", "v_proj"],
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM"
)
```

For better results, some practitioners target all linear layers: `["q_proj", "k_proj", "v_proj", "o_proj", "gate_proj", "up_proj", "down_proj"]`.

### Pros, Cons, and Best Practices

**Pros:**
- Reduces trainable parameters by 100x or more
- Checkpoints are tiny (MBs instead of GBs)
- Can merge adapters back into base model
- No inference latency when merged

**Cons:**
- Slightly lower performance than full fine-tuning on some tasks
- Hyperparameter tuning required for optimal results
- Not ideal for tasks requiring massive knowledge updates

**Best practices:**
- Start with rank 16, alpha 32
- Target q_proj and v_proj for efficiency, all projections for quality
- Use higher rank (64+) for complex tasks
- Merge adapters before production deployment to eliminate inference overhead

## QLoRA: Quantization + LoRA for Consumer GPUs

### 4-Bit Quantization with bitsandbytes

[QLoRA](https://arxiv.org/abs/2303.15693), developed by Tim Dettmers in 2023, combines 4-bit quantization with LoRA to enable fine-tuning of 70B parameter models on 48GB GPUs.

The [bitsandbytes](https://github.com/TimDettmers/bitsandbytes) library implements 4-bit Normal Float (NF4) quantization, which empirically works better than standard 4-bit integers for neural network weights. NF4 adapts the quantization bins to the normal distribution of neural weights, reducing quantization error.

### Double Quantization and NF4

Double quantization applies a second round of quantization to the quantization constants themselves, saving an additional 0.373 bits per parameter on average. For a 65B parameter model, this saves ~3 GB of memory.

NF4 (4-bit Normal Float) is a quantile-based datatype optimized for normally distributed weights. It outperforms INT4 and FP4 quantization by better preserving the weight distribution's information content.

### Paged Optimizers for Memory Efficiency

Paged optimizers use NVIDIA unified memory to automatically page optimizer states between GPU and CPU memory. When GPU memory is exhausted, the least recently used optimizer states spill to CPU RAM. This prevents out-of-memory errors during long training runs or when batch sizes are larger than expected.

### QLoRA vs LoRA: Performance Comparison

| Metric | LoRA (16-bit) | QLoRA (4-bit) |
|--------|--------------|---------------|
| **VRAM (Llama 3 8B)** | 16 GB | 6 GB |
| **VRAM (Llama 3 70B)** | 140 GB | 48 GB |
| **Training Speed** | Baseline | ~70-80% of LoRA |
| **Final Model Quality** | Baseline | ~97-99% of LoRA |
| **Checkpoint Size** | Same (adapters only) | Same (adapters only) |

QLoRA trades a small amount of training speed and model quality for massive memory savings. For most practical applications, the quality difference is negligible.

### When to Use QLoRA Over LoRA

Use QLoRA when GPU memory is constrained: consumer GPUs (RTX 4090, RTX 3090), cloud instances with limited VRAM, or when training larger models than your hardware normally supports. Use standard LoRA when you have sufficient GPU memory and want maximum training speed and model quality.

## PEFT: Hugging Face's Unified Fine-Tuning Library

### Overview of PEFT Library

The [Hugging Face PEFT](https://huggingface.co/docs/peft) library is the most widely adopted framework for parameter-efficient fine-tuning. It provides a unified API for multiple PEFT methods, abstracting away the implementation details of each technique.

PEFT integrates seamlessly with the Hugging Face ecosystem: Transformers for model loading, Datasets for data preparation, Accelerate for distributed training, and TRL for reinforcement learning from human feedback (RLHF).

### Supported Methods

PEFT implements multiple fine-tuning techniques beyond LoRA:

- **LoRA**: Low-rank adaptation (most popular)
- **IA³**: Infused Adapter by Inhibiting and Amplifying Inner Activations, learns scaling vectors instead of low-rank matrices
- **AdaLoRA**: Adaptive LoRA that dynamically allocates rank budget across layers
- **Prefix Tuning**: Prepends trainable tokens to each layer's key and value projections
- **Prompt Tuning**: Trains soft prompt embeddings prepended to the input
- **P-Tuning**: Uses a prompt encoder to generate virtual token embeddings

For most use cases, LoRA remains the recommended starting point due to its maturity and ease of use.

### Integration with Transformers and Accelerate

PEFT's core abstraction is the `get_peft_model()` function, which wraps any Hugging Face model with PEFT adapters:

```python
from transformers import AutoModelForCausalLM
from peft import get_peft_model, LoraConfig

base_model = AutoModelForCausalLM.from_pretrained("meta-llama/Meta-Llama-3-8B")
peft_model = get_peft_model(base_model, lora_config)
```

After wrapping, training proceeds normally with Hugging Face's `Trainer` or any PyTorch training loop. The base model weights remain frozen; only LoRA parameters receive gradients.

### Unified API for All PEFT Methods

PEFT provides a consistent interface across methods. Switching from LoRA to IA³ requires only changing the configuration class:

```python
# LoRA
from peft import LoraConfig
config = LoraConfig(r=16, lora_alpha=32)

# IA3
from peft import IA3Config
config = IA3Config(target_modules=["q_proj", "v_proj"])
```

### Saving and Loading Adapters

PEFT adapters save independently from the base model:

```python
# Save only the adapter weights (~10-100 MB)
peft_model.save_pretrained("./lora_adapter")

# Load adapter on top of base model
from peft import PeftModel
model = PeftModel.from_pretrained(base_model, "./lora_adapter")
```

This separation enables efficient experiment management: one base model with dozens of small adapter checkpoints for different tasks.

## Unsloth: The Fastest Fine-Tuning Framework

### What Makes Unsloth 2-5x Faster

[Unsloth](https://github.com/unslothai/unsloth), released in late 2023, is a high-performance fine-tuning framework that reimplements critical training operations with hand-optimized kernels. Benchmarks show 2-5x speedups over standard PEFT + PyTorch training while using 50-80% less VRAM.

The speedups come from several optimizations:

- **Handwritten Triton kernels**: Custom GPU kernels for RoPE embeddings, RMS normalization, and cross-entropy loss that outperform PyTorch defaults
- **Optimized backpropagation**: Reduced gradient computation through mathematical reformulation
- **Reduced memory overhead**: Elimination of intermediate buffers and in-place operations
- **Flash Attention 2 integration**: Memory-efficient attention computation

### Handwritten GPU Kernels Optimization

Unsloth replaces PyTorch's general-purpose operations with hand-tuned Triton kernels specific to transformer architectures. For example, Unsloth's RoPE (Rotary Position Embedding) kernel fuses multiple operations into a single GPU kernel, reducing memory bandwidth and kernel launch overhead.

These kernels are benchmarked and optimized for modern NVIDIA GPUs (Ampere, Ada Lovelace, Hopper architectures).

### Reduced VRAM Usage

Unsloth's memory optimizations enable training larger models on the same hardware:

| Model | Standard PEFT VRAM | Unsloth VRAM | Savings |
|-------|-------------------|--------------|---------|
| Llama 3 8B QLoRA | 6.2 GB | 4.8 GB | 23% |
| Mistral 7B QLoRA | 5.8 GB | 4.2 GB | 28% |
| Llama 3 70B QLoRA | 47.6 GB | 38.2 GB | 20% |

### Supported Models and Architectures

As of early 2025, Unsloth supports:

- Llama 3 and Llama 2 family (7B, 8B, 13B, 70B)
- Mistral 7B and Mixtral 8x7B/8x22B
- Qwen 2 and Qwen 2.5 series
- Phi-3 and Phi-4 series
- Gemma 2 series
- CodeLlama and CodeQwen

### Unsloth Pro vs Free Version

Unsloth offers both a free open-source version (Apache 2.0 license) and a paid Pro tier. The free version includes all core optimizations and supports most popular models. Unsloth Pro adds support for additional architectures, priority kernel updates for new GPUs, and enterprise support.

## Head-to-Head Comparison

### Training Speed Comparison

Training speed (tokens/second) for Llama 3 8B QLoRA on RTX 4090 (24GB):

| Framework | Speed | Relative |
|-----------|-------|----------|
| Standard PEFT + PyTorch | 1,200 t/s | 1.0x |
| PEFT + Flash Attention 2 | 1,580 t/s | 1.3x |
| Unsloth (Free) | 3,100 t/s | 2.6x |
| Unsloth Pro | 4,200 t/s | 3.5x |

### VRAM Usage Comparison

Peak VRAM during Llama 3 8B QLoRA training (batch size 1, sequence length 2048):

| Framework | VRAM Usage |
|-----------|-----------|
| Standard PEFT | 16.2 GB |
| PEFT + Gradient Checkpointing | 12.4 GB |
| PEFT + QLoRA | 6.2 GB |
| Unsloth + QLoRA | 4.8 GB |

### Final Model Quality Evaluation

Quality measured by validation loss on the Alpaca instruction-tuning dataset (lower is better):

| Framework | Final Val Loss |
|-----------|---------------|
| Full Fine-tuning (BF16) | 1.084 |
| LoRA (rank 16) | 1.092 |
| QLoRA (rank 16) | 1.098 |
| Unsloth QLoRA (rank 16) | 1.095 |

All PEFT methods achieve within 1.3% of full fine-tuning quality, with Unsloth matching standard LoRA despite the quantization.

### Ease of Use and Documentation

| Framework | Documentation | Setup Complexity | Community |
|-----------|--------------|------------------|-----------|
| PEFT (Hugging Face) | Excellent | Low | Massive |
| Unsloth | Good | Low | Growing rapidly |
| QLoRA (bitsandbytes) | Good | Medium | Large |

## Step-by-Step Fine-Tuning Tutorial

### Environment Setup

For this tutorial, we will use Google Colab (free T4 GPU) or a local GPU with 16GB+ VRAM.

Install dependencies:

```bash
pip install transformers datasets peft bitsandbytes accelerate
# For Unsloth:
pip install unsloth
```

### Dataset Preparation and Formatting

We will use the Alpaca instruction-funing format, a JSON structure with `instruction`, `input`, and `output` fields:

```python
from datasets import load_dataset

dataset = load_dataset("yahma/alpaca-cleaned", split="train")

def format_prompt(example):
    if example["input"]:
        prompt = f"### Instruction:\n{example['instruction']}\n\n### Input:\n{example['input']}\n\n### Response:\n{example['output']}"
    else:
        prompt = f"### Instruction:\n{example['instruction']}\n\n### Response:\n{example['output']}"
    return {"text": prompt}

formatted_dataset = dataset.map(format_prompt)
```

### Fine-Tuning Llama 3 with LoRA/QLoRA

Using standard PEFT + QLoRA:

```python
from transformers import AutoModelForCausalLM, AutoTokenizer, TrainingArguments
from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training
from trl import SFTTrainer

# Load model in 4-bit
model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Meta-Llama-3-8B",
    load_in_4bit=True,
    device_map="auto"
)
model = prepare_model_for_kbit_training(model)

# Configure LoRA
lora_config = LoraConfig(r=16, lora_alpha=32, target_modules=["q_proj", "v_proj"])
model = get_peft_model(model, lora_config)

# Train
trainer = SFTTrainer(
    model=model,
    train_dataset=formatted_dataset,
    max_seq_length=2048,
    args=TrainingArguments(num_train_epochs=1, per_device_train_batch_size=1)
)
trainer.train()
```

### Fine-Tuning with Unsloth (Faster Option)

Using Unsloth for 2-3x faster training:

```python
from unsloth import FastLanguageModel
from trl import SFTTrainer

model, tokenizer = FastLanguageModel.from_pretrained(
    model_name="unsloth/Meta-Llama-3.1-8B",
    max_seq_length=2048,
    load_in_4bit=True,
)

model = FastLanguageModel.get_peft_model(
    model, r=16, lora_alpha=16,
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj"]
)

trainer = SFTTrainer(
    model=model,
    train_dataset=formatted_dataset,
    max_seq_length=2048,
    args=TrainingArguments(num_train_epochs=1, per_device_train_batch_size=2)
)
trainer.train()
```

### Evaluating Your Fine-Tuned Model

Evaluate using standard NLP metrics:

```python
from evaluate import load

# Perplexity
perplexity = load("perplexity")
results = perplexity.compute(model_id="your-model", predictions=test_texts)

# MT-Bench or custom evaluation
# Use the lm-evaluation-harness for standardized benchmarks
```

### Merging Adapters and Exporting to GGUF

Merge LoRA adapters back into the base model for inference without PEFT dependencies:

```python
# Merge adapters
merged_model = model.merge_and_unload()
merged_model.save_pretrained("./merged_model")

# Export to GGUF for Ollama
# Use llama.cpp convert script or Unsloth's built-in export
model.save_pretrained_gguf("./gguf_model", tokenizer, quantization_method="q4_k_m")
```

## Fine-Tuning Best Practices

### Choosing the Right Base Model

Select a base model close to your target domain:

- **General instruction**: Llama 3 Instruct, Mistral Instruct, Qwen Chat
- **Code**: CodeLlama, DeepSeek Coder, CodeQwen
- **Multilingual**: Qwen, Aya, BLOOM
- **Small/Fast**: Phi-3, Gemma 2B, Llama 3.2 1B

### Dataset Curation and Cleaning

Quality matters more than quantity. A few thousand high-quality examples typically outperform tens of thousands of noisy ones. Clean your dataset by:

- Removing duplicates and near-duplicates
- Filtering examples with incorrect formatting
- Ensuring consistent output style and length
- Balancing instruction types and topics
- Using human-verified examples for critical domains

### Hyperparameter Tuning Guide

Start with these defaults and adjust based on validation loss:

| Hyperparameter | Default | Range | Effect |
|---------------|---------|-------|--------|
| Rank (r) | 16 | 4-256 | Higher = more expressive, more parameters |
| Alpha | 32 | 8-512 | Higher = stronger fine-tuning signal |
| Learning rate | 2e-4 | 1e-5 to 1e-3 | Higher = faster learning, risk of instability |
| Batch size | 1-4 | 1-16 | Larger = more stable gradients, more VRAM |
| Epochs | 1-3 | 1-10 | More = better fit, risk of overfitting |
| LoRA dropout | 0.05 | 0.0-0.2 | Regularization for small datasets |

### Avoiding Overfitting and Catastrophic Forgetting

- Monitor validation loss and stop training when it increases
- Use LoRA dropout > 0 for datasets under 10,000 examples
- Keep rank reasonably low (8-32) for behavior-focused fine-tuning
- Evaluate on held-out test sets that differ from training data
- Consider using techniques like DoRA (Weight-Decomposed LoRA) for better stability

### Testing and Evaluation Metrics

Evaluate fine-tuned models with:

- **Perplexity**: Measures fluency on held-out text
- **BLEU/ROUGE**: For tasks with reference outputs
- **MT-Bench**: Multi-turn conversation quality
- **Human evaluation**: Gold standard for subjective quality
- **Task-specific metrics**: Accuracy for classification, F1 for extraction

## Deployment of Fine-Tuned Models

### Merging LoRA Weights with Base Model

For production deployment, merge adapter weights into the base model to eliminate PEFT inference overhead:

```python
merged_model = peft_model.merge_and_unload()
merged_model.save_pretrained("./production_model")
```

The merged model is a standard Hugging Face model that works with any inference engine.

### Converting to GGUF for Ollama/llama.cpp

For local deployment with Ollama or llama.cpp:

```bash
# Using Unsloth's export
model.save_pretrained_gguf("model_gguf", tokenizer, quantization_method="q4_k_m")

# Or using llama.cpp directly
python convert_hf_to_gguf.py ./production_model --outfile model.gguf
```

### Deploying with vLLM for Serving

For production API serving, use [vLLM](https://github.com/vllm-project/vllm):

```python
from vllm import LLM

llm = LLM(model="./production_model", tensor_parallel_size=1)
output = llm.generate("Hello, how can I help?")
```

vLLM provides continuous batching, PagedAttention, and OpenAI-compatible API serving.

### Hugging Face Hub Upload and Sharing

Upload your model or adapters to the Hugging Face Hub:

```python
from huggingface_hub import HfApi

api = HfApi()
api.create_repo(repo_id="your-username/your-model", repo_type="model")
api.upload_folder(folder_path="./lora_adapter", repo_id="your-username/your-model")
```

## Alternatives and Complementary Tools

### Axolotl: YAML-Based Fine-Tuning

[Axoloth](https://github.com/OpenAccess-AI-Collective/axolotl) simplifies fine-tuning through YAML configuration files. Define your dataset, model, and training parameters in a single YAML file, then run `axolotl train config.yaml`. It is ideal for users who prefer configuration over code.

### LLaMA-Factory: Comprehensive Training Toolkit

[LLaMA-Factory](https://github.com/hiyouga/LLaMA-Factory) provides a unified web UI and CLI for fine-tuning dozens of models. It supports pre-training, supervised fine-tuning, DPO, PPO, and ORPO through a single interface. The web UI makes hyperparameter tuning accessible to non-experts.

### Torchtune: PyTorch Native Fine-Tuning

[Torchtune](https://github.com/pytorch/torchtune), developed by Meta, is a PyTorch-native library for fine-tuning LLMs. It offers memory-efficient recipes, distributed training support, and integration with the PyTorch ecosystem. Best for teams deeply invested in PyTorch.

### OpenPipe: Fine-Tuning API Service

[OpenPipe](https://openpipe.ai) is a managed fine-tuning service that handles infrastructure, dataset formatting, and deployment. Upload your data, and OpenPipe returns a hosted fine-tuned model accessible via API. Ideal for teams without GPU resources or ML engineering expertise.

## Conclusion

Parameter-efficient fine-tuning has democratized LLM customization. In 2025, you do not need a supercomputer to adapt a 70B parameter model, you need a consumer GPU, the right framework, and a quality dataset.

For most practitioners, we recommend this workflow:

1. **Start with Unsloth** for the fastest training and lowest VRAM usage
2. **Fall back to Hugging Face PEFT** for models Unsloth does not support
3. **Use QLoRA** as the default quantization strategy for memory efficiency
4. **Merge adapters** before production deployment for clean inference
5. **Serve with vLLM** for high-throughput production APIs

The field evolves rapidly. Follow the [Hugging Face PEFT repository](https://huggingface.co/docs/peft), [Unsloth GitHub](https://github.com/unslothai/unsloth), and [bitsandbytes releases](https://github.com/TimDettmers/bitsandbytes) for the latest optimizations and model support.

## Frequently Asked Questions

**LoRA vs QLoRA: Which should I use?**

Use QLoRA as your default choice. It trains on 4-bit quantized models with nearly identical quality to standard LoRA while requiring 60-70% less VRAM. Use standard LoRA only when you have abundant GPU memory (A100 80GB, H100) and want maximum training speed without quantization overhead.

**Is Unsloth really faster than standard PEFT?**

Yes. Unsloth achieves 2-5x speedups over standard PEFT training through hand-optimized GPU kernels, reduced memory overhead, and fused operations. These speedups are consistent across benchmarks with Llama, Mistral, and other popular architectures. The free version delivers most optimizations; the Pro tier adds support for additional models and newer GPU architectures.

**How much VRAM do I need for fine-tuning?**

VRAM requirements depend on model size and quantization:

| Model Size | LoRA (16-bit) | QLoRA (4-bit) | Unsloth QLoRA |
|-----------|---------------|---------------|---------------|
| 7B/8B | 16 GB | 6 GB | 5 GB |
| 13B | 28 GB | 10 GB | 8 GB |
| 70B | 140 GB | 48 GB | 38 GB |

These figures assume batch size 1, gradient accumulation, and sequence length 2048. Larger batches require proportionally more VRAM.

**Can I fine-tune on a free Colab GPU?**

Yes. Google Colab's free T4 GPU (16 GB VRAM) can fine-tune 7B and 8B parameter models using QLoRA. Use Unsloth for maximum efficiency. Limit sequence length to 1024-2048 tokens and use gradient accumulation to simulate larger batch sizes. For 13B models, Colab Pro with a V100 or A100 GPU is recommended.

**What is the difference between PEFT and full fine-tuning?**

PEFT (Parameter-Efficient Fine-Tuning) trains only a small fraction of parameters, typically 0.1% to 1% of total model weights, while freezing the rest. Full fine-tuning updates all parameters. PEFT requires 100x less memory, trains faster, and produces tiny checkpoints, but may achieve slightly lower performance on tasks requiring extensive knowledge updates. For most instruction-following and style adaptation tasks, PEFT matches or approaches full fine-tuning quality.

---

## Recommended Infrastructure

To run any of the tools above reliably 24/7, infrastructure matters:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit, 14+ global regions, one-click droplets for AI/dev workloads.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low latency for mainland China access. This is the same IDC hosting dibi8.com — production-proven.

*Affiliate links — no extra cost to you, helps keep dibi8.com running.*

