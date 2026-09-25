---
title: "Or with specific provider"
description: "Vercel AI SDK is the most popular open-source framework for building AI-powered user interfaces in 2026, supporting 30k+ stars on GitHub"
date: 2026-09-20
slug: "vercel-ai-sdk-complete-guide"
category: "ai-tools"
tags: ["ai", "tools"]
---


## TL;DR

Vercel AI SDK is the most popular open-source framework for building AI-powered user interfaces in 2026, supporting 30k+ stars on GitHub. This comprehensive guide covers installation, streaming responses, tool calling, provider integration, and production deployment patterns for building chat interfaces, AI assistants, and generative UI applications.

## What Is Vercel AI SDK?

Vercel AI SDK is a TypeScript library that provides a unified API for integrating large language models into web applications. It supports both server-side and client-side rendering, making it compatible with React Server Components, Next.js, SvelteKit, SolidStart, and Nuxt. The SDK handles streaming, error handling, and provider abstraction so you can switch between OpenAI, Anthropic, Google Gemini, and other providers without changing your application code.

### Key Features

- **Provider Agnostic**: Switch between OpenAI, Anthropic, Google, Mistral, and 20+ providers with minimal code changes
- **React Server Components**: Native support for RSC streaming and server-side rendering
- **Streaming Responses**: Real-time token-by-token streaming with built-in UI components
- **Tool Calling**: Built-in support for function calling and tool execution
- **Type Safety**: Full TypeScript support with automatic type inference for model outputs
- **Framework Support**: Works with Next.js, SvelteKit, SolidStart, Nuxt, Express, and Hono
- **UI Components**: Pre-built streaming UI components for rapid development
- **Data Streaming**: Custom data streaming beyond text for rich interactive experiences

### Architecture Overview

The AI SDK follows a layered architecture: 1. **Core Layer**: Provider-agnostic API for LLM interactions (text generation, embeddings)
2. **Adapter Layer**: Provider-specific implementations (OpenAI, Anthropic, Google, etc.)
3. **UI Layer**: React components for streaming chat interfaces
4. **Middleware Layer**: Server-side helpers for route handlers and API endpoints

````typescript
// Provider-agnostic API
import { generateText } from 'ai';
import { openai } from '@ai-sdk/openai';

const { text } = await generateText({
  model: openai('gpt-4o'),
  prompt: 'Write a poem about artificial intelligence',
});
`````

## Installation Guide

### Basic Installation

`````bash
npm install ai
# Or with specific provider
npm install ai @ai-sdk/openai @ai-sdk/anthropic
`````

### Next.js Project Setup

`````bash
npx create-next-app@latest my-ai-app --typescript
cd my-ai-app
npm install ai @ai-sdk/openai
`````

Create ``.env.local``: `````
OPENAI_API_KEY=sk-your-key-here
ANTHROPIC_API_KEY=sk-ant-your-key-here
`````

### Verify Installation

`````typescript
import { generateText } from 'ai';
import { openai } from '@ai-sdk/openai';

async function main() {
  const { text, usage } = await generateText({
    model: openai('gpt-4o-mini'),
    prompt: 'Say hello in 5 words',
  });
  
  console.log(text); // "Hello! How can I help you today?"
  console.log(usage); // { promptTokens: 10, completionTokens: 8 }
}

main();
`````

## Core APIs

### Text Generation

The simplest way to interact with LLMs: `````typescript
import { generateText } from 'ai';
import { anthropic } from '@ai-sdk/anthropic';

const { text, toolCalls, toolResults, usage } = await generateText({
  model: anthropic('claude-3-5-sonnet-20241022'),
  prompt: 'What is the weather in Tokyo?',
  maxTokens: 500,
  temperature: 0.7,
});

console.log(text);
console.log('Tokens used:', usage.totalTokens);
`````

### Chat Completions

Build conversational interfaces with message history: `````typescript
import { streamText } from 'ai';
import { openai } from '@ai-sdk/openai';

const result = streamText({
  model: openai('gpt-4o'),
  system: 'You are a helpful coding assistant.',
  messages: [
    { role: 'user', content: 'How do I reverse a linked list?' },
  ],
  maxTokens: 1000,
  temperature: 0.3,
});

for await (const textPart of result.textStream) {
  process.stdout.write(textPart);
}
`````

### Embedding Generation

Create vector representations for semantic search: `````typescript
import { embed } from 'ai';
import { openai } from '@ai-sdk/openai';

