---
title: 'Claude Code Skill 작성법: 필요할 때만 Claude가 불러오는 절차를 패키징하는 방법 (2026)'
description: 'Claude Code 스킬 작성 완전 가이드 — SKILL.md 구조, 로딩을 제어하는 트리거 description, 점진적 공개(progressive disclosure), 그리고 스킬이 CLAUDE.md나 서브에이전트보다 나은 경우. 실전 예제와 피해야 할 실수까지.'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'Markdown', 'YAML']
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
tags: ['claude-code', 'skills', 'agent-sdk', 'ai-coding-agents', 'llm-frameworks', 'developer-tools', 'prompt-engineering']
aliases:
- /posts/claude-code-skill-authoring/
faq:
  - q: "스킬은 어디에 두며, SKILL.md에 최소한 필요한 것은 무엇인가요?"
    a: "스킬은 SKILL.md 파일을 담은 디렉터리로, .claude/skills/<name>/ (프로젝트 범위) 또는 ~/.claude/skills/<name>/ (사용자 범위) 아래에 위치합니다. 최소 구성은 name과 description을 담은 YAML 프런트매터, 그리고 그 뒤에 본문으로 들어가는 지시문입니다. 디렉터리에는 스킬이 가리키는 보조 파일 — 참조 문서, 스크립트, 템플릿 — 도 함께 둘 수 있지만, 이 두 프런트매터 필드를 갖춘 SKILL.md가 더 이상 줄일 수 없는 핵심입니다."
  - q: "스킬과 단순히 CLAUDE.md에 지시문을 넣는 것의 차이는 무엇인가요?"
    a: "CLAUDE.md는 모든 상호작용마다 빠짐없이 로딩됩니다 — 항상 켜져 있는 프로젝트 전역 규칙용입니다. 반면 스킬은 그 description이 현재 작업과 맞을 때만 로딩됩니다. CLAUDE.md는 『항상 탭을 사용한다』, 『main에 직접 커밋하지 않는다』 같은 규칙에 쓰세요. 스킬은 『릴리스를 자르는 방법』이나 『불안정한(flaky) 테스트를 디버깅하는 방법』처럼 상황에 따른 절차 — 모든 프롬프트를 비대하게 만들고 싶지 않고, 실제로 그 작업을 할 때만 존재하길 바라는 지식 — 에 쓰세요. 스킬은 기본 컨텍스트를 가볍게 유지해 줍니다."
  - q: "description 필드는 스킬이 언제 로딩될지를 어떻게 제어하나요?"
    a: "description은 곧 트리거 신호입니다. Claude는 스킬 description들을 읽어 현재 작업에 어떤 스킬이 관련 있는지 판단한 뒤, 그 스킬의 전체 본문을 컨텍스트로 불러옵니다. 따라서 description은 스킬이 무엇인지가 아니라 언제 써야 하는지를 구체적인 단서로 묘사해야 합니다 — 『릴리스를 자르거나, 버전을 게시하거나, 빌드에 태그를 달 때 사용』처럼요. 모호한 description(『릴리스 헬퍼』)은 스킬이 존재하긴 해도 정작 필요한 순간에 발동하지 않게 만듭니다."
  - q: "점진적 공개(progressive disclosure)란 무엇이며 스킬에 왜 중요한가요?"
    a: "점진적 공개란 스킬이 먼저 가벼운 SKILL.md를 로딩하고, 더 무거운 보조 파일(상세 참조 문서, 큰 템플릿, 스크립트)은 작업이 실제로 필요로 할 때만 끌어오는 방식을 말합니다. SKILL.md는 짧게 유지하고 깊은 세부 내용은 references/big-spec.md를 가리키게 합니다. 이렇게 하면 컨텍스트가 보호됩니다 — 라우팅을 위한 트리거와 개요는 로딩 비용이 싸고, 비싼 세부 내용은 스킬이 진짜로 동작에 들어간 뒤에야 대화에 진입합니다."
  - q: "스킬에 스크립트도 포함할 수 있나요, 아니면 지시문만 담나요?"
    a: "둘 다 가능합니다. 스킬 디렉터리는 SKILL.md와 함께 스크립트(파이썬 헬퍼, 셸 스크립트), 템플릿, 참조 문서를 묶을 수 있습니다. 본문은 Claude에게 번들된 스크립트를 실행하거나 번들된 참조 문서를 읽으라고 지시할 수 있습니다. 바로 이 점이 스킬을 단순한 프롬프트 이상으로 만들어 줍니다 — 지시문, 참조 자료, 실행 가능한 헬퍼가 모두 하나의 디렉터리에서 함께 버전 관리되는, 패키징된 역량인 것이죠."
  - q: "스킬 대신 서브에이전트를 작성해야 하는 경우는 언제인가요?"
    a: "현재 대화 안에서 실행되는 절차를 가르쳐야 할 때는 스킬을 작성하세요. 작업에 자체 컨텍스트 윈도우가 필요할 때 — 무거운 탐색, 병렬 리서치, 또는 그러지 않으면 부모 컨텍스트를 비대하게 만들 독립적 리뷰 — 는 서브에이전트를 작성하세요. 둘은 조합됩니다: 서브에이전트가 격리된 채 실행되면서 당신의 방법론을 따르기 위해 스킬을 로딩할 수 있습니다. 확장 결정 프레임워크의 경험칙은 이렇습니다 — 스킬은 행동을 바꾸고, 서브에이전트는 컨텍스트를 보호하며, MCP 서버는 역량을 추가한다."
