---
title: 'Tại Sao Claude Code Của Bạn Quên Mọi Thứ Mỗi Ngày: Hướng Dẫn Triển Khai Bộ Nhớ AI Agent Lập Trình 2026'
description: 'Tại Sao Claude Code Của Bạn Quên Mọi Thứ Mỗi Ngày: Hướng Dẫn Triển Khai Bộ Nhớ AI Agent Lập Trình 2026'
date: 2026-05-17 00:00:00+08:00
lastmod: 2026-05-17 00:00:00+08:00
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
last_maintained: '2026-05-17'
featureImage: ''
draft: false
aliases:
- /posts/why-claude-code-forgets-memory-fix/
---

{</* resource-info */>}

**Meta Description:** Hướng dẫn thực chiến cài đặt rohitg00/agentmemory và mattpocock/skills — hai dự án đang thống trị GitHub Trending tháng 5/2026. Giúp Claude Code, Cursor và Codex CLI ghi nhớ lâu dài giữa các session, biến agent từ "thực tập sinh" thành đồng nghiệp thực thụ.

**Ngày xuất bản:** 2026-05-17
**Thẻ:** bộ nhớ AI agent, agentmemory, Claude Code memory, MCP server, kỹ năng agent, mattpocock skills, GitHub trending 2026, lập trình agent AI

---

## Mở đầu: Vòng lặp đào tạo lại vô tận

Nếu bạn dùng Claude Code hay Cursor Agent quá ba ngày, chắc chắn đã trải qua cảm giác này: hôm qua vừa giải thích xong kiến trúc dự án, quy tắc xử lý lỗi, và ba file tuyệt đối không được động — sáng nay mở session mới, agent quên sạch. Bạn lại phải bắt đầu từ "Đây là dự án Python backend..."

Đây không phải lỗi của Claude. Đây là giới hạn cấu trúc của LLM inference không trạng thái (stateless). Mỗi session khởi động từ con số không. Context window giống như RAM — tắt máy là mất dữ liệu.

Tháng 5/2026, hai dự án open-source liên tục đứng đầu GitHub Trending đang giải quyết vấn đề này tại tầng hạ tầng, không phải tầng mô hình. Và vì cả hai đều dùng giấy phép tự do (Apache-2.0 và MIT), bạn có thể áp dụng ngay mà không lo bị khóa vào nhà cung cấp.

- **rohitg00/agentmemory** (Apache-2.0, 6,500+ stars): tầng bộ nhớ lâu dài chuyên biệt cho coding agent
- **mattpocock/skills** (MIT, 75,000+ stars): khung kỹ năng production-grade cho Claude/Codex agent

Bài viết này không phải bản dịch README. Tôi sẽ phân tích kiến trúc, hướng dẫn cài đặt, tích hợp MCP, và các bẫy production mà ít người đề cập.

---

## 1. Ba tầng bệnh lý "trí nhớ cá vàng" của coding agent

### 1.1 Quên ở tầng session — biểu hiện rõ nhất

Claude Code, Cursor Agent, Codex CLI đều hoạt động theo dạng hội thoại. Một session đóng lại, những thông tin sau bay hơi ngay lập tức:

- Thiết kế API vừa được phê duyệt
- Phong cách xử lý lỗi bạn ưa thích (throw exception vs trả về Result type)
- Nguyên nhân gốc rễ của bug vừa sửa xong
- Ràng buộc "không được động file này" mà bạn đã nhấn mạnh

### 1.2 Quên ở tầng dự án — quy chuẩn không được lắng đọng

Ngay cả trong cùng một session, agent cũng khó duy trì phong cách coding nhất quán khi xử lý 20 file. Điều đáng sợ hơn: ba ngày trước bạn mất nửa tiếng giúp agent hiểu data flow của dự án, ba ngày sau nó quên sạch và thiết kế lại từ đầu.

### 1.3 Quên ở tầng team — kiến thức không thể kế thừa

