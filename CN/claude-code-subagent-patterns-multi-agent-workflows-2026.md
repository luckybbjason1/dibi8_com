---
title: 'Claude Code Subagent Patterns: 5 Multi-Agent Workflows That Save Hours Every Day (2026)'
description: 'Five battle-tested Claude Code subagent patterns — parallel research, isolated worktrees, specialist delegation, context protection, and pipeline orchestration — with real prompts and tradeoffs from production use.'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'CLI', 'Bash']
application_domain: LLM Frameworks
source_version: ''
licensing_model: Commercial (Anthropic)
license_type: 'Proprietary'
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/anthropics/claude-code'
stars: 0
maintainer: 'Anthropic'
last_maintained: '2026-05-28'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['claude-code', 'subagents', 'multi-agent', 'ai-coding-agents', 'llm-frameworks', 'developer-tools', 'agent-sdk']
aliases:
- /posts/claude-code-subagent-patterns/
faq:
  - q: "What exactly is a subagent in Claude Code, and how is it different from running another instance of the CLI?"
    a: "A subagent is a sandboxed Claude conversation spawned from within an active Claude session via the Agent (Task) tool. The parent only sees the subagent's final report — not the intermediate tool calls, file reads, or thinking. This is the key difference from launching a second CLI: the parent's context window is protected from the subagent's exploration noise. Subagents are spawned for parallel research, deep code exploration, and isolated experiments where you don't want the parent's working memory polluted."
  - q: "When should I NOT use a subagent and just keep working in the parent session?"
    a: "Skip subagents for trivial lookups where the parent already has the file open or the context loaded, for sequential edits where you need to see each intermediate state, and for tightly-coupled changes where the subagent would need to communicate back-and-forth (subagents are one-shot — they return a single report). The rule of thumb: if you can answer it in three or fewer tool calls from your current state, do it inline."
  - q: "How do I run multiple subagents in parallel safely?"
    a: "Invoke them in a single message with multiple Agent tool calls. The harness fans them out concurrently. Safety considerations: pass disjoint scopes (e.g., 'subagent A audits /auth/, B audits /payments/'), avoid having two subagents write to the same file, and use git worktrees when subagents need to make non-trivial edits to overlapping code (each worktree gives a subagent its own working tree to avoid interference)."
  - q: "What's the failure mode I should watch for with subagent-driven development?"
    a: "Subagents return summaries — they describe what they intended to do, not necessarily what they did. The most common failure is treating the subagent's report as ground truth without verification. Always check the actual file changes (git diff) or test results, not the prose summary. A subagent claiming 'I refactored the auth module' might have made shallow edits that pass type-checking but break runtime behavior."
  - q: "Can I build my own specialized subagents, or am I stuck with the built-in ones?"
    a: "Claude Code supports custom agent definitions through the Agent SDK and agent frontmatter files. You can ship a team-specific 'database-migration-reviewer' or 'security-auditor' as a markdown file with a description, system prompt, and tool allowlist. When the parent agent decides to delegate, it can pick your custom type. This is how teams encode review checklists, compliance gates, and domain expertise into reusable agent personalities."
  - q: "How does Claude Code subagent pricing work — am I paying separately for each one?"
    a: "Each subagent invocation consumes tokens like any other Claude conversation. The cost is roughly the subagent's full context (system prompt + tools schema + task prompt + thinking + final report). For Pro and Max plans, subagent usage counts against the same usage allowance as the parent session. For API users, the cost is straightforward per-token billing. The savings come from offloading exploration that would otherwise bloat your parent context — you pay for the subagent, but your main session stays fast and focused."
---

## Introduction

Single-threaded AI coding hit a wall in late 2025. You'd ask Claude to "refactor the payments module," it would read 30 files, fill up its context window with exploration, and then start making edits with half the working memory it needed. Half a year and one paradigm shift later, the answer turned out to be embarrassingly simple: **stop doing everything in one conversation**.

This article walks through five Claude Code subagent patterns that have proven their worth in daily production use — across solo indie dev workflows, multi-engineer teams, and AI-assisted research pipelines. Each pattern includes the actual prompt shape, the failure mode it avoids, and the tradeoffs you accept by adopting it. None of these are theoretical. They're the patterns we use to ship faster without burning out our context windows.

