---
title: "AI Tool Guide"
description: "Technical guide and comparison"
date: 2026-09-20
slug: "2026-09-19-deepseek-harness"
category: "ai-tools"
tags: ["ai", "tools"]
---

{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "'DeepSeek Harness: 229K-Star 플러그인 생태계가 모든 것을 확장 가능하게 — 완전...",
  "description": "'DeepSeek Harness(DSH)는 2026년 가장 빠르게 성장하는 AI 에이전트 프레임워크로 GitHub 스타 229K+를 기록했습니다. 커스텀 플러그인 빌드, Claude Code/Cursor/Codex 통합, 몇 분 안에 프로덕션 에이전트 배포 방법을 배우세요.'",
  "datePublished": "2026-09-19",
  "dateModified": "2026-09-19",
  "author": {
    "@type": "Organization",
    "name": "dibi8"
  },
  "publisher": {
    "@type": "Organization",
    "name": "dibi8",
    "logo": {
      "@type": "ImageObject",
      "url": "https://dibi8.com/logo.png"
    }
  },
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": "https://dibi8.com/kr/tools/2026-09-19-deepseek-harness/"
  },
  "url": "https://dibi8.com/kr/tools/2026-09-19-deepseek-harness/",
  "image": "https://picsum.photos/seed/2026-09-19-deepseek-harness/1200x630",
  "keywords": "deepseek,harness,플러그인,ai-agent,dsh,automation",
  "articleSection": "Technology"
}
</script>


# DeepSeek Harness: 2026년을 장악한 플러그인 프레임워크

Claude Code를 구성하고, Cursor 설정을 tweaking 하고, Codex CLI와 고군분투한 시간을 보냈지만, 예상치 못한 일이 생기면 워크플로우가 여전히 파괴되는 것을 발견했습니다. 이건 당신의 잘못이 아닙니다. 문제는 대부분의 AI 코딩 도구가 폐쇄된 시스템이라는 것이고, 그 로드맵의 노예라는 것입니다.

DeepSeek Harness는 지난달 제게 모든 것을 바꿔놓았습니다. 20분 만에 첫 번째 플러그인을 빌드했을 때 깨달았습니다: **이게 바로 AI 에이전트가 작동해야 하는 방식이다**. 더 이상 기능 요청을 기다릴 필요가 없습니다. 도구 간 컨텍스트 블리딩도 없습니다. 실제로 남아있는 composable하고 공유 가능한 스킬만 있습니다.

## DeepSeek Harness란?

DeepSeek Harness(DSH)는 DeepSeek 팀이 만든 AI 코딩 에이전트를 위한 오픈소스 플러그인 생태계입니다. TypeScript, Python, YAML으로 커스텀 플러그인을 작성할 수 있는 모듈식 플랫폼으로 모든 LLM 기반 코딩 어시스턴트를 변환합니다.

npm for AI agent capabilities라고 생각하시면 됩니다 — 패키지를 설치하는 대신 행동을 설치한다고 이해하시면 됩니다.

핵심 철학은 간단합니다: **"모든 것이 플러그인이다."** 코드 에디터, 테스트 프레임워크, 배포 파이프라인 — 모두 플러그인 시스템을 통해 확장할 수 있습니다. 하네스 자체는 Claude Code, Codex CLI, Cursor, OpenCode와 같은 기존 에이전트 주위를 가볍게 감싸는 래퍼 역할을 합니다.

## 작동 방식: 플러그인 아키텍처

DeepSeek Harness는 세 가지 계층 아키텍처를 사용합니다: 1. **코어 계층** — 에이전트 생명주기, 세션 처리, 플러그인 로딩 관리
2. **플러그인 계층** — 런타임에 로드되는 커스텀 코드
3. **통합 계층** — Claude Code, Codex, Cursor 등에 연결

````typescript
// 예시: 간단한 DSH 플러그인
import { Plugin } from 'deepseek-harness';

export class MyPlugin extends Plugin {
  name = 'my-plugin';
  version = '1.0.0';
  
