---
title: 'ibis-dataframe-python-sql'
description: '{''en'': ''Discover Ibis, the Python DataFrame library that compiles expressions to SQL for 20+ backends including DuckDB, PostgreSQL, BigQuery, and Snowflake. Learn how lazy evaluation and type-safe expressions deliver 10x performance over pandas.'', ''zh'': ''发现 Ibis，这款将表达式编译为 SQL 的 Python DataFrame 库，支持 DuckDB、PostgreSQL、BigQuery、Snowflake 等 20+ 后端。了解惰性求值和类型安全表达式如何带来比 pandas 快 10 倍的性能。'', ''ko'': ''DuckDB, PostgreSQL, BigQuery, Snowflake를 포함한 20개 이상의 백엔드를 위해 표현식을 SQL로 컴파일하는 Python DataFrame 라이브러리 Ibis를 알아보세요. 지연 평가와 타입 안전 표현식이 pandas보다 10배 빠른 성능을 제공하는 방법을 배워보세요.'', ''vi'': ''Khám phá Ibis, thư viện DataFrame Python biên dịch biểu thức thành SQL cho 20+ backend bao gồm DuckDB, PostgreSQL, BigQuery và Snowflake. Tìm hiểu cách đánh giá lưới và biểu thức kiểu an toàn mang lại hiệu suất gấp 10 lần so với pandas.''}'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Data Science
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
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['data-science']
tags: ['Ibis']
aliases:
- /zh/posts/ibis-dataframe-python-sql/
---

{{</* resource-info */>}}

在数据分析领域不断演进的格局中，Python 开发者长期面临一个令人沮丧的困境：应该选择**pandas**以获得直观的 DataFrame API，还是编写原生 **SQL** 以在大型数据集上获得更优的性能？到了 2026 年，这种权衡已不再必要。**Ibis** 应运而生 —— 一个可移植的开源 Python 库，提供熟悉的 DataFrame API，同时将表达式编译为高性能 SQL，在 20 多个后端上执行。凭借超过 12,000 个 GitHub Star 和 Apache-2.0 许可证，Ibis 正在改变数据工程师和数据科学家与数据库交互的方式。

无论您是查询本地 DuckDB 实例、生产级 PostgreSQL 集群、PB 级 BigQuery 数据仓库，还是 Snowflake 企业分析环境，Ibis 都能提供统一且一致的 API。它的秘密武器 —— **惰性求值**、**类型安全表达式**和 **SQL 编译** —— 通常比传统 pandas 工作流快 10 倍的性能，同时又不牺牲开发者喜爱的 Python 风格表达性。

在本综合指南中，我们将探索 Ibis 的所有功能：从安装和基本查询到高级模式和实际基准测试。读完本文，您将明白为什么 Ibis 正成为拒绝在生产力和性能之间妥协的数据从业者的默认选择。

---

## 什么是 Ibis？数据分析的新范式

Ibis 是由 **Wes McKinney**（pandas 的原作者）创建的 Python DataFrame 库。与完全在内存中运行的 pandas 不同，Ibis 采用了一种根本不同的方法：它提供了一个**可编译为 SQL 的 DataFrame API**。这意味着您编写的代码外观和感觉都像 pandas，但 Ibis 会将这些表达式转换为优化的 SQL 查询，直接在您的数据库引擎中运行。

结果如何？您获得了两全其美的优势：Python 的 ergonomics 与现代 SQL 查询引擎的原始强大功能相结合。不再需要仅仅为了计算聚合就将数百万行数据拉入内存。不再需要在 Python 和 SQL 方言之间来回切换上下文。Ibis 将您的数据工作流统一在一个优雅、可移植的接口之下。

```python
# Ibis 对任何 pandas 用户来说都很熟悉
import ibis

con = ibis.duckdb.connect("analytics.db")
t = con.table("sales")

result = (
    t.group_by("region")
     .aggregate(total_sales=t.amount.sum())
     .order_by(ibis.desc("total_sales"))
     .limit(10)
)

# 执行查询 — 在 DuckDB 内部运行，不在 Python 内存中
print(result.execute())
```

