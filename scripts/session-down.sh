#!/usr/bin/env bash
set -euo pipefail

echo "[1/3] Remove monitoring stack"
helm uninstall kube-prometheus-stack -n monitoring || true
kubectl delete namespace monitoring --ignore-not-found

echo "[2/3] Remove app stack"
./scripts/cleanup.sh

echo "[3/3] Verify remaining resources"
kubectl get ns | rg "scalelab|monitoring" || true

echo "Session resources cleaned. If you use ephemeral clusters, delete EKS cluster too."
