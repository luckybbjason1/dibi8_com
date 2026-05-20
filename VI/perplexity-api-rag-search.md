---
title: 'perplexity-api-rag-search'
description: '{''en'': ''Learn how to build RAG-enhanced search applications using the Perplexity API. Covers Sonar models, real-time web citations, streaming, and production integration patterns.'', ''zh'': ''学习如何使用Perplexity API构建RAG增强搜索应用。涵盖Sonar模型、实时网络引用、流式传输和生产集成模式。'', ''ko'': ''Perplexity API를 사용하여 RAG 강화 검색 애플리케이션을构建하는 방법을 알아보세요. Sonar 모델, 실시간 웹 인용, 스트리밍 및 프로덕션 통합 패턴을 다룹니다.'', ''vi'': ''Tìm hiểu cách xây dựng ứng dụng tìm kiếm tăng cường RAG bằng Perplexity API. Bao gồm mô hình Sonar, trích dẫn web thờigian thực, streaming và các mẫu tích hợp sản xuất.''}'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Proprietary
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/perplexity'
stars: 0
maintainer: 'perplexity'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Perplexity API']
aliases:
- /vi/posts/perplexity-api-rag-search/
---

{{</* resource-info */>}}

Cuộc đua xây dựng các ứng dụng thông minh, nhận thức được sự kiện đã đạt đến cột mốc then chốt với Perplexity API — một dịch vụ tìm kiếm RAG (Retrieval-Augmented Generation) được xây dựng chuyên biệt kết hợp các mô hình ngôn ngữ lớn với lập chỉ mục web trực tiếp. Không giống như các API LLM truyền thống chỉ dựa vào dữ liệu huấn luyện tĩnh, các mô hình Sonar của Perplexity truy vấn internet theo thờigian thực, truy xuất các nguồn có thẩm quyền và trả về câu trả lờ có cấu trúc kèm theo trích dẫn nội tuyến. Đối với các nhà phát triển xây dựng chatbot, công cụ nghiên cứu, trợ lý kiến thức và đường ống xác minh nội dung, điều này đại diện cho một sự chuyển đổi paradigma: các ứng dụng không chỉ tạo ra văn bản, mà còn căn cứ mọi khẳng định vào thực tế có thể xác minh được.

Hướng dẫn này cung cấp lộ trình tích hợp toàn diện cho Perplexity API trong năm 2026. Bạn sẽ tìm hiểu kiến trúc tìm kiếm RAG hoạt động như thế nào, mô hình Sonar nào phù hợp với trường hợp sử dụng của bạn, cách triển khai chat completions streaming, xử lý trích dẫn theo chương trình, quản lý giớ hạn tốc độ và triển khai các ứng dụng tìm kiếm cấp sản xuất cung cấp câu trả lờ chính xác, có nguồn gốc cho ngườ dùng.

---

## Perplexity API là gì và tại sao RAG lại quan trọng?

Perplexity AI đã ra mắt API của mình để giải quyết một hạn chế cơ bản của các mô hình ngôn ngữ thông thường: ảo giác và điểm cắt kiến thức. Các LLM tiêu chuẩn bị đóng băng trong thờigian, được đào tạo trên dữ liệu dừng lại ở một ngày cụ thể. Hỏi họ về biến động thị trường ngày hôm qua, một câu chuyện tin tức nóng hoặc phiên bản phần mềm mới phát hành gần đây, và họ hoặc bịa đặt hoặc thừa nhận sự thiếu hiểu biết.

Perplexity API loại bỏ ràng buộc này thông qua RAG tích hợp sẵn. Khi bạn gửi một truy vấn, hệ thống phía sau của Perplexity thực hiện tìm kiếm web trực tiếp, truy xuất các tài liệu liên quan, xếp hạng chúng theo thẩm quyền và cung cấp chúng cho mô hình ngôn ngữ như một cơ sở ngữ cảnh. Mô hình sau đó tổng hợp một câu trả lờ trích dẫn các URL cụ thể, cho phép ngườ dùng xác minh mọi thông tin.