If you're already using Claude Code via the [official CLI](https://docs.anthropic.com/en/docs/claude-code) and want to graduate from "one big conversation" to coordinated multi-agent workflows, this is the playbook. Compare with the [Superpowers framework](/resources/llm-frameworks/superpowers/) and [Aider's solo-agent model](/vs/claude-code-vs-aider/) to see how the subagent approach differs philosophically.

## Pattern 1: Parallel Research Fan-Out

**Problem.** You need to answer "where in the codebase do we handle X?" and "what's our pattern for Y?" and "are there any usages of deprecated function Z?" — three independent questions. Doing them sequentially in your parent conversation means three rounds of file reads and three context-window injections. By the time you have all three answers, your parent has 40k tokens of grep output and no headroom for the actual work.

**Pattern.** Spawn three Explore subagents in parallel, one per question. Each runs in its own sandboxed context. Each returns a short report. Your parent sees three concise paragraphs instead of three grep dumps.

```
Single message → 3 Agent tool calls:
  - Agent("Find auth handlers", subagent_type="Explore", prompt="...")
  - Agent("Map state management", subagent_type="Explore", prompt="...")
  - Agent("Find deprecated fn Z usages", subagent_type="Explore", prompt="...")
```

**Failure mode it avoids.** Context window bloat. Your parent stays light and can hold the actual implementation conversation.

**Tradeoff.** You pay for three subagent invocations instead of one parent conversation. For non-trivial searches the math wins — Explore subagents fan out across many tools and return only the synthesized answer.

## Pattern 2: Worktree Isolation for Risky Edits

**Problem.** You want a subagent to try a refactor, but if it goes sideways you don't want to manually `git reset --hard`. You also want the subagent to be able to run tests without interfering with your active changes in the main worktree.

**Pattern.** Use the worktree isolation parameter on the Agent invocation. The subagent operates in a temporary git worktree branched off your current state. If it makes changes, you get back the worktree path and can review, cherry-pick, or discard at your leisure. If it makes no changes, the worktree is auto-cleaned.

```
Agent({
  description: "Try the controller-level refactor",
  isolation: "worktree",
  prompt: "Refactor controllers/orders.rb to extract the validation logic..."
})
```

**Failure mode it avoids.** Half-done refactors that contaminate your working tree before you've had a chance to evaluate.

**Tradeoff.** Some scenarios — like adding a single function that the parent needs to immediately call — don't benefit from worktree isolation because you'd just have to merge back anyway. Reserve this for exploratory or risky changes.

## Pattern 3: Specialist Delegation

**Problem.** Code review, security audits, accessibility audits, and SQL query optimization all benefit from a focused mindset that's hard to maintain when you're also writing the feature. Generic Claude is good at all of these, but specialized prompting is better.

**Pattern.** Use the `subagent_type` parameter to delegate to specialists. A `code-reviewer` subagent reads the diff and reports findings with confidence levels. A security-auditor reads the same diff with threat-modeling glasses on. You stay in your parent conversation building the feature.

```
Agent({
  description: "Independent code review",
  subagent_type: "code-reviewer",
  prompt: "Review the changes on branch feat/payment-gateway. I want a second
   opinion on the retry logic — I've checked idempotency but want
   independent verification. Report: is this safe under concurrent failures?"
})
```

**Failure mode it avoids.** The "I wrote it so it must be right" blind spot. A separate agent with no context from your conversation is genuinely independent.

**Tradeoff.** Specialists have narrower toolkits than the general-purpose agent. Don't ask a code-reviewer to also generate the migration script.

## Pattern 4: Context Window Protection on Long Sessions

**Problem.** You're four hours into a debugging session. Your parent context is heavy with stack traces, log dumps, and dead-end hypothesis branches. You need to "go check something" that requires reading 8 files. Doing it inline will tip you into compression and you'll lose the load-bearing context that holds your debugging state together.

**Pattern.** Treat your parent session as the strategic layer and push every exploratory dive to a subagent. The parent says "go figure out X" — the subagent returns "the answer is Y, here's the one-line evidence." Your debugging state stays intact.

This is the pattern that pays for itself the fastest. A two-hour debugging session that would have hit context compression at hour 1 can run cleanly for the full duration when exploration is offloaded.

