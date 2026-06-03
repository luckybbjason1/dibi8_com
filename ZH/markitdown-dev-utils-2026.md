---
title: 'markitdown：把文件和 Office 文档转成 Markdown（141K Stars）——2026 实战指南'
description: 'markitdown 是微软出品的 Python 工具，用于把各类文件和 Office 文档转换成 Markdown。141,153 个 GitHub star，MIT 协议。涵盖安装、核心命令行与 Python 用法、真实代码示例，以及与 pandoc、docx2txt 的客观对比。'
date: 2026-06-02 00:00:00+08:00
lastmod: 2026-06-02 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'microsoft/markitdown'
stars: 141153
maintainer: 'microsoft'
last_maintained: '2026-06-02'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: []
aliases:
- /posts/markitdown-dev-utils-2026/
faqs:
  - q: '怎么安装 markitdown？'
    a: '用 pip 安装即可。常见做法是把所有格式的 extras 一起装上： ```bash pip install ''markitdown[all]'' ```'
  - q: 'markitdown 能转换所有类型的 Office 文档吗？'
    a: '它支持很多种格式——Word（.docx）、Excel（.xlsx）、PowerPoint（.pptx）、PDF、HTML、图片和音频——但并非每种格式的每个特性都会被保留。具体支持哪些类型、需要哪些 extras，请查阅文档。'
  - q: 'markitdown 采用什么开源协议？'
    a: '`markitdown` 采用 MIT 协议发布，可自由用于任何用途并进行修改。'
  - q: '怎么为这个项目做贡献？'
    a: '你可以提交 issue 或发起 pull request。贡献指南请查看 [GitHub 仓库](https://github.com/microsoft/markitdown)。'
  - q: 'markitdown 有哪些已知的局限？'
    a: '有的——一些高级特性和复杂的文档结构可能无法完整保留。项目维护活跃，但它优先保证的是文本准确性，而非视觉还原。'
---

{{< resource-info >}}

## 引言

把 Office 文档转成 Markdown 是件挺繁琐的活儿，尤其是要处理一大堆不同格式的文件时。微软的 `markitdown` 工具正好能帮上忙，它在 GitHub 上拿下了超过 14.1 万 star，是开发者做文档转换时常用的选择之一。本文会带你过一遍安装、用法，以及和其他工具的对比，帮你判断 `markitdown` 是否适合你的工作流。

## markitdown 是什么？

`markitdown` 是微软开发的一个 Python 工具，用于把各类文件和 Office 文档转成 Markdown。它能把不同类型的文档变成纯 Markdown 文本，因此对那些需要把富文档喂给 LLM 流水线、wiki 或静态站点生成器的开发者和内容创作者特别有用。它的主要目标是为后续处理保留文本的准确性，而不是像素级还原原始外观。

## markitdown 的工作原理

`markitdown` 会读取源文件、识别其类型，然后把 Markdown 输出到标准输出（或你指定的文件）。实际工作流程是这样的：

1. **文件转换**：`markitdown` 接收输入文件（如 `.docx`、`.xlsx` 或 `.pptx`），把它们转换成 Markdown 结构的文本。
2. **结构处理**：它会保留原文档中的结构元素，比如标题、列表和表格，让输出依然清晰可读。
3. **可选增强**：对于图片和音频，`markitdown` 可以挂接一个 LLM 客户端（用于生成图片描述），或使用 Azure Document Intelligence，这些都通过构造函数参数或命令行参数来配置。

最简单的调用方式就是把 Markdown 直接打印到终端：

```bash
markitdown example.docx
```

如果要把结果保存到文件，加上 `-o` 参数：

```bash
markitdown example.docx -o output.md
```

这会转换你的文档，并保存为 `output.md`。

## 安装与配置

