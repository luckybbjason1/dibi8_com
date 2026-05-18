---
title: '코드 품질 도구 가이드: ESLint, Prettier, Black, Ruff 및 기타 도구'
description: 'JavaScript/TypeScript와 Python의 코드 품질 도구를 상세히 비교합니다. ESLint, Prettier, Black, Ruff의 설정 방법과 통합 전략, 그리고 Go와 Rust의 포맷터까지 완벽 정리했습니다.'
date: 2026-05-18 00:00:00+08:00
lastmod: 2026-05-18 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-18'
featureImage: ''
draft: false
aliases:
- /posts/code-quality-tools-eslint-prettier-black-ruff/
---

{</* resource-info */>}

일관된 코드 스타일은 단순한 미관의 문제가 아닙니다. 2024년 Stripe의 연구에 따른 결과, 코드 리뷰 시간의 25%가 스타일 논쟁과 형식 불일치 해결에 소비됩니다. 코드 품질 도구는 이러한 낭비를 제거하고 버그를 사전에 발견하는 핵심 인프라입니다. 이 글에서는 JavaScript/TypeScript와 Python 생태계의 대표적인 코드 품질 도구를 설치부터 CI/CD 통합까지 상세히 다룹니다.

## 린팅과 포맷팅의 차이점

**린팅(Linting)**은 코드의 잠재적 버그, 안티 패턴, 논리적 오류를 검출합니다. **포맷팅(Formatting)**은 코드의 시각적 배치(들여쓰기, 줄 길이, 따옴표 등)를 통일합니다. 두 도구는 서로 보완적이며, 동시에 사용해야 최적의 효과를 얻습니다.

| 구분 | 린터 | 포맷터 |
|------|------|--------|
| 목적 | 버그/오류 검출 | 코드 스타일 통일 |
| 예시 | ESLint, Ruff(check) | Prettier, Ruff(format) |
| 설정 복잡도 | 높음 (규칙 선택) | 낮음 (의견 제시) |
| 수정 가능성 | 일부 자동 수정 | 대부분 자동 수정 |

## 1. JavaScript/TypeScript: ESLint 상세 가이드

### ESLint란?

