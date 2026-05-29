---
title: 'Claude Code 커스텀 에이전트 작성 가이드: 팀 표준을 강제하는 재사용 가능한 서브에이전트 만들기 (2026)'
description: 'Claude Code 커스텀 서브에이전트를 작성하는 완벽 가이드 — frontmatter 필드, 시스템 프롬프트 설계, 도구 화이트리스트, 그리고 바로 투입 가능한 두 가지 예제(마이그레이션 리뷰어, 보안 게이트)와 피해야 할 실수까지.'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'CLI', 'Markdown', 'YAML']
application_domain: LLM Frameworks
source_version: ''
licensing_model: Commercial (Anthropic)
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
tags: ['claude-code', 'subagents', 'custom-agents', 'agent-sdk', 'ai-coding-agents', 'llm-frameworks', 'developer-tools']
aliases:
- /posts/claude-code-custom-agent-authoring/
faq:
  - q: "커스텀 에이전트 정의 파일은 어디에 두며, 어떤 형식인가요?"
    a: "커스텀 에이전트는 YAML frontmatter가 붙은 Markdown 파일로, 프로젝트의 .claude/agents/ 디렉터리(또는 모든 프로젝트에서 쓰고 싶다면 ~/.claude/agents/)에 저장합니다. 파일명에서 .md 확장자를 뗀 것이 에이전트의 정체성은 아닙니다 — frontmatter의 name 필드가 정체성입니다. frontmatter는 name, description, 선택적 tools 화이트리스트, 선택적 model을 선언하며, 닫는 --- 아래의 모든 내용이 에이전트의 시스템 프롬프트입니다."
  - q: "description 필드와 시스템 프롬프트 본문은 어떻게 다른가요?"
    a: "description은 라우팅 신호입니다. 부모 에이전트가 이 서브에이전트에게 위임할지 결정할 때 읽는 것이 바로 이것이므로, 단순히 무엇인지가 아니라 『언제』 이 에이전트를 써야 하는지를 말해야 합니다. 시스템 프롬프트 본문은 에이전트가 호출된 뒤 그 아래에서 실행하는 지시 집합입니다 — 역할, 방법, 출력 계약이죠. 훌륭한 description에 모호한 본문이면 올바른 시점에 호출되지만 평범한 일을 하고, 훌륭한 본문에 모호한 description이면 뛰어난 일을 하지만 결코 트리거되지 않습니다."
  - q: "커스텀 에이전트에 모든 도구를 열어줘야 하나요, 아니면 제한해야 하나요?"
    a: "제한하세요. tools 필드를 생략하면 상속된 전체 도구 집합이 부여되는데, 편리하지만 결코 쓰거나 실행해서는 안 되는 에이전트에는 위험합니다 — Write와 Bash 권한을 가진 code-reviewer는 자기 제안을 『친절하게』 직접 적용해버려, 독립적 리뷰의 의미를 무너뜨립니다. 최소한만 선언하세요: 리뷰어는 Read, Grep, Glob을 받고, 마이그레이션 감사기는 거기에 읽기 전용 데이터베이스 쿼리 도구(있다면)를 더합니다. 최소 권한이 에이전트의 행동을 예측 가능하게 만듭니다."
  - q: "실제 프로젝트를 오염시키지 않고 커스텀 에이전트를 테스트하려면 어떻게 하나요?"
    a: "이미 문제가 있는 예제(인덱스가 빠진 마이그레이션, 논리적 허점이 있는 인증 변경)를 담은 일회용 브랜치나 git worktree를 만들고 그것을 대상으로 에이전트를 호출하세요. 두 가지를 확인하는 겁니다: 자연스러운 요청에 의해 트리거되는가(description 품질), 그리고 심어둔 문제를 잡아내는가(시스템 프롬프트 품질). frontmatter와 본문은 따로 반복 개선하세요 — 실패하는 이유가 서로 다릅니다."
  - q: "커스텀 에이전트가 다른 서브에이전트를 호출하거나 자기 서브에이전트를 만들 수 있나요?"
    a: "아니요. 서브에이전트는 한 단계 깊이까지만 가능합니다 — 서브에이전트는 더 깊은 서브에이전트를 만들 수 없습니다. 이는 폭주하는 팬아웃을 막기 위한 의도적 가드레일입니다. 다단계 오케스트레이션이 필요하면 부모(최상위) 에이전트가 조율합니다: 에이전트 A를 호출하고, 결과를 읽고, 그다음 에이전트 B를 호출하죠. 커스텀 에이전트는 구조화된 보고서를 반환하는 단일 목적 작업자로 설계하고, 최상위 오케스트레이터가 순서를 정하게 하세요."
  - q: "커스텀 에이전트는 CI와 헤드리스 실행에서도 동작하나요, 아니면 대화형에서만 동작하나요?"
    a: "둘 다에서 동작합니다. 동일한 .claude/agents/ 정의가 Claude Code를 비대화형으로 실행할 때(CI에서 쓰는 -p / print 모드)도 인식됩니다. 저장소에 버전 관리되는 파일이므로 모든 동료와 모든 CI 작업이 완전히 동일한 에이전트 정의를 봅니다 — 리뷰 체크리스트를 아무도 열어보지 않는 위키 페이지가 아니라 에이전트로 코드화하는 것의 핵심이 바로 이것입니다."
