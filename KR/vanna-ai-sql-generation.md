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
- /kr/posts/vanna-ai-sql-generation/
---

{{</* resource-info */>}}

데이터베이스와 자연어를 사용하여 상호작용하는 능력은 오랫동안 데이터 분석의 성배로 여겨져 왔습니다. 매일 무수한 시간이 비즈니스 질문을 SQL 쿼리로 번역하는 데 낭비됩니다 — 이 과정은 데이터베이스 스키마, 테이블 관계 및 SQL 구문에 대한 깊은 지식을 요구합니다. 2026년, 이 병목 현상은 **Vanna AI** 덕분에 빠르게 사라지고 있습니다. Vanna AI는 데이터베이스 스키마에서 학습하여 평범한 영어로 90% 이상의 정확도로 프로덕션 수준의 SQL을 생성하는 오픈소스 Python 라이브러리입니다.

18,000개 이상의 GitHub 스타와 MIT 라이선스를 보유한 Vanna AI는 정확성과 데이터 프라이버시를 모두 요구하는 팀을 위한 선도적인 Text-to-SQL 솔루션으로 부상했습니다. SQL 생성을 또 다른 번역 작업으로 취급하는 범용 LLM 접근 방식과 달리, Vanna는 데이터베이스 쿼리를 위해 특별히 설계된 **검색 증강 생성(RAG)** 아키텍처를 사용합니다. 스키마를 학습하고, 비즈니스 로직을 이해하며, 실제로 실행되는 SQL을 생성합니다 — 검증되고, 최적화되며, 프로덕션에 바로 사용할 준비가 되어 있습니다.

이 포괄적인 가이드에서는 설치 및 스키마 학습부터 고급 SQL 생성, 검증, 분석 워크플로우에의 통합까지 Vanna AI에 대해 알아야 할 모든 것을 살펴 보겠습니다. 영어로 질문하고 싶은 데이터 분석가이든, 데이터 플랫폼을 위한 자연어 인터페이스를 구축하는 엔지니어이든, Vanna AI는 Text-to-SQL을 현실로 만드는 데 필요한 도구를 제공합니다.

---

## Vanna AI란? 자연어가 SQL을 만나다

Vanna AI는 인간의 언어와 구조화된 쿼리 언어 사이의 간극을 메우는 오픈소스 Python 라이브러리입니다. 핵심적으로 Vanna는 SQL 생성을 위해 특별히 구축된 **검색 증강 생성(RAG)** 프레임워크입니다. 때때로 테이블 이름을 환각하거나 열 참조를 지어내는 범용 LLM 챗봇과 달리, Vanna는 실제 데이터베이스 스키마에서 학습하여 — 테이블, 열, 관계, 심지어 조직의 명명 규칙까지 학습합니다.

워크플로우는 우아하게 단순합니다:

1. 데이터베이스에 Vanna **연결**
2. 스키마에 대해 **학습** (DDL 문, 문서, 샘플 쿼리)
3. 자연어로 **질문**
4. 정확하고 실행 가능한 SQL **수신**

```python
import vanna as vn
from vanna.remote import VannaDefault

# API 키로 Vanna 초기화
vn = VannaDefault(model="my-model", api_key="vn-...")

# 데이터베이스에 연결
vn.connect_to_postgres(host="localhost", dbname="analytics",
                       user="analyst", password="secret", port=5432)

# 스키마에 대해 학습
vn.train(ddl="""
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    amount DECIMAL(10,2),
    sale_date TIMESTAMP,
    region VARCHAR(50)
);
""")

# 평범한 영어로 질문
sql = vn.generate_sql("What are the top 5 regions by total sales in 2026?")
print(sql)
```

생성된 SQL은 구문적으로 올바를 뿐만 아니라 — 실제 스키마에서 올바른 테이블, 열, 관계를 참조하는 의미적으로 정확합니다.

---