在幕后，Ibis 将上述表达式编译为优化的 SQL 查询，将所有计算推送到后端，并仅返回最终的聚合结果。这种架构使 Ibis 能够处理足以使 pandas 进程崩溃的数据集。

---

## 为什么 Ibis 在 2026 年至关重要

2026 年的数据格局比以往任何时候都更加分散。组织在由多个系统组成的混合环境中运行分析：本地 DuckDB 用于开发，PostgreSQL 用于事务数据，BigQuery 用于数据仓库，Snowflake 用于企业分析，ClickHouse 用于实时工作负载。从历史上看，每个系统都需要学习不同的 SDK、不同的 SQL 方言和不同的心智模型。

Ibis 优雅地解决了这种碎片化问题。其统一的 DataFrame API 在所有支持的后端上完全相同地工作。您为 DuckDB 编写的代码可以在 BigQuery 或 Snowflake 上 unchanged 地运行。这种可移植性不仅仅是一种便利 —— 对于需要在不重新编写分析管道的情况下在不同环境之间切换的团队来说，它是一个游戏规则改变者。

```python
# 相同的代码在所有后端上都能运行
query = (
    t.select("customer_id", "order_date", "amount")
     .filter(t.amount > 100)
     .group_by("customer_id")
     .aggregate(
         order_count=t.order_date.count(),
         total_spent=t.amount.sum(),
         avg_order=t.amount.mean()
     )
     .filter(ibis._.order_count >= 5)
     .order_by(ibis.desc("total_spent"))
)

# 在 DuckDB 上运行
con_duck = ibis.duckdb.connect("local.db")
result_local = query.execute()

# 在 BigQuery 上运行完全相同的查询
con_bq = ibis.bigquery.connect(project_id="my-project")
result_cloud = query.execute()
```

除了可移植性之外，Ibis 还解决了困扰 pandas 工作流的**性能瓶颈**。由于 Ibis 将计算推送到后端查询引擎，它永远不会在 Python 内存中物化中间结果。聚合、连接、窗口函数和筛选都在数据库内部执行 —— 这正是它们应该在的地方。

---

## 安装 Ibis 和后端依赖

开始使用 Ibis 非常简单。核心库非常轻量，您只需要安装所需的后端额外组件。

```bash
# 安装 Ibis 核心
pip install ibis-framework

# 安装特定后端支持
pip install "ibis-framework[duckdb]"
pip install "ibis-framework[postgres]"
pip install "ibis-framework[bigquery]"
pip install "ibis-framework[snowflake]"
pip install "ibis-framework[mysql]"
pip install "ibis-framework[clickhouse]"

# 一次安装多个后端
pip install "ibis-framework[duckdb,postgres,bigquery]"
```

对于 conda 用户：

```bash
conda install -c conda-forge ibis-framework
conda install -c conda-forge ibis-duckdb ibis-postgres
```

安装完成后，验证一切正常：

```python
import ibis
print(ibis.__version__)

# 列出可用的后端
print(ibis.util.backend_entry_points())
```

Ibis 目前支持 20 多个后端，包括 DuckDB、PostgreSQL、MySQL、SQLite、BigQuery、Snowflake、ClickHouse、Trino、PySpark、DataFusion 等。后端生态系统随着每次发布都在不断扩展。

---

## 连接 20 多个 SQL 后端

Ibis 的标志性优势之一是能够连接到几乎任何数据系统。让我们探索如何与最流行的后端建立连接。

### DuckDB（本地分析推荐）

```python
import ibis

# 内存数据库
con = ibis.duckdb.connect()

# 持久化本地数据库
con = ibis.duckdb.connect("my_analytics.db")

# 直接读取 Parquet 文件
con.read_parquet("data/*.parquet", table_name="events")

# 读取 CSV
con.read_csv("customers.csv", table_name="customers")

t = con.table("events")
print(t.count().execute())
```

