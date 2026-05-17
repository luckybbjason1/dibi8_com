---
title: 'Why Your Claude Code Forgets Everything—and the Open-Source Fix That Changes Everything'
description: 'Why Your Claude Code Forgets Everything—and the Open-Source Fix That Changes Everything'
date: 2026-05-17 00:00:00+08:00
lastmod: 2026-05-17 00:00:00+08:00
tech_stack: []
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
last_maintained: '2026-05-17'
featureImage: ''
draft: false
aliases:
- /posts/why-claude-code-forgets-memory-fix/
---

{</* resource-info */>}

**Meta Description:** A hands-on guide to rohitg00/agentmemory and mattpocock/skills, the two GitHub Trending projects ending "session amnesia" in AI coding agents. Learn how to add persistent memory and production-grade skill scaffolds to Claude Code, Cursor, and Codex CLI in under 10 minutes.

**Published:** 2026-05-17
**Tags:** AI agent memory, persistent memory coding agents, agentmemory GitHub, Claude Code MCP server, mattpocock skills, agent skills scaffold, coding agent context loss, 2026 GitHub trending

---

## The 30-Second Problem Statement

You spend twenty minutes briefing Claude Code on your architecture, your error-handling philosophy, and the three files it must never touch. You go to bed. Next morning, new session. Claude starts suggesting `bcrypt` again even though you explicitly ruled it out yesterday. It wants to refactor the module you told it to leave alone. It is, in every meaningful sense, a brand-new intern who has never heard of your project.

This is not a Claude bug. It is a structural limitation of stateless LLM inference. Every session starts from zero. The context window is RAM, not disk—and the power gets cut at the end of every chat.

Two open-source projects, both dominating GitHub Trending in May 2026, are fixing this at the infrastructure layer rather than the model layer. And because both ship under permissive licenses (Apache-2.0 and MIT), you can adopt them without vendor lock-in or usage pricing.

---

## Part I: The Memory Layer—How agentmemory Works Under the Hood

### 1.1 Architecture: Not a Vector DB, a Semantic Extractor

Most developers assume "memory for agents" means plugging in Pinecone or Qdrant and doing RAG. agentmemory deliberately avoids that complexity. Its internal iii engine performs a more precise job: it watches the conversation, scores sentences for memorability, and persists only the facts that will matter in future sessions.

The storage model is three-tiered:

```
┌─────────────────────────────────────────────────────────┐
│              User / Agent Conversation                   │
└────────────────────┬────────────────────────────────────┘
                     │
              ┌──────▼──────┐
              │  iii Engine  │  ← fact extraction + salience scoring
              │   (local)    │
              └──────┬──────┘
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
   ┌─────────┐  ┌──────────┐  ┌───────────┐
   │  Facts  │  │Preferences│  │Constraints│
   │(long-term)│  │(inject on boot)│ │(pre-action guard)│
   └────┬────┘  └─────┬─────┘  └─────┬─────┘
        │             │              │
        └─────────────┼──────────────┘
                      ▼
             ┌──────────────┐
             │ SQLite / JSON │  ← local-first, no network dependency
             │  (on-disk)     │
             └──────────────┘
```

| Tier | What Gets Stored | Retrieval Pattern | Lifetime |
|------|-----------------|-------------------|----------|
| **Facts** | "User prefers Result types over throwing" | Semantic + keyword hybrid | Indefinite |
| **Preferences** | Indentation, naming conventions, linter rules | Injected into system prompt on session start | Until explicitly updated |
| **Constraints** | "NEVER modify auth/middleware.ts" | Pre-action guard check | Until revoked |

This design is deliberately minimalist. agentmemory is not trying to be a knowledge graph or a semantic search platform. It is trying to be the smallest possible unit of persistence that makes an agent feel like a returning teammate rather than a first-day hire.

### 1.2 Installation: npm or Docker, Zero Config

