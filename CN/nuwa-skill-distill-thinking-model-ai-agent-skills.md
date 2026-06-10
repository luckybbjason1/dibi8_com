---
title: 'Nuwa-Skill: Distill Any Person Thinking Model into AI Agent Skill — 23,000 Stars — Guide 2026'
description: 'Nuwa-Skill (23,508 GitHub stars) distills thinking models of historical figures, experts, and influencers into reusable AI Agent Skills. Compatible with Claude Code, Codex, Cursor, Hermes, and 50+ runtimes. Install via npx skills add.'
date: 2026-06-09
slug: 'nuwa-skill-distill-thinking-model-ai-agent-skills'
category: 'llm-frameworks'
tags: ['nuwa-skill', 'agent skills', 'thinking models', 'COT distillation', 'AI agent framework', 'Claude Code skills', 'Codex skills', 'MCP alternatives', 'agent memory']
github_repo: 'https://github.com/alchaincyf/nuwa-skill'
stars: 23508
maintainer: 'alchaincyf'
license: MIT
featureImage: 'https://raw.githubusercontent.com/alchaincyf/nuwa-skill/main/assets/hero.gif'
lang: en
---

# Nuwa-Skill: Distill Any Person Thinking Model into AI Agent Skill — 23,000 Stars — Guide 2026

```
┌──────────────────────────────────────────────┐
│          Nuwa-Skill Pipeline                   │
│                                                │
│  Input: "Distill Steve Jobs"                   │
│          │                                     │
│          ▼                                     │
│  ┌─────────────────────────┐                   │
│  │  Step 1: Research        │                   │
│  │  - Gather public content │                   │
│  │  - Speeches, interviews, │                   │
│  │    books, tweets         │                   │
│  └─────────┬───────────────┘                   │
│            ▼                                   │
│  ┌─────────────────────────┐                   │
│  │  Step 2: Analyze 5 L4s  │                   │
│  │  1. How they speak      │                   │
│  │  2. How they think      │                   │
│  │  3. How they decide     │                   │
│  │  4. What they avoid     │                   │
│  │  5. Their limitations   │                   │
│  └─────────┬───────────────┘                   │
│            ▼                                   │
│  ┌─────────────────────────┐                   │
│  │  Step 3: Generate SKILL │                   │
│  │  .md with YAML front-   │                   │
│  │  matter + instructions  │                   │
│  └─────────┬───────────────┘                   │
│            ▼                                   │
│  ┌─────────────────────────┐                   │
│  │  Step 4: Deploy to any  │                   │
│  │  Agent Runtime          │                   │
│  │  (50+ compatible)       │                   │
│  └─────────────────────────┘                   │
└──────────────────────────────────────────────┘
```

Nuwa-Skill (女娲) is a groundbreaking AI Agent Skills framework that lets you distill the thinking models of anyone — from Steve Jobs to Warren Buffett to your favorite podcast host — into reusable, deployable agent skills. With 23,500+ GitHub stars, it has become one of the most popular projects in the Agent Skills ecosystem.

The core insight is simple but profound: instead of asking an LLM to "roleplay as X," Nuwa-Skill extracts five deep layers of cognitive operating systems — how they speak, how they think, how they decide, what they avoid, and their honest limitations — and encodes these into structured SKILL.md files that any compatible agent runtime can use.

## What Is Nuwa-Skill?

