---
title: 'Stable Diffusion WebUI 2026 (AUTOMATIC1111): Hướng Dẫn Đầy Đủ Sinh Ảnh Self-Host 163k Sao'
description: 'AUTOMATIC1111 stable-diffusion-webui là UI self-host tiêu chuẩn de-facto 163k sao cho sinh ảnh SD/SDXL. Hướng dẫn cài đặt + production 2026 đầy đủ: txt2img / img2img / inpainting / outpainting / LoRA / ControlNet, yêu cầu phần cứng, lựa chọn thay thế (Forge, SD.Next).'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack: [Python, PyTorch, Gradio, CUDA]
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/AUTOMATIC1111/stable-diffusion-webui'
stars: 163000
maintainer: 'AUTOMATIC1111'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['Stable Diffusion', 'SDXL', 'sinh ảnh', 'AUTOMATIC1111', 'mã nguồn mở']
aliases:
  - /posts/stable-diffusion-webui-2026/
---

Nếu bạn từng Google "stable diffusion install" kết quả đầu tiên là **AUTOMATIC1111's stable-diffusion-webui** trong 3 năm liên tiếp. Ở 163k GitHub sao (một trong các project AI nhiều sao nhất trong lịch sử), nó là UI self-host mặc định cho sinh ảnh họ SD năm 2026 — text-to-image, image-to-image, inpainting, outpainting, LoRA, ControlNet, sinh batch, tất cả phía sau UI web Gradio bạn có thể chạy trên GPU 4 GB.

Đây là câu trả lời "Tôi muốn sinh ảnh local mà không trả $20/tháng cho Midjourney" cho creator solo và dev. Cho workflow phức tạp hơn (pipeline đa mô hình, sinh video, audio), xem [ComfyUI](/vi/resources/ai-tools/comfyui-node-based-ai-image-2026/) — hai cái bổ sung nhau, không cạnh tranh.

## TL;DR

- **Là gì**: UI web Gradio cho mô hình họ SD
- **GitHub**: 163k sao, 7,689+ commit, mới nhất v1.10.1
- **License**: AGPL-3.0 (chú ý cho triển khai SaaS)
- **Mô hình**: SD 1.5, SD 2.x, SSD-1B, Alt-Diffusion native; SDXL qua extension; SD3 / Flux qua fork
- **Phần cứng**: 4 GB VRAM tối thiểu (báo cáo 2 GB hoạt động với `--lowvram`)
- **Fork đáng biết**: Forge (nhanh hơn, focus SDXL/Flux), SD.Next (rolling release)

## 1. Vì Sao A1111 Vẫn Là Mặc Định Năm 2026

Hệ sinh thái sinh ảnh phân mảnh mạnh sau khi Flux ra (tháng 9/2024) và SD 3.5 theo sau. ComfyUI chiếm niche "pipeline phức tạp". Nhưng A1111 vẫn là mặc định vì:

1. **Đường cong học thấp nhất** — text box, nút sinh, xong
2. **Nhiều extension nhất** — 500+ extension xử lý ControlNet, ADetailer, Regional Prompter, training, mọi thứ
3. **Nhiều tutorial nhất** — 4 năm nội dung Reddit/YouTube đều theo hình dáng A1111
4. **Đủ cho 80% trường hợp sử dụng** — khi bạn chỉ muốn "ảnh tốt từ text", view graph của ComfyUI quá mức

Nếu mới làm sinh ảnh local: bắt đầu ở đây. Chuyển sang ComfyUI khi vượt qua.

## 2. Số Liệu Phần Cứng Thực Tế (2026)

| GPU | SD 1.5 (512×768) | SDXL (1024×1024) | Flux (1024×1024) |
|---|---|---|---|
| 4 GB (GTX 1650 / 3050) | ~15s/ảnh | ~60s (`--lowvram`) | Không thực tế |
| 8 GB (RTX 3060 / 4060) | ~5s | ~12s | ~30s (`--medvram`) |
| 12 GB (RTX 3060 12GB / 4070) | ~3s | ~6s | ~15s |
| 16-24 GB (RTX 4080 / 4090) | ~1.5s | ~3s | ~6s |

Sử dụng cloud: instance GPU $0.30-0.50/giờ trên Vast.ai hoặc {{< aff "digitalocean" "sd-gpu" "DigitalOcean GPU droplets" >}} rẻ hơn Midjourney ở bất kỳ volume có ý nghĩa.

## 3. Cài Nhanh (15 phút)

**Linux/macOS**:
```bash
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
cd stable-diffusion-webui
./webui.sh  # tự cài Python deps, tải mô hình mặc định
```

**Windows**: Tải zip release mới nhất, giải nén, chạy `webui-user.bat`.

Lần chạy đầu tải xuống ~4 GB (mô hình SD 1.5 mặc định) + ~2 GB Python deps. Mở trình duyệt tại `http://localhost:7860`.

## 4. Cài Đặt 80/20

Cho workflow "chỉ tạo ảnh đẹp cho tôi":

- **Sampler**: DPM++ 2M Karras hoặc Euler a
- **Steps**: 20-30 (trên 30 = lợi nhuận giảm)
- **CFG Scale**: 7 (thấp hơn = sáng tạo hơn, cao hơn = literal hơn)
- **Độ phân giải**: 512×768 cho SD 1.5, 1024×1024 cho SDXL
- **Negative prompt baseline**: `bad anatomy, blurry, low quality, watermark, text, signature`

