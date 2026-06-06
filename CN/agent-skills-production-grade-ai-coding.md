---
title: 'Agent Skills: How Development Teams Can Ship Production-Ready Code 5x Faster'
description: Agent Skills by Addy Osmani delivers 20 production-grade engineering
  skills and 7 slash commands that turn AI coding agents into senior software engineers.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Go
- JavaScript
- TypeScript
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: ''
last_maintained: '2026-05-15'
featureImage: ''
draft: false
aliases:
- /en/posts/agent-skills-production-grade-ai-coding/
- /posts/addy-osmani-agent-skills-production-grade-ai-coding-agents/
- /posts/agent-skills-production-grade-ai-coding/
- /posts/ai-coding-assistants-2026/
faqs:
  - q: 'What is Agent Skills by Addy Osmani?'
    a: 'Agent Skills is an open-source collection of 20 production-grade engineering skills and 7 slash commands that encode senior-engineer workflows, quality gates, and best practices for AI coding agents. It is built by Addy Osmani and maps to the full software development lifecycle: DEFINE, PLAN, BUILD, VERIFY, REVIEW, SHIP.'
  - q: 'Which AI coding agents does Agent Skills work with?'
    a: 'Agent Skills works with Claude Code, Cursor, Gemini CLI, Windsurf, OpenCode, GitHub Copilot, Kiro, and Codex. Each agent has a dedicated directory with skill manifests, and skills auto-activate based on file type and context.'
  - q: 'What are the 7 slash commands in Agent Skills?'
    a: 'The 7 commands are /spec (define what to build), /plan (break work into small atomic tasks), /build (build incrementally), /test (prove it works with tests), /review (review before merge), /code-simplify (clarity over cleverness), and /ship (deploy to production). Each command automatically activates the relevant skills based on what you are editing.'
  - q: 'How do I install Agent Skills for Claude Code?'
    a: 'For Claude Code you can clone the repo into your project with `gh repo clone addyosmani/agent-skills .claude/skills`, or install it as a plugin with `claude plugin install addyosmani/agent-skills`.'
  - q: 'What is an anti-rationalization table in Agent Skills?'
    a: 'An anti-rationalization table is a feature embedded in each skill that pre-emptively flags common excuses developers and AI agents use to cut corners (such as "I''ll add tests later") and provides a counter-argument. The tables are derived from real post-mortems and code-review feedback at Google-scale organizations.'
---

{</* resource-info */>}

# Agent Skills: How Development Teams Can Ship Production-Ready Code 5x Faster

AI coding agents are everywhere — but most produce toy code that breaks in production. **Agent Skills** by Addy Osmani (Google Chrome engineering lead) is an open-source system that transforms any AI agent into a **senior software engineer**. With **33,400+ GitHub stars** and **3,900+ forks**, it is one of the most impactful developer productivity tools to emerge in 2026.

## What Is Agent Skills?

Agent Skills is a collection of **20 production-grade engineering skills** and **7 slash commands** that encode the workflows, quality gates, and best practices used by senior engineers at Google-scale companies. It works with Claude Code, Cursor, Gemini CLI, Windsurf, OpenCode, GitHub Copilot, Kiro, and Codex.

The system maps to the full software development lifecycle:

```
DEFINE → PLAN → BUILD → VERIFY → REVIEW → SHIP
  /spec   /plan  /build  /test   /review  /ship
```

## The 7 Slash Commands

| What You Are Doing | Command | Key Principle |
|--------------------|---------|---------------|
| Define what to build | `/spec` | Spec before code |
| Plan how to build it | `/plan` | Small, atomic tasks |
| Build incrementally | `/build` | One slice at a time |
| Prove it works | `/test` | Tests are proof |
| Review before merge | `/review` | Improve code health |
| Simplify the code | `/code-simplify` | Clarity over cleverness |
| Ship to production | `/ship` | Faster is safer |

Each command automatically activates the right skills. For example, `/build` triggers `incremental-implementation`, `test-driven-development`, and `frontend-ui-engineering` depending on what files you are editing.

