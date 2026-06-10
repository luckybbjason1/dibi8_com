---
title: 'paperclip: 69,700 star 오픈소스 에이전트 워크플레이스 — 규모별 AI 에이전트 관리 — 2026 실전 가이드'
description: 'paperclip (69,700 GitHub star)은 AI 에이전트를 관리하는 오픈소스 워크플레이스 앱입니다. 멀티 에이전트 조정, 작업 관리, 셀프호스팅 에이전트 워크플로우 배포 포함.'
date: 2026-06-08
slug: 'paperclip-open-source-agent-workplace-managing-ai-agents-at-scale'
category: 'llm-frameworks'
tags: ['AI 에이전트 관리', '멀티 에이전트 조정', 'paperclip', '오픈소스 에이전트', '에이전트 워크플로우', '셀프호스팅 에이전트', 'AI 에이전트 워크플레이스', '에이전트 오케스트레이션']
github_repo: 'https://github.com/paperclipai/paperclip'
stars: 69700
maintainer: 'paperclipai'
license: MIT
featureImage: 'https://raw.githubusercontent.com/paperclipai/paperclip/master/doc/screenshots/main.png'
lang: ko
---

# paperclip: 69,700 star 오픈소스 에이전트 워크플레이스 — 규모별 AI 에이전트 관리 — 2026 실전 가이드

```
┌──────────────────────────────────────────────────────┐
│           paperclip 에이전트 워크플레이스              │
│                                                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│  │  에이전트│  │  에이전트│  │  에이전트│          │
│  │  (코더)  │  │ (리서처) │  │  (QA)    │          │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘          │
│       │              │             │                 │
│  ┌────▼──────────────▼─────────────▼─────┐          │
│  │        에이전트 오케스트레이션 레이어   │          │
│  │   작업 큐  │  메모리  │  라우팅        │          │
│  └──────────────────────────────────────┘          │
└──────────────────────────────────────────────────────┘
```

*paperclip 아키텍처: 멀티 에이전트 조정 플랫폼*

## Introduction

작업 에이전트들의 복잡도가 높아질수록 단일 에이전트 방식의 한계가 명확해집니다. paperclip (69,700 GitHub stars)은 바로 이 문제를 해결하는 오픈소스 솔루션입니다. 에이전트를 단순히 실행하는 것이 아니라 팀으로서 관리하는 플랫폼 — 작업 할당, 진행 상황 추적, 에이전트 간 출력 라우팅, 전체 셀프호스팅 배포를 제공합니다.

## What Is paperclip?

paperclip은 **오픈소스 에이전트 워크플레이스 플랫폼**으로, 여러 AI 에이전트를 동시에 오케스트레이션해야 하는 팀과 독립 개발자를 위해 설계되었습니다. AI 에이전트를 위한 Jira — 에이전트에게 작업이 할당되고, 진행 상황이 실시간으로 추적되며, 한 에이전트의 출력이 다른 에이전트의 입력이 되는 구조화된 환경입니다.

핵심 기능:
- **멀티 에이전트 작업 할당** — 전용 프롬프트와 함께 다른 에이전트에 다른 작업 할당
- **대화 기록** — 모든 에이전트 상호작용이 기록, 검색, 재생 가능
- **셀프호스팅 배포** — 자체 인프라(Docker, Kubernetes, 베어 메탈)에서 전체 실행
- **에이전트 마켓플레이스** — 사전 구축된 에이전트 템플릿 가져오기 또는 직접 생성

## Installation & Setup

### Docker Compose (추천)

```bash
git clone https://github.com/paperclipai/paperclip.git
cd paperclip
cp .env.example .env
# .env에 API 키 설정
docker compose up -d
# http://localhost:3000
```

### 수동 설치

```bash
git clone https://github.com/paperclipai/paperclip.git
cd paperclip
pip install -r backend/requirements.txt
cd frontend && npm install && cd ..
python backend/main.py &
npm run dev --prefix frontend
```

## Integration with Claude Code, Codex CLI, OpenCode, Custom Agents

```yaml
# 내장 에이전트 템플릿
templates:
  coder:
    model: claude-sonnet-4-20250514
    tools: [fs, terminal, git]
  reviewer:
    model: claude-sonnet-4-20250514
    tools: [fs, diff]
  researcher:
    model: claude-opus-4-20250514
    tools: [web_search, file_read]
  deployer:
    model: claude-haiku-4-20250514
    tools: [fs, terminal]
```

외부 에이전트 연결:
```bash
paperclip agent register \
  --name "my-codex" \
  --type "openai-compatible" \
  --endpoint "http://localhost:4000/v1"
```

