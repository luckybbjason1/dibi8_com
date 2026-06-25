---
title: 'PM-Skills: 68 Product Management Skills and 42 Workflows for AI Agents'
description: 'The AI operating system for better product decisions. 9 plugins covering discovery, strategy, execution, research, analytics, GTM, marketing, toolkit, and AI shipping. Works with Claude Code, Codex, Cursor, and 50+ AI assistants.'
tags: ["ai-agent", "automation", "open-source"]
date: 2026-06-22
lastmod: 2026-06-22
draft: false
categories: ['ai-tools']
slug: pm-skills-68-product-management-skills-ai-agents
featureImage: 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'
aliases: ['/pm-skills']
sources:
  - name: 'GitHub'
    url: 'https://github.com/phuryn/pm-skills'
  - name: 'The Product Compass'
    url: 'https://www.productcompass.pm'
lang: en
---
---
title: 'PM-Skills: 68 Product Management Skills and 42 Workflows for AI Agents'
description: 'The AI operating system for better product decisions. 9 plugins covering discovery, strategy, execution, research, analytics, GTM, marketing, toolkit, and AI shipping. Works with Claude Code, Codex, Cursor, and 50+ AI assistants.'
date: 2026-06-22
lastmod: 2026-06-22
draft: false
tags: ['AI Tools', 'Product Management', 'Claude Code', 'Agent Skills', 'Open Source']
categories: ['ai-tools']
slug: pm-skills-68-product-management-skills-ai-agents

aliases: ['/pm-skills']
sources:
  - name: 'GitHub'
    url: 'https://github.com/phuryn/pm-skills'
  - name: 'The Product Compass'
    url: 'https://www.productcompass.pm'
---

# PM-Skills: 68 Product Management Skills and 42 Workflows for AI Agents

TL;DR — **PM-Skills Marketplace** is an open-source collection of 68 product management skills and 42 chained workflows across 9 plugins, designed for Claude Code, Cowork, and 50+ other AI assistants. From discovery to strategy, execution, launch, growth, and shipping AI-built code — it encodes proven PM frameworks from Teresa Torres, Marty Cagan, Alberto Savoia, and Dan Olsen directly into your AI agent's workflow.

## What Is PM-Skills?

Generic AI gives you text. **PM-Skills gives you structure.**

Each skill encodes a proven product management framework — discovery, assumption mapping, prioritization, strategy — and walks your AI agent through it step by step. You get the rigor of industry-standard PM methodologies built into your daily workflow, not sitting on a bookshelf.

The result: better product decisions, not just faster documents.

PM-Skills uses three abstractions:

- **Skills** — Reusable PM knowledge (frameworks, templates, analytical tools). Loaded automatically when relevant to a conversation.
- **Commands** — User-triggered workflows (`/discover`, `/write-prd`, `/strategy`) that chain multiple skills into end-to-end processes.
- **Plugins** — Installable packages grouping related skills and commands by PM domain.

Commands are designed to flow into each other, matching the real PM workflow. After any command completes, it suggests relevant next commands.

