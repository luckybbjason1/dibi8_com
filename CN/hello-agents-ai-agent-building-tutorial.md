---
title: 'Hello-Agents: How Datawhale''s Open-Source AI Agent Tutorial Helps You Build
  Production-Grade Agents from Scratch'
description: Datawhale Hello-Agents is the top open-source AI agent tutorial covering
  ReAct, AutoGen, LangGraph, MCP, Agentic RL and real-world projects with 45,600+
  GitHub stars.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Go
- JavaScript
- Python
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "197.3 MB"
file_md5: ''
download_url: https://github.com/datawhalechina/hello-agents
backup_url: ''
github_repo: https://github.com/datawhalechina/hello-agents
stars: 50847
maintainer: "datawhalechina"
last_maintained: "2026-05-14"
featureImage: ''
draft: false
aliases:
- /posts/building-persistent-ai-agent/
faqs:
  - q: 'What is Datawhale Hello-Agents?'
    a: 'Hello-Agents is a free, open-source tutorial from China''s Datawhale community that teaches building AI agents from scratch. It offers a 16-chapter curriculum with runnable code and is available as an online book, local docs, and a downloadable PDF.'
  - q: 'What topics does the Hello-Agents 16-chapter curriculum cover?'
    a: 'It spans agent and LLM foundations, classic paradigms (ReAct, Plan-and-Solve, Reflection), low-code platforms (Coze, Dify, n8n), professional frameworks (AutoGen, AgentScope, LangGraph), memory and RAG, context engineering, communication protocols (MCP, A2A, ANP), Agentic RL (SFT, RLHF, GRPO), evaluation, and three capstone case studies.'
  - q: 'What programming language and environment do you need for Hello-Agents?'
    a: 'The code is primarily Python (about 72.5%) with Jupyter notebooks. The recommended setup is Python 3.9+, an OpenAI API key or GitHub Models access, with optional Ollama for local models and Chroma or Weaviate as a vector database for the RAG chapters.'
  - q: 'Is Hello-Agents free to use, and what is its license?'
    a: 'Yes, Hello-Agents is completely free under an open-source license, and the full PDF is available at no charge via GitHub releases or the Datawhale website. The PDF carries a Datawhale watermark to prevent commercial resale while remaining fully usable for personal learning.'
  - q: 'What real-world projects can you build by following Hello-Agents?'
    a: 'The tutorial includes three comprehensive case studies: a Smart Travel Assistant that coordinates multiple specialized agents via MCP tool calling, an Automated Deep Research agent that searches and synthesizes web findings into a report, and a Cyber Town simulation populated by AI agents with distinct personalities and routines.'
---
{</* resource-info */>}

# Hello-Agents: How Datawhale's Open-Source AI Agent Tutorial Helps You Build Production-Grade Agents from Scratch

