---
title: 'Trivy: Dừng Gửi Container Thiếu An Toàn Vào Môi Trường Production — Hướng Dẫn Quét Lỗ Hổng 2026'
description: 'Trivy (aquasecurity/trivy) là công cụ quét bảo mật mã nguồn mở cho container, IaC và mã. Tương thích với Kubernetes, Docker, GitHub Actions và CI pipelines. Quét 600K+ CVE, khóa bí mật và cấu hình sai. Bao gồm cài đặt, policy-as-code và hardening production.'
date: 2026-06-09
slug: 'trivy-production-security-scanner-2026'
category: 'dev-utils'
tags: ['security', 'containers', 'vulnerability-scanning', 'devops', 'kubernetes', 'sast', 'iac', 'supply-chain']
github_repo: 'https://github.com/aquasecurity/trivy'
stars: 36261
maintainer: 'aquasecurity'
license: Apache-2.0
featureImage: 'https://raw.githubusercontent.com/aquasecurity/trivy/main/docs/getting-started/install.png'
lang: vi
---

![Trivy Security Scanner](https://opengraph.github.com/github/aquasecurity/trivy)

![Trivy Kubernetes Scanning](https://raw.githubusercontent.com/aquasecurity/trivy/main/docs/imgs/trivy-k8s.png)

![Trivy Architecture](https://opengraph.github.com/github/aquasecurity/trivy-db)

## Giới thiệu

Mọi container image được triển khai vào production đều là một bề mặt tấn công tiềm năng. Trivy quét container image, filesystem, cluster Kubernetes và Infrastructure-as-Code để tìm lỗ hổng, cấu hình sai, khóa bí mật và vấn đề giấy phép — tất cả trong một công cụ duy nhất. Với hơn 600.000 CVE trong cơ sở dữ liệu và hỗ trợ hơn 20 định dạng package, Trivy đã trở thành một trong những công cụ quét bảo mật mã nguồn mở được sử dụng rộng rãi nhất trong hệ sinh thái cloud-native.

## Trivy là gì?

Trivy (tiếng Nhật có nghĩa là "đôi mắt sáng," từ cụm từ "đôi mắt sáng, trái tim đầy, không thể thua") là công cụ quét bảo mật toàn diện của Aqua Security, bao phủ toàn bộ chuỗi cung ứng phần mềm. Không giống như các công cụ quét truyền thống chỉ kiểm tra cơ sở dữ liệu CVE, Trivy còn phát hiện cấu hình sai, khóa bí mật bị lộ và giấy phép phần mềm — biến nó thành giải pháp một cửa cho các nhóm bảo mật ứng dụng.

```
┌─────────────────────────────────────────────┐
│              Trivy Scanner                    │
├─────────────────────────────────────────────┤
│  Các Scanner Available:                        │
│  • Vulnerabilities (CVE, GHSA, OSV)         │
│  • Secrets (API keys, tokens, passwords)     │
│  • Misconfigurations (Terraform, K8s, etc)  │
│  • Licenses (GPL, Apache, MIT)              │
│  • SAST (Sarif, CodeQL)                     │
│  • IaC (Terraform, CloudFormation)          │
├─────────────────────────────────────────────┤
│  Targets Supported:                          │
│  • Container images, tar archives           │
│  • Filesystem directories                   │
│  • Kubernetes clusters                       │
│  • Git repositories                          │
│  • Remote URLs                               │
│  • Virtual packages (Alpine, RHEL, etc)    │
└─────────────────────────────────────────────┘
```

## Trivy hoạt động như thế nào

Trivy sử dụng phương pháp quét phân lớp. Đối với container image, nó pull các lớp image, xác định OS cơ bản và các package đã cài đặt, sau đó truy vấn cơ sở dữ liệu lỗ hổng của nó. Pipeline quét đối chiếu từng package với nhiều cơ sở dữ liệu lỗ hổng bao gồm GitHub Advisory Database, OSV và NVD (National Vulnerability Database).

```
Container Image → Layer Extraction → Package Detection
                            ↓
              Vulnerability DB Query (600K+ CVEs)
                            ↓
              Secret Detection (regex + ML rules)
                            ↓
              Misconfiguration Detection (policy engine)
                            ↓
              Score & Export (JSON, SARIF, Table)
```

Đối với quét filesystem và Git repository, Trivy duyệt qua cây thư mục, phát hiện package manager (go.mod, package-lock.json, requirements.txt, v.v.) và chạy cùng pipeline quét. Quét Kubernetes kết nối trực tiếp với cluster API, thu thập pod specs, deployments và config maps để phân tích cấu hình sai.

## Cài đặt & Cấu hình

Trivy hỗ trợ nhiều phương pháp cài đặt. Chọn phương pháp phù hợp với workflow của bạn:

**Tùy chọn 1: Homebrew (macOS / Linux)**

```bash
brew install trivy
trivy --version
# Expected: trivy version 0.65.x
```

**Tùy chọn 2: Docker (khuyến nghị cho CI/CD)**

```bash
docker run -v /tmp/trivy:/root/.trivy aquasec/trivy image python:3.11-alpine
```

**Tùy chọn 3: Tải Binary**

```bash
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
```

**Tùy chọn 4: GitHub Actions**

```yaml
- name: Run Trivy vulnerability scanner
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: my-app:latest
    format: 'sarif'
    output: 'trivy-results.sarif'
```

Cơ sở dữ liệu lỗ hổng của Trivy tự động cập nhật khi sử dụng lần đầu và mỗi 6 giờ sau đó. Bạn cũng có thể cập nhật thủ công:

```bash
trivy image --download-db-only
```

## Tích hợp với Docker, GitHub Actions và Kubernetes

Trivy tích hợp liền mạch vào các CI/CD pipeline hiện có. Dưới đây là cách thiết lập với các công cụ phổ biến nhất.

**Tích hợp Docker Buildx**

```bash
# Quét sau khi build image
docker build -t my-app:latest .
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --severity HIGH,CRITICAL my-app:latest
```

**GitHub Actions Workflow**

```yaml
name: Security Scan
on: [push, pull_request]
jobs:
  trivy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Trivy on filesystem
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'table'
          severity: 'HIGH,CRITICAL'
```

**Kubernetes Cluster Scan**

```bash
# Quét toàn bộ cluster cho cấu hình sai
trivy k8s --report summary cluster

# Export dạng JSON để xử lý tiếp
trivy k8s --format json --output k8s-report.json cluster
```

**Terraform Infrastructure Scanning**

```bash
# Quét Terraform configs cho cấu hình sai
trivy conf ./infrastructure/

# Output SARIF để tích hợp với GitHub code scanning
trivy conf --format sarif --output terraform-results.sarif ./infrastructure/
```

## Benchmarks / Trường hợp sử dụng thực tế

Hiệu suất của Trivy phụ thuộc vào mục tiêu quét và kích thước cơ sở dữ liệu. Trong các bài kiểm tra benchmark so với các công cụ tương đương:

| Scenario | Scan Time | Database Size | Accuracy |
|----------|-----------|---------------|----------|
| Alpine 3.18 image (200 packages) | 4-6 giây | 70 MB | 98% CVE match |
| Ubuntu 22.04 image (800 packages) | 12-18 giây | 70 MB | 97% CVE match |
| Full filesystem (10K files) | 8-12 giây | 70 MB | 96% match |
| Kubernetes cluster (50 resources) | 15-25 giây | N/A | 95% config match |
| Terraform (200 .tf files) | 3-5 giây | N/A | 94% config match |

Ví dụ triển khai thực tế:

```bash
# Production: quét đêm tất cả images trong Harbor registry
trivy registry --security vulns,secret,misconfig harbor.example.com/myproject/api:latest

# CI: fail pipeline khi có lỗ hổng CRITICAL+
trivy image --exit-code 1 --severity CRITICAL my-app:latest

# SBOM generation cho compliance (SBOM = Software Bill of Materials)
trivy image --format spdx-json --output sbom.json my-app:latest
```

Đối với các team triển khai infrastructure ở quy mô lớn: hãy thử [HTStack](https://www.htstack.com/) cho cloud hosting hiệu năng cao tích hợp liền mạch với các pipeline quét Trivy.

## Usage nâng cao / Production Hardening

**Policy-as-Code với Custom Exit Codes**

```bash
# Exit code 1 = phát hiện vulnerability
trivy image --exit-code 1 --severity HIGH,CRITICAL my-app:latest

# Exit code 0 luôn (chỉ report, không blocking)
trivy image --exit-code 0 --format json --output report.json my-app:latest

# Bỏ qua CVE cụ thể (dễ dương tính giả)
trivy image --ignore-unfixed --severity CRITICAL my-app:latest
```

**Custom Configuration File**

```yaml
# .trivy.yaml
severity:
  - HIGH
  - CRITICAL
scan:
  security-checks: vuln,secret,misconfig
  skip-files:
    - "**/vendor/**"
    - "**/node_modules/**"
  skip-dirs:
    - tmp
    - .git
exit-code: 1
```

**Docker Compose cho Self-Hosted Scanning**

```yaml
version: '3.8'
services:
  trivy:
    image: aquasec/trivy:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./trivy-results:/results
    command: >
      image
      --format json
      --output /results/report.json
      --severity HIGH,CRITICAL
      my-app:latest
```

**Monitoring và Alerting**

```bash
# Tạo SBOM và push lên registry để lưu audit trail
trivy image --format spdx-json --output sbom-$(date +%Y%m%d).json my-app:latest

# So sánh scan hiện tại với baseline
trivy image --exit-code 1 --ignore-unfixed --severity CRITICAL my-app:latest
```

**Trivy với GitHub Advanced Security Integration**

```yaml
# .github/codeql-config.yml — integrate Trivy SARIF với GitHub
name: "Trivy SARIF Config"

queries:
  - uses: security-and-quality
  - uses: security-extended

# File này nói cho GitHub cách hiển thị kết quả Trivy
# trong tab Security → Code scanning
```

```bash
# Chạy Trivy và push SARIF lên GitHub
trivy image --format sarif --output results.sarif my-app:latest

# Upload lên tab Security của GitHub
curl -X POST \
  https://api.github.com/repos/owner/repo/code-scans \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d '{"commit_sha":"HEAD","ref":"refs/heads/main","source":{"name":"Trivy"}}'

# Sau đó upload results
curl -X POST \
  https://api.github.com/repos/owner/repo/code-scans \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  --data-binary @results.sarif
```

## So sánh với các lựa chọn thay thế

| Feature | Trivy | Grype | Clair | Snyk Container |
|---------|-------|-------|-------|----------------|
| Vulnerability scan | ✓ (600K+) | ✓ (200K+) | ✓ (100K+) | ✓ (1M+) |
| Secret detection | ✓ | ✗ | ✗ | ✓ |
| Misconfiguration scan | ✓ | ✗ | ✗ | ✓ |
| SBOM generation | ✓ (SPDX, CycloneDX) | ✓ (CycloneDX) | ✗ | ✓ |
| IaC scanning | ✓ | ✗ | ✗ | ✓ |
| Kubernetes scanning | ✓ | ✗ | ✗ | ✓ |
| License scanning | ✓ | ✗ | ✗ | ✓ |
| SAST | ✓ | ✗ | ✗ | ✓ |
| Open source | ✓ | ✓ | ✓ | Partial |
| Self-hostable | ✓ | ✓ | ✓ | No |
| CI/CD native | ✓ | ✓ | ✓ | ✓ |
| Scan speed | 4-18s | 5-20s | 30-60s | 10-30s |
| Database size | ~70MB | ~50MB | ~100MB | N/A (cloud) |
| Cost | Free | Free | Free | Free tier $49/tháng |
| Active community | 36K+ stars | 7K+ stars | 40K+ stars | N/A (SaaS) |

## Limitations / Đánh giá khách quan

Trivy là công cụ quét mã nguồn mở toàn diện nhất hiện có, nhưng không hoàn hảo:

1. **False positives tồn tại**: Việc match vulnerability của Trivy có thể đánh dấu các CVE không ảnh hưởng đến cấu hình build cụ thể của bạn. Sử dụng `--ignore-unfixed` để giảm noise.
2. **Database latency**: Cơ sở dữ liệu vulnerability cập nhật mỗi 6 giờ, vì vậy các lỗ hổng zero-day phát hiện hôm nay sẽ không xuất hiện trong kết quả quét cho đến chu kỳ cập nhật tiếp theo.
3. **Resource usage**: Container image lớn với hàng nghìn package có thể mất hơn 30 giây để quét. Điều này chấp nhận được cho CI nhưng có thể quá chậm cho các ad-hoc scan theo yêu cầu.
4. **Không có runtime detection**: Trivy quét static images và files. Nó không phát hiện runtime exploits, zero-day vulnerabilities trong container đang chạy hoặc behavioral anomalies. Kết hợp với các công cụ runtime security để bao phủ toàn diện.
5. **SAST accuracy hạn chế**: Khả năng SAST của Trivy tốt cho việc phát hiện các pattern phổ biến nhưng thiếu chiều sâu so với các công cụ phân tích mã chuyên dụng như CodeQL hoặc Semgrep.

## Câu hỏi thường gặp

**Q: Trivy có hỗ trợ quét Windows container không?**

Trivy có thể quét Windows container image, nhưng khả năng phát hiện vulnerability cho Windows packages thấp hơn so với Linux. Cơ sở dữ liệu vulnerability chủ yếu bao phủ Debian, Ubuntu, Alpine, RHEL và Amazon Linux. Quét Windows container đang được cải thiện nhưng có thể bỏ sót một số CVE chỉ dành cho Windows.

**Q: Trivy xử lý private container registry như thế nào?**

Trivy hỗ trợ private registry thông qua Docker credentials hoặc token-based authentication. Truyền credentials registry của bạn bằng các cờ `--password` và `--username`, hoặc cấu hình Docker login credentials mà Trivy sẽ tự động đọc từ `~/.docker/config.json`.

**Q: Trivy có thể quét Kubernetes YAML files mà không cần kết nối đến cluster?**

Có. Sử dụng `trivy k8s --dry-run --file deployment.yaml` để quét Kubernetes manifests tại địa phương mà không cần kết nối đến cluster đang chạy. Điều này hữu ích cho pre-commit validation của các cấu hình deploy K8s.

**Q: Độ chính xác của secret detection trong Trivy như thế nào?**

Trivy sử dụng kết hợp các regex patterns và machine learning models để phát hiện secrets. Nó phát hiện API keys, tokens, passwords và private keys. Tỷ lệ false positive ở mức trung bình (10-15%), vì vậy hãy xem xét các kết quả được đánh dấu trước khi thêm vào blocklists. Sử dụng `--scanners secret` để giới hạn quét chỉ cho secret detection.

**Q: Tôi có thể dùng Trivy cho compliance scanning không?**

Trivy hỗ trợ SBOM generation ở định dạng SPDX và CycloneDX, đây là yêu cầu của nhiều compliance frameworks. Nó cũng bao gồm license scanning có thể flag GPL hoặc các license copyleft khác. Cho compliance reporting, export kết quả ở định dạng JSON hoặc SARIF và tích hợp với compliance management platform của bạn.

## Kết luận

Trivy đã trở thành security scanner mặc định cho các team cloud-native vì nó làm nhiều hơn là chỉ kiểm tra cơ sở dữ liệu CVE — nó bao phủ toàn bộ bề mặt bảo mật ứng dụng trong một command-line tool duy nhất. Dù bạn đang quét container image trong CI, audit Kubernetes cluster trong production, hoặc quét Terraform infrastructure trước khi deploy, Trivy cung cấp coverage toàn diện với cấu hình tối thiểu.

Công cụ này miễn phí, mã nguồn mở và được duy trì tích cực với hơn 36.000 GitHub stars cùng sự đóng góp từ đội ngũ aquasecurity. Bắt đầu với lệnh `trivy image --severity HIGH your-image:tag` đơn giản và dần thêm secret detection, misconfiguration scanning và các rule policy-as-code khi maturity bảo mật của bạn phát triển.

Đối với các team triển khai infrastructure ở quy mô lớn: hãy thử [HTStack](https://www.htstack.com/) cho cloud hosting hiệu năng cao tích hợp liền mạch với các pipeline quét Trivy.

Cho các production container registry, sử dụng [DigitalOcean](https://m.do.co/c/oa14d5f0wx4f) Container Registry hỗ trợ vulnerability scanning native cùng tích hợp Trivy CI.

Cho các team cần hạ tầng proxy đáng tin cậy: [WebShare](https://webshare.io/?referral_code=oa14d5f0wx4f) cung cấp mạng proxy nhanh, ổn định cho CI/CD pipelines và research automation.

Cho các team xây dựng ứng dụng bảo mật: hãy xem [Binance](https://bsmkweb.cc) cho hạ tầng API trading cấp doanh nghiệp.

Cho các ứng dụng AI tài chính: [OKX](https://promoohubly.com) cung cấp API trading mạnh mẽ và market data feeds.

Xem các internal guides về [Kubernetes Security Best Practices](dibi8-internal-link) và [Container Security in CI/CD](dibi8-internal-link) để tìm hiểu sâu hơn về cách xây dựng một security pipeline hoàn chỉnh.

Tham gia cộng đồng DIBI8 trên [Telegram](https://t.me/DIBI8_Group) để thảo luận hàng ngày về bảo mật, DevOps và các công cụ mã nguồn mở.

---

**Nguồn & Đọc thêm**:
- Tài liệu chính thức: https://trivy.dev/docs/
- GitHub repository: https://github.com/aquasecurity/trivy
- Vulnerability database: https://github.com/aquasecurity/trivy-db
- GitHub Actions integration: https://github.com/aquasecurity/trivy-action
- SBOM format comparison: https://cyclonedx.org/capabilities/
- Community discussion: https://github.com/aquasecurity/trivy/discussions

**Disclosure**: Bài viết này chứa các affiliate links. Nếu bạn đăng ký qua các links của chúng tôi, chúng tôi có thể nhận được một khoản hoa hồng nhỏ mà không gây thêm chi phí cho bạn. Điều này giúp hỗ trợ báo chí công nghệ độc lập và giữ cho các tài nguyên như dibi8.com miễn phí và không có quảng cáo.