Kiến trúc này quan trọng vì nó biến đổi các LLM từ ngườ thi cử kín sách thành nhà nghiên cứu mở sách. Lớp truy xuất đảm bảo tính chính xác của sự kiện. Lớp tạo sinh đảm bảo khả năng đọc và tổng hợp. Lớp trích dẫn đảm bảo sự tin tưởng. Cùng nhau, chúng tạo ra một trải nghiệm tìm kiếm sánh ngang với các công cụ truyền thống trong khi mang lại sự trôi chảy hội thoại mà ngườ dùng mong đợi từ AI.

Đối với các nhà phát triển, ảnh hưởng thực tế là sâu sắc: bạn không còn cần xây dựng đường ống truy xuất riêng, quản lý cơ sở dữ liệu vector hoặc điều chỉnh chiến lược phân đoạn. Perplexity tự động xử lý truy xuất tài liệu, đánh giá mức độ liên quan và tiêm ngữ cảnh, hiển thị một giao diện chat completions sạch sẽ mà quen thuộc với bất kỳ ai đã từng làm việc với API của OpenAI.

---

## Hiểu về dòng mô hình Sonar: Chọn mô hình nào

Perplexity cung cấp một dòng mô hình phân tầng dưới thương hiệu Sonar, mỗi mô hình được tối ưu hóa cho các yêu cầu về độ trễ, độ chính xác và chi phí khác nhau. Chọn đúng mô hình là quyết định kiến trúc đầu tiên bạn sẽ đưa ra.

### Sonar (Tiêu chuẩn)

Mô hình Sonar cơ bản cung cấp thờigian phản hồi nhanh nhất và chi phí thấp nhất mỗi truy vấn. Nó xuất sắc trong các truy vấn thông tin đơn giản nơi câu trả lờ có thể được tìm thấy trong nội dung web dễ dàng truy cập. Sử dụng Sonar cho chatbot, hệ thống FAQ và các ứng dụng nơi trải nghiệm ngườ dùng đòi hỏi câu trả lờ nhanh.

### Sonar Pro

Sonar Pro đánh đổi một chút độ trễ để lấy khả năng suy luận sâu hơn đáng kể và khả năng nghiên cứu đa bước. Nó thực hiện nhiều lần lặp tìm kiếm, theo sau suy luận chuỗi suy nghĩ và tổng hợp các câu trả lờ phức tạp từ nhiều nguồn khác nhau. Chọn Sonar Pro cho trợ lý nghiên cứu, công cụ phân tích nội dung và bất kỳ ứng dụng nào nơi chất lượng câu trả lờ quan trọng hơn tốc độ.

### Sonar Reasoning

Biến thể suy luận áp dụng phân tích từng bước rõ ràng trước khi tạo phản hồi. Nó chia nhỏ các truy vấn thành các câu hỏi phụ, tìm kiếm từng thành phần và xây dựng các câu trả lờ logic nghiêm ngặt. Mô hình này lý tưởng cho các tác vụ phân tích, quy trình kiểm tra sự thật và ứng dụng giáo dục.

### Sonar Deep Research

Đối với nghiên cứu cấp doanh nghiệp và khám phá chủ đề toàn diện, Sonar Deep Research tiến hành điều tra đa nguồn mở rộng, đánh giá hàng chục tài liệu để tạo ra các báo cáo chi tiết, có cấu trúc tốt. Mong đợi độ trễ và mức sử dụng token cao hơn, nhưng sự toàn diện không thể sánh bằng.

```python
# Ánh xạ chọn mô hình cho các trường hợp sử dụng khác nhau
MODEL_MAP = {
    "fast_chat": "sonar",           # Q&A nhanh, độ trễ thấp
    "deep_research": "sonar-pro",   # Điều tra kỹ lưỡng
    "analytical": "sonar-reasoning", # Suy luận từng bước
    "enterprise": "sonar-deep-research"  # Báo cáo toàn diện
}
```

---

## Bắt đầu: Khóa API và Xác thực

Trước khi viết mã tích hợp, bạn cần một khóa API Perplexity. Truy cập cổng thông tin nhà phát triển Perplexity, tạo tài khoản và tạo khóa API từ bảng điều khiển. Perplexity sử dụng xác thực token Bearer tiêu chuẩn qua HTTPS.

```bash
# Lưu trữ khóa API của bạn một cách an toàn
export PERPLEXITY_API_KEY="pplx-your-api-key-here"
```

