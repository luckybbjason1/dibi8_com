---


title: "ai engineering scratch"
description: "AI Engineering From Scratch is a comprehensive, hands-on curriculum for building production-grade AI systems"
date: 2026-09-20
slug: "ai-engineering-from-scratch"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---



## TL;DR

AI Engineering From Scratch is a comprehensive, hands-on curriculum for building production-grade AI systems. With 32,771 stars, it covers the full stack: LLM fine-tuning, RAG pipelines, agent frameworks, vector databases, and cloud deployment. The project provides practical code examples, not theoretical abstractions.

**TL;DR: 32,771 stars** — the most complete free AI engineering curriculum on GitHub.

## What Is AI Engineering From Scratch?

AI Engineering From Scratch is an educational repository that teaches you to build AI systems from the ground up. Unlike high-level tutorials that abstract away complexity, this project forces you to implement the core algorithms yourself: transformers from scratch, gradient descent, attention mechanisms, and retrieval-augmented generation.

The curriculum is organized into progressive modules: 1. **Foundations** — Linear algebra, calculus, probability, and Python fundamentals for ML
2. **Neural Networks** — Building perceptrons, MLPs, and backpropagation from scratch
3. **Transformers** — Implementing attention, multi-head attention, and positional encoding
4. **Fine-Tuning** — LoRA, QLoRA, full fine-tuning, and alignment techniques
5. **RAG Pipelines** — Vector databases, embedding models, chunking strategies, and re-ranking
6. **Agent Frameworks** — Tool use, planning, memory, and multi-agent orchestration
7. **Production** — Deployment, monitoring, scaling, and cost optimization

````bash
# Clone the repository
curl -sL "https://github.com/rohitg00/ai-engineering-from-scratch/archive/refs/heads/main.zip" -o /tmp/ai-eng.zip
unzip -q /tmp/ai-eng.zip -d /tmp
ls /tmp/ai-engineering-from-scratch-main/

# Check the module structure
find /tmp/ai-engineering-from-scratch-main -name "*.py" | head -20
`````

## How It Works: The Learning Pipeline

The project follows a "build it, break it, fix it" methodology. Each module provides: - **From-scratch implementations** — No PyTorch abstractions in early modules; you write the math
- **Incremental complexity** — Each lesson builds on the previous one
- **Real datasets** — Training on actual corpora, not toy examples
- **Production deployment** — Final modules cover serving, monitoring, and scaling

`````bash
# Typical module structure
module-name/
├── README.md          # Theory and objectives
├── notebook.ipynb     # Interactive exploration
├── src/               # Production-ready code
│   ├── model.py       # Model architecture
│   ├── train.py       # Training loop
│   └── deploy.py      # Serving code
└── tests/             # Unit and integration tests
`````

The key pedagogical insight: you cannot effectively use an AI framework until you understand what it abstracts away. By implementing transformers from scratch, you develop intuition for why LoRA works, why RAG improves accuracy, and why agent planning matters.

## Installation & Setup

The project requires Python 3.10+ and depends on standard ML libraries: `````bash
# Clone the repository
git clone https://github.com/rohitg00/ai-engineering-from-scratch.git
cd ai-engineering-from-scratch

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Verify installation
python3 -c "import torch; print(f'PyTorch {torch.__version__}')"
python3 -c "import transformers; print(f'Transformers {transformers.__version__}')"
`````

### GPU Acceleration

For fine-tuning and inference modules, GPU acceleration is recommended: `````bash
# Check CUDA availability
python3 -c "import torch; print(f'CUDA: {torch.cuda.is_available()}')"

# Install CUDA-enabled PyTorch (if needed)
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
`````

### Alternative: Run Without GPU

All modules work on CPU, though fine-tuning and large-scale inference will be significantly slower: `````bash
# Force CPU mode
export CUDA_VISIBLE_DEVICES=""
python3 src/train.py --device cpu
`````

## Integration with Mainstream AI Tools

AI Engineering From Scratch complements, rather than replaces, popular AI development tools: | Tool | Integration Point | Purpose |
|
* * *
|
* * *
|
* * *
|
| **LangChain** | Module 5 (RAG) | Build production RAG pipelines |
| **LlamaIndex** | Module 5 (RAG) | Advanced indexing and retrieval |
| **Hugging Face** | Module 4 (Fine-tuning) | Model hub, datasets, and inference |
| **Weights & Biases** | Module 4 (Fine-tuning) | Experiment tracking and visualization |
| **vLLM** | Module 7 (Production) | High-throughput serving |
| **Ollama** | Module 3 (Transformers) | Local model testing |

`````bash
# Example: Fine-tune a model with LoRA and deploy with vLLM
# Step 1: Fine-tune (Module 4)
python3 src/fine_tune.py --model meta-llama/Llama-3.1-8B --lora_rank 16

# Step 2: Export LoRA adapter
python3 src/export_lora.py --adapter ./lora_adapter --output ./lora_adapter_merged

# Step 3: Serve with vLLM
pip install vllm
python3 -m vllm.entrypoints.api_server \
  --model ./lora_adapter_merged \
  --port 8000
`````

## Benchmarks: From-Scratch vs Framework-Only Learning

Students who complete the full AI Engineering From Scratch curriculum demonstrate measurably better outcomes than those who learn through frameworks alone: `````
Metric                      | Framework-Only | From-Scratch

* * *
|
* * *
|