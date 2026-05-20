---
title: 'vanna-ai-sql-generation'
description: '{''en'': ''Explore Vanna AI, the open-source Python library that trains on your database schema to generate SQL from natural language with 90%+ accuracy. Features self-hosting, Jupyter integration, SQL validation, multiple LLM backends, and privacy-first design.'', ''zh'': ''探索 Vanna AI，这款基于你的数据库 Schema 训练以 90%+ 准确率从自然语言生成 SQL 的开源 Python 库。支持自托管、Jupyter 集成、SQL 验证、多 LLM 后端和隐私优先设计。'', ''ko'': ''데이터베이스 스키마에서 학습하여 90%+ 정확도로 자연어에서 SQL을 생성하는 오픈소스 Python 라이브러리 Vanna AI를 살펴 보세요. 자체 호스팅, Jupyter 통합, SQL 검증, 다중 LLM 백엔드, 개인정보 보호 중심 설계를 제공합니다.'', ''vi'': ''Khám phá Vanna AI, thư viện Python mã nguồn mở được huấn luyện trên schema cơ sở dữ liệu của bạn để tạo SQL từ ngôn ngữ tự nhiên với độ chính xác 90%+. Có tính năng tự lưu trữ, tích hợp Jupyter, xác thực SQL, nhiều backend LLM, và thiết kế ưu tiên quyền riêng tư.''}'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
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
categories: ['llm-frameworks']
tags: ['Vanna AI']
aliases:
- /zh/posts/vanna-ai-sql-generation/
---

{{</* resource-info */>}}

使用自然语言与数据库交互的能力长期以来一直是数据分析领域的圣杯。每天，无数时间被浪费在将业务问题转化为 SQL 查询上 — 这个过程需要对数据库 Schema、表关系和 SQL 语法有深入的了解。2026年，这一瓶颈正在迅速消融，这要归功于 **Vanna AI** — 一款基于你的数据库 Schema 训练、以超过 90% 的准确率从纯英文生成生产级 SQL 的开源 Python 库。

凭借超过 18,000 个 GitHub Star 和 MIT 许可证，Vanna AI 已成为追求准确性和数据隐私的团队的首选 Text-to-SQL 解决方案。与将 SQL 生成视为另一种翻译任务的通用 LLM 方法不同，Vanna 使用了专为数据库查询设计的 **检索增强生成（RAG）** 架构。它学习你的 Schema、理解你的业务逻辑，并生成实际可运行的 SQL — 经过验证、优化，且可直接用于生产环境。

在本综合指南中，我们将详细介绍关于 Vanna AI 的一切：从安装和 Schema 训练到高级 SQL 生成、验证和集成到分析工作流。无论你是想用英文提问的数据分析师，还是为数据平台构建自然语言界面的工程师，Vanna AI 都能提供你所需的工具，让 Text-to-SQL 成为现实。

---

## 什么是 Vanna AI？自然语言遇见 SQL

Vanna AI 是一款弥合人类语言和结构化查询语言之间差距的开源 Python 库。其核心是一个专为 SQL 生成而构建的 **检索增强生成（RAG）** 框架。与偶尔会产生表名幻觉或虚构列引用的通用 LLM 聊天机器人不同，Vanna 在你实际的数据库 Schema 上进行训练 — 学习你的表、列、关系，甚至你组织的命名约定。

工作流程非常优雅：

1. **连接** Vanna 到你的数据库
2. 在你的 Schema 上**训练**它（DDL 语句、文档、示例查询）
3. 用自然语言**提问**
4. 接收准确、可执行的 SQL

```python
import vanna as vn
from vanna.remote import VannaDefault

# 使用你的 API 密钥初始化 Vanna
vn = VannaDefault(model="my-model", api_key="vn-...")

# 连接到你的数据库
vn.connect_to_postgres(host="localhost", dbname="analytics",
                       user="analyst", password="secret", port=5432)

# 在你的 Schema 上训练
vn.train(ddl="""
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    amount DECIMAL(10,2),
    sale_date TIMESTAMP,
    region VARCHAR(50)
);
""")

# 用纯英文提问
sql = vn.generate_sql("What are the top 5 regions by total sales in 2026?")
print(sql)
```

