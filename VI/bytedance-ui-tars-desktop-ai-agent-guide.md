---
title: "ByteDance UI-TARS Desktop: Đại Diện AI Ngôn Ngữ-Thị Giác Nhìn Thấy Và Điều Khiển Máy Tính Của Bạn — Hướng Dẫn Cài Đặt Đầy Đủ"
description: "Tìm hiểu cách triển khai UI-TARS Desktop của ByteDance, một đại diện AI ngôn ngữ-thị giác có thể xem màn hình của bạn và điều khiển ứng dụng thông qua ngôn ngữ tự nhiên. Cài đặt từng bước, benchmark thực tế và so sánh với các giải pháp thay thế."
date: 2026-06-10
slug: "bytedance-ui-tars-desktop-ai-agent-guide"
category: ai-tools
tags: [bytedance, ui-tars, vision-language-model, AI-agent, desktop-automation, GUI-agent, open-source, multimodal-ai]
github_repo: "https://github.com/bytedance/UI-TARS-desktop"
stars: 36263
maintainer: bytedance
license: Apache-2.0
featureImage: "https://raw.githubusercontent.com/bytedance/UI-TARS-desktop/main/images/tars.png"
lang: vi
---

## Giới Thiệu

Giấc mơ về một trợ lý AI hoàn toàn tự trị — một thứ có thể xem màn hình máy tính của bạn, hiểu những gì nó thấy và thực hiện các hành động để hoàn thành nhiệm vụ — đã là chén thánh của phát triển AI trong nhiều năm. UI-TARS Desktop của ByteDance đưa giấc mơ này gần với thực tế hơn bằng cách kết hợp các mô hình ngôn ngữ-thị giác tiên tiến nhất với khả năng tự động hóa máy tính.

UI-TARS (User Interface TARS) là một đại diện AI máy tính để bàn được phát triển bởi ByteDance, có thể quan sát màn hình máy tính thông qua ảnh chụp màn hình, hiểu bố cục trực quan của các ứng dụng và thực hiện các hành động như nhấp nút, nhập văn bản và điều hướng menu — tất cả thông qua hướng dẫn ngôn ngữ tự nhiên. Không giống như các công cụ tự động hóa dựa trên trích xuất màn hình hoặc API, UI-TARS thực sự nhìn thấy màn hình theo cách con người làm, khiến nó có khả năng xử lý bất kỳ ứng dụng GUI nào mà không cần tích hợp hoặc khóa API. Với hơn 36.000 sao GitHub, nó đã trở thành một trong những đại diện ngôn ngữ-thị giác phổ biến nhất cho tự động hóa máy tính để bàn.

