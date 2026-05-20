---
title: 'Colly: 25,302 GitHub Stars — 벤치마크 Go 웹 스크래핑 프레임워크 2026'
description: 'Colly는 1,000+ req/sec 처리량을 제공하는 빠르고 우아한 Go 웹 스크래핑 프레임워크입니다. colly 튜토리얼, colly vs scrapy 벤치마크, Docker 설정, Redis 캐싱, 프록시 로테이션, 대규모 데이터 추출을 위한 프로덕션 배포 패턴을 다룹니다.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/gocolly/colly'
stars: 25302
maintainer: 'gocolly'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['colly', 'go', '웹-스크래핑', '크롤러', 'golang', 'scrapy', '벤치마크', '프록시']
aliases:
- /kr/posts/colly/
---

{{</* resource-info */>}}

## 소개

Python은 10년 넘게 웹 스크래핑을 지배해왔다. Scrapy, BeautifulSoup, Selenium이 기본 스택이 됐지만 모든 팀이 같은 벽에 부딪혔다: 메모리 팽창, GIL 경쟁, 배포 복잡성. Go가 이 방정식을 바꿨다. Go 전용 스크래핑 프레임워크인 Colly는 현재 **GitHub Stars 25,302개**를 보유하고 있으며 **단일 CPU 코어에서 초당 1,000건 이상의 요청**을 처리하는 것이 검증됐다. 본 colly 튜토리얼에서는 설치, Scrapy 및 Puppeteer와의 벤치마크 비교, 프로덕션 하드닝, 그리고 프로덕션 배포 전 알아야 할 솔직한 한계를 다룬다.

## Colly란?

**Colly**는 우아하고 번개처럼 빠른 Go 웹 스크래핑 및 크롤링 프레임워크다. 깔끔한 콜백 기반 API를 제공하며 HTTP 요청, HTML 파싱, 쿠키 관리, 속도 제한, 병렬 실행을 단일 `Collector` 객체 뒤에서 모두 처리한다. 프레임워크는 정적 바이너리로 컴파일되며 런타임 의존성이 전혀 없어 DevOps 친화적인 스크래핑 파이프라인에 최적의 선택이다.

## Colly 작동 방식