生成的 SQL 不仅在语法上正确，而且在语义上准确，引用了你实际 Schema 中的正确表、列和关系。

---

## 为什么 Vanna AI 在 2026 年至关重要

近年来，大型语言模型的爆发为自然语言界面创造了巨大的机会。然而，通用 LLM 在 SQL 生成方面面临几个关键挑战：它们会产生 Schema 元素幻觉、忽略数据库特定的语法，并且对实际数据模型一无所知。将原始数据发送到第三方 API 端点还会引发严重的隐私和合规性问题。

Vanna AI 直面所有这些挑战：

- **Schema 感知生成**：Vanna 学习你的特定 Schema，消除幻觉
- **隐私优先设计**：你的数据永远不会离开你的基础设施，除非你选择这样做
- **自托管选项**：使用开源 LLM 在本地运行一切
- **SQL 验证**：每个生成的查询在返回之前都会针对你的数据库进行验证
- **多 LLM 后端**：使用 OpenAI、Anthropic、Google 或本地模型如 Ollama

```python
# Vanna 支持多个 LLM 后端
from vanna.ollama import Ollama
from vanna.chromadb import ChromaDB_VectorStore

class MyVanna(ChromaDB_VectorStore, Ollama):
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        Ollama.__init__(self, config={"model": "llama3"})

# 完全本地、自托管的设置
vn = MyVanna()
vn.connect_to_sqlite("my_database.db")
vn.train(ddl="SELECT sql FROM sqlite_master WHERE type='table';")
```

2026年，随着组织应对日益复杂的数据 Schema 和更严格的合规要求，Vanna 的方法 — 在 Schema 上训练而不是将数据发送到云端 — 代表了安全、准确的 Text-to-SQL 的黄金标准。

---

## 安装和配置 Vanna AI

Vanna 设计为易于安装和配置，具有合理的默认值，可让你快速上手。

```bash
# 安装 Vanna 核心
pip install vanna

# 安装特定 LLM 后端支持
pip install "vanna[openai]"
pip install "vanna[anthropic]"
pip install "vanna[google]"
pip install "vanna[ollama]"

# 安装数据库驱动
pip install "vanna[postgres]"
pip install "vanna[mysql]"
pip install "vanna[snowflake]"
pip install "vanna[bigquery]"

# 安装全部
pip install "vanna[all]"
```

最常见的设置快速配置：

```python
from vanna.remote import VannaDefault

# 使用 Vanna 的托管服务（最简单的设置）
vn = VannaDefault(
    model="my-database-model",
    api_key="vn-your-api-key"
)

# 连接到 PostgreSQL
vn.connect_to_postgres(
    host="db.company.com",
    dbname="analytics",
    user="analyst",
    password="secure-password",
    port=5432
)
```

对于使用本地 LLM 的完全自托管设置：

```python
from vanna.ollama import Ollama
from vanna.chromadb import ChromaDB_VectorStore

class LocalVanna(ChromaDB_VectorStore, Ollama):
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        Ollama.__init__(self, config={"model": "codellama:13b"})

vn = LocalVanna()
vn.connect_to_postgres(host="localhost", dbname="sales",
                       user="admin", password="admin", port=5432)
```

---

## 在数据库 Schema 上训练 Vanna

训练是 Vanna 真正闪耀的地方。你对 Schema 训练 Vanna 越多，其 SQL 生成就越准确。你可以提供三种主要类型的训练数据。

### 使用 DDL 语句训练

最基本的训练方法是提供数据库的 DDL（数据定义语言）— 定义 Schema 的 CREATE TABLE 语句。

```python
# 使用单个 DDL 语句训练
vn.train(ddl="""
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    segment VARCHAR(50)
);
""")

vn.train(ddl="""
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    total_amount DECIMAL(12,2),
    order_date TIMESTAMP,
    status VARCHAR(20)
);
""")

vn.train(ddl="""
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id),
    product_name VARCHAR(255),
    quantity INT,
    unit_price DECIMAL(10,2)
);
""")
```

