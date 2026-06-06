---
title: 'Scanners-Box: 200+ 사이버보안 도구 모음 — 보안 전문가 필수'
description: Scanners-Box를 탐색하세요 — 침투 테스트, 취약점 스캐닝, 보안 연구를 포함한 200개 이상의 오픈소스 사이버보안
  도구 모음.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Docker
- Go
- JavaScript
- Python
- Rust
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "236 KB"
file_md5: ''
download_url: https://github.com/luckybbjason1/Scanners-Box
backup_url: ''
github_repo: https://github.com/luckybbjason1/Scanners-Box
stars: 0
maintainer: "luckybbjason1"
last_maintained: "2023-09-21"
featureImage: ''
draft: false
aliases:
- /ko/posts/scanners-box-cybersecurity-tools-collection/
faqs:
  - q: 'Scanners-Box란 무엇인가요?'
    a: 'Scanners-Box는 15개 이상의 카테고리에 걸쳐 200개 이상의 오픈소스 사이버보안 도구를 엄선한 모음으로, 서브도메인 열거, SQL 인젝션, 퍼징, 포트 스캐닝, 사회공학 등을 아우릅니다. 원래 중국 보안 커뮤니티(t00ls)를 위해 만들어졌으며, 침투 테스터와 보안 연구자를 대상으로 합니다.'
  - q: 'Scanners-Box는 SQL 인젝션 테스트에 어떤 도구를 추천하나요?'
    a: '주요 추천 도구는 sqlmap으로, SQL 인젝션을 자동으로 탐지하고 익스플로잇하며, 6가지 데이터베이스 유형을 지원하고 WAF 우회를 위한 tamper 스크립트를 포함합니다. 이 모음에는 jsql-injection, SQLiScanner, NoSQLAttack도 함께 나열되어 있습니다.'
  - q: '포트 스캐닝에서 Nmap과 masscan의 차이점은 무엇인가요?'
    a: 'Nmap은 서비스/버전 탐지와 스크립팅(예: --script=vuln을 통한 취약점 스크립트)을 제공하는 표준 네트워크 스캐너이고, masscan은 비동기 전송을 사용해 약 6분 만에 인터넷 전체를 스캔할 수 있는 가장 빠른 인터넷 포트 스캐너입니다. masscan은 Nmap과 호환되므로 두 도구는 흔히 함께 사용됩니다.'
  - q: 'Scanners-Box에는 어떤 퍼징 도구가 포함되어 있나요?'
    a: 'AFL(American Fuzzy Lop), honggfuzz, syzkaller, libFuzzer를 포함해 20개 이상의 퍼저가 나열되어 있습니다. AFL은 커버리지 기반이며 실제 소프트웨어에서 수천 개의 버그를 찾아냈고, syzkaller는 Linux 커널 퍼저로 3000개 이상의 커널 버그를 발견했으며 Google과 Microsoft에서 사용됩니다.'
  - q: 'Scanners-Box에 있는 것과 같은 침투 테스트 도구를 사용하는 것이 합법인가요?'
    a: '이러한 도구는 승인된 보안 테스트에 한해서만 합법이며, 명시적인 서면 허가 없이 시스템을 대상으로 사용하는 것은 불법이며 비윤리적입니다. 관련 법률로는 미국 컴퓨터 사기 및 남용 방지법(CFAA), 영국 컴퓨터 오용법, 중국 사이버보안법, EU GDPR 등이 있으므로, 테스트 전에 반드시 서면 승인을 받고 범위를 정의하십시오.'
---
{</* resource-info */>}

## Scanners-Box란?

**Scanners-Box**는 보안 전문가, 침투 테스트 전문가 및 윤리적 해커를 위한 **200개 이상의 오픈소스 사이버보안 도구**를 엄선하여 모은 컬렉션입니다. 원래 중국 보안 커뮤니티(t00ls)를 위해 만들어졌으며, 정찰부터 공격까지 사이버보안의 모든 측면을 다룹니다.

**GitHub**: https://github.com/luckybbjason1/Scanners-Box  
**라이선스**: 오픈소스 모음  
**도구 수**: 200+  
**카테고리**: 15+

