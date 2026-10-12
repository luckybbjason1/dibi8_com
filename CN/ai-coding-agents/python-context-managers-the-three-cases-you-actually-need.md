---


title: "Environment is back to whatever it was here."
description: "AI tool guide"
date: 2026-09-20
slug: "python-context-managers-the-three-cases-you-actually-need"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---


title: "Python Context Managers: The Three Cases You Actually Need"
description: "AI tool guide"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack: - Go
- Python
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
last_maintained: "2026-05-15"
draft: false
aliases:
  - /en/posts/python-context-managers-the-three-cases/
- /posts/python-context-managers-the-three-cases-you-actually-need/
- /posts/python-context-managers-the-three-cases/
faqs: - q: 'When should you write a custom context manager instead of using try/finally directly?'
    a: 'Write one when leaving the cleanup out would cause the next person to silently leak resources, or when you see the same acquire/release try/finally pattern repeated across a codebase. The win is that the try/finally lives in the helper, so every caller gets it for free and nobody can forget the finally block.'
  - q: 'How do you create a context manager that temporarily sets environment variables and restores them afterward?'
    a: 'Use @contextlib.contextmanager to save each variable''s previous value with os.environ.get(), apply the overrides, yield inside a try, and restore in the finally. Critically, if a variable was absent before (its saved value is None), restore it with os.environ.pop() rather than assigning it, otherwise you write the literal string "None".'
  - q: 'What does contextlib.suppress do and why is it better than try/except: pass?'
    a: 'contextlib.suppress(ExceptionClass) swallows a specific named exception and continues, e.g. ``with suppress(FileNotFoundError): os.unlink("maybe-stale.lock")``. It is clearer than try/except: pass because its limited surface forces you to name the exception class, so you can''t accidentally suppress everything or suppress code below the cleanup.'
  - q: 'How do you write an async context manager in Python?'
    a: 'Decorate an async generator with @contextlib.asynccontextmanager and consume it with ``async with``. The shape is identical to a synchronous one, except you can await inside the body, which suits patterns like acquiring a connection from a pool, running a query, then releasing it in the finally block.'
  - q: 'When should you NOT use a context manager in Python?'
    a: 'Avoid them when the acquire half needs no paired release (just call the function), when cleanup is best-effort and a small inline try/finally reads more clearly, or when the resource is already lifecycle-managed by something else, such as a framework Session. Each ``with`` adds machinery and stacking them hurts readability fast.'