Trong môi trường nhóm, quy tắc mà đồng nghiệp A thiết lập với agent không thể chuyển giao cho đồng nghiệp B. Mỗi lập trình viên đều phải "thuần hóa" lại agent từ con số không.

---

## 2. Kiến trúc agentmemory: Gắn "ổ cứng ngoài" cho agent

### 2.1 Thiết kế lõi: iii engine + mô hình lưu trữ cục bộ

agentmemory không cố thay thế vector database. Nó làm một việc chính xác hơn: quan sát cuộc hội thoại, đánh giá điểm "đáng nhớ" của từng câu, và chỉ lưu những sự kiện thực sự cần thiết cho session tương lai.

```
┌─────────────────────────────────────────┐
│           Truy vấn người dùng            │
│        (Claude Code / Cursor)            │
└──────────────┬──────────────────────────┘
               │
        ┌──────▼──────┐
        │ iii Engine  │  ← trích xuất sự kiện + chấm điểm mức độ quan trọng
        │  Bộ xử lý   │
        └──────┬──────┘
               │
    ┌──────────┼──────────┐
    ▼          ▼          ▼
┌───────┐  ┌───────┐  ┌───────┐
│ Facts │  │Preferences│  │Constraints│
│ Tầng  │  │ Tầng     │  │ Tầng      │
│ sự kiện│  │ ưu tiên  │  │ ràng buộc │
└───┬───┘  └───┬───┘  └───┬───┘
    │          │          │
    └──────────┼──────────┘
               ▼
        ┌──────────────┐
        │ SQLite / JSON │  ← lưu trữ cục bộ, không phụ thuộc dịch vụ ngoài
        │   (local)     │
        └──────────────┘
```

Cấu trúc bộ nhớ ba tầng:

| Tầng | Nội dung lưu trữ | Cách truy xuất | Thời hạn |
|------|-----------------|---------------|---------|
| **Facts** | "Người dùng thích Result<T,E> hơn throw" | Tìm kiếm ngữ nghĩa + từ khóa | Dài hạn |
| **Preferences** | "Thụt lề 2 dấu cách, không dùng chấm phẩy" | Khớp chính xác, tự động chèn khi khởi động | Vĩnh viễn |
| **Constraints** | "KHÔNG ĐƯỢC sửa auth/middleware.ts" | Tìm theo tag, kiểm tra trước khi thực thi | Cho đến khi gỡ bỏ |

### 2.2 Cài đặt: npm một dòng lệnh

```bash
# Cài đặt npm (khuyến nghị làm MCP server cho Claude Code / Cursor)
npm install -g agentmemory

# Hoặc Docker (cho team chia sẻ bộ nhớ)
docker run -d -p 37777:37777 -v agentmemory-data:/data rohitg00/agentmemory
```

### 2.3 Tích hợp MCP: Claude Code có bộ nhớ bản địa

Điểm mạnh nhất của agentmemory là tích hợp MCP gốc. Claude Code với tư cách MCP client có thể gọi trực tiếp các tool của agentmemory.

Thêm vào cấu hình MCP của Claude Code:

```json
{
  "mcpServers": {
    "agentmemory": {
      "command": "npx",
      "args": ["-y", "agentmemory", "mcp"],
      "env": {
        "AGENTMEMORY_DB_PATH": "~/.agentmemory/project.db"
      }
    }
  }
}
```

Sau khi cấu hình, Claude Code tự động có bốn công cụ:

- `agentmemory_remember` — đánh dấu sự kiện cần lưu lâu dài
- `agentmemory_recall` — truy xuất ký ức liên quan đến ngữ cảnh hiện tại
- `agentmemory_forget` — xóa ràng buộc đã lỗi thời
- `agentmemory_list_preferences` — chèn ưu tiên khi session khởi động

### 2.4 Thực chiến: Luồng session thực tế

