---
title: 'Axolotl 2026: 12k 별 YAML 주도 LLM 파인튜닝 프레임워크 완전 가이드'
description: 'Axolotl은 단일 YAML 구성으로 full / LoRA / QLoRA / DPO / GRPO 커버하는 오픈소스 LLM 파인튜닝 프레임워크. 12k GitHub 별, Apache 2.0. Llama / Mistral / Qwen / GLM / 10+ 패밀리 지원. 2026 완전 설치 가이드 + Axolotl이 Unsloth와 원시 HuggingFace TRL을 이기는 때.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack: [Python, PyTorch, CUDA, YAML]
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/axolotl-ai-cloud/axolotl'
stars: 12000
maintainer: 'axolotl-ai-cloud'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Axolotl', '파인튜닝', 'LoRA', 'QLoRA', 'DPO', '오픈소스']
aliases:
  - /posts/axolotl-llm-fine-tuning-framework-2026/
---

Llama 모델 파인튜닝 시도하고 300줄 PyTorch + DeepSpeed config + Hugging Face Trainer 래퍼 작성한 적 있다면 **Axolotl**이 채우는 갭을 느낌. 한 YAML 파일이 전체 파인튜닝 실행 설명 — 모델, 데이터셋, LoRA config, 하이퍼파라미터, 분산 전략 — 그리고 Axolotl이 나머지 처리.

12k GitHub 별, Apache 2.0, 모든 주요 LLM 패밀리 지원 (Llama, Mistral, Mixtral, Qwen, GLM, GPT-OSS, HunYuan 등) 및 2026에 중요한 모든 파인튜닝 방법 (full, LoRA, QLoRA, GPTQ, QAT, DPO/IPO/KTO/ORPO 선호 튜닝, GRPO/GDPO 강화 학습, 보상 모델링).

대부분 프로덕션 파인튜닝 파이프라인이 Hugging Face TRL 벗어나지만 클로즈드 클라우드 플랫폼에 헌신하고 싶지 않을 때 정착하는 프레임워크.

## TL;DR

- **무엇**: YAML 주도 오픈소스 LLM 파인튜닝 프레임워크
- **GitHub**: 12k 별
- **License**: Apache 2.0 (상업 사용 안전)
- **모델**: Llama, Mistral, Mixtral, Qwen, GLM, GPT-OSS, HunYuan, Granite, Pythia, 등
- **방법**: Full / LoRA / QLoRA / GPTQ / QAT / DPO / IPO / KTO / ORPO / GRPO / GDPO / 보상 모델링
- **하드웨어**: NVIDIA Ampere+ 또는 AMD GPU, Python 3.11+, PyTorch ≥2.9.1

## 1. Axolotl 존재 이유 (해결 문제)

대체하는 3가지 일반 패턴:

1. **커스텀 HF Trainer 스크립트** — 실험당 300줄 보일러플레이트, 깨지기 쉬움, 프레임워크 버전 bump 안 견딤
2. **DeepSpeed config 고고학** — 모델 크기 + GPU에 어떤 조합 `zero_stage`, `offload_optimizer`, `gradient_checkpointing` 작동하는지 알아내기
3. **클라우드 파인튜닝 플랫폼** (Together, Fireworks 등) — 쉽지만 결과 가중치나 프로세스 소유 안 함

Axolotl은 "클라우드 플랫폼" UX (한 config 파일, 한 명령) 주면서 본인 소유 인프라에 두고 본인 통제 가중치 유지.

## 2. 하드웨어 현실

| 셋업 | 파인튜닝 가능 모델 |
|---|---|
| 24 GB GPU (RTX 4090 / 3090) | Llama 3.2 8B QLoRA, Mistral 7B QLoRA |
| 48 GB GPU (A6000) | Llama 3.2 8B LoRA, Mistral 7B full fine-tune |
| 80 GB GPU (A100 / H100) | Llama 3.3 70B QLoRA, Mistral 8x7B QLoRA |
| 2× 80 GB (2× H100) | Llama 3.3 70B LoRA, Mixtral full fine-tune |
| 8× H100 클러스터 | 프런티어급 full fine-tune |

