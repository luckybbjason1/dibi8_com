---
title: '代码质量工具指南：ESLint、Prettier、Black、Ruff等完整配置教程'
description: '2025年最全代码质量工具配置指南，涵盖JavaScript/TypeScript的ESLint与Prettier、Python的Black与Ruff、Go与Rust的格式化工具，含pre-commit与CI/CD集成方案。'
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

代码质量工具是现代软件开发的基础设施。它们像自动化的质检员，在代码进入审查环节前捕获潜在问题、统一格式风格、减少低级错误。本文按语言维度拆解2025年最常用的质量工具链，提供可直接复制的配置文件和CI/CD集成方案。

## Lint与Format：两者的区别是什么？

很多开发者混淆了这两个概念：

- **Linting（静态分析）**：检查代码中的逻辑问题、潜在Bug、不符合最佳实践的模式。例如：使用了未声明的变量、可能的空指针引用、不安全的正则表达式
- **Formatting（格式化）**：调整代码的外观风格，不影响逻辑。例如：缩进空格数、引号类型、尾随逗号、最大行宽

**核心原则**：Linting找Bug，Format管美观。两者互补，不可互相替代。

## JavaScript/TypeScript：ESLint 9深度配置

[ESLint](https://eslint.org/) 是JavaScript生态的事实标准Linter，2024年发布的v9版本引入了革命性的Flat Config配置系统。

### ESLint 9 Flat Config基础配置

创建 `eslint.config.js`（替代旧的 `.eslintrc`）：

```javascript
import js from '@eslint/js';
import globals from 'globals';
import tseslint from 'typescript-eslint';
import reactHooks from 'eslint-plugin-react-hooks';

export default [
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    files: ['**/*.{js,jsx,ts,tsx}'],
    languageOptions: {
      ecmaVersion: 2024,
      sourceType: 'module',
      globals: {
        ...globals.browser,
        ...globals.node,
      },
    },
    plugins: {
      'react-hooks': reactHooks,
    },
    rules: {
      'no-unused-vars': 'warn',
      'no-console': ['warn', { allow: ['error', 'warn'] }],
      '@typescript-eslint/no-explicit-any': 'warn',
      'react-hooks/rules-of-hooks': 'error',
      'react-hooks/exhaustive-deps': 'warn',
    },
  },
  {
    ignores: ['dist/', 'node_modules/', '*.config.js'],
  },
];
```

Flat Config相比传统配置的优势：

- **纯JavaScript**：无需YAML/JSON，逻辑表达能力更强
- **显式导入**：每个配置集都是npm包，依赖关系清晰
- **性能更好**：不再有冗长的extends链

### 主流Shareable Config推荐

- **@eslint/js/recommended**：ESLint官方推荐规则
- **typescript-eslint/recommended**：TypeScript专属规则
- **eslint-config-airbnb**：Airbnb的严格规范，适合追求极致代码质量的团队
- **eslint-config-standard**：JavaScript Standard Style，无需配置即可使用
- **eslint-stylistic**：从ESLint核心迁移出的风格规则（ESLint 9已移除内置风格规则）

## Prettier：固执己见的代码格式化

[Prettier](https://prettier.io/) 采用"Opinionated"哲学——几乎没有配置选项，直接按照一套精心设计的规则格式化。这种设计减少了团队内的风格争论。

配置 `.prettierrc`：

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100,
  "bracketSpacing": true
}
```

**Prettier与ESLint不是竞争关系**。Prettier管格式，ESLint管逻辑。两者配合需要关闭ESLint中所有与格式相关的规则，使用 `eslint-config-prettier` 一键关闭：

```bash
npm install --save-dev eslint-config-prettier
```

然后在 `eslint.config.js` 末尾添加：

```javascript
import prettierConfig from 'eslint-config-prettier';

export default [
  // ... 其他配置
  prettierConfig, // 必须放在最后，覆盖所有格式相关规则
];
```

## ESLint + Prettier 完整集成步骤

新项目从零配置的步骤：

1. 安装依赖：`npm install --save-dev eslint prettier eslint-config-prettier typescript-eslint`
2. 创建 `eslint.config.js`（Flat Config格式）
3. 创建 `.prettierrc` 和 `.prettierignore`
4. 在 `package.json` 中添加脚本：

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

5. 配置VS Code自动格式化：

```json
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  }
}
```

这套配置实现了**保存时自动格式化+自动修复ESLint问题**的无缝体验。

## Python：Black——不妥协的格式化

[Black](https://black.readthedocs.io/) 被称为"The Uncompromising Python Code Formatter"，设计哲学与Prettier类似：几乎无配置选项，只提供一种正确的格式化方式。

安装与使用：

```bash
pip install black
black src/           # 格式化目录
black --check src/   # CI中检查格式（不改文件）
black --diff src/    # 查看将要做的修改
```

在 `pyproject.toml` 中配置：

```toml
[tool.black]
line-length = 88
target-version = ['py311', 'py312']
include = '\.pyi?$'
extend-exclude = '''
/(
  migrations
  | \.venv
  | build
  | dist
)/
'''
```

Black的88字符行宽（PEP 8默认79字符）经过精心设计，能在大多数显示器上并排显示两个文件。Black与Jupyter Notebook配合良好：`black notebook.ipynb` 可直接格式化Notebook中的代码单元格。

## Python：Ruff——极速全功能Linter

[Ruff](https://docs.astral.sh/ruff/) 由Astral团队开发（该团队还开发了uv包管理器），2025年已经成为Python代码质量工具的新标准。核心数据说话：

- **速度**：比Flake8快10-100倍，比Pylint快约300倍（Rust编写）
- **统一**：替代Flake8 + Black + isort + pydocstyle + pyupgrade 等多个工具
- **兼容**：原生支持Black的格式化风格和isort的导入排序

Ruff在 `pyproject.toml` 中的完整配置：

```toml
[tool.ruff]
target-version = "py311"
line-length = 88

