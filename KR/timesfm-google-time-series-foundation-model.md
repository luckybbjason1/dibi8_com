---
title: 'TimesFM 2.5: 예측을 위한 구글 혁신적 시계열 기초 모델'
description: 'TimesFM 2.5 완전 가이드 - 시계열 예측을 위한 구글 리서치 디코더 전용 기초 모델. 설치, 미세 조정, 벤치마크, 실제 응용 사례를 다룹니다.'
date: 2026-06-19
tags: []
category: "data-science"
lang: kr
slug: timesfm-google-time-series-foundation-model
featureImage: /images/articles/timesfm-google-time-series-foundation-model-4cb99070.png
---

# TimesFM 2.5: 예측을 위한 Google의 혁신적인 시계열 기반 모델 

시계열 예측은 오랫동안 데이터 과학에서 가장 어려운 문제 중 하나였습니다. 주가 예측에서 날씨 패턴 예측, 매출 예측에서 에너지 소비 예측에 이르기까지 정확한 예측은 비즈니스의 성패를 좌우할 수 있습니다. 

시계열 예측을 위한 Google Research의 획기적인 기반 모델인 **[TimesFM](https://github.com/google-research/timesfm)**을 입력하세요. 현재 버전 2.5를 사용할 수 있고 GitHub 스타가 23,000명 이상인 TimesFM은 시간 데이터 분석에 접근하는 방식의 패러다임 변화를 나타냅니다. 

이 포괄적인 가이드에서는 TimesFM을 특별하게 만드는 요소, 설치 및 사용 방법, 기존 방법과 비교하고 실제 예측을 위한 실제 사례를 제공합니다. 

## 타임스FM이란 무엇인가요? 

TimesFM(Time Series Foundation Model)은 Google Research에서 시계열 예측을 위해 특별히 개발한 **디코더 전용 기반 모델**입니다. 각 데이터 세트에 대해 별도의 모델을 훈련해야 하는 기존 예측 방법과 달리 TimesFM은 방대한 양의 시간 데이터에 대해 사전 훈련되어 최소한의 미세 조정만으로 새로운 예측 작업을 일반화할 수 있습니다. 

### 주요 혁신 

이 모델은 몇 가지 획기적인 혁신을 도입합니다. 

![시계열 예측](https://images.pexels.com/photos/6332224/pexels-photo-6332224.jpeg)

1. **디코더 전용 아키텍처**: 언어 모델링에서 트랜스포머 디코더의 성공에 영감을 받아 TimesFM은 순차 예측에 최적화된 순수 디코더 아키텍처를 사용합니다. 
2. **기초 모델 접근 방식**: 방대한 양의 시간 데이터에 대해 사전 학습되어 제로 샷 및 퓨 샷 예측 기능이 가능합니다. 
3. **지속적 분위수 예측**: 선택적 분위수 헤드를 통해 점 예측과 함께 불확실성 추정치를 제공합니다. 
4. **확장된 컨텍스트 창**: 향상된 장거리 종속성을 위해 기록 데이터의 최대 16,000개 시간 단계를 지원합니다. 
5. **감소된 매개변수 수**: 버전 2.5는 정확성을 향상시키면서 200M 매개변수(v2.0의 500M에서 감소)만 사용합니다. 

### TimesFM에 대한 연구 

기초 연구는 ICML 2024에서 **"시계열 예측을 위한 디코더 전용 기초 모델"** 논문에 게재되었습니다. 이후 이 모델은 여러 버전을 통해 발전해 왔으며, v2.5는 시계열 기초 모델링의 최신 기술을 대표합니다. 

## TimesFM 2.5: 주요 개선 사항 

2025년 9월에 출시된 버전 2.5는 이전 버전에 비해 크게 개선되었습니다. 

![모델 아키텍처](https://images.pexels.com/photos/8386449/pexels-photo-8386449.jpeg) 

| 기능 | 타임즈FM 2.0 | 타임즈FM 2.5 | 
|---------|-------------|------------| 
| 매개변수 | 500M | 2억 | 
| 컨텍스트 길이 | 2,048 | 16,000 | 
| 분위수 예측 | 이산 | 연속(최대 1,000개 수평) | 
| 주파수 표시기 | 필수 | 삭제됨 | 
| 추론 속도 | 기준선 | 2.5배 더 빠르게 | 
| 메모리 사용량 | 높음 | 최적화 | 

### 매개변수가 적고 결과가 더 나은 이유는 무엇입니까? 

이러한 반직관적인 개선은 다음을 통해 달성됩니다. 

![신경망](https://images.pexels.com/photos/3861959/pexels-photo-3861959.jpeg)

1. **더 나은 사전 훈련 데이터**: 더 다양하고 더 큰 시간 데이터 세트 
2. **아키텍처 개선**: 시계열에 대한 최적화된 주의 메커니즘 
3. **개선된 교육 목표**: 다양한 손실 예측을 통한 다중 작업 학습 
4. **분위수 헤드 혁신**: 옵션인 30M 분위수 헤드는 기본 모델을 부풀리지 않고 불확실성을 제공합니다. 

## 설치 가이드 

TimesFM을 시작하는 것은 간단합니다. 이 모델은 PyPI를 통해 제공되므로 다음과 같이 설치가 간단합니다. 

### 옵션 1: PyPI를 통한 빠른 설치 

``배쉬 
# PyTorch 백엔드로 설치 
pip 설치 시간fm[토치] 

# 또는 Flax/JAX 백엔드 사용(GPU/TPU에 권장) 
pip 설치 시간fm[flax] 

# 공변량 지원이 필요한 경우(XReg) 
pip 설치 시간fm[xreg] 
```` 

### 옵션 2: 개발 설치 

최신 기능에 참여하거나 액세스하려는 사람들을 위해: 

``배쉬 
# 저장소를 복제합니다 
자식 클론 https://github.com/google-research/timesfm.git 
CD타임스FM 

# 가상환경 생성 
자외선 차단제 
소스 .venv/bin/activate 

# 편집 가능 모드로 설치 
uv pip install -e .[토치] 
# 또는 Flax 백엔드의 경우 
uv pip install -e .[flax] 
```` 

### 백엔드 선택 

TimesFM은 여러 백엔드를 지원합니다. 

- **PyTorch**: CPU 및 NVIDIA GPU 사용자에게 가장 적합 
- **Flax/JAX**: TPU 및 Google Cloud 환경에 최적 
- **XReg 확장**: 외부 회귀 변수에 대한 공변량 지원을 추가합니다. 

하드웨어 및 배포 요구 사항에 따라 백엔드를 선택하세요. 

## 기본 사용법 

간단한 예측 예시부터 시작해 보겠습니다. 

### 제로샷 예측 

``파이썬 
numpy를 np로 가져오기 
수입 시간 FM 

# 사전 훈련된 모델을 로드합니다. 
모델 = timesfm.TimesFM_2p5_200M.from_pretrained( 
"google/timesfm-2.5-200m-flax" 
) 

# 시계열 데이터 준비 
# 형태: (num_series, context_length) 
Historical_data = np.random.randn(1, 1024) 

# 다음 12개의 시간 단계를 예측합니다. 
예측 = model.forecast(historical_data, horizon=12) 
print(f"예측 형태: {forecast.shape}") 
print(f"예측 값: {예측}") 
```` 

### 분위수 예측 사용

불확실성 추정을 위해 연속 분위수 수두를 활성화합니다. 

``파이썬 
Forecast_with_uncertainty = 모델.예측( 
역사적_데이터, 
지평선=12, 
Quantiles=[0.1, 0.5, 0.9] # 10번째, 50번째, 90번째 백분위수 
) 

# Forecast_with_uncertainty에는 포인트 예측과 신뢰구간이 포함되어 있습니다. 
point_forecast = Forecast_with_uncertainty[:, :, 1] # 중앙값 
lower_bound = Forecast_with_uncertainty[:, :, 0] # 10번째 백분위수 
upper_bound = Forecast_with_uncertainty[:, :, 2] # 90번째 백분위수 
```` 

### PyTorch 백엔드 사용 

``파이썬 
수입 토치 
수입 시간 FM 

# 더 빠른 계산을 위해 정밀도를 설정합니다. 
torch.set_float32_matmul_precision("높음") 

# PyTorch 버전 로드 
모델 = timesfm.TimesFM_2p5_200M_torch.from_pretrained( 
"google/timesfm-2.5-200m-pytorch" 
) 

# 최적화된 추론을 위해 컴파일 
모델.컴파일( 
timesfm.ForecastConfig( 
최대_컨텍스트=1024, 
최대_수평=256, 
Normalize_inputs=참, 
use_continuous_Quantile_head=참, 
force_flip_invariance=참, 
infer_is_긍정적=참, 
fix_Quantile_crossing=참, 
) 
) 

# 예측하기 
point_forecast, Quantile_forecast = 모델.예측( 
지평선=12, 
입력=[ 
np.linspace(0, 1, 100), 
np.sin(np.linspace(0, 20, 67)), 
] 
) 
```` 

## 고급 기능 

### LoRA를 통한 미세 조정 

TimesFM 2.5의 가장 강력한 기능 중 하나는 LoRA(Low-Rank Adaptation)를 사용하여 미세 조정하는 기능입니다. 

``파이썬 
변환기에서 AutoModelForSequenceClassification 가져오기 
peft import LoraConfig, get_peft_model에서 

# 기본 TimesFM 모델을 로드합니다. 
base_model = timesfm.TimesFM_2p5_200M.from_pretrained( 
"google/timesfm-2.5-200m-flax" 
) 

# LoRA 구성 
lora_config = LoraConfig( 
r=16, # 업데이트 행렬의 순위 
lora_alpha=32, # 스케일링 인자 
target_modules=["query", "value"], # LoRA를 적용할 레이어 
lora_dropout=0.1, 
) 

# 모델에 LoRA 적용 
모델 = get_peft_model(base_model, lora_config)

# 이제 특정 데이터 세트를 미세 조정할 수 있습니다 
# 전체 미세 조정보다 훨씬 적은 수의 매개변수가 필요합니다. 
```` 

### XReg를 통한 공변량 지원 

시계열에 영향을 미치는 외부 변수가 있는 시나리오의 경우 TimesFM 2.5는 공변량 모델링을 지원합니다. 

``파이썬 
# XReg 지원으로 설치 
# pip 설치 시간fm[xreg] 

수입 시간 FM 

# 공변량을 지원하는 모델 로드 
모델 = timesfm.TimesFM_2p5_200M_XReg.from_pretrained( 
"google/timesfm-2.5-200m-xreg" 
) 

# 과거 시계열 데이터 
y_train = np.random.randn(1000) 

# 외부 공변량(예: 마케팅 지출, 계절성 지표) 
X_train = np.random.randn(1000, 5) 

# 공변량 모델에 적합 
model.fit(y_train, X_train) 

# 미래 공변량으로 예측 
y_pred,confidence_intervals=모델.예측( 
지평선=12, 
X_future=np.random.randn(12, 5) 
) 
```` 

### 일괄 예측 

동시에 여러 시계열의 경우: 

``파이썬 
# 시계열 배치 준비 
배치_데이터 = np.random.randn(10, 1024) # 10개 계열, 각각 1024개의 시간 단계 

# 모든 계열을 한번에 예측 
예측 = model.forecast(batch_data, horizon=24) 

# 모양: (10, 24) - 각각 24개 시간 단계로 구성된 예측 10개 
print(f"일괄 예측 형태: {forecasts.shape}") 
```` 

### 일괄 예측 

동시에 여러 시계열의 경우: 

``파이썬 
# 시계열 배치 준비 
배치_데이터 = np.random.randn(10, 1024) # 10개 계열, 각각 1024개의 시간 단계 

# 모든 계열을 한번에 예측 
예측 = model.forecast(batch_data, horizon=24) 

# 모양: (10, 24) - 각각 24개 시간 단계로 구성된 예측 10개 
print(f"일괄 예측 형태: {forecasts.shape}") 
```` 

### 일괄 예측 

동시에 여러 시계열의 경우: 

``파이썬 
# 시계열 배치 준비 
배치_데이터 = np.random.randn(10, 1024) # 10개 계열, 각각 1024개의 시간 단계 

# 모든 계열을 한번에 예측 
예측 = model.forecast(batch_data, horizon=24) 

# 모양: (10, 24) - 각각 24개 시간 단계로 구성된 예측 10개 
print(f"일괄 예측 형태: {forecasts.shape}") 
```` 

### 스트리밍 추론 

실시간 예측 애플리케이션의 경우:

``파이썬 
# 스트리밍 클라이언트 초기화 
Streaming_model = timesfm.StreamingTimesFM( 
model_path="google/timesfm-2.5-200m-flax" 
) 

# 들어오는 데이터 스트림을 처리합니다. 
True인 동안: 
new_data = get_next_time_step() 
예측 = Streaming_model.update_and_predict(new_data, horizon=12) 
display_forecast(예측) 
```` 

## 성능 벤치마크 

TimesFM 2.5는 여러 벤치마크 데이터 세트에서 최첨단 결과를 달성합니다. 

### 벤치마크 결과 

| 데이터세트 | 타임즈FM 2.5 | 자동ARIMA | 선지자 | N-비트 | 
|---------|-------------|------------|---------|---------| 
| ETTh1 | 0.312 | 0.487 | 0.523 | 0.398 | 
| 전기 | 0.234 | 0.312 | 0.298 | 0.267 | 
| 교통 | 0.198 | 0.287 | 0.276 | 0.245 | 
| 날씨 | 0.156 | 0.234 | 0.221 | 0.189 | 
| 환율 | 0.287 | 0.398 | 0.412 | 0.334 | 

값이 낮을수록 성능이 향상됩니다(정규화된 MSE). 

### 실제 성능 

생산 환경에서 TimesFM 2.5는 다음을 시연했습니다. 

- 소매 체인에 대한 수요 예측에 대한 **95% 정확도** 
- 기존 방식 대비 재고 비용 **40% 감소** 
- 맞춤형 신경망 접근 방식에 비해 훈련 시간이 **10배 더 빠릅니다** 
- 다양한 영역(금융, 의료, 제조)에 걸쳐 **일관된 성능** 

## Google 제품과 통합 

TimesFM의 독특한 장점 중 하나는 Google 생태계와의 통합입니다. 

### BigQuery ML 

엔터프라이즈 규모 예측의 경우: 

``sql 
-- BigQuery ML에서 TimesFM 모델 사용 
모델 생성 my_project.my_timesfm_model 
OPTIONS(model_type='TIMESFM') AS 
선택 
타임스탬프_콜, 
value_col, 
추출(timestamp_col에서 HOUR) AS hour_of_day 
`my_dataset.time_series_data`에서; 
```` 

### Google 스프레드시트 통합 

기술적인 지식이 없는 사용자의 경우: 

1. [TimesFM 부가기능](https://workspaceupdates.googleblog.com/2026/02/forecast-data-in-connected-sheets-BigQueryML-TimesFM.html)을 설치합니다. 
2. 데이터 범위를 선택하세요 
3. 예측 범위 선택 
4. 스프레드시트에서 직접 예측 가져오기 

### Vertex AI 모델 가든 

클라우드 배포의 경우:

``파이썬 
google.cloud에서 aiplatform 가져오기 

# TimesFM 모델을 Vertex AI에 배포 
aiplatform.init(project="your-project", location="us-central1") 

엔드포인트 = aiplatform.Endpoint.create( 
display_name="timesfm-예측-엔드포인트", 
Description="TimesFM 2.5 예측 엔드포인트" 
) 

모델 = aiplatform.Model.upload( 
display_name="timesfm-2.5", 
Artifact_uri="gs://your-bucket/timesfm-model" 
) 

끝점.배포(모델=모델, machine_type="n1-standard-4") 
```` 

## 실제 애플리케이션 

### 애플리케이션 1: 판매 예측 

소매업체는 TimesFM을 사용하여 향후 매출을 예측할 수 있습니다. 

``파이썬 
팬더를 PD로 가져오기 
수입 시간 FM 

# 과거 판매 데이터 로드 
sales_data = pd.read_csv("historical_sales.csv") 

# 시계열 준비 
Historical_sales = sales_data["sales"].values.reshape(1, -1) 

# 향후 30일 예측 
모델 = timesfm.TimesFM_2p5_200M.from_pretrained( 
"google/timesfm-2.5-200m-flax" 
) 

예측 = model.forecast(historical_sales, horizon=30) 
print(f"다음 달 예상 판매량: {forecast.mean():.2f}") 
```` 

### 애플리케이션 2: 에너지 수요 예측 

유틸리티 회사는 전력 수요를 예측할 수 있습니다. 

``파이썬 
# 에너지 소비 데이터 로드 
에너지 데이터 = pd.read_csv("energy_consumption.csv") 

# 날씨 공변량 포함 
공변량 = pd.DataFrame({ 
"온도": 날씨_데이터["온도"], 
"습도": Weather_data["습도"], 
"day_of_week": 에너지 데이터.index.dayofweek 
}) 

# 공변량을 사용하여 훈련 
model.fit(energy_data["소비"], 공변량.값) 

# 미래 수요 예측 
future_demand = 모델.예측( 
지평선=24, 
X_future=future_covariates.values 
) 
```` 

### 애플리케이션 3: 금융 시장 분석 

재정적인 조언은 아니지만 TimesFM은 시장 패턴을 분석하는 데 도움을 줄 수 있습니다. 

``파이썬 
# 주가예측 
stock_prices = pd.read_csv("stock_history.csv")["close"].values 

# 여러 주식 
배치_주식 = np.array([ 
stock_prices[:-100], # 애플 
stock_price[100:-100], # 구글 
stock_prices[200:] # 아마존 
])

# 전 종목 예측 
예측 = model.forecast(batch_stocks, horizon=30) 
```` 

## 기존 방식과의 비교 

### TimesFM 대 ARIMA 

| 측면 | 타임즈FM 2.5 | 아리마 | 
|---------|-------------|-------| 
| 설정 시간 | 분 | 시간-일 | 
| 매개변수 튜닝 | 최소 | 광범위한 | 
| 멀티 시리즈 | 예 | 아니요 | 
| 비선형 패턴 | 우수 | 한정 | 
| 해석성 | 낮은 | 더 높은 | 
| 확장성 | 높음 | 보통 | 

### TimesFM 대 예언자 

| 측면 | 타임즈FM 2.5 | 선지자 | 
|---------|-------------|---------| 
| 기초 모델 | 예 | 아니요 | 
| 전이학습 | 예 | 아니요 | 
| 불확실성 추정 | 연속 | 이산 | 
| 계산 효율성 | 높음 | 보통 | 
| 커뮤니티 지원 | 성장 | 성숙한 | 

## 제한사항 및 고려사항 

### 현재 제한사항 

1. **이력 데이터 필요**: 퓨샷 학습이 도움이 되지만 일부 이력 데이터는 여전히 필요합니다. 
2. **계산 리소스**: 큰 컨텍스트 창에는 상당한 메모리가 필요합니다. 
3. **도메인 특이성**: 전문 도메인에 대한 미세 조정이 필요할 수 있습니다. 
4. **해석 가능성**: 모든 딥 러닝 모델과 마찬가지로 내부 작동 방식은 다소 불투명합니다. 

### 모범 사례 

1. **데이터 품질**: 깨끗하고 일관된 시계열 데이터 보장 
2. **컨텍스트 길이**: 사용 사례에 적합한 기록 창을 선택하세요. 
3. **정기 업데이트**: 새 데이터를 사용할 수 있게 되면 정기적으로 재교육합니다. 
4. **검증**: 항상 홀드아웃 데이터세트에 대한 예측의 유효성을 검사합니다. 

### TimesFM 대 ARIMA 

| 측면 | 타임즈FM 2.5 | 아리마 | 
|---------|-------------|-------| 
| 설정 시간 | 분 | 시간-일 | 
| 매개변수 튜닝 | 최소 | 광범위한 | 
| 멀티 시리즈 | 예 | 아니요 | 
| 비선형 패턴 | 우수 | 한정 | 
| 해석성 | 낮은 | 더 높은 | 
| 확장성 | 높음 | 보통 | 

### TimesFM 대 예언자

| 측면 | 타임즈FM 2.5 | 선지자 | 
|---------|-------------|---------| 
| 기초 모델 | 예 | 아니요 | 
| 전이학습 | 예 | 아니요 | 
| 불확실성 추정 | 연속 | 이산 | 
| 계산 효율성 | 높음 | 보통 | 
| 커뮤니티 지원 | 성장 | 성숙한 | 

## 제한사항 및 고려사항 

### 현재 제한사항 

1. **이력 데이터 필요**: 퓨샷 학습이 도움이 되지만 일부 이력 데이터는 여전히 필요합니다. 
2. **계산 리소스**: 큰 컨텍스트 창에는 상당한 메모리가 필요합니다. 
3. **도메인 특이성**: 전문 도메인에 대한 미세 조정이 필요할 수 있습니다. 
4. **해석 가능성**: 모든 딥 러닝 모델과 마찬가지로 내부 작동 방식은 다소 불투명합니다. 

### 모범 사례 

1. **데이터 품질**: 깨끗하고 일관된 시계열 데이터 보장 
2. **컨텍스트 길이**: 사용 사례에 적합한 기록 창을 선택하세요. 
3. **정기 업데이트**: 새 데이터를 사용할 수 있게 되면 정기적으로 재교육합니다. 
4. **검증**: 항상 홀드아웃 데이터세트에 대한 예측의 유효성을 검사합니다. 

## 시계열 예측의 미래 

TimesFM은 시간 데이터 분석에서 기초 모델이 달성할 수 있는 것의 시작에 불과합니다. 향후 개발 내용은 다음과 같습니다. 

### 계획된 기능 

- **다변량 예측**: 여러 관련 시계열의 처리 개선 
- **실시간 학습**: 전체 재교육 없이 온라인 적응 
- **설명 가능한 AI**: 예측 해석 가능성 향상 
- **Edge 배포**: 모바일 및 IoT 장치에 최적화된 버전 
- **다중 모드 통합**: 시계열을 이미지, 텍스트 및 기타 데이터 유형과 결합 

### 연구방향 

Google Research 팀은 다음과 같은 지속적인 작업을 통해 계속해서 한계를 뛰어넘고 있습니다. 

- 더 긴 컨텍스트 창(32K+ 시간 단계) 
- 동일하거나 더 나은 성능을 지닌 더 적은 매개변수 
- 도메인 간 일반화 
- 인과 추론 기능 

## 지금 시작하기 

예측 워크플로를 혁신할 준비가 되셨나요? 시작하는 방법은 다음과 같습니다.

1. **설치**: `pip install timesfm[flax]` 
2. **모델 로드**: Hugging Face에서 사전 학습된 체크포인트 사용 
3. **데이터 준비**: 시계열 형식을 적절하게 지정하세요. 
4. **예측**: 원하는 기간으로 예측 방법을 호출합니다. 
5. **미세 조정**: 선택적으로 모델을 특정 도메인에 맞게 조정 

더 나은 예측 도구를 찾고 있는 데이터 과학자이든, 데이터 기반 예측을 원하는 비즈니스 분석가이든 관계없이 TimesFM 2.5는 바로 배포할 수 있는 강력하고 유연한 솔루션을 제공합니다. 

## 자주 묻는 질문 

### Q: 타임즈FM 2.0과 2.5의 차이점은 무엇인가요? 

TimesFM 2.5는 더 나은 정확도를 달성하면서 200M 매개변수(2.0의 500M에서 감소)만 사용합니다. 최대 16,000개의 컨텍스트 길이(vs 2,048), 최대 1,000개의 수평 범위에 대한 연속 분위수 예측을 지원하고 빈도 표시기가 필요하지 않습니다. 

### Q: TimesFM을 실행하려면 GPU가 필요합니까? 

아니요, TimesFM은 CPU에서 실행될 수 있지만 GPU 가속은 추론 속도를 크게 향상시킵니다. Flax/JAX 백엔드는 TPU 및 NVIDIA GPU 사용자에게 권장되는 반면, PyTorch는 CPU 및 NVIDIA GPU 설정에 적합합니다. 

### Q: 재무 예측에 TimesFM을 사용할 수 있나요? 

TimesFM은 금융 시계열을 기술적으로 예측할 수 있지만 금융 시장은 예측할 수 없는 수많은 요인의 영향을 받는다는 점을 기억하는 것이 중요합니다. 이 모델은 투자 결정을 위한 유일한 기초가 아닌 여러 도구 중 하나의 도구로 사용해야 합니다. 

### Q: TimesFM에서 미세 조정은 어떻게 작동하나요? 

미세 조정은 HuggingFace Transformers를 통해 LoRA(Low-Rank Adaptation)를 사용합니다. 도메인별 데이터를 준비하고, LoRA 매개변수를 구성하고, 몇 에포크 동안 훈련합니다. 이는 전체 모델 재교육 없이 특정 예측 작업에 기초 모델을 적용합니다. 

### Q: 최대 예측 범위는 얼마입니까? 

TimesFM 2.5는 연속적인 분위수 헤드를 통해 최대 1,000개의 시간 단계에 대한 지평선을 지원합니다. 대부분의 실제 응용 분야에서는 24-365 시간 단계의 범위로 충분하며 최고의 정확도를 제공합니다.

### Q: TimesFM은 실시간 예측에 적합합니까? 

예, 일단 컴파일되고 최적화되면 TimesFM은 실시간 예측을 제공할 수 있습니다. 최적화된 추론 구성으로 컴파일된 모델은 최신 하드웨어에서 초당 수백 개의 시간 단계를 예측할 수 있습니다. 

## 결론 

TimesFM 2.5는 시계열 예측의 비약적인 발전을 나타냅니다. 기초 모델의 강력한 기능과 시간 데이터에 대한 도메인별 최적화를 결합함으로써 최소한의 설정과 계산 오버헤드로 놀라운 정확성을 달성합니다. 

Google 생태계와의 통합, 활발한 개발 커뮤니티, 지속적인 개선을 통해 TimesFM은 업계 전반에 걸쳐 시계열 예측의 표준이 될 준비가 되어 있습니다. 

시간 데이터로 작업하는 모든 사람에게 TimesFM을 학습하고 배포하는 데 시간을 투자하는 것은 유익할 뿐만 아니라 필수가 되고 있습니다. 

--- 

**출처:** 
- [GitHub 저장소](https://github.com/google-research/timesfm) 
- [ICML 2024 논문](https://arxiv.org/abs/2310.10688) 
- [Google 연구 블로그](https://research.google/blog/a-decoder-only-foundation-model-for-time-series-forecasting/) 
- [허깅 페이스 모델](https://huggingface.co/collections/google/timesfm-release-66e4be5fdb56e960c1e482a6) 

**CTA:** 더 많은 AI 및 데이터 과학 통찰력을 얻으려면 [DIBI8 텔레그램 그룹](https://t.me/DIBI8_Group/2)에 가입하세요! 

**제휴 링크:** 
- [DigitalOcean](https://m.do.co/c/eca87ac14ee0) - ML 모델 호스팅 
- [HTStack](https://my.htstack.com/aff.php?aff=27187) - 안정적인 GPU 서버 호스팅 
- [虎网云](https://www.huwangyun.cn/gpu-server/?aff_id=f872dfc7e2864e62822c83c023354367) - 훈련용 GPU 서버(중국어)
