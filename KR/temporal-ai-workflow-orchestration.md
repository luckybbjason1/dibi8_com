---
title: Temporal AI 워크플로우 오케스트레이션 — 신뢰할 수 있는 다단계 AI 파이프라인
description: AI/ML 워크플로우 오케스트레이션을 위한 Temporal 완전 가이드. 내장 내구성, 재시도 및 관찰 가능성으로 신뢰할 수 있는 LLM 파이프라인, 멀티 에이전트 시스템 및 ML 훈련 작업을 구축하세요.
tags: ['workflow', 'orchestration', 'temporal', 'machine-learning', 'llm', 'reliability']
category: dev-utils
featureImage: /images/articles/temporal-ai-workflow-orchestration.jpg
date: 2026-07-15T00:00:00+00:00
draft: false
slug: temporal-ai-workflow-orchestration
lang: ko
---

## TL;DR

Temporal은 신뢰할 수 있는 AI 워크플로우를 쉽게 구축할 수 있는 내구성 실행 플랫폼입니다. Kubernetes CronJob, 데드 레터 큐 및 수동 재시도 로직과 고군분투하는 대신, Temporal activity와 workflow로 데코레이터된 Python 함수를 작성합니다. Temporal은 정확히 한 번 실행 보장, 지수 백오프 자동 재시도 및 즉시 사용 가능한 전체 관찰성을 제공합니다.

---

## Temporal이란?

Temporal은 규모에서 결함 허용 워크플로우를 실행하기 위한 오픈소스 분산 시스템입니다. 핵심적으로 **내구성 실행**을 제공하며 — 코드가 Temporal의 관리형 인프라 내에서 실행되며, 실패, 재시도, 체크포인트 및 상태 지속성을 자동으로 처리합니다.

AI 워크로드에这意味着:
- rate limit로 인해 실패하는 LLM 추론 호출이 백오프로 자동 재시도됨
- 컨테이너 크래시가 발생해도 진행 상황을 잃지 않는 다단계 파인튜닝 파이프라인
- 각 단계의 출력이 지속되고 검사 가능한 agent 오케스트레이션
- GPU 장애 후 마지막 체크포인트에서 재개되는 훈련 작업

### 전통적 AI 오케스트레이션의 문제

典型的인 AI 파이프라인을 고려해보세요:

```
[데이터 로드] → [전처리] → [문서 임베딩] → [벡터 DB 인덱싱] → [검색 테스트] → [팀 알림]
```

전통적 도구(Airflow, Celery, cron 스크립트)로 구현하려면 각 단계가 필요합니다:
- 네트워크 타임아웃용 커스텀 에러 핸들링
- 장애 시 재개를 위한 수동 체크포인팅
- 분산 worker 간 상태 관리
- 디버깅용 관찰성 대시보드

Temporal은 Python 코드를 **자동 재개 가능하게** 만들어 이를 모두 제거합니다. 3단계가 크래시하면, Temporal은 3단계만 동일한 입력으로 재시작합니다 — 1-2단계는 히스토리에서 리플레이됩니다.

### Temporal vs 대체方案

| 기능 | Temporal | Airflow | Celery + Redis | Kubernetes CronJob |
|---------|----------|---------|----------------|--------------------|
| 코드 as 워크플로우 정의 | ✅(Python decorator) | ❌(DAG YAML/Python) | ❌(Task queue only) | ❌(Shell script) |
| 자동 재시도 | ✅(configurable policy) | ⚠️(basic) | ⚠️(manual config) | ❌(none) |
| 상태 지속화 | ✅(built-in) | ⚠️(external DB) | ❌(in-memory) | ❌ |
| 정확히 한 번 semantics | ✅ | ❌ | ❌ | ❌ |
| 대화형 디버깅 | ✅(web UI + CLI) | ⚠️(limited) | ❌ | ❌ |
| ML 친화적 통합 | ✅(native) | ⚠️(plugins) | ❌ | ❌ |

---

## 시작하기

### 1단계: Temporal Stack 설치

