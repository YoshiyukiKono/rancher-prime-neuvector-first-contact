# 01. NeuVector Overview

NeuVector は、コンテナと Kubernetes ワークロードを対象としたセキュリティプラットフォームです。

この first-contact では、NeuVector を単なる「脆弱性スキャナ」としてではなく、次のような複数の役割を持つプラットフォームとして扱います。

- イメージ脆弱性スキャン
- ランタイムプロセス監視
- ファイルシステム監視
- ネットワーク可視化
- Layer 7 コンテナファイアウォール
- Zero Trust / Zero Drift 的な実行時制御
- Kubernetes Admission Webhook との連携

## なぜ Runtime Security なのか

イメージスキャンだけでは、コンテナが実行された後の挙動は見えません。

例えば、`nginx` イメージが脆弱性スキャン上は比較的安全だったとしても、実行後に以下のようなプロセスが突然動き始めたらどうでしょう。

```text
bash
curl
python
nc
```

このような挙動は、イメージの静的スキャンだけでは検出できません。NeuVector の価値は、実行中のコンテナを監視し、正常な挙動からの逸脱を検知・制御できる点にあります。

## Rancher Prime における位置づけ

Rancher Prime では、NeuVector Extension によって Rancher UI 内に NeuVector の画面が統合されます。ただし、Extension はあくまで UI 統合であり、実際の NeuVector 本体は Helm Chart として Kubernetes クラスタへデプロイされます。

この二段階構成は、このリポジトリの重要な学習ポイントです。