Cho chất lượng cao: bật Hires fix (2× upscale + denoise 0.4-0.5) với chi phí 2× thời gian sinh.

## 5. Extension Thiết Yếu

Top pick từ 500+ tab Extensions:

- **ControlNet** — điều kiện hóa pose / depth / canny / scribble. Extension hữu ích đơn lẻ nhất
- **ADetailer** — tự sửa khuôn mặt và tay (hai mode thất bại của SD)
- **Regional Prompter** — prompt khác nhau cho phần khác nhau của ảnh
- **Dynamic Prompts** — cú pháp wildcard `{red|blue|green} car`
- **Civitai Helper** — quản lý mô hình tải từ Civitai
- **sd-webui-prompt-history** — khôi phục prompt từ sinh quá khứ

Cài qua Extensions tab → Install from URL → dán URL GitHub → Apply và restart.

## 6. LoRA / Embedding / ControlNet Workflow

Ba cơ chế tùy chỉnh:

- **LoRA** (Low-Rank Adaptation) — file nhỏ (~150 MB) điều chỉnh mô hình cơ sở về style hoặc đối tượng cụ thể. Đặt vào `models/Lora/`, tham chiếu trong prompt: `<lora:style_name:0.8>`
- **Textual Inversion / Embeddings** — nhỏ hơn (~30 KB), bổ sung khái niệm đơn. Đặt vào `embeddings/`, chỉ gõ từ trigger trong prompt
- **ControlNet** — điều kiện sinh trên pose / depth / line art / v.v. Mô hình vào `models/ControlNet/`

Civitai là hub de-facto cho LoRA và checkpoint cộng đồng. Extension Civitai Helper tự đồng bộ file local với metadata.

## 7. Hỗ Trợ SDXL / SD3 / Flux (Thực Tế 2026)

Box ngoài, mainline A1111 làm SD 1.x/2.x. Cho mô hình mới hơn:

- **SDXL** — hoạt động mainline từ v1.6
- **SDXL Turbo / Lightning** — hoạt động, cấu hình như SDXL tăng tốc
- **SD 3.5** — cần fork Forge hoặc extension, mainline tụt hậu
- **Flux** — cần fork Forge; mainline A1111 không hỗ trợ Flux tính đến v1.10
- **Muốn tất cả trên + Wan + Hunyuan?** Chuyển [ComfyUI](/vi/resources/ai-tools/comfyui-node-based-ai-image-2026/)

Setup 2026 dùng SDXL hàng ngày: mainline A1111 hoạt động. Pipeline sáng tạo Flux-first: fork Forge. Hỗ trợ mọi thứ: ComfyUI.

## 8. Pattern Self-Host Production

Triển khai "API ảnh cá nhân":

```
   {{< aff "digitalocean" "sd-droplet" "GPU droplet" >}} (RTX 6000 Ada $0.50/giờ hoặc thuê trên Vast.ai)
            │
            ▼
   A1111 với cờ --api bật
            │
            ▼
   Wrapper FastAPI nội bộ (auth + rate limit + queue)
            │
            ▼
   App / agent của bạn gọi /sdapi/v1/txt2img
```

Ví dụ chi phí: 8 giờ/ngày × $0.50/giờ × 30 ngày = $120/tháng cho sinh không giới hạn, vs Midjourney $30/tháng cho 200 fast giờ. Hòa vốn ở sử dụng vừa phải.

## 9. A1111 vs Forge vs SD.Next vs ComfyUI

| Chọn | Khi nào |
|---|---|
| **A1111 mainline** | Mặc định, focus SD 1.x/SDXL, hệ sinh thái extension lớn nhất |
| **Forge** | Cùng UI A1111 nhưng nhanh hơn 30-75%, SDXL/Flux sẵn sàng, footprint VRAM nhỏ hơn |
| **SD.Next** | Rolling release, hỗ trợ gần như mọi thứ A1111+Forge hỗ trợ nhưng fork đơn |
| **ComfyUI** | Workflow phức tạp, sinh video, audio, mô hình mới nhất ngày 1, điều khiển dựa node |

Khuyến nghị thành thật 2026: thử mainline A1111 trước. Nếu cần Flux hoặc tốc độ, chuyển sang Forge. Nếu vượt mô hình tinh thần UI tuyến tính, học ComfyUI.

## TL;DR

AUTOMATIC1111 SD WebUI = **sinh ảnh self-host mặc định cho creator solo năm 2026**. 163k sao, tối thiểu 4 GB VRAM, chạy SD 1.x/SDXL box ngoài. Pair với Civitai cho mô hình cộng đồng, ControlNet/LoRA/ADetailer cho điều khiển nâng cao.

Bật instance GPU, chạy cài đặt mục 3, và 15 phút sau bạn có sinh ảnh local hòa vốn với Midjourney ở bất kỳ volume có ý nghĩa.

---

*Một phần của stack nội dung đa phương thức dibi8 — xem [ComfyUI cho workflow dựa node](/vi/resources/ai-tools/comfyui-node-based-ai-image-2026/) và bộ sưu tập Multi-Modal Content Pipeline sắp tới.*
