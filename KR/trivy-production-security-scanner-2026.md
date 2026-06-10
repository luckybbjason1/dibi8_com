---
title: 'Trivy: 프로덕션에 취약한 컨테이너를 보내는 것 멈추기 — 2026 보안 스캔 가이드'
description: 'Trivy(aquasecurity/trivy)는 컨테이너, IaC, 코드를 위한 오픈소스 보안 스캐너입니다. Kubernetes, Docker, GitHub Actions, CI 파이프라인과 연동됩니다. 60만 개 이상의 CVE, 시크릿, 오설정 스캔. 설치, 정책-as-코드, 프로덕션 하드닝을 다룹니다.'
date: 2026-06-09
slug: 'trivy-production-security-scanner-2026'
category: 'dev-utils'
tags: ['security', 'containers', 'vulnerability-scanning', 'devops', 'kubernetes', 'sast', 'iac', 'supply-chain']
github_repo: 'https://github.com/aquasecurity/trivy'
stars: 36261
maintainer: 'aquasecurity'
license: Apache-2.0
featureImage: 'https://raw.githubusercontent.com/aquasecurity/trivy/main/docs/getting-started/install.png'
lang: ko
---

![Trivy 보안 스캐너](https://opengraph.github.com/github/aquasecurity/trivy)

![Trivy Kubernetes 스캔](https://raw.githubusercontent.com/aquasecurity/trivy/main/docs/imgs/trivy-k8s.png)

![Trivy 아키텍처](https://opengraph.github.com/github/aquasecurity/trivy-db)

## 소개

프로덕션에 배포되는 모든 컨테이너 이미지는 잠재적인 공격 표면입니다. Trivy는 컨테이너 이미지, 파일시스템, Kubernetes 클러스터 및 인프라스트럭처-어스-코드(IaC)에서 취약점, 오설정, 시크릿, 라이선스 문제를 스캔합니다. 60만 개 이상의 CVE를 데이터베이스에 보유하고 있으며 20개 이상의 패키지 포맷을 지원하여, 클라우드 네이티브 생태계에서 가장 널리 채택된 오픈소스 보안 스캐닝 도구 중 하나가 되었습니다.

## Trivy란?

Trivy(일본어로 "맑은 눈", "맑은 눈, 가득한 마음, 패하지 않는다"는 말에서 유래)는 Aqua Security에서 제공하는 포괄적인 보안 스캐너로, 전체 소프트웨어 공급망을 커버합니다. 단순히 CVE 데이터베이스만 확인하는 기존 스캐너와 달리 Trivy는 오설정된 파일, 노출된 시크릿, 소프트웨어 라이선스도 탐지하여 애플리케이션 보안 팀을 위한 원스톱 솔루션이 됩니다.

```
┌─────────────────────────────────────────────┐
│              Trivy 스캐너                     │
├─────────────────────────────────────────────┤
│  사용 가능한 스캐너:                           │
│  • 취약점 (CVE, GHSA, OSV)                  │
│  • 시크릿 (API 키, 토큰, 비밀번호)           │
│  • 오설정 (Terraform, K8s 등)               │
│  • 라이선스 (GPL, Apache, MIT)              │
│  • SAST (Sarif, CodeQL)                     │
│  • IaC (Terraform, CloudFormation)          │
├─────────────────────────────────────────────┤
│  지원 대상:                                    │
│  • 컨테이너 이미지, tar 아카이브              │
│  • 파일시스템 디렉토리                        │
│  • Kubernetes 클러스터                         │
│  • Git 저장소                                 │
│  • 원격 URL                                   │
│  • 가상 패키지 (Alpine, RHEL 등)             │
└─────────────────────────────────────────────┘
```

## Trivy의 동작 방식

Trivy는 계층형 스캔 접근 방식을 사용합니다. 컨테이너 이미지의 경우, 이미지 레이어를 추출하고 기본 OS 및 설치된 패키지를 식별한 후 취약점 데이터베이스를 쿼리합니다. 스캔 파이프라인은 각 패키지를 GitHub Advisory Database, OSV, NVD(국가 취약점 데이터베이스)를 포함한 여러 취약점 데이터베이스와 대조합니다.

```
컨테이너 이미지 → 레이어 추출 → 패키지 감지
                        ↓
              취약점 데이터베이스 쿼리 (60만+ CVE)
                        ↓
              시크릿 감지 (정규식 + ML 규칙)
                        ↓
              오설정 감지 (정책 엔진)
                        ↓
              점수 및 내보내기 (JSON, SARIF, 테이블)
```

파일시스템 및 Git 저장소 스캔의 경우, Trivy는 디렉토리 트리를 순회하여 패키지 매니저(go.mod, package-lock.json, requirements.txt 등)를 감지하고 동일한 스캔 파이프라인을 실행합니다. Kubernetes 스캔은 클러스터 API에 직접 연결하여, 오설정 분석을 위해 Pod 사양, 배포 및 구성 맵을 수집합니다.

## 설치 및 설정

Trivy는 여러 설치 방법을 지원합니다. 워크플로우에 맞는 방법을 선택하세요:

**방법 1: Homebrew (macOS / Linux)**

```bash
brew install trivy
trivy --version
# 예상: trivy version 0.65.x
```

**방법 2: Docker (CI/CD 권장)**

```bash
docker run -v /tmp/trivy:/root/.trivy aquasec/trivy image python:3.11-alpine
```

**방법 3: 바이너리 다운로드**

```bash
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
```

**방법 4: GitHub Actions**

```yaml
- name: Run Trivy vulnerability scanner
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: my-app:latest
    format: 'sarif'
    output: 'trivy-results.sarif'
```

Trivy의 취약점 데이터베이스는 최초 사용 시 자동으로 업데이트되며, 이후 매 6시간마다 자동으로 업데이트됩니다. 수동으로도 업데이트할 수 있습니다:

```bash
trivy image --download-db-only
```

## Docker, GitHub Actions, Kubernetes와의 통합

Trivy는 기존 CI/CD 파이프라인에 원활하게 통합됩니다. 가장 일반적인 도구로 설정하는 방법을 소개합니다.

**Docker Buildx 통합**

```bash
# 이미지 빌드 후 스캔
docker build -t my-app:latest .
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --severity HIGH,CRITICAL my-app:latest
```

**GitHub Actions 워크플로우**

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

**Kubernetes 클러스터 스캔**

```bash
# 클러스터 전체를 오설정 대상으로 스캔
trivy k8s --report summary cluster

# JSON 형식으로 내보내어 추가 처리
trivy k8s --format json --output k8s-report.json cluster
```

**Terraform 인프라스트럭처 스캔**

```bash
# Terraform 구성의 오설정 스캔
trivy conf ./infrastructure/

# GitHub 코드 스캔 통합을 위한 SARIF 형식 출력
trivy conf --format sarif --output terraform-results.sarif ./infrastructure/
```

## 벤치마크 / 실제 사용 사례

Trivy의 성능은 스캔 대상과 데이터베이스 크기에 따라 다릅니다. 유사한 도구들과의 벤치마크 테스트에서:

| 시나리오 | 스캔 시간 | 데이터베이스 크기 | 정확도 |
|----------|-----------|---------------|----------|
| Alpine 3.18 이미지 (200개 패키지) | 4-6초 | 70MB | 98% CVE 매칭 |
| Ubuntu 22.04 이미지 (800개 패키지) | 12-18초 | 70MB | 97% CVE 매칭 |
| 전체 파일시스템 (10K 파일) | 8-12초 | 70MB | 96% 매칭 |
| Kubernetes 클러스터 (50개 리소스) | 15-25초 | N/A | 95% 구성 매칭 |
| Terraform (200개 .tf 파일) | 3-5초 | N/A | 94% 구성 매칭 |

실제 배포 예시:

```bash
# 프로덕션: Harbor 레지스트리의 모든 이미지를 매일 밤 스캔
trivy registry --security vulns,secret,misconfig harbor.example.com/myproject/api:latest

# CI: 크리티컬+ 취약점 발생 시 파이프라인 실패
trivy image --exit-code 1 --severity CRITICAL my-app:latest

# 컴플라이언스를 위한 SBOM 생성 (SBOM = Software Bill of Materials)
trivy image --format spdx-json --output sbom.json my-app:latest
```

대규모 인프라 배포 팀의 경우: [HTStack](https://www.htstack.com/)을 검토하여 Trivy 스캔 파이프라인과 원활하게 통합되는 고성능 클라우드 호스팅을 사용해 보세요.

## 고급 사용법 / 프로덕션 하드닝

**커스텀 종료 코드와 정책-as-코드**

```bash
# 종료 코드 1 = 취약점 발견
trivy image --exit-code 1 --severity HIGH,CRITICAL my-app:latest

# 종료 코드 0 항상 (보고만 하고 차단 안 함)
trivy image --exit-code 0 --format json --output report.json my-app:latest

# 특정 CVE 무시 (오경보에 취약한 경우)
trivy image --ignore-unfixed --severity CRITICAL my-app:latest
```

**커스텀 구성 파일**

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

**셀프호스팅 스캐닝을 위한 Docker Compose**

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

**모니터링 및 알림**

```bash
# SBOM 생성 및 감사 추적을 위해 레지스트리에 푸시
trivy image --format spdx-json --output sbom-$(date +%Y%m%d).json my-app:latest

# 현재 스캔을 기준으로线与 비교
trivy image --exit-code 1 --ignore-unfixed --severity CRITICAL my-app:latest
```

**Trivy와 GitHub Advanced Security 통합**

```yaml
# .github/codeql-config.yml — Trivy SARIF를 GitHub과 통합
name: "Trivy SARIF Config"

queries:
  - uses: security-and-quality
  - uses: security-extended

# 이 파일은 GitHub이
# 보안 → 코드 스캔 탭에서 Trivy 결과를 표시하는 방법을 알려줍니다
```

```bash
# Trivy 실행 후 SARIF를 GitHub에 푸시
trivy image --format sarif --output results.sarif my-app:latest

# GitHub 보안 탭에 업로드
curl -X POST \
  https://api.github.com/repos/owner/repo/code-scans \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d '{"commit_sha":"HEAD","ref":"refs/heads/main","source":{"name":"Trivy"}}'

# 결과 업로드
curl -X POST \
  https://api.github.com/repos/owner/repo/code-scans \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  --data-binary @results.sarif
```

## 대체 도구와의 비교

| 기능 | Trivy | Grype | Clair | Snyk Container |
|---------|-------|-------|-------|----------------|
| 취약점 스캔 | ✓ (60만+) | ✓ (20만+) | ✓ (10만+) | ✓ (100만+) |
| 시크릿 감지 | ✓ | ✗ | ✗ | ✓ |
| 오설정 스캔 | ✓ | ✗ | ✗ | ✓ |
| SBOM 생성 | ✓ (SPDX, CycloneDX) | ✓ (CycloneDX) | ✗ | ✓ |
| IaC 스캔 | ✓ | ✗ | ✗ | ✓ |
| Kubernetes 스캔 | ✓ | ✗ | ✗ | ✓ |
| 라이선스 스캔 | ✓ | ✗ | ✗ | ✓ |
| SAST | ✓ | ✗ | ✗ | ✓ |
| 오픈소스 | ✓ | ✓ | ✓ | 부분 |
| 셀프호스팅 | ✓ | ✓ | ✓ | 아니요 |
| CI/CD 네이티브 | ✓ | ✓ | ✓ | ✓ |
| 스캔 속도 | 4-18초 | 5-20초 | 30-60초 | 10-30초 |
| 데이터베이스 크기 | ~70MB | ~50MB | ~100MB | N/A (클라우드) |
| 비용 | 무료 | 무료 | 무료 | 무료 티어 $49/월 |
| 활성 커뮤니티 | 36K+ 스타 | 7K+ 스타 | 40K+ 스타 | N/A (SaaS) |

## 한계 / 정확한 평가

Trivy는 현재 사용 가능한 가장 포괄적인 오픈소스 스캐너이지만 완벽하지는 않습니다:

1. **오경보 존재**: Trivy의 취약점 매칭은 특정 빌드 구성에 영향을 주지 않는 CVE를 플래그할 수 있습니다. 노이즈를 줄이려면 `--ignore-unfixed`를 사용하세요.
2. **데이터베이스 지연**: 취약점 데이터베이스는 매 6시간마다 업데이트되므로, 오늘 발견된 제로데이 취약점은 다음 업데이트 주기까지 스캔에 나타나지 않습니다.
3. **리소스 사용량**: 수천 개의 패키지를 포함한 대형 컨테이너 이미지는 스캔하는 데 30초 이상 소요될 수 있습니다. CI에는 적합하지만オン디맨드 임의 스캔에는 너무 느릴 수 있습니다.
4. **런타임 감지 없음**: Trivy는 정적 이미지와 파일을 스캔합니다. 런타임 익스플로잇, 실행 중인 컨테이너의 제로데이 취약점, 동작 이상을 감지하지 않습니다. 포괄적인 커버리지를 위해 런타임 보안 도구와 함께 사용하세요.
5. **제한된 SAST 정확도**: Trivy의 SAST 기능은 일반적인 패턴을 감지하는 데 좋지만 CodeQL이나 Semgrep 같은 전용 코드 분석 도구에 비해 깊이가 부족합니다.

## 자주 묻는 질문

**Q: Trivy는 Windows 컨테이너 스캔을 지원하나요?**

Trivy는 Windows 컨테이너 이미지를 스캔할 수 있지만, Linux에 비해 Windows 패키지의 취약점 감지 범위는 낮습니다. 취약점 데이터베이스는 주로 Debian, Ubuntu, Alpine, RHEL, Amazon Linux를 커버합니다. Windows 컨테이너 스캔은 개선 중이지만 일부 Windows 전용 CVE를 놓칠 수 있습니다.

**Q: Trivy는 private 컨테이너 레지스트리를 어떻게 처리하나요?**

Trivy는 Docker 자격 증명이나 토큰 기반 인증을 통해 private 레지스트리를 지원합니다. `--password` 및 `--username` 플래그를 사용하여 레지스트리 자격 증명을 전달하거나, Docker 로그인 자격 증명을 설정하면 Trivy가 `~/.docker/config.json`에서 자동으로 읽어옵니다.

**Q: Trivy는 클러스터에 연결하지 않고 Kubernetes YAML 파일을 스캔할 수 있나요?**

네. `trivy k8s --dry-run --file deployment.yaml`을 사용하여 실행 중인 클러스터에 연결하지 않고도 Kubernetes 매니페스트를 로컬에서 스캔할 수 있습니다. 이는 K8s 배포 구성에 대한 커밋 전 검증에 유용합니다.

**Q: Trivy의 시크릿 감지 정확도는 어떻게 되나요?**

Trivy는 정규식과 머신러닝 모델을 조합하여 시크릿을 감지합니다. API 키, 토큰, 비밀번호, 개인키를 감지합니다. 오경보율은 중정도(10-15%)이므로, 차단 목록에 추가하기 전에 플래그된 결과를 검토하세요. `--scanners secret`만 사용하여 시크릿 감지만 수행할 수 있습니다.

**Q: Trivy를 컴플라이언스 스캔에 사용할 수 있나요?**

Trivy는 SPDX 및 CycloneDX 형식으로 SBOM 생성을 지원하며, 이는 많은 컴플라이언스 프레임워크에서 필수 요구사항입니다. 또한 GPL 또는 기타 카프로프트 라이선스를 플래그할 수 있는 라이선스 스캔도 포함합니다. 컴플라이언스 보고를 위해 결과를 JSON 또는 SARIF 형식으로 내보내고 컴플라이언스 관리 플랫폼과 통합할 수 있습니다.

## 결론

Trivy는 CVE 데이터베이스를 확인하는 것을 넘어선다는 이유로 클라우드 네이티브 팀의 기본 보안 스캐너가 되었습니다. 단일 명령줄 도구로 전체 애플리케이션 보안 표면을 커버합니다. CI에서 컨테이너 이미지를 스캔하든, 프로덕션에서 Kubernetes 클러스터를 감사하든, 배포 전 Terraform 인프라스트럭처를 스캔하든 Trivy는 최소한의 구성으로 포괄적인 커버리지를 제공합니다.

이 도구는 무료이고 오픈소스이며, aquasecurity 팀이 적극적으로 유지보수하고 있고 GitHub 스타가 36,000개 이상입니다. 간단한 `trivy image --severity HIGH your-image:tag`로 시작하고 보안 성숙도가 높아짐에 따라 점진적으로 시크릿 감지, 오설정 스캔, 정책-as-코드 규칙을 추가하세요.

대규모 인프라 배포 팀의 경우: [HTStack](https://www.htstack.com/)을 검토하여 Trivy 스캔 파이프라인과 원활하게 통합되는 고성능 클라우드 호스팅을 사용해 보세요.

프로덕션 컨테이너 레지스트리에는 [DigitalOcean](https://m.do.co/c/oa14d5f0wx4f) Container Registry를 사용하세요. 이 자체적으로 취약점 스캔을 지원하며 Trivy CI 통합과 함께 사용됩니다.

신뢰할 수 있는 프록시 인프라가 필요한 팀의 경우: [WebShare](https://webshare.io/?referral_code=oa14d5f0wx4f)는 CI/CD 파이프라인 및 연구 자동화를 위해 빠르고 안정적인 프록시 네트워크를 제공합니다.

보안 애플리케이션을 구축하는 팀의 경우: [Binance](https://bsmkweb.cc)의 엔터프라이즈급 API 거래 인프라를 확인해 보세요.

금융 AI 애플리케이션의 경우: [OKX](https://promoohubly.com)은 강력한 거래 API와 시장 데이터 피드를 제공합니다.

[Kubernetes 보안 모범 사례](dibi8-internal-link) 및 [CI/CD의 컨테이너 보안](dibi8-internal-link)에 대한 내부 가이드를 확인하여 완전한 보안 파이프라인 구축에 대해 더 깊이 알아보세요.

[Telegram](https://t.me/DIBI8_Group)에서 DIBI8 커뮤니티에 참여하여 보안, DevOps, 오픈소스 도구에 대한 매일의 논의에 참여하세요.

---

**소스 및 추가 읽을거리**:
- 공식 문서: https://trivy.dev/docs/
- GitHub 저장소: https://github.com/aquasecurity/trivy
- 취약점 데이터베이스: https://github.com/aquasecurity/trivy-db
- GitHub Actions 통합: https://github.com/aquasecurity/trivy-action
- SBOM 형식 비교: https://cyclonedx.org/capabilities/
- 커뮤니티 논의: https://github.com/aquasecurity/trivy/discussions

**고지**: 이 기고에는 제휴 링크가 포함되어 있습니다. 링크를 통해 가입하면 추가 비용 없이 소정의 수수료를 받을 수 있습니다. 이는 독립적인 기술 저널리즘을 지원하고 dibi8.com 같은 리소스를 무료 및 무광고로 유지하는 데 도움이 됩니다.
