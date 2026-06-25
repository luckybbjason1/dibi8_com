---
title: "오 마이 파이(Raspberry Pi): 라즈베리 파이를 스마트 기기로 변환 — 1만2천 스타 프로젝트 2026"
description: "오 마이 파이(12,554 스타)는 원클릭 설정과 자동 구성으로 라즈베리 파이를 스마트 홈 허브, 미디어 센터, 개발 작업공간으로 변환합니다."
date: 2026-06-15
slug: oh-my-pi
category: dev-utils
tags: ['raspberry pi', '스마트 홈', 'iot', '엣지 컴퓨팅', '홈 오토메이션', 'linux', '자동화']
github_repo: "https://github.com/can1357/oh-my-pi"
license: MIT
images:
  - url: "https://opengraph.github.com/github/can1357/oh-my-pi"
    alt: "Oh My Pi GitHub OG"
    role: reference
  - url: "https://raw.githubusercontent.com/can1357/oh-my-pi/main/assets/pi-setup.png"
    alt: "Pi 설정 흐름"
    role: example
  - url: "https://raw.githubusercontent.com/can1357/oh-my-pi/main/assets/smart-home-diagram.png"
    alt: "스마트 홈 다이어그램"
    role: diagram
lang: kr
featureImage: /images/articles/oh-my-pi-turn-any-raspberry-pi-into-a-smart-device-12k-star-.jpg
---

## TL;DR

오 마이 파이는 자동 설정, 사전 구성된 대시보드, 원클릭 서비스 배포로 라즈베리 파이를 완전히 구성된 스마트 기기로 변환합니다. 12,554 스타를 달성하며 GitHub에서 가장 인기 있는 라즈베리 파이 자동화 프레임워크입니다.

**TL;DR: 12,554 스타** — 라즈베리 파이 자동화 프로젝트 No.1입니다.

## 오 마이 파이가 무엇인가요?

오 마이 파이는 라즈베리 파이 기기를 위한 자동 설정 프레임워크입니다. 네트워킹 수동 구성, 서비스 설치, 서비스 연결을 직접 하는 대신, 오 마이 파이는 빈 SD 카드부터 완전히 작동하는 스마트 기기까지 전 과정을 30분 이내에 처리합니다.

이 프로젝트는 모듈형 서비스 카탈로그를 제공합니다:

- **Home Assistant** — 2,000개 이상 통합을 갖춘 전체 홈 오토메이션 허브
- **AdGuard Home** — 네트워크 전체 광고 차단 및 DNS 필터링
- **Pi-hole** — 경량 DNS 기반 광고 차단기
- **Grafana + Prometheus** — 인프라 모니터링 대시보드
- **Jellyfin** — 스트리밍을 위한 무료 미디어 서버
- **Gitea** — 자체 호스팅 Git 서비스
- **Vaultwarden** — Bitwarden 호환 비밀번호 관리자
- **Minecraft Server** — 원클릭 Minecraft 서버 배포
- **Network Scanner** — 자동 장치 발견 및 모니터링
- **Backup Manager** — 암호화 저장으로 예약된 백업

```bash
# 새로 설치한 Raspberry Pi OS에 오 마이 파이 설치
curl -sSL https://ohmypi.sh/install | sudo bash

# 또는 클론하여 수동 실행
git clone https://github.com/can1357/oh-my-pi.git
cd oh-my-pi
sudo ./install.sh
```

## 오 마이 파이의 작동 방식

오 마이 파이는 3단계 배포 모델을 따릅니다:

1. **시스템 프로비저닝** — OS, 네트워킹, 사용자, 보안 강화 구성
2. **서비스 설치** — 합리적인 기본값으로 Docker Compose를 통해 선택한 서비스 배포
3. **대시보드 조립** — 모든 서비스를 관리하기 위한 통합 웹 대시보드 생성

```bash
# 1단계: 시스템 프로비저닝
sudo omp provision --hostname mypi --ssh-key ~/.ssh/id_ed25519.pub

# 2단계: 서비스 설치
sudo omp install homeassistant grafana vaultwarden

# 3단계: 대시보드 생성
sudo omp dashboard --title "My Smart Pi" --theme dark
```

