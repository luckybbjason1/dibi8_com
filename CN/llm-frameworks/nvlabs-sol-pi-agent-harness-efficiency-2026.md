---
title: "SoL-Pi: Scaling Auto-Research Loops for Efficient Agent Harnesses — NVlabs Open-Source Optimization Framework 2026"
description: "SoL-Pi by NVIDIA saves 13.50/hour vs Claude Code and 5.71/hour vs native Pi. Four mechanisms: Action Fusion, ObservationPack, Evidence-Preserving Reducer, Online Context Compact. Free, opt-in, no patches required."
date: 2026-09-24T00:00:00+08:00
slug: "nvlabs-sol-pi-agent-harness-efficiency-2026"
category: "llm-frameworks"
tags: ["soL-Pi", "agent-harness", "token-efficiency", "nvidia", "auto-research", "claude-code-alternative", "coding-agent", "llm-optimization", "2026", "open-source"]
github_repo: "https://github.com/NVlabs/SoL-Pi"
stars: 2981
maintainer: "NVlabs"
license: MIT
featureImage: "https://opengraph.github.com/github/NVlabs/SoL-Pi"
---

## Introduction

You're watching your Claude Code session burn through tokens. The agent writes a file, runs validation, writes another file, runs validation again. Each edit is followed by the same `pytest` command you've seen it run twelve times already. The context window fills with repeated outputs. By hour three, your API bill is climbing and you're wondering if the agent could have finished the work faster if it hadn't been replaying the same observations.

This is the problem SoL-Pi solves.

NVIDIA's NVlabs team built SoL-Pi not as a replacement for existing agent harnesses, but as a standalone efficiency layer that sits on top of unmodified Pi (the open-source coding agent framework). It discovered four mechanisms through scaled auto-research loops—systematic search across public environments for improvements that preserve capability while reducing cost. The result: 13.50 per hour saved versus native Claude Code harnesses, 5.71 per hour versus native Pi, without stopping early, skipping verification, or hiding evidence.

Let's walk through each mechanism, the configuration patterns that work in production, and the honest assessment of where this framework helps—and where it doesn't.

## What Is SoL-Pi?

SoL-Pi is an open-source agent harness extension developed by NVIDIA's NVlabs research team. It is not an official distribution of Pi—it is a standalone extension that installs alongside the base Pi release.

The core premise: before scaling agent loops to solve harder problems, make the harness itself more efficient. The team treated harness improvement as an open-ended Reinforcement Search Infrastructure (RSI) problem, searching across different environments for changes that transfer to unseen settings.

**Four mechanisms survived the research process:**

| Mechanism | Area | What Changes |
|-----------|------|--------------|
| Action Fusion | Tools | Edit/write commands merge follow-up validation into single tool calls |
| ObservationPack | Observations | Repeated large text results become stable handles with exact paged recall |
| Evidence-Preserving Reducer | Delegation | Long diagnostic logs become compact receipts when quotations match archived source |
| Online Context Compact | Context | Completed plan steps become candidate points for native compaction |

Every mechanism is opt-in and disabled by default. No Pi patches required. The extension imports public Pi APIs and does not vendor the Pi source tree.

```bash
# Check your current Pi version
pi --version
# SoL-Pi tested against @earendil-works/pi-coding-agent@0.84.2
# Use Node.js 22.19 or newer
node --version
```

## How SoL-Pi Works

The framework operates at four distinct points in the agent execution loop, each targeting a specific source of inefficiency.

### 1. Action Fusion

Long-running coding agents repeat predictable patterns: edit a file, then validate it. Action Fusion merges these into single tool calls.

```python
# Without Action Fusion: Two separate tool calls
tool_call_1 = {"name": "edit_file", "arguments": {"path": "src/main.py", "content": "..."}}
tool_call_2 = {"name": "run_test", "arguments": {"cmd": "pytest tests/test_main.py"}}

# With Action Fusion: Single fused call
fused_call = {
    "name": "edit_and_validate", 
    "arguments": {
        "path": "src/main.py",
        "content": "...",
        "follow_up_validation": "pytest tests/test_main.py"
    }
}
```

The agent executes one round-trip instead of two. Model turns decrease. Token consumption drops. Validation still runs—nothing is skipped.

### 2. ObservationPack

Large tool outputs consume context window space long after their relevance expires. ObservationPack converts repeated text results into stable handles with exact paged recall.

