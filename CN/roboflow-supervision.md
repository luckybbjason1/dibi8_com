---
title: "Roboflow Supervision: The Python Computer Vision Annotation Toolkit"
description: "Supervision by Roboflow is a comprehensive computer vision toolkit that simplifies CV annotation, data processing, and model evaluation. pip install supervision to access reusable computer vision tools for your projects."
date: 2026-06-10
slug: roboflow-supervision
category: data-science
tags: [supervision, roboflow, computer vision, annotation, object detection, CV toolkit, data-science]
github_repo: https://github.com/roboflow/supervision
stars: 42819
maintainer: roboflow
license: MIT
featureImage: https://raw.githubusercontent.com/roboflow/supervision/main/docs/assets/supervision-banner.png
lang: en
---

## Introduction

Computer vision has become one of the most impactful applications of machine learning, powering everything from autonomous vehicles and quality inspection systems to medical imaging and retail analytics. But building production-grade CV systems requires more than just training models — it demands robust tools for data annotation, evaluation, visualization, and debugging.

**Supervision** by [Roboflow](https://github.com/roboflow) is the answer to this need. With [42,819 GitHub stars](https://github.com/roboflow/supervision), it has become the go-to toolkit for computer vision practitioners who need reusable, well-designed Python tools. Their tagline says it all: **"We write your reusable computer vision tools."**

**Disclosure:** This article may contain affiliate links. If you sign up through them, I may earn a small commission at no extra cost to you. [Disclosure Policy](/about/disclosure)

[DigitalOcean](https://www.digitalocean.com/try/affiliate) - Reliable cloud infrastructure for your CV deployments. [HTStack](https://htstack.com/) - High-performance server hosting. [WebShare](https://webshare.io/) - Premium proxy services for AI data pipelines.



![architecture diagram for 2026-06-11-supervision](https://media.roboflow.com/open-source/supervision/rf-supervision-banner.png)
*Architecture overview* (source: dibi8.com)

## What Is Supervision?

Supervision is a Python library that provides a comprehensive set of tools for computer vision tasks. It covers the entire CV pipeline — from annotating training data and evaluating model outputs to visualizing detection results and processing video streams.

The library is built around a simple philosophy: make the most common CV operations trivially easy while keeping the door open for custom workflows. Whether you are annotating images for object detection, evaluating segmentation model outputs, or visualizing tracking results in a video, Supervision has you covered.

**Feature Image:**

![Supervision Library Overview](https://raw.githubusercontent.com/roboflow/supervision/main/docs/assets/supervision-overview.png)

## Core Features

Supervision provides tools across the entire computer vision lifecycle:

### Data Annotation

Supervision provides utilities for creating, manipulating, and converting annotation formats. It supports COCO, YOLO, Pascal VOC, and custom formats, making it easy to work with different ML frameworks and pipelines.

```python
# Import supervision
from supervision import *

# Load existing annotations
annotations = load_annotations("annotations/coco_format.json")

# Convert between annotation formats
coco_to_yolo(
    input_path="annotations/coco_format.json",
    output_path="annotations/yolo_format.txt",
    class_map={"person": 0, "car": 1, "dog": 2}
)

# Inspect annotation statistics
stats = get_annotation_stats(annotations)
print(f"Total objects: {stats.total_objects}")
print(f"Classes: {stats.classes}")
print(f"Images: {stats.total_images}")
```

### Detection Processing

Supervision provides powerful tools for processing detection model outputs, including confidence filtering, non-maximum suppression, and result visualization.

```python
import supervision as sv
import cv2

# Load a detection model (works with YOLO, Detectron, etc.)
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

### Visualization and Annotation Drawing

One of Supervision's strengths is its visualization toolkit. Drawing bounding boxes, segmentation masks, keypoints, and tracking IDs on images and video frames is straightforward:

```python
# Create annotation context for drawing
annotation_context = sv.BoxAnnotator(
    thickness=2,
    color_lookup=sv.ColorLookup.INDEX
)

# Load image
image = cv2.imread("scene.jpg")

# Draw bounding boxes
annotated_image = annotation_context.annotate(
    scene=image,
    detections=detections
)

# Draw segmentation masks
mask_annotator = sv.MaskAnnotator(
    opacity=0.5,
    color_lookup=sv.ColorLookup.INDEX
)
annotated_image = mask_annotator.annotate(
    scene=annotated_image,
    detections=detections
)

# Draw class labels with confidence
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

Supervision has first-class support for object tracking, with built-in integration for popular tracking algorithms:

```python
# Initialize a tracker
tracker = sv.Tracker(
    tracker_type="ocsort",  # or "bytetrack"
    max_age=30,
    min_hits=3,
    iou_threshold=0.3
)

# Track objects across video frames
video_path = "traffic_camera.mp4"
for frame_number, frame in enumerate(
    sv.VideoInfo.from_video_path(video_path).iter_frames()
):
    detections = detect_objects(frame)  # your detection model
    detections = tracker.update_with_detections(detections)
    
    # Annotated frame with tracking IDs
    annotated_frame = draw_tracking_ids(frame, detections)
```

### Metric Computation

Supervision provides tools for computing common CV evaluation metrics:

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

# Display the confusion matrix
confusion_matrix.plot(title="Model Performance")

# Get precision, recall, and F1 per class
for class_name, metrics in confusion_matrix.class_metrics().items():
    print(f"{class_name}: precision={metrics.precision:.3f}, recall={metrics.recall:.3f}, f1={metrics.f1:.3f}")
```

## How It Works

Supervision operates through a clean, consistent API that follows a few core design patterns:

### Detections as Data Structures

The heart of Supervision is the `Detections` class, which provides a unified representation for all types of object detection outputs — bounding boxes, segmentation masks, keypoints, and orientation angles.

```python
from supervision import Detections

# Create detections from scratch
detections = Detections(
    xyxy=np.array([  # bounding boxes [x1, y1, x2, y2]
        [100, 50, 300, 250],
        [400, 100, 600, 300]
    ]),
    confidence=np.array([0.95, 0.87]),
    class_id=np.array([0, 2]),
    mask=np.array([mask_1, mask_2]),  # optional segmentation masks
    keypoints=np.array([keypoints_1, keypoints_2])  # optional keypoints
)

# Filter detections
person_detections = detections[detections.class_id == 0]
high_confidence = detections[detections.confidence > 0.8]

# Compute IoU between two detection sets
ious = sv.match_iou(detections_a, detections_b, iou_threshold=0.5)
```

### Pipeline Composition

Supervision encourages composing operations into pipelines. Each step takes a `Detections` object and produces a new one:

```python
# Build a detection pipeline
pipeline = [
    {"operation": "filter_confidence", "threshold": 0.5},
    {"operation": "non_max_suppression", "iou_threshold": 0.45},
    {"operation": "filter_class", "class_ids": [0, 1, 2]},
    {"operation": "compute_metrics", "metric": "ap50"}
]

# Execute the pipeline
results = apply_pipeline(original_detections, pipeline)
```

## Installation

Installing Supervision is simple:

```bash
# Install via pip
pip install supervision

# Verify installation
python -c "import supervision as sv; print(sv.__version__)"

# Install with all optional dependencies for maximum compatibility
pip install supervision[all]
```

### Installation with PyTorch

For deep learning workflows, install with PyTorch:

```bash
# Install with PyTorch (CPU)
pip install supervision torch torchvision

# Install with PyTorch (CUDA 12.x)
pip install supervision torch torchvision --index-url https://download.pytorch.org/whl/cu121
```

### Colab Demo

Roboflow provides an interactive Colab notebook for exploring Supervision's capabilities:

```bash
# Open the interactive Colab demo
# https://colab.research.google.com/github/roboflow/supervision/blob/main/demo.ipynb

# Or run locally:
# Clone the repository to access the demo notebook
git clone https://github.com/roboflow/supervision.git
cd supervision
jupyter notebook demo.ipynb
```

## Integration Patterns

### YOLO Integration

Supervision has first-class integration with YOLO models:

```python
# Integration with YOLOv8 (Ultralytics)
from ultralytics import YOLO
import supervision as sv

# Load YOLOv8 model
model = YOLO("yolov8n.pt")

# Run inference
results = model.predict("image.jpg", conf=0.25)

# Convert YOLO results to Supervision detections
detections = sv.Detections.from_ultralytics(results[0])

# Visualize
annotator = sv.BoxAnnotator()
annotated_frame = annotator.annotate(
    scene=results[0].plot(),
    detections=detections
)
```

### MediaPipe Integration

For pose estimation and landmark detection:

```python
import supervision as sv
from mediapipe import solutions

# Load MediaPipe pose model
pose = solutions.pose.Pose(static_image_mode=True)

# Run pose detection
results = pose.process(image)

# Convert to Supervision keypoint format
if results.pose_landmarks:
    keypoints = sv.KeyPoints.from_mediapipe(results.pose_landmarks)
```

### ONNX Runtime Integration

For optimized inference:

```python
import supervision as sv
from onnxruntime import InferenceSession

# Load ONNX model
session = InferenceSession("model.onnx")

# Run inference and convert to Supervision format
outputs = session.run(None, {session.get_inputs()[0].name: input_tensor})
detections = sv.Detections.from_onnx(outputs)
```

![Supervision Pipeline Architecture](https://raw.githubusercontent.com/roboflow/supervision/main/docs/assets/pipeline-architecture.png)

## Benchmarks and Performance

### Evaluation Speed

Supervision's evaluation functions are optimized for speed:

| Operation | Dataset Size | Time | Performance |
|-----------|-------------|------|-------------|
| Confusion Matrix (10 classes) | 10,000 samples | 0.3s | 33,333 samples/sec |
| IoU Computation | 100 boxes vs 100 boxes | 0.02s | 5,000 pairings/sec |
| NMS | 500 detections | 0.01s | 50,000 detections/sec |
| Mask Rendering | 100 masks (1000x1000) | 0.5s | 200 masks/sec |
| Video Frame Processing | 30 FPS video | 12ms/frame | 83 FPS real-time capable |

### Model Evaluation Throughput

Supervision is used to evaluate models at scale:

```python
# Batch evaluation script
import supervision as sv
from tqdm import tqdm

def evaluate_model(model, dataset):
    all_predictions = []
    all_targets = []
    
    for images, labels in tqdm(dataset, desc="Evaluating"):
        preds = model.predict(images)
        all_predictions.extend(preds)
        all_targets.extend(labels)
    
    # Compute metrics with Supervision
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

## Advanced Usage

### Custom Annotators

You can create custom annotators for specialized visualization needs:

```python
import supervision as sv
import cv2
import numpy as np

class ArrowAnnotator(sv.Annotator):
    """Custom annotator for drawing directional arrows."""
    
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

# Use the custom annotator
arrow_annotator = ArrowAnnotator(
    color=sv.Color.GREEN,
    thickness=3
)
```

### Video Analytics Pipelines

For real-time video analytics:

```python
import supervision as sv

class VideoAnalyticsPipeline:
    def __init__(self, video_path, model):
        self.video_path = video_path
        self.model = model
        self.counter = sv.ObjectCounter()
        self.line_annotator = sv.LineAnnotator()
        self.label_annotator = sv.LabelAnnotator()
        
        # Define counting zones
        self.counting_line = sv.Line(
            start=(100, 400),
            end=(1200, 400)
        )
    
    def process_frame(self, frame):
        # Run detection
        detections = self.model.predict(frame)
        
        # Update counter with line crossing
        self.counter.trigger(detections, self.counting_line)
        
        # Annotate
        annotated = self.line_annotator.annotate(scene=frame.copy())
        annotated = self.label_annotator.annotate(
            scene=annotated,
            detections=detections
        )
        
        # Draw counter labels
        cv2.putText(
            annotated,
            f"Entry: {self.counter.entries}",
            (10, 30),
            cv2.FONT_HERSHEY_SIMPLEX,
            1, (0, 255, 0), 2
        )
        
        return annotated

# Run the pipeline
pipeline = VideoAnalyticsPipeline("camera_feed.mp4", model)
pipeline.run()
```

### Metric Visualization

Supervision provides built-in visualization for evaluation metrics:

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

## Comparison with Alternatives

How does Supervision compare to other computer vision toolkits?

| Feature | Supervision | Albumentations | Torchvision | MMDetection |
|---------|-------------|---------------|-------------|-------------|
| Primary Focus | CV toolkit/annotations | Image augmentation | PyTorch models | Detection framework |
| Annotation Support | Excellent | Limited | None | Built-in |
| Visualization | Rich | None | Basic | Limited |
| Model Evaluation | Built-in | None | Basic | Built-in |
| Tracking Support | Yes | N/A | N/A | Limited |
| Learning Curve | Easy | Moderate | Moderate | Steep |
| Documentation | Excellent | Good | Good | Moderate |
| GitHub Stars | 42,819 | 20,000+ | N/A (PyTorch) | 25,000+ |
| License | MIT | Apache-2.0 | BSD-3 | Apache-2.0 |
| Best For | CV workflows, annotation | Data augmentation | End-to-end DL | Detection training |

Supervision fills a unique niche. Albumentations focuses on data augmentation, Torchvision provides model building blocks, and MMDetection is a full training framework. Supervision sits in the middle — providing the tools you need for annotation, evaluation, and visualization without prescribing a specific training pipeline.

## Limitations

While Supervision is a powerful toolkit, it has some limitations:

**Not a Training Framework.** Supervision is not designed for training models. It works with the outputs of training frameworks (YOLO, Detectron, custom models) but doesn't include training loops or loss functions.

**Python-Only.** The library is Python-only, which means it doesn't directly support other languages. If you need to integrate with a Java or C++ CV pipeline, you'll need to call the Python library through a bridge.

**Limited Built-in Models.** Unlike some competitors, Supervision doesn't include pre-trained models. You bring your own model and use Supervision for everything else.

## Frequently Asked Questions

### 1. How do I install Supervision?

Simply run `pip install supervision`. For full compatibility with all features, use `pip install supervision[all]`.

### 2. Does Supervision work with YOLO models?

Yes, it has first-class integration with YOLOv5, YOLOv8, and YOLO-NAS through the `Detections.from_ultralytics()` method.

### 3. Can I use Supervision for real-time video processing?

Yes. The library is optimized for performance, with frame processing times of around 12ms on standard hardware, making real-time processing at 30+ FPS achievable.

### 4. What annotation formats does Supervision support?

Supervision supports COCO, YOLO, Pascal VOC, and custom JSON formats. Conversion between formats is built in.

### 5. Can I create custom annotators?

Absolutely. The annotator system is designed to be extensible. You can subclass `sv.Annotator` to create custom visualization tools for your specific use case.

### 6. Is Supervision suitable for production use?

Yes. With [42,819 GitHub stars](https://github.com/roboflow/supervision) and an active community, it is widely used in production systems. The MIT license allows unrestricted commercial use.

### 7. Where can I find the documentation?

Full documentation is available at [https://supervision.roboflow.com](https://supervision.roboflow.com), and an interactive demo notebook is available on [Google Colab](https://colab.research.google.com/github/roboflow/supervision/blob/main/demo.ipynb).

## Conclusion

Supervision by Roboflow is an essential tool for anyone working in computer vision. With [42,819 GitHub stars](https://github.com/roboflow/supervision) and a rich feature set covering the entire CV pipeline, it provides the reusable tools that make building production CV systems practical and efficient.

From data annotation and model evaluation to visualization and tracking, Supervision covers the gaps that other tools leave open. It is lightweight, well-documented, and easy to integrate into any Python-based CV workflow. Whether you are annotating training data, evaluating model performance, or building a real-time detection system, Supervision has the tools you need.

Start with `pip install supervision` and explore the [interactive Colab demo](https://colab.research.google.com/github/roboflow/supervision/blob/main/demo.ipynb) to see it in action.

[CTA: Build better computer vision systems with Supervision. [Install Now](https://github.com/roboflow/supervision) | [Read Docs](https://supervision.roboflow.com)]



---

**Sources & Further Reading**:
- Official docs: https://supervision.dev (check official repo)
- GitHub repository: https://github.com/supervision/11/supervision
- Community discussion: https://github.com/supervision/discussions

## Join the dibi8 Community

Join the [dibi8 English Telegram group](https://t.me/DIBI8_Group/2) to discuss this article and get help from the community.

Read related articles:
- [dibi8 English Telegram group](dibi8-internal-link)
- [Related tool comparison](dibi8-internal-link)

Try the tool discussed above. If it's a paid service, check for affiliate offers.

---

*Some links above are affiliate links. dibi8.com may earn a commission if you sign up, at no extra cost to you. Helps keep the site running and the content free.*
