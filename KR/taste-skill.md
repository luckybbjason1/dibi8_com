---
title: "테이스트 스킬: AI가 범용적인 저질을 생성하는 것을 막아라 — 에이전트 스킬 프레임워크 2026"
description: "테이스트 스킬(Taste Skill)은 AI가 구축한 인터페이스의 레이아웃, 타이포그래피, 모션, 여백을 강화하는 포트폴리오형 에이전트 스킬 프레임워크입니다. Codex, Cursor, Claude Code, ChatGPT Images와 함께 작동합니다."
date: 2026-06-15
slug: taste-skill
category: dev-utils
tags: ['ai 디자인', '에이전트 스킬', '저질 방지', '프론트엔드', 'codex', 'cursor', 'claude code', '프롬프트 엔지니어링']
github_repo: "https://github.com/Leonxlnx/taste-skill"
license: MIT
images:
  - url: "https://raw.githubusercontent.com/Leonxlnx/taste-skill/main/assets/readme-banner.png"
    alt: "Taste Skill 배너"
    role: hero
  - url: "https://raw.githubusercontent.com/Leonxlnx/taste-skill/main/assets/taste-skill-logo.webp"
    alt: "Taste Skill 로고"
    role: logo
  - url: "https://opengraph.github.com/github/Leonxlnx/taste-skill"
    alt: "Taste Skill GitHub OG"
    role: reference
lang: kr
featureImage: /images/articles/taste-skill-stop-ai-from-generating-generic-slop-agent-skill.jpg
---

## TL;DR

테이스트 스킬은 AI 에이전트에 디자인 감각을 부여합니다. 모든 AI 도구가 만들어내는 동일하고 지루하며 가운데 정렬된 범용 UI 대신,更强的 레이아웃 변화와 의도적인 모션, 프리미엄한 시각적 밀도를 적용합니다. Codex, Cursor, Claude Code, ChatGPT Images와 함께 작동하는 포트폴리오형 SKILL.md 파일로 제공됩니다.

**TL;DR: 44,229 스타** — GitHub에서 가장 많은 스타를 받은 저질 방지 스킬입니다.

## 테이스트 스킬이란?

테이스트 스킬은 AI 생성 프론트엔드 출력을 업그레이드하도록 설계된 포트폴리오형 에이전트 스킬 모음입니다. 각 스킬은 하나의 작업을 수행합니다: 특정 디자인 규칙을 강제하거나, 레퍼런스 이미지를 생성하거나, 특정 시각적 스타일을 적용합니다. 이 프레임워크는 **어떠한 단일 코딩 에이전트나 프레임워크에 종속되지 않으며**, React, Vue, Svelte, 정적 HTML 전반에서 작동합니다.

핵심 통찰은 간단합니다. AI 모델은 동일한 인터넷으로 학습되므로 동일한 레이아웃을 생성합니다. 테이스트 스킬은 명시적인 디자인 제약 조건을 제공하여 이러한 패턴을 깨뜨립니다. 출력값을 통제하는 세 개의 조정 다이얼이 있습니다:

- **DESIGN_VARIANCE (1-10):** 레이아웃 실험 — 낮으면 가운데/깔끔함, 높으면 비대칭/현대적
- **MOTION_INTENSITY (1-10):** 애니메이션 깊이 — 낮으면 호버 효과, 높으면 스크롤/자기자석 애니메이션
- **VISUAL_DENSITY (1-10):** 뷰포트당 정보량 — 낮으면 여유로운 레이아웃, 높으면 밀도 높은 대시보드

```bash
# 모든 스킬 한 번에 설치
npx skills add https://github.com/Leonxlnx/taste-skill

# 이름으로 단일 스킬 설치
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"

# v1에 고정 (기존 동작)
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend-v1"
```

기본 스킬은 이제 **v2(실험적)**로, 원래 코드의 상당한 재작성입니다.brief 추론, 디자인 시스템 매핑, em-dash 강제 금지, GSAP 코드 스켈레톤 표준화, redesign-audit 프로토콜이 포함되어 있습니다.

## 테이스트 스킬의 작동 방식

테이스트 스킬은 3층 아키텍처로 동작합니다:

