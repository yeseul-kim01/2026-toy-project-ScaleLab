#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <ecr-image-uri:tag>"
  exit 1
fi

IMAGE_URI=$1

echo "[1/4] Install metrics server"
./scripts/install-metrics-server.sh

echo "[2/4] Deploy app and HPA"

kubectl apply -f infra/k8s/namespace.yaml

sed "s|YOUR_ECR_IMAGE_URI:latest|${IMAGE_URI}|g" infra/k8s/deployment.yaml | kubectl apply -f -

kubectl apply -f infra/k8s/service.yaml
kubectl apply -f infra/k8s/hpa.yaml

kubectl -n scalelab rollout status deployment/target-service

echo "[3/4] Install monitoring stack"
./scripts/install-monitoring.sh

echo "[4/4] Summary"
kubectl -n scalelab get deploy,svc,hpa,pods
kubectl -n monitoring get pods,svc | rg "grafana|prometheus|NAME"