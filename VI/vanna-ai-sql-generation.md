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
- /vi/posts/vanna-ai-sql-generation/
---

{{</* resource-info */>}}

Khả năng tương tác với cơ sở dữ liệu bằng ngôn ngữ tự nhiên từ lâu đã là chén thánh của phân tích dữ liệu. Mỗi ngày, vô số giờ đồng hồ bị lãng phí cho việc dịch các câu hỏi kinh doanh thành truy vấn SQL — một quá trình đòi hỏi kiến thức sâu rộng về schema cơ sở dữ liệu, mối quan hệ bảng, và cú pháp SQL. Năm 2026, nút thắt cổ chai này đang nhanh chóng tan biến nhờ **Vanna AI**, một thư viện Python mã nguồn mở được huấn luyện trên schema cơ sở dữ liệu của bạn và tạo ra SQL sẵn sàng cho production từ tiếng Anh đơn giản với độ chính xác trên 90%.

Với hơn 18.000 sao GitHub và giấy phép MIT, Vanna AI đã nổi lên như giải pháp text-to-SQL hàng đầu cho các team đòi hỏi cả độ chính xác và quyền riêng tư dữ liệu. Khác với các phương pháp LLM chung chung coi SQL generation như một tác vụ dịch thuật, Vanna sử dụng kiến trúc **Retrieval-Augmented Generation (RAG)** được thiết kế đặc biệt cho việc truy vấn cơ sở dữ liệu. Nó học schema của bạn, hiểu logic kinh doanh của bạn, và tạo ra SQL thực sự chạy được — được xác thực, tối ưu hóa, và sẵn sàng cho production.

Trong hướng dẫn toàn diện này, chúng ta sẽ đi qua mọi thứ bạn cần biết về Vanna AI: từ cài đặt và huấn luyện schema đến tạo SQL nâng cao, xác thực, và tích hợp vào quy trình phân tích của bạn. Dù bạn là nhà phân tích dữ liệu muốn đặt câu hỏi bằng tiếng Anh, hay kỹ sư đang xây dựng giao diện ngôn ngữ tự nhiên cho nền tảng dữ liệu của bạn, Vanna AI cung cấp các công cụ bạn cần để biến text-to-SQL thành hiện thực.

---

## Vanna AI là gì? Ngôn ngữ Tự nhiên Gặp gỡ SQL

Vanna AI là một thư viện Python mã nguồn mở bắc cầu khoảng cách giữa ngôn ngữ con ngườ và ngôn ngữ truy vấn có cấu trúc. Về cốt lõi, Vanna là một framework **Retrieval-Augmented Generation (RAG)** được xây dựng đặc biệt cho SQL generation. Khác với các chatbot LLM chung chung thỉnh thoảng ảo giác tên bảng hay bịa ra tham chiếu cột, Vanna được huấn luyện trên schema cơ sở dữ liệu thực tế của bạn — học các bảng, cột, mối quan hệ, và thậm chí quy ước đặt tên của tổ chức bạn.

Quy trình làm việc đầy thanh lịch:

1. **Kết nối** Vanna với cơ sở dữ liệu của bạn
2. **Huấn luyện** nó trên schema của bạn (các câu lệnh DDL, tài liệu, truy vấn mẫu)
3. **Đặt câu hỏi** bằng ngôn ngữ tự nhiên
4. **Nhận** SQL chính xác, có thể thực thi

```python
import vanna as vn
from vanna.remote import VannaDefault

# Khởi tạo Vanna với API key của bạn
vn = VannaDefault(model="my-model", api_key="vn-...")

# Kết nối đến cơ sở dữ liệu của bạn
vn.connect_to_postgres(host="localhost", dbname="analytics",
                       user="analyst", password="secret", port=5432)

# Huấn luyện trên schema của bạn
vn.train(ddl="""
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    amount DECIMAL(10,2),
    sale_date TIMESTAMP,
    region VARCHAR(50)
);
""")

# Đặt câu hỏi bằng tiếng Anh đơn giản
sql = vn.generate_sql("What are the top 5 regions by total sales in 2026?")
print(sql)
```

SQL được tạo ra không chỉ đúng về mặt cú pháp — nó còn chính xác về mặt ngữ nghĩa, tham chiếu đến đúng các bảng, cột, và mối quan hệ từ schema thực tế của bạn.

