---
title: 'Alpaca交易API 2026：面向算法交易的零佣金股票经纪API — 设置指南'
description: '零佣金算法交易的Alpaca交易API完整指南。学习设置、下单、WebSocket实时流、碎股交易和模拟交易，附Python代码示例。'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Ai Trading
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/alpacahq/alpaca-trade-api-python'
stars: 4500
maintainer: 'alpacahq'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: ['Alpaca Trading API']
aliases:
- /zh/posts/alpaca-trading-api-stock-broker/
---

{{</* resource-info */>}}

> 📌 **联盟营销披露**：本文包含联盟营销链接。如果您通过我们的链接注册，我们可能会获得佣金——不会给您带来额外费用。我们的评测独立且基于深入研究。
> 
> 🚀 **体验AI驱动交易**：[注册Minara](https://minara.ai/r/OSXG4X) —— AI交易平台，助您零代码构建、回测和部署自动化交易策略。

---

**发布日期：** 2026-05-19 | **类别：** AI交易 | **阅读时间：** 15分钟

---

## 什么是Alpaca交易API？

**Alpaca交易API**是一个面向开发者和算法交易者的零佣金、API优先的经纪平台。Alpaca成立于2015年，总部位于硅谷，已迅速成为构建自动化交易系统最受欢迎的选择之一，拥有超过**700万个API连接账户**，并于2026年1月被BrokerChooser评为**最佳券商第一名**。

与那些将陈旧、过时的API作为附加功能的传统券商不同，Alpaca从一开始就是为开发者设计的。该平台为算法交易提供了完整的生态系统——从模拟交易和回测到实盘执行和投资组合管理——所有功能都通过简洁、文档完善的REST和WebSocket API实现。

Alpaca真正的独特之处在于其**零佣金模式**。您在美国股票和ETF交易上不支付任何佣金，这对于每天执行数十笔甚至数百笔交易的高频策略来说极具成本效益。API免费使用，包括完整的模拟交易环境，这意味着您可以在不支付任何平台费用的情况下开发、测试和部署策略。

| 功能 | 规格 |
|---------|--------------|
| **API类型** | REST API、WebSocket流式传输、FIX API |
| **支持资产** | 美国股票、ETF、期权、加密货币 |
| **SDK语言** | Python、JavaScript/Node.js、Go、C# |
| **佣金** | 美国股票和期权零佣金 |
| **模拟交易** | 功能齐全的沙盒环境，提供100万美元虚拟资金 |
| **系统正常运行时间** | 自2025年1月以来99.99% |
| **订单处理速度** | 平均延迟1.5毫秒 |
| **交易时间** | 每周5天、每天24小时（24/5） |
| **碎股交易** | 支持——按金额投资 |
| **保证金利率** | 6.25% |

---

## 为什么选择Alpaca进行算法交易？

### 零佣金执行

对于算法交易者来说，佣金是盈利能力的隐形杀手。一笔每笔交易产生50美元毛利润的策略，如果每侧支付5-10美元的佣金和费用，就会变得无利可图。Alpaca的零佣金模式完全消除了这个问题，让您可以按照策略需求随意交易，而不会侵蚀收益。

### 开发者优先设计

Alpaca的每个方面都是为开发者构建的。API遵循RESTful约定，使用标准HTTP方法，返回JSON响应。身份验证通过简单的API密钥对处理。文档全面且包含多种语言的交互式代码示例。Webhook支持事件驱动架构，WebSocket API提供实时流式传输，无需轮询开销。

### 与实盘完全一致的模拟交易

Alpaca的模拟交易环境不是一个简化的演示——它是一个功能齐全的沙盒，与生产API完全一致。您可以获得实时市场数据，可以执行所有订单类型，并接收逼真的成交模拟。这意味着为模拟交易编写的代码在切换到实盘交易时无需任何更改——只需更换API端点和凭证即可。

根据2025年Aite-Novarica集团的研究，在实盘部署前至少进行90天模拟测试的算法策略，在第一年实盘交易中显示出**低23%的回撤**。

---

## 入门指南：账户设置和API密钥

### 第一步：创建Alpaca账户

在[alpaca.markets](https://alpaca.markets)注册并完成身份验证流程。您需要提供标准的KYC信息，包括社会安全号码（美国居民）并关联银行账户以进行资金充值。

### 第二步：生成API密钥

账户获批后，导航至模拟交易部分以生成您的第一个API密钥：

```python
# 您的API凭证将如下所示：
API_KEY = 'PKABCDEF1234567890EXAMPLE'
API_SECRET = 'abcdefghijklmnopqrstuvwxyz1234567890example'
BASE_URL = 'https://paper-api.alpaca.markets'  # 模拟交易端点
```

```javascript
// JavaScript/Node.js凭证配置
const API_KEY = 'PKABCDEF1234567890EXAMPLE';
const API_SECRET = 'abcdefghijklmnopqrstuvwxyz1234567890example';
const BASE_URL = 'https://paper-api.alpaca.markets';
```

妥善保管您的密钥——切勿将其提交到版本控制。使用环境变量或密钥管理器：

```python
# 使用环境变量的安全凭证管理
import os
from alpaca_trade_api import REST

api = REST(
    key_id=os.getenv('ALPACA_API_KEY'),
    secret_key=os.getenv('ALPACA_SECRET_KEY'),
    base_url='https://paper-api.alpaca.markets'
)
```

```bash
# .env文件（添加到.gitignore！）
ALPACA_API_KEY=PKABCDEF1234567890EXAMPLE
ALPACA_SECRET_KEY=abcdefghijklmnopqrstuvwxyz1234567890example
```

### 第三步：安装SDK

```bash
# Python SDK
pip install alpaca-trade-api

# JavaScript/Node.js SDK
npm install @alpacahq/alpaca-trade-api

# Go SDK
go get github.com/alpacahq/alpaca-trade-api-go/v3/alpaca
```

---

## 核心交易操作

### 下第一笔订单

Alpaca支持多种订单类型，包括市价单、限价单、止损单、止损限价单和跟踪止损单。以下是每种类型的操作方法：

```python
from alpaca_trade_api import REST
import os

api = REST(
    key_id=os.getenv('ALPACA_API_KEY'),
    secret_key=os.getenv('ALPACA_SECRET_KEY'),
    base_url='https://paper-api.alpaca.markets'
)

# 市价单 —— 以最佳可用价格立即执行
market_order = api.submit_order(
    symbol='AAPL',
    qty=10,
    side='buy',
    type='market',
    time_in_force='day'
)
print(f"市价单已提交: {market_order.id}")
```

```python
# 限价单 —— 仅在指定价格或更优价格执行
limit_order = api.submit_order(
    symbol='TSLA',
    qty=5,
    side='buy',
    type='limit',
    limit_price=180.00,
    time_in_force='gtc'  # 长期有效
)
print(f"限价单已提交: {limit_order.id}")
```

```python
# 止损单 —— 当价格跌至止损价时触发市价卖出
stop_order = api.submit_order(
    symbol='MSFT',
    qty=20,
    side='sell',
    type='stop',
    stop_price=380.00,
    time_in_force='day'
)
```

```python
# 止损限价单 —— 将止损触发与限价执行相结合
stop_limit_order = api.submit_order(
    symbol='GOOGL',
    qty=2,
    side='sell',
    type='stop_limit',
    stop_price=165.00,
    limit_price=164.50,
    time_in_force='day'
)
```

```python
# 跟踪止损单 —— 止损价格跟随市场以设定距离移动
trailing_stop = api.submit_order(
    symbol='AMZN',
    qty=3,
    side='sell',
    type='trailing_stop',
    trail_percent=5.0,  # 5%跟踪距离
    time_in_force='gtc'
)
```

### 碎股交易

Alpaca的突出功能之一是**碎股交易**，它允许您按精确的美元金额投资，而不是购买整股：

```python
# 买入价值500美元的苹果股票 —— 无论股价如何
fractional_order = api.submit_order(
    symbol='AAPL',
    notional=500.00,  # 美元金额而非股数
    side='buy',
    type='market',
    time_in_force='day'
)
```

```python
# 以精确的美元分配构建平衡投资组合
portfolio = {
    'VTI': 2000.00,   # 美国全股票市场
    'VXUS': 1000.00,  # 国际股票
    'BND': 1000.00,   # 美国债券
    'VNQ': 500.00     # 房地产
}

for symbol, amount in portfolio.items():
    order = api.submit_order(
        symbol=symbol,
        notional=amount,
        side='buy',
        type='market',
        time_in_force='day'
    )
    print(f"已下单买入 ${amount} 的 {symbol}")
```

### 延长交易时间（24/5）

Alpaca支持**每周5天、每天24小时交易**，让您可以在常规交易时间（美国东部时间上午9:30 – 下午4:00）之外进行交易：

```python
# 为延长交易时间执行下单
extended_hours_order = api.submit_order(
    symbol='SPY',
    qty=50,
    side='buy',
    type='limit',
    limit_price=520.00,
    time_in_force='day',
    extended_hours=True  # 启用盘前（凌晨4:00）和盘后（晚上8:00）交易
)
```

```python
# 查看某个标的的交易时间
from alpaca_trade_api import REST

api = REST(key_id='YOUR_KEY', secret_key='YOUR_SECRET')
clock = api.get_clock()

print(f"市场{'开盘' if clock.is_open else '收盘'}")
print(f"下次开盘: {clock.next_open}")
print(f"下次收盘: {clock.next_close}")
```

---

## 使用WebSocket进行实时市场数据流式传输

### 设置WebSocket数据流

Alpaca的WebSocket API提供交易、报价和分钟K线的实时流式传输。这对于需要实时响应市场事件的策略至关重要：

```python
import asyncio
from alpaca_trade_api.stream import Stream

# 用于实时数据的WebSocket流式传输
async def handle_trade(t):
    print(f"成交: {t.symbol} @ ${t.price} x {t.size}")

async def handle_quote(q):
    print(f"报价: {q.symbol} 买入: ${q.bid_price} 卖出: ${q.ask_price}")

async def handle_bar(bar):
    print(f"K线: {bar.symbol} 开:{bar.open} 高:{bar.high} 低:{bar.low} 收:{bar.close}")

# 初始化流
stream = Stream(
    key_id='YOUR_API_KEY',
    secret_key='YOUR_SECRET_KEY',
    base_url='https://paper-api.alpaca.markets',
    data_feed='iex'  # 'iex'（免费）或 'sip'（高级）
)

# 订阅频道
stream.subscribe_trades(handle_trade, 'AAPL', 'TSLA', 'MSFT')
stream.subscribe_quotes(handle_quote, 'AAPL', 'TSLA')
stream.subscribe_bars(handle_bar, 'SPY', 'QQQ')

# 运行流
print("启动WebSocket流...")
stream.run()
```

```python
# 用于WebSocket流的异步上下文管理器模式
import asyncio
from alpaca_trade_api.stream import Stream

async def run_streaming_strategy():
    stream = Stream(
        key_id='YOUR_API_KEY',
        secret_key='YOUR_SECRET_KEY',
        data_feed='iex'
    )
    
    async def on_bar(bar):
        # 您的策略逻辑
        if bar.close > bar.vwap * 1.02:
            print(f"潜在突破: {bar.symbol} 在 ${bar.close}")
    
    stream.subscribe_bars(on_bar, 'AAPL', 'MSFT', 'GOOGL', 'AMZN')
    
    # 正确清理运行
    await stream._run_forever()

# asyncio.run(run_streaming_strategy())
```

```javascript
// Node.js WebSocket流式传输
const Alpaca = require('@alpacahq/alpaca-trade-api');

const alpaca = new Alpaca({
    keyId: 'YOUR_API_KEY',
    secretKey: 'YOUR_SECRET_KEY',
    paper: true
});

const client = alpaca.data_ws;

client.onConnect(() => {
    console.log('WebSocket已连接');
    client.subscribe(['alpacadatafeed/T.AAPL', 'alpacadatafeed/T.TSLA']);
});

client.onStockTrade((subject, data) => {
    console.log(`成交: ${data.sym} @ $${data.p} x ${data.s}`);
});

client.connect();
```

---

## 投资组合管理和账户操作

### 查看持仓和账户信息

```python
from alpaca_trade_api import REST
import pandas as pd

api = REST(key_id='YOUR_KEY', secret_key='YOUR_SECRET')

# 获取账户信息
account = api.get_account()
print(f"账户ID: {account.id}")
print(f"投资组合价值: ${account.portfolio_value}")
print(f"现金: ${account.cash}")
print(f"购买力: ${account.buying_power}")
print(f"权益: ${account.equity}")
print(f"当日交易次数: {account.daytrade_count}")
```

```python
# 列出所有当前持仓
positions = api.list_positions()
print(f"持仓数量: {len(positions)}")

for pos in positions:
    print(f"{pos.symbol}: {pos.qty} 股 @ ${pos.avg_entry_price}")
    print(f"  当前: ${pos.current_price} | 盈亏: ${pos.unrealized_pl} ({pos.unrealized_plpc}%)")
```

```python
# 获取特定标的的持仓
aapl_position = api.get_position('AAPL')
print(f"AAPL持仓: {aapl_position.qty} 股")
print(f"市值: ${aapl_position.market_value}")
print(f"未实现盈亏: ${aapl_position.unrealized_pl}")
```

### 订单管理

```python
# 列出所有未成交订单
open_orders = api.list_orders(status='open')
for order in open_orders:
    print(f"订单 {order.id}: {order.side} {order.qty} {order.symbol} @ {order.type}")
```

```python
# 取消特定订单
api.cancel_order('ORDER_ID_HERE')
print("订单已取消")
```

```python
# 取消所有未成交订单
api.cancel_all_orders()
print("所有订单已取消")
```

```python
# 获取订单历史（已成交订单）
closed_orders = api.list_orders(
    status='closed',
    limit=100,
    after='2026-05-01T00:00:00Z'
)

for order in closed_orders:
    print(f"{order.symbol}: {order.side} {order.filled_qty}/{order.qty} @ ${order.filled_avg_price}")
```

---

## 历史数据和回测

### 获取历史K线数据

```python
from alpaca_trade_api import REST
from datetime import datetime, timedelta

api = REST(key_id='YOUR_KEY', secret_key='YOUR_SECRET')

# 获取过去6个月的日K线
end_date = datetime.now()
start_date = end_date - timedelta(days=180)

bars = api.get_bars(
    'AAPL',
    timeframe='1Day',
    start=start_date.isoformat(),
    end=end_date.isoformat(),
    feed='iex'
).df

print(f"获取了 {len(bars)} 根K线")
print(bars.head())
```

```python
# 获取日内策略的分钟K线
minute_bars = api.get_bars(
    'SPY',
    timeframe='1Min',
    start='2026-05-15T09:30:00Z',
    end='2026-05-15T16:00:00Z',
    feed='iex'
).df

# 计算简单移动平均线
minute_bars['SMA_20'] = minute_bars['close'].rolling(20).mean()
minute_bars['SMA_50'] = minute_bars['close'].rolling(50).mean()

# 生成信号
minute_bars['signal'] = 0
minute_bars.loc[minute_bars['SMA_20'] > minute_bars['SMA_50'], 'signal'] = 1
minute_bars.loc[minute_bars['SMA_20'] < minute_bars['SMA_50'], 'signal'] = -1

print(minute_bars[['close', 'SMA_20', 'SMA_50', 'signal']].tail(10))
```

```python
# 高效获取多个标的
import pandas as pd

symbols = ['AAPL', 'MSFT', 'GOOGL', 'AMZN', 'META']
all_bars = {}

for symbol in symbols:
    bars = api.get_bars(
        symbol,
        timeframe='1Day',
        start='2026-01-01T00:00:00Z',
        end='2026-05-19T00:00:00Z',
        feed='iex'
    ).df
    all_bars[symbol] = bars['close']

# 创建包含所有收盘价的DataFrame
prices_df = pd.DataFrame(all_bars)
print(prices_df.head())

# 计算收益率
returns = prices_df.pct_change().dropna()
print("\n日收益率:")
print(returns.head())
```

---

## 构建完整的交易策略

以下是一个结合了上述所有内容的完整**动量交易策略机器人**：

```python
"""
Alpaca动量交易机器人
策略: 当价格伴随成交量确认上穿20周期SMA时买入
"""
import os
import time
import pandas as pd
from alpaca_trade_api import REST, Stream

# 配置
API_KEY = os.getenv('ALPACA_API_KEY')
API_SECRET = os.getenv('ALPACA_SECRET_KEY')
BASE_URL = 'https://paper-api.alpaca.markets'

WATCHLIST = ['AAPL', 'MSFT', 'GOOGL', 'AMZN', 'NVDA']
POSITION_SIZE = 1000  # 每笔交易金额
SMA_PERIOD = 20

class MomentumTrader:
    def __init__(self):
        self.api = REST(key_id=API_KEY, secret_key=API_SECRET, base_url=BASE_URL)
        self.price_history = {s: [] for s in WATCHLIST}
        self.positions_held = set()
    
    def get_sma(self, prices, period):
        """计算简单移动平均线"""
        if len(prices) < period:
            return None
        return sum(prices[-period:]) / period
    
    def check_for_signal(self, symbol, current_price):
        """基于SMA交叉生成买入/卖出信号"""
        self.price_history[symbol].append(current_price)
        
        if len(self.price_history[symbol]) < SMA_PERIOD + 5:
            return None
        
        sma = self.get_sma(self.price_history[symbol], SMA_PERIOD)
        prev_price = self.price_history[symbol][-2]
        prev_sma = self.get_sma(self.price_history[symbol][:-1], SMA_PERIOD)
        
        # 买入信号: 价格上穿SMA
        if prev_price <= prev_sma and current_price > sma:
            if symbol not in self.positions_held:
                return 'buy'
        
        # 卖出信号: 价格下穿SMA
        if prev_price >= prev_sma and current_price < sma:
            if symbol in self.positions_held:
                return 'sell'
        
        return None
    
    def execute_trade(self, symbol, signal):
        """根据信号执行交易"""
        try:
            if signal == 'buy':
                order = self.api.submit_order(
                    symbol=symbol,
                    notional=POSITION_SIZE,
                    side='buy',
                    type='market',
                    time_in_force='day'
                )
                self.positions_held.add(symbol)
                print(f"买入 {symbol}: ${POSITION_SIZE} | 订单ID: {order.id}")
            
            elif signal == 'sell':
                position = self.api.get_position(symbol)
                order = self.api.submit_order(
                    symbol=symbol,
                    qty=position.qty,
                    side='sell',
                    type='market',
                    time_in_force='day'
                )
                self.positions_held.discard(symbol)
                print(f"卖出 {symbol}: {position.qty} 股 | 订单ID: {order.id}")
        
        except Exception as e:
            print(f"{symbol} 交易错误: {e}")
    
    def run(self):
        """使用轮询的主交易循环"""
        print("动量交易器启动...")
        
        while True:
            try:
                clock = self.api.get_clock()
                if not clock.is_open:
                    print(f"市场已收盘。下次开盘: {clock.next_open}")
                    time.sleep(60)
                    continue
                
                for symbol in WATCHLIST:
                    # 获取最新价格
                    bars = self.api.get_latest_bar(symbol)
                    signal = self.check_for_signal(symbol, bars.c)
                    
                    if signal:
                        self.execute_trade(symbol, signal)
                
                time.sleep(60)  # 每分钟检查一次
                
            except Exception as e:
                print(f"主循环错误: {e}")
                time.sleep(60)

if __name__ == '__main__':
    trader = MomentumTrader()
    trader.run()
```

---

## 高级功能和最佳实践

### 使用高级订单类型（OCO、IOC）

通过Alpaca Elite，您可以访问复杂的订单类型：

```python
# 二选一（OCO）括号订单
bracket_order = api.submit_order(
    symbol='TSLA',
    qty=10,
    side='buy',
    type='limit',
    limit_price=200.00,
    time_in_force='gtc',
    order_class='bracket',
    take_profit=dict(limit_price=220.00),
    stop_loss=dict(stop_price=185.00, limit_price=184.50)
)
```

```python
# 立即成交或取消（IOC）订单
ioc_order = api.submit_order(
    symbol='SPY',
    qty=100,
    side='buy',
    type='limit',
    limit_price=520.00,
    time_in_force='ioc'  # 如未立即成交则取消
)
```

### 用于事件驱动交易的Webhook

```python
# 用于外部信号的Flask webhook处理器
from flask import Flask, request, jsonify
from alpaca_trade_api import REST

app = Flask(__name__)
api = REST(key_id='YOUR_KEY', secret_key='YOUR_SECRET')

@app.route('/webhook/trading-signal', methods=['POST'])
def handle_trading_signal():
    data = request.json
    symbol = data.get('symbol')
    signal = data.get('signal')  # 'buy' 或 'sell'
    
    if signal == 'buy':
        order = api.submit_order(
            symbol=symbol,
            notional=1000,
            side='buy',
            type='market',
            time_in_force='day'
        )
        return jsonify({'status': 'success', 'order_id': order.id})
    
    elif signal == 'sell':
        position = api.get_position(symbol)
        order = api.submit_order(
            symbol=symbol,
            qty=position.qty,
            side='sell',
            type='market',
            time_in_force='day'
        )
        return jsonify({'status': 'success', 'order_id': order.id})
    
    return jsonify({'status': 'unknown_signal'}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

---

## 常见问题解答（FAQ）

### Alpaca真的是零佣金吗？

是的，Alpaca为美国股票、ETF和期权提供面向零售客户的零佣金交易。没有每笔交易佣金，没有API访问费，模拟交易环境完全免费。Alpaca通过订单流付款、保证金借贷和高级数据订阅（SIP数据源）产生收入。请注意，某些交易可能仍需支付监管费用。

### Alpaca支持期权交易吗？

是的，截至2026年，Alpaca通过其API支持期权交易。您可以零佣金交易期权以及股票和ETF。但是，期权交易需要审批，与股票交易相比可能有额外要求。Alpaca目前不提供期权流分析——为此，您需要一个互补的平台，如TradeAlgo。

### 我可以在美国以外使用Alpaca吗？

Alpaca面向100多个国家的居民提供美国股票交易服务。但是，某些功能如IRA账户和期权交易可能仅限于拥有有效社会安全号码的美国居民。国际用户应查看Alpaca当前的受支持国家列表以获取最新信息。

### 模拟交易与实盘交易有何不同？

Alpaca的模拟交易环境几乎与生产API完全一致——相同的端点、相同的订单类型、相同的市场数据。主要区别在于：(1) 交易针对模拟撮合引擎执行，而非真实市场；(2) 您从10万美元虚拟资金开始（可升级至100万美元）；(3) 没有真实的财务后果。这使其成为在投入真实资金之前进行策略开发和测试的理想选择。

### Alpaca API的速率限制是什么？

Alpaca实施速率限制以确保公平使用：交易端点每分钟200个请求，市场数据端点每分钟200个请求。WebSocket流式传输API不计入这些限制。对于高频策略，请考虑使用WebSocket API获取实时数据，而不是轮询REST端点。

### Alpaca与Interactive Brokers相比如何？

Alpaca和Interactive Brokers服务于不同的用例。Alpaca是希望拥有现代、零佣金API且易于设置的开发者和算法交易者的理想选择。Interactive Brokers更适合需要访问全球市场、期货、外汇和高级投资组合分析的专业交易者。许多交易者同时使用两者：Alpaca用于美国股票策略，IBKR用于全球多资产交易。

---



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 结论

**Alpaca交易API**代表了算法交易基础设施的范式转变。通过消除佣金、提供开发者优先的API以及提供强大的模拟交易环境，Alpaca使机构级交易工具的获取变得民主化。

无论您是构建简单的定投机器人、复杂的动量策略还是全功能的金融科技应用，Alpaca都提供了成功所需的基础设施。零佣金、碎股交易、24/5延长交易时间以及实时WebSocket流式传输的组合，使其成为2026年算法交易者最具吸引力的平台之一。

对于希望加速进入自动化交易旅程而无需从头编写代码的交易者，我们建议将Alpaca与 **[Minara](https://minara.ai/r/OSXG4X)** 配对使用——这是一个AI驱动的交易平台，可帮助您可视化地构建、回测和部署策略。[立即注册Minara](https://minara.ai/r/OSXG4X)，了解AI如何改变您的交易工作流程。

---

*最后更新：2026-05-19 | Alpaca API版本：v2*
