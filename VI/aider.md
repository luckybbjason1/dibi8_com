---
title: 'Aider: 45K+ Stars — Lập Trình Cặp AI trong Terminal vs Claude Code, Cursor 2026'
description: 'Aider là công cụ lập trình cặp AI trong terminal, chỉnh sửa code trong git repository cục bộ. Hỗ trợ OpenAI, Claude, DeepSeek, Gemini. Hướng dẫn cài đặt Aider, tutorial, tích hợp Git, benchmark và so sánh với Claude Code, Cursor, Codex CLI.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/Aider-AI/aider'
stars: 45040
maintainer: 'paul-gauthier'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['aider', 'ai-pair-programming', 'terminal-ai', 'cli-coding', 'git-ai', 'llm-tools', 'mã-nguồn-mở']
aliases:
- /vi/posts/aider/
---

{{</* resource-info */>}}

## Giới thiệu

Terminal luôn là nơi làm việc của những ngườ dùng cao cấp. Đến năm 2026, đây cũng là nơi trợ lý lập trình AI mạnh mẽ nhất hoạt động. Aider, một công cụ lập trình cặp AI mã nguồn mở trong terminal với hơn 45,000 sao GitHub, đã trở thành vũ khí lựa chọn cho các nhà phát triển muốn có hỗ trợ AI mà không cần từ bỏ trình soạn thảo hiện tại hay trả phí đăng ký hàng tháng. Không giống như các lựa chọn thay thế bị khóa trong IDE, Aider hoạt động với VS Code, Vim, Neovim, Emacs, hoặc bất kỳ trình soạn thảo văn bản nào — vì nó hoạt động trực tiếp trên git repository của bạn, không phải là một plugin trong trình soạn thảo. Nếu bạn đang tìm kiếm hướng dẫn aider, so sánh aider vs claude code, hoặc tìm kiếm một cấu hình ai pair programming cấp production, hướng dẫn này bao gồm cài đặt, cấu hình, benchmark và đánh giá trung thực về ưu nhược điểm.

## Aider là gì?

Aider là công cụ lập trình cặp AI trong terminal. Đây là một công cụ dòng lệnh cho phép bạn kết hợp với mô hình ngôn ngữ lớn để chỉnh sửa code trong git repository cục bộ của bạn. Aider đọc codebase, thực hiện thay đổi trên nhiều file, và tự động commit từng thay đổi với thông điệp mô tả chi tiết. Aider hỗ trợ nhiều nhà cung cấp mô hình khác nhau — OpenAI GPT, Anthropic Claude, DeepSeek, Google Gemini, các mô hình cục bộ qua Ollama, và hơn một chục nhà cung cấp khác. Mỗi lần chỉnh sửa đều là một git commit riêng biệt — cho phép bạn có khả năng kiểm tra chi tiết và khôi phục dễ dàng.

## Aider hoạt động như thế nào

Kiến trúc của Aider tập trung vào ba khái niệm cốt lõi: repo map, edit format, và architect mode.

