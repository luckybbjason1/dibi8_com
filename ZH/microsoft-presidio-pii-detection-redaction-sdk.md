---
lang: zh
slug: microsoft-presidio-pii-detection-redaction-sdk
title: Presidio 评论：微软的开源个人身份信息检测和数据脱敏框架（9.4K 星）
description: 'Presidio（在 GitHub 上有 9.4K+ 星）由微软开发，是一个开源框架，用于检测、编辑、掩码和匿名化文本、图像及结构化数据中的敏感数据（PII）。支持自然语言处理（NLP）、正则表达式、基于规则的识别、DICOM 图像编辑以及可自定义的处理流程。采用 MIT 许可证，获得 OpenSSF 最佳实践认证。'
date: 2026-06-22 00:00:00+08:00
lastmod: 2026-06-22 00:00:00+08:00
tech_stack:
  - Python 3.8+
  - spaCy
  - Transformers
  - Docker
  - PySpark
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/microsoft/presidio'
last_maintained: '2026-06-21'
draft: false
categories: ['dev-utils']
tags: ["要塞", "个人身份信息检测", "数据脱敏", "数据匿名化", "微软", "自然语言处理", "命名实体识别", "图像编辑", "DICOM", "通用数据保护法规", "健康保险可携性和责任法案", "打开-ssf", "隐私", "数据保护"]
aliases:
- /posts/microsoft-presidio-pii-detection-redaction-sdk/
faqs:
  - q: '微软 Presidio 是什么？'
    a: 'Presidio 是微软推出的一个开源 SDK，用于在文本、图像和结构化数据中检测、编辑、掩码和匿名化个人身份信息（PII）。它的名称来源于拉丁语“保护”或“要塞”，提供上下文感知的、可插拔且可定制的 PII 去标识化模块。它支持命名实体识别（NER）、正则表达式、基于规则的逻辑和多语言的校验和验证。'
  - q: 'Presidio由哪些组件构成？'
    a: 'Presidio 包含四个主要组件：(1) **Presidio 分析器** — 使用定义好的或自定义的识别器，通过命名实体识别（NER）、正则表达式、基于规则的逻辑和校验和检测文本中的个人可识别信息（PII）；(2) **Presidio 匿名化器** — 对检测到的 PII 进行编辑、遮蔽、哈希或用可配置的转换替换；(3) **Presidio 图像编辑器** — 从图像中编辑 PII，包括标准图像类型和 DICOM 医学图像；(4) **Presidio 结构化模块** — 检测表格/结构化数据中的 PII，如 CSV 和 Excel 文件。'
  - q: 'Presidio 可以检测哪些类型的个人身份信息（PII）？'
    a: 'Presidio 可以检测信用卡号码、姓名、地址、社会保障号码、比特币钱包、美国电话号码、财务数据、电子邮件地址、IP 地址、信用卡号码等。它支持预定义的识别器和自定义识别器。基于 NER 的识别器使用 spaCy 和 HuggingFace transformers，并且你可以添加自定义正则表达式模式、基于规则的逻辑，或者连接到外部 PII 检测模型。'
  - q: 'Presidio可以免费用于商业用途吗？'
    a: '是的。Presidio 在 MIT 许可证下获得许可，这允许个人和商业用途的免费使用、修改和分发。它还获得了 OpenSSF 最佳实践徽章认证，表明其符合严格的开源安全和维护标准。'
  - q: 'Presidio 如何处理图像编辑？'
    a: 'Presidio 图像编辑器使用计算机视觉模型检测并编辑图像中的个人身份信息（PII）。它支持标准图像格式（PNG、JPEG 等）和 DICOM 医学图像。编辑可以将检测到的文本替换为黑色方框、模糊区域或完全删除文本。这对于需要在共享或发布前匿名化医学影像数据的医疗机构尤其有价值。'
  - q: 'Presidio 能否在大规模生产环境中运行？'
    a: '是的。Presidio 支持多种部署选项：Python 或 PySpark 工作负载、Docker 容器以及 Kubernetes 部署。分析器和匿名化工具可以作为 REST API 运行，结构化组件可以处理大型表格数据集。它设计用于跨多个平台的全自动和半自动 PII 去标识化流程。'
featureImage: /images/articles/pii-detection-redaction-7b4e12.png
---



## Why PII Detection Matters More Than Ever

每个处理用户数据的组织都面临同样日益增长的挑战：**知道敏感信息存储在哪里并保护它**。客户支持聊天中的信用卡号码。人力资源文件中的社会保障号码。医疗影像中的患者姓名。营销数据库中的电子邮件地址。

在大规模情况下，手动审核是不可能的。没有合适的工具，自动检测容易出错。而且监管要求——GDPR、HIPAA、CCPA、PCI-DSS——要求组织证明他们能够在每种数据类型和格式中识别和保护个人可识别信息（PII）。

**[Microsoft Presidio](https://github.com/microsoft/presidio)**（GitHub：`microsoft/presidio`，**9,397+ 星**）是针对该问题最广泛采用的开源解决方案。它最初由微软于2019年发布，已经发展成为一个成熟的、经过生产测试的框架，能够处理文本、图像、结构化数据和医学影像——所有这些都在宽松的 MIT 许可证下。

Presidio 提供用于文本、图像和结构化数据中私人实体的**快速识别和匿名化模块**。它具有上下文感知功能，可插拔，并可根据特定业务需求进行定制。

## Presidio Architecture

Presidio 被组织为四个主要组件，每个组件处理不同的数据类型和处理阶段：

```
presidio/
├── presidio-analyzer/     # PII detection in text (NER + regex + rules)
├── presidio-anonymizer/   # PII redaction/transformation in text
├── presidio-image-redactor/ # PII redaction in images (incl. DICOM)
├── presidio-structured/   # PII detection in tabular data (CSV, Excel)
└── docs/                  # Full documentation and samples
```

### Presidio Analyzer — The Detection Engine

分析器是Presidio的核心。它使用多种识别策略检测文本中的个人身份信息（PII）:

| Strategy | Description | Example |
|----------|-------------|---------|
| **Named Entity Recognition (NER)** | ML models that identify entities like persons, organizations, locations | "John Smith went to New York" → PERSON: John Smith, GPE: New York |
| **Regular Expressions** | Pattern matching for structured data formats | Credit card numbers, email addresses, phone numbers |
| **Rule-Based Logic** | Custom business rules and contextual analysis | Detecting "SSN:" followed by a 9-digit number |
| **Checksum Validation** | Verifies data integrity for known formats | Luhn algorithm for credit card numbers |
| **External Models** | Connection to third-party PII detection services | Commercial NER APIs, custom models |

分析器支持多种语言，并且可以通过自定义识别器进行扩展。您可以定义对您的组织重要的个人身份信息类型，Presidio 会围绕这些类型构建检测管道。

### Presidio Anonymizer — The Transformation Engine

一旦检测到个人可识别信息（PII），匿名器将应用转换：

| Transformation | What It Does | Use Case |
|---------------|-------------|----------|
| **Redact** | Replace with placeholder (e.g., `[PHONE_NUMBER]`) | General-purpose masking |
| **Mask** | Hide part of the value (e.g., `***-**-1234`) | Partial obfuscation |
| **Hash** | Replace with cryptographic hash | Analytics-friendly anonymization |
| **Replace** | Substitute with configurable value | Domain-specific replacement |
| **Encrypt** | Encrypt the value with a key | Reversible anonymization |

每个检测到的实体都可以独立转换，并且转换可以串联进行。匿名化工具在删除敏感内容的同时保留文档结构。

### Presidio Image Redactor — Visual PII Removal

图像编辑器将个人身份信息保护扩展到文本之外：

- **标准图像**（PNG、JPEG、WebP）——检测并编辑图像中可见的文字
- **DICOM 医学图像**——专门用于医疗数据匿名化
- **多种编辑方法**——黑色方框、模糊、像素化或完全删除文字

这个组件对于医疗机构、研究机构以及任何需要共享包含敏感信息的图像的团队尤其有价值。

### Presidio Structured — Tabular Data Protection

结构化组件可检测表格数据格式（CSV、Excel、Parquet）中的个人身份信息（PII）。它执行列级分析，识别结构化字段中的PII模式，并生成适合分析和数据共享的匿名版本。

## Installation and Setup

Presidio 可以通过 pip、Docker 或从源码安装：

### Using pip

```bash
pip install presidio-analyzer presidio-anonymizer
pip install presidio-image-redactor
pip install presidio-structured
```

### Using Docker

```bash
docker pull mcr.microsoft.com/presidio-analyzer:latest
docker pull mcr.microsoft.com/presidio-anonymizer:latest
docker pull mcr.microsoft.com/presidio-image-redactor:latest
```

### From Source

```bash
git clone https://github.com/microsoft/presidio.git
cd presidio
pip install -e presidio-analyzer
pip install -e presidio-anonymizer
```

## Basic Usage Examples

### Text PII Detection

```python
from presidio_analyzer import AnalyzerEngine

analyzer = AnalyzerEngine()

text = "John Smith's SSN is 123-45-6789 and his email is john@example.com"
results = analyzer.analyze(text=text, language='en')

for result in results:
    print(f"Entity: {result.entity_type}, "
          f"Score: {result.score:.2f}, "
          f"Position: {result.start}-{result.end}")
```

输出：
```
Entity: PERSON, Score: 0.85, Position: 0-10
Entity: PHONE_NUMBER, Score: 0.95, Position: 26-38
Entity: EMAIL_ADDRESS, Score: 0.99, Position: 57-73
```

### Text PII Anonymization

```python
from presidio_anonymizer import AnonymizerEngine

anonymizer = AnonymizerEngine()

anonymized = anonymizer.anonymize(
    text=text,
    analyzer_results=results,
    operators={
        "DEFAULT": {"operator": "redact"},
        "PERSON": {"operator": "mask", "custom_secret": "XXX"},
        "EMAIL_ADDRESS": {"operator": "hash"}
    }
)

print(anonymized.text)
# "XXX Smith's SSN is *************** and his email is [HASH]"
```

### Image PII Redaction

```python
from presidio_image_redactor import ImageRedactorEngine

redactor = ImageRedactorEngine()

# Redact PII from an image file
redacted_image = redactor.redact_from_image(
    image_path="document.png",
    text_recognition_provider="easyocr"
)

# Save the redacted image
redacted_image.save("redacted_document.png")
```

### Structured Data Anonymization

```python
import pandas as pd
from presidio_structured import StructuredAnalyzerEngine

df = pd.read_csv("customer_data.csv")

analyzer = StructuredAnalyzerEngine()
results = analyzer.analyze(df=df, columns=["name", "email", "phone"])

# Results contain PII detections per column with confidence scores
```

## Custom Recognizers

Presidio 最强大的功能之一是能够为特定领域的数据定义自定义 PII 识别器：

```python
from presidio_analyzer import AnalyzerEngine
from presidio_analyzer.recognizer_registry import RecognizerRegistry
from presidio_analyzer.nlp_engine import NlpEngineProvider

# Define a custom recognizer for employee IDs
class EmployeeIdRecognizer(TextRegexRecognizer):
    NAME = "employee_id"
    DEFAULT_SCORE = 0.85

    def build_regex(self):
        return r"EMP-\d{4}-\d{4}"

    def validate_result(self, list_output):
        # Additional validation logic
        pass

# Register the custom recognizer
registry = RecognizerRegistry()
registry.add_recognizer(EmployeeIdRecognizer())

analyzer = AnalyzerEngine(registry=registry)
results = analyzer.analyze("Employee ID: EMP-1234-5678", language='en')
```

自定义识别器可以利用：
- **正则表达式模式** 用于结构化数据格式
- **上下文关键字**（例如，“SSN:” 前缀）
- **校验码验证**（例如信用卡的 Luhn 算法，ISBN 的 Modulo-11 算法）
- **跨字段验证**（多个字段共同指示PII）

## Deployment Options

Presidio 支持多种部署模式：

### REST API (Docker)

```bash
docker run -d -p 5002:5002 mcr.microsoft.com/presidio-analyzer:latest
docker run -d -p 5001:5001 mcr.microsoft.com/presidio-anonymizer:latest
```

分析器提供 `POST /analyze` 接口，匿名化器提供 `POST /anonymize` 接口。两者都接受包含文本、语言和实体类型规范的 JSON 数据。

### Docker Compose Deployment

对于多组件部署，使用 Docker Compose 一起运行所有 Presidio 服务：

```yaml
version: '3.8'
services:
  analyzer:
    image: mcr.microsoft.com/presidio-analyzer:latest
    ports:
      - "5002:5002"
    environment:
      - PORT=5002

  anonymizer:
    image: mcr.microsoft.com/presidio-anonymizer:latest
    ports:
      - "5001:5001"
    environment:
      - PORT=5001
    depends_on:
      - analyzer

  image-redactor:
    image: mcr.microsoft.com/presidio-image-redactor:latest
    ports:
      - "5003:5003"
    environment:
      - PORT=5003
    depends_on:
      - analyzer
```

使用 `docker compose up -d` 部署，并通过各自的端口访问所有组件。

### Kubernetes

Presidio 容器是为编排而设计的。将每个组件作为单独的服务部署，并根据请求量进行水平 Pod 自动扩展。模块化架构允许独立于匿名化器对分析器进行扩展。

### PySpark Integration

对于大数据工作负载，Presidio 的结构化组件与 PySpark 集成，可在大型数据集上进行分布式的 PII 检测。能够在集群上处理数百万条记录，而无需将数据移动到集中服务。

## Supported PII Entity Types

Presidio 包含用于几十种个人身份信息类型的内置识别器：

| Category | Entity Types |
|----------|-------------|
| **Financial** | CREDIT_CARD, IBAN, PET_CODE, CRYPTO, UK_NHS, US_BANK_NUMBER, US_ITIN, US_DRIVER_LICENSE, US_PASSPORT |
| **Personal** | PERSON, AGE, NRP, RECOGNIZABLE_EVENT_DATE, DATE_TIME |
| **Contact** | EMAIL_ADDRESS, PHONE_NUMBER, US_STATE, ZIP_CODE |
| **Government ID** | US_SSN, TAX_ID_NUMBER, NRP, PASSPORT_NUMBER |
| **Network** | IP_ADDRESS, MAC_ADDRESS |
| **Healthcare** | NRP (Named Recipe/Procedure), US_HEALTHCARE_PROVIDER_NPI |
| **Location** | US_STATE, GEOLOCATION, ADDRESS |

## Comparing Presidio to Alternatives

| Feature | Presidio | OpenNRE | Amazon Comprehend | Google DLP |
|---------|----------|---------|-------------------|------------|
| **License** | MIT (free) | Apache 2.0 | N/A (paid API) | N/A (paid API) |
| **Self-hosted** | Yes | Yes | No | No |
| **Image redaction** | Yes (incl. DICOM) | No | No | No |
| **Structured data** | Yes (CSV/Excel) | No | Limited | Limited |
| **Custom recognizers** | Yes | Limited | No | Partial |
| **Multi-language** | Yes | Yes | Yes | Yes |
| **Offline capable** | Yes | Yes | No | No |
| **OpenSSF certified** | Yes | No | N/A | N/A |
| **Kubernetes ready** | Yes | No | N/A | N/A |

Presidio 是唯一一个将自托管部署、图像编辑（包括医学 DICOM）、结构化数据处理、自定义识别器以及 MIT 许可证——全部整合在一个框架中的解决方案。

## Real-World Applications

### Healthcare Data Anonymization

Presidio 图像编辑器支持 DICOM 医学图像，使其适用于需要共享匿名化医学影像数据的医院和研究机构。基于命名实体识别的文本分析器可以检测临床文档中的患者姓名、病历号和日期。

### Financial Services Compliance

银行和金融科技公司使用 Presidio 来检测和编辑客户通信、交易记录和支持工单中的个人可识别信息（PII）。信用卡的校验和验证以及为专有数据格式定义自定义识别器的能力，使其非常适合受监管的行业。

### Customer Support Data Protection

自动化检测客户支持对话、电子邮件和聊天记录中的个人身份信息（PII）。Presidio 可以实时运行，标记包含敏感数据的对话，或批量处理历史数据以进行合规审计。

### Research Data Sharing

学术机构使用 Presidio 在发布或共享之前对研究数据集进行匿名处理。结构化组件处理表格数据，而文本分析器处理调查响应和访谈记录。

### GDPR/CCPA Compliance

Presidio 为隐私法规所要求的数据主体访问请求、删除权工作流程和数据映射清单提供技术基础。其审计追踪功能记录每一次的检测和转换。

## Custom NER Model Integration

Presidio 支持将默认的 NER 模型替换为特定领域的替代模型：

```python
from presidio_analyzer.nlp_engine import SpacyNlpEngine

# Load a custom spaCy model
custom_nlp = SpacyNlpEngine(
    models=[{"lang": "en", "model": "en_core_web_trf"}]
)

# Or use a HuggingFace transformer model
from presidio_analyzer.nlp_engine import TransformersNlpEngine

transformer_nlp = TransformersNlpEngine(
    transformers_model_name="dslim/bert-base-NER",
    spacy_model_name="en_core_web_sm"
)

analyzer = AnalyzerEngine(nlp_engine=transformer_nlp)
```

特定领域的模型显著提高了对专业实体（如医疗编码、法律术语或金融工具）的检测准确性。在组织的数据上对变换器模型进行微调，然后将其直接接入 Presidio。

## Performance and Scalability

Presidio 的性能特点：

| Component | Throughput | Latency | Notes |
|-----------|-----------|---------|-------|
| **Analyzer (CPU)** | ~100-500 docs/sec | 10-50ms/doc | Depends on NER model size |
| **Analyzer (GPU)** | ~1000-5000 docs/sec | 1-10ms/doc | With transformer acceleration |
| **Anonymizer** | ~1000+ docs/sec | <5ms/doc | Lightweight text transformation |
| **Image Redactor** | ~5-20 imgs/min | Varies | OCR + NER on image text |
| **Structured** | ~10K rows/sec | Varies | Pandas-based, scales with cluster |

在生产部署中，Docker 容器的水平扩展可以应对增加的负载。分析器是计算量最密集的组件，从 GPU 加速中受益最大。

## Limitations and Honest Assessment

Presidio 很出色，但不是灵丹妙药：

1. **命名实体识别（NER）模型的准确性。** 默认的 spaCy 和基于 Transformer 的 NER 模型表现强劲但并不完美。特别是在特定领域的实体中，会出现假阳性和假阴性情况。自定义识别器可以提供帮助，但需要进行维护。

2. **图像编辑质量。** 图像编辑器依赖于OCR的准确性。手写文本、风格化字体和低分辨率图像可能无法被可靠检测。DICOM支持比一般图像编辑更成熟。

3. **没有内置的数据分类功能。** Presidio 可以检测个人身份信息（PII），但不会对数据敏感级别进行分类，也不维护数据清单。它是一个检测和屏蔽工具，而不是完整的数据治理平台。

4. **每次请求只进行单语言命名实体识别（NER）。** 分析器一次处理一种语言。多语言文档需要预处理（语言检测 + 路由）或运行多次分析。

5. **内存占用。** 加载基于 Transformer 的命名实体识别模型需要大量内存（每个模型 2-4GB）。对于高吞吐量部署，模型缓存和批处理是必不可少的。

6. **默认情况下不可逆的匿名化。** 虽然匿名化工具支持基于加密的可逆掩码，但大多数使用场景会产生不可逆的编辑。请相应地规划您的匿名化策略。

## Getting Started

使用Presidio的最快方式：

```bash
# Install all components
pip install presidio-analyzer presidio-anonymizer presidio-image-redactor presidio-structured

# Quick test
python -c "
from presidio_analyzer import AnalyzerEngine
analyzer = AnalyzerEngine()
results = analyzer.analyze(
    text='Call John at 555-123-4567 or email john@example.com',
    language='en'
)
for r in results:
    print(f'{r.entity_type}: {r.start}-{r.end} (score: {r.score:.2f})')
"
```

或者通过 Docker 部署以获得可用于生产的 API：

```bash
docker run -d -p 5002:5002 --name presidio-analyzer mcr.microsoft.com/presidio-analyzer:latest
curl -X POST http://localhost:5002/analyze   -H "Content-Type: application/json"   -d '{"text":"John Smith lives in New York", "language":"en"}'
```

## Conclusion

Microsoft Presidio 是最全面的开源个人身份信息（PII）检测和脱敏框架。它包含四个经过生产测试的组件，覆盖文本、图像、DICOM 医学影像和结构化数据——全部采用宽松的 MIT 许可证，并由 OpenSSF 认证——它是那些需要保护敏感信息而又不希望被供应商锁定的组织的默认选择。

无论您是构建 GDPR 合规管道、匿名化医疗数据、保护客户通信，还是保障研究数据集的安全，Presidio 都提供您所需的检测和转换工具。可扩展的识别器系统允许您添加特定领域的个人识别信息 (PII) 类型，而 Docker/Kubernetes 部署选项使其从第一天起就可以用于生产环境。

对于基础设施，可以考虑 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) 以实现简单的自托管部署，或使用 [HTStack](https://my.htstack.com/aff.php?aff=27187) 进行 GPU 加速的 NER 推理。需要可靠的代理来进行网页抓取和数据收集吗？[WebShare.io](https://www.webshare.io/?referral_code=oa14d5f0wx4f) 提供网络层服务。寻找数据处理优惠？查看 [Bitget Web3](https://web3.bitget.com/share/3Wla0s?inviteCode=irBqLe) 和 [Crypto.com](https://www.bsmkweb.cc/register?aff=dibi8) 的独家优惠。对于营销自动化，[PromoOhLy](https://www.promoohubly.com/join/12190433) 提供强大的漏斗工具。

---

**来源:** [Presidio GitHub](https://github.com/microsoft/presidio) · [文档](https://microsoft.github.io/presidio) · [演示](https://aka.ms/presidio-demo) · [OpenSSF 徽章](https://www.bestpractices.dev/projects/6076)

**加入社区：** [GitHub 讨论](https://github.com/microsoft/presidio/discussions) · [GitHub 问题](https://github.com/microsoft/presidio/issues)

📢 **保持更新：** 加入我们的 [Telegram 群组](https://t.me/DIBI8_Group/2)，获取每日 AI 工具评测和新内容的抢先体验。