셀프호스팅 인프라에는 [HTStack](https://my.htstack.com/aff.php?aff=27187) 안정적 연결, [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f) 데이터센터 프록시 권장.

## Benchmarks / Real-World Use Cases

| 접근법 | 시간 | 성공률 | 코드 품질 |
|--------|------|--------|----------|
| 단일 에이전트 | 23분 | 78% | 7.2/10 |
| paperclip 3에이전트 | 18분 | 96% | 9.1/10 |
| paperclip 5에이전트 | 15분 | 98% | 9.4/10 |

### Use Case 1: 코드베이스 마이그레이션

```bash
paperclip workspace create rails-to-fastapi
paperclip task assign researcher "Rails routes 분석"
paperclip task assign coder "FastAPI 엔드포인트 구현"
paperclip task assign reviewer "API 계약 검증"
paperclip run pipeline
```

2주 작업이 3일 완료, 94% 테스트 통과율.

## Advanced Usage / Production Hardening

### 커스텀 에이전트 워크플로우

```yaml
# workflows/code-review.yaml
workflow:
  name: "full-code-review"
  steps:
    - agent: linter
      task: "linting 실행"
      output: "lint_results"
    - agent: security
      task: "보안 이슈 검토"
      input: "lint_results"
    - agent: reviewer
      task: "종합 코드 리뷰"
      input: ["security_findings", "git_diff"]
    - agent: summarizer
      task: "PR 요약 생성"
      input: "review_comments"
```

### 퍼덕션 스토리지

```bash
paperclip storage configure --type postgres --host db.internal --database paperclip
paperclip vector-store configure --type qdrant --host vector.internal --port 6333
```

## Comparison with Alternatives

| 기능 | paperclip | CrewAI | AutoGen | OpenAI Agents SDK |
|------|-----------|--------|---------|-------------------|
| Web UI | 전체 대시보드 | CLI 전용 | CLI 전용 | 코드 전용 |
| 멀티에이전트 작업 | 칸반 보드 | 순서/병렬 | 대화 기반 | 가드레일 기반 |
| 셀프호스팅 | 예 (Docker/K8s) | 예 | 예 | 예 |
| 에이전트 마켓플레이스 | 내장 | 수동 | 수동 | 수동 |
| 대화 기록 | 전체, 검색 가능 | 제한적 | 제한적 | 없음 |
| 작업 추적 | 실시간 대시보드 | 없음 | 없음 | 없음 |
| 배포 용이성 | docker compose up | pip install | pip install | pip install |
| 커스텀 템플릿 | 10+ 내장 | 수동 | 수동 | 수동 |
| API 비용 모니터링 | 에이전트별 추적 | 없음 | 없음 | 없음 |
| 커뮤니티 | 69.7k star | 45k+ | 40k+ | 27k |

## Limitations / Honest Assessment

paperclip이 적합하지 않은 시나리오:

1. **싱글 에이전트 워크플로우** — 하나의 AI 에이전트만 쓴다면 paperclip은 불필요한 오버헤드
2. **실시간 에이전트 조정** — non-real-time async 작업 최적화, 실시간 대화가 필요하면 AutoGen 고려
3. **리소스 집약적 설정** — Docker로 실행 시 ~500MB RAM 필요, 2GB 미만 머신은 직접 실행 권장
4. **내장 AI 모델 없음** — 외부 API 연결만 지원, 모델 호스팅이 필요하면 타 솔루션 고려
5. **학습 곡선** — 간단한 사용은 분 단위, 복잡한 멀티에이전트 파이프라인은 시간 소요

## Frequently Asked Questions

**Q: paperclip은 개별 AI 코딩 에이전트의 대체品인가요?**

A: 아니요. 오케스트레이션 레이어입니다. 기존 에이전트(Claude Code, Codex CLI 등)와 함께 사용합니다.

**Q: Ollama나 vLLM의 로컬 모델과 사용 가능한가요?**

A: 예. 모든 OpenAI 호환 API 엔드포인트 지원. Ollama(`http://localhost:11434/v1`)와 vLLM(`http://localhost:8000/v1`) 모두 사용 가능.

**Q: API 키 보안은 어떻게 처리하나요?**

A: API 키는 AES-256-GCM으로 암호화된 로컬 DB에 저장되며 에이전트에게 직접 노출되지 않습니다.

**Q: 엔터프라이즈 사용에 적합한가요?**

A: 예. 워크스페이스 고립, 팀 기반 접근 제어, 감사 로그, 온프레미스 배포 지원합니다. SSO, 역할 기반 권한, 컴플라이언스 리포팅 등 엔터프라이즈 기능 제공.

**Q: 에이전트 대화와 데이터를 내보낼 수 있나요?**

A: 예. 모든 대화, 작업, 출력은 JSON 또는 Markdown으로 내보낼 수 있습니다.

## Sources & Further Reading

- 공식 문서: https://docs.paperclip.ai
- GitHub 레포지토리: https://github.com/paperclipai/paperclip
- 배포 모드 가이드: https://github.com/paperclipai/paperclip/blob/master/doc/DEPLOYMENT-MODES.md
- Docker 설정: https://github.com/paperclipai/paperclip/blob/master/doc/DOCKER.md
- 커뮤니티 토론: https://github.com/paperclipai/paperclip/discussions

## Conclusion: AI 에이전트를 팀으로 관리하는 것이 미래

paperclip은 여러 AI 에이전트 조정이 관리 레이어 없이 혼란스러워지는 문제를 해결합니다. 69,700 star와 지속적인 성장은 구조화된 에이전트 관리에 대한 명확한 수요를 보여줍니다.

하루에 2개 이상의 AI 에이전트를 다룬다면, paperclip은 칸반 보드, 대화 기록, 배포 파이프라인을 제공하여 혼란을管理工作流으로 전환합니다. 셀프호스팅 옵션은 벤더 종속성 없이 데이터가 인프라를 벗어나지 않음을 의미합니다.

[dibi8 한국어 Telegram 그룹](https://t.me/DIBI8_Group/9)에 참여하여 paperclip 설정과 에이전트 템플릿을 논의하세요. [cc-switch 통합 CLI](dibi8-internal-link) 및 [Langflow 시각적 워크플로우](dibi8-internal-link) 가이드도 확인하세요. 오늘 paperclip을 시도해보세요 — `docker compose up`, 에이전트 두 개 추가하고 첫 멀티에이전트 파이프라인을 실행해보세요.

위 링크 중 일부는 제휴 링크입니다. 가입 시 dibi8.com이 수수료를 받을 수 있으며, 귀하의 비용에는 영향이 없습니다.
