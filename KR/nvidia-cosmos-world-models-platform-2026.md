---

title: "NVIDIA Cosmos: 물리적 AI를 위한 오픈소스 월드 모델 (1만 스타)"
description: 'NVIDIA Cosmos는 물리 AI(로봇, 자율주행차, 스마트 인프라)를 구축하기 위한 월드 모델, 데이터세트, 도구의 오픈 플랫폼입니다. Cosmos 3는 Mixture-of-Transformers를 사용하여 언어, 이미지, 비디오, 오디오, 액션을 통합 생성합니다. 16B 및 64B 모델 제공.'
date: 2026-06-13
slug: 'nvidia-cosmos-world-models-platform-2026'
category: ai-tools
tags: ['nvidia-cosmos', 'world-models', 'physical-ai', 'robotics', 'video-generation', 'multimodal', 'mixture-of-transformers', 'open-source', 'ai-simulation']
github_repo: 'https://github.com/NVIDIA/cosmos'
license: Apache-2.0
lang: kr
featureImage: /articles/nvidia-cosmos-open-source-world-models-for-physical-ai-10k-s.jpg/images/articles/nvidia-cosmos-open-source-world-models-for-physical-ai-10k-s.jpg
---
![NVIDIA Cosmos 플랫폼](https://raw.githubusercontent.com/NVIDIA/cosmos/main/cookbooks/cosmos3/cosmos3-model-architecture.png) # NVIDIA Cosmos: 물리적 AI를 위한 오픈 소스 세계 모델(별 10,000개) 물리 방정식을 시뮬레이션하는 것이 아니라 세계 자체로부터 학습하여 물리적 세계가 어떻게 작동하는지 예측할 수 있다면 어떨까요? NVIDIA Cosmos는 바로 물리적 세계를 이해하고 생성하도록 훈련된 세계 모델의 오픈 소스 플랫폼입니다. 로봇이 움직이는 이미지를 생성할 뿐만 아니라 해당 동작의 물리학, 타이밍, 원인과 결과를 예측합니다. Cosmos 3는 언어, 이미지, 비디오, 오디오 및 액션 시퀀스를 동시에 처리하는 통합 MoT(Mixture-of-Transformers) 아키텍처를 기반으로 구축된 NVIDIA의 최신 모델 제품군입니다. 두 가지 런타임: **Reasoner**(세계 이해 및 계획용) 및 **Generator**(세계 시뮬레이션 및 합성 데이터 생성용). 모델 범위는 16B(Nano)부터 64B(Super) 매개변수까지이며 HuggingFace에서 사용할 수 있습니다. 이는 로봇, 자율주행차, 스마트 인프라 등 차세대 물리적 AI를 위한 인프라입니다. ## 엔비디아 코스모스란 무엇인가요? NVIDIA Cosmos는 물리적 AI 시스템 구축을 위해 설계된 **세계 모델, 데이터 세트 및 도구로 구성된 개방형 플랫폼**입니다. 이는 전통적인 AI가 할 수 있는 것 이상입니다. ```` 
전통적인 AI: 코스모스: 입력 → 출력 → 입력 → 추론 → 출력 (이미지 입력, (물리학을 이해하고, 캡션 아웃) 미래를 예측하고, 작업 생성) 
```` 주요 기능: - **세계 이해**: 캡션, 시간적 사건, 다음 조치, 공간적 접지, 물리적 타당성 및 인과적 결과에 대한 비디오 및 이미지를 분석합니다. 
- **월드 생성**: 텍스트, 이미지, 비디오 또는 작업 입력에서 이미지, 비디오, 동기화된 사운드 및 작업 조건 롤아웃을 생성합니다. 
- **동작 모델링**: 로봇 공학, 카메라 동작, 자기 중심 동작 및 자율 주행에 대한 정책 동작, 역역학 및 순방향 역학을 예측합니다. Cosmos 3 모델 제품군에는 다음이 포함됩니다. | 모델 | 사이즈 | 능력 | 
|