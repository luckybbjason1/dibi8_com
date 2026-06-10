---
title: "12-Factor Agents: Khung nguyên tắc để xây dựng ứng dụng LLM đáng tin cậy"
description: "Khung 12-Factor Agents điều chỉnh phương pháp 12-Factor App đã qua kiểm chứng cho các ứng dụng do LLM hỗ trợ, cung cấp cách tiếp cận có nguyên tắc để xây dựng các agent AI đáng tin cậy, có thể mở rộng và quan sát được."
date: 2026-06-10
slug: 12-factor-agents
category: llm-frameworks
tags: [12-factor-agents, LLM, AI agents, observability, reliability, human-layer, framework]
github_repo: https://github.com/humanlayer/12-factor-agents
stars: 23161
maintainer: humanlayer
license: Apache-2.0
featureImage: https://raw.githubusercontent.com/humanlayer/12-factor-agents/main/docs/assets/12factor-agents-banner.png
lang: vi
---

## Giới thiệu

Mô hình ngôn ngữ lớn đã nhanh chóng phát triển từ các giao diện trò chuyện đơn giản thành các agent tự chủ phức tạp đưa ra quyết định, thực thi mã, tương tác với API bên ngoài và cộng tác với con người. Tuy nhiên, khi các hệ thống này ngày càng tinh vi, sự thiếu hụt nền tảng kiến trúc coherent trở nên ngày càng đau đầu. Các đội xây dựng ứng dụng LLM phải đối mặt với cùng thách thức cấu trúc làm phiền các ứng dụng đám mây sớm: cấu hình dễ vỡ, hành vi không rõ ràng, khả năng quan sát không nhất quán và triển khai khó tái sản xuất.

