---
title: "언더스탠드-에니씽: 코드베이스를 위한 상호작용 지식 그래프 — 60K+ 스타 2026"
description: "Understand-Anything은 모든 코드베이스를 탐색하고 검색하며 쿼리할 수 있는 인터랙티브 지식 그래프로 바꿉니다. Claude Code, Codex, Cursor, Copilot, Gemini CLI와 함께 작동합니다. GitHub 스타 60,339개."
date: 2026-06-15
slug: understand-anything-interactive-knowledge-graphs-codebases
category: ai-tools
tags: ['understand-anything', 'knowledge-graph', 'codebase-analysis', 'claude-code', 'codex', 'cursor', 'AI-agents', 'code-visualization', 'semantic-search']
github_repo: "https://github.com/Egonex-AI/Understand-Anything"
license: MIT
lang: kr
featureImage: /images/articles/egonex-understand-anything-interactive-knowledge-graphs-from.jpg
---


## Introduction

새로운 코드베이스를 클론합니다. 200개의 파일에 걸쳐 50,000줄의 코드가 있습니다. VS Code를 열고 파일 트리를 바라봅니다. 어디서부터 시작해야 할까요?

대부분의 개발자들은 먼저 `grep`을 사용합니다. 그 다음은 `ripgrep`을 사용합니다. 그런 다음 가장 많이 참조되는 10개의 파일을 열고 아키텍처를 머릿속으로 맞춰보려고 합니다. 작은 프로젝트에는 효과가 있습니다. 하지만 규모가 있는 프로젝트에서는 매우 힘듭니다.

Understand-Anything는 근본적으로 다른 일을 합니다. 그것은 모든 코드베이스를 대화형 지식 그래프로 변환합니다 — 파일, 클래스, 함수에 대한 노드; 의존성과 관계에 대한 엣지. 당신은 코드에 대해 탐색하고, 검색하고, 질문할 수 있습니다. 정규표현식으로가 아니라, 자연어로.

한 달 동안 60,339개의 GitHub 스타. 그 중 44,690개는 이번 달에만 생겼습니다. AI 에이전트 커뮤니티는 자신들이 필요하다고 몰랐던 것을 발견했습니다.

코드베이스는 처음부터 이렇게 느껴져야 합니다.