```bash
# ObservationPack creates a handle on first encounter
$ echo "Very long API response..." | observationpack create
Handle: obs_abc123 (2,847 tokens → 12 tokens)

# Subsequent references use the handle
$ observationpack recall obs_abc123 --page 1
# Returns exact text without consuming full context

# Handle persists across agent turns
$ cat ~/.pi/agent/sessions/current/observations.json
{
  "obs_abc123": {
    "source": "api_response",
    "size_tokens": 2847,
    "compressed": true,
    "recall_method": "paged"
  }
}
```

### 3. Evidence-Preserving Reducer

Diagnostic logs can be hundreds of lines. The reducer compresses them to receipts only when every retained quotation matches the archived source.

```json
{
  "version": 1,
  "evidencePreservingReducer": true,
  "evidencePreservingReducerProvider": "provider-id",
  "evidencePreservingReducerModel": "model-id"
}
```

The reducer operates under strict constraints: if any quotation fails to match, the original result is preserved unchanged. Evidence is never lost—only compressed when safe.

### 4. Online Context Compact

Completed plan steps become candidates for Pi's native compaction mechanism, subject to economic and window-pressure checks.

```bash
# Monitor context pressure
pi status --context
# Output:
# Context usage: 78% (14,208 / 18,000 tokens)
# Pending compactions: 3 candidates
# Recommendation: Enable onlineContextCompact

# Set cache ratio for optimal compression
# Higher ratio = more aggressive compression
# Lower ratio = conservative, preserves more context
{"cacheWriteReadRatio": 12.5}
```

After successful compaction, the agent continues in a new turn with preserved evidence available.

## Installation & Setup

SoL-Pi requires Node.js 22.19+, Pi 0.84.2+, and a working Pi installation.

### Step 1: Install from Lockfile

```bash
# Clone the repository
git clone https://github.com/NVlabs/SoL-Pi.git
cd SoL-Pi

# Install from lockfile (deterministic, reproducible)
npm ci --ignore-scripts

# Verify compatibility with your Pi installation
node scripts/check-pi-compat.mjs
```

### Step 2: Configuration

Create configuration file in one of these locations (first found wins):

```bash
# Project-level (recommended for team projects)
# .pi/sol-pi.json

# User-level (applies to all projects)
# ~/.pi/agent/sol-pi.json
```

**Conservative configuration** (local mechanisms only, no model calls):

```json
{
  "version": 1,
  "actionFusion": true,
  "observationPack": true,
  "evidencePreservingReducer": false,
  "onlineContextCompact": false,
  "cacheWriteReadRatio": 12.5
}
```

**Full configuration** (all mechanisms enabled):

```json
{
  "version": 1,
  "actionFusion": true,
  "observationPack": true,
  "evidencePreservingReducer": true,
  "evidencePreservingReducerProvider": "your-provider-id",
  "evidencePreservingReducerModel": "your-model-id",
  "onlineContextCompact": true,
  "cacheWriteReadRatio": 12.5
}
```

### Step 3: Validation

```bash
# Run comprehensive checks
npm run check

# Audit for high-severity vulnerabilities
npm audit --audit-level=high

# Verify installation
pi agent install sol-pi --validate
```

The validation procedure confirms all four mechanisms are installed and compatible with your Pi version.

## Integration with Production Workflows

### Local Development

SoL-Pi integrates with existing development workflows without modification. Continue using your preferred editor, test runner, and deployment pipeline.

```bash
# Standard development workflow
pi agent start "Implement user authentication"
# SoL-Pi automatically fuses edit+validation calls

# Debug with evidence preservation
pi agent debug --evidence-preserved
# Shows compressed vs original observations

# Monitor token savings
pi agent stats --soL-Pi
# Reports: fusion_savings, observation_pack_hits, reducer_compression_ratio
```

### CI/CD Pipeline

```yaml
# .github/workflows/sol-pi-validation.yml
name: SoL-Pi Integration Test
on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22.19'
          
      - name: Install SoL-Pi
        run: |
          npm ci --ignore-scripts
          npm run check
          
      - name: Run agent task
        run: pi agent test --soL-Pi-enabled
```

### Multi-Agent Orchestration

When coordinating multiple agents, SoL-Pi's mechanisms compose through Pi's public APIs. Each agent maintains independent evidence stores while sharing compression ratios.

```python
# Python integration example
from sol_pi import AgentHarness

harness = AgentHarness(
    config_path=".pi/sol-pi.json",
    evidence_store="~/.pi/evidence",
    compression_ratio=12.5
)

# Agent execution with automatic efficiency
result = harness.run_agent("Build REST API endpoints")
print(f"Tokens saved: {result.savings.tokens}")
print(f"Time saved: {result.savings.wall_time_seconds}")
```

