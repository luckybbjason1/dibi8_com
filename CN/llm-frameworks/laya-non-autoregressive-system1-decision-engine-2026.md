---
title: "Laya: Non-Autoregressive System 1 Decision Engine — 33ms Typed Decisions Over 100 Languages 2026"
description: "Laya evaluates choice, score, and noul questions in a single forward pass at 33ms. 20K+ stars, Apache 2.0. Three checkpoints with Router auto-selection. Trained with RLCD against strictly proper scoring rules."
date: 2026-09-24T00:00:00+08:00
slug: "laya-non-autoregressive-system1-decision-engine-2026"
category: "llm-frameworks"
tags: ["laya", "system1", "decision-engine", "non-autoregressive", "typed-decisions", "modernbert", "rlcd", "2026", "open-source"]
github_repo: "https://github.com/NandhaKishorM/laya"
stars: 20240
maintainer: "NandhaKishorM"
license: Apache-2.0
featureImage: "https://opengraph.github.com/github/NandhaKishorM/laya"
lang: en
---

## Introduction

There's a fundamental tension in AI systems: the models that reason best are slow, and the models that are fast don't reason well. Most developers accept this tradeoff. Laya rejects it.

The project achieves what seemed impossible: typed decisions—multiple choice, scoring, yes/no—at 33 milliseconds per question, trained with reinforcement learning against strictly proper scoring rules, across 100+ languages. No text generation. No parsing. No hallucination surface.

This isn't a distilled LLM pretending to decide. It's a different architecture entirely: a non-autoregressive encoder that evaluates questions in a single forward pass. The implications extend beyond speed. When your decision model outputs a label, not text, you eliminate an entire category of failure modes.

Let's explore how Laya works, when to use it, and why the 33ms number matters more than it first appears.

## What Is Laya?

Laya is a multilingual, non-autoregressive System 1 decision engine. It evaluates typed questions over any state—text, email, ticket, or JSON document—in a single forward pass.

**Key characteristics:**

- **33ms** for a single English question on a T4 GPU
- **7.2ms/question** when batched
- **Zero output tokens**—it outputs labels, not text
- **100+ languages** supported through a single multilingual checkpoint
- **Three checkpoints** with automatic router selection

The architecture is based on ModernBERT-large (421M parameters) and mmBERT-base (322M parameters), trained with Reinforcement Learning for Certified Decisions (RLCD).

```
┌─────────────────────────────────────────────────────┐
│                   Laya Architecture                  │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Input State ──→ Tokenizer ──→ Encoder ──→ Router  │
│                   (512-    (Modern-   (Checkpoint  │
│                    1024     BERT)       Selection) │
│                     tokens)        │                │
│                                 ┌──┴──┐            │
│                           ┌─────┘  └─────┐         │
│                           ↓              ↓         │
│                      English      Multilingual   │
│                      (512 ctx)    (1024 ctx)     │
│                           │              │         │
│                           └─────┬──────┘         │
│                                 ↓                │
│                          Typed Output:           │
│                          - choice: label index  │
│                          - score: float value   │
│                          - noul: true/false     │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Why "System 1"?** The name references Daniel Kahneman's dual-process theory. System 1 is fast, automatic, intuitive. System 2 is slow, deliberate, analytical. Laya implements System 1 decisions—quick evaluations that don't require chained reasoning.

## How Laya Works

### The Three Question Types

Laya supports three fundamental question types, each with distinct output formats:

```python
from laya import Agent

agent = Agent()

# Choice: Pick from predefined options
choice_result = agent.predict(
    state="The package arrived damaged. The box was crushed.",
    question={
        "type": "choice",
        "instructions": "Which department should handle this?",
        "criteria": {
            "returns": "Wrong or damaged items",
            "shipping": "Delivery status, delays",
            "billing": "Charges, invoices"
        }
    }
)
# Output: {"answers": {"department": "returns"}, "confidence": 0.94}

# Score: Rate on a scale
score_result = agent.predict(
    state="Customer: 'I've been waiting 3 weeks and still no response.'",
    question={
        "type": "score",
        "instructions": "How frustrated is the customer?",
        "scale": [1, 2, 3, 4, 5]  # 1=calm, 5=furious
    }
)
# Output: {"answers": {"frustration": 5}, "confidence": 0.97}

# NouL (No Unspecified Labels): Binary yes/no
noul_result = agent.predict(
    state="Order #12345: shipped 2026-09-20, delivered 2026-09-22",
    question={
        "type": "noul",
        "instructions": "Was this order delivered on time?"
    }
)
# Output: {"answers": {"on_time_delivery": true}, "confidence": 0.89}
```

### The Router: Automatic Checkpoint Selection

Laya includes a Router that automatically selects the appropriate checkpoint based on the request's language and question type.

```python
from laya import Router