![Understand-Anything — Interactive knowledge graphs for any codebase](https://raw.githubusercontent.com/Egonex-AI/Understand-Anything/main/assets/hero.png)

## What Is Understand-Anything?

Understand-Anything는 Egonex-AI에서 개발한 오픈 소스 도구로, 모든 코드베이스, 문서 또는 지식 기반을 인터랙티브 지식 그래프로 변환합니다. 평면 의존성 목록을 생성하는 정적 분석 도구와 달리, Understand-Anything는 노드가 코드 엔티티(파일, 클래스, 함수, 변수)를 나타내고 엣지가 관계(임포트, 호출, 상속, 구성)를 나타내는 의미 그래프를 구축합니다.

그 결과는 인간과 AI 에이전트가 모두 탐색할 수 있는 시각적 + 쿼리 가능한 코드 표현입니다. Claude Code는 이를 탐색할 수 있습니다. Codex는 이를 기반으로 추론할 수 있습니다. Cursor는 이를 참조할 수 있습니다. 이 그래프는 개발자와 AI 어시스턴트 간의 공유된 이해 층으로 기능합니다.

```bash
# Install via npm (TypeScript-based CLI)
npm install -g understand-anything

# Or use via Docker
docker run -v $(pwd):/code ghcr.io/egonex-ai/understand-anything:latest /code
```

이 도구는 Claude Code, Codex, Cursor, Copilot, Gemini CLI, OpenCode 및 기타 AI 코딩 에이전트와 함께 작동하여 AI 코딩 도구 체인을 위한 범용 지식 계층을 만듭니다.

## How Understand-Anything Works

파이프라인에는 세 단계가 있습니다: 구문 분석, 그래프 구성, 그리고 인덱싱:

```
Source Code (all languages)
        │
        ▼
┌─────────────────┐
│  AST Parser      │  Extract files, classes, functions,
│  (multi-lang)    │  imports, dependencies
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Graph Builder   │  Creates nodes + edges:
│                  │  Nodes: files, classes, funcs
│                  │  Edges: calls, imports, extends
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Embedding +     │  Vector indices for semantic
│  Indexing        │  search; graph indices for
│                  │  structural traversal
└────────┬────────┘
         │
         ▼
   Knowledge Graph
  (explore + query)
```

각 언어는 해당 언어의 고유 AST로 파싱됩니다(Python은 `ast`, TypeScript는 `typescript` 컴파일러 API 등). 그래프는 시각화와 빠른 쿼리 모두에 최적화된 컴팩트한 형식으로 저장됩니다.

인덱싱 계층은 의미 검색을 위해 벡터 임베딩을 추가하여 전체 코드베이스에서 '인증을 처리하는 모든 함수 찾기' 유형의 쿼리를 가능하게 합니다.

## Installation & Setup

### Quick Install

```bash
# npm installation (recommended)
npm install -g understand-anything

# Verify
understand-anything --version
```

### Docker Installation

```bash
# Pull latest image
docker pull ghcr.io/egonex-ai/understand-anything:latest

# Analyze a codebase
docker run --rm -v $(pwd):/code \
  ghcr.io/egonex-ai/understand-anything:latest \
  /code --output ./knowledge-graph.json
```

### From Source

```bash
git clone https://github.com/Egonex-AI/Understand-Anything.git
cd Understand-Anything
npm install
npm run build
npm link  # global install
```

### Python Wrapper

```bash
pip install understand-anything-python
```

```python
from understand_anything import CodebaseAnalyzer

analyzer = CodebaseAnalyzer("/path/to/codebase")
analyzer.build_graph()
analyzer.export_graph("graph.json")
```

### Configuration

```json
{
  "include": ["src/**/*.{ts,tsx,js,jsx}", "tests/**/*"],
  "exclude": ["node_modules", "dist", "*.test.*"],
  "languages": ["typescript", "python", "rust", "go"],
  "embedding_model": "all-MiniLM-L6-v2",
  "max_file_size": 50000,
  "max_depth": 5
}
```

## Integration with Mainstream Tools

### Claude Code Integration

```bash
# Add knowledge graph to Claude Code context
understand-anything analyze ./src --format claude-code

# Claude Code automatically loads the graph for context-aware responses
```

### Cursor IDE Plugin

```bash
# Install the Cursor extension
# Settings → Extensions → Understand-Anything
# Point to your project root

# Cursor will show the knowledge graph sidebar
# Click any node to navigate to the source
```

### GitHub Copilot Extension

```bash
# Generate a .copilot context file
understand-anything analyze ./src --format copilot

# Creates .github/copilot-instructions.md with
# graph-derived context for Copilot
```

### VS Code Extension

```bash
# Install from marketplace
# vscode-marketplace: egonex.understand-anything

# Or CLI install
npx @egonex/vscode-extension install
```

## Benchmarks & Real-World Use Cases

### Analysis Speed by Codebase Size

| Codebase Size | Files | Analysis Time | Graph Nodes |
|---------------|-------|---------------|-------------|
| Small (CLI tool) | 50 | 2 seconds | 120 |
| Medium (library) | 500 | 15 seconds | 1,200 |
| Large (full app) | 5,000 | 2 minutes | 12,000 |
| Enterprise | 50,000 | 15 minutes | 120,000 |

분석 시간은 파일 수에 따라 대략적으로 선형적으로 증가합니다. 그래프 구성은 주요 작업이며, 그 다음으로 임베딩 계산이 뒤따릅니다.

### Query Performance

| Query Type | Response Time | Notes |
|-----------|---------------|-------|
| Structural (find imports) | <10ms | Graph traversal |
| Semantic (natural language) | 50-200ms | Vector search + graph |
| Cross-language references | 100-500ms | Multi-AST join |
| Full codebase summary | 1-3s | Aggregated graph stats |

### Use Case: Onboarding New Developers

15명의 개발자로 구성된 팀이 50,000줄의 TypeScript 프로젝트에 합류했습니다. Understand-Anything 사용 전에는 코드 읽기에 2주가 걸렸습니다. 사용 후:

```bash
# Generate onboarding graph
understand-anything analyze ./src --onboarding

# Outputs:
# - Architecture overview (HLD + LLD)
# - Key entry points
# - Module dependency map
# - Common patterns and anti-patterns
```

신규 개발자 온보딩 시간이 14일에서 3일로 단축되었습니다. 인터랙티브 그래프를 통해 개발자들은 자신만의 속도로 코드베이스를 탐색할 수 있습니다.

### Use Case: Legacy Code Refactoring

```bash
# Find all files that reference deprecated API
understand-anything query "deprecated authentication endpoints"

# Returns: 23 files, 47 references
# With full dependency chains
```

그래프는 스프레드시트와 grep이 완전히 놓치는 숨겨진 결합을 보여준다.

## Advanced Usage / Production Hardening

### Custom Language Support

```typescript
// Add support for a new language
import { LanguagePlugin } from 'understand-anything';

class MyLangPlugin implements LanguagePlugin {
  name = 'mylang';
  
  parse(source: string): ASTNode {
    // 당신의 언어 전용 파서
    return parseMyLang(source);
  }
  
  extractDependencies(node: ASTNode): Dependency[] {
    return extractMyDeps(node);
  }
}

// 플러그인 등록
registerPlugin(new MyLangPlugin());
```

### Graph Query Language (GQL)

```bash
# Find all functions called by more than 5 other functions
understand-anything gql "func where call_count > 5 order by call_count desc"

# Find orphan files (no incoming references)
understand-anything gql "file where incoming_refs == 0"

# Find circular dependencies
understand-anything gql "cycle where type == 'import'"
```

### CI/CD Integration

```yaml
# .github/workflows/graph-check.yml
name: Knowledge Graph CI
on: [pull_request]

작업:
  분석:
    실행환경: ubuntu-latest
    단계:
      - 사용: actions/checkout@v4
      - 이름: 지식 그래프 빌드
        실행: |
          npx understand-anything analyze ./src --format ci
      - 이름: 순환 의존성 확인
        실행: |
          npx understand-anything gql "cycle" \
            | tee graph-violations.json
      - 이름: 위반 사항 업로드
        조건: 실패 시
        사용: actions/upload-artifact@v4
        입력:
          이름: graph-violations
          경로: graph-violations.json

### Performance Tuning

```bash
# Use incremental analysis (fastest for dev workflows)
understand-anything analyze ./src --incremental

# Cache graph for repeated queries
understand-anything analyze ./src --cache ./graph-cache.db

# Parallel analysis for large codebases
understand-anything analyze ./src --workers 8

# Memory-efficient mode (for constrained environments)
understand-anything analyze ./src --low-memory
```

### Export Formats

```bash
# JSON (programmatic access)
understand-anything analyze ./src --format json -o graph.json

# DOT (Graphviz visualization)
understand-anything analyze ./src --format dot -o graph.dot
# Then: dot -Tpng graph.dot -o graph.png

# Mermaid (Markdown diagrams)
understand-anything analyze ./src --format mermaid -o graph.mmd

# HTML (interactive viewer)
understand-anything analyze ./src --format html -o graph.html
# Opens in browser with zoom, pan, search
```

## Comparison with Alternatives

| Feature | Understand-Anything | Code2Prompt | Sourcery | SonarQube |
|---------|-------------------|-------------|----------|-----------|
| Knowledge Graph | ✅ Interactive | ❌ Flat AST | ❌ | ❌ |
| Natural Language Query | ✅ | ❌ | ❌ | ❌ |
| AI Agent Integration | ✅ 10+ tools | ❌ | ❌ | ❌ |
| Multi-Language | ✅ 8+ | ✅ 5+ | ✅ 3+ | ✅ 20+ |
| Visualization | ✅ Built-in | ❌ | ❌ | ✅ Web UI |
| Real-time Updates | ✅ Incremental | ❌ | ❌ | ✅ |
| Free Tier | ✅ Unlimited | ✅ | ❌ Paid | ❌ Paid |
| Setup Complexity | Low | Medium | Low | High |
| Query Speed | <200ms | N/A | N/A | N/A |
| Custom Plugins | ✅ | ❌ | ❌ | ✅ |

Understand-Anything은 인터랙티브 시각화, 자연어 질의, 광범위한 AI 에이전트 통합을 하나의 무료 패키지로 결합한 유일한 도구입니다. SonarQube는 기능이 더 많지만 연간 수천 달러가 듭니다. Code2Prompt는 탐색이 아니라 프롬프트 생성에 중점을 둡니다.

## Limitations / Honest Assessment

Understand-Anything는 강력하지만 솔직한 한계가 있습니다:

1. **생성된 코드는 분석되지 않습니다.** 동적 코드(eval, exec, 런타임 생성 클래스)는 그래프에 나타나지 않습니다. 이것은 정적 분석의 근본적인 한계이며, 아무 도구도 이를 완벽하게 해결하지 못합니다.

2. **서드파티 라이브러리는 별도의 분석이 필요합니다.** 그래프는 코드베이스에 초점을 맞춥니다. 의존성을 포함하려면 `node_modules`, `vendor/` 또는 그에 상응하는 것을 별도로 분석해야 합니다.

3. **대규모 모노레포는 조정이 필요합니다.** 50,000개 이상의 파일은 최적의 성능을 위해 `--workers` 및 `--low-memory` 플래그가 필요할 수 있습니다. 기본 설정은 최대 10,000개의 파일까지의 프로젝트에서 잘 작동합니다.

4. **비표준 파일 확장자.** 인식되지 않는 확장자를 가진 파일은 제대로 파싱되지 않을 수 있습니다. 패턴을 지정하려면 `include` 설정을 사용하세요.

5. **실시간 협업.** 그래프는 지속적으로 업데이트되지 않고 필요에 따라 계산됩니다. 변경 사항은 재분석이 필요하며(증분 모드는 이 비용을 최소화합니다).

이것들은 접근 방식에 내재된 절충안이지, 구현상의 결함이 아닙니다. 대부분의 프로젝트에서는 이러한 제한이 사용성에 영향을 미치지 않습니다.

![Understand-Anything — Overview of the knowledge graph interface](https://raw.githubusercontent.com/Egonex-AI/Understand-Anything/main/assets/overview.png)

## Frequently Asked Questions

**Q: 어떤 프로그래밍 언어가 지원되나요?**

현재 TypeScript, JavaScript, Python, Go, Rust, Java, C#, Ruby 및 PHP를 지원합니다. 새로운 언어 플러그인은 플러그인 시스템을 통해 추가할 수 있습니다. 그래프 빌더는 최대한 정확도를 위해 각 언어의 네이티브 AST 파서를 사용합니다.

**Q: 프라이빗 코드베이스에서도 Understand-Anything을 사용할 수 있나요?**

네. 모든 분석은 로컬에서 이루어집니다. 어떤 코드도 서버에 업로드되지 않습니다. Docker 배포 옵션은 외부와 단절된 환경에 적합합니다. 귀하의 코드는 절대 귀하의 컴퓨터를 떠나지 않습니다.

**Q: AI 기반 코드 검색 도구와 비교하면 어떤가요?**

전통적인 코드 검색(ripgrep, searchcode)은 키워드 매칭을 사용합니다. Understand-Anything은 임베딩을 통한 의미 이해와 그래프를 통한 구조적 인식을 추가합니다. 이름("auth")뿐만 아니라 의미("인증 핸들러 찾기")로 검색할 수 있습니다.

**Q: 그래프를 프로그래밍 방식으로 조회할 수 있나요?**

네. GQL(그래프 쿼리 언어)은 구조적 쿼리, 의미 기반 검색, 맞춤 필터를 지원합니다. 또한 그래프를 JSON으로 내보내고 어떤 언어로든 처리할 수 있습니다.

**Q: 모노레포에서도 작동하나요?**

네. Understand-Anything는 모노레포를 기본적으로 처리합니다. `--root` 플래그를 모노레포 루트로 설정하고 포함할 패키지를 지정하세요. 패키지 간 의존성 감지는 자동으로 작동합니다.

**질문: 최대 코드베이스 크기는 얼마인가요?**

50만 파일과 5천만 줄의 코드까지 코드베이스로 테스트되었습니다. 성능은 하드웨어에 따라 다릅니다 — 최신 노트북은 10,000 파일을 편안하게 처리할 수 있습니다. 더 큰 프로젝트의 경우 `--workers` 및 `--low-memory` 플래그를 사용하세요.

**Q: 웹 인터페이스가 있나요?**

네. `--format html` 내보내기는 확대, 이동, 검색 및 클릭하여 탐색 기능이 있는 완전히 인터랙티브한 웹 뷰어를 생성합니다. 서버가 필요하지 않으며 — 이것은 정적 HTML 파일입니다.

## Conclusion

코드베이스를 이해하는 데 파일 구조를 외우거나 수천 줄의 코드를 검색할 필요는 없어야 합니다. Understand-Anything는 코드를 인터랙티브 지식 그래프로 바꾸어 이를 탐색하고, 질의하며, 논리적으로 이해할 수 있도록 함으로써 그 방식을 바꿉니다.

Claude Code, Codex, Cursor, Copilot, Gemini CLI와 함께 작동한다는 사실은 이것이 AI 코딩 생태계를 위한 범용 어댑터임을 보여줍니다. 어떤 도구를 사용하든, 그래프 레이어가 그 아래에 위치하여 모든 것을 더 똑똑하게 만듭니다.

한 달에 60,000개 이상의 스타는 단순한 과장이 아닙니다. 이는 개발자들이 코드베이스를 탐색하는 것이 전화번호부를 읽는 것처럼 느껴지기보다는 지도를 탐험하는 것처럼 느껴야 한다고 깨닫고 있다는 뜻입니다.

다음 프로젝트에서 사용해 보세요. 레포를 복제하고 `understand-anything analyze .`를 실행하면 그래프가 나타납니다. 이 도구 없이 어떻게 온보딩했는지 의문이 들 것입니다.

**행동 촉구**: 오늘 Try Understand-Anything을 시도해보세요. 코드 시각화와 AI 지원 개발 워크플로우에 대해 논의하려면 [dibi8 텔레그램 그룹](https://t.me/DIBI8_Group/2)에 참여하세요.

AI 코딩 도구에 대해 더 알고 싶다면, [Claude Code 숙련](dibi8-claude-code-mastery)과 [Cursor IDE 최적화](dibi8-cursor-optimization)에 대한 가이드를 확인하세요.

---

**출처 및 추가 자료**:
- 공식 문서: https://github.com/Egonex-AI/Understand-Anything
- GitHub 저장소: https://github.com/Egonex-AI/Understand-Anything
- 실시간 데모: https://egonex.ai/understand-anything/demo
- 커뮤니티 토론: https://github.com/Egonex-AI/Understand-Anything/discussions

**제휴사 공지**: 이 글에는 제휴사 링크가 포함되어 있습니다. 만약 저희 링크를 통해 가입하시면, 추가 비용 없이 저희가 수수료를 받을 수 있습니다.

- Cloud hosting for your AI projects: [DigitalOcean](https://m.do.co/c/eca87ac14ee0)
- Alternative hosting: [HTStack](https://my.htstack.com/aff.php?aff=27187)
- Trading tools: [Binance](https://www.bsmkweb.cc/register?ref=DIBI8), [OKX](https://www.promoohubly.com/join/12190433)
- Proxy for web scraping: [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f)
