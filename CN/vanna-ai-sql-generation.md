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
- /posts/vanna-ai-sql-generation/
---

{{</* resource-info */>}}

The ability to interact with databases using natural language has long been the holy grail of data analytics. Every day, countless hours are lost translating business questions into SQL queries — a process that requires deep knowledge of database schemas, table relationships, and SQL syntax. In 2026, this bottleneck is rapidly dissolving thanks to **Vanna AI**, an open-source Python library that trains on your database schema and generates production-ready SQL from plain English with over 90% accuracy.

With more than 18,000 GitHub stars and an MIT license, Vanna AI has emerged as the leading text-to-SQL solution for teams that demand both accuracy and data privacy. Unlike generic LLM approaches that treat SQL generation as just another translation task, Vanna uses a **Retrieval-Augmented Generation (RAG)** architecture specifically designed for database querying. It learns your schema, understands your business logic, and produces SQL that actually runs — validated, optimized, and ready for production.

In this comprehensive guide, we will walk through everything you need to know about Vanna AI: from installation and schema training to advanced SQL generation, validation, and integration into your analytics workflows. Whether you are a data analyst who wants to ask questions in English, or an engineer building natural language interfaces for your data platform, Vanna AI provides the tools you need to make text-to-SQL a reality.

---

## What Is Vanna AI? Natural Language Meets SQL

Vanna AI is an open-source Python library that bridges the gap between human language and structured query language. At its core, Vanna is a ** Retrieval-Augmented Generation (RAG) ** framework built specifically for SQL generation. Unlike generic LLM chatbots that occasionally hallucinate table names or invent column references, Vanna trains on your actual database schema — learning your tables, columns, relationships, and even your organization's naming conventions.

The workflow is elegantly simple:

1. **Connect** Vanna to your database
2. **Train** it on your schema (DDL statements, documentation, sample queries)
3. **Ask** questions in natural language
4. **Receive** accurate, executable SQL

```python
import vanna as vn
from vanna.remote import VannaDefault

# Initialize Vanna with your API key
vn = VannaDefault(model="my-model", api_key="vn-...")

# Connect to your database
vn.connect_to_postgres(host="localhost", dbname="analytics",
                       user="analyst", password="secret", port=5432)

# Train on your schema
vn.train(ddl="""
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    amount DECIMAL(10,2),
    sale_date TIMESTAMP,
    region VARCHAR(50)
);
""")

# Ask a question in plain English
sql = vn.generate_sql("What are the top 5 regions by total sales in 2026?")
print(sql)
```

The generated SQL is not just syntactically correct — it is semantically accurate, referencing the correct tables, columns, and relationships from your actual schema.

---

## Why Vanna AI Matters in 2026

The explosion of Large Language Models in recent years has created enormous opportunities for natural language interfaces. However, generic LLMs struggle with SQL generation for several critical reasons: they hallucinate schema elements, ignore database-specific syntax, and have no awareness of your actual data model. Sending your raw data to third-party API endpoints also raises serious privacy and compliance concerns.

Vanna AI addresses all of these challenges head-on:

- **Schema-Aware Generation**: Vanna learns your specific schema, eliminating hallucination
- **Privacy-First Design**: Your data never leaves your infrastructure unless you choose otherwise
- **Self-Hosted Option**: Run everything locally with open-source LLMs
- **SQL Validation**: Every generated query is validated against your database before being returned
- **Multiple LLM Backends**: Use OpenAI, Anthropic, Google, or local models like Ollama

```python
# Vanna supports multiple LLM backends
from vanna.ollama import Ollama
from vanna.chromadb import ChromaDB_VectorStore

class MyVanna(ChromaDB_VectorStore, Ollama):
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        Ollama.__init__(self, config={"model": "llama3"})

# Fully local, self-hosted setup
vn = MyVanna()
vn.connect_to_sqlite("my_database.db")
vn.train(ddl="SELECT sql FROM sqlite_master WHERE type='table';")
```

In 2026, as organizations grapple with increasingly complex data schemas and stricter compliance requirements, Vanna's approach — training on schema rather than sending data to the cloud — represents the gold standard for secure, accurate text-to-SQL.

---

## Installing and Configuring Vanna AI

Vanna is designed to be easy to install and configure, with sensible defaults that get you productive quickly.