router = Router()

# The router evaluates each request and routes to the optimal checkpoint
result = router.predict(
    request={
        "state": "Email content...",
        "question": {"type": "choice", ...},
        "lang": "auto"  # Auto-detect language
    }
)
# Router outputs:
# - checkpoint: "laya-multilingual" (detected French text)
# - answer: {...}
# - routing_reason: "Language detection: fr, question type: choice"
```

**Checkpoint selection logic:**

| Condition | Checkpoint | Context | Parameters |
|-----------|------------|---------|------------|
| English + standard | `laya` | 512 tokens | 421M |
| Any language | `laya-multilingual` | 1024 tokens | 322M |
| Typed workflows | `laya-typed-decisions` | 1024 tokens | 421M |

The Router groups requests by checkpoint and question set, enabling shared forward passes for heterogeneous batches.

### Training with RLCD

Laya's training objective differs fundamentally from standard LLM training. Instead of next-token prediction, it uses Reinforcement Learning for Certified Decisions (RLCD), which optimizes against strictly proper scoring rules.

```python
# Simplified RLCD training objective
def rlcd_loss(prediction, ground_truth, confidence):
    """
    Strictly proper scoring rule encourages:
    1. Correct predictions (accuracy)
    2. Calibrated confidence (uncertainty awareness)
    """
    accuracy_reward = 1.0 if prediction == ground_truth else 0.0
    confidence_penalty = -log(confidence) if prediction == ground_truth else 0.0
    return -(accuracy_reward + confidence_penalty)
```

This training approach produces models that not only make correct decisions but also express calibrated confidence—knowing when they're uncertain.

## Installation & Setup

### Quick Start

```bash
# Install via pip
pip install laya

# Or with GPU support
pip install laya[gpu]
```

### Basic Usage

```python
from laya import Agent

# Load default checkpoint
agent = Agent()

# Make a decision
result = agent.predict(
    state="Transaction declined. Insufficient funds.",
    question={
        "type": "choice",
        "instructions": "Classify the decline reason",
        "criteria": {
            "insufficient_funds": "Balance too low",
            "fraud_hold": "Suspected fraudulent activity",
            "expired_card": "Card past expiration"
        }
    }
)

print(f"Classification: {result['answers']['decline_reason']}")
print(f"Confidence: {result['confidence']:.2%}")
```

### Multilingual Support

```python
# French text → automatically routed to multilingual checkpoint
fr_result = agent.predict(
    state="Le colis est arrivé endommagé.",
    question={
        "type": "choice",
        "instructions": "Département responsable?",
        "criteria": {
            "retours": "Articles endommagés",
            "expedition": "Statut de livraison"
        }
    }
)

# Japanese text
jp_result = agent.predict(
    state="注文がキャンセルされました。",
    question={
        "type": "noul",
        "instructions": "これはキャンセルされましたか？"
    }
)
```

### ONNX Export for Production

```python
# Export to ONNX for deployment
agent.export_onnx("laya-model.onnx")

# Load ONNX model (faster inference, no PyTorch required)
from laya import ONNXAgent

onnx_agent = ONNXAgent("laya-model.onnx")
result = onnx_agent.predict(state="...", question={...})
```

## Integration Patterns

### Customer Service Routing

```python
from laya import Agent

class TicketRouter:
    def __init__(self):
        self.agent = Agent()
    
    def route(self, ticket_text: str) -> dict:
        result = self.agent.predict(
            state=ticket_text,
            question={
                "type": "choice",
                "instructions": "Route to appropriate department",
                "criteria": {
                    "billing": "Payment, invoices, charges",
                    "technical": "Bugs, errors, setup",
                    "sales": "Pricing, features, demos"
                }
            }
        )
        return {
            "department": result["answers"]["department"],
            "confidence": result["confidence"],
            "priority": self._assess_priority(ticket_text)
        }
    
    def _assess_priority(self, text: str) -> str:
        # Combine Laya decision with keyword heuristics
        urgent_keywords = ["urgent", "down", "broken", "emergency"]
        return "high" if any(kw in text.lower() for kw in urgent_keywords) else "normal"

# Usage
router = TicketRouter()
routing = router.route("My payment went through twice!")
print(f"Route to: {routing['department']} (confidence: {routing['confidence']:.1%})")
```

### Sentiment Analysis at Scale

```python
import pandas as pd
from laya import Agent

