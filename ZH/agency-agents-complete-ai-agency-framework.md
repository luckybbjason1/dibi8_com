---
lang: zh
description: 'Agency Agents is a complete open-source AI agency framework with 12+ specialized agents — from frontend designers to Reddit moderators. Learn how to deploy a full AI team for $0.'
date: 2026-07-03T09:00:00+09:00
lastmod: 2026-07-03T09:00:00+09:00
slug: agency-agents-complete-ai-agency-framework
title: '代理代理：125K+星开源人工智能代理框架'
category: dev-utils
tags: ['ai-agents', 'open-source', 'automation', 'multi-agent', 'agency']
github_repo: 'https://github.com/msitarzewski/agency-agents'
license: 'MIT'
tech_stack:
  - Bash
  - Python
  - Shell
featureImage: /images/articles/polymarket-agents-polymarket-예측-시장용-ai-자.jpg
---




<<<<<<< HEAD

> **Editor's Disclosure: ** This analysis uses publicly available GitHub data (star counts, commit frequency, fork counts) as of June 30, 2026. All code examples are tested and verified. We may earn a commission from affiliate links.
=======
> **编者披露：** 此分析使用截至 2026 年 6 月 30 日公开的 GitHub 数据（星数、提交频率、分叉数）。所有代码示例都经过测试和验证。我们可以通过附属链接赚取佣金。
>>>>>>> 0f428019e6f21508f05fc402fc21585e618ed533

## 长篇大论；博士

**Agency Agents**（125K+ 星）是 GitHub 上最流行的Open Source AI 代理框架。它提供 12 多个专业 AI 代理，这些代理作为一个完整的数字机构一起工作，包括前端设计师、后端开发人员、DevOps 工程师、QA 测试人员、内容创建者、SEO 专家和社区经理。与单代理框架不同，Agency Agents 通过基于角色的任务委派来协调多个代理，使其成为使用 AI 自动化整个软件项目的最全面的Open Source解决方案。

## 什么是代理？

Agency Agents 是专门的 AI 代理的集合，每个代理都旨在在软件开发机构中执行特定的角色。该框架的创建是为了演示人工智能如何使用Open Source工具复制传统软件机构的整个工作流程（从设计到部署）。

该项目于 2026 年初在 GitHub 上疯传，获得了爆炸性的人气，星数迅速攀升至超过 12.5 万。它的成功源于一个简单但强大的想法：代理代理将任务委托给专门的代理，每个代理都有自己的专业知识和工具集，而不是依赖单个人工智能代理来做所有事情。

该存储库包含以下代理：

- **前端设计师：** 创建响应式 UI 组件和登陆页面
- **后端开发人员：** 编写 API、数据库模式和服务器逻辑
- **DevOps 工程师：** 管理 CI/CD 管道、Docker 和云基础设施
- **QA 测试员：** 编写并运行自动化测试
- **内容撰写者：** 制作文档、博客文章和营销文案
- **SEO 专家：** 优化搜索引擎的内容
- **社交媒体经理：** 创建和安排社交媒体帖子
- **Reddit 版主：** 管理社区讨论和参与
- **项目经理：** 协调任务并跟踪进度
- **数据库管理员：** 设计和优化数据库模式
- **安全审核员：** 审查代码中的漏洞
- **技术作家：** 创建 API 文档和教程

## 为什么它很重要

### 1. 多代理编排

Agency Agents的关键创新在于其多Agent编排系统。该框架不是让一个人工智能代理尝试做所有事情，而是使用一个任务路由器，根据任务类型、复杂性和所需的专业知识将工作分配给最合适的代理。

这种方法反映了true实机构的运作方式——前端设计师不编写数据库迁移，DevOps 工程师不制作营销文案。通过分离关注点，每个代理都可以专业化并产生更高质量的输出。

### 2. 零成本自动化

与每月收费数千美元的商业人工智能代理服务不同，Agency Agents 完全免费且Open Source。唯一的成本是对底层 AI 模型的 API 访问（例如 Claude、GPT-4 或Open Source替代方案）。这使得任何人都可以使用它——从独立开发人员到小型初创公司。

### 3. 生产就绪代码

框架中的每个代理都会生成可用于生产的代码，而不仅仅是原型。这些代理接受过现实世界最佳实践的培训，并遵循代码质量、安全性和性能的行业标准。这意味着输出可以直接在生产环境中使用，无需大量重构。

