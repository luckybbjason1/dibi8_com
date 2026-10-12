---


title: "Laya: Non-Autoregressive System 1 Decision Engine — 33ms Typed Decisions Over 100 Languages 2026"
description: "AI tool comparison and guide"
date: 2026-09-24T00:00:00+08:00
slug: "laya-non-autoregressive-system1-decision-engine-2026"
category: "llm-frameworks"
tags: ["laya", "system1", "decision-engine", "non-autoregressive", "typed-decisions", "modernbert", "rlcd", "2026", "open-source"]
categories: ["llm-frameworks"]
github_repo: "https://github.com/NandhaKishorM/laya"
stars: 20240
maintainer: "NandhaKishorM"
license: Apache-2.0
featureImage: "https://opengraph.github.com/github/NandhaKishorM/laya"
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
|