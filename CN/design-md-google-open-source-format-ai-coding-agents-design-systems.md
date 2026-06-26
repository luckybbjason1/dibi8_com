---
title: "DESIGN.md: Google's Open-Source Format for Giving AI Coding Agents a Design System"
description: 'DESIGN.md by Google Labs Code is an open-source format specification for describing visual identity to AI coding agents. 20.8k GitHub stars. Learn how it bridges design systems and AI code generation with YAML tokens and prose-based constraints.'
tags: ["guide", "open-source", "ai-agents", "design-systems", "reference", "google"]
date: 2026-06-27
slug: 'design-md-google-open-source-format-ai-coding-agents-design-systems'
category: dev-utils
github_repo: 'https://github.com/google-labs-code/design.md'
license: Apache-2.0
lang: en
featureImage: /images/articles/design-md-format-specification-for-ai-coding-agents.png
---

![DESIGN.md Format Specification](https://opengraph.github.com/github/google-labs-code/design.md)

![DESIGN.md Philosophy Document](https://raw.githubusercontent.com/google-labs-code/design.md/main/PHILOSOPHY.md)

## Introduction

When you ask an AI coding agent to build a landing page, it produces something functional — but rarely beautiful. The problem isn't the model's capability; it's the lack of a shared design language. Every prompt starts from scratch, every generation drifts from the last, and there's no persistent memory of what "our design" actually looks like.

**DESIGN.md** by Google Labs Code solves this. It's an open-source format specification that gives AI coding agents a persistent, structured understanding of your design system — combining YAML color tokens, typography specs, and spacing rules with natural language prose that describes the *intent* behind every value. With 20,800+ GitHub stars and 2,319 stars gained in a single day, it's currently the hottest design tool on GitHub.

## What Is DESIGN.md?

DESIGN.md is a markdown file that serves as the single source of truth for a project's visual identity. It's designed to be read by AI coding agents (Claude, ChatGPT, Codex, Cursor, etc.) so they can generate UI that consistently matches your brand — without you having to re-explain your design system every time.

The format has two complementary layers:

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

The YAML tokens provide machine-readable values. The prose provides human-readable *context* — explaining why a color is `#F4F0E4` (warmed xerox stock, never pure white) rather than just stating the hex code. This distinction is what makes DESIGN.md fundamentally different from a design token JSON file.

## Why Prose Matters More Than Tokens

The designers behind DESIGN.md made a deliberate choice: **the prose is the most vital part of the specification**. Their philosophy document explains it perfectly:

> *"A design that references 'A 1970s graduate lecture handout in the tradition of an old and established university' evokes a complete world: the one color of ink, the generous margins, the serif set at a reading size, and the absence of decoration. That single sentence carries more useful information than a dozen metric values."*

This is a profound insight about AI-assisted development. When you tell an LLM "use a warm, premium editorial aesthetic," it generates something generic. When you tell it "a 1970s graduate lecture handout," it understands the entire cultural reference — the paper texture, the restrained typography, the absence of decorative elements. The model fills in all the gaps from its training data.

DESIGN.md formalizes this principle. The tokens are context, not instructions. The prose carries the creative intent. Together, they give agents both precision and imagination.

## How It Works Under the Hood

The DESIGN.md repository is structured as a Bun monorepo with Turbo for orchestration:

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

The CLI tool (`@google/design.md`) provides:
- **Linting**: Validates DESIGN.md files against the specification schema
- **Token extraction**: Parses YAML blocks into structured data
- **Agent integration**: Ships as an `.agents/skills/` definition for Claude, ChatGPT, and other coding agents

The linter enforces that required sections (name, colors, typography, spacing, rounded, components) are present while allowing arbitrary custom sections for motion, iconography, elevation, and other design dimensions specific to each project.

## Getting Started

### 1. Install the CLI

```bash
bun install -g @google/design.md
```

Or use it directly with npx:

```bash
npx @google/design.md lint DESIGN.md
```

### 2. Create Your First DESIGN.md

Start with the minimal required structure:

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
