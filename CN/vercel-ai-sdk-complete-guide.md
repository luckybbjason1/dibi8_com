---
title: Vercel AI SDK — The Universal Framework for Building AI-Powered Applications
description: Complete guide to Vercel AI SDK, the provider-agnostic framework for building AI-powered chat interfaces, streaming responses, and tool calling. Works with React Server Components, Next.js, SvelteKit, and more.
category: llm-frameworks
tags: ['ai-sdk', 'vercel', 'react-server-components', 'streaming', 'tool-calling', 'llm-integration']
slug: vercel-ai-sdk-complete-guide
date: 2026-07-17 00:00:00+00:00
featureImage: /images/articles/vercel-ai-sdk.jpg
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

The AI SDK follows a layered architecture:

1. **Core Layer**: Provider-agnostic API for LLM interactions (text generation, embeddings)
2. **Adapter Layer**: Provider-specific implementations (OpenAI, Anthropic, Google, etc.)
3. **UI Layer**: React components for streaming chat interfaces
4. **Middleware Layer**: Server-side helpers for route handlers and API endpoints

```typescript
// Provider-agnostic API
import { generateText } from 'ai';
import { openai } from '@ai-sdk/openai';

const { text } = await generateText({
  model: openai('gpt-4o'),
  prompt: 'Write a poem about artificial intelligence',
});
```

## Installation Guide

### Basic Installation

```bash
npm install ai
# Or with specific provider
npm install ai @ai-sdk/openai @ai-sdk/anthropic
```

### Next.js Project Setup

```bash
npx create-next-app@latest my-ai-app --typescript
cd my-ai-app
npm install ai @ai-sdk/openai
```

Create `.env.local`:

```
OPENAI_API_KEY=sk-your-key-here
ANTHROPIC_API_KEY=sk-ant-your-key-here
```

### Verify Installation

```typescript
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
```

## Core APIs

### Text Generation

The simplest way to interact with LLMs:

```typescript
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
```

### Chat Completions

Build conversational interfaces with message history:

```typescript
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
```

### Embedding Generation

Create vector representations for semantic search:

```typescript
import { embed } from 'ai';
import { openai } from '@ai-sdk/openai';

const { embedding } = await embed({
  model: openai.embedding('text-embedding-3-small'),
  value: 'Machine learning is a subset of artificial intelligence',
});

console.log(`Embedding dimension: ${embedding.length}`);
// Output: Embedding dimension: 1536
```

### Structured Outputs

Generate typed JSON responses:

```typescript
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
```

## Streaming Responses

### Text Stream

Real-time token streaming for chat interfaces:

```typescript
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
```

### Data Stream

Send custom structured data alongside text:

```typescript
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
```

### Client-Side Streaming Component

```tsx
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
          <div key={m.id} className={`message ${m.role}`}>
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
```

## Tool Calling

### Defining Tools

Define tools that the model can call:

```typescript
import { tool } from 'ai';
import { z } from 'zod';

const result = await generateText({
  model: openai('gpt-4o'),
  messages: [
    { role: 'user', content: 'What is the weather in San Francisco?' },
  ],
  tools: {
    getWeather: tool({
      description: 'Get the current weather for a location',
      parameters: z.object({
        location: z.string().describe('City name, e.g. San Francisco'),
        unit: z.enum(['celsius', 'fahrenheit']).default('celsius'),
      }),
      execute: async ({ location, unit }) => {
        const response = await fetch(
          `https://api.weather.com/${location}?unit=${unit}`
        );
        return response.json();
      },
    }),
    searchWeb: tool({
      description: 'Search the web for information',
      parameters: z.object({
        query: z.string().describe('Search query'),
        maxResults: z.number().default(5),
      }),
      execute: async ({ query, maxResults }) => {
        const results = await performSearch(query, maxResults);
        return results;
      },
    }),
  },
});

// Access tool calls and results
if (result.toolResults && result.toolResults.length > 0) {
  console.log('Tools called:', result.toolCalls);
}
```

### Streaming Tool Execution

Execute tools while streaming the response:

```typescript
import { streamText } from 'ai';

