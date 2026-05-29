---
title: 'Claude Code Custom Agent Authoring: Build Reusable Subagents That Enforce Your Standards (2026)'
description: 'A complete guide to authoring custom Claude Code subagents — frontmatter fields, system prompt design, tool allowlists, and two production-ready examples (migration reviewer, security gate) with the mistakes to avoid.'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'CLI', 'Markdown', 'YAML']
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
tags: ['claude-code', 'subagents', 'custom-agents', 'agent-sdk', 'ai-coding-agents', 'llm-frameworks', 'developer-tools']
aliases:
- /posts/claude-code-custom-agent-authoring/
faq:
  - q: "Where do custom agent definition files live, and what format are they?"
    a: "Custom agents are Markdown files with YAML frontmatter, stored in .claude/agents/ in your project (or ~/.claude/agents/ for ones you want available across every project). The filename minus the .md extension is not the agent's identity — the name field in the frontmatter is. The frontmatter declares name, description, an optional tools allowlist, and an optional model; everything below the closing --- is the agent's system prompt."
  - q: "What's the difference between the description field and the system prompt body?"
    a: "The description is the routing signal: it's what the parent agent reads when deciding whether to delegate to this subagent, so it must say WHEN to use the agent, not just what it is. The system prompt body is the instruction set the subagent runs under once it's invoked — its role, its method, its output contract. A great description with a vague body gets invoked at the right time but does mediocre work; a great body with a vague description does excellent work that never gets triggered."
  - q: "Should I give my custom agent access to all tools or restrict them?"
    a: "Restrict them. Omitting the tools field grants the full inherited toolset, which is convenient but risky for agents that should never write or execute — a code-reviewer with Write and Bash access can 'helpfully' apply its own suggestions, defeating the point of an independent review. Declare the minimum: a reviewer gets Read, Grep, Glob; a migration auditor gets those plus a read-only database query tool if you have one. Least privilege makes the agent's behavior predictable."
  - q: "How do I test a custom agent without polluting a real project?"
    a: "Create a throwaway branch or a git worktree with a known-bad example (a migration with a missing index, an auth change with a logic hole) and invoke the agent against it. You're checking two things: does it get triggered by a natural request (description quality), and does it catch the planted problem (system prompt quality). Iterate on the frontmatter and body separately — they fail for different reasons."
  - q: "Can a custom agent call other subagents, or spawn its own?"
    a: "No. Subagents are one level deep — a subagent cannot spawn further subagents. This is a deliberate guardrail against runaway fan-out. If you need multi-stage orchestration, the parent (top-level) agent coordinates: it calls agent A, reads the result, then calls agent B. Design your custom agents as single-purpose workers that return a structured report, and let the orchestrator at the top sequence them."
  - q: "Do custom agents work in CI and headless runs, or only interactively?"
    a: "They work in both. The same .claude/agents/ definitions are picked up when you run Claude Code non-interactively (the -p / print mode used in CI). Because they're version-controlled files in your repo, every teammate and every CI job sees the identical agent definitions — that's the whole point of codifying a review checklist as an agent rather than a wiki page everyone forgets to open."
---

## Introduction

In [Claude Code Subagent Patterns](/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) we covered five workflows for spending your context window wisely — and the fifth, **pipeline orchestration with custom agents**, is the one teams ask about most. "Codify your review checklist as a subagent" sounds great until you open an empty `.claude/agents/migration-reviewer.md` and a blinking cursor.

This guide is the missing manual. We'll walk through the anatomy of a custom agent definition, what each frontmatter field actually controls, how to write a system prompt that produces a structured report instead of a chatty ramble, why tool allowlists matter more than they look, and two complete, production-ready examples you can copy today. Then the mistakes — because the failure modes here are subtle and they cost you trust in the agent the first time it misses something obvious.

If you've never delegated to a subagent before, read the [patterns piece](/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) first. If you have, and you're ready to ship your own, this is the playbook.

## Anatomy of a Custom Agent

A custom agent is a single Markdown file with YAML frontmatter. It lives in one of two places:

- `.claude/agents/<name>.md` — project-scoped, version-controlled, shared with your whole team
- `~/.claude/agents/<name>.md` — user-scoped, available across every project on your machine

The structure is dead simple:

```markdown
---
name: migration-reviewer
description: Reviews database migrations for safety. Use when a PR touches db/migrate/, schema files, or any SQL DDL.
tools: Read, Grep, Glob
model: sonnet
---

You are a database migration reviewer. Your job is to catch unsafe
migrations before they reach production...
```

