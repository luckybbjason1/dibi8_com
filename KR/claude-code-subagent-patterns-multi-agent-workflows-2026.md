---
title: 'Claude Code 서브에이전트(Subagent) 실전: 매일 몇 시간을 아껴주는 5가지 멀티에이전트 워크플로 (2026)'
description: '프로덕션에서 검증된 5가지 Claude Code subagent 패턴 — 병렬 리서치, worktree 격리, 전문가 위임, 컨텍스트 보호, 파이프라인 오케스트레이션. 실제 프롬프트와 트레이드오프 포함.'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'CLI', 'Bash']
application_domain: LLM Frameworks
source_version: ''
licensing_model: 상용 (Anthropic)
license_type: 'Proprietary'
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/anthropics/claude-code'
stars: 0
maintainer: 'Anthropic'
last_maintained: '2026-05-28'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['claude-code', 'subagents', 'multi-agent', 'ai-coding-agents', 'llm-frameworks', 'developer-tools', 'agent-sdk']
aliases:
- /posts/claude-code-subagent-patterns/
faq:
  - q: "Claude Code의 subagent란 정확히 무엇이며, CLI를 한 번 더 실행하는 것과 어떻게 다른가요?"
    a: "Subagent는 활성 Claude 세션 내부에서 Agent(Task) 도구를 통해 생성되는 샌드박스화된 Claude 대화입니다. 부모 세션은 subagent의 최종 보고서만 보고 — 중간 도구 호출, 파일 읽기, 사고 과정은 보지 못합니다. 이것이 두 번째 CLI를 실행하는 것과의 핵심 차이입니다: 부모의 컨텍스트 윈도우가 subagent의 탐색 노이즈로부터 보호됩니다. Subagent는 병렬 리서치, 깊은 코드 탐색, 격리된 실험에 적합합니다 — 부모의 작업 기억이 오염되지 않아야 하는 상황입니다."
  - q: "Subagent를 사용하지 말고 부모 세션에서 계속 작업해야 할 때는 언제인가요?"
    a: "부모가 이미 파일을 열어두었거나 컨텍스트를 로드한 사소한 조회, 각 중간 상태를 봐야 하는 순차 편집, 그리고 subagent가 양방향 통신을 해야 하는 긴밀하게 결합된 변경 (subagent는 일회성입니다 — 단일 보고서만 반환합니다)에는 subagent를 건너뛰세요. 경험 법칙: 현재 상태에서 3번 이하의 도구 호출로 답할 수 있다면, 인라인으로 처리하세요."
  - q: "여러 subagent를 병렬로 안전하게 실행하려면 어떻게 해야 하나요?"
    a: "여러 Agent 도구 호출을 하나의 메시지에서 호출하세요. 하니스가 동시에 fan-out 합니다. 안전 고려사항: 서로 겹치지 않는 범위를 전달하고 ('subagent A는 /auth/, B는 /payments/ 감사'), 두 subagent가 같은 파일에 쓰지 않도록 하고, subagent가 겹치는 코드에 사소하지 않은 편집을 해야 할 때는 git worktree를 사용하세요 (각 worktree가 subagent에 자체 작업 트리를 제공해 간섭을 막습니다)."
  - q: "Subagent 기반 개발에서 주의해야 할 실패 모드는 무엇인가요?"
    a: "Subagent는 요약을 반환합니다 — 그것이 무엇을 하려 했는지를 설명할 뿐, 반드시 무엇을 실제로 했는지는 아닙니다. 가장 흔한 실패는 subagent의 보고서를 검증 없이 사실로 받아들이는 것입니다. 산문 요약이 아닌 실제 파일 변경(git diff) 또는 테스트 결과를 항상 확인하세요. '나는 auth 모듈을 리팩토링했다'고 주장하는 subagent가 타입 체크는 통과하지만 런타임 동작은 깨뜨리는 얕은 편집만 했을 수 있습니다."
  - q: "전용 subagent를 직접 만들 수 있나요, 아니면 내장된 것에만 의존해야 하나요?"
    a: "Claude Code는 Agent SDK와 agent frontmatter 파일을 통해 사용자 정의 agent 정의를 지원합니다. 팀 전용 'database-migration-reviewer' 또는 'security-auditor'를 description, system prompt, 도구 허용 목록을 포함한 markdown 파일로 출시할 수 있습니다. 부모 agent가 위임을 결정할 때, 당신의 사용자 정의 타입을 선택할 수 있습니다. 이것이 팀이 리뷰 체크리스트, 규정 준수 게이트, 도메인 전문성을 재사용 가능한 agent 페르소나로 인코딩하는 방식입니다."
  - q: "Claude Code subagent 가격은 어떻게 작동하나요 — 각각에 대해 별도로 청구되나요?"
    a: "각 subagent 호출은 다른 Claude 대화처럼 토큰을 소비합니다. 비용은 대략 subagent의 전체 컨텍스트입니다 (시스템 프롬프트 + 도구 스키마 + 작업 프롬프트 + 사고 + 최종 보고서). Pro와 Max 플랜에서 subagent 사용은 부모 세션과 같은 사용 한도에 산입됩니다. API 사용자의 경우 토큰당 직접 청구됩니다. 절약은 부모 컨텍스트를 부풀릴 탐색을 분담함으로써 발생합니다 — subagent에 비용을 지불하지만, 메인 세션은 빠르고 집중된 상태로 유지됩니다."