const { embedding } = await embed({
  model: openai.embedding('text-embedding-3-small'),
  value: 'Machine learning is a subset of artificial intelligence',
});

console.log(````Embedding dimension: ${embedding.length}````);
// Output: Embedding dimension: 1536
`````

### Structured Outputs

Generate typed JSON responses: `````typescript
import { generateObject } from 'ai';
import { z } from 'zod';

const movie = await generateObject({
  model: openai('gpt-4o'),
  schema: z.object({
    title: z.string(),
    year: z.number(),
    genre: z.enum(['Action', 'Drama', 'Comedy', 'Sci-Fi']),
    rating: z.number().min(0).max(10),
  }),
  prompt: 'Recommend a great sci-fi movie from the 2020s',
});

console.log(movie.object.title); // Example: "Dune: Part Two"
`````

## Streaming Responses

### Text Stream

Real-time token streaming for chat interfaces: `````typescript
import { streamText } from 'ai';
import { anthropic } from '@ai-sdk/anthropic';

const result = streamText({
  model: anthropic('claude-3-5-sonnet-20241022'),
  messages: [{ role: 'user', content: 'Explain quantum computing' }],
  onFinish: ({ text, usage }) => {
    console.log('Generation complete');
    console.log('Tokens:', usage);
  },
});

// Consume the stream
const fullText = result.textStream;
for await (const chunk of fullText) {
  console.log(chunk);
}
`````

### Data Stream

Send custom structured data alongside text: `````typescript
import { streamResponse } from 'ai';

export async function POST(request: Request) {
  return streamResponse(
    request,
    async ({ sendMessage, abortController }) => {
      sendMessage('loading', { status: 'processing' });
      
      const result = await streamText({
        model: openai('gpt-4o'),
        prompt: 'Analyze this data and provide insights',
        onFinish: ({ text }) => {
          sendMessage('complete', { analysis: text });
        },
      });
      
      // Send intermediate data chunks
      for await (const part of result.fullStream) {
        if (part.type === 'step-start') {
          sendMessage('step', { step: part.stepIndex });
        }
      }
    },
  );
}
`````

### Client-Side Streaming Component

`````tsx
'use client';

import { useChat } from '@ai-sdk/react';

export default function Chat() {
  const { messages, input, handleSubmit, isLoading } = useChat({
    api: '/api/chat',
    onResponse(response) {
      console.log('Response received');
    },
    onFinish() {
      console.log('Generation complete');
    },
  });

  return (
    <div className="chat-container">
      <div className="messages">
        {messages.map((m) => (
          <div key={m.id} className={````message ${m.role}````}>
            <strong>{m.role === 'user' ? 'You' : 'AI'}:</strong>
            <p>{m.content}</p>
          </div>
        ))}
      </div>
      
      <form onSubmit={handleSubmit}>
        <input 
          value={input} 
          onChange={(e) => setInput(e.target.value)}
          placeholder="Ask anything..."
        />
        <button type="submit" disabled={isLoading}>
          {isLoading ? 'Thinking...' : 'Send'}
        </button>
      </form>
    </div>
  );
}
`````

## Tool Calling

### Defining Tools

Define tools that the model can call: ````typescript
import { tool } from 'ai';
import { z } from 'zod';

const result = await generateText({
  model: openai('gpt-4o'),
  messages: [
    { role: 'user', content: 'What is the weather in San Francisco?' },
  ],
  tools: {
    getWeather: tool({
      description: "Vercel AI SDK is the most popular open-source framework for building AI-powered user interfaces in 2026, supporting 30k+ stars on GitHub"
      parameters: z.object({
        location: z.string().d..."
  },
  "publisher": {
    "@type": "Organization",
    "name": "Dibi8",
    "logo": {
      "@type": "ImageObject",
      "url": "https://dibi8.com/logo.png"
    }
  },
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": "https://dibi8.com/resources/vercel-ai-sdk-complete-guide"
  }
}
</script>


* * *
## Related Articles

- [vercel-ai-sdk-edge-compute](vercel-ai-sdk-complete-guide)
- [vercel-ai-sdk-edge-compute](vercel-ai-sdk-complete-guide)
- [vercel-ai-sdk-edge-compute](vercel-ai-sdk-complete-guide)
- [vercel-ai-sdk-edge-compute](vercel-ai-sdk-complete-guide)


* * *
*Found this helpful? [Join our Telegram community](https://t.me/DIBI8_Group) for daily AI tool updates!*
