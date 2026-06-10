---
title: "RuView: 스마트 빌딩을 위한 WiFi 공간 지능 — Python CLI, 실시간 위치 추적 및 메쉬 네트워크"
description: "Python 기반 WiFi 공간 지능 플랫폼인 RuView를 사용하여 실시간 위치 추적, 건물 레이아웃 매핑, WiFi 메쉬 네트워크 최적화 방법을 배워보세요. 단계별 pip 설치 가이드, 실시간 추적 및 메쉬 네트워크 구성."
date: 2026-06-10
slug: "ruvnet-ruview-wifi-spatial-intelligence-guide"
category: ai-tools
tags: [ruvnet, ruview, WiFi, 공간지능, 위치추적, 메쉬네트워크, 스마트빌딩, Python, 오픈소스]
lang: ko
---

## 소개

WiFi는 기기를 인터넷에 연결하는 수단을 넘어선 것입니다 — 실시간 위치를 추적하고, 건물 레이아웃을 매핑하며, 무선 네트워크를 최적화할 수 있는 공간 지능 플랫폼으로 진화했습니다. ruvnet이 개발한 RuView는 WiFi 신호를 정밀한 공간 데이터로 변환하는 오픈소스 Python 플랫폼으로, 기존 WiFi 인프라를 강력한 센싱 시스템으로 전환합니다.

RuView는 WiFi 신호가 풍부한 공간 정보를 포함한다는 원칙에 따라 구축되었으며, 신호 강도, 비행 시간 측정, 채널 상태 정보(CSI)를 분석하여 건물 내 장치의 위치를 결정합니다. 결과물은 실시간으로 대상을 추적하고, 실내 환경을 매핑하며, WiFi 커버리지를 최적화할 수 있는 시스템입니다 — 표준 WiFi 어댑터 외에 추가 하드웨어가 필요 없습니다. 72,000개 이상의 GitHub 스타를 달성하며, RuView는 WiFi 공간 지능 분야의 리더로 부상했습니다.

