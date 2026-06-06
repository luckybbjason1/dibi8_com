---
title: "WiFi-Forge — WiFi 해킹을 안전하고 합법적으로 배우는 샌드박스"
description: "WiFi Forge: 보안 연구를 위한 안전한 WiFi 해킹 연구소. 통제된 환경에서 침투 테스트, 무선 보안 및 윤리적 해킹을 배우세요."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Python
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "16.4 MB"
file_md5: ""
download_url: "https://github.com/her3ticAVI/MiniNet-framework"
backup_url: ""
github_repo: "https://github.com/her3ticAVI/MiniNet-framework"
stars: 813
maintainer: "blackhillsinfosec"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /kr/posts/wifi-forge-safe-wifi-hacking-lab/
faqs:
  - q: 'WiFi-Forge란 무엇인가요?'
    a: 'WiFi-Forge는 Black Hills InfoSec에서 만든 오픈소스 프로젝트로, 무선 공격 기법을 안전하고 합법적으로 실습할 수 있는 샌드박스 환경을 제공합니다. 별도 하드웨어를 구매할 필요 없이 노트북에서 가상 실습 환경을 구동하며, 타인의 네트워크에 접촉할 위험도 전혀 없습니다.'
  - q: 'WiFi-Forge로 WiFi 해킹을 배우려면 전용 WiFi 어댑터가 필요한가요?'
    a: '아니요. WiFi-Forge는 소프트웨어로 액세스 포인트, 스테이션, 무선 채널을 에뮬레이션하기 때문에 monitor mode를 지원하는 USB 어댑터가 전혀 필요 없습니다. 물리적 RF 계층을 학습하고 싶을 때만 실제 카드가 필요하며, 그 부분은 이 시뮬레이션에서 다루지 않습니다.'
  - q: 'WiFi-Forge는 어떤 기술을 기반으로 만들어졌나요?'
    a: 'WiFi-Forge는 mininet-wifi 위에 구축되어 있습니다. mininet-wifi는 802.11 네트워크 에뮬레이터로, Linux 네트워크 네임스페이스 내에 가상 액세스 포인트와 클라이언트를 생성합니다. 각 AP와 클라이언트는 실제 Linux 프로세스이므로 airodump-ng, tcpdump, Reaver, Hashcat 등의 도구가 실제 무선 트래픽을 다루는 것처럼 동작합니다.'
  - q: 'WiFi-Forge에서 어떤 WiFi 공격을 실습할 수 있나요?'
    a: '기본 제공 실습 랩에는 WPA/WPA2 핸드셰이크 캡처, WPS 공격(Reaver PIN 브루트포스 및 Pixie-Dust), evil-twin/Karma 악성 AP, 디어인증(deauthentication) 플러딩, 비콘 플러딩, MAC 랜덤화 분석, PMKID 공격이 포함되어 있습니다. 각 랩은 특정 토폴로지를 부팅하고 CTF 형식의 소규모 목표를 제시합니다.'
  - q: 'WiFi-Forge를 설치하고 실행하려면 무엇이 필요한가요?'
    a: 'Linux(Ubuntu 또는 Debian 권장), Python 3, 그리고 root 권한이 필요합니다. mininet-wifi가 커널 기능을 사용하기 때문입니다. 저장소를 클론한 후 sudo ./install.sh를 실행해 의존성을 설치하고, sudo python3 wififorge.py로 시작하면 됩니다.'
---
{</* resource-info */>}

WiFi 공격을 전통적인 방식으로 배워본 적이 있다면, 흐름은 대개 이렇습니다: 모니터 모드와 패킷 인젝션을 지원하는 USB 무선 어댑터를 주문하고, 한나절 동안 Linux 드라이버와 씨름하고, 본인 소유의 테스트 AP를 세팅하고, *그제서야* 진짜로 배우려던 공격 연습을 시작합니다. **WiFi-Forge**는 이 모든 사전 준비를 통째로 건너뛰게 해줍니다.

