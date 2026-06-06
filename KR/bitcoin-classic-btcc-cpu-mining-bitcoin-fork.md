---
title: "Bitcoin-Classic (BTCC): 일반인도 CPU로 채굴할 수 있는 비트코인 복제판"
description: "Bitcoin-Classic (BTCC)는 Bitcoin Core v28.1을 기반으로 재구축된 탈중앙화 디지털 통화입니다. CPU 채굴을 지원하며 내장 그래픽 채굴기를 제공하여 일반 사용자도 초기 비트코인 채굴을 경험할 수 있습니다."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - C++
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "14.8 MB"
file_md5: ""
download_url: "https://github.com/Marcus-Vane/Bitcoin-Classic"
backup_url: ""
github_repo: "https://github.com/Marcus-Vane/Bitcoin-Classic"
stars: 23
maintainer: "Marcus-Vane"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /kr/posts/bitcoin-classic-btcc-cpu-mining-bitcoin-fork/
faqs:
  - q: '일반 CPU로 Bitcoin-Classic (BTCC)을 채굴할 수 있나요?'
    a: '네. BTCC는 일반 가정용 컴퓨터 CPU도 채굴에 참여할 수 있도록 설계되었으며, ASIC 장비나 전용 GPU가 필요하지 않습니다. 네트워크 해시레이트가 매우 낮기 때문에 일반 CPU로도 실제로 블록 보상을 받을 수 있습니다.'
  - q: 'Bitcoin-Classic (BTCC)의 총 공급량과 블록 보상은 얼마인가요?'
    a: 'BTCC의 총 공급량은 비트코인과 동일한 21,000,000개입니다. 초기 블록 보상은 50 BTCC이며, 210,000블록(약 4년)마다 반감기가 적용되고, 블록 생성 시간은 10분입니다.'
  - q: 'Bitcoin-Classic은 무엇을 기반으로 만들어졌고 어떤 합의 방식을 사용하나요?'
    a: 'Bitcoin-Classic은 Bitcoin Core v28.1을 기반으로 재구성되었으며 C++로 작성되었습니다. SHA-256 작업증명(Proof-of-Work) 합의 방식과 최장 체인 규칙을 사용하며, 완전히 탈중앙화되어 있고 프리마인이 없습니다.'
  - q: 'Bitcoin-Classic 채굴을 어떻게 시작하나요?'
    a: 'GitHub releases 페이지에서 Bitcoin-Classic-Setup.exe를 다운로드하여 설치한 후, 첫 실행 시 블록체인 동기화가 완료될 때까지 기다립니다. 새 지갑을 생성한 다음, 내장 그래픽 채굴기의 「Start Mining」 버튼을 클릭하면 됩니다. 명령줄 입력은 필요하지 않습니다.'
  - q: 'Bitcoin-Classic (BTCC)은 투자 가치가 있나요?'
    a: '아닙니다. BTCC는 현재 시가총액과 유동성이 거의 없고, 주요 거래소 지원도 없으며, 커뮤니티 규모도 매우 작습니다(GitHub 스타 약 18-23개). 투자 대상이 아닌 교육 및 실험적 프로젝트로 보는 것이 가장 적합합니다.'
---
{</* resource-info */>}

## Bitcoin-Classic란?

**Bitcoin-Classic (BTCC)**는 **Bitcoin Core v28.1**을 기반으로 재구축된 탈중앙화 디지털 통화 프로젝트입니다. 가장 큰 특징은 **채굴 장벽을 낮춘 것** — 비싼 ASIC 장비나 전용 그래픽 카드가 필요 없습니다. **일반 가정용 컴퓨터의 CPU로도 채굴에 참여**할 수 있습니다.

**GitHub**: https://github.com/Marcus-Vane/Bitcoin-Classic
**Stars**: 18
**언어**: C++
**라이선스**: MIT
**탐색기**: https://explorer.bitcoin-classic.net/

---

## 비전: 모든 사람이 채굴할 수 있도록

> "오늘날 거의 모든 사람이 비트코인을 들어봤지만, 실제로 채굴을 통해 비트코인을 얻은 사람은 극소수입니다."

Bitcoin-Classic의 핵심 개념은 **초기 비트코인 채굴 경험을 복원**하는 것입니다. 2009-2010년에는 누구나 가정용 컴퓨터로 비트코인을 채굴할 수 있었습니다. 하지만 ASIC 채굴기의 등장과 전문 채굴장의 부상으로 인해 개인 채굴은 이미 수익성이 없어졌습니다.

BTCC는 **낮은 난이도, CPU 친화적 채굴, 그래픽 인터페이스**를 통해 일반인이 다시 그 경험을 할 수 있도록 합니다.

---

## 핵심 기술 파라미터

### 합의 메커니즘

