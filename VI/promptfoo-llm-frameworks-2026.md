---
title: 'Promptfoo: Kiểm thử, Đánh giá & Red-Team Prompt LLM của bạn — Hướng dẫn thực chiến 2026'
description: 'Promptfoo là một CLI và thư viện mã nguồn mở để đánh giá và red-team các ứng dụng LLM. Chỉ với cấu hình khai báo đơn giản, bạn có thể so sánh GPT, Claude, Gemini, DeepSeek và tích hợp mượt mà vào CLI lẫn CI/CD. Hướng dẫn 2026 này bao quát cài đặt, promptfooconfig.yaml, assertion và kiểm thử red-team.'
date: 2026-06-02 00:00:00+08:00
lastmod: 2026-06-02 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'promptfoo/promptfoo'
stars: 21825
maintainer: 'promptfoo'
last_maintained: '2026-06-02'
featureImage: 'https://raw.githubusercontent.com/promptfoo/promptfoo/main/site/static/img/claude-vs-gpt-example@2x.png'
draft: false
categories: ['llm-frameworks']
tags: []
aliases:
- /posts/promptfoo-llm-frameworks-2026/
faqs:
  - q: 'Làm sao cài và chạy promptfoo cục bộ?'
    a: 'Con đường nhanh nhất là không cần cài: ```bash npx promptfoo@latest init --example getting-started ``` Để cài toàn cục, dùng `npm install -g promptfoo` (hoặc `brew install promptfoo`, hoặc `pip install promptfoo`). Sau đó chạy `promptfoo eval` để đánh giá và `promptfoo view` để mở trình xem cục bộ.'
  - q: 'Tôi có thể dùng promptfoo với mô hình của riêng mình không?'
    a: 'Có. Promptfoo hỗ trợ nhiều provider — OpenAI, Anthropic, Google, DeepSeek, các mô hình cục bộ và hơn thế. Bạn khai báo từng cái trong danh sách `providers` của `promptfooconfig.yaml` và cung cấp khóa API tương ứng qua biến môi trường.'
  - q: 'Promptfoo so sánh hiệu năng giữa các mô hình khác nhau như thế nào?'
    a: 'Bạn liệt kê nhiều mục dưới `providers`, và promptfoo chạy mọi prompt cùng mọi test case lên từng mục. Sau đó `promptfoo view` hiển thị các đầu ra song song kèm trạng thái đạt/không đạt theo từng assertion, để bạn so sánh trực tiếp trên đầu vào của chính mình.'
  - q: 'Có cách nào tích hợp promptfoo vào pipeline CI/CD không?'
    a: 'Có. Vì promptfoo là một CLI, bạn có thể chạy `npx promptfoo@latest eval` trong bất kỳ pipeline nào. Nó thường được cài vào GitHub Actions để mỗi lần push hay pull request đều chạy bộ đánh giá của bạn.'
  - q: 'Làm sao đóng góp cho dự án promptfoo?'
    a: 'Mọi đóng góp đều được hoan nghênh. Bạn có thể mở issue hoặc gửi pull request trên GitHub. Xem chi tiết tại [hướng dẫn đóng góp](https://github.com/promptfoo/promptfoo/blob/main/CONTRIBUTING.md).'
---

{{< resource-info >}}

## Giới thiệu

Nếu bạn xây dựng ứng dụng với các mô hình như GPT, Claude, Gemini hay DeepSeek, hẳn bạn biết rằng "trông ổn trong playground" hoàn toàn khác với "chạy ổn định trong môi trường production". Promptfoo là một CLI và thư viện mã nguồn mở để đánh giá và red-team các ứng dụng LLM. Nó thay thế kiểu làm mò mẫm bằng các cấu hình kiểm thử khai báo mà bạn có thể chạy cục bộ và cài vào CI/CD. Trong hướng dẫn này, chúng ta sẽ cài đặt nó, viết `promptfooconfig.yaml`, chạy một lần đánh giá, so sánh các mô hình, rồi khởi chạy một lượt quét red-team.

## Promptfoo là gì?

Promptfoo là một CLI và thư viện để đánh giá và red-team các ứng dụng LLM. Bạn chỉ cần mô tả prompt của mình, các provider (mô hình) muốn chạy, cùng một bộ test case kèm assertion. Promptfoo sẽ chạy mọi prompt qua mọi test case, kiểm tra từng assertion, rồi cho bạn một bảng so sánh song song mức độ hoạt động của từng mô hình.

Các khả năng cốt lõi gồm:

- **Đánh giá** — chạy prompt trên nhiều provider và chấm điểm đầu ra bằng assertion (khớp chính xác, chứa chuỗi, độ tương đồng ngữ nghĩa, rubric chấm bằng LLM, v.v.).
- **So sánh mô hình** — so sánh GPT, Claude, Gemini, DeepSeek và nhiều mô hình khác trên cùng một đầu vào.
- **Red-team** — tạo các test case đối kháng để dò tìm lỗ hổng của ứng dụng trước khi phát hành.
- **Tích hợp CI/CD** — cấu hình khai báo chạy được ở bất cứ nơi nào có terminal, kể cả GitHub Actions.

Dự án được viết bằng TypeScript, phát hành theo giấy phép MIT và do nhóm promptfoo duy trì.

## Promptfoo hoạt động thế nào

Quy trình ưu tiên cấu hình:

1. **Cấu hình khai báo** — một tệp `promptfooconfig.yaml` duy nhất định nghĩa `prompts`, `providers` và `tests`. Với các trường hợp thông thường, bạn không cần viết code kết dính.

2. **Giao diện dòng lệnh (CLI)** — `promptfoo eval` chạy lần đánh giá. Nó in bảng kết quả ra terminal và lưu kết quả cục bộ.

3. **Trình xem web cục bộ** — `promptfoo view` mở một giao diện web cục bộ trực quan hóa kết quả đánh giá, giúp bạn so sánh đầu ra của từng mô hình theo từng ô.

Dưới đây là một `promptfooconfig.yaml` tối giản:

```yaml
# promptfooconfig.yaml
description: "GPT vs Claude on a couple of prompts"

prompts:
  - "What is the capital of {{country}}?"
  - "Explain quantum mechanics in one sentence."

providers:
  - openai:gpt-4o-mini
  - anthropic:messages:claude-3-5-sonnet-20241022

tests:
  - vars:
      country: France
    assert:
      - type: contains
        value: Paris
```

Cấu hình này chạy cả hai prompt trên cả hai provider. Với prompt đầu tiên, nó thay thế `{{country}}` và khẳng định rằng đầu ra có chứa "Paris". Khóa API được đọc từ biến môi trường (ví dụ `OPENAI_API_KEY` và `ANTHROPIC_API_KEY`), không lưu trong tệp cấu hình.

