---
title: 'Fine-Tuning Stack 2026: 데이터셋에서 프로덕션 배포 LLM까지 5컴포넌트 파이프라인'
description: '완전한 LLM 파인튜닝 스택: Unsloth (빠른 단일 GPU 실험) + Axolotl (프로덕션 멀티 GPU) + HuggingFace datasets/Hub + Weights & Biases (eval 추적) + vLLM (서빙). $50-300/월 훈련 인프라. 전체 파이프라인: 데이터셋 준비 → 실험 → 프로덕션 파인튜닝 → eval → 배포.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack: [Python, PyTorch, CUDA, YAML]
application_domain: Collections
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
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['collections']
tags: ['Fine-Tuning', 'LLM', '스택', '컬렉션']
aliases:
  - /posts/fine-tuning-stack/
---

2026년 LLM 파인튜닝이 마침내 일관된 스택을 가짐 — HuggingFace Trainer + DeepSpeed config + 커스텀 eval 스크립트를 덕테이프로 붙이는 날들은 끝. 이 컬렉션은 원시 데이터셋에서 프로덕션 배포 파인튜닝 모델까지 **5컴포넌트 파이프라인** 조립, 빠른 반복 (Unsloth)과 프로덕션 배포 (Axolotl) 사이 깔끔한 분할. 스케일에 따라 $50-300/월 훈련 인프라.

도메인 특화 모델 구축, 오픈 웨이트 베이스 모델 instruction-tuning, DPO/GRPO 정렬, 또는 프로덕션 파인튜닝 파이프라인 실행 중이라면 — 이 스택.

## TL;DR — 한눈에 보는 스택

| # | 컴포넌트 | 단계 | 역할 | 심층 가이드 |
|---|---|---|---|---|
| 1 | **Unsloth** | 실험 | 빠른 단일 GPU 파인튜닝, 2× 속도 + 70% 적은 VRAM | [Unsloth 2026 가이드](/kr/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/) |
| 2 | **Axolotl** | 프로덕션 | YAML 주도 멀티 GPU 프로덕션 파인튜닝 | [Axolotl 2026 가이드](/kr/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/) |
| 3 | **HuggingFace datasets + Hub** | 데이터 | 데이터셋 버전, 팀과 공유, 훈련 가중치 push | [HF docs] |
| 4 | **Weights & Biases** (또는 대안) | Eval | 손실 곡선, eval 점수, 하이퍼파라미터 sweep 추적 | [W&B docs] |
| 5 | **vLLM** | 서빙 | 파인튜닝 모델 프로덕션 멀티테넌트 서빙 | [로컬 LLM 러너 비교](/kr/resources/llm-frameworks/local-llm-runner-comparison-2026/) |

**월 총 비용** (훈련 자본 제외):
- **취미** (주당 GPU 10시간 임대): **$30-60/월**
- **프로덕션 팀** (전용 GPU 1-2 + 모니터링): **$200-400/월**
- **작은 AI 랩** (8× H100 클러스터): **$2000-5000/월**

매니지드 파인튜닝 플랫폼 비교: Together 파인튜닝 ~$0.50/M 토큰 (큰 데이터셋엔 빠르게 쌓임), OpenAI 파인튜닝 $25/M 토큰 (스케일에서 미친). 셀프호스트가 의미 있는 볼륨에서 둘 다 이김 + 가중치 소유.

## 1. 왜 2026에 "파인튜닝 스택" 정의 필요했나

스택 결정화한 3 변화:

1. **Unsloth + Axolotl이 프로덕션 성숙 도달** — "빠른 실험 + 스케일 프로덕션" 분할이 이제 깔끔
2. **GRPO가 기본 RL 파인튜닝됨** (DeepSeek-R1 이후) — 둘 다 네이티브 지원
3. **오픈 웨이트 베이스 모델이 GPT-4 클래스 도달** — Llama 3.3 70B, Qwen 3 32B, DeepSeek V3. 이들을 도메인용으로 파인튜닝이 이제 클로즈드 대안과 진짜 경쟁력