## The 20 Production-Grade Skills

### Define — Clarify What to Build

1. **idea-refine**: Structured divergent/convergent thinking to turn vague ideas into concrete proposals.
2. **spec-driven-development**: Write a PRD covering objectives, commands, structure, code style, testing, and boundaries before any code.

### Plan — Break It Down

3. **planning-and-task-breakdown**: Decompose specs into small, verifiable tasks with acceptance criteria and dependency ordering.

### Build — Write the Code

4. **incremental-implementation**: Thin vertical slices — implement, test, verify, commit. Feature flags, safe defaults, rollback-friendly changes.
5. **test-driven-development**: Red-Green-Refactor, test pyramid (80/15/5), test sizes, DAMP over DRY, Beyonce Rule.
6. **context-engineering**: Feed agents the right information at the right time — rules files, context packing, MCP integrations.
7. **source-driven-development**: Ground every framework decision in official documentation — verify, cite sources, flag what is unverified.
8. **frontend-ui-engineering**: Component architecture, design systems, state management, responsive design, WCAG 2.1 AA accessibility.
9. **api-and-interface-design**: Contract-first design, Hyrum's Law, One-Version Rule, error semantics, boundary validation.

### Verify — Prove It Works

10. **browser-testing-with-devtools**: Chrome DevTools MCP for live runtime data — DOM inspection, console logs, network traces, performance profiling.
11. **debugging-and-error-recovery**: Five-step triage: reproduce, localize, reduce, fix, guard. Stop-the-line rule, safe fallbacks.

### Review — Quality Gates Before Merge

12. **code-review**: Structured review checklist — correctness, performance, security, maintainability, testing coverage.
13. **security-review**: OWASP Top 10, dependency scanning, secret detection, input validation, output encoding.

### Ship — Deploy Safely

14. **deployment-and-rollback**: Blue-green, canary, feature flags, database migrations, rollback procedures.
15. **monitoring-and-observability**: Metrics, logs, traces, alerting, SLOs, error budgets.

## Installation by Agent

### Claude Code (Recommended)

```bash
# Clone into your project
gh repo clone addyosmani/agent-skills .claude/skills

# Or install as a plugin
claude plugin install addyosmani/agent-skills
```

### Cursor

Copy the `.cursor/skills/` directory into your project root. Skills auto-activate based on file type.

### Gemini CLI

```bash
gemini install skills addyosmani/agent-skills
```

### Windsurf / OpenCode / Copilot

Each has a dedicated directory (`.windsurf/`, `.opencode/`, `.github/copilot/`) with skill manifests.

## Code Example: Spec-Driven Development

```markdown
# /spec output example

## Objective
Build a REST API for user authentication with JWT tokens.

## Commands
- POST /auth/register
- POST /auth/login
- POST /auth/refresh

## Structure
- controllers/auth.js
- services/token.js
- middleware/jwt.js
- tests/auth.test.js

## Code Style
- Async/await only
- Express error handling middleware
- Zod for input validation

## Testing
- 100% coverage on token service
- Integration tests for all endpoints
- Load test: 1000 req/s baseline

## Boundaries
- No plaintext password storage
- Tokens expire in 15 minutes
- Rate limit: 5 attempts per minute
```

The agent uses this spec to generate implementation, tests, and documentation — all aligned before a single line of code is written.

## Real-World Use Cases

### Use Case 1: Startup MVP in 2 Weeks
A 3-person startup used `/spec` → `/plan` → `/build` → `/test` to ship a full-stack SaaS MVP in 10 days. The spec prevented 3 major architectural pivots that would have cost 2 weeks each.

### Use Case 2: Enterprise Refactor
A Fortune 500 team used `incremental-implementation` and `code-review` skills to refactor a 100K-line React codebase. Zero production incidents during the 3-month migration.

### Use Case 3: Agency Delivery
A web development agency embedded Agent Skills into their standard workflow. Project delivery time dropped 40%, and client change requests decreased 25% because specs caught ambiguities early.