---

## 들어가며

2025년 말, 싱글 스레드 AI 코딩이 벽에 부딪쳤습니다. Claude에게 "결제 모듈을 리팩토링해줘"라고 요청하면, 30개 파일을 읽고, 컨텍스트 윈도우를 탐색 내용으로 채운 다음, 필요한 작업 기억의 절반만 가지고 편집을 시작했습니다. 반년과 한 번의 패러다임 전환 후, 답은 당혹스러울 정도로 단순했습니다: **모든 일을 한 대화에서 처리하지 마세요**.

이 글은 일일 프로덕션 사용에서 가치를 증명한 5가지 Claude Code subagent 패턴을 안내합니다 — 솔로 인디 개발자 워크플로, 멀티 엔지니어 팀, AI 보조 리서치 파이프라인을 망라합니다. 각 패턴에는 실제 프롬프트 형태, 회피하는 실패 모드, 채택 시 받아들여야 할 트레이드오프가 포함됩니다. 어느 것도 이론이 아닙니다. 우리가 컨텍스트 윈도우를 태우지 않고 더 빠르게 출시하기 위해 사용하는 패턴들입니다.

이미 [공식 CLI](https://docs.anthropic.com/en/docs/claude-code)를 통해 Claude Code를 사용 중이고 "하나의 큰 대화"에서 졸업해 조율된 멀티에이전트 워크플로로 가고 싶다면, 이것이 플레이북입니다. [Superpowers 프레임워크](/kr/resources/llm-frameworks/superpowers/)와 [Aider의 솔로 에이전트 모델](/kr/vs/claude-code-vs-aider/)과 비교해 subagent 접근이 철학적으로 어떻게 다른지 살펴보세요.

## 패턴 1: 병렬 리서치 fan-out

**문제.** "코드베이스에서 X를 어디서 처리하는가?", "Y를 위한 우리 패턴은 무엇인가?", "더 이상 사용되지 않는 함수 Z의 사용 사례가 있는가?" — 세 가지 독립적인 질문입니다. 부모 대화에서 순차적으로 처리하면 세 번의 파일 읽기 라운드와 세 번의 컨텍스트 윈도우 주입이 됩니다. 세 답변을 모두 얻을 즈음, 부모는 grep 출력 40k 토큰과 실제 작업을 위한 여유 공간 0을 갖게 됩니다.

**패턴.** 세 개의 Explore subagent를 병렬로 생성합니다. 각각 질문 하나씩. 각각 자체 샌드박스 컨텍스트에서 실행됩니다. 각각 짧은 보고서를 반환합니다. 부모는 세 개의 grep dump 대신 세 개의 간결한 문단을 봅니다.

```
단일 메시지 → 3개의 Agent 도구 호출:
  - Agent("auth 핸들러 찾기", subagent_type="Explore", prompt="...")
  - Agent("상태 관리 매핑", subagent_type="Explore", prompt="...")
  - Agent("폐기된 fn Z 사용처 찾기", subagent_type="Explore", prompt="...")
```

**회피하는 실패 모드.** 컨텍스트 윈도우 팽창. 부모 세션이 가볍게 유지되어 실제 구현 대화를 담을 수 있습니다.

**트레이드오프.** 단일 부모 대화 대신 세 번의 subagent 호출에 비용을 지불합니다. 사소하지 않은 검색에 대해서는 수학이 이깁니다 — Explore subagent는 여러 도구에 걸쳐 fan out 하고 종합된 답변만 반환합니다.

## 패턴 2: 위험한 편집을 위한 worktree 격리

**문제.** Subagent가 리팩토링을 시도하길 원하지만, 잘못되면 수동으로 `git reset --hard`를 하고 싶지 않습니다. 또한 subagent가 메인 worktree의 활성 변경 사항을 방해하지 않고 테스트를 실행할 수 있길 원합니다.

**패턴.** Agent 호출에 worktree 격리 매개변수를 사용합니다. Subagent는 현재 상태에서 분기된 임시 git worktree에서 작동합니다. 변경을 만들면, worktree 경로를 돌려받아 여유롭게 검토, cherry-pick, 또는 폐기할 수 있습니다. 변경이 없으면 worktree는 자동으로 정리됩니다.

```
Agent({
  description: "컨트롤러 레벨 리팩토링 시도",
  isolation: "worktree",
  prompt: "controllers/orders.rb를 리팩토링해 검증 로직을 추출..."
})
```

**회피하는 실패 모드.** 평가할 기회를 갖기 전에 작업 트리를 오염시키는 반쯤 완료된 리팩토링.

**트레이드오프.** 일부 시나리오 — 부모가 즉시 호출해야 하는 단일 함수를 추가하는 것과 같은 — 는 worktree 격리의 이점이 없습니다. 어차피 다시 병합해야 하기 때문입니다. 이 패턴은 탐색적이거나 위험한 변경을 위해 남겨두세요.

## 패턴 3: 전문가 위임

**문제.** 코드 리뷰, 보안 감사, 접근성 감사, SQL 쿼리 최적화 — 모두 집중된 사고방식의 혜택을 받지만, 동시에 기능을 작성하고 있으면 유지하기 어렵습니다. 일반 Claude는 이 모든 것에 능숙하지만, 전문화된 프롬프팅이 더 좋습니다.

**패턴.** `subagent_type` 매개변수를 사용해 전문가에게 위임합니다. `code-reviewer` subagent는 diff를 읽고 신뢰도와 함께 발견 사항을 보고합니다. security-auditor는 위협 모델링 안경을 끼고 동일한 diff를 읽습니다. 당신은 부모 대화에서 기능을 계속 만듭니다.

```
Agent({
  description: "독립 코드 리뷰",
  subagent_type: "code-reviewer",
  prompt: "feat/payment-gateway 브랜치의 변경 사항 리뷰. 재시도 로직에
   대한 두 번째 의견 원함 — 멱등성은 확인했지만 독립 검증 원함.
   보고: 동시 실패 하에서 안전한가?"
})
```

**회피하는 실패 모드.** "내가 작성했으니 맞을 거야" 사각지대. 당신의 대화 컨텍스트가 없는 별도의 agent는 진정으로 독립적입니다.

**트레이드오프.** 전문가는 범용 에이전트보다 좁은 도구 세트를 가집니다. code-reviewer에게 마이그레이션 스크립트도 생성하라고 하지 마세요.

## 패턴 4: 긴 세션의 컨텍스트 윈도우 보호

**문제.** 디버깅 세션 4시간째입니다. 부모 컨텍스트는 스택 트레이스, 로그 덤프, 막다른 가설 분기로 무겁습니다. 8개 파일을 읽어야 하는 "뭔가 확인하러 가야" 합니다. 인라인으로 하면 압축에 빠져 디버깅 상태를 함께 묶어 두는 부하 분담 컨텍스트를 잃게 됩니다.

**패턴.** 부모 세션을 전략 계층으로 취급하고 모든 탐색적 잠수를 subagent에 밀어냅니다. 부모는 "X를 알아내라"라고 말합니다 — subagent는 "답은 Y, 증거 한 줄"을 반환합니다. 디버깅 상태가 손상되지 않습니다.

이것이 가장 빨리 본전을 뽑는 패턴입니다. 1시간차에 컨텍스트 압축에 걸렸을 두 시간 디버깅 세션이 탐색이 분담되면 전체 기간 동안 깨끗하게 실행될 수 있습니다.

**회피하는 실패 모드.** 디버그 중 조기 컨텍스트 압축 — 종종 원래 증상이나 핵심 재현 단계를 떨어뜨립니다.

**트레이드오프.** 탐색을 "볼" 능력을 잃습니다. Subagent의 보고서가 불완전하면 후속 질문을 하는 대신 더 엄격한 프롬프트로 다른 것을 생성해야 합니다.

## 패턴 5: 사용자 정의 agent를 통한 파이프라인 오케스트레이션

**문제.** 팀에 8단계 리뷰 체크리스트가 문서화되어 있습니다. 주니어 엔지니어는 급할 때 3, 5, 7단계를 건너뜁니다. PR 리뷰 경찰이 되지 않고 체크리스트가 강제되길 원합니다.

**패턴.** 체크리스트를 repo의 사용자 정의 subagent로 인코딩합니다. Claude Code가 설치된 누구나 호출할 수 있습니다. 체크리스트는 실행 가능해집니다: 각 단계에 대한 구조화된 보고서를 생성합니다.

```
.claude/agents/migration-reviewer.md  # 사용자 정의 subagent 정의
.claude/agents/security-gate.md
.claude/agents/perf-budget-checker.md
```

팀 멤버가 오케스트레이터를 실행하면, 세 개 모두에 fan out 할 수 있습니다: migration-reviewer는 SQL을 감사하고, security-gate는 auth 터치를 감사하고, perf-budget-checker는 요청 핫 패스를 건드리는 모든 것을 감사합니다. 각각 구조화된 보고서를 반환합니다. 오케스트레이터가 집계합니다.

**회피하는 실패 모드.** "팀의 리뷰 기준"과 "누군가 급할 때 실제로 확인되는 것" 사이의 표류.

**트레이드오프.** 사용자 정의 agent는 버전 관리되는 아티팩트입니다. 다른 코드처럼 유지보수가 필요합니다. 분기별 리뷰를 스케줄링하지 않으면 부패합니다.

## 근본 원칙

다섯 패턴 모두 하나의 설계 직관을 공유합니다: **부모 대화는 희소한 자원이며, subagent는 그것을 고갈시키지 않고 소비하는 방법입니다**. 부모는 중요한 사고를 하는 곳입니다. Subagent는 그것이 작업 메모리에서 비용을 치르지 않고 입력을 얻는 방법입니다.

이는 2024-2025년 초반을 지배한 "하나의 슈퍼 에이전트가 모든 것을 한다"라는 본능의 반대입니다. 그 모델은 컨텍스트 압력 하에 무너졌습니다. 2026년의 답은 엄격한 정보 경계가 있는 위임된 전문화입니다 — 단일 마음 대신 작은 위원회.

## 프로덕션 준비된 Claude Code 구축하기

스케일로 멀티에이전트 워크플로를 실행하려면 세 가지 인프라 조각이 필요합니다:

1. **장기 세션을 위한 신뢰할 수 있는 호스트.** CI에서 또는 서버 측 코드베이스에 대해 Claude Code를 실행한다면, SSH 세션이 끊기거나 스로틀링되지 않는 VPS가 필요합니다. **{{< aff "htstack" "footer-cta" "HTStack" >}}** — 중국 본토에서 저지연 액세스가 가능한 홍콩 VPS, 안정적인 BGP 라우팅. dibi8.com을 호스트하는 동일한 IDC이므로, 우리는 자체 멀티에이전트 파이프라인을 그 위에서 실행합니다. 견고한 가치 등급 $5-12/월.

2. **병렬 실험을 위한 클라우드 플레이그라운드.** 각자 자체 worktree가 필요한 6+ subagent를 fan out 할 때, 여분의 CPU가 필요합니다. **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — 60일 동안 $200 무료 크레딧, 14+ 글로벌 리전. 인디 개발자들은 이것을 사용해 메인 앱과 함께 Claude Code 오케스트레이터를 호스트하고 리소스 경합 없이 실행합니다.

3. **Skills 번들.** Claude Code subagent를 처음 접한다면, 곡선의 가장 가파른 부분은 무너지지 않는 사용자 정의 agent 정의를 작성하는 것입니다. 우리는 다섯 가지 검증된 skill을 $19 번들로 Gumroad에 패키징했습니다 — 모서리의 떠 있는 CTA를 보세요 — 위 패턴을 출시하는 오케스트레이터 프롬프트가 포함되어 있습니다.

## 관련 읽기

- [OpenAI Codex CLI vs Claude Code](/kr/vs/openai-codex-cli-vs-claude-code/) — Codex의 솔로 에이전트 접근이 Claude Code의 subagent 모델과 어떻게 비교되는지.
- [Gemini CLI vs Claude Code](/kr/vs/gemini-cli-vs-claude-code/) — Gemini의 병렬 리서치 전략 vs Claude Code subagent fan out.
- [Cursor vs Claude Code](/kr/vs/cursor-vs-claude-code/) — IDE 임베디드 에이전트 vs CLI 주도 오케스트레이터.
- [MCP 서버 2026 랭킹](/kr/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/) — MCP 서버가 번들 도구 세트 너머로 subagent 능력을 어떻게 확장하는지.
- [AI 코딩 에이전트 풍경](/kr/resources/llm-frameworks/ai-coding-agent-landscape-2026-skills-mcp-opensource/) — 더 넓은 생태계 그림.

## 결론

2026년, subagent는 선택 사항이 아닙니다. 여전히 단일 Claude 대화에서 모든 작업을 하고 있다면, 조기 컨텍스트 압축과 추론 상태 손실의 특권을 위해 돈을 지불하는 것입니다. 위 다섯 가지 패턴 — 병렬 fan out, worktree 격리, 전문가 위임, 컨텍스트 보호, 파이프라인 오케스트레이션 — 은 각각 학습에 약 1시간이 들고, 각각 주당 그 몇 배의 시간을 절약합니다.

패턴 1(병렬 리서치 fan out)부터 시작하세요 — 가장 낮은 마찰 채택 지점이며 이득은 즉시 옵니다. 세션이 길어지고 작업이 무거워질수록 다른 것들을 계층화하세요.

"메인 세션에 계속 타이핑하라"는 본능은 죽기 어렵습니다. 무시하세요. Subagent를 생성하세요.