Nuwa-Skill is built on the open [Agent Skills protocol](https://agentskills.io) and works with 50+ compatible AI agent runtimes including Claude Code, Codex CLI, Cursor, OpenClaw, Hermes Agent, CodeBuddy, Gemini CLI, and OpenCode.

Unlike traditional roleplay prompts that produce superficial imitations, Nuwa-Skill extracts five distinct cognitive layers:

| Layer | What It Captures | Example |
|-------|-----------------|---------|
| **1. Expression DNA** | Tone, rhythm, word choice preferences | Jobs's "insanely great," Naval's parable-heavy style |
| **2. Mental Models** | Cognitive frameworks and thinking patterns | Musk's "first principles," Buffett's "circle of competence" |
| **3. Decision Heuristics** | Rules for making choices under uncertainty | Bezos's "one-way vs. two-way door" |
| **4. Anti-Patterns** | What they actively refuse to do | Jobs's "focus means saying no" |
| **5. Honest Boundaries** | What they explicitly cannot do | Musk's admission: "I don't know about biology" |

This five-layer approach ensures the distillation goes far beyond surface-level mimicry into actual cognitive framework transfer.

### Example Outputs

Here's what distilling Naval Ravikant produces:

```
User      ❯ I want to do self-media, write a book, and build a startup simultaneously

Naval     ❯ You listed three desires. Each desire is a contract you signed with unhappiness.
            It's not that you lack energy — you have too many contracts.

            Ask yourself: which one makes you lose track of time?
            That's where your specific knowledge lives.

            Not pick one of three. First be one, then one, then one.
            Serial compounding, not parallel friction.
```

And Musk on SaaS customer acquisition:

```
User      ❯ Our SaaS customer acquisition cost is too high

Musk      ❯ Don't think about reducing yet. Calculate the physical limit first.
            What's the minimum necessary action for a user to discover and pay for you?
            What's the theoretical shortest path for information transfer?

            Now — how many times longer is your actual path compared to the theoretical minimum?
            If it's more than 3x, there are steps in the middle that should be eliminated.
            Don't optimize the funnel. Question whether the funnel should exist at all.
```

![Nuwa-Skill Hero](https://raw.githubusercontent.com/alchaincyf/nuwa-skill/main/assets/hero.gif)

![Nuwa Distillation Pipeline](https://raw.githubusercontent.com/alchaincyf/nuwa-skill/main/6-agents-parallel.png)

![Nuwa Advisory Board](https://raw.githubusercontent.com/alchaincyf/nuwa-skill/main/advisory-board.png)

## How It Works

The distillation process is fully automated. You provide a name, and Nuwa-Skill handles the research, analysis, generation, and deployment pipeline.

### Step 1: Research Phase

The system gathers public content about the target person: books, speeches, interviews, podcasts, tweets, and articles. This forms the raw material for the five-layer analysis.

### Step 2: Five-Layer Analysis

Each layer is analyzed independently:

```yaml
# Example SKILL.md structure generated by Nuwa
name: "Steve Jobs"
description: "Steve Jobs thinking model — focus, simplicity, reality distortion"
cognitive_layers:
  expression:
    tone: "direct, confident, sometimes abrasive"
    patterns: ["metaphors", "binary framing", "repetition"]
    signature_phrases:
      - "insanely great"
      - "the only way to do great work"
      - "stay hungry, stay foolish"
  mental_models:
    - "connect the dots looking backward"
    - "focus and simplify"
    - "reality distortion field (convince others of possibility)"
    - "端到端控制 (end-to-end control)"
  decision_heuristics:
    - "say no to 1000 things to focus on 3"
    - "people think focus means saying yes to the thing you've got to focus on"
    - "simplicity is the ultimate sophistication"
  anti_patterns:
    - "never compromise on quality for speed"
    - "avoid feature creep"
    - "don't design for committees"
  limitations:
    - "not suited for collaborative team-building contexts"
    - "decisions made with incomplete data"
    - "highly personality-dependent, hard to scale"
```

### Step 3: SKILL.md Generation

The analysis is compiled into a `SKILL.md` file following the Agent Skills protocol specification. This file includes YAML frontmatter with metadata and structured instructions for the agent runtime.

### Step 4: Deployment

The generated skill is deployed to your chosen agent runtime — Claude Code, Codex, Cursor, or any of 50+ compatible platforms.

## Installation & Setup

### Method 1: One-Command Install (Recommended)

Open any compatible agent (Claude Code, Codex, Cursor, OpenClaw, Hermes, CodeBuddy, Workbuddy, Gemini CLI, OpenCode, etc.) and tell it:

```
Help me install this skill: https://github.com/alchaincyf/nuwa-skill
```

The agent will automatically detect your runtime and install the skill to the correct directory.

### Method 2: Universal CLI Installer

Use the [vercel-labs/skills](https://github.com/vercel-labs/skills) universal CLI tool that supports 55+ runtimes:

```bash
# Install Nuwa-Skill to your default runtime
npx skills add alchaincyf/nuwa-skill

# Specify a particular runtime
npx skills add alchaincyf/nuwa-skill -a claude-code
npx skills add alchaincyf/nuwa-skill -a codex
npx skills add alchaincyf/nuwa-skill -a cursor
npx skills add alchaincyf/nuwa-skill -a openclaw
```

### Method 3: Manual Installation

For advanced users who want to customize the installation:

```bash
# Clone to the appropriate runtime's skills directory
git clone https://github.com/alchaincyf/nuwa-skill ~/.claude/skills/nuwa-skill/
git clone https://github.com/alchaincyf/nuwa-skill ~/.codex/skills/nuwa-skill/
git clone https://github.com/alchaincyf/nuwa-skill ~/.cursor/skills/nuwa-skill/
git clone https://github.com/alchaincyf/nuwa-skill ~/.openclaw/workspace/skills/nuwa-skill/
```

Runtime-specific skill directories:

| Runtime | Installation Path |
|---------|------------------|
| Claude Code | `~/.claude/skills/nuwa-skill/` |
| Codex CLI | `~/.codex/skills/nuwa-skill/` |
| Cursor | `~/.cursor/skills/nuwa-skill/` |
| OpenClaw | `~/.openclaw/workspace/skills/nuwa-skill/` |
| Hermes Agent | Run `tools/install_hermes_skill.py` |
| Other runtimes | Clone to their `skills/` directory |

### Method 4: Reference-Only Usage

Even if your runtime doesn't support automatic Agent Skills loading, you can paste the `SKILL.md` content directly into your conversation — it's fundamentally just Markdown with YAML frontmatter.

## Usage

Once installed, you can use Nuwa-Skill with natural language commands:

```
# Create a distillation
> Distill Paul Graham
> Create a Zhang Xiaolong perspective Skill
> Help me make a Daniel Okun (段永平) Skill

# After creation, invoke the distillation
> Analyze this investment decision from Munger's perspective
> How would Feynman explain quantum computing?
> Switch to Naval, I'm纠结 about three things
```

### Creating Custom Distillations

You can create skills for any person by providing their name and optionally additional context:

```yaml
# Example: Custom distillation prompt
> Distill Linus Torvalds
> Context: Focus on his technical decision-making and Linux development philosophy
> Output: Include his anti-patterns (about religious coding and BDFL debates)

> Distill my manager
> Context: She's great at prioritization and stakeholder management
> Output: Capture her email writing patterns and meeting facilitation approach
```

## Integration with Agent Runtimes

### Claude Code

```bash
# After installation, Claude Code automatically loads the skill
# No additional configuration needed
claude
> distill Elon Musk
> use Musk's framework to analyze this product decision
```

### Codex CLI

```bash
# Codex detects and loads the skill automatically
# If not auto-detected, specify explicitly
codex --skill nuwa-skill
> distill Naval Ravikant
> analyze my startup strategy from Naval's perspective
```

### Cursor

```
# In Cursor, the skill appears as a slash command
/distill [person name]

# Or use the skill directly in your conversation
> Switch to the Steve Jobs thinking model
```

### OpenClaw

```bash
# OpenClaw loads skills from its workspace directory
# Nuwa-Skill deploys there automatically
> Create a Jobs distillation
> Apply it to this code review
```

## Benchmarks & Use Cases

### Distillation Quality Comparison

| Aspect | Traditional Roleplay | Nuwa-Skill 5-Layer |
|--------|---------------------|-------------------|
| Tone matching | Good | Excellent |
| Decision framework | Poor | Excellent |
| Limitation awareness | None | Full 5-layer |
| Consistency | Variable | High |
| Adaptability | Low | High (re-asks with context) |

### Real-World Use Cases

#### 1. Product Strategy

```
User: "Should we add social features to our productivity app?"

Jobs Model: "You're asking the wrong question. The real question is:
what would happen if you removed ALL features except one?"
```

#### 2. Investment Analysis

```
User: "Is this crypto project worth investing in?"

Munger Model: "Let me reframe: what are the incentives of the founders?
Are they aligned with shareholders? Show me their skin in the game."
```

#### 3. Technical Architecture

```
User: "Should we build monolith or microservices?"

Torvalds Model: "I don't care about the architecture. I care about whether
the code works. Start with what works. Refactor later if it actually breaks."
```

## Advanced Usage

### Customizing Distillations

You can refine the distillation by adding specific instructions:

```
> Distill Tim Cook but focus specifically on supply chain management
> and operational excellence, not his public speaking style

> Distill my PhD advisor with emphasis on their experimental design
> methodology and paper review patterns
```

### Combining Multiple Distillations

```
> First, analyze this from Buffett's perspective on risk
> Then, from Musk's perspective on first principles
> Finally, synthesize both viewpoints
```

### Export and Share

Generated skills can be exported and shared:

```bash
# Export a skill
cat ~/.claude/skills/nuwa-skill/SKILL.md > jobs-distilled.md

# Share with a team member
scp jobs-distilled.md team@example.com:~/skills/

# They install by pointing to your URL
npx skills add https://your-server.com/jobs-distilled.md
```

### Creating Skills for Personal Use

Beyond famous people, Nuwa-Skill works for anyone whose thinking you want to capture:

```
> Distill my mentor Sarah — she's great at system design
> and always asks "what breaks first?" when reviewing architecture

> Distill the engineering team's decision-making patterns
> from our last 10 architecture review meetings
```

## Comparison with Alternatives

| Feature | Nuwa-Skill | Traditional Roleplay Prompt | Custom Fine-tuning | Character Cards |
|---------|-----------|---------------------------|-------------------|----------------|
| Setup time | 1 command | 5 min writing | 2-4 hours | 10-30 min |
| Cognitive depth | 5 layers | Surface tone | Deep but static | Variable |
| Multi-runtime | 50+ runtimes | Chat interface only | Model-specific | Platform-specific |
| Update capability | Re-distill anytime | Rewrite prompt | Retraining needed | Edit JSON |
| Limitation awareness | Built-in (Layer 5) | None | None | Rare |
| Agent integration | Native (SKILL.md) | Chat message only | API call only | Chat message |

## Limitations / Honest Assessment

Nuwa-Skill is innovative but has important limitations:

1. **Public information only** — The distillation is limited to what the person has publicly expressed. Private thoughts and unspoken frameworks cannot be captured.

2. **Snapshot in time** — Distillations capture the person's thinking at a point in time. People evolve, and the skill won't reflect that evolution unless re-distilled.

3. **No intuition transfer** — As the README states: "Distillation can't capture intuition — frameworks can be extracted, inspiration cannot." The skill provides cognitive patterns, not creative sparks.

4. **Runtime dependency** — The quality of output depends on the underlying LLM. A weaker model may not faithfully follow the 5-layer instructions.

5. **Research quality varies** — The quality of distillation depends on the quality and quantity of public content available about the target person. Obscure figures with limited public records will produce thinner distillations.

6. **Not a replacement for the person** — The skill captures patterns of thought, not the full complexity of human cognition. It's a decision aid, not a psychic medium.

## Frequently Asked Questions

**Q: How does Nuwa-Skill differ from simply using a roleplay prompt?**

A: Traditional roleplay prompts only capture surface-level tone and vocabulary. Nuwa-Skill's five-layer extraction captures decision heuristics, anti-patterns, and honestly stated limitations — producing much more actionable cognitive frameworks.

**Q: Can I distill myself?**

A: Yes, this is one of the most practical use cases. The system analyzes your public content (blog posts, tweets, GitHub commits, interview transcripts) and distills your unique thinking patterns into a skill you can use across all your agent runtimes.

**Q: Does Nuwa-Skill store my data?**

A: Nuwa-Skill is a local-first framework. The SKILL.md files are stored in your local agent runtime's skills directory. No data is sent to external servers during distillation.

**Q: How many distillations can I create?**

A: There's no hard limit. You can create as many skills as you want. The [colleague-skill](https://github.com/titanwings/colleague-skill) project demonstrated that distilling colleagues is possible — but why stop at colleagues?

**Q: What's the difference between Nuwa-Skill and MCP?**

A: Nuwa-Skill uses the Agent Skills protocol (agentskills.io), which is a different standard than MCP. It's designed specifically for reusable cognitive frameworks rather than tool interfaces. It works alongside MCP, not instead of it.

**Q: Can I use Nuwa-Skill with OpenAI's ChatGPT?**

A: Not directly, as ChatGPT doesn't support the Agent Skills protocol. However, you can paste the SKILL.md content directly into a ChatGPT conversation, or use ChatGPT's custom instructions feature to achieve similar results.

## Conclusion

Nuwa-Skill represents a new paradigm in AI agent augmentation — rather than asking "what model should I use," it asks "whose thinking should I borrow." By distilling the cognitive operating systems of experts, historical figures, and mentors into reusable, deployable skills, it gives you a superpower: instant access to the decision frameworks of the world's best thinkers.

The beauty of Nuwa-Skill is its simplicity: one command, 50+ runtimes, and infinite distillation possibilities. From Steve Jobs's product philosophy to Warren Buffett's investment heuristics to your own manager's email patterns, the cognitive frameworks you need are one `npx skills add` away.

**Try Nuwa-Skill:** [github.com/alchaincyf/nuwa-skill](https://github.com/alchaincyf/nuwa-skill)

**Related articles:**
- [Headroom](https://dibi8.com/headroom-token-compression-proxy-library-mcp-server) — Compress LLM inputs by 60-95%
- [Matt Pocock's Skills](https://dibi8.com/mattpocock-skills-ai-agent-framework-guide) — CLI framework for AI agent superpowers

**Sources & Further Reading:**
- Agent Skills protocol: https://agentskills.io
- Universal skills installer: https://github.com/vercel-labs/skills
- Colleague-skill (predecessor): https://github.com/titanwings/colleague-skill
- GitHub repository: https://github.com/alchaincyf/nuwa-skill

---

Join our community for more AI tool deep-dives: [t.me/DIBI8_Group](https://t.me/DIBI8_Group)

**Disclaimer:** This article is for informational purposes only. Distillations are based on publicly available information and do not represent the actual thoughts of the individuals described. Always verify claims independently. Affiliate disclosure: Some links above may contain affiliate codes. We may earn a commission at no extra cost to you.