---

## Tại sao Vanna AI Quan trọng vào năm 2026

Sự bùng nổ của các Mô hình Ngôn ngữ Lớn trong những năm gần đây đã tạo ra cơ hội to lớn cho các giao diện ngôn ngữ tự nhiên. Tuy nhiên, các LLM chung chung gặp khó khăn với SQL generation vì một số lý do quan trọng: chúng ảo giác các phần tử schema, bỏ qua cú pháp đặc thù của cơ sở dữ liệu, và không có nhận thức về mô hình dữ liệu thực tế của bạn. Gửi dữ liệu thô của bạn đến các điểm cuối API của bên thứ ba cũng gây ra những lo ngại nghiêm trọng về quyền riêng tư và tuân thủ.

Vanna AI giải quyết tất cả những thách thức này một cách trực diện:

- **Schema-Aware Generation**: Vanna học schema cụ thể của bạn, loại bỏ ảo giác
- **Thiết kế Ưu tiên Quyền riêng tư**: Dữ liệu của bạn không bao giờ rờ khỏi cơ sở hạ tầng của bạn trừ khi bạn chọn
- **Tùy chọn Tự lưu trữ**: Chạy mọi thứ cục bộ với các LLM mã nguồn mở
- **Xác thực SQL**: Mỗi truy vấn được tạo được xác thực trước cơ sở dữ liệu của bạn trước khi được trả về
- **Nhiều Backend LLM**: Sử dụng OpenAI, Anthropic, Google, hoặc các mô hình cục bộ như Ollama

```python
# Vanna hỗ trợ nhiều backend LLM
from vanna.ollama import Ollama
from vanna.chromadb import ChromaDB_VectorStore

class MyVanna(ChromaDB_VectorStore, Ollama):
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        Ollama.__init__(self, config={"model": "llama3"})

# Thiết lập hoàn toàn cục bộ, tự lưu trữ
vn = MyVanna()
vn.connect_to_sqlite("my_database.db")
vn.train(ddl="SELECT sql FROM sqlite_master WHERE type='table';")
```

Vào năm 2026, khi các tổ chức đối phó với các schema dữ liệu ngày càng phức tạp và các yêu cầu tuân thủ nghiêm ngặt hơn, phương pháp của Vanna — huấn luyện trên schema thay vì gửi dữ liệu lên đám mây — đại diện cho tiêu chuẩn vàng cho text-to-SQL an toàn và chính xác.

---

## Cài đặt và Cấu hình Vanna AI

Vanna được thiết kế để dễ dàng cài đặt và cấu hình, với các giá trị mặc định hợp lý giúp bạn nhanh chóng làm việc hiệu quả.

```bash
# Cài đặt Vanna core
pip install vanna

# Cài đặt với hỗ trợ backend LLM cụ thể
pip install "vanna[openai]"
pip install "vanna[anthropic]"
pip install "vanna[google]"
pip install "vanna[ollama]"

# Cài đặt trình điều khiển cơ sở dữ liệu
pip install "vanna[postgres]"
pip install "vanna[mysql]"
pip install "vanna[snowflake]"
pip install "vanna[bigquery]"

# Cài đặt tất cả
pip install "vanna[all]"
```

Cấu hình nhanh cho thiết lập phổ biến nhất:

```python
from vanna.remote import VannaDefault

# Sử dụng dịch vụ được lưu trữ của Vanna (thiết lập dễ nhất)
vn = VannaDefault(
    model="my-database-model",
    api_key="vn-your-api-key"
)

# Kết nối đến PostgreSQL
vn.connect_to_postgres(
    host="db.company.com",
    dbname="analytics",
    user="analyst",
    password="secure-password",
    port=5432
)
```

Để thiết lập hoàn toàn tự lưu trữ với LLM cục bộ:

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

## Huấn luyện Vanna trên Schema Cơ sở dữ liệu của Bạn

Huấn luyện là nơi Vanna thực sự tỏa sáng. Bạn huấn luyện Vanna trên schema càng nhiều, khả năng tạo SQL của nó càng chính xác. Có ba loại dữ liệu huấn luyện chính bạn có thể cung cấp.

### Huấn luyện với Các Câu lệnh DDL

