# AWS Runbook (End-to-End)

## 0) Variables

```bash
export AWS_REGION=ap-northeast-2
export AWS_ACCOUNT_ID=<your-account-id>
export ECR_REPO=scalelab-target
export IMAGE_TAG=v0.1.0
export CLUSTER_NAME=scalelab-eks
```

## 1) Build & Push image

```bash
aws ecr create-repository --repository-name $ECR_REPO --region $AWS_REGION || true

aws ecr get-login-password --region $AWS_REGION \
| docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

docker build -t $ECR_REPO:$IMAGE_TAG ./target-service
docker tag $ECR_REPO:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
```

## 2) Deploy app

`infra/k8s/deployment.yaml` 이미지 URI를 먼저 수정한 뒤:

```bash
./scripts/install-metrics-server.sh
./scripts/deploy.sh
```

## 3) Install monitoring

```bash
./scripts/install-monitoring.sh
```

## 4) Expose Grafana at domain

1. `infra/ingress/grafana-ingress.yaml`에서 `YOUR_ACM_CERT_ARN` 치환
2. Ingress 적용

```bash
./scripts/apply-grafana-ingress.sh
```

3. Route53 `A Alias` 레코드 생성
   - Name: `scalelab`
   - Target: ALB DNS

## 5) Verify

```bash
kubectl -n scalelab get deploy,svc,hpa,pods
kubectl -n monitoring get pods,svc,ingress
```

브라우저에서:

- `https://scalelab.yeseulkim.cloud`