### PostgreSQL

```python
import ibis

con = ibis.postgres.connect(
    host="localhost",
    port=5432,
    user="analytics",
    password="secret",
    database="production"
)

t = con.table("sales")
print(t.schema())
```

### BigQuery

```python
import ibis

con = ibis.bigquery.connect(
    project_id="my-gcp-project",
    dataset_id="analytics_dataset"
)

t = con.table("user_events")
result = t.filter(t.event_date >= "2026-01-01").execute()
```

### Snowflake

```python
import ibis

con = ibis.snowflake.connect(
    user="ANALYST",
    password="***",
    account="myorg-myaccount",
    database="ANALYTICS",
    schema="PUBLIC",
    warehouse="COMPUTE_WH"
)

t = con.table("transactions")
```

### SQLite

```python
import ibis

con = ibis.sqlite.connect("sample.db")
t = con.table("employees")
```

所有后端的连接 API 都是一致的。一旦您建立了连接并获得了表引用，无论底层是什么，Ibis 表达式 API 的工作方式都是完全相同的。

---

## Ibis DataFrame API：熟悉而强大

如果您使用过 pandas，Ibis API 会立即让您感到熟悉。Ibis 提供了您期望的所有核心 DataFrame 操作：`select`、`filter`、`group_by`、`aggregate`、`order_by`、`limit`、`join` 等等。

### 选择和筛选

```python
import ibis

con = ibis.duckdb.connect()
con.read_parquet("events.parquet", table_name="events")
t = con.table("events")

# 选择特定列
selected = t.select("user_id", "event_type", "timestamp", "value")

# 筛选行
filtered = t.filter(t.event_type == "purchase", t.value > 50)

# 组合条件
filtered = t.filter(
    (t.event_type == "purchase") & (t.value > 50) & (t.timestamp >= "2026-01-01")
)

# 使用 .mutate 创建计算列
enriched = t.mutate(
    value_squared=t.value * t.value,
    is_high_value=t.value > 100
)
```

### 聚合和分组

```python
# 基本聚合
stats = t.aggregate(
    count=t.user_id.count(),
    total_value=t.value.sum(),
    avg_value=t.value.mean(),
    max_value=t.value.max(),
    min_value=t.value.min()
)

# 多字段分组聚合
by_category = (
    t.group_by("event_type", "region")
     .aggregate(
         count=t.user_id.count(),
         total=t.value.sum(),
         avg=t.value.mean()
     )
     .order_by(ibis.desc("total"))
)
```

### 连接操作

```python
users = con.table("users")
orders = con.table("orders")

# 内连接
joined = users.inner_join(
    orders,
    users.user_id == orders.user_id
).select(users.user_id, users.name, orders.amount)

# 多条件左连接
joined = users.left_join(
    orders,
    [users.user_id == orders.user_id,
     orders.order_date >= "2026-01-01"]
).select(users.name, orders.amount)

# 使用别名的自连接
managers = users.view("managers")
reporting = users.inner_join(
    managers,
    users.manager_id == managers.user_id
).select(
    users.name.name("employee"),
    managers.name.name("manager")
)
```

### 窗口函数

```python
# 累计求和
running = t.mutate(
    running_total=t.value.sum().over(
        ibis.window(order_by=t.timestamp)
    )
)

# 按类别分区排名
ranked = t.mutate(
    row_num=ibis.row_number().over(
        ibis.window(group_by=t.event_type, order_by=ibis.desc(t.value))
    )
)

# 移动平均（3 行窗口）
moving = t.mutate(
    moving_avg=t.value.mean().over(
        ibis.window(order_by=t.timestamp, preceding=1, following=1)
    )
)
```

---

## 惰性求值和 SQL 编译

