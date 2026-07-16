---
title: Modal 서버리스 GPU 컴퓨팅 — 인프라 없이 ML 파이프라인 실행
description: Modal 서버리스 GPU 인프라 완전 가이드. 클러스터 관리 없이 LLM 추론, 파인튜닝 파이프라인, 배치 ML 워크로드 배포. 가격, 벤치마크, 실제 패턴 비교.
tags: ['serverless', 'gpu', 'machine-learning', 'inference', 'llm', 'cloud-compute']
category: llm-frameworks
featureImage: /images/articles/modal-serverless-gpu-compute.jpg
date: 2026-07-15T00:00:00+00:00
draft: false
slug: modal-serverless-gpu-compute
lang: ko
---

## TL;DR

Modal은 인프라를 관리하지 않고도 GPU 가속 워크로드를 실행할 수 있는 Python 네이티브 서버리스 컴퓨팅 플랫폼입니다. 표준 Python 함수를 작성하고 `@modal.enter()` 및 `@modal.function()`으로 데코레이터하면 Modal이 컨테이너 프로비저닝, GPU 할당, 네트워킹 및 스케일링을 처리합니다. LLM 추론 엔드포인트, 파인튜닝 작업, 배치 ML 파이프라인에 완벽합니다.

---

## Modal이란?

Modal은 머신러닝과 데이터 집약적 워크로드를 위해 특별히 설계된 서버리스 컴퓨팅 플랫폼입니다. VM을 프로비저닝하고 Kubernetes 클러스터를 관리하거나 자동 확장 그룹을 구성해야 하는 전통적인 클라우드 제공업체와 달리, Modal은 모든 인프라를 간단한 Python 데코레이터로 추상화합니다.

핵심 철학은 간단합니다. **당신의 코드가 바로 인프라 정의입니다.** Python 함수를 작성하고 리소스 요구사항(GPU 타입, 메모리, 타임아웃)을 지정하는 몇 가지 데코레이터를 추가한 다음 배포하세요. Modal은 올바른 컨테이너를 자동으로 프로비저닝하고 들어오는 요청에 따라 스케일링하며 실제 사용된 컴퓨팅 시간만큼 초 단위로 청구합니다.

### 왜 서버리스 GPU가 AI에 중요한가

GPU 인프라는 역사적으로 AI 개발의 가장 큰 병목 현상이었습니다. 전통적인 접근 방식은 다음과 같습니다:

- GPU 인스턴스 사전 프로비저닝(비싼 유휴 시간)
- 오케스트레이션을 위한 Kubernetes 클러스터 관리(복잡한 ops 오버헤드)
- 추론 엔드포인트의 콜드 스타트 처리(지연 시간 문제)
- 0에서 수천 개의 동시 요청으로 스케일링(수동 튜닝)

Modal은 GPU를 일급 서버리스 원자로 취급하여 이러한 모든 문제를 해결합니다. GPU가 실제로 추론이나 훈련을 실행하는 초만큼만 지불하면 되며 최소 커밋은 필요 없습니다.

```python
import modal

# PyTorch와 CUDA가 사전 설치된 컨테이너 이미지 정의
stub = modal.Stub("my-modal-app")

image = modal.Image.debian_slim().pip_install(
    "torch",
    "transformers",
    "accelerate"
)
```

### 대안과의 주요 차별점

| 기능 | Modal | AWS SageMaker | Google Vertex AI | Lambda GPU |
|---------|-------|---------------|------------------|------------|
| Python 네이티브 API | ✅ | ❌(콘솔/CLI) | ❌(콘솔/CLI) | ❌(YAML) |
| 제로 콜드 스타트* | ✅(웜 풀) | ❌ | ❌ | ❌ |
| 초 단위 과금 | ✅ | ❌(시간 단위 최소) | ❌(시간 단위 최소) | ✅ |
| 멀티 GPU 스케일링 | ✅(최대 8xH100) | ✅ | ✅ | ❌(단일 GPU) |
| 대화형 개발 | ✅(`modal serve`) | ❌ | ❌ | ❌ |

_*웜 풀은 대부분의 모델에 대해 콜드 스타트를 2초 미만으로 줄입니다._

