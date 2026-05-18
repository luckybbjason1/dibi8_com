---
title: 'Code Quality Tools Guide: ESLint, Prettier, Black, Ruff & More'
description: 'Set up code quality tools for any language: ESLint, Prettier, Black, Ruff, golangci-lint, and rustfmt. Complete configs, CI integration, and pre-commit hooks.'
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

Code quality tools are not optional in professional software development. They catch bugs before they reach production, enforce consistency across team members, and eliminate entire categories of code review debates about formatting and style. A project without automated quality enforcement drifts into inconsistency. A project with the right tools maintains readability and reliability with minimal ongoing effort.

This guide covers the essential linting and formatting tools for JavaScript, TypeScript, Python, Go, and Rust. You will find complete setup instructions, configuration examples, CI/CD integration patterns, and pre-commit hook configurations for each language.

## Why Code Quality Tools Are Essential

### The Cost of Inconsistent Code

Inconsistent code is expensive to maintain. A 2023 study by Stripe estimated that developers spend 31% of their time dealing with technical debt — much of it caused by inconsistent patterns that make code harder to understand and modify. When every file in a project uses different formatting, naming conventions, and style patterns, developers must context-switch constantly. Cognitive load increases. Bugs hide in the confusion.

### Linting vs Formatting: Understanding the Difference

Linting and formatting serve different purposes:

- **Linting** analyzes code for potential errors, bugs, and anti-patterns. It catches unused variables, unreachable code, type mismatches, and security vulnerabilities. Linters enforce *correctness*.
- **Formatting** concerns code presentation — indentation, line length, quote style, trailing commas. Formatters enforce *consistency*.

These tools are complementary. ESLint catches the bug. Prettier makes the fix look uniform. Both run in your editor and CI pipeline.

### How Quality Tools Reduce Bugs and Review Time

Automated quality tools reduce pull request review time by eliminating style debates. When Prettier handles formatting, reviewers focus on logic and architecture. When ESLint catches common mistakes, fewer bugs reach human review. A well-configured tool suite catches 30-50% of issues that would otherwise require manual review.

## JavaScript/TypeScript: ESLint Deep Dive

### What Is ESLint and How It Works