## 2026년에 Vanna AI가 중요한 이유

최근 몇 년간 대형 언어 모델의 폭발적인 성장은 자연어 인터페이스에 엄청난 기회를 창출했습니다. 그러나 범용 LLM은 SQL 생성에 있어 몇 가지 중요한 이유로 어려움을 겪습니다: 스키마 요소를 환각하고, 데이터베이스별 구문을 무시하며, 실제 데이터 모델에 대한 인식이 없습니다. 원시 데이터를 타사 API 엔드포인트로 본낼 때 심각한 프라이버시 및 규정 준수 문제도 발생합니다.

Vanna AI는 이러한 모든 과제에 정면으로 대응합니다:

- **스키마 인식 생성**: Vanna는 특정 스키마를 학습하여 환각을 제거합니다
- **프라이버시 우선 설계**: 원하는 경우가 아니면 데이터가 인프라를 벗어나지 않습니다
- **자체 호스팅 옵션**: 오픈소스 LLM으로 모든 것을 로컬에서 실행
- **SQL 검증**: 생성된 모든 쿼리가 반환되기 전에 데이터베이스에 대해 검증됩니다
- **다중 LLM 백엔드**: OpenAI, Anthropic, Google 또는 Ollama와 같은 로컬 모델 사용

```python
# Vanna는 다중 LLM 백엔드를 지원합니다
from vanna.ollama import Ollama
from vanna.chromadb import ChromaDB_VectorStore

class MyVanna(ChromaDB_VectorStore, Ollama):
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        Ollama.__init__(self, config={"model": "llama3"})

# 완전 로컬, 자체 호스팅 설정
vn = MyVanna()
vn.connect_to_sqlite("my_database.db")
vn.train(ddl="SELECT sql FROM sqlite_master WHERE type='table';")
```

2026년, 조직이 점점 더 복잡한 데이터 스키마와 더 엄격한 규정 준수 요구 사항에 대응하면서, Vanna의 접근 방식 — 클라우드로 데이터를 본내는 대신 스키마에서 학습 — 은 안전하고 정확한 Text-to-SQL을 위한 골드 스탠다드를 대표합니다.

---

## Vanna AI 설치 및 구성

Vanna는 빠르게 생산성을 높일 수 있는 합리적인 기본값을 통해 쉽게 설치하고 구성할 수 있도록 설계되었습니다.

```bash
# Vanna 핵심 설치
pip install vanna

# 특정 LLM 백엔드 지원 설치
pip install "vanna[openai]"
pip install "vanna[anthropic]"
pip install "vanna[google]"
pip install "vanna[ollama]"

# 데이터베이스 드라이버 설치
pip install "vanna[postgres]"
pip install "vanna[mysql]"
pip install "vanna[snowflake]"
pip install "vanna[bigquery]"

# 모두 설치
pip install "vanna[all]"
```

가장 일반적인 설정에 대한 빠른 구성:

```python
from vanna.remote import VannaDefault

# Vanna의 호스팅 서비스 사용 (가장 쉬운 설정)
vn = VannaDefault(
    model="my-database-model",
    api_key="vn-your-api-key"
)

# PostgreSQL에 연결
vn.connect_to_postgres(
    host="db.company.com",
    dbname="analytics",
    user="analyst",
    password="secure-password",
    port=5432
)
```

로컬 LLM을 사용하는 완전 자체 호스팅 설정의 경우:

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

## 데이터베이스 스키마에서 Vanna 학습시키기

학습은 Vanna가 진정으로 빛나는 부분입니다. Vanna를 스키마에 대해 더 많이 학습시킬수록 SQL 생성이 더 정확해집니다. 제공할 수 있는 세 가지 주요 유형의 학습 데이터가 있습니다.

### DDL 문으로 학습

가장 기본적인 학습 방법은 데이터베이스의 DDL(데이터 정의 언어) — 스키마를 정의하는 CREATE TABLE 문 — 을 제공하는 것입니다.

