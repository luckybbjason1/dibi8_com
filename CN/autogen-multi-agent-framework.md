---
title: 'AutoGen Tutorial 2025: Building Multi-Agent AI Systems Made Easy'
description: 'Learn Microsoft AutoGen in 2025. Build multi-agent AI systems, create conversational agents, and deploy autonomous workflows with code examples.'
date: 2026-05-18 00:00:00+08:00
lastmod: 2026-05-18 00:00:00+08:00
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
maintainer: 'dibi8'
last_maintained: '2026-05-18'
featureImage: ''
draft: false
aliases:
- /posts/autogen-multi-agent-framework/
---

{</* resource-info */>}

Single LLM calls can write emails and summarize articles. But real-world problems require collaboration: a researcher gathers data, an analyst crunches numbers, a writer drafts a report, and an editor polishes the output. AutoGen, Microsoft's open-source multi-agent framework, automates this kind of teamwork with AI agents.

First released by Microsoft Research in October 2023, AutoGen has rapidly evolved into the most capable framework for building conversational multi-agent systems. With over 34,000 GitHub stars and active development from both Microsoft and the open-source community, it represents a paradigm shift from single-prompt AI to collaborative agent networks.

This tutorial walks you through building your first multi-agent system, then scales up to advanced patterns you can deploy in production.

## What is AutoGen?

AutoGen is a Python framework for building applications where multiple AI agents converse with each other and with humans to accomplish tasks. Unlike single-shot LLM APIs, AutoGen agents can write code, execute it, call external tools, and ask each other clarifying questions — all through a unified conversation interface.

The framework's central innovation is the **conversable agent** — an abstraction that wraps an LLM, tools, and optional human input into an entity that can send and receive messages. When multiple conversable agents chat in a group, they form a multi-agent system capable of complex problem-solving.

### Introduction to Microsoft's AutoGen Framework

AutoGen emerged from Microsoft Research's work on making LLMs more capable through collaboration. The insight is simple: one LLM can write buggy code, but two LLMs — one writing and one reviewing — produce better results. Three LLMs — a planner, a coder, and a tester — perform even better.

The framework handles conversation routing, code execution, human feedback integration, and error recovery automatically. You define the agents and their roles; AutoGen orchestrates the collaboration.

### Core Concept: Conversable Agents

Every AutoGen agent is "conversable" — it participates in structured conversations through a standardized message protocol. Agents do not just exchange text; they share structured messages containing code, execution results, tool calls, and reasoning steps. This structured communication enables agents to actually collaborate rather than just take turns talking.

### AutoGen vs Other Agent Frameworks

| Framework | Agent Model | Best For | Learning Curve |
|-----------|-------------|----------|----------------|
| **AutoGen** | Conversational collaboration | Code generation, data analysis, research | Moderate |
| **CrewAI** | Role-based teams | Business workflows, content creation | Low |
| **LangGraph** | Stateful DAG graphs | Deterministic workflows, human-in-the-loop | High |
| **MetaGPT** | Software engineering simulation | Code generation, system design | Moderate |

AutoGen differentiates itself through native code execution and deep multi-agent conversation support. While CrewAI offers simpler role definitions and LangGraph provides more precise control over execution flow, AutoGen excels when agents need to actually do things — write code, run queries, iterate on solutions.

## AutoGen Architecture and Key Concepts

### ConversableAgent: The Base Agent Class

Every agent in AutoGen extends `ConversableAgent`. This base class provides:

- **LLM backend configuration**: Connect to OpenAI, Azure, or local models
- **System messages**: Define agent personality and role
- **Code execution**: Run Python code in Docker or local environments
- **Tool registration**: Attach callable functions to the agent
- **Human proxy mode**: Pause for human input when needed

### UserProxyAgent: Human-in-the-Loop

The `UserProxyAgent` represents a human user in the conversation. It can execute code locally, make decisions about conversation flow, and prompt for human input when configured. Typically, one `UserProxyAgent` initiates the task and receives the final result.

### AssistantAgent: Code-Writing Agent

The `AssistantAgent` is a pre-configured agent optimized for writing code and following instructions. It cannot execute code directly — it proposes code and the `UserProxyAgent` (or another executor agent) runs it. This separation of writing and execution is a deliberate security design.

### GroupChat: Multi-Agent Collaboration

