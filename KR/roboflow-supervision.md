---
title: "Roboflow Supervision: Python 컴퓨터 비전 주석 도구 모음"
description: "Roboflow의 Supervision은 CV 주석, 데이터 처리 및 모델 평가를 간소화하는 포괄적인 컴퓨터 비전 도구 모음입니다. pip install supervision을 사용하여 프로젝트에 재사용 가능한 컴퓨터 비전 도구에 액세스하세요."
date: 2026-06-10
slug: roboflow-supervision
category: data-science
tags: [supervision, roboflow, computer vision, annotation, object detection, CV toolkit, data-science]
github_repo: https://github.com/roboflow/supervision
stars: 42819
maintainer: roboflow
license: MIT
featureImage: https://raw.githubusercontent.com/roboflow/supervision/main/docs/assets/supervision-banner.png
lang: ko
---

## 소개

컴퓨터 비전은 자율 주행 자동차, 품질 검사 시스템부터 의료 이미징 및 리테일 분석에 이르기까지 모든 것을 가능하게 하는 머신러닝의 가장 영향력 있는 응용 분야 중 하나가 되었습니다. 하지만 프로덕션 등급 CV 시스템을 구축하는 데에는 모델 학습만으로는 부족합니다. 데이터 주석, 평가, 시각화 및 디버깅을 위한 강력한 도구가 필요합니다.