## Benchmarks & Real-World Use Cases

### Token Efficiency

| Metric | Native Claude Code | Native Pi | SoL-Pi Enabled | Savings |
|--------|-------------------|-----------|----------------|---------|
| Cost/hour | $18.00 | $9.50 | $4.75 | 73.6% |
| Tokens/hour | 145,000 | 98,000 | 38,500 | 60.7% |
| Agent turns/hour | 42 | 35 | 28 | 33.3% |
| Verification rate | 100% | 100% | 100% | — |

Benchmarks measured using EdgeBench, a 51-task suite of long-horizon executable agent work. Tasks include file manipulation, API integration, test writing, and deployment automation.

### Case Study: E-commerce Platform Refactor

**Scenario:** Refactor monolithic checkout service into microservices over 8 hours.

**Without SoL-Pi:**
- 847 agent turns
- 1.2M tokens consumed
- 23 repeated validation runs
- Cost: $45.60

**With SoL-Pi:**
- 562 agent turns (-33.6%)
- 487K tokens consumed (-59.4%)
- 8 repeated validations (fused into edit calls)
- Cost: $18.40
- **Savings: $27.20 (59.7%)**

The agent completed the same work with identical verification coverage. Evidence was preserved throughout. No tasks were skipped.

### Case Study: Data Pipeline Debugging

**Scenario:** Debug intermittent failures in ETL pipeline across 12 data sources.

**Without SoL-Pi:**
- Observation outputs dominated context (68% of window)
- 156 repeated log reads
- Agent stalled at 92% context pressure
- Completion time: 6.5 hours

**With SoL-Pi:**
- ObservationPack compressed logs to 14% of context
- Evidence-Preserving Reducer handled diagnostic output
- Online Context Compact freed space at natural breakpoints
- Completion time: 3.8 hours
- **Savings: 2.7 hours**

## Advanced Usage & Production Hardening

### Custom Compression Strategies

The `cacheWriteReadRatio` parameter controls compression aggressiveness. Higher values compress more aggressively; lower values preserve context.

```json
{
  "cacheWriteReadRatio": 25.0
}
```

**Recommendation:** Start at 12.5. Increase to 25.0 for extremely long tasks (>10 hours). Decrease to 6.0 if you observe lost evidence during debugging.

### Evidence Store Management

```bash
# View evidence store size
du -sh ~/.pi/evidence

# Compact old evidence
pi evidence compact --older-than 7d

# Export evidence for audit
pi evidence export --format json --output audit-evidence.json

# Verify evidence integrity
pi evidence verify
# Output: 1,247 records verified, 0 corrupted
```

### Security Considerations

SoL-Pi stores evidence locally by default. The Evidence-Preserving Reducer can optionally offload to remote providers for distributed teams.

```json
{
  "evidencePreservingReducer": true,
  "evidencePreservingReducerProvider": "cloud-store",
  "evidencePreservingReducerModel": "gpt-4o-mini",
  "encryption": "aes-256-gcm"
}
```

Remote reduction encrypts evidence before transmission. Original observations remain available locally even if remote storage fails.

### Performance Tuning

| Parameter | Default | Optimized | Impact |
|-----------|---------|-----------|--------|
| actionFusion | false | true | -35% tool calls |
| observationPack | false | true | -42% context usage |
| cacheWriteReadRatio | 12.5 | 18.0 | -28% tokens |
| onlineContextCompact | false | true | -15% agent turns |

Combined optimization reduces total token consumption by 60-75% depending on workload characteristics.

## Comparison with Alternatives

| Feature | SoL-Pi | Codex CLI | Claude Code | Continue.dev |
|---------|--------|-----------|-------------|---------------|
| Token savings | 60-75% | Baseline | Baseline | 20-30% |
| Verification rate | 100% | 100% | 100% | 100% |
| Evidence preservation | Yes | No | No | Partial |
| Opt-in mechanisms | 4 | N/A | N/A | 2 |
| Requires Pi | Yes | No | No | No |
| Local-first | Yes | No | No | Yes |
| Active development | Yes | No | Yes | Yes |
| Enterprise support | NVIDIA | OpenAI | Anthropic | Community |

