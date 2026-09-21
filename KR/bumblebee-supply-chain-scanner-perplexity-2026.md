---
title: 'Bumblebee 2026: Perplexity AI 내부 공급망 스캐너 오픈소스화 — MCP 설정·...
description: "Bumblebee는 Perplexity AI의 오픈소스 읽기 전용 공급망 스캐너입니다. npm, PyPI, Go 모듈, MCP 설정, 에디터 확장, 브라우저 확장에서 알려진 침해 패키지를 검사하며, 코드를 단 한 줄도 실행하지 않습니다."
date: 2026-06-09 00:00:00+08:00
lastmod: 2026-06-09 00:00:00+08:00
tech_stack: [Go, Security, CLI]
application_domain: Dev Utils
source_version: "0.1.1"
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: "https://github.com/perplexityai/bumblebee"
backup_url: ''
github_repo: "perplexityai/bumblebee"
stars: 1500
maintainer: perplexityai
last_maintained: "2026-05-22"
featureImage: '/images/articles/bumblebee-supply-chain-scanner-perplexity-2026/cover.jpg'
draft: false
categories: ["dev-utils"]
tags: ["bumblebee", "공급망-보안", "mcp", "security", "go", "npm", "pypi", "perplexity-ai"]
aliases:
  - /kr/posts/bumblebee-supply-chain-scanner-perplexity-2026/
faqs: - q: 'Bumblebee란 무엇이며 무엇을 스캔합니까?'
    a: 'Bumblebee는 Perplexity AI가 오픈소스로 공개한 읽기 전용 개발자 엔드포인트 스캐너입니다. npm, pnpm, Yarn, PyPI, Go 모듈, RubyGems, MCP 설정, 에디터 확장(VS Code, Cursor, Windsurf, Zed), 브라우저 확장의 디스크 메타데이터를 스캔합니다. 설치 스크립트를 실행하거나 패키지 관리자를 호출하지 않습니다.'
  - q: 'AI 개발자에게 MCP 스캔이 왜 중요합니까?'
    a: 'MCP(Model Context Protocol) 서버는 개발자 머신에서 높은 권한으로 실행됩니다. 침해된 MCP 패키지는 데이터를 유출하거나 임의 코드를 실행할 수 있습니다. Bumblebee는 MCP 설정 파일(claude_desktop_config.json, mcp_settings.json 등)을 위협 인텔리전스 카탈로그와 대조해 스캔하는 최초의 공개 도구입니다.'
  - q: '세 가지 스캔 프로필의 차이는 무엇입니까?'
    a: 'baseline은 전역 패키지 루트, 툴체인, 에디터 확장, MCP 설정을 스캔하며 일상적인 인벤토리에 적합합니다. project는 baseline에 개발 디렉터리(~/code 등)를 추가합니다. deep은 지정된 루트(보통 홈 디렉터리 전체)를 스윕하며 보안 사고 대응 시 사용합니다.'
  - q: 'Bumblebee 설치 방법은?'
    a: 'go install github.com/perplexityai/bumblebee/cmd/bumblebee@v0.1.1을 실행합니다. 일상 인벤토리는 bumblebee scan --profile baseline > inventory.ndjson, 특정 취약점 노출 검사는 bumblebee scan --profile deep --root "$HOME" --exposure-catalog ./catalog.json --findings-only를 사용합니다.'
---

![Bumblebee 2026: Perplexity AI 공급망 스캐너 — dibi8.com](/images/articles/bumblebee-supply-chain-scanner-perplexity-2026/cover.jpg)