Tất cả các yêu cầu API đều yêu cầu header `Authorization: Bearer <token>`. Điểm cuối cơ bản cho chat completions là `https://api.perplexity.ai/chat/completions`.

```python
import os

API_KEY = os.environ.get("PERPLEXITY_API_KEY")
BASE_URL = "https://api.perplexity.ai"
HEADERS = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json"
}
```

Perplexity cung cấp gói miễn phí hào phóng cho việc thử nghiệm, với các gói trả phí mở rộng dựa trên khối lượng truy vấn và lựa chọn mô hình. Cấu trúc giá dựa trên truy vấn thay vì dựa trên token để đơn giản hóa việc thanh toán, mặc dù mức tiêu thụ token được theo dõi để phân tích sử dụng.

---

## Chat Completions Cơ bản: Truy vấn RAG đầu tiên của bạn

Perplexity API triển khai giao diện chat completions tương thích với OpenAI, giúp việc di chuyển trở nên đơn giản nếu bạn đã sử dụng các mô hình dựa trên GPT. Sự khác biệt quan trọng là tìm kiếm web tự động và tiêm trích dẫn diễn ra ở hậu trường.

```python
import requests
import json

def perplexity_query(query: str, model: str = "sonar-pro") -> dict:
    """Gửi một truy vấn được tăng cường RAG duy nhất đến Perplexity API."""
    url = f"{BASE_URL}/chat/completions"
    
    payload = {
        "model": model,
        "messages": [
            {
                "role": "system",
                "content": "Bạn là một trợ lý nghiên cứu hữu ích. Cung cấp câu trả lờ chính xác, có nguồn gốc rõ ràng."
            },
            {
                "role": "user",
                "content": query
            }
        ],
        "max_tokens": 1024,
        "temperature": 0.2
    }
    
    response = requests.post(url, headers=HEADERS, json=payload)
    response.raise_for_status()
    return response.json()

# Thực hiện tìm kiếm RAG đầu tiên của bạn
result = perplexity_query(
    "Những phát triển mới nhất trong năng lượng nhiệt hạch từ 2026 là gì?"
)
print(result["choices"][0]["message"]["content"])
```

Lưu ý rằng không cần tham số tìm kiếm, ID tài liệu hoặc cấu hình truy xuất. Perplexity tự động xác định xem có cần tìm kiếm web hay không, thực hiện truy xuất và căn cứ phản hồi trên tài liệu có nguồn.

Phản hồi bao gồm không chỉ văn bản được tạo mà cả siêu dữ liệu trích dẫn:

```python
# Trích xuất trích dẫn từ phản hồi
message = result["choices"][0]["message"]
answer_text = message["content"]
citations = message.get("citations", [])

print(f"Câu trả lờ: {answer_text[:200]}...")
print(f"\nSố nguồn được trích dẫn: {len(citations)}")
for i, citation in enumerate(citations[:5], 1):
    print(f"  [{i}] {citation}")
```

---

## Làm việc với Trích dẫn: Xây dựng Niềm tin thông qua Minh bạch

Trích dẫn là đặc điểm xác định của triển khai RAG của Perplexity. Mọi khẳng định thực tế trong phản hồi đều có thể được truy nguyên đến một nguồn web cụ thể, cho phép ngườ dùng xác minh thông tin và khám phá chủ đề sâu hơn.

### Hiểu Định dạng Trích dẫn

Perplexity trả về trích dẫn dưới dạng danh sách URL trong trường `citations` của tin nhắn trợ lý. Trong văn bản nội dung, các trích dẫn được tham chiếu bằng chỉ số trong ngoặc vuông `[1]`, `[2]`, v.v., khớp với thứ tự của mảng trích dẫn.

```python
def format_response_with_citations(result: dict) -> str:
    """Định dạng phản hồi Perplexity với các liên kết trích dẫn có thể nhấp."""
    message = result["choices"][0]["message"]
    content = message["content"]
    citations = message.get("citations", [])
    
    formatted = f"{content}\n\n---\n**Nguồn:**\n"
    for i, url in enumerate(citations, 1):
        formatted += f"\n[{i}] [{url}]({url})"
    
    return formatted

print(format_response_with_citations(result))
```