---

## 시작하기: 첫 번째 Modal 앱

### 단계 1: 설치 및 인증

```bash
# Modal Python SDK 설치
pip install modal-client

# Modal 계정으로 인증
modal setup
```

Modal은 새 계정에 무료 크레딧을 제공합니다. 일반적으로 테스트용 A10G 컴퓨팅을 몇 시간 정도 돌리기에 충분합니다.

### 단계 2: 간단한 추론 함수 작성

```python
import modal
from transformers import AutoModelForCausalLM, AutoTokenizer

stub = modal.Stub("llm-inference")

# 컨테이너 시작 시 모델 한 번만 로드
@stub.cls(
    image=modal.Image.debian_slim().pip_install("transformers", "torch", "accelerate"),
    gpu="A10G",
    memory=8192
)
class LLMEndpoint:
    @modal.enter()
    def load_model(self):
        self.model = AutoModelForCausalLM.from_pretrained(
            "meta-llama/Llama-3.2-3B-Instruct",
            torch_dtype="auto",
            device_map="auto"
        )
        self.tokenizer = AutoTokenizer.from_pretrained("meta-llama/Llama-3.2-3B-Instruct")

    @modal.method()
    def generate(self, prompt: str, max_tokens: int = 512) -> str:
        inputs = self.tokenizer(prompt, return_tensors="pt").to(self.model.device)
        outputs = self.model.generate(**inputs, max_new_tokens=max_tokens)
        return self.tokenizer.decode(outputs[0], skip_special_tokens=True)
```

이 클래스 기반 접근 방식은 모델이 요청 간에 메모리에 로드된 상태로 유지되어 서버리스 LLM 배포에서 흔히 발생하는 수 분짜리 콜드 스타트 페널티를 제거합니다.

### 단계 3: 배포 및 테스트

```bash
# 앱을 Modal 클라우드에 배포
modal deploy my_app.py

# 명령줄에서 테스트
modal run my_app::LLMEndpoint.generate --prompt "양자 컴퓨팅 설명해줘" --max_tokens 256
```

배포 후 Modal은 공개 URL을 엔드포인트에 할당합니다. 모든 클라이언트가 HTTP REST API로 호출할 수 있습니다.

---

## 배포 패턴

### 패턴 1: 고투율 추론 엔드포인트

프로덕션 LLM 서빙에는 Modal의 내장 컨커런시와 요청 큐를 사용하세요:

```python
@stub.cls(
    gpu="L4",
    concurrency_limit=20,
    allow_concurrent_inputs=10,
    keep_warm=2  # 최소 2개 컨테이너 웜 상태로 유지
)
class ProductionLLM:
    @modal.enter()
    def load_model(self):
        self.model = load_optimized_model()
        self.tokenizer = AutoTokenizer.from_pretrained("your-model")

    @modal.web_endpoint(method="POST")
    def infer(self, req: dict):
        prompt = req.get("prompt", "")
        result = self.model.generate(prompt, max_tokens=req.get("max_tokens", 256))
        return {"response": result}
```

핵심 설정:
- `keep_warm=2`: 버스트 트래픽을 처리할 2개의 컨테이너를 항상 핫하게 유지
- `allow_concurrent_inputs=10`: 각 컨테이너가 10개의 동시 요청 처리
- `concurrency_limit=20`: 총 최대 20개 컨테이너(비용 제어)

### 패턴 2: 배치 처리 파이프라인

LLM을 통해 수천 개의 문서를 처리하려면:

```python
@stub.function(
    image=image,
    gpu="A100-80GB",
    timeout=3600,  # 최대 1시간
    retries=2
)
def batch_embed(docs: list[str]) -> list[list[float]]:
    """배치 문서 처리 후 임베딩 반환."""
    model = get_embedding_model()
    return model.encode(docs, batch_size=64).tolist()

# 배치 작업 실행
results = batch_embed.remote([f"문서 {i}" for i in range(10000)])
```

Modal은 청킹, 실패한 배치 재시도, 여러 GPU 컨테이너 간 병렬화를 자동으로 처리합니다.

