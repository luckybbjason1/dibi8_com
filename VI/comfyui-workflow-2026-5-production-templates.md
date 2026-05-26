---
title: 'ComfyUI Workflow 2026: Hướng dẫn cài đặt cho người mới + 5 template sẵn sàng production'
description: 'ComfyUI cán mốc 106K stars trên GitHub trong năm 2026. Hướng dẫn cài đặt thân thiện với người mới, gợi ý mô hình cho năm 2026, và 5 template workflow sẵn sàng đưa vào production (text-to-image, inpaint, upscale, video, nhất quán nhân vật).'
date: 2026-05-25 00:00:00+08:00
lastmod: 2026-05-25 00:00:00+08:00
tech_stack: ['ComfyUI', 'Stable Diffusion', 'Python', 'CUDA']
application_domain: Công cụ AI
source_version: 'ComfyUI 2026.05'
licensing_model: Mã nguồn mở
license_type: 'GPL-3.0'
github_repo: 'https://github.com/comfyanonymous/ComfyUI'
stars: 106000
maintainer: 'comfyanonymous'
last_maintained: '2026-05-25'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['comfyui', 'stable-diffusion', 'image-generation', 'workflows', '2026']
aliases:
- /vi/posts/comfyui-workflow-2026-5-production-templates/
faq:
  - q: "Năm 2026, ComfyUI có tốt hơn Stable Diffusion WebUI không?"
    a: "Đối với tự động hóa workflow và sử dụng production: có, một cách dứt khoát. Đồ thị dựa trên node của ComfyUI khiến các pipeline phức tạp nhiều bước (upscale → inpaint → ControlNet → render lại) trở nên cực kỳ dễ dàng. SD WebUI đơn giản hơn cho các lần sinh ảnh đơn lẻ. Hầu hết nghệ sĩ AI chuyên nghiệp đều dùng cả hai."
  - q: "Tôi cần phần cứng nào?"
    a: "Tối thiểu: 8GB VRAM (RTX 3060, RTX 4060) cho SDXL ở chất lượng vừa phải. Thoải mái: 16GB+ VRAM (RTX 4080, 4090) cho SDXL + mô hình Flux + xếp chồng LoRA. Production: H100 / nhiều GPU cho các workflow chạy theo batch."
  - q: "Mô hình 2026 nào nên tải về đầu tiên?"
    a: "Ba ưu tiên: (1) SDXL base + refiner (vẫn là ngựa chiến), (2) Flux.1 Schnell (nhanh hơn, tốt để tạo prototype), (3) Stable Diffusion 3.5 Large (chân thực ảnh tốt nhất). Thêm 2-3 LoRA hợp với phong cách của bạn. Bỏ qua hàng tá persona trên Civitai cho đến khi có lý do rõ ràng."
  - q: "Học ComfyUI từ đầu mất bao lâu?"
    a: "Load một workflow + sinh ảnh: 30 phút. Tự dựng workflow riêng: 1-2 ngày. Thành thạo node cho production: 2-3 tuần. Đường cong học tập ban đầu rất dốc nhưng đáng — workflow có thể tái sử dụng, chia sẻ và tái lập."
---

{{</* resource-info */>}}

# ComfyUI Workflow 2026: Cài đặt + 5 Template Production

> **Meta Description**: ComfyUI cán mốc 106K stars trong năm 2026. Hướng dẫn cài đặt + 5 template workflow sẵn sàng production (text-to-image, inpaint, upscale, video, nhất quán nhân vật).

ComfyUI đã trở thành công cụ mặc định cho việc sinh ảnh AI nghiêm túc trong năm 2026. Dựa trên node, tái lập được, có thể tự động hóa. Hướng dẫn này đưa bạn từ con số 0 đến 5 workflow production hoạt động được trong một buổi chiều.

## ⚡ TL;DR

> **Tại sao chọn ComfyUI**: workflow tái lập được, tự động hóa, pipeline phức tạp. 106K stars trong năm 2026.
>
> **Phần cứng**: tối thiểu 8GB VRAM, 16GB+ thoải mái.
>
> **Thời gian cài đặt**: 1 giờ đến lần sinh ảnh đầu tiên.
>
> **5 template bên dưới**: text-to-image, inpaint, chuỗi upscale, video, nhất quán nhân vật.

## Cài đặt (1 giờ)

### Bước 1: Cài đặt (15 phút)
```bash
# Clone + thiết lập venv
git clone https://github.com/comfyanonymous/ComfyUI
cd ComfyUI
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
python main.py
```

Trình duyệt sẽ mở tại `http://localhost:8188`.

### Bước 2: Tải mô hình (30 phút)
Thả vào `ComfyUI/models/checkpoints/`:
- **SDXL base + refiner** (đa năng nhất, tổng ~13GB)
- **Flux.1 Schnell** (prototype nhanh, ~24GB)
- **SD 3.5 Large** (chân thực ảnh tốt nhất, ~17GB)

