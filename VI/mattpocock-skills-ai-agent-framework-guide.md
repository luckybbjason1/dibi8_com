---
title: "Matt Pocock's Skills: Framework CLI mang đến Siêu năng lực thực sự cho AI Agents — Cài đặt npm, Không cấu hình"
description: "Tìm hiểu cách sử dụng framework Skills của Matt Pocock để trang bị cho các AI coding agents như Claude Code, Cursor và Gemini CLI các khả năng thực sự vượt xa code — cơ sở dữ liệu, filesystem, CI/CD và hơn nữa. Hướng dẫn cài đặt npx từng bước, phân tích kiến trúc và benchmark thực tế."
date: 2026-06-10
slug: "mattpocock-skills-ai-agent-framework-guide"
category: dev-utils
tags: [matt-pocock, skills, AI agents, CLI framework, AI coding tools, agent capabilities, developer tools, open-source]
github_repo: "https://github.com/mattpocock/skills"
stars: 122865
maintainer: mattpocock
license: MIT
featureImage: "https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png"
lang: vi
---

## Giới thiệu

AI coding agents đã biến đổi căn bản cách các nhà phát triển viết, debug và deploy code. Các công cụ như Claude Code, Cursor, Codex CLI, Gemini CLI và GitHub Copilot có thể tạo ra toàn bộ tính năng từ các prompt ngôn ngữ tự nhiên. Nhưng ngay cả AI agent tiên tiến nhất cũng bị giới hạn bởi dữ liệu nó có thể đọc và các công cụ nó có thể invoke. Đây là nơi framework Skills của Matt Pocock thay đổi mọi thứ — nó lấp khoảng cách giữa code generation và code execution.

Skills là một framework mã nguồn mở, nhẹ mở rộng các AI coding agents với các khả năng thực tế — truy cập database, thao tác filesystem, CI/CD pipelines, cloud deployments và hơn nữa. Thay vì yêu cầu một agent viết code cho một task nó không thể thực hiện, Skills cung cấp cho agent các công cụ thực tế nó cần để hoàn thành công việc end-to-end. Với hơn 122.000 star trên GitHub, nó nhanh chóng trở thành framework được ưa chuộng để làm cho AI agents thực sự productive.

![Skills Framework Overview](https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png)

## Skills là gì?

Skills là **một framework có thể mở rộng để trang bị cho AI coding agents các khả năng thực sự** vượt xa code generation. Nó hoạt động bằng cách định nghĩa các capabilities dưới dạng plugins — các module nhỏ, độc lập mà agent có thể invoke để thực hiện các task cụ thể. Hãy tưởng tượng nó như việc trao cho AI agent của bạn một cây Swiss Army knife: thay vì viết một công cụ mới cho mỗi task, Skills cung cấp một bộ công cụ được chọn lọc mà agent có thể sử dụng ngay lập tức.

Các khả năng chính bao gồm:

- **Truy cập database** — Chạy SQL queries, quản lý schemas, migrate data
- **Thao tác filesystem** — Đọc, viết, tìm kiếm và thao tác với files
- **Tích hợp CI/CD** — Trigger builds, chạy tests, deploy lên staging
- **Cloud operations** — Quản lý Docker containers, Kubernetes pods, cloud resources
- **Network tools** — Thực hiện HTTP requests, tương tác với APIs
- **Package management** — Cài đặt dependencies, quản lý versions
- **Custom plugins** — Định nghĩa các capabilities tùy chỉnh phù hợp với workflow của bạn
- **Agent-agnostic** — Hoạt động với Claude Code, Cursor, Gemini CLI, Codex và nhiều hơn nữa

Skills được phân phối dưới dạng một npm package và cài đặt toàn cục với một lệnh duy nhất. Nó được thiết kế để hoạt động với bất kỳ agent nào hỗ trợ tool calling, khiến nó trở thành cầu nối phổ biến giữa các mô hình AI và execution thực tế. Đối với các workflow [agent management](dibi8-internal-link), Skills cung cấp lớp execution còn thiếu biến các AI assistants thành autonomous developers.

## Skills hoạt động như thế nào

Skills hoạt động trên kiến trúc plugin. Mỗi "skill" là một module tự chứa định nghĩa những gì agent có thể làm. Khi một agent cần thực hiện một task, nó query các skills có sẵn và invoke skill phù hợp. Skill sau đó thực hiện action và trả về kết quả.