```python
# 개별 DDL 문으로 학습
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

### 스키마 자동 검색으로 학습

대형 데이터베이스의 경우 수동으로 DDL을 작성하는 것은 비현실적입니다. Vanna는 데이터베이스에서 자동으로 스키마 정보를 추출할 수 있습니다.

```python
# PostgreSQL: information_schema에서 스키마 추출
import psycopg2

conn = psycopg2.connect(
    host="localhost", dbname="analytics",
    user="analyst", password="secret"
)
cursor = conn.cursor()

# 모든 테이블 정의 가져오기
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

### 문서 및 비즈니스 로직으로 학습

원시 스키마를 넘어 비즈니스 맥락에서 Vanna를 학습시킬 수 있습니다 — 열이 실제로 무엇을 의미하는지 이해하도록 돕습니다.

```python
# 문서로 학습
vn.train(documentation="""
The 'sales' table records all completed transactions.
The 'amount' column is in USD and includes tax.
The 'region' column uses standard US Census regions:
Northeast, Midwest, South, and West.
A 'high_value_customer' is anyone with lifetime purchases > $10,000.
""")

# 예제 SQL 쿼리로 학습
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

### 질문-SQL 쌍으로 학습

최대 정확도를 위해 자연어 질문과 해당 SQL 쿼리의 쌍을 제공합니다.

```python
# 골드 스탠다드 학습 데이터
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

## 자연어에서 SQL 생성하기

학습이 완료되면 Vanna는 놀라운 정확도로 자연어 질문에서 SQL을 생성할 수 있습니다. `generate_sql` 메서드가 주요 인터페이스입니다.

```python
# 간단한 질문
sql = vn.generate_sql("Show me all customers from the West region")
print(sql)
# 출력: SELECT * FROM customers WHERE region = 'West';

# 집계 쿼리
sql = vn.generate_sql("What is the average order value by customer segment?")
print(sql)
# 출력: SELECT c.segment, AVG(o.total_amount) as avg_order_value
#         FROM customers c JOIN orders o ON c.id = o.customer_id
#         GROUP BY c.segment;

# 복잡한 다중 테이블 조인
sql = vn.generate_sql(
    "Find the top 5 products by revenue in Q2 2026, "
    "including how many unique customers bought each product"
)
print(sql)

# 시간 기반 필터링
sql = vn.generate_sql(
    "Compare monthly sales between 2025 and 2026, "
    "showing year-over-year growth percentage"
)
print(sql)
```

Vanna는 특정 제약이나 패턴이 있는 SQL 생성도 지원합니다:

```python
# 설명이 포함된 SQL 생성
sql, explanation = vn.generate_sql(
    "Which customers haven't placed an order in the last 90 days?",
    explain=True
)
print(f"SQL: {sql}")
print(f"Explanation: {explanation}")

# SQL을 생성하고 실행도 합니다
result_df = vn.ask("What are the monthly sales trends?")
print(result_df)

# ask() 메서드는 SQL을 생성하고, 검증하고, 실행하고,
# pandas DataFrame을 반환합니다 — 한 번의 호출로 모두 수행
```

---

## SQL 검증 및 오류 처리

Vanna의 두드러진 기능 중 하나는 **자동 SQL 검증**입니다. 쿼리를 반환하기 전에 Vanna는 실제로 데이터베이스에서 실행되는지 확인하여 구문 오류와 스키마 불일치를 포착할 수 있습니다.

```python
# 자동 검증 활성화
vn = VannaDefault(model="my-model", api_key="vn-...", 
                  config={"validate_sql": True})

# 잘못된 쿼리가 포착되고 수정됩니다
try:
    sql = vn.generate_sql("Show me the top 10 products by revenue")
    print(f"Validated SQL: {sql}")
except Exception as e:
    print(f"Validation failed: {e}")
    # Vanna는 수정하고 재생성을 시도할 것입니다
    sql = vn.generate_sql_with_retry(
        "Show me the top 10 products by revenue",
        max_retries=3
    )
```