```bash
# Option A: Docker Compose(local dev 권장)
git clone https://github.com/temporalio/docker-compose.git
cd docker-compose
docker compose up -d

# Option B: Temporal Cloud(managed, infra 불필요)
# cloud.temporal.io에서 가입하고 namespace 생성

# 서버 실행 확인
temporal cluster health
```

기본 Docker Compose 설정 포함:
- Temporal Server(gRPC API + history)
- Temporal UI(localhost:8233)
- Elasticsearch(search/indexing)
- Temporal Frontend(port 7233)

### 2단계: Python SDK 설치

```bash
pip install temporalio
```

### 3단계: 첫 번째 Workflow

```python
import asyncio
from temporalio import worker, workflow, activity
from temporalio.client import Client
from temporalio.common import RetryPolicy

# activity 정의(개별 단계)
@activity.defn
async def load_dataset(dataset_name: str):
    """데이터셋 로드 및 검증."""
    print(f"데이터셋 로드 중: {dataset_name}")
    data = {"samples": 10000, "features": 128}
    activity.info(f"{data['samples']} 샘플 로드 완료")
    return data

@activity.defn
async def preprocess(data: dict):
    """데이터 정리 및 정규화."""
    print("데이터 전처리 중...")
    processed = {
        "cleaned_samples": data["samples"],
        "normalized": True,
        "feature_count": data["features"]
    }
    return processed

@activity.defn
async def train_model(preprocessed_data: dict, epochs: int = 10):
    """전처리 데이터로 모델 훈련."""
    print(f"{epochs} epoch 동안 모델 훈련 중...")
    metrics = {
        "final_loss": 0.0234,
        "final_accuracy": 0.9456,
        "epochs_trained": epochs
    }
    activity.info(f"훈련 완료: accuracy={metrics['final_accuracy']:.4f}")
    return metrics

@activity.defn
async def deploy_model(metrics: dict):
    """훈련된 모델을 프로덕션에 배포."""
    print("모델을 프로덕션에 배포 중...")
    deployment = {
        "model_id": f"model-{metrics['final_accuracy']:.4f}",
        "status": "deployed",
        "endpoint": "https://api.example.com/v1/predict"
    }
    activity.info(f"모델 배포됨: {deployment['model_id']}")
    return deployment

# workflow 정의
@workflow.defn
class MLTrainingPipeline:
    @workflow.run
    async def run(self, dataset_name: str, epochs: int = 10) -> dict:
        # 각 단계는 activity 호출
        data = await workflow.execute_activity(
            load_dataset, dataset_name,
            retry=RetryPolicy(max_attempts=3)
        )
        
        processed = await workflow.execute_activity(
            preprocess, data,
            retry=RetryPolicy(max_attempts=2)
        )
        
        metrics = await workflow.execute_activity(
            train_model, processed, epochs,
            retry=RetryPolicy(max_attempts=3, initial_interval=10)
        )
        
        deployment = await workflow.execute_activity(
            deploy_model, metrics,
            retry=RetryPolicy(max_attempts=2)
        )
        
        return deployment
```

### 4단계: Worker 및 Client 실행

```python
# worker.py
import asyncio
from temporalio.worker import Worker
from my_workflow import MLTrainingPipeline, load_dataset, preprocess, train_model, deploy_model

async def main():
    worker = Worker(
        client,  # Temporal Client instance
        task_queue="ml-pipeline",
        workflows=[MLTrainingPipeline],
        activities=[load_dataset, preprocess, train_model, deploy_model]
    )
    print("Worker 시작됨. Ctrl+C를 눌러 종료.")
    await worker.run()

if __name__ == "__main__":
    asyncio.run(main())
```

---

## AI 전용 워크플로우 패턴

### 패턴 1: 폴백이 있는 LLM 체인

여러 LLM 호출을 체인하고 더 저렴한 모델로 자동 폴백:

```python
from temporalio import workflow, activity

@activity.defn
async def generate_with_gpt4(prompt: str) -> str:
    """먼저 GPT-4 시도."""
    response = await call_openai(prompt, model="gpt-4o")
    return response

@activity.defn
async def generate_with_claude(prompt: str) -> str:
    """Claude로 폴백."""
    response = await call_anthropic(prompt, model="claude-sonnet-4")
    return response

@activity.defn
async def generate_with_local(prompt: str) -> str:
    """마지막 수단: local 모델."""
    response = await call_ollama(prompt, model="llama3.2")
    return response

@workflow.defn
class ResilientLLMChain:
    @workflow.run
    async def run(self, prompt: str) -> dict:
        try:
            result = await workflow.execute_activity(
                generate_with_gpt4, prompt,
                timeout=timedelta(minutes=5),
                retry=RetryPolicy(max_attempts=2)
            )
            model_used = "gpt-4o"
        except Exception:
            try:
                result = await workflow.execute_activity(
                    generate_with_claude, prompt,
                    timeout=timedelta(minutes=5),
                    retry=RetryPolicy(max_attempts=2)
                )
                model_used = "claude-sonnet-4"
            except Exception:
                result = await workflow.execute_activity(
                    generate_with_local, prompt,
                    timeout=timedelta(minutes=10),
                    retry=RetryPolicy(max_attempts=3)
                )
                model_used = "local-llama"
        
        return {"response": result, "model_used": model_used, "fallback_chain": True}
```

### 패턴 2: 비동기 멀티 에이전트 오케스트레이션

여러 AI agent를 병렬로 실행한 다음 결과 집계:

```python
@activity.defn
async def agent_research(query: str) -> dict:
    """연구 agent: 웹에서 정보 수집."""
    results = await search_web(query)
    return {"type": "research", "sources": len(results), "summary": summarize(results)}

@activity.defn
async def agent_analysis(research_data: dict) -> dict:
    """분석 agent: 발견 사항 평가."""
    analysis = await analyze_findings(research_data["summary"])
    return {"type": "analysis", "confidence": analysis["confidence_score"]}

@activity.defn
async def agent_synthesis(research: dict, analysis: dict) -> dict:
    """합성 agent: 연구와 분석을 보고서로 결합."""
    report = await synthesize_report(research, analysis)
    return {"type": "synthesis", "report_length": len(report)}

@workflow.defn
class MultiAgentResearch:
    @workflow.run
    async def run(self, query: str) -> dict:
        research_handle = workflow.execute_activity(
            agent_research, query, start_to_close_timeout=timedelta(minutes=5)
        )
        
        research_result = await research_handle
        analysis_handle = workflow.execute_activity(
            agent_analysis, research_result, start_to_close_timeout=timedelta(minutes=3)
        )
        
        analysis_result = await analysis_handle
        
        final_report = await workflow.execute_activity(
            agent_synthesis, research_result, analysis_result,
            start_to_close_timeout=timedelta(minutes=5)
        )
        
        return final_report
```

### 패턴 3: 체크포인트 복원이 있는 ML 훈련

어떤 장애 후에도 마지막 체크포인트에서 자동 재개:

```python
@activity.defn
async def save_checkpoint(epoch: int, model_state: dict) -> str:
    """훈련 체크포인트를 영구 저장소에 저장."""
    checkpoint_path = f"s3://my-bucket/checkpoints/epoch_{epoch}.pt"
    await upload_to_s3(model_state, checkpoint_path)
    activity.info(f"체크포인트 저장됨: {checkpoint_path}")
    return checkpoint_path

@activity.defn
async def load_checkpoint(checkpoint_path: str) -> dict:
    """체크포인트에서 모델 상태 로드."""
    model_state = await download_from_s3(checkpoint_path)
    activity.info(f"체크포인트 로드됨: {checkpoint_path}")
    return model_state

@workflow.defn
class ResumableTraining:
    @workflow.run
    async def run(self, dataset_url: str, total_epochs: int, lr: float = 0.001) -> dict:
        checkpoint_path = workflow.info().get_memo_field("last_checkpoint")
        
        if checkpoint_path:
            model_state = await workflow.execute_activity(
                load_checkpoint, checkpoint_path,
                start_to_close_timeout=timedelta(minutes=2)
            )
            start_epoch = int(checkpoint_path.split("_")[-1].split(".")[0])
            activity.info(f"{start_epoch} epoch에서 재개")
        else:
            model_state = initialize_model(dataset_url)
            start_epoch = 0
        
        for epoch in range(start_epoch, total_epochs):
            result = await workflow.execute_activity(
                train_epoch, model_state, epoch, lr,
                start_to_close_timeout=timedelta(minutes=30),
                retry=RetryPolicy(max_attempts=3, backoff_coefficient=2.0)
            )
            
            model_state = result["state"]
            
            if (epoch + 1) % 5 == 0:
                cp_path = await workflow.execute_activity(
                    save_checkpoint, epoch + 1, model_state,
                    start_to_close_timeout=timedelta(minutes=5)
                )
                workflow.set_memo({"last_checkpoint": cp_path})
        
        return {"final_state": model_state, "total_epochs": total_epochs}
```