### Hiển thị Trích dẫn trong Ứng dụng Web

Khi xây dựng giao diện web, hiển thị trích dẫn dưới dạng chú thích tương tác hoặc tham chiếu thanh bên:

```html
<!-- Thành phần React cho phản hồi có trích dẫn -->
function CitedResponse({ content, citations }) {
  // Phân tích các đánh dấu [1], [2] trong nội dung
  const parts = content.split(/(\[\d+\])/g);
  
  return (
    <div className="cited-response">
      <div className="answer-text">
        {parts.map((part, i) => {
          const match = part.match(/\[(\d+)\]/);
          if (match) {
            const idx = parseInt(match[1]) - 1;
            return (
              <sup key={i} className="citation-ref">
                <a href={citations[idx]} target="_blank" rel="noopener">
                  {part}
                </a>
              </sup>
            );
          }
          return <span key={i}>{part}</span>;
        })}
      </div>
      <CitationList citations={citations} />
    </div>
  );
}
```

---

## Phản hồi Streaming cho Trải nghiệm Ngườ dùng Thờigian Thực

Đối với các ứng dụng tương tác, Perplexity hỗ trợ streaming Server-Sent Events (SSE), phân phối token khi chúng được tạo thay vì đợi phản hồi hoàn chỉnh. Điều này tạo ra nhận thức về tốc độ và cho phép hiển thị trích dẫn dần dần.

```python
import sseclient
import io

def perplexity_stream(query: str, model: str = "sonar-pro"):
    """Phát trực tiếp phản hồi truy vấn RAG từng token."""
    url = f"{BASE_URL}/chat/completions"
    
    payload = {
        "model": model,
        "messages": [
            {"role": "system", "content": "Hãy súc tích và chính xác."},
            {"role": "user", "content": query}
        ],
        "stream": True,
        "max_tokens": 1024
    }
    
    response = requests.post(url, headers=HEADERS, json=payload, stream=True)
    response.raise_for_status()
    
    client = sseclient.SSEClient(response)
    full_content = []
    citations = []
    
    for event in client.events():
        if event.data == "[DONE]":
            break
        
        chunk = json.loads(event.data)
        delta = chunk["choices"][0].get("delta", {})
        
        # Tích lũy các token nội dung
        if "content" in delta:
            token = delta["content"]
            full_content.append(token)
            print(token, end="", flush=True)
        
        # Chụp các trích dẫn từ chunk cuối cùng
        if "citations" in delta:
            citations.extend(delta["citations"])
    
    print(f"\n\nNguồn: {citations}")
    return "".join(full_content), citations

# Phát trực tiếp một truy vấn thờigian thực
answer, sources = perplexity_stream(
    "Kết quả của hội nghị khí hậu UN mới nhất là gì?"
)
```

```javascript
// Ví dụ streaming Node.js sử dụng fetch
async function streamPerplexity(query) {
  const response = await fetch('https://api.perplexity.ai/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.PERPLEXITY_API_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: 'sonar-pro',
      messages: [{ role: 'user', content: query }],
      stream: true
    })
  });

  const reader = response.body.getReader();
  const decoder = new TextDecoder();

  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    
    const chunk = decoder.decode(value);
    const lines = chunk.split('\n').filter(line => line.startsWith('data: '));
    
    for (const line of lines) {
      const data = line.slice(6);
      if (data === '[DONE]') return;
      
      const parsed = JSON.parse(data);
      const token = parsed.choices[0]?.delta?.content || '';
      process.stdout.write(token);
    }
  }
}
```

---

## Hội thoại Đa lượt với Tìm kiếm theo Ngữ cảnh

Perplexity duy trì ngữ cảnh hội thoại xuyên suốt nhiều lượt, cho phép các câu hỏi tiếp theo tham chiếu các cuộc trao đổi trước đó. Hệ thống tìm kiếm thích ứng với luồng hội thoại, tinh chỉnh các truy xuất dựa trên ngữ cảnh tích lũy.

