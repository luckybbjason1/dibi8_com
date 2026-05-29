---
title: 'Multi-Agent Pipeline Postmortem: 5 Ways Subagent Orchestration Goes Wrong (2026)'
description: 'Five real failure modes of Claude Code multi-agent pipelines — trusting unverified reports, context bleed, runaway fan-out, silent truncation, and orphaned worktrees — each with the symptom, the root cause, and the fix.'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'Git', 'CLI']
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
tags: ['claude-code', 'subagents', 'multi-agent', 'agent-sdk', 'debugging', 'llm-frameworks', 'developer-tools']
aliases:
- /posts/multi-agent-pipeline-postmortem/
faq:
  - q: "What's the single most common multi-agent failure?"
    a: "Trusting a subagent's report without verifying its actual output. Subagents return a prose summary of what they intended to do — not a guaranteed record of what they did. The classic failure is an orchestrator that reads 'I refactored the auth module and all tests pass,' marks the step done, and moves on — when in reality the subagent made shallow edits that type-check but break at runtime, and never actually ran the tests. Always verify against ground truth: git diff, test exit codes, a re-read of the file. The summary is a claim, not evidence."
  - q: "How do I stop two subagents from corrupting each other's work?"
    a: "Give them disjoint scopes, and use git worktrees when they make non-trivial edits. The corruption happens when two agents write to the same file or assume a shared working-tree state that the other one changed underneath them. The fix is isolation: scope agent A to /auth/ and agent B to /payments/ with no overlap, or hand each a worktree so they operate on independent checkouts. Never let two writers share one working tree."
  - q: "My multi-agent run cost 10x what I expected. What happened?"
    a: "Runaway fan-out. Either you spawned far more agents than the work justified, or you put agent-spawning inside a loop with no convergence condition and it kept going. The fix is a budget and a stop condition: cap the number of agents per phase, and for discovery loops use a 'stop after K rounds with nothing new' rule instead of 'keep going until done.' Every subagent is a full context's worth of tokens — fan out deliberately, not reflexively."
  - q: "Why did my pipeline report success but miss obvious findings?"
    a: "Silent truncation. A finder agent capped its results at the top N, or sampled instead of sweeping, and nobody logged that work was dropped. The orchestrator then reports 'audit complete' when it actually audited 60% of the surface. The fix is to make truncation loud: if an agent bounds its coverage, it must say so in its report, and the orchestrator must surface 'N items not examined' rather than silently presenting partial results as complete."
  - q: "What goes wrong with git worktrees in agent pipelines?"
    a: "Orphaned worktrees and leaked state. A subagent given worktree isolation makes changes, the orchestrator reads the result, but nobody cleans up — so you accumulate stale worktrees, and worse, a later agent reads a half-finished worktree thinking it's the main tree. The fix: treat worktrees as scoped resources. Auto-clean on no-change, explicitly review-and-merge or discard on change, and never let a downstream agent read another agent's worktree as if it were canonical state."
  - q: "Is multi-agent orchestration worth the complexity if it fails this often?"
    a: "Yes, when the task genuinely exceeds one context window or needs independent verification — but these five failures are exactly why you don't reach for it reflexively. A single well-prompted agent beats a buggy five-agent pipeline every time. Use orchestration when the problem is real (comprehensive coverage, parallel independent work, adversarial review), and when you do, build in the verification and stop conditions that prevent these failure modes. Complexity you can't verify is worse than simplicity you can."
---

## Introduction

Multi-agent orchestration is the most powerful — and the most quietly dangerous — pattern in Claude Code. When it works, you sweep a codebase in parallel, get independent review, and tackle problems one context window could never hold. When it fails, it fails *silently*: the pipeline reports success, you ship, and the bug it was supposed to catch is already in production.

This is a postmortem of the five failure modes we've actually hit running agent pipelines in production. Each one comes with the symptom you'll see, the root cause underneath it, and the fix. If you've read [Subagent Patterns](/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) and [Custom Agent Authoring](/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/) and you're now running real orchestration, this is the piece that keeps you out of the ditch.

## Failure 1: The Trust Trap

**Symptom.** Your orchestrator reports "auth module refactored, all tests pass." You ship. Runtime breaks immediately on a path the "passing tests" never covered.

**Root cause.** A subagent returns a *summary* — a description of what it intended to do, not a verified record of what it did. "All tests pass" might mean it ran them, or it might mean it believes they would pass. The orchestrator treated prose as ground truth.

**The fix.** Verify against artifacts, never against the summary. After a subagent claims a change, the orchestrator reads the actual `git diff`, checks the test command's exit code, or re-reads the file. We learned this one the hard way — and it's why, when we [wrote a 4-language article using a translation subagent](/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/), we ran `npm run build` as ground truth instead of trusting the agent's "YAML valid: yes." The summary is a claim. The build is evidence.

## Failure 2: Context Bleed

