---
title: '过去30天技能：AI代理搜索引擎，通过真实互动评分社交媒体'
description: '并行搜索 Reddit、X、YouTube、TikTok、Polymarket、GitHub 等。根据点赞数、喜欢数和真钱评分结果——而不是编辑评分。支持 Claude Code、Codex、Cursor 及 50 多种代理主机。'
date: 2026-06-22
lastmod: 2026-06-22
draft: false
tags: ['AI Tools', 'Research', 'Social Media', 'Agent Skill', 'Open Source']
categories: ['ai-tools']
slug: last30days-skill-ai-agent-research-engine-social-media
featureImage: 'https://images.pexels.com/photos/5468134/pexels-photo-5468134.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'
aliases: ['/last30days-skill']
sources:
  - name: 'GitHub'
    url: 'https://github.com/mvanhorn/last30days-skill'
  - name: 'Agent Skills'
    url: 'https://agentskills.io'
lang: zh
---
title: 'Last30Days-Skill: AI Agent Search Engine That Scores Social Media by Real Engagement'
description: 'Search Reddit, X, YouTube, TikTok, Polymarket, GitHub and more in parallel. Scores results by upvotes, likes, and real money — not editors. Works with Claude Code, Codex, Cursor, and 50+ agent hosts.'
date: 2026-06-22
lastmod: 2026-06-22
draft: false
tags: ['AI Tools', 'Research', 'Social Media', 'Agent Skill', 'Open Source']
categories: ['ai-tools']
slug: last30days-skill-ai-agent-research-engine-social-media

aliases: ['/last30days-skill']
sources:
  - name: 'GitHub'
    url: 'https://github.com/mvanhorn/last30days-skill'
  - name: 'Agent Skills'
    url: 'https://agentskills.io'
---

# Last30Days-Skill: AI Agent Search Engine That Scores Social Media by Real Engagement

TL;DR — **Last30Days-Skill** is an AI agent skill that searches Reddit, X/Twitter, YouTube, TikTok, Instagram, Hacker News, Polymarket, GitHub, Bluesky, and the broader web in parallel, then scores every result by **real engagement** — upvotes, likes, views, and even real-money betting odds. The synthesized output is a research brief grounded in what people actually care about, not what editors or SEO algorithms promote. Install in one command across 50+ AI agent hosts.

## What Is Last30Days-Skill?

Google aggregates editors. **Last30Days searches people.**

Every major social platform is a walled garden with its own API, its own tokens, its own authentication. No single AI has access to all of them. Google search doesn't touch Reddit comments or X posts. ChatGPT has a deal with Reddit but can't search X or TikTok. Gemini has YouTube but not Reddit. Claude has none of them natively.

Last30Days-Skill bridges all of these disconnected platforms through an AI agent that searches them in parallel, scores results by engagement, and synthesizes everything into one brief.

Type `/last30days Peter Steinberger` and get a research report covering: his OpenAI Codex team activities, GitHub PR velocity, r/ClaudeCode debate threads with 569 upvotes, X posts, YouTube transcripts, and Polymarket odds — all sourced from the last 30 days, ranked by what real people engaged with.

