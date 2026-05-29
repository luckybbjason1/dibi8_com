---
title: 'Claude Code Skill Authoring: How to Package Procedures Claude Loads Only When Relevant (2026)'
description: 'A complete guide to authoring Claude Code skills — SKILL.md structure, the trigger description that controls loading, progressive disclosure, and when a skill beats CLAUDE.md or a subagent. With worked examples and the mistakes to avoid.'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'Markdown', 'YAML']
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
tags: ['claude-code', 'skills', 'agent-sdk', 'ai-coding-agents', 'llm-frameworks', 'developer-tools', 'prompt-engineering']
aliases:
- /posts/claude-code-skill-authoring/
faq:
  - q: "Where do skills live and what's the minimum a SKILL.md needs?"
    a: "A skill is a directory under .claude/skills/<name>/ (project-scoped) or ~/.claude/skills/<name>/ (user-scoped), containing a SKILL.md file. The minimum is YAML frontmatter with a name and a description, followed by the instructions in the body. The directory can also hold supporting files — reference docs, scripts, templates — that the skill points to, but SKILL.md with those two frontmatter fields is the irreducible core."
  - q: "What's the difference between a skill and just putting instructions in CLAUDE.md?"
    a: "CLAUDE.md loads on every single interaction — it's for always-on, project-wide rules. A skill loads only when its description matches the task at hand. Use CLAUDE.md for 'always use tabs, never commit to main directly.' Use a skill for situational procedures like 'how to cut a release' or 'how to debug a flaky test' — knowledge you don't want bloating every prompt, only present when you're actually doing that thing. The skill keeps your base context lean."
  - q: "How does the description field control when a skill loads?"
    a: "The description is the trigger signal. Claude reads skill descriptions to decide which skill is relevant to the current task, then loads that skill's full body into context. So the description must describe WHEN to use the skill with concrete cues — 'Use when cutting a release, publishing a version, or tagging a build' — not just what it is. A vague description ('release helper') means the skill exists but never fires at the right moment."
  - q: "What is progressive disclosure and why does it matter for skills?"
    a: "Progressive disclosure means the skill loads its lightweight SKILL.md first, and only pulls in heavier supporting files (detailed references, large templates, scripts) when the task actually needs them. You keep SKILL.md short and point to references/big-spec.md for the deep detail. This protects context: the trigger and the overview are cheap to load for routing, and the expensive detail only enters the conversation once the skill is genuinely engaged."
  - q: "Can a skill include scripts or just instructions?"
    a: "Both. A skill directory can bundle scripts (a Python helper, a shell script), templates, and reference documents alongside SKILL.md. The body can instruct Claude to run a bundled script or read a bundled reference. This is how a skill becomes more than a prompt — it's a packaged capability with its instructions, its reference material, and its executable helpers all version-controlled together in one directory."
  - q: "When should I write a subagent instead of a skill?"
    a: "Write a skill when you need to teach a procedure that runs in the current conversation. Write a subagent when the work needs its own context window — heavy exploration, parallel research, or independent review that would otherwise bloat the parent. They compose: a subagent can load a skill to follow your methodology while running in isolation. The rule of thumb from the extension-decision framework — skill changes behavior, subagent protects context, MCP server adds capability."
---

## Introduction

In [Subagent vs MCP vs Skill](/resources/llm-frameworks/claude-code-subagent-vs-mcp-server-skill-agent-2026/) we drew the three-axis map: skills move the **knowledge** axis, subagents move **context**, MCP servers move **capability**. We've since published deep guides on the subagent axis — [authoring custom agents](/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/) and the [orchestration failure modes](/resources/llm-frameworks/multi-agent-pipeline-postmortem-5-failures-2026/). This guide completes the trio: how to author the **skill** itself.

