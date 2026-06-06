---
title: AiWind：1000+ AI 绘画提示词宝库，让 GPT-Image 2 和 Nanobanana 产出惊艳作品
description: AiWind는 GPT-Image 2, Nanobanana, Stable Diffusion, Midjourney 등 주요 모델을
  위한 1000+ 전문 AI 그림 프롬프트를 무료로 제공하는 AI 프롬프트 라이브러리입니다.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Go
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: ''
last_maintained: '2026-05-15'
featureImage: ''
draft: false
aliases:
- /ko/posts/aiwind-ai-prompt-library/
faqs:
  - q: 'AiWind은 무료로 사용할 수 있나요?'
    a: '네, AiWind는 aiwind.org에서 제공하는 완전 무료 AI 프롬프트 라이브러리로, 유료 플랜이 없습니다. 1000개 이상의 전문 프롬프트를 제공하며 지속적으로 업데이트됩니다.'
  - q: 'AiWind는 어떤 AI 이미지 모델의 프롬프트를 지원하나요?'
    a: 'AiWind는 GPT-Image 2, Nanobanana, Stable Diffusion, Midjourney, Flux-Kontext, Tencent Hunyuan, Google Imagen, ByteDance Seedream을 포함한 10개 이상의 모델을 지원합니다. 각 프롬프트 항목에는 가장 잘 작동하는 모델 추천 정보가 포함되어 있습니다.'
  - q: 'AiWind 프롬프트 라이브러리에는 어떤 아트 스타일이 있나요?'
    a: 'AiWind는 사실적 인물 사진, 사이버펑크, 3D 렌더링(픽사 스타일), 풍경 사진, 음식 사진, 패션 에디토리얼, 애니메이션, 중국 전통(국풍), 초현실주의, 인포그래픽 등의 스타일로 프롬프트를 분류하고 있습니다. 스타일, 모델 또는 키워드로 필터링할 수 있습니다.'
  - q: 'AiWind가 Stable Diffusion에 권장하는 CFG Scale과 스텝 설정은 무엇인가요?'
    a: '해당 문서에서는 CFG Scale 7-12, 샘플링 스텝 20-50, 샘플러 DPM++ 2M Karras, 해상도 1024x1024 이상을 권장합니다. 이 파라미터들은 프롬프트 준수도와 이미지 품질 사이의 균형을 잡아줍니다.'
  - q: 'AiWind는 PromptHero, Lexica, Civitai와 어떻게 비교되나요?'
    a: 'AiWind는 완전 무료 이용, 강력한 중국어 지원, 10개 이상의 모델 커버리지로 차별화됩니다. 반면 Lexica는 약 3개 모델을 지원하고, Civitai는 주로 Stable Diffusion에 집중합니다. AiWind, PromptHero, Civitai는 모두 커뮤니티 프롬프트 제출을 지원하지만, Lexica는 지원하지 않습니다.'
---

{</* resource-info */>}

## 문제: 왜 당신의 AI 그림은 항상 "뭔가 부족"한가?

GPT-Image 2, Midjourney 또는 Stable Diffusion에 큰돈을 들여 구독했지만 생성된 이미지는 항상:

- 인물 표정이 경직되어 플라스틱 마네킹 같다
- 풍경에 입체감이 없어 스티커를 붙인 것 같다
- 스타일이 일관되지 않고 전후가 모순된다
- 디테일이 부족해 확대하면 끔찍하다

**문제는 모델이 아니라 프롬프트에 있습니다.**

대부분의 사람은 프롬프트를 "예쁜 여자 그려줘"처럼 작성합니다. 하지만 AI는 알아야 합니다: 어떤 스타일? 어떤 조명? 어떤 구도? 어떤 감정?

## AiWind란 무엇인가?