결과: 파인튜닝이 연구 → 엔지니어링 실천으로 이동. 스택이 그것을 반영.

## 2. 아키텍처 — 실험-프로덕션 파이프라인

```
   ┌──────────────────────────────────────────────────┐
   │ 데이터셋 (JSONL: prompt/response 또는 messages)  │
   │  → HuggingFace datasets 라이브러리               │
   │  → HuggingFace Hub에 push (버전 관리)             │
   └────────────────┬─────────────────────────────────┘
                    │
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ 실험 단계 (단일 GPU, 빠른 반복)                  │
   │  → 임대 RTX 4090 / H100에 Unsloth                 │
   │  → 50+ 짧은 QLoRA 실행으로 위닝 레시피 발견      │
   │  → W&B가 손실 곡선 + eval 점수 로그              │
   └────────────────┬─────────────────────────────────┘
                    │ (위닝 레시피 식별)
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ 프로덕션 단계 (멀티 GPU, 장시간 훈련)            │
   │  → Axolotl YAML config (git 추적)                │
   │  → 8× H100 클러스터로 full / 긴 컨텍스트 파인튜닝│
   │  → W&B가 최종 eval 로그                          │
   └────────────────┬─────────────────────────────────┘
                    │
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ 배포 단계                                         │
   │  → LoRA + base 가중치 머지                       │
   │  → 머지된 모델 HuggingFace Hub에 push            │
   │  → LiteLLM 게이트웨이 뒤 vLLM이 모델 서빙        │
   └──────────────────────────────────────────────────┘
```

분할이 이걸 작동시키는 것 — Unsloth의 빠른 반복은 "무엇이 작동하는가" 탐색, Axolotl의 견고함은 "이제 스케일" 프로덕션 실행.

## 3. 컴포넌트 1 — Unsloth (실험 단계)

**역할**: 파인튜닝 시간의 80% 보내는 곳. 데이터셋 포맷, 하이퍼파라미터, 베이스 모델 선택 반복. 각 실험 사이클: 단일 임대 GPU에 30분 - 3시간.

**Unsloth가 여기서 이기는 이유**: HF TRL보다 2× 빠름 = 달러당 2× 실험. 70% 적은 VRAM = A100 필요 대신 $1500 RTX 4090에서 실험. [Unsloth 심층 가이드](/kr/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/) 참조.

**빠른 설치**:
```bash
pip install unsloth
```

**패턴**: Vast.ai에 RTX 4090 임대 ($0.40-0.60/시간) 또는 RunPod, 주말에 10-20 실험 실행, 위닝 레시피 발견, 팀 리뷰용 노트북에 캡처.

## 4. 컴포넌트 2 — Axolotl (프로덕션 단계)

**역할**: 위닝 레시피 발견하면 스케일 업 — full 파인튜닝, 더 긴 컨텍스트, 멀티 epoch, 멀티 GPU. Axolotl 사용 YAML config는 git 추적 가능, ops 핸드오프 친화.

**Axolotl이 여기서 이기는 이유**: 박스 밖에서 작동하는 멀티 노드 분산 훈련, 가장 넓은 방법 지원 (DPO/GRPO/KTO/ORPO/GDPO), 재현성용 config-as-code. [Axolotl 심층 가이드](/kr/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/) 참조.

**빠른 설치**:
```bash
pip install axolotl
```

**패턴**: Unsloth 위닝 레시피에서 하이퍼파라미터 가져옴 → Axolotl YAML 작성 → 8× H100 클러스터에서 실행 (Vast.ai ~$15-25/시간)으로 최종 6-12시간 프로덕션 실행 → 최종 가중치 HF Hub에 push.

## 5. 컴포넌트 3 — HuggingFace Datasets + Hub (데이터 레이어)

**역할**: 데이터셋 버전. 팀 간 데이터셋 공유. 협업 테스트용 훈련 모델 가중치 push.

