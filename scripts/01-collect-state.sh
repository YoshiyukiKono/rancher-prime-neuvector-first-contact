#!/usr/bin/env bash
set -euo pipefail

mkdir -p outputs manifests

kubectl get nodes -o wide > outputs/nodes.txt
kubectl get pods -A > outputs/pods-all.txt
kubectl get all -n cattle-neuvector-system > outputs/neuvector-all.txt
kubectl get deploy -n cattle-neuvector-system -o yaml > manifests/neuvector-deployments.yaml
kubectl get ds -n cattle-neuvector-system -o yaml > manifests/neuvector-daemonsets.yaml
kubectl get apps -A | grep neuvector > outputs/neuvector-apps.txt || true
rdctl list-settings > outputs/rancher-desktop-settings.json
kubectl top nodes > outputs/top-nodes.txt || true
kubectl top pods -n cattle-neuvector-system > outputs/top-neuvector-pods.txt || true