[ESLint](https://eslint.org) is a static analysis tool for JavaScript and TypeScript. It parses your code into an abstract syntax tree (AST), then applies rules that detect patterns ranging from stylistic preferences to potential runtime errors. With over 300 built-in rules and thousands of third-party rules, ESLint is the most configurable linter in any language ecosystem.

### Setting Up ESLint 9 (Flat Config)

ESLint 9, released in April 2024, introduced the flat config format (`eslint.config.js`) which replaces the legacy `.eslintrc` files. Flat config is more explicit, easier to debug, and supports JavaScript configuration natively.

Install ESLint 9:

```bash
npm install --save-dev eslint @eslint/js
```

Create `eslint.config.js`:

```javascript
import js from '@eslint/js';

export default [
  js.configs.recommended,
  {
    files: ['**/*.js', '**/*.jsx'],
    languageOptions: {
      ecmaVersion: 2024,
      sourceType: 'module',
      globals: {
        console: 'readonly',
        process: 'readonly',
      },
    },
    rules: {
      'no-unused-vars': 'error',
      'no-console': 'warn',
      'eqeqeq': 'error',
    },
  },
];
```

Run ESLint:

```bash
npx eslint .
```

### Recommended Rules and Configurations

Start with `js.configs.recommended` and add rules incrementally. Common additions include:

| Rule | Purpose | Severity |
|------|---------|----------|
| `no-unused-vars` | Catch declared but unused variables | Error |
| `no-undef` | Catch undeclared variables | Error |
| `eqeqeq` | Require strict equality (`===`) | Error |
| `curly` | Require braces for all control statements | Warn |
| `no-throw-literal` | Require Error objects for throw | Error |

### Integrating With TypeScript (@typescript-eslint)

For TypeScript projects, add the TypeScript parser and plugin:

```bash
npm install --save-dev typescript-eslint
```

Update `eslint.config.js`:

```javascript
import js from '@eslint/js';
import tseslint from 'typescript-eslint';

export default [
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    files: ['**/*.ts', '**/*.tsx'],
    languageOptions: {
      parser: tseslint.parser,
      parserOptions: {
        project: './tsconfig.json',
      },
    },
  },
];
```

### Popular Shareable Configs: Airbnb, Standard, XO

Several organizations publish shareable ESLint configurations:

- **Airbnb** (`eslint-config-airbnb`) — The most popular preset, enforcing 400+ rules. Comprehensive but strict.
- **Standard** (`eslint-config-standard`) — Enforces the JavaScript Standard Style. No semicolons, 2-space indentation.
- **XO** (`eslint-config-xo`) — Opinionated with sensible defaults. Good middle ground between Airbnb and minimal.

### ESLint Stylistic for Formatting Rules

ESLint Stylistic (`@stylistic/eslint-plugin`) provides formatting rules extracted from the core ESLint project. Use it for projects that want linting and basic formatting in a single tool:

```javascript
import stylistic from '@stylistic/eslint-plugin';

export default [
  {
    plugins: {
      '@stylistic': stylistic,
    },
    rules: {
      '@stylistic/indent': ['error', 2],
      '@stylistic/quotes': ['error', 'single'],
      '@stylistic/semi': ['error', 'always'],
    },
  },
];
```

## JavaScript/TypeScript: Prettier Setup

### What Is Prettier: Opinionated Code Formatter

[Prettier](https://prettier.io) is an opinionated code formatter that supports JavaScript, TypeScript, JSON, CSS, HTML, Markdown, and more. It removes all formatting decisions from developers by enforcing a single consistent style. Unlike configurable formatters, Prettier intentionally limits options to prevent bikeshedding.

### Installing and Configuring .prettierrc

Install Prettier:

```bash
npm install --save-dev --save-exact prettier
```

Create `.prettierrc`:

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100
}
```

Create `.prettierignore`:

```
node_modules
dist
build
coverage
*.min.js
```

### Prettier vs ESLint: Complementary, Not Competing

ESLint and Prettier have overlapping territory — both can enforce formatting. The recommended approach is:

- **ESLint** handles code quality rules (correctness, best practices)
- **Prettier** handles formatting rules (indentation, quotes, line breaks)

Use `eslint-config-prettier` to disable ESLint rules that conflict with Prettier:

```bash
npm install --save-dev eslint-config-prettier
```

Add to `eslint.config.js`:

```javascript
import prettier from 'eslint-config-prettier';

export default [
  // ... other configs
  prettier,
];
```

### Editor Integration (VS Code, Vim, JetBrains)

Install the Prettier extension for your editor and enable "Format on Save." In VS Code, add to `settings.json`:

```json
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true
}
```

## ESLint + Prettier: Complete Integration

### Step-by-Step Setup for New Projects

1. Install dependencies:

```bash
npm install --save-dev eslint prettier eslint-config-prettier typescript-eslint
```

2. Create `eslint.config.js`:

```javascript
import js from '@eslint/js';
import tseslint from 'typescript-eslint';
import prettier from 'eslint-config-prettier';

export default [
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    files: ['**/*.ts', '**/*.tsx'],
    languageOptions: {
      parser: tseslint.parser,
    },
    rules: {
      '@typescript-eslint/no-unused-vars': 'error',
      '@typescript-eslint/explicit-function-return-type': 'warn',
    },
  },
  prettier,
];
```

3. Create `.prettierrc` with your formatting preferences.

4. Add package.json scripts:

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

### Migrating From ESLint Legacy Config to Flat Config

To migrate from `.eslintrc.json` to `eslint.config.js`:

1. Run `npx @eslint/migrate-config .eslintrc.json` to generate a starter flat config
2. Review and adjust the generated file
3. Rename or delete `.eslintrc.json`
4. Test with `npx eslint .`

### CI/CD Integration for Automated Checks

Add a GitHub Actions workflow:

```yaml
name: Code Quality
on: [pull_request]
jobs:
  lint-and-format:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run format:check
