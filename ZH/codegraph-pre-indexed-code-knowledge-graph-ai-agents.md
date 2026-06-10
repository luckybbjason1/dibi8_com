---
title: "CodeGraph: 从代码库构建知识图谱"
slug: "codegraph-pre-indexed-code-knowledge-graph-ai-agents"
category: "dev-utils"
publish_date: "2026-06-10"
author: "DIBI8"
tags: ["kotlin", "graph", "code-analysis", "devtools", "knowledge-graph"]
featureImage: "https://avatars.githubusercontent.com/u/11434"
---

# CodeGraph：从代码库构建知识图谱

## 引言

每个软件项目的复杂度都超出了人类认知的极限。新团队成员往往需要数周时间才能弄清楚一个函数的位置以及它如何与系统的其余部分连接。CodeGraph 是一款开源工具，它将整个代码库转化为一个可导航的知识图谱，让你一眼就能看清类、函数、接口和包之间的关系。CodeGraph 使用 Kotlin 编写，为需要深度理解代码库的开发者提供了强大的 CLI 工具和一个程序化 API。

## 什么是 CodeGraph？

CodeGraph 是一个 Kotlin 原生的库和 CLI 工具，它解析你的源代码并构建全面的图表示。可以把它想象成你代码的通用图数据库：每个节点是一个程序元素（类、函数、包、接口），每条边代表一种关系（继承、实现、调用、依赖）。有了这种图结构，你可以在几毫秒内回答诸如"哪些类实现了这个接口？"和"这个包的传递依赖是什么？"这样的问题。

该工具支持 Kotlin、Java，并且可以扩展到其他 JVM 语言。它使用 Kotlin 编译器自身的解析基础设施，因此它理解你代码的完整语义上下文，而不仅仅是表面上的文本模式。

