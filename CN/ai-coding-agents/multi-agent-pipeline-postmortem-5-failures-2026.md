---


title: "Multi-Agent Pipeline Postmortem: 5 Ways Subagent Orchestration Goes Wrong (2026)"
description: "Technical guide and comparison"
date: 2026-09-20
slug: "multi-agent-pipeline-postmortem-5-failures-2026"
category: "ai-tools"
tags: ["ai", "tools"]

categories: ["ai-coding-agents"]
---


title: "Multi-Agent Pipeline Postmortem: 5 Ways Subagent Orchest...
description: "Technical guide and comparison"
date: 2026-05-28T00:00:00+08:00
lastmod: 2026-05-29T00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', Git, CLI]
application_domain: LLM Frameworks
source_version: ''
licensing_model: Commercial (Anthropic)
license_type: Proprietary
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
last_maintained: "2026-05-28"
draft: false
categories: ["llm-frameworks"]
tags: ["claude-code", "subagents", "multi-agent", "agent-sdk", "debugging", "llm-frameworks", "developer-tools"]
aliases:
  - /posts/multi-agent-pipeline-postmortem/
faq: - q: "What's the single most common multi-agent failure?"
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
