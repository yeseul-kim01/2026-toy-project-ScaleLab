#!/usr/bin/env bash
set -euo pipefail

kubectl delete -f infra/k8s/hpa.yaml --ignore-not-found
kubectl delete -f infra/k8s/service.yaml --ignore-not-found
kubectl delete -f infra/k8s/deployment.yaml --ignore-not-found
kubectl delete -f infra/k8s/namespace.yaml --ignore-not-found