Phương pháp huấn luyện cơ bản nhất là cung cấp DDL (Ngôn ngữ Định nghĩa Dữ liệu) của cơ sở dữ liệu — các câu lệnh CREATE TABLE xác định schema của bạn.

```python
# Huấn luyện với các câu lệnh DDL riêng lẻ
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

### Huấn luyện với Tự động Khám phá Schema

Đối với các cơ sở dữ liệu lớn, việc viết DDL thủ công là không thực tế. Vanna có thể tự động trích xuất thông tin schema từ cơ sở dữ liệu của bạn.

```python
# PostgreSQL: trích xuất schema từ information_schema
import psycopg2

conn = psycopg2.connect(
    host="localhost", dbname="analytics",
    user="analyst", password="secret"
)
cursor = conn.cursor()

# Lấy tất cả định nghĩa bảng
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

### Huấn luyện với Tài liệu và Logic Kinh doanh

Vượt ra khỏi schema thô, bạn có thể huấn luyện Vanna trên bối cảnh kinh doanh — giúp nó hiểu các cột của bạn thực sự có nghĩa là gì.

```python
# Huấn luyện với tài liệu
vn.train(documentation="""
The 'sales' table records all completed transactions.
The 'amount' column is in USD and includes tax.
The 'region' column uses standard US Census regions:
Northeast, Midwest, South, and West.
A 'high_value_customer' is anyone with lifetime purchases > $10,000.
""")

# Huấn luyện với các truy vấn SQL mẫu
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

### Huấn luyện với Các Cặp Câu hỏi-SQL

Để đạt độ chính xác tối đa, hãy cung cấp các cặp câu hỏi ngôn ngữ tự nhiên và các truy vấn SQL tương ứng của chúng.

```python
# Dữ liệu huấn luyện chuẩn vàng
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

## Tạo SQL từ Ngôn ngữ Tự nhiên

Một khi được huấn luyện, Vanna có thể tạo SQL từ các câu hỏi ngôn ngữ tự nhiên với độ chính xác đáng kinh ngạc. Phương thức `generate_sql` là giao diện chính.

```python
# Các câu hỏi đơn giản
sql = vn.generate_sql("Show me all customers from the West region")
print(sql)
# Đầu ra: SELECT * FROM customers WHERE region = 'West';

# Các truy vấn tổng hợp
sql = vn.generate_sql("What is the average order value by customer segment?")
print(sql)
# Đầu ra: SELECT c.segment, AVG(o.total_amount) as avg_order_value
#         FROM customers c JOIN orders o ON c.id = o.customer_id
#         GROUP BY c.segment;

# Các phép join đa bảng phức tạp
sql = vn.generate_sql(
    "Find the top 5 products by revenue in Q2 2026, "
    "including how many unique customers bought each product"
)
print(sql)

# Lọc theo thờ gian
sql = vn.generate_sql(
    "Compare monthly sales between 2025 and 2026, "
    "showing year-over-year growth percentage"
)
print(sql)
```

Vanna cũng hỗ trợ tạo SQL với các ràng buộc hoặc mẫu cụ thể:

```python
# Tạo SQL với giải thích
sql, explanation = vn.generate_sql(
    "Which customers haven't placed an order in the last 90 days?",
    explain=True
)
print(f"SQL: {sql}")
print(f"Explanation: {explanation}")

# Tạo SQL và cũng chạy nó
result_df = vn.ask("What are the monthly sales trends?")
print(result_df)

# Phương thức ask() tạo SQL, xác thực nó, thực thi nó,
# và trả về một DataFrame pandas — tất cả trong một lần gọi
```

---

## Xác thực SQL và Xử lý Lỗi

Một trong những tính năng nổi bật của Vanna là **xác thực SQL tự động**. Trước khi trả về một truy vấn cho bạn, Vanna có thể kiểm tra xem nó có thực sự chạy trên cơ sở dữ liệu của bạn không, bắt các lỗi cú pháp và sự không khớp schema.

```python
# Bật xác thực tự động
vn = VannaDefault(model="my-model", api_key="vn-...", 
                  config={"validate_sql": True})

# Các truy vấn không hợp lệ bị bắt và sửa
try:
    sql = vn.generate_sql("Show me the top 10 products by revenue")
    print(f"Validated SQL: {sql}")
except Exception as e:
    print(f"Validation failed: {e}")
    # Vanna sẽ cố gắng sửa và tạo lại
    sql = vn.generate_sql_with_retry(
        "Show me the top 10 products by revenue",
        max_retries=3
    )
```

