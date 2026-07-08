# NeuVector Scan & Zero Trust 実行記録 2026-07-08

このディレクトリは、`rancher-prime-demo-workloads-light` を Rancher Desktop 上の k3s にデプロイし、NeuVector で Image Scan / Discovery / Monitor / Protect を確認した実行記録です。

## 含まれるもの

- `commands.log`: 実行したコマンドと主な結果
- `screenshots/`: NeuVector UI とブラウザ確認画面
- `../../docs/08-neuvector-scan-zero-trust.md`: 教材本文

## 主な結論

- Image Scan により、公開済みイメージのCVEを確認できた。
- Discovery で正常通信とプロセスを学習できた。
- Monitor では未知プロセスが Alert になった。
- Protect では `sh` と `id` が Deny された。
- 一方で、正常通信に使う `curl` は Protect 後も許可された。
- Protect は `kubectl exec` 全体を禁止するものではなく、コンテナ内プロセス単位の許可・拒否である。
