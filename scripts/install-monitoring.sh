#!/usr/bin/env bash
set -euo pipefail

echo "[1/4] Add Helm repos"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "[2/4] Ensure monitoring namespace"
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

echo "[3/4] Install kube-prometheus-stack"
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  -f infra/monitoring/grafana-values.yaml

echo "[4/4] Show pods and grafana service"
kubectl -n monitoring get pods
kubectl -n monitoring get svc kube-prometheus-stack-grafana
