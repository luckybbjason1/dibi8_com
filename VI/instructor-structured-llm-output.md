---
# Instructor: Thư Viện Python Đảm Bảo LLM Xuất JSON Hợp Lệ 100% — Hướng Dẫn 2026

*Cập nhật lần cuối: 19 tháng 5, 2026*

Nếu bạn từng thử nghiệm để làm cho một Mô hình Ngôn ngữ lớn luôn luôn xuất ra JSON hợp lệ, bạn sẽ biết sự khó chịu. Một phản hồi hoàn hảo. Phản hồi tiếp theo thiếu dấu ngoặc đóng. Phản hồi thứ ba bao gồm văn bản giải thích trước JSON. Phản hồi thứ tư trả về JSON hợp lệ nhưng với schema sai. Sự không nhất quán này làm cho LLM trở nên không đáng tin cậy cho các ứng dụng sản xuất cần dữ liệu có cấu trúc — cho đến khi **Instructor** xuất hiện.

Instructor là một thư viện Python sửa đổi khách hàng OpenAI (và hơn 10 nhà cung cấp LLM khác) để đảm bảo kết quả có cấu trúc, an toàn về kiểu dữ liệu và đã được kiểm tra sử dụng **Pydantic models**. Nó chuyển đổi sự hoang dã của quá trình tạo văn bản từ các Mô hình Ngôn ngữ lớn thành một quy trình dự đoán, kỹ thuật phần mềm. Với hơn 11.000 ngôi sao trên GitHub, giấy phép MIT và cộng đồng sôi động, Instructor đã trở thành chuẩn mực thực tế cho đầu ra có cấu trúc của LLM trong Python. Hướng dẫn này bao gồm mọi thứ từ cài đặt cơ bản đến các mẫu đa nhà cung cấp nâng cao vào năm 2026.

---
---
## Instructor và Tại Sao Nó Quan Trọng?

Instructor, do **Jason Liu** (`jxnl`) tạo ra, là một thư viện Python nhẹ nhàng nằm trên khách hàng LLM hiện có của bạn và áp dụng kiểm định cấu trúc thông qua việc xác nhận mô hình Pydantic. Thay vì nhận được văn bản gốc từ LLM và cầu nguyện nó được phân tích đúng đắn, bạn định nghĩa một schema Pydantic và Instructor đảm bảo mỗi phản hồi tuân theo schema đó — hoặc tự động thử lại với một yêu cầu được sửa đổi.

Vấn đề mà Instructor giải quyết là căn bản: LLMs tạo ra văn bản, nhưng ứng dụng cần dữ liệu. Mỗi nhà phát triển đã từng tung một tính năng LLM vào sản xuất đều trải qua cuộc gọi pager lúc 2 giờ sáng khi `json.loads()` gặp sự cố vì mô hình thêm "Here's your result:" trước đối tượng JSON. Instructor loại bỏ cả lớp lỗi này.

```bash
# Cài đặt Instructor
pip install instructor

# Cài đặt khách hàng LLM yêu thích của bạn (OpenAI được hiển thị)
pip install openai
```

---
---
## Khái niệm Cốt Lõi: Đánh Gía Khách Hàng OpenAI

Học viên sử dụng phép **đánh giá khách hàng** để làm magie. Thay vì gọi trực tiếp API của OpenAI, bạn tạo một khách hàng được đánh giá mà nó chặn các phản hồi, kiểm tra chúng theo mô hình Pydantic của bạn và xử lý lỗi tự động.

```python
import instructor
from openai import OpenAI
from pydantic import BaseModel

# Đánh giá khách hàng OpenAI với Học viên
client = instructor.from_openai(OpenAI())

# Định nghĩa cấu trúc dữ liệu đầu ra như một mô hình Pydantic
class UserProfile(BaseModel):
    name: str
    age: int
    email: str
    interests: list[str]

# Trích xuất dữ liệu có cấu trúc từ ngôn ngữ tự nhiên
def extract_profile(user_description: str) -> UserProfile:
    return client.chat.completions.create(
        model="gpt-4o",
        response_model=UserProfile,
        messages=[
            {
                "role": "user",
                "content": f"Trích xuất một hồ sơ người dùng từ mô tả này: {user_description}"
            }
        ]
    )

# Sử dụng
profile = extract_profile(
    "Sarah là một kỹ sư phần mềm 28 tuổi ở Seattle. "
    "Cô yêu thích đi bộ, chụp ảnh và đọc tiểu thuyết khoa học viễn tưởng. "
    "Email của cô là sarah.chen@example.com"
)

print(profile)
# UserProfile(name='Sarah', age=28, email='sarah.chen@example.com', 
#             interests=['hiking', 'photography', 'reading sci-fi novels'])

# Truy cập các trường đã định kiểu trực tiếp
print(f"Tên: {profile.name}, Tuổi: {profile.age}")
print(f"Email hợp lệ: {'@' in profile.email}")
```

