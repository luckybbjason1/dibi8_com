---


title: "DESIGN.md: Google's Open-Source Format for Giving AI Coding Agents a Design System"
description: "AI tool guide"
date: 2026-09-20
slug: "design-md-google-open-source-format-ai-coding-agents-design-systems"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---



# DESIGN.md: Google's Open-Source Format for Giving AI Coding Agents a Design System


![DESIGN.md Format Specification](https://opengraph.github.com/github/google-labs-code/design.md)

![DESIGN.md Philosophy Document](https://raw.githubusercontent.com/google-labs-code/design.md/main/PHILOSOPHY.md)

## Introduction

When you ask an AI coding agent to build a landing page, it produces something functional — but rarely beautiful. The problem isn't the model's capability; it's the lack of a shared design language. Every prompt starts from scratch, every generation drifts from the last, and there's no persistent memory of what "our design" actually looks like.

**DESIGN.md** by Google Labs Code solves this. It's an open-source format specification that gives AI coding agents a persistent, structured understanding of your design system — combining YAML color tokens, typography specs, and spacing rules with natural language prose that describes the *intent* behind every value. With 20,800+ GitHub stars and 2,319 stars gained in a single day, it's currently the hottest design tool on GitHub.

## What Is DESIGN.md?

DESIGN.md is a markdown file that serves as the single source of truth for a project's visual identity. It's designed to be read by AI coding agents (Claude, ChatGPT, Codex, Cursor, etc.) so they can generate UI that consistently matches your brand — without you having to re-explain your design system every time.

The format has two complementary layers: ````
┌──────────────────────────────────────────────────┐
│              DESIGN.md Structure                  │
├──────────────────────────────────────────────────┤
│                                                  │
│  