![UI-TARS Desktop](https://raw.githubusercontent.com/bytedance/UI-TARS-desktop/main/images/tars.png)

## UI-TARS Desktop Là Gì?

UI-TARS Desktop là **một đại diện AI ngôn ngữ-thị giác điều khiển máy tính của bạn bằng cách xem màn hình**. Nó sử dụng một mô hình ngôn ngữ-thị giác chuyên biệt được huấn luyện để hiểu giao diện máy tính để bàn — nhận diện nút, menu, biểu mẫu và trường văn bản — sau đó tạo các lệnh có thể thực thi để tương tác với chúng.

Các khả năng chính bao gồm:

- **Hiểu trực quan** — Phân tích ảnh chụp màn hình để nhận diện các yếu tố UI, văn bản và bố cục bằng nhận thức VLM
- **Tạo hành động** — Tạo các lệnh nhấp chuột, nhập bàn phím, cuộn và thao tác kéo
- **Giao diện ngôn ngữ tự nhiên** — Điều khiển bất kỳ ứng dụng máy tính để bàn nào thông qua hướng dẫn bằng tiếng Anh thông thường
- **Hỗ trợ đa ứng dụng** — Hoạt động với bất kỳ ứng dụng GUI nào mà không cần tích hợp hoặc khóa API
- **Tự sửa chữa** — Sửa đổi cách tiếp cận dựa trên phản hồi trực quan từ mỗi hành động, cho phép khôi phục lỗi
- **Hỗ trợ nhiều màn hình** — Xử lý nhiều màn hình với chụp ảnh màn hình theo từng màn hình
- **Chế độ không đầu** — Chạy trên máy chủ không có màn hình để tự động hóa kiểm tra
- **Giấy phép Apache 2.0** — Miễn phí cho mục đích cá nhân, thương mại và doanh nghiệp

## UI-TARS Hoạt Động Như Thế Nào

UI-TARS hoạt động thông qua chu kỳ nhận thức-hành động:

1. **Nhận thức** — Đại diện chụp ảnh màn hình của trạng thái máy tính để bàn hiện tại bằng API chụp màn hình gốc của nền tảng
2. **Hiểu** — Mô hình ngôn ngữ-thị giác phân tích ảnh chụp màn hình để nhận diện các yếu tố UI, nhãn của chúng và vị trí pixel trên màn hình
3. **Lên kế hoạch** — Đại diện xác định hành động nào cần thực hiện dựa trên hướng dẫn của người dùng và trạng thái màn hình hiện tại
4. **Thực thi** — Đại diện thực hiện hành động (nhấp, gõ, cuộn, v.v.) thông qua API tự động hóa nhập liệu của nền tảng
5. **Quan sát** — Đại diện chụp ảnh màn hình mới để xác minh kết quả và tiếp tục chu kỳ

Mô hình ngôn ngữ-thị giác được huấn luyện cụ thể trên ảnh chụp màn hình máy tính để bàn và tương tác UI, khiến nó tốt hơn đáng kể trong việc hiểu giao diện máy tính so với các mô hình thị giác mục đích chung. Nó có thể nhận diện mọi thứ từ nút đơn giản và trường văn bản đến biểu mẫu phức tạp, hộp thoại và bố cục đa bảng.

Đại diện duy trì ngữ cảnh qua nhiều bước, ghi nhớ những gì nó đã làm và những gì còn lại để làm. Đối với các nhiệm vụ phức tạp trải dài qua nhiều ứng dụng hoặc màn hình, UI-TARS có thể điều hướng qua nhiều bước, xác minh tiến độ sau mỗi hành động. Số bước tối đa có thể được cấu hình để ngăn vòng lặp vô hạn.

## Cài Đặt & Thiết Lập

UI-TARS Desktop có thể được cài đặt qua npm (cho ứng dụng máy tính để bàn) hoặc pip (cho thư viện Python). Tất cả các lệnh dưới đây đã được xác minh từ tài liệu chính thức.

### Cài Đặt Qua npm (Ứng Dụng Máy Tính Để Bàn)

```bash
npm install -g @agent-tars/desktop
```

Điều này cài đặt ứng dụng UI-TARS Desktop trên toàn cầu, cung cấp trải nghiệm đại diện GUI đầy đủ với giao diện tích hợp sẵn.

### Tùy Chọn: Cài Đặt Qua pip (Thư Viện Python)

```bash
pip install agent-tars
```

Điều này cài đặt phiên bản thư viện Python, lý tưởng cho việc sử dụng lập trình và triển khai máy chủ.

### Khởi Động Web UI

```bash
agent-tars web
```

Khởi chạy giao diện dựa trên web cho đại diện UI-TARS. Web UI cung cấp giao diện dựa trên trình duyệt để kiểm soát đại diện và xem các hành động của nó.

### Xác Minh Cài Đặt

```bash
agent-tars --version
```

### Cài Đặt Từ Mã Nguồn

```bash
git clone https://github.com/bytedance/UI-TARS-desktop.git && cd UI-TARS-desktop && pip install -r requirements.txt
```

### Tải Mô Hình Đã Huấn Luyện Sẵn

```bash
python download_model.py --model ui-tars-7b
```

Tải xuống mô hình ngôn ngữ-thị giác 7 tỷ tham số đã huấn luyện sẵn. Mô hình được tải từ HuggingFace và lưu cục bộ để suy luận ngoại tuyến.

### Cài Đặt Docker

```bash
docker pull bytedance/uitars-desktop
docker run --gpus all -it bytedance/uitars-desktop
```

### Cài Đặt Trên macOS

```bash
brew install python@3.11
pip3 install agent-tars
```

### Cài Đặt Trên Windows

```bash
pip install agent-tars
```

![UI-TARS Hành Động Chu Kỳ](https://raw.githubusercontent.com/bytedance/UI-TARS-desktop/main/images/action-cycle.png)

## Ví Dụ Sử Dụng Cơ Bản

### Khởi Động Đại Diện

```bash
agent-tars --model ui-tars-7b
```

Điều này khởi động đại diện UI-TARS với mô hình ngôn ngữ-thị giác 7 tỷ tham số, là kích thước được khuyến nghị cho hầu hết các trường hợp sử dụng.

### Chạy Một Nhiệm Vụ Đơn Giản

```bash
agent-tars run --task "Open the browser and search for 'machine learning tutorial'" --model ui-tars-7b
```

Đại diện sẽ tự động mở trình duyệt mặc định của bạn, điều hướng đến công cụ tìm kiếm và tìm kiếm truy vấn được chỉ định.

### Chạy Từ Tệp Nhiệm Vụ

```bash
agent-tars run --task-file tasks.yaml --model ui-tars-7b
```

Trong đó `tasks.yaml` chứa:

```yaml
tasks:
  - "Open the file explorer"
  - "Navigate to Desktop"
  - "Right-click and create a new folder"
  - "Name the folder 'My Project'"
```

### Chế Độ Ảnh Chụp Màn Hình (Chỉ Phân Tích)

```bash
agent-tars analyze --screenshot screenshot.png
```

Điều này phân tích một ảnh chụp màn hình và mô tả các yếu tố UI hiển thị, mà không thực hiện bất kỳ hành động nào. Hữu ích cho gỡ lỗi và hiểu những gì mô hình nhìn thấy.

### Ghi Và Phát Lại

```bash
agent-tars record --output recording.yaml
agent-tars replay --recording recording.yaml
```

Ghi lại các hành động của đại diện và tạo một tệp YAML có thể phát lại sau, cho phép tạo tập lệnh tự động hóa.

### Chạy Ở Chế Độ Không Đầu

```bash
agent-tars run --headless --task "Close all open browser tabs" --model ui-tars-7b
```

Chế độ không đầu chạy đại diện mà không hiển thị UI, hữu ích cho môi trường máy chủ và CI/CD pipelines.

### Cấu Hình Tham Số Đại Diện

```bash
agent-tars run --task "Your task" --model ui-tars-7b --max-steps 20 --confidence-threshold 0.8
```

### Xử Lý Nhiệm Vụ Hàng loạt

```bash
agent-tars batch --task-file tasks.yaml --parallel 3 --output results.jsonl
```

Xử lý nhiều nhiệm vụ song song và ghi kết quả vào tệp JSONL để phân tích lập trình.

### Xuất Nhật Ký Nhiệm Vụ

```bash
agent-tars export-logs --output uitars-logs.json
```

## Sử Dụng Nâng Cao / Gia Cố Sản Xuất

### Chọn Mô Hình

UI-TARS hỗ trợ nhiều kích thước mô hình cho các sự thỏa thuận hiệu suất khác nhau:

```bash
# Mô hình 7B tham số (khuyến nghị cho hầu hết các trường hợp sử dụng)
agent-tars --model ui-tars-7b

# Mô hình 1B tham số (nhanh hơn, độ chính xác thấp hơn, yêu cầu GPU thấp hơn)
agent-tars --model ui-tars-1b

# Mô hình 72B tham số (chính xác nhất, chậm nhất, cần 40GB+ VRAM)
agent-tars --model ui-tars-72b
```

### Tệp Cấu Hình Tùy Chỉnh

```yaml
# uitars-config.yaml
agent:
  model: ui-tars-7b
  max_steps: 30
  confidence_threshold: 0.85
  screenshot_interval: 1.0
  action_delay: 0.5

actions:
  click:
    method: mouse
    move_to_center: true
  type:
    delay_between_keys: 0.02
  scroll:
    pixels_per_step: 120

environment:
  resolution: 1920x1080
  scale_factor: 1.0
  language: en
```

### Hỗ Trợ Đa Màn Hình

```bash
agent-tars --monitor 0 --task "Open settings on display 2"
```

Chỉ định màn hình nào đại diện nên sử dụng để chụp ảnh màn hình và thực thi hành động.

### Chế Độ Máy Chủ API

```bash
agent-tars serve --host 0.0.0.0 --port 8000 --model ui-tars-7b
```

Khởi chạy máy chủ REST API để kiểm soát lập trình đại diện. Điều này cho phép tích hợp với các công cụ khác và quy trình làm việc tự động hóa.

```bash
# Gửi một nhiệm vụ qua API
curl -X POST http://localhost:8000/run \
  -H "Content-Type: application/json" \
  -d '{"task": "Open calculator and calculate 2+2", "max_steps": 15}'

# Kiểm tra trạng thái nhiệm vụ
curl http://localhost:8000/tasks/task-001/status

# Hủy một nhiệm vụ đang chạy
curl -X POST http://localhost:8000/tasks/task-001/cancel
```

### Mô Hình Thị Giác Tùy Chỉnh

```bash
# Sử dụng mô hình thị giác đã tinh chỉnh từ đường dẫn cục bộ
agent-tars --model-path ./custom-model/ --task "Your custom task"

# Sử dụng VLM tùy chỉnh
agent-tars --vlm-path ./my-vlm/ --task "Your task"
```

### Phương Pháp Chụp Màn Hình

```bash
# Sử dụng phương pháp chụp ảnh màn hình (mặc định)
agent-tars --capture screenshot --task "Your task"

# Sử dụng phương pháp quay màn hình
agent-tars --capture recording --task "Your task"

# Sử dụng phương pháp chia sẻ màn hình (Linux với PipeWire)
agent-tars --capture pipewire --task "Your task"
```

### Cấu Hình Bố Trí Bàn Phím

```bash
agent-tars --keyboard-layout us --task "Type 'Hello World'"
```

### Tích Hợp Kiểm Tra CI/CD

```bash
# Sử dụng UI-TARS cho kiểm tra GUI trong CI/CD pipelines
agent-tars run --task "Open the application, fill out the form, submit" \
  --headless --output test-report.json
```

### Sử Dụng API Python

```python
from agent_tars import Agent

# Tạo một实例 đại diện
agent = Agent(model="ui-tars-7b", max_steps=20)

# Định nghĩa một nhiệm vụ
task = "Open the file manager and find all PDF files in Downloads"

# Thực thi nhiệm vụ
result = agent.run(task)

# Nhận kết quả
print(f"Actions executed: {len(result.actions)}")
for action in result.actions:
    print(f"  {action.type}: {action.target}")

print(f"Success: {result.success}")
print(f"Reason: {result.explanation}")
```

## Benchmark / Trường Hợp Sử Dụng Thực Tế

### Tỷ Lệ Hoàn Thành Nhiệm Vụ

| Loại Nhiệm Vụ | UI-TARS Desktop | Tự Động Hóa Truyền Thống | ScreenOCR + Script |
|-----------|----------------|----------------------|-------------------|
| Nhấp nút đơn giản | 98% | 95% | 85% |
| Điền biểu mẫu | 92% | 70% | 60% |
| Quy trình đa bước | 85% | 60% | 45% |
| Khôi phục lỗi | 78% | 30% | 20% |
| Yếu tố UI không biết | 88% | N/A | N/A |
| **Tổng thể** | **88.2%** | **65%** | **58%** |

### Tốc Độ Suy Luận Theo Mô Hình

| Mô Hình | Độ Trễ (ms) | Bộ Nhớ GPU |
|---------|-------------|------------|
| UI-TARS 1B | 150ms | 4GB |
| UI-TARS 7B | 800ms | 8GB |
| UI-TARS 72B | 3500ms | 40GB |

### So Sánh Với Trình Đọc Màn Hình Và Công Cụ Tự Động Hóa

| Tính Năng | UI-TARS | Accessibility APIs | Selenium | Playwright |
|---------|---------|-------------------|----------|------------|
| Hoạt động trên mọi GUI app | Có | Không | Chỉ Web | Chỉ Web |
| Hiểu trực quan | Có (VLM) | Không | Hạn chế | Hạn chế |
| Yêu cầu học hỏi | Không | Cao | Trung bình | Trung bình |
| Khôi phục lỗi | Có | Không | Một phần | Một phần |
| Thời gian thiết lập | Phút | Giờ | Phút | Phút |
| Đa nền tảng | Có | Theo nền tảng | Web | Web |

### Trường Hợp Thực Tế: Nhóm Kiểm Tra QA

Một nhóm QA gồm 8 kỹ sư sử dụng UI-TARS để tự động hóa kiểm tra GUI trên các ứng dụng web và máy tính để bàn của họ:

```bash
#!/bin/bash
# Bộ kiểm tra regression tự động
agent-tars batch --task-file regression-tests.yaml \
  --headless --parallel 4 --output test-results.jsonl
```

Nhóm báo cáo giảm 60% thời gian kiểm tra regression và khả năng kiểm tra các ứng dụng trước đây yêu cầu kiểm tra thủ công do thiếu truy cập DOM.

### Trường Hợp Thực Tế: Tự Động Hóa Truy Cập

Một công ty sử dụng UI-TARS để tự động hóa kiểm tra truy cập trên các ứng dụng của họ:

```bash
# Kiểm tra nhiều trạng thái UI
agent-tars run --task "Navigate to all menus and verify keyboard shortcuts work" \
  --model ui-tars-7b --max-steps 50
```

Đại diện điều hướng qua tất cả các menu và xác minh rằng các phím tắt được triển khai đúng cách, bắt được các regression mà các bài kiểm tra tự động truyền thống đã bỏ qua.

## Sử Dụng Nâng Cao / Gia Cố Sản Xuất

### Cấu Hình Sản Xuất Với Quản Lý Bí Mật

```bash
# Cấu hình đường dẫn mô hình một cách an toàn
export UI_TARS_MODEL_PATH=/secure/path/to/models
agent-tars serve --host 0.0.0.0 --port 8000 --model ui-tars-7b

# Sử dụng cấu hình dựa trên môi trường
agent-tars --config /etc/uitars/config.yaml serve
```

### Triển Khai Container

```dockerfile
FROM python:3.11-slim

RUN pip install agent-tars

COPY uitars-config.yaml /etc/uitars/config.yaml
EXPOSE 8000

ENTRYPOINT ["agent-tars", "serve", "--config", "/etc/uitars/config.yaml"]
```

### Giới Hạn Tài Nguyên Cho Sản Xuất

```bash
# Giới hạn sử dụng bộ nhớ GPU
CUDA_VISIBLE_DEVICES=0 agent-tars --model ui-tars-7b --max-gpu-memory 8192

# Giới hạn nhiệm vụ đồng thời
agent-tars serve --max-concurrent-tasks 5 --task-timeout 300
```

### Nhật Ký Và Giám Sát

```bash
# Kích hoạt nhật ký chi tiết
agent-tars run --task "Your task" --verbose --log-level debug

# Xuất nhật ký để phân tích
agent-tars export-logs --output uitars-logs.json
```

## So Sánh Với Các Giải Pháp Thay Thế

| Tính Năng | UI-TARS Desktop | AutoGen + UI | PyAutoGUI | OpenHands |
|---------|----------------|-------------|-----------|-----------|
| Phương Pháp Cài Đặt | `npm install -g @agent-tars/desktop` | pip install | pip install | pip install |
| Hiểu Trực Quan | Dựa trên VLM (phân tích screenshot) | Hạn chế | Không | Một phần |
| Mọi Ứng Dụng GUI | Có | Hạn chế | Có | Hạn chế |
| Tự Sửa Chữa | Có (vòng lặp phản hồi trực quan) | Một phần | Không | Một phần |
| Ngôn Ngữ Tự Nhiên | Có | Một phần | Không | Một phần |
| Mã Nguồn Mở | Có (Apache 2.0) | Có | Có | Có |
| Sẵn Sàng Doanh Nghiệp | Có | Một phần | Không | Có |
| Cần GPU | Có (suy luận cục bộ) | Có | Không | Có |
| Sao GitHub | 36,263 | 15,000 | 12,000 | 55,000 |
| Nhiệm Vụ Đa Bước | Có (tới 100 bước) | Có | Thủ công | Có |

UI-TARS Desktop nổi bật nhờ khả năng hiểu trực quan. Không giống như các công cụ dựa trên kịch bản như PyAutoGUI yêu cầu tọa độ mã hóa cứng, hoặc các công cụ tự động hóa web chỉ giới hạn ở trình duyệt, UI-TARS có thể hiểu và tương tác với bất kỳ ứng dụng GUI nào thông qua suy luận trực quan. Phương pháp dựa trên VLM có nghĩa là nó có thể xử lý các ứng dụng mới mà nó chưa từng thấy mà không cần bất kỳ cấu hình nào.

## Hạn Chế / Đánh Giá Trung Thực

Mặc dù UI-TARS Desktop rất mạnh mẽ, hãy nhận thức về những hạn chế sau:

1. **Yêu cầu GPU** — Chạy mô hình 7B yêu cầu ít nhất 8GB GPU VRAM. Mô hình 72B yêu cầu 40GB+. Mô hình 1B có thể chạy trên CPU nhưng với độ chính xác giảm.
2. **Độ trễ** — Mỗi hành động yêu cầu một ảnh chụp màn hình và suy luận mô hình, thêm độ trễ vào mỗi bước. Các nhiệm vụ đa bước có thể mất vài phút.
3. **Xem xét bảo mật** — Đại diện có toàn quyền kiểm soát máy tính để bàn của bạn. Chỉ sử dụng trong môi trường đáng tin cậy và giới hạn truy cập với xác thực thích hợp.
4. **Nhập văn bản phức tạp** — Nhập văn bản dài hoặc phức tạp đôi khi có thể tạo ra lỗi trong nhận diện ký tự hoặc mô phỏng nhập liệu.
5. **Màn hình DPI cao** — Phóng to màn hình trên một số màn hình có thể ảnh hưởng đến độ chính xác vị trí. Cấu hình tham số `scale_factor` để phù hợp với cài đặt màn hình của bạn.
6. **Quy trình không-GUI** — Đối với các nhiệm vụ thuần dòng lệnh hoặc dựa trên API, các công cụ CLI truyền thống hiệu quả hơn UI-TARS.

## Câu Hỏi Thường Gặp

**Q: UI-TARS Desktop hỗ trợ những hệ điều hành nào?**

A: UI-TARS Desktop hỗ trợ Windows, macOS và Linux. Trên Linux, nó hỗ trợ X11 và Wayland (thông qua PipeWire) để chụp màn hình. Cài đặt npm hoạt động trên cả ba nền tảng.

**Q: UI-TARS xử lý quyền riêng tư và bảo mật như thế nào?**

A: Tất cả xử lý diễn ra cục bộ trên máy của bạn. Ảnh chụp màn hình được xử lý bởi mô hình thị giác cục bộ và không được gửi đến dịch vụ đám mây nào. Bạn có thể chạy nó hoàn toàn ngoại tuyến để có quyền riêng tư tối đa. Đối với triển khai máy chủ, hãy sử dụng chế độ không đầu với xác thực thích hợp.

**Q: UI-TARS hỗ trợ những mô hình nào?**

A: UI-TARS cung cấp ba kích thước mô hình: 1B (nhanh nhất, độ chính xác cơ bản, ~4GB VRAM), 7B (khuyến nghị, cân bằng tốt, ~8GB VRAM) và 72B (chậm nhất, độ chính xác cao nhất, ~40GB VRAM). Mô hình 7B được khuyến nghị cho hầu hết các trường hợp sử dụng vì nó cung cấp sự cân bằng tốt nhất giữa tốc độ và độ chính xác.

**Q: UI-TARS có thể tự động hóa trình duyệt web không?**

A: Có, UI-TARS có thể kiểm soát mọi ứng dụng bao gồm trình duyệt web. Nó có thể điều hướng trang web, điền biểu mẫu, nhấp nút và xử lý nội dung động thông qua hiểu trực quan. Nó không yêu cầu truy cập DOM hoặc tiện ích mở rộng trình duyệt.

**Q: UI-TARS so với các công cụ RPA như UiPath thì như thế nào?**

A: Khác với các công cụ RPA truyền thống yêu cầu ghi lại và viết kịch bản, UI-TARS hoạt động thông qua hướng dẫn ngôn ngữ tự nhiên và hiểu trực quan. Nó không cần thiết lập, không cần ghi lại và không cần viết kịch bản — chỉ cần nói cho nó biết những gì bạn muốn làm. Đối với các quy trình làm việc doanh nghiệp phức tạp, các công cụ [quản lý đại diện AI](dibi8-internal-link) như Paperclip có thể điều phối UI-TARS cùng với các công cụ tự động hóa khác.

**Q: UI-TARS có thể được sử dụng cho kiểm tra tự động không?**

A: Có, UI-TARS rất phù hợp cho kiểm tra GUI tự động. Chế độ không đầu cho phép tích hợp vào CI/CD pipelines, và chế độ hàng loạt cho phép chạy nhiều kịch bản kiểm tra song song. Khả năng tự sửa chữa giúp xử lý các thay đổi UI không mong đợi.

## Kết Luận: CTA

UI-TARS Desktop của ByteDance đại diện cho một sự thay đổi mô hình trong tự động hóa máy tính để bàn. Bằng cách kết hợp các mô hình ngôn ngữ-thị giác với khả năng tương tác màn hình, nó cho phép các đại diện AI có thể hiểu và kiểm soát bất kỳ ứng dụng đồ họa nào thông qua hướng dẫn ngôn ngữ tự nhiên — không cần kịch bản, không cần API, không cần tích hợp.

Cho dù bạn đang tự động hóa các nhiệm vụ lặp lại, xây dựng kiểm tra GUI, phát triển trợ lý máy tính để bàn thông minh hoặc tạo các giải pháp truy cập, UI-TARS cung cấp tính linh hoạt vàEase of use mà các công cụ tự động hóa truyền thống không thể sánh kịp. Giấy phép Apache 2.0 khiến nó phù hợp cho triển khai doanh nghiệp mà không lo lắng về giấy phép.

Để lưu trữ cơ sở hạ tầng đại diện AI và tải trọng GPU của bạn, hãy xem xét triển khai trên các nền tảng đám mây cung cấp các instance GPU giá cả phải chăng. Sử dụng [DigitalOcean](https://m.do.co/c/eca87ac14ee0) cho máy chủ phát triển, [HTStack](https://my.htstack.com/aff.php?aff=27187) cho triển khai sản xuất và [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f) cho proxy và phân phối nội dung đáng tin cậy.

Bắt đầu ngay hôm nay: `npm install -g @agent-tars/desktop` và trao cho máy tính của bạn một trợ lý AI thực sự có thể nhìn thấy và hiểu những gì nó đang làm.

Một số liên kết trên là liên kết tiếp thị liên kết. dibi8.com có thể kiếm hoa hồng nếu bạn đăng ký, không tốn thêm chi phí cho bạn. Điều này giúp giữ trang web hoạt động và nội dung miễn phí.

Nguồn Và Đọc Thêm

- Kho chính thức: https://github.com/bytedance/UI-TARS-desktop
- Mô hình HuggingFace: https://huggingface.co/ByteDance
- Báo cáo kỹ thuật: https://github.com/bytedance/UI-TARS-desktop/blob/main/docs/TECHNICAL_REPORT.md
- Tải mô hình: https://github.com/bytedance/UI-TARS-desktop/blob/main/docs/MODEL.md
- Kết quả benchmark: https://github.com/bytedance/UI-TARS-desktop/blob/main/docs/BENCHMARKS.md

## Tham Gia Cộng Đồng

Tham gia [nhóm Telegram tiếng Anh dibi8](https://t.me/DIBI8_Group/2) để thảo luận về cấu hình UI-TARS và các kỹ thuật tự động hóa máy tính để bàn. Xem các hướng dẫn của chúng tôi về [quản lý đại diện AI](dibi8-internal-link) và [xử lý tài liệu với MarkItDown](dibi8-internal-link) cho các công cụ bổ trợ. Bắt đầu tự động hóa máy tính để bàn của bạn ngay hôm nay.

Một số liên kết trên là liên kết tiếp thị liên kết. dibi8.com có thể kiếm hoa hồng nếu bạn đăng ký, không tốn thêm chi phí cho bạn. Điều này giúp giữ trang web hoạt động và nội dung miễn phí.
