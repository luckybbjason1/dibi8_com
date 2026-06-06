---
title: Scrapling 实测:更快、更隐蔽的 Python 爬虫框架
description: Scrapling评测：Python隐形网页抓取库。绕过反爬虫机制，处理动态内容，轻松实现大规模数据抓取。
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Java
- JavaScript
- Python
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "8.0 MB"
file_md5: ''
download_url: https://github.com/D4Vinci/Scrapling
backup_url: ''
github_repo: https://github.com/D4Vinci/Scrapling
stars: 50997
maintainer: "D4Vinci"
last_maintained: "2026-05-16"
featureImage: ''
draft: false
aliases:
- /zh/posts/scrapling-python-stealthy-web-scraping-review/
faqs:
  - q: 'Python 中的 Scrapling 是什么？'
    a: 'Scrapling 是一个 Python 3.10+ 网页抓取框架，通过统一的选择器 API 封装了三种抓取后端：带 TLS 指纹模拟的普通 HTTP、隐身模式反检测浏览器，以及完整的 Playwright 驱动浏览器。它将 Scrapy 风格的爬虫、curl_cffi 风格的 TLS 指纹伪造，以及免检测 Playwright 整合进一个 import 中。'
  - q: 'Scrapling 的三种 fetcher 分别是什么？各在什么场景下使用？'
    a: 'Fetcher 使用带 TLS 指纹模拟的普通 HTTP，适用于快速抓取静态 HTML。StealthyFetcher 使用带反检测补丁的无头浏览器，适用于 Cloudflare 或有 JS 保护的页面。DynamicFetcher 使用 Playwright/Chromium 进行完整自动化，适用于有复杂认证或点击流程的 SPA 应用。单个 Spider 类可以按请求混用不同层级。'
  - q: 'Scrapling 真的比 Scrapy 和 BeautifulSoup 更快吗？'
    a: 'Scrapling 解析 5,000 个嵌套元素时比 BeautifulSoup4 快约 784 倍（1584 ms vs 约 2 ms），但这个差距是已知的 lxml vs BS4 结论，并非 Scrapling 独有的优势。对比 Scrapy 的 Parsel 引擎，差异在误差范围内（2.02 ms vs 2.04 ms）。它真正的实际优势在网络层——TLS 指纹模拟可以跳过启动浏览器的开销。'
  - q: '如何为 Cloudflare 页面安装 Scrapling 的 StealthyFetcher？'
    a: '先运行 pip install "scrapling[fetchers]"，再运行 scrapling install。scrapling install 步骤会下载经过补丁的 Chromium 二进制文件，依赖包大小有几百 MB，在小型 VM 上安装前请注意这一点。'
  - q: 'Scrapling 默认遵守 robots.txt 吗？'
    a: '不遵守。robots_txt_obey 设置是可选启用的，默认不开启，因此你必须主动启用它。这是为了照顾拥有被抓取站点的用户而做出的有意设计，但在抓取第三方站点时忘记开启可能带来法律风险。'
---
{</* resource-info */>}

Python 爬虫工具大致经历了四个时代。先是 `urllib` 加正则。然后
是 `requests` 加 `BeautifulSoup`。再后来,严肃一点的活就上
`Scrapy`。最后,半个互联网都变成 JavaScript-only 之后,前面
三件套被一脚踹下悬崖,`Playwright` 顶上来了。