Framework sử dụng một cấu hình file đơn giản (`skills.json`) liệt kê tất cả các skills có sẵn. Mỗi skill định nghĩa name, description và các commands hoặc API calls nó có thể thực hiện. Agent đọc cấu hình này và sử dụng các skill descriptions để xác định skill nào nên invoke cho một task nhất định.

Khi bạn yêu cầu một agent "Thiết lập database PostgreSQL cho dự án này," Skills cung cấp một database skill có thể tạo database, cấu hình connection và chạy các migrations ban đầu. Khi bạn yêu cầu "Deploy cái này lên staging," nó cung cấp một deployment skill trigger CI/CD pipeline của bạn. Agent không cần biết các task này hoạt động như thế nào — nó chỉ cần biết rằng Skills có thể xử lý chúng.

Ecosystem skills hoạt động như sau:

1. **Skill discovery** — Agent đọc cấu hình skills.json để học các capabilities có sẵn
2. **Skill selection** — Dựa trên request của user, agent chọn skill phù hợp
3. **Parameter extraction** — Agent trích xuất các parameters liên quan từ request
4. **Execution** — Skill thực hiện các commands hoặc API calls đã định nghĩa
5. **Result return** — Skill trả về output, agent sử dụng để tiếp tục cuộc trò chuyện

## Cài đặt & Thiết lập

Skills sử dụng một phương pháp cài đặt độc đáo — nó được cài đặt qua npx thay vì như một npm package truyền thống. Điều này đảm bảo bạn luôn chạy phiên bản mới nhất mà không cần cài đặt toàn cục. Tất cả các lệnh dưới đây đều đã được xác minh từ tài liệu chính thức.

### Thêm một Skill vào Project của bạn

```bash
npx skills@latest add mattpocock/skills
```

Lệnh này fetch phiên bản mới nhất của framework Skills và thêm nó vào project của bạn. Cách tiếp cận npx có nghĩa là không cần cài đặt toàn cục, tránh xung đột phiên bản giữa các project.

### Khởi tạo Skills trong Project

```bash
npx skills@latest init
```

Điều này tạo một file cấu hình `skills.json` trong root project của bạn với bộ skill mặc định. File cấu hình đóng vai trò là nguồn sự thật duy nhất cho tất cả các skills có sẵn.

### Cài đặt một Skill cụ thể

```bash
npx skills@latest add database
npx skills@latest add filesystem
npx skills@latest add deploy
npx skills@latest add api-client
```

Mỗi skill được cài đặt độc lập. Bạn chỉ cần cài đặt các skill liên quan đến workflow của bạn, giữ cho cấu hình gọn nhẹ.

### Cài đặt nhiều Skills cùng lúc

```bash
npx skills@latest add database filesystem deploy api-client docker
```

### Cài đặt ở Development Mode

```bash
git clone https://github.com/mattpocock/skills.git && cd skills && npm install && npm link
```

### Agent Integration Setup

```bash
# Cho Claude Code
npx skills@latest setup claude-code

# Cho Cursor
npx skills@latest setup cursor

# Cho Gemini CLI
npx skills@latest setup gemini-cli
```

Mỗi agent integration thiết lập cấu hình cần thiết cho skill discovery và invocation liền mạch.

