---


title: "问题：找工作就是一份全职工作"
description: "AI tool guide"
date: 2026-09-20
slug: "justhireme-ai-job-search-workbench"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---


title: "问题：找工作就是一份全职工作"
description: "AI tool guide"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack: - JavaScript
  - Python
  - TypeScript
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "50.9 MB"
file_md5: ""
download_url: "https://github.com/vasu-devs/JustHireMe.git"
backup_url: ""
last_maintained: "2026-05-15"
draft: false
aliases:
  - /posts/justhireme-ai-job-search-workbench/
faqs: - q: 'Is JustHireMe free and open source?'
    a: 'Yes. JustHireMe is open source under the MIT license, with no subscription fees or hidden costs. You own your resume and data, and the scoring algorithm is transparent.'
  - q: 'Does JustHireMe require an AI API key or send my data to the cloud?'
    a: 'No. JustHireMe is local-first: all AI computation runs locally with no API key required, and your data is stored on your machine in a local SQLite database rather than uploaded to the cloud.'
  - q: 'Which job platforms can JustHireMe scrape listings from?'
    a: 'It automatically aggregates jobs from LinkedIn, Indeed, Glassdoor, AngelList, Hacker News, company career pages, and remote-work sections. A deduplication algorithm merges the same role when it appears across multiple platforms.'
  - q: 'How does JustHireMe''s job matching score work?'
    a: 'It uses semantic understanding rather than keyword matching, comparing your skills, experience, salary expectations, and career goals against each job''s requirements. Each listing receives a 0-100 score so you can focus on roles above 80.'
  - q: 'What technology stack is JustHireMe built on?'
    a: 'The desktop app uses Tauri 2 with React 19 and TypeScript; the backend runs Python 3.13 with FastAPI and WebSockets; data is stored in SQLite plus a Kuzu graph database and LanceDB vector store; and Playwright handles browser automation for scraping and applying.'