**Session 1 (Thứ Hai)**

```
Người dùng: Viết giúp tôi middleware xác thực người dùng
Claude: Tôi sẽ dùng JWT + bcrypt...
Người dùng: Khoan, dự án này dùng Argon2id, cấm bcrypt
Claude: [gọi agentmemory_remember]
      → Lưu: "Xác thực: dùng Argon2id, không dùng bcrypt"
      → Tag: ["auth", "security", "preference"]
```

**Session 2 (Thứ Tư, session hoàn toàn mới)**

```
Claude: [tự động gọi agentmemory_recall khi khởi động]
      → Truy xuất: "Xác thực: dùng Argon2id, không dùng bcrypt"
      → Chèn vào system prompt

Người dùng: Viết thêm API reset mật khẩu
Claude: Tôi sẽ xử lý hash bằng Argon2id...
      (không lặp lại cuộc đối thoại thứ Hai, trực tiếp kế thừa quy tắc)
```

### 2.5 Cạm bẫy production: PII và phình to bộ nhớ

**Rủi ro rò rỉ PII**

Người dùng có thể vô tình tiết lộ API key, mật khẩu, thông tin cá nhân trong hội thoại. agentmemory không tự động ẩn danh.

**Giải pháp:**

```javascript
// Thêm lớp lọc PII trước MCP server
const { PresidioAnalyzer } = require('presidio-anonymizer');

agentmemory.setFilter(async (fact) => {
  const pii = await analyzer.analyze(fact.content);
  if (pii.length > 0) {
    return { ...fact, content: '[REDACTED_PII]', store: false };
  }
  return fact;
});
```

**Phình to bộ nhớ**

Sau thời gian dài, có thể tích lũy hàng vạn ký ức, làm chậm truy xuất.

**Giải pháp:**

```bash
# Thiết lập chính sách lưu trữ tự động
agentmemory config --archive-after-days 90 --compress-old --max-memories-per-query 5
```

---

## 3. mattpocock/skills: Từ "chatbot lập trình" đến "agent kỹ sư"

### 3.1 Skills là gì

Skills là tập hợp chỉ thị có cấu trúc cho Claude Code, Codex CLI và Cursor. Nó không coi agent như công cụ sinh code "viết giúp tôi hàm này", mà như thành viên nhóm tuân thủ quy chuẩn kỹ thuật.

Matt Pocock là một trong những creator nội dung TypeScript nổi tiếng nhất. Kinh nghiệm dạy con người của anh được chuyển hóa thành dạy agent.

### 3.2 Cấu trúc thư mục Skills: Agent có ý thức nghề nghiệp

```
.claude/skills/
├── 00-always/
│   └── engineering-principles.md      # Nguyên tắc cơ bản, luôn tải
├── 10-planning/
│   ├── architecture-review.md          # Trước khi sửa, xem xét kiến trúc
│   └── scope-definition.md           # Xác định rõ phạm vi thay đổi
├── 20-coding/
│   ├── type-safety-first.md            # Ưu tiên type safety
│   ├── error-handling-patterns.md      # Quy chuẩn xử lý lỗi
│   └── test-driven-refactoring.md      # Refactor trước hết viết test
├── 30-reviewing/
│   ├── self-review-checklist.md        # Checklist tự kiểm tra trước khi nộp
│   └── regression-risk-assessment.md  # Đánh giá rủi ro hồi quy
└── 90-debugging/
    ├── systematic-debugging.md         # Quy trình debug có hệ thống
    └── root-cause-documentation.md     # Ghi chép nguyên nhân gốc rễ
```

Tiền tố số là thứ tự ưu tiên. `00-always/` được tải trước tiên. Các tầng khác được chọn lọc tải theo tình huống.

### 3.3 Một file Skill tiêu biểu

`20-coding/type-safety-first.md`:

```markdown
# Type Safety First

## Nguyên tắc

Trong mọi tác vụ coding, tính chính xác của type system được ưu tiên hơn runtime.
Nếu một thay đổi làm suy yếu hệ thống type (any, @ts-ignore, type assertion),
bắt buộc phải thảo luận và nhận được sự đồng ý rõ ràng.

## Danh sách cấm

- Cấm dùng `any`, trừ trường hợp thiếu type thư viện bên thứ ba
- Cấm `@ts-ignore`, dùng `@ts-expect-error` kèm lý do
- Cấm type assertion không cần thiết `as Type`

## Quy trình ngoại lệ

Nếu bắt buộc phải phá vỡ quy tắc:
1. Thêm `// TYPE-SAFETY-EXCEPTION: [lý do]` bên cạnh code
2. Trích dẫn ngoại lệ trong mô tả PR
3. Tối đa 3 ngoại lệ cùng loại trên một file
```

Đây không phải prompt. Đây là **tài liệu chính sách** mà agent đọc, hiểu và thực thi. Vì nó nằm trong Git, nó tiến hóa cùng team.

### 3.4 Cài đặt: Không phá hoại, áp dụng từng bước

```bash
# Clone vào thư mục dự án
git clone https://github.com/mattpocock/skills.git .claude/skills

# Kích hoạt trong Claude Code
# ~/.claude/config.json
{
  "skillsDir": "./.claude/skills",
  "autoLoad": ["00-always"],
  "selectiveLoad": true
}
```

Điểm then chốt: skills không yêu cầu thay đổi toàn bộ quy trình ngay ngày đầu. Bắt đầu từ `00-always`, tuần sau thêm `20-coding`, để team phê duyệt từng skill trước khi nó thành chính sách.

---

## 4. Hiệu ứng nhân: agentmemory × skills

Từng công cụ riêng lẻ đã hữu ích. Kết hợp, chúng tạo ra thứ gì đó khác biệt về chất so với "autocomplete thông minh".

```
agentmemory:     "Nhớ: người dùng cấm bcrypt, ưu tiên Argon2id"
        ↓
mattpocock/skills: "Áp dụng nguyên tắc ưu tiên bảo mật khi coding"
        ↓
Claude Code:     "Đang viết module xác thực. Argon2id + ưu tiên bảo mật
                  → tự động chọn tham số an toàn theo OWASP
                  → thêm so sánh an toàn về thời gian
                  → ghi chú lý do lựa chọn trong comment"
```

Bộ nhớ cung cấp **ngữ cảnh cá nhân hóa**. Skills cung cấp **kỷ luật kỹ thuật**. Chỉ khi cả hai kết hợp, agent mới thực sự có giá trị sử dụng ngang một thành viên nhóm mới.

---

## 5. So sánh với các giải pháp khác

| Giải pháp | Định vị | Giấy phép | Phù hợp coding agent | MCP gốc | Thời gian cài |
|-----------|---------|-----------|---------------------|---------|---------------|
| **agentmemory** | Bộ nhớ chuyên biệt coding | Apache-2.0 | ★★★★★ | ✅ | 5 phút |
| **Mem0** | Bộ nhớ agent đa năng | Apache-2.0 | ★★★★☆ | ✅ | 10 phút |
| **Zep** | Doanh nghiệp + suy luận thời gian | MIT | ★★★☆☆ | Cần adapter | 1 giờ |
| **Letta** | Agent runtime + tự chỉnh sửa bộ nhớ | MIT | ★★★☆☆ | ❌ | Nửa ngày |
| **Supermemory** | API bộ nhớ + tiện ích trình duyệt | MIT | ★★★★☆ | ✅ | 15 phút |

**Khuyến nghị:**

- **Lập trình viên cá nhân / nhóm nhỏ:** agentmemory + mattpocock/skills, miễn phí, lưu trữ cục bộ, 5 phút triển khai
- **Chia sẻ bộ nhớ đa nền tảng:** Mem0 hoặc Supermemory, đồng bộ cloud
- **Nghiên cứu / agent chạy dài ngày:** Letta, khả năng tự chỉnh sửa bộ nhớ không thể thay thế
- **Ngành y tế, tài chính (tuân thủ):** Zep, xử lý PII và cửa sổ thời gian hợp lệ tích hợp sẵn

---

## 6. Triển khai cấp team và tích hợp CI

### 6.1 Bộ nhớ chia sẻ với Docker Compose

```yaml
version: '3.8'
services:
  agentmemory:
    image: rohitg00/agentmemory:latest
    ports:
      - "37777:37777"
    volumes:
      - agentmemory-data:/data
    environment:
      - AGENTMEMORY_API_KEY=${AGENTMEMORY_API_KEY}
      - AGENTMEMORY_ENCRYPTION_AT_REST=true

  chroma:
    image: chromadb/chroma:latest
    volumes:
      - chroma-data:/chroma/chroma