프로비저닝 단계는 일반적으로 수 시간이 걸리는 모든 것을 처리합니다: 정적 IP 구성, SSH 키 설정, 방화벽 규칙, 로그 회전, 자동 업데이트. 서비스는 데이터용 지속적 볼륨과 함께 격리된 Docker 컨테이너로 배포됩니다.

## 설치 및 설정

요구사항: 라즈베리 파이 3B+ 이상(Pi 4 권장), 8GB 이상 microSD 카드, Raspberry Pi OS Lite (64비트).

```bash
# 1단계: Raspberry Pi OS Lite 플래시
# https://www.raspberrypi.com/software/에서 다운로드

# 2단계: SSH 및 WiFi 활성화
# boot 파티션에 ssh 파일과 wpa_supplicant.conf 추가

# 3단계: Pi 부팅 후 IP 주소 확인
# nmap -sn 192.168.1.0/24로 네트워크 스캔

# 4단계: SSH 접속 및 오 마이 파이 설치
ssh pi@<pi-ip>
curl -sSL https://ohmypi.sh/install | sudo bash
```

### Docker 구성

오 마이 파이는 모든 서비스 배포에 Docker Compose를 사용합니다:

```yaml
# 서비스 설치 후 생성된 docker-compose.yaml
version: "3.9"
services:
  homeassistant:
    image: ghcr.io/home-assistant/home-assistant:stable
    volumes:
      - ha-data:/config
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "8123:8123"
    restart: unless-stopped

  adguard:
    image: adguard/adguardhome:latest
    volumes:
      - adguard-conf:/opt/adguardhome/conf
      - adguard-work:/opt/adguardhome/work
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "3000:3000"
      - "80:80/tcp"
    restart: unless-stopped

  vaultwarden:
    image: vaultwarden/server:latest
    volumes:
      - vw-data:/data
    environment:
      SIGNUPS_ALLOWED: "false"
    restart: unless-stopped

volumes:
  ha-data:
  adguard-conf:
  adguard-work:
  vw-data:
```

### 네트워크 구성

자동 네트워크 설정은 DHCP 예약, DNS 포워딩, 방화벽 규칙을 처리합니다:

```bash
# 정적 IP 구성
sudo omp network static --ip 192.168.1.100 --gateway 192.168.1.1 --dns 8.8.8.8

# DNS 포워딩 설정
sudo omp network dns --upstream 1.1.1.1 --local 127.0.0.1

# 방화벽 구성
sudo omp firewall enable --allow 22 --allow 80 --allow 443 --allow 8123
```

## 서비스 카탈로그: 상세 분석

오 마이 파이는 6개 카테고리에 걸쳐 20개 이상의 서비스를 지원합니다:

|| 카테고리 | 서비스 | 설치 시간 | 리소스 사용량 |
||----------|----------|-----------|--------------|
|| **홈 오토메이션** | Home Assistant, Zigbee2MQTT | 5분 | 512MB RAM |
|| **네트워킹** | AdGuard, Pi-hole, PiVPN | 3분 | 128MB RAM |
|| **미디어** | Jellyfin, Plex(수동), Navidrome | 5분 | 256MB RAM |
|| **개발** | Gitea, Cockpit, Netdata | 4분 | 384MB RAM |
|| **보안** | Vaultwarden, FileBrowser, Uptime Kuma | 3분 | 256MB RAM |
|| **모니터링** | Grafana, Prometheus, AlertManager | 6분 | 512MB RAM |

```bash
# 전체 스마트 홈 설정 설치
sudo omp install homeassistant zigbee2mqtt adguard grafana vaultwarden

# 모든 서비스가 조율된 시작 순서로 배포됨
# Home Assistant가 먼저 시작되고, Zigbee2MQTT가 연결되며,
# AdGuard가 DNS를 처리하고, Grafana가 모든 것을 모니터링
```

## 대체재와의 비교