```

## Python: Black — The Uncompromising Formatter

### Philosophy: One Way to Format Python

[Black](https://black.readthedocs.io) is Python's most popular code formatter. Its philosophy is simple: there is one correct way to format Python code, and Black decides what that is. With only a handful of configurable options, Black eliminates all formatting debates.

### Installation and Basic Usage

```bash
pip install black
black .
```

Black formats all Python files in place. Use `black --check .` in CI to verify formatting without modifying files.

### pyproject.toml Configuration

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

### Black With Jupyter Notebooks

Black supports Jupyter notebooks via the `black[jupyter]` extra:

```bash
pip install "black[jupyter]"
black notebook.ipynb
```

### Limitations and When to Use Alternatives

Black's strictness is its strength and weakness. It will not format docstrings (use `docformatter`), sort imports (use `isort` or `ruff`), or handle specific team conventions. For teams needing more flexibility, Ruff's formatter provides Black-compatible output with additional options.

## Python: Ruff — The Ultra-Fast All-in-One Linter

### Why Ruff Is Replacing Flake8, Pylint, and isort

[Ruff](https://docs.astral.sh/ruff), developed by Astral, is a Rust-based Python linter and formatter that replaces an entire toolchain. One tool handles linting (Flake8 + plugins), formatting (Black-compatible), import sorting (isort), and more. As of early 2025, Ruff implements over 800 lint rules and is actively adding new ones.

The consolidation argument alone is compelling. Instead of configuring Flake8, Black, isort, pydocstyle, pyupgrade, and autoflake separately, you configure one tool.

### 10-100x Faster Than Alternatives

Ruff's Rust implementation delivers extraordinary performance. Benchmarks on a typical Django codebase show:

| Tool | Time | Files/sec |
|------|------|-----------|
| Flake8 | 12.4s | 180 |
| Pylint | 45.2s | 49 |
| Ruff | 0.3s | 7,400 |

This speed enables running Ruff on every file save without noticeable delay. It also makes pre-commit hooks and CI checks significantly faster.

### Replacing Black With Ruff Format

Ruff's formatter produces Black-compatible output in most cases. To switch:

```bash
pip install ruff
ruff format .       # Replaces black .
ruff check .        # Replaces flake8
ruff check --fix .  # Auto-fix issues
```

### Complete pyproject.toml Configuration

```toml
[tool.ruff]
target-version = "py311"
line-length = 88

[tool.ruff.lint]
select = [
    "E",   # pycodestyle errors
    "F",   # Pyflakes
    "I",   # isort
    "N",   # pep8-naming
    "W",   # pycodestyle warnings
    "UP",  # pyupgrade
    "B",   # flake8-bugbear
    "C4",  # flake8-comprehensions
    "SIM", # flake8-simplify
]
ignore = ["E501"]  # Line too long (handled by formatter)

[tool.ruff.lint.pydocstyle]
convention = "google"

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
```

### Migration Guide From Flake8/Black to Ruff

1. Remove Flake8, Black, isort, and related plugins from your dependencies
2. Install Ruff: `pip install ruff`
3. Convert `.flake8` and `pyproject.toml` Black config to Ruff equivalents
4. Run `ruff check .` and address any new violations Ruff detects
5. Update pre-commit hooks and CI pipelines
6. Run `ruff format .` to verify formatting matches expectations

## Go: gofmt and golangci-lint

### Built-In Formatting With gofmt

Go includes `gofmt` in the standard toolchain. Every Go installation has it. Unlike other languages where formatting tools are third-party additions, Go treats formatting as a language feature. The Go proverb is explicit: "Gofmt's style is no one's favorite, yet gofmt is everyone's favorite."

Format Go code:

```bash
gofmt -w .
```

Most Go editors run gofmt on save by default.

### golangci-lint for Comprehensive Linting

While gofmt handles formatting, linting requires [golangci-lint](https://golangci-lint.run), a meta-linter that runs 30+ individual linters in parallel:

```bash
golangci-lint run
```

Create `.golangci.yml`:

```yaml
linters:
  enable:
    - errcheck
    - gosimple
    - govet
    - ineffassign
    - staticcheck
    - unused
    - gocritic
    - gosec
