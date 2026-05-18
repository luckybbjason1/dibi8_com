---
title: 'Code Search & Replace Tools: From grep to ripgrep, sd, and Modern Alternatives'
description: 'Explore modern code search tools from grep to ripgrep, fzf, sd, and Sourcegraph. Benchmarks, workflows, and setup guide for developer search in 2025.'
date: 2026-05-18 00:00:00+08:00
lastmod: 2026-05-18 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-18'
featureImage: ''
draft: false
aliases:
- /posts/code-search-replace-tools-grep-modern-alternatives/
---

{</* resource-info */>}

Searching through code is one of the most frequent tasks developers perform. Finding where a function is defined, tracing how a variable is used, or replacing a deprecated API across dozens of files — these operations happen dozens of times per day. The right search tool turns minutes of scrolling into seconds of typing.

The code search landscape has evolved dramatically. grep, the 50-year-old Unix staple, has given way to a new generation of tools that are faster, smarter, and more developer-friendly. This guide traces that evolution, benchmarks the contenders, and shows you how to build a search toolkit that makes navigating codebases effortless.

## Why grep Is No Longer Enough for Modern Development

grep (global regular expression print) was created in 1974 by Ken Thompson. It searches file contents for patterns matching a regular expression and prints matching lines. For decades, it was the only tool available. It remains pre-installed on every Unix-like system and works reliably in shell scripts.

But grep was designed for a different era. It does not understand `.gitignore` files, so it wastes time searching `node_modules`, `.git`, and build artifacts. It does not filter by file type by default. Recursive search requires the `-r` flag and still traverses irrelevant directories. Binary file handling is crude. The output formatting lacks the visual cues that speed up comprehension.

For simple searches in a few files, grep still works. For daily development in modern codebases, there are significantly better options.

## ack: The Developer-Focused grep Replacement

ack ("better than grep, designed for programmers") was created by Andy Lester in 2005. It introduced three concepts that became standard in modern search tools: automatic `.gitignore` respect, file type detection without regex, and colored, formatted output.

With ack, you type `ack --python "class User"` instead of `grep -r --include="*.py" "class User"`. The `--python` flag knows which file extensions belong to Python. The colored output highlights matches, line numbers, and file names in distinct colors. These defaults save typing and reduce cognitive load.

