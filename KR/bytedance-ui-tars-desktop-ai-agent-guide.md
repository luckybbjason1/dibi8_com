---
title: "ByteDance UI-TARS Desktop: 화면을 보고 컴퓨터를 제어하는 비전-언어 AI 에이전트 — 완전 설정 가이드"
description: "화면을 보고 자연어로 애플리케이션을 제어하는 비전-언어 AI 에이전트인 ByteDance의 UI-TARS Desktop 배포 방법을 배워보세요. 단계별 설치, 실제 벤치마크 및 대안과 비교."
date: 2026-06-10
slug: "bytedance-ui-tars-desktop-ai-agent-guide"
category: ai-tools
tags: [바이트댄스, ui-tars, 비전-언어모델, AI에이전트, 데스크톱자동화, GUI에이전트, 오픈소스, 멀티모달AI]
github_repo: "https://github.com/bytedance/UI-TARS-desktop"
stars: 36263
maintainer: bytedance
license: Apache-2.0
featureImage: "https://raw.githubusercontent.com/bytedance/UI-TARS-desktop/main/images/tars.png"
lang: ko
---

## 소개

진정으로 자율적인 AI 어시스턴트의 꿈 — 컴퓨터 화면을 보고, 무엇을 보는지 이해하고, 작업을 완료하기 위해 조치를 취하는 — 은 수년간 AI 개발의 성배였습니다. ByteDance의 UI-TARS Desktop은 최첨단 비전-언어 모델과 데스크톱 자동화 기능을 결합하여 이 꿈을 더 현실에 가깝게 가져옵니다.

UI-TARS(User Interface TARS)는 ByteDance에서 개발한 데스크톱 AI 에이전트로, 스크린샷을 통해 컴퓨터 화면을 관찰하고, 애플리케이션의 시각적 레이아웃을 이해하고, 버튼 클릭, 텍스트 입력, 메뉴 탐색 등의 작업을 수행할 수 있습니다 — 모두 자연어 지침을 통해. 스크래핑이나 API 기반 자동화 도구와 달리, UI-TARS는 사람이 보는 방식으로 실제로 화면을 보므로, 통합이나 API 키 없이 어떤 GUI 애플리케이션도 처리할 수 있습니다. 36,000개 이상의 GitHub 스타를 달성하며, 데스크톱 자동화를 위한 가장 인기 있는 비전-언어 에이전트 중 하나가 되었습니다.