Lưu ý cách `response_model=UserProfile` cho Học viên biết phải kiểm tra đầu ra của mô hình LLM theo mô hình của bạn. Kết quả là một đối tượng Pydantic đã định kiểu hoàn toàn — không phải chuỗi gốc hay từ điển chưa được định kiểu.

---
---
## Xử Lý Lỗi Kiểm Tra Tự Động

Khi mô hình LLM sản xuất ra kết quả không hợp lệ, hành vi mặc định của Instructor là **đưa lại** yêu cầu cho mô hình với phản hồi về những gì đã sai, tạo ra một vòng lặp tự sửa chữa.

```python
from pydantic import BaseModel, Field, field_validator

class ValidatedProduct(BaseModel):
    name: str = Field(description="Tên sản phẩm, tối đa 50 ký tự")
    price: float = Field(description="Giá USD, phải dương")
    category: str = Field(description="Một trong những loại sau: điện tử, quần áo, thực phẩm, sách")
    
    @field_validator('category')
    @classmethod
    def validate_category(cls, v):
        allowed = {'electronics', 'clothing', 'food', 'books'}
        if v.lower() not in allowed:
            raise ValueError(f"Loại sản phẩm phải là một trong: {allowed}")
        return v.lower()
    
    @field_validator('price')
    @classmethod
    def validate_price(cls, v):
        if v <= 0:
            raise ValueError("Giá phải dương")
        return round(v, 2)

# Instructor tự động thử lại khi có lỗi kiểm tra
def parse_product(description: str) -> ValidatedProduct:
    return client.chat.completions.create(
        model="gpt-4o",
        response_model=ValidatedProduct,
        max_retries=3,  # Thử lại tối đa 3 lần với phản hồi
        messages=[
            {"role": "user", "content": f"Phân tích sản phẩm này: {description}"}
        ]
    )

# Điều này sẽ hoạt động ngay cả khi lần thử đầu tiên có vấn đề
product = parse_product(
    "Tai nghe Bluetooth không dây với giảm tiếng ồn, giá $79.99. Loại điện tử."
)
print(product)
# ValidatedProduct(name='Tai nghe Bluetooth không dây', 
#                  price=79.99, category='electronics')
```

---
---
## Mô hình Trinh luân và Schema Phức tạp

Các ứng dụng thực tế cần hơn những cấu trúc phẳng. Instructor xử lý dễ dàng các mô hình Pydantic được lồng nhau một cách linh hoạt.

```python
from typing import Optional, List
from pydantic import BaseModel, Field

class Address(BaseModel):
    street: str
    city: str
    state: str = Field(description="2-letter state code")
    zip_code: str
    country: str = "US"

class OrderItem(BaseModel):
    product_name: str
    quantity: int = Field(ge=1, description="Must be at least 1")
    unit_price: float = Field(gt=0)
    
    @property
    def total(self) -> float:
        return self.quantity * self.unit_price

class CustomerOrder(BaseModel):
    customer_name: str
    customer_email: str
    shipping_address: Address
    billing_address: Optional[Address] = None
    items: List[OrderItem]
    order_notes: Optional[str] = None
    
    @property
    def grand_total(self) -> float:
        return sum(item.total for item in self.items)

def extract_order(email_text: str) -> CustomerOrder:
    return client.chat.completions.create(
        model="gpt-4o",
        response_model=CustomerOrder,
        messages=[
            {"role": "user", "content": f"Extract order from email:\n\n{email_text}"}
        ]
    )

order = extract_order("""
Hi, I'd like to place an order.

Customer: John Smith (john.smith@email.com)
Ship to: 123 Oak Street, San Francisco, CA 94102

Items:
- MacBook Pro M3, qty 1, $1999
- USB-C Hub, qty 2, $49 each

Please gift wrap the laptop.
""")

print(f"Customer: {order.customer_name}")
print(f"Shipping to: {order.shipping_address.city}")
print(f"Order total: ${order.grand_total:.2f}")
```