```bash
# One-liner for individual developers
npm install -g agentmemory

# Docker for team-shared memory layer
docker run -d -p 37777:37777 \
  -v agentmemory-data:/data \
  rohitg00/agentmemory
```

The Docker path is particularly interesting for teams. Instead of every developer maintaining a separate local SQLite file, the team can run a single agentmemory instance on the dev network. Each developer's Claude Code connects to the same memory layer, meaning constraints and preferences propagate across the team automatically.

### 1.3 MCP Integration: Native First-Class Citizen

agentmemory ships as a first-class MCP server. This matters because MCP is rapidly becoming the standard wire protocol between AI agents and their tools. When Claude Code speaks MCP to agentmemory, it gains four native tools:

- `agentmemory_remember` — persist a fact with optional tags and TTL
- `agentmemory_recall` — retrieve relevant memories for current context
- `agentmemory_forget` — delete a specific memory by ID or tag
- `agentmemory_list_preferences` — bulk-inject preferences at session start

Configuration in Claude Code's MCP settings:

```json
{
  "mcpServers": {
    "agentmemory": {
      "command": "npx",
      "args": ["-y", "agentmemory", "mcp"],
      "env": {
        "AGENTMEMORY_DB_PATH": "${HOME}/.agentmemory/project.db"
      }
    }
  }
}
```

No API keys. No cloud signup. No metering. The data lives in a SQLite file on your machine.

### 1.4 Walkthrough: A Two-Session Story

**Session 1—Monday afternoon**

```
User: Generate a password-reset endpoint for me.
Claude: I'll use bcrypt with a cost factor of 12...
User: Stop. We use Argon2id. Never bcrypt.

[Claude internally calls agentmemory_remember]
→ Stored: "Authentication: use Argon2id, not bcrypt"
→ Tags: ["auth", "security", "hard-constraint"]
```

**Session 2—Wednesday morning, brand-new session**

```
[Claude boots, automatically calls agentmemory_list_preferences]
→ Retrieved: "Authentication: use Argon2id, not bcrypt"
→ Injected into system prompt

User: I need another auth endpoint, this time for OAuth callback.
Claude: I'll set up the OAuth handler and use Argon2id for any
       local password comparisons...
```

No re-explanation. No repeated correction. The agent simply remembers, the way a human colleague would.

### 1.5 Production Hardening: PII and Memory Bloat

agentmemory's extraction logic is agnostic to content type. It will happily store API keys, personal names, or credit card numbers if they appear in conversation. For production use, you must add a sanitization layer:

```javascript
// Pre-filter hook example (Node.js)
const { PresidioAnalyzer } = require('presidio-anonymizer');

agentmemory.setFilter(async (candidateFact) => {
  const findings = await analyzer.analyze(candidateFact.content);
  if (findings.length > 0) {
    return { store: false, reason: 'PII_DETECTED' };
  }
  return candidateFact;
});
```

For memory bloat—after months of usage, the SQLite file can grow unwieldy—configure automatic archival:

```bash
agentmemory config \
  --archive-after-days 90 \
  --compress-old-memories \
  --max-retrieval-per-query 5
```

---

## Part II: Engineering Discipline—What mattpocock/skills Actually Does

### 2.1 From Prompt Engineering to Skill Engineering

The dominant pattern in 2024-2025 was "prompt engineering": craft the perfect prompt, iterate until the LLM behaves, paste it into a chat window, lose it when the session ends.

Matt Pocock's skills repo takes a fundamentally different approach. It treats agent behavior as **versioned, reviewable, structured engineering artifacts**—not as ephemeral chat magic.

Matt Pocock is one of the most recognized TypeScript educators (formerly Vercel, now independent). His skills repo distills years of teaching humans into teaching agents. The result is a `.claude/skills/` directory that lives inside your repo, is tracked by Git, and is subject to the same code review process as any other file.

### 2.2 Directory Convention: Skill Tiers

