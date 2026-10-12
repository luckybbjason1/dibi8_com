---


title: "脆弱的选择器，页面一改就失效"
description: "AI tool guide"
date: 2026-09-20
slug: "browser-harness-self-healing-llm-web-automation"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---


title: "脆弱的选择器，页面一改就失效"
description: "AI tool guide"
  Playwright 和 Selenium。
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack: - Go
- Python
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "1.2 MB"
file_md5: ''
download_url: https://github.com/browser-use/browser-harness
backup_url: ''
last_maintained: "2026-05-15"
draft: false
aliases:
  - /posts/browser-harness-self-healing-llm-web-automation/
faqs: - q: 'What is Browser Harness?'
    a: 'Browser Harness is a self-healing browser control framework that lets large language models autonomously complete web tasks the way a human would. It is written in Python, supports both Playwright and Selenium, and is maintained by the browser-use team.'
  - q: 'How does Browser Harness''s self-healing mechanism work?'
    a: 'When an action fails, Browser Harness takes a screenshot, has the LLM diagnose the problem, generates a new strategy, and retries. It loops through this detect-analyze-regenerate-retry cycle until the task succeeds or it confirms the task cannot be completed.'
  - q: 'How is Browser Harness different from Playwright and Selenium?'
    a: 'Playwright and Selenium rely on fixed CSS selectors or XPath that break when a page changes and require manual maintenance. Browser Harness instead uses an LLM to understand page semantics, plan multi-step tasks automatically, and self-heal when selectors fail, so you describe goals in natural language rather than coding each step.'
  - q: 'Can Browser Harness handle CAPTCHAs and dynamic content?'
    a: 'Browser Harness can solve some CAPTCHAs using the LLM and automatically waits for dynamic content, but the article notes that certain complex CAPTCHAs still require human intervention.'
  - q: 'What are the main limitations of Browser Harness?'
    a: 'Its limitations are cost (LLM API calls incur fees, though local models can be used), speed (it is slower than traditional automation because the model needs time to reason), safety (strict guardrails are needed to prevent mis-operations), and complex CAPTCHAs that may still need a human.'
