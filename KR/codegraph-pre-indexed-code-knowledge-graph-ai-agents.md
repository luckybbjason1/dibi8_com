---
title: "CodeGraph: 코드베이스 전체에서 코드 지식 그래프 구축"
slug: "codegraph-pre-indexed-code-knowledge-graph-ai-agents"
category: "dev-utils"
publish_date: "2026-06-10"
author: "DIBI8"
tags: ["kotlin", "graph", "code-analysis", "devtools", "knowledge-graph"]
featureImage: "https://avatars.githubusercontent.com/u/11434"
---

# CodeGraph: 코드베이스 전체에서 코드 지식 그래프 구축

## 소개

모든 소프트웨어 프로젝트는 인간의 인지 능력을 초월할 정도로 복잡해집니다. 새로 합류한 팀원들은 특정 함수가 어디에 있고 어떻게 시스템의 나머지 부분과 연결되어 있는지 파악하는 데 몇 주가 걸리기도 합니다. CodeGraph는 전체 코드베이스를 탐색 가능한 지식 그래프로 변환하는 오픈소스 도구로, 클래스, 함수, 인터페이스, 패키지 간의 관계를 한눈에 이해할 수 있게 해줍니다. Kotlin으로 작성된 CodeGraph는 심층적인 코드베이스 이해가 필요한 개발자를 위해 강력한 CLI와 프로그래밍 API를 제공합니다.

## CodeGraph란 무엇인가?

CodeGraph는 소스 코드를 파싱하고 포괄적인 그래프 표현을 구축하는 Kotlin 네이티브 라이브러리이자 CLI 도구입니다. 코드베이스를 위한 범용 그래프 데이터베이스라고 생각하세요. 모든 노드는 프로그램 요소(클래스, 함수, 패키지, 인터페이스)이고, 모든 간선은 관계를 나타냅니다(상속, 구현, 호출, 의존). 이러한 그래프 구조를 통해 "이 인터페이스를 구현하는 클래스는 무엇인가?", "이 패키지의 종속성 전이 결과는 무엇인가?"와 같은 질문을 밀리초 단위로 확인할 수 있습니다.

이 도구는 Kotlin과 Java를 지원하며, 다른 JVM 언어로도 확장할 수 있습니다. Kotlin 컴파일러의 파싱 인프라를 사용하므로 표면적인 텍스트 패턴이 아닌 코드의 전체 의미론적 컨텍스트를 이해합니다.