```
.claude/skills/
├── 00-always/
│   └── engineering-principles.md       # loaded on every session boot
├── 10-planning/
│   ├── scope-before-code.md           # define boundaries before writing
│   └── architecture-review.md         # any cross-module change needs review
├── 20-coding/
│   ├── type-safety-first.md            # Result<T,E> over exceptions
│   ├── error-handling-patterns.md      # explicit over implicit
│   └── no-magic-numbers.md            # constants must be named
├── 30-reviewing/
│   ├── self-review-checklist.md        # 12-point checklist before "done"
│   └── regression-risk-assessment.md  # any refactoring needs risk score
└── 90-debugging/
    ├── systematic-debugging.md         # binary search through commits
    └── root-cause-documentation.md      # every bug fix needs a comment
```

The numeric prefixes serve as priority tiers. `00-always/` is boot-loaded. Other tiers are loaded selectively based on the task at hand. A simple bug fix might only load `90-debugging/`. A greenfield feature loads `10-planning/` and `20-coding/`.

### 2.3 Anatomy of a Skill File

`20-coding/type-safety-first.md`:

```markdown
# Type Safety First

## Principle

Type correctness is more important than runtime correctness.
If a change weakens the type system (any, @ts-ignore, unsound assertions),
it requires explicit human approval.

## Forbidden Patterns

- `any` — use `unknown` with narrowing instead
- `@ts-ignore` — use `@ts-expect-error` with mandatory explanation
- Unnecessary type assertions `as T`

## Exception Protocol

If a pattern from the forbidden list is unavoidable:
1. Add `// TYPE-SAFETY-EXCEPTION: [justification]`
2. Reference the exception in the PR description
3. Max 3 exceptions per file; exceptions expire after 90 days
```

This is not a prompt. It is a **policy document** that the agent reads, interprets, and enforces. Because it lives in Git, it evolves with the team. Because it is structured Markdown with clear headings, the agent can parse it consistently.

### 2.4 Adoption Path: Non-Destructive, Incremental

```bash
# Step 1: clone into your repo
git clone https://github.com/mattpocock/skills.git .claude/skills

# Step 2: configure Claude Code
cat > ~/.claude/config.json << 'EOF'
{
  "skillsDir": "./.claude/skills",
  "autoLoad": ["00-always"],
  "selectiveLoad": true
}
EOF

# Step 3: start with just one skill, expand over weeks
```

The critical design decision is **non-destructive adoption**. You do not need to change your workflow on day one. Start with `00-always/engineering-principles.md`. Add `20-coding/type-safety-first.md` next week. Let the team review and approve each skill before it becomes policy. Skills become part of your engineering culture, not an AI vendor's black box.

---

## Part III: The Multiplicative Effect—Memory + Skills

Either tool in isolation is useful. Together, they create something that feels qualitatively different from a "smart autocomplete."

```
agentmemory:     "Remember: user banned bcrypt, prefers Argon2id"
        ↓
mattpocock/skills: "Apply security-first coding principles"
        ↓
Claude Code:     "Writing auth module. Argon2id + security-first
                  → automatically select OWASP-recommended parameters
                  → add timing-safe comparison
                  → document the choice in code comments"
