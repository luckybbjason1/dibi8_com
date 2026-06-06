---
title: Python 上下文管理器：你真正需要的三个场景
description: Python 上下文管理器：你真正需要的三个场景。掌握 with 语句、contextlib 和自定义上下文管理器，实现更好的资源管理。
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
- /zh/posts/python-context-managers-the-three-cases-you-actually-need/
faqs:
  - q: '什么时候应该自己编写自定义上下文管理器，而不是直接用 try/finally？'
    a: '当省略清理代码会让下一个人静默泄漏资源时，或者当你发现同一段「获取/释放 try/finally」模式在代码库里反复出现时，就应该封装成上下文管理器。好处在于 try/finally 住在辅助函数里，每个调用者自动享有它，再也不会有人忘记写 finally 块。'
  - q: '如何创建一个能临时设置环境变量、退出后自动还原的上下文管理器？'
    a: '用 @contextlib.contextmanager，先用 os.environ.get() 保存每个变量的原值，再应用覆盖值，在 try 里 yield，最后在 finally 里还原。关键细节：如果某个变量之前不存在（保存值为 None），还原时要用 os.environ.pop() 而不是赋值，否则会把字面字符串 "None" 写进去。'
  - q: 'contextlib.suppress 是做什么的？为什么比 try/except: pass 更好？'
    a: 'contextlib.suppress(ExceptionClass) 会吞掉指定的异常并继续执行，例如 `with suppress(FileNotFoundError): os.unlink("maybe-stale.lock")`。它比 try/except: pass 更清晰，因为有限的作用域强制你明确写出异常类，不会不小心吞掉所有异常，也不会误吞清理代码下方的代码抛出的异常。'
  - q: '在 Python 中如何编写异步上下文管理器？'
    a: '用 @contextlib.asynccontextmanager 装饰一个异步生成器，然后用 `async with` 来使用它。结构与同步版本完全相同，区别只是函数体内可以 await，非常适合「从连接池获取连接、执行查询、在 finally 块里释放连接」这类模式。'
  - q: '什么情况下不应该在 Python 中使用上下文管理器？'
    a: '以下情况应避免：获取操作不需要配对的释放操作（直接调用函数即可）；清理是尽力而为的，且内联的 try/finally 更易读；被管理的资源已经由其他机制负责生命周期管理，例如框架自带生命周期管理的 Session。每个 `with` 都会引入额外开销，嵌套过多会迅速损害可读性。'
---

{</* resource-info */>}

大多数关于 Python 上下文管理器的介绍只展示一个示例——
`with open("file.txt") as f:`——然后就此打住。这足以让你*使用*它们，但并没有告诉你什么时候该*编写*一个。

在编写了几年的 Python 服务之后，我发现在三个特定的情况下，我会不断地求助于上下文管理器。每一个都解决了 `try`/`finally` 技术上可以解决，但在实践中往往容易出错的问题。

## 场景 1：配对获取与释放 (Pairing acquire and release)

这是最经典的情况。你拥有一些必须释放的东西——一个锁、一个数据库连接、一个临时文件、一个网络套接字——并且你希望确保即使中间的代码抛出异常，释放操作也一定会发生。

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

为什么不直接用 `try`/`finally`？当然可以——在调用端，上下文管理器展开后也就是这些东西。关键在于 `try`/`finally` 存在于*助手函数*中，而不是调用端。每个调用者都能免费获得它，而且没有人会忘记编写 `finally` 块。

当我看到一个代码库中有五个 `try: thing.acquire(); ...; finally: thing.release()` 的副本时，我知道有一个上下文管理器正等待被提取出来。

## 场景 2：临时改变全局状态

这个场景讨论得较少，但它是上下文管理器真正发挥作用的地方。你希望在某个代码块运行期间翻转某些设置，并且无论该块如何退出，你都希望它能恢复到原来的状态。

```python
import os
from contextlib import contextmanager

@contextmanager
def env(**overrides):
    """临时设置环境变量，退出时恢复之前的值。"""
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
# 环境变量在这里恢复到原来的样子。
```

同样的模式也适用于 `sys.path`、`logging` 级别、`decimal` 上下文、模拟属性（mocked attributes）——任何遵循“保存、更改、恢复”形状的东西。测试尤其能从中受益；替代方案是那些在测试中途抛出异常时会发生泄漏的 fixtures。

微妙之处在于**正确恢复 `None`**。一个常见的错误是不经检查就执行 `os.environ[k] = saved[k]`——这会在变量之前不存在时将字面量字符串 `"None"` 写入变量。始终使用 `pop` 来恢复“缺失”状态，而不是字符串。

## 场景 3：抑制你真正想要忽略的异常

有时你确实想要吞掉一个特定的异常类并继续运行。Python 为此提供了 `contextlib.suppress`：

```python
from contextlib import suppress

with suppress(FileNotFoundError):
    os.unlink("maybe-stale.lock")
```

这比等效的 `try`/`except: pass` 要清晰得多，*因为有限的范围迫使你必须明确*。你不会意外地抑制所有内容——你必须指明类名。而且你不会意外地抑制清理代码下方的代码；`with` 块的作用域正是你所编写的内容。

我发现这在析构函数和 atexit 处理程序的清理中非常有用，在这些情况下，你真的无法承担清理工作本身抛出异常的后果。

## 什么时候*不要*编写上下文管理器

上下文管理器并不是免费的。每个 `with` 都会引入少量的机制，并且叠加使用它们会迅速影响可读性。在以下情况下我会避免使用它们：

- “获取”部分实际上不需要配对的“释放”——直接调用函数即可。
- 清理工作是尽力而为的（best-effort），且范围足够小，使得内联的 `try`/`finally` 读起来更清晰。
- 被管理的东西已经被其他东西管理了（例如，不要包装一个来自已经对自己的生命周期进行上下文管理的框架的 `Session`）。

我使用的测试准则是：*“如果我省去了清理工作，下一个人会悄悄地泄露资源吗？”* 如果答案是肯定的，那就编写上下文管理器。如果是否定的，普通的函数就足够了。

## 关于异步 (Async) 的说明

在 `async` 代码中，使用 `@asynccontextmanager` 和 `async with`。形状是完全相同的；唯一需要记住的是你可以在主体内部使用 `await`，这使得该模式对于诸如“从池中获取连接、运行查询、返回连接”之类的事情更加有用。

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

就是这样。这三个模式涵盖了我编写的上下文管理器的 90%。剩下的 10% 是怪异的，当你遇到时就会明白。


## 相关文章

- [Scrapling 评测：一种更快、更隐蔽的 Python 爬虫方案](/zh/resources/dev-utils/scrapling-python-stealthy-web-scraping-review/) — 高级 Python 爬虫
- [在 Postgres 中阅读 EXPLAIN ANALYZE 而不迷失方向](/zh/resources/ai-tools/reading-explain-analyze-postgres/) — 数据库性能优化
- [免费 Claude Code：通过任何 AI 提供商免费使用 Claude Code CLI](/zh/resources/ai-tools/free-claude-code-open-source-proxy/) — AI 辅助编程

---

## 推荐工具

跑或部署开源 AI 工具时，推荐：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心，AI 工作流 droplet 一键部署。
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Claude / OpenAI / DeepSeek API 中转。上面的 AI 工具 (chatbot / 代码生成 / 翻译 / 搜索 等) 大多需要 LLM API key — 这个中转给你稳定访问顶级模型, 价格约官方 30%。

*推广链接 — 不增加你的成本，能支持 dibi8.com 持续运营。*