想要了解更多代码分析工具，请参阅我们的 [dibi8-internal-link](https://dibi8.com)。

## 核心功能

CodeGraph 在精简的包中集成了令人惊讶的丰富功能：

- **自动代码解析**：从源代码构建完整的依赖图
- **查询 API**：程序化查询以查找节点、遍历关系和过滤结果
- **CLI 工具**：一条命令生成图并从终端进行交互式查询
- **导出功能**：将图导出为 JSON、DOT（Graphviz）或 GraphML 格式
- **增量更新**：仅重建更改的部分以实现快速增量分析
- **IDE 集成**：可用作库来驱动 IDE 插件
- **自定义查询**：使用内置的图查询语言编写自己的查询

## 安装

安装 CodeGraph 非常简单。最常见的方法是通过 Gradle 插件或 Maven 依赖。你也可以直接下载 CLI JAR 文件。

### 通过 Gradle 安装

在 `build.gradle.kts` 中将 CodeGraph 添加为依赖项：

```kotlin
plugins {
    id("org.jetbrains.kotlin.jvm") version "1.9.22"
}

dependencies {
    implementation("io.codegraph:codegraph-core:1.2.0")
    implementation("io.codegraph:codegraph-cli:1.2.0")
}
```

### 通过 Maven 安装

```xml
<dependency>
    <groupId>io.codegraph</groupId>
    <artifactId>codegraph-core</artifactId>
    <version>1.2.0</version>
</dependency>
```

### 安装 CLI 工具

下载最新的 CLI JAR 文件并直接运行：

```bash
curl -L -o codegraph-cli.jar https://repo.maven.apache.org/maven2/io/codegraph/codegraph-cli/1.2.0/codegraph-cli-1.2.0.jar
java -jar codegraph-cli.jar --version
```

或者在 macOS 上通过 Homebrew 安装：

```bash
brew tap codegraph/tap
brew install codegraph
```

## 构建第一个图

安装 CodeGraph 后，生成代码库的知识图只需一条命令：

```bash
codegraph scan \
  --source-dir ./src/main \
  --output-dir ./codegraph-output \
  --format json
```

这条命令扫描 `./src/main` 下的所有 Kotlin 和 Java 源文件，构建依赖图，并将其导出为 JSON 格式到 `./codegraph-output`。你可以将 `json` 替换为 `dot`（Graphviz 格式）或 `graphml`（与图数据库工具兼容的格式）。

生成后，检查输出内容：

```bash
codegraph inspect \
  --input ./codegraph-output/graph.json \
  --query "classes package=com.example.service"
```

## 使用程序化 API

为了实现更深度的集成，CodeGraph 提供了一个丰富的程序化 API。以下是加载图、查询图以及以编程方式提取关系的示例：

```kotlin
import io.codegraph.*
import io.codegraph.query.*

fun main() {
    // 加载已有图
    val graph = GraphLoader.loadFromJson("codegraph-output/graph.json")

    // 查找所有继承特定基类的类
    val subclasses = graph.query {
        where { type == NodeType.CLASS }
        where { name == "com.example.service.UserService" }
        followEdge(EdgeType.EXTENDS)
        select()
    }

    // 查找特定方法的所有调用者
    val callers = graph.query {
        where { name == "UserService.login" }
        traceBackward(EdgeType.CALLS)
        where { type == NodeType.FUNCTION }
        select()
    }

    // 计算包的传递依赖
    val dependencies = graph.query {
        where { package == "com.example.api" }
        followEdges(EdgeType.DEPENDS_ON)
        depth = 3
        selectUnique()
    }

    println("子类数量: ${subclasses.count()}")
    println("调用者数量: ${callers.count()}")
    println("传递依赖: ${dependencies.count()}")
}
```

## 使用内置查询语言查询图

CodeGraph 内置了一套强大的声明式查询语言。以下是几种常见用法：

### 查找包中的所有类

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "classes package=com.example.api"
```

### 查找调用特定方法的函数

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "callers of UserService.login"
```

### 追踪函数的调用链

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "call chain of UserController.processRequest" \
  --depth 5
```

### 查找孤儿函数（无人调用的函数）

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "functions with zero callers"
```

### 检测循环依赖

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "circular dependencies among packages"
```

## 实际应用场景

CodeGraph 服务于广泛的各种开发场景。以下是影响力最大的几个场景：

### 新员工入职培训

新团队成员可以通过查询图来了解代码库结构，而无需阅读每个文件。一个简单的查询如 `classes package=com.example` 会返回按包组织的所有类的清晰列表，为架构提供一个即时的心理地图。

### 重构安全保障

在重构类或函数之前，开发者可以追踪所有依赖者和调用者，以了解变更的影响范围。这可以防止经典的"我只改了一个方法"式的意外——一个小改动破坏了数十个不相关的文件。

### 架构违规检测

CodeGraph 可以自动检测架构违规。例如，你可以查询从 UI 层到数据层的任何绕过服务层的依赖：

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "classes package=ui" \
  --follow "DEPENDS_ON" \
  --filter "classes package=repo" \
  --violation "should go through service layer"
```

### 技术债务识别

具有过多入边或没有任何调用者的函数可能表明维护负担。CodeGraph 通过以下查询标记这些问题：

```bash
codegraph query \
  --input ./codegraph-output/graph.json \
  --filter "functions with callers > 20"
```

### API 表面分析

对于公共 API，CodeGraph 帮助识别库的真正公共表面，通过追踪哪些类和方法暴露给外部消费者，而非内部实现细节。

想要深入了解 Kotlin 生态工具，可以参考 [dibi8-internal-link](https://dibi8.com)。

## 对比：CodeGraph vs. 其他工具

| 功能 | CodeGraph | Sourcetrail | IDE 索引 | jOOQ Codegen | ArchUnit |
|---------|-----------|-------------|-----------|-------------|----------|
| 图可视化 | 是 | 是 | 否 | 否 | 否 |
| 查询语言 | 内置 DSL | 手动过滤 | 搜索栏 | 不适用 | Java DSL |
| 增量更新 | 是 | 否 | 是 | 不适用 | 不适用 |
| CLI 支持 | 完整 CLI | 仅 GUI | 仅 IDE | 不适用 | 仅测试 |
| 导出格式 | JSON、DOT、GraphML | 仅 DOT | 不适用 | 不适用 | 不适用 |
| 语言支持 | Kotlin、Java | 多语言 | 多语言 | Java | Java |
| 可扩展性 | 插件 API | 有限 | IDE 插件 | 不适用 | Java 测试 |
| 程序化 API | Kotlin API | 无 | 不适用 | API | 测试 API |
| 社区规模 | 快速增长 | 成熟 | 非常庞大 | 庞大 | 庞大 |
| 维护状态 | 活跃 | 已停止 | 活跃 | 活跃 | 活跃 |

## 真实案例：构建 GraphQL 服务器

假设你正在使用 Ktor 构建一个 GraphQL 服务器。CodeGraph 帮助你可视化数据模型、GraphQL 类型和解析器之间的关系：

```kotlin
import io.codegraph.*

fun analyzeGraphQLServer() {
    val graph = GraphLoader.loadFromJson("graphql-project/codegraph-output/graph.json")

    // 查找所有数据模型类
    val models = graph.query {
        where { package.startsWith("com.myapp.model") }
        where { type == NodeType.CLASS }
        select()
    }

    // 查找所有 GraphQL 解析器
    val resolvers = graph.query {
        where { package.startsWith("com.myapp.graphql") }
        where { type == NodeType.FUNCTION }
        select()
    }

    // 查找模型与解析器之间的映射
    val mappings = graph.query {
        from(models)
        followEdge(EdgeType.CALLS)
        whereIn(resolvers)
        select()
    }

    println("数据模型数量: ${models.count()}")
    println("解析器数量: ${resolvers.count()}")
    println("模型-解析器映射: ${mappings.count()}")
}
```

此分析揭示了你的解析器覆盖范围中的缺口，并确保每个数据模型都有相应的 GraphQL 解析器。

## 对比：CodeGraph vs. 传统代码审查

| 方面 | CodeGraph | 手动代码审查 | 代码搜索（grep/ripgrep） |
|--------|-----------|-------------------|---------------------------|
| 关系理解 | 完整图、传递依赖 | 部分，依赖经验 | 基于文本，无语义上下文 |
| 查找连接所需时间 | 秒 | 分钟到小时 | 秒但不完整 |
| 准确性 | 100%（语义级） | 可能出现人为错误 | 仅语法，遗漏语义 |
| 范围 | 整个代码库 | 限于已审查文件 | 整个代码库但原始 |
| 可视化 | 交互式图 | 无 | 无 |
| 增量分析 | 仅扫描变更文件 | 需要完整审查 | 需要完整重新扫描 |
| 自动化程度 | 完全自动化 | 手动流程 | 部分自动化 |
| 学习曲线 | 中等（Kotlin） | 高（代码库知识） | 低 |

## 集成到 CI/CD 流水线

CodeGraph 无缝集成到 CI/CD 流水线中，自动执行架构规则：

```yaml
# .github/workflows/codegraph.yml
name: CodeGraph 分析
on:
  pull_request:
    branches: [main]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: 配置 JDK
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
      - name: 生成 Code 图
        run: |
          ./gradlew codegraphGenerate
      - name: 检查架构规则
        run: |
          ./gradlew codegraphCheck --rules=arch-rules.json
      - name: 导出图报告
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: codegraph-report
          path: build/codegraph/
```

## 限制与不足

虽然 CodeGraph 功能强大，但它有几个重要的限制：

1. **仅限 JVM 语言**：目前仅支持 Kotlin 和 Java。不支持 JavaScript、Python 或其他非 JVM 语言。
2. **无运行时分析**：CodeGraph 仅分析编译时的静态结构。动态分派、基于反射的调用和运行时生成的代码不可见。
3. **第三方库覆盖有限**：来自外部 JAR 的依赖可能无法被完全分析，除非有源代码可用。
4. **内存占用**：大型代码库（50 万行以上）需要大量堆空间来构建图。建议至少 4GB 内存。
5. **构建依赖**：CodeGraph 需要在分析过程中编译你的代码，增量扫描会添加构建时间开销。
6. **不支持自然语言查询**：查询使用声明式语法，而非自然语言。可以在此基础上添加自然语言层，但不包含在内。
7. **单线程分析**：图的构建是单线程的，对于非常大的项目来说可能较慢。

## 常见问题（FAQ）

### Q1：CodeGraph 支持哪些语言？

CodeGraph 目前支持 Kotlin 和 Java。它使用 Kotlin 编译器的内部 API 进行解析，这意味着它对 Kotlin 代码有深度的语义理解。Scala 和 Groovy 等其他 JVM 语言的支持计划在未来的版本中推出。

### Q2：CodeGraph 可以分析 Gradle 多模块项目吗？

可以。CodeGraph 原生支持多模块 Gradle 和 Maven 项目。当你在项目根目录运行 `codegraph scan` 时，它会自动检测所有模块及其模块间依赖关系。`--multi-module` 标志启用了额外的模块间分析：

```bash
codegraph scan --source-dir . --multi-module
```

### Q3：CodeGraph 能处理多大规模的代码库？

CodeGraph 已在高达 200 万行代码的代码库上进行了测试。性能大致随代码规模线性扩展。对于非常大的代码库（100 万行以上），将 JVM 堆大小增加到 8GB 或更多：

```bash
java -Xmx8g -jar codegraph-cli.jar scan --source-dir ./src
```

### Q4：我可以在非 Kotlin 项目中使用 CodeGraph 吗？

如果你的项目可以在 JVM 上编译，你就可以使用 CodeGraph。它适用于任何 Java 或 Kotlin 项目，无论使用什么框架、库或构建工具。纯 JVM 语言如 Scala 和 Clojure 也能很好地工作。对于非 JVM 项目，你需要使用其他工具。

### Q5：CodeGraph 能处理动态生成的代码吗？

CodeGraph 分析静态编译的源代码。如果你的项目使用代码生成（如 Kotlin Poet、jOOQ codegen、Protobuf），你应该确保将生成的代码包含在扫描目标中。将生成的源目录添加到扫描路径：

```bash
codegraph scan \
  --source-dir ./src/main \
  --source-dir ./build/generated
```

### Q6：CodeGraph 可用于代码质量度量吗？

可以。CodeGraph 可以从图结构计算多种代码质量指标：结合 AST 分析的圈复杂度、耦合度量、内聚分数和依赖深度。使用 `codegraph metrics` 子命令：

```bash
codegraph metrics --input ./codegraph-output/graph.json --output ./report.json
```

### Q7：CodeGraph 与 IDE 内置的代码洞察工具有何区别？

IDE 工具提供针对当前打开文件的即时分析。CodeGraph 分析整个代码库，并提供一个可查询、可导出、可集成到自动化工作流中的持久化图。日常导航使用 IDE 工具，深度架构分析使用 CodeGraph。

## 参考来源

1. CodeGraph 官方仓库：https://github.com/kotlin-io/codegraph
2. CodeGraph 文档：https://codegraph.io/docs
3. Kotlin 编译器内部原理：https://github.com/JetBrains/kotlin/tree/master/compiler
4. 图数据库最佳实践：https://neo4j.com/docs/
5. 使用静态分析工具进行软件架构分析：https://www.seas.upenn.edu/~sergey/papers/

## 行动号召

准备好将你的代码库转化为可导航的知识图谱了吗？今天就开始试用 CodeGraph，再也不用为理解项目架构而苦恼了。

欲了解更多信息，加入我们的 Telegram 社群：https://t.me/DIBI8_Group/4

**推荐工具：**

- Binance：开始使用 Binance 进行交易。注册链接：https://www.bsmkweb.cc/register?ref=DIBI8
- OKX 交易所：使用 OKX 进行交易。注册链接：https://www.promoohubly.com/join/12190433
- WebShare：使用 WebShare 匿名浏览。开始使用：https://www.webshare.io/?referral_code=oa14d5f0wx4f
- DigitalOcean：在 DigitalOcean 上部署你的项目。注册链接：https://m.do.co/c/eca87ac14ee0
- HTStack：管理你的云基础设施。加入链接：https://my.htstack.com/aff.php?aff=27187

---

DIBI8 是你探索最佳开源工具、AI 创新和开发者资源的门户。订阅我们的 Telegram 频道，获取科技领域最具影响力项目的每日更新。