Ibis 最强大的功能之一是其**惰性求值模型**。当您编写 Ibis 表达式时，不会立即发生任何计算。相反，Ibis 会构建查询的内部表示 —— 抽象语法树（AST） —— 然后仅在您调用 `.execute()` 时才将其优化并编译为 SQL。

```python
import ibis

con = ibis.duckdb.connect("sales.db")
t = con.table("transactions")

# 这会构建一个表达式树 —— 还没有查询运行
expr = (
    t.filter(t.amount > 100)
     .group_by("category")
     .aggregate(total=t.amount.sum())
     .order_by(ibis.desc("total"))
     .limit(5)
)

# 检查编译后的 SQL，无需执行
print(expr.sql())
```

输出显示 Ibis 将执行的确切 SQL：

```sql
SELECT "category", SUM("amount") AS "total"
FROM "transactions"
WHERE "amount" > 100
GROUP BY "category"
ORDER BY "total" DESC
LIMIT 5
```

这种惰性方法使 Ibis 能够执行复杂的查询优化。它可以将筛选条件下推到源端，消除不必要的列，合并冗余操作，并利用底层 SQL 引擎的全部优化能力。

```python
# 链式多个操作 —— Ibis 优化整个管道
pipeline = (
    t.filter(t.status == "completed")
     .select("user_id", "amount", "category", "created_at")
     .mutate(
         year=t.created_at.year(),
         month=t.created_at.month()
     )
     .group_by("category", "year", "month")
     .aggregate(
         revenue=t.amount.sum(),
         orders=t.amount.count(),
         avg_order=t.amount.mean()
     )
     .filter(ibis._.revenue > 10000)
     .order_by("year", "month", ibis.desc("revenue"))
)

# 查看优化后的 SQL
print(pipeline.sql())

# 现在才执行查询
results = pipeline.execute()
```

在执行前检查编译后的 SQL 对于调试、查询调优和学习 SQL 来说非常宝贵。它架起了 Python 风格数据操作和以 SQL 为先的分析平台之间的桥梁。

---

## Ibis 的高级查询模式

Ibis 支持超越基本 CRUD 操作的复杂分析模式。让我们探索一些高级功能。

### 自定义表达式和字面量

```python
import ibis
import ibis.selectors as s

con = ibis.duckdb.connect()
t = con.table("sales")

# 使用选择器选择列组
numeric_cols = t.select(s.numeric())
string_cols = t.select(s.of_type("string"))

# 使用字面量
threshold = ibis.literal(1000)
high_value = t.filter(t.amount > threshold)

# 条件表达式（CASE WHEN）
categorized = t.mutate(
    tier=ibis.case()
        .when(t.amount >= 10000, "Platinum")
        .when(t.amount >= 5000, "Gold")
        .when(t.amount >= 1000, "Silver")
        .else_("Bronze")
        .end()
)
```

### 复杂子查询

```python
# 查找高于平均消费的用户
avg_spend = t.amount.mean()
above_avg = t.filter(t.amount > avg_spend)

# 查找每个类别中排名前 3 的产品
from ibis import window, row_number

w = window(group_by=t.category, order_by=ibis.desc(t.revenue))
ranked = t.mutate(rn=row_number().over(w))
top3 = ranked.filter(ranked.rn <= 3)
```

### 用户定义函数（UDF）

```python
# 定义在 DuckDB 中运行的 Python UDF
@ibis.udf.scalar.python
def format_currency(value: float) -> str:
    return f"${value:,.2f}"

applied = t.mutate(
    formatted=format_currency(t.amount)
)
```

### 使用 `_` 引用的交互式操作

```python
# 下划线（_）在管道中引用当前表
result = (
    t.filter(_.amount > 100)
     .group_by(_.category)
     .aggregate(total=_.amount.sum())
     .filter(_.total > 10000)
     .order_by(_.total.desc())
)
```

---

## 性能基准测试：Ibis 与 pandas 的对比

随着数据集规模的增长，Ibis 和 pandas 之间的性能差异变得显著。让我们通过一个具体基准测试来比较这两个库。