2026년 5월 22일, Perplexity AI는 내부 보안 팀이 개발자 노트북 공급망 리스크 감사에 사용하던 도구인 [Bumblebee](https://github.com/perplexityai/bumblebee)를 오픈소스로 공개했습니다. 일주일도 안 돼 1,500개 이상의 GitHub 스타와 112개의 포크를 기록했습니다. 이 도구가 답하는 질문은 단 하나입니다: **침해된 패키지가 내 머신에 있는가?**

## 공급망 공격이 개발자를 먼저 노리는 이유

xz 사건, polyfill.io, AI 툴링을 겨냥한 수십 개의 악성 npm 패키지를 포함한 2024~2026년 공급망 사건들은 하나의 패턴을 공유합니다: 개발자 머신에 먼저 상륙하고, 수개월 후 프로덕션에서 피해를 입힙니다.

기존 SCA 도구(Snyk, Dependabot)는 코드가 선언한 의존성을 검사합니다. 이들이 놓치는 것: 전역 설치 CLI, 에디터 확장, 브라우저 확장, **MCP 설정 파일**. Bumblebee는 이 공백을 채웁니다.

## 읽기 전용 보장

이 도구의 핵심 제약은 **아무것도 실행하지 않는다**는 것입니다. `npm ls`, `pip check`, `go list` 없음. 공급망 공격은 점점 검사 단계 자체를 노립니다. Bumblebee는 디스크의 메타데이터 파일만 읽어 이 위험을 완전히 우회합니다.

## 세 가지 스캔 프로필

```bash
# 일상 전역 인벤토리
bumblebee scan --profile baseline > inventory.ndjson

# 프로젝트 범위 스캔
bumblebee scan --profile project --project-root ~/code

# 사고 대응 - 전체 홈 디렉터리 스윕
bumblebee scan --profile deep \
  --root "$HOME" \
  --exposure-catalog ./catalog.json \
  --findings-only \
  --max-duration 10m
```

## MCP 설정 지원

2026년 AI 개발자에게 가장 중요한 기능입니다. Bumblebee가 스캔하는 경로: | 파일 | 도구 |
|------|------|
| `~/.claude.json` | Claude CLI |
| `claude_desktop_config.json` | Claude Desktop |
| `mcp_settings.json` | Cline / Roo Code |
| `.mcp.json` / `mcp.json` | 범용 MCP |
| `~/.gemini/settings.json` | Gemini CLI |

각 MCP 서버 항목에 대해 패키지 이름, 버전, 출처 레지스트리를 기록합니다. 노출 스캔 실행 시 MCP 패키지도 일반 의존성과 함께 검사됩니다.

## 제로 의존성 설계

Go 1.25로 작성되었으며 **표준 라이브러리 외 의존성 없음**. 결과물은 단일 정적 바이너리입니다.

```bash
go install github.com/perplexityai/bumblebee/cmd/bumblebee@v0.1.1
```

> **안전한 AI 인프라 구축:** MCP 서버나 AI 워크로드를 VPS에서 운영한다면 호스트 OS 강화가 최우선입니다. [월 $6 DigitalOcean Droplet](https://m.do.co/c/eca87ac14ee0)으로 방화벽, 사용자 격리, 감사 로깅을 직접 설정하세요. 신규 사용자에게 **$200 무료 크레딧** 제공.

**GitHub:** [perplexityai/bumblebee](https://github.com/perplexityai/bumblebee) · v0.1.1 · Apache-2.0


{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Bumblebee 2026: Perplexity AI 내부 공급망 스캐너 오픈소스화 — MCP 설정·에디터 확장 지원",
  "datePublished": "2026-06-09",
  "dateModified": "2026-06-09",
  "author": {
    "@type": "Organization",
    "name": "Dibi8"
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
    "@id": "https://dibi8.com/kr/resources/bumblebee-supply-chain-scanner-perplexity-2026"
  }
}
</script>

## Why This Matters

Understanding bumblebee 2026: perplexity ai 내부 공급망 스캐너 오픈소스화 — mcp 설정·에디터 확장 지원 is crucial for modern AI development. Here's why: ### Key Benefits
- **Efficiency**: Save time on repetitive tasks
- **Quality**: Improve output consistency  
- **Scalability**: Handle larger workloads
- **Cost**: Reduce operational expenses

### Real-World Applications
Organizations are using similar approaches to: 1. Automate code review processes
2. Generate documentation automatically
3. Build internal knowledge bases
4. Streamline deployment pipelines

### Getting Started
To implement this in your workflow: 1. **Assess Your Needs**
   - Identify repetitive tasks
   - Measure current time costs
   - Define success metrics

2. **Choose Your Approach**
   - Start with simple automations
   - Gradually increase complexity
   - Test and iterate

3. **Measure Results**
   - Track time savings
   - Monitor quality improvements
   - Calculate ROI

## Conclusion

Bumblebee 2026: Perplexity AI 내부 공급망 스캐너 오픈소스화 — MCP 설정·에디터 확장 지원 represents an important step forward in AI-powered development. As the ecosystem matures, we expect to see even more powerful capabilities emerge.

For the latest updates and community discussions, join our Telegram channel: https://t.me/DIBI8_Group

---

*Last updated: 2026-09-20*
*Read time: ~5 minutes*

---

## Related Articles

- [free-mcp-tools-top10-2026](bumblebee-supply-chain-scanner-perplexity-2026)
- [cc-switch-all-in-one-ai-coding-agent-manager](bumblebee-supply-chain-scanner-perplexity-2026)
- [codebase-memory-mcp-high-performance-code-intelligence](bumblebee-supply-chain-scanner-perplexity-2026)
- [headroom-token-compression-proxy-library-mcp-server](bumblebee-supply-chain-scanner-perplexity-2026)
- [codebase-memory-mcp-deep-code-intelligence](bumblebee-supply-chain-scanner-perplexity-2026)

---

*Found this helpful? [Join our Telegram community](https://t.me/DIBI8_Group) for daily AI tool updates!*

## Frequently Asked Questions (FAQ)

**问：AI Agent和传统自动化有什么区别？**

AI Agent具有自主决策能力，能够根据环境变化调整策略，而传统自动化只能执行预设规则。

**问：如何选择合适的AI Agent框架？**

考虑因素包括：部署难度、社区活跃度、扩展性、成本。Claude Code适合开发者，AutoGen适合复杂多智能体场景。

**问：AI Agent的安全性如何保证？**

实施权限最小化、输入验证、审计日志、以及定期安全评估。

**问：AI Agent的学习成本有多高？**

入门级使用3-5天，高级配置需要2-4周，取决于团队技术基础。

**问：能否自定义AI Agent的行为？**

是的，通过提示工程、工具定义、记忆系统、以及行为约束来定制。


## Tool Comparison

| Feature | Claude Code | Cursor | Codex CLI | OpenCode |
|---------|-------------|--------|-----------|----------|
| **Price** | $20/month | $20/month | Free | Free |
| **Interface** | CLI + IDE | Full IDE | CLI | CLI |
| **License** | Proprietary | Commercial | Apache 2.0 | MIT |
| **GitHub Stars** | N/A | N/A | N/A | 45,000+ |
| **Best For** | Complex reasoning | Daily coding | Fast iteration | Customization |

