#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl rollout status -n kube-system deployment/metrics-server
kubectl get apiservice v1beta1.metrics.k8s.io