```bash
# Install Vanna core
pip install vanna

# Install with specific LLM backend support
pip install "vanna[openai]"
pip install "vanna[anthropic]"
pip install "vanna[google]"
pip install "vanna[ollama]"

# Install with database drivers
pip install "vanna[postgres]"
pip install "vanna[mysql]"
pip install "vanna[snowflake]"
pip install "vanna[bigquery]"

# Install everything
pip install "vanna[all]"
```

Quick configuration for the most common setup:

```python
from vanna.remote import VannaDefault

# Use Vanna's hosted service (easiest setup)
vn = VannaDefault(
    model="my-database-model",
    api_key="vn-your-api-key"
)

# Connect to PostgreSQL
vn.connect_to_postgres(
    host="db.company.com",
    dbname="analytics",
    user="analyst",
    password="secure-password",
    port=5432
)
```

For a fully self-hosted setup with local LLMs:

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

## Training Vanna on Your Database Schema

Training is where Vanna truly shines. The more you train Vanna on your schema, the more accurate its SQL generation becomes. There are three primary types of training data you can provide.

### Training with DDL Statements

The most fundamental training method is providing your database's DDL (Data Definition Language) — the CREATE TABLE statements that define your schema.

```python
# Train with individual DDL statements
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

### Training with Schema Auto-Discovery

For large databases, manually writing DDL is impractical. Vanna can automatically extract schema information from your database.

```python
# PostgreSQL: extract schema from information_schema
import psycopg2

conn = psycopg2.connect(
    host="localhost", dbname="analytics",
    user="analyst", password="secret"
)
cursor = conn.cursor()

# Get all table definitions
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

### Training with Documentation and Business Logic

Beyond raw schema, you can train Vanna on business context — helping it understand what your columns actually mean.

```python
# Train with documentation
vn.train(documentation="""
The 'sales' table records all completed transactions.
The 'amount' column is in USD and includes tax.
The 'region' column uses standard US Census regions:
Northeast, Midwest, South, and West.
A 'high_value_customer' is anyone with lifetime purchases > $10,000.
""")

# Train with example SQL queries
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

### Training with Question-SQL Pairs

For maximum accuracy, provide pairs of natural language questions and their corresponding SQL queries.

```python
# Gold-standard training data
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

## Generating SQL from Natural Language

Once trained, Vanna can generate SQL from natural language questions with remarkable accuracy. The `generate_sql` method is the primary interface.

```python
# Simple questions
sql = vn.generate_sql("Show me all customers from the West region")
print(sql)
# Output: SELECT * FROM customers WHERE region = 'West';

# Aggregation queries
sql = vn.generate_sql("What is the average order value by customer segment?")
print(sql)
# Output: SELECT c.segment, AVG(o.total_amount) as avg_order_value
#         FROM customers c JOIN orders o ON c.id = o.customer_id
#         GROUP BY c.segment;

# Complex multi-table joins
sql = vn.generate_sql(
    "Find the top 5 products by revenue in Q2 2026, "
    "including how many unique customers bought each product"
)
print(sql)

# Time-based filtering
sql = vn.generate_sql(
    "Compare monthly sales between 2025 and 2026, "
    "showing year-over-year growth percentage"
)
print(sql)
```

Vanna also supports generating SQL with specific constraints or patterns:

```python
# Generate SQL with explanation
sql, explanation = vn.generate_sql(
    "Which customers haven't placed an order in the last 90 days?",
    explain=True
)
print(f"SQL: {sql}")
print(f"Explanation: {explanation}")

# Generate SQL and also run it
result_df = vn.ask("What are the monthly sales trends?")
print(result_df)

# The ask() method generates SQL, validates it, executes it,
# and returns a pandas DataFrame — all in one call
```

---

## SQL Validation and Error Handling

One of Vanna's standout features is its **automatic SQL validation**. Before returning a query to you, Vanna can check that it actually runs against your database, catching syntax errors and schema mismatches.

```python
# Enable automatic validation
vn = VannaDefault(model="my-model", api_key="vn-...", 
                  config={"validate_sql": True})

# Invalid queries are caught and corrected
try:
    sql = vn.generate_sql("Show me the top 10 products by revenue")
    print(f"Validated SQL: {sql}")
except Exception as e:
    print(f"Validation failed: {e}")
    # Vanna will attempt to fix and regenerate
    sql = vn.generate_sql_with_retry(
        "Show me the top 10 products by revenue",
        max_retries=3
    )
```