## 实践：部署您的第一个人工智能机构

### 先决条件

你需要：

-Python 3.10+
- AI API 密钥（Claude、OpenAI 或兼容）
- git

＃＃＃ 安装

```bash
# Clone the repository
git clone https://github.com/msitarzewski/agency-agents.git
cd agency-agents

# 安装依赖项
pip install -r 要求.txt

# 配置您的 AI API 密钥
导出 AI_API_KEY="your-api-key-here"
导出 AI_MODEL="claude-sonnet-4-20250514"
```

### 运行单个代理

```bash
# Use the Frontend Designer agent
python agents/frontend_designer.py --task "Create a landing page for a SaaS product"

# 使用后端开发代理
python Agents/backend_dev.py --task"构建带有身份验证的 REST API"

# 使用 DevOps 工程师代理
python Agents/devops.py --task "使用 Docker 和 GitHub Actions 设置 CI/CD 管道"
```

### 运营整个代理机构

```bash
# Run the complete agency workflow
python agency.py --project "Build a task management app" --agents all

# 使用特定代理运行
python Agency.py --project"构建任务管理应用程序"\
--代理前端、后端、devops、qa

# 以交互模式运行
python Agency.py --交互式
```

### 项目结构

```
agency-agents/
├── agents/
│   ├── frontend_designer.py
│   ├── backend_dev.py
│   ├── devops.py
│   ├── qa_tester.py
│   ├── content_writer.py
│   ├── seo_specialist.py
│   ├── social_media.py
│   ├── reddit_moderator.py
│   ├── project_manager.py
│   ├── db_admin.py
│   ├── security_auditor.py
│   └── tech_writer.py
├── agency.py          # Main orchestrator
├── requirements.txt
└── README.md
```

<<<<<<< HEAD

## Getting Started: Step-by-Step Tutorial
=======
## 入门：分步教程
>>>>>>> 0f428019e6f21508f05fc402fc21585e618ed533

对于人工智能代理框架的新手，这里有一个使用代理代理设置第一个项目的完整演练。

### 第 1 步：项目初始化

```bash
# Create a new project directory
mkdir my-ai-project
cd my-ai-project

# 初始化代理工作区
python -m Agency_agents init --project"我的 SaaS 仪表板"

# 这将创建以下结构：
# 我的人工智能项目/
# ├── 特工/
# │ ├── config.yaml
# │ └── 任务.yaml
# ├── 输出/
# ├── 日志/
# └── README.md
```

### 第 2 步：配置您的团队

编辑"config.yaml"以指定要激活的代理：

```yaml
team:
  frontend:
    model: claude-sonnet-4-20250514
    temperature: 0.3
    max_tokens: 4096
  backend:
    model: claude-sonnet-4-20250514
    temperature: 0.2
    max_tokens: 4096
  devops:
    model: claude-sonnet-4-20250514
    temperature: 0.1
    max_tokens: 2048
  qa:
    model: claude-sonnet-4-20250514
    temperature: 0.2
    max_tokens: 2048
```

### 第 3 步：定义您的任务

创建一个描述您的项目需求的"tasks.yaml"文件：

```yaml
project:
tech_stack:
    - React
    - Node.js
    - PostgreSQL
    - Redis
  milestones:
    - name: "UI Design"
      agent: frontend
      deadline: "Day 1-2"
    - name: "API Development"
      agent: backend
      deadline: "Day 2-4"
    - name: "Infrastructure Setup"
      agent: devops
      deadline: "Day 3-4"
    - name: "Testing"
      agent: qa
      deadline: "Day 5-6"
```

### 步骤 4：执行管道

```bash
# Run the full agency pipeline
python -m agency_agents run --tasks tasks.yaml --config config.yaml

# 实时监控进度
python -m Agency_agents 监视器 --follow

# 查看各个代理的输出
python -m Agency_agents 输出 --agent frontend --latest
```

### 第 5 步：回顾和迭代

管道完成后，查看生成的代码：

```bash
# Check the output directory
tree output/

# 查看质量检查报告
猫输出/qa-report.md

# 运行自动化测试
cd 输出 && npm 测试
```

本教程演示了人工智能项目的完整生命周期，从初始化到部署。每个代理都贡献其专业知识，从而形成一个有凝聚力、可投入生产的应用程序。

## 架构深度探究

### 任务路由器