### 使用 Schema 自动发现训练

对于大型数据库，手动编写 DDL 是不现实的。Vanna 可以自动从你的数据库中提取 Schema 信息。

```python
# PostgreSQL：从 information_schema 提取 Schema
import psycopg2

conn = psycopg2.connect(
    host="localhost", dbname="analytics",
    user="analyst", password="secret"
)
cursor = conn.cursor()

# 获取所有表定义
cursor.execute("""
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public';
""")
tables = cursor.fetchall()

for (table_name,) in tables:
    cursor.execute(f"""
        SELECT column_name, data_type, is_nullable
        FROM information_schema.columns
        WHERE table_name = '{table_name}';
    """)
    columns = cursor.fetchall()
    ddl = f"CREATE TABLE {table_name} (\n"
    ddl += ",\n".join([
        f"    {col[0]} {col[1]}{'' if col[2] == 'YES' else ' NOT NULL'}"
        for col in columns
    ])
    ddl += "\n);"
    vn.train(ddl=ddl)

conn.close()
```

### 使用文档和业务逻辑训练

除了原始 Schema 之外，你还可以在业务上下文上训练 Vanna — 帮助它理解你的列的实际含义。

```python
# 使用文档训练
vn.train(documentation="""
The 'sales' table records all completed transactions.
The 'amount' column is in USD and includes tax.
The 'region' column uses standard US Census regions:
Northeast, Midwest, South, and West.
A 'high_value_customer' is anyone with lifetime purchases > $10,000.
""")

# 使用示例 SQL 查询训练
vn.train(sql="""
SELECT region, SUM(amount) as total_sales, COUNT(*) as order_count
FROM sales
WHERE sale_date >= '2026-01-01'
GROUP BY region
ORDER BY total_sales DESC;
""")

vn.train(sql="""
SELECT c.name, COUNT(o.id) as order_count, SUM(o.total_amount) as lifetime_value
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.id, c.name
HAVING SUM(o.total_amount) > 10000;
""")
```

### 使用问题-SQL 对训练

为了获得最大准确性，提供自然语言问题及其对应 SQL 查询的配对。

```python
# 黄金标准训练数据
vn.train(
    question="What are the top 10 customers by lifetime value?",
    sql="""
    SELECT c.name, SUM(o.total_amount) as lifetime_value
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.id, c.name
    ORDER BY lifetime_value DESC
    LIMIT 10;
    """
)

vn.train(
    question="How many orders were placed each month in 2026?",
    sql="""
    SELECT DATE_TRUNC('month', order_date) as month, COUNT(*) as order_count
    FROM orders
    WHERE order_date >= '2026-01-01' AND order_date < '2027-01-01'
    GROUP BY month
    ORDER BY month;
    """
)
```

---

## 从自然语言生成 SQL

经过训练后，Vanna 能够以惊人的准确性从自然语言问题生成 SQL。`generate_sql` 方法是主要接口。

```python
# 简单问题
sql = vn.generate_sql("Show me all customers from the West region")
print(sql)
# 输出: SELECT * FROM customers WHERE region = 'West';

# 聚合查询
sql = vn.generate_sql("What is the average order value by customer segment?")
print(sql)
# 输出: SELECT c.segment, AVG(o.total_amount) as avg_order_value
#         FROM customers c JOIN orders o ON c.id = o.customer_id
#         GROUP BY c.segment;

# 复杂多表连接
sql = vn.generate_sql(
    "Find the top 5 products by revenue in Q2 2026, "
    "including how many unique customers bought each product"
)
print(sql)

# 基于时间的筛选
sql = vn.generate_sql(
    "Compare monthly sales between 2025 and 2026, "
    "showing year-over-year growth percentage"
)
print(sql)
```

Vanna 还支持生成具有特定约束或模式的 SQL：