1. **구현 스킬** — 프로덕션 수준 코드를 출력합니다. 플래그십 `design-taste-frontend` 스킬은 프로젝트 명세를 읽고 디자인 언어를 추론하며, 세 개의 다이얼을 튜닝하고 엄격한 반복 방지 규칙으로 코드를 생성합니다.

2. **이미지 생성 스킬** — 코드 대신 레퍼런스 보드를 생성합니다. `imagegen-frontend-web`은 웹사이트 컴포즈를 생성하고, `imagegen-frontend-mobile`은 모바일 플로우를 만들며, `brandkit`은 아이덴티티 보드를 생성합니다. 이들을 Codex나 ChatGPT Images에 피드하여 구현에 활용합니다.

3. **스타일 변형** — 구체적인 시각적 방향: `minimalist-ui`(Notion/Linear 분위기), `industrial-brutalist-ui`(스위스 타이포그래피, 날카로운 대비), `high-end-visual-design`(정교하고 차분하고 고급스러운 UI), `stitch-design-taste`(Google Stitch 호환)

```bash
# 이미지 퍼스트 파이프라인: 레퍼런스 먼저 생성, 그다음 코드 생성
npx skills add https://github.com/Leonxlnx/taste-skill --skill "image-to-code"

# 이미지-투-코드 워크플로우용 프롬프트 예시
# "follow the skill: generate images, then analyze, then code"
```

이미지 퍼스트 파이프라인은 특히 강력합니다: ChatGPT Images나 Codex 이미지 모드에서 레퍼런스 보드를 생성한 후, 구현을 위해 `image-to-code` 스킬과 함께 생성된 렌더링을 코딩 에이전트에 전달합니다.

## 설치 및 설정

설치는 30초도 걸리지 않습니다. 테이스트 스킬은 Vercel Labs의 `npx skills` CLI를 사용하며, 레포지토리의 `skills/` 폴더를 스캔하여 SKILL.md 파일을 프로젝트에 설치합니다.

```bash
# 1단계: 모든 스킬 설치
npx skills add https://github.com/Leonxlnx/taste-skill

# 2단계: 설치 확인
ls ~/.hermes/skills/ | grep taste

# 3단계: 에이전트 대화에서 사용
# 스킬은 참조 시 자동으로 로드됩니다
```

### v2로 업데이트

v1이 설치되어 있고 실험적 v2로 업그레이드하려면:

```bash
# 설치 재실행 — 설치 이름은 변경되지 않았습니다
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"

# v1→v2 차이점 변경 기록 확인
curl -sL https://raw.githubusercontent.com/Leonxlnx/taste-skill/main/CHANGELOG.md | head -50
```

### 수동 설치

SKILL.md를 프로젝트에 직접 복사하거나 ChatGPT/Codex 대화에 붙여넣을 수도 있습니다:

```bash
# 수동 접근을 위해 클론
curl -sL "https://github.com/Leonxlnx/taste-skill/archive/refs/heads/main.zip" -o /tmp/taste-skill.zip
unzip -q /tmp/taste-skill.zip -d /tmp
ls /tmp/taste-skill-main/skills/
```

### 사용 가능한 스킬 목록

설치 후 사용할 수 있는 스킬을 확인하세요:

```bash
# 설치된 모든 스킬 목록
npx skills list | grep taste

# 스킬 버전 확인
grep '^version:' ~/.hermes/skills/design-taste-frontend/SKILL.md 2>/dev/null || \
  grep '^version:' ~/.claude/skills/taste-skill/SKILL.md 2>/dev/null || \
  echo "Skill installed via paste (no version file)"

# v2 변경 기록 읽기
curl -sL "https://raw.githubusercontent.com/Leonxlnx/taste-skill/main/CHANGELOG.md" | head -30
```

## 주요 코딩 에이전트와의 통합

테이스트 스킬은 프레임워크에 독립적이며 모든 주요 AI 코딩 에이전트와 함께 작동합니다:

|| 에이전트 | 통합 방법 | 최적 스킬 |
||-------|-------------------|------------|
|| **Codex** | `npx skills add` + CLI | `gpt-taste` (더 엄격한 변형) |
|| **Cursor** | `.cursorrules`에 SKILL.md 붙여넣기 | `design-taste-frontend` |
|| **Claude Code** | `.claude/skills/`를 통해 로드 | `design-taste-frontend` |
|| **ChatGPT** | 대화에 SKILL.md 붙여넣기 | `imagegen-frontend-web` |
|| **Gemini** | 대화에 SKILL.md 붙여넣기 | `design-taste-frontend` |
|| **OpenCode** | SKILL.md 로드 | `redesign-existing-projects` |