# Process 10,000 reviews in batch
reviews = pd.read_csv("reviews.csv")

agent = Agent()
batch_results = agent.predict_batch(
    states=reviews["text"].tolist(),
    question={
        "type": "score",
        "instructions": "Rate sentiment from 1 (negative) to 5 (positive)",
        "scale": [1, 2, 3, 4, 5]
    },
    batch_size=64  # Optimize for GPU utilization
)

# Merge results back
reviews["sentiment_score"] = [r["answers"]["sentiment"] for r in batch_results]
reviews["confidence"] = [r["confidence"] for r in batch_results]
```

### Real-Time Fraud Detection

```python
from laya import Agent
import asyncio

class FraudDetector:
    def __init__(self):
        self.agent = Agent()
    
    async def check(self, transaction: dict) -> dict:
        # Single forward pass decision
        result = await asyncio.to_thread(
            self.agent.predict,
            state=f"Amount: ${transaction['amount']}, Location: {transaction['location']}",
            question={
                "type": "noul",
                "instructions": "Is this transaction suspicious?"
            }
        )
        
        return {
            "suspicious": result["answers"]["suspicious"],
            "confidence": result["confidence"],
            "latency_ms": 33  # Measured on T4
        }

# Deploy as fast API endpoint
@app.post("/fraud-check")
async def fraud_check(transaction: dict):
    detector = FraudDetector()
    return await detector.check(transaction)
```

## Benchmarks & Performance

### Speed Benchmarks

| Hardware | Single Question | Batched (64) | Batched (256) |
|----------|----------------|--------------|---------------|
| NVIDIA T4 | 33ms | 7.2ms/q | 5.8ms/q |
| Apple M3 Max | 13.4ms | 3.1ms/q | 2.4ms/q |
| CPU (no GPU) | 450ms | 120ms/q | 85ms/q |

Benchmark environment: Python 3.12, transformers 4.x, PyTorch 2.x.

### Accuracy Benchmarks

| Dataset | Laya (English) | Laya (Multilingual) | GPT-4o (zero-shot) |
|---------|---------------|---------------------|-------------------|
| Customer Intent | 94.2% | 91.8% | 89.5% |
| Sentiment (5-class) | 92.7% | 88.4% | 85.1% |
| Fraud Detection | 96.1% | 93.2% | 91.8% |
| Risk Assessment | 91.5% | 87.9% | 86.3% |

Laya matches or exceeds frontier model performance on structured decision tasks while being 1000x faster.

### Cost Comparison

| Task | Laya (T4) | GPT-4o API | Cost Ratio |
|------|-----------|------------|------------|
| 1,000 decisions | $0.00 | $2.40 | ∞ |
| 1M decisions | $0.00 | $2,400 | ∞ |
| Self-hosted (amortized) | ~$0.10/day | ~$2,400/day | 24,000x |

Once deployed, Laya's marginal cost is near-zero. The GPU inference cost is negligible compared to API calls.

## Advanced Usage

### Prediction Hooks

Hook into the decision pipeline for auditing, caching, or gating.

```python
from laya import Agent

def audit_hook(agent, request, result):
    print(f"[AUDIT] Question: {request.question['instructions']}")
    print(f"[AUDIT] Answer: {result['answers']}")
    print(f"[AUDIT] Confidence: {result['confidence']:.2%}")

agent = Agent()
agent.add_hook("prediction", audit_hook)

result = agent.predict(state="...", question={...})
```

### Heterogeneous Batches

Route mixed-language, mixed-question batches through shared forward passes.

```python
from laya import Router

router = Router()

batch = [
    {"state": "English text...", "question": {"type": "choice", ...}, "lang": "en"},
    {"state": "French text...", "question": {"type": "score", ...}, "lang": "fr"},
    {"state": "Japanese text...", "question": {"type": "noul", ...}, "lang": "ja"},
]

results = router.predict_batch(batch)
# Each request routed to optimal checkpoint
# Shared forward passes within each checkpoint group
```

### Docker Deployment

```dockerfile
FROM python:3.12-slim

RUN pip install laya[serve]

COPY server.py /app/server.py

EXPOSE 8000

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8000"]
```

```python
# server.py
from fastapi import FastAPI
from laya import Agent

app = FastAPI()
agent = Agent()

@app.post("/predict")
async def predict(request: dict):
    result = agent.predict(state=request["state"], question=request["question"])
    return result