ack is written in Perl and installs through CPAN or package managers. It remains functional in 2025 but receives minimal updates. ack's primary historical importance is proving that developer-focused search tools could improve dramatically on grep's defaults. See [beyondgrep.com](https://beyondgrep.com) for documentation.

## The Silver Searcher (ag): Speed as a Feature

The Silver Searcher, commonly called "ag," was released by Geoff Greer in 2011. It implemented the same developer-friendly features as ack but rewrote the core in C for maximum performance. Benchmarks at release showed ag was 3-5x faster than ack for typical code search tasks.

ag respects `.gitignore`, `.hgignore`, and `.ignore` files automatically. It searches only source code files by default, skipping binary files, hidden directories, and generated artifacts. The command-line interface mirrors ack's conventions: `ag "function_name" --js` searches JavaScript files.

Editor integration is a strength. ag ships with built-in support for Vim (through plugins like ack.vim), Emacs, and Sublime Text. VS Code's search uses ripgrep internally, but ag plugins remain available for Vim users who prefer its specific behavior.

In 2025, ag's maintenance has slowed. The last significant release was in 2020. While still functional, it has been surpassed by ripgrep in both speed and feature set. New setups should use ripgrep instead, but ag remains installed on many long-established development machines. The [ag GitHub repository](https://github.com/ggreer/the_silver_searcher) archives the project's history.

## ripgrep (rg): The New Standard for Code Search

ripgrep, created by Andrew Gallant in 2016, is the dominant code search tool in 2025. It combines the best features of ack and ag with superior performance, smarter defaults, and broader platform support. ripgrep is written in Rust and leverages memory mapping, parallel directory traversal, and SIMD-accelerated pattern matching to achieve speeds that exceed even ag.

On a warm filesystem cache, ripgrep searches the Linux kernel source tree (over 25 million lines across 60,000 files) in approximately 0.8 seconds. grep takes 8+ seconds for the same search. ag takes 2-3 seconds. The performance gap widens with larger codebases and more complex patterns.

The smart defaults eliminate configuration for typical use. ripgrep automatically respects `.gitignore`, `.ignore`, and `.rgignore` files. It skips hidden files and binary files. It detects file encoding (UTF-8, UTF-16, Latin-1) automatically. The result is that `rg "pattern"` does the right thing in 95% of cases — no flags needed.

ripgrep supports Unicode properly, including searching across mixed-encoding files and matching Unicode-aware regex patterns. This matters for codebases with internationalized strings, emoji in comments, or non-ASCII identifiers.

Type filtering narrows searches by language without manual glob patterns:

```bash
rg "User" --type js          # JavaScript files only
rg "User" --type-add 'config:*.conf' --type config  # Custom types
rg "User" -tjs -trs          # Multiple types: JS and Rust
rg "User" --type-not json    # Exclude JSON files
```

Configuration file support via `.ripgreprc` lets you set project-wide defaults. Common settings include:

```bash
# ~/.ripgreprc
--smart-case
--follow
--hidden
--glob=!*.min.js
--glob=!node_modules
--glob=!.git
```

Editor integration is comprehensive. VS Code uses ripgrep for its search functionality. Vim users combine ripgrep with fzf for the `:Rg` command. Emacs has rg.el for Projectile integration. JetBrains IDEs can configure external tools to use ripgrep. The [ripgrep GitHub repository](https://github.com/BurntSushi/ripgrep) provides installation instructions for all platforms and extensive documentation.

## fzf: Interactive Fuzzy Finding

fzf is not a search tool in the traditional sense. It is an interactive fuzzy finder that filters lists in real time as you type. Combined with ripgrep, fzf transforms command-line search into an interactive experience that rivals IDE search functionality.

The core concept is simple: pipe any list into fzf, type characters to filter, and select with Enter. fzf matches fuzzily — typing "usctrl" matches "user_controller.rb" because those characters appear in order. This "fuzzy" matching is faster than typing exact substrings.

The default key bindings transform daily workflows. `Ctrl+T` pastes a fuzzy-selected file path at the cursor. `Alt+C` changes directory into a fuzzy-selected subdirectory. `Ctrl+R` replaces the shell's history search with an interactive, fuzzy-filtered list of previous commands.

The preview window displays file contents as you navigate. Combined with bat for syntax highlighting, the preview makes file selection visual:

```bash
rg --files | fzf --preview 'bat --style=numbers --color=always {}' --bind 'enter:execute(vim {})'
```

This single command lists all project files, previews each with line numbers and syntax highlighting, and opens the selected file in Vim. It is the fastest way to navigate an unfamiliar codebase from the terminal.

git integration extends fzf to branch selection (`git branch | fzf`), commit browsing (`git log --oneline | fzf`), and stash management. The [fzf GitHub repository](https://github.com/junegunn/fzf) includes example scripts for these workflows.

## sd: Intuitive Find and Replace

Searching is half the problem. Replacing text across files is the other half. sed (stream editor) has been the standard Unix tool for this since 1974, but its syntax is notoriously difficult. Remembering whether to use `-i` for in-place editing, escaping forward slashes in paths, and handling capture groups differently across sed variants consumes mental energy better spent on actual problems.

sd replaces sed for human-facing find-and-replace tasks. Its syntax is straightforward: `sd 'old_pattern' 'replacement' file`. sd uses regex by default but provides a `--string-mode` flag for literal replacement. In string mode, no characters need escaping — `sd 'foo.bar' 'baz' file` replaces the literal string `foo.bar`, not the regex pattern.

Recursive directory replacement replaces all occurrences across a project tree:

```bash
sd 'deprecated_function' 'new_function' $(rg -l 'deprecated_function')
```

This combines ripgrep (finding files containing the pattern) with sd (performing the replacement). The `--preview` flag shows changes before applying them, preventing costly mistakes in production code.

Comparison with alternatives for a common task — replacing "http" with "https" in all JavaScript files:

```bash
# sed: complex escaping, easy to get wrong
sed -i 's/http/https/g' $(find . -name "*.js")

# perl: works but arcane
perl -pi -e 's/http/https/g' $(find . -name "*.js")

# sd: straightforward, no escaping issues
sd 'http' 'https' $(rg -l 'http' --type js)
```

For shell scripting where portability matters, sed remains the correct choice. For interactive development work, sd is the superior tool. The [sd GitHub repository](https://github.com/chmln/sd) has installation instructions and additional examples.

## Modern IDE and Editor Search

CLI search tools are essential, but modern editors also provide powerful search capabilities that excel in specific scenarios.

**VS Code** offers global search with regex support, file inclusion/exclusion patterns, and replace across files. The search panel previews results with syntax highlighting. Multi-cursor editing lets you make related changes simultaneously across multiple files. For project-wide refactoring, VS Code's search-and-replace is often faster than CLI workflows.

**JetBrains IDEs** (IntelliJ, PyCharm, WebStorm) provide structural search and replace — searching not by text patterns but by AST structures. Find all `for` loops that iterate over a specific collection type, regardless of variable names. This semantic search is impossible with regex-based tools and invaluable for large-scale refactoring.

**Vim/Neovim** offer `:vimgrep` for project search, `:cfdo` for running commands across quickfix list files, and Telescope (in Neovim) for a fuzzy-finding interface comparable to fzf. The `:Rg` integration with ripgrep provides IDE-like search without leaving the editor.

CLI tools win for speed, composability, and use in scripts. Editor search wins for interactive refactoring, preview, and integration with editing workflows. Use both.

## Large-Scale Code Search Platforms

When your codebase exceeds a single repository, or when you need to search across your entire organization's code, specialized platforms provide the infrastructure.

**Sourcegraph** is a code intelligence platform that indexes repositories for fast, regex-based search across millions of files. It adds code navigation (click-to-definition, find-references), batch changes (automated code modification across many repositories), and code insights (tracking code patterns over time). Sourcegraph is used by companies like Amazon, PayPal, and Uber to manage code at massive scale. See [sourcegraph.com](https://sourcegraph.com) for pricing and deployment options.

**GitHub Code Search** provides native repository search with regex support, path filtering, and language scoping. The 2023 rewrite improved performance and accuracy significantly. For organizations on GitHub, this is the simplest way to search across all repositories.

**OpenGrok** and **Hound** are self-hosted code search engines. OpenGrok is the more mature option with support for 20+ programming languages, cross-reference navigation, and history search. Hound is simpler to set up but less feature-rich. Both require indexing infrastructure and periodic re-indexing as code changes.

**Livegrep** powers Google's internal code search and is available as open-source. It uses a custom trigram index for fast regex search across massive codebases. Setup is complex, but the performance is unmatched for organizations with billions of lines of code.

## Complete Search Workflows for Daily Development

The best developers combine tools into workflows for specific tasks:

**Daily code navigation:** `rg --files | fzf --preview 'bat {}'` — fuzzy-find files with syntax-highlighted preview. This is your default for exploring codebases.

**Finding definitions:** `rg "^fn main" --type rust` — regex-anchored search for function definitions. For language-aware search, use your IDE's "Go to Definition" feature.

**Bulk refactoring:** `rg -l 'old_api' | xargs sd 'old_api' 'new_api'` — find all files containing the old API, replace across all of them. Always preview first: `rg 'old_api'` before running the replacement.

**Cross-repository search:** Sourcegraph or GitHub Code Search for organization-wide queries. Set up saved searches for tracking deprecated API usage or security patterns.

**Git history search:** `git log -S "function_name"` finds commits that added or removed a specific string. `git log -G "regex_pattern"` uses regex matching. `git grep "pattern" HEAD~10` searches the codebase at a specific commit.

**Log analysis:** `rg "ERROR" -C 5 --after-context 10 /var/log/app` searches logs with 5 lines of context before and 10 lines after each match. Pipe to `less` for paginated reading.

## Performance Benchmarks: How Fast Is Fast?

Andrew Gallant's official ripgrep benchmarks compare grep, ack, ag, git grep, and ripgrep across multiple test cases. The results on a warm cache searching the Linux kernel source:

| Tool | Time (seconds) | Notes |
|------|---------------|-------|
| **ripgrep (rg)** | 0.8 | Fastest, smart defaults |
| **The Silver Searcher (ag)** | 2.3 | Good, but surpassed by rg |
| **git grep** | 1.5 | Fast within git repos, limited features |
| **ack** | 4.1 | Slower, but established developer features |
| **grep -r** | 8.2 | Baseline, no optimizations |

Cold cache performance (first run after reboot) shows different patterns. ripgrep's memory-mapped I/O and parallel traversal still lead, but the gap narrows as all tools are bound by disk read speed. Memory usage is another differentiator: ripgrep uses approximately 10 MB for typical searches, while ag uses 15-20 MB and ack uses 50+ MB due to its Perl runtime.

Unicode handling reveals ripgrep's strength. Searching a pattern across mixed UTF-8 and UTF-16 files, ripgrep handles encoding detection automatically. grep and ag treat non-UTF-8 content as binary by default, potentially missing matches.

## Conclusion: Build Your Essential Search Toolkit

The modern developer's search toolkit has three essential components. ripgrep handles content search with speed and intelligence. fzf adds interactivity to any list-filtering operation. sd replaces sed for find-and-replace tasks. Together, these three tools cover 90% of daily code search needs.

For specialized scenarios, add Sourcegraph for cross-repository search, your IDE's structural search for semantic refactoring, and git's built-in tools for history exploration. Replace ack and ag with ripgrep in new setups — they are legacy tools at this point.

The future of code search is AI-assisted. Tools like GitHub Copilot Chat and Sourcegraph Cody already answer natural language questions about code: "Where is user authentication handled?" "Show me all uses of the payment API." These tools do not replace ripgrep and fzf for precise, fast searches. They complement them by handling vague, exploratory queries that would require multiple searches with traditional tools.

Invest in your search toolkit. The seconds saved on each search compound into hours over a month. More importantly, low-friction search encourages exploration — reading more code, understanding more systems, and making better architectural decisions.

---

## FAQ

**Is ripgrep faster than grep?**

Yes, significantly. ripgrep is typically 5-10x faster than grep for code search tasks. The speed comes from parallel directory traversal, automatic filtering (respecting .gitignore), memory-mapped file I/O, and SIMD-accelerated pattern matching. On a warm cache, ripgrep searches the entire Linux kernel source (25+ million lines) in under one second. grep takes 8+ seconds for the same operation. The gap is smaller on cold caches where disk I/O is the bottleneck.

**What is the best tool for searching code across multiple files?**

ripgrep is the best general-purpose code search tool. It searches recursively by default, respects .gitignore automatically, filters by file type, and handles Unicode correctly. For interactive file navigation, combine ripgrep with fzf: `rg --files | fzf --preview 'bat {}'`. For searching across many repositories or an entire organization, use Sourcegraph or GitHub Code Search. For semantic search (finding by code structure rather than text), use your IDE's structural search features.

**How do I replace text in multiple files from the command line?**

Use sd (for simple, human-friendly syntax) or sed (for scripting portability). The recommended workflow: first find affected files with ripgrep (`rg -l 'old_pattern'`), then preview replacements (`sd --preview 'old' 'new' file`), then execute (`sd 'old' 'new' $(rg -l 'old')`). For in-place editing with sed: `sed -i 's/old/new/g' file` (GNU sed) or `sed -i '' 's/old/new/g' file` (BSD/macOS sed). Always version control your code before bulk replacements.

**Can I use ripgrep with VS Code?**

VS Code uses ripgrep internally for its search functionality — you are already using it when you search within the editor. To use ripgrep from the integrated terminal, install it on your system (`brew install ripgrep` on macOS, `apt install ripgrep` on Ubuntu) and run `rg` commands directly. For enhanced terminal search, install the fzf extension for VS Code to get fuzzy file finding within the editor interface.

**What is the difference between ack, ag, and rg?**

ack was the first developer-focused grep replacement (2005), written in Perl. It introduced .gitignore respect, file type filtering, and colored output. ag (The Silver Searcher, 2011) rewrote ack's feature set in C for 3-5x speed improvement. rg (ripgrep, 2016) surpassed both with superior performance, better Unicode support, broader platform availability, and ongoing active development. In 2025, ripgrep is the clear choice for new setups. ack and ag are legacy tools — functional but unmaintained or minimally maintained. All three share similar command-line interfaces, so transitioning from one to another requires minimal relearning.

---

## Recommended Infrastructure

To run any of the tools above reliably 24/7, infrastructure matters:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit, 14+ global regions, one-click droplets for AI/dev workloads.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low latency for mainland China access. This is the same IDC hosting dibi8.com — production-proven.

*Affiliate links — no extra cost to you, helps keep dibi8.com running.*

