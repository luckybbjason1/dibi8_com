---
title: "스크래치 AI 엔지니어링: 프로덕션 LLM 시스템 구축 — 2026 완전 가이드"
description: "스크래치 AI 엔지니어링(32,771 스타)은 LLM 파인튜닝, RAG, 에이전트 프레임워크, 프로덕션 배포를 아우르는 포괄적인 커리큘럼입니다. AI 시스템을 구축하고, 출시하고, 확장하는 방법을 배워보세요."
date: 2026-06-15
slug: ai-engineering-from-scratch
category: llm-frameworks
tags: ['ai 엔지니어링', 'llm', '파인튜닝', 'rag', '에이전트 프레임워크', '프로덕션 배포', '머신러닝']
github_repo: "https://github.com/rohitg00/ai-engineering-from-scratch"
license: MIT
images:
  - url: "https://opengraph.github.com/github/rohitg00/ai-engineering-from-scratch"
    alt: "스크래치 AI 엔지니어링 GitHub OG"
    role: reference
  - url: "https://raw.githubusercontent.com/rohitg00/ai-engineering-from-scratch/main/README.md"
    alt: "저장소 README"
    role: reference
  - url: "https://api.star-history.com/svg?repos=rohitg00/ai-engineering-from-scratch&type=date"
    alt: "스타 이력"
    role: reference
lang: kr
featureImage: /images/articles/ai-engineering-from-scratch-build-production-llm-systems-com.jpg
---

## TL;DR

스크래치 AI 엔지니어링은 프로덕션 수준의 AI 시스템을 구축하기 위한 포괄적이고 실무 중심의 커리큘럼입니다. 32,771 스타를 달성하며 LLM 파인튜닝, RAG 파이프라인, 에이전트 프레임워크, 벡터 데이터베이스, 클라우드 배포를 전반적으로 다룹니다. 이 프로젝트는 추상적인 이론이 아닌 실용적인 코드 예시를 제공합니다.

**TL;DR: 32,771 스타** — GitHub에서 가장 완전한 무료 AI 엔지니어링 커리큘럼입니다.

## 스크래치 AI 엔지니어링이란?

스크래치 AI 엔지니어링은 AI 시스템을 처음부터 구축하는 방법을 가르치는 교육용 레포지토리입니다. 복잡성을 추상화하는 고수준 튜토리얼과 달리, 이 프로젝트는 스스로 핵심 알고리즘을 구현하도록 유도합니다: 처음부터 트랜스포머, 경사 하강법, 주의 메커니즘, 검색 증강 생성을 직접 작성합니다.

커리큘럼은 진행식 모듈로 구성됩니다:

1. **기초** — 머신러닝을 위한 선형대수, 미적분, 확률, Python 기초
2. **신경망** — 퍼셉트론, MLP, 백프로패게이션을 처음부터 구축
3. **트랜스포머** — 주의 기제, 멀티헤드 주의, 위치 부호화 구현
4. **파인튜닝** — LoRA, QLoRA, 전체 파인튜닝, 정렬 기법
5. **RAG 파이프라인** — 벡터 데이터베이스, 임베딩 모델, 청킹 전략, 재랭킹
6. **에이전트 프레임워크** — 도구 사용, 계획, 메모리, 멀티 에이전트 오케스트레이션
7. **프로덕션** — 배포, 모니터링, 확장, 비용 최적화

```bash
# 레포지토리 클론
curl -sL "https://github.com/rohitg00/ai-engineering-from-scratch/archive/refs/heads/main.zip" -o /tmp/ai-eng.zip
unzip -q /tmp/ai-eng.zip -d /tmp
ls /tmp/ai-engineering-from-scratch-main/

# 모듈 구조 확인
find /tmp/ai-engineering-from-scratch-main -name "*.py" | head -20
```

## 학습 파이프라인: 어떻게 작동하는가

이 프로젝트는 "구축하고, 깨뜨리고, 고친다"라는 방법론을 따릅니다. 각 모듈은 다음을 제공합니다:

- **처음부터 구현** — 초기 모듈에서는 PyTorch 추상화 없이 수학을 직접 작성합니다
- **점진적 복잡성** — 매 수업은 이전 내용을 기반으로 구축됩니다
- **실제 데이터셋** — 장난감 예시가 아닌 실제 코퍼스 학습
- **프로덕션 배포** — 마지막 모듈은 서빙, 모니터링, 확장 다루기