如果你要把 markitdown 作为定时的生产任务来跑，那就需要一台常开的机器——可以在 [DigitalOcean](https://m.do.co/c/eca87ac14ee0)（新账号有免费试用额度）开一台，或者用 [HTStack](https://my.htstack.com/aff.php?aff=27187) 的低延迟香港 VPS（和托管 dibi8.com 的是同一个机房）。

要开始使用 `markitdown`，用 Python 的包管理器 `pip` 安装即可。这个包采用可选附加组件（extras）的方式，所以最常见的做法是把全部组件都装上：

1. **用 pip 安装（支持全部格式）：**
   ```sh
   pip install 'markitdown[all]'
   ```
   如果你只需要某几种格式，只装对应的 extras 即可，例如：
   ```sh
   pip install 'markitdown[pdf, docx, pptx]'
   ```

2. **直接从 GitHub 克隆仓库（可选）：**
   如果你想要一份全新的源码，或者打算参与贡献，用 Git 克隆仓库：
   ```sh
   git clone https://github.com/microsoft/markitdown.git
   cd markitdown
   pip install -e 'packages/markitdown[all]'
   ```

3. **用 Docker（适合喜欢容器化环境的人）：**
   仓库里自带 Dockerfile，所以你需要在本地构建镜像，再把文件通过管道喂进去：
   ```sh
   docker build -t markitdown:latest .
   docker run --rm -i markitdown:latest < example.docx > output.md
   ```

有个常见问题是：用户忘了装所转换格式对应的 extra。如果你在转换 PDF 或 Office 文件时遇到 `ImportError` 或缺依赖的提示，先确认相关 extra 已经装好：

```sh
pip install --upgrade 'markitdown[all]'
```

如果你用的是虚拟环境，记得在执行安装命令前先激活它。

## 核心用法

`markitdown` 装好之后，我们来看看实际怎么用。

### 转换 Word 文档

首先确保你有一个 `.docx` 文件。本例中我们假设文件名为 `example.docx`。你可以这样转换它并把结果写入文件：

```sh
markitdown example.docx -o output.md
```

这会在当前目录生成一个 `output.md` 文件。如果省略 `-o`，Markdown 则会直接打印到标准输出。

### 批量转换多个文件

你可能想一次处理多个文件。用一个简单的 shell 循环就能搞定：

```sh
for file in *.docx; do
    markitdown "$file" -o "${file%.docx}.md"
done
```

这段脚本会转换当前目录下所有 `.docx` 文件，并保存为对应的 `.md` 文件。

### 从标准输入读取

`markitdown` 也支持从标准输入读取，这在管道里很方便：

```sh
cat example.docx | markitdown > output.md
```

### API 示例

如果你在用 Python，想以编程方式调用 `markitdown`，下面是个简单的例子。注意 `convert()` 返回的是一个结果对象——Markdown 内容在它的 `.text_content` 属性上：

```python
from markitdown import MarkItDown

md = MarkItDown()
result = md.convert('example.docx')

with open('output.md', 'w') as file:
    file.write(result.text_content)
```

这段 Python 脚本和前面的命令行示例做的事情一样，只是更便于集成。

这些例子应该足够让你上手 `markitdown` 了。这个工具维护活跃，背后还有一个庞大的社区在支撑。

## 集成

`markitdown` 能比较顺畅地融入大多数现有的工具链。无论你是在做文档转换，还是要把内容喂进基于 Markdown 的流水线，它都能嵌进你的工作流。

### 与常用工具的兼容性

为了看清 `markitdown` 如何与其他工具协作，我们来举个简单例子：把一个 Office 文档转成 Markdown，再做后处理。

首先确保系统里装了 Python。你可以用 pip 安装 `markitdown`：

```bash
pip install 'markitdown[all]'
```

装好之后，你可以把它和 `pandoc` 之类的工具搭配使用，做进一步处理或格式化。比如，把一个 Word 文档转成 Markdown，再用 `pandoc` 规范化输出：

```bash
markitdown input.docx -o temp.md
pandoc temp.md -s -t gfm > final_output.md
```

在这个例子里，`markitdown` 负责把 Word 转成 Markdown，`pandoc` 再把结果重新渲染成 GitHub 风格的 Markdown。

### 在 Jupyter Notebook 中使用

如果你在 Jupyter Notebook 环境里工作，用 `markitdown` 直接把源文档转成 Markdown 文本会很方便：

```python
!pip install 'markitdown[all]'
from markitdown import MarkItDown

def convert_to_markdown(path):
    md = MarkItDown()
    return md.convert(path).text_content

content = convert_to_markdown('example.docx')
print(content)
```

这段代码会转换一个文档并返回它的 Markdown 内容，便于你把它整合进文档或博客文章中。

把 `markitdown` 和 `pandoc` 这类工具搭配起来，你就能在整条流水线里让文档保持一致的 Markdown 格式。

## 性能表现与实战应用

凭借扎实的功能和易用性，`markitdown` 已经被广泛采用。下面是一些有代表性的使用场景。（以下数字仅用于说明典型工作流，并非正式基准测试。）

### 应用场景：文档团队的迁移

文档团队可以用 `markitdown` 把大量 Office 文档批量转成 Markdown，从而更方便地整合进内部 wiki。做过这类迁移的团队反馈说，手动重排源文件所花的时间有明显下降。

### 转换流程示例

`markitdown` 能处理很多种文件类型，包括 `.docx`、`.pptx`、`.xlsx` 和 PDF。下面是把一个 Word 文档转成 Markdown 的典型命令：

```bash
markitdown input.docx -o output.md
```

对于结构简单的文档，转换很快；转换耗时会随文档的大小和复杂度而增加。

### 集成进 CI/CD 流水线

`markitdown` 在持续集成与持续部署（CI/CD）流水线里也表现良好，因此可以实现文档的自动更新。比如，你可以配一个 GitHub Actions 工作流，每当有新文档被提交时就自动把它转成 Markdown：

```yaml
name: Convert Docs to Markdown

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4
    - name: Install MarkItDown
      run: pip install 'markitdown[all]'
    - name: Convert Docs to Markdown
      run: |
        for f in docs/*.docx; do
          markitdown "$f" -o "${f%.docx}.md"
        done
```

这样配置下来，文档几乎不需要人工干预就能保持最新。

### 社区反馈

社区贡献了不少有价值的反馈，推动着这个工具不断演进。比如，有用户反映 `.docx` 文件里的复杂表格转换得不够干净；维护者会在 GitHub 上跟踪这类问题，并在后续版本中修复，正是这些改进让工具随时间变得越来越可靠。

## 与替代方案的对比

也可以看看我们关于[相关开源工具](dibi8-internal-link)的报道。

在挑选一款把文件和 Office 文档转成 Markdown 的工具时，微软的 `markitdown` 是个很不错的选项。下面把 `markitdown` 和另外两个热门替代品 `pandoc` 与 `docx2txt` 做个对比，表格突出了在 star 数、语言、易用性和功能上的关键差异。

| 特性                 | markitdown            | pandoc                  | docx2txt                |
|----------------------|-----------------------|-------------------------|------------------------|
| Stars                | 141,153               | 709,865                 | N/A                    |
| 语言                 | Python                | Haskell                 | Python                 |
| 默认分支             | main                  | master                  | master                 |
| 未关闭 Issue         | 797                   | 2,264                   | N/A                    |
| 转换侧重             | 面向 LLM 的文本准确性 | 忠实的格式互转          | 纯文本提取             |
| 格式覆盖             | 广（Office、PDF、音频、图片、HTML） | 非常广（含 LaTeX） | 仅 .docx |
| 额外功能             | LLM 图片描述、Azure Doc Intelligence | 引用、LaTeX、自定义模板 | 无 |
| 易用性               | 命令行简单            | 命令行（门槛较高）      | 命令行简单             |
| 社区支持             | 活跃                  | 庞大                    | 较小                   |

当你的目标是从混合文档类型里产出干净、可读的 Markdown 时——尤其是作为 LLM 和搜索索引的输入——`markitdown` 是个稳妥的选择。它用 Python 实现，很容易嵌进脚本和服务，活跃的社区也让它保持前进。

相比之下，`pandoc` 是做忠实的文档互转的重量级选手。它支持非常多的输入输出格式，还有引用、LaTeX 等，所以当你需要精确、可高度配置的排版输出时，它更合适。不过它用 Haskell 实现、选项又多，上手曲线相对陡一些。

`docx2txt` 则窄得多：它只从 `.docx` 文件里提取纯文本，仅此而已。要快速抽取文本它还行，但在格式覆盖和 Markdown 结构上比不上前两者。

简而言之，如果你需要广泛的格式覆盖、以及能直接喂给 LLM 和文档流水线的 Markdown，`markitdown` 是个合理的默认选择；当你需要精确、可高度配置的转换时，就上 `pandoc`。

## 局限与客观评估

`markitdown` 虽然能力不俗，但也有它的局限和取舍。以下这些场景里，它可能没那么合适：

1. **复杂的文档结构**：对于深度嵌套的表格或交叉引用错综复杂的文档，`markitdown` 未必能精确还原原始结构。
2. **自定义 Office 宏与 VBA 脚本**：如果文档依赖宏或 VBA 来实现某些行为，这部分逻辑不会被带过来——Markdown 没有对应物，所以要做好手动重做的准备。
3. **视觉还原度**：那些大量依赖自定义样式、精确排版或复杂格式的文档，转换后会丢失视觉细节，因为 `markitdown` 关注的是文本和结构，而非外观。
4. **协作功能**：Office 格式里有批注、修订追踪和实时协作，这些没法干净地映射到 Markdown。如果这些功能很重要，那就保留原始格式。
5. **大批量处理**：对于超大文档或大批量文件，转换会比较吃资源、也更慢，这在配置较低的机器上可能要留意。

在判断 `markitdown` 是否符合你的具体需求时，这些局限值得权衡。

## 结语

`markitdown` 是个扎实的 Python 工具，在 GitHub 上已收获超过 14.1 万 star，由微软维护。它能高效地把文件和 Office 文档转成 Markdown，并专注于产出干净的文本以供后续使用。对于想要简化文档处理流程的开发者——尤其是面向 LLM 和文档流水线的场景——`markitdown` 值得收进工具箱。

接下来，不妨用 pip 装上它，在自己的项目里试试它的转换能力。

- 加入 [dibi8 英文 Telegram 群](https://t.me/DIBI8_Group/2)，获取开源 AI 工具的第一手分享。
- 继续阅读：[dibi8 上的相关指南](dibi8-internal-link)。

---

**来源与延伸阅读**：
- GitHub 仓库：https://github.com/microsoft/markitdown
- 官方文档 / README：https://github.com/microsoft/markitdown#readme

*以上部分链接为联盟（affiliate）链接。如果你通过它们注册，dibi8.com 可能会获得一笔佣金，但不会让你多花一分钱。这有助于维持网站运转、让内容保持免费。*

<!-- internal-link-candidates:
  related open-source tools -> ai-tools-directory
  related guides on dibi8 -> ai-coding-agent-landscape-2026-skills-mcp-opensource
-->