[ESLint](https://eslint.org)는 JavaScript/TypeScript 생태계에서 가장 널리 사용되는 정적 분석 도구입니다. 2024년에 릴리스된 ESLint 9는 Flat Config라는 새로운 설정 시스템을 도입했습니다.

### ESLint 9 Flat Config 설정

Legacy `.eslintrc` 대신 `eslint.config.js` (또는 `.mjs`)를 사용합니다:

```javascript
// eslint.config.mjs
import js from "@eslint/js";
import tseslint from "typescript-eslint";
import globals from "globals";

export default [
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    languageOptions: {
      globals: { ...globals.node, ...globals.browser },
    },
    rules: {
      "no-unused-vars": "warn",
      "@typescript-eslint/no-explicit-any": "warn",
    },
  },
];
```

### 주요 공유 설정

| 설정 | 특징 | 설치 방법 |
|------|------|----------|
| Airbnb | 가장 엄격한 규칙 | `eslint-config-airbnb` |
| Standard | 세미콜론 없음, 간결함 | `eslint-config-standard` |
| XO | Prettier와 호환 | `eslint-config-xo` |
| Recommended | ESLint 기본 권장 | `@eslint/js` 내장 |

### TypeScript 통합

2024년 기준 `@typescript-eslint`는 ESLint 팀이 직접 관리합니다:

```bash
npm install --save-dev typescript-eslint @eslint/js eslint
```

### ESLint Stylistic

ESLint 9에서 코어 포맷팅 규칙이 제거되었습니다. 포맷팅 규칙이 필요하면 [ESLint Stylistic](https://eslint.style)을 사용합니다.

## 2. JavaScript/TypeScript: Prettier 설정

### Prettier란?

[Prettier](https://prettier.io)는 "의견이 강한(opinionated)" 코드 포맷터입니다. 설정 옵션을 최소화하고 하나의 표준을 강제합니다.

### 설치와 설정

```bash
npm install --save-dev prettier
```

`.prettierrc` 파일:

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100
}
```

### ESLint와 Prettier의 관계

두 도구는 경쟁이 아닌 협력 관계입니다. ESLint는 린팅, Prettier는 포맷팅을 담당합니다. 충돌을 방지하려면 `eslint-config-prettier`를 설치하여 ESLint의 포맷팅 규칙을 비활성화합니다:

```bash
npm install --save-dev eslint-config-prettier
```

`eslint.config.mjs`에 추가:

```javascript
import prettier from "eslint-config-prettier";

export default [
  // ... 다른 설정
  prettier, // Prettier와 충돌하는 규칙 비활성화
];
```

## 3. ESLint + Prettier: 완전 통합 가이드

### 신규 프로젝트 설정

```bash
# 1. 패키지 설치
npm install --save-dev eslint prettier eslint-config-prettier typescript-eslint @eslint/js

# 2. 설정 파일 작성 (eslint.config.mjs, .prettierrc)
# 3. package.json 스크립트 추가
```

`package.json` 스크립트:

```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier --write .",
    "format:check": "prettier --check ."
  }
}
```

### Legacy Config에서 Flat Config 마이그레이션

ESLint 8 → 9 업그레이드 시 `.eslintrc.json`을 `eslint.config.mjs`로 변환합니다. 주요 변경점:
- `extends` → 배열의 설정 객체 임포트
- `plugins` → 직접적인 플러그인 임포트
- `.eslintignore` → `ignores` 배열

## 4. Python: Black — 타협하지 않는 포맷터

### Black의 철학

[Black](https://black.readthedocs.io)은 "There is one way to format Python"이라는 모토로, 사용자의 선택권을 최소화하고 PEP 8 기반의 유일한 포맷을 강제합니다.

### 설치와 사용

```bash
pip install black
black .
```

### pyproject.toml 설정

```toml
[tool.black]
line-length = 88
target-version = ['py311']
include = '\.pyi?$'
extend-exclude = '''
/(
  migrations
)/
'''
```

Black의 핵심 장점은 **설정이 거의 없다는 것**입니다. 팀 내 스타일 논쟁을 원천 차단합니다. 다만, 줄 길이(기본 88자)나 문자열 따옴표 정책 등 일부 사용자에게는 제한적으로 느껴질 수 있습니다.

## 5. Python: Ruff — 초고속 올인원 린터

### 왜 Ruff가 Black과 Flake8을 대체하는가?

[Ruff](https://docs.astral.sh/ruff)는 Astral Software가 개발한 Rust 기반 Python 린터이자 포맷터입니다. 2023년 출시 이후 폭발적인 성장을 이뤘으며, 2025년 현재 Python 생태계에서 가장 빠른 린팅/포맷팅 도구입니다.

**성능 비교:**

| 도구 | 속도 | 기능 |
|------|------|------|
| Flake8 | 기준 | 린팅 |
| Black | 기준 | 포맷팅 |
| isort | 기준 | 임포트 정렬 |
| **Ruff** | **Flake8 대비 10-100배** | **린팅 + 포맷팅 + 임포트 정렬** |

Ruff 하나로 Flake8, Black, isort, pydocstyle, pyupgrade를 모두 대체할 수 있습니다.

### pyproject.toml 전체 설정

```toml
[tool.ruff]
target-version = "py311"
line-length = 88

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "UP", "B", "C4"]
ignore = ["E501"]

[tool.ruff.lint.pydocstyle]
convention = "google"

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
```

### Flake8/Black에서 Ruff로 마이그레이션

1. `pip uninstall flake8 black isort`
2. `pip install ruff`
3. `pyproject.toml`에 Ruff 설정 추가
4. `ruff check .`와 `ruff format .`으로 검증

Ruff의 포맷터는 Black과 99.9% 동일한 출력을 생성하므로, 기존 Black 사용자는 거의 무차별 전환이 가능합니다.

## 6. Go: gofmt과 golangci-lint

Go는 [gofmt](https://pkg.go.dev/cmd/gofmt)가 언어 표준 도구체인에 내장되어 있습니다. 모든 Go 개발자가 동일한 포맷을 사용하며, 이는 Go 생태계의 큰 강점입니다.

종합 린팅은 [golangci-lint](https://golangci-lint.run)를 사용합니다:

```bash
golangci-lint run ./...
```

`.golangci.yml`으로 30개 이상의 린터를 통합 관리할 수 있습니다.

## 7. Rust: rustfmt과 Clippy

Rust도 `rustfmt`가 표준 포맷터로, `cargo fmt` 명령어로 실행합니다. [Clippy](https://doc.rust-lang.org/clippy)는 Rust의 공식 린터로 650개 이상의 검사 규칙을 제공합니다:

```bash
cargo fmt        # 포맷팅
cargo clippy     # 린팅
```

## 8. Pre-commit Hooks: 코드 품질 자동화

### pre-commit 프레임워크

[pre-commit](https://pre-commit.com)은 Git의 pre-commit 훅을 관리하는 Python 기반 도구입니다. `.pre-commit-config.yaml`로 여러 훅을 선언적으로 관리합니다:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.5.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: v4.0.0-alpha.8
    hooks:
      - id: prettier
```