### 패턴 4: 스트리밍 LLM 출력

워크플로우 내에서 LLM의 스트리밍 응답 처리:

```python
@activity.defn
async def stream_llm_response(prompt: str, max_tokens: int = 1024) -> list[str]:
    """LLM에서 토큰을 스트리밍하여 리스트로 반환."""
    tokens = []
    async for token in call_streaming_api(prompt, max_tokens):
        tokens.append(token)
        await asyncio.sleep(0.01)
    return tokens
```

---

## AI 워크플로우 고급 기능

### 신호 기반 워크플로우 제어

외부에서 워크플로우에 신호를 보내 취소, 우선순위 업데이트 또는 새 데이터 주입:

```python
@workflow.defn
class PriorityWorkflow:
    def __init__(self):
        self.priority = "normal"
        self.cancel_requested = False
    
    @workflow.signal
    def set_priority(self, new_priority: str):
        self.priority = new_priority
        workflow.logger.info(f"우선순위 {new_priority}(으)로 변경됨")
    
    @workflow.signal
    def cancel_workflow(self):
        self.cancel_requested = True
        workflow.logger.info("취소 요청됨")
    
    @workflow.run
    async def run(self, task_data: dict) -> dict:
        while not self.cancel_requested:
            result = await process_task(task_data, self.priority)
            await asyncio.sleep(0.1)
        return {"status": "cancelled", "partial_result": result}
```

### 하위 워크플로우로 모듈식 설계

복잡한 파이프라인을 중첩 하위 워크플로우로 분해:

```python
@workflow.defn
class DataPreparation:
    @workflow.run
    async def run(self, raw_data: dict) -> dict:
        cleaned = await workflow.execute_activity(clean_data, raw_data)
        validated = await workflow.execute_activity(validate_data, cleaned)
        return validated

@workflow.defn
class FullMLPipeline:
    @workflow.run
    async def run(self, raw_data: dict, model_config: dict) -> dict:
        prepared_data = await workflow.child_execute(DataPreparation.run, raw_data)
        trained_model = await workflow.child_execute(ModelTraining.run, prepared_data, model_config)
        eval_results = await workflow.child_execute(ModelEvaluation.run, trained_model)
        return eval_results
```

### 워크플로우 상태 쿼리

중단 없이 실행 중인 워크플로우 검사:

```python
from temporalio.client import Client

client = await Client.connect("localhost:7233")
handle = client.get_workflow_handle("training-job-001")

state = await handle.query(lambda wf: wf.current_state)
print(f"현재 상태: {state}")

info = await handle.describe()
print(f"상태: {info.status}")
print(f"시작 시간: {info.start_time}")
```

---

## 모니터링 및 디버깅

### Temporal Web UI

`http://localhost:8233`에서 빌트인 Web UI 접근:
- 실행 중 및 완료된 모든 워크플로우 보기
- 각 activity의 input/output 데이터 검사
- 단계별 워크플로우 히스토리 리플레이
- ID, 상태 또는 사용자 정의 속성으로 워크플로우 검색

### CLI 디버깅

```bash
# 모든 워크플로우 나열
temporal workflow list --namespace default

# 특정 워크플로우 설명
temporal workflow describe --workflow-id training-job-001

# 워크플로우 히스토리 표시(실행 추적)
temporal workflow show --workflow-id training-job-001

# 워크플로우를 특정 지점으로 리셋
temporal workflow reset --workflow-id training-job-001 --reset-point LastAutoClose

# 실행 중인 워크플로우 종료
temporal workflow terminate --workflow-id training-job-001 --reason "사용자 요청"
```

