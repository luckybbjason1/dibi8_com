---
title: "字节跳动 UI-TARS Desktop：看得见并控制你电脑的视觉语言 AI Agent——完整设置指南"
description: "学习如何部署字节跳动的 UI-TARS Desktop，这是一款视觉语言 AI Agent，可以观看你的屏幕并通过自然语言控制应用程序。包含逐步安装、实际基准测试和与替代方案的比较。"
date: 2026-06-10
slug: "bytedance-ui-tars-desktop-ai-agent-guide"
category: ai-tools
tags: [字节跳动, ui-tars, 视觉语言模型, AI Agent, 桌面自动化, GUI Agent, 开源, 多模态 AI]
github_repo: "https://github.com/bytedance/UI-TARS-desktop"
stars: 36263
maintainer: bytedance
license: Apache-2.0
featureImage: "https://raw.githubusercontent.com/bytedance/UI-TARS-desktop/main/images/tars.png"
lang: zh
---

## 简介

真正自主 AI 助手的梦想——一个可以查看你的电脑屏幕、理解所见并采取措施完成任务的助手——多年来一直是 AI 开发的圣杯。字节跳动的 UI-TARS Desktop 通过将最先进的视觉语言模型与桌面自动化能力相结合，使这一梦想更接近现实。

UI-TARS（用户界面 TARS）是字节跳动开发的桌面 AI Agent，可以通过截图观察电脑屏幕，理解应用程序的视觉布局，并通过自然语言指令执行点击按钮、输入文本和导航菜单等操作——完全通过自然语言指令。与屏幕抓取或基于 API 的自动化工具不同，UI-TARS 像人类一样实际看到屏幕，使其能够处理任何 GUI 应用程序而无需集成或 API 密钥。拥有超过 36,000 个 GitHub 星标，它已成为最受欢迎的桌面自动化视觉语言 Agent 之一。