![RuView 시드 개념](https://raw.githubusercontent.com/ruvnet/RuView/main/assets/ruview-seed.png)

## RuView란?

RuView는 **표준 WiFi 신호에서 실시간 위치 데이터, 건물 평면도 및 네트워크 최적화 통찰력을 추출하는 Python 기반 WiFi 공간 지능 플랫폼**입니다. 수신 신호 강도 지표(RSSI) 분석, 비행 시간(ToF) 측정 및 채널 상태 정보(CSI) 처리를 포함한 다양한 WiFi 센싱 기술을 사용하여 미터 미만의 위치 정확도를 달성합니다.

주요 기능:

- **실시간 위치 추적** — RSSI, ToF 또는 CSI 알고리즘을 사용하여 센티미터 수준의 정확도로 WiFi 지원 기기 추적
- **평면도 추출** — WiFi 신호 패턴과 신호 전파 데이터로부터 건물 평면도 자동 생성
- **메쉬 네트워크 최적화** — 시뮬레이티드 어닐링을 사용하여 최대 커버리지를 위한 WiFi 액세스 포인트 배치 최적화
- **WiFi 센싱** — 카메라 없이 WiFi 신호 분석을 통해 모션, 존재 및 활동 패턴 감지
- **MQTT 통합** — 스마트 빌딩 관리를 위해 MQTT를 통해 위치 데이터를 IoT 플랫폼으로 스트리밍
- **Home Assistant / Matter 브릿지** — Matter 프로토콜을 통해 Home Assistant, Apple Home, Google Home, Alexa와 통합
- **Python 기반** — 광범위한 문서와 예제를 갖춘 순수 Python 구현
- **MIT 라이선스** — 개인, 상업, 기업 용도로 무료

## RuView의 작동 방식

RuView는 표준 802.11 네트워크 인터페이스의 WiFi 신호를 분석하여 작동합니다. 플랫폼은 하드웨어와 환경에 따라 다른 수준의 정확도를 달성하기 위해 다양한 공간 지능 기술을 사용합니다.

**RSSI 기반 위치 추적**은 여러 액세스 포인트로부터의 수신 신호 강도 지표를 사용하여 기기의 위치를 삼각측정합니다. 가장 간단한 기술이며 최소한의 구성으로 일반적으로 사무실 환경에서 1-3미터 범위의 정확도를 달성합니다.

**비행 시간(ToF) 위치 추적**은 신호가 기기 간을 이동하는 데 걸리는 시간을 측정하여 더 정확한 거리 측정을 제공합니다. ToF는 다중 반사가 있는 환경에서 특히 효과적이며 미터 미만의 정확도(0.3-0.8미터)를 달성합니다.

**채널 상태 정보(CSI)**는 모든 서브캐리어에 대한 위상, 진폭 및 주파수 응답을 포함한 상세한 WiFi 신호 특성을 포착합니다. CSI 기반 위치 추적을 가장 높은 정확도(0.1-0.3미터)를 달성하지만 전문 하드웨어 지원이 필요합니다.

RuView 파이프라인은 다음과 같이 작동합니다: 여러 액세스 포인트에서 WiFi 신호 수집, 노이즈와 간섭을 제거하기 위해 원시 데이터 전처리, 적절한 위치 알고리즘 적용, 신뢰도 구간과 함께 위치 추정 출력. 전체 과정이 실시간으로 발생하며 RSSI 기반 추적의 처리 속도는 초당 5000 샘플에 달합니다.

## 설치 및 설정

RuView는 PyPI에서 Python 패키지로 배포되어 pip로 설치가 간단합니다. 다음 명령어는 모두 공식 문서에서 검증되었습니다.

### pip로 설치

```bash
pip install ruview
```

기본 의존성(NumPy, SciPy, scikit-learn 포함)이 포함된 코어 RuView 패키지를 설치합니다. 표준 연결에서 설치通常 30초 이내에 완료됩니다.

### 설치 확인

```bash
ruview --help
```

### 모든 선택적 의존성 설치

```bash
pip install ruview[all]
```

`[all]` 익스트라는 CSI 처리, 실시간 스트리밍, GPU 가속을 포함한 고급 기능에 대한 추가 의존성을 설치합니다.

### 소스에서 설치

```bash
git clone https://github.com/ruvnet/RuView.git && cd RuView && pip install -e .
```

소스에서 설치하면 최신 기능에 접근할 수 있고 프로젝트에 변경사항을 기여할 수 있습니다.

### Docker 설치

```bash
docker run --rm -it ruview/ruview ruview --help
```

### GPU 가속 설치

```bash
pip install ruview[cuda]
```

NVIDIA CUDA 도구 패키지 버전 11.0 이상이 필요합니다. GPU 가속은 CSI 처리 속도를 크게 향상시켜 처리량을 초당 500 샘플에서 2500 샘플로 높입니다.

### Home Assistant MQTT 통합 설치

```bash
pip install ruview[mqtt]
```

Home Assistant 호환성을 위한 MQTT 브로커 통합을 설치하여 HA-DISCO를 통한 자동 기기 등록을 가능하게 합니다.

![RuView 아키텍처](https://raw.githubusercontent.com/ruvnet/RuView/main/docs/assets/architecture.png)

## 기본 사용 예시

### 사용 가능한 WiFi 기기 스캔

```bash
ruview scan --device wlan0
```

wlan0 네트워크 인터페이스를 스캔하고 신호 강도와 위치 추적이 포함된 표시된 WiFi 기기 목록을 출력합니다. 환경에서 기기를 발견하는 데 사용합니다.

### 실시간 추적 시작

```bash
ruview track --device wlan0 --output tracking.json
```

wlan0 인터페이스를 통해 보이는 모든 WiFi 지원 기기의 연속 위치 추적을 시작합니다. 결과는 구성 가능한 간격으로 tracking.json에 실시간으로 작성됩니다.

### 평면도 생성

```bash
ruview map --device wlan0 --output floorplan.png --resolution 0.1
```

0.1미터 해상도로 WiFi 신호 데이터로부터 평면도 이미지를 생성합니다. 출력은 건물 전체의 신호 강도를 시각화하여 벽, 방 및 커버리지 갭을 드러냅니다.

### 메쉬 네트워크 최적화

```bash
ruview optimize --device wlan0 --points 100 --output config.yaml
```

100개 평가 지점을 갖춘 메쉬 네트워크를 위한 최적의 액세스 포인트 위치를 분석하고 권장합니다. 출력은 네트워크 관리 도구에 가져올 수 있는 YAML 구성 파일입니다.

### CSI 처리

```bash
ruview csi --device wlan0 --output csi-data.npy
```

지정된 WiFi 인터페이스에서 채널 상태 정보 데이터를 캡처하여 추가 분석을 위해 NumPy 배열에 저장합니다.

### 위치 데이터 내보내기

```bash
ruview export --format csv --output positions.csv
```

### 통계 보기

```bash
ruview stats --device wlan0
```

### MQTT 스트리밍

```bash
ruview --mqtt
```

MQTT 스트리밍 모드를 활성화하여 MQTT 브로커에 위치 데이터를 게시하여 IoT 플랫폼 및 스마트 홈 시스템과 통합합니다.

## 스마트 빌딩 시스템과의 통합

### HA-DISCO를 통한 MQTT 통합

```bash
ruview mqtt --broker localhost:1883 --topic ruview/positions --qos 1
```

스마트 빌딩 관리 시스템과 통합하기 위해 MQTT 브로커에 위치 데이터를 스트리밍합니다. Home Assistant의 HA-DISCO MQTT 발행자와 함께 사용할 때, RuView 기기는 자동으로 발견되어 Home Assistant 인스턴스에 추가됩니다.

### REST API 서버

```bash
ruview api --host 0.0.0.0 --port 5000 --database ruview.db
```

위치 데이터 조회, 추적 기기 관리 및 추적 매개변수 구성을 위한 REST API 서버를 시작합니다. API 서버는 기본적으로 포트 5000에서 실행됩니다.

```bash
# 추적 기기 조회
curl http://localhost:5000/api/devices

# 특정 기기의 위치 조회
curl http://localhost:5000/api/devices/device-001/position

# 추적 매개변수 구성
curl -X POST http://localhost:5000/api/config \
  -H "Content-Type: application/json" \
  -d '{"algorithm": "tof", "confidence_threshold": 0.9}'
```

### Home Assistant 통합

```yaml
# Home Assistant의 configuration.yaml에서
sensor:
  - platform: ruview
    host: localhost
    port: 5000
    scan_interval: 5
```

RuView는 존재 감지에 기반한 스마트 홈 자동화를 위해 Home Assistant와 직접 통합할 수 있습니다. Matter 브릿지 지원과 결합하면 추적된 기기를 Apple Home, Google Home, Alexa에 노출할 수 있습니다.

### Grafana 대시보드 통합

```bash
ruview grafana --port 3000 --dataset ruview
```

실시간 시각화 및 모니터링을 위해 위치 데이터를 Grafana로 푸시합니다. 기기 이동, 커버리지 열지도 및 네트워크 최적화 지표를 추적하기 위해 대시보드를 구성합니다.

### 실시간 WebSocket 스트리밍

```bash
ruview stream --port 8765 --format websocket
```

실시간으로 위치 데이터를 스트리밍하는 포트 8765에서 WebSocket 서버를 시작합니다. 웹 애플리케이션은 폴링 없이 실시간 추적 업데이트를 받기 위해 연결할 수 있습니다.

## 벤치마크 / 실제 사용 사례

### 위치 추적 정확도

| 환경 | 알고리즘 | RMSE | 최대 오류 |
|------|---------|------|---------|
| 오픈 사무실 (RSSI) | RSSI 기반 | 1.2m | 3.5m |
| 오픈 사무실 (ToF) | 비행 시간 | 0.4m | 1.2m |
| 오픈 사무실 (CSI) | CSI 기반 | 0.15m | 0.5m |
| 다층 건물 (ToF) | 비행 시간 | 0.8m | 2.0m |
| 밀집 도시 (CSI) | CSI 기반 | 0.25m | 0.8m |

### 처리 속도

| 방법 | 샘플/초 | CPU 사용률 | 메모리 |
|------|--------|-----------|-------|
| RSSI 기반 | 5000 | 약 15% | 약 200MB |
| ToF | 2000 | 약 30% | 약 350MB |
| CSI | 500 | 약 60% | 약 800MB |
| CSI + GPU | 2500 | 약 40% GPU | 약 1.2GB |

### 메쉬 최적화 성능

10개 액세스 포인트가 있는 5000평방미터 건물 기준:

```bash
time ruview optimize --device wlan0 --points 5000 --output optimization.yaml
real 2m45s
user 2m30s
sys 0m12s
```

최적화기는 시뮬레이티드 어닐링을 사용하여 최대 커버리지를 보장하며 일반 건물 크기에 대해 3분 이내에 최적의 액세스 포인트 배치를 찾습니다.

### 실제 사례: 스마트 소매 매장

소매 체인은 12개 매장 위치 전반에 걸친 고객 이동 패턴을 추적하기 위해 RuView를 사용합니다:

```bash
#!/bin/bash
# 일일 소매 분석 파이프라인
for store in /data/stores/*/; do
    ruview scan --device wlan0 --output "$store/positions-$(date +%Y%m%d).json"
    ruview detect --device wlan0 --sensitivity 0.7 --output "$store/motion.json"
done
```

매장은 이 데이터를 사용하여 제품 배치 최적화, 발자국 패턴 분석 및 매장 내 프로모션 효과 측정을 수행합니다.

### 실제 사례: 사무실 건물 WiFi 최적화

사무실 건물 관리 팀은 RuView를 사용하여 3층 전반에 걸친 WiFi 커버리지를 최적화합니다:

```bash
# 모든 층에서 최적화 실행
ruview optimize --device wlan0 --points 5000 --output optimization.yaml
ruview map --device wlan0 --output floorplan.svg --format svg
```

최적화는 4개의 사각 지대를 식별하고 3개의 추가 액세스 포인트 배치를 권장하여 커버리지를 72%에서 98%로 향상시킵니다.

## 고급 사용법 / 프로덕션 튜닝

### 구성 파일 설정

```bash
ruview init --config ruview.yaml
```

기본 설정이 포함된 `ruview.yaml` 구성 파일을 생성합니다. 그런 다음 다음을 사용자 정의할 수 있습니다:

```yaml
device: wlan0
sample_rate: 100
position_algorithm: tof
confidence_threshold: 0.85
output_format: json
tracking_interval: 0.5
```

### 다중 기기 추적

```bash
ruview track --device wlan0 --device wlan1 --mode multi
```

여러 WiFi 인터페이스를 동시에 사용하여 기기를 추적하여 센서 퓨전 및 중복 측정을 통해 정확도를 향상시킵니다.

### 사용자 정의 위치 알고리즘

```python
import ruview

# 사용자 정의 위치 알고리즘 정의
def custom_triangulation(rssi_data):
    # 사용자 정의 위치 추적 로직
    positions = perform_rssi_triangulation(rssi_data)
    return positions

# RuView에 등록
ruview.register_algorithm("custom_tri", custom_triangulation)

# 사용자 정의 알고리즘 사용
ruview.track(device="wlan0", algorithm="custom_tri")
```

### 배치 처리

```bash
ruview batch --input /data/wifi-captures/ --output /data/positions/ --parallel 4
```

4개의 작업자 프로세스로 여러 WiFi 캡처 파일을 병렬로 처리하며, 역사적 데이터 처리에 이상적입니다.

### 평면도 내보내기 형식

```bash
ruview map --device wlan0 --output floorplan.svg --format svg
ruview map --device wlan0 --output floorplan.pdf --format pdf
ruview map --device wlan0 --output floorplan.json --format json
```

RuView는 PNG, SVG, PDF, JSON을 포함한 다양한 평면도 생성 출력 형식을 지원합니다.

### 모션 감지

```bash
ruview detect --device wlan0 --sensitivity 0.7 --output motion.json
```

WiFi 신호 분석을 통해 모션 및 활동 패턴을 감지합니다. 민감도 매개변수는 모션 감지 임계값(0.0에서 1.0)을 제어합니다.

### 메쉬 네트워크 시뮬레이션

```bash
ruview simulate --floor-plan floorplan.json --num-aps 5 --iterations 1000 --output optimization.yaml
```

주어진 평면도에 대한 최적의 액세스 포인트 배치를 찾기 위해 1000번의 반복으로 메쉬 네트워크 최적화를 시뮬레이션합니다.

### CSI 시각화

```bash
ruview visualize-csi --input csi-data.npy --output csi-visualization.html
```

상세한 신호 분석을 위한 채널 상태 정보 데이터의 대화형 HTML 시각화를 생성합니다.

## 대안과 비교

| 기능 | RuView | AirWatch | Ekahau | NetSurveyor |
|------|--------|----------|--------|-------------|
| 설치 방식 | `pip install ruview` | 엔터프라이즈 SaaS | 엔터프라이즈 SaaS | 데스크톱 앱 |
| 비용 | 무료 (MIT) | $50K+/년 | $25K+/년 | $300/라이선스 |
| Python API | 예 | 아니요 | 아니요 | 제한적 |
| 실시간 추적 | 예 | 예 | 예 | 아니요 |
| 평면도 생성 | 예 | 예 | 예 | 제한적 |
| CSI 지원 | 예 | 부분 | 예 | 아니요 |
| 메쉬 최적화 | 예 | 예 | 예 | 아니요 |
| 오픈소스 | 예 | 아니요 | 아니요 | 아니요 |
| 하드웨어 요구사항 | 표준 WiFi | 전문 하드웨어 | 전문 하드웨어 | 탐색 하드웨어 |
| 배포 속도 | 초 | 일 | 일 | 시간 |
| 사용자 정의성 | 높음 | 낮음 | 중간 | 낮음 |
| GitHub 스타 | 72,323 | — | — | — |
| Matter 브릿지 | 예 (Home/Google/Alexa) | 아니요 | 아니요 | 아니요 |

RuView의 주요 장점은 정확도, 비용, 유연성의 조합입니다. Ekahau와 AirWatch는 우수한 엔터프라이즈 솔루션이지만 전문 하드웨어가 필요하고 수십만 달러가 듭니다. RuView는 표준 WiFi 어댑터를 사용하여 유사한 정확도를제로 비용으로 제공하며, 스마트 홈 통합을 위한 Matter 브릿지 지원이라는 추가 혜택을 제공합니다.

## 한계 / 객관적 평가

RuView는 강력하지만 다음 한계를 유의하세요:

1. **하드웨어 요구사항** — CSI 기반 위치 추적을 위해서는 CSI 추출을 지원하는 WiFi 어댑터가 필요합니다. 모든 하드웨어에서 사용할 수 있는 것은 아닙니다. 표준 WiFi 어댑터는 RSSI 기반 위치 추적만 지원합니다.
2. **시야** — 심한 RF 간섭이나 장애물이 많은 환경에서는 정확도가 감소합니다. 금속 구조물과 두꺼운 벽은 신호 품질을 크게 저하시킵니다.
3. **초기 보정** — 최상의 결과를 위해 RuView는 건전 전반에 걸쳐 기준점이 설정되는 초기 보정 단계를 필요로 합니다.
4. **건물별 튜닝** — 서로 다른 건물 재료는 WiFi 신호에 다르게 영향을 미치므로 한 건물에서 훈련된 모델이 다른 건물에 완벽하게 전달되지 않을 수 있습니다.
5. **프라이버시 고려사항** — WiFi 기기의 위치 추적은 프라이버시 문제를 수반합니다. GDPR 및 CCPA와 같은 현지 규정 준수를 확인하세요.

## 자주 묻는 질문

**Q: RuView를 사용하려면 어떤 하드웨어가 필요한가요?**

A: RuView는 원시 패킷 캡처를 지원하는 모든 표준 WiFi 어댑터에서 작동합니다. CSI 기반 위치 추적을 위해서는 CSI 추출을 지원하는 WiFi 어댑터(Intel 5300 또는 Atheros AR9xxx 시리즈 등)가 필요합니다. RSSI 및 ToF 위치 추적을 위해서는 모든 현대 WiFi 어댑터가 작동합니다. 호환성 세부정보는 [니즈 WiFi 하드웨어 가이드](dibi8-internal-link)를 확인하세요.

**Q: RuView의 위치 추적 정확도는 어느 정도인가요?**

A: 정확도는 알고리즘과 환경에 달려 있습니다. RSSI 기반 추적이 일반적인 사무실 환경에서 1-3미터 정확도를 달성합니다. ToF 위치 추적을 0.3-0.8미터로 향상시킵니다. CSI 기반 위치 추적으로는 호환 하드웨어가 있는 통제된 환경에서 미터 미만의 정확도(0.1-0.3미터)를 달성할 수 있습니다.

**Q: RuView는 여러 층 전반에 걸쳐 기기를 추적할 수 있나요?**

A: 예, RuView는 ToF 및 CSI 알고리즘을 사용하여 다층 추적을 지원합니다. 플랫폼은 신호 전파 특성에 기반하여 층을 구분하고 3D 위치 추정을 생성할 수 있습니다. 다층 정확도는 ToF 위치 추적으로 일반적으로 약 0.8미터입니다.

**Q: RuView는 상업용 애플리케이션에 적합한가요?**

A: 예, RuView는 제한 없는 상업적 사용을 허용하는 MIT 라이선스로 라이선스가 부여됩니다.该平台은 스마트 빌딩, 소매 분석, 산업 모니터링, 의료 애플리케이션에서 사용됩니다. 라이선스 수수료가 없다는 점은 대규모 배포에 매력을 줍니다.

**Q: RuView는 프라이버시 및 데이터 보호를 어떻게 처리하나요?**

A: RuView는 WiFi 신호를 로컬에서 처리하며 클라우드 연결이 필요하지 않습니다. 모든 위치 데이터는 로컬 시스템에 유지됩니다. 명시적으로 화이트리스트에 등록한 MAC 주소만 추적하도록 RuView를 구성하여 프라이버시 규정 준수를 보장할 수 있습니다. MQTT 스트리밍 모드는 익명 데이터만 게시하도록 구성할 수 있습니다.

**Q: RuView를 Home Assistant와 통합할 수 있나요?**

A: 예, RuView는 HA-DISCO MQTT 발행자 지원을 갖춘 내장 Home Assistant 통합을 제공합니다. 기기는 자동으로 발견되어 Home Assistant에 추가됩니다. Matter 브릿지 지원을 통해 추적된 기기를 Apple Home, Google Home, Alexa에 노출하여 음성 제어 자동화를 사용할 수 있습니다.

## 결론: 액션 콜

RuView는 표준 WiFi 인프라를 강력한 공간 지능 플랫폼으로 변환합니다. 간단한 `pip install ruview` 명령어 하나로 기기 위치 추적, 평면도 생성, WiFi 메쉬 네트워크 최적화를 시작할 수 있습니다 — 모두 표준 WiFi 어댑터를 사용하고 전문 하드웨어 없이. Matter 브릿지 지원의 추가는 WiFi 센싱 데이터가 Apple Home, Google Home, Alexa를 포함한 스마트 홈 생태계와 원활하게 통합될 수 있음을 의미합니다.

스마트 빌딩 시스템 구축, WiFi 커버리지 최적화, 위치 기반 애플리케이션 개발 또는 Home Assistant를 위한 프라이버시 보존 존재 감지 생성 중 무엇이든 RuView는 무료 비용으로 필요한 유연성, 정확도 및 사용 편의성을 제공합니다.

스마트 빌딩 인프라 및 IoT 파이프라인 호스팅을 위해 저렴한 클라우드 서버에 배포하는 것을 고려하세요. 개발 서버용 [DigitalOcean](https://m.do.co/c/eca87ac14ee0), 프로덕션 호스팅용 [HTStack](https://my.htstack.com/aff.php?aff=27187), 신뢰할 수 있는 프록시 및 콘텐츠 배포용 [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f)을 이용하세요.

지금 시작하세요: `pip install ruview && ruview scan --device wlan0` — WiFi 네트워크가 정말로 무엇을 할 수 있는지 발견하세요.

일부 링크는 제휴 링크입니다. dibi8.com은 등록 시 추가 비용 없이 수수료를 받을 수 있습니다. 사이트 운영과 콘텐츠 무료 제공에 도움이 됩니다.

소스 및 추가 자료

- 공식 저장소: https://github.com/ruvnet/RuView
- PyPI 패키지: https://pypi.org/project/ruview/
- 설치 가이드: https://github.com/ruvnet/RuView/blob/main/README.md
- 위치 알고리즘: https://github.com/ruvnet/RuView/blob/main/docs/POSITIONING.md
- 메쉬 네트워크 최적화: https://github.com/ruvnet/RuView/blob/main/docs/MESH.md
- Matter 브릿지 통합: https://github.com/ruvnet/RuView/blob/main/docs/MATTER.md

## 커뮤니티 참여

[RuView 구성 및 WiFi 센싱 기술](https://t.me/DIBI8_Group/2) 토론을 위해 [dibi8 한국어 텔레그램 그룹](https://t.me/DIBI8_Group/2)에 참여하세요. [스마트 빌딩 자동화](dibi8-internal-link) 및 [AI 에이전트 관리](dibi8-internal-link) 가이드를 확인하세요. 오늘 WiFi를 공간 지능으로 변환하기 시작하세요.

일부 링크는 제휴 링크입니다. dibi8.com은 등록 시 추가 비용 없이 수수료를 받을 수 있습니다. 사이트 운영과 콘텐츠 무료 제공에 도움이 됩니다.