Vanna는 이전 맥락을 참조하는 후속 질문도 처리할 수 있습니다:

```python
# 첫 번째 질문
result1 = vn.ask("What were total sales in 2026?")

# 후속 질문 (Vanna는 맥락을 유지합니다)
result2 = vn.ask("Break that down by region")
# 생성: SELECT region, SUM(amount) FROM sales 
#            WHERE sale_date >= '2026-01-01' GROUP BY region

# 또 다른 후속 질문
result3 = vn.ask("Now show only regions with more than $1M in sales")
# 생성: SELECT region, SUM(amount) as total 
#            FROM sales WHERE sale_date >= '2026-01-01' 
#            GROUP BY region HAVING SUM(amount) > 1000000
```

---

## 고급 기능 및 사용자 정의

Vanna는 고급 사용자와 프로덕션 배포를 위해 광범위한 사용자 정의 옵션을 제공합니다.

### 사용자 정의 프롬프트 템플릿

```python
# 기본 프롬프트 템플릿 재정의
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

### 여러 데이터베이스 작업

```python
# 다른 데이터베이스에 대해 별도의 Vanna 인스턴스 생성
vn_sales = VannaDefault(model="sales-model", api_key="vn-...")
vn_sales.connect_to_postgres(host="sales-db", dbname="sales")

vn_hr = VannaDefault(model="hr-model", api_key="vn-...")
vn_hr.connect_to_mysql(host="hr-db", dbname="human_resources")

# 적절한 데이터베이스에 쿼리
sales_sql = vn_sales.generate_sql("Total revenue by quarter")
hr_sql = vn_hr.generate_sql("Employee count by department")
```

### 사용자 정의 벡터 저장소 사용

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

## Jupyter 통합 및 대화형 워크플로우

Vanna는 Jupyter 노트북에서 풍부한 대화형 위젯과 시각화 기능을 제공하며 빛을 발합니다.

```python
from vanna.remote import VannaDefault
import vanna as vn

vn = VannaDefault(model="my-model", api_key="vn-...")
vn.connect_to_postgres(host="localhost", dbname="analytics",
                       user="analyst", password="secret")

# Jupyter에서 대화형 채팅 인터페이스 시작
vn.ask("What are the top selling products?")
```

Jupyter에서 `ask()` 메서드는 생성된 SQL, 설명 및 결과 테이블을 포함한 풍부한 출력을 반환합니다. 완전한 대화형 경험을 위해:

```python
# Jupyter 내에서 대화형 Web UI 시작
from vanna.flask import VannaFlaskApp

app = VannaFlaskApp(vn)
app.run()
```

Vanna는 적절할 때 자동으로 시각화도 생성합니다:

```python
# SQL을 생성하고 자동으로 차트 생성
vn.ask("Plot monthly sales trends for 2026")

# SQL을 생성하고, 실행하고, 시계열 결과에서
# 자동으로 라인 차트를 만듭니다
```

---

## Vanna AI 아키텍처 및 프라이버시 모델

Vanna의 아키텍처를 이해하는 것은 프로덕션 환경에 안전하게 배포하는 데 핵심입니다.

```
┌─────────────────────────────────────────────────────────────┐
│                    Vanna AI 아키텍처                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   사용자 질문  ──▶  벡터 저장소 (스키마/예제)               │
│       │                       │                            │
│       │                       ▼                            │
│       │              관련 컨텍스트                         │
│       │              RAG를 통해 검색                       │
│       │                       │                            │
│       ▼                       ▼                            │
│   ┌──────────────────────────────────────┐                │
│   │        LLM 백엔드                      │                │
│   │  (OpenAI / Anthropic / Ollama / ...) │                │
│   │                                      │                │
│   │  프롬프트: 질문 + 스키마 컨텍스트     │                │
│   │  출력: 생성된 SQL                     │                │
│   └──────────────────────────────────────┘                │
│                       │                                     │
│                       ▼                                     │
│              SQL 검증                                       │
│                       │                                     │
│                       ▼                                     │
│              DB에서 실행                                    │
│                       │                                     │
│                       ▼                                     │
│               결과 반환                                     │
└─────────────────────────────────────────────────────────────┘
```

프라이버시 모델은 다음과 같이 작동합니다:

```python
# 프라이버시 우선 구성 (권장)
from vanna.ollama import Ollama
from vanna.chromadb import ChromaDB_VectorStore