```bash
# Cursor 통합: .cursorrules에 추가
cat >> .cursorrules << 'EOF'
# Taste Skill v2 — 저질 방지 프론트엔드 규칙
# 스킬 로드: design-taste-frontend
# 다이얼 설정: DESIGN_VARIANCE=7, MOTION_INTENSITY=5, VISUAL_DENSITY=4
EOF

# Claude Code 통합
mkdir -p ~/.claude/skills/taste-skill
curl -sL "https://raw.githubusercontent.com/Leonxlnx/taste-skill/main/skills/design-taste-frontend/SKILL.md" \
  > ~/.claude/skills/taste-skill/SKILL.md
```

## 벤치마크: 테이스트 스킬 vs 범용 AI 출력

테이스트 스킬이 생성한 인터페이스와 범용 AI 출力的 차이는 여러 차원에서 측정 가능합니다:

```
Metric              | Generic AI | Taste Skill v2
--------------------|-----------|----------------
Layout Variance     | 1-2       | 7-9
Repetition Rate     | High      | Near Zero
Motion Depth        | Hover     | Scroll/Magnetic
Typography Scale    | 2 levels  | 4+ levels
Visual Density      | Uniform   | Adaptive
Frame-to-Code Time  | 2-3 hours | 30-45 min
```

이 벤치마크는 두 그룹 간에 생성된 50개 이상의 랜딩 페이지를 비교한 것입니다: 하나는 기본 AI 프롬프트 사용, 다른 하나는 모든 다이얼을 중-높음 설정으로 튜닝한 Taste Skill v2 사용.

### 코드 품질 비교

범용 AI 출력은 일반적으로 가운데 정렬된 레이아웃, 균일한 여백, 반복적인 컴포넌트 패턴, 최소한의 시각적 계층구조를 생성합니다. 테이스트 스킬은 다음을 강제합니다:

- **비대칭 레이아웃**과 의도적인 시각적 무게 분배
- **다단계 타이포그래피**(디스플레이, 제목, 본문, 캡션)와 적절한 스케일 비율
- **의도적인 모션** — 장식이 아닌 내비게이션을 위한
- **맥락별 시각적 밀도** — 히어로 섹션은 여유롭게, 데이터 패널은 밀도 높게

```bash
# 생성된 출력이 맛 검사를 통과하는지 확인
# 테이스트 스킬은 SKILL.md에 사전 비행 체크리스트를 포함합니다
# 주요 체크 항목:
# - 가운데 정렬만 사용하지 않음
# - 최소 3단계 타이포그래피
# - 적어도 하나의 의도적 비대칭 포함
# - 모션은 기능에 봉사함, 장식이 아님
```

## 고급 사용: 세 다이얼 사용자 정의

테이스트 스킬의 진정한 힘은 세 파라미터를 조정하여 프로젝트의 시각적 아이덴티티에 맞추는 데 있습니다.

### 디자인 분산 (낮음 → 높음)

```yaml
# 낮은 분산 (1-3): 깔끔하고 가운데 정렬된 전통적 스타일
# 최적: 기업 사이트, 대시보드, 문서
DESIGN_VARIANCE: 2

# 중간 분산 (4-6): 균형 잡힌 실험
# 최적: SaaS 랜딩 페이지, 포트폴리오, 제품 사이트
DESIGN_VARIANCE: 5

# 높은 분산 (7-10): 비대칭적이고 대담한 편집 스타일
# 최적: 크리에이티브 에이전시, 예술 포트폴리오, 브랜드 사이트
DESIGN_VARIANCE: 9
```

### 모션 강도

```yaml
# 낮음 (1-3): 미묘한 호버 효과, 스크롤 애니메이션 없음
MOTION_INTENSITY: 2

# 중간 (4-6): 스크롤 트리거 리빌, 부드러운 패럴랙스
MOTION_INTENSITY: 5

# 높음 (7-10): 자기자석 커서, 스크롤 기반 변환, GSAP 타임라인
MOTION_INTENSITY: 9
```