![](https://raw.githubusercontent.com/promptfoo/promptfoo/main/site/static/img/claude-vs-gpt-example@2x.png)
- Source Code: [promptfoo GitHub](https://github.com/promptfoo/promptfoo)

![promptfoo self-grading, via dibi8.com](https://www.promptfoo.dev/img/docs/self-grading.gif)

*Giao diện tự chấm điểm của promptfoo (nguồn: kho promptfoo/promptfoo, do dibi8 phân tích tổng hợp)*

## Cài đặt & Thiết lập

Nếu muốn chạy promptfoo như một tác vụ production theo lịch, bạn cần một máy luôn bật — có thể khởi tạo một máy trên [DigitalOcean](https://m.do.co/c/eca87ac14ee0) (tài khoản mới có tín dụng dùng thử miễn phí), hoặc dùng [HTStack](https://my.htstack.com/aff.php?aff=27187) cho VPS Hồng Kông độ trễ thấp (cùng IDC đang host dibi8.com).

Promptfoo cần Node.js `^20.20.0` hoặc `>=22.22.0`. Kiểm tra phiên bản:

```bash
node -v
```

Nếu cần Node.js, hãy tải từ [trang chủ chính thức](https://nodejs.org/).

### Cài đặt

Cách nhanh nhất để dùng thử promptfoo là không cài gì cả:

```bash
npx promptfoo@latest init --example getting-started
```

Nếu muốn cài toàn cục, chọn cách phù hợp với môi trường của bạn:

```bash
# npm
npm install -g promptfoo

# Homebrew
brew install promptfoo

# pip
pip install promptfoo
```

### Thiết lập khóa API

Promptfoo đọc thông tin xác thực provider từ biến môi trường. Với OpenAI:

```bash
export OPENAI_API_KEY=sk-abc123
```

Hãy dùng biến tương ứng với provider bạn đang kiểm thử (ví dụ `ANTHROPIC_API_KEY` cho Claude). Nếu quên đặt khóa, khi chạy đánh giá provider sẽ trả về lỗi xác thực — chỉ cần đặt biến rồi chạy lại.

### Chạy lần đánh giá đầu tiên

Sau khi `init`, thư mục của bạn sẽ có một `promptfooconfig.yaml`. Chạy đánh giá và mở trình xem:

```bash
promptfoo eval
promptfoo view
```

`promptfoo eval` in kết quả ra terminal; `promptfoo view` mở một giao diện web cục bộ để so sánh song song đầy đủ hơn. Nếu gặp khó, hãy xem [tài liệu](https://www.promptfoo.dev/docs/) hoặc mở issue trên GitHub.

## Cách dùng cốt lõi

### Ví dụ 1: Một assertion đơn giản

Tạo cấu hình kiểm tra một chuỗi con kỳ vọng:

```yaml
# promptfooconfig.yaml
description: "Basic prompt test"

prompts:
  - "What is the capital of {{country}}?"

providers:
  - openai:gpt-4o-mini

tests:
  - vars:
      country: France
    assert:
      - type: contains
        value: Paris
```

Chạy:

```bash
promptfoo eval
```

Promptfoo thực thi test case và báo cáo assertion có vượt qua hay không.

### Ví dụ 2: So sánh mô hình với nhiều loại assertion

Bạn có thể liệt kê nhiều provider và phối hợp nhiều loại assertion — chính xác, ngữ nghĩa và chấm bằng LLM:

```yaml
# promptfooconfig.yaml
description: "GPT vs Claude comparison"

prompts:
  - "Answer concisely: {{question}}"

providers:
  - openai:gpt-4o
  - anthropic:messages:claude-3-5-sonnet-20241022

defaultTest:
  assert:
    - type: llm-rubric
      value: does not describe itself as an AI, model, or chatbot

tests:
  - vars:
      question: "What is the meaning of life?"
    assert:
      - type: similar
        value: "It depends on the person"
        threshold: 0.6
```

Chạy cùng lệnh đó rồi dùng `promptfoo view` để so sánh hai mô hình theo từng ô:

```bash
promptfoo eval
```

### Ví dụ 3: Chạy trong pipeline CI/CD

Ở đâu có terminal thì promptfoo chạy được ở đó. Dưới đây là một workflow GitHub Actions làm hỏng (fail) bản build nếu assertion thất bại:

```yaml
# .github/workflows/eval.yml
name: Promptfoo Eval

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  eval:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22'

      - name: Run promptfoo eval
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
        run: npx promptfoo@latest eval
```

Nó chạy bộ đánh giá của bạn ở mỗi lần push và pull request, bắt lỗi hồi quy trước khi gộp code.

## Red-Team

Ngoài đánh giá thông thường, promptfoo có thể tạo các test case đối kháng để dò tìm những lỗ hổng như prompt injection, jailbreak và đầu ra không an toàn. Quy trình red-team có các lệnh con riêng:

```bash
# Mở giao diện thiết lập để cấu hình mục tiêu và loại tấn công
npx promptfoo@latest redteam setup

# Hoặc cấu hình mà không cần GUI
promptfoo redteam init --no-gui

# Tạo các case đối kháng và chạy chúng lên mục tiêu
promptfoo redteam run

# Xem báo cáo các phát hiện
promptfoo redteam report
```

Báo cáo phân nhóm các phát hiện theo loại lỗ hổng và mức độ nghiêm trọng, kèm các biện pháp khắc phục được gợi ý.

## Benchmark & Sử dụng thực tế

Promptfoo được dùng rộng rãi để đánh giá prompt và mô hình. Tuy vậy, điểm mấu chốt không phải là dựa vào một bảng xếp hạng duy nhất, mà là benchmark trên *chính prompt và test case của bạn* — những con số đáng giá đến từ ứng dụng của bạn, không phải từ một bộ thử nghiệm chung chung.

Một quy trình tiêu biểu trông như sau:

```bash
npx promptfoo@latest eval && npx promptfoo@latest view
```

Chạy toàn bộ tập kiểm thử trên các mô hình ứng viên, rồi mở trình xem để thấy chính xác mỗi mô hình vượt qua hay thất bại ở prompt nào, case nào. Vì cấu hình mang tính khai báo, cùng một bộ kiểm thử chạy cục bộ lúc phát triển và chạy trên CI ở mỗi lần commit.

![promptfoo red team dashboard, via dibi8.com](https://www.promptfoo.dev/img/redteam-dashboard@2x.jpg)

*Bảng điều khiển red-team của promptfoo (nguồn: kho promptfoo/promptfoo, do dibi8 phân tích tổng hợp)*

## So sánh với các lựa chọn khác

Bạn cũng có thể xem bài tổng hợp [các công cụ mã nguồn mở liên quan](dibi8-internal-link) của chúng tôi.

Khi chọn công cụ đánh giá và red-team LLM, sức hút chính của promptfoo là sự kết hợp giữa cấu hình khai báo, quy trình ưu tiên cục bộ và khả năng red-team tích hợp sẵn.

| Hạng mục              | promptfoo                                                                 |
|-----------------------|---------------------------------------------------------------------------|
| **Số Star**           | 21,825                                                                     |
| **Giấy phép**         | MIT                                                                        |
| **Bên duy trì**       | promptfoo                                                                  |
| **Ngôn ngữ**          | TypeScript                                                                |
| **Nhánh mặc định**    | main                                                                       |
| **Kiểu cấu hình**     | `promptfooconfig.yaml` khai báo (prompts / providers / tests / assert)     |
| **Giao diện**         | CLI (`promptfoo eval` / `view`) cùng việc dùng như thư viện                 |
| **Phạm vi mô hình**   | GPT, Claude, Gemini, DeepSeek và nhiều provider khác                        |
| **Red-team**          | Tích hợp sẵn (các lệnh con `promptfoo redteam`)                             |
| **CI/CD**             | Chạy ở mọi terminal; hỗ trợ GitHub Actions hạng nhất                       |

### Phân tích chi tiết

- **Số Star** — promptfoo có khoảng 21,825 star trên GitHub, một tín hiệu mạnh cho thấy mức độ phổ biến trong giới phát triển LLM.
- **Cấu hình khai báo** — định nghĩa các bài kiểm thử trong `promptfooconfig.yaml` giúp bộ đánh giá của bạn được quản lý phiên bản cùng với code, để cùng một bộ kiểm tra chạy được cả cục bộ lẫn trên CI.

## Hạn chế & Đánh giá thẳng thắn

Promptfoo là một công cụ giàu năng lực, nhưng vẫn có những đánh đổi đáng lưu ý:

1. **Cấu hình phình to theo độ phức tạp** — định dạng khai báo rất tốt cho trường hợp thông thường, nhưng các bộ lớn với nhiều provider, biến động và assertion tùy biến sẽ trở nên dài dòng. Bạn thường phải tách prompt và test case ra các tệp riêng.
2. **Bạn tự lo việc truy cập mô hình** — promptfoo điều phối việc đánh giá nhưng dựa vào khóa API và hạn mức provider của bạn. Chi phí và giới hạn tốc độ là phần của bạn.
3. **Chạy đánh giá tốn token và thời gian** — một bộ lớn trải trên nhiều provider tạo ra rất nhiều lệnh gọi API. Trên các tập kiểm thử lớn, độ trễ và chi phí sẽ tích lũy.
4. **Thiết kế assertion cần cân nhắc** — rubric chấm bằng LLM (`llm-rubric`) và kiểm tra ngữ nghĩa rất mạnh nhưng không tất định; để có assertion đáng tin và có ý nghĩa cần lặp đi lặp lại.
5. **Đang tiến hóa tích cực** — promptfoo phát hành thường xuyên. Điều đó nghĩa là cải tiến nhanh, nhưng đôi khi có thay đổi gây phá vỡ; hãy ghim một phiên bản trong CI để ổn định.

Đây là những điều đáng cân nhắc trước khi chuẩn hóa nó.

## Kết luận

Promptfoo biến việc kiểm thử prompt và mô hình từ chuyện đoán mò thành một quy trình có thể tái lập và quản lý phiên bản. Chỉ với một `promptfooconfig.yaml`, bạn có thể đánh giá prompt, so sánh GPT, Claude, Gemini và DeepSeek trên dữ liệu của chính mình, và red-team ứng dụng để tìm lỗ hổng — tất cả ngay trong CLI và CI/CD. Bước tiếp theo tốt nhất là chạy `npx promptfoo@latest init --example getting-started`, trỏ nó vào prompt của bạn, rồi mở trình xem để thấy các mô hình thực sự hoạt động ra sao.

Việc scraping quy mô lớn cần proxy luân phiên — [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f) là lựa chọn tiêu chuẩn.

- Tham gia [nhóm Telegram tiếng Anh của dibi8](https://t.me/DIBI8_Group/2) để nhận tin về các công cụ AI mã nguồn mở.
- Đọc tiếp: [các hướng dẫn liên quan trên dibi8](dibi8-internal-link).

---

**Nguồn & Đọc thêm**:
- Kho GitHub: https://github.com/promptfoo/promptfoo
- Tài liệu chính thức / README: https://github.com/promptfoo/promptfoo#readme

*Một số liên kết ở trên là liên kết tiếp thị. dibi8.com có thể nhận hoa hồng nếu bạn đăng ký, mà bạn không tốn thêm chi phí nào. Điều này giúp duy trì website và giữ cho nội dung miễn phí.*

<!-- internal-link-candidates:
  related open-source tools -> ai-tools-directory
  related guides on dibi8 -> ai-coding-agent-landscape-2026-skills-mcp-opensource
-->