---

## 도구 카테고리 개요

| 카테고리 | 도구 수 | 예시 |
|----------|-----------|----------|
| **하위 도메인 열거** | 15+ | subDomainsBrute, amass, subfinder, OneForAll |
| **데이터베이스 & SQL 인젝션** | 10+ | sqlmap, jsql-injection, SQLiScanner, NoSQLAttack |
| **퍼징 도구** | 20+ | AFL, honggfuzz, syzkaller, libFuzzer |
| **포트 스캐닝 & 핑거프린팅** | 25+ | Nmap, masscan, whatweb, wafw00f |
| **약한 비밀번호 & 정보 유출** | 15+ | htpwdScan, BBScan, GitHack, truffleHog |
| **IoT 장치 스캐닝** | 5+ | IoTSeeker, RouterSploit, routersploit |
| **XSS 공격** | 10+ | BruteXSS, XSS-Radar, XSSTracer, easyXssPayload |
| **사회 공학** | 15+ | SET, gophish, evilginx2, blackeye |
| **웹셸 탐지** | 10+ | findWebshell, HaboMalHunter, PHP-Shell-Detector |
| **기업 네트워크 감사** | 5+ | theHarvester, xunfeng, LNScan |
| **취약점 스캐너** | 15+ | vulfocus, vulhub, VulApps, upload-labs |
| **무선 보안** | 5+ | fern-wifi-cracker, aircrack-ng |
| **자산 발견** | 5+ | linglong, H, nemo_go, NextScan |
| **위협 인텔리전스** | 3+ | threat-intelligence, VirusTotal, ThreatBook |
| **학습 리소스** | 20+ | sec-wiki, FreeBuf, Web Hacking 101 |

---

## 주요 도구 심층 분석

### 1. 하위 도메인 열거

**OneForAll** — 가장 포괄적인 하위 도메인 수집 도구
- 20개 이상의 데이터 소스 통합
- 더 나은 결과를 위한 API 키 지원
- 다양한 형식으로보내기

**amass** — Go 기반 하위 도메인 열거
- 빠르고 효율적
- DNS, 스크래핑, 인증서 투명성
- 그래프 시각화 출력

### 2. SQL 인젝션

**sqlmap** — SQL 인젝션 도구의 왕
- 자동 감지 및 공격
- 6가지 데이터베이스 유형 지원
- WAF 우회용 변조 스크립트

```bash
# 기본 사용법
sqlmap -u "http://target.com/page.php?id=1" --dbs

# 특정 테이블 덤프
sqlmap -u "http://target.com/page.php?id=1" -D database -T users --dump
```

### 3. 퍼징 프레임워크

**AFL (American Fuzzy Lop)** — 커버리지 기반 퍼징
- 자동으로 취약점 발견
- 테스트 케이스 생성
- 실제 소프트웨어에서 1000개 이상의 버그 발견

**syzkaller** — Linux 커널 퍼저
- 3000개 이상의 Linux 커널 버그 발견
- Google, Microsoft 사용
- 다양한 운영 체제 지원

### 4. 포트 스캐닝

**Nmap** — 네트워크 스캐너의 왕
```bash
# 기본 스캔
nmap -sV -sC target.com

# 스크립트가 포함된 전체 포트 스캔
nmap -p- -sV --script=vuln target.com

# 공격적 스캔
nmap -A target.com
```

**masscan** — 가장 빠른 인터넷 포트 스캐너
- 6분 만에 전체 인터넷 스캔
- Nmap과 호환
- 비동기 전송

### 5. 사회 공학 도구킷

**SET (Social-Engineer Toolkit)** — 완전한 피싱 프레임워크
- 웹사이트 복제
- 이메일 스피어 피싱
- 자격 증명 수집
- 다중 공격 벡터

**evilginx2** — 2FA 우회 피싱 프레임워크
- 중간자 공격
- 세션 쿠키 캡처
- 이중 인증 우회

---

## 보안 학습 리소스