```

### Configuration and CI Integration

Add to GitHub Actions:

```yaml
- name: golangci-lint
  uses: golangci/golangci-lint-action@v6
  with:
    version: latest
```

## Rust: rustfmt and Clippy

### rustfmt for Consistent Formatting

Rust's official formatter, `rustfmt`, is installed with Rustup:

```bash
rustfmt src/**/*.rs
```

Configure in `rustfmt.toml`:

```toml
max_width = 100
tab_spaces = 4
edition = "2021"
```

### Clippy Linting and Code Suggestions

[Clippy](https://doc.rust-lang.org/clippy) is Rust's linter with over 650 lints ranging from style suggestions to performance improvements and bug detection:

```bash
cargo clippy
```

Enable all lints for maximum checking:

```bash
cargo clippy -- -W clippy::all -W clippy::pedantic
```

### Cargo Integration

Both `rustfmt` and `clippy` integrate directly with Cargo. Add aliases to `.cargo/config.toml`:

```toml
[alias]
lint = "clippy -- -W clippy::all"
checkfmt = "fmt -- --check"
```

## Pre-Commit Hooks: Automating Code Quality

### Introduction to Pre-Commit Framework

The [pre-commit](https://pre-commit.com) framework manages Git pre-commit hooks across languages. It installs hooks that run automatically before each commit, blocking the commit if checks fail. This catches issues before they enter the repository.

Install pre-commit:

```bash
pip install pre-commit
pre-commit install
```

### Setting Up .pre-commit-config.yaml

Create `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-merge-conflict

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.6.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  - repo: https://github.com/pre-commit/mirrors-eslint
    rev: v9.0.0
    hooks:
      - id: eslint
        additional_dependencies:
          - eslint@9.0.0
          - eslint-config-prettier

  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: v4.0.0-alpha.8
    hooks:
      - id: prettier
```

Run against all files:

```bash
pre-commit run --all-files
```

### Popular Hooks: Trailing Whitespace, End-of-File Fixer

The `pre-commit-hooks` repository provides language-agnostic checks that every project should use:

- `trailing-whitespace` — Removes trailing whitespace
- `end-of-file-fixer` — Ensures files end with exactly one newline
- `check-yaml` — Validates YAML syntax
- `check-added-large-files` — Prevents committing files over a size threshold
- `check-merge-conflict` — Blocks commits with unresolved merge conflict markers

### Custom Hooks for Project-Specific Needs

You can define custom hooks for project-specific checks:

```yaml
repos:
  - repo: local
    hooks:
      - id: run-tests
        name: Run unit tests
        entry: pytest tests/
        language: system
        types: [python]
        pass_filenames: false
        always_run: true
```

### Husky for JavaScript/TypeScript Projects

[Husky](https://github.com/typicode/husky) simplifies Git hooks for JavaScript projects. Install and configure:

```bash
npx husky-init && npm install
```

Edit `.husky/pre-commit`:

```bash
npm run lint
npm run format:check
npm test
```

## CI/CD Integration for Code Quality

### GitHub Actions Workflow for Linting

A comprehensive quality workflow:

```yaml
name: Quality Checks
on: [pull_request, push]
jobs:
  javascript:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run format:check

  python:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      - run: pip install ruff
      - run: ruff check .
      - run: ruff format --check .
```

### GitLab CI Pipeline for Formatting Checks

```yaml
stages:
  - quality

lint-js:
  stage: quality
  image: node:20
  script:
    - npm ci
    - npm run lint
    - npm run format:check