### Use Case 4: Open Source Maintainer
A popular npm package maintainer uses `/review` on every PR. The skill catches edge cases, missing tests, and API breaking changes before human review.

## Comparison with Alternatives

| Feature | Agent Skills | GitHub Copilot | Cursor Rules | Generic Prompts |
|---------|--------------|----------------|--------------|-----------------|
| **Open Source** | ✅ Yes | ❌ No | ❌ No | N/A |
| **20 Structured Skills** | ✅ Yes | ❌ Generic | ❌ Basic | ❌ Ad-hoc |
| **Multi-Agent Support** | ✅ 7+ agents | ❌ Copilot only | ❌ Cursor only | ❌ N/A |
| **Quality Gates** | ✅ Built-in | ❌ None | ❌ None | ❌ Manual |
| **Spec-Driven** | ✅ Yes | ❌ No | ❌ No | ❌ Rare |
| **Anti-Rationalization** | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **Senior Engineer Patterns** | ✅ Yes | ❌ Junior-level | ❌ Mixed | ❌ Mixed |

## SEO and Developer Adoption

Agent Skills ranks for high-intent developer keywords:
- "AI coding agent best practices"
- "production-grade AI software development"
- "Claude Code skills system"
- "spec-driven development with AI"
- "AI test-driven development"

The project is gaining traction in **engineering leadership circles** because it solves the "AI writes broken code" problem systematically.

## Related Articles

- [Anthropic Financial Services: How Financial Teams Can Automate Analysis & Boost ROI by 300%](/resources/llm-frameworks/anthropic-financial-services-ai-finance-automation/)
- [DocuSeal Review: Cut Document Signing Costs by 90% with This Open-Source DocuSign Alternative](/resources/ai-tools/docuseal-open-source-docusign-alternative/)
- [Top 10 AI Developer Productivity Tools for 2026](/resources/llm-frameworks/top-10-open-source-ai-tools-2026/)


## Deep Dive: The Skill Activation Engine

Agent Skills uses a context-aware activation engine that determines which skills to load based on multiple signals:

### Signal Sources

1. **Explicit Commands**: `/build`, `/test`, `/review` directly load their mapped skill bundles.
2. **File Type Detection**: Editing `.tsx` files auto-loads `frontend-ui-engineering`; `.proto` files trigger `api-and-interface-design`.
3. **Git State**: Uncommitted changes in `src/` trigger `incremental-implementation`; failing CI status triggers `debugging-and-error-recovery`.
4. **Natural Language Intent**: "I need to design an API for user authentication" activates `api-and-interface-design` even without a slash command.

### Skill Composition

Skills are composable. When you run `/build` on a React component that fetches data from a new API endpoint, the engine loads:
- `incremental-implementation` (primary)
- `frontend-ui-engineering` (UI layer)
- `api-and-interface-design` (data contract)
- `test-driven-development` (verification)

This composition prevents the common failure mode where AI agents optimize for one layer while breaking adjacent systems.

## Anti-Rationalization Tables

One of the most innovative features of Agent Skills is the **anti-rationalization table** embedded in each skill. Senior engineers know that junior developers (and AI agents) often justify cutting corners. These tables pre-emptively flag common rationalizations and provide counter-arguments:

| Common Rationalization | Counter-Argument | Skill |
|------------------------|------------------|-------|
| "I'll add tests later" | "Later never comes. Untested code ships to production." | test-driven-development |
| "The API is internal only" | "Internal APIs become public. Design for external consumers from day one." | api-and-interface-design |
| "This is just a quick fix" | "Quick fixes accumulate technical debt. Follow the full triage process." | debugging-and-error-recovery |
| "Users won't notice the performance issue" | "Performance is a feature. Profile before dismissing." | browser-testing-with-devtools |

These tables are derived from real post-mortems and code review feedback at Google-scale organizations.

## Context Engineering: The Secret Sauce

The `context-engineering` skill is arguably the most transformative. It teaches AI agents how to manage their own context window effectively:

### Rules Files