---

## 들어가며

[Subagent vs MCP vs Skill](/kr/resources/llm-frameworks/claude-code-subagent-vs-mcp-server-skill-agent-2026/)에서 우리는 세 축 지도를 그렸습니다: 스킬은 **지식** 축을, 서브에이전트는 **컨텍스트** 축을, MCP 서버는 **역량** 축을 움직입니다. 이후 우리는 서브에이전트 축에 대한 심층 가이드를 발행했습니다 — [커스텀 에이전트 작성](/kr/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/)과 [오케스트레이션 실패 양상](/kr/resources/llm-frameworks/multi-agent-pipeline-postmortem-5-failures-2026/)입니다. 이 가이드는 그 삼부작을 완성합니다: **스킬** 자체를 어떻게 작성하는가.

스킬은 셋 중 가장 저평가된 존재입니다. 겉보기에 사소해 보이기 때문이죠 — "그냥 마크다운 파일 한 개잖아." 하지만 잘 작성된 스킬은 *필요할 때 그곳에 있어 주는* 지식과, 모든 프롬프트가 지금 아무에게도 필요 없는 규칙 4,000 토큰을 끌고 다니는 비대한 `CLAUDE.md` 사이의 차이를 만듭니다. 이 글에서는 SKILL.md 구조, 모든 것을 결정하는 트리거 description, 가볍게 유지하기 위한 점진적 공개, 두 가지 실전 예제, 그리고 스킬이 결코 발동하지 않게 만드는 실수들을 다룹니다.

## 스킬이란 실제로 무엇인가

스킬은 단순한 파일이 아니라 **디렉터리**입니다:

```
.claude/skills/cut-release/
  SKILL.md            # frontmatter + instructions
  references/
    versioning.md     # heavy detail, loaded on demand
  scripts/
    bump-version.sh    # an executable the skill can run
```

`SKILL.md`가 진입점입니다. 그 프런트매터는 스킬의 정체성과 — 결정적으로 — *언제 로딩되어야 하는지*를 선언합니다. 본문에는 절차가 담깁니다. 보조 파일(참조 문서, 템플릿, 스크립트)은 옆에 두고 필요할 때만 끌어옵니다. 스킬은 `.claude/skills/`(프로젝트, 팀과 공유) 또는 `~/.claude/skills/`(사용자, 당신 머신의 모든 프로젝트)에 위치합니다.

## 스킬 vs CLAUDE.md: 로딩의 문제

이것이 사람들이 헷갈려 하는 결정입니다. 둘 다 지시문을 담지만, 차이는 *언제 로딩되는가*입니다.

- **CLAUDE.md**는 **모든** 상호작용마다 로딩됩니다. 항상 켜져 있는 프로젝트 전역 불변 규칙용입니다: "탭을 쓴다", "main에 force-push하지 않는다", "우리 API 베이스는 X다".
- **스킬**은 **그 description이 현재 작업과 맞을 때만** 로딩됩니다. 상황에 따른 절차용입니다: "릴리스를 자르는 방법", "새 서비스를 온보딩하는 방법", "우리의 장애 대응 런북".

판별 기준: *이 지시문이 무엇에 관한 것이든 무작위 프롬프트에 적용되는가?* 그렇다면 → CLAUDE.md. 특정 종류의 작업 중에만 의미가 있다면 → 스킬. 상황에 따른 플레이북을 CLAUDE.md에 욱여넣는 것이 컨텍스트 비대화의 1순위 실수입니다. 모든 프롬프트가 필요도 없는 지식의 비용을 치르게 되니까요.

## 프런트매터: name과 description

```markdown
---
name: cut-release
description: Use when cutting a release, publishing a new version, tagging a build, or preparing release notes. Walks through version bump, changelog, tag, and publish steps.
---

You are helping cut a release. Follow these steps in order...
```

