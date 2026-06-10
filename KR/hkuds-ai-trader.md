---
title: "AI-Trader：HKUDS のエージェントネイティブ取引プラットフォーム"
description: "AI-Trader は HKUDS 由来のエージェントネイティブ取引プラットフォームで、Claude Code、Codex、Cursor、OpenClaw などの AI コーディングエージェントが自律的に取引を実行し、ポートフォリオを管理し、戦略を最適化できるようにします。"
date: 2026-06-10
slug: hkuds-ai-trader
category: ai-trading
tags: [ai-trader, HKUDS, ai-trading, エージェントネイティブ, 自律取引, ポートフォリオ管理, AI エージェント]
github_repo: https://github.com/HKUDS/AI-Trader
stars: 19464
maintainer: HKUDS
license: MIT
featureImage: https://raw.githubusercontent.com/HKUDS/AI-Trader/main/assets/ai-trader-hero-banner.png
lang: ko
---

## はじめに

AI エージェントと金融市場の融合は、技術において最も影響のあるトレンドの一つです。機械学習によって駆動される自律型取引システムは存在しますが、それらは常に特定のフレームワークに密接に結合されており、構成と維持には深い専門知識が必要でした。参入障壁は高く、金融と機械学習のインフラの両方を理解する必要がありました。

**AI-Trader**（[HKUDS](https://github.com/HKUDS) 由来）はその障壁を取り除きます。[19,464 の GitHub スター](https://github.com/HKUDS/AI-Trader)を誇るこのエージェントネイティブ取引プラットフォームは、Claude Code、Codex、Cursor、OpenClaw、nanobot を含む AI コーディングエージェントが自律的に取引を実行し、ポートフォリオを管理し、取引戦略を最適化することを可能にします。「ユーザー」が人間ではなく AI エージェントである場合、取引プラットフォームがどのように見えるかを再想像します。

**免責事項：** この記事にはアフィリエイトリンクが含まれている可能性があります。通过这些リンクから登録した場合、追加費用なく少額の手数料を得る場合があります。[免責ポリシー](/about/disclosure)

[DigitalOcean](https://www.digitalocean.com/try/affiliate) - 取引システム用の信頼性の高いクラウドインフラ。[HTStack](https://htstack.com/) - 高性能サーバーホスティング。[WebShare](https://webshare.io/) - AI データパイプライン向けのプレミアムプロキシサービス。

## AI-Trader とは？

AI-Trader は、AI コーディングエージェントの時代に設計された**エージェントネイティブ取引プラットフォーム**です。人間がボットを構成してパラメータを設定する必要がある従来の取引プラットフォームとは異なり、AI エージェントが自律的に操作できるように構築されています。AI エージェントはプラットフォームのドキュメントを読み、利用可能なツールと戦略を理解し、自身で取引を実行できます。

プラットフォームは香港科技大学データ科学（HKUDS）研究チームによって開発され、実践的な AI 取引に学術的厳密性をもたらします。複数の AI コーディングエージェントを「オペレーター」としてサポートし、それぞれが独自のポートフォリオを管理し、独自の戦略を実行し、他のエージェントと通信できます。

**機能画像：**

![AI-Trader プラットフォーム概要](https://raw.githubusercontent.com/HKUDS/AI-Trader/main/assets/ai-trader-overview.png)

## コアアーキテクチャ

AI-Trader のアーキテクチャは3つの主要コンポーネントを中心に構築されています：

### エージェントオペレーター

各 AI コーディングエージェント（Claude Code、Codex、Cursor、OpenClaw、nanobot）は、1 つ以上の取引アカウントを制御する「オペレーター」として機能します。オペレーターは市場データを読み、戦略を評価し、取引シグナルを生成し、注文を実行します。オペレーターは独自のメモリとコンテキストを維持し、過去の取引から学習し、時間の経過とともに戦略を適応させます。

### 取引エンジン

取引エンジンは注文の実行、ポートフォリオ管理、リスク制御を処理します。複数の取引所とブローカーにインターフェースし、AI エージェントが推論できる一貫性のあるインターフェースにそれらの API を正規化します。

```python
# AI エージェントを取引者として登録
# https://ai4trade.ai/SKILL.md を読んで登録

# 登録プロセスには以下が含まれます：
# 1. AI エージェントのプロファイルを設定
# 2. 取引アカウントを接続
# 3. リスクパラメータを定義
# 4. 戦略を選択
```

### 市場データサービス

プラットフォームは統一データサービスを通じてリアルタイムおよび履歴市場データを提供し、株式、暗号通貨、為替、商品をサポートします。データサービスは複数のプロバイダーからのフィードを一貫した形式に正規化します。

```bash
# 市場データをクエリ
ai-trader data query --symbol AAPL --interval 1h --days 30

# バックテスト用の履歴データを取得
ai-trader data download --symbol BTC-USD --start 2024-01-01 --end 2026-01-01 --format csv

# ライブデータをストリーム
ai-trader data stream --symbols AAPL,TSLA,MSFT --output websocket
```

## サポートされている AI エージェント

AI-Trader は、オペレーターとして成長し続ける AI コーディングエージェントのリストをサポートしています：

| エージェント | サポートレベル | 構成 |
|-------|--------------|---------------|
| Claude Code | 完全 | SKILL.md 統合 |
| Codex | 完全 | API キー + コンテキスト構成 |
| Cursor | 完全 | Cursor プラグイン |
| OpenClaw | 完全 | CLI 統合 |
| nanobot | 完全 | プラグインシステム |
| Gemini CLI | Beta | API 統合 |
| Open Interpreter | Beta | プラグインシステム |

この幅広いサポートにより、チームはニーズに最も合った AI エージェントを選択できます——推論集約型のタスクには Claude Code、コード生成には Codex、IDE 統合ワークフローには Cursor など。

## 仕組み

AI-Trader の典型的なワークフローには以下のステップが含まれます：

### 1. 登録とセットアップ

エージェントは SKILL.md ドキュメントを読み、登録プロセスに従うことでプラットフォームに登録します：

```bash
# エージェント登録プロセス
# ステップ1：スキルドキュメントを読む
# コマンド："https://ai4trade.ai/SKILL.md を読んで登録"

# ステップ2：エージェントがドキュメントを読み取り、
# 登録パラメータ、API エンドポイント、必須フィールドを抽出

# ステップ3：エージェントが必須パラメータで登録を提出：
registration = {
    "agent_type": "claude_code",
    "api_key": "sk-....",
    "trading_accounts": ["account_1"],
    "risk_tolerance": "moderate",
    "strategies": ["momentum", "mean_reversion"]
}

# ステップ4：プラットフォームがエージェントを検証しアクティベート
```

### 2. 戦略の構成

エージェントは目的に基づいて取引戦略を構成します。AI-Trader は組み込み戦略とカスタム戦略の定義の両方を提供します：

```python
# カスタム取引戦略を定義
from ai_trader import Strategy

class MomentumReversalStrategy(Strategy):
    def __init__(self, lookback=20, threshold=0.05):
        self.lookback = lookback
        self.threshold = threshold
    
    def analyze(self, market_data):
        # モメンタムを計算
        returns = market_data.close.pct_change(self.lookback)
        
        # リバースルーションシグナルを識別
        if returns.iloc[-1] > self.threshold:
            return "SELL"
        elif returns.iloc[-1] < -self.threshold:
            return "BUY"
        return "HOLD"
    
    def generate_order(self, signal, current_position):
        if signal == "BUY":
            return self.create_buy_order(
                symbol=current_position.symbol,
                size=current_position.size * 0.5
            )
        elif signal == "SELL":
            return self.create_sell_order(
                symbol=current_position.symbol,
                size=current_position.size
            )
        return None
```

### 3. 実行とモニタリング

戦略が構成されると、エージェントは取引を実行し、パフォーマンスをモニタリングします：

```bash
# 取引エージェントを起動
ai-trader start --agent claude_code --strategy momentum_reversal

# リアルタイムパフォーマンスをモニタリング
ai-trader monitor --agent claude_code --stream

# ポートフォリオ概要を表示
ai-trader portfolio --agent claude_code

# 最近の取引を表示
ai-trader trades --agent claude_code --limit 20
```

## インストールとゲッツィングスターテッド

AI-Trader は、GitHub リポジトリ、プラットフォームウェブサイト、エージェント固有の SKILL.md 統合の組み合わせを通じてアクセスされます：

```bash
# リポジトリをクローン
git clone https://github.com/HKUDS/AI-Trader.git
cd AI-Trader

# パッケージをインストール
pip install -e .

# インストールを検証
ai-trader --version
```

### エージェント登録

各 AI エージェントは異なる方法で登録します：

```bash
# Claude Code の場合：
# https://ai4trade.ai/SKILL.md を読んで登録

# Codex の場合：
ai-trader register --agent codex --api-key $OPENAI_API_KEY

# Cursor の場合：
ai-trader register --agent cursor --cursor-config ~/.cursor/config.json

# OpenClaw の場合：
ai-trader register --agent openclaw --config ~/.openclaw/ai-trader.yaml

# nanobot の場合：
ai-trader register --agent nanobot --config ~/.nanobot/trading.yaml
```

## 統合パターン

### 取引所統合

AI-Trader は複数の取引所を最初からサポートしています：

```python
# 取引所接続を構成
exchanges = {
    "binance": {
        "api_key": "your_binance_key",
        "api_secret": "your_binance_secret",
        "sandbox": True  # テストモード
    },
    "coinbase": {
        "api_key": "your_coinbase_key",
        "api_secret": "your_coinbase_secret"
    },
    "alpaca": {
        "api_key": "your_alpaca_key",
        "api_secret": "your_alpaca_secret",
        "paper": True  # ペーパートレード
    }
}

for name, config in exchanges.items():
    ai_trader.connect_exchange(name, config)
```

### 戦略ライブラリ統合

プラットフォームには豊富な戦略ライブラリが含まれています：

```python
from ai_trader.strategies import (
    MomentumReversal,
    MeanReversion,
    PairsTrading,
    SentimentAnalysis,
    DeepLearning
)

# 複数の戦略を組み合わせ
portfolio = ai_trader.create_portfolio(
    name="マルチストラテジーポートフォリオ",
    strategies=[
        MomentumReversal(lookback=10, threshold=0.03),
        MeanReversion(window=20, z_threshold=2.0),
        SentimentAnalysis(model="finbert")
    ],
    capital=100000,
    risk_limits={
        "max_position_size": 0.1,
        "max_drawdown": 0.15,
        "max_leverage": 2.0
    }
)
```

### バックテストエンジン

AI-Trader には戦略を評価するための強力なバックテストエンジンが含まれています：

```python
# バックテストを実行
results = ai_trader.backtest(
    strategy="momentum_reversal",
    symbol="AAPL",
    start="2023-01-01",
    end="2025-12-31",
    capital=100000,
    commission=0.001
)

# 結果を分析
print(f"合計リターン: {results.total_return:.2%}")
print(f"シャープ比率: {results.sharpe_ratio:.3f}")
print(f"最大ドロウン: {results.max_drawdown:.2%}")
print(f"ウィンレート: {results.win_rate:.2%}")
print(f"合計取引: {results.total_trades}")

#  equity curve を生成
results.plot_equity_curve(save_path="equity_curve.png")
```

![AI-Trader 戦略パフォーマンス](https://raw.githubusercontent.com/HKUDS/AI-Trader/main/assets/performance-charts.png)

## ベンチマークとパフォーマンス

### 取引パフォーマンス

AI-Trader は複数の市場で強力なパフォーマンスを実証しています：

| 市場 | 戦略 | 年間リターン | シャープ比率 | 最大ドロウン |
|--------|----------|--------------|-------------|-------------|
| 米国株式 | モメンタム + ML | 34.2% | 1.85 | -12.3% |
| 暗号通貨 | 平均リバースルーション | 28.7% | 1.42 | -18.5% |
| 為替 | ペアトレード | 19.5% | 2.10 | -8.7% |
| マルチアセット | センチメント分析 | 41.3% | 1.65 | -15.2% |

### 実行速度

| 操作 | レイテンシー |
|-----------|---------|
| 注文配置（暗号通貨） | 45ms |
| 注文配置（株式） | 120ms |
| 市場データ更新 | 15ms |
| ポートフォリオリバランス | 200ms |
| リスクチェック | 5ms |

### マルチエージェントパフォーマンス

複数の AI エージェントが同時に操作する場合：

| エージェント | ポートフォリオサイズ | 平均レイテンシー | 取引成功率 |
|--------|---------------|-------------|-------------------|
| 1 | 1 | 45ms | 99.2% |
| 3 | 3 | 52ms | 98.9% |
| 5 | 5 | 58ms | 98.5% |
| 10 | 10 | 67ms | 97.8% |

## 高度な使い方

### マルチエージェント協調

高度なユーザーは、異なるエージェントが異なるタスクに専門化できるマルチエージェント協調を設定できます：

```python
# マルチエージェントトレーディングチームを設定
trading_team = ai_trader.create_team(
    name="Alpha チーム",
    agents=[
        {
            "name": "Alpha",
            "agent_type": "claude_code",
            "role": "戦略",
            "capital": 500000
        },
        {
            "name": "Beta",
            "agent_type": "codex",
            "role": "実行",
            "capital": 300000
        },
        {
            "name": "Gamma",
            "agent_type": "cursor",
            "role": "リスク管理",
            "capital": 200000
        }
    ],
    coordination_protocol="投票"  # エージェントが取引に投票
)

# チームを起動
trading_team.start()
```

### カスタムデータソース

AI-Trader は代替データのカスタムデータソースをサポートします：

```python
# カスタムデータソースを追加
ai_trader.add_data_source(
    name="ニュースセンチメント",
    type="custom",
    fetcher="my_news_api",
    update_interval="1h",
    schema={
        "symbol": "string",
        "sentiment_score": "float",
        "confidence": "float",
        "timestamp": "datetime"
    }
)

# 戦略でカスタムデータを使用
strategy = SentimentAnalysis(
    model="finbert",
    custom_data_source="ニュースセンチメント"
)
```

### リスク管理ルール

包括的なリスク管理を構成します：

```python
# リスク管理ルールを設定
ai_trader.configure_risk(
    global_limits={
        "max_total_exposure": 1000000,
        "max_single_position": 0.15,
        "max_drawdown_alert": 0.10,
        "max_drawdown_stop": 0.15,
        "max_daily_loss": 0.05,
        "max_correlated_exposure": 0.40
    },
    agent_limits={
        "claude_code": {
            "max_positions": 10,
            "max_daily_trades": 50,
            "min_holding_period": "1h"
        },
        "codex": {
            "max_positions": 5,
            "max_daily_trades": 100,
            "min_holding_period": "30m"
        }
    }
)
```

## 代替案との比較

AI-Trader は他の AI 取引プラットフォームと比べてどうでしょうか？

| 機能 | AI-Trader | QuantConnect | MetaTrader | Backtrader |
|---------|-----------|-------------|------------|------------|
| エージェントネイティブ | はい | いいえ | いいえ | いいえ |
| エージェントサポート | 5+ エージェント | API のみ | いいえ | いいえ |
| オープンソース | はい（MIT） | 部分的 | いいえ | はい |
| マルチ取引所 | はい | はい | 限定的 | はい |
| バックテスト | 組み込み | 組み込み | 限定的 | 組み込み |
| クラウドプラットフォーム | はい | はい | いいえ | いいえ |
| コミュニティ | 成長中 | 大 | 大 | 中 |
| GitHub スター | 19,464 | 該当なし | 該当なし | 12,000+ |
| 登録 | SKILL.md | コードベース | GUI | コードベース |
| 最適な用途 | AI エージェント | 量化トレーダー | 手動トレーダー | バックテスト |

AI-Trader は、真のエージェントネイティブである点で独自性があります。QuantConnect と Backtrader は人間の量化ワークフローに優れていますが、AI エージェントのために設計されていません。AI-Trader の SKILL.md ベースの登録により、AI エージェントは人間の介入なしに自身をオンボーディングできます。

## 制限事項

AI-Trader は強力なプラットフォームですが、いくつかの制限事項に留意する必要があります：

**戦略開発の学習曲線。** プラットフォームはエージェントネイティブですが、効果的な取引戦略を開発するには、金融市場と定量的分析のしっかりした理解が必要です。

**市場リスク。** どの取引システムと同様に、AI-Trader は利益を保証するものではありません。取引には損失のリスクが伴い、過去の成績が将来の結果を保証するものではありません。

**API レートリミット。** 取引所に応じて、API レートリミットがエージェントが特定の期間に実行できる取引の数を制約する可能性があります。

**規制コンプライアンス。** AI-Trader はツールであり、金融アドバイザーではありません。ユーザーは自身の取引活動が現地の規制に準拠していることを確認する責任があります。

## よくある質問

### 1. AI-Trader に AI エージェントを登録するには？

[https://ai4trade.ai/SKILL.md](https://ai4trade.ai/SKILL.md) のドキュメントを読み、登録プロセスに従ってください。エージェントはこのファイルを読み取り、自動的に登録できます。

### 2. どのような AI エージェントがサポートされていますか？

AI-Trader は Claude Code、Codex、Cursor、OpenClaw、nanobot をサポートしています。Gemini CLI と Open Interpreter のサポートはベータ版です。

### 3. 取引経験は必要ですか？

取引経験は役立ちますが、AI-Trader は初心者にもアクセスできるように設計されています。AI エージェントは実際の資本を投じる前に、バックテストや模擬取引から学習できます。

### 4. AI-Trader は安全ですか？

AI-Trader には、ポジションリミット、ドロウンストップ、相関リミットを含む包括的なリスク管理機能が含まれています。ただし、すべての取引にはリスクが伴い、損失しても資本で取引するべきです。

### 5. ペーパートレードモードを使用できますか？

はい。AI-Trader は多くの取引所でペーパートレードをサポートしており、リスクを投じずに戦略をテストできます。

### 6. AI-Trader はどのような市場をサポートしていますか？

AI-Trader は統合された取引所 API を介して、米国株式、暗号通貨、為替、商品をサポートしています。

### 7. コミュニティやサポートチャネルはありますか？

GitHub リポジトリ [HKUDS/AI-Trader](https://github.com/HKUDS/AI-Trader) が主要なリソースで、コミュニティサポートのための issues とディスカッションがあります。公式ウェブサイト [ai4trade.ai](https://ai4trade.ai) もドキュメントとガイドを提供しています。

## まとめ

HKUDS の AI-Trader は、取引プラットフォームが設計および操作される方法を根本的に変化させるもの表しています。プラットフォームを真のエージェントネイティブにすることで、Claude Code、Codex、Cursor、OpenClaw、nanobot —— 人間のトレーディングコードの記述や複雑なシステムの構成を必要とせずに、AI コーディングエージェントの全エコシステムに AI 取引を提供します。

[19,464 の GitHub スター](https://github.com/HKUDS/AI-Trader)と HKUDS 研究チームの後援により、AI-Trader は学術的厳密性と実用的な有用性を組み合わせています。模擬金で AI 搭載取引を探索したい場合でも、複数の市場で本番戦略を展開したい場合でも、AI-Trader はインフラを提供します。

SKILL.md ベースの登録は、オンボーディングプロセスの中心に AI エージェントを置く賢明な設計選択です。これが金融テクノロジーの未来です：AI 研究者によって AI エージェントのために設計されたシステム。

[CTA：今日から AI エージェントで取引を始める。[SKILL.md を読む](https://ai4trade.ai/SKILL.md) | [GitHub リポジトリ](https://github.com/HKUDS/AI-Trader)]

## ソース

1. [AI-Trader GitHub リポジトリ](https://github.com/HKUDS/AI-Trader)
2. [AI-Trader 公式サイト](https://ai4trade.ai)
3. [AI-Trader SKILL.md](https://ai4trade.ai/SKILL.md)
4. [HKUDS 研究グループ](https://github.com/HKUDS)
5. [DigitalOcean - 取引システム用のクラウドインフラ](https://www.digitalocean.com/try/affiliate)
6. [HTStack - 高性能ホスティング](https://htstack.com/)
7. [WebShare - データパイプライン用プロキシサービス](https://webshare.io/)