---

## 들어가며

[Claude Code 서브에이전트 패턴](/kr/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) 글에서 우리는 컨텍스트 창을 현명하게 쓰는 다섯 가지 워크플로를 다뤘습니다 — 그중 다섯 번째인 **커스텀 에이전트를 활용한 파이프라인 오케스트레이션**이 팀에서 가장 많이 묻는 주제입니다. "리뷰 체크리스트를 서브에이전트로 코드화하라"는 말은 멋지게 들리지만, 막상 비어 있는 `.claude/agents/migration-reviewer.md`와 깜빡이는 커서를 마주하면 막막해집니다.

이 가이드가 바로 그 빠진 설명서입니다. 커스텀 에이전트 정의의 해부 구조, 각 frontmatter 필드가 실제로 무엇을 제어하는지, 장황한 잡담 대신 구조화된 보고서를 만들어내는 시스템 프롬프트를 어떻게 작성하는지, 도구 화이트리스트가 보기보다 왜 더 중요한지, 그리고 오늘 바로 복사해 쓸 수 있는 완전하고 투입 가능한 두 가지 예제를 차례로 살펴봅니다. 그다음 실수들 — 여기서의 실패 모드는 미묘하고, 처음으로 뻔한 문제를 놓치는 순간 그 에이전트에 대한 신뢰가 무너지기 때문입니다.

서브에이전트에 위임해본 적이 없다면 [패턴 글](/kr/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/)을 먼저 읽으세요. 이미 읽었고 자신만의 것을 출시할 준비가 됐다면, 이것이 여러분의 실전 플레이북입니다.

## 커스텀 에이전트의 해부 구조

커스텀 에이전트는 YAML frontmatter가 붙은 단일 Markdown 파일입니다. 두 위치 중 하나에 둡니다:

- `.claude/agents/<name>.md` — 프로젝트 범위, 버전 관리, 팀 전체와 공유
- `~/.claude/agents/<name>.md` — 사용자 범위, 내 머신의 모든 프로젝트에서 사용 가능

구조는 무척 단순합니다:

```markdown
---
name: migration-reviewer
description: Reviews database migrations for safety. Use when a PR touches db/migrate/, schema files, or any SQL DDL.
tools: Read, Grep, Glob
model: sonnet
---

You are a database migration reviewer. Your job is to catch unsafe
migrations before they reach production...
```

닫는 `---` 위쪽은 전부 설정이고, 아래쪽은 전부 **시스템 프롬프트** — 서브에이전트가 실행되는 페르소나이자 지시 집합입니다. 이것이 계약의 전부입니다. 빌드 단계도, 등록도, 플러그인 매니페스트도 없습니다. 파일을 넣고 `/agents`를 실행해 Claude Code가 인식했는지 확인하면 바로 호출할 수 있습니다.

## Frontmatter 필드

네 개의 필드가 모든 일을 합니다. 그중 셋은 선택이지만, 진지하게 에이전트를 만들 때 기본값이 원하는 값인 경우는 드뭅니다.

### `name` (필수)