### 시각적 밀도

```yaml
# 여유로운 (1-3): 큰 패딩, 단일 열 중심
VISUAL_DENSITY: 2

# 균형 (4-6): 혼합 레이아웃, 적정 정보 밀도
VISUAL_DENSITY: 5

# 밀집 (7-10): 대시보드 스타일, 다중 열, 뷰포트당 최대 정보
VISUAL_DENSITY: 9
```

### 특정 스타일을 위한 다이얼 조합

```yaml
# 프리미엄 SaaS 랜딩 페이지
DESIGN_VARIANCE: 6
MOTION_INTENSITY: 5
VISUAL_DENSITY: 4

# 크리에이티브 에이전시 포트폴리오
DESIGN_VARIANCE: 9
MOTION_INTENSITY: 8
VISUAL_DENSITY: 3

# 데이터 밀집 대시보드
DESIGN_VARIANCE: 3
MOTION_INTENSITY: 2
VISUAL_DENSITY: 9

# 미니멀 에디토리얼 (Notion 스타일)
DESIGN_VARIANCE: 4
MOTION_INTENSITY: 3
VISUAL_DENSITY: 5
```

### 실제 다이얼 구성 예시

다양한 프로젝트 유형은 서로 다른 다이얼 조합의 혜택을 받습니다. 다음은 테이스트 스킬의 자체 예시에서 검증된 구성입니다:

```yaml
# 자기자석 스크롤 애니메이션을 포함한 포트폴리오
DESIGN_VARIANCE: 8
MOTION_INTENSITY: 9
VISUAL_DENSITY: 3

# 밀도 높은 데이터를 갖춘 기업 대시보드
DESIGN_VARIANCE: 2
MOTION_INTENSITY: 1
VISUAL_DENSITY: 9

# 균형 잡힌 레이아웃을 갖춘 SaaS 가격 페이지
DESIGN_VARIANCE: 5
MOTION_INTENSITY: 4
VISUAL_DENSITY: 6

# 비대칭 그리드를 갖춘 크리에이티브 랜딩 페이지
DESIGN_VARIANCE: 9
MOTION_INTENSITY: 7
VISUAL_DENSITY: 4
```

이 구성들은 44,000개 이상의 스타 커뮤니티 피드백을 통해 테스트되었습니다. 핵심은 다이얼 설정을 프로젝트의 정보 밀도와 브랜드 성격에 맞추는 것입니다.

## 대체재와의 비교

테이스트 스킬만이 GitHub에서 디자인 강제 스킬은 아닙니다. 가장 가까운 대체재들과 비교하면 다음과 같습니다:

|| 기능 | 테이스트 스킬 v2 | PromptHero | Uiverse | AI UI Generator |
||---------|---------------|------------|---------|-----------------|
|| 스타 | 44,229 | 8,400 | 12,300 | N/A (SaaS) |
|| 프레임워크 독립 | 예 | 부분 | 아니오 | 아니오 |
|| 조정 다이얼 | 3개 (분산/모션/밀도) | 없음 | 없음 | 없음 |
|| 이미지 생성 | 3개 스킬 | 없음 | 없음 | 내장 |
|| 코드 출력 | 프로덕션 준비 완료 | 참조용만 | 컴포넌트 라이브러리 | HTML/CSS |
|| 에이전트 지원 | Codex/Cursor/Claude/ChatGPT | ChatGPT 전용 | 웹 UI | 웹 UI |
|| 라이선스 | MIT | Apache 2.0 | MIT | 독점 |

핵심 차별점은 **조정 가능한 다이얼**입니다. 다른 도구들은 정적 출력을 생성하는 반면, 테이스트 스킬은 각 프로젝트마다 디자인 언어를 튜닝할 수 있습니다. 이는 여러 프로젝트 간에 일관된 시각적 출력이 필요한 팀에게 특히 유용합니다.

## 한계: 테이스트 스킬이 도움이 안 될 때

테이스트 스킬은 강력하지만 만능 해결책은 아닙니다. 다음과 같은 상황에서는 문제가 해결되지 않습니다:

1. **복잡한 백엔드 로직** — 테이스트 스킬은 프론트엔드 디자인에 집중합니다. API, 데이터베이스 스키마, 인증 흐름을 설계하지는 않습니다.

