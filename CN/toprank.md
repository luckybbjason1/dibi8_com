---
title: "Toprank: Open-Source Claude Code Skills That Automate SEO, GEO, and Ad Campaign Optimization"
description: "Toprank is a trending open-source Claude Code skills suite for SEO audits, GEO optimization, Google Ads management, and Meta Ads automation. Install once, get automatic updates, and let AI handle your marketing stack."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Go
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "1.3 MB"
file_md5: ""
download_url: "https://github.com/nowork-studio/toprank"
backup_url: ""
github_repo: "https://github.com/nowork-studio/toprank"
stars: 2513
maintainer: "nowork-studio"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /posts/toprank/
faqs:
  - q: 'What is Toprank and how is it different from SEO SaaS tools?'
    a: 'Toprank is an open-source suite of Claude Code skills that turns Anthropic''s Claude Code CLI into a marketing automation engine. Unlike web-dashboard SaaS tools, it runs inside your existing development environment with no browser tabs, monthly seat fees, or context switching.'
  - q: 'What SEO tasks can Toprank automate?'
    a: 'Toprank''s SEO module includes skills for technical audits with Google Search Console data (seo-analysis), EEAT content drafting (content-writer), keyword research with topic clustering, meta tag and Open Graph optimization, JSON-LD schema generation, single-page Core Web Vitals analysis (seo-page), and broken-link/orphan-page checking. It also has a dedicated geo-optimizer skill for Generative Engine Optimization.'
  - q: 'Can Toprank manage Google Ads and Meta Ads directly?'
    a: 'Yes. Toprank connects to Google Ads and Meta accounts via official APIs to audit campaign health, generate ad copy, and execute live changes such as applying negative keywords, adjusting bids, pausing underperformers, reallocating budgets, and starting A/B tests. Because it uses official APIs, recommendations are backed by real account data rather than scraped estimates.'
  - q: 'How does Toprank handle installation and updates?'
    a: 'Toprank installs via a one-time setup script, after which its skills update automatically whenever the repository releases new versions. There is no package manager to monitor or manual changelog to read, so all team members stay on the same skill version without lockfile conflicts.'
  - q: 'Who is Toprank best suited for?'
    a: 'Toprank targets technical SEOs automating audits in their CLI, growth engineers running marketing infrastructure alongside application code, agencies managing many client accounts with version-controlled playbooks, and startup founders who need professional SEO and ad management without a $500+/month SaaS stack.'
---
{</* resource-info */>}

# Toprank: Open-Source Claude Code Skills That Automate SEO, GEO, and Ad Campaign Optimization