에이전트의 정체성 — 부모가 `subagent_type`으로 전달하는 문자열입니다. kebab-case로 짧고 서술적으로 유지하세요: `agent2`가 아니라 `security-auditor`처럼요. 파일명은 표면적인 것이고, `name` 필드가 정식 기준입니다.

### `description` (필수 — 그리고 사람들이 가장 과소평가하는 것)

이것이 **라우팅 신호**입니다. 부모 에이전트가 위임할지 결정할 때 읽는 것은 시스템 프롬프트가 아니라 description입니다. 그래서 description은 구체적인 트리거 조건으로 *언제* 이 에이전트를 찾아야 하는지를 담아야 합니다:

> ❌ `description: A code reviewer.`
> ✅ `description: Reviews code changes for correctness and security. Use proactively after writing a non-trivial diff, before committing, especially for auth, payments, or concurrency-sensitive code.`

"proactively"(능동적으로)라는 단어가 하중을 떠받칩니다 — 명시적 요청 없이도 부모가 알아서 호출하도록 부추기죠. 에이전트가 도무지 트리거되지 않는 것 같다면, 거의 항상 description이 원인입니다.

### `tools` (선택 — 그래도 선언하세요)

쉼표로 구분한 화이트리스트입니다. 생략하면 에이전트는 부모가 가진 모든 도구를 상속합니다. 왜 그것이 대개 잘못된지는 한 섹션을 통째로 할애해 다룹니다.

### `model` (선택)

등급을 고정하세요: 저렴한 기계적 처리에는 `haiku`, 균형 잡힌 리뷰 작업에는 `sonnet`, 깊은 추론에는 `opus`. 고빈도 린터 스타일 에이전트를 `haiku`로 돌리면 비용을 잡을 수 있고, 놓치면 대가가 큰 보안 감사기는 `opus`를 받을 만합니다.

## 시스템 프롬프트 작성하기

본문은 대부분의 에이전트가 성패가 갈리는 곳입니다. 세 가지 규칙이 신뢰할 만한 작업자를 만들어냅니다:

**1. 첫 문장에서 역할과 경계를 밝히세요.** "You are a migration reviewer. You do not write code or apply fixes — you report findings." 에이전트에게 *하지 말아야 할* 것을 알려주는 일은 일 자체를 알려주는 것만큼 중요합니다.

**2. 출력 계약을 명시하세요.** 모호한 프롬프트는 산문을 낳습니다. 여러분이 원하는 건 구조죠. 못 박아 두세요:

```markdown
Report your findings as a list. For each issue:
- SEVERITY: blocker | warning | nit
- LOCATION: file:line
- PROBLEM: one sentence
- FIX: the concrete change
End with a one-line VERDICT: SAFE TO MERGE or NEEDS CHANGES.
```

**3. 느낌이 아니라 체크리스트를 주세요.** "안전성을 리뷰하라"는 소망일 뿐입니다. 검사할 항목을 하나하나 열거하세요 — 에이전트는 여러분의 목록을 결정론적으로 끝까지 훑을 것이며, 그것이 바로 이걸 코드화하는 모든 가치입니다.

## 도구 화이트리스트: 에이전트에 최소 권한 적용하기

여기 함정이 있습니다. `tools`를 비워두면 여러분의 "리뷰어"가 `Write`, `Edit`, `Bash`를 상속받습니다. 문제를 처음 발견하는 순간 그것을 "친절하게" 고쳐버릴 수 있습니다 — 작업 트리를 변경하고, 명령을 실행하고, 이 리뷰를 요청할 가치를 만들어준 그 독립성을 파괴하면서요.

해법은 최소 권한입니다. 도구를 직무에 맞추세요:

| 에이전트 유형 | 도구 |
| --- | --- |
| 리뷰어 / 감사기 | `Read, Grep, Glob` |
| 조사원 / 탐색기 | `Read, Grep, Glob, WebSearch, WebFetch` |
| 테스트 러너 | `Read, Grep, Glob, Bash` |
| 수정기 (드물게, 의도적으로) | `Read, Edit, Bash` |

