---
title: 'Skyvern: Tự động hóa quy trình duyệt web bằng AI Agent (21K Sao) — Hướng dẫn Thực tế 2026'
description: 'Skyvern tự động hóa các quy trình trên trình duyệt bằng mô hình ngôn ngữ lớn và thị giác máy tính (21.803 sao GitHub, AGPL-3.0). Bao gồm cài đặt, API Python thực tế, ví dụ mã chạy được và so sánh thẳng thắn với Selenium và Playwright.'
date: 2026-06-02 00:00:00+08:00
lastmod: 2026-06-02 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'Skyvern-AI/skyvern'
stars: 21803
maintainer: 'Skyvern-AI'
last_maintained: '2026-06-02'
featureImage: 'https://raw.githubusercontent.com/Skyvern-AI/skyvern/main/fern/images/skyvern_logo_blackbg.png'
draft: false
categories: ['dev-utils']
tags: []
aliases:
- /posts/skyvern-dev-utils-2026/
faqs:
  - q: 'Tôi cài Skyvern-AI/skyvern như thế nào?'
    a: 'Cài bằng pip và chạy quickstart: ```bash pip install "skyvern[all]" skyvern quickstart ``` quickstart giúp bạn cấu hình một nhà cung cấp LLM và khởi chạy máy chủ cùng UI cục bộ.'
  - q: 'Yêu cầu hệ thống để chạy Skyvern-AI/skyvern là gì?'
    a: 'Skyvern cần Python 3.11 trở lên và ít nhất một LLM API key (OpenAI, Anthropic, Gemini, Bedrock, hoặc một mô hình cục bộ qua Ollama). Một máy hiện đại với vài GB RAM là đủ để dùng cục bộ; còn các tác vụ sản xuất theo lịch tốt nhất nên chạy trên một máy chủ luôn bật.'
  - q: 'Tôi có thể dùng Skyvern-AI/skyvern cho dự án thương mại không?'
    a: 'Có. Giấy phép AGPL-3.0 cho phép sử dụng thương mại, nhưng nếu bạn sửa đổi Skyvern rồi phân phối hoặc cung cấp nó như một dịch vụ mạng, các thay đổi của bạn phải được phát hành theo AGPL-3.0. Các nhóm muốn tránh nghĩa vụ này có thể dùng phiên bản đám mây được host thay thế.'
  - q: 'Tôi đóng góp cho dự án Skyvern-AI/skyvern bằng cách nào?'
    a: 'Rất hoan nghênh đóng góp. Bạn có thể báo lỗi hoặc mở pull request trên GitHub; cộng đồng rất tích cực và phản hồi nhanh với các bản sửa lỗi và tính năng mới.'
  - q: 'Tôi có thể tìm thêm thông tin về cách dùng Skyvern-AI/skyvern ở đâu?'
    a: 'Xem trang chính thức tại <https://www.skyvern.com> và README trên GitHub, cả hai đều trình bày chi tiết về cài đặt, API và các quy trình mẫu.'
---

{{< resource-info >}}

## Giới thiệu

