#!/usr/bin/env bash
set -euo pipefail

echo "[1/4] Create namespace"
kubectl apply -f infra/k8s/namespace.yaml

echo "[2/4] Apply deployment/service/hpa"
kubectl apply -f infra/k8s/deployment.yaml
kubectl apply -f infra/k8s/service.yaml
kubectl apply -f infra/k8s/hpa.yaml

echo "[3/4] Wait for rollout"
kubectl -n scalelab rollout status deployment/target-service

echo "[4/4] Show resources"
kubectl -n scalelab get deploy,svc,hpa,pods