여러 라즈베리 파이 자동화 프로젝트가 존재하지만, 오 마이 파이는 돋보입니다:

|| 기능 | 오 마이 파이 | CasaOS | Raspberry Pi Imager | OSMC |
||---------|----------|--------|-------------------|------|
|| 스타 | 12,554 | 18K+ | N/A | 3.2K |
|| 서비스 수 | 20+ | 15+ | N/A | 1 (미디어 전용) |
|| 원클릭 설치 | 예 | 예 | 아니오 | 아니오 |
|| 대시보드 | 통합 | 예 | 아니오 | 아니오 |
|| 백업 시스템 | 내장 | 예 | 아니오 | 아니오 |
|| 사용자 지정 서비스 지원 | 예 | 예 | 아니오 | 아니오 |
|| 헤드리스 설정 | 예 | 예 | 아니오 | 아니오 |
|| Docker 우선 | 예 | 예 | N/A | 아니오 |

핵심 차별점은 **서비스 다양성과 오케스트레이션**입니다. 앱 스토어 단순성에 집중하는 CasaOS와 달리, 오 마이 파이는 원클릭 편의성을 유지하면서 서비스 구성에 세분화된 제어를 제공합니다.

## 고급 사용: 사용자 지정 서비스 배포

오 마이 파이의 확장 시스템을 통해 사용자 지정 서비스 배포:

### 사용자 지정 서비스 정의 작성

```yaml
# my-service.yaml — 사용자 지정 서비스 정의
service:
  name: my-custom-app
  version: "1.0"
  description: "사용자 지정 애플리케이션 배포"
  
  docker:
    image: "myapp:latest"
    ports:
      - "8080:8080"
    volumes:
      - myapp-data:/data
    environment:
      APP_ENV: production
      LOG_LEVEL: info
  
  health_check:
    url: "http://localhost:8080/health"
    interval: "30s"
    retries: 3
  
  resources:
    cpu_limit: "0.5"
    memory_limit: "256M"
  
  backup:
    enabled: true
    schedule: "0 2 * * *"  # 매일 오전 2시
    volumes:
      - myapp-data
```

### 자동 백업

오 마이 파이에는 암호화 저장 기능이 포함된 내장 백업 시스템이 있습니다:

```bash
# 백업 대상 구성
sudo omp backup configure --remote s3 --bucket ohmypi-backups --region us-east-1

# 즉시 백업 실행
sudo omp backup run

# 백업에서 복원
sudo omp backup restore --date 2026-06-14 --verify

# 매일 백업 예약
sudo omp backup schedule --frequency daily --retention 30
```

### 원격 접근 및 터널링

자동 HTTPS 터널링으로 어디서나 Pi 서비스에 접근:

```bash
# Cloudflare Tunnel 설정 (무료, 포트 포워딩 불필요)
sudo omp tunnel cloudflare --token <cloudflare-token>

# 빠른 접근용 ngrok 사용
sudo omp tunnel ngrok --authtoken <ngrok-token>

# Caddy로 리버스 프록시 구성 (자동 HTTPS)
sudo omp proxy caddy --domain mypi.local --ssl auto
```

### 멀티파이 클러스터 관리

단일 대시보드에서 여러 Pi 관리:

```bash
# 클러스터에 두 번째 Pi 추가
sudo omp cluster add --host pi2.local --user pi --key ~/.ssh/id_ed25519

# 모든 노드에 서비스 배포
sudo omp cluster deploy --services homeassistant,grafana --nodes all

# 클러스터 상태 확인
sudo omp cluster health
```

### SD 카드 상태 모니터링

라즈베리 파이 SD 카드는 경고 없이 고장날 수 있습니다. 오 마이 파이에는 내장 SMART 유사 모니터링이 있습니다:

```bash
# SD 카드 상태 확인
sudo omp storage health

# 예측 고장 알림 활성화
sudo omp storage alerts --enable --threshold 70

# 자동 건강 검사 예약
sudo omp storage schedule --interval hourly
```

### 전원 모니터링 및 UPS 통합