[AiWind](https://aiwind.org/)는 **무료 AI 프롬프트 라이브러리**로, **1000+ 전문급 AI 그림 프롬프트**를 수집하여 주요 AI 이미지 생성 모델에 최적화했습니다.

### 지원 모델

| 모델 | 유형 | 특징 |
|------|------|------|
| **GPT-Image 2** | OpenAI | 의미 이해가 강하고 텍스트 렌더링이 우수 |
| **Nanobanana** | 국산 | 중문 지원이 우수하고 속도가 빠름 |
| **Stable Diffusion** | 오픈소스 | 커스터마이징이 강하고 생태계가 풍부 |
| **Midjourney** | 상업 | 예술성이 강하고 미학이 뛰어남 |
| **Flux-Kontext** | 오픈소스 | 맥락 이해와 일관성이 좋음 |
| **Hunyuan** | 텐센트 | 중문 시나리오 최적화 |
| **Imagen** | Google | 사진급 사실감 |
| **Seedream** | 바이트댄스 | 모바일 최적화 |

### 커버하는 스타일 분류

- **사실적 초상화** — 빛, 피부 질감, 표정 디테일
- **사이버펑크** — 네온, 기계, 미래감
- **3D 렌더링** — 픽사 스타일, 사실적 재질, 제품 전시
- **풍경 사진** — 대기 원근법, 골든 아워, 장노출
- **미식 대작** — 공중에 떠 있는 식재료, 증기, 질감
- **패션 대작** — Vogue 스타일, 에디토리얼, 오뜨 꾸뛰르
- **이차원** — 애니메이션, 일러스트, 캐릭터 디자인
- **국풍** — 한푸, 수묵화, 공필화
- **초현실** — 꿈, 깨진 거울, 컨셉 아트
- **인포그래픽** — 레시피, 데이터, 미니멀 디자인

## 추천 프롬프트 예시

### 1. 사실적 초상화 — 두바이 야금 금발 슈퍼모델

```
두바이 야금 금발 슈퍼모델
키워드: dubai, night, blonde
스타일: 패션 사진, 야경 인물
적용: GPT-Image 2, Midjourney
```

**효과**: 금발 모델이 두바이 야경 앞에서 도시 조명을 배경광으로 활용하여 고급 패션 잡지 느낌을 연출합니다.

### 2. 미식 대작 — 공중에 떠 있는 식재료 8K

```
공중에 떠 있는 식재료 8K 미식 대작
키워드: food, 8k, suspended
스타일: 상업 미식 사진, 공중 구도
적용: Nanobanana, Stable Diffusion
```

**효과**: 식재료가 공중에 떠 있고 물방울이 튀어 8K 초고화질 질감으로 레스토랑 메뉴와 광고에 적합합니다.

### 3. 3D 렌더링 — 픽사 스타일 햇살 소년

```
픽사 스타일 햇살 소년
키워드: pixar, disney, 3d
스타일: 3D 애니메이션 캐릭터, 픽사 스타일
적용: GPT-Image 2, Flux
```

**효과**: 햇살이 소년의 얼굴에 비치고 피부에 차표면 산란이 있으며 눈에 하이라이트 반사가 있는 전형적인 픽사 캐릭터 질감입니다.

### 4. 초현실 — 전구 속 로켓 발사

```
전구 속 로켓 발사
키워드: surreal, rocket, lightbulb
스타일: 초현실주의, 컨셉 아트
적용: Midjourney, Stable Diffusion
```

**효과**: 로켓이 전구에서 발사되고 유리 파편이 사방으로 흩날려 포스터와 커버에 창의적입니다.

### 5. 국풍 — 한푸 꽃병 미녀도

```
한푸 꽃병 미녀도
키워드: hanfu, chinese, traditional
스타일: 중국 전통 공필화, 미녀도
적용: Nanobanana, Hunyuan
```

**효과**: 미녀가 한푸를 입고 꽃병을 들고 배경에 산수 요소가 있는 섬세한 공필과 우아한 색채입니다.

### 6. 패션 대작 — 다크 포식 Vogue 커버

```
다크 포식 Vogue 커버
키워드: vogue, editorial, predatory
스타일: 하이엔드 패션 에디토리얼, 다크 미학
적용: GPT-Image 2, Midjourney
```

**효과**: 모델의 눈빛이 날카롭고 메이크업이 다크하며 구도가 Vogue 커버를 참고하여 고급스러운 질감입니다.

## AiWind 사용 방법

### 단계 1: 프롬프트 라이브러리 탐색

[aiwind.org](https://aiwind.org/)에 접속하여 1000+ 프롬프트를 탐색합니다. 스타일, 모델, 키워드로 필터링할 수 있습니다.

### 단계 2: 상세 정보 확인

임의의 프롬프트를 클릭하여 다음을 확인합니다:
- 완전한 영문 프롬프트
- 추천 모델과 파라미터
- 예시 이미지
- 태그 분류

### 단계 3: 복사하여 사용

프롬프트를 AI 이미지 생성 도구에 복사합니다:

```
# Midjourney 예시
/imagine prompt: 두바이 야금 금발 슈퍼모델, dubai night blonde, 
fashion photography, golden hour lighting, 
editorial style, 8k, ultra detailed --ar 3:4 --v 6

# Stable Diffusion 예시
긍정 프롬프트: dubai night blonde supermodel, fashion photography,
golden hour, editorial, 8k, ultra detailed, 
best quality, masterpiece
부정 프롬프트: blurry, low quality, distorted face, extra limbs
```

### 단계 4: 투고 공유

우수한 프롬프트가 있다면 AiWind에 투고하여 커뮤니티 성장을 도와주세요.

## 프롬프트 엔지니어링 팁

### 1. 구조화된 프롬프트

```
[주체] + [스타일] + [조명] + [구도] + [품질 단어]

예시:
주체: 금발 슈퍼모델이 두바이 야경 앞에 서 있다
스타일: 패션 사진, Vogue 에디토리얼 스타일
조명: 골든 아워, 도시 조명 배경광
구도: 미디엄 샷, 삼분법
품질: 8K, 초고화질, 최고 품질, 걸작
```

### 2. 가중치 제어（Stable Diffusion）

```
(금발 슈퍼모델:1.3) 가중치 증가를 의미
[야경:0.8] 가중치 감소를 의미
```

### 3. 부정 프롬프트

```
 blurry, lowres, bad anatomy, bad hands, text, error, 
 missing fingers, extra digit, fewer digits, cropped, 
 worst quality, low quality, normal quality, 
 jpeg artifacts, signature, watermark, username
```

### 4. 파라미터 튜닝

| 파라미터 | 역할 | 추천값 |
|------|------|--------|
| **CFG Scale** | 프롬프트 준수도 | 7-12 |
| **Steps** | 반복 단계 | 20-50 |
| **Sampler** | 샘플러 | DPM++ 2M Karras |
| **Resolution** | 해상도 | 1024x1024 이상 |

## 유사 도구 비교

| 특성 | AiWind | PromptHero | Lexica | Civitai |
|------|--------|-----------|--------|---------|
| **무료** | ✅ 완전 | ⚠️ 부분 | ✅ 예 | ✅ 예 |
| **중문 지원** | ✅ 우수 | ❌ 약함 | ❌ 약함 | ⚠️ 보통 |
| **모델 커버** | 10+ 모델 | 5+ 모델 | 3 모델 | 주로 SD |
| **프롬프트 품질** | 전문급 | 커뮤니티급 | 커뮤니티급 | 커뮤니티급 |
| **이미지 예시** | ✅ 있음 | ✅ 있음 | ✅ 있음 | ✅ 있음 |
| **투고 기능** | ✅ 있음 | ✅ 있음 | ❌ 없음 | ✅ 있음 |
| **분류 시스템** | 상세 | 보통 | 보통 | 태그 |

## 결론

AiWind는 **중문 사용자를 위한 최고의 AI 그림 프롬프트 라이브러리**입니다.

- 1000+ 프롬프트, 주요 모델과 스타일 커버
- 완전 무료, 지속 업데이트
- 중문 인터페이스, 중문 프롬프트
- 예시 이미지로 효과를 직관적으로 확인

AI로 이미지를 생성할 때 항상 "뭔가 부족"하다면 AiWind에서 영감을 찾아보세요.

**웹사이트**: [aiwind.org](https://aiwind.org/)  
**기능**: 1000+ 프롬프트 | 10+ 모델 지원 | 무료 사용

## 관련 기사

- [Pixelle-Video: AI 자동 숏폼 생성기](/kr/resources/ai-tools/pixelle-video-ai-short-video-generator/)
- [TabPFN: 테이블 데이터 기반 모델](/kr/resources/ai-tools/tabpfn-foundation-model-tabular-data/)
- [Hermes Agent: 자기 개선하는 AI 에이전트](/kr/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/)

---

## 추천 도구

오픈소스 AI 도구 개발/배포 시 권장:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전, AI 워크로드용 원클릭 droplet.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API 프록시. 위의 AI 도구 대부분 (챗봇, 코드 생성, 번역, 검색 등) LLM API 키 필요 — 이 프록시로 안정적인 톱 모델 액세스, 공식 가격의 ~30%.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

