---


title: "Kev: Train Your Own Decision Models on Qwen3.5 — A Practical Framework for Small Typed Decisions 2026"
description: "AI tool comparison and guide"
date: 2026-09-24T00:00:00+08:00
slug: "kev-trainable-decision-models-qwen35-2026"
category: "llm-frameworks"
tags: ["kev", "qwen35", "trainable-models", "decision-models", "jared-palmer", "rlvr", "pydantic", "2026", "open-source"]
categories: ["llm-frameworks"]
github_repo: "https://github.com/jaredpalmer/kev"
stars: 5888
maintainer: "jaredpalmer"
license: MIT
featureImage: "https://opengraph.github.com/github/jaredpalmer/kev"
---



## Introduction

Jared Palmer is known for React ecosystem tools—Next.js, Formik, React Training. His latest project, Kev, represents a different kind of contribution: a framework for training small decision models that output structured labels instead of text.

The premise is deceptively simple: take a Qwen3.5 model, add a classification head, train it with reinforcement learning, and you get a model that makes typed decisions in under 100 lines of code.

But the implications are significant. For the first time, developers can train their own decision models—models that classify, score, and categorize without hallucinating free-form text. The cost is minimal: training runs on a single GPU for hours, not weeks. The inference cost is near-zero: these models run at tens of milliseconds on CPU.

Let's explore how Kev works, why it matters, and whether trainable decision models are the next step in AI efficiency.

## What Is Kev?

Kev is a framework for creating trainable decision models based on Qwen3.5. Unlike LLMs that generate text token-by-token, Kev trains small models to output structured labels directly.

**Key features:**

- **30K+ parameters** — Tiny models that fit in memory
- **RLVR training** — Reinforcement Learning from Verifiable Rewards
- **JSON/Pydantic outputs** — Structured schemas, not free text
- **Under 100 lines** — Minimal code to get started
- **Qwen3.5 base** — Leverages recent open-weight models

```
┌─────────────────────────────────────────────────────┐
│                    Kev Architecture                  │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Qwen3.5 Base ──→ Classification Head ──→ Labels    │
│   (30K+ params)    (lightweight)         (JSON)      │
│        │                                    │        │
│        │                            Verifiable   │
│        │                            Rewards      │
│        │                                 │        │
│        └──────── RLVR Training ──────────┘        │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Kev vs. Laya vs. Jev

These three projects solve overlapping but distinct problems:

| Project | Author | Purpose | Training | Output |
|