```python
class PerplexityConversation:
    """Trình xử lý hội thoại trạng thái với bộ nhớ tìm kiếm RAG."""
    
    def __init__(self, model: str = "sonar-pro", system_prompt: str = None):
        self.model = model
        self.messages = []
        if system_prompt:
            self.messages.append({"role": "system", "content": system_prompt})
        self.citation_history = []
    
    def ask(self, query: str) -> dict:
        """Gửi tin nhắn và duy trì lịch sử hội thoại."""
        self.messages.append({"role": "user", "content": query})
        
        payload = {
            "model": self.model,
            "messages": self.messages,
            "max_tokens": 1024,
            "temperature": 0.2,
            "return_citations": True
        }
        
        response = requests.post(
            f"{BASE_URL}/chat/completions",
            headers=HEADERS,
            json=payload
        )
        response.raise_for_status()
        result = response.json()
        
        assistant_msg = result["choices"][0]["message"]
        self.messages.append({
            "role": "assistant",
            "content": assistant_msg["content"]
        })
        self.citation_history.extend(assistant_msg.get("citations", []))
        
        return result
    
    def get_conversation_summary(self) -> str:
        """Tạo tóm tắt về cuộc hội thoại và các nguồn đã sử dụng."""
        unique_sources = list(set(self.citation_history))
        return f"Lượt: {len(self.messages)//2}, Nguồn duy nhất: {len(unique_sources)}"

# Cách sử dụng: Phiên nghiên cứu đa lượt
conv = PerplexityConversation(
    model="sonar-pro",
    system_prompt="Bạn là một nhà phân tích nghiên cứu thị trường chuyên về xu hướng công nghệ."
)

# Lượt 1: Nghiên cứu ban đầu
r1 = conv.ask("Top 5 công ty chip AI theo vốn hóa thị trường năm 2026 là gì?")

# Lượt 2: Theo dõi với ngữ cảnh
r2 = conv.ask("Trong số này, công ty nào đầu tư mạnh nhất vào R&D?")

# Lượt 3: Đi sâu
r3 = conv.ask("Họ đang ra mắt sản phẩm cụ thể nào trong năm nay?")

print(conv.get_conversation_summary())
```

---

## Các Mẫu Truy vấn Nâng cao: Dữ liệu Có cấu trúc và Lọc Miền

Vượt ra ngoài Q&A cơ bản, Perplexity API hỗ trợ các mẫu truy vấn nâng cao giúp các nhà phát triển kiểm soát tinh vi quá trình truy xuất và tạo sinh.

### Nhắm mục tiêu Miền Tìm kiếm

Hạn chế tìm kiếm vào các miền cụ thể để có nguồn có thẩm quyền trong các lĩnh vực chuyên môn:

```python
def targeted_search(query: str, domains: list[str]) -> dict:
    """Tìm kiếm trong các miền đã chỉ định để có kết quả có thẩm quyền."""
    payload = {
        "model": "sonar-pro",
        "messages": [
            {
                "role": "system",
                "content": f"Ưu tiên các nguồn từ: {', '.join(domains)}. Trích dẫn ưu tiên những nguồn này."
            },
            {"role": "user", "content": query}
        ],
        "search_domain_filter": domains,
        "return_citations": True
    }
    
    response = requests.post(
        f"{BASE_URL}/chat/completions",
        headers=HEADERS,
        json=payload
    )
    return response.json()

# Truy vấn y tế giớ hạn trong các miền sức khỏe có thẩm quyền
medical_result = targeted_search(
    "Những phát triển mới nhất về vắc-xin mRNA là gì?",
    domains=["who.int", "cdc.gov", "nejm.org", " Lancet.com"]
)
```

### Lọc Thờigian gần đây

Kiểm soát phạm vi thờigian của tìm kiếm web để đảm bảo độ mới:

```python
def recent_search(query: str, recency_days: int = 7) -> dict:
    """Chỉ tìm kiếm thông tin gần đây."""
    payload = {
        "model": "sonar-pro",
        "messages": [{"role": "user", "content": query}],
        "search_recency_filter": f"{recency_days}d",
        "return_citations": True
    }
    
    response = requests.post(
        f"{BASE_URL}/chat/completions",
        headers=HEADERS,
        json=payload
    )
    return response.json()

# Chỉ lấy tin tức từ 24 giờ qua
breaking = recent_search("Các thương vụ công nghệ lớn hôm nay", recency_days=1)
```

