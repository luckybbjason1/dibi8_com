---
title: 'repomix 2026: Đóng Gói Toàn Bộ Codebase Thành File Duy Nhất Cho LLM — Không Cần Cấu Hình'
description: 'repomix (tên cũ repopack) chuyển đổi repository Git thành một file text có cấu trúc duy nhất, tối ưu cho cửa sổ ngữ cảnh của Claude, ChatGPT, Gemini. 14k+ sao, không cần cấu hình, chạy ngay với npx.'
date: 2026-06-09 00:00:00+08:00
lastmod: 2026-06-09 00:00:00+08:00
tech_stack: ['Node.js', 'TypeScript', 'CLI']
application_domain: Dev Utils
source_version: 'v0.3'
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: 'https://github.com/yamadashy/repomix'
backup_url: ''
github_repo: 'yamadashy/repomix'
stars: 14200
maintainer: 'yamadashy'
last_maintained: '2026-06-01'
featureImage: '/images/articles/repomix-pack-repo-for-llm-context-2026/cover.jpg'
draft: false
categories: ['dev-utils']
tags: ['repomix', 'repopack', 'AI-coding', 'LLM-context', 'đóng-gói-codebase', 'Claude', 'ChatGPT', 'công-cụ-dev', 'mã-nguồn-mở']
aliases:
- /vi/posts/repomix-pack-repo-for-llm-context-2026/
faqs:
  - q: 'repomix là gì và tên cũ của nó là gì?'
    a: 'repomix (tên cũ repopack) là công cụ CLI mã nguồn mở đóng gói toàn bộ repository Git thành một file text có cấu trúc duy nhất, tối ưu cho cửa sổ ngữ cảnh LLM. Đổi tên từ "repopack" sang "repomix" vào năm 2025 để tránh nhầm lẫn với lệnh "repack" của npm. Phát triển bởi yamadashy, giấy phép MIT.'
  - q: 'repomix hỗ trợ những định dạng đầu ra nào?'
    a: 'repomix hỗ trợ ba định dạng đầu ra: văn bản thuần túy (mặc định, phù hợp ChatGPT và LLM thông thường), XML (tốt nhất cho Claude — Claude dùng XML bản địa), và Markdown (phù hợp Copilot và quy trình tài liệu). Chọn bằng --style plain|xml|markdown.'
  - q: 'repomix xử lý được codebase lớn đến mức nào?'
    a: 'repomix hoạt động tốt với khoảng 100,000–200,000 token (khoảng 5,000–10,000 file). Với repo lớn hơn, dùng --include để chỉ gửi subsystem liên quan. Flag --output-show-line-numbers giúp LLM đưa ra gợi ý chỉnh sửa chính xác theo số dòng.'
---

![repomix 2026: Đóng gói codebase cho ngữ cảnh LLM — dibi8.com](/images/articles/repomix-pack-repo-for-llm-context-2026/cover.jpg)

Khi nhờ Claude hoặc ChatGPT debug lỗi liên quan nhiều file, việc dán từng đoạn code một nhanh chóng mất ngữ cảnh. [repomix](https://github.com/yamadashy/repomix) giải quyết bằng cách biến toàn bộ repository thành một file có cấu trúc — sẵn sàng đưa vào cửa sổ ngữ cảnh của bất kỳ LLM nào trong vài giây.

## repomix Làm Gì

repomix quét repository, loại trừ file trong `.gitignore`, và xuất file text duy nhất chứa:

1. **Tóm tắt repository** — tổng số file, ước tính token, phân bố ngôn ngữ
2. **Cây thư mục** — cấu trúc thư mục đầy đủ
3. **Tất cả file nguồn** — mỗi file có tiêu đề đường dẫn và số dòng tùy chọn

## Bắt Đầu Không Cần Cấu Hình

```bash
# Chạy không cần cài đặt bằng npx
npx repomix

# Cài đặt toàn cục
npm install -g repomix

# Đóng gói thư mục cụ thể
repomix ./src

# Đóng gói repository GitHub từ xa (không cần git clone)
npx repomix --remote https://github.com/user/repo
```

## Định Dạng Đầu Ra

| Định dạng | Cờ | Phù hợp nhất |
|-----------|-----|-------------|
| Văn bản thuần | `--style plain` (mặc định) | ChatGPT, LLM thông thường |
| XML | `--style xml` | Claude (dùng XML bản địa) |
| Markdown | `--style markdown` | Copilot, quy trình tài liệu |

## Lọc Đầu Ra (Cho Dự Án Lớn)

```bash
# Chỉ bao gồm file TypeScript trong src/
repomix --include "src/**/*.ts"

# Loại trừ file test và build
repomix --ignore "**/*.test.ts,dist/**"

# Hiển thị số dòng
repomix --output-show-line-numbers
```

## Bảo Mật: `.repomixignore`

repomix tôn trọng `.gitignore` theo mặc định, nhưng file nhạy cảm chưa được gitignore (như `.env` local) có thể lọt vào output. Tạo file `.repomixignore` để loại trừ rõ ràng:

```
.env
.env.local
config/credentials.json
```

> **Cần máy chủ để xây dựng công cụ AI?** [Người dùng mới DigitalOcean nhận $200 tín dụng miễn phí](https://m.do.co/c/eca87ac14ee0) — đủ để chạy máy chủ phát triển hoặc triển khai codebase hỗ trợ AI.

**GitHub:** [yamadashy/repomix](https://github.com/yamadashy/repomix) · 14.2k ⭐ · MIT