더 많은 코드 분석 도구를 알아보고 싶다면 [dibi8-internal-link](https://dibi8.com)를 참조하세요.

## 핵심 기능

CodeGraph는 간결한 패키지에 놀라울 정도로 많은 기능을 담고 있습니다:

- **자동 코드 파싱**: 소스 코드에서 전체 의존성 그래프 구축
- **쿼리 API**: 노드 검색, 관계 탐색, 결과 필터링을 위한 프로그래밍 방식 쿼리
- **CLI 도구**: 한 번의 명령으로 그래프 생성 및 터미널에서 인터랙티브 쿼리
- **내보내기 기능**: 그래프를 JSON, DOT(Graphviz), GraphML 형식으로 내보내기
- **증분 업데이트**: 변경된 부분만 재빌드하여 빠른 증분 분석
- **IDE 통합**: IDE 플러그인을 구동하는 라이브러리로 사용 가능
- **사용자 정의 쿼리**: 내장 그래프 쿼리 언어를 사용한 커스텀 쿼리 작성

## 설치

CodeGraph 설치는 간단합니다. 가장 일반적인 방법은 Gradle 플러그인이나 Maven 의존성을 이용하는 것입니다. CLI JAR을 직접 다운로드하여 실행할 수도 있습니다.

### Gradle로 설치하기

`build.gradle.kts`에 CodeGraph를 의존성으로 추가합니다:

```kotlin
plugins {
    id("org.jetbrains.kotlin.jvm") version "1.9.22"
}

dependencies {
    implementation("io.codegraph:codegraph-core:1.2.0")
    implementation("io.codegraph:codegraph-cli:1.2.0")
}
```

### Maven으로 설치하기

```xml
<dependency>
    <groupId>io.codegraph</groupId>
    <artifactId>codegraph-core</artifactId>
    <version>1.2.0</version>
</dependency>
```

### CLI 설치하기

최신 CLI JAR을 다운로드하여 직접 실행하세요:

```bash
curl -L -o codegraph-cli.jar https://repo.maven.apache.org/maven2/io/codegraph/codegraph-cli/1.2.0/codegraph-cli-1.2.0.jar
java -jar codegraph-cli.jar --version
```

또는 macOS에서 Homebrew로 설치합니다:

```bash
brew tap codegraph/tap
brew install codegraph
```

## 첫 번째 그래프 구축하기

CodeGraph를 설치한 후, 코드베이스에서 지식 그래프를 생성하는 것은 한 줄의 명령어로 끝납니다:

```bash
codegraph scan \
  --source-dir ./src/main \
  --output-dir ./codegraph-output \
  --format json
```

이 명령은 `./src/main` 아래의 모든 Kotlin 및 Java 소스 파일을 스캔하고, 의존성 그래프를 구축한 다음, JSON 형식으로 `./codegraph-output`에 내보냅니다. `json` 대신 `dot`(Graphviz 형식)이나 `graphml`(그래프 데이터베이스 도구와 호환되는 형식)로 변경할 수 있습니다.

생성 후 출력을 확인합니다:

```bash
codegraph inspect \
  --input ./codegraph-output/graph.json \
  --query "classes package=com.example.service"
```

## 프로그래밍 API 사용하기

더 깊은 통합을 위해 CodeGraph는 풍부한 프로그래밍 API를 제공합니다. 다음은 그래프를 로드하고 쿼리하며 프로그래밍 방식으로 관계를 추출하는 예시입니다:

```kotlin
import io.codegraph.*
import io.codegraph.query.*

fun main() {
    // 기존 그래프 로드
    val graph = GraphLoader.loadFromJson("codegraph-output/graph.json")

    // 특정 베이스 클래스를 상속하는 모든 클래스 찾기
    val subclasses = graph.query {
        where { type == NodeType.CLASS }
        where { name == "com.example.service.UserService" }
        followEdge(EdgeType.EXTENDS)
        select()
    }

    // 특정 메서드를 호출하는 모든 콜러 찾기
    val callers = graph.query {
        where { name == "UserService.login" }
        traceBackward(EdgeType.CALLS)
        where { type == NodeType.FUNCTION }
        select()
    }

    // 패키지의 전이 의존성 계산
    val dependencies = graph.query {
        where { package == "com.example.api" }
        followEdges(EdgeType.DEPENDS_ON)
        depth = 3
        selectUnique()
    }

    println("하위 클래스: ${subclasses.count()}")
    println("콜러: ${callers.count()}")
    println("전이 의존성: ${dependencies.count()}")
}
```

## 내장 쿼리 언어로 그래프 쿼리하기

CodeGraph는 강력한 선언형 쿼리 언어를 제공합니다. 다음은 몇 가지 일반적인 사용 패턴입니다:

### 패키지의 모든 클래스 찾기

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "classes package=com.example.api"
```

### 특정 메서드를 호출하는 함수 찾기

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "callers of UserService.login"
```

### 함수의 호출 체인 추적

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "call chain of UserController.processRequest" \
  --depth 5
```

### 고아 함수 찾기(호출자가 없는 함수)

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "functions with zero callers"
```

### 순환 의존성 감지

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "circular dependencies among packages"
```

## 활용 사례

CodeGraph는 다양한 개발 시나리오에 활용됩니다. 가장 영향력 있는 사례들을 소개합니다:

### 신규 개발자 온보딩

새로운 팀원은 모든 파일을 읽지 않고도 그래프를 쿼리하여 코드베이스 구조를 파악할 수 있습니다. `classes package=com.example`과 같은 간단한 쿼리는 패키지로 정리된 모든 클래스의 깔끔한 목록을 반환하여 아키텍처에 대한 즉각적인 mentale map을 제공합니다.

### 리팩토링 안전성

클래스나 함수를 리팩토링하기 전에 개발자는 모든 의존성과 호출자를 추적하여 변경의 파급효과를 이해할 수 있습니다. 이는 "메서드 하나만 변경했는데"라는 고전적인 놀람을 방지합니다. 작은 변경이 수십 개의 관련 없는 파일을 깨뜨리는 경우처럼요.

### 아키텍처 위반 감지

CodeGraph는 아키텍처 위반을 자동으로 감지할 수 있습니다. 예를 들어, 서비스 레이어를 우회하는 UI 레이어에서 데이터 레이어로의 모든 의존성을 쿼리할 수 있습니다:

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "classes package=ui" \
  --follow "DEPENDS_ON" \
  --filter "classes package=repo" \
  --violation "should go through service layer"
```

### 기술 부채 식별

과도한 진입 에지가 있거나 호출자가 없는 함수는 유지보수 부담을 나타낼 수 있습니다. CodeGraph는 다음 쿼리로 이러한 문제를 플래그합니다:

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "functions with callers > 20"
```

### API 표면 분석

공개 API의 경우, CodeGraph는 외부 소비자에게 노출된 클래스와 메서드를 추적하여 라이브러리의 실제 공개 표면과 내부 구현 세부정보를 구분합니다.

더 많은 Kotlin 생태계 도구를 알아보고 싶다면 [dibi8-internal-link](https://dibi8.com)를 참조하세요.

## 비교: CodeGraph vs. 대안 도구

| 기능 | CodeGraph | Sourcetrail | IDE 인덱스 | jOOQ Codegen | ArchUnit |
|---------|-----------|-------------|-----------|-------------|----------|
| 그래프 시각화 | 예 | 예 | 아니오 | 아니오 | 아니오 |
| 쿼리 언어 | 내장 DSL | 수동 필터링 | 검색창 | N/A | Java DSL |
| 증분 업데이트 | 예 | 아니오 | 예 | N/A | N/A |
| CLI 지원 | 완전한 CLI | GUI 전용 | IDE 전용 | N/A | 테스트 전용 |
| 내보내기 형식 | JSON, DOT, GraphML | DOT 전용 | N/A | N/A | N/A |
| 언어 지원 | Kotlin, Java | 다중 | 다중 | Java | Java |
| 확장성 | 플러그인 API | 제한적 | IDE 플러그인 | N/A | Java 테스트 |
| 프로그래밍 API | Kotlin API | 없음 | N/A | API | 테스트 API |
| 커뮤니티 규모 | 성장 중 | 안정적 | 매우 큼 | 큼 | 큼 |
| 유지보수 상태 | 활성 | 비활성 | 활성 | 활성 | 활성 |

## 실제 예시: GraphQL 서버 구축하기

Ktor를 사용하여 GraphQL 서버를 구축한다고 가정해 봅시다. CodeGraph는 데이터 모델, GraphQL 타입, 리졸버 간의 관계를 시각화하는 데 도움을 줍니다:

```kotlin
import io.codegraph.*

fun analyzeGraphQLServer() {
    val graph = GraphLoader.loadFromJson("graphql-project/codegraph-output/graph.json")

    // 모든 데이터 모델 클래스 찾기
    val models = graph.query {
        where { package.startsWith("com.myapp.model") }
        where { type == NodeType.CLASS }
        select()
    }

    // 모든 GraphQL 리졸버 찾기
    val resolvers = graph.query {
        where { package.startsWith("com.myapp.graphql") }
        where { type == NodeType.FUNCTION }
        select()
    }

    // 모델과 리졸버 간의 매핑 찾기
    val mappings = graph.query {
        from(models)
        followEdge(EdgeType.CALLS)
        whereIn(resolvers)
        select()
    }

    println("데이터 모델: ${models.count()}")
    println("리졸버: ${resolvers.count()}")
    println("모델-리졸버 매핑: ${mappings.count()}")
}
```

이 분석은 리졸버 커버리지의 격차를 드러내며, 모든 데이터 모델에 대응되는 GraphQL 리졸버가 있는지 확인할 수 있게 합니다.

## 비교: CodeGraph vs. 전통적인 코드 리뷰

| 측면 | CodeGraph | 수동 코드 리뷰 | 코드 검색(grep/ripgrep) |
|--------|-----------|-------------------|---------------------------|
| 관계 이해 | 전체 그래프, 전이 의존성 | 부분적, 경험 의존적 | 텍스트 기반, 의미론적 컨텍스트 없음 |
| 연결 탐색 시간 | 초 단위 | 분~시간 | 초 단위지만 불완전 |
| 정확도 | 100%(의미론적) | 인간 오류 가능 | 구문만 처리, 의미론 생략 |
| 범위 | 전체 코드베이스 | 리뷰된 파일로 제한 | 전체 코드베이스이지만 피상적 |
| 시각화 | 인터랙티브 그래프 | 없음 | 없음 |
| 증분 분석 | 변경된 파일만 | 전체 리뷰 필요 | 전체 재스캔 필요 |
| 자동화 | 완전 자동화 | 수동 프로세스 | 부분 자동화 |
| 학습 곡선 | 중간(Kotlin) | 높음(코드베이스 지식) | 낮음 |

## CI/CD 파이프라인과 통합하기

CodeGraph는 CI/CD 파이프라인에 매끄럽게 통합되어 아키텍처 규칙을 자동으로 강제합니다:

```yaml
# .github/workflows/codegraph.yml
name: CodeGraph 분석
on:
  pull_request:
    branches: [main]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: JDK 설정
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
      - name: Code Graph 생성
        run: |
          ./gradlew codegraphGenerate
      - name: 아키텍처 규칙 확인
        run: |
          ./gradlew codegraphCheck --rules=arch-rules.json
      - name: 그래프 보고서 내보내기
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: codegraph-report
          path: build/codegraph/
```

## 제한사항

CodeGraph는 강력하지만 몇 가지 중요한 제한사항이 있습니다:

1. **JVM 언어만 지원**: 현재 Kotlin과 Java만 지원합니다. JavaScript, Python 등 비-JVM 언어는 지원하지 않습니다.
2. **런타임 분석 없음**: CodeGraph는 컴파일 타임 정적 구조만 분석합니다. 동적 디스패치, 리플렉션 기반 호출, 런타임 생성 코드는 볼 수 없습니다.
3. **타사 라이브러리 커버리지**: 외부 JAR에서의 의존성은 소스가 제공되지 않으면 완전히 분석되지 않을 수 있습니다.
4. **메모리 사용량**: 대규모 코드베이스(50만 라인 이상)는 그래프 구축에 상당한 힙 공간이 필요합니다. 최소 4GB RAM을 권장합니다.
5. **빌드 의존성**: CodeGraph는 분석의 일환으로 코드를 컴파일해야 하므로 증분 스캔 시 빌드 시간 오버헤드가 발생합니다.
6. **자연어 쿼리 미지원**: 쿼리는 선언형 구문을 사용하며 자연어를 사용하지 않습니다. 자연어 레이어를 위에 추가할 수는 있지만 포함되지 않습니다.
7. **단일 스레드 분석**: 그래프 구축은 단일 스레드로 동작하므로 매우 큰 프로젝트에서는 느릴 수 있습니다.

## 자주 묻는 질문 (FAQ)

### Q1: CodeGraph는 어떤 언어를 지원하나요?

CodeGraph는 현재 Kotlin과 Java를 지원합니다. Kotlin 컴파일러의 내부 API를 파싱에 사용하므로 Kotlin 코드에 대한 심층적인 의미론적 이해를 가지고 있습니다. Scala와 Groovy를 비롯한 다른 JVM 언어 지원은 향후 릴리스에서 예정되어 있습니다.

### Q2: CodeGraph는 Gradle 멀티모듈 프로젝트를 분석할 수 있나요?

네. CodeGraph는 네이티브로 Gradle과 Maven 멀티모듈 프로젝트를 처리합니다. 프로젝트 루트에서 `codegraph scan`을 실행하면 모든 모듈과 모듈 간 의존성을 자동으로 감지합니다. `--multi-module` 플래그는 추가적인 모듈 간 분석을 활성화합니다:

```bash
codegraph scan --source-dir . --multi-module
```

### Q3: CodeGraph는 얼마나 큰 코드베이스를 처리할 수 있나요?

CodeGraph는 최대 200만 라인 코드의 코드베이스로 테스트되었습니다. 성능은 코드 크기에 거의 선형적으로 스케일합니다. 매우 대규모 코드베이스(100만 라인 이상)의 경우 JVM 힙 크기를 8GB 이상으로 늘리세요:

```bash
java -Xmx8g -jar codegraph-cli.jar scan --source-dir ./src
```

### Q4: 비-Kotlin 프로젝트에서 CodeGraph를 사용할 수 있나요?

JVM에서 컴파일되는 프로젝트라면 CodeGraph를 사용할 수 있습니다. 프레임워크, 라이브러리, 빌드 도구에 관계없이 모든 Java 또는 Kotlin 프로젝트에서 작동합니다. Scala와 Clojure와 같은 순수 JVM 언어도 잘 작동합니다. 비-JVM 프로젝트의 경우 다른 도구가 필요합니다.

### Q5: CodeGraph는 동적으로 생성된 코드를 처리하나요?

CodeGraph는 정적으로 컴파일된 소스 코드를 분석합니다. 프로젝트에서 코드 생성(Kotlin Poet, jOOQ codegen, Protobuf 등)을 사용하는 경우, 생성된 코드를 스캔 대상에 포함해야 합니다. 생성된 소스 디렉토리를 스캔 경로에 추가하세요:

```bash
codegraph scan \
  --source-dir ./src/main \
  --source-dir ./build/generated
```

### Q6: CodeGraph를 코드 품질 메트릭에 사용할 수 있나요?

네. CodeGraph는 그래프 구조에서 다양한 코드 품질 메트릭을 계산할 수 있습니다: AST 분석과 결합한 순환 복잡도, 결합도 메트릭, 응집도 점수, 의존성 깊이 등. `codegraph metrics` 서브커맨드를 사용하세요:

```bash
codegraph metrics --input ./codegraph-output/graph.json --output ./report.json
```

### Q7: CodeGraph는 IDE 내장 코드 인사이트 도구와 어떻게 다른가요?

IDE 도구는 현재 열려 있는 파일에 대한 실시간 분석을 제공합니다. CodeGraph는 전체 코드베이스를 분석하며, 쿼리하고 내보내며 자동화 워크플로우에 통합할 수 있는 영구적인 그래프를 제공합니다. 일상적인 탐색에는 IDE 도구를, 심층 아키텍처 분석에는 CodeGraph를 사용하세요.

## 출처 및 추가 자료

1. CodeGraph 공식 저장소: https://github.com/kotlin-io/codegraph
2. CodeGraph 문서: https://codegraph.io/docs
3. Kotlin 컴파일러 내부: https://github.com/JetBrains/kotlin/tree/master/compiler
4. 그래프 데이터베이스 모범 사례: https://neo4j.com/docs/
5. 정적 분석 도구를 사용한 소프트웨어 아키텍처 분석: https://www.seas.upenn.edu/~sergey/papers/

## 행동 유도

코드베이스를 탐색 가능한 지식 그래프로 변환할 준비가 되셨나요? 오늘 CodeGraph를 시도하고 프로젝트 아키텍처를 이해하는 데 고통받지 마세요.

더 많은 정보를 원하시면 Telegram 커뮤니티에 참여하세요: https://t.me/DIBI8_Group/9

**추천 도구:**

- Binance: Binance에서 거래 시작하기. 등록: https://www.bsmkweb.cc/register?ref=DIBI8
- OKX 거래소: OKX로 거래하기. 가입: https://www.promoohubly.com/join/12190433
- WebShare: WebShare로 익명浏览. 시작하기: https://www.webshare.io/?referral_code=oa14d5f0wx4f
- DigitalOcean: DigitalOcean에 프로젝트 배포. 가입: https://m.do.co/c/eca87ac14ee0
- HTStack: 클라우드 인프라 관리. 가입: https://my.htstack.com/aff.php?aff=27187

---

DIBI8는 최고의 오픈소스 도구, AI 혁신, 개발자 리소스를 발견하는 당신의 게이트웨이입니다. 기술 분야에서 가장 영향력 있는 프로젝트에 대한 일일 업데이트를 위해 Telegram 채널을 구독하세요.
