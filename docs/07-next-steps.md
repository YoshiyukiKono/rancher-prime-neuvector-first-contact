# 07. Next Steps

NeuVector の導入とリソース安定化が完了したので、次は実際にセキュリティ機能を観察します。

## 1. Dashboard の読み解き

現在の Dashboard では、以下が表示されています。

- Security Score: Fair
- Nodes: 1
- Pods: 20前後
- Service Connection Risk
- Ingress/Egress Exposure Risk
- Vulnerability Exploit Risk
- Critical Run-Time Security Events

まずはこれらの意味を整理します。

## 2. Assets の確認

NeuVector standalone UI で以下を確認します。

- Assets > Containers
- Assets > Nodes
- Assets > Images

どのコンテナが検出されているかを確認します。

## 3. Network Activity

軽いサンプルアプリをデプロイして、通信がどのように見えるか確認します。

候補:

- nginx
- httpbin
- frontend/backend の2層サンプル

## 4. Vulnerability Scan

まずは既存イメージのスキャン結果を確認します。

その後、必要に応じて意図的に古いイメージを使い、脆弱性一覧がどう表示されるか確認します。

## 5. Policy Mode

NeuVector の Policy Mode を理解します。

- Discover
- Monitor
- Protect

最初は Discover のまま観察し、いきなり Protect にしない方が安全です。

## 6. 次のリポジトリへの接続

この first-contact の後は、以下へ接続します。

```text
Protect  : rancher-prime-neuvector-first-contact
Observe  : rancher-prime-observability-first-contact
Govern   : rancher-prime-admission-controller-first-contact
```

Rancher Prime を「クラウドネイティブ運用基盤」として学ぶなら、この3本柱で整理すると見通しが良くなります。