```python
# Các trường tùy chọn có giá trị mặc định được xử lý một cách trơn tru
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class Event(BaseModel):
    name: str
    start_time: datetime
    end_time: Optional[datetime] = None
    location: Optional[str] = None
    description: Optional[str] = ""

event = client.chat.completions.create(
    model="gpt-4o-mini",
    response_model=Event,
    messages=[{
        "role": "user",
        "content": "Team standup meeting tomorrow at 10 AM in Conference Room B"
    }]
)
print(f"Event: {event.name}")
print(f"Starts: {event.start_time}")
print(f"Location: {event.location}")  # Conference Room B
print(f"Description: '{event.description}'")  # Sử dụng chuỗi trống rỗng mặc định
```

---
---
## Hỗ Trợ Nhiều Nhà Cung Cấp:超越我的知识库，请提供翻译。
---
## Xử Lý Lô Cho Các Ứng Dụng Có VOLUME Cao

Khi xử lý hàng nghìn mục, các gọi API riêng lẻ quá chậm. Instructor hỗ trợ xử lý lô với asyncio để thực thi đồng thời.

```python
import asyncio
import instructor
from openai import AsyncOpenAI
from pydantic import BaseModel

# Sử dụng client async cho xử lý lô
async_client = instructor.from_openai(AsyncOpenAI())

class SentimentResult(BaseModel):
    text: str
    sentiment: str  # "positive", "negative", "neutral"
    confidence: float
    key_phrases: list[str]

async def analyze_single(text: str) -> SentimentResult:
    return await async_client.chat.completions.create(
        model="gpt-4o-mini",
        response_model=SentimentResult,
        messages=[
            {"role": "user", "content": f"Đánh giá tình cảm: {text}"}
        ]
    )

async def analyze_batch(texts: list[str]) -> list[SentimentResult]:
    """Xử lý nhiều văn bản đồng thời."""
    tasks = [analyze_single(text) for text in texts]
    results = await asyncio.gather(*tasks)
    return results

# Xử lý 100 đánh giá đồng thời
texts = [
    "Sản phẩm này vượt quá mong đợi của tôi!",
    "Chất lượng kém, hỏng sau một ngày.",
    "Được rồi, không gì đặc biệt nhưng làm việc được.",
    # ... 97 mục còn lại
]

results = asyncio.run(analyze_batch(texts))
positive = sum(1 for r in results if r.sentiment == "positive")
print(f"Positive: {positive}/{len(results)}")
```

---
---
## Xuất Bản Kết Quả Đa Dạng Hóa Theo Thời Gian Thực

Cho ứng dụng thời gian thực, Instructor hỗ trợ việc truyền tải kết quả phần tử một cách liên tục khi chúng đến từ LLM.

```python
from typing import Iterable
from pydantic import BaseModel

class PartialArticle(BaseModel):
    title: str
    sections: list[str]
    key_points: list[str]

# Truyền tải dữ liệu đa dạng hóa theo thời gian thực khi nó được tạo ra
def stream_article(topic: str) -> Iterable[PartialArticle]:
    return client.chat.completions.create_partial(
        model="gpt-4o",
        response_model=PartialArticle,
        stream=True,
        messages=[
            {"role": "user", "content": f"Write an article outline about: {topic}"}
        ]
    )

# Xử lý kết quả phần tử khi chúng đến
for partial in stream_article("trends về năng lượng tái tạo 2026"):
    print(f"Tiêu đề: {partial.title}")
    print(f"Số phần đã có: {len(partial.sections)}")
    print("---")
```

---
---
## Thử Lại Nội Built-in với Việc Nhắc Lại

Hệ thống retry của giáo viên không chỉ lặp lại yêu cầu — nó cung cấp cho LLM phản hồi cụ thể về những gì đã thất bại trong việc kiểm tra, cho phép tự sửa chữa.