### Chế độ JSON để Trích xuất Có cấu trúc

Khi xây dựng đường ống dữ liệu, yêu cầu đầu ra có cấu trúc để phân tích tự động:

```python
import json

def structured_search(query: str, schema: dict) -> dict:
    """Tìm kiếm và trả về JSON có cấu trúc phù hợp với lược đồ."""
    payload = {
        "model": "sonar-pro",
        "messages": [
            {
                "role": "system",
                "content": f"Trả lờ bằng JSON hợp lệ khớp với lược đồ này: {json.dumps(schema)}"
            },
            {"role": "user", "content": query}
        ],
        "response_format": {"type": "json_object"},
        "return_citations": True
    }
    
    response = requests.post(
        f"{BASE_URL}/chat/completions",
        headers=HEADERS,
        json=payload
    )
    result = response.json()
    
    # Phân tích nội dung JSON
    content = result["choices"][0]["message"]["content"]
    result["structured"] = json.loads(content)
    return result

# Trích xuất dữ liệu công ty có cấu trúc
company_schema = {
    "company_name": "string",
    "founded_year": "integer",
    "headquarters": "string",
    "key_products": ["string"],
    "market_cap_usd": "string"
}

structured = structured_search(
    "Cung cấp chi tiết về công ty Perplexity AI",
    company_schema
)
print(json.dumps(structured["structured"], indent=2))
```

---

## Triển khai Sản xuất: Giớ hạn Tốc độ, Xử lý Lỗi và Logic Thử lại

Các tích hợp sản xuất đòi hỏi khả năng xử lý mạnh mẽ các giớ hạn API và lỗi tạm thờ. Perplexity thực thi các giớ hạn tốc độ dựa trên cấp đăng ký của bạn, với các giớ hạn điển hình từ 20 đến 1000 yêu cầu mỗi phút.

```python
import time
from functools import wraps

class PerplexityClient:
    """Khách hàng API Perplexity sẵn sàng sản xuất với thử lại và giớ hạn tốc độ."""
    
    def __init__(self, api_key: str, model: str = "sonar-pro", max_retries: int = 3):
        self.api_key = api_key
        self.model = model
        self.max_retries = max_retries
        self.headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json"
        }
        self.request_count = 0
        self.last_reset = time.time()
    
    def _rate_limit_check(self, rpm_limit: int = 50):
        """Kiểm soát tốc độ cơ bản để duy trì trong giớ hạn cấp."""
        now = time.time()
        if now - self.last_reset >= 60:
            self.request_count = 0
            self.last_reset = now
        
        if self.request_count >= rpm_limit:
            sleep_time = 60 - (now - self.last_reset)
            if sleep_time > 0:
                print(f"Đã đạt giớ hạn tốc độ. Tạm dừng {sleep_time:.1f}s")
                time.sleep(sleep_time)
            self.request_count = 0
            self.last_reset = time.time()
    
    def query(self, user_query: str, temperature: float = 0.2, **kwargs) -> dict:
        """Thực thi truy vấn với tự động thử lại khi lỗi."""
        self._rate_limit_check()
        
        payload = {
            "model": self.model,
            "messages": [{"role": "user", "content": user_query}],
            "temperature": temperature,
            "return_citations": True,
            **kwargs
        }
        
        for attempt in range(self.max_retries):
            try:
                response = requests.post(
                    f"{BASE_URL}/chat/completions",
                    headers=self.headers,
                    json=payload,
                    timeout=30
                )
                
                if response.status_code == 429:
                    retry_after = int(response.headers.get("Retry-After", 2 ** attempt))
                    print(f"Bị giớ hạn tốc độ. Thử lại sau {retry_after}s")
                    time.sleep(retry_after)
                    continue
                
                response.raise_for_status()
                self.request_count += 1
                return response.json()
                
            except requests.exceptions.Timeout:
                print(f"Hết thờigian ở lần thử {attempt + 1}")
                time.sleep(2 ** attempt)
            except requests.exceptions.HTTPError as e:
                print(f"Lỗi HTTP: {e}")
                if attempt < self.max_retries - 1:
                    time.sleep(2 ** attempt)
        
        raise Exception("Đã vượt quá số lần thử lại tối đa")

# Sử dụng sản xuất
client = PerplexityClient(api_key=os.environ["PERPLEXITY_API_KEY"])

# Xử lý hàng loạt với kiểm soát tốc độ
queries = [
    "Các đột phá mới nhất về máy tính lượng tử",
    "Đầu tư năng lượng tái tạo năm 2026",
    "Khám phá kính viễn vọng không gian mới"
]

results = []
for q in queries:
    try:
        result = client.query(q)
        results.append(result)
        print(f"✓ Truy vấn hoàn thành: {q[:50]}...")
    except Exception as e:
        print(f"✗ Truy vấn thất bại: {q[:50]}... - {e}")
```