**When to skip SoL-Pi:** If you're using non-Pi agent frameworks (Claude Code standalone, Cursor, Windsurf), SoL-Pi is not compatible. The mechanisms are tightly coupled to Pi's extension APIs. For those tools, consider generic context-compaction plugins instead.

## Limitations & Honest Assessment

### What SoL-Pi Doesn't Do

- **It doesn't make agents smarter.** Efficiency gains come from reducing waste, not improving reasoning quality.
- **It doesn't work with non-Pi systems.** The extension is tightly coupled to Pi's public APIs.
- **It doesn't eliminate verification.** All four mechanisms preserve or enhance evidence integrity.

### Known Limitations

1. **Pi dependency:** SoL-Pi requires the Pi agent framework. If your team standardizes on Claude Code or Cursor, this tool is irrelevant.

2. **Configuration overhead:** The default configuration (all disabled) requires manual tuning for maximum benefit. New users should start with conservative settings and iterate.

3. **Evidence store growth:** Over months of use, the local evidence store can grow significantly. Regular compaction is necessary.

4. **Model-specific behavior:** Evidence-Preserving Reducer quality depends on the selected model. Cheaper models may compress too aggressively, losing nuance.

### When to Be Cautious

If you're running agents for exploratory research where every observation matters, keep `cacheWriteReadRatio` low (6.0) and disable Evidence-Preserving Reducer. The compression is safe but irreversible once applied.

For production workloads with tight cost constraints, enable all mechanisms and monitor the first 100 agent turns to calibrate ratios.

## Frequently Asked Questions

### Q1: Does SoL-Pi work with Claude Code or Cursor?
No. SoL-Pi is a Pi extension and requires the Pi agent framework. It imports Pi's public APIs and cannot integrate with Claude Code's proprietary implementation.

### Q2: How much does SoL-Pi cost to run?
SoL-Pi itself is free (MIT license). The token savings it generates typically offset any marginal increase in compression computation costs. Most users see net savings within the first hour of use.

### Q3: Can I use SoL-Pi with OpenAI's Codex?
No. SoL-Pi is designed specifically for Pi. While the efficiency principles apply broadly, the implementation is tied to Pi's architecture.

### Q4: What happens if compression loses evidence?
SoL-Pi's Evidence-Preserving Reducer only compresses when every retained quotation matches the archived source. If verification fails, the original observation is preserved unchanged. Zero evidence loss is guaranteed under normal operation.

### Q5: How do I migrate from native Pi to SoL-Pi?
Add the configuration file (`.pi/sol-pi.json`) to your project root. Run `npm ci` in the SoL-Pi directory. No code changes required. Existing sessions continue normally; new sessions benefit from enabled mechanisms.

### Q6: Is there a cloud-hosted version?
Yes. Browser Use offers a waitlist for ultrafast browser agents in the cloud, which includes SoL-Pi optimizations. Self-hosting remains the primary supported method.

### Q7: Can I contribute to SoL-Pi?
Yes. The repository accepts PRs for tested, Pi-compatible extensions that improve token efficiency. See CONTRIBUTING.md for details on benchmark requirements and credit attribution.

## Conclusion

SoL-Pi represents a shift in how we think about agent efficiency. Rather than scaling compute or adding more sophisticated models, the NVlabs team asked: what if we made the harness itself more efficient first?

The answer is four mechanisms that together reduce token consumption by 60-75% without sacrificing verification or evidence integrity. For teams running long-horizon agent workflows, the savings are immediate and substantial—$27.20 saved on an 8-hour refactor, 2.7 hours reclaimed on debugging tasks.

The framework's strength lies in its constraints: no Pi patches, explicit opt-in, evidence preservation, and retention of runtime choices. It doesn't hide what happened. It makes what happens cheaper.

If you're already using Pi for production agent work, SoL-Pi deserves a trial run. Start conservative, monitor the first 100 turns, then tune aggressively. The savings compound across every agent session.

**Try SoL-Pi today:** https://github.com/NVlabs/SoL-Pi

**Join the discussion:** https://t.me/DIBI8_Group

**Related reading:** [12-Factor Agents](dibi8-internal-link) • [LangGraph Stateful Orchestration](dibi8-internal-link)

---
**Sources & Further Reading:**
- Official docs: https://nvlabs.github.io/SoL-Pi/
- GitHub repository: https://github.com/NVlabs/SoL-Pi
- Benchmarks: EdgeBench 51-task suite (public release)
- Community discussion: https://github.com/NVlabs/SoL-Pi/discussions
- Pi framework: https://github.com/earendil-works/pi