If you are tired of juggling ten different SaaS subscriptions for SEO audits, content writing, keyword research, and ad management, there is a new open-source project trending on GitHub that deserves your attention. **Toprank** — developed by [nowork-studio](https://notfair.co) — is a suite of Claude Code skills designed to turn your terminal into an autonomous marketing engine. Install it once, and it stays automatically updated while handling everything from technical SEO audits to live Google Ads optimizations.

## What Is Toprank?

Toprank is not another web dashboard. It is a collection of Claude Code skills — programmable extensions for Anthropic's Claude Code CLI — that connect directly to your marketing accounts and data sources. Because it runs inside your existing development environment, there is no context switching, no browser tabs, and no monthly seat fees. You type a command, Claude reads your site or ad account, and you receive an actionable report or an executed optimization.

The project is open-source, hosted at [github.com/nowork-studio/toprank](https://github.com/nowork-studio/toprank), and has been gaining traction among developers and technical marketers who prefer infrastructure-as-code over click-heavy UIs.

## SEO Skills: A Complete Audit and Content Stack

Toprank's SEO module covers the full lifecycle of organic search optimization:

- **seo-analysis** — Runs a comprehensive technical SEO audit and pulls Google Search Console (GSC) data to surface indexing issues, CTR opportunities, and ranking drops.
- **content-writer** — Generates EEAT-compliant content drafts with proper entity coverage, semantic structure, and citation suggestions.
- **keyword-research** — Discovers keywords and automatically groups them into topic clusters, complete with search intent classification.
- **meta-tags-optimizer** — Rewrites page titles, meta descriptions, and Open Graph tags for maximum CTR and social shareability.
- **schema-markup-generator** — Produces JSON-LD structured data for articles, products, FAQs, and local business markup.
- **seo-page** — Performs deep single-page analysis, evaluating Core Web Vitals, internal linking, and on-page entity density.
- **broken-link-checker** — Crawls your site and reports 404s, redirects, and orphan pages that waste crawl budget.
- **geo-optimizer** — A dedicated GEO (Generative Engine Optimization) skill that tunes your content for AI search engines and answer engines, ensuring your brand surfaces in LLM-generated responses.

Each skill returns structured output you can pipe into CI/CD workflows, Slack alerts, or Notion databases.

## Google Ads and Meta Ads: Direct Account Integration

Where Toprank differentiates itself from generic SEO tools is its direct integration with paid media platforms:

- **google-ads-audit** — Connects to your Google Ads account, scores campaign health across bidding strategies, ad group structure, and keyword overlap, then delivers a printable scorecard.
- **google-ads-copy** — Generates responsive search ad headlines and descriptions tailored to your landing page content and audience segments.
- **google-ads** — The execution layer: applies negative keywords, adjusts bids, pauses underperformers, and pushes changes live without leaving your terminal.
- **meta-ads-audit** — Mirrors the Google Ads audit for Facebook and Instagram campaigns, evaluating creative fatigue, audience overlap, and CPM trends.
- **meta-ads-copy** — Writes primary text, headlines, and call-to-action variations for Meta placements.
- **meta-ads** — Automates budget reallocation, audience expansion, and A/B test initiation inside your Meta Business Manager.

Because these skills use official APIs, every recommendation is backed by real account data, not scraped estimates.

## Installation and Update Model

Toprank installs via a one-time setup script. After that, skills update automatically when the repository releases new versions. There is no package manager to monitor or manual changelog to read. For teams, this means every developer and marketer stays on the same skill version without lockfile conflicts.

## Who Should Use Toprank?

- **Technical SEOs** who want to automate audits inside their existing CLI workflows.
- **Growth engineers** running marketing infrastructure alongside application code.
- **Agencies** managing dozens of client accounts and needing reproducible, version-controlled optimization playbooks.
- **Startup founders** who cannot justify $500+/month marketing SaaS stacks but still need professional-grade SEO and ad management.

## Why It Matters

Most marketing tools force a trade-off between power and usability. Toprank rejects that premise by leveraging Claude Code's natural-language interface. You do not need to memorize API parameters or write SQL to extract GSC data. You describe what you want — "Audit my Google Ads account and pause anything with CPA above $50" — and Toprank's skills translate that intent into API calls, analysis, and executed changes.

The project is still new and trending, which means early adopters have an opportunity to shape its roadmap. If you believe marketing operations should be as version-controlled and automatable as software deployments, Toprank is worth the GitHub star.

## Get Started

Visit the repository at [github.com/nowork-studio/toprank](https://github.com/nowork-studio/toprank) to read the setup guide, browse the skill catalog, and join the growing community of developers treating SEO and paid media as code.

---

*Built by nowork-studio / notfair.co. Open source. Automatically updated. Designed for Claude Code.*

---

## Recommended Tools

For developers building or deploying open-source AI tools, we recommend:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for new users, 14+ global regions, one-click GPU/CPU droplets ideal for AI workloads.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API proxy. Most AI tools above (chatbots, code gen, translation, search, etc) need an LLM API key — this proxy delivers stable access to top models at ~30% of official pricing.

*Affiliate link — supports dibi8.com at no cost to you.*

<!--auto-references-->
## References & Sources

- [Toprank (nowork-studio)](https://github.com/nowork-studio/toprank)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview)
- [Google Ads API](https://developers.google.com/google-ads/api/docs/start)
- [Google Search Console](https://search.google.com/search-console/about)
- [Schema.org JSON-LD](https://schema.org/)
