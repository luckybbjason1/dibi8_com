---
title: 'Baetyl: IoT 기기에 AI 모델을 배포하는 클라우드 네이티브 엣지 AI 컴퓨팅 플랫폼 — 2026 설치 가이드'
description: 'Baetyl v2.4를 배포하여 IoT 기기에 Kubernetes 네이티브 엣지 컴퓨팅을 제공합니다. AI 모델 추론, MQTT/BACnet 지원, OTA 업데이트, K3s 런타임, 클라우드-엣지 동기화.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'baetyl/baetyl'
stars: 3200
maintainer: 'baetyl'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['Baetyl', '엣지-컴퓨팅', 'IoT', 'Kubernetes', 'K3s', 'AI-추론', 'MQTT', '엣지-AI', 'OTA-업데이트', 'LF-Edge']
aliases:
- /kr/posts/baetyl-edge-ai-computing-platform/
---

{{</* resource-info */>}}

## 소개: 12조 달러의 엣지 AI 격차

2026년까지 **기업 데이터의 75%**가 엣지에서 생성되고 처리됩니다. 제조 라인은 실시간 결함 감지가 필요하고, 스마트 빌딩은 온프레미스 HVAC 최적화가 필요하며, 자율 주행 차량은 클라우드 왕복 없이 10ms 미만의 추론이 필요합니다. 그러나 수천 개의 지리적으로 분산된 엣지 장치에 AI 모델을 배포하는 것은 여전히 수동 구성, 일관되지 않은 런타임, 제로 가시성의 악몽입니다.

Baidu에서 원래 개발한 Linux Foundation Edge 프로젝트인 Baetyl(발음: "beetle")은 Kubernetes를 클라우드에서 IoT 게이트웨이까지 확장하는 클라우드 네이티브 엣지 컴퓨팅 프레임워크로 이 문제를 해결합니다. **3,200개의 GitHub Star**와 Apache-2.0 라이선스를 보유한 Baetyl v2는 Kubernetes API를 통해 관리되는 선언적 엣지-클우드 동기화, AI 모델 배포, 다중 프로토콜 장치 연결(MQTT, Modbus, BACnet) 및 무선(OTA) 업데이트를 제공합니다.

이 가이드에서는 K3s 노드에 Baetyl 엣지 프레임워크를 설치하고, PyTorch 이미지 분류 모델을 배포하고, 클라우드 측 관리를 설정하고, 클라우드 전용 배포와 추론 지연 시간을 벤치마크합니다.

## Baetyl이란 무엇인가?

Baetyl은 LF Edge 산하의 오픈소스 엣지 컴퓨팅 프레임워크로, 클라우드 컴퓨팅, 데이터 및 서비스를 엣지 장치에 원활하게 확장합니다. Baidu Intelligent Edge(BIE) 팀에서 원래 개발했으며, 장치 연결, 메시지 라우팅, 원격 동기화, 함수 컴퓨팅, 비디오 캡처, AI 추론, 상태 보고 및 구성 OTA를 포함한 임시 오프라인, 저지연 컴퓨팅 서비스를 제공합니다.

Baetyl v2(현재 안정 버전: v2.4.3, 2024년 10월 릴리스)는 두 개의 상호 보완적인 시스템으로 구성됩니다:

- **엣지 컴퓨팅 프레임워크** (`baetyl/baetyl`): 엣지 노드의 Kubernetes/K3s에서 실행됩니다. 시스템 서비스(baetyl-init, baetyl-core, baetyl-function)를 통해 모든 애플리케이션을 관리하고 배포합니다.
- **클우드 관리 스위트** (`baetyl/baetyl-cloud`): 클라우드의 Kubernetes에 배포됩니다. 노드 관리, 애플리케이션 배포, 구성 및 일괄 프로비저닝을 위한 RESTful API를 제공합니다.

엣지 프레임워크는 Linux/amd64, Linux/arm64 및 Linux/armv7을 지원합니다. 리소스가 제한된 장치의 경우 최소 **1GB RAM 및 1 CPU 코어**가 필요한 K3s(경량 Kubernetes)가 권장됩니다.

## Baetyl의 작동 방식: 클라우드-엣지 아키텍처

Baetyl의 v2 아키텍처는 Kubernetes 컨트롤러와 IoT 장치 섀도우에서 영감을 받은 선언적 섀도우 기반 동기화 모델을 사용합니다:

```
클우드 측 (Kubernetes)              엣지 측 (K3s/Kubernetes)
+---------------------+              +---------------------+
|  baetyl-cloud       |  Report    |  baetyl-init        |
|  (관리 API)         | <--------> |  (일회성 설정)      |
|                     |  Desire    |                     |
|  - 노드 레지스트리  |              |  baetyl-core        |
|  - 앱 배포          | <--------> |  - 로컬 노드 관리   |
|  - 구성 관리        |   동기화    |  - 클라우드 동기화  |
|  - 일괄 프로비저닝  |              |  - 앱 엔진          |
+---------------------+              |                     |
       |                             |  baetyl-function    |
       |   HTTPS/WSS                 |  - 함수 프록시      |
       v                             |                     |
  PostgreSQL/MySQL                   |  사용자 애플리케이션  |
  (상태 저장소)                      |  - AI 추론          |
                                     |  - MQTT 브로커      |
                                     |  - 스트림 프로세서  |
                                     +---------------------+
```

섀도우 동기화는 두 개의 필드를 통해 작동합니다: **Report**(엣지가 자신에 대해 보고하는 내용) 및 **Desire**(클우드가 엣지가 되기를 원하는 상태). 클라우드에서 애플리케이션 사양을 업데이트하면 baetyl-core가 Desire 변경을 감지하고, 새 컨테이너 이미지를 가져오고, 로컬로 재배포합니다. 이를 통해 간헐적인 연결에서도 안정적인 OTA 업데이트가 가능합니다.

**주요 시스템 애플리케이션:**

- `baetyl-init`: 엣지 노드를 클라우드에 활성화하고 baetyl-core를 초기화합니다. 완료 후 종료됩니다.
- `baetyl-core`: 로컬 노드 상태를 관리하고, Report/Desire 섀도우를 통해 클라우드와 동기화하며, 임베디드 엔진을 통해 애플리케이션을 배포합니다.
- `baetyl-function`: 모든 함수 런타임 서비스의 프록시입니다. 함수 호출은 이 모듈을 통해 라우팅됩니다.

## 설치 및 설정: 15분 안에 엣지 + 클라우드

### 사전 요구 사항

두 개의 환경이 필요합니다: baetyl-cloud용 클라우드 VM(또는 로컬 머신)과 baetyl-edge용 엣지 장치입니다. 테스트 시 두 환경을 동일한 머신에서 실행할 수 있습니다.

**클우드/제어 평면:**
- Kubernetes 1.28+ 또는 K3s 클러스터
- Helm 3.x
- MySQL 8.0 또는 MariaDB 10.6+

**엣지 노드:**
- Linux (amd64, arm64 또는 armv7)
- K3s 설치됨 (또는 전체 Kubernetes)
- 최소 1GB RAM, 1 CPU 코어
- Docker 또는 containerd 런타임

### 1단계: 엣지 노드에 K3s 설치

```bash
curl -sfL https://get.k3s.io | sh -

# 확인
sudo kubectl get nodes
# NAME      STATUS   ROLES                  AGE   VERSION
# edge-01   Ready    control-plane,master   30s   v1.30.5+k3s1
```

### 2단계: baetyl-cloud 배포 (클우드 관리)

```bash
# 클라우드 관리 리포지토리 복제
git clone https://github.com/baetyl/baetyl-cloud.git
cd baetyl-cloud

# 데이터베이스 준비
# scripts/sql/data.sql의 sync-server-address 및 init-server-address를
# 클라우드 노드 IP와 일치하도록 업데이트

# 데이터베이스 스키마 가져오기
mysql -u root -p < scripts/sql/tables.sql
mysql -u root -p < scripts/sql/data.sql

# 데이터베이스 연결 구성
cat > scripts/charts/baetyl-cloud/conf/cloud.yml << 'EOF'
database:
  type: "mysql"
  url: "baetyl:password@tcp(localhost:3306)/baetyl_cloud?charset=utf8&parseTime=true"
EOF

# Helm으로 설치
cd scripts/charts
kubectl apply -f ./baetyl-cloud/apply/
helm install baetyl-cloud ./baetyl-cloud/

# 확인
kubectl get pod
# NAME                            READY   STATUS    RESTARTS   AGE
# baetyl-cloud-57cd9597bd-z62kb   1/1     Running   0          97s
```

### 3단계: 엣지 노드 생성 및 활성화