**왜 명백한 픽인가**: HF가 AI 데이터셋 배포 레이어 이김 (코드의 GitHub처럼, 모델 + 데이터셋의 HF Hub). 모든 파인튜닝 도구가 네이티브 통합.

**빠른 설치**:
```bash
pip install datasets
huggingface-cli login
```

**패턴**:
```python
from datasets import load_dataset, Dataset

# 로컬 준비 + push
data = Dataset.from_json("my_data.jsonl")
data.push_to_hub("yourname/my-finetune-dataset", private=True)

# 팀원 로드
data = load_dataset("yourname/my-finetune-dataset")
```

민감한 데이터 (의료 / 금융 / 독점)는 HF Hub의 **프라이빗 데이터셋** — 액세스 제어됨.

## 6. 컴포넌트 4 — Weights & Biases (Eval 추적)

**역할**: 위닝 레시피 찾기 위해 50 실험 실행할 때 비교 방법 필요. W&B가 사실상 선택 — 손실 곡선, eval 점수, 하이퍼파라미터, 하드웨어 활용 자동 로그.

**빠른 설치** (env var 통해 Unsloth와 Axolotl 모두 작동):
```bash
pip install wandb
wandb login
export WANDB_PROJECT="my-finetune-project"
```

이제 모든 Unsloth / Axolotl 훈련 실행이 W&B 대시보드에 자동 로그.

**비용**: W&B 무료 티어 관대 (단일 사용자, 무제한 공개 프로젝트). 팀 / 프라이빗 프로젝트: $50/사용자/월. 대안: **MLflow** (셀프호스트, 무료, 덜 정돈), **TensorBoard** (기본이지만 무료 + 로컬).

## 7. 컴포넌트 5 — vLLM (서빙 단계)

**역할**: 모델 파인튜닝했으면 사용자에게 서빙. vLLM이 프로덕션 멀티테넌트 서빙 선택 — PagedAttention + continuous batching이 처리량 챔피언으로 만듦.

vLLM이 프로덕션 멀티 사용자 서빙에서 Ollama / LM Studio / llama.cpp 이기는 이유 전체는 [로컬 LLM 러너 비교](/kr/resources/llm-frameworks/local-llm-runner-comparison-2026/) 참조.

**빠른 설치 + 파인튜닝 모델 서브**:
```bash
pip install vllm
vllm serve yourname/my-finetuned-llama \
  --enable-lora \
  --lora-modules my-lora=path/to/lora_weights \
  --port 8000
```

[LiteLLM 게이트웨이](/kr/resources/llm-frameworks/litellm/) 뒤에서 auth + rate limiting + 고객별 가상 키 = 본인 소유 인프라의 프로덕션 준비 멀티테넌트 LLM API.

## 8. Day 1 파이프라인 셋업 (3-4시간)

1. **JSONL 포맷 데이터셋** (다양함) — `train.jsonl`과 `eval.jsonl` 준비, HF Hub 프라이빗에 push
2. **RTX 4090 GPU 임대** (10분) — 실험 단계용 Vast.ai 또는 {{< aff "digitalocean" "ftstack-experiment-gpu" "DigitalOcean GPU droplet" >}}
3. **Unsloth + W&B 설치** (10분) — `pip install unsloth wandb`
4. **첫 QLoRA 실행** (60분) — Unsloth 가이드 3절, Llama 3.2 8B 1 epoch 파인튜닝, W&B 로그 나타남 확인
5. **5-10 짧은 실험 반복** (~반나절) — 학습률, LoRA rank, 데이터셋 슬라이스 변경. 최고 eval 점수 레시피 찾기
6. **레시피를 Axolotl YAML로 번역** (30분) — 같은 하이퍼파라미터 YAML 포맷, git commit
7. **8× H100 클러스터 임대** 프로덕션 실행용 (Vast.ai ~$15-20/시간 × 6-12시간 = $90-240), 데이터 + 모니터링 측은 {{< aff "htstack" "ftstack-prod-vps" "HTStack 홍콩 VPS" >}}
8. **Axolotl 프로덕션 훈련 실행** — 최종 가중치 HF Hub에 push
9. **vLLM 통해 배포** — 전용 24 GB GPU + LiteLLM 게이트웨이에서 파인튜닝 모델 서빙
10. **베이스 모델 대비 eval** — 파인튜닝이 실제로 eval 셋에서 베이스 이김? 아니면 반복