```python
import ibis
import pandas as pd
import numpy as np

# 创建 1000 万行的数据集
np.random.seed(42)
n = 10_000_000
df = pd.DataFrame({
    "user_id": np.random.randint(1, 100000, n),
    "category": np.random.choice(["A", "B", "C", "D", "E"], n),
    "amount": np.random.exponential(100, n),
    "region": np.random.choice(["North", "South", "East", "West"], n)
})
df.to_parquet("benchmark.parquet", index=False)

# pandas 方法：将所有内容加载到内存中
import time
start = time.time()
df = pd.read_parquet("benchmark.parquet")
result_pd = (
    df[df.amount > 50]
    .groupby(["category", "region"])
    .agg(total=("amount", "sum"), count=("amount", "count"), avg=("amount", "mean"))
    .reset_index()
    .query("total > 10000")
    .sort_values("total", ascending=False)
)
pandas_time = time.time() - start
print(f"pandas: {pandas_time:.2f}s")

# Ibis 方法：将计算推送到 DuckDB
con = ibis.duckdb.connect()
con.read_parquet("benchmark.parquet", table_name="data")
t = con.table("data")

start = time.time()
result_ibis = (
    t.filter(t.amount > 50)
     .group_by("category", "region")
     .aggregate(
         total=t.amount.sum(),
         count=t.amount.count(),
         avg=t.amount.mean()
     )
     .filter(ibis._.total > 10000)
     .order_by(ibis.desc("total"))
     .execute()
)
ibis_time = time.time() - start
print(f"Ibis + DuckDB: {ibis_time:.2f}s")
print(f"加速比: {pandas_time / ibis_time:.1f}x")
```

在典型硬件上，Ibis + DuckDB 组合执行此查询的速度比 pandas 快 **10-15 倍**，且内存使用量显著降低。pandas 必须将所有 1000 万行加载到 RAM 中，为筛选和分组分配中间数组，并在 Python 中执行所有计算。相比之下，Ibis 将所有内容推送到 DuckDB 优化的 C++ 查询引擎，仅在 Python 中物化小型聚合结果。

对于更大的数据集 —— 数亿甚至数十亿行 —— 差距进一步扩大。pandas 通常会耗尽内存并崩溃，而 Ibis 通过 BigQuery、Snowflake 或 ClickHouse 继续执行，毫无压力。

---

## Ibis 与 SQLAlchemy 与 pandas：何时使用什么

了解 Ibis 与现有工具的比较有助于阐明其独特的价值主张。

| 特性 | pandas | SQLAlchemy | Ibis |
|------|--------|------------|------|
| API 风格 | DataFrame | SQL/ORM | DataFrame |
| 执行方式 | 内存 Python | Python 转 SQL | Python 转 SQL |
| 后端支持 | 无（仅本地） | 多种数据库 | 20+ 后端 |
| 惰性求值 | 否 | 部分 | 是（完整） |
| 类型安全 | 仅运行时 | 编译时 | 编译时 |
| SQL 编译 | 不适用 | 是 | 是（已优化） |
| 扩展性 | 受 RAM 限制 | 数据库规模 | 数据库规模 |

**使用 pandas**：当处理适合内存的小型到中型数据集时，需要快速交互式探索，或需要复杂的非 SQL 操作。

**使用 SQLAlchemy**：当构建基于 ORM 的应用程序，需要与 Flask 或 FastAPI 紧密集成，或更喜欢使用 Python 包装器编写显式 SQL。

**使用 Ibis**：当您想要任何规模下类似 pandas 的体验，需要使用相同代码查询多个数据库后端，或想要带有优化 SQL 编译的惰性求值时。Ibis 是 DataFrame ergonomics 与数据库性能相遇的分析工作负载的最佳选择。