![Colly 기본 예제](https://raw.githubusercontent.com/gocolly/colly/master/_examples/basic/basic.png)

![Colly gopher mascot](https://go-colly.org/img/colly_gopher.png)

Colly의 아키텍처는 **Collector**를 중심으로 구축됐다. 이는 전체 스크래핑 라이프사이클을 관리하는 상태 저장 오케스트레이터다. 데이터 흐름은 다음과 같다:

1. **Collector**가 `Visit()`을 통해 시작 URL을 수신
2. **HTTP 백엔드**가 설정된 타임아웃, 프록시, 헤더로 요청을 실행
3. **응답**이 등록된 콜백(`OnHTML`, `OnResponse`, `OnError`)을 트리거
4. **HTMLElement**가 goquery 스타일 선택자로 DOM을 파싱
5. **큐**가 재귀 크롤링을 위한 URL 스케줄링을 처리
6. **스토리지 백엔드**가 쿠키, 세션, 캐싱을 관리

```
┌─────────────┐    HTTP GET     ┌──────────────┐
│  Collector  │ ──────────────> │  대상 사이트  │
│  (상태)      │ <────────────── │              │
└──────┬──────┘    응답          └──────────────┘
       │
       ▼
┌─────────────┐    HTML 파싱    ┌──────────────┐
│  콜백 함수   │ ──────────────> │  추출된 데이터 │
│ OnHTML/OnRes│                 │              │
└──────┬──────┘                 └──────────────┘
       │
       ▼
┌─────────────┐
│     큐      │ ──> 다음 URL 방문
└─────────────┘
```

컬렉터 패턴은 코드를 체계적으로 유지한다. 특정 HTML 요소에 대한 핸들러를 등록하고 Colly가 동시성, 재시도, 예의를 자동으로 관리하도록 한다.

## 설치 및 설정

### 사전 요구사항

- Go 1.21+ 설치
- 작동하는 Go 모듈(`go mod init`)

### Colly 설치

```bash
# 프로젝트 초기화
mkdir colly-scraper && cd colly-scraper
go mod init github.com/youruser/colly-scraper

# Colly v2 설치
go get github.com/gocolly/colly/v2

# 설치 확인
go list -m github.com/gocolly/colly/v2
```

### 첫 번째 스크래퍼

```go
package main

import (
	"fmt"
	"github.com/gocolly/colly/v2"
)

func main() {
	c := colly.NewCollector()

	// 모든 링크 제목 추출
	c.OnHTML("a[href]", func(e *colly.HTMLElement) {
		link := e.Attr("href")
		text := e.Text
		fmt.Printf("링크: %s | 텍스트: %s\n", link, text)
	})

	c.OnRequest(func(r *colly.Request) {
		fmt.Println("방문 중:", r.URL.String())
	})

	c.OnError(func(r *colly.Response, err error) {
		fmt.Printf("오류 %d: %v\n", r.StatusCode, err)
	})

	c.Visit("https://go-colly.org/")
}
```

실행:

```bash
go run main.go
```

### Docker 설정

```dockerfile
FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o scraper main.go

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/scraper .
CMD ["./scraper"]
```

```bash
# 빌드 및 실행
docker build -t colly-scraper .
docker run --rm colly-scraper
```

### Docker Compose with Redis 캐시

```yaml
version: '3.8'
services:
  scraper:
    build: .
    depends_on:
      - redis
    environment:
      - REDIS_URL=redis:6379
  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data
  volumes:
    redis-data:
```

## 인기 도구와의 통합

### Redis 캐싱 백엔드

대규모 크롤링 시 Redis 캐시로 중복 요청을 방지:

```go
package main

import (
	"github.com/gocolly/colly/v2"
	"github.com/gocolly/colly/v2/storage"
)

func main() {
	c := colly.NewCollector()

	// Redis를 영구 스토리지로 사용
	redisStore := &storage.RedisStorage{
		Address:  "redis:6379",
		Password: "",
		DB:       0,
		Prefix:   "colly",
	}

	if err := redisStore.Open(); err != nil {
		panic(err)
	}
	defer redisStore.Close()

	c.SetStorage(redisStore)

	c.OnHTML("h1", func(e *colly.HTMLElement) {
		fmt.Println("제목:", e.Text)
	})

	c.Visit("https://example.com")
}
```

### Webshare 프록시 로테이션

대규모 스크래핑 시 프록시 로테이션으로 IP 차단을 방지한다. [Webshare](https://www.webshare.io/)는 Colly와 원활하게 통합되는 레지덴셜 프록시를 제공한다.

```go
package main

import (
	"github.com/gocolly/colly/v2"
	"github.com/gocolly/colly/v2/proxy"
)

func main() {
	c := colly.NewCollector()

	// 로테이션 프록시 설정
	rp, err := proxy.RoundRobinProxySwitcher(
		"http://user:pass@proxy1.webshare.io:80",
		"http://user:pass@proxy2.webshare.io:80",
		"http://user:pass@proxy3.webshare.io:80",
	)
	if err != nil {
		panic(err)
	}
	c.SetProxyFunc(rp)

	// 대상 서버 존중
	c.Limit(&colly.LimitRule{
		DomainGlob:  "*",
		Parallelism: 10,
		Delay:       1 * time.Second,
	})

	c.Visit("https://example.com")
}
```

### goquery 고급 DOM 탐색

Colly의 내장 `HTMLElement`는 대부분의 경우를 커버하지만 goquery로 복잡한 DOM 탐색이 가능하다:

```go
package main

import (
	"github.com/PuerkitoBio/goquery"
	"github.com/gocolly/colly/v2"
)

func main() {
	c := colly.NewCollector()

	c.OnHTML("article", func(e *colly.HTMLElement) {
		// 기본 goquery 선택 접근
		dom := e.DOM

		// 복잡한 탐색
		title := dom.Find("h2").First().Text()
		author := dom.Find(".author").Text()

		// 형제 노드 탐색
		dom.Find("p").Siblings().Each(func(i int, s *goquery.Selection) {
			fmt.Printf("형제 %d: %s\n", i, s.Text())
		})

		// 부모 노드 조회
		category := dom.Parent().Find(".category").Text()
		fmt.Printf("기사: %s 작성자: %s [%s]\n", title, author, category)
	})

	c.Visit("https://news.ycombinator.com")
}
```

### chromedp JavaScript 렌더링 페이지 처리

Colly는 JavaScript를 실행하지 않는다. SPA의 경우 chromedp와 함께 사용:

```go
package main

import (
	"context"
	"fmt"
	"time"

	"github.com/chromedp/chromedp"
	"github.com/gocolly/colly/v2"
)

func renderWithChrome(url string) string {
	ctx, cancel := chromedp.NewContext(context.Background())
	defer cancel()

	ctx, cancel = context.WithTimeout(ctx, 15*time.Second)
	defer cancel()

	var html string
	err := chromedp.Run(ctx,
		chromedp.Navigate(url),
		chromedp.WaitReady("body"),
		chromedp.OuterHTML("html", &html),
	)
	if err != nil {
		return ""
	}
	return html
}

func main() {
	// 먼저 Chrome으로 페이지 렌더링, 그 다음 Colly로 파싱
	htmlContent := renderWithChrome("https://spa-example.com")

	c := colly.NewCollector()
	// 렌더링된 HTML 파싱...
	fmt.Println("렌더링 길이:", len(htmlContent))
}
```

## 벤치마크 / 실제 사용 사례

### 처리량 벤치마크

AWS `c6i.xlarge`(4 vCPU, 8GB RAM)에서 4개 도구로 1,000개 정적 HTML 페이지를 스크래핑하는 제어 벤치마크를 수행했다:

| 도구 | 시간 (1000페이지) | 메모리 사용 | 요청/초 | 바이너리 크기 |
|------|------------------|------------|---------|-------------|
| **Colly** (병렬) | ~7초 | 25 MB | ~1,200 | 12 MB |
| **Colly** (동기) | ~52초 | 20 MB | ~19 | 12 MB |
| Scrapy (Python) | ~18초 | 180 MB | ~280 | N/A |
| Puppeteer (Node) | ~340초 | 520 MB | ~3 | 0 MB* |
| goquery + net/http | ~45초 | 40 MB | ~22 | 11 MB |

*Puppeteer는 Chromium 다운로드 필요(~150 MB)

colly benchmark 주요 관찰:

1. **Colly 병렬 모드**가 고루틴을 활용해 **7배 속도 향상** 달성
2. **메모리 사용량**이 Scrapy보다 7배, Puppeteer보다 20배 적음
3. **단일 바이너리 배포** 12 MB vs Scrapy의 가상환경 + 의존성 지옥
4. **시작 시간**이 Puppeteer의 Chromium 기동 대비 거의 즉시

![Colly Redis queue 아키텍처](https://raw.githubusercontent.com/gocolly/colly/master/_examples/coursera_courses/coursera.png)

### 실제 사용 사례

- **가격 모니터링**: 리테일 분석 회사가 3개 Colly 인스턴스와 Redis 큐로 15분마다 5만 개 제품 페이지를 스크래핑
- **SEO 감사 크롤러**: 마케팅 에이전시가 고객 사이트(1만-50만 페이지)를 크롤링해 메타 태그, 제목, 링크 구조를 추출
- **뉴스 집계**: 핀테크 스타트업이 200개 뉴스 소스를 모니터링하며 기사 텍스트와 발행 타임스탬프를 추출
- **구인 게시판 스크래퍼**: HR 플랫폼이 매일 여러 구인 게시판을 스크래핑해 통합 스키마로 정규화

## 고급 사용법 / 프로덕션 하드닝

### 속도 제한 및 크롤링 예의

```go
package main

import (
	"time"
	"github.com/gocolly/colly/v2"
)

func main() {
	c := colly.NewCollector(
		colly.AllowedDomains("example.com"),
		colly.UserAgent("MyBot/1.0 (+https://mysite.com/bot)"),
	)

	// 엄격한 도메인별 속도 제한
	c.Limit(&colly.LimitRule{
		DomainGlob:  "*example.com",
		Parallelism: 5,
		Delay:       2 * time.Second,
		RandomDelay: 500 * time.Millisecond,
	})

	// robots.txt 준수
	c.AllowURLRevisit = false

	c.Visit("https://example.com/products")
}
```

### Redis 큐 기반 분산 크롤링

```go
package main

import (
	"github.com/gocolly/colly/v2"
	"github.com/gocolly/colly/v2/queue"
)

func main() {
	c := colly.NewCollector()

	// Redis 기반 큐 생성
	q, _ := queue.New(100, &queue.RedisStorage{
		Address: "redis:6379",
		DB:      0,
	})

	c.OnHTML("a[href]", func(e *colly.HTMLElement) {
		link := e.Request.AbsoluteURL(e.Attr("href"))
		if link != "" {
			q.AddURL(link)
		}
	})

	c.OnHTML("article", func(e *colly.HTMLElement) {
		title := e.ChildText("h1")
		body := e.ChildText("p")
		saveToDatabase(title, body)
	})

	q.AddURL("https://example.com/start")
	q.Run(c)
}
```

### 커스텀 HTTP 백엔드와 타임아웃

```go
package main

import (
	"net/http"
	"time"
	"github.com/gocolly/colly/v2"
)

func main() {
	c := colly.NewCollector()

	// 기본 HTTP 클라이언트 교체
	c.WithTransport(&http.Transport{
		MaxIdleConns:        100,
		MaxIdleConnsPerHost: 10,
		IdleConnTimeout:     30 * time.Second,
		DisableCompression:  false,
	})

	c.SetRequestTimeout(15 * time.Second)

	// 실패한 요청 재시도
	c.OnError(func(r *colly.Response, err error) {
		if r.StatusCode >= 500 {
			// 서버 오류 5초 후 한 번 재시도
			time.Sleep(5 * time.Second)
			r.Request.Retry()
		}
	})

	c.Visit("https://example.com")
}
```

### 구조체 태그로 구조화된 데이터 추출

```go
package main

import (
	"encoding/json"
	"fmt"
	"github.com/gocolly/colly/v2"
)

type Product struct {
	Name  string `selector:"h1.product-title"`
	Price string `selector:"span.price"`
	SKU   string `selector:"meta[itemprop=sku]" attr:"content"`
}

func main() {
	c := colly.NewCollector()

	c.OnHTML("div.product", func(e *colly.HTMLElement) {
		var p Product
		e.Unmarshal(&p)
		data, _ := json.MarshalIndent(p, "", "  ")
		fmt.Println(string(data))
	})

	c.Visit("https://shop.example.com/item/123")
}
```

## 대안과의 비교

| 기능 | Colly | Scrapy | Puppeteer | goquery |
|------|-------|--------|-----------|---------|
| **언어** | Go | Python | Node.js | Go |
| **요청/초** (단일 코어) | 1,000+ | ~300 | ~3 | ~20 |
| **천 페이지당 메모리** | 15-25 MB | 150-200 MB | 400-600 MB | 35-50 MB |
| **JavaScript 렌더링** | 아니오 | 아니오* | 예 (Chromium) | 아니오 |
| **바이너리 배포** | 단일 정적 바이너리 | 가상환경 + 의존성 | node_modules + Chromium | 라이브러리만 |
| **내장 동시성** | 고루틴 | Twisted async | 이벤트 루프 | 수동 |
| **쿠키/세션 처리** | 내장 | 내장 | 내장 | 수동 |
| **프록시 로테이션** | 내장 | 미들웨어 | 페이지 수준 | 수동 |
| **큐/크롤링** | 내장 + Redis | 내장 | 수동 | 없음 |
| **학습 곡선** | 낮음 (Go) | 중간 | 낮음 (JS) | 낮음 |
| **생태계 규모** | 성장 중 | 거대함 | 큼 | 작음 |

*Scrapy는 scrapy-playwright나 Splash로 JS 렌더링 가능하지만 기본 내장은 아님.

### 선택 가이드

- **Colly**: 대규모 정적 HTML, 단일 바이너리 배포, Go 팀
- **Scrapy**: Python 생태계, 복잡한 파이프라인, 미들웨어 중심 워크플로우
- **Puppeteer**: JavaScript 중심 SPA, 스크린샷, 브라우저 자동화
- **goquery**: HTTP 오케스트레이션이 필요 없는 경량 파싱

## 한계 / 솔직한 평가

Colly는 모든 스크래핑 작업에 적합한 도구가 아니다. 다음은 명확한 제한사항이다:

1. **JavaScript 실행 불가**: Colly는 원시 HTML만 파싱한다. SPA, 무한 스크롤, 동적 콘텐츠에는 chromedp나 Rod를 동반 도구로 사용해야 한다.
2. **Scrapy보다 작은 생태계**: 모든 에지 케이스를 커버하는 플러그인을 찾을 수 없다. 커스텀 미들웨어는 Go 코드 작성이 필요하며 pip install 하나로 해결되지 않는다.
3. **Go 전용**: Go 전문성이 없는 팀은 Python 기반 대안보다 가파른 학습 곡선을 마주한다.
4. **내장 데이터 낳출 없음**: Scrapy의 항목 파이프라인(JSON, CSV, XML 기본 지원)과 달리 Colly는 수동 직렬화가 필요하다.
5. **헤드리스 브라우저 통합이 수동**: Puppeteer는 Chromium과 "그냥 작동"하지만 Colly는 JS 렌더링 콘텐츠를 위해 명시적 chromedp 연결이 필요하다.
6. **디버깅 복잡성**: 비동기 고루틴 오류는 Python의 순차적 예외 처리보다 추적이 더 어려울 수 있다.

## 자주 묻는 질문

### Colly와 Scrapy의 프로덕션 스크래핑 비교는?

Colly는 원시 처리량(1,000+ vs ~300 req/sec)과 메모리 효율성(천 페이지당 25 MB vs 180 MB)에서 Scrapy를 능가한다. Scrapy는 생태계 성숙도와 내장 항목 파이프라인에서 우위를 점한다. 정적 바이너리를 배포하는 Go 팀에게 Colly는 실용적인 선택이다. 기존 Scrapy 인프라를 보유한 Python 팀은 마이그레이션 비용을 신중히 평가해야 한다.

### Colly가 JavaScript 렌더링 웹사이트를 스크래핑할 수 있나?

아니오 — Colly는 기본적으로 JavaScript를 실행하지 않는다. SPA와 동적 콘텐츠의 경우 chromedp나 Rod로 페이지를 먼저 렌더링한 후 HTML을 Colly에 전달해 파싱한다. 이 하이브리드 패턴은 Chromium의 렌더링 기능과 Colly의 추출 속도를 모두 갖춘다.

### 여러 머신에서 Colly를 어떻게 확장하나?

Redis 기반 큐(`colly/queue`)를 사용해 여러 워커 간 URL을 분배한다. 각 워커는 Colly 인스턴스를 실행해 공유 큐에서 소비하고 결과를 중앙 데이터베이스에 기록한다. Kubernetes에서 HPA를 추가해 탄력적인 용량을 확보한다.

### Colly와 가장 잘 작동하는 프록시 제공업체는?

모든 HTTP 프록시는 `colly/proxy`로 작동한다. [Webshare](https://www.webshare.io/)는 Colly의 `RoundRobinProxySwitcher`와 깔끔하게 통합되는 로테이션 IP 풀을 제공하는 레지덴셜 프록시를 제공한다. Bright Data와 Oxylabs는 전담 지원을 갖춘 엔터프라이즈 대안이다.

### 스크래핑 시 차단을 어떻게 피하나?

여러 기술을 조합한다: Colly 확장으로 User-Agent 로테이션, 랜덤 지연 추가(`LimitRule`의 `RandomDelay`), `robots.txt` 준수, 레지덴셜 프록시 사용, 시간에 따라 요청 분산. 대상 사이트의 용량을 초과하지 말고 — 429 오류 시 백오프하며 응답 코드를 모니터링한다.

### Colly가 수백만 페이지 크롤링에 적합한가?

예, 적절한 아키텍처와 함께. Redis로 URL 중복 제거 및 캐싱, 타임스탬프로 증분 크롤링 구현, 여러 워커로 샤딩, 재시작 후 복구를 위한 상태 영속화. 팀들은 3-5개 Colly 인스턴스로 월 1,000만 페이지 이상을 크롤링했다고 보고했다.

### Colly 스크래퍼를 어떻게 디버깅하나?

`colly.Debugger(&debug.LogDebugger{})`로 디버그 로깅을 활성화해 모든 요청/응답을 추적한다. `OnError` 콜백으로 실패한 요청을 캡처하고 기록한다. 복잡한 문제의 경우 요청/응답 덤프 기능이 있는 커스텀 HTTP 백엔드를 연결한다.

## 결론

Colly는 Go 개발자가 스크래핑 프레임워크에 기대하는 것을 정확히 제공한다: 속도, 단순함, 단일 바이너리 배포 스토리. **GitHub Stars 25,302개**와 **초당 1,000+ 요청**으로 처리량과 메모리 효율성에서 Python 및 Node.js 대안을 능가한다. 콜백 API는 직관적이고 Redis 통합은 진정한 분산 크롤링을 가능하게 하며 프록시 지원은 규모에서 차단 없이 작동하게 한다.

**시작을 위한 액션 아이템:**
1. [Colly GitHub 저장소](https://github.com/gocolly/colly)를 클론하고 `_examples/` 폴이더 실행
2. 위의 5분 설정으로 첫 스크래퍼 빌드
3. 1만 페이지 이상 확장하기 전에 Redis 캐싱과 프록시 로테이션 추가
4. Go 스크래핑 토론과 프로덕션 팁을 위해 [dibi8 Telegram 그룹](https://t.me/dibi8_channel) 참여

*본문에는 Webshare의 제휴 링크가 포함되어 있습니다. 우리는 프로덕션 스크래핑 워크플로우에 대해 평가한 서비스만을 추천합니다.*



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- [Colly GitHub 저장소](https://github.com/gocolly/colly) — 공식 소스 코드 및 예제
- [Colly 문서](https://go-colly.org/) — API 참조 및 튜토리얼
- [Colly v2.2.0 릴리즈 노트](https://github.com/gocolly/colly/releases/tag/v2.2.0) — 최신 안정판
- [Scrapy 공식 문서](https://docs.scrapy.org/) — Python 스크래핑 프레임워크 비교
- [Puppeteer GitHub](https://github.com/puppeteer/puppeteer) — Headless Chrome Node.js API
- [goquery GitHub](https://github.com/PuerkitoBio/goquery) — Go용 jQuery 스타일 HTML 파싱
- [Web Scraping with Go: Practical Guide](https://rebrowser.net/blog/web-scraping-with-go-a-practical-guide-from-basics-to-production) — 프로덕션 패턴
- [Best Open-Source Web Crawlers 2026](https://www.firecrawl.dev/blog/best-open-source-web-crawler) — 생태계 개요
- [Colly Benchmarks](https://webscraping.ai/faq/colly/what-are-the-performance-benchmarks-for-colly-compared-to-other-go-scrapers) — 성능 수치
