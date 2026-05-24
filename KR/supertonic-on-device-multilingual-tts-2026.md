---
title: 'Supertonic 리뷰: ONNX로 31개 언어를 돌리는 99M 파라미터 온디바이스 TTS (2026)'
description: 'Supertone Inc.가 만든 Supertonic(GitHub 9.9K+ stars)은 ONNX Runtime을 통해 CPU에서 로컬로 돌아가는 초고속 다국어 TTS 모델이다 — 클라우드 없음, API 없음, GPU 불필요. 99M 파라미터, 한국어/일본어/베트남어/중국어 포함 31개 언어, 44.1kHz 스튜디오 음질, 10개 표현 태그, Python·Node.js·브라우저(WebGPU/WASM)·iOS·Android·Rust·Flutter 런타임 지원. 기능 분석·설치·코드 예제·2026년 온디바이스 TTS 지형 비교까지 정리.'
date: 2026-05-23 00:00:00+08:00
lastmod: 2026-05-23 00:00:00+08:00
tech_stack: []
application_domain: AI Tools
source_version: 'v2.0.0'
licensing_model: Open Source
license_type: MIT (code) / OpenRAIL-M (model)
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/supertone-inc/supertonic'
stars: 9900
maintainer: 'supertone-inc'
last_maintained: '2026-01-06'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['supertonic', 'text-to-speech', 'tts', 'on-device-ai', 'onnx', 'multilingual', 'open-source-tts', 'edge-ai', 'korean-tts', 'japanese-tts']
aliases:
- /kr/posts/supertonic-on-device-multilingual-tts-2026/
---

## 온디바이스 TTS의 문제

수년간 "괜찮은" 다국어 TTS란 곧 남의 클라우드 API를 호출하는 일이었다 — Google Cloud TTS, Amazon Polly, ElevenLabs, OpenAI Voice. 음성은 자연스러웠고, 광대역에서 지연은 견딜 만했으며, 문자당 단가는 청구서가 날아오기 전까진 아무도 신경 쓰지 않을 만큼 작았다.

균열은 세 군데서 드러났다. **프라이버시** — 모든 스크립트를 제3자에 보내는 건 의료, 법률, 규제 산업에선 선택지가 아니다. **지연 편차** — 네트워크가 흔들리면 음성이 끊긴다. **스케일에서의 비용** — 월 100시간 정도의 오디오를 합성하기 시작하면 문자당 청구서가 쌓인다. 그리고 **오프라인 사용** — 차량, 항공기, 원격 시설, 키오스크 어디든 로컬 추론이 필수다. 끝.

오픈소스 온디바이스 TTS도 따라잡고 있었지만 트레이드오프가 가혹했다: 영어 전용 미니 모델(Piper, Coqui의 소형 변종)이거나, 실용성을 확보하려면 GPU가 필수인 거대 다국어 모델(XTTS-v2, Bark)이거나. "빠르고, 다국어이며, 가볍고, 진짜 오픈 웨이트"라는 sweet spot은 누구도 맞추지 못했다.