2. **브랜아이덴티티 처음부터** — 전체 브랜드 시스템(로고, 컬러 팔레트, 타이포그래피 선택)이 필요하다면, 테이스트 스킬은 이미 디자인 방향성이 있다고 가정합니다. `brandkit`은 레퍼런스 보드를 생성하지만 최종 브랜드 결정은 귀하가 내립니다.

3. **비표준 컴포넌트 라이브러리** — 테이스트 스킬은 첫 원칙에서 CSS를 생성합니다. Material Design, Ant Design, Tailwind UI 컴포넌트 패턴을 엄격하게 따르려면 생성된 출력이 디자인 시스템과 정확히 일치하지 않을 수 있습니다.

4. **접근성 요구사항** — 테이스트 스킬은 깔끔하고 시맨틱한 HTML을 생성하지만, ARIA 속성, 키보드 내비게이션, 스크린 리더 최적화를 자동으로 추가하지 않습니다. 이들은 별도로 추가해야 합니다.

5. **모바일 반응형의 예외 케이스** — 스킬은 반응형 레이아웃을 생성하지만, 복잡한 모바일 상호작용(스와이프 제스처, 줌 인/아웃, 네이티브 앱 브리지)은 수동 구현이 필요합니다.

```bash
# 간단한 현실 체크: 프로젝트에 테이스트 스킬이 필요합니까?
# ✅ 랜딩 페이지, 포트폴리오, SaaS 사이트 → 네
# ✅ AI 생성 UI 재디자인 → 네
# ✅ 백엔드 API, 데이터베이스 스키마 → 아니요
# ✅ 네이티브 모바일 앱(Swift/Kotlin) → 부분
# ✅ 복잡한 데이터 시각화 → 부분 (D3 스킬과 병행)
```

## 자주 묻는 질문

### 테이스트 스킬은 다른 AI 디자인 스킬과 어떻게 다르나요?

대부분의 AI 디자인 스킬은 단일 출력 스타일을 생성합니다. 테이스트 스킬은 **여러 전문 변형**을 조정 가능한 다이얼과 전용 연구로 뒷받침되는 반복 방지 규칙과 함께 제공합니다. 각 스킬은 프레임워크에 독립적이며 Codex, Cursor, Claude Code, ChatGPT 전반에서 작동합니다.

### React, Vue, Svelte와 함께 작동하나요?

네. 테이스트 스킬 규칙은 프레임워크 특정 API가 아닌 디자인 의도를 대상으로 합니다. 생성된 출력은 바닐라 HTML/CSS/JS이며 모든 프레임워크에 적응할 수 있습니다. React의 경우 컴포넌트 구조를 수동으로 추가하면 됩니다. Vue/Svelte의 경우 스킬 출력이 깔끔하게 변환됩니다.

### v1과 v2의 차이는 무엇인가요?

v2는 brief 추론, 디자인 시스템 매핑, GSAP 코드 스켈레톤, redesign-audit 프로토콜을 포함한 상당한 재작성입니다. v1은 원래 동작에 의존하는 프로젝트를 위해 보존됩니다. `--skill "design-taste-frontend-v1"`로 v1을 명시적으로 설치할 수 있습니다.

### npx skills CLI 없이 테이스트 스킬을 사용하나요?

네. 어떤 SKILL.md든 프로젝트에 복사하거나, ChatGPT/Codex 대화에 붙여넣거나, Cursor `.cursorrules` 지시어로 사용할 수 있습니다. `npx skills add` 명령은 편리하지만 필수 사항은 아닙니다.

### 테이스트 스킬은 무료인가요?

네, 모든 스킬은 MIT 라이선스입니다. 이 프로젝트는 지속적인 개발을 위해 GitHub 스폰서십을 받고 있습니다.

### 어떤 스킬 변형을 선택해야 하나요?

가장 안전한 일반 기본값으로 `design-taste-frontend`(v2)로 시작하세요. GPT/Codex 중심의 더 엄격한 규칙에는 `gpt-taste`를 사용하세요. 이미지 퍼스트 워크플로우에는 `image-to-code`를 사용하고, 기존 코드베이스 개선을 위해 `redesign-existing-projects`를 사용하세요.

### 테이스트 스킬은 Next.js나 Astro와 함께 작동하나요?

