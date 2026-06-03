---
title: 'Firecrawl: Biến mọi website thành dữ liệu sẵn sàng cho LLM (127K Stars) — Hướng dẫn thực chiến 2026'
description: 'Firecrawl là API dữ liệu web mã nguồn mở giúp scrape, crawl, map và search web thành Markdown sạch hoặc JSON có cấu trúc, sẵn sàng cho LLM. 127,747 sao GitHub, giấy phép AGPL-3.0. Bao gồm cài đặt, các SDK chính thức, code thực tế, self-host và so sánh thẳng thắn với Puppeteer, Scrapy, Axios.'
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
github_repo: 'firecrawl/firecrawl'
stars: 127747
maintainer: 'firecrawl'
last_maintained: '2026-06-02'
featureImage: 'https://raw.githubusercontent.com/firecrawl/firecrawl/main/img/open-source-cloud.png'
draft: false
categories: ['dev-utils']
tags: []
aliases:
- /posts/firecrawl-dev-utils-2026/
faqs:
  - q: 'Tôi cài Firecrawl như thế nào?'
    a: 'Hãy cài một trong các SDK chính thức. Với Node.js: ```bash npm install firecrawl ``` Với Python: ```bash pip install firecrawl-py ``` Sau đó tạo một client bằng API key lấy từ [firecrawl.dev](https://firecrawl.dev).'
  - q: 'Tôi có thể dùng Firecrawl với các ngôn ngữ khác ngoài TypeScript không?'
    a: 'Có. Firecrawl là một HTTP API, nên bất kỳ ngôn ngữ nào cũng có thể gọi nó. Có SDK chính thức cho Node.js và Python, và với các ngôn ngữ khác bạn có thể gọi trực tiếp các endpoint REST bằng một HTTP client bất kỳ.'
  - q: 'Tôi bắt buộc phải dùng API được lưu trữ, hay có thể self-host?'
    a: 'Cả hai đều được hỗ trợ. API được lưu trữ tại `api.firecrawl.dev` là cách bắt đầu nhanh nhất, nhưng bản thân dự án là mã nguồn mở và đi kèm cấu hình Docker Compose, nên bạn có thể chạy toàn bộ trên máy chủ của riêng mình.'
  - q: 'Sự khác biệt giữa scrape, crawl và map là gì?'
    a: '`scrape` xử lý một URL. `crawl` đi theo các liên kết để scrape toàn bộ một website một cách bất đồng bộ. `map` chỉ trả về danh sách URL trên một site mà không scrape nội dung của chúng — hữu ích để lập kế hoạch crawl.'
  - q: 'Firecrawl có miễn phí không, và giấy phép của nó là gì?'
    a: 'Mã nguồn miễn phí và mở theo AGPL-3.0, còn các SDK chính thức và thành phần UI theo MIT. API đám mây được lưu trữ có một bậc miễn phí cùng các gói trả phí cho mức dùng cao hơn. Nếu self-host, bạn tự chịu chi phí hạ tầng để vận hành.'
---

{{< resource-info >}}

## Giới thiệu

Nếu bạn từng thử đưa các trang web vào LLM, bạn hiểu nỗi khổ này: HTML thô đầy thanh điều hướng, quảng cáo, script và bố cục vỡ, vừa lãng phí token vừa làm rối mô hình. **Firecrawl** giải quyết đúng vấn đề đó. Đây là một API dữ liệu web mã nguồn mở, nhận bất kỳ URL nào — hoặc cả một website — và trả về Markdown sạch, JSON có cấu trúc, hoặc ảnh chụp màn hình, sẵn sàng cho LLM. Với hơn 127.000 sao trên GitHub, nó đã trở thành một trong những công cụ phổ biến nhất để biến web thành dữ liệu mà ứng dụng AI của bạn có thể dùng được thật sự. Hướng dẫn này sẽ đưa bạn qua: Firecrawl làm được gì, cách cài đặt, code chạy thực tế, self-host, và cách nó so với các lựa chọn thay thế quen thuộc.