![Kiến trúc Aider](https://aider.chat/assets/logo.svg)

**Repo Map:** Trước khi thực hiện bất kỳ thay đổi nào, Aider xây dựng một bản đồ codebase của bạn bằng cách sử dụng các trình phân tích cú pháp tree-sitter. Bản đồ này cho LLM biết vị trí các hàm, lớp và kiểu dữ liệu được định nghĩa trong các file khác nhau — cho phép chỉnh sửa nhiều file mà không cần tải toàn bộ repository vào ngữ cảnh. Đối với một dự án Python 50.000 dòng, repo map thường tiêu thụ dưới 2.000 token, để lại phần lớn cửa sổ ngữ cảnh cho tác vụ chỉnh sửa thực tế.

**Edit Format:** Aider sử dụng các định dạng diff có cấu trúc (unified diff, diff-fenced, hoặc editor-diff) để chỉ định chính xác cách LLM sửa đổi các file. Điều này đáng tin cậy hơn là yêu cầu mô hình xuất ra toàn bộ file, đặc biệt là đối với các codebase lớn. Bảng xếp hạng benchmark đa ngôn ngữ cho thấy các mô hình sử dụng chỉnh sửa dựa trên diff đạt tỷ lệ định dạng chỉnh sửa chính xác từ 88-98%.

**Architect Mode:** Đối với các thay đổi phức tạp, Aider tách biệt việc lập kế hoạch và thực thi. Một mô hình suy luận (như o3 hoặc Claude Opus) soạn thảo kế hoạch kiến trúc, trong khi một mô hình chỉnh sửa nhanh (như GPT-4.1) thực thi các thay đổi file. Cách tiếp cận hai mô hình này giảm chi phí 40-60% cho các chỉnh sửa thông thường trong khi vẫn duy trì chất lượng cao cho các tác vụ tái cấu trúc phức tạp.

```bash
aider --model o3 --editor-model gpt-4.1 --architect
```

## Cài đặt & Thiết lập

Bắt đầu với Aider chỉ mất dưới năm phút. Bạn cần Python 3.8-3.13 và một API key từ ít nhất một nhà cung cấp LLM.

**Bước 1 — Cài đặt Aider:**

```bash
# Sử dụng aider-install (khuyến nghị)
python -m pip install aider-install
aider-install

# Hoặc sử dụng uv
python -m pip install uv
uv tool install --force --python python3.12 --with pip aider-chat@latest

# Lệnh một dòng cho Mac/Linux
curl -LsSf https://aider.chat/install.sh | sh

# Lệnh một dòng cho Windows
powershell -ExecutionPolicy ByPass -c "irm https://aider.chat/install.ps1 | iex"
```

**Bước 2 — Cấu hình API key:**

```bash
# Claude (Anthropic)
export ANTHROPIC_API_KEY=sk-ant-api03-your-key

# OpenAI
export OPENAI_API_KEY=sk-proj-your-key

# DeepSeek
export DEEPSEEK_API_KEY=sk-your-key

# Google Gemini
export GEMINI_API_KEY=your-key

# Hoặc sử dụng file .env trong thư mục gốc dự án
echo "ANTHROPIC_API_KEY=sk-ant-api03-your-key" > .env
```

**Bước 3 — Bắt đầu lập trình:**

```bash
cd /to/your/project

# Với Claude Sonnet
aider --model sonnet

# Với OpenAI GPT-5
aider --model gpt-5

# Với DeepSeek (tùy chọn tiết kiệm)
aider --model deepseek --api-key deepseek=sk-your-key

# Với mô hình cục bộ qua Ollama
ollama pull qwen2.5-coder:32b
aider --model ollama/qwen2.5-coder:32b
```

**Phương án Docker:**

```bash
docker run -it --rm \
  -v $(pwd):/app \
  -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
  paulgauthier/aider \
  --model sonnet
```

## Tích hợp với các công cụ phổ biến

### VS Code

Aider không yêu cầu extension VS Code. Khởi động Aider trong terminal dự án của bạn, sau đó chỉnh sửa file trong VS Code như bình thường. Aider giám sát git repository và tự động commit các thay đổi. Để có luồng làm việc chặt chẽ hơn, sử dụng cờ `--watch-files`:

```bash
# Terminal 1: khởi động aider
aider --model sonnet --watch-files

# Trong VS Code: thêm comment AI như "// AI: refactor cái này sang async/await"
# Aider nhận comment, thực hiện thay đổi, và commit
```

### Vim / Neovim

Aider phù hợp tự nhiên với luồng làm việc Vim. Chạy nó trong một cửa sổ tmux chia đôi bên cạnh trình soạn thảo của bạn:

```bash
# Cấu hình tmux cho aider + vim
tmux new-session -d -s aider-vim
tmux split-window -h -t aider-vim
tmux send-keys -t aider-vim.0 'vim .' C-m
tmux send-keys -t aider-vim.1 'aider --model sonnet' C-m
tmux attach -t aider-vim
```

### Git và GitHub

Tích hợp git của Aider là tính năng nổi bật. Mỗi chỉnh sửa được hỗ trợ bởi AI đều trở thành một commit riêng biệt:

```bash
# Trong phiên aider
> /add src/auth.js src/middleware.js
> Thêm xác thực JWT token vào auth middleware

# Aider thực hiện thay đổi và commit:
# [main a1b2c3d] feat: Thêm xác thực JWT token vào auth middleware
#  2 files changed, 45 insertions(+), 12 deletions(-)

# Xem xét các commit trước khi push
git log --oneline -10
git diff HEAD~3..HEAD  # xem xét 3 commit AI gần nhất

# Push lên GitHub
git push origin main
```

### Tích hợp GitLab CI/CD

```yaml
# .gitlab-ci.yml - pipeline đánh giá code AI
ai-review:
  image: python:3.12
  before_script:
    - pip install aider-chat
  script:
    - aider --model sonnet --message "Đánh giá MR này về vấn đề bảo mật" --no-auto-commits
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
```

### Pre-commit hooks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: aider-lint
        name: Chạy sửa lỗi lint aider
        entry: aider --lint-cmd "npm run lint" --lint
        language: system
        pass_filenames: false
```

## Benchmark / Trường hợp sử dụng thực tế

Aider duy trì bảng xếp hạng LLM coding được trích dẫn rộng rãi nhất trong ngành. Benchmark đa ngôn ngữ kiểm tra 225 bài tập lập trình Exercism đầy thách thức trên C++, Go, Java, JavaScript, Python và Rust.

### Bảng xếp hạng đa ngôn ngữ (Các mô hình hàng đầu, tháng 5/2026)

| Mô hình | Điểm | Chi phí/chạy | Định dạng chỉnh sửa |
|---------|------|-------------|---------------------|
| GPT-5 (high) | 88.0% | $29.08 | diff |
| GPT-5 (medium) | 86.7% | $17.69 | diff |
| o3-pro (high) | 84.9% | $146.32 | diff |
| Gemini 2.5 Pro (32k think) | 83.1% | $49.88 | diff-fenced |
| GPT-5 (low) | 81.3% | $10.37 | diff |
| Grok-4 (high) | 79.6% | $59.62 | diff |
| DeepSeek-V3.2 Reasoner | 74.2% | $1.30 | diff |

Khoảng cách về chi phí đáng kinh ngạc: DeepSeek V3.2 Reasoner đạt 74.2% với $1.30 mỗi lần chạy benchmark — rẻ hơn hơn 20 lần so với các mô hình frontier. Đối với việc tái cấu trúc thông thường, tạo boilerplate, và viết test, đây là lựa chọn thực tế.

### Benchmark riêng của Aider

Aider cũng tự benchmark trên các tác vụ lập trình thực tế:

| Mô hình | Tỷ lệ đạt | Token trung bình | Độ trễ |
|---------|-----------|------------------|--------|
| Claude Sonnet 4 | 72% | 18,400 | 45 giây |
| GPT-4.1 | 68% | 22,100 | 38 giây |
| DeepSeek V3.2 | 61% | 25,600 | 52 giây |
| Gemini 2.5 Pro | 69% | 19,800 | 41 giây |

### Dữ liệu năng suất thực tế

Dựa trên báo cáo cộng đồng và khảo sát nhà phát triển năm 2026:

- **Nhà phát triển độc lập:** Giảm trung bình 35-45% thờ gian viết boilerplate khi sử dụng Aider với Sonnet hoặc GPT-5
- **Tác vụ tái cấu trúc:** Các tác vụ tái cấu trúc đa file từng mất 4-6 giờ thủ công nay hoàn thành trong 45-90 phút với Aider
- **Tạo test:** Độ phủ dòng tăng từ trung bình 60% lên 85% khi sử dụng Aider để viết test cho code hiện có
- **Lịch sử git:** Ngườ dùng Aider báo cáo số lượng commit hàng ngày tăng 3-5 lần nhờ độ chi tiết của auto-commit, giúp code review dễ dàng hơn

## Sử dụng nâng cao / Củng cố production

### Bảo mật: Hạn chế truy cập file

```bash
# Chỉ cho phép chỉnh sửa các thư mục cụ thể
aider --model sonnet --read-only src/ --edit docs/

# Sử dụng file .aiderignore
echo "*.secret" > .aiderignore
echo "config/prod.yml" >> .aiderignore
```

### Prompt caching để giảm chi phí

Aider hỗ trợ prompt caching cho các mô hình Anthropic Claude và OpenAI, giảm chi phí API 40-60% trong các cuộc trò chuyện nhiều lượt:

```bash
# Prompt caching tự động cho các mô hình được hỗ trợ
aider --model sonnet --cache-prompts

# Kiểm tra thống kê cache
# Tìm "Cache hit" trong output để xác nhận tiết kiệm
```

### Bí danh mô hình tùy chỉnh

```bash
# ~/.aider.conf.yml
model-alias:
  - fast: gpt-4.1
  - smart: claude-sonnet-4
  - cheap: deepseek/deepseek-chat
  - local: ollama/qwen2.5-coder:32b
```

Sử dụng:

```bash
aider --model fast    # sử dụng gpt-4.1
aider --model smart   # sử dụng claude-sonnet-4
aider --model cheap   # sử dụng DeepSeek
```

### Tích hợp linting và testing

```bash
# Tự động chạy lint sau mỗi lần chỉnh sửa
aider --model sonnet --lint-cmd "npm run lint"

# Tự động chạy test sau mỗi lần chỉnh sửa
aider --model sonnet --test-cmd "npm test" --auto-test

# Chỉ commit nếu test đạt
aider --model sonnet --test-cmd "pytest" --auto-test --test-first
```

### File cấu hình YAML

```yaml
# ~/.aider.conf.yml
model: sonnet
editor: nvim
auto-commits: true
dirty-commits: true
lint-cmd: "npm run lint"
test-cmd: "npm test"
cache-prompts: true
show-model-warnings: false
```

### Giám sát với phân tích

```bash
# Đặt log phân tích để theo dõi chi phí
export AIDER_ANALYTICS_LOG=/var/log/aider/analytics.jsonl

# Theo dõi chi phí từng dự án
aider --model sonnet --analytics-log ./logs/aider.jsonl
```

## So sánh với các lựa chọn thay thế

| Tính năng | Aider | Claude Code | Cursor | Codex CLI |
|-----------|-------|-------------|--------|-----------|
| **Giá** | Miễn phí + API key | $20+/tháng Pro | $20/tháng Pro | ChatGPT Plus $20/tháng |
| **Mã nguồn mở** | Apache-2.0 | Độc quyền | Độc quyền | Độc quyền |
| **Lựa chọn mô hình** | Mọi nhà cung cấp | Chỉ Claude | Hạn chế | Chỉ OpenAI |
| **Tích hợp Git** | Auto-commit mỗi thay đổi | Commit thủ công | Commit thủ công | Commit thủ công |
| **Giao diện** | Terminal | Terminal + IDE plugin | IDE đầy đủ | Terminal |
| **Repo Map** | Có (tree-sitter) | Có | Có | Hạn chế |
| **Architect Mode** | Có (tách kế hoạch/thực thi) | Không | Không | Không |
| **Mô hình cục bộ** | Hỗ trợ Ollama đầy đủ | Không | Không | Không |
| **Chi phí/tháng (sử dụng vừa)** | $5-15 | $20-100 | $20 | $20 |
| **Điểm SWE-bench** | N/A (benchmark LLM) | 72.5% | N/A | 68% |

### Khi nào chọn cái nào

**Chọn Aider khi:**
- Bạn muốn tự do chọn mô hình (Claude hôm nay, DeepSeek ngày mai, mô hình cục bộ khi offline)
- Bạn sống trong terminal và dùng vim/emacs
- Bạn muốn tự động git commit cho mỗi lần chỉnh sửa AI
- Bạn tránh đăng ký tháng và thích định giá API theo mức sử dụng
- Bạn cần architect mode cho luồng đa mô hình phức tạp

**Chọn Claude Code khi:**
- Bạn muốn thiết lập đơn giản nhất không cần cấu hình
- Bạn đã trả phí Claude Pro
- Bạn cần chất lượng suy luận tốt nhất tuyệt đối (Opus 4.6)
- Bạn cần tích hợp Slack và đội đa agent
- Bạn thích trải nghiệm được đánh bóng, có hỗ trợ từ nhà cung cấp

**Chọn Cursor khi:**
- Bạn muốn AI trong IDE đầy đủ với tính năng tự động hoàn thành
- Bạn thích GUI để xem xét diff
- Bạn cần trải nghiệm tab completion tốt nhất
- Nhóm của bạn muốn môi trường lập trình AI chung

**Chọn Codex CLI khi:**
- Bạn đã có ChatGPT Plus
- Bạn muốn thực thi tác vụ nền không đồng bộ
- Bạn chỉ thích các mô hình OpenAI

## Hạn chế / Đánh giá trung thực

Aider không phải là công cụ phù hợp cho mọi nhà phát triển hay mọi tình huống. Đây là những gì nó KHÔNG giỏi:

**Luồng làm việc phụ thuộc GUI:** Nếu bạn cần xem UI được render, quản lý file kéo-thả, hoặc xem xét diff trực quan, giao diện terminal của Aider sẽ gây khó chịu. Cursor hoặc Windsurf phù hợp hơn.

**Ngườ không phải nhà phát triển:** Aider giả định bạn thành thạo git, thoải mái với terminal, và quản lý được API key. Một nhà phát triển không biết cách đặt biến môi trường sẽ gặp khó khăn. Trình cài đặt một lần nhấp của Cursor là lựa chọn khởi đầu tốt hơn.

**Cộng tác thờ gian thực:** Aider là công cụ một ngườ dùng. Không có trạng thái phiên chia sẻ, không có chế độ nhiều ngườ chơi thờ gian thực, và không có dashboard nhóm. Để lập trình cặp với đồng nghiệp, hãy dùng VS Code Live Share + Cursor.

**Trải nghiệm gốc Windows:** Mặc dù Aider hoạt động trên Windows (qua WSL hoặc Python gốc), trải nghiệm terminal-first được tối ưu cho môi trường Unix. Các nhà phát triển Windows thỉnh thoảng báo cáo vấn đề về đường dẫn và mã hóa.

**Tác vụ không phải lập trình:** Aider được xây dựng đặc biệt để chỉnh sửa code trong git repository. Nó không phải chatbot đa năng, trình soạn thảo tài liệu, hay công cụ quản trị hệ thống. Đối với những việc đó, hãy dùng Claude Code hoặc LLM API thô.

**Chênh lệch chất lượng mô hình:** Vì Aider hỗ trợ mọi mô hình, trải nghiệm của bạn thay đổi đáng kể. Một mô hình cục bộ 7B tham số sẽ cho kết quả kém hơn rõ rệt so với Claude Sonnet hay GPT-5. Tự do lựa chọn đi kèm với trách nhiệm chọn mô hình phù hợp cho tác vụ.

## Câu hỏi thường gặp

**Q: Aider tốn bao nhiêu mỗi tháng?**
A: Aider bản thân miễn phí và mã nguồn mở. Bạn chỉ trả phí sử dụng API LLM. Sử dụng vừa phải (50 tác vụ/tuần) tốn khoảng $5-15/tháng với DeepSeek, $15-40/tháng với Claude Sonnet, và $20-60/tháng với GPT-5. Aider bản thân không có phí đăng ký.

**Q: Tôi có thể dùng Aider với trình soạn thảo code hiện tại không?**
A: Có — đây là nguyên tắc thiết kế cốt lõi của Aider. Aider chạy trong terminal và hoạt động trên git repository của bạn. Bạn có thể dùng VS Code, Vim, Neovim, Emacs, Sublime Text, hoặc bất kỳ trình soạn thảo nào đồng thờ. Các thay đổi do Aider thực hiện xuất hiện ngay lập tức trong trình theo dõi file của trình soạn thảo.

**Q: Aider có an toàn cho codebase production không?**
A: Aider commit mọi thay đổi vào git với thông điệp mô tả, vì vậy bạn có thể xem xét và hoàn tác bất kỳ chỉnh sửa nào. Tuy nhiên, bạn nên luôn xem xét code do AI tạo trước khi merge vào main. Dùng `git diff` để kiểm tra thay đổi, chạy test suite với `--auto-test`, và bật bảo vệ nhánh trên GitHub/GitLab.

**Q: Mô hình LLM nào hoạt động tốt nhất với Aider?**
A: Theo bảng xếp hạng đa ngôn ngữ của Aider, GPT-5 (high) đạt điểm cao nhất ở 88.0%, tiếp theo là Claude Sonnet 4 khoảng 84% và Gemini 2.5 Pro ở 83.1%. Đối với công việc nhạy cảm về chi phí, DeepSeek V3.2 Reasoner với 74.2% và $1.30 mỗi lần chạy mang lại giá trị tốt nhất.

**Q: Aider có thể hoạt động không cần kết nối internet không?**
A: Có, nếu bạn dùng mô hình cục bộ qua Ollama hoặc LM Studio. Cài đặt mô hình cục bộ (`ollama pull qwen2.5-coder:32b`), sau đó chạy `aider --model ollama/qwen2.5-coder:32b`. Lưu ý rằng các mô hình cục bộ chậm hơn và kém năng lực hơn API đám mây cho các chỉnh sửa phức tạp trên nhiều file.

**Q: Aider so với GitHub Copilot như thế nào?**
A: Copilot cung cấp tự động hoàn thành inline trong IDE. Aider là agent hội thoại thực hiện chỉnh sửa đa file và commit chúng vào git. Chúng bổ sung cho nhau — nhiều nhà phát triển dùng Copilot cho tự động hoàn thành hàng ngày và Aider cho các tác vụ tái cấu trúc lớn và triển khai tính năng. Copilot giá $10-19/tháng; Aider miễn phí cộng phí API.

**Q: Tôi có thể dùng Aider trong repository riêng của công ty không?**
A: Có. Aider hoạt động hoàn toàn cục bộ — code của bạn không bao giờ rờ khỏi máy trừ khi bạn chủ động thực hiện cuộc gọi API LLM. Để bảo mật tối đa, hãy dùng mô hình cục bộ qua Ollama để code không rờ khỏi mạng của bạn. Luôn xem xét chính sách sử dụng AI của tổ chức trước khi dùng bất kỳ công cụ lập trình AI nào.

## Kết luận

Aider là công cụ lập trình cặp AI linh hoạt và hiệu quả nhất về chi phí có sẵn trong năm 2026. Với hơn 45,000 sao GitHub, kiến trúc độc lập với mô hình, và luồng làm việc git-native, nó lấp đầy một phân khúc độc đáo: lập trình AI ưu tiên terminal mà không có sự khóa chặt nhà cung cấp hay phí đăng ký. Đối với các nhà phát triển sống trong dòng lệnh, coi trọng việc theo dõi commit tự động, và muốn tự do chuyển đổi giữa Claude, GPT, DeepSeek và các mô hình cục bộ, Aider là lựa chọn thực tế.

**Các bước hành động để bắt đầu:**

1. Cài đặt Aider bằng `curl -LsSf https://aider.chat/install.sh | sh`
2. Thiết lập `ANTHROPIC_API_KEY` hoặc `OPENAI_API_KEY`
3. Chạy `aider --model sonnet` trong thư mục dự án
4. Thêm file bằng `/add`, sau đó mô tả bạn muốn gì bằng ngôn ngữ tự nhiên
5. Xem xét auto-commit bằng `git log` trước khi push

Tham gia cộng đồng [Discord](https://discord.gg/Y7X7bhMQFV) hoặc [Telegram](https://t.me/dibi8opensource) để chia sẻ mẹo, nhận trợ giúp và cập nhật các bản phát hành mới.



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài liệu tham khảo

- [Aider GitHub Repository](https://github.com/Aider-AI/aider) — 45,000+ sao, giấy phép Apache-2.0
- [Aider Tài liệu chính thức](https://aider.chat/docs/)
- [Aider LLM Leaderboards](https://aider.chat/docs/leaderboards/) — kết quả benchmark đa ngôn ngữ
- [Aider Hướng dẫn cài đặt](https://aider.chat/docs/install.html)
- [Aider Tài liệu sử dụng](https://aider.chat/docs/usage.html)
- [Claude Code Tài liệu](https://docs.anthropic.com/en/docs/claude-code)
- [Cursor AI Code Editor](https://www.cursor.com/)
- [OpenAI Codex CLI](https://github.com/openai/codex)
- [Exercism Bài tập đa ngôn ngữ](https://exercism.org/) — benchmark mà Aider sử dụng
- [Aider Lịch sử phát hành](https://aider.chat/HISTORY.html)
- [Aider Tham khảo cấu hình](https://aider.chat/docs/config.html)

*Bài viết này chỉ mang tính chất thông tin. Aider là phần mềm mã nguồn mở theo giấy phép Apache-2.0. Luôn xem xét code do AI tạo trước khi triển khai production.*