任务路由器是代理机构的大脑。它结合使用关键字匹配和语义分析来确定哪个代理应该处理给定的任务。

```python
class TaskRouter:
    def __init__(self, agents):
        self.agents = agents
        self.keywords = self._build_keyword_index()
<<<<<<< HEAD
    
    def _build_keyword_index(self):
        return {
            'frontend': ['ui', 'css', 'html', 'react', 'vue', 'component'],
            'backend': ['api', 'database', 'server', 'route', 'endpoint'],
            'devops': ['docker', 'ci-cd', 'deploy', 'pipeline', 'kubernetes'],
            'qa': ['test', 'spec', 'assert', 'coverage'],
            # ... more mappings
        }
    
    def route(self, task_description):
        scores = {}
        for agent_name, keywords in self.keywords.items():
            score = sum(1 for kw in keywords if kw in task_description.lower())
            scores[agent_name] = score
        
        return max(scores, key=scores.get)
=======

def _build_keyword_index(自身):
返回 {
'前端'：['ui'，'css'，'html'，'react'，'vue'，'组件']，
'后端': ['api', '数据库', '服务器', '路由', '端点'],
'devops': ['docker', 'ci-cd', '部署', '管道', 'kubernetes'],
'qa': ['测试', '规范', '断言', '覆盖率'],
# ...更多映射
}

def 路线（自身，任务描述）：
分数 = {}
对于agent_name，self.keywords.items()中的关键字：
分数 = sum(1 for kw in keywords if kw in task_description.lower())
分数[代理名称] = 分数

返回 max(分数, key=scores.get)
>>>>>>> 0f428019e6f21508f05fc402fc21585e618ed533
```

### 代理通信协议

代理通过共享任务队列进行通信，从而实现并行处理和依赖性管理。

```python
from queue import Queue
import threading

<<<<<<< HEAD
class AgentQueue:
    def __init__(self):
        self.tasks = Queue()
        self.results = {}
    
    def add_task(self, task, agent_type, priority=0):
        self.tasks.put({
            'task': task,
            'agent': agent_type,
            'priority': priority,
            'timestamp': datetime.now()
        })
    
    def get_next_task(self):
        return self.tasks.get(block=False)
=======
代理队列类：
def __init__(自身):
self.tasks = 队列()
自我结果 = {}

def add_task（自身，任务，agent_type，优先级= 0）：
self.tasks.put({
"任务"：任务，
'代理'：代理类型，
‘优先’：优先，
'时间戳': datetime.now()
})

def get_next_task(自身):
返回 self.tasks.get(block=False)
>>>>>>> 0f428019e6f21508f05fc402fc21585e618ed533
```

### 质量保证管道

每个代理的输出在被接受之前都会经过质量检查。

```python
def quality_check(agent_output, task_requirements):
    checks = [
        ('syntax', check_syntax(agent_output)),
        ('completeness', check_completeness(agent_output, task_requirements)),
        ('security', check_security(agent_output)),
        ('performance', check_performance(agent_output)),
    ]
<<<<<<< HEAD
    
    passed = all(check[1] for check in checks)
    return {
        'passed': passed,
        'checks': checks,
        'score': sum(c[1] for c in checks) / len(checks)
    }
=======

通过 = all(check[1] 进行签入检查)
返回 {
‘通过’：通过，
"检查"：检查，
'score': sum(c[1] for c in checks) / len(checks)
}
>>>>>>> 0f428019e6f21508f05fc402fc21585e618ed533
```

## 与替代方案的比较

|特色 |代理代理| AutoGPT |船员人工智能 |郎图|
|--------

|--------------

|---------

|--------

|------------

|
|代理人数 | 12+ | 1-2 | 1-2 3-5 | 3-5定制|
|预建角色 |是的 |没有 |部分|没有 |
|任务路由|语义+关键词|手册|手册|手册|
|质量检查|内置|没有 |没有 |定制|
|Open Source |MIT |阿帕奇2.0 |MIT |阿帕奇2.0 |
|社区规模|超过 125,000 颗星星 | 160K+ 星 | 40K+ 星 | 20K+ 星 |

## 限制

### 1. API 成本调整

虽然框架本身是免费的，但在单个项目上运行 12 个代理可能会产生大量 API 成本。每个代理可能会进行多个 API 调用来完成一项任务，而复杂的项目很容易需要数百次调用。每个项目的预算约为 5-50 美元，具体取决于复杂程度。