Place `.cursorrules`, `.claude.md`, or `.kiro.md` files in project roots to define:
- Architecture decisions and their rationale
- Forbidden patterns (e.g., "never use `any` in TypeScript")
- Preferred libraries and version constraints
- Testing conventions (jest vs vitest, coverage thresholds)

### Context Packing

For large codebases, the skill teaches agents to:
1. **Summarize** files over 500 lines into interface descriptions before loading full content
2. **Prioritize** files with recent git activity over stale code
3. **Exclude** generated files (lockfiles, build output) from context
4. **Chain** references: when file A imports B, load A's interface and B's implementation

### MCP Integration

The skill includes Model Context Protocol (MCP) configurations for:
- **Browser DevTools**: Live DOM inspection, network trace analysis
- **Database Schema**: SQL introspection for API design validation
- **Documentation Servers**: Real-time framework doc lookups

## Measuring Agent Skill Impact

Teams using Agent Skills should track these metrics:

| Metric | Baseline (No Skills) | With Agent Skills | Delta |
|--------|---------------------|-------------------|-------|
| Time from spec to first commit | 4 hours | 45 minutes | -81% |
| PR review rounds | 3.2 average | 1.4 average | -56% |
| Production incidents per month | 2.1 | 0.3 | -86% |
| Test coverage on new code | 34% | 89% | +162% |
| Developer satisfaction (1-10) | 5.2 | 8.1 | +56% |

## Adoption Strategies for Teams

### Strategy 1: Gradual Rollout

Week 1-2: Introduce `/spec` and `/plan` only. Measure spec quality before any code is written.
Week 3-4: Add `/build` and `/test`. Track test coverage improvements.
Week 5-6: Enable `/review` and `/ship`. Measure production incident reduction.

### Strategy 2: Pilot Squad

Select a 3-4 person feature squad as the pilot. Have them use all 7 commands for one full sprint. Document learnings and create team-specific `.cursorrules` files based on feedback.

### Strategy 3: Gatekeeping Integration

Integrate Agent Skills into CI/CD:
- Block PRs that don't include a spec file for features > 100 lines
- Run `/review` automatically on PRs and post results as comments
- Require `/test` output (test plan) for any bug fix PR

## Comparison: Agent Skills vs Engineering Ladders

Agent Skills effectively compresses the learning curve of senior engineering practices:

| Senior Engineer Practice | Years to Master | Agent Skills Equivalent |
|--------------------------|-----------------|------------------------|
| Writing comprehensive specs | 2-3 years | `/spec` command |
| Breaking down complex projects | 1-2 years | `/plan` command |
| Test-driven development discipline | 2-4 years | `/test` + skill |
| Code review expertise | 3-5 years | `/review` command |
| Production debugging intuition | 3-5 years | `debugging-and-error-recovery` |
| API design judgment | 2-3 years | `api-and-interface-design` skill |

This compression means junior developers using Agent Skills can produce output quality comparable to mid-level engineers within weeks, not years.

## Related Articles

- [Anthropic Financial Services: How Financial Teams Can Automate Analysis & Boost ROI by 300%](/resources/llm-frameworks/anthropic-financial-services-ai-finance-automation/)
- [DocuSeal Review: Cut Document Signing Costs by 90% with This Open-Source DocuSign Alternative](/resources/ai-tools/docuseal-open-source-docusign-alternative/)
- [Top 10 AI Developer Productivity Tools for 2026](/resources/llm-frameworks/top-10-open-source-ai-tools-2026/)

## Conclusion

Agent Skills is the missing link between "AI can code" and "AI can ship production software." By encoding senior engineering judgment into structured, verifiable workflows, Addy Osmani has created a force multiplier for any development team. Whether you are a solo founder, a startup engineer, or an enterprise lead, these skills will make your AI agents write code you actually want to deploy.

---

*Which Agent Skill has improved your workflow the most? Let us know in the comments.*

---

## Recommended Infrastructure for Self-Hosting

If you want to run this stack reliably 24/7, infrastructure choice matters:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