```python
# 生成带有解释的 SQL
sql, explanation = vn.generate_sql(
    "Which customers haven't placed an order in the last 90 days?",
    explain=True
)
print(f"SQL: {sql}")
print(f"Explanation: {explanation}")

# 生成 SQL 并运行它
result_df = vn.ask("What are the monthly sales trends?")
print(result_df)

# ask() 方法生成 SQL、验证它、执行它，
# 并返回一个 pandas DataFrame — 全部在一行调用中完成
```

---

## SQL 验证和错误处理

Vanna 的突出功能之一是 **自动 SQL 验证**。在将查询返回给你之前，Vanna 可以检查它是否实际在你的数据库上运行，捕获语法错误和 Schema 不匹配。

```python
# 启用自动验证
vn = VannaDefault(model="my-model", api_key="vn-...", 
                  config={"validate_sql": True})

# 无效查询被捕获并纠正
try:
    sql = vn.generate_sql("Show me the top 10 products by revenue")
    print(f"Validated SQL: {sql}")
except Exception as e:
    print(f"Validation failed: {e}")
    # Vanna 将尝试修复并重新生成
    sql = vn.generate_sql_with_retry(
        "Show me the top 10 products by revenue",
        max_retries=3
    )
```

Vanna 还可以处理引用先前上下文的后续问题：

```python
# 第一个问题
result1 = vn.ask("What were total sales in 2026?")

# 后续问题（Vanna 保持上下文）
result2 = vn.ask("Break that down by region")
# 生成: SELECT region, SUM(amount) FROM sales 
#            WHERE sale_date >= '2026-01-01' GROUP BY region

# 另一个后续问题
result3 = vn.ask("Now show only regions with more than $1M in sales")
# 生成: SELECT region, SUM(amount) as total 
#            FROM sales WHERE sale_date >= '2026-01-01' 
#            GROUP BY region HAVING SUM(amount) > 1000000
```

---

## 高级功能和自定义

Vanna 为高级用户和生产部署提供了广泛的自定义选项。

### 自定义提示模板

```python
# 覆盖默认提示模板
vn.set_prompt_template("""
You are an expert SQL analyst. Given the following database schema,
generate a PostgreSQL-compatible query to answer the user's question.

Schema:
{schema}

User Question: {question}

Generate only the SQL query, with no additional explanation.
""")

sql = vn.generate_sql("List all high-value customers")
```

### 使用多个数据库

```python
# 为不同的数据库创建单独的 Vanna 实例
vn_sales = VannaDefault(model="sales-model", api_key="vn-...")
vn_sales.connect_to_postgres(host="sales-db", dbname="sales")

vn_hr = VannaDefault(model="hr-model", api_key="vn-...")
vn_hr.connect_to_mysql(host="hr-db", dbname="human_resources")

# 查询适当的数据库
sales_sql = vn_sales.generate_sql("Total revenue by quarter")
hr_sql = vn_hr.generate_sql("Employee count by department")
```

### 使用自定义向量存储

```python
from vanna.pinecone import Pinecone_VectorStore
from vanna.openai import OpenAI_Chat

class PineconeVanna(Pinecone_VectorStore, OpenAI_Chat):
    def __init__(self, config=None):
        Pinecone_VectorStore.__init__(self, config=config)
        OpenAI_Chat.__init__(self, config=config)

vn = PineconeVanna(config={
    "api_key": "your-openai-key",
    "pinecone_api_key": "your-pinecone-key",
    "pinecone_index": "vanna-index"
})
```

---

## Jupyter 集成和交互式工作流

Vanna 在 Jupyter 笔记本中表现出色，提供丰富的交互式小部件和可视化功能。

```python
from vanna.remote import VannaDefault
import vanna as vn

vn = VannaDefault(model="my-model", api_key="vn-...")
vn.connect_to_postgres(host="localhost", dbname="analytics",
                       user="analyst", password="secret")

# 在 Jupyter 中启动交互式聊天界面
vn.ask("What are the top selling products?")
```

`ask()` 方法在 Jupyter 中返回丰富的输出，包括生成的 SQL、解释和结果表。为了获得完整的交互式体验：

