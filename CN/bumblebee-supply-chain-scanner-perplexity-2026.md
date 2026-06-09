---
title: 'Bumblebee 2026: Perplexity AI Open-Sources Its Internal Supply-Chain Scanner for Developer Machines'
description: 'Bumblebee is Perplexity AI''s open-source, read-only supply-chain scanner that checks npm, PyPI, Go modules, MCP configs, editor extensions, and browser extensions for known compromised packages — without executing a single line of your code.'
date: 2026-06-09 00:00:00+08:00
lastmod: 2026-06-09 00:00:00+08:00
tech_stack: ['Go', 'Security', 'CLI']
application_domain: Dev Utils
source_version: '0.1.1'
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: 'https://github.com/perplexityai/bumblebee'
backup_url: ''
github_repo: 'perplexityai/bumblebee'
stars: 1500
maintainer: 'perplexityai'
last_maintained: '2026-05-22'
featureImage: '/images/articles/bumblebee-supply-chain-scanner-perplexity-2026/cover.jpg'
draft: false
categories: ['dev-utils']
tags: ['bumblebee', 'supply-chain', 'security', 'MCP', 'developer-tools', 'Go', 'npm', 'PyPI', 'perplexity-ai']
aliases:
- /posts/bumblebee-supply-chain-scanner-perplexity-2026/
faqs:
  - q: 'What is Bumblebee and what does it scan?'
    a: 'Bumblebee is a read-only developer endpoint scanner open-sourced by Perplexity AI. It scans on-disk metadata for npm, pnpm, Yarn, Bun, PyPI, Go modules, RubyGems, Composer, MCP configurations, editor extensions (VS Code, Cursor, Windsurf, Zed), and browser extensions. It never executes install scripts or invokes package managers — it only reads what is already on disk.'
  - q: 'Why does Bumblebee matter for AI developers using MCP?'
    a: 'MCP (Model Context Protocol) servers run with elevated privileges on your machine. A compromised MCP package could exfiltrate data or run arbitrary code. Bumblebee is the first publicly available tool that scans MCP configuration files (claude_desktop_config.json, mcp_settings.json, .mcp.json, etc.) against its threat intelligence catalog, making it essential for anyone using Claude Desktop, Cursor, or other MCP-enabled tools.'
  - q: 'What are the three scan profiles?'
    a: 'Baseline scans your global package roots, toolchain installs, editor extensions, and MCP configs — suitable for routine daily inventory. Project focuses on configured development directories (e.g. ~/code or ~/src) alongside the baseline. Deep sweeps an operator-supplied root, typically your full home directory, and is designed for active incident response when you need certainty.'
  - q: 'How do I install and run Bumblebee?'
    a: 'Run ''go install github.com/perplexityai/bumblebee/cmd/bumblebee@v0.1.1''. For a routine global inventory run ''bumblebee scan --profile baseline > inventory.ndjson''. For an exposure check against a specific advisory run ''bumblebee scan --profile deep --root "$HOME" --exposure-catalog ./catalog.json --findings-only --max-duration 10m''.'
  - q: 'Does Bumblebee run on Windows?'
    a: 'Bumblebee v0.1.1 supports macOS and Linux. Windows support is planned. For Windows users, running Bumblebee under WSL2 gives full coverage of Linux-side packages and MCP configs, though Windows-native paths (AppData, LOCALAPPDATA) require native Windows support.'
---

![Bumblebee 2026: Perplexity AI Supply-Chain Scanner — dibi8.com](/images/articles/bumblebee-supply-chain-scanner-perplexity-2026/cover.jpg)

