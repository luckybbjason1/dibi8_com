---
title: "Claude Code 메모리 주입: MemPalace로 96.6% 리콜 달성하는 완벽 가이드 (2026)"
description: "Claude Code 메모리 주입: MemPalace로 96.6% 리콜 달성하는 완벽 가이드 (2026)"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - AI
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: ""
file_md5: ""
download_url: ""
backup_url: ""
github_repo: ""
stars: 0
maintainer: ""
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /kr/posts/mempalace-guide/
faqs:
  - q: 'Claude Code에 영구 메모리를 추가하는 방법은?'
    a: 'MemPalace를 로컬에서 실행한 후, claude_code_config.json을 설정해 http://localhost:8787/mcp 엔드포인트를 읽기/쓰기 권한으로 가리키도록 하면 Claude Code에 연결됩니다. 이후 Claude는 과거 컨텍스트가 필요할 때마다 MemPalace를 시맨틱 벡터 데이터베이스로 조회합니다.'
  - q: 'Claude Code의 메모리는 세션 종료 및 재부팅 후에도 유지되나요?'
    a: '네. MemPalace는 데이터를 로컬 SQLite/ChromaDB 디스크 인스턴스에 기록하기 때문에, AI의 메모리는 재부팅, 크래시, 완전히 새로운 터미널 세션에서도 유지되며 터미널을 닫아도 사라지지 않습니다.'
  - q: 'MemPalace는 LongMemEval 벤치마크에서 얼마의 recall rate를 달성하나요?'
    a: 'MemPalace는 LongMemEval 벤치마크에서 96.6%의 recall rate를 달성합니다. 이는 Pinecone 클라우드 설정의 81.2%, 종료 시 모든 것을 잊는 순수 Claude Code의 0%와 비교됩니다.'
  - q: 'MemPalace 데이터는 로컬에 저장되나요, 아니면 클라우드로 전송되나요?'
    a: 'MemPalace는 ChromaDB를 사용해 데이터를 100% 로컬에 저장하므로, 프로젝트 컨텍스트가 외부 클라우드 서버로 전송되지 않습니다. 이는 데이터를 클라우드 서버로 전송하는 Pinecone과 다른 점입니다.'
  - q: 'MemPalace는 무료로 사용할 수 있나요?'
    a: '네. MemPalace는 MIT 라이선스 하에 오픈소스로 제공되며 $0의 비용으로 API 요금이나 구독료가 없습니다. 구독 또는 사용 요금을 부과하는 Pinecone과 달리 완전 무료입니다.'
---

{</* resource-info */>}

# Claude Code 메모리 주입: MemPalace로 96.6% 리콜 달성하는 완벽 가이드 (2026)

Claude Code는 소프트웨어 엔지니어링의 혁명입니다. 하지만 치명적인 단점이 하나 있습니다. 터미널을 닫는 순간 '기억 상실증'에 걸린다는 것입니다. 수시간 동안 설명한 아키텍처나 코딩 컨벤션이 모두 날아갑니다. 그래서 **MemPalace**가 필요합니다.

이 기술 심층 분석에서는 MemPalace의 MCP 엔드포인트를 Claude Code에 연결하여 LongMemEval 벤치마크 기준 **96.6% 리콜율**의 영구적인 장기 기억을 부여하는 방법을 소개합니다.

## 벤치마크 비교: Claude Code 메모리 솔루션

AI 에이전트가 프로젝트 히스토리를 기억하게 하려면 몇 가지 옵션이 있습니다. 2026년 개발자들이 MemPalace를 선택할 수밖에 없는 이유를 데이터로 증명합니다:

| 지표 / 프레임워크 | MemPalace (로컬 MCP) | Pinecone (클라우드) | 순정 Claude Code |
| :--- | :--- | :--- | :--- |
| **컨텍스트 리콜율** | **96.6%** | 81.2% | 0% (종료 시 망각) |
| **소스코드 프라이버시** | **100% 로컬 (ChromaDB)** | 클라우드 서버로 전송됨 | N/A |
| **API 호출 비용** | **$0 / 완전 무료** | 구독 / 종량제 과금 | N/A |
| **설정 난이도**| 쉬움 (MCP 명령어 1줄) | 어려움 (API 키 필요) | 없음 |


### MCP를 통한 네이티브 통합

MemPalace는 표준 모델 컨텍스트 프로토콜(MCP) 서버를 노출합니다. `claude_code_config.json`을 수정하여 `http://localhost:8787/mcp`를 가리키도록 하고 읽기/쓰기 권한을 부여하기만 하면 됩니다. 이제 Claude에게 '이 아키텍처 결정을 기억해둬'라고 말하면, 자동으로 MemPalace의 원문-벡터 이중 스토리지에 저장됩니다.

## FAQ

**Q: Claude Code에 메모리를 어떻게 추가하나요? (How to add memory to Claude Code?)**
A: 로컬에서 MemPalace를 실행하고 해당 MCP 엔드포인트를 Claude Code에 전달하면 됩니다. MemPalace는 Claude가 과거의 컨텍스트가 필요할 때 언제든 자연스럽게 쿼리할 수 있는 시맨틱 벡터 데이터베이스 역할을 합니다.

**Q: Claude Code 세션 메모리 영구 보존이 가능한가요?**
A: 네. MemPalace는 데이터를 로컬 SQLite/ChromaDB 디스크에 기록하기 때문에, 컴퓨터를 재부팅하거나 완전히 새로운 터미널 세션을 열어도 AI의 메모리는 영구적으로 유지됩니다.

---

## 추천 도구

오픈소스 AI 도구 개발/배포 시 권장:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전, AI 워크로드용 원클릭 droplet.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API 프록시. 위의 AI 도구 대부분 (챗봇, 코드 생성, 번역, 검색 등) LLM API 키 필요 — 이 프록시로 안정적인 톱 모델 액세스, 공식 가격의 ~30%.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