**Failure mode it avoids.** Premature context compression mid-debug, which often drops the original symptom or the key reproduction step.

**Tradeoff.** You lose the ability to "see" the exploration. If the subagent's report is incomplete you have to spawn another one with a tighter prompt rather than asking a follow-up.

## Pattern 5: Pipeline Orchestration with Custom Agents

**Problem.** Your team has a documented review checklist with eight steps. Junior engineers skip steps 3, 5, and 7 when in a hurry. You want the checklist enforced without becoming the PR-review police.

**Pattern.** Codify the checklist as a custom subagent in your repo. Anyone with Claude Code installed can invoke it. The checklist becomes executable: it produces a structured report against each step.

```
.claude/agents/migration-reviewer.md  # custom subagent definition
.claude/agents/security-gate.md
.claude/agents/perf-budget-checker.md
```

When a team member runs the orchestrator, it can fan out to all three: migration-reviewer audits SQL, security-gate audits auth touches, perf-budget-checker audits anything that touches the request hot path. Each returns a structured report. The orchestrator aggregates.

**Failure mode it avoids.** Drift between "the team's review standards" and "what actually gets checked when someone's in a hurry."

**Tradeoff.** Custom agents are version-controlled artifacts. They need maintenance like any other code. Schedule a quarterly review or they rot.

## The Underlying Principle

All five patterns share one design intuition: **your parent conversation is a scarce resource, and subagents are the way to spend without exhausting it**. The parent is where the model is doing the thinking that matters. Subagents are how it gets the inputs without paying for them out of its working memory.

This is the opposite of the "one super-agent does everything" instinct that dominated 2024-early 2025. That model collapsed under context pressure. The 2026 answer is delegated specialization with strict information boundaries — a small council instead of a single mind.

## Setting Up Production-Ready Claude Code

To run multi-agent workflows at scale you need three pieces of infrastructure:

1. **A reliable host for long-running sessions.** If you're running Claude Code in CI or against a server-side codebase, you need a VPS that won't drop your SSH session or get throttled. **{{< aff "htstack" "footer-cta" "HTStack" >}}** — Hong Kong VPS with low-latency access from mainland China and stable BGP routing. Same IDC that hosts dibi8.com, so we run our own multi-agent pipelines on it. Solid value tier for $5-12/month.

2. **A cloud playground for parallel experiments.** When you're fanning out 6+ subagents that each need their own worktree, you want spare CPU. **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — $200 free credit for 60 days across 14+ global regions. Indie devs use this to host Claude Code orchestrators alongside their main app without resource contention.

3. **A skills bundle.** If you're new to Claude Code subagents, the steepest part of the curve is writing custom agent definitions that don't fall over. We packaged five battle-tested skills as a $19 bundle on Gumroad — see the floating CTA in the corner — including the orchestrator prompts that ship the patterns above.

## Related Reading

- [OpenAI Codex CLI vs Claude Code](/vs/openai-codex-cli-vs-claude-code/) — How Codex's solo-agent approach compares to Claude Code's subagent model.
- [Gemini CLI vs Claude Code](/vs/gemini-cli-vs-claude-code/) — Gemini's parallel research strategy vs Claude Code subagent fan-out.
- [Cursor vs Claude Code](/vs/cursor-vs-claude-code/) — IDE-embedded agent vs CLI-driven orchestrator.
- [MCP Servers 2026 Rankings](/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/) — How MCP servers extend subagent capability beyond the bundled tool set.
- [AI Coding Agent Landscape](/resources/llm-frameworks/ai-coding-agent-landscape-2026-skills-mcp-opensource/) — The broader ecosystem picture.

## Verdict

Subagents are not optional in 2026. If you're still doing every task in a single Claude conversation, you're paying for the privilege of premature context compression and lost reasoning state. The five patterns above — parallel fan-out, worktree isolation, specialist delegation, context protection, pipeline orchestration — each cost roughly an hour to learn and each saves multiples of that per week.

Start with Pattern 1 (parallel research fan-out) — it's the lowest friction adoption point and the gains are immediate. Layer in the others as your sessions get longer and your tasks get heavier.

The instinct to "just keep typing into the main session" dies hard. Override it. Spawn the subagent.