**Symptom.** Two subagents run in parallel. One's edits vanish, or the file ends up with garbled half-merges from both.

**Root cause.** Both agents wrote to the same file, or each assumed a working-tree state the other changed underneath it. Parallel writers sharing one working tree is a race condition with extra steps.

**The fix.** Disjoint scopes and worktree isolation. Scope agent A to `/auth/`, agent B to `/payments/`, with zero overlap. When agents make non-trivial edits, hand each its own git worktree so they operate on independent checkouts and you merge deliberately afterward. Never let two writers share one tree.

## Failure 3: The Runaway Fan-Out

**Symptom.** A run that should have cost a few thousand tokens cost 10x that. Or the pipeline never finished — it kept spawning agents.

**Root cause.** Agent-spawning inside a loop with no convergence condition, or fanning out far more workers than the work justified. Every subagent is a full context's worth of tokens; reflexive fan-out multiplies cost fast.

**The fix.** A budget and a stop condition. Cap agents per phase. For discovery loops ("find all the bugs"), use "stop after K consecutive rounds that surface nothing new" instead of an open-ended "keep going." Fan out deliberately, with a number you chose on purpose. This matters doubly when you're watching costs — see how the [token math actually works](/resources/dev-utils/ai-coding-agent-monthly-bill-2026-real-receipts/) before you scale a pipeline.

## Failure 4: Silent Truncation

**Symptom.** The pipeline reports "security audit complete — no issues found." A week later an obvious injection bug surfaces in code the audit supposedly covered.

**Root cause.** A finder agent capped results at the top N, or sampled instead of sweeping the full surface — and *nobody logged that anything was dropped*. The orchestrator presented 60% coverage as 100%.

**The fix.** Make truncation loud. If an agent bounds its coverage — top-N, sampling, a time cap — it must say so in its report, explicitly: "examined 18 of 30 endpoints; 12 not checked." The orchestrator surfaces that gap instead of swallowing it. Partial results presented as complete are worse than an honest "I didn't finish."

## Failure 5: The Orphaned Worktree

**Symptom.** Stale git worktrees pile up. Worse: a later agent reads a half-finished worktree as if it were the canonical main tree, and builds on a fiction.

**Root cause.** Worktrees created for isolation but never treated as scoped resources. No cleanup on completion; no clear ownership of which tree is canonical.

**The fix.** Treat every worktree as a resource with a lifecycle. Auto-clean when an agent makes no changes. On changes, explicitly review-and-merge or discard — don't leave it dangling. And never let a downstream agent read another agent's worktree as ground truth; the canonical state is the main tree, full stop. (We've personally cleaned up an orphaned worktree mid-pipeline — it's a five-second `git worktree remove` that saves an hour of "why is this file wrong.")

## The Principle

Every one of these failures shares a root: **treating an agent's claim as if it were verified reality.** The summary that wasn't checked, the scope that wasn't isolated, the loop that wasn't bounded, the truncation that wasn't logged, the worktree that wasn't owned. Multi-agent orchestration doesn't fail because the agents are dumb — it fails because the *orchestrator* trusted without verifying. Build verification and explicit bounds into every seam, and the pipeline becomes as reliable as it is powerful.

## Setting Up Production-Ready Claude Code

Reliable pipelines want infrastructure that won't add failures of its own:

1. **A stable host for long pipelines and CI gates.** A dropped SSH session mid-orchestration is its own failure mode. **{{< aff "htstack" "footer-cta" "HTStack" >}}** — Hong Kong VPS, low-latency mainland-China access, stable BGP. Same IDC that hosts dibi8.com, where we run these pipelines. $5-12/month.

2. **Cloud headroom for parallel fan-out.** When you (deliberately, with a budget) fan out workers, spare CPU keeps them from contending. **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — $200 free credit for 60 days, 14+ regions.

3. **A skills bundle.** Avoiding these five failures is mostly about prompt discipline — verification steps, stop conditions, scoped resources. We packaged five battle-tested skills as a $19 bundle on Gumroad — see the floating CTA in the corner — including orchestrator prompts with the verification seams already built in.

## Related Reading

- [Subagent Patterns](/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) — the five workflows these failures lurk inside.
- [Custom Agent Authoring](/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/) — building reliable workers with output contracts.
- [Subagent vs MCP vs Skill](/resources/llm-frameworks/claude-code-subagent-vs-mcp-server-skill-agent-2026/) — picking the right extension so you don't over-build.
- [AI Coding Agent Monthly Bill](/resources/dev-utils/ai-coding-agent-monthly-bill-2026-real-receipts/) — the token math behind runaway fan-out.

## Verdict

Multi-agent orchestration is worth it when the task genuinely exceeds one context window or needs independent verification — but reach for it deliberately, not reflexively. A single well-prompted agent beats a buggy five-agent pipeline every time. When you do orchestrate, the difference between power and disaster is one habit: **verify every claim against ground truth, and bound every loop.** Complexity you can't verify is worse than simplicity you can.
