---
title: "Hiểu Mọi Thứ: Đồ Thị Kiến Thức Tương Tác cho Các Cơ Sở Mã — Hơn 60K Sao 2026"
description: "Understand-Anything biến bất kỳ cơ sở mã nào thành đồ thị tri thức tương tác mà bạn có thể khám phá, tìm kiếm và truy vấn. Hoạt động với Claude Code, Codex, Cursor, Copilot, Gemini CLI. 60.339 sao trên GitHub."
date: 2026-06-17
slug: understand-anything-interactive-knowledge-graphs-codebases
category: ai-tools
tags: ['understand-anything', 'knowledge-graph', 'codebase-analysis', 'claude-code', 'codex', 'cursor', 'AI-agents', 'code-visualization', 'semantic-search']
github_repo: "https://github.com/Egonex-AI/Understand-Anything"
license: MIT
lang: vi
featureImage: /images/articles/egonex-understand-anything-interactive-knowledge-graphs-from.jpg
---

## Giới thiệu

Bạn sao chép một cơ sở mã mới. 50.000 dòng mã trên 200 tệp. Bạn mở VS Code và nhìn chằm chằm vào cây tệp. Bạn bắt đầu từ đâu?

Hầu hết các nhà phát triển đều sử dụng `grep`. Rồi đến `ripgrep`. Sau đó họ mở 10 tệp được tham chiếu nhiều nhất và cố gắng lắp ráp kiến trúc trong đầu. Nó hiệu quả — với các dự án nhỏ. Với bất cứ thứ gì lớn hơn, nó thật mệt mỏi.

Understand-Anything làm một điều hoàn toàn khác biệt. Nó biến mọi cơ sở mã thành một đồ thị tri thức tương tác — các nút cho tệp, lớp và hàm; các cạnh cho các phụ thuộc và mối quan hệ. Bạn có thể khám phá, tìm kiếm và đặt câu hỏi về mã. Không phải với regex. Mà với ngôn ngữ tự nhiên.

60.339 sao trên GitHub trong một tháng. 44.690 trong số đó chỉ đến trong tháng này. Cộng đồng các đại lý AI đã tìm thấy điều gì đó mà họ không biết là họ cần.

Đây là cách mà các cơ sở mã nên cảm nhận từ ngày đầu tiên.

