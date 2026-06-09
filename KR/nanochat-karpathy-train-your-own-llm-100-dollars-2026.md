---
title: 'nanochat 2026: Andrej Karpathy의 오픈소스 ChatGPT $100 — 8,000줄 전체 LLM 파이프라인'
description: 'Andrej Karpathy의 nanochat는 토크나이저, 사전학습, 파인튜닝, 평가, 추론, 채팅 UI를 포함한 전체 LLM 훈련 파이프라인으로, 단일 8×H100 노드에서 $100 미만으로 GPT-2 수준의 챗봇을 처음부터 훈련하도록 설계되었습니다.'
date: 2026-06-09 00:00:00+08:00
lastmod: 2026-06-09 00:00:00+08:00
tech_stack: ['Python', 'PyTorch', 'Rust', 'LLM Training']
application_domain: LLM Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: 'https://github.com/karpathy/nanochat'
backup_url: ''
github_repo: 'karpathy/nanochat'
stars: 54700
maintainer: 'karpathy'
last_maintained: '2026-06-01'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['nanochat', 'karpathy', 'LLM-훈련', 'PyTorch', 'GPT', '자체호스팅', '오픈소스', 'transformer']
aliases:
- /kr/posts/nanochat-karpathy-train-your-own-llm-100-dollars-2026/
faqs:
  - q: 'nanochat란 무엇이며 누가 만들었습니까?'
    a: 'nanochat는 Andrej Karpathy(OpenAI 공동창립자, 전 테슬라 AI 총감독)가 만든 최소한의 전체 스택 LLM 훈련·추론 파이프라인입니다. 기존 nanoGPT가 사전학습만 다뤘던 것과 달리, nanochat는 Rust BPE 토크나이저, 사전학습, 지도 파인튜닝, 평가, 추론 서버, 채팅 UI를 포함한 완전한 파이프라인을 약 8,000줄의 읽기 쉬운 코드로 제공합니다.'
  - q: 'nanochat로 모델 훈련 비용은 얼마입니까?'
    a: 'Karpathy는 GPT-2 수준의 챗봇을 처음부터 훈련하는 데 약 $48–$100이면 된다고 추정합니다. 단일 8×H100 노드(클라우드 임대 시 약 $24/시간)에서 2시간이면 대화 가능한 모델을, 4시간이면 훨씬 나은 추론 품질을 얻을 수 있습니다. 2019년 GPT-2 훈련 비용 $43,000에 비해 수천 배 감소했습니다.'
  - q: 'nanochat와 Ollama의 차이점은 무엇입니까?'
    a: 'Ollama는 추론 런타임입니다 — 기존 사전학습 모델을 로드하고 서빙합니다. nanochat는 훈련 프레임워크입니다 — 원시 텍스트 데이터에서 모델을 훈련합니다. Ollama는 자동차고, nanochat는 엔진을 만드는 공장입니다. nanochat도 추론 서버와 채팅 UI를 포함하지만, 핵심 목적은 훈련입니다.'
---

![nanochat 2026: Andrej Karpathy LLM 훈련 파이프라인 — dibi8.com](/images/articles/nanochat-karpathy-train-your-own-llm-100-dollars-2026/cover.jpg)

2025년 10월, Andrej Karpathy는 간단한 전제로 [nanochat](https://github.com/karpathy/nanochat)를 발표했습니다: "$100으로 살 수 있는 최고의 ChatGPT." 2026년 6월 기준 **54,700개의 GitHub 스타**를 기록하며 오픈소스 커뮤니티에서 가장 많이 읽히는 LLM 훈련 튜토리얼이 되었습니다.

## nanochat의 구성 요소

1. **토크나이저 (Rust)** — 데이터에서 처음부터 훈련하는 커스텀 BPE 토크나이저, Rust로 구현
2. **사전학습 (PyTorch)** — FineWeb에서 Transformer 훈련, FlashAttention-2·BF16 혼합 정밀도 지원
3. **파인튜닝 (SFT)** — SmolTalk 대화 데이터, 객관식 QA, 도구 사용 데이터로 파인튜닝
4. **평가** — CORE 벤치마크 자동 실행 (추론/지식/코딩/명령어 따르기 점수)
5. **추론 서버** — OpenAI chat completions 호환 HTTP API
6. **채팅 UI** — 훈련된 모델과 대화하는 미니멀 웹 인터페이스

약 8,000줄의 Python + Rust 코드.

## $100 훈련 비용

| 설정 | 시간당 비용 | 훈련 시간 | 총 비용 |
|------|-----------|---------|-------|
| 8× H100 (SXM5) | ~$24 | 2시간 | ~$48 |
| 8× A100 (80GB) | ~$16 | 4시간 | ~$64 |
| 8× H100 (PCIe) | ~$18 | 3시간 | ~$54 |

Lambda Labs, CoreWeave, vast.ai, RunPod에서 노드를 임대할 수 있습니다.

## 핵심 훈련 명령어

```bash
# 토크나이저 훈련
python tokenize_dataset.py --dataset fineweb --vocab-size 32768

# 8-GPU 사전학습
torchrun --nproc_per_node=8 train_pretrain.py \
  --config configs/pretrain_fineweb_120m.yaml

# 지도 파인튜닝
torchrun --nproc_per_node=8 train_sft.py \
  --pretrain-checkpoint checkpoints/pretrain_final.pt \
  --config configs/sft_smoltalk.yaml

# 추론 서버 실행
python serve.py --checkpoint checkpoints/sft_final.pt --port 8000
```

## 활용 대상

- **nanochat 사용**: LLM 원리를 코드로 이해하고 싶은 분; 수정 가능한 기준이 필요한 연구자; 자체 데이터로 도메인 특화 모델을 사전학습하고 싶은 분
- **Ollama 사용**: 기존 모델을 로컬에서 실행하기만 원하는 분 → [Ollama](/resources/llm-frameworks/ollama/)

## 2026년 신기능: autoresearch

2026년 3월 Karpathy가 발표한 [autoresearch](https://github.com/karpathy/autoresearch)는 AI 에이전트가 nanochat 훈련 실험을 자동으로 실행하고 결과를 보고하는 시스템입니다.

> **GPU 컴퓨팅이 필요하신가요?** [DigitalOcean 신규 사용자는 $200 크레딧을 받습니다](https://m.do.co/c/eca87ac14ee0) — 여러 번의 완전한 nanochat 훈련 실험을 실행하기에 충분합니다.

**GitHub:** [karpathy/nanochat](https://github.com/karpathy/nanochat) · 54.7k ⭐ · MIT