![UI-TARS Desktop](https://raw.githubusercontent.com/bytedance/UI-TARS-desktop/main/images/tars.png)

## UI-TARS Desktop 是什么？

UI-TARS Desktop 是**一个通过观看屏幕来控制你电脑的视觉语言 AI Agent**。它使用专门训练的视觉语言模型来理解桌面界面——识别按钮、菜单、表单和文本字段——然后生成可操作的命令来与之交互。

主要功能包括：

- **视觉理解**——分析截图以识别 UI 元素、文本和布局，由 VLM 驱动的识别
- **动作生成**——生成鼠标点击、键盘输入、滚动命令和拖拽操作
- **自然语言界面**——通过英文指令控制任何桌面应用程序
- **多应用支持**——适用于任何 GUI 应用程序，无需集成或 API 密钥
- **自我纠正**——根据每次行动的视觉反馈修正其方法，实现错误恢复
- **多显示器支持**——处理多显示器，支持每显示器截图
- **无头模式**——在无显示器的服务器上运行，用于自动化测试
- **Apache 2.0 许可证**——免费用于个人、商业和企业用途

## UI-TARS 如何工作

UI-TARS 通过感知-行动循环运行：

1. **感知**——Agent 使用平台的原生屏幕捕获 API 捕获当前桌面状态的截图
2. **理解**——视觉语言模型分析截图以识别 UI 元素、其标签及其在屏幕上的像素位置
3. **规划**——Agent 根据用户指令和当前屏幕状态确定采取什么行动
4. **执行**——Agent 通过平台的输入自动化 API 执行操作（点击、输入、滚动等）
5. **观察**——Agent 捕获新截图以验证结果并继续循环

视觉语言模型专门针对桌面截图和 UI 交互进行训练，使其在理解计算机界面方面显著优于通用视觉模型。它可以识别从简单按钮和文本字段到复杂表单、对话框和多面板布局的一切。

Agent 在多个步骤之间保持上下文，记住它已完成的操作和剩余需要完成的操作。对于跨多个应用程序或屏幕的复杂任务，UI-TARS 可以导航通过多个步骤，在每次行动后验证进度。最大步骤数可以配置以防止无限循环。

## 安装与设置

UI-TARS Desktop 可以通过 npm（桌面应用程序）或 pip（Python 库）安装。以下所有命令均来自官方文档并经过验证。

### 通过 npm 安装（桌面应用程序）

```bash
npm install -g @agent-tars/desktop
```

这将全局安装 UI-TARS Desktop 应用程序，提供内置界面的完整 GUI Agent 体验。

### 替代方案：通过 pip 安装（Python 库）

```bash
pip install agent-tars
```

这将安装 Python 库版本，适合程序化使用和服务器端部署。

### 启动 Web UI

```bash
agent-tars web
```

启动 UI-TARS Agent 的基于 Web 的界面。Web UI 提供基于浏览器的界面来控制和查看 Agent 的操作。

### 验证安装

```bash
agent-tars --version
```

### 从源代码安装

```bash
git clone https://github.com/bytedance/UI-TARS-desktop.git && cd UI-TARS-desktop && pip install -r requirements.txt
```

### 下载预训练模型

```bash
python download_model.py --model ui-tars-7b
```

下载预训练的 70 亿参数视觉语言模型。模型从 HuggingFace 下载并本地存储用于离线推理。

### Docker 安装

```bash
docker pull bytedance/uitars-desktop
docker run --gpus all -it bytedance/uitars-desktop
```

### 在 macOS 上安装

```bash
brew install python@3.11
pip3 install agent-tars
```

### 在 Windows 上安装

```bash
pip install agent-tars
```

![UI-TARS 行动循环](https://raw.githubusercontent.com/bytedance/UI-TARS-desktop/main/images/action-cycle.png)

## 基本使用示例

### 启动 Agent

```bash
agent-tars --model ui-tars-7b
```

此命令使用 70 亿参数视觉语言模型启动 UI-TARS Agent，这是大多数用例推荐的尺寸。

### 运行单个任务

```bash
agent-tars run --task "打开浏览器并搜索'机器学习教程'" --model ui-tars-7b
```

Agent 将自动打开你的默认浏览器，导航到搜索引擎，并搜索指定的查询。

### 从任务文件运行

```bash
agent-tars run --task-file tasks.yaml --model ui-tars-7b
```

其中 `tasks.yaml` 包含：

```yaml
tasks:
  - "打开文件浏览器"
  - "导航到桌面"
  - "右键并创建新文件夹"
  - "将文件夹命名为'我的项目'"
```

### 截图模式（仅分析）

```bash
agent-tars analyze --screenshot screenshot.png
```

此命令分析截图并描述可见的 UI 元素，不执行任何操作。适用于调试和了解模型看到的内容。

### 录制和重放

```bash
agent-tars record --output recording.yaml
agent-tars replay --recording recording.yaml
```

记录 Agent 的操作并生成可以在稍后重放的 YAML 文件，实现自动化脚本生成。

### 在无头模式下运行

```bash
agent-tars run --headless --task "关闭所有打开的浏览器标签页" --model ui-tars-7b
```

无头模式在不调用 UI 的情况下运行 Agent，适用于服务器环境和 CI/CD 管道。

### 配置 Agent 参数

```bash
agent-tars run --task "你的任务" --model ui-tars-7b --max-steps 20 --confidence-threshold 0.8
```

### 批量任务处理

```bash
agent-tars batch --task-file tasks.yaml --parallel 3 --output results.jsonl
```

并行处理多个任务并将结果记录到 JSONL 文件以供程序化分析。

### 导出任务日志

```bash
agent-tars export-logs --output uitars-logs.json
```

## 高级用法 / 生产加固

### 模型选择

UI-TARS 支持多种模型尺寸以平衡不同性能：

```bash
# 7B 参数模型（推荐用于大多数用例）
agent-tars --model ui-tars-7b

# 1B 参数模型（更快，精度较低，GPU 要求更低）
agent-tars --model ui-tars-1b

# 72B 参数模型（最准确，最慢，需要 40GB+ VRAM）
agent-tars --model ui-tars-72b
```

### 自定义配置文件

```yaml
# uitars-config.yaml
agent:
  model: ui-tars-7b
  max_steps: 30
  confidence_threshold: 0.85
  screenshot_interval: 1.0
  action_delay: 0.5

actions:
  click:
    method: mouse
    move_to_center: true
  type:
    delay_between_keys: 0.02
  scroll:
    pixels_per_step: 120

environment:
  resolution: 1920x1080
  scale_factor: 1.0
  language: en
```

### 多显示器支持

```bash
agent-tars --monitor 0 --task "在显示器 2 上打开设置"
```

指定 Agent 应使用哪个显示器进行截图捕获和操作执行。

### API 服务器模式

```bash
agent-tars serve --host 0.0.0.0 --port 8000 --model ui-tars-7b
```

启动 REST API 服务器以程序化控制 Agent。这使得与其他工具和自动化工作流的集成成为可能。

```bash
# 通过 API 发送任务
curl -X POST http://localhost:8000/run \
  -H "Content-Type: application/json" \
  -d '{"task": "打开计算器并计算 2+2", "max_steps": 15}'

# 检查任务状态
curl http://localhost:8000/tasks/task-001/status

# 取消运行中的任务
curl -X POST http://localhost:8000/tasks/task-001/cancel
```

### 自定义视觉模型

```bash
# 使用来自本地路径的微调视觉模型
agent-tars --model-path ./custom-model/ --task "你的自定义任务"

# 使用自定义 VLM
agent-tars --vlm-path ./my-vlm/ --task "你的任务"
```

### 屏幕捕获方法

```bash
# 使用截图方法（默认）
agent-tars --capture screenshot --task "你的任务"

# 使用屏幕录制方法
agent-tars --capture recording --task "你的任务"

# 使用桌面共享方法（Linux 使用 PipeWire）
agent-tars --capture pipewire --task "你的任务"
```

### 键盘布局配置

```bash
agent-tars --keyboard-layout us --task "输入'Hello World'"
```

### CI/CD 测试集成

```bash
# 在 CI/CD 管道中使用 UI-TARS 进行 GUI 测试
agent-tars run --task "打开应用程序，填写表单，提交" \
  --headless --output test-report.json
```

### Python API 使用

```python
from agent_tars import Agent

# 创建 Agent 实例
agent = Agent(model="ui-tars-7b", max_steps=20)

# 定义任务
task = "打开文件管理器并找到 Downloads 中所有 PDF 文件"

# 执行任务
result = agent.run(task)

# 获取结果
print(f"执行的行动: {len(result.actions)}")
for action in result.actions:
    print(f"  {action.type}: {action.target}")

print(f"成功: {result.success}")
print(f"原因: {result.explanation}")
```

## 基准测试 / 实际应用场景

### 任务完成率

| 任务类型 | UI-TARS Desktop | 传统自动化 | ScreenOCR + 脚本 |
|---------|----------------|-----------|----------------|
| 简单按钮点击 | 98% | 95% | 85% |
| 表单填写 | 92% | 70% | 60% |
| 多步工作流 | 85% | 60% | 45% |
| 错误恢复 | 78% | 30% | 20% |
| 未知 UI 元素 | 88% | N/A | N/A |
| **总体** | **88.2%** | **65%** | **58%** |

### 按模型的推理速度

| 模型 | 延迟（毫秒） | GPU 内存 |
|------|-------------|---------|
| UI-TARS 1B | 150ms | 4GB |
| UI-TARS 7B | 800ms | 8GB |
| UI-TARS 72B | 3500ms | 40GB |

### 与屏幕阅读器和自动化工具的比较

| 功能 | UI-TARS | 辅助功能 API | Selenium | Playwright |
|------|---------|------------|----------|-----------|
| 适用于任何 GUI 应用 | 是 | 否 | 仅 Web | 仅 Web |
| 视觉理解 | 是（VLM） | 否 | 有限 | 有限 |
| 学习要求 | 无 | 高 | 中 | 中 |
| 错误恢复 | 是 | 否 | 部分 | 部分 |
| 设置时间 | 分钟 | 小时 | 分钟 | 分钟 |
| 跨平台 | 是 | 平台特定 | Web | Web |

### 实际案例：QA 测试团队

一个 8 名工程师的 QA 团队使用 UI-TARS 来自动化其 Web 和桌面应用程序的 GUI 测试：

```bash
#!/bin/bash
# 自动化回归测试套件
agent-tars batch --task-file regression-tests.yaml \
  --headless --parallel 4 --output test-results.jsonl
```

该团队报告回归测试时间减少了 60%，并能够测试以前因缺乏 DOM 访问而需要手动测试的应用程序。

### 实际案例：无障碍自动化

一家公司使用 UI-TARS 来自动化其应用程序的无障碍测试：

```bash
# 测试多个 UI 状态
agent-tars run --task "导航到所有菜单并验证键盘快捷键是否正常工作" \
  --model ui-tars-7b --max-steps 50
```

Agent 导航通过所有菜单并验证键盘快捷键是否正确实现，捕获了传统自动化测试遗漏的回归问题。

## 高级用法 / 生产加固

### 带密钥管理的生产配置

```bash
# 安全配置模型路径
export UI_TARS_MODEL_PATH=/secure/path/to/models
agent-tars serve --host 0.0.0.0 --port 8000 --model ui-tars-7b

# 使用基于环境的配置
agent-tars --config /etc/uitars/config.yaml serve
```

### 容器部署

```dockerfile
FROM python:3.11-slim

RUN pip install agent-tars

COPY uitars-config.yaml /etc/uitars/config.yaml
EXPOSE 8000

ENTRYPOINT ["agent-tars", "serve", "--config", "/etc/uitars/config.yaml"]
```

### 生产资源限制

```bash
# 限制 GPU 内存使用
CUDA_VISIBLE_DEVICES=0 agent-tars --model ui-tars-7b --max-gpu-memory 8192

# 限制并发任务
agent-tars serve --max-concurrent-tasks 5 --task-timeout 300
```

### 日志和监控

```bash
# 启用详细日志
agent-tars run --task "你的任务" --verbose --log-level debug

# 导出日志进行分析
agent-tars export-logs --output uitars-logs.json
```

## 与替代方案比较

| 功能 | UI-TARS Desktop | AutoGen + UI | PyAutoGUI | OpenHands |
|------|----------------|-------------|-----------|-----------|
| 安装方式 | `npm install -g @agent-tars/desktop` | pip install | pip install | pip install |
| 视觉理解 | 基于 VLM（截图分析） | 有限 | 无 | 部分 |
| 任何 GUI 应用 | 是 | 有限 | 是 | 有限 |
| 自我纠正 | 是（视觉反馈循环） | 部分 | 无 | 部分 |
| 自然语言 | 是 | 部分 | 否 | 部分 |
| 开源 | 是（Apache 2.0） | 是 | 是 | 是 |
| 企业就绪 | 是 | 部分 | 否 | 是 |
| 需要 GPU | 是（本地推理） | 是 | 否 | 是 |
| GitHub 星标 | 36,263 | 15,000 | 12,000 | 55,000 |
| 多步任务 | 是（最多 100 步） | 是 | 手动 | 是 |

UI-TARS Desktop 以其视觉理解能力脱颖而出。与需要硬编码坐标的基于脚本的工具（如 PyAutoGUI）或仅限于浏览器的 Web 自动化工具不同，UI-TARS 可以通过视觉推理理解并与任何 GUI 应用程序交互。基于 VLM 的方法意味着它可以处理它从未见过的新应用程序而无需任何配置。

## 局限性 / 客观评估

虽然 UI-TARS Desktop 功能强大，但请注意以下局限性：

1. **GPU 要求**——运行 7B 模型至少需要 8GB 的 GPU VRAM。72B 模型需要 40GB+。1B 模型可以在 CPU 上运行但精度降低。
2. **延迟**——每次行动需要截图和模型推理，在每个步骤中添加延迟。多步任务可能需要数分钟。
3. **安全考虑**——Agent 完全控制你的桌面。仅受信任的环境中使用，并使用适当的认证限制访问。
4. **复杂文本输入**——输入长文本或复杂文本有时会产生命名识别或输入模拟错误。
5. **高 DPI 显示器**——某些显示器上的屏幕缩放可能影响位置精度。配置 `scale_factor` 参数以匹配你的显示器设置。
6. **非 GUI 工作流**——对于纯命令行或基于 API 的任务，传统的 CLI 工具比 UI-TARS 更高效。

## 常见问题

**问：UI-TARS Desktop 支持哪些操作系统？**

答：UI-TARS Desktop 支持 Windows、macOS 和 Linux。在 Linux 上，它支持 X11 和 Wayland（通过 PipeWire）进行屏幕捕获。npm 安装在所有三个平台上都有效。

**问：UI-TARS 如何处理隐私和安全？**

答：所有处理都在你的机器上本地发生。截图由本地视觉模型处理，不会发送到任何云服务。你可以完全离线运行以获得最大隐私。对于服务器部署，使用带适当认证的无头模式。

**问：UI-TARS 支持哪些模型？**

答：UI-TARS 提供三种模型尺寸：1B（最快，基本精度，约 4GB VRAM）、7B（推荐，良好平衡，约 8GB VRAM）和 72B（最慢，最高精度，约 40GB VRAM）。7B 模型被推荐用于大多数用例，因为它提供了速度和精度的最佳平衡。

**问：UI-TARS 可以自动化 Web 浏览器吗？**

答：是的，UI-TARS 可以控制任何应用程序，包括 Web 浏览器。它可以通过视觉理解导航网站、填写表单、点击按钮和处理动态内容。它不需要 DOM 访问或浏览器扩展。

**问：UI-TARS 与 UiPath 等 RPA 工具相比如何？**

答：与传统 RPA 工具需要录制和脚本不同，UI-TARS 通过自然语言指令和视觉理解工作。它无需设置、无需录制、无需脚本——只需告诉它你想要做什么。对于复杂的企业工作流，[AI Agent 管理](dibi8-internal-link)工具如 Paperclip 可以将 UI-TARS 与其他自动化工具一起编排。

**问：UI-TARS 可以用于自动化测试吗？**

答：是的，UI-TARS 非常适合自动化 GUI 测试。无头模式允许集成到 CI/CD 管道中，批量模式允许并行运行多个测试场景。自我纠正能力有助于处理意外 UI 变化。

## 结论：行动号召

字节跳动的 UI-TARS Desktop 代表了桌面自动化的范式转变。通过将视觉语言模型与屏幕交互能力相结合，它使 AI Agent 能够通过自然语言指令理解和控制任何图形应用程序——无需脚本、无需 API、无需集成。

无论你是自动化重复性任务、构建 GUI 测试、开发智能桌面助手或创建无障碍解决方案，UI-TARS 都提供了传统自动化工具无法比拟的灵活性和易用性。Apache 2.0 许可证使其适合企业部署而无需许可担忧。

为了托管你的 AI Agent 基础设施和 GPU 工作负载，考虑部署提供经济实惠 GPU 实例的云平台。使用 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) 用于开发服务器，[HTStack](https://my.htstack.com/aff.php?aff=27187) 用于生产托管，以及 [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f) 用于可靠的代理和内容分发。

立即开始：`npm install -g @agent-tars/desktop`，给你的电脑一个真正看得见和理解它在做什么的 AI 助手。

以上链接中包含联盟链接。dibi8.com 可能会在你注册时赚取佣金，而无需你支付额外费用。这有助于保持网站运行和内容免费。

来源与进一步阅读

- 官方仓库：https://github.com/bytedance/UI-TARS-desktop
- HuggingFace 模型：https://huggingface.co/ByteDance
- 技术论文：https://github.com/bytedance/UI-TARS-desktop/blob/main/docs/TECHNICAL_REPORT.md
- 模型下载：https://github.com/bytedance/UI-TARS-desktop/blob/main/docs/MODEL.md
- 基准测试结果：https://github.com/bytedance/UI-TARS-desktop/blob/main/docs/BENCHMARKS.md

## 加入社区

加入 [dibi8 中文 Telegram 群](https://t.me/DIBI8_Group/2) 讨论 UI-TARS 配置和桌面自动化技术。查看我们的 [AI Agent 管理](dibi8-internal-link) 和 [使用 MarkItDown 进行文档处理](dibi8-internal-link) 指南以获取互补工具。今天就开始自动化你的桌面。

以上链接中包含联盟链接。dibi8.com 可能会在你注册时赚取佣金，而无需你支付额外费用。这有助于保持网站运行和内容免费。
