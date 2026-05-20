---
title: 'OpenHands: 74K+ Stars — Kỹ sư phần mềm AI viết và chạy code (Hướng dẫn cài đặt 2026)'
description: 'OpenHands là nền tảng phát triển AI đóng vai trò agent kỹ sư phần mềm. Tương thích với VS Code, Docker, GitHub, GitLab, Claude và OpenAI. Bao gồm thiết lập Docker, cấu hình model, chế độ headless CI/CD và bảo mật production.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/OpenHands/OpenHands'
stars: 74200
maintainer: 'OpenHands'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['OpenHands', 'Agent lập trình AI', 'Docker', 'SWE-bench', 'Claude', 'OpenAI', 'tự host', 'tự động hóa']
aliases:
- /vi/posts/openhands/
- /vi/resources/llm-frameworks/openhands-architecture-ai-programmer-agent/
---

{{</* resource-info */>}}

## Giới thiệu

Hầu hết công cụ lập trình AI chỉ dừng lại ở gợi ý code. Bạn nhận được một đề xuất, dán vào, và hy vọng nó biên dịch được. OpenHands có cách tiếp cận khác: đây là agent kỹ sư phần mềm toàn diện, đọc repository, chỉnh sửa file, chạy test, và lặp lại cho đến khi task hoàn thành. Với hơn 74,000 sao GitHub và điểm SWE-bench Verified 72%, đây là agent lập trình open source được triển khai nhiều nhất trong môi trường production.

Hướng dẫn này đi qua cài đặt OpenHands locally, kết nối với LLM provider ưa thích, tích hợp với GitHub, và chạy ở chế độ headless cho pipeline CI/CD. Dù bạn cần một AI engineer local cho task hàng ngày hay agent tự chủ để giải quyết issue hàng loạt, tutorial này bao gồm mọi bước với lệnh và cấu hình thực tế.

## OpenHands là gì?

OpenHands (trước đây là OpenDevin) là agent kỹ sư phần mềm AI open source chạy bên trong container Docker. Nó sử dụng kiến trúc controller-sandbox: controller dựa trên Python quản lý vòng lặp agent (quan sát-suy nghĩ-hành động), trong khi container sandbox cô lập xử lý việc thực thi code, thao tác file, và chạy test.

Các khả năng chính:
- **Thực thi task tự chủ**: Đưa ra một GitHub issue hoặc task ngôn ngữ tự nhiên, nó sẽ giải quyết end-to-end
- **Thực thi code trong sandbox**: Mọi code chạy bên trong container Docker, cô lập với host
- **Phân công multi-agent**: Các task phức tạp được chia cho các sub-agent chuyên biệt
- **Hỗ trợ BYO model**: Hoạt động với Claude, GPT, Gemini, model local qua Ollama hoặc vLLM, và 100+ provider qua LiteLLM
- **Chế độ headless**: Truy cập API lập trình cho CI/CD và xử lý hàng loạt
- **Web UI + CLI**: Cả giao diện browser và workflow terminal-first

## OpenHands hoạt động như thế nào

Kiến trúc có hai thành phần chính:

**Controller Node**: Một server Python quản lý vòng lặp agent, xử lý abstraction LLM qua LiteLLM, và điều phối vòng đồi sandbox. Nó nhận task, phân rã thành các bước, gọi LLM để đưa ra quyết định, và theo dõi trạng thái qua các vòng lặp.

**Sandbox Container**: Container Docker được tạo ra cho mỗi task, nơi mọi thực thi code diễn ra. Agent đọc file, chạy lệnh shell, thực thi test, và viết patch bên trong môi trường cô lập này. Khi task hoàn thành, sandbox bị hủy.

