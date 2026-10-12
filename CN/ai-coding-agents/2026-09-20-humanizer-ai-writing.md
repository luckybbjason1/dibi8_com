---


title: "Install via npx (recommended)"
description: "Humanizer is a powerful agent skill that eliminates AI-generated writing patterns from text while preserving the original meaning"
date: 2026-09-20
slug: "2026-09-20-humanizer-ai-writing"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---


Humanizer is a powerful agent skill that eliminates AI-generated writing patterns from text while preserving the original meaning. Created by blader, it has garnered **49,212 GitHub stars** and **3,993 forks** since its release in January 2026.

This comprehensive guide explores how Humanizer works, its 35-pattern system based on Wikipedia's "Signs of AI writing," and practical applications for content creators, developers, and writers.

## What is Humanizer?

Humanizer is an AI writing detection and remediation tool that rewrites AI-sounding text to read naturally. Unlike generic rewriters, it uses a sophisticated pattern-matching system based on linguistics research from Wikipedia's WikiProject AI Cleanup.

### Key Features

- **35 AI Writing Patterns**: Detects and corrects common AI tells
- **Voice Matching**: Adapts to your writing style when given samples
- **Transparency**: Shows before/after with explanations
- **Factual Preservation**: Never invents details or changes meaning
- **Multi-format Support**: Works with Markdown, code, frontmatter, and more

### How It Works

Humanizer follows a three-step process: 1. **Pattern Detection**: Scans text against 35 known AI writing patterns
2. **Draft Rewrite**: Creates initial humanized version without fixed structure
3. **Quality Check**: Verifies draft against patterns and original claims
4. **Final Output**: Produces polished text that sounds natural

## The 35 AI Writing Patterns

Humanizer addresses patterns identified in Wikipedia's comprehensive "Signs of AI writing" article. Here are the most common ones: ### 1. Repeated Sentence Openings

**Problem**: Multiple sentences start with the same subject (often "It" or "The").

**Example:**
```
Before: It provides features. It offers flexibility. It scales well.
After: The tool provides features, offers flexibility, and scales well.
```

### 2. Dashes as Universal Connectors

**Problem**: Overuse of em-dashes for every clause connection.

**Example:**
```
Before: The tool—which is powerful—offers features that are useful.
After: The powerful tool offers useful features.
```

### 3. Forced Triads

**Problem**: Unnecessary grouping of three items when two would suffice.

**Example:**
```
Before: It's fast, reliable, and secure.
After: It's fast and reliable.
```

### 4. One-Line Closers

**Problem**: Ending paragraphs with dramatic single-sentence conclusions.

**Example:**
```
Before: This changed everything.
After: This was a turning point.
```

### 5. Inflated Claims

**Problem**: Using absolute language like "revolutionary," "game-changing," "ultimate."

**Example:**
```
Before: This is the ultimate solution for all your needs.
After: This solution addresses most common requirements.
```

### 6. Sales Language

**Problem**: Marketing speak that sounds promotional rather than informative.

**Example:**
```
Before: Transform your workflow with this incredible tool!
After: The tool can improve workflow efficiency.
```

### 7. Stock AI Words

**Problem**: Overuse of words like "delve," "tapestry," "landscape," "realm."

**Example:**
```
Before: Let's delve into the rich tapestry of this realm.
After: Here's what you need to know.
```

### 8. Bold Labels Everywhere

**Problem**: Excessive bold text for emphasis that isn't needed.

**Example:**
```
Before: **Key Insight:** Users prefer simplicity.
After: Users prefer simplicity.
```

### 9. Lists with Bold Mini-Headings

**Problem**: Every list item starts with a bold label and colon.

**Example:**
```
Before: - **Feature 1:** Description here
- **Feature 2:** Description here
After: - Description of feature one
- Description of feature two
```

### 10. Curly Quotation Marks

**Problem**: Using curly quotes ("...") instead of straight quotes ("...").

**Example:**
```
Before: He said "the project is on track."
After: He said "the project is on track."
```