```python
from pydantic import BaseModel, field_validator

class StrictDateRange(BaseModel):
    start_date: str = Field(description="Định dạng YYYY-MM-DD")
    end_date: str = Field(description="Định dạng YYYY-MM-DD, phải sau ngày bắt đầu")
    
    @field_validator('start_date', 'end_date')
    @classmethod
    def validate_date_format(cls, v):
        from datetime import datetime
        datetime.strptime(v, "%Y-%m-%d")
        return v
    
    @field_validator('end_date')
    @classmethod
    def validate_order(cls, end, info):
        start = info.data.get('start_date')
        if start and end <= start:
            raise ValueError("end_date phải sau start_date")
        return end

# Giáo viên sẽ retry với phản hồi lỗi kiểm tra cụ thể
def extract_date_range(text: str) -> StrictDateRange:
    return client.chat.completions.create(
        model="gpt-4o",
        response_model=StrictDateRange,
        max_retries=3,
        messages=[
            {"role": "user", "content": f"Extract date range: {text}"}
        ]
    )

# Ngay cả khi mô hình thay đổi ngày hoặc sử dụng định dạng sai ban đầu,
# Giáo viên sẽ nhắc lại với thông báo lỗi cụ thể
try:
    result = extract_date_range(
        "Dự án đã chạy từ 15 tháng 3 năm 2026 đến 10 tháng 1 năm 2026"
    )
    print(result)
except Exception as e:
    print(f"Thất bại sau số lần retry tối đa: {e}")
```

---
---
## Sử Dụng Literal cho Phân Loại Giới Hạn

Đối với các tác vụ phân loại, sử dụng kiểu `Literal` của Python để giới hạn đầu ra chỉ đến những giá trị cụ thể.

```python
from typing import Literal

class SupportTicket(BaseModel):
    customer_query: str
    category: Literal[
        "billing", 
        "technical_support", 
        "account_access",
        "feature_request",
        "refund",
        "general_inquiry"
    ]
    priority: Literal["low", "medium", "high", "urgent"]
    suggested_response: str

def classify_ticket(ticket_text: str) -> SupportTicket:
    return client.chat.completions.create(
        model="gpt-4o-mini",
        response_model=SupportTicket,
        messages=[
            {
                "role": "system",
                "content": "Bạn là một chuyên gia phân loại hỗ trợ khách hàng."
            },
            {"role": "user", "content": f"Phân loại ticket này:\n\n{ticket_text}"}
        ]
    )

# Phân loại đảm bảo sẽ là một trong các giá trị được cho phép
ticket = classify_ticket(
    "Tôi đã bị thu phí hai lần cho dịch vụ đăng ký của mình vào tháng này. "
    "Vui lòng hoàn tiền khoản phí trùng lặp ngay lập tức."
)
print(f"Loại: {ticket.category}")  # Luôn luôn là "billing"
print(f"Khẩn cấp: {ticket.priority}")  # Luôn một trong bốn giá trị
```

```python
# Trích xuất thông tin cấu trúc từ các tài liệu dài
from pydantic import BaseModel

class ExtractedFact(BaseModel):
    subject: str
    predicate: str
    object_: str
    confidence: float

class DocumentExtraction(BaseModel):
    title: str
    facts: list[ExtractedFact]
    entities: list[str]
    summary: str

extraction = client.chat.completions.create(
    model="gpt-4o",
    response_model=DocumentExtraction,
    messages=[{
        "role": "user",
        "content": (
            "Trích xuất thông tin cấu trúc từ văn bản này:\n\n"
            "Apple Inc. được thành lập bởi Steve Jobs và Steve Wozniak "
            "ngày 1 tháng 4 năm 1976. Công ty có trụ sở tại Cupertino, California. "
            "Tim Cook trở thành CEO vào năm 2011."
        )
    }]
)
print(f"Tiêu đề: {extraction.title}")
print(f"Các đối tượng tìm thấy: {extraction.entities}")
print(f"Số lượng thông tin: {len(extraction.facts)}")
```

---
---
## Kết hợp với FastAPI cho API Sản xuất

Instructor tỏa sáng trong phát triển API. Dưới đây là một điểm cuối hoàn chỉnh của FastAPI với đầu ra LLM được cấu trúc:

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import instructor
from openai import OpenAI

app = FastAPI(title="API Đầu ra LLM Cấu Trúc")
client = instructor.from_openai(OpenAI())

# Schema yêu cầu
class ExtractionRequest(BaseModel):
    text: str
    extract_fields: list[str]

# Schema trả lời
class ExtractedData(BaseModel):
    entities: list[dict]
    relationships: list[dict]
    summary: str