`GroupChat` enables three or more agents to collaborate. The `GroupChatManager` handles conversation routing, deciding which agent speaks next based on the conversation history and configured selection strategy.

### Chat History and Memory Management

AutoGen maintains full conversation history automatically. Agents can reference previous messages, and the framework handles context window management. For long-running tasks, conversation history can be summarized to stay within model token limits.

## Installation and Setup

### Installing AutoGen

```bash
pip install pyautogen
```

For the latest development features:

```bash
pip install pyautogen --pre
```

### Configuring LLM Endpoints

AutoGen supports multiple LLM backends through a configuration list:

```python
import autogen

config_list = [
    {
        "model": "gpt-4o",
        "api_key": "your-openai-key",
    }
]

# For local models via Ollama or LM Studio
local_config = [
    {
        "model": "llama3.1",
        "base_url": "http://localhost:11434/v1",
        "api_key": "not-needed",
    }
]
```

### Setting Up Your First Agent Configuration

```python
from autogen import AssistantAgent, UserProxyAgent

assistant = AssistantAgent(
    name="assistant",
    llm_config={"config_list": config_list}
)

user_proxy = UserProxyAgent(
    name="user_proxy",
    human_input_mode="NEVER",
    max_consecutive_auto_reply=10,
    code_execution_config={"work_dir": "coding", "use_docker": False}
)
```

## Building Your First Multi-Agent System

### Creating a Simple Two-Agent Conversation

The simplest AutoGen application pairs an assistant with a user proxy:

```python
# Initiate the conversation
user_proxy.initiate_chat(
    assistant,
    message="Write a Python function that calculates the Fibonacci sequence up to n terms, then test it with n=10."
)
```

The assistant writes the code. The user proxy executes it. If the output is wrong, the assistant sees the error and fixes it. This loop continues until the task succeeds or max replies are reached.

### Enabling Code Execution

Code execution is AutoGen's killer feature. Configure it carefully:

```python
code_execution_config = {
    "work_dir": "coding_workspace",  # Where code files are saved
    "use_docker": True,  # Isolate execution in Docker (recommended)
    "timeout": 60,  # Seconds before killing a runaway script
    "last_n_messages": 3,  # How many recent messages to check for code
}
```

Always use Docker for untrusted code. The container isolation prevents agents from accidentally (or maliciously) damaging your system.

### Setting Termination Conditions

Prevent infinite conversations with termination conditions:

```python
user_proxy = UserProxyAgent(
    name="user_proxy",
    is_termination_msg=lambda msg: "TERMINATE" in msg.get("content", ""),
    human_input_mode="NEVER"
)
```

The assistant is instructed to include "TERMINATE" in its final message when the task is complete.

### Running and Observing Agent Interactions

When you run the conversation, AutoGen prints each exchange with clear role indicators. The conversation typically follows this pattern:

1. **Human** sends the task
2. **Assistant** writes code
3. **UserProxy** executes code, returns output
4. **Assistant** reviews output, fixes if needed
5. Repeat until success
6. **Assistant** sends TERMINATE

## Advanced Agent Patterns

### GroupChat with Multiple Agents

GroupChat extends beyond two-agent collaboration:

```python
from autogen import GroupChat, GroupChatManager

# Define specialized agents
planner = AssistantAgent(name="planner", system_prompt="You break down tasks into steps.")
coder = AssistantAgent(name="coder", system_prompt="You write Python code.")
reviewer = AssistantAgent(name="reviewer", system_prompt="You review code for bugs.")

user_proxy = UserProxyAgent(name="user_proxy", code_execution_config={"use_docker": True})

groupchat = GroupChat(
    agents=[user_proxy, planner, coder, reviewer],
    messages=[],
    max_round=12
)

manager = GroupChatManager(groupchat=groupchat, llm_config={"config_list": config_list})

user_proxy.initiate_chat(manager, message="Build a web scraper that extracts titles from Hacker News.")
```

### Sequential Chat Workflows

For deterministic multi-step processes, use sequential chats:

```python
# Step 1: Planning
chat_result1 = user_proxy.initiate_chat(planner, message="Plan a data analysis of sales.csv", clear_history=True)

# Step 2: Execution (pass plan as context)
summary = chat_result1.summary
chat_result2 = user_proxy.initiate_chat(coder, message=f"Execute this plan: {summary}", clear_history=True)
```

### Nested Chat Patterns