### `name`

케밥 케이스, 서술적으로. 이것이 스킬의 정체성입니다.

### `description` — 모든 것을 결정하는 트리거 신호

Claude는 라우팅을 위해 스킬 description들을 읽습니다: 그것들을 훑어보고, 어떤 스킬이 현재 작업에 맞는지 판단한 뒤, 그 스킬의 본문을 로딩합니다. 따라서 description은 라벨이 아니라 **언제 발동할지에 대한 조건**입니다. 구체적인 트리거로 꽉 채우세요:

> ❌ `description: Release helper.`
> ✅ `description: Use when cutting a release, publishing a version, tagging a build, or writing release notes. Covers version bump, changelog generation, git tag, and publish.`

첫 번째는 절대 발동하지 않습니다 — 실제 작업에서 "release helper"에 매칭되는 것이 아무것도 없으니까요. 두 번째는 사용자가 "2.4.0 배포하자"라고 말하는 순간 발동합니다. 스킬이 존재하는데도 결코 활성화되지 않는다면, 범인은 — 매번 — description입니다.

## 본문 작성하기: 에세이가 아니라 절차

본문은 스킬이 로딩된 뒤 Claude가 따르는 지시문입니다. 세 가지 규칙:

1. **에세이가 아니라 절차로.** 모델이 순서대로 실행하는 번호 매긴 단계가 맥락을 늘어놓은 문단보다 낫습니다. "1. package.json의 버전을 올린다. 2. 마지막 태그 이후 커밋들로부터 체인지로그를 재생성한다. 3. ..."
2. **전제조건과 함정을 인라인으로 명시하라.** "태그를 달기 전에 main에서 CI가 통과(green) 상태인지 확인하라" — 사람이라면 당연히 점검할 그런 것 말입니다.
3. **무거운 세부 내용은 인라인하지 말고 가리켜라.** 버전 정책이 800단어라면 `references/versioning.md`에 넣고 "버전 올리기 규칙은 references/versioning.md를 읽어라"라고 쓰세요. 그게 다음에 다룰 점진적 공개입니다.

## 점진적 공개: SKILL.md를 가볍게 유지하라

스킬 작성의 핵심 한 수입니다. SKILL.md는 **작아야** 합니다 — 트리거 + 개요 + 포인터. 무거운 자료는 작업이 거기에 다다랐을 때만 로딩되는 보조 파일에 둡니다.

왜 중요한가: description과 개요는 라우팅을 위해 훑어지므로 비용이 싸야 합니다. 상세한 2,000단어짜리 명세는 스킬이 실제로 동작에 들어가고 작업이 그 깊이를 필요로 할 때만 컨텍스트에 들어가야 합니다. 모든 것을 인라인하는 스킬은 그 목적을 무너뜨립니다 — 발동 방식만 달라졌을 뿐, CLAUDE.md식 비대화로 되돌아간 셈이죠.

```markdown
## Steps
1. Bump version (see references/versioning.md for the semver rules)
2. Run scripts/changelog.sh to generate the draft
3. ...
```

Claude는 매번 로딩할 때가 아니라, 실제로 규칙이 필요할 때만 `references/versioning.md`를 읽습니다.

## 실전 예제: 릴리스 체크리스트 스킬

```markdown
---
name: cut-release
description: Use when cutting a release, publishing a version, or tagging a build. Covers version bump, changelog, tag, publish, and the green-CI precondition.
---

You are cutting a release. Do NOT skip the precondition check.

PRECONDITION: confirm CI is green on main. If not, stop and report.

Steps:
1. Determine the new version (semver; see references/versioning.md).
2. Bump it in package.json and any version constants.
3. Generate the changelog from commits since the last tag.
4. Open a release PR; wait for review.
5. After merge: tag, push the tag, publish.

Report which step you stopped at if anything blocks.
```

전제조건과 "어디서 멈췄는지 보고하라"는 줄이 이 스킬을 프로덕션 등급으로 만들어 주는 요소입니다 — 단순한 단계들이 아니라, 신중한 사람이 적용하는 가드레일이죠.

## 실전 예제: 도메인 플레이북 스킬

```markdown
---
name: debug-flaky-test
description: Use when a test passes sometimes and fails other times, or when investigating CI flakiness, intermittent failures, or race conditions in the suite.
---

You are diagnosing a flaky test. Flakiness is almost always one of:
shared state, timing/async, test-order dependence, or external resources.

1. Reproduce: run the test 20x in isolation and 20x with the full suite.
   Different results = test-order or shared-state dependence.
2. Check for unawaited async, real timers, and fixed sleeps.
3. Check for shared mutable state between tests.
4. Only after locating the cause, propose the fix. Do not "add a retry."
```