---

## Xây dựng Ứng dụng Tìm kiếm RAG Hoàn chỉnh

Hãy tổng hợp mọi thứ thành một ứng dụng Flask hoàn chỉnh minh họa các mẫu sản xuất cho một dịch vụ tìm kiếm được hỗ trợ bởi RAG.

```python
# app.py - API Tìm kiếm RAG Hoàn chỉnh
from flask import Flask, request, jsonify, Response
from flask_cors import CORS
import os
import json
import requests

app = Flask(__name__)
CORS(app)

PERPLEXITY_KEY = os.environ["PERPLEXITY_API_KEY"]
BASE_URL = "https://api.perplexity.ai"

class RAGSearchService:
    def __init__(self):
        self.headers = {
            "Authorization": f"Bearer {PERPLEXITY_KEY}",
            "Content-Type": "application/json"
        }
    
    def search(self, query: str, model: str = "sonar-pro", stream: bool = False):
        """Thực thi tìm kiếm RAG với tùy chọn streaming."""
        payload = {
            "model": model,
            "messages": [
                {
                    "role": "system",
                    "content": "Cung cấp câu trả lờ chính xác, có nguồn gốc rõ ràng với trích dẫn."
                },
                {"role": "user", "content": query}
            ],
            "stream": stream,
            "return_citations": True,
            "max_tokens": 2048
        }
        
        response = requests.post(
            f"{BASE_URL}/chat/completions",
            headers=self.headers,
            json=payload,
            stream=stream
        )
        response.raise_for_status()
        return response

service = RAGSearchService()

@app.route("/search", methods=["POST"])
def search():
    """Điểm cuối tìm kiếm RAG đồng bộ."""
    data = request.get_json()
    query = data.get("query", "")
    model = data.get("model", "sonar-pro")
    
    if not query:
        return jsonify({"error": "Cần có truy vấn"}), 400
    
    try:
        result = service.search(query, model=model)
        data = result.json()
        
        message = data["choices"][0]["message"]
        return jsonify({
            "answer": message["content"],
            "citations": message.get("citations", []),
            "model": model,
            "usage": data.get("usage", {})
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/search/stream", methods=["POST"])
def search_stream():
    """Điểm cuối tìm kiếm RAG streaming với Server-Sent Events."""
    data = request.get_json()
    query = data.get("query", "")
    model = data.get("model", "sonar-pro")
    
    if not query:
        return jsonify({"error": "Cần có truy vấn"}), 400
    
    def generate():
        response = service.search(query, model=model, stream=True)
        for line in response.iter_lines():
            if line:
                decoded = line.decode("utf-8")
                if decoded.startswith("data: "):
                    yield f"{decoded}\n\n"
    
    return Response(
        generate(),
        mimetype="text/event-stream",
        headers={"Cache-Control": "no-cache"}
    )

@app.route("/health", methods=["GET"])
def health():
    """Điểm cuối kiểm tra sức khỏe."""
    return jsonify({"status": "healthy", "service": "rag-search"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
```

```bash
# Dockerfile để triển khai container
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
ENV PERPLEXITY_API_KEY=""
ENV FLASK_ENV=production

EXPOSE 5000
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
```