### 패턴 3: 파인튜닝 작업

```python
@stub.function(
    gpu="H100-80GB",
    memory=16384,
    timeout=14400  # 4시간
)
def run_finetune(dataset_path: str, output_dir: str):
    """데이터셋에서 LoRA 파인튜닝 실행."""
    from trl import SFTTrainer
    from peft import LoraConfig

    model = AutoModelForCausalLM.from_pretrained("meta-llama/Llama-3.2-3B")
    tokenizer = AutoTokenizer.from_pretrained("meta-llama/Llama-3.2-3B")

    peft_config = LoraConfig(
        r=16, lora_alpha=32, target_modules=["q_proj", "v_proj"],
        lora_dropout=0.05, bias="none", task_type="CAUSAL_LM"
    )

    trainer = SFTTrainer(
        model=model, tokenizer=tokenizer,
        train_dataset=load_dataset(dataset_path),
        peft_config=peft_config,
        args=TrainingArguments(output_dir=output_dir, num_train_epochs=3)
    )
    trainer.train()
    trainer.save_model(output_dir)
```

`modal run finetune.py --dataset_path s3://my-bucket/data --output_dir /mnt/output`로 배포합니다. Modal은 출력 디렉토리를 영구 저장소에 마운트합니다.

---

## 가격 및 비용 최적화

### Modal의 가격 모델 이해

Modal은 컨테이너가 실제로 사용하는 리소스에 따라 청구합니다:

| 리소스 | 가격(대략) |
|----------|---------------------|
| A10G GPU | $0.60/시간 |
| L4 GPU | $0.80/시간 |
| A100-80GB | $2.50/시간 |
| H100 GPU | $4.00/시간 |
| vCPU(초 단위) | $0.000025/초 |
| 메모리(GB-시간당) | $0.003/GB-시간 |