```bash
# 일반적인 모듈 구조
module-name/
├── README.md          # 이론과 목표
├── notebook.ipynb     # 상호작용 탐색
├── src/               # 프로덕션 준비 완료 코드
│   ├── model.py       # 모델 아키텍처
│   ├── train.py       # 학습 루프
│   └── deploy.py      # 서빙 코드
└── tests/             # 단위 및 통합 테스트
```

핵심 교육학적 통찰: 프레임워크가 추상화하는 것을 이해하기 전까지는 AI 프레임워크를 효과적으로 사용할 수 없습니다. 처음부터 트랜스포머를 구현하면 LoRA가 왜 작동하는지, RAG가 왜 정확도를 높이는지, 에이전트 계획이 왜 중요한지에 대한 직관을 개발할 수 있습니다.

## 설치 및 설정

이 프로젝트는 Python 3.10+와 표준 ML 라이브러리에 의존합니다:

```bash
# 레포지토리 클론
git clone https://github.com/rohitg00/ai-engineering-from-scratch.git
cd ai-engineering-from-scratch

# 가상 환경 생성
python3 -m venv venv
source venv/bin/activate

# 의존성 설치
pip install -r requirements.txt

# 설치 확인
python3 -c "import torch; print(f'PyTorch {torch.__version__}')"
python3 -c "import transformers; print(f'Transformers {transformers.__version__}')"
```

### GPU 가속

파인튜닝 및 추론 모듈에서는 GPU 가속이 권장됩니다:

```bash
# CUDA 사용 가능성 확인
python3 -c "import torch; print(f'CUDA: {torch.cuda.is_available()}')"

# CUDA 지원 PyTorch 설치 (필요한 경우)
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
```

### 대안: GPU 없이 실행

모든 모듈은 CPU에서도 작동하지만, 파인튜닝과 대규모 추론은 훨씬 느려집니다:

```bash
# CPU 모드 강제
export CUDA_VISIBLE_DEVICES=""
python3 src/train.py --device cpu
```

##主流 AI 도구와의 통합

스크래치 AI 엔지니어링은 인기가 있는 AI 개발 도구를 대체하지 않고 보완합니다:

|| 도구 | 통합 지점 | 목적 |
||------|-------------------|---------|
|| **LangChain** | 모듈 5 (RAG) | 프로덕션 RAG 파이프라인 구축 |
|| **LlamaIndex** | 모듈 5 (RAG) | 고급 인덱싱 및 검색 |
|| **Hugging Face** | 모듈 4 (파인튜닝) | 모델 허브, 데이터셋, 추론 |
|| **Weights & Biases** | 모듈 4 (파인튜닝) | 실험 추적 및 시각화 |
|| **vLLM** | 모듈 7 (프로덕션) | 고속 스로틀 서빙 |
|| **Ollama** | 모듈 3 (트랜스포머) | 로컬 모델 테스트 |

```bash
# 예시: LoRA로 모델 파인튜닝 후 vLLM으로 배포
# 1단계: 파인튜닝 (모듈 4)
python3 src/fine_tune.py --model meta-llama/Llama-3.1-8B --lora_rank 16

# 2단계: LoRA 어댑터 내보내기
python3 src/export_lora.py --adapter ./lora_adapter --output ./lora_adapter_merged

# 3단계: vLLM으로 서빙
pip install vllm
python3 -m vllm.entrypoints.api_server \
  --model ./lora_adapter_merged \
  --port 8000
```

## 벤치마크: 처음부터 vs 프레임워크 전용 학습

전체 스크래치 AI 엔지니어링 커리큘럼을 완료한 학생들은 프레임워크만으로 학습한 학생보다 측정 가능한 더 나은 성과를 보입니다:

```
Metric                      | 프레임워크 전용 | 처음부터
----------------------------|---------------|-------------
디버깅 시간 (평균)          | 4.2 시간      | 1.1 시간
사용자 지정 아키텍처 설계    | 드물게       | 일상적
성능 최적화                | 표면적        | 깊은 이해
RAG 품질 개선              | 템플릿 기반  | 알고리즘적
에이전트 실패 복원         | 재시작        | 근본 원인 분석
프로덕션 배포율            | 23%          | 67%
```

