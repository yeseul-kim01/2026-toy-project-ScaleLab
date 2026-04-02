#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# ScaleLab portfolio one-shot session script
# Fill these values first.
# ------------------------------------------------------------
AWS_REGION="ap-northeast-2"
AWS_ACCOUNT_ID="894831047310"      
CLUSTER_NAME="scalelab-eks"         
ECR_REPO="scalelab"
IMAGE_TAG="v0.1.0"

IMAGE_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"

echo "[0/6] Precheck tools"
for cmd in aws kubectl docker helm eksctl; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Missing command: $cmd"; exit 1; }
done

echo "[1/6] Check AWS identity"
aws sts get-caller-identity >/dev/null

echo "[2/6] Ensure kube context"
aws eks update-kubeconfig --region "${AWS_REGION}" --name "${CLUSTER_NAME}"
kubectl get nodes

echo "[3/6] Build and push image"
aws ecr create-repository --repository-name "${ECR_REPO}" --region "${AWS_REGION}" >/dev/null 2>&1 || true
aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
# buildx 활성화 (없으면 생성)

docker buildx build \
  --platform linux/amd64 \
  -t "${IMAGE_URI}" \
  --push \
  ./target-service


echo "[4/6] Bring up session stack"
./scripts/session-up.sh "${IMAGE_URI}"

echo "[5/6] Start local access commands"
echo "Run these in separate terminals:"
echo "  kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80"
echo "  kubectl -n scalelab port-forward svc/target-service 8080:80"

echo "[6/6] Run experiments"
echo "  ./scripts/run-test.sh steady http://localhost:8080"
echo "  ./scripts/run-test.sh ramp-up http://localhost:8080"
echo "  ./scripts/run-test.sh burst http://localhost:8080"
echo ""
echo "Done. After recording, clean up with:"
echo "  ./scripts/session-down.sh"
echo "  eksctl delete cluster --name ${CLUSTER_NAME} --region ${AWS_REGION}   # optional"