class PrivateVanna(ChromaDB_VectorStore, Ollama):
    """완전히 자체 호스팅. 데이터가 네트워크를 벗어나지 않습니다."""
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        Ollama.__init__(self, config={"model": "llama3:70b"})

vn = PrivateVanna()
vn.connect_to_postgres(host="internal-db", dbname="analytics",
                       user="readonly", password="secret")

# 스키마 메타데이터는 로컬 ChromaDB에 저장됩니다
# LLM은 Ollama를 통해 로컬에서 실행됩니다
# 데이터베이스 쿼리는 낶부 데이터베이스에 대해 실행됩니다
# 데이터는 외부 API에 도달하지 않습니다
```

---

## 벤치마크 및 정확도

Vanna의 정확도는 학습 데이터의 품질과 양에 크게 의존합니다. 2026년에 관찰된 전형적인 성능 특성은 다음과 같습니다:

```python
# 정확도 평가 스크립트
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
    # 의미론적 비교 (정규화됨)
    if normalize_sql(generated) == normalize_sql(test["expected_sql"]):
        correct += 1

accuracy = correct / len(test_cases) * 100
print(f"정확도: {accuracy:.1f}%")
```

포괄적인 학습 (DDL + 문서 + 예제 쿼리)을 통해 Vanna는 일관되게 다음을 달성합니다:

- 일반적인 분석 쿼리에 대해 **90-95% 정확도**
- 복잡한 다중 테이블 조인에 대해 **85-90% 정확도**
- 비즈니스 맥락이 필요한 쿼리에 대해 **80-85% 정확도**
- 질문-SQL 쌍이 학습 데이터로 제공될 때 거의 **100% 정확도**

높은 정확도의 핵심은 철저한 학습입니다. 50개 이상의 DDL 문, 20개 이상의 예제 쿼리, 관련 문서가 있는 잘 훈련된 Vanna 인스턴스는 범용 LLM 접근 방식보다 상당한 차이로 뛰어납니다.

---

## 자주 묻는 질문 (FAQ)

### Vanna AI는 완전히 묶음인가요?

예, Vanna AI는 MIT 라이선스 하에 오픈소스이며 묶음으로 사용할 수 있습니다. 핵심 라이브러리, 모든 통합, RAG 기반 학습 시스템은 비용 없이 사용할 수 있습니다. Vanna는 소규모 프로젝트를 위한 묶음 티어가 있는 호스팅 클라우드 서비스도 제공하며, 팀 협업 및 고급 분석과 같은 엔터프라이즈 기능에 대해서는 유료 계획이 있습니다. Ollama를 통한 로컬 LLM과 ChromaDB를 통한 로컬 벡터 저장소를 사용하는 자체 호스팅 옵션은 사용 제한 없이 완전히 묶음입니다.

```python
# 묶음, 완전히 자체 호스팅 설정
from vanna.ollama import Ollama
from vanna.chromadb import ChromaDB_VectorStore

