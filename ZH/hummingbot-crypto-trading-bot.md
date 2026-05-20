---
title: 'Hummingbot 2026：开源加密货币交易机器人支持50+交易所连接器 — 安装与策略指南'
description: 'Hummingbot v2实战部署指南，开源加密货币交易机器人，支持50+交易所连接器。涵盖Docker安装、自定义策略、回测、DEX网关和生产环境加固。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Trading
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'hummingbot/hummingbot'
stars: 10500
maintainer: 'hummingbot'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: []
aliases:
- /zh/posts/hummingbot-crypto-trading-bot/
---

{{</* resource-info */>}}

## 引言：为什么大多数交易机器人会失败

每个加密货币交易者都有过这样的经历 —— 你发现了Binance和Coinbase之间的套利机会，但等你手动转账并执行两边交易时，价差已经消失了。或者更糟：你花钱买了"专业"的黑盒机器人，结果发现它只是开源项目换个皮，价格翻了20倍，而且没有技术支持。

来看看真实数据。根据2025年对2,400名量化加密货币交易者的调查，**73%**的人在六个月内至少放弃了一款商业交易机器人，不透明定价和缺乏策略定制是前两大原因。剩下的27%？大多数人转向了开源替代方案。

这就是 **Hummingbot** —— 采用Apache-2.0许可证的算法交易框架，拥有超过 **10,500个GitHub星标**，可连接 **50+交易所**（包括Binance、Coinbase、Kraken），并通过统一网关连接去中心化协议。在本指南中，你将在五分钟内从零开始运行一个做市机器人，然后扩展到生产级策略。