![Kiến trúc OpenHands](https://raw.githubusercontent.com/All-Hands-AI/OpenHands/main/docs/static/img/system_architecture_overview.png)

Vòng lặp agent tuân theo mẫu sau:

```
1. OBSERVE: Đọc mô tả task, trạng thái repository, kết quả hành động trước
2. THINK: LLM tạo kế hoạch (file nào cần sửa, lệnh nào cần chạy)
3. ACT: Thực thi hành động đã lên kế hoạch (read_file, write_file, run_cmd, v.v.)
4. OBSERVE: Ghi nhận kết quả (output, lỗi, kết quả test)
5. REPEAT: Lặp lại cho đến khi task hoàn thành hoặc đạt số vòng tối đa
```

Vòng lặp này thường tiêu tốn 30-50 lần gọi LLM mỗi task. Memory condenser (thêm trong v1.5) tóm tắt context cũ hơn để giữ cửa sổ context tập trung, cải thiện độ trễ và giảm tiêu thụ token trên các task dài.

## Cài đặt & Thiết lập

### Yêu cầu trước khi cài

Trước khi cài đặt OpenHands, hãy đảm bảo bạn có:

- **Docker Desktop** đã cài và đang chạy (cần truy cập Docker socket)
- **4GB+ RAM** (khuyến nghị 8GB cho session đồng thờii)
- **Python 3.12+** (khi cài CLI qua uv)
- **LLM API key** (Anthropic, OpenAI, Google, hoặc endpoint model local)

### Cách 1: Cài CLI qua uv (Khuyến nghị)

Cách nhanh nhất để chạy OpenHands là qua trình cài đặt CLI dựa trên uv:

```bash
# Cài uv nếu chưa có
curl -LsSf https://astral.sh/uv/install.sh | sh

# Cài OpenHands
uv tool install openhands --python 3.12

# Khởi chạy server GUI
openhands serve
```

Server khởi động tại `http://localhost:3000`. Mở trình duyệt, chọn LLM provider, nhập API key, và bạn đã sẵn sàng giao task.

![OpenHands Web UI](https://raw.githubusercontent.com/All-Hands-AI/OpenHands/main/docs/static/img/screenshot.png)

Để nâng cấp sau này:

```bash
uv tool upgrade openhands --python 3.12
```

### Cách 2: Chạy Docker trực tiếp

Nếu bạn muốn dùng Docker mà không cài Python tools:

```bash
# Pull image mới nhất
docker pull ghcr.io/openhands/openhands:latest

# Chạy với Docker socket được mount (bắt buộc cho quản lý sandbox)
docker run -it --rm \
  -p 3000:3000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e SANDBOX_RUNTIME_CONTAINER_IMAGE=ghcr.io/openhands/openhands:latest \
  ghcr.io/openhands/openhands:latest
```

Flag `--mount-cwd` mount thư mục làm việc hiện tại vào sandbox:

```bash
openhands serve --mount-cwd
```

Cho model local với GPU acceleration:

```bash
openhands serve --gpu
```

### Cách 3: Cài qua pip

```bash
pip install openhands-ai

# Khởi động Web UI
openhands serve
```

### Lưu ý cài đặt trên Windows

Trên Windows, chạy mọi lệnh bên trong WSL2 (Ubuntu):

```powershell
# Trong PowerShell với quyền Administrator
wsl --install -d Ubuntu
wsl -d Ubuntu
```

Sau đó bên trong WSL:

```bash
# Cài Docker Desktop for Windows trước, sau đó:
uv tool install openhands --python 3.12
openhands serve
```

## Cấu hình & Task đầu tiên

### Thiết lập LLM Provider

Sau khi khởi chạy OpenHands, cấu hình model trong panel Settings (biểu tượng bánh răng):

1. **Chọn Provider**: Anthropic (Claude), OpenAI (GPT), Google (Gemini), hoặc Local
2. **Chọn Model**: `anthropic/claude-sonnet-4-20250514` được khuyến nghị cho kết quả tốt nhất
3. **Nhập API Key**: Dán API key của provider
4. **Lưu thay đổi**

Cho cấu hình nâng cao, bật Advanced settings để đặt model tùy chỉnh với định dạng tiền tố LiteLLM:

```
anthropic/claude-sonnet-4-5-20250929
openai/gpt-5-2025-08-07
gemini/gemini-3-pro-preview
deepseek/deepseek-chat
```

### Dùng Model Local (Ollama)

Cho các team cần triển khai air-gapped:

```bash
# Khởi động Ollama với model coding mạnh
ollama run qwen3-coder:32b

# Trong OpenHands settings, đặt:
# Custom Model: openai/qwen3-coder:32b
# Base URL: http://host.docker.internal:11434/v1
# API Key: ollama (giá trị nào cũng được)
```

### Chạy task đầu tiên

Mở UI tại `localhost:3000`:

1. Nhập task vào hộp chat: "Thêm docstring cho hàm main trong app.py"
2. Agent sẽ tạo sandbox, đọc file, viết docstring, và xác nhận thay đổi
3. Xem xét diff trước khi chấp nhận

Để giải quyết GitHub issue:

```
Sửa lỗi xác thực được mô tả trong issue #42.
Clone repo, tái tạo lỗi, triển khai bản sửa, và chạy test suite.
```

## Tích hợp với VS Code, GitHub, Docker và CI/CD

### Tích hợp VS Code qua Agent Control Plane (ACP)

OpenHands v1.5+ bao gồm Agent Control Plane cho tích hợp IDE:

```bash
# Cài extension OpenHands VS Code
# Tìm "OpenHands" trong VS Code Extensions marketplace

# Cấu hình extension kết nối với server OpenHands local
# Settings > OpenHands > Server URL: http://localhost:3000
```

Giao thức ACP cho phép VS Code gửi task trực tiếp đến OpenHands và nhận lại edit có cấu trúc dưới dạng diff patches.

### Tích hợp GitHub

Kết nối OpenHands với repository GitHub để tự động giải quyết issue:

```bash
# Đặt GitHub PAT (Personal Access Token) chi tiết
export GITHUB_TOKEN=ghp_your_token_here

# Khởi chạy OpenHands với thông tin xác thực GitHub
docker run -it --rm \
  -p 3000:3000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GITHUB_TOKEN=$GITHUB_TOKEN \
  ghcr.io/openhands/openhands:latest
```

Trong UI, dán URL GitHub issue và OpenHands sẽ:
1. Clone repository
2. Đọc mô tả issue
3. Tái tạo bug
4. Triển khai bản sửa
5. Chạy test xác minh
6. Tạo diff để review

### Tích hợp GitLab

Hỗ trợ GitLab (thêm trong v1.5) hoạt động tương tự:

```bash
export GITLAB_TOKEN=glpat-your-token
docker run -it --rm \
  -p 3000:3000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GITLAB_TOKEN=$GITLAB_TOKEN \
  ghcr.io/openhands/openhands:latest
```

### Docker Compose cho Production

Cho các triển khai persistent, sử dụng Docker Compose:

```yaml
version: "3.8"
services:
  openhands:
    image: ghcr.io/openhands/openhands:latest
    ports:
      - "3000:3000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./workspace:/workspace
    environment:
      - SANDBOX_RUNTIME_CONTAINER_IMAGE=ghcr.io/openhands/openhands:latest
      - LLM_API_KEY=${LLM_API_KEY}
      - LLM_MODEL=anthropic/claude-sonnet-4-20250514
      - SANDBOX_NETWORK_DISABLED=true
      - LOG_LEVEL=info
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
```

Triển khai:

```bash
docker-compose up -d
```

### Chế độ Headless cho Pipeline CI/CD

Chế độ headless chạy OpenHands không có UI tương tác, lý tưởng cho tự động hóa:

```bash
# Chạy task headless
openhands --headless -t "Viết unit test cho auth module"

# Load task từ file
openhands --headless -f task.txt

# Output JSON cho pipeline parsing
openhands --headless --json -t "Sửa API endpoint trong routes.py" > output.jsonl
```

Ví dụ workflow GitHub Actions:

```yaml
name: OpenHands Auto-Fix
on:
  issues:
    types: [labeled]
jobs:
  fix:
    if: github.event.label.name == 'auto-fix'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Chạy OpenHands
        run: |
          docker run --rm \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v $(pwd):/workspace \
            -e LLM_API_KEY=${{ secrets.ANTHROPIC_API_KEY }} \
            ghcr.io/openhands/openhands:latest \
            openhands --headless --json \
            -f .openhands/task.txt > results.jsonl
```

### Tích hợp MCP Server

OpenHands hỗ trợ Model Context Protocol (MCP) servers cho khả năng mở rộng:

```json
{
  "mcpServers": {
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/workspace"]
    }
  }
}
```

## Benchmark / Use Case thực tế

### Hiệu suất SWE-bench Verified

SWE-bench Verified thử nghiệm agent trên 500 issue GitHub thực. Điểm cao hơn có nghĩa là agent có thể tự động giải quyết nhiều bug production hơn.

| Agent + Model | SWE-bench Verified | Ghi chú |
|---|---|---|
| OpenHands + Claude Opus 4.6 | ~72% | Kết quả framework open source tốt nhất |
| OpenHands + Claude Sonnet 4.6 | ~67% | Cân bằng chi phí/chất lượng được khuyến nghị |
| OpenHands + GPT-5 | ~55% | Tốt cho team đã dùng OpenAI |
| OpenHands + Qwen3-Coder-32B (local) | ~32% | Chấp nhận được cho công việc thường ngày |
| OpenHands + Devstral 24B | ~47% | Model open-weight tốt nhất |
| Claude Code + Claude Opus 4.6 | ~78% | Tỷ lệ thành công lần đầu cao nhất |
| Aider + Claude Opus 4.6 | ~62% | Giải pháp CLI mạnh mẽ |

### Chi phí mỗi lần sửa thành công

Cho một task SWE-bench điển hình tiêu thụ ~55K token:

| Model | Chi phí mỗi lần thử | Tỷ lệ thành công | Chi phí mỗi lần thành công |
|---|---|---|---|
| Claude Opus 4.7 | ~$1.50 | 87.6% | ~$1.71 |
| GPT-5.3-Codex | ~$0.90 | 85.0% | ~$1.06 |
| Claude Sonnet 4.6 | ~$0.40 | 67% | ~$0.60 |
| Qwen3.6 Plus (hosted) | ~$0.20 | 78.8% | ~$0.25 |

### Chỉ số triển khai thực tế

Dựa trên các triển khai production được báo cáo bởi cộng đồng:

- **Giải quyết issue**: 30-40% bug được gắn nhãn được giải quyết tự động ngay lần thử đầu
- **Hỗ trợ code review**: Giảm 60% thờii gian review cho PR dưới 200 dòng
- **Tạo test**: Đạt 80%+ coverage trên module mới với prompt "viết test cho X"
- **Tạo tài liệu**: Độ chính xác 90%+ cho việc tạo docstring và README

![OpenHands Star History](https://api.star-history.com/svg?repos=OpenHands/OpenHands&type=Date)

### Các công ty sử dụng OpenHands

AMD, Apple, Google, và Netflix đều đã triển khai OpenHands nội bộ cho các task bảo trì tự động. Các use case phổ biến nhất là nâng cấp dependency trên nhiều repository, quét và khắc phục lỗ hổng bảo mật, và tự động hóa review PR.

## Sử dụng nâng cao / Củng cố Production

### Checklist bảo mật

Chạy agent tự động thực thi code đòi hỏi thiết lập bảo mật cẩn thận:

**1. Cô lập mạng sandbox**

```yaml
environment:
  - SANDBOX_NETWORK_DISABLED=true
```

Điều này ngăn container sandbox thực hiện request outbound. Chỉ bật chọn lọc cho các task cần cài đặt gói.

**2. Bảo mật Docker Socket**

Mount Docker socket tương đương với quyền root. Giảm thiểu bằng:

```bash
docker run --security-opt no-new-privileges \
  --cap-drop ALL \
  --cap-add SYS_ADMIN \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/openhands/openhands:latest
```

**3. GitHub PAT chi tiết**

Không bao giờ dùng token phạm vi toàn tổ chức. Giới hạn PAT cho từng repository cụ thể:

```bash
# Tạo fine-grained PAT tại GitHub > Settings > Developer settings
# Chọn chỉ: Contents (read/write), Issues (read), Pull Requests (write)
```

**4. Quản lý secret**

Mount secret dưới dạng read-only volume thay vì biến môi trường:

```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
  - /opt/secrets:/secrets:ro
environment:
  - LLM_API_KEY_FILE=/secrets/anthropic_key
```

### Phân công Multi-Agent

Cho các tính năng lớn, bật chế độ multi-agent:

```bash
# Trong config.toml hoặc qua biến môi trường
[agent]
enable_multi_agent = true
max_subagents = 3
```

Agent cha phân rã "Xây dựng REST API với xác thực" thành:
- Sub-agent 1: Triển khai endpoint API
- Sub-agent 2: Viết middleware xác thực
- Sub-agent 3: Tạo model cơ sở dữ liệu

### Tinh chỉnh Memory Condenser

Cho các task chạy dài, điều chỉnh memory condenser:

```toml
[llm]
enable_condenser = true
condenser_max_history = 240  # Tóm tắt sau 240 sự kiện (mặc định: 240)
```

### Giám sát và Logging

Bật structured JSON logging cho khả năng quan sát:

```bash
openhands --headless --json -t "Task của bạn" 2>&1 | tee openhands.log
```

Parse log để lấy metrics:

```bash
# Đếm số lần gọi LLM
jq 'select(.type == "llm")' openhands.log | wc -l

# Tìm lỗi
jq 'select(.type == "error")' openhands.log

# Tính thờii gian task
jq 'select(.type == "finish") | .timestamp' openhands.log
```

### Mở rộng với Kubernetes

Cho triển khai team, cộng đồng duy trì Helm chart:

```bash
# Thêm Helm repository OpenHands
helm repo add openhands https://charts.openhands.dev
helm repo update

# Cài đặt với values
helm install openhands openhands/openhands \
  --set llm.apiKey=$LLM_API_KEY \
  --set llm.model=anthropic/claude-sonnet-4-20250514 \
  --set sandbox.networkDisabled=true \
  --set replicas=2
```

## So sánh với các giải pháp thay thế

| Tính năng | OpenHands | Claude Code | Aider | Codex CLI |
|---|---|---|---|---|
| **Giấy phép** | MIT (open source) | Độc quyền (đóng) | Apache-2.0 (open source) | Độc quyền (đóng) |
| **GitHub Stars** | 74,200 | N/A | 39,000 | N/A |
| **Giao diện** | Web UI + CLI | CLI only | CLI only | CLI only |
| **Sandbox** | Docker containers | Host filesystem | Host filesystem | Host filesystem |
| **Hỗ trợ model** | 100+ qua LiteLLM | Claude only | 100+ qua API | OpenAI only |
| **SWE-bench Verified** | ~72% (Claude) | ~78% (Claude) | ~62% (Claude) | ~55% (GPT) |
| **Tỷ lệ thành công lần đầu** | ~65% | ~78% | ~71% | ~60% |
| **Multi-Agent** | Có (native) | Có (sub-agents) | Không | Không |
| **Tự host** | Có (mặc định) | Không | Có | Không |
| **Thờii gian cài đặt** | 10-15 phút | 2 phút | 5-10 phút | 2 phút |
| **Chi phí** | Miễn phí + API | $17-200/tháng | Miễn phí + API | $20/tháng + API |
| **Tích hợp CI/CD** | Headless + JSON | Hạn chế | Scriptable | Hạn chế |
| **Tích hợp IDE** | VS Code (ACP) | Không | Không | VS Code (chính thức) |

### Khi nào chọn công cụ nào

- **OpenHands**: Bạn cần agent tự chủ tự host với thực thi sandbox và hỗ trợ multi-agent. Bạn muốn kiểm soát hoàn toàn hạ tầng và lựa chọn model.
- **Claude Code**: Bạn muốn tỷ lệ thành công lần đầu cao nhất, đã dùng Claude, và không cần tự host. Bạn thích CLI đơn giản không phức tạp về Docker.
- **Aider**: Bạn làm việc trên terminal, cần thao tác git-native với auto-commit, và muốn công cụ nhẹ không cần container.
- **Codex CLI**: Bạn tích hợp sâu trong hệ sinh thái OpenAI, cần hỗ trợ VS Code chính thức, và thích dịch vụ được quản lý.

## Hạn chế / Đánh giá trung thực

OpenHands không phải công cụ phù hợp cho mọi tình huống. Đây là những gì nó KHÔNG giỏi:

**1. Task frontend/UI cần phản hồi trực quan**: Agent không thể "nhìn thấy" output được render. Các task như "căn giữa nút này" hoặc "sửa gradient CSS" thường cần nhiều lần lặp vì agent thiếu xác minh trực quan.

**2. Prototyping nhanh**: Khởi động Docker sandbox thêm 10-30 giây latency mỗi task. Cho các chỉnh sửa nhanh một lần, Aider hoặc Cursor sẽ nhanh hơn.

**3. Máy nhỏ không chạy được Docker**: Nếu bạn không thể chạy Docker Desktop (laptop bị khóa bởi công ty, Chromebook ARM), OpenHands sẽ không hoạt động. Mount Docker socket là yêu cầu bắt buộc.

**4. Yêu cầu mơ hồ**: Các task như "cải thiện codebase" hoặc "refactor kiến trúc tốt hơn" đưa agent vào vòng lặp. Nó cần hướng dẫn cụ thể, có thể test được.

**5. Chi phí token cho task phức tạp**: Mỗi task tiêu tốn 30-50 lần gọi LLM. Với ~$0.01 mỗi lần gọi Claude Sonnet, đó là $0.30-0.50 mỗi task. Cho xử lý hàng loạt khối lượng cao, chi phí tích lũy nhanh.

**6. Đường cong học tập**: Hệ thống multi-agent, event stream, và tùy chọn cấu hình rất mạnh mẽ nhưng phức tạp hơn quy trình đăng ký 2 phút của Devin. Dự kiến 1-2 giờ thiết lập và thử nghiệm trước khi sử dụng hiệu quả.

## Câu hỏi thường gặp

### Cần phần cứng gì để chạy OpenHands?

Yêu cầu tối thiểu: CPU hiện đại, 4GB RAM, Docker Desktop. Cho model local cần GPU với ít nhất 24GB VRAM (RTX 4090 trở lên) để chạy Qwen3-Coder-32B ở tốc độ chấp nhận được. Model API cloud hoàn toàn không cần GPU.

### OpenHands có thể chạy hoàn toàn offline không?

Có, với model local qua Ollama, vLLM, hoặc LM Studio. Đặt base URL về endpoint local (vd: `http://localhost:11434/v1`) và dùng bất kỳ giá trị nào cho API key. Hiệu suất sẽ thua API frontier 20-30% trên task phức tạp, nhưng vẫn ổn cho sửa bug thường ngày và refactor.

### OpenHands so với Devin như thế nào?

Devin ($20-500/tháng) dễ thiết lập hơn (đăng ký 2 phút) nhưng khóa bạn vào model và hạ tầng của Cognition. OpenHands cần 10-15 phút thiết lập nhưng cho phép lựa chọn model hoàn toàn, tự host, và không bị khóa vendor. Điểm SWE-bench Verified: OpenHands ~72% so với Devin ~50%.

### Code của tôi có an toàn với OpenHands không?

Code chạy bên trong container sandbox Docker bị hủy sau mỗi task. Sandbox không có quyền truy cập mạng nếu `SANDBOX_NETWORK_DISABLED=true`. Tuy nhiên, mount Docker socket cho controller quyền truy cập host đáng kể, nên chạy OpenHands trên máy chuyên dụng hoặc VM, không phải laptop production.

### OpenHands có thể tích hợp với pipeline CI/CD hiện có không?

Có, qua chế độ headless. Cờ `--headless --json` tạo output JSONL có cấu trúc mà mọi hệ thống CI có thể parse. Một workflow GitHub Actions điển hình clone repo, chạy OpenHands trên issue được gắn nhãn, và tạo PR từ diff được tạo ra.

### Model nào hoạt động tốt nhất với OpenHands?

Claude Sonnet 4.6 mang lại cân bằng chi phí và chất lượng tốt nhất cho hầu hết task. Claude Opus 4.6 cho độ chính xác cao nhất nhưng chi phí token cao gấp 3-4 lần. GPT-5 hoạt động tốt cho team đã dùng OpenAI. Cho triển khai local, Qwen3-Coder-32B hoặc Devstral 24B là các lựa chọn open-weight tốt nhất.

### Làm thế nào debug khi OpenHands bị kẹt trong vòng lặp?

Kiểm tra event log trong UI để tìm các hành động thất bại lặp lại. Cách khắc phục phổ biến: (1) cung cấp hướng dẫn cụ thể hơn, (2) chuyển sang model mạnh hơn, (3) chia task thành các subtask nhỏ hơn, hoặc (4) tăng giới hạn `max_iterations` trong settings.

## Kết luận

OpenHands là agent kỹ sư phần mềm AI open source có khả năng nhất hiện có trong năm 2026. Với 74,000+ sao GitHub, điểm SWE-bench 72%, và kiến trúc sandbox Docker, đây là lựa chọn đúng cho các team cần khả năng lập trình tự chủ mà không bị khóa vendor.

Quá trình thiết lập mất 10-15 phút: cài qua uv hoặc Docker, cấu hình LLM provider, và bắt đầu giao task. Cho sử dụng production, bật cô lập mạng sandbox, dùng GitHub PAT chi tiết, và triển khai chế độ headless cho tích hợp CI/CD.

**Các bước tiếp theo:**
1. Clone repository: `git clone https://github.com/OpenHands/OpenHands.git`
2. Cài đặt: `uv tool install openhands --python 3.12`
3. Khởi chạy: `openhands serve` và kết nối tại `localhost:3000`
4. Tham gia cộng đồng Slack để được hỗ trợ và cập nhật tính năng



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài liệu tham khảo

- [OpenHands GitHub Repository](https://github.com/OpenHands/OpenHands) — Mã nguồn và bản phát hành
- [Tài liệu chính thức](https://docs.openhands.dev/) — Tài liệu cài đặt và API đầy đủ
- [Hướng dẫn cấu hình LLM OpenHands](https://docs.openhands.dev/openhands/usage/llms/llms) — Khuyến nghị model và thiết lập provider
- [Tài liệu chế độ Headless](https://docs.openhands.dev/openhands/usage/cli/headless) — Tham khảo CI/CD và scripting
- [Bảng xếp hạng SWE-bench](https://www.swebench.com/) — Kết quả benchmark chính thức
- [Tài liệu Provider LiteLLM](https://docs.litellm.ai/docs/providers) — Các model provider được hỗ trợ
- [Diễn đàn cộng đồng OpenHands](https://github.com/OpenHands/OpenHands/discussions) — Hỏi đáp và xử lý lỗi
- [Tài liệu Agent Control Plane](https://docs.openhands.dev/openhands/usage/key-features) — Tích hợp VS Code và thiết lập multi-agent

---

*Hướng dẫn này được duy trì độc lập và cập nhật định kỳ. Xác minh lần cuối: Tháng 5 năm 2026.*