Bạn đã bao giờ viết kịch bản cho một tác vụ trên trình duyệt bằng Selenium hay Playwright, để rồi nhìn nó hỏng ngay khi trang web đổi một tên lớp CSS hoặc dời một cái nút? Với hơn 21.803 sao trên GitHub, [Skyvern-AI/skyvern](https://github.com/Skyvern-AI/skyvern) chọn một cách tiếp cận khác: thay vì gắn cứng selector cho từng trang, nó dùng mô hình ngôn ngữ lớn cộng với thị giác máy tính để hiểu trang web theo cách một con người sẽ làm, rồi hoàn thành tác vụ mà bạn mô tả bằng ngôn ngữ tự nhiên. Hướng dẫn này sẽ dẫn bạn qua việc thiết lập Skyvern và sử dụng API thực tế của nó.

![skyvern overview, via dibi8.com](https://raw.githubusercontent.com/Skyvern-AI/skyvern/main/fern/images/skyvern_logo_blackbg.png)

*Tổng quan skyvern (nguồn: kho Skyvern-AI/skyvern, qua phân tích của dibi8)*

## Skyvern là gì?

Skyvern là một công cụ mã nguồn mở tự động hóa các quy trình trên trình duyệt bằng AI agent. Do Skyvern-AI phát triển, nó cho phép bạn mô tả một mục tiêu bằng ngôn ngữ tự nhiên — "đăng nhập và tải hóa đơn tháng trước", "điền vào đơn đăng ký này", "trích xuất mọi tên sản phẩm và giá" — và agent sẽ tự tìm cách thực hiện điều đó trong một trình duyệt thật.

Ý tưởng cốt lõi là Skyvern suy luận về mỗi trang một cách trực quan thay vì dựa vào XPath hay CSS selector dễ vỡ. Vì nó diễn giải DOM trực tiếp cùng ảnh chụp màn hình đã render bằng một LLM có khả năng thị giác, cùng một quy trình có thể tiếp tục hoạt động trên hàng nghìn trang web khác nhau, và nó thường sống sót qua những thay đổi bố cục vốn làm hỏng một kịch bản truyền thống.

Với sự hậu thuẫn mạnh mẽ của cộng đồng — hơn 21.803 sao trên GitHub — Skyvern đã thu hút được sự quan tâm thực sự từ các lập trình viên đang tìm kiếm giải pháp tự động hóa bền bỉ.

## Skyvern hoạt động như thế nào

Skyvern kết hợp nhiều thành phần để biến một chỉ dẫn bằng ngôn ngữ tự nhiên thành các thao tác trình duyệt đáng tin cậy:

1. **Lập kế hoạch dựa trên LLM**: Bạn cung cấp một prompt mô tả mục tiêu. Một mô hình ngôn ngữ lớn chia nhỏ nó thành các bước cụ thể cần thiết để đạt được. Skyvern không phụ thuộc vào một mô hình cụ thể và hỗ trợ OpenAI, Anthropic Claude, Google Gemini, AWS Bedrock, cùng các mô hình cục bộ thông qua Ollama, và nhiều hơn nữa.
2. **Thị giác máy tính để nhận diện phần tử**: Thay vì dựa vào selector cố định, Skyvern đưa trang đã render (DOM cộng ảnh chụp màn hình) cho một LLM có khả năng thị giác để xác định đúng phần tử cần nhấp, gõ vào hoặc đọc từ đó. Đây chính là điều khiến nó vững vàng trước thay đổi bố cục.
3. **Playwright để điều khiển trình duyệt**: Việc nhấp, gõ và điều hướng thực sự chạy trên Playwright, một framework tự động hóa trình duyệt trưởng thành, nên Skyvern kế thừa khả năng hỗ trợ vững chắc cho các ứng dụng web hiện đại.

Bên dưới, mỗi tác vụ được lưu trong một cơ sở dữ liệu cục bộ (mặc định là SQLite, hoặc Postgres), giúp các lần chạy có thể tái lập và cho phép bạn xem agent đã làm gì theo từng bước.

![skyvern in action, via dibi8.com](https://raw.githubusercontent.com/Skyvern-AI/skyvern/main/fern/images/geico_shu_recording_cropped.gif)

*skyvern khi hoạt động (nguồn: kho Skyvern-AI/skyvern, qua phân tích của dibi8)*

## Cài đặt & Thiết lập

Để chạy Skyvern như một tác vụ sản xuất được lên lịch, bạn cần một máy luôn bật — hãy dựng một cái trên [DigitalOcean](https://m.do.co/c/eca87ac14ee0) (tín dụng dùng thử miễn phí cho tài khoản mới), hoặc [HTStack](https://my.htstack.com/aff.php?aff=27187) cho VPS Hồng Kông độ trễ thấp (cùng IDC đang host dibi8.com).

Cài đặt Skyvern khá đơn giản nếu bạn quen với Python. Bạn cần Python 3.11 trở lên và ít nhất một LLM API key.

### Dùng `pip`

Cài gói đầy đủ, bao gồm cả UI và máy chủ cục bộ:

```bash
pip install "skyvern[all]"
```

Nếu bạn chỉ cần SDK để gọi Skyvern từ mã của mình, bản cài nhẹ hơn là đủ:

```bash
pip install skyvern
```

### Bắt đầu nhanh

Sau khi cài, cách nhanh nhất để có một môi trường hoạt động là lệnh quickstart đi kèm. Nó hướng dẫn bạn cấu hình nhà cung cấp LLM, rồi khởi chạy máy chủ cục bộ và giao diện web với SQLite làm backend:

```bash
skyvern quickstart
```

Nếu bạn thích thiết lập dùng Postgres làm backend, hãy truyền cờ:

```bash
skyvern quickstart --postgres
```

Bạn cũng có thể khởi động từng thành phần riêng lẻ:

```bash
skyvern run server   # chỉ máy chủ API
skyvern run ui       # chỉ giao diện web
```

### Cấu hình

Skyvern cần ít nhất một LLM API key, và nó đọc key này từ tệp `.env` trong dự án. Một ví dụ tối thiểu dùng OpenAI trông như sau:

```bash
# .env
ENABLE_OPENAI=true
OPENAI_API_KEY=sk-your-key-here
```

Lệnh quickstart có thể tạo tệp này cho bạn theo kiểu tương tác. Mặc định Skyvern lưu dữ liệu trong cơ sở dữ liệu SQLite cục bộ tại `~/.skyvern/`.

### Lỗi thường gặp và cách khắc phục

Một vấn đề hay gặp khi chạy lần đầu là máy chủ khởi động được nhưng mọi tác vụ đều thất bại vì chưa bật nhà cung cấp LLM nào. Nếu bạn thấy lỗi về mô hình bị thiếu hoặc bị tắt, hãy xác nhận rằng cờ `ENABLE_*` tương ứng và API key đều có mặt trong `.env`, ví dụ:

```bash
ENABLE_ANTHROPIC=true
ANTHROPIC_API_KEY=sk-ant-your-key-here
```

Hãy khởi động lại máy chủ sau khi chỉnh `.env` để các giá trị mới được áp dụng.

## Cách dùng cốt lõi

Skyvern được xây dựng quanh việc chạy các tác vụ agent từ một prompt ngôn ngữ tự nhiên. Hãy cùng xem API thực tế.

### Ví dụ 1: Chạy một tác vụ

Quy trình đơn giản nhất là khởi tạo một client Skyvern cục bộ và gọi `run_task` với một prompt. Agent mở trình duyệt, hoàn thành mục tiêu và trả về kết quả:

```python
import asyncio
from skyvern import Skyvern

async def main():
    skyvern = Skyvern.local()
    task = await skyvern.run_task(
        prompt="Go to news.ycombinator.com and find the title of the top post today",
    )
    print(task)

asyncio.run(main())
```

### Ví dụ 2: Trích xuất dữ liệu có cấu trúc

Khi bạn muốn đầu ra có cấu trúc gọn gàng thay vì văn bản tự do, hãy truyền `data_extraction_schema`. Skyvern trả về các trường được trích xuất khớp với schema của bạn:

```python
import asyncio
from skyvern import Skyvern

async def main():
    skyvern = Skyvern.local()
    task = await skyvern.run_task(
        prompt="Extract the top 3 posts on Hacker News",
        data_extraction_schema={
            "type": "object",
            "properties": {
                "posts": {
                    "type": "array",
                    "items": {
                        "type": "object",
                        "properties": {
                            "title": {"type": "string"},
                            "points": {"type": "integer"},
                        },
                    },
                }
            },
        },
    )
    print(task)

asyncio.run(main())
```

### Ví dụ 3: Lệnh cấp trang

Để kiểm soát tinh tế hơn, bạn có thể điều khiển trình duyệt trực tiếp và ra từng lệnh AI riêng lẻ — `act` để làm gì đó, `extract` để đọc dữ liệu, và `validate` để kiểm tra một điều kiện:

```python
import asyncio
from skyvern import Skyvern

async def main():
    skyvern = Skyvern.local()
    browser = await skyvern.launch_cloud_browser()
    page = await browser.get_working_page()

    await page.act("Click the login button")
    data = await page.extract("Get the product name and price")
    await page.validate("Confirm the user is logged in")
    print(data)

asyncio.run(main())
```

Những ví dụ này bao quát các điểm vào chính: `run_task` cấp cao cho mục tiêu đầu-cuối, trích xuất dựa trên schema để có dữ liệu gọn gàng, và lệnh cấp trang khi bạn cần kiểm soát từng bước.

- **Image**: ![](https://raw.githubusercontent.com/Skyvern-AI/skyvern/main/fern/images/skyvern_2_0_screenshot.png)
- **Stars**: 21,803
- **License**: AGPL-3.0
- **Maintainer**: Skyvern-AI
- **Homepage**: <https://www.skyvern.com>
- **Language**: Python

## Tích hợp

Skyvern hòa vào một codebase Python sẵn có mà không cần nhiều thủ tục, vì SDK chỉ là một client bất đồng bộ mà bạn có thể gọi từ bất cứ đâu.

### Gọi Skyvern từ một dịch vụ web

Vì `run_task` là bất đồng bộ, nó ăn khớp tự nhiên với một framework web bất đồng bộ. Dưới đây là cách gắn nó vào một endpoint FastAPI khởi động một tác vụ theo yêu cầu:

```python
from fastapi import FastAPI
from skyvern import Skyvern

app = FastAPI()
skyvern = Skyvern.local()

@app.get("/automate")
async def automate():
    task = await skyvern.run_task(
        prompt="Go to example.com and click the Submit button",
    )
    return {"result": task}
```

### Cấu hình qua biến môi trường

Với môi trường sản xuất, để thông tin xác thực và lựa chọn nhà cung cấp trong biến môi trường thay vì viết cứng trong mã sẽ gọn gàng hơn. Skyvern đọc chúng khi khởi động, nên tệp `.env` là nơi tự nhiên để quản lý:

```bash
# .env
ENABLE_OPENAI=true
OPENAI_API_KEY=your_api_key_here
```

```python
from dotenv import load_dotenv
from skyvern import Skyvern

load_dotenv()

# Skyvern picks up the LLM provider settings from the environment
skyvern = Skyvern.local()
```

Bằng cách giữ cấu hình trong môi trường, bạn có thể di chuyển cùng một mã giữa cục bộ, staging và sản xuất mà không phải đổi một dòng nào.

## Đánh giá hiệu năng & Ứng dụng thực tế

Skyvern nhắm tới những tác vụ mà độ tin cậy trên nhiều trang web khác nhau quan trọng hơn tốc độ thuần túy. Một vài lĩnh vực nó đã chứng tỏ hữu ích:

### Các trường hợp sử dụng thực tế

1. **Điền biểu mẫu ở quy mô lớn**: Hoàn thành đơn đăng ký, luồng onboarding và biểu mẫu nhập liệu trên các trang không chia sẻ một bố cục chung — cách tiếp cận trực quan nghĩa là một prompt có thể xử lý nhiều biến thể.
2. **Thu thập nội dung động**: Trích xuất dữ liệu có cấu trúc từ những trang nặng JavaScript, nơi mà selector vốn rất dễ vỡ.
3. **Tự động hóa quy trình**: Các tác vụ nhiều bước như đăng nhập, điều hướng và tải tài liệu, mà Skyvern có thể nối lại với nhau và chạy lại theo lịch.

Vì Skyvern suy luận về mỗi trang ngay lúc chạy, nó đánh đổi một chút độ trễ và chi phí LLM để lấy sự bền bỉ: thường chậm hơn và đắt hơn cho mỗi thao tác so với một kịch bản Selenium được tinh chỉnh thủ công, nhưng ít có khả năng hỏng hơn nhiều khi một trang thay đổi.

### Sơ đồ hệ thống

Sơ đồ hệ thống của dự án cho thấy một prompt đi qua khâu lập kế hoạch bằng LLM và nhận diện phần tử dựa trên thị giác như thế nào để biến thành các thao tác trình duyệt của Playwright:

![Skyvern 2.0 System Diagram](https://raw.githubusercontent.com/Skyvern-AI/skyvern/main/fern/images/skyvern_2_0_system_diagram.png)

### Tóm tắt

Với các nhóm coi trọng sự bền bỉ hơn tốc độ tối ưu hóa đến từng chi tiết, Skyvern mang lại một giải pháp có năng lực để tự động hóa các quy trình trên trình duyệt. Giao diện ngôn ngữ tự nhiên và việc xử lý phần tử dựa trên thị giác khiến nó rất phù hợp cho những tác vụ tự động hóa phải hoạt động được trên nhiều trang web.

## So sánh với các giải pháp thay thế

Xem thêm chuyên mục [các công cụ mã nguồn mở liên quan](dibi8-internal-link) của chúng tôi.

Khi chọn một công cụ tự động hóa trình duyệt, việc so sánh các lựa chọn theo quy mô cộng đồng, hướng tiếp cận, độ dễ dùng và mức bảo trì sẽ rất hữu ích. Dưới đây là so sánh Skyvern với hai giải pháp được dùng rộng rãi, Selenium WebDriver và Playwright. Lưu ý rằng Skyvern là một AI agent cấp cao hơn được xây trên một framework như Playwright — chúng giải quyết những bài toán chồng lấn nhưng không hoàn toàn giống nhau.

| Tiêu chí               | Skyvern-AI/skyvern             | Selenium WebDriver        | Playwright                  |
|------------------------|--------------------------------|---------------------------|-----------------------------|
| **Số sao**             | 21.803                         | ~31.000                   | ~75.000                     |
| **Hướng tiếp cận**     | AI agent (LLM + thị giác)      | Kịch bản dựa trên selector| Kịch bản dựa trên selector  |
| **Ngôn ngữ lập trình** | Python                         | Java/Python/JS, v.v.      | JavaScript/Python/.NET/Java |
| **Độ dễ dùng**         | Mô tả mục tiêu bằng ngôn ngữ tự nhiên | Cần selector tường minh | API hiện đại, selector tường minh |
| **Khả năng chịu thay đổi UI** | Cao (không có selector cố định) | Thấp                  | Thấp                        |
| **Tốc độ & chi phí mỗi thao tác** | Chậm hơn, có chi phí LLM mỗi lần chạy | Nhanh, không chi phí LLM | Nhanh, không chi phí LLM |
| **Hỗ trợ trình duyệt** | Chromium qua Playwright        | Nhiều trình duyệt         | Chromium/Firefox/WebKit     |
| **Bảo trì**            | Tích cực                       | Tích cực, trưởng thành    | Tích cực, phát hành thường xuyên |

### So sánh chi tiết

- **Hướng tiếp cận**: Đây là khác biệt cốt lõi. Selenium và Playwright thực thi các selector mà bạn tự viết, nên chúng nhanh và xác định nhưng hỏng khi trang thay đổi. Skyvern mô tả mục tiêu cho một LLM và để thị giác chọn phần tử, đánh đổi tốc độ và chi phí để lấy sự bền bỉ.

- **Độ dễ dùng**: Với những tác vụ mà bạn không muốn bảo trì selector, Skyvern hạ thấp rào cản — bạn viết một prompt. Selenium và Playwright cho bạn quyền kiểm soát chính xác nhưng đòi hỏi bạn phải biết cấu trúc trang.

- **Khi nào chọn cái nào**: Hãy dùng Playwright hoặc Selenium khi bạn kiểm soát trang đích và cần các lần chạy nhanh, lặp lại được. Hãy dùng Skyvern khi bạn cần tự động hóa trên nhiều trang mà mình không kiểm soát, hoặc khi bố cục thay đổi đủ thường xuyên đến mức việc bảo trì selector mới là chi phí thực sự.

## Hạn chế & Đánh giá thẳng thắn

Dù Skyvern là một công cụ mạnh cho tự động hóa trình duyệt bền bỉ, nó có những đánh đổi thực sự đáng để hiểu rõ:

1. **Chi phí và độ trễ của LLM**: Mỗi thao tác liên quan đến ít nhất một lời gọi LLM, nên Skyvern chậm hơn và đắt hơn cho mỗi bước so với một kịch bản viết tay. Với các tác vụ khối lượng lớn, được định nghĩa rõ ràng trên một trang ổn định, một kịch bản Playwright truyền thống có thể là lựa chọn kinh tế hơn.

2. **Giấy phép AGPL-3.0**: Giấy phép AGPL-3.0 yêu cầu các sửa đổi phải được phát hành theo cùng giấy phép nếu bạn phân phối phần mềm hoặc cung cấp nó như một dịch vụ mạng. Đây có thể là một ràng buộc đáng kể với các tổ chức ưa giấy phép thoáng hơn hoặc độc quyền. (Skyvern cũng cung cấp một phiên bản đám mây được host cho các nhóm không muốn tự vận hành.)

3. **Tính phi xác định**: Vì một LLM quyết định mỗi bước, cùng một prompt đôi khi có thể hành xử khác nhau qua các lần chạy. Các tác vụ đòi hỏi hành vi nghiêm ngặt, lặp lại được có thể cần thêm kiểm tra hoặc rào chắn.

4. **Phụ thuộc vào chất lượng mô hình**: Kết quả chỉ tốt ngang với mô hình nền tảng. Các mô hình rẻ hơn hoặc cục bộ có thể chật vật với những trang phức tạp, trong khi các mô hình hàng đầu lại đẩy chi phí mỗi tác vụ lên cao.

5. **Đường cong học tập khi viết prompt**: Dù bạn mô tả mục tiêu bằng ngôn ngữ tự nhiên, việc đạt kết quả đáng tin cậy trên những trang khó vẫn cần luyện tập đôi chút trong việc viết prompt rõ ràng, cụ thể và các schema trích xuất.

Những hạn chế này nghĩa là Skyvern xuất sắc cho tự động hóa bền bỉ, đa trang, nhưng không phải lúc nào cũng là công cụ phù hợp cho khối lượng công việc lớn trên một trang duy nhất, ổn định.

## Kết luận

Skyvern-AI/skyvern là một công cụ có năng lực để tự động hóa các quy trình trên trình duyệt bằng AI, với hơn 21.800 sao và được bảo trì tích cực. Nếu việc tự động hóa của bạn phải sống sót qua những thay đổi bố cục hoặc hoạt động trên nhiều trang mà bạn không kiểm soát, cách tiếp cận "LLM cộng thị giác" của nó là một bước tiến thực sự so với kịch bản dựa trên selector. Hãy vào kho GitHub, chạy `skyvern quickstart`, và thử một prompt của riêng bạn.

- Tham gia [nhóm Telegram tiếng Anh của dibi8](https://t.me/DIBI8_Group/2) để nhận các bản giới thiệu công cụ AI mã nguồn mở.
- Đọc tiếp: [các hướng dẫn liên quan trên dibi8](dibi8-internal-link).

---

**Nguồn & Đọc thêm**:
- Kho GitHub: https://github.com/Skyvern-AI/skyvern
- Tài liệu chính thức / README: https://github.com/Skyvern-AI/skyvern#readme

*Một số liên kết ở trên là liên kết tiếp thị. dibi8.com có thể nhận hoa hồng nếu bạn đăng ký, mà bạn không tốn thêm chi phí nào. Điều này giúp duy trì hoạt động của trang và giữ cho nội dung miễn phí.*

<!-- internal-link-candidates:
  related open-source tools -> ai-tools-directory
  related guides on dibi8 -> ai-coding-agent-landscape-2026-skills-mcp-opensource
-->
