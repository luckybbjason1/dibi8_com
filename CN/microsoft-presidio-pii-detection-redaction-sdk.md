---
lang: en
slug: microsoft-presidio-pii-detection-redaction-sdk
title: "Presidio Review: Microsoft's Open-Source PII Detection and Data Redaction Framework (9.4K Stars)"
description: "Presidio (9.4K+ GitHub stars) from Microsoft is an open-source framework for detecting, redacting, masking, and anonymizing sensitive data (PII) across text, images, and structured data. Supports NLP, regex, rule-based recognition, DICOM image redaction, and customizable pipelines. MIT licensed, OpenSSF Best Practices certified."
tags: ["open-source", "self-hosted"]
date: "2026-06-22 00:00:00+08:00"
lastmod: "2026-06-22 00:00:00+08:00"
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
aliases:
- /posts/microsoft-presidio-pii-detection-redaction-sdk/
faqs:
  - q: 'What is Microsoft Presidio?'
    a: 'Presidio is an open-source SDK from Microsoft for detecting, redacting, masking, and anonymizing personally identifiable information (PII) across text, images, and structured data. Named after the Latin word for "protection" or "garrison," it provides context-aware, pluggable, and customizable PII de-identification modules. It supports Named Entity Recognition (NER), regular expressions, rule-based logic, and checksum validation across multiple languages.'
  - q: 'What components make up Presidio?'
    a: 'Presidio consists of four main components: (1) **Presidio Analyzer** — detects PII in text using predefined or custom recognizers leveraging NER, regex, rule-based logic, and checksums; (2) **Presidio Anonymizer** — redacts, masks, hashes, or replaces detected PII with configurable transformations; (3) **Presidio Image Redactor** — redacts PII from images including standard image types and DICOM medical images; (4) **Presidio Structured** — detects PII in tabular/structured data like CSV and Excel files.'
  - q: 'What types of PII can Presidio detect?'
    a: 'Presidio detects credit card numbers, names, locations, social security numbers, Bitcoin wallets, US phone numbers, financial data, email addresses, IP addresses, credit card numbers, and more. It supports both predefined recognizers and custom ones. The NER-based recognizers use spaCy and HuggingFace transformers, and you can add custom regex patterns, rule-based logic, or connect to external PII detection models.'
  - q: 'Is Presidio free to use commercially?'
    a: 'Yes. Presidio is licensed under the MIT license, which allows free use, modification, and distribution for both personal and commercial purposes. It is also certified with the OpenSSF Best Practices badge, indicating it meets rigorous open-source security and maintenance standards.'
  - q: 'How does Presidio handle image redaction?'
    a: 'Presidio Image Redactor uses computer vision models to detect and redact PII from images. It supports standard image formats (PNG, JPEG, etc.) and DICOM medical images. The redaction can replace detected text with black boxes, blur regions, or remove the text entirely. This is particularly valuable for healthcare organizations that need to anonymize medical imaging data before sharing or publication.'
  - q: 'Can Presidio run in production at scale?'
    a: 'Yes. Presidio supports multiple deployment options: Python or PySpark workloads, Docker containers, and Kubernetes deployments. The analyzer and anonymizer can run as REST APIs, and the structured component can process large tabular datasets. It is designed for both fully automated and semi-automated PII de-identification flows across multiple platforms.'
featureImage: /images/articles/pii-detection-redaction-7b4e12.png
---

## Why PII Detection Matters More Than Ever

Every organization that processes user data faces the same growing challenge: **knowing where sensitive information lives and protecting it**. Credit card numbers in customer support chats. Social security numbers in HR documents. Patient names in medical images. Email addresses in marketing databases.

Manual review is impossible at scale. Automated detection is error-prone without the right tools. And regulatory requirements — GDPR, HIPAA, CCPA, PCI-DSS — demand that organizations prove they can identify and protect personally identifiable information (PII) across every data type and format.

**[Microsoft Presidio](https://github.com/microsoft/presidio)** (GitHub: `microsoft/presidio`, **9,397+ stars**) is the most widely adopted open-source solution for this problem. Originally released by Microsoft in 2019, it has grown into a mature, production-tested framework that handles text, images, structured data, and medical imaging — all under the permissive MIT license.

Presidio provides **fast identification and anonymization modules** for private entities in text, images, and structured data. It is context-aware, pluggable, and customizable to specific business needs.

## Presidio Architecture

Presidio is organized into four main components, each addressing a different data type and processing stage:

```
presidio/
├── presidio-analyzer/     # PII detection in text (NER + regex + rules)
├── presidio-anonymizer/   # PII redaction/transformation in text
├── presidio-image-redactor/ # PII redaction in images (incl. DICOM)
├── presidio-structured/   # PII detection in tabular data (CSV, Excel)
└── docs/                  # Full documentation and samples
```

### Presidio Analyzer — The Detection Engine

The Analyzer is the heart of Presidio. It detects PII in text using multiple recognition strategies:

| Strategy | Description | Example |
|----------|-------------|---------|
| **Named Entity Recognition (NER)** | ML models that identify entities like persons, organizations, locations | "John Smith went to New York" → PERSON: John Smith, GPE: New York |
| **Regular Expressions** | Pattern matching for structured data formats | Credit card numbers, email addresses, phone numbers |
| **Rule-Based Logic** | Custom business rules and contextual analysis | Detecting "SSN:" followed by a 9-digit number |
| **Checksum Validation** | Verifies data integrity for known formats | Luhn algorithm for credit card numbers |
| **External Models** | Connection to third-party PII detection services | Commercial NER APIs, custom models |

The Analyzer supports multiple languages and can be extended with custom recognizers. You define what PII types matter to your organization, and Presidio builds detection pipelines around them.

### Presidio Anonymizer — The Transformation Engine

Once PII is detected, the Anonymizer applies transformations:

| Transformation | What It Does | Use Case |
|---------------|-------------|----------|
| **Redact** | Replace with placeholder (e.g., `[PHONE_NUMBER]`) | General-purpose masking |
| **Mask** | Hide part of the value (e.g., `***-**-1234`) | Partial obfuscation |
| **Hash** | Replace with cryptographic hash | Analytics-friendly anonymization |
| **Replace** | Substitute with configurable value | Domain-specific replacement |
| **Encrypt** | Encrypt the value with a key | Reversible anonymization |

Each detected entity can be transformed independently, and transformations can be chained. The Anonymizer preserves the document structure while removing sensitive content.

### Presidio Image Redactor — Visual PII Removal

The Image Redactor extends PII protection beyond text:

- **Standard images** (PNG, JPEG, WebP) — detects and redacts text visible in images
- **DICOM medical images** — specifically designed for healthcare data anonymization
- **Multiple redaction methods** — black boxes, blur, pixelation, or complete text removal

This component is particularly valuable for healthcare organizations, research institutions, and any team that needs to share images containing sensitive information.

### Presidio Structured — Tabular Data Protection

The Structured component detects PII in tabular data formats (CSV, Excel, Parquet). It applies column-level analysis, identifies PII patterns in structured fields, and generates anonymized versions suitable for analytics and data sharing.

## Installation and Setup

Presidio can be installed via pip, Docker, or from source:

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

Output:
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

One of Presidio\'s strongest features is the ability to define custom PII recognizers for domain-specific data:

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

Custom recognizers can leverage:
- **Regex patterns** for structured data formats
- **Contextual keywords** (e.g., "SSN:" prefix)
- **Checksum validation** (Luhn for credit cards, Modulo-11 for ISBN)
- **Cross-field validation** (multiple fields that together indicate PII)

## Deployment Options

Presidio supports multiple deployment patterns:

### REST API (Docker)

```bash
docker run -d -p 5002:5002 mcr.microsoft.com/presidio-analyzer:latest
docker run -d -p 5001:5001 mcr.microsoft.com/presidio-anonymizer:latest
```

The Analyzer exposes `POST /analyze` and the Anonymizer exposes `POST /anonymize`. Both accept JSON payloads with text, language, and entity type specifications.

### Docker Compose Deployment

For multi-component deployments, use Docker Compose to run all Presidio services together:

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

Deploy with `docker compose up -d` and access all components at their respective ports.

### Kubernetes

Presidio containers are designed for orchestration. Deploy each component as a separate service with horizontal pod autoscaling based on request volume. The modular architecture allows scaling the Analyzer independently from the Anonymizer.

### PySpark Integration

For big data workloads, Presidio\'s structured component integrates with PySpark for distributed PII detection across large datasets. Process millions of records across a cluster without moving data to a central service.

## Supported PII Entity Types

Presidio includes built-in recognizers for dozens of PII types:

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

Presidio is the only solution that combines self-hosted deployment, image redaction (including medical DICOM), structured data processing, custom recognizers, and an MIT license — all in one framework.

## Real-World Applications

### Healthcare Data Anonymization

Presidio Image Redactor supports DICOM medical images, making it suitable for hospitals and research institutions that need to share anonymized medical imaging data. The NER-based text analyzer can detect patient names, medical record numbers, and dates in clinical documents.

### Financial Services Compliance

Banks and fintech companies use Presidio to detect and redact PII in customer communications, transaction records, and support tickets. The checksum validation for credit cards and the ability to define custom recognizers for proprietary data formats make it ideal for regulated industries.

### Customer Support Data Protection

Automate PII detection in customer support conversations, emails, and chat logs. Presidio can run in real-time to flag conversations containing sensitive data, or batch-process historical data for compliance audits.

### Research Data Sharing

Academic institutions use Presidio to anonymize research datasets before publication or sharing. The structured component processes tabular data, while the text analyzer handles survey responses and interview transcripts.

### GDPR/CCPA Compliance

Presidio provides the technical foundation for data subject access requests, right-to-erasure workflows, and data mapping inventories required by privacy regulations. Its audit trail capabilities log every detection and transformation.

## Custom NER Model Integration

Presidio supports swapping the default NER models for domain-specific alternatives:

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

Domain-specific models significantly improve detection accuracy for specialized entities like medical codes, legal terms, or financial instruments. Fine-tune a transformer model on your organization\'s data and plug it directly into Presidio.

## Performance and Scalability

Presidio\'s performance characteristics:

| Component | Throughput | Latency | Notes |
|-----------|-----------|---------|-------|
| **Analyzer (CPU)** | ~100-500 docs/sec | 10-50ms/doc | Depends on NER model size |
| **Analyzer (GPU)** | ~1000-5000 docs/sec | 1-10ms/doc | With transformer acceleration |
| **Anonymizer** | ~1000+ docs/sec | <5ms/doc | Lightweight text transformation |
| **Image Redactor** | ~5-20 imgs/min | Varies | OCR + NER on image text |
| **Structured** | ~10K rows/sec | Varies | Pandas-based, scales with cluster |

For production deployments, horizontal scaling of the Docker containers handles increased load. The Analyzer is the most compute-intensive component and benefits most from GPU acceleration.

## Limitations and Honest Assessment

Presidio is excellent but not a silver bullet:

1. **NER model accuracy.** The default spaCy and transformer-based NER models are strong but not perfect. False positives and false negatives occur, especially with domain-specific entities. Custom recognizers help but require maintenance.

2. **Image redaction quality.** The image redactor depends on OCR accuracy. Handwritten text, stylized fonts, and low-resolution images may not be detected reliably. The DICOM support is more mature than general image redaction.

3. **No built-in data classification.** Presidio detects PII but does not classify data sensitivity levels or maintain a data inventory. It is a detection and redaction tool, not a full data governance platform.

4. **Single-language NER per request.** The Analyzer processes one language at a time. Multilingual documents require either preprocessing (language detection + routing) or running multiple analyses.

5. **Memory footprint.** Loading transformer-based NER models requires significant RAM (2-4GB per model). For high-throughput deployments, model caching and batching are essential.

6. **No reversible anonymization by default.** While the Anonymizer supports encryption-based reversible masking, most use cases produce irreversible redactions. Plan your anonymization strategy accordingly.

## Getting Started

The quickest path to using Presidio:

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

Or deploy via Docker for a production-ready API:

```bash
docker run -d -p 5002:5002 --name presidio-analyzer mcr.microsoft.com/presidio-analyzer:latest
curl -X POST http://localhost:5002/analyze   -H "Content-Type: application/json"   -d '{"text":"John Smith lives in New York", "language":"en"}'
```

## Conclusion

Microsoft Presidio is the most comprehensive open-source PII detection and redaction framework available. With four production-tested components covering text, images, DICOM medical imaging, and structured data — all under the permissive MIT license and certified by the OpenSSF — it is the default choice for organizations that need to protect sensitive information without vendor lock-in.

Whether you are building GDPR compliance pipelines, anonymizing healthcare data, protecting customer communications, or securing research datasets, Presidio provides the detection and transformation tools you need. The extensible recognizer system lets you add domain-specific PII types, and the Docker/Kubernetes deployment options make it production-ready from day one.

For infrastructure, consider [DigitalOcean](https://m.do.co/c/eca87ac14ee0) for simple self-hosted deployments or [HTStack](https://my.htstack.com/aff.php?aff=27187) for GPU-accelerated NER inference. Need reliable proxies for web scraping and data collection? [WebShare.io](https://www.webshare.io/?referral_code=oa14d5f0wx4f) provides the networking layer. Looking for data processing deals? Check [Bitget Web3](https://web3.bitget.com/share/3Wla0s?inviteCode=irBqLe) and [Crypto.com](https://www.bsmkweb.cc/register?aff=dibi8) for exclusive offers. For marketing automation, [PromoOhLy](https://www.promoohubly.com/join/12190433) provides powerful funnel tools.

---

**Sources:** [Presidio GitHub](https://github.com/microsoft/presidio) · [Documentation](https://microsoft.github.io/presidio) · [Demo](https://aka.ms/presidio-demo) · [OpenSSF Badge](https://www.bestpractices.dev/projects/6076)

**Join the community:** [GitHub Discussions](https://github.com/microsoft/presidio/discussions) · [GitHub Issues](https://github.com/microsoft/presidio/issues)

📢 **Stay updated:** Join our [Telegram group](https://t.me/DIBI8_Group/2) for daily AI tool reviews and early access to new content.