![firecrawl overview, via dibi8.com](https://raw.githubusercontent.com/firecrawl/firecrawl/main/img/open-source-cloud.png)

*firecrawl overview (source: firecrawl/firecrawl repo, via dibi8 analysis)*

## Firecrawl là gì?

Firecrawl là một API dữ liệu web để tìm kiếm, scrape và crawl website ở quy mô lớn, với mục tiêu rõ ràng là tạo ra đầu ra sẵn sàng cho LLM. Thay vì trả về HTML thô, nó xử lý những phần khó nhằn — render JavaScript, proxy, cơ chế chống bot và làm sạch nội dung — rồi đưa cho bạn Markdown hoặc JSON có cấu trúc.

Nó được cung cấp theo hai cách: một API đám mây được lưu trữ tại `api.firecrawl.dev` (bạn đăng ký để lấy API key), và một phiên bản mã nguồn mở hoàn toàn mà bạn có thể tự lưu trữ (self-host) bằng Docker. Phần lõi phát hành theo giấy phép AGPL-3.0, còn các SDK chính thức và thành phần UI dùng giấy phép MIT. Với hơn 127.000 sao GitHub và được đội ngũ Firecrawl bảo trì tích cực, đây là một lựa chọn đáng tin cậy cho các pipeline dữ liệu AI ở môi trường sản xuất.

## Firecrawl hoạt động thế nào

Firecrawl phơi bày một nhóm nhỏ các endpoint, mỗi cái giải quyết đúng một việc. Bạn xác thực bằng Bearer API key (định dạng `fc-...`) và gọi cái mình cần:

1. **Scrape** — Chuyển một URL đơn lẻ thành Markdown, HTML, ảnh chụp màn hình, hoặc JSON có cấu trúc. Firecrawl render JavaScript và loại bỏ phần thừa giúp bạn.

2. **Crawl** — Chỉ cần đưa một URL, Firecrawl sẽ khám phá và scrape mọi trang truy cập được trên website, đồng thời tôn trọng `robots.txt`. Crawl chạy bất đồng bộ: bạn khởi động một tác vụ rồi poll để lấy kết quả.

3. **Map** — Trả về ngay lập tức tất cả URL trên một website, hữu ích để lập kế hoạch crawl hoặc dựng sitemap.

4. **Search** — Truy vấn web và nhận về toàn bộ nội dung trang của các kết quả, chứ không chỉ là liên kết.

5. **Interact & Extract** — Thực hiện hành động trên trang (click, cuộn, gõ) trước khi scrape, và rút trích dữ liệu có cấu trúc theo schema bạn định nghĩa.

Một lần scrape tối giản với Node SDK trông như sau:

```typescript
import { Firecrawl } from 'firecrawl';

const app = new Firecrawl({ apiKey: 'fc-YOUR_API_KEY' });

const doc = await app.scrape('https://example.com', {
  formats: ['markdown'],
});

console.log(doc.markdown);
```

Firecrawl là một dự án mã nguồn mở trưởng thành với một cộng đồng lớn phía sau, điều này được phản ánh qua con số 127k+ sao trên GitHub.

![firecrawl architecture, via dibi8.com](https://raw.githubusercontent.com/firecrawl/firecrawl/main/img/firecrawl_logo.png)

*firecrawl architecture (source: firecrawl/firecrawl repo, via dibi8 analysis)*

## Cài đặt và thiết lập

Với hầu hết người dùng, con đường nhanh nhất là dùng API được lưu trữ: đăng ký tại [firecrawl.dev](https://firecrawl.dev), lấy API key, rồi cài một SDK. Nếu muốn self-host, bạn sẽ cần một máy luôn bật — khởi tạo một máy trên [DigitalOcean](https://m.do.co/c/eca87ac14ee0) (tài khoản mới có tín dụng dùng thử miễn phí), hoặc [HTStack](https://my.htstack.com/aff.php?aff=27187) cho VPS Hong Kong độ trễ thấp (cùng IDC đang host dibi8.com).

### Node.js SDK

```bash
npm install firecrawl
```

```typescript
import { Firecrawl } from 'firecrawl';

const app = new Firecrawl({ apiKey: 'fc-YOUR_API_KEY' });
```

### Python SDK

```bash
pip install firecrawl-py
```

```python
from firecrawl import Firecrawl

app = Firecrawl(api_key="fc-YOUR_API_KEY")
```

### Self-host bằng Docker

Nếu bạn thích chạy Firecrawl trên hạ tầng của riêng mình, hãy clone repo và dùng cấu hình Docker Compose đi kèm:

```bash
git clone https://github.com/firecrawl/firecrawl.git
cd firecrawl
docker compose up
```

Lệnh này khởi chạy API và các worker của nó. Theo mặc định, API lắng nghe ở cổng `3002`, nên bạn có thể truy cập qua `http://localhost:3002`. Để trỏ SDK tới instance self-host, chỉ cần đặt URL của API:

```typescript
const app = new Firecrawl({
  apiKey: 'fc-YOUR_API_KEY',
  apiUrl: 'http://localhost:3002',
});
```

### Cấu hình

Self-host được cấu hình thông qua biến môi trường. Sao chép mẫu được cung cấp và chỉnh sửa:

```bash
cp apps/api/.env.example apps/api/.env
```

Các khóa thường đặt gồm `PORT`, `NUM_WORKERS_PER_QUEUE`, và các tích hợp tùy chọn cho proxy và render. Xem hướng dẫn self-host trong repo để có danh sách đầy đủ. Với API được lưu trữ, bạn bỏ qua tất cả những thứ này — thiết lập bắt buộc duy nhất là API key.

## Cách dùng cốt lõi

Dưới đây là các thao tác phổ biến nhất với API được lưu trữ, dùng Node SDK. Python SDK có các phương thức tương ứng một-một.

### Scrape một trang đơn lẻ

```typescript
import { Firecrawl } from 'firecrawl';

const app = new Firecrawl({ apiKey: 'fc-YOUR_API_KEY' });

const doc = await app.scrape('https://example.com', {
  formats: ['markdown', 'html'],
});

console.log(doc.markdown);
```

### Crawl toàn bộ website

`crawl` khám phá và scrape mọi trang truy cập được. Bạn có thể giới hạn số trang và giới hạn độ sâu:

```typescript
const result = await app.crawl('https://example.com', {
  limit: 100,
  scrapeOptions: { formats: ['markdown'] },
});

for (const page of result.data) {
  console.log(page.metadata?.sourceURL, page.markdown?.slice(0, 80));
}
```

### Rút trích dữ liệu có cấu trúc

Truyền vào một JSON schema và Firecrawl trả về dữ liệu có kiểu thay vì văn bản thô — lý tưởng để lấy tiêu đề, giá, hay bất kỳ trường cố định nào:

```typescript
const doc = await app.scrape('https://example.com', {
  formats: [{
    type: 'json',
    schema: {
      type: 'object',
      properties: {
        title: { type: 'string' },
        description: { type: 'string' },
      },
    },
  }],
});

console.log(doc.json);
```

Để biết chi tiết đầy đủ, hãy xem [tài liệu chính thức](https://docs.firecrawl.dev).

## Tích hợp

Vì Firecrawl về cơ bản chỉ là một HTTP API với các SDK mỏng, nó hòa nhập vào hầu như mọi stack — Next.js, Express, một pipeline dữ liệu Python, hay một ứng dụng RAG dùng LangChain / LlamaIndex nơi nó đóng vai trò document loader.

### Dùng trong một route phía server

Một mẫu điển hình là bọc thao tác scrape sau endpoint của chính bạn:

```typescript
import { Firecrawl } from 'firecrawl';

const app = new Firecrawl({ apiKey: process.env.FIRECRAWL_API_KEY });

export async function scrapeHandler(url: string) {
  const doc = await app.scrape(url, { formats: ['markdown'] });
  return doc.markdown;
}
```

### Chạy crawl theo lịch trong CI/CD

Với các tác vụ định kỳ, hãy chạy Firecrawl từ GitHub Actions, GitLab CI, hoặc bất kỳ trình lập lịch nào. Dưới đây là một workflow GitHub Actions đơn giản, scrape một trang ở mỗi lần push và lưu Markdown:

```yaml
name: Firecrawl Scraper

on:
  push:
    branches: [ main ]

jobs:
  scrape:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm install firecrawl

      - name: Run scraper
        env:
          FIRECRAWL_API_KEY: ${{ secrets.FIRECRAWL_API_KEY }}
        run: node scrape.js > output.json
```

Cách này giữ cho các tác vụ scrape được tự động hóa và có thể tái lập, với API key được lưu trong secrets của repo thay vì viết cứng trong code.

### Tóm lại

Thiết kế ưu tiên API của Firecrawl giúp dễ dàng thêm nó vào một dự án sẵn có. Dù bạn đang cấp dữ liệu cho một pipeline RAG hay làm mới một tập dữ liệu theo lịch, chỉ vài dòng code là xong.

## Benchmark và thực tế sử dụng

Firecrawl được dùng trong nhiều kịch bản sản xuất khác nhau. Các con số dưới đây mang tính minh họa cho loại khối lượng công việc mà các đội thường chạy, không phải benchmark chính thức từ nhà cung cấp.

### Các trường hợp sử dụng thực tế

#### Cấp dữ liệu cho RAG và tìm kiếm AI
Nhiều đội dùng Firecrawl làm tầng nạp dữ liệu cho retrieval-augmented generation (RAG): crawl một site tài liệu hoặc cơ sở tri thức, lấy Markdown sạch, chia chunk rồi embed. Đầu ra sẵn sàng cho LLM loại bỏ phần lớn công đoạn tiền xử lý mà việc scrape HTML thô thường đòi hỏi.

#### Giám sát đối thủ và thương mại điện tử
Các đội crawl trang sản phẩm và giá theo lịch để giữ danh mục và dữ liệu so giá luôn cập nhật. Nhờ render JavaScript, các gian hàng dạng single-page app (SPA) vẫn hoạt động mà không cần viết tự động hóa trình duyệt riêng.

#### Kiểm toán SEO và nội dung quy mô lớn
Các agency chạy crawl trên các site lớn để kiểm kê trang, phát hiện liên kết hỏng, và đánh dấu nội dung lỗi thời. Endpoint `map` rất tiện ở đây — lấy danh sách URL đầy đủ trước khi bắt tay vào một lần crawl sâu hơn.

### Lưu ý về hiệu năng

Thông lượng trên API được lưu trữ phụ thuộc vào giới hạn đồng thời của gói bạn dùng, cũng như vào cơ chế giới hạn tốc độ và chống bot của chính site đích. Self-host cho phép bạn tinh chỉnh độ đồng thời bằng `NUM_WORKERS_PER_QUEUE`, nhưng khi đó bạn phải tự gánh hạ tầng proxy và render. Một quy tắc kinh nghiệm: hãy lập kế hoạch cho các tác vụ crawl theo đơn vị số-trang-mỗi-phút, thay vì xem Firecrawl như một tầng request thời gian thực dưới 100 mili-giây.

![firecrawl contributors, via dibi8.com](https://contrib.rocks/image?repo=firecrawl/firecrawl)

*firecrawl contributors (source: firecrawl/firecrawl repo, via dibi8 analysis)*

## So sánh với các lựa chọn thay thế

Xem thêm bài [các công cụ mã nguồn mở liên quan](dibi8-internal-link) của chúng tôi.

Sẽ hữu ích khi nói rõ Firecrawl là gì và không là gì. Firecrawl là một API dữ liệu web được quản lý (hoặc có thể self-host), tập trung vào đầu ra sẵn sàng cho LLM. Puppeteer là một thư viện tự động hóa trình duyệt, Scrapy là một framework crawl bằng Python, còn Axios là một HTTP client thông dụng. Chúng có giao nhau ở chỗ "lấy dữ liệu từ web", nhưng nằm ở các tầng khác nhau.

| Tính năng          | firecrawl/firecrawl      | Puppeteer               | Scrapy                  | Axios                   |
|--------------------|--------------------------|-------------------------|-------------------------|-------------------------|
| **Stars**          | 127,747                  | ~90k                    | ~55k                    | ~107k                   |
| **Loại**           | API dữ liệu web          | Thư viện tự động hóa trình duyệt | Framework crawl    | HTTP client             |
| **Ngôn ngữ**       | TypeScript               | JavaScript              | Python                  | JavaScript              |
| **Giấy phép**      | AGPL-3.0 (SDK là MIT)    | Apache-2.0              | BSD-3-Clause            | MIT                     |
| **Render JS**      | Tích hợp sẵn             | Có (nó chính là trình duyệt) | Cần thêm thành phần | Không                   |
| **Đầu ra cho LLM** | Sẵn Markdown / JSON      | Tự làm                  | Tự làm                  | Tự làm                  |
| **Tùy chọn host**  | Có (API đám mây)         | Không                   | Không                   | Không                   |
| **Self-host**      | Có (Docker)              | Không áp dụng (thư viện) | Không áp dụng (thư viện) | Không áp dụng (thư viện) |
| **Hợp nhất cho**   | Pipeline web → dữ liệu LLM | Tác vụ trình duyệt bằng script | Crawl lớn tùy biến | Gọi HTTP đơn giản       |

Firecrawl nổi bật khi mục tiêu của bạn là *dữ liệu sạch cho LLM* với ít công ghép nối nhất: nó xử lý render, làm sạch và crawl phía sau một API duy nhất. Puppeteer cho bạn toàn quyền kiểm soát một trình duyệt thật, nhưng bạn phải tự dựng mọi thứ (làm sạch, xếp hàng, mở rộng). Scrapy tuyệt vời cho các lần crawl lớn, tùy biến nếu bạn thoải mái với Python và sẵn lòng viết spider. Axios chỉ là một HTTP client — ổn để gọi một API, nhưng không render cũng không rút trích.

Với các lập trình viên muốn có dữ liệu web sẵn sàng cho LLM với lượng code keo nối ít nhất, Firecrawl là lựa chọn trực tiếp nhất trong bốn cái.

## Hạn chế và đánh giá thẳng thắn

Firecrawl là một công cụ mạnh, nhưng không phải lựa chọn phù hợp cho mọi việc:

1. **Không phải tầng thời gian thực, độ trễ thấp**: Crawl chạy như các tác vụ bất đồng bộ mà bạn phải poll để lấy kết quả, và ngay cả một lần scrape đơn lẻ cũng liên quan đến render và làm sạch. Nếu bạn cần phản hồi dưới 100 mili-giây cho mọi request, hãy đặt một lớp cache phía trước hoặc xem lại kiến trúc.

2. **Chống scraping vẫn là chuyện khó**: Firecrawl xử lý nhiều cơ chế chống bot và cung cấp tùy chọn proxy, nhưng không công cụ nào vượt qua được một cách đáng tin các site có bảo vệ nghiêm ngặt hoặc giới hạn tốc độ gắt gao. Hãy lường trước việc một số đích đến sẽ chặn hoặc throttle bạn, và tôn trọng điều khoản dịch vụ của từng site.

3. **Phần lõi theo AGPL-3.0**: API được lưu trữ và các SDK giấy phép MIT thì ổn cho ứng dụng nguồn đóng, nhưng nếu bạn self-host và sửa đổi phần lõi AGPL-3.0, các điều khoản copyleft sẽ áp dụng. Hãy cùng đội ngũ rà soát giấy phép trước khi xây dựng trên một bản fork của phần lõi.

4. **Chi phí và hạn mức của gói được lưu trữ**: API đám mây tính phí theo mức dùng. Các lần crawl lớn tiêu tốn tín dụng rất nhanh, nên với khối lượng rất cao, bạn nên so sánh hóa đơn của bản được lưu trữ với chi phí vận hành của self-host.

5. **Tuân thủ vẫn là việc của bạn**: Firecrawl giúp việc scrape trở nên dễ dàng, nhưng nó không quyết định bạn được phép scrape gì. Tôn trọng `robots.txt`, điều khoản dịch vụ và các quy định bảo vệ dữ liệu là trách nhiệm của bạn.

Chính những đánh đổi này khiến việc đánh giá kỹ trường hợp sử dụng của bạn trước khi áp dụng Firecrawl là điều đáng làm.

## Kết luận

Firecrawl là một trong những cách thực dụng nhất để biến web mở thành dữ liệu mà LLM thật sự dùng được, với hơn 127k sao GitHub và một đội ngũ năng động phía sau. Thiết kế ưu tiên API của nó — scrape, crawl, map, search, extract — nghĩa là bạn có thể đi từ một URL đến Markdown sạch chỉ trong vài dòng, dù dùng đám mây được lưu trữ hay self-host bằng Docker. Bước tiếp theo tự nhiên là lấy một API key, chạy một lần scrape trên một trang bạn quan tâm, và tận mắt thấy phần đầu ra đã được làm sạch.

Việc scrape quy mô lớn cần proxy xoay vòng — [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f) là lựa chọn tiêu chuẩn.

- Tham gia [nhóm Telegram tiếng Anh của dibi8](https://t.me/DIBI8_Group/2) để nhận tin về các công cụ AI mã nguồn mở.
- Đọc tiếp: [các hướng dẫn liên quan trên dibi8](dibi8-internal-link).

---

**Nguồn & Đọc thêm**:
- Kho GitHub: https://github.com/firecrawl/firecrawl
- Tài liệu chính thức: https://docs.firecrawl.dev

*Một số liên kết ở trên là liên kết tiếp thị (affiliate). dibi8.com có thể nhận hoa hồng nếu bạn đăng ký, mà bạn không tốn thêm chi phí nào. Điều này giúp duy trì hoạt động của trang và giữ cho nội dung miễn phí.*

<!-- internal-link-candidates:
  related open-source tools -> ai-tools-directory
  related guides on dibi8 -> ai-coding-agent-landscape-2026-skills-mcp-opensource
-->
