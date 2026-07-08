# 03. NeuVector Architecture

NeuVector は複数のコンポーネントから構成されています。

公式ドキュメントでも、NeuVector security solution は Controllers, Enforcers, Managers, Scanners を持つ構成として説明されています。

## コンポーネント対応

| NeuVector コンポーネント | Kubernetes リソース | 役割 |
|---|---|---|
| Manager | Deployment | Web UI / 管理画面 |
| Controller | Deployment | ポリシー、グループ、状態管理 |
| Enforcer | DaemonSet | 各ノード上のコンテナ監視・ランタイム保護 |
| Scanner | Deployment | イメージ脆弱性スキャン |
| Updater | CronJob | CVE データベース更新 |

## なぜ Enforcer は DaemonSet なのか

Enforcer は Node 上で動作しているコンテナを監視します。そのため、全Nodeに1つずつ配置される必要があります。

```text
Node A
  └─ Enforcer
      ├─ Pod
      ├─ Pod
      └─ Pod

Node B
  └─ Enforcer
      ├─ Pod
      └─ Pod
```

この性質から、Enforcer は Deployment ではなく DaemonSet としてデプロイされます。

## インストール後の実際の状態

今回の最終状態では、次のようになりました。

```text
NAME                       READY   UP-TO-DATE   AVAILABLE
neuvector-controller-pod   1/1     1            1
neuvector-manager-pod      1/1     1            1
neuvector-scanner-pod      1/1     1            1
```

DaemonSet は以下です。

```text
daemonset.apps/neuvector-enforcer-pod   1/1
```

## Updater と cert-upgrader

`kubectl get all -n cattle-neuvector-system` では、以下の CronJob / Job も確認されました。

```text
cronjob.batch/neuvector-cert-upgrader-pod
cronjob.batch/neuvector-updater-pod
job.batch/neuvector-cert-upgrader-job
```

これらは、証明書更新や CVE データ更新に関係する補助的なコンポーネントです。