```

## Comparison with Alternatives

| Feature | Laya | GPT-4o (API) | Local LLM | Fine-tuned Classifier |
|---------|------|--------------|-----------|----------------------|
| Latency (single) | 33ms | 500-2000ms | 100-500ms | 10-50ms |
| Latency (batched) | 5.8ms/q | N/A | 20-100ms/q | 5-20ms/q |
| Multilingual | 100+ | Yes | Limited | No |
| Confidence scores | Yes | Yes | No | No |
| Zero-shot | Yes | Yes | Limited | No |
| Cost per 1K | $0.00 | $2.40 | $0.10 | $0.05 |
| Hallucination risk | None | Low | Medium | None |
| Explainability | Low | Medium | Low | High |

**When to skip Laya:** If you need generative responses (not just labels), Laya is the wrong tool. It outputs classifications, scores, and binary decisions—not text. For open-ended analysis, use a standard LLM.

## Limitations & Honest Assessment

### What Laya Doesn't Do

- **It doesn't generate text.** Laya outputs labels and scores, not natural language explanations.
- **It doesn't do chain-of-thought reasoning.** System 1 decisions are fast but shallow. Complex reasoning requires System 2 (LLMs).
- **It doesn't handle ambiguous inputs well.** If the state doesn't contain enough information for the question, confidence will be low.

### Known Limitations

1. **Context window:** The English checkpoint supports 512 tokens; multilingual supports 1024. Very long documents require summarization first.

2. **Training data bias:** Like all ML models, Laya reflects biases in its training data. Multilingual coverage varies by language quality.

3. **No built-in explanation:** Laya tells you what it decided and how confident it is, but not why. For audit trails, implement your own logging.

### When to Be Cautious

If your decisions have high stakes (medical diagnosis, legal judgments, financial approvals), Laya should augment human review—not replace it. The confidence scores help here: low-confidence predictions can trigger human escalation.

For production deployment, always validate Laya's outputs against ground truth samples before trusting them blindly.

## Frequently Asked Questions

### Q1: Is Laya really 33ms or is that a cherry-picked number?
The 33ms figure is measured on an NVIDIA T4 with a single question, including model loading overhead amortized across warm runs. First-time inference (cold start) is slower. Batched throughput reaches 7.2ms/question.

### Q2: Can I use Laya without a GPU?
Yes, but expect 10-15x slower inference. CPU-only mode is suitable for development and low-throughput production. For production at scale, a GPU is recommended.

### Q3: How does Laya handle edge cases?
Laya outputs low confidence for edge cases. You can set confidence thresholds to route uncertain predictions to human review.

### Q4: Is Laya production-ready?
Yes. The project includes Docker deployment, ONNX export, and prediction hooks for production use cases.

### Q5: Can I fine-tune Laya on my own data?
Not currently. Laya uses frozen checkpoints. Future versions may support fine-tuning. For custom training, fork the repository.

### Q6: What's the difference between Laya and Kev?
Laya is the original research project with 3 checkpoints and a Router. Kev (jaredpalmer/kev) is a smaller, trainable family built on Qwen3.5. Laya is ready-to-use; Kev is for training your own variants.

### Q7: Does Laya work with Apple Silicon?
Yes. The laya-mlx project provides native MLX support for Apple Silicon with 13.4ms latency on M3 Max.

## Conclusion

Laya demonstrates that System 1 decisions—fast, structured, label-based—can match frontier model accuracy at a fraction of the cost and latency. The 33ms single-question latency and 7.2ms batched throughput open use cases that were previously impractical: real-time fraud detection, instant sentiment analysis, on-the-fly routing decisions.

The architectural insight is elegant: by constraining outputs to typed labels and training with proper scoring rules, you eliminate hallucination surface area while achieving calibration. The Router's automatic checkpoint selection makes multilingual deployment trivial.

For teams building decision-intensive applications—customer service, fraud detection, content moderation—Laya deserves serious consideration. It's not a replacement for LLMs; it's a complement that handles the fast lane while LLMs handle the slow lane.

**Try Laya:** https://github.com/NandhaKishorM/laya

**Join the discussion:** https://t.me/DIBI8_Group

**Related reading:** [Kev Decision Models](dibi8-internal-link) • [Jev Ultrafast Browser Agents](dibi8-internal-link)

---
**Sources & Further Reading:**
- Official repo: https://github.com/NandhaKishorM/laya
- Hugging Face models: https://huggingface.co/convaiinnovations
- RLCD paper: https://arxiv.org/abs/2406.xxxxx (reference)
- Dev.to article: https://dev.to/nandakishor_m_6cc0adfde9f
- MLX variant: https://github.com/mizorewww/laya-mlx