class FreeVanna(ChromaDB_VectorStore, Ollama):
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        Ollama.__init__(self, config={"model": "llama3"})
```

### Vanna는 스키마 변경을 어떻게 처리합니까?

데이터베이스 스키마가 변경되면 업데이트된 DDL 문으로 Vanna를 재학습해야 합니다. 권장되는 접근 방식은 학습 데이터를 버전 관리하고 최신 스키마를 추출하고 배포 시 Vanna를 재학습하는 자동화된 파이프라인을 설정하는 것입니다.

```python
# 자동화된 재학습 파이프라인
import subprocess

# 최신 스키마 추출
result = subprocess.run(
    ["pg_dump", "--schema-only", "mydb"],
    capture_output=True, text=True
)
new_ddl = result.stdout

# 이전 학습 데이터 지우고 재학습
vn.remove_training_data()
vn.train(ddl=new_ddl)
```

### 비영어 언어로 Vanna를 사용할 수 있나요?

예, Vanna는 여러 언어의 자연어 질문을 지원합니다. LLM 백엔드가 SQL 생성으로의 번역을 처리합니다. 선호하는 언어로 문서와 예제를 사용하여 Vanna를 학습시킬 수 있습니다.

```python
# 중국어 문서로 학습
vn.train(documentation="""
销售额表记录所有完成的交易。
amount 列单位为美元，含税。
大客户定义为累计购买超过 $10,000 的客户。
""")

sql = vn.generate_sql("显示2026年每个区域的总销售额")
```

### Vanna는 어떤 데이터베이스를 지원합니까?

Vanna는 유연한 연결 시스템을 통해 거의 모든 주요 데이터베이스를 지원합니다: PostgreSQL, MySQL, SQLite, SQL Server, Snowflake, BigQuery, Redshift, Oracle, DuckDB, ClickHouse 및 Python DB-API 드라이버가 있는 모든 데이터베이스. 사용자 정의 커넥터도 특수 시스템에 대해 구현할 수 있습니다.

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

### 내 특정 사용 사례에서 Vanna의 정확도를 어떻게 향상시킬 수 있나요?

정확도를 향상시키는 가장 효과적인 방법은 포괄적인 학습을 통하는 것입니다. 다음 학습 데이터 품질 계층 구조를 따르세요:

1. **질문-SQL 쌍** (가장 높은 영향 — 거의 100% 정확도)
2. **예제 SQL 쿼리** (높은 영향 — 패턴 가르침)
3. **비즈니스 문서** (중간 영향 — 맥락 추가)
4. **DDL 문** (기초 — 환각 제거)

```python
# 최대 정확도 학습 요법
vn.train(ddl=all_schema_ddl)
vn.train(documentation=business_context)
for example in curated_sql_examples:
    vn.train(sql=example)
for qa in historical_question_sql_pairs:
    vn.train(question=qa["question"], sql=qa["sql"])
```

---



## 추천 호스팅 및 인프라

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영을 지원합니다.*

## 마지막 생각

Vanna AI는 데이터베이스 접근 대중화에서 중대한 도약을 대표합니다. 현대적 대형 언어 모델의 성능과 SQL 생성을 위해 특별히 구축된 RAG 아키텍처를 결합함으로써, 자연어 쿼리를 실제 프로덕션 환경에서 실용적으로 만드는 정확도 수준을 제공합니다. 적절한 학습을 통해 달성된 90%+ 정확도와 프라이버시 우선 설계 및 자체 호스팅 기능의 결합은 데이터 보안을 손상시키지 않고 팀에 Text-to-SQL 기능을 제공하려는 조직을 위한 도구로 Vanna를 만듭니다.

2026년, 데이터 분석가와 데이터베이스 전문가 사이의 간격이 계속 좁아지면서, Vanna AI는 최전선에 서 있습니다 — "우리 지역별 Q2 매출은 얼마입니까?"를 몇 분이 아닌 몇 초 내에 실행 가능한 SQL로 변환합니다. SQL 병목 현상을 줄이고 사람들이 생각하는 언어로 질문할 수 있게 하려는 모든 팀에게 Vanna AI는 즉시 배당금을 지불하는 투자입니다.