Vanna cũng có thể xử lý các câu hỏi tiếp theo tham chiếu đến ngữ cảnh trước đó:

```python
# Câu hỏi đầu tiên
result1 = vn.ask("What were total sales in 2026?")

# Câu hỏi tiếp theo (Vanna duy trì ngữ cảnh)
result2 = vn.ask("Break that down by region")
# Tạo: SELECT region, SUM(amount) FROM sales 
#            WHERE sale_date >= '2026-01-01' GROUP BY region

# Một câu hỏi tiếp theo khác
result3 = vn.ask("Now show only regions with more than $1M in sales")
# Tạo: SELECT region, SUM(amount) as total 
#            FROM sales WHERE sale_date >= '2026-01-01' 
#            GROUP BY region HAVING SUM(amount) > 1000000
```

---

## Các Tính năng Nâng cao và Tùy biến

Vanna cung cấp các tùy chọn tùy biến rộng rãi cho ngườ dùng nâng cao và các triển khai production.

### Mẫu Prompt Tùy chỉnh

```python
# Ghi đè mẫu prompt mặc định
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

### Làm việc với Nhiều Cơ sở dữ liệu

```python
# Tạo các instance Vanna riêng biệt cho các cơ sở dữ liệu khác nhau
vn_sales = VannaDefault(model="sales-model", api_key="vn-...")
vn_sales.connect_to_postgres(host="sales-db", dbname="sales")

vn_hr = VannaDefault(model="hr-model", api_key="vn-...")
vn_hr.connect_to_mysql(host="hr-db", dbname="human_resources")

# Truy vấn cơ sở dữ liệu phù hợp
sales_sql = vn_sales.generate_sql("Total revenue by quarter")
hr_sql = vn_hr.generate_sql("Employee count by department")
```

### Sử dụng Các Kho Lưu trữ Vector Tùy chỉnh

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

## Tích hợp Jupyter và Các Quy trình Tương tác

Vanna tỏa sáng trong các notebook Jupyter, cung cấp các widget tương tác phong phú và khả năng trực quan hóa.

```python
from vanna.remote import VannaDefault
import vanna as vn

vn = VannaDefault(model="my-model", api_key="vn-...")
vn.connect_to_postgres(host="localhost", dbname="analytics",
                       user="analyst", password="secret")

# Khởi chạy giao diện trò chuyện tương tác trong Jupyter
vn.ask("What are the top selling products?")
```

Phương thức `ask()` trong Jupyter trả về đầu ra phong phú bao gồm SQL được tạo, giải thích, và bảng kết quả. Để có trải nghiệm tương tác đầy đủ:

```python
# Khởi chạy giao diện Web UI tương tác trong Jupyter
from vanna.flask import VannaFlaskApp

app = VannaFlaskApp(vn)
app.run()
```

Vanna cũng tạo các trực quan tự động khi phù hợp:

```python
# Tạo SQL và tự động tạo biểu đồ
vn.ask("Plot monthly sales trends for 2026")

# Tạo SQL, thực thi nó, và tạo biểu đồ đường
# từ các kết quả chuỗi thờ gian tự động
```

---

## Kiến trúc Vanna AI và Mô hình Quyền riêng tư

Hiểu kiến trúc của Vanna là chìa khóa để triển khai nó an toàn trong các môi trường production.

```
┌─────────────────────────────────────────────────────────────┐
│                    Kiến trúc Vanna AI                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   Câu hỏi Ngườ dùng  ──▶  Kho Vector (Schema/Ví dụ)       │
│       │                       │                            │
│       │                       ▼                            │
│       │              Ngữ cảnh Liên quan                    │
│       │              Được truy xuất qua RAG                │
│       │                       │                            │
│       ▼                       ▼                            │
│   ┌──────────────────────────────────────┐                │
│   │        Backend LLM                   │                │
│   │  (OpenAI / Anthropic / Ollama / ...) │                │
│   │                                      │                │
│   │  Lờ nhắc: Câu hỏi + Ngữ cảnh Schema│                │
│   │  Đầu ra: SQL Được tạo               │                │
│   └──────────────────────────────────────┘                │
│                       │                                     │
│                       ▼                                     │
│              Xác thực SQL                                   │
│                       │                                     │
│                       ▼                                     │
│              Thực thi Trên DB                               │
│                       │                                     │
│                       ▼                                     │
│               Trả về Kết quả                                │
└─────────────────────────────────────────────────────────────┘
```

Mô hình quyền riêng tư hoạt động như sau:

```python
# Cấu hình Ưu tiên Quyền riêng tư (Khuyến nghị)
from vanna.ollama import Ollama
from vanna.chromadb import ChromaDB_VectorStore