Nested chats let agents delegate subtasks to other agents internally. A manager agent might spin up a research sub-conversation, collect results, and incorporate them into its main response. This pattern creates hierarchical agent organizations.

### Human-in-the-Loop and Approval Modes

For sensitive operations, require human approval:

```python
user_proxy = UserProxyAgent(
    name="user_proxy",
    human_input_mode="ALWAYS"  # Prompt for every message
)

# Or use "TERMINATE" mode for approval only before termination
```

### Custom Agent Classes and Behaviors

Extend `ConversableAgent` for custom behaviors:

```python
class DataAnalystAgent(AssistantAgent):
    def __init__(self, **kwargs):
        super().__init__(
            name="data_analyst",
            system_prompt="You are an expert data analyst. Always validate data before analysis.",
            **kwargs
        )

    def generate_reply(self, messages, sender, config):
        # Custom logic before generating reply
        return super().generate_reply(messages, sender, config)
```

## AutoGen with Local and Open-Source Models

### Using Ollama with AutoGen

AutoGen works with any OpenAI-compatible API, including Ollama:

```python
config_list = [{
    "model": "llama3.1:8b",
    "base_url": "http://localhost:11434/v1",
    "api_key": "ollama",
    "price": [0, 0],  # Local models are free
}]
```

Note that smaller models struggle with complex multi-agent coordination. For reliable results with local models, use models with at least 7 billion parameters and strong instruction-following capabilities like Llama 3.1 or Qwen 2.5.

### Integrating vLLM and LM Studio

vLLM provides high-throughput local serving for open-source models. Configure AutoGen to point at your vLLM endpoint:

```python
vllm_config = [{
    "model": "mistralai/Mistral-7B-Instruct-v0.3",
    "base_url": "http://localhost:8000/v1",
    "api_key": "not-needed",
}]
```

### Cost Optimization Strategies

Multi-agent systems consume significant API tokens. Optimize costs:

- **Use cheaper models for simple tasks**: GPT-4o-mini for planning, GPT-4o only for complex reasoning
- **Limit max_round**: Prevent runaway conversations
- **Cache LLM responses**: AutoGen supports caching to avoid redundant API calls
- **Use local models for code execution feedback**: You do not need GPT-4 to tell you a script ran successfully

## Real-World Use Cases

### Automated Data Analysis Pipeline

A three-agent system can automate exploratory data analysis:

1. **Planner** agent outlines analysis steps
2. **Coder** agent writes pandas and matplotlib code
3. **Reporter** agent summarizes findings in natural language

This pipeline turns raw CSV files into documented insights without human intervention.

### Multi-Agent Code Review System

Simulate a development team:

1. **Developer** writes the initial implementation
2. **Reviewer** checks for bugs, performance issues, and style violations
3. **Tester** writes and runs unit tests
4. **Architect** verifies design patterns and consistency

The system iterates until all agents approve or max rounds are reached.

### Research Assistant with Web Search

Combine AutoGen with search tools:

```python
from autogen.register_function import register_function

def web_search(query: str) -> str:
    """Search the web for information."""
    # Implementation using DuckDuckGo or similar
    return results

register_function(web_search, caller=assistant, executor=user_proxy)
```

The research agent searches, synthesizes, and cites sources — useful for literature reviews and competitive analysis.

### Content Creation Workflow

A content team simulation:

1. **Strategist** defines topic and angle
2. **Writer** produces the draft
3. **Editor** improves clarity and grammar
4. **SEO specialist** optimizes keywords and structure

## AutoGen + LangGraph: When to Choose What

### AutoGen for Conversational Multi-Agent

Choose AutoGen when your agents need to have open-ended conversations, write and execute code, and collaborate dynamically. AutoGen excels at creative problem-solving where the path to the solution is not known in advance.

### LangGraph for Stateful DAG Workflows

Choose LangGraph when you need precise control over execution flow — specific branching logic, guaranteed checkpoints, and reproducible state transitions. LangGraph represents workflows as graphs, making it better for regulated environments where every decision must be auditable.

### Integration Possibilities

You can combine both frameworks. Use LangGraph to define the high-level workflow (data ingestion → processing → validation → output), and AutoGen for the processing step where multiple agents collaborate on the actual analysis.

## Best Practices and Production Tips

### Managing Token Costs

Multi-agent conversations multiply token usage. A single task might involve 20+ LLM calls across multiple agents. Strategies to control costs:

- Set `max_consecutive_auto_reply` low (5-10)
- Use the cheapest model that handles the task
- Enable the built-in cache: `autogen.Cache.disk_cache_root = "./cache"`
- Monitor usage with `ChatResult.cost` after each conversation

### Error Handling and Retries

Agent conversations can derail. Implement safeguards:

- Set `max_round` on GroupChat to prevent infinite loops
- Use `is_termination_msg` to detect natural conversation endings
- Wrap agent calls in try-except blocks for production applications
- Log all conversations for debugging

### Security Considerations for Code Execution

**Never** enable code execution without Docker isolation on production systems. Even benign-looking code can access environment variables, network resources, and the file system. Best practices:

- Always set `use_docker: True`
- Mount only necessary directories as volumes
- Set reasonable timeouts (30-60 seconds)
- Review and whitelist allowed Python packages

### Debugging Agent Conversations

When agents fail to cooperate:

1. Check the system prompt — unclear roles cause confusion
2. Reduce agent count — start with two agents, add more gradually
3. Review the conversation log — identify where it derailed
4. Adjust the GroupChat speaker selection strategy
5. Use stronger models — GPT-4o significantly outperforms GPT-4o-mini for agent coordination

## Frequently Asked Questions

### What is AutoGen used for?

AutoGen builds multi-agent AI systems where multiple LLM instances collaborate to solve complex tasks. Common use cases include automated data analysis, code generation and review, research synthesis, content creation workflows, and simulation of expert teams (development, marketing, research). Any problem that benefits from multiple perspectives or specialized roles is a good fit for AutoGen.

### Is AutoGen free and open source?

Yes, AutoGen is open-source under the MIT license and free to use. You can install it with `pip install pyautogen`. You pay only for the LLM API calls your agents make — OpenAI, Azure, or your local compute. Microsoft Research maintains the core framework with active community contributions.

### AutoGen vs CrewAI: What is the difference?

CrewAI emphasizes role-based agent definitions with a simpler API — you define agents, tasks, and crews declaratively. AutoGen focuses on conversational collaboration with native code execution and more flexible conversation patterns. Choose CrewAI for straightforward business workflows with clear task sequences. Choose AutoGen for problems requiring code generation, iterative debugging, and open-ended agent conversations.

### Can AutoGen run with local LLMs?

Yes, AutoGen works with any OpenAI-compatible API endpoint. Configure it to use Ollama, LM Studio, vLLM, or any local inference server. However, multi-agent coordination requires strong instruction-following capabilities. Models below 7 billion parameters often struggle with complex agent interactions. For best results, use strong local models like Llama 3.1 8B, Qwen 2.5 7B, or Mistral 7B.

### How does AutoGen handle code execution security?

AutoGen separates code generation from execution. The `AssistantAgent` writes code; the `UserProxyAgent` executes it. By default, AutoGen runs code in a Docker container, isolating it from the host system. Always enable Docker isolation (`use_docker: True`) in production. Set timeouts, limit file system access, and whitelist packages to minimize security risks.

## Conclusion and Getting Started Resources

AutoGen represents a fundamental shift in how we build AI applications — from single-model prompts to collaborative agent networks. The framework's native support for code execution, flexible conversation patterns, and human-in-the-loop integration makes it uniquely capable for tasks that require actual problem-solving rather than just text generation.

Start with a simple two-agent setup: a `UserProxyAgent` and an `AssistantAgent`. Give them a coding task and observe the collaboration loop. Then experiment with `GroupChat` for multi-agent scenarios, add custom tools for domain-specific capabilities, and configure local models to control costs.

For production deployments, always use Docker isolation, implement termination conditions, and monitor token usage. The framework is powerful but requires careful configuration to prevent runaway conversations and unexpected API bills.

The future of AI is multi-agent. AutoGen gives you the tools to build that future today.

For more resources, visit the [official AutoGen documentation](https://microsoft.github.io/autogen/) and explore examples in the [GitHub repository](https://github.com/microsoft/autogen).

---

## Recommended Infrastructure

To run any of the tools above reliably 24/7, infrastructure matters:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit, 14+ global regions, one-click droplets for AI/dev workloads.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low latency for mainland China access. This is the same IDC hosting dibi8.com — production-proven.

*Affiliate links — no extra cost to you, helps keep dibi8.com running.*