![WiFi-Forge 배너](https://github.com/her3ticAVI/MiniNet-framework/raw/main/images/WifiForgeVersion2.png)

[WiFi-Forge](https://github.com/blackhillsinfosec/WifiForge)는 [Black Hills InfoSec](https://www.blackhillsinfosec.com/)에서 공개한 오픈소스 프로젝트로, 무선 공격을 연습할 **안전하고 합법적인** 환경을 제공합니다. 하드웨어를 살 필요가 없고, 남의 네트워크를 건드릴 위험도 없으며, 드라이버를 망가뜨릴 일도 없습니다. 가상 랩을 띄우면 곧바로 해킹 연습을 시작할 수 있습니다.

## 왜 필요한가 —— WiFi 학습의 세 가지 함정

기존 WiFi 실습 학습이 사람을 떨어뜨리는 세 가지 이유:

1. **하드웨어 복불복.** 모든 USB 어댑터가 모니터 + 인젝션을 깔끔하게 지원하지는 않습니다. 검증된 모델(Alfa AWUS036, Panda PAU09 등)은 30~60 달러이며, 한 번에 한 개만 사용할 수 있습니다.
2. **법적 회색지대.** 대부분 국가에서 본인 소유가 아닌 네트워크를 건드리는 것은 —— 단순히 패시브 스니핑조차 —— 모두 위법입니다. *"그냥 보기만 했다"* 는 변명이 되지 않습니다.
3. **롤백 비용.** 실제 하드웨어는 한 번의 명령으로 초기화되지 않습니다. 망가진 설정을 `git checkout`으로 되돌릴 수 없습니다.

WiFi-Forge는 이 세 가지를 노트북 위의 단일 샌드박스로 통합합니다.

## 내부 구조

WiFi-Forge는 [mininet-wifi](https://github.com/intrig-unicamp/mininet-wifi) 위에 구축되었습니다 —— 802.11 네트워크 에뮬레이터로, Linux 네트워크 네임스페이스 내부에 가상 AP, 스테이션, "전파"를 만들어냅니다. 모든 AP와 클라이언트는 실제 Linux 프로세스이므로 `iwconfig`, `airodump-ng`, `tcpdump`는 물론 Reaver, Hashcat까지 시뮬레이션된 트래픽에 그대로 적용 가능하며, 표준 도구들이 실제 전파를 다루는 것처럼 동작합니다.

WiFi-Forge가 그 위에 더하는 것: 미리 만들어진 토폴로지, 바로 실행되는 공격 시나리오, 그리고 매번 네트워크를 처음부터 설계할 필요가 없는 가이드 구조.

## 무엇을 연습할 수 있나

![WiFi-Forge 실행 화면](https://github.com/her3ticAVI/MiniNet-framework/raw/main/images/wififorge-running.png)

번들된 랩은 일반적인 WiFi 공격 카테고리를 망라합니다:

- **WPA/WPA2 핸드셰이크 캡처** —— 클라이언트를 deauth하고, 4-way handshake를 캡처하고, hashcat이나 aircrack-ng로 오프라인 크래킹
- **WPS 공격** —— Reaver PIN 무차별 대입, Pixie-Dust 공격
- **Evil-twin / Karma** —— 타깃 SSID를 흉내낸 악성 AP를 띄우고 클라이언트가 자동 연결되는 모습 관찰
- **Deauth 플러드** —— 합법 AP에서 클라이언트를 떨어뜨리기
- **Beacon 플러딩** —— 가짜 AP 수천 개를 살포해 스캐너 혼란시키기
- **MAC 무작위화 분석** —— 최신 기기들이 신원을 어떻게 숨기는지 (그리고 어디서 노출되는지) 관찰
- **PMKID 공격** —— 클라이언트가 연결되어 있지 않아도 핸드셰이크 캡처

각 랩은 특정 토폴로지를 부팅하고 셸을 제공한 뒤, 작은 CTF 스타일의 목표를 부여합니다.

## 시작하기

```bash
git clone https://github.com/blackhillsinfosec/WifiForge
cd WifiForge
sudo ./install.sh
sudo python3 wififorge.py
```

Linux(Ubuntu 또는 Debian 권장), Python 3, root 권한이 필요합니다(mininet-wifi가 커널 기능을 사용함). 설치 스크립트가 의존성을 자동으로 처리합니다 —— mininet-wifi, aircrack-ng, hashcat, reaver 등.

## 누구에게 적합한가

![무선 보안 실험](https://www.bobology.com/members/images/249.jpg?cb=20250922025150)

- **OSCP / OSWP 수험생** —— 시험 랩과 유사한 시나리오를 하드웨어 없이 연습
- **CTF 출제자** —— 실제 무전기 없이 무선 챌린지를 빠르게 구성
- **보안 교육자** —— 모든 학생에게 몇 초 만에 초기화되는 독립적인 랩 제공
- **호기심 있는 개발자** —— 4-way handshake가 실제로 어떻게 작동하는지 디버거 붙여 한 단계씩 추적

> ⚠️ **WiFi-Forge로 배울 수 없는 것:** 물리 계층 —— RF, 안테나 선택, 실제 신호 감쇠. 이것은 결국 진짜 카드가 필요합니다. 그러나 실전 공격의 90%가 발생하는 프로토콜 계층에서는 시뮬레이션과 실제 트래픽이 사실상 구별 불가능합니다.

## 합법성과 윤리에 관한 한마디

이런 프로젝트는 직접적으로 말하는 것이 중요합니다: **본인이 소유하거나 명시적으로 서면 허가를 받은 네트워크에서만 이 기술을 사용하세요.** WiFi-Forge가 존재하는 *이유*는, 시뮬레이션 랩이 있기에 옆 카페 WiFi에 "한 번 해볼까"라는 유혹이 사라지기 때문입니다. 안전하게 배우는 것 —— 그것이 핵심입니다.

---

- **저장소:** [github.com/blackhillsinfosec/WifiForge](https://github.com/blackhillsinfosec/WifiForge)
- **기반:** [mininet-wifi](https://github.com/intrig-unicamp/mininet-wifi)
- **관리:** [Black Hills InfoSec](https://www.blackhillsinfosec.com/)

---

## 추천 도구

오픈소스 AI 도구 개발/배포 시 권장:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전, AI 워크로드용 원클릭 droplet.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API 프록시. 위의 AI 도구 대부분 (챗봇, 코드 생성, 번역, 검색 등) LLM API 키 필요 — 이 프록시로 안정적인 톱 모델 액세스, 공식 가격의 ~30%.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

