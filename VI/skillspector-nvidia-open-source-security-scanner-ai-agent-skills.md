---
title: 'SkillSpector: Công cụ quét bảo mật mã nguồn mở cho kỹ năng AI Agent của NVIDIA'
description: 'Một công cụ quét bảo mật dành riêng cho kỹ năng AI Agent, phát hiện lỗ hổng, mẫu độc hại và rủi ro bảo mật trước khi cài đặt kỹ năng. Đạt 10K sao từ NVIDIA. Bảo vệ Claude Code, Codex CLI và các khung tác nhân khác.'
date: 2026-06-25
lastmod: 2026-06-25
draft: false
category: dev-utils
tags: ['security', 'ai-agents', 'scanner', 'vulnerability-detection', 'claude-code', 'codex', 'mcp', 'agent-skills', 'nvidia']
slug: skillspector-nvidia-open-source-security-scanner-ai-agent-skills
featureImage: /images/articles/skillspector-nvidias-open-source-security-scanner-for-ai-agent-skills.png
lang: vi
github_repo: https://github.com/NVIDIA/SkillSpector
license: Apache-2.0
---



# SkillSpector: Công cụ quét bảo mật mã nguồn mở cho kỹ năng AI Agent của NVIDIA

**SkillSpector** là một công cụ quét bảo mật được thiết kế đặc biệt cho kỹ năng AI Agent — các plugin mô-đun và tiện ích mở rộng cung cấp năng lượng cho các khung như Claude Code, GitHub Copilot, Codex CLI và Gemini CLI. Được NVIDIA phát triển với **10.273 sao GitHub**, công cụ này giải quyết những lo ngại ngày càng tăng về bảo mật khi cài đặt các kỹ năng agent chưa được kiểm duyệt trong môi trường sản xuất.

Bài viết này bao gồm hướng dẫn cài đặt, khả năng quét, phát hiện lỗ hổng, tích hợp với các khung agent và thực tiễn tốt nhất để bảo vệ hệ sinh thái AI Agent.

## TL;DR

Khi kỹ năng AI Agent ngày càng phổ biến, các rủi ro bảo mật khi cài đặt các kỹ năng chưa được kiểm duyệt cũng gia tăng. SkillSpector cung cấp quét tự động cho hơn 800 kỹ năng an ninh mạng, phát hiện lỗ hổng, mẫu độc hại và rủi ro bảo mật trước khi chúng tiếp cận hệ thống của bạn. Công cụ hỗ trợ tất cả các khung agent chính và cung cấp hướng dẫn khắc phục có thể hành động được.

## SkillSpector là gì?

SkillSpector ra đời từ một quan sát quan trọng: khi kỹ năng AI Agent lan rộng trong quy trình làm việc của nhà phát triển, diện tích bề mặt bảo mật mở rộng đáng kể. Không giống như các gói phần mềm truyền thống phải trải qua đánh giá mã nghiêm ngặt, nhiều kỹ năng agent chỉ là các tệp văn bản đơn giản (SKILL.md) hướng dẫn LLM thực hiện các thao tác tùy ý — bao gồm thực thi lệnh shell, truy cập API và sửa đổi tệp.

Công cụ cung cấp:

- **Quét lỗ hổng tự động** cho các tệp kỹ năng AI Agent
- **Phát hiện hành vi độc hại dựa trên mẫu** bao gồm tiêm lệnh, đánh cắp dữ liệu và leo thang đặc quyền
- **Phân tích theo khung cụ thể** cho Claude Code, GitHub Copilot, Codex CLI và nhiều hơn nữa
- **Hướng dẫn khắc phục** với các sửa đổi cụ thể cho từng lỗ hổng được phát hiện
- **Tích hợp CI/CD** cho quét trước khi cài đặt trong các quy trình tự động

## Hướng dẫn cài đặt

### Yêu cầu tiên quyết

- **Python**: 3.12+ (yêu cầu cho tính năng quét bất đồng bộ)
- **Hệ điều hành**: Linux, macOS hoặc Windows WSL2
- **Dung lượng đĩa**: 500MB cho bộ quét + cơ sở dữ liệu kỹ năng
- **Mạng**: Cần thiết để tải cơ sở dữ liệu kỹ năng và bản cập nhật

### Tùy chọn 1: Cài đặt qua Pip

```bash
# Cài đặt SkillSpector từ PyPI
pip install skillspector

# Xác nhận cài đặt
skillspector --version

# Tải cơ sở dữ liệu kỹ năng mới nhất
skillspector update-db
```

### Tùy chọn 2: Từ mã nguồn

```bash
# Sao chép kho lưu trữ
git clone https://github.com/NVIDIA/SkillSpector.git
cd SkillSpector

# Tạo môi trường ảo
python -m venv .venv
source .venv/bin/activate

# Cài đặt ở chế độ phát triển
pip install -e .

# Khởi tạo bộ quét
skillspector init --download-database
```

### Tùy chọn 3: Triển khai Docker

```bash
# Kéo hình ảnh chính thức
docker pull nvcr.io/nvidia/skillspector:latest

# Chạy quét
docker run --rm \
  -v ${PWD}/skills:/app/skills \
  nvcr.io/nvidia/skillspector:latest \
  scan /app/skills

# Lên lịch quét thường xuyên
docker run -d \
  --name skillspector \
  -v ${PWD}/skills:/app/skills \
  -v ${PWD}/reports:/app/reports \
  nvcr.io/nvidia/skillspector:latest \
  daemon --interval 3600
```

## Khả năng quét

### Danh mục phát hiện lỗ hổng

SkillSpector phát hiện lỗ hổng trên nhiều danh mục:

| Danh mục | Mô tả | Mức độ nghiêm trọng |
|
Tham gia cộng đồng: [Telegram](https://t.me/DIBI8_Group) · [HuggingFace](https://huggingface.co/collections/nvidia/cosmos3)

Liên kết nội bộ: [nvidia-cosmos-world-models-platform-2026](https://dibi8.com/vi/resources/ai-tools/nvidia-cosmos-world-models-platform-2026) · [bytedance-ui-tars-desktop-ai-agent-guide](https://dibi8.com/vi/resources/ai-tools/bytedance-ui-tars-desktop-ai-agent-guide)

**Tiết lộ**: Bài viết này đề cập đến các công cụ có thể có quan hệ liên kết. Chúng tôi không chấp nhận thanh toán cho đánh giá. Tất cả ý kiến đều là của riêng chúng tôi.