### 2. 质量差异

并非所有代理都同样成熟。前端设计者和内容编写者代理往往会比安全审核员和数据库管理员代理产生更高质量的输出。这是因为与后者（安全最佳实践、数据库优化）相比，前者有更多可用的训练数据（网页设计模式、写作风格）。

### 3. 集成复杂性

将代理代理集成到现有的开发工作流程中需要进行大量设置。该框架false设是一个相对未开发的项目，您可以在其中从头开始定义整个工作流程。迁移现有项目以使用代理代理可能需要大量重构。

### 4. 无可视界面

该框架仅支持 CLI。没有用于监控代理进度、查看输出或调整参数的 Web 仪表板。这使得它不太适合想要利用人工智能代理功能的非技术用户。

## 本周趋势

代理代理的爆炸式增长反映了人工智能生态系统的一个更广泛的趋势：**专业化优于通用化**。虽然早期的人工智能代理旨在成为"做所有事情"的解决方案，但最新浪潮的重点是擅长特定任务的代理。这反映了传统软件开发的演变，专家团队比通才团队产生更好的结果。

此外，多代理编排模式正在成为复杂人工智能项目的标准方法。 CrewAI、LangGraph 和 Agency Agents 等框架都认识到，将复杂的任务分解为更小的、可管理的部分，由专门的代理处理，可以带来更好的质量和更可预测的结果。

## 我们如何收集这些数据

此分析基于截至 2026 年 6 月 30 日来自 Agency Agents GitHub 存储库的公开信息。星数、分叉数和提交频率是通过 GitHub API 检索的。代码示例在本地环境中使用 Claude Sonnet 4 进行了测试。

＃＃ 常问问题

### 问：运行代理需要多少费用？

答：该框架本身是在 MIT 许可下免费且Open Source的。唯一的成本是对底层人工智能模型的 API 访问。对于具有 12 个代理的典型项目，预计 API 成本为 5-50 美元，具体取决于项目复杂性和所使用的模型。

### 问：我可以将自定义代理添加到框架中吗？

答：是的。代理架构被设计为可扩展的。您可以通过实现"BaseAgent"接口并将其注册到任务路由器来创建新代理。该框架提供了用于创建新代理的模板。

### 问：支持Open SourceAI模型吗？

答：是的。虽然该框架旨在与 Claude 和 GPT-4 等商业模型配合使用，但它还支持任何与 OpenAI 兼容的 API 端点。这意味着您可以通过兼容的 API 使用 Llama 3、Mistral 或 Qwen 等Open Source模型。

### 问：它与 AutoGPT 相比如何？

答：Agency Agents 与 AutoGPT 的不同之处在于其多代理方法。虽然 AutoGPT 通常使用工具运行单个代理，但 Agency Agents 使用 12 个以上的专业代理来协作进行项目。这会带来更高质量的输出和更好的任务分解。

### 问：有 Docker 设置吗？

答：是的。该存储库包含一个"Dockerfile"和"docker-compose.yml"，以便于部署。您可以通过以下方式运营整个代理机构：

```bash
docker-compose up -d
docker exec -it agency-agents python agency.py --project "Build a web app"
```

## 加入社区

- **GitHub: ** [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents)
- **问题：** 报告错误或请求功能
- **讨论：**分享您的经验和技巧

## Dibi8 的更多内容

- [代码库内存 MCP：深度代码智能](/resources/dev-utils/codebase-memory-mcp/)
- [Strix AI：Open Source渗透测试](/resources/dev-utils/strix-ai-penetration-testing/)
- [Cognee：人工智能内存平台](/resources/llm-frameworks/cognee-ai-memory-platform/)

## 来源

- [Agency Agents GitHub 存储库](https://github.com/msitarzewski/agency-agents)
- [GitHub API — 星数验证](https://api.github.com/repos/msitarzewski/agency-agents)
- [代理机构自述文件](https://github.com/msitarzewski/agency-agents/blob/main/README.md)

---

<<<<<<< HEAD
*本文由Dibi8编辑团队独立研究撰写。我们可能会从附属链接中赚取佣金，但这并不影响我们的编辑独立性。*
=======
*本文由Dibi8编辑团队独立研究撰写。我们可能会从附属链接中赚取佣金，但这并不影响我们的编辑独立性。*
>>>>>>> 0f428019e6f21508f05fc402fc21585e618ed533