class PrivateVanna(ChromaDB_VectorStore, Ollama):
    """Hoàn toàn tự lưu trữ. Không dữ liệu nào rờ khỏi mạng của bạn."""
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        Ollama.__init__(self, config={"model": "llama3:70b"})

vn = PrivateVanna()
vn.connect_to_postgres(host="internal-db", dbname="analytics",
                       user="readonly", password="secret")

# Siêu dữ liệu Schema được lưu trữ cục bộ trong ChromaDB
# LLM chạy cục bộ qua Ollama
# Các truy vấn cơ sở dữ liệu thực thi trên cơ sở dữ liệu nội bộ
# Không dữ liệu nào đến được các API bên ngoài
```

---

## Benchmark và Độ chính xác

Độ chính xác của Vanna phụ thuộc nhiều vào chất lượng và số lượng dữ liệu huấn luyện. Dưới đây là các đặc điểm hiệu suất điển hình được quan sát vào năm 2026:

```python
# Script đánh giá độ chính xác
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
    # So sánh ngữ nghĩa (được chuẩn hóa)
    if normalize_sql(generated) == normalize_sql(test["expected_sql"]):
        correct += 1

accuracy = correct / len(test_cases) * 100
print(f"Độ chính xác: {accuracy:.1f}%")
```

Với việc huấn luyện toàn diện (DDL + tài liệu + các truy vấn mẫu), Vanna liên tục đạt được:

- **Độ chính xác 90-95%** trên các truy vấn phân tích thông thường
- **Độ chính xác 85-90%** trên các phép join đa bảng phức tạp
- **Độ chính xác 80-85%** trên các truy vấn đòi hỏi ngữ cảnh kinh doanh
- Gần như **100% độ chính xác** khi các cặp câu hỏi-SQL được cung cấp làm dữ liệu huấn luyện

Chìa khóa cho độ chính xác cao là huấn luyện kỹ lưỡng. Một instance Vanna được huấn luyện tốt với 50+ câu lệnh DDL, 20+ truy vấn mẫu, và tài liệu liên quan vượt trội hơn đáng kể so với các phương pháp LLM chung chung.

---

## Câu Hỏi Thường Gặp (FAQ)

### Vanna AI có hoàn toàn miễn phí không?

Có, Vanna AI là mã nguồn mở theo giấy phép MIT và miễn phí sử dụng. Thư viện lõi, tất cả các tích hợp, và hệ thống huấn luyện dựa trên RAG đều có sẵn miễn phí. Vanna cũng cung cấp dịch vụ đám mây được lưu trữ với gói miễn phí cho các dự án nhỏ, với các gói trả phí cho các tính năng doanh nghiệp như cộng tác team và phân tích nâng cao. Tùy chọn tự lưu trữ sử dụng LLM cục bộ (qua Ollama) và kho lưu trữ vector cục bộ (qua ChromaDB) hoàn toàn miễn phí không giới hạn sử dụng.

```python
# Thiết lập tự lưu trữ hoàn toàn miễn phí
from vanna.ollama import Ollama
from vanna.chromadb import ChromaDB_VectorStore

class FreeVanna(ChromaDB_VectorStore, Ollama):
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        Ollama.__init__(self, config={"model": "llama3"})
```

### Vanna xử lý các thay đổi schema như thế nào?

Khi schema cơ sở dữ liệu của bạn thay đổi, bạn cần huấn luyện lại Vanna với các câu lệnh DDL đã cập nhật. Phương pháp được khuyến nghị là phiên bản hóa dữ liệu huấn luyện của bạn và thiết lập một pipeline tự động trích xuất schema mới nhất và huấn luyện lại Vanna khi triển khai.

```python
# Pipeline huấn luyện lại tự động
import subprocess