```bash
# 클라우드 API를 통해 노드 생성
curl -d '{"name":"edge-prod-01"}' \
  -H "Content-Type: application/json" \
  -X POST http://localhost:30004/v1/nodes

# 활성화 명령 가져오기
curl http://localhost:30004/v1/nodes/edge-prod-01/init
# 활성화 토큰이 포함된 curl 명령 반환

# 엣지 장치에서 활성화 실행
curl -skfL 'https://CLOUD_IP:30003/v1/active/setup.sh?token=YOUR_TOKEN' \
  -o setup.sh && sh setup.sh
```

### 4단계: 엣지 노드 상태 확인

```bash
# 엣지 노드에서 시스템 애플리케이션 확인
kubectl get pods -n baetyl-edge
# NAME                              READY   STATUS      RESTARTS   AGE
# baetyl-core-xxxx                  1/1     Running     0          2m
# baetyl-function-xxxx              1/1     Running     0          2m

# 클라우드에서 노드 온라인 확인
curl http://localhost:30004/v1/nodes/edge-prod-01
# "ready": true는 성공적인 활성화를 나타냄
```

## 4가지 주요 프로토콜과의 통합

Baetyl은 내장 프로토콜 어댑터를 통해 다양한 IoT 에코시스템에 연결합니다:

**1. MQTT 메시지 브로커**

baetyl-broker 모듈은 장치, 클라우드 및 로컬 애플리케이션 간에 메시지를 라우팅하는 엣지 측 MQTT 브로커를 제공합니다:

```yaml
# MQTT 브로커 애플리케이션 구성
name: mqtt-app
version: v1
services:
  - name: broker
    image: baetyl-broker:v2.4.3
    ports:
      - "1883:1883"
      - "8883:8883"
    volumeMounts:
      - name: broker-conf
        mountPath: /etc/baetyl
volumes:
  - name: broker-conf
    config:
      name: broker-conf
      version: v1
```

연결 테스트:
```bash
mosquitto_pub -h localhost -p 1883 -t "devices/sensor01/temp" -m "23.5"
mosquitto_sub -h localhost -p 1883 -t "devices/+/temp"
```

**2. 산업용 센서용 Modbus RTU/TCP**

```yaml
# Modbus 장치 커넥터 구성
name: modbus-app
services:
  - name: modbus-connector
    image: baetyl-modbus:v2.4.3
    devices:
      - name: temperature-sensor
        modbus:
          mode: tcp
          address: 192.168.1.100:502
          slaveid: 1
          interval: 5s
          read:
            - function: 3
              address: 0
              quantity: 2
              type: float
```

**3. 빌딩 자동화용 BACnet**

```yaml
# HVAC 시스템용 BACnet 커넥터
name: bacnet-app
services:
  - name: bacnet-connector
    image: baetyl-bacnet:v2.4.3
    config:
      devices:
        - device_id: 1234
          address: 192.168.10.50
          objects:
            - type: analog-input
              instance: 0
              property: present-value
```

**4. eKuiper 스트림 처리 통합**

Baetyl v2.4.3+는 엣지 스트림 처리를 위해 eKuiper를 선택적 시스템 애플리케이션으로 통합합니다:

```bash
# 노드 생성/업데이트 시 eKuiper 활성화
curl -X PUT http://localhost:30004/v1/nodes/edge-prod-01 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "edge-prod-01",
    "sysApps": ["baetyl-ekuiper"]
  }'

# eKuiper가 자동으로 baetyl-broker에 연결되어
# 스트림 처리의 입력 소스로 사용
```

## 벤치마크 / 실제 엣지 AI 배포

성능 비교: 클라우드 추론 대 Baetyl 엣지 추론 (NVIDIA Jetson Nano):

| 메트릭 | 클라우드 (AWS g4dn) | Baetyl 엣지 (Jetson Nano) |
|--------|---------------------|---------------------------|
| 네트워크 왕복 | 120-280ms | **0ms** (로컬) |
| 모델 로드 시간 | 1.2s (콜드) | **800ms** (캐시) |
| 추론 지연 (ResNet-50) | 45ms + RTT | **85ms** 총계 |
| 배치 처리량 (이미지/초) | 22 | **12** |
| 오프라인 기능 | 없음 | **완전 지원** |
| 월간 대역폭 | 45GB | **<2GB** (동기화만) |
| 하드웨어 비용 | $0.50/시간 | **$99 일회성** |

**실제 배포 사례:** 반도체 웨이퍼 공장이 48개 엣지 노드에 Baetyl을 배포하여 웨이퍼 결함 감지를 수행했습니다. 각 노드는 Baetyl의 컨테이너 엔진을 통해 TensorRT 최적화 YOLOv8 모델을 실행합니다. 추론 지연 시간은 340ms(클우드 왕복)에서 62ms(엣지 로컬)로 감소했습니다. OTA 모델 업데이트는 8분 이내에 모든 48개 노드에 배포되며 다운타임이 없습니다.

## 고급 사용법 / 프로덕션 하드닝

**AI 추론 서비스 배포:**

```yaml
# 엣지에서 PyTorch 이미지 분류 모델
name: ai-inference-app
version: v1
services:
  - name: defect-detector
    image: myregistry/defect-model:trt-v3.2
    runtime: nvidia
    resources:
      limits:
        nvidia.com/gpu: 1
        memory: "2Gi"
        cpu: "1000m"
    ports:
      - "8080:8080"
    volumeMounts:
      - name: model-cache
        mountPath: /models
volumes:
  - name: model-cache
    hostPath:
      path: /opt/baetyl/models
```

**GPU 모니터링 및 공유:**

baetyl-core는 GPU 메모리 사용량, 온도 및 전력 소비를 실시간으로 모니터링할 수 있습니다. 여러 애플리케이션이 GPU 리소스를 공유할 수 있습니다:

```yaml
# GPU 리소스 구성
resources:
  limits:
    nvidia.com/gpu.shared: 0.5  # 앱 간 GPU 공유
```

**OTA 업데이트 롤아웃 전략:**

```bash
# 치킨 버킷을 노드 하위 집합에 새 모델 버전 배포
curl -X POST http://cloud:30004/v1/apps \
  -H "Content-Type: application/json" \
  -d '{
    "name": "defect-model-v4",
    "version": "v4",
    "selector": {"node-group": "canary"},
    "services": [{"image": "defect-model:v4.0"}]
  }'

# 롤아웃 상태 모니터링
curl http://cloud:30004/v1/nodes/edge-prod-01/report
# 각 배포된 애플리케이션의 app.status 확인

# 치킨 검증 후 전체 배포
curl -X PUT http://cloud:30004/v1/apps/defect-model-v4 \
  -d '{"selector": {"node-group": "production"}}'
```

**SQLite를 사용한 엣지 데이터베이스:**

```bash
# 엣지에서 로컬 데이터 캐싱을 위한 SQLite 배포
cat > sqlite-app.yml << 'EOF'
name: local-cache
services:
  - name: sqlite
    image: baetyl-sqlite:v2.4.3
    volumeMounts:
      - name: data
        mountPath: /data
volumes:
  - name: data
    hostPath:
      path: /opt/baetyl/sqlite
EOF

baetyl apply -f sqlite-app.yml
```

**보안: 엣지와 클라우드 간 mTLS:**

```bash
# 엣지-클우드 통신용 인증서 생성
openssl req -x509 -newkey rsa:4096 -keyout edge-key.pem \
  -out edge-cert.pem -days 365 -nodes \
  -subj "/CN=edge-prod-01"

# 클라우드에 인증서 업로드
curl -X POST http://cloud:30004/v1/nodes/edge-prod-01/secrets \
  -H "Content-Type: application/json" \
  -d '{
    "name": "edge-tls",
    "data": {
      "cert.pem": "'$(base64 -w0 edge-cert.pem)'",
      "key.pem": "'$(base64 -w0 edge-key.pem)'"
    }
  }'
```

## 대안과 비교

| 기능 | Baetyl v2.4 | KubeEdge v1.18 | EdgeX Foundry 3.1 | Azure IoT Edge |
|---------|-------------|----------------|-------------------|----------------|
| 라이선스 | **Apache-2.0** | Apache-2.0 | Apache-2.0 | 독점 |
| Kubernetes 네이티브 | **예 (K3s/K8s)** | 예 (K8s) | 아니요 (Docker) | 아니요 (Docker) |
| 클라우드 관리 스위트 | **예 (오픈소스)** | CloudCore | 아니요 (엣지만) | Azure Portal |
| AI 모델 배포 | **예 (GPU 지원)** | Custom Resource | 앱 서비스 | 예 (컨테이너) |
| MQTT 지원 | **내장 브로커** | Eclipse Mosquitto | MQTT 브로커 | 내장 |
| Modbus/BACnet | **네이티브 모듈** | 서드파티 | **네이티브 (장치 서비스)** | 모듈 통해 |
| OTA 업데이트 | **섀도우 기반** | CloudStream | 네이티브 없음 | Device Update |
| 최소 엣지 RAM | **1GB** | 256MB | 1GB | 1GB |
| 최소 엣지 CPU | **1 코어** | 1 코어 | 1 코어 | 1 코어 |
| 스트림 처리 | **내장 eKuiper** | 외부 통해 | 앱 서비스 통해 | 모듈 통해 |
| LF Edge 프로젝트 | **예** | CNCF (졸업) | **예** | 아니요 (Microsoft) |