**Supervision**은 [Roboflow](https://github.com/roboflow)에서 제공하는 이 필요에 대한 답입니다. [42,819개의 GitHub star](https://github.com/roboflow/supervision)를 달성한 이 도구는 재사용 가능한 잘 설계된 Python 도구가 필요한 컴퓨터 비전 실무자에게 가장 선호되는 도구 모음이 되었습니다. 그들의 슬로건이 모든 것을 말해줍니다. **"우리는 당신의 재사용 가능한 컴퓨터 비전 도구를 작성합니다."**

**면책:** 이 artikel에는 제휴 링크가 포함될 수 있습니다. 이를 통해 가입하면 추가 비용 없이 소정의 수수료를 받을 수 있습니다. [면책 정책](/about/disclosure)

[DigitalOcean](https://www.digitalocean.com/try/affiliate) - CV 배포를 위한 신뢰할 수 있는 클라우드 인프라. [HTStack](https://htstack.com/) - 고성능 서버 호스팅. [WebShare](https://webshare.io/) - AI 데이터 파이프라인을 위한 프리미엄 프록시 서비스.

## Supervision이란?

Supervision은 컴퓨터 비전 작업을 위한 포괄적인 도구 세트를 제공하는 Python 라이브러리입니다. 훈련 데이터 주석 작성과 모델 출력 평가부터 탐지 결과 시각화 및 비디오 스트림 처리에 이르기까지 전체 CV 파이프라인을 다룹니다.

이 라이브러리는 단순한 철학을 바탕으로 구축되었습니다: 가장 일반적인 CV 작업을 매우 쉽게 만들면서도 사용자 정의 워크플로우를 위한 문은 열어둡니다. 객체 감지를 위해 이미지를 주석 작성하든, 분할 모델 출력을 평가하든, 비디오에서 추적 결과를 시각화하든, Supervision이 모든 것을 커버합니다.

**표지 이미지:**

![Supervision 라이브러리 개요](https://raw.githubusercontent.com/roboflow/supervision/main/docs/assets/supervision-overview.png)

## 핵심 기능

Supervision은 전체 컴퓨터 비전 수명 주기 전반에 걸쳐 도구를 제공합니다:

### 데이터 주석

Supervision은 주석 형식을 생성, 조작 및 변환하기 위한 유틸리티를 제공합니다. COCO, YOLO, Pascal VOC 및 사용자 정의 형식을 지원하여 다양한 ML 프레임워크 및 파이프라인과 쉽게 작업할 수 있습니다.

```python
# supervision import
from supervision import *

# 기존 주석 로드
annotations = load_annotations("annotations/coco_format.json")

# 주석 형식 간 변환
coco_to_yolo(
    input_path="annotations/coco_format.json",
    output_path="annotations/yolo_format.txt",
    class_map={"person": 0, "car": 1, "dog": 2}
)

# 주석 통계 검토
stats = get_annotation_stats(annotations)
print(f"Total objects: {stats.total_objects}")
print(f"Classes: {stats.classes}")
print(f"Images: {stats.total_images}")
```

### 탐지 처리

Supervision은 신뢰도 필터링, 비최대값 억제 및 결과 시각화를 포함한 탐지 모델 출력을 처리하기 위한 강력한 도구를 제공합니다.

```python
import supervision as sv
import cv2

# 탐지 모델 로드 (YOLO, Detectron 등 작동)
detections = sv.Detections.from_yolo_output(
    prediction,  # 모델 출력 텐서
    original_image_size,  # 이미지 크기
    confidence_threshold=0.5,
    class_id=0  # 클래스별 필터링
)

# 비최대값 억제 적용
detections = sv.NMS(detections, iou_threshold=0.45)

# 신뢰도로 필터링
detections = detections[detections.confidence > 0.6]
```

### 시각화 및 주석 그리기

Supervision의 강점 중 하나는 시각화 도구 모음입니다. 이미지 및 비디오 프레임에 bounding box, segmentation mask, keypoint 및 tracking ID를 그리는 것은 간단합니다:

```python
# 그리기용 annotation context 생성
annotation_context = sv.BoxAnnotator(
    thickness=2,
    color_lookup=sv.ColorLookup.INDEX
)

# 이미지 로드
image = cv2.imread("scene.jpg")

# bounding box 그리기
annotated_image = annotation_context.annotate(
    scene=image,
    detections=detections
)

# segmentation mask 그리기
mask_annotator = sv.MaskAnnotator(
    opacity=0.5,
    color_lookup=sv.ColorLookup.INDEX
)
annotated_image = mask_annotator.annotate(
    scene=annotated_image,
    detections=detections
)

# 신뢰도 있는 class label 그리기
label_annotator = sv.LabelAnnotator(
    text_scale=0.5,
    text_thickness=1,
    color_lookup=sv.ColorLookup.INDEX
)
annotated_image = label_annotator.annotate(
    scene=annotated_image,
    detections=detections
)

# 결과 저장
cv2.imwrite("annotated_scene.jpg", annotated_image)
```

### 추적 지원

Supervision은 인기 있는 추적 알고리즘에 대한 내장 통합을 갖춘 object tracking에 대한 first-class 지원을 제공합니다:

```python
# tracker 초기화
tracker = sv.Tracker(
    tracker_type="ocsort",  # 또는 "bytetrack"
    max_age=30,
    min_hits=3,
    iou_threshold=0.3
)

# 비디오 프레임 전체에서 object 추적
video_path = "traffic_camera.mp4"
for frame_number, frame in enumerate(
    sv.VideoInfo.from_video_path(video_path).iter_frames()
):
    detections = detect_objects(frame)  # 사용자의 탐지 모델
    detections = tracker.update_with_detections(detections)
    
    # tracking ID가 있는 주석이 달린 프레임
    annotated_frame = draw_tracking_ids(frame, detections)
```

### 메트릭 계산

Supervision은 일반적인 CV 평가 메트릭을 계산하기 위한 도구를 제공합니다:

```python
# confusion matrix 계산
confusion_matrix = sv.ConfusionMatrix(
    num_classes=10,
    task="multiclass"
)
confusion_matrix.compute(
    predictions=predicted_labels,
    targets=ground_truth_labels
)

# confusion matrix 표시
confusion_matrix.plot(title="Model Performance")

# 클래스별 precision, recall 및 F1 가져오기
for class_name, metrics in confusion_matrix.class_metrics().items():
    print(f"{class_name}: precision={metrics.precision:.3f}, recall={metrics.recall:.3f}, f1={metrics.f1:.3f}")
```

## 동작 방식

Supervision은 몇 가지 핵심 디자인 패턴을 따르는 깔끔하고 일관된 API를 통해 동작합니다:

### Detections을 데이터 구조로

Supervision의 핵심은 `Detections` 클래스로, 모든 유형의 객체 탐지 출력에 대한 통합 표현을 제공합니다 — bounding box, segmentation mask, keypoint 및 방향 각도.

```python
from supervision import Detections

# 처음부터 detection 생성
detections = Detections(
    xyxy=np.array([  # bounding box [x1, y1, x2, y2]
        [100, 50, 300, 250],
        [400, 100, 600, 300]
    ]),
    confidence=np.array([0.95, 0.87]),
    class_id=np.array([0, 2]),
    mask=np.array([mask_1, mask_2]),  # 선택적 segmentation mask
    keypoints=np.array([keypoints_1, keypoints_2])  # 선택적 keypoint
)

# detection 필터링
person_detections = detections[detections.class_id == 0]
high_confidence = detections[detections.confidence > 0.8]

# 두 detection set 간 IoU 계산
ious = sv.match_iou(detections_a, detections_b, iou_threshold=0.5)
```

### 파이프라인 구성

Supervision은 작업을 파이프라인으로 composition하도록 권장합니다. 각 단계는 `Detections` 객체를 가져오고 새 객체를 생성합니다:

```python
# 탐지 파이프라인 빌드
pipeline = [
    {"operation": "filter_confidence", "threshold": 0.5},
    {"operation": "non_max_suppression", "iou_threshold": 0.45},
    {"operation": "filter_class", "class_ids": [0, 1, 2]},
    {"operation": "compute_metrics", "metric": "ap50"}
]

# 파이프라인 실행
results = apply_pipeline(original_detections, pipeline)
```

## 설치

Supervision 설치는 간단합니다:

```bash
# pip로 설치
pip install supervision

# 설치 검증
python -c "import supervision as sv; print(sv.__version__)"

# 최대 호환성을 위해 모든 선택적 의존성과 함께 설치
pip install supervision[all]
```

### PyTorch와 함께 설치

딥러닝 워크플로우를 위해 PyTorch와 함께 설치하세요:

```bash
# PyTorch로 설치 (CPU)
pip install supervision torch torchvision

# PyTorch로 설치 (CUDA 12.x)
pip install supervision torch torchvision --index-url https://download.pytorch.org/whl/cu121
```

### Colab 데모

Roboflow는 Supervision의 기능을 탐색하기 위한 대화형 Colab 노트북을 제공합니다:

```bash
# 대화형 Colab 데모 열기
# https://colab.research.google.com/github/roboflow/supervision/blob/main/demo.ipynb

# 또는 로컬에서 실행:
# 데모 노트북에 접근하기 위해 repository clone
git clone https://github.com/roboflow/supervision.git
cd supervision
jupyter notebook demo.ipynb
```

## 통합 패턴

### YOLO 통합

Supervision은 YOLO 모델과 first-class 통합을 제공합니다:

```python
# YOLOv8 (Ultralytics) 통합
from ultralytics import YOLO
import supervision as sv

# YOLOv8 모델 로드
model = YOLO("yolov8n.pt")

# 추론 실행
results = model.predict("image.jpg", conf=0.25)

# YOLO 결과를 Supervision detection으로 변환
detections = sv.Detections.from_ultralytics(results[0])

# 시각화
annotator = sv.BoxAnnotator()
annotated_frame = annotator.annotate(
    scene=results[0].plot(),
    detections=detections
)
```

### MediaPipe 통합

_pose estimation 및 landmark detection을 위해:_

```python
import supervision as sv
from mediapipe import solutions

# MediaPipe pose 모델 로드
pose = solutions.pose.Pose(static_image_mode=True)

# pose detection 실행
results = pose.process(image)

# Supervision keypoint 형식으로 변환
if results.pose_landmarks:
    keypoints = sv.KeyPoints.from_mediapipe(results.pose_landmarks)
```

### ONNX Runtime 통합

최적화된 추론을 위해:

```python
import supervision as sv
from onnxruntime import InferenceSession

# ONNX 모델 로드
session = InferenceSession("model.onnx")

# 추론 실행 및 Supervision 형식으로 변환
outputs = session.run(None, {session.get_inputs()[0].name: input_tensor})
detections = sv.Detections.from_onnx(outputs)
```

![Supervision 파이프라인 아키텍처](https://raw.githubusercontent.com/roboflow/supervision/main/docs/assets/pipeline-architecture.png)

## 벤치마크 및 성능

### 평가 속도

Supervision의 평가 함수는 속도에 최적화되어 있습니다:

| 작업 | 데이터셋 크기 | 시간 | 성능 |
|------|-------------|------|------|
| Confusion Matrix (10 classes) | 10,000 samples | 0.3초 | 33,333 samples/sec |
| IoU 계산 | 100 box vs 100 box | 0.02초 | 5,000 pairings/sec |
| NMS | 500 detections | 0.01초 | 50,000 detections/sec |
| Mask 렌더링 | 100 mask (1000x1000) | 0.5초 | 200 mask/sec |
| 비디오 프레임 처리 | 30 FPS video | 12ms/frame | 83 FPS 실시간 가능 |

### 모델 평가 처리량

Supervision은 대규모로 모델을 평가하는 데 사용됩니다:

```python
# 배치 평가 스크립트
import supervision as sv
from tqdm import tqdm

def evaluate_model(model, dataset):
    all_predictions = []
    all_targets = []
    
    for images, labels in tqdm(dataset, desc="Evaluating"):
        preds = model.predict(images)
        all_predictions.extend(preds)
        all_targets.extend(labels)
    
    # Supervision으로 메트릭 계산
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

## 고급 사용

### 사용자 정의 Annotator

전문화된 시각화 필요에 대해 사용자 정의 annotator를 생성할 수 있습니다:

```python
import supervision as sv
import cv2
import numpy as np

class ArrowAnnotator(sv.Annotator):
    """방향 화살표 그리기 위한 사용자 정의 annotator."""
    
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

# 사용자 정의 annotator 사용
arrow_annotator = ArrowAnnotator(
    color=sv.Color.GREEN,
    thickness=3
)
```

### 비디오 분석 파이프라인

실시간 비디오 분석을 위해:

```python
import supervision as sv

class VideoAnalyticsPipeline:
    def __init__(self, video_path, model):
        self.video_path = video_path
        self.model = model
        self.counter = sv.ObjectCounter()
        self.line_annotator = sv.LineAnnotator()
        self.label_annotator = sv.LabelAnnotator()
        
        # 카운팅 zone 정의
        self.counting_line = sv.Line(
            start=(100, 400),
            end=(1200, 400)
        )
    
    def process_frame(self, frame):
        # 탐지 실행
        detections = self.model.predict(frame)
        
        # line crossing로 counter 업데이트
        self.counter.trigger(detections, self.counting_line)
        
        # 주석 달기
        annotated = self.line_annotator.annotate(scene=frame.copy())
        annotated = self.label_annotator.annotate(
            scene=annotated,
            detections=detections
        )
        
        # counter label 그리기
        cv2.putText(
            annotated,
            f"Entry: {self.counter.entries}",
            (10, 30),
            cv2.FONT_HERSHEY_SIMPLEX,
            1, (0, 255, 0), 2
        )
        
        return annotated

# 파이프라인 실행
pipeline = VideoAnalyticsPipeline("camera_feed.mp4", model)
pipeline.run()
```

### 메트릭 시각화

Supervision은 평가 메트릭에 대한 내장 시각화를 제공합니다:

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

## 대안과의 비교

Supervision은 다른 컴퓨터 비전 도구 모음과 어떻게 비교됩니까?

| 기능 | Supervision | Albumentations | Torchvision | MMDetection |
|------|-------------|---------------|-------------|-------------|
| 주요 초점 | CV 도구/주석 | 이미지 증강 | PyTorch 모델 | 탐지 프레임워크 |
| 주석 지원 | 우수 | 제한적 | 없음 | 내장 |
| 시각화 | 풍부 | 없음 | 기본 | 제한적 |
| 모델 평가 | 내장 | 없음 | 기본 | 내장 |
| 추적 지원 | 예 | N/A | N/A | 제한적 |
| 학습 곡선 | 쉬움 | 보통 | 보통 | 가파름 |
| 문서 | 우수 | 좋음 | 좋음 | 보통 |
| GitHub Star | 42,819 | 20,000+ | N/A (PyTorch) | 25,000+ |
| License | MIT | Apache-2.0 | BSD-3 | Apache-2.0 |
| 최적 용도 | CV 워크플로우, 주석 | 데이터 증강 | 엔드투엔드 DL | 탐지 학습 |

Supervision은 독특한 niche을 채웁니다. Albumentations는 데이터 증강에, Torchvision은 모델 빌드 블록을, MMDetection은 전체 학습 프레임워크에 중점을 둡니다. Supervision은 중간에 위치하여 — 특정 학습 파이프라인을 규정하지 않고 주석, 평가 및 시각화에 필요한 도구를 제공합니다.

## 제한 사항

Supervision은 강력한 도구 모음이지만 몇 가지 제한 사항이 있습니다:

**학습 프레임워크가 아님.** Supervision은 모델 학습을 위해 설계되지 않았습니다. 학습 프레임워크(YOLO, Detectron, 사용자 정의 모델)의 출력과 함께 작동하지만 학습 루프 또는 loss function을 포함하지 않습니다.

**Python 전용.** 라이브러리는 Python 전용이므로 다른 언어를 직접 지원하지 않습니다. Java 또는 C++ CV 파이프라인과 통합해야 하는 경우 브릿지를 통해 Python 라이브러리를 호출해야 합니다.

**제한된 내장 모델.** 일부 경쟁사와 달리 Supervision은 사전 학습된 모델을 포함하지 않습니다. 자신의 모델을 가져와서 다른 모든 것에 Supervision을 사용합니다.

## 자주 묻는 질문

### 1. Supervision은 어떻게 설치하나요?

`pip install supervision`을 실행하기만 하면 됩니다. 모든 기능과의 전체 호환성을 위해 `pip install supervision[all]`을 사용하세요.

### 2. Supervision은 YOLO 모델과 작동하나요?

예, `Detections.from_ultralytics()` 메서드를 통해 YOLOv5, YOLOv8 및 YOLO-NAS와 first-class 통합을 제공합니다.

### 3. 실시간 비디오 처리에 Supervision을 사용할 수 있나요?

예. 라이브러리는 성능에 최적화되어 있으며, 표준 하드웨어에서 프레임 처리 시간이 약 12ms로 실시간 30+ FPS 처리가 가능합니다.

### 4. Supervision은 어떤 주석 형식을 지원하나요?

Supervision은 COCO, YOLO, Pascal VOC 및 사용자 정의 JSON 형식을 지원합니다. 형식 간 변환이 내장되어 있습니다.

### 5. 사용자 정의 annotator를 생성할 수 있나요?

물론입니다. annotator 시스템은 확장 가능하도록 설계되었습니다. `sv.Annotator`를 subclass하여 특정 사용 사례에 대한 사용자 정의 시각화 도구를 생성할 수 있습니다.

### 6. Supervision은 프로덕션 사용에 적합한가요?

예. [42,819개의 GitHub star](https://github.com/roboflow/supervision)와 활성 커뮤니티를 통해 프로덕션 시스템에서 널리 사용됩니다. MIT license는 unrestricted commercial use를 허용합니다.

### 7. documentation은 어디에서 찾을 수 있나요?

전체 documentation은 [https://supervision.roboflow.com](https://supervision.roboflow.com)에서 사용할 수 있으며, 대화형 데모 노트북은 [Google Colab](https://colab.research.google.com/github/roboflow/supervision/blob/main/demo.ipynb)에서 사용할 수 있습니다.

## 결론

Roboflow의 Supervision은 컴퓨터 비전 분야에서 작업하는 모든 사람에게 필수적인 도구입니다. [42,819개의 GitHub star](https://github.com/roboflow/supervision)와 전체 CV 파이프라인을 아우르는 풍부한 기능 세트를 통해 프로덕션 CV 시스템을 구축하는 실용적이고 효율적으로 만드는 재사용 가능한 도구를 제공합니다.

데이터 주석과 모델 평가부터 시각화 및 추적에 이르기까지, Supervision은 다른 도구가 열어둔 gap을 커버합니다. 경량화, 잘 문서화되어 있으며 Python 기반 CV 워크플로우에 쉽게 통합할 수 있습니다. 훈련 데이터 주석 작성, 모델 성능 평가 또는 실시간 탐지 시스템 빌드이든, Supervision에는 필요한 도구가 있습니다.

`pip install supervision`으로 시작하고 [대화형 Colab 데모](https://colab.research.google.com/github/roboflow/supervision/blob/main/demo.ipynb)를 탐색하여 실제로 작동하는 것을 확인하세요.

[CTA: Supervision으로 더 나은 컴퓨터 비전 시스템 빌드하기. [지금 설치](https://github.com/roboflow/supervision) | [문서 읽기](https://supervision.roboflow.com)]

## 출처

1. [Supervision GitHub Repository](https://github.com/roboflow/supervision)
2. [Supervision Documentation](https://supervision.roboflow.com)
3. [Roboflow 공식 웹사이트](https://roboflow.com)
4. [대화형 Colab 데모](https://colab.research.google.com/github/roboflow/supervision/blob/main/demo.ipynb)
5. [DigitalOcean - CV 배포를 위한 클라우드 인프라](https://www.digitalocean.com/try/affiliate)
6. [HTStack - 고성능 호스팅](https://htstack.com/)
7. [WebShare - 데이터 파이프라인을 위한 프록시 서비스](https://webshare.io/)