클라우드 임대 옵션: Vast.ai에 H100 $1.50-2/시간, 또는 지속 워크로드용 {{< aff "digitalocean" "axolotl-gpu" "DigitalOcean GPU droplet" >}}. 데이터 준비 + 모니터링 측은 {{< aff "htstack" "axolotl-vps-hk" "HTStack 홍콩" >}}이 중국 친화 레이턴시 작동 (실제 훈련은 임대 GPU에 머무름).

## 3. 빠른 설치 (15분)

```bash
git clone https://github.com/axolotl-ai-cloud/axolotl
cd axolotl
pip install -e '.[flash-attn,deepspeed]'
```

최소 훈련 실행 — 샘플 데이터셋에 QLoRA로 Llama 3.2 8B 파인튜닝:

```yaml
# config.yml
base_model: meta-llama/Llama-3.2-8B
datasets:
  - path: tatsu-lab/alpaca
    type: alpaca
adapter: qlora
lora_r: 16
lora_alpha: 32
load_in_4bit: true
num_epochs: 3
output_dir: ./outputs/llama-alpaca
```

```bash
axolotl train config.yml
```

그게 다. 같은 YAML이 1 GPU, 8 GPU, 또는 멀티 노드에서 작동 — Axolotl이 accelerate/DeepSpeed 통해 자동 감지.

## 4. YAML 구성이 킬러 기능

YAML이 여기서 진짜 올바른 추상화인 이유:

- **Git 친화**: 모든 파인튜닝이 repo의 config 파일. 체크아웃으로 재현 가능
- **실험 매트릭스**: `yq` 치환 또는 W&B sweep 통한 파라미터 sweep. 복사-붙여넣기 50 스크립트 없음
- **팀 핸드오프**: ML 엔지니어 YAML 작성, ops 엔지니어 실행. 명확한 계약
- **자동 업그레이드**: Axolotl이 버전 간 config 하위 호환 유지, 6개월 전 실험도 여전히 실행

커스텀 스크립트와 비교: 모든 파인튜닝이 눈송이, 버전 bump가 깨뜨림, 팀 간 공유는 "여기 내 노트북 복사".

## 5. 파인튜닝 방법 치트 시트

| 방법 | 언제 사용 | VRAM (8B 모델) |
|---|---|---|
| **Full** fine-tune | 컴퓨트 많음, 최고 품질 원함 | ~80 GB |
| **LoRA** | 대부분 케이스, 비용/품질 균형 | ~24-32 GB |
| **QLoRA** | 저렴 실험, 빠듯 VRAM | ~12-16 GB |
| **GPTQ** | 이미 양자화된 모델, 추론 초점 | ~8 GB |
| **DPO** | 선호 데이터 (chosen/rejected 페어), RL 없이 정렬 | LoRA + ~30% |
| **GRPO** | 보상 신호 있는 진짜 RL, 수학/코드 도메인 | LoRA + ~50% |
| **KTO** | 바이너리 선호 (좋아요/싫어요), DPO보다 단순 | LoRA + ~30% |

2026 대부분 팀: 실험에 QLoRA, 프로덕션 배포에 LoRA, 정렬 실행에 DPO.

## 6. 실제 워크플로우

```
1. 데이터셋 준비 (JSONL, prompt/response 또는 messages 포맷)
   └─> 버전 관리 위해 HuggingFace Hub에 push

2. Axolotl config.yml 작성 (모델 + 데이터셋 + 방법 + 하이퍼파라미터)
   └─> git commit (이제 재현 가능)

3. GPU 인스턴스 띄우기 (Vast.ai / DigitalOcean / HTStack)
   └─> repo 클론, pip install Axolotl

4. axolotl preprocess config.yml (한 번 토큰화, 캐시)
   └─> 데이터셋 통계 예상과 일치 확인

5. axolotl train config.yml
   └─> W&B가 손실 곡선 로그. N epoch 훈련.

6. axolotl inference --base-model llama3-8b --lora ./outputs/lora
   └─> held-out prompt에 응답 정상 확인

7. LoRA + base 머지 → HuggingFace Hub에 push 또는 vLLM 통해 서빙
```

