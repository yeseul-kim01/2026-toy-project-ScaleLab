# Domain Setup Guide (`scalelab.yeseulkim.cloud`)

이 문서는 Grafana UI를 도메인으로 노출하기 위한 최소 절차를 설명합니다.

## 1) Prerequisites

- EKS 클러스터 생성 완료
- `kubectl` 컨텍스트 연결 완료
- AWS CLI 인증 완료
- Helm 설치 완료
- Route53에서 `yeseulkim.cloud` hosted zone 보유

## 2) Install Metrics Server (HPA prerequisite)

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl get apiservice v1beta1.metrics.k8s.io
```

## 3) Install Prometheus + Grafana

```bash
./scripts/install-monitoring.sh
```

## 4) Install AWS Load Balancer Controller

ALB Ingress를 사용하려면 controller가 필요합니다.
공식 가이드 순서(IRM/IAM/Helm)대로 설치하세요:

- [AWS EKS - Install AWS Load Balancer Controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)

## 5) Prepare TLS certificate (ACM)

`scalelab.yeseulkim.cloud` 인증서를 ACM에서 발급하고, 아래 파일의 값 치환:

- `infra/ingress/grafana-ingress.yaml`
  - `alb.ingress.kubernetes.io/certificate-arn: YOUR_ACM_CERT_ARN`

## 6) Apply Grafana Ingress

```bash
./scripts/apply-grafana-ingress.sh
```

Ingress의 ADDRESS(또는 ALB DNS)가 생성되면 확인:

```bash
kubectl -n monitoring get ingress grafana-ingress
```

## 7) Route53 record

Route53에서 `A (Alias)` 레코드 생성:

- Name: `scalelab`
- Type: `A - IPv4 address`
- Alias target: 생성된 ALB DNS

## 8) Access

- URL: `https://scalelab.yeseulkim.cloud`
- 기본 계정: `admin` / `changeme-scalelab` (즉시 변경)

## 9) Security hardening (recommended)

- `alb.ingress.kubernetes.io/inbound-cidrs`로 접근 IP 제한
- Grafana strong password + viewer 계정 분리
- 필요 시 Cognito/OIDC 인증 앞단 추가
