---


title: "Install all skills at once"
description: "Taste Skill gives your AI agent a design brain"
date: 2026-09-20
slug: "taste-skill"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---



## TL;DR

Taste Skill gives your AI agent a design brain. Instead of generating the same generic, centered, boring UI that every AI tool produces, it enforces stronger layout variance, intentional motion, and premium visual density. It ships as portable SKILL.md files that work with Codex, Cursor, Claude Code, and ChatGPT Images.

**TL;DR: 44,229 stars** — the most-starred anti-slop skill on GitHub.

## What Is Taste Skill?

Taste Skill is a collection of portable agent skills designed to upgrade AI-generated frontend output. Each skill does one job: enforce specific design rules, generate reference images, or apply a particular visual style. The framework is **not tied to any single coding agent or framework** — it works across React, Vue, Svelte, and static HTML.

The core insight is simple: AI models are trained on the same internet, so they generate the same layouts. Taste Skill breaks this by providing explicit design constraints that force variance. Three adjustable dials control the output: - **DESIGN_VARIANCE (1-10):** Layout experimentation — lower for centered/clean, higher for asymmetric/modern
- **MOTION_INTENSITY (1-10):** Animation depth — lower for hover effects, higher for scroll/magnetic animations
- **VISUAL_DENSITY (1-10):** Information per viewport — lower for spacious layouts, higher for dense dashboards

````bash
# Install all skills at once
npx skills add https://github.com/Leonxlnx/taste-skill

# Install a single skill by name
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"

# Pin to v1 (original behavior)
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend-v1"
`````

The default skill is now **v2 (experimental)**, a substantial rewrite of the original. It includes brief inference, design-system mapping, hard em-dash bans, canonical GSAP code skeletons, and a redesign-audit protocol.

## How Taste Skill Works

Taste Skill operates through a three-layer architecture: 1. **Implementation Skills** — These output production-ready code. The flagship ````design-taste-frontend```` skill reads your project brief, infers a design language, tunes the three dials, and generates code with strict anti-repetition rules.

2. **Image Generation Skills** — These produce reference boards (not code). ````imagegen-frontend-web```` generates website comps, ````imagegen-frontend-mobile```` creates mobile flows, and ````brandkit```` produces identity boards. Feed these to Codex or ChatGPT Images for implementation.

3. **Style Variants** — Specific visual directions: ````minimalist-ui```` (Notion/Linear vibes), ````industrial-brutalist-ui```` (Swiss type, sharp contrast), ````high-end-visual-design```` (polished, calm, expensive UI), and ````stitch-design-taste```` (Google Stitch-compatible).

`````bash
# Image-first pipeline: generate references, then code
npx skills add https://github.com/Leonxlnx/taste-skill --skill "image-to-code"

# Prompt example for image-to-code workflow
# "follow the skill: generate images, then analyze, then code"
`````

The image-first pipeline is particularly powerful: generate reference boards with ChatGPT Images or Codex image mode, then pass the renders to your coding agent with the ````image-to-code```` skill for implementation.

## Installation & Setup

Installation takes less than 30 seconds. Taste Skill uses the Vercel Labs ````npx skills```` CLI, which scans the repo's ````skills/```` folder and installs SKILL.md files into your project.

`````bash
# Step 1: Install all skills
npx skills add https://github.com/Leonxlnx/taste-skill

# Step 2: Verify installation
ls ~/.hermes/skills/ | grep taste

# Step 3: Use in your agent conversation
# The skill is automatically loaded when referenced
`````

### Updating to v2

If you have v1 installed and want the experimental v2: `````bash
# Re-run install — the install name didn't change
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"

# Check changelog for v1→v2 differences
curl -sL https://raw.githubusercontent.com/Leonxlnx/taste-skill/main/CHANGELOG.md | head -50
`````

### Manual Installation

You can also copy any SKILL.md directly into your project or paste it into ChatGPT/Codex conversations: `````bash
# Clone for manual access
curl -sL "https://github.com/Leonxlnx/taste-skill/archive/refs/heads/main.zip" -o /tmp/taste-skill.zip
unzip -q /tmp/taste-skill.zip -d /tmp
ls /tmp/taste-skill-main/skills/
`````

### Listing Available Skills

After installation, see what skills are available: `````bash
# List all installed skills
npx skills list | grep taste

# Check the skill version
grep '^version:' ~/.hermes/skills/design-taste-frontend/SKILL.md 2>/dev/null || \
  grep '^version:' ~/.claude/skills/taste-skill/SKILL.md 2>/dev/null || \
  echo "Skill installed via paste (no version file)"

# Read the v2 changelog
curl -sL "https://raw.githubusercontent.com/Leonxlnx/taste-skill/main/CHANGELOG.md" | head -30
`````

## Integration with Major Coding Agents

Taste Skill is framework-agnostic and works with every major AI coding agent: | Agent | Integration Method | Best Skill |
|
* * *
|
* * *
|
* * *
|
| **Codex** | ````npx skills add```` + CLI | ````gpt-taste```` (stricter variant) |
| **Cursor** | Paste SKILL.md into ````.cursorrules```` | ````design-taste-frontend```` |
| **Claude Code** | Load via ````.claude/skills/```` | ````design-taste-frontend```` |
| **ChatGPT** | Paste SKILL.md into conversation | ````imagegen-frontend-web```` |
| **Gemini** | Paste SKILL.md into conversation | ````design-taste-frontend```` |
| **OpenCode** | Load SKILL.md | ````redesign-existing-projects```` |

`````bash
# Cursor integration: add to .cursorrules
cat >> .cursorrules << 'EOF'
# Taste Skill v2 — Anti-slop frontend rules
# Load skill: design-taste-frontend
# Dials: DESIGN_VARIANCE=7, MOTION_INTENSITY=5, VISUAL_DENSITY=4
EOF

# Claude Code integration
mkdir -p ~/.claude/skills/taste-skill
curl -sL "https://raw.githubusercontent.com/Leonxlnx/taste-skill/main/skills/design-taste-frontend/SKILL.md" \
  > ~/.claude/skills/taste-skill/SKILL.md
`````

## Benchmarks: Taste Skill vs Generic AI Output

The difference between a Taste Skill-generated interface and a generic AI output is measurable across several dimensions: `````
Metric              | Generic AI | Taste Skill v2

* * *
|
* * *
|