[**Scrapling**](https://github.com/D4Vinci/Scrapling) 就是想
在这个栈上再加一层的新库之一 —— 一个工具包同时覆盖简单页面、
重度 JS 页面、以及反爬保护页面这三种场景,让你不用再把三个不
同的库缝在一起。

我把项目、benchmark 和 API 都翻了一遍。下面是我觉得它真正有
价值的地方、需要小心的地方,以及在什么情况下我会选它而不是更
显而易见的替代品。

![Scrapling — 隐身式 Python 爬虫](/images/articles/scrapling-python-stealthy-web-scraping-review/cover.svg)
*来源：[github.com/D4Vinci/Scrapling](https://github.com/D4Vinci/Scrapling) — 官方 hero banner*

## 一句话讲清楚它是什么

Scrapling 是一个 Python 3.10+ 的爬虫框架,它把三种不同的请求
后端 —— 带 TLS 指纹模拟的纯 HTTP、带反检测的隐身浏览器、完整
的 Playwright 浏览器 —— 包在同一套 selector API 后面。
BSD-3-Clause 协议。

仓库的标语是 *"Effortless Web Scraping for the Modern Web"*
(为现代 Web 而生的轻松爬虫),这种话每个爬虫库都会说。更有
用的描述方式是:**它想做 Scrapy 的 Spider 模型 + curl_cffi 的
TLS 指纹模拟 + 一个反检测 Playwright,合并成一个 import。**

## 三层 fetcher 的设计

这是我觉得这个项目里**真正下了功夫**的部分。大多数爬虫项目最
后都会变成一坨缝合怪:`requests` 处理快页面,`Selenium` 或
`Playwright` 处理 JS 重的页面,再加上一些自己写的 CDN 绕过逻辑。
Scrapling 把这些拆成三档,而且响应对象长得一样:

| Fetcher | 后端 | 什么时候用 |
| --- | --- | --- |
| `Fetcher` | 纯 HTTP,带 TLS 指纹模拟 | 静态 HTML;不需要真浏览器;你想要它够快 |
| `StealthyFetcher` | 带反检测补丁的 headless 浏览器 | Cloudflare / JS 保护页面,必须用真浏览器 |
| `DynamicFetcher` | Playwright/Chromium 完整自动化 | SPA、复杂登录流程、JS 渲染数据 |

在同一个 Spider 类里你可以给不同请求打不同的档位标记。README
里的例子:

```python
async def parse(self, response: Response):
    for link in response.css('a::attr(href)').getall():
        if "protected" in link:
            yield Request(link, sid="stealth")
        else:
            yield Request(link, sid="fast", callback=self.parse)
```

为什么这事重要:在真实的爬取任务里,只有一小部分页面真正需要
重型后端,但你最后往往会因为重写太麻烦,所有页面都付浏览器开
销的代价。让一个 Spider 能混合不同档位,就把平均成本压下来了。

## Benchmark,带保留意见

README 里贴的是解析 5,000 个嵌套元素的数据:

| 库 | 时间 | 相对值 |
| --- | --- | --- |
| Scrapling | 2.02 ms | 1.0× |
| Parsel / Scrapy | 2.04 ms | 1.01× |
| Raw lxml | 2.54 ms | 1.26× |
| BeautifulSoup4 + lxml | 1584.31 ms | ~784× |

两点诚实的解读:

**是的,BeautifulSoup 真的就是这么慢。** 那个数字不是打错了。
BS4 是个易用性优先的库;在大量文档的紧密循环里,基于 lxml 的
解析器(Scrapling、Parsel、raw lxml 都是)能快上几个数量级。
这是一个**已知结果**,不是 Scrapling 独有的发现。

**不,Scrapling 在解析层并没有真的比 Scrapy 快。** 看表 ——
Scrapy 用的 Parsel 是 2.04 ms,Scrapling 是 2.02 ms。在微基
准的误差范围内。"比 BS4 快几百倍"是真的;"比 Scrapy 快"不是,
至少在解析这一层不是。

Scrapling 在**真实负载**里大概率胜出的地方,是网络层 ——
`Fetcher` 的 TLS 指纹模拟让你不用为了绕过基础的 JA3 指纹检测
就去引入 Playwright。这种节省是按"秒/请求"算的,不是按
"微秒"算的。

## 自适应选择 —— 真正有意思的想法

爬虫的痛点不是写第一条 selector,而是**三周以后目标网站重命
名了一个 class,你的 selector 就废了**。Scrapling 在这块的承
诺是 "smart element relocation after website changes using
similarity algorithms"(用相似度算法在网站结构变更后智能重定
位元素)—— 也就是说当原 selector 失效时,库会通过和之前抓过
的结构做相似度比较,试图重新找到那个元素。

我对这个**谨慎乐观**。这是该有的功能。实际表现上,基于相似度
的重定位在**外观性**改动(class 重命名、加一层 wrapper div)
上会工作得很好,在**语义性**改动(数据搬到了另一个页面、整个
区块被重新模板化)上则会失败。把它当成"省你三点钟为了一个
class 名爬起来改代码"的功能,不要当成"你的爬虫从此自我维护"
的功能。

## 最简单能跑的写法

直接照搬文档,绝对最小是这样:

```python
from scrapling.fetchers import Fetcher, FetcherSession

with FetcherSession(impersonate='chrome') as session:
    page = session.get('https://quotes.toscrape.com/', stealthy_headers=True)
    quotes = page.css('.quote .text::text').getall()
```

就这样,三行代码搞定"用 Chrome 的 TLS 指纹去抓页面并解析"。
`impersonate='chrome'` 是 curl_cffi 风格的指纹欺骗 —— 在目标
站点用基础指纹检测时很有用。

针对 Cloudflare 保护的页面:

```python
from scrapling.fetchers import StealthyFetcher

page = StealthyFetcher.fetch('https://nopecha.com/demo/cloudflare')
data = page.css('#padded_content a').getall()
```

注意 `StealthyFetcher` 要单独装浏览器:

```bash
pip install "scrapling[fetchers]"
scrapling install
```

`scrapling install` 这一步会下打过补丁的 Chromium。在干净的服务
器上是几百 MB 的依赖,在小内存 VPS 上 `pip install` 之前要心里
有数。

## 跟显而易见的替代品比

| 需求 | 选什么 |
| --- | --- |
| 一次性脚本、简单 HTML、入门学习 | `requests` + `BeautifulSoup` |
| 大规模抓取、流水线明确、生态成熟 | `Scrapy` |
| 重度 JS 应用、复杂登录、自己控制浏览器 | 直接用 `Playwright` |
| TLS 指纹模拟、不要浏览器开销 | `curl_cffi` |
| Cloudflare/Turnstile 保护的静态页 | `cloudscraper` 或 `Scrapling.StealthyFetcher` |
| **以上所有都想要,合并成一个库** | `Scrapling` |

老实说一句:如果你的项目形态明确("我要在一个已知站点上爬
1000 万个商品页"),那就用专门为这个形态设计的工具 —— 大型
受规约的爬取,Scrapy 还是对的;严肃的浏览器自动化,Playwright
还是对的。Scrapling 的价值在那些**形态不明确**的项目上,在那
里你本来要被迫维护三个不同的爬虫。

## 哪些地方要小心

**反爬绕过是个移动靶。** README 自己也明说了:企业级系统
(Akamai、DataDome、Kasada、Incapsula)需要第三方方案,文档
里也没承诺能搞定。即便是 Scrapling 确实针对的系统 —— 比如
Cloudflare Turnstile —— 你也要预期"今天能用的下个季度未必能
用"。如果你的业务靠这个吃饭,要做好**持续维护**的预算,而不
是"装上就忘"。

**`robots_txt_obey` 是 opt-in,不是默认开。** 这是有意为之的设
计选择(有些用户有合理理由绕过 robots,比如他在爬自己的站),
但意思就是你必须**自觉打开**。在第三方站点上忘了打开,你会先
在法庭上后悔,再在技术上后悔。

**隐蔽 ≠ 授权。** 库本身有一份免责声明,值得引用一下:

> "本库仅供教育与研究用途。使用本库即表示您同意遵守当地及国
> 际数据抓取与隐私法律。"

反检测能力对**合法场景**有用 —— 学术研究、网站存档、无障碍辅
助抓取、监测你有授权的站点、把你自己的数据从不愿提供导出的服
务里取出来。但同样这些能力也正是**广告欺诈、内容盗窃、违反
ToS** 用的。库本身不在乎你在干哪种;法院和监管机构在乎。把
"stealthy"系列功能当成**电动工具**来对待 —— 有用,但你得知
道什么时候不用它。

## 我会在什么情况下真的用它

三种我觉得 Scrapling 合适的具体场景:

1. **个人数据导出。** 某个服务持有你自己的数据但不给真正的
   导出 API。你要慢慢地、尊重对方限速地、用真浏览器爬你自己
   的账号 —— Scrapling 的 `DynamicSession` 干这个挺合适。

2. **小型商业爬取,但需要面对两三种不同保护级别。** 你不想为
   一个一周的项目去搭一套 Scrapy + Playwright + curl_cffi 流
   水线。Scrapling 让你更快出原型。

3. **研究和存档。** 抓公共记录、数据集、政府门户、新闻档案。
   这种活的特点就是大批量用快 HTTP,少数几个奇葩页面用真浏览
   器。

我**不会**首选它的情况:目标是单一、深度了解、要爬好几年的站
点(Scrapy 的纪律性在这种场景下回报更高);或者站点所有者明
确说请你别爬(没有任何库能解决这个问题)。

## 结论

Scrapling 是一个真实存在、设计认真的库 —— 不是噱头,不是炒作。
对 BeautifulSoup 的 benchmark 是真的,对 Scrapy 的 benchmark
诚实地讲是在噪声范围内;**真正的优势**是三档 fetcher 的统一
接口,以及网络层指纹处理让你能避免为不需要浏览器的场景启动浏
览器。

它**没有**解决爬虫的真正难题 —— 那些都在法律和伦理层面,没有
任何库能帮你 —— 但它干净利落地解决了一个真实的工程问题。如果
你今天要起一个新爬虫项目,而且还不确定要不要浏览器,这是个合
理的起点。

完整源码和文档在
[github.com/D4Vinci/Scrapling](https://github.com/D4Vinci/Scrapling)。

---

## 推荐工具

跑或部署开源 AI 工具时，推荐：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心，AI 工作流 droplet 一键部署。
- **{{< aff "nbility" "category-footer" "Nbility" >}}** — 专业级代理服务, 用于真实 web scraping. 跟 Scrapling 隐身特性配合做 IP 轮换、避开 bot 检测、规模化爬取不被封。

*推广链接 — 不增加你的成本，能支持 dibi8.com 持续运营。*