const result = streamText({
  model: anthropic('claude-3-5-sonnet-20241022'),
  messages: [{ role: 'user', content: 'Search for React performance tips' }],
  tools: {
    search: tool({
      description: 'Search for information on a topic',
      parameters: z.object({ query: z.string() }),
      execute: async ({ query }) => {
        return await searchEngine(query);
      },
    }),
  },
  onStepFinish: ({ toolResults }) => {
    // Process tool results after each step
    toolResults.forEach((tr) => {
      console.log(`Tool ${tr.toolName} returned:`, tr.result);
    });
  },
});
```

## Provider Integration

### Supported Providers

| Provider | Package | Models Available |
|----------|---------|-----------------|
| OpenAI | @ai-sdk/openai | GPT-4o, GPT-4 Turbo, o1 |
| Anthropic | @ai-sdk/anthropic | Claude 3.5 Sonnet, Haiku |
| Google | @ai-sdk/google | Gemini Pro, Gemini Ultra |
| Mistral | @ai-sdk/mistral | Mistral Large, Small |
| Groq | @ai-sdk/groq | Llama 3, Mixtral |
| Together | @ai-sdk/together | Various open models |
| Cohere | @ai-sdk/cohere | Command R+, R |
| AWS Bedrock | @ai-sdk/aws-bedrock | Claude, Llama, Titan |

### Multi-Provider Fallback

Implement provider fallback for reliability:

```typescript
import { generateText } from 'ai';
import { openai } from '@ai-sdk/openai';
import { anthropic } from '@ai-sdk/anthropic';

async function generateWithFallback(prompt: string) {
  // Try primary provider first
  try {
    return await generateText({
      model: anthropic('claude-3-5-sonnet-20241022'),
      prompt,
    });
  } catch (error) {
    console.log('Primary failed, falling back to OpenAI');
    
    // Fall back to secondary provider
    return await generateText({
      model: openai('gpt-4o'),
      prompt,
    });
  }
}
```

### Custom Provider

Integrate with any provider using the custom adapter:

```typescript
import { createCustomProvider } from 'ai';

const myProvider = createCustomProvider({
  languageModels: {
    'my-model': {
      generateOutput: async (prompt, options) => {
        const response = await fetch('https://api.myprovider.com/generate', {
          method: 'POST',
          headers: { 'Authorization': `Bearer ${process.env.MY_API_KEY}` },
          body: JSON.stringify({ prompt, ...options }),
        });
        
        const data = await response.json();
        return {
          text: data.generated_text,
          usage: { promptTokens: data.prompt_tokens, completionTokens: data.tokens_used },
        };
      },
    },
  },
});
```

## Production Patterns

### Next.js Route Handler

```typescript
// app/api/chat/route.ts
import { streamText } from 'ai';
import { openai } from '@ai-sdk/openai';

export async function POST(req: Request) {
  const { messages } = await req.json();
  
  const result = streamText({
    model: openai('gpt-4o'),
    system: 'You are a helpful assistant specialized in answering technical questions.',
    messages,
    maxTokens: 2048,
    temperature: 0.7,
  });
  
  return result.toDataStreamResponse();
}
```

### Rate Limiting

Implement rate limiting for API endpoints:

```typescript
import { Ratelimit } from '@upstash/ratelimit';
import { Redis } from '@upstash/redis';

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, '1 m'),
});

export async function POST(req: Request) {
  const ip = req.headers.get('x-forwarded-for') || 'anonymous';
  const { success } = await ratelimit.limit(ip);
  
  if (!success) {
    return new Response('Rate limit exceeded', { status: 429 });
  }
  
  // ... proceed with chat generation
}
```

### Cost Tracking

Monitor API usage and costs:

```typescript
interface UsageMetrics {
  totalTokens: number;
  promptTokens: number;
  completionTokens: number;
  costUSD: number;
}

const COST_PER_TOKEN: Record<string, number> = {
  'gpt-4o': { prompt: 0.000005, completion: 0.000015 },
  'claude-3-5-sonnet': { prompt: 0.000003, completion: 0.000015 },
};

