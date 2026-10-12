---


title: "promptfooconfig.yaml"
description: "AI tool guide"
date: 2026-09-20
slug: "promptfoo-llm-frameworks-2026"
category: "ai-tools"
tags: ["ai", "tools"]

categories: ["ai-coding-agents"]---


title: "promptfooconfig.yaml"
description: "AI tool guide"
date: 2026-06-02T00:00:00+08:00
lastmod: 2026-06-02T00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
last_maintained: "2026-06-02"
draft: false
categories: ["llm-frameworks"]
tags: ["]
aliases:
  - /posts/promptfoo-llm-frameworks-2026/
faqs: - q: 'How do I install and run promptfoo locally?'
    a: 'The quickest path needs no install: ```bash npx promptfoo@latest init --example getting-started ``` To install globally", "use ``npm install -g promptfoo`` (or ``brew install promptfoo``", "or ``pip install promptfoo``). Then run ``promptfoo eval`` to evaluate and ``promptfoo view`` to open the local viewer.'
  - q: 'Can I use promptfoo with my own AI models?'
    a: 'Yes. Promptfoo supports many providers — OpenAI", "Anthropic", "Google", "DeepSeek", "local models", "and more. You declare each one in the ``providers`` list of your ``promptfooconfig.yaml`` and supply the matching API key via environment variables.'
  - q: 'How does promptfoo compare performance across different models?'
    a: 'You list several entries under ``providers``", "and promptfoo runs every prompt and test case against each one. ``promptfoo view`` then shows the outputs side by side with pass/fail per assertion", "so you can compare quality directly on your own inputs.'
  - q: 'Is there a way to integrate promptfoo with CI/CD pipelines?'
    a: 'Yes. Because promptfoo is a CLI", "you can run ``npx promptfoo@latest eval`` in any pipeline. It''s commonly wired into GitHub Actions so every push or pull request runs your evaluation suite.'
  - q: 'How do I contribute to the promptfoo project?'
    a: 'Contributions are welcome. Open an issue or submit a pull request on GitHub. See the [contributing guidelines"](https://github.com/promptfoo/promptfoo/blob/main/CONTRIBUTING.md) for details.'