한국 음성 AI 회사 Supertone Inc.가 만든 [**Supertonic**](https://github.com/supertone-inc/supertonic) (GitHub: `supertone-inc/supertonic`, **9,900+ stars**)은 2026년에 그 공백을 메울 가장 신뢰할 만한 후보다. 99M 파라미터, 31개 언어, ONNX 런타임, CPU에서 무리 없이 돌아간다 — README에 따르면 비행기 모드의 e-reader에서도 실시간 대비 0.3배(RTF) 성능을 낸다고 한다.

---

## Supertonic의 정체

ONNX로 익스포트된, flow-matching 기반 text-to-latent 모듈 + speech autoencoder. 구체적으로:

- **총 99M 파라미터** — 몇 초 안에 로딩되고 평범한 CPU에서 실시간으로 돌아갈 만큼 작다. 참고로 XTTS-v2는 ~1.5B, Bark는 ~900M 수준.
- **기본 제공 31개 언어**: 아랍어, 불가리아어, 크로아티아어, 체코어, 덴마크어, 네덜란드어, 영어, 에스토니아어, 핀란드어, 프랑스어, 독일어, 그리스어, 힌디어, 헝가리어, 인도네시아어, 이탈리아어, **일본어**, **한국어**, 라트비아어, 리투아니아어, 폴란드어, 포르투갈어, 루마니아어, 러시아어, 슬로바키아어, 슬로베니아어, 스페인어, 스웨덴어, 터키어, 우크라이나어, **베트남어**.
- **44.1kHz 오디오 출력** — 대부분의 "그럭저럭" TTS가 머무는 22kHz가 아니라 진짜 스튜디오 샘플레이트.
- **10개 표현 태그** — `<laugh>`, `<breath>`, `<sigh>` 등. 텍스트 안에 그대로 박아 넣으면 음성 클로닝을 다시 학습할 필요 없이 더 자연스러운 전달을 끌어낼 수 있다.
- **`lang="na"` 모드** — 언어 코드를 굳이 고르고 싶지 않을 때 쓰는 언어 비종속(language-agnostic) 생성.

라이선스: **코드는 MIT, 모델 가중치는 OpenRAIL-M**. 이 분리가 중요하다. OpenRAIL-M은 "책임 있는 AI" 라이선스로 일부 유해 용도를 제한하지만 상업적 배포는 허용한다. 제품으로 출시하기 전엔 model card를 꼭 읽어둬라.

---

## 성능 수치

Supertone Inc.가 자사 benchmark와 README에서 인용한 수치들:

| 지표 | Supertonic | 일반 베이스라인 |
|---|---|---|
| 파라미터 수 | 99M | 0.7B–2B |
| 발음 정확도 (Minimax-MLS-test, WER/CER) | 훨씬 큰 모델 대비 경쟁력 | — |
| 런타임 메모리 | GPU 베이스라인 대비 현저히 적음 | — |
| Onyx Boox Go 6 e-reader(비행기 모드) RTF | 0.3배 | 해당 없음 (실행 불가) |
| CPU 지연 | A100 GPU 베이스라인과 경쟁력 | — |

e-reader benchmark가 헤드라인 수치다 — "정말 어디서든 돌아간다"는 시그널을 보내는 종류의 숫자. 최신 스마트폰 CPU라면 이것에 비하면 식은 죽 먹기여야 한다.

---

## 런타임 커버리지

Supertonic은 "알아서 래핑하시오" 식이 아니라 실제 SDK 바인딩을 함께 출시하는 몇 안 되는 오픈 TTS 프로젝트 중 하나다. v2.0.0 기준:

- **Python** (`pip install supertonic`) — 1차 통합
- **Node.js** — 서버 및 Electron 앱
- **Browser** — 가능하면 WebGPU, 폴백은 WebAssembly
- **Java** — Android 및 JVM 백엔드
- **C++**, **C#**, **Go**, **Rust** — 시스템 통합
- **Swift / iOS** — 퍼스트파티 네이티브 바인딩
- **Flutter** — 크로스플랫폼 모바일

2026년 애플리케이션 개발자가 TTS를 임베드하려는 거의 모든 자리를 커버한다. 무거운 일은 ONNX 런타임이 떠맡고, Supertonic은 모델별 접착제(glue)만 더한다.

---

## 빠른 설치 (Python)

```bash
pip install supertonic
```

의존성은 이것 하나로 끝. 모델은 첫 호출 시 다운로드된다:

```python
from supertonic import TTS

tts = TTS(auto_download=True)
style = tts.get_voice_style(voice_name="M1")

text = "Supertonic is a lightning fast, on-device TTS system."

wav, duration = tts.synthesize(
    text=text,
    lang="en",
    voice_style=style,
    total_steps=8,
    speed=1.05,
)
tts.save_audio(wav, "output.wav")
```

한국어가 필요하면 `lang="en"` → `lang="ko"`로 바꾸면 된다. `ja`, `vi`, `zh`도 동일. 보이스 스타일(`M1`)은 언어가 바뀌어도 일관성을 유지한다 — 다국어 캐릭터 음성을 만들 때 유용하다.

표현 태그를 쓰려면:

```python
text = "I can't believe it. <laugh> That's incredible. <breath> Let me explain."
```

모델이 태그를 텍스트 안에서 해석해 그에 맞는 표현을 음성에 입혀준다.

---

## 다른 솔루션과의 비교

2026년 온디바이스 TTS 지형을 실제 결과물 기준으로 줄 세워보면:

### vs. Piper (40K+ stars)
Piper는 온디바이스 TTS의 오랜 강자다. **Piper의 우위**: 보이스당 모델이 더 작다(수 MB), 영어 전용 케이스에서 배포가 더 단순. **Supertonic의 우위**: 훨씬 많은 언어, 더 강한 표현 제어, 더 높은 샘플레이트, 언어마다 모델 하나가 아니라 단일 모델로 전 언어를 처리.

### vs. XTTS-v2 (Coqui)
XTTS-v2는 보이스 클로닝을 제공하지만 Supertonic은 이를 셀링 포인트로 내세우지 않는다. **XTTS-v2의 우위**: 보이스 클로닝 품질. **Supertonic의 우위**: CPU에서의 실용성, 멀티 런타임 SDK, 모델 크기, 라이선스 명확성.

### vs. Bark (Suno)
Bark는 비음성 오디오(음악, 효과음)에서 인상적이다. **Bark의 우위**: 음성 너머의 스타일 폭. **Supertonic의 우위**: 속도, 배포 용이성, 그리고 Bark가 영어 위주인 반면 31개 언어 지원.

### vs. ElevenLabs / OpenAI / Google Cloud
보이스 클로닝 충실도와 최상위 음성의 순수 자연스러움에서는 클라우드 TTS가 여전히 앞선다. **Supertonic의 우위**: API 키 없음, 문자당 청구서 없음, 네트워크 의존성 없음, 완전한 프라이버시.

---

## Supertonic이 못 하는 것

기대치를 맞추기 위해:

- **샘플 기반 보이스 클로닝 없음.** 내장된 보이스 스타일 중에서 골라야 한다. 클로닝이 필요하면 XTTS-v2나 상용 API를 봐라.
- **토큰 단위 스트리밍 합성 없음** — 공개 릴리스에서는 합성이 세그먼트 단위로만 이뤄진다.
- **파인튜닝 도구가 제한적.** 모델 가중치는 OpenRAIL-M으로 오픈되어 있지만 학습 파이프라인 전체가 공개되어 있진 않다.
- **22kHz 폴백 없음.** 항상 44.1kHz 출력. 더 낮은 대역폭이 필요하면 직접 리샘플해야 한다.

---

## Supertonic이 빛나는 실전 케이스

- **음성 기능을 가진 모바일 앱** — 온보딩 내레이션, 접근성 읽어주기, 언어 학습. 단일 ONNX 파일 하나 묶으면 31개 언어 지원, 바이너리에 API 키 박을 일도 없다.
- **의료·법률 도구** — 민감 문서를 디바이스 밖으로 한 발자국도 내보내지 않고 음성으로 읽어줄 수 있다.
- **차량 및 기내 시스템** — 완전 오프라인 지원, graceful degradation 따위 신경 쓸 필요 없음.
- **한국어 / 일본어 / 베트남어 / 중국어 로컬라이제이션** — 아시아 언어용 오픈소스 TTS의 공백은 그동안 뼈아팠는데, Supertonic이 모델 하나로 그 큰 덩어리를 메운다.
- **엣지 IoT 디바이스** — 클라우드 연결 없는 키오스크, 사이니지, 스마트 스피커.

---

## 누가 써야 하나

**그렇다, 설치해라, 만약 당신이:**
- 음성 출력이 필요한 앱을 배포하는데 사용량에 비례해 늘어나는 클라우드 청구서가 싫다.
- 프라이버시(규제 산업)나 오프라인(모바일, 기내, 엣지)이 필요하다.
- 비영어권 시장용 로컬라이즈를 하는데 모델 서른 개보다 하나로 끝내고 싶다.
- GPU 없이 스튜디오급 44.1kHz 오디오를 뽑고 싶다.

**클라우드 TTS를 유지해라, 만약 당신이:**
- 30초 샘플로 보이스 클로닝을 해야 한다.
- ElevenLabs 라인업 최상위가 여전히 앞서는 초사실적 단일 보이스 콘텐츠를 만든다.
- 스트리밍 부분 오디오가 필요하다(공개된 Supertonic 릴리스는 아직 노출하지 않음).

---

## 결론

Supertonic은 2026년에 출시된 "어디서든 돌아가는 단일 모델" 오픈 TTS 중 가장 신뢰할 만한 후보다. 99M 파라미터 규모, 31개 언어, 멀티 런타임 SDK, e-reader에서의 0.3배 RTF — 이 조합은 그동안 거의 어떤 오픈 TTS도 도달하지 못한 "그래, 이거 모바일 앱에 그대로 박아도 된다" 영역에 Supertonic을 단단히 올려놓는다.

한국·일본·베트남, 그 외 TTS 지원이 박했던 언어 시장의 개발자들에게 더 큰 이야기는 따로 있다: 오픈소스 TTS와 클라우드 API 사이의 품질 격차가 극적으로 좁혀졌다는 사실. 5년 전엔 영어만이 오픈 TTS로 프로덕션이 가능한 유일한 언어였다. 2026년, Supertonic과 함께 그 명단은 이제 세계 대부분의 언어를 진짜로 포함한다.

프롬프트 측은 [온디바이스 LLM 런타임](https://dibi8.com/kr/resources/llm-frameworks/local-llm-runner-comparison-2026/)과 묶으면, 클라우드 의존도 0인 완전 로컬 음성 에이전트 스택이 완성된다.

---

**GitHub**: [supertone-inc/supertonic](https://github.com/supertone-inc/supertonic) · **라이선스**: MIT (코드) / OpenRAIL-M (가중치) · **최신**: v2.0.0 (2026-01-06) · **Stars**: 9.9K+ · **메인테이너**: Supertone Inc.
