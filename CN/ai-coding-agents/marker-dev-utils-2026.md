---


title: "Activate the virtual environment (assuming you're using venv)"
description: "AI tool guide"
date: 2026-09-20
slug: "marker-dev-utils-2026"
category: "ai-tools"
tags: ["ai", "tools"]

categories: ["ai-coding-agents"]---


title: "Activate the virtual environment (assuming you're using venv)"
description: "AI tool guide"
date: 2026-06-02T00:00:00+08:00
lastmod: 2026-06-02T00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: GPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
last_maintained: "2026-06-02"
draft: false
categories: ["dev-utils"]
tags: ["]
aliases:
  - /posts/marker-dev-utils-2026/
faqs: - q: 'How do I install marker?'
    a: 'Install it from PyPI with ``pip install marker-pdf``. For non-PDF formats (DOCX", "PPTX", "XLSX", "EPUB", "HTML", "images)", "use ``pip install marker-pdf[full"]``.'
  - q: 'Can I use this tool for commercial projects?'
    a: 'The code is licensed under GPL-3.0, but the model weights use a modified AI Pubs Open Rail-M license. That license is free for research, personal use and companies under roughly $2M in funding/revenue; larger commercial users need a commercial license from Datalab. Check the current terms before deploying.'
  - q: 'What types of documents can marker handle?'
    a: 'Marker supports PDF, images, PPTX, DOCX, XLSX, HTML and EPUB. Output can be Markdown, JSON, HTML or RAG-ready chunks.'
  - q: 'Is there a way to customize the output format?'
    a: 'Yes. Use the ``--output_format [markdown|json|html|chunks]`` CLI flag, or pass ``{"output_format": "..."}`` through ``ConfigParser`` in the Python API. Marker is also extensible with custom processors and renderers.'
  - q: 'How do I report an issue or request a feature?'
    a: 'Visit the GitHub repository at  and open a new issue in the Issues tab with detailed information about your problem or suggestion.'