읽기 전용 리뷰어는 글자 그대로 *제멋대로 굴 수 없습니다*. 그 예측 가능성이야말로, 그것이 건드린 모든 것을 다시 검사하지 않고도 보고서를 믿을 수 있게 해주는 이유입니다. (나중에 [MCP 서버](/kr/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/)를 통해 외부 시스템을 연결하더라도 같은 규율이 적용됩니다 — 에이전트가 정말로 필요로 하는 MCP 도구만 부여하세요.)

## 실전 예제: 마이그레이션 리뷰어

```markdown
---
name: migration-reviewer
description: Reviews database migrations for production safety. Use proactively when a change touches db/migrate/, schema.rb, or any SQL DDL file.
tools: Read, Grep, Glob
model: sonnet
---

You are a database migration reviewer. You do NOT edit files or run
migrations — you read the proposed migration and report risks.

Check every migration against this list:
1. Adding a column with a NOT NULL constraint and no default on a large table (locks).
2. Adding an index without CONCURRENTLY (blocks writes).
3. Renaming or dropping a column still referenced by application code.
4. A data backfill running inside the same transaction as the schema change.
5. Missing a corresponding rollback / down path.

Report findings as:
- SEVERITY: blocker | warning | nit
- LOCATION: file:line
- PROBLEM / FIX
End with VERDICT: SAFE TO MERGE or NEEDS CHANGES.
```

부모 에이전트에서 자연스러운 요청으로 호출하세요 — "이 브랜치의 마이그레이션을 리뷰해줘" — description이 `db/migrate/`를 지목하고 있으므로 부모가 알아서 그쪽으로 라우팅합니다.

## 실전 예제: 보안 게이트

```markdown
---
name: security-gate
description: Threat-models diffs that touch authentication, authorization, secrets, or user input. Use proactively before merging any auth or payments change.
tools: Read, Grep, Glob
model: opus
---

You are a security reviewer with a threat-modeling mindset. Assume the
input is hostile. You report only — you never modify code.

For the diff, check:
- Authn/authz: can this path be reached without the expected check?
- Injection: is user input concatenated into SQL, shell, or HTML?
- Secrets: any key, token, or password added to code or logs?
- IDOR: are object references scoped to the authenticated user?

For each finding give an EXPLOIT SKETCH (how an attacker triggers it),
then the FIX. Default to flagging when uncertain — false positives are
cheap, a missed auth hole is not.
```

`opus` 등급과 "불확실할 때 기본적으로 표시하라"는 지시에 주목하세요 — 보안 게이트는 편집증 쪽으로 튜닝하는 겁니다.

## 에이전트 테스트와 반복 개선

속여보지도 않은 에이전트를 출시하지 마세요. [git worktree](/kr/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/)나 일회용 브랜치를 띄우고 그 안에 *심어둔* 문제 — `CONCURRENTLY`가 빠진 마이그레이션, 소유권 검사가 빠진 엔드포인트 — 를 넣은 뒤 에이전트를 호출하세요.

서로 독립적인 두 가지를 테스트하는 겁니다:

- **자연스러운 요청에 트리거됐나요?** 안 됐으면 `description`을 고치세요.
- **심어둔 버그를 잡았나요?** 안 잡았으면 시스템 프롬프트의 체크리스트를 고치세요.

이 둘은 실패 원인이 다르므로 따로 반복 개선하세요. 흔한 의외의 상황: 명시적으로 이름을 부르면 완벽하게 동작하는데 스스로는 결코 발동하지 않는 경우 — 그건 언제나 description 문제이지 본문 문제가 아닙니다.

## 흔한 작성 실수

- **모호한 description.** 아무도 트리거하지 않는 좋은 일을 합니다. 구체적인 파일 경로와 "proactively"라는 단어를 넣으세요.
- **도구 화이트리스트 없음.** 리뷰어가 리뷰해야 할 코드를 고쳐버립니다. `Read, Grep, Glob`을 선언하세요.
- **산문 출력, 계약 없음.** 분류된 목록 대신 의견 세 문단을 받게 됩니다. 정확한 보고서 형식을 지정하세요.
- **하나의 거대 에이전트.** "다 하는" 단일 에이전트는 단계만 늘어난 부모일 뿐입니다. 관심사별로 쪼개세요 — 그것이 바로 [전문가 위임 패턴](/kr/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/)이 여러분을 위해 작동하는 방식입니다.
- **만들고 방치.** 에이전트는 코드입니다. 관리되지 않는 체크리스트는 기술 스택이 변하면서 썩습니다. 분기마다 한 번씩 검토하세요.