Everything above the closing `---` is configuration. Everything below it is the **system prompt** — the persona and instruction set the subagent runs under. That's the entire contract. No build step, no registration, no plugin manifest. Drop the file in, run `/agents` to confirm Claude Code picked it up, and it's invokable.

## The Frontmatter Fields

Four fields do all the work. Three of them are optional, but the defaults are rarely what you want for a serious agent.

### `name` (required)

The agent's identity — this is the string the parent passes as `subagent_type`. Keep it kebab-case and descriptive: `security-auditor`, not `agent2`. The filename is cosmetic; the `name` field is canonical.

### `description` (required — and the one people underweight)

This is **the routing signal**. When the parent agent is deciding whether to delegate, it reads descriptions, not system prompts. So a description must encode *when* to reach for this agent, with concrete triggers:

> ❌ `description: A code reviewer.`
> ✅ `description: Reviews code changes for correctness and security. Use proactively after writing a non-trivial diff, before committing, especially for auth, payments, or concurrency-sensitive code.`

The word "proactively" is load-bearing — it nudges the parent to invoke without being explicitly asked. If your agent never seems to fire, the description is almost always why.

### `tools` (optional — but declare it anyway)

A comma-separated allowlist. Omit it and the agent inherits every tool the parent has. We'll spend a whole section on why that's usually wrong.

### `model` (optional)

Pin a tier: `haiku` for cheap mechanical passes, `sonnet` for balanced review work, `opus` for deep reasoning. A high-volume linter-style agent on `haiku` keeps costs sane; a security auditor where a miss is expensive earns `opus`.

## Writing the System Prompt

The body is where most agents are won or lost. Three rules produce reliable workers:

**1. State the role and the boundary in the first sentence.** "You are a migration reviewer. You do not write code or apply fixes — you report findings." Telling the agent what *not* to do is as important as the job itself.

**2. Specify the output contract.** Vague prompts produce prose; you want structure. Spell it out:

```markdown
Report your findings as a list. For each issue:
- SEVERITY: blocker | warning | nit
- LOCATION: file:line
- PROBLEM: one sentence
- FIX: the concrete change
End with a one-line VERDICT: SAFE TO MERGE or NEEDS CHANGES.
```

**3. Give it a checklist, not a vibe.** "Review for safety" is a wish. Enumerate exactly what to check — the agent will work through your list deterministically, which is the entire value of codifying it.

## Tool Allowlists: Least Privilege for Agents

Here's the trap. Leave `tools` out, and your "reviewer" inherits `Write`, `Edit`, and `Bash`. The first time it finds an issue, it may "helpfully" fix it — mutating your working tree, running commands, and destroying the independence that made the review worth requesting.

The fix is least privilege. Match tools to the job:

| Agent kind | Tools |
| --- | --- |
| Reviewer / auditor | `Read, Grep, Glob` |
| Researcher / explorer | `Read, Grep, Glob, WebSearch, WebFetch` |
| Test runner | `Read, Grep, Glob, Bash` |
| Fixer (rare, deliberate) | `Read, Edit, Bash` |

A read-only reviewer literally *cannot* go rogue. That predictability is what lets you trust its report without re-checking everything it touched. (If you later wire in external systems through [MCP servers](/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/), the same discipline applies — only grant the MCP tools the agent genuinely needs.)

## Worked Example: A Migration Reviewer

```markdown
---
name: migration-reviewer
description: Reviews database migrations for production safety. Use proactively when a change touches db/migrate/, schema.rb, or any SQL DDL file.
tools: Read, Grep, Glob
model: sonnet
---

You are a database migration reviewer. You do NOT edit files or run
migrations — you read the proposed migration and report risks.

Check every migration against this list:
1. Adding a column with a NOT NULL constraint and no default on a large table (locks).
2. Adding an index without CONCURRENTLY (blocks writes).
3. Renaming or dropping a column still referenced by application code.
4. A data backfill running inside the same transaction as the schema change.
5. Missing a corresponding rollback / down path.

Report findings as:
- SEVERITY: blocker | warning | nit
- LOCATION: file:line
- PROBLEM / FIX
End with VERDICT: SAFE TO MERGE or NEEDS CHANGES.
```

Invoke it from the parent with a natural request — "review the migration on this branch" — and because the description names `db/migrate/`, the parent routes there on its own.