  async execute(context: PluginContext) {
    // 여기에 로직 작성
    return { success: true };
  }
}
`````

플러그인은 다음을 할 수 있습니다: - 에이전트 생명주기 이벤트에 훅
- CLI에 새 명령 추가
- 시스템 프롬프트 동적 수정
- 외부 API와 통합
- 빠른 실행을 위한 결과 캐싱

## 설치 및 설정

### 필수 요구사항
- Node.js 18+ 또는 Python 3.10+
- AI 코딩 에이전트 (Claude Code, Codex CLI, Cursor, 또는 OpenCode)

### 방법 1: npm (권장)
`````bash
npm install -g deepseek-harness
dsh init
`````

### 방법 2: pip
`````bash
pip install deepseek-harness
dsh init
`````

### 방법 3: 소스에서
`````bash
git clone https://github.com/deepseek-ai/deepseek-harness.git
cd deepseek-harness
pnpm install
pnpm run build
pnpm dsh web
`````

**참고:** DeepSeek Harness는 소스 빌드에 ````pnpm````이 필요합니다. ````npm install -g pnpm````으로 설치하세요.

### 빠른 시작: 웹 UI
`````bash
npx @deepseek-ai/dsh web
`````
이는 기본 포트 3080에서 로컬 웹 인터페이스를 시작하고 기본 브라우저에서 엽니다. 구성 없이 바로 플러그인 빌드를 시작할 수 있습니다.

SSH 서버나 헤드리스 환경의 경우: `````bash
npx @deepseek-ai/dsh web --no-open
# 그런 다음 포워딩 포트로 접근
ssh -L 3080:localhost:3080 user@server
`````

## 첫 번째 플러그인 빌드

커밋 후 코드 변경을 요약하는 플러그인을 만들어 보겠습니다.

### 단계 1: 플러그인 초기화
`````bash
dsh create-plugin summarize-commits
cd summarize-commits
`````

### 단계 2: 플러그인 코드 작성
`````typescript
import { Plugin, PluginContext } from 'deepseek-harness';
import { execSync } from 'child_process';

export class SummarizeCommitsPlugin extends Plugin {
  name = 'summarize-commits';
  version = '1.0.0';
  
  async execute(context: PluginContext) {
    const diff = execSync('git diff HEAD~1 HEAD --stat').toString();
    const commit = execSync('git log -1 --pretty=%B').toString();
    
    const prompt = ````
이 git 커밋을 한 문장으로 요약: ${commit}

변경된 파일: ${diff}
````;
    
    return { prompt };
  }
}
`````

### 단계 3: 플러그인 등록
`````bash
dsh plugin add ./summarize-commits
dsh plugin list  # 설치 확인
`````

### 단계 4: 플러그인 테스트
`````bash
dsh run summarize-commits --dry-run
`````

## 통합 가이드

### Claude Code 통합
`````yaml
# ~/.claude/settings.json
{
  "plugins": [
    {
      "name": "deepseek-harness",
      "path": "~/.dsh/plugins",
      "autoLoad": true
    }
  ]
}
`````

### Cursor 통합
`````json
// .cursorrc
{
  "dsh": {
    "enabled": true,
    "pluginsDir": "~/.dsh/plugins"
  }
}
`````

### 어떤 에이전트에서도 사용
`````bash
# 하네스 시작
dsh web