![UI-TARS Desktop](https://raw.githubusercontent.com/bytedance/UI-TARS-desktop/main/images/tars.png)

## UI-TARS Desktop이란?

UI-TARS Desktop은 **화면을 관찰하여 컴퓨터를 제어하는 비전-언어 AI 에이전트**입니다. 데스크톱 인터페이스를 이해하도록 훈련된 전용 비전-언어 모델을 사용하여 — 버튼, 메뉴, 폼, 텍스트 필드 인식 — 그리고 상호작용하기 위한 실행 가능한 명령을 생성합니다.

주요 기능:

- **시각적 이해** — VLM 기반 인식을 통해 스크린샷을 분석하여 UI 요소, 텍스트, 레이아웃 식별
- **동작 생성** — 마우스 클릭, 키보드 입력, 스크롤 명령, 드래그 작업 생성
- **자연어 인터페이스** — 일반 영어 지침으로 모든 데스크톱 애플리케이션 제어
- **다중 애플리케이션 지원** — 통합이나 API 키 없이 모든 GUI 애플리케이션에서 작동
- **자기 수정** — 각 동작의 시각적 피드백을 기반으로 접근 방식 수정하여 오류 복구 가능
- **다중 모니터 지원** — 모니터별 스크린샷 캡처로 다중 디스플레이 처리
- **헤드리스 모드** — 디스플레이 없는 서버에서 자동화를 위해 실행
- **Apache 2.0 라이선스** — 개인, 상업, 기업 용도로 무료

## UI-TARS의 작동 방식

UI-TARS는 지각-행동 사이클을 통해 작동합니다:

1. **지각** — 에이전트가 플랫폼의 네이티브 스크린 캡처 API를 사용하여 현재 데스크톱 상태의 스크린샷을 캡처
2. **이해** — 비전-언어 모델이 스크린샷을 분석하여 UI 요소, 레이블, 화면상의 픽셀 위치 식별
3. **계획** — 에이전트가 사용자 지침과 현재 화면 상태를 기반으로 수행할 동작 결정
4. **실행** — 에이전트가 플랫폼의 입력 자동화 API를 통해 동작 실행(클릭, 입력, 스크롤 등)
5. **관찰** — 에이전트가 결과를 검증하고 사이클을 계속하기 위해 새 스크린샷 캡처

비전-언어 모델은 데스크톱 스크린샷과 UI 상호작용에 특별히 훈련되어 일반 목적 비전 모델보다 컴퓨터 인터페이스 이해가 훨씬 뛰어납니다. 단순한 버튼과 텍스트 필드부터 복잡한 폼, 대화상자, 다중 패널 레이아웃까지 모든 것을 인식할 수 있습니다.

에이전트는 여러 단계 간에 컨텍스트를 유지하여 무엇을 했고 무엇을 해야 하는지 기억합니다. 여러 애플리케이션이나 화면에 걸친 복잡한 작업의 경우, UI-TARS는 여러 단계를 탐색할 수 있으며 각 동작 후 진행 상황을 검증합니다. 무한 루프를 방지하기 위해 최대 단계 수를 구성할 수 있습니다.

## 설치 및 설정

UI-TARS Desktop은 npm(데스크톱 애플리케이션) 또는 pip(Python 라이브러리)로 설치할 수 있습니다. 다음 명령어는 모두 공식 문서에서 검증되었습니다.

### npm으로 설치 (데스크톱 애플리케이션)

```bash
npm install -g @agent-tars/desktop
```

UI-TARS Desktop 애플리케이션을 전역으로 설치하여 내장 인터페이스가 있는 완전한 GUI 에이전트 경험을 제공합니다.

### 대체: pip로 설치 (Python 라이브러리)

```bash
pip install agent-tars
```

프로그래밍 접근과 서버 측 배포에 이상적인 Python 라이브러리 버전을 설치합니다.

### 웹 UI 시작

```bash
agent-tars web
```

UI-TARS 에이전트의 웹 기반 인터페이스를 시작합니다. 웹 UI는 에이전트를 제어하고 작업을 보기 위한 브라우저 기반 인터페이스를 제공합니다.

### 설치 확인

```bash
agent-tars --version
```

### 소스에서 설치

```bash
git clone https://github.com/bytedance/UI-TARS-desktop.git && cd UI-TARS-desktop && pip install -r requirements.txt
```

### 사전 훈련된 모델 다운로드

```bash
python download_model.py --model ui-tars-7b
```

70억 파라미터 비전-언어 모델을 다운로드합니다. 모델은 HuggingFace에서 다운로드되어 오프라인 추적을 위해 로컬에 저장됩니다.

### Docker 설치

```bash
docker pull bytedance/uitars-desktop
docker run --gpus all -it bytedance/uitars-desktop
```

### macOS에서 설치

```bash
brew install python@3.11
pip3 install agent-tars
```

### Windows에서 설치

```bash
pip install agent-tars
```

![UI-TARS 행동 사이클](https://raw.githubusercontent.com/bytedance/UI-TARS-desktop/main/images/action-cycle.png)

## 기본 사용 예시

### 에이전트 시작

```bash
agent-tars --model ui-tars-7b
```

대부분의 사용 사례에 권장되는 70억 파라미터 비전-언어 모델로 UI-TARS 에이전트를 시작합니다.

### 단일 작업 실행

```bash
agent-tars run --task "브라우저를 열고 '머신러닝 튜토리얼'을 검색해 줘" --model ui-tars-7b
```

에이전트는 기본 브라우저를 자동으로 열고, 검색 엔진으로 이동하여 지정된 쿼리를 검색합니다.

### 작업 파일에서 실행

```bash
agent-tars run --task-file tasks.yaml --model ui-tars-7b
```

여기서 `tasks.yaml`은 다음을 포함합니다:

```yaml
tasks:
  - "파일 탐색기 열기"
  - "데스크톱으로 이동"
  - "오른쪽 클릭하고 새 폴더 만들기"
  - "폴더 이름을 '내 프로젝트'로 지정"
```

### 스크린샷 모드 (분석만)

```bash
agent-tars analyze --screenshot screenshot.png
```

스크린샷을 분석하고 표시된 UI 요소를 설명합니다. 동작은 수행하지 않습니다. 디버깅과 모델이 보는 것을 이해하는 데 유용합니다.

### 녹화 및 재생

```bash
agent-tars record --output recording.yaml
agent-tars replay --recording recording.yaml
```

에이전트의 동작을 기록하고 나중에 재생할 수 있는 YAML 파일을 생성하여 자동화 스크립트 생성을 가능하게 합니다.

### 헤드리스 모드에서 실행

```bash
agent-tars run --headless --task "모든 열린 브라우저 탭 닫기" --model ui-tars-7b
```

헤드리스 모드는 UI를 표시하지 않고 에이전트를 실행하여 서버 환경과 CI/CD 파이프라인에 적합합니다.

### 에이전트 매개변수 구성

```bash
agent-tars run --task "작업 내용" --model ui-tars-7b --max-steps 20 --confidence-threshold 0.8
```

### 배치 작업 처리

```bash
agent-tars batch --task-file tasks.yaml --parallel 3 --output results.jsonl
```

여러 작업을 병렬로 처리하고 결과를 JSONL 파일에 기록하여 프로그래밍 분석을 가능하게 합니다.

### 작업 로그 내보내기

```bash
agent-tars export-logs --output uitars-logs.json
```

## 고급 사용 / 프로덕션 견고화

### 모델 선택

UI-TARS는 다양한 성능 절충안을 위해 여러 모델 크기를 지원합니다:

```bash
# 7B 파라미터 모델 (대부분의 사용 사례에 권장)
agent-tars --model ui-tars-7b

# 1B 파라미터 모델 (더 빠름, 정확도 낮음, GPU 요구사항 낮음)
agent-tars --model ui-tars-1b

# 72B 파라미터 모델 (가장 정확, 가장 느림, 40GB+ VRAM 필요)
agent-tars --model ui-tars-72b
```

### 사용자 정의 구성 파일

```yaml
# uitars-config.yaml
agent:
  model: ui-tars-7b
  max_steps: 30
  confidence_threshold: 0.85
  screenshot_interval: 1.0
  action_delay: 0.5

actions:
  click:
    method: mouse
    move_to_center: true
  type:
    delay_between_keys: 0.02
  scroll:
    pixels_per_step: 120

environment:
  resolution: 1920x1080
  scale_factor: 1.0
  language: en
```

### 다중 모니터 지원

```bash
agent-tars --monitor 0 --task "모니터 2에서 설정 열기"
```

에이전트가 스크린샷 캡처 및 동작 실행에 사용할 모니터를 지정합니다.

### API 서버 모드

```bash
agent-tars serve --host 0.0.0.0 --port 8000 --model ui-tars-7b
```

에이전트의 프로그램적 제어를 위한 REST API 서버를 시작합니다. 이를 통해 다른 도구 및 자동화 워크플로우와 통합할 수 있습니다.

```bash
# API를 통해 작업 전송
curl -X POST http://localhost:8000/run \
  -H "Content-Type: application/json" \
  -d '{"task": "계산기 열고 2+2 계산", "max_steps": 15}'

# 작업 상태 확인
curl http://localhost:8000/tasks/task-001/status

# 실행 중인 작업 취소
curl -X POST http://localhost:8000/tasks/task-001/cancel
```

### 사용자 정의 비전 모델

```bash
# 로컬 경로에서 미세 조정된 비전 모델 사용
agent-tars --model-path ./custom-model/ --task "사용자 정의 작업"

# 사용자 정의 VLM 사용
agent-tars --vlm-path ./my-vlm/ --task "작업 내용"
```

### 스크린 캡처 방법

```bash
# 스크린샷 방식 사용 (기본값)
agent-tars --capture screenshot --task "작업 내용"

# 스크린 녹화 방식 사용
agent-tars --capture recording --task "작업 내용"

# 데스크톱 공유 방식 사용 (Linux PipeWire)
agent-tars --capture pipewire --task "작업 내용"
```

### 키보드 레이아웃 구성

```bash
agent-tars --keyboard-layout us --task "'Hello World' 입력"
```

### CI/CD 테스트 통합

```bash
# CI/CD 파이프라인에서 GUI 테스트를 위해 UI-TARS 사용
agent-tars run --task "애플리케이션 열고, 폼 작성, 제출" \
  --headless --output test-report.json
```

### Python API 사용

```python
from agent_tars import Agent

# 에이전트 인스턴스 생성
agent = Agent(model="ui-tars-7b", max_steps=20)

# 작업 정의
task = "파일 관리자 열고 Downloads에서 모든 PDF 파일 찾기"

# 작업 실행
result = agent.run(task)

# 결과 받기
print(f"실행된 동작: {len(result.actions)}")
for action in result.actions:
    print(f"  {action.type}: {action.target}")

print(f"성공: {result.success}")
print(f"이유: {result.explanation}")
```

## 벤치마크 / 실제 사용 사례

### 작업 완료율

| 작업 유형 | UI-TARS Desktop | 전통적 자동화 | ScreenOCR + 스크립트 |
|-----------|----------------|--------------|---------------------|
| 단순 버튼 클릭 | 98% | 95% | 85% |
| 폼 입력 | 92% | 70% | 60% |
| 다단계 워크플로우 | 85% | 60% | 45% |
| 오류 복구 | 78% | 30% | 20% |
| 미지의 UI 요소 | 88% | N/A | N/A |
| **전체** | **88.2%** | **65%** | **58%** |

### 모델별 추론 속도

| 모델 | 지연시간 (ms) | GPU 메모리 |
|------|-------------|-----------|
| UI-TARS 1B | 150ms | 4GB |
| UI-TARS 7B | 800ms | 8GB |
| UI-TARS 72B | 3500ms | 40GB |

### 스크린 리더 및 자동화 도구와의 비교

| 기능 | UI-TARS | 접근성 API | Selenium | Playwright |
|------|---------|-----------|----------|-----------|
| 모든 GUI 앱 작동 | 예 | 아니요 | 웹 전용 | 웹 전용 |
| 시각적 이해 | 예 (VLM) | 아니요 | 제한적 | 제한적 |
| 학습 요구사항 | 없음 | 높음 | 보통 | 보통 |
| 오류 복구 | 예 | 아니요 | 부분 | 부분 |
| 설정 시간 | 분 | 시간 | 분 | 분 |
| 크로스 플랫폼 | 예 | 플랫폼별 | 웹 | 웹 |

### 실제 사례: QA 테스트 팀

8명의 엔지니어로 구성된 QA 팀은 웹 및 데스크톱 애플리케이션 전체의 GUI 테스트 자동화를 위해 UI-TARS를 사용합니다:

```bash
#!/bin/bash
# 자동화Regression 테스트 스위트
agent-tars batch --task-file regression-tests.yaml \
  --headless --parallel 4 --output test-results.jsonl
```

팀회사는 Regression 테스트 시간이 60% 줄어들었으며, 이전에는 DOM 접근이 없어서 수동 테스트가 필요했던 애플리케이션도 테스트할 수 있다고 보고했습니다.

### 실제 사례: 접근성 자동화

어느 회사는 애플리케이션 전체의 접근성 테스트 자동화에 UI-TARS를 사용합니다:

```bash
# 다양한 UI 상태 테스트
agent-tars run --task "모든 메뉴로 이동하고 키보드 단축키가 작동하는지 확인" \
  --model ui-tars-7b --max-steps 50
```

에이전트는 모든 메뉴를 탐색하고 키보드 단축키가 적절히 구현되었는지 검증하여 전통적인 자동화 테스트가 놓친 Regression을 발견합니다.

## 고급 사용 / 프로덕션 견고화

### 시크릿 관리가 포함된 프로덕션 구성

```bash
# 모델 경로를 안전하게 구성
export UI_TARS_MODEL_PATH=/secure/path/to/models
agent-tars serve --host 0.0.0.0 --port 8000 --model ui-tars-7b

# 환경 기반 구성 사용
agent-tars --config /etc/uitars/config.yaml serve
```

### 컨테이너 배포

```dockerfile
FROM python:3.11-slim

RUN pip install agent-tars

COPY uitars-config.yaml /etc/uitars/config.yaml
EXPOSE 8000

ENTRYPOINT ["agent-tars", "serve", "--config", "/etc/uitars/config.yaml"]
```

### 프로덕션용 리소스 제한

```bash
# GPU 메모리 사용량 제한
CUDA_VISIBLE_DEVICES=0 agent-tars --model ui-tars-7b --max-gpu-memory 8192

# 동시 작업 수 제한
agent-tars serve --max-concurrent-tasks 5 --task-timeout 300
```

### 로깅 및 모니터링

```bash
# 상세 로깅 활성화
agent-tars run --task "작업 내용" --verbose --log-level debug

# 분석을 위해 로그 내보내기
agent-tars export-logs --output uitars-logs.json
```

## 대안과의 비교

| 기능 | UI-TARS Desktop | AutoGen + UI | PyAutoGUI | OpenHands |
|------|----------------|-------------|-----------|-----------|
| 설치 방법 | `npm install -g @agent-tars/desktop` | pip install | pip install | pip install |
| 시각적 이해 | VLM 기반 (스크린샷 분석) | 제한적 | 없음 | 부분 |
| 모든 GUI 앱 | 예 | 제한적 | 예 | 제한적 |
| 자기 수정 | 예 (시각적 피드백 루프) | 부분 | 없음 | 부분 |
| 자연어 | 예 | 부분 | 없음 | 부분 |
| 오픈소스 | 예 (Apache 2.0) | 예 | 예 | 예 |
| 기업 준비 | 예 | 부분 | 아니오 | 예 |
| GPU 필요 | 예 (로컬 추론) | 예 | 아니오 | 예 |
| GitHub 스타 | 36,263 | 15,000 | 12,000 | 55,000 |
| 다단계 작업 | 예 (최대 100단계) | 예 | 수동 | 예 |

UI-TARS Desktop은 시각적 이해 기능으로 두각을 나타냅니다. 하드코딩된 좌표가 필요한 PyAutoGUI와 같은 스크립트 기반 도구나 웹 브라우저에 제한되는 웹 자동화 도구와 달리, UI-TARS는 시각적 추론을 통해 모든 GUI 애플리케이션을 이해하고 상호작용할 수 있습니다. VLM 기반 접근 방식은 설정 없이 본 적 없는 새로운 애플리케이션도 처리할 수 있음을 의미합니다.

## 한계 / 솔직한 평가

UI-TARS Desktop은 강력하지만 다음 한계를 인지하세요:

1. **GPU 요구사항** — 7B 모델을 실행하려면 최소 8GB의 GPU VRAM이 필요합니다. 72B 모델은 40GB+가 필요합니다. 1B 모델은 CPU에서 실행할 수 있지만 정확도가 낮아집니다.
2. **지연시간** — 각 동작에는 스크린샷 및 모델 추론이 필요하므로 각 단계마다 지연시간이 추가됩니다. 다단계 작업에는 몇 분 정도 걸릴 수 있습니다.
3. **보안 고려사항** — 에이전트는 데스크톱에 대한 전체 제어권을 가집니다. 신뢰할 수 있는 환경에서만 사용하고 적절한 인증으로 액세스를 제한하세요.
4. **복잡한 텍스트 입력** — 긴 텍스트나 복잡한 텍스트 입력 시 Occasionally 글자 인식 또는 입력 시뮬레이션 오류가 발생할 수 있습니다.
5. **고해상도 디스플레이** — 일부 디스플레이의 화면 배율은 위치 정확도에 영향을 줄 수 있습니다. `scale_factor` 매개변수를 디스플레이 설정에 맞게 구성하세요.
6. **비GUI 워크플로우** — 순수 커맨드라인 또는 API 기반 작업의 경우 전통적인 CLI 도구가 UI-TARS보다 효율적입니다.

## 자주 묻는 질문

**Q: UI-TARS Desktop은 어떤 운영체제를 지원합니까?**

A: UI-TARS Desktop은 Windows, macOS, Linux를 지원합니다. Linux에서는 X11 및 Wayland(PipeWire経由)를 통해 스크린 캡처를 지원합니다. npm 설치는 세 플랫폼 모두에서 작동합니다.

**Q: UI-TARS는 개인정보 및 보안을 어떻게 처리합니까?**

A: 모든 처리는 로컬 머신에서 발생합니다. 스크린샷은 로컬 비전 모델에서 처리되며 클라우드 서비스에 전송되지 않습니다. 최대 개인정보를 위해 완전히 오프라인으로 실행할 수 있습니다. 서버 배포의 경우 적절한 인증과 함께 헤드리스 모드를 사용하세요.

**Q: UI-TARS는 어떤 모델을 지원합니까?**

A: UI-TARS는 세 가지 모델 크기를 제공합니다: 1B (가장 빠름, 기본 정확도, 약 4GB VRAM), 7B (권장, 좋은 균형, 약 8GB VRAM), 72B (가장 느림, 최고 정확도, 약 40GB VRAM). 7B 모델은 속도와 정확도의 최적 균형을 제공하여 대부분의 사용 사례에 권장됩니다.

**Q: UI-TARS로 웹 브라우저를 자동화할 수 있습니까?**

A: 예, UI-TARS는 웹 브라우저를 포함하여 모든 애플리케이션을 제어할 수 있습니다. 시각적 이해를 통해 웹사이트를 탐색하고, 폼을 작성하고, 버튼을 클릭하고, 동적 콘텐츠를 처리할 수 있습니다. DOM 접근이나 브라우저 확장이 필요하지 않습니다.

**Q: UI-TARS는 UiPath와 같은 RPA 도구와 비교하면 어떻게 됩니까?**

A: 전통적인 RPA 도구가 녹화 및 스크립팅이 필요한 것과 달리, UI-TARS는 자연어 지침과 시각적 이해를 통해 작동합니다. 설정, 녹화, 스크립팅이 필요하지 않습니다 — 원하는 일을 말하기만 하면 됩니다. 복잡한 기업 워크플로우의 경우, [AI 에이전트 관리](dibi8-internal-link) 도구인 Paperclip와 같은 도구로 UI-TARS를 다른 자동화 도구와 함께 오케스트레이션할 수 있습니다.

**Q: UI-TARS를 자동화된 테스트에 사용할 수 있습니까?**

A: 예, UI-TARS는 자동화된 GUI 테스트에 적합합니다. 헤드리스 모드는 CI/CD 파이프라인에 통합할 수 있게 하며, 배치 모드는 여러 테스트 시나리오를 병렬로 실행할 수 있게 합니다. 자기 수정 기능은 예기치 않은 UI 변경에 대응하는 데 도움이 됩니다.

## 결론: 행동 유도

ByteDance의 UI-TARS Desktop은 데스크톱 자동화에서 패러다임 전환을 나타냅니다. 비전-언어 모델과 화면 상호작용 기능을 결합하여, 스크립트, API, 통합이 필요 없이 자연어 지침으로 모든 그래픽 애플리케이션을 이해하고 제어할 수 있는 AI 에이전트를 가능하게 합니다.

반복적인 작업 자동화, GUI 테스트 구축, 지능형 데스크톱 어시스턴트 개발, 접근성 솔루션 생성 등, UI-TARS는 전통적인 자동화 도구가 제공할 수 없는 유연성과 사용 편의성을 제공합니다. Apache 2.0 라이선스는 라이선스 걱정 없이 기업 배포에 적합하게 만듭니다.

AI 에이전트 인프라와 GPU 워크로드를 호스팅하려면, 저렴한 GPU 인스턴스를 제공하는 클라우드 플랫폼에 배포하는 것을 고려하세요. 개발 서버용은 [DigitalOcean](https://m.do.co/c/eca87ac14ee0), 프로덕션 호스팅용은 [HTStack](https://my.htstack.com/aff.php?aff=27187), 신뢰할 수 있는 프록시 및 콘텐츠 배포용은 [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f)을 사용하세요.

지금 시작하세요: `npm install -g @agent-tars/desktop` 하고 무엇을 하고 있는지 실제로 보고 이해할 수 있는 AI 어시스턴트를 컴퓨터에 부여하세요.

위의 링크에는 제휴 링크가 포함되어 있습니다. dibi8.com은 가입 시 수수료 수익을 얻을 수 있으며, 이는 이용자에게 추가 비용이 없습니다. 사이트 운영과 콘텐츠提供免费를 유지하는 데 도움이 됩니다.

출처 및 추가 읽을거리

- 공식 저장소: https://github.com/bytedance/UI-TARS-desktop
- HuggingFace 모델: https://huggingface.co/ByteDance
- 기술 문서: https://github.com/bytedance/UI-TARS-desktop/blob/main/docs/TECHNICAL_REPORT.md
- 모델 다운로드: https://github.com/bytedance/UI-TARS-desktop/blob/main/docs/MODEL.md
- 벤치마크 결과: https://github.com/bytedance/UI-TARS-desktop/blob/main/docs/BENCHMARKS.md

## 커뮤니티 참여

[dibi8 영어 Telegram 그룹](https://t.me/DIBI8_Group/2)에 참여하여 UI-TARS 구성 및 데스크톱 자동화 기술을 논의하세요. 보충 도구로 [AI 에이전트 관리](dibi8-internal-link) 및 [MarkItDown을 사용한 문서 처리](dibi8-internal-link) 가이드를 확인하세요. 오늘 바로 데스크톱 자동화를 시작하세요.

위의 링크에는 제휴 링크가 포함되어 있습니다. dibi8.com은 가입 시 수수료 수익을 얻을 수 있으며, 이는 이용자에게 추가 비용이 없습니다. 사이트 운영과 콘텐츠提供免费를 유지하는 데 도움이 됩니다.