[tool.ruff.lint]
select = [
  "E",    # pycodestyle errors
  "F",    # Pyflakes
  "I",    # isort
  "N",    # pep8-naming
  "W",    # pycodestyle warnings
  "UP",   # pyupgrade
  "B",    # flake8-bugbear
  "C4",   # flake8-comprehensions
  "SIM",  # flake8-simplify
]
ignore = ["E501"]  # 行宽由Black控制

[tool.ruff.lint.pydocstyle]
convention = "google"

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
```

**2025年的推荐**：新项目直接使用Ruff替代Flake8+Black组合。Ruff的格式化输出与Black高度一致，且单个工具减少了依赖管理的复杂度。

## 其他语言的质量工具

### Go：官方工具链

Go语言的格式化工具是官方内置的 `gofmt`，没有配置选项，所有Go代码统一格式：

```bash
gofmt -w .        # 格式化
go vet ./...      # 静态分析
golangci-lint run # 综合Linting（推荐）
```

[golangci-lint](https://golangci-lint.run/) 是Go生态的事实标准Linter聚合工具，集成了50+个Linter，一次运行完成全部检查。配置 `.golangci.yml` 启用需要的Linter。

### Rust：rustfmt + Clippy

Rust的官方工具链同样内置了格式化工具：

```bash
rustfmt src/main.rs    # 格式化
cargo clippy           # 综合Linting
cargo fmt -- --check   # CI中检查格式
```

[Clippy](https://doc.rust-lang.org/clippy/) 是Rust的官方Linter，提供了500+条检查规则，从性能优化到代码风格全覆盖。运行 `cargo clippy -- -D warnings` 可将所有警告视为错误，在CI中强制零警告。

## 各语言工具链一览对比

| 语言 | 格式化工具 | Linter | 配置文件 | 速度评级 |
|------|-----------|--------|---------|---------|
| **JavaScript/TypeScript** | Prettier | ESLint | `eslint.config.js` + `.prettierrc` | ★★★☆ |
| **Python（传统）** | Black | Flake8 + isort | `pyproject.toml` | ★★☆☆ |
| **Python（2025推荐）** | Ruff format | Ruff lint | `pyproject.toml` | ★★★★ |
| **Go** | gofmt | golangci-lint | `.golangci.yml` | ★★★★ |
| **Rust** | rustfmt | Clippy | `rustfmt.toml` | ★★★★ |

## Pre-Commit Hooks：自动化代码质量守门

手动运行lint和format容易遗忘。[pre-commit](https://pre-commit.com/) 框架在每次 `git commit` 前自动运行指定的检查，未通过则阻止提交。

安装配置：

```bash
pip install pre-commit
```

创建 `.pre-commit-config.yaml`：

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.4.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  - repo: local
    hooks:
      - id: eslint
        name: ESLint
        entry: npx eslint --fix
        language: system
        types: [javascript, jsx, tsx]
        pass_filenames: true
```