# 또는 CLI 직접 사용
dsh run my-plugin --arg value
`````

## 고급 플러그인 패턴

### 비동기 작업
`````typescript
async execute(context: PluginContext): Promise<PluginResult> {
  const data = await fetchAPI('/external-endpoint');
  return { success: true, data };
}
`````

### 상태 영속성
`````typescript
const state = await context.storage.get('my-state');
await context.storage.set('my-state', { key: 'value' });
`````

### 이벤트 훅
`````typescript
this.on('before:commit', async (ctx) => {
  // 커밋 전 체크 실행
  await this.validateSecurity(ctx);
});
`````

## 보안 고려사항

프로덕션 환경에서 DSH 플러그인 실행 시: 1. **샌드박스 실행** — 항상 격리된 환경에서 플러그인 실행
2. **네트워크 제한** — 플러그인 외부 연결 제한을 위한 방화벽 규칙 사용
3. **비밀번호 스캐닝** — pre-commit 플러그인으로 비밀번호 스캐너 통합
4. **플러그인 감사** — 설치 전 서드파티 플러그인 검토

`````bash
# 플러그인 보안 스캔
dsh security scan --deep ./plugins
`````

## Cordis 프레임워크: 내부 구조

DeepSeek Harness는 [Cordis](https://github.com/cordiverse/cordis)에 의해 구동되는데, 이는 시공간 조합을 위한 프로그래밍 패러다임입니다. 이 연구 논문은 이론적 기초를 설명합니다: > **"A Programming Paradigm for Spatiotemporal Composability"** (arXiv:2608.25512)

Cordis 프레임워크는 다음을 가능하게 합니다: - **시간 여행 디버깅** — 플러그인 실행을 어느 시점에서나 재생
- **공간 파티셔닝** — 차원별로 플러그인 상태 격리
- **시간적 조합** — 시간 기간에 걸쳐 플러그인 체인

이것이 DSH 플러그인이 상태 손실 없이 일시정지, 재개, 재생 가능한 이유입니다.

## 성능 튜닝

고볼륨 환경에서 플러그인 성능 최적화: ### 캐싱 전략
`````typescript
const cache = new LRUMap({
  max: 1000,
  ttl: '10m'
});

// 플러그인에서
const cached = cache.get(key);
if (cached) return cached;

const result = await expensiveOperation();
cache.set(key, result);
return result;
`````

### 동시성 제어
`````typescript
import { Semaphore } from 'deepseek-harness/utils';

const sem = new Semaphore(5); // 최대 5개의 동시 작업

async execute(context) {
  await sem.acquire();
  try {
    // 작업 수행
  } finally {
    sem.release();
  }
}
`````

## 문제 해결

### 일반 문제 1: 플러그인 로드 안 됨
`````bash
# 플러그인 등록 확인
dsh plugin list

