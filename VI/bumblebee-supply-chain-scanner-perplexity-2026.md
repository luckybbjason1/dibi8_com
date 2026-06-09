---
title: 'Bumblebee 2026: Perplexity AI Mở Nguồn Bộ Quét Chuỗi Cung Ứng Nội Bộ — Hỗ Trợ MCP và Extension Editor'
description: 'Bumblebee là bộ quét chuỗi cung ứng chỉ đọc, mã nguồn mở của Perplexity AI, kiểm tra npm, PyPI, Go module, cấu hình MCP, extension editor và extension trình duyệt tìm các gói đã bị xâm phạm — không thực thi bất kỳ dòng code nào.'
date: 2026-06-09 00:00:00+08:00
lastmod: 2026-06-09 00:00:00+08:00
tech_stack: ['Go', 'Security', 'CLI']
application_domain: Dev Utils
source_version: '0.1.1'
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: 'https://github.com/perplexityai/bumblebee'
backup_url: ''
github_repo: 'perplexityai/bumblebee'
stars: 1500
maintainer: 'perplexityai'
last_maintained: '2026-05-22'
featureImage: '/images/articles/bumblebee-supply-chain-scanner-perplexity-2026/cover.jpg'
draft: false
categories: ['dev-utils']
tags: ['bumblebee', 'supply-chain', 'security', 'MCP', 'Go', 'npm', 'PyPI', 'perplexity-ai']
aliases:
- /vi/posts/bumblebee-supply-chain-scanner-perplexity-2026/
faqs:
  - q: 'Bumblebee là gì và quét những gì?'
    a: 'Bumblebee là bộ quét endpoint nhà phát triển chỉ đọc, mã nguồn mở của Perplexity AI. Nó quét metadata trên đĩa của npm, pnpm, Yarn, PyPI, Go module, RubyGems, cấu hình MCP, extension editor (VS Code, Cursor, Windsurf, Zed) và extension trình duyệt. Không bao giờ thực thi install script hay gọi package manager.'
  - q: 'Tại sao nhà phát triển AI cần quét cấu hình MCP?'
    a: 'MCP (Model Context Protocol) server chạy với quyền cao trên máy nhà phát triển. Package MCP bị xâm phạm có thể rò rỉ dữ liệu hoặc chạy code tùy ý. Bumblebee là công cụ công khai đầu tiên quét các file cấu hình MCP (claude_desktop_config.json, mcp_settings.json, v.v.) với catalog thông tin mối đe dọa.'
  - q: 'Ba profile quét khác nhau như thế nào?'
    a: 'baseline quét global package roots, toolchain, editor extension và cấu hình MCP — phù hợp kiểm tra hàng ngày. project bao gồm thêm thư mục phát triển (~/code, ~/src). deep quét toàn bộ root chỉ định (thường là home directory), dùng khi xảy ra sự cố bảo mật.'
  - q: 'Cách cài đặt Bumblebee?'
    a: 'Chạy go install github.com/perplexityai/bumblebee/cmd/bumblebee@v0.1.1. Kiểm tra hàng ngày: bumblebee scan --profile baseline > inventory.ndjson. Quét sự cố: bumblebee scan --profile deep --root "$HOME" --exposure-catalog ./catalog.json --findings-only --max-duration 10m.'
---

![Bumblebee 2026: Perplexity AI Supply-Chain Scanner — dibi8.com](/images/articles/bumblebee-supply-chain-scanner-perplexity-2026/cover.jpg)

Ngày 22 tháng 5 năm 2026, Perplexity AI công bố mã nguồn mở [Bumblebee](https://github.com/perplexityai/bumblebee) — công cụ nội bộ mà nhóm bảo mật của họ dùng để kiểm tra máy tính nhà phát triển tìm rủi ro chuỗi cung ứng. Chưa đầy một tuần, nó đã có hơn 1.500 GitHub star và 112 fork. Câu hỏi công cụ này trả lời: **khi có cảnh báo về package bị xâm phạm, máy nào trong đội của bạn đang có nó?**

## Tại sao tấn công chuỗi cung ứng nhắm vào nhà phát triển trước?

Các sự kiện chuỗi cung ứng 2024–2026 (xz, polyfill.io, nhiều package npm độc hại nhắm vào AI tooling) đều có chung một mô hình: đầu tiên hạ cánh trên máy nhà phát triển, vài tháng sau mới gây thiệt hại trên production. Laptop nhà phát triển là mục tiêu giá trị cao vì chứa API key, SSH credential, source code, và ngày càng quan trọng hơn — cấu hình MCP server.

Các công cụ SCA truyền thống (Snyk, Dependabot) kiểm tra dependency trong code. Chúng bỏ sót: CLI cài global, editor extension, browser extension, **file cấu hình MCP**. Bumblebee được tạo ra để lấp đầy những khoảng trống đó.

## Đảm bảo chỉ đọc

Ràng buộc cốt lõi của công cụ: **không bao giờ thực thi bất cứ thứ gì**. Không `npm ls`, không `pip check`, không `go list`. Bumblebee hoàn toàn bỏ qua rủi ro này bằng cách chỉ đọc metadata trên đĩa: `package.json`, `go.sum`, `requirements.txt`, extension manifest, và cấu hình MCP JSON.

## Ba Profile Quét

```bash
# Kiểm tra toàn cục hàng ngày
bumblebee scan --profile baseline > inventory.ndjson

# Quét theo phạm vi dự án
bumblebee scan --profile project --project-root ~/code

# Xử lý sự cố - quét toàn bộ home directory
bumblebee scan --profile deep \
  --root "$HOME" \
  --exposure-catalog ./catalog.json \
  --findings-only \
  --max-duration 10m
```

## Hỗ Trợ Cấu Hình MCP

Đây là tính năng quan trọng nhất với nhà phát triển AI năm 2026. Bumblebee quét các đường dẫn:

| File | Công cụ |
|------|---------|
| `~/.claude.json` | Claude CLI |
| `claude_desktop_config.json` | Claude Desktop |
| `mcp_settings.json` | Cline / Roo Code |
| `.mcp.json` / `mcp.json` | MCP chung |
| `~/.gemini/settings.json` | Gemini CLI |

## Thiết Kế Zero Dependency

Viết bằng Go 1.25, **không nhập gì ngoài thư viện chuẩn**. Kết quả là một binary tĩnh duy nhất.

```bash
go install github.com/perplexityai/bumblebee/cmd/bumblebee@v0.1.1
```

> **Triển khai hạ tầng AI an toàn:** Nếu bạn chạy MCP server hoặc workload AI trên VPS, hardening hệ điều hành máy chủ là tuyến phòng thủ đầu tiên. [DigitalOcean Droplet $6/tháng](https://m.do.co/c/eca87ac14ee0) cho phép bạn cấu hình firewall, user isolation và audit log riêng. Người dùng mới nhận **$200 credit miễn phí**.

**GitHub:** [perplexityai/bumblebee](https://github.com/perplexityai/bumblebee) · v0.1.1 · Apache-2.0