function trackUsage(modelId: string, usage: { promptTokens: number; completionTokens: number }): UsageMetrics {
  const rates = COST_PER_TOKEN[modelId];
  const costUSD = (usage.promptTokens * rates.prompt) + (usage.completionTokens * rates.completion);
  
  return {
    totalTokens: usage.promptTokens + usage.completionTokens,
    promptTokens: usage.promptTokens,
    completionTokens: usage.completionTokens,
    costUSD,
  };
}
```

### Caching Responses

Cache common queries to reduce API costs:

```typescript
import { kv } from '@vercel/kv';

async function getCachedResponse(key: string) {
  const cached = await kv.get(`response:${key}`);
  if (cached) return cached as string;
  return null;
}

async function setCachedResponse(key: string, value: string) {
  await kv.set(`response:${key}`, value, { ex: 3600 }); // 1 hour TTL
}

// Usage in route handler
const cacheKey = hashUserInput(input);
let response = await getCachedResponse(cacheKey);

if (!response) {
  const result = await generateText({ model, prompt: input });
  response = result.text;
  await setCachedResponse(cacheKey, response);
}
```

## Comparison with Alternatives

| Feature | Vercel AI SDK | LangChain | LlamaIndex | Semantic Kernel |
|---------|--------------|-----------|------------|----------------|
| TypeScript Native | ✅ | Partial | ❌ | ❌ |
| React Components | ✅ | ❌ | ❌ | ❌ |
| Streaming UI | ✅ | Manual | Manual | Manual |
| Tool Calling | ✅ | ✅ | Limited | ✅ |
| Provider Support | 20+ | 50+ | 30+ | 20+ |
| Learning Curve | Easy | Steep | Moderate | Steep |
| Bundle Size | ~50KB | ~200KB | ~150KB | ~100KB |
| RSC Support | ✅ | ❌ | ❌ | ❌ |

## FAQ

### Q1: Does the AI SDK support React Server Components?

Yes, the AI SDK has first-class support for React Server Components. You can use the `generateText`, `streamText`, and `generateObject` functions directly in server components, and the `useChat` and `useCompletion` hooks work seamlessly with RSC streaming.

### Q2: Can I use the AI SDK with frameworks other than Next.js?

Yes, the AI SDK works with SvelteKit, SolidStart, Nuxt, Remix, Express, Hono, and any framework that supports Node.js or edge runtime. The core API is framework-agnostic, and the UI components are designed to be easily adaptable.

### Q3: How do I handle errors gracefully?

Wrap AI SDK calls in try-catch blocks and implement fallback logic. The SDK throws specific error types (`APICallError`, `InvalidResponseDataError`) that you can catch and handle differently. Always implement a fallback provider or a friendly error message for users.

### Q4: Is the AI SDK free to use?

Yes, the AI SDK itself is MIT licensed and completely free. However, you still need API keys and credits for the underlying LLM providers (OpenAI, Anthropic, Google, etc.). The SDK does not charge any additional fees.

### Q5: How do I implement authentication for my AI app?

Use middleware to verify authentication before processing requests. Integrate with NextAuth.js, Clerk, or Supabase Auth to protect your API routes. Store API keys in environment variables and never expose them to the client side.

### Q6: Can I customize the streaming behavior?

Yes, you can control streaming through options like `maxTokens`, `temperature`, `topP`, and `stopSequences`. For custom streaming behavior, use the `fullStream` API which gives you access to every event including tool calls, metadata, and usage information.

### Q7: How do I deploy AI SDK apps to production?

Deploy to Vercel for the best experience with automatic edge runtime support. You can also deploy to any Node.js hosting provider, Docker containers, or cloud platforms that support serverless functions. Make sure to set environment variables for API keys.

## Sources

- [Vercel AI SDK GitHub Repository](https://github.com/vercel/ai)
- [AI SDK Documentation](https://sdk.vercel.ai/docs)
- [Vercel AI SDK Examples](https://github.com/vercel/ai/tree/main/examples)
- [React Server Components Documentation](https://react.dev/reference/rsc/server-components)

## Call to Action

Build your next AI-powered application with the Vercel AI SDK. [Explore the docs](https://dibi8.com/auth/) and join thousands of developers creating amazing AI experiences.
