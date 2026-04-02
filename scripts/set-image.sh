#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <ecr-image-uri:tag>"
  exit 1
fi

IMAGE_URI="$1"
kubectl -n scalelab set image deployment/target-service target-service="${IMAGE_URI}"
kubectl -n scalelab rollout status deployment/target-service