On May 22, 2026, Perplexity AI published [Bumblebee](https://github.com/perplexityai/bumblebee) — the internal tool their security team uses to audit developer laptops for supply-chain exposure. Within a week it had over 1,500 GitHub stars and 112 forks. The premise is deceptively simple: given an advisory naming a compromised package, version, or extension, which machines in your fleet actually have it?

## Why Supply-Chain Attacks Hit Developers First

The 2024–2026 wave of supply-chain incidents (xz, polyfill.io, dozens of malicious npm packages targeting AI tooling) share a pattern: they land on a developer's machine months before they cause damage in production. Developer laptops are high-value targets because they hold API keys, SSH credentials, source code, and now — increasingly — MCP server configs that grant AI models access to files, databases, and web browsers.

Traditional SCA tools (Snyk, Dependabot) check what your code declares as a dependency. They miss:
- Globally installed CLIs (`npm install -g`, `pip install --user`)
- Editor extensions loaded by Cursor, VS Code, or Windsurf
- Browser extensions with broad host permissions
- MCP config files that reference packages pulled from npm or PyPI

Bumblebee was built to fill exactly those gaps.

## The Read-Only Guarantee

The tool's defining constraint is that **it never executes anything**. No `npm ls`, no `pip check`, no `go list`. Supply-chain attacks have increasingly targeted the inspection phase — a malicious `postinstall` or a poisoned metadata endpoint can turn a routine audit into an exploit. Bumblebee bypasses this entirely by reading on-disk metadata files: `package.json`, `package-lock.json`, `go.sum`, `requirements.txt`, `Gemfile.lock`, extension manifests, and MCP config JSON.

This makes it safe to run during an active incident, on machines where you don't fully trust the installed packages.

## Three Scan Profiles

```bash
# Routine daily inventory — global packages, toolchains, extensions, MCP configs
bumblebee scan --profile baseline > inventory.ndjson

# Project-scoped scan — includes ~/code, ~/src, or your configured dev roots
bumblebee scan --profile project --project-root ~/code

# Incident response — sweep full home directory against a threat catalog
bumblebee scan --profile deep \
  --root "$HOME" \
  --exposure-catalog ./catalog.json \
  --findings-only \
  --max-duration 10m
```

**Baseline** is what you run daily. It covers global package roots for all supported ecosystems, language toolchain installs (pyenv, nvm, rbenv, GOPATH), editor extensions, browser extensions, and every MCP config file it can find.

**Project** adds your development directories on top of baseline. Use this when investigating a newly compromised package that might exist in vendored copies inside repos.

**Deep** takes an arbitrary root and sweeps recursively. It is designed for the scenario where you have an advisory and need to know, with certainty, whether any copy of the package exists on this machine.

## MCP Config Coverage

This is the feature most relevant to AI developers in 2026. Bumblebee scans the following config file paths:

| File | Tool |
|------|------|
| `~/.claude.json` | Claude CLI |
| `claude_desktop_config.json` | Claude Desktop |
| `mcp_settings.json` | Cline / Roo Code |
| `cline_mcp_settings.json` | Cline |
| `.mcp.json` | generic MCP |
| `mcp.json` | generic MCP |
| `mcp_config.json` | generic MCP |
| `~/.gemini/settings.json` | Gemini CLI |

For each MCP server entry, Bumblebee records the package name, version, and the npm/PyPI registry from which it came. When you run an exposure scan against a threat catalog, MCP packages are checked alongside your regular dependencies — which is novel, because no other tool currently does this.

## Zero Dependencies by Design

Bumblebee is written in Go 1.25 and imports **nothing outside the standard library**. The result is a single, statically linked binary with no glibc dependency, distributable via MDM to a fleet of developer machines without managing runtime environments. There are no third-party packages that could themselves be compromised — the tool that checks for supply-chain issues has no supply chain to attack.

Install is one line:

```bash
go install github.com/perplexityai/bumblebee/cmd/bumblebee@v0.1.1
```

Or download a pre-built binary from the [GitHub releases page](https://github.com/perplexityai/bumblebee/releases).

## Output Format

Bumblebee outputs **NDJSON** (newline-delimited JSON), one record per scanned artifact. This makes it easy to pipe into `jq`, ingest into a SIEM, or diff against a previous inventory to detect new packages:

```bash
# Show only packages with known exposures
bumblebee scan --profile baseline --findings-only | jq '.name + " " + .version'

# Diff today's inventory against yesterday's
comm -23 \
  <(bumblebee scan --profile baseline | jq -r '.name + "@" + .version' | sort) \
  <(cat yesterday.ndjson | jq -r '.name + "@" + .version' | sort)
```

The NDJSON schema includes: ecosystem (npm/pypi/go/gem/composer), package name, version, install path, and (when applicable) findings from the threat catalog.

## Integrating with CI and MDM

For fleet-wide deployment, Perplexity's own workflow runs `bumblebee scan --profile baseline` as a daily cron job on developer machines, ships the output to a central store, and alerts when any machine's inventory matches an active advisory. The Apache 2.0 license permits this kind of centralized use without restriction.

For CI pipelines, the **project** profile is more appropriate: it scans the vendored dependencies and toolchain installs within a specific repository, producing a repeatable SBOM-style artifact that can be checked into version control or archived per-release.

## What Bumblebee Does Not Do

Bumblebee is a scanner, not a remediation tool. It tells you what is on disk; it does not remove packages, patch versions, or block execution. Remediation is intentionally out of scope — the team's view is that accurate read-only detection is hard enough, and that mixing detection with mutation increases the risk of unintended consequences.

It also does not scan Docker images, container registries, or cloud infrastructure. The scope is strictly developer laptops (macOS and Linux in v0.1.1).

## Related Tools

If Bumblebee surfaces a finding in your npm packages, [socket.dev](https://socket.dev) provides deeper static analysis of the flagged packages. For Python, [pip-audit](https://pypi.org/project/pip-audit/) complements Bumblebee by querying the OSV and PyPI Advisory databases — Bumblebee finds the package, pip-audit explains the vulnerability. For a broader security toolkit covering vulnerability scanners and penetration testing tools, see our [Scanners Box cybersecurity collection](/resources/dev-utils/scanners-box-cybersecurity-tools-collection/).

> **Deploy secure AI infrastructure:** If you're running MCP servers or AI workloads on a VPS, hardening the host OS is the first line of defence. A [$6/month DigitalOcean Droplet](https://m.do.co/c/eca87ac14ee0) (2 vCPU, 2 GB RAM) gives you full root access to configure your own firewall, user isolation, and audit logging. New users get **$200 in free credits**.

## Bottom Line

Bumblebee solves a specific, underserved problem: auditing the full surface of a developer machine — global packages, editor extensions, browser extensions, and MCP configs — for supply-chain exposure, without executing anything that could make the situation worse. If you use Claude Desktop, Cursor, or any MCP-enabled AI tool, running `bumblebee scan --profile baseline` should be part of your weekly routine.

**GitHub:** [perplexityai/bumblebee](https://github.com/perplexityai/bumblebee) · v0.1.1 · Apache-2.0