> **GitHub Stars:** 45,600+ | **Daily Growth:** 1,162 stars | **Forks:** 5,500+ | **Repository:** [datawhalechina/hello-agents](https://github.com/datawhalechina/hello-agents)

The year 2025 was widely recognized as the "Year of AI Agents." From OpenAI's Operator to Google's A2A protocol, from Anthropic's MCP to ByteDance's UI-TARS, the entire technology industry has pivoted toward autonomous intelligent systems that can perceive, plan, and act on behalf of users. Yet for most developers, the gap between using a chatbot and building a true agent remains vast. Enter **Hello-Agents**, the open-source educational project from China's renowned Datawhale community that has amassed **45,600+ GitHub stars** and become the definitive starting point for anyone who wants to transition from "LLM user" to "Agent system builder."

Unlike scattered blog posts or framework documentation that assumes prior knowledge, Hello-Agents delivers a **complete 16-chapter curriculum** spanning agent fundamentals, classic paradigms, low-code platforms, professional frameworks, advanced memory systems, communication protocols, reinforcement learning, and comprehensive capstone projects. Every chapter includes runnable code, and the entire course is freely available as an online book, local documentation, and downloadable PDF.

In this deep-dive review, we explore what makes Hello-Agents the most valuable agent education resource on GitHub today, how its structured curriculum accelerates your path from beginner to production-ready agent developer, and why its combination of theory, hands-on coding, and real-world projects creates a learning experience that no paid bootcamp can match.

---

## What Is Hello-Agents?

Hello-Agents is a **systematic, open-source tutorial for building AI agents from scratch**, created by the Datawhale community — one of China's most influential open-source AI education organizations. The project is published under the Apache 2.0 license and hosted on GitHub at `datawhalechina/hello-agents`.

The tutorial addresses a critical market gap: while there are countless introductions to ChatGPT prompting and plenty of framework README files, there is almost no resource that systematically teaches **how agents actually work under the hood** — from the Transformer architecture that powers them, to the reasoning patterns that guide them, to the communication protocols that connect them, to the reinforcement learning that trains them.

Hello-Agents fills this gap with five major parts:

1. **Agent & LLM Foundations** — Understanding what agents are, their history, and the language models that drive them
2. **Building Your First LLM Agent** — Implementing classic patterns, using low-code platforms, and working with professional frameworks
3. **Advanced Knowledge Expansion** — Memory systems, context engineering, agent protocols, Agentic RL, and evaluation
4. **Comprehensive Case Studies** — Travel assistant, DeepResearch agent, and cyber town simulation
5. **Capstone Project & Future Outlook** — Building a complete intelligent application from end to end

---

## Core Curriculum: The 16-Chapter Learning Path

The heart of Hello-Agents is its meticulously structured 16-chapter curriculum, designed to take a developer from zero knowledge to the ability to build and deploy production-grade agent systems.

### Part 1: Agent & Language Model Foundations

**Chapter 1: First Encounter with Agents**
This chapter establishes the conceptual foundation. It defines what an AI agent is (an autonomous system that perceives its environment, makes decisions, and takes actions to achieve goals), traces the evolution from symbolic AI to LLM-driven agents, and introduces the key paradigms that dominate the field today. By the end, you understand why 2025 became the "Year of Agents" and what distinguishes a true agent from a simple chatbot wrapper.

**Chapter 2: Agent Development History**
A historical tour from early rule-based systems through reinforcement learning agents like AlphaGo, to the current era of LLM-powered autonomous systems. This context is essential because many modern agent patterns are reinventions of ideas from decades ago — understanding the history prevents you from repeating old mistakes.

**Chapter 3: LLM Foundations**
Before you can build an agent, you need to understand the engine. This chapter covers the Transformer architecture, attention mechanisms, prompting techniques (zero-shot, few-shot, chain-of-thought), and the limitations of current language models that agent systems must work around. It also surveys the mainstream LLM landscape, from GPT-4 and Claude to open-source alternatives.

### Part 2: Building Your LLM Agent

**Chapter 4: Classic Agent Paradigms**
This is where coding begins in earnest. You implement three foundational agent patterns from scratch:

- **ReAct (Reasoning + Acting)** — The pattern that powers many modern agents, where the model interleaves thought traces with tool calls in a continuous loop until the task is complete.
- **Plan-and-Solve** — A two-phase approach where the agent first generates a step-by-step plan, then executes each step systematically.
- **Reflection** — A self-improvement pattern where the agent evaluates its own output, identifies errors, and iteratively refines its response.

Each pattern is implemented with clean Python code using the OpenAI API, so you see exactly how the loop works without framework magic obscuring the mechanics.

**Chapter 5: Low-Code Platform Agents**
Not every agent needs custom code. This chapter teaches you to build functional agents using three major low-code platforms:

- **Coze** (ByteDance) — A visual agent builder with rich plugin ecosystem
- **Dify** — An open-source LLM application development platform
- **n8n** — A workflow automation tool that can be extended with AI capabilities

You learn when to choose low-code (rapid prototyping, non-technical teams) versus code-native approaches (custom logic, scale, integration).

**Chapter 6: Framework Development Practice**
When you outgrow low-code platforms, you need professional frameworks. This chapter provides hands-on experience with:

- **AutoGen** (Microsoft) — A multi-agent conversation framework where agents can chat with each other to solve problems
- **AgentScope** — A flexible agent platform with strong support for heterogeneous agents
- **LangGraph** (LangChain) — A library for building stateful, multi-actor applications with LLMs, modeled as graphs

You build the same simple agent in all three frameworks, allowing direct comparison of their APIs, abstractions, and trade-offs.

**Chapter 7: Build Your Own Agent Framework**
The capstone of Part 2. Using only the OpenAI API and standard Python libraries, you build a minimal but functional agent framework from scratch. This exercise demystifies every abstraction you encountered in AutoGen and LangGraph — you understand why frameworks exist, what problems they solve, and when you might outgrow them entirely.

### Part 3: Advanced Knowledge Expansion

**Chapter 8: Memory & Retrieval**
A stateless LLM cannot maintain context across long conversations or recall information from previous sessions. This chapter teaches you to build memory systems:

- **Short-term memory** — Managing conversation context within token limits
- **Long-term memory** — Persistent storage of user preferences, facts, and conversation history
- **RAG (Retrieval-Augmented Generation)** — Connecting agents to external knowledge bases via vector databases and embedding search

You implement a RAG pipeline using open-source embedding models and vector stores, enabling your agent to answer questions grounded in private documents.

**Chapter 9: Context Engineering**
Context is the most precious resource in agent systems — every token spent on irrelevant information is a token not available for reasoning. This chapter teaches advanced context management: windowing strategies, summarization techniques, hierarchical context structures, and the "context engineering" mindset that separates amateur agents from professional ones.

**Chapter 10: Agent Communication Protocols**
As the agent ecosystem matures, standardized protocols are emerging. This chapter provides deep technical analysis of:

- **MCP (Model Context Protocol)** — Anthropic's open standard for connecting AI systems to external data sources and tools
- **A2A (Agent-to-Agent)** — Google's protocol for agent interoperability
- **ANP (Agent Network Protocol)** — A community-driven protocol for agent discovery and communication

You implement basic MCP servers and clients, giving your agents the ability to call external tools in a standardized way.

**Chapter 11: Agentic RL**
This is one of the most advanced chapters in any agent tutorial available today. It teaches you to train language models for agentic behavior using reinforcement learning:

- **SFT (Supervised Fine-Tuning)** — The starting point for any custom model
- **RLHF (Reinforcement Learning from Human Feedback)** — The technique behind ChatGPT's alignment
- **GRPO (Group Relative Policy Optimization)** — The efficient RL method popularized by DeepSeek

You walk through the complete training pipeline, from data preparation to model evaluation, using accessible open-source tools.

**Chapter 12: Agent Performance Evaluation**
How do you know if your agent is good? This chapter covers evaluation metrics (task success rate, efficiency, safety), benchmark datasets (AgentBench, SWE-bench), and frameworks for systematic agent testing. You learn to build evaluation pipelines that catch regressions before deployment.

### Part 4: Comprehensive Case Studies

**Chapter 13: Smart Travel Assistant**
A real-world multi-agent application that combines MCP tool calling, web search, map APIs, and itinerary planning. The travel assistant demonstrates how multiple specialized agents (flight search, hotel booking, activity recommendation) can collaborate through a coordinator agent to deliver a complete service.

**Chapter 14: Automated Deep Research Agent**
OpenAI's DeepResearch demonstrated that agents can autonomously conduct multi-step research on the web. This chapter guides you through replicating that capability: building an agent that formulates search queries, browses results, synthesizes findings, and generates a structured research report — all without human intervention.

**Chapter 15: Build Cyber Town**
The most creative project in the curriculum. You build a simulated town populated by AI agents, each with its own personality, goals, and daily routines. Inspired by projects like Stanford's Generative Agents, this case study teaches multi-agent social dynamics, emergent behavior, and environment simulation.

### Part 5: Capstone & Future

**Chapter 16: Capstone Project**
The final chapter challenges you to design and build a complete intelligent agent application from scratch, applying everything learned across the previous 15 chapters. It includes project planning guidance, architecture decision frameworks, and deployment considerations.

---

## Community Contributions and Extra Content

Beyond the core 16 chapters, Hello-Agents maintains an active community contribution system through its **Extra-Chapter** and **Co-creation-projects** directories. Notable community content includes:

- **Agent Interview Questions** — A curated set of technical interview questions and detailed answers for agent-related positions
- **Dify Agent Creation Tutorial** — A beginner-friendly, step-by-step guide to building your first agent in Dify
- **Agent Skills vs MCP Comparison** — A technical deep-dive comparing two major approaches to agent tool integration
- **GUI Agent Introduction and Practice** — Exploring agents that interact with graphical user interfaces
- **Agent Self-Evolution** — Advanced techniques for building agents that can improve their own capabilities through closed-loop learning

With **71 contributors** and continuous pull request activity, the project benefits from a vibrant community that keeps the content current with the rapidly evolving agent landscape.

---

## Installation and Learning Setup

Hello-Agents is designed to be accessible through multiple formats:

### Online Reading
Visit the official documentation site at `https://datawhalechina.github.io/hello-agents/` for the complete web-based tutorial. An optimized mirror is available for users in China.

### Local Setup
Clone the repository and serve the documentation locally:

```bash
git clone https://github.com/datawhalechina/hello-agents.git
cd hello-agents
# Follow the environment setup guide in Extra-Chapter/07
```

### PDF Download
A complete PDF version is available free of charge via GitHub releases or the Datawhale website. The PDF includes a Datawhale watermark to prevent commercial resale while remaining fully usable for personal learning.

### Code Environment
The `/code` directory contains runnable implementations for every chapter. The primary language is Python (72.5%), with Jupyter notebooks for interactive exploration. Recommended environment:

- Python 3.9+
- OpenAI API key or access to GitHub Models
- Optional: Ollama for local model execution
- Optional: Vector database (Chroma or Weaviate) for RAG chapters

---

## Code Example: Building a ReAct Agent from Scratch

To illustrate the hands-on nature of the tutorial, here is a simplified version of the ReAct agent you build in Chapter 4:

```python
import openai
import json

# Define available tools
 tools = [
    {
        "type": "function",
        "function": {
            "name": "search_web",
            "description": "Search the web for information",
            "parameters": {
                "type": "object",
                "properties": {
                    "query": {"type": "string"}
                },
                "required": ["query"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "calculate",
            "description": "Perform a mathematical calculation",
            "parameters": {
                "type": "object",
                "properties": {
                    "expression": {"type": "string"}
                },
                "required": ["expression"]
            }
        }
    }
]

# Simple tool implementations
def search_web(query):
    return f"Results for: {query}"

def calculate(expression):
    return str(eval(expression))

# ReAct loop
messages = [
    {"role": "system", "content": "You are a helpful assistant. Use tools when needed."},
    {"role": "user", "content": "What is the population of Tokyo divided by 1000?"}
]

for step in range(5):  # Max 5 reasoning steps
    response = openai.chat.completions.create(
        model="gpt-4",
        messages=messages,
        tools=tools,
        tool_choice="auto"
    )
    
    message = response.choices[0].message
    messages.append(message)
    
    if message.tool_calls:
        for tool_call in message.tool_calls:
            function_name = tool_call.function.name
            arguments = json.loads(tool_call.function.arguments)
            
            if function_name == "search_web":
                result = search_web(**arguments)
            elif function_name == "calculate":
                result = calculate(**arguments)
            
            messages.append({
                "role": "tool",
                "tool_call_id": tool_call.id,
                "content": result
            })
    else:
        print("Final answer:", message.content)
        break
```

This pattern — reasoning about what tool to call, executing it, observing the result, and reasoning again — is the fundamental loop that powers professional agents like OpenAI's Operator and Anthropic's Claude Computer Use.

---

## Real-World Use Cases and Career Impact

### For Aspiring AI Engineers
Hello-Agents provides the structured foundation that job postings for "AI Agent Engineer" or "LLM Application Developer" increasingly require. The interview question supplements are directly drawn from real hiring processes at major AI companies.

### For Product Teams
Product managers and designers can use the low-code chapters (Coze, Dify, n8n) to rapidly prototype agent-powered features without waiting for engineering resources. The framework chapters then provide the technical literacy needed to collaborate effectively with development teams.

### For Researchers and Academics
The Agentic RL chapter (SFT to GRPO) and the evaluation chapter provide enough depth to serve as starting points for research projects. The DeepResearch replication is particularly valuable for academic groups studying autonomous information retrieval.

### For Indie Developers and Founders
The capstone project structure and the community-contributed project gallery provide inspiration and reference implementations for shipping agent-powered products. The cyber town simulation chapter demonstrates how agents can create engaging user experiences beyond simple chat interfaces.

---

## Comparison with Alternatives

| Capability | Hello-Agents | Framework Docs (AutoGen, etc.) | Paid Bootcamps | YouTube Tutorials |
|------------|--------------|--------------------------------|----------------|-------------------|
| Structured curriculum | 16 chapters, progressive | Fragmented, assumes knowledge | Varies widely | Unstructured, random |
| Theory depth | Transformer to RL | Framework-specific only | Often shallow | Usually shallow |
| Hands-on coding | Every chapter | Examples only | Limited by cost | Rarely complete |
| Low-code + code-native | Both covered | Code only | Usually one or other | Mixed quality |
| Advanced topics (RL, protocols) | Full chapters | Rarely covered | Premium tier only | Almost never |
| Real-world projects | 3 comprehensive capstones | Usually none | 1-2 projects | Rarely production-grade |
| Community & updates | 71 contributors, active | Vendor-controlled | N/A | Unreliable |
| Price | Free (Apache 2.0) | Free | $500-$5000 | Free |
| Interview preparation | Dedicated Q&A | None | Sometimes | Rarely |

Hello-Agents occupies a unique position: it has the depth of a university course, the practicality of a bootcamp, the community of an open-source project, and the price of free documentation.

---

## The Datawhale Community Advantage

Hello-Agents is not an isolated project. It is produced by **Datawhale**, a community with deep roots in Chinese open-source AI education. Datawhale has produced multiple starred repositories and runs active learning groups, hackathons, and mentorship programs.

This community backing means:
- **Sustained maintenance** — The project receives regular updates as the agent landscape evolves
- **Quality control** — Content is peer-reviewed by practitioners before merge
- **Network effects** — Learners join a community of thousands, not just read documentation in isolation
- **Career connections** — Datawhale's industry partnerships create pathways from learning to employment

---

## Limitations and Considerations

While Hello-Agents is exceptional, learners should be aware of a few constraints:

- **Chinese-language primary** — The main content is in Chinese, though an English README exists and community translations are ongoing
- **Rapid ecosystem change** — Some specific platform instructions (Coze, Dify) may become outdated as those products evolve; the core principles remain valid
- **Hardware requirements** — The Agentic RL chapter benefits from GPU access for training; CPU execution is possible but slow
- **API costs** — Hands-on practice requires OpenAI API or equivalent access; costs can accumulate during intensive experimentation

---

## Conclusion and Getting Started

Hello-Agents is the most comprehensive, accessible, and community-backed resource for learning AI agent development available today. With **45,600+ GitHub stars**, a **16-chapter curriculum** covering everything from Transformer fundamentals to GRPO reinforcement learning, and a **71-person contributor community** continuously expanding the content, it represents an unparalleled educational investment — especially considering it is completely free.

If you are a developer who wants to move beyond prompting ChatGPT and start building systems that autonomously plan, reason, and act, Hello-Agents provides the roadmap. If you are a product leader who needs to understand what agents can and cannot do, the case study chapters offer grounded realism. If you are a researcher entering the agent space, the advanced chapters on protocols and RL provide enough depth to accelerate your work.

**Next steps:**

1. Visit the repository at [github.com/datawhalechina/hello-agents](https://github.com/datawhalechina/hello-agents)
2. Read the online documentation at [datawhalechina.github.io/hello-agents](https://datawhalechina.github.io/hello-agents/)
3. Download the PDF release for offline study
4. Clone the `/code` directory and run the Chapter 4 ReAct implementation
5. Join the community discussion and explore the Extra-Chapter contributions

The agent revolution is not coming — it is here. Hello-Agents ensures you do not just watch it happen. You build it.

---

## Related Articles

- [Anthropics Claude for Financial Services: How AI Agents Automate Investment Banking & Fund Administration](/resources/llm-frameworks/anthropic-financial-services-ai-finance-automation/)

---

## Recommended Infrastructure for Self-Hosting

If you want to run this stack reliably 24/7, infrastructure choice matters:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

<!--auto-references-->
## References & Sources

- [Hello-Agents (datawhalechina/hello-agents)](https://github.com/datawhalechina/hello-agents)
- [Dify](https://github.com/langgenius/dify)
- [n8n](https://github.com/n8n-io/n8n)
- [AutoGen](https://github.com/microsoft/autogen)
- [AgentScope](https://github.com/modelscope/agentscope)
- [LangGraph](https://github.com/langchain-ai/langgraph)
- [Model Context Protocol (MCP)](https://github.com/modelcontextprotocol)
- [A2A (Agent-to-Agent Protocol)](https://github.com/a2aproject/A2A)
- [Ollama](https://github.com/ollama/ollama)
- [Chroma](https://github.com/chroma-core/chroma)
- [Weaviate](https://github.com/weaviate/weaviate)
- [SWE-bench](https://github.com/SWE-bench/SWE-bench)
- [AgentBench](https://github.com/THUDM/AgentBench)