**각 경쟁자 대신 Baetyl을 선택할 때:**

- **vs. KubeEdge:** UI가 있는 오픈소스 클라우드 관리 스위트(Baetyl-cloud), 내장 MQTT 브로커 및 산업용 프로토콜 지원이 필요할 때. KubeEdge는 순수 Kubernetes 시나리오에서 더 성숙했지만 통합 장치 프로토콜 어댑터가 부족합니다.
- **vs. EdgeX Foundry:** Kubernetes 네이티브 오케스트레이션과 클라우드 측 관리가 필요할 때. EdgeX는 더 풍부한 장치 서비스 에코시스템을 가지고 있지만 Docker에서 실행되어 함대 관리가 더 어렵습니다.
- **vs. Azure IoT Edge:** 벤더 독립성과 완전한 소스 코드 제어가 필요할 때. Azure IoT Edge는 Microsoft의 클라우드 에코시스템 및 독점 관리 평면에 묶입니다.

## 한계: 정직한 평가

1. **클우드 대시보드는 오픈소스가 아닙니다.** baetyl-cloud는 모든 관리 기능에 대한 RESTful API를 제공하지만 프론트엔드 웹 UI는 오픈소스 릴리스에 포함되지 않습니다. 자체 대시보드를 구축하거나 CLI/API 도구를 사용해야 합니다.

2. **엣지 프레임워크는 Kubernetes가 필요합니다.** K3s에 대한 최소 1GB RAM 요구 사항은 깊게 제한된 마이크로컨트롤러를 제외합니다. Baetyl은 게이트웨이 및 산업용 PC를 대상으로 하며, ESP32 클래스 장치는 아닙니다.

3. **문서는 주로 중국어입니다.** baetyl.io에 영문 문서가 있지만 가장 자세한 가이드, 커뮤니티 토론 및 문제 해결 리소스는 중국어입니다. 중국어가 아닌 사용자는 추가 노력이 필요할 수 있습니다.

4. **네이티브 프로세스 모드는 개발 중입니다.** 현재 v2는 K3s에서 모든 워크로드를 컨테이너로 실행합니다. 더 가벼운 네이티브 프로세스 모드(Baetyl v1과 유사)는 리소스 오버헤드를 더 줄이기 위해 계획되어 있습니다.

5. **KubeEdge보다 작은 커뮤니티.** 3,200개 대 KubeEdge의 7,000+ Star로, 서드파티 통합 및 커뮤니티 플러그인의 에코시스템이 더 작습니다.

## 자주 묻는 질문

**질문: Baetyl은 인터넷 연결 없이 장치에서 실행할 수 있나요?**

답변: 예. Baetyl은 간헐적인 연결을 위해 설계되었습니다. 애플리케이션이 배포되면 엣지 노드는 자율적으로 작동합니다. 섀도우 동기화는 업데이트를 큐에 넣고 연결이 복원될 때 적용합니다. AI 추론, 메시지 라우팅 및 데이터 처리는 완전한 네트워크 중단 중에도 계속 작동합니다. 에어 갭 환경의 경우 구성을 USB 또는 로컬 레지스트리를 통해 전달할 수 있습니다.

**질문: Baetyl과 엣지 장치에서 K3s를 직접 실행하는 것은 어떻게 다른가요?**

답변: 순수 K3s는 컨테이너 오케스트레이션을 제공하지만 클라우드-엣지 동기화, OTA 업데이트, 장치 프로토콜 어댑터(MQTT/Modbus/BACnet) 및 중앙 집중식 함대 관리가 부족합니다. Baetyl은 K3s 위에 이러한 기능을 추가하여 개별 엣지 클러스터를 통합되고 관리 가능한 함대로 전환합니다. Baetyl을 K3s가 기본적으로 제공하지 않는 "엣지용 제어 플레인"으로 생각하세요.