"30줄 YAML + 한 명령" 워크플로우가 파인튜닝을 연구 프로젝트에서 배포 가능 엔지니어링 실천으로 바꿈.

## 7. Axolotl vs Unsloth vs HuggingFace TRL

| 선택 | 언제 |
|---|---|
| **Axolotl** | 프로덕션 파인튜닝 파이프라인, 멀티 노드, 넓은 방법 지원 (DPO/GRPO/KTO/ORPO), YAML-config-as-code 워크플로우 |
| **Unsloth** | 단일 GPU, 2× 속도 + 70% VRAM 절감 원함, RL 파인튜닝 특별히. [Unsloth 심층 가이드](/kr/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/) 참조 |
| **HuggingFace TRL** | 저레벨 제어, 커스텀 루프, 연구 논문. 대부분 프로덕션 코드는 이제 Axolotl 또는 Unsloth 통해 TRL 래핑 |
| **Together / Fireworks / OpenAI 파인튜닝** | 인프라 소유 원하지 않음, 가중치 이식성 신경 안 씀, $$$ 프리미엄 가격 |

2026 기본 추천: **프로덕션 멀티 GPU에 Axolotl + 빠른 단일 GPU 실험에 Unsloth**. 보완적, 경쟁자 아님.

## 8. 프로덕션 팁

Axolotl 첫 사용자가 처음 부딪히는 5가지:

1. **Tokenizer pad token** — 많은 config가 `tokenizer.pad_token = eos_token` 누락. Axolotl 기본값이 알려진 모델 처리; 새 모델은 직접 verify
2. **`max_seq_length`와 OOM** — 작게 시작 (1024), OOM까지 올림, 그 후 10% 후퇴. 추측하지 마세요
3. **Flash Attention 컴파일 시간** — 첫 설치가 FA2 컴파일에 20-30분 걸릴 수 있음. 인내
4. **데이터셋 포맷 불일치** — `type` 필드가 데이터와 매치해야 함. `alpaca` ≠ `sharegpt` ≠ `chat_template`. 문서 읽기
5. **DeepSpeed ZeRO stage 혼동** — Stage 1 = offload 없음 (가장 빠름, 가장 많은 VRAM). Stage 2 = optimizer offload. Stage 3 = full param offload (가장 느림, 가장 적은 VRAM). VRAM 예산에 맞춤

## 9. Axolotl을 사용하지 *않을* 때

- **로컬 모델과 채팅만 원함** — 파인튜닝 불필요. 기본 instruct 모델로 [Ollama](/kr/resources/llm-frameworks/local-llm-runner-comparison-2026/)
- **작은 데이터셋 (< 1000 예제)** — Few-shot prompting이 파인튜닝 이길 가능성, 또는 RAG 사용 ([지식 베이스 스택](/kr/collections/knowledge-base-stack/) 참조)
- **이미 작업에서 기본 모델에 만족** — 파인튜닝 위해 파인튜닝하지 마세요. 비용 > 이익, 벤치마크 개선 증명 가능까지
- **노트북 GPU에서 <24시간 반복 사이클 필요** — Unsloth의 2× 속도와 70% VRAM 감소가 더 적합

## TL;DR

Axolotl = **YAML 주도 LLM 파인튜닝 프레임워크, 2026 프로덕션 멀티 GPU 기본**. 12k 별, Apache 2.0, 모든 주요 모델 패밀리 + 중요한 모든 파인튜닝 방법 지원. Unsloth (단일 GPU 속도)와 페어로 완전 실험-프로덕션 파인튜닝 파이프라인.

H100 인스턴스 띄우고, 3절의 20줄 YAML 작성하고, 15분 후 파인튜닝 실행 중.

---

*dibi8의 Fine-Tuning Stack 일부 — [빠른 단일 GPU 반복용 Unsloth](/kr/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/)와 페어. 전체 LLM ops 그림은 다가오는 Fine-Tuning Stack 컬렉션 참조.*