## Installation and Setup

### For Claude Code

```bash
# Install via npx (recommended)
npx -y blader/humanizer

# Or clone and link
git clone https://github.com/blader/humanizer.git
cd humanizer
./skills.sh install
```

### For Other AI Agents

Humanizer works with any agent that supports Markdown skills: ```markdown
# Using Humanizer with your text

1. Paste your AI-generated text
2. Add: /humanizer [your text]
3. Review the before/after comparison
4. Apply the humanized version
```

### Voice Matching Setup

To match your personal writing style: ```
/humanizer
Here's a sample of my writing: [Paste 2-3 paragraphs of your own writing]

Now humanize this text: [Paste AI text to rewrite]
```

## Practical Use Cases

### 1. Content Creator Workflow

**Problem**: AI tools generate first drafts that sound robotic.

**Solution**: Run drafts through Humanizer before publishing.

```python
# Example workflow
ai_draft = generate_with_chatgpt("Write about React best practices")
humanized = run_humanizer(ai_draft, voice_sample=my_writing)
final = review_and_edit(humanized)
publish(final)
```

### 2. Technical Documentation

**Problem**: Documentation sounds too promotional or vague.

**Solution**: Use Humanizer to maintain technical accuracy while improving readability.

```
Original: "Our cutting-edge solution leverages synergistic paradigms..."
Humanized: "The tool combines existing patterns for better results."
```

### 3. Academic Writing

**Problem**: AI-generated papers lack personal voice and insight.

**Solution**: Humanizer helps maintain academic tone while removing AI patterns.

### 4. Marketing Copy

**Problem**: Marketing text sounds generic and salesy.

**Solution**: Transform promotional language into authentic messaging.

```
Before: "Unlock unprecedented growth with our revolutionary platform!"
After: "The platform helps teams grow their user base."
```

## Before and After Examples

### Example 1: Product Description

**AI Generated:**
```
In today's rapidly evolving digital landscape, our innovative solution 
provides a comprehensive suite of tools that empower organizations to 
streamline their workflows and unlock unprecedented productivity. 
By leveraging cutting-edge technology and intuitive design, our 
platform delivers an unparalleled user experience that transforms 
how teams collaborate and achieve their goals.
```

**Humanized:**
```
The platform offers tools to streamline workflows and improve 
productivity. Its design focuses on team collaboration and 
helping users achieve their goals.
```

### Example 2: Technical Explanation

**AI Generated:**
```
Furthermore, it is essential to delve deeper into the multifaceted 
nature of this technology. The interplay between various components 
creates a rich tapestry of possibilities that extends far beyond 
the superficial understanding many practitioners possess.
```

**Humanized:**
```
The technology involves multiple components working together. 
This creates more possibilities than most users initially realize.
```

### Example 3: Personal Essay

**AI Generated:**
```
As I reflect upon this journey, I am struck by the profound 
transformations that have occurred. The experience has truly 
been life-changing and has opened doors I never knew existed.
```

**Humanized:**
```
Looking back, things changed a lot. It opened opportunities I 
didn't expect.
```

## Advanced Features

### Pattern Customization

You can customize which patterns to apply: ```
/humanizer --skip=triads --skip=dashes [text]
```

### Output Formatting

Control the output format: ```
/humanizer --format=markdown [text]
/humanizer --format=plain [text]
```

### Confidence Levels

Humanizer shows confidence scores: - **High (90%+)**: Text clearly had AI patterns
- **Medium (60-89%)**: Some patterns detected
- **Low ( humanized.md

# Review changes
git diff ai-draft.md humanized.md
```

## Performance Benchmarks

### Processing Speed

- **Short text (2000 words)**: 5-15 seconds

### Pattern Detection Accuracy

Based on internal testing with 10,000 AI-generated samples: - **Pattern Detection**: 94% accuracy
- **Rewrite Quality**: 89% user satisfaction
- **Meaning Preservation**: 99.2% fidelity

### Comparison with Other Tools

| Tool | Price | Accuracy | Speed | Features |
|