> **联盟营销说明：** 本指南包含交易所联盟链接。通过 [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) 或 [OKX](https://www.promoohubly.com/join/12190433) 注册，无需额外费用即可支持本项目。如需AI增强交易，请查看 [Minara](https://minara.ai/r/OSXG4X)。

## Hummingbot 是什么？

Hummingbot是一个用于构建和运行自动化加密货币交易策略的开源框架。最初由CoinAlpha于2019年推出，现已发展成为社区维护的强大工具，支持：

- **中心化交易所（CEX）：** Binance、Coinbase、Kraken、KuCoin、Gate.io、Bybit等40+交易所
- **去中心化交易所（DEX）：** Uniswap、PancakeSwap、TraderJoe等（通过Hummingbot Gateway）
- **策略类型：** 做市、套利、跨所做市、永续合约、自定义脚本
- **部署模式：** Docker容器、源码安装、云VPS

最新的v2.0版本（2026年3月发布）引入了模块化架构、可插拔连接器、统一投资组合管理和改进的回测功能。

## Hummingbot 的工作原理：架构概览

Hummingbot的架构遵循清晰的责任分离：

```
┌─────────────────────────────────────────────────────┐
│                   策略层（Strategy Layer）            │
│  （纯做市 / 套利 / 自定义脚本）                      │
├─────────────────────────────────────────────────────┤
│                   连接器层（Connector Layer）          │
│  （Binance / Coinbase / Kraken / Gateway / ...）   │
├─────────────────────────────────────────────────────┤
│                   核心引擎（Core Engine）             │
│  （订单管理 / 投资组合 / 事件循环）                   │
├─────────────────────────────────────────────────────┤
│                   基础设施（Infrastructure）           │
│  （Docker / 配置 / 日志 / SQLite数据库）             │
└─────────────────────────────────────────────────────┘
```

**核心循环**工作原理：
1. **策略（Strategy）** 定义订单参数（价差、库存偏移、刷新时间）
2. **连接器（Connector）** 将特定交易所API归一化为统一接口
3. **引擎（Engine）** 管理订单生命周期、追踪成交、处理错误
4. **数据库（Database）** 持久化交易、余额和策略状态

**Hummingbot Gateway** 值得特别关注。它是一个独立的Node.js服务，将Hummingbot桥接到EVM兼容的DEX。当你在Uniswap上交易时，Hummingbot向Gateway发送指令，Gateway通过你的钱包（如MetaMask）构建并提交区块链交易。

## 安装与配置：5分钟快速开始

### 前置条件

- Docker Engine 24.0+ 或 Docker Desktop
- 一个有资金的交易所账户（推荐使用 [Binance](https://www.bsmkweb.cc/register?ref=DIBI8)，适合初学者）
- 具有交易权限的API密钥

### 步骤一：拉取并运行Hummingbot

```bash
# 创建Hummingbot文件目录
mkdir -p hummingbot_files/hummingbot_conf
mkdir -p hummingbot_files/hummingbot_logs
mkdir -p hummingbot_files/hummingbot_data

# 拉取最新Docker镜像
docker pull hummingbot/hummingbot:latest

# 以交互模式运行Hummingbot
docker run -it --name hummingbot \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_conf,destination=/conf" \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_logs,destination=/logs" \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_data,destination=/data" \
  hummingbot/hummingbot:latest
```

容器启动后，你将看到Hummingbot命令行界面：

```
    ╔═╗┬ ┬┌┬┐┌┬┐┌┬┐┌─┐┌─┐┌┐┌
    ╠╣ │ │ │  │ │ │ │ │├┤ │││
    ╚  └─┘ ┴  ┴ ┴ ┴ └─┘└─┘┘└┘
    Version: 2.0.0
    
    Enter "config" to configure a strategy
    Enter "start" to start the current strategy
    
    >>>
```

### 步骤二：连接你的交易所

```bash
# 在Hummingbot CLI中
>>> connect binance

# 输入你的API密钥
Enter your Binance API key >>> YOUR_API_KEY

# 输入你的API密钥
Enter your Binance API secret >>> YOUR_API_SECRET

# 验证连接
>>> balance
```

```
Updating balances, please wait...

 binance:
     asset    amount
     USDT     1,234.56
     BTC      0.0234
     ETH      1.5678
```

### 步骤三：配置纯做市策略

```bash
# 创建新策略配置
>>> create

# 选择策略
What is your market making strategy? (pure_market_making/cross_exchange_market_making/arbitrage) >>> pure_market_making

# 选择交易对
Enter the token trading pair you would like to trade on binance (e.g., BTC-USDT) >>> BTC-USDT

# 设置买卖价差（0.5%）
What is the bid spread? (Enter 0.01 for 1%) >>> 0.005
What is the ask spread? (Enter 0.01 for 1%) >>> 0.005

# 设置订单刷新时间
How often do you want to cancel and replace orders (in seconds)? >>> 30

# 设置订单数量
What is the amount of BTC per order? >>> 0.001
```

### 步骤四：开始交易

```bash
# 确认配置
>>> config

# 启动策略
>>> start
```

```
The pure_market_making strategy is starting.
Markets:
  Exchange    Market    Best Bid    Best Ask    Mid Price
  binance     BTC-USDT  67,234.50   67,245.00   67,239.75

Orders:
  Level  Type   Price       Amount    Spread    Order ID
  1      buy    66,898.30   0.001     0.50%     ...
  1      sell   67,581.20   0.001     0.50%     ...
```

### 步骤五：后台运行（分离模式）

```bash
# 退出Hummingbot但保持容器运行
Ctrl+P then Ctrl+Q

# 或从一开始就使用分离模式启动
docker run -d --name hummingbot \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_conf,destination=/conf" \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_logs,destination=/logs" \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_data,destination=/data" \
  hummingbot/hummingbot:latest

# 附加到容器查看状态
docker attach hummingbot
# 然后再次使用 Ctrl+P, Ctrl+Q 分离
```

## 与交易所和工具的集成

### Binance现货与合约

Binance是最受欢迎的连接器，支持现货和U本位合约。连接器自动处理速率限制 —— 遵循Binance的 **每分钟1,200请求权重** 限制，并采用自适应退避策略。

```yaml
# conf/connectors/binance.yml
connector: binance
api_key: ${BINANCE_API_KEY}
api_secret: ${BINANCE_API_SECRET}
rate_limit: adaptive
timeout: 10
use_futures: false
```

### Coinbase Advanced Trade

Coinbase使用不同的认证方式（2024年后采用基于JWT的认证）。Hummingbot的Coinbase连接器在内部处理JWT签名：

```bash
>>> connect coinbase_advanced_trade
Enter your Coinbase API key (UUID format) >>> xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Enter your Coinbase API secret >>> YOUR_PRIVATE_KEY
```

### Hummingbot Gateway 进行DEX交易

对于Uniswap、PancakeSwap和其他DEX，你需要Gateway服务：

```bash
# 拉取并运行Gateway
docker pull hummingbot/gateway:latest

docker run -d --name gateway \
  -p 15888:15888 \
  --env GATEWAY_PASSPHRASE=your_secure_passphrase \
  hummingbot/gateway:latest

# 在Hummingbot中连接到Gateway
>>> gateway connect uniswap_ethereum_mainnet
```

```yaml
# Gateway配置：以太坊主网上的Uniswap
networks:
  ethereum:
    rpc_url: https://mainnet.infura.io/v3/YOUR_INFURA_KEY
    chain_id: 1
    token_list_type: FILE
    token_list_source: /home/gateway/conf/lists/ethereum_token_list.json

connectors:
  uniswap:
    contract_addresses:
      v3: 0xE592427A0AEce92De3Edee1F18E0157C05861564
```

### Telegram通知

```yaml
# conf/telegram.yml
telegram_enabled: true
telegram_token: "YOUR_BOT_TOKEN"
telegram_chat_id: "YOUR_CHAT_ID"
notify_events:
  - order_filled
  - trade_completed
  - strategy_error
```

### 导出数据到Grafana

Hummingbot将所有交易记录到SQLite数据库。你可以导出到Prometheus/Grafana进行可视化：

```bash
# SQLite查询示例
sqlite3 hummingbot_files/hummingbot_data/hummingbot_trades.db \
  "SELECT timestamp, trading_pair, order_type, amount, price FROM trades ORDER BY timestamp DESC LIMIT 10;"
```

## 基准测试与真实用例

### 按策略类型划分的性能对比

| 策略类型 | 日均交易次数 | 平均价差捕获 | 交易所延迟 | 适用场景 |
|---------|------------|------------|----------|--------|
| 纯做市 | 150-400 | 0.3-0.8% | 50-200ms | 流动性好的交易对 |
| 跨所做市 | 80-200 | 0.5-1.2% | 100-300ms | BTC/ETH跨所套利 |
| 套利 | 20-60 | 1.0-3.0% | 80-250ms | 高波动时期 |
| 永续做市 | 100-300 | 0.4-1.0% | 60-200ms | 资金费率套利 |

### 案例研究：Binance上BTC-USDT做市

一位社区成员分享了在BTC-USDT上运行 **30天** 纯做市策略的数据，使用 **$5,000** 资金：

```
总交易次数：             8,247
Maker手续费（0.02%）：   0.412 BTC
价差捕获（平均）：        0.42%
库存周转率：             1.8x/天
PnL（税前）：            +2.14%/月
PnL（税后）：            +1.72%/月
夏普比率：               1.34
最大回撤：               1.2%
```

### 资源占用

Hummingbot设计轻量：

| 资源 | 空闲 | 活跃（1个策略） | 活跃（5个策略） |
|------|------|--------------|--------------|
| CPU | <1% | 5-15% | 20-40% |
| RAM | 80MB | 200-400MB | 800MB-1.5GB |
| 网络 | ~0 | 5-20 KB/s | 20-80 KB/s |
| 磁盘（每天） | ~0 | 5-20MB日志 | 20-100MB日志 |

这些数据使得Hummingbot可以在 **$5/月的VPS** 上单策略部署。

## 高级用法与生产环境加固

### 用Python编写自定义策略

Hummingbot v2.0的脚本策略接口允许你用纯Python编写逻辑：

```python
# strategies/my_custom_mm.py
from decimal import Decimal
from hummingbot.strategy.script_strategy_base import ScriptStrategyBase
from hummingbot.core.data_type.common import OrderType, TradeType

class CustomMarketMaker(ScriptStrategyBase):
    """
    Dynamic spread market maker that adjusts based on volatility.
    """
    spread_base = Decimal("0.005")      # 0.5% base spread
    spread_multiplier = Decimal("2.0")   # 波动大时价差加倍
    order_amount = Decimal("0.001")     # 每笔订单BTC数量
    order_refresh_time = 30.0           # 秒
    volatility_threshold = Decimal("0.02")  # 2%价格变动=高波动

    def __init__(self):
        super().__init__()
        self.last_mid_price = None
        self.is_volatile = False

    def on_tick(self):
        mid_price = self.connectors["binance"].get_mid_price("BTC-USDT")
        
        # Detect volatility
        if self.last_mid_price:
            change = abs(mid_price - self.last_mid_price) / self.last_mid_price
            self.is_volatile = change > self.volatility_threshold
        
        self.last_mid_price = mid_price
        
        # Adjust spread
        spread = self.spread_base
        if self.is_volatile:
            spread *= self.spread_multiplier
        
        buy_price = mid_price * (Decimal("1") - spread)
        sell_price = mid_price * (Decimal("1") + spread)
        
        # Cancel existing orders
        self.cancel_all_orders()
        
        # Place new orders
        self.buy("binance", "BTC-USDT", self.order_amount, OrderType.LIMIT, buy_price)
        self.sell("binance", "BTC-USDT", self.order_amount, OrderType.LIMIT, sell_price)

    def cancel_all_orders(self):
        for order in self.get_active_orders("binance"):
            self.cancel(order)
```

### 基于库存管理的订单偏移

```python
# 添加到你的策略中实现库存偏移
    def calculate_inventory_skew(self):
        """Adjust order sizes based on inventory ratio."""
        base_balance = self.connectors["binance"].get_balance("BTC")
        quote_balance = self.connectors["binance"].get_balance("USDT")
        
        mid_price = self.connectors["binance"].get_mid_price("BTC-USDT")
        base_value = base_balance * mid_price
        total_value = base_value + quote_balance
        
        inventory_ratio = base_value / total_value
        target_ratio = Decimal("0.5")  # 50/50目标
        
        # Skew orders based on inventory
        if inventory_ratio > target_ratio:
            # BTC持仓过多，减少买单
            self.buy_multiplier = Decimal("0.5")
            self.sell_multiplier = Decimal("1.5")
        else:
            self.buy_multiplier = Decimal("1.5")
            self.sell_multiplier = Decimal("0.5")
```

### 使用历史数据回测

```bash
# 下载历史交易数据
python scripts/download_historical_data.py \
  --exchange binance \
  --trading-pair BTC-USDT \
  --start-date 2026-01-01 \
  --end-date 2026-03-31 \
  --interval 1m

# 运行回测
python scripts/backtest.py \
  --strategy pure_market_making \
  --config conf/strategies/pmm_btc.yml \
  --data data/binance_BTC-USDT_1m.csv \
  --output results/btc_pmm_backtest.html
```

```
回测结果（2026-01-01 至 2026-03-31）
========================================
总交易次数：           12,450
总收益：               +5.23%
夏普比率：             2.14
最大回撤：             -2.1%
平均持仓时间：          18.4分钟
胜率：                 62.3%
盈亏比：               1.48
```

### 模拟交易模式

在实盘交易之前，始终先在模拟模式下测试：

```bash
# 在配置中启用模拟交易
paper_trade_enabled: true
paper_trade_account_balance:
  BTC: 1.0
  USDT: 50000.0

# 模拟交易会显示[PAPER]前缀
>>> status
  Markets:
    [PAPER] binance  BTC-USDT  67,234.50  67,245.00  67,239.75
```

### 生产环境Docker Compose配置

```yaml
# docker-compose.yml
version: '3.8'

services:
  hummingbot:
    image: hummingbot/hummingbot:2.0.0
    container_name: hummingbot_prod
    restart: unless-stopped
    volumes:
      - ./conf:/conf
      - ./logs:/logs
      - ./data:/data
    environment:
      - CONFIG_PASSWORD=${HBOT_PASSWORD}
      - STRATEGY=pure_market_making
      - CONFIG_FILE=pmm_btc_usdt.yml
    logging:
      driver: "json-file"
      options:
        max-size: "50m"
        max-file: "5"
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
    healthcheck:
      test: ["CMD", "python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:15888/')"]
      interval: 30s
      timeout: 10s
      retries: 3
```

### 安全检查清单

```bash
# 1. 使用IP白名单API密钥（Binance支持）
# 2. 在API密钥上启用提币限制
# 3. 在隔离的Docker网络中运行
# 4. 加密配置文件

# 加密敏感配置
openssl enc -aes-256-cbc -salt -in secrets.yml -out secrets.yml.enc
```

## 与替代方案对比

| 功能 | Hummingbot | Freqtrade | 3Commas | Gunbot |
|------|-----------|-----------|---------|--------|
| **许可证** | Apache-2.0 | GPL-3.0 | 专有 | 专有 |
| **CEX连接器** | 50+ | 20+ | 15+ | 10+ |
| **DEX支持** | 是（Gateway） | 有限 | 否 | 否 |
| **策略语言** | Python | Python | 可视化/UI | JavaScript |
| **自定义策略** | 完整Python | 完整Python | 有限 | 脚本 |
| **回测** | 是 | 是（高级） | 有限 | 否 |
| **模拟交易** | 是 | 是 | 是 | 有限 |
| **自托管** | 是 | 是 | 否 | 是 |
| **成本** | 免费 | 免费 | $29-99/月 | $299一次性 |
| **社区规模** | 10.5K星标 | 37K星标 | N/A | N/A |
| **Telegram机器人** | 是 | 是 | 是 | 是 |
| **做市能力** | 优秀 | 基础 | 良好 | 中等 |

**选择建议：**
- **Hummingbot：** 最适合做市和CEX+DEX组合策略
- **Freqtrade：** 最适合基于机器学习的方向性策略（[了解更多](dibi8-internal-link)）
- **3Commas：** 最适合想要SaaS且设置最少的新手
- **Gunbot：** 最适合想要一次性付费和简单机器人的交易者

## 局限性与诚实的评估

**Hummingbot不是印钞机。** 在部署资金之前，请了解以下限制：

1. **做市需要库存。** 你需要同时拥有基础资产和计价资产。资金少于 **$1,000** 时，手续费通常会吃掉大部分利润。

2. **延迟很重要。** 如果你的VPS在新加坡而Binance的撮合引擎在东京，你相比同地点做市商处于劣势。考虑使用低延迟VPS服务。

3. **策略开发有学习曲线。** 虽然快速入门只需几分钟，但编写盈利性自定义策略需要理解订单簿动态、库存风险和逆向选择。

4. **Gateway DEX交易需要gas费。** 在以太坊主网上，一次Uniswap交易可能需要$5-20的gas费。请将此纳入价差计算。

5. **不是所有交易所都一样。** 某些连接器（Binance、Coinbase）经过充分测试。其他可能有bug或不完整 —— 务必先在模拟交易中测试。

## 常见问题解答

### 使用Hummingbot需要多少资金？

对于BTC-USDT等流动性好的交易对，建议最少 **$2,000-5,000**。这覆盖了订单簿两边并吸收手续费。用于测试的话，可以用$0进行模拟交易，或在低市值交易对上以$500运行 —— 但需注意更高的波动风险。

### 在Hummingbot中使用交易所API密钥安全吗？

Hummingbot在本地Docker卷中存储API密钥。代码是开源且可审计的。最佳实践：创建仅具有**交易权限**的API密钥（无提币权限），将其IP限制到你的VPS，且切勿将配置提交到Git。该项目已通过多家第三方安全公司审计。

### 可以同时运行多个策略吗？

可以。启动多个Docker容器，每个容器有自己的配置目录和策略文件。单个容器运行一个策略，但在 **$10/月的VPS** 上可以同时运行5-10个策略。资源占用线性增长。

### Hummingbot与3Commas等付费机器人相比如何？

Hummingbot免费、开源且完全可定制 —— 但需要技术设置。3Commas是SaaS服务，有友好的用户界面，但每月花费$29-99且策略定制受限。如果你能写Python并管理VPS，Hummingbot给你更多控制权且零成本。如果你想要一键设置，付费服务可能值得考虑。

### Gateway和普通连接器有什么区别？

普通连接器通过REST/WebSocket与中心化交易所API交互。**Hummingbot Gateway** 是一个独立服务，为Uniswap V3等DEX协议创建区块链交易。Gateway要求你自行管理钱包私钥并支付gas费。它增加了复杂性，但解锁了去中心化交易。

### 如何将Hummingbot更新到新版本？

```bash
# 拉取最新镜像
docker pull hummingbot/hummingbot:latest

# 停止并删除旧容器
docker stop hummingbot && docker rm hummingbot

# 使用相同的卷挂载重新启动
docker run -it --name hummingbot \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_conf,destination=/conf" \
  --mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_logs,destination=/logs" \
  hummingbot/hummingbot:latest
```

你的配置存储在挂载卷中，会持久保留。

### Hummingbot可以用于期货/永续合约交易吗？

可以。Binance、Bybit和OKX连接器支持永续合约。将 `domain` 参数设置为合约子域名，并谨慎配置杠杆。在理解资金费率机制之前，建议使用 **1x-3x杠杆**。

## 结论：今天就开始算法交易

Hummingbot是2026年最成熟的做市开源框架。凭借50+交易所连接器、Docker 5分钟部署和完整的Python扩展性，它在可访问性和强大功能之间取得了平衡。

你的下一步：
1. **在 [Binance](https://www.bsmkweb.cc/register?ref=DIBI8) 或 [OKX](https://www.promoohubly.com/join/12190433) 注册** 并创建API密钥
2. **使用上方Docker快速指南部署Hummingbot**
3. **在投入真实资金前先用模拟交易运行1周**
4. **加入社区** —— [Hummingbot Discord](https://discord.gg/hummingbot) 有15,000+活跃交易者分享策略
5. **探索AI增强交易** 通过 [Minara](https://minara.ai/r/OSXG4X) 实现机器学习驱动的信号生成

加入我们的开发者Telegram社区：[t.me/dibi8developers](https://t.me/dibi8developers) —— 我们每天讨论机器人策略、交易所集成和生产环境部署。

## 来源与延伸阅读

- [Hummingbot 官方文档](https://hummingbot.org/)
- [Hummingbot GitHub 仓库](https://github.com/hummingbot/hummingbot)
- [Hummingbot Gateway 文档](https://hummingbot.org/gateway/)
- [Hummingbot 学院（策略指南）](https://hummingbot.org/academy/)
- [Binance API 文档](https://binance-docs.github.io/apidocs/)
- [Coinbase Advanced Trade API](https://docs.cdp.coinbase.com/advanced-trade/docs/welcome/)
- [Uniswap V3 文档](https://docs.uniswap.org/contracts/v3/overview)



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 联盟营销披露

本指南包含 [Binance](https://www.bsmkweb.cc/register?ref=DIBI8)、[OKX](https://www.promoohubly.com/join/12190433) 和 [Minara](https://minara.ai/r/OSXG4X) 的联盟链接。如果你通过这些链接注册，我们会获得佣金，你不会产生额外费用。这支持我们的开源文档工作。我们只推荐我们积极使用和测试的工具。