Tùy chọn nhưng hữu ích:
- 2-3 LoRA hợp phong cách của bạn (trên Civitai, tìm "2026 SDXL trending")
- Mô hình ControlNet (OpenPose, Depth, Canny — mỗi cái ~1.5GB)

### Bước 3: Sinh ảnh lần đầu (15 phút)
- Kéo workflow mặc định từ `ComfyUI/workflows/`
- Load checkpoint SDXL
- Nhập prompt
- Queue prompt

Xong. Bạn đã bắt đầu sinh ảnh. Phần khó bắt đầu từ bây giờ: dựng các workflow có thể tái sử dụng.

## 5 Template Sẵn Sàng Production

### Template 1: Text-to-Image (SDXL base + refiner)
**Dùng cho**: sinh ảnh chuẩn, ngựa chiến hàng ngày.
**Node**: Load Checkpoint → CLIP Text Encode (prompt) → KSampler (base 70%) → KSampler (refiner 30%) → VAE Decode → Save Image.
**Thời gian mỗi ảnh**: 8-15 giây trên RTX 4090.

### Template 2: Mask Inpaint (chỉnh sửa có chọn lọc)
**Dùng cho**: đổi một vùng cụ thể mà không phải sinh lại toàn bộ ảnh.
**Node**: Load Image → MaskEditor → CLIP Text Encode (nội dung mới) → InpaintModelConditioning → KSampler → ghép lại.
**Thời gian mỗi lần chỉnh**: 5-10 giây.

### Template 3: Chuỗi Upscale 4x (đầu ra 4K)
**Dùng cho**: đưa ảnh sinh 1024×1024 → đầu ra production 4096×4096.
**Node**: Sinh ở 1024 → Upscale Latent 2x → KSampler pass tinh chỉnh → Upscale Latent 2x lần nữa → tinh chỉnh cuối.
**Thời gian**: 30-45 giây mỗi ảnh ở 4K.

### Template 4: Image-to-Video (clip 5 giây)
**Dùng cho**: làm động một ảnh tĩnh thành clip chuyển động 5 giây.
**Node**: Load mô hình SVD → Load Image → Image to Video (24 frame @ 8fps) → VAE Decode → Save Video.
**Thời gian**: 60-90 giây trên RTX 4090.
**Mô hình 2026**: Stable Video Diffusion XT hoặc LTX Video.

### Template 5: Nhất Quán Nhân Vật (LoRA + IPAdapter)
**Dùng cho**: sinh cùng một nhân vật qua nhiều cảnh với khuôn mặt nhất quán.
**Node**: Load LoRA (đã train theo nhân vật) + IPAdapter (ảnh tham chiếu) → CLIP Text Encode → KSampler → đầu ra.
**Thời gian mỗi ảnh**: 12-20 giây.
**Mẹo**: tự train LoRA trên 15-20 ảnh nguồn của một nhân vật — IPAdapter lo phần còn lại.

## Chia Sẻ Workflow

Cả 5 template đều có thể lưu dưới dạng `.json`. Kéo lên canvas ComfyUI để load. Chia sẻ với team qua git hoặc Discord.

Cộng đồng đã đăng hàng nghìn workflow tại:
- Subreddit ComfyUI
- Thư viện workflow OpenArt.ai
- Civitai (tìm bộ lọc "ComfyUI workflow")

Mang 2-3 workflow cộng đồng vào và tùy biến theo phong cách của bạn. Đó là cách hầu hết nghệ sĩ production làm việc — không xây từ đầu.

## Hạ Tầng Khuyến Nghị

Cho công việc ComfyUI nghiêm túc:
- **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — credit $200, GPU droplet (H100/L40S/A100)
- **{{< aff "htstack" "footer-cta" "HTStack" >}}** — VPS Hồng Kông để sinh ảnh độ trễ thấp tại châu Á

*Liên kết tiếp thị liên kết — cùng giá, ủng hộ dibi8.com.*

## Kết Luận

Đường cong học tập của ComfyUI là thật nhưng phần thưởng cũng vậy. Khi đã có 5 workflow tái sử dụng được, bạn ra sản phẩm nhanh hơn mọi công cụ dùng một lần. Hệ sinh thái 2026 (Flux, SD 3.5, cải tiến IPAdapter, ControlNet) là stack sinh ảnh mạnh nhất từng được lắp ráp — và ComfyUI là công cụ duy nhất điều phối nó một cách gọn gàng.

Bắt đầu với 5 template ở trên. Tùy biến. Chia sẻ. Hiệu ứng lãi kép của workflow tái sử dụng sẽ xuất hiện sau tuần thứ 2 — khi bạn nhận ra mình kết hợp node nhanh hơn cả viết code.

---

**Bài liên quan**: [Cài đặt Stable Diffusion WebUI](https://dibi8.com/vi/resources/ai-tools/stable-diffusion-webui/) · [Công cụ sinh ảnh AI hàng đầu 2026](https://dibi8.com/vi/resources/ai-tools/ai-image-generation-tools-2025/) · [Stack AI Local-First 2026](https://dibi8.com/vi/resources/llm-frameworks/2026-local-first-ai-stack-production-architecture/)