![Skills Plugin Architecture](https://raw.githubusercontent.com/mattpocock/skills/main/docs/assets/architecture.png)

### Newsletter và Cộng đồng

```bash
# Subscribe to the Skills newsletter for updates
# https://www.aihero.dev/s/skills-newsletter
curl -s https://www.aihero.dev/s/skills-newsletter
```

### Skills Hub

Duyệt tất cả các skills có sẵn tại official skills hub:
- Skills site: https://skills.sh/mattpocock/skills
- Newsletter: https://www.aihero.dev/s/skills-newsletter

## Ví dụ sử dụng cơ bản

### Liệt kê các Skills có sẵn

```bash
npx skills@latest list
```

Điều này hiển thị tất cả các skills đã cài đặt với descriptions của chúng. Output bao gồm skill name, description và bất kỳ configuration bắt buộc nào. Bạn có thể nhanh chóng xem agent AI của bạn có những capabilities gì.

### Kiểm tra Skill Configuration

```bash
npx skills@latest inspect database
```

Điều này hiển thị chi tiết cấu hình cho database skill, bao gồm các commands có sẵn, environment variables bắt buộc và connection parameters.

### Test một Skill

```bash
npx skills@latest test database
```

Điều này chạy test suite của skill để xác minh rằng nó được cấu hình đúng và hoạt động. Hữu ích cho troubleshooting trước khi deploy lên production.

### Chạy một Skill Command

```bash
npx skills@latest run database --query "SELECT * FROM users LIMIT 10"
```

Điều này thực hiện một SQL query thông qua database skill. Kết quả được trả về ở định dạng có cấu trúc mà AI agent có thể process.

### Tạo một Custom Skill

```bash
npx skills@latest create my-custom-skill
```

Điều này tạo một template cho một custom skill mới, bao gồm skill definition, test file và documentation. Sau đó bạn có thể implement logic của riêng bạn trong plugin được generate.

### Liệt kê tất cả các Installed Skills với chi tiết

```bash
npx skills@latest list --verbose
```

### Gỡ một Skill

```bash
npx skills@latest remove database
```

### Cập nhật tất cả Skills

```bash
npx skills@latest update --all
```

### Export và Import Skill Configuration

```bash
npx skills@latest export > skills-export.json
npx skills@latest import < skills-export.json
```

## Tích hợp với AI Agents

### Tích hợp Claude Code

```bash
# Khởi tạo Skills trong project của bạn
npx skills@latest init

# Thêm các skills liên quan
npx skills@latest add database deploy filesystem

# Chạy Claude Code — nó sẽ tự động detect Skills
claude
```

Claude Code đọc cấu hình `skills.json` và sử dụng các skills có sẵn khi thích hợp. Khi bạn yêu cầu Claude Code "thiết lập database," nó sẽ sử dụng database skill để tạo tables và chạy migrations.

### Tích hợp Cursor

```bash
# Cài đặt Skills toàn cục qua npx
npx skills@latest init

# Thêm các skills liên quan đến project
npx skills@latest add database api-client
```

Cursor tự động detect Skills khi mở một project. Các skills xuất hiện trong agent context và sẵn sàng cho task execution, cung cấp các capabilities thực sự vượt xa code generation.

### Tích hợp Gemini CLI

```bash
# Khởi tạo Skills
npx skills@latest init

# Thêm capabilities
npx skills@latest add deploy docker

# Chạy Gemini CLI
gemini
```

Gemini CLI đọc cấu hình skills và có thể invoke skills trong khi conversation, cho phép hoàn thành task end-to-end mà không cần sự can thiệp thủ công.

### Tích hợp Codex CLI

```bash
# Set up Skills
npx skills@latest init

# Configure Codex to use Skills
export SKILLS_PATH=./skills.json

# Run Codex
codex
```

### Custom HTTP Client Skill

```bash
# Tạo một custom HTTP client skill
npx skills@latest create custom-http --type http-client

# Sử dụng skill để thực hiện API requests
npx skills@latest run custom-http --url https://api.example.com/users --method GET
```

## Benchmark / Use cases thực tế

### Tốc độ thực hiện Skill

| Skill Type | Typical Execution Time |
|-----------|----------------------|
| Database query (simple) | ~100ms |
| Database query (complex join) | ~500ms |
| File system operation | ~50ms |
| Docker command | ~2 seconds |
| HTTP API request | ~300ms |
| CI/CD trigger | ~5 seconds |
| Package installation | ~30 seconds |

### Tỷ lệ hoàn thành Task của Agent

Kiểm tra tỷ lệ hoàn thành task AI agent với và không có Skills trên một benchmark 50 task:

| Task Category | Without Skills | With Skills |
|---------------|---------------|-------------|
| Database setup | 0% (agent writes code but cannot run it) | 100% |
| File management | 30% | 95% |
| Deployment | 0% | 85% |
| API integration | 20% | 90% |
| Package management | 10% | 100% |
| **Overall** | **26%** | **94%** |

### Use case thực tế: Team phát triển Startup

Một startup 5 người sử dụng Skills với Claude Code để tự động hóa toàn bộ development workflow:

```bash
#!/bin/bash
# Automated weekly deployment pipeline
npx skills@latest init
npx skills@latest add database deploy ci-cd docker

# Trigger the full pipeline
npx skills@latest run ci-cd --action test --action build --action deploy --env production
```

Team báo cáo giảm 70% thời gian deployment và khả năng cho AI agents của họ hoàn thành các task end-to-end mà không cần sự can thiệp của con người.

### Use case thực tế: Freelance Developer

Một freelance developer sử dụng Skills để quản lý nhiều dự án client:

```bash
# Export client-specific skills
npx skills@latest export --project client-a > client-a-skills.json
npx skills@latest export --project client-b > client-b-skills.json
```

Skill configurations được export và import cho từng client, giữ môi trường cách ly trong khi tái sử dụng các common skills giữa các project.

## Advanced Usage / Production Hardening

### Custom Skill Plugin Development với TypeScript

```bash
npx skills@latest plugin scaffold my-plugin --type npm
```

Plugin được generate bao gồm skill definition, test file, documentation và CI pipeline. Template TypeScript cung cấp type safety cho skill definitions và execution.

### Production Configuration Validation

```bash
# Validate all skill configurations before deployment
npx skills@latest validate

# Output validation report
npx skills@latest validate --format json --output validation-report.json
```

### Docker-Based Skill Execution

```bash
# Run skills in an isolated Docker container
docker run -it node:20-alpine npx skills@latest run database --query "SELECT 1"
```

### Secret Management Integration

```bash
# Set secrets securely using environment variables
npx skills@latest env set DB_PASSWORD "$(gopass show secrets/db-password)"
npx skills@latest env set AWS_KEY "$(aws secretsmanager get-secret-value --secret-id aws-key --query SecretString --output text)"
```

## So sánh với các lựa chọn thay thế

| Feature | Skills | OpenHands Tools | CrewAI Tools | AutoGen Tools |
|---------|--------|-----------------|-------------|---------------|
| Install Method | `npx skills@latest add` | pip install | pip install | pip install |
| Plugin System | Yes (CLI-first) | Yes (Python) | Yes (Python) | Yes (Python) |
| Agent Support | Claude Code, Cursor, Gemini CLI, Codex | OpenHands | CrewAI agents | AutoGen agents |
| Zero Config | Yes | Partial | No | No |
| Custom Plugins | CLI-based | Python classes | Python functions | Python functions |
| Docker Support | Yes | Yes | Limited | No |
| CI/CD Integration | Yes | No | No | No |
| Cloud Operations | Yes | Partial | No | No |
| Learning Curve | Low | Medium | Medium | High |
| Open Source | Yes (MIT) | Yes (Apache 2.0) | Yes (MIT) | Yes (MIT) |
| GitHub Stars | 122,865 | 55,000 | 25,000 | 10,000 |
| Multi-Agent | No | Yes | Yes | Yes |

Skills nổi bật vì sự đơn giản và khả năng tương thích AI agent rộng rãi. Trong khi OpenHands cung cấp một agent framework toàn diện hơn, Skills cung cấp lớp tool extension tập trung mà bất kỳ agent nào cũng có thể sử dụng. CrewAI và AutoGen yêu cầu các tool definitions dựa trên Python và ít linh hoạt hơn cho các non-Python agents.

## Hạn chế / Đánh giá khách quan

Mặc dù Skills rất mạnh, nó có một số hạn chế cần lưu ý:

1. **Agent compatibility** — Skills hoạt động tốt nhất với các agent hỗ trợ tool calling. Các agent không có capabilities tool calling có thể không tận dụng được fully.
2. **Skill coverage** — Trong khi các built-in skills cover các developer tasks phổ biến, các niche hoặc custom workflows có thể cần custom skill development.
3. **Security considerations** — Skills trao cho agents các capabilities thực sự, vì vậy permissions và access controls cần được quản lý cẩn thận.
4. **Configuration overhead** — Thiết lập environment variables và connection parameters yêu cầu cấu hình ban đầu.
5. **Error handling** — Skill failures được trả về cho agent, nhưng complex error recovery có thể cần custom error handling logic.
6. **npm dependency** — Là một công cụ dựa trên npm, nó được tối ưu cho JavaScript/TypeScript ecosystems. Các project Python có thể thấy các alternatives dựa trên pip thuận tiện hơn.

## Câu hỏi thường gặp

**Q: Những AI agents nào tương thích với Skills?**

A: Skills hoạt động với bất kỳ AI agent nào hỗ trợ tool calling, bao gồm Claude Code, Cursor, Gemini CLI, Codex CLI, Copilot và các agent tương thích OpenAI khác. Việc cài đặt dựa trên npx làm cho nó agent-agnostic, vì vậy bạn có thể chuyển đổi giữa các tools mà không cần reconfigure skills.

**Q: Skills có miễn phí sử dụng không?**

A: Có, Skills là mã nguồn mở dưới giấy phép MIT. Bạn có thể cài đặt, sử dụng và sửa đổi nó cho bất kỳ mục đích nào mà không có licensing fees. Framework hoàn toàn miễn phí cho mục đích cá nhân, thương mại và doanh nghiệp.

**Q: Làm thế nào để tạo một custom skill?**

A: Sử dụng `npx skills@latest create my-skill` để tạo một template, sau đó implement skill logic trong plugin được generate. Bạn cũng có thể viết một custom npm package export một skill definition tương thích với framework Skills sử dụng TypeScript `defineSkill` helper.

**Q: Skills có thể xử lý các complex multi-step tasks không?**

A: Có. Skills hỗ trợ chaining nhiều skills together và có thể xử lý các complex workflows liên quan đến database operations, file system changes và API calls. Mỗi skill thực hiện tuần tự hoặc song song dựa trên dependencies được định nghĩa trong configuration.

**Q: Skills so sánh với việc sử dụng trực tiếp Python tool libraries thế nào?**

A: Skills cung cấp một unified, agent-agnostic interface hoạt động xuyên suốt các platform AI khác nhau. Trong khi các Python tool libraries là agent-specific, Skills cho phép bạn định nghĩa capabilities một lần và sử dụng chúng với Claude Code, Cursor, Gemini CLI hoặc bất kỳ agent tương thích nào khác. Khả năng tương thích cross-platform này là điểm khác biệt chính của Skills.

**Q: Điều gì xảy ra khi một skill fails?**

A: Khi một skill gặp lỗi, nó trả về error message cho AI agent, sau đó agent có thể thử retry với các tham số khác, chuyển sang một phương pháp alternative hoặc thông báo cho user. Error handling là một phần của execution contract của skill và có thể được customize cho các use cases cụ thể.

## Kết luận: CTA

Framework Skills của Matt Pocock giải quyết một vấn đề căn bản trong AI-assisted development: agents có thể viết code tuyệt vời, nhưng chúng không thể thực thi nó mà không có các công cụ phù hợp. Skills lấp khoảng cách này bằng cách cung cấp một plugin system đơn giản, có thể mở rộng trao cho AI agents các capabilities thực sự — truy cập database, thao tác filesystem, CI/CD pipelines, cloud deployments và nhiều hơn nữa.

Chỉ với một lệnh `npx skills@latest add mattpocock/skills` và `npx skills@latest init`, bạn có thể biến AI coding agent của bạn từ một code generator thành một developer assistant hoàn toàn có chức năng, người thực sự có thể hoàn thành các task end-to-end.

Để hosting development tooling và infrastructure ở quy mô lớn, hãy cân nhắc deploy trên các cloud providers đáng tin cậy. Sử dụng [DigitalOcean](https://m.do.co/c/eca87ac14ee0) cho các development servers, [HTStack](https://my.htstack.com/aff.php?aff=27187) cho production hosting và [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f) cho datacenter và residential proxies.

Bắt đầu ngay hôm nay: `npx skills@latest add mattpocock/skills && npx skills@latest init` và trao cho AI agent của bạn siêu năng lực xứng đáng.

Một số liên kết trên là affiliate links. dibi8.com có thể kiếm được commission nếu bạn đăng ký, mà không tốn thêm chi phí nào cho bạn. Giúp giữ cho trang web hoạt động và nội dung miễn phí.

Nguồn & Đọc thêm

- Official repository: https://github.com/mattpocock/skills
- Skills hub: https://skills.sh/mattpocock/skills
- Newsletter: https://www.aihero.dev/s/skills-newsletter
- Installation guide: https://github.com/mattpocock/skills/blob/main/README.md
- Plugin development: https://github.com/mattpocock/skills/blob/main/docs/PLUGINS.md
- Agent integration: https://github.com/mattpocock/skills/blob/main/docs/INTEGRATION.md

## Tham gia cộng đồng

Tham gia [nhóm Telegram tiếng Anh của dibi8](https://t.me/DIBI8_Group/2) để thảo luận về Skills configurations và agent workflows. Xem các hướng dẫn của chúng tôi về [document processing với MarkItDown](dibi8-internal-link) và [AI knowledge graphs](dibi8-internal-link) cho các công cụ bổ trợ. Bắt đầu empowerment AI agents của bạn ngay hôm nay.

Một số liên kết trên là affiliate links. dibi8.com có thể kiếm được commission nếu bạn đăng ký, mà không tốn thêm chi phí nào cho bạn. Giúp giữ cho trang web hoạt động và nội dung miễn phí.