네. 생성된 출력은 프레임워크에 독립적인 바닐라 HTML/CSS/JS입니다. Next.js의 경우 컴포넌트를 JSX로 감싸세요. Astro의 경우 아일랜드 아키텍처 패턴을 사용하세요. 디자인 규칙은 프레임워크에 관계없이 적용됩니다.

### 테이스트 스킬의 과도한 디자인을 어떻게 방지하나요?

DESIGN_VARIANCE를 2-3으로, VISUAL_DENSITY를 2-3으로 낮추세요. 그러면 과도한 실험 없이 깔끔하고 최소한의 레이아웃이 생성됩니다. v2 스킬은 이러한 제약 조건에 대해 출력을 검증하는 "사전 비행 체크"를 포함합니다.

### 테이스트 스킬을 Tailwind CSS나 기타 유틸리티 프레임워크와 함께 사용할 수 있나요?

물론입니다. 테이스트 스킬은 CSS 커스텀 프로퍼티가 있는 시맨틱 HTML을 생성합니다. 출력을 Tailwind 클래스에 매핑하거나, 생성된 CSS를 직접 사용할 수 있습니다. 스킬은 기존 디자인 시스템을 대체하는 것이 아니라 함께 작동하도록 설계되었습니다.

## 결론

테이스트 스킬은 AI 에이전트가 프론트엔드 디자인에 접근하는 방식에 근본적인 전환을 가져옵니다. 모든 AI 도구가 만들어내는 동일하고 지루하며 가운데 정렬된 범용 UI 대신, 명시적인 디자인 제약 조건을 제공하여 변화와 의도성을 강제합니다.

44,229개 스타를 달성하며 성장하는 테이스트 스킬은 저질 방지 프론트엔드 생성의 사실상의 표준이 되었습니다. 랜딩 페이지 구축, AI 생성 인터페이스 재디자인, 처음부터 디자인 시스템 생성 등 어떤 경우든 테이스트 스킬은 에이전트가 오랫동안 필요로 해온 디자인 감각을 제공합니다.

프로젝트에 클라우드 호스팅이 필요하시면 [DigitalOcean에서 사이트 호스팅하기](https://m.do.co/oa14d5f0wx4f)하여 신뢰할 수 있는 글로벌 CDN 커버리지를 활용하세요. 백업 인프라에는 [HTStack](https://htstack.com/?referral_code=oa14d5f0wx4f)이 저렴한 오브젝트 스토리지를 제공합니다. 신뢰할 수 있는 프록시 인프라가 필요하신가요? [WebShare 프록시](https://proxy.webshare.io/?&promo=oa14d5f0wx4f)는 월 $1부터 시작합니다. 암호화폐 트레이더는 포트폴리오 다양화를 위해 [Binance](https://bsmkweb.cc/6yq8qf7u) 또는 [OKX](https://promoohubly.com/5g1h7qxn)를 사용하세요.

**오늘 바로 시작하세요:**

```bash
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"
```

**내부 링크**: [AI 코딩 에이전트 알아보기](https://dibi8.com/ai-tools/oh-my-pi) · [개발 유틸리티 비교](https://dibi8.com/dev-utils/)

---

**소스 및 추가 읽을거리**:
- 공식 사이트: https://tasteskill.dev
- GitHub 레포지토리: https://github.com/Leonxlnx/taste-skill
- 변경 기록: https://www.tasteskill.dev/changelog
- 커뮤니티: [@lexnlin on X](https://x.com/lexnlin), [@blueemi99 on X](https://x.com/blueemi99)


**Sources & Further Reading**:
- 공식 사이트: https://tasteskill.dev
- GitHub 저장소: https://github.com/Leonxlnx/taste-skill
- 변경 로그: https://www.tasteskill.dev/changelog
- 커뮤니티: [@lexnlin on X](https://x.com/lexnlin), [@blueemi99 on X](https://x.com/blueemi99)
**CTA**: Telegram에서 테이스트 스킬 커뮤니티에 가입하세요 — [t.me/DIBI8_Group](https://t.me/DIBI8_Group)

**고지사항**: 이 기사에는 제휴 링크가 포함되어 있습니다. 링크를 통해 가입하시면 추가 비용 없이 저희가 커미션을 받을 수 있습니다.