![Understand-Anything — Interactive knowledge graphs for any codebase](https://raw.githubusercontent.com/Egonex-AI/Understand-Anything/main/assets/hero.png)

## Understand-Anything là gì?

Understand-Anything là một công cụ mã nguồn mở của Egonex-AI, chuyển đổi bất kỳ cơ sở mã, tài liệu hoặc cơ sở kiến thức nào thành một đồ thị kiến thức tương tác. Khác với các công cụ phân tích tĩnh tạo ra danh sách phụ thuộc phẳng, Understand-Anything xây dựng một đồ thị ngữ nghĩa nơi các nút đại diện cho các thực thể mã (tệp, lớp, hàm, biến) và các cạnh đại diện cho các mối quan hệ (nhập khẩu, gọi, kế thừa, thành phần).

Kết quả là một biểu diễn trực quan + có thể truy vấn của mã mà cả con người và các tác nhân AI đều có thể duyệt. Claude Code có thể di chuyển qua nó. Codex có thể suy luận về nó. Cursor có thể tham chiếu đến nó. Đồ thị này đóng vai trò như một lớp hiểu biết chung giữa các nhà phát triển và trợ lý AI.

```bash
# Install via npm (TypeScript-based CLI)
npm install -g understand-anything

# Or use via Docker
docker run -v $(pwd):/code ghcr.io/egonex-ai/understand-anything:latest /code
```

Công cụ này hoạt động với Claude Code, Codex, Cursor, Copilot, Gemini CLI, OpenCode và các tác nhân lập trình AI khác — biến nó thành một lớp kiến thức phổ quát cho chuỗi công cụ lập trình AI.

## Cách Hiểu-Mọi-Thứ Hoạt Động

Đường ống có ba giai đoạn: phân tích cú pháp, xây dựng đồ thị và lập chỉ mục:

```
Source Code (all languages)
        │
        ▼
┌─────────────────┐
│  AST Parser      │  Extract files, classes, functions,
│  (multi-lang)    │  imports, dependencies
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Graph Builder   │  Creates nodes + edges:
│                  │  Nodes: files, classes, funcs
│                  │  Edges: calls, imports, extends
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Embedding +     │  Vector indices for semantic
│  Indexing        │  search; graph indices for
│                  │  structural traversal
└────────┬────────┘
         │
         ▼
   Knowledge Graph
  (explore + query)
```

Mỗi ngôn ngữ được phân tích cú pháp với AST gốc của nó (Python với `ast`, TypeScript với API trình biên dịch `typescript`, v.v.). Đồ thị được lưu trữ ở định dạng gọn nhẹ tối ưu cho cả việc trực quan hóa và truy vấn nhanh.

Lớp lập chỉ mục thêm các nhúng vector cho tìm kiếm ngữ nghĩa — cho phép các truy vấn kiểu "tìm tất cả các hàm xử lý xác thực" trên toàn bộ cơ sở mã.

## Cài đặt & Thiết lập

### Cài đặt Nhanh

```bash
# npm installation (recommended)
npm install -g understand-anything

# Verify
understand-anything --version
```

### Cài đặt Docker

```bash
# Pull latest image
docker pull ghcr.io/egonex-ai/understand-anything:latest

# Analyze a codebase
docker run --rm -v $(pwd):/code \
  ghcr.io/egonex-ai/understand-anything:latest \
  /code --output ./knowledge-graph.json
```

### Từ Nguồn

```bash
git clone https://github.com/Egonex-AI/Understand-Anything.git
cd Understand-Anything
npm install
npm run build
npm link  # global install
```

### Vỏ Bao Python

```bash
pip install understand-anything-python
```

```python
from understand_anything import CodebaseAnalyzer

analyzer = CodebaseAnalyzer("/path/to/codebase")
analyzer.build_graph()
analyzer.export_graph("graph.json")
```

### Cấu hình

```json
{
  "include": ["src/**/*.{ts,tsx,js,jsx}", "tests/**/*"],
  "exclude": ["node_modules", "dist", "*.test.*"],
  "languages": ["typescript", "python", "rust", "go"],
  "embedding_model": "all-MiniLM-L6-v2",
  "max_file_size": 50000,
  "max_depth": 5
}
```

## Tích hợp với các công cụ chính

### Tích hợp Mã Claude

```bash
# Add knowledge graph to Claude Code context
understand-anything analyze ./src --format claude-code

# Claude Code automatically loads the graph for context-aware responses
```

### Plugin IDE Cursor

```bash
# Install the Cursor extension
# Settings → Extensions → Understand-Anything
# Point to your project root

# Cursor will show the knowledge graph sidebar
# Click any node to navigate to the source
```

### Tiện ích GitHub Copilot

```bash
# Generate a .copilot context file
understand-anything analyze ./src --format copilot

# Creates .github/copilot-instructions.md with
# graph-derived context for Copilot
```

### Tiện ích mở rộng VS Code

```bash
# Install from marketplace
# vscode-marketplace: egonex.understand-anything

# Or CLI install
npx @egonex/vscode-extension install
```

## Tiêu chuẩn tham chiếu & Các trường hợp sử dụng thực tế

### Tốc độ phân tích theo kích thước mã nguồn

| Kích thước mã nguồn | Tệp | Thời gian phân tích | Các nút đồ thị |
| --------------- | ------- | --------------- | ------------- |
| Nhỏ (công cụ CLI) | năm mươi | 2 giây | Một trăm hai mươi |
| Medium (thư viện) | năm trăm | 15 giây | Một nghìn hai trăm |
| Lớn (ứng dụng đầy đủ) | Năm nghìn | 2 phút | 12.000 |

Thời gian phân tích tăng xấp xỉ tuyến tính theo số lượng tệp. Việc xây dựng đồ thị là thao tác chiếm ưu thế, sau đó là tính toán nhúng.

### Hiệu suất truy vấn

| Doanh nghiệp | 50.000 | 15 phút | 120.000 |
| Loại truy vấn | Thời gian phản hồi | Ghi chú |
| ----------- | --------------- | ------- |
| Cấu trúc (tìm nhập khẩu) | <10ms | Duyệt đồ thị |
| Ngữ nghĩa (ngôn ngữ tự nhiên) | 50-200ms | Tìm kiếm vector + đồ thị |
| Tham chiếu đa ngôn ngữ | 100-500ms | Kết nối Multi-AST |

### Trường hợp sử dụng: Đưa các nhà phát triển mới vào

Một nhóm 15 lập trình viên tham gia vào một dự án TypeScript dài 50.000 dòng. Trước khi Sử dụng Understand-Anything, việc làm quen mất 2 tuần để đọc mã. Sau đó:

```bash
# Generate onboarding graph
understand-anything analyze ./src --onboarding

# Outputs:
# - Architecture overview (HLD + LLD)
# - Key entry points
# - Module dependency map
# - Common patterns and anti-patterns
```

Thời gian giới thiệu lập trình viên mới đã giảm từ 14 ngày xuống còn 3 ngày. Biểu đồ tương tác cho phép họ khám phá cơ sở mã theo tốc độ của riêng mình.

### Trường hợp sử dụng: Tái cấu trúc mã cũ

```bash
# Find all files that reference deprecated API
understand-anything query "deprecated authentication endpoints"

# Returns: 23 files, 47 references
# With full dependency chains
```

Đồ thị tiết lộ sự liên kết ẩn mà bảng tính và grep hoàn toàn bỏ sót.

## Sử Dụng Nâng Cao / Cứng Hóa Sản Xuất

### Hỗ Trợ Ngôn Ngữ Tùy Chỉnh

```typescript
// Add support for a new language
import { LanguagePlugin } from 'understand-anything';

class MyLangPlugin implements LanguagePlugin {
  name = 'mylang';
  
  parse(source: string): ASTNode {
    // Your language-specific parser
    return parseMyLang(source);
  }
  
  extractDependencies(node: ASTNode): Dependency[] {
    return extractMyDeps(node);
  }
}

// Register plugin
registerPlugin(new MyLangPlugin());
```

### Ngôn ngữ Truy vấn Đồ thị (GQL)

```bash
# Find all functions called by more than 5 other functions
understand-anything gql "func where call_count > 5 order by call_count desc"

# Find orphan files (no incoming references)
understand-anything gql "file where incoming_refs == 0"

# Find circular dependencies
understand-anything gql "cycle where type == 'import'"
```

### Tích hợp CI/CD

```yaml
# .github/workflows/graph-check.yml
name: Knowledge Graph CI
on: [pull_request]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build knowledge graph
        run: |
          npx understand-anything analyze ./src --format ci
      - name: Check for circular dependencies
        run: |
          npx understand-anything gql "cycle" \
            | tee graph-violations.json
      - name: Upload violations
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: graph-violations
          path: graph-violations.json
```

### Tối Ưu Hiệu Suất

```bash
# Use incremental analysis (fastest for dev workflows)
understand-anything analyze ./src --incremental

# Cache graph for repeated queries
understand-anything analyze ./src --cache ./graph-cache.db

# Parallel analysis for large codebases
understand-anything analyze ./src --workers 8

# Memory-efficient mode (for constrained environments)
understand-anything analyze ./src --low-memory
```

### Định dạng xuất

```bash
# JSON (programmatic access)
understand-anything analyze ./src --format json -o graph.json

# DOT (Graphviz visualization)
understand-anything analyze ./src --format dot -o graph.dot
# Then: dot -Tpng graph.dot -o graph.png

# Mermaid (Markdown diagrams)
understand-anything analyze ./src --format mermaid -o graph.mmd

# HTML (interactive viewer)
understand-anything analyze ./src --format html -o graph.html
# Opens in browser with zoom, pan, search
```

## So sánh với các lựa chọn thay thế

| Tóm tắt toàn bộ mã nguồn | 1-3 giây | Thống kê đồ thị tổng hợp |
| Tính năng | Hiểu-Mọi-Thứ | Mã2Gợi ý | Phù thủy | SonarQube |
| --------- | ------------------- | ------------- | ---------- | ----------- |
| Đồ thị tri thức | ✅ Tương tác | ❌ AST phẳng | ❌ | ❌ |
| Truy vấn Ngôn ngữ Tự nhiên | ✅ | ❌ | ❌ | ❌ |
| Tích hợp Tác nhân AI | ✅ Hơn 10 công cụ | ❌ | ❌ | ❌ |
| Đa ngôn ngữ | ✅ 8+ | ✅ 5+ | ✅ 3+ | ✅ 20+ |
| Hình dung | ✅ Tích hợp sẵn | ❌ | ❌ | ✅ Giao diện Web |
| Cập nhật theo thời gian thực | ✅ Tăng dần | ❌ | ❌ | ✅ |
| Miễn phí | ✅ Không giới hạn | ✅ | ❌ Đã thanh toán | ❌ Đã thanh toán |
| Độ phức tạp khi thiết lập | Thấp | Trung bình | Thấp | Cao |
| Tốc độ truy vấn | <200ms | Không áp dụng | Không áp dụng | Không áp dụng |

Understand-Anything là công cụ duy nhất kết hợp trực quan hóa tương tác, truy vấn ngôn ngữ tự nhiên và tích hợp đại lý AI rộng rãi trong một gói miễn phí duy nhất. SonarQube có nhiều tính năng hơn nhưng tốn hàng nghìn mỗi năm. Code2Prompt tập trung vào tạo lệnh nhắc, không phải khám phá.

## Giới hạn / Đánh giá trung thực

Understand-Anything mạnh mẽ nhưng có những hạn chế trung thực:

1. **Mã được tạo ra không được phân tích.** Mã động (eval, exec, các lớp được tạo ra trong thời gian chạy) sẽ không xuất hiện trong biểu đồ. Đây là một hạn chế cơ bản của phân tích tĩnh — không có công cụ nào giải quyết vấn đề này một cách hoàn hảo.

2. **Thư viện bên thứ ba cần được phân tích riêng.** Biểu đồ tập trung vào mã nguồn của bạn. Để bao gồm các phụ thuộc, bạn cần phân tích `node_modules`, `vendor/`, hoặc tương đương một cách riêng biệt.

3. **Các kho mã lớn cần được điều chỉnh.** Hơn 50.000 tệp có thể yêu cầu các cờ `--workers` và `--low-memory` để đạt hiệu suất tối ưu. Cài đặt mặc định hoạt động tốt cho các dự án lên đến 10.000 tệp.

4. **Phần mở rộng tệp không chuẩn.** Các tệp không có phần mở rộng được công nhận có thể không được phân tích đúng cách. Sử dụng cấu hình `include` để chỉ định các mẫu.

5. **Hợp tác theo thời gian thực.** Đồ thị được tính toán theo nhu cầu, không được cập nhật liên tục. Các thay đổi yêu cầu phân tích lại (chế độ tăng dần giảm thiểu chi phí này).

Đây là những đánh đổi vốn có của phương pháp, không phải lỗi trong việc triển khai. Đối với phần lớn các dự án, những hạn chế này không ảnh hưởng đến khả năng sử dụng.

![Understand-Anything — Overview of the knowledge graph interface](https://raw.githubusercontent.com/Egonex-AI/Understand-Anything/main/assets/overview.png)

## Câu hỏi thường gặp

**Hỏi: Các ngôn ngữ lập trình nào được hỗ trợ?**

Hiện tại hỗ trợ TypeScript, JavaScript, Python, Go, Rust, Java, C#, Ruby và PHP. Các plugin ngôn ngữ mới có thể được thêm vào thông qua hệ thống plugin. Trình xây dựng biểu đồ sử dụng bộ phân tích cú pháp AST gốc của từng ngôn ngữ để đạt độ chính xác tối đa.

**Hỏi: Tôi có thể sử dụng Understand-Anything với các cơ sở mã riêng không?**

Vâng. Tất cả các phân tích diễn ra cục bộ. Không có mã nào được tải lên bất kỳ máy chủ nào. Tùy chọn triển khai Docker là lý tưởng cho các môi trường tách mạng. Mã của bạn không bao giờ rời khỏi máy của bạn.

**Hỏi: Nó so sánh như thế nào với các công cụ tìm kiếm mã nguồn sử dụng AI?**

Tìm kiếm mã truyền thống (ripgrep, searchcode) sử dụng việc đối chiếu từ khóa. Understand-Anything thêm khả năng hiểu ngữ nghĩa thông qua embeddings và nhận thức về cấu trúc thông qua đồ thị. Bạn có thể tìm kiếm theo ý nghĩa ("tìm các trình xử lý xác thực") chứ không chỉ theo tên ("auth").

**Hỏi: Tôi có thể truy vấn biểu đồ bằng lập trình không?**

Vâng. GQL (Ngôn ngữ Truy vấn Đồ thị) hỗ trợ các truy vấn cấu trúc, tìm kiếm ngữ nghĩa và các bộ lọc tùy chỉnh. Bạn cũng có thể xuất đồ thị ra JSON và xử lý nó bằng bất kỳ ngôn ngữ nào.

**Hỏi: Nó có hoạt động với monorepos không?**

Vâng. Understand-Anything xử lý monorepo một cách tự nhiên. Đặt cờ `--root` đến gốc của monorepo và chỉ định các gói cần bao gồm. Việc phát hiện phụ thuộc giữa các gói hoạt động tự động.

**Hỏi: Kích thước mã nguồn tối đa là bao nhiêu?**

Đã được thử nghiệm với các cơ sở mã lên đến 500.000 tệp và 50 triệu dòng mã. Hiệu suất phụ thuộc vào phần cứng — một chiếc laptop hiện đại có thể xử lý 10.000 tệp một cách dễ dàng. Đối với các dự án lớn hơn, hãy sử dụng các cờ `--workers` và `--low-memory`.

**Hỏi: Có giao diện web không?**

Vâng. Xuất `--format html` tạo ra một trình xem web tương tác đầy đủ với các chức năng phóng to, thu nhỏ, tìm kiếm và nhấp để điều hướng. Không cần máy chủ — đây là một tệp HTML tĩnh.

## Kết luận

Hiểu một cơ sở mã không nên yêu cầu phải ghi nhớ cấu trúc tệp hoặc tìm kiếm qua hàng nghìn dòng mã. Understand-Anything thay đổi điều đó bằng cách biến mã của bạn thành một đồ thị tri thức tương tác — thứ mà bạn có thể khám phá, truy vấn và suy luận về nó.

Thực tế là nó hoạt động với Claude Code, Codex, Cursor, Copilot và Gemini CLI khiến nó trở thành một bộ chuyển đổi toàn diện cho hệ sinh thái lập trình AI. Dù bạn sử dụng công cụ nào, lớp biểu đồ nằm bên dưới và làm cho mọi thứ thông minh hơn.

Hơn 60.000 sao trong một tháng không chỉ là thị phi. Đó là các nhà phát triển nhận ra rằng việc điều hướng các cơ sở mã nên cảm giác như khám phá một bản đồ, chứ không phải đọc sổ điện thoại.

Hãy thử nó trong dự án tiếp theo của bạn. Sao chép một kho lưu trữ, chạy `understand-anything analyze .`, và xem biểu đồ xuất hiện. Bạn sẽ tự hỏi làm sao bạn từng bắt đầu mà không có nó.

**Hành động kêu gọi**: Hãy thử Understand-Anything hôm nay. Tham gia [nhóm Telegram dibi8](https://t.me/DIBI8_Group/2) để thảo luận về trực quan hóa mã và quy trình phát triển được hỗ trợ bởi AI.

Để tìm hiểu thêm về các công cụ lập trình AI, hãy xem hướng dẫn của chúng tôi về [thành thạo Claude Code](dibi8-claude-code-mastery) và [tối ưu hóa Cursor IDE](dibi8-cursor-optimization).

---

**Nguồn & Đọc thêm**:
- Tài liệu chính thức: https://github.com/Egonex-AI/Understand-Anything
- Kho lưu trữ GitHub: https://github.com/Egonex-AI/Understand-Anything
- Trình diễn trực tiếp: https://egonex.ai/understand-anything/demo
- Thảo luận cộng đồng: https://github.com/Egonex-AI/Understand-Anything/discussions

**Tiết lộ liên kết tiếp thị**: Bài viết này chứa các liên kết tiếp thị. Nếu bạn đăng ký thông qua các liên kết của chúng tôi, chúng tôi có thể nhận được hoa hồng mà không tốn thêm chi phí nào cho bạn.

- Lưu trữ đám mây cho các dự án AI của bạn: [DigitalOcean](https://m.do.co/c/eca87ac14ee0)
- Lưu trữ thay thế: [HTStack](https://my.htstack.com/aff.php?aff=27187)
- Công cụ giao dịch: [Binance](https://www.bsmkweb.cc/register?ref=DIBI8), [OKX](https://www.promoohubly.com/join/12190433)
- Proxy để thu thập dữ liệu web: [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f)
