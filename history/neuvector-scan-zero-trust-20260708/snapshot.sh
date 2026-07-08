#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="${BASE_DIR}/outputs"
mkdir -p "$OUT"

echo "[snapshot] writing to: $OUT"

date > "$OUT/snapshot-date.txt"

kubectl version > "$OUT/kubectl-version.txt" 2>&1 || true
kubectl config current-context > "$OUT/current-context.txt" 2>&1 || true

kubectl get nodes -o wide > "$OUT/nodes.txt" 2>&1 || true
kubectl get ns > "$OUT/namespaces.txt" 2>&1 || true
kubectl get pods -A -o wide > "$OUT/pods-all.txt" 2>&1 || true

kubectl top nodes > "$OUT/top-nodes.txt" 2>&1 || true
kubectl top pods -A > "$OUT/top-pods-all.txt" 2>&1 || true

kubectl get all -n cattle-neuvector-system > "$OUT/neuvector-all.txt" 2>&1 || true
kubectl get pods -n cattle-neuvector-system -o wide > "$OUT/neuvector-pods.txt" 2>&1 || true
kubectl get deploy -n cattle-neuvector-system > "$OUT/neuvector-deployments.txt" 2>&1 || true
kubectl get ds -n cattle-neuvector-system > "$OUT/neuvector-daemonsets.txt" 2>&1 || true
kubectl top pods -n cattle-neuvector-system > "$OUT/neuvector-top-pods.txt" 2>&1 || true

kubectl get deploy -n cattle-neuvector-system -o yaml > "$OUT/neuvector-deployments.yaml" 2>&1 || true
kubectl get ds -n cattle-neuvector-system -o yaml > "$OUT/neuvector-daemonsets.yaml" 2>&1 || true
kubectl get svc -n cattle-neuvector-system -o yaml > "$OUT/neuvector-services.yaml" 2>&1 || true
kubectl get apps -A | grep neuvector > "$OUT/neuvector-rancher-apps.txt" 2>&1 || true

rdctl list-settings > "$OUT/rancher-desktop-settings.json" 2>&1 || true

echo "[snapshot] done"