Skills are the most underrated of the three because they look trivial — "it's just a markdown file." But a well-authored skill is the difference between knowledge that's *there when you need it* and a `CLAUDE.md` so bloated that every prompt drags 4,000 tokens of rules nobody's task needs right now. We'll cover the SKILL.md structure, the trigger description that decides everything, progressive disclosure for keeping it light, two worked examples, and the mistakes that make skills never fire.

## What a Skill Actually Is

A skill is a **directory**, not just a file:

```
.claude/skills/cut-release/
  SKILL.md            # frontmatter + instructions
  references/
    versioning.md     # heavy detail, loaded on demand
  scripts/
    bump-version.sh    # an executable the skill can run
```

The `SKILL.md` is the entry point. Its frontmatter declares the skill's identity and — critically — *when it should load*. The body holds the procedure. Supporting files (references, templates, scripts) live alongside and get pulled in only when needed. Skills live in `.claude/skills/` (project, shared with the team) or `~/.claude/skills/` (user, every project on your machine).

## Skill vs CLAUDE.md: The Loading Question

This is the decision that trips people up. Both hold instructions; the difference is *when they load*.

- **CLAUDE.md** loads on **every** interaction. It's for always-on, project-wide invariants: "use tabs," "never force-push main," "our API base is X."
- **A skill** loads **only when its description matches** the current task. It's for situational procedures: "how to cut a release," "how to onboard a new service," "our incident runbook."

The test: *would this instruction apply to a random prompt about anything?* If yes → CLAUDE.md. If it only matters during a specific kind of task → skill. Stuffing situational playbooks into CLAUDE.md is the #1 context-bloat mistake; every prompt pays for knowledge it doesn't need.

## The Frontmatter: Name and Description

```markdown
---
name: cut-release
description: Use when cutting a release, publishing a new version, tagging a build, or preparing release notes. Walks through version bump, changelog, tag, and publish steps.
---

You are helping cut a release. Follow these steps in order...
```

### `name`

Kebab-case, descriptive. This is the skill's identity.

### `description` — the trigger signal that decides everything

Claude reads skill descriptions to route: it scans them, decides which skill fits the current task, and loads that skill's body. So the description is not a label — it's a **when-to-fire condition**. Pack it with concrete triggers:

> ❌ `description: Release helper.`
> ✅ `description: Use when cutting a release, publishing a version, tagging a build, or writing release notes. Covers version bump, changelog generation, git tag, and publish.`

The first never fires because nothing in a real task matches "release helper." The second fires the moment the user says "let's ship 2.4.0." If your skill exists but never activates, the description is the culprit — every time.

## Writing the Body: A Procedure, Not an Essay

The body is the instructions Claude follows once the skill loads. Three rules:

1. **Be a procedure, not prose.** Numbered steps the model executes in order beat paragraphs of context. "1. Bump the version in package.json. 2. Regenerate the changelog from commits since the last tag. 3. ..." 
2. **State preconditions and gotchas inline.** "Before tagging, confirm CI is green on main" — the kind of thing a human would know to check.
3. **Point to heavy detail, don't inline it.** If the versioning policy is 800 words, put it in `references/versioning.md` and write "for the version-bump rules, read references/versioning.md." That's progressive disclosure, next.

## Progressive Disclosure: Keep SKILL.md Light

The power move in skill authoring. SKILL.md should be **small** — the trigger plus an overview plus pointers. The heavy material lives in supporting files that load only when the task reaches them.

Why it matters: the description and overview need to be cheap, because they're scanned for routing. The detailed 2,000-word spec only belongs in context once the skill is actually engaged and the task needs that depth. A skill that inlines everything defeats the purpose — you're back to CLAUDE.md-style bloat, just triggered differently.

```markdown
## Steps
1. Bump version (see references/versioning.md for the semver rules)
2. Run scripts/changelog.sh to generate the draft
3. ...
```

Claude reads `references/versioning.md` only when it actually needs the rules, not on every load.

## Worked Example: A Release Checklist Skill