### 입문자용
- **sec-wiki** — 보안 위키백과
- **FreeBuf** — 해커와 기술자 뉴스
- **Web Hacking 101** — 웹 보안 기초
- **Kali Linux Web 침투 테스트 요리책**

### 중급자용
- **Burpsuite 실전 가이드** — 웹 침투 테스트
- **API-Security-Checklist** — API 보안 모범 사례
- **Web-Security-Learning** — 종합 웹 보안
- **응급 대응 실전 노트** — 응급 대응

### 고급 주제
- **Linux 익스플로잇 개발 튜토리얼**
- **Android 침투 테스트**
- **Node.js 웹 보안 문제**
- **Python 보안 시리즈**

---

## 취약점 타겟 연습

| 플랫폼 | 설명 | 링크 |
|----------|-------------|------|
| **vulfocus** | Docker 기반 취약점 플랫폼 | GitHub |
| **vulhub** | 사전 구축된 취약한 환경 | GitHub |
| **VulApps** | 취약한 애플리케이션 모음 | GitHub |
| **upload-labs** | 파일 업로드 취약점 연습 | GitHub |
| **bWAPP** | 버그가 있는 웹 애플리케이션 | SourceForge |
| **DVWA** | 매우 취약한 웹 애플리케이션 | GitHub |
| **WebGoat** | OWASP 웹 보안 연습 | GitHub |

---

## 책임 있는 공개

> **⚠️ 경고**: 여기에 나열된 모든 도구는 승인된 보안 테스트용으로만 사용됩니다. 이러한 도구를 명시적 허가 없이 시스템에 사용하는 것은 불법이며 비윤리적입니다.

### 법적 프레임워크
- **CFAA** (컴퓨터 사기 및 남용법) — 미국
- **컴퓨터 남용법** — 영국
- **사이버보안법** — 중국
- **GDPR** — EU 데이터 보호

### 모범 사례
1. 항상 서면 승인을 받으세요
2. 범위를 명확히 정의하세요
3. 업무 시간을 존중하세요
4. 발견 사항을 즉시 보고하세요
5. 테스트 후 데이터를 삭제하세요

---

## 도구 선택 가이드

### 웹 애플리케이션 테스트
```
정찰: amass, subfinder, theHarvester
스캐닝: Nmap, masscan, whatweb
취약점: sqlmap, XSS 스캐너, dirsearch
공격: Burp Suite, 사용자 지정 스크립트
보고: Dradis, Faraday
```

### 네트워크 침투 테스트
```
발견: Nmap, masscan, nbtscan
열거: enum4linux, snmp-check
취약점: OpenVAS, Nessus
공격: Metasploit, Cobalt Strike
후 공격: PowerShell Empire, Mimikatz
```

### 레드팀 작전
```
초기 접근: SET, gophish, evilginx2
지속성: 사용자 지정 임플란트, 예약된 작업
권한 상승: PowerUp, BeRoot
측면 이동: Pass-the-hash, Kerberoasting
데이터 유출: DNS 터널링, HTTPS C2
```

---

## 관련 기사

- [Agent Reach: AI 에이전트 인터넷 접근](/kr/resources/llm-frameworks/agent-reach-ai-agent-internet-access/) — AI 기반 보안 자동화
- [Free Claude Code: 오픈소스 AI 코딩](/kr/resources/ai-tools/free-claude-code-open-source-proxy/) — 안전한 코딩 관행

---

*면책 조항: 본 문서는 교육 목적으로만 제공됩니다. 모든 도구는 책임감 있게 사용해야 하며, 소유하고 있거나 명시적 테스트 허가를 받은 시스템에만 사용해야 합니다. 작성자와 dibi8.com은 제공된 정보의 오용에 대해 책임을 지지 않습니다.*

---

## 추천 도구

오픈소스 AI 도구 개발/배포 시 권장:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전, AI 워크로드용 원클릭 droplet.
- **{{< aff "htstack" "category-footer" "HTStack" >}}** — 홍콩 VPS, dibi8.com 호스팅하는 동일 IDC. 보안 스캐너 자체 호스팅 전용 VPS, 아시아 저지연 커버리지, 공유 테넌트 노이즈 없음.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

