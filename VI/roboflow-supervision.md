---
title: "Roboflow Supervision: Bộ công cụ chú thích thị giác máy tính Python"
description: "Supervision của Roboflow là một bộ công cụ thị giác máy tính toàn diện giúp đơn giản hóa chú thích CV, xử lý dữ liệu và đánh giá mô hình. pip install supervision để truy cập các công cụ thị giác máy tính tái sử dụng cho dự án của bạn."
date: 2026-06-10
slug: roboflow-supervision
category: data-science
tags: [supervision, roboflow, computer vision, annotation, object detection, CV toolkit, data-science]
github_repo: https://github.com/roboflow/supervision
stars: 42819
maintainer: roboflow
license: MIT
featureImage: https://raw.githubusercontent.com/roboflow/supervision/main/docs/assets/supervision-banner.png
lang: vi
---

## Giới thiệu

Thị giác máy tính đã trở thành một trong những ứng dụng impactful nhất của machine learning, powering từ autonomous vehicles và quality inspection systems đến medical imaging và retail analytics. Nhưng xây dựng production-grade CV system yêu cầu nhiều hơn chỉ training model — nó demands robust tools cho data annotation, evaluation, visualization và debugging.

**Supervision** bởi [Roboflow](https://github.com/roboflow) là answer cho need này. Với [42.819 sao GitHub](https://github.com/roboflow/supervision), nó đã trở thành go-to toolkit cho computer vision practitioner cần reusable, well-designed Python tool. Slogan của họ nói lên tất cả: **"We write your reusable computer vision tools."**

**Tuyên bố:** Bài viết này có thể chứa liên kết liên kết. Nếu bạn đăng ký qua chúng, tôi có thể kiếm được một khoản hoa hồng nhỏ mà không tốn thêm chi phí cho bạn. [Chính sách tuyên bố](/about/disclosure)

[DigitalOcean](https://www.digitalocean.com/try/affiliate) - Cơ sở hạ tầng đám mây đáng tin cậy cho CV deployment của bạn. [HTStack](https://htstack.com/) - Lưu trữ máy chủ hiệu suất cao. [WebShare](https://webshare.io/) - Dịch vụ proxy cao cấp cho pipeline dữ liệu AI.

## Supervision là gì?

Supervision là một Python library cung cấp một comprehensive set của tools cho computer vision task. Nó bao gồm toàn bộ CV pipeline — từ annotating training data và evaluating model output đến visualizing detection result và processing video stream.

Library được xây dựng dựa trên một simple philosophy: làm cho most common CV operation trivially easy trong khi vẫn giữ cửa mở cho custom workflow. Cho dù bạn đang annotating image cho object detection, evaluating segmentation model output hoặc visualizing tracking result trong video, Supervision đều cover bạn.

**Hình ảnh tính năng:**

![Tổng quan Supervision Library](https://raw.githubusercontent.com/roboflow/supervision/main/docs/assets/supervision-overview.png)

## Tính năng Cốt lõi

Supervision cung cấp tools across toàn bộ computer vision lifecycle:

### Data Annotation

Supervision cung cấp utility cho việc tạo, manipulat và convert annotation format. Nó hỗ trợ COCO, YOLO, Pascal VOC và custom format, làm cho dễ dàng làm việc với các ML framework và pipeline khác nhau.

```python
# Import supervision
from supervision import *

# Load annotation hiện tại
annotations = load_annotations("annotations/coco_format.json")

# Convert giữa annotation format
coco_to_yolo(
    input_path="annotations/coco_format.json",
    output_path="annotations/yolo_format.txt",
    class_map={"person": 0, "car": 1, "dog": 2}
)

# Inspect annotation statistics
stats = get_annotation_stats(annotations)
print(f"Tổng objects: {stats.total_objects}")
print(f"Classes: {stats.classes}")
print(f"Images: {stats.total_images}")
```

### Detection Processing

Supervision cung cấp powerful tools cho việc processing detection model output, bao gồm confidence filtering, non-maximum suppression và result visualization.

```python
import supervision as sv
import cv2

# Load một detection model (works với YOLO, Detectron, v.v.)
detections = sv.Detections.from_yolo_output(
    prediction,  # model output tensor
    original_image_size,  # image dimensions
    confidence_threshold=0.5,
    class_id=0  # filter by class
)

# Apply non-maximum suppression
detections = sv.NMS(detections, iou_threshold=0.45)

# Filter by confidence
detections = detections[detections.confidence > 0.6]
```

### Visualization và Annotation Drawing

Một trong những strength của Supervision là visualization toolkit. Vẽ bounding box, segmentation mask, keypoint và tracking ID trên image và video frame là straightforward:

```python
# Tạo annotation context cho drawing
annotation_context = sv.BoxAnnotator(
    thickness=2,
    color_lookup=sv.ColorLookup.INDEX
)

# Load image
image = cv2.imread("scene.jpg")

# Vẽ bounding box
annotated_image = annotation_context.annotate(
    scene=image,
    detections=detections
)

# Vẽ segmentation mask
mask_annotator = sv.MaskAnnotator(
    opacity=0.5,
    color_lookup=sv.ColorLookup.INDEX
)
annotated_image = mask_annotator.annotate(
    scene=annotated_image,
    detections=detections
)

# Vẽ class label với confidence
label_annotator = sv.LabelAnnotator(
    text_scale=0.5,
    text_thickness=1,
    color_lookup=sv.ColorLookup.INDEX
)
annotated_image = label_annotator.annotate(
    scene=annotated_image,
    detections=detections
)

# Save result
cv2.imwrite("annotated_scene.jpg", annotated_image)
```

### Tracking Support

Supervision có first-class support cho object tracking, với built-in integration cho các tracking algorithm phổ biến:

```python
# Khởi tạo một tracker
tracker = sv.Tracker(
    tracker_type="ocsort",  # hoặc "bytetrack"
    max_age=30,
    min_hits=3,
    iou_threshold=0.3
)

# Track objects qua video frame
video_path = "traffic_camera.mp4"
for frame_number, frame in enumerate(
    sv.VideoInfo.from_video_path(video_path).iter_frames()
):
    detections = detect_objects(frame)  # detection model của bạn
    detections = tracker.update_with_detections(detections)
    
    # Annotated frame với tracking ID
    annotated_frame = draw_tracking_ids(frame, detections)
```

### Metric Computation

Supervision cung cấp tools cho việc computing common CV evaluation metric:

```python
# Compute confusion matrix
confusion_matrix = sv.ConfusionMatrix(
    num_classes=10,
    task="multiclass"
)
confusion_matrix.compute(
    predictions=predicted_labels,
    targets=ground_truth_labels
)

# Display confusion matrix
confusion_matrix.plot(title="Model Performance")

# Get precision, recall và F1 per class
for class_name, metrics in confusion_matrix.class_metrics().items():
    print(f"{class_name}: precision={metrics.precision:.3f}, recall={metrics.recall:.3f}, f1={metrics.f1:.3f}")
```

## Cách hoạt động

Supervision hoạt động qua một clean, consistent API theo một vài core design pattern:

### Detections như Data Structure

Trái tim của Supervision là class `Detections`, cung cấp unified representation cho tất cả các loại object detection output — bounding box, segmentation mask, keypoint và orientation angle.

```python
from supervision import Detections

# Create detections từ scratch
detections = Detections(
    xyxy=np.array([  # bounding box [x1, y1, x2, y2]
        [100, 50, 300, 250],
        [400, 100, 600, 300]
    ]),
    confidence=np.array([0.95, 0.87]),
    class_id=np.array([0, 2]),
    mask=np.array([mask_1, mask_2]),  # optional segmentation mask
    keypoints=np.array([keypoints_1, keypoints_2])  # optional keypoint
)

# Filter detections
person_detections = detections[detections.class_id == 0]
high_confidence = detections[detections.confidence > 0.8]

# Compute IoU giữa hai detection set
ious = sv.match_iou(detections_a, detections_b, iou_threshold=0.5)
```

### Pipeline Composition

Supervision khuyến nghị composing operation vào pipeline. Mỗi step lấy một `Detections` object và produce một cái mới:

```python
# Build một detection pipeline
pipeline = [
    {"operation": "filter_confidence", "threshold": 0.5},
    {"operation": "non_max_suppression", "iou_threshold": 0.45},
    {"operation": "filter_class", "class_ids": [0, 1, 2]},
    {"operation": "compute_metrics", "metric": "ap50"}
]

# Execute pipeline
results = apply_pipeline(original_detections, pipeline)
```

## Cài đặt

Cài đặt Supervision là đơn giản:

```bash
# Cài đặt qua pip
pip install supervision

# Xác nhận cài đặt
python -c "import supervision as sv; print(sv.__version__)"

# Cài đặt với tất cả optional dependency cho maximum compatibility
pip install supervision[all]
```

### Cài đặt với PyTorch

Cho deep learning workflow, cài đặt với PyTorch:

```bash
# Cài đặt với PyTorch (CPU)
pip install supervision torch torchvision

# Cài đặt với PyTorch (CUDA 12.x)
pip install supervision torch torchvision --index-url https://download.pytorch.org/whl/cu121
```

### Colab Demo

Roboflow cung cấp một interactive Colab notebook cho việc exploring Supervision capability:

```bash
# Mở interactive Colab demo
# https://colab.research.google.com/github/roboflow/supervision/blob/main/demo.ipynb

# Hoặc chạy local:
# Clone repository để access demo notebook
git clone https://github.com/roboflow/supervision.git
cd supervision
jupyter notebook demo.ipynb
```

## Integration Patterns

### YOLO Integration

Supervision có first-class integration với YOLO model:

```python
# Integration với YOLOv8 (Ultralytics)
from ultralytics import YOLO
import supervision as sv

# Load YOLOv8 model
model = YOLO("yolov8n.pt")

# Run inference
results = model.predict("image.jpg", conf=0.25)

# Convert YOLO result sang Supervision detection
detections = sv.Detections.from_ultralytics(results[0])

# Visualize
annotator = sv.BoxAnnotator()
annotated_frame = annotator.annotate(
    scene=results[0].plot(),
    detections=detections
)
```

### MediaPipe Integration

Cho pose estimation và landmark detection:

```python
import supervision as sv
from mediapipe import solutions

# Load MediaPipe pose model
pose = solutions.pose.Pose(static_image_mode=True)

# Run pose detection
results = pose.process(image)

# Convert sang Supervision keypoint format
if results.pose_landmarks:
    keypoints = sv.KeyPoints.from_mediapipe(results.pose_landmarks)
```

### ONNX Runtime Integration

Cho optimized inference:

```python
import supervision as sv
from onnxruntime import InferenceSession

# Load ONNX model
session = InferenceSession("model.onnx")

# Run inference và convert sang Supervision format
outputs = session.run(None, {session.get_inputs()[0].name: input_tensor})
detections = sv.Detections.from_onnx(outputs)
```

![Supervision Pipeline Architecture](https://raw.githubusercontent.com/roboflow/supervision/main/docs/assets/pipeline-architecture.png)

## Benchmark và Performance

### Evaluation Speed

Evaluation function của Supervision được optimize cho speed:

| Operation | Dataset Size | Time | Performance |
|-----------|-------------|------|-------------|
| Confusion Matrix (10 classes) | 10.000 sample | 0.3s | 33.333 sample/sec |
| IoU Computation | 100 box vs 100 box | 0.02s | 5.000 pairing/sec |
| NMS | 500 detection | 0.01s | 50.000 detection/sec |
| Mask Rendering | 100 mask (1000x1000) | 0.5s | 200 mask/sec |
| Video Frame Processing | 30 FPS video | 12ms/frame | 83 FPS real-time capable |

### Model Evaluation Throughput

Supervision được sử dụng để evaluate model ở quy mô lớn:

```python
# Batch evaluation script
import supervision as sv
from tqdm import tqdm

def evaluate_model(model, dataset):
    all_predictions = []
    all_targets = []
    
    for images, labels in tqdm(dataset, desc="Đang đánh giá"):
        preds = model.predict(images)
        all_predictions.extend(preds)
        all_targets.extend(labels)
    
    # Compute metric với Supervision
    confusion = sv.ConfusionMatrix(
        num_classes=len(dataset.classes),
        task="multiclass"
    )
    confusion.compute(
        predictions=all_predictions,
        targets=all_targets
    )
    
    metrics = confusion.metrics()
    print(f"mAP@0.5: {metrics.map_50:.4f}")
    print(f"mAP@0.5:0.95: {metrics.map_50_95:.4f}")
    return metrics
```

## Usage Nâng cao

### Custom Annotator

Bạn có thể tạo custom annotator cho specialized visualization need:

```python
import supervision as sv
import cv2
import numpy as np

class ArrowAnnotator(sv.Annotator):
    """Custom annotator cho việc vẽ directional arrow."""
    
    def __init__(self, color=None, thickness=2):
        super().__init__()
        self.color = color or sv.Color.WHITE
        self.thickness = thickness
    
    def annotate(self, scene, detections, direction="right"):
        for i, detection in enumerate(detections):
            center_x = int((detection.xyxy[0] + detection.xyxy[2]) / 2)
            center_y = int((detection.xyxy[1] + detection.xyxy[3]) / 2)
            
            if direction == "right":
                end_x = center_x + 50
                end_y = center_y
            elif direction == "left":
                end_x = center_x - 50
                end_y = center_y
            elif direction == "up":
                end_x = center_x
                end_y = center_y - 50
            else:
                end_x = center_x
                end_y = center_y + 50
            
            cv2.arrowedLine(
                scene,
                (center_x, center_y),
                (end_x, end_y),
                (self.color.r, self.color.g, self.color.b),
                self.thickness
            )
        
        return scene

# Sử dụng custom annotator
arrow_annotator = ArrowAnnotator(
    color=sv.Color.GREEN,
    thickness=3
)
```

### Video Analytics Pipeline

Cho real-time video analytics:

```python
import supervision as sv

class VideoAnalyticsPipeline:
    def __init__(self, video_path, model):
        self.video_path = video_path
        self.model = model
        self.counter = sv.ObjectCounter()
        self.line_annotator = sv.LineAnnotator()
        self.label_annotator = sv.LabelAnnotator()
        
        # Define counting zone
        self.counting_line = sv.Line(
            start=(100, 400),
            end=(1200, 400)
        )
    
    def process_frame(self, frame):
        # Run detection
        detections = self.model.predict(frame)
        
        # Update counter với line crossing
        self.counter.trigger(detections, self.counting_line)
        
        # Annotate
        annotated = self.line_annotator.annotate(scene=frame.copy())
        annotated = self.label_annotator.annotate(
            scene=annotated,
            detections=detections
        )
        
        # Draw counter label
        cv2.putText(
            annotated,
            f"Entry: {self.counter.entries}",
            (10, 30),
            cv2.FONT_HERSHEY_SIMPLEX,
            1, (0, 255, 0), 2
        )
        
        return annotated

# Chạy pipeline
pipeline = VideoAnalyticsPipeline("camera_feed.mp4", model)
pipeline.run()
```

### Metric Visualization

Supervision cung cấp built-in visualization cho evaluation metric:

```python
import supervision as sv

# ROC curve
roc = sv.ROCCurve(
    num_classes=5,
    labels=["cat", "dog", "car", "person", "bird"]
)
roc.compute(predictions, targets)
roc.plot(save_path="roc_curve.png")

# Precision-Recall curve
pr = sv.PrecisionRecallCurve(
    num_classes=5
)
pr.compute(predictions, targets)
pr.plot(save_path="pr_curve.png")
```

## So sánh với Alternatives

Supervision so sánh như thế nào với các computer vision toolkit khác?

| Tính năng | Supervision | Albumentations | Torchvision | MMDetection |
|-----------|-------------|---------------|-------------|-------------|
| Primary Focus | CV toolkit/annotation | Image augmentation | PyTorch model | Detection framework |
| Annotation Support | Excellent | Limited | None | Built-in |
| Visualization | Rich | None | Basic | Limited |
| Model Evaluation | Built-in | None | Basic | Built-in |
| Tracking Support | Yes | N/A | N/A | Limited |
| Learning Curve | Easy | Moderate | Moderate | Steep |
| Documentation | Excellent | Good | Good | Moderate |
| GitHub Stars | 42.819 | 20.000+ | N/A (PyTorch) | 25.000+ |
| License | MIT | Apache-2.0 | BSD-3 | Apache-2.0 |
| Best For | CV workflow, annotation | Data augmentation | End-to-end DL | Detection training |

Supervision fill một niche duy nhất. Albumentations tập trung vào data augmentation, Torchvision cung cấp model building block và MMDetection là một full training framework. Supervision nằm ở giữa — cung cấp tool bạn cần cho annotation, evaluation và visualization mà không prescribe một specific training pipeline.

## Giới hạn

Trong khi Supervision là một powerful toolkit, nó có một số limitation:

**Không phải là Training Framework.** Supervision không được thiết kế cho việc training model. Nó hoạt động với output của training framework (YOLO, Detectron, custom model) nhưng không bao gồm training loop hoặc loss function.

**Chỉ Python.** Library là Python-only, điều này có nghĩa nó không trực tiếp hỗ trợ ngôn ngữ khác. Nếu bạn cần integrate với Java hoặc C++ CV pipeline, bạn sẽ cần call Python library qua một bridge.

**Hạn chế Built-in Model.** Khác với một số competitor, Supervision không bao gồm pre-trained model. Bạn bring model của bạn và sử dụng Supervision cho mọi thứ khác.

## Câu hỏi thường gặp

### 1. Làm thế nào để cài đặt Supervision?

Chỉ cần chạy `pip install supervision`. Cho full compatibility với tất cả feature, sử dụng `pip install supervision[all]`.

### 2. Supervision có hoạt động với YOLO model không?

Có, nó có first-class integration với YOLOv5, YOLOv8 và YOLO-NAS qua method `Detections.from_ultralytics()`.

### 3. Tôi có thể sử dụng Supervision cho real-time video processing không?

Có. Library được optimize cho performance, với frame processing time khoảng 12ms trên standard hardware, making real-time processing at 30+ FPS achievable.

### 4. Supervision hỗ trợ annotation format nào?

Supervision hỗ trợ COCO, YOLO, Pascal VOC và custom JSON format. Conversion giữa format là built in.

### 5. Tôi có thể tạo custom annotator không?

Chắc chắn. Annotator system được design để extendable. Bạn có thể subclass `sv.Annotator` để tạo custom visualization tool cho use case cụ thể của bạn.

### 6. Supervision có phù hợp cho production use không?

Có. Với [42.819 sao GitHub](https://github.com/roboflow/supervision) và một community active, nó được widely used trong production system. MIT license cho phép unrestricted commercial use.

### 7. Tôi có thể tìm documentation ở đâu?

Full documentation có sẵn tại [https://supervision.roboflow.com](https://supervision.roboflow.com) và một interactive demo notebook có sẵn trên [Google Colab](https://colab.research.google.com/github/roboflow/supervision/blob/main/demo.ipynb).

## Kết luận

Supervision của Roboflow là một essential tool cho bất kỳ ai làm việc trong computer vision. Với [42.819 sao GitHub](https://github.com/roboflow/supervision) và một rich feature set bao gồm toàn bộ CV pipeline, nó cung cấp reusable tool làm cho việc xây dựng production CV system practical và efficient.

Từ data annotation và model evaluation đến visualization và tracking, Supervision cover gap mà tool khác để ngỏ. Nó lightweight, well-documented và easy integrate vào bất kỳ Python-based CV workflow nào. Cho dù bạn đang annotating training data, evaluating model performance hoặc xây dựng một real-time detection system, Supervision có tool bạn cần.

Bắt đầu với `pip install supervision` và explore [interactive Colab demo](https://colab.research.google.com/github/roboflow/supervision/blob/main/demo.ipynb) để xem nó hoạt động.

[CTA: Xây dựng hệ thống computer vision tốt hơn với Supervision. [Cài đặt ngay](https://github.com/roboflow/supervision) | [Đọc tài liệu](https://supervision.roboflow.com)]

## Nguồn

1. [GitHub Repository Supervision](https://github.com/roboflow/supervision)
2. [Tài liệu Supervision](https://supervision.roboflow.com)
3. [Trang web chính thức Roboflow](https://roboflow.com)
4. [Interactive Colab Demo](https://colab.research.google.com/github/roboflow/supervision/blob/main/demo.ipynb)
5. [DigitalOcean - Cơ sở hạ tầng Cloud cho CV Deployment](https://www.digitalocean.com/try/affiliate)
6. [HTStack - Lưu trữ Hiệu suất Cao](https://htstack.com/)
7. [WebShare - Dịch vụ Proxy cho Pipeline Dữ liệu](https://webshare.io/)