```python
# 在 Jupyter 中启动交互式 Web UI
from vanna.flask import VannaFlaskApp

app = VannaFlaskApp(vn)
app.run()
```

Vanna 还可以在适当时自动生成可视化：

```python
# 生成 SQL 并自动创建图表
vn.ask("Plot monthly sales trends for 2026")

# 生成 SQL，执行它，并自动创建折线图
# 从时间序列结果
```

---

## Vanna AI 架构和隐私模型

理解 Vanna 的架构是在生产环境中安全部署它的关键。

```
┌─────────────────────────────────────────────────────────────┐
│                    Vanna AI 架构                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   用户问题  ──▶  向量存储 (Schema/示例)                     │
│       │                       │                            │
│       │                       ▼                            │
│       │              相关上下文                             │
│       │              通过 RAG 检索                         │
│       │                       │                            │
│       ▼                       ▼                            │
│   ┌──────────────────────────────────────┐                │
│   │        LLM 后端                        │                │
│   │  (OpenAI / Anthropic / Ollama / ...) │                │
│   │                                      │                │
│   │  提示: 问题 + Schema 上下文           │                │
│   │  输出: 生成的 SQL                     │                │
│   └──────────────────────────────────────┘                │
│                       │                                     │
│                       ▼                                     │
│              SQL 验证                                       │
│                       │                                     │
│                       ▼                                     │
│              针对数据库执行                                 │
│                       │                                     │
│                       ▼                                     │
│               返回结果                                       │
└─────────────────────────────────────────────────────────────┘
```

隐私模型的工作原理如下：

```python
# 隐私优先配置（推荐）
from vanna.ollama import Ollama
from vanna.chromadb import ChromaDB_VectorStore

class PrivateVanna(ChromaDB_VectorStore, Ollama):
    """完全自托管。零数据离开你的网络。"""
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        Ollama.__init__(self, config={"model": "llama3:70b"})

vn = PrivateVanna()
vn.connect_to_postgres(host="internal-db", dbname="analytics",
                       user="readonly", password="secret")

# Schema 元数据存储在本地 ChromaDB 中
# LLM 通过 Ollama 本地运行
# 数据库查询在内部数据库上执行
# 数据永远不会到达外部 API
```

---

## 基准测试和准确性

Vanna 的准确性在很大程度上取决于训练数据的质量和数量。以下是 2026 年观察到的典型性能特征：

```python
# 准确性评估脚本
import pandas as pd

test_cases = [
    {
        "question": "Total sales in 2026",
        "expected_sql": "SELECT SUM(amount) FROM sales WHERE sale_date >= '2026-01-01'"
    },
    {
        "question": "Top 5 customers by order count",
        "expected_sql": """
            SELECT customer_id, COUNT(*) as order_count 
            FROM orders GROUP BY customer_id ORDER BY order_count DESC LIMIT 5
        """
    },
    {
        "question": "Average order value by region",
        "expected_sql": """
            SELECT region, AVG(total_amount) 
            FROM orders GROUP BY region
        """
    }
]

correct = 0
for test in test_cases:
    generated = vn.generate_sql(test["question"])
    # 语义比较（标准化）
    if normalize_sql(generated) == normalize_sql(test["expected_sql"]):
        correct += 1

accuracy = correct / len(test_cases) * 100
print(f"准确性: {accuracy:.1f}%")
```

通过全面的训练（DDL + 文档 + 示例查询），Vanna 持续实现：

- 常见分析查询的 **90-95% 准确性**
- 复杂多表连接的 **85-90% 准确性**
- 需要业务上下文的查询的 **80-85% 准确性**
- 提供问题-SQL 对作为训练数据时接近 **100% 准确性**

高准确性的关键在于彻底训练。一个训练充分的 Vanna 实例，具有 50+ 条 DDL 语句、20+ 条示例查询和相关文档，其表现显著优于通用 LLM 方法。

---

## 常见问题解答（FAQ）

### Vanna AI 是完全免费的吗？