初始化钩子：

```bash
pre-commit install  # 注册到.git/hooks/pre-commit
pre-commit run --all-files  # 首次运行检查所有已有文件
```

JavaScript项目也可以使用 [Husky](https://typicode.github.io/husky/) + lint-staged 实现类似效果：

```json
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": ["eslint --fix", "prettier --write"],
    "*.py": ["ruff check --fix", "ruff format"]
  }
}
```

## CI/CD中的代码质量检查

代码质量检查必须集成到CI流水线中，确保不合规的代码无法合并到主分支。

### GitHub Actions示例（JavaScript + Python混合项目）

```yaml
name: Code Quality
on: [push, pull_request]
jobs:
  lint-js:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: npm ci
      - run: npm run lint
      - run: npm run format:check

  lint-python:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v2
      - run: uv pip install ruff
      - run: ruff check .
      - run: ruff format --check .
```

### GitLab CI示例

```yaml
stages: [lint]

lint:js:
  stage: lint
  image: node:20-alpine
  script:
    - npm ci
    - npm run lint
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"

lint:python:
  stage: lint
  image: python:3.12-slim
  script:
    - pip install ruff
    - ruff check .
    - ruff format --check .
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
```

关键原则：**CI中的检查命令与本地配置完全一致**，使用相同的配置文件（`pyproject.toml`、`eslint.config.js`），确保本地通过即CI通过。

## 如何渐进式引入代码质量工具？

存量项目一次性开启所有规则可能导致成百上千个错误，推荐渐进式策略：

1. **第一周**：安装工具，启用最基础规则（语法错误、未使用变量），`--fix` 自动修复大部分问题
2. **第二周**：加入格式化工具（Prettier/Ruff format），格式化全部代码
3. **第三周**：逐步启用更多lint规则，每次新增5-10条
4. **第四周**：配置pre-commit hooks和CI流水线，强制执行

对于遗留代码库，可以使用ESLint的 `override` 或Ruff的 `per-file-ignores` 对旧文件临时豁免，新文件严格执行，避免一次性改动过大。

## FAQ：代码质量工具常见问题

**Q: ESLint和Prettier要一起用吗？**
A: 强烈推荐一起使用，但职责要分开。ESLint负责逻辑问题（未使用变量、类型错误），Prettier负责代码格式（缩进、引号、行宽）。使用 `eslint-config-prettier` 关闭冲突规则即可无缝配合。

**Q: Python开发该用Black还是Ruff？**
A: 2025年推荐直接用Ruff。Ruff的格式化输出与Black几乎完全一致，且同时提供lint和format功能，一个工具替代整个工具链，速度也快10倍以上。新项目首选Ruff。

**Q: 如何设置pre-commit hooks？**
A: 安装 `pre-commit` 包，创建 `.pre-commit-config.yaml` 定义需要的hooks，运行 `pre-commit install` 注册到Git钩子。提交代码时会自动运行检查，未通过则阻止提交并显示问题。

**Q: 有没有一个工具能覆盖多种语言？**
A: 没有真正意义上的全语言通用工具。但pre-commit框架可以统一编排不同语言的工具，在一个配置中管理JS/Python/Go等项目的检查。EditorConfig（`.editorconfig`）则提供跨语言的基础格式约定（缩进、换行符、编码）。

**Q: 如何在CI/CD中强制执行代码质量？**
A: 在CI流水线中添加lint和format检查步骤，使用 `--check` 模式（只检查不修复），任何不合规的代码都会导致流水线失败。配合分支保护规则，未通过检查的PR禁止合并。

---

## 推荐基础设施

要 7×24 稳跑上述工具，服务器选择关键：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 $200 试用 60 天，全球 14+ 节点，一键 droplet 适配 AI 工作流。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟。**dibi8.com 自家所在 IDC**，生产验证。

*推广链接，不增加你的成本，能支持 dibi8.com 运营。*