## Worked Example: A Security Gate

```markdown
---
name: security-gate
description: Threat-models diffs that touch authentication, authorization, secrets, or user input. Use proactively before merging any auth or payments change.
tools: Read, Grep, Glob
model: opus
---

You are a security reviewer with a threat-modeling mindset. Assume the
input is hostile. You report only — you never modify code.

For the diff, check:
- Authn/authz: can this path be reached without the expected check?
- Injection: is user input concatenated into SQL, shell, or HTML?
- Secrets: any key, token, or password added to code or logs?
- IDOR: are object references scoped to the authenticated user?

For each finding give an EXPLOIT SKETCH (how an attacker triggers it),
then the FIX. Default to flagging when uncertain — false positives are
cheap, a missed auth hole is not.
```

Note the `opus` model and the "default to flagging when uncertain" instruction — for a security gate you tune toward paranoia.

## Testing and Iterating on Agents

Don't ship an agent you haven't tried to fool. Spin up a [git worktree](/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) or a throwaway branch with a *planted* problem — a migration missing `CONCURRENTLY`, an endpoint missing an ownership check — and invoke the agent.

You're testing two independent things:

- **Did it get triggered** by a natural request? If not, fix the `description`.
- **Did it catch the planted bug?** If not, fix the system prompt's checklist.

These fail for different reasons, so iterate on them separately. A common surprise: the agent works perfectly when you name it explicitly but never fires on its own — that's always a description problem, never a body problem.

## Common Authoring Mistakes

- **Vague description.** The agent does great work nobody ever triggers. Add concrete file paths and the word "proactively."
- **No tool allowlist.** Your reviewer edits the code it was supposed to review. Declare `Read, Grep, Glob`.
- **Prose output, no contract.** You get three paragraphs of opinion instead of a triaged list. Specify the exact report format.
- **One mega-agent.** A single "do-everything" agent is just the parent with extra steps. Split by concern — that's the [specialist delegation pattern](/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) working for you.
- **Set-and-forget.** Agents are code. An unmaintained checklist rots as your stack changes. Review them quarterly.

## The Principle

A custom agent is **executable institutional knowledge**. The review standard that used to live in a wiki page nobody opened, or in the head of the one senior engineer who always caught the bug — you encode it once, version-control it, and every teammate plus every CI run gets the identical, tireless reviewer. The agent doesn't get rushed before a deadline and skip steps 3, 5, and 7. That consistency, not raw intelligence, is the win.

## Setting Up Production-Ready Claude Code

To run custom-agent pipelines at scale you want stable infrastructure:

1. **A reliable host for long-running and CI sessions.** Custom agents shine in CI, where they gate every PR. You need a box that won't drop the job. **{{< aff "htstack" "footer-cta" "HTStack" >}}** — Hong Kong VPS with low-latency access from mainland China and stable BGP routing. It's the same IDC that hosts dibi8.com, so we run our own agent pipelines on it. Value tier runs $5-12/month.

2. **Cloud headroom for parallel gates.** When an orchestrator fans out to migration-reviewer + security-gate + perf-checker at once, you want spare CPU. **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — $200 free credit for 60 days across 14+ regions, great for hosting CI runners next to your app.

3. **A skills bundle.** The steepest part of the curve is writing agent definitions that don't fall over. We packaged five battle-tested skills as a $19 bundle on Gumroad — see the floating CTA in the corner — including the orchestrator prompts and three more ready-to-ship agent definitions.

## Related Reading

- [Claude Code Subagent Patterns](/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) — the five workflows; this guide deep-dives pattern 5.
- [Superpowers framework](/resources/llm-frameworks/superpowers/) — a curated skill/agent library to learn from.
- [MCP Servers 2026 Rankings](/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/) — extend agent capability beyond the bundled tools.
- [AI Coding Agent Landscape](/resources/llm-frameworks/ai-coding-agent-landscape-2026-skills-mcp-opensource/) — where custom agents sit in the wider ecosystem.

## Verdict

Custom agents turn your team's best practices from documentation nobody reads into checks that run on every change. The recipe: a sharp **description** so it triggers, a **least-privilege tool allowlist** so it stays in its lane, and a **system prompt with an explicit checklist and output contract** so it produces a report you can act on.

Start with one — the migration reviewer above is the highest-leverage first agent for most teams. Plant a bug, confirm it catches it, then commit the file. From that moment, every teammate has a reviewer that never gets tired and never skips a step.