是的，Vanna AI 是 MIT 许可证下的开源软件，可以免费使用。核心库、所有集成和基于 RAG 的训练系统均可免费使用。Vanna 还为小型项目提供免费层的托管云服务，企业功能如团队协作和高级分析则有付费计划。使用本地 LLM（通过 Ollama）和本地向量存储（通过 ChromaDB）的自托管选项完全免费，没有使用限制。

```python
# 免费、完全自托管的设置
from vanna.ollama import Ollama
from vanna.chromadb import ChromaDB_VectorStore

class FreeVanna(ChromaDB_VectorStore, Ollama):
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        Ollama.__init__(self, config={"model": "llama3"})
```

### Vanna 如何处理 Schema 变更？

当你的数据库 Schema 变更时，你需要使用更新的 DDL 语句重新训练 Vanna。推荐的方法是对训练数据进行版本控制，并设置一个自动化管道，在部署时提取最新的 Schema 并重新训练 Vanna。

```python
# 自动化重新训练管道
import subprocess

# 提取最新 Schema
result = subprocess.run(
    ["pg_dump", "--schema-only", "mydb"],
    capture_output=True, text=True
)
new_ddl = result.stdout

# 清除旧训练数据并重新训练
vn.remove_training_data()
vn.train(ddl=new_ddl)
```

### 我可以在非英语语言中使用 Vanna 吗？

是的，Vanna 支持多种语言的自然语言问题。LLM 后端处理翻译到 SQL 生成的过程。你可以用你喜欢的语言训练 Vanna 文档和示例。

```python
# 使用中文文档训练
vn.train(documentation="""
销售额表记录所有完成的交易。
amount 列单位为美元，含税。
大客户定义为累计购买超过 $10,000 的客户。
""")

sql = vn.generate_sql("显示2026年每个区域的总销售额")
```

### Vanna 支持哪些数据库？

Vanna 通过其灵活的连接系统支持几乎所有主要数据库：PostgreSQL、MySQL、SQLite、SQL Server、Snowflake、BigQuery、Redshift、Oracle、DuckDB、ClickHouse 以及任何具有 Python DB-API 驱动程序的数据库。自定义连接器也可以为专门的系统实现。

```python
# SQLite
vn.connect_to_sqlite("mydb.sqlite")

# Snowflake
vn.connect_to_snowflake(
    account="myaccount", username="user",
    password="pass", database="analytics"
)

# BigQuery
vn.connect_to_bigquery(project_id="my-project")

# DuckDB
vn.connect_to_duckdb("mydb.duckdb")
```

### 如何提高 Vanna 在我特定用例中的准确性？

提高准确性的最有效方法是通过全面的训练。按照以下训练数据质量层次结构进行：

1. **问题-SQL 对**（最高影响 — 接近 100% 准确性）
2. **示例 SQL 查询**（高影响 — 教授模式）
3. **业务文档**（中等影响 — 添加上下文）
4. **DDL 语句**（基础 — 消除幻觉）

```python
# 最大准确性训练方案
vn.train(ddl=all_schema_ddl)
vn.train(documentation=business_context)
for example in curated_sql_examples:
    vn.train(sql=example)
for qa in historical_question_sql_pairs:
    vn.train(question=qa["question"], sql=qa["sql"])
```

---



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 最终思考

Vanna AI 代表了在普及数据库访问方面的重大飞跃。通过将现代大型语言模型的力量与专为 SQL 生成而构建的 RAG 架构相结合，它提供了一种使自然语言查询在现实世界生产环境中实用的准确性水平。通过适当训练实现的 90%+ 准确性，结合其隐私优先设计和自托管功能，使 Vanna 成为希望在不损害数据安全的情况下让团队获得 Text-to-SQL 能力的组织的首选工具。

2026年，随着数据分析师和数据库专家之间的差距继续缩小，Vanna AI 站在最前沿 — 将"我们各区域第二季度的销售额是多少？"在几秒钟内转化为可执行的 SQL，而不是几分钟。对于任何希望减少 SQL 瓶颈并让人们在思考所用的语言中提问的团队来说，Vanna AI 是一项立即就能带来回报的投资。