3-4시간 셋업 + 1-2주 실험 후, 본인의 파인튜닝 모델을 프로덕션에 배포.

## 9. 비용 분석

| 항목 | 취미 | 프로덕션 팀 | 작은 AI 랩 |
|---|---|---|---|
| 실험 GPU (필요 시 임대) | $30-60/월 | $100-200/월 | $300-500/월 |
| 프로덕션 훈련 (실행 시 임대) | $0-50/월 | $200-400/월 | $1500-3000/월 |
| 전용 서빙 GPU (vLLM) | $0 (Ollama 대신 사용) | $200/월 (RTX 4090) | $1000/월 (H100) |
| HF Hub | $0 (공개 + 1 GB까지 프라이빗 무료) | $9/월 (Pro) | $20/사용자/월 (엔터프라이즈) |
| W&B | $0 (무료 티어) | $50/사용자/월 | $50/사용자/월 |
| 기타 스토리지 / 대역폭 | $5 | $20 | $50 |
| **합계** | **~$35-115/월** | **~$580-880/월** | **~$2870-4570/월** |

매니지드 비교: Together 파인튜닝 $0.50/M 토큰 × 100M 토큰 데이터셋 = 파인튜닝 실행당 $50 × 10 실험 = 실험만 $500/월. 셀프호스트가 월 ~10 파인튜닝 이상에서 이김.

## 10. 업그레이드 경로

이 스택 벗어날 때:

- **70B 모델 일상 파인튜닝 필요** — 임대 대신 H100 클러스터 구매 또는 장기 임대
- **컴플라이언스 / 데이터 거주성** — Vast.ai에서 관할의 전용 베어 메탈로 이동
- **멀티테넌트 파인튜닝 SaaS** — 사용자 격리 레이어 추가; LangSmith 또는 유사 매니지드 eval 고려
- **연속 파인튜닝 루프** — 프로덕션 모델 저하 시 자동 재훈련 트리거용 [AI 에이전트 도구 체인](/kr/collections/ai-agent-tool-chain/)과 페어
- **도메인 특화 RL** — 보상 모델링 + GRPO 루프 추가 (둘 다 지원; 그냥 더 컴퓨트 헝그리)

## TL;DR — 레시피

**프로덕션 LLM 파인튜닝용 5 컴포넌트, 취미부터 프로덕션 팀까지 $50-300/월**:
1. **Unsloth** — 빠른 단일 GPU 실험 단계
2. **Axolotl** — 프로덕션 멀티 GPU 단계
3. **HuggingFace datasets + Hub** — 데이터 버전 관리 + 모델 배포
4. **Weights & Biases** — eval 추적
5. **vLLM** — 프로덕션 서빙

실험용 {{< aff "digitalocean" "footer-cta" "GPU droplet" >}} 임대, 프로덕션 실행은 Vast.ai 8× H100으로 스케일, 최종 모델 전용 24 GB GPU에 배포. 엔드 투 엔드 셀프호스트, 가중치 본인 소유, 진지함에 따라 스케일 비용.

---

*동반 컬렉션: [저렴한 LLM 스택](/kr/collections/cheap-llm-stack/) 배포 후 추론 비용 측 커버. [AI 에이전트 도구 체인](/kr/collections/ai-agent-tool-chain/) 자동 파인튜닝 루프. [지식 베이스 스택](/kr/collections/knowledge-base-stack/) 일부 케이스에서 RAG가 파인튜닝 대안.*