**GitHub:** [phuryn/pm-skills](https://github.com/phuryn/pm-skills) · **Stars:** 2,400+ · **License:** MIT · **Language:** Markdown/Shell

## Quick Start

| Need | Command |
|------|---------|
| New idea? | `/discover` |
| Strategic clarity? | `/strategy` |
| Writing a PRD? | `/write-prd` |
| Planning a launch? | `/plan-launch` |
| Defining metrics? | `/north-star` |

## The 9 Plugins

### 1. pm-product-discovery (13 skills, 5 commands)

Ideation, experiments, assumption testing, Opportunity Solution Trees, and customer interviews.

**Skills:**
- `brainstorm-ideas-existing` — Multi-perspective ideation for existing products (PM, Designer, Engineer viewpoints)
- `brainstorm-ideas-new` — Ideation for new products in initial discovery
- `brainstorm-experiments-existing` — Design experiments to test assumptions for existing products
- `brainstorm-experiments-new` — Design lean startup pretotypes (Alberto Savoia methodology)
- `identify-assumptions-existing` — Identify risky assumptions across Value, Usability, Viability, Feasibility
- `identify-assumptions-new` — Identify risky assumptions across 8 risk categories including Go-to-Market, Strategy, and Team
- `prioritize-assumptions` — Prioritize using an Impact × Risk matrix with experiment suggestions
- `prioritize-features` — Prioritize feature backlog based on impact, effort, risk, and strategic alignment
- `analyze-feature-requests` — Categorize customer feature requests by theme and strategic fit
- `opportunity-solution-tree` — Build an OST (Teresa Torres): outcome → opportunities → solutions → experiments
- `interview-script` — Structured customer interview script with JTBD probing questions
- `summarize-interview` — Summarize interview transcripts into JTBD, satisfaction signals, and action items
- `metrics-dashboard` — Design a product metrics dashboard with North Star, input metrics, and alert thresholds

**Commands:**
- `/discover` — Full discovery cycle: ideation → assumption mapping → prioritization → experiment design
- `/brainstorm` — Multi-perspective ideation
- `/triage-requests` — Analyze and prioritize feature request batches
- `/interview` — Prepare interview scripts or summarize transcripts
- `/setup-metrics` — Design a product metrics dashboard

**Example:**
```
/discover AI-powered meeting summarizer for remote teams
```

### 2. pm-product-strategy (12 skills, 5 commands)

Vision, business models, pricing, and competitive landscape analysis.

**Skills:**
- `product-strategy` — Comprehensive 9-section Product Strategy Canvas
- `startup-canvas` — Startup Canvas: Product Strategy + Business Model
- `product-vision` — Craft an inspiring, achievable, emotional product vision
- `value-proposition` — 6-part JTBD value proposition template
- `lean-canvas` — Lean Canvas business model for startups
- `business-model` — Business Model Canvas with all 9 building blocks
- `monetization-strategy` — Brainstorm 3-5 monetization strategies with validation experiments
- `pricing-strategy` — Pricing models, competitive analysis, willingness-to-pay
- `swot-analysis` — SWOT analysis with actionable recommendations
- `pestle-analysis` — Macro environment: Political, Economic, Social, Technological, Legal, Environmental
- `porters-five-forces` — Competitive forces analysis
- `ansoff-matrix` — Growth strategy across markets and products

**Commands:**
- `/strategy` — Create a complete 9-section Product Strategy Canvas
- `/business-model` — Explore business models (lean/full/startup/value-prop/all)
- `/value-proposition` — Design a JTBD value proposition
- `/market-scan` — Macro environment analysis (SWOT + PESTLE + Porter's + Ansoff)
- `/pricing` — Design a pricing strategy with competitive analysis

**Example:**
```
/strategy B2B project management tool for agencies
```

### 3. pm-execution (16 skills, 11 commands)

Day-to-day product management: PRDs, OKRs, roadmaps, sprints, retrospectives, release notes.

**Skills:**
- `create-prd` — Comprehensive 8-section PRD template
- `brainstorm-okrs` — Team-level OKRs aligned with company objectives
- `outcome-roadmap` — Transform feature lists into outcome-focused roadmaps
- `sprint-plan` — Sprint planning with capacity estimation and risk identification
- `retro` — Structured sprint retrospective facilitation
- `release-notes` — User-facing release notes from tickets, PRDs, or changelogs
- `pre-mortem` — Risk analysis with Tigers/Paper Tigers/Elephants classification
- `stakeholder-map` — Power × Interest grid with communication plan
- `summarize-meeting` — Meeting transcripts → decisions + action items
- `user-stories` — User stories following 3 C's and INVEST criteria
- `job-stories` — Job stories: When [situation], I want to [motivation], so I can [outcome]
- `wwas` — Product backlog items in Why-What-Acceptance format
- `test-scenarios` — Happy paths, edge cases, error handling
- `dummy-dataset` — Realistic dummy datasets as CSV, JSON, SQL, or Python
- `prioritization-frameworks` — Reference guide to 9 frameworks (Opportunity Score, ICE, RICE, MoSCoW, Kano, etc.)
- `strategy-red-team` — Adversarial stress-test of a plan with cheapest tests first

**Commands:**
- `/write-prd` — Create a PRD from a feature idea or problem statement
- `/plan-okrs` — Brainstorm team-level OKRs
- `/transform-roadmap` — Convert feature-based roadmaps to outcome-focused
- `/sprint` — Sprint lifecycle (plan/retro/release)
- `/pre-mortem` — Pre-mortem risk analysis on a PRD or launch plan
- `/red-team-prd` — Adversarially stress-test a PRD, roadmap, or strategy
- `/meeting-notes` — Summarize meeting transcripts into structured notes
- `/stakeholder-map` — Map stakeholders and create communication plans
- `/write-stories` — Break features into backlog items
- `/test-scenarios` — Generate test scenarios from user stories
- `/generate-data` — Create realistic dummy datasets

**Example:**
```
/write-prd Smart notification system that reduces alert fatigue
```

### 4. pm-market-research (7 skills, 3 commands)

User research and competitive analysis: personas, segmentation, journey maps, market sizing.

**Skills:**
- `user-personas` — Create refined user personas from research data
- `market-segments` — Identify 3-5 customer segments with demographics and JTBD
- `user-segmentation` — Segment users from feedback data by behavior and needs
- `customer-journey-map` — End-to-end journey maps with stages, touchpoints, emotions
- `market-sizing` — TAM, SAM, SOM with top-down and bottom-up approaches
- `competitor-analysis` — Competitor strengths, weaknesses, differentiation opportunities
- `sentiment-analysis` — Sentiment analysis and theme extraction from user feedback

**Commands:**
- `/research-users` — Build personas, segment users, map customer journeys
- `/competitive-analysis` — Analyze the competitive landscape
- `/analyze-feedback` — Sentiment analysis and segment insights from user feedback

**Example:**
```
/competitive-analysis Figma competitors in the design tool space
```

### 5. pm-data-analytics (3 skills, 3 commands)

Data analytics for PMs: SQL generation, cohort analysis, A/B test analysis.

**Skills:**
- `sql-queries` — Generate SQL from natural language (BigQuery, PostgreSQL, MySQL)
- `cohort-analysis` — Retention curves, feature adoption, engagement trends by cohort
- `ab-test-analysis` — Statistical significance, sample size validation, ship/extend/stop recommendations

**Commands:**
- `/write-query` — Generate SQL queries from natural language
- `/analyze-cohorts` — Cohort analysis on user engagement data
- `/analyze-test` — Analyze A/B test results

**Example:**
```
/write-query Show me monthly active users by country for Q4 2025 (BigQuery)
```

### 6. pm-go-to-market (6 skills, 3 commands)

GTM strategy: beachhead segments, ICPs, messaging, growth loops, battlecards.

**Skills:**
- `gtm-strategy` — Full GTM strategy: channels, messaging, success metrics, launch plan
- `beachhead-segment` — Identify the first beachhead market segment
- `ideal-customer-profile` — ICP with demographics, behaviors, JTBD, and needs
- `growth-loops` — Design sustainable growth loops (flywheels)
- `gtm-motions` — Evaluate GTM motions (product-led, sales-led, etc.)
- `competitive-battlecard` — Sales-ready battlecard with objection handling

**Commands:**
- `/plan-launch` — Full GTM strategy from beachhead to launch plan
- `/growth-strategy` — Design growth loops and evaluate GTM motions
- `/battlecard` — Create a competitive battlecard

**Example:**
```
/plan-launch AI code review tool targeting mid-size engineering teams
```

### 7. pm-marketing-growth (5 skills, 2 commands)

Product marketing and growth: marketing ideas, positioning, naming, North Star metrics.

**Skills:**
- `marketing-ideas` — Creative, cost-effective marketing ideas with channels and messaging
- `positioning-ideas` — Product positioning differentiated from competitors
- `value-prop-statements` — Value proposition statements for marketing, sales, and onboarding
- `product-name` — Product name brainstorming aligned to brand values and audience
- `north-star-metric` — North Star Metric + input metrics with business game classification

**Commands:**
- `/market-product` — Brainstorm marketing ideas, positioning, value props, and product names
- `/north-star` — Define your North Star Metric and supporting input metrics

**Example:**
```
/north-star Two-sided marketplace connecting freelancers with clients
```

### 8. pm-toolkit (4 skills, 5 commands)

PM utilities beyond core product work: resume review, legal documents, proofreading.

**Skills:**
- `review-resume` — PM resume review against 10 best practices (XYZ+S formula)
- `draft-nda` — Non-Disclosure Agreement with jurisdiction-appropriate clauses
- `privacy-policy` — Privacy policy covering GDPR/CCPA compliance
- `grammar-check` — Grammar, logic, and flow checking with targeted fixes

**Commands:**
- `/review-resume` — Comprehensive PM resume review
- `/tailor-resume` — Tailor a resume to a specific job description
- `/draft-nda` — Draft an NDA
- `/privacy-policy` — Draft a privacy policy
- `/proofread` — Check grammar, logic, and flow

### 9. pm-ai-shipping (2 skills, 5 commands)

For PMs and founders accountable for AI-built code. Restores reviewability to vibe-coded apps.

**Skills:**
- `shipping-artifacts` — Durable documentation set for AI-built apps: architecture, user/permission flows, variables/secrets, test-coverage map, plus conditional docs (emails, cron, SEO, embedded agents)
- `intended-vs-implemented` — Method for finding the gap between documented intent and actual code behavior, with cited evidence

**Commands:**
- `/ship-check` — Turn a vibe-coded repo into a reviewer-ready shipping packet
- `/document-app` — Reverse-engineer a codebase into system documents reviewers need
- `/derive-tests` — Turn documented intent into a test-coverage map
- `/security-audit-static` — Static security audit with trust boundary mapping
- `/performance-audit-static` — Static performance audit: over-fetching, missing indexes, caching

**Example:**
```
/ship-check the payments service
```

## Installation

### Claude Code (Recommended)

```bash
# Step 1: Add the marketplace
claude plugin marketplace add phuryn/pm-skills

# Step 2: Install individual plugins
claude plugin install pm-toolkit@pm-skills
claude plugin install pm-product-strategy@pm-skills
claude plugin install pm-product-discovery@pm-skills
claude plugin install pm-market-research@pm-skills
claude plugin install pm-data-analytics@pm-skills
claude plugin install pm-marketing-growth@pm-skills
claude plugin install pm-go-to-market@pm-skills
claude plugin install pm-execution@pm-skills
claude plugin install pm-ai-shipping@pm-skills
```

### Claude Cowork (For Non-Developers)

1. Open **Customize** (bottom-left)
2. Go to **Browse plugins** → **Personal** → **+**
3. Select **Add marketplace from GitHub**
4. Enter: `phuryn/pm-skills`

All 9 plugins install automatically with both commands and skills.

### Codex CLI (OpenAI)

Codex reads the same plugin marketplace file as Claude Code:

```bash
# Step 1: Add the marketplace
codex plugin marketplace add phuryn/pm-skills

# Step 2: Install the plugins you want
codex plugin add pm-toolkit@pm-skills
codex plugin add pm-product-strategy@pm-skills
# ... etc
```

**Note:** Codex plugins don't expose `/slash` commands. To run workflows, describe the steps in plain language:

> Run product discovery on [your idea]: brainstorm options, map assumptions, prioritize the risky ones, then design experiments — pause between each step.

Optionally, ask Codex to convert command files into equivalent skills for the workflows you use most.

### Other AI Assistants (Skills Only)

The `skills/*/SKILL.md` files follow the universal skill format and work with any tool that reads them. Commands (`/slash-commands`) are Claude-specific.

| Tool | How to Use | What Works |
|------|-----------|------------|
| Gemini CLI | Copy skill folders to `.gemini/skills/` | Skills only |
| OpenCode | Copy skill folders to `.opencode/skills/` | Skills only |
| Cursor | Copy skill folders to `.cursor/skills/` | Skills only |
| Kiro | Copy skill folders to `.kiro/skills/` | Skills only |

```bash
# Example: copy all skills for OpenCode (project-level)
for plugin in pm-*/; do
  mkdir -p .opencode/skills/
  cp -r "$plugin/skills/"* .opencode/skills/ 2>/dev/null
done

# Example: copy all skills for Gemini CLI (global)
for plugin in pm-*/; do
  cp -r "$plugin/skills/"* ~/.gemini/skills/ 2>/dev/null
done
```

## Architecture: Skills, Commands, and Plugins

```
┌─────────────────────────────────────────────────────────┐
│                    PM Skills Marketplace                  │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │ Commands │  │  Skills  │  │ Plugins  │              │
│  │ (trigger)│  │(building │  │(packages │              │
│  │          │  │ blocks)  │  │ of skills│              │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘              │
│       │              │              │                    │
│       ▼              ▼              ▼                    │
│  ┌─────────────────────────────────────────┐            │
│  │         9 Domain Plugins                │            │
│  │  Discovery │ Strategy │ Execution │ ... │            │
│  └─────────────────────────────────────────┘            │
│                                                         │
│  68 Skills  │  42 Commands  │  9 Plugins                │
└─────────────────────────────────────────────────────────┘
```

**Skills** are loaded automatically when relevant to the conversation — no explicit invocation needed. To force-load skills: `/plugin-name:skill-name` or `/skill-name`.

**Commands** chain one or more skills into end-to-end processes. For example, `/discover` chains: `brainstorm-ideas → identify-assumptions → prioritize-assumptions → brainstorm-experiments`.

**Plugins** group related skills and commands into installable packages. Installing the marketplace gives you all 9 plugins at once.

## Frameworks and Methodologies

PM-Skills encodes frameworks from the world's most respected product thinkers:

| Author | Framework | Used In |
|--------|-----------|---------|
| Teresa Torres | Continuous Discovery, Opportunity Solution Trees | pm-product-discovery |
| Marty Cagan | INSPIRED, TRANSFORMED methodology | pm-product-strategy |
| Alberto Savoia | Pretotype, Right It | pm-product-discovery |
| Dan Olsen | Lean Product Playbook, JP&P | pm-product-discovery |
| Roger L. Martin | Playing to Win | pm-product-strategy |
| Ash Maurya | Running Lean, Lean Canvas | pm-product-strategy |
| Strategyzer | Business Model Generation, Value Prop Design | pm-product-strategy |
| Christina Wodtke | Radical Focus, OKRs | pm-execution |
| Anthony Ulwick | Jobs to Be Done | pm-product-discovery |
| Alistair Croll & Ben Yoskovitz | Lean Analytics | pm-data-analytics |
| Sean Ellis | Hacking Growth | pm-marketing-growth |
| Maja Voje | Go-To-Market Strategy | pm-go-to-market |

## Who Should Use PM-Skills?

- **Product Managers** who want structured frameworks for every PM task
- **Founders** building products without a dedicated PM team
- **Product Designers** transitioning into product strategy
- **Engineers** taking on product responsibilities
- **Growth Marketers** needing structured GTM planning
- **Anyone** who wants AI to give them frameworks, not just text

## Alternatives Compared

| Feature | PM-Skills | Generic AI Prompts | Notion Templates | AI2SDK |
|---------|-----------|-------------------|-----------------|--------|
| Structured workflows | ✅ 42 commands | ❌ Free-form | ❌ Static docs | ❌ No workflows |
| Multi-agent support | ✅ 50+ hosts | ✅ Any | ❌ N/A | ❌ Claude only |
| Framework-based | ✅ 12 authors | ❌ Ad hoc | ❌ DIY | ❌ Generic |
| Chained skills | ✅ Skills chain to commands | ❌ No | ❌ No | ❌ No |
| Self-updating | ✅ Marketplace updates | ❌ Static | ❌ Static | ❌ Static |
| AI shipping kit | ✅ pm-ai-shipping plugin | ❌ No | ❌ No | ❌ No |
| Cost | ✅ Free (MIT) | ✅ Free | ❌ Paid | ❌ Paid |

## Getting Started Checklist

1. Install via Claude Code: `claude plugin marketplace add phuryn/pm-skills`
2. Install plugins you need: `claude plugin install pm-product-discovery@pm-skills`
3. Try `/discover` for a new product idea
4. Try `/write-prd` for product documentation
5. Try `/strategy` for strategic planning
6. Explore the full plugin list and pick what fits your workflow
7. Use skills-only installation for non-Claude agents

## Frequently Asked Questions

### Q: Do I need to install all 9 plugins?

No. Install only the plugins relevant to your workflow. Most PMs will start with `pm-product-discovery`, `pm-execution`, and `pm-product-strategy`.

### Q: Can I use PM-Skills without Claude Code?

Yes. The skills directory (`skills/*/SKILL.md`) follows the universal skill format and works with Gemini CLI, OpenCode, Cursor, Kiro, and any tool that reads SKILL.md files. Commands (`/slash-commands`) are Claude-specific.

### Q: How are skills loaded?

Skills load automatically when relevant to the conversation. You can also force-load a skill with `/plugin-name:skill-name` or `/skill-name`.

### Q: What's the difference between skills and commands?

Skills are building blocks — individual frameworks, templates, or analytical tools. Commands are user-triggered workflows that chain multiple skills together into end-to-end processes.

### Q: Is this free?

Yes. PM-Skills is MIT licensed. No tracking, no analytics, no cloud dependency. Everything runs locally.

### Q: What is PM Brain?

[PM Brain](https://github.com/phuryn/pm-brain) is a companion project — a second brain for product managers. Plain markdown files on your laptop. Claude reads them before answering, writes to them after, sweeps them every Friday. No vector DB, no cloud, no agent memory tricks.

## Writing Custom Skills

You can extend PM-Skills with your own custom skills. Create a `SKILL.md` file in the `skills/` directory:

```markdown
---
name: my-company-framework
mode: inline
---

# My Company Product Framework

When working on product decisions for our company, follow this framework:

1. Validate the problem with at least 3 customer interviews
2. Build an Opportunity Solution Tree
3. Design a pretotype before building
4. Measure against our North Star metric
```

Test your custom skill with:

```bash
# Force-load your custom skill
/my-company-framework Brainstorm monetization for our analytics dashboard
```

## Full Discovery Workflow Example

Here's a complete discovery workflow using PM-Skills commands in sequence:

```
# Step 1: Generate ideas
/discover AI-powered code review tool for small teams

# Step 2: Map assumptions
/identify-assumptions-existing
→ Value: Will devs actually use AI suggestions?
→ Feasibility: Can we integrate with GitHub API reliably?

# Step 3: Prioritize
/prioritize-assumptions
→ Highest risk: Value assumption (low confidence)

# Step 4: Design experiments
/brainstorm-experiments-existing
→ Pretotype: Manual concierge test with 5 beta users
→ Survey: NPS + feature importance ranking
```

## Sources

- [PM-Skills on GitHub](https://github.com/phuryn/pm-skills)
- [The Product Compass Newsletter](https://www.productcompass.pm)
- [PM Brain Companion](https://github.com/phuryn/pm-brain)
- [Agent Skills Marketplace](https://agentskills.io)

---

**Want better product decisions from your AI agent?** PM-Skills gives you 68 structured frameworks and 42 workflows across 9 plugins — all free and open source.

**Join the Dibi8 community:** [Telegram Group](https://t.me/DIBI8_Group/2)
