---
title: 'Python Context Managers: The Three Cases You Actually Need'
description: 'Python context managers: the three cases you actually need. Master with
  statements, contextlib and custom context managers for better resource management.'
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Go
- Python
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: ''
last_maintained: '2026-05-15'
featureImage: ''
draft: false
aliases:
- /en/posts/python-context-managers-the-three-cases/
- /posts/python-context-managers-the-three-cases-you-actually-need/
- /posts/python-context-managers-the-three-cases/
faqs:
  - q: 'When should you write a custom context manager instead of using try/finally directly?'
    a: 'Write one when leaving the cleanup out would cause the next person to silently leak resources, or when you see the same acquire/release try/finally pattern repeated across a codebase. The win is that the try/finally lives in the helper, so every caller gets it for free and nobody can forget the finally block.'
  - q: 'How do you create a context manager that temporarily sets environment variables and restores them afterward?'
    a: 'Use @contextlib.contextmanager to save each variable''s previous value with os.environ.get(), apply the overrides, yield inside a try, and restore in the finally. Critically, if a variable was absent before (its saved value is None), restore it with os.environ.pop() rather than assigning it, otherwise you write the literal string "None".'
  - q: 'What does contextlib.suppress do and why is it better than try/except: pass?'
    a: 'contextlib.suppress(ExceptionClass) swallows a specific named exception and continues, e.g. `with suppress(FileNotFoundError): os.unlink("maybe-stale.lock")`. It is clearer than try/except: pass because its limited surface forces you to name the exception class, so you can''t accidentally suppress everything or suppress code below the cleanup.'
  - q: 'How do you write an async context manager in Python?'
    a: 'Decorate an async generator with @contextlib.asynccontextmanager and consume it with `async with`. The shape is identical to a synchronous one, except you can await inside the body, which suits patterns like acquiring a connection from a pool, running a query, then releasing it in the finally block.'
  - q: 'When should you NOT use a context manager in Python?'
    a: 'Avoid them when the acquire half needs no paired release (just call the function), when cleanup is best-effort and a small inline try/finally reads more clearly, or when the resource is already lifecycle-managed by something else, such as a framework Session. Each `with` adds machinery and stacking them hurts readability fast.'
---

{</* resource-info */>}

Most introductions to context managers in Python show one example —
`with open("file.txt") as f:` — and call it a day. That's enough to use
them, but it doesn't tell you when to *write* one.

After a few years of writing Python services, I keep reaching for context
managers in three specific situations. Each one solves a problem that
`try`/`finally` can technically solve but tends to get wrong in practice.

## Case 1: Pairing acquire and release

The classic case. You have something that must be released —
a lock, a database connection, a temporary file, a network socket — and
you want to make sure release happens even if the code in between raises.

```python
from contextlib import contextmanager
import threading

_lock = threading.Lock()

@contextmanager
def critical_section():
    _lock.acquire()
    try:
        yield
    finally:
        _lock.release()

with critical_section():
    do_dangerous_thing()
```

Why not just `try`/`finally`? You can — and at the call site, that's all
the context manager expands to. The win is that the `try`/`finally` lives
in the *helper*, not the call site. Every caller gets it for free, and
nobody can forget to write the `finally` block.

When I see five copies of `try: thing.acquire(); ...; finally:
thing.release()` in a codebase, I know there's a context manager waiting
to be extracted.

## Case 2: Temporarily changing global-ish state

This one is less talked about, but it's where context managers really
earn their keep. You want to flip some setting for the duration of a
block, and you want it back to what it was no matter how the block exits.

```python
import os
from contextlib import contextmanager

@contextmanager
def env(**overrides):
    """Temporarily set environment variables, restoring previous values on exit."""
    saved = {k: os.environ.get(k) for k in overrides}
    os.environ.update({k: str(v) for k, v in overrides.items()})
    try:
        yield
    finally:
        for k, prev in saved.items():
            if prev is None:
                os.environ.pop(k, None)
            else:
                os.environ[k] = prev

with env(DEBUG="1", REGION="us-east-1"):
    run_test_suite()
# Environment is back to whatever it was here.
```

The same pattern works for `sys.path`, `logging` levels, `decimal`
contexts, mocked attributes — anything that follows the "save, change,
restore" shape. Tests in particular benefit from this; the alternative
is fixtures that leak when something raises mid-test.

The subtle part is **restoring `None` correctly**. A common bug is to do
`os.environ[k] = saved[k]` without checking — that writes the literal
string `"None"` into the variable when it didn't exist before. Always
restore "absent" as `pop`, not as a string.

## Case 3: Suppressing exceptions you genuinely want to ignore

Sometimes you really do want to swallow a specific exception class and
move on. Python ships `contextlib.suppress` for this:

```python
from contextlib import suppress

with suppress(FileNotFoundError):
    os.unlink("maybe-stale.lock")
```

This is dramatically clearer than the equivalent `try`/`except: pass`,
*because the limited surface forces you to be specific*. You can't
accidentally suppress everything — you have to name the class. And you
can't accidentally suppress code below the cleanup; the `with` block's
scope is exactly what you wrote.

I find this useful for cleanup in destructors and atexit handlers, where
you really cannot afford the cleanup itself to raise.

## When *not* to write one

Context managers are not free. Each `with` introduces a small amount of
machinery, and stacking them affects readability fast. I avoid them
when:

- The "acquire" half doesn't actually need a paired "release" — just
  call the function.
- The cleanup is best-effort and the scope is small enough that
  `try`/`finally` reads more clearly inline.
- The thing being managed is already managed by something else (e.g.
  don't wrap a `Session` from a framework that already context-manages
  its own lifecycle).

The test I use: *"if I leave the cleanup out, will the next person
silently leak resources?"* If yes, write the context manager. If no, a
plain function is fine.

## A note on async

In `async` code, use `@asynccontextmanager` and `async with`. The shape
is identical; the only thing to remember is that you can `await` inside
the body, which makes the pattern even more useful for things like
"acquire a connection from a pool, run a query, return it."

```python
from contextlib import asynccontextmanager

@asynccontextmanager
async def borrowed(pool):
    conn = await pool.acquire()
    try:
        yield conn
    finally:
        await pool.release(conn)
```

That's it. Three patterns covers maybe 90% of the context managers
I've written. The other 10% are weird and you'll know one when you see
it.


## Related Articles

- [Scrapling Reviewed: A Faster, Stealthier Take on Python Scraping](/resources/dev-utils/scrapling-python-stealthy-web-scraping-review/) — Advanced Python scraping
- [Reading EXPLAIN ANALYZE in Postgres Without Getting Lost](/resources/ai-tools/reading-explain-analyze-postgres/) — Database performance optimization
- [Free Claude Code: Use Claude Code CLI for Free with Any AI Provider](/resources/ai-tools/free-claude-code-open-source-proxy/) — AI-assisted coding

---

## Recommended Tools

For developers building or deploying open-source AI tools, we recommend:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for new users, 14+ global regions, one-click GPU/CPU droplets ideal for AI workloads.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API proxy. Most AI tools above (chatbots, code gen, translation, search, etc) need an LLM API key — this proxy delivers stable access to top models at ~30% of official pricing.

*Affiliate link — supports dibi8.com at no cost to you.*

<!--auto-references-->
## References & Sources

- [contextlib (Python standard library)](https://docs.python.org/3/library/contextlib.html)
- [CPython](https://github.com/python/cpython)
- [Python with statement reference](https://docs.python.org/3/reference/compound_stmts.html#the-with-statement)