lint-python:
  stage: quality
  image: python:3.12
  script:
    - pip install ruff
    - ruff check .
    - ruff format --check .
```

### Failing Builds on Lint Errors

Configure your CI to fail on lint errors. Set the exit code of your lint command to non-zero when violations are found — all the tools in this guide do this by default. A red build status prevents merging code that violates quality standards.

### Reporting Lint Results as PR Comments

Tools like [reviewdog](https://github.com/reviewdog/reviewdog) post lint results as pull request comments. This puts feedback exactly where developers need it — in the review interface — rather than buried in CI logs. Reviewdog supports ESLint, Ruff, golangci-lint, and dozens of other tools.

## Language Comparison Table

| Language | Formatter | Linter | Pre-Commit Hook | Config File |
|----------|-----------|--------|-----------------|-------------|
| JavaScript/TypeScript | Prettier | ESLint 9 | `mirrors-prettier`, `mirrors-eslint` | `eslint.config.js`, `.prettierrc` |
| Python | Ruff format | Ruff | `ruff-pre-commit` | `pyproject.toml` |
| Go | gofmt | golangci-lint | Custom (local) | `.golangci.yml` |
| Rust | rustfmt | Clippy | Custom (cargo) | `rustfmt.toml` |
| Multi-language | — | — | `pre-commit-hooks` | `.pre-commit-config.yaml` |

## Conclusion

Code quality tools are force multipliers for development teams. A well-configured toolchain catches bugs, enforces consistency, and eliminates style debates — all without ongoing manual effort. Start with one language, configure the formatter and linter, add pre-commit hooks, then expand to CI/CD integration. Within a week, your codebase will be more consistent, your reviews more focused, and your developers more productive.

The tools covered in this guide — ESLint 9 with flat config, Prettier, Ruff replacing the entire Python toolchain, golangci-lint, and Clippy — represent the state of the art in 2025. Invest the time to set them up correctly. The return on that investment compounds with every commit.

## Frequently Asked Questions

### Should I use ESLint and Prettier together?

Yes. ESLint handles code quality (correctness, best practices) while Prettier handles formatting (indentation, line breaks, quotes). They are complementary. Use `eslint-config-prettier` to disable ESLint's formatting rules and prevent conflicts. Configure your editor to run both on save.

### Is Ruff better than Black for Python?

Ruff is faster and more comprehensive than Black. It replaces Black (formatting), Flake8 (linting), isort (import sorting), and numerous plugins in a single tool. Ruff's formatter produces Black-compatible output. For new projects, Ruff is the recommended choice. For existing Black users, switching to Ruff format is straightforward and yields significant performance improvements.

### How do I set up pre-commit hooks?

Install the pre-commit framework: `pip install pre-commit`. Create a `.pre-commit-config.yaml` file with your hooks. Run `pre-commit install` to activate the hooks in your Git repository. Run `pre-commit run --all-files` to test the configuration against existing files. For JavaScript projects, Husky provides a simpler alternative.

### Can I use one tool for multiple programming languages?

Prettier handles JavaScript, TypeScript, JSON, CSS, HTML, Markdown, YAML, and more. Ruff handles Python exclusively. ESLint focuses on JavaScript/TypeScript with some JSON support. For multi-language projects, configure the pre-commit framework to run the appropriate tool for each file type. No single tool covers all languages well — use the best tool for each language.

### How do I enforce code quality in CI/CD pipelines?

Add lint and format check steps to your CI pipeline. Use exit codes to fail the build when violations are found. For GitHub Actions, the `pull_request` trigger runs checks on every PR. Combine with branch protection rules that require status checks to pass before merging. Tools like reviewdog can post results as PR comments for better visibility.

---

## Recommended Infrastructure

To run any of the tools above reliably 24/7, infrastructure matters:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit, 14+ global regions, one-click droplets for AI/dev workloads.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low latency for mainland China access. This is the same IDC hosting dibi8.com — production-proven.

*Affiliate links — no extra cost to you, helps keep dibi8.com running.*