Vanna can also handle follow-up questions that reference previous context:

```python
# First question
result1 = vn.ask("What were total sales in 2026?")

# Follow-up question (Vanna maintains context)
result2 = vn.ask("Break that down by region")
# Generates: SELECT region, SUM(amount) FROM sales 
#            WHERE sale_date >= '2026-01-01' GROUP BY region

# Another follow-up
result3 = vn.ask("Now show only regions with more than $1M in sales")
# Generates: SELECT region, SUM(amount) as total 
#            FROM sales WHERE sale_date >= '2026-01-01' 
#            GROUP BY region HAVING SUM(amount) > 1000000
```

---

## Advanced Features and Customization

Vanna offers extensive customization options for advanced users and production deployments.

### Custom Prompt Templates

```python
# Override the default prompt template
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

### Working with Multiple Databases

```python
# Create separate Vanna instances for different databases
vn_sales = VannaDefault(model="sales-model", api_key="vn-...")
vn_sales.connect_to_postgres(host="sales-db", dbname="sales")

vn_hr = VannaDefault(model="hr-model", api_key="vn-...")
vn_hr.connect_to_mysql(host="hr-db", dbname="human_resources")

# Query the appropriate database
sales_sql = vn_sales.generate_sql("Total revenue by quarter")
hr_sql = vn_hr.generate_sql("Employee count by department")
```

### Using Custom Vector Stores

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

## Jupyter Integration and Interactive Workflows

Vanna shines in Jupyter notebooks, offering rich interactive widgets and visualization capabilities.

```python
from vanna.remote import VannaDefault
import vanna as vn

vn = VannaDefault(model="my-model", api_key="vn-...")
vn.connect_to_postgres(host="localhost", dbname="analytics",
                       user="analyst", password="secret")

# Launch the interactive chat interface in Jupyter
vn.ask("What are the top selling products?")
```

The `ask()` method in Jupyter returns rich output including the generated SQL, explanation, and results table. For a full interactive experience:

```python
# Launch the interactive web UI within Jupyter
from vanna.flask import VannaFlaskApp

app = VannaFlaskApp(vn)
app.run()
```

Vanna also generates visualizations automatically when appropriate:

```python
# Generate SQL and auto-create chart
vn.ask("Plot monthly sales trends for 2026")

# Generates SQL, executes it, and creates a line chart
# from the time-series results automatically
```

---

## Vanna AI Architecture and Privacy Model

Understanding Vanna's architecture is key to deploying it securely in production environments.

```
┌─────────────────────────────────────────────────────────────┐
│                    Vanna AI Architecture                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   User Question  ──▶  Vector Store (Schema/Examples)       │
│       │                       │                            │
│       │                       ▼                            │
│       │              Relevant Context                      │
│       │              Retrieved via RAG                     │
│       │                       │                            │
│       ▼                       ▼                            │
│   ┌──────────────────────────────────────┐                │
│   │        LLM Backend                   │                │
│   │  (OpenAI / Anthropic / Ollama / ...) │                │
│   │                                      │                │
│   │  Prompt: Question + Schema Context   │                │
│   │  Output: Generated SQL               │                │
│   └──────────────────────────────────────┘                │
│                       │                                     │
│                       ▼                                     │
│              SQL Validation                                 │
│                       │                                     │
│                       ▼                                     │
│              Execute Against DB                             │
│                       │                                     │
│                       ▼                                     │
│               Return Results                                │
└─────────────────────────────────────────────────────────────┘
```

The privacy model works as follows:

```python
# Privacy-First Configuration (Recommended)
from vanna.ollama import Ollama
from vanna.chromadb import ChromaDB_VectorStore

class PrivateVanna(ChromaDB_VectorStore, Ollama):
    """Fully self-hosted. Zero data leaves your network."""
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        Ollama.__init__(self, config={"model": "llama3:70b"})

vn = PrivateVanna()
vn.connect_to_postgres(host="internal-db", dbname="analytics",
                       user="readonly", password="secret")

# Schema metadata is stored locally in ChromaDB
# LLM runs locally via Ollama
# Database queries execute against your internal database
# No data ever reaches external APIs
```

---

## Benchmarks and Accuracy

Vanna's accuracy depends heavily on the quality and quantity of training data. Here are typical performance characteristics observed in 2026:

```python
# Accuracy evaluation script
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
    # Semantic comparison (normalized)
    if normalize_sql(generated) == normalize_sql(test["expected_sql"]):
        correct += 1