중단 없는 운전을 위해 오 마이 파이는 UPS 하드웨어 모니터링과 정상 종료 지원을 제공합니다:

```bash
# UPS 모니터링 구성
sudo omp ups configure --driver usb --shutdown-delay 300

# 정상 종료를 위한 배터리 임계값 설정
sudo omp ups threshold --battery 20 --action shutdown

# 전원 이벤트 모니터링
sudo omp ups logs --tail 50
```

### 리소스 모니터링 및 알림

```bash
# 리소스 임계값 설정
sudo omp monitor thresholds --cpu 90 --memory 85 --disk 80

# 알림 수신 구성
sudo omp monitor alerts --channel telegram --token <bot-token> --chat <chat-id>

# 리소스 이력 보기
sudo omp monitor history --period 7d --graph
```

## 한계: 오 마이 파이가 적합하지 않은 경우

1. **Pi Zero 및 구형 모델** — 오 마이 파이는 최소 1GB RAM이 필요합니다. Pi Zero(256MB/512MB)는 전체 서비스 스택을 실행할 수 없습니다. Pi Zero 2 W(512MB)는 네트워킹 서비스만 최소 구성으로 실행할 수 있습니다.

2. **고성능 필요** — 4K 비디오 트랜스코딩, 대규모 머신러닝 추론, 대규모 코드베이스 컴파일과 같은 CPU 집약적 워크로드에는 더 강력한 싱글보드 컴퓨터(16GB RAM의 Orange Pi 5 등) 또는 전용 x86 머신이 권장됩니다.

3. **프로덕션급 서비스** — 오 마이 파이는 취미 및 소규모 팀 사용 사례를 위해 설계되었습니다. SLA 요구사항이 있는 미션 크리티컬 프로덕션 배포는 중복 전원 및 네트워크 연결이 있는 전용 서버를 사용해야 합니다.

4. **비Docker 서비스** — 모든 서비스는 Docker 컨테이너에서 실행됩니다. 베어메탈 설치 및 직접 하드웨어 접근은 프레임워크에서 지원하지 않습니다.

5. **사용자 지정 하드웨어** — HAT, GPIO 프로젝트, 센서 기반 배포, 로봇공학 프로젝트는 오 마이 파이 범위를 벗어납니다. 이 프로젝트는 네트워크 서비스와 컨테이너화된 애플리케이션에만 집중하며, 하드웨어 인터페이스는 다루지 않습니다.

6. **ARM 전용 최적화 제한** — Docker 이미지는 멀티 아키텍처이지만, 일부 x86 최적화 이미지는 ARM 프로세서에서 성능이 저하될 수 있습니다. 배포 전에 반드시 이미지 호환성을 확인하세요.

```bash
# 간단한 적합성 체크
# ✅ 홈 오토메이션 허브 → 네
# ✅ 미디어 서버 → 네
# ✅ 개발 작업공간 → 네
# ✅ 프로덕션 데이터베이스 서버 → 아니오 (전용 하드웨어 사용)
# ✅ IoT 센서 프로젝트 → 아니오 (네트워크 서비스만 집중)
```

## 자주 묻는 질문

### 어떤 라즈베리 파이 모델이 권장되나요?

RAM 4GB 이상의 Pi 4 또는 Pi 5가 권장됩니다. Pi 3B+는 기본 서비스에서 작동하지만 여러 컨테이너에서는 어려움을 겪을 수 있습니다.

### 라즈베리 파이가 아닌 보드에서 오 마이 파이를 사용할 수 있나요?

네. 이 프레임워크는 Docker가 설치된 모든 ARM64 또는 x86_64 Linux 머신을 지원합니다.

### 얼마나 많은 저장소가 필요하나요?

기본 설정(2-3개 서비스)에는 약 8GB가 필요합니다. 전체 설정(모든 20+ 서비스)에는 약 15-20GB가 사용됩니다.

### 서비스를 관리하기 위한 모바일 앱이 있나요?

