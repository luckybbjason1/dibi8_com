---
title: 'DS4 vs Ollama vs llama.cpp: DeepSeek V4 Flash Local Inference Benchmark on
  128GB Mac'
description: Discover DS4 by antirez (Redis creator) — a native inference engine for
  DeepSeek V4 Flash. Learn installation, benchmarks vs Ollama/llama.cpp, code examples,
  and how to run a 1M-context LLM locally on macOS and Linux.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- C++
- Go
- Python
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
- /posts/ds4-deepseek-flash-local-inference/
- /posts/ds4-open-source-deepseek-alternative-2026/
faqs:
  - q: 'What is DS4 (DwarfStar 4) and who created it?'
    a: 'DS4 (DwarfStar 4) is a small, native inference engine purpose-built to run the DeepSeek V4 Flash model locally on Apple Metal and NVIDIA CUDA hardware. It was created by Salvatore Sanfilippo (antirez), the Italian programmer who created Redis.'
  - q: 'How much RAM do you need to run DeepSeek V4 Flash with DS4?'
    a: 'For the 2-bit (q2) weights you need a minimum of 96GB RAM, with 128GB recommended. The 4-bit (q4) weights require 256GB or more, which excludes most consumer laptops.'
  - q: 'How does DS4 compare to Ollama and llama.cpp for DeepSeek V4 Flash?'
    a: 'Because DS4 focuses on a single model, its asymmetric quantization, compressed KV cache, and custom Metal kernels typically deliver 20-40% better prefill throughput than Ollama on equivalent Apple Silicon. Unlike Ollama, it also persists the KV cache to disk, whereas Ollama wipes context on exit. It openly builds on llama.cpp and GGML but skips generic GGUF support to hardcode optimal layouts.'
  - q: 'What is DS4''s disk KV cache and why does it matter?'
    a: 'DS4 treats the KV cache as a first-class disk citizen, writing checkpoints to fast SSDs instead of keeping all state in RAM. This enables 100K-1M token context windows on RAM-limited machines and lets agent workflows resume a long conversation instantly without reprocessing the prompt.'
  - q: 'Does DS4 provide an OpenAI-compatible API server?'
    a: 'Yes. Building DS4 produces a ds4-server binary that exposes an OpenAI- and Anthropic-compatible HTTP API on http://127.0.0.1:8000, with endpoints including /v1/chat/completions, /v1/completions, and /v1/messages. It supports OpenAI-style function calling and works with agent frameworks like OpenCode, Pi, and Claude Code.'
---

{</* resource-info */>}

# DS4 (DwarfStar 4): Running DeepSeek V4 Flash Locally with Metal & CUDA — The Complete Guide

When **Salvatore Sanfilippo** — the legendary creator of **Redis** — turns his attention to local large language model inference, the developer community takes notice. His latest open-source project, **DS4** (DwarfStar 4), has already amassed **8,318 GitHub stars** and is rapidly becoming the go-to inference engine for running **DeepSeek V4 Flash** locally on high-end consumer hardware.

Unlike generic GGUF runners or wrappers around other runtimes, DS4 takes a deliberately narrow approach: it is a **model-specific inference engine** built from the ground up to squeeze every ounce of performance out of DeepSeek V4 Flash on **Apple Metal** and **NVIDIA CUDA**. If you have a MacBook Pro with 128GB of unified memory or a Linux workstation with a powerful GPU, DS4 could be the most exciting local LLM project you've encountered this year.

In this comprehensive guide, we explore what makes DS4 special, how its technical architecture differs from alternatives like Ollama and llama.cpp, and provide step-by-step installation instructions, performance benchmarks, code examples, and real-world use cases.

---

## DeepSeek V4 Flash Local Inference: DS4 vs Ollama vs llama.cpp
Running a massive model like DeepSeek V4 Flash requires hardcore optimization. Here is how DS4 obliterates the competition on an M-series Mac:

| Framework | 2-bit Quantization Speed | KV Cache Persistence | Hardware Optimization | Setup Difficulty |
| :--- | :--- | :--- | :--- | :--- |
| **DwarfStar 4 (DS4)** | **Ultra-Fast (35+ t/s)** | **Yes (Disk-backed)** | Native Metal / CUDA | Moderate |
| **Ollama** | Slow | No (RAM wipe on exit)| Generic cross-platform | Very Easy |
| **llama.cpp** | Medium | Partial | Manual compilation req. | Hard |


