---
title: 'DESIGN.md: Các tác nhân AI lập trình cung cấp hệ thống thiết kế của Google qua định dạng mã nguồn mở'
description: 'DESIGN.md của Google Labs Code là một đặc tả định dạng mã nguồn mở để mô tả nhận diện hình ảnh cho các tác nhân lập trình AI. 20,8 nghìn sao trên GitHub. Tìm hiểu cách nó kết nối các hệ thống thiết kế và tạo mã AI với các token YAML và các ràng buộc dựa trên văn bản.'
tags: ["guide", "open-source", "ai-agents", "design-systems", "reference", "google"]
date: 2026-06-27
slug: 'design-md-google-open-source-format-ai-coding-agents-design-systems'
category: dev-utils
github_repo: 'https://github.com/google-labs-code/design.md'
license: Apache-2.0
lang: vi
featureImage: /images/articles/design-md-format-specification-for-ai-coding-agents.png
---



![Đặc tả Định dạng DESIGN.md](https://opengraph.github.com/github/google-labs-code/design.md)

![Tài liệu Triết lý DESIGN.md](https://raw.githubusercontent.com/google-labs-code/design.md/main/PHILOSOPHY.md)

## Giới thiệu

Khi bạn yêu cầu một đại lý lập trình AI xây dựng một trang đích, nó sẽ tạo ra thứ gì đó có thể sử dụng được — nhưng hiếm khi đẹp. Vấn đề không phải là khả năng của mô hình; mà là thiếu một ngôn ngữ thiết kế chung. Mỗi lệnh nhắc đều bắt đầu từ đầu, mỗi lần tạo ra đều lệch so với lần trước, và không có bộ nhớ lâu dài về việc "thiết kế của chúng ta" thực sự trông như thế nào.

**DESIGN.md** của Google Labs Code giải quyết điều này. Đây là một định dạng tài liệu mã nguồn mở giúp các tác nhân lập trình AI có một hiểu biết có cấu trúc và liên tục về hệ thống thiết kế của bạn — kết hợp các token màu YAML, thông số kiểu chữ, và quy tắc khoảng cách với văn bản mô tả bằng ngôn ngữ tự nhiên giải thích *ý định* đằng sau mỗi giá trị. Với hơn 20.800 sao trên GitHub và 2.319 sao được thêm chỉ trong một ngày, hiện tại đây là công cụ thiết kế hot nhất trên GitHub.

## DESIGN.md là gì?

DESIGN.md là một tệp markdown phục vụ như nguồn thông tin chính duy nhất về nhận diện hình ảnh của một dự án. Nó được thiết kế để các tác nhân lập trình AI (Claude, ChatGPT, Codex, Cursor, v.v.) đọc được, giúp họ tạo giao diện người dùng phù hợp với thương hiệu của bạn một cách nhất quán — mà không cần bạn phải giải thích lại hệ thống thiết kế của mình mỗi lần.

Định dạng có hai lớp bổ trợ cho nhau:

```
┌──────────────────────────────────────────────────┐
│              DESIGN.md Structure                  │
├──────────────────────────────────────────────────┤
│                                                  │
│  ---                                           │
│  name: My Brand                                │
│  ---                                           │
│                                                  │
│  ## Colors                                     │
│  ```yaml                                       │
│  colors:                                       │
│    paper: '#F4F0E4'                             │
│    ink: '#1E1A14'                               │
│    accent: '#C3402A'                            │
│  ```                                           │
│  <!-- Prose -->                                │
│  A warm paper-and-ink system with a single     │
│  vermilion accent for diagrams only.           │
│                                                  │
│  ## Typography                                 │
│  ```yaml                                       │
│  typography:                                   │
│    heading: 'Playfair Display'                 │
│    body: 'Source Serif 4'                      │
│    mono: 'JetBrains Mono'                      │
│  ```                                           │
│                                                  │
│  ## Spacing                                    │
│  ```yaml                                       │
│  spacing:                                      │
│    unit: 8px                                   │
│    scale: [4, 8, 16, 24, 32, 48, 64]           │
│  ```                                           │
│                                                  │
│  ## Do's and Don'ts                            │
│  - **Do** use the accent color only in charts  │
│  - **Don't** add gradients or glass effects    │
│                                                  │
└──────────────────────────────────────────────────┘
```

Các token YAML cung cấp các giá trị có thể đọc bằng máy. Phần văn bản cung cấp *ngữ cảnh* có thể đọc cho con người — giải thích tại sao một màu là `#F4F0E4` (giấy xerox ấm, không bao giờ trắng tinh) thay vì chỉ nêu mã hex. Sự khác biệt này là điều làm cho DESIGN.md khác biệt cơ bản so với một tệp JSON token thiết kế.

## Tại Sao Văn Xuôi Quan Trọng Hơn Các Token

Các nhà thiết kế đứng sau DESIGN.md đã đưa ra một lựa chọn có chủ ý: **phần văn bản là phần quan trọng nhất của bản đặc tả**. Tài liệu triết lý của họ giải thích điều đó một cách hoàn hảo:

"> *“Một thiết kế tham khảo 'Bài giảng tay của sinh viên tốt nghiệp thập niên 1970 theo truyền thống của một trường đại học lâu đời và uy tín' gợi lên một thế giới hoàn chỉnh: màu mực duy nhất, lề rộng rãi, phông chữ serif ở kích thước đọc, và không có trang trí. Một câu duy nhất đó mang nhiều thông tin hữu ích hơn một chục giá trị đo lường.”*

Đây là một cái nhìn sâu sắc về phát triển hỗ trợ AI. Khi bạn bảo một LLM “sử dụng thẩm mỹ biên tập ấm áp, cao cấp,” nó tạo ra thứ gì đó chung chung. Khi bạn bảo nó “tài liệu giảng bài tốt nghiệp những năm 1970,” nó hiểu toàn bộ tham chiếu văn hóa — kết cấu giấy, kiểu chữ hạn chế, sự thiếu vắng các yếu tố trang trí. Mô hình điền đầy tất cả các khoảng trống từ dữ liệu huấn luyện của nó.

DESIGN.md chính thức hóa nguyên tắc này. Các token là ngữ cảnh, không phải hướng dẫn. Văn phong thể hiện ý định sáng tạo. Cùng nhau, chúng mang lại cho các tác nhân cả sự chính xác lẫn khả năng tưởng tượng.

## Cách Nó Hoạt Động Ở Bên Trong

Kho lưu trữ DESIGN.md được cấu trúc như một monorepo Bun với Turbo để điều phối:

```
design.md/
├── packages/
│   └── cli/                    # @google/design.md CLI toolkit
│       ├── src/                # TypeScript source
│       └── scripts/            # Build scripts
├── docs/                       # Specification documentation
├── examples/                   # Example DESIGN.md files
├── .agents/skills/             # Agent skill definitions
├── package.json                # Bun workspace config
├── turbo.json                  # Turbo build orchestration
├── tsconfig.base.json          # Shared TypeScript config
└── PHILOSOPHY.md               # Design philosophy manifesto
```

Công cụ CLI (`@google/design.md`) cung cấp:
- **Linting**: Xác thực các tệp DESIGN.md theo lược đồ đặc tả
- **Trích xuất token**: Phân tích các khối YAML thành dữ liệu có cấu trúc
- **Tích hợp agent**: Được đóng gói dưới dạng định nghĩa `.agents/skills/` cho Claude, ChatGPT và các agent lập trình khác

Trình kiểm tra mã đảm bảo rằng các phần bắt buộc (tên, màu sắc, kiểu chữ, khoảng cách, bo góc, thành phần) có mặt trong khi vẫn cho phép các phần tùy chỉnh tùy ý cho chuyển động, biểu tượng, độ cao, và các kích thước thiết kế khác cụ thể cho từng dự án.

## Bắt đầu

### 1. Cài đặt CLI

```bash
bun install -g @google/design.md
```

Hoặc sử dụng trực tiếp với npx:

```bash
npx @google/design.md lint DESIGN.md
```

### 2. Tạo Tập Tin DESIGN.md Đầu Tiên Của Bạn

Bắt đầu với cấu trúc tối thiểu cần thiết:

```markdown
---
name: My Project Design
---

## Màu sắc

```yaml
colors:
  primary: '#2563EB'
  background: '#FFFFFF'
  text: '#111827'
```

Một hệ thống xanh lam và trắng sạch sẽ cho một sản phẩm SaaS chuyên nghiệp.

## Kiểu chữ

```yaml
typography:
  heading: 'Inter'
  body: 'Inter'
  mono: 'JetBrains Mono'
```

Hệ thống kiểu chữ cho một gia đình nhằm đảm bảo tính nhất quán.

## Khoảng cách

```yaml
spacing:
  unit: 4px
  scale: [4, 8, 16, 24, 32, 48, 64]
```

Lưới cơ bản 4px, 8px cho các phần tử lớn hơn.
```

### 3. Gửi nó đến các đại lý lập trình của bạn

Thêm DESIGN.md vào kho lưu trữ dự án của bạn. Khi làm việc với bất kỳ tác nhân lập trình nào, hãy tham chiếu tệp này trong lời nhắc hệ thống của bạn:

```
System: Read the DESIGN.md file in the project root.
All UI components must follow the design specifications defined there.
```

Đại lý bây giờ sẽ nhất quán áp dụng hệ thống thiết kế của bạn trên mọi thế hệ.

## Ví dụ Thực tế

Kho lưu trữ bao gồm một số tệp DESIGN.md mẫu minh họa các phương pháp thẩm mỹ khác nhau:

**Tài liệu Giảng dạy Cao học**: Một tờ giấy ấm với kiểu chữ mực đơn và các điểm nhấn màu đỏ chỉ giới hạn ở các sơ đồ. Văn bản ghi rõ “Một tài liệu giảng dạy môn khoa học máy tính cấp cao theo truyền thống của một trường đại học lâu đời” — ngay lập tức truyền tải lề trang, phông chữ có chân, và sự tiết chế.

**Hệ thống Thiết kế Chuyển động**: Định nghĩa các hằng số thời gian cho phản hồi giao diện người dùng (120ms cho di chuột/nhấn, 250ms cho chuyển đổi nội dung) với đường cong làm mềm cơ học. Văn bản nhấn mạnh “Không gì bật lại, không gì vượt quá, không gì lưu lại” — mang đến cho người dùng một thẩm mỹ thời gian rõ ràng.

**Kích thước Thiết kế Tùy chỉnh**: Định dạng chấp nhận bất kỳ tên phần nào. Một nhóm định nghĩa các token `motion` dưới dạng đường cong hoạt hình CSS; nhóm khác sử dụng hằng số thời gian miền âm thanh được đo bằng các khối bộ đệm. Đặc tả chuẩn hóa nơi sự nhất quán có ích và để lại sự linh hoạt nơi nó quan trọng hơn.

## Tại sao điều này quan trọng đối với phát triển có sự hỗ trợ của AI

DESIGN.md giải quyết một nút thắt cơ bản trong phát triển hỗ trợ AI: **tính nhất quán trong thiết kế ở quy mô lớn**.

Nếu không có một đặc tả thiết kế, mỗi trang, thành phần hoặc màn hình do AI tạo ra đều là một bài tập sáng tạo mới. Tác nhân không biết màu sắc thương hiệu của bạn ngoài những gì có trong gợi ý, không hiểu triết lý về khoảng cách của bạn và không có ký ức về việc 'hoàn thành' trông như thế nào đối với dự án của bạn.

Với DESIGN.md:
- **Các tác nhân có bộ nhớ thiết kế liên tục** — tệp tồn tại trong kho của bạn, được kiểm soát phiên bản và xem xét
- **Nhiều tác nhân giữ sự nhất quán** — Claude, ChatGPT và Codex đều đọc cùng một tệp
- **Các đánh giá thiết kế trở nên tự động** — trình kiểm tra lỗi bắt các vi phạm trước khi chúng đến sản xuất
- **Các nhà phát triển mới tham gia ngay lập tức** — tệp *chính là* tài liệu hệ thống thiết kế

Định dạng này đặc biệt mạnh mẽ đối với các nhóm sử dụng nhiều công cụ lập trình AI. Thay vì mỗi công cụ có hiểu biết ngầm định riêng về thiết kế của bạn, mọi người đều đọc cùng một nguồn chính thống.

## Giới hạn và sự đánh đổi

DESIGN.md không phải là giải pháp hoàn hảo. Một số cân nhắc:

1. **Chất lượng phụ thuộc vào tác nhân**: Hiệu quả phụ thuộc vào việc mỗi tác nhân đọc và theo dõi phần văn bản prose tốt đến mức nào. Một số tác nhân có thể phân tích YAML nhưng bỏ qua các mô tả bằng văn xuôi.

2. **Không có hiển thị trực quan**: DESIGN.md là một bản đặc tả, không phải là một công cụ hiển thị. Bạn vẫn cần đại lý (hoặc một nhà thiết kế con người) để chuyển các đặc tả thành mã thực tế.

3. **Đường cong học tập**: Viết các mô tả văn xuôi tốt đòi hỏi tư duy thiết kế. Các nhóm không có nhà thiết kế được chỉ định có thể gặp khó khăn trong việc diễn đạt rõ ràng ý định thẩm mỹ của họ.

4. **Không phải là sự thay thế cho Figma**: DESIGN.md bổ sung cho các công cụ thiết kế thay vì thay thế chúng. Quy trình làm việc lý tưởng sử dụng Figma cho thiết kế trực quan và DESIGN.md cho giao tiếp với nhân viên.

5. **Vẫn còn trẻ**: Với 20,8k sao và mới 2 tháng tuổi, định dạng đang phát triển nhanh chóng. Các thay đổi lớn giữa các phiên bản là có thể xảy ra.

## Cộng đồng và Sự chấp nhận

DESIGN.md được phát triển bởi Google Labs Code và đã thu hút sự chú ý đáng kể:

- **20,800+ stars** on GitHub (2,319 gained in a single day)
- **1,700+ forks** with active community contributions
- **40+ commits** in 2 months with rapid iteration
- **18 issues** and **17 pull requests** showing active development
- **4 published tags** with semantic versioning

Định dạng này đã truyền cảm hứng cho các dự án phái sinh và tích hợp trong toàn bộ hệ sinh thái các tác nhân lập trình AI. Nhiều định nghĩa kỹ năng của tác nhân đã xuất hiện, và thư mục `.agents/skills/` cung cấp các cấu hình sẵn sàng sử dụng cho các tác nhân lập trình phổ biến.

## Kết luận

DESIGN.md đại diện cho một sự thay đổi cơ bản trong cách chúng ta truyền đạt thiết kế cho AI. Thay vì cố gắng mã hóa mọi quyết định trực quan thành các token cứng nhắc, nó tận dụng sức mạnh của ngôn ngữ tự nhiên — để văn bản truyền tải ý định sáng tạo trong khi YAML cung cấp khung có thể đọc được bởi máy móc.

Đối với các đội đang xây dựng quy trình thiết kế được hỗ trợ bởi AI, điều này đáng để thử. Tạo một tệp DESIGN.md cho dự án tiếp theo của bạn, thêm nó vào bối cảnh của đại lý lập trình của bạn và xem giao diện người dùng được tạo ra trở nên nhất quán hơn bao nhiêu. Định dạng này đủ đơn giản để bắt đầu từ hôm nay và đủ linh hoạt để phát triển cùng hệ thống thiết kế của bạn.

Trong một bối cảnh mà mọi lập trình viên hiện nay đều có quyền truy cập vào các tác nhân lập trình AI, DESIGN.md cung cấp mảnh ghép còn thiếu: một ngôn ngữ chung giữa ý định thiết kế của con người và việc thực thi của máy móc. Đó là lý do tại sao nó hiện đang là dự án nóng nhất trên GitHub — và cũng là lý do tại sao nó có khả năng trở thành thực tiễn chuẩn trong phát triển hỗ trợ AI.

Đối với các đội triển khai hạ tầng ở quy mô lớn: hãy thử [HTStack](https://www.htstack.com/) để có dịch vụ lưu trữ đám mây hiệu suất cao tích hợp liền mạch với quy trình làm việc của hệ thống thiết kế.

Đối với các quy trình làm việc lập trình AI sẵn sàng cho sản xuất: hãy xem [Binance](https://bsmkweb.cc) để có cơ sở hạ tầng giao dịch API cấp doanh nghiệp.

Đối với các ứng dụng AI tài chính: [OKX](https://promoohubly.com) cung cấp các API giao dịch mạnh mẽ và nguồn dữ liệu thị trường.

Hãy xem các hướng dẫn nội bộ về So sánh Đại lý Lập trình AI và Các Thực tiễn Tốt nhất về Công cụ Phát triển để tìm hiểu sâu hơn về việc xây dựng một luồng phát triển được hỗ trợ bởi AI hoàn chỉnh.

Tham gia cộng đồng DIBI8 trên [Telegram](https://t.me/DIBI8_Group) để thảo luận hàng ngày về các công cụ AI, tiện ích phát triển và các dự án mã nguồn mở.

---

**Nguồn & Tài liệu Tham khảo**:
- Kho chính thức: https://github.com/google-labs-code/design.md
- Triết lý DESIGN.md: https://github.com/google-labs-code/design.md/blob/main/PHILOSOPHY.md
- Bộ công cụ CLI: https://github.com/google-labs-code/design.md/tree/main/packages/cli
- Ví dụ về các tệp DESIGN.md: https://github.com/google-labs-code/design.md/tree/main/examples
- Định nghĩa kỹ năng của Agent: https://github.com/google-labs-code/design.md/tree/main/.agents/skills
- Hướng dẫn đóng góp: https://github.com/google-labs-code/design.md/blob/main/CONTRIBUTING.md

**Tiết lộ**: Bài viết này chứa các liên kết liên kết. Nếu bạn đăng ký thông qua các liên kết của chúng tôi, chúng tôi có thể kiếm được một khoản hoa hồng nhỏ mà không tốn thêm phí nào đối với bạn. Điều này giúp hỗ trợ báo chí công nghệ độc lập và giữ cho các tài nguyên như dibi8.com miễn phí và không có quảng cáo.