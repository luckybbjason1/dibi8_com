---
title: "DESIGN.md：谷歌用于为 AI 编码代理提供设计系统的开源格式"
description: 'DESIGN.md 由 Google Labs Code 提供，是一种开源格式规范，用于向 AI 编码代理描述视觉识别。拥有 20.8k 个 GitHub 星标。了解它如何通过 YAML 令牌和基于文本的约束桥接设计系统与 AI 代码生成。'
tags: ["guide", "open-source", "ai-agents", "design-systems", "reference", "google"]
date: 2026-06-27
slug: 'design-md-google-open-source-format-ai-coding-agents-design-systems'
category: dev-utils
github_repo: 'https://github.com/google-labs-code/design.md'
license: Apache-2.0
lang: zh
featureImage: /images/articles/design-md-format-specification-for-ai-coding-agents.png
---

![DESIGN.md Format Specification](https://opengraph.github.com/github/google-labs-code/design.md)

![DESIGN.md Philosophy Document](https://raw.githubusercontent.com/google-labs-code/design.md/main/PHILOSOPHY.md)

## 引言

当你要求一个 AI 编程代理构建一个登录页面时，它会生成一些可用的东西——但很少美观。问题不在于模型的能力，而在于缺乏共同的设计语言。每个提示都是从零开始，每次生成都会偏离上一次，而且没有对“我们的设计”实际样子持续的记忆。

**DESIGN.md** 由 Google Labs Code 解决了这个问题。它是一个开源的格式规范，为 AI 编码代理提供对你的设计系统的持久、结构化理解——将 YAML 颜色标记、排版规范和间距规则，与描述每个数值背后*意图*的自然语言内容结合起来。凭借超过 20,800 个 GitHub 星标以及单日新增 2,319 个星标，它目前是 GitHub 上最热门的设计工具。

## 什么是 DESIGN.md？

DESIGN.md 是一个 Markdown 文件，作为项目视觉识别的唯一真实来源。它的设计是为了让 AI 编码代理（Claude、ChatGPT、Codex、Cursor 等）阅读，以便它们生成与您的品牌一致的 UI —— 无需每次都重新解释您的设计系统。

该格式有两个互补的层次：

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

YAML 令牌提供可被机器读取的数值。散文提供可被人类理解的*上下文*——解释为什么一个颜色是 `#F4F0E4`（暖色复印纸，从不纯白），而不仅仅是说明十六进制代码。这种区别正是使 DESIGN.md 与设计令牌 JSON 文件根本不同的原因。

## 为什么散文比代币更重要

DESIGN.md 背后的设计师做出了一个深思熟虑的选择：**文字部分是规范中最重要的部分**。他们的理念文档对此解释得非常清楚：

"> *“一个引用‘1970年代老牌大学毕业讲座讲义风格’的设计唤起了一个完整的世界：单色墨水、宽裕的页边距、以可阅读大小排版的衬线字体，以及没有装饰的设计。仅这一句话就包含的信息，比一打指标数值更有用。”*

这是关于人工智能辅助开发的深刻见解。当你告诉一个大型语言模型“使用温暖、高端的编辑美学”时，它会生成一些普通内容。而当你告诉它“一个1970年代的毕业讲座讲义”时，它会理解整个文化背景——纸张质感、克制的排版、缺乏装饰元素。模型会从它的训练数据中填补所有空白。

DESIGN.md 将这一原则形式化。令牌是上下文，而不是指令。文本承载了创意意图。两者结合，为代理提供了精确性与想象力。

## 背后的工作原理

DESIGN.md 仓库被构建为一个使用 Turbo 进行编排的 Bun 单体仓库：

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

CLI 工具（`@google/design.md`）提供：
- **Linting（代码检查）**：根据规范模式验证 DESIGN.md 文件
- **令牌提取**：将 YAML 块解析为结构化数据
- **代理整合**：作为 Claude、ChatGPT 和其他编程代理的 `.agents/skills/` 定义提供

该代码检查器强制要求存在必需的部分（名称、颜色、排版、间距、圆角、组件），同时允许为运动、图标、层次以及每个项目特定的其他设计维度添加任意自定义部分。

## 入门

### 1. 安装 CLI

```bash
bun install -g @google/design.md
```

或者直接使用 npx：

```bash
npx @google/design.md lint DESIGN.md
```

### 2. 创建你的第一个 DESIGN.md

从最基本的必要结构开始：

```markdown
---
name: My Project Design
---

## Colors

```yaml
colors:
  primary: '#2563EB'
  background: '#FFFFFF'
  text: '#111827'
```

A clean blue-and-white system for a professional SaaS product.

## Typography

```yaml
typography:
  heading: 'Inter'
  body: 'Inter'
  mono: 'JetBrains Mono'
```

Single-family typography system for consistency.

## Spacing

```yaml
spacing:
  unit: 4px
  scale: [4, 8, 16, 24, 32, 48, 64]
```

4px base grid, 8px for larger elements.
```

### 3. Ship It to Your Coding Agents

Add DESIGN.md to your project repository. When working with any coding agent, reference the file in your system prompt:

```
System: Read the DESIGN.md file in the project root.
All UI components must follow the design specifications defined there.
```

The agent will now consistently apply your design system across every generation.

## Real-World Examples

The repository includes several example DESIGN.md files demonstrating different aesthetic approaches:

**Graduate Lecture Handout**: A warm paper canvas with single-ink typography and vermilion accents limited to diagrams. The prose specifies "A graduate-level computer science lecture handout in the tradition of an old established university" — instantly communicating margins, serif fonts, and restraint.

**Motion Design System**: Defines timing constants for UI feedback (120ms for hover/press, 250ms for content transitions) with a mechanical easing curve. The prose emphasizes "Nothing bounces, nothing overshoots, nothing lingers" — giving agents a clear temporal aesthetic.

**Custom Design Dimensions**: The format accepts any section name. One team defines `motion` tokens as CSS animation curves; another uses audio-domain time constants measured in buffer blocks. The spec standardizes where consistency helps and leaves flexibility where it matters more.

## Why This Matters for AI-Assisted Development

DESIGN.md addresses a fundamental bottleneck in AI-assisted development: **design consistency at scale**.

Without a design specification, every AI-generated page, component, or screen is a fresh creative exercise. The agent doesn't know your brand colors beyond what's in the prompt, doesn't understand your spacing philosophy, and has no memory of what "done" looks like for your project.

With DESIGN.md:
- **Agents have persistent design memory** — the file lives in your repo, version-controlled and reviewed
- **Multiple agents stay consistent** — Claude, ChatGPT, and Codex all read the same file
- **Design reviews become automated** — the linter catches violations before they reach production
- **New developers onboard instantly** — the file *is* the design system documentation

The format is particularly powerful for teams using multiple AI coding tools. Instead of each tool having its own implicit understanding of your design, everyone reads the same authoritative source.

## Limitations and Trade-offs

DESIGN.md is not a silver bullet. Several considerations:

1. **Agent-dependent quality**: The effectiveness depends on how well each agent reads and follows the prose. Some agents may parse the YAML but ignore the narrative descriptions.

2. **No visual rendering**: DESIGN.md is a specification, not a rendering engine. You still need the agent (or a human designer) to translate the specs into actual code.

3. **Learning curve**: Writing good prose descriptions requires design thinking. Teams without a designated designer may struggle to articulate their aesthetic intent clearly.

4. **Not a replacement for Figma**: DESIGN.md complements design tools rather than replacing them. The ideal workflow uses Figma for visual design and DESIGN.md for agent communication.

5. **Still young**: At 20.8k stars and 2 months old, the format is evolving rapidly. Breaking changes between versions are possible.

## Community and Adoption

DESIGN.md is developed by Google Labs Code and has attracted significant attention:

- **20,800+ stars** on GitHub (2,319 gained in a single day)
- **1,700+ forks** with active community contributions
- **40+ commits** in 2 months with rapid iteration
- **18 issues** and **17 pull requests** showing active development
- **4 published tags** with semantic versioning

The format has inspired derivative projects and integrations across the AI coding agent ecosystem. Multiple agent skill definitions have emerged, and the `.agents/skills/` directory provides ready-to-use configurations for popular coding agents.

## Conclusion

DESIGN.md represents a fundamental shift in how we communicate design to AI. Rather than trying to encode every visual decision into rigid tokens, it embraces the strength of natural language — letting prose carry the creative intent while YAML provides the machine-readable scaffolding.

For teams building AI-assisted design workflows, it's worth trying. Create a DESIGN.md for your next project, add it to your coding agent's context, and see how much more consistent your generated UI becomes. The format is simple enough to start with today and flexible enough to grow with your design system.

In a landscape where every developer now has access to AI coding agents, DESIGN.md provides the missing piece: a shared language between human design intent and machine execution. That's why it's currently the hottest project on GitHub — and why it's likely to become a standard practice in AI-assisted development.

For teams deploying infrastructure at scale: try [HTStack](https://www.htstack.com/) for high-performance cloud hosting that integrates seamlessly with design system workflows.

For production-ready AI coding workflows: check out [Binance](https://bsmkweb.cc) for enterprise-grade API trading infrastructure.

For financial AI applications: [OKX](https://promoohubly.com) offers robust trading APIs and market data feeds.

Check out internal guides on AI Coding Agent Comparison and Developer Tooling Best Practices for deeper dives into building a complete AI-assisted development workflow.

Join the DIBI8 community on [Telegram](https://t.me/DIBI8_Group) for daily discussions on AI tools, dev utilities, and open-source projects.

---

**Sources & Further Reading**:
- Official repository: https://github.com/google-labs-code/design.md
- DESIGN.md philosophy: https://github.com/google-labs-code/design.md/blob/main/PHILOSOPHY.md
- CLI toolkit: https://github.com/google-labs-code/design.md/tree/main/packages/cli
- Example DESIGN.md files: https://github.com/google-labs-code/design.md/tree/main/examples
- Agent skill definitions: https://github.com/google-labs-code/design.md/tree/main/.agents/skills
- Contributing guidelines: https://github.com/google-labs-code/design.md/blob/main/CONTRIBUTING.md

**Disclosure**: This article contains affiliate links. If you sign up through our links, we may earn a small commission at no additional cost to you. This helps support independent tech journalism and keeps resources like dibi8.com free and ad-free.