_대략적인 가격이며 최신 요금은 [modal.com/pricing](https://modal.com/pricing)을 확인하세요._

### 비용 최적화 전략

**전략 1: GPU 선택을 적재적소에**

```python
# 3B 파라미터 모델에 H100 사용하지 마세요
# 대신 A10G 사용 — 비용 75% 절감
@stub.function(gpu="A10G", memory=4096)
def light_inference(prompt: str):
    model = load_small_model()  # 3B 파라미터는 쉽게 수용
    return model.generate(prompt)

# 대규모 파인튜닝에만 H100 예약
@stub.function(gpu="H100-80GB", memory=32768)
def heavy_finetune(config: dict):
    return run_large_scale_training(config)
```

**전략 2: `keep_warm`을 전략적으로 사용**

```python
# 예측 가능한 트래픽: 비즈니스 시간 동안만 웜 상태 유지
@stub.function(gpu="L4", keep_warm=1)
def production_endpoint():
    ...

# 버스트 트래픽: 더 높은 concurrency_limit 사용
@stub.function(gpu="L4", concurrency_limit=50, keep_warm=3)
def bursty_endpoint():
    ...
```

**전략 3: `@stub.cls`로 컨테이너 재사용**

클래스 기반 함수는 상태를 메모리에 유지하여 반복 모델 로드를 피합니다. 모델 로드에 2~5분이 걸리는 LLM 워크로드에 특히 중요합니다.

```python
# ❌ 나쁨: 매번 모델을 로드
@stub.function(gpu="A10G")
def bad_approach(prompt: str):
    model = load_model()  # 호출마다 다시 로드!
    return model.generate(prompt)

# ✅ 좋음: 한 번 로드하고 요청 간 재사용
@stub.cls(gpu="A10G")
class GoodApproach:
    @modal.enter()
    def setup(self):
        self.model = load_model()  # 시작 시 한 번만 로드
    
    @modal.method()
    def generate(self, prompt: str):
        return self.model.generate(prompt)  # 로드된 모델 재사용
```

### 실제 세계 비용 비교

| 워크로드 | AWS EC2(p4d) | Modal | 절감률 |
|----------|---------------|-------|---------|
| Llama 3.2 3B 추론(분당 100 요청) | $2,200/월(상시稼動) | $180/월(온디맨드) | 92% |
| 파인튜닝 8시간 작업 | $200(예약) | $20(실제 사용) | 90% |
| 배치 임베딩 100만 문서 | $500(클러스터 관리) | $85(순수 컴퓨팅) | 83% |

---

## 고급 기능

### 시크릿 관리

API 키를 하드코딩하지 마세요. Modal의 시크릿 관리자는 런타임에 자격 증명을 주입합니다:

```python
import modal

stub = modal.Stub("secret-demo")

@stub.function(
    secrets=[
        modal.Secret.from_name("huggingface-token"),
        modal.Secret.from_name("openai-key"),
    ]
)
def secure_inference(prompt: str):
    import os
    hf_token = os.environ["HF_TOKEN"]  # 시크릿에서 주입
    openai_key = os.environ["OPENAI_API_KEY"]
    return call_api(prompt, hf_token, openai_key)
```

시크릿 한 번 생성:
```bash
modal secret create huggingface-token HF_TOKEN=your_token_here
modal secret create openai-key OPENAI_API_KEY=sk-...
```

### 영구 저장을 위한 볼륨 마운트

Modal 볼륨은 함수 호출 간 공유된 영구 파일시스템을 제공합니다:

```python
# 모델 체크포인트용 볼륨 생성
checkpoint_volume = modal.Volume.from_name("model-checkpoints", create_if_missing=True)

@stub.function(
    gpu="A100-80GB",
    volumes={"/checkpoints": checkpoint_volume},
    timeout=7200
)
def fine_tune_and_save(dataset_url: str):
    dataset = load_dataset(dataset_url)
    
    trainer.train()
    trainer.save_model("/checkpoints/final-model")
    
    print(f"체크포인트 볼륨에 저장됨. 크기: {os.path.getsize('/checkpoints/final-model')}")

@stub.function(volumes={"/checkpoints": checkpoint_volume})
def load_and_infer(prompt: str):
    model = AutoModelForCausalLM.from_pretrained("/checkpoints/final-model")
    return model.generate(prompt)
```

볼륨은 함수 호출 간 데이터를 영구 저장하므로 모델 체크포인트, 데이터셋, 캐시 디렉토리에 이상적입니다.

### 이그레스 컨트롤

보안과 비용 관리를 위해 아웃바운드 네트워크 접근을 제어하세요:

```python
@stub.function(
    gpu="L4",
    network_mounts={"/etc/resolv.conf": modal.NetworkMount()},
    blocked_subnets=["169.254.0.0/16"],  # 메타데이터 서비스 차단
    allowed_domains=["api.openai.com"]   # 특정 도메인만 허용
)
def restricted_inference(prompt: str):
    return call_openai(prompt)
```

### 커스텀 Docker 이미지

`pip_install`로 커버되지 않는 복잡한 의존성이 있을 때:

```python
custom_image = (
    modal.Image.from_dockerhub("nvidia/cuda:12.2.0-devel-ubuntu22.04")
    .apt_install("git", "cmake", "build-essential")
    .pip_install("torch", "transformers", "bitsandbytes")
    .copy_local_dir("./my-custom-model", "/app/model")
)

@stub.function(image=custom_image, gpu="A100-80GB")
def custom_model_inference(request: dict):
    model = torch.load("/app/model/best.pt")
    return model.predict(request["input"])
```

---

## 공통 문제 해결

### 문제 1: 추론 중 컨테이너 OOM 크래시

```
에러: 메모리 제한 초과로 컨테이너 종료
```

**해결**: 메모리 할당을 늘리고 스왑 활성화:

```python
@stub.cls(
    gpu="A100-80GB",
    memory=32768,  # 대형 모델용 32GB RAM
    ephemeral_disk=100_000  # 모델 가중치용 100GB 디스크
)
class LargeModel:
    @modal.enter()
    def load(self):
        self.model = AutoModel.from_pretrained(
            "big-model",
            torch_dtype=torch.float16,  # 반정밀도 사용
            device_map="auto"
        )
```

### 문제 2: 첫 번째 요청의 느린 콜드 스타트

```
경고: 첫 번째 요청에 180초 소요(모델 로딩)
```

**해결**: `keep_warm` 사용 및 컨테이너 프리워밍:

```python
@stub.cls(
    gpu="A10G",
    keep_warm=3,  # 항상 3개의 웜 컨테이너 유지
    timeout=600
)
class WarmEndpoint:
    @modal.enter()
    def load(self):
        self.model = load_model()
        print("모델 로드 완료")
```

### 문제 3: 장기 파인튜닝 작업 타임아웃

```
에러: 함수가 3600초 후 타임아웃
```

**해결**: 타임아웃 증가 및 체크포인트 저장을 위한 볼륨 사용:

```python
@stub.function(
    gpu="H100-80GB",
    timeout=28800,  # 8시간
    volumes={"/data": modal.Volume.from_name("training-data")}
)
def long_training_job(config_path: str):
    for epoch in range(10):
        train_epoch(config_path)
        if epoch % 2 == 0:
            save_checkpoint(f"/data/checkpoint-{epoch}")
```

### 문제 4: 컨커런시 스로틀링

```
에러: 너무 많은 동시 입력(제한: 10)
```

**해결**: 컨커런시 설정 조정:

```python
@stub.cls(
    gpu="L4",
    concurrency_limit=100,       # 최대 컨테이너 수
    allow_concurrent_inputs=20,  # 컨테이너당 요청 수
    keep_warm=5                  # 웜 풀 크기
)
class ScalableEndpoint:
    @modal.method()
    def handle(self, request: dict):
        return process(request)
```

---

## 미래 방향

### Modal의 2026 로드맵

Modal은 ML 인프라에 지속적으로 대규모 투자를 하고 있습니다. 주요 예정 기능:

1. **멀티노드 분산 훈련**: 8개 이상의 GPU 간 자동 데이터 병렬화된 훈련 지원
2. **GPU 공유**: 저트래픽 기간 중 더 나은 활용을 위한 GPU 타임 슬라이싱
3. **커스텀 GPU 타입**: 사용 가능해지면 차세대 GPU(Blackwell B200) 지원
4. **엣지 배포**: 서브-50ms 추론 지연时间来 엣지 로케이션에 Modal 함수 배포
5. **네이티브 벡터 DB 통합**: Modal 스토리지 레이어 기반의 내장 벡터 검색

### 언제 Modal을 선택해야 하나요

**다음 경우 Modal 선택:**
- 주가 아닌 시간 내에 ML 워크로드를 출시하고 싶을 때
- 워크로드가 간헐적일 때(배치 작업, 드문 추론)
- 클러스터 관리 없이 GPU 접근이 필요할 때
- Python 우선 팀이고 최소한의 DevOps를 원할 때

**대안을 고려할 때:**
- 절대 최소 지연 시간(<10ms)이 필요할 때 — 베어 메탈 또는 전용 인스턴스가 유리
- 예측 가능한 24/7 고투율 트래픽이 있을 때 — 예약 인스턴스가 더 저렴할 수 있음
- 커스텀 커널 수정이 필요할 때 — Modal은 표준 컨테이너 이미지 사용
- 특정 클라우드 생태계에 깊이 투자되어 있을 때 — 네이티브 서비스가 더 잘 통합될 수 있음

---

## 커뮤니티 업데이트

서버리스 GPU 공간이 빠르게 뜨거워지고 있습니다. 2026년 중반, 여러 신규 참가자가 시장에 진입했습니다:

- **RunPod Serverless**가 A10G 기준 $0.30/시간의 경쟁력 있는 GPU 가격 발표
- **Replicate**가 500개 이상의 패키지된 ML 모델 라이브러리 확장
- **AWS Lambda GPU**가 Graviton4 + Inferentia2 조합의 일반 가용성 발표

이러한 경쟁에도 불구하고 Modal은 개발자 경험에서 선두를 유지합니다. Python 네이티브 API 덕분에 팀은 YAML, Helm 차트 또는 Terraform을 배우지 않고도 프로토타입에서 프로덕션까지 이동할 수 있습니다.

Modal의 커뮤니티 기반 모델 레지스트리는 2,000개 이상의 모델로 성장했으며, LLM부터 확산 모델, 음성 인식까지 모든 것을 커버합니다. 사용자는 한 줄의 Python 코드만으로 등록된 모델을 탐색, 테스트, 배포할 수 있습니다.

---

## FAQ

### Q: Modal은 AWS EC2에서 직접 GPU를 실행하는 것과 어떻게 비교되나요?

Modal은 GPU 인스턴스 관리의 운영 오버헤드를 제거합니다. EC2에서는 스팟 인스턴스 중단, 드라이버 업데이트, GPU 모니터링, 자동 확장 구성을 처리해야 합니다. Modal에서는 모든 것이 추상화되어 있으므로 Python 함수만 작성하면 됩니다. 간헐적 워크로드의 경우 Modal은 일반적으로 70~90% 저렴합니다. 실제 컴퓨팅 시간만큼만 지불하기 때문에 인스턴스를 24/7 실행하지 않아도 됩니다.

### Q: 기존 Hugging Face 모델을 Modal과 함께 사용할 수 있나요?

예. Modal은 Hugging Face 모델과 원활하게 작동합니다. 이미지에 `transformers` 라이브러리를 설치하고 표준 `AutoModel.from_pretrained()` API로 모델을 로드하기만 하면 됩니다. 개인 모델 액세스를 위해 Hugging Face 토큰을 Modal 시크릿으로 마운트할 수도 있습니다. 많은 사용자가 100억 파라미터 미만 모델에 대해 30~60초의 로드 시간을 보고합니다.

### Q: GPU 컨테이너가 요청 중간에 크래시하면 어떻게 되나요?

Modal은 구성 가능한 재시도 정책으로 실패한 컨테이너를 자동으로 재시도합니다. 추론 엔드포인트의 경우 함수 정의에 `retries=3`을 설정할 수 있습니다. 훈련 작업의 경우 Modal은 체크포인트 기반 복구를 지원합니다. 체크포인트를 Modal 볼륨에 저장하면 재시도 시 처음부터 다시 시작하는 대신 마지막 체크포인트에서 계속됩니다.

### Q: 테스트를 위한 무료 티어가 있나요?

Modal은 새 계정에 무료 크레딧을 제공합니다. 일반적으로 A10G 컴퓨팅 10~20시간에 충분합니다. 이는 유료 사용에 착수하기 전에 대부분의 ML 워크로드를 프로토타입 테스트하기에 충분합니다. 시작하려면 신용카드가 필요 없습니다.

### Q: 실행 중인 Modal 함수를 어떻게 모니터링하고 디버깅하나요?

Modal은 `modal.com/apps`에서 실시간 메트릭(호출 횟수, 지연 시간 백분위, 오류율, GPU 사용량)을 보여주는 웹 대시보드를 제공합니다. `modal logs <app-name>`으로 CLI에서 로그를 직접 스트리밍할 수 있으며 오류 임계값이나 비용 제한에 대한 알림을 설정할 수 있습니다.

### Q: 온프레미스 또는 에어갭 환경에서 Modal 함수를 실행할 수 있나요?

현재 Modal은 자체 관리 클라우드 인프라에서만 운영됩니다. 온프레미스 배포 옵션은 제공하지 않습니다. 에어갭 환경의 경우 Kubernetes 또는 Ray Serve와 함께 vLLM을 고려하세요. 이는 전체적으로 자체 인프라 내에서 실행할 수 있습니다.

---

## 출처

- [Modal 문서](https://modal.com/docs)
- [Modal GitHub 예제](https://github.com/modal-labs/modal-examples)
- [Modal 가격 페이지](https://modal.com/pricing)
- [서버리스 GPU 컴퓨팅 조사 — ACM Queue 2026](https://dl.acm.org/doi/10.1145/serverless-gpu-2026)
- [클라우드 GPU 비용 비교 — ML 인프라 보고서 2026년 2분기](https://mlinfra.report/gpu-costs-q2-2026)

---

*실시간 AI 도구 토론 및 배포 팁을 위한 Telegram 그룹 가입: [t.me/dibi8](https://t.me/dibi8)*