@app.post("/extract", response_model=ExtractedData)
async def extract_entities(request: ExtractionRequest):
    """Trích xuất các entitie cấu trúc từ văn bản không cấu trúc."""
    try:
        result = client.chat.completions.create(
            model="gpt-4o",
            response_model=ExtractedData,
            messages=[
                {
                    "role": "user",
                    "content": (
                        f"Trích xuất entitie từ văn bản này. "
                        f"Tập trung vào: {', '.join(request.extract_fields)}\n\n"
                        f"Văn bản: {request.text}"
                    )
                }
            ]
        )
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Chạy với: uvicorn main:app --reload
```

---
---
## Nâng Cao: Thay thế Gọi Hàm của OpenAI bằng Phương Án Pydantic

Instructor có thể thay thế gọi hàm của OpenAI bằng các phương án mạnh mẽ hơn dựa trên schemas Pydantic.

```python
from typing import Type

class SearchQuery(BaseModel):
    """Tạo câu hỏi tìm kiếm với các tham số"""
    keywords: list[str]
    filters: dict[str, str]
    sort_by: Literal["relevance", "date", "price_asc", "price_desc"]
    
def generate_search(user_request: str) -> SearchQuery:
    return client.chat.completions.create(
        model="gpt-4o",
        response_model=SearchQuery,
        messages=[
            {
                "role": "user",
                "content": f"Generate an optimized search query for: {user_request}"
            }
        ]
    )

query = generate_search(
    "Find wireless earbuds under $100 with good battery life, newest first"
)
print(query.keywords)  # ['wireless earbuds', 'bluetooth']
print(query.filters)   # {'max_price': '100'}
print(query.sort_by)   # 'date'
```

---
---
## Xử Lý Lỗi và Ghi Nhật Ký

Hệ thống sản xuất cần có khả năng theo dõi hành vi thử lại của Instructor. Cấu hình ghi nhật ký để hỗ trợ việc debug.

```python
import logging
import instructor

# Kích hoạt ghi chi tiết
instructor.enable_logging()
logging.basicConfig(level=logging.DEBUG)

# Hoặc cấu hình logger cụ thể
logger = logging.getLogger("instructor")
logger.setLevel(logging.INFO)

# Thêm handler file cho sản xuất
handler = logging.FileHandler("instructor.log")
handler.setFormatter(logging.Formatter(
    '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
))
logger.addHandler(handler)