**GitHub:** [mvanhorn/last30days-skill](https://github.com/mvanhorn/last30days-skill) · **Stars:** 45,446+ · **License:** MIT · **Language:** Python

## Data Sources

Last30Days-Skill searches 14+ platforms in parallel:

| Source | What It Reveals | Access |
|--------|----------------|--------|
| **Reddit** | Unfiltered community opinions, top comments with upvote counts | Free (public JSON) |
| **X / Twitter** | Hot takes, expert threads, breaking reactions | Browser cookies or API key |
| **YouTube** | Deep-dive transcripts, reaction videos, tutorials | `yt-dlp` (free) |
| **TikTok** | Creator takes reaching millions | ScrapeCreators API |
| **Instagram Reels** | Influencer perspectives with spoken transcripts | ScrapeCreators API |
| **Hacker News** | Developer consensus, technical debates | Free (public API) |
| **Polymarket** | Prediction market odds backed by real money | Free |
| **GitHub** | PR velocity, star counts, release notes, issues | Free (public API) |
| **Bluesky** | Decentralized social conversations | App password |
| **Digg** | Curated story clusters from AI 1000 leaderboard | Auto-enabled |
| **Threads** | Post-Twitter text conversations | ScrapeCreators API |
| **Pinterest** | Visual discovery pins and saves | ScrapeCreators API |
| **Perplexity** | Grounded Sonar synthesis and Deep Research | Perplexity/OpenRouter API |
| **Web** | Editorial coverage, blog comparisons | Brave Search API |

Reddit threads with 1,500 upvotes are a stronger signal than a blog post nobody read. A TikTok with 3.6M views tells you more about cultural relevance than a press release. Polymarket odds backed by $66K in volume are harder to argue with than a pundit's guess.

## What People Use It For

### Before a Meeting

```
/last30days Peter Steinberger
```

Discovers: joined OpenAI's Codex team, fighting Anthropic's ban on third-party agents, 23 PRs merged at 85% merge rate on GitHub, building LobsterOS for cross-device agent control. r/ClaudeCode debate thread with 227 upvotes. None of this is on LinkedIn.

### Hiring Signal Detection

```
/last30days Listen Labs --hiring-signals
```

Current jobs and careers pages become cited evidence for focus shifts: hiring into enterprise security, customer success, infrastructure, or product expansion. The report says what the hiring appears to signal, not what the roadmap will ship.

### Breaking News Analysis

```
/last30days Kanye West
```

UK blocked his visa, Wireless Festival canceled, sponsors fled. But BULLY debuted #2 on Billboard. Fantano reviewed it (653K views). SoFi Homecoming brought out Lauryn Hill and Travis Scott for 44 songs. Polymarket: "Will Kanye tweet again?" 86% Yes. 23 Reddit threads, 17 YouTube videos, 86K upvotes.

### Tool Comparisons

```
/last30days OpenClaw vs Hermes vs Paperclip
```

"These aren't competitors, they're layers." OpenClaw is the executor (351K GitHub stars), Hermes is the self-improving brain (31K stars), Paperclip is the org chart (49K stars). Star counts pulled live from the GitHub API, not stale blog posts. Side-by-side comparison table with architecture, memory, security, best-for.

### Understanding Global Events

```
/last30days Iran vs USA
```

Day 38 of the conflict. Trump's Tuesday deadline for Iran to reopen the Strait of Hormuz. Two US warplanes downed. Oil at $126/barrel. The IEA called it "the largest supply disruption in the history of the global oil market." Polymarket: ceasefire by Dec 31 at 74%. 27 X posts, 10 YouTube videos, 20 prediction markets.

### Trip Planning

```
/last30days Universal Epic Universe
```

Expansion already under construction. "Project 680" permit filed. Fireworks show confirmed by infrastructure but unannounced. Wait times: Mine-Cart Madness averaging 148 minutes. No annual pass yet, and locals are frustrated. Stardust Racers down for refurbishment through April 5.

### Rapid Learning

```
/last30days Nano Banana Pro prompting
```

JSON-structured prompts are replacing tag soup. Nested formats prevent "concept bleeding." Edit-first workflow beats regeneration. The skill then writes you a production prompt using exactly what the community said works.

## v3 Engine Features

The v3 engine introduced several major improvements:

### Shareable HTML Briefs

Generate dark-mode, print-friendly HTML briefs you can drop into Slack, email, or Notion:

```
/last30days OpenClaw --emit=html
```

Or just ask in plain language:
```
/last30days Cursor IDE for slack
/last30days Anthropic earnings export as html
```

The skill saves a self-contained HTML file to `~/Documents/Last30Days/{topic}-brief.html` with inline CSS, system-font fallbacks behind Inter and JetBrains Mono, no JavaScript, works offline.

### Intelligent Topic Resolution

The v3 engine doesn't just search for your topic — it figures out **where** to search first. Type "OpenClaw" and the engine resolves:
- @steipete (Peter Steinberger, creator)
- r/openclaw subreddit
- r/ClaudeCode community
- Right YouTube channels and TikTok hashtags

All via a Python pre-research brain built by [@j-sperling](https://github.com/j-sperling). Bidirectional resolution: person to company, product to founder, name to GitHub profile.

### Best Takes Judge

A second scoring judge rates every result for humor, wit, and virality alongside relevance. Tommy Lloyd's "My Michael Jordan is Steve Kerr" scores low on relevance to "Arizona Basketball" but off the charts on fun. Every brief ends with a "Best Takes" section featuring the cleverest one-liners and most viral quotes.

### Cross-Source Cluster Merging

When the same story appears on Reddit, X, and YouTube, v3 merges them into one cluster instead of showing three separate items. Entity-based overlap detection catches matches even when titles use different words.

### Single-Pass Comparisons

"CLI vs MCP" used to run three serial passes (12+ minutes). v3 runs one pass with entity-aware subqueries for both sides simultaneously. Same depth, 3 minutes.

### Auto-Discovered Competitor Comparisons

```
/last30days OpenAI --competitors
```

Tells the hosting reasoning model to discover the top 2 peers via WebSearch (Anthropic, xAI), run research per entity, and invoke the engine with `"OpenAI vs Anthropic vs xAI"`. The engine fans out 3 full pipelines in parallel and merges them into a 3-way comparison.

### GitHub Person-Mode

When the topic is a person, the engine switches from keyword search to author-scoped queries:

```
/last30days Peter Steinberger --github-user=steipete
```

Shows 22 PRs merged across 3 repos at 85% merge rate. Own projects with README summaries, star counts, and top feature requests. Release notes for what shipped this month.

### ELI5 Mode

Say "eli5 on" after any research run. The synthesis rewrites in plain language. No jargon. Same data, same sources, same citations — just clearer. "Arizona wins by being physical" instead of "Arizona's identity is paint scoring (50%+ shooting, 9th nationally)." Say "eli5 off" to go back.

## Installation

Last30Days-Skill installs across 50+ AI agent hosts:

| Surface | Install Command | Updates |
|---------|----------------|---------|
| **Claude Code** (recommended) | `/plugin marketplace add mvanhorn/last30days-skill` | Auto via marketplace |
| **Codex, Cursor, Copilot, Gemini CLI** | `npx skills add mvanhorn/last30days-skill -g` | `npx skills update last30days -g` |
| **claude.ai (web)** | Download `.skill` file and upload | Re-download and re-upload |
| **Claude Desktop** | Download `.mcpb` bundle and drag in | Re-download and drag in |
| **OpenClaw** | `clawhub install last30days-official` | `clawhub update last30days-official` |

### Claude Code (Recommended)

```
/plugin marketplace add mvanhorn/last30days-skill
```

The marketplace handles updates automatically. Run `claude plugin update last30days@last30days-skill` to force a check.

### Agent Skills Hosts (50+)

```bash
npx skills add mvanhorn/last30days-skill -g
```

The `-g` flag installs globally for your user, available across all projects. Supports Codex, Cursor, Copilot, Gemini CLI, Windsurf, Cline, Continue, Roo, Aider-Desk, OpenCode, Goose, and more.

Target specific hosts:
```bash
npx skills add mvanhorn/last30days-skill -g -a codex
npx skills add mvanhorn/last30days-skill -g -a cursor
npx skills add mvanhorn/last30days-skill -g -a gemini-cli
```

### Claude Desktop (MCP Bundle)

1. Download the `.mcpb` for your platform from [Latest Release](https://github.com/mvanhorn/last30days-skill/releases/latest)
2. Open Claude Desktop → Settings → Extensions → drag the file in
3. Paste API keys for sources you want to enable (every field is optional)
4. Restart Claude Desktop

Requires Python 3.12+ on PATH.

### Manual Installation (Developer)

```bash
git clone https://github.com/mvanhorn/last30days-skill.git
ln -s "$(pwd)/last30days-skill/skills/last30days" ~/.claude/skills/last30days
```

The symlink keeps the install in sync with your working tree as you edit.

## How It Works

1. **You type a topic.** Person, company, product, technology, "X vs Y." Anything.
2. **The agent resolves who matters.** Finds X handles (including founders), GitHub repos, subreddits, TikTok hashtags, YouTube channels. For "Kanye West" it knows r/hiphopheads, @kanyewest, and "bully review" on YouTube. For "OpenClaw" it resolves openclaw/openclaw on GitHub and fetches live star counts.
3. **All sources searched in parallel.** Multi-query expansion. Results scored by engagement, relevance, freshness.
4. **The depth nobody else has.** Full YouTube transcripts from reaction videos. Top Reddit comments with upvote counts. TikTok captions. Polymarket odds. Not just titles and links.
5. **Same story, merged.** Wireless Festival announced on Reddit, discussed on X, ticket prices on TikTok = one cluster, not three separate items.
6. **Synthesized into one brief.** Grounded in specific data. Cited by source. Ranked by what people actually engage with.
7. **Then it becomes your expert.** After one run, your Claude session knows everything the community knows. Ask follow-up questions. Have it write prompts, draft emails, plan trips, architect systems — all grounded in what's real right now.

## Configuration

### Research File Storage

Files save to `~/Documents/Last30Days/` by default. Override with:

```bash
export LAST30DAYS_MEMORY_DIR=/path/to/dir
# Or per-run:
/last30days topic --save-dir /custom/path
```

### Trend Monitoring Across Runs

For accumulating findings over time:

```bash
/last30days topic --store
```

Persists into a SQLite database. Use included scripts for scheduled runs:

- `scripts/watchlist.py` — scheduled runs with optional Slack/webhook delivery on new findings
- `scripts/briefing.py` — daily/weekly digest generation

Full configuration documented in [CONFIGURATION.md](https://github.com/mvanhorn/last30days-skill/blob/main/CONFIGURATION.md).

### API Keys

| Sources | What You Need | Cost |
|---------|--------------|------|
| Reddit (with comments) + HN + Polymarket + GitHub | Nothing | Free |
| X / Twitter | Browser cookies or API key | Free (cookies) / Paid (keys) |
| YouTube | `brew install yt-dlp` | Free |
| Bluesky | App password from bsky.app | Free |
| TikTok + Instagram + Threads + Pinterest + YouTube comments | ScrapeCreators key | 100 free credits, then PAYG |
| Perplexity Sonar / Search API / Deep Research | Perplexity or OpenRouter key | Pay as you go |
| Web search | Brave Search key | 2,000 free queries/month |

Reddit, Hacker News, Polymarket, and GitHub work immediately with zero configuration. Run `/last30days` once and the setup wizard unlocks more sources in 30 seconds.

## macOS Keychain Integration

Store keys in the system keychain instead of `.env` files:

```bash
# Interactive setup
skills/last30days/scripts/setup-keychain.sh

# Or store a single key by hand
security add-generic-password -a "$USER" -s last30days-XAI_API_KEY -w "xai-..."

# Inspect / clean up
skills/last30days/scripts/setup-keychain.sh --list
skills/last30days/scripts/setup-keychain.sh --delete XAI_API_KEY
```

Items stored under service name `last30days-<KEY>` for the current user. Non-Darwin platforms: loader is a no-op.

## Performance and Scale

- **1,012 tests passing** in the test suite
- **Parallel search** across 14+ platforms simultaneously
- **Entity-based clustering** reduces duplicate stories by 60-80%
- **Configurable retention** — search files persist for trend tracking
- **Zero tracking, zero analytics** — your research stays on your machine

## Who Should Use Last30Days-Skill?

- **AI developers** who need to stay current with rapidly changing tool landscapes
- **Product managers** researching competitor activity and user sentiment
- **Journalists** gathering community reactions and expert opinions
- **Investors** monitoring hiring signals and market sentiment
- **Content creators** discovering trending topics and community debates
- **Anyone** who needs to understand what people are actually talking about right now

## Alternatives Compared

| Feature | Last30Days | Perplexity AI | ChatGPT | Gemini |
|---------|-----------|---------------|---------|--------|
| Multi-platform search | ✅ 14+ sources | ❌ Web only | ❌ Limited | ❌ Limited |
| Real-time social data | ✅ Reddit, X, TikTok | ❌ No social | ❌ Reddit only | ❌ YouTube only |
| Engagement scoring | ✅ Upvotes, likes, views | ❌ SEO ranking | ❌ SEO ranking | ❌ SEO ranking |
| Polymarket integration | ✅ Betting odds | ❌ No | ❌ No | ❌ No |
| GitHub activity tracking | ✅ PRs, stars, releases | ❌ No | ❌ No | ❌ No |
| Self-hosted | ✅ Local Python | ❌ Cloud only | ❌ Cloud only | ❌ Cloud only |
| Open source | ✅ MIT | ❌ Proprietary | ❌ Proprietary | ❌ Proprietary |
| Agent integration | ✅ 50+ hosts | ❌ Web only | ❌ Web only | ❌ Web only |
| Cost | ✅ Free (MIT) | ❌ $20/mo | ❌ $20/mo | ❌ Free/Paid |

## Getting Started Checklist

1. Install via your agent host (`npx skills add mvanhorn/last30days-skill -g` for most)
2. Run your first search: `/last30days your-topic`
3. Reddit, HN, Polymarket, and GitHub work immediately — zero config
4. Set up additional API keys for X, YouTube, TikTok via the setup wizard
5. Try `--emit=html` for shareable briefs
6. Enable `--store` for trend monitoring across runs
7. Use `eli5 on` for plain-language summaries
8. Explore `--competitors` for auto-discovered comparison research

## Frequently Asked Questions

### Q: Do I need API keys for all platforms?

No. Reddit (with comments), Hacker News, Polymarket, and GitHub work immediately with zero configuration. X requires browser cookies or an API key. YouTube requires `yt-dlp`. Other platforms are optional and unlockable via the setup wizard.

### Q: How is this different from just Googling?

Google returns editorial content ranked by SEO. Last30Days searches what **real people** are engaging with — Reddit upvotes, X likes, YouTube views, TikTok shares, and even real-money Polymarket bets. A Reddit thread with 1,500 upvotes is a stronger signal than a blog post. A TikTok with 3.6M views tells you more about cultural relevance than a press release.

### Q: Can I use this for business research?

Absolutely. Use `--hiring-signals` to detect focus shifts from job postings. Run `--competitors` to auto-discover and compare rival products. Track GitHub PR velocity and release notes for technical companies. The HTML brief output makes it easy to share research with your team.

### Q: Does it work with AI agents other than Claude?

Yes. Last30Days installs via the open [Agent Skills](https://agentskills.io) CLI and supports 50+ harnesses including Codex, Cursor, GitHub Copilot, Gemini CLI, Windsurf, Cline, Continue, Roo, and OpenClaw. The skill is platform-agnostic.

### Q: Is my research data stored anywhere?

No. All research stays on your local machine. The skill has zero tracking and zero analytics. Files save to your configured `LAST30DAYS_MEMORY_DIR` (default: `~/Documents/Last30Days/`). You control retention.

### Q: What about the `--store` feature?

`--store` persists search results into a local SQLite database for trend monitoring across runs. Combined with `scripts/watchlist.py` for scheduled runs and `scripts/briefing.py` for daily/weekly digests, you can build automated research workflows.

## Sources

- [Last30Days-Skill on GitHub](https://github.com/mvanhorn/last30days-skill)
- [Agent Skills Registry](https://agentskills.io)
- [Configuration Documentation](https://github.com/mvanhorn/last30days-skill/blob/main/CONFIGURATION.md)
- [Changelog](https://github.com/mvanhorn/last30days-skill/blob/main/CHANGELOG.md)

---

**Ready to search what people actually care about?** Install Last30Days-Skill in under 30 seconds across 50+ AI agent hosts.

**Join the Dibi8 community:** [Telegram Group](https://t.me/DIBI8_Group/2)