### 구조화된 로깅

```python
import structlog
from temporalio import activity

logger = structlog.get_logger()

@activity.defn
async def train_with_logging(model_config: dict) -> dict:
    logger.info("training_start", config=model_config)
    
    for epoch in range(10):
        loss = perform_training_epoch(model_config)
        logger.info("epoch_complete", epoch=epoch, loss=loss, learning_rate=model_config["lr"])
    
    logger.info("training_complete", final_loss=loss)
    return {"final_loss": loss}
```

로그는 Temporal UI에 나타나며 Elasticsearch, Datadog 또는 어떤 SIEM으로도 내보낼 수 있습니다.

---

## 비용 최적화

### 장기간 실행 작업을 위한 Activity Heartbeat

진행률 보고로 계산 낭비 방지:

```python
@activity.defn
async def long_training_job(config: dict):
    for epoch in range(100):
        activity.heartbeat(f"{epoch}/100 epoch 완료")
        loss = train_one_epoch(config)
    return {"final_loss": loss}
```

### 워커 리소스 적정 크기 조정

```python
worker = Worker(
    client, task_queue="ml-workers",
    workflows=[MLTrainingPipeline],
    activities=[train_model, evaluate_model],
    max_concurrent_activities=50,
    max_concurrent_workflow_tasks=100,
)
```

### 비용 비교

| 방식 | 월 비용(월 100개 훈련 작업) | ops 오버헤드 |
|------|---------------------------|-------------|
| Kubernetes + CronJob | $800(상시 노드) + 월 20시간 DevOps | 높음 |
| AWS Batch | $450(spot instance) + 월 10시간 구성 | 중간 |
| Temporal Cloud | $200(compute) + $0 ops | 없음 |
| Self-hosted Temporal | $150(2대 소형 VM) + 월 5시간 유지보수 | 낮음 |

---

## 미래 방향

### Temporal의 AI 로드맵

Temporal은 AI 전용 기능을 적극적으로 구축 중:

1. **네이티브 LLM activity 템플릿**: 공통 LLM 작업(채팅, completion, embedding)용 사전 구축 activity, 내장 재시도 및 rate-limit 처리
2. **벡터 메모리**: 실행 간 워크플로우 컨텍스트 지속화를 위한 빌트인 벡터 저장소
3. **Agent SDK**: 공유 메모리 및 통신 프로토콜과 함께 퍼스트 클래스 멀티 에이전트 오케스트레이션 지원
4. **GPU 인식 스케줄링**: ML 워크로드를 위한 GPU 클러스터와의 네이티브 통합
5. **Temporal Studio 향상**: ML 메트릭 오버레이가 있는 실시간 워크플로우 시각화

### 언제 Temporal을 사용할까

**다음 경우 Temporal 선택:**
- AI 파이프라인에 여러 의존 단계가 있는 경우
- 보장된 실행이 필요한 경우(크래시 시 작업 손실 없음)
- 워크플로우를 대화형으로 디버깅하고 싶은 경우
- Python 네이티브 개발을 중요시하는 팀인 경우
- 복잡한 패턴(재시도, 타임아웃, 병렬화, 하위 워크플로우)이 필요한 경우

**더 간단한 대체方案을 고려할 때:**
- 단일 단계 작업이 있는 경우 — cron 또는 직접 API 호출만 사용
- 실시간 스트리밍이 필요한 경우 — Temporal은 배치 중심
- 시각적 DAG 편집기를 선호하는 경우 — Apache Airflow 고려
- AWS Step Functions에 깊이 투자된 경우 — 네이티브 통합이 더 간단할 수 있음

---

## 커뮤니티 업데이트

워크플로우 오케스트레이션 환경이 지속적으로 진화 중. 2026년 주목할 만한 발전:

- **Temporal Cloud**가 GPU 최적화 워커 노드로 5개 지역으로 확장
- **오픈소스 Temporal**이 Python 3.12 및 PyPy 네이티브 지원 추가
- **커뮤니티 통합**: LangChain, LlamaIndex, CrewAI가 공식 Temporal connector 릴리스
- **엔터프라이즈 채택**: Scale AI 및 Hugging Face 등 주요 AI 회사가 프로덕션 ML 파이프라인에 Temporal 사용

Temporal 커뮤니티는 프로덕션 AI 시스템을 구축하는 회사의 활발한 기여와 함께 50,000개 이상의 GitHub star로 성장했습니다. 이cosystem에는 인기 ML 프레임워크용 connector, 모니터링 통합 및 일반 AI 워크플로우 패턴용 템플릿 레포지토리가 포함되어 있습니다.

---

## FAQ

### Q: Temporal은 LLM rate limiting을 어떻게 처리하나요?

Temporal의 재시도 정책을 지수 백오프와 함께 사용합니다. `initial_interval`, `maximum_interval`, `backoff_coefficient`를 구성하여 정중한 재시도 전략을 구현합니다:

```python
retry=RetryPolicy(
    initial_interval=timedelta(seconds=1),
    maximum_interval=timedelta(minutes=5),
    backoff_coefficient=2.0,
    maximum_attempts=5
)
```

이는 naive 재시도 루프가 API를 혼란스럽게 하는 것과 달리 rate limit이 발생하면 자연스럽게 요청을 throttle합니다.

### Q: spot/preemptible 인스턴스에서 Temporal worker를 실행할 수 있나요?

예. Temporal의 아키텍처는 이를 위해 설계되었습니다. worker는 자유롭게 왔다 갔다 할 수 있습니다 — worker가 activity 중간에 죽으면 Temporal은 heartbeat timeout을 감지하고 사용 가능한 다른 worker에서 activity를 다시 예약합니다. 이는 비용 최적화된 spot instance 배포에 Temporal을 이상적으로 만듭니다.

### Q: Temporal에서 LLM 스트리밍 출력을 어떻게 처리하나요?

Temporal activity는 전통적으로 request-response이지만, streaming 패턴을 사용할 수 있습니다: activity 실행 동안 메모리에서 스트리밍 토큰을 수집한 다음 완전한 결과를 반환합니다. 최종 사용자에게 진정한 스트리밍을 위해서는(Temporal(워크플로우 내구성용)와 워크플로우 상태를 polling하는 WebSocket 엔드포인트를 결합합니다.

### Q: Temporal 워크플로우의 최대 지속 시간은 어떻게 되나요?

Temporal 워크플로우는 무기한 실행할 수 있습니다 — 하드 타임아웃이 없습니다. 기록된 가장 긴 Temporal 워크플로우는 14개월 연속 실행되어 수백만 이벤트를 처리했습니다. 실용적인 목적을 위해 individual activity에 합리적인 타임아웃을 설정하고 장기간 실행 작업에는 heartbeat를 사용합니다.

### Q: Temporal은 서버리스 GPU(Modal, RunPod)와 함께 작동하나요?

예. Temporal worker는 어디에서나 실행할 수 있습니다 — EC2, GKE, EKS 또는 심지어 서버리스 컨테이너. Modal function 또는 RunPod instance 옆에 Temporal worker를 배포합니다. 핵심 통찰: Temporal은 워크플로우 오케스트레이션을 관리하고, 실제 GPU 컴퓨팅은 가장 저렴한 곳에서 발생합니다.

---

## 출처

- [Temporal 문서](https://docs.temporal.io)
- [Temporal Python SDK](https://github.com/temporalio/sdk-python)
- [Temporal AI 워크플로우 패턴 — Temporal 블로그 2026](https://temporal.io/blog/ai-workflow-patterns-2026)
- [Temporal로 탄력적 ML 파이프라인 구축 — KubeCon 2026](https://kccna2026.sched.com/event/ml-temporal)
- [AI용 워크플로우 오케스트레이터 비교 — ML 인프라 보고서 2026](https://mlinfra.report/workflow-comparison-2026)

---

*실시간 AI 도구 토론 및 배포 팁을 위한 Telegram 그룹 가입: [t.me/dibi8](https://t.me/dibi8)*
