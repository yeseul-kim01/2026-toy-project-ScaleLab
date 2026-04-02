#!/usr/bin/env bash
set -euo pipefail

echo "Apply grafana ingress..."
kubectl apply -f infra/ingress/grafana-ingress.yaml

echo "Wait a bit and fetch hostname"
kubectl -n monitoring get ingress grafana-ingress