volumes:
  agentmemory-data:
  chroma-data:
```

### 6.2 CI: Kiểm tra hồi quy bộ nhớ agent

```yaml
# .github/workflows/agentmemory-regression.yml
name: Agent Memory Regression
on: [push]
jobs:
  memory-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Khởi động agentmemory
        run: docker compose up -d agentmemory
      - name: Chạy kiểm tra tính nhất quán bộ nhớ
        run: |
          npm test -- tests/agentmemory/
          npx agentmemory verify --expected memories/critical-facts.json
```

### 6.3 Quản lý phiên bản Skills

Xử lý `.claude/skills/` như code production:

```bash
# Yêu cầu review của con người khi thay đổi skill
echo ".claude/skills/ merge=skills-review" >> .gitattributes

# Kiểm tra cấu trúc file skill
npx skills-linter .claude/skills/
```

---

## Tóm tắt và danh sách hành động

Bảng xếp hạng GitHub Trending tháng 5/2026 đang gửi một tín hiệu rõ ràng: **coding agent đang tiến hóa từ "đồ chơi chatbot" thành "công cụ kỹ thuật"**, và cộng đồng open-source đang xây dựng hạ tầng để biến điều đó thành hiện thực.

Bộ nhớ lâu dài (agentmemory) và kỹ năng có cấu trúc (mattpocock/skills) là hai trụ cột. Không cần đăng ký cloud, không bị khóa vào vendor, cả hai đều đang phát triển tích cực dưới giấy phép tự do.

**Làm ngay tối nay:**

1. ✅ `npm install -g agentmemory`
2. ✅ Thêm agentmemory server vào cấu hình MCP của Claude Code
3. ✅ `git clone https://github.com/mattpocock/skills.git .claude/skills`
4. ✅ Kích hoạt skills directory trong `.claude/config.json`
5. ✅ Dạy agent một ràng buộc, đóng session, mở lại, xác minh agent vẫn nhớ

Nếu bước 5 thành công, agent của bạn không còn là thực tập sinh cần đào tạo lại mỗi sáng. Nó là đồng nghiệp ghi nhớ sở thích của bạn và tuân thủ quy chuẩn kỹ thuật của nhóm. Đó là sự khác biệt giữa prototype và công cụ production.

---

## Tài liệu tham khảo

- [rohitg00/agentmemory trên GitHub](https://github.com/rohitg00/agentmemory)
- [mattpocock/skills trên GitHub](https://github.com/mattpocock/skills)
- [GitHub Trending AI DevTools May 2026 | SignalForges](https://signalforges.com/pages/github-trending-ai-devtools-2026-05-13/)
- [Best AI Agent Memory Frameworks 2026 | Atlan](https://atlan.com/know/best-ai-agent-memory-frameworks-2026/)

*Bài viết dựa trên dữ liệu công khai từ GitHub Trending và Hacker News tháng 5/2026. Số sao và thứ hạng được cập nhật đến ngày 2026-05-17.*