## 근본 원칙

커스텀 에이전트는 **실행 가능한 조직 지식**입니다. 한때 아무도 열어보지 않는 위키 페이지에, 혹은 늘 그 버그를 잡아내던 그 한 명의 시니어 엔지니어 머릿속에 들어 있던 리뷰 표준 — 여러분은 그것을 한 번 코드화하고, 버전 관리에 넣고, 그러면 모든 동료와 모든 CI 실행이 완전히 동일하고 지치지 않는 리뷰어를 얻습니다. 이 에이전트는 마감이 임박했다고 서둘러 3, 5, 7단계를 건너뛰지 않습니다. 원초적 지능이 아니라 그 일관성이야말로 진짜 승리입니다.

## 프로덕션 수준의 Claude Code 구성하기

커스텀 에이전트 파이프라인을 대규모로 돌리려면 안정적인 인프라가 필요합니다:

1. **장시간 세션과 CI 세션을 위한 믿을 만한 호스트.** 커스텀 에이전트는 모든 PR을 지키는 CI에서 가장 빛납니다. 작업을 떨어뜨리지 않는 머신이 필요합니다. **{{< aff "htstack" "footer-cta" "HTStack" >}}** — 중국 본토에서 저지연으로 접속되고 BGP 라우팅이 안정적인 홍콩 VPS입니다. dibi8.com을 호스팅하는 바로 그 IDC라서, 우리 자신의 에이전트 파이프라인도 그 위에서 돌립니다. 가성비 등급은 월 $5-12입니다.

2. **병렬 게이트를 위한 클라우드 여유.** 오케스트레이터가 migration-reviewer + security-gate + perf-checker로 한꺼번에 팬아웃할 때는 여분의 CPU가 필요합니다. **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — 14개 이상 리전에 걸쳐 60일간 $200 무료 크레딧, 앱 옆에 CI 러너를 두기에 좋습니다.

3. **스킬 번들.** 가장 가파른 구간은 무너지지 않는 에이전트 정의를 쓰는 일입니다. 우리는 실전 검증된 다섯 가지 스킬을 Gumroad에서 $19 번들로 묶었습니다 — 모서리의 떠 있는 CTA를 보세요 — 오케스트레이터 프롬프트와 바로 출시 가능한 에이전트 정의 셋이 더 들어 있습니다.

## 관련 읽을거리

- [Claude Code 서브에이전트 패턴](/kr/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) — 다섯 가지 워크플로; 이 가이드는 그중 5번 패턴을 깊이 파고듭니다.
- [Superpowers 프레임워크](/kr/resources/llm-frameworks/superpowers/) — 배울 점이 많은 엄선된 스킬/에이전트 라이브러리.
- [MCP 서버 2026 랭킹](/kr/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/) — 에이전트 능력을 기본 제공 도구 너머로 확장하기.
- [AI 코딩 에이전트 지형도](/kr/resources/llm-frameworks/ai-coding-agent-landscape-2026-skills-mcp-opensource/) — 더 큰 생태계 속에서 커스텀 에이전트의 위치.

## 결론

커스텀 에이전트는 팀의 모범 사례를 아무도 읽지 않는 문서에서, 모든 변경에 대해 실행되는 검사로 바꿉니다. 비결은 이렇습니다: 트리거되도록 날카로운 **description**, 본분에 머물도록 하는 최소 권한 **도구 화이트리스트**, 그리고 여러분이 행동에 옮길 수 있는 보고서를 만들어내도록 명시적 체크리스트와 출력 계약을 담은 **시스템 프롬프트**.

하나로 시작하세요 — 위의 마이그레이션 리뷰어가 대부분의 팀에 가장 레버리지가 높은 첫 에이전트입니다. 버그를 심고, 그것을 잡아내는지 확인한 뒤, 파일을 커밋하세요. 그 순간부터 모든 동료는 결코 지치지 않고 결코 단계를 건너뛰지 않는 리뷰어를 갖게 됩니다.
