#!/usr/bin/env bash
set -euo pipefail

kubectl scale deployment neuvector-controller-pod   -n cattle-neuvector-system   --replicas=1

kubectl scale deployment neuvector-scanner-pod   -n cattle-neuvector-system   --replicas=1

kubectl get deploy -n cattle-neuvector-system
kubectl get pods -n cattle-neuvector-system