여기 박힌 도메인 지식(네 가지 흔한 원인)에 주목하세요 — 그것은 제도화된 전문성이며, 누구나 시니어 엔지니어의 머릿속 점검표를 발동시킬 수 있도록 패키징된 것입니다.

## 흔한 작성 실수

- **모호한 description.** 스킬이 존재하지만 결코 발동하지 않습니다. 구체적인 트리거 문구를 — 사용자가 그것을 필요로 할 때 실제로 타이핑하는 단어들을 — 넣으세요.
- **모든 것을 CLAUDE.md에.** 상황에 따른 절차가 모든 프롬프트를 비대하게 만듭니다. 스킬로 옮기세요.
- **무거운 세부 내용 인라인.** 2,000단어짜리 SKILL.md. 점진적 공개를 쓰세요 — `references/`를 가리키세요.
- **절차 대신 에세이.** 에세이처럼 읽히는 스킬. 단계에 번호를 매기세요.
- **가드레일 부재.** 전제조건도 정지 조건도 없는 단계들. 신중한 사람이라면 할 점검을 추가하세요.

## 핵심 원리

스킬은 **적시(just-in-time) 전문성**입니다. CLAUDE.md는 항상 참인 것이고, 스킬은 *당신이 바로 이 특정한 일을 할 때* 참인 것입니다. 기예는 description(그래서 적절한 순간에 발동하도록)과 점진적 공개(그래서 필요해질 때까지 비용이 싸게 유지되도록)에 있습니다. 이 둘을 제대로 갖추면, 당신 팀의 절차는 아무도 열어 보지 않는 위키 안에서 살기를 멈춥니다 — 작업이 부를 때 정확히 그 순간에 완전히 로딩된 채로 나타나고, 그 외에는 방해되지 않게 비켜나 있습니다.

## 프로덕션급 Claude Code 세팅하기

스킬은 안정적이고 공유되는 환경에서 가장 빛납니다:

1. **팀 공유, CI 호출형 워크플로를 위한 신뢰할 수 있는 호스트.** 스킬은 버전 관리되며 CI에서도 실행됩니다. **{{< aff "htstack" "footer-cta" "HTStack" >}}** — 홍콩 VPS, 저지연 중국 본토 접속, 안정적인 BGP. dibi8.com을 호스팅하는 바로 그 IDC입니다. 월 $5-12.

2. **병렬 실행을 위한 클라우드 여유 공간.** **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — 60일간 $200 무료 크레딧, 14개 이상의 리전.

3. **스킬 번들.** 훌륭한 스킬을 쓰는 가장 빠른 길은 훌륭한 스킬을 읽어 보는 것입니다. 우리는 실전에서 검증된 다섯 개의 스킬을 Gumroad에 $19 번들로 묶었습니다 — 화면 모서리의 떠 있는 CTA를 참고하세요 — description, 점진적 공개 구조, 번들 스크립트가 이미 제대로 갖춰진 형태로요.

## 함께 읽으면 좋은 글

- [Subagent vs MCP vs Skill](/kr/resources/llm-frameworks/claude-code-subagent-vs-mcp-server-skill-agent-2026/) — 이 글이 완성하는 세 축 프레임워크.
- [커스텀 에이전트 작성](/kr/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/) — 이 가이드의 서브에이전트 축 자매편.
- [AI Agent Skills 2026 개발자 가이드](/kr/resources/llm-frameworks/ai-agent-skills-2026-developer-guide/) — 더 넓은 스킬 생태계.
- [서브에이전트 패턴](/kr/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) — 스킬이 위임된 워커들과 어떻게 조합되는가.

## 결론

스킬은 가장 저렴하고 가장 저평가된 확장 지점입니다 — 마크다운 파일 하나가 든 디렉터리로, 상황에 따른 전문성을 적시 컨텍스트로 바꿔 줍니다. 이 기예 전체는 결국 두 가지로 환원됩니다: 적절한 순간에 발동하도록 실제 트리거 문구로 꽉 채운 **description**, 그리고 작업이 그 깊이를 필요로 할 때까지 가볍게 유지되도록 하는 **점진적 공개**. 이 둘을 잘 쓰면, 당신은 팀 전체가 — 그리고 모든 CI 실행이 — 관련된 바로 그 순간에 공짜로 얻는 절차를 패키징한 것입니다. 그것으로 삼부작이 완성됩니다: 지식엔 스킬, 컨텍스트엔 서브에이전트, 역량엔 MCP 서버.