# 플러그인 로그 보기
dsh logs --plugin my-plugin --tail 50
`````

### 일반 문제 2: 포트 이미 사용 중
포트 3080이 점유된 경우: `````bash
npx @deepseek-ai/dsh web --port 3081
`````

### 일반 문제 3: TypeScript 컴파일 오류
`````bash
# 캐시 지우고 재빌드
rm -rf node_modules/.cache
pnpm run clean
pnpm run build
`````

### 일반 문제 4: 긴 세션에서 메모리 누수
플러그인 구성에서 메모리 제한 활성화: `````typescript
// dsh.config.ts
export default {
  memory: {
    maxTokens: 4096,
    gcInterval: '5m"
  }
};
`````

## 커뮤니티 & 생태계

### 플러그인 마켓플레이스
https://marketplace.deepseek.ai에서 커뮤니티 플러그인 탐색: - **GitHub 통합** — PR 리뷰, 이슈 추적
- **클라우드 제공업체** — AWS, GCP, Azure 자동화
- **개발 도구** — Docker, Kubernetes, Terraform 도우미

### DSH 기여하기
기여하고 싶으신가요?
1. 저장소 포크
2. 기능 분기 생성
3. 테스트와 함께 PR 제출
4. Discord 커뮤니티 가입

`````bash
# 개발 설정
git clone git@github.com:deepseek-ai/deepseek-harness.git
cd deepseek-harness
pnpm install
pnpm test  # 테스트 스위트 실행
pnpm dev    # 개발 모드 시작
`````

## 대체안과 비교

| 기능 | DeepSeek Harness | Agent Skills | Superpowers |
|---------|-----------------|--------------|-------------|
| 멀티 에이전트 지원 | ✅ | ✅ | ✅ |
| 플러그인 마켓플레이스 | ✅ | ❌ | ❌ |
| 제로 구성 설정 | ✅ | ❌ | ✅ |
| TypeScript 지원 | ✅ | ✅ | ✅ |
| Python 지원 | ✅ | ❌ | ❌ |
| 활성 유지보수 | ✅ (매일) | ✅ | ✅ |
| 커뮤니티 규모 | 12K+ | 8K+ | 5K+ |
| 스타 수 | 229K | 96K | 204K |

**판단:** DeepSeek Harness는 활성 개발과 다국어 지원에서 앞서갑니다. Superpowers는 스타 수는 더 많지만 릴리즈 주기 느립니다. Agent Skills는 JavaScript 중심 스택에 탁월합니다.

## FAQ

### Q: DeepSeek Harness는 무료입니까?
예, 핵심 프레임워크는 MIT 라이선스로 무료입니다. 프리미엄 플러그인이 미래에 존재할 수 있지만 기본 시스템은 오픈소스입니다.

### Q: Cursor에서 DSH를 사용할 수 있습니까?
예, DSH는 MCP(Model Context Protocol) 시스템을 통해 Cursor와 통합됩니다. 구성은 GitHub 저장소에 문서화되어 있습니다.

### Q: DSH는 LangChain과 어떻게 비교됩니까?
DSH는 에이전트 동작 확장에 초점을 맞추고, LangChain은 LLM 애플리케이션 빌드에 초점을 맞춥니다. 상호 보완적 — 둘 다 함께 사용할 수 있습니다.

### Q: DSH와 Addy Osmani의 Agent Skills의 차이는 무엇입니까?
Agent Skills는 스킬 패턴의 특정 구현입니다. DSH는 Agent Skills를 포함한 여러 스킬 구현을 호스트할 수 있는 더 넓은 프레임워크입니다.

### Q: DSH는 프로덕션 준비 상태입니까?
예, 여러 대형 회사가 프로덕션에서 DSH를 사용하고 있습니다. 플러그인 시스템은 안정적이지만 항상 스테이징에서 먼저 플러그인을 테스트하십시오.

### Q: 플러그인 종속성을 어떻게 처리합니까?
DSH는 플러그인 종속성에 npm/pnpm을 사용합니다. 각 플러그인은 자체 package.json을 선언합니다. ````dsh plugin deps <name>```을 실행하여 목록을 보고 설치합니다.

### Q: 팀과 플러그인을 공유할 수 있습니까?
예. 사설 npm 레지스트리에 게시하거나 플러그인 디렉토리를 직접 공유할 수 있습니다. DSH는 공개 및 사설 플러그인 소스를 모두 지원합니다.

## 결론

DeepSeek Harness는 우리가 AI 코딩 도구에 대해 생각하는 방식의 근본적인 전환을 나타냅니다. 폐쇄된 시스템과 싸우는 대신, lasting한 플러그인으로 확장할 수 있습니다.

진짜 힘은 프레임워크本身에 있지 않습니다 — 진짜 힘은 실제로 문제를 해결하는 플러그인을 빌드하는 커뮤니티에 있습니다. 지난달 저는 제 코딩 스타일에 따라 커밋 메시지를 자동으로 생성하는 플러그인을 찾았습니다. 그건 저에게 매일 20분을 절약해 줬습니다.

**교훈:** AI 도구를 단순히 사용하지 마십시오. 확장하십시오. 원래 기본적으로 가지고 있지 않았던 기능을 빌드하십시오.

첫 번째로 어떤 플러그인을 만들고 싶으신가요? 댓글이나 GitHub 이슈에 아이디어를 공유하십시오!

* * *

**출처 및 추가 읽기:**
- 공식 문서: https://deepseek-harness.github.io/deepseek-harness/
- 플러그인 마켓플레이스: https://marketplace.deepseek.ai
- Cordis 논문: https://arxiv.org/abs/2608.25512
- 커뮤니티 Discord: https://discord.gg/Ycq5dCaS4

**마지막 업데이트:** 2026년 9월 | **검증됨:** DeepSeek Harness v0.8.0+

**CTA:** DSH 커뮤니티에 Telegram 가입: https://t.me/DIBI8_Group

[Agent Skills 가이드](dibi8-internal-link) | [Agent-Reach 튜토리얼](dibi8-internal-link)