```python
# Ibis 代码比等效的 SQLAlchemy 分析代码更简洁
# Ibis:
result = (
    t.group_by("category")
     .aggregate(total=t.amount.sum())
     .order_by(ibis.desc("total"))
     .limit(10)
).execute()

# 等效的 SQLAlchemy 分析查询需要更多样板代码
```

---

## 常见问题解答（FAQ）

### Ibis 会完全取代 pandas 吗？

不会，Ibis 与 pandas 是互补关系，而非直接替代。Ibis 擅长查询远程数据库和处理超出可用内存的大型数据集。pandas 仍然非常适合小型到中型内存数据集，并提供更丰富的统计和可视化工具生态系统。许多工作流使用 Ibis 来完成繁重的任务（大规模筛选、连接、聚合），然后将较小的结果传递给 pandas 进行最终分析或绘图。

```python
# 混合工作流：Ibis 处理大数据，pandas 进行分析
large_result = ibis_query.execute()  # 返回 pandas DataFrame
small_summary = large_result.describe()  # pandas 用于快速统计
```

### 我可以看到 Ibis 生成的 SQL 吗？

当然可以。您可以随时使用 Ibis 表达式上的 `.sql()` 方法来检查编译后的 SQL。这对于调试、性能调优和学习 SQL 非常有用。

```python
expr = t.group_by("category").aggregate(total=t.amount.sum())
print(expr.sql())
```

### Ibis 适合生产级 ETL 管道吗？

是的，Ibis 正越来越多地用于生产 ETL 和分析管道。其 Apache-2.0 许可证、ibis-project 组织的积极维护以及不断增长的社区使其成为企业部署的安全选择。无需更改代码即可切换后端的能力意味着您的本地开发管道可以在 DuckDB 上运行，而生产环境在 BigQuery 或 Snowflake 上运行 —— 使用完全相同的 Ibis 代码。

### Ibis 如何处理后端特定的 SQL 方言？

Ibis 自动抽象掉方言差异。当您编写 Ibis 表达式时，库会处理向 PostgreSQL 语法、BigQuery 语法、Snowflake 语法或您的目标后端所需的任何方言的转换。您编写一段 Python 代码，Ibis 负责其余部分。

```python
# 同一表达式为每个后端编译为不同的 SQL
expr = t.mutate(year=t.date.year(), month=t.date.month())

# PostgreSQL: EXTRACT(YEAR FROM "date")
# BigQuery: EXTRACT(YEAR FROM `date`)
# DuckDB: EXTRACT(YEAR FROM "date")
# Ibis 自动处理所有这些
```

### pandas 用户的学习曲线如何？

对于 pandas 用户来说，学习曲线出奇地平缓。大多数核心操作 —— `filter`、`select`、`group_by`、`aggregate`、`order_by`、`mutate`、`join` —— 使用熟悉的名称和语义。主要需要调整的是理解惰性求值：表达式在您调用 `.execute()` 之前不会执行。大多数有经验的 pandas 用户在几个小时内就能熟练使用 Ibis。

---



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 最终思考

Ibis 代表了 Python 数据分析的范式转变。通过提供统一的、兼容 pandas 的 DataFrame API，将其编译为 20 多个后端的优化 SQL，它消除了开发者生产力和查询性能之间的历史权衡。惰性求值、类型安全表达式和可移植后端支持的组合使其成为任何大规模数据专业人员的重要工具。

在 2026 年，随着数据量持续爆炸式增长，组织将其分析分布在多个数据库系统上，Ibis 提供了一个在任何地方都能工作的单一、一致的接口。无论您是使用 DuckDB 进行本地开发的数据科学家，还是在 BigQuery 中查询 PB 级数据的工程师，Ibis 都能提供相同优雅的 Python API —— 编译为尽可能快的 SQL，在您的数据所在之处精确运行。

如果您还没有将 Ibis 添加到您的数据工具包中，现在是时候了。从 DuckDB 开始本地开发，您会发现您的分析工作流在一夜之间变得更快、更可移植、更易于维护。