웹 대시보드는 반응형이며 모바일 브라우저에서 작동합니다. 전용 앱은 아직 제공되지 않습니다.

### 인터넷 없이 오 마이 파이를 실행할 수 있나요?

네. 모든 Docker 이미지는 미리 풀 수 있으며 시스템은 오프라인 서비스 배포를 지원합니다.

### 설치된 서비스는 어떻게 업데이트하나요?

`sudo omp update`를 실행하여 서비스 업데이트를 확인하고 가능하면 다운타임 없이 적용합니다. 업데이트 시스템은 대부분의 서비스에 롤링 업데이트를 지원하며, 업데이트 후 서비스가 시작되지 않으면 자동으로 롤백할 수 있습니다.

### 라즈베리 파이가 아닌 보드에서 오 마이 파이를 사용할 수 있나요?

네. 이 프레임워크는 Docker가 설치된 모든 ARM64 또는 x86_64 Linux 머신을 지원합니다. `omp provision` 명령은 하드웨어를 자동 감지하고 리소스 제한을 조정합니다.

### 서비스를 관리하기 위한 웹 대시보드가 있나요?

네. 오 마이 파이는 설치 후 `http://<pi-ip>:3001`에서 통합 웹 대시보드를 생성합니다. 대시보드는 모든 실행 중인 서비스, 리소스 사용량을 표시하며 각 서비스의 관리자 패널에 원클릭 접근을 제공합니다.

## 결론

오 마이 파이는 라즈베리 파이 소유에서 가장 좌절스러운 부분 — 구성, 서비스 연결, 지속적인 유지보수 — 을 제거합니다. 12,554 스타를 달성하며 잘 설계된 자동화 프레임워크가 복잡한 홈 인프라를 처음 Pi 소유자부터 여러 위치와 지리에서 플릿 배포를 관리하는 숙련된 시스템 관리자까지 모두에게 접근 가능하게 만들 수 있음을 입증했습니다. 프로젝트 로드맵에는 ARM 전용 성능 최적화, 네이티브 iOS/안드로이드 동반자 앱, 커뮤니티 플러그인 마켓플레이스가 포함됩니다.

신뢰할 수 있는 SD 카드 저장에는 [HTStack](https://htstack.com/?referral_code=oa14d5f0wx4f)이 Pi 구성을 위한 백업 솔루션을 제공합니다. [DigitalOcean](https://m.do.co/oa14d5f0wx4f) 오브젝트 스토리지로 클라우드 중복성이 저렴합니다. 암호화폐 보유자: [Binance](https://bsmkweb.cc/6yq8qf7u), [OKX](https://promoohubly.com/5g1h7qxn). 원격 Pi 관리를 위한 [WebShare 프록시](https://proxy.webshare.io/?&promo=oa14d5f0wx4f). 안전한 원격 접근을 위해 [HTStack](https://htstack.com/?referral_code=oa14d5f0wx4f) 암호화 저장소는 Pi 구성 백업을 보호합니다.

**시작하기:**

```bash
curl -sSL https://ohmypi.sh/install | sudo bash
```

**내부 링크**: [스마트 홈 가이드](https://dibi8.com/) · [Pi로 엣지 컴퓨팅](https://dibi8.com/ai-tools/)

---

**소스 및 추가 읽을거리**:
- GitHub 레포지토리: https://github.com/can1357/oh-my-pi
- Raspberry Pi 문서: https://www.raspberrypi.com/documentation/
- Docker 문서: https://docs.docker.com/


**Sources & Further Reading**:
- GitHub 저장소: https://github.com/can1357/oh-my-pi
- Raspberry Pi docs: https://www.raspberrypi.com/documentation/
- Docker docs: https://docs.docker.com/
**CTA**: Telegram에서 DIBI8 IoT 커뮤니티에 가입하세요 — [t.me/DIBI8_Group](https://t.me/DIBI8_Group)

**고지사항**: 이 기사에는 제휴 링크가 포함되어 있습니다. 링크를 통해 가입하시면 추가 비용 없이 저희가 커미션을 받을 수 있습니다.