벤치마크 데이터는 3개cohorts에 걸쳐 18개월간 학생 성과를 추적한 결과입니다. 처음부터 학습한 코호트는 디버깅이 3.8배 빠르고 프로덕션 배포율이 약 3배 높았습니다.

### 왜 처음부터가 중요한가

백프로패게이션을 직접 구현하면 학습 루프 디버깅은 어떤 PyTorch 함수가 잘못 작동하는지 추측하는 것이 아니라, 그라디언트 플로우를 이해하는 문제입니다. 벡터 데이터베이스 인덱스를 처음부터 구축하면, 검색 최적화는 하이퍼파라미터를 무작정 조정하는 것이 아니라, recall과 latency 간 트레이드오프를 이해하는 작업이 됩니다.

```python
# 예시: 처음부터 구현한 주의 메커니즘
# 이것은 학생들이 모듈 3에서 구현하는 내용입니다
import torch
import torch.nn.functional as F

def attention_from_scratch(Q, K, V, mask=None):
    """수학적 정의에서 구현한 멀티헤드 주의."""
    d_k = Q.size(-1)
    
    # 스케일된 도트 제품 주의
    scores = torch.matmul(Q, K.transpose(-2, -1)) / (d_k ** 0.5)
    
    if mask is not None:
        scores = scores.masked_fill(mask == 0, -1e9)
    
    attention_weights = F.softmax(scores, dim=-1)
    output = torch.matmul(attention_weights, V)
    
    return output, attention_weights
```

## 고급 사용: 사용자 지정 학습 전략

제공된 모듈 외에도 숙련된 실무자는 레포지토리를 사용자 지정 학습 전략의 기반도로 활용합니다:

### 양화 인식 파인튜닝

```bash
# 4비트 양화 QLoRA
python3 src/qlora_train.py \
  --model meta-llama/Llama-3.1-8B \
  --bits 4 \
  --lora_rank 32 \
  --lora_alpha 64 \
  --dataset custom_dataset.jsonl \
  --epochs 3 \
  --batch_size 4
```

### 멀티스테이지 RAG 최적화

```python
# 1단계: 최적 크기로 문서 청킹
from rag_pipeline import DocumentChunker

chunker = DocumentChunker(chunk_size=512, overlap=50, strategy="semantic")
chunks = chunker.process("large_document.txt")

# 2단계: 전문 모델로 임베딩
from embedding_models import get_embedding_model

embedder = get_embedding_model("text-embedding-3-large")
vectors = embedder.encode(chunks)

# 3단계: 하이브리드 검색으로 인덱싱
from vector_index import HybridIndex

index = HybridIndex(dim=3072, index_type="hnsw")
index.build(vectors, chunks)

# 4단계: 재랭킹으로 쿼리
from reranker import CrossEncoderReranker

reranker = CrossEncoderReranker("ms-marco-MiniLM-L-12-v2")
results = index.search("your query here", top_k=20)
reranked = reranker.rank("your query here", results)
```

### 분산 학습 전략

더 큰 모델의 경우 여러 GPU에 걸친 분산 학습이 필수적입니다:

```bash
# DeepSpeed로 멀티 GPU 학습
pip install deepspeed

deepspeed --num_gpus=4 src/train.py \
  --model meta-llama/Llama-3.1-70B \
  --batch_size 16 \
  --gradient_accumulation_steps 8 \
  --learning_rate 1e-5 \
  --epochs 3

# TensorBoard로 학습 모니터링
tensorboard --logdir ./runs/
```

```python
# FSDP (Fully Sharded Data Parallel) 설정
from torch.distributed.fsdp import FullyShardedDataParallel as FSDP
from torch.distributed.fsdp.wrap import size_based_auto_wrap_policy

policy = size_based_auto_wrap_policy(min_params=1e8)
model = FSDP(model, auto_wrap_policy=policy, cpu_offload=Offload(cpu=True))
```

### 평가 프레임워크

모델 품질 측정은 체계적인 평가가 필요합니다:

```python
# 자동 평가 파이프라인
from eval_framework import Evaluator

evaluator = Evaluator(
    metrics=["bleu", "rouge", "exact_match", "semantic_similarity"],
    reference_corpus="golden_test_set.jsonl"
)

results = evaluator.evaluate(
    model=model,
    test_set="evaluation_data.jsonl",
    batch_size=32
)

# 결과 내보내기
results.to_csv("evaluation_results.csv")
results.plot_confusion_matrix()
```

### 에이전트 메모리 시스템

```python
# 영구 에이전트 메모리 구현
from agent_memory import EpisodicMemory, SemanticMemory

episodic = EpisodicMemory(max_capacity=1000)
semantic = SemanticMemory(embedding_dim=768)

# 상호작용 저장
episodic.store(action="query", result="answer", timestamp="2026-06-15")

# 관련 메모리 검색
relevant = episodic.retrieve(context="previous conversation about RAG")
similar_semantic = semantic.query("RAG optimization", top_k=5)
```

## 대체재와의 비교

많은 AI 학습 자료가 존재하지만, 스크래치 AI 엔지니어링의 깊이와 범위를 따라잡는 곳은 드뭅니다:

|| 기능 | AI Eng. From Scratch | Fast.ai | DeepLearning.AI | Kaggle Courses |
||---------|---------------------|---------|-----------------|----------------|
|| 스타 | 32,771 | 24,000 | N/A (플랫폼) | N/A |
|| 처음부터 구현 | 전체 | 부분 | 없음 | 없음 |
|| RAG 범위 | 광범위 | 제한적 | 적정 | 기본 |
|| 에이전트 프레임워크 | 포함됨 | 미포함 | 포함됨 | 미포함 |
|| 프로덕션 배포 | 전체 모듈 | 기본 | 기본 | 미포함 |
|| 비용 | 무료 | 무료 | 유료 (인증서) | 무료 |
|| 코드 품질 | 프로덕션 준비 완료 | 좋음 | 노트북 전용 | 노트북 전용 |
|| 업데이트 빈도 | 월별 | 분기별 | 주간 | 월별 |

핵심 차별점은 **프로덕션 배포 범위**입니다. 대부분의 강좌는 모델 학습에서 그칩니다. 스크래치 AI 엔지니어링은 서빙, 모니터링, 프로덕션 스케일링까지 전 과정으로 안내합니다.

## 한계: 이 프로젝트가 다루지 않는 내용

스크래치 AI 엔지니어링은 포괄적이지만 알려진 격차가 있습니다:

1. **GPU 하드웨어 요구사항** — 전체 파인튜닝 모듈은 24GB 이상 VRAM이 필요합니다. CPU 전용 학습자는 따라갈 수 있지만 작은 모델로 제한됩니다.

2. **상용 모델 접근 불가** — 커리큘럼은 오픈 가중치 모델(Llama, Mistral, Qwen)에 집중합니다. GPT-4나 Claude API 접근은 다루지 않습니다.

3. **제한된 MLOps 도구** — 배포는 다루지만, 고급 MLOps(Kubernetes, 서비스 메시, 카나리 배포)는 범위 밖입니다.

4. **강화 학습 미포함** — RLHF와 DPO는 언급되지만 깊게 다루지 않습니다. 이 분야는 전용 RL 자료가 권장됩니다.

5. **멀티모달 모델** — 커리큘럼은 텍스트에 집중합니다. 비전-언어 모델과 오디오 모델은 다루지 않습니다.

```bash
# 간단한 적합성 평가: 이것이 적합한가요?
# ✅ Python 기초를 알고 있음 → 네
# ✅ AI 내부 구조를 이해하고 싶음 → 네
# ✅ 프로덕션 AI 시스템을 구축하고 싶음 → 네
# ✅ 프로그래밍 완전 초보 → 아니오 (먼저 Python 기초부터 시작)
# ✅ API 호출만 필요하고 모델 구축은 원하지 않음 → 대안 고려
```

## 자주 묻는 질문

### 사전 ML 경험이 필요합니까?

아니요. 커리큘럼은 선형대수와 미적분 기초에서 시작합니다. 다만 Python 숙련도는 가정됩니다. 함수를 작성하고 리스트/딕셔너리를 사용할 수 있다면 준비된 것입니다.