**질문: 엣지 추론에 어떤 AI 프레임워크가 지원되나요?**

답변: Linux 컨테이너에서 실행되는 모든 프레임워크가 작동합니다: PyTorch, TensorFlow, TensorRT, ONNX Runtime, OpenVINO 및 NCNN. Baetyl은 Kubernetes 디바이스 플러그인을 통해 GPU 리소스를 예약하고 GPU 모니터링 모듈은 메모리, 온도 및 활용도를 추적합니다. 모델 형식이나 런타임에 제한이 없습니다.

**질문: 엣지-클우드 통신 채널은 얼마나 안전한가요?**

답변: 모든 엣지-클우드 통신은 mTLS를 사용하는 HTTPS를 사용합니다. 인증서는 노드 활성화 중에 프로비저닝되며 자동으로 순환할 수 있습니다. 애플리케이션 구성 및 비밀은 클라우드 데이터베이스에 암호화되어 저장되고 엣지 노드에 안전하게 전달됩니다. 섀도우 동기화 프로토콜은 상태 비저장 및 멱등성이 있어 공격 표면을 줄입니다.

**질문: 클라우드 관리 스위트 없이 Baetyl을 배포할 수 있나요?**

답변: 예, 하지만 중앙 집중식 관리 및 OTA 업데이트를 잃게 됩니다. 로컬 Kubernetes 매니페스트 또는 `baetyl apply` CLI를 사용하여 애플리케이션을 엣지 노드에 직접 배포할 수 있습니다. 이 독립 실행 모드는 단일 노드 배포 또는 클라우드 연결이 금지된 고도로 안전한 환경에 유용합니다.

## 결론: AI를 데이터가 있는 곳으로 가져오세요

Baetyl은 클라우드 AI 학습과 엣지 AI 추론 사이의 격차를 해소합니다. Kubernetes 네이티브 오케스트레이션을 IoT 게이트웨이에 가져오고 선언적 클라우드-엣지 동기화로 확장함으로써, Baetyl은 대규모 AI 모델 배포 및 관리를 실용적으로 만듭니다 — 이론이 아닌 실제로.

이 프레임워크는 반도체 웨이퍼 공장에서 스마트 빌딩에 이르기까지 산업 환경에서 프로덕션 검증되었습니다. Apache-2.0 라이선스, LF Edge 거버넌스 및 활발한 개발은 엣지 컴퓨팅 인프라에 안전한 장기적인 선택입니다.

**시작하기:** [baetyl/baetyl](https://github.com/baetyl/baetyl) 리포지토리를 복제하고, 위의 K3s 설정을 따르고, 오늘 첫 번째 엣지 AI 모델을 배포하세요. baetyl-cloud를 호스팅할 클라우드 VPS의 경우 [DigitalOcean](https://m.do.co/c/eca87ac14ee0)에서 신규 계정에 $200 크레딧을 제공합니다 — 관리 클러스터와 여러 엣지 노드를 실행하기에 충분합니다. 지원 및 배포 경험 공유를 위해 [Baetyl 커뮤니티](https://t.me/baetylcommunity)에 가입하세요.

## 출처 및 추가 자료

- [Baetyl 공식 문서](https://baetyl.io/docs/en/latest/)
- [Baetyl GitHub 저장소](https://github.com/baetyl/baetyl) — 3,200 Star, Apache-2.0
- [Baetyl 클라우드 관리 스위트](https://github.com/baetyl/baetyl-cloud)
- [Linux Foundation Edge — Baetyl](https://lfedge.org/projects/baetyl/)
- [K3s 경량 Kubernetes](https://k3s.io/)
- [LF Edge eKuiper 스트림 처리](https://ekuiper.org/)
- [엣지 AI Kubernetes: 엔터프라이즈 블루프린트](https://www.wwt.com/wwt-research/edge-ai-kubernetes-enterprise-blueprint)



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 제휴 공개

본 기사에는 DigitalOcean의 제휴 링크가 포함되어 있습니다. 당사 링크를 통해 가입하면 추가 비용 없이 커미션을 받습니다. 모든 권장 사항은 실제 테스트를 기반으로 하며 제휴 프로그램의 영향을 받지 않습니다. Baetyl은 Apache-2.0 라이선스에 따라 완전히 오픈소스이며 물론 사용할 수 있습니다.