```markdown
---
name: cut-release
description: Use when cutting a release, publishing a version, or tagging a build. Covers version bump, changelog, tag, publish, and the green-CI precondition.
---

You are cutting a release. Do NOT skip the precondition check.

PRECONDITION: confirm CI is green on main. If not, stop and report.

Steps:
1. Determine the new version (semver; see references/versioning.md).
2. Bump it in package.json and any version constants.
3. Generate the changelog from commits since the last tag.
4. Open a release PR; wait for review.
5. After merge: tag, push the tag, publish.

Report which step you stopped at if anything blocks.
```

The precondition and the "report where you stopped" line are what make it production-grade — not just steps, but the guardrails a careful human applies.

## Worked Example: A Domain Playbook Skill

```markdown
---
name: debug-flaky-test
description: Use when a test passes sometimes and fails other times, or when investigating CI flakiness, intermittent failures, or race conditions in the suite.
---

You are diagnosing a flaky test. Flakiness is almost always one of:
shared state, timing/async, test-order dependence, or external resources.

1. Reproduce: run the test 20x in isolation and 20x with the full suite.
   Different results = test-order or shared-state dependence.
2. Check for unawaited async, real timers, and fixed sleeps.
3. Check for shared mutable state between tests.
4. Only after locating the cause, propose the fix. Do not "add a retry."
```

Note the embedded domain knowledge (the four usual causes) — that's institutional expertise, packaged so anyone triggers the senior engineer's mental checklist.

## Common Authoring Mistakes

- **Vague description.** The skill exists but never fires. Add concrete trigger phrases — the words a user actually types when they need it.
- **Everything in CLAUDE.md.** Situational procedures bloating every prompt. Move them to skills.
- **Inlining heavy detail.** A 2,000-word SKILL.md. Use progressive disclosure — point to `references/`.
- **Prose instead of procedure.** A skill that reads like an essay. Number the steps.
- **No guardrails.** Steps with no preconditions or stop conditions. Add the checks a careful human would make.

## The Principle

A skill is **just-in-time expertise**. CLAUDE.md is what's true always; a skill is what's true *when you're doing this specific thing*. The art is in the description (so it fires at the right moment) and in progressive disclosure (so it stays cheap until it's needed). Get those two right and your team's procedures stop living in wikis nobody opens — they show up, fully loaded, exactly when the task calls for them, and stay out of the way otherwise.

## Setting Up Production-Ready Claude Code

Skills shine most in a stable, shared environment:

1. **A reliable host for team-shared, CI-invoked workflows.** Skills are version-controlled and run in CI too. **{{< aff "htstack" "footer-cta" "HTStack" >}}** — Hong Kong VPS, low-latency mainland-China access, stable BGP. Same IDC that hosts dibi8.com. $5-12/month.

2. **Cloud headroom for parallel runs.** **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — $200 free credit for 60 days, 14+ regions.

3. **A skills bundle.** The fastest way to write great skills is to read great ones. We packaged five battle-tested skills as a $19 bundle on Gumroad — see the floating CTA in the corner — with the descriptions, progressive-disclosure structure, and bundled scripts already done right.

## Related Reading

- [Subagent vs MCP vs Skill](/resources/llm-frameworks/claude-code-subagent-vs-mcp-server-skill-agent-2026/) — the three-axis framework this completes.
- [Custom Agent Authoring](/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/) — the subagent-axis sibling to this guide.
- [AI Agent Skills 2026 Developer Guide](/resources/llm-frameworks/ai-agent-skills-2026-developer-guide/) — the broader skills ecosystem.
- [Subagent Patterns](/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) — how skills compose with delegated workers.

## Verdict

Skills are the cheapest, most underrated extension point — a directory with a markdown file that turns situational expertise into just-in-time context. The whole craft reduces to two things: a **description** packed with the real trigger phrases so it fires at the right moment, and **progressive disclosure** so it stays light until the task needs its depth. Write those two well and you've packaged a procedure your whole team — and every CI run — gets for free, exactly when it's relevant. That completes the trio: skill for knowledge, subagent for context, MCP server for capability.
