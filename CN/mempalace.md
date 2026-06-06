---
title: "MemPalace vs Mem0: 96.6% Recall Benchmark & Best AI Memory Framework (2026)"
description: "MemPalace is the best-benchmarked open-source AI memory system. Learn how to install it, mine your project history, and retrieve context with semantic search so your AI assistant never forgets again."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Go
  - Python
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: ""
file_md5: ""
download_url: ""
backup_url: ""
github_repo: ""
stars: 0
maintainer: ""
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /posts/mempalace/
faqs:
  - q: 'What is MemPalace and how does it give an AI memory?'
    a: 'MemPalace is a free, open-source, local-first AI memory system that stores your conversation and project history as verbatim text and retrieves it with semantic search. It creates a structured memory layer outside the model so your AI assistant can recall exact past context instead of starting every chat from zero.'
  - q: 'How do you install MemPalace?'
    a: 'MemPalace is a Python tool that installs via uv (uv tool install mempalace) or pip (pip install mempalace). After installing, run mempalace init ~/projects/myapp to initialize it for your project.'
  - q: 'How does MemPalace compare to Mem0 on recall accuracy?'
    a: 'On the LongMemEval benchmark, MemPalace reports a 96.6% recall rate versus 89.2% for Mem0. MemPalace also runs fully locally with zero API calls, while Mem0 requires a paid OpenAI API.'
  - q: 'How does MemPalace organize stored memory?'
    a: 'MemPalace uses a palace metaphor with three levels: Wings for people and projects, Rooms for topics within those projects, and Drawers that hold the original content stored verbatim. This lets you scope a search to a specific project wing or topic room instead of querying a flat vector database.'
  - q: 'Does MemPalace work with Claude Code and other AI tools?'
    a: 'Yes. MemPalace ships native plugins including a .claude-plugin directory for Claude Code, a .codex-plugin directory for OpenAI Codex, and a .agents/plugins directory for MCP-compatible tools, plus support for Gemini CLI and local models. It exposes an MCP-compatible endpoint out of the box for persistent coding-agent memory.'
---

{</* resource-info */>}

# MemPalace: Give Your AI a Perfect Memory (Free, Open Source, 51K+ Stars)

Every AI conversation starts from zero. You explain your stack, your preferences, and your project history over and over. MemPalace fixes that. It is the best-benchmarked open-source AI memory system, and it is completely free.

With **51,745 GitHub stars** and a growing ecosystem of plugins, MemPalace stores your conversation history as verbatim text and retrieves it with semantic search. Your AI assistant finally remembers.

---

## Benchmark Comparison: MemPalace vs Mem0 vs Mastra
When evaluating AI memory systems, performance and resource consumption are critical. Here is how MemPalace stacks up in the **LongMemEval** benchmark:

| Feature/Metric | MemPalace | Mem0 | Mastra | Hindsight |
| :--- | :--- | :--- | :--- | :--- |
| **Recall Rate** | **96.6%** | 89.2% | 85.5% | 91.0% |
| **API Calls Required**| **Zero (Local)** | OpenAI API (Paid) | Anthropic API | Zero |
| **Storage Architecture**| Verbatim + Vector | Vector Only | Graph + Vector | Vector Only |
| **Claude Code Support**| Yes (Native) | Manual integration | Yes | No |


## Why AI Memory Matters

Large language models have a fixed context window. Once a conversation exceeds that limit, earlier details are lost or compressed. For developers working across multiple projects, this means repeatedly re-explaining architecture decisions, coding standards, and past debugging sessions.

MemPalace solves this by creating a **structured, searchable memory layer** outside the model itself. It does not summarize or paraphrase your history. It keeps the original text intact and retrieves the exact passages your AI needs, when it needs them.

---

## How MemPalace Works

MemPalace organizes memory using a palace metaphor:

- **Wings** — People and projects
- **Rooms** — Topics within those projects
- **Drawers** — Original content stored verbatim

This structure lets you scope searches precisely. Instead of dumping everything into a flat vector database, you can search within a specific project wing or topic room.

The retrieval layer is pluggable. The default backend is **ChromaDB**, and the interface is defined in `mempalace/backends/base.py`. You can swap in an alternative backend without touching the rest of the system.

Importantly, **nothing leaves your machine unless you opt in**. MemPalace is local-first by design.

---

## Quickstart: Install in Seconds

MemPalace is written in Python and installs cleanly via `uv` or `pip`:

```shell
# Recommended: install with uv
uv tool install mempalace

# Or use pip
pip install mempalace

# Initialize for your project
mempalace init ~/projects/myapp
```

Once installed, you can start mining content and searching memory immediately.

---

## Mining Your Project History

MemPalace can ingest both project files and conversation history. Here is how to populate your palace:

```shell
# Mine a project directory
mempalace mine ~/projects/myapp

# Mine Claude Code conversations (scoped by project)
mempalace mine ~/.claude/projects/ --mode convos --wing myapp

# Search your memory
mempalace search "why did we switch to GraphQL"

# Load context into a new session
mempalace wake-up
```

The `mine` command indexes your content. The `search` command runs semantic retrieval. And `wake-up` loads the most relevant context into your current AI session so you can pick up exactly where you left off.

---

## Plugin Ecosystem

MemPalace ships with native plugins for popular AI tools:

- **Claude Code** — `.claude-plugin` directory
- **OpenAI Codex** — `.codex-plugin` directory
- **MCP-compatible tools** — `.agents/plugins` directory
- **Gemini CLI** and local models

This means you can integrate MemPalace into your existing workflow without switching editors or rewriting prompts.

---

## Benchmarks and Performance

MemPalace markets itself as the **best-benchmarked** open-source AI memory system. The repository includes a `benchmarks/` directory with reproducible tests comparing retrieval accuracy, latency, and memory usage against other memory solutions. If you care about measurable performance rather than marketing claims, this is a strong signal.

---

## When to Use MemPalace

MemPalace is ideal if you:

- Work on long-running projects with complex context
- Use AI assistants daily and hate repeating yourself
- Want a **free, open-source** alternative to proprietary memory services
- Need **local-first** storage for privacy or compliance
- Prefer structured retrieval over flat vector search

If your AI sessions are short and self-contained, you may not need a memory system. But for developers, researchers, and power users, MemPalace turns every new chat into a continuation rather than a restart.

---


---

## Related Articles

- [Hermes Agent: Self-Improving AI](/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/) - AI with learning loop
- [AI Tools Directory 2024](/resources/dev-utils/ai-tools-directory/) - AI tools guide
- [DS4: DeepSeek V4 Flash](/resources/ai-tools/ds4-deepseek-flash-local-inference/) - Local LLM
- [Free Claude Code](/resources/ai-tools/free-claude-code-open-source-proxy/) - Free AI coding
- Agent Skills: AI Coding - AI skills

## Conclusion

MemPalace gives your AI a memory that is structured, searchable, and private. With over 51,000 GitHub stars, a pluggable backend architecture, and native support for Claude, Codex, and MCP tools, it is the most credible open-source option in the AI memory space.

Install it today, mine your first project, and stop re-explaining your stack to every new chat session.

---

## Related Articles





---


---

## Recommended Tools

For developers building or deploying open-source AI tools, we recommend:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for new users, 14+ global regions, one-click GPU/CPU droplets ideal for AI workloads.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API proxy. Most AI tools above (chatbots, code gen, translation, search, etc) need an LLM API key — this proxy delivers stable access to top models at ~30% of official pricing.

*Affiliate link — supports dibi8.com at no cost to you.*

*Published on dibi8.com — May 10, 2026*

## FAQ: Running MemPalace in Production

**Q: How much RAM is required for MemPalace?**
A: MemPalace is highly optimized. It can run smoothly on machines with just 8GB of RAM, but for large-scale production with thousands of long-term sessions, 16GB is recommended.

**Q: Can I integrate MemPalace with Claude Code?**
A: Yes! MemPalace provides an MCP-compatible endpoint out of the box, allowing seamless integration with Claude Code for persistent coding agent memory.

**Q: ChromaDB vs Pinecone for local memory?**
A: MemPalace uses ChromaDB locally to ensure zero latency and zero API costs, making it superior to Pinecone for localized, privacy-focused agent workflows.

<!--auto-references-->
## References & Sources

- [ChromaDB](https://github.com/chroma-core/chroma)
- [Mem0](https://github.com/mem0ai/mem0)
- [Mastra](https://github.com/mastra-ai/mastra)
- [Pinecone](https://www.pinecone.io/)
- [Model Context Protocol (MCP)](https://modelcontextprotocol.io/)