```

Memory provides **contextual personalization**. Skills provide **behavioral structure**. Without memory, the agent cannot know your specific preferences. Without skills, the agent has no framework for translating those preferences into consistent, reviewable actions.

This combination is why these two projects are trending simultaneously. They solve complementary halves of the same problem.

---

## Part IV: Competitive Landscape and Decision Framework

May 2026 has no shortage of agent memory solutions. Here is how to choose:

| Solution | Best For | License | MCP Native | Setup Time | Hosting |
|----------|----------|---------|------------|------------|---------|
| **agentmemory** | Coding agents, local-first | Apache-2.0 | ✅ Native | 5 min | Self-hosted |
| **Mem0** | Multi-platform shared memory | Apache-2.0 | ✅ | 10 min | Managed or self |
| **Zep** | Enterprise, temporal reasoning | MIT | Adapter needed | 1 hour | Self-hosted |
| **Letta** | Research, long-horizon agents | MIT | ❌ | 4 hours | Self-hosted |
| **Supermemory** | Browser + agent unified memory | MIT | ✅ | 15 min | Cloud or self |

**Decision logic:**

- If you are an individual developer or small team using Claude Code / Cursor, start with **agentmemory + mattpocock/skills**. It is the fastest path to persistent memory with zero recurring cost.
- If you need memory shared across multiple agents (Claude Code, a custom LangGraph agent, and a Slack bot), evaluate **Mem0** or **Supermemory** for their unified API.
- If you work in regulated industries (healthcare, finance), **Zep** provides PII handling and temporal validity windows that are hard to replicate.
- If you are building autonomous agents that run for days or weeks without human supervision, **Letta** (formerly MemGPT) is the research-grade choice.

---

## Part V: Team Deployment and CI/CD Integration

### 5.1 Shared Memory with Docker Compose

```yaml
version: '3.8'
services:
  agentmemory:
    image: rohitg00/agentmemory:latest
    ports:
      - "37777:37777"
    volumes:
      - agentmemory-data:/data
    environment:
      - AGENTMEMORY_API_KEY=${AGENTMEMORY_API_KEY}
      - AGENTMEMORY_ENCRYPTION_AT_REST=true

  chroma:
    image: chromadb/chroma:latest
    volumes:
      - chroma-data:/chroma/chroma

volumes:
  agentmemory-data:
  chroma-data:
```

### 5.2 CI Regression Tests for Agent Memory

```yaml
# .github/workflows/agentmemory-regression.yml
name: Agent Memory Regression
on: [push]
jobs:
  memory-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: docker compose up -d agentmemory
      - run: npm test -- tests/agentmemory/
      - run: npx agentmemory verify --expected memories/critical-facts.json
```

### 5.3 Skills Change Management

Treat `.claude/skills/` as production code:

```bash
# Require human review for skill changes
echo ".claude/skills/ merge=skills-review" >> .gitattributes

# Lint skill files for structure
npx skills-linter .claude/skills/

# Version skills with your release cycle
git tag -a skills-v1.2.0 -m "Added error-handling-patterns skill"
```

---

## Conclusion and Action Items

The May 2026 GitHub Trending charts tell a clear story: **coding agents are graduating from chat toys to engineering tools**, and the open-source community is building the infrastructure to make that transition real.

Persistent memory (agentmemory) and structured skills (mattpocock/skills) are the two primitives that make this graduation possible. Neither requires a cloud subscription. Neither locks you into a vendor. Both are under active development with permissive licenses.

**Do this tonight:**

1. `npm install -g agentmemory`
2. Add the MCP server config to Claude Code
3. `git clone https://github.com/mattpocock/skills.git .claude/skills`
4. Configure `~/.claude/config.json` to load the skills directory
5. Have a conversation, teach the agent one constraint, close the session, reopen it, and verify the constraint persisted

If step 5 works, your agent is no longer an intern who needs re-briefing every morning. It is a teammate who learns, remembers, and follows your team's engineering standards. That is the difference between a prototype and a production tool.

---

## References

- [rohitg00/agentmemory on GitHub](https://github.com/rohitg00/agentmemory)
- [mattpocock/skills on GitHub](https://github.com/mattpocock/skills)
- [GitHub Trending AI DevTools May 2026 | SignalForges](https://signalforges.com/pages/github-trending-ai-devtools-2026-05-13/)
- [Best AI Agent Memory Frameworks 2026 | Atlan](https://atlan.com/know/best-ai-agent-memory-frameworks-2026/)
- [The State of AI Agent Memory in 2026 | DEV Community](https://dev.to/vektor_memory_43f51a32376/the-state-of-ai-agent-memory-in-2026-what-the-research-actually-shows-3aja)

*Data sourced from GitHub Trending and Hacker News front-page discussions, May 2026. Star counts and rankings current as of 2026-05-17.*