```yaml
# docker-compose.yml
version: "3.8"
services:
  rag-search:
    build: .
    ports:
      - "5000:5000"
    environment:
      - PERPLEXITY_API_KEY=${PERPLEXITY_API_KEY}
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

---

## FAQ

### Perplexity API khác với API GPT của OpenAI như thế nào?

Perplexity API tự động thực hiện tìm kiếm web trực tiếp và tiêm trích dẫn, trong khi API của OpenAI dựa vào dữ liệu huấn luyện trừ khi bạn tự triển khai RAG với cơ sở dữ liệu vector bên ngoài. Perplexity xử lý truy xuất, xếp hạng và căn cứ nội bộ, cung cấp giải pháp RAG all-in-one.

### Giớ hạn tốc độ cho Perplexity API là gì?

Giớ hạn tốc độ thay đổi theo cấp đăng ký. Gói miễn phí thường cho phép 20 yêu cầu mỗi phút, trong khi các cấp Pro và Doanh nghiệp mở rộng lên 100-1000+ RPM. Kiểm tra bảng điều khiển nhà phát triển để biết giớ hạn chính xác.

### Tôi có thể sử dụng Perplexity API với tài liệu của riêng mình không?

Hiện tại, Perplexity API tập trung vào tìm kiếm web RAG thay vì tiếp nhận tài liệu riêng tư. Đối với RAG tài liệu tùy chỉnh, bạn cần kết hợp tìm kiếm web của Perplexity với giải pháp cơ sở dữ liệu vector cho nội dung độc quyền của bạn.

### Trích dẫn do Perplexity cung cấp có độ chính xác như thế nào?

Hệ thống trích dẫn của Perplexity có độ chính xác cao, với các nguồn được liên kết trực tiếp đến URL được truy xuất trong giai đoạn tìm kiếm. Các đánh dấu `[1]`, `[2]` trong phản hồi tương ứng chính xác với mảng trích dẫn. Tuy nhiên, hãy luôn xác thực thông tin quan trọng với các nguồn chính.

### Streaming có được hỗ trợ cho tất cả các mô hình Sonar không?

Có, streaming qua Server-Sent Events được hỗ trợ trên tất cả các biến thể mô hình Sonar. Triển khai streaming tuân theo định dạng tương thích OpenAI, giúp dễ dàng điều chỉnh các máy khách streaming hiện có.

### Mô hình định giá của Perplexity API là gì?

Perplexity sử dụng mô hình định giá kết hợp dựa trên khối lượng truy vấn và mức tiêu thụ token. Sonar cơ bản là kinh tế nhất, trong khi Sonar Deep Research phát sinh chi phí cao hơn do truy xuất đa bước mở rộng.

### Tôi có thể lọc tìm kiếm đến các miền hoặc phạm vi ngày cụ thể không?

Có, API hỗ trợ `search_domain_filter` để giớ hạn truy vấn vào các miền cụ thể và `search_recency_filter` để giớ hạn kết quả theo thờigian gần đây. Các tham số này giúp đảm bảo nguồn có thẩm quyền và kịp thờ.

---



## Hosting Và Hạ Tầng Được Đề Xuất

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit $200 trong 60 ngày.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Kết luận

Perplexity API đại diện cho một bước tiến đáng kể trong công nghệ RAG có thể truy cập được cho nhà phát triển. Bằng cách kết hợp lập chỉ mục web trực tiếp, nhiều mô hình Sonar chuyên biệt, trích dẫn minh bạch và giao diện tương thích OpenAI, nó loại bỏ sự phức tạp về cơ sở hạ tầng thường liên quan đến retrieval-augmented generation.

Đối với các nhà phát triển xây dựng thế hệ ứng dụng thông minh tiếp theo — từ trợ lý nghiên cứu và công cụ kiểm tra sự thật đến cơ sở kiến thức động và hệ thống xác minh nội dung — Perplexity cung cấp một con đường trực tiếp đến RAG cấp sản xuất mà không cần quản lý cơ sở dữ liệu vector, đường ống embedding hoặc điều chỉnh độ liên quan.

Khi chúng ta bước qua năm 2026, kỳ vọng rằng các ứng dụng AI cung cấp câu trả lờ có nguồn gốc, có thể xác minh đang trở thành tiêu chuẩn, không phải ngoại lệ. Tích hợp API tìm kiếm RAG của Perplexity định vị các ứng dụng của bạn để đáp ứng kỳ vọng này, mang lại trải nghiệm mà ngườ dùng có thể tin tưởng vì mọi câu trả lờ đều dựa trên nền tảng của các nguồn thực, có thể trích dẫn.