| 파라미터 | 설명 |
|----------|------|
| **합의 알고리즘** | SHA-256 작업 증명 (PoW) |
| **채굴 방식** | CPU / GPU (낮은 난이도 친화적) |
| **보안 모델** | 가장 긴 체인 규칙 |
| **탈중앙화** | 완전 탈중앙화, 프리마인 없음 |

### 블록 및 경제 모델

| 파라미터 | 수치 |
|----------|------|
| **총 공급량** | 21,000,000 BTCC |
| **블록 시간** | 10분 / 블록 |
| **난이도 조정** | 2016블록마다 (약 14일) |
| **초기 블록 보상** | 50 BTCC / 블록 |
| **최소 단위** | 0.00000001 BTCC |
| **반감기 주기** | 210,000블록마다 (약 4년) |

### 반감기 일정

| 블록 높이 | 블록 보상 |
|-----------|----------|
| 0 ~ 209,999 | 50 BTCC |
| 210,000 ~ 419,999 | 25 BTCC |
| 420,000 ~ 629,999 | 12.5 BTCC |

---

## 핵심 기능

### 1. 내장 그래픽 채굴기
명령줄이 필요 없습니다. 설치 패키지를 다운로드하여 실행한 후 "채굴 시작"을 클릭하면 됩니다.

### 2. CPU 친화적
네트워트 총 해시레이트가 낮아 일반 CPU도 효과적으로 채굴에 참여하고 실제 블록 보상을 받을 수 있습니다.

### 3. 경량 지갑
내장 지갑 기능으로 지갑 생성 후 자동 채굴 시작, 잔액 실시간 표시.

### 4. 블록체인 탐색기
공식 온라인 탐색기 https://explorer.bitcoin-classic.net/에서 블록, 거래, 주소 잔액 조회 가능.

---

## 빠른 시작

```
1. Bitcoin-Classic-Setup.exe 다운로드
   → https://github.com/Marcus-Vane/Bitcoin-Classic/releases

2. D 드라이브 또는 E 드라이브에 설치 (시스템 드라이브 제외 권장)

3. 첫 실행 시 블록체인 동기화 완료 대기

4. "Create a new wallet" 클릭하여 지갑 생성

5. "Start Mining" 클릭하여 채굴 시작

6. 채굴 시작 후 자동으로 채굴 지갑 생성됨,
   우측 상단에서 지갑 전환하여 잔액 확인
```

---

## 보안 주의사항

⚠️ **지갑 파일(xxx.dat)을 반드시 백업하세요**
- .dat 파일 = 당신의 개인키
- 온라인에 절대 노출하지 마세요
- 누구에게도 별내지 마세요
- 지갑 자산 소유권의 유일한 증명입니다

---

## 비트코인과 비교

| 차원 | 비트코인 (BTC) | Bitcoin-Classic (BTCC) |
|------|---------------|------------------------|
| 출시 | 2009 | 2026 |
| 합의 알고리즘 | SHA-256 PoW | SHA-256 PoW |
| 총 공급량 | 2100만 | 2100만 |
| 초기 보상 | 50 BTC | 50 BTCC |
| 채굴 장벽 | ASIC + 저렴한 전기 | 가정용 CPU |
| 네트워크 해시레이트 | 극도로 높음 (EH/s) | 매우 낮음 (CPU 가능) |
| 생태계 | 성숙 (거래소, DeFi) | 초기 (지갑 + 탐색기) |
| 투자 가치 | 높은 유동성 | 실험적 |

---

## 요약

Bitcoin-Classic은 **교육적이고 체험적인** 성격이 강한 프로젝트입니다. 기술적 배경이 전혀 없는 사용자도 "블록을 채굴하는" 성취감을 직접 느낄 수 있습니다.

하지만 현실적인 과제도 있습니다:
- GitHub Stars 18개로 극소수 커뮤니티
- 주요 거래소 지원 없음
- 장기 지속 가능성 불확실

**적합한 사람**:
- 블록체인 기초 원리를 배우고 싶은 기술 애호가
- 초기 비트코인 채굴 분위기를 체험하고 싶은 사용자
- 암호화폐와 PoW 합의 메커니즘을 공부하는 학생

> ⚠️ BTCC는 현재 시가총액과 유동성이 극히 낮습니다. 대량의 자금이나 해시파워를 투입하지 마세요.

> 💡 더 많은 블록체인 및 암호화폐 도구를 원하시나요? 매주 선별된 오픈소스 프로젝트를 위해 [dibi8.com](https://dibi8.com)을 팔로우하세요.

---

## 추천 도구

오픈소스 AI 도구 개발/배포 시 권장:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전, AI 워크로드용 원클릭 droplet.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API 프록시. 위의 AI 도구 대부분 (챗봇, 코드 생성, 번역, 검색 등) LLM API 키 필요 — 이 프록시로 안정적인 톱 모델 액세스, 공식 가격의 ~30%.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