설치와 실행:

```bash
pre-commit install
pre-commit run --all-files
```

### JavaScript 프로젝트: Husky

[Husky](https://github.com/typicode/husky)는 JavaScript/TypeScript 프로젝트에서 널리 사용되는 Git hooks 관리자입니다:

```bash
npx husky-init && npm install
```

`.husky/pre-commit`:

```bash
npx lint-staged
```

## 9. CI/CD 통합

### GitHub Actions 워크플로우

```yaml
name: Code Quality
on: [push, pull_request]
jobs:
  lint-and-format:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - run: npm run lint
      - run: npm run format:check
```

### GitLab CI 파이프라인

```yaml
lint:
  image: node:20-alpine
  script:
    - npm ci
    - npm run lint
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
```

린팅 오류가 발생하면 빌드를 실패시키는 것이 중요합니다. 이렇게 하면 품질 기준을 강제할 수 있습니다.

## 10. 언어별 도구 매핑 표

| 언어 | 포맷터 | 린터 | 임포트 정렬 | 설정 파일 |
|------|--------|------|------------|----------|
| JavaScript/TypeScript | Prettier | ESLint | ESLint (sort-imports) | `eslint.config.mjs`, `.prettierrc` |
| Python | Ruff format | Ruff | Ruff | `pyproject.toml` |
| Go | gofmt | golangci-lint | goimports | `.golangci.yml` |
| Rust | rustfmt | Clippy | 내장 | `rustfmt.toml` |

## 결론

코드 품질 도구의 선택은 언어와 팀 문화에 따라 달라집니다. JavaScript/TypeScript 프로젝트는 ESLint + Prettier의 조합이 여전히 표준이며, Python 프로젝트는 2025년 기준 Ruff가 Flake8 + Black 조합을 빠르게 대체하고 있습니다.

도구를 도입할 때는 **한 번에 하나씩** 도입하세요. 한꺼번에 너무 많은 규칙을 추가하면 팀의 저항과 피로도가 높아집니다. pre-commit hook과 CI/CD 통합으로 자동화하면 개발자가 신경 쓰지 않아도 코드 품질이 유지됩니다.

---

## FAQ

**ESLint와 Prettier를 함께 사용해야 하나요?**  
네이, 두 도구는 서로 보완적입니다. ESLint는 코드 품질(버그, 안티 패턴)을 검사하고, Prettier는 코드 스타일(들여쓰기, 줄 길이)을 통일합니다. `eslint-config-prettier`로 충돌 규칙을 비활성화하세요.

**Python에서 Ruff가 Black보다 더 나은가요?**  
속도와 통합 측면에서 Ruff가 우수합니다. Ruff의 포맷터는 Black과 99.9% 동일한 출력을 생성하며, 린팅까지 단일 도구로 처리할 수 있습니다. 2025년 신규 프로젝트에는 Ruff를 권장합니다.

**pre-commit hook을 어떻게 설정하나요?**  
`pip install pre-commit` 후 `.pre-commit-config.yaml`에 원하는 훅을 정의하고, `pre-commit install`로 Git hook을 활성화합니다. JavaScript 프로젝트는 Husky + lint-staged 조합을 사용하세요.

**하나의 도구로 여러 프로그래밍 언어를 지원할 수 있나요?**  
Ruff는 Python 전용입니다. 다중 언어 지원이 필요하면 [pre-commit](https://pre-commit.com) 프레임워크를 사용하여 ESLint(JS/TS), Ruff(Python), gofmt(Go)를 하나의 파이프라인에서 실행할 수 있습니다.

**CI/CD 파이프라인에서 코드 품질을 어떻게 강제하나요?**  
GitHub Actions나 GitLab CI에 린트/포맷 체크 단계를 추가하고, 실패 시 빌드를 중단하도록 설정합니다. PR 머지 전에 코드 품질 검사를 통과하도록 브랜치 보호 규칙을 구성하세요.

---

## 추천 인프라

위 도구들을 24/7 안정 운영하려면 인프라가 중요하다:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연. dibi8.com 자체 호스팅 IDC.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