accuracy = correct / len(test_cases) * 100
print(f"Accuracy: {accuracy:.1f}%")
```

With comprehensive training (DDL + documentation + example queries), Vanna consistently achieves:

- **90-95% accuracy** on common analytical queries
- **85-90% accuracy** on complex multi-table joins
- **80-85% accuracy** on queries requiring business context
- Near **100% accuracy** when question-SQL pairs are provided as training data

The key to high accuracy is thorough training. A well-trained Vanna instance with 50+ DDL statements, 20+ example queries, and relevant documentation outperforms generic LLM approaches by a significant margin.

---

## Frequently Asked Questions (FAQ)

### Is Vanna AI completely free to use?

Yes, Vanna AI is open-source under the MIT license and free to use. The core library, all integrations, and the RAG-based training system are available at no cost. Vanna also offers a hosted cloud service with a free tier for small projects, with paid plans for enterprise features like team collaboration and advanced analytics. The self-hosted option using local LLMs (via Ollama) and local vector stores (via ChromaDB) is entirely free with no usage limits.

```python
# Free, fully self-hosted setup
from vanna.ollama import Ollama
from vanna.chromadb import ChromaDB_VectorStore

class FreeVanna(ChromaDB_VectorStore, Ollama):
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        Ollama.__init__(self, config={"model": "llama3"})
```

### How does Vanna handle schema changes?

When your database schema changes, you need to retrain Vanna with the updated DDL statements. The recommended approach is to version your training data and set up an automated pipeline that extracts the latest schema and retrains Vanna on deployment.

```python
# Automated retraining pipeline
import subprocess

# Extract latest schema
result = subprocess.run(
    ["pg_dump", "--schema-only", "mydb"],
    capture_output=True, text=True
)
new_ddl = result.stdout

# Clear old training and retrain
vn.remove_training_data()
vn.train(ddl=new_ddl)
```

### Can I use Vanna with non-English languages?

Yes, Vanna supports natural language questions in multiple languages. The LLM backend handles the translation to SQL generation. You can train Vanna with documentation and examples in your preferred language.

```python
# Training with Chinese documentation
vn.train(documentation="""
销售额表记录所有完成的交易。
amount 列单位为美元，含税。
大客户定义为累计购买超过 $10,000 的客户。
""")

sql = vn.generate_sql("显示2026年每个区域的总销售额")
```

### What databases does Vanna support?

Vanna supports virtually all major databases through its flexible connection system: PostgreSQL, MySQL, SQLite, SQL Server, Snowflake, BigQuery, Redshift, Oracle, DuckDB, ClickHouse, and any database with a Python DB-API driver. Custom connectors can also be implemented for specialized systems.

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

### How can I improve Vanna's accuracy for my specific use case?

The most effective way to improve accuracy is through comprehensive training. Follow this hierarchy of training data quality:

1. **Question-SQL pairs** (highest impact — near 100% accuracy)
2. **Example SQL queries** (high impact — teaches patterns)
3. **Business documentation** (medium impact — adds context)
4. **DDL statements** (foundational — eliminates hallucination)

```python
# Maximum accuracy training regimen
vn.train(ddl=all_schema_ddl)
vn.train(documentation=business_context)
for example in curated_sql_examples:
    vn.train(sql=example)
for qa in historical_question_sql_pairs:
    vn.train(question=qa["question"], sql=qa["sql"])
```

---



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Final Thoughts

Vanna AI represents a significant leap forward in democratizing database access. By combining the power of modern Large Language Models with a purpose-built RAG architecture for SQL generation, it delivers an accuracy level that makes natural language querying practical for real-world production environments. The 90%+ accuracy achieved with proper training, combined with its privacy-first design and self-hosting capabilities, makes Vanna the tool of choice for organizations that want to empower their teams with text-to-SQL without compromising data security.

In 2026, as the gap between data analysts and database experts continues to narrow, Vanna AI stands at the forefront — turning "What were our Q2 sales by region?" into executable SQL in seconds, not minutes. For any team looking to reduce the SQL bottleneck and let people ask questions in the language they think in, Vanna AI is an investment that pays dividends immediately.