# Tất cả các lần thử lại và lỗi kiểm tra đều được ghi nhật ký
result = client.chat.completions.create(
    model="gpt-4o",
    response_model=UserProfile,
    max_retries=3,
    messages=[{"role": "user", "content": "Extract: Jane, age 25, likes art"}]
)
```

---
---
## Câu Hỏi Thường Gặp

### Instructor Hỗ Trợ Các Nhà Cung Cấp LLM Nào?

Instructor hỗ trợ **OpenAI** (GPT-4, GPT-4o, GPT-3.5), **Anthropic** (Claude 3/3.5/4 Sonnet, Opus, Haiku), **Google** (Gemini 1.5/2.0/2.5 Pro, Flash), **Cohere**, **Mistral**, **Groq**, **Ollama** (mô hình địa phương), **Azure OpenAI**, **AWS Bedrock**, **Fireworks AI**, và **Together AI**. API `response_model` hoạt động giống nhau trên tất cả các nhà cung cấp.

### Instructor Độc Đáo Hơn So Với Chế Độ JSON Của OpenAI?

Chế độ JSON của OpenAI đảm bảo cú pháp JSON hợp lệ nhưng không có kiểm tra schema. Mô hình vẫn có thể trả về JSON với tên trường sai, kiểu dữ liệu không đúng, trường bắt buộc bị thiếu hoặc giá trị nằm ngoài phạm vi mong đợi. Instructor thêm một lớp xác thực Pydantic mà nó phát hiện tất cả các vấn đề này và kích hoạt việc thử lại tự động cùng phản hồi điều chỉnh. Chế độ JSON là một cam kết về cú pháp; Instructor là một cam kết về nghĩa.

### Instructor Có Hoạt Động Với Các Mô Hình Địa Phương/Open-Source Không?

Có. Instructor hoạt động với bất kỳ mô hình nào có thể truy cập thông qua thư viện khách được hỗ trợ. Đối với các mô hình địa phương, sử dụng các tích hợp **Ollama** hoặc **llama-cpp-python**. Đối với các mô hình được-host trên vLLM hoặc TGI, sử dụng API tương thích OpenAI. Yêu cầu chính là mô hình có đủ khả năng tuân theo chỉ thị để tạo ra văn bản cấu trúc chuyển đổi thành JSON.

### Chi Phí Khó Khê Của Instructor Là Bao Nhiêu?

Instructor thêm chi phí nhỏ — thường là **10-50ms** mỗi lần gọi cho xác thực Pydantic. Cơ chế thử lại chỉ tăng độ trễ khi xác thực thất bại (điều này nên dưới 5% các lần gọi với mô hình có khả năng). Đối với ứng dụng có lưu lượng cao, sử dụng `gpt-4o-mini` hoặc các mô hình địa phương với xử lý lô đồng bộ. Chi phí này nhỏ so với độ trễ của API LLM chính nó (thông thường là 500ms-5s).

### Cơ Chế Thử Lại/Trả Lời Lại Làm Thế Nào?

Khi xác thực thất bại, Instructor bắt lỗi Pydantic `ValidationError`, rút ra các thông báo lỗi cụ thể (ví dụ: "tuổi phải là số nguyên dương"), và gửi yêu cầu mới đến mô hình LLM bao gồm: câu hỏi gốc, phản hồi sai, và chi tiết lỗi xác thực. Điều này tạo thành vòng lặp tự điều chỉnh giải quyết hầu hết các vấn đề trong 1-2 lần thử lại. Bạn kiểm soát số lần thử tối đa thông qua tham số `max_retries`.

### Tôi Có Thể Sử Dụng Instructor Với Các.Pattern Async/Await Không?

Có. Instructor hỗ trợ hoàn toàn async thông qua `AsyncOpenAI`, `AsyncAnthropic`, và các khách hàng async khác. Sử dụng `await client.chat.completions.create()` cho các gọi đơn lẻ hoặc sử dụng `asyncio.gather()` cho xử lý đồng thời. Chuỗi dữ liệu cũng được hỗ trợ trong chế độ async thông qua `create_partial()`.

### Instructor Có Hợp Phù Cho Triển Khai Sản Xuất Doanh Nghiệp Không?

Tuyệt đối. Với hơn 11,000 ngôi sao trên GitHub, giấy phép MIT, việc bảo trì tích cực và kiến trúc dựa trên Pydantic, Instructor phù hợp cho triển khai doanh nghiệp. Nó tích hợp dễ dàng với FastAPI, hệ thống giám sát (Datadog, Prometheus) và ghi log cấu trúc. Layer xác thực thêm độ tin cậy mà các API LLM nguyên bản không thể so sánh được. Nhiều công ty Fortune 500 sử dụng Instructor trong các luồng dữ liệu sản xuất.

---
---
## Kết luận

Instructor chuyển đổi LLM từ các nhà tạo ra văn bản không dự đoán được thành nguồn dữ liệu có cấu trúc đáng tin cậy. Bằng cách kết hợp sức mạnh của việc xác nhận Pydantic với thuật toán thử lại thông minh, nó giải quyết vấn đề số 1 đang gặp phải trong triển khai sản xuất LLM: sự nhất quán của đầu ra. Dù bạn đang rút ra các đối tượng từ tài liệu, phân loại vé hỗ trợ, hay xây dựng hệ thống đại diện phức tạp có nhiều bước, Instructor cung cấp an toàn kiểu và độ tin cậy mà các ứng dụng chuyên nghiệp yêu cầu.

Hỗ trợ đa nhà cung cấp của thư viện nghĩa là bạn không bị mắc kẹt với một nhà cung cấp LLM duy nhất. Sự tích hợp liền mạch với FastAPI, mô hình async, và streaming làm cho nó phù hợp cho mọi thứ từ việc chạy lô nền đến API thời gian thực. Với hơn 11.000 ngôi sao và cộng đồng hoạt động, Instructor đã giành được vị trí của mình như một công cụ không thể thiếu trong bộ dụng cụ phát triển AI hiện đại.

Nếu bạn vẫn đang phân tích đầu ra gốc từ LLM bằng `json.loads()` và hy vọng vào may mắn, thì đến lúc nâng cấp rồi. Cài đặt Instructor ngay hôm nay và trải nghiệm ý nghĩa của việc có **100% JSON hợp lệ, 100% thời gian**.

---