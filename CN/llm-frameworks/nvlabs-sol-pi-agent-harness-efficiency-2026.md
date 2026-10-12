---


title: "SoL-Pi: Scaling Auto-Research Loops for Efficient Agent Harnesses — NVlabs Open-Source Optimization Framework 2026"
description: "AI tool guide"
date: 2026-09-24T00:00:00+08:00
slug: "nvlabs-sol-pi-agent-harness-efficiency-2026"
category: "llm-frameworks"
tags: ["soL-Pi", "agent-harness", "token-efficiency", "nvidia", "auto-research", "claude-code-alternative", "coding-agent", "llm-optimization", "2026", "open-source"]
categories: ["llm-frameworks"]
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
|