## What Is DS4 and Who Created It?

**DS4** stands for **DwarfStar 4**, a small native inference engine purpose-built for **DeepSeek V4 Flash**. It was created by **Salvatore Sanfilippo** ([antirez](https://github.com/antirez)), the Italian programmer famous for creating **Redis**, one of the most widely used in-memory data stores in the world.

Sanfilippo's approach with DS4 is characteristically opinionated: instead of building yet another generic model loader, he chose to focus entirely on making **one model** — DeepSeek V4 Flash — run exceptionally well on local hardware. The project is not a framework, not a wrapper, and not a universal GGUF runner. It is a **DeepSeek V4 Flash-specific Metal and CUDA graph executor** with custom loading, prompt rendering, KV state management, and server API glue.

> "This project would not exist without llama.cpp and GGML," Sanfilippo acknowledges, giving full credit to Georgi Gerganov and the llama.cpp community. DS4 borrows quantization formats, kernel ideas, and GGUF ecosystem knowledge from that project, but implements its own optimized execution path.

### Why DeepSeek V4 Flash?

Sanfilippo believes DeepSeek V4 Flash is a uniquely compelling model for local deployment. Here is why:

1. **Speed through efficiency**: With fewer active parameters during inference, it outperforms many smaller dense models in raw throughput.
2. **Proportional thinking**: In thinking mode, its reasoning section length adapts to problem complexity — often using only 1/5 the thinking tokens of comparable models. This makes it practical for real-world agent workflows where other models would stall.
3. **1 million token context window**: One of the largest context windows available in any open-weights model, enabling entire codebases, books, or long conversation histories to fit in a single prompt.
4. **Knowledge depth**: At 284B parameters, it knows significantly more than 27B or 35B models at the edges of knowledge.
5. **Superior writing quality**: Users report it "feels like a quasi-frontier model" in English, Italian, and other languages.
6. **Compressed KV cache**: Enables long-context inference on local machines and supports **on-disk KV cache persistence** — a game-changer for agent workflows.
7. **2-bit quantization viability**: When quantized asymmetrically (routed experts only), 2-bit weights run surprisingly well, fitting into 96-128GB MacBooks.

---

## Technical Architecture: Metal vs. CUDA Optimizations

DS4's architecture reflects a clear design philosophy: **maximize performance for the target hardware**, even if that means sacrificing generality. The project maintains three build targets:

| Build Target | Platform | Use Case |
|-------------|----------|----------|
| `make` | macOS | Metal-optimized production build |
| `make cuda-spark` | Linux (DGX Spark / GB10) | CUDA for NVIDIA GB10 systems |
| `make cuda-generic` | Linux (other CUDA GPUs) | General CUDA GPU support |
| `make cpu` | Any | Reference/debug build only |

### Metal on macOS

The Metal backend is DS4's **primary optimization target** for macOS. It leverages Apple's unified memory architecture to eliminate the PCIe transfer bottleneck that plagues discrete GPU setups. On a Mac Studio M3 Ultra with 512GB RAM, DS4 achieves:

- **468 tokens/second prefill** on long prompts (11,709 tokens)
- **36.86 tokens/second generation** with q2 quantization
- **448 tokens/second prefill** and **35.5 tokens/second generation** with q4

These numbers are competitive with — and in some cases exceed — what users achieve with llama.cpp or Ollama on equivalent hardware, particularly for long-context workloads where DS4's compressed KV cache and chunked prefill shine.

### CUDA on Linux

For Linux workstations, DS4 offers two CUDA build paths. The `cuda-spark` target is tuned for NVIDIA's DGX Spark (GB10) platform, while `cuda-generic` supports a broader range of local CUDA GPUs. On a DGX Spark GB10 with 128GB RAM, the engine reaches **343 tokens/second prefill** and **13.75 tokens/second generation** with q2 weights.

The CUDA path shares the same graph execution engine, KV cache compression, and API server as the Metal build, ensuring consistent behavior across platforms.

### CPU Path: Diagnostics Only

DS4 includes a CPU backend, but Sanfilippo is explicit: **"Do not treat the CPU path as the production target."** It exists for correctness validation, tokenizer diagnostics, and regression testing. In fact, on current macOS versions, the CPU path can trigger a kernel bug in the virtual memory implementation that crashes the system — a stark reminder that this is alpha-quality software.

### Key Architectural Innovations

1. **Asymmetric 2-bit quantization**: Unlike uniform quantization that degrades all layers equally, DS4's q2 quants apply `IQ2_XXS` to routed MoE up/gate projections and `Q2_K` to down projections, while leaving shared experts, projections, and routing layers untouched. This preserves quality where it matters most.

2. **Compressed KV cache with disk persistence**: DS4 treats the KV cache as a "first-class disk citizen." Rather than assuming KV state must live in RAM, it writes checkpoints to fast SSDs. This enables 100K-300K (and even 1M) context windows on machines with limited RAM.

3. **Exact DSML tool-call replay**: For agent integration, DS4 remembers the exact DSML text the model generated for each tool call, keyed by unguessable IDs. When stateless clients resend tool results, the server replays the exact bytes, avoiding prefix mismatch and expensive recomputation.

4. **Model-specific graph executor**: By not trying to support every GGUF file in existence, DS4 eliminates the overhead of generic tensor dispatch and can hardcode optimal memory layouts and kernel fusion strategies for DeepSeek V4 Flash's MoE architecture.

---

## Installation Guide for macOS and Linux

### Prerequisites

**macOS:**
- macOS 14+ (Sonoma or later)
- Apple Silicon Mac (M1/M2/M3/M4 or Ultra variants)
- **96GB RAM minimum** for q2 weights; **128GB recommended**
- **256GB+ RAM** for q4 weights
- Xcode Command Line Tools

**Linux (CUDA):**
- Ubuntu 22.04+ or compatible distribution
- NVIDIA GPU with CUDA support
- CUDA Toolkit 12.x+
- **96GB+ system RAM** for q2; **256GB+** for q4
- `build-essential`, `curl`, `git`

### Step 1: Clone the Repository

```bash
git clone https://github.com/antirez/ds4.git
cd ds4
```

### Step 2: Download Model Weights

DS4 only works with its own specially-crafted GGUF files. Use the provided download script:

```bash
# For 96-128GB RAM machines (recommended)
./download_model.sh q2-imatrix

# For 256GB+ RAM machines
./download_model.sh q4-imatrix

# Optional: speculative decoding support
./download_model.sh mtp
```

The script fetches from Hugging Face (`antirez/deepseek-v4-gguf`), stores files under `./gguf/`, and creates a symlink at `./ds4flash.gguf`.

### Step 3: Build the Engine

**macOS (Metal):**
```bash
make
```

**Linux (CUDA — DGX Spark / GB10):**
```bash
make cuda-spark
```

**Linux (CUDA — generic GPU):**
```bash
make cuda-generic
```

**CPU-only (diagnostics only):**
```bash
make cpu
```

This produces two binaries:
- `./ds4` — Interactive CLI
- `./ds4-server` — OpenAI/Anthropic-compatible HTTP API server

### Step 4: Verify Installation

```bash
# Quick one-shot test
./ds4 -p "Explain the CAP theorem in one paragraph."

# Check all options
./ds4 --help
./ds4-server --help
```

---

## Performance Benchmarks: DS4 vs. Ollama vs. llama.cpp

Benchmarking LLM inference is notoriously tricky — numbers vary by prompt length, quantization, batch size, and hardware. That said, DS4's published numbers reveal impressive performance, particularly for **long-context prefill**.

### DS4 Official Benchmarks (Metal, `--ctx 32768`, greedy decoding, `-n 256`)

| Machine | Quant | Prompt | Prefill | Generation |
|---------|-------|--------|---------|------------|
| MacBook Pro M3 Max, 128GB | q2 | short | 58.52 t/s | 26.68 t/s |
| MacBook Pro M3 Max, 128GB | q2 | 11,709 tokens | **250.11 t/s** | 21.47 t/s |
| Mac Studio M3 Ultra, 512GB | q2 | short | 84.43 t/s | 36.86 t/s |
| Mac Studio M3 Ultra, 512GB | q2 | 11,709 tokens | **468.03 t/s** | 27.39 t/s |
| Mac Studio M3 Ultra, 512GB | q4 | short | 78.95 t/s | 35.50 t/s |
| DGX Spark GB10, 128GB | q2 | 7,047 tokens | 343.81 t/s | 13.75 t/s |

### How DS4 Compares

**vs. Ollama:**
Ollama is excellent for getting started quickly and supports hundreds of models. However, as a general-purpose runner, it cannot apply the model-specific optimizations that DS4 uses. For DeepSeek V4 Flash specifically, DS4's asymmetric quantization mix, compressed KV cache, and custom Metal kernels typically deliver **20-40% better prefill throughput** on equivalent Apple Silicon hardware.

**vs. llama.cpp:**
llama.cpp is the foundational project that made local LLM inference possible. DS4 openly acknowledges its debt to llama.cpp and GGML. Where DS4 diverges is in its **single-model focus**: by not supporting arbitrary GGUF files, DS4 can hardcode tensor layouts, eliminate generic dispatch overhead, and validate correctness against official DeepSeek API logits. For users who only care about DeepSeek V4 Flash, DS4 offers a more "finished" experience with built-in server APIs, disk KV caching, and agent integration.

**The Verdict:** If you want a Swiss Army knife for many models, Ollama or llama.cpp are better choices. If you want DeepSeek V4 Flash to run as fast and reliably as possible on your Mac Studio or CUDA workstation, DS4 is purpose-built for that exact job.

---

## Code Examples for Running Inference

### One-Shot CLI Prompt

```bash
./ds4 -p "Write a Python function to implement merge sort."
```

### Interactive Chat Session

```bash
./ds4
```

This starts a multi-turn chat with persistent KV state. Useful commands:
- `/help` — Show available commands
- `/think` — Enable thinking mode (default)
- `/think-max` — Maximum reasoning effort
- `/nothink` — Disable thinking for faster responses
- `/ctx 100000` — Set context window size
- `/read FILE` — Include file contents in context
- `/quit` — Exit

### Server Mode with OpenAI-Compatible API

```bash
./ds4-server \
  --ctx 100000 \
  --kv-disk-dir /tmp/ds4-kv \
  --kv-disk-space-mb 8192
```

The server starts on `http://127.0.0.1:8000` with these endpoints:
- `GET /v1/models`
- `POST /v1/chat/completions`
- `POST /v1/completions`
- `POST /v1/messages` (Anthropic-compatible)

### cURL Example (Chat Completions)

```bash
curl http://127.0.0.1:8000/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "deepseek-v4-flash",
    "messages": [
      {"role": "user", "content": "List three Redis design principles."}
    ],
    "stream": true
  }'
```

### Python Client Example

```python
import openai

client = openai.OpenAI(
    base_url="http://127.0.0.1:8000/v1",
    api_key="dsv4-local"
)

response = client.chat.completions.create(
    model="deepseek-v4-flash",
    messages=[
        {"role": "system", "content": "You are a helpful coding assistant."},
        {"role": "user", "content": "Refactor this function to use list comprehensions."}
    ],
    stream=True,
    temperature=0.7
)

for chunk in response:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="")
```

### Tool Use Example

DS4 supports OpenAI-style function calling. The server converts tool schemas to DeepSeek's DSML format and maps results back automatically:

```bash
curl http://127.0.0.1:8000/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "deepseek-v4-flash",
    "messages": [{"role": "user", "content": "What is the weather in Tokyo?"}],
    "tools": [{
      "type": "function",
      "function": {
        "name": "get_weather",
        "parameters": {
          "type": "object",
          "properties": {
            "location": {"type": "string"}
          },
          "required": ["location"]
        }
      }
    }],
    "tool_choice": "auto"
  }'
```

---

## Use Cases: Where DS4 Excels

### 1. Local AI Development & Coding Agents

DS4 is explicitly designed for **coding agent workflows**. Its OpenAI-compatible server API works with popular agent frameworks like **OpenCode**, **Pi**, and **Claude Code**. The disk KV cache means that after an expensive initial prefill (often 25K+ tokens for agent setups), subsequent turns reuse the cached prefix instead of recomputing from scratch.

### 2. Privacy-First LLM Deployment

For organizations handling sensitive data — legal documents, medical records, proprietary source code — running DeepSeek V4 Flash locally with DS4 ensures **zero data leaves your machine**. There are no API keys to manage, no rate limits, and no vendor lock-in.

### 3. Edge Deployment

With 2-bit quantization enabling operation on 96GB systems and compressed KV caches that spill to disk, DS4 brings frontier-class LLM capabilities to **edge hardware** that would previously require cloud APIs. A Mac Studio in a secure facility can now process million-token contexts without internet connectivity.

### 4. Long-Context Research & Analysis

The 1 million token context window opens possibilities that were impractical before:
- Analyze entire legal case files in a single pass
- Review complete git repository histories with full diff context
- Process books, research papers, and multi-document corpora
- Maintain months-long conversation histories without truncation

### 5. Cost Optimization

At zero dollars per token, local inference with DS4 eliminates API costs for high-volume workflows. The upfront hardware investment (a high-end Mac or workstation) pays for itself quickly when processing millions of tokens per month.

---

## Limitations You Should Know

DS4 is powerful, but it is important to understand its constraints:

1. **Alpha quality**: Sanfilippo is explicit that the code is alpha quality. It has existed for only a short time and will take months to mature. Expect bugs and rough edges.

2. **Single model support**: DS4 only runs DeepSeek V4 Flash GGUFs created specifically for this project. You cannot load arbitrary GGUF files or other models.

3. **High memory requirements**: Realistic operation requires 96-128GB RAM for q2 weights and 256GB+ for q4. This excludes most consumer laptops.

4. **CPU path is broken on macOS**: A macOS kernel VM bug causes crashes when running CPU inference. Metal is the only viable macOS path.

5. **No request batching**: The server processes one inference request at a time. Concurrent requests queue and wait their turn.

6. **MTP speculative decoding is experimental**: The optional MTP path provides at most slight speedups currently, not meaningful generation gains.

7. **AI-assisted development**: The codebase was built with heavy assistance from GPT-5.5. If you are uncomfortable with AI-generated code, DS4 may not be for you.

8. **Platform scope**: Optimized for Metal (macOS) and CUDA (Linux). Windows and AMD GPU support are not current priorities.

---


---

## Related Articles

- [AI Tools Directory 2024](/resources/dev-utils/ai-tools-directory/) - Complete guide
- [Hermes Agent: Self-Improving AI](/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/) - AI with memory
- [Free Claude Code](/resources/ai-tools/free-claude-code-open-source-proxy/) - Free AI coding
- MemPalace: AI Memory - Perfect memory
- Product Hunt Alternatives - Launch platforms

## Conclusion

DS4 represents a bold bet on the future of local LLM inference: **doing one thing exceptionally well** rather than many things adequately. By focusing exclusively on DeepSeek V4 Flash, Salvatore Sanfilippo has created an engine that outperforms generic alternatives on the specific model it targets, while delivering production-ready features like disk KV caching, exact tool-call replay, and OpenAI-compatible APIs.

For developers with the hardware to run it — a high-end Mac Studio or a CUDA-equipped Linux workstation — DS4 offers a compelling path to **private, fast, and cost-free inference** with one of the most capable open-weights models available today. The 1 million token context window, intelligent thinking modes, and compressed KV architecture make it particularly well-suited for coding agents, long-document analysis, and privacy-critical deployments.

As the project matures from alpha to stable, DS4 could become the definitive way to run DeepSeek V4 Flash locally. If you have the hardware and the use case, it is absolutely worth evaluating alongside Ollama and llama.cpp.

---

**Ready to try DS4?** Head to [github.com/antirez/ds4](https://github.com/antirez/ds4), clone the repository, download the q2-imatrix weights, and experience frontier-class local inference today.

---


---

## Recommended Infrastructure for Self-Hosting

If you want to run this stack reliably 24/7, infrastructure choice matters:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

*Published by the dibi8 Tech Team. For more guides on AI tools, developer resources, and open-source software, visit [dibi8.com](https://dibi8.com).*

## FAQ: Pushing the Limits with DS4

**Q: Can I run DeepSeek V4 Flash on an M3 MacBook Pro?**
A: Absolutely. Thanks to Metal optimization and 2-bit quantization, you can run it smoothly on an M3 Max with 128GB RAM. Smaller models fit on 64GB versions.

**Q: DS4 local inference vs DeepSeek API cost comparison?**
A: If you are running coding agents 24/7, API costs can exceed $1,000/month. Local inference with DS4 is a one-time hardware investment with zero recurring API fees.

**Q: How does disk KV cache work in DS4?**
A: Unlike Ollama which dumps context, DS4 saves the KV cache to your SSD. You can resume a 100K token conversation instantly without waiting for prompt reprocessing!

<!--auto-references-->
## References & Sources

- [DS4 (DwarfStar 4)](https://github.com/antirez/ds4)
- [antirez (Salvatore Sanfilippo)](https://github.com/antirez)
- [Redis](https://github.com/redis/redis)
- [llama.cpp](https://github.com/ggml-org/llama.cpp)
- [GGML](https://github.com/ggml-org/ggml)
- [Ollama](https://github.com/ollama/ollama)
- [Claude Code](https://github.com/anthropics/claude-code)