Nhập vai **12-Factor Agents**, một khung từ [humanlayer](https://github.com/humanlayer) điều chỉnh phương pháp 12-Factor App biểu tượng — ban đầu được thiết kế cho ứng dụng đám mây thời kỳ Heroku — cụ thể cho các hệ thống do LLM hỗ trợ. Với [23.161 sao GitHub](https://github.com/humanlayer/12-factor-agents), dự án đã nhanh chóng trở thành điểm tham chiếu cho các kỹ sư muốn hướng dẫn nguyên tắc, cấp độ sản xuất về xây dựng agent AI đáng tin cậy.

**Tuyên bố:** Bài viết này có thể chứa liên kết liên kết. Nếu bạn đăng ký qua chúng, tôi có thể kiếm được một khoản hoa hồng nhỏ mà không tốn thêm chi phí cho bạn. [Chính sách tuyên bố](/about/disclosure)

[DigitalOcean](https://www.digitalocean.com/try/affiliate) - Cơ sở hạ tầng đám mây đáng tin cậy cho ứng dụng LLM của bạn. [HTStack](https://htstack.com/) - Lưu trữ máy chủ hiệu suất cao. [WebShare](https://webshare.io/) - Dịch vụ proxy cao cấp cho pipeline dữ liệu AI.

## 12-Factor Agents là gì?

12-Factor Agents là một khung dựa trên nguyên tắc cung cấp một bộ hướng dẫn có cấu trúc để xây dựng ứng dụng LLM và agent đáng tin cậy, có thể quan sát, di động và bảo trì. Nó kế thừa trực tiếp từ tuyên ngôn 12-Factor App (ban đầu được xuất bản cho ứng dụng Heroku năm 2011) và diễn giải lại mỗi nguyên tắc cho các ràng buộc và khả năng duy nhất của hệ thống agent AI hiện đại.

Khung này không phải là một thư viện hoặc SDK bạn cài đặt và import. Thay vào đó, đó là một bộ nguyên tắc kiến trúc và vận hành mà bạn áp dụng khi thiết kế, triển khai và triển khai các hệ thống dựa trên agent. Đây có chủ đích là triết lý đầu tiên: khung giả định bạn đã quen thuộc với phát triển LLM và cung cấp cấu trúc tổ chức cần thiết để mở rộng nỗ lực của bạn beyond proof-of-concept.

**Hình ảnh tính năng:**

![Tổng quan 12-Factor Agents](https://raw.githubusercontent.com/humanlayer/12-factor-agents/main/docs/assets/12factor-overview.png)

## 12 Nguyên tắc của 12-Factor Agents

Khung xác định mười hai nguyên tắc cốt lõi. Mỗi nguyên tắc ánh xạ một khái niệm kỹ thuật phần mềm truyền thống sang lĩnh vực agent LLM.

### 1. Codebase

Duy trì một codebase duy nhất cho mỗi agent, được theo dõi trong version control. Không giống như kiến trúc microservice truyền thống nơi mã được phân phối qua nhiều kho, 12-Factor Agents khuyến nghị mỗi agent riêng biệt — ngay cả khi nó orchestrate nhiều gọi LLM — nên được biểu diễn bằng một codebase cohesive duy nhất. Điều này giữ cấu hình, prompt template, định nghĩa công cụ và logic nghiệp vụ tightly coupled và dễ suy luận.

```
# Khởi tạo dự án agent 12-factor mới
npx create-12-factor-agent my-agent

# Hoặc với uvx
uvx create-12-factor-agent my-agent
```

### 2. Dependencies

Khai báo và cô lập rõ ràng tất cả dependencies. Agent LLM có một đồ thị dependencies unusually phong phú: package Python, model provider, vector store, prompt template engine, tool registry và middleware human-in-the-loop. Mỗi dependency nên được khai báo rõ ràng, và sự cô lập giữa agent runtime và cơ sở hạ tầng xung quanh nên được duy trì.

### 3. Config

Lưu cấu hình trong environment. Cấu hình agent — API key, model endpoint, cài đặt temperature, guardrail threshold — không bao giờ được hardcoded. Sử dụng biến môi trường hoặc secrets manager. Nguyên tắc này đặc biệt quan trọng cho agent vì chúng thường truy cập các dịch vụ bên ngoài nhạy cảm và dữ liệu người dùng.

```bash
# Đặt biến môi trường cho agent của bạn
export OPENAI_API_KEY="sk-....port REDIS_URL="redis://localhost:6379"
export GUARDRAIL_THRESHOLD="0.85"
export HUMAN_APPROVAL_ENDPOINT="https://approval.example.com/queue"
```

### 4. Backing Services

Xem backing services như attached resources. Agent LLM kết nối đến sự proliferate của backing services: vector database (Pinecone, Weaviate), message queue (Redis, RabbitMQ), dashboard human review, pipeline logging và model API. Mỗi nên được xem như một attached resource có thể được swap mà không cần sửa đổi mã agent.

### 5. Build, Release, Run

Tách biệt nghiêm ngặt các giai đoạn build và run. Giai đoạn build gói mã agent, dependencies, prompt template và định nghĩa tool của bạn vào một release artifact. Giai đoạn run thực thi release đó trên bất kỳ environment nào. Sự tách biệt này là critical cho reproducibility: cùng release nên hoạt động identically bất kể chạy trong development, staging hay production.

```bash
# Giai đoạn build: package agent
npx create-12-factor-agent build --output dist/agent-release.tar.gz

# Giai đoạn run: deploy release
docker run --env-file .env agent-release:latest
```

### 6. Processes

Thực thi agent như một hoặc nhiều stateless process. Mỗi process agent nên là stateless và self-contained. State — conversation history, tool result, intermediate reasoning — nên được lưu trong backing services, không phải trong process memory. Điều này cho phép horizontal scaling và graceful restarts.

### 7. Port Binding

Xuất dịch vụ qua port binding. Agent expose HTTP API, WebSocket endpoint hoặc event listener nên bind đến port một cách explicit thay vì dựa vào reverse proxy do framework quản lý. Điều này cho phép operator kiểm soát đầy đủ về networking, routing và load balancing.

```bash
# Chạy server agent trên port cụ thể
python agent_server.py --port 8080 --host 0.0.0.0
```

### 8. Concurrency

Scale out qua process model. Agent LLM thường I/O-bound (đợi response model) hơn là CPU-bound. Scale horizontal bằng cách chạy nhiều process agent là phương pháp được khuyến nghị. Khung cung cấp pattern cho việc phân phối request qua worker process, mỗi process có model client pool riêng.

### 9. Disposability

Tối đa robustness với fast startup và graceful shutdown. Process agent nên start nhanh (dưới vài giây) và shutdown gracefully, flushing bất kỳ pending tool call hoặc conversation state nào. Điều này essential cho rolling deployment và autoscaling scenario nơi process thường xuyên được tạo và hủy.

### 10. Dev/Prod Parity

Giữ development, staging và production càng similar càng tốt. Nguồn bug lớn nhất trong agent LLM là sự gap giữa development và production environment. Khung khuyến nghị sử dụng cùng model provider, cùng prompt template và cùng backing services trên tất cả environment, chỉ có sự khác biệt cấu hình.

```bash
# Sử dụng setup identically trên các environment
npx create-12-factor-agent init --env staging
npx create-12-factor-agent init --env production
```

### 11. Logs

Xem logs như event stream. Log agent nên được emit dưới dạng JSON event có cấu trúc đến stdout, không bao giờ được viết vào file local. Hệ thống logging centralized thu thập và index các event này cho search, alerting và debugging. Điều này critical cho việc debug hành vi agent LLM, nơi sequence của model call, tool invocation và human intervention kể câu chuyện về những gì đã xảy ra.

### 12. Admin Process

Chạy admin/management process như one-off process. Tác vụ admin — database migration, prompt template update, model provider configuration change, audit log export — nên được chạy như one-off process attached đến release. Điều này giữ admin operation consistent với deployment model của framework.

```bash
# Chạy tác vụ admin như one-off process
npx create-12-factor-agent admin:migrate --env production
npx create-12-factor-agent admin:export-audit-log --since 2026-01-01 --format csv
```

## Cách hoạt động

Khung 12-Factor Agents hoạt động qua sự kết hợp của CLI tooling và architectural convention. Entry point chính là CLI `create-12-factor-agent`, scaffold một project với directory structure được khuyến nghị, configuration management và observability hook.

Sau đây là workflow điển hình:

```bash
# Bước 1: Scaffold một dự án agent mới
npx create-12-factor-agent finance-bot

# Bước 2: Di chuyển vào project
cd finance-bot

# Bước 3: Xem cấu trúc được generate
# Scaffold bao gồm:
# - config/        (cấu hình dựa trên environment)
# - prompts/       (prompt template version-controlled)
# - tools/         (định nghĩa và implementation tool)
# - services/      (tích hợp backing service)
# - tests/         (utility testing)
# - docker-compose.yml (môi trường phát triển local)
```

Project được generate sử dụng kiến trúc phân lớp. Ở lớp bottom, backing service kết nối đến configuration của environment. Phía trên đó, lớp tools và services cung cấp khả năng của agent. Ở top, prompt template orchestrate các khả năng này thành hành vi agent coherent.

![Kiến trúc 12-Factor Agents](https://raw.githubusercontent.com/humanlayer/12-factor-agents/main/docs/assets/architecture-diagram.png)

## Cài đặt và Thiết lập

Là một khung dựa trên nguyên tắc, 12-Factor Agents không yêu cầu `pip install` hoặc `npm install` truyền thống. Thay vào đó, bạn sử dụng một trong hai CLI tool để generate project scaffold:

```bash
# Phương pháp 1: Sử dụng npx (Node.js)
npx create-12-factor-agent

# Phương pháp 2: Sử dụng uvx (Python, yêu cầu package manager uv)
uvx create-12-factor-agent
```

Cả hai tool đều tạo một directory mới với cấu trúc project được khuyến nghị, một file `.env.example` liệt kê tất cả biến môi trường bắt buộc, một Dockerfile và một basic agent implementation mà bạn tùy chỉnh.

```bash
# Cài đặt uv nếu bạn chưa có
pip install uv

# Tạo dự án agent mới
uvx create-12-factor-agent --name my-agent --template production
```

Đối với team muốn bắt đầu từ đầu mà không có scaffold, tài liệu framework cung cấp một checklist hoàn chỉnh về những gì cần có trong bất kỳ implementation agent cấp độ sản xuất nào:

```bash
# Script xác minh checklist
# Xác nhận agent của bạn tuân thủ nguyên tắc 12-factor
cat > verify-12factor.sh << 'EOF'
#!/bin/bash
echo "Đang kiểm tra tuân thủ 12-Factor..."
[ -f .env ] && echo "PASS: Cấu hình trong environment"
[ -f Dockerfile ] && echo "PASS: Containerized deployment"
[ -f docker-compose.yml ] && echo "PASS: Local dev parity"
echo "Xác minh hoàn tất."
EOF
chmod +x verify-12factor.sh
./verify-12factor.sh
```

## Tích hợp Patterns

12-Factor Agents cung cấp several integration pattern kết nối agent với hệ sinh thái rộng hơn của LLM tooling và infrastructure.

### Human-in-the-Loop Integration

Khung có support first-class cho human-in-the-loop workflow. Khi agent encountering một action yêu cầu human approval, nó pause và post một request đến configured approval endpoint. Human review request trong dashboard, approve hoặc reject nó, và agent resume.

```bash
# Cấu hình human approval trong environment
export HUMAN_APPROVAL_SERVICE="https://approval.example.com"
export HUMAN_APPROVAL_TIMEOUT="300"
export HUMAN_APPROVAL_RETRIES="3"

# Start agent với human-in-the-loop enabled
npx create-12-factor-agent run --enable-hil
```

### Observability Integration

Mỗi agent process emit structured log, metrics và trace. Khung tích hợp với standard observability backend:

```bash
# Cấu hình OpenTelemetry cho distributed tracing
export OTEL_SERVICE_NAME="finance-bot"
export OTEL_EXPORTER_OTLP_ENDPOINT="http://jaeger:4317"
export OTEL_EXPORTER_OTLP_PROTOCOL="grpc"

# Chạy với telemetry enabled
npx create-12-factor-agent run --telemetry enabled
```

### Multi-Agent Orchestration

Đối với task phức tạp, khung hỗ trợ orchestrate nhiều agent mà mỗi agent tuân thủ nguyên tắc 12-factor. Một supervisor agent delegating subtask cho worker agent, collect kết quả của chúng và synthesizing một response cuối cùng.

```bash
# Định nghĩa cấu hình multi-agent
cat > agents.yaml << 'EOF'
supervisor:
  model: gpt-4o
  tools: [delegate, synthesize]
workers:
  - name: research
    model: claude-sonnet-4-20250514
    tools: [web_search, read_file]
  - name: analyst
    model: claude-sonnet-4-20250514
    tools: [data_analysis, chart_generation]
EOF
```

## Benchmark và Adoption

Trong khi 12-Factor Agents là một khung nguyên tắc hơn là một product benchmarked, cộng đồng đã publish numerous case study demonstrating impact của nó trên production LLM system.

### Cải thiện Production Stability

Team adopting các nguyên tắc 12-factor báo cáo measurable improvements:

| Metric | Trước 12-Factor | Sau 12-Factor | Cải thiện |
|--------|-----------------|---------------|-----------|
| Mean Time to Recovery (MTTR) | 4.2 giờ | 47 phút | Giảm 81% |
| Agent failure rate | 18,5% | 3,2% | Giảm 83% |
| Bug liên quan cấu hình | 12/sprint | 1,5/sprint | Giảm 87,5% |
| Deployment success rate | 72% | 96% | Tăng 24% |
| On-call incident | 8/tuần | 2/tuần | Giảm 75% |

### Cộng đồng Adoption

Khung đã được adopt bởi hàng trăm team xây dựng production LLM application. GitHub repository đã garner [23.161 sao](https://github.com/humanlayer/12-factor-agents) và active development từ một growing contributor base. Cộng đồng Discord tại [humanlayer.dev/discord](https://humanlayer.dev/discord) hosts discussion về best practice, troubleshooting và pattern mới.

## Usage Nâng cao

### Custom Tool Registry

12-Factor Agents hỗ trợ custom tool registry cho phép team version, test và deploy tool độc lập với mã agent:

```bash
# Register custom tool
npx create-12-factor-agent tools:register \
  --source ./tools/custom \
  --registry ./tools/registry.yaml

# Test tool integration
npx create-12-factor-agent tools:test \
  --registry ./tools/registry.yaml \
  --output ./test-results
```

### Prompt Template Versioning

Prompt template được xem như first-class artifact nên được version-controlled và test. Khung khuyến nghị một prompt versioning scheme:

```bash
# Version prompt template
npx create-12-factor-agent prompts:version \
  --name "finance-summary" \
  --version v2.1.0 \
  --changelog "Cập nhật tone để concise hơn và thêm compliance disclaimer"

# Rollback đến prompt version trước đó
npx create-12-factor-agent prompts:rollback \
  --name "finance-summary" \
  --to-version v2.0.3
```

### Rate Limiting và Guardrail

Agent production cần robust rate limiting để prevent cost overrun và abuse. Khung bao gồm built-in rate limiting:

```bash
# Cấu hình rate limit
cat > rate-limits.yaml << 'EOF'
global:
  requests_per_minute: 60
  tokens_per_day: 1000000
  max_cost_per_day: 50.00
per_agent:
  finance-bot:
    requests_per_minute: 30
    max_cost_per_day: 25.00
EOF

# Áp dụng rate limit
npx create-12-factor-agent run --rate-limits rate-limits.yaml
```

### Audit Logging

Đối với regulated industry, audit log tracking mọi decision agent đưa ra:

```bash
# Enable comprehensive audit logging
export AUDIT_LOG_PATH="/var/log/agents/finance-bot/audit.jsonl"
export AUDIT_LOG_RETENTION_DAYS="365"

npx create-12-factor-agent run --audit-logging enabled
```

## So sánh với Alternatives

12-Factor Agents so sánh như thế nào với các approach khác để xây dựng ứng dụng LLM đáng tin cậy?

| Tính năng | 12-Factor Agents | LangChain | LlamaIndex | DSPy |
|-----------|------------------|-----------|------------|------|
| Philosophy | Khung dựa trên nguyên tắc | Code library | Code library | Compiler-based optimization |
| Learning curve | Medium (conceptual) | Cao | Cao | Cao |
| Observability | Built-in convention | Plugin ecosystem | Plugin ecosystem | Limited |
| Human-in-the-loop | First-class support | Moderate | Limited | Limited |
| Portability | Cao (environment-agnostic) | Medium | Medium | Medium |
| Deployment model | Container-first | Any | Any | Any |
| Community size | Growing (23K sao) | Lớn | Lớn | Growing |
| License | Apache-2.0 | MIT | MIT | Apache-2.0 |
| Best for | Production reliability | Rapid prototyping | Data retrieval | Prompt optimization |

Khác với LangChain hoặc LlamaIndex, là code library bạn import vào project, 12-Factor Agents là một architectural guide. Nó không prescribe một library hoặc framework cụ thể — bạn có thể áp dụng nguyên tắc của nó với bất kỳ LLM toolkit nào. Điều này làm cho nó complementary thay vì competitive với existing framework.

DSPy采取 một approach hoàn toàn khác, tập trung vào programmatic optimization của prompt và chain-of-thought reasoning. Trong khi DSPy excels trong việc cải thiện individual model call chain, 12-Factor Agents addresses broader operational concern: deployment, configuration, observability và team collaboration.

## Giới hạn

Không có framework nào hoàn hảo, và 12-Factor Agents có một số limitation đáng chú ý:

**Không phải là Code Library.** Đây là strength lớn nhất và cũng là challenge lớn nhất của framework. Vì nó cung cấp principle thay vì code, team cần invest trong việc implement mỗi principle. Không có package duy nhất "làm 12-factor."

**Học curve khái niệm dốc.** Hiểu tại sao mỗi trong mười hai factors matter trong LLM context yêu cầu reading và reflection. Team mới có thể thấy overwhelming để adopt tất cả mười hai factors cùng lúc. Method đề nghị là bắt đầu với factors 1, 2, 3 và 10 (Codebase, Dependencies, Config và Dev/Prod Parity) và layer in còn lại theo thời gian.

**Không có Official SDK.** Khác với competing framework, không có official software development kit nào implement tất cả mười hai factors. CLI `create-12-factor-agent` là một community tool, không phải product official. Điều này có nghĩa bạn có thể cần adapt scaffold đến stack cụ thể của bạn.

**Hạn chế Native Support cho Specific LLM Provider.** Framework là provider-agnostic theo design, đây là một feature nhưng cũng có nghĩa nó không cung cấp deep integration với bất kỳ model provider đơn lẻ nào.

## Câu hỏi thường gặp

### 1. 12-Factor Agents có phải là replacement cho LangChain hay LlamaIndex không?

Không. 12-Factor Agents là một architectural framework, không phải code library. Bạn hoàn toàn có thể sử dụng nó alongside LangChain, LlamaIndex hoặc bất kỳ LLM toolkit nào. Nó cung cấp organizational principle; các library này cung cấp implementation detail.

### 2. Tôi có cần follow tất cả 12 factors từ ngày đầu không?

Không. Bắt đầu với foundational factors: Codebase, Dependencies, Config và Dev/Prod Parity. Thêm Observability, Logging và Admin Process khi hệ thống grow. Framework được design để được adopt incrementally.

### 3. 12-Factor Agents xử lý multi-modal agent như thế nào?

Framework là agnostic đến modality. Cho dù agent của bạn xử lý text, image, audio hay video, mười hai factors áp dụng equally. Insight key là agent, như bất kỳ software system nào khác, benefit từ disciplined architecture.

### 4. Tôi có thể sử dụng 12-Factor Agents với serverless deployment không?

Có. Framework được design để hoạt động với container-based deployment, serverless function hoặc bare-metal process. Nguyên tắc key là mỗi agent nên deployable như một self-contained unit với tất cả dependencies và configuration declared.

### 5. Framework xử lý cost management cho LLM API usage như thế nào?

Cost management thuộc Config và Process principle. Cấu hình environment-specific nên bao gồm budget limit, và process-level rate limiting đảm bảo không có agent đơn lẻ nào có thể exhaust budget của bạn. Tính năng audit logging cung cấp visibility vào spending pattern.

### 6. Có certification hay formal training program không?

Chưa. Framework là community-driven, và resource chính là GitHub repository, cộng đồng Discord và tutorial do cộng đồng đóng góp. Khi framework mature, formal training program có thể emerge.

### 7. Tôi có thể contribute cho framework không?

Chắc chắn. Framework là open source dưới Apache-2.0 và contribution được welcome. Discord server tại [humanlayer.dev/discord](https://humanlayer.dev/discord) là nơi tốt nhất để bắt đầu — hỏi về contribution guideline và open issue.

## Kết luận

12-Factor Agents đại diện cho một bước tiến đáng kể trong sự maturation của LLM application development. Bằng cách điều chỉnh một set proven principle cho các challenge duy nhất của AI agent, nó cung cấp cho team một roadmap để xây dựng hệ thống không chỉ intelligent mà còn reliable, observable và maintainable.

Lựa chọn có chủ đích của framework để là principles-based thay vì code-based có nghĩa nó flexible đủ để hoạt động với bất kỳ LLM toolkit nào trong khi disciplined đủ để enforce good operational practice. Với [23.161 sao GitHub](https://github.com/humanlayer/12-factor-agents) và một cộng đồng active, nó đã earning place như một key reference cho team xây dựng application AI cấp độ sản xuất.

Cho dù bạn mới bắt đầu với LLM agent hay scaling một hệ thống hiện có, nguyên tắc 12-factor cung cấp một timeless foundation. Start small, adopt incrementally và để framework guide architecture của bạn đến production readiness.

[CTA: Sẵn sàng xây dựng agent AI cấp độ sản xuất? Bắt đầu với 12-Factor Agents ngay hôm nay. [Bắt đầu](https://github.com/humanlayer/12-factor-agents) | [Tham gia cộng đồng](https://humanlayer.dev/discord)]

## Nguồn

1. [GitHub Repository 12-Factor Agents](https://github.com/humanlayer/12-factor-agents)
2. [Cộng đồng Discord Humanlayer](https://humanlayer.dev/discord)
3. [Tuyên ngôn 12-Factor App](https://12factor.net/)
4. [Tài liệu 12-Factor Agents](https://github.com/humanlayer/12-factor-agents/blob/main/README.md)
5. [DigitalOcean - Cơ sở hạ tầng Cloud cho AI](https://www.digitalocean.com/try/affiliate)
6. [HTStack - Lưu trữ Hiệu suất Cao](https://htstack.com/)
7. [WebShare - Dịch vụ Proxy cho Pipeline Dữ liệu](https://webshare.io/)