# Trích xuất schema mới nhất
result = subprocess.run(
    ["pg_dump", "--schema-only", "mydb"],
    capture_output=True, text=True
)
new_ddl = result.stdout

# Xóa dữ liệu huấn luyện cũ và huấn luyện lại
vn.remove_training_data()
vn.train(ddl=new_ddl)
```

### Tôi có thể sử dụng Vanna với các ngôn ngữ không phải tiếng Anh không?

Có, Vanna hỗ trợ các câu hỏi ngôn ngữ tự nhiên bằng nhiều ngôn ngữ. Backend LLM xử lý việc dịch sang SQL generation. Bạn có thể huấn luyện Vanna bằng tài liệu và ví dụ bằng ngôn ngữ ưa thích của bạn.

```python
# Huấn luyện bằng tài liệu tiếng Trung
vn.train(documentation="""
销售额表记录所有完成的交易。
amount 列单位为美元，含税。
大客户定义为累计购买超过 $10,000 的客户。
""")

sql = vn.generate_sql("显示2026年每个区域的总销售额")
```

### Vanna hỗ trợ những cơ sở dữ liệu nào?

Vanna hỗ trợ hầu hết tất cả các cơ sở dữ liệu chính thông qua hệ thống kết nối linh hoạt của nó: PostgreSQL, MySQL, SQLite, SQL Server, Snowflake, BigQuery, Redshift, Oracle, DuckDB, ClickHouse, và bất kỳ cơ sở dữ liệu nào có trình điều khiển Python DB-API. Các trình kết nối tùy chỉnh cũng có thể được triển khai cho các hệ thống chuyên dụng.

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

### Làm thế nào để cải thiện độ chính xác của Vanna cho trường hợp sử dụng cụ thể của tôi?

Cách hiệu quả nhất để cải thiện độ chính xác là thông qua huấn luyện toàn diện. Tuân theo hệ thống phân cấp chất lượng dữ liệu huấn luyện này:

1. **Các cặp Câu hỏi-SQL** (tác động cao nhất — gần 100% độ chính xác)
2. **Các truy vấn SQL mẫu** (tác động cao — dạy các mẫu)
3. **Tài liệu Kinh doanh** (tác động trung bình — thêm ngữ cảnh)
4. **Các câu lệnh DDL** (nền tảng — loại bỏ ảo giác)

```python
# Chế độ huấn luyện độ chính xác tối đa
vn.train(ddl=all_schema_ddl)
vn.train(documentation=business_context)
for example in curated_sql_examples:
    vn.train(sql=example)
for qa in historical_question_sql_pairs:
    vn.train(question=qa["question"], sql=qa["sql"])
```

---



## Hosting Và Hạ Tầng Được Đề Xuất

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit $200 trong 60 ngày.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Suy Nghĩ Cuối Cùng

Vanna AI đại diện cho một bước nhảy vọt đáng kể trong việc dân chủ hóa quyền truy cập cơ sở dữ liệu. Bằng cách kết hợp sức mạnh của các Mô hình Ngôn ngữ Lớn hiện đại với kiến trúc RAG được xây dựng có mục đích cho SQL generation, nó mang lại mức độ chính xác làm cho truy vấn ngôn ngữ tự nhiên trở nên thực tế trong các môi trường production thực tế. Mức độ chính xác 90%+ đạt được với huấn luyện phù hợp, kết hợp với thiết kế ưu tiên quyền riêng tư và khả năng tự lưu trữ, khiến Vanna trở thành công cụ lựa chọn cho các tổ chức muốn trao quyền cho team của họ với text-to-SQL mà không làm giảm bảo mật dữ liệu.

Vào năm 2026, khi khoảng cách giữa các nhà phân tích dữ liệu và các chuyên gia cơ sở dữ liệu tiếp tục thu hẹp, Vanna AI đứng ở tuyến đầu — biến "Doanh thu Q2 theo khu vực của chúng ta là bao nhiêu?" thành SQL có thể thực thi trong vài giây, không phải vài phút. Đối với bất kỳ team nào muốn giảm nút thắt cổ chai SQL và cho phép mọi ngườ đặt câu hỏi bằng ngôn ngữ họ suy nghĩ, Vanna AI là một khoản đầu tư mang lại lợi nhuận ngay lập tức.
