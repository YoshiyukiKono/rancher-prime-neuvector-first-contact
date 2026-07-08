# 04. Installation Notes

この章では、Rancher Prime UI から NeuVector をインストールした流れを記録します。

## Rancher Server URL の確認（推奨）

NeuVector Prime Extension は、Rancher Server の `server-url` 設定を利用して
Rancher API と連携します。

ローカル環境では、この設定がブラウザ用 URL (`https://rancher.localhost` など)
になっている場合があります。

ブラウザからはアクセスできますが、NeuVector Controller Pod からは
`localhost` は Pod 自身を意味するため、Rancher Server に到達できません。

そのため、Prime Extension をインストールする前に、
`server-url` をクラスタ内部から到達可能な Service URL に設定しておくことを推奨します。

### 現在の設定を確認

```bash
kubectl get settings.management.cattle.io server-url -o yaml
```

例：

```yaml
value: https://rancher.localhost
```

### Service URL に変更

```bash
kubectl patch settings.management.cattle.io server-url \
  --type merge \
  -p '{"value":"https://rancher.cattle-system.svc"}'
```

変更後に確認します。

```bash
kubectl get settings.management.cattle.io server-url -o yaml
```

期待される結果：

```yaml
value: https://rancher.cattle-system.svc
```

---

### NeuVector インストール後の確認

Helm Values に同じ URL が反映されていることを確認します。

```bash
helm -n cattle-neuvector-system get values neuvector -o yaml | grep -A10 cattle
```

期待される結果：

```yaml
global:
  cattle:
    url: https://rancher.cattle-system.svc
```

---

### Controller の接続状態確認

Controller ログに認証エラーが出ていないことを確認します。

```bash
kubectl -n cattle-neuvector-system \
logs deploy/neuvector-controller-pod --tail=100
```

正常時は、

```
OrchConnStatus: connected
```

などのメッセージが表示され、
`Authentication failed` や `connection refused` が出力されないことを確認します。

---

### NeuVector Dashboard の確認

Rancher UI の

```
Cluster
└── NeuVector
    └── Dashboard
```

を開き、

- Dashboard が表示されること
- Security Score が表示されること
- Authentication failed が表示されないこと

を確認します。

### Note

server-url は Rancher UI へブラウザがアクセスする URL とは用途が異なります。
Prime Extension は Controller Pod から Rancher API へ接続するため、クラスタ内部から到達可能な URL を設定することが重要です。ローカル検証環境では https://rancher.cattle-system.svc が適しています。

## 1. NeuVector Extension のインストール

Rancher Prime の `Extensions` 画面で NeuVector を選択します。

![NeuVector extension detail](../assets/screenshots/01-neuvector-extension-detail.png)

Version `2.1.9` を選択してインストールしました。

![Install extension version select](../assets/screenshots/02-install-extension-version-select.png)

インストール後、UI reload が必要になります。

![Reload required](../assets/screenshots/03-extension-installed-reload-required.png)

## 2. NeuVector 本体のインストール

Extension の導入後、左メニューに NeuVector が表示されます。ただし、この時点では本体はまだありません。

![Extension installed but chart not yet](../assets/screenshots/04-extension-installed-but-chart-not-yet.png)

`Install NeuVector` を押すと、Helm Chart のインストール画面に進みます。

### Step 1: Metadata

![Helm metadata](../assets/screenshots/05-helm-install-step1-metadata.png)

今回の Chart は以下でした。

```text
Chart Version: 109.0.3+up2.10.3
NeuVector core image tag: 5.5.3
```

### Step 2: Values

Container images 画面では、Controller / Manager / Enforcer / Scanner / Updater のイメージが確認できます。

![Helm values container images](../assets/screenshots/06-helm-values-container-images.png)

Security Settings では、Manager / Scanner / Updater の runAsUser などが確認できます。

![Helm values security settings](../assets/screenshots/07-helm-values-security-settings.png)

### Step 3: Helm Options

![Helm options](../assets/screenshots/08-helm-options.png)

`Apply custom resource definitions` が有効になっており、CRD が先にインストールされます。

## 3. CRD と本体の2段階インストール

インストールログから、以下の順番で処理されることが分かりました。

```text
1. neuvector-crd をインストール
2. neuvector 本体をインストール
```

![Install operation log](../assets/screenshots/09-install-operation-log.png)

これは Kubernetes における典型的なパターンです。Operator やセキュリティ製品では、先に CustomResourceDefinition を登録し、その後に本体リソースをデプロイすることがよくあります。

## 4. Installed Apps の表示条件

NeuVector は `cattle-neuvector-system` namespace にインストールされます。

Rancher UI の Apps > Installed Apps で `Only User Namespaces` のままだと見えません。`Only System Namespaces` に切り替えると表示されます。

![Installed apps system namespaces](../assets/screenshots/10-installed-apps-system-namespaces.png)
