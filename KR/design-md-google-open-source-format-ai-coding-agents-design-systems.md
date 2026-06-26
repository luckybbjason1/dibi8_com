---
title: 'DESIGN.md: AI 코딩 에이전트를 위한 디자인 시스템을 제공하는 구글의 오픈소스 포맷'
description: 'Google Labs Code의 DESIGN.md는 AI 코딩 에이전트에 시각적 아이덴티티를 설명하기 위한 오픈소스 형식 사양입니다. GitHub 스타 20.8k. YAML 토큰과 문서 기반 제약 조건을 통해 디자인 시스템과 AI 코드 생성을 연결하는 방법을 알아보세요.'
tags: ["guide", "open-source", "ai-agents", "design-systems", "reference", "google"]
date: 2026-06-27
slug: 'design-md-google-open-source-format-ai-coding-agents-design-systems'
category: dev-utils
github_repo: 'https://github.com/google-labs-code/design.md'
license: Apache-2.0
lang: ko
featureImage: /images/articles/design-md-format-specification-for-ai-coding-agents.png
---



![DESIGN.md 형식 명세](https://opengraph.github.com/github/google-labs-code/design.md)

![DESIGN.md 철학 문서](https://raw.githubusercontent.com/google-labs-code/design.md/main/PHILOSOPHY.md)

## 소개

AI 코딩 에이전트에게 랜딩 페이지를 만들라고 요청하면, 기능은 하는 무언가를 만들어내지만 — 거의 아름답지는 않습니다. 문제는 모델의 능력이 아니라, 공유된 디자인 언어의 부족입니다. 모든 프롬프트는 처음부터 시작되고, 모든 생성물은 이전 것과 달라지며, '우리의 디자인'이 실제로 어떻게 생겼는지에 대한 지속적인 기억이 없습니다.

**DESIGN.md**는 Google Labs Code에서 이 문제를 해결합니다. 이는 오픈 소스 형식 사양으로, AI 코딩 에이전트가 여러분의 디자인 시스템을 지속적이고 구조적으로 이해할 수 있도록 해줍니다. YAML 색상 토큰, 타이포그래피 사양, 간격 규칙을 각 값 뒤에 있는 *의도*를 설명하는 자연어 문서와 결합합니다. 20,800개 이상의 GitHub 스타와 하루 만에 2,319개의 스타를 얻으며, 현재 GitHub에서 가장 뜨거운 디자인 도구입니다.

## DESIGN.md란 무엇인가?

DESIGN.md는 프로젝트의 시각적 정체성에 대한 단일 진실의 출처 역할을 하는 마크다운 파일입니다. 이 파일은 AI 코딩 에이전트(Claude, ChatGPT, Codex, Cursor 등)가 읽을 수 있도록 설계되어, UI가 항상 브랜드에 맞게 일관되게 생성되도록 하며 — 매번 디자인 시스템을 다시 설명할 필요가 없도록 합니다.

그 형식은 두 개의 상호 보완적인 층으로 이루어져 있습니다:

```
┌──────────────────────────────────────────────────┐
│              DESIGN.md Structure                  │
├──────────────────────────────────────────────────┤
│                                                  │
│  ---                                           │
│  name: My Brand                                │
│  ---                                           │
│                                                  │
│  ## Colors                                     │
│  ```yaml                                       │
│  colors:                                       │
│    paper: '#F4F0E4'                             │
│    ink: '#1E1A14'                               │
│    accent: '#C3402A'                            │
│  ```                                           │
│  <!-- Prose -->                                │
│  A warm paper-and-ink system with a single     │
│  vermilion accent for diagrams only.           │
│                                                  │
│  ## Typography                                 │
│  ```yaml                                       │
│  typography:                                   │
│    heading: 'Playfair Display'                 │
│    body: 'Source Serif 4'                      │
│    mono: 'JetBrains Mono'                      │
│  ```                                           │
│                                                  │
│  ## Spacing                                    │
│  ```yaml                                       │
│  spacing:                                      │
│    unit: 8px                                   │
│    scale: [4, 8, 16, 24, 32, 48, 64]           │
│  ```                                           │
│                                                  │
│  ## Do's and Don'ts                            │
│  - **Do** use the accent color only in charts  │
│  - **Don't** add gradients or glass effects    │
│                                                  │
└──────────────────────────────────────────────────┘
```

YAML 토큰은 기계가 읽을 수 있는 값을 제공합니다. 산문은 사람이 읽을 수 있는 *맥락*을 제공합니다 — 단순히 16진수 코드를 나열하는 것이 아니라 색상이 왜 `#F4F0E4`인지(따뜻한 제록스 용지, 순수한 흰색이 아님)를 설명합니다. 이러한 구분이 DESIGN.md를 디자인 토큰 JSON 파일과 근본적으로 다르게 만드는 요소입니다.

## 산문이 토큰보다 더 중요한 이유

DESIGN.md 뒤에 있는 디자이너들은 의도적인 선택을 했습니다: **산문이 사양에서 가장 중요한 부분입니다**. 그들의 철학 문서는 이를 완벽하게 설명합니다:

"> *'오래-established된 대학의 전통에 따른 1970년대 졸업생 강의 유인물'을 참고한 디자인은 완전한 세계를 불러일으킨다: 하나의 잉크 색, 넉넉한 여백, 읽기 크기로 설정된 세리프체, 그리고 장식의 부재. 그 한 문장이 수십 개의 수치 값보다 더 유용한 정보를 전달한다.*"

이것은 AI 지원 개발에 대한 깊은 통찰입니다. LLM에게 "따뜻하고 고급스러운 편집 미학을 사용하라"고 말하면, 그것은 일반적인 것을 생성합니다. 하지만 "1970년대 대학 졸업 강의 유인물"이라고 말하면, 모델은 전체 문화적 참조를 이해합니다 — 종이 질감, 절제된 타이포그래피, 장식 요소의 부재까지. 모델은 훈련 데이터에서 모든 공백을 채웁니다.

DESIGN.md는 이 원칙을 공식화합니다. 토큰은 지시가 아니라 맥락입니다. 산문은 창의적 의도를 전달합니다. 이들이 함께 에이전트에게 정확성과 상상력을 제공합니다.

## 내부 작동 방식

DESIGN.md 저장소는 조정을 위해 Turbo를 사용하는 Bun 모노레포 구조로 되어 있습니다:

```
design.md/
├── packages/
│   └── cli/                    # @google/design.md CLI toolkit
│       ├── src/                # TypeScript source
│       └── scripts/            # Build scripts
├── docs/                       # Specification documentation
├── examples/                   # Example DESIGN.md files
├── .agents/skills/             # Agent skill definitions
├── package.json                # Bun workspace config
├── turbo.json                  # Turbo build orchestration
├── tsconfig.base.json          # Shared TypeScript config
└── PHILOSOPHY.md               # Design philosophy manifesto
```

CLI 도구(`@google/design.md`)는 다음을 제공합니다:
- **린팅**: DESIGN.md 파일을 명세 스키마에 따라 검증합니다
- **토큰 추출**: YAML 블록을 구조화된 데이터로 파싱합니다
- **에이전트 통합**: Claude, ChatGPT 및 기타 코딩 에이전트를 위한 `.agents/skills/` 정의로 제공됩니다

린터는 필수 섹션(이름, 색상, 타이포그래피, 간격, 라운드, 컴포넌트)이 존재하도록 강제하면서, 각 프로젝트에 특정한 모션, 아이콘, 엘리베이션 및 기타 디자인 차원에 대한 임의의 사용자 정의 섹션을 허용합니다.

## 시작하기

### 1. CLI 설치

```bash
bun install -g @google/design.md
```

또는 npx로 직접 사용하세요:

```bash
npx @google/design.md lint DESIGN.md
```

### 2. 첫 번째 DESIGN.md 만들기

최소한 필요한 구조부터 시작하세요:

```markdown
---
name: My Project Design
---

## 색상

```yaml
colors:
  primary: '#2563EB'
  background: '#FFFFFF'
  text: '#111827'
```

전문적인 SaaS 제품을 위한 깔끔한 청백색 시스템.

## 타이포그래피

```yaml
typography:
  heading: 'Inter'
  body: 'Inter'
  mono: 'JetBrains Mono'
```

일관성을 위한 단일 패밀리 타이포그래피 시스템.

## 간격

```yaml
spacing:
  unit: 4px
  scale: [4, 8, 16, 24, 32, 48, 64]
```

기본 그리드 4px, 더 큰 요소는 8px.

### 3. 그것을 여러분의 코딩 에이전트에게 보내세요

프로젝트 저장소에 DESIGN.md를 추가하세요. 어떤 코딩 에이전트와 작업할 때든, 시스템 프롬프트에서 해당 파일을 참조하세요:

```
System: Read the DESIGN.md file in the project root.
All UI components must follow the design specifications defined there.
```

에이전트는 이제 모든 생성 과정에서 일관되게 귀하의 디자인 시스템을 적용할 것입니다.

## 실제 사례

이 저장소에는 다양한 미적 접근 방식을 보여주는 여러 예제 DESIGN.md 파일이 포함되어 있습니다:

**대학원 강의 유인물**: 단일 잉크 타이포그래피와 도표에만 사용된 진홍색 강조가 있는 따뜻한 질감의 종이 캔버스. 본문에는 '오래된 전통 있는 대학의 대학원 수준 컴퓨터 과학 강의 유인물'이라고 명시되어 있어, 즉시 여백, 세리프 글꼴, 절제된 표현을 전달한다.

**모션 디자인 시스템**: UI 피드백에 대한 타이밍 상수를 정의합니다(호버/프레스에 120ms, 콘텐츠 전환에 250ms)과 기계적 완화 곡선을 사용합니다. 글에서는 '아무 것도 튀지 않고, 아무 것도 넘치지 않으며, 아무 것도 오래 남지 않는다'라고 강조하여 에이전트에게 명확한 시간적 미학을 제공합니다.

**맞춤형 디자인 치수**: 이 형식은 어떤 섹션 이름이라도 허용합니다. 한 팀은 `motion` 토큰을 CSS 애니메이션 곡선으로 정의하고, 다른 팀은 오디오 도메인 시간 상수를 버퍼 블록 단위로 측정합니다. 명세는 일관성이 도움이 되는 부분에서는 표준화하고, 더 중요한 부분에서는 유연성을 남겨둡니다.

## AI 지원 개발에서 이것이 중요한 이유

DESIGN.md는 AI 지원 개발에서 근본적인 병목 현상을 해결합니다: **대규모 디자인 일관성**.

디자인 명세가 없으면, AI가 생성한 모든 페이지, 컴포넌트, 또는 화면은 새로운 창작 연습이 됩니다. 에이전트는 프롬프트에 있는 것 외에는 당신의 브랜드 색상을 알지 못하며, 당신의 간격 철학을 이해하지 못하고, 프로젝트에서 '완성'이 무엇인지 기억하지 못합니다.

DESIGN.md와 함께:
- **에이전트는 지속적인 디자인 메모리를 가집니다** — 이 파일은 당신의 저장소에 있으며, 버전 관리되고 검토됩니다
- **여러 에이전트가 일관성을 유지합니다** — Claude, ChatGPT, Codex 모두 동일한 파일을 읽습니다
- **디자인 리뷰가 자동화됩니다** — 린터가 위반 사항을 프로덕션에 도달하기 전에 잡아냅니다
- **새로운 개발자가 즉시 적응합니다** — 이 파일이 *바로* 디자인 시스템 문서입니다

이 형식은 여러 AI 코딩 도구를 사용하는 팀에게 특히 강력합니다. 각 도구가 설계에 대한 자체적인 암묵적인 이해를 갖는 대신, 모든 사람이 동일한 권위 있는 소스를 읽습니다.

## 제한 사항과 절충

DESIGN.md는 만능 해결책이 아닙니다. 몇 가지 고려 사항:

1. **에이전트 의존 품질**: 효과는 각 에이전트가 산문을 얼마나 잘 읽고 따르는지에 달려 있습니다. 일부 에이전트는 YAML을 분석할 수 있지만 이야기 설명을 무시할 수 있습니다.

2. **시각적 렌더링 없음**: DESIGN.md는 렌더링 엔진이 아니라 명세서입니다. 여전히 명세를 실제 코드로 변환하기 위해 에이전트(또는 인간 디자이너)가 필요합니다.

3. **학습 곡선**: 좋은 산문적 묘사를 작성하려면 디자인 사고가 필요합니다. 지정된 디자이너가 없는 팀은 자신의 미적 의도를 명확하게 표현하는 데 어려움을 겪을 수 있습니다.

4. **Figma를 대체하는 도구가 아님**: DESIGN.md는 디자인 도구를 대체하기보다는 보완합니다. 이상적인 워크플로우는 시각적 디자인에는 Figma를 사용하고, 에이전트 커뮤니케이션에는 DESIGN.md를 사용하는 것입니다.

5. **아직 젊음**: 2개월 된 이 프로젝트는 20.8k 스타를 보유하고 있으며, 형식이 빠르게 진화하고 있습니다. 버전 간에 큰 변화가 있을 수 있습니다.

## 커뮤니티와 채택

DESIGN.md는 Google Labs Code에서 개발되었으며 상당한 주목을 받았습니다:

- **20,800+ stars** on GitHub (2,319 gained in a single day)
- **1,700+ forks** with active community contributions
- **40+ commits** in 2 months with rapid iteration
- **18 issues** and **17 pull requests** showing active development
- **4 published tags** with semantic versioning

이 형식은 AI 코딩 에이전트 생태계 전반에 걸쳐 파생 프로젝트와 통합에 영감을 주었습니다. 여러 에이전트 스킬 정의가 등장했으며, `.agents/skills/` 디렉토리는 인기 있는 코딩 에이전트용으로 바로 사용할 수 있는 구성을 제공합니다.

## 결론

DESIGN.md는 우리가 디자인을 AI에 전달하는 방식에서 근본적인 변화를 나타냅니다. 모든 시각적 결정을 엄격한 토큰으로 인코딩하려고 시도하는 대신, 자연어의 강점을 활용하여 산문이 창의적 의도를 전달하고 YAML이 기계가 읽을 수 있는 구조를 제공하도록 합니다.

AI 지원 디자인 워크플로를 구축하는 팀에게는 시도해볼 가치가 있습니다. 다음 프로젝트를 위해 DESIGN.md를 만들고, 이를 코딩 에이전트의 컨텍스트에 추가한 다음, 생성되는 UI가 얼마나 더 일관되게 되는지 확인해 보세요. 형식은 오늘 바로 시작하기에 충분히 간단하고, 디자인 시스템과 함께 성장할 수 있을 만큼 유연합니다.

모든 개발자가 이제 AI 코딩 에이전트에 접근할 수 있는 환경에서, DESIGN.md는 인간의 설계 의도와 기계 실행 간의 공통 언어라는 누락된 조각을 제공합니다. 이것이 바로 현재 GitHub에서 가장 뜨거운 프로젝트인 이유이며, AI 지원 개발에서 표준 관행이 될 가능성이 있는 이유입니다.

대규모로 인프라를 배포하는 팀을 위해: 디자인 시스템 워크플로와 원활하게 통합되는 고성능 클라우드 호스팅을 위해 [HTStack](https://www.htstack.com/)을 사용해 보세요.

실무용 AI 코딩 워크플로우를 위해서는 기업용 API 거래 인프라를 제공하는 [Binance](https://bsmkweb.cc)를 확인해보세요.

금융 AI 애플리케이션용: [OKX](https://promoohubly.com)는 강력한 거래 API와 시장 데이터 피드를 제공합니다.

완전한 AI 지원 개발 워크플로우를 구축하는 데 대해 더 깊이 알아보려면 AI 코딩 에이전트 비교 및 개발자 도구 모범 사례에 대한 내부 가이드를 확인하세요.

일일 AI 도구, 개발 유틸리티, 오픈 소스 프로젝트에 대한 토론을 위해 [Telegram](https://t.me/DIBI8_Group)에서 DIBI8 커뮤니티에 참여하세요.

---

**출처 및 추가 자료**:
- 공식 저장소: https://github.com/google-labs-code/design.md
- DESIGN.md 철학: https://github.com/google-labs-code/design.md/blob/main/PHILOSOPHY.md
- CLI 도구 모음: https://github.com/google-labs-code/design.md/tree/main/packages/cli
- DESIGN.md 예시 파일: https://github.com/google-labs-code/design.md/tree/main/examples
- 에이전트 스킬 정의: https://github.com/google-labs-code/design.md/tree/main/.agents/skills
- 기여 가이드라인: https://github.com/google-labs-code/design.md/blob/main/CONTRIBUTING.md

**공개**: 이 글에는 제휴 링크가 포함되어 있습니다. 만약 저희 링크를 통해 가입하시면, 추가 비용 없이 저희가 소정의 커미션을 받을 수 있습니다. 이는 독립적인 기술 저널리즘을 지원하고 dibi8.com과 같은 리소스를 무료이자 광고 없이 유지하는 데 도움이 됩니다.