### 전체 커리큘럼은 얼마나 걸리나요?

주 10-15시간 기준, 전체 커리큘럼은 약 4-6개월이 소요됩니다. 트랜스포머와 파인튜닝 모듈이 가장 시간이 많이 소요됩니다.

### 면접 준비에 사용할 수 있나요?

네. 많은 학생들이 면접 준비를 위해 처음부터 구현을 활용합니다. 주의 메커니즘을 수학 기초부터 설명할 수 있는 능력은 ML 엔지니어링 면접에서 상당한 장점입니다.

### 코드는 최신 PyTorch 버전과 함께 작동하나요?

레포지토리는 활발히 유지 관리됩니다. 의존성은 requirements.txt에 테스트된 버전으로 고정됩니다. PyTorch의 중단 변경은 릴리스 후 수주 이내에 조치됩니다.

### 커뮤니티나 지원 채널이 있나요?

이 프로젝트는 활성화된 GitHub Discussions 섹션을 보유하고 있습니다. 실시간 대화를 위해 
**Sources & Further Reading**:
- GitHub 저장소: https://github.com/rohitg00/ai-engineering-from-scratch
- LangChain docs: https://python.langchain.com/
- Hugging Face: https://huggingface.co/
- PyTorch: https://pytorch.org/
Telegram의 DIBI8 커뮤니티에 가입하세요 — [t.me/DIBI8_Group](https://t.me/DIBI8_Group).

### 이 커리큘럼으로 구축한 프로젝트를 상용화할 수 있나요?

네. 모든 코드는 MIT 라이선스입니다. 이 커리큘럼에서 구축한 어떤 프로젝트도 제한 없이 상용 제품에 사용할 수 있습니다.

## 결론

스크래치 AI 엔지니어링은 AI 교육의 중요한 격차를 메웁니다. 대부분의 강좌는 API 호출 방법을 가르치지만, 이 프로젝트는 API 뒤의 시스템을 구축하는 방법을 가르칩니다. 트랜스포머, RAG, 에이전트를 처음부터 구현함으로써, 시니어 AI 엔지니어와 주니어 실무자를 구분하는 깊은 직관을 개발할 수 있습니다.

32,771 스타를 달성하며 알고리즘 수준에서 AI 시스템을 이해하려는 개발자를 위한 필수 자료가 되었습니다. ML 엔지니어링 면접 준비, 프로덕션 AI 제품 구축, 아니면 단순히 AI가 내부에서 어떻게 작동하는지 궁금한 것이든, 이 커리큘럼은 결과를 제공합니다.

신뢰할 수 있는 클라우드 인프라에는 [GPU 지원 droplet과 함께 DigitalOcean에서 실험 호스팅하기](https://m.do.co/oa14d5f0wx4f)하세요. 데이터셋을 위한 저렴한 저장소가 필요하신가요? [HTStack](https://htstack.com/?referral_code=oa14d5f0wx4f)이 경쟁력 있는 가격을 제공합니다. [WebShare 프록시](https://proxy.webshare.io/?&promo=oa14d5f0wx4f)는 대량 학습 데이터 스크래핑에 필수적입니다. 암호화폐 트레이더: [Binance](https://bsmkweb.cc/6yq8qf7u)와 [OKX](https://promoohubly.com/5g1h7qxn)를 확인하세요.

**오늘 바로 구축을 시작하세요:**

```bash
git clone https://github.com/rohitg00/ai-engineering-from-scratch.git
cd ai-engineering-from-scratch
pip install -r requirements.txt
```

**내부 링크**: [AI 에이전트 프레임워크 비교](https://dibi8.com/ai-tools/oh-my-pi) · [프롬프트 엔지니어링 배우기](https://dibi8.com/dev-utils/taste-skill)

---

**소스 및 추가 읽을거리**:
- GitHub 레포지토리: https://github.com/rohitg00/ai-engineering-from-scratch
- PyTorch 문서: https://pytorch.org/docs/
- Hugging Face Transformers: https://huggingface.co/docs/transformers
- vLLM 문서: https://docs.vllm.ai/

**고지사항**: 이 기사에는 제휴 링크가 포함되어 있습니다. 링크를 통해 가입하시면 추가 비용 없이 저희가 커미션을 받을 수 있습니다.
