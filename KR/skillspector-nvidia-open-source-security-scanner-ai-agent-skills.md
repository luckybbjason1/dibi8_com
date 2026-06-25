---
title: 'SkillSpector: AI 에이전트 스킬을 위한 NVIDIA의 오픈소스 보안 스캐너'
description: 에이전트 스킬 설치 전 취약점, 악성 패턴 및 보안 위험을 감지하는 AI 에이전트 스킬 전용 보안 스캐너. NVIDIA에서 10K 스타 획득. Claude Code, Codex CLI 및 기타 에이전트 프레임워크를 보호하세요.
date: 2026-06-25
lastmod: 2026-06-25
draft: false
category: dev-utils
tags: ['security', 'ai-agents', 'scanner', 'vulnerability-detection', 'claude-code', 'codex', 'mcp', 'agent-skills', 'nvidia']
slug: skillspector-nvidia-open-source-security-scanner-ai-agent-skills
featureImage: /images/articles/skillspector-nvidias-open-source-security-scanner-for-ai-agent-skills.png
lang: kr
github_repo: https://github.com/NVIDIA/SkillSpector
license: Apache-2.0
---



# SkillSpector: AI 에이전트 스킬을 위한 NVIDIA의 오픈소스 보안 스캐너

**SkillSpector**는 Claude Code, GitHub Copilot, Codex CLI, Gemini CLI 등의 프레임워크를 powering하는 모듈형 플러그인 및 확장 프로그램인 AI 에이전트 스킬을 위해 특별히 설계된 보안 스캔 도구입니다. NVIDIA에서 개발했으며 GitHub에서 **10,273개의 스타**를 기록했으며, 프로덕션 환경에서 검증되지 않은 에이전트 스킬을 설치하는 것과 관련된 급증하는 보안 문제를 해결합니다.

이 문서에서는 설치 방법, 스캔 기능, 취약점 감지, 에이전트 프레임워크와의 통합, AI 에이전트 생태계 보안을 위한 모범 사례를 다룹니다.

## TL;DR

AI 에이전트 스킬이 점점 더 인기를 얻으면서 검증되지 않은 스킬을 설치하는 보안 위험도 함께 증가하고 있습니다. SkillSpector는 800개 이상의 사이버보안 스킬에 대해 자동 스캔을 제공하며, 이러한 위험이 시스템에 도달하기 전에 취약점, 악성 패턴 및 보안 위험을 감지합니다. 모든 주요 에이전트 프레임워크를 지원하며 실행 가능한 복구 지침을 제공합니다.

## SkillSpector란?

SkillSpector은 중요한 관찰에서 탄생했습니다: AI 에이전트 스킬이 개발자 워크플로우 전반에 확산되면서 보안 공격 표면이 극적으로 확대되고 있습니다. 엄격한 코드 검토를 거치는 전통적인 소프트웨어 패키지와 달리 많은 에이전트 스킬은 간단한 텍스트 파일(SKILL.md)로, 임의의 작업을 수행하도록 LLM에게 지시합니다 — 셸 명령 실행, API 접근, 파일 수정 등을 포함합니다.

이 도구는 다음을 제공합니다:

- **AI 에이전트 스킬 파일에 대한 자동화된 취약점 스캔**
- **패턴 기반 악성 동작 감지** — 명령 삽입, 데이터 유출, 권한 상승 포함
- **프레임워크별 분석** — Claude Code, GitHub Copilot, Codex CLI 등 지원
- **복구 지침** — 감지된 취약점에 대한 구체적인 수정 사항 제공
- **CI/CD 통합** — 자동 파이프라인에서 설치 전 스캔 지원

## 설치 가이드

### 사전 요구사항

- **Python**: 3.12+ (비동기 스캔 기능 필수)
- **운영 체제**: Linux, macOS 또는 Windows WSL2
- **디스크 공간**: 500MB (스캐너 + 스킬 데이터베이스)
- **네트워크**: 스킬 데이터베이스 및 업데이트 다운로드에 필요

### 옵션 1: Pip 설치

```bash
# PyPI에서 SkillSpector 설치
pip install skillspector

# 설치 확인
skillspector --version

# 최신 스킬 데이터베이스 다운로드
skillspector update-db
```

### 옵션 2: 소스에서 설치

```bash
# 저장소 복제
git clone https://github.com/NVIDIA/SkillSpector.git
cd SkillSpector

# 가상 환경 생성
python -m venv .venv
source .venv/bin/activate

# 개발 모드 설치
pip install -e .

# 스캐너 초기화
skillspector init --download-database
```

### 옵션 3: Docker 배포

```bash
# 공식 이미지 가져오기
docker pull nvcr.io/nvidia/skillspector:latest

# 스캔 실행
docker run --rm \
  -v ${PWD}/skills:/app/skills \
  nvcr.io/nvidia/skillspector:latest \
  scan /app/skills

# 정기 스캔 예약
docker run -d \
  --name skillspector \
  -v ${PWD}/skills:/app/skills \
  -v ${PWD}/reports:/app/reports \
  nvcr.io/nvidia/skillspector:latest \
  daemon --interval 3600
```

## 스캔 기능

### 취약점 감지 카테고리

SkillSpector는 여러 카테고리에서 취약점을 감지합니다:

| 카테고리 | 설명 | 심각도 |
|
커뮤니티 가입: [Telegram](https://t.me/DIBI8_Group) · [HuggingFace](https://huggingface.co/collections/nvidia/cosmos3)

내부 링크: [nvidia-cosmos-world-models-platform-2026](https://dibi8.com/kr/resources/ai-tools/nvidia-cosmos-world-models-platform-2026) · [bytedance-ui-tars-desktop-ai-agent-guide](https://dibi8.com/kr/resources/ai-tools/bytedance-ui-tars-desktop-ai-agent-guide)

**고지 사항**: 본 기사는 제휴 관계가 있을 수 있는 도구를 언급합니다. 우리는 리뷰에 대한 대가를 받지 않습니다. 모든 의견은 우리 자신의 것입니다.
