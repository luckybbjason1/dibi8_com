---
title: "ECC (affaan-m/ECC): 2026년 최고 Agent 제어 시스템"
description: "ECC는 265K GitHub stars를 갖춘 agent harness 성능 최적화 시스템입니다. 68개 agents, 286개 skills, 94개 commands 지원. AgentShield 보안 내장. Claude Code, Codex, Cursor, OpenCode 호환."
date: 2026-09-22
lastmod: 2026-09-22
tags: [github, ecc, claude-code, coding-agent, performance]
category: github-tools
image: https://raw.githubusercontent.com/affaan-m/ECC/main/assets/hero.png
related_posts:
  - /ko/archify-diagrams
  - /ko/rag-systems-2026
  - /ko/ai-coding-agents-comparison
toc: true
---

## ECC란?

**ECC** (Agent Harness Performance Optimization System)는 `affaan-m`이 개발한 **265,039 stars**를 기록한 도구입니다. 단순한 스킬 패키지가 아닌 당신의 코딩 agent를 위한 운영체제입니다.

![ECC Hero Image](https://raw.githubusercontent.com/affaan-m/ECC/main/assets/hero.png)

> **빠른 요약:** ECC는 AI 코딩 에이전트를 "코드 작성 도구"에서 "협업 엔지니어링 시스템"으로 변환합니다 — 빌드 전에 계획하고, 검증 전에 테스트하고, 새로울 컨텍스트에서 작업을 검토하며, 지속적인 학습을 통해 반복된 성공을 재사용 가능한 스킬과 워크플로로 변환합니다.

## 왜 ECC가 특별한가?

### 1. 숫자가 말해줍니다

| 구성 요소 | 수량 |
|-----------|------|
| Agents | 68 |
| Skills | 286 |
| Commands | 94 |
| Hooks/Rules | 런타임 지원 |
| AgentShield | 내장 통합 |

### 2. 다중 플랫폼 지원

ECC는 단일 에이전트에 국한되지 않습니다:

- ✅ **Claude Code** — 네이티브 지원
- ✅ **OpenAI Codex** — 동기화 경로 있음
- ✅ **Cursor** — 로컬 어댑터
- ✅ **OpenCode** — 완전한 플러그인
- ✅ **Gemini CLI** — 미니멀 설치
- ✅ **Zed** — 로컬 어댑터
- ✅ **Hermes** — 전용 설정 가이드
- ✅ **기타**: Antigravity, Qwen, Kimi, CodeBuddy, JoyCode, GitHub Copilot

### 3. AgentShield — 자동 보안

귀중한 기능: **AgentShield**가 자동으로 스캔합니다:
- 악의적인 프롬프트
- 위험한 MCP 구성
- 누설된 시크릿
- 권한 남용

## 설치 방법

### Claude Code 사용
```bash
# 방법 1: 설치 스크립트
./install.sh --profile minimal --target claude

# 방법 2: 플러그인 사용
claude plugin install ecc@ecc
```

### Codex CLI 사용
```bash
./install.sh --profile minimal --target codex
```

### Cursor 사용
```bash
./install.sh --profile minimal --target cursor
```

### 수동 설치 (크로스 플랫폼)
```bash
npm install -g ecc-universal
npm install -g ecc-agentshield
```

## 사용 가능한 Agents

### Planning Agents
- `planner` — 요구사항 분석, 계획 수립
- `tdd-workflow` — 테스트 먼저 강제
- `spec-analyzer` — 사양 분석

### Security Agents
- `security-reviewer` — 코드 보안 검토
- `dependency-auditor` — 의존성 취약점 스캔
- `prompt-injection-detector` — 주입 공격 감지

### Architecture Agents
- `architecture-reviewer` — 시스템 아키텍처 검토
- `performance-analyst` — 성능 분석 및 최적화
- `code-reviewer` — 코드 품질 검토

### Domain Agents
- `database-reviewer` — 데이터베이스 쿼리 감사
- `api-designer` — REST/GraphQL API 설계
- `frontend-developer` — UI/UX 구현

## 대안과 비교

| 기능 | ECC | Ponytail | agent-skills |
|------|-----|----------|--------------|
| Agent 수 | 68 | 간결성 집중 | 20+ 스킬 |
| 보안 | AgentShield 내장 | 없음 | 기본 |
| 다중 플랫폼 | 10+ agents | Claude Code 집중 | 다양한 |
| 학습 시스템 | 지속적 학습 | 정적 규칙 | 정적 규칙 |
| 가격 | 오픈 소스 (MIT) | 오픈 소스 | 오픈 소스 |

## 왜 사용해야 하나요?

1. **코딩 전에 계획** —盲目的으로 코드 작성하지 않기
2. **테스트 주도 개발** — 먼저 테스트 작성, 나중에 코드
3. **보안 우선** — AgentShield가 자동으로 보호
4. **지속적 학습** — 모든 세션에서 학습
5. **크로스 헐리스** — 다양한 AI 도구와 호환

## 결론

ECC는 단순한 스킬 패키지가 아닙니다 — 그것은 **당신의 AI 코딩 agent를 위한 운영체제**입니다. 265K stars와 빠르게 성장하는 커뮤니티를 갖춘 ECC는 AI 워크플로우를 최적화하려는 개발者的首选입니다.

**링크:** [github.com/affaan-m/ECC](https://github.com/affaan-m/ECC)
**문서:** [ecc.tools](https://ecc.tools)
