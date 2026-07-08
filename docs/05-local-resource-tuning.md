# 05. Local Resource Tuning for Rancher Desktop

今回の first-contact で最も重要な実践知は、**NeuVector のデフォルト構成は Rancher Desktop の小さいVM設定には重い**という点です。

## 初期状態

当初の Rancher Desktop VM 設定は以下でした。

```json
"virtualMachine": {
  "memoryInGB": 6,
  "numberCPUs": 2,
  "type": "vz",
  "useRosetta": false,
  "mount": {
    "type": "virtiofs"
  }
}
```

この状態で NeuVector をデフォルト構成のまま入れると、次のようになりました。

```text
controller.replicas = 3
cve.scanner.replicas = 3
manager.replicas = 1
enforcer = DaemonSet 1
```

その結果、Manager Pod が OOMKilled になり、Rancher UI から NeuVector Dashboard が 503 / Bad Gateway になりました。

## 安定化方針

まず、ローカル検証では以下の軽量化を行いました。

```yaml
controller:
  replicas: 1

cve:
  scanner:
    replicas: 1
```

ただし、Rancher Desktop の VM メモリが 6GB のままでは、Helm upgrade 中に旧 Pod と新 Pod が重複し、再び OOM が発生しました。

## 最終的な Rancher Desktop 設定

GUI からの変更は `virtualMachine.numberCPUs: <null>` エラーで失敗したため、`rdctl` を使いました。

```bash
rdctl set --virtual-machine.memory-in-gb 16 --virtual-machine.number-cpus 6
```

変更後の確認結果です。

```json
"virtualMachine": {
  "memoryInGB": 16,
  "numberCPUs": 6,
  "type": "vz",
  "useRosetta": false,
  "mount": {
    "type": "virtiofs"
  }
}
```

## 最終的なリソース利用

最終的に、NeuVector が Running になった状態で以下のリソース利用でした。

```text
kubectl top nodes
NAME                   CPU(cores)   CPU(%)   MEMORY(bytes)   MEMORY(%)
lima-rancher-desktop   1028m        17%      9044Mi          56%
```

NeuVector Pod 単位では以下でした。

```text
NAME                                        CPU(cores)   MEMORY(bytes)
neuvector-controller-pod-84757f8b44-97lxl   7m           1939Mi
neuvector-enforcer-pod-phcl7                24m          1041Mi
neuvector-manager-pod-76cdbf54d9-pztbt      4m           665Mi
neuvector-scanner-pod-5d5d6449d4-w6psh      1065m        3322Mi
```

Scanner は初期スキャンや CVE DB 関連処理のため、一時的に大きくなる可能性があります。

## 推奨構成

| 目的 | Memory | CPU |
|---|---:|---:|
| Rancherのみ軽量確認 | 8GB | 4 |
| Rancher + NeuVector | 16GB | 6 |
| Rancher + NeuVector + Observability | 16GB以上 | 6以上 |

今後 Observability を試す場合、Prometheus / Grafana / Alertmanager などが追加されるため、16GB以